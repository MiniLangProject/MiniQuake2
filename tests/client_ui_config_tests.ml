/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Strict persistent product settings/bindings round-trip and malformed gate. */
package tests.client_ui_config_tests

import std.fs as uiconfigtestfs
import miniquake2.audio.mixer as uiconfigtestmixer
import miniquake2.client.ui.commands as uiconfigtestcommands
import miniquake2.client.ui.config as uiconfigtestconfig
import miniquake2.client.ui.console as uiconfigtestconsole
import miniquake2.client.ui.keys as uiconfigtestkeys
import miniquake2.client.ui.menu as uiconfigtestmenu
import miniquake2.client.ui.screen as uiconfigtestscreen

function uiConfigAssert(value, name)
  if not value then return error(8302, name) end if
  return true
end function

function runUiConfigTests()
uiConfigPath = "build/client_ui_config_tests.cfg"
if uiconfigtestfs.exists(uiConfigPath) then uiconfigtestfs.delete(uiConfigPath) end if
uiConfigInput = uiconfigtestkeys.createInputState()
uiconfigtestkeys.bind(uiConfigInput, 119, "+forward")
// Exercise the exact controls-menu mutation path: capture owns the next key,
// replaces the prior command binding and leaves a dirty sentinel for the
// product loop to persist before it creates the actual game InputState.
uiconfigtestkeys.bind(uiConfigInput, 201, "+attack")
uiconfigtestkeys.beginBindingCapture(uiConfigInput, "+attack")
uiconfigtestkeys.captureBindingEvent(uiConfigInput, 200)
uiConfigAssert(uiConfigInput.capturedKey == 200 and
  uiconfigtestkeys.bindingFor(uiConfigInput, 201) == "",
  "controls-menu capture did not replace the old binding")
uiConfigInputSettings = uiConfigInput.config
uiConfigInputSettings.sensitivity = 6.5
uiConfigInputSettings.alwaysRun = true
uiConfigInputSettings.mousePitch = -0.022
uiConfigInputSettings.hand = 1
uiConfigState = uiconfigtestcommands.create()
uiConfigState.videoMode = 7
uiConfigState.fullScreen = true
uiConfigState.brightness = 1.2
uiConfigState.joystickEnabled = false
uiConfigMixer = uiconfigtestmixer.create(8000)
uiconfigtestmixer.setMasterVolume(uiConfigMixer, 0.4)
uiConfigScreen = uiconfigtestscreen.create(uiconfigtestconsole.create(40),
  uiconfigtestmenu.create())
uiConfigScreen.crosshair = 3

uiConfigCaptured = uiconfigtestconfig.captureProductConfig(uiConfigInput,
  uiConfigState, uiConfigMixer, uiConfigScreen)
uiconfigtestconfig.saveProductConfig(uiConfigPath, uiConfigCaptured)
uiConfigLoaded = uiconfigtestconfig.loadProductConfig(uiConfigPath)
uiConfigAssert(uiConfigLoaded.videoMode == 7 and uiConfigLoaded.fullScreen and
  uiConfigLoaded.brightness == 1.2 and uiConfigLoaded.sensitivity == 6.5 and
  uiConfigLoaded.alwaysRun and uiConfigLoaded.invertMouse and
  uiConfigLoaded.hand == 1 and uiConfigLoaded.crosshair == 3 and
  not uiConfigLoaded.joystick and
  uiConfigLoaded.volume == 0.4 and
  len(uiConfigLoaded.bindings) == 2, "config disk round trip")

uiConfigApplyInput = uiconfigtestkeys.createInputState()
uiconfigtestkeys.bindDefaultGame(uiConfigApplyInput)
uiConfigApplyState = uiconfigtestcommands.create()
uiConfigApplyMixer = uiconfigtestmixer.create(8000)
uiConfigApplyScreen = uiconfigtestscreen.create(uiconfigtestconsole.create(40),
  uiconfigtestmenu.create())
uiconfigtestconfig.applyProductConfig(uiConfigLoaded, uiConfigApplyInput,
  uiConfigApplyState, uiConfigApplyMixer, uiConfigApplyScreen)
uiConfigAssert(uiconfigtestkeys.bindingFor(uiConfigApplyInput, 119) == "+forward" and
  uiconfigtestkeys.bindingFor(uiConfigApplyInput, 200) == "+attack" and
  uiconfigtestkeys.bindingFor(uiConfigApplyInput, 55) == "use Rocket Launcher" and
  uiconfigtestkeys.bindingFor(uiConfigApplyInput, miniquake2.client.ui.constants.K_MWHEELUP) == "weapnext" and
  uiConfigApplyInput.config.hand == 1 and uiConfigApplyInput.config.mousePitch < 0.0 and
  uiConfigApplyState.videoMode == 7 and uiConfigApplyMixer.masterVolume == 0.4 and
  not uiConfigApplyState.joystickEnabled and
  uiConfigApplyScreen.crosshair == 3,
  "config applied to live product state")

uiConfigAssert(try(uiconfigtestconfig.decodeProductConfig(
  "MiniQuake2Config 1\nsensitivity 3\nsensitivity 4\ncl_run 0\ns_volume 1\nvid_mode 0\nvid_fullscreen 0\nvid_gamma 1\n")) is error,
  "duplicate setting rejected")
uiConfigAssert(try(uiconfigtestconfig.decodeProductConfig(
  "MiniQuake2Config 1\nsensitivity 3\ncl_run 0\ns_volume 1\nvid_mode 0\nvid_fullscreen 0\nvid_gamma 1\nbind 119 \"+forward\"\nbind 119 \"+back\"\n")) is error,
  "duplicate binding rejected")
uiConfigAssert(try(uiconfigtestconfig.decodeProductConfig(
  "MiniQuake2Config 1\nsensitivity 3\ncl_run 0\nhand 3\ns_volume 1\nvid_mode 0\nvid_fullscreen 0\nvid_gamma 1\n")) is error,
  "invalid handedness rejected")
uiConfigLegacy = uiconfigtestconfig.decodeProductConfig(
  "MiniQuake2Config 1\nsensitivity 3\ncl_run 0\ns_volume 1\nvid_mode 0\nvid_fullscreen 0\nvid_gamma 1\n")
uiConfigAssert(uiConfigLegacy.hand == 0 and not uiConfigLegacy.invertMouse and
  uiConfigLegacy.crosshair == 1 and uiConfigLegacy.joystick,
  "legacy config defaults to right hand, normal pitch, crosshair one and controller enabled")
uiconfigtestfs.delete(uiConfigPath)
return true
end function

runUiConfigTests()
print "client_ui_config_tests: PASS"
