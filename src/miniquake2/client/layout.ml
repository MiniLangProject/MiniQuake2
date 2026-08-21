/* Safe Quake II statusbar/layout string interpreter and renderer handoff. */
package miniquake2.client.layout

import miniquake2.qcommon.cmd as lcmd
import miniquake2.qcommon.constants as lqc
import miniquake2.game.constants as lgc

struct LayoutCommand
  operation
  x
  y
  value
  width
  text
end struct

function integer(token, operation)
  value = toNumber(token)
  if typeof(value) != "int" then return error(7750, operation + ": integer required") end if
  return value
end function

function stat(stats, index)
  if index < 0 or index >= len(stats) then return error(7751, "layout stat index outside table") end if
  return stats[index]
end function

function requireToken(tokens, index, operation)
  if index >= len(tokens) then return error(7752, operation + ": missing argument") end if
  return tokens[index]
end function

function parse(layout, stats, configStrings, screenWidth, screenHeight)
  tokens = lcmd.tokenize(layout)
  commands = []
  x = 0
  y = 0
  index = 0
  skipDepth = 0
  ifDepth = 0
  while index < len(tokens)
    operation = tokens[index]
    index = index + 1
    if operation == "if" then
      statIndex = integer(requireToken(tokens, index, "if"), "if"); index = index + 1
      ifDepth = ifDepth + 1
      if skipDepth > 0 then skipDepth = skipDepth + 1
      else if stat(stats, statIndex) == 0 then skipDepth = 1
      end if
    else if operation == "endif" then
      if ifDepth <= 0 then return error(7753, "layout endif without if") end if
      if skipDepth > 0 then skipDepth = skipDepth - 1 end if
      ifDepth = ifDepth - 1
    else if skipDepth > 0 then
      // Even skipped operators must consume their fixed arguments.
      if operation == "xl" or operation == "xr" or operation == "xv" or operation == "yt" or operation == "yb" or operation == "yv" or operation == "pic" or operation == "picn" or operation == "stat_string" or operation == "string" or operation == "string2" or operation == "cstring" or operation == "cstring2" then index = index + 1
      else if operation == "num" then index = index + 2
      end if
      if index > len(tokens) then return error(7752, operation + ": missing skipped argument") end if
    else if operation == "xl" then x = integer(requireToken(tokens, index, operation), operation); index = index + 1
    else if operation == "xr" then x = screenWidth + integer(requireToken(tokens, index, operation), operation); index = index + 1
    else if operation == "xv" then x = screenWidth / 2 - 160 + integer(requireToken(tokens, index, operation), operation); index = index + 1
    else if operation == "yt" then y = integer(requireToken(tokens, index, operation), operation); index = index + 1
    else if operation == "yb" then y = screenHeight + integer(requireToken(tokens, index, operation), operation); index = index + 1
    else if operation == "yv" then y = screenHeight / 2 - 120 + integer(requireToken(tokens, index, operation), operation); index = index + 1
    else if operation == "pic" then
      statIndex = integer(requireToken(tokens, index, operation), operation); index = index + 1
      imageIndex = stat(stats, statIndex)
      configIndex = lqc.CS_IMAGES + imageIndex
      if imageIndex < 0 or configIndex >= len(configStrings) then return error(7754, "layout pic configstring outside table") end if
      commands = commands + [LayoutCommand("pic", x, y, 0, 0, configStrings[configIndex])]
    else if operation == "picn" then
      commands = commands + [LayoutCommand("pic", x, y, 0, 0, requireToken(tokens, index, operation))]; index = index + 1
    else if operation == "num" then
      width = integer(requireToken(tokens, index, operation), operation); index = index + 1
      statIndex = integer(requireToken(tokens, index, operation), operation); index = index + 1
      commands = commands + [LayoutCommand("num", x, y, stat(stats, statIndex), width, "")]
    else if operation == "hnum" then commands = commands + [LayoutCommand("num", x, y, stat(stats, lgc.STAT_HEALTH), 3, "")]
    else if operation == "anum" then commands = commands + [LayoutCommand("num", x, y, stat(stats, lgc.STAT_AMMO), 3, "")]
    else if operation == "rnum" then commands = commands + [LayoutCommand("num", x, y, stat(stats, lgc.STAT_ARMOR), 3, "")]
    else if operation == "stat_string" then
      statIndex = integer(requireToken(tokens, index, operation), operation); index = index + 1
      configIndex = stat(stats, statIndex)
      if configIndex < 0 or configIndex >= len(configStrings) then return error(7755, "layout stat_string outside configstrings") end if
      commands = commands + [LayoutCommand("string", x, y, 0, 0, configStrings[configIndex])]
    else if operation == "string" or operation == "string2" or operation == "cstring" or operation == "cstring2" then
      text = requireToken(tokens, index, operation); index = index + 1
      drawX = x
      if operation == "cstring" or operation == "cstring2" then drawX = screenWidth / 2 - len(bytes(text)) * 4 end if
      commands = commands + [LayoutCommand("string", drawX, y, 0, 0, text)]
    else
      return error(7756, "unknown layout token " + operation)
    end if
  end while
  if ifDepth != 0 then return error(7757, "layout if without endif") end if
  return commands
end function

function drawText(exports, x, y, text)
  data = bytes(text)
  index = 0
  while index < len(data)
    exports.DrawChar(x + index * 8, y, data[index])
    index = index + 1
  end while
end function

function draw(commands, exports)
  for each command in commands
    if command.operation == "pic" then exports.DrawPic(command.x, command.y, command.text)
    else if command.operation == "string" then drawText(exports, command.x, command.y, command.text)
    else if command.operation == "num" then
      text = command.value + ""
      drawText(exports, command.x + (command.width - len(bytes(text))) * 8, command.y, text)
    end if
  end for
  return len(commands)
end function
