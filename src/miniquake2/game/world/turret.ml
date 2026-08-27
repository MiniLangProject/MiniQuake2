/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Coupled Classic Quake II 3.19 turret_base/breach/driver state machines. */
package miniquake2.game.world.turret

import std.math as turretmath
import miniquake2.game.constants as turretgameconstants
import miniquake2.game.ai.constants as turretaiconstants
import miniquake2.game.world.constants as turretworldconstants
import miniquake2.game.world.core as turretcore
import miniquake2.game.world.vector as turretvector
import miniquake2.game.world.turret_types as turrettypes
import miniquake2.qcommon.byteio as turretbyteio
import miniquake2.qcommon.constants as turretqconstants
import miniquake2.qcommon.types as turretqtypes

const TURRET_FIRE_REQUEST = 65536
const TURRET_NO_KNOCKBACK = 0x00000800

// Return the turret control value.
function turretControl(entity)
  control = entity.item
  if typeof(control) != "struct" then return error(9550, entity.className + " has no TurretControl") end if
  if typeof(control.callbacks) != "struct" then return error(9550, entity.className + " has no TurretCallbacks") end if
  return control
end function

// Attach turret control.
function turretAttachControl(entity, control)
  configuredItem = entity.item
  if typeof(configuredItem) == "string" and configuredItem != "" and entity.itemName == "" then
    entity.itemName = configuredItem
  end if
  entity.item = control
  return control
end function

// Return the turret current skill value.
function inline turretCurrentSkill(control)
  skill = control.callbacks.skillValue()
  if typeof(skill) != "int" and typeof(skill) != "float" then skill = control.skill end if
  if skill < 0.0 then skill = 0.0 end if
  if skill > 3.0 then skill = 3.0 end if
  return skill
end function

// Normalize turret angle.
function turretNormalizeAngle(value)
  while value > 360.0
    value = value - 360.0
  end while
  while value < 0.0
    value = value + 360.0
  end while
  return value
end function

// Return the turret shortest delta value.
function turretShortestDelta(value)
  if value < -180.0 then return value + 360.0 end if
  if value > 180.0 then return value - 360.0 end if
  return value
end function

// Return the turret snap to eighth value.
function turretSnapToEighth(value)
  scaled = value * 8.0
  if scaled > 0.0 then scaled = scaled + 0.5 else scaled = scaled - 0.5 end if
  return 0.125 * turretbyteio.truncInt(scaled)
end function

// Return the turret angle vectors value.
function turretAngleVectors(angles)
  pitch = turretmath.degToRad(angles.x)
  yaw = turretmath.degToRad(angles.y)
  roll = turretmath.degToRad(angles.z)
  pitchSine = turretmath.sin(pitch); pitchCosine = turretmath.cos(pitch)
  yawSine = turretmath.sin(yaw); yawCosine = turretmath.cos(yaw)
  rollSine = turretmath.sin(roll); rollCosine = turretmath.cos(roll)
  forward = turretqtypes.Vec3(pitchCosine * yawCosine, pitchCosine * yawSine, -pitchSine)
  right = turretqtypes.Vec3(
    -rollSine * pitchSine * yawCosine + rollCosine * yawSine,
    -rollSine * pitchSine * yawSine - rollCosine * yawCosine,
    -rollSine * pitchCosine
  )
  up = turretqtypes.Vec3(
    rollCosine * pitchSine * yawCosine + rollSine * yawSine,
    rollCosine * pitchSine * yawSine - rollSine * yawCosine,
    rollCosine * pitchCosine
  )
  result = array(3, void)
  result[0] = forward; result[1] = right; result[2] = up
  return result
end function

// Append turret team member.
function turretAppendTeamMember(master, member, world)
  if master is void or member is void or master == member then return false end if
  if master.teamMaster is void then master.teamMaster = master end if
  tail = master
  visited = 0
  limit = len(world.entities) + 1
  while tail.teamChain is not void
    if tail.teamChain == member then
      member.teamMaster = master
      member.flags = member.flags | turretworldconstants.FL_TEAMSLAVE
      return true
    end if
    tail = tail.teamChain
    visited = visited + 1
    if visited > limit then return error(9551, "turret team chain contains a cycle") end if
  end while
  tail.teamChain = member
  member.teamMaster = master
  member.flags = member.flags | turretworldconstants.FL_TEAMSLAVE
  return true
end function

// Bind turret team.
function bindTurretTeam(baseEntity, breach, world)
  if baseEntity is void or breach is void or baseEntity.className != "turret_base" or breach.className != "turret_breach" then
    return error(9552, "bindTurretTeam requires turret_base and turret_breach")
  end if
  baseEntity.teamMaster = baseEntity
  turretAppendTeamMember(baseEntity, breach, world)
  return baseEntity
end function

// Bind try turret team.
function tryBindTurretTeam(entity, world)
  if entity.team == "" then return false end if
  baseEntity = void
  breach = void
  for each candidate in world.entities
    if candidate.inUse and candidate.team == entity.team then
      if candidate.className == "turret_base" and baseEntity is void then baseEntity = candidate end if
      if candidate.className == "turret_breach" and breach is void then breach = candidate end if
    end if
  end for
  if baseEntity is void or breach is void then return false end if
  bindTurretTeam(baseEntity, breach, world)
  return true
end function

// Report whether turret blocked.
function turretBlocked(entity, other, world)
  if other is void or other.takeDamage == turretworldconstants.DAMAGE_NO then return false end if
  control = turretControl(entity)
  master = entity.teamMaster
  if master is void then master = entity end if
  attacker = master
  if master.owner is not void then attacker = master.owner end if
  control.callbacks.crushDamage(other, entity, attacker, master.damage, 10,
    turretworldconstants.MOD_CRUSH, world)
  turretcore.emit(world, "turret-blocked", entity, [other.number, master.damage])
  return true
end function

// Fire turret breach.
function turretBreachFire(entity, world)
  control = turretControl(entity)
  vectors = turretAngleVectors(entity.angles)
  forward = vectors[0]; right = vectors[1]; up = vectors[2]
  start = turretvector.multiplyAdd(entity.origin, entity.moveInfo.endOrigin.x, forward)
  start = turretvector.multiplyAdd(start, entity.moveInfo.endOrigin.y, right)
  start = turretvector.multiplyAdd(start, entity.moveInfo.endOrigin.z, up)
  randomValue = control.callbacks.randomUnit()
  if typeof(randomValue) != "int" and typeof(randomValue) != "float" then return error(9553, "turret randomUnit must return a number") end if
  if randomValue < 0.0 then randomValue = 0.0 end if
  if randomValue > 1.0 then randomValue = 1.0 end if
  damage = 100 + turretbyteio.truncInt(randomValue * 50.0)
  speed = 550 + turretbyteio.truncInt(50.0 * turretCurrentSkill(control))
  master = entity.teamMaster
  if master is void then master = entity end if
  attacker = master.owner
  if attacker is void then attacker = entity.owner end if
  if attacker is void then attacker = entity end if
  control.callbacks.fireRocket(attacker, start, forward, damage, speed, 150, world)
  control.callbacks.positionedSound(start, entity, "weapons/rocklf1a.wav", world)
  turretcore.emit(world, "turret-fire", entity, [damage, speed, start])
  return true
end function

// Clamp turret desired angles.
function turretClampDesiredAngles(entity)
  desiredPitch = turretNormalizeAngle(entity.moveDirection.x)
  desiredYaw = turretNormalizeAngle(entity.moveDirection.y)
  if desiredPitch > 180.0 then desiredPitch = desiredPitch - 360.0 end if
  maximumPitch = entity.moveInfo.startAngles.x
  minimumPitch = entity.moveInfo.endAngles.x
  if desiredPitch > maximumPitch then desiredPitch = maximumPitch end if
  if desiredPitch < minimumPitch then desiredPitch = minimumPitch end if

  minimumYaw = entity.moveInfo.startAngles.y
  maximumYaw = entity.moveInfo.endAngles.y
  if desiredYaw < minimumYaw or desiredYaw > maximumYaw then
    minimumDistance = turretmath.abs(minimumYaw - desiredYaw)
    if minimumDistance > 180.0 then minimumDistance = minimumDistance - 360.0 end if
    maximumDistance = turretmath.abs(maximumYaw - desiredYaw)
    if maximumDistance > 180.0 then maximumDistance = maximumDistance - 360.0 end if
    if turretmath.abs(minimumDistance) < turretmath.abs(maximumDistance) then desiredYaw = minimumYaw
    else desiredYaw = maximumYaw
    end if
  end if
  entity.moveDirection.x = desiredPitch
  entity.moveDirection.y = desiredYaw
  return true
end function

// Run turret breach.
function turretBreachThink(entity, world)
  // Keep turret breach think phases explicit: validate inputs, update owned state, then publish the result.
  turretClampDesiredAngles(entity)
  currentPitch = turretNormalizeAngle(entity.angles.x)
  currentYaw = turretNormalizeAngle(entity.angles.y)
  pitchDelta = turretShortestDelta(entity.moveDirection.x - currentPitch)
  yawDelta = turretShortestDelta(entity.moveDirection.y - currentYaw)
  maximumStep = entity.speed * world.frameTime
  if pitchDelta > maximumStep then pitchDelta = maximumStep end if
  if pitchDelta < -maximumStep then pitchDelta = -maximumStep end if
  if yawDelta > maximumStep then yawDelta = maximumStep end if
  if yawDelta < -maximumStep then yawDelta = -maximumStep end if
  entity.angularVelocity = turretqtypes.Vec3(pitchDelta / world.frameTime, yawDelta / world.frameTime, 0.0)
  entity.think = turretBreachThink
  entity.nextThink = world.time + world.frameTime

  master = entity.teamMaster
  if master is void then master = entity end if
  member = master
  visited = 0
  limit = len(world.entities) + 1
  while member is not void
    member.angularVelocity.y = entity.angularVelocity.y
    member = member.teamChain
    visited = visited + 1
    if visited > limit then return error(9554, "turret breach team chain contains a cycle") end if
  end while

  driver = entity.owner
  if driver is not void and driver.inUse then
    driver.angularVelocity.x = entity.angularVelocity.x
    driver.angularVelocity.y = entity.angularVelocity.y
    yaw = turretmath.degToRad(entity.angles.y + driver.moveDirection.y)
    targetX = turretSnapToEighth(entity.origin.x + turretmath.cos(yaw) * driver.moveDirection.x)
    targetY = turretSnapToEighth(entity.origin.y + turretmath.sin(yaw) * driver.moveDirection.x)
    driver.velocity.x = (targetX - driver.origin.x) / world.frameTime
    driver.velocity.y = (targetY - driver.origin.y) / world.frameTime
    pitch = turretmath.degToRad(entity.angles.x)
    targetZ = turretSnapToEighth(entity.origin.z + driver.moveDirection.x * turretmath.tan(pitch) + driver.moveDirection.z)
    driver.velocity.z = (targetZ - driver.origin.z) / world.frameTime
    if (entity.spawnFlags & TURRET_FIRE_REQUEST) != 0 then
      turretBreachFire(entity, world)
      entity.spawnFlags = entity.spawnFlags & ~TURRET_FIRE_REQUEST
    end if
  end if
  return true
end function

// Finish turret breach init.
function turretBreachFinishInit(entity, world)
  if entity.target == "" then
    turretcore.log(world, "turret_breach needs a muzzle target")
  else
    muzzle = turretcore.pickTarget(world, entity.target)
    if muzzle is void then
      turretcore.log(world, "turret_breach muzzle target " + entity.target + " not found")
    else
      entity.moveInfo.endOrigin = turretvector.subtract(muzzle.origin, entity.origin)
      turretcore.freeEntity(world, muzzle)
    end if
  end if
  master = entity.teamMaster
  if master is void then
    master = entity
    entity.teamMaster = entity
    turretcore.log(world, "turret_breach is not teamed with turret_base")
  end if
  master.damage = entity.damage
  entity.think = turretBreachThink
  return turretBreachThink(entity, world)
end function

// Spawn turret breach.
function spawnTurretBreach(entity, world, control, limits)
  if control is void then control = turrettypes.createTurretControl(void, 1.0) end if
  if limits is void then limits = turrettypes.defaultTurretLimits() end if
  if entity.model == "" then
    turretcore.log(world, "turret_breach with no model")
    turretcore.freeEntity(world, entity)
    return false
  end if
  turretAttachControl(entity, control)
  entity.solid = turretworldconstants.SOLID_BSP
  entity.moveType = turretworldconstants.MOVETYPE_PUSH
  world.callbacks.setModel(entity, entity.model)
  if entity.speed == 0.0 then entity.speed = 50.0 end if
  if entity.damage == 0 then entity.damage = 10 end if
  entity.moveInfo.startAngles = turretqtypes.Vec3(-limits.minPitch, limits.minYaw, 0.0)
  entity.moveInfo.endAngles = turretqtypes.Vec3(-limits.maxPitch, limits.maxYaw, 0.0)
  entity.moveDirection.y = entity.angles.y
  entity.blocked = turretBlocked
  entity.think = turretBreachFinishInit
  entity.nextThink = world.time + world.frameTime
  tryBindTurretTeam(entity, world)
  world.callbacks.linkEntity(entity)
  return entity
end function

// Spawn turret base.
function spawnTurretBase(entity, world, control)
  if control is void then control = turrettypes.createTurretControl(void, 1.0) end if
  if entity.model == "" then
    turretcore.log(world, "turret_base with no model")
    turretcore.freeEntity(world, entity)
    return false
  end if
  turretAttachControl(entity, control)
  entity.solid = turretworldconstants.SOLID_BSP
  entity.moveType = turretworldconstants.MOVETYPE_PUSH
  world.callbacks.setModel(entity, entity.model)
  entity.blocked = turretBlocked
  tryBindTurretTeam(entity, world)
  world.callbacks.linkEntity(entity)
  return entity
end function

// Use turret driver.
function turretDriverUse(entity, other, activator, world)
  control = turretControl(entity)
  if entity.enemy is not void or entity.health <= 0 or activator is void then return false end if
  if (activator.flags & turretaiconstants.FL_NOTARGET) != 0 then return false end if
  if activator.isClient != true and
      (activator.aiFlags & turretaiconstants.AI_GOOD_GUY) == 0 then return false end if
  entity.enemy = activator
  entity.timestamp = world.time
  entity.aiFlags = entity.aiFlags & ~turretaiconstants.AI_LOST_SIGHT
  return control.callbacks.driverUse(entity, other, activator, world)
end function

// Handle turret driver.
function turretDriverDie(entity, inflictor, attacker, damage, point, world)
  control = turretControl(entity)
  breach = entity.targetEntity
  if breach is not void and typeof(breach) == "struct" then
    breach.moveDirection.x = 0.0
  end if
  master = entity.teamMaster
  if master is not void then
    previous = master
    visited = 0
    limit = len(world.entities) + 1
    while previous.teamChain is not void and previous.teamChain != entity
      previous = previous.teamChain
      visited = visited + 1
      if visited > limit then return error(9555, "turret driver team chain contains a cycle") end if
    end while
    if previous.teamChain == entity then previous.teamChain = entity.teamChain end if
  end if
  entity.teamMaster = void
  entity.teamChain = void
  entity.flags = entity.flags & ~turretworldconstants.FL_TEAMSLAVE
  if breach is not void and typeof(breach) == "struct" then
    breach.owner = void
    breachMaster = breach.teamMaster
    if breachMaster is not void then breachMaster.owner = void end if
  end if
  turretcore.emit(world, "turret-driver-die", entity, damage)
  return control.callbacks.driverDie(entity, inflictor, attacker, damage, point, world)
end function

// Run turret driver.
function turretDriverThink(entity, world)
  // Keep turret driver think phases explicit: validate inputs, update owned state, then publish the result.
  control = turretControl(entity)
  entity.think = turretDriverThink
  entity.nextThink = world.time + world.frameTime
  enemy = entity.enemy
  if enemy is not void and (enemy.inUse == false or enemy.health <= 0) then enemy = void; entity.enemy = void end if
  if enemy is void then
    candidate = control.callbacks.acquireTarget(entity, world)
    if candidate is void then return true end if
    if typeof(candidate) != "struct" or candidate.inUse == false or candidate.health <= 0 then
      turretcore.log(world, "turret_driver acquireTarget returned an invalid enemy")
      return false
    end if
    entity.enemy = candidate
    enemy = candidate
    entity.timestamp = world.time
    entity.aiFlags = entity.aiFlags & ~turretaiconstants.AI_LOST_SIGHT
  else
    visible = control.callbacks.traceVisible(entity, enemy, world)
    if typeof(visible) != "bool" then return error(9556, "turret traceVisible must return bool") end if
    if visible then
      if (entity.aiFlags & turretaiconstants.AI_LOST_SIGHT) != 0 then
        entity.timestamp = world.time
        entity.aiFlags = entity.aiFlags & ~turretaiconstants.AI_LOST_SIGHT
      end if
    else
      entity.aiFlags = entity.aiFlags | turretaiconstants.AI_LOST_SIGHT
      return true
    end if
  end if

  breach = entity.targetEntity
  if breach is void or typeof(breach) != "struct" or breach.inUse == false then
    turretcore.log(world, "turret_driver has no active breach")
    return false
  end if
  target = turretvector.copy(enemy.origin)
  target.z = target.z + enemy.height
  direction = turretvector.subtract(target, breach.origin)
  breach.moveDirection = turretvector.toAngles(direction)
  if world.time < entity.pauseTime then return true end if
  reactionTime = 3.0 - turretCurrentSkill(control)
  if world.time - entity.timestamp < reactionTime then return true end if
  entity.pauseTime = world.time + reactionTime + 1.0
  breach.spawnFlags = breach.spawnFlags | TURRET_FIRE_REQUEST
  turretcore.emit(world, "turret-fire-request", entity, breach.number)
  return true
end function

// Link turret driver.
function turretDriverLink(entity, world)
  if entity.target == "" then
    turretcore.log(world, "turret_driver has no breach target")
    return false
  end if
  breach = turretcore.pickTarget(world, entity.target)
  if breach is void or breach.className != "turret_breach" then
    turretcore.log(world, "turret_driver target " + entity.target + " is not a turret_breach")
    return false
  end if
  master = breach.teamMaster
  if master is void then
    turretcore.log(world, "turret_driver target breach has no turret team")
    return false
  end if
  entity.targetEntity = breach
  breach.owner = entity
  master.owner = entity
  entity.angles = turretvector.copy(breach.angles)
  horizontal = turretqtypes.Vec3(breach.origin.x - entity.origin.x, breach.origin.y - entity.origin.y, 0.0)
  radius = turretvector.length(horizontal)
  relative = turretvector.subtract(entity.origin, breach.origin)
  relativeAngles = turretvector.toAngles(relative)
  entity.moveDirection = turretqtypes.Vec3(radius, turretNormalizeAngle(relativeAngles.y), entity.origin.z - breach.origin.z)
  turretAppendTeamMember(master, entity, world)
  entity.think = turretDriverThink
  entity.nextThink = world.time + world.frameTime
  turretcore.emit(world, "turret-driver-link", entity, breach.number)
  return true
end function

// Spawn turret driver.
function spawnTurretDriver(entity, world, control, deathmatch)
  if deathmatch then turretcore.freeEntity(world, entity); return false end if
  if control is void then control = turrettypes.createTurretControl(void, 1.0) end if
  turretAttachControl(entity, control)
  entity.moveType = turretworldconstants.MOVETYPE_PUSH
  entity.solid = turretworldconstants.SOLID_BBOX
  entity.model = "models/monsters/infantry/tris.md2"
  world.callbacks.setModel(entity, entity.model)
  entity.mins = turretqtypes.Vec3(-16.0, -16.0, -24.0)
  entity.maxs = turretqtypes.Vec3(16.0, 16.0, 32.0)
  entity.health = 100
  entity.maxHealth = 100
  entity.gibHealth = 0
  entity.mass = 200
  entity.height = 24.0
  entity.die = turretDriverDie
  entity.flags = entity.flags | TURRET_NO_KNOCKBACK
  entity.serverFlags = entity.serverFlags | turretworldconstants.SVF_MONSTER
  entity.renderFx = entity.renderFx | turretgameconstants.RF_FRAMELERP
  entity.takeDamage = turretworldconstants.DAMAGE_AIM
  entity.clipMask = turretqconstants.MASK_MONSTERSOLID
  entity.aiFlags = entity.aiFlags | turretaiconstants.AI_STAND_GROUND |
    turretaiconstants.AI_DUCKED
  entity.use = turretDriverUse
  entity.oldOrigin = turretvector.copy(entity.origin)
  entity.think = turretDriverLink
  entity.nextThink = world.time + world.frameTime
  control.callbacks.driverSpawn(entity, world)
  world.callbacks.linkEntity(entity)
  return entity
end function

// Spawn turret base.
function SP_turret_base(entity, world, control)
  return spawnTurretBase(entity, world, control)
end function

// Spawn turret breach.
function SP_turret_breach(entity, world, control, limits)
  return spawnTurretBreach(entity, world, control, limits)
end function

// Spawn turret driver.
function SP_turret_driver(entity, world, control, deathmatch)
  return spawnTurretDriver(entity, world, control, deathmatch)
end function

// Function identities are not serialized. Rebind the stock phase only after
// private-save reference numbers have been resolved, so an already linked
// driver resumes turret_driver_think instead of appending itself a second time.
function restoreTurretState(entity, world)
  if entity.className == "turret_base" then
    entity.blocked = turretBlocked
    return entity
  end if
  if entity.className == "turret_breach" then
    entity.blocked = turretBlocked
    if entity.nextThink > 0.0 then entity.think = turretBreachThink end if
    return entity
  end if
  if entity.className == "turret_driver" then
    entity.use = turretDriverUse
    entity.die = turretDriverDie
    if entity.inUse == false or entity.nextThink <= 0.0 then
      entity.think = void
    else if entity.targetEntity is void then entity.think = turretDriverLink
    else entity.think = turretDriverThink end if
  end if
  return entity
end function
