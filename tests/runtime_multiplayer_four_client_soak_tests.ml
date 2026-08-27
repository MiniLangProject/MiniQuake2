/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Four-client UDP signon, snapshot, reconnect, map-change and soak gate. */
import miniquake2.runtime.multiplayer_session as fourmpsession
import miniquake2.network.constants as fourmpnetwork
import miniquake2.qcommon.types as fourmpqtypes
import miniquake2.game.constants as fourmpgameconstants
import miniquake2.game.null_game as fourmpgame
import miniquake2.runtime.session_persistence as fourmppersistence

// Assert the four mp test condition.
function fourMpAssert(value, message)
  if value != true then return error(9824, message) end if
  return true
end function

// Map four mp.
function fourMpMap(title, offset)
  return "{\n\"classname\" \"worldspawn\"\n\"message\" \"" + title + "\"\n}\n" +
    "{\n\"classname\" \"info_player_start\"\n\"origin\" \"0 0 24\"\n}\n" +
    "{\n\"classname\" \"info_player_deathmatch\"\n\"origin\" \"" + offset + " 0 24\"\n}\n" +
    "{\n\"classname\" \"info_player_deathmatch\"\n\"origin\" \"128 0 24\"\n}\n" +
    "{\n\"classname\" \"info_player_deathmatch\"\n\"origin\" \"256 0 24\"\n}\n" +
    "{\n\"classname\" \"info_player_deathmatch\"\n\"origin\" \"384 0 24\"\n}\n" +
    "{\n\"classname\" \"info_player_deathmatch\"\n\"origin\" \"0 128 24\"\n}\n" +
    "{\n\"classname\" \"info_player_deathmatch\"\n\"origin\" \"128 128 24\"\n}\n" +
    "{\n\"classname\" \"info_player_deathmatch\"\n\"origin\" \"256 128 24\"\n}\n" +
    "{\n\"classname\" \"info_player_deathmatch\"\n\"origin\" \"384 128 24\"\n}\n" +
    "{\n\"classname\" \"info_player_deathmatch\"\n\"origin\" \"0 256 24\"\n}\n" +
    "{\n\"classname\" \"info_player_deathmatch\"\n\"origin\" \"128 256 24\"\n}\n" +
    "{\n\"classname\" \"info_player_deathmatch\"\n\"origin\" \"256 256 24\"\n}\n" +
    "{\n\"classname\" \"info_player_deathmatch\"\n\"origin\" \"384 256 24\"\n}\n" +
    "{\n\"classname\" \"info_player_deathmatch\"\n\"origin\" \"0 384 24\"\n}\n" +
    "{\n\"classname\" \"info_player_deathmatch\"\n\"origin\" \"128 384 24\"\n}\n" +
    "{\n\"classname\" \"info_player_deathmatch\"\n\"origin\" \"256 384 24\"\n}\n" +
    "{\n\"classname\" \"info_player_deathmatch\"\n\"origin\" \"384 384 24\"\n}\n"
end function

// Assert the four mp mutual visibility test condition.
function fourMpAssertMutualVisibility(session)
  fourMpViewer = 0
  while fourMpViewer < 4
    fourMpSubject = 0
    while fourMpSubject < 4
      fourMpVisiblePlayer = fourmpsession.player(session, fourMpSubject)
      if fourMpVisiblePlayer is void or not fourmpsession.snapshotHasEntity(session,
          fourMpViewer, fourMpVisiblePlayer.edict.state.number) then
        fourMpNumbers = ""
        for each fourMpFrameEntity in session.clients[fourMpViewer].integrated.network.client.currentFrame.entities
          fourMpNumbers = fourMpNumbers + "," + fourMpFrameEntity.number
        end for
        fourMpPlayerShapes = ""
        fourMpShapeIndex = 0
        while fourMpShapeIndex < 4
          fourMpShapePlayer = fourmpsession.player(session, fourMpShapeIndex)
          fourMpPlayerShapes = fourMpPlayerShapes + "," + fourMpShapePlayer.edict.state.number +
            ":" + fourMpShapePlayer.edict.state.modelIndex + ":" + fourMpShapePlayer.edict.inUse +
            ":" + fourMpShapePlayer.health + ":" + fourMpShapePlayer.deadFlag + ":" +
            fourMpShapePlayer.persistent.connected
          fourMpShapeIndex = fourMpShapeIndex + 1
        end while
        return error(9825, "four-client snapshot visibility matrix is incomplete viewer=" +
          fourMpViewer + " subject=" + fourMpSubject + " entity=" +
          fourMpVisiblePlayer.edict.state.number + " frame=" + fourMpNumbers +
          " players=" + fourMpPlayerShapes)
      end if
      fourMpSubject = fourMpSubject + 1
    end while
    fourMpViewer = fourMpViewer + 1
  end while
  return true
end function

// The synthetic core fixture intentionally has no BSP collision. Keep living
// players inside the signed-short PMove range so this remains a network soak,
// not a gravity/wrap test (retail collision owns that separate matrix).
function fourMpStabilizePlayers(session)
  fourMpStableIndex = 0
  while fourMpStableIndex < 4
    fourMpStablePlayer = fourmpsession.player(session, fourMpStableIndex)
    if fourMpStablePlayer is not void and fourMpStablePlayer.health > 0 and
        fourMpStablePlayer.persistent.connected and fourMpStablePlayer.edict.client is not void then
      fourMpStableX = fourMpStableIndex * 128
      fourMpStableY = (fourMpStableIndex & 1) * 128
      fourMpStablePlayer.edict.state.origin = fourmpqtypes.Vec3(
        fourMpStableX * 1.0, fourMpStableY * 1.0, 64.0)
      fourMpStablePlayer.edict.state.oldOrigin = fourmpqtypes.Vec3(
        fourMpStableX * 1.0, fourMpStableY * 1.0, 64.0)
      fourMpStablePlayer.edict.client.playerState.pmove.origin = [
        fourMpStableX * 8, fourMpStableY * 8, 512]
      fourMpStablePlayer.edict.client.playerState.pmove.velocity = [0, 0, 0]
      fourMpStablePlayer.oldPmove.origin = [fourMpStableX * 8, fourMpStableY * 8, 512]
      fourMpStablePlayer.oldPmove.velocity = [0, 0, 0]
      fourMpStablePlayer.velocity = [0.0, 0.0, 0.0]
    end if
    fourMpStableIndex = fourMpStableIndex + 1
  end while
  return true
end function

// Return the four mp recover live players value.
function fourMpRecoverLivePlayers(session)
  fourMpRecoverContext = fourmpgame.playerContext()
  fourMpRecoverContext.dmFlags = fourMpRecoverContext.dmFlags |
    fourmpgameconstants.DF_FORCE_RESPAWN
  fourMpRecoverSteps = 0
  fourMpRecoverCount = 0
  while fourMpRecoverSteps < 64 and fourMpRecoverCount < 4
    fourMpStabilizePlayers(session)
    fourmpsession.step(session)
    fourMpRecoverCount = 0
    fourMpRecoverIndex = 0
    while fourMpRecoverIndex < 4
      fourMpRecoverPlayer = fourmpsession.player(session, fourMpRecoverIndex)
      if fourMpRecoverPlayer.health > 0 and fourMpRecoverPlayer.edict.state.modelIndex != 0 then
        fourMpRecoverCount = fourMpRecoverCount + 1
      end if
      fourMpRecoverIndex = fourMpRecoverIndex + 1
    end while
    fourMpRecoverSteps = fourMpRecoverSteps + 1
  end while
  fourMpRecoverContext.dmFlags = fourMpRecoverContext.dmFlags &
    ~fourmpgameconstants.DF_FORCE_RESPAWN
  fourMpStabilizePlayers(session)
  return fourMpRecoverCount
end function

fourMpAssert(try(fourmpsession.validateUserInfos(["\\name\\solo"])) is error,
  "single-client multiplayer harness accepted")
fourMpInfos = [
  "\\name\\Alpha\\skin\\male/grunt",
  "\\name\\Bravo\\skin\\female/athena",
  "\\name\\Charlie\\skin\\male/howitzer",
  "\\name\\Delta\\skin\\female/venus"
]
fourMpSession = fourmpsession.createCore(fourmpsession.MODE_DEATHMATCH,
  "dm_four_a", fourMpMap("Four Player A", 0), void, fourMpInfos)
fourMpActive = fourmpsession.runUntilActive(fourMpSession, 1000)
fourMpAssert(fourMpActive.activeClients == 4 and
  len(fourMpActive.clientStates) == 4 and len(fourMpActive.serverStates) == 4,
  "four clients did not complete signon")

fourMpSlots = array(4, -1)
fourMpIndex = 0
while fourMpIndex < 4
  fourMpSlots[fourMpIndex] = fourmpsession.serverSlot(fourMpSession, fourMpIndex)
  fourMpAssert(fourMpSlots[fourMpIndex] >= 0 and
    fourMpSession.clients[fourMpIndex].integrated.network.client.state ==
      fourmpnetwork.CA_ACTIVE,
    "four-client slot/state assignment failed")
  fourMpPrevious = 0
  while fourMpPrevious < fourMpIndex
    fourMpAssert(fourMpSlots[fourMpPrevious] != fourMpSlots[fourMpIndex],
      "four-client server slot collision")
    fourMpPrevious = fourMpPrevious + 1
  end while
  fourMpIndex = fourMpIndex + 1
end while
// All four connect commands may land in one server frame. Classic deathmatch
// allows those simultaneous spawn selections to telefrag; exercise the normal
// force-respawn path until every slot owns a live networked player.
fourMpAssert(fourMpRecoverLivePlayers(fourMpSession) == 4,
  "simultaneous four-client telefrags did not recover through normal respawn")
fourMpSnapshotSettle = 0
while fourMpSnapshotSettle < 32
  fourMpStabilizePlayers(fourMpSession)
  fourmpsession.step(fourMpSession)
  fourMpSnapshotSettle = fourMpSnapshotSettle + 1
end while
fourMpAssertMutualVisibility(fourMpSession)

// Exercise bidirectional command/ACK traffic from every client before churn.
fourMpTrafficFrame = 0
while fourMpTrafficFrame < 200
  if fourMpTrafficFrame % 8 == 0 then
    fourMpCommandClient = 0
    while fourMpCommandClient < 4
      fourmpsession.queueUserCmd(fourMpSession, fourMpCommandClient,
        fourmpqtypes.UserCmd(100, 0, [0, 0, 0],
          80 + fourMpCommandClient * 8, (fourMpCommandClient - 2) * 12,
          0, 0, 64))
      fourMpCommandClient = fourMpCommandClient + 1
    end while
  end if
  fourMpStabilizePlayers(fourMpSession)
  fourmpsession.step(fourMpSession)
  fourMpTrafficFrame = fourMpTrafficFrame + 1
end while
fourMpAssert(fourmpsession.result(fourMpSession).packetsRejected == 0,
  "four-client command traffic rejected packets")

fourMpAssert(fourmpsession.disconnectClient(fourMpSession, 1),
  "first staggered disconnect failed")
fourMpAssert(fourmpsession.disconnectClient(fourMpSession, 3),
  "second staggered disconnect failed")
fourMpAssert(fourmpsession.activeClients(fourMpSession) == 2,
  "surviving clients did not remain active")
fourMpSurvivorSoak = 0
while fourMpSurvivorSoak < 100
  fourMpStabilizePlayers(fourMpSession)
  fourmpsession.step(fourMpSession)
  fourMpSurvivorSoak = fourMpSurvivorSoak + 1
end while
fourmpsession.reconnectClient(fourMpSession, 3,
  "\\name\\DeltaReturns\\skin\\female/venus")
fourmpsession.reconnectClient(fourMpSession, 1,
  "\\name\\BravoReturns\\skin\\female/athena")
fourMpRejoined = fourmpsession.runUntilActive(fourMpSession, 1000)
fourMpAssert(fourMpRejoined.activeClients == 4 and
  fourmpsession.player(fourMpSession, 1).persistent.netName == "BravoReturns" and
  fourmpsession.player(fourMpSession, 3).persistent.netName == "DeltaReturns",
  "four-client reconnect did not restore live player state")
fourMpAssert(fourMpRecoverLivePlayers(fourMpSession) == 4,
  "four-client reconnect telefrags did not recover")
fourMpSnapshotSettle = 0
while fourMpSnapshotSettle < 32
  fourMpStabilizePlayers(fourMpSession)
  fourmpsession.step(fourMpSession)
  fourMpSnapshotSettle = fourMpSnapshotSettle + 1
end while
fourMpAssertMutualVisibility(fourMpSession)

fourMpCheckpointClientChannels = array(4, void)
fourMpCheckpointServerChannels = array(4, void)
fourMpIndex = 0
while fourMpIndex < 4
  fourMpCheckpointPlayer = fourmpsession.player(fourMpSession, fourMpIndex)
  fourMpCheckpointPlayer.health = 80 + fourMpIndex
  fourMpCheckpointPlayer.gameplay.health = 80 + fourMpIndex
  fourMpCheckpointPlayer.respawn.score = fourMpIndex * 2
  fourMpCheckpointClientChannels[fourMpIndex] = fourMpSession.clients[fourMpIndex].integrated.network.client.channel
  fourMpCheckpointSlot = fourmpsession.serverSlot(fourMpSession, fourMpIndex)
  fourMpCheckpointServerChannels[fourMpIndex] = fourMpSession.server.networkRuntime.server.clients[fourMpCheckpointSlot].channel
  fourMpIndex = fourMpIndex + 1
end while
fourMpCheckpoint = fourmppersistence.saveMultiplayerSession(fourMpSession,
  "build/runtime_multiplayer_four_client.game.sav",
  "build/runtime_multiplayer_four_client.level.sav")
fourmpsession.player(fourMpSession, 0).health = 5
fourmpsession.player(fourMpSession, 3).respawn.score = -10
fourmpsession.step(fourMpSession)
fourMpRestore = fourmppersistence.restoreMultiplayerSession(fourMpSession,
  fourMpCheckpoint)
fourMpAssert(fourMpRestore.restored and fourMpRestore.channelPreserved and
  not fourMpRestore.reSignon, "four-client same-map checkpoint failed")
fourMpIndex = 0
while fourMpIndex < 4
  fourMpRestoredPlayer = fourmpsession.player(fourMpSession, fourMpIndex)
  fourMpRestoredSlot = fourmpsession.serverSlot(fourMpSession, fourMpIndex)
  fourMpAssert(fourMpRestoredPlayer.health == 80 + fourMpIndex and
      fourMpRestoredPlayer.respawn.score == fourMpIndex * 2 and
      nativeRawValue(fourMpSession.clients[fourMpIndex].integrated.network.client.channel) ==
        nativeRawValue(fourMpCheckpointClientChannels[fourMpIndex]) and
      nativeRawValue(fourMpSession.server.networkRuntime.server.clients[fourMpRestoredSlot].channel) ==
        nativeRawValue(fourMpCheckpointServerChannels[fourMpIndex]),
    "four-client checkpoint player/channel mismatch")
  fourMpIndex = fourMpIndex + 1
end while

fourMpSpawnBefore = fourMpSession.clients[0].integrated.network.spawnCount
fourMpSequencesBefore = array(4, 0)
fourMpIndex = 0
while fourMpIndex < 4
  fourMpSlot = fourmpsession.serverSlot(fourMpSession, fourMpIndex)
  fourMpSequencesBefore[fourMpIndex] = fourMpSession.server.networkRuntime.server.clients[fourMpSlot].channel.outgoingSequence
  fourMpIndex = fourMpIndex + 1
end while
fourMpChange = fourmpsession.changeMapCore(fourMpSession, "dm_four_b",
  fourMpMap("Four Player B", 64), void, 1200)
fourMpAssert(fourMpChange.changed and fourmpsession.signonComplete(fourMpSession) and
  fourMpSession.clients[0].integrated.network.spawnCount > fourMpSpawnBefore,
  "four-client map change did not establish a new spawn epoch")
fourMpAssert(fourMpRecoverLivePlayers(fourMpSession) == 4,
  "four-client map-change telefrags did not recover")
// Each closed client emits the classic three-disconnect burst. Datagrams that
// arrive after its replacement channel is installed are intentionally stale
// and counted by the diagnostic reject counter; the long steady-state tail
// must not add any further rejects.
fourMpPostChangeRejects = fourmpsession.result(fourMpSession).packetsRejected
fourMpAssert(fourMpPostChangeRejects <= 4,
  "four-client churn produced unbounded stale packet rejects")
fourMpIndex = 0
while fourMpIndex < 4
  fourMpSlot = fourmpsession.serverSlot(fourMpSession, fourMpIndex)
  fourMpAssert(fourMpSession.server.networkRuntime.server.clients[fourMpSlot].channel.outgoingSequence >
      fourMpSequencesBefore[fourMpIndex],
    "four-client map change rewound or stalled Netchan sequence")
  fourMpIndex = fourMpIndex + 1
end while

fourMpTail = 0
while fourMpTail < 500
  if fourMpTail % 10 == 0 then
    fourMpCommandClient = 0
    while fourMpCommandClient < 4
      fourmpsession.queueUserCmd(fourMpSession, fourMpCommandClient,
        fourmpqtypes.UserCmd(100, 0, [0, 0, 0], 64, 0, 0, 0, 64))
      fourMpCommandClient = fourMpCommandClient + 1
    end while
  end if
  fourMpStabilizePlayers(fourMpSession)
  fourmpsession.step(fourMpSession)
  fourMpTail = fourMpTail + 1
end while
fourMpFinal = fourmpsession.result(fourMpSession)
fourMpAssert(fourMpFinal.activeClients == 4,
  "four-client post-change active count=" + fourMpFinal.activeClients)
fourMpAssert(fourMpFinal.packetsRejected == fourMpPostChangeRejects,
  "four-client steady-state soak added rejected packets=" +
    fourMpFinal.packetsRejected)
fourMpAssert(fourMpFinal.packetsReceived > fourMpActive.packetsReceived and
  fourMpFinal.packetsSent > fourMpActive.packetsSent,
  "four-client post-change counters did not advance received=" +
    fourMpFinal.packetsReceived + " sent=" + fourMpFinal.packetsSent)
fourMpAssertMutualVisibility(fourMpSession)
fourMpAssert(fourmpsession.shutdown(fourMpSession), "four-client shutdown failed")
print "runtime_multiplayer_four_client_soak_tests: PASS clients=4 frames=" +
  fourMpFinal.serverFrame + " packets=" + fourMpFinal.packetsReceived + "/" +
  fourMpFinal.packetsSent + " stale-rejects=" + fourMpFinal.packetsRejected
