/* Save/restore across staged Jorg death and the dynamic Makron successor. */
import std.fs as bosspersistencefs
import miniquake2.server.game_bridge as bosspersistencebridge
import miniquake2.game.null_game as bosspersistencegame
import miniquake2.game.integration.baseq2 as bosspersistenceintegration
import miniquake2.qcommon.types as bosspersistenceqtypes

function bossPersistenceAssert(value, message)
  if value != true then return error(9834, message) end if
  return true
end function

function bossPersistenceMonster(runtime, className)
  for each bossPersistenceActor in runtime.monsters
    if bossPersistenceActor.className == className then return bossPersistenceActor end if
  end for
  return void
end function

function bossPersistenceMonsterIndex(runtime, className)
  bossPersistenceIndex = 0
  while bossPersistenceIndex < len(runtime.monsters)
    if runtime.monsters[bossPersistenceIndex].className == className then return bossPersistenceIndex end if
    bossPersistenceIndex = bossPersistenceIndex + 1
  end while
  return -1
end function

bossPersistencePath = "gameplay_boss_persistence_tests.sav"
if bosspersistencefs.exists(bossPersistencePath) then bosspersistencefs.delete(bossPersistencePath) end if

bossPersistenceServer = bosspersistencebridge.createRuntime(4)
bossPersistenceApi = bosspersistencegame.GetGameApi(bosspersistencebridge.makeImports(bossPersistenceServer))
bossPersistenceServer.game = bossPersistenceApi
bossPersistenceApi.init()
bossPersistenceFixture = "{\"classname\" \"worldspawn\"}" +
  "{\"classname\" \"info_player_start\" \"origin\" \"0 0 0\"}" +
  "{\"classname\" \"trigger_counter\" \"targetname\" \"t26\" \"target\" \"t5\" \"count\" \"2\"}" +
  "{\"classname\" \"target_changelevel\" \"targetname\" \"t5\" \"map\" \"*victory\"}" +
  "{\"classname\" \"monster_jorg\" \"origin\" \"128 16 4\" \"angles\" \"0 45 0\" \"target\" \"t26\"}" +
  "{\"classname\" \"monster_soldier\" \"origin\" \"256 16 4\"}"
bossPersistenceApi.spawnEntities("boss2", bossPersistenceFixture, "")
bossPersistenceRuntime = bosspersistencegame.baseRuntime()
bossPersistenceJorg = bossPersistenceMonster(bossPersistenceRuntime, "monster_jorg")
bossPersistenceSoldier = bossPersistenceMonster(bossPersistenceRuntime, "monster_soldier")
bossPersistenceCounter = bosspersistenceintegration.findWorldByClass(bossPersistenceRuntime, "trigger_counter")
bossPersistenceJorg.edict.state.origin = bosspersistenceqtypes.Vec3(144.0, 24.0, 8.0)
bossPersistenceJorg.edict.state.oldOrigin = bosspersistenceqtypes.Vec3(140.0, 20.0, 8.0)
bossPersistenceJorg.edict.state.angles = bosspersistenceqtypes.Vec3(0.0, 75.0, 0.0)

bossPersistenceJorgIndex = bossPersistenceMonsterIndex(bossPersistenceRuntime, "monster_jorg")
bosspersistenceintegration.damageMonster(bossPersistenceRuntime, bossPersistenceJorgIndex, void, 4000)
// Retain a live monster enemy through the staged continuation without using
// that AI record as the world-target activator for Jorg's first DeathUse.
bossPersistenceJorg.enemy = bossPersistenceSoldier
bossPersistenceAssert(bossPersistenceCounter.count == 1, "Jorg DeathUse fires first counter edge")
bossPersistenceAssert(bossPersistenceJorg.deathUseComplete and bossPersistenceJorg.bossPhase == "jorg-death" and
  bossPersistenceJorg.successorSpawned == false, "Jorg enters persistent staged death")
bossPersistenceAssert(len(bossPersistenceRuntime.monsters) == 2, "Makron is not tossed immediately")
bossPersistenceApi.writeLevel(bossPersistencePath)

bossPersistenceJorg.target = "mutated"
bossPersistenceJorg.enemy = void
bossPersistenceJorg.edict.state.origin = bosspersistenceqtypes.Vec3(999.0, 999.0, 999.0)
bossPersistenceJorg.successorDueTime = 99.0
bossPersistenceApi.readLevel(bossPersistencePath)
bossPersistenceRuntime = bosspersistencegame.baseRuntime()
bossPersistenceJorg = bossPersistenceMonster(bossPersistenceRuntime, "monster_jorg")
bossPersistenceSoldier = bossPersistenceMonster(bossPersistenceRuntime, "monster_soldier")
bossPersistenceCounter = bosspersistenceintegration.findWorldByClass(bossPersistenceRuntime, "trigger_counter")
bossPersistenceAssert(len(bossPersistenceRuntime.monsters) == 2 and bossPersistenceJorg.bossPhase == "jorg-death",
  "staged Jorg phase restored without premature successor")
bossPersistenceAssert(bossPersistenceJorg.deathUseComplete and bossPersistenceJorg.successorSpawned == false and
  bossPersistenceJorg.target == "t26", "DeathUse and successor guards restored")
bossPersistenceAssert(bossPersistenceJorg.enemy is not void and bossPersistenceJorg.enemy.className == "monster_soldier" and
  bossPersistenceJorg.enemy.edict.state.number == bossPersistenceSoldier.edict.state.number, "Jorg enemy reference restored")
bossPersistenceAssert(bossPersistenceJorg.edict.state.origin.x == 144.0 and bossPersistenceJorg.edict.state.origin.y == 24.0 and
  bossPersistenceJorg.edict.state.angles.y == 75.0 and bossPersistenceJorg.edict.state.oldOrigin.x == 140.0,
  "Jorg transform restored")
bossPersistenceAssert(bossPersistenceJorg.nextThink < bossPersistenceJorg.successorDueTime and
  bossPersistenceJorg.activity == "monster_jorg-death",
  "Jorg death animation and successor deadline restored")

bossPersistenceStageFrames = 0
while len(bossPersistenceRuntime.monsters) == 2 and bossPersistenceStageFrames < 55
  bossPersistenceApi.runFrame()
  bossPersistenceStageFrames = bossPersistenceStageFrames + 1
end while
bossPersistenceAssert(len(bossPersistenceRuntime.monsters) == 3, "restored Jorg death continues to Makron toss")
bossPersistenceMakron = bossPersistenceMonster(bossPersistenceRuntime, "monster_makron")
bossPersistenceAssert(bossPersistenceMakron is not void and bossPersistenceMakron.bossPhase == "makron-active" and
  bossPersistenceMakron.target == "t26", "Makron successor phase and target established")
bossPersistenceAssert(bossPersistenceMakron.enemy is not void and bossPersistenceMakron.enemy.className == "monster_soldier",
  "Makron inherits restored enemy")
bossPersistenceAssert(bossPersistenceMakron.edict.state.origin.x == 144.0 and bossPersistenceMakron.edict.state.angles.y == 75.0,
  "Makron inherits restored Jorg transform")
bossPersistenceAssert(bossPersistenceCounter.count == 1, "Makron toss does not refire DeathUse")

// Save again with a runtime-only edict.  Restore must materialize the actor,
// bind it to the persisted engine edict, and retain the active boss phase.
bossPersistenceApi.writeLevel(bossPersistencePath)
bossPersistenceMakron.target = "mutated"
bossPersistenceMakron.enemy = void
bossPersistenceMakron.edict.state.origin = bosspersistenceqtypes.Vec3(-1.0, -1.0, -1.0)
bossPersistenceApi.readLevel(bossPersistencePath)
bossPersistenceRuntime = bosspersistencegame.baseRuntime()
bossPersistenceMakron = bossPersistenceMonster(bossPersistenceRuntime, "monster_makron")
bossPersistenceCounter = bosspersistenceintegration.findWorldByClass(bossPersistenceRuntime, "trigger_counter")
bossPersistenceAssert(len(bossPersistenceRuntime.monsters) == 3 and bossPersistenceMakron is not void,
  "dynamic Makron actor materialized on restore")
bossPersistenceAssert(bossPersistenceMakron.bossPhase == "makron-active" and bossPersistenceMakron.target == "t26" and
  bossPersistenceMakron.enemy is not void and bossPersistenceMakron.enemy.className == "monster_soldier",
  "Makron phase target and enemy restored")
bossPersistenceAssert(bossPersistenceMakron.edict.state.origin.x == 144.0 and
  bossPersistenceMakron.edict.state.number < bossPersistenceApi.numEdicts,
  "Makron transform and exported edict restored")

bossPersistenceMakronIndex = bossPersistenceMonsterIndex(bossPersistenceRuntime, "monster_makron")
bosspersistenceintegration.damageMonster(bossPersistenceRuntime, bossPersistenceMakronIndex, void, 4000)
bossPersistenceContext = bosspersistencegame.playerContext()
bossPersistenceAssert(bossPersistenceCounter.count == 0 and bossPersistenceRuntime.world.intermission,
  "restored Makron completes campaign counter")
bossPersistenceAssert(bossPersistenceContext.nextMap == "*victory", "restored Makron reaches changelevel")
bossPersistenceAssert(bossPersistenceMakron.deathUseComplete and bossPersistenceMakron.bossPhase == "makron-complete",
  "Makron completion guard recorded")
bossPersistenceAssert(bosspersistenceintegration.damageMonster(bossPersistenceRuntime, bossPersistenceMakronIndex, void, 1) == false and
  bossPersistenceCounter.count == 0, "Makron DeathUse cannot execute twice")

bossPersistenceApi.shutdown()
bosspersistencefs.delete(bossPersistencePath)
print("gameplay_boss_persistence_tests: PASS")
