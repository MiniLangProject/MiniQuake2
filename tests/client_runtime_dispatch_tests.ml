/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Integrated serverdata/config/baseline/download/effect and demo handoff tests. */
import miniquake2.qcommon.constants as qc
import miniquake2.qcommon.message as qmsg
import miniquake2.qcommon.sizebuf as qsz
import miniquake2.qcommon.types as qt
import miniquake2.protocol.types as pt
import miniquake2.network.constants as nc
import miniquake2.network.client as nclient
import miniquake2.network.runtime.messages as rmessages
import miniquake2.network.runtime.types as nrtypes
import miniquake2.network.runtime.pump as crpump
import miniquake2.client.demo as cdemo
import miniquake2.client.effects.constants as ceconstants
import miniquake2.client.effects.state as cestate
import miniquake2.client.runtime.dispatcher as crdispatcher
import miniquake2.client.state as cstate

// Assert the client runtime equal test condition.
function clientRuntimeAssertEqual(actual, expected, name)
  if actual != expected then return error(8300, name + ": expected " + expected + ", got " + actual) end if
  return true
end function

// Create client runtime.
function clientRuntimeCreate()
  networkClient = nclient.create(0x1234, 5000)
  networkClient.state = nc.CA_CONNECTED
  return crdispatcher.create(nrtypes.createClient(networkClient), cstate.create(), cestate.createSilent(7))
end function

clientRuntime = clientRuntimeCreate()
clientRuntimeDemo = cdemo.create()
crdispatcher.setDemoRecorder(clientRuntime, clientRuntimeDemo)
clientRuntimeBuffer = qsz.alloc(1024)
rmessages.writeServerData(clientRuntimeBuffer, 44, false, "baseq2", 0, "Runtime Unit")
rmessages.writeConfigString(clientRuntimeBuffer, qc.CS_NAME, "Runtime Unit")
rmessages.writeConfigString(clientRuntimeBuffer, qc.CS_LIGHTS + 3, "az")
clientRuntimeBaseline = pt.zeroEntityState()
clientRuntimeBaseline.number = 1
clientRuntimeBaseline.modelIndex = 2
clientRuntimeBaseline.origin = [10.0, 20.0, 30.0]
rmessages.writeSpawnBaseline(clientRuntimeBuffer, clientRuntimeBaseline)
rmessages.writeStuffText(clientRuntimeBuffer, "echo server-controlled\n")
rmessages.writeDownload(clientRuntimeBuffer, bytes([8, 9, 10]), 0, 3, 100)
qmsg.writeByte(clientRuntimeBuffer, qc.SVC_SOUND)
qmsg.writeByte(clientRuntimeBuffer, 0)
qmsg.writeByte(clientRuntimeBuffer, 7)
qmsg.writeByte(clientRuntimeBuffer, qc.SVC_MUZZLEFLASH)
qmsg.writeShort(clientRuntimeBuffer, 1)
qmsg.writeByte(clientRuntimeBuffer, ceconstants.MZ_BLASTER)
qmsg.writeByte(clientRuntimeBuffer, qc.SVC_TEMP_ENTITY)
qmsg.writeByte(clientRuntimeBuffer, ceconstants.TE_EXPLOSION1)
qmsg.writePos(clientRuntimeBuffer, qt.vec3(1.0, 2.0, 3.0))
clientRuntimePayload = qsz.dataSlice(clientRuntimeBuffer)

clientRuntimeResult = crdispatcher.dispatch(clientRuntime, clientRuntimePayload, 10, 2500)
clientRuntimeAssertEqual(clientRuntimeResult.accepted, true, "integrated packet accepted")
clientRuntimeAssertEqual(clientRuntimeResult.commands, 9, "service command count")
clientRuntimeAssertEqual(clientRuntime.network.protocol, 34, "serverdata routed")
clientRuntimeAssertEqual(clientRuntime.network.configStrings[qc.CS_NAME], "Runtime Unit", "configstring routed")
clientRuntimeAssertEqual(clientRuntime.client.lightStyleMaps[3], "az",
  "light style configstring routed into client animation")
clientRuntimeAssertEqual(clientRuntime.network.baselines[1].modelIndex, 2, "baseline routed")
clientRuntimeAssertEqual(clientRuntime.network.downloadData, bytes([8, 9, 10]), "download routed")
clientRuntimeAssertEqual(crdispatcher.pendingStuffText(clientRuntime)[0], "echo server-controlled\n", "stufftext only queued")
clientRuntimeAssertEqual(len(clientRuntime.effects.soundEvents), 3, "sound, muzzle and explosion sounds routed")
clientRuntimeAssertEqual(clientRuntime.effects.soundEvents[2].soundName,
  "weapons/rocklx1a.wav", "temp explosion sound routed")
clientRuntimeAssertEqual(len(clientRuntime.effects.dLights), 1, "muzzleflash routed")
clientRuntimeAssertEqual(len(clientRuntime.effects.explosions), 1, "temp entity routed")
clientRuntimeAssertEqual(len(clientRuntimeDemo.packets), 1, "accepted packet handed to demo")
clientRuntimeAssertEqual(clientRuntimeDemo.packets[0], clientRuntimePayload, "demo preserves exact payload")

// Duplicate network packets never replay one-shot effects or enter a demo.
clientRuntimeReplay = crdispatcher.dispatch(clientRuntime, clientRuntimePayload, 10, 2600)
clientRuntimeAssertEqual(clientRuntimeReplay.accepted, false, "duplicate packet rejected")
clientRuntimeAssertEqual(clientRuntimeReplay.reason, "stale-or-duplicate", "duplicate reason")
clientRuntimeAssertEqual(len(clientRuntime.effects.explosions), 1, "duplicate effect suppressed")
clientRuntimeAssertEqual(len(clientRuntimeDemo.packets), 1, "duplicate demo packet suppressed")

// Malformed service payloads are ERR_DROP-equivalent, not stale packet noise.
// The integrated network pump must surface them to its session/product owner.
clientRuntimeFatal = try(crpump.dispatchIntegratedPayload(clientRuntime,
  bytes([255]), 11, 2700))
clientRuntimeAssertEqual(clientRuntimeFatal is error, true,
  "malformed integrated payload is connection-fatal")
clientRuntimeAssertEqual(clientRuntime.lastSequence, 10,
  "fatal payload does not commit sequence state")
clientRuntimeAssertEqual(len(clientRuntimeDemo.packets), 1,
  "fatal payload does not enter demo stream")

// The length-prefixed .dm2 handoff replays through the identical dispatcher.
clientRuntimeEncoded = cdemo.encodeDemo(clientRuntimeDemo)
clientRuntimeDecoded = cdemo.decodeDemo(clientRuntimeEncoded)
clientRuntimePlayer = cdemo.player(clientRuntimeDecoded)
clientRuntimePlayback = clientRuntimeCreate()
clientRuntimePlaybackResult = crdispatcher.nextDemo(clientRuntimePlayback, clientRuntimePlayer, 3000)
clientRuntimeAssertEqual(clientRuntimePlaybackResult.accepted, true, "demo packet dispatched")
clientRuntimeAssertEqual(clientRuntimePlayback.network.levelName, "Runtime Unit", "demo serverdata replayed")
clientRuntimeAssertEqual(len(clientRuntimePlayback.effects.explosions), 1, "demo effect replayed")
clientRuntimeAssertEqual(crdispatcher.nextDemo(clientRuntimePlayback, clientRuntimePlayer, 3100), void, "demo completion")
print("MiniQuake2 client runtime dispatch tests passed: 1")
