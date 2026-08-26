/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Shared product window/renderer lifecycle for maps, CIN and PCX media. */
package miniquake2.runtime.product_host

import miniquake2.platform.window as producthostwindow
import miniquake2.platform.gamma as producthostgamma
import miniquake2.renderer.opengl as producthostgl

struct ProductHostCallbacks
  createWindow
  destroyWindow
  createRenderer
  initRenderer
  shutdownRenderer
end struct

struct ProductHost
  callbacks
  window
  renderer
  videoMode
  fullScreen
  generation
  loadingFrames
  closed
  gammaState
end struct

function productHostCreateWindow(title, width, height, fullScreen)
  return producthostwindow.create(title, width, height, fullScreen)
end function

function productHostDestroyWindow(window)
  return producthostwindow.destroy(window)
end function

function productHostCreateRenderer(imports, contextActive)
  return producthostgl.getRefAPI(imports, contextActive)
end function

function productHostInitRenderer(renderer)
  return renderer.exports.Init(void, void)
end function

function productHostShutdownRenderer(renderer)
  return renderer.exports.Shutdown()
end function

function productHostDefaultCallbacks()
  return ProductHostCallbacks(productHostCreateWindow, productHostDestroyWindow,
    productHostCreateRenderer, productHostInitRenderer, productHostShutdownRenderer)
end function

function productHostDimensions(videoMode)
  if typeof(videoMode) != "int" or videoMode < 0 or videoMode > 7 then
    return error(9931, "product video mode outside [0,7]")
  end if
  if videoMode == 0 then return [640, 480] end if
  if videoMode == 1 then return [800, 600] end if
  if videoMode == 2 then return [1024, 768] end if
  if videoMode == 3 then return [1280, 720] end if
  if videoMode == 4 then return [1600, 900] end if
  if videoMode == 5 then return [1920, 1080] end if
  if videoMode == 6 then return [2560, 1440] end if
  return [3840, 2160]
end function

function productHostRequireCallbacks(callbacks)
  if typeof(callbacks) != "struct" or
      typeof(callbacks.createWindow) != "function" or
      typeof(callbacks.destroyWindow) != "function" or
      typeof(callbacks.createRenderer) != "function" or
      typeof(callbacks.initRenderer) != "function" or
      typeof(callbacks.shutdownRenderer) != "function" then
    return error(9932, "product host callbacks are incomplete")
  end if
  return callbacks
end function

function openProductHostWith(callbacks, title, videoMode, fullScreen, rendererImports)
  productHostCallbacksHolder = productHostRequireCallbacks(callbacks)
  if typeof(title) != "string" or title == "" then
    return error(9933, "product host title is required")
  end if
  if typeof(fullScreen) != "bool" then
    return error(9934, "product fullscreen state must be boolean")
  end if
  productHostDimensionsHolder = productHostDimensions(videoMode)
  productHostWindowHolder = productHostCallbacksHolder.createWindow(title,
    productHostDimensionsHolder[0], productHostDimensionsHolder[1], fullScreen)
  productHostRendererResult = try(productHostCallbacksHolder.createRenderer(rendererImports, true))
  if productHostRendererResult is error then
    productHostCallbacksHolder.destroyWindow(productHostWindowHolder)
    return productHostRendererResult
  end if
  productHostRendererHolder = productHostRendererResult
  productHostInitResult = try(productHostCallbacksHolder.initRenderer(productHostRendererHolder))
  if productHostInitResult is error then
    productHostCallbacksHolder.shutdownRenderer(productHostRendererHolder)
    productHostCallbacksHolder.destroyWindow(productHostWindowHolder)
    return productHostInitResult
  end if
  return ProductHost(productHostCallbacksHolder, productHostWindowHolder,
    productHostRendererHolder, videoMode, fullScreen, 1, 0, false, void)
end function

function openProductHost(title, videoMode, fullScreen, rendererImports)
  return openProductHostWith(productHostDefaultCallbacks(), title, videoMode,
    fullScreen, rendererImports)
end function

function productHostDrawText(exports, x, y, text)
  productHostTextBytes = bytes(text)
  productHostTextIndex = 0
  while productHostTextIndex < len(productHostTextBytes)
    exports.DrawChar(x + productHostTextIndex * 8, y,
      productHostTextBytes[productHostTextIndex])
    productHostTextIndex = productHostTextIndex + 1
  end while
  return len(productHostTextBytes)
end function

function showProductLoading(host, label)
  if typeof(host) != "struct" or host.closed or host.window.closed then return false end if
  if typeof(label) != "string" then return error(9935, "loading label must be text") end if
  productHostExportsHolder = host.renderer.exports
  productHostExportsHolder.BeginFrame(0.0)
  productHostExportsHolder.DrawFadeScreen()
  productHostLoadingX = host.window.width / 2 - len(bytes(label)) * 4
  productHostLoadingY = host.window.height / 2
  productHostDrawText(productHostExportsHolder, productHostLoadingX, productHostLoadingY, label)
  productHostExportsHolder.EndFrame()
  host.loadingFrames = host.loadingFrames + 1
  return true
end function

function restartProductHost(host, title, videoMode, fullScreen, rendererImports)
  if typeof(host) != "struct" or host.closed then
    return error(9937, "cannot restart a closed product host")
  end if
  if typeof(title) != "string" or title == "" then
    return error(9933, "product host title is required")
  end if
  if typeof(fullScreen) != "bool" then
    return error(9934, "product fullscreen state must be boolean")
  end if
  productHostRestartDimensions = productHostDimensions(videoMode)
  productHostRestartCallbacks = host.callbacks
  productHostRestartGamma = 1.0
  if host.gammaState is not void then
    productHostRestartGamma = host.gammaState.value
    producthostgamma.restore(host.gammaState)
    host.gammaState = void
  end if
  productHostRestartCallbacks.shutdownRenderer(host.renderer)
  productHostRestartCallbacks.destroyWindow(host.window)

  productHostRestartWindowResult = try(productHostRestartCallbacks.createWindow(title,
    productHostRestartDimensions[0], productHostRestartDimensions[1], fullScreen))
  if productHostRestartWindowResult is error then
    host.closed = true
    return productHostRestartWindowResult
  end if
  productHostRestartWindow = productHostRestartWindowResult
  productHostRestartRendererResult = try(productHostRestartCallbacks.createRenderer(
    rendererImports, true))
  if productHostRestartRendererResult is error then
    productHostRestartCallbacks.destroyWindow(productHostRestartWindow)
    host.closed = true
    return productHostRestartRendererResult
  end if
  productHostRestartRenderer = productHostRestartRendererResult
  productHostRestartInit = try(productHostRestartCallbacks.initRenderer(
    productHostRestartRenderer))
  if productHostRestartInit is error then
    productHostRestartCallbacks.shutdownRenderer(productHostRestartRenderer)
    productHostRestartCallbacks.destroyWindow(productHostRestartWindow)
    host.closed = true
    return productHostRestartInit
  end if
  host.window = productHostRestartWindow
  host.renderer = productHostRestartRenderer
  host.videoMode = videoMode
  host.fullScreen = fullScreen
  host.generation = host.generation + 1
  if productHostRestartGamma != 1.0 then
    applyProductGamma(host, productHostRestartGamma, true)
  end if
  return true
end function

function applyProductGamma(host, gamma, active)
  if typeof(host) != "struct" or host.closed then return false end if
  if host.gammaState is void then host.gammaState = producthostgamma.create() end if
  return producthostgamma.update(host.gammaState, gamma, active)
end function

// Rebuild renderer-owned managed state while preserving the native window and
// its OpenGL context. Media chains use this between heavyweight 3D steps.
function resetProductRenderer(host, rendererImports)
  if typeof(host) != "struct" or host.closed then
    return error(9938, "cannot reset renderer on a closed product host")
  end if
  productHostResetCallbacks = host.callbacks
  productHostResetCallbacks.shutdownRenderer(host.renderer)
  productHostResetRendererResult = try(productHostResetCallbacks.createRenderer(
    rendererImports, true))
  if productHostResetRendererResult is error then
    productHostResetCallbacks.destroyWindow(host.window)
    host.closed = true
    return productHostResetRendererResult
  end if
  productHostResetRenderer = productHostResetRendererResult
  productHostResetInit = try(productHostResetCallbacks.initRenderer(
    productHostResetRenderer))
  if productHostResetInit is error then
    productHostResetCallbacks.shutdownRenderer(productHostResetRenderer)
    productHostResetCallbacks.destroyWindow(host.window)
    host.closed = true
    return productHostResetInit
  end if
  host.renderer = productHostResetRenderer
  host.generation = host.generation + 1
  return true
end function

function closeProductHost(host)
  if typeof(host) != "struct" or host.closed then return false end if
  if host.gammaState is not void then
    producthostgamma.restore(host.gammaState)
    host.gammaState = void
  end if
  host.callbacks.shutdownRenderer(host.renderer)
  host.callbacks.destroyWindow(host.window)
  host.closed = true
  return true
end function
