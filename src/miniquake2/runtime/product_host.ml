/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Shared product window/renderer lifecycle for maps, CIN and PCX media. */
package miniquake2.runtime.product_host

import miniquake2.platform.window as producthostwindow
import miniquake2.platform.gamma as producthostgamma
import miniquake2.renderer.opengl as producthostgl

// Store product host callbacks data.
struct ProductHostCallbacks
  createWindow
  reconfigureWindow
  destroyWindow
  createRenderer
  initRenderer
  shutdownRenderer
end struct

// Store product host data.
struct ProductHost
  callbacks
  window
  renderer
  videoMode
  fullScreen
  generation
  rendererGeneration
  loadingFrames
  closed
  gammaState
end struct

// Create product host window.
function productHostCreateWindow(title, width, height, fullScreen)
  return producthostwindow.create(title, width, height, fullScreen)
end function

// Reconfigure product host window.
function productHostReconfigureWindow(window, width, height, fullScreen)
  return producthostwindow.reconfigure(window, width, height, fullScreen)
end function

// Return the product host destroy window value.
function productHostDestroyWindow(window)
  return producthostwindow.destroy(window)
end function

// Create product host renderer.
function productHostCreateRenderer(imports, contextActive)
  return producthostgl.getRefAPI(imports, contextActive)
end function

// Initialize product host renderer.
function productHostInitRenderer(renderer)
  productHostRendererInit = renderer.exports.Init(void, void)
  if productHostRendererInit is error then return productHostRendererInit end if
  // MiniQuake and the original optional ref_gl path both default alias
  // shadows on. Keep the product default here so every newly created renderer
  // (including a video restart) receives the same behavior.
  producthostgl.setShadows(renderer, true)
  return productHostRendererInit
end function

// Shut down product host renderer.
function productHostShutdownRenderer(renderer)
  return renderer.exports.Shutdown()
end function

// Return the product host default callbacks value.
function productHostDefaultCallbacks()
  return ProductHostCallbacks(productHostCreateWindow,
    productHostReconfigureWindow, productHostDestroyWindow,
    productHostCreateRenderer, productHostInitRenderer,
    productHostShutdownRenderer)
end function

// Return the product host dimensions.
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

// Require product host callbacks.
function productHostRequireCallbacks(callbacks)
  if typeof(callbacks) != "struct" or
      typeof(callbacks.createWindow) != "function" or
      typeof(callbacks.reconfigureWindow) != "function" or
      typeof(callbacks.destroyWindow) != "function" or
      typeof(callbacks.createRenderer) != "function" or
      typeof(callbacks.initRenderer) != "function" or
      typeof(callbacks.shutdownRenderer) != "function" then
    return error(9932, "product host callbacks are incomplete")
  end if
  return callbacks
end function

// Open product host with.
function openProductHostWith(callbacks, title, videoMode, fullScreen, rendererImports)
  productHostCallbacksHolder = productHostRequireCallbacks(callbacks)
  if typeof(title) != "string" or title == "" then
    return error(9933, "product host title is required")
  end if
  if typeof(fullScreen) != "bool" then
    return error(9934, "product fullscreen state must be boolean")
  end if
  productHostDimensionsHolder = productHostDimensions(videoMode)
  productHostWindowResult = try(productHostCallbacksHolder.createWindow(title,
    productHostDimensionsHolder[0], productHostDimensionsHolder[1], fullScreen))
  if productHostWindowResult is error then return productHostWindowResult end if
  productHostWindowHolder = productHostWindowResult
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
    productHostRendererHolder, videoMode, fullScreen, 1, 1, 0, false, void)
end function

// Recreate the last known-good video host after a target mode, context or
// renderer initialization failure.  The native backend owns one window at a
// time, so this rollback is necessarily performed after the old host closes.
function restoreProductHost(host, title, videoMode, fullScreen,
    rendererImports, gamma)
  productHostRestoreDimensions = productHostDimensions(videoMode)
  productHostRestoreCallbacks = host.callbacks
  productHostRestoreWindowResult = try(productHostRestoreCallbacks.createWindow(
    title, productHostRestoreDimensions[0], productHostRestoreDimensions[1],
    fullScreen))
  if productHostRestoreWindowResult is error then
    host.closed = true
    return error(9941, "video rollback window failed: " +
      productHostRestoreWindowResult.message)
  end if
  productHostRestoreWindow = productHostRestoreWindowResult
  productHostRestoreRendererResult = try(productHostRestoreCallbacks.createRenderer(
    rendererImports, true))
  if productHostRestoreRendererResult is error then
    productHostRestoreCallbacks.destroyWindow(productHostRestoreWindow)
    host.closed = true
    return error(9941, "video rollback renderer failed: " +
      productHostRestoreRendererResult.message)
  end if
  productHostRestoreRenderer = productHostRestoreRendererResult
  productHostRestoreInit = try(productHostRestoreCallbacks.initRenderer(
    productHostRestoreRenderer))
  if productHostRestoreInit is error then
    productHostRestoreCallbacks.shutdownRenderer(productHostRestoreRenderer)
    productHostRestoreCallbacks.destroyWindow(productHostRestoreWindow)
    host.closed = true
    return error(9941, "video rollback initialization failed: " +
      productHostRestoreInit.message)
  end if
  host.window = productHostRestoreWindow
  host.renderer = productHostRestoreRenderer
  host.videoMode = videoMode
  host.fullScreen = fullScreen
  host.generation = host.generation + 1
  host.rendererGeneration = host.rendererGeneration + 1
  host.closed = false
  if gamma != 1.0 then applyProductGamma(host, gamma, true) end if
  return true
end function

// Restart product host error.
function productHostRestartError(host, title, rendererImports, oldVideoMode,
    oldFullScreen, gamma, restartFailure)
  productHostRollbackResult = try(restoreProductHost(host, title, oldVideoMode,
    oldFullScreen, rendererImports, gamma))
  if productHostRollbackResult is error then
    return error(9942, restartFailure.message + "; " +
      productHostRollbackResult.message)
  end if
  return error(9943, restartFailure.message +
    "; previous video mode restored")
end function

// Open product host.
function openProductHost(title, videoMode, fullScreen, rendererImports)
  return openProductHostWith(productHostDefaultCallbacks(), title, videoMode,
    fullScreen, rendererImports)
end function

// Draw product host text.
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

// Return the show product loading value.
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

// Restart product host.
function restartProductHost(host, title, videoMode, fullScreen, rendererImports)
  // Keep restart product host phases explicit: validate inputs, update owned state, then publish the result.
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
  productHostRestartOldMode = host.videoMode
  productHostRestartOldFullScreen = host.fullScreen
  productHostRestartGamma = 1.0
  if host.gammaState is not void then
    productHostRestartGamma = host.gammaState.value
    producthostgamma.restore(host.gammaState)
    host.gammaState = void
  end if

  // The common path keeps HWND, HDC, WGL context and renderer resources live.
  // A native failure falls through to the original destroy/recreate rollback
  // path, which remains the last-known-good safety net.
  productHostLiveResult = try(productHostRestartCallbacks.reconfigureWindow(
    host.window, productHostRestartDimensions[0],
    productHostRestartDimensions[1], fullScreen))
  if productHostLiveResult is not error then
    host.window = productHostLiveResult
    host.videoMode = videoMode
    host.fullScreen = fullScreen
    host.generation = host.generation + 1
    if productHostRestartGamma != 1.0 then
      applyProductGamma(host, productHostRestartGamma, true)
    end if
    return true
  end if
  productHostRestartCallbacks.shutdownRenderer(host.renderer)
  productHostRestartCallbacks.destroyWindow(host.window)

  productHostRestartWindowResult = try(productHostRestartCallbacks.createWindow(title,
    productHostRestartDimensions[0], productHostRestartDimensions[1], fullScreen))
  if productHostRestartWindowResult is error then
    return productHostRestartError(host, title, rendererImports,
      productHostRestartOldMode, productHostRestartOldFullScreen,
      productHostRestartGamma, productHostRestartWindowResult)
  end if
  productHostRestartWindow = productHostRestartWindowResult
  productHostRestartRendererResult = try(productHostRestartCallbacks.createRenderer(
    rendererImports, true))
  if productHostRestartRendererResult is error then
    productHostRestartCallbacks.destroyWindow(productHostRestartWindow)
    return productHostRestartError(host, title, rendererImports,
      productHostRestartOldMode, productHostRestartOldFullScreen,
      productHostRestartGamma, productHostRestartRendererResult)
  end if
  productHostRestartRenderer = productHostRestartRendererResult
  productHostRestartInit = try(productHostRestartCallbacks.initRenderer(
    productHostRestartRenderer))
  if productHostRestartInit is error then
    productHostRestartCallbacks.shutdownRenderer(productHostRestartRenderer)
    productHostRestartCallbacks.destroyWindow(productHostRestartWindow)
    return productHostRestartError(host, title, rendererImports,
      productHostRestartOldMode, productHostRestartOldFullScreen,
      productHostRestartGamma, productHostRestartInit)
  end if
  host.window = productHostRestartWindow
  host.renderer = productHostRestartRenderer
  host.videoMode = videoMode
  host.fullScreen = fullScreen
  host.generation = host.generation + 1
  host.rendererGeneration = host.rendererGeneration + 1
  if productHostRestartGamma != 1.0 then
    applyProductGamma(host, productHostRestartGamma, true)
  end if
  return true
end function

// Apply product gamma.
function applyProductGamma(host, gamma, active)
  if typeof(host) != "struct" or host.closed then return false end if
  if host.gammaState is void then host.gammaState = producthostgamma.create() end if
  productHostGammaApplied = active and gamma != 1.0 and gamma != 1
  // This function is sampled every render frame so focus changes take effect
  // immediately. Gamma ramps and pow() are comparatively expensive in
  // MiniLang; do no work while both the requested value and active state are
  // unchanged.
  if host.gammaState.value == gamma and
      host.gammaState.applied == productHostGammaApplied then return true end if
  // SetDeviceGammaRamp is routinely accepted but ignored by DWM/HDR. Retain
  // the original ramp solely for clean restoration and apply the requested
  // value in the renderer, where windowed, borderless and exclusive modes all
  // behave consistently.
  producthostgamma.buildRamp(gamma)
  host.gammaState.value = gamma * 1.0
  host.gammaState.applied = productHostGammaApplied
  productHostRenderGamma = 1.0
  if active then productHostRenderGamma = gamma * 1.0 end if
  return producthostgl.setBrightness(host.renderer, productHostRenderGamma)
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
  host.rendererGeneration = host.rendererGeneration + 1
  return true
end function

// Close product host.
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
