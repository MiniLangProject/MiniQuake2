/*
Copyright (C) 1997-2001 Id Software, Inc.
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later

Versioned, pointer-free MiniLang save image.  It is intentionally not the
machine-dependent 3.19 C struct dump; the gameplay semantics are preserved
while ownership links are rebuilt by edict number.
*/
package miniquake2.game.persistence

import std.fs as savefs
import miniquake2.qcommon.sizebuf as qsz
import miniquake2.qcommon.message as qmsg
import miniquake2.protocol.checked as pchecked
import miniquake2.game.types as gt

const SAVE_MAGIC = "MQ2SAVE1"
const SAVE_VERSION = 2

function saveFormat(data)
  if typeof(data) != "bytes" or len(data) < len(bytes(SAVE_MAGIC)) + 1 then
    return "truncated"
  end if
  expected = bytes(SAVE_MAGIC)
  index = 0
  while index < len(expected)
    if data[index] != expected[index] then return "native-or-foreign" end if
    index = index + 1
  end while
  if data[len(expected)] != 0 then return "native-or-foreign" end if
  return "miniquake2"
end function

struct SaveImage
  kind
  mapName
  frameNumber
  numEdicts
  edicts
  privateData
end struct

function writeVec3(buffer, value)
  qmsg.writeFloat(buffer, value.x)
  qmsg.writeFloat(buffer, value.y)
  qmsg.writeFloat(buffer, value.z)
end function

function readFloat(buffer, operation)
  pchecked.require(buffer, 4, operation)
  return qmsg.readFloat(buffer)
end function

function readVec3(buffer, operation)
  return miniquake2.qcommon.types.Vec3(readFloat(buffer, operation + " x"), readFloat(buffer, operation + " y"), readFloat(buffer, operation + " z"))
end function

function writePmoveState(buffer, state)
  qmsg.writeLong(buffer, state.moveType)
  index = 0
  while index < 3
    qmsg.writeLong(buffer, state.origin[index])
    qmsg.writeLong(buffer, state.velocity[index])
    qmsg.writeLong(buffer, state.deltaAngles[index])
    index = index + 1
  end while
  qmsg.writeLong(buffer, state.flags)
  qmsg.writeLong(buffer, state.time)
  qmsg.writeLong(buffer, state.gravity)
end function

function readPmoveState(buffer)
  state = gt.zeroPmoveState()
  state.moveType = pchecked.readLong(buffer, "save pmove type")
  index = 0
  while index < 3
    state.origin[index] = pchecked.readLong(buffer, "save pmove origin")
    state.velocity[index] = pchecked.readLong(buffer, "save pmove velocity")
    state.deltaAngles[index] = pchecked.readLong(buffer, "save pmove delta angle")
    index = index + 1
  end while
  state.flags = pchecked.readLong(buffer, "save pmove flags")
  state.time = pchecked.readLong(buffer, "save pmove time")
  state.gravity = pchecked.readLong(buffer, "save pmove gravity")
  return state
end function

function writePlayerState(buffer, state)
  writePmoveState(buffer, state.pmove)
  writeVec3(buffer, state.viewAngles); writeVec3(buffer, state.viewOffset)
  writeVec3(buffer, state.kickAngles); writeVec3(buffer, state.gunAngles); writeVec3(buffer, state.gunOffset)
  qmsg.writeLong(buffer, state.gunIndex); qmsg.writeLong(buffer, state.gunFrame)
  index = 0
  while index < 4
    qmsg.writeFloat(buffer, state.blend[index])
    index = index + 1
  end while
  qmsg.writeFloat(buffer, state.fov); qmsg.writeLong(buffer, state.rdFlags)
  index = 0
  while index < 32
    qmsg.writeLong(buffer, state.stats[index])
    index = index + 1
  end while
end function

function readPlayerState(buffer)
  state = gt.zeroPlayerState()
  state.pmove = readPmoveState(buffer)
  state.viewAngles = readVec3(buffer, "save view angles"); state.viewOffset = readVec3(buffer, "save view offset")
  state.kickAngles = readVec3(buffer, "save kick angles"); state.gunAngles = readVec3(buffer, "save gun angles"); state.gunOffset = readVec3(buffer, "save gun offset")
  state.gunIndex = pchecked.readLong(buffer, "save gun index"); state.gunFrame = pchecked.readLong(buffer, "save gun frame")
  index = 0
  while index < 4
    state.blend[index] = readFloat(buffer, "save blend")
    index = index + 1
  end while
  state.fov = readFloat(buffer, "save fov"); state.rdFlags = pchecked.readLong(buffer, "save rdflags")
  index = 0
  while index < 32
    state.stats[index] = pchecked.readLong(buffer, "save stat")
    index = index + 1
  end while
  return state
end function

function writeEntityState(buffer, state)
  qmsg.writeLong(buffer, state.number)
  writeVec3(buffer, state.origin); writeVec3(buffer, state.angles); writeVec3(buffer, state.oldOrigin)
  qmsg.writeLong(buffer, state.modelIndex); qmsg.writeLong(buffer, state.modelIndex2)
  qmsg.writeLong(buffer, state.modelIndex3); qmsg.writeLong(buffer, state.modelIndex4)
  qmsg.writeLong(buffer, state.frame); qmsg.writeLong(buffer, state.skinNumber)
  qmsg.writeLong(buffer, state.effects); qmsg.writeLong(buffer, state.renderFx)
  qmsg.writeLong(buffer, state.solid); qmsg.writeLong(buffer, state.sound); qmsg.writeLong(buffer, state.event)
end function

function readEntityState(buffer, expectedNumber)
  number = pchecked.readLong(buffer, "save entity number")
  if number != expectedNumber then return error(3850, "save edict numbering is not contiguous") end if
  gpersistStateHolder = gt.zeroEntityState(number)
  gpersistOriginHolder = readVec3(buffer, "save origin")
  gpersistAnglesHolder = readVec3(buffer, "save angles")
  gpersistOldOriginHolder = readVec3(buffer, "save old origin")
  gpersistStateHolder.origin = gpersistOriginHolder
  gpersistStateHolder.angles = gpersistAnglesHolder
  gpersistStateHolder.oldOrigin = gpersistOldOriginHolder
  gpersistStateHolder.modelIndex = pchecked.readLong(buffer, "save model1"); gpersistStateHolder.modelIndex2 = pchecked.readLong(buffer, "save model2")
  gpersistStateHolder.modelIndex3 = pchecked.readLong(buffer, "save model3"); gpersistStateHolder.modelIndex4 = pchecked.readLong(buffer, "save model4")
  gpersistStateHolder.frame = pchecked.readLong(buffer, "save frame"); gpersistStateHolder.skinNumber = pchecked.readLong(buffer, "save skin")
  gpersistStateHolder.effects = pchecked.readLong(buffer, "save effects"); gpersistStateHolder.renderFx = pchecked.readLong(buffer, "save renderfx")
  gpersistStateHolder.solid = pchecked.readLong(buffer, "save state solid"); gpersistStateHolder.sound = pchecked.readLong(buffer, "save sound"); gpersistStateHolder.event = pchecked.readLong(buffer, "save event")
  return gt.stabilizeEntityState(gpersistStateHolder)
end function

function encodeSaveImageWithPrivate(exportTable, kind, mapName, frameNumber, privateData)
  if kind != "game" and kind != "level" then return error(3851, "invalid save kind") end if
  if exportTable.numEdicts < 1 or exportTable.numEdicts > exportTable.maxEdicts then return error(3852, "invalid exported edict count") end if
  if typeof(privateData) != "bytes" then return error(3861, "private save payload must be bytes") end if
  buffer = qsz.alloc(516 + exportTable.numEdicts * 512 + len(privateData))
  qmsg.writeString(buffer, SAVE_MAGIC); qmsg.writeLong(buffer, SAVE_VERSION)
  qmsg.writeString(buffer, kind); qmsg.writeString(buffer, mapName)
  qmsg.writeLong(buffer, frameNumber); qmsg.writeLong(buffer, exportTable.numEdicts)
  index = 0
  while index < exportTable.numEdicts
    edict = exportTable.edicts[index]
    inUseMarker = 0
    if edict.inUse then inUseMarker = 1 end if
    qmsg.writeByte(buffer, inUseMarker)
    qmsg.writeLong(buffer, edict.linkCount)
    writeEntityState(buffer, edict.state)
    qmsg.writeLong(buffer, edict.serverFlags)
    writeVec3(buffer, edict.mins); writeVec3(buffer, edict.maxs)
    qmsg.writeLong(buffer, edict.solid); qmsg.writeLong(buffer, edict.clipMask)
    ownerNumber = -1
    if edict.owner is not void then ownerNumber = edict.owner.state.number end if
    qmsg.writeLong(buffer, ownerNumber)
    clientMarker = 0
    if edict.client is not void then clientMarker = 1 end if
    qmsg.writeByte(buffer, clientMarker)
    if edict.client is not void then
      qmsg.writeLong(buffer, edict.client.ping)
      writePlayerState(buffer, edict.client.playerState)
    end if
    index = index + 1
  end while
  qmsg.writeLong(buffer, len(privateData))
  qsz.writeBytes(buffer, privateData)
  return qsz.dataSlice(buffer)
end function

function encode(exportTable, kind, mapName, frameNumber)
  return encodeSaveImageWithPrivate(exportTable, kind, mapName, frameNumber, bytes(0))
end function

function encodeWithPrivate(exportTable, kind, mapName, frameNumber, privateData)
  return encodeSaveImageWithPrivate(exportTable, kind, mapName, frameNumber, privateData)
end function

function decodeSaveImage(data, maxEdicts)
  if typeof(data) != "bytes" or len(data) < 20 then return error(3853, "save image is truncated") end if
  if saveFormat(data) != "miniquake2" then
    return error(3854, "original Quake II native saves are machine-layout dumps and cannot be imported safely; use a MiniQuake2 save slot")
  end if
  buffer = qsz.alloc(len(data)); qsz.writeBytes(buffer, data); qmsg.beginReading(buffer)
  pchecked.require(buffer, len(bytes(SAVE_MAGIC)) + 1, "save magic")
  if qmsg.readString(buffer) != SAVE_MAGIC then return error(3854, "MiniQuake2 save magic mismatch") end if
  version = pchecked.readLong(buffer, "save version")
  if version != 1 and version != SAVE_VERSION then return error(3855, "unsupported save version") end if
  pchecked.require(buffer, 1, "save kind"); kind = qmsg.readString(buffer)
  pchecked.require(buffer, 1, "save map"); mapName = qmsg.readString(buffer)
  frameNumber = pchecked.readLong(buffer, "save frame number")
  numEdicts = pchecked.readLong(buffer, "save edict count")
  if numEdicts < 1 or numEdicts > maxEdicts then return error(3856, "save edict count outside game limits") end if
  edicts = array(maxEdicts)
  index = 0
  while index < maxEdicts
    gpersistCreatedEdictHolder = gt.zeroEdict(index)
    edicts[index] = gpersistCreatedEdictHolder
    gpersistStoredEdictHolder = edicts[index]
    gpersistStoredEdictHolder.state = gpersistCreatedEdictHolder.state
    gpersistStoredEdictHolder.mins = gpersistCreatedEdictHolder.mins
    gpersistStoredEdictHolder.maxs = gpersistCreatedEdictHolder.maxs
    gpersistStoredEdictHolder.absoluteMins = gpersistCreatedEdictHolder.absoluteMins
    gpersistStoredEdictHolder.absoluteMaxs = gpersistCreatedEdictHolder.absoluteMaxs
    gpersistStoredEdictHolder.size = gpersistCreatedEdictHolder.size
    gt.stabilizeEdict(gpersistStoredEdictHolder)
    index = index + 1
  end while
  ownerNumbers = array(numEdicts, -1)
  index = 0
  while index < numEdicts
    edict = edicts[index]
    edict.inUse = pchecked.readByte(buffer, "save inuse") != 0
    edict.linkCount = pchecked.readLong(buffer, "save link count")
    gpersistRestoredStateHolder = readEntityState(buffer, index)
    edict.state = gpersistRestoredStateHolder
    edict.serverFlags = pchecked.readLong(buffer, "save server flags")
    gpersistRestoredMinsHolder = readVec3(buffer, "save mins")
    gpersistRestoredMaxsHolder = readVec3(buffer, "save maxs")
    edict.mins = gpersistRestoredMinsHolder
    edict.maxs = gpersistRestoredMaxsHolder
    edict.solid = pchecked.readLong(buffer, "save solid"); edict.clipMask = pchecked.readLong(buffer, "save clipmask")
    ownerNumbers[index] = pchecked.readLong(buffer, "save owner")
    hasClient = pchecked.readByte(buffer, "save client marker")
    if hasClient != 0 and hasClient != 1 then return error(3857, "invalid save client marker") end if
    if hasClient == 1 then
      edict.client = gt.zeroGameClient()
      edict.client.ping = pchecked.readLong(buffer, "save ping")
      edict.client.playerState = readPlayerState(buffer)
    end if
    gt.stabilizeEdict(edict)
    index = index + 1
  end while
  index = 0
  while index < numEdicts
    owner = ownerNumbers[index]
    if owner >= numEdicts then return error(3858, "save owner outside edict table") end if
    if owner >= 0 then edicts[index].owner = edicts[owner] end if
    index = index + 1
  end while
  privateData = bytes(0)
  if version >= 2 then
    privateLength = pchecked.readLong(buffer, "private save length")
    if privateLength < 0 then return error(3862, "negative private save length") end if
    pchecked.require(buffer, privateLength, "private save payload")
    privateData = qmsg.readData(buffer, privateLength)
  end if
  if buffer.readCount != buffer.curSize then return error(3859, "trailing save data") end if
  return SaveImage(kind, mapName, frameNumber, numEdicts, edicts, privateData)
end function

function decode(data, maxEdicts)
  return decodeSaveImage(data, maxEdicts)
end function

function writeFile(exportTable, kind, mapName, frameNumber, filename)
  if typeof(filename) != "string" or filename == "" then return error(3860, "empty save filename") end if
  return savefs.writeAllBytes(filename, encodeSaveImageWithPrivate(exportTable, kind, mapName, frameNumber, bytes(0)))
end function

function writeFileWithPrivate(exportTable, kind, mapName, frameNumber, privateData, filename)
  if typeof(filename) != "string" or filename == "" then return error(3860, "empty save filename") end if
  return savefs.writeAllBytes(filename, encodeSaveImageWithPrivate(exportTable, kind, mapName, frameNumber, privateData))
end function

function readFile(filename, maxEdicts)
  if typeof(filename) != "string" or filename == "" then return error(3860, "empty save filename") end if
  return decodeSaveImage(savefs.readAllBytes(filename), maxEdicts)
end function
