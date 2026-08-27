/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Protocol-34 UI service framing, bounded handoff queues and malformed guards. */
import miniquake2.qcommon.constants as qc
import miniquake2.qcommon.message as qmsg
import miniquake2.qcommon.sizebuf as qsz
import miniquake2.network.constants as nc
import miniquake2.network.client as nclient
import miniquake2.network.runtime.pump as rpump
import miniquake2.network.runtime.types as nrtypes
import miniquake2.client.effects.state as cestate
import miniquake2.client.runtime.dispatcher as crdispatcher
import miniquake2.client.state as cstate

// Assert the client ui runtime equal test condition.
function clientUiRuntimeAssertEqual(actual, expected, name)
  if actual != expected then return error(8320, name + ": expected " + expected + ", got " + actual) end if
  return true
end function

// Create client ui runtime.
function clientUiRuntimeCreate()
  networkClient = nclient.create(0x2222, 5000)
  networkClient.state = nc.CA_CONNECTED
  return crdispatcher.create(nrtypes.createClient(networkClient), cstate.create(), cestate.createSilent(3))
end function

clientUiRuntime = clientUiRuntimeCreate()
clientUiBuffer = qsz.alloc(1400)
qmsg.writeByte(clientUiBuffer, qc.SVC_PRINT)
qmsg.writeByte(clientUiBuffer, qc.PRINT_CHAT)
qmsg.writeString(clientUiBuffer, "Marine: hello\n")
qmsg.writeByte(clientUiBuffer, qc.SVC_CENTERPRINT)
qmsg.writeString(clientUiBuffer, "MISSION START")
qmsg.writeByte(clientUiBuffer, qc.SVC_LAYOUT)
qmsg.writeString(clientUiBuffer, "xl 8 yt 8 string hud")
qmsg.writeByte(clientUiBuffer, qc.SVC_INVENTORY)
clientUiIndex = 0
while clientUiIndex < qc.MAX_ITEMS
  clientUiValue = 0
  if clientUiIndex == 0 then clientUiValue = -7 end if
  if clientUiIndex == qc.MAX_ITEMS - 1 then clientUiValue = 32767 end if
  qmsg.writeShort(clientUiBuffer, clientUiValue)
  clientUiIndex = clientUiIndex + 1
end while
qmsg.writeByte(clientUiBuffer, qc.SVC_NOP)

clientUiResult = crdispatcher.dispatch(clientUiRuntime, qsz.dataSlice(clientUiBuffer), 1, 1234)
clientUiRuntimeAssertEqual(clientUiResult.commands, 5, "combined UI command framing")
clientUiRuntimeAssertEqual(clientUiRuntime.prints[0].level, qc.PRINT_CHAT, "print level")
clientUiRuntimeAssertEqual(clientUiRuntime.prints[0].text, "Marine: hello\n", "print text")
clientUiRuntimeAssertEqual(clientUiRuntime.prints[0].chat, true, "chat handoff flag")
clientUiRuntimeAssertEqual(clientUiRuntime.prints[0].time, 1234, "print handoff time")
clientUiRuntimeAssertEqual(clientUiRuntime.centerPrints[0].text, "MISSION START", "centerprint text")
clientUiRuntimeAssertEqual(clientUiRuntime.layouts[0].text, "xl 8 yt 8 string hud", "layout text")
clientUiRuntimeAssertEqual(len(clientUiRuntime.inventories[0].values), qc.MAX_ITEMS, "inventory width")
clientUiRuntimeAssertEqual(clientUiRuntime.inventories[0].values[0], -7, "signed inventory value")
clientUiRuntimeAssertEqual(clientUiRuntime.inventories[0].values[255], 32767, "inventory final value")
clientUiRuntimeAssertEqual(len(crdispatcher.takePrints(clientUiRuntime)), 1, "print handoff drain")
clientUiRuntimeAssertEqual(len(clientUiRuntime.prints), 0, "print queue cleared")
clientUiRuntimeAssertEqual(len(crdispatcher.takeCenterPrints(clientUiRuntime)), 1, "centerprint handoff drain")
clientUiRuntimeAssertEqual(len(crdispatcher.takeLayouts(clientUiRuntime)), 1, "layout handoff drain")
clientUiRuntimeAssertEqual(len(crdispatcher.takeInventories(clientUiRuntime)), 1, "inventory handoff drain")
clientUiRuntimeAssertEqual(typeof(rpump.pumpIntegratedClient), "function", "integrated pump import graph")

// Queues are bounded even if a server emits a print flood in one valid packet.
clientUiFloodBuffer = qsz.alloc(512)
clientUiFloodIndex = 0
while clientUiFloodIndex < 70
  qmsg.writeByte(clientUiFloodBuffer, qc.SVC_PRINT)
  qmsg.writeByte(clientUiFloodBuffer, qc.PRINT_LOW)
  qmsg.writeString(clientUiFloodBuffer, "x")
  clientUiFloodIndex = clientUiFloodIndex + 1
end while
crdispatcher.dispatch(clientUiRuntime, qsz.dataSlice(clientUiFloodBuffer), 2, 1300)
clientUiRuntimeAssertEqual(len(clientUiRuntime.prints), 64, "bounded print queue")

clientUiMalformed = clientUiRuntimeCreate()
clientUiRuntimeAssertEqual(typeof(try(crdispatcher.dispatch(clientUiMalformed,
  bytes([qc.SVC_PRINT, 4, 0]), 1, 0))), "error", "invalid print level rejected")
clientUiRuntimeAssertEqual(typeof(try(crdispatcher.dispatch(clientUiMalformed,
  bytes([qc.SVC_CENTERPRINT, 65]), 1, 0))), "error", "unterminated centerprint rejected")
clientUiRuntimeAssertEqual(typeof(try(crdispatcher.dispatch(clientUiMalformed,
  bytes([qc.SVC_LAYOUT, 65]), 1, 0))), "error", "unterminated layout rejected")
clientUiRuntimeAssertEqual(typeof(try(crdispatcher.dispatch(clientUiMalformed,
  bytes([qc.SVC_INVENTORY, 1, 0]), 1, 0))), "error", "truncated inventory rejected")

// A 1024-byte string cannot fit the destination including its terminator.
clientUiLongBytes = bytes(qc.MAX_STRING_CHARS)
clientUiLongIndex = 0
while clientUiLongIndex < len(clientUiLongBytes)
  clientUiLongBytes[clientUiLongIndex] = 65
  clientUiLongIndex = clientUiLongIndex + 1
end while
clientUiLongBuffer = qsz.alloc(1400)
qmsg.writeByte(clientUiLongBuffer, qc.SVC_CENTERPRINT)
qmsg.writeString(clientUiLongBuffer, decode(clientUiLongBytes))
clientUiRuntimeAssertEqual(typeof(try(crdispatcher.dispatch(clientUiMalformed,
  qsz.dataSlice(clientUiLongBuffer), 1, 0))), "error", "oversized centerprint rejected")

// Preflight keeps an earlier valid UI command from leaking out of a packet
// that later becomes malformed.
clientUiLateBad = bytes([qc.SVC_PRINT, qc.PRINT_HIGH, 111, 107, 0, qc.SVC_BAD])
clientUiRuntimeAssertEqual(typeof(try(crdispatcher.dispatch(clientUiMalformed,
  clientUiLateBad, 1, 0))), "error", "late bad UI packet rejected")
clientUiRuntimeAssertEqual(len(clientUiMalformed.prints), 0, "late bad packet has no partial print")
clientUiRuntimeAssertEqual(clientUiMalformed.sequenceInitialized, false, "malformed UI sequence not committed")
print("MiniQuake2 client runtime UI messages tests passed: 1")

