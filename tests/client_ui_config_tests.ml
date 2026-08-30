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

// Assert the ui config test condition.
function uiConfigAssert(value, name)
  if not value then return error(8302, name) end if
  return true
end function

// Run ui config tests.
function runUiConfigTests()
uiConfigPath = "build/client_ui_config_tests.cfg"
if uiconfigtestfs.exists(uiConfigPath) then uiconfigtestfs.delete(uiConfigPath) end if
uiConfigDefaultInput = uiconfigtestkeys.createInputState()
uiconfigtestkeys.bindDefaultGame(uiConfigDefaultInput)
uiConfigDefaultState = uiconfigtestcommands.create()
uiConfigDefaultMixer = uiconfigtestmixer.create(8000)
uiConfigDefaultScreen = uiconfigtestscreen.create(
  uiconfigtestconsole.create(40), uiconfigtestmenu.create())
uiConfigDefaults = uiconfigtestconfig.decodeProductConfig(
  uiconfigtestconfig.encodeProductConfig(
    uiconfigtestconfig.captureProductConfig(uiConfigDefaultInput,
      uiConfigDefaultState, uiConfigDefaultMixer, uiConfigDefaultScreen)))
uiConfigAssert(uiConfigDefaults.sensitivity == 3.0 and
  uiConfigDefaults.brightness == 1.0 and uiConfigDefaults.maxFps == 90 and
  uiConfigDefaults.swapInterval,
  "integral default floats use decoder-safe archive tokens")
uiConfigInput = uiconfigtestkeys.createInputState()
uiconfigtestkeys.bindDefaultGame(uiConfigInput)
// A complete v2 snapshot must preserve an intentional unbind across the
// base1 -> base2 reconstruction instead of restoring the product default.
uiconfigtestkeys.unbind(uiConfigInput, 55)
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
uiConfigState.maxFps = 144
uiConfigState.swapInterval = false
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
  uiConfigLoaded.maxFps == 144 and not uiConfigLoaded.swapInterval and
  uiConfigLoaded.alwaysRun and uiConfigLoaded.invertMouse and
  uiConfigLoaded.hand == 1 and uiConfigLoaded.crosshair == 3 and
  not uiConfigLoaded.joystick and
  uiConfigLoaded.volume == 0.4 and
  uiConfigLoaded.bindingsComplete, "config disk round trip")

// Simulate stale disk state after base1. The in-memory handover is
// authoritative for the immediate successor map.
uiConfigCaptured.sensitivity = 2.5
uiconfigtestconfig.saveProductConfig(uiConfigPath, uiConfigCaptured)
uiConfigSelected = uiconfigtestconfig.selectProductConfig(
  uiConfigPath, uiConfigLoaded)
uiConfigAssert(uiConfigSelected.sensitivity == 6.5 and
  uiConfigSelected.invertMouse and uiConfigSelected.volume == 0.4,
  "base1-to-base2 in-memory settings handover")

uiConfigApplyInput = uiconfigtestkeys.createInputState()
uiconfigtestkeys.bindDefaultGame(uiConfigApplyInput)
uiConfigApplyState = uiconfigtestcommands.create()
uiConfigApplyMixer = uiconfigtestmixer.create(8000)
uiConfigApplyScreen = uiconfigtestscreen.create(uiconfigtestconsole.create(40),
  uiconfigtestmenu.create())
uiconfigtestconfig.applyProductConfig(uiConfigSelected, uiConfigApplyInput,
  uiConfigApplyState, uiConfigApplyMixer, uiConfigApplyScreen)
uiConfigAssert(uiconfigtestkeys.bindingFor(uiConfigApplyInput, 119) == "+forward" and
  uiconfigtestkeys.bindingFor(uiConfigApplyInput, 200) == "+attack" and
  uiconfigtestkeys.bindingFor(uiConfigApplyInput, 55) == "" and
  uiconfigtestkeys.bindingFor(uiConfigApplyInput, miniquake2.client.ui.constants.K_MWHEELUP) == "weapnext" and
  uiConfigApplyInput.config.hand == 1 and uiConfigApplyInput.config.mousePitch < 0.0 and
  uiConfigApplyState.videoMode == 7 and uiConfigApplyMixer.masterVolume == 0.4 and
  uiConfigApplyState.maxFps == 144 and not uiConfigApplyState.swapInterval and
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
  uiConfigLegacy.crosshair == 1 and uiConfigLegacy.joystick and
  uiConfigLegacy.maxFps == 90 and uiConfigLegacy.swapInterval and
  not uiConfigLegacy.bindingsComplete,
  "legacy config defaults to right hand, normal pitch, crosshair one and controller enabled")
uiConfigV2 = uiconfigtestconfig.decodeProductConfig(
  "MiniQuake2Config 2\nsensitivity 4\ncl_run 1\nm_invert 1\nhand 2\ns_volume 0.5\nvid_mode 6\nvid_fullscreen 1\nvid_gamma 1.4\ncrosshair 2\nin_joystick 0\n")
uiConfigAssert(uiConfigV2.maxFps == 90 and uiConfigV2.swapInterval and
  uiConfigV2.bindingsComplete and uiConfigV2.invertMouse and
  uiConfigV2.hand == 2 and not uiConfigV2.joystick,
  "v2 config upgrades frame pacing without losing complete binding semantics")
uiConfigLegacyInput = uiconfigtestkeys.createInputState()
uiconfigtestkeys.bindDefaultGame(uiConfigLegacyInput)
uiConfigLegacyState = uiconfigtestcommands.create()
uiConfigLegacyMixer = uiconfigtestmixer.create(8000)
uiConfigLegacyScreen = uiconfigtestscreen.create(uiconfigtestconsole.create(40),
  uiconfigtestmenu.create())
uiconfigtestconfig.applyProductConfig(uiConfigLegacy, uiConfigLegacyInput,
  uiConfigLegacyState, uiConfigLegacyMixer, uiConfigLegacyScreen)
uiConfigAssert(uiconfigtestkeys.bindingFor(uiConfigLegacyInput, 55) ==
  "use Rocket Launcher", "v1 binding overrides retain newer defaults")
uiconfigtestfs.delete(uiConfigPath)
return true
end function

runUiConfigTests()
print "client_ui_config_tests: PASS"
