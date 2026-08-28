/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Owned state records for the asset-free client UX layer. */
package miniquake2.client.ui.types

// Store binding data.
struct Binding
  key
  command
end struct

// Store action state data.
struct ActionState
  name
  down
  pressed
  downTime
  msec
end struct

// Store input config data.
struct InputConfig
  forwardSpeed
  sideSpeed
  upSpeed
  yawSpeed
  pitchSpeed
  angleSpeedKey
  alwaysRun
  hand
  sensitivity
  mouseYaw
  mousePitch
  mouseForward
  mouseSide
end struct

// Store input state data.
struct InputState
  destination
  focused
  bindings
  keys
  actions
  viewAngles
  mouseDx
  mouseDy
  impulse
  lightLevel
  commands
  message
  messageTeam
  config
  captureCommand
  capturedKey
  controllerForward
  controllerSide
  controllerButtons
  commandTime
end struct

// Store console line data.
struct ConsoleLine
  text
  time
end struct

// Store console state data.
struct ConsoleState
  lines
  input
  cursor
  history
  historyIndex
  widthChars
  visibleFraction
  notifyLines
  notifyMsec
  commands
end struct

// Store inventory item data.
struct InventoryItem
  index
  name
  count
  hotkey
end struct

// Store menu item data.
struct MenuItem
  id
  label
  kind
  value
  minimum
  maximum
  step
  choices
  command
  enabled
end struct

// Store menu page data.
struct MenuPage
  id
  title
  parent
  items
end struct

// Store menu state data.
struct MenuState
  pages
  currentPage
  cursor
  active
  commands
  commandCount
end struct

// Store screen state data.
struct ScreenState
  console
  menu
  centerText
  centerStart
  centerDuration
  layoutText
  statusbarText
  statusbarTokens
  statusbarCommands
  layoutTokenText
  layoutTokens
  layoutCommands
  inventory
  selectedInventory
  showInventory
  crosshair
  showHud
end struct
