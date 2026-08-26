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

const METADATA_HEADER = "MiniQuake2Slot 1"

extern function GetLocalTime(systemTime as bytes) from "kernel32.dll" returns void

struct SaveSlotMetadata
  mapName
  frameNumber
  timestamp
  screenshot
end struct

function twoDigits(saveMetadataTwoValue)
  saveMetadataTwoText = "" + saveMetadataTwoValue
  if saveMetadataTwoValue < 10 then
    saveMetadataTwoText = "0" + saveMetadataTwoText
  end if
  return saveMetadataTwoText
end function

function fourDigits(saveMetadataFourValue)
  saveMetadataFourText = "" + saveMetadataFourValue
  while len(bytes(saveMetadataFourText)) < 4
    saveMetadataFourText = "0" + saveMetadataFourText
  end while
  return saveMetadataFourText
end function

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

function decode(saveMetadataDecodeText)
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
