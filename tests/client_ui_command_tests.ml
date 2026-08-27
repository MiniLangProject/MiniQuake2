/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Product UI command draining, local settings and forwarding policy tests. */
import miniquake2.audio.mixer as uicmdtestmixer
import miniquake2.qcommon.constants as uicmdtestqc
import miniquake2.client.ui.commands as uicmdtestcommands
import miniquake2.client.ui.console as uicmdtestconsole
import miniquake2.client.ui.keys as uicmdtestkeys
import miniquake2.client.ui.menu as uicmdtestmenu
import miniquake2.client.ui.screen as uicmdtestscreen
import miniquake2.client.ui.constants as uicmdtestconstants

// Assert the ui command test condition.
function uiCommandAssert(value, name)
  if not value then return error(8289, name) end if
  return true
end function

uiCommandInput = uicmdtestkeys.createInputState()
uiCommandScreen = uicmdtestscreen.create(uicmdtestconsole.create(40), uicmdtestmenu.create())
uiCommandMixer = uicmdtestmixer.create(8000)
uiCommandState = uicmdtestcommands.create()

uiCommandInput.commands = ["+forward 119 10", "sensitivity 4.5", "m_invert 1",
  "cl_run 1", "hand 1", "inven", "say hello"]
uiCommandScreen.console.commands = ["s_volume 0.5", "save 2"]
uiCommandScreen.menu.commands = ["quit", "vid_mode 7", "vid_fullscreen 1",
  "vid_gamma 1.3", "crosshair 3", "vid_restart"]
uiCommandAssert(uicmdtestcommands.drain(uiCommandState, uiCommandInput,
  uiCommandScreen, uiCommandMixer) == 15, "all command sources drained")
uiCommandAssert(uiCommandInput.config.sensitivity == 4.5 and
  uiCommandInput.config.alwaysRun and uiCommandInput.config.hand == 1 and
  uiCommandInput.config.mousePitch < 0.0,
  "input settings applied")
uiCommandAssert(uiCommandScreen.showInventory and uiCommandMixer.masterVolume == 0.5,
  "inventory and volume settings applied")
uiCommandAssert(uiCommandScreen.crosshair == 3, "crosshair setting applied")
uiCommandAssert(uiCommandState.quitRequested and uiCommandState.executed == 15 and
  uiCommandState.rejected == 0, "command counters and quit state")
uiCommandAssert(uiCommandState.videoRestartRequested and uiCommandState.videoMode == 7 and
  uiCommandState.fullScreen and uiCommandState.brightness == 1.3,
  "video menu state retained locally")
uiCommandAssert(uicmdtestcommands.takeConfigDirty(uiCommandState) and
  not uicmdtestcommands.takeConfigDirty(uiCommandState),
  "persistent config dirty state drained atomically")
uiCommandAssert(uicmdtestcommands.takeSaveSlot(uiCommandState) == 2 and
  uicmdtestcommands.takeSaveSlot(uiCommandState) == -1, "save slot request drained")
uiCommandForwarded = uicmdtestcommands.takeForwarded(uiCommandState)
uiCommandAssert(len(uiCommandForwarded) == 1 and uiCommandForwarded[0] == "say hello",
  "only server command forwarded")
uiCommandAssert(len(uicmdtestcommands.takeForwarded(uiCommandState)) == 0,
  "forward queue drained atomically")

uiCommandAssert(uicmdtestcommands.execute(uiCommandState, uiCommandInput,
  uiCommandScreen, uiCommandMixer, "bindcapture +attack"),
  "binding capture command handled locally")
uiCommandAssert(uiCommandInput.captureCommand == "+attack" and
  len(uicmdtestcommands.takeForwarded(uiCommandState)) == 0,
  "binding capture not forwarded")
uiCommandAssert(try(uicmdtestcommands.execute(uiCommandState, uiCommandInput,
  uiCommandScreen, uiCommandMixer, "bindcapture disconnect")) is error,
  "unsafe binding capture rejected")
uiCommandAssert(uicmdtestcommands.execute(uiCommandState, uiCommandInput,
  uiCommandScreen, uiCommandMixer, "newgame hard"), "new game handled locally")
uiCommandAssert(uicmdtestcommands.takeNewGameSkill(uiCommandState) == 2 and
  uicmdtestcommands.takeNewGameSkill(uiCommandState) == -1,
  "new game difficulty drained atomically")
uiCommandAssert(len(uicmdtestcommands.takeForwarded(uiCommandState)) == 0,
  "new game not forwarded as inert server text")

uiCommandAssert(uicmdtestcommands.execute(uiCommandState, uiCommandInput,
  uiCommandScreen, uiCommandMixer, "name Ranger") and
  uicmdtestcommands.execute(uiCommandState, uiCommandInput,
  uiCommandScreen, uiCommandMixer, "model 1") and
  uicmdtestcommands.execute(uiCommandState, uiCommandInput,
  uiCommandScreen, uiCommandMixer, "skin 2"), "player setup commands handled")
uiCommandProfile = uicmdtestcommands.playerProfile(uiCommandState, uiCommandInput)
uiCommandAssert(uiCommandProfile.name == "Ranger" and
  uiCommandProfile.model == "female" and uiCommandProfile.skin == "cobalt" and
  uicmdtestcommands.takePlayerDirty(uiCommandState),
  "player profile retained and dirtiness drained")
uiCommandAssert(uicmdtestcommands.execute(uiCommandState, uiCommandInput,
  uiCommandScreen, uiCommandMixer, "connect 127.0.0.1:27910") and
  uicmdtestcommands.takeConnectAddress(uiCommandState) == "127.0.0.1:27910",
  "join endpoint retained atomically")
uicmdtestcommands.execute(uiCommandState, uiCommandInput, uiCommandScreen,
  uiCommandMixer, "sv_map 3")
uicmdtestcommands.execute(uiCommandState, uiCommandInput, uiCommandScreen,
  uiCommandMixer, "sv_rules 1")
uicmdtestcommands.execute(uiCommandState, uiCommandInput, uiCommandScreen,
  uiCommandMixer, "sv_maxclients 4")
uicmdtestcommands.execute(uiCommandState, uiCommandInput, uiCommandScreen,
  uiCommandMixer, "dm_falling 0")
uicmdtestcommands.execute(uiCommandState, uiCommandInput, uiCommandScreen,
  uiCommandMixer, "startserver")
uiCommandServerOptions = uicmdtestcommands.serverOptions(uiCommandState)
uiCommandAssert(uiCommandServerOptions.mapName == "q2dm3" and
  uiCommandServerOptions.cooperative and uiCommandServerOptions.maxClients == 4 and
  uiCommandServerOptions.dmFlags != 0 and
  uicmdtestcommands.takeStartServer(uiCommandState),
  "start-server and deathmatch options retained")
uicmdtestcommands.execute(uiCommandState, uiCommandInput, uiCommandScreen,
  uiCommandMixer, "allow_download_sounds 0")
uiCommandAssert(not uicmdtestcommands.downloadPolicy(uiCommandState).sounds,
  "download policy retained")
uicmdtestcommands.execute(uiCommandState, uiCommandInput, uiCommandScreen,
  uiCommandMixer, "record parity_test")
uicmdtestcommands.execute(uiCommandState, uiCommandInput, uiCommandScreen,
  uiCommandMixer, "stop")
uicmdtestcommands.execute(uiCommandState, uiCommandInput, uiCommandScreen,
  uiCommandMixer, "screenshot")
uicmdtestcommands.execute(uiCommandState, uiCommandInput, uiCommandScreen,
  uiCommandMixer, "in_joystick 0")
uiCommandAssert(uicmdtestcommands.takeRecordName(uiCommandState) == "parity_test" and
  uicmdtestcommands.takeStopRecording(uiCommandState) and
  uicmdtestcommands.takeScreenshot(uiCommandState) and
  not uiCommandState.joystickEnabled,
  "recording, screenshot and controller intents retained")

uiCommandOldSensitivity = uiCommandInput.config.sensitivity
uiCommandAssert(try(uicmdtestcommands.execute(uiCommandState, uiCommandInput,
  uiCommandScreen, uiCommandMixer, "sensitivity 99")) is error,
  "invalid sensitivity rejected")
uiCommandAssert(uiCommandInput.config.sensitivity == uiCommandOldSensitivity and
  uiCommandState.rejected == 2, "invalid local command did not mutate setting")
uiCommandAssert(try(uicmdtestcommands.execute(uiCommandState, uiCommandInput,
  uiCommandScreen, uiCommandMixer, "hand 7")) is error and
  uiCommandInput.config.hand == 1, "invalid handedness rejected atomically")
uiCommandAssert(try(uicmdtestcommands.execute(uiCommandState, uiCommandInput,
  uiCommandScreen, uiCommandMixer, "m_invert 2")) is error and
  uiCommandInput.config.mousePitch < 0.0, "invalid mouse inversion rejected atomically")

uicmdtestkeys.bind(uiCommandInput, 65, "+attack")
uiCommandInput.config.sensitivity = 12.0
uiCommandInput.config.alwaysRun = true
uiCommandInput.config.mousePitch = -0.05
uiCommandInput.config.hand = 2
uiCommandMixer.masterVolume = 0.1
uiCommandScreen.crosshair = 3
uiCommandState.joystickEnabled = false
uiCommandAssert(uicmdtestcommands.execute(uiCommandState, uiCommandInput,
  uiCommandScreen, uiCommandMixer, "reset_defaults"),
  "reset defaults handled locally")
uiCommandAssert(uiCommandInput.config.sensitivity == 3.0 and
  not uiCommandInput.config.alwaysRun and uiCommandInput.config.mousePitch == 0.022 and
  uiCommandInput.config.hand == 0 and uiCommandMixer.masterVolume == 0.7 and
  uiCommandScreen.crosshair == 1 and uiCommandState.joystickEnabled,
  "reset defaults applies supported option values")
uiCommandAssert(uicmdtestkeys.bindingFor(uiCommandInput, 119) == "+forward" and
  uicmdtestkeys.bindingFor(uiCommandInput, 65) == "" and
  uicmdtestmenu.itemById(uiCommandScreen.menu, "options", "sensitivity").value == 3.0 and
  uicmdtestmenu.itemById(uiCommandScreen.menu, "options", "crosshair").value == 1,
  "reset defaults rebuilds bindings and synchronizes menu values")

uicmdtestconsole.appendLine(uiCommandScreen.console, "old notify", 123)
uiCommandScreen.console.input = "partial"
uiCommandScreen.console.cursor = 7
uicmdtestmenu.open(uiCommandScreen.menu, "options")
uicmdtestkeys.setDestination(uiCommandInput, uicmdtestconstants.KEY_MENU)
uiCommandAssert(uicmdtestcommands.execute(uiCommandState, uiCommandInput,
  uiCommandScreen, uiCommandMixer, "go_console"),
  "go to console handled locally")
uiCommandAssert(uiCommandInput.destination == uicmdtestconstants.KEY_CONSOLE and
  not uiCommandScreen.menu.active and uiCommandScreen.console.visibleFraction == 0.5 and
  uiCommandScreen.console.input == "" and uiCommandScreen.console.cursor == 0 and
  uiCommandScreen.console.lines[len(uiCommandScreen.console.lines) - 1].time < 0,
  "go to console clears typing/notify and transfers key destination")

uiCommandInventoryValues = array(uicmdtestqc.MAX_ITEMS, 0)
uiCommandInventoryValues[2] = 17
uiCommandInventoryValues[8] = 1
uiCommandConfigStrings = array(uicmdtestqc.MAX_CONFIGSTRINGS, "")
uiCommandConfigStrings[uicmdtestqc.CS_ITEMS + 2] = "Shells"
uiCommandConfigStrings[uicmdtestqc.CS_ITEMS + 8] = "Data CD"
uiCommandScreen.showInventory = false
uiCommandAssert(uicmdtestscreen.updateInventory(uiCommandScreen,
  uiCommandInventoryValues, uiCommandConfigStrings, 8) == 2,
  "inventory handoff compacted")
uiCommandAssert(len(uiCommandScreen.inventory) == 2 and
  uiCommandScreen.inventory[0].name == "Shells" and
  uiCommandScreen.inventory[1].count == 1 and
  uiCommandScreen.selectedInventory == 8 and not uiCommandScreen.showInventory,
  "inventory names, selection and visibility applied")
uiCommandAssert(try(uicmdtestscreen.updateInventory(uiCommandScreen,
  [1], uiCommandConfigStrings, 0)) is error, "short inventory rejected")
print("MiniQuake2 client UI command tests passed: 1")
