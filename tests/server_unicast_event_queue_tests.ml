/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* GameImport cprintf/centerprintf/unicast queue framing and bounds. */
import miniquake2.qcommon.constants as suq_qc
import miniquake2.game.types as suq_gtypes
import miniquake2.server.game_bridge as suq_bridge
import miniquake2.server.game_messages as suq_messages

function unicastQueueAssert(value, label)
  if value != true then return error(8468, label) end if
  return true
end function

runtime = suq_bridge.createRuntime(2)
imports = suq_bridge.makeImports(runtime)
client = suq_gtypes.zeroEdict(1)

imports.cprintf(client, suq_qc.PRINT_HIGH, "Denied")
imports.centerprintf(client, "Need key")
unicastQueueAssert(len(runtime.pendingUnicasts) == 2 and runtime.nextUnicastSerial == 2,
  "client print imports did not enqueue typed unicast events")
printEvent = runtime.pendingUnicasts[0]
centerEvent = runtime.pendingUnicasts[1]
unicastQueueAssert(printEvent.entity == 1 and printEvent.reliable and
  printEvent.payload[0] == suq_qc.SVC_PRINT and printEvent.payload[1] == suq_qc.PRINT_HIGH and
  printEvent.payload[len(printEvent.payload) - 1] == 0,
  "cprintf Protocol-34 framing mismatch")
unicastQueueAssert(centerEvent.entity == 1 and centerEvent.reliable and
  centerEvent.payload[0] == suq_qc.SVC_CENTERPRINT and
  centerEvent.payload[len(centerEvent.payload) - 1] == 0,
  "centerprintf Protocol-34 framing mismatch")

imports.writeByte(suq_qc.SVC_NOP)
imports.unicast(client, false)
unicastQueueAssert(len(runtime.pendingUnicasts) == 3 and
  not runtime.pendingUnicasts[2].reliable and
  runtime.pendingUnicasts[2].payload == bytes([suq_qc.SVC_NOP]),
  "raw unreliable unicast framing mismatch")

payload = bytes([1, 2, 3])
owned = suq_messages.enqueueUnicast(runtime, client, true, payload)
payload[0] = 99
unicastQueueAssert(owned.payload == bytes([1, 2, 3]),
  "queued unicast retained caller-owned payload")
queueBefore = len(runtime.pendingUnicasts)
serialBefore = runtime.nextUnicastSerial
invalidClient = suq_gtypes.zeroEdict(3)
unicastQueueAssert(try(suq_messages.enqueueUnicast(runtime, invalidClient, true,
  bytes([1]))) is error and len(runtime.pendingUnicasts) == queueBefore and
  runtime.nextUnicastSerial == serialBefore,
  "invalid unicast target partially mutated queue")
unicastQueueAssert(imports.centerprintf(invalidClient, "not a client") == false and
  len(runtime.pendingUnicasts) == queueBefore,
  "centerprintf non-client was not ignored like Quake II 3.19")
unicastQueueAssert(imports.cprintf(void, suq_qc.PRINT_HIGH, "console") == true and
  len(runtime.pendingUnicasts) == queueBefore,
  "null cprintf did not use the console-only path")
unicastQueueAssert(try(imports.cprintf(client, 99, "bad")) is error and
  len(runtime.pendingUnicasts) == queueBefore,
  "invalid cprintf level partially mutated queue")

full = suq_bridge.createRuntime(1)
fullClient = suq_gtypes.zeroEdict(1)
index = 0
while index < suq_messages.MAX_PENDING_UNICAST_EVENTS
  suq_messages.enqueueUnicast(full, fullClient, false, bytes([suq_qc.SVC_NOP]))
  index = index + 1
end while
unicastQueueAssert(try(suq_messages.enqueueUnicast(full, fullClient, false,
  bytes([suq_qc.SVC_NOP]))) is error and
  len(full.pendingUnicasts) == suq_messages.MAX_PENDING_UNICAST_EVENTS and
  full.nextUnicastSerial == suq_messages.MAX_PENDING_UNICAST_EVENTS,
  "bounded unicast overflow changed queue")

print("server_unicast_event_queue_tests: PASS")
