//! Provides miniquake2 client layout facilities for this project.

/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Safe Quake II statusbar/layout string interpreter and renderer handoff. */
package miniquake2.client.layout

import miniquake2.qcommon.cmd as lcmd
import miniquake2.qcommon.constants as lqc
import miniquake2.game.constants as lgc

/// Store layout command data.
struct LayoutCommand
  /// Stores the operation value associated with layout command.
  operation
  /// Stores the x value associated with layout command.
  x
  /// Stores the y value associated with layout command.
  y
  /// Stores the value value associated with layout command.
  value
  /// Stores the width value associated with layout command.
  width
  /// Stores the text value associated with layout command.
  text
  /// Stores the style value associated with layout command.
  style
end struct

/// Return the integer value.
/// @param token token value consumed by this operation.
/// @param operation operation value consumed by this operation.
function integer(token, operation)
  value = toNumber(token)
  if typeof(value) != "int" then return error(7750, operation + ": integer required") end if
  return value
end function

/// Return the stat value.
/// @param stats stats value consumed by this operation.
/// @param index Zero-based index of the affected item.
function stat(stats, index)
  if index < 0 or index >= len(stats) then return error(7751, "layout stat index outside table") end if
  return stats[index]
end function

/// Require token.
/// @param tokens tokens value consumed by this operation.
/// @param index Zero-based index of the affected item.
/// @param operation operation value consumed by this operation.
function requireToken(tokens, index, operation)
  if index >= len(tokens) then return error(7752, operation + ": missing argument") end if
  return tokens[index]
end function

/// Return the tokenize value.
/// @param layout layout value consumed by this operation.
function tokenize(layout)
  return lcmd.tokenize(layout)
end function

/// Return the player identity value.
/// @param configStrings configStrings value consumed by this operation.
/// @param playerIndex Zero-based index of player.
function playerIdentity(configStrings, playerIndex)
  identity = array(2)
  identity[0] = "unnamed"
  identity[1] = "players/male/grunt_i.pcx"
  configIndex = lqc.CS_PLAYERSKINS + playerIndex
  if configIndex < 0 or configIndex >= len(configStrings) or
      typeof(configStrings[configIndex]) != "string" or configStrings[configIndex] == "" then
    return identity
  end if
  data = bytes(configStrings[configIndex])
  separator = -1
  index = 0
  while index < len(data)
    if data[index] == 92 then separator = index; break end if
    index = index + 1
  end while
  if separator < 0 then identity[0] = configStrings[configIndex]; return identity end if
  if separator > 0 then identity[0] = decode(slice(data, 0, separator)) end if
  if separator + 1 < len(data) then
    skin = decode(slice(data, separator + 1, len(data) - separator - 1))
    identity[1] = "players/" + skin + "_i.pcx"
  end if
  return identity
end function

/// Pad left 3.
/// @param value Value consumed or transformed by the operation.
function padLeft3(value)
  text = value + ""
  if len(bytes(text)) >= 3 then return text end if
  if len(bytes(text)) == 2 then return " " + text end if
  return "  " + text
end function

/// Return the fixed player name.
/// @param name Name of the affected item.
function fixedPlayerName(name)
  data = bytes(name)
  if len(data) > 12 then return decode(slice(data, 0, 12)) end if
  output = name
  while len(bytes(output)) < 12
    output = output + " "
  end while
  return output
end function

/// Populate the parse tokens context destination.
/// @param commands commands value consumed by this operation.
/// @param tokens tokens value consumed by this operation.
/// @param stats stats value consumed by this operation.
/// @param configStrings configStrings value consumed by this operation.
/// @param screenWidth screenWidth value consumed by this operation.
/// @param screenHeight screenHeight value consumed by this operation.
/// @param serverFrame serverFrame value consumed by this operation.
/// @param playerNumber playerNumber value consumed by this operation.
function parseTokensContextInto(commands, tokens, stats, configStrings,
    screenWidth, screenHeight, serverFrame, playerNumber)
  // Flash fields and client blocks can emit multiple draws. Callers provide a
  // reusable two-commands-per-token work buffer so the live HUD does not
  // allocate and compact two arrays on every rendered frame.
  if typeof(commands) != "array" or len(commands) < len(tokens) * 2 then
    return error(7759, "layout command work buffer is too small")
  end if
  commandCount = 0
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
      else if operation == "client" then index = index + 6
      else if operation == "ctf" then index = index + 5
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
      if configStrings[configIndex] != "" then
        commands[commandCount] = LayoutCommand("pic", x, y, 0, 0, configStrings[configIndex], 0); commandCount = commandCount + 1
      end if
    else if operation == "picn" then
      commands[commandCount] = LayoutCommand("pic", x, y, 0, 0, requireToken(tokens, index, operation), 0); commandCount = commandCount + 1; index = index + 1
    else if operation == "num" then
      width = integer(requireToken(tokens, index, operation), operation); index = index + 1
      statIndex = integer(requireToken(tokens, index, operation), operation); index = index + 1
      commands[commandCount] = LayoutCommand("num", x, y, stat(stats, statIndex), width, "", 0); commandCount = commandCount + 1
    else if operation == "hnum" then
      health = stat(stats, lgc.STAT_HEALTH)
      color = 0
      if health <= 0 then color = 1
      else if health <= 25 then color = (serverFrame / 4) & 1
      end if
      if (stat(stats, lgc.STAT_FLASHES) & 1) != 0 then
        commands[commandCount] = LayoutCommand("pic", x, y, 0, 0, "field_3", 0); commandCount = commandCount + 1
      end if
      commands[commandCount] = LayoutCommand("num", x, y, health, 3, "", color); commandCount = commandCount + 1
    else if operation == "anum" then
      ammo = stat(stats, lgc.STAT_AMMO)
      if ammo >= 0 then
        color = 0
        if ammo <= 5 then color = (serverFrame / 4) & 1 end if
        if (stat(stats, lgc.STAT_FLASHES) & 4) != 0 then
          commands[commandCount] = LayoutCommand("pic", x, y, 0, 0, "field_3", 0); commandCount = commandCount + 1
        end if
        commands[commandCount] = LayoutCommand("num", x, y, ammo, 3, "", color); commandCount = commandCount + 1
      end if
    else if operation == "rnum" then
      armor = stat(stats, lgc.STAT_ARMOR)
      if armor >= 1 then
        if (stat(stats, lgc.STAT_FLASHES) & 2) != 0 then
          commands[commandCount] = LayoutCommand("pic", x, y, 0, 0, "field_3", 0); commandCount = commandCount + 1
        end if
        commands[commandCount] = LayoutCommand("num", x, y, armor, 3, "", 0); commandCount = commandCount + 1
      end if
    else if operation == "stat_string" then
      statIndex = integer(requireToken(tokens, index, operation), operation); index = index + 1
      configIndex = stat(stats, statIndex)
      if configIndex < 0 or configIndex >= len(configStrings) then return error(7755, "layout stat_string outside configstrings") end if
      commands[commandCount] = LayoutCommand("string", x, y, 0, 0, configStrings[configIndex], 0); commandCount = commandCount + 1
    else if operation == "string" or operation == "string2" or operation == "cstring" or operation == "cstring2" then
      text = requireToken(tokens, index, operation); index = index + 1
      style = 0
      if operation == "string2" or operation == "cstring2" then style = 128 end if
      if operation == "cstring" or operation == "cstring2" then
        commands[commandCount] = LayoutCommand("center", x, y, 0, 320, text, style); commandCount = commandCount + 1
      else
        commands[commandCount] = LayoutCommand("string", x, y, 0, 0, text, style); commandCount = commandCount + 1
      end if
    else if operation == "client" then
      drawX = screenWidth / 2 - 160 + integer(requireToken(tokens, index, operation), operation); index = index + 1
      drawY = screenHeight / 2 - 120 + integer(requireToken(tokens, index, operation), operation); index = index + 1
      clientIndex = integer(requireToken(tokens, index, operation), operation); index = index + 1
      if clientIndex < 0 or clientIndex >= lqc.MAX_CLIENTS then return error(7758, "layout client outside table") end if
      score = integer(requireToken(tokens, index, operation), operation); index = index + 1
      ping = integer(requireToken(tokens, index, operation), operation); index = index + 1
      elapsed = integer(requireToken(tokens, index, operation), operation); index = index + 1
      identity = playerIdentity(configStrings, clientIndex)
      commands[commandCount] = LayoutCommand("string", drawX + 32, drawY, 0, 0, identity[0], 128); commandCount = commandCount + 1
      commands[commandCount] = LayoutCommand("string", drawX + 32, drawY + 8, 0, 0, "Score: ", 0); commandCount = commandCount + 1
      commands[commandCount] = LayoutCommand("string", drawX + 88, drawY + 8, 0, 0, score + "", 128); commandCount = commandCount + 1
      commands[commandCount] = LayoutCommand("string", drawX + 32, drawY + 16, 0, 0, "Ping:  " + ping, 0); commandCount = commandCount + 1
      commands[commandCount] = LayoutCommand("string", drawX + 32, drawY + 24, 0, 0, "Time:  " + elapsed, 0); commandCount = commandCount + 1
      commands[commandCount] = LayoutCommand("pic", drawX, drawY, 0, 0, identity[1], 0); commandCount = commandCount + 1
    else if operation == "ctf" then
      drawX = screenWidth / 2 - 160 + integer(requireToken(tokens, index, operation), operation); index = index + 1
      drawY = screenHeight / 2 - 120 + integer(requireToken(tokens, index, operation), operation); index = index + 1
      clientIndex = integer(requireToken(tokens, index, operation), operation); index = index + 1
      if clientIndex < 0 or clientIndex >= lqc.MAX_CLIENTS then return error(7758, "layout ctf client outside table") end if
      score = integer(requireToken(tokens, index, operation), operation); index = index + 1
      ping = integer(requireToken(tokens, index, operation), operation); index = index + 1
      if ping > 999 then ping = 999 end if
      identity = playerIdentity(configStrings, clientIndex)
      style = 0
      if clientIndex == playerNumber then style = 128 end if
      commands[commandCount] = LayoutCommand("string", drawX, drawY, 0, 0,
        padLeft3(score) + " " + padLeft3(ping) + " " + fixedPlayerName(identity[0]), style); commandCount = commandCount + 1
    else
      return error(7756, "unknown layout token " + operation)
    end if
  end while
  if ifDepth != 0 then return error(7757, "layout if without endif") end if
  return commandCount
end function

/// Parse tokens context.
/// @param tokens tokens value consumed by this operation.
/// @param stats stats value consumed by this operation.
/// @param configStrings configStrings value consumed by this operation.
/// @param screenWidth screenWidth value consumed by this operation.
/// @param screenHeight screenHeight value consumed by this operation.
/// @param serverFrame serverFrame value consumed by this operation.
/// @param playerNumber playerNumber value consumed by this operation.
function parseTokensContext(tokens, stats, configStrings, screenWidth, screenHeight,
    serverFrame, playerNumber)
  commands = array(len(tokens) * 2)
  commandCount = parseTokensContextInto(commands, tokens, stats, configStrings,
    screenWidth, screenHeight, serverFrame, playerNumber)
  if commandCount == 0 then return [] end if
  if commandCount == len(commands) then return commands end if
  // Do not expose a slice backed by the larger void-filled work array. The
  // current native MiniLang runtime may retain the source capacity during a
  // struct-array foreach, causing the renderer to visit uninitialized slots.
  compact = array(commandCount)
  compactIndex = 0
  while compactIndex < commandCount
    compact[compactIndex] = commands[compactIndex]
    compactIndex = compactIndex + 1
  end while
  return compact
end function

/// Parse tokens.
/// @param tokens tokens value consumed by this operation.
/// @param stats stats value consumed by this operation.
/// @param configStrings configStrings value consumed by this operation.
/// @param screenWidth screenWidth value consumed by this operation.
/// @param screenHeight screenHeight value consumed by this operation.
function parseTokens(tokens, stats, configStrings, screenWidth, screenHeight)
  return parseTokensContext(tokens, stats, configStrings, screenWidth, screenHeight, 0, -1)
end function

/// Parse at frame.
/// @param layout layout value consumed by this operation.
/// @param stats stats value consumed by this operation.
/// @param configStrings configStrings value consumed by this operation.
/// @param screenWidth screenWidth value consumed by this operation.
/// @param screenHeight screenHeight value consumed by this operation.
/// @param serverFrame serverFrame value consumed by this operation.
/// @param playerNumber playerNumber value consumed by this operation.
function parseAtFrame(layout, stats, configStrings, screenWidth, screenHeight,
    serverFrame, playerNumber)
  return parseTokensContext(tokenize(layout), stats, configStrings, screenWidth,
    screenHeight, serverFrame, playerNumber)
end function

/// Parses parse for the miniquake2 client layout workflow.
/// @param layout layout value consumed by this operation.
/// @param stats stats value consumed by this operation.
/// @param configStrings configStrings value consumed by this operation.
/// @param screenWidth screenWidth value consumed by this operation.
/// @param screenHeight screenHeight value consumed by this operation.
function parse(layout, stats, configStrings, screenWidth, screenHeight)
  return parseTokens(tokenize(layout), stats, configStrings, screenWidth, screenHeight)
end function

/// Draws text through the miniquake2 client layout rendering path.
/// @param exports exports value consumed by this operation.
/// @param x Horizontal coordinate used by the operation.
/// @param y Vertical coordinate used by the operation.
/// @param text Text consumed by the operation.
/// @param style style value consumed by this operation.
function drawText(exports, x, y, text, style)
  data = bytes(text)
  index = 0
  while index < len(data)
    exports.DrawChar(x + index * 8, y, (data[index] | style) & 255)
    index = index + 1
  end while
end function

/// Draw number.
/// @param exports exports value consumed by this operation.
/// @param x Horizontal coordinate used by the operation.
/// @param y Vertical coordinate used by the operation.
/// @param value Value consumed or transformed by the operation.
/// @param width Width in the coordinate or storage units used by the caller.
/// @param color color value consumed by this operation.
function drawNumber(exports, x, y, value, width, color)
  if width > 5 then width = 5 end if
  if width < 1 then return 0 end if
  text = value + ""
  data = bytes(text)
  count = len(data)
  if count > width then count = width end if
  drawX = x + 2 + 16 * (width - count)
  index = 0
  while index < count
    glyph = ""
    if data[index] == 45 then glyph = "num_minus"
    else if data[index] >= 48 and data[index] <= 57 then glyph = "num_" + (data[index] - 48)
    end if
    if glyph != "" then
      if color != 0 then glyph = "a" + glyph end if
      exports.DrawPic(drawX, y, glyph)
    end if
    drawX = drawX + 16
    index = index + 1
  end while
  return count
end function

/// Draws draw through the miniquake2 client layout rendering path.
/// @param commands commands value consumed by this operation.
/// @param exports exports value consumed by this operation.
function draw(commands, exports)
  return drawCount(commands, len(commands), exports)
end function

/// Draw count.
/// @param commands commands value consumed by this operation.
/// @param commandCount Number of command to process.
/// @param exports exports value consumed by this operation.
function drawCount(commands, commandCount, exports)
  index = 0
  while index < commandCount
    command = commands[index]
    if command.operation == "pic" then exports.DrawPic(command.x, command.y, command.text)
    else if command.operation == "string" then drawText(exports, command.x, command.y, command.text, command.style)
    else if command.operation == "center" then
      drawText(exports, command.x + (command.width - len(bytes(command.text)) * 8) / 2,
        command.y, command.text, command.style)
    else if command.operation == "num" then
      drawNumber(exports, command.x, command.y, command.value, command.width, command.style)
    end if
    index = index + 1
  end while
  return commandCount
end function
