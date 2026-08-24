/* Product UI command policy joining keys, console, menus and local settings. */
package miniquake2.client.ui.commands

import miniquake2.qcommon.cmd as cuicmdq
import miniquake2.qcommon.byteio as cuicmdbyteio
import miniquake2.qcommon.text as cuicmdtext
import miniquake2.audio.mixer as cuicmdmixer
import miniquake2.client.ui.console as cuicmdconsole
import miniquake2.client.ui.keys as cuicmdkeys
import miniquake2.client.ui.menu as cuicmdmenu

struct CommandState
  quitRequested
  videoRestartRequested
  videoMode
  fullScreen
  brightness
  saveSlot
  loadSlot
  executed
  rejected
  forwarded
  newGameSkill
  configDirty
end struct

function create()
  return CommandState(false, false, 0, false, 1.0, -1, -1, 0, 0, [], -1, false)
end function

function numericArgument(arguments, name)
  if len(arguments) != 2 then return error(8280, name + " expects one numeric value") end if
  cuicmdNumberResult = try(toNumber(arguments[1]))
  if cuicmdNumberResult is error or
      (typeof(cuicmdNumberResult) != "int" and typeof(cuicmdNumberResult) != "float") then
    return error(8280, name + " expects one numeric value")
  end if
  if cuicmdNumberResult != cuicmdNumberResult then return error(8280, name + " expects a finite numeric value") end if
  return cuicmdNumberResult
end function

function localAction(commandState, input, screen, mixer, command)
  if typeof(command) != "string" then return error(8281, "UI command must be text") end if
  cuicmdArguments = cuicmdq.tokenize(command)
  if len(cuicmdArguments) == 0 then return false end if
  cuicmdName = cuicmdtext.lower(cuicmdArguments[0])

  // Key state is updated when the event is received. Its generated +/− text
  // is retained for compatibility/debugging but must not be sent a second
  // time to the game server.
  cuicmdNameBytes = bytes(cuicmdName)
  if len(cuicmdNameBytes) > 0 and
      (cuicmdNameBytes[0] == 43 or cuicmdNameBytes[0] == 45) then return true end if

  if cuicmdName == "sensitivity" then
    cuicmdSensitivity = numericArgument(cuicmdArguments, cuicmdName)
    if cuicmdSensitivity < 1.0 or cuicmdSensitivity > 20.0 then
      return error(8282, "sensitivity outside [1,20]")
    end if
    input.config.sensitivity = cuicmdSensitivity * 1.0
    commandState.configDirty = true
    return true
  end if
  if cuicmdName == "m_invert" then
    cuicmdInvert = numericArgument(cuicmdArguments, cuicmdName)
    if cuicmdInvert != 0 and cuicmdInvert != 1 and
        cuicmdInvert != 0.0 and cuicmdInvert != 1.0 then
      return error(8283, "m_invert expects 0 or 1")
    end if
    cuicmdPitch = input.config.mousePitch
    if cuicmdPitch < 0.0 then cuicmdPitch = -cuicmdPitch end if
    if cuicmdInvert != 0 then input.config.mousePitch = -cuicmdPitch
    else input.config.mousePitch = cuicmdPitch
    end if
    commandState.configDirty = true
    return true
  end if
  if cuicmdName == "cl_run" then
    cuicmdAlwaysRun = numericArgument(cuicmdArguments, cuicmdName)
    if cuicmdAlwaysRun != 0 and cuicmdAlwaysRun != 1 and
        cuicmdAlwaysRun != 0.0 and cuicmdAlwaysRun != 1.0 then
      return error(8283, "cl_run expects 0 or 1")
    end if
    input.config.alwaysRun = cuicmdAlwaysRun != 0
    commandState.configDirty = true
    return true
  end if
  if cuicmdName == "hand" then
    cuicmdHandValue = numericArgument(cuicmdArguments, cuicmdName)
    cuicmdHand = cuicmdbyteio.truncInt(cuicmdHandValue)
    if cuicmdHandValue != cuicmdHand or cuicmdHand < 0 or cuicmdHand > 2 then
      return error(8283, "hand expects 0, 1 or 2")
    end if
    input.config.hand = cuicmdHand
    commandState.configDirty = true
    return true
  end if
  if cuicmdName == "s_volume" then
    cuicmdVolume = numericArgument(cuicmdArguments, cuicmdName)
    cuicmdmixer.setMasterVolume(mixer, cuicmdVolume)
    commandState.configDirty = true
    return true
  end if
  if cuicmdName == "vid_mode" then
    cuicmdModeValue = numericArgument(cuicmdArguments, cuicmdName)
    cuicmdMode = cuicmdbyteio.truncInt(cuicmdModeValue)
    if cuicmdModeValue != cuicmdMode or cuicmdMode < 0 or cuicmdMode > 3 then
      return error(8284, "vid_mode outside [0,3]")
    end if
    commandState.videoMode = cuicmdMode
    commandState.configDirty = true
    return true
  end if
  if cuicmdName == "vid_fullscreen" then
    cuicmdFullScreen = numericArgument(cuicmdArguments, cuicmdName)
    if cuicmdFullScreen != 0 and cuicmdFullScreen != 1 and
        cuicmdFullScreen != 0.0 and cuicmdFullScreen != 1.0 then
      return error(8285, "vid_fullscreen expects 0 or 1")
    end if
    commandState.fullScreen = cuicmdFullScreen != 0
    commandState.configDirty = true
    return true
  end if
  if cuicmdName == "vid_gamma" then
    cuicmdBrightness = numericArgument(cuicmdArguments, cuicmdName)
    if cuicmdBrightness < 0.5 or cuicmdBrightness > 2.0 then
      return error(8286, "vid_gamma outside [0.5,2]")
    end if
    commandState.brightness = cuicmdBrightness * 1.0
    commandState.configDirty = true
    return true
  end if
  if cuicmdName == "crosshair" then
    cuicmdCrosshairValue = numericArgument(cuicmdArguments, cuicmdName)
    cuicmdCrosshair = cuicmdbyteio.truncInt(cuicmdCrosshairValue)
    if cuicmdCrosshairValue != cuicmdCrosshair or cuicmdCrosshair < 0 or
        cuicmdCrosshair > 3 then
      return error(8286, "crosshair outside [0,3]")
    end if
    screen.crosshair = cuicmdCrosshair
    commandState.configDirty = true
    return true
  end if
  if cuicmdName == "vid_restart" then
    commandState.videoRestartRequested = true
    return true
  end if
  if cuicmdName == "bindcapture" then
    if len(cuicmdArguments) != 2 then return error(8288, "bindcapture expects one command") end if
    cuicmdBindingCommand = cuicmdArguments[1]
    cuicmdBindingAllowed = cuicmdBindingCommand == "+forward" or
      cuicmdBindingCommand == "+back" or cuicmdBindingCommand == "+moveleft" or
      cuicmdBindingCommand == "+moveright" or cuicmdBindingCommand == "+moveup" or
      cuicmdBindingCommand == "+attack" or cuicmdBindingCommand == "+use" or
      cuicmdBindingCommand == "inven"
    if not cuicmdBindingAllowed then return error(8288, "bindcapture command is not allowed") end if
    cuicmdkeys.beginBindingCapture(input, cuicmdBindingCommand)
    return true
  end if
  if cuicmdName == "newgame" then
    if len(cuicmdArguments) != 2 then return error(8289, "newgame expects a difficulty") end if
    cuicmdDifficulty = cuicmdtext.lower(cuicmdArguments[1])
    if cuicmdDifficulty == "easy" then commandState.newGameSkill = 0
    else if cuicmdDifficulty == "medium" then commandState.newGameSkill = 1
    else if cuicmdDifficulty == "hard" then commandState.newGameSkill = 2
    else return error(8289, "newgame difficulty must be easy, medium or hard") end if
    return true
  end if
  if cuicmdName == "save" or cuicmdName == "load" then
    cuicmdSlotValue = numericArgument(cuicmdArguments, cuicmdName)
    cuicmdSlot = cuicmdbyteio.truncInt(cuicmdSlotValue)
    if cuicmdSlotValue != cuicmdSlot or cuicmdSlot < 0 or cuicmdSlot > 2 then
      return error(8287, cuicmdName + " slot outside [0,2]")
    end if
    if cuicmdName == "save" then commandState.saveSlot = cuicmdSlot
    else commandState.loadSlot = cuicmdSlot end if
    return true
  end if
  if cuicmdName == "inven" then
    screen.showInventory = not screen.showInventory
    return true
  end if
  if cuicmdName == "quit" then
    commandState.quitRequested = true
    return true
  end if
  return false
end function

function execute(commandState, input, screen, mixer, command)
  cuicmdHandled = try(localAction(commandState, input, screen, mixer, command))
  commandState.executed = commandState.executed + 1
  if cuicmdHandled is error then
    commandState.rejected = commandState.rejected + 1
    return cuicmdHandled
  end if
  if not cuicmdHandled then commandState.forwarded = commandState.forwarded + [command] end if
  return cuicmdHandled
end function

function drain(commandState, input, screen, mixer)
  cuicmdPending = cuicmdkeys.drainCommands(input)
  cuicmdPending = cuicmdPending + cuicmdconsole.drainCommands(screen.console)
  cuicmdPending = cuicmdPending + cuicmdmenu.drainCommands(screen.menu)
  cuicmdProcessed = 0
  for each cuicmdPendingValue in cuicmdPending
    // User-entered console values are an untrusted runtime boundary. Invalid
    // local settings are counted and ignored without tearing down the game.
    cuicmdPendingResult = try(execute(commandState, input, screen, mixer, cuicmdPendingValue))
    cuicmdProcessed = cuicmdProcessed + 1
  end for
  return cuicmdProcessed
end function

function takeForwarded(commandState)
  cuicmdForwarded = commandState.forwarded
  commandState.forwarded = []
  return cuicmdForwarded
end function

function takeSaveSlot(commandState)
  cuicmdSaveSlot = commandState.saveSlot
  commandState.saveSlot = -1
  return cuicmdSaveSlot
end function

function takeLoadSlot(commandState)
  cuicmdLoadSlot = commandState.loadSlot
  commandState.loadSlot = -1
  return cuicmdLoadSlot
end function

function takeNewGameSkill(commandState)
  cuicmdNewGameSkill = commandState.newGameSkill
  commandState.newGameSkill = -1
  return cuicmdNewGameSkill
end function

function takeConfigDirty(commandState)
  cuicmdConfigDirty = commandState.configDirty
  commandState.configDirty = false
  return cuicmdConfigDirty
end function
