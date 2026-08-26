/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
package tests.runtime_product_host_tests

import miniquake2.runtime.product_host as testproducthost

struct FakeWindow
  width
  height
  closed
end struct

struct FakeExports
  Init
  Shutdown
  BeginFrame
  EndFrame
  DrawFadeScreen
  DrawChar
end struct

struct FakeRenderer
  exports
end struct

fakeProductCreates = 0
fakeProductDestroys = 0
fakeProductInits = 0
fakeProductShutdowns = 0
fakeProductFrames = 0
fakeProductCharacters = 0

function fakeProductInit(first, second)
  global fakeProductInits
  fakeProductInits = fakeProductInits + 1
  return true
end function

function fakeProductShutdown()
  global fakeProductShutdowns
  fakeProductShutdowns = fakeProductShutdowns + 1
  return true
end function

function fakeProductBeginFrame(separation)
  return true
end function

function fakeProductEndFrame()
  global fakeProductFrames
  fakeProductFrames = fakeProductFrames + 1
  return true
end function

function fakeProductFade()
  return true
end function

function fakeProductDrawChar(x, y, value)
  global fakeProductCharacters
  fakeProductCharacters = fakeProductCharacters + 1
  return true
end function

function fakeProductCreateWindow(title, width, height, fullScreen)
  global fakeProductCreates
  fakeProductCreates = fakeProductCreates + 1
  return FakeWindow(width, height, false)
end function

function fakeProductDestroyWindow(window)
  global fakeProductDestroys
  fakeProductDestroys = fakeProductDestroys + 1
  window.closed = true
  return true
end function

function fakeProductCreateRenderer(imports, contextActive)
  return FakeRenderer(FakeExports(fakeProductInit, fakeProductShutdown,
    fakeProductBeginFrame, fakeProductEndFrame, fakeProductFade,
    fakeProductDrawChar))
end function

function fakeProductInitRenderer(renderer)
  return renderer.exports.Init(void, void)
end function

function fakeProductShutdownRenderer(renderer)
  return renderer.exports.Shutdown()
end function

function productHostAssert(condition, message)
  if not condition then return error(9936, message) end if
  return true
end function

productHostCallbacks = testproducthost.ProductHostCallbacks(
  fakeProductCreateWindow, fakeProductDestroyWindow, fakeProductCreateRenderer,
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
productHostAssert(productHost.generation == 2 and fakeProductCreates == 1 and
  fakeProductDestroys == 0 and fakeProductInits == 2 and fakeProductShutdowns == 1,
  "renderer reset preserves the native window")
testproducthost.restartProductHost(productHost, "MiniQuake2", 1, true, void)
productHostAssert(productHost.window.width == 800 and productHost.window.height == 600 and
  productHost.fullScreen and productHost.videoMode == 1 and productHost.generation == 3,
  "live video restart applies mode")
productHostAssert(fakeProductCreates == 2 and fakeProductInits == 3 and
  fakeProductDestroys == 1 and fakeProductShutdowns == 2,
  "restart replaces exactly one window and renderer")
testproducthost.restartProductHost(productHost, "MiniQuake2", 7, false, void)
productHostAssert(productHost.window.width == 3840 and
  productHost.window.height == 2160 and not productHost.fullScreen and
  productHost.videoMode == 7 and productHost.generation == 4,
  "4K video restart applies modern mode")
productHostAssert(testproducthost.closeProductHost(productHost), "first close")
productHostAssert(not testproducthost.closeProductHost(productHost), "idempotent close")
productHostAssert(fakeProductDestroys == 3 and fakeProductShutdowns == 4,
  "one final shutdown")

print "runtime_product_host_tests: PASS"
