/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Deterministic Protocol-34 server frame and packet-entity tests. */
import miniquake2.qcommon.sizebuf as qsz
import miniquake2.qcommon.message as qmsg
import miniquake2.protocol.types as pt
import miniquake2.server.snapshot as ssnap

function assertEqual(actual, expected, name)
  if actual != expected then return error(7960, name + ": expected " + expected + ", got " + actual) end if
end function

function entity(number, model, x)
  value = pt.zeroEntityState()
  value.number = number
  value.modelIndex = model
  value.origin[0] = x
  return value
end function

function testFullAndDeltaFrames()
  history = ssnap.createHistory(4)
  baseline2 = entity(2, 2, 0.0)
  ssnap.setBaseline(history, baseline2)

  player1 = pt.zeroPlayerState()
  player1.fov = 90.0
  player1.stats[0] = 100
  first = ssnap.addFrame(history, 1, bytes([0x05]), player1, [entity(1, 1, 8.0), entity(3, 3, 24.0)])
  wire1 = qsz.alloc(1400)
  ssnap.writeFrame(history, first, -1, 0, wire1)
  qmsg.beginReading(wire1)
  decoded1 = ssnap.readFrame(wire1, void, history.baselines)
  assertEqual(decoded1.number, 1, "full frame number")
  assertEqual(decoded1.deltaNumber, -1, "full frame base")
  assertEqual(decoded1.playerState.stats[0], 100, "full player stat")
  assertEqual(len(decoded1.entities), 2, "full entity count")
  assertEqual(decoded1.entities[1].number, 3, "full entity order")

  player2 = pt.copyPlayerState(player1)
  player2.stats[0] = 75
  firstEntity = entity(1, 1, 8.0)
  addedEntity = entity(2, 2, 16.0)
  second = ssnap.addFrame(history, 2, bytes([0x07, 0x01]), player2, [firstEntity, addedEntity])
  wire2 = qsz.alloc(1400)
  ssnap.writeFrame(history, second, 1, 2, wire2)
  qmsg.beginReading(wire2)
  decoded2 = ssnap.readFrame(wire2, decoded1, history.baselines)
  assertEqual(decoded2.deltaNumber, 1, "delta frame base")
  assertEqual(decoded2.suppressCount, 2, "suppress count")
  assertEqual(decoded2.playerState.stats[0], 75, "delta player stat")
  assertEqual(len(decoded2.entities), 2, "delta entity count")
  assertEqual(decoded2.entities[0].number, 1, "unchanged entity retained")
  assertEqual(decoded2.entities[1].number, 2, "baseline entity added")
  assertEqual(decoded2.entities[1].origin[0], 16.0, "new entity delta decoded")
end function

function testHistoryAndValidation()
  history = ssnap.createHistory(1)
  player = pt.zeroPlayerState()
  frame = ssnap.addFrame(history, 20, bytes([]), player, [])
  buffer = qsz.alloc(1400)
  ssnap.writeFrame(history, frame, 1, 0, buffer)
  qmsg.beginReading(buffer)
  decoded = ssnap.readFrame(buffer, void, history.baselines)
  assertEqual(decoded.deltaNumber, -1, "stale delta falls back to full")
  malformed = try(ssnap.addFrame(history, 21, bytes([]), player, [entity(2, 1, 0.0), entity(1, 1, 0.0)]))
  assertEqual(typeof(malformed), "error", "unsorted entities rejected")
end function

testFullAndDeltaFrames()
testHistoryAndValidation()
print("MiniQuake2 server snapshot tests passed: 2")
