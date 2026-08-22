/* Failure-atomic active-session save/restore adapter over game_export_t. */
package miniquake2.runtime.session_persistence

import miniquake2.game.persistence as savegategamepersistence
import miniquake2.game.null_game as savegategameapi
import miniquake2.network.constants as savegatenetworkconstants
import miniquake2.runtime.server_session as savegateserversession
import miniquake2.runtime.play_session as savegateplaysession
import miniquake2.runtime.multiplayer_session as savegatemultiplayer

struct SessionCheckpoint
  gamePath
  levelPath
  mapName
  spawnCount
  gameFrame
  serverFrame
end struct

struct SessionRestoreResult
  restored
  reSignon
  mapName
  spawnCount
  gameFrame
  serverFrame
  channelPreserved
end struct

struct CoreMapSource
  entityText
  collision
end struct

function coreMapSource(entityText, collision)
  if typeof(entityText) != "string" then return error(8455, "core map resolver returned invalid entity text") end if
  return CoreMapSource(entityText, collision)
end function

function validatePaths(gamePath, levelPath)
  if typeof(gamePath) != "string" or gamePath == "" or
      typeof(levelPath) != "string" or levelPath == "" then
    return error(8440, "session save paths are missing")
  end if
  if gamePath == levelPath then return error(8441, "game and level save paths must differ") end if
  return true
end function

function readCheckpointImages(server, gamePath, levelPath, expectedMap)
  savegateGameImage = savegategamepersistence.readFile(gamePath, server.gameExport.maxEdicts)
  savegateLevelImage = savegategamepersistence.readFile(levelPath, server.gameExport.maxEdicts)
  if savegateGameImage.kind != "game" or savegateLevelImage.kind != "level" then
    return error(8442, "session checkpoint kind mismatch")
  end if
  if savegateGameImage.mapName != expectedMap or savegateLevelImage.mapName != expectedMap or
      savegateGameImage.frameNumber != savegateLevelImage.frameNumber or
      savegateGameImage.numEdicts != savegateLevelImage.numEdicts or
      len(savegateGameImage.privateData) == 0 or len(savegateLevelImage.privateData) == 0 then
    return error(8443, "session checkpoint images disagree")
  end if
  return [savegateGameImage, savegateLevelImage]
end function

function synchronizeRestoredServer(server)
  savegateserversession.synchronizeServerState(server)
  savegateRestoredContext = savegategameapi.playerContext()
  if savegateRestoredContext is void then return error(8444, "restored player context is missing") end if
  for each savegateRestoredPlayer in savegateRestoredContext.players
    savegateRestoredSlot = savegateRestoredPlayer.edict.state.number - 1
    if savegateRestoredSlot >= 0 and savegateRestoredSlot < server.networkRuntime.server.maxClients then
      server.networkRuntime.server.clients[savegateRestoredSlot].score = savegateRestoredPlayer.respawn.score
    end if
  end for
  return true
end function

function saveServerSession(server, gamePath, levelPath)
  validatePaths(gamePath, levelPath)
  if server is void or server.closed then return error(8445, "cannot save a closed server session") end if
  savegateGameWritten = try(server.gameExport.writeGame(gamePath, false))
  if savegateGameWritten is error then return savegateGameWritten end if
  savegateLevelWritten = try(server.gameExport.writeLevel(levelPath))
  if savegateLevelWritten is error then return savegateLevelWritten end if
  savegateImages = readCheckpointImages(server, gamePath, levelPath, server.mapName)
  savegateImage = savegateImages[0]
  return SessionCheckpoint(gamePath, levelPath, server.mapName,
    server.networkRuntime.spawnCount, savegateImage.frameNumber, server.frameNumber)
end function

function savePlaySession(session, gamePath, levelPath)
  if session is void or session.closed or not savegateplaysession.signonComplete(session) then
    return error(8446, "play session must be active before save")
  end if
  return saveServerSession(session.server, gamePath, levelPath)
end function

function saveMultiplayerSession(session, gamePath, levelPath)
  if session is void or session.closed or not savegatemultiplayer.signonComplete(session) then
    return error(8480, "multiplayer session must be active before save")
  end if
  return saveServerSession(session.server, gamePath, levelPath)
end function

// Reconstruct durable slot metadata after a process restart. Spawn/server
// epochs are intentionally unknown (-1/0); restorePlaySessionRetail therefore
// performs a legal re-signon before applying the images.
function loadSessionCheckpoint(gamePath, levelPath, maxEdicts)
  validatePaths(gamePath, levelPath)
  if typeof(maxEdicts) != "int" or maxEdicts < 1 then
    return error(8467, "persistent checkpoint maxEdicts must be positive")
  end if
  savegatePersistentGame = savegategamepersistence.readFile(gamePath, maxEdicts)
  savegatePersistentLevel = savegategamepersistence.readFile(levelPath, maxEdicts)
  if savegatePersistentGame.kind != "game" or savegatePersistentLevel.kind != "level" or
      savegatePersistentGame.mapName == "" or
      savegatePersistentGame.mapName != savegatePersistentLevel.mapName or
      savegatePersistentGame.frameNumber != savegatePersistentLevel.frameNumber or
      savegatePersistentGame.numEdicts != savegatePersistentLevel.numEdicts or
      len(savegatePersistentGame.privateData) == 0 or
      len(savegatePersistentLevel.privateData) == 0 then
    return error(8468, "persistent checkpoint pair is inconsistent")
  end if
  return SessionCheckpoint(gamePath, levelPath, savegatePersistentGame.mapName,
    -1, savegatePersistentGame.frameNumber, 0)
end function

function rollbackServerSession(server, rollbackGamePath, rollbackLevelPath)
  savegateRollbackGame = try(server.gameExport.readGame(rollbackGamePath))
  if savegateRollbackGame is error then return savegateRollbackGame end if
  savegateRollbackLevel = try(server.gameExport.readLevel(rollbackLevelPath))
  if savegateRollbackLevel is error then return savegateRollbackLevel end if
  return synchronizeRestoredServer(server)
end function

function restoreFailure(server, rollbackGamePath, rollbackLevelPath, failure)
  savegateRollbackResult = try(rollbackServerSession(server, rollbackGamePath, rollbackLevelPath))
  if savegateRollbackResult is error then
    return error(8447, "session restore and rollback both failed: " + failure.message + "; " + savegateRollbackResult.message)
  end if
  return error(8448, "session restore rejected atomically: " + failure.message)
end function

function restoreServerSessionAtCurrentEpoch(server, checkpoint, requireSavedSpawn)
  if server is void or server.closed then return error(8449, "cannot restore a closed server session") end if
  if typeof(checkpoint) != "struct" then return error(8450, "session checkpoint is missing") end if
  validatePaths(checkpoint.gamePath, checkpoint.levelPath)
  if checkpoint.mapName != server.mapName or
      (requireSavedSpawn and checkpoint.spawnCount != server.networkRuntime.spawnCount) then
    return error(8451, "cross-map session restore requires a map-change re-signon")
  end if
  savegateValidatedImages = readCheckpointImages(server,
    checkpoint.gamePath, checkpoint.levelPath, checkpoint.mapName)
  if savegateValidatedImages[0].frameNumber != checkpoint.gameFrame then
    return error(8452, "session checkpoint metadata is stale")
  end if

  savegatePreservedChannel = void
  savegatePreservedSlot = 0
  while savegatePreservedSlot < server.networkRuntime.server.maxClients and savegatePreservedChannel is void
    savegatePreservedClient = server.networkRuntime.server.clients[savegatePreservedSlot]
    if savegatePreservedClient.state >= savegatenetworkconstants.CS_CONNECTED then
      savegatePreservedChannel = savegatePreservedClient.channel
    end if
    savegatePreservedSlot = savegatePreservedSlot + 1
  end while

  // The rollback images are captured before either requested Read mutates the
  // live export.  They are full managed images just like the target pair.
  savegateRollbackGamePath = checkpoint.gamePath + ".runtime.rollback"
  savegateRollbackLevelPath = checkpoint.levelPath + ".runtime.rollback"
  savegateRollbackGameWritten = try(server.gameExport.writeGame(savegateRollbackGamePath, false))
  if savegateRollbackGameWritten is error then return savegateRollbackGameWritten end if
  savegateRollbackLevelWritten = try(server.gameExport.writeLevel(savegateRollbackLevelPath))
  if savegateRollbackLevelWritten is error then return savegateRollbackLevelWritten end if

  savegateReadGame = try(server.gameExport.readGame(checkpoint.gamePath))
  if savegateReadGame is error then
    return restoreFailure(server, savegateRollbackGamePath, savegateRollbackLevelPath, savegateReadGame)
  end if
  savegateReadLevel = try(server.gameExport.readLevel(checkpoint.levelPath))
  if savegateReadLevel is error then
    return restoreFailure(server, savegateRollbackGamePath, savegateRollbackLevelPath, savegateReadLevel)
  end if
  savegateSynchronized = try(synchronizeRestoredServer(server))
  if savegateSynchronized is error then
    return restoreFailure(server, savegateRollbackGamePath, savegateRollbackLevelPath, savegateSynchronized)
  end if

  savegateChannelPreserved = true
  if savegatePreservedChannel is not void then
    savegateRestoredNetworkClient = server.networkRuntime.server.clients[savegatePreservedSlot - 1]
    savegateChannelPreserved = savegateRestoredNetworkClient.state >= savegatenetworkconstants.CS_CONNECTED and
      nativeRawValue(savegateRestoredNetworkClient.channel) == nativeRawValue(savegatePreservedChannel)
  end if
  return SessionRestoreResult(true, false, server.mapName,
    server.networkRuntime.spawnCount, checkpoint.gameFrame,
    server.frameNumber, savegateChannelPreserved)
end function

function restoreServerSession(server, checkpoint)
  return restoreServerSessionAtCurrentEpoch(server, checkpoint, true)
end function

function restorePlaySession(session, checkpoint)
  if session is void or session.closed or not savegateplaysession.signonComplete(session) then
    return error(8453, "play session must be active before restore")
  end if
  savegatePlayClientChannel = session.client.integrated.network.client.channel
  savegatePlayResult = restoreServerSession(session.server, checkpoint)
  if session.client.integrated.network.client.state != savegatenetworkconstants.CA_ACTIVE or
      session.server.networkRuntime.server.clients[0].state != savegatenetworkconstants.CS_SPAWNED or
      nativeRawValue(session.client.integrated.network.client.channel) != nativeRawValue(savegatePlayClientChannel) then
    return error(8454, "active channel state changed during same-map restore")
  end if
  return savegatePlayResult
end function

function restoreMultiplayerSession(session, checkpoint)
  if session is void or session.closed or not savegatemultiplayer.signonComplete(session) then
    return error(8481, "multiplayer session must be active before restore")
  end if
  savegateMultiplayerClientChannels = array(savegatemultiplayer.CLIENT_COUNT, void)
  savegateMultiplayerServerChannels = array(savegatemultiplayer.CLIENT_COUNT, void)
  savegateMultiplayerChannelIndex = 0
  while savegateMultiplayerChannelIndex < savegatemultiplayer.CLIENT_COUNT
    savegateMultiplayerClientChannel = session.clients[
      savegateMultiplayerChannelIndex].integrated.network.client.channel
    savegateMultiplayerClientChannels[savegateMultiplayerChannelIndex] = savegateMultiplayerClientChannel
    savegateMultiplayerSlot = savegatemultiplayer.serverSlot(session,
      savegateMultiplayerChannelIndex)
    if savegateMultiplayerSlot < 0 then
      return error(8482, "multiplayer restore lost an active server slot")
    end if
    savegateMultiplayerServerChannel = session.server.networkRuntime.server.clients[
      savegateMultiplayerSlot].channel
    savegateMultiplayerServerChannels[savegateMultiplayerChannelIndex] = savegateMultiplayerServerChannel
    savegateMultiplayerChannelIndex = savegateMultiplayerChannelIndex + 1
  end while

  savegateMultiplayerResult = restoreServerSession(session.server, checkpoint)
  savegateMultiplayerVerifyIndex = 0
  while savegateMultiplayerVerifyIndex < savegatemultiplayer.CLIENT_COUNT
    savegateMultiplayerVerifySlot = savegatemultiplayer.serverSlot(session,
      savegateMultiplayerVerifyIndex)
    if savegateMultiplayerVerifySlot < 0 or
        nativeRawValue(session.clients[savegateMultiplayerVerifyIndex].integrated.network.client.channel) !=
          nativeRawValue(savegateMultiplayerClientChannels[savegateMultiplayerVerifyIndex]) or
        nativeRawValue(session.server.networkRuntime.server.clients[savegateMultiplayerVerifySlot].channel) !=
          nativeRawValue(savegateMultiplayerServerChannels[savegateMultiplayerVerifyIndex]) then
      return error(8483, "multiplayer restore replaced a live Netchan")
    end if
    savegateMultiplayerVerifyIndex = savegateMultiplayerVerifyIndex + 1
  end while
  if not savegatemultiplayer.signonComplete(session) then
    return error(8484, "multiplayer restore changed active signon state")
  end if
  savegatemultiplayer.synchronizeScores(session)
  return savegateMultiplayerResult
end function

function saveCrossMapRollback(session, checkpoint)
  savegateCrossRollbackGamePath = checkpoint.gamePath + ".crossmap.rollback"
  savegateCrossRollbackLevelPath = checkpoint.levelPath + ".crossmap.rollback"
  savegateCrossRollback = saveServerSession(session.server,
    savegateCrossRollbackGamePath, savegateCrossRollbackLevelPath)
  return savegateCrossRollback
end function

function changeCoreUntilCommitted(session, mapName, entityText, collision, maximumSteps)
  savegateChangeAttempt = 0
  while savegateChangeAttempt < maximumSteps
    savegateChangeResult = savegateplaysession.changeMapCore(session, mapName, entityText, collision)
    if savegateChangeResult.changed then return savegateChangeResult end if
    if not savegateChangeResult.deferred then return error(8456, "core map change was rejected: " + savegateChangeResult.reason) end if
    savegateplaysession.step(session)
    savegateChangeAttempt = savegateChangeAttempt + 1
  end while
  return error(8457, "core map change remained backpressured")
end function

function changeRetailUntilCommitted(session, baseDirectory, mapName, maximumSteps)
  savegateRetailChangeAttempt = 0
  while savegateRetailChangeAttempt < maximumSteps
    savegateRetailChangeResult = savegateplaysession.changeMapRetail(
      session, baseDirectory, mapName)
    if savegateRetailChangeResult.changed then return savegateRetailChangeResult end if
    if not savegateRetailChangeResult.deferred then
      return error(8464, "retail target map change was rejected: " + savegateRetailChangeResult.reason)
    end if
    savegateplaysession.step(session)
    savegateRetailChangeAttempt = savegateRetailChangeAttempt + 1
  end while
  return error(8464, "retail target map change remained backpressured")
end function

function rollbackCrossMap(session, rollbackCheckpoint, entityText, collision, maximumSteps)
  savegateRollbackMapChange = try(changeCoreUntilCommitted(session,
    rollbackCheckpoint.mapName, entityText, collision, maximumSteps))
  if savegateRollbackMapChange is error then return savegateRollbackMapChange end if
  savegateRollbackSignon = try(savegateplaysession.runUntilActive(session, maximumSteps))
  if savegateRollbackSignon is error then return savegateRollbackSignon end if
  return restoreServerSessionAtCurrentEpoch(session.server, rollbackCheckpoint, false)
end function

function crossMapFailure(session, rollbackCheckpoint, rollbackEntityText, rollbackCollision, maximumSteps, failure)
  savegateCrossRollbackResult = try(rollbackCrossMap(session, rollbackCheckpoint,
    rollbackEntityText, rollbackCollision, maximumSteps))
  if savegateCrossRollbackResult is error then
    return error(8458, "cross-map restore failed and source-map rollback failed: " +
      failure.message + "; " + savegateCrossRollbackResult.message)
  end if
  return error(8459, "cross-map restore failed; source map restored on a new signon epoch: " + failure.message)
end function

function targetMapFailure(session, rollbackCheckpoint, rollbackEntityText, rollbackCollision, maximumSteps, failure)
  // Parser/loader failures normally leave changeMap* on the source map. Any
  // deferred retry steps may still have advanced gameplay, so restore its
  // pre-call image without introducing an unnecessary map epoch.
  if session.server.mapName == rollbackCheckpoint.mapName then
    savegateSameMapRollback = try(restoreServerSessionAtCurrentEpoch(
      session.server, rollbackCheckpoint, false))
    if savegateSameMapRollback is error then
      return error(8465, "target map failed and source state rollback failed: " +
        failure.message + "; " + savegateSameMapRollback.message)
    end if
    return error(8466, "target map failed; source state restored: " + failure.message)
  end if
  return crossMapFailure(session, rollbackCheckpoint, rollbackEntityText,
    rollbackCollision, maximumSteps, failure)
end function

function finishCrossMapRestore(session, checkpoint, rollbackCheckpoint,
    rollbackEntityText, rollbackCollision, maximumSteps)
  savegateTargetSignon = try(savegateplaysession.runUntilActive(session, maximumSteps))
  if savegateTargetSignon is error then
    return crossMapFailure(session, rollbackCheckpoint, rollbackEntityText,
      rollbackCollision, maximumSteps, savegateTargetSignon)
  end if
  savegateTargetRestore = try(restoreServerSessionAtCurrentEpoch(
    session.server, checkpoint, false))
  if savegateTargetRestore is error then
    return crossMapFailure(session, rollbackCheckpoint, rollbackEntityText,
      rollbackCollision, maximumSteps, savegateTargetRestore)
  end if
  return SessionRestoreResult(true, true, session.server.mapName,
    session.server.networkRuntime.spawnCount, checkpoint.gameFrame,
    session.server.frameNumber, savegateTargetRestore.channelPreserved)
end function

function validateCrossMapPlay(session, checkpoint, maximumSteps)
  if session is void or session.closed or not savegateplaysession.signonComplete(session) then
    return error(8453, "play session must be active before restore")
  end if
  if typeof(checkpoint) != "struct" then return error(8450, "session checkpoint is missing") end if
  if typeof(maximumSteps) != "int" or maximumSteps < 1 then
    return error(8461, "cross-map restore step limit must be positive")
  end if
  validatePaths(checkpoint.gamePath, checkpoint.levelPath)
  savegateCrossImages = readCheckpointImages(session.server,
    checkpoint.gamePath, checkpoint.levelPath, checkpoint.mapName)
  if savegateCrossImages[0].frameNumber != checkpoint.gameFrame then
    return error(8452, "session checkpoint metadata is stale")
  end if
  return true
end function

function restorePlaySessionCore(session, checkpoint, resolver, maximumSteps)
  validateCrossMapPlay(session, checkpoint, maximumSteps)
  if typeof(resolver) != "function" then return error(8462, "core map resolver is missing") end if
  if checkpoint.mapName == session.server.mapName and
      checkpoint.spawnCount == session.server.networkRuntime.spawnCount then
    return restorePlaySession(session, checkpoint)
  end if

  // Resolve before creating files or touching the source map.
  savegateResolvedCore = try(resolver(checkpoint.mapName))
  if savegateResolvedCore is error then return savegateResolvedCore end if
  if typeof(savegateResolvedCore) != "struct" or typeof(savegateResolvedCore.entityText) != "string" then
    return error(8455, "core map resolver returned an invalid map source")
  end if
  savegateSourceEntityText = session.server.entityText
  savegateSourceCollision = session.server.collision
  savegateCrossRollbackCheckpoint = saveCrossMapRollback(session, checkpoint)
  savegateTargetChange = try(changeCoreUntilCommitted(session, checkpoint.mapName,
    savegateResolvedCore.entityText, savegateResolvedCore.collision, maximumSteps))
  if savegateTargetChange is error then
    return targetMapFailure(session, savegateCrossRollbackCheckpoint,
      savegateSourceEntityText, savegateSourceCollision, maximumSteps,
      savegateTargetChange)
  end if
  return finishCrossMapRestore(session, checkpoint, savegateCrossRollbackCheckpoint,
    savegateSourceEntityText, savegateSourceCollision, maximumSteps)
end function

function restorePlaySessionRetail(session, checkpoint, baseDirectory, maximumSteps)
  validateCrossMapPlay(session, checkpoint, maximumSteps)
  if typeof(baseDirectory) != "string" or baseDirectory == "" then
    return error(8463, "retail restore base directory is missing")
  end if
  if checkpoint.mapName == session.server.mapName and
      checkpoint.spawnCount == session.server.networkRuntime.spawnCount then
    return restorePlaySession(session, checkpoint)
  end if

  savegateRetailSourceEntityText = session.server.entityText
  savegateRetailSourceCollision = session.server.collision
  savegateRetailRollbackCheckpoint = saveCrossMapRollback(session, checkpoint)
  savegateRetailTargetChange = try(changeRetailUntilCommitted(
    session, baseDirectory, checkpoint.mapName, maximumSteps))
  if savegateRetailTargetChange is error then
    return targetMapFailure(session, savegateRetailRollbackCheckpoint,
      savegateRetailSourceEntityText, savegateRetailSourceCollision,
      maximumSteps, savegateRetailTargetChange)
  end if
  return finishCrossMapRestore(session, checkpoint, savegateRetailRollbackCheckpoint,
    savegateRetailSourceEntityText, savegateRetailSourceCollision, maximumSteps)
end function
