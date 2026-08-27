/*
Copyright (C) 1997-2001 Id Software, Inc.
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later

SV_EmitPacketEntities / CL_ParsePacketEntities and frame history orchestration.
*/
package miniquake2.network.snapshot

import std.array as nsnapshotarray
import miniquake2.qcommon.message as qmsg
import miniquake2.qcommon.sizebuf as qsz
import miniquake2.protocol.types as pt
import miniquake2.protocol.checked as pchecked
import miniquake2.protocol.entity_delta as pentity
import miniquake2.protocol.player_delta as pplayer
import miniquake2.network.constants as nc
import miniquake2.network.types as nt

// Validate entities.
function validateEntities(entities, operation)
  if typeof(entities) != "array" or len(entities) > nc.MAX_PARSE_ENTITIES then return error(7130, operation + ": entity list is invalid") end if
  previous = 0
  for each entity in entities
    if entity.number <= previous or entity.number >= 1024 then return error(7131, operation + ": entities are not strictly sorted") end if
    previous = entity.number
  end for
  return true
end function

// Return the baseline for the requested input.
function baselineFor(baselines, number)
  if typeof(baselines) != "array" or number < 0 or number >= len(baselines) then return error(7132, "entity baseline is unavailable") end if
  if baselines[number] is void then return pt.zeroEntityState() end if
  return baselines[number]
end function

// Write packet entities.
function writePacketEntities(buffer, oldEntities, newEntities, baselines, maxClients)
  validateEntities(oldEntities, "old packet entities")
  validateEntities(newEntities, "new packet entities")
  qmsg.writeByte(buffer, nc.SVC_PACKETENTITIES)
  oldIndex = 0
  newIndex = 0
  while newIndex < len(newEntities) or oldIndex < len(oldEntities)
    oldNumber = 9999
    newNumber = 9999
    if oldIndex < len(oldEntities) then oldNumber = oldEntities[oldIndex].number end if
    if newIndex < len(newEntities) then newNumber = newEntities[newIndex].number end if
    if newNumber == oldNumber then
      pentity.writeDelta(buffer, oldEntities[oldIndex], newEntities[newIndex], false, newNumber <= maxClients)
      oldIndex = oldIndex + 1
      newIndex = newIndex + 1
    else if newNumber < oldNumber then
      baseline = baselineFor(baselines, newNumber)
      pentity.writeDelta(buffer, baseline, newEntities[newIndex], true, true)
      newIndex = newIndex + 1
    else
      pentity.writeRemoval(buffer, oldNumber)
      oldIndex = oldIndex + 1
    end if
  end while
  pentity.writeEndMarker(buffer)
  return buffer
end function

// Return the inherit entity value.
function inheritEntity(buffer, base)
  header = pt.EntityDeltaHeader(base.number, 0, false, false)
  return pentity.readDelta(buffer, base, header)
end function

// Read packet entities body.
function readPacketEntitiesBody(buffer, oldEntities, baselines)
  // Keep read packet entities body phases explicit: validate inputs, update owned state, then publish the result.
  validateEntities(oldEntities, "old packet entities")
  result = array(nc.MAX_PARSE_ENTITIES)
  resultCount = 0
  oldIndex = 0
  previousWireNumber = 0
  while true
    header = pentity.readHeader(buffer)
    if header.endMarker then break end if
    if header.number <= previousWireNumber then return error(7133, "packet entity headers are not strictly sorted") end if
    previousWireNumber = header.number

    oldNumber = 99999
    if oldIndex < len(oldEntities) then oldNumber = oldEntities[oldIndex].number end if
    while oldNumber < header.number
      if resultCount >= nc.MAX_PARSE_ENTITIES then return error(7134, "packet entities exceed parse capacity") end if
      inherited = inheritEntity(buffer, oldEntities[oldIndex])
      result[resultCount] = inherited
      resultCount = resultCount + 1
      oldIndex = oldIndex + 1
      oldNumber = 99999
      if oldIndex < len(oldEntities) then oldNumber = oldEntities[oldIndex].number end if
    end while

    if header.remove then
      if oldNumber != header.number then return error(7135, "entity removal does not match delta baseline") end if
      oldIndex = oldIndex + 1
    else if oldNumber == header.number then
      if resultCount >= nc.MAX_PARSE_ENTITIES then return error(7134, "packet entities exceed parse capacity") end if
      decoded = pentity.readDelta(buffer, oldEntities[oldIndex], header)
      result[resultCount] = decoded
      resultCount = resultCount + 1
      oldIndex = oldIndex + 1
    else
      baseline = baselineFor(baselines, header.number)
      if resultCount >= nc.MAX_PARSE_ENTITIES then return error(7134, "packet entities exceed parse capacity") end if
      decoded = pentity.readDelta(buffer, baseline, header)
      result[resultCount] = decoded
      resultCount = resultCount + 1
    end if
  end while

  while oldIndex < len(oldEntities)
    if resultCount >= nc.MAX_PARSE_ENTITIES then return error(7134, "packet entities exceed parse capacity") end if
    inherited = inheritEntity(buffer, oldEntities[oldIndex])
    result[resultCount] = inherited
    resultCount = resultCount + 1
    oldIndex = oldIndex + 1
  end while
  output = nsnapshotarray.slice(result, 0, resultCount)
  validateEntities(output, "decoded packet entities")
  return output
end function

// Read packet entities.
function readPacketEntities(buffer, oldEntities, baselines)
  opcode = pchecked.readByte(buffer, "packetentities opcode")
  if opcode != nc.SVC_PACKETENTITIES then return error(7136, "expected svc_packetentities") end if
  return readPacketEntitiesBody(buffer, oldEntities, baselines)
end function

// Create frame.
function createFrame(serverFrame, areaBits, playerState, entities)
  if typeof(serverFrame) != "int" or serverFrame < 0 then return error(7137, "negative server frame") end if
  if typeof(areaBits) != "bytes" or len(areaBits) > nc.MAX_MAP_AREA_BYTES then return error(7138, "frame area bits exceed protocol capacity") end if
  validateEntities(entities, "frame entities")
  return nt.Frame(true, serverFrame, -1, serverFrame * 100, 0,
    slice(areaBits, 0, len(areaBits)), playerState, entities)
end function

// Choose delta.
function chooseDelta(serverFrame, lastFrame, history)
  if typeof(history) != "array" or len(history) != nc.UPDATE_BACKUP then return error(7139, "frame history must contain UPDATE_BACKUP slots") end if
  if lastFrame <= 0 or lastFrame >= serverFrame or serverFrame - lastFrame >= nc.DELTA_SAFETY_WINDOW then return [-1, void] end if
  candidate = history[lastFrame & nc.UPDATE_MASK]
  if candidate is void or not candidate.valid or candidate.serverFrame != lastFrame then return [-1, void] end if
  return [lastFrame, candidate]
end function

// Write frame for client.
function writeFrameForClient(buffer, current, lastFrame, history, baselines, maxClients, suppressCount)
  if typeof(current.areaBits) != "bytes" or len(current.areaBits) > nc.MAX_MAP_AREA_BYTES then return error(7144, "frame area bits exceed protocol capacity") end if
  if typeof(suppressCount) != "int" or suppressCount < 0 or suppressCount > 255 then return error(7145, "frame suppress count outside byte range") end if
  selection = chooseDelta(current.serverFrame, lastFrame, history)
  wireLast = selection[0]
  oldFrame = selection[1]
  oldPlayer = pt.zeroPlayerState()
  oldEntities = []
  if oldFrame is not void then oldPlayer = oldFrame.playerState; oldEntities = oldFrame.entities end if

  qmsg.writeByte(buffer, nc.SVC_FRAME)
  qmsg.writeLong(buffer, current.serverFrame)
  qmsg.writeLong(buffer, wireLast)
  qmsg.writeByte(buffer, suppressCount)
  qmsg.writeByte(buffer, len(current.areaBits))
  qsz.writeBytes(buffer, current.areaBits)
  pplayer.writeMessage(buffer, oldPlayer, current.playerState)
  writePacketEntities(buffer, oldEntities, current.entities, baselines, maxClients)
  current.deltaFrame = wireLast
  current.suppressCount = suppressCount
  history[current.serverFrame & nc.UPDATE_MASK] = current
  return wireLast
end function

// Read frame protocol.
function readFrameProtocol(buffer, history, baselines, protocol)
  if typeof(history) != "array" or len(history) != nc.UPDATE_BACKUP then return error(7139, "frame history must contain UPDATE_BACKUP slots") end if
  if protocol != 26 and protocol != 34 then return error(7146, "unsupported snapshot protocol") end if
  opcode = pchecked.readByte(buffer, "frame opcode")
  if opcode != nc.SVC_FRAME then return error(7140, "expected svc_frame") end if
  serverFrame = pchecked.readLong(buffer, "server frame")
  deltaFrame = pchecked.readLong(buffer, "delta frame")
  if serverFrame < 0 or deltaFrame >= serverFrame then return error(7141, "invalid frame sequence") end if
  suppressCount = 0
  if protocol != 26 then suppressCount = pchecked.readByte(buffer, "frame suppress count") end if
  areaLength = pchecked.readByte(buffer, "frame area byte count")
  if areaLength > nc.MAX_MAP_AREA_BYTES then return error(7142, "frame area bits exceed protocol capacity") end if
  areaBits = pchecked.readBytes(buffer, areaLength, "frame area bits")

  oldFrame = void
  oldPlayer = pt.zeroPlayerState()
  oldEntities = []
  if deltaFrame > 0 then
    candidate = history[deltaFrame & nc.UPDATE_MASK]
    if candidate is void or not candidate.valid or candidate.serverFrame != deltaFrame then return error(7143, "delta frame is no longer available") end if
    oldFrame = candidate
    oldPlayer = oldFrame.playerState
    oldEntities = oldFrame.entities
  end if
  playerState = pplayer.readMessage(buffer, oldPlayer)
  entities = readPacketEntities(buffer, oldEntities, baselines)
  frame = nt.Frame(true, serverFrame, deltaFrame, serverFrame * 100, suppressCount,
    areaBits, playerState, entities)
  history[serverFrame & nc.UPDATE_MASK] = frame
  return frame
end function

// Read frame.
function readFrame(buffer, history, baselines)
  return readFrameProtocol(buffer, history, baselines, 34)
end function
