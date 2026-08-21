/* Real two-client UDP deathmatch session: signon, kill, score, respawn, snapshots. */
import miniquake2.network.constants as mpdtestnetworkconstants
import miniquake2.qcommon.types as mpdtestqtypes
import miniquake2.game.constants as mpdtestgameconstants
import miniquake2.game.player.constants as mpdtestplayerconstants
import miniquake2.game.gameplay.constants as mpdtestgameplayconstants
import miniquake2.game.null_game as mpdtestgameapi
import miniquake2.runtime.multiplayer_session as mpdtestsession

function mpdAssert(value, name)
  if not value then return error(8420, name) end if
  return true
end function

mpdEntities = "{\n\"classname\" \"worldspawn\"\n\"message\" \"Two Player Deathmatch\"\n}\n" +
  "{\n\"classname\" \"info_player_start\"\n\"origin\" \"0 0 24\"\n}\n" +
  "{\n\"classname\" \"info_player_deathmatch\"\n\"origin\" \"0 0 24\"\n}\n" +
  "{\n\"classname\" \"info_player_deathmatch\"\n\"origin\" \"128 0 24\"\n}\n" +
  "{\n\"classname\" \"info_player_deathmatch\"\n\"origin\" \"256 0 24\"\n}\n"

mpdSession = mpdtestsession.createCore(mpdtestsession.MODE_DEATHMATCH,
  "dm_two", mpdEntities, void,
  ["\\name\\Alpha\\skin\\male/grunt", "\\name\\Bravo\\skin\\female/athena"])
mpdActive = mpdtestsession.runUntilActive(mpdSession, 500)
mpdAssert(mpdActive.activeClients == 2, "both deathmatch clients did not become active")
mpdAssert(mpdActive.clientStates[0] == mpdtestnetworkconstants.CA_ACTIVE and
  mpdActive.clientStates[1] == mpdtestnetworkconstants.CA_ACTIVE,
  "deathmatch client state mismatch")
mpdAssert(mpdActive.serverStates[0] == mpdtestnetworkconstants.CS_SPAWNED and
  mpdActive.serverStates[1] == mpdtestnetworkconstants.CS_SPAWNED,
  "deathmatch server slot state mismatch")
mpdContext = mpdtestgameapi.playerContext()
mpdAssert(mpdContext.deathmatch and not mpdContext.cooperative,
  "deathmatch mode was not installed before spawn")
mpdSlot0 = mpdtestsession.serverSlot(mpdSession, 0)
mpdSlot1 = mpdtestsession.serverSlot(mpdSession, 1)
mpdAssert(mpdSlot0 >= 0 and mpdSlot1 >= 0 and mpdSlot0 != mpdSlot1,
  "clients did not own distinct server slots")
mpdPlayer0 = mpdtestsession.player(mpdSession, 0)
mpdPlayer1 = mpdtestsession.player(mpdSession, 1)
mpdAssert(mpdPlayer0.persistent.netName == "Alpha" and mpdPlayer1.persistent.netName == "Bravo",
  "deathmatch userinfo names did not reach live players")

// Void collision exposes every networked edict to both snapshot builders.
mpdtestsession.step(mpdSession)
mpdAssert(mpdtestsession.snapshotHasEntity(mpdSession, 0, mpdPlayer0.edict.state.number) and
  mpdtestsession.snapshotHasEntity(mpdSession, 0, mpdPlayer1.edict.state.number),
  "client zero snapshot cannot see both players")
mpdAssert(mpdtestsession.snapshotHasEntity(mpdSession, 1, mpdPlayer0.edict.state.number) and
  mpdtestsession.snapshotHasEntity(mpdSession, 1, mpdPlayer1.edict.state.number),
  "client one snapshot cannot see both players")

mpdDeath = mpdtestsession.kill(mpdSession, 1, 0, 105, mpdtestgameplayconstants.MOD_ROCKET)
mpdAssert(mpdDeath.message == "Bravo ate Alpha's rocket.", "deathmatch obituary mismatch")
mpdAssert(mpdPlayer0.respawn.score == 1 and mpdPlayer1.respawn.score == 0,
  "deathmatch score mismatch")
mpdAssert(mpdSession.server.networkRuntime.server.clients[mpdSlot0].score == 1,
  "server status score was not synchronized")
mpdAssert(mpdPlayer1.deadFlag != mpdtestplayerconstants.DEAD_NO and mpdPlayer1.showScores,
  "victim did not enter death/scoreboard state")

mpdWait = 0
while mpdWait < 12
  mpdtestsession.step(mpdSession)
  mpdWait = mpdWait + 1
end while
mpdAttack = mpdtestqtypes.UserCmd(100, mpdtestgameconstants.BUTTON_ATTACK,
  [0, 0, 0], 0, 0, 0, 0, 64)
mpdtestsession.queueUserCmd(mpdSession, 1, mpdAttack)
mpdAssert(mpdContext.time > mpdPlayer1.respawnTime,
  "deathmatch clock did not pass respawn time")
mpdtestsession.step(mpdSession)
mpdAssert(mpdSession.server.networkRuntime.lastCommands[mpdSlot1].buttons == mpdtestgameconstants.BUTTON_ATTACK,
  "server did not decode victim attack command")
// The current managed weapon frame consumes the attack latch while dead;
// exercise BaseQ2's canonical force-respawn rule after proving the wire cmd.
mpdContext.dmFlags = mpdContext.dmFlags | mpdtestgameconstants.DF_FORCE_RESPAWN
mpdRespawnSteps = 0
while mpdPlayer1.deadFlag != mpdtestplayerconstants.DEAD_NO and mpdRespawnSteps < 20
  mpdtestsession.step(mpdSession)
  mpdRespawnSteps = mpdRespawnSteps + 1
end while
mpdAssert(mpdPlayer1.deadFlag == mpdtestplayerconstants.DEAD_NO and mpdPlayer1.health == 100,
  "attack command did not respawn victim")
mpdAssert(mpdtestsession.snapshotHasEntity(mpdSession, 0, mpdPlayer1.edict.state.number),
  "respawned player was not visible in attacker snapshot")
mpdFinal = mpdtestsession.result(mpdSession)
mpdAssert(mpdFinal.packetsRejected == 0 and mpdActive.packetsReceived > 0 and mpdActive.packetsSent > 0,
  "deathmatch UDP transport counters mismatch")
mpdAssert(mpdtestsession.shutdown(mpdSession), "deathmatch shutdown failed")
mpdAssert(not mpdtestsession.shutdown(mpdSession), "deathmatch shutdown was not idempotent")
print("runtime_multiplayer_deathmatch_tests: PASS")
