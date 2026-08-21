/* Linear mover support and BaseQ2 button, door, plat, train and timer logic. */
package miniquake2.game.world.movers

import std.math as smath
import miniquake2.qcommon.types as qt
import miniquake2.qcommon.byteio as qbyteio
import miniquake2.game.world.constants as gwconstants
import miniquake2.game.world.core as gwcore
import miniquake2.game.world.vector as gwvector
import miniquake2.game.world.types as gwtypes

function moveDone(entity, world)
  entity.velocity = qt.zeroVec3()
  if entity.moveInfo.endFunction is not void then entity.moveInfo.endFunction(entity, world) end if
  return true
end function

function moveFinal(entity, world)
  if entity.moveInfo.remainingDistance == 0.0 then return moveDone(entity, world) end if
  entity.velocity = gwvector.scale(entity.moveInfo.direction, entity.moveInfo.remainingDistance / world.frameTime)
  entity.think = moveDone
  entity.nextThink = world.time + world.frameTime
  return true
end function

function moveBegin(entity, world)
  if entity.moveInfo.speed * world.frameTime >= entity.moveInfo.remainingDistance then return moveFinal(entity, world) end if
  entity.velocity = gwvector.scale(entity.moveInfo.direction, entity.moveInfo.speed)
  frames = smath.floor((entity.moveInfo.remainingDistance / entity.moveInfo.speed) / world.frameTime)
  entity.moveInfo.remainingDistance = entity.moveInfo.remainingDistance - frames * entity.moveInfo.speed * world.frameTime
  entity.nextThink = world.time + frames * world.frameTime
  entity.think = moveFinal
  return true
end function

function accelerationDistance(target, rate)
  return target * ((target / rate) + 1.0) / 2.0
end function

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

// -------------------------------------------------------------------------
// func_button

function buttonDone(entity, world)
  entity.moveInfo.state = gwconstants.STATE_BOTTOM
  entity.effects = entity.effects & ~gwconstants.EF_ANIM23
  entity.effects = entity.effects | gwconstants.EF_ANIM01
  return true
end function

function buttonReturn(entity, world)
  entity.moveInfo.state = gwconstants.STATE_DOWN
  moveCalc(entity, entity.moveInfo.startOrigin, buttonDone, world)
  entity.frame = 0
  if entity.health != 0 then entity.takeDamage = gwconstants.DAMAGE_YES end if
  return true
end function

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

function buttonFire(entity, world)
  if entity.moveInfo.state == gwconstants.STATE_UP or entity.moveInfo.state == gwconstants.STATE_TOP then return false end if
  entity.moveInfo.state = gwconstants.STATE_UP
  moveCalc(entity, entity.moveInfo.endOrigin, buttonWait, world)
  return true
end function

function buttonUse(entity, other, activator, world)
  entity.activator = activator
  return buttonFire(entity, world)
end function

function buttonTouch(entity, other, world)
  if other is void or other.isClient == false or other.health <= 0 then return false end if
  entity.activator = other
  return buttonFire(entity, world)
end function

function buttonKilled(entity, inflictor, attacker, damage, point, world)
  entity.activator = attacker
  entity.health = entity.maxHealth
  entity.takeDamage = gwconstants.DAMAGE_NO
  return buttonFire(entity, world)
end function

function spawnButton(entity, world)
  entity.moveDirection = gwvector.movedir(entity.angles)
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

// -------------------------------------------------------------------------
// func_door

function doorUseAreaPortals(entity, isOpen, world)
  if entity.target == "" then return false end if
  for each targetEntity in gwcore.matchingTargets(world, entity.target)
    if targetEntity.className == "func_areaportal" then world.callbacks.areaPortal(targetEntity.style, isOpen) end if
  end for
  return true
end function

function doorHitTop(entity, world)
  entity.moveInfo.state = gwconstants.STATE_TOP
  entity.loopSound = 0
  if (entity.spawnFlags & gwconstants.DOOR_TOGGLE) != 0 then return true end if
  if entity.moveInfo.wait >= 0.0 then
    entity.think = doorGoDown
    entity.nextThink = world.time + entity.moveInfo.wait
  end if
  return true
end function

function doorHitBottom(entity, world)
  entity.moveInfo.state = gwconstants.STATE_BOTTOM
  entity.loopSound = 0
  doorUseAreaPortals(entity, false, world)
  return true
end function

function doorGoDown(entity, world)
  if entity.maxHealth != 0 then
    entity.takeDamage = gwconstants.DAMAGE_YES
    entity.health = entity.maxHealth
  end if
  entity.moveInfo.state = gwconstants.STATE_DOWN
  return moveCalc(entity, entity.moveInfo.startOrigin, doorHitBottom, world)
end function

function doorGoUp(entity, activator, world)
  if entity.moveInfo.state == gwconstants.STATE_UP then return false end if
  if entity.moveInfo.state == gwconstants.STATE_TOP then
    if entity.moveInfo.wait >= 0.0 then entity.nextThink = world.time + entity.moveInfo.wait end if
    return false
  end if
  entity.moveInfo.state = gwconstants.STATE_UP
  moveCalc(entity, entity.moveInfo.endOrigin, doorHitTop, world)
  gwcore.useTargets(world, entity, activator)
  doorUseAreaPortals(entity, true, world)
  return true
end function

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
    if entity.moveInfo.state == gwconstants.STATE_DOWN then doorGoUp(member, member.activator, world) else doorGoDown(member, world) end if
    member = member.teamChain
  end while
  return true
end function

function doorKilled(entity, inflictor, attacker, damage, point, world)
  master = entity.teamMaster
  if master is void then master = entity end if
  member = master
  while member is not void
    member.health = member.maxHealth
    member.takeDamage = gwconstants.DAMAGE_NO
    member = member.teamChain
  end while
  return doorUse(master, attacker, attacker, world)
end function

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
  return entity
end function

function rotatingDoorHitBottom(entity, world)
  entity.angularVelocity = qt.zeroVec3()
  entity.angles = gwvector.copy(entity.moveInfo.startAngles)
  entity.moveInfo.state = gwconstants.STATE_BOTTOM
  world.callbacks.linkEntity(entity)
  return true
end function

function rotatingDoorGoDown(entity, world)
  entity.moveInfo.state = gwconstants.STATE_DOWN
  entity.angularVelocity = gwvector.scale(entity.moveDirection, -entity.speed)
  entity.think = rotatingDoorHitBottom
  entity.nextThink = world.time + entity.moveInfo.distance / entity.speed
  return true
end function

function rotatingDoorHitTop(entity, world)
  entity.angularVelocity = qt.zeroVec3()
  entity.angles = gwvector.copy(entity.moveInfo.endAngles)
  entity.moveInfo.state = gwconstants.STATE_TOP
  if entity.wait >= 0.0 and (entity.spawnFlags & gwconstants.DOOR_TOGGLE) == 0 then
    entity.think = rotatingDoorGoDown
    entity.nextThink = world.time + entity.wait
  end if
  world.callbacks.linkEntity(entity)
  return true
end function

function rotatingDoorGoUp(entity, world)
  entity.moveInfo.state = gwconstants.STATE_UP
  entity.angularVelocity = gwvector.scale(entity.moveDirection, entity.speed)
  entity.think = rotatingDoorHitTop
  entity.nextThink = world.time + entity.moveInfo.distance / entity.speed
  return true
end function

function rotatingDoorUse(entity, other, activator, world)
  entity.activator = activator
  if (entity.spawnFlags & gwconstants.DOOR_TOGGLE) != 0 and (entity.moveInfo.state == gwconstants.STATE_TOP or entity.moveInfo.state == gwconstants.STATE_UP) then return rotatingDoorGoDown(entity, world) end if
  return rotatingDoorGoUp(entity, world)
end function

function spawnRotatingDoor(entity, world)
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
  if entity.wait == 0.0 then entity.wait = 3.0 end if
  if entity.damage == 0 then entity.damage = 2 end if
  distance = entity.moveInfo.distance
  if distance == 0.0 then distance = 90.0 end if
  entity.moveInfo.distance = distance
  entity.moveInfo.startAngles = gwvector.copy(entity.angles)
  entity.moveInfo.endAngles = gwvector.multiplyAdd(entity.angles, distance, entity.moveDirection)
  entity.moveInfo.state = gwconstants.STATE_BOTTOM
  world.callbacks.linkEntity(entity)
  return entity
end function

// -------------------------------------------------------------------------
// func_plat

function platHitTop(entity, world)
  entity.moveInfo.state = gwconstants.STATE_TOP
  entity.think = platGoDown
  entity.nextThink = world.time + 3.0
  return true
end function

function platHitBottom(entity, world)
  entity.moveInfo.state = gwconstants.STATE_BOTTOM
  return true
end function

function platGoDown(entity, world)
  entity.moveInfo.state = gwconstants.STATE_DOWN
  return moveCalc(entity, entity.moveInfo.endOrigin, platHitBottom, world)
end function

function platGoUp(entity, world)
  entity.moveInfo.state = gwconstants.STATE_UP
  return moveCalc(entity, entity.moveInfo.startOrigin, platHitTop, world)
end function

function platUse(entity, other, activator, world)
  if entity.nextThink != 0.0 then return false end if
  return platGoDown(entity, world)
end function

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
  return entity
end function

// Inline BSP bounds arrive through game_import_t.setmodel after the managed
// spawn callbacks have established behavior. Rebuild only the geometric
// endpoints here; do not reapply speed scaling or allocate trigger helpers.
function refreshBrushGeometry(entity, world)
  if entity.className == "func_button" then
    startOrigin = gwvector.copy(entity.moveInfo.startOrigin)
    distance = smath.abs(entity.moveDirection.x) * entity.size.x + smath.abs(entity.moveDirection.y) * entity.size.y + smath.abs(entity.moveDirection.z) * entity.size.z - entity.lip
    entity.origin = gwvector.copy(startOrigin)
    entity.moveInfo.endOrigin = gwvector.multiplyAdd(startOrigin, distance, entity.moveDirection)
    world.callbacks.linkEntity(entity)
    return true
  end if
  if entity.className == "func_door" or entity.className == "func_water" or entity.className == "func_door_secret" then
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

// -------------------------------------------------------------------------
// func_train

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
  else
    trainNext(entity, world)
  end if
  return true
end function

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
      moveCalc(entity, destination, trainWait, world)
      entity.spawnFlags = entity.spawnFlags | gwconstants.TRAIN_START_ON
    end if
  end while
  return true
end function

function trainResume(entity, world)
  if entity.targetEntity is void then return false end if
  destination = gwvector.subtract(entity.targetEntity.origin, entity.mins)
  entity.moveInfo.state = gwconstants.STATE_TOP
  entity.moveInfo.startOrigin = gwvector.copy(entity.origin)
  entity.moveInfo.endOrigin = gwvector.copy(destination)
  moveCalc(entity, destination, trainWait, world)
  entity.spawnFlags = entity.spawnFlags | gwconstants.TRAIN_START_ON
  return true
end function

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

function trainUse(entity, other, activator, world)
  entity.activator = activator
  if (entity.spawnFlags & gwconstants.TRAIN_START_ON) != 0 then
    if (entity.spawnFlags & gwconstants.TRAIN_TOGGLE) == 0 then return false end if
    entity.spawnFlags = entity.spawnFlags & ~gwconstants.TRAIN_START_ON
    entity.velocity = qt.zeroVec3()
    entity.nextThink = 0.0
  else if entity.targetEntity is not void then
    trainResume(entity, world)
  else
    trainNext(entity, world)
  end if
  return true
end function

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

// -------------------------------------------------------------------------
// func_timer

function timerThink(entity, world)
  gwcore.useTargets(world, entity, entity.activator)
  entity.nextThink = world.time + entity.wait + world.callbacks.randomSigned() * entity.random
  entity.think = timerThink
  return true
end function

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

// -------------------------------------------------------------------------
// func_explosive from g_misc.c (kept here with the brush movers).

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

function explosiveUse(entity, other, activator, world)
  return explosiveExplode(entity, entity, other, entity.health, qt.zeroVec3(), world)
end function

function explosiveSpawn(entity, other, activator, world)
  entity.solid = gwconstants.SOLID_BSP
  entity.serverFlags = entity.serverFlags & ~gwconstants.SVF_NOCLIENT
  entity.use = void
  world.callbacks.killBox(entity)
  world.callbacks.linkEntity(entity)
  return true
end function

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

function SP_func_button(entity, world)
  return spawnButton(entity, world)
end function
function SP_func_door(entity, world)
  return spawnDoor(entity, world)
end function
function SP_func_plat(entity, world)
  return spawnPlat(entity, world)
end function
function SP_func_train(entity, world)
  return spawnTrain(entity, world)
end function
function SP_func_timer(entity, world)
  return spawnTimer(entity, world)
end function
function SP_func_explosive(entity, world, deathmatch)
  return spawnExplosive(entity, world, deathmatch)
end function

// Rebind serialized callback identities from classname/state. Function values
// are deliberately not written to disk; the deterministic spawn path restores
// behavior and this boundary restores the currently pending mover callback.
function restoreMoverState(entity, world)
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
  else if name == "func_door" or name == "func_water" or name == "func_door_secret" then
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
