/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Screen composition for HUD, inventory, centerprint, notify and menus. */
package miniquake2.client.ui.screen

import miniquake2.qcommon.constants as cuiscreenqc
import miniquake2.client.layout as clayout
import miniquake2.client.ui.console as cuiconsole
import miniquake2.client.ui.menu as cuimenu
import miniquake2.client.ui.types as cuitypes

// Create state.
function create(console, menu)
  return cuitypes.ScreenState(console, menu, "", 0, 0, "", "", [], [], "", [],
    [], [], 0, false, 1, true)
end function

// Return the crosshair position.
function crosshairPosition(screenWidth, screenHeight, pictureWidth, pictureHeight)
  return [(screenWidth - pictureWidth) / 2, (screenHeight - pictureHeight) / 2]
end function

// Draw crosshair.
function drawCrosshair(screen, screenWidth, screenHeight, exports)
  if not screen.showHud or screen.crosshair <= 0 or screen.menu.active or
      screen.console.visibleFraction > 0.0 then return 0 end if
  name = "ch" + screen.crosshair
  size = exports.DrawGetPicSize(name)
  if size.width <= 0 or size.height <= 0 then return 0 end if
  position = crosshairPosition(screenWidth, screenHeight, size.width, size.height)
  exports.DrawPic(position[0], position[1], name)
  return 1
end function

// Print center.
function centerPrint(screen, text, now, duration)
  if duration < 0 then return error(8240, "negative centerprint duration") end if
  screen.centerText = text
  screen.centerStart = now
  screen.centerDuration = duration
  return true
end function

// Set inventory.
function setInventory(screen, items, selected)
  screen.inventory = items
  screen.selectedInventory = selected
  screen.showInventory = true
  return true
end function

// Convert the fixed Protocol-34 inventory vector into the compact rows the
// renderer needs. Receiving an update does not implicitly open the inventory;
// the local `inven` command owns that user-visible toggle.
function updateInventory(screen, values, configStrings, selected)
  if typeof(values) != "array" or len(values) != cuiscreenqc.MAX_ITEMS or
      typeof(configStrings) != "array" then
    return error(8241, "inventory handoff shape is invalid")
  end if
  cuiscreenInventoryItems = []
  cuiscreenInventoryIndex = 0
  while cuiscreenInventoryIndex < len(values)
    cuiscreenInventoryCount = values[cuiscreenInventoryIndex]
    if typeof(cuiscreenInventoryCount) != "int" then
      return error(8242, "inventory handoff count must be integer")
    end if
    if cuiscreenInventoryCount != 0 then
      cuiscreenInventoryName = "item " + cuiscreenInventoryIndex
      cuiscreenInventoryConfigIndex = cuiscreenqc.CS_ITEMS + cuiscreenInventoryIndex
      if cuiscreenInventoryConfigIndex >= 0 and
          cuiscreenInventoryConfigIndex < len(configStrings) and
          configStrings[cuiscreenInventoryConfigIndex] != "" then
        cuiscreenInventoryName = configStrings[cuiscreenInventoryConfigIndex]
      end if
      cuiscreenInventoryItems = cuiscreenInventoryItems + [cuitypes.InventoryItem(
        cuiscreenInventoryIndex, cuiscreenInventoryName, cuiscreenInventoryCount)]
    end if
    cuiscreenInventoryIndex = cuiscreenInventoryIndex + 1
  end while
  screen.inventory = cuiscreenInventoryItems
  screen.selectedInventory = selected
  return len(cuiscreenInventoryItems)
end function

// Draw text.
function drawText(exports, x, y, text)
  data = bytes(text)
  index = 0
  while index < len(data)
    exports.DrawChar(x + index * 8, y, data[index]); index = index + 1
  end while
end function

// Draw centered lines.
function drawCenteredLines(exports, screenWidth, startY, text)
  data = bytes(text)
  start = 0
  y = startY
  count = 0
  index = 0
  while index <= len(data)
    if index == len(data) or data[index] == 10 then
      line = decode(slice(data, start, index - start))
      drawText(exports, screenWidth / 2 - len(bytes(line)) * 4, y, line)
      y = y + 8; count = count + 1; start = index + 1
    end if
    index = index + 1
  end while
  return count
end function

// Draw inventory.
function drawInventory(screen, screenWidth, screenHeight, exports)
  if screen.showInventory == false then return 0 end if
  x = screenWidth / 2 - 120
  y = screenHeight / 2 - 80
  exports.DrawFill(x - 8, y - 8, 256, 176, 0)
  drawText(exports, x, y, "hotkey ### item")
  y = y + 16
  count = 0
  for each item in screen.inventory
    prefix = "  "
    if item.index == screen.selectedInventory then prefix = "> " end if
    drawText(exports, x, y, prefix + item.index + " " + item.count + " " + item.name)
    y = y + 8; count = count + 1
    if count >= 17 then return count end if
  end for
  return count
end function

// Draw state.
function draw(screen, now, screenWidth, screenHeight, stats, configStrings,
    serverFrame, playerNumber, exports)
  // Keep draw phases explicit: validate inputs, update owned state, then publish the result.
  count = 0
  count = count + drawCrosshair(screen, screenWidth, screenHeight, exports)
  if screen.showHud then
    statusbar = ""
    if len(configStrings) > cuiscreenqc.CS_STATUSBAR and
        typeof(configStrings[cuiscreenqc.CS_STATUSBAR]) == "string" then
      statusbar = configStrings[cuiscreenqc.CS_STATUSBAR]
    end if
    if statusbar != screen.statusbarText then
      screen.statusbarText = statusbar
      screen.statusbarTokens = []
      if statusbar != "" then screen.statusbarTokens = clayout.tokenize(statusbar) end if
      screen.statusbarCommands = array(len(screen.statusbarTokens) * 2)
    end if
    if len(screen.statusbarTokens) > 0 then
      statusCommandCount = clayout.parseTokensContextInto(
        screen.statusbarCommands, screen.statusbarTokens, stats, configStrings,
        screenWidth, screenHeight, serverFrame, playerNumber)
      count = count + clayout.drawCount(screen.statusbarCommands,
        statusCommandCount, exports)
    end if
    if screen.layoutText != screen.layoutTokenText then
      screen.layoutTokenText = screen.layoutText
      screen.layoutTokens = []
      if screen.layoutText != "" then screen.layoutTokens = clayout.tokenize(screen.layoutText) end if
      screen.layoutCommands = array(len(screen.layoutTokens) * 2)
    end if
    if len(screen.layoutTokens) > 0 then
      layoutCommandCount = clayout.parseTokensContextInto(screen.layoutCommands,
        screen.layoutTokens, stats, configStrings, screenWidth, screenHeight,
        serverFrame, playerNumber)
      count = count + clayout.drawCount(screen.layoutCommands,
        layoutCommandCount, exports)
    end if
  end if
  count = count + drawInventory(screen, screenWidth, screenHeight, exports)
  if screen.centerText != "" and now - screen.centerStart <= screen.centerDuration then
    count = count + drawCenteredLines(exports, screenWidth, screenHeight * 35 / 100, screen.centerText)
  end if
  if screen.menu.active then count = count + cuimenu.draw(screen.menu, screenWidth, screenHeight, now, exports)
  else if screen.console.visibleFraction > 0.0 then count = count + cuiconsole.draw(screen.console, screenWidth, screenHeight, exports)
  else count = count + cuiconsole.notify(screen.console, now, exports)
  end if
  return count
end function
