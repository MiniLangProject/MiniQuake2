/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Frame→client.state/entity-event routing plus malformed/replay guards. */
import miniquake2.qcommon.constants as qc
import miniquake2.qcommon.sizebuf as qsz
import miniquake2.protocol.constants as pc
import miniquake2.protocol.types as pt
import miniquake2.network.constants as nc
import miniquake2.network.client as nclient
import miniquake2.network.snapshot as nsnapshot
import miniquake2.network.runtime.types as nrtypes
import miniquake2.client.effects.constants as ceconstants
import miniquake2.client.effects.state as cestate
import miniquake2.client.runtime.dispatcher as crdispatcher
import miniquake2.client.state as cstate

function clientFrameAssertEqual(actual, expected, name)
  if actual != expected then return error(8310, name + ": expected " + expected + ", got " + actual) end if
  return true
end function

function clientFrameCreate()
  networkClient = nclient.create(0x1111, 5000)
  networkClient.state = nc.CA_CONNECTED
  return crdispatcher.create(nrtypes.createClient(networkClient), cstate.create(), cestate.createSilent(9))
end function

clientFrameRuntime = clientFrameCreate()
clientFrameEntity = pt.zeroEntityState()
clientFrameEntity.number = 1
clientFrameEntity.modelIndex = 1
clientFrameEntity.origin = [4.0, 5.0, 6.0]
clientFrameEntity.event = ceconstants.EV_ITEM_RESPAWN
clientFrameEntity.effects = ceconstants.EF_TELEPORTER
clientFramePlayer = pt.zeroPlayerState()
clientFramePlayer.fov = 90.0
clientFrameValue = nsnapshot.createFrame(1, bytes([3]), clientFramePlayer, [clientFrameEntity])
clientFrameBuffer = qsz.alloc(1024)
clientFrameHistory = array(nc.UPDATE_BACKUP, void)
nsnapshot.writeFrameForClient(clientFrameBuffer, clientFrameValue, -1,
  clientFrameHistory, clientFrameRuntime.network.baselines, 1, 0)
clientFramePayload = qsz.dataSlice(clientFrameBuffer)
clientFrameResult = crdispatcher.dispatch(clientFrameRuntime, clientFramePayload, 20, 100)
clientFrameAssertEqual(clientFrameResult.frames, 1, "frame accepted")
clientFrameAssertEqual(clientFrameRuntime.client.current.number, 1, "client.state current snapshot")
clientFrameAssertEqual(clientFrameRuntime.client.state, "active", "client.state activated")
clientFrameAssertEqual(clientFrameRuntime.network.client.currentFrame.serverFrame, 1, "network frame retained")
clientFrameAssertEqual(clientFrameRuntime.effects.particleCount, 72,
  "entity event plus persistent teleporter particles")
clientFrameAssertEqual(len(clientFrameRuntime.effects.soundEvents), 1, "entity event sound")

// Malformed packets do not consume their sequence; a repaired packet with the
// same sequence is accepted. Unknown service opcodes are hard failures.
clientMalformedRuntime = clientFrameCreate()
clientFrameAssertEqual(typeof(try(crdispatcher.dispatch(clientMalformedRuntime,
  bytes([qc.SVC_CONFIGSTRING, 0]), 7, 0))), "error", "truncated configstring rejected")
clientFrameAssertEqual(clientMalformedRuntime.sequenceInitialized, false, "malformed sequence not committed")
clientFrameValid = crdispatcher.dispatch(clientMalformedRuntime, bytes([qc.SVC_NOP]), 7, 1)
clientFrameAssertEqual(clientFrameValid.accepted, true, "repaired same sequence accepted")
clientFrameAssertEqual(typeof(try(crdispatcher.dispatch(clientMalformedRuntime,
  bytes([qc.SVC_BAD]), 8, 2))), "error", "bad opcode rejected")
clientFrameAssertEqual(clientMalformedRuntime.lastSequence, 7, "bad opcode sequence not committed")
clientFrameAssertEqual(typeof(try(crdispatcher.dispatch(clientMalformedRuntime,
  bytes([qc.SVC_DOWNLOAD, 2, 0, 50, 1]), 8, 3))), "error", "truncated download rejected")
clientFrameAssertEqual(typeof(try(crdispatcher.dispatch(clientMalformedRuntime,
  bytes([qc.SVC_STUFFTEXT, 120, 0, qc.SVC_BAD]), 8, 4))), "error", "late malformed opcode rejected")
clientFrameAssertEqual(len(clientMalformedRuntime.network.stuffedTexts), 0, "malformed packet has no partial stufftext")
clientFrameAssertEqual(clientMalformedRuntime.lastSequence, 7, "late malformed packet not committed")

// Modular ordering accepts the Protocol-34 31-bit wrap and rejects old data.
clientWrapRuntime = clientFrameCreate()
clientFrameAssertEqual(crdispatcher.dispatch(clientWrapRuntime, bytes([qc.SVC_NOP]), pc.SEQUENCE_MASK, 0).accepted, true, "maximum sequence")
clientFrameAssertEqual(crdispatcher.dispatch(clientWrapRuntime, bytes([qc.SVC_NOP]), 0, 1).accepted, true, "wrapped sequence")
clientFrameAssertEqual(crdispatcher.dispatch(clientWrapRuntime, bytes([qc.SVC_NOP]), pc.SEQUENCE_MASK, 2).accepted, false, "pre-wrap replay rejected")
print("MiniQuake2 client runtime frame/malformed tests passed: 1")
