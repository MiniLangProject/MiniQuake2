/*
Copyright (C) 1997-2001 Id Software, Inc.
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later

SV_EmitPacketEntities / SV_WriteFrameToClient semantics for Protocol 34.
Frames own managed entity arrays rather than indexing a shared C ring.
*/
package miniquake2.server.snapshot

import miniquake2.qcommon.constants as qc
import miniquake2.qcommon.message as qmsg
import miniquake2.qcommon.sizebuf as qsz
import miniquake2.protocol.checked as pchecked
import miniquake2.protocol.types as pt
import miniquake2.protocol.entity_delta as pedelta
import miniquake2.protocol.player_delta as ppdelta

struct SnapshotFrame
  number
  deltaNumber
  suppressCount
  areaBits
  playerState
  entities
end struct

struct SnapshotHistory
  frames
  baselines
  maxClients
end struct

function copyEntities(entities)
  output = array(len(entities))
  index = 0
  while index < len(entities)
    output[index] = pt.copyEntityState(entities[index])
    index = index + 1
  end while
  return output
end function

function validateEntities(entities, operation)
  if typeof(entities) != "array" then return error(7500, operation + ": entity list must be an array") end if
  lastNumber = 0
  index = 0
  while index < len(entities)
    entity = entities[index]
    if entity.number <= lastNumber or entity.number >= qc.MAX_EDICTS then
      return error(7501, operation + ": entities must be unique and sorted by number")
    end if
    lastNumber = entity.number
    index = index + 1
  end while
  return true
end function

function createHistory(maxClients)
  if maxClients < 1 or maxClients > qc.MAX_CLIENTS then return error(7502, "invalid snapshot maxClients") end if
  baselines = array(qc.MAX_EDICTS)
  index = 0
  while index < qc.MAX_EDICTS
    baseline = pt.zeroEntityState()
    baseline.number = index
    baselines[index] = baseline
    index = index + 1
  end while
  return SnapshotHistory([], baselines, maxClients)
end function

function setBaseline(history, state)
  if state.number <= 0 or state.number >= qc.MAX_EDICTS then return error(7503, "baseline entity outside range") end if
  history.baselines[state.number] = pt.copyEntityState(state)
end function

function addFrame(history, number, areaBits, playerState, entities)
  if number < 0 then return error(7504, "negative server frame") end if
  if typeof(areaBits) != "bytes" or len(areaBits) > 255 then return error(7505, "area bits exceed protocol byte count") end if
  validateEntities(entities, "addFrame")
  frame = SnapshotFrame(number, -1, 0, areaBits, pt.copyPlayerState(playerState), copyEntities(entities))
  history.frames = history.frames + [frame]
  if len(history.frames) > qc.UPDATE_BACKUP then history.frames = slice(history.frames, len(history.frames) - qc.UPDATE_BACKUP, qc.UPDATE_BACKUP) end if
  return frame
end function

function findFrame(history, number)
  index = 0
  while index < len(history.frames)
    if history.frames[index].number == number then return history.frames[index] end if
    index = index + 1
  end while
  return void
end function

function chooseDeltaFrame(history, current, requestedNumber)
  if requestedNumber <= 0 then return void end if
  if current.number - requestedNumber >= qc.UPDATE_BACKUP - 3 then return void end if
  return findFrame(history, requestedNumber)
end function

function emitPacketEntities(buffer, previousEntities, currentEntities, baselines, maxClients)
  validateEntities(previousEntities, "packet previous")
  validateEntities(currentEntities, "packet current")
  qmsg.writeByte(buffer, qc.SVC_PACKETENTITIES)
  oldIndex = 0
  newIndex = 0
  while newIndex < len(currentEntities) or oldIndex < len(previousEntities)
    oldNumber = 9999
    newNumber = 9999
    if oldIndex < len(previousEntities) then oldNumber = previousEntities[oldIndex].number end if
    if newIndex < len(currentEntities) then newNumber = currentEntities[newIndex].number end if
    if newNumber == oldNumber then
      pedelta.writeDelta(buffer, previousEntities[oldIndex], currentEntities[newIndex], false, newNumber <= maxClients)
      oldIndex = oldIndex + 1
      newIndex = newIndex + 1
    else if newNumber < oldNumber then
      pedelta.writeDelta(buffer, baselines[newNumber], currentEntities[newIndex], true, true)
      newIndex = newIndex + 1
    else
      pedelta.writeRemoval(buffer, oldNumber)
      oldIndex = oldIndex + 1
    end if
  end while
  pedelta.writeEndMarker(buffer)
end function

function writeFrame(history, current, requestedDeltaNumber, suppressCount, buffer)
  oldFrame = chooseDeltaFrame(history, current, requestedDeltaNumber)
  oldNumber = -1
  oldPlayer = pt.zeroPlayerState()
  oldEntities = []
  if oldFrame is not void then
    oldNumber = oldFrame.number
    oldPlayer = oldFrame.playerState
    oldEntities = oldFrame.entities
  end if
  current.deltaNumber = oldNumber
  current.suppressCount = suppressCount
  qmsg.writeByte(buffer, qc.SVC_FRAME)
  qmsg.writeLong(buffer, current.number)
  qmsg.writeLong(buffer, oldNumber)
  qmsg.writeByte(buffer, suppressCount)
  qmsg.writeByte(buffer, len(current.areaBits))
  qsz.writeBytes(buffer, current.areaBits)
  ppdelta.writeMessage(buffer, oldPlayer, current.playerState)
  emitPacketEntities(buffer, oldEntities, current.entities, history.baselines, history.maxClients)
  return qsz.dataSlice(buffer)
end function

function applyPacketEntities(buffer, previousEntities, baselines)
  validateEntities(previousEntities, "parse previous")
  opcode = pchecked.readByte(buffer, "packetentities opcode")
  if opcode != qc.SVC_PACKETENTITIES then return error(7506, "expected svc_packetentities") end if
  output = array(qc.MAX_EDICTS)
  outputCount = 0
  oldIndex = 0
  previousHeaderNumber = 0
  while true
    header = pedelta.readHeader(buffer)
    if header.endMarker then
      while oldIndex < len(previousEntities)
        output[outputCount] = pt.copyEntityState(previousEntities[oldIndex])
        outputCount = outputCount + 1
        oldIndex = oldIndex + 1
      end while
      if outputCount == 0 then return [] end if
      compact = array(outputCount)
      compactIndex = 0
      while compactIndex < outputCount
        compact[compactIndex] = output[compactIndex]
        compactIndex = compactIndex + 1
      end while
      return compact
    end if
    if header.number <= previousHeaderNumber then return error(7507, "packet entity headers are not strictly ordered") end if
    previousHeaderNumber = header.number
    while oldIndex < len(previousEntities) and previousEntities[oldIndex].number < header.number
      output[outputCount] = pt.copyEntityState(previousEntities[oldIndex])
      outputCount = outputCount + 1
      oldIndex = oldIndex + 1
    end while
    if header.remove then
      if oldIndex >= len(previousEntities) or previousEntities[oldIndex].number != header.number then
        return error(7508, "packet entity removal has no old entity")
      end if
      oldIndex = oldIndex + 1
    else
      base = baselines[header.number]
      if oldIndex < len(previousEntities) and previousEntities[oldIndex].number == header.number then
        base = previousEntities[oldIndex]
        oldIndex = oldIndex + 1
      end if
      output[outputCount] = pedelta.readDelta(buffer, base, header)
      outputCount = outputCount + 1
    end if
  end while
end function

function readFrame(buffer, oldFrame, baselines)
  opcode = pchecked.readByte(buffer, "frame opcode")
  if opcode != qc.SVC_FRAME then return error(7509, "expected svc_frame") end if
  number = pchecked.readLong(buffer, "server frame number")
  deltaNumber = pchecked.readLong(buffer, "delta frame number")
  suppressCount = pchecked.readByte(buffer, "suppress count")
  areaLength = pchecked.readByte(buffer, "area bits length")
  areaBits = pchecked.readBytes(buffer, areaLength, "area bits")
  basePlayer = pt.zeroPlayerState()
  oldEntities = []
  if oldFrame is not void then
    if deltaNumber != oldFrame.number then return error(7510, "frame delta base mismatch") end if
    basePlayer = oldFrame.playerState
    oldEntities = oldFrame.entities
  else if deltaNumber != -1 then
    return error(7511, "missing requested frame delta base")
  end if
  playerState = ppdelta.readMessage(buffer, basePlayer)
  entities = applyPacketEntities(buffer, oldEntities, baselines)
  if buffer.readCount != buffer.curSize then return error(7512, "trailing bytes after snapshot frame") end if
  return SnapshotFrame(number, deltaNumber, suppressCount, areaBits, playerState, entities)
end function
