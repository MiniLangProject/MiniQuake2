/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later

Deterministic protocol-34 frame and packet-entity list orchestration tests.
*/
import miniquake2.qcommon.sizebuf as qsz
import miniquake2.qcommon.message as qmsg
import miniquake2.protocol.types as pt
import miniquake2.network.constants as nc
import miniquake2.network.client as nclient
import miniquake2.network.snapshot as nsnapshot

function assertEqual(actual, expected, name)
  if actual != expected then return error(7960, name + ": expected " + expected + ", got " + actual) end if
  return true
end function

function assertTrue(value, name)
  if value != true then return error(7961, name + ": expected true") end if
  return true
end function

function readingBuffer(data)
  buffer = qsz.alloc(len(data))
  qsz.writeBytes(buffer, data)
  qmsg.beginReading(buffer)
  return buffer
end function

function entity(number, x, model)
  value = pt.zeroEntityState()
  value.number = number
  value.origin[0] = x
  value.modelIndex = model
  return value
end function

function baselines()
  values = array(1024, void)
  values[1] = pt.zeroEntityState()
  values[2] = pt.zeroEntityState()
  values[3] = pt.zeroEntityState()
  return values
end function

function testPacketEntityMerge()
  oldEntities = [entity(1, 1.0, 2), entity(2, 2.0, 3)]
  newEntities = [entity(1, 1.5, 2), entity(3, 3.0, 4)]
  buffer = qsz.alloc(256)
  nsnapshot.writePacketEntities(buffer, oldEntities, newEntities, baselines(), 1)
  decoded = nsnapshot.readPacketEntities(readingBuffer(qsz.dataSlice(buffer)), oldEntities, baselines())
  assertEqual(len(decoded), 2, "decoded entity count")
  assertEqual(decoded[0].number, 1, "delta entity number")
  assertEqual(decoded[0].origin[0], 1.5, "delta entity origin")
  assertEqual(decoded[1].number, 3, "baseline entity number")
  assertEqual(decoded[1].modelIndex, 4, "baseline entity model")
  return true
end function

function testFrameRoundtrip()
  historyWrite = array(nc.UPDATE_BACKUP, void)
  historyRead = array(nc.UPDATE_BACKUP, void)
  basePlayer = pt.zeroPlayerState()
  basePlayer.pmove.origin = [8, 16, 24]
  baseFrame = nsnapshot.createFrame(10, bytes([1, 2]), basePlayer, [entity(1, 1.0, 2), entity(2, 2.0, 3)])
  historyWrite[10 & nc.UPDATE_MASK] = baseFrame
  historyRead[10 & nc.UPDATE_MASK] = baseFrame

  player = pt.copyPlayerState(basePlayer)
  player.pmove.origin[0] = 16
  player.viewAngles[1] = 90.0
  current = nsnapshot.createFrame(11, bytes([3, 4, 5]), player, [entity(1, 1.5, 2), entity(3, 3.0, 4)])
  buffer = qsz.alloc(512)
  wireDelta = nsnapshot.writeFrameForClient(buffer, current, 10, historyWrite, baselines(), 1, 2)
  assertEqual(wireDelta, 10, "selected delta frame")
  wire = qsz.dataSlice(buffer)
  assertEqual(wire[0], nc.SVC_FRAME, "frame opcode")
  client = nclient.create(1, 1000)
  client.state = nc.CA_CONNECTED
  client.frames = historyRead
  decoded = nclient.parseFrame(client, readingBuffer(wire), baselines())
  assertEqual(decoded.serverFrame, 11, "decoded server frame")
  assertEqual(decoded.deltaFrame, 10, "decoded delta frame")
  assertEqual(decoded.suppressCount, 2, "decoded suppress count")
  assertEqual(len(decoded.areaBits), 3, "decoded area bits")
  assertEqual(decoded.playerState.pmove.origin[0], 16, "decoded player origin")
  assertEqual(decoded.playerState.viewAngles[1], 90.0, "decoded player angle")
  assertEqual(len(decoded.entities), 2, "decoded frame entities")
  assertEqual(decoded.entities[1].number, 3, "decoded new entity")

  assertEqual(client.state, nc.CA_ACTIVE, "valid frame activates client")
  return true
end function

function testFullFrameFallbackAndMalformed()
  history = array(nc.UPDATE_BACKUP, void)
  frame = nsnapshot.createFrame(20, bytes(), pt.zeroPlayerState(), [entity(1, 0.0, 1)])
  buffer = qsz.alloc(256)
  assertEqual(nsnapshot.writeFrameForClient(buffer, frame, 1, history, baselines(), 1, 0), -1, "old delta falls back to full frame")
  decoded = nsnapshot.readFrame(readingBuffer(qsz.dataSlice(buffer)), array(nc.UPDATE_BACKUP, void), baselines())
  assertEqual(decoded.deltaFrame, -1, "full frame marker")

  malformed = qsz.dataSlice(buffer)
  malformed[10] = nc.MAX_MAP_AREA_BYTES + 1
  assertTrue(try(nsnapshot.readFrame(readingBuffer(malformed), array(nc.UPDATE_BACKUP, void), baselines())) is error, "oversized area bits rejected")
  assertTrue(try(nsnapshot.writePacketEntities(qsz.alloc(32), [entity(2, 0.0, 1), entity(1, 0.0, 1)], [], baselines(), 1)) is error, "unsorted entities rejected")
  return true
end function

function testSnapshotHistoryRootingSoak()
  baselineTable = array(1024, void)
  entityIndex = 1
  while entityIndex <= 24
    baselineTable[entityIndex] = pt.zeroEntityState()
    entityIndex = entityIndex + 1
  end while
  writeHistory = array(nc.UPDATE_BACKUP, void)
  readHistory = array(nc.UPDATE_BACKUP, void)
  previousEntities = array(24)
  entityIndex = 0
  while entityIndex < 24
    previousEntities[entityIndex] = entity(entityIndex + 1, entityIndex * 1.0, 1)
    entityIndex = entityIndex + 1
  end while
  previous = nsnapshot.createFrame(1, bytes([1]), pt.zeroPlayerState(), previousEntities)
  writeHistory[1 & nc.UPDATE_MASK] = previous
  readHistory[1 & nc.UPDATE_MASK] = previous
  pressure = array(16, void)
  frameNumber = 2
  while frameNumber <= 500
    currentEntities = array(24)
    entityIndex = 0
    while entityIndex < 24
      currentEntities[entityIndex] = entity(entityIndex + 1,
        frameNumber * 0.125 + entityIndex, 1)
      entityIndex = entityIndex + 1
    end while
    current = nsnapshot.createFrame(frameNumber, bytes([frameNumber & 255]),
      pt.zeroPlayerState(), currentEntities)
    buffer = qsz.alloc(4096)
    nsnapshot.writeFrameForClient(buffer, current, frameNumber - 1,
      writeHistory, baselineTable, 1, 0)
    decoded = nsnapshot.readFrame(readingBuffer(qsz.dataSlice(buffer)),
      readHistory, baselineTable)
    assertEqual(len(decoded.entities), 24, "soak entity count")
    assertEqual(decoded.entities[23].origin[0], frameNumber * 0.125 + 23.0,
      "soak terminal entity origin")
    pressure[frameNumber & 15] = array(4096, frameNumber)
    frameNumber = frameNumber + 1
  end while
  return true
end function

function main(args)
  print "MiniQuake2 network snapshot tests starting: 4"
  result = try(testPacketEntityMerge())
  if result is error then print "FAIL packet entities: " + result.message; return 1 end if
  result = try(testFrameRoundtrip())
  if result is error then print "FAIL frame: " + result.message; return 1 end if
  result = try(testFullFrameFallbackAndMalformed())
  if result is error then print "FAIL malformed: " + result.message; return 1 end if
  result = try(testSnapshotHistoryRootingSoak())
  if result is error then print "FAIL snapshot rooting soak: " + result.message; return 1 end if
  print "MiniQuake2 network snapshot tests passed: 4"
  return 0
end function
