/*
Copyright (C) 1997-2001 Id Software, Inc.
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later

Collision-bound BaseQ2 monster movement ported from m_move.c and the ground
initialization helpers in g_monster.c. The live path keeps scalar coordinates
and package-rooted scratch vectors so a walk frame does not build temporary
arrays or concatenate values.
*/
package miniquake2.game.ai.move

import miniquake2.game.ai.constants as aimoveconstants
import miniquake2.game.ai.core as aimovecore
import miniquake2.qcommon.constants as aimoveqconstants
import miniquake2.qcommon.types as aimoveqtypes
import std.math as aimovemath

const STEP_SIZE = 18.0
const NO_DIRECTION = -1.0

moveTraceStartScratch = aimoveqtypes.Vec3(0.0, 0.0, 0.0)
moveTraceEndScratch = aimoveqtypes.Vec3(0.0, 0.0, 0.0)
movePointScratch = aimoveqtypes.Vec3(0.0, 0.0, 0.0)
moveZeroScratch = aimoveqtypes.Vec3(0.0, 0.0, 0.0)

// Set origin.
function inline setOrigin(actor, x, y, z)
  actor.edict.state.origin.x = x
  actor.edict.state.origin.y = y
  actor.edict.state.origin.z = z
  return true
end function

// Trace move.
function inline traceMove(actor, start, mins, maxs, finish, context)
  if typeof(context.moveTrace) != "function" then
    return error(9720, "monster movement trace callback is not installed")
  end if
  return context.moveTrace(start, mins, maxs, finish, actor,
    aimoveqconstants.MASK_MONSTERSOLID)
end function

// Return the contents for the requested position.
function inline contentsAt(point, context)
  if typeof(context.pointContents) != "function" then
    return error(9721, "monster point-contents callback is not installed")
  end if
  return context.pointContents(point)
end function

// Link and touch.
function inline linkAndTouch(actor, context)
  if typeof(context.linkActor) == "function" then context.linkActor(actor) end if
  if typeof(context.touchActorTriggers) == "function" then
    context.touchActorTriggers(actor)
  end if
  return true
end function

// Return the random integer value.
function inline randomInteger(context)
  if typeof(context.nextRandomInteger) == "function" then
    return context.nextRandomInteger()
  end if
  return 0
end function

// Validate m bottom.
function M_CheckBottom(actor, context)
  origin = actor.edict.state.origin
  mins = actor.edict.mins
  maxs = actor.edict.maxs
  minimumX = origin.x + mins.x
  minimumY = origin.y + mins.y
  minimumZ = origin.z + mins.z
  maximumX = origin.x + maxs.x
  maximumY = origin.y + maxs.y
  maximumZ = origin.z + maxs.z

  // Fast path: all four points immediately below the hull are solid world.
  point = movePointScratch
  point.z = minimumZ - 1.0
  allSolid = true
  xIndex = 0
  while xIndex <= 1
    if xIndex == 0 then point.x = minimumX else point.x = maximumX end if
    yIndex = 0
    while yIndex <= 1
      if yIndex == 0 then point.y = minimumY else point.y = maximumY end if
      if contentsAt(point, context) != aimoveqconstants.CONTENTS_SOLID then
        allSolid = false
      end if
      yIndex = yIndex + 1
    end while
    xIndex = xIndex + 1
  end while
  if allSolid then return true end if

  start = moveTraceStartScratch
  stop = moveTraceEndScratch
  start.x = (minimumX + maximumX) * 0.5
  start.y = (minimumY + maximumY) * 0.5
  start.z = minimumZ
  stop.x = start.x; stop.y = start.y; stop.z = start.z - 2.0 * STEP_SIZE
  trace = traceMove(actor, start, moveZeroScratch, moveZeroScratch, stop, context)
  if trace.fraction == 1.0 then return false end if
  middle = trace.endPosition.z
  bottom = middle

  xIndex = 0
  while xIndex <= 1
    if xIndex == 0 then start.x = minimumX else start.x = maximumX end if
    stop.x = start.x
    yIndex = 0
    while yIndex <= 1
      if yIndex == 0 then start.y = minimumY else start.y = maximumY end if
      stop.y = start.y
      trace = traceMove(actor, start, moveZeroScratch, moveZeroScratch, stop,
        context)
      if trace.fraction != 1.0 and trace.endPosition.z > bottom then
        bottom = trace.endPosition.z
      end if
      if trace.fraction == 1.0 or middle - trace.endPosition.z > STEP_SIZE then
        return false
      end if
      yIndex = yIndex + 1
    end while
    xIndex = xIndex + 1
  end while
  return true
end function

// Validate m ground.
function M_CheckGround(actor, context)
  if (actor.flags & (aimoveconstants.FL_SWIM | aimoveconstants.FL_FLY)) != 0 then
    return false
  end if
  if actor.velocity.z > 100.0 then actor.groundEntity = void; return false end if
  origin = actor.edict.state.origin
  point = moveTraceEndScratch
  point.x = origin.x; point.y = origin.y; point.z = origin.z - 0.25
  trace = traceMove(actor, origin, actor.edict.mins, actor.edict.maxs, point,
    context)
  if trace.plane.normal.z < 0.7 and not trace.startSolid then
    actor.groundEntity = void
    return false
  end if
  if not trace.startSolid and not trace.allSolid then
    setOrigin(actor, trace.endPosition.x, trace.endPosition.y,
      trace.endPosition.z)
    actor.groundEntity = trace.entity
    actor.groundLinkCount = 0
    if trace.entity is not void then actor.groundLinkCount = trace.entity.linkCount end if
    actor.velocity.z = 0.0
    return actor.groundEntity is not void
  end if
  return false
end function

// Return the m categorize position.
function M_CategorizePosition(actor, context)
  origin = actor.edict.state.origin
  point = movePointScratch
  point.x = origin.x; point.y = origin.y
  point.z = origin.z + actor.edict.mins.z + 1.0
  contents = contentsAt(point, context)
  if (contents & aimoveqconstants.MASK_WATER) == 0 then
    actor.waterLevel = 0; actor.waterType = 0
    return 0
  end if
  actor.waterType = contents
  actor.waterLevel = 1
  point.z = point.z + 26.0
  contents = contentsAt(point, context)
  if (contents & aimoveqconstants.MASK_WATER) == 0 then return 1 end if
  actor.waterLevel = 2
  point.z = point.z + 22.0
  contents = contentsAt(point, context)
  if (contents & aimoveqconstants.MASK_WATER) != 0 then actor.waterLevel = 3 end if
  return actor.waterLevel
end function

// Drop m to floor.
function M_DropToFloor(actor, context)
  origin = actor.edict.state.origin
  origin.z = origin.z + 1.0
  endPosition = moveTraceEndScratch
  endPosition.x = origin.x; endPosition.y = origin.y
  endPosition.z = origin.z - 256.0
  trace = traceMove(actor, origin, actor.edict.mins, actor.edict.maxs,
    endPosition, context)
  if trace.fraction == 1.0 or trace.allSolid then return false end if
  setOrigin(actor, trace.endPosition.x, trace.endPosition.y,
    trace.endPosition.z)
  if typeof(context.linkActor) == "function" then context.linkActor(actor) end if
  M_CheckGround(actor, context)
  M_CategorizePosition(actor, context)
  return actor.groundEntity is not void
end function

// Apply one stock M_MoveStep attempt without publishing a partial transform.
// Ground, fly/swim and water branches commit only after their trace checks pass.
function MoveStep(actor, moveX, moveY, moveZ, relink, context)
  // Keep move step phases explicit: validate inputs, update owned state, then publish the result.
  origin = actor.edict.state.origin
  oldX = origin.x; oldY = origin.y; oldZ = origin.z
  newOrigin = moveTraceStartScratch
  endPosition = moveTraceEndScratch
  testPoint = movePointScratch

  if (actor.flags & (aimoveconstants.FL_SWIM | aimoveconstants.FL_FLY)) != 0 then
    attempt = 0
    while attempt < 2
      newOrigin.x = origin.x + moveX
      newOrigin.y = origin.y + moveY
      newOrigin.z = origin.z + moveZ
      if attempt == 0 and actor.enemy is not void then
        if actor.goalEntity is void then actor.goalEntity = actor.enemy end if
        deltaZ = origin.z - actor.goalEntity.edict.state.origin.z
        if actor.goalEntity.isClient then
          if deltaZ > 40.0 then newOrigin.z = newOrigin.z - 8.0 end if
          if not ((actor.flags & aimoveconstants.FL_SWIM) != 0 and
              actor.waterLevel < 2) and deltaZ < 30.0 then
            newOrigin.z = newOrigin.z + 8.0
          end if
        else
          if deltaZ > 8.0 then newOrigin.z = newOrigin.z - 8.0
          else if deltaZ > 0.0 then newOrigin.z = newOrigin.z - deltaZ
          else if deltaZ < -8.0 then newOrigin.z = newOrigin.z + 8.0
          else newOrigin.z = newOrigin.z + deltaZ
          end if
        end if
      end if
      trace = traceMove(actor, origin, actor.edict.mins, actor.edict.maxs,
        newOrigin, context)
      testPoint.x = trace.endPosition.x
      testPoint.y = trace.endPosition.y
      testPoint.z = trace.endPosition.z + actor.edict.mins.z + 1.0
      if (actor.flags & aimoveconstants.FL_FLY) != 0 and actor.waterLevel == 0 and
          (contentsAt(testPoint, context) & aimoveqconstants.MASK_WATER) != 0 then
        return false
      end if
      if (actor.flags & aimoveconstants.FL_SWIM) != 0 and actor.waterLevel < 2 and
          (contentsAt(testPoint, context) & aimoveqconstants.MASK_WATER) == 0 then
        return false
      end if
      if trace.fraction == 1.0 then
        setOrigin(actor, trace.endPosition.x, trace.endPosition.y,
          trace.endPosition.z)
        if relink then linkAndTouch(actor, context) end if
        return true
      end if
      if actor.enemy is void then break end if
      attempt = attempt + 1
    end while
    return false
  end if

  stepSize = STEP_SIZE
  if (actor.info.aiFlags & aimoveconstants.AI_NOSTEP) != 0 then stepSize = 1.0 end if
  newOrigin.x = origin.x + moveX
  newOrigin.y = origin.y + moveY
  newOrigin.z = origin.z + moveZ + stepSize
  endPosition.x = newOrigin.x
  endPosition.y = newOrigin.y
  endPosition.z = newOrigin.z - stepSize * 2.0
  trace = traceMove(actor, newOrigin, actor.edict.mins, actor.edict.maxs,
    endPosition, context)
  if trace.allSolid then return false end if
  if trace.startSolid then
    newOrigin.z = newOrigin.z - stepSize
    trace = traceMove(actor, newOrigin, actor.edict.mins, actor.edict.maxs,
      endPosition, context)
    if trace.allSolid or trace.startSolid then return false end if
  end if

  if actor.waterLevel == 0 then
    testPoint.x = trace.endPosition.x
    testPoint.y = trace.endPosition.y
    testPoint.z = trace.endPosition.z + actor.edict.mins.z + 1.0
    if (contentsAt(testPoint, context) & aimoveqconstants.MASK_WATER) != 0 then
      return false
    end if
  end if

  if trace.fraction == 1.0 then
    if (actor.flags & aimoveconstants.FL_PARTIALGROUND) != 0 then
      setOrigin(actor, oldX + moveX, oldY + moveY, oldZ + moveZ)
      if relink then linkAndTouch(actor, context) end if
      actor.groundEntity = void
      return true
    end if
    return false
  end if

  setOrigin(actor, trace.endPosition.x, trace.endPosition.y,
    trace.endPosition.z)
  if M_CheckBottom(actor, context) != true then
    if (actor.flags & aimoveconstants.FL_PARTIALGROUND) != 0 then
      if relink then linkAndTouch(actor, context) end if
      return true
    end if
    setOrigin(actor, oldX, oldY, oldZ)
    return false
  end if
  actor.flags = actor.flags & ~aimoveconstants.FL_PARTIALGROUND
  actor.groundEntity = trace.entity
  actor.groundLinkCount = 0
  if trace.entity is not void then actor.groundLinkCount = trace.entity.linkCount end if
  if relink then linkAndTouch(actor, context) end if
  return true
end function

// Advance direction.
function StepDirection(actor, yaw, distance, context)
  actor.idealYaw = yaw
  aimovecore.ChangeYaw(actor)
  radians = aimovemath.degToRad(yaw)
  moveX = aimovemath.cos(radians) * distance
  moveY = aimovemath.sin(radians) * distance
  origin = actor.edict.state.origin
  oldX = origin.x; oldY = origin.y; oldZ = origin.z
  if MoveStep(actor, moveX, moveY, 0.0, false, context) then
    delta = actor.edict.state.angles.y - actor.idealYaw
    if delta > 45.0 and delta < 315.0 then setOrigin(actor, oldX, oldY, oldZ) end if
    linkAndTouch(actor, context)
    return true
  end if
  linkAndTouch(actor, context)
  return false
end function

// Return the new chase direction value.
function NewChaseDirection(actor, goal, distance, context)
  // Keep new chase direction phases explicit: validate inputs, update owned state, then publish the result.
  if goal is void then return false end if
  oldDirection = aimovecore.angleMod(
    aimovemath.floor(actor.idealYaw / 45.0) * 45.0)
  turnAround = aimovecore.angleMod(oldDirection - 180.0)
  deltaX = goal.edict.state.origin.x - actor.edict.state.origin.x
  deltaY = goal.edict.state.origin.y - actor.edict.state.origin.y
  directionX = NO_DIRECTION
  directionY = NO_DIRECTION
  if deltaX > 10.0 then directionX = 0.0
  else if deltaX < -10.0 then directionX = 180.0
  end if
  if deltaY < -10.0 then directionY = 270.0
  else if deltaY > 10.0 then directionY = 90.0
  end if

  if directionX != NO_DIRECTION and directionY != NO_DIRECTION then
    targetDirection = 215.0
    if directionX == 0.0 then
      if directionY == 90.0 then targetDirection = 45.0
      else targetDirection = 315.0
      end if
    else if directionY == 90.0 then targetDirection = 135.0
    end if
    if targetDirection != turnAround and
        StepDirection(actor, targetDirection, distance, context) then return true end if
  end if

  if ((randomInteger(context) & 3) & 1) != 0 or
      aimovemath.abs(deltaY) > aimovemath.abs(deltaX) then
    swap = directionX; directionX = directionY; directionY = swap
  end if
  if directionX != NO_DIRECTION and directionX != turnAround and
      StepDirection(actor, directionX, distance, context) then return true end if
  if directionY != NO_DIRECTION and directionY != turnAround and
      StepDirection(actor, directionY, distance, context) then return true end if
  if oldDirection != NO_DIRECTION and
      StepDirection(actor, oldDirection, distance, context) then return true end if

  if (randomInteger(context) & 1) != 0 then
    targetDirection = 0.0
    while targetDirection <= 315.0
      if targetDirection != turnAround and
          StepDirection(actor, targetDirection, distance, context) then return true end if
      targetDirection = targetDirection + 45.0
    end while
  else
    targetDirection = 315.0
    while targetDirection >= 0.0
      if targetDirection != turnAround and
          StepDirection(actor, targetDirection, distance, context) then return true end if
      targetDirection = targetDirection - 45.0
    end while
  end if
  if turnAround != NO_DIRECTION and
      StepDirection(actor, turnAround, distance, context) then return true end if
  actor.idealYaw = oldDirection
  if M_CheckBottom(actor, context) != true then
    actor.flags = actor.flags | aimoveconstants.FL_PARTIALGROUND
  end if
  return false
end function

// Close enough.
function CloseEnough(actor, goal, distance)
  actorOrigin = actor.edict.state.origin
  goalOrigin = goal.edict.state.origin
  if goalOrigin.x + goal.edict.mins.x > actorOrigin.x + actor.edict.maxs.x + distance or
      goalOrigin.x + goal.edict.maxs.x < actorOrigin.x + actor.edict.mins.x - distance then
    return false
  end if
  if goalOrigin.y + goal.edict.mins.y > actorOrigin.y + actor.edict.maxs.y + distance or
      goalOrigin.y + goal.edict.maxs.y < actorOrigin.y + actor.edict.mins.y - distance then
    return false
  end if
  if goalOrigin.z + goal.edict.mins.z > actorOrigin.z + actor.edict.maxs.z + distance or
      goalOrigin.z + goal.edict.maxs.z < actorOrigin.z + actor.edict.mins.z - distance then
    return false
  end if
  return true
end function

// Move to goal.
function MoveToGoal(actor, distance, context)
  if actor.groundEntity is void and
      (actor.flags & (aimoveconstants.FL_FLY | aimoveconstants.FL_SWIM)) == 0 then
    return false
  end if
  if actor.enemy is not void and CloseEnough(actor, actor.enemy, distance) then
    return true
  end if
  if (randomInteger(context) & 3) == 1 or
      StepDirection(actor, actor.idealYaw, distance, context) != true then
    if actor.edict.inUse then
      return NewChaseDirection(actor, actor.goalEntity, distance, context)
    end if
  end if
  return true
end function

// Move walk.
function WalkMove(actor, yaw, distance, context)
  if actor.groundEntity is void and
      (actor.flags & (aimoveconstants.FL_FLY | aimoveconstants.FL_SWIM)) == 0 then
    return false
  end if
  radians = aimovemath.degToRad(yaw)
  return MoveStep(actor, aimovemath.cos(radians) * distance,
    aimovemath.sin(radians) * distance, 0.0, true, context)
end function

// Initialize actor.
function InitializeActor(actor, context)
  if actor.movementInitialized then return true end if
  actor.movementInitialized = true
  if not actor.edict.inUse or
      (actor.spawnFlags & aimoveconstants.SPAWNFLAG_TRIGGER_SPAWN) != 0 then
    return true
  end if
  if (actor.flags & aimoveconstants.FL_FLY) != 0 then
    return WalkMove(actor, actor.edict.state.angles.y, 0.0, context)
  end if
  if (actor.flags & aimoveconstants.FL_SWIM) != 0 then
    M_CategorizePosition(actor, context)
    return true
  end if
  return M_DropToFloor(actor, context)
end function
