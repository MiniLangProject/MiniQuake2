/* Owned state records for the asset-free client UX layer. */
package miniquake2.client.ui.types

struct Binding
  key
  command
end struct

struct ActionState
  name
  down
  pressed
end struct

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
end struct

struct ConsoleLine
  text
  time
end struct

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

struct InventoryItem
  index
  name
  count
end struct

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

struct MenuPage
  id
  title
  parent
  items
end struct

struct MenuState
  pages
  currentPage
  cursor
  active
  commands
  commandCount
end struct

struct ScreenState
  console
  menu
  centerText
  centerStart
  centerDuration
  layoutText
  statusbarText
  statusbarTokens
  layoutTokenText
  layoutTokens
  inventory
  selectedInventory
  showInventory
  crosshair
  showHud
end struct
