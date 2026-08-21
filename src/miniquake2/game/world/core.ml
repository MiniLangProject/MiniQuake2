/* G_UseTargets, entity lifetime and deterministic world scheduling. */
package miniquake2.game.world.core

import miniquake2.qcommon.text as qtext
import miniquake2.game.world.constants as gwconstants
import miniquake2.game.world.types as gwtypes
import miniquake2.game.world.vector as gwvector

const MAX_WORLD_EVENT_HISTORY = 1024

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

function noopLog(message)
  return true
end function
function noopCenterPrint(entity, message)
  return true
end function
function noopSound(entity, soundName)
  return true
end function
function noopAreaPortal(style, isOpen)
  return true
end function
function noopDamage(target, inflictor, attacker, amount, means)
  return true
end function
function noopRadiusDamage(inflictor, attacker, amount, radius, means)
  return true
end function
function noopEffect(kind, origin, style, count)
  return true
end function
function noopChangeLevel(entity, mapName)
  return true
end function
function noopSpawnExternal(className, origin, angles, velocity)
  return true
end function
function noopLinkEntity(entity)
  return true
end function
function noopKillBox(entity)
  return true
end function
function zeroRandomSigned()
  return 0.0
end function
function zeroRandomIndex(count)
  return 0
end function
function noopResolveKeyItem(itemClassName)
  return void
end function
function noopHasKeyItem(activator, itemClassName)
  return false
end function
function noopConsumeKeyItem(activator, itemClassName)
  return false
end function
function noopActorMessage(actor, message)
  return true
end function
function noopActorTransition(actor, waypoint, action, actionTarget, nextTarget, wait, flags)
  return true
end function
function noopCombatPointTransition(actor, point, nextTarget, hold, clearCombatPoint)
  return true
end function
function zeroClockSeconds()
  return 0
end function
function noopSetModel(entity, modelName)
  return true
end function

function defaultCallbacks()
  return gwtypes.WorldCallbacks(
    noopLog, noopCenterPrint, noopSound, noopAreaPortal,
    noopDamage, noopRadiusDamage, noopEffect, noopChangeLevel,
    noopSpawnExternal, noopLinkEntity, noopKillBox,
    zeroRandomSigned, zeroRandomIndex,
    noopResolveKeyItem, noopHasKeyItem, noopConsumeKeyItem,
    noopActorMessage, noopActorTransition, noopCombatPointTransition, zeroClockSeconds,
    noopSetModel
  )
end function

function createWorld(callbacks)
  if callbacks is void then callbacks = defaultCallbacks() end if
  return gwtypes.WorldState(
    [], 0.0, gwconstants.FRAME_TIME, void, 1, callbacks, [],
    "", "", 0, 0, 0, 0, 0, 0, false
  )
end function

function emit(world, kind, entity, detail)
  number = 0
  if entity is not void then number = entity.number end if
  world.events = worldCoreAppendEvent(world.events, [world.time, kind, number, detail])
  return true
end function

function log(world, message)
  emit(world, "log", void, message)
  return world.callbacks.log(message)
end function

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

function spawnEntity(world, className)
  entity = gwtypes.createEntity(world.nextEntityNumber, className)
  world.nextEntityNumber = world.nextEntityNumber + 1
  world.entities = world.entities + [entity]
  return entity
end function

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

function freeThink(entity, world)
  return freeEntity(world, entity)
end function

function findByNumber(world, number)
  for each entity in world.entities
    if entity.inUse and entity.number == number then return entity end if
  end for
  return void
end function

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

function useEntity(world, entity, other, activator)
  if entity is void or entity.inUse == false or entity.use is void then return false end if
  emit(world, "use", entity, entity.className)
  entity.use(entity, other, activator, world)
  return true
end function

function touchEntity(world, entity, other)
  if entity is void or entity.inUse == false or entity.touch is void then return false end if
  emit(world, "touch", entity, entity.className)
  entity.touch(entity, other, world)
  return true
end function

function blockedEntity(world, entity, other)
  if entity is void or entity.inUse == false or entity.blocked is void then return false end if
  entity.blocked(entity, other, world)
  return true
end function

function killEntity(world, entity, inflictor, attacker, damage, point)
  if entity is void or entity.inUse == false or entity.die is void then return false end if
  entity.die(entity, inflictor, attacker, damage, point, world)
  return true
end function

function thinkDelayed(entity, world)
  useTargets(world, entity, entity.activator)
  freeEntity(world, entity)
  return true
end function

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
    world.callbacks.sound(activator, "misc/talk1.wav")
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
      skipAreaPortal = qtext.equalInsensitive(gwUseTargetClassHolder, "func_areaportal") and (qtext.equalInsensitive(gwUseSourceClassHolder, "func_door") or qtext.equalInsensitive(gwUseSourceClassHolder, "func_door_rotating"))
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

function integrate(world, duration)
  if duration <= 0.0 then return true end if
  for each entity in world.entities
    if entity.inUse then
      nextOrigin = gwvector.multiplyAdd(entity.origin, duration, entity.velocity)
      nextAngles = gwvector.multiplyAdd(entity.angles, duration, entity.angularVelocity)
      entity.origin = nextOrigin
      entity.angles = nextAngles
    end if
  end for
  return true
end function

function advance(world, targetTime)
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

function runFrame(world)
  return advance(world, world.time + world.frameTime)
end function

// Source-traceable entry points retained for later baseq2 registry wiring.
function G_UseTargets(entity, activator, world)
  return useTargets(world, entity, activator)
end function

function Think_Delay(entity, world)
  return thinkDelayed(entity, world)
end function
