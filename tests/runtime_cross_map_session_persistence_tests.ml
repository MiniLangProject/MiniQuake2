/* Cross-map checkpoint orchestration through real Protocol-34 re-signon. */
import std.fs as crosssavetestfs
import miniquake2.network.constants as crosssavetestnetworkconstants
import miniquake2.protocol.netchan as crosssavetestnetchan
import miniquake2.qcommon.types as crosssavetestqtypes
import miniquake2.game.constants as crosssavetestgameconstants
import miniquake2.game.null_game as crosssavetestgameapi
import miniquake2.runtime.play_session as crosssavetestplaysession
import miniquake2.runtime.session_persistence as crosssavetestpersistence

function crossSaveAssert(value, name)
  if not value then return error(8470, name) end if
  return true
end function

function crossSaveMapA(mapName)
  if mapName != "cross_a" then return error(8471, "unexpected core map request") end if
  crossSaveAEntities = "{\n\"classname\" \"worldspawn\"\n\"message\" \"Checkpoint A\"\n}\n" +
    "{\n\"classname\" \"info_player_start\"\n\"origin\" \"16 0 24\"\n}\n"
  return crosssavetestpersistence.coreMapSource(crossSaveAEntities, void)
end function

function crossSaveRejectResolver(mapName)
  return error(8472, "synthetic map resolver failure")
end function

function crossSaveBrokenMap(mapName)
  return crosssavetestpersistence.coreMapSource("{", void)
end function

function crossSaveFindBytes(data, pattern)
  crossSaveFindOffset = 0
  while crossSaveFindOffset + len(pattern) <= len(data)
    crossSaveFindMatches = true
    crossSaveFindIndex = 0
    while crossSaveFindIndex < len(pattern)
      if data[crossSaveFindOffset + crossSaveFindIndex] != pattern[crossSaveFindIndex] then
        crossSaveFindMatches = false
      end if
      crossSaveFindIndex = crossSaveFindIndex + 1
    end while
    if crossSaveFindMatches then return crossSaveFindOffset end if
    crossSaveFindOffset = crossSaveFindOffset + 1
  end while
  return -1
end function

crossSaveAEntities = "{\n\"classname\" \"worldspawn\"\n\"message\" \"Checkpoint A\"\n}\n" +
  "{\n\"classname\" \"info_player_start\"\n\"origin\" \"16 0 24\"\n}\n"
crossSaveBEntities = "{\n\"classname\" \"worldspawn\"\n\"message\" \"Live B\"\n}\n" +
  "{\n\"classname\" \"info_player_start\"\n\"origin\" \"160 0 24\"\n}\n"
crossSaveSession = crosssavetestplaysession.createCore("cross_a",
  crossSaveAEntities, void, "\\name\\CrossSave\\skin\\male/grunt")
crosssavetestplaysession.runUntilActive(crossSaveSession, 500)
crossSavePlayerA = crosssavetestgameapi.playerContext().players[0]
crossSavePlayerA.health = 72
crossSavePlayerA.maxHealth = 130
crossSavePlayerA.gameplay.health = 72
crossSavePlayerA.gameplay.inventory.counts[2] = 14
crossSavePlayerA.persistent.score = 6
crossSavePlayerA.respawn.score = 6
crossSavePlayerA.edict.state.origin = crosssavetestqtypes.Vec3(48.0, 0.0, 64.0)
crossSavePlayerA.edict.client.playerState.pmove.origin = [384, 0, 512]
crossSavePlayerA.oldPmove.origin = [384, 0, 512]
crossSaveCheckpoint = crosssavetestpersistence.savePlaySession(crossSaveSession,
  "build/runtime_cross_map_game.sav", "build/runtime_cross_map_level.sav")
crossSaveValidGame = crosssavetestfs.readAllBytes(crossSaveCheckpoint.gamePath)
crossSaveServerChannel = crossSaveSession.server.networkRuntime.server.clients[0].channel
crossSaveClientChannel = crossSaveSession.client.integrated.network.client.channel

crossSaveToB = crosssavetestplaysession.changeMapCore(crossSaveSession,
  "cross_b", crossSaveBEntities, void)
crossSaveAssert(crossSaveToB.changed, "initial switch to map B failed")
crosssavetestplaysession.runUntilActive(crossSaveSession, 500)
crossSaveBSpawn = crossSaveSession.server.networkRuntime.spawnCount
crossSaveBOutgoing = crossSaveServerChannel.outgoingSequence

// Resolver and retail bootstrap failures occur before files/state/map/channel
// are touched.
crossSaveBFrameBeforeResolveFailure = crossSaveSession.server.frameNumber
crossSaveAssert(try(crosssavetestpersistence.restorePlaySessionCore(
  crossSaveSession, crossSaveCheckpoint, crossSaveRejectResolver, 500)) is error,
  "failing core resolver was accepted")
crossSaveAssert(crossSaveSession.server.mapName == "cross_b" and
  crossSaveSession.server.networkRuntime.spawnCount == crossSaveBSpawn and
  crossSaveSession.server.frameNumber == crossSaveBFrameBeforeResolveFailure and
  crossSaveServerChannel.outgoingSequence == crossSaveBOutgoing,
  "resolver failure partially mutated map B")
crossSaveAssert(try(crosssavetestpersistence.restorePlaySessionRetail(
  crossSaveSession, crossSaveCheckpoint, "", 500)) is error,
  "empty retail baseDirectory was accepted")

// The resolver itself is legal, but its target entity document is not. The
// source-map rollback image must retain the live B player and channel.
crossSaveBPlayerBeforeBrokenMap = crosssavetestgameapi.playerContext().players[0]
crossSaveBPlayerBeforeBrokenMap.health = 66
crossSaveBPlayerBeforeBrokenMap.gameplay.health = 66
crossSaveBPlayerBeforeBrokenMap.respawn.score = 3
crossSaveBrokenSequence = crossSaveServerChannel.outgoingSequence
crossSaveAssert(try(crosssavetestpersistence.restorePlaySessionCore(
  crossSaveSession, crossSaveCheckpoint, crossSaveBrokenMap, 500)) is error,
  "malformed resolved map was accepted")
crossSaveBPlayerAfterBrokenMap = crosssavetestgameapi.playerContext().players[0]
crossSaveAssert(crossSaveSession.server.mapName == "cross_b" and
  crossSaveSession.server.networkRuntime.spawnCount == crossSaveBSpawn and
  crossSaveBPlayerAfterBrokenMap.health == 66 and
  crossSaveBPlayerAfterBrokenMap.respawn.score == 3 and
  crossSaveServerChannel.outgoingSequence == crossSaveBrokenSequence and
  crosssavetestplaysession.signonComplete(crossSaveSession),
  "malformed target map did not roll source state back atomically")

crossSaveRestore = crosssavetestpersistence.restorePlaySessionCore(
  crossSaveSession, crossSaveCheckpoint, crossSaveMapA, 500)
crossSaveAssert(crossSaveRestore.restored and crossSaveRestore.reSignon and
  crossSaveRestore.channelPreserved and crossSaveSession.server.mapName == "cross_a",
  "cross-map restore did not complete explicit re-signon")
crossSaveAssert(crossSaveSession.server.networkRuntime.spawnCount > crossSaveBSpawn and
  crossSaveSession.client.integrated.network.spawnCount == crossSaveSession.server.networkRuntime.spawnCount and
  nativeRawValue(crossSaveServerChannel) == nativeRawValue(
    crossSaveSession.server.networkRuntime.server.clients[0].channel) and
  nativeRawValue(crossSaveClientChannel) == nativeRawValue(
    crossSaveSession.client.integrated.network.client.channel),
  "cross-map restore replaced channels or retained stale spawn epoch")
crossSaveRestoredA = crosssavetestgameapi.playerContext().players[0]
crossSaveAssert(crossSaveRestoredA.health == 72 and crossSaveRestoredA.maxHealth == 130 and
  crossSaveRestoredA.gameplay.inventory.counts[2] == 14 and
  crossSaveRestoredA.respawn.score == 6 and crossSaveRestoredA.edict.state.origin.x == 48.0,
  "map A player checkpoint was not restored")

crossSaveFrameBeforeSnapshot = crossSaveSession.client.integrated.network.client.currentFrame.serverFrame
crossSaveSnapshotSteps = 0
while crossSaveSession.client.integrated.network.client.currentFrame.serverFrame <= crossSaveFrameBeforeSnapshot and
    crossSaveSnapshotSteps < 16
  crosssavetestplaysession.step(crossSaveSession)
  crossSaveSnapshotSteps = crossSaveSnapshotSteps + 1
end while
crossSaveSnapshot = crossSaveSession.client.integrated.network.client.currentFrame
crossSaveSawRestoredA = false
for each crossSaveEntity in crossSaveSnapshot.entities
  if crossSaveEntity.number == crossSaveRestoredA.edict.state.number and
      crossSaveEntity.origin[0] == 48.0 then crossSaveSawRestoredA = true end if
end for
crossSaveAssert(crossSaveSnapshot.valid and
  crossSaveSnapshot.playerState.stats[crosssavetestgameconstants.STAT_HEALTH] == 72 and
  crossSaveSawRestoredA and crosssavetestplaysession.signonComplete(crossSaveSession),
  "cross-map restore did not produce a valid restored snapshot")

// Return to B and establish live state that must survive a target ReadGame
// failure after map A has already completed its re-signon.
crossSaveBackToB = crosssavetestplaysession.changeMapCore(crossSaveSession,
  "cross_b", crossSaveBEntities, void)
crossSaveAssert(crossSaveBackToB.changed, "second switch to map B failed")
crosssavetestplaysession.runUntilActive(crossSaveSession, 500)
crossSaveLiveBPlayer = crosssavetestgameapi.playerContext().players[0]
crossSaveLiveBPlayer.health = 61
crossSaveLiveBPlayer.maxHealth = 119
crossSaveLiveBPlayer.gameplay.health = 61
crossSaveLiveBPlayer.gameplay.inventory.counts[2] = 9
crossSaveLiveBPlayer.persistent.score = 8
crossSaveLiveBPlayer.respawn.score = 8
crossSaveFailureStartSpawn = crossSaveSession.server.networkRuntime.spawnCount
crossSaveFailureStartSequence = crossSaveServerChannel.outgoingSequence

crossSaveCorruptGame = bytes(crossSaveValidGame)
crossSavePrivateOffset = crossSaveFindBytes(crossSaveCorruptGame, bytes("MQ2BASEQ2"))
crossSaveAssert(crossSavePrivateOffset > 0, "cross-map private marker missing")
crossSaveCorruptGame[crossSavePrivateOffset] = 88
crosssavetestfs.writeAllBytes(crossSaveCheckpoint.gamePath, crossSaveCorruptGame)
crossSaveAssert(try(crosssavetestpersistence.restorePlaySessionCore(
  crossSaveSession, crossSaveCheckpoint, crossSaveMapA, 500)) is error,
  "corrupt cross-map checkpoint was accepted")
crosssavetestfs.writeAllBytes(crossSaveCheckpoint.gamePath, crossSaveValidGame)

crossSaveRolledBackB = crosssavetestgameapi.playerContext().players[0]
crossSaveAssert(crossSaveSession.server.mapName == "cross_b" and
  crosssavetestplaysession.signonComplete(crossSaveSession) and
  crossSaveRolledBackB.health == 61 and crossSaveRolledBackB.maxHealth == 119 and
  crossSaveRolledBackB.gameplay.inventory.counts[2] == 9 and
  crossSaveRolledBackB.respawn.score == 8,
  "failed target Read did not restore live map B state")
crossSaveAssert(crossSaveSession.server.networkRuntime.spawnCount > crossSaveFailureStartSpawn and
  crosssavetestnetchan.sequenceNewer(crossSaveServerChannel.outgoingSequence,
    crossSaveFailureStartSequence) and
  nativeRawValue(crossSaveServerChannel) == nativeRawValue(
    crossSaveSession.server.networkRuntime.server.clients[0].channel) and
  crossSaveSession.client.integrated.network.client.state == crosssavetestnetworkconstants.CA_ACTIVE,
  "failure rollback did not preserve channel identity/new signon epoch")

crossSaveRollbackFrame = crossSaveSession.client.integrated.network.client.currentFrame.serverFrame
crossSaveRollbackSnapshotSteps = 0
while crossSaveSession.client.integrated.network.client.currentFrame.serverFrame <= crossSaveRollbackFrame and
    crossSaveRollbackSnapshotSteps < 16
  crosssavetestplaysession.step(crossSaveSession)
  crossSaveRollbackSnapshotSteps = crossSaveRollbackSnapshotSteps + 1
end while
crossSaveAssert(crossSaveSession.client.integrated.network.client.currentFrame.playerState.stats[
  crosssavetestgameconstants.STAT_HEALTH] == 61,
  "failure rollback did not publish restored map B snapshot")

crossSaveAssert(crosssavetestplaysession.shutdown(crossSaveSession),
  "cross-map persistence session shutdown failed")
print("runtime_cross_map_session_persistence_tests: PASS")
