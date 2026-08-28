/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* BaseQ2 g_trigger.c trigger_multiple/once/relay state machines. */
package miniquake2.game.world.triggers

import std.math as smath
import miniquake2.game.world.constants as gwconstants
import miniquake2.game.world.core as gwcore
import miniquake2.game.world.vector as gwvector

// Initialize trigger.
function initTrigger(entity, world)
  zeroAngles = gwvector.scale(entity.angles, 0.0)
  if gwvector.equal(entity.angles, zeroAngles) == false then
    entity.moveDirection = gwvector.movedir(entity.angles)
  end if
  entity.solid = gwconstants.SOLID_TRIGGER
  entity.moveType = gwconstants.MOVETYPE_NONE
  entity.serverFlags = entity.serverFlags | gwconstants.SVF_NOCLIENT
  world.callbacks.linkEntity(entity)
  return entity
end function

// Return the multi wait value.
function multiWait(entity, world)
  entity.nextThink = 0.0
  return true
end function

// Return the multi trigger value.
function multiTrigger(entity, world)
  if entity.nextThink != 0.0 then return false end if
  gwcore.useTargets(world, entity, entity.activator)
  if entity.inUse == false then return false end if
  if entity.wait > 0.0 then
    entity.think = multiWait
    entity.nextThink = world.time + entity.wait
  else
    // G_FreeEdict is deferred by one server frame because touch iteration may
    // still hold this entity.
    entity.touch = void
    entity.think = gwcore.freeThink
    entity.nextThink = world.time + world.frameTime
  end if
  return true
end function

// Use multi.
function useMulti(entity, other, activator, world)
  entity.activator = activator
  return multiTrigger(entity, world)
end function

// Handle multi.
function touchMulti(entity, other, world)
  if other is void or other.inUse == false then return false end if
  if other.isClient then
    if (entity.spawnFlags & gwconstants.TRIGGER_NOT_PLAYER) != 0 then return false end if
  else if (other.serverFlags & gwconstants.SVF_MONSTER) != 0 then
    if (entity.spawnFlags & gwconstants.TRIGGER_MONSTER) == 0 then return false end if
  else
    return false
  end if

  zeroDirection = gwvector.scale(entity.moveDirection, 0.0)
  if gwvector.equal(entity.moveDirection, zeroDirection) == false then
    forward = gwvector.movedir(other.angles)
    if gwvector.dot(forward, entity.moveDirection) < 0.0 then return false end if
  end if
  entity.activator = other
  return multiTrigger(entity, world)
end function

// Return the enable trigger value.
function enableTrigger(entity, other, activator, world)
  entity.solid = gwconstants.SOLID_TRIGGER
  entity.use = useMulti
  world.callbacks.linkEntity(entity)
  return true
end function

// Spawn multiple.
function spawnMultiple(entity, world)
  if entity.sounds == 1 then entity.noise = "misc/secret.wav"
  else if entity.sounds == 2 then entity.noise = "misc/talk.wav"
  else if entity.sounds == 3 then entity.noise = "misc/trigger1.wav"
  end if
  if entity.wait == 0.0 then entity.wait = 0.2 end if
  entity.touch = touchMulti
  entity.moveType = gwconstants.MOVETYPE_NONE
  entity.serverFlags = entity.serverFlags | gwconstants.SVF_NOCLIENT
  if (entity.spawnFlags & gwconstants.TRIGGER_TRIGGERED) != 0 then
    entity.solid = gwconstants.SOLID_NOT
    entity.use = enableTrigger
  else
    entity.solid = gwconstants.SOLID_TRIGGER
    entity.use = useMulti
  end if
  zeroAngles = gwvector.scale(entity.angles, 0.0)
  if gwvector.equal(entity.angles, zeroAngles) == false then
    entity.moveDirection = gwvector.movedir(entity.angles)
  end if
  world.callbacks.linkEntity(entity)
  return entity
end function

// Spawn once.
function spawnOnce(entity, world)
  // Compatibility with early maps where TRIGGERED incorrectly used bit 1.
  if (entity.spawnFlags & 1) != 0 then
    entity.spawnFlags = (entity.spawnFlags & ~1) | gwconstants.TRIGGER_TRIGGERED
    gwcore.log(world, "fixed TRIGGERED flag on " + entity.className)
  end if
  entity.wait = -1.0
  return spawnMultiple(entity, world)
end function

// Use relay.
function useRelay(entity, other, activator, world)
  return gwcore.useTargets(world, entity, activator)
end function

// Spawn relay.
function spawnRelay(entity, world)
  entity.use = useRelay
  return entity
end function

// Spawn always.
function spawnAlways(entity, world)
  if entity.delay < 0.2 then entity.delay = 0.2 end if
  gwcore.useTargets(world, entity, entity)
  return entity
end function

// -------------------------------------------------------------------------
// trigger_key. Inventory and cooperative power-cube policy remain outside the
// world package through resolve/has/consume callbacks.

function useKey(entity, other, activator, world)
  if entity.item == "" then return false end if
  if activator is void or typeof(activator) != "struct" or activator.isClient == false then return false end if
  available = world.callbacks.hasKeyItem(activator, entity.item)
  if typeof(available) != "bool" then return error(9390, "trigger_key hasKeyItem callback must return bool") end if
  if available == false then
    if world.time < entity.touchDebounceTime then return false end if
    entity.touchDebounceTime = world.time + 5.0
    world.callbacks.centerPrint(activator, "You need the " + entity.itemName)
    world.callbacks.sound(activator, "misc/keytry.wav")
    gwcore.emit(world, "key-missing", entity, entity.item)
    return true
  end if

  consumed = world.callbacks.consumeKeyItem(activator, entity.item)
  if typeof(consumed) != "bool" then return error(9391, "trigger_key consumeKeyItem callback must return bool") end if
  if consumed == false then
    gwcore.log(world, "trigger_key inventory changed before consumption: " + entity.item)
    return false
  end if
  world.callbacks.sound(activator, "misc/keyuse.wav")
  gwcore.emit(world, "key-used", entity, entity.item)
  gwcore.useTargets(world, entity, activator)
  entity.use = void
  return true
end function

// Spawn key.
function spawnKey(entity, world)
  if typeof(entity.item) != "string" or entity.item == "" then
    gwcore.log(world, "no key item for trigger_key")
    return false
  end if
  pickupName = world.callbacks.resolveKeyItem(entity.item)
  if pickupName is void then
    gwcore.log(world, "trigger_key item not found: " + entity.item)
    return false
  end if
  if typeof(pickupName) != "string" or pickupName == "" then
    return error(9392, "trigger_key resolveKeyItem callback must return pickup text or void")
  end if
  if entity.target == "" then
    gwcore.log(world, "trigger_key has no target")
    return false
  end if
  entity.itemName = pickupName
  entity.use = useKey
  return entity
end function

// Use counter.
function useCounter(entity, other, activator, world)
  if entity.count == 0 then return false end if
  entity.count = entity.count - 1
  if entity.count > 0 then
    if (entity.spawnFlags & 1) == 0 and activator is not void then
      world.callbacks.centerPrint(activator, entity.count + " more to go...")
      world.callbacks.sound(activator, "misc/talk1.wav")
    end if
    return true
  end if
  if (entity.spawnFlags & 1) == 0 and activator is not void then
    world.callbacks.centerPrint(activator, "Sequence completed!")
    world.callbacks.sound(activator, "misc/talk1.wav")
  end if
  entity.activator = activator
  return multiTrigger(entity, world)
end function

// Spawn counter.
function spawnCounter(entity, world)
  entity.wait = -1.0
  if entity.count == 0 then entity.count = 2 end if
  entity.use = useCounter
  entity.serverFlags = entity.serverFlags | gwconstants.SVF_NOCLIENT
  return entity
end function

// Handle hurt.
function hurtTouch(entity, other, world)
  if other is void or other.inUse == false or other.takeDamage == gwconstants.DAMAGE_NO then return false end if
  if world.time < entity.touchDebounceTime then return false end if
  if (entity.spawnFlags & 16) != 0 then entity.touchDebounceTime = world.time + 1.0
  else entity.touchDebounceTime = world.time + world.frameTime
  end if
  if (entity.spawnFlags & 4) == 0 then
    frameNumber = smath.floor(world.time / world.frameTime + 0.00001)
    if frameNumber % 10 == 0 then
      world.callbacks.sound(other, entity.noise)
    end if
  end if
  means = gwconstants.MOD_TRIGGER_HURT
  if (entity.spawnFlags & 8) != 0 then means = gwconstants.MOD_TRIGGER_HURT_NO_PROTECTION end if
  world.callbacks.damage(other, entity, entity, entity.damage, means)
  return true
end function

// Use hurt.
function hurtUse(entity, other, activator, world)
  if entity.solid == gwconstants.SOLID_NOT then entity.solid = gwconstants.SOLID_TRIGGER else entity.solid = gwconstants.SOLID_NOT end if
  world.callbacks.linkEntity(entity)
  if (entity.spawnFlags & 2) == 0 then entity.use = void end if
  return true
end function

// Spawn hurt.
function spawnHurt(entity, world)
  initTrigger(entity, world)
  entity.noise = "world/electro.wav"
  entity.touch = hurtTouch
  if entity.damage == 0 then entity.damage = 5 end if
  if (entity.spawnFlags & 1) != 0 then entity.solid = gwconstants.SOLID_NOT end if
  if (entity.spawnFlags & 2) != 0 then entity.use = hurtUse end if
  world.callbacks.linkEntity(entity)
  return entity
end function

// Handle push.
function pushTouch(entity, other, world)
  if other is void or other.inUse == false then return false end if
  pushed = other.className == "grenade" or other.health > 0
  if pushed then
    other.velocity = gwvector.scale(entity.moveDirection, entity.speed * 10.0)
    if other.isClient then
      other.oldVelocity = gwvector.copy(other.velocity)
      if other.flySoundDebounceTime < world.time then
        other.flySoundDebounceTime = world.time + 1.5
        world.callbacks.sound(other, entity.noise)
      end if
    end if
  end if
  if (entity.spawnFlags & gwconstants.PUSH_ONCE) != 0 then gwcore.freeEntity(world, entity) end if
  return pushed
end function

// Spawn push.
function spawnPush(entity, world)
  initTrigger(entity, world)
  entity.noise = "misc/windfly.wav"
  entity.touch = pushTouch
  entity.moveDirection = gwvector.movedir(entity.angles)
  if entity.speed == 0.0 then entity.speed = 1000.0 end if
  return entity
end function

// Handle gravity.
function gravityTouch(entity, other, world)
  if other is void or other.inUse == false then return false end if
  other.gravity = entity.gravity
  return true
end function

// Spawn gravity.
function spawnGravity(entity, world)
  // The stock game tests whether the mapper supplied the spawn-temp key, not
  // the edict's physical gravity multiplier (which defaults to one).
  if not entity.gravitySpecified then
    gwcore.log(world, "trigger_gravity without gravity set")
    gwcore.freeEntity(world, entity)
    return false
  end if
  initTrigger(entity, world)
  entity.touch = gravityTouch
  return entity
end function

// Handle monster jump.
function monsterJumpTouch(entity, other, world)
  if other is void then return false end if
  if (other.flags & (gwconstants.FL_FLY | gwconstants.FL_SWIM)) != 0 then return false end if
  if (other.serverFlags & gwconstants.SVF_DEADMONSTER) != 0 then return false end if
  if (other.serverFlags & gwconstants.SVF_MONSTER) == 0 then return false end if
  other.velocity.x = entity.moveDirection.x * entity.speed
  other.velocity.y = entity.moveDirection.y * entity.speed
  if other.groundEntity is void then return true end if
  other.groundEntity = void
  other.velocity.z = entity.moveDirection.z
  return true
end function

// Spawn monster jump.
function spawnMonsterJump(entity, world)
  if entity.speed == 0.0 then entity.speed = 200.0 end if
  if entity.height == 0.0 then entity.height = 200.0 end if
  if entity.angles.y == 0.0 then entity.angles.y = 360.0 end if
  initTrigger(entity, world)
  entity.touch = monsterJumpTouch
  entity.moveDirection.z = entity.height
  return entity
end function

// Spawn trigger multiple.
function SP_trigger_multiple(entity, world)
  return spawnMultiple(entity, world)
end function
// Spawn trigger once.
function SP_trigger_once(entity, world)
  return spawnOnce(entity, world)
end function
// Spawn trigger relay.
function SP_trigger_relay(entity, world)
  return spawnRelay(entity, world)
end function
// Spawn trigger always.
function SP_trigger_always(entity, world)
  return spawnAlways(entity, world)
end function
// Spawn trigger counter.
function SP_trigger_counter(entity, world)
  return spawnCounter(entity, world)
end function
// Spawn trigger hurt.
function SP_trigger_hurt(entity, world)
  return spawnHurt(entity, world)
end function
// Spawn trigger push.
function SP_trigger_push(entity, world)
  return spawnPush(entity, world)
end function
// Spawn trigger gravity.
function SP_trigger_gravity(entity, world)
  return spawnGravity(entity, world)
end function
// Spawn trigger monsterjump.
function SP_trigger_monsterjump(entity, world)
  return spawnMonsterJump(entity, world)
end function
// Spawn trigger key.
function SP_trigger_key(entity, world)
  return spawnKey(entity, world)
end function
