/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Strict persistent product settings and key bindings. */
package miniquake2.client.ui.config

import std.fs as uiconfigfs
import std.string as uiconfigstring
import miniquake2.qcommon.cmd as uiconfigcmd
import miniquake2.qcommon.byteio as uiconfigbyteio
import miniquake2.client.ui.constants as uiconfigconstants
import miniquake2.client.ui.keys as uiconfigkeys
import miniquake2.audio.mixer as uiconfigmixer

const CONFIG_HEADER = "MiniQuake2Config 3"
const CONFIG_V2_HEADER = "MiniQuake2Config 2"
const CONFIG_LEGACY_HEADER = "MiniQuake2Config 1"
const CONFIG_MAX_BYTES = 65536
const CONFIG_MAX_LINES = 512
const CONFIG_MAX_BINDINGS = 256

// Store product config data.
struct ProductConfig
  sensitivity
  alwaysRun
  invertMouse
  hand
  volume
  videoMode
  fullScreen
  brightness
  maxFps
  swapInterval
  crosshair
  joystick
  bindings
  bindingsComplete
end struct

// Return the product config safe command value.
function productConfigSafeCommand(command)
  if typeof(command) != "string" or command == "" or len(bytes(command)) > 255 then
    return false
  end if
  for each productConfigCommandByte in bytes(command)
    if productConfigCommandByte < 32 or productConfigCommandByte == 34 then return false end if
  end for
  return true
end function

// Validate product config.
function productConfigValidate(config)
  if typeof(config) != "struct" or
      (typeof(config.sensitivity) != "int" and typeof(config.sensitivity) != "float") or
      config.sensitivity < 1.0 or config.sensitivity > 20.0 or
      typeof(config.alwaysRun) != "bool" or
      typeof(config.invertMouse) != "bool" or
      typeof(config.hand) != "int" or config.hand < 0 or config.hand > 2 or
      (typeof(config.volume) != "int" and typeof(config.volume) != "float") or
      config.volume < 0.0 or config.volume > 1.0 or
      typeof(config.videoMode) != "int" or config.videoMode < 0 or config.videoMode > 7 or
      typeof(config.fullScreen) != "bool" or
      (typeof(config.brightness) != "int" and typeof(config.brightness) != "float") or
      config.brightness < 0.5 or config.brightness > 2.0 or
      typeof(config.maxFps) != "int" or config.maxFps < 30 or
      config.maxFps > 1000 or typeof(config.swapInterval) != "bool" or
      typeof(config.crosshair) != "int" or config.crosshair < 0 or
      config.crosshair > 3 or
      typeof(config.joystick) != "bool" or
      typeof(config.bindings) != "array" or len(config.bindings) > CONFIG_MAX_BINDINGS or
      typeof(config.bindingsComplete) != "bool" then
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

// Capture product config.
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
    commandState.brightness, commandState.maxFps, commandState.swapInterval,
    screen.crosshair, commandState.joystickEnabled,
    productConfigBindings, true)
  return productConfigValidate(productConfigCaptured)
end function

// MiniLang renders an integral float as `3.`. The command tokenizer's numeric
// grammar deliberately rejects that spelling, so archive integral values as
// integers and retain the ordinary representation only for fractional values.
function productConfigEncodedNumber(value)
  productConfigInteger = uiconfigbyteio.truncInt(value)
  if value == productConfigInteger then return productConfigInteger end if
  return value
end function

// Encode product config.
function encodeProductConfig(config)
  // Validate the typed snapshot, encode booleans as retail-style numeric
  // cvars, then append the variable-length binding section.
  productConfigValue = productConfigValidate(config)
  productConfigRunValue = 0
  if productConfigValue.alwaysRun then productConfigRunValue = 1 end if
  productConfigInvertValue = 0
  if productConfigValue.invertMouse then productConfigInvertValue = 1 end if
  productConfigFullscreenValue = 0
  if productConfigValue.fullScreen then productConfigFullscreenValue = 1 end if
  productConfigJoystickValue = 0
  if productConfigValue.joystick then productConfigJoystickValue = 1 end if
  productConfigSwapIntervalValue = 0
  if productConfigValue.swapInterval then productConfigSwapIntervalValue = 1 end if
  productConfigText = CONFIG_HEADER + "\n" +
    "sensitivity " + productConfigEncodedNumber(
      productConfigValue.sensitivity) + "\n" +
    "cl_run " + productConfigRunValue + "\n" +
    "m_invert " + productConfigInvertValue + "\n" +
    "hand " + productConfigValue.hand + "\n" +
    "s_volume " + productConfigEncodedNumber(productConfigValue.volume) + "\n" +
    "vid_mode " + productConfigValue.videoMode + "\n" +
    "vid_fullscreen " + productConfigFullscreenValue + "\n" +
    "vid_gamma " + productConfigEncodedNumber(
      productConfigValue.brightness) + "\n" +
    "cl_maxfps " + productConfigValue.maxFps + "\n" +
    "gl_swapinterval " + productConfigSwapIntervalValue + "\n" +
    "crosshair " + productConfigValue.crosshair + "\n"
  productConfigText = productConfigText + "in_joystick " +
    productConfigJoystickValue + "\n"
  for each productConfigWriteBinding in productConfigValue.bindings
    productConfigText = productConfigText + "bind " + productConfigWriteBinding.key +
      " \"" + productConfigWriteBinding.command + "\"\n"
  end for
  if len(bytes(productConfigText)) > CONFIG_MAX_BYTES then
    return error(8292, "encoded product config exceeds size limit")
  end if
  return productConfigText
end function

// Return the product config number.
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

// Decode product config.
function decodeProductConfig(text)
  if typeof(text) != "string" or len(bytes(text)) == 0 or
      len(bytes(text)) > CONFIG_MAX_BYTES then
    return error(8294, "product config text is empty or too large")
  end if
  productConfigLines = uiconfigstring.split(text, "\n")
  productConfigHeader = uiconfigstring.trim(productConfigLines[0])
  if typeof(productConfigLines) != "array" or len(productConfigLines) < 7 or
      len(productConfigLines) > CONFIG_MAX_LINES or
      (productConfigHeader != CONFIG_HEADER and productConfigHeader != CONFIG_V2_HEADER and
       productConfigHeader != CONFIG_LEGACY_HEADER) then
    return error(8295, "product config header or line count is invalid")
  end if
  productConfigBindingsComplete = productConfigHeader != CONFIG_LEGACY_HEADER
  productConfigSensitivity = void
  productConfigRun = void
  productConfigInvert = void
  productConfigHand = void
  productConfigVolume = void
  productConfigMode = void
  productConfigFullscreen = void
  productConfigGamma = void
  productConfigMaxFps = void
  productConfigSwapInterval = void
  productConfigCrosshair = void
  productConfigJoystick = void
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
      else if productConfigName == "cl_maxfps" and productConfigMaxFps is void then
        productConfigMaxFps = uiconfigbyteio.truncInt(productConfigSetting)
        if productConfigSetting != productConfigMaxFps or productConfigMaxFps < 30 or
            productConfigMaxFps > 1000 then
          return error(8297, "cl_maxfps must be an integer inside [30,1000]")
        end if
      else if productConfigName == "gl_swapinterval" and
          productConfigSwapInterval is void and
          (productConfigSetting == 0 or productConfigSetting == 1) then
        productConfigSwapInterval = productConfigSetting != 0
      else if productConfigName == "crosshair" and productConfigCrosshair is void then
        productConfigCrosshair = uiconfigbyteio.truncInt(productConfigSetting)
        if productConfigSetting != productConfigCrosshair or productConfigCrosshair < 0 or
            productConfigCrosshair > 3 then
          return error(8297, "crosshair must be an integer from 0 to 3")
        end if
      else if productConfigName == "in_joystick" and productConfigJoystick is void and
          (productConfigSetting == 0 or productConfigSetting == 1) then
        productConfigJoystick = productConfigSetting != 0
      else return error(8298, "unknown, duplicate or invalid product config setting") end if
    end if
  end while
  if productConfigSensitivity is void or productConfigRun is void or
      productConfigVolume is void or productConfigMode is void or
      productConfigFullscreen is void or productConfigGamma is void or
      (productConfigHeader == CONFIG_HEADER and
       (productConfigMaxFps is void or productConfigSwapInterval is void)) then
    return error(8299, "product config is missing required settings")
  end if
  // Config v1 predates persisted handedness, mouse inversion and crosshair.
  // Preserve those files with the product defaults instead of rejecting them.
  if productConfigHand is void then productConfigHand = 0 end if
  if productConfigInvert is void then productConfigInvert = false end if
  if productConfigCrosshair is void then productConfigCrosshair = 1 end if
  if productConfigJoystick is void then productConfigJoystick = true end if
  // Config versions one and two predate explicit frame pacing. Preserve the
  // original Quake II defaults when upgrading either format.
  if productConfigMaxFps is void then productConfigMaxFps = 90 end if
  if productConfigSwapInterval is void then productConfigSwapInterval = true end if
  return productConfigValidate(ProductConfig(productConfigSensitivity,
    productConfigRun, productConfigInvert, productConfigHand, productConfigVolume,
    productConfigMode, productConfigFullscreen, productConfigGamma,
    productConfigMaxFps, productConfigSwapInterval, productConfigCrosshair,
    productConfigJoystick, productConfigBindings,
    productConfigBindingsComplete))
end function

// Apply product config.
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
  commandState.maxFps = productConfigApply.maxFps
  commandState.swapInterval = productConfigApply.swapInterval
  commandState.joystickEnabled = productConfigApply.joystick
  screen.crosshair = productConfigApply.crosshair
  uiconfigmixer.setMasterVolume(mixer, productConfigApply.volume)
  // Version 2 is a complete key-table snapshot, so an absent entry represents
  // an intentional unbind. Version 1 remains an override layer on current
  // defaults because old files could not distinguish an unbind from omission.
  if productConfigApply.bindingsComplete then input.bindings = [] end if
  for each productConfigApplyBinding in productConfigApply.bindings
    uiconfigkeys.bind(input, productConfigApplyBinding.key,
      productConfigApplyBinding.command)
  end for
  return true
end function

// A live map-to-map snapshot is authoritative over disk. This mirrors the
// original client's process-lifetime Cvar/key tables while retaining the file
// as startup and crash-recovery storage.
function selectProductConfig(path, handover)
  if handover is not void then return productConfigValidate(handover) end if
  return loadProductConfig(path)
end function

// Save product config.
function saveProductConfig(path, config)
  if typeof(path) != "string" or path == "" then return error(8300, "product config path is missing") end if
  productConfigEncoded = encodeProductConfig(config)
  productConfigTemporaryPath = path + ".tmp"
  uiconfigfs.writeAllText(productConfigTemporaryPath, productConfigEncoded)
  productConfigVerifiedResult = try(decodeProductConfig(
    uiconfigfs.readAllText(productConfigTemporaryPath)))
  if productConfigVerifiedResult is error then
    uiconfigfs.delete(productConfigTemporaryPath)
    return productConfigVerifiedResult
  end if
  productConfigVerified = productConfigVerifiedResult
  if len(productConfigVerified.bindings) != len(config.bindings) or
      not productConfigVerified.bindingsComplete then
    uiconfigfs.delete(productConfigTemporaryPath)
    return error(8301, "product config temporary verification failed")
  end if
  return uiconfigfs.moveFile(productConfigTemporaryPath, path, true)
end function

// Load product config.
function loadProductConfig(path)
  if typeof(path) != "string" or path == "" then return error(8300, "product config path is missing") end if
  if not uiconfigfs.exists(path) then return void end if
  return decodeProductConfig(uiconfigfs.readAllText(path))
end function
