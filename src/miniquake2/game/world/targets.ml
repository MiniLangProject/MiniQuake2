/* Function-valued ports of the self-contained g_target.c target entities. */
package miniquake2.game.world.targets

import std.string as sstring
import miniquake2.game.world.constants as gwconstants
import miniquake2.game.world.core as gwcore
import miniquake2.game.world.vector as gwvector
import miniquake2.qcommon.types as targetactorqtypes
import miniquake2.qcommon.byteio as targetlightrampbyteio

// -------------------------------------------------------------------------
// target_actor from m_actor.c. AI-private state changes are represented by
// one explicit transition callback; this package still owns target lookup,
// pathtarget dispatch, jump velocity and deterministic waypoint chaining.

function targetActorTouch(entity, other, world)
  if other is void or typeof(other) != "struct" or other.inUse == false then return false end if
  if other.targetEntity != entity then return false end if
  if other.enemy is not void then return false end if

  other.targetEntity = void
  if entity.message != "" then
    world.callbacks.actorMessage(other, entity.message)
    gwcore.emit(world, "actor-message", entity, entity.message)
  end if

  if (entity.spawnFlags & gwconstants.ACTOR_JUMP) != 0 then
    other.velocity.x = entity.moveDirection.x * entity.speed
    other.velocity.y = entity.moveDirection.y * entity.speed
    if other.groundEntity is not void then
      other.groundEntity = void
      other.velocity.z = entity.moveDirection.z
      world.callbacks.sound(other, "player/male/jump1.wav")
    end if
  end if

  action = "move"
  actionTarget = void
  if (entity.spawnFlags & gwconstants.ACTOR_SHOOT) != 0 then
    action = "shoot"
    if entity.pathTarget != "" then actionTarget = gwcore.pickTarget(world, entity.pathTarget) end if
  else if (entity.spawnFlags & gwconstants.ACTOR_ATTACK) != 0 then
    action = "attack"
    if entity.pathTarget != "" then actionTarget = gwcore.pickTarget(world, entity.pathTarget) end if
    other.enemy = actionTarget
  else if entity.pathTarget != "" then
    savedTarget = entity.target
    entity.target = entity.pathTarget
    gwcore.useTargets(world, entity, other)
    entity.target = savedTarget
    if entity.inUse == false then return false end if
  end if

  nextTarget = void
  if entity.target != "" then nextTarget = gwcore.pickTarget(world, entity.target) end if
  other.targetEntity = nextTarget
  if nextTarget is void and other.enemy is void then action = "stand" end if
  world.callbacks.actorTransition(other, entity, action, actionTarget,
    nextTarget, entity.wait, entity.spawnFlags)
  gwcore.emit(world, "actor-transition", entity, action)
  return true
end function

function spawnTargetActor(entity, world)
  if entity.targetName == "" then gwcore.log(world, "target_actor with no targetname") end if
  entity.solid = gwconstants.SOLID_TRIGGER
  entity.touch = targetActorTouch
  entity.mins = targetactorqtypes.Vec3(-8.0, -8.0, -8.0)
  entity.maxs = targetactorqtypes.Vec3(8.0, 8.0, 8.0)
  entity.serverFlags = gwconstants.SVF_NOCLIENT
  if (entity.spawnFlags & gwconstants.ACTOR_JUMP) != 0 then
    if entity.speed == 0.0 then entity.speed = 200.0 end if
    if entity.height == 0.0 then entity.height = 200.0 end if
    if entity.angles.y == 0.0 then entity.angles.y = 360.0 end if
    entity.moveDirection = gwvector.movedir(entity.angles)
    entity.moveDirection.z = entity.height
  end if
  world.callbacks.linkEntity(entity)
  return entity
end function

function useTempEntity(entity, other, activator, world)
  world.callbacks.effect("temp-entity", entity.origin, entity.style, 1)
  gwcore.emit(world, "temp-entity", entity, entity.style)
  return true
end function

function spawnTempEntity(entity, world)
  entity.use = useTempEntity
  return entity
end function

function useSpeaker(entity, other, activator, world)
  if (entity.spawnFlags & 3) != 0 then
    if entity.loopSound != 0 then entity.loopSound = 0 else entity.loopSound = entity.soundIndex end if
  else
    world.callbacks.sound(entity, entity.noise)
  end if
  gwcore.emit(world, "speaker", entity, entity.noise)
  return true
end function

function spawnSpeaker(entity, world)
  if entity.noise == "" then
    gwcore.log(world, "target_speaker with no noise")
    return false
  end if
  if sstring.contains(entity.noise, ".wav") == false then entity.noise = entity.noise + ".wav" end if
  if entity.volume == 0.0 then entity.volume = 1.0 end if
  if entity.attenuation == 0.0 then entity.attenuation = 1.0 else if entity.attenuation == -1.0 then entity.attenuation = 0.0 end if
  if entity.soundIndex == 0 then entity.soundIndex = entity.number end if
  if (entity.spawnFlags & 1) != 0 then entity.loopSound = entity.soundIndex end if
  entity.use = useSpeaker
  world.callbacks.linkEntity(entity)
  return entity
end function

function useHelp(entity, other, activator, world)
  if (entity.spawnFlags & 1) != 0 then world.helpMessage1 = entity.message else world.helpMessage2 = entity.message end if
  world.helpChanged = world.helpChanged + 1
  return true
end function

function spawnHelp(entity, world)
  if entity.message == "" then
    gwcore.log(world, "target_help with no message")
    gwcore.freeEntity(world, entity)
    return false
  end if
  entity.use = useHelp
  return entity
end function

function useSecret(entity, other, activator, world)
  world.callbacks.sound(entity, entity.noise)
  world.foundSecrets = world.foundSecrets + 1
  gwcore.useTargets(world, entity, activator)
  gwcore.freeEntity(world, entity)
  return true
end function

function spawnSecret(entity, world)
  entity.use = useSecret
  if entity.noise == "" then entity.noise = "misc/secret.wav" end if
  entity.serverFlags = gwconstants.SVF_NOCLIENT
  world.totalSecrets = world.totalSecrets + 1
  return entity
end function

function useGoal(entity, other, activator, world)
  world.callbacks.sound(entity, entity.noise)
  world.foundGoals = world.foundGoals + 1
  if world.foundGoals == world.totalGoals then gwcore.emit(world, "cd-track", entity, 0) end if
  gwcore.useTargets(world, entity, activator)
  gwcore.freeEntity(world, entity)
  return true
end function

function spawnGoal(entity, world)
  entity.use = useGoal
  if entity.noise == "" then entity.noise = "misc/secret.wav" end if
  entity.serverFlags = gwconstants.SVF_NOCLIENT
  world.totalGoals = world.totalGoals + 1
  return entity
end function

function explosionThink(entity, world)
  // g_target.c publishes TE_EXPLOSION1 through MULTICAST_PHS.  Keep the
  // protocol-specific encoding outside the portable world simulation.
  world.callbacks.targetExplosion(entity.origin)
  world.callbacks.radiusDamage(entity, entity.activator, entity.damage, entity.damage + 40, gwconstants.MOD_EXPLOSIVE)
  savedDelay = entity.delay
  entity.delay = 0.0
  gwcore.useTargets(world, entity, entity.activator)
  entity.delay = savedDelay
  return true
end function

function useExplosion(entity, other, activator, world)
  entity.activator = activator
  if entity.delay == 0.0 then return explosionThink(entity, world) end if
  entity.think = explosionThink
  entity.nextThink = world.time + entity.delay
  return true
end function

function spawnExplosion(entity, world)
  entity.use = useExplosion
  entity.serverFlags = gwconstants.SVF_NOCLIENT
  return entity
end function

function useChangeLevel(entity, other, activator, world)
  if world.intermission then return false end if
  if sstring.contains(entity.map, "*") then world.serverFlags = world.serverFlags & ~gwconstants.SFL_CROSS_TRIGGER_MASK end if
  world.intermission = true
  world.callbacks.changeLevel(entity, entity.map)
  gwcore.emit(world, "change-level", entity, entity.map)
  return true
end function

function spawnChangeLevel(entity, world)
  if entity.map == "" then
    gwcore.log(world, "target_changelevel with no map")
    gwcore.freeEntity(world, entity)
    return false
  end if
  entity.use = useChangeLevel
  entity.serverFlags = gwconstants.SVF_NOCLIENT
  return entity
end function

function useSplash(entity, other, activator, world)
  // target_splash uses the map's "sounds" field as the TE_SPLASH color, not
  // style.  Its movedir is part of the wire event and cannot be reconstructed
  // by the client from origin/count alone.
  world.callbacks.targetSplash(entity.origin, entity.moveDirection,
    entity.count, entity.sounds)
  if entity.damage != 0 then world.callbacks.radiusDamage(entity, activator, entity.damage, entity.damage + 40, "splash") end if
  return true
end function

function spawnSplash(entity, world)
  entity.use = useSplash
  entity.moveDirection = gwvector.movedir(entity.angles)
  if entity.count == 0 then entity.count = 32 end if
  entity.serverFlags = gwconstants.SVF_NOCLIENT
  return entity
end function

function useSpawner(entity, other, activator, world)
  world.callbacks.spawnExternal(entity.target, entity.origin, entity.angles, entity.moveDirection)
  gwcore.emit(world, "spawn-external", entity, entity.target)
  return true
end function

function spawnSpawner(entity, world)
  entity.use = useSpawner
  entity.serverFlags = gwconstants.SVF_NOCLIENT
  if entity.speed != 0.0 then
    direction = gwvector.movedir(entity.angles)
    entity.moveDirection = gwvector.scale(direction, entity.speed)
  end if
  return entity
end function

function useBlaster(entity, other, activator, world)
  world.callbacks.fireBlaster(entity, entity.moveDirection, entity.damage,
    entity.speed)
  gwcore.emit(world, "target-blaster", entity, entity.damage)
  return true
end function

function spawnBlaster(entity, world)
  entity.use = useBlaster
  entity.moveDirection = gwvector.movedir(entity.angles)
  entity.noise = "weapons/laser2.wav"
  if entity.damage == 0 then entity.damage = 15 end if
  if entity.speed == 0.0 then entity.speed = 1000.0 end if
  entity.serverFlags = gwconstants.SVF_NOCLIENT
  return entity
end function

function useCrossLevelTrigger(entity, other, activator, world)
  world.serverFlags = world.serverFlags | entity.spawnFlags
  gwcore.freeEntity(world, entity)
  return true
end function

function spawnCrossLevelTrigger(entity, world)
  entity.serverFlags = gwconstants.SVF_NOCLIENT
  entity.use = useCrossLevelTrigger
  return entity
end function

function crossLevelTargetThink(entity, world)
  if entity.spawnFlags == (world.serverFlags & gwconstants.SFL_CROSS_TRIGGER_MASK & entity.spawnFlags) then
    gwcore.useTargets(world, entity, entity)
    gwcore.freeEntity(world, entity)
  end if
  return true
end function

function spawnCrossLevelTarget(entity, world)
  if entity.delay == 0.0 then entity.delay = 1.0 end if
  entity.serverFlags = gwconstants.SVF_NOCLIENT
  entity.think = crossLevelTargetThink
  entity.nextThink = world.time + entity.delay
  return entity
end function

const LASER_START_ON = 1
const LASER_RED = 2
const LASER_GREEN = 4
const LASER_BLUE = 8
const LASER_YELLOW = 16
const LASER_ORANGE = 32
const LASER_FAT = 64
const LASER_DIRECTION_CHANGED = 0x80000000

function laserThink(entity, world)
  sparkCount = 4
  if (entity.spawnFlags & LASER_DIRECTION_CHANGED) != 0 then sparkCount = 8 end if
  target = entity.targetEntity
  if target is not void and target.inUse then
    targetDelta = gwvector.subtract(target.origin, entity.origin)
    newDirection = gwvector.normalized(targetDelta)[0]
    if gwvector.equal(newDirection, entity.moveDirection) == false then
      entity.spawnFlags = entity.spawnFlags | LASER_DIRECTION_CHANGED
    end if
    entity.moveDirection = newDirection
  end if

  start = entity.origin
  finish = gwvector.multiplyAdd(start, 2048.0, entity.moveDirection)
  ignore = entity
  tracing = true
  traceCount = 0
  while tracing and traceCount < 256
    trace = world.callbacks.traceLine(start, finish, ignore)
    entity.oldOrigin = trace.endPosition
    if trace.hit == false or trace.entity is void then
      tracing = false
    else
      hit = trace.entity
      if hit.takeDamage != gwconstants.DAMAGE_NO and
          (hit.flags & gwconstants.FL_IMMUNE_LASER) == 0 then
        world.callbacks.damage(hit, entity, entity.activator, entity.damage,
          gwconstants.MOD_TARGET_LASER)
      end if

      // Stock target_laser passes through players and monsters, including an
      // immune boss, but stops at every other solid entity.
      if (hit.serverFlags & gwconstants.SVF_MONSTER) == 0 and hit.isClient == false then
        if (entity.spawnFlags & LASER_DIRECTION_CHANGED) != 0 then
          entity.spawnFlags = entity.spawnFlags & ~LASER_DIRECTION_CHANGED
          world.callbacks.laserSparks(trace.endPosition, trace.planeNormal,
            sparkCount, entity.style)
          gwcore.emit(world, "laser-sparks", entity, sparkCount)
        end if
        tracing = false
      else
        ignore = hit
        start = trace.endPosition
      end if
    end if
    traceCount = traceCount + 1
  end while

  entity.think = laserThink
  entity.nextThink = world.time + world.frameTime
  return true
end function

function laserOn(entity, world)
  if entity.activator is void then entity.activator = entity end if
  entity.spawnFlags = entity.spawnFlags | LASER_DIRECTION_CHANGED | LASER_START_ON
  entity.serverFlags = entity.serverFlags & ~gwconstants.SVF_NOCLIENT
  laserThink(entity, world)
  return true
end function

function laserOff(entity, world)
  entity.spawnFlags = entity.spawnFlags & ~LASER_START_ON
  entity.serverFlags = entity.serverFlags | gwconstants.SVF_NOCLIENT
  entity.nextThink = 0.0
  return true
end function

function laserUse(entity, other, activator, world)
  entity.activator = activator
  if (entity.spawnFlags & LASER_START_ON) != 0 then laserOff(entity, world)
  else laserOn(entity, world)
  end if
  world.callbacks.linkEntity(entity)
  return true
end function

function laserStart(entity, world)
  entity.moveType = gwconstants.MOVETYPE_NONE
  entity.solid = gwconstants.SOLID_NOT
  entity.renderFx = entity.renderFx | gwconstants.RF_BEAM | gwconstants.RF_TRANSLUCENT
  entity.modelIndex = 1
  if (entity.spawnFlags & LASER_FAT) != 0 then entity.frame = 16 else entity.frame = 4 end if
  if (entity.spawnFlags & LASER_RED) != 0 then entity.style = 0xf2f2f0f0
  else if (entity.spawnFlags & LASER_GREEN) != 0 then entity.style = 0xd0d1d2d3
  else if (entity.spawnFlags & LASER_BLUE) != 0 then entity.style = 0xf3f3f1f1
  else if (entity.spawnFlags & LASER_YELLOW) != 0 then entity.style = 0xdcdddedf
  else if (entity.spawnFlags & LASER_ORANGE) != 0 then entity.style = 0xe0e1e2e3
  end if

  if entity.targetEntity is void then
    if entity.target != "" then
      choices = gwcore.matchingTargets(world, entity.target)
      if len(choices) > 0 then entity.targetEntity = choices[0]
      else gwcore.log(world, "target_laser has a bad target " + entity.target)
      end if
    else
      entity.moveDirection = gwvector.movedir(entity.angles)
    end if
  end if
  entity.use = laserUse
  entity.think = laserThink
  if entity.damage == 0 then entity.damage = 1 end if
  entity.mins = targetactorqtypes.Vec3(-8.0, -8.0, -8.0)
  entity.maxs = targetactorqtypes.Vec3(8.0, 8.0, 8.0)
  world.callbacks.linkEntity(entity)
  if (entity.spawnFlags & LASER_START_ON) != 0 then laserOn(entity, world)
  else laserOff(entity, world)
  end if
  return true
end function

function spawnLaser(entity, world)
  // The original defers initialization so every possible target has spawned.
  entity.think = laserStart
  entity.nextThink = world.time + 1.0
  return entity
end function

function earthquakeThink(entity, world)
  playSound = false
  if entity.pauseTime < world.time then
    playSound = true
    entity.pauseTime = world.time + 0.5
  end if
  world.callbacks.earthquake(entity, entity.speed, playSound)
  gwcore.emit(world, "earthquake", entity, entity.speed)
  if world.time < entity.timestamp then
    entity.think = earthquakeThink
    entity.nextThink = world.time + world.frameTime
  else
    entity.nextThink = 0.0
  end if
  return true
end function

function earthquakeUse(entity, other, activator, world)
  // Re-triggering extends/restarts the stock effect; it is not rejected while
  // an earlier activation is still running.
  entity.timestamp = world.time + entity.count
  entity.nextThink = world.time + world.frameTime
  entity.activator = activator
  entity.pauseTime = 0.0
  return true
end function

function spawnEarthquake(entity, world)
  if entity.targetName == "" then gwcore.log(world, "untargeted target_earthquake") end if
  if entity.count == 0 then entity.count = 5 end if
  if entity.speed == 0.0 then entity.speed = 200.0 end if
  if entity.noise == "" then entity.noise = "world/quake.wav" end if
  entity.think = earthquakeThink
  entity.use = earthquakeUse
  entity.serverFlags = entity.serverFlags | gwconstants.SVF_NOCLIENT
  return entity
end function

// -------------------------------------------------------------------------
// target_lightramp from g_target.c. Configstring mutation is an explicit
// engine callback so this state machine stays deterministic and headless.

function targetLightRampThink(entity, world)
  elapsedFrames = (world.time - entity.timestamp) / world.frameTime
  styleOffset = entity.moveDirection.x + elapsedFrames * entity.moveDirection.z
  styleByte = 97 + targetlightrampbyteio.truncInt(styleOffset)
  world.callbacks.lightStyle(entity.targetEntity.style, decode(bytes([styleByte])))
  gwcore.emit(world, "light-ramp", entity, styleByte)

  if world.time - entity.timestamp < entity.speed then
    entity.think = targetLightRampThink
    entity.nextThink = world.time + world.frameTime
  else if (entity.spawnFlags & 1) != 0 then
    start = entity.moveDirection.x
    entity.moveDirection.x = entity.moveDirection.y
    entity.moveDirection.y = start
    entity.moveDirection.z = -entity.moveDirection.z
  end if
  return true
end function

function targetLightRampUse(entity, other, activator, world)
  light = entity.targetEntity
  if light is void or typeof(light) != "struct" or light.inUse == false then
    light = void
    matches = gwcore.matchingTargets(world, entity.target)
    for each candidate in matches
      if candidate.className != "light" then
        gwcore.log(world, "target_lightramp target " + entity.target + " is not a light: " + candidate.className)
      else
        light = candidate
      end if
    end for
    if light is void then
      gwcore.log(world, "target_lightramp target " + entity.target + " not found")
      gwcore.freeEntity(world, entity)
      return false
    end if
    entity.targetEntity = light
  end if
  entity.timestamp = world.time
  return targetLightRampThink(entity, world)
end function

function spawnTargetLightRamp(entity, world, deathmatch)
  ramp = bytes(entity.message)
  badRamp = len(ramp) != 2
  if badRamp == false then
    badRamp = ramp[0] < 97 or ramp[0] > 122 or ramp[1] < 97 or ramp[1] > 122 or ramp[0] == ramp[1]
  end if
  if badRamp then
    gwcore.log(world, "target_lightramp has bad ramp " + entity.message)
    gwcore.freeEntity(world, entity)
    return false
  end if
  if deathmatch then gwcore.freeEntity(world, entity); return false end if
  if entity.target == "" then
    gwcore.log(world, "target_lightramp with no target")
    gwcore.freeEntity(world, entity)
    return false
  end if
  if entity.speed <= 0.0 or world.frameTime <= 0.0 then
    gwcore.log(world, "target_lightramp requires positive speed and frame time")
    gwcore.freeEntity(world, entity)
    return false
  end if

  start = ramp[0] - 97
  finish = ramp[1] - 97
  slope = (finish - start) / (entity.speed / world.frameTime)
  entity.moveDirection = targetactorqtypes.Vec3(start, finish, slope)
  entity.serverFlags = entity.serverFlags | gwconstants.SVF_NOCLIENT
  entity.use = targetLightRampUse
  entity.think = targetLightRampThink
  return entity
end function

function SP_target_temp_entity(entity, world)
  return spawnTempEntity(entity, world)
end function
function SP_target_speaker(entity, world)
  return spawnSpeaker(entity, world)
end function
function SP_target_help(entity, world)
  return spawnHelp(entity, world)
end function
function SP_target_secret(entity, world)
  return spawnSecret(entity, world)
end function
function SP_target_goal(entity, world)
  return spawnGoal(entity, world)
end function
function SP_target_explosion(entity, world)
  return spawnExplosion(entity, world)
end function
function SP_target_changelevel(entity, world)
  return spawnChangeLevel(entity, world)
end function
function SP_target_splash(entity, world)
  return spawnSplash(entity, world)
end function
function SP_target_spawner(entity, world)
  return spawnSpawner(entity, world)
end function
function SP_target_blaster(entity, world)
  return spawnBlaster(entity, world)
end function
function SP_target_crosslevel_trigger(entity, world)
  return spawnCrossLevelTrigger(entity, world)
end function
function SP_target_crosslevel_target(entity, world)
  return spawnCrossLevelTarget(entity, world)
end function
function SP_target_laser(entity, world)
  return spawnLaser(entity, world)
end function
function SP_target_earthquake(entity, world)
  return spawnEarthquake(entity, world)
end function
function SP_target_actor(entity, world)
  return spawnTargetActor(entity, world)
end function
function SP_target_lightramp(entity, world)
  return spawnTargetLightRamp(entity, world, false)
end function
