/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* G_UseTargets, entity lifetime and deterministic world scheduling. */
package miniquake2.game.world.core

import miniquake2.qcommon.text as qtext
import miniquake2.qcommon.types as gwcoreqtypes
import miniquake2.game.world.constants as gwconstants
import miniquake2.game.world.types as gwtypes
import miniquake2.game.world.vector as gwvector

const MAX_WORLD_EVENT_HISTORY = 1024

// Append world core event.
function worldCoreAppendEvent(values, value)
  if len(values) < MAX_WORLD_EVENT_HISTORY then return values + [value] end if
  output = array(MAX_WORLD_EVENT_HISTORY, void)
  index = 1
  while index < MAX_WORLD_EVENT_HISTORY
    output[index - 1] = values[index]
    index = index + 1
  end while
  output[MAX_WORLD_EVENT_HISTORY - 1] = value
  return output
end function

// Return the noop log value.
function noopLog(message)
  return true
end function
// Print noop center.
function noopCenterPrint(entity, message)
  return true
end function
// Return the noop sound value.
function noopSound(entity, soundName)
  return true
end function
// Return the noop area portal value.
function noopAreaPortal(style, isOpen)
  return true
end function
// Return the noop damage value.
function noopDamage(target, inflictor, attacker, amount, means)
  return true
end function
// Return the noop radius damage value.
function noopRadiusDamage(inflictor, attacker, amount, radius, means)
  return true
end function
// Return the noop effect value.
function noopEffect(kind, origin, style, count)
  return true
end function
// Return the noop change level value.
function noopChangeLevel(entity, other, activator, mapName)
  return true
end function
// Spawn noop external.
function noopSpawnExternal(className, origin, angles, velocity)
  return true
end function
// Link noop entity.
function noopLinkEntity(entity)
  return true
end function
// Kill noop box.
function noopKillBox(entity)
  return true
end function
// Return the zero random signed value.
function zeroRandomSigned()
  return 0.0
end function
// Return the zero random index.
function zeroRandomIndex(count)
  return 0
end function
// Resolve noop key item.
function noopResolveKeyItem(itemClassName)
  return void
end function
// Report whether noop has key item.
function noopHasKeyItem(activator, itemClassName)
  return false
end function
// Consume noop key item.
function noopConsumeKeyItem(activator, itemClassName)
  return false
end function
// Return the noop actor message value.
function noopActorMessage(actor, message)
  return true
end function
// Return the noop actor transition value.
function noopActorTransition(actor, waypoint, action, actionTarget, nextTarget, wait, flags)
  return true
end function
// Return the noop combat point transition value.
function noopCombatPointTransition(actor, point, nextTarget, hold, clearCombatPoint)
  return true
end function
// Return the zero clock seconds value.
function zeroClockSeconds()
  return 0
end function
// Set noop model.
function noopSetModel(entity, modelName)
  return true
end function
// Return the noop light style value.
function noopLightStyle(style, pattern)
  return true
end function
// Trace noop line.
function noopTraceLine(start, finish, ignore)
  return gwtypes.WorldTrace(false, finish, gwcoreqtypes.zeroVec3(), void)
end function
// Return the noop laser sparks value.
function noopLaserSparks(origin, normal, count, color)
  return true
end function
// Return the noop earthquake value.
function noopEarthquake(entity, speed, playSound)
  return 0
end function
// Fire noop blaster.
function noopFireBlaster(entity, direction, damage, speed)
  return void
end function
// Return the noop target explosion value.
function noopTargetExplosion(origin)
  return true
end function
// Return the noop target splash value.
function noopTargetSplash(origin, direction, count, sounds)
  return true
end function

// Return the default callbacks value.
function defaultCallbacks()
  return gwtypes.WorldCallbacks(
    noopLog, noopCenterPrint, noopSound, noopAreaPortal,
    noopDamage, noopRadiusDamage, noopEffect, noopChangeLevel,
    noopSpawnExternal, noopLinkEntity, noopKillBox,
    zeroRandomSigned, zeroRandomIndex,
    noopResolveKeyItem, noopHasKeyItem, noopConsumeKeyItem,
    noopActorMessage, noopActorTransition, noopCombatPointTransition, zeroClockSeconds,
    noopSetModel, noopLightStyle,
    noopTraceLine, noopLaserSparks, noopEarthquake, noopFireBlaster,
    noopTargetExplosion, noopTargetSplash
  )
end function

// Create world.
function createWorld(callbacks)
  if callbacks is void then callbacks = defaultCallbacks() end if
  return gwtypes.WorldState(
    [], 0.0, gwconstants.FRAME_TIME, void, 1, callbacks, [],
    "", "", 0, 0, 0, 0, 0, 0, false
  )
end function

// Emit state.
function emit(world, kind, entity, detail)
  number = 0
  if entity is not void then number = entity.number end if
  world.events = worldCoreAppendEvent(world.events, [world.time, kind, number, detail])
  return true
end function

// Return the log value.
function log(world, message)
  emit(world, "log", void, message)
  return world.callbacks.log(message)
end function

// Add entity.
function addEntity(world, entity)
  if entity.number <= 0 then
    entity.number = world.nextEntityNumber
    world.nextEntityNumber = world.nextEntityNumber + 1
  else if entity.number >= world.nextEntityNumber then
    world.nextEntityNumber = entity.number + 1
  end if
  world.entities = world.entities + [entity]
  return entity
end function

// Spawn entity.
function spawnEntity(world, className)
  entity = gwtypes.createEntity(world.nextEntityNumber, className)
  world.nextEntityNumber = world.nextEntityNumber + 1
  world.entities = world.entities + [entity]
  return entity
end function

// Release entity.
function freeEntity(world, entity)
  if entity is void or entity.inUse == false then return false end if
  entity.inUse = false
  entity.solid = gwconstants.SOLID_NOT
  entity.use = void
  entity.think = void
  entity.touch = void
  entity.blocked = void
  entity.die = void
  entity.nextThink = 0.0
  entity.velocity.x = 0.0
  entity.velocity.y = 0.0
  entity.velocity.z = 0.0
  emit(world, "free", entity, entity.className)
  return true
end function

// Release think.
function freeThink(entity, world)
  return freeEntity(world, entity)
end function

// Find by number.
function findByNumber(world, number)
  for each entity in world.entities
    if entity.inUse and entity.number == number then return entity end if
  end for
  return void
end function

// Return the matching targets value.
function matchingTargets(world, targetName)
  result = []
  if typeof(targetName) != "string" then return error(9290, "matchingTargets targetName is not text") end if
  if targetName == "" then return result end if
  for each entity in world.entities
    gwMatchingEntityTargetHolder = entity.targetName
    if typeof(gwMatchingEntityTargetHolder) != "string" then return error(9291, "matchingTargets entity targetName is not text") end if
    if entity.inUse and gwMatchingEntityTargetHolder != "" and qtext.equalInsensitive(gwMatchingEntityTargetHolder, targetName) then
      result = result + [entity]
    end if
  end for
  return result
end function

// Choose target.
function pickTarget(world, targetName)
  choices = matchingTargets(world, targetName)
  if len(choices) == 0 then
    log(world, "G_PickTarget: target " + targetName + " not found")
    return void
  end if
  count = len(choices)
  if count > 8 then count = 8 end if
  selected = world.callbacks.randomIndex(count)
  if typeof(selected) != "int" then selected = 0 end if
  if selected < 0 then selected = -selected end if
  selected = selected % count
  return choices[selected]
end function

// Use entity.
function useEntity(world, entity, other, activator)
  if entity is void or entity.inUse == false or entity.use is void then return false end if
  emit(world, "use", entity, entity.className)
  entity.use(entity, other, activator, world)
  return true
end function

// Handle entity.
function touchEntity(world, entity, other)
  if entity is void or entity.inUse == false or entity.touch is void then return false end if
  emit(world, "touch", entity, entity.className)
  entity.touch(entity, other, world)
  return true
end function

// Report whether blocked entity.
function blockedEntity(world, entity, other)
  if entity is void or entity.inUse == false or entity.blocked is void then return false end if
  entity.blocked(entity, other, world)
  return true
end function

// Kill entity.
function killEntity(world, entity, inflictor, attacker, damage, point)
  if entity is void or entity.inUse == false or entity.die is void then return false end if
  entity.die(entity, inflictor, attacker, damage, point, world)
  return true
end function

// Run delayed.
function thinkDelayed(entity, world)
  useTargets(world, entity, entity.activator)
  freeEntity(world, entity)
  return true
end function

// Use targets.
function useTargets(world, entity, activator)
  if entity.delay != 0.0 then
    delayed = spawnEntity(world, "DelayedUse")
    delayed.nextThink = world.time + entity.delay
    delayed.think = thinkDelayed
    delayed.activator = activator
    delayed.message = entity.message
    delayed.target = entity.target
    delayed.killTarget = entity.killTarget
    emit(world, "delayed-use", delayed, entity.className)
    if activator is void then log(world, "Think_Delay with no activator") end if
    return delayed
  end if

  if entity.message != "" and activator is not void and (activator.serverFlags & gwconstants.SVF_MONSTER) == 0 then
    world.callbacks.centerPrint(activator, entity.message)
    messageSound = entity.noise
    if messageSound == "" then messageSound = "misc/talk1.wav" end if
    world.callbacks.sound(activator, messageSound)
    emit(world, "message", activator, entity.message)
  end if

  if entity.killTarget != "" then
    killMatches = matchingTargets(world, entity.killTarget)
    for each victim in killMatches
      freeEntity(world, victim)
      if entity.inUse == false then
        log(world, "entity was removed while using killtargets")
        return false
      end if
    end for
  end if

  if entity.target != "" then
    // Preserve edict-number iteration order. Snapshotting the matches also
    // avoids a newly spawned same-name target being used in this dispatch.
    targets = matchingTargets(world, entity.target)
    for each targetEntity in targets
      gwUseTargetClassHolder = targetEntity.className
      gwUseSourceClassHolder = entity.className
      if typeof(gwUseTargetClassHolder) != "string" or typeof(gwUseSourceClassHolder) != "string" then
        return error(9292, "useTargets classname is not text")
      end if
      skipAreaPortal = qtext.equalInsensitive(gwUseTargetClassHolder, "func_areaportal") and
        (qtext.equalInsensitive(gwUseSourceClassHolder, "func_door") or
         qtext.equalInsensitive(gwUseSourceClassHolder, "func_door_rotating") or
         qtext.equalInsensitive(gwUseSourceClassHolder, "func_door_secret") or
         qtext.equalInsensitive(gwUseSourceClassHolder, "func_water"))
      if skipAreaPortal == false then
        if targetEntity.number == entity.number then
          log(world, "WARNING: Entity used itself.")
        else
          useEntity(world, targetEntity, entity, activator)
        end if
      end if
      if entity.inUse == false then
        log(world, "entity was removed while using targets")
        return false
      end if
    end for
  end if
  return true
end function

// Return the integrate value.
function inline integrate(world, duration)
  if duration <= 0.0 then return true end if
  for each entity in world.entities
    if entity.inUse then
      velocity = entity.velocity
      if velocity.x != 0.0 or velocity.y != 0.0 or velocity.z != 0.0 then
        origin = entity.origin
        origin.x = origin.x + duration * velocity.x
        origin.y = origin.y + duration * velocity.y
        origin.z = origin.z + duration * velocity.z
      end if
      angularVelocity = entity.angularVelocity
      if angularVelocity.x != 0.0 or angularVelocity.y != 0.0 or
          angularVelocity.z != 0.0 then
        angles = entity.angles
        angles.x = angles.x + duration * angularVelocity.x
        angles.y = angles.y + duration * angularVelocity.y
        angles.z = angles.z + duration * angularVelocity.z
      end if
    end if
  end for
  return true
end function

// Advance state.
function advance(world, targetTime)
  // Keep advance phases explicit: validate inputs, update owned state, then publish the result.
  if targetTime < world.time then return error(9200, "world time cannot move backwards") end if
  timeEpsilon = 0.000000001
  iterations = 0
  while world.time < targetTime or iterations == 0
    nextEvent = targetTime
    foundDue = false
    for each entity in world.entities
      if entity.inUse and entity.think is not void and entity.nextThink > 0.0 then
        if entity.nextThink <= world.time + timeEpsilon then
          nextEvent = world.time
          foundDue = true
        else if entity.nextThink < nextEvent then
          nextEvent = entity.nextThink
        end if
      end if
    end for

    if nextEvent > world.time then
      integrate(world, nextEvent - world.time)
      world.time = nextEvent
    end if

    processed = false
    entityIndex = 0
    scanCount = len(world.entities)
    while entityIndex < scanCount
      entity = world.entities[entityIndex]
      if entity.inUse and entity.think is not void and entity.nextThink > 0.0 and entity.nextThink <= world.time + timeEpsilon then
        callback = entity.think
        entity.nextThink = 0.0
        world.currentEntity = entity
        callback(entity, world)
        world.currentEntity = void
        processed = true
      end if
      entityIndex = entityIndex + 1
    end while

    iterations = iterations + 1
    if iterations > 10000 then return error(9201, "world scheduler exceeded deterministic think limit") end if
    if world.time >= targetTime and processed == false then break end if
    if world.time >= targetTime and foundDue == false then
      pendingNow = false
      for each pending in world.entities
        if pending.inUse and pending.think is not void and pending.nextThink > 0.0 and pending.nextThink <= world.time + timeEpsilon then pendingNow = true end if
      end for
      if pendingNow == false then break end if
    end if
  end while
  return true
end function

// Run frame.
function runFrame(world)
  return advance(world, world.time + world.frameTime)
end function

// Source-traceable entry points retained for later baseq2 registry wiring.
function G_UseTargets(entity, activator, world)
  return useTargets(world, entity, activator)
end function

// Run delay.
function Think_Delay(entity, world)
  return thinkDelayed(entity, world)
end function
