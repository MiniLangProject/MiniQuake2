//! Provides miniquake2 runtime save metadata facilities for this project.

/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Durable classic save-slot presentation metadata. */
package miniquake2.runtime.save_metadata

import std.fs as savemetadatafs
import std.string as savemetadatastring
import miniquake2.qcommon.byteio as savemetadatabyteio
import miniquake2.qcommon.cmd as savemetadatacmd

/// Defines the metadata header constant used by the miniquake2 runtime save metadata module.
const METADATA_HEADER = "MiniQuake2Slot 1"

/// Invokes the native GetLocalTime entry point used by the miniquake2 runtime save metadata module.
/// @param systemTime systemTime value consumed by this operation.
extern function GetLocalTime(systemTime as bytes) from "kernel32.dll" returns void

/// Store save slot metadata data.
struct SaveSlotMetadata
  /// Stores the map name value associated with save slot metadata.
  mapName
  /// Stores the frame number value associated with save slot metadata.
  frameNumber
  /// Stores the timestamp value associated with save slot metadata.
  timestamp
  /// Stores the screenshot value associated with save slot metadata.
  screenshot
end struct

/// Return the two digits value.
/// @param saveMetadataTwoValue saveMetadataTwoValue value consumed by this operation.
function twoDigits(saveMetadataTwoValue)
  saveMetadataTwoText = "" + saveMetadataTwoValue
  if saveMetadataTwoValue < 10 then
    saveMetadataTwoText = "0" + saveMetadataTwoText
  end if
  return saveMetadataTwoText
end function

/// Return the four digits value.
/// @param saveMetadataFourValue saveMetadataFourValue value consumed by this operation.
function fourDigits(saveMetadataFourValue)
  saveMetadataFourText = "" + saveMetadataFourValue
  while len(bytes(saveMetadataFourText)) < 4
    saveMetadataFourText = "0" + saveMetadataFourText
  end while
  return saveMetadataFourText
end function

/// Return the current timestamp value.
function currentTimestamp()
  saveMetadataTimeBytes = bytes(16)
  GetLocalTime(saveMetadataTimeBytes)
  saveMetadataTimeYear = savemetadatabyteio.u16(saveMetadataTimeBytes, 0)
  saveMetadataTimeMonth = savemetadatabyteio.u16(saveMetadataTimeBytes, 2)
  saveMetadataTimeDay = savemetadatabyteio.u16(saveMetadataTimeBytes, 6)
  saveMetadataTimeHour = savemetadatabyteio.u16(saveMetadataTimeBytes, 8)
  saveMetadataTimeMinute = savemetadatabyteio.u16(saveMetadataTimeBytes, 10)
  saveMetadataTimeSecond = savemetadatabyteio.u16(saveMetadataTimeBytes, 12)
  return fourDigits(saveMetadataTimeYear) + "-" +
    twoDigits(saveMetadataTimeMonth) + "-" + twoDigits(saveMetadataTimeDay) +
    "T" + twoDigits(saveMetadataTimeHour) + ":" +
    twoDigits(saveMetadataTimeMinute) + ":" +
    twoDigits(saveMetadataTimeSecond)
end function

/// Return the safe token value.
/// @param saveMetadataSafeValue saveMetadataSafeValue value consumed by this operation.
function safeToken(saveMetadataSafeValue)
  if typeof(saveMetadataSafeValue) != "string" or
      saveMetadataSafeValue == "" or
      len(bytes(saveMetadataSafeValue)) > 255 then return false end if
  for each saveMetadataSafeByte in bytes(saveMetadataSafeValue)
    if saveMetadataSafeByte <= 32 or saveMetadataSafeByte == 34 then
      return false
    end if
  end for
  return true
end function

/// Validates validate for the miniquake2 runtime save metadata workflow.
/// @param saveMetadataValidateValue saveMetadataValidateValue value consumed by this operation.
function validate(saveMetadataValidateValue)
  if typeof(saveMetadataValidateValue) != "struct" or
      not safeToken(saveMetadataValidateValue.mapName) or
      typeof(saveMetadataValidateValue.frameNumber) != "int" or
      saveMetadataValidateValue.frameNumber < 0 or
      not safeToken(saveMetadataValidateValue.timestamp) or
      (saveMetadataValidateValue.screenshot != "" and
       not safeToken(saveMetadataValidateValue.screenshot)) then
    return error(8490, "save-slot metadata is invalid")
  end if
  return saveMetadataValidateValue
end function

/// Encodes encode for the miniquake2 runtime save metadata workflow.
/// @param saveMetadataEncodeInput saveMetadataEncodeInput value consumed by this operation.
function encode(saveMetadataEncodeInput)
  saveMetadataEncodeValue = validate(saveMetadataEncodeInput)
  saveMetadataEncodeScreenshot = "-"
  if saveMetadataEncodeValue.screenshot != "" then
    saveMetadataEncodeScreenshot = saveMetadataEncodeValue.screenshot
  end if
  return METADATA_HEADER + "\nmap " + saveMetadataEncodeValue.mapName +
    "\nframe " + saveMetadataEncodeValue.frameNumber + "\ntime " +
    saveMetadataEncodeValue.timestamp + "\nscreenshot " +
    saveMetadataEncodeScreenshot + "\n"
end function

/// Decode state.
/// @param saveMetadataDecodeText saveMetadataDecodeText value consumed by this operation.
function decode(saveMetadataDecodeText)
  // Keep decode phases explicit: validate inputs, update owned state, then publish the result.
  if typeof(saveMetadataDecodeText) != "string" or
      len(bytes(saveMetadataDecodeText)) > 4096 then
    return error(8491, "save-slot metadata text is invalid")
  end if
  saveMetadataDecodeLines = savemetadatastring.split(saveMetadataDecodeText,
    "\n")
  if len(saveMetadataDecodeLines) < 5 or
      savemetadatastring.trim(saveMetadataDecodeLines[0]) !=
      METADATA_HEADER then
    return error(8492, "save-slot metadata header is invalid")
  end if
  saveMetadataDecodeMapName = ""
  saveMetadataDecodeFrameNumber = -1
  saveMetadataDecodeTimestamp = ""
  saveMetadataDecodeScreenshot = ""
  saveMetadataDecodeIndex = 1
  while saveMetadataDecodeIndex < len(saveMetadataDecodeLines)
    saveMetadataDecodeLine = savemetadatastring.trim(
      saveMetadataDecodeLines[saveMetadataDecodeIndex])
    saveMetadataDecodeIndex = saveMetadataDecodeIndex + 1
    if saveMetadataDecodeLine == "" then continue end if
    saveMetadataDecodeTokens = savemetadatacmd.tokenize(
      saveMetadataDecodeLine)
    if len(saveMetadataDecodeTokens) != 2 then
      return error(8493, "save-slot metadata line is invalid")
    end if
    saveMetadataDecodeName = saveMetadataDecodeTokens[0]
    saveMetadataDecodeToken = saveMetadataDecodeTokens[1]
    if saveMetadataDecodeName == "map" and
        saveMetadataDecodeMapName == "" then
      saveMetadataDecodeMapName = saveMetadataDecodeToken
    else if saveMetadataDecodeName == "frame" and
        saveMetadataDecodeFrameNumber < 0 then
      saveMetadataDecodeNumber = try(toNumber(saveMetadataDecodeToken))
      if saveMetadataDecodeNumber is error then
        return error(8493, "save-slot frame is invalid")
      end if
      saveMetadataDecodeFrameNumber = savemetadatabyteio.truncInt(
        saveMetadataDecodeNumber)
      if saveMetadataDecodeNumber != saveMetadataDecodeFrameNumber then
        return error(8493, "save-slot frame is not integral")
      end if
    else if saveMetadataDecodeName == "time" and
        saveMetadataDecodeTimestamp == "" then
      saveMetadataDecodeTimestamp = saveMetadataDecodeToken
    else if saveMetadataDecodeName == "screenshot" and
        saveMetadataDecodeScreenshot == "" then
      saveMetadataDecodeScreenshot = saveMetadataDecodeToken
      if saveMetadataDecodeScreenshot == "-" then
        saveMetadataDecodeScreenshot = ""
      end if
    else
      return error(8493,
        "unknown or duplicate save-slot metadata field")
    end if
  end while
  saveMetadataDecodeValue = SaveSlotMetadata(saveMetadataDecodeMapName,
    saveMetadataDecodeFrameNumber, saveMetadataDecodeTimestamp,
    saveMetadataDecodeScreenshot)
  return validate(saveMetadataDecodeValue)
end function

/// Save state.
/// @param saveMetadataSavePath Path associated with save metadata save.
/// @param saveMetadataSaveValue saveMetadataSaveValue value consumed by this operation.
function save(saveMetadataSavePath, saveMetadataSaveValue)
  if typeof(saveMetadataSavePath) != "string" or
      saveMetadataSavePath == "" then
    return error(8494, "metadata path is required")
  end if
  saveMetadataSaveTemporary = saveMetadataSavePath + ".tmp"
  saveMetadataSaveEncoded = encode(saveMetadataSaveValue)
  savemetadatafs.writeAllText(saveMetadataSaveTemporary,
    saveMetadataSaveEncoded)
  saveMetadataSaveText = savemetadatafs.readAllText(
    saveMetadataSaveTemporary)
  if saveMetadataSaveText != saveMetadataSaveEncoded then
    savemetadatafs.delete(saveMetadataSaveTemporary)
    return error(8495,
      "temporary save-slot metadata verification failed")
  end if
  return savemetadatafs.moveFile(saveMetadataSaveTemporary,
    saveMetadataSavePath, true)
end function
