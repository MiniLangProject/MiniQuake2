//! Provides miniquake2 platform window facilities for this project.

/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Win32 window/input lifecycle. Rendering is kept behind renderer API v3. */
package miniquake2.platform.window

import miniquake2.native as native

/// Store window data.
struct Window
  /// Stores the handle value associated with window.
  handle
  /// Stores the width value associated with window.
  width
  /// Stores the height value associated with window.
  height
  /// Stores the fullscreen value associated with window.
  fullscreen
  /// Stores the closed value associated with window.
  closed
  /// Stores the vertical sync value associated with window.
  verticalSync
end struct

/// Store input event data.
struct InputEvent
  /// Stores the type value associated with input event.
  type
  /// Stores the code value associated with input event.
  code
  /// Stores the value value associated with input event.
  value
end struct

/// Resolve a fixed Quake II menu mode to a mode the active monitor can safely
/// display. The third value selects the native "use current display mode"
/// borderless fallback.
/// @param width Width in the coordinate or storage units used by the caller.
/// @param height Height in the coordinate or storage units used by the caller.
/// @param fullscreen fullscreen value consumed by this operation.
/// @param exclusiveAvailable exclusiveAvailable value consumed by this operation.
/// @param desktopWidth desktopWidth value consumed by this operation.
/// @param desktopHeight desktopHeight value consumed by this operation.
function resolvedDisplayMode(width, height, fullscreen, exclusiveAvailable,
    desktopWidth, desktopHeight)
  if width <= 0 or height <= 0 then return error(2920, "invalid window dimensions") end if
  if fullscreen and not exclusiveAvailable then
    if desktopWidth <= 0 or desktopHeight <= 0 then
      return error(2923, "desktop fullscreen dimensions are unavailable")
    end if
    return [desktopWidth, desktopHeight, 1]
  end if
  return [width, height, 0]
end function

/// Creates create for the miniquake2 platform window module.
/// @param title Human-readable title presented to the user.
/// @param width Width in the coordinate or storage units used by the caller.
/// @param height Height in the coordinate or storage units used by the caller.
/// @param fullscreen fullscreen value consumed by this operation.
function create(title, width, height, fullscreen)
  if width <= 0 or height <= 0 then return error(2920, "invalid window dimensions") end if
  fullscreenValue = 0
  if fullscreen then fullscreenValue = 1 end if
  exclusiveAvailable = true
  if fullscreen then
    exclusiveAvailable = native.winTestDisplayMode(width, height, 32, 0) != 0
  end if
  displayMode = try(resolvedDisplayMode(width, height, fullscreen,
    exclusiveAvailable, native.winDesktopWidth(), native.winDesktopHeight()))
  if displayMode is error then return displayMode end if
  windowWidth = displayMode[0]
  windowHeight = displayMode[1]
  useCurrentDisplayMode = displayMode[2]
  // Quake II exposes a fixed mode list, including modes that the current
  // monitor may not advertise.  Keep Apply safe in that case: use a
  // borderless window at the active desktop resolution rather than tearing
  // down the product and failing to create its replacement window.
  // mq_win_create only chooses the borderless window style.  Configure the
  // requested Win32 display mode first so fullscreen also owns the selected
  // resolution instead of occupying just that many pixels on a larger desktop.
  if native.winConfigureDisplayMode(windowWidth, windowHeight, 32, 0,
      fullscreenValue, useCurrentDisplayMode) == 0 then
    return error(2923, "requested fullscreen display mode is unavailable")
  end if
  nativeHandle = native.winCreate(title, windowWidth, windowHeight,
    fullscreenValue)
  if nativeHandle is void or nativeHandle == 0 then
    native.winRestoreDisplayMode()
    return error(2921, "window creation failed")
  end if
  // Quake II 3.19 archives gl_swapinterval and defaults it to one. Product
  // config can change the live interval after creation without rebuilding the
  // window or OpenGL context.
  native.winSetSwapInterval(1)
  verticalSync = true
  return Window(nativeHandle, native.winClientWidth(), native.winClientHeight(),
    fullscreen, false, verticalSync)
end function

/// Apply one native mode transaction and return the verified client size. The
/// caller retains the logical Window fields until this transaction succeeds.
/// @param width Width in the coordinate or storage units used by the caller.
/// @param height Height in the coordinate or storage units used by the caller.
/// @param fullscreen fullscreen value consumed by this operation.
function applyNativeWindowMode(width, height, fullscreen)
  fullscreenValue = 0
  if fullscreen then fullscreenValue = 1 end if
  exclusiveAvailable = true
  if fullscreen then
    exclusiveAvailable = native.winTestDisplayMode(width, height, 32, 0) != 0
  end if
  displayMode = try(resolvedDisplayMode(width, height, fullscreen,
    exclusiveAvailable, native.winDesktopWidth(), native.winDesktopHeight()))
  if displayMode is error then return displayMode end if
  windowWidth = displayMode[0]; windowHeight = displayMode[1]
  if native.winConfigureDisplayMode(windowWidth, windowHeight, 32, 0,
      fullscreenValue, displayMode[2]) == 0 then
    return error(2923, "requested fullscreen display mode is unavailable")
  end if
  if native.winResizeClient(windowWidth, windowHeight) == 0 then
    return error(2924, "live window resize failed")
  end if
  if fullscreen and exclusiveAvailable and
      (native.winDesktopWidth() != windowWidth or
       native.winDesktopHeight() != windowHeight) then
    return error(2924, "live exclusive display mode was not retained")
  end if
  return [native.winClientWidth(), native.winClientHeight()]
end function

/// Reconfigure one live Win32 window without destroying its OpenGL context.
/// Changing display mode and frame style in place preserves every registered
/// GPU resource and, consequently, the active level and client presentation.
/// @param window window value consumed by this operation.
/// @param width Width in the coordinate or storage units used by the caller.
/// @param height Height in the coordinate or storage units used by the caller.
/// @param fullscreen fullscreen value consumed by this operation.
function reconfigure(window, width, height, fullscreen)
  if window.closed then return error(2924, "cannot reconfigure a closed window") end if
  if width <= 0 or height <= 0 then return error(2920, "invalid window dimensions") end if
  previousWidth = window.width; previousHeight = window.height
  previousFullscreen = window.fullscreen
  // The native backend owns the display-mode bookkeeping, frame style and
  // client-size verification. Its resize entry point deliberately preserves
  // the HWND, HDC and WGL context while applying the staged mode below.
  resized = try(applyNativeWindowMode(width, height, fullscreen))
  if resized is error then
    // ConfigureDisplaySettings and frame-style changes are not atomic. Restore
    // the last verified mode before returning the original failure.
    rollback = try(applyNativeWindowMode(previousWidth, previousHeight,
      previousFullscreen))
    if rollback is not error then
      window.width = rollback[0]; window.height = rollback[1]
      window.fullscreen = previousFullscreen
    end if
    return resized
  end if
  window.width = resized[0]
  window.height = resized[1]
  window.fullscreen = fullscreen
  return window
end function

/// Performs the poll operation for the miniquake2 platform window module.
/// @param window window value consumed by this operation.
function poll(window)
  if window.closed then return false end if
  alive = native.winPoll()
  window.width = native.winClientWidth()
  window.height = native.winClientHeight()
  if alive == 0 then window.closed = true end if
  return alive != 0
end function

/// Swap state.
/// @param window window value consumed by this operation.
function swap(window)
  if window.closed then return false end if
  native.winSwap()
  return true
end function

/// Apply the archived Quake II swap interval to the live OpenGL context.
/// @param window window value consumed by this operation.
/// @param enabled enabled value consumed by this operation.
function setVerticalSync(window, enabled)
  if window.closed then return false end if
  if typeof(enabled) != "bool" then return error(2925, "vertical sync must be boolean") end if
  interval = 0
  if enabled then interval = 1 end if
  applied = native.winSetSwapInterval(interval) != 0
  // Lack of WGL_EXT_swap_control is a supported driver condition. Preserve
  // the requested logical value so config round trips while the frame limiter
  // still supplies deterministic pacing.
  window.verticalSync = enabled
  return applied
end function

/// Set title.
/// @param window window value consumed by this operation.
/// @param title Human-readable title presented to the user.
function setTitle(window, title)
  if window.closed then return false end if
  if typeof(title) != "string" or title == "" then
    return error(2922, "window title is required")
  end if
  native.winSetTitle(title)
  return true
end function

/// Return the destroy value.
/// @param window window value consumed by this operation.
function destroy(window)
  // WM_CLOSE marks the logical object closed before application teardown.
  // Native destruction is idempotent and must still release HWND/HDC/WGL.
  native.winDestroy()
  window.closed = true
  return true
end function

/// Return the pop input event value.
function popInputEvent()
  packed = native.winInputEventPop()
  if packed == 0 then return void end if
  return InputEvent((packed >> 24) & 255, (packed >> 8) & 0xffff, packed & 255)
end function

/// Set mouse capture.
/// @param enabled enabled value consumed by this operation.
function setMouseCapture(enabled)
  if enabled then native.winSetCursorCapture(1) else native.winSetCursorCapture(0) end if
  return true
end function
