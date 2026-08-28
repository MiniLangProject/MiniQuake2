/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Two-client goal route with same-map checkpoints across all retail SP BSPs. */
import miniquake2.game.null_game as mpcpgame
import miniquake2.game.constants as mpcpgameconstants
import miniquake2.game.gameplay.constants as mpcpgameplayconstants
import miniquake2.runtime.multiplayer_session as mpcpsession
import miniquake2.runtime.multiplayer_campaign_session as mpcpcampaign
import miniquake2.runtime.session_persistence as mpcppersistence

// Assert the mpcp test condition.
function mpcpAssert(value, name)
  if not value then return error(8495, name) end if
  return true
end function

// Return the mpcp entities value.
function mpcpEntities(nextMap, origin)
  return "{\"classname\" \"worldspawn\"}" +
    "{\"classname\" \"info_player_start\" \"origin\" \"" + origin + "\"}" +
    "{\"classname\" \"info_player_start\" \"targetname\" \"start\" " +
      "\"origin\" \"" + origin + "\"}" +
    "{\"classname\" \"info_player_coop\" \"origin\" \"64 0 0\"}" +
    "{\"classname\" \"info_player_coop\" \"targetname\" \"start\" " +
      "\"origin\" \"96 0 0\"}" +
    "{\"classname\" \"trigger_once\" \"target\" \"exit_goal\"}" +
    "{\"classname\" \"target_changelevel\" \"targetname\" \"exit_goal\" \"map\" \"" +
      nextMap + "$start\"}"
end function

// Return the mpcp checkpoint value.
function mpcpCheckpoint(session, ordinal)
  mpcpPlayer0 = mpcpsession.player(session, 0)
  mpcpPlayer1 = mpcpsession.player(session, 1)
  mpcpHealth0 = 60 + (ordinal % 30)
  mpcpHealth1 = 70 + (ordinal % 20)
  mpcpPlayer0.health = mpcpHealth0
  mpcpPlayer0.gameplay.health = mpcpHealth0
  mpcpPlayer0.flags = mpcpPlayer0.flags | mpcpgameplayconstants.FL_GODMODE
  mpcpPlayer0.respawn.score = ordinal
  mpcpPlayer1.health = mpcpHealth1
  mpcpPlayer1.gameplay.health = mpcpHealth1
  mpcpPlayer1.flags = mpcpPlayer1.flags | mpcpgameplayconstants.FL_GODMODE
  mpcpPlayer1.respawn.score = ordinal + 1
  mpcpClientChannel0 = session.clients[0].integrated.network.client.channel
  mpcpClientChannel1 = session.clients[1].integrated.network.client.channel
  mpcpServerChannel0 = session.server.networkRuntime.server.clients[
    mpcpsession.serverSlot(session, 0)].channel
  mpcpServerChannel1 = session.server.networkRuntime.server.clients[
    mpcpsession.serverSlot(session, 1)].channel
  mpcpSpawn = session.server.networkRuntime.spawnCount
  mpcpCheckpointValue = mpcppersistence.saveMultiplayerSession(session,
    "build/runtime_multiplayer_campaign.game.sav",
    "build/runtime_multiplayer_campaign.level.sav")
  mpcpPlayer0.health = 1
  mpcpPlayer0.gameplay.health = 1
  mpcpPlayer0.respawn.score = -1
  mpcpPlayer1.health = 2
  mpcpPlayer1.gameplay.health = 2
  mpcpPlayer1.respawn.score = -2
  mpcpRestored = mpcppersistence.restoreMultiplayerSession(session,
    mpcpCheckpointValue)
  mpcpPlayer0 = mpcpsession.player(session, 0)
  mpcpPlayer1 = mpcpsession.player(session, 1)
  mpcpAssert(mpcpRestored.restored and not mpcpRestored.reSignon and
    session.server.networkRuntime.spawnCount == mpcpSpawn and
    mpcpPlayer0.health == mpcpHealth0 and mpcpPlayer1.health == mpcpHealth1 and
    mpcpPlayer0.respawn.score == ordinal and
    mpcpPlayer1.respawn.score == ordinal + 1,
    "multiplayer campaign checkpoint state " + session.server.mapName)
  mpcpAssert(nativeRawValue(session.clients[0].integrated.network.client.channel) ==
      nativeRawValue(mpcpClientChannel0) and
    nativeRawValue(session.clients[1].integrated.network.client.channel) ==
      nativeRawValue(mpcpClientChannel1) and
    nativeRawValue(session.server.networkRuntime.server.clients[
      mpcpsession.serverSlot(session, 0)].channel) == nativeRawValue(mpcpServerChannel0) and
    nativeRawValue(session.server.networkRuntime.server.clients[
      mpcpsession.serverSlot(session, 1)].channel) == nativeRawValue(mpcpServerChannel1),
    "multiplayer campaign checkpoint replaced Netchan " + session.server.mapName)
  mpcpSnapshotReady = false
  mpcpSnapshotAttempts = 0
  while not mpcpSnapshotReady and mpcpSnapshotAttempts < 32
    mpcpsession.step(session)
    mpcpSnapshotReady = mpcpsession.signonComplete(session) and
      session.clients[0].integrated.network.client.currentFrame.valid and
      session.clients[1].integrated.network.client.currentFrame.valid and
      session.clients[0].integrated.network.client.currentFrame.playerState.stats[
        mpcpgameconstants.STAT_HEALTH] == mpcpHealth0 and
      session.clients[1].integrated.network.client.currentFrame.playerState.stats[
        mpcpgameconstants.STAT_HEALTH] == mpcpHealth1
    mpcpSnapshotAttempts = mpcpSnapshotAttempts + 1
  end while
  mpcpAssert(mpcpsession.signonComplete(session),
    "multiplayer campaign checkpoint lost signon " + session.server.mapName)
  mpcpAssert(mpcpSnapshotReady,
    "multiplayer campaign clients missing restored health snapshot " +
      session.server.mapName)
  return true
end function

// Return the mpcp synthetic value.
function mpcpSynthetic()
  mpcpSyntheticSession = mpcpsession.createCoreAtSkill(
    mpcpsession.MODE_COOP, "mpcp-a", mpcpEntities("mpcp-b", "0 0 0"),
    void, ["\\name\\CoopA\\skin\\male/grunt",
      "\\name\\CoopB\\skin\\female/athena"], 2)
  mpcpsession.runUntilActive(mpcpSyntheticSession, 500)
  mpcpCheckpoint(mpcpSyntheticSession, 1)
  mpcpSyntheticAdvance = mpcpcampaign.advanceCore(mpcpSyntheticSession,
    "mpcp-b", mpcpEntities("mpcp-c", "128 0 0"), void, 500)
  mpcpAssert(mpcpSyntheticAdvance.advanced and
    mpcpSyntheticAdvance.objective.reached and
    mpcpsession.signonComplete(mpcpSyntheticSession),
    "synthetic multiplayer objective/re-signon")
  mpcpAssert(mpcpsession.shutdown(mpcpSyntheticSession),
    "synthetic multiplayer campaign shutdown")
  return true
end function

// Return the mpcp seen value.
function mpcpSeen(values, candidate)
  for each mpcpKnown in values
    if mpcpKnown == candidate then return true end if
  end for
  return false
end function

// Return the mpcp retail value.
function mpcpRetail(baseDirectory)
  mpcpRetailSession = mpcpsession.createRetailAtSkill(
    mpcpsession.MODE_COOP, baseDirectory, "base1",
    ["\\name\\RetailCoopA\\skin\\male/grunt",
      "\\name\\RetailCoopB\\skin\\female/athena"], 2)
  mpcpsession.runUntilActive(mpcpRetailSession, 700)
  mpcpRoute = [
    "base2", "base3", "train", "base3", "base2", "bunk1",
    "ware1", "bunk1", "ware2", "jail1",
    "jail2", "jail3", "jail4", "jail3", "jail5", "jail3", "security", "mintro",
    "mine1", "mine2", "mine3", "mine4", "mine3", "fact1",
    "fact2", "fact1", "fact3", "fact1", "power1",
    "power2", "cool1", "power2", "waste1", "waste2", "waste3", "waste1", "power2", "biggun",
    "hangar1", "space", "hangar1", "lab", "hangar1", "hangar2", "command", "strike", "city1",
    "city2", "city3", "boss1", "boss2"]
  mpcpVisited = ["base1"]
  mpcpCheckpoint(mpcpRetailSession, 1)
  mpcpTransitionCount = 0
  for each mpcpTarget in mpcpRoute
    mpcpAdvance = mpcpcampaign.advanceRetail(mpcpRetailSession,
      baseDirectory, mpcpTarget, 700)
    mpcpAssert(mpcpAdvance.advanced and mpcpAdvance.objective.reached and
      not mpcpAdvance.objective.directFallback and
      mpcpRetailSession.server.mapName == mpcpTarget and
      mpcpsession.signonComplete(mpcpRetailSession),
      "retail multiplayer objective/re-signon " + mpcpTarget)
    mpcpTransitionCount = mpcpTransitionCount + 1
    if not mpcpSeen(mpcpVisited, mpcpTarget) then
      mpcpVisited = mpcpVisited + [mpcpTarget]
      mpcpCheckpoint(mpcpRetailSession, len(mpcpVisited))
    end if
  end for
  mpcpTerminal = mpcpcampaign.complete(mpcpRetailSession, "victory.pcx")
  mpcpAssert(len(mpcpVisited) == 39 and mpcpTransitionCount == 51 and
    mpcpTerminal.advanced and mpcpTerminal.objective.reached and
    mpcpsession.result(mpcpRetailSession).packetsRejected == 0,
    "retail multiplayer route/checkpoint aggregate")
  mpcpAssert(mpcpsession.shutdown(mpcpRetailSession),
    "retail multiplayer campaign shutdown")
  print "runtime_multiplayer_campaign_checkpoint_tests: retail PASS maps=39 transitions=51 checkpoints=39"
  return true
end function

// Run this source file's command-line entry point.
function main(args)
  if len(args) > 1 then return error(8496, "expected optional Quake II install root") end if
  mpcpSynthetic()
  if len(args) == 1 then mpcpRetail(args[0])
  else print "runtime_multiplayer_campaign_checkpoint_tests: synthetic PASS"
  end if
  return 0
end function
