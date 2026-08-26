/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Stock corpse bounds, physical gib edicts and staged boss explosions. */
import miniquake2.game.ai.death_effects as deatheffecttests
import miniquake2.game.ai.reaction_sequences as deatheffectreactions
import miniquake2.game.integration.baseq2 as deatheffectintegration
import miniquake2.game.null_game as deatheffectgame
import miniquake2.game.world.core as deatheffectworld
import miniquake2.game.world.types as deatheffectworldtypes
import miniquake2.game.world.constants as deatheffectworldconstants
import miniquake2.game.constants as deatheffectconstants
import miniquake2.qcommon.types as deatheffectqtypes
import miniquake2.qcommon.constants as deatheffectqconstants
import miniquake2.server.game_bridge as deatheffectbridge
import std.fs as deatheffectfs

function deathEffectAssert(value, message)
  if value != true then return error(9996, message) end if
  return true
end function

function deathEffectSpecCount(specs)
  total = 0
  for each spec in specs
    total = total + spec.count
  end for
  return total
end function

function deathEffectMonsterIndex(runtime, className)
  index = 0
  while index < len(runtime.monsters)
    if runtime.monsters[index].className == className then return index end if
    index = index + 1
  end while
  return -1
end function

function deathEffectWorldGibs(runtime, onlyActive)
  count = 0
  for each entity in runtime.world.entities
    if entity.className == "monster_gib" and (not onlyActive or entity.inUse) then count = count + 1 end if
  end for
  return count
end function

function deathEffectModelCount(runtime, modelName)
  count = 0
  for each entity in runtime.world.entities
    if entity.className == "monster_gib" and entity.model == modelName then count = count + 1 end if
  end for
  return count
end function

deathEffectWaterEnabled = false

function deathEffectPointContents(point)
  global deathEffectWaterEnabled
  if deathEffectWaterEnabled and point.x > 1500.0 then
    return deatheffectqconstants.CONTENTS_WATER
  end if
  return 0
end function

deathEffectAssert(deathEffectSpecCount(deatheffecttests.organicGibs()) == 7, "organic stock gib inventory")
deathEffectAssert(deathEffectSpecCount(deatheffecttests.gibPlan("monster_soldier")) == 5, "soldier stock gib inventory")
deathEffectAssert(deathEffectSpecCount(deatheffecttests.gibPlan("monster_flipper")) == 5, "flipper stock gib inventory")
deathEffectAssert(deathEffectSpecCount(deatheffecttests.gibPlan("monster_tank")) == 7, "tank stock gib inventory")
deathEffectAssert(deathEffectSpecCount(deatheffecttests.gibPlan("monster_makron")) == 6, "Makron stock gib inventory")
deathEffectAssert(deathEffectSpecCount(deatheffecttests.supertankFinalGibs()) == 14, "supertank final gib inventory")
deathEffectAssert(len(deatheffecttests.gibPlan("monster_flyer")) == 0 and
  len(deatheffecttests.gibPlan("monster_floater")) == 0, "exploding flyers do not take generic gib branch")

chickBounds = deatheffecttests.corpseBounds("monster_chick")
tankBounds = deatheffecttests.corpseBounds("monster_tank")
makronBounds = deatheffecttests.corpseBounds("monster_makron")
deathEffectAssert(chickBounds.minimumZ == 0.0 and chickBounds.maximumZ == 16.0 and
  tankBounds.minimumZ == -16.0 and tankBounds.maximumZ == 0.0 and
  makronBounds.minimumX == -60.0 and makronBounds.maximumZ == 72.0,
  "class-specific corpse bounds")
deathEffectAssert(deatheffectreactions.selectDeathPlan("monster_supertank", 7, 1, true).terminalKind == "boss-explode" and
  deatheffectreactions.selectDeathPlan("monster_flyer", 7, 1, true).terminalKind == "explode" and
  deatheffectreactions.selectDeathPlan("monster_soldier", 7, 1, true).terminalKind == "gib",
  "class-specific overkill selection")

bounceProbe = deatheffectworldtypes.createEntity(999, "bounce_probe")
bounceProbe.moveType = deatheffectworldconstants.MOVETYPE_BOUNCE
bounceProbe.velocity = deatheffectqtypes.Vec3(20.0, 0.0, -200.0)
deathEffectAssert(not deatheffectintegration.clipWorldTossVelocity(
  bounceProbe, deatheffectqtypes.Vec3(0.0, 0.0, 1.0)) and
  bounceProbe.velocity.x == 20.0 and bounceProbe.velocity.z == 100.0,
  "fast MOVETYPE_BOUNCE reflects with stock overbounce and remains airborne")
bounceProbe.velocity = deatheffectqtypes.Vec3(0.0, 0.0, -100.0)
deathEffectAssert(deatheffectintegration.clipWorldTossVelocity(
  bounceProbe, deatheffectqtypes.Vec3(0.0, 0.0, 1.0)) and bounceProbe.velocity.z == 50.0,
  "slow MOVETYPE_BOUNCE crosses the stock 60 ups floor-rest threshold")

server = deatheffectbridge.createRuntime(4)
deathEffectImports = deatheffectbridge.makeImports(server)
deathEffectImports.pointContents = deathEffectPointContents
api = deatheffectgame.GetGameApi(deathEffectImports)
server.game = api
api.init()
fixture = "{\"classname\" \"worldspawn\"}" +
  "{\"classname\" \"info_player_start\" \"origin\" \"0 0 0\"}" +
  "{\"classname\" \"monster_gunner\" \"origin\" \"128 0 0\"}" +
  "{\"classname\" \"monster_soldier\" \"origin\" \"192 0 0\"}" +
  "{\"classname\" \"monster_supertank\" \"origin\" \"320 0 0\"}"
api.spawnEntities("death-effects", fixture, "")
runtime = deatheffectgame.baseRuntime()

gunnerIndex = deathEffectMonsterIndex(runtime, "monster_gunner")
gunner = runtime.monsters[gunnerIndex]
gunner.health = 1
deathEffectAssert(deatheffectintegration.damageMonster(runtime, gunnerIndex, void, 1), "normal death dispatch")
gunnerPlan = deatheffectreactions.planByName(gunner.className, gunner.activity)
step = 0
while gunner.activity == gunnerPlan.name and step < 32
  api.runFrame()
  step = step + 1
end while
deathEffectAssert(gunner.activity == "corpse" and gunner.edict.inUse and
  gunner.edict.mins.x == -16.0 and gunner.edict.mins.z == -24.0 and
  gunner.edict.maxs.x == 16.0 and gunner.edict.maxs.z == -8.0 and
  (gunner.edict.serverFlags & deatheffectconstants.SVF_DEADMONSTER) != 0,
  "normal death ends as linked stock corpse")

soldierIndex = deathEffectMonsterIndex(runtime, "monster_soldier")
soldier = runtime.monsters[soldierIndex]
soldier.health = 1
gibsBefore = deathEffectWorldGibs(runtime, false)
edictsBefore = api.numEdicts
deathEffectAssert(deatheffectintegration.damageMonster(runtime, soldierIndex, void, 2 - soldier.gibHealth), "over-gib death dispatch")
deathEffectAssert(deathEffectWorldGibs(runtime, false) - gibsBefore == 5 and api.numEdicts - edictsBefore == 5,
  "over-gib creates five exported physical edicts")
deathEffectAssert(deathEffectModelCount(runtime, "models/objects/gibs/sm_meat/tris.md2") >= 3 and
  deathEffectModelCount(runtime, "models/objects/gibs/chest/tris.md2") >= 1 and
  deathEffectModelCount(runtime, "models/objects/gibs/head2/tris.md2") >= 1,
  "soldier gib models match stock inventory")
for each gibEntity in runtime.world.entities
  if gibEntity.className == "monster_gib" then
    deathEffectAssert(gibEntity.modelIndex > 0 and (gibEntity.effects & deatheffectconstants.EF_GIB) != 0 and
      api.edicts[gibEntity.number].inUse and api.edicts[gibEntity.number].state.modelIndex == gibEntity.modelIndex,
      "gib is visible through exported EntityState")
  end if
end for
api.runFrame()
api.runFrame()
deathEffectAssert(soldier.activity == "gib" and soldier.edict.inUse == false,
  "over-gib terminal hides original monster edict")

supertankIndex = deathEffectMonsterIndex(runtime, "monster_supertank")
supertank = runtime.monsters[supertankIndex]
supertank.health = 1
explosionsBefore = len(server.pendingMulticasts)
gibsBefore = deathEffectWorldGibs(runtime, false)
deathEffectAssert(deatheffectintegration.damageMonster(runtime, supertankIndex, void, 1), "supertank death dispatch")
step = 0
while supertank.activity != "gib" and step < 48
  api.runFrame()
  step = step + 1
end while
deathEffectAssert(supertank.activity == "gib" and supertank.bossPhase == "supertank-complete" and
  supertank.edict.inUse == false, "supertank completes staged destruction")
deathEffectAssert(len(server.pendingMulticasts) - explosionsBefore == 8,
  "supertank emits eight Protocol-34 explosion events")
deathEffectAssert(deathEffectWorldGibs(runtime, false) - gibsBefore == 14 and
  deathEffectModelCount(runtime, "models/objects/gibs/sm_metal/tris.md2") == 8,
  "supertank emits fourteen stock final gibs")

movingMetalGib = void
for each candidateGib in runtime.world.entities
  if candidateGib.className == "monster_gib" and
      candidateGib.model == "models/objects/gibs/sm_metal/tris.md2" then
    movingMetalGib = candidateGib
  end if
end for
deathEffectAssert(movingMetalGib is not void and
  movingMetalGib.moveType == deatheffectworldconstants.MOVETYPE_BOUNCE,
  "metallic death part uses stock bounce physics")
metalOriginZ = movingMetalGib.origin.z
api.runFrame()
deathEffectAssert(movingMetalGib.origin.z != metalOriginZ,
  "integrated world frame advances MOVETYPE_BOUNCE death parts")

waterGibNumber = movingMetalGib.number
movingMetalGib.origin.x = 2000.0
movingMetalGib.oldOrigin.x = 2000.0
api.edicts[waterGibNumber].state.origin.x = 2000.0
api.edicts[waterGibNumber].state.oldOrigin.x = 2000.0
waterEntrySound = server.pendingSoundCount
deathEffectWaterEnabled = true
api.runFrame()
deathEffectAssert(movingMetalGib.waterType == deatheffectqconstants.CONTENTS_WATER and
  movingMetalGib.waterLevel == 1 and server.pendingSoundCount == waterEntrySound + 1,
  "dry bounce entity enters water and queues one positioned splash")
entrySplash = server.pendingSounds[waterEntrySound]
deathEffectAssert(server.soundNames[entrySplash.soundIndex] == "misc/h2ohit1.wav",
  "water entry splash uses stock sound")
deathEffectAssert(entrySplash.entity == 0 and entrySplash.hasEntity,
  "water entry splash is associated with the stock world entity")
deathEffectAssert(entrySplash.position.x == movingMetalGib.oldOrigin.x and
  entrySplash.position.z == movingMetalGib.oldOrigin.z,
  "water entry splash uses the pre-move origin")
waterSteadySound = server.pendingSoundCount
api.runFrame()
deathEffectAssert(server.pendingSoundCount == waterSteadySound and
  movingMetalGib.waterLevel == 1,
  "remaining in water does not repeat the transition splash")

destroyedGib = void
for each candidateGib in runtime.world.entities
  if destroyedGib is void and candidateGib.className == "monster_gib" and candidateGib.inUse then
    destroyedGib = candidateGib
  end if
end for
deathEffectAssert(destroyedGib is not void and
  deatheffectintegration.damageWorldEntity(runtime, destroyedGib.number, void, 1) and
  not destroyedGib.inUse and deathEffectWorldGibs(runtime, true) == 18,
  "shot monster gib runs stock gib_die callback")

deathEffectSavePath = "gameplay_monster_death_effects_tests.sav"
if deatheffectfs.exists(deathEffectSavePath) then deatheffectfs.delete(deathEffectSavePath) end if
api.writeLevel(deathEffectSavePath)
for each mutatedGib in runtime.world.entities
  if mutatedGib.className == "monster_gib" then mutatedGib.inUse = false; mutatedGib.model = "mutated" end if
end for
api.readLevel(deathEffectSavePath)
runtime = deatheffectgame.baseRuntime()
deathEffectAssert(deathEffectWorldGibs(runtime, true) == 18 and
  deathEffectModelCount(runtime, "models/objects/gibs/sm_metal/tris.md2") == 8,
  "private save v17 restores active gib records and models")

restoredWaterGib = deatheffectworld.findByNumber(runtime.world, waterGibNumber)
deathEffectAssert(restoredWaterGib is not void and
  restoredWaterGib.waterType == deatheffectqconstants.CONTENTS_WATER and
  restoredWaterGib.waterLevel == 1,
  "private save v17 restores toss water transition state")
waterRestoreSound = server.pendingSoundCount
api.runFrame()
deathEffectAssert(server.pendingSoundCount == waterRestoreSound,
  "restored entity already in water does not replay entry splash")
deathEffectWaterEnabled = false
api.runFrame()
deathEffectAssert(restoredWaterGib.waterType == 0 and restoredWaterGib.waterLevel == 0 and
  server.pendingSoundCount == waterRestoreSound + 1 and
  server.soundNames[server.pendingSounds[waterRestoreSound].soundIndex] ==
    "misc/h2ohit1.wav",
  "water exit clears state and queues one positioned stock splash")

restoredGib = void
for each candidateGib in runtime.world.entities
  if restoredGib is void and candidateGib.className == "monster_gib" and candidateGib.inUse then
    restoredGib = candidateGib
  end if
end for
deathEffectAssert(restoredGib is not void and
  deatheffectintegration.damageWorldEntity(runtime, restoredGib.number, void, 1) and
  not restoredGib.inUse and deathEffectWorldGibs(runtime, true) == 17,
  "private restore reconstructs stock gib_die callback")

deatheffectworld.advance(runtime.world, runtime.world.time + 20.0)
deatheffectintegration.syncGameEdicts(runtime, api)
deathEffectAssert(deathEffectWorldGibs(runtime, true) == 0, "managed gib lifetime expires")
for each expiredGib in runtime.world.entities
  if expiredGib.className == "monster_gib" then
    deathEffectAssert(api.edicts[expiredGib.number].inUse == false, "expired gib leaves Protocol snapshot")
  end if
end for

api.shutdown()
deatheffectfs.delete(deathEffectSavePath)
print "gameplay_monster_death_effects_tests: PASS"
