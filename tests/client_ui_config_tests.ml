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
uiconfigtestkeys.bind(uiConfigInput, 200, "+attack")
uiConfigInputSettings = uiConfigInput.config
uiConfigInputSettings.sensitivity = 6.5
uiConfigInputSettings.alwaysRun = true
uiConfigInputSettings.mousePitch = -0.022
uiConfigInputSettings.hand = 1
uiConfigState = uiconfigtestcommands.create()
uiConfigState.videoMode = 2
uiConfigState.fullScreen = true
uiConfigState.brightness = 1.2
uiConfigMixer = uiconfigtestmixer.create(8000)
uiconfigtestmixer.setMasterVolume(uiConfigMixer, 0.4)
uiConfigScreen = uiconfigtestscreen.create(uiconfigtestconsole.create(40),
  uiconfigtestmenu.create())
uiConfigScreen.crosshair = 3

uiConfigCaptured = uiconfigtestconfig.captureProductConfig(uiConfigInput,
  uiConfigState, uiConfigMixer, uiConfigScreen)
uiconfigtestconfig.saveProductConfig(uiConfigPath, uiConfigCaptured)
uiConfigLoaded = uiconfigtestconfig.loadProductConfig(uiConfigPath)
uiConfigAssert(uiConfigLoaded.videoMode == 2 and uiConfigLoaded.fullScreen and
  uiConfigLoaded.brightness == 1.2 and uiConfigLoaded.sensitivity == 6.5 and
  uiConfigLoaded.alwaysRun and uiConfigLoaded.invertMouse and
  uiConfigLoaded.hand == 1 and uiConfigLoaded.crosshair == 3 and
  uiConfigLoaded.volume == 0.4 and
  len(uiConfigLoaded.bindings) == 2, "config disk round trip")

uiConfigApplyInput = uiconfigtestkeys.createInputState()
uiConfigApplyState = uiconfigtestcommands.create()
uiConfigApplyMixer = uiconfigtestmixer.create(8000)
uiConfigApplyScreen = uiconfigtestscreen.create(uiconfigtestconsole.create(40),
  uiconfigtestmenu.create())
uiconfigtestconfig.applyProductConfig(uiConfigLoaded, uiConfigApplyInput,
  uiConfigApplyState, uiConfigApplyMixer, uiConfigApplyScreen)
uiConfigAssert(uiconfigtestkeys.bindingFor(uiConfigApplyInput, 119) == "+forward" and
  uiconfigtestkeys.bindingFor(uiConfigApplyInput, 200) == "+attack" and
  uiConfigApplyInput.config.hand == 1 and uiConfigApplyInput.config.mousePitch < 0.0 and
  uiConfigApplyState.videoMode == 2 and uiConfigApplyMixer.masterVolume == 0.4 and
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
  uiConfigLegacy.crosshair == 1,
  "legacy config defaults to right hand, normal pitch and crosshair one")
uiconfigtestfs.delete(uiConfigPath)
return true
end function

runUiConfigTests()
print "client_ui_config_tests: PASS"
