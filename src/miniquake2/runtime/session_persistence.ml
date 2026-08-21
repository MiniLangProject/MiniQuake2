/* Failure-atomic active-session save/restore adapter over game_export_t. */
package miniquake2.runtime.session_persistence

import miniquake2.game.persistence as savegategamepersistence
import miniquake2.game.null_game as savegategameapi
import miniquake2.network.constants as savegatenetworkconstants
import miniquake2.runtime.server_session as savegateserversession
import miniquake2.runtime.play_session as savegateplaysession

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

function restoreServerSession(server, checkpoint)
  if server is void or server.closed then return error(8449, "cannot restore a closed server session") end if
  if typeof(checkpoint) != "struct" then return error(8450, "session checkpoint is missing") end if
  validatePaths(checkpoint.gamePath, checkpoint.levelPath)
  if checkpoint.mapName != server.mapName or checkpoint.spawnCount != server.networkRuntime.spawnCount then
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
