/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Win32 window/input lifecycle. Rendering is kept behind renderer API v3. */
package miniquake2.platform.window

import miniquake2.native as native

struct Window
  handle
  width
  height
  fullscreen
  closed
end struct

struct InputEvent
  type
  code
  value
end struct

function create(title, width, height, fullscreen)
  if width <= 0 or height <= 0 then return error(2920, "invalid window dimensions") end if
  fullscreenValue = 0
  if fullscreen then fullscreenValue = 1 end if
  nativeHandle = native.winCreate(title, width, height, fullscreenValue)
  if nativeHandle is void or nativeHandle == 0 then return error(2921, "window creation failed") end if
  return Window(nativeHandle, native.winClientWidth(), native.winClientHeight(), fullscreen, false)
end function

function poll(window)
  if window.closed then return false end if
  alive = native.winPoll()
  window.width = native.winClientWidth()
  window.height = native.winClientHeight()
  if alive == 0 then window.closed = true end if
  return alive != 0
end function

function swap(window)
  if window.closed then return false end if
  native.winSwap()
  return true
end function

function setTitle(window, title)
  if window.closed then return false end if
  if typeof(title) != "string" or title == "" then
    return error(2922, "window title is required")
  end if
  native.winSetTitle(title)
  return true
end function

function destroy(window)
  if window.closed == false then native.winDestroy(); window.closed = true end if
  return true
end function

function popInputEvent()
  packed = native.winInputEventPop()
  if packed == 0 then return void end if
  return InputEvent((packed >> 24) & 255, (packed >> 8) & 0xffff, packed & 255)
end function

function setMouseCapture(enabled)
  if enabled then native.winSetCursorCapture(1) else native.winSetCursorCapture(0) end if
  return true
end function
