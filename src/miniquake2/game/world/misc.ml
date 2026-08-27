/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Retail BaseQ2 g_misc.c and func_rotating/func_wall state machines. */
package miniquake2.game.world.misc

import miniquake2.game.constants as wmgameconstants
import miniquake2.game.world.constants as wmconstants
import miniquake2.game.world.core as wmcore
import miniquake2.game.world.movers as wmmovers
import miniquake2.game.world.vector as wmvector
import miniquake2.qcommon.types as wmqtypes
import miniquake2.qcommon.constants as wmqconstants
import miniquake2.qcommon.byteio as worldclockbyteio

// -------------------------------------------------------------------------
// func_areaportal from g_misc.c. Doors also drive linked areaportals through
// mover code, but a directly targeted portal must own the stock toggle use.

function areaPortalUse(entity, other, activator, world)
  entity.count = entity.count ^ 1
  world.callbacks.areaPortal(entity.style, entity.count != 0)
  return true
end function

// Spawn area portal.
function spawnAreaPortal(entity, world)
  entity.use = areaPortalUse
  entity.count = 0
  return entity
end function

// -------------------------------------------------------------------------
// path_corner from g_misc.c.  AI-private walk/stand state stays behind the
// existing actorTransition callback used by target_actor.

function pathCornerTouch(entity, other, world)
  if other is void or other.inUse == false or
      other.targetEntity != entity or other.enemy is not void then return false end if
  if entity.pathTarget != "" then
    savedTarget = entity.target
    entity.target = entity.pathTarget
    wmcore.useTargets(world, entity, other)
    entity.target = savedTarget
    if entity.inUse == false then return false end if
  end if
  nextTarget = void
  if entity.target != "" then nextTarget = wmcore.pickTarget(world, entity.target) end if
  teleported = false
  if nextTarget is not void and (nextTarget.spawnFlags & 1) != 0 then
    other.origin.x = nextTarget.origin.x
    other.origin.y = nextTarget.origin.y
    other.origin.z = nextTarget.origin.z + nextTarget.mins.z - other.mins.z
    if nextTarget.target != "" then
      nextTarget = wmcore.pickTarget(world, nextTarget.target)
    else nextTarget = void
    end if
    teleported = true
  end if
  other.targetEntity = nextTarget
  action = "path"
  if teleported then action = "path-teleport" end if
  world.callbacks.actorTransition(other, entity, action, void, nextTarget,
    entity.wait, 0)
  return true
end function

// Spawn path corner.
function spawnPathCorner(entity, world)
  if entity.targetName == "" then
    wmcore.log(world, "path_corner with no targetname")
    wmcore.freeEntity(world, entity)
    return false
  end if
  entity.solid = wmconstants.SOLID_TRIGGER
  entity.touch = pathCornerTouch
  entity.mins = wmqtypes.Vec3(-8.0, -8.0, -8.0)
  entity.maxs = wmqtypes.Vec3(8.0, 8.0, 8.0)
  entity.serverFlags = entity.serverFlags | wmconstants.SVF_NOCLIENT
  world.callbacks.linkEntity(entity)
  return entity
end function

// -------------------------------------------------------------------------
// point_combat from g_misc.c. AI_COMBAT_POINT and stand-ground mutations live
// behind combatPointTransition; this world layer owns route consumption,
// target lookup and G_UseTargets activator selection.

function pointCombatTouch(entity, other, world)
  // Keep point combat touch phases explicit: validate inputs, update owned state, then publish the result.
  if other is void or typeof(other) != "struct" or other.inUse == false then return false end if
  if other.targetEntity != entity then return false end if

  nextTarget = entity
  if entity.target != "" then
    other.target = entity.target
    nextTarget = wmcore.pickTarget(world, other.target)
    other.targetEntity = nextTarget
    if nextTarget is void then
      wmcore.log(world, "point_combat target " + entity.target + " does not exist")
      other.targetEntity = entity
      nextTarget = entity
    end if
    entity.target = ""
  end if

  hold = (entity.spawnFlags & 1) != 0 and
    (other.flags & (wmconstants.FL_FLY | wmconstants.FL_SWIM)) == 0 and
    other.targetEntity == entity
  clearCombatPoint = false
  if other.targetEntity == entity then
    other.target = ""
    other.targetEntity = void
    nextTarget = void
    clearCombatPoint = true
  end if
  world.callbacks.combatPointTransition(other, entity, nextTarget, hold, clearCombatPoint)
  wmcore.emit(world, "combat-point", entity, [hold, clearCombatPoint])

  if entity.pathTarget != "" then
    savedTarget = entity.target
    entity.target = entity.pathTarget
    targetActivator = other
    if other.enemy is not void and typeof(other.enemy) == "struct" and other.enemy.isClient then targetActivator = other.enemy
    else if other.oldEnemy is not void and typeof(other.oldEnemy) == "struct" and other.oldEnemy.isClient then targetActivator = other.oldEnemy
    else if other.activator is not void and typeof(other.activator) == "struct" and other.activator.isClient then targetActivator = other.activator
    end if
    wmcore.useTargets(world, entity, targetActivator)
    entity.target = savedTarget
  end if
  return true
end function

// Spawn point combat.
function spawnPointCombat(entity, world, deathmatch)
  if deathmatch then return wmcore.freeEntity(world, entity) end if
  entity.solid = wmconstants.SOLID_TRIGGER
  entity.touch = pointCombatTouch
  entity.mins = wmqtypes.Vec3(-8.0, -8.0, -16.0)
  entity.maxs = wmqtypes.Vec3(8.0, 8.0, 16.0)
  entity.serverFlags = wmconstants.SVF_NOCLIENT
  world.callbacks.linkEntity(entity)
  return entity
end function

// Use wall.
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

// Spawn wall.
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

// Handle func object.
function funcObjectTouch(entity, other, world)
  if other is void or entity.moveDirection.z < 1.0 or
      other.takeDamage == wmconstants.DAMAGE_NO then return false end if
  return world.callbacks.damage(other, entity, entity, entity.damage,
    wmconstants.MOD_CRUSH)
end function

// Release func object.
function funcObjectRelease(entity, world)
  entity.moveType = wmconstants.MOVETYPE_TOSS
  entity.touch = funcObjectTouch
  return true
end function

// Use func object.
function funcObjectUse(entity, other, activator, world)
  entity.solid = wmconstants.SOLID_BSP
  entity.serverFlags = entity.serverFlags & ~wmconstants.SVF_NOCLIENT
  entity.use = void
  world.callbacks.killBox(entity)
  funcObjectRelease(entity, world)
  world.callbacks.linkEntity(entity)
  return true
end function

// Return the shrink func object bounds.
function shrinkFuncObjectBounds(entity)
  if entity.mins.x < entity.maxs.x then entity.mins.x = entity.mins.x + 1.0; entity.maxs.x = entity.maxs.x - 1.0 end if
  if entity.mins.y < entity.maxs.y then entity.mins.y = entity.mins.y + 1.0; entity.maxs.y = entity.maxs.y - 1.0 end if
  if entity.mins.z < entity.maxs.z then entity.mins.z = entity.mins.z + 1.0; entity.maxs.z = entity.maxs.z - 1.0 end if
  return true
end function

// Spawn object.
function spawnObject(entity, world)
  world.callbacks.setModel(entity, entity.model)
  shrinkFuncObjectBounds(entity)
  if entity.damage == 0 then entity.damage = 100 end if
  entity.moveType = wmconstants.MOVETYPE_PUSH
  if entity.spawnFlags == 0 then
    entity.solid = wmconstants.SOLID_BSP
    entity.think = funcObjectRelease
    entity.nextThink = world.time + 2.0 * world.frameTime
  else
    entity.solid = wmconstants.SOLID_NOT
    entity.use = funcObjectUse
    entity.serverFlags = entity.serverFlags | wmconstants.SVF_NOCLIENT
  end if
  if (entity.spawnFlags & 2) != 0 then entity.effects = entity.effects | wmconstants.EF_ANIM_ALL end if
  if (entity.spawnFlags & 4) != 0 then entity.effects = entity.effects | wmconstants.EF_ANIM_ALLFAST end if
  entity.clipMask = wmqconstants.MASK_MONSTERSOLID
  world.callbacks.linkEntity(entity)
  return entity
end function

// Report whether rotating blocked.
function rotatingBlocked(entity, other, world)
  if other is void then return false end if
  return world.callbacks.damage(other, entity, entity, entity.damage, wmconstants.MOD_CRUSH)
end function

// Handle rotating.
function rotatingTouch(entity, other, world)
  if entity.angularVelocity.x == 0.0 and entity.angularVelocity.y == 0.0 and entity.angularVelocity.z == 0.0 then return false end if
  return rotatingBlocked(entity, other, world)
end function

// Use rotating.
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

// Spawn rotating.
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

// Handle teleporter.
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

// Spawn teleporter.
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

// Spawn teleporter destination.
function spawnTeleporterDestination(entity, world)
  entity.solid = wmconstants.SOLID_NOT
  entity.moveType = wmconstants.MOVETYPE_NONE
  entity.serverFlags = entity.serverFlags | wmconstants.SVF_NOCLIENT
  return entity
end function

// Drop barrel to floor.
function barrelDropToFloor(entity, world)
  world.callbacks.linkEntity(entity)
  return true
end function

// Return the barrel explode value.
function barrelExplode(entity, world)
  world.callbacks.radiusDamage(entity, entity.activator, entity.damage, entity.damage + 40, wmconstants.MOD_BARREL)
  // g_misc.c emits two random large chunks, four debris3 bottom corners and
  // eight random small chunks. Keep the exact model split so the integration
  // layer can publish real bouncing edicts rather than only an explosion.
  center = wmqtypes.Vec3(
    entity.absoluteMins.x + entity.size.x * 0.5,
    entity.absoluteMins.y + entity.size.y * 0.5,
    entity.absoluteMins.z + entity.size.z * 0.5)
  largeSpeed = 1.5 * entity.damage / 200.0
  smallSpeed = 2.0 * entity.damage / 200.0
  index = 0
  while index < 2
    debrisOrigin = wmqtypes.Vec3(
      center.x + world.callbacks.randomSigned() * entity.size.x,
      center.y + world.callbacks.randomSigned() * entity.size.y,
      center.z + world.callbacks.randomSigned() * entity.size.z)
    world.callbacks.effect("barrel-debris1", debrisOrigin, largeSpeed, 1)
    index = index + 1
  end while
  cornerSpeed = 1.75 * entity.damage / 200.0
  world.callbacks.effect("barrel-debris3", entity.absoluteMins, cornerSpeed, 1)
  world.callbacks.effect("barrel-debris3", wmqtypes.Vec3(
    entity.absoluteMins.x + entity.size.x, entity.absoluteMins.y,
    entity.absoluteMins.z), cornerSpeed, 1)
  world.callbacks.effect("barrel-debris3", wmqtypes.Vec3(
    entity.absoluteMins.x, entity.absoluteMins.y + entity.size.y,
    entity.absoluteMins.z), cornerSpeed, 1)
  world.callbacks.effect("barrel-debris3", wmqtypes.Vec3(
    entity.absoluteMins.x + entity.size.x,
    entity.absoluteMins.y + entity.size.y, entity.absoluteMins.z),
    cornerSpeed, 1)
  index = 0
  while index < 8
    debrisOrigin = wmqtypes.Vec3(
      center.x + world.callbacks.randomSigned() * entity.size.x,
      center.y + world.callbacks.randomSigned() * entity.size.y,
      center.z + world.callbacks.randomSigned() * entity.size.z)
    world.callbacks.effect("barrel-debris2", debrisOrigin, smallSpeed, 1)
    index = index + 1
  end while
  world.callbacks.effect("barrel-explosion", entity.origin, 0, 1)
  return wmcore.freeEntity(world, entity)
end function

// Return the barrel delay value.
function barrelDelay(entity, inflictor, attacker, damage, point, world)
  entity.takeDamage = wmconstants.DAMAGE_NO
  entity.activator = attacker
  entity.think = barrelExplode
  entity.nextThink = world.time + 2.0 * world.frameTime
  return true
end function

// Handle barrel.
function barrelTouch(entity, other, world)
  if other is void or other.mass <= 0 then return false end if
  ratio = other.mass / entity.mass
  pushDelta = wmvector.subtract(entity.origin, other.origin)
  normalizedDirection = wmvector.normalized(pushDelta)
  direction = normalizedDirection[0]
  entity.velocity = wmvector.scale(direction, 20.0 * ratio)
  return true
end function

// Spawn explobox.
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

// Run banner.
function bannerThink(entity, world)
  entity.frame = (entity.frame + 1) % 16
  entity.think = bannerThink
  entity.nextThink = world.time + world.frameTime
  return true
end function

// Spawn banner.
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

// Handle dead soldier.
function deadSoldierDie(entity, inflictor, attacker, damage, point, world)
  if entity.health > -80 then return false end if
  world.callbacks.sound(entity, "misc/udeath.wav")
  world.callbacks.effect("dead-soldier-gibs", entity.origin, 0, 5)
  return wmcore.freeEntity(world, entity)
end function

// Spawn dead soldier.
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

// Use strogg ship.
function stroggShipUse(entity, other, activator, world)
  entity.serverFlags = entity.serverFlags & ~wmconstants.SVF_NOCLIENT
  entity.use = wmmovers.trainUse
  return wmmovers.trainUse(entity, other, activator, world)
end function

// Spawn strogg ship.
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

// Release gib.
function gibFree(entity, world)
  return wmcore.freeEntity(world, entity)
end function

// Handle gib.
function gibDie(entity, inflictor, attacker, damage, point, world)
  world.callbacks.effect("gib-destroyed", entity.origin, 0, 1)
  return wmcore.freeEntity(world, entity)
end function

// ThrowDebris uses a quiet damage callback: shooting a chunk removes it but
// must not create a blood/gib effect.
function debrisDie(entity, inflictor, attacker, damage, point, world)
  return wmcore.freeEntity(world, entity)
end function

// Spawn gib part.
function spawnGibPart(entity, modelName, world)
  entity.model = modelName
  entity.solid = wmconstants.SOLID_NOT
  entity.effects = entity.effects | wmgameconstants.EF_GIB
  entity.takeDamage = wmconstants.DAMAGE_YES
  entity.die = gibDie
  entity.moveType = wmconstants.MOVETYPE_TOSS
  entity.serverFlags = entity.serverFlags | wmconstants.SVF_MONSTER
  entity.angularVelocity = wmqtypes.Vec3(
    (world.callbacks.randomSigned() + 1.0) * 100.0,
    (world.callbacks.randomSigned() + 1.0) * 100.0,
    (world.callbacks.randomSigned() + 1.0) * 100.0)
  entity.think = gibFree
  entity.nextThink = world.time + 30.0
  world.callbacks.linkEntity(entity)
  return entity
end function

// Spawn gib head.
function spawnGibHead(entity, world)
  return spawnGibPart(entity, "models/objects/gibs/head/tris.md2", world)
end function

// Spawn gib arm.
function spawnGibArm(entity, world)
  return spawnGibPart(entity, "models/objects/gibs/arm/tris.md2", world)
end function

// Spawn gib leg.
function spawnGibLeg(entity, world)
  return spawnGibPart(entity, "models/objects/gibs/leg/tris.md2", world)
end function

// Run view thing.
function viewThingThink(entity, world)
  entity.frame = (entity.frame + 1) % 7
  entity.think = viewThingThink
  entity.nextThink = world.time + world.frameTime
  return true
end function

// Spawn view thing.
function spawnViewThing(entity, world)
  entity.moveType = wmconstants.MOVETYPE_NONE
  entity.solid = wmconstants.SOLID_BBOX
  entity.renderFx = entity.renderFx | wmgameconstants.RF_FRAMELERP
  entity.mins = wmqtypes.Vec3(-16.0, -16.0, -24.0)
  entity.maxs = wmqtypes.Vec3(16.0, 16.0, 32.0)
  entity.model = "models/objects/banner/tris.md2"
  world.callbacks.setModel(entity, entity.model)
  entity.think = viewThingThink
  entity.nextThink = world.time + 0.5
  world.callbacks.linkEntity(entity)
  return entity
end function

// Spawn light mine 1.
function spawnLightMine1(entity, world)
  entity.moveType = wmconstants.MOVETYPE_NONE
  entity.solid = wmconstants.SOLID_BBOX
  entity.model = "models/objects/minelite/light1/tris.md2"
  world.callbacks.setModel(entity, entity.model)
  world.callbacks.linkEntity(entity)
  return entity
end function

// Spawn big viper.
function spawnBigViper(entity, world)
  entity.moveType = wmconstants.MOVETYPE_NONE
  entity.solid = wmconstants.SOLID_BBOX
  entity.mins = wmqtypes.Vec3(-176.0, -120.0, -24.0)
  entity.maxs = wmqtypes.Vec3(176.0, 120.0, 72.0)
  entity.model = "models/ships/bigviper/tris.md2"
  world.callbacks.setModel(entity, entity.model)
  world.callbacks.linkEntity(entity)
  return entity
end function

// Use light.
function lightUse(entity, other, activator, world)
  if (entity.spawnFlags & 1) != 0 then entity.spawnFlags = entity.spawnFlags & ~1
  else entity.spawnFlags = entity.spawnFlags | 1
  end if
  wmcore.emit(world, "light-style", entity, entity.style)
  return true
end function

// Spawn light.
function spawnLight(entity, world)
  if entity.targetName == "" then return wmcore.freeEntity(world, entity) end if
  if entity.style >= 32 then entity.use = lightUse end if
  return entity
end function

// Spawn null.
function spawnNull(entity, world)
  return wmcore.freeEntity(world, entity)
end function

// Spawn info not null.
function spawnInfoNotNull(entity, world)
  entity.absoluteMins = wmvector.copy(entity.origin)
  entity.absoluteMaxs = wmvector.copy(entity.origin)
  return entity
end function

// -------------------------------------------------------------------------
// Remaining stock g_misc.c set pieces. Model registration is injected through
// setModel; animation and movement remain world-owned deterministic state.

function blackHoleUse(entity, other, activator, world)
  return wmcore.freeEntity(world, entity)
end function

// Run black hole.
function blackHoleThink(entity, world)
  entity.frame = entity.frame + 1
  if entity.frame >= 19 then entity.frame = 0 end if
  entity.think = blackHoleThink
  entity.nextThink = world.time + world.frameTime
  return true
end function

// Spawn black hole.
function spawnBlackHole(entity, world)
  entity.moveType = wmconstants.MOVETYPE_NONE
  entity.solid = wmconstants.SOLID_NOT
  entity.model = "models/objects/black/tris.md2"
  world.callbacks.setModel(entity, entity.model)
  entity.mins = wmqtypes.Vec3(-64.0, -64.0, 0.0)
  entity.maxs = wmqtypes.Vec3(64.0, 64.0, 8.0)
  entity.renderFx = entity.renderFx | wmconstants.RF_TRANSLUCENT
  entity.use = blackHoleUse
  entity.think = blackHoleThink
  entity.nextThink = world.time + 2.0 * world.frameTime
  world.callbacks.linkEntity(entity)
  return entity
end function

// Run easter tank.
function easterTankThink(entity, world)
  entity.frame = entity.frame + 1
  if entity.frame >= 293 then entity.frame = 254 end if
  entity.think = easterTankThink
  entity.nextThink = world.time + world.frameTime
  return true
end function

// Spawn easter tank.
function spawnEasterTank(entity, world)
  entity.moveType = wmconstants.MOVETYPE_NONE
  entity.solid = wmconstants.SOLID_BBOX
  entity.model = "models/monsters/tank/tris.md2"
  world.callbacks.setModel(entity, entity.model)
  entity.mins = wmqtypes.Vec3(-32.0, -32.0, -16.0)
  entity.maxs = wmqtypes.Vec3(32.0, 32.0, 32.0)
  entity.frame = 254
  entity.think = easterTankThink
  entity.nextThink = world.time + 2.0 * world.frameTime
  world.callbacks.linkEntity(entity)
  return entity
end function

// Run easter chick.
function easterChickThink(entity, world)
  entity.frame = entity.frame + 1
  if entity.frame >= 247 then entity.frame = 208 end if
  entity.think = easterChickThink
  entity.nextThink = world.time + world.frameTime
  return true
end function

// Spawn easter chick.
function spawnEasterChick(entity, world)
  entity.moveType = wmconstants.MOVETYPE_NONE
  entity.solid = wmconstants.SOLID_BBOX
  entity.model = "models/monsters/bitch/tris.md2"
  world.callbacks.setModel(entity, entity.model)
  entity.mins = wmqtypes.Vec3(-32.0, -32.0, 0.0)
  entity.maxs = wmqtypes.Vec3(32.0, 32.0, 32.0)
  entity.frame = 208
  entity.think = easterChickThink
  entity.nextThink = world.time + 2.0 * world.frameTime
  world.callbacks.linkEntity(entity)
  return entity
end function

// Run easter chick 2.
function easterChick2Think(entity, world)
  entity.frame = entity.frame + 1
  if entity.frame >= 287 then entity.frame = 248 end if
  entity.think = easterChick2Think
  entity.nextThink = world.time + world.frameTime
  return true
end function

// Spawn easter chick 2.
function spawnEasterChick2(entity, world)
  entity.moveType = wmconstants.MOVETYPE_NONE
  entity.solid = wmconstants.SOLID_BBOX
  entity.model = "models/monsters/bitch/tris.md2"
  world.callbacks.setModel(entity, entity.model)
  entity.mins = wmqtypes.Vec3(-32.0, -32.0, 0.0)
  entity.maxs = wmqtypes.Vec3(32.0, 32.0, 32.0)
  entity.frame = 248
  entity.think = easterChick2Think
  entity.nextThink = world.time + 2.0 * world.frameTime
  world.callbacks.linkEntity(entity)
  return entity
end function

// Run satellite dish.
function satelliteDishThink(entity, world)
  entity.frame = entity.frame + 1
  if entity.frame < 38 then
    entity.think = satelliteDishThink
    entity.nextThink = world.time + world.frameTime
  end if
  return true
end function

// Use satellite dish.
function satelliteDishUse(entity, other, activator, world)
  entity.frame = 0
  entity.think = satelliteDishThink
  entity.nextThink = world.time + world.frameTime
  return true
end function

// Spawn satellite dish.
function spawnSatelliteDish(entity, world)
  entity.moveType = wmconstants.MOVETYPE_NONE
  entity.solid = wmconstants.SOLID_BBOX
  entity.model = "models/objects/satellite/tris.md2"
  world.callbacks.setModel(entity, entity.model)
  entity.mins = wmqtypes.Vec3(-64.0, -64.0, 0.0)
  entity.maxs = wmqtypes.Vec3(64.0, 64.0, 128.0)
  entity.use = satelliteDishUse
  world.callbacks.linkEntity(entity)
  return entity
end function

// Spawn light mine 2.
function spawnLightMine2(entity, world)
  entity.moveType = wmconstants.MOVETYPE_NONE
  entity.solid = wmconstants.SOLID_BBOX
  entity.model = "models/objects/minelite/light2/tris.md2"
  world.callbacks.setModel(entity, entity.model)
  world.callbacks.linkEntity(entity)
  return entity
end function

// Use viper.
function viperUse(entity, other, activator, world)
  entity.serverFlags = entity.serverFlags & ~wmconstants.SVF_NOCLIENT
  entity.use = wmmovers.trainUse
  return wmmovers.trainUse(entity, other, activator, world)
end function

// Spawn viper.
function spawnViper(entity, world)
  if entity.target == "" then
    wmcore.log(world, "misc_viper without a target")
    wmcore.freeEntity(world, entity)
    return false
  end if
  if entity.speed == 0.0 then entity.speed = 300.0 end if
  entity.moveType = wmconstants.MOVETYPE_PUSH
  entity.solid = wmconstants.SOLID_NOT
  entity.model = "models/ships/viper/tris.md2"
  world.callbacks.setModel(entity, entity.model)
  entity.mins = wmqtypes.Vec3(-16.0, -16.0, 0.0)
  entity.maxs = wmqtypes.Vec3(16.0, 16.0, 32.0)
  entity.think = wmmovers.trainFind
  entity.nextThink = world.time + world.frameTime
  entity.use = viperUse
  entity.serverFlags = entity.serverFlags | wmconstants.SVF_NOCLIENT
  entity.moveInfo.speed = entity.speed
  entity.moveInfo.accel = entity.speed
  entity.moveInfo.decel = entity.speed
  world.callbacks.linkEntity(entity)
  return entity
end function

// Find world viper.
function findWorldViper(world)
  for each candidate in world.entities
    if candidate.inUse and candidate.className == "misc_viper" then return candidate end if
  end for
  return void
end function

// Run viper bomb pre.
function viperBombPreThink(entity, world)
  entity.groundEntity = void
  difference = entity.timestamp - world.time
  if difference < -1.0 then difference = -1.0 end if
  direction = wmvector.scale(entity.moveInfo.direction, 1.0 + difference)
  direction.z = difference
  roll = entity.angles.z
  entity.angles = wmvector.toAngles(direction)
  entity.angles.z = roll + 10.0
  entity.think = viperBombPreThink
  entity.nextThink = world.time + world.frameTime
  return true
end function

// Handle viper bomb.
function viperBombTouch(entity, other, world)
  wmcore.useTargets(world, entity, entity.activator)
  if entity.inUse == false then return false end if
  entity.origin.z = entity.absoluteMins.z + 1.0
  world.callbacks.radiusDamage(entity, entity, entity.damage, entity.damage + 40, wmconstants.MOD_BOMB)
  world.callbacks.effect("explosion2", entity.origin, 0, 1)
  return wmcore.freeEntity(world, entity)
end function

// Use viper bomb.
function viperBombUse(entity, other, activator, world)
  viper = findWorldViper(world)
  if viper is void then
    wmcore.log(world, "misc_viper_bomb used without misc_viper")
    return false
  end if
  entity.solid = wmconstants.SOLID_BBOX
  entity.serverFlags = entity.serverFlags & ~wmconstants.SVF_NOCLIENT
  entity.effects = entity.effects | wmconstants.EF_ROCKET
  entity.use = void
  entity.moveType = wmconstants.MOVETYPE_TOSS
  entity.think = viperBombPreThink
  entity.nextThink = world.time + world.frameTime
  entity.touch = viperBombTouch
  entity.activator = activator
  entity.velocity = wmvector.scale(viper.moveInfo.direction, viper.moveInfo.speed)
  entity.timestamp = world.time
  entity.moveInfo.direction = wmvector.copy(viper.moveInfo.direction)
  world.callbacks.linkEntity(entity)
  return true
end function

// Spawn viper bomb.
function spawnViperBomb(entity, world)
  entity.moveType = wmconstants.MOVETYPE_NONE
  entity.solid = wmconstants.SOLID_NOT
  entity.mins = wmqtypes.Vec3(-8.0, -8.0, -8.0)
  entity.maxs = wmqtypes.Vec3(8.0, 8.0, 8.0)
  entity.model = "models/objects/bomb/tris.md2"
  world.callbacks.setModel(entity, entity.model)
  entity.mins = wmqtypes.Vec3(-8.0, -8.0, -8.0)
  entity.maxs = wmqtypes.Vec3(8.0, 8.0, 8.0)
  if entity.damage == 0 then entity.damage = 1000 end if
  entity.use = viperBombUse
  entity.serverFlags = entity.serverFlags | wmconstants.SVF_NOCLIENT
  world.callbacks.linkEntity(entity)
  return entity
end function

// -------------------------------------------------------------------------
// target_character / target_string from g_misc.c.

function spawnTargetCharacter(entity, world)
  if entity.model == "" then
    wmcore.log(world, "target_character with no model")
    return false
  end if
  entity.moveType = wmconstants.MOVETYPE_PUSH
  world.callbacks.setModel(entity, entity.model)
  entity.solid = wmconstants.SOLID_BSP
  entity.frame = 12
  world.callbacks.linkEntity(entity)
  return entity
end function

// Return the target string frame value.
function targetStringFrame(character)
  if character >= 48 and character <= 57 then return character - 48 end if
  if character == 45 then return 10 end if
  if character == 58 then return 11 end if
  return 12
end function

// Use target string.
function useTargetString(entity, other, activator, world)
  if typeof(entity.message) != "string" then return error(9490, "target_string message must be text") end if
  messageBytes = bytes(entity.message)
  member = entity.teamMaster
  if member is void then member = entity end if
  visited = 0
  visitLimit = len(world.entities) + 1
  while member is not void
    if typeof(member) != "struct" then return error(9491, "target_string team chain member must be an entity") end if
    if typeof(member.count) != "int" then return error(9491, "target_string character count must be an integer") end if
    if member.count > 0 then
      position = member.count - 1
      if position < 0 or position >= len(messageBytes) then member.frame = 12
      else member.frame = targetStringFrame(messageBytes[position])
      end if
    end if
    member = member.teamChain
    visited = visited + 1
    if visited > visitLimit then return error(9492, "target_string team chain contains a cycle") end if
  end while
  wmcore.emit(world, "target-string", entity, entity.message)
  return true
end function

// Spawn target string.
function spawnTargetString(entity, world)
  if typeof(entity.message) != "string" then entity.message = "" end if
  entity.use = useTargetString
  return entity
end function

// -------------------------------------------------------------------------
// func_clock. The original localtime dependency is injected as clockSeconds;
// timer-up/down paths remain entirely scheduler-driven and deterministic.

function worldClockTwoWide(value)
  if value >= 0 and value < 10 then return " " + value end if
  return "" + value
end function

// Return the world clock two digits value.
function worldClockTwoDigits(value)
  if value >= 0 and value < 10 then return "0" + value end if
  return "" + value
end function

// Format world clock value.
function worldClockFormatValue(value, style)
  clockValue = worldclockbyteio.truncInt(value)
  if style == 0 then return worldClockTwoWide(clockValue) end if
  if style == 1 then
    minutes = worldclockbyteio.truncInt(clockValue / 60.0)
    seconds = clockValue % 60
    return worldClockTwoWide(minutes) + ":" + worldClockTwoDigits(seconds)
  end if
  hours = worldclockbyteio.truncInt(clockValue / 3600.0)
  minutes = worldclockbyteio.truncInt((clockValue - hours * 3600) / 60.0)
  seconds = clockValue % 60
  return worldClockTwoWide(hours) + ":" + worldClockTwoDigits(minutes) + ":" + worldClockTwoDigits(seconds)
end function

// Reset world clock.
function resetWorldClock(entity)
  entity.activator = void
  if (entity.spawnFlags & wmconstants.CLOCK_TIMER_UP) != 0 then
    entity.health = 0
    entity.wait = entity.count
  else if (entity.spawnFlags & wmconstants.CLOCK_TIMER_DOWN) != 0 then
    entity.health = entity.count
    entity.wait = 0
  end if
  return entity
end function

// Return the world clock display value.
function worldClockDisplay(entity, world)
  if (entity.spawnFlags & wmconstants.CLOCK_TIMER_UP) != 0 or
      (entity.spawnFlags & wmconstants.CLOCK_TIMER_DOWN) != 0 then
    return worldClockFormatValue(entity.health, entity.style)
  end if
  secondsValue = world.callbacks.clockSeconds()
  if typeof(secondsValue) != "int" and typeof(secondsValue) != "float" then
    return error(9493, "func_clock clockSeconds callback must return a number")
  end if
  seconds = worldclockbyteio.truncInt(secondsValue) % 86400
  if seconds < 0 then seconds = seconds + 86400 end if
  hours = worldclockbyteio.truncInt(seconds / 3600.0)
  minutes = worldclockbyteio.truncInt((seconds - hours * 3600) / 60.0)
  remainder = seconds % 60
  return worldClockTwoWide(hours) + ":" + worldClockTwoDigits(minutes) + ":" + worldClockTwoDigits(remainder)
end function

// Run world clock.
function worldClockThink(entity, world)
  // Keep world clock think phases explicit: validate inputs, update owned state, then publish the result.
  display = entity.targetEntity
  if display is not void and typeof(display) != "struct" then return error(9494, "func_clock targetEntity must be an entity") end if
  if display is void or display.inUse == false then
    matches = wmcore.matchingTargets(world, entity.target)
    if len(matches) == 0 then
      wmcore.log(world, "func_clock target " + entity.target + " not found")
      return false
    end if
    display = matches[0]
    entity.targetEntity = display
  end if
  if display.use is void then
    wmcore.log(world, "func_clock target " + entity.target + " has no use function")
    return false
  end if

  entity.message = worldClockDisplay(entity, world)
  if (entity.spawnFlags & wmconstants.CLOCK_TIMER_UP) != 0 then entity.health = entity.health + 1
  else if (entity.spawnFlags & wmconstants.CLOCK_TIMER_DOWN) != 0 then entity.health = entity.health - 1
  end if
  display.message = entity.message
  wmcore.useEntity(world, display, entity, entity)
  wmcore.emit(world, "clock-tick", entity, entity.message)

  finished = ((entity.spawnFlags & wmconstants.CLOCK_TIMER_UP) != 0 and entity.health > entity.wait) or
    ((entity.spawnFlags & wmconstants.CLOCK_TIMER_DOWN) != 0 and entity.health < entity.wait)
  if finished then
    if entity.pathTarget != "" then
      savedTarget = entity.target
      savedMessage = entity.message
      entity.target = entity.pathTarget
      entity.message = ""
      wmcore.useTargets(world, entity, entity.activator)
      entity.target = savedTarget
      entity.message = savedMessage
      if entity.inUse == false then return false end if
    end if
    if (entity.spawnFlags & wmconstants.CLOCK_MULTI_USE) == 0 then return true end if
    resetWorldClock(entity)
    if (entity.spawnFlags & wmconstants.CLOCK_START_OFF) != 0 then return true end if
  end if
  entity.think = worldClockThink
  entity.nextThink = world.time + 1.0
  return true
end function

// Use world clock.
function useWorldClock(entity, other, activator, world)
  if (entity.spawnFlags & wmconstants.CLOCK_MULTI_USE) == 0 then entity.use = void end if
  if entity.activator is not void then return false end if
  entity.activator = activator
  return worldClockThink(entity, world)
end function

// Spawn world clock.
function spawnWorldClock(entity, world)
  if entity.target == "" then
    wmcore.log(world, "func_clock with no target")
    wmcore.freeEntity(world, entity)
    return false
  end if
  if entity.style < 0 or entity.style > 2 then
    wmcore.log(world, "func_clock style outside [0,2]")
    wmcore.freeEntity(world, entity)
    return false
  end if
  if (entity.spawnFlags & wmconstants.CLOCK_TIMER_DOWN) != 0 and entity.count <= 0 then
    wmcore.log(world, "func_clock TIMER_DOWN with no count")
    wmcore.freeEntity(world, entity)
    return false
  end if
  if (entity.spawnFlags & wmconstants.CLOCK_TIMER_UP) != 0 and entity.count <= 0 then entity.count = 3600 end if
  resetWorldClock(entity)
  entity.message = ""
  entity.think = worldClockThink
  if (entity.spawnFlags & wmconstants.CLOCK_START_OFF) != 0 then entity.use = useWorldClock
  else entity.nextThink = world.time + 1.0
  end if
  return entity
end function

// Spawn target character.
function SP_target_character(entity, world)
  return spawnTargetCharacter(entity, world)
end function

// Spawn target string.
function SP_target_string(entity, world)
  return spawnTargetString(entity, world)
end function

// Spawn func clock.
function SP_func_clock(entity, world)
  return spawnWorldClock(entity, world)
end function

// Spawn point combat.
function SP_point_combat(entity, world)
  return spawnPointCombat(entity, world, false)
end function
// Spawn info notnull.
function SP_info_notnull(entity, world)
  return spawnInfoNotNull(entity, world)
end function
// Spawn misc blackhole.
function SP_misc_blackhole(entity, world)
  return spawnBlackHole(entity, world)
end function
// Spawn misc eastertank.
function SP_misc_eastertank(entity, world)
  return spawnEasterTank(entity, world)
end function
// Spawn misc easterchick.
function SP_misc_easterchick(entity, world)
  return spawnEasterChick(entity, world)
end function
// Spawn misc easterchick 2.
function SP_misc_easterchick2(entity, world)
  return spawnEasterChick2(entity, world)
end function
// Spawn misc satellite dish.
function SP_misc_satellite_dish(entity, world)
  return spawnSatelliteDish(entity, world)
end function
// Spawn light mine 2.
function SP_light_mine2(entity, world)
  return spawnLightMine2(entity, world)
end function
// Spawn misc viper.
function SP_misc_viper(entity, world)
  return spawnViper(entity, world)
end function
// Spawn misc viper bomb.
function SP_misc_viper_bomb(entity, world)
  return spawnViperBomb(entity, world)
end function
