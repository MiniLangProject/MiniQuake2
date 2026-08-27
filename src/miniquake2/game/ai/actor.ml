/*
Copyright (C) 1997-2001 Id Software, Inc.
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Stock Quake II 3.19 misc_actor state machine from game/m_actor.c. */
package miniquake2.game.ai.actor

import miniquake2.game.ai.constants as actorconstants
import miniquake2.game.ai.core as actorcore
import miniquake2.game.ai.death_effects as actordeatheffects
import miniquake2.game.ai.types as actortypes
import miniquake2.game.constants as actorgameconstants
import miniquake2.qcommon.types as actorqtypes

actorWalkDistances = [0.0, 6.0, 10.0, 3.0, 2.0, 7.0, 10.0, 1.0]
actorRunDistances = [4.0, 15.0, 15.0, 8.0, 20.0, 15.0]
actorPain1Distances = [-5.0, 4.0, 1.0]
actorPain2Distances = [-4.0, 4.0, 0.0]
actorPain3Distances = [-1.0, 1.0, 0.0]
actorDeath1Distances = [0.0, 0.0, -13.0, 14.0, 3.0, -2.0, 1.0]
actorDeath2Distances = [0.0, 7.0, -6.0, -5.0, 1.0, 0.0, -1.0,
  -2.0, -1.0, -9.0, -13.0, -13.0, 0.0]

// Return the actor random unit value.
function actorRandomUnit(context, fallback)
  if typeof(context.nextRandomUnit) == "function" then return context.nextRandomUnit() end if
  return fallback
end function

// Return the actor random integer value.
function actorRandomInteger(context, fallback)
  if typeof(context.nextRandomInteger) == "function" then return context.nextRandomInteger() end if
  return fallback
end function

// Create actor move.
function actorMakeMove(name, firstFrame, lastFrame, aiFunction, distances,
    endFunction)
  frameCount = lastFrame - firstFrame + 1
  frames = array(frameCount)
  frameIndex = 0
  while frameIndex < frameCount
    distance = 0.0
    if distances is not void and frameIndex < len(distances) then
      distance = distances[frameIndex]
    end if
    frames[frameIndex] = actortypes.MonsterFrame(aiFunction, distance, void)
    frameIndex = frameIndex + 1
  end while
  return actortypes.MonsterMove(name, firstFrame, lastFrame, frames, endFunction)
end function

// Move actor stand.
function actorStandMove()
  return actorMakeMove("actor-stand", 128, 167, actorcore.ai_stand, void,
    void)
end function

// Move actor walk.
function actorWalkMove()
  // m_actor.c declares eleven frame records but bounds actor_move_walk to
  // FRAME_walk01..FRAME_walk08. M_MoveFrame therefore consumes exactly the
  // first eight distances, which are preserved here.
  return actorMakeMove("actor-walk", 251, 258, actorcore.ai_walk,
    actorWalkDistances, void)
end function

// Run actor move.
function actorRunMove()
  // The original table likewise bounds its twelve records to run02..run07.
  return actorMakeMove("actor-run", 93, 98, actorcore.ai_run,
    actorRunDistances, void)
end function

// Handle actor move.
function actorPainMove(variant)
  if variant == 0 then
    return actorMakeMove("actor-pain1", 74, 76, actorcore.ai_move,
      actorPain1Distances, actorRun)
  end if
  if variant == 1 then
    return actorMakeMove("actor-pain2", 77, 79, actorcore.ai_move,
      actorPain2Distances, actorRun)
  end if
  return actorMakeMove("actor-pain3", 80, 82, actorcore.ai_move,
    actorPain3Distances, actorRun)
end function

// Move actor taunt.
function actorTauntMove(flipOff)
  if flipOff then
    return actorMakeMove("actor-flipoff", 39, 52, actorcore.ai_turn,
      void, actorRun)
  end if
  return actorMakeMove("actor-taunt", 234, 250, actorcore.ai_turn,
    void, actorRun)
end function

// Move actor death.
function actorDeathMove(variant)
  if variant == 0 then
    return actorMakeMove("actor-death1", 4, 10, actorcore.ai_move,
      actorDeath1Distances, actorDead)
  end if
  return actorMakeMove("actor-death2", 11, 23, actorcore.ai_move,
    actorDeath2Distances, actorDead)
end function

// Set actor move.
function actorSetMove(actor, move)
  actor.info.currentMove = move
  actor.activity = move.name
  actor.thinkKind = "monster-think"
  return move
end function

// Return the actor stand value.
function actorStand(actor, context)
  move = actorSetMove(actor, actorStandMove())
  if context.time < 1.0 then
    actor.edict.state.frame = move.firstFrame +
      (actorRandomInteger(context, context.randomFrame) %
        (move.lastFrame - move.firstFrame + 1))
  end if
  return move
end function

// Return the actor walk value.
function actorWalk(actor, context)
  return actorSetMove(actor, actorWalkMove())
end function

// Run actor.
function actorRun(actor, context)
  if context.time < actor.reactionDebounce and actor.enemy is void then
    if actor.moveTarget is not void then return actorWalk(actor, context) end if
    return actorStand(actor, context)
  end if
  if (actor.info.aiFlags & actorconstants.AI_STAND_GROUND) != 0 then
    return actorStand(actor, context)
  end if
  return actorSetMove(actor, actorRunMove())
end function

// Run actor.
function actorAttack(actor, context)
  // The integrated combat timeline owns actor_move_attack's held first frame
  // and machine-gun events. This callback retains the stock attack counter.
  actor.activity = "attack"
  actor.attackCount = actor.attackCount + 1
  return true
end function

// Use actor.
function actorUse(actor, other, activator, context)
  actor.goalEntity = context.pickTarget(actor.target)
  actor.moveTarget = actor.goalEntity
  if actor.moveTarget is void or actor.moveTarget.className != "target_actor" then
    if typeof(context.log) == "function" then
      context.log("misc_actor has bad target " + actor.target)
    end if
    actor.target = ""
    actor.info.pauseTime = 100000000.0
    actorStand(actor, context)
    return false
  end if
  actor.idealYaw = actorcore.vectorToYaw(
    actorcore.directionTo(actor, actor.goalEntity))
  actorcore.setActorYaw(actor, actor.idealYaw)
  actorWalk(actor, context)
  // Actors are single-start scripted entities. Their route is subsequently
  // owned by target_actor.target, not by the spawn entity's original target.
  actor.target = ""
  return true
end function

// Handle actor.
function actorPain(actor, attacker, damage, context)
  actor.painCount = actor.painCount + 1
  actor.reactionDebounce = context.time + 3.0

  if attacker is not void and attacker.isClient and
      actorRandomUnit(context, context.randomAttack) < 0.4 then
    actor.idealYaw = actorcore.vectorToYaw(actorcore.directionTo(actor, attacker))
    flipOff = actorRandomUnit(context, context.randomIdle) < 0.5
    actorSetMove(actor, actorTauntMove(flipOff))
    messageRoll = actorRandomInteger(context, context.randomFrame) % 3
    message = "Watch it"
    if messageRoll == 1 then message = "#$@*&"
    else if messageRoll == 2 then message = "Idiot" end if
    // m_actor.c declares a fourth message but selects rand()%3, so
    // "Check your targets" is intentionally unreachable.
    if typeof(context.actorChat) == "function" then
      context.actorChat(actor, message)
    end if
    return true
  end if

  variant = actorRandomInteger(context, context.randomFrame) % 3
  actorSetMove(actor, actorPainMove(variant))
  return true
end function

// Return the actor dead value.
function actorDead(actor, context)
  actor.mins = [-16.0, -16.0, -24.0]
  actor.maxs = [16.0, 16.0, -8.0]
  actor.edict.mins = actorqtypes.Vec3(-16.0, -16.0, -24.0)
  actor.edict.maxs = actorqtypes.Vec3(16.0, 16.0, -8.0)
  actor.moveType = actorconstants.MOVETYPE_TOSS
  actor.edict.serverFlags = actor.edict.serverFlags |
    actorgameconstants.SVF_DEADMONSTER
  actor.nextThink = 0.0
  actor.activity = "actor-dead"
  actor.thinkKind = "none"
  if context is not void and typeof(context.linkActor) == "function" then
    context.linkActor(actor)
  end if
  return true
end function

// Handle actor.
function actorDie(actor, attacker, damage, context)
  if actor.health <= -80 then
    emitted = actordeatheffects.emitMonsterGibs(actor, damage, context)
    if emitted is error then return emitted end if
    actor.deadFlag = actorconstants.DEAD_DEAD
    actor.dieCount = actor.dieCount + 1
    actor.takeDamage = 0
    actor.edict.inUse = false
    actor.nextThink = 0.0
    actor.activity = "actor-gibbed"
    actor.thinkKind = "none"
    return true
  end if
  if actor.deadFlag == actorconstants.DEAD_DEAD then return false end if
  actor.deadFlag = actorconstants.DEAD_DEAD
  actor.takeDamage = 1
  actor.dieCount = actor.dieCount + 1
  variant = actorRandomInteger(context, context.randomFrame) % 2
  actorSetMove(actor, actorDeathMove(variant))
  return true
end function

// Configure state.
function configure(actor, context)
  actor.info.aiFlags = actor.info.aiFlags | actorconstants.AI_GOOD_GUY
  actor.info.stand = actorStand
  actor.info.idle = void
  actor.info.search = void
  actor.info.walk = actorWalk
  actor.info.run = actorRun
  actor.info.dodge = void
  actor.info.attack = actorAttack
  actor.info.melee = void
  actor.info.sight = void
  actor.pain = actorPain
  actor.die = actorDie
  actorSetMove(actor, actorStandMove())
  return actor
end function

// Restore move.
function restoreMove(actor, moveName)
  if moveName == "actor-stand" then actor.info.currentMove = actorStandMove()
  else if moveName == "actor-walk" then actor.info.currentMove = actorWalkMove()
  else if moveName == "actor-run" then actor.info.currentMove = actorRunMove()
  else if moveName == "actor-pain1" then actor.info.currentMove = actorPainMove(0)
  else if moveName == "actor-pain2" then actor.info.currentMove = actorPainMove(1)
  else if moveName == "actor-pain3" then actor.info.currentMove = actorPainMove(2)
  else if moveName == "actor-flipoff" then actor.info.currentMove = actorTauntMove(true)
  else if moveName == "actor-taunt" then actor.info.currentMove = actorTauntMove(false)
  else if moveName == "actor-death1" then actor.info.currentMove = actorDeathMove(0)
  else if moveName == "actor-death2" then actor.info.currentMove = actorDeathMove(1)
  else if moveName == "actor-dead" then actorDead(actor, void)
  else if moveName == "actor-gibbed" then
    actor.edict.inUse = false
    actor.takeDamage = 0
    actor.nextThink = 0.0
    actor.thinkKind = "none"
  else if moveName == "misc_actor-single" then
    // The attack plan is reconstructed by attack_sequences from persisted
    // nextFrame/attackCycles; the prior locomotion move is not advanced.
    actor.info.currentMove = actorRunMove()
  else return error(9657, "unknown misc_actor saved move " + moveName) end if
  actor.activity = moveName
  return actor
end function
