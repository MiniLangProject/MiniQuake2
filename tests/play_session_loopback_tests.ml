/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Real UDP vertical slice: signon, snapshots, UI/FX handoff and shutdown. */
import miniquake2.platform.system as psystem
import miniquake2.qcommon.constants as qc
import miniquake2.qcommon.message as qmsg
import miniquake2.qcommon.types as qt
import miniquake2.protocol.constants as pc
import miniquake2.protocol.netchan as pnetchan
import miniquake2.client.effects.constants as ceconstants
import miniquake2.client.runtime.handoff as crhandoff
import miniquake2.network.constants as nc
import miniquake2.runtime.client_session as plclienttest
import miniquake2.runtime.server_session as plservertest
import miniquake2.runtime.play_session as playsession
import miniquake2.server.game_messages as playmessages
import miniquake2.game.constants as gc
import miniquake2.game.null_game as playgame

// Assert the play test condition.
function playAssert(value, name)
  if not value then return error(8396, name) end if
  return true
end function

entities = "{\n\"classname\" \"worldspawn\"\n\"message\" \"Vertical Slice\"\n}\n" +
  "{\n\"classname\" \"info_player_start\"\n\"origin\" \"0 0 24\"\n\"angle\" \"0\"\n}\n"
session = playsession.createCore("vertical", entities, void, "\\name\\Vertical\\rate\\25000")
active = playsession.runUntilActive(session, 500)
playAssert(active.signonComplete, "Protocol-34 signon did not complete")
playAssert(active.clientState == nc.CA_ACTIVE, "client did not become active")
playAssert(session.server.networkRuntime.server.clients[0].state == nc.CS_SPAWNED,
  "server slot did not become spawned")
playAssert(active.handoff is not void, "first server snapshot had no frame handoff")
playAssert(active.handoff.snapshot.number == active.handoff.frameNumber,
  "snapshot commit was not atomic")

// BaseQ2 registers several projectile assets lazily from g_weapon.c. Active
// clients must receive both additions and removals as reliable configstrings.
dynamicModelName = "models/objects/runtime_dynamic/tris.md2"
dynamicModelIndex = playgame.playerContext().imports.modelIndex(dynamicModelName)
playAssert(session.client.integrated.network.configStrings[qc.CS_MODELS + dynamicModelIndex] == "",
  "dynamic model unexpectedly existed before server synchronization")
dynamicAttempts = 0
while session.client.integrated.network.configStrings[qc.CS_MODELS + dynamicModelIndex] !=
    dynamicModelName and dynamicAttempts < 100
  playsession.step(session)
  dynamicAttempts = dynamicAttempts + 1
end while
playAssert(session.client.integrated.network.configStrings[qc.CS_MODELS + dynamicModelIndex] ==
  dynamicModelName, "live model configstring did not reach the spawned client")
playgame.playerContext().imports.configString(qc.CS_MODELS + dynamicModelIndex, "")
dynamicAttempts = 0
while session.client.integrated.network.configStrings[qc.CS_MODELS + dynamicModelIndex] != "" and
    dynamicAttempts < 100
  playsession.step(session)
  dynamicAttempts = dynamicAttempts + 1
end while
playAssert(session.client.integrated.network.configStrings[qc.CS_MODELS + dynamicModelIndex] == "",
  "cleared live model configstring did not reach the spawned client")

playAssert(playsession.setUserInfo(session,
  "\\name\\Lefty\\skin\\female/athena\\hand\\1\\rate\\25000"),
  "live player userinfo was not queued")
userinfoAttempts = 0
while session.server.networkRuntime.server.clients[0].name != "Lefty" and
    userinfoAttempts < 100
  playsession.step(session)
  userinfoAttempts = userinfoAttempts + 1
end while
playAssert(session.server.networkRuntime.server.clients[0].name == "Lefty" and
  session.server.networkRuntime.server.clients[0].userInfo ==
    "\\name\\Lefty\\skin\\female/athena\\hand\\1\\rate\\25000",
  "live clc_userinfo did not reach the server slot")
playAssert(playgame.playerContext().players[0].persistent.hand == 1,
  "live handedness did not reach ClientUserinfoChanged")

// Empty any snapshots accumulated during the asynchronous signon before the
// one-shot reliable UI/FX packet is staged.
while playsession.takeFrame(session) is not void
end while

// The UI-facing queue feeds the exact Quake-II three-command delta history.
cmd1 = qt.UserCmd(11, 1, [101, 102, 103], 111, 112, 113, 2, 3)
cmd2 = qt.UserCmd(22, 4, [201, 202, 203], 221, 222, 223, 5, 6)
cmd3 = qt.UserCmd(33, 7, [301, 302, 303], 331, 332, 333, 8, 9)
playsession.setUserCmd(session, cmd1)
playAssert(playsession.pendingUserCmds(session) == 1, "setUserCmd did not replace the queue")
playsession.queueUserCmd(session, cmd2)
playsession.queueUserCmd(session, cmd3)
cmd1.forwardMove = 999
headlessBefore = session.client.lastCommand.msec
plclienttest.sendMove(session.client, 1000)
playAssert(session.client.lastCommand.forwardMove == 111 and
  session.client.previousCommand.msec == headlessBefore, "first queued command/history mismatch")
plclienttest.sendMove(session.client, 1001)
playAssert(session.client.previousCommand.forwardMove == 111 and
  session.client.lastCommand.forwardMove == 221, "second delta history mismatch")
plclienttest.sendMove(session.client, 1002)
playAssert(session.client.previousCommand.forwardMove == 221 and
  session.client.lastCommand.forwardMove == 331 and playsession.pendingUserCmds(session) == 0,
  "third delta history mismatch")
plservertest.step(session.server)
playAssert(session.server.networkRuntime.lastCommands[0].forwardMove == 331,
  "server did not decode the newest queued command")

channel = session.server.networkRuntime.server.clients[0].channel
qmsg.writeByte(channel.message, qc.SVC_PRINT)
qmsg.writeByte(channel.message, qc.PRINT_HIGH)
qmsg.writeString(channel.message, "Loopback ready")
qmsg.writeByte(channel.message, qc.SVC_CENTERPRINT)
qmsg.writeString(channel.message, "Vertical Slice")
qmsg.writeByte(channel.message, qc.SVC_LAYOUT)
qmsg.writeString(channel.message, "xv 8 yv 8 string vertical")
qmsg.writeByte(channel.message, qc.SVC_INVENTORY)
item = 0
while item < qc.MAX_ITEMS
  amount = 0
  if item == 5 then amount = 23 end if
  qmsg.writeShort(channel.message, amount)
  item = item + 1
end while
qmsg.writeByte(channel.message, qc.SVC_SOUND)
qmsg.writeByte(channel.message, 0)
qmsg.writeByte(channel.message, 7)
qmsg.writeByte(channel.message, qc.SVC_TEMP_ENTITY)
qmsg.writeByte(channel.message, ceconstants.TE_EXPLOSION1)
qmsg.writePos(channel.message, qt.vec3(16.0, 24.0, 32.0))

delivered = void
attempt = 0
while delivered is void and attempt < 100
  result = playsession.step(session)
  candidate = result.handoff
  while candidate is not void
    if len(candidate.prints) == 1 and len(candidate.explosions) == 1 then delivered = candidate end if
    candidate = playsession.takeFrame(session)
  end while
  if delivered is void then psystem.sleep(1) end if
  attempt = attempt + 1
end while
playAssert(delivered is not void, "reliable UI/FX did not join a snapshot")
playAssert(delivered.prints[0].text == "Loopback ready", "console handoff mismatch")
playAssert(delivered.centerPrints[0].text == "Vertical Slice", "centerprint handoff mismatch")
playAssert(delivered.layouts[0].text == "xv 8 yv 8 string vertical", "layout handoff mismatch")
playAssert(delivered.inventories[0].values[5] == 23, "inventory handoff mismatch")
playAssert(len(delivered.sounds) == 2 and delivered.sounds[0].soundIndex == 7 and
  delivered.sounds[1].soundName == "weapons/rocklx1a.wav",
  "audio handoff mismatch")
playAssert(delivered.explosions[0].origin.x == 16.0 and
  delivered.explosions[0].origin.y == 24.0 and delivered.explosions[0].origin.z == 32.0,
  "temp-entity handoff mismatch")

// A second commit of the current server frame and a stale dispatcher packet
// cannot duplicate the frame or its one-shot UI/audio records.
pendingBefore = crhandoff.pending(session.client.integrated)
playAssert(crhandoff.commit(session.client.integrated, 9999) is void,
  "duplicate snapshot produced another handoff")
playAssert(crhandoff.pending(session.client.integrated) == pendingBefore,
  "duplicate snapshot changed the handoff queue")

// Reproduce the reported multicast overflow shape: one reliable fragment is
// blocked behind a completely full Netchan queue while hundreds of ordinary
// effects continue to arrive. Stock client datagrams are attempted and then
// discarded per frame; only the reliable event may remain in the bridge.
channel.reliableLength = 1
channel.reliableBuffer = bytes([qc.SVC_NOP])
channel.reliableQueue = []
channel.reliableQueuedBytes = 0
fullReliableQueue = array(pc.MAX_RELIABLE_QUEUE_FRAGMENTS,
  bytes(pc.RELIABLE_BUFFER_SIZE))
playAssert(pnetchan.queueReliableFragments(channel, fullReliableQueue) != false,
  "could not stage multicast backpressure fixture")
backlogImports = playgame.playerContext().imports
backlogImports.writeByte(qc.SVC_NOP)
backlogImports.multicast(qt.zeroVec3(), gc.MULTICAST_ALL_R)
backlogTransient = 0
while backlogTransient < 300
  backlogImports.writeByte(qc.SVC_NOP)
  backlogImports.multicast(qt.zeroVec3(), gc.MULTICAST_ALL)
  plservertest.step(session.server)
  backlogTransient = backlogTransient + 1
end while
backlogRemaining = playmessages.pendingMulticastSnapshot(
  session.server.bridgeRuntime)
backlogOnlyReliable = true
if len(backlogRemaining) == 1 then
  backlogOnlyReliable = backlogRemaining[0].destination == gc.MULTICAST_ALL_R
end if
playAssert(len(backlogRemaining) <= 1 and backlogOnlyReliable,
  "transient multicast traffic accumulated behind reliable backpressure")

shutdownReceivedBefore = session.server.packetsReceived
playAssert(playsession.shutdown(session), "first shutdown failed")
playAssert(session.server.packetsReceived > shutdownReceivedBefore,
  "server did not receive the disconnect datagram")
playAssert(session.closed and session.client.closed and session.server.closed,
  "session resources were not closed")
playAssert(session.server.networkRuntime.server.clients[0].state == nc.CS_FREE,
  "server did not consume the disconnect")
playAssert(not playsession.shutdown(session), "shutdown was not idempotent")
print("play_session_loopback_tests: PASS")
