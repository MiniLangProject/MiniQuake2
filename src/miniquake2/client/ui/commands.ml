//! Provides miniquake2 client ui commands facilities for this project.

/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Product UI command policy joining keys, console, menus and local settings. */
package miniquake2.client.ui.commands

import miniquake2.qcommon.cmd as cuicmdq
import miniquake2.qcommon.byteio as cuicmdbyteio
import miniquake2.qcommon.text as cuicmdtext
import miniquake2.audio.mixer as cuicmdmixer
import miniquake2.client.ui.console as cuicmdconsole
import miniquake2.client.ui.constants as cuicmdconstants
import miniquake2.client.ui.keys as cuicmdkeys
import miniquake2.client.ui.menu as cuicmdmenu
import miniquake2.qcommon.info as cuicmdinfo
import miniquake2.game.constants as cuicmdgameconstants
import miniquake2.runtime.product_startup as cuicmdstartup

/// Store command state data.
struct CommandState
  /// Stores the quit requested value associated with command state.
  quitRequested
  /// Stores the video restart requested value associated with command state.
  videoRestartRequested
  /// Stores the video mode value associated with command state.
  videoMode
  /// Stores the full screen value associated with command state.
  fullScreen
  /// Stores the brightness value associated with command state.
  brightness
  /// Stores the max fps value associated with command state.
  maxFps
  /// Stores the swap interval value associated with command state.
  swapInterval
  /// Stores the save slot value associated with command state.
  saveSlot
  /// Stores the load slot value associated with command state.
  loadSlot
  /// Stores the executed value associated with command state.
  executed
  /// Stores the rejected value associated with command state.
  rejected
  /// Stores the forwarded value associated with command state.
  forwarded
  /// Stores the new game skill value associated with command state.
  newGameSkill
  /// Stores the config dirty value associated with command state.
  configDirty
  /// Stores the player name value associated with command state.
  playerName
  /// Stores the player model value associated with command state.
  playerModel
  /// Stores the player skin value associated with command state.
  playerSkin
  /// Stores the player password value associated with command state.
  playerPassword
  /// Stores the player spectator value associated with command state.
  playerSpectator
  /// Stores the player fov value associated with command state.
  playerFov
  /// Stores the player dirty value associated with command state.
  playerDirty
  /// Stores the connect address value associated with command state.
  connectAddress
  /// Stores the refresh servers value associated with command state.
  refreshServers
  /// Stores the start server requested value associated with command state.
  startServerRequested
  /// Stores the disconnect requested value associated with command state.
  disconnectRequested
  /// Stores the server map value associated with command state.
  serverMap
  /// Stores the server hostname value associated with command state.
  serverHostname
  /// Stores the server rules value associated with command state.
  serverRules
  /// Stores the server max clients value associated with command state.
  serverMaxClients
  /// Stores the server time limit value associated with command state.
  serverTimeLimit
  /// Stores the server frag limit value associated with command state.
  serverFragLimit
  /// Stores the dm flags value associated with command state.
  dmFlags
  /// Stores the allow download value associated with command state.
  allowDownload
  /// Stores the allow download maps value associated with command state.
  allowDownloadMaps
  /// Stores the allow download models value associated with command state.
  allowDownloadModels
  /// Stores the allow download players value associated with command state.
  allowDownloadPlayers
  /// Stores the allow download sounds value associated with command state.
  allowDownloadSounds
  /// Stores the record name value associated with command state.
  recordName
  /// Stores the stop recording requested value associated with command state.
  stopRecordingRequested
  /// Stores the screenshot requested value associated with command state.
  screenshotRequested
  /// Stores the joystick enabled value associated with command state.
  joystickEnabled
  /// Stores the reconnect requested value associated with command state.
  reconnectRequested
  /// Stores the rcon password value associated with command state.
  rconPassword
  /// Stores the rcon address value associated with command state.
  rconAddress
  /// Stores the rcon commands value associated with command state.
  rconCommands
end struct

/// Creates create for the miniquake2 client ui commands module.
function create()
  return CommandState(false, false, 0, false, 1.0, 90, true, -1, -1, 0, 0, [], -1, false,
    "MiniQuake2", "male", "grunt", "", false, 90, false, "", false, false, false,
    "q2dm1", "MiniQuake2", 0, 8, 0, 0, 0, true, true, true, true, true,
    "", false, false, true, false, "", "", [])
end function

/// Return the numeric argument value.
/// @param arguments arguments value consumed by this operation.
/// @param name Name of the affected item.
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

/// Return the integer argument value.
/// @param arguments arguments value consumed by this operation.
/// @param name Name of the affected item.
/// @param minimum minimum value consumed by this operation.
/// @param maximum maximum value consumed by this operation.
function integerArgument(arguments, name, minimum, maximum)
  cuicmdIntegerValue = numericArgument(arguments, name)
  cuicmdInteger = cuicmdbyteio.truncInt(cuicmdIntegerValue)
  if cuicmdIntegerValue != cuicmdInteger or cuicmdInteger < minimum or
      cuicmdInteger > maximum then
    return error(8283, name + " expects an integer inside its valid range")
  end if
  return cuicmdInteger
end function

/// Return the boolean argument value.
/// @param arguments arguments value consumed by this operation.
/// @param name Name of the affected item.
function booleanArgument(arguments, name)
  cuicmdBoolean = integerArgument(arguments, name, 0, 1)
  return cuicmdBoolean != 0
end function

/// Return the player model name.
/// @param index Zero-based index of the affected item.
function playerModelName(index)
  if index == 0 then return "male" end if
  if index == 1 then return "female" end if
  if index == 2 then return "cyborg" end if
  return error(8283, "model index outside retail player models")
end function

/// Return the player skin name.
/// @param model model value consumed by this operation.
/// @param index Zero-based index of the affected item.
function playerSkinName(model, index)
  cuicmdSkinChoices = cuicmdmenu.playerSkinChoices(model)
  if index < 0 or index >= len(cuicmdSkinChoices) then return error(8283, "skin index outside selected model") end if
  return cuicmdSkinChoices[index]
end function

/// Set dm flag.
/// @param commandState commandState value consumed by this operation.
/// @param bit bit value consumed by this operation.
/// @param enabled enabled value consumed by this operation.
function setDmFlag(commandState, bit, enabled)
  if enabled then commandState.dmFlags = commandState.dmFlags | bit
  else commandState.dmFlags = commandState.dmFlags & ~bit end if
  return true
end function

/// `exec default.cfg` in the stock Options menu resets controls and the values
/// displayed by that menu. Keep the operation local and typed so it cannot run
/// arbitrary config text, while applying every setting our Options page owns.
/// @param commandState commandState value consumed by this operation.
/// @param input input value consumed by this operation.
/// @param screen screen value consumed by this operation.
/// @param mixer mixer value consumed by this operation.
function resetOptionDefaults(commandState, input, screen, mixer)
  input.config = cuicmdkeys.defaultConfig()
  input.bindings = []
  cuicmdkeys.bindDefaultGame(input)
  input.captureCommand = ""
  input.capturedKey = -1
  for each cuicmdResetAction in input.actions
    cuicmdResetAction.down = false
    cuicmdResetAction.pressed = false
  end for
  input.mouseDx = 0.0
  input.mouseDy = 0.0
  cuicmdmixer.setMasterVolume(mixer, 0.7)
  screen.crosshair = 1
  commandState.joystickEnabled = true
  commandState.configDirty = true
  commandState.playerDirty = true
  cuicmdResetSensitivity = try(cuicmdmenu.setItemValue(screen.menu,
    "options", "sensitivity", 3.0))
  cuicmdResetInvert = try(cuicmdmenu.setItemValue(screen.menu,
    "options", "invertmouse", 0))
  cuicmdResetRun = try(cuicmdmenu.setItemValue(screen.menu,
    "options", "alwaysrun", 0))
  cuicmdResetVolume = try(cuicmdmenu.setItemValue(screen.menu,
    "options", "volume", 0.7))
  cuicmdResetCrosshair = try(cuicmdmenu.setItemValue(screen.menu,
    "options", "crosshair", 1))
  cuicmdResetJoystick = try(cuicmdmenu.setItemValue(screen.menu,
    "options", "joystick", 1))
  return true
end function

/// Apply commands owned by the client UI and return false only for text that
/// must cross the Game API boundary. Parsing and validation happen before any
/// persistent setting is mutated.
/// @param commandState commandState value consumed by this operation.
/// @param input input value consumed by this operation.
/// @param screen screen value consumed by this operation.
/// @param mixer mixer value consumed by this operation.
/// @param command command value consumed by this operation.
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
    commandState.playerDirty = true
    return true
  end if
  if cuicmdName == "name" then
    if len(cuicmdArguments) != 2 or cuicmdArguments[1] == "" or
        len(bytes(cuicmdArguments[1])) > 15 or
        not cuicmdinfo.componentValid(cuicmdArguments[1]) then
      return error(8283, "name is empty or invalid")
    end if
    commandState.playerName = cuicmdArguments[1]
    commandState.playerDirty = true
    commandState.configDirty = true
    return true
  end if
  if cuicmdName == "model" then
    cuicmdModelIndex = integerArgument(cuicmdArguments, cuicmdName, 0, 2)
    commandState.playerModel = playerModelName(cuicmdModelIndex)
    cuicmdDefaultSkinIndex = 0
    if commandState.playerModel == "male" then cuicmdDefaultSkinIndex = 3 end if
    commandState.playerSkin = playerSkinName(commandState.playerModel,
      cuicmdDefaultSkinIndex)
    commandState.playerDirty = true
    commandState.configDirty = true
    return true
  end if
  if cuicmdName == "skin" then
    cuicmdSkinIndex = integerArgument(cuicmdArguments, cuicmdName, 0, 31)
    commandState.playerSkin = playerSkinName(commandState.playerModel,
      cuicmdSkinIndex)
    commandState.playerDirty = true
    commandState.configDirty = true
    return true
  end if
  if cuicmdName == "password" then
    if len(cuicmdArguments) != 2 or len(bytes(cuicmdArguments[1])) > 63 or
        not cuicmdinfo.componentValid(cuicmdArguments[1]) then
      return error(8283, "password is invalid")
    end if
    commandState.playerPassword = cuicmdArguments[1]
    commandState.playerDirty = true
    commandState.configDirty = true
    return true
  end if
  if cuicmdName == "spectator" then
    commandState.playerSpectator = booleanArgument(cuicmdArguments, cuicmdName)
    commandState.playerDirty = true
    commandState.configDirty = true
    return true
  end if
  if cuicmdName == "fov" then
    commandState.playerFov = integerArgument(cuicmdArguments, cuicmdName, 1, 160)
    commandState.playerDirty = true
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
    if cuicmdModeValue != cuicmdMode or cuicmdMode < 0 or cuicmdMode > 7 then
      return error(8284, "vid_mode outside [0,7]")
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
  if cuicmdName == "in_joystick" then
    commandState.joystickEnabled = booleanArgument(cuicmdArguments,
      cuicmdName)
    commandState.configDirty = true
    return true
  end if
  if cuicmdName == "reset_defaults" then
    if len(cuicmdArguments) != 1 then
      return error(8289, "reset_defaults takes no arguments")
    end if
    return resetOptionDefaults(commandState, input, screen, mixer)
  end if
  if cuicmdName == "go_console" then
    if len(cuicmdArguments) != 1 then
      return error(8289, "go_console takes no arguments")
    end if
    cuicmdconsole.clearTyping(screen.console)
    cuicmdconsole.clearNotify(screen.console)
    screen.menu.active = false
    screen.console.visibleFraction = 0.5
    cuicmdkeys.setDestination(input, cuicmdconstants.KEY_CONSOLE)
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
      cuicmdBindingCommand == "+moveright" or cuicmdBindingCommand == "+left" or
      cuicmdBindingCommand == "+right" or cuicmdBindingCommand == "+speed" or
      cuicmdBindingCommand == "+strafe" or cuicmdBindingCommand == "+lookup" or
      cuicmdBindingCommand == "+lookdown" or cuicmdBindingCommand == "+mlook" or
      cuicmdBindingCommand == "+klook" or cuicmdBindingCommand == "+moveup" or
      cuicmdBindingCommand == "+movedown" or cuicmdBindingCommand == "+attack" or
      cuicmdBindingCommand == "weapnext" or cuicmdBindingCommand == "centerview" or
      cuicmdBindingCommand == "inven" or cuicmdBindingCommand == "invuse" or
      cuicmdBindingCommand == "invdrop" or cuicmdBindingCommand == "invprev" or
      cuicmdBindingCommand == "invnext" or cuicmdBindingCommand == "cmd help"
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
  if cuicmdName == "connect" then
    if len(cuicmdArguments) != 2 then return error(8289, "connect expects one endpoint") end if
    cuicmdConnectEndpoint = cuicmdstartup.parseEndpoint(cuicmdArguments[1])
    commandState.connectAddress = cuicmdstartup.endpointText(cuicmdConnectEndpoint)
    return true
  end if
  if cuicmdName == "net_refresh" then
    if len(cuicmdArguments) != 1 then return error(8289, "net_refresh takes no arguments") end if
    commandState.refreshServers = true
    return true
  end if
  if cuicmdName == "disconnect" then
    if len(cuicmdArguments) != 1 then return error(8289, "disconnect takes no arguments") end if
    commandState.disconnectRequested = true
    return true
  end if
  if cuicmdName == "cl_maxfps" then
    commandState.maxFps = integerArgument(cuicmdArguments, cuicmdName, 30, 1000)
    commandState.configDirty = true
    return true
  end if
  if cuicmdName == "gl_swapinterval" then
    commandState.swapInterval = booleanArgument(cuicmdArguments, cuicmdName)
    commandState.configDirty = true
    return true
  end if
  if cuicmdName == "reconnect" then
    if len(cuicmdArguments) != 1 then return error(8289, "reconnect takes no arguments") end if
    commandState.reconnectRequested = true
    return true
  end if
  if cuicmdName == "rcon_password" then
    if len(cuicmdArguments) != 2 or len(bytes(cuicmdArguments[1])) > 63 or
        not cuicmdinfo.componentValid(cuicmdArguments[1]) then
      return error(8289, "rcon_password is invalid")
    end if
    commandState.rconPassword = cuicmdArguments[1]
    return true
  end if
  if cuicmdName == "rcon_address" then
    if len(cuicmdArguments) != 2 then return error(8289, "rcon_address expects one endpoint") end if
    cuicmdRconEndpoint = cuicmdstartup.parseEndpoint(cuicmdArguments[1])
    commandState.rconAddress = cuicmdstartup.endpointText(cuicmdRconEndpoint)
    return true
  end if
  if cuicmdName == "rcon" then
    cuicmdRconCommand = cuicmdq.argumentTail(command)
    if cuicmdRconCommand == "" then return error(8289, "rcon expects a command") end if
    if commandState.rconPassword == "" then return error(8289, "rcon_password is not configured") end if
    commandState.rconCommands = commandState.rconCommands + [cuicmdRconCommand]
    return true
  end if
  if cuicmdName == "startserver" then
    if len(cuicmdArguments) != 1 then return error(8289, "startserver takes no arguments") end if
    commandState.startServerRequested = true
    return true
  end if
  if cuicmdName == "sv_map" then
    cuicmdMapIndex = integerArgument(cuicmdArguments, cuicmdName, 0, 8)
    cuicmdMaps = ["base1", "q2dm1", "q2dm2", "q2dm3", "q2dm4", "q2dm5",
      "q2dm6", "q2dm7", "q2dm8"]
    commandState.serverMap = cuicmdMaps[cuicmdMapIndex]
    return true
  end if
  if cuicmdName == "sv_rules" then
    commandState.serverRules = integerArgument(cuicmdArguments, cuicmdName, 0, 1)
    return true
  end if
  if cuicmdName == "hostname" then
    if len(cuicmdArguments) != 2 or cuicmdArguments[1] == "" or
        len(bytes(cuicmdArguments[1])) > 63 or
        not cuicmdinfo.componentValid(cuicmdArguments[1]) then
      return error(8283, "hostname is empty or invalid")
    end if
    commandState.serverHostname = cuicmdArguments[1]
    return true
  end if
  if cuicmdName == "sv_maxclients" then
    commandState.serverMaxClients = integerArgument(cuicmdArguments, cuicmdName, 2, 8)
    return true
  end if
  if cuicmdName == "timelimit" then
    commandState.serverTimeLimit = integerArgument(cuicmdArguments, cuicmdName, 0, 60)
    return true
  end if
  if cuicmdName == "fraglimit" then
    commandState.serverFragLimit = integerArgument(cuicmdArguments, cuicmdName, 0, 100)
    return true
  end if
  if cuicmdName == "dm_falling" then
    // The UI is positive while the wire/game bit is DF_NO_FALLING.
    return setDmFlag(commandState, cuicmdgameconstants.DF_NO_FALLING,
      not booleanArgument(cuicmdArguments, cuicmdName))
  end if
  if cuicmdName == "dm_health" then return setDmFlag(commandState,
    cuicmdgameconstants.DF_NO_HEALTH, not booleanArgument(cuicmdArguments, cuicmdName)) end if
  if cuicmdName == "dm_items" then return setDmFlag(commandState,
    cuicmdgameconstants.DF_NO_ITEMS, not booleanArgument(cuicmdArguments, cuicmdName)) end if
  if cuicmdName == "dm_armor" then return setDmFlag(commandState,
    cuicmdgameconstants.DF_NO_ARMOR, not booleanArgument(cuicmdArguments, cuicmdName)) end if
  if cuicmdName == "dm_friendly_fire" then return setDmFlag(commandState,
    cuicmdgameconstants.DF_NO_FRIENDLY_FIRE,
    not booleanArgument(cuicmdArguments, cuicmdName)) end if
  if cuicmdName == "dm_teamplay" then
    cuicmdTeamplay = integerArgument(cuicmdArguments, cuicmdName, 0, 2)
    commandState.dmFlags = commandState.dmFlags &
      ~(cuicmdgameconstants.DF_SKINTEAMS | cuicmdgameconstants.DF_MODELTEAMS)
    if cuicmdTeamplay == 1 then commandState.dmFlags = commandState.dmFlags |
      cuicmdgameconstants.DF_SKINTEAMS end if
    if cuicmdTeamplay == 2 then commandState.dmFlags = commandState.dmFlags |
      cuicmdgameconstants.DF_MODELTEAMS end if
    return true
  end if
  if cuicmdName == "dm_weapons_stay" then return setDmFlag(commandState,
    cuicmdgameconstants.DF_WEAPONS_STAY, booleanArgument(cuicmdArguments, cuicmdName)) end if
  if cuicmdName == "dm_instant_items" then return setDmFlag(commandState,
    cuicmdgameconstants.DF_INSTANT_ITEMS, booleanArgument(cuicmdArguments, cuicmdName)) end if
  if cuicmdName == "dm_same_level" then return setDmFlag(commandState,
    cuicmdgameconstants.DF_SAME_LEVEL, booleanArgument(cuicmdArguments, cuicmdName)) end if
  if cuicmdName == "dm_spawn_farthest" then return setDmFlag(commandState,
    cuicmdgameconstants.DF_SPAWN_FARTHEST, booleanArgument(cuicmdArguments, cuicmdName)) end if
  if cuicmdName == "dm_force_respawn" then return setDmFlag(commandState,
    cuicmdgameconstants.DF_FORCE_RESPAWN, booleanArgument(cuicmdArguments, cuicmdName)) end if
  if cuicmdName == "dm_allow_exit" then return setDmFlag(commandState,
    cuicmdgameconstants.DF_ALLOW_EXIT, booleanArgument(cuicmdArguments, cuicmdName)) end if
  if cuicmdName == "dm_infinite_ammo" then return setDmFlag(commandState,
    cuicmdgameconstants.DF_INFINITE_AMMO, booleanArgument(cuicmdArguments, cuicmdName)) end if
  if cuicmdName == "dm_fixed_fov" then return setDmFlag(commandState,
    cuicmdgameconstants.DF_FIXED_FOV, booleanArgument(cuicmdArguments, cuicmdName)) end if
  if cuicmdName == "dm_quad_drop" then return setDmFlag(commandState,
    cuicmdgameconstants.DF_QUAD_DROP, booleanArgument(cuicmdArguments, cuicmdName)) end if
  if cuicmdName == "allow_download" then commandState.allowDownload = booleanArgument(cuicmdArguments, cuicmdName); commandState.configDirty = true; return true end if
  if cuicmdName == "allow_download_maps" then commandState.allowDownloadMaps = booleanArgument(cuicmdArguments, cuicmdName); commandState.configDirty = true; return true end if
  if cuicmdName == "allow_download_models" then commandState.allowDownloadModels = booleanArgument(cuicmdArguments, cuicmdName); commandState.configDirty = true; return true end if
  if cuicmdName == "allow_download_players" then commandState.allowDownloadPlayers = booleanArgument(cuicmdArguments, cuicmdName); commandState.configDirty = true; return true end if
  if cuicmdName == "allow_download_sounds" then commandState.allowDownloadSounds = booleanArgument(cuicmdArguments, cuicmdName); commandState.configDirty = true; return true end if
  if cuicmdName == "save" or cuicmdName == "load" then
    cuicmdSlotValue = numericArgument(cuicmdArguments, cuicmdName)
    cuicmdSlot = cuicmdbyteio.truncInt(cuicmdSlotValue)
    if cuicmdSlotValue != cuicmdSlot or cuicmdSlot < 0 or cuicmdSlot > 14 then
      return error(8287, cuicmdName + " slot outside [0,14]")
    end if
    if cuicmdName == "save" then commandState.saveSlot = cuicmdSlot
    else commandState.loadSlot = cuicmdSlot end if
    return true
  end if
  if cuicmdName == "inven" then
    screen.showInventory = not screen.showInventory
    return true
  end if
  if cuicmdName == "record" then
    if len(cuicmdArguments) != 2 or cuicmdArguments[1] == "" or
        len(bytes(cuicmdArguments[1])) > 48 then
      return error(8289, "record expects one short demo name")
    end if
    for each cuicmdRecordByte in bytes(cuicmdArguments[1])
      if not ((cuicmdRecordByte >= 48 and cuicmdRecordByte <= 57) or
          (cuicmdRecordByte >= 65 and cuicmdRecordByte <= 90) or
          (cuicmdRecordByte >= 97 and cuicmdRecordByte <= 122) or
          cuicmdRecordByte == 45 or cuicmdRecordByte == 95) then
        return error(8289, "record demo name contains unsafe characters")
      end if
    end for
    commandState.recordName = cuicmdArguments[1]
    return true
  end if
  if cuicmdName == "stop" then
    if len(cuicmdArguments) != 1 then return error(8289, "stop takes no arguments") end if
    commandState.stopRecordingRequested = true
    return true
  end if
  if cuicmdName == "screenshot" then
    if len(cuicmdArguments) != 1 then return error(8289, "screenshot takes no arguments") end if
    commandState.screenshotRequested = true
    return true
  end if
  if cuicmdName == "quit" then
    commandState.quitRequested = true
    return true
  end if
  return false
end function

/// Execute state.
/// @param commandState commandState value consumed by this operation.
/// @param input input value consumed by this operation.
/// @param screen screen value consumed by this operation.
/// @param mixer mixer value consumed by this operation.
/// @param command command value consumed by this operation.
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

/// Drain state.
/// @param commandState commandState value consumed by this operation.
/// @param input input value consumed by this operation.
/// @param screen screen value consumed by this operation.
/// @param mixer mixer value consumed by this operation.
function drain(commandState, input, screen, mixer)
  cuicmdProcessed = 0
  cuicmdKeyPending = cuicmdkeys.drainCommands(input)
  for each cuicmdKeyPendingValue in cuicmdKeyPending
    // User-entered console values are an untrusted runtime boundary. Invalid
    // local settings are counted and ignored without tearing down the game.
    cuicmdKeyPendingResult = try(execute(commandState, input, screen, mixer,
      cuicmdKeyPendingValue))
    cuicmdProcessed = cuicmdProcessed + 1
  end for
  cuicmdConsolePending = cuicmdconsole.drainCommands(screen.console)
  for each cuicmdConsolePendingValue in cuicmdConsolePending
    cuicmdConsolePendingResult = try(execute(commandState, input, screen, mixer,
      cuicmdConsolePendingValue))
    cuicmdProcessed = cuicmdProcessed + 1
  end for
  cuicmdMenuPending = cuicmdmenu.drainCommands(screen.menu)
  for each cuicmdMenuPendingValue in cuicmdMenuPending
    cuicmdMenuPendingResult = try(execute(commandState, input, screen, mixer,
      cuicmdMenuPendingValue))
    cuicmdProcessed = cuicmdProcessed + 1
  end for
  return cuicmdProcessed
end function

/// Consume forwarded.
/// @param commandState commandState value consumed by this operation.
function inline takeForwarded(commandState)
  // Most frames do not forward a console command. Avoid manufacturing a new
  // empty array on every probe while retaining move-style ownership for work.
  if len(commandState.forwarded) == 0 then return commandState.forwarded end if
  cuicmdForwarded = commandState.forwarded
  commandState.forwarded = []
  return cuicmdForwarded
end function

/// Consume save slot.
/// @param commandState commandState value consumed by this operation.
function takeSaveSlot(commandState)
  cuicmdSaveSlot = commandState.saveSlot
  commandState.saveSlot = -1
  return cuicmdSaveSlot
end function

/// Consume load slot.
/// @param commandState commandState value consumed by this operation.
function takeLoadSlot(commandState)
  cuicmdLoadSlot = commandState.loadSlot
  commandState.loadSlot = -1
  return cuicmdLoadSlot
end function

/// Consume new game skill.
/// @param commandState commandState value consumed by this operation.
function takeNewGameSkill(commandState)
  cuicmdNewGameSkill = commandState.newGameSkill
  commandState.newGameSkill = -1
  return cuicmdNewGameSkill
end function

/// Report whether take config dirty.
/// @param commandState commandState value consumed by this operation.
function takeConfigDirty(commandState)
  cuicmdConfigDirty = commandState.configDirty
  commandState.configDirty = false
  return cuicmdConfigDirty
end function

/// Report whether take player dirty.
/// @param commandState commandState value consumed by this operation.
function takePlayerDirty(commandState)
  cuicmdPlayerDirty = commandState.playerDirty
  commandState.playerDirty = false
  return cuicmdPlayerDirty
end function

/// Return the player profile value.
/// @param commandState commandState value consumed by this operation.
/// @param input input value consumed by this operation.
function playerProfile(commandState, input)
  return cuicmdstartup.PlayerProfile(commandState.playerName,
    commandState.playerModel, commandState.playerSkin, input.config.hand, 25000,
    commandState.playerPassword, commandState.playerSpectator,
    commandState.playerFov)
end function

/// Consume connect address.
/// @param commandState commandState value consumed by this operation.
function takeConnectAddress(commandState)
  cuicmdConnectAddress = commandState.connectAddress
  commandState.connectAddress = ""
  return cuicmdConnectAddress
end function

/// Consume refresh servers.
/// @param commandState commandState value consumed by this operation.
function takeRefreshServers(commandState)
  cuicmdRefresh = commandState.refreshServers
  commandState.refreshServers = false
  return cuicmdRefresh
end function

/// Consume start server.
/// @param commandState commandState value consumed by this operation.
function takeStartServer(commandState)
  cuicmdStart = commandState.startServerRequested
  commandState.startServerRequested = false
  return cuicmdStart
end function

/// Consume disconnect.
/// @param commandState commandState value consumed by this operation.
function takeDisconnect(commandState)
  cuicmdDisconnect = commandState.disconnectRequested
  commandState.disconnectRequested = false
  return cuicmdDisconnect
end function

/// Consume reconnect request.
/// @param commandState commandState value consumed by this operation.
function takeReconnect(commandState)
  cuicmdReconnect = commandState.reconnectRequested
  commandState.reconnectRequested = false
  return cuicmdReconnect
end function

/// Consume pending remote-console commands.
/// @param commandState commandState value consumed by this operation.
function takeRconCommands(commandState)
  cuicmdRconCommands = commandState.rconCommands
  commandState.rconCommands = []
  return cuicmdRconCommands
end function

/// Return the server options value.
/// @param commandState commandState value consumed by this operation.
function serverOptions(commandState)
  return cuicmdstartup.ServerOptions(commandState.serverMap,
    commandState.serverHostname, commandState.serverRules == 1,
    commandState.serverMaxClients,
    commandState.serverTimeLimit, commandState.serverFragLimit,
    commandState.dmFlags)
end function

/// Return the download policy value.
/// @param commandState commandState value consumed by this operation.
function downloadPolicy(commandState)
  return cuicmdstartup.DownloadPolicy(commandState.allowDownload,
    commandState.allowDownloadMaps, commandState.allowDownloadModels,
    commandState.allowDownloadPlayers, commandState.allowDownloadSounds)
end function

/// Consume record name.
/// @param commandState commandState value consumed by this operation.
function takeRecordName(commandState)
  cuicmdRecordName = commandState.recordName
  commandState.recordName = ""
  return cuicmdRecordName
end function

/// Consume stop recording.
/// @param commandState commandState value consumed by this operation.
function takeStopRecording(commandState)
  cuicmdStopRecording = commandState.stopRecordingRequested
  commandState.stopRecordingRequested = false
  return cuicmdStopRecording
end function

/// Consume screenshot.
/// @param commandState commandState value consumed by this operation.
function takeScreenshot(commandState)
  cuicmdScreenshot = commandState.screenshotRequested
  commandState.screenshotRequested = false
  return cuicmdScreenshot
end function
