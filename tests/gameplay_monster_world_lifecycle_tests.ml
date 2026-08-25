/* Exact g_monster.c world-effect, corpse-fly and trigger-spawn lifecycle tests. */
import miniquake2.game.ai.archetypes as lifecyclearchetypes
import miniquake2.game.ai.constants as lifecycleconstants
import miniquake2.game.ai.monster as lifecyclemonster
import miniquake2.game.ai.types as lifecycletypes
import miniquake2.game.constants as lifecyclegameconstants
import miniquake2.qcommon.constants as lifecycleqconstants

lifecycleDamageCount = 0
lifecycleLastDamage = 0
lifecycleLastDamageFlags = 0
lifecycleLastMod = 0
lifecycleSounds = []
lifecycleRandomValues = []
lifecycleRandomIndex = 0
lifecycleKillBoxes = 0
lifecycleLinks = 0
lifecycleTargets = []
lifecycleLogs = []

function lifecycleAssert(value, message)
  if value != true then return error(9890, message) end if
  return true
end function

function lifecycleDamage(actor, amount, flags, meansOfDeath)
  global lifecycleDamageCount, lifecycleLastDamage, lifecycleLastDamageFlags, lifecycleLastMod
  lifecycleDamageCount = lifecycleDamageCount + 1
  lifecycleLastDamage = amount
  lifecycleLastDamageFlags = flags
  lifecycleLastMod = meansOfDeath
  actor.health = actor.health - amount
  return amount
end function

function lifecyclePlaySound(actor, soundName, channel, attenuation)
  global lifecycleSounds
  lifecycleSounds = lifecycleSounds + [soundName]
  return true
end function

function lifecycleSoundIndex(soundName)
  if soundName == "infantry/inflies1.wav" then return 91 end if
  return 0
end function

function lifecycleRandom()
  global lifecycleRandomValues, lifecycleRandomIndex
  if lifecycleRandomIndex >= len(lifecycleRandomValues) then return 0.0 end if
  value = lifecycleRandomValues[lifecycleRandomIndex]
  lifecycleRandomIndex = lifecycleRandomIndex + 1
  return value
end function

function lifecycleKillBox(actor)
  global lifecycleKillBoxes
  lifecycleKillBoxes = lifecycleKillBoxes + 1
  return true
end function

function lifecycleLink(actor)
  global lifecycleLinks
  lifecycleLinks = lifecycleLinks + 1
  return true
end function

function lifecycleFindTargets(targetName)
  global lifecycleTargets
  return lifecycleTargets
end function

function lifecyclePickTarget(targetName)
  global lifecycleTargets
  if len(lifecycleTargets) == 0 then return void end if
  return lifecycleTargets[0]
end function

function lifecycleLog(message)
  global lifecycleLogs
  lifecycleLogs = lifecycleLogs + [message]
  return true
end function

function lifecycleContext()
  context = lifecycletypes.defaultContext()
  context.damage = lifecycleDamage
  context.playSound = lifecyclePlaySound
  context.soundIndex = lifecycleSoundIndex
  context.nextRandomUnit = lifecycleRandom
  context.killBox = lifecycleKillBox
  context.linkActor = lifecycleLink
  context.findTargets = lifecycleFindTargets
  context.pickTarget = lifecyclePickTarget
  context.log = lifecycleLog
  return context
end function

function resetDamage()
  global lifecycleDamageCount, lifecycleLastDamage, lifecycleLastDamageFlags, lifecycleLastMod
  lifecycleDamageCount = 0
  lifecycleLastDamage = 0
  lifecycleLastDamageFlags = 0
  lifecycleLastMod = 0
  return true
end function

function testWorldEffects()
  global lifecycleSounds
  context = lifecycleContext()
  actor = lifecycletypes.createActor(1, "monster_infantry")
  context.time = 5.0
  lifecyclemonster.M_WorldEffects(actor, context)
  lifecycleAssert(actor.airFinished == 17.0, "dry walking monster receives twelve seconds of air")

  resetDamage()
  context.time = 20.0
  actor.waterLevel = 3
  actor.waterType = lifecycleqconstants.CONTENTS_WATER
  actor.airFinished = 15.0
  actor.painDebounceTime = 0.0
  lifecyclemonster.M_WorldEffects(actor, context)
  lifecycleAssert(lifecycleDamageCount == 1 and lifecycleLastDamage == 12 and
    lifecycleLastDamageFlags == lifecycleconstants.DAMAGE_NO_ARMOR and
    lifecycleLastMod == lifecycleconstants.MOD_WATER,
    "drowning ramps by two damage per overdue second")
  lifecycleAssert(actor.painDebounceTime == 21.0, "drowning damage is one-second debounced")
  lifecyclemonster.M_WorldEffects(actor, context)
  lifecycleAssert(lifecycleDamageCount == 1, "drowning debounce blocks a duplicate tick")

  resetDamage()
  swimmer = lifecycletypes.createActor(2, "monster_flipper")
  swimmer.flags = swimmer.flags | lifecycleconstants.FL_SWIM
  swimmer.waterLevel = 0
  swimmer.airFinished = 2.0
  context.time = 6.0
  lifecyclemonster.M_WorldEffects(swimmer, context)
  lifecycleAssert(lifecycleDamageCount == 1 and lifecycleLastDamage == 10 and
    lifecycleLastMod == lifecycleconstants.MOD_WATER,
    "swimming monster suffocates outside water")
  swimmer.waterLevel = 1
  context.time = 7.0
  lifecyclemonster.M_WorldEffects(swimmer, context)
  lifecycleAssert(swimmer.airFinished == 16.0, "swimming monster receives nine seconds of air in water")

  resetDamage()
  lifecycleSounds = []
  lava = lifecycletypes.createActor(3, "monster_gunner")
  lava.waterLevel = 2
  lava.waterType = lifecycleqconstants.CONTENTS_LAVA
  lava.airFinished = 20.0
  context.time = 1.0
  lifecyclemonster.M_WorldEffects(lava, context)
  lifecycleAssert(lifecycleDamageCount == 1 and lifecycleLastDamage == 20 and
    lifecycleLastMod == lifecycleconstants.MOD_LAVA,
    "lava deals ten damage per water level")
  lifecycleAssert((lava.flags & lifecycleconstants.FL_INWATER) != 0 and
    len(lifecycleSounds) == 1, "first liquid entry sets flag and emits sound")
  lava.waterLevel = 0
  context.time = 1.1
  lifecyclemonster.M_WorldEffects(lava, context)
  lifecycleAssert((lava.flags & lifecycleconstants.FL_INWATER) == 0 and
    lifecycleSounds[len(lifecycleSounds) - 1] == "player/watr_out.wav",
    "liquid exit clears flag and emits stock exit sound")

  resetDamage()
  slime = lifecycletypes.createActor(4, "monster_gunner")
  slime.waterLevel = 3
  slime.waterType = lifecycleqconstants.CONTENTS_SLIME
  slime.airFinished = 20.0
  slime.flags = slime.flags | lifecycleconstants.FL_IMMUNE_SLIME
  context.time = 2.0
  lifecyclemonster.M_WorldEffects(slime, context)
  lifecycleAssert(lifecycleDamageCount == 0, "slime immunity suppresses environmental damage")
  slime.flags = slime.flags & ~lifecycleconstants.FL_IMMUNE_SLIME
  context.time = 2.1
  lifecyclemonster.M_WorldEffects(slime, context)
  lifecycleAssert(lifecycleDamageCount == 1 and lifecycleLastDamage == 12 and
    lifecycleLastMod == lifecycleconstants.MOD_SLIME,
    "slime deals four damage per water level")
  return true
end function

function testCorpseFliesAndEffects()
  global lifecycleRandomValues, lifecycleRandomIndex
  context = lifecycleContext()
  context.time = 5.0
  lifecycleRandomValues = [0.4, 0.3]
  lifecycleRandomIndex = 0
  corpse = lifecycletypes.createActor(5, "monster_infantry")
  corpse.health = 0
  lifecycleAssert(lifecyclemonster.M_FlyCheck(corpse, context), "dry corpse schedules flies")
  lifecycleAssert(corpse.thinkKind == "flies-on" and corpse.nextThink == 13.0,
    "fly check preserves stock five-plus-random delay")
  context.time = 13.0
  lifecyclemonster.MonsterThink(corpse, context)
  lifecycleAssert((corpse.edict.state.effects & lifecyclegameconstants.EF_FLIES) != 0 and
    corpse.edict.state.sound == 91 and corpse.thinkKind == "flies-off" and
    corpse.nextThink == 73.0, "flies enable looping effect and sixty-second removal")
  context.time = 73.0
  lifecyclemonster.MonsterThink(corpse, context)
  lifecycleAssert((corpse.edict.state.effects & lifecyclegameconstants.EF_FLIES) == 0 and
    corpse.edict.state.sound == 0 and corpse.nextThink == 0.0,
    "flies-off clears both network effect and loop sound")

  powered = lifecycletypes.createActor(6, "monster_brain")
  powered.powerArmorType = lifecycleconstants.POWER_ARMOR_SCREEN
  powered.powerArmorTime = 8.0
  context.time = 7.9
  lifecyclemonster.M_SetEffects(powered, context)
  lifecycleAssert((powered.edict.state.effects & lifecyclegameconstants.EF_POWERSCREEN) != 0,
    "active screen armor projects EF_POWERSCREEN")
  powered.powerArmorType = lifecycleconstants.POWER_ARMOR_SHIELD
  lifecyclemonster.M_SetEffects(powered, context)
  lifecycleAssert((powered.edict.state.effects & lifecyclegameconstants.EF_COLOR_SHELL) != 0 and
    (powered.edict.state.renderFx & lifecyclegameconstants.RF_SHELL_GREEN) != 0,
    "active shield armor projects green shell")
  context.time = 8.0
  lifecyclemonster.M_SetEffects(powered, context)
  lifecycleAssert((powered.edict.state.effects &
    (lifecyclegameconstants.EF_COLOR_SHELL | lifecyclegameconstants.EF_POWERSCREEN)) == 0,
    "expired power-armor flash is cleared")
  return true
end function

function testTriggeredSpawnLifecycle()
  global lifecycleKillBoxes, lifecycleLinks, lifecycleTargets
  lifecycleKillBoxes = 0
  lifecycleLinks = 0
  lifecycleTargets = []
  context = lifecycleContext()
  context.time = 2.0
  actor = lifecycletypes.createActor(7, "monster_infantry")
  lifecyclemonster.installDefaultCallbacks(actor, true, false)
  actor.info.currentMove = lifecyclearchetypes.idleMove()
  actor.spawnFlags = lifecycleconstants.SPAWNFLAG_TRIGGER_SPAWN
  lifecycleAssert(lifecyclemonster.WalkMonsterStart(actor, context), "trigger monster starts")
  lifecycleAssert(actor.thinkKind == "triggered-wait" and
    actor.edict.solid == lifecyclegameconstants.SOLID_NOT and
    (actor.edict.serverFlags & lifecyclegameconstants.SVF_NOCLIENT) != 0,
    "triggered start makes monster non-solid and invisible")

  activator = lifecycletypes.createClientTarget(8)
  lifecyclemonster.MonsterTargetUse(actor, void, activator, context)
  lifecycleAssert(actor.thinkKind == "triggered-spawn" and actor.nextThink == 2.1 and
    nativeRawValue(actor.enemy) == nativeRawValue(activator),
    "client activator is retained across one-frame spawn delay")
  context.time = 2.1
  lifecyclemonster.MonsterThink(actor, context)
  lifecycleAssert(lifecycleKillBoxes == 1 and lifecycleLinks == 1,
    "triggered spawn performs KillBox and relinks")
  lifecycleAssert(actor.edict.state.origin.z == 1.0 and
    actor.edict.solid == lifecyclegameconstants.SOLID_BBOX and
    actor.moveType == lifecycleconstants.MOVETYPE_STEP and
    (actor.edict.serverFlags & lifecyclegameconstants.SVF_NOCLIENT) == 0,
    "triggered spawn restores stock origin, solid, movement and visibility")
  lifecycleAssert(actor.airFinished == 14.1 and actor.thinkKind == "monster-think" and
    actor.nextThink == 2.2, "triggered spawn restarts normal monster scheduling")
  lifecycleAssert(nativeRawValue(actor.enemy) == nativeRawValue(activator),
    "non-ambush triggered monster wakes against client activator")
  return true
end function

function testCombatPointNormalization()
  global lifecycleTargets, lifecycleLogs
  context = lifecycleContext()
  point = lifecycletypes.createActor(9, "point_combat")
  path = lifecycletypes.createActor(10, "path_corner")
  lifecycleTargets = [point, path]
  lifecycleLogs = []
  actor = lifecycletypes.createActor(11, "monster_gunner")
  lifecyclemonster.installDefaultCallbacks(actor, true, false)
  actor.info.currentMove = lifecyclearchetypes.idleMove()
  actor.target = "mixed_route"
  lifecyclemonster.MonsterStartGo(actor, context)
  lifecycleAssert(actor.target == "" and actor.combatTarget == "mixed_route",
    "point_combat target is promoted to combattarget")
  lifecycleAssert(len(lifecycleLogs) == 2,
    "mixed target and invalid combattarget entries both log diagnostics")

  lifecycleTargets = [point]
  lifecycleLogs = []
  valid = lifecycletypes.createActor(12, "monster_gunner")
  lifecyclemonster.installDefaultCallbacks(valid, true, false)
  valid.info.currentMove = lifecyclearchetypes.idleMove()
  valid.combatTarget = "combat_only"
  lifecyclemonster.MonsterStartGo(valid, context)
  lifecycleAssert(len(lifecycleLogs) == 0 and valid.combatTarget == "combat_only",
    "valid combat target remains unchanged")

  brain = lifecyclearchetypes.SpawnMonster(
    lifecyclearchetypes.defaultRegistry(), "monster_brain", 13, context)
  lifecycleAssert(brain.powerArmorType == lifecycleconstants.POWER_ARMOR_SCREEN and
    brain.powerArmorPower == 100, "Brain spawns with stock screen armor capacity")
  return true
end function

testWorldEffects()
testCorpseFliesAndEffects()
testTriggeredSpawnLifecycle()
testCombatPointNormalization()
print "gameplay_monster_world_lifecycle_tests: PASS"
