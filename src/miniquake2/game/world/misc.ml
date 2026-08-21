/* Retail BaseQ2 g_misc.c and func_rotating/func_wall state machines. */
package miniquake2.game.world.misc

import miniquake2.game.constants as wmgameconstants
import miniquake2.game.world.constants as wmconstants
import miniquake2.game.world.core as wmcore
import miniquake2.game.world.movers as wmmovers
import miniquake2.game.world.vector as wmvector
import miniquake2.qcommon.types as wmqtypes

function wallUse(entity, other, activator, world)
  if entity.solid == wmconstants.SOLID_NOT then
    entity.solid = wmconstants.SOLID_BSP
    entity.serverFlags = entity.serverFlags & ~wmconstants.SVF_NOCLIENT
    world.callbacks.killBox(entity)
  else
    entity.solid = wmconstants.SOLID_NOT
    entity.serverFlags = entity.serverFlags | wmconstants.SVF_NOCLIENT
  end if
  world.callbacks.linkEntity(entity)
  if (entity.spawnFlags & 2) == 0 then entity.use = void end if
  return true
end function

function spawnWall(entity, world)
  entity.moveType = wmconstants.MOVETYPE_PUSH
  if (entity.spawnFlags & 8) != 0 then entity.effects = entity.effects | wmconstants.EF_ANIM_ALL end if
  if (entity.spawnFlags & 16) != 0 then entity.effects = entity.effects | wmconstants.EF_ANIM_ALLFAST end if
  if (entity.spawnFlags & 7) == 0 then
    entity.solid = wmconstants.SOLID_BSP
    world.callbacks.linkEntity(entity)
    return entity
  end if
  if (entity.spawnFlags & 1) == 0 then entity.spawnFlags = entity.spawnFlags | 1 end if
  if (entity.spawnFlags & 4) != 0 and (entity.spawnFlags & 2) == 0 then
    wmcore.log(world, "func_wall START_ON without TOGGLE")
    entity.spawnFlags = entity.spawnFlags | 2
  end if
  entity.use = wallUse
  if (entity.spawnFlags & 4) != 0 then entity.solid = wmconstants.SOLID_BSP
  else entity.solid = wmconstants.SOLID_NOT; entity.serverFlags = entity.serverFlags | wmconstants.SVF_NOCLIENT
  end if
  world.callbacks.linkEntity(entity)
  return entity
end function

function rotatingBlocked(entity, other, world)
  if other is void then return false end if
  return world.callbacks.damage(other, entity, entity, entity.damage, wmconstants.MOD_CRUSH)
end function

function rotatingTouch(entity, other, world)
  if entity.angularVelocity.x == 0.0 and entity.angularVelocity.y == 0.0 and entity.angularVelocity.z == 0.0 then return false end if
  return rotatingBlocked(entity, other, world)
end function

function rotatingUse(entity, other, activator, world)
  if entity.angularVelocity.x != 0.0 or entity.angularVelocity.y != 0.0 or entity.angularVelocity.z != 0.0 then
    entity.loopSound = 0
    entity.angularVelocity = wmqtypes.zeroVec3()
    entity.touch = void
  else
    entity.angularVelocity = wmvector.scale(entity.moveDirection, entity.speed)
    if (entity.spawnFlags & 16) != 0 then entity.touch = rotatingTouch end if
  end if
  world.callbacks.linkEntity(entity)
  return true
end function

function spawnRotating(entity, world)
  entity.solid = wmconstants.SOLID_BSP
  if (entity.spawnFlags & 32) != 0 then entity.moveType = wmconstants.MOVETYPE_STOP else entity.moveType = wmconstants.MOVETYPE_PUSH end if
  entity.moveDirection = wmqtypes.zeroVec3()
  if (entity.spawnFlags & 4) != 0 then entity.moveDirection.z = 1.0
  else if (entity.spawnFlags & 8) != 0 then entity.moveDirection.x = 1.0
  else entity.moveDirection.y = 1.0
  end if
  if (entity.spawnFlags & 2) != 0 then entity.moveDirection = wmvector.scale(entity.moveDirection, -1.0) end if
  if entity.speed == 0.0 then entity.speed = 100.0 end if
  if entity.damage == 0 then entity.damage = 2 end if
  entity.use = rotatingUse
  entity.blocked = rotatingBlocked
  if (entity.spawnFlags & 1) != 0 then rotatingUse(entity, void, void, world) end if
  if (entity.spawnFlags & 64) != 0 then entity.effects = entity.effects | wmconstants.EF_ANIM_ALL end if
  if (entity.spawnFlags & 128) != 0 then entity.effects = entity.effects | wmconstants.EF_ANIM_ALLFAST end if
  world.callbacks.linkEntity(entity)
  return entity
end function

function teleporterTouch(entity, other, world)
  if other is void or other.isClient == false or entity.target == "" then return false end if
  destination = wmcore.pickTarget(world, entity.target)
  if destination is void then
    wmcore.log(world, "misc_teleporter without destination " + entity.target)
    return false
  end if
  other.origin = wmvector.copy(destination.origin)
  other.origin.z = other.origin.z + 10.0
  other.angles = wmvector.copy(destination.angles)
  other.velocity = wmqtypes.zeroVec3()
  world.callbacks.effect("teleport", entity.origin, 0, 1)
  world.callbacks.effect("teleport", destination.origin, 0, 1)
  return true
end function

function spawnTeleporter(entity, world)
  entity.model = "models/objects/dmspot/tris.md2"
  entity.solid = wmconstants.SOLID_TRIGGER
  entity.moveType = wmconstants.MOVETYPE_NONE
  entity.serverFlags = entity.serverFlags & ~wmconstants.SVF_NOCLIENT
  entity.mins = wmqtypes.Vec3(-32.0, -32.0, -24.0)
  entity.maxs = wmqtypes.Vec3(32.0, 32.0, -16.0)
  entity.touch = teleporterTouch
  world.callbacks.linkEntity(entity)
  return entity
end function

function spawnTeleporterDestination(entity, world)
  entity.solid = wmconstants.SOLID_NOT
  entity.moveType = wmconstants.MOVETYPE_NONE
  entity.serverFlags = entity.serverFlags | wmconstants.SVF_NOCLIENT
  return entity
end function

function barrelDropToFloor(entity, world)
  world.callbacks.linkEntity(entity)
  return true
end function

function barrelExplode(entity, world)
  world.callbacks.radiusDamage(entity, entity.activator, entity.damage, entity.damage + 40, wmconstants.MOD_BARREL)
  world.callbacks.effect("barrel-debris-large", entity.origin, 1, 6)
  world.callbacks.effect("barrel-debris-small", entity.origin, 2, 8)
  world.callbacks.effect("barrel-explosion", entity.origin, 0, 1)
  return wmcore.freeEntity(world, entity)
end function

function barrelDelay(entity, inflictor, attacker, damage, point, world)
  entity.takeDamage = wmconstants.DAMAGE_NO
  entity.activator = attacker
  entity.think = barrelExplode
  entity.nextThink = world.time + 2.0 * world.frameTime
  return true
end function

function barrelTouch(entity, other, world)
  if other is void or other.mass <= 0 then return false end if
  ratio = other.mass / entity.mass
  pushDelta = wmvector.subtract(entity.origin, other.origin)
  normalizedDirection = wmvector.normalized(pushDelta)
  direction = normalizedDirection[0]
  entity.velocity = wmvector.scale(direction, 20.0 * ratio)
  return true
end function

function spawnExplobox(entity, world)
  entity.solid = wmconstants.SOLID_BBOX
  entity.moveType = wmconstants.MOVETYPE_STEP
  entity.model = "models/objects/barrels/tris.md2"
  entity.mins = wmqtypes.Vec3(-16.0, -16.0, 0.0)
  entity.maxs = wmqtypes.Vec3(16.0, 16.0, 40.0)
  if entity.mass == 0 then entity.mass = 400 end if
  if entity.health == 0 then entity.health = 10; entity.maxHealth = 10 end if
  if entity.damage == 0 then entity.damage = 150 end if
  entity.renderFx = entity.renderFx | wmgameconstants.RF_FRAMELERP
  entity.takeDamage = wmconstants.DAMAGE_YES
  entity.die = barrelDelay
  entity.touch = barrelTouch
  entity.think = barrelDropToFloor
  entity.nextThink = world.time + 2.0 * world.frameTime
  world.callbacks.linkEntity(entity)
  return entity
end function

function bannerThink(entity, world)
  entity.frame = (entity.frame + 1) % 16
  entity.think = bannerThink
  entity.nextThink = world.time + world.frameTime
  return true
end function

function spawnBanner(entity, world)
  entity.moveType = wmconstants.MOVETYPE_NONE
  entity.solid = wmconstants.SOLID_NOT
  entity.model = "models/objects/banner/tris.md2"
  entity.frame = world.callbacks.randomIndex(16) % 16
  entity.think = bannerThink
  entity.nextThink = world.time + world.frameTime
  world.callbacks.linkEntity(entity)
  return entity
end function

function deadSoldierDie(entity, inflictor, attacker, damage, point, world)
  if entity.health > -80 then return false end if
  world.callbacks.sound(entity, "misc/udeath.wav")
  world.callbacks.effect("dead-soldier-gibs", entity.origin, 0, 5)
  return wmcore.freeEntity(world, entity)
end function

function spawnDeadSoldier(entity, world)
  entity.moveType = wmconstants.MOVETYPE_NONE
  entity.solid = wmconstants.SOLID_BBOX
  entity.model = "models/deadbods/dude/tris.md2"
  if (entity.spawnFlags & 2) != 0 then entity.frame = 1
  else if (entity.spawnFlags & 4) != 0 then entity.frame = 2
  else if (entity.spawnFlags & 8) != 0 then entity.frame = 3
  else if (entity.spawnFlags & 16) != 0 then entity.frame = 4
  else if (entity.spawnFlags & 32) != 0 then entity.frame = 5
  else entity.frame = 0
  end if
  entity.mins = wmqtypes.Vec3(-16.0, -16.0, 0.0)
  entity.maxs = wmqtypes.Vec3(16.0, 16.0, 16.0)
  entity.takeDamage = wmconstants.DAMAGE_YES
  entity.serverFlags = entity.serverFlags | wmconstants.SVF_MONSTER | wmconstants.SVF_DEADMONSTER
  entity.die = deadSoldierDie
  world.callbacks.linkEntity(entity)
  return entity
end function

function stroggShipUse(entity, other, activator, world)
  entity.serverFlags = entity.serverFlags & ~wmconstants.SVF_NOCLIENT
  entity.use = wmmovers.trainUse
  return wmmovers.trainUse(entity, other, activator, world)
end function

function spawnStroggShip(entity, world)
  if entity.target == "" then
    wmcore.log(world, "misc_strogg_ship without a target")
    wmcore.freeEntity(world, entity)
    return false
  end if
  if entity.speed == 0.0 then entity.speed = 300.0 end if
  entity.moveType = wmconstants.MOVETYPE_PUSH
  entity.solid = wmconstants.SOLID_NOT
  entity.model = "models/ships/strogg1/tris.md2"
  entity.mins = wmqtypes.Vec3(-16.0, -16.0, 0.0)
  entity.maxs = wmqtypes.Vec3(16.0, 16.0, 32.0)
  entity.think = wmmovers.trainFind
  entity.nextThink = world.time + world.frameTime
  entity.use = stroggShipUse
  entity.serverFlags = entity.serverFlags | wmconstants.SVF_NOCLIENT
  entity.moveInfo.speed = entity.speed
  entity.moveInfo.accel = entity.speed
  entity.moveInfo.decel = entity.speed
  world.callbacks.linkEntity(entity)
  return entity
end function

function gibFree(entity, world)
  return wmcore.freeEntity(world, entity)
end function

function gibDie(entity, inflictor, attacker, damage, point, world)
  world.callbacks.effect("gib-destroyed", entity.origin, 0, 1)
  return wmcore.freeEntity(world, entity)
end function

function spawnGibHead(entity, world)
  entity.model = "models/objects/gibs/head/tris.md2"
  entity.solid = wmconstants.SOLID_NOT
  entity.effects = entity.effects | wmgameconstants.EF_GIB
  entity.takeDamage = wmconstants.DAMAGE_YES
  entity.die = gibDie
  entity.moveType = wmconstants.MOVETYPE_TOSS
  entity.serverFlags = entity.serverFlags | wmconstants.SVF_MONSTER
  entity.angularVelocity = wmqtypes.Vec3(0.0, 0.0, 0.0)
  entity.think = gibFree
  entity.nextThink = world.time + 30.0
  world.callbacks.linkEntity(entity)
  return entity
end function

function lightUse(entity, other, activator, world)
  if (entity.spawnFlags & 1) != 0 then entity.spawnFlags = entity.spawnFlags & ~1
  else entity.spawnFlags = entity.spawnFlags | 1
  end if
  wmcore.emit(world, "light-style", entity, entity.style)
  return true
end function

function spawnLight(entity, world)
  if entity.targetName == "" then return wmcore.freeEntity(world, entity) end if
  if entity.style >= 32 then entity.use = lightUse end if
  return entity
end function

function spawnNull(entity, world)
  return wmcore.freeEntity(world, entity)
end function
