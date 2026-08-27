/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Real two-client spectator transition, map rotation and post-change soak. */
import miniquake2.network.constants as mprotatenetwork
import miniquake2.qcommon.types as mprotateqtypes
import miniquake2.game.constants as mprotategameconstants
import miniquake2.game.null_game as mprotategame
import miniquake2.runtime.multiplayer_session as mprotatesession

// Assert the mprotate test condition.
function mprotateAssert(value, name)
  if not value then return error(8422, name) end if
  return true
end function

mprotateMapOne = "{\n\"classname\" \"worldspawn\"\n\"message\" \"Rotation One\"\n}\n" +
  "{\n\"classname\" \"info_player_deathmatch\"\n\"origin\" \"0 0 24\"\n}\n" +
  "{\n\"classname\" \"info_player_deathmatch\"\n\"origin\" \"128 0 24\"\n}\n"
mprotateMapTwo = "{\n\"classname\" \"worldspawn\"\n\"message\" \"Rotation Two\"\n}\n" +
  "{\n\"classname\" \"info_player_deathmatch\"\n\"origin\" \"32 0 24\"\n}\n" +
  "{\n\"classname\" \"info_player_deathmatch\"\n\"origin\" \"192 0 24\"\n}\n"

mprotateSession = mprotatesession.createCore(
  mprotatesession.MODE_DEATHMATCH, "dm_one", mprotateMapOne, void,
  ["\\name\\Fighter\\skin\\male/grunt",
   "\\name\\Observer\\skin\\female/athena\\spectator\\1"])
mprotateActive = mprotatesession.runUntilActive(mprotateSession, 500)
mprotateAssert(mprotateActive.activeClients == 2,
  "player and spectator did not complete signon")
mprotatePlayer = mprotatesession.player(mprotateSession, 0)
mprotateObserver = mprotatesession.player(mprotateSession, 1)
mprotateAssert(not mprotatePlayer.respawn.spectator and
  mprotateObserver.persistent.spectator and mprotateObserver.respawn.spectator,
  "initial spectator state did not reach live game")
mprotateAssert(mprotateObserver.moveType == 8 and
  mprotateObserver.edict.solid == mprotategameconstants.SOLID_NOT,
  "spectator is not noclip/non-solid")
mprotateAssert(mprotatesession.snapshotHasEntity(mprotateSession, 1,
  mprotatePlayer.edict.state.number), "spectator cannot observe player snapshot")

// Leave spectator mode through a real reliable clc_userinfo update. The game
// intentionally applies the respawn transition only after its five-second
// debounce window.
mprotateAssert(mprotatesession.setUserInfo(mprotateSession, 1,
  "\\name\\ObserverReturns\\skin\\female/athena\\spectator\\0"),
  "spectator userinfo update was not queued")
mprotateTransitionSteps = 0
while mprotateObserver.respawn.spectator and mprotateTransitionSteps < 80
  mprotatesession.step(mprotateSession)
  mprotateTransitionSteps = mprotateTransitionSteps + 1
end while
mprotateAssert(not mprotateObserver.persistent.spectator and
  not mprotateObserver.respawn.spectator and mprotateObserver.health == 100,
  "spectator did not rejoin deathmatch")
mprotateAssert(mprotateObserver.persistent.netName == "ObserverReturns" and
  mprotateObserver.edict.solid != mprotategameconstants.SOLID_NOT,
  "rejoined spectator identity/solid state")

// Drive the existing DM rules to a real queued gamemap command.
mprotateContext = mprotategame.playerContext()
mprotateContext.mapList = "dm_one dm_two"
mprotateContext.fragLimit = 1
mprotatePlayer.respawn.score = 1
mprotateRuleSteps = 0
while mprotateContext.intermissionTime <= 0.0 and mprotateRuleSteps < 8
  mprotatesession.step(mprotateSession)
  mprotateRuleSteps = mprotateRuleSteps + 1
end while
mprotateAssert(mprotateContext.nextMap == "dm_two" and
  mprotateContext.intermissionTime > 0.0, "fraglimit did not select maplist successor")
mprotateIntermissionWait = 0
while mprotateContext.time <= mprotateContext.intermissionTime + 5.0 and
    mprotateIntermissionWait < 80
  mprotatesession.step(mprotateSession)
  mprotateIntermissionWait = mprotateIntermissionWait + 1
end while
mprotateAssert(mprotateContext.time > mprotateContext.intermissionTime + 5.0,
  "intermission input window did not open")
mprotateExitCommand = mprotateqtypes.UserCmd(100,
  mprotategameconstants.BUTTON_ANY, [0, 0, 0], 0, 0, 0, 0, 64)
mprotatesession.queueUserCmd(mprotateSession, 0, mprotateExitCommand)
mprotateExitSteps = 0
mprotateQueuedMap = ""
while mprotateQueuedMap == "" and mprotateExitSteps < 40
  mprotatesession.step(mprotateSession)
  mprotateQueuedMap = mprotatesession.takeQueuedMap(mprotateSession)
  mprotateExitSteps = mprotateExitSteps + 1
end while
mprotateAssert(mprotateQueuedMap == "dm_two",
  "intermission did not queue selected gamemap")

mprotateOldSpawn = mprotateSession.server.networkRuntime.spawnCount
mprotateOldServerSequence = mprotateSession.server.networkRuntime.server.clients[
  mprotatesession.serverSlot(mprotateSession, 0)].channel.outgoingSequence
mprotateChanged = mprotatesession.changeMapCore(mprotateSession,
  mprotateQueuedMap, mprotateMapTwo, void, 500)
mprotateAssert(mprotateChanged.changed and
  mprotateSession.server.networkRuntime.spawnCount == mprotateOldSpawn + 1,
  "two-client map rotation did not commit a new spawn epoch")
mprotateAssert(mprotatesession.signonComplete(mprotateSession) and
  mprotateSession.clients[0].integrated.network.levelName == "dm_two" and
  mprotateSession.clients[1].integrated.network.levelName == "dm_two",
  "both clients did not re-sign on to rotated map")
mprotateAssert(mprotateSession.server.networkRuntime.server.clients[
  mprotatesession.serverSlot(mprotateSession, 0)].channel.outgoingSequence >
  mprotateOldServerSequence, "map rotation replaced or rewound server Netchan")

mprotateSoak = 0
while mprotateSoak < 500
  mprotatesession.step(mprotateSession)
  mprotateSoak = mprotateSoak + 1
end while
mprotateFinal = mprotatesession.result(mprotateSession)
mprotateAssert(mprotateFinal.activeClients == 2 and
  mprotateFinal.packetsRejected == 0 and
  mprotateFinal.clientStates[0] == mprotatenetwork.CA_ACTIVE and
  mprotateFinal.clientStates[1] == mprotatenetwork.CA_ACTIVE,
  "post-rotation two-client soak failed")
mprotateAssert(mprotatesession.shutdown(mprotateSession),
  "rotation/spectator session shutdown")
print "runtime_multiplayer_rotation_spectator_tests: PASS"
