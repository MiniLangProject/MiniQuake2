/* Quake II key translation, destinations and command bindings. */
package miniquake2.client.ui.keys

import miniquake2.client.ui.constants as cuic
import miniquake2.client.ui.types as cuitypes
import miniquake2.platform.window as pwindow

function actionNames()
  return ["forward", "back", "moveleft", "moveright", "left", "right",
    "lookup", "lookdown", "moveup", "movedown", "attack", "use",
    "speed", "strafe", "klook"]
end function

function defaultConfig()
  return cuitypes.InputConfig(200.0, 200.0, 200.0, 140.0, 150.0, 1.5,
    false, 3.0, 0.022, 0.022, 1.0, 1.0)
end function

function createInputState()
  actions = []
  for each name in actionNames()
    actions = actions + [cuitypes.ActionState(name, false, false)]
  end for
  return cuitypes.InputState(cuic.KEY_GAME, true, [], array(cuic.MAX_KEYS, false),
    actions, [0.0, 0.0, 0.0], 0.0, 0.0, 0, 0, [], "", false,
    defaultConfig(), "", -1)
end function

function setDestination(state, destination)
  if destination < cuic.KEY_GAME or destination > cuic.KEY_MENU then return error(8200, "invalid key destination") end if
  state.destination = destination
  return destination
end function

function findBinding(state, key)
  for each binding in state.bindings
    if binding.key == key then return binding end if
  end for
  return void
end function

function bind(state, key, command)
  if key < 0 or key >= cuic.MAX_KEYS then return error(8201, "binding key outside table") end if
  if len(bytes(command)) == 0 then return unbind(state, key) end if
  binding = findBinding(state, key)
  if binding is void then state.bindings = state.bindings + [cuitypes.Binding(key, command)]
  else binding.command = command
  end if
  return true
end function

function unbind(state, key)
  output = []
  for each binding in state.bindings
    if binding.key != key then output = output + [binding] end if
  end for
  state.bindings = output
  return true
end function

function bindingFor(state, key)
  binding = findBinding(state, key)
  if binding is void then return "" end if
  return binding.command
end function

function beginBindingCapture(state, command)
  if typeof(command) != "string" or command == "" then
    return error(8203, "binding capture requires a command")
  end if
  state.captureCommand = command
  state.capturedKey = -1
  return true
end function

function cancelBindingCapture(state)
  state.captureCommand = ""
  state.capturedKey = -2
  return true
end function

function unbindCommand(state, command)
  cuikeysRemainingBindings = []
  for each cuikeysExistingBinding in state.bindings
    if cuikeysExistingBinding.command != command then
      cuikeysRemainingBindings = cuikeysRemainingBindings + [cuikeysExistingBinding]
    end if
  end for
  state.bindings = cuikeysRemainingBindings
  return true
end function

function captureBindingEvent(state, key)
  if state.captureCommand == "" then return false end if
  if key == cuic.K_ESCAPE then return cancelBindingCapture(state) end if
  cuikeysCapturedCommand = state.captureCommand
  unbindCommand(state, cuikeysCapturedCommand)
  bind(state, key, cuikeysCapturedCommand)
  state.captureCommand = ""
  state.capturedKey = key
  return true
end function

function findAction(state, name)
  for each action in state.actions
    if action.name == name then return action end if
  end for
  return void
end function

function setAction(state, name, down)
  action = findAction(state, name)
  if action is void then return false end if
  if down and action.down == false then action.pressed = true end if
  action.down = down
  return true
end function

function commandAction(command)
  data = bytes(command)
  if len(data) < 2 or data[0] != 43 then return "" end if
  return decode(slice(data, 1, len(data) - 1))
end function

function scanKey(scan)
  if scan == 1 then return cuic.K_ESCAPE end if
  if scan >= 2 and scan <= 10 then return 47 + scan end if
  if scan == 11 then return 48 end if
  if scan == 12 then return 45 end if
  if scan == 13 then return 61 end if
  if scan == 14 then return cuic.K_BACKSPACE end if
  if scan == 15 then return cuic.K_TAB end if
  letters = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    113, 119, 101, 114, 116, 121, 117, 105, 111, 112, 91, 93, 0, 0,
    97, 115, 100, 102, 103, 104, 106, 107, 108, 59, 39, 96, 0, 92,
    122, 120, 99, 118, 98, 110, 109, 44, 46, 47]
  if scan >= 16 and scan < len(letters) and letters[scan] != 0 then return letters[scan] end if
  if scan == 28 then return cuic.K_ENTER end if
  if scan == 29 then return cuic.K_CTRL end if
  if scan == 42 or scan == 54 then return cuic.K_SHIFT end if
  if scan == 56 then return cuic.K_ALT end if
  if scan == 57 then return cuic.K_SPACE end if
  if scan >= 59 and scan <= 68 then return cuic.K_F1 + scan - 59 end if
  if scan == 87 then return cuic.K_F11 end if
  if scan == 88 then return cuic.K_F12 end if
  if scan == 71 then return cuic.K_HOME end if
  if scan == 72 then return cuic.K_UPARROW end if
  if scan == 73 then return cuic.K_PGUP end if
  if scan == 75 then return cuic.K_LEFTARROW end if
  if scan == 77 then return cuic.K_RIGHTARROW end if
  if scan == 79 then return cuic.K_END end if
  if scan == 80 then return cuic.K_DOWNARROW end if
  if scan == 81 then return cuic.K_PGDN end if
  if scan == 82 then return cuic.K_INS end if
  if scan == 83 then return cuic.K_DEL end if
  return 0
end function

function eventKey(event)
  if event.type == cuic.EVENT_SCAN_KEY then return scanKey(event.code) end if
  if event.type == cuic.EVENT_KEY then
    // Synthetic/test events may already carry Quake key codes.
    if event.code >= 0 and event.code < cuic.MAX_KEYS then return event.code end if
  else if event.type == cuic.EVENT_MOUSE_BUTTON then
    if event.code >= 0 and event.code <= 2 then return cuic.K_MOUSE1 + event.code end if
  else if event.type == cuic.EVENT_MOUSE_WHEEL then
    value = event.value
    if value >= 128 then value = value - 256 end if
    if value < 0 then return cuic.K_MWHEELDOWN end if
    if value > 0 then return cuic.K_MWHEELUP end if
  end if
  return 0
end function

function queueBinding(state, key, down, time)
  command = bindingFor(state, key)
  if command == "" then return false end if
  actionName = commandAction(command)
  if actionName != "" then
    setAction(state, actionName, down)
    if down then state.commands = state.commands + [command + " " + key + " " + time]
    else state.commands = state.commands + ["-" + actionName + " " + key + " " + time]
    end if
  else if down then state.commands = state.commands + [command]
  end if
  return true
end function

function handleEvent(state, event, time)
  if event.type == cuic.EVENT_FOCUS then
    state.focused = event.value != 0
    if state.focused == false then
      index = 0
      while index < len(state.keys)
        if state.keys[index] then queueBinding(state, index, false, time); state.keys[index] = false end if
        index = index + 1
      end while
    end if
    return true
  end if
  key = eventKey(event)
  if key == 0 then return false end if
  down = event.value != 0
  if event.type == cuic.EVENT_MOUSE_WHEEL then down = true end if
  if key < 0 or key >= len(state.keys) then return error(8202, "input key outside table") end if
  if state.captureCommand != "" and down then return captureBindingEvent(state, key) end if
  wasDown = state.keys[key]
  state.keys[key] = down
  if (state.destination == cuic.KEY_GAME or (down == false and wasDown)) and (down != wasDown or event.type == cuic.EVENT_MOUSE_WHEEL) then
    queueBinding(state, key, down, time)
    if event.type == cuic.EVENT_MOUSE_WHEEL then queueBinding(state, key, false, time); state.keys[key] = false end if
  end if
  return true
end function

function drainCommands(state)
  output = state.commands
  state.commands = []
  return output
end function
