//! Provides miniquake2 client ui screen facilities for this project.

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
import miniquake2.client.ui.keys as cuiscreenkeys
import miniquake2.client.ui.types as cuitypes

/// Creates create for the miniquake2 client ui screen module.
/// @param console console value consumed by this operation.
/// @param menu menu value consumed by this operation.
function create(console, menu)
  return cuitypes.ScreenState(console, menu, "", 0, 0, "", "", [], [], "", [],
    [], [], 0, false, 1, true)
end function

/// Return the crosshair position.
/// @param screenWidth screenWidth value consumed by this operation.
/// @param screenHeight screenHeight value consumed by this operation.
/// @param pictureWidth pictureWidth value consumed by this operation.
/// @param pictureHeight pictureHeight value consumed by this operation.
function crosshairPosition(screenWidth, screenHeight, pictureWidth, pictureHeight)
  return [(screenWidth - pictureWidth) / 2, (screenHeight - pictureHeight) / 2]
end function

/// Draw crosshair.
/// @param screen screen value consumed by this operation.
/// @param screenWidth screenWidth value consumed by this operation.
/// @param screenHeight screenHeight value consumed by this operation.
/// @param exports exports value consumed by this operation.
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

/// Print center.
/// @param screen screen value consumed by this operation.
/// @param text Text consumed by the operation.
/// @param now now value consumed by this operation.
/// @param duration duration value consumed by this operation.
function centerPrint(screen, text, now, duration)
  if duration < 0 then return error(8240, "negative centerprint duration") end if
  screen.centerText = text
  screen.centerStart = now
  screen.centerDuration = duration
  return true
end function

/// Set inventory.
/// @param screen screen value consumed by this operation.
/// @param items Items consumed or updated by the operation.
/// @param selected selected value consumed by this operation.
function setInventory(screen, items, selected)
  screen.inventory = items
  screen.selectedInventory = selected
  screen.showInventory = true
  return true
end function

/// Convert the fixed Protocol-34 inventory vector into the compact rows the
/// renderer needs. Receiving an update does not implicitly open the inventory;
/// the local `inven` command owns that user-visible toggle.
/// @param screen screen value consumed by this operation.
/// @param values values value consumed by this operation.
/// @param configStrings configStrings value consumed by this operation.
/// @param selected selected value consumed by this operation.
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
        cuiscreenInventoryIndex, cuiscreenInventoryName, cuiscreenInventoryCount, "")]
    end if
    cuiscreenInventoryIndex = cuiscreenInventoryIndex + 1
  end while
  screen.inventory = cuiscreenInventoryItems
  screen.selectedInventory = selected
  return len(cuiscreenInventoryItems)
end function

/// Resolve the first exact `use <item>` binding shown by the stock inventory.
/// @param screen screen value consumed by this operation.
/// @param input input value consumed by this operation.
function updateInventoryHotkeys(screen, input)
  for each cuiscreenHotkeyItem in screen.inventory
    cuiscreenHotkeyItem.hotkey = ""
    cuiscreenHotkeyCommand = "use " + cuiscreenHotkeyItem.name
    for each cuiscreenHotkeyBinding in input.bindings
      if cuiscreenHotkeyBinding.command == cuiscreenHotkeyCommand and
          cuiscreenHotkeyItem.hotkey == "" then
        cuiscreenHotkeyItem.hotkey = cuiscreenkeys.keyName(cuiscreenHotkeyBinding.key)
      end if
    end for
  end for
  return true
end function

/// Draws text through the miniquake2 client ui screen rendering path.
/// @param exports exports value consumed by this operation.
/// @param x Horizontal coordinate used by the operation.
/// @param y Vertical coordinate used by the operation.
/// @param text Text consumed by the operation.
function drawText(exports, x, y, text)
  data = bytes(text)
  index = 0
  while index < len(data)
    exports.DrawChar(x + index * 8, y, data[index]); index = index + 1
  end while
end function

/// Draw centered lines.
/// @param exports exports value consumed by this operation.
/// @param screenWidth screenWidth value consumed by this operation.
/// @param startY startY value consumed by this operation.
/// @param text Text consumed by the operation.
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

/// Draw inventory.
/// @param screen screen value consumed by this operation.
/// @param screenWidth screenWidth value consumed by this operation.
/// @param screenHeight screenHeight value consumed by this operation.
/// @param exports exports value consumed by this operation.
function drawInventory(screen, screenWidth, screenHeight, exports)
  if screen.showInventory == false then return 0 end if
  x = screenWidth / 2 - 120
  y = screenHeight / 2 - 80
  exports.DrawFill(x - 8, y - 8, 256, 176, 0)
  drawText(exports, x, y, "hotkey ### item")
  y = y + 16
  selectedPosition = 0
  while selectedPosition < len(screen.inventory) and
      screen.inventory[selectedPosition].index != screen.selectedInventory
    selectedPosition = selectedPosition + 1
  end while
  top = selectedPosition - 8
  if top < 0 then top = 0 end if
  if top + 17 > len(screen.inventory) then top = len(screen.inventory) - 17 end if
  if top < 0 then top = 0 end if
  count = 0
  inventoryPosition = top
  while inventoryPosition < len(screen.inventory) and count < 17
    item = screen.inventory[inventoryPosition]
    prefix = "  "
    if item.index == screen.selectedInventory then prefix = "> " end if
    drawText(exports, x, y, prefix + item.hotkey + " " + item.count + " " + item.name)
    y = y + 8; count = count + 1
    inventoryPosition = inventoryPosition + 1
  end while
  return count
end function

/// Draws draw through the miniquake2 client ui screen rendering path.
/// @param screen screen value consumed by this operation.
/// @param now now value consumed by this operation.
/// @param screenWidth screenWidth value consumed by this operation.
/// @param screenHeight screenHeight value consumed by this operation.
/// @param stats stats value consumed by this operation.
/// @param configStrings configStrings value consumed by this operation.
/// @param serverFrame serverFrame value consumed by this operation.
/// @param playerNumber playerNumber value consumed by this operation.
/// @param exports exports value consumed by this operation.
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
      statusCommandCount = try(clayout.parseTokensContextInto(
        screen.statusbarCommands, screen.statusbarTokens, stats, configStrings,
        screenWidth, screenHeight, serverFrame, playerNumber))
      if statusCommandCount is error then
        cuiconsole.appendLine(screen.console,
          "Ignored malformed server statusbar: " + statusCommandCount.message,
          now)
        screen.statusbarTokens = []
        screen.statusbarCommands = []
      else
        count = count + clayout.drawCount(screen.statusbarCommands,
          statusCommandCount, exports)
      end if
    end if
    if screen.layoutText != screen.layoutTokenText then
      screen.layoutTokenText = screen.layoutText
      screen.layoutTokens = []
      if screen.layoutText != "" then screen.layoutTokens = clayout.tokenize(screen.layoutText) end if
      screen.layoutCommands = array(len(screen.layoutTokens) * 2)
    end if
    if len(screen.layoutTokens) > 0 then
      layoutCommandCount = try(clayout.parseTokensContextInto(screen.layoutCommands,
        screen.layoutTokens, stats, configStrings, screenWidth, screenHeight,
        serverFrame, playerNumber))
      if layoutCommandCount is error then
        cuiconsole.appendLine(screen.console,
          "Ignored malformed server layout: " + layoutCommandCount.message,
          now)
        screen.layoutTokens = []
        screen.layoutCommands = []
      else
        count = count + clayout.drawCount(screen.layoutCommands,
          layoutCommandCount, exports)
      end if
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
