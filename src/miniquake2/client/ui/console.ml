/* Console text buffer, notify overlay and editable command line. */
package miniquake2.client.ui.console

import miniquake2.client.ui.constants as cuic
import miniquake2.client.ui.types as cuitypes
import std.math as smath

function create(widthChars)
  if widthChars < 1 then widthChars = 1 end if
  return cuitypes.ConsoleState([], "", 0, [], 0, widthChars, 0.0,
    cuic.DEFAULT_NOTIFY_LINES, cuic.DEFAULT_NOTIFY_MSEC, [])
end function

function appendLine(console, text, time)
  console.lines = console.lines + [cuitypes.ConsoleLine(text, time)]
  if len(console.lines) > cuic.MAX_CONSOLE_LINES then
    console.lines = slice(console.lines, len(console.lines) - cuic.MAX_CONSOLE_LINES, cuic.MAX_CONSOLE_LINES)
  end if
end function

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
      console.history = console.history + [console.input]
      console.historyIndex = len(console.history)
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

function drainCommands(console)
  output = console.commands
  console.commands = []
  return output
end function

function drawText(exports, x, y, text)
  data = bytes(text)
  index = 0
  while index < len(data)
    exports.DrawChar(x + index * 8, y, data[index])
    index = index + 1
  end while
end function

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
