/* Strict persistent product settings and key bindings. */
package miniquake2.client.ui.config

import std.fs as uiconfigfs
import std.string as uiconfigstring
import miniquake2.qcommon.cmd as uiconfigcmd
import miniquake2.qcommon.byteio as uiconfigbyteio
import miniquake2.client.ui.constants as uiconfigconstants
import miniquake2.client.ui.keys as uiconfigkeys
import miniquake2.audio.mixer as uiconfigmixer

const CONFIG_HEADER = "MiniQuake2Config 1"
const CONFIG_MAX_BYTES = 65536
const CONFIG_MAX_LINES = 512
const CONFIG_MAX_BINDINGS = 256

struct ProductConfig
  sensitivity
  alwaysRun
  invertMouse
  hand
  volume
  videoMode
  fullScreen
  brightness
  crosshair
  bindings
end struct

function productConfigSafeCommand(command)
  if typeof(command) != "string" or command == "" or len(bytes(command)) > 255 then
    return false
  end if
  for each productConfigCommandByte in bytes(command)
    if productConfigCommandByte < 32 or productConfigCommandByte == 34 then return false end if
  end for
  return true
end function

function productConfigValidate(config)
  if typeof(config) != "struct" or
      (typeof(config.sensitivity) != "int" and typeof(config.sensitivity) != "float") or
      config.sensitivity < 1.0 or config.sensitivity > 20.0 or
      typeof(config.alwaysRun) != "bool" or
      typeof(config.invertMouse) != "bool" or
      typeof(config.hand) != "int" or config.hand < 0 or config.hand > 2 or
      (typeof(config.volume) != "int" and typeof(config.volume) != "float") or
      config.volume < 0.0 or config.volume > 1.0 or
      typeof(config.videoMode) != "int" or config.videoMode < 0 or config.videoMode > 3 or
      typeof(config.fullScreen) != "bool" or
      (typeof(config.brightness) != "int" and typeof(config.brightness) != "float") or
      config.brightness < 0.5 or config.brightness > 2.0 or
      typeof(config.crosshair) != "int" or config.crosshair < 0 or
      config.crosshair > 3 or
      typeof(config.bindings) != "array" or len(config.bindings) > CONFIG_MAX_BINDINGS then
    return error(8290, "product config fields are invalid")
  end if
  productConfigSeenKeys = array(uiconfigconstants.MAX_KEYS, false)
  for each productConfigBinding in config.bindings
    if typeof(productConfigBinding) != "struct" or typeof(productConfigBinding.key) != "int" or
        productConfigBinding.key < 0 or productConfigBinding.key >= uiconfigconstants.MAX_KEYS or
        not productConfigSafeCommand(productConfigBinding.command) or
        productConfigSeenKeys[productConfigBinding.key] then
      return error(8291, "product config binding is invalid or duplicated")
    end if
    productConfigSeenKeys[productConfigBinding.key] = true
  end for
  return config
end function

function captureProductConfig(input, commandState, mixer, screen)
  productConfigBindings = []
  for each productConfigInputBinding in input.bindings
    productConfigBindings = productConfigBindings + [
      miniquake2.client.ui.types.Binding(productConfigInputBinding.key,
        productConfigInputBinding.command)]
  end for
  productConfigInvertMouse = input.config.mousePitch < 0.0
  productConfigCaptured = ProductConfig(input.config.sensitivity,
    input.config.alwaysRun, productConfigInvertMouse, input.config.hand,
    mixer.masterVolume, commandState.videoMode, commandState.fullScreen,
    commandState.brightness, screen.crosshair, productConfigBindings)
  return productConfigValidate(productConfigCaptured)
end function

function encodeProductConfig(config)
  productConfigValue = productConfigValidate(config)
  productConfigRunValue = 0
  if productConfigValue.alwaysRun then productConfigRunValue = 1 end if
  productConfigInvertValue = 0
  if productConfigValue.invertMouse then productConfigInvertValue = 1 end if
  productConfigFullscreenValue = 0
  if productConfigValue.fullScreen then productConfigFullscreenValue = 1 end if
  productConfigText = CONFIG_HEADER + "\n" +
    "sensitivity " + productConfigValue.sensitivity + "\n" +
    "cl_run " + productConfigRunValue + "\n" +
    "m_invert " + productConfigInvertValue + "\n" +
    "hand " + productConfigValue.hand + "\n" +
    "s_volume " + productConfigValue.volume + "\n" +
    "vid_mode " + productConfigValue.videoMode + "\n" +
    "vid_fullscreen " + productConfigFullscreenValue + "\n" +
    "vid_gamma " + productConfigValue.brightness + "\n" +
    "crosshair " + productConfigValue.crosshair + "\n"
  for each productConfigWriteBinding in productConfigValue.bindings
    productConfigText = productConfigText + "bind " + productConfigWriteBinding.key +
      " \"" + productConfigWriteBinding.command + "\"\n"
  end for
  if len(bytes(productConfigText)) > CONFIG_MAX_BYTES then
    return error(8292, "encoded product config exceeds size limit")
  end if
  return productConfigText
end function

function productConfigNumber(token, name)
  productConfigNumberResult = try(toNumber(token))
  if productConfigNumberResult is error or
      (typeof(productConfigNumberResult) != "int" and
       typeof(productConfigNumberResult) != "float") or
      productConfigNumberResult != productConfigNumberResult then
    return error(8293, name + " requires a finite number")
  end if
  return productConfigNumberResult
end function

function decodeProductConfig(text)
  if typeof(text) != "string" or len(bytes(text)) == 0 or
      len(bytes(text)) > CONFIG_MAX_BYTES then
    return error(8294, "product config text is empty or too large")
  end if
  productConfigLines = uiconfigstring.split(text, "\n")
  if typeof(productConfigLines) != "array" or len(productConfigLines) < 7 or
      len(productConfigLines) > CONFIG_MAX_LINES or
      uiconfigstring.trim(productConfigLines[0]) != CONFIG_HEADER then
    return error(8295, "product config header or line count is invalid")
  end if
  productConfigSensitivity = void
  productConfigRun = void
  productConfigInvert = void
  productConfigHand = void
  productConfigVolume = void
  productConfigMode = void
  productConfigFullscreen = void
  productConfigGamma = void
  productConfigCrosshair = void
  productConfigBindings = []
  productConfigLineIndex = 1
  while productConfigLineIndex < len(productConfigLines)
    productConfigLine = uiconfigstring.trim(productConfigLines[productConfigLineIndex])
    productConfigLineIndex = productConfigLineIndex + 1
    if productConfigLine == "" then continue end if
    productConfigTokens = uiconfigcmd.tokenize(productConfigLine)
    if len(productConfigTokens) == 0 then continue end if
    productConfigName = productConfigTokens[0]
    if productConfigName == "bind" then
      if len(productConfigTokens) != 3 or len(productConfigBindings) >= CONFIG_MAX_BINDINGS then
        return error(8296, "product config bind line is invalid")
      end if
      productConfigKeyNumber = productConfigNumber(productConfigTokens[1], "bind key")
      productConfigKey = uiconfigbyteio.truncInt(productConfigKeyNumber)
      if productConfigKeyNumber != productConfigKey then
        return error(8296, "product config bind key must be an integer")
      end if
      productConfigBindings = productConfigBindings + [
        miniquake2.client.ui.types.Binding(productConfigKey, productConfigTokens[2])]
    else
      if len(productConfigTokens) != 2 then return error(8297, "product config setting line is invalid") end if
      productConfigSetting = productConfigNumber(productConfigTokens[1], productConfigName)
      if productConfigName == "sensitivity" and productConfigSensitivity is void then
        productConfigSensitivity = productConfigSetting * 1.0
      else if productConfigName == "cl_run" and productConfigRun is void and
          (productConfigSetting == 0 or productConfigSetting == 1) then
        productConfigRun = productConfigSetting != 0
      else if productConfigName == "m_invert" and productConfigInvert is void and
          (productConfigSetting == 0 or productConfigSetting == 1) then
        productConfigInvert = productConfigSetting != 0
      else if productConfigName == "hand" and productConfigHand is void then
        productConfigHand = uiconfigbyteio.truncInt(productConfigSetting)
        if productConfigSetting != productConfigHand or productConfigHand < 0 or
            productConfigHand > 2 then return error(8297, "hand must be 0, 1 or 2") end if
      else if productConfigName == "s_volume" and productConfigVolume is void then
        productConfigVolume = productConfigSetting * 1.0
      else if productConfigName == "vid_mode" and productConfigMode is void then
        productConfigMode = uiconfigbyteio.truncInt(productConfigSetting)
        if productConfigSetting != productConfigMode then return error(8297, "vid_mode must be an integer") end if
      else if productConfigName == "vid_fullscreen" and productConfigFullscreen is void and
          (productConfigSetting == 0 or productConfigSetting == 1) then
        productConfigFullscreen = productConfigSetting != 0
      else if productConfigName == "vid_gamma" and productConfigGamma is void then
        productConfigGamma = productConfigSetting * 1.0
      else if productConfigName == "crosshair" and productConfigCrosshair is void then
        productConfigCrosshair = uiconfigbyteio.truncInt(productConfigSetting)
        if productConfigSetting != productConfigCrosshair or productConfigCrosshair < 0 or
            productConfigCrosshair > 3 then
          return error(8297, "crosshair must be an integer from 0 to 3")
        end if
      else return error(8298, "unknown, duplicate or invalid product config setting") end if
    end if
  end while
  if productConfigSensitivity is void or productConfigRun is void or
      productConfigVolume is void or productConfigMode is void or
      productConfigFullscreen is void or productConfigGamma is void then
    return error(8299, "product config is missing required settings")
  end if
  // Config v1 predates persisted handedness, mouse inversion and crosshair.
  // Preserve those files with the product defaults instead of rejecting them.
  if productConfigHand is void then productConfigHand = 0 end if
  if productConfigInvert is void then productConfigInvert = false end if
  if productConfigCrosshair is void then productConfigCrosshair = 1 end if
  return productConfigValidate(ProductConfig(productConfigSensitivity,
    productConfigRun, productConfigInvert, productConfigHand, productConfigVolume,
    productConfigMode, productConfigFullscreen, productConfigGamma,
    productConfigCrosshair, productConfigBindings))
end function

function applyProductConfig(config, input, commandState, mixer, screen)
  productConfigApply = productConfigValidate(config)
  input.config.sensitivity = productConfigApply.sensitivity
  input.config.alwaysRun = productConfigApply.alwaysRun
  productConfigPitch = input.config.mousePitch
  if productConfigPitch < 0.0 then productConfigPitch = -productConfigPitch end if
  if productConfigApply.invertMouse then input.config.mousePitch = -productConfigPitch
  else input.config.mousePitch = productConfigPitch
  end if
  input.config.hand = productConfigApply.hand
  commandState.videoMode = productConfigApply.videoMode
  commandState.fullScreen = productConfigApply.fullScreen
  commandState.brightness = productConfigApply.brightness
  screen.crosshair = productConfigApply.crosshair
  uiconfigmixer.setMasterVolume(mixer, productConfigApply.volume)
  input.bindings = []
  for each productConfigApplyBinding in productConfigApply.bindings
    uiconfigkeys.bind(input, productConfigApplyBinding.key,
      productConfigApplyBinding.command)
  end for
  return true
end function

function saveProductConfig(path, config)
  if typeof(path) != "string" or path == "" then return error(8300, "product config path is missing") end if
  productConfigEncoded = encodeProductConfig(config)
  productConfigTemporaryPath = path + ".tmp"
  uiconfigfs.writeAllText(productConfigTemporaryPath, productConfigEncoded)
  productConfigVerified = decodeProductConfig(uiconfigfs.readAllText(productConfigTemporaryPath))
  if len(productConfigVerified.bindings) != len(config.bindings) then
    uiconfigfs.delete(productConfigTemporaryPath)
    return error(8301, "product config temporary verification failed")
  end if
  return uiconfigfs.moveFile(productConfigTemporaryPath, path, true)
end function

function loadProductConfig(path)
  if typeof(path) != "string" or path == "" then return error(8300, "product config path is missing") end if
  if not uiconfigfs.exists(path) then return void end if
  return decodeProductConfig(uiconfigfs.readAllText(path))
end function
