/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Two-client coop skill, checkpoint, live-channel restore and friendly fire. */
import miniquake2.network.constants as mpchecknetwork
import miniquake2.protocol.netchan as mpchecknetchan
import miniquake2.qcommon.types as mpcheckqtypes
import miniquake2.game.constants as mpcheckgameconstants
import miniquake2.game.gameplay.constants as mpcheckgameplayconstants
import miniquake2.game.player.constants as mpcheckplayerconstants
import miniquake2.game.null_game as mpcheckgame
import miniquake2.game.integration.baseq2 as mpcheckbaseq2
import miniquake2.runtime.multiplayer_session as mpchecksession
import miniquake2.runtime.session_persistence as mpcheckpersistence

function mpcheckAssert(value, name)
  if not value then return error(8485, name) end if
  return true
end function

mpcheckEntities = "{\n\"classname\" \"worldspawn\"\n\"message\" \"Coop Checkpoint\"\n}\n" +
  "{\n\"classname\" \"info_player_start\"\n\"origin\" \"0 0 24\"\n}\n" +
  "{\n\"classname\" \"info_player_coop\"\n\"origin\" \"96 0 24\"\n}\n" +
  "{\n\"classname\" \"key_data_cd\"\n\"origin\" \"48 0 24\"\n}\n"
mpcheckInfos = ["\\name\\CheckpointA\\skin\\male/grunt",
  "\\name\\CheckpointB\\skin\\female/athena"]

// Both endpoint difficulty values must reach the integrated AI/game context
// before SpawnEntities. Keep the easy session short; the nightmare session is
// the persistent live matrix below.
mpcheckEasy = mpchecksession.createCoreAtSkill(mpchecksession.MODE_COOP,
  "coop_easy", mpcheckEntities, void, mpcheckInfos, 0)
mpchecksession.runUntilActive(mpcheckEasy, 500)
mpcheckAssert(mpcheckgame.baseRuntime().aiContext.skill == 0,
  "easy coop skill did not reach gameplay")
mpcheckAssert(mpchecksession.shutdown(mpcheckEasy), "easy coop shutdown")

mpcheckLive = mpchecksession.createCoreAtSkill(mpchecksession.MODE_COOP,
  "coop_nightmare", mpcheckEntities, void, mpcheckInfos, 3)
mpchecksession.runUntilActive(mpcheckLive, 500)
mpcheckAssert(mpcheckgame.baseRuntime().aiContext.skill == 3 and
  mpcheckgame.playerContext().cooperative,
  "nightmare coop mode/skill did not reach gameplay")
mpcheckPlayer0 = mpchecksession.player(mpcheckLive, 0)
mpcheckPlayer1 = mpchecksession.player(mpcheckLive, 1)
mpcheckPickup0 = mpchecksession.touchItem(mpcheckLive, 0, "key_data_cd")
mpcheckPickup1 = mpchecksession.touchItem(mpcheckLive, 1, "key_data_cd")
mpcheckAssert(mpcheckPickup0.success and mpcheckPickup1.success,
  "coop checkpoint key pickup failed")
mpcheckKeyEntity = mpcheckbaseq2.findItemByClass(mpcheckgame.baseRuntime(),
  "key_data_cd")
mpcheckAssert(mpcheckKeyEntity is not void, "coop checkpoint key entity missing")
mpcheckKeyIndex = mpcheckKeyEntity.item.index

mpcheckPlayer0.health = 61
mpcheckPlayer0.gameplay.health = 61
mpcheckPlayer0.respawn.score = 4
mpcheckPlayer1.health = 72
mpcheckPlayer1.gameplay.health = 72
mpcheckPlayer1.respawn.score = 2
mpcheckgame.baseRuntime().world.totalGoals = 7
mpcheckgame.baseRuntime().world.foundGoals = 3
mpcheckGamePath = "build/runtime_multiplayer_coop_checkpoint.game.sav"
mpcheckLevelPath = "build/runtime_multiplayer_coop_checkpoint.level.sav"
mpcheckCheckpoint = mpcheckpersistence.saveMultiplayerSession(mpcheckLive,
  mpcheckGamePath, mpcheckLevelPath)
mpcheckSpawn = mpcheckLive.server.networkRuntime.spawnCount
mpcheckServerFrame = mpcheckLive.server.frameNumber
mpcheckClientChannels = [
  mpcheckLive.clients[0].integrated.network.client.channel,
  mpcheckLive.clients[1].integrated.network.client.channel]
mpcheckServerChannels = [
  mpcheckLive.server.networkRuntime.server.clients[
    mpchecksession.serverSlot(mpcheckLive, 0)].channel,
  mpcheckLive.server.networkRuntime.server.clients[
    mpchecksession.serverSlot(mpcheckLive, 1)].channel]
mpcheckOldClientSequences = [mpcheckClientChannels[0].outgoingSequence,
  mpcheckClientChannels[1].outgoingSequence]

// Mutate both player-private records and shared world state before restoring.
mpcheckPlayer0.health = 5
mpcheckPlayer0.gameplay.health = 5
mpcheckPlayer0.gameplay.inventory.counts[mpcheckKeyIndex] = 0
mpcheckPlayer0.respawn.score = -9
mpcheckPlayer1.health = 9
mpcheckPlayer1.gameplay.health = 9
mpcheckPlayer1.gameplay.inventory.counts[mpcheckKeyIndex] = 0
mpcheckPlayer1.respawn.score = -8
mpcheckgame.baseRuntime().world.totalGoals = 1
mpcheckgame.baseRuntime().world.foundGoals = 0
mpchecksession.step(mpcheckLive)
mpcheckRestore = mpcheckpersistence.restoreMultiplayerSession(mpcheckLive,
  mpcheckCheckpoint)
mpcheckAssert(mpcheckRestore.restored and not mpcheckRestore.reSignon and
  mpcheckRestore.channelPreserved and
  mpcheckLive.server.networkRuntime.spawnCount == mpcheckSpawn and
  mpcheckLive.server.frameNumber >= mpcheckServerFrame,
  "same-map coop checkpoint changed epoch/frame/channel")
mpcheckPlayer0 = mpchecksession.player(mpcheckLive, 0)
mpcheckPlayer1 = mpchecksession.player(mpcheckLive, 1)
mpcheckAssert(mpcheckPlayer0.health == 61 and mpcheckPlayer1.health == 72 and
  mpcheckPlayer0.respawn.score == 4 and mpcheckPlayer1.respawn.score == 2,
  "coop checkpoint did not restore both player records")
mpcheckAssert(mpcheckPlayer0.gameplay.inventory.counts[mpcheckKeyIndex] == 1 and
  mpcheckPlayer1.gameplay.inventory.counts[mpcheckKeyIndex] == 1 and
  mpcheckgame.baseRuntime().world.totalGoals == 7 and
  mpcheckgame.baseRuntime().world.foundGoals == 3 and
  mpcheckgame.baseRuntime().aiContext.skill == 3,
  "coop checkpoint did not restore inventory/world/difficulty")
mpcheckIndex = 0
while mpcheckIndex < 2
  mpcheckSlot = mpchecksession.serverSlot(mpcheckLive, mpcheckIndex)
  mpcheckAssert(nativeRawValue(mpcheckLive.clients[mpcheckIndex].integrated.network.client.channel) ==
    nativeRawValue(mpcheckClientChannels[mpcheckIndex]) and
    nativeRawValue(mpcheckLive.server.networkRuntime.server.clients[mpcheckSlot].channel) ==
    nativeRawValue(mpcheckServerChannels[mpcheckIndex]),
    "coop checkpoint replaced a client/server Netchan")
  mpcheckIndex = mpcheckIndex + 1
end while

// Produce actual teammate damage through decoded UDP UserCmds and the managed
// Blaster projectile. Coop classifies the obituary as friendly fire but does
// not award a deathmatch frag.
mpcheckReady = 0
while mpcheckPlayer0.gameplay.weaponState != mpcheckgameplayconstants.WEAPON_READY and
    mpcheckReady < 16
  mpchecksession.step(mpcheckLive)
  mpcheckReady = mpcheckReady + 1
end while
mpcheckAssert(mpchecksession.prepareCoopPair(mpcheckLive, 0, 1, 96),
  "coop combat pair setup failed")
mpcheckShots = 0
while mpcheckPlayer1.deadFlag == mpcheckplayerconstants.DEAD_NO and
    mpcheckShots < 8
  mpcheckCycle = 0
  while mpcheckPlayer0.gameplay.weaponState != mpcheckgameplayconstants.WEAPON_READY and
      mpcheckCycle < 16
    mpchecksession.step(mpcheckLive)
    mpcheckCycle = mpcheckCycle + 1
  end while
  mpcheckAssert(mpcheckPlayer0.gameplay.weaponState ==
    mpcheckgameplayconstants.WEAPON_READY, "coop Blaster did not become ready")
  mpcheckFireBefore = mpcheckPlayer0.gameplay.fireCount
  mpcheckAttack = mpcheckqtypes.UserCmd(100, mpcheckgameconstants.BUTTON_ATTACK,
    [0, 0, 0], 0, 0, 0, 0, 64)
  mpchecksession.queueUserCmd(mpcheckLive, 0, mpcheckAttack)
  mpcheckFireSteps = 0
  while mpcheckPlayer0.gameplay.fireCount == mpcheckFireBefore and
      mpcheckFireSteps < 8
    mpchecksession.step(mpcheckLive)
    mpcheckFireSteps = mpcheckFireSteps + 1
  end while
  mpcheckAssert(mpcheckPlayer0.gameplay.fireCount == mpcheckFireBefore + 1,
    "coop BUTTON_ATTACK did not reach Weapon_Generic")
  mpcheckShots = mpcheckShots + 1
end while
mpcheckAssert(mpcheckPlayer1.deadFlag != mpcheckplayerconstants.DEAD_NO,
  "coop teammate Blaster damage did not kill victim: health=" +
    mpcheckPlayer1.health + " shots=" + mpcheckShots)
mpcheckAssert(mpcheckPlayer1.obituary ==
  "CheckpointB was blasted by CheckpointA.",
  "coop teammate obituary mismatch: " + mpcheckPlayer1.obituary)
mpcheckAssert(mpcheckPlayer0.respawn.score == 4,
  "coop teammate kill changed attacker score: " + mpcheckPlayer0.respawn.score)
mpcheckAssert(mpcheckPlayer1.respawn.cooperativeInventory[mpcheckKeyIndex] == 1,
  "coop death did not checkpoint retained key inventory")

mpcheckPostRestore = 0
while mpcheckPostRestore < 200
  mpchecksession.step(mpcheckLive)
  mpcheckPostRestore = mpcheckPostRestore + 1
end while
mpcheckResult = mpchecksession.result(mpcheckLive)
mpcheckAssert(mpcheckResult.activeClients == 2 and
  mpcheckResult.packetsRejected == 0 and
  mpcheckResult.clientStates[0] == mpchecknetwork.CA_ACTIVE and
  mpcheckResult.clientStates[1] == mpchecknetwork.CA_ACTIVE and
  mpchecknetchan.sequenceNewer(mpcheckClientChannels[0].outgoingSequence,
    mpcheckOldClientSequences[0]) and
  mpchecknetchan.sequenceNewer(mpcheckClientChannels[1].outgoingSequence,
    mpcheckOldClientSequences[1]),
  "post-checkpoint coop transport soak failed")
mpcheckAssert(mpchecksession.shutdown(mpcheckLive), "coop checkpoint shutdown")
print "runtime_multiplayer_coop_checkpoint_tests: PASS"
