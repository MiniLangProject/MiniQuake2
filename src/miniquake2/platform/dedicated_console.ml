//! Provides miniquake2 platform dedicated console facilities for this project.

/*
Copyright (C) 1997-2001 Id Software, Inc.
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later

Nonblocking dedicated-server console input using the shared native bridge.
*/
package miniquake2.platform.dedicated_console

import miniquake2.native as dcnative

/// Defines the console capacity constant used by the miniquake2 platform dedicated console module.
const CONSOLE_CAPACITY = 256
/// Defines the event present constant used by the miniquake2 platform dedicated console module.
const EVENT_PRESENT = 0x80000000
/// Defines the event key down constant used by the miniquake2 platform dedicated console module.
const EVENT_KEY_DOWN = 0x00010000

/// Store the partially entered dedicated-console line.
struct DedicatedConsoleState
  /// Stores the input value associated with dedicated console state.
  input
  /// Stores the length value associated with dedicated console state.
  length
  /// Stores the opened value associated with dedicated console state.
  opened
end struct

/// Create an isolated console decoder. Native allocation remains explicit so
/// unit tests can exercise the byte-for-byte input policy without host I/O.
function create()
  return DedicatedConsoleState(bytes(CONSOLE_CAPACITY), 0, false)
end function

/// Attach to the process console, allocating one only when the executable does
/// not already own a usable standard-output handle.
/// @param state Mutable state inspected or updated by the operation.
function open(state)
  if state.opened then return true end if
  state.opened = dcnative.sysConsoleAlloc() != 0
  return state.opened
end function

/// Release only a console allocated by the shared bridge.
/// @param state Mutable state inspected or updated by the operation.
function close(state)
  if not state.opened then return false end if
  dcnative.sysConsoleFree()
  state.opened = false
  return true
end function

/// Decode one bridge event. The original Windows Quake console consumes the
/// character on key release; redirected stdin uses the same key-up encoding.
/// The return value is [completedLine-or-void, echoText].
/// @param state Mutable state inspected or updated by the operation.
/// @param encoded encoded value consumed by this operation.
function acceptEvent(state, encoded)
  if (encoded & EVENT_PRESENT) == 0 then return [void, ""] end if
  if (encoded & EVENT_KEY_DOWN) != 0 then return [void, ""] end if
  character = encoded & 255
  if character == 13 then
    if state.length > 0 then
      line = decode(slice(state.input, 0, state.length))
      state.length = 0
      return [line, "\r\n"]
    end if
    return [void, "\r\n"]
  end if
  if character == 8 then
    if state.length > 0 then
      state.length = state.length - 1
      return [void, "\b \b"]
    end if
    return [void, ""]
  end if
  if character < 32 or character > 126 or state.length >= CONSOLE_CAPACITY - 1 then
    return [void, ""]
  end if
  state.input[state.length] = character
  state.length = state.length + 1
  return [void, decode(bytes([character]))]
end function

/// Drain all currently pending native events without blocking the 10 Hz server
/// frame. More than one complete redirected-input line may be available.
/// @param state Mutable state inspected or updated by the operation.
function poll(state)
  if not state.opened then return [] end if
  lines = []
  while true
    encoded = dcnative.sysConsoleEventPop()
    if (encoded & EVENT_PRESENT) == 0 then break end if
    accepted = acceptEvent(state, encoded)
    if accepted[1] != "" then dcnative.sysConsoleWrite(accepted[1]) end if
    if accepted[0] is not void then lines = lines + [accepted[0]] end if
  end while
  return lines
end function

/// Write operator output through the console-safe bridge.
/// @param state Mutable state inspected or updated by the operation.
/// @param text Text consumed by the operation.
function write(state, text)
  if not state.opened or text == "" then return false end if
  return dcnative.sysConsoleWrite(text) != 0
end function
