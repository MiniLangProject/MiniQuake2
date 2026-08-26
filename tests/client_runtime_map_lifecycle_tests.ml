/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Client level reset, reconnect sequence generation and atomic malformed gates. */
import miniquake2.qcommon.constants as crmap_qc
import miniquake2.qcommon.message as crmap_qmsg
import miniquake2.qcommon.sizebuf as crmap_qsz
import miniquake2.qcommon.types as crmap_qt
import miniquake2.protocol.constants as crmap_pc
import miniquake2.protocol.netchan as crmap_netchan
import miniquake2.network.constants as crmap_nc
import miniquake2.network.client as crmap_client
import miniquake2.network.connectionless as crmap_connectionless
import miniquake2.network.runtime.messages as crmap_messages
import miniquake2.network.runtime.types as crmap_nrtypes
import miniquake2.client.effects.state as crmap_effects
import miniquake2.client.runtime.dispatcher as crmap_dispatcher
import miniquake2.client.runtime.types as crmap_crtypes
import miniquake2.client.state as crmap_state

function clientMapAssert(value, name)
  if not value then return error(8480, name) end if
  return true
end function

function mapAddress()
  return crmap_qt.NetAddress(crmap_nc.NA_IP, [127, 0, 0, 1], array(10, 0), 27910)
end function

function mapRuntime()
  client = crmap_client.create(0x4455, 5000)
  client.state = crmap_nc.CA_ACTIVE
  client.serverName = "127.0.0.1:27910"
  client.serverAddress = mapAddress()
  client.userInfo = "\\name\\MapRuntime"
  client.channel = crmap_netchan.setup(crmap_pc.NS_CLIENT, mapAddress(), client.qport, 0)
  runtime = crmap_dispatcher.create(crmap_nrtypes.createClient(client),
    crmap_state.create(), crmap_effects.createSilent(23))
  runtime.client.state = "active"
  return runtime
end function

function serverData(spawnCount, levelName)
  buffer = crmap_qsz.alloc(256)
  crmap_messages.writeServerData(buffer, spawnCount, false, "baseq2", 0, levelName)
  return crmap_qsz.dataSlice(buffer)
end function

runtime = mapRuntime()
runtime.network.spawnCount = 7
runtime.network.levelName = "old-map"
runtime.network.configStrings[crmap_qc.CS_NAME] = "old-map"
runtime.network.baselines[9].modelIndex = 5
oldFrame = crmap_crtypes.Snapshot(77, -1, 0, bytes(), void, [])
crmap_state.acceptSnapshot(runtime.client, oldFrame)
runtime.network.client.currentFrame = "old-network-frame"
runtime.prints = [crmap_crtypes.PrintHandoff(crmap_qc.PRINT_HIGH, "old-print", 1, false)]
runtime.sequenceInitialized = true
runtime.lastSequence = 9

malformed = crmap_qsz.alloc(256)
crmap_messages.writeServerData(malformed, 8, false, "baseq2", 0, "new-map")
crmap_qmsg.writeByte(malformed, crmap_qc.SVC_BAD)
clientMapAssert(try(crmap_dispatcher.dispatch(runtime,
  crmap_qsz.dataSlice(malformed), 10, 100)) is error,
  "late malformed serverdata packet was accepted")
clientMapAssert(runtime.network.spawnCount == 7 and runtime.network.levelName == "old-map" and
  runtime.network.configStrings[crmap_qc.CS_NAME] == "old-map" and
  runtime.network.baselines[9].modelIndex == 5,
  "malformed serverdata partially reset map tables")
clientMapAssert(runtime.client.current.number == 77 and runtime.network.client.currentFrame == "old-network-frame" and
  len(runtime.prints) == 1 and runtime.lastSequence == 9,
  "malformed serverdata partially reset client state")

accepted = crmap_dispatcher.dispatch(runtime, serverData(8, "new-map"), 10, 101)
clientMapAssert(accepted.accepted and runtime.network.spawnCount == 8 and
  runtime.network.levelName == "new-map", "valid replacement serverdata was rejected")
clientMapAssert(runtime.network.configStrings[crmap_qc.CS_NAME] == "" and
  runtime.network.baselines[9].modelIndex == 0 and runtime.network.client.currentFrame is void and
  runtime.client.current is void and runtime.client.state == "connected" and len(runtime.prints) == 0,
  "serverdata did not clear all per-level client state")

// svc_reconnect is the separate server-restart path.  It is terminal and
// retires the old dispatcher/Netchan sequence generation atomically.
runtime.network.client.state = crmap_nc.CA_ACTIVE
runtime.network.client.channel = crmap_netchan.setup(crmap_pc.NS_CLIENT,
  mapAddress(), runtime.network.client.qport, 200)
runtime.client.state = "active"
runtime.network.ackPending = true
oldChannel = runtime.network.client.channel
clientMapAssert(try(crmap_dispatcher.dispatch(runtime,
  bytes([crmap_qc.SVC_RECONNECT, crmap_qc.SVC_NOP]), 11, 201)) is error,
  "non-terminal svc_reconnect was accepted")
clientMapAssert(runtime.network.client.state == crmap_nc.CA_ACTIVE and
  nativeRawValue(runtime.network.client.channel) == nativeRawValue(oldChannel) and
  runtime.sequenceInitialized and runtime.lastSequence == 10 and runtime.network.ackPending,
  "malformed reconnect partially retired the live channel")

reconnect = crmap_dispatcher.dispatch(runtime, bytes([crmap_qc.SVC_RECONNECT]), 11, 202)
clientMapAssert(reconnect.accepted and runtime.network.client.state == crmap_nc.CA_CONNECTING and
  runtime.network.client.channel is void and not runtime.sequenceInitialized and
  not runtime.network.ackPending and runtime.effects.time == 0,
  "valid svc_reconnect did not begin a fresh connection generation")
clientMapAssert(crmap_client.checkForResend(runtime.network.client, 203).kind == "getchallenge",
  "reconnect did not arm immediate challenge resend")

connected = crmap_client.handleConnectionless(runtime.network.client, mapAddress(),
  crmap_connectionless.clientConnect(), 204)
clientMapAssert(connected.accepted and runtime.network.client.state == crmap_nc.CA_CONNECTED,
  "fresh client_connect after svc_reconnect failed")
fresh = crmap_dispatcher.dispatch(runtime, serverData(9, "restart-map"), 1, 205)
clientMapAssert(fresh.accepted and runtime.sequenceInitialized and runtime.lastSequence == 1 and
  runtime.network.spawnCount == 9, "fresh Netchan sequence one was rejected as stale")

print("client_runtime_map_lifecycle_tests: PASS")
