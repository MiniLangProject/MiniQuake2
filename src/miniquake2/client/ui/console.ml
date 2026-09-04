//! Provides miniquake2 client ui console facilities for this project.

/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Console text buffer, notify overlay and editable command line. */
package miniquake2.client.ui.console

import miniquake2.client.ui.constants as cuic
import miniquake2.client.ui.types as cuitypes
import std.math as smath

/// Creates create for the miniquake2 client ui console module.
/// @param widthChars widthChars value consumed by this operation.
function create(widthChars)
  if widthChars < 1 then widthChars = 1 end if
  return cuitypes.ConsoleState([], "", 0, [], 0, widthChars, 0.0,
    cuic.DEFAULT_NOTIFY_LINES, cuic.DEFAULT_NOTIFY_MSEC, [])
end function

/// Append line.
/// @param console console value consumed by this operation.
/// @param text Text consumed by the operation.
/// @param time time value consumed by this operation.
function appendLine(console, text, time)
  console.lines = console.lines + [cuitypes.ConsoleLine(text, time)]
  if len(console.lines) > cuic.MAX_CONSOLE_LINES then
    console.lines = slice(console.lines, len(console.lines) - cuic.MAX_CONSOLE_LINES, cuic.MAX_CONSOLE_LINES)
  end if
end function

/// Append text.
/// @param console console value consumed by this operation.
/// @param text Text consumed by the operation.
/// @param time time value consumed by this operation.
function appendText(console, text, time)
  data = bytes(text)
  start = 0
  count = 0
  index = 0
  while index < len(data)
    if data[index] == 10 then
      appendLine(console, decode(slice(data, start, count)), time)
      start = index + 1; count = 0
    else
      count = count + 1
      if count >= console.widthChars then
        appendLine(console, decode(slice(data, start, count)), time)
        start = index + 1; count = 0
      end if
    end if
    index = index + 1
  end while
  if count > 0 or len(data) == 0 then appendLine(console, decode(slice(data, start, count)), time) end if
  return true
end function

/// Clear typing.
/// @param console console value consumed by this operation.
function clearTyping(console)
  console.input = ""
  console.cursor = 0
  return true
end function

/// Clear notify.
/// @param console console value consumed by this operation.
function clearNotify(console)
  for each consoleNotifyLine in console.lines
    consoleNotifyLine.time = -2147483647
  end for
  return true
end function

/// Append history.
/// @param console console value consumed by this operation.
/// @param value Value consumed or transformed by the operation.
function appendHistory(console, value)
  if len(console.history) < cuic.MAX_CONSOLE_HISTORY then
    output = array(len(console.history) + 1, void)
    index = 0
    while index < len(console.history)
      output[index] = console.history[index]
      index = index + 1
    end while
    output[len(output) - 1] = value
    console.history = output
    return len(output)
  end if
  index = 1
  while index < len(console.history)
    console.history[index - 1] = console.history[index]
    index = index + 1
  end while
  console.history[len(console.history) - 1] = value
  return len(console.history)
end function

/// Insert byte.
/// @param console console value consumed by this operation.
/// @param value Value consumed or transformed by the operation.
function insertByte(console, value)
  if value < 32 or value > 126 then return false end if
  data = bytes(console.input)
  if len(data) >= cuic.MAX_CONSOLE_INPUT - 1 then return false end if
  before = slice(data, 0, console.cursor)
  after = slice(data, console.cursor, len(data) - console.cursor)
  console.input = decode(before + bytes([value]) + after)
  console.cursor = console.cursor + 1
  return true
end function

/// Return the edit key value.
/// @param console console value consumed by this operation.
/// @param key key value consumed by this operation.
function editKey(console, key)
  data = bytes(console.input)
  if key == cuic.K_BACKSPACE and console.cursor > 0 then
    console.input = decode(slice(data, 0, console.cursor - 1) + slice(data, console.cursor, len(data) - console.cursor))
    console.cursor = console.cursor - 1
  else if key == cuic.K_DEL and console.cursor < len(data) then
    console.input = decode(slice(data, 0, console.cursor) + slice(data, console.cursor + 1, len(data) - console.cursor - 1))
  else if key == cuic.K_LEFTARROW and console.cursor > 0 then console.cursor = console.cursor - 1
  else if key == cuic.K_RIGHTARROW and console.cursor < len(data) then console.cursor = console.cursor + 1
  else if key == cuic.K_HOME then console.cursor = 0
  else if key == cuic.K_END then console.cursor = len(data)
  else if key == cuic.K_ENTER then
    if len(data) > 0 then
      console.commands = console.commands + [console.input]
      console.historyIndex = appendHistory(console, console.input)
    end if
    console.input = ""; console.cursor = 0
  else if key == cuic.K_UPARROW and len(console.history) > 0 then
    if console.historyIndex > 0 then console.historyIndex = console.historyIndex - 1 end if
    console.input = console.history[console.historyIndex]; console.cursor = len(bytes(console.input))
  else if key == cuic.K_DOWNARROW and len(console.history) > 0 then
    if console.historyIndex < len(console.history) - 1 then
      console.historyIndex = console.historyIndex + 1
      console.input = console.history[console.historyIndex]
    else console.historyIndex = len(console.history); console.input = ""
    end if
    console.cursor = len(bytes(console.input))
  else return insertByte(console, key)
  end if
  return true
end function

/// Performs the drainCommands operation for the miniquake2 client ui console module.
/// @param console console value consumed by this operation.
function inline drainCommands(console)
  // Preserve the reusable empty queue on idle frames. A non-empty queue is
  // still transferred by ownership so command execution sees a stable array.
  if len(console.commands) == 0 then return console.commands end if
  output = console.commands
  console.commands = []
  return output
end function

/// Draws text through the miniquake2 client ui console rendering path.
/// @param exports exports value consumed by this operation.
/// @param x Horizontal coordinate used by the operation.
/// @param y Vertical coordinate used by the operation.
/// @param text Text consumed by the operation.
function drawText(exports, x, y, text)
  data = bytes(text)
  index = 0
  while index < len(data)
    exports.DrawChar(x + index * 8, y, data[index])
    index = index + 1
  end while
end function

/// Notify state.
/// @param console console value consumed by this operation.
/// @param now now value consumed by this operation.
/// @param exports exports value consumed by this operation.
function notify(console, now, exports)
  first = len(console.lines) - console.notifyLines
  if first < 0 then first = 0 end if
  y = 0
  count = 0
  index = first
  while index < len(console.lines)
    line = console.lines[index]
    if now - line.time <= console.notifyMsec then drawText(exports, 0, y, line.text); y = y + 8; count = count + 1 end if
    index = index + 1
  end while
  return count
end function

/// Draws draw through the miniquake2 client ui console rendering path.
/// @param console console value consumed by this operation.
/// @param screenWidth screenWidth value consumed by this operation.
/// @param screenHeight screenHeight value consumed by this operation.
/// @param exports exports value consumed by this operation.
function draw(console, screenWidth, screenHeight, exports)
  height = smath.floor(screenHeight * console.visibleFraction)
  if height <= 0 then return 0 end if
  exports.DrawFill(0, 0, screenWidth, height, 0)
  rows = height / 8 - 2
  first = len(console.lines) - rows
  if first < 0 then first = 0 end if
  y = height - (len(console.lines) - first + 2) * 8
  index = first
  while index < len(console.lines)
    drawText(exports, 0, y, console.lines[index].text); y = y + 8; index = index + 1
  end while
  drawText(exports, 0, height - 16, "]" + console.input)
  exports.DrawChar(8 + console.cursor * 8, height - 16, 11)
  return len(console.lines) - first + 2
end function
