/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Bounded GameImport sound queue and Protocol-34 golden fragment tests. */
import miniquake2.qcommon.types as sseq_test_qt
import miniquake2.game.constants as sseq_test_gc
import miniquake2.game.types as sseq_test_gt
import miniquake2.server.game_bridge as sseq_test_bridge
import miniquake2.server.sound_events as sseq_test_events
import miniquake2.server.types as sseq_test_types

// Assert the sound queue test condition.
function soundQueueAssert(value, name)
  if not value then return error(8450, name) end if
  return true
end function

runtime = sseq_test_bridge.createRuntime(1)
imports = sseq_test_bridge.makeImports(runtime)
entity = sseq_test_gt.zeroEdict(3)
event = imports.positionedSound(sseq_test_qt.vec3(1.0, -2.0, 3.0), entity,
  sseq_test_gc.CHAN_VOICE, 7, 0.5, 2.0, 0.025)
soundQueueAssert(event.serial == 0 and event.entity == 3 and event.channel == 2,
  "typed positioned sound mismatch")
golden = bytes([9, 31, 7, 127, 128, 25, 26, 0, 8, 0, 240, 255, 24, 0])
soundQueueAssert(sseq_test_events.encode(event) == golden,
  "Protocol-34 svc_sound golden fragment mismatch")
soundQueueAssert(runtime.pendingSoundCount == 1 and runtime.nextSoundSerial == 1,
  "sound queue sequencing mismatch")

// SV_StartSound spatializes inline brush models at their bbox midpoint rather
// than at the mapper-defined model origin. This keeps large mover volume and
// panning faithful to the original client.
bspEntity = sseq_test_gt.zeroEdict(9)
bspEntity.solid = sseq_test_gc.SOLID_BSP
bspEntity.state.origin = sseq_test_qt.vec3(100.0, 200.0, 300.0)
bspEntity.mins = sseq_test_qt.vec3(-16.0, -8.0, -4.0)
bspEntity.maxs = sseq_test_qt.vec3(48.0, 24.0, 12.0)
bspEvent = imports.sound(bspEntity, sseq_test_gc.CHAN_BODY, 8, 1.0, 1.0, 0.0)
soundQueueAssert(bspEvent.position.x == 116.0 and
  bspEvent.position.y == 208.0 and bspEvent.position.z == 304.0,
  "inline BSP sound did not use its bounds midpoint")
noClientEntity = sseq_test_gt.zeroEdict(10)
noClientEntity.serverFlags = sseq_test_gc.SVF_NOCLIENT
noClientEntity.state.origin = sseq_test_qt.vec3(-10.0, 20.0, 30.0)
noClientEvent = imports.sound(noClientEntity, sseq_test_gc.CHAN_AUTO, 9,
  1.0, 1.0, 0.0)
soundQueueAssert(noClientEvent.position.x == -10.0 and
  noClientEvent.position.y == 20.0 and noClientEvent.position.z == 30.0,
  "SVF_NOCLIENT sound did not carry an explicit origin")
ordinaryEntity = sseq_test_gt.zeroEdict(11)
ordinaryEvent = imports.sound(ordinaryEntity, sseq_test_gc.CHAN_AUTO, 10,
  1.0, 1.0, 0.0)
soundQueueAssert(ordinaryEvent.position is void,
  "ordinary entity sound unexpectedly froze its snapshot origin")

// Validation is performed before append; every malformed call leaves the
// queue and serial untouched.
queueBefore = runtime.pendingSoundCount
serialBefore = runtime.nextSoundSerial
soundQueueAssert(try(imports.sound(entity, 32, 7, 1.0, 1.0, 0.0)) is error,
  "reserved channel flags accepted")
soundQueueAssert(try(imports.sound(entity, 0, 0, 1.0, 1.0, 0.0)) is error,
  "zero sound index accepted")
soundQueueAssert(try(imports.sound(entity, 0, 7, 1.1, 1.0, 0.0)) is error,
  "oversized volume accepted")
soundQueueAssert(try(imports.sound(entity, 0, 7, 1.0, 4.1, 0.0)) is error,
  "oversized attenuation accepted")
soundQueueAssert(try(imports.positionedSound(sseq_test_qt.vec3(5000.0, 0.0, 0.0),
  entity, 0, 7, 1.0, 1.0, 0.0)) is error, "out-of-range position accepted")
soundQueueAssert(runtime.pendingSoundCount == queueBefore and
  runtime.nextSoundSerial == serialBefore, "malformed sound partially changed queue")

overflowRuntime = sseq_test_bridge.createRuntime(1)
overflowImports = sseq_test_bridge.makeImports(overflowRuntime)
index = 0
while index < sseq_test_events.MAX_PENDING_SOUND_EVENTS
  overflowImports.sound(entity, sseq_test_gc.CHAN_AUTO, 1, 1.0, 1.0, 0.0)
  index = index + 1
end while
soundQueueAssert(overflowRuntime.pendingSoundCount == sseq_test_events.MAX_PENDING_SOUND_EVENTS,
  "bounded queue did not fill")
soundQueueAssert(try(overflowImports.sound(entity, 0, 1, 1.0, 1.0, 0.0)) is error,
  "sound queue overflow accepted")
soundQueueAssert(overflowRuntime.pendingSoundCount == sseq_test_events.MAX_PENDING_SOUND_EVENTS and
  overflowRuntime.nextSoundSerial == sseq_test_events.MAX_PENDING_SOUND_EVENTS,
  "overflow mutated bounded queue")

// A malformed tail rejects the full encode preflight without consuming any
// previously queued event.
malformed = sseq_test_types.PendingSoundEvent(
  sseq_test_events.MAX_PENDING_SOUND_EVENTS, false, 0, 0, 0, 300,
  1.0, 1.0, 0.0, void)
validBatch = sseq_test_events.pendingSnapshot(overflowRuntime)
malformedBatch = array(len(validBatch) + 1)
index = 0
while index < len(validBatch)
  malformedBatch[index] = validBatch[index]
  index = index + 1
end while
malformedBatch[len(validBatch)] = malformed
soundQueueAssert(try(sseq_test_events.encodeAll(malformedBatch)) is error,
  "malformed pending event encoded")
soundQueueAssert(overflowRuntime.pendingSoundCount == sseq_test_events.MAX_PENDING_SOUND_EVENTS,
  "failed preflight consumed queue")
print("server_sound_event_queue_tests: PASS")
