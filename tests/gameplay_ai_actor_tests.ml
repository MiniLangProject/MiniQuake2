/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Exact m_actor.c lifecycle, route, burst, taunt and gib goldens. */
import miniquake2.game.ai.actor as actortestactor
import miniquake2.game.ai.archetypes as actortestarchetypes
import miniquake2.game.ai.attack_sequences as actortestattacks
import miniquake2.game.ai.constants as actortestconstants
import miniquake2.game.ai.monster as actortestmonster
import miniquake2.game.ai.types as actortesttypes
import miniquake2.game.base.spawn as actortestspawn
import miniquake2.game.constants as actortestgameconstants

actorTestChat = ""
actorTestGibs = []
actorTestRandomUnits = [0.2, 0.2]
actorTestRandomUnitIndex = 0
actorTestRandomInteger = 1

// Assert the actor test test condition.
function actorTestAssert(value, message)
  if value != true then return error(9838, message) end if
  return true
end function

// Report whether actor test equal.
function actorTestEqual(actual, expected, message)
  if actual != expected then
    return error(9839, message + ": expected " + expected + ", got " + actual)
  end if
  return true
end function

// Verify actor pick target.
function actorTestPickTarget(targetName)
  if targetName != "route-1" then return void end if
  target = actortesttypes.createActor(90, "target_actor")
  target.isMonster = false
  target.edict.state.origin.x = 128.0
  return target
end function

// Verify actor chat callback.
function actorTestChatCallback(actor, message)
  global actorTestChat
  actorTestChat = message
  return true
end function

// Verify actor death effect.
function actorTestDeathEffect(actor, effect)
  global actorTestGibs
  if effect.kind == "gib" then actorTestGibs = actorTestGibs + [effect.modelName] end if
  return true
end function

// Verify actor next unit.
function actorTestNextUnit()
  global actorTestRandomUnits, actorTestRandomUnitIndex
  value = actorTestRandomUnits[actorTestRandomUnitIndex]
  actorTestRandomUnitIndex = actorTestRandomUnitIndex + 1
  return value
end function

// Verify actor next integer.
function actorTestNextInteger()
  global actorTestRandomInteger
  return actorTestRandomInteger
end function

// Verify actor context.
function actorTestContext()
  context = actortesttypes.defaultContext()
  context.time = 0.5
  context.randomFrame = 3
  context.pickTarget = actorTestPickTarget
  context.actorChat = actorTestChatCallback
  context.deathEffect = actorTestDeathEffect
  context.nextRandomUnit = actorTestNextUnit
  context.nextRandomInteger = actorTestNextInteger
  return context
end function

registry = actortestarchetypes.defaultRegistry()
actorTestAssert(actortestarchetypes.validate(registry), "actor campaign registry validates")
definition = actortestarchetypes.find(registry, "misc_actor")
actorTestAssert(definition is not void, "misc_actor has a real AI archetype")
actorTestEqual(definition.model, "players/male/tris.md2", "actor model")
actorTestEqual(definition.health, 100, "actor health")
actorTestEqual(definition.gibHealth, -80, "actor gib threshold")
actorTestEqual(definition.mass, 200, "actor mass")
modeFixture = "{\"classname\" \"worldspawn\"}" +
  "{\"classname\" \"misc_actor\" \"targetname\" \"start\" " +
    "\"target\" \"route\"}"
deathmatchSpawn = actortestspawn.SpawnEntitiesForMode("actor-dm", modeFixture,
  "", 1, true)
actorTestEqual(deathmatchSpawn.inhibitedEntityCount, 1,
  "SP_misc_actor deathmatch gate")
actorTestEqual(len(deathmatchSpawn.edicts), 1,
  "deathmatch actor consumes no live edict")

context = actorTestContext()
actor = actortestarchetypes.SpawnMonster(registry, "misc_actor", 8, context)
actorTestAssert((actor.info.aiFlags & actortestconstants.AI_GOOD_GUY) != 0,
  "actor carries AI_GOOD_GUY")
actorTestEqual(actor.info.currentMove.name, "actor-stand", "actor starts dormant")
actorTestEqual(actor.info.currentMove.firstFrame, 128, "stand first frame")
actorTestEqual(actor.info.currentMove.lastFrame, 167, "stand last frame")
actorTestAssert(typeof(actor.info.attack) == "function" and
  actor.info.melee is void and actor.info.sight is void, "actor callback surface")

actor.target = "route-1"
actor.targetName = "actor-start"
actortestmonster.MonsterStartGo(actor, context)
actorTestEqual(actor.info.currentMove.name, "actor-stand", "target does not auto-start actor")
actorTestAssert(actor.moveTarget is void, "dormant actor has no route before use")
actorTestAssert(actortestmonster.MonsterTargetUse(actor, void, void, context),
  "targeted use starts actor")
actorTestEqual(actor.info.currentMove.name, "actor-walk", "use installs walk table")
actorTestEqual(actor.info.currentMove.firstFrame, 251, "walk first frame")
actorTestEqual(actor.info.currentMove.lastFrame, 258, "walk last frame")
actorTestEqual(actor.target, "", "one-shot route target consumed")
actorTestEqual(actor.edict.state.angles.y, 0.0, "route-facing yaw")

actorTestRandomInteger = 1
actorTestChat = ""
attacker = actortesttypes.createClientTarget(1)
attacker.edict.state.origin.y = 64.0
actor.health = 49
context.time = 5.0
actorTestAssert(actortestmonster.DispatchPain(actor, attacker, 12, context),
  "client pain taunt dispatch")
actorTestEqual(actor.edict.state.skinNumber, 1, "below-half damaged skin")
actorTestEqual(actor.info.currentMove.name, "actor-flipoff", "random flipoff move")
actorTestEqual(actorTestChat, "#$@*&", "stock rand modulo-three taunt")
actorTestEqual(actor.idealYaw, 90.0, "pain taunt faces attacker")
actorTestEqual(actortestmonster.DispatchPain(actor, attacker, 1, context), false,
  "three-second pain debounce")

burst10 = actortestattacks.actorMachinegunPlan(0)
burst25 = actortestattacks.actorMachinegunPlan(15)
actorTestEqual(len(burst10.frameOffsets), 10, "minimum actor burst")
actorTestEqual(len(burst25.frameOffsets), 25, "maximum actor burst")
actorTestEqual(burst25.muzzleFlashes[0], 63, "MZ2 actor muzzle flash")
actorTestEqual(actortestattacks.modelFrameAt(burst25, 24), 0,
  "held attack01 through final shot")
actorTestEqual(actortestattacks.modelFrameAt(burst25, 25), 1,
  "attack tail frame two")
actorTestEqual(actortestattacks.modelFrameAt(burst25, 27), 3,
  "attack tail frame four")
actorTestEqual(actortestattacks.movementDistanceAt(burst25, 24), -2.0,
  "held-frame charge distance")
actorTestEqual(actortestattacks.movementDistanceAt(burst25, 26), 3.0,
  "attack tail forward distance")

actorTestRandomInteger = 0
actor.health = 0
actorTestAssert(actortestmonster.DispatchDie(actor, attacker, 49, context),
  "regular actor death")
actorTestEqual(actor.info.currentMove.name, "actor-death1", "death animation one")
actor.edict.state.frame = actor.info.currentMove.lastFrame
actortestmonster.M_MoveFrame(actor, context)
actorTestEqual(actor.activity, "actor-dead", "death reaches corpse")
actorTestEqual(actor.moveType, actortestconstants.MOVETYPE_TOSS, "corpse toss movetype")
actorTestEqual(actor.edict.maxs.z, -8.0, "corpse height")
actorTestAssert((actor.edict.serverFlags & actortestgameconstants.SVF_DEADMONSTER) != 0,
  "dead-monster server flag")

actorTestGibs = []
actor.health = -81
actorTestAssert(actortestmonster.DispatchDie(actor, attacker, 100, context),
  "corpse crosses actor gib threshold")
actorTestEqual(len(actorTestGibs), 7, "two bone, four meat and one head gib")
actorTestEqual(actorTestGibs[0], "models/objects/gibs/bone/tris.md2", "first bone gib")
actorTestEqual(actorTestGibs[2], "models/objects/gibs/sm_meat/tris.md2", "first meat gib")
actorTestEqual(actorTestGibs[6], "models/objects/gibs/head2/tris.md2", "head2 gib")
actorTestAssert(actor.edict.inUse == false and actor.takeDamage == 0,
  "gibbed source actor leaves targeting")

print("gameplay_ai_actor_tests: PASS")
