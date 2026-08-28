/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Win32 window/input lifecycle. Rendering is kept behind renderer API v3. */
package miniquake2.platform.window

import miniquake2.native as native

// Store window data.
struct Window
  handle
  width
  height
  fullscreen
  closed
  verticalSync
end struct

// Store input event data.
struct InputEvent
  type
  code
  value
end struct

// Resolve a fixed Quake II menu mode to a mode the active monitor can safely
// display. The third value selects the native "use current display mode"
// borderless fallback.
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

// Create state.
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
  // Match MiniQuake's low-latency presentation default. The product loop
  // yields between frames but no longer hides renderer gains behind a 60-Hz
  // swap interval or a synthetic 120-Hz fallback cap.
  native.winSetSwapInterval(0)
  verticalSync = false
  return Window(nativeHandle, native.winClientWidth(), native.winClientHeight(),
    fullscreen, false, verticalSync)
end function

// Reconfigure one live Win32 window without destroying its OpenGL context.
// Changing display mode and frame style in place preserves every registered
// GPU resource and, consequently, the active level and client presentation.
function reconfigure(window, width, height, fullscreen)
  if window.closed then return error(2924, "cannot reconfigure a closed window") end if
  if width <= 0 or height <= 0 then return error(2920, "invalid window dimensions") end if
  fullscreenValue = 0
  if fullscreen then fullscreenValue = 1 end if
  exclusiveAvailable = true
  if fullscreen then
    exclusiveAvailable = native.winTestDisplayMode(width, height, 32, 0) != 0
  end if
  displayMode = try(resolvedDisplayMode(width, height, fullscreen,
    exclusiveAvailable, native.winDesktopWidth(), native.winDesktopHeight()))
  windowWidth = displayMode[0]
  windowHeight = displayMode[1]
  // The native backend owns the display-mode bookkeeping, frame style and
  // client-size verification. Its resize entry point deliberately preserves
  // the HWND, HDC and WGL context while applying the staged mode below.
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
  window.width = native.winClientWidth()
  window.height = native.winClientHeight()
  window.fullscreen = fullscreen
  return window
end function

// Poll state.
function poll(window)
  if window.closed then return false end if
  alive = native.winPoll()
  window.width = native.winClientWidth()
  window.height = native.winClientHeight()
  if alive == 0 then window.closed = true end if
  return alive != 0
end function

// Swap state.
function swap(window)
  if window.closed then return false end if
  native.winSwap()
  return true
end function

// Set title.
function setTitle(window, title)
  if window.closed then return false end if
  if typeof(title) != "string" or title == "" then
    return error(2922, "window title is required")
  end if
  native.winSetTitle(title)
  return true
end function

// Return the destroy value.
function destroy(window)
  if window.closed == false then native.winDestroy(); window.closed = true end if
  return true
end function

// Return the pop input event value.
function popInputEvent()
  packed = native.winInputEventPop()
  if packed == 0 then return void end if
  return InputEvent((packed >> 24) & 255, (packed >> 8) & 0xffff, packed & 255)
end function

// Set mouse capture.
function setMouseCapture(enabled)
  if enabled then native.winSetCursorCapture(1) else native.winSetCursorCapture(0) end if
  return true
end function
