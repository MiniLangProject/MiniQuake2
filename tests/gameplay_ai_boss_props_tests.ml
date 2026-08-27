/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Classic boss3 stand and commander-body scripted prop goldens. */
import miniquake2.game.ai.archetypes as bossproptestarchetypes
import miniquake2.game.ai.constants as bossproptestconstants
import miniquake2.game.ai.monster as bossproptestmonster
import miniquake2.game.ai.types as bossproptesttypes
import miniquake2.game.constants as bossproptestgameconstants

bossPropTestSounds = []
bossPropTestTempEntities = []

// Assert the boss prop test test condition.
function bossPropTestAssert(value, message)
  if value != true then return error(9627, message) end if
  return true
end function

// Report whether boss prop test equal.
function bossPropTestEqual(actual, expected, message)
  if actual != expected then return error(9628, message + ": expected " + expected + ", got " + actual) end if
  return true
end function

// Verify boss prop sound.
function bossPropTestSound(actor, soundName, channel, attenuation)
  global bossPropTestSounds
  bossPropTestEqual(channel, bossproptestgameconstants.CHAN_BODY, "prop sound channel")
  bossPropTestEqual(attenuation, bossproptestgameconstants.ATTN_NORM, "prop sound attenuation")
  bossPropTestSounds = bossPropTestSounds + [soundName]
  return true
end function

// Verify boss prop temp entity.
function bossPropTestTempEntity(actor, effectType)
  global bossPropTestTempEntities
  bossPropTestTempEntities = bossPropTestTempEntities + [effectType]
  return true
end function

bossPropRegistry = bossproptestarchetypes.defaultRegistry()
bossPropContext = bossproptesttypes.defaultContext()
bossPropContext.time = 10.0
bossPropContext.playSound = bossPropTestSound
bossPropContext.tempEntity = bossPropTestTempEntity

bossStand = bossproptestarchetypes.SpawnMonster(bossPropRegistry, "monster_boss3_stand", 80, bossPropContext)
bossPropTestEqual(bossStand.model, "models/monsters/boss3/rider/tris.md2", "boss3 rider model")
bossPropTestAssert(bossStand.edict.mins.x == -32.0 and bossStand.edict.maxs.z == 90.0, "boss3 bounds")
bossPropTestEqual(bossStand.edict.state.frame, 414, "boss3 FRAME_stand201")
bossPropTestEqual(bossStand.activity, "boss3-stand", "boss3 initial phase")
bossStand.edict.state.frame = 473
bossPropContext.time = 10.1
bossPropTestAssert(bossproptestmonster.MonsterThink(bossStand, bossPropContext), "boss3 stand think")
bossPropTestEqual(bossStand.edict.state.frame, 414, "boss3 FRAME_stand260 wraps to stand201")
bossPropTestAssert(bossStand.nextThink > 10.19 and bossStand.nextThink < 10.21, "boss3 recurring think")
bossPropTestAssert(bossproptestmonster.MonsterUse(bossStand, void, void, bossPropContext), "boss3 use teleports")
bossPropTestEqual(bossPropTestTempEntities[0], bossproptestconstants.TE_BOSSTPORT, "boss teleport effect")
bossPropTestAssert(bossStand.edict.inUse == false and bossStand.activity == "boss3-teleported" and
  bossStand.nextThink == 0.0, "boss3 freed after teleport")
bossPropTestEqual(bossproptestmonster.MonsterUse(bossStand, void, void, bossPropContext), false,
  "boss3 teleport use is single-shot")

bossDeathmatchContext = bossproptesttypes.defaultContext()
bossDeathmatchContext.deathmatch = true
bossDeathmatchStand = bossproptestarchetypes.SpawnMonster(bossPropRegistry, "monster_boss3_stand", 81, bossDeathmatchContext)
bossPropTestAssert(bossDeathmatchStand.edict.inUse == false and bossDeathmatchStand.nextThink == 0.0,
  "boss3 inhibited in deathmatch")

commander = bossproptestarchetypes.SpawnMonster(bossPropRegistry, "monster_commander_body", 82, bossPropContext)
bossPropTestEqual(commander.model, "models/monsters/commandr/tris.md2", "commander model")
bossPropTestAssert(commander.edict.mins.x == -32.0 and commander.edict.maxs.z == 48.0, "commander bounds")
bossPropTestAssert((commander.flags & bossproptestconstants.FL_GODMODE) != 0 and commander.takeDamage == 1,
  "commander damageable godmode state")
bossPropTestAssert((commander.edict.state.renderFx & bossproptestgameconstants.RF_FRAMELERP) != 0,
  "commander frame lerp")
bossPropTestEqual(commander.moveType, bossproptestconstants.MOVETYPE_NONE, "commander starts fixed")
bossPropTestEqual(commander.activity, "commander-drop-wait", "commander delayed drop phase")
bossPropContext.time = 10.5
bossPropTestAssert(bossproptestmonster.MonsterThink(commander, bossPropContext), "commander drop think")
bossPropTestEqual(commander.moveType, bossproptestconstants.MOVETYPE_TOSS, "commander becomes toss entity")
bossPropTestEqual(commander.edict.state.origin.z, 2.0, "commander drop raises origin")
bossPropTestEqual(commander.nextThink, 0.0, "commander drop stops think")

bossPropTestSounds = []
bossPropTestAssert(bossproptestmonster.MonsterUse(commander, void, void, bossPropContext), "commander use starts animation")
bossPropTestEqual(bossPropTestSounds[0], "tank/pain.wav", "commander use pain sound")
bossPropTestEqual(commander.activity, "commander-animate", "commander animation phase")
commander.edict.state.frame = 21
bossPropContext.time = 10.6
bossPropTestAssert(bossproptestmonster.MonsterThink(commander, bossPropContext), "commander frame 22 think")
bossPropTestEqual(commander.edict.state.frame, 22, "commander thud frame")
bossPropTestEqual(bossPropTestSounds[1], "tank/thud.wav", "commander frame 22 thud")
commander.edict.state.frame = 23
bossPropContext.time = 10.7
bossPropTestAssert(bossproptestmonster.MonsterThink(commander, bossPropContext), "commander terminal frame think")
bossPropTestEqual(commander.edict.state.frame, 24, "commander terminal frame")
bossPropTestAssert(commander.nextThink == 0.0 and commander.activity == "commander-idle", "commander animation stops")
commander.health = -999
bossPropTestEqual(bossproptestmonster.DispatchDie(commander, void, 999, bossPropContext), false,
  "commander godmode prop has no die dispatch")
bossPropTestEqual(commander.health, commander.maxHealth, "commander godmode restores health")

print("gameplay_ai_boss_props_tests: PASS")
