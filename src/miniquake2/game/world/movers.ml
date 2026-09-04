//! Provides miniquake2 game world movers facilities for this project.

/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Linear mover support and BaseQ2 button, door, plat, train and timer logic. */
package miniquake2.game.world.movers

import std.math as smath
import miniquake2.qcommon.types as qt
import miniquake2.qcommon.byteio as qbyteio
import miniquake2.game.world.constants as gwconstants
import miniquake2.game.world.core as gwcore
import miniquake2.game.world.vector as gwvector
import miniquake2.game.world.types as gwtypes

/// Move done.
/// @param entity entity value consumed by this operation.
/// @param world world value consumed by this operation.
function moveDone(entity, world)
  entity.velocity = qt.zeroVec3()
  if entity.moveInfo.endFunction is not void then entity.moveInfo.endFunction(entity, world) end if
  return true
end function

/// Move final.
/// @param entity entity value consumed by this operation.
/// @param world world value consumed by this operation.
function moveFinal(entity, world)
  if entity.moveInfo.remainingDistance == 0.0 then return moveDone(entity, world) end if
  entity.velocity = gwvector.scale(entity.moveInfo.direction, entity.moveInfo.remainingDistance / world.frameTime)
  entity.think = moveDone
  entity.nextThink = world.time + world.frameTime
  return true
end function

/// Move begin.
/// @param entity entity value consumed by this operation.
/// @param world world value consumed by this operation.
function moveBegin(entity, world)
  if entity.moveInfo.speed * world.frameTime >= entity.moveInfo.remainingDistance then return moveFinal(entity, world) end if
  entity.velocity = gwvector.scale(entity.moveInfo.direction, entity.moveInfo.speed)
  frames = smath.floor((entity.moveInfo.remainingDistance / entity.moveInfo.speed) / world.frameTime)
  entity.moveInfo.remainingDistance = entity.moveInfo.remainingDistance - frames * entity.moveInfo.speed * world.frameTime
  entity.nextThink = world.time + frames * world.frameTime
  entity.think = moveFinal
  return true
end function

/// Return the acceleration distance value.
/// @param target target value consumed by this operation.
/// @param rate rate value consumed by this operation.
function accelerationDistance(target, rate)
  return target * ((target / rate) + 1.0) / 2.0
end function

/// Calculate accelerated move.
/// @param moveInfo moveInfo value consumed by this operation.
function calculateAcceleratedMove(moveInfo)
  moveInfo.moveSpeed = moveInfo.speed
  if moveInfo.remainingDistance < moveInfo.accel then
    moveInfo.currentSpeed = moveInfo.remainingDistance
    return true
  end if
  accelDistance = accelerationDistance(moveInfo.speed, moveInfo.accel)
  decelDistance = accelerationDistance(moveInfo.speed, moveInfo.decel)
  if moveInfo.remainingDistance - accelDistance - decelDistance < 0.0 then
    factor = (moveInfo.accel + moveInfo.decel) / (moveInfo.accel * moveInfo.decel)
    moveInfo.moveSpeed = (-2.0 + smath.sqrt(4.0 - 4.0 * factor * (-2.0 * moveInfo.remainingDistance))) / (2.0 * factor)
    decelDistance = accelerationDistance(moveInfo.moveSpeed, moveInfo.decel)
  end if
  moveInfo.decelDistance = decelDistance
  return true
end function

/// Move accelerate.
/// @param moveInfo moveInfo value consumed by this operation.
function accelerateMove(moveInfo)
  if moveInfo.remainingDistance <= moveInfo.decelDistance then
    if moveInfo.remainingDistance < moveInfo.decelDistance then
      if moveInfo.nextSpeed != 0.0 then
        moveInfo.currentSpeed = moveInfo.nextSpeed
        moveInfo.nextSpeed = 0.0
        return true
      end if
      if moveInfo.currentSpeed > moveInfo.decel then moveInfo.currentSpeed = moveInfo.currentSpeed - moveInfo.decel end if
    end if
    return true
  end if

  if moveInfo.currentSpeed == moveInfo.moveSpeed and moveInfo.remainingDistance - moveInfo.currentSpeed < moveInfo.decelDistance then
    phase1Distance = moveInfo.remainingDistance - moveInfo.decelDistance
    phase2Distance = moveInfo.moveSpeed * (1.0 - phase1Distance / moveInfo.moveSpeed)
    distance = phase1Distance + phase2Distance
    moveInfo.currentSpeed = moveInfo.moveSpeed
    moveInfo.nextSpeed = moveInfo.moveSpeed - moveInfo.decel * (phase2Distance / distance)
    return true
  end if

  if moveInfo.currentSpeed < moveInfo.speed then
    oldSpeed = moveInfo.currentSpeed
    moveInfo.currentSpeed = moveInfo.currentSpeed + moveInfo.accel
    if moveInfo.currentSpeed > moveInfo.speed then moveInfo.currentSpeed = moveInfo.speed end if
    if moveInfo.remainingDistance - moveInfo.currentSpeed >= moveInfo.decelDistance then return true end if
    phase1Distance = moveInfo.remainingDistance - moveInfo.decelDistance
    phase1Speed = (oldSpeed + moveInfo.moveSpeed) / 2.0
    phase2Distance = moveInfo.moveSpeed * (1.0 - phase1Distance / phase1Speed)
    distance = phase1Distance + phase2Distance
    moveInfo.currentSpeed = phase1Speed * (phase1Distance / distance) + moveInfo.moveSpeed * (phase2Distance / distance)
    moveInfo.nextSpeed = moveInfo.moveSpeed - moveInfo.decel * (phase2Distance / distance)
  end if
  return true
end function

/// Run accelerated move.
/// @param entity entity value consumed by this operation.
/// @param world world value consumed by this operation.
function thinkAcceleratedMove(entity, world)
  entity.moveInfo.remainingDistance = entity.moveInfo.remainingDistance - entity.moveInfo.currentSpeed
  if entity.moveInfo.currentSpeed == 0.0 then calculateAcceleratedMove(entity.moveInfo) end if
  accelerateMove(entity.moveInfo)
  if entity.moveInfo.remainingDistance <= entity.moveInfo.currentSpeed then return moveFinal(entity, world) end if
  entity.velocity = gwvector.scale(entity.moveInfo.direction, entity.moveInfo.currentSpeed * 10.0)
  entity.nextThink = world.time + world.frameTime
  entity.think = thinkAcceleratedMove
  return true
end function

/// Move calc.
/// @param entity entity value consumed by this operation.
/// @param destination destination value consumed by this operation.
/// @param endFunction endFunction value consumed by this operation.
/// @param world world value consumed by this operation.
function moveCalc(entity, destination, endFunction, world)
  entity.velocity = qt.zeroVec3()
  gwMoverMoveInfoHolder = gwtypes.stabilizeMoveInfo(entity.moveInfo)
  entity.moveInfo = gwMoverMoveInfoHolder
  gwMoverDestinationHolder = gwtypes.vec3FromValue(destination, "moveCalc destination")
  gwMoverOriginHolder = gwtypes.vec3FromValue(entity.origin, "moveCalc origin")
  entity.origin = gwMoverOriginHolder
  movementDelta = gwvector.subtract(gwMoverDestinationHolder, gwMoverOriginHolder)
  normalization = gwvector.normalized(movementDelta)
  gwMoverDirectionHolder = gwtypes.vec3FromValue(normalization[0], "moveCalc direction")
  entity.moveInfo.direction = gwMoverDirectionHolder
  entity.moveInfo.remainingDistance = normalization[1]
  entity.moveInfo.endFunction = endFunction

  if entity.moveInfo.speed == entity.moveInfo.accel and entity.moveInfo.speed == entity.moveInfo.decel then
    master = entity
    if (entity.flags & gwconstants.FL_TEAMSLAVE) != 0 and entity.teamMaster is not void then master = entity.teamMaster end if
    if world.currentEntity is not void and world.currentEntity.number == master.number then
      moveBegin(entity, world)
    else
      entity.nextThink = world.time + world.frameTime
      entity.think = moveBegin
    end if
  else
    entity.moveInfo.currentSpeed = 0.0
    entity.think = thinkAcceleratedMove
    entity.nextThink = world.time + world.frameTime
  end if
  return true
end function

/// func_button
/// @param entity entity value consumed by this operation.
/// @param world world value consumed by this operation.

function buttonDone(entity, world)
  entity.moveInfo.state = gwconstants.STATE_BOTTOM
  entity.effects = entity.effects & ~gwconstants.EF_ANIM23
  entity.effects = entity.effects | gwconstants.EF_ANIM01
  return true
end function

/// Return button.
/// @param entity entity value consumed by this operation.
/// @param world world value consumed by this operation.
function buttonReturn(entity, world)
  entity.moveInfo.state = gwconstants.STATE_DOWN
  moveCalc(entity, entity.moveInfo.startOrigin, buttonDone, world)
  entity.frame = 0
  if entity.health != 0 then entity.takeDamage = gwconstants.DAMAGE_YES end if
  return true
end function

/// Return the button wait value.
/// @param entity entity value consumed by this operation.
/// @param world world value consumed by this operation.
function buttonWait(entity, world)
  entity.moveInfo.state = gwconstants.STATE_TOP
  entity.effects = entity.effects & ~gwconstants.EF_ANIM01
  entity.effects = entity.effects | gwconstants.EF_ANIM23
  gwcore.useTargets(world, entity, entity.activator)
  entity.frame = 1
  if entity.moveInfo.wait >= 0.0 then
    entity.nextThink = world.time + entity.moveInfo.wait
    entity.think = buttonReturn
  end if
  return true
end function

/// Fire button.
/// @param entity entity value consumed by this operation.
/// @param world world value consumed by this operation.
function buttonFire(entity, world)
  if entity.moveInfo.state == gwconstants.STATE_UP or entity.moveInfo.state == gwconstants.STATE_TOP then return false end if
  entity.moveInfo.state = gwconstants.STATE_UP
  if entity.soundIndex != 0 and (entity.flags & gwconstants.FL_TEAMSLAVE) == 0 then
    world.callbacks.sound(entity, "switches/butn2.wav")
  end if
  moveCalc(entity, entity.moveInfo.endOrigin, buttonWait, world)
  return true
end function

/// Use button.
/// @param entity entity value consumed by this operation.
/// @param other other value consumed by this operation.
/// @param activator activator value consumed by this operation.
/// @param world world value consumed by this operation.
function buttonUse(entity, other, activator, world)
  entity.activator = activator
  return buttonFire(entity, world)
end function

/// Handle button.
/// @param entity entity value consumed by this operation.
/// @param other other value consumed by this operation.
/// @param world world value consumed by this operation.
function buttonTouch(entity, other, world)
  if other is void or other.isClient == false or other.health <= 0 then return false end if
  entity.activator = other
  return buttonFire(entity, world)
end function

/// Return the button killed value.
/// @param entity entity value consumed by this operation.
/// @param inflictor inflictor value consumed by this operation.
/// @param attacker attacker value consumed by this operation.
/// @param damage damage value consumed by this operation.
/// @param point point value consumed by this operation.
/// @param world world value consumed by this operation.
function buttonKilled(entity, inflictor, attacker, damage, point, world)
  entity.activator = attacker
  entity.health = entity.maxHealth
  entity.takeDamage = gwconstants.DAMAGE_NO
  return buttonFire(entity, world)
end function

/// Spawn button.
/// @param entity entity value consumed by this operation.
/// @param world world value consumed by this operation.
function spawnButton(entity, world)
  entity.moveDirection = gwvector.setMovedir(entity)
  entity.moveType = gwconstants.MOVETYPE_STOP
  entity.solid = gwconstants.SOLID_BSP
  if entity.speed == 0.0 then entity.speed = 40.0 end if
  if entity.accel == 0.0 then entity.accel = entity.speed end if
  if entity.decel == 0.0 then entity.decel = entity.speed end if
  if entity.wait == 0.0 then entity.wait = 3.0 end if
  if entity.lip == 0.0 then entity.lip = 4.0 end if
  startOrigin = gwvector.copy(entity.origin)
  distance = smath.abs(entity.moveDirection.x) * entity.size.x + smath.abs(entity.moveDirection.y) * entity.size.y + smath.abs(entity.moveDirection.z) * entity.size.z - entity.lip
  endOrigin = gwvector.multiplyAdd(startOrigin, distance, entity.moveDirection)
  entity.use = buttonUse
  entity.effects = entity.effects | gwconstants.EF_ANIM01
  if entity.health != 0 then
    entity.maxHealth = entity.health
    entity.die = buttonKilled
    entity.takeDamage = gwconstants.DAMAGE_YES
  else if entity.targetName == "" then
    entity.touch = buttonTouch
  end if
  entity.moveInfo.state = gwconstants.STATE_BOTTOM
  entity.moveInfo.speed = entity.speed
  entity.moveInfo.accel = entity.accel
  entity.moveInfo.decel = entity.decel
  entity.moveInfo.wait = entity.wait
  entity.moveInfo.startOrigin = startOrigin
  entity.moveInfo.endOrigin = endOrigin
  entity.moveInfo.startAngles = gwvector.copy(entity.angles)
  entity.moveInfo.endAngles = gwvector.copy(entity.angles)
  world.callbacks.linkEntity(entity)
  return entity
end function

/// func_door
/// @param entity entity value consumed by this operation.
/// @param isOpen isOpen value consumed by this operation.
/// @param world world value consumed by this operation.

function doorUseAreaPortals(entity, isOpen, world)
  if entity.target == "" then return false end if
  for each targetEntity in gwcore.matchingTargets(world, entity.target)
    if targetEntity.className == "func_areaportal" then world.callbacks.areaPortal(targetEntity.style, isOpen) end if
  end for
  return true
end function

/// Handle door.
/// @param entity entity value consumed by this operation.
/// @param other other value consumed by this operation.
/// @param world world value consumed by this operation.
function doorTouch(entity, other, world)
  if other is void or other.health <= 0 then return false end if
  if other.isClient == false and (other.serverFlags & gwconstants.SVF_MONSTER) == 0 then return false end if
  if world.time < entity.touchDebounceTime then return false end if
  entity.touchDebounceTime = world.time + 5.0
  world.callbacks.centerPrint(other, entity.message)
  world.callbacks.sound(other, "misc/talk1.wav")
  return true
end function

/// Calculate door move speed.
/// @param entity entity value consumed by this operation.
/// @param world world value consumed by this operation.
function calculateDoorMoveSpeed(entity, world)
  if (entity.flags & gwconstants.FL_TEAMSLAVE) != 0 then return false end if
  minimumDistance = smath.abs(entity.moveInfo.distance)
  member = entity.teamChain
  while member is not void
    memberDistance = smath.abs(member.moveInfo.distance)
    if memberDistance < minimumDistance then minimumDistance = memberDistance end if
    member = member.teamChain
  end while
  if minimumDistance == 0.0 or entity.moveInfo.speed == 0.0 then return false end if
  movementTime = minimumDistance / entity.moveInfo.speed
  member = entity
  while member is not void
    newSpeed = smath.abs(member.moveInfo.distance) / movementTime
    ratio = newSpeed / member.moveInfo.speed
    if member.moveInfo.accel == member.moveInfo.speed then member.moveInfo.accel = newSpeed
    else member.moveInfo.accel = member.moveInfo.accel * ratio end if
    if member.moveInfo.decel == member.moveInfo.speed then member.moveInfo.decel = newSpeed
    else member.moveInfo.decel = member.moveInfo.decel * ratio end if
    member.moveInfo.speed = newSpeed
    member = member.teamChain
  end while
  return true
end function

/// Handle door trigger.
/// @param trigger trigger value consumed by this operation.
/// @param other other value consumed by this operation.
/// @param world world value consumed by this operation.
function doorTriggerTouch(trigger, other, world)
  owner = trigger.owner
  if owner is void or other is void or other.health <= 0 then return false end if
  if other.isClient == false and (other.serverFlags & gwconstants.SVF_MONSTER) == 0 then return false end if
  if (owner.spawnFlags & gwconstants.DOOR_NOMONSTER) != 0 and
      (other.serverFlags & gwconstants.SVF_MONSTER) != 0 then return false end if
  if world.time < trigger.touchDebounceTime then return false end if
  trigger.touchDebounceTime = world.time + 1.0
  return doorUse(owner, other, other, world)
end function

/// Spawn door trigger.
/// @param entity entity value consumed by this operation.
/// @param world world value consumed by this operation.
function spawnDoorTrigger(entity, world)
  if (entity.flags & gwconstants.FL_TEAMSLAVE) != 0 then return false end if
  minimum = gwvector.copy(entity.absoluteMins)
  maximum = gwvector.copy(entity.absoluteMaxs)
  member = entity.teamChain
  while member is not void
    if member.absoluteMins.x < minimum.x then minimum.x = member.absoluteMins.x end if
    if member.absoluteMins.y < minimum.y then minimum.y = member.absoluteMins.y end if
    if member.absoluteMins.z < minimum.z then minimum.z = member.absoluteMins.z end if
    if member.absoluteMaxs.x > maximum.x then maximum.x = member.absoluteMaxs.x end if
    if member.absoluteMaxs.y > maximum.y then maximum.y = member.absoluteMaxs.y end if
    if member.absoluteMaxs.z > maximum.z then maximum.z = member.absoluteMaxs.z end if
    member = member.teamChain
  end while
  minimum.x = minimum.x - 60.0
  minimum.y = minimum.y - 60.0
  maximum.x = maximum.x + 60.0
  maximum.y = maximum.y + 60.0
  trigger = gwcore.spawnEntity(world, "door_trigger")
  trigger.mins = minimum
  trigger.maxs = maximum
  trigger.owner = entity
  trigger.solid = gwconstants.SOLID_TRIGGER
  trigger.moveType = gwconstants.MOVETYPE_NONE
  trigger.touch = doorTriggerTouch
  world.callbacks.linkEntity(trigger)
  if (entity.spawnFlags & gwconstants.DOOR_START_OPEN) != 0 then
    doorUseAreaPortals(entity, true, world)
  end if
  calculateDoorMoveSpeed(entity, world)
  return true
end function

/// Return the door hit top value.
/// @param entity entity value consumed by this operation.
/// @param world world value consumed by this operation.
function doorHitTop(entity, world)
  entity.moveInfo.state = gwconstants.STATE_TOP
  if (entity.flags & gwconstants.FL_TEAMSLAVE) == 0 then
    if entity.className == "func_water" and entity.sounds != 0 then
      world.callbacks.sound(entity, "world/stp_watr.wav")
    else if entity.soundIndex != 0 then world.callbacks.sound(entity, "doors/dr1_end.wav")
    end if
    entity.loopSound = 0
  end if
  if (entity.spawnFlags & gwconstants.DOOR_TOGGLE) != 0 then return true end if
  if entity.moveInfo.wait >= 0.0 then
    entity.think = doorGoDown
    entity.nextThink = world.time + entity.moveInfo.wait
  end if
  return true
end function

/// Return the door hit bottom value.
/// @param entity entity value consumed by this operation.
/// @param world world value consumed by this operation.
function doorHitBottom(entity, world)
  entity.moveInfo.state = gwconstants.STATE_BOTTOM
  if (entity.flags & gwconstants.FL_TEAMSLAVE) == 0 then
    if entity.className == "func_water" and entity.sounds != 0 then
      world.callbacks.sound(entity, "world/stp_watr.wav")
    else if entity.soundIndex != 0 then world.callbacks.sound(entity, "doors/dr1_end.wav")
    end if
    entity.loopSound = 0
  end if
  doorUseAreaPortals(entity, false, world)
  return true
end function

/// Return the door go down value.
/// @param entity entity value consumed by this operation.
/// @param world world value consumed by this operation.
function doorGoDown(entity, world)
  if (entity.flags & gwconstants.FL_TEAMSLAVE) == 0 then
    if entity.className == "func_water" and entity.sounds != 0 then
      world.callbacks.sound(entity, "world/mov_watr.wav")
    else if entity.soundIndex != 0 then
      world.callbacks.sound(entity, "doors/dr1_strt.wav")
      entity.loopSound = entity.soundIndex
    end if
  end if
  if entity.maxHealth != 0 then
    entity.takeDamage = gwconstants.DAMAGE_YES
    entity.health = entity.maxHealth
  end if
  entity.moveInfo.state = gwconstants.STATE_DOWN
  return moveCalc(entity, entity.moveInfo.startOrigin, doorHitBottom, world)
end function

/// Return the door go up value.
/// @param entity entity value consumed by this operation.
/// @param activator activator value consumed by this operation.
/// @param world world value consumed by this operation.
function doorGoUp(entity, activator, world)
  if entity.moveInfo.state == gwconstants.STATE_UP then return false end if
  if entity.moveInfo.state == gwconstants.STATE_TOP then
    if entity.moveInfo.wait >= 0.0 then entity.nextThink = world.time + entity.moveInfo.wait end if
    return false
  end if
  if (entity.flags & gwconstants.FL_TEAMSLAVE) == 0 then
    if entity.className == "func_water" and entity.sounds != 0 then
      world.callbacks.sound(entity, "world/mov_watr.wav")
    else if entity.soundIndex != 0 then
      world.callbacks.sound(entity, "doors/dr1_strt.wav")
      entity.loopSound = entity.soundIndex
    end if
  end if
  entity.moveInfo.state = gwconstants.STATE_UP
  moveCalc(entity, entity.moveInfo.endOrigin, doorHitTop, world)
  gwcore.useTargets(world, entity, activator)
  doorUseAreaPortals(entity, true, world)
  return true
end function

/// Use door.
/// @param entity entity value consumed by this operation.
/// @param other other value consumed by this operation.
/// @param activator activator value consumed by this operation.
/// @param world world value consumed by this operation.
function doorUse(entity, other, activator, world)
  if (entity.flags & gwconstants.FL_TEAMSLAVE) != 0 then return false end if
  if (entity.spawnFlags & gwconstants.DOOR_TOGGLE) != 0 and (entity.moveInfo.state == gwconstants.STATE_UP or entity.moveInfo.state == gwconstants.STATE_TOP) then
    member = entity
    while member is not void
      member.message = ""
      member.touch = void
      doorGoDown(member, world)
      member = member.teamChain
    end while
    return true
  end if
  member = entity
  while member is not void
    member.message = ""
    member.touch = void
    doorGoUp(member, activator, world)
    member = member.teamChain
  end while
  return true
end function

/// Report whether door blocked.
/// @param entity entity value consumed by this operation.
/// @param other other value consumed by this operation.
/// @param world world value consumed by this operation.
function doorBlocked(entity, other, world)
  if other is void then return false end if
  if other.isClient == false and (other.serverFlags & gwconstants.SVF_MONSTER) == 0 then
    world.callbacks.damage(other, entity, entity, 100000, gwconstants.MOD_CRUSH)
    gwcore.freeEntity(world, other)
    return true
  end if
  world.callbacks.damage(other, entity, entity, entity.damage, gwconstants.MOD_CRUSH)
  if (entity.spawnFlags & gwconstants.DOOR_CRUSHER) != 0 or entity.moveInfo.wait < 0.0 then return true end if
  master = entity.teamMaster
  if master is void then master = entity end if
  member = master
  while member is not void
    if entity.moveInfo.state == gwconstants.STATE_DOWN then
      if member.className == "func_door_rotating" then rotatingDoorGoUp(member, member.activator, world)
      else doorGoUp(member, member.activator, world) end if
    else
      if member.className == "func_door_rotating" then rotatingDoorGoDown(member, world)
      else doorGoDown(member, world) end if
    end if
    member = member.teamChain
  end while
  return true
end function

/// Return the door killed value.
/// @param entity entity value consumed by this operation.
/// @param inflictor inflictor value consumed by this operation.
/// @param attacker attacker value consumed by this operation.
/// @param damage damage value consumed by this operation.
/// @param point point value consumed by this operation.
/// @param world world value consumed by this operation.
function doorKilled(entity, inflictor, attacker, damage, point, world)
  master = entity.teamMaster
  if master is void then master = entity end if
  member = master
  while member is not void
    member.health = member.maxHealth
    member.takeDamage = gwconstants.DAMAGE_NO
    member = member.teamChain
  end while
  if master.className == "func_door_rotating" then return rotatingDoorUse(master, attacker, attacker, world) end if
  return doorUse(master, attacker, attacker, world)
end function

/// Spawn door.
/// @param entity entity value consumed by this operation.
/// @param world world value consumed by this operation.
function spawnDoor(entity, world)
  entity.moveDirection = gwvector.movedir(entity.angles)
  entity.moveType = gwconstants.MOVETYPE_PUSH
  entity.solid = gwconstants.SOLID_BSP
  entity.blocked = doorBlocked
  entity.use = doorUse
  if entity.speed == 0.0 then entity.speed = 100.0 end if
  if entity.accel == 0.0 then entity.accel = entity.speed end if
  if entity.decel == 0.0 then entity.decel = entity.speed end if
  if entity.wait == 0.0 then entity.wait = 3.0 end if
  if entity.lip == 0.0 then entity.lip = 8.0 end if
  if entity.damage == 0 then entity.damage = 2 end if
  startOrigin = gwvector.copy(entity.origin)
  distance = smath.abs(entity.moveDirection.x) * entity.size.x + smath.abs(entity.moveDirection.y) * entity.size.y + smath.abs(entity.moveDirection.z) * entity.size.z - entity.lip
  endOrigin = gwvector.multiplyAdd(startOrigin, distance, entity.moveDirection)
  if (entity.spawnFlags & gwconstants.DOOR_START_OPEN) != 0 then
    entity.origin = gwvector.copy(endOrigin)
    endOrigin = startOrigin
    startOrigin = gwvector.copy(entity.origin)
  end if
  entity.moveInfo.state = gwconstants.STATE_BOTTOM
  if entity.health != 0 then
    entity.takeDamage = gwconstants.DAMAGE_YES
    entity.die = doorKilled
    entity.maxHealth = entity.health
  else if entity.targetName != "" and entity.message != "" then
    entity.touch = doorTouch
  end if
  entity.moveInfo.speed = entity.speed
  entity.moveInfo.accel = entity.accel
  entity.moveInfo.decel = entity.decel
  entity.moveInfo.wait = entity.wait
  entity.moveInfo.distance = distance
  entity.moveInfo.startOrigin = startOrigin
  entity.moveInfo.endOrigin = endOrigin
  entity.moveInfo.startAngles = gwvector.copy(entity.angles)
  entity.moveInfo.endAngles = gwvector.copy(entity.angles)
  if (entity.spawnFlags & 16) != 0 then entity.effects = entity.effects | gwconstants.EF_ANIM_ALL end if
  if (entity.spawnFlags & 64) != 0 then entity.effects = entity.effects | gwconstants.EF_ANIM_ALLFAST end if
  if entity.teamMaster is void then entity.teamMaster = entity end if
  world.callbacks.linkEntity(entity)
  // The one-frame delay matches g_func.c: teams and inline-model absolute
  // bounds are complete before speed synchronization or touch-field creation.
  if entity.health != 0 or entity.targetName != "" then entity.think = calculateDoorMoveSpeed
  else entity.think = spawnDoorTrigger end if
  entity.nextThink = world.time + world.frameTime
  return entity
end function

/// func_water reuses door_use only after establishing its distinct defaults:
/// 25-unit speed, zero lip, no blocked callback and a wait=-1 toggle.
/// @param entity entity value consumed by this operation.
/// @param world world value consumed by this operation.
function spawnWater(entity, world)
  entity.moveDirection = gwvector.movedir(entity.angles)
  entity.moveType = gwconstants.MOVETYPE_PUSH
  entity.solid = gwconstants.SOLID_BSP
  entity.blocked = void
  entity.use = doorUse
  if entity.speed == 0.0 then entity.speed = 25.0 end if
  if entity.wait == 0.0 then entity.wait = -1.0 end if

  startOrigin = gwvector.copy(entity.origin)
  distance = smath.abs(entity.moveDirection.x) * entity.size.x +
    smath.abs(entity.moveDirection.y) * entity.size.y +
    smath.abs(entity.moveDirection.z) * entity.size.z - entity.lip
  endOrigin = gwvector.multiplyAdd(startOrigin, distance, entity.moveDirection)
  if (entity.spawnFlags & gwconstants.DOOR_START_OPEN) != 0 then
    entity.origin = gwvector.copy(endOrigin)
    endOrigin = startOrigin
    startOrigin = gwvector.copy(entity.origin)
  end if

  entity.moveInfo.state = gwconstants.STATE_BOTTOM
  entity.moveInfo.speed = entity.speed
  entity.moveInfo.accel = entity.speed
  entity.moveInfo.decel = entity.speed
  entity.moveInfo.wait = entity.wait
  entity.moveInfo.distance = distance
  entity.moveInfo.startOrigin = startOrigin
  entity.moveInfo.endOrigin = endOrigin
  entity.moveInfo.startAngles = gwvector.copy(entity.angles)
  entity.moveInfo.endAngles = gwvector.copy(entity.angles)
  if entity.wait == -1.0 then
    entity.spawnFlags = entity.spawnFlags | gwconstants.DOOR_TOGGLE
  end if
  world.callbacks.linkEntity(entity)
  return entity
end function

/// func_door_secret is a two-leg mover. It slides sideways, pauses, moves
/// forward, waits open, then reverses the same two legs.
/// @param entity entity value consumed by this operation.
/// @param world world value consumed by this operation.
function configureSecretDoorGeometry(entity, world)
  authoredAngles = entity.moveInfo.startAngles
  pitch = smath.degToRad(authoredAngles.x)
  yaw = smath.degToRad(authoredAngles.y)
  roll = smath.degToRad(authoredAngles.z)
  sp = smath.sin(pitch); cp = smath.cos(pitch)
  sy = smath.sin(yaw); cy = smath.cos(yaw)
  sr = smath.sin(roll); cr = smath.cos(roll)
  forward = qt.Vec3(cp * cy, cp * sy, -sp)
  right = qt.Vec3(-sr * sp * cy + cr * sy,
    -sr * sp * sy - cr * cy, -sr * cp)
  up = qt.Vec3(cr * sp * cy + sr * sy,
    cr * sp * sy - sr * cy, cr * cp)

  side = 1.0
  if (entity.spawnFlags & 2) != 0 then side = -1.0 end if
  firstDirection = right
  firstScale = side
  if (entity.spawnFlags & 4) != 0 then
    firstDirection = up
    firstScale = -1.0
  end if
  width = smath.abs(gwvector.dot(firstDirection, entity.size))
  length = smath.abs(gwvector.dot(forward, entity.size))
  entity.origin = gwvector.copy(entity.oldOrigin)
  entity.moveInfo.startOrigin = gwvector.multiplyAdd(entity.oldOrigin,
    firstScale * width, firstDirection)
  entity.moveInfo.endOrigin = gwvector.multiplyAdd(entity.moveInfo.startOrigin,
    length, forward)
  entity.moveInfo.distance = width + length
  entity.angles = qt.zeroVec3()
  world.callbacks.linkEntity(entity)
  return true
end function

/// Move secret door 2.
/// @param entity entity value consumed by this operation.
/// @param world world value consumed by this operation.
function secretDoorMove2(entity, world)
  entity.count = 3
  return moveCalc(entity, entity.moveInfo.endOrigin, secretDoorMove3, world)
end function

/// Move secret door 1.
/// @param entity entity value consumed by this operation.
/// @param world world value consumed by this operation.
function secretDoorMove1(entity, world)
  entity.count = 2
  entity.think = secretDoorMove2
  entity.nextThink = world.time + 1.0
  return true
end function

/// Move secret door 3.
/// @param entity entity value consumed by this operation.
/// @param world world value consumed by this operation.
function secretDoorMove3(entity, world)
  entity.moveInfo.state = gwconstants.STATE_TOP
  entity.count = 4
  if entity.soundIndex != 0 then
    world.callbacks.sound(entity, "doors/dr1_end.wav")
    entity.loopSound = 0
  end if
  if entity.wait == -1.0 then return true end if
  entity.think = secretDoorMove4
  entity.nextThink = world.time + entity.wait
  return true
end function

/// Move secret door 4.
/// @param entity entity value consumed by this operation.
/// @param world world value consumed by this operation.
function secretDoorMove4(entity, world)
  entity.moveInfo.state = gwconstants.STATE_DOWN
  entity.count = 5
  if entity.soundIndex != 0 then
    world.callbacks.sound(entity, "doors/dr1_strt.wav")
    entity.loopSound = entity.soundIndex
  end if
  return moveCalc(entity, entity.moveInfo.startOrigin, secretDoorMove5, world)
end function

/// Move secret door 5.
/// @param entity entity value consumed by this operation.
/// @param world world value consumed by this operation.
function secretDoorMove5(entity, world)
  entity.count = 6
  entity.think = secretDoorMove6
  entity.nextThink = world.time + 1.0
  return true
end function

/// Move secret door 6.
/// @param entity entity value consumed by this operation.
/// @param world world value consumed by this operation.
function secretDoorMove6(entity, world)
  entity.count = 7
  return moveCalc(entity, entity.oldOrigin, secretDoorDone, world)
end function

/// Return the secret door done value.
/// @param entity entity value consumed by this operation.
/// @param world world value consumed by this operation.
function secretDoorDone(entity, world)
  entity.moveInfo.state = gwconstants.STATE_BOTTOM
  entity.count = 0
  if entity.targetName == "" or (entity.spawnFlags & 1) != 0 then
    entity.health = 0
    entity.takeDamage = gwconstants.DAMAGE_YES
  end if
  if entity.soundIndex != 0 then
    world.callbacks.sound(entity, "doors/dr1_end.wav")
    entity.loopSound = 0
  end if
  doorUseAreaPortals(entity, false, world)
  return true
end function

/// Use secret door.
/// @param entity entity value consumed by this operation.
/// @param other other value consumed by this operation.
/// @param activator activator value consumed by this operation.
/// @param world world value consumed by this operation.
function secretDoorUse(entity, other, activator, world)
  if entity.moveInfo.state != gwconstants.STATE_BOTTOM or
      gwvector.equal(entity.origin, entity.oldOrigin) == false then return false end if
  entity.activator = activator
  entity.moveInfo.state = gwconstants.STATE_UP
  entity.count = 1
  if entity.soundIndex != 0 then
    world.callbacks.sound(entity, "doors/dr1_strt.wav")
    entity.loopSound = entity.soundIndex
  end if
  moveCalc(entity, entity.moveInfo.startOrigin, secretDoorMove1, world)
  doorUseAreaPortals(entity, true, world)
  return true
end function

/// Report whether secret door blocked.
/// @param entity entity value consumed by this operation.
/// @param other other value consumed by this operation.
/// @param world world value consumed by this operation.
function secretDoorBlocked(entity, other, world)
  if other is void then return false end if
  if other.isClient == false and (other.serverFlags & gwconstants.SVF_MONSTER) == 0 then
    world.callbacks.damage(other, entity, entity, 100000, gwconstants.MOD_CRUSH)
    gwcore.freeEntity(world, other)
    return true
  end if
  if world.time < entity.touchDebounceTime then return false end if
  entity.touchDebounceTime = world.time + 0.5
  world.callbacks.damage(other, entity, entity, entity.damage, gwconstants.MOD_CRUSH)
  return true
end function

/// Handle secret door.
/// @param entity entity value consumed by this operation.
/// @param inflictor inflictor value consumed by this operation.
/// @param attacker attacker value consumed by this operation.
/// @param damage damage value consumed by this operation.
/// @param point point value consumed by this operation.
/// @param world world value consumed by this operation.
function secretDoorDie(entity, inflictor, attacker, damage, point, world)
  entity.takeDamage = gwconstants.DAMAGE_NO
  return secretDoorUse(entity, attacker, attacker, world)
end function

/// Spawn secret door.
/// @param entity entity value consumed by this operation.
/// @param world world value consumed by this operation.
function spawnSecretDoor(entity, world)
  entity.moveType = gwconstants.MOVETYPE_PUSH
  entity.solid = gwconstants.SOLID_BSP
  entity.blocked = secretDoorBlocked
  entity.use = secretDoorUse
  entity.oldOrigin = gwvector.copy(entity.origin)
  entity.moveInfo.startAngles = gwvector.copy(entity.angles)
  if entity.damage == 0 then entity.damage = 2 end if
  if entity.wait == 0.0 then entity.wait = 5.0 end if
  entity.speed = 50.0
  entity.accel = 50.0
  entity.decel = 50.0
  entity.moveInfo.speed = 50.0
  entity.moveInfo.accel = 50.0
  entity.moveInfo.decel = 50.0
  entity.moveInfo.wait = entity.wait
  entity.moveInfo.state = gwconstants.STATE_BOTTOM
  entity.count = 0
  if entity.targetName == "" or (entity.spawnFlags & 1) != 0 then
    entity.health = 0
    entity.takeDamage = gwconstants.DAMAGE_YES
    entity.die = secretDoorDie
  else if entity.health != 0 then
    entity.maxHealth = entity.health
    entity.takeDamage = gwconstants.DAMAGE_YES
    entity.die = doorKilled
  end if
  configureSecretDoorGeometry(entity, world)
  return entity
end function

/// Return the rotating door hit bottom value.
/// @param entity entity value consumed by this operation.
/// @param world world value consumed by this operation.
function rotatingDoorHitBottom(entity, world)
  entity.angularVelocity = qt.zeroVec3()
  entity.angles = gwvector.copy(entity.moveInfo.startAngles)
  entity.moveInfo.state = gwconstants.STATE_BOTTOM
  if (entity.flags & gwconstants.FL_TEAMSLAVE) == 0 then
    if entity.soundIndex != 0 then world.callbacks.sound(entity, "doors/dr1_end.wav") end if
    entity.loopSound = 0
  end if
  doorUseAreaPortals(entity, false, world)
  world.callbacks.linkEntity(entity)
  return true
end function

/// Return the rotating door go down value.
/// @param entity entity value consumed by this operation.
/// @param world world value consumed by this operation.
function rotatingDoorGoDown(entity, world)
  entity.moveInfo.state = gwconstants.STATE_DOWN
  if (entity.flags & gwconstants.FL_TEAMSLAVE) == 0 and entity.soundIndex != 0 then
    world.callbacks.sound(entity, "doors/dr1_strt.wav")
    entity.loopSound = entity.soundIndex
  end if
  entity.angularVelocity = gwvector.scale(entity.moveDirection, -entity.moveInfo.speed)
  entity.think = rotatingDoorHitBottom
  entity.nextThink = world.time + entity.moveInfo.distance / entity.moveInfo.speed
  return true
end function

/// Return the rotating door hit top value.
/// @param entity entity value consumed by this operation.
/// @param world world value consumed by this operation.
function rotatingDoorHitTop(entity, world)
  entity.angularVelocity = qt.zeroVec3()
  entity.angles = gwvector.copy(entity.moveInfo.endAngles)
  entity.moveInfo.state = gwconstants.STATE_TOP
  if (entity.flags & gwconstants.FL_TEAMSLAVE) == 0 then
    if entity.soundIndex != 0 then world.callbacks.sound(entity, "doors/dr1_end.wav") end if
    entity.loopSound = 0
  end if
  if entity.wait >= 0.0 and (entity.spawnFlags & gwconstants.DOOR_TOGGLE) == 0 then
    entity.think = rotatingDoorGoDown
    entity.nextThink = world.time + entity.wait
  end if
  world.callbacks.linkEntity(entity)
  return true
end function

/// Return the rotating door go up value.
/// @param entity entity value consumed by this operation.
/// @param activator activator value consumed by this operation.
/// @param world world value consumed by this operation.
function rotatingDoorGoUp(entity, activator, world)
  if entity.moveInfo.state == gwconstants.STATE_UP then return false end if
  if entity.moveInfo.state == gwconstants.STATE_TOP then
    if entity.moveInfo.wait >= 0.0 then entity.nextThink = world.time + entity.moveInfo.wait end if
    return false
  end if
  entity.moveInfo.state = gwconstants.STATE_UP
  if (entity.flags & gwconstants.FL_TEAMSLAVE) == 0 and entity.soundIndex != 0 then
    world.callbacks.sound(entity, "doors/dr1_strt.wav")
    entity.loopSound = entity.soundIndex
  end if
  entity.angularVelocity = gwvector.scale(entity.moveDirection, entity.moveInfo.speed)
  entity.think = rotatingDoorHitTop
  entity.nextThink = world.time + entity.moveInfo.distance / entity.moveInfo.speed
  gwcore.useTargets(world, entity, activator)
  doorUseAreaPortals(entity, true, world)
  return true
end function

/// Use rotating door.
/// @param entity entity value consumed by this operation.
/// @param other other value consumed by this operation.
/// @param activator activator value consumed by this operation.
/// @param world world value consumed by this operation.
function rotatingDoorUse(entity, other, activator, world)
  if (entity.flags & gwconstants.FL_TEAMSLAVE) != 0 then return false end if
  entity.activator = activator
  if (entity.spawnFlags & gwconstants.DOOR_TOGGLE) != 0 and (entity.moveInfo.state == gwconstants.STATE_TOP or entity.moveInfo.state == gwconstants.STATE_UP) then
    member = entity
    while member is not void
      member.activator = activator
      member.message = ""
      member.touch = void
      rotatingDoorGoDown(member, world)
      member = member.teamChain
    end while
    return true
  end if
  member = entity
  while member is not void
    member.activator = activator
    member.message = ""
    member.touch = void
    rotatingDoorGoUp(member, activator, world)
    member = member.teamChain
  end while
  return true
end function

/// Spawn rotating door.
/// @param entity entity value consumed by this operation.
/// @param world world value consumed by this operation.
function spawnRotatingDoor(entity, world)
  // Keep spawn rotating door phases explicit: validate inputs, update owned state, then publish the result.
  entity.angles = qt.zeroVec3()
  entity.moveType = gwconstants.MOVETYPE_PUSH
  entity.solid = gwconstants.SOLID_BSP
  entity.blocked = doorBlocked
  entity.use = rotatingDoorUse
  entity.moveDirection = qt.zeroVec3()
  if (entity.spawnFlags & gwconstants.DOOR_X_AXIS) != 0 then entity.moveDirection.z = 1.0
  else if (entity.spawnFlags & gwconstants.DOOR_Y_AXIS) != 0 then entity.moveDirection.x = 1.0
  else entity.moveDirection.y = 1.0
  end if
  if (entity.spawnFlags & gwconstants.DOOR_REVERSE) != 0 then entity.moveDirection = gwvector.scale(entity.moveDirection, -1.0) end if
  if entity.speed == 0.0 then entity.speed = 100.0 end if
  if entity.accel == 0.0 then entity.accel = entity.speed end if
  if entity.decel == 0.0 then entity.decel = entity.speed end if
  if entity.wait == 0.0 then entity.wait = 3.0 end if
  if entity.damage == 0 then entity.damage = 2 end if
  distance = entity.moveInfo.distance
  if distance == 0.0 then distance = 90.0 end if
  entity.moveInfo.distance = distance
  entity.moveInfo.speed = entity.speed
  entity.moveInfo.accel = entity.accel
  entity.moveInfo.decel = entity.decel
  entity.moveInfo.wait = entity.wait
  entity.moveInfo.startAngles = gwvector.copy(entity.angles)
  entity.moveInfo.endAngles = gwvector.multiplyAdd(entity.angles, distance, entity.moveDirection)
  if (entity.spawnFlags & gwconstants.DOOR_START_OPEN) != 0 then
    entity.angles = gwvector.copy(entity.moveInfo.endAngles)
    entity.moveInfo.endAngles = gwvector.copy(entity.moveInfo.startAngles)
    entity.moveInfo.startAngles = gwvector.copy(entity.angles)
    entity.moveDirection = gwvector.scale(entity.moveDirection, -1.0)
  end if
  entity.moveInfo.state = gwconstants.STATE_BOTTOM
  if entity.health != 0 then
    entity.takeDamage = gwconstants.DAMAGE_YES
    entity.die = doorKilled
    entity.maxHealth = entity.health
  end if
  if entity.targetName != "" and entity.message != "" then entity.touch = doorTouch end if
  if (entity.spawnFlags & 16) != 0 then entity.effects = entity.effects | gwconstants.EF_ANIM_ALL end if
  if entity.teamMaster is void then entity.teamMaster = entity end if
  world.callbacks.linkEntity(entity)
  if entity.health != 0 or entity.targetName != "" then entity.think = calculateDoorMoveSpeed
  else entity.think = spawnDoorTrigger end if
  entity.nextThink = world.time + world.frameTime
  return entity
end function

/// func_plat
/// @param entity entity value consumed by this operation.
/// @param world world value consumed by this operation.

function platHitTop(entity, world)
  entity.moveInfo.state = gwconstants.STATE_TOP
  if (entity.flags & gwconstants.FL_TEAMSLAVE) == 0 then
    if entity.soundIndex != 0 then world.callbacks.sound(entity, "plats/pt1_end.wav") end if
    entity.loopSound = 0
  end if
  entity.think = platGoDown
  entity.nextThink = world.time + 3.0
  return true
end function

/// Return the plat hit bottom value.
/// @param entity entity value consumed by this operation.
/// @param world world value consumed by this operation.
function platHitBottom(entity, world)
  entity.moveInfo.state = gwconstants.STATE_BOTTOM
  if (entity.flags & gwconstants.FL_TEAMSLAVE) == 0 then
    if entity.soundIndex != 0 then world.callbacks.sound(entity, "plats/pt1_end.wav") end if
    entity.loopSound = 0
  end if
  return true
end function

/// Return the plat go down value.
/// @param entity entity value consumed by this operation.
/// @param world world value consumed by this operation.
function platGoDown(entity, world)
  entity.moveInfo.state = gwconstants.STATE_DOWN
  if (entity.flags & gwconstants.FL_TEAMSLAVE) == 0 and entity.soundIndex != 0 then
    world.callbacks.sound(entity, "plats/pt1_strt.wav")
    entity.loopSound = entity.soundIndex
  end if
  return moveCalc(entity, entity.moveInfo.endOrigin, platHitBottom, world)
end function

/// Return the plat go up value.
/// @param entity entity value consumed by this operation.
/// @param world world value consumed by this operation.
function platGoUp(entity, world)
  entity.moveInfo.state = gwconstants.STATE_UP
  if (entity.flags & gwconstants.FL_TEAMSLAVE) == 0 and entity.soundIndex != 0 then
    world.callbacks.sound(entity, "plats/pt1_strt.wav")
    entity.loopSound = entity.soundIndex
  end if
  return moveCalc(entity, entity.moveInfo.startOrigin, platHitTop, world)
end function

/// Use plat.
/// @param entity entity value consumed by this operation.
/// @param other other value consumed by this operation.
/// @param activator activator value consumed by this operation.
/// @param world world value consumed by this operation.
function platUse(entity, other, activator, world)
  if entity.nextThink != 0.0 then return false end if
  return platGoDown(entity, world)
end function

/// Handle plat center.
/// @param trigger trigger value consumed by this operation.
/// @param other other value consumed by this operation.
/// @param world world value consumed by this operation.
function platCenterTouch(trigger, other, world)
  if other is void or other.isClient == false or other.health <= 0 then return false end if
  plat = trigger.enemy
  if plat is void or plat.inUse == false then return false end if
  if plat.moveInfo.state == gwconstants.STATE_BOTTOM then return platGoUp(plat, world) end if
  if plat.moveInfo.state == gwconstants.STATE_TOP then
    plat.nextThink = world.time + 1.0
    return true
  end if
  return false
end function

/// Report whether spawn plat inside trigger.
/// @param entity entity value consumed by this operation.
/// @param world world value consumed by this operation.
function spawnPlatInsideTrigger(entity, world)
  trigger = gwcore.spawnEntity(world, "plat_trigger")
  trigger.touch = platCenterTouch
  trigger.moveType = gwconstants.MOVETYPE_NONE
  trigger.solid = gwconstants.SOLID_TRIGGER
  trigger.enemy = entity
  trigger.mins = qt.Vec3(entity.mins.x + 25.0, entity.mins.y + 25.0, entity.mins.z)
  trigger.maxs = qt.Vec3(entity.maxs.x - 25.0, entity.maxs.y - 25.0, entity.maxs.z + 8.0)
  trigger.mins.z = trigger.maxs.z -
    (entity.moveInfo.startOrigin.z - entity.moveInfo.endOrigin.z + entity.lip)
  if (entity.spawnFlags & gwconstants.PLAT_LOW_TRIGGER) != 0 then
    trigger.maxs.z = trigger.mins.z + 8.0
  end if
  if trigger.maxs.x - trigger.mins.x <= 0.0 then
    trigger.mins.x = (entity.mins.x + entity.maxs.x) * 0.5
    trigger.maxs.x = trigger.mins.x + 1.0
  end if
  if trigger.maxs.y - trigger.mins.y <= 0.0 then
    trigger.mins.y = (entity.mins.y + entity.maxs.y) * 0.5
    trigger.maxs.y = trigger.mins.y + 1.0
  end if
  world.callbacks.linkEntity(trigger)
  return true
end function

/// Report whether plat blocked.
/// @param entity entity value consumed by this operation.
/// @param other other value consumed by this operation.
/// @param world world value consumed by this operation.
function platBlocked(entity, other, world)
  if other.isClient == false and (other.serverFlags & gwconstants.SVF_MONSTER) == 0 then
    world.callbacks.damage(other, entity, entity, 100000, gwconstants.MOD_CRUSH)
    gwcore.freeEntity(world, other)
    return true
  end if
  world.callbacks.damage(other, entity, entity, entity.damage, gwconstants.MOD_CRUSH)
  if entity.moveInfo.state == gwconstants.STATE_UP then return platGoDown(entity, world) end if
  if entity.moveInfo.state == gwconstants.STATE_DOWN then return platGoUp(entity, world) end if
  return true
end function

/// Spawn plat.
/// @param entity entity value consumed by this operation.
/// @param world world value consumed by this operation.
function spawnPlat(entity, world)
  entity.angles = qt.zeroVec3()
  entity.solid = gwconstants.SOLID_BSP
  entity.moveType = gwconstants.MOVETYPE_PUSH
  entity.blocked = platBlocked
  if entity.speed == 0.0 then entity.speed = 20.0 else entity.speed = entity.speed * 0.1 end if
  if entity.accel == 0.0 then entity.accel = 5.0 else entity.accel = entity.accel * 0.1 end if
  if entity.decel == 0.0 then entity.decel = 5.0 else entity.decel = entity.decel * 0.1 end if
  if entity.damage == 0 then entity.damage = 2 end if
  if entity.lip == 0.0 then entity.lip = 8.0 end if
  top = gwvector.copy(entity.origin)
  bottom = gwvector.copy(entity.origin)
  if entity.height != 0.0 then bottom.z = bottom.z - entity.height else bottom.z = bottom.z - (entity.maxs.z - entity.mins.z) + entity.lip end if
  entity.use = platUse
  if entity.targetName != "" then
    entity.moveInfo.state = gwconstants.STATE_UP
  else
    entity.origin = gwvector.copy(bottom)
    entity.moveInfo.state = gwconstants.STATE_BOTTOM
  end if
  entity.moveInfo.speed = entity.speed
  entity.moveInfo.accel = entity.accel
  entity.moveInfo.decel = entity.decel
  entity.moveInfo.wait = entity.wait
  entity.moveInfo.startOrigin = top
  entity.moveInfo.endOrigin = bottom
  world.callbacks.linkEntity(entity)
  entity.think = spawnPlatInsideTrigger
  entity.nextThink = world.time + world.frameTime
  return entity
end function

/// Inline BSP bounds arrive through game_import_t.setmodel after the managed
/// spawn callbacks have established behavior. Rebuild only the geometric
/// endpoints here; do not reapply speed scaling or allocate trigger helpers.
/// @param entity entity value consumed by this operation.
/// @param world world value consumed by this operation.
function refreshBrushGeometry(entity, world)
  // Keep refresh brush geometry phases explicit: validate inputs, update owned state, then publish the result.
  if entity.className == "func_button" then
    startOrigin = gwvector.copy(entity.moveInfo.startOrigin)
    distance = smath.abs(entity.moveDirection.x) * entity.size.x + smath.abs(entity.moveDirection.y) * entity.size.y + smath.abs(entity.moveDirection.z) * entity.size.z - entity.lip
    entity.origin = gwvector.copy(startOrigin)
    entity.moveInfo.endOrigin = gwvector.multiplyAdd(startOrigin, distance, entity.moveDirection)
    world.callbacks.linkEntity(entity)
    return true
  end if
  if entity.className == "func_water" then
    closedOrigin = entity.moveInfo.startOrigin
    if (entity.spawnFlags & gwconstants.DOOR_START_OPEN) != 0 then
      closedOrigin = entity.moveInfo.endOrigin
    end if
    entity.origin = gwvector.copy(closedOrigin)
    return spawnWater(entity, world)
  end if
  if entity.className == "func_door_secret" then
    return configureSecretDoorGeometry(entity, world)
  end if
  if entity.className == "func_door" then
    closedOrigin = entity.moveInfo.startOrigin
    if (entity.spawnFlags & gwconstants.DOOR_START_OPEN) != 0 then closedOrigin = entity.moveInfo.endOrigin end if
    entity.origin = gwvector.copy(closedOrigin)
    return spawnDoor(entity, world)
  end if
  if entity.className == "func_plat" then
    top = gwvector.copy(entity.moveInfo.startOrigin)
    bottom = gwvector.copy(top)
    if entity.height != 0.0 then bottom.z = bottom.z - entity.height else bottom.z = bottom.z - entity.size.z + entity.lip end if
    entity.moveInfo.startOrigin = top
    entity.moveInfo.endOrigin = bottom
    if entity.targetName != "" then entity.origin = gwvector.copy(top) else entity.origin = gwvector.copy(bottom) end if
    world.callbacks.linkEntity(entity)
    return true
  end if
  world.callbacks.linkEntity(entity)
  return true
end function

/// func_train
/// @param entity entity value consumed by this operation.
/// @param world world value consumed by this operation.

function trainWait(entity, world)
  corner = entity.targetEntity
  if corner is not void and corner.pathTarget != "" then
    savedTarget = corner.target
    corner.target = corner.pathTarget
    gwcore.useTargets(world, corner, entity.activator)
    corner.target = savedTarget
    if entity.inUse == false then return false end if
  end if
  if entity.moveInfo.wait != 0.0 then
    if entity.moveInfo.wait > 0.0 then
      entity.nextThink = world.time + entity.moveInfo.wait
      entity.think = trainNext
    else if (entity.spawnFlags & gwconstants.TRAIN_TOGGLE) != 0 then
      trainNext(entity, world)
      entity.spawnFlags = entity.spawnFlags & ~gwconstants.TRAIN_START_ON
      entity.velocity = qt.zeroVec3()
      entity.nextThink = 0.0
    end if
    if (entity.flags & gwconstants.FL_TEAMSLAVE) == 0 then entity.loopSound = 0 end if
  else
    trainNext(entity, world)
  end if
  return true
end function

/// Return the train next value.
/// @param entity entity value consumed by this operation.
/// @param world world value consumed by this operation.
function trainNext(entity, world)
  first = true
  searching = true
  while searching
    searching = false
    if entity.target == "" then return false end if
    corner = gwcore.pickTarget(world, entity.target)
    if corner is void then return false end if
    entity.target = corner.target
    if (corner.spawnFlags & 1) != 0 then
      if first == false then
        gwcore.log(world, "connected teleport path_corners")
        return false
      end if
      first = false
      entity.origin = gwvector.subtract(corner.origin, entity.mins)
      entity.oldOrigin = gwvector.copy(entity.origin)
      world.callbacks.linkEntity(entity)
      searching = true
    else
      entity.moveInfo.wait = corner.wait
      entity.targetEntity = corner
      destination = gwvector.subtract(corner.origin, entity.mins)
      entity.moveInfo.state = gwconstants.STATE_TOP
      entity.moveInfo.startOrigin = gwvector.copy(entity.origin)
      entity.moveInfo.endOrigin = gwvector.copy(destination)
      if (entity.flags & gwconstants.FL_TEAMSLAVE) == 0 then
        entity.loopSound = entity.soundIndex
      end if
      moveCalc(entity, destination, trainWait, world)
      entity.spawnFlags = entity.spawnFlags | gwconstants.TRAIN_START_ON
    end if
  end while
  return true
end function

/// Resume train.
/// @param entity entity value consumed by this operation.
/// @param world world value consumed by this operation.
function trainResume(entity, world)
  if entity.targetEntity is void then return false end if
  destination = gwvector.subtract(entity.targetEntity.origin, entity.mins)
  entity.moveInfo.state = gwconstants.STATE_TOP
  entity.moveInfo.startOrigin = gwvector.copy(entity.origin)
  entity.moveInfo.endOrigin = gwvector.copy(destination)
  if (entity.flags & gwconstants.FL_TEAMSLAVE) == 0 then
    entity.loopSound = entity.soundIndex
  end if
  moveCalc(entity, destination, trainWait, world)
  entity.spawnFlags = entity.spawnFlags | gwconstants.TRAIN_START_ON
  return true
end function

/// Find train.
/// @param entity entity value consumed by this operation.
/// @param world world value consumed by this operation.
function trainFind(entity, world)
  if entity.target == "" then
    gwcore.log(world, "train_find: no target")
    return false
  end if
  corner = gwcore.pickTarget(world, entity.target)
  if corner is void then return false end if
  entity.target = corner.target
  entity.origin = gwvector.subtract(corner.origin, entity.mins)
  world.callbacks.linkEntity(entity)
  if entity.targetName == "" then entity.spawnFlags = entity.spawnFlags | gwconstants.TRAIN_START_ON end if
  if (entity.spawnFlags & gwconstants.TRAIN_START_ON) != 0 then
    entity.nextThink = world.time + world.frameTime
    entity.think = trainNext
    entity.activator = entity
  end if
  return true
end function

/// Use train.
/// @param entity entity value consumed by this operation.
/// @param other other value consumed by this operation.
/// @param activator activator value consumed by this operation.
/// @param world world value consumed by this operation.
function trainUse(entity, other, activator, world)
  entity.activator = activator
  if (entity.spawnFlags & gwconstants.TRAIN_START_ON) != 0 then
    if (entity.spawnFlags & gwconstants.TRAIN_TOGGLE) == 0 then return false end if
    entity.spawnFlags = entity.spawnFlags & ~gwconstants.TRAIN_START_ON
    entity.velocity = qt.zeroVec3()
    entity.nextThink = 0.0
    if (entity.flags & gwconstants.FL_TEAMSLAVE) == 0 then entity.loopSound = 0 end if
  else if entity.targetEntity is not void then
    trainResume(entity, world)
  else
    trainNext(entity, world)
  end if
  return true
end function

/// Report whether train blocked.
/// @param entity entity value consumed by this operation.
/// @param other other value consumed by this operation.
/// @param world world value consumed by this operation.
function trainBlocked(entity, other, world)
  if other.isClient == false and (other.serverFlags & gwconstants.SVF_MONSTER) == 0 then
    world.callbacks.damage(other, entity, entity, 100000, gwconstants.MOD_CRUSH)
    gwcore.freeEntity(world, other)
    return true
  end if
  if world.time < entity.touchDebounceTime or entity.damage == 0 then return false end if
  entity.touchDebounceTime = world.time + 0.5
  world.callbacks.damage(other, entity, entity, entity.damage, gwconstants.MOD_CRUSH)
  return true
end function

/// Spawn train.
/// @param entity entity value consumed by this operation.
/// @param world world value consumed by this operation.
function spawnTrain(entity, world)
  entity.moveType = gwconstants.MOVETYPE_PUSH
  entity.angles = qt.zeroVec3()
  entity.blocked = trainBlocked
  if (entity.spawnFlags & gwconstants.TRAIN_BLOCK_STOPS) != 0 then entity.damage = 0 else if entity.damage == 0 then entity.damage = 100 end if
  entity.solid = gwconstants.SOLID_BSP
  if entity.speed == 0.0 then entity.speed = 100.0 end if
  entity.moveInfo.speed = entity.speed
  entity.moveInfo.accel = entity.speed
  entity.moveInfo.decel = entity.speed
  entity.use = trainUse
  world.callbacks.linkEntity(entity)
  if entity.target != "" then
    entity.nextThink = world.time + world.frameTime
    entity.think = trainFind
  else
    gwcore.log(world, "func_train without a target")
  end if
  return entity
end function

/// trigger_elevator from g_func.c. The train remains the authoritative mover;
/// the trigger only resolves a requested path_corner and resumes it.
/// @param entity entity value consumed by this operation.
/// @param other other value consumed by this operation.
/// @param activator activator value consumed by this operation.
/// @param world world value consumed by this operation.

function elevatorUse(entity, other, activator, world)
  train = entity.targetEntity
  if train is void or typeof(train) != "struct" or train.inUse == false or train.className != "func_train" then
    gwcore.log(world, "trigger_elevator has no active train")
    return false
  end if
  if train.nextThink != 0.0 then return false end if
  if other is void or typeof(other) != "struct" or typeof(other.pathTarget) != "string" or other.pathTarget == "" then
    gwcore.log(world, "elevator used with no pathtarget")
    return false
  end if
  corner = gwcore.pickTarget(world, other.pathTarget)
  if corner is void then
    gwcore.log(world, "elevator used with bad pathtarget: " + other.pathTarget)
    return false
  end if
  train.targetEntity = corner
  train.activator = activator
  return trainResume(train, world)
end function

/// Initialize elevator.
/// @param entity entity value consumed by this operation.
/// @param world world value consumed by this operation.
function elevatorInit(entity, world)
  if entity.target == "" then
    gwcore.log(world, "trigger_elevator has no target")
    return false
  end if
  train = gwcore.pickTarget(world, entity.target)
  if train is void then
    gwcore.log(world, "trigger_elevator unable to find target " + entity.target)
    return false
  end if
  if train.className != "func_train" then
    gwcore.log(world, "trigger_elevator target " + entity.target + " is not a train")
    return false
  end if
  entity.targetEntity = train
  entity.use = elevatorUse
  entity.serverFlags = gwconstants.SVF_NOCLIENT
  return true
end function

/// Spawn elevator.
/// @param entity entity value consumed by this operation.
/// @param world world value consumed by this operation.
function spawnElevator(entity, world)
  entity.think = elevatorInit
  entity.nextThink = world.time + world.frameTime
  return entity
end function

/// func_timer
/// @param entity entity value consumed by this operation.
/// @param world world value consumed by this operation.

function timerThink(entity, world)
  gwcore.useTargets(world, entity, entity.activator)
  entity.nextThink = world.time + entity.wait + world.callbacks.randomSigned() * entity.random
  entity.think = timerThink
  return true
end function

/// Use timer.
/// @param entity entity value consumed by this operation.
/// @param other other value consumed by this operation.
/// @param activator activator value consumed by this operation.
/// @param world world value consumed by this operation.
function timerUse(entity, other, activator, world)
  entity.activator = activator
  if entity.nextThink != 0.0 then
    entity.nextThink = 0.0
    return true
  end if
  if entity.delay != 0.0 then
    entity.nextThink = world.time + entity.delay
    entity.think = timerThink
  else
    timerThink(entity, world)
  end if
  return true
end function

/// Spawn timer.
/// @param entity entity value consumed by this operation.
/// @param world world value consumed by this operation.
function spawnTimer(entity, world)
  if entity.wait == 0.0 then entity.wait = 1.0 end if
  entity.use = timerUse
  entity.think = timerThink
  if entity.random >= entity.wait then
    entity.random = entity.wait - world.frameTime
    gwcore.log(world, "func_timer random >= wait")
  end if
  if (entity.spawnFlags & 1) != 0 then
    entity.nextThink = world.time + 1.0 + entity.pauseTime + entity.delay + entity.wait + world.callbacks.randomSigned() * entity.random
    entity.activator = entity
  end if
  entity.serverFlags = gwconstants.SVF_NOCLIENT
  return entity
end function

/// func_conveyor
/// @param entity entity value consumed by this operation.
/// @param other other value consumed by this operation.
/// @param activator activator value consumed by this operation.
/// @param world world value consumed by this operation.

function conveyorUse(entity, other, activator, world)
  if (entity.spawnFlags & 1) != 0 then
    entity.speed = 0.0
    entity.spawnFlags = entity.spawnFlags & ~1
  else
    entity.speed = entity.count
    entity.spawnFlags = entity.spawnFlags | 1
  end if
  if (entity.spawnFlags & 2) == 0 then entity.count = 0 end if
  return true
end function

/// Spawn conveyor.
/// @param entity entity value consumed by this operation.
/// @param world world value consumed by this operation.
function spawnConveyor(entity, world)
  if entity.speed == 0.0 then entity.speed = 100.0 end if
  if (entity.spawnFlags & 1) == 0 then
    entity.count = entity.speed
    entity.speed = 0.0
  end if
  entity.use = conveyorUse
  entity.solid = gwconstants.SOLID_BSP
  world.callbacks.linkEntity(entity)
  return entity
end function

/// func_explosive from g_misc.c (kept here with the brush movers).
/// @param entity entity value consumed by this operation.
/// @param inflictor inflictor value consumed by this operation.
/// @param attacker attacker value consumed by this operation.
/// @param damage damage value consumed by this operation.
/// @param point point value consumed by this operation.
/// @param world world value consumed by this operation.

function explosiveExplode(entity, inflictor, attacker, damage, point, world)
  halfSize = gwvector.scale(entity.size, 0.5)
  entity.origin = gwvector.add(entity.absoluteMins, halfSize)
  entity.takeDamage = gwconstants.DAMAGE_NO
  if entity.damage != 0 then world.callbacks.radiusDamage(entity, attacker, entity.damage, entity.damage + 40, gwconstants.MOD_EXPLOSIVE) end if
  if inflictor is not void then
    impactDelta = gwvector.subtract(entity.origin, inflictor.origin)
    direction = gwvector.normalized(impactDelta)
    impactDirection = direction[0]
    entity.velocity = gwvector.scale(impactDirection, 150.0)
  end if
  effectiveMass = entity.mass
  if effectiveMass == 0 then effectiveMass = 75 end if
  largeCount = 0
  if effectiveMass >= 100 then largeCount = qbyteio.truncInt(effectiveMass / 100.0); if largeCount > 8 then largeCount = 8 end if end if
  smallCount = qbyteio.truncInt(effectiveMass / 25.0)
  if smallCount > 16 then smallCount = 16 end if
  world.callbacks.effect("debris-large", entity.origin, 1, largeCount)
  world.callbacks.effect("debris-small", entity.origin, 2, smallCount)
  gwcore.useTargets(world, entity, attacker)
  if entity.damage != 0 then world.callbacks.effect("explosion", entity.origin, 0, 1) end if
  gwcore.freeEntity(world, entity)
  return true
end function

/// Use explosive.
/// @param entity entity value consumed by this operation.
/// @param other other value consumed by this operation.
/// @param activator activator value consumed by this operation.
/// @param world world value consumed by this operation.
function explosiveUse(entity, other, activator, world)
  return explosiveExplode(entity, entity, other, entity.health, qt.zeroVec3(), world)
end function

/// Spawn explosive.
/// @param entity entity value consumed by this operation.
/// @param other other value consumed by this operation.
/// @param activator activator value consumed by this operation.
/// @param world world value consumed by this operation.
function explosiveSpawn(entity, other, activator, world)
  entity.solid = gwconstants.SOLID_BSP
  entity.serverFlags = entity.serverFlags & ~gwconstants.SVF_NOCLIENT
  entity.use = void
  world.callbacks.killBox(entity)
  world.callbacks.linkEntity(entity)
  return true
end function

/// Spawn explosive.
/// @param entity entity value consumed by this operation.
/// @param world world value consumed by this operation.
/// @param deathmatch deathmatch value consumed by this operation.
function spawnExplosive(entity, world, deathmatch)
  if deathmatch then
    gwcore.freeEntity(world, entity)
    return false
  end if
  entity.moveType = gwconstants.MOVETYPE_PUSH
  if (entity.spawnFlags & 1) != 0 then
    entity.serverFlags = entity.serverFlags | gwconstants.SVF_NOCLIENT
    entity.solid = gwconstants.SOLID_NOT
    entity.use = explosiveSpawn
  else
    entity.solid = gwconstants.SOLID_BSP
    if entity.targetName != "" then entity.use = explosiveUse end if
    if entity.targetName == "" then
      if entity.health == 0 then entity.health = 100 end if
      entity.die = explosiveExplode
      entity.takeDamage = gwconstants.DAMAGE_YES
    end if
  end if
  if (entity.spawnFlags & 2) != 0 then entity.effects = entity.effects | gwconstants.EF_ANIM_ALL end if
  if (entity.spawnFlags & 4) != 0 then entity.effects = entity.effects | gwconstants.EF_ANIM_ALLFAST end if
  world.callbacks.linkEntity(entity)
  return entity
end function

/// func_killbox from g_func.c.
/// @param entity entity value consumed by this operation.
/// @param other other value consumed by this operation.
/// @param activator activator value consumed by this operation.
/// @param world world value consumed by this operation.

function killBoxUse(entity, other, activator, world)
  world.callbacks.killBox(entity)
  gwcore.emit(world, "killbox", entity, entity.model)
  return true
end function

/// Spawn kill box.
/// @param entity entity value consumed by this operation.
/// @param world world value consumed by this operation.
function spawnKillBox(entity, world)
  if entity.model == "" then
    gwcore.log(world, "func_killbox with no model")
    gwcore.freeEntity(world, entity)
    return false
  end if
  world.callbacks.setModel(entity, entity.model)
  // Stock SP_func_killbox keeps the inline hull as an invisible use-time
  // volume; it is never a linked BSP obstacle. The generic func_* parser
  // defaults must therefore be cleared explicitly.
  entity.solid = gwconstants.SOLID_NOT
  entity.moveType = gwconstants.MOVETYPE_NONE
  entity.use = killBoxUse
  entity.serverFlags = gwconstants.SVF_NOCLIENT
  return entity
end function

/// Spawn func button.
/// @param entity entity value consumed by this operation.
/// @param world world value consumed by this operation.
function SP_func_button(entity, world)
  return spawnButton(entity, world)
end function
/// Spawn func door.
/// @param entity entity value consumed by this operation.
/// @param world world value consumed by this operation.
function SP_func_door(entity, world)
  return spawnDoor(entity, world)
end function
/// Spawn func water.
/// @param entity entity value consumed by this operation.
/// @param world world value consumed by this operation.
function SP_func_water(entity, world)
  return spawnWater(entity, world)
end function
/// Spawn func door secret.
/// @param entity entity value consumed by this operation.
/// @param world world value consumed by this operation.
function SP_func_door_secret(entity, world)
  return spawnSecretDoor(entity, world)
end function
/// Spawn func plat.
/// @param entity entity value consumed by this operation.
/// @param world world value consumed by this operation.
function SP_func_plat(entity, world)
  return spawnPlat(entity, world)
end function
/// Spawn func train.
/// @param entity entity value consumed by this operation.
/// @param world world value consumed by this operation.
function SP_func_train(entity, world)
  return spawnTrain(entity, world)
end function
/// Spawn func timer.
/// @param entity entity value consumed by this operation.
/// @param world world value consumed by this operation.
function SP_func_timer(entity, world)
  return spawnTimer(entity, world)
end function
/// Spawn func conveyor.
/// @param entity entity value consumed by this operation.
/// @param world world value consumed by this operation.
function SP_func_conveyor(entity, world)
  return spawnConveyor(entity, world)
end function
/// Spawn func explosive.
/// @param entity entity value consumed by this operation.
/// @param world world value consumed by this operation.
/// @param deathmatch deathmatch value consumed by this operation.
function SP_func_explosive(entity, world, deathmatch)
  return spawnExplosive(entity, world, deathmatch)
end function
/// Spawn func killbox.
/// @param entity entity value consumed by this operation.
/// @param world world value consumed by this operation.
function SP_func_killbox(entity, world)
  return spawnKillBox(entity, world)
end function
/// Spawn trigger elevator.
/// @param entity entity value consumed by this operation.
/// @param world world value consumed by this operation.
function SP_trigger_elevator(entity, world)
  return spawnElevator(entity, world)
end function

/// Rebind serialized callback identities from classname/state. Function values
/// are deliberately not written to disk; the deterministic spawn path restores
/// behavior and this boundary restores the currently pending mover callback.
/// @param entity entity value consumed by this operation.
/// @param world world value consumed by this operation.
function restoreMoverState(entity, world)
  // Keep restore mover state phases explicit: validate inputs, update owned state, then publish the result.
  entity.moveInfo = gwtypes.stabilizeMoveInfo(entity.moveInfo)
  entity.moveDirection = gwtypes.vec3FromValue(entity.moveDirection, "restore mover moveDirection")
  if entity.nextThink <= 0.0 then return entity end if
  name = entity.className
  state = entity.moveInfo.state
  if name == "func_door_rotating" then
    if state == gwconstants.STATE_UP then entity.think = rotatingDoorHitTop
    else if state == gwconstants.STATE_DOWN then entity.think = rotatingDoorHitBottom
    else if state == gwconstants.STATE_TOP then entity.think = rotatingDoorGoDown
    end if
  else if name == "func_door_secret" then
    if entity.count == 2 then entity.think = secretDoorMove2
    else if entity.count == 3 then entity.think = secretDoorMove3
    else if entity.count == 4 then entity.think = secretDoorMove4
    else if entity.count == 5 then entity.think = secretDoorMove5
    else if entity.count == 6 then entity.think = secretDoorMove6
    else if entity.count == 7 then entity.think = secretDoorDone
    end if
  else if name == "func_door" or name == "func_water" then
    if state == gwconstants.STATE_UP then entity.think = doorHitTop
    else if state == gwconstants.STATE_DOWN then entity.think = doorHitBottom
    else if state == gwconstants.STATE_TOP then entity.think = doorGoDown
    end if
  else if name == "func_plat" then
    if state == gwconstants.STATE_UP then entity.think = platHitTop
    else if state == gwconstants.STATE_DOWN then entity.think = platHitBottom
    else if state == gwconstants.STATE_TOP then entity.think = platGoDown
    end if
  else if name == "func_button" then
    if state == gwconstants.STATE_UP then entity.think = buttonWait
    else if state == gwconstants.STATE_DOWN then entity.think = buttonDone
    else if state == gwconstants.STATE_TOP then entity.think = buttonReturn
    end if
  else if name == "func_train" then
    entity.think = trainNext
  end if
  return entity
end function
