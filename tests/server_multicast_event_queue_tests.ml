/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* GameImport multicast queue ownership, framing and bounded-failure tests. */
import miniquake2.qcommon.types as smq_qtypes
import miniquake2.game.constants as smq_gc
import miniquake2.server.game_bridge as smq_bridge
import miniquake2.server.game_messages as smq_messages

// Assert the multicast queue test condition.
function multicastQueueAssert(value, label)
  if value != true then return error(8465, label) end if
  return true
end function

runtime = smq_bridge.createRuntime(1)
imports = smq_bridge.makeImports(runtime)
origin = smq_qtypes.Vec3(8.0, 16.0, 24.0)
imports.writeByte(2)
imports.writeShort(7)
imports.writeByte(57)
imports.multicast(origin, smq_gc.MULTICAST_PVS)
multicastQueueAssert(len(runtime.pendingMulticasts) == 1 and runtime.nextMulticastSerial == 1,
  "GameImport multicast did not enqueue one typed event")
event = runtime.pendingMulticasts[0]
multicastQueueAssert(event.serial == 0 and event.destination == smq_gc.MULTICAST_PVS and
  event.origin.x == 8.0 and event.origin.y == 16.0 and event.origin.z == 24.0,
  "queued multicast metadata mismatch")
multicastQueueAssert(event.payload == bytes([2, 7, 0, 57]),
  "queued multicast did not preserve exact service-command framing")
origin.x = 999.0
multicastQueueAssert(event.origin.x == 8.0,
  "queued multicast retained caller-owned origin")

payload = bytes([10, 20, 30])
owned = smq_messages.enqueue(runtime, smq_qtypes.Vec3(1.0, 2.0, 3.0),
  smq_gc.MULTICAST_ALL_R, payload)
payload[0] = 99
multicastQueueAssert(owned.payload == bytes([10, 20, 30]) and
  smq_messages.reliableDestination(owned.destination),
  "queued multicast retained caller-owned payload")

queueBefore = len(runtime.pendingMulticasts)
serialBefore = runtime.nextMulticastSerial
multicastQueueAssert(try(smq_messages.enqueue(runtime, origin, 99, bytes([1]))) is error and
  len(runtime.pendingMulticasts) == queueBefore and runtime.nextMulticastSerial == serialBefore,
  "invalid destination partially mutated multicast queue")
multicastQueueAssert(try(smq_messages.enqueue(runtime, origin, smq_gc.MULTICAST_ALL, bytes())) is error and
  len(runtime.pendingMulticasts) == queueBefore,
  "empty payload partially mutated multicast queue")

full = smq_bridge.createRuntime(1)
index = 0
while index < smq_messages.MAX_PENDING_MULTICAST_EVENTS
  smq_messages.enqueue(full, smq_qtypes.Vec3(0.0, 0.0, 0.0),
    smq_gc.MULTICAST_ALL, bytes([1]))
  index = index + 1
end while
multicastQueueAssert(smq_messages.enqueue(full, smq_qtypes.Vec3(0.0, 0.0, 0.0),
  smq_gc.MULTICAST_ALL, bytes([1])) == false and
  len(full.pendingMulticasts) == smq_messages.MAX_PENDING_MULTICAST_EVENTS and
  full.nextMulticastSerial == smq_messages.MAX_PENDING_MULTICAST_EVENTS,
  "unreliable multicast overflow was not dropped atomically")
multicastQueueAssert(try(smq_messages.enqueue(full,
  smq_qtypes.Vec3(0.0, 0.0, 0.0), smq_gc.MULTICAST_ALL_R,
  bytes([1]))) is error, "reliable multicast overflow was silently dropped")

optimized = smq_bridge.createRuntime(1)
smq_messages.enableOptimizedQueues(optimized)
smq_messages.enqueue(optimized, smq_qtypes.Vec3(1.0, 1.0, 1.0),
  smq_gc.MULTICAST_PVS, bytes([7, 8]))
multicastQueueAssert(len(optimized.pendingMulticasts) == 0 and
  optimized.pendingMulticastCount == 1 and optimized.pendingMulticastBytes == 2 and
  smq_messages.pendingMulticastSnapshot(optimized)[0].payload == bytes([7, 8]),
  "optimized multicast queue did not retain its fixed-storage prefix")
smq_messages.clearMulticasts(optimized)
multicastQueueAssert(optimized.pendingMulticastCount == 0 and
  optimized.pendingMulticastBytes == 0,
  "optimized multicast queue did not clear its counters")

print("server_multicast_event_queue_tests: PASS")
