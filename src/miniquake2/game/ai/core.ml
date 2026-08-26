/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Deterministic callback-based port of the central g_ai.c decisions. */
package miniquake2.game.ai.core

import miniquake2.game.ai.constants as gaiconstants
import miniquake2.game.ai.types as gaitypes
import miniquake2.qcommon.constants as gaiqconstants
import miniquake2.qcommon.types as gaiqtypes
import std.math as gaimath

aiRunCourseScratch = gaiqtypes.Vec3(0.0, 0.0, 0.0)

function vectorX(value)
  if typeof(value) == "struct" then return value.x end if
  return value[0]
end function

function vectorY(value)
  if typeof(value) == "struct" then return value.y end if
  return value[1]
end function

function vectorZ(value)
  if typeof(value) == "struct" then return value.z end if
  return value[2]
end function

function actorYaw(actor)
  return vectorY(actor.edict.state.angles)
end function

function setActorYaw(actor, value)
  if typeof(actor.edict.state.angles) == "struct" then actor.edict.state.angles.y = value
  else actor.edict.state.angles[1] = value
  end if
  return value
end function

function vectorLength(value)
  return gaimath.sqrt(value[0] * value[0] + value[1] * value[1] + value[2] * value[2])
end function

function vectorToYaw(value)
  yaw = gaimath.radToDeg(gaimath.atan2(value[1], value[0]))
  if yaw < 0.0 then yaw = yaw + 360.0 end if
  return yaw
end function

function inline scalarToYaw(x, y)
  yaw = gaimath.radToDeg(gaimath.atan2(y, x))
  if yaw < 0.0 then yaw = yaw + 360.0 end if
  return yaw
end function

function angleMod(value)
  result = value % 360.0
  if result < 0.0 then result = result + 360.0 end if
  return result
end function

function directionTo(first, second)
  return [
    vectorX(second.edict.state.origin) - vectorX(first.edict.state.origin),
    vectorY(second.edict.state.origin) - vectorY(first.edict.state.origin),
    vectorZ(second.edict.state.origin) - vectorZ(first.edict.state.origin)
  ]
end function

function inline copyOriginToArray(target, origin)
  target[0] = vectorX(origin)
  target[1] = vectorY(origin)
  target[2] = vectorZ(origin)
  return target
end function

function pursuitGoal(actor)
  if actor.pursuitGoal is void then
    actor.pursuitGoal = gaitypes.createActor(-1, "ai_pursuit_goal")
    actor.pursuitGoal.isMonster = false
    actor.pursuitGoal.viewHeight = 0.0
  end if
  return actor.pursuitGoal
end function

function range(first, second)
  distance = vectorLength(directionTo(first, second))
  if distance < gaiconstants.MELEE_DISTANCE then return gaiconstants.RANGE_MELEE end if
  if distance < 500.0 then return gaiconstants.RANGE_NEAR end if
  if distance < 1000.0 then return gaiconstants.RANGE_MID end if
  return gaiconstants.RANGE_FAR
end function

function infront(first, second)
  direction = directionTo(first, second)
  length = vectorLength(direction)
  if length == 0.0 then return true end if
  yawRadians = gaimath.degToRad(actorYaw(first))
  dot = (direction[0] / length) * gaimath.cos(yawRadians) + (direction[1] / length) * gaimath.sin(yawRadians)
  return dot > 0.3
end function

function visible(actor, other, context)
  if typeof(context.visible) != "function" then return error(9600, "visible callback is not installed") end if
  return context.visible(actor, other)
end function

function ChangeYaw(actor)
  current = angleMod(actorYaw(actor))
  ideal = angleMod(actor.idealYaw)
  move = ideal - current
  if ideal > current and move >= 180.0 then move = move - 360.0 end if
  if ideal < current and move <= -180.0 then move = move + 360.0 end if
  speed = actor.yawSpeed
  if move > speed then move = speed end if
  if move < -speed then move = -speed end if
  return setActorYaw(actor, angleMod(current + move))
end function

function walkMove(actor, yaw, distance, context)
  if typeof(context.walkMove) == "function" then return context.walkMove(actor, yaw, distance) end if
  radians = gaimath.degToRad(yaw)
  if typeof(actor.edict.state.origin) == "struct" then
    actor.edict.state.origin.x = actor.edict.state.origin.x + gaimath.cos(radians) * distance
    actor.edict.state.origin.y = actor.edict.state.origin.y + gaimath.sin(radians) * distance
  else
    actor.edict.state.origin[0] = actor.edict.state.origin[0] + gaimath.cos(radians) * distance
    actor.edict.state.origin[1] = actor.edict.state.origin[1] + gaimath.sin(radians) * distance
  end if
  return true
end function

function moveToGoal(actor, distance, context)
  if typeof(context.moveToGoal) == "function" then return context.moveToGoal(actor, distance) end if
  if actor.goalEntity is void then return false end if
  actor.idealYaw = vectorToYaw(directionTo(actor, actor.goalEntity))
  ChangeYaw(actor)
  return walkMove(actor, actorYaw(actor), distance, context)
end function

function ai_move(actor, distance, context)
  return walkMove(actor, actorYaw(actor), distance, context)
end function

function ai_stand(actor, distance, context)
  if distance != 0.0 then walkMove(actor, actorYaw(actor), distance, context) end if
  if (actor.info.aiFlags & gaiconstants.AI_STAND_GROUND) != 0 then
    if actor.enemy is not void then
      actor.idealYaw = vectorToYaw(directionTo(actor, actor.enemy))
      if actorYaw(actor) != actor.idealYaw and (actor.info.aiFlags & gaiconstants.AI_TEMP_STAND_GROUND) != 0 then
        actor.info.aiFlags = actor.info.aiFlags & ~(gaiconstants.AI_STAND_GROUND | gaiconstants.AI_TEMP_STAND_GROUND)
        if typeof(actor.info.run) == "function" then actor.info.run(actor, context) end if
      end if
      ChangeYaw(actor)
      ai_checkattack(actor, 0.0, context)
    else
      FindTarget(actor, context)
    end if
    return true
  end if
  if FindTarget(actor, context) then return true end if
  if context.time > actor.info.pauseTime then
    if typeof(actor.info.walk) == "function" then actor.info.walk(actor, context) end if
    return true
  end if
  if (actor.spawnFlags & gaiconstants.SPAWNFLAG_AMBUSH) == 0 and typeof(actor.info.idle) == "function" and context.time > actor.info.idleTime then
    actor.info.idle(actor, context)
    actor.info.idleTime = context.time + 15.0 + context.randomIdle * 15.0
  end if
  return true
end function

function ai_walk(actor, distance, context)
  moveToGoal(actor, distance, context)
  if FindTarget(actor, context) then return true end if
  if typeof(actor.info.search) == "function" and context.time > actor.info.idleTime then
    actor.info.search(actor, context)
    actor.info.idleTime = context.time + 15.0 + context.randomIdle * 15.0
  end if
  return true
end function

function ai_charge(actor, distance, context)
  if actor.enemy is void then return false end if
  actor.idealYaw = vectorToYaw(directionTo(actor, actor.enemy))
  ChangeYaw(actor)
  if distance != 0.0 then walkMove(actor, actorYaw(actor), distance, context) end if
  return true
end function

function ai_turn(actor, distance, context)
  if distance != 0.0 then walkMove(actor, actorYaw(actor), distance, context) end if
  if FindTarget(actor, context) then return true end if
  ChangeYaw(actor)
  return true
end function

function FacingIdeal(actor)
  delta = angleMod(actorYaw(actor) - actor.idealYaw)
  return not (delta > 45.0 and delta < 315.0)
end function

function HuntTarget(actor, context)
  actor.goalEntity = actor.enemy
  if (actor.info.aiFlags & gaiconstants.AI_STAND_GROUND) != 0 then
    if typeof(actor.info.stand) == "function" then actor.info.stand(actor, context) end if
  else
    if typeof(actor.info.run) == "function" then actor.info.run(actor, context) end if
    actor.info.attackFinished = context.time + 1.0
  end if
  actor.idealYaw = vectorToYaw(directionTo(actor, actor.enemy))
  return true
end function

function FoundTarget(actor, context)
  if actor.enemy is void then return error(9601, "FoundTarget: enemy required") end if
  // Publish a monster that found a client for one frame so nearby monsters
  // can inherit the sighting without scanning every client.
  if actor.enemy.isClient then
    context.sightEntity = actor
    context.sightEntityFrame = context.frameNumber
    actor.lightLevel = 128
  end if
  actor.showHostile = context.time + 1.0
  copyOriginToArray(actor.info.lastSighting, actor.enemy.edict.state.origin)
  actor.info.trailTime = context.time
  if actor.combatTarget == "" then
    HuntTarget(actor, context)
  else
    destination = void
    if typeof(context.pickTarget) == "function" then destination = context.pickTarget(actor.combatTarget) end if
    if destination is void then
      actor.goalEntity = actor.enemy
      actor.moveTarget = actor.enemy
      HuntTarget(actor, context)
    else
      actor.goalEntity = destination
      actor.moveTarget = destination
      actor.combatTarget = ""
      actor.info.aiFlags = actor.info.aiFlags | gaiconstants.AI_COMBAT_POINT
      actor.info.pauseTime = 0.0
      if typeof(actor.info.run) == "function" then actor.info.run(actor, context) end if
    end if
  end if
  return true
end function

function candidateFromContext(actor, context)
  heard = false
  candidate = void
  if context.sightEntityFrame >= context.frameNumber - 1 and (actor.spawnFlags & gaiconstants.SPAWNFLAG_AMBUSH) == 0 then candidate = context.sightEntity
  else if context.soundEntityFrame >= context.frameNumber - 1 then candidate = context.soundEntity; heard = true
  else if actor.enemy is void and context.sound2EntityFrame >= context.frameNumber - 1 and (actor.spawnFlags & gaiconstants.SPAWNFLAG_AMBUSH) == 0 then candidate = context.sound2Entity; heard = true
  else candidate = context.sightClient
  end if
  return gaitypes.TargetSelection(candidate, heard)
end function

function FindTarget(actor, context)
  if (actor.info.aiFlags & gaiconstants.AI_GOOD_GUY) != 0 then return false end if
  if (actor.info.aiFlags & gaiconstants.AI_COMBAT_POINT) != 0 then return false end if
  selection = candidateFromContext(actor, context)
  candidate = selection.candidate
  heard = selection.heard
  if candidate is void or candidate.edict.inUse != true then return false end if
  if actor.enemy is not void and nativeRawValue(candidate) == nativeRawValue(actor.enemy) then return true end if
  if candidate.isClient then
    if (candidate.flags & gaiconstants.FL_NOTARGET) != 0 then return false end if
  else if candidate.isMonster then
    if candidate.enemy is void then return false end if
    if (candidate.enemy.flags & gaiconstants.FL_NOTARGET) != 0 then return false end if
  else if heard then
    if candidate.owner is void or (candidate.owner.flags & gaiconstants.FL_NOTARGET) != 0 then return false end if
  else return false
  end if

  if not heard then
    enemyRange = range(actor, candidate)
    if enemyRange == gaiconstants.RANGE_FAR or candidate.lightLevel <= 5 then return false end if
    if visible(actor, candidate, context) != true then return false end if
    if enemyRange == gaiconstants.RANGE_NEAR and candidate.showHostile < context.time and infront(actor, candidate) != true then return false end if
    if enemyRange == gaiconstants.RANGE_MID and infront(actor, candidate) != true then return false end if
    actor.enemy = candidate
    actor.info.aiFlags = actor.info.aiFlags & ~gaiconstants.AI_SOUND_TARGET
    if candidate.isMonster then
      actor.enemy = candidate.enemy
      if actor.enemy is void or actor.enemy.isClient != true then actor.enemy = void; return false end if
    end if
  else
    if (actor.spawnFlags & gaiconstants.SPAWNFLAG_AMBUSH) != 0 then
      if visible(actor, candidate, context) != true then return false end if
    else
      if typeof(context.inPHS) != "function" or context.inPHS(actor.edict.state.origin, candidate.edict.state.origin) != true then return false end if
    end if
    delta = directionTo(actor, candidate)
    if vectorLength(delta) > 1000.0 then return false end if
    if candidate.areaNumber != actor.areaNumber then
      if typeof(context.areasConnected) != "function" or context.areasConnected(actor.areaNumber, candidate.areaNumber) != true then return false end if
    end if
    actor.idealYaw = vectorToYaw(delta)
    ChangeYaw(actor)
    actor.info.aiFlags = actor.info.aiFlags | gaiconstants.AI_SOUND_TARGET
    actor.enemy = candidate
  end if
  FoundTarget(actor, context)
  if (actor.info.aiFlags & gaiconstants.AI_SOUND_TARGET) == 0 and typeof(actor.info.sight) == "function" then actor.info.sight(actor, actor.enemy, context) end if
  return true
end function

function M_CheckAttack(actor, context, enemyRange)
  if actor.enemy is void then return false end if
  if actor.enemy.health > 0 and typeof(context.clearShot) == "function" and context.clearShot(actor, actor.enemy) != true then return false end if
  if enemyRange == gaiconstants.RANGE_MELEE then
    if context.skill == 0 and context.randomAttack > 0.25 then return false end if
    if typeof(actor.info.melee) == "function" then actor.info.attackState = gaiconstants.AS_MELEE
    else actor.info.attackState = gaiconstants.AS_MISSILE
    end if
    return true
  end if
  if typeof(actor.info.attack) != "function" or context.time < actor.info.attackFinished or enemyRange == gaiconstants.RANGE_FAR then return false end if
  chance = 0.0
  if (actor.info.aiFlags & gaiconstants.AI_STAND_GROUND) != 0 then chance = 0.4
  else if enemyRange == gaiconstants.RANGE_NEAR then chance = 0.1
  else if enemyRange == gaiconstants.RANGE_MID then chance = 0.02
  end if
  if context.skill == 0 then chance = chance * 0.5 else if context.skill >= 2 then chance = chance * 2.0 end if
  if context.randomAttack < chance then
    actor.info.attackState = gaiconstants.AS_MISSILE
    actor.info.attackFinished = context.time + 2.0 * context.randomDelay
    return true
  end if
  if (actor.flags & gaiconstants.FL_FLY) != 0 then
    if context.randomDelay < 0.3 then actor.info.attackState = gaiconstants.AS_SLIDING else actor.info.attackState = gaiconstants.AS_STRAIGHT end if
  end if
  return false
end function

function DispatchAttackState(actor, context, enemyYaw)
  actor.idealYaw = enemyYaw
  ChangeYaw(actor)
  if not FacingIdeal(actor) then return false end if
  if actor.info.attackState == gaiconstants.AS_MELEE and typeof(actor.info.melee) == "function" then actor.info.melee(actor, context)
  else if actor.info.attackState == gaiconstants.AS_MISSILE and typeof(actor.info.attack) == "function" then actor.info.attack(actor, context)
  else return false
  end if
  actor.info.attackState = gaiconstants.AS_STRAIGHT
  return true
end function

function ai_checkattack(actor, distance, context)
  actor.enemyVisible = false
  // Stock g_ai.c hunts a player_noise for at most five seconds.
  if actor.goalEntity is not void then
    if (actor.info.aiFlags & gaiconstants.AI_COMBAT_POINT) != 0 then return false end if
    if (actor.info.aiFlags & gaiconstants.AI_SOUND_TARGET) != 0 and actor.enemy is not void then
      if context.time - actor.enemy.teleportTime > 5.0 then
        if nativeRawValue(actor.goalEntity) == nativeRawValue(actor.enemy) then actor.goalEntity = actor.moveTarget end if
        actor.info.aiFlags = actor.info.aiFlags & ~gaiconstants.AI_SOUND_TARGET
        if (actor.info.aiFlags & gaiconstants.AI_TEMP_STAND_GROUND) != 0 then
          actor.info.aiFlags = actor.info.aiFlags & ~(gaiconstants.AI_STAND_GROUND | gaiconstants.AI_TEMP_STAND_GROUND)
        end if
      else
        actor.showHostile = context.time + 1.0
        return false
      end if
    end if
  end if
  enemyUnavailable = actor.enemy is void
  if not enemyUnavailable then enemyUnavailable = actor.enemy.edict.inUse != true end if
  if not enemyUnavailable and (actor.info.aiFlags & gaiconstants.AI_MEDIC) != 0 then
    // A Medic deliberately hunts a dead monster. Only a patient that has
    // already become alive again ends this special target state.
    if actor.enemy.health > 0 then
      enemyUnavailable = true
      actor.info.aiFlags = actor.info.aiFlags & ~gaiconstants.AI_MEDIC
    end if
  else if not enemyUnavailable then
    if (actor.info.aiFlags & gaiconstants.AI_BRUTAL) != 0 then
      if actor.enemy.health <= -80 then enemyUnavailable = true end if
    else if actor.enemy.health <= 0 then enemyUnavailable = true
    end if
  end if
  if enemyUnavailable then
    actor.enemy = void
    if actor.oldEnemy is not void and actor.oldEnemy.health > 0 then actor.enemy = actor.oldEnemy; actor.oldEnemy = void; HuntTarget(actor, context)
    else if actor.moveTarget is not void then actor.goalEntity = actor.moveTarget; if typeof(actor.info.walk) == "function" then actor.info.walk(actor, context) end if
    else actor.info.pauseTime = context.time + 100000000.0; if typeof(actor.info.stand) == "function" then actor.info.stand(actor, context) end if
    end if
    return true
  end if
  actor.showHostile = context.time + 1.0
  enemyVisible = visible(actor, actor.enemy, context)
  actor.enemyVisible = enemyVisible
  if enemyVisible then
    actor.info.searchTime = context.time + 5.0
    copyOriginToArray(actor.info.lastSighting, actor.enemy.edict.state.origin)
  end if
  enemyRange = range(actor, actor.enemy)
  enemyYaw = vectorToYaw(directionTo(actor, actor.enemy))
  if actor.info.attackState == gaiconstants.AS_MISSILE or actor.info.attackState == gaiconstants.AS_MELEE then return DispatchAttackState(actor, context, enemyYaw) end if
  if not enemyVisible then return false end if
  if typeof(actor.info.checkAttack) == "function" then return actor.info.checkAttack(actor, context, enemyRange) end if
  return M_CheckAttack(actor, context, enemyRange)
end function

function ai_run_slide(actor, distance, context)
  if actor.enemy is void then return false end if
  actor.idealYaw = vectorToYaw(directionTo(actor, actor.enemy))
  ChangeYaw(actor)
  offset = -90.0
  if actor.info.lefty != 0 then offset = 90.0 end if
  if walkMove(actor, actor.idealYaw + offset, distance, context) then return true end if
  actor.info.lefty = 1 - actor.info.lefty
  return walkMove(actor, actor.idealYaw - offset, distance, context)
end function

// Port the stock ai_run pursuit state machine. Lost-sight flags and temporary
// goals change in stock order so trail markers are consumed at most once.
function ai_run(actor, distance, context)
  if (actor.info.aiFlags & gaiconstants.AI_COMBAT_POINT) != 0 then
    return moveToGoal(actor, distance, context)
  end if

  if (actor.info.aiFlags & gaiconstants.AI_SOUND_TARGET) != 0 and
      actor.enemy is not void then
    deltaX = vectorX(actor.edict.state.origin) - vectorX(actor.enemy.edict.state.origin)
    deltaY = vectorY(actor.edict.state.origin) - vectorY(actor.enemy.edict.state.origin)
    deltaZ = vectorZ(actor.edict.state.origin) - vectorZ(actor.enemy.edict.state.origin)
    if gaimath.sqrt(deltaX * deltaX + deltaY * deltaY + deltaZ * deltaZ) < 64.0 then
      actor.info.aiFlags = actor.info.aiFlags |
        gaiconstants.AI_STAND_GROUND | gaiconstants.AI_TEMP_STAND_GROUND
      if typeof(actor.info.stand) == "function" then actor.info.stand(actor, context) end if
      return true
    end if
    moveToGoal(actor, distance, context)
    if FindTarget(actor, context) != true then return true end if
  end if

  if ai_checkattack(actor, distance, context) then return true end if
  // The active player_noise was already approached above. Do not feed that
  // fake target into lost-sight trail pursuit while it remains valid.
  if (actor.info.aiFlags & gaiconstants.AI_SOUND_TARGET) != 0 then return true end if
  if actor.info.attackState == gaiconstants.AS_SLIDING then
    return ai_run_slide(actor, distance, context)
  end if
  if actor.enemyVisible then
    moveToGoal(actor, distance, context)
    actor.info.aiFlags = actor.info.aiFlags & ~gaiconstants.AI_LOST_SIGHT
    copyOriginToArray(actor.info.lastSighting, actor.enemy.edict.state.origin)
    actor.info.trailTime = context.time
    return true
  end if

  if context.cooperative and FindTarget(actor, context) then return true end if
  if actor.info.searchTime != 0.0 and
      context.time > actor.info.searchTime + 20.0 then
    moveToGoal(actor, distance, context)
    actor.info.searchTime = 0.0
    return true
  end if

  savedGoalEntity = actor.goalEntity
  temporaryGoal = pursuitGoal(actor)
  actor.goalEntity = temporaryGoal
  isNewGoal = false
  if (actor.info.aiFlags & gaiconstants.AI_LOST_SIGHT) == 0 then
    actor.info.aiFlags = actor.info.aiFlags |
      gaiconstants.AI_LOST_SIGHT | gaiconstants.AI_PURSUIT_LAST_SEEN
    actor.info.aiFlags = actor.info.aiFlags &
      ~(gaiconstants.AI_PURSUE_NEXT | gaiconstants.AI_PURSUE_TEMP)
    isNewGoal = true
  end if

  marker = void
  if (actor.info.aiFlags & gaiconstants.AI_PURSUE_NEXT) != 0 then
    actor.info.aiFlags = actor.info.aiFlags & ~gaiconstants.AI_PURSUE_NEXT
    actor.info.searchTime = context.time + 5.0
    if (actor.info.aiFlags & gaiconstants.AI_PURSUE_TEMP) != 0 then
      actor.info.aiFlags = actor.info.aiFlags & ~gaiconstants.AI_PURSUE_TEMP
      actor.info.lastSighting[0] = actor.info.savedGoal[0]
      actor.info.lastSighting[1] = actor.info.savedGoal[1]
      actor.info.lastSighting[2] = actor.info.savedGoal[2]
      isNewGoal = true
    else if (actor.info.aiFlags & gaiconstants.AI_PURSUIT_LAST_SEEN) != 0 then
      actor.info.aiFlags = actor.info.aiFlags & ~gaiconstants.AI_PURSUIT_LAST_SEEN
      if typeof(context.trailPickFirst) == "function" then
        marker = context.trailPickFirst(actor)
      end if
    else if typeof(context.trailPickNext) == "function" then
      marker = context.trailPickNext(actor)
    end if
    if marker is not void then
      copyOriginToArray(actor.info.lastSighting, marker.edict.state.origin)
      actor.info.trailTime = marker.timestamp
      setActorYaw(actor, actorYaw(marker))
      actor.idealYaw = actorYaw(marker)
      isNewGoal = true
    end if
  end if

  actorX = vectorX(actor.edict.state.origin)
  actorY = vectorY(actor.edict.state.origin)
  actorZ = vectorZ(actor.edict.state.origin)
  sightDeltaX = actorX - actor.info.lastSighting[0]
  sightDeltaY = actorY - actor.info.lastSighting[1]
  sightDeltaZ = actorZ - actor.info.lastSighting[2]
  sightDistance = gaimath.sqrt(sightDeltaX * sightDeltaX +
    sightDeltaY * sightDeltaY + sightDeltaZ * sightDeltaZ)
  if sightDistance <= distance then
    actor.info.aiFlags = actor.info.aiFlags | gaiconstants.AI_PURSUE_NEXT
    distance = sightDistance
  end if

  temporaryOrigin = temporaryGoal.edict.state.origin
  temporaryOrigin.x = actor.info.lastSighting[0]
  temporaryOrigin.y = actor.info.lastSighting[1]
  temporaryOrigin.z = actor.info.lastSighting[2]

  if isNewGoal and typeof(context.moveTrace) == "function" then
    courseTrace = context.moveTrace(actor.edict.state.origin, actor.edict.mins,
      actor.edict.maxs, temporaryOrigin, actor, gaiqconstants.MASK_PLAYERSOLID)
    if courseTrace.fraction < 1.0 then
      goalDeltaX = temporaryOrigin.x - actorX
      goalDeltaY = temporaryOrigin.y - actorY
      goalDeltaZ = temporaryOrigin.z - actorZ
      goalDistance = gaimath.sqrt(goalDeltaX * goalDeltaX +
        goalDeltaY * goalDeltaY + goalDeltaZ * goalDeltaZ)
      centerFraction = courseTrace.fraction
      correctionDistance = goalDistance * ((centerFraction + 1.0) * 0.5)
      if correctionDistance > 0.0 then
        yaw = scalarToYaw(goalDeltaX, goalDeltaY)
        setActorYaw(actor, yaw); actor.idealYaw = yaw
        yawRadians = gaimath.degToRad(yaw)
        forwardX = gaimath.cos(yawRadians)
        forwardY = gaimath.sin(yawRadians)
        rightX = -forwardY
        rightY = forwardX
        courseTarget = aiRunCourseScratch
        courseTarget.x = actorX + forwardX * correctionDistance - rightX * 16.0
        courseTarget.y = actorY + forwardY * correctionDistance - rightY * 16.0
        courseTarget.z = actorZ
        leftTrace = context.moveTrace(actor.edict.state.origin, actor.edict.mins,
          actor.edict.maxs, courseTarget, actor, gaiqconstants.MASK_PLAYERSOLID)
        leftFraction = leftTrace.fraction
        leftX = courseTarget.x; leftY = courseTarget.y; leftZ = courseTarget.z
        courseTarget.x = actorX + forwardX * correctionDistance + rightX * 16.0
        courseTarget.y = actorY + forwardY * correctionDistance + rightY * 16.0
        courseTarget.z = actorZ
        rightTrace = context.moveTrace(actor.edict.state.origin, actor.edict.mins,
          actor.edict.maxs, courseTarget, actor, gaiqconstants.MASK_PLAYERSOLID)
        rightFraction = rightTrace.fraction
        rightXTarget = courseTarget.x; rightYTarget = courseTarget.y
        rightZTarget = courseTarget.z
        normalizedCenter = (goalDistance * centerFraction) / correctionDistance
        selectedX = 0.0; selectedY = 0.0; selectedZ = 0.0
        selected = false
        if leftFraction >= normalizedCenter and leftFraction > rightFraction then
          if leftFraction < 1.0 then
            partialDistance = correctionDistance * leftFraction * 0.5
            leftX = actorX + forwardX * partialDistance - rightX * 16.0
            leftY = actorY + forwardY * partialDistance - rightY * 16.0
            leftZ = actorZ
          end if
          selectedX = leftX; selectedY = leftY; selectedZ = leftZ
          selected = true
        else if rightFraction >= normalizedCenter and rightFraction > leftFraction then
          if rightFraction < 1.0 then
            partialDistance = correctionDistance * rightFraction * 0.5
            rightXTarget = actorX + forwardX * partialDistance + rightX * 16.0
            rightYTarget = actorY + forwardY * partialDistance + rightY * 16.0
            rightZTarget = actorZ
          end if
          selectedX = rightXTarget; selectedY = rightYTarget
          selectedZ = rightZTarget; selected = true
        end if
        if selected then
          actor.info.savedGoal[0] = actor.info.lastSighting[0]
          actor.info.savedGoal[1] = actor.info.lastSighting[1]
          actor.info.savedGoal[2] = actor.info.lastSighting[2]
          actor.info.aiFlags = actor.info.aiFlags | gaiconstants.AI_PURSUE_TEMP
          temporaryOrigin.x = selectedX; temporaryOrigin.y = selectedY
          temporaryOrigin.z = selectedZ
          actor.info.lastSighting[0] = selectedX
          actor.info.lastSighting[1] = selectedY
          actor.info.lastSighting[2] = selectedZ
          selectedYaw = scalarToYaw(selectedX - actorX, selectedY - actorY)
          setActorYaw(actor, selectedYaw); actor.idealYaw = selectedYaw
        end if
      end if
    end if
  end if

  result = moveToGoal(actor, distance, context)
  actor.goalEntity = savedGoalEntity
  return result
end function
