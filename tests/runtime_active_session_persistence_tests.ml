/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Active real-UDP PlaySession save/restore, atomic failure and map boundary. */
import std.fs as savegatetestfs
import miniquake2.network.constants as savegatetestnetworkconstants
import miniquake2.protocol.netchan as savegatetestnetchan
import miniquake2.qcommon.types as savegatetestqtypes
import miniquake2.game.constants as savegatetestgameconstants
import miniquake2.game.null_game as savegatetestgameapi
import miniquake2.game.integration.baseq2 as savegatetestbaseq2
import miniquake2.runtime.play_session as savegatetestplaysession
import miniquake2.runtime.session_persistence as savegatetestpersistence

// Assert the save gate test condition.
function saveGateAssert(value, name)
  if not value then return error(8460, name) end if
  return true
end function

// Save gate find bytes.
function saveGateFindBytes(data, pattern)
  saveGateFindOffset = 0
  while saveGateFindOffset + len(pattern) <= len(data)
    saveGateFindMatches = true
    saveGateFindIndex = 0
    while saveGateFindIndex < len(pattern)
      if data[saveGateFindOffset + saveGateFindIndex] != pattern[saveGateFindIndex] then
        saveGateFindMatches = false
      end if
      saveGateFindIndex = saveGateFindIndex + 1
    end while
    if saveGateFindMatches then return saveGateFindOffset end if
    saveGateFindOffset = saveGateFindOffset + 1
  end while
  return -1
end function

saveGateEntities = "{\n\"classname\" \"worldspawn\"\n\"message\" \"Persistent Session\"\n}\n" +
  "{\n\"classname\" \"info_player_start\"\n\"origin\" \"0 0 24\"\n}\n" +
  "{\n\"classname\" \"ammo_shells\"\n\"origin\" \"96 0 24\"\n\"count\" \"8\"\n}\n"
saveGateSession = savegatetestplaysession.createCore("save_active", saveGateEntities,
  void, "\\name\\SaveLoop\\skin\\male/grunt")
savegatetestplaysession.runUntilActive(saveGateSession, 500)
saveGateAssert(savegatetestplaysession.signonComplete(saveGateSession),
  "active save session did not complete signon")

saveGateRuntime = savegatetestgameapi.baseRuntime()
saveGateContext = savegatetestgameapi.playerContext()
saveGatePlayer = saveGateContext.players[0]
saveGateItem = savegatetestbaseq2.findItemByClass(saveGateRuntime, "ammo_shells")
saveGateAssert(saveGateItem is not void, "save fixture item is missing")

saveGatePlayer.health = 73
saveGatePlayer.maxHealth = 125
saveGatePlayer.gameplay.health = 73
saveGatePlayer.gameplay.inventory.counts[2] = 17
saveGatePlayer.persistent.score = 4
saveGatePlayer.respawn.score = 4
saveGatePlayer.edict.state.origin = savegatetestqtypes.Vec3(32.0, 0.0, 64.0)
saveGatePlayer.edict.state.oldOrigin = savegatetestqtypes.Vec3(32.0, 0.0, 64.0)
saveGatePlayer.edict.client.playerState.pmove.origin = [256, 0, 512]
saveGatePlayer.oldPmove.origin = [256, 0, 512]
saveGateRuntime.world.totalSecrets = 5
saveGateRuntime.world.foundSecrets = 3
saveGateRuntime.world.serverFlags = 77
saveGateItem.count = 19
saveGateItem.hidden = true
saveGateItem.nextThink = 123.5

saveGateGamePath = "build/runtime_active_session_game.sav"
saveGateLevelPath = "build/runtime_active_session_level.sav"
saveGateWrongLevelPath = "build/runtime_active_session_wrong_level.sav"
saveGateCheckpoint = savegatetestpersistence.savePlaySession(saveGateSession,
  saveGateGamePath, saveGateLevelPath)
saveGateDurableCheckpoint = savegatetestpersistence.loadSessionCheckpoint(
  saveGateGamePath, saveGateLevelPath, saveGateSession.server.gameExport.maxEdicts)
saveGateAssert(saveGateDurableCheckpoint.mapName == "save_active" and
  saveGateDurableCheckpoint.gameFrame == saveGateCheckpoint.gameFrame and
  saveGateDurableCheckpoint.spawnCount == -1,
  "persistent slot metadata was not reconstructed from disk")
saveGateSavedWorldTime = saveGateRuntime.world.time
saveGateSavedGameFrame = saveGateCheckpoint.gameFrame
saveGateServerChannel = saveGateSession.server.networkRuntime.server.clients[0].channel
saveGateClientChannel = saveGateSession.client.integrated.network.client.channel
saveGateServerOutgoingAtSave = saveGateServerChannel.outgoingSequence
saveGateClientOutgoingAtSave = saveGateClientChannel.outgoingSequence

saveGateAdvance = 0
while saveGateAdvance < 8
  savegatetestplaysession.step(saveGateSession)
  saveGateAdvance = saveGateAdvance + 1
end while
saveGateAssert(saveGateRuntime.world.time > saveGateSavedWorldTime and
  saveGateSession.server.frameNumber > saveGateCheckpoint.serverFrame,
  "session did not continue after save")

// Make every representative live value visibly different from the image.
saveGatePlayer.health = 11
saveGatePlayer.maxHealth = 99
saveGatePlayer.gameplay.health = 11
saveGatePlayer.gameplay.inventory.counts[2] = 0
saveGatePlayer.persistent.score = 91
saveGatePlayer.respawn.score = 91
saveGatePlayer.edict.state.origin = savegatetestqtypes.Vec3(320.0, 0.0, 64.0)
saveGatePlayer.edict.client.playerState.pmove.origin = [2560, 0, 512]
saveGateRuntime.world.foundSecrets = 0
saveGateRuntime.world.serverFlags = 1
saveGateItem.count = 0
saveGateItem.hidden = false
saveGateItem.nextThink = 0.0

// A syntactically valid game image in the level position is rejected during
// preflight. No ReadGame has run, so all live mutations must remain intact.
saveGateSession.server.gameExport.writeGame(saveGateWrongLevelPath, false)
saveGateWrongCheckpoint = savegatetestpersistence.SessionCheckpoint(
  saveGateCheckpoint.gamePath, saveGateWrongLevelPath,
  saveGateCheckpoint.mapName, saveGateCheckpoint.spawnCount,
  saveGateCheckpoint.gameFrame, saveGateCheckpoint.serverFrame)
saveGateAssert(try(savegatetestpersistence.restorePlaySession(
  saveGateSession, saveGateWrongCheckpoint)) is error,
  "wrong-kind checkpoint was accepted")
saveGateAssert(saveGatePlayer.health == 11 and saveGatePlayer.respawn.score == 91 and
  saveGateRuntime.world.foundSecrets == 0 and saveGateItem.count == 0,
  "failed restore partially mutated the active game")

// Outer save framing stays valid while the private payload is corrupted.
// ReadGame therefore begins replacing the export before private restore fails;
// the adapter must recover the exact pre-call live mutation from its rollback.
saveGateValidGameData = savegatetestfs.readAllBytes(saveGateGamePath)
saveGateCorruptGameData = bytes(saveGateValidGameData)
saveGatePrivateOffset = saveGateFindBytes(saveGateCorruptGameData, bytes("MQ2BASEQ2"))
saveGateAssert(saveGatePrivateOffset > 0, "private save payload marker is missing")
saveGateCorruptGameData[saveGatePrivateOffset] = 88
savegatetestfs.writeAllBytes(saveGateGamePath, saveGateCorruptGameData)
saveGateChannelBeforeAtomicFailure = saveGateServerChannel.outgoingSequence
saveGateAssert(try(savegatetestpersistence.restorePlaySession(
  saveGateSession, saveGateCheckpoint)) is error,
  "corrupt private payload was accepted")
saveGateAtomicRuntime = savegatetestgameapi.baseRuntime()
saveGateAtomicPlayer = savegatetestgameapi.playerContext().players[0]
saveGateAtomicItem = savegatetestbaseq2.findItemByClass(saveGateAtomicRuntime, "ammo_shells")
saveGateAssert(saveGateAtomicPlayer.health == 11 and saveGateAtomicPlayer.respawn.score == 91 and
  saveGateAtomicRuntime.world.foundSecrets == 0 and saveGateAtomicItem.count == 0 and
  saveGateServerChannel.outgoingSequence == saveGateChannelBeforeAtomicFailure,
  "mid-restore failure was not rolled back atomically")
savegatetestfs.writeAllBytes(saveGateGamePath, saveGateValidGameData)

saveGateFrameBeforeRestore = saveGateSession.server.frameNumber
saveGateClientFrameBeforeRestore = saveGateSession.client.integrated.network.client.currentFrame.serverFrame
saveGateServerOutgoingBeforeRestore = saveGateServerChannel.outgoingSequence
saveGateClientOutgoingBeforeRestore = saveGateClientChannel.outgoingSequence
saveGateRestore = savegatetestpersistence.restorePlaySession(saveGateSession, saveGateCheckpoint)
saveGateAssert(saveGateRestore.restored and not saveGateRestore.reSignon and
  saveGateRestore.channelPreserved, "same-map restore did not preserve channels")
saveGateAssert(saveGateSession.server.frameNumber == saveGateFrameBeforeRestore and
  saveGateServerChannel.outgoingSequence == saveGateServerOutgoingBeforeRestore and
  saveGateClientChannel.outgoingSequence == saveGateClientOutgoingBeforeRestore,
  "restore rewound the transport/session frame")
saveGateAssert(nativeRawValue(saveGateServerChannel) == nativeRawValue(
  saveGateSession.server.networkRuntime.server.clients[0].channel) and
  nativeRawValue(saveGateClientChannel) == nativeRawValue(
  saveGateSession.client.integrated.network.client.channel),
  "restore replaced a live Netchan")

saveGateRestoredRuntime = savegatetestgameapi.baseRuntime()
saveGateRestoredContext = savegatetestgameapi.playerContext()
saveGateRestoredPlayer = saveGateRestoredContext.players[0]
saveGateRestoredItem = savegatetestbaseq2.findItemByClass(saveGateRestoredRuntime, "ammo_shells")
saveGateRestoredTimeDelta = saveGateRestoredRuntime.world.time - saveGateSavedWorldTime
saveGateAssert(saveGateRestoredTimeDelta > -0.0001 and saveGateRestoredTimeDelta < 0.0001 and
  saveGateRestoredRuntime.world.totalSecrets == 5 and
  saveGateRestoredRuntime.world.foundSecrets == 3 and
  saveGateRestoredRuntime.world.serverFlags == 77,
  "world state was not restored")
saveGateAssert(saveGateRestoredPlayer.health == 73 and saveGateRestoredPlayer.maxHealth == 125 and
  saveGateRestoredPlayer.gameplay.inventory.counts[2] == 17 and
  saveGateRestoredPlayer.persistent.score == 4 and saveGateRestoredPlayer.respawn.score == 4,
  "player inventory/health/score was not restored")
saveGateAssert(saveGateRestoredPlayer.edict.state.origin.x == 32.0 and
  saveGateRestoredItem.count == 19 and saveGateRestoredItem.hidden and
  saveGateRestoredItem.nextThink == 123.5,
  "player transform/item state was not restored")
saveGateAssert(saveGateSession.server.networkRuntime.server.clients[0].score == 4,
  "restored score was not synchronized to the network slot")

saveGateSnapshotSteps = 0
while saveGateSession.client.integrated.network.client.currentFrame.serverFrame <= saveGateClientFrameBeforeRestore and
    saveGateSnapshotSteps < 16
  savegatetestplaysession.step(saveGateSession)
  saveGateSnapshotSteps = saveGateSnapshotSteps + 1
end while
saveGateSnapshot = saveGateSession.client.integrated.network.client.currentFrame
saveGateSawPlayer = false
for each saveGateSnapshotEntity in saveGateSnapshot.entities
  if saveGateSnapshotEntity.number == saveGateRestoredPlayer.edict.state.number and
      saveGateSnapshotEntity.origin[0] == 32.0 then saveGateSawPlayer = true end if
end for
saveGateAssert(saveGateSnapshot.valid and saveGateSnapshot.serverFrame > saveGateClientFrameBeforeRestore and
  saveGateSnapshot.playerState.stats[savegatetestgameconstants.STAT_HEALTH] == 73 and saveGateSawPlayer,
  "client did not accept a valid post-restore snapshot")
saveGateAssert(savegatetestnetchan.sequenceNewer(saveGateServerChannel.outgoingSequence,
  saveGateServerOutgoingBeforeRestore) and
  savegatetestnetchan.sequenceNewer(saveGateClientChannel.outgoingSequence,
  saveGateClientOutgoingBeforeRestore),
  "post-restore UDP sequences did not continue monotonically")
saveGateAssert(saveGateSession.client.integrated.network.client.state == savegatetestnetworkconstants.CA_ACTIVE and
  saveGateSession.server.networkRuntime.server.clients[0].state == savegatetestnetworkconstants.CS_SPAWNED and
  saveGateSession.server.networkRuntime.spawnCount == saveGateCheckpoint.spawnCount,
  "same-map restore changed signon state or spawn epoch")

// Old-map images cannot enter a new Protocol-34 generation. Rejection occurs
// before any live state or channel mutation.
saveGateNewEntities = "{\n\"classname\" \"worldspawn\"\n\"message\" \"After Save\"\n}\n" +
  "{\n\"classname\" \"info_player_start\"\n\"origin\" \"128 0 24\"\n}\n"
saveGateChanged = savegatetestplaysession.changeMapCore(saveGateSession,
  "save_after", saveGateNewEntities, void)
saveGateAssert(saveGateChanged.changed, "post-restore map change did not commit")
savegatetestplaysession.runUntilActive(saveGateSession, 500)
saveGateNewSpawn = saveGateSession.server.networkRuntime.spawnCount
saveGateNewFrame = saveGateSession.server.frameNumber
saveGateNewOutgoing = saveGateServerChannel.outgoingSequence
saveGateAssert(try(savegatetestpersistence.restorePlaySession(
  saveGateSession, saveGateCheckpoint)) is error,
  "old-map checkpoint crossed a new spawn epoch")
saveGateAssert(saveGateSession.server.mapName == "save_after" and
  saveGateSession.server.networkRuntime.spawnCount == saveGateNewSpawn and
  saveGateSession.server.frameNumber == saveGateNewFrame and
  saveGateServerChannel.outgoingSequence == saveGateNewOutgoing and
  savegatetestplaysession.signonComplete(saveGateSession),
  "rejected cross-map restore partially mutated the new session")

saveGateAssert(savegatetestplaysession.shutdown(saveGateSession),
  "persistent play session shutdown failed")
print("runtime_active_session_persistence_tests: PASS")
