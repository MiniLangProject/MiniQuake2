/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
package tests.runtime_product_host_tests

import miniquake2.runtime.product_host as testproducthost

// Store fake window data.
struct FakeWindow
  width
  height
  closed
end struct

// Store fake exports data.
struct FakeExports
  Init
  Shutdown
  BeginFrame
  EndFrame
  DrawFadeScreen
  DrawChar
end struct

// Store fake renderer data.
struct FakeRenderer
  exports
end struct

fakeProductCreates = 0
fakeProductDestroys = 0
fakeProductInits = 0
fakeProductShutdowns = 0
fakeProductFrames = 0
fakeProductCharacters = 0
fakeProductFailNextCreate = false
fakeProductReconfigures = 0
fakeProductFailNextReconfigure = false

// Initialize fake product.
function fakeProductInit(first, second)
  global fakeProductInits
  fakeProductInits = fakeProductInits + 1
  return true
end function

// Shut down fake product.
function fakeProductShutdown()
  global fakeProductShutdowns
  fakeProductShutdowns = fakeProductShutdowns + 1
  return true
end function

// Begin fake product frame.
function fakeProductBeginFrame(separation)
  return true
end function

// End fake product frame.
function fakeProductEndFrame()
  global fakeProductFrames
  fakeProductFrames = fakeProductFrames + 1
  return true
end function

// Return the fake product fade value.
function fakeProductFade()
  return true
end function

// Draw fake product char.
function fakeProductDrawChar(x, y, value)
  global fakeProductCharacters
  fakeProductCharacters = fakeProductCharacters + 1
  return true
end function

// Create fake product window.
function fakeProductCreateWindow(title, width, height, fullScreen)
  global fakeProductCreates, fakeProductFailNextCreate
  fakeProductCreates = fakeProductCreates + 1
  if fakeProductFailNextCreate then
    fakeProductFailNextCreate = false
    return error(9944, "injected window failure")
  end if
  return FakeWindow(width, height, false)
end function

// Reconfigure fake product window.
function fakeProductReconfigureWindow(window, width, height, fullScreen)
  global fakeProductReconfigures, fakeProductFailNextReconfigure
  fakeProductReconfigures = fakeProductReconfigures + 1
  if fakeProductFailNextReconfigure then
    fakeProductFailNextReconfigure = false
    return error(9944, "injected live reconfigure failure")
  end if
  window.width = width
  window.height = height
  return window
end function

// Return the fake product destroy window value.
function fakeProductDestroyWindow(window)
  global fakeProductDestroys
  fakeProductDestroys = fakeProductDestroys + 1
  window.closed = true
  return true
end function

// Create fake product renderer.
function fakeProductCreateRenderer(imports, contextActive)
  return FakeRenderer(FakeExports(fakeProductInit, fakeProductShutdown,
    fakeProductBeginFrame, fakeProductEndFrame, fakeProductFade,
    fakeProductDrawChar))
end function

// Initialize fake product renderer.
function fakeProductInitRenderer(renderer)
  return renderer.exports.Init(void, void)
end function

// Shut down fake product renderer.
function fakeProductShutdownRenderer(renderer)
  return renderer.exports.Shutdown()
end function

// Assert the product host test condition.
function productHostAssert(condition, message)
  if not condition then return error(9936, message) end if
  return true
end function

productHostCallbacks = testproducthost.ProductHostCallbacks(
  fakeProductCreateWindow, fakeProductReconfigureWindow,
  fakeProductDestroyWindow, fakeProductCreateRenderer,
  fakeProductInitRenderer, fakeProductShutdownRenderer)
productHost = testproducthost.openProductHostWith(productHostCallbacks,
  "MiniQuake2", 3, false, void)
productHostAssert(productHost.window.width == 1280 and productHost.window.height == 720,
  "video mode dimensions")
productHostAssert(productHost.generation == 1 and not productHost.closed,
  "host starts active")
testproducthost.showProductLoading(productHost, "loading base1")
testproducthost.showProductLoading(productHost, "loading end.cin")
productHostAssert(fakeProductCreates == 1 and fakeProductInits == 1,
  "one window and renderer shared across media")
productHostAssert(fakeProductFrames == 2 and productHost.loadingFrames == 2 and
  fakeProductCharacters == len(bytes("loading base1")) + len(bytes("loading end.cin")),
  "loading plaque frames")
testproducthost.resetProductRenderer(productHost, void)
productHostAssert(productHost.generation == 2 and
  productHost.rendererGeneration == 2 and fakeProductCreates == 1 and
  fakeProductDestroys == 0 and fakeProductInits == 2 and fakeProductShutdowns == 1,
  "renderer reset preserves the native window")
testproducthost.restartProductHost(productHost, "MiniQuake2", 1, true, void)
productHostAssert(productHost.window.width == 800 and productHost.window.height == 600 and
  productHost.fullScreen and productHost.videoMode == 1 and
  productHost.generation == 3 and productHost.rendererGeneration == 2,
  "live video restart applies mode")
productHostAssert(fakeProductReconfigures == 1 and fakeProductCreates == 1 and
  fakeProductInits == 2 and fakeProductDestroys == 0 and
  fakeProductShutdowns == 1,
  "live restart preserves window and renderer")
testproducthost.restartProductHost(productHost, "MiniQuake2", 7, false, void)
productHostAssert(productHost.window.width == 3840 and
  productHost.window.height == 2160 and not productHost.fullScreen and
  productHost.videoMode == 7 and productHost.generation == 4,
  "4K video restart applies modern mode")
fakeProductFailNextReconfigure = true
fakeProductFailNextCreate = true
failedProductRestart = try(testproducthost.restartProductHost(productHost,
  "MiniQuake2", 5, true, void))
productHostAssert(failedProductRestart is error and not productHost.closed and
  productHost.videoMode == 7 and not productHost.fullScreen and
  productHost.window.width == 3840 and productHost.window.height == 2160 and
  not productHost.window.closed and productHost.generation == 5 and
  productHost.rendererGeneration == 3,
  "failed video restart restores the last known-good host")
productHostAssert(testproducthost.closeProductHost(productHost), "first close")
productHostAssert(not testproducthost.closeProductHost(productHost), "idempotent close")
productHostAssert(fakeProductReconfigures == 3 and fakeProductDestroys == 2 and
  fakeProductShutdowns == 3,
  "one final shutdown")

print "runtime_product_host_tests: PASS"
