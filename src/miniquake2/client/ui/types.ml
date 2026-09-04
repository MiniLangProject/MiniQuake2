//! Provides miniquake2 client ui types facilities for this project.

/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Owned state records for the asset-free client UX layer. */
package miniquake2.client.ui.types

/// Store binding data.
struct Binding
  /// Stores the key value associated with binding.
  key
  /// Stores the command value associated with binding.
  command
end struct

/// Store action state data.
struct ActionState
  /// Stores the name value associated with action state.
  name
  /// Stores the down value associated with action state.
  down
  /// Stores the pressed value associated with action state.
  pressed
  /// Stores the down time value associated with action state.
  downTime
  /// Stores the msec value associated with action state.
  msec
end struct

/// Store input config data.
struct InputConfig
  /// Stores the forward speed value associated with input config.
  forwardSpeed
  /// Stores the side speed value associated with input config.
  sideSpeed
  /// Stores the up speed value associated with input config.
  upSpeed
  /// Stores the yaw speed value associated with input config.
  yawSpeed
  /// Stores the pitch speed value associated with input config.
  pitchSpeed
  /// Stores the angle speed key value associated with input config.
  angleSpeedKey
  /// Stores the always run value associated with input config.
  alwaysRun
  /// Stores the hand value associated with input config.
  hand
  /// Stores the sensitivity value associated with input config.
  sensitivity
  /// Stores the mouse yaw value associated with input config.
  mouseYaw
  /// Stores the mouse pitch value associated with input config.
  mousePitch
  /// Stores the mouse forward value associated with input config.
  mouseForward
  /// Stores the mouse side value associated with input config.
  mouseSide
end struct

/// Store input state data.
struct InputState
  /// Stores the destination value associated with input state.
  destination
  /// Stores the focused value associated with input state.
  focused
  /// Stores the bindings value associated with input state.
  bindings
  /// Stores the keys value associated with input state.
  keys
  /// Stores the actions value associated with input state.
  actions
  /// Stores the view angles value associated with input state.
  viewAngles
  /// Stores the mouse dx value associated with input state.
  mouseDx
  /// Stores the mouse dy value associated with input state.
  mouseDy
  /// Stores the impulse value associated with input state.
  impulse
  /// Stores the light level value associated with input state.
  lightLevel
  /// Stores the commands value associated with input state.
  commands
  /// Stores the message value associated with input state.
  message
  /// Stores the message team value associated with input state.
  messageTeam
  /// Stores the config value associated with input state.
  config
  /// Stores the capture command value associated with input state.
  captureCommand
  /// Stores the captured key value associated with input state.
  capturedKey
  /// Stores the controller forward value associated with input state.
  controllerForward
  /// Stores the controller side value associated with input state.
  controllerSide
  /// Stores the controller buttons value associated with input state.
  controllerButtons
  /// Stores the command time value associated with input state.
  commandTime
end struct

/// Store console line data.
struct ConsoleLine
  /// Stores the text value associated with console line.
  text
  /// Stores the time value associated with console line.
  time
end struct

/// Store console state data.
struct ConsoleState
  /// Stores the lines value associated with console state.
  lines
  /// Stores the input value associated with console state.
  input
  /// Stores the cursor value associated with console state.
  cursor
  /// Stores the history value associated with console state.
  history
  /// Stores the history index value associated with console state.
  historyIndex
  /// Stores the width chars value associated with console state.
  widthChars
  /// Stores the visible fraction value associated with console state.
  visibleFraction
  /// Stores the notify lines value associated with console state.
  notifyLines
  /// Stores the notify msec value associated with console state.
  notifyMsec
  /// Stores the commands value associated with console state.
  commands
end struct

/// Store inventory item data.
struct InventoryItem
  /// Stores the index value associated with inventory item.
  index
  /// Stores the name value associated with inventory item.
  name
  /// Stores the count value associated with inventory item.
  count
  /// Stores the hotkey value associated with inventory item.
  hotkey
end struct

/// Store menu item data.
struct MenuItem
  /// Stores the id value associated with menu item.
  id
  /// Stores the label value associated with menu item.
  label
  /// Stores the kind value associated with menu item.
  kind
  /// Stores the value value associated with menu item.
  value
  /// Stores the minimum value associated with menu item.
  minimum
  /// Stores the maximum value associated with menu item.
  maximum
  /// Stores the step value associated with menu item.
  step
  /// Stores the choices value associated with menu item.
  choices
  /// Stores the command value associated with menu item.
  command
  /// Stores the enabled value associated with menu item.
  enabled
end struct

/// Store menu page data.
struct MenuPage
  /// Stores the id value associated with menu page.
  id
  /// Stores the title value associated with menu page.
  title
  /// Stores the parent value associated with menu page.
  parent
  /// Stores the items value associated with menu page.
  items
end struct

/// Store menu state data.
struct MenuState
  /// Stores the pages value associated with menu state.
  pages
  /// Stores the current page value associated with menu state.
  currentPage
  /// Stores the cursor value associated with menu state.
  cursor
  /// Stores the active value associated with menu state.
  active
  /// Stores the commands value associated with menu state.
  commands
  /// Stores the command count value associated with menu state.
  commandCount
end struct

/// Store screen state data.
struct ScreenState
  /// Stores the console value associated with screen state.
  console
  /// Stores the menu value associated with screen state.
  menu
  /// Stores the center text value associated with screen state.
  centerText
  /// Stores the center start value associated with screen state.
  centerStart
  /// Stores the center duration value associated with screen state.
  centerDuration
  /// Stores the layout text value associated with screen state.
  layoutText
  /// Stores the statusbar text value associated with screen state.
  statusbarText
  /// Stores the statusbar tokens value associated with screen state.
  statusbarTokens
  /// Stores the statusbar commands value associated with screen state.
  statusbarCommands
  /// Stores the layout token text value associated with screen state.
  layoutTokenText
  /// Stores the layout tokens value associated with screen state.
  layoutTokens
  /// Stores the layout commands value associated with screen state.
  layoutCommands
  /// Stores the inventory value associated with screen state.
  inventory
  /// Stores the selected inventory value associated with screen state.
  selectedInventory
  /// Stores the show inventory value associated with screen state.
  showInventory
  /// Stores the crosshair value associated with screen state.
  crosshair
  /// Stores the show hud value associated with screen state.
  showHud
end struct
