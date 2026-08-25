/* Adapter joining parsed BSP entities to world, item and monster runtimes. */
package miniquake2.game.integration.baseq2

import miniquake2.qcommon.types as ibqtypes
import miniquake2.game.world.types as ibwtypes
import miniquake2.game.world.core as ibworld
import miniquake2.game.world.triggers as ibtriggers
import miniquake2.game.world.targets as ibtargets
import miniquake2.game.world.movers as ibmovers
import miniquake2.game.world.misc as ibmisc
import miniquake2.game.world.turret as ibturret
import miniquake2.game.world.turret_types as ibturrettypes
import miniquake2.game.world.constants as ibworldconstants
import miniquake2.game.integration.pusher as ibpusher
import miniquake2.game.ai.archetypes as ibarchetypes
import miniquake2.game.ai.monster as ibmonster
import miniquake2.game.ai.core as ibgaicore
import miniquake2.game.ai.move as ibaimove
import miniquake2.game.ai.trail as ibaitrail
import miniquake2.game.ai.props as ibaiprops
import miniquake2.game.ai.constants as ibaiconstants
import miniquake2.game.ai.combat_profiles as ibaicombat
import miniquake2.game.ai.attack_sequences as ibattackseq
import miniquake2.game.ai.reaction_sequences as ibreactionseq
import miniquake2.game.ai.death_effects as ibdeatheffects
import miniquake2.game.ai.sounds as ibaisounds
import miniquake2.game.gameplay.registry as ibitems
import miniquake2.game.gameplay.item_rules as ibitemrules
import miniquake2.game.gameplay.precache as ibprecache
import miniquake2.game.gameplay.powerups as ibpowerups
import miniquake2.game.gameplay.constants as ibgpconstants
import miniquake2.game.gameplay.types as ibgtypes
import miniquake2.game.gameplay.weapons as ibgpweapons
import miniquake2.game.gameplay.combat as ibgpcombat
import miniquake2.game.constants as ibgconstants
import miniquake2.game.types as ibgametypes
import miniquake2.game.random as ibrandom
import miniquake2.game.ai.types as ibaitypes
import miniquake2.game.player.view as ibplayerview
import miniquake2.game.player.rules as ibplayerrules
import miniquake2.game.player.constants as ibplayerconstants
import miniquake2.game.weapons.types as ibwptypes
import miniquake2.game.weapons.core as ibwpcore
import miniquake2.game.weapons.hitscan as ibwphitscan
import miniquake2.game.weapons.projectiles as ibwpprojectiles
import miniquake2.game.weapons.hand_grenade as ibwphandgrenade
import miniquake2.game.weapons.vector as ibwpvector
import miniquake2.game.weapons.constants as ibwpconstants
import miniquake2.qcommon.constants as ibqconstants
import miniquake2.qcommon.monster_flash_offsets as ibflashoffsets
import std.math as ibmath

struct IntegratedBaseQ2
  world
  aiContext
  monsters
  items
  aiPlayers
  weaponContext
  playerContext
  exportTable
  randomState
  playerTrail
  collisionWorldReady
  dynamicSolidEdicts
  dynamicSolidCount
  dynamicSolidFrame
  dynamicSolidNumEdicts
end struct

struct IntegratedDynamicClip
  hit
  fraction
  enter
  exit
  normalAxis
  normalSign
  startSolid
  allSolid
end struct

activeIntegrationRuntime = void

// Exact m_medic.c attack42-relative cable offsets. Package-rooted scalar
// tables avoid rebuilding arrays in the live resurrection callback.
medicCableOffsetX = [45.0, 48.4, 47.8, 47.3, 45.4, 41.9, 37.8, 34.3, 32.7, 32.7]
medicCableOffsetY = [-9.2, -9.7, -9.8, -9.3, -10.1, -12.7, -15.8, -18.4, -19.7, -19.7]
medicCableOffsetZ = [15.5, 15.2, 15.8, 14.3, 13.1, 12.0, 11.2, 10.7, 10.4, 10.4]

// m_infantry.c's fixed death211..death222 spray. Scalar package tables avoid
// constructing twelve nested angle vectors every time an Infantry dies.
infantryDeathAimPitch = [0.0, 10.0, 20.0, 25.0, 30.0, 30.0,
  25.0, 20.0, 15.0, 40.0, 70.0, 90.0]
infantryDeathAimYaw = [5.0, 15.0, 25.0, 35.0, 40.0, 45.0,
  50.0, 40.0, 35.0, 35.0, 35.0, 35.0]

// The server game is single-threaded. Reuse the three immutable-by-callee
// trace arguments instead of allocating eye/zero vectors for every monster
// visibility and attack check in the hot frame path.
aiTraceStartScratch = ibqtypes.Vec3(0.0, 0.0, 0.0)
aiTraceEndScratch = ibqtypes.Vec3(0.0, 0.0, 0.0)
aiTraceZeroScratch = ibqtypes.Vec3(0.0, 0.0, 0.0)
aiMoveDynamicClip = IntegratedDynamicClip(false, 1.0, 0.0, 1.0, -1,
  0.0, false, false)
aiTriggerMinsScratch = ibqtypes.Vec3(0.0, 0.0, 0.0)
aiTriggerMaxsScratch = ibqtypes.Vec3(0.0, 0.0, 0.0)

// target_laser is evaluated every server frame.  Reuse its clip and adapter
// records so retail maps with large laser banks do not allocate a target array
// (and one WeaponTarget per actor) for every beam trace.
worldLaserClipScratch = IntegratedDynamicClip(false, 1.0, 0.0, 1.0, -1,
  0.0, false, false)
worldLaserEndScratch = ibqtypes.Vec3(0.0, 0.0, 0.0)
worldLaserNormalScratch = ibqtypes.Vec3(0.0, 0.0, 0.0)
worldLaserTraceScratch = ibwtypes.WorldTrace(false, worldLaserEndScratch,
  worldLaserNormalScratch, void)
worldLaserPlayerProxy = ibwtypes.createEntity(-1, "laser_player_proxy")
worldLaserBlockProxy = ibwtypes.createEntity(-1, "laser_block_proxy")

function compactIntegratedValues(values, count)
  if count <= 0 then return [] end if
  if count == len(values) then return values end if
  output = array(count)
  index = 0
  while index < count
    output[index] = values[index]
    index = index + 1
  end while
  return output
end function

function copyVector(values)
  return ibqtypes.Vec3(values[0], values[1], values[2])
end function

function worldEntity(baseEdict)
  source = baseEdict.component
  entity = ibwtypes.createEntity(baseEdict.number, source.className)
  entity.target = source.target; entity.targetName = source.targetName
  entity.killTarget = source.killTarget; entity.pathTarget = source.pathTarget
  entity.team = source.team
  entity.message = source.message; entity.map = source.map; entity.model = source.model
  entity.noise = source.spawnTemp.noise; entity.spawnFlags = source.spawnFlags
  entity.solid = source.solid; entity.moveType = source.moveType
  entity.origin = copyVector(source.origin); entity.angles = copyVector(source.angles)
  entity.speed = source.speed; entity.accel = source.accel; entity.decel = source.decel
  entity.wait = source.wait; entity.delay = source.delay; entity.random = source.random
  entity.damage = source.damage; entity.health = source.health; entity.maxHealth = source.health
  entity.mass = source.mass; entity.count = source.count
  entity.volume = source.volume; entity.attenuation = source.attenuation
  entity.sounds = source.sounds
  entity.style = source.style; entity.lip = source.spawnTemp.lip; entity.height = source.spawnTemp.height
  entity.item = source.spawnTemp.item
  entity.moveInfo.distance = source.spawnTemp.distance
  entity.pauseTime = source.spawnTemp.pauseTime
  if source.className == "turret_breach" then
    entity.moveInfo.startAngles = ibqtypes.Vec3(source.spawnTemp.minPitch, source.spawnTemp.minYaw, 0.0)
    entity.moveInfo.endAngles = ibqtypes.Vec3(source.spawnTemp.maxPitch, source.spawnTemp.maxYaw, 0.0)
  end if
  if source.className == "worldspawn" then entity.modelIndex = 1 end if
  return entity
end function

function aiPickTarget(targetName)
  global activeIntegrationRuntime
  if activeIntegrationRuntime is void then return void end if
  entity = ibworld.pickTarget(activeIntegrationRuntime.world, targetName)
  if entity is void then return void end if
  // The world subsystem owns target/path entities as WorldEntity records,
  // while the AI core deliberately deals only in AIActor-shaped targets.
  // Adapt at this boundary so direction/range code never has to inspect two
  // unrelated record layouts.
  target = ibaitypes.createActor(entity.number, entity.className)
  target.edict.state.origin = entity.origin
  target.edict.state.angles = entity.angles
  target.edict.inUse = entity.inUse
  target.target = entity.target
  target.targetName = entity.targetName
  target.areaNumber = 0
  target.isMonster = false
  return target
end function

function aiUseTargets(actor, activator)
  global activeIntegrationRuntime
  if activeIntegrationRuntime is void or actor.target == "" then return false end if
  ibAiWorldActivatorHolder = activator
  if activator is not void then
    ibAiWorldServerFlagsProbe = try(activator.serverFlags)
    if typeof(ibAiWorldServerFlagsProbe) != "int" then
      ibAiWorldActivatorHolder = ibwtypes.createEntity(
        activator.edict.state.number, activator.className)
      ibAiWorldActivatorHolder.serverFlags = activator.edict.serverFlags
      ibAiWorldActivatorHolder.origin = ibqtypes.Vec3(
        activator.edict.state.origin.x, activator.edict.state.origin.y,
        activator.edict.state.origin.z)
      ibAiWorldActivatorHolder.angles = ibqtypes.Vec3(
        activator.edict.state.angles.x, activator.edict.state.angles.y,
        activator.edict.state.angles.z)
      ibAiWorldActivatorHolder.mins = ibqtypes.Vec3(activator.edict.mins.x,
        activator.edict.mins.y, activator.edict.mins.z)
      ibAiWorldActivatorHolder.maxs = ibqtypes.Vec3(activator.edict.maxs.x,
        activator.edict.maxs.y, activator.edict.maxs.z)
      ibAiWorldActivatorHolder.health = activator.health
      ibAiWorldActivatorHolder.maxHealth = activator.maxHealth
      ibAiWorldActivatorHolder.mass = activator.mass
      ibAiWorldActivatorHolder.isClient = activator.isClient
    end if
  end if
  used = false
  for each targetEntity in ibworld.matchingTargets(activeIntegrationRuntime.world, actor.target)
    if ibworld.useEntity(activeIntegrationRuntime.world, targetEntity, void,
        ibAiWorldActivatorHolder) then used = true end if
  end for
  return used
end function

function aiVisible(actor, other)
  global activeIntegrationRuntime
  ibVisibleRuntimeHolder = activeIntegrationRuntime
  if ibVisibleRuntimeHolder is void or ibVisibleRuntimeHolder.playerContext is void then return true end if
  ibVisibleActorOriginHolder = actor.edict.state.origin
  ibVisibleOtherOriginHolder = other.edict.state.origin
  ibVisibleStartHolder = aiTraceStartScratch
  ibVisibleStartHolder.x = ibVisibleActorOriginHolder.x
  ibVisibleStartHolder.y = ibVisibleActorOriginHolder.y
  ibVisibleStartHolder.z = ibVisibleActorOriginHolder.z + actor.viewHeight
  ibVisibleEndHolder = aiTraceEndScratch
  ibVisibleEndHolder.x = ibVisibleOtherOriginHolder.x
  ibVisibleEndHolder.y = ibVisibleOtherOriginHolder.y
  ibVisibleEndHolder.z = ibVisibleOtherOriginHolder.z + other.viewHeight
  ibVisibleTraceHolder = ibVisibleRuntimeHolder.playerContext.imports.trace(
    ibVisibleStartHolder, aiTraceZeroScratch, aiTraceZeroScratch,
    ibVisibleEndHolder, actor.edict, ibqconstants.MASK_OPAQUE)
  return ibVisibleTraceHolder.fraction == 1.0
end function

function aiClearShot(actor, other)
  global activeIntegrationRuntime
  ibClearRuntimeHolder = activeIntegrationRuntime
  if ibClearRuntimeHolder is void or ibClearRuntimeHolder.playerContext is void then return true end if
  ibClearActorOriginHolder = actor.edict.state.origin
  ibClearOtherOriginHolder = other.edict.state.origin
  ibClearStartHolder = aiTraceStartScratch
  ibClearStartHolder.x = ibClearActorOriginHolder.x
  ibClearStartHolder.y = ibClearActorOriginHolder.y
  ibClearStartHolder.z = ibClearActorOriginHolder.z + actor.viewHeight
  ibClearEndHolder = aiTraceEndScratch
  ibClearEndHolder.x = ibClearOtherOriginHolder.x
  ibClearEndHolder.y = ibClearOtherOriginHolder.y
  ibClearEndHolder.z = ibClearOtherOriginHolder.z + other.viewHeight
  ibClearMask = ibqconstants.CONTENTS_SOLID | ibqconstants.CONTENTS_MONSTER |
    ibqconstants.CONTENTS_SLIME | ibqconstants.CONTENTS_LAVA | ibqconstants.CONTENTS_WINDOW
  ibClearTraceHolder = integratedWeaponTrace(ibClearStartHolder,
    aiTraceZeroScratch, aiTraceZeroScratch, ibClearEndHolder, actor, ibClearMask)
  return ibClearTraceHolder.entity is not void and
    ibClearTraceHolder.entity.number == other.edict.state.number
end function

function aiInPHS(first, second)
  global activeIntegrationRuntime
  if activeIntegrationRuntime is void or activeIntegrationRuntime.playerContext is void then return true end if
  return activeIntegrationRuntime.playerContext.imports.inPHS(first, second)
end function

function aiAreasConnected(first, second)
  global activeIntegrationRuntime
  if activeIntegrationRuntime is void or activeIntegrationRuntime.playerContext is void then return true end if
  return activeIntegrationRuntime.playerContext.imports.areasConnected(first, second)
end function

function aiTrailPickFirst(actor)
  global activeIntegrationRuntime
  runtime = activeIntegrationRuntime
  if runtime is void then return void end if
  return ibaitrail.PickFirst(runtime.playerTrail, actor, aiVisible)
end function

function aiTrailPickNext(actor)
  global activeIntegrationRuntime
  runtime = activeIntegrationRuntime
  if runtime is void then return void end if
  return ibaitrail.PickNext(runtime.playerTrail, actor)
end function

function inline clipAIDynamicAxis(clip, startValue, finishValue, minimum,
    maximum, axis)
  delta = finishValue - startValue
  if delta == 0.0 then
    // A hull travelling exactly along a box face is touching, not entering.
    return startValue > minimum and startValue < maximum
  end if
  near = (minimum - startValue) / delta
  far = (maximum - startValue) / delta
  normalSign = -1.0
  if near > far then
    swap = near; near = far; far = swap; normalSign = 1.0
  end if
  if near > clip.enter then
    clip.enter = near; clip.normalAxis = axis; clip.normalSign = normalSign
  end if
  if far < clip.exit then clip.exit = far end if
  return clip.enter <= clip.exit
end function

// Allocation-free swept AABB test used only for non-BSP SOLID_BBOX edicts.
// The engine import already owns world and inline-brush collision.
function clipAIDynamicEdict(start, mins, maxs, finish, target, bestFraction)
  clip = aiMoveDynamicClip
  clip.hit = false; clip.fraction = 1.0
  clip.enter = 0.0; clip.exit = 1.0
  clip.normalAxis = -1; clip.normalSign = 0.0
  targetOrigin = target.state.origin
  minimumX = targetOrigin.x + target.mins.x - maxs.x
  minimumY = targetOrigin.y + target.mins.y - maxs.y
  minimumZ = targetOrigin.z + target.mins.z - maxs.z
  maximumX = targetOrigin.x + target.maxs.x - mins.x
  maximumY = targetOrigin.y + target.maxs.y - mins.y
  maximumZ = targetOrigin.z + target.maxs.z - mins.z
  clip.startSolid = start.x > minimumX and start.x < maximumX and
    start.y > minimumY and start.y < maximumY and
    start.z > minimumZ and start.z < maximumZ
  finishInside = finish.x > minimumX and finish.x < maximumX and
    finish.y > minimumY and finish.y < maximumY and
    finish.z > minimumZ and finish.z < maximumZ
  clip.allSolid = clip.startSolid and finishInside
  if clipAIDynamicAxis(clip, start.x, finish.x, minimumX, maximumX, 0) != true or
      clipAIDynamicAxis(clip, start.y, finish.y, minimumY, maximumY, 1) != true or
      clipAIDynamicAxis(clip, start.z, finish.z, minimumZ, maximumZ, 2) != true then
    return clip
  end if
  if clip.startSolid then clip.fraction = 0.0
  else
    clip.fraction = clip.enter
    // Moving away from a face that the hull merely touches is not a hit.
    if clip.fraction <= 0.0 and clip.exit <= 0.0 then return clip end if
  end if
  if clip.fraction < 0.0 or clip.fraction > 1.0 or
      (not clip.startSolid and clip.fraction >= bestFraction) then return clip end if
  clip.hit = true
  return clip
end function

// Rebuild at most once per server frame. A retail map can expose 800+ edicts,
// while only players and live monsters normally use SOLID_BBOX. Keeping this
// fixed-capacity list turns every subsequent monster trace from an all-edict
// scan into a compact, allocation-free hot loop.
function refreshAIDynamicSolids(runtime)
  if runtime is void or runtime.exportTable is void then
    if runtime is not void then runtime.dynamicSolidCount = 0 end if
    return 0
  end if
  exportTable = runtime.exportTable
  count = 0
  index = 1
  while index < exportTable.numEdicts
    target = exportTable.edicts[index]
    if target.inUse and target.solid == ibgconstants.SOLID_BBOX then
      runtime.dynamicSolidEdicts[count] = target
      count = count + 1
    end if
    index = index + 1
  end while
  runtime.dynamicSolidCount = count
  runtime.dynamicSolidFrame = runtime.aiContext.frameNumber
  runtime.dynamicSolidNumEdicts = exportTable.numEdicts
  return count
end function

function integratedAITrace(start, mins, maxs, finish, ignore, mask)
  global activeIntegrationRuntime
  runtime = activeIntegrationRuntime
  if runtime is void or runtime.playerContext is void then
    return ibwpcore.clearTrace(start, mins, maxs, finish, ignore, mask)
  end if
  passEdict = void
  if ignore is not void then
    passProbe = try(ignore.edict)
    if typeof(passProbe) == "struct" then passEdict = passProbe
    else passEdict = ignore
    end if
  end if
  trace = runtime.playerContext.imports.trace(start, mins, maxs, finish,
    passEdict, mask)
  if trace.fraction == 0.0 or (mask & ibqconstants.CONTENTS_MONSTER) == 0 or
      runtime.exportTable is void then return trace end if

  passNumber = -1
  passOwnerNumber = -1
  if passEdict is not void then
    passNumber = passEdict.state.number
    passOwnerProbe = try(passEdict.owner.state.number)
    if typeof(passOwnerProbe) == "int" then passOwnerNumber = passOwnerProbe end if
  end if
  exportTable = runtime.exportTable
  if runtime.dynamicSolidFrame != runtime.aiContext.frameNumber or
      runtime.dynamicSolidNumEdicts != exportTable.numEdicts then
    refreshAIDynamicSolids(runtime)
  end if
  index = 0
  while index < runtime.dynamicSolidCount
    target = runtime.dynamicSolidEdicts[index]
    eligible = target.inUse and target.solid == ibgconstants.SOLID_BBOX and
      target.state.number != passNumber
    if eligible and (target.serverFlags & ibgconstants.SVF_DEADMONSTER) != 0 and
        (mask & ibqconstants.CONTENTS_DEADMONSTER) == 0 then eligible = false end if
    if eligible and passEdict is not void then
      targetOwnerProbe = try(target.owner.state.number)
      if typeof(targetOwnerProbe) == "int" and targetOwnerProbe == passNumber then
        eligible = false
      end if
      if target.state.number == passOwnerNumber then eligible = false end if
    end if
    if eligible then
      candidate = clipAIDynamicEdict(start, mins, maxs, finish, target,
        trace.fraction)
      if candidate.hit then
        priorStartSolid = trace.startSolid
        trace.allSolid = candidate.allSolid
        trace.startSolid = priorStartSolid or candidate.startSolid
        trace.fraction = candidate.fraction
        trace.endPosition = ibqtypes.Vec3(
          start.x + (finish.x - start.x) * candidate.fraction,
          start.y + (finish.y - start.y) * candidate.fraction,
          start.z + (finish.z - start.z) * candidate.fraction)
        normal = ibqtypes.Vec3(0.0, 0.0, 0.0)
        if candidate.normalAxis == 0 then normal.x = candidate.normalSign
        else if candidate.normalAxis == 1 then normal.y = candidate.normalSign
        else if candidate.normalAxis == 2 then normal.z = candidate.normalSign
        end if
        trace.plane = ibqtypes.Plane(normal, 0.0, 0, 0)
        trace.contents = ibqconstants.CONTENTS_MONSTER
        trace.entity = target
      end if
    end if
    index = index + 1
  end while
  return trace
end function

function integratedAIPointContents(point)
  global activeIntegrationRuntime
  if activeIntegrationRuntime is void or activeIntegrationRuntime.playerContext is void then
    return 0
  end if
  return activeIntegrationRuntime.playerContext.imports.pointContents(point)
end function

function integratedAILinkActor(actor)
  global activeIntegrationRuntime
  runtime = activeIntegrationRuntime
  if runtime is void or runtime.playerContext is void then return false end if
  runtime.playerContext.imports.linkEntity(actor.edict)
  actor.areaNumber = actor.edict.areaNumber
  return true
end function

function integratedAITouchTriggers(actor)
  global activeIntegrationRuntime
  runtime = activeIntegrationRuntime
  if runtime is void or runtime.playerContext is void or actor.health <= 0 then
    return 0
  end if
  origin = actor.edict.state.origin
  minimum = aiTriggerMinsScratch
  maximum = aiTriggerMaxsScratch
  minimum.x = origin.x + actor.edict.mins.x
  minimum.y = origin.y + actor.edict.mins.y
  minimum.z = origin.z + actor.edict.mins.z
  maximum.x = origin.x + actor.edict.maxs.x
  maximum.y = origin.y + actor.edict.maxs.y
  maximum.z = origin.z + actor.edict.maxs.z
  candidates = runtime.playerContext.imports.boxEdicts(minimum, maximum, 2)
  if len(candidates) == 0 then return 0 end if
  proxy = actor.triggerProxy
  if proxy is void then
    proxy = ibwtypes.createEntity(actor.edict.state.number, actor.className)
    actor.triggerProxy = proxy
  end if
  proxy.inUse = actor.edict.inUse
  proxy.origin = actor.edict.state.origin
  proxy.angles = actor.edict.state.angles
  proxy.velocity.x = actor.velocity.x
  proxy.velocity.y = actor.velocity.y
  proxy.velocity.z = actor.velocity.z
  proxy.mins = actor.edict.mins; proxy.maxs = actor.edict.maxs
  proxy.health = actor.health; proxy.maxHealth = actor.maxHealth
  proxy.mass = actor.mass; proxy.flags = actor.flags
  proxy.groundEntity = actor.groundEntity
  proxy.serverFlags = actor.edict.serverFlags | ibgconstants.SVF_MONSTER
  proxy.isClient = false
  touched = 0
  for each candidateEdict in candidates
    if candidateEdict.inUse and candidateEdict.state.number != actor.edict.state.number then
      trigger = ibworld.findByNumber(runtime.world, candidateEdict.state.number)
      if trigger is not void and ibworld.touchEntity(runtime.world, trigger, proxy) then
        touched = touched + 1
      end if
    end if
  end for
  actor.edict.state.origin.x = proxy.origin.x
  actor.edict.state.origin.y = proxy.origin.y
  actor.edict.state.origin.z = proxy.origin.z
  actor.edict.state.angles.x = proxy.angles.x
  actor.edict.state.angles.y = proxy.angles.y
  actor.edict.state.angles.z = proxy.angles.z
  actor.velocity.x = proxy.velocity.x
  actor.velocity.y = proxy.velocity.y
  actor.velocity.z = proxy.velocity.z
  actor.groundEntity = proxy.groundEntity
  return touched
end function

function integratedAIWalkMove(actor, yaw, distance)
  global activeIntegrationRuntime
  if activeIntegrationRuntime is void then return false end if
  if activeIntegrationRuntime.playerContext is void or
      activeIntegrationRuntime.collisionWorldReady != true then
    // Component-only tests may deliberately detach GameImport, and supported
    // asset-free sessions deliberately have no BSP hull. Retain their
    // deterministic transform boundary; every retail runtime uses m_move.c.
    radians = ibmath.degToRad(yaw)
    actor.edict.state.origin.x = actor.edict.state.origin.x +
      ibmath.cos(radians) * distance
    actor.edict.state.origin.y = actor.edict.state.origin.y +
      ibmath.sin(radians) * distance
    return true
  end if
  return ibaimove.WalkMove(actor, yaw, distance,
    activeIntegrationRuntime.aiContext)
end function

function integratedAIMoveToGoal(actor, distance)
  global activeIntegrationRuntime
  if activeIntegrationRuntime is void then return false end if
  if activeIntegrationRuntime.playerContext is void or
      activeIntegrationRuntime.collisionWorldReady != true then
    if actor.goalEntity is void then return false end if
    actor.idealYaw = ibgaicore.vectorToYaw(
      ibgaicore.directionTo(actor, actor.goalEntity))
    ibgaicore.ChangeYaw(actor)
    return integratedAIWalkMove(actor, actor.edict.state.angles.y, distance)
  end if
  return ibaimove.MoveToGoal(actor, distance,
    activeIntegrationRuntime.aiContext)
end function

function integratedAISound(actor, soundName, channel, attenuation)
  global activeIntegrationRuntime
  ibAISoundRuntimeHolder = activeIntegrationRuntime
  if ibAISoundRuntimeHolder is void or ibAISoundRuntimeHolder.playerContext is void then return false end if
  ibAISoundImportsHolder = ibAISoundRuntimeHolder.playerContext.imports
  return ibAISoundImportsHolder.sound(actor.edict, channel,
    ibAISoundImportsHolder.soundIndex(soundName), 1.0, attenuation, 0.0)
end function

function integratedAITempEntity(actor, effectType)
  global activeIntegrationRuntime
  ibAITempRuntimeHolder = activeIntegrationRuntime
  if ibAITempRuntimeHolder is void or ibAITempRuntimeHolder.playerContext is void then return false end if
  ibAITempImportsHolder = ibAITempRuntimeHolder.playerContext.imports
  ibAITempOriginHolder = actor.edict.state.origin
  ibAITempImportsHolder.writeByte(ibqconstants.SVC_TEMP_ENTITY)
  ibAITempImportsHolder.writeByte(effectType)
  ibAITempImportsHolder.writePosition(ibAITempOriginHolder)
  return ibAITempImportsHolder.multicast(ibAITempOriginHolder, ibgconstants.MULTICAST_PVS)
end function

function integratedAIDeathEffect(actor, effect)
  global activeIntegrationRuntime
  ibDeathRuntimeHolder = activeIntegrationRuntime
  if ibDeathRuntimeHolder is void then return false end if

  if effect.kind == "corpse" then
    if ibDeathRuntimeHolder.playerContext is not void then
      return ibDeathRuntimeHolder.playerContext.imports.linkEntity(actor.edict)
    end if
    return true
  end if

  if effect.kind == "explosion" then
    if ibDeathRuntimeHolder.playerContext is void then return true end if
    ibDeathExplosionImportsHolder = ibDeathRuntimeHolder.playerContext.imports
    ibDeathExplosionOriginHolder = effect.origin
    ibDeathExplosionImportsHolder.writeByte(ibqconstants.SVC_TEMP_ENTITY)
    ibDeathExplosionImportsHolder.writeByte(effect.effectType)
    ibDeathExplosionImportsHolder.writePosition(ibDeathExplosionOriginHolder)
    return ibDeathExplosionImportsHolder.multicast(ibDeathExplosionOriginHolder, ibgconstants.MULTICAST_PVS)
  end if

  if effect.kind != "gib" then return error(9708, "unsupported monster death effect " + effect.kind) end if
  if ibDeathRuntimeHolder.exportTable is void or ibDeathRuntimeHolder.playerContext is void then return true end if
  ibDeathExportHolder = ibDeathRuntimeHolder.exportTable
  ibDeathGibNumber = ibDeathExportHolder.numEdicts
  if ibDeathGibNumber < 1 or ibDeathGibNumber >= ibDeathExportHolder.maxEdicts then
    return error(9709, "monster gib exceeds edict capacity")
  end if

  ibDeathGibHolder = ibwtypes.createEntity(ibDeathGibNumber, "monster_gib")
  ibDeathGibHolder.model = effect.modelName
  ibDeathGibHolder.modelIndex = ibDeathRuntimeHolder.playerContext.imports.modelIndex(effect.modelName)
  ibDeathSequence = effect.sequence
  ibDeathSeed = actor.edict.state.number * 41 + ibDeathSequence * 73 + 19
  ibDeathOriginHolder = effect.origin
  ibDeathGibHolder.origin = ibqtypes.Vec3(
    ibDeathOriginHolder.x + ((ibDeathSeed % 33) - 16),
    ibDeathOriginHolder.y + (((ibDeathSeed * 3) % 33) - 16),
    ibDeathOriginHolder.z + (((ibDeathSeed * 7) % 25) - 4)
  )
  ibDeathVelocityScale = 0.5
  if effect.gibType == ibdeatheffects.GIB_METALLIC then ibDeathVelocityScale = 1.0 end if
  ibDeathGibHolder.velocity = ibqtypes.Vec3(
    (((ibDeathSeed * 17) % 401) - 200) * ibDeathVelocityScale,
    (((ibDeathSeed * 29) % 401) - 200) * ibDeathVelocityScale,
    200.0 + ((ibDeathSeed * 11) % 301)
  )
  ibDeathGibHolder.angularVelocity = ibqtypes.Vec3(
    (ibDeathSeed * 31) % 600, (ibDeathSeed * 47) % 600, (ibDeathSeed * 59) % 600)
  ibDeathGibHolder.effects = ibgconstants.EF_GIB
  ibDeathGibHolder.solid = ibworldconstants.SOLID_NOT
  ibDeathGibHolder.moveType = ibworldconstants.MOVETYPE_TOSS
  if effect.gibType == ibdeatheffects.GIB_METALLIC then ibDeathGibHolder.moveType = ibworldconstants.MOVETYPE_BOUNCE end if
  ibDeathGibHolder.takeDamage = ibworldconstants.DAMAGE_YES
  ibDeathGibHolder.think = ibworld.freeThink
  ibDeathGibHolder.nextThink = ibDeathRuntimeHolder.world.time + 10.0 + (ibDeathSequence % 10)
  ibworld.addEntity(ibDeathRuntimeHolder.world, ibDeathGibHolder)

  ibDeathGibEdictHolder = ibgametypes.zeroEdict(ibDeathGibNumber)
  ibDeathGibEdictHolder.inUse = true
  ibDeathGibEdictHolder.solid = ibworldconstants.SOLID_NOT
  ibDeathGibEdictHolder.state.origin = ibDeathGibHolder.origin
  ibDeathGibEdictHolder.state.oldOrigin = ibDeathGibHolder.origin
  ibDeathGibEdictHolder.state.effects = ibDeathGibHolder.effects
  ibDeathGibEdictHolder.mins = ibqtypes.Vec3(0.0, 0.0, 0.0)
  ibDeathGibEdictHolder.maxs = ibqtypes.Vec3(0.0, 0.0, 0.0)
  ibDeathExportHolder.edicts[ibDeathGibNumber] = ibDeathGibEdictHolder
  ibDeathExportHolder.numEdicts = ibDeathGibNumber + 1
  ibDeathRuntimeHolder.playerContext.imports.setModel(ibDeathGibEdictHolder, effect.modelName)
  ibDeathGibEdictHolder.state.modelIndex = ibDeathGibHolder.modelIndex
  ibDeathExportHolder.edicts[ibDeathGibNumber] = ibgametypes.stabilizeEdict(ibDeathGibEdictHolder)
  ibDeathRuntimeHolder.playerContext.imports.linkEntity(ibDeathGibEdictHolder)
  return true
end function

function integratedMedicCorpseVisible(runtime, medic, patient)
  if runtime.playerContext is void then return true end if
  ibMedicSightStartHolder = ibqtypes.Vec3(medic.edict.state.origin.x,
    medic.edict.state.origin.y, medic.edict.state.origin.z + medic.viewHeight)
  ibMedicSightEndHolder = ibqtypes.Vec3(patient.edict.state.origin.x,
    patient.edict.state.origin.y, patient.edict.state.origin.z + patient.viewHeight)
  ibMedicSightTraceHolder = runtime.playerContext.imports.trace(
    ibMedicSightStartHolder, ibqtypes.zeroVec3(), ibqtypes.zeroVec3(),
    ibMedicSightEndHolder, medic.edict, ibqconstants.MASK_OPAQUE)
  return ibMedicSightTraceHolder.fraction == 1.0
end function

function integratedFindDeadMonster(medic)
  global activeIntegrationRuntime
  ibMedicFindRuntimeHolder = activeIntegrationRuntime
  if ibMedicFindRuntimeHolder is void then return void end if
  ibMedicBestHolder = void
  for each ibMedicCandidateHolder in ibMedicFindRuntimeHolder.monsters
    ibMedicCandidateValid = nativeRawValue(ibMedicCandidateHolder) != nativeRawValue(medic) and
      ibMedicCandidateHolder.edict.inUse and
      ibMedicCandidateHolder.edict.solid != ibgconstants.SOLID_NOT and
      (ibMedicCandidateHolder.edict.serverFlags & ibgconstants.SVF_MONSTER) != 0 and
      (ibMedicCandidateHolder.info.aiFlags & ibaiconstants.AI_GOOD_GUY) == 0 and
      ibMedicCandidateHolder.owner is void and ibMedicCandidateHolder.health <= 0 and
      ibMedicCandidateHolder.nextThink == 0.0
    if ibMedicCandidateValid then
      // findradius compares against the entity centre. Keep this hot scan in
      // scalar squared space: Vec3/subtract/length would allocate two arrays
      // and perform an unnecessary square root for every monster candidate.
      ibMedicCenterDeltaX = ibMedicCandidateHolder.edict.state.origin.x +
        (ibMedicCandidateHolder.edict.mins.x + ibMedicCandidateHolder.edict.maxs.x) * 0.5 -
        medic.edict.state.origin.x
      ibMedicCenterDeltaY = ibMedicCandidateHolder.edict.state.origin.y +
        (ibMedicCandidateHolder.edict.mins.y + ibMedicCandidateHolder.edict.maxs.y) * 0.5 -
        medic.edict.state.origin.y
      ibMedicCenterDeltaZ = ibMedicCandidateHolder.edict.state.origin.z +
        (ibMedicCandidateHolder.edict.mins.z + ibMedicCandidateHolder.edict.maxs.z) * 0.5 -
        medic.edict.state.origin.z
      ibMedicDistanceSquared = ibMedicCenterDeltaX * ibMedicCenterDeltaX +
        ibMedicCenterDeltaY * ibMedicCenterDeltaY +
        ibMedicCenterDeltaZ * ibMedicCenterDeltaZ
      if ibMedicDistanceSquared <= 1048576.0 and
          integratedMedicCorpseVisible(ibMedicFindRuntimeHolder, medic,
            ibMedicCandidateHolder) then
        if ibMedicBestHolder is void or
            ibMedicCandidateHolder.maxHealth > ibMedicBestHolder.maxHealth then
          ibMedicBestHolder = ibMedicCandidateHolder
        end if
      end if
    end if
  end for
  return ibMedicBestHolder
end function

function integratedInfantryDeathFire(runtime, actor, timelineOffset)
  ibInfantryDeathIndex = timelineOffset - 10
  if ibInfantryDeathIndex < 0 or ibInfantryDeathIndex >= 12 then return false end if
  ibInfantryDeathFlash = 27 + ibInfantryDeathIndex
  ibInfantryDeathStartHolder = monsterMuzzleStart(actor, ibInfantryDeathFlash)
  ibInfantryDeathAnglesHolder = ibqtypes.Vec3(
    actor.edict.state.angles.x - infantryDeathAimPitch[ibInfantryDeathIndex],
    actor.edict.state.angles.y - infantryDeathAimYaw[ibInfantryDeathIndex],
    actor.edict.state.angles.z)
  ibInfantryDeathDirectionHolder = ibwpvector.angleVectors(
    ibInfantryDeathAnglesHolder)[0]
  ibInfantryDeathShooterHolder = monsterWeaponTarget(actor)
  ibwphitscan.fireBullet(runtime.weaponContext, ibInfantryDeathShooterHolder,
    ibInfantryDeathStartHolder, ibInfantryDeathDirectionHolder, 3, 4,
    300.0, 500.0, ibgpconstants.MOD_UNKNOWN)
  integratedMonsterMuzzleFlash(runtime, actor, ibInfantryDeathFlash,
    ibInfantryDeathStartHolder)
  return true
end function

function integratedSoldierDeathFire(runtime, actor, timelineOffset)
  ibSoldierDeathShot = 0
  if timelineOffset == 24 then ibSoldierDeathShot = 1
  else if timelineOffset != 21 then return false end if
  ibSoldierDeathStartFlash = 92
  if actor.className == "monster_soldier" then ibSoldierDeathStartFlash = 93
  else if actor.className == "monster_soldier_ss" then ibSoldierDeathStartFlash = 94 end if
  ibSoldierDeathFlash = ibSoldierDeathStartFlash + ibSoldierDeathShot * 3
  ibSoldierDeathStartHolder = monsterMuzzleStart(actor, ibSoldierDeathFlash)
  ibSoldierDeathDirectionHolder = ibwpvector.angleVectors(
    actor.edict.state.angles)[0]
  ibSoldierDeathShooterHolder = monsterWeaponTarget(actor)
  if actor.className == "monster_soldier_light" then
    ibwpprojectiles.fireBlaster(runtime.weaponContext, ibSoldierDeathShooterHolder,
      ibSoldierDeathStartHolder, ibSoldierDeathDirectionHolder, 5, 600.0,
      ibwpconstants.EF_BLASTER, false)
  else if actor.className == "monster_soldier" then
    ibwphitscan.fireShotgun(runtime.weaponContext, ibSoldierDeathShooterHolder,
      ibSoldierDeathStartHolder, ibSoldierDeathDirectionHolder, 2, 1,
      500.0, 500.0, 12, ibgpconstants.MOD_UNKNOWN)
  else
    if actor.attackCycles <= 0 then
      actor.attackCycles = 3 + (ibrandom.nextInteger(runtime.randomState) % 8)
    end if
    ibwphitscan.fireBullet(runtime.weaponContext, ibSoldierDeathShooterHolder,
      ibSoldierDeathStartHolder, ibSoldierDeathDirectionHolder, 2, 4,
      300.0, 500.0, ibgpconstants.MOD_UNKNOWN)
    actor.attackCycles = actor.attackCycles - 1
    if actor.attackCycles > 0 then
      actor.info.aiFlags = actor.info.aiFlags | ibaiconstants.AI_HOLD_FRAME
    else
      actor.info.aiFlags = actor.info.aiFlags & ~ibaiconstants.AI_HOLD_FRAME
    end if
  end if
  integratedMonsterMuzzleFlash(runtime, actor, ibSoldierDeathFlash,
    ibSoldierDeathStartHolder)
  return true
end function

function integratedReactionFrameEvent(actor, plan, timelineOffset, eventKind)
  global activeIntegrationRuntime
  ibReactionEventRuntimeHolder = activeIntegrationRuntime
  if ibReactionEventRuntimeHolder is void then return false end if
  if eventKind == "infantry-death-machinegun" then
    return integratedInfantryDeathFire(ibReactionEventRuntimeHolder, actor,
      timelineOffset)
  end if
  if eventKind == "soldier-death-fire" then
    return integratedSoldierDeathFire(ibReactionEventRuntimeHolder, actor,
      timelineOffset)
  end if
  return error(9712, "unsupported stock reaction frame event " + eventKind)
end function

function configureAI(context)
  context.pickTarget = aiPickTarget
  context.useTargets = aiUseTargets
  context.visible = aiVisible
  context.clearShot = aiClearShot
  context.inPHS = aiInPHS
  context.areasConnected = aiAreasConnected
  context.spawnMonster = integratedSpawnMonster
  context.playSound = integratedAISound
  context.tempEntity = integratedAITempEntity
  context.deathEffect = integratedAIDeathEffect
  context.nextRandomUnit = integratedRandomUnit
  context.nextRandomInteger = integratedRandomInteger
  context.findDeadMonster = integratedFindDeadMonster
  context.reactionFrameEvent = integratedReactionFrameEvent
  context.moveTrace = integratedAITrace
  context.pointContents = integratedAIPointContents
  context.linkActor = integratedAILinkActor
  context.touchActorTriggers = integratedAITouchTriggers
  context.walkMove = integratedAIWalkMove
  context.moveToGoal = integratedAIMoveToGoal
  context.trailPickFirst = aiTrailPickFirst
  context.trailPickNext = aiTrailPickNext
  return context
end function

function integratedPropProxyUse(entity, other, activator, world)
  ibPropActorHolder = integratedWorldActor(entity.number)
  if ibPropActorHolder is void then return false end if
  global activeIntegrationRuntime
  return ibmonster.MonsterUse(ibPropActorHolder, other, activator, activeIntegrationRuntime.aiContext)
end function

function installPropTargetProxies(runtime)
  ibPropProxyCount = 0
  for each ibPropActorHolder in runtime.monsters
    if ibPropActorHolder.className == "monster_boss3_stand" or ibPropActorHolder.className == "monster_commander_body" then
      ibPropProxyHolder = ibwtypes.createEntity(ibPropActorHolder.edict.state.number, "ai_prop_target_proxy")
      ibPropProxyHolder.targetName = ibPropActorHolder.targetName
      ibPropProxyHolder.target = ibPropActorHolder.target
      ibPropProxyHolder.use = integratedPropProxyUse
      runtime.world.entities = runtime.world.entities + [ibPropProxyHolder]
      ibPropProxyCount = ibPropProxyCount + 1
    end if
  end for
  return ibPropProxyCount
end function

function integratedSpawnMonster(className, parent)
  global activeIntegrationRuntime
  ibBossRuntimeHolder = activeIntegrationRuntime
  if ibBossRuntimeHolder is void then return error(9695, "dynamic monster spawn requires an active integration runtime") end if
  ibBossRegistryHolder = ibarchetypes.defaultRegistry()
  if ibarchetypes.find(ibBossRegistryHolder, className) is void then return error(9696, "dynamic monster class is not registered: " + className) end if

  ibBossNumber = ibBossRuntimeHolder.world.nextEntityNumber
  for each ibBossActorProbe in ibBossRuntimeHolder.monsters
    if ibBossActorProbe.edict.state.number >= ibBossNumber then ibBossNumber = ibBossActorProbe.edict.state.number + 1 end if
  end for
  for each ibBossItemProbe in ibBossRuntimeHolder.items
    if ibBossItemProbe.edict.state.number >= ibBossNumber then ibBossNumber = ibBossItemProbe.edict.state.number + 1 end if
  end for
  if ibBossRuntimeHolder.exportTable is not void then
    ibBossNumber = ibBossRuntimeHolder.exportTable.numEdicts
    if ibBossNumber >= ibBossRuntimeHolder.exportTable.maxEdicts then return error(9697, "dynamic monster spawn exceeds edict capacity") end if
  end if

  ibBossActorHolder = ibarchetypes.SpawnMonster(ibBossRegistryHolder, className, ibBossNumber, ibBossRuntimeHolder.aiContext)
  if parent is not void then
    ibBossOriginHolder = copyVector([parent.edict.state.origin.x, parent.edict.state.origin.y, parent.edict.state.origin.z])
    ibBossAnglesHolder = copyVector([parent.edict.state.angles.x, parent.edict.state.angles.y, parent.edict.state.angles.z])
    ibBossActorHolder.edict.state.origin = ibBossOriginHolder
    ibBossActorHolder.edict.state.oldOrigin = ibBossOriginHolder
    ibBossActorHolder.edict.state.angles = ibBossAnglesHolder
    ibBossActorHolder.target = parent.target
    ibBossActorHolder.enemy = parent.enemy
  end if
  ibBossActorMinsHolder = copyVector(ibBossActorHolder.mins)
  ibBossActorMaxsHolder = copyVector(ibBossActorHolder.maxs)
  ibBossActorHolder.edict.mins = ibBossActorMinsHolder
  ibBossActorHolder.edict.maxs = ibBossActorMaxsHolder
  ibBossActorHolder.activity = "boss-successor"
  ibBossActorHolder.nextThink = ibBossRuntimeHolder.aiContext.time + 0.8
  ibgametypes.stabilizeEdict(ibBossActorHolder.edict)
  prepareMonsterRuntimeState(ibBossActorHolder)
  ibBossRuntimeHolder.monsters = ibBossRuntimeHolder.monsters + [ibBossActorHolder]
  if ibBossNumber >= ibBossRuntimeHolder.world.nextEntityNumber then ibBossRuntimeHolder.world.nextEntityNumber = ibBossNumber + 1 end if

  if ibBossRuntimeHolder.exportTable is not void then
    ibBossExportHolder = ibBossRuntimeHolder.exportTable
    ibBossExportHolder.edicts[ibBossNumber] = ibBossActorHolder.edict
    ibBossStoredEdictHolder = ibBossExportHolder.edicts[ibBossNumber]
    ibBossStoredEdictHolder.state = ibBossActorHolder.edict.state
    ibBossStoredEdictHolder.mins = ibBossActorMinsHolder
    ibBossStoredEdictHolder.maxs = ibBossActorMaxsHolder
    ibgametypes.stabilizeEdict(ibBossStoredEdictHolder)
    ibBossExportHolder.numEdicts = ibBossNumber + 1
  end if
  if ibBossRuntimeHolder.playerContext is not void then
    ibBossImportsHolder = ibBossRuntimeHolder.playerContext.imports
    ibBossImportsHolder.setModel(ibBossActorHolder.edict, ibBossActorHolder.model)
    ibBossImportsHolder.linkEntity(ibBossActorHolder.edict)
    ibaimove.InitializeActor(ibBossActorHolder, ibBossRuntimeHolder.aiContext)
  end if
  return ibBossActorHolder
end function

function weaponVector(value)
  if typeof(value) == "struct" then return ibqtypes.Vec3(value.x, value.y, value.z) end if
  return ibqtypes.Vec3(value[0], value[1], value[2])
end function

function integratedPlayerByNumber(runtime, number)
  if runtime.playerContext is void then return void end if
  for each player in runtime.playerContext.players
    if player.edict.state.number == number then return player end if
  end for
  return void
end function

function integratedMonsterByNumber(runtime, number)
  for each actor in runtime.monsters
    if actor.edict.state.number == number then return actor end if
  end for
  return void
end function

function playerWeaponTarget(player, registry)
  target = ibwptypes.createTarget(player.edict.state.number, player.health)
  target.className = "player"
  target.origin = weaponVector(player.edict.state.origin)
  target.mins = weaponVector(player.edict.mins)
  target.maxs = weaponVector(player.edict.maxs)
  target.isClient = true
  target.flags = player.flags
  target.inUse = player.edict.inUse and player.health > 0
  target.combatant.edict = player.edict
  target.combatant.health = player.health
  target.combatant.takeDamage = player.takeDamage != ibplayerconstants.DAMAGE_NO
  target.combatant.flags = player.flags
  target.combatant.moveType = player.moveType
  target.combatant.mass = 200
  target.combatant.velocity = player.velocity
  target.combatant.invincibleUntilFrame = player.powerups.invincibleFrame
  ibpowerups.SyncFromPlayerData(player.gameplay, player)
  ibpowerups.SyncArmorToCombatant(player.gameplay, target.combatant, registry)
  return target
end function

function monsterWeaponTarget(actor)
  target = ibwptypes.createTarget(actor.edict.state.number, actor.health)
  target.className = actor.className
  target.origin = weaponVector(actor.edict.state.origin)
  target.mins = weaponVector(actor.edict.mins)
  target.maxs = weaponVector(actor.edict.maxs)
  target.isMonster = true
  target.flags = actor.flags
  target.inUse = actor.edict.inUse and actor.health > 0
  target.combatant.edict = actor.edict
  target.combatant.health = actor.health
  target.combatant.takeDamage = actor.takeDamage != 0 and actor.deadFlag == ibaiconstants.DEAD_NO
  target.combatant.flags = actor.flags
  target.combatant.moveType = actor.moveType
  target.combatant.mass = actor.mass
  return target
end function

function worldWeaponTarget(entity)
  target = ibwptypes.createTarget(entity.number, entity.health)
  target.className = entity.className
  target.origin = weaponVector(entity.origin)
  target.mins = weaponVector(entity.mins)
  target.maxs = weaponVector(entity.maxs)
  target.inUse = entity.inUse
  target.isMonster = (entity.serverFlags & ibworldconstants.SVF_MONSTER) != 0
  target.flags = entity.flags
  target.combatant.edict.state.number = entity.number
  target.combatant.edict.state.origin = weaponVector(entity.origin)
  target.combatant.edict.mins = weaponVector(entity.mins)
  target.combatant.edict.maxs = weaponVector(entity.maxs)
  target.combatant.health = entity.health
  target.combatant.takeDamage = entity.takeDamage != ibworldconstants.DAMAGE_NO
  target.combatant.flags = entity.flags
  target.combatant.moveType = entity.moveType
  target.combatant.mass = entity.mass
  target.combatant.velocity = [entity.velocity.x, entity.velocity.y, entity.velocity.z]
  return target
end function

function weaponTargetByNumber(runtime, number)
  player = integratedPlayerByNumber(runtime, number)
  if player is not void then return playerWeaponTarget(player, runtime.playerContext.registry) end if
  actor = integratedMonsterByNumber(runtime, number)
  if actor is not void then return monsterWeaponTarget(actor) end if
  worldEntity = ibworld.findByNumber(runtime.world, number)
  if worldEntity is not void and worldEntity.takeDamage != ibworldconstants.DAMAGE_NO then return worldWeaponTarget(worldEntity) end if
  return void
end function

function integratedWeaponTargets(runtime)
  capacity = len(runtime.monsters) + len(runtime.world.entities)
  if runtime.playerContext is not void then capacity = capacity + len(runtime.playerContext.players) end if
  targets = array(capacity)
  targetCount = 0
  if runtime.playerContext is not void then
    for each player in runtime.playerContext.players
      if player.edict.inUse and player.health > 0 then
        targets[targetCount] = playerWeaponTarget(player, runtime.playerContext.registry)
        targetCount = targetCount + 1
      end if
    end for
  end if
  for each actor in runtime.monsters
    if actor.edict.inUse and actor.health > 0 then
      targets[targetCount] = monsterWeaponTarget(actor); targetCount = targetCount + 1
    end if
  end for
  for each entity in runtime.world.entities
    if entity.inUse and entity.takeDamage != ibworldconstants.DAMAGE_NO then
      targets[targetCount] = worldWeaponTarget(entity); targetCount = targetCount + 1
    end if
  end for
  return compactIntegratedValues(targets, targetCount)
end function

function clipWeaponAxis(interval, startValue, endValue, minimum, maximum, axis)
  delta = endValue - startValue
  if delta == 0.0 then return startValue >= minimum and startValue <= maximum end if
  near = (minimum - startValue) / delta
  far = (maximum - startValue) / delta
  normalSign = -1.0
  if near > far then swap = near; near = far; far = swap; normalSign = 1.0 end if
  if near > interval[0] then interval[0] = near; interval[2] = axis; interval[3] = normalSign end if
  if far < interval[1] then interval[1] = far end if
  return interval[0] <= interval[1]
end function

function segmentWeaponTarget(start, finish, target)
  interval = [0.0, 1.0, 0, 0.0]
  minimum = ibqtypes.Vec3(target.origin.x + target.mins.x, target.origin.y + target.mins.y, target.origin.z + target.mins.z)
  maximum = ibqtypes.Vec3(target.origin.x + target.maxs.x, target.origin.y + target.maxs.y, target.origin.z + target.maxs.z)
  if clipWeaponAxis(interval, start.x, finish.x, minimum.x, maximum.x, 0) != true then return [false, 1.0, ibqtypes.zeroVec3()] end if
  if clipWeaponAxis(interval, start.y, finish.y, minimum.y, maximum.y, 1) != true then return [false, 1.0, ibqtypes.zeroVec3()] end if
  if clipWeaponAxis(interval, start.z, finish.z, minimum.z, maximum.z, 2) != true then return [false, 1.0, ibqtypes.zeroVec3()] end if
  if interval[0] < 0.0 or interval[0] > 1.0 then return [false, 1.0, ibqtypes.zeroVec3()] end if
  normal = ibqtypes.zeroVec3()
  if interval[2] == 0 then normal.x = interval[3]
  else if interval[2] == 1 then normal.y = interval[3]
  else normal.z = interval[3]
  end if
  return [true, interval[0], normal]
end function

function integratedWeaponTrace(start, mins, maxs, finish, ignore, mask)
  global activeIntegrationRuntime
  runtime = activeIntegrationRuntime
  if runtime is void or runtime.playerContext is void then return ibwpcore.clearTrace(start, mins, maxs, finish, ignore, mask) end if
  ignoredNumber = -1
  passEdict = void
  if ignore is not void then
    ignoredNumber = ignore.number
    for each projectile in runtime.weaponContext.projectiles
      if nativeRawValue(projectile) == nativeRawValue(ignore) and projectile.owner is not void then ignoredNumber = projectile.owner.number end if
    end for
    ignoredTarget = weaponTargetByNumber(runtime, ignoredNumber)
    if ignoredTarget is not void then passEdict = ignoredTarget.combatant.edict end if
  end if
  engineTrace = runtime.playerContext.imports.trace(start, mins, maxs, finish, passEdict, mask)
  if engineTrace.entity is not void then engineTrace.entity = weaponTargetByNumber(runtime, engineTrace.entity.state.number) end if
  if (mask & (ibqconstants.CONTENTS_MONSTER | ibqconstants.CONTENTS_DEADMONSTER)) == 0 then return engineTrace end if
  closest = engineTrace.fraction
  hitTarget = void
  hitNormal = ibqtypes.Vec3(0.0, 0.0, 1.0)
  for each target in integratedWeaponTargets(runtime)
    if target.number != ignoredNumber and target.inUse then
      candidate = segmentWeaponTarget(start, finish, target)
      if candidate[0] and candidate[1] < closest then closest = candidate[1]; hitTarget = target; hitNormal = candidate[2] end if
    end if
  end for
  if hitTarget is void then return engineTrace end if
  endPosition = ibqtypes.Vec3(
    start.x + (finish.x - start.x) * closest,
    start.y + (finish.y - start.y) * closest,
    start.z + (finish.z - start.z) * closest
  )
  plane = ibqtypes.Plane(hitNormal, 0.0, 0, 0)
  surface = ibqtypes.CollisionSurface("flesh", 0, 0)
  return ibqtypes.Trace(false, false, closest, endPosition, plane, surface, ibqconstants.CONTENTS_MONSTER, hitTarget)
end function

function integratedWeaponContents(point)
  global activeIntegrationRuntime
  runtime = activeIntegrationRuntime
  if runtime is void or runtime.playerContext is void then return 0 end if
  return runtime.playerContext.imports.pointContents(point)
end function

function integratedCanDamage(target, origin)
  trace = integratedWeaponTrace(origin, ibqtypes.zeroVec3(), ibqtypes.zeroVec3(), target.origin, void, ibqconstants.MASK_SHOT)
  return trace.fraction == 1.0 or (trace.entity is not void and trace.entity.number == target.number)
end function

function integratedRadiusTargets(origin, radius)
  global activeIntegrationRuntime
  runtime = activeIntegrationRuntime
  if runtime is void then return [] end if
  targets = integratedWeaponTargets(runtime)
  result = array(len(targets))
  resultCount = 0
  for each target in targets
    if ibwpvector.length(ibwpvector.subtract(target.origin, origin)) <= radius then
      result[resultCount] = target; resultCount = resultCount + 1
    end if
  end for
  return compactIntegratedValues(result, resultCount)
end function

function integratedWeaponDamage(combatant, request)
  global activeIntegrationRuntime
  runtime = activeIntegrationRuntime
  if runtime is void then return ibgpcombat.T_Damage(combatant, request) end if
  number = combatant.edict.state.number
  player = integratedPlayerByNumber(runtime, number)
  actor = integratedMonsterByNumber(runtime, number)
  worldEntity = ibworld.findByNumber(runtime.world, number)
  if player is not void and player.deadFlag != ibplayerconstants.DEAD_NO then return false end if
  if actor is not void and actor.health <= 0 then return false end if
  result = ibgpcombat.T_Damage(combatant, request)
  ibDamagePointHolder = weaponVector(request.point)
  ibDamageDirectionHolder = weaponVector(request.direction)
  ibDamageWasBullet = (request.flags & ibgpconstants.DAMAGE_BULLET) != 0
  if result.armorSaved > 0 or result.protectedDamage > 0 then
    integratedDamageEffect(ibDamagePointHolder, ibDamageDirectionHolder, false, ibDamageWasBullet)
  end if
  if result.taken > 0 then
    integratedDamageEffect(ibDamagePointHolder, ibDamageDirectionHolder,
      player is not void or actor is not void, ibDamageWasBullet)
  end if
  attackerNumber = ibwpcore.damageAttackerNumber()
  if player is not void then
    player.health = combatant.health
    player.velocity = combatant.velocity
    ibpowerups.SyncArmorFromCombatant(player.gameplay, combatant)
    ibplayerview.RecordDamage(player, result.taken, result.armorSaved, 0, request.knockback, request.point)
    if result.killed and player.deadFlag == ibplayerconstants.DEAD_NO then
      attackerPlayer = integratedPlayerByNumber(runtime, attackerNumber)
      ibplayerrules.player_die(runtime.playerContext, player, void, attackerPlayer, result.taken, request.point, result.meansOfDeath)
    end if
  else if actor is not void then
    actor.health = combatant.health
    attackerActor = findAIPlayer(runtime, attackerNumber)
    if attackerActor is void then attackerActor = integratedMonsterByNumber(runtime, attackerNumber) end if
    if result.killed then ibmonster.DispatchDie(actor, attackerActor, result.taken, runtime.aiContext)
    else if result.taken > 0 then ibmonster.DispatchPain(actor, attackerActor, result.taken, runtime.aiContext)
    end if
  else if worldEntity is not void then
    worldEntity.health = combatant.health
    worldEntity.velocity = weaponVector(combatant.velocity)
    if result.killed and worldEntity.die is not void then
      attackerWorld = ibworld.findByNumber(runtime.world, attackerNumber)
      attackerPlayer = integratedPlayerByNumber(runtime, attackerNumber)
      if attackerWorld is void and attackerPlayer is not void then attackerWorld = playerWorldProxy(attackerPlayer) end if
      ibworld.killEntity(runtime.world, worldEntity, void, attackerWorld, result.taken, weaponVector(request.point))
    end if
  end if
  return result
end function

function integratedWorldMeans(means)
  if means == ibworldconstants.MOD_CRUSH then return ibplayerconstants.MOD_CRUSH end if
  if means == ibworldconstants.MOD_BARREL then return ibplayerconstants.MOD_BARREL end if
  if means == ibworldconstants.MOD_TARGET_LASER then return ibplayerconstants.MOD_TARGET_LASER end if
  return ibplayerconstants.MOD_EXPLOSIVE
end function

function integratedSourceNumber(source)
  if source is void then return -1 end if
  directNumber = try(source.number)
  if typeof(directNumber) == "int" then return directNumber end if
  gameplayNumber = try(source.edict.state.number)
  if typeof(gameplayNumber) == "int" then return gameplayNumber end if
  engineNumber = try(source.state.number)
  if typeof(engineNumber) == "int" then return engineNumber end if
  return -1
end function

function integratedWorldDamage(targetEntity, inflictor, attacker, amount, means)
  global activeIntegrationRuntime
  runtime = activeIntegrationRuntime
  if runtime is void or targetEntity is void then return false end if
  target = weaponTargetByNumber(runtime, targetEntity.number)
  if target is void then return false end if
  inflictorTarget = void
  attackerTarget = void
  inflictorNumber = integratedSourceNumber(inflictor)
  attackerNumber = integratedSourceNumber(attacker)
  if inflictorNumber >= 0 then inflictorTarget = weaponTargetByNumber(runtime, inflictorNumber) end if
  if attackerNumber >= 0 then attackerTarget = weaponTargetByNumber(runtime, attackerNumber) end if
  damageFlags = 0
  if means == ibworldconstants.MOD_TARGET_LASER then damageFlags = ibgpconstants.DAMAGE_ENERGY end if
  return ibwpcore.applyDamage(runtime.weaponContext, target, inflictorTarget, attackerTarget,
    ibqtypes.zeroVec3(), target.origin, amount, 1, damageFlags, integratedWorldMeans(means))
end function

function clipWorldLaserAxis(clip, startValue, endValue, minimum, maximum, axis)
  delta = endValue - startValue
  if delta == 0.0 then return startValue >= minimum and startValue <= maximum end if
  near = (minimum - startValue) / delta
  far = (maximum - startValue) / delta
  normalSign = -1.0
  if near > far then swap = near; near = far; far = swap; normalSign = 1.0 end if
  if near > clip.enter then
    clip.enter = near
    clip.normalAxis = axis
    clip.normalSign = normalSign
  end if
  if far < clip.exit then clip.exit = far end if
  return clip.enter <= clip.exit
end function

function clipWorldLaserBounds(start, finish, origin, mins, maxs)
  global worldLaserClipScratch
  clip = worldLaserClipScratch
  clip.hit = false
  clip.enter = 0.0
  clip.exit = 1.0
  clip.normalAxis = -1
  clip.normalSign = 0.0
  if clipWorldLaserAxis(clip, start.x, finish.x,
      origin.x + mins.x, origin.x + maxs.x, 0) == false then return false end if
  if clipWorldLaserAxis(clip, start.y, finish.y,
      origin.y + mins.y, origin.y + maxs.y, 1) == false then return false end if
  if clipWorldLaserAxis(clip, start.z, finish.z,
      origin.z + mins.z, origin.z + maxs.z, 2) == false then return false end if
  clip.hit = clip.enter >= 0.0 and clip.enter <= 1.0
  return clip.hit
end function

function integratedWorldLaserTrace(start, finish, ignore)
  global activeIntegrationRuntime, worldLaserTraceScratch, worldLaserEndScratch
  global worldLaserNormalScratch, worldLaserPlayerProxy, worldLaserBlockProxy
  runtime = activeIntegrationRuntime
  result = worldLaserTraceScratch
  endPosition = worldLaserEndScratch
  normal = worldLaserNormalScratch
  endPosition.x = finish.x; endPosition.y = finish.y; endPosition.z = finish.z
  normal.x = 0.0; normal.y = 0.0; normal.z = 0.0
  result.hit = false
  result.entity = void
  result.endPosition = endPosition
  result.planeNormal = normal
  if runtime is void or runtime.playerContext is void then return result end if

  ignoredNumber = -1
  passEdict = void
  if ignore is not void then
    ignoredNumber = ignore.number
    if runtime.exportTable is not void and ignoredNumber >= 0 and
        ignoredNumber < runtime.exportTable.numEdicts then
      passEdict = runtime.exportTable.edicts[ignoredNumber]
    end if
  end if

  mask = ibqconstants.CONTENTS_SOLID | ibqconstants.CONTENTS_MONSTER |
    ibqconstants.CONTENTS_DEADMONSTER
  engineTrace = runtime.playerContext.imports.trace(start, aiTraceZeroScratch,
    aiTraceZeroScratch, finish, passEdict, mask)
  closest = engineTrace.fraction
  selectedKind = 0
  selected = void
  selectedNumber = -1
  bestAxis = -1
  bestSign = 0.0
  if engineTrace.entity is not void then selectedNumber = engineTrace.entity.state.number end if

  for each player in runtime.playerContext.players
    if player.edict.inUse and player.edict.state.number != ignoredNumber and
        player.edict.solid != ibgconstants.SOLID_NOT and
        clipWorldLaserBounds(start, finish, player.edict.state.origin,
          player.edict.mins, player.edict.maxs) and
        worldLaserClipScratch.enter < closest then
      closest = worldLaserClipScratch.enter
      bestAxis = worldLaserClipScratch.normalAxis
      bestSign = worldLaserClipScratch.normalSign
      selectedKind = 1
      selected = player
    end if
  end for

  for each actor in runtime.monsters
    if actor.edict.inUse and actor.edict.state.number != ignoredNumber and
        actor.edict.solid != ibgconstants.SOLID_NOT and
        clipWorldLaserBounds(start, finish, actor.edict.state.origin,
          actor.edict.mins, actor.edict.maxs) and
        worldLaserClipScratch.enter < closest then
      closest = worldLaserClipScratch.enter
      bestAxis = worldLaserClipScratch.normalAxis
      bestSign = worldLaserClipScratch.normalSign
      selectedKind = 2
      selected = actor
    end if
  end for

  for each candidate in runtime.world.entities
    if candidate.inUse and candidate.number != ignoredNumber and
        candidate.solid == ibworldconstants.SOLID_BBOX and
        clipWorldLaserBounds(start, finish, candidate.origin,
          candidate.mins, candidate.maxs) and
        worldLaserClipScratch.enter < closest then
      closest = worldLaserClipScratch.enter
      bestAxis = worldLaserClipScratch.normalAxis
      bestSign = worldLaserClipScratch.normalSign
      selectedKind = 3
      selected = candidate
    end if
  end for

  if selectedKind == 0 and closest >= 1.0 and engineTrace.startSolid == false and
      engineTrace.allSolid == false then return result end if

  result.hit = true
  if selectedKind == 0 then
    endPosition.x = engineTrace.endPosition.x
    endPosition.y = engineTrace.endPosition.y
    endPosition.z = engineTrace.endPosition.z
    normal.x = engineTrace.plane.normal.x
    normal.y = engineTrace.plane.normal.y
    normal.z = engineTrace.plane.normal.z
    blocker = ibworld.findByNumber(runtime.world, selectedNumber)
    if blocker is void then
      blocker = worldLaserBlockProxy
      blocker.number = selectedNumber
      blocker.inUse = true
      blocker.className = "laser_world_block"
      blocker.takeDamage = ibworldconstants.DAMAGE_NO
      blocker.flags = 0
      blocker.serverFlags = 0
      blocker.isClient = false
    end if
    result.entity = blocker
    return result
  end if

  endPosition.x = start.x + (finish.x - start.x) * closest
  endPosition.y = start.y + (finish.y - start.y) * closest
  endPosition.z = start.z + (finish.z - start.z) * closest
  if bestAxis == 0 then normal.x = bestSign
  else if bestAxis == 1 then normal.y = bestSign
  else if bestAxis == 2 then normal.z = bestSign
  end if
  if selectedKind == 1 then
    proxy = worldLaserPlayerProxy
    proxy.number = selected.edict.state.number
    proxy.inUse = selected.edict.inUse
    proxy.className = "player"
    proxy.origin = selected.edict.state.origin
    proxy.mins = selected.edict.mins
    proxy.maxs = selected.edict.maxs
    proxy.health = selected.health
    proxy.takeDamage = selected.takeDamage
    proxy.flags = selected.flags
    proxy.serverFlags = selected.edict.serverFlags
    proxy.isClient = true
    result.entity = proxy
  else if selectedKind == 2 then
    proxy = selected.triggerProxy
    if proxy is void then
      proxy = ibwtypes.createEntity(selected.edict.state.number, selected.className)
      selected.triggerProxy = proxy
    end if
    proxy.number = selected.edict.state.number
    proxy.inUse = selected.edict.inUse
    proxy.className = selected.className
    proxy.origin = selected.edict.state.origin
    proxy.mins = selected.edict.mins
    proxy.maxs = selected.edict.maxs
    proxy.health = selected.health
    proxy.takeDamage = selected.takeDamage
    proxy.flags = selected.flags
    proxy.serverFlags = selected.edict.serverFlags | ibworldconstants.SVF_MONSTER
    proxy.isClient = false
    result.entity = proxy
  else
    result.entity = selected
  end if
  return result
end function

function integratedWorldLaserSparks(origin, normal, count, color)
  global activeIntegrationRuntime
  runtime = activeIntegrationRuntime
  if runtime is void or runtime.playerContext is void then return false end if
  imports = runtime.playerContext.imports
  imports.writeByte(ibqconstants.SVC_TEMP_ENTITY)
  imports.writeByte(ibwpconstants.TE_LASER_SPARKS)
  imports.writeByte(count)
  imports.writePosition(origin)
  imports.writeDirection(normal)
  imports.writeByte(color & 255)
  return imports.multicast(origin, ibgconstants.MULTICAST_PVS)
end function

function integratedWorldEarthquake(entity, speed, playSound)
  global activeIntegrationRuntime
  runtime = activeIntegrationRuntime
  if runtime is void or runtime.playerContext is void then return 0 end if
  if playSound and runtime.exportTable is not void and entity.number >= 0 and
      entity.number < runtime.exportTable.numEdicts then
    imports = runtime.playerContext.imports
    imports.positionedSound(entity.origin, runtime.exportTable.edicts[entity.number],
      ibgconstants.CHAN_AUTO, imports.soundIndex(entity.noise), 1.0,
      ibgconstants.ATTN_NONE, 0.0)
  end if
  affected = 0
  for each player in runtime.playerContext.players
    if player.edict.inUse and player.groundEntity is not void then
      player.groundEntity = void
      player.velocity[0] = player.velocity[0] + integratedRandomSigned() * 150.0
      player.velocity[1] = player.velocity[1] + integratedRandomSigned() * 150.0
      player.velocity[2] = speed * 0.5
      affected = affected + 1
    end if
  end for
  return affected
end function

function integratedWorldFireBlaster(entity, direction, damage, speed)
  global activeIntegrationRuntime
  runtime = activeIntegrationRuntime
  if runtime is void then return void end if
  shooter = worldWeaponTarget(entity)
  projectile = ibwpprojectiles.fireTargetBlaster(runtime.weaponContext,
    shooter, entity.origin, direction, damage, speed)
  if runtime.playerContext is not void and runtime.exportTable is not void and
      entity.number >= 0 and entity.number < runtime.exportTable.numEdicts then
    imports = runtime.playerContext.imports
    imports.sound(runtime.exportTable.edicts[entity.number],
      ibgconstants.CHAN_VOICE, imports.soundIndex("weapons/laser2.wav"),
      1.0, ibgconstants.ATTN_NORM, 0.0)
  end if
  return projectile
end function

function integratedWorldKillBox(entity)
  global activeIntegrationRuntime
  runtime = activeIntegrationRuntime
  if runtime is void or runtime.playerContext is void then return true end if
  minimum = ibqtypes.Vec3(entity.origin.x + entity.mins.x,
    entity.origin.y + entity.mins.y, entity.origin.z + entity.mins.z)
  maximum = ibqtypes.Vec3(entity.origin.x + entity.maxs.x,
    entity.origin.y + entity.maxs.y, entity.origin.z + entity.maxs.z)
  candidates = runtime.playerContext.imports.boxEdicts(minimum, maximum, 1)
  source = worldWeaponTarget(entity)
  for each engineEntity in candidates
    if engineEntity.state.number != entity.number then
      target = weaponTargetByNumber(runtime, engineEntity.state.number)
      if target is void then return false end if
      ibwpcore.applyDamage(runtime.weaponContext, target, source, source,
        ibqtypes.zeroVec3(), entity.origin, 100000, 0,
        ibgpconstants.DAMAGE_NO_PROTECTION, ibgpconstants.MOD_TELEFRAG)
    end if
  end for
  return true
end function

function reserveSpawnerEdict(runtime)
  number = runtime.world.nextEntityNumber
  if runtime.exportTable is not void then
    number = runtime.exportTable.numEdicts
    if number >= runtime.exportTable.maxEdicts then
      return error(9699, "target_spawner exceeds edict capacity")
    end if
    runtime.exportTable.edicts[number] = ibgametypes.zeroEdict(number)
    runtime.exportTable.edicts[number].inUse = true
    runtime.exportTable.numEdicts = number + 1
  end if
  if number >= runtime.world.nextEntityNumber then
    runtime.world.nextEntityNumber = number + 1
  end if
  return number
end function

function integratedWorldSpawnExternal(className, origin, angles, velocity)
  global activeIntegrationRuntime
  runtime = activeIntegrationRuntime
  if runtime is void then return false end if

  archetype = ibarchetypes.find(ibarchetypes.defaultRegistry(), className)
  if archetype is not void then
    actor = integratedSpawnMonster(className, void)
    actor.edict.state.origin = ibqtypes.Vec3(origin.x, origin.y, origin.z)
    actor.edict.state.oldOrigin = ibqtypes.Vec3(origin.x, origin.y, origin.z)
    actor.edict.state.angles = ibqtypes.Vec3(angles.x, angles.y, angles.z)
    actor.velocity.x = velocity.x; actor.velocity.y = velocity.y
    actor.velocity.z = velocity.z
    actor.activity = "stand"
    actor.nextThink = runtime.aiContext.time + runtime.world.frameTime
    ibmonster.MonsterStart(actor, runtime.aiContext)
    ibmonster.MonsterStartGo(actor, runtime.aiContext)
    if runtime.playerContext is not void then
      imports = runtime.playerContext.imports
      imports.modelIndex(actor.model)
      imports.setModel(actor.edict, actor.model)
      for each soundName in ibaisounds.stockNames(actor.className)
        imports.soundIndex(soundName)
      end for
      imports.linkEntity(actor.edict)
    end if
    proxy = ibwtypes.createEntity(actor.edict.state.number, actor.className)
    proxy.origin = actor.edict.state.origin
    proxy.mins = actor.edict.mins; proxy.maxs = actor.edict.maxs
    integratedWorldKillBox(proxy)
    return actor
  end if

  registry = ibitems.stockRegistry()
  if runtime.playerContext is not void then registry = runtime.playerContext.registry end if
  definition = ibitemrules.findByClassName(registry, className)
  if definition is not void then
    number = reserveSpawnerEdict(runtime)
    if number is error then return number end if
    itemEntity = ibgtypes.createItemEntity(number, definition)
    itemEntity.edict.state.origin = ibqtypes.Vec3(origin.x, origin.y, origin.z)
    itemEntity.edict.state.oldOrigin = ibqtypes.Vec3(origin.x, origin.y, origin.z)
    itemEntity.edict.state.angles = ibqtypes.Vec3(angles.x, angles.y, angles.z)
    itemEntity.edict.mins = ibqtypes.Vec3(-15.0, -15.0, -15.0)
    itemEntity.edict.maxs = ibqtypes.Vec3(15.0, 15.0, 15.0)
    itemEntity.edict.solid = ibgconstants.SOLID_TRIGGER
    runtime.items = runtime.items + [itemEntity]
    if runtime.playerContext is not void and runtime.exportTable is not void then
      imports = runtime.playerContext.imports
      ibprecache.PrecacheItem(registry, definition, imports)
      if definition.worldModel != "" then imports.setModel(itemEntity.edict, definition.worldModel) end if
      runtime.exportTable.edicts[number] = itemEntity.edict
      imports.linkEntity(runtime.exportTable.edicts[number])
    end if
    proxy = ibwtypes.createEntity(number, className)
    proxy.origin = itemEntity.edict.state.origin
    proxy.mins = itemEntity.edict.mins; proxy.maxs = itemEntity.edict.maxs
    integratedWorldKillBox(proxy)
    return itemEntity
  end if

  if className == "misc_gib_arm" or className == "misc_gib_leg" or
      className == "misc_gib_head" then
    number = reserveSpawnerEdict(runtime)
    if number is error then return number end if
    entity = ibwtypes.createEntity(number, className)
    entity.origin = ibqtypes.Vec3(origin.x, origin.y, origin.z)
    entity.oldOrigin = ibqtypes.Vec3(origin.x, origin.y, origin.z)
    entity.angles = ibqtypes.Vec3(angles.x, angles.y, angles.z)
    entity.velocity = ibqtypes.Vec3(velocity.x, velocity.y, velocity.z)
    ibworld.addEntity(runtime.world, entity)
    installWorldSpawn(entity, runtime.world)
    if runtime.playerContext is not void and runtime.exportTable is not void then
      runtime.world.callbacks.setModel(entity, entity.model)
      runtime.world.callbacks.linkEntity(entity)
    end if
    return entity
  end if

  ibworld.log(runtime.world, "target_spawner unknown class " + className)
  return false
end function

function integratedWorldRadiusDamage(inflictor, attacker, amount, radius, means)
  global activeIntegrationRuntime
  runtime = activeIntegrationRuntime
  if runtime is void or inflictor is void then return false end if
  inflictorTarget = worldWeaponTarget(inflictor)
  attackerTarget = void
  attackerNumber = integratedSourceNumber(attacker)
  if attackerNumber >= 0 then attackerTarget = weaponTargetByNumber(runtime, attackerNumber) end if
  ibwpcore.radiusDamage(runtime.weaponContext, inflictorTarget, attackerTarget, amount, void, radius, integratedWorldMeans(means))
  return true
end function

function integratedResolveKeyItem(itemClassName)
  ibKeyRegistryHolder = ibitems.stockRegistry()
  ibKeyDefinitionHolder = ibitemrules.findByClassName(ibKeyRegistryHolder, itemClassName)
  if ibKeyDefinitionHolder is void then return void end if
  return ibKeyDefinitionHolder.pickupName
end function

function integratedWorldPlayer(activator)
  global activeIntegrationRuntime
  ibKeyRuntimeHolder = activeIntegrationRuntime
  if ibKeyRuntimeHolder is void or ibKeyRuntimeHolder.playerContext is void or activator is void then return void end if
  for each ibKeyPlayerHolder in ibKeyRuntimeHolder.playerContext.players
    if ibKeyPlayerHolder.edict.state.number == activator.number then return ibKeyPlayerHolder end if
  end for
  return void
end function

function integratedHasKeyItem(activator, itemClassName)
  ibKeyPlayerHolder = integratedWorldPlayer(activator)
  if ibKeyPlayerHolder is void then return false end if
  global activeIntegrationRuntime
  ibKeyRuntimeHolder = activeIntegrationRuntime
  ibKeyDefinitionHolder = ibitemrules.findByClassName(ibKeyRuntimeHolder.playerContext.registry, itemClassName)
  if ibKeyDefinitionHolder is void then return false end if
  return ibKeyPlayerHolder.gameplay.inventory.counts[ibKeyDefinitionHolder.index] > 0
end function

function integratedConsumeKeyItem(activator, itemClassName)
  ibKeyPlayerHolder = integratedWorldPlayer(activator)
  if ibKeyPlayerHolder is void then return false end if
  global activeIntegrationRuntime
  ibKeyRuntimeHolder = activeIntegrationRuntime
  ibKeyContextHolder = ibKeyRuntimeHolder.playerContext
  ibKeyDefinitionHolder = ibitemrules.findByClassName(ibKeyContextHolder.registry, itemClassName)
  if ibKeyDefinitionHolder is void or ibKeyPlayerHolder.gameplay.inventory.counts[ibKeyDefinitionHolder.index] <= 0 then return false end if
  if ibKeyContextHolder.cooperative and itemClassName != "key_power_cube" then
    for each ibKeyCoopPlayerHolder in ibKeyContextHolder.players
      ibKeyCoopPlayerHolder.gameplay.inventory.counts[ibKeyDefinitionHolder.index] = 0
    end for
  else
    ibKeyPlayerHolder.gameplay.inventory.counts[ibKeyDefinitionHolder.index] = ibKeyPlayerHolder.gameplay.inventory.counts[ibKeyDefinitionHolder.index] - 1
  end if
  return true
end function

function integratedWorldActor(number)
  global activeIntegrationRuntime
  ibWorldActorRuntimeHolder = activeIntegrationRuntime
  if ibWorldActorRuntimeHolder is void then return void end if
  for each ibWorldActorHolder in ibWorldActorRuntimeHolder.monsters
    if ibWorldActorHolder.edict.state.number == number then return ibWorldActorHolder end if
  end for
  return void
end function

function integratedActorMessage(actorEntity, message)
  ibWorldActorHolder = integratedWorldActor(actorEntity.number)
  if ibWorldActorHolder is void then return false end if
  ibWorldActorHolder.activity = "message:" + message
  return true
end function

function integratedWorldAITarget(entity)
  if entity is void then return void end if
  ibWorldTargetHolder = ibaitypes.createActor(entity.number, entity.className)
  ibWorldTargetHolder.edict.state.origin = entity.origin
  ibWorldTargetHolder.edict.state.angles = entity.angles
  ibWorldTargetHolder.target = entity.target
  ibWorldTargetHolder.targetName = entity.targetName
  ibWorldTargetHolder.isMonster = false
  ibWorldTargetHolder.edict.inUse = entity.inUse
  return ibWorldTargetHolder
end function

function integratedActorTransition(actorEntity, waypoint, action, actionTarget, nextTarget, wait, flags)
  ibWorldActorHolder = integratedWorldActor(actorEntity.number)
  if ibWorldActorHolder is void then return false end if
  ibWorldNextHolder = integratedWorldAITarget(nextTarget)
  ibWorldActorHolder.moveTarget = ibWorldNextHolder
  ibWorldActorHolder.goalEntity = ibWorldNextHolder
  ibWorldActorHolder.info.pauseTime = wait
  ibWorldActorHolder.activity = "actor-" + action
  if action == "attack" then ibWorldActorHolder.enemy = integratedWorldAITarget(actionTarget) end if
  if (flags & ibworldconstants.ACTOR_HOLD) != 0 then ibWorldActorHolder.info.aiFlags = ibWorldActorHolder.info.aiFlags | ibaiconstants.AI_STAND_GROUND end if
  if (flags & ibworldconstants.ACTOR_BRUTAL) != 0 then ibWorldActorHolder.info.aiFlags = ibWorldActorHolder.info.aiFlags | ibaiconstants.AI_BRUTAL end if
  return true
end function

function integratedCombatPointTransition(actorEntity, point, nextTarget, hold, clearCombatPoint)
  ibCombatActorHolder = integratedWorldActor(actorEntity.number)
  if ibCombatActorHolder is void then return false end if
  ibCombatNextHolder = integratedWorldAITarget(nextTarget)
  ibCombatActorHolder.moveTarget = ibCombatNextHolder
  ibCombatActorHolder.goalEntity = ibCombatNextHolder
  if hold then ibCombatActorHolder.info.aiFlags = ibCombatActorHolder.info.aiFlags | ibaiconstants.AI_STAND_GROUND end if
  if clearCombatPoint then ibCombatActorHolder.info.aiFlags = ibCombatActorHolder.info.aiFlags & ~ibaiconstants.AI_COMBAT_POINT end if
  return true
end function

function integratedClockSeconds()
  global activeIntegrationRuntime
  if activeIntegrationRuntime is void or activeIntegrationRuntime.playerContext is void then return 0 end if
  return activeIntegrationRuntime.playerContext.time
end function

function integratedWorldSetModel(entity, modelName)
  global activeIntegrationRuntime
  ibWorldModelRuntimeHolder = activeIntegrationRuntime
  if ibWorldModelRuntimeHolder is void or ibWorldModelRuntimeHolder.playerContext is void or ibWorldModelRuntimeHolder.exportTable is void then return true end if
  if entity.number < 0 or entity.number >= ibWorldModelRuntimeHolder.exportTable.numEdicts then return false end if
  ibWorldModelEdictHolder = ibWorldModelRuntimeHolder.exportTable.edicts[entity.number]
  ibWorldModelRuntimeHolder.playerContext.imports.setModel(ibWorldModelEdictHolder, modelName)
  entity.modelIndex = ibWorldModelEdictHolder.state.modelIndex
  entity.mins = ibWorldModelEdictHolder.mins
  entity.maxs = ibWorldModelEdictHolder.maxs
  return true
end function

function integratedLightStyle(style, pattern)
  global activeIntegrationRuntime
  ibLightRuntimeHolder = activeIntegrationRuntime
  if ibLightRuntimeHolder is void or ibLightRuntimeHolder.playerContext is void then return false end if
  if style < 0 or style >= ibqconstants.MAX_LIGHTSTYLES then return false end if
  return ibLightRuntimeHolder.playerContext.imports.configString(ibqconstants.CS_LIGHTS + style, pattern)
end function

function integratedWeaponEffect(effect)
  global activeIntegrationRuntime
  ibWeaponEffectRuntimeHolder = activeIntegrationRuntime
  if ibWeaponEffectRuntimeHolder is void or ibWeaponEffectRuntimeHolder.playerContext is void then return false end if
  ibWeaponEffectImportsHolder = ibWeaponEffectRuntimeHolder.playerContext.imports
  ibWeaponEffectKind = effect.kind
  ibWeaponEffectType = -1
  ibWeaponEffectDestination = ibgconstants.MULTICAST_PVS

  if ibWeaponEffectKind == "impact" then
    if effect.style != ibwpconstants.TE_GUNSHOT and effect.style != ibwpconstants.TE_SHOTGUN then
      return error(9692, "invalid integrated impact effect type")
    end if
    ibWeaponEffectType = effect.style
  else if ibWeaponEffectKind == "blaster-impact" then ibWeaponEffectType = ibwpconstants.TE_BLASTER
  else if ibWeaponEffectKind == "splash" then ibWeaponEffectType = ibwpconstants.TE_SPLASH
  else if ibWeaponEffectKind == "bubble-trail" then ibWeaponEffectType = ibwpconstants.TE_BUBBLETRAIL; ibWeaponEffectDestination = ibgconstants.MULTICAST_PHS
  else if ibWeaponEffectKind == "rail-trail" or ibWeaponEffectKind == "rail-trail-water" then ibWeaponEffectType = ibwpconstants.TE_RAILTRAIL; ibWeaponEffectDestination = ibgconstants.MULTICAST_PHS
  else if ibWeaponEffectKind == "rocket-explosion" then ibWeaponEffectType = ibwpconstants.TE_ROCKET_EXPLOSION
  else if ibWeaponEffectKind == "grenade-explosion" then ibWeaponEffectType = ibwpconstants.TE_GRENADE_EXPLOSION
  else if ibWeaponEffectKind == "rocket-explosion-water" then ibWeaponEffectType = ibwpconstants.TE_ROCKET_EXPLOSION_WATER
  else if ibWeaponEffectKind == "grenade-explosion-water" then ibWeaponEffectType = ibwpconstants.TE_GRENADE_EXPLOSION_WATER
  else if ibWeaponEffectKind == "bfg-laser" then ibWeaponEffectType = ibwpconstants.TE_BFG_LASER; ibWeaponEffectDestination = ibgconstants.MULTICAST_PHS
  else if ibWeaponEffectKind == "bfg-target-explosion" then ibWeaponEffectType = ibwpconstants.TE_BFG_EXPLOSION
  else if ibWeaponEffectKind == "bfg-big-explosion" then ibWeaponEffectType = ibwpconstants.TE_BFG_BIGEXPLOSION
  else return error(9691, "unsupported integrated weapon effect " + ibWeaponEffectKind)
  end if

  if ibWeaponEffectType < 0 or ibWeaponEffectType > 255 then return error(9692, "invalid integrated weapon effect type") end if
  ibWeaponEffectImportsHolder.writeByte(ibqconstants.SVC_TEMP_ENTITY)
  ibWeaponEffectImportsHolder.writeByte(ibWeaponEffectType)
  if ibWeaponEffectType == ibwpconstants.TE_SPLASH then
    ibWeaponEffectCount = effect.count
    if ibWeaponEffectCount < 0 then ibWeaponEffectCount = 0 end if
    if ibWeaponEffectCount > 255 then ibWeaponEffectCount = 255 end if
    ibWeaponEffectImportsHolder.writeByte(ibWeaponEffectCount)
    ibWeaponEffectImportsHolder.writePosition(effect.endPosition)
    ibWeaponEffectImportsHolder.writeDirection(effect.normal)
    ibWeaponEffectImportsHolder.writeByte(effect.style)
  else if ibWeaponEffectType == ibwpconstants.TE_RAILTRAIL or
      ibWeaponEffectType == ibwpconstants.TE_BUBBLETRAIL or
      ibWeaponEffectType == ibwpconstants.TE_BFG_LASER then
    ibWeaponEffectImportsHolder.writePosition(effect.start)
    ibWeaponEffectImportsHolder.writePosition(effect.endPosition)
  else if ibWeaponEffectType == ibwpconstants.TE_GUNSHOT or
      ibWeaponEffectType == ibwpconstants.TE_SHOTGUN or
      ibWeaponEffectType == ibwpconstants.TE_BLASTER then
    ibWeaponEffectImportsHolder.writePosition(effect.endPosition)
    ibWeaponEffectImportsHolder.writeDirection(effect.normal)
  else
    ibWeaponEffectImportsHolder.writePosition(effect.endPosition)
  end if
  return ibWeaponEffectImportsHolder.multicast(effect.endPosition, ibWeaponEffectDestination)
end function

function integratedDamageEffect(point, direction, blood, bullet)
  global activeIntegrationRuntime
  ibDamageEffectRuntimeHolder = activeIntegrationRuntime
  if ibDamageEffectRuntimeHolder is void or ibDamageEffectRuntimeHolder.playerContext is void then return false end if
  ibDamageEffectImportsHolder = ibDamageEffectRuntimeHolder.playerContext.imports
  ibDamageEffectType = ibwpconstants.TE_SPARKS
  if blood then ibDamageEffectType = ibwpconstants.TE_BLOOD end if
  if not blood and bullet then ibDamageEffectType = ibwpconstants.TE_BULLET_SPARKS end if
  ibDamageEffectImportsHolder.writeByte(ibqconstants.SVC_TEMP_ENTITY)
  ibDamageEffectImportsHolder.writeByte(ibDamageEffectType)
  ibDamageEffectImportsHolder.writePosition(point)
  ibDamageEffectImportsHolder.writeDirection(direction)
  return ibDamageEffectImportsHolder.multicast(point, ibgconstants.MULTICAST_PVS)
end function

function integratedWeaponSound(entity, soundName)
  global activeIntegrationRuntime
  runtime = activeIntegrationRuntime
  if runtime is void or runtime.playerContext is void then return false end if
  imports = runtime.playerContext.imports
  ibWeaponSoundEngineNumber = try(entity.engineNumber)
  if typeof(ibWeaponSoundEngineNumber) == "int" and ibWeaponSoundEngineNumber >= 0 and
      runtime.exportTable is not void and ibWeaponSoundEngineNumber < runtime.exportTable.numEdicts then
    return imports.sound(runtime.exportTable.edicts[ibWeaponSoundEngineNumber], ibgconstants.CHAN_WEAPON,
      imports.soundIndex(soundName), 1.0, ibgconstants.ATTN_NORM, 0.0)
  end if
  target = weaponTargetByNumber(runtime, entity.number)
  if target is void then return true end if
  return imports.sound(target.combatant.edict, ibgconstants.CHAN_WEAPON,
    imports.soundIndex(soundName), 1.0, ibgconstants.ATTN_NORM, 0.0)
end function

function integratedWeaponLink(entity)
  global activeIntegrationRuntime
  ibProjectileRuntimeHolder = activeIntegrationRuntime
  if ibProjectileRuntimeHolder is void or ibProjectileRuntimeHolder.exportTable is void or
      ibProjectileRuntimeHolder.playerContext is void then return true end if
  ibProjectileExportHolder = ibProjectileRuntimeHolder.exportTable
  ibProjectileEngineNumber = entity.engineNumber
  if ibProjectileEngineNumber < 0 then
    ibProjectileCandidate = 1
    ibProjectileEngineNumber = -1
    while ibProjectileCandidate < ibProjectileExportHolder.numEdicts and ibProjectileEngineNumber < 0
      ibProjectileReserved = false
      for each ibProjectilePlayerHolder in ibProjectileRuntimeHolder.playerContext.players
        if ibProjectilePlayerHolder.edict.state.number == ibProjectileCandidate then ibProjectileReserved = true end if
      end for
      if not ibProjectileReserved and not ibProjectileExportHolder.edicts[ibProjectileCandidate].inUse then
        ibProjectileEngineNumber = ibProjectileCandidate
      end if
      ibProjectileCandidate = ibProjectileCandidate + 1
    end while
    if ibProjectileEngineNumber < 0 then
      ibProjectileEngineNumber = ibProjectileExportHolder.numEdicts
      if ibProjectileEngineNumber >= ibProjectileExportHolder.maxEdicts then
        return error(9694, "projectile export edict limit reached")
      end if
      ibProjectileExportHolder.numEdicts = ibProjectileExportHolder.numEdicts + 1
    end if
    entity.engineNumber = ibProjectileEngineNumber
  end if
  ibProjectileEdictHolder = ibgametypes.zeroEdict(ibProjectileEngineNumber)
  ibProjectileEdictHolder.inUse = entity.inUse
  ibProjectileEdictHolder.serverFlags = 0
  if entity.className == "bolt" then ibProjectileEdictHolder.serverFlags = ibgconstants.SVF_DEADMONSTER end if
  ibProjectileEdictHolder.solid = entity.solid
  ibProjectileEdictHolder.clipMask = entity.clipMask
  ibProjectileEdictHolder.state.origin = weaponVector(entity.origin)
  ibProjectileEdictHolder.state.oldOrigin = weaponVector(entity.oldOrigin)
  ibProjectileEdictHolder.state.angles = weaponVector(entity.angles)
  ibProjectileEdictHolder.mins = weaponVector(entity.mins)
  ibProjectileEdictHolder.maxs = weaponVector(entity.maxs)
  ibProjectileEdictHolder.state.effects = entity.effects
  ibProjectileEdictHolder.state.frame = entity.frame
  ibProjectileImportsHolder = ibProjectileRuntimeHolder.playerContext.imports
  if entity.modelName != "" and entity.modelIndex == 0 then
    entity.modelIndex = ibProjectileImportsHolder.modelIndex(entity.modelName)
  end if
  if entity.soundName != "" and entity.soundIndex == 0 then
    entity.soundIndex = ibProjectileImportsHolder.soundIndex(entity.soundName)
  end if
  ibProjectileEdictHolder.state.modelIndex = entity.modelIndex
  ibProjectileEdictHolder.state.sound = entity.soundIndex
  ibProjectileExportHolder.edicts[ibProjectileEngineNumber] = ibProjectileEdictHolder
  ibProjectileStoredEdictHolder = ibProjectileExportHolder.edicts[ibProjectileEngineNumber]
  ibgametypes.stabilizeEdict(ibProjectileStoredEdictHolder)
  ibProjectileImportsHolder.linkEntity(ibProjectileStoredEdictHolder)
  return ibProjectileEngineNumber
end function

function integratedWeaponFree(entity)
  global activeIntegrationRuntime
  ibProjectileFreeRuntimeHolder = activeIntegrationRuntime
  if ibProjectileFreeRuntimeHolder is void or ibProjectileFreeRuntimeHolder.exportTable is void or
      ibProjectileFreeRuntimeHolder.playerContext is void or entity.engineNumber < 0 or
      entity.engineNumber >= ibProjectileFreeRuntimeHolder.exportTable.numEdicts then return true end if
  ibProjectileFreeEdictHolder = ibProjectileFreeRuntimeHolder.exportTable.edicts[entity.engineNumber]
  ibProjectileFreeRuntimeHolder.playerContext.imports.unlinkEntity(ibProjectileFreeEdictHolder)
  ibProjectileFreeEdictHolder.inUse = false
  ibProjectileFreeEdictHolder.solid = ibgconstants.SOLID_NOT
  ibProjectileFreeRuntimeHolder.exportTable.edicts[entity.engineNumber] = ibProjectileFreeEdictHolder
  return true
end function

function integratedPlayerNoise(owner, position, noiseType)
  global activeIntegrationRuntime
  runtime = activeIntegrationRuntime
  if runtime is void or noiseType < 0 or noiseType > 2 then return false end if
  source = findAIPlayer(runtime, owner.number)
  if source is void then return false end if
  if runtime.playerContext is not void and runtime.playerContext.deathmatch then return false end if
  if (source.flags & ibaiconstants.FL_NOTARGET) != 0 then return false end if

  if source.noisePrimary is void then
    ibNoisePrimaryNumber = -(source.edict.state.number * 2 + 1)
    ibNoiseSecondaryNumber = -(source.edict.state.number * 2 + 2)
    ibNoisePrimaryHolder = ibaitypes.createActor(ibNoisePrimaryNumber, "player_noise")
    ibNoiseSecondaryHolder = ibaitypes.createActor(ibNoiseSecondaryNumber, "player_noise")
    ibNoisePrimaryHolder.isClient = false; ibNoisePrimaryHolder.isMonster = false
    ibNoiseSecondaryHolder.isClient = false; ibNoiseSecondaryHolder.isMonster = false
    ibNoisePrimaryHolder.owner = source; ibNoiseSecondaryHolder.owner = source
    ibNoisePrimaryHolder.edict.serverFlags = ibNoisePrimaryHolder.edict.serverFlags | ibgconstants.SVF_NOCLIENT
    ibNoiseSecondaryHolder.edict.serverFlags = ibNoiseSecondaryHolder.edict.serverFlags | ibgconstants.SVF_NOCLIENT
    ibNoisePrimaryHolder.mins = [-8.0, -8.0, -8.0]
    ibNoisePrimaryHolder.maxs = [8.0, 8.0, 8.0]
    ibNoiseSecondaryHolder.mins = [-8.0, -8.0, -8.0]
    ibNoiseSecondaryHolder.maxs = [8.0, 8.0, 8.0]
    ibNoisePrimaryHolder.edict.mins = ibqtypes.Vec3(-8.0, -8.0, -8.0)
    ibNoisePrimaryHolder.edict.maxs = ibqtypes.Vec3(8.0, 8.0, 8.0)
    ibNoiseSecondaryHolder.edict.mins = ibqtypes.Vec3(-8.0, -8.0, -8.0)
    ibNoiseSecondaryHolder.edict.maxs = ibqtypes.Vec3(8.0, 8.0, 8.0)
    source.noisePrimary = ibNoisePrimaryHolder
    source.noiseSecondary = ibNoiseSecondaryHolder
  end if

  noise = source.noisePrimary
  if noiseType == 2 then noise = source.noiseSecondary end if
  noise.owner = source
  noise.edict.inUse = true
  ibNoiseOriginHolder = noise.edict.state.origin
  ibNoiseOriginHolder.x = position.x; ibNoiseOriginHolder.y = position.y
  ibNoiseOriginHolder.z = position.z
  noise.edict.state.origin = ibNoiseOriginHolder
  noise.teleportTime = runtime.aiContext.time
  noise.areaNumber = source.edict.areaNumber
  if runtime.playerContext is not void then
    runtime.playerContext.imports.linkEntity(noise.edict)
    noise.areaNumber = noise.edict.areaNumber
  end if
  if noiseType == 2 then
    runtime.aiContext.sound2Entity = noise
    runtime.aiContext.sound2EntityFrame = runtime.aiContext.frameNumber
  else
    runtime.aiContext.soundEntity = noise
    runtime.aiContext.soundEntityFrame = runtime.aiContext.frameNumber
  end if
  return true
end function

function integratedDodge(owner, start, direction, speed)
  global activeIntegrationRuntime
  ibDodgeRuntimeHolder = activeIntegrationRuntime
  if ibDodgeRuntimeHolder is void or speed <= 0.0 then return false end if
  // g_weapon.c consumes its separate easy-skill draw before the trace. Every
  // stock dodge callback then consumes its own 25-percent draw.
  if ibDodgeRuntimeHolder.aiContext.skill == 0 and
      ibrandom.unit(ibDodgeRuntimeHolder.randomState) > 0.25 then return false end if
  ibDodgeEndHolder = ibwpvector.multiplyAdd(start, 8192.0, direction)
  ibDodgeTraceHolder = integratedWeaponTrace(start, ibqtypes.zeroVec3(), ibqtypes.zeroVec3(),
    ibDodgeEndHolder, owner, ibqconstants.MASK_SHOT)
  if ibDodgeTraceHolder.entity is void then return false end if
  ibDodgeActorHolder = integratedMonsterByNumber(ibDodgeRuntimeHolder, ibDodgeTraceHolder.entity.number)
  if ibDodgeActorHolder is void or ibDodgeActorHolder.health <= 0 then return false end if
  ibDodgePlanHolder = ibreactionseq.stockDodgePlan(ibDodgeActorHolder.className)
  if ibDodgePlanHolder is void or ibreactionseq.planByName(ibDodgeActorHolder.className, ibDodgeActorHolder.activity) is not void then return false end if
  ibDodgeAttackerActorHolder = findAIPlayer(ibDodgeRuntimeHolder, owner.number)
  if ibDodgeAttackerActorHolder is void then
    ibDodgeAttackerActorHolder = integratedMonsterByNumber(ibDodgeRuntimeHolder, owner.number)
  end if
  if ibDodgeAttackerActorHolder is not void and
      ibgaicore.infront(ibDodgeActorHolder, ibDodgeAttackerActorHolder) != true then return false end if
  if ibrandom.unit(ibDodgeRuntimeHolder.randomState) > 0.25 then return false end if
  if ibDodgeActorHolder.enemy is void and ibDodgeAttackerActorHolder is not void then
    ibDodgeActorHolder.enemy = ibDodgeAttackerActorHolder
  end if
  if (ibDodgeActorHolder.className == "monster_soldier_light" or
      ibDodgeActorHolder.className == "monster_soldier" or
      ibDodgeActorHolder.className == "monster_soldier_ss") and
      ibDodgeRuntimeHolder.aiContext.skill > 0 then
    ibDodgeChoiceRoll = ibrandom.unit(ibDodgeRuntimeHolder.randomState)
    if ibattackseq.soldierDodgeUsesAttack(ibDodgeRuntimeHolder.aiContext.skill,
        ibDodgeChoiceRoll) then
      ibDodgeTravelHolder = ibwpvector.subtract(ibDodgeTraceHolder.endPosition, start)
      ibDodgeEta = (ibwpvector.length(ibDodgeTravelHolder) - ibDodgeActorHolder.maxs[0]) / speed
      if ibDodgeEta < 0.0 then ibDodgeEta = 0.0 end if
      ibDodgeActorHolder.info.pauseTime = ibDodgeRuntimeHolder.aiContext.time + ibDodgeEta + 0.3
      ibDodgeActorHolder.activity = "soldier-duck-shoot-pending"
      ibDodgeActorHolder.info.nextFrame = 0
      ibDodgeActorHolder.attackCycles = 0
      return true
    end if
  end if
  return ibmonster.StartReaction(ibDodgeActorHolder, ibDodgePlanHolder, ibDodgeRuntimeHolder.aiContext)
end function

function integratedRandomSigned()
  global activeIntegrationRuntime
  ibRandomRuntimeHolder = activeIntegrationRuntime
  if ibRandomRuntimeHolder is void then return 0.0 end if
  return ibrandom.signed(ibRandomRuntimeHolder.randomState)
end function

function integratedRandomUnit()
  global activeIntegrationRuntime
  ibRandomUnitRuntimeHolder = activeIntegrationRuntime
  if ibRandomUnitRuntimeHolder is void then return 0.0 end if
  return ibrandom.unit(ibRandomUnitRuntimeHolder.randomState)
end function

function integratedRandomInteger()
  global activeIntegrationRuntime
  ibRandomIntegerRuntimeHolder = activeIntegrationRuntime
  if ibRandomIntegerRuntimeHolder is void then return 0 end if
  return ibrandom.nextInteger(ibRandomIntegerRuntimeHolder.randomState)
end function

function integratedRandomIndex(count)
  if count <= 1 then return 0 end if
  index = ibmath.floor(integratedRandomUnit() * count)
  if index >= count then index = count - 1 end if
  return index
end function

function refreshAiRandom(runtime)
  // Stock game AI shares the Win32 CRT rand() stream with weapons. Refresh
  // decision inputs only for an actual monster think, so idle server frames do
  // not consume entropy and save/demo replay remains deterministic.
  runtime.aiContext.randomFrame = ibrandom.nextInteger(runtime.randomState)
  runtime.aiContext.randomAttack = ibrandom.unit(runtime.randomState)
  runtime.aiContext.randomDelay = ibrandom.unit(runtime.randomState)
  runtime.aiContext.randomIdle = ibrandom.unit(runtime.randomState)
  return true
end function

function integratedTurretAcquire(driver, world)
  global activeIntegrationRuntime
  ibTurretRuntimeHolder = activeIntegrationRuntime
  if ibTurretRuntimeHolder is void or ibTurretRuntimeHolder.playerContext is void then return void end if
  for each ibTurretPlayerHolder in ibTurretRuntimeHolder.playerContext.players
    if ibTurretPlayerHolder.edict.inUse and ibTurretPlayerHolder.persistent.connected and
        ibTurretPlayerHolder.health > 0 and ibTurretPlayerHolder.respawn.spectator != true then
      ibTurretProxyHolder = playerWorldProxy(ibTurretPlayerHolder)
      ibTurretProxyHolder.height = ibTurretPlayerHolder.viewHeight
      ibTurretProxyHolder.takeDamage = ibworldconstants.DAMAGE_YES
      return ibTurretProxyHolder
    end if
  end for
  return void
end function

function integratedTurretVisible(driver, enemy, world)
  global activeIntegrationRuntime
  ibTurretRuntimeHolder = activeIntegrationRuntime
  if ibTurretRuntimeHolder is void or ibTurretRuntimeHolder.playerContext is void then return true end if
  ibTurretStartHolder = ibqtypes.Vec3(driver.origin.x, driver.origin.y, driver.origin.z + driver.height)
  ibTurretEndHolder = ibqtypes.Vec3(enemy.origin.x, enemy.origin.y, enemy.origin.z + enemy.height)
  ibTurretPassEdictHolder = void
  if ibTurretRuntimeHolder.exportTable is not void and driver.number >= 0 and
      driver.number < ibTurretRuntimeHolder.exportTable.numEdicts then
    ibTurretPassEdictHolder = ibTurretRuntimeHolder.exportTable.edicts[driver.number]
  end if
  ibTurretTraceHolder = ibTurretRuntimeHolder.playerContext.imports.trace(
    ibTurretStartHolder, ibqtypes.zeroVec3(), ibqtypes.zeroVec3(), ibTurretEndHolder,
    ibTurretPassEdictHolder, ibqconstants.MASK_SHOT)
  if ibTurretTraceHolder.fraction == 1.0 then return true end if
  return ibTurretTraceHolder.entity is not void and ibTurretTraceHolder.entity.state.number == enemy.number
end function

function integratedTurretRandomUnit()
  return integratedRandomUnit()
end function

function integratedTurretSkillValue()
  global activeIntegrationRuntime
  ibTurretSkillRuntimeHolder = activeIntegrationRuntime
  if ibTurretSkillRuntimeHolder is void then return void end if
  return ibTurretSkillRuntimeHolder.aiContext.skill
end function

function integratedTurretFire(attacker, start, direction, damage, speed, splashRadius, world)
  global activeIntegrationRuntime
  ibTurretRuntimeHolder = activeIntegrationRuntime
  if ibTurretRuntimeHolder is void then return false end if
  ibTurretShooterHolder = weaponTargetByNumber(ibTurretRuntimeHolder, attacker.number)
  if ibTurretShooterHolder is void then ibTurretShooterHolder = worldWeaponTarget(attacker) end if
  ibwpprojectiles.fireRocket(ibTurretRuntimeHolder.weaponContext, ibTurretShooterHolder,
    start, direction, damage, speed, splashRadius, damage)
  return true
end function

function integratedTurretPositionedSound(origin, entity, soundName, world)
  global activeIntegrationRuntime
  ibTurretSoundRuntimeHolder = activeIntegrationRuntime
  if ibTurretSoundRuntimeHolder is void or ibTurretSoundRuntimeHolder.playerContext is void or
      ibTurretSoundRuntimeHolder.exportTable is void then return false end if
  if entity.number < 0 or entity.number >= ibTurretSoundRuntimeHolder.exportTable.numEdicts then return false end if
  ibTurretSoundImportsHolder = ibTurretSoundRuntimeHolder.playerContext.imports
  ibTurretSoundEdictHolder = ibTurretSoundRuntimeHolder.exportTable.edicts[entity.number]
  return ibTurretSoundImportsHolder.positionedSound(origin, ibTurretSoundEdictHolder,
    ibgconstants.CHAN_WEAPON, ibTurretSoundImportsHolder.soundIndex(soundName),
    1.0, ibgconstants.ATTN_NORM, 0.0)
end function

function integratedTurretCrushDamage(targetEntity, inflictor, attacker, amount,
    knockback, means, world)
  global activeIntegrationRuntime
  ibTurretCrushRuntimeHolder = activeIntegrationRuntime
  if ibTurretCrushRuntimeHolder is void or targetEntity is void then return false end if
  ibTurretCrushTargetHolder = weaponTargetByNumber(
    ibTurretCrushRuntimeHolder, targetEntity.number)
  if ibTurretCrushTargetHolder is void then return false end if
  ibTurretCrushInflictorHolder = void
  ibTurretCrushAttackerHolder = void
  if inflictor is not void then
    ibTurretCrushInflictorHolder = weaponTargetByNumber(
      ibTurretCrushRuntimeHolder, inflictor.number)
  end if
  if attacker is not void then
    ibTurretCrushAttackerHolder = weaponTargetByNumber(
      ibTurretCrushRuntimeHolder, attacker.number)
  end if
  return ibwpcore.applyDamage(ibTurretCrushRuntimeHolder.weaponContext,
    ibTurretCrushTargetHolder, ibTurretCrushInflictorHolder,
    ibTurretCrushAttackerHolder, ibqtypes.zeroVec3(),
    ibTurretCrushTargetHolder.origin, amount, knockback, 0,
    integratedWorldMeans(means))
end function

function integratedTurretDriverSpawn(driver, world)
  return true
end function

function integratedTurretDriverUse(driver, other, activator, world)
  return true
end function

function integratedTurretDriverDie(driver, inflictor, attacker, damage, point, world)
  global activeIntegrationRuntime
  ibTurretDeathRuntimeHolder = activeIntegrationRuntime
  if ibTurretDeathRuntimeHolder is void then driver.inUse = false; return true end if
  if ibTurretDeathRuntimeHolder.playerContext is not void and
      ibTurretDeathRuntimeHolder.exportTable is not void and driver.number >= 0 and
      driver.number < ibTurretDeathRuntimeHolder.exportTable.numEdicts then
    ibTurretDeathImportsHolder = ibTurretDeathRuntimeHolder.playerContext.imports
    ibTurretDeathEdictHolder = ibTurretDeathRuntimeHolder.exportTable.edicts[driver.number]
    ibTurretDeathImportsHolder.sound(ibTurretDeathEdictHolder,
      ibgconstants.CHAN_VOICE,
      ibTurretDeathImportsHolder.soundIndex("misc/udeath.wav"),
      1.0, ibgconstants.ATTN_NORM, 0.0)
  end if
  ibTurretDeathActorHolder = ibaitypes.createActor(driver.number, "monster_infantry")
  ibTurretDeathActorHolder.edict.state.origin = ibqtypes.Vec3(
    driver.origin.x, driver.origin.y, driver.origin.z)
  ibTurretDeathActorHolder.edict.state.angles = ibqtypes.Vec3(
    driver.angles.x, driver.angles.y, driver.angles.z)
  ibTurretDeathGibResult = ibdeatheffects.emitMonsterGibs(
    ibTurretDeathActorHolder, damage, ibTurretDeathRuntimeHolder.aiContext)
  if ibTurretDeathGibResult is error then return ibTurretDeathGibResult end if
  driver.inUse = false
  driver.solid = ibworldconstants.SOLID_NOT
  driver.takeDamage = ibworldconstants.DAMAGE_NO
  driver.modelIndex = 0
  driver.nextThink = 0.0
  if ibTurretDeathRuntimeHolder.exportTable is not void and driver.number >= 0 and
      driver.number < ibTurretDeathRuntimeHolder.exportTable.numEdicts then
    ibTurretDeathRuntimeHolder.exportTable.edicts[driver.number].inUse = false
  end if
  return true
end function

function integratedTurretControl()
  ibTurretCallbacksHolder = ibturrettypes.defaultTurretCallbacks()
  ibTurretCallbacksHolder.acquireTarget = integratedTurretAcquire
  ibTurretCallbacksHolder.traceVisible = integratedTurretVisible
  ibTurretCallbacksHolder.randomUnit = integratedTurretRandomUnit
  ibTurretCallbacksHolder.skillValue = integratedTurretSkillValue
  ibTurretCallbacksHolder.fireRocket = integratedTurretFire
  ibTurretCallbacksHolder.positionedSound = integratedTurretPositionedSound
  ibTurretCallbacksHolder.crushDamage = integratedTurretCrushDamage
  ibTurretCallbacksHolder.driverSpawn = integratedTurretDriverSpawn
  ibTurretCallbacksHolder.driverUse = integratedTurretDriverUse
  ibTurretCallbacksHolder.driverDie = integratedTurretDriverDie
  return ibturrettypes.createTurretControl(ibTurretCallbacksHolder, 1.0)
end function

function installTurretRigs(runtime)
  ibTurretRigCount = 0
  for each ibTurretBreachHolder in runtime.world.entities
    if ibTurretBreachHolder.inUse and ibTurretBreachHolder.className == "turret_breach" then
      ibTurretControlHolder = integratedTurretControl()
      ibTurretRawMinimumsHolder = ibTurretBreachHolder.moveInfo.startAngles
      ibTurretRawMaximumsHolder = ibTurretBreachHolder.moveInfo.endAngles
      ibTurretLimitsHolder = ibturrettypes.createTurretLimits(
        ibTurretRawMinimumsHolder.x, ibTurretRawMaximumsHolder.x,
        ibTurretRawMinimumsHolder.y, ibTurretRawMaximumsHolder.y)
      for each ibTurretBaseHolder in runtime.world.entities
        if ibTurretBaseHolder.inUse and ibTurretBaseHolder.className == "turret_base" and
            ibTurretBaseHolder.team == ibTurretBreachHolder.team then
          ibturret.spawnTurretBase(ibTurretBaseHolder, runtime.world, ibTurretControlHolder)
        end if
      end for
      ibturret.spawnTurretBreach(ibTurretBreachHolder, runtime.world, ibTurretControlHolder, ibTurretLimitsHolder)
      for each ibTurretDriverHolder in runtime.world.entities
        if ibTurretDriverHolder.inUse and ibTurretDriverHolder.className == "turret_driver" and
            ibTurretDriverHolder.target == ibTurretBreachHolder.targetName then
          ibturret.spawnTurretDriver(ibTurretDriverHolder, runtime.world, ibTurretControlHolder, false)
        end if
      end for
      ibTurretRigCount = ibTurretRigCount + 1
    end if
  end for
  return ibTurretRigCount
end function

function integratedWeaponCallbacks()
  return ibwptypes.WeaponCallbacks(
    integratedWeaponTrace, integratedWeaponContents, integratedWeaponDamage,
    integratedCanDamage, integratedRadiusTargets, integratedWeaponEffect,
    integratedWeaponSound, integratedWeaponLink, integratedWeaponFree,
    integratedPlayerNoise, integratedDodge, integratedRandomSigned
  )
end function

function installWorldSpawn(entity, world)
  name = entity.className
  if name == "trigger_multiple" then return ibtriggers.spawnMultiple(entity, world) end if
  if name == "trigger_once" then return ibtriggers.spawnOnce(entity, world) end if
  if name == "trigger_relay" then return ibtriggers.spawnRelay(entity, world) end if
  if name == "trigger_always" then return ibtriggers.spawnAlways(entity, world) end if
  if name == "trigger_counter" then return ibtriggers.spawnCounter(entity, world) end if
  if name == "trigger_hurt" then return ibtriggers.spawnHurt(entity, world) end if
  if name == "trigger_push" then return ibtriggers.spawnPush(entity, world) end if
  if name == "trigger_monsterjump" then return ibtriggers.spawnMonsterJump(entity, world) end if
  if name == "trigger_key" then return ibtriggers.spawnKey(entity, world) end if
  if name == "func_button" then return ibmovers.spawnButton(entity, world) end if
  if name == "func_door" then return ibmovers.spawnDoor(entity, world) end if
  if name == "func_water" then return ibmovers.spawnWater(entity, world) end if
  if name == "func_door_secret" then return ibmovers.spawnSecretDoor(entity, world) end if
  if name == "func_door_rotating" then return ibmovers.spawnRotatingDoor(entity, world) end if
  if name == "func_plat" then return ibmovers.spawnPlat(entity, world) end if
  if name == "func_train" then return ibmovers.spawnTrain(entity, world) end if
  if name == "trigger_elevator" then return ibmovers.spawnElevator(entity, world) end if
  if name == "func_timer" then return ibmovers.spawnTimer(entity, world) end if
  if name == "func_clock" then return ibmisc.spawnWorldClock(entity, world) end if
  if name == "func_killbox" then return ibmovers.spawnKillBox(entity, world) end if
  if name == "func_explosive" then return ibmovers.spawnExplosive(entity, world, false) end if
  if name == "func_wall" then return ibmisc.spawnWall(entity, world) end if
  if name == "func_object" then return ibmisc.spawnObject(entity, world) end if
  if name == "func_rotating" then return ibmisc.spawnRotating(entity, world) end if
  if name == "misc_explobox" then return ibmisc.spawnExplobox(entity, world) end if
  if name == "misc_banner" then return ibmisc.spawnBanner(entity, world) end if
  if name == "misc_deadsoldier" then return ibmisc.spawnDeadSoldier(entity, world) end if
  if name == "misc_strogg_ship" then return ibmisc.spawnStroggShip(entity, world) end if
  if name == "misc_gib_head" then return ibmisc.spawnGibHead(entity, world) end if
  if name == "misc_gib_arm" then return ibmisc.spawnGibArm(entity, world) end if
  if name == "misc_gib_leg" then return ibmisc.spawnGibLeg(entity, world) end if
  if name == "misc_teleporter" then return ibmisc.spawnTeleporter(entity, world) end if
  if name == "misc_teleporter_dest" then return ibmisc.spawnTeleporterDestination(entity, world) end if
  if name == "misc_viper" then return ibmisc.spawnViper(entity, world) end if
  if name == "misc_viper_bomb" then return ibmisc.spawnViperBomb(entity, world) end if
  if name == "misc_satellite_dish" then return ibmisc.spawnSatelliteDish(entity, world) end if
  if name == "misc_blackhole" then return ibmisc.spawnBlackHole(entity, world) end if
  if name == "misc_eastertank" then return ibmisc.spawnEasterTank(entity, world) end if
  if name == "misc_easterchick" then return ibmisc.spawnEasterChick(entity, world) end if
  if name == "misc_easterchick2" then return ibmisc.spawnEasterChick2(entity, world) end if
  if name == "light_mine2" then return ibmisc.spawnLightMine2(entity, world) end if
  if name == "info_notnull" then return ibmisc.spawnInfoNotNull(entity, world) end if
  if name == "point_combat" then return ibmisc.spawnPointCombat(entity, world, false) end if
  if name == "target_character" then return ibmisc.spawnTargetCharacter(entity, world) end if
  if name == "target_string" then return ibmisc.spawnTargetString(entity, world) end if
  if name == "light" then return ibmisc.spawnLight(entity, world) end if
  if name == "func_group" then return ibmisc.spawnNull(entity, world) end if
  if name == "target_temp_entity" then return ibtargets.spawnTempEntity(entity, world) end if
  if name == "target_speaker" then return ibtargets.spawnSpeaker(entity, world) end if
  if name == "target_help" then return ibtargets.spawnHelp(entity, world) end if
  if name == "target_secret" then return ibtargets.spawnSecret(entity, world) end if
  if name == "target_goal" then return ibtargets.spawnGoal(entity, world) end if
  if name == "target_explosion" then return ibtargets.spawnExplosion(entity, world) end if
  if name == "target_changelevel" then return ibtargets.spawnChangeLevel(entity, world) end if
  if name == "target_splash" then return ibtargets.spawnSplash(entity, world) end if
  if name == "target_spawner" then return ibtargets.spawnSpawner(entity, world) end if
  if name == "target_blaster" then return ibtargets.spawnBlaster(entity, world) end if
  if name == "target_crosslevel_trigger" then return ibtargets.spawnCrossLevelTrigger(entity, world) end if
  if name == "target_crosslevel_target" then return ibtargets.spawnCrossLevelTarget(entity, world) end if
  if name == "target_laser" then return ibtargets.spawnLaser(entity, world) end if
  if name == "target_earthquake" then return ibtargets.spawnEarthquake(entity, world) end if
  if name == "target_actor" then return ibtargets.spawnTargetActor(entity, world) end if
  if name == "target_lightramp" then return ibtargets.spawnTargetLightRamp(entity, world, false) end if
  return entity
end function

function prepareMonsterRuntimeState(actor)
  if actor.pursuitGoal is void then
    pursuitGoal = ibaitypes.createActor(-2000 - actor.edict.state.number,
      "ai_pursuit_goal")
    pursuitGoal.isMonster = false
    pursuitGoal.isClient = false
    pursuitGoal.viewHeight = 0.0
    actor.pursuitGoal = pursuitGoal
  end if
  if actor.triggerProxy is void then
    actor.triggerProxy = ibwtypes.createEntity(actor.edict.state.number,
      actor.className)
  end if
  return actor
end function

function create(spawnResult)
  global activeIntegrationRuntime
  world = ibworld.createWorld(void)
  world.callbacks.resolveKeyItem = integratedResolveKeyItem
  world.callbacks.hasKeyItem = integratedHasKeyItem
  world.callbacks.consumeKeyItem = integratedConsumeKeyItem
  world.callbacks.actorMessage = integratedActorMessage
  world.callbacks.actorTransition = integratedActorTransition
  world.callbacks.combatPointTransition = integratedCombatPointTransition
  world.callbacks.clockSeconds = integratedClockSeconds
  world.callbacks.setModel = integratedWorldSetModel
  world.callbacks.lightStyle = integratedLightStyle
  world.callbacks.traceLine = integratedWorldLaserTrace
  world.callbacks.laserSparks = integratedWorldLaserSparks
  world.callbacks.earthquake = integratedWorldEarthquake
  world.callbacks.fireBlaster = integratedWorldFireBlaster
  world.callbacks.killBox = integratedWorldKillBox
  world.callbacks.spawnExternal = integratedWorldSpawnExternal
  world.callbacks.randomSigned = integratedRandomSigned
  world.callbacks.randomIndex = integratedRandomIndex
  aiContext = ibaitypes.defaultContext()
  monsters = []
  items = []
  monsterRegistry = ibarchetypes.defaultRegistry()
  itemRegistry = ibitems.stockRegistry()
  for each baseEdict in spawnResult.edicts
    component = baseEdict.component
    archetype = ibarchetypes.find(monsterRegistry, component.className)
    item = ibitemrules.findByClassName(itemRegistry, component.className)
    if archetype is not void then
      actor = ibarchetypes.SpawnMonster(monsterRegistry, component.className, baseEdict.number, aiContext)
      actor.edict.state.origin = copyVector(component.origin)
      actor.edict.state.angles = copyVector(component.angles)
      actor.edict.mins = copyVector(actor.mins)
      actor.edict.maxs = copyVector(actor.maxs)
      ibgametypes.stabilizeEdict(actor.edict)
      actor.spawnFlags = component.spawnFlags
      actor.target = component.target
      actor.targetName = component.targetName
      // Stock m_flyer.c repairs one shipped jail5 entity whose target was
      // authored in the target field instead of targetname.
      if spawnResult.mapName == "jail5" and actor.className == "monster_flyer" and
          actor.edict.state.origin.z == -104.0 then
        actor.targetName = actor.target
        actor.target = ""
      end if
      actor.deathTarget = component.deathTarget
      actor.combatTarget = component.combatTarget
      if component.health != 0 then actor.health = component.health; actor.maxHealth = component.health end if
      if component.mass != 0 then actor.mass = component.mass end if
      if component.spawnTemp.item != "" then actor.item = ibitemrules.findByPickupName(itemRegistry, component.spawnTemp.item) end if
      monsters = monsters + [actor]
    else if item is not void then
      itemEntity = ibgtypes.createItemEntity(baseEdict.number, item)
      itemEntity.edict.state.origin = copyVector(component.origin)
      itemEntity.edict.mins = ibqtypes.Vec3(-15.0, -15.0, -15.0)
      itemEntity.edict.maxs = ibqtypes.Vec3(15.0, 15.0, 15.0)
      ibgametypes.stabilizeEdict(itemEntity.edict)
      itemEntity.edict.solid = ibgconstants.SOLID_TRIGGER
      itemEntity.spawnFlags = component.spawnFlags
      itemEntity.count = component.count
      items = items + [itemEntity]
    else
      entity = worldEntity(baseEdict)
      // Entity zero is the engine-owned world edict and must never be
      // renumbered by the normal dynamic-entity allocator.
      if entity.number == 0 then world.entities = world.entities + [entity]
      else ibworld.addEntity(world, entity) end if
      installWorldSpawn(entity, world)
      // Stock g_target.c fixes the shipped mine3 secret's missing message.
      if spawnResult.mapName == "mine3" and entity.className == "target_secret" and
          entity.origin.x == 280.0 and entity.origin.y == -2048.0 and
          entity.origin.z == -624.0 then
        entity.message = "You have found a secret area."
      end if
    end if
  end for
  weaponContext = ibwpcore.createContext(integratedWeaponCallbacks())
  ibCreateRandomStateHolder = ibrandom.create(1)
  if activeIntegrationRuntime is not void and activeIntegrationRuntime.randomState is not void then
    ibCreateRandomStateHolder = activeIntegrationRuntime.randomState
  end if
  playerTrail = ibaitrail.create(true)
  dynamicSolidEdicts = array(ibqconstants.MAX_EDICTS)
  runtime = IntegratedBaseQ2(world, aiContext, monsters, items, [], weaponContext, void, void,
    ibCreateRandomStateHolder, playerTrail, false, dynamicSolidEdicts, 0, -1, -1)
  activeIntegrationRuntime = runtime
  configureAI(aiContext)
  for each preparedActor in runtime.monsters
    prepareMonsterRuntimeState(preparedActor)
  end for
  installTurretRigs(runtime)
  installPropTargetProxies(runtime)
  ibpusher.assembleTeams(runtime.world)
  // SpawnMonster establishes defaults before the parsed fields are copied.
  // Re-running the generic start boundary applies target/trigger-spawn state.
  for each actor in runtime.monsters
    refreshAiRandom(runtime)
    ibmonster.MonsterStart(actor, aiContext)
    ibmonster.MonsterStartGo(actor, aiContext)
  end for
  return runtime
end function

function containsItemIndex(indexes, value)
  for each index in indexes
    if index == value then return true end if
  end for
  return false
end function

function monsterSecondaryModelName(actor)
  // The rider is entity model 1 and the Jorg chassis is model 2 in m_boss31.c.
  if actor.className == "monster_jorg" then return "models/monsters/boss3/jorg/tris.md2" end if
  return ""
end function

// Keep map startup bounded to the definitions that can actually participate in
// this level. The default Blaster/player model are the only unconditional
// player assets; duplicate item and monster instances reuse engine indices.
function precacheSpawned(runtime, playerContext)
  runtime.playerContext = playerContext
  imports = playerContext.imports
  itemIndexes = []
  blaster = ibitemrules.findByPickupName(playerContext.registry, "Blaster")
  if blaster is not void then
    ibprecache.PrecacheItem(playerContext.registry, blaster, imports)
    itemIndexes = itemIndexes + [blaster.index]
  end if
  imports.modelIndex("players/male/tris.md2")
  imports.soundIndex("weapons/noammo.wav")

  for each itemEntity in runtime.items
    item = itemEntity.item
    if containsItemIndex(itemIndexes, item.index) != true then
      ibprecache.PrecacheItem(playerContext.registry, item, imports)
      itemIndexes = itemIndexes + [item.index]
    end if
    if item.worldModel != "" then imports.setModel(itemEntity.edict, item.worldModel) end if
  end for

  monsterModels = []
  ibPrecacheMonsterPosition = 0
  while ibPrecacheMonsterPosition < len(runtime.monsters)
    ibPrecacheActorHolder = runtime.monsters[ibPrecacheMonsterPosition]
    if ibPrecacheActorHolder.model != "" then
      // Keep the managed actor state authoritative even when a GameImport
      // adapter implements SetModel as an engine-edict side effect.  The
      // explicit index is also the value published into Protocol 34 frames.
      ibPrecacheMonsterModelIndex = imports.modelIndex(ibPrecacheActorHolder.model)
      imports.setModel(ibPrecacheActorHolder.edict, ibPrecacheActorHolder.model)
      ibPrecacheEdictHolder = ibPrecacheActorHolder.edict
      ibPrecacheStateHolder = ibPrecacheEdictHolder.state
      ibPrecacheStateHolder.modelIndex = ibPrecacheMonsterModelIndex
      ibPrecacheEdictHolder.state = ibPrecacheStateHolder
      ibPrecacheActorHolder.edict = ibPrecacheEdictHolder
      runtime.monsters[ibPrecacheMonsterPosition] = ibPrecacheActorHolder
      if containsItemIndex(monsterModels, ibPrecacheMonsterModelIndex) != true then monsterModels = monsterModels + [ibPrecacheMonsterModelIndex] end if
    end if
    ibPrecacheSecondaryName = monsterSecondaryModelName(ibPrecacheActorHolder)
    if ibPrecacheSecondaryName != "" then
      ibPrecacheSecondaryIndex = imports.modelIndex(ibPrecacheSecondaryName)
      ibPrecacheSecondaryEdict = ibPrecacheActorHolder.edict
      ibPrecacheSecondaryState = ibPrecacheSecondaryEdict.state
      ibPrecacheSecondaryState.modelIndex2 = ibPrecacheSecondaryIndex
      ibPrecacheSecondaryEdict.state = ibPrecacheSecondaryState
      ibPrecacheActorHolder.edict = ibPrecacheSecondaryEdict
      runtime.monsters[ibPrecacheMonsterPosition] = ibPrecacheActorHolder
      if containsItemIndex(monsterModels, ibPrecacheSecondaryIndex) != true then monsterModels = monsterModels + [ibPrecacheSecondaryIndex] end if
    end if
    if ibPrecacheActorHolder.className == "monster_commander_body" then
      imports.soundIndex("tank/thud.wav")
      imports.soundIndex("tank/pain.wav")
    end if
    for each ibPrecacheMonsterSoundName in ibaisounds.stockNames(ibPrecacheActorHolder.className)
      imports.soundIndex(ibPrecacheMonsterSoundName)
    end for
    ibPrecacheMonsterLoopName = ibaisounds.loopName(ibPrecacheActorHolder.className)
    if ibPrecacheMonsterLoopName != "" then
      ibPrecacheMonsterLoopEdict = ibPrecacheActorHolder.edict
      ibPrecacheMonsterLoopState = ibPrecacheMonsterLoopEdict.state
      ibPrecacheMonsterLoopState.sound = imports.soundIndex(ibPrecacheMonsterLoopName)
      ibPrecacheMonsterLoopEdict.state = ibPrecacheMonsterLoopState
      ibPrecacheActorHolder.edict = ibPrecacheMonsterLoopEdict
      runtime.monsters[ibPrecacheMonsterPosition] = ibPrecacheActorHolder
    end if
    if ibPrecacheActorHolder.className == "monster_jorg" then
      // m_boss31.c invokes MakronPrecache because the rider is spawned during
      // Jorg's death sequence, after configstring setup has completed.
      for each ibPrecacheMakronSoundName in ibaisounds.stockNames("monster_makron")
        imports.soundIndex(ibPrecacheMakronSoundName)
      end for
    end if
    ibPrecacheMonsterPosition = ibPrecacheMonsterPosition + 1
  end while
  if len(runtime.monsters) > 0 then
    // Every stock death function draws from this bounded shared inventory.
    // Register it during level setup so a later gib never mutates model
    // configstrings in the middle of an unreliable snapshot.
    imports.modelIndex("models/objects/gibs/bone/tris.md2")
    imports.modelIndex("models/objects/gibs/sm_meat/tris.md2")
    imports.modelIndex("models/objects/gibs/head2/tris.md2")
    imports.modelIndex("models/objects/gibs/chest/tris.md2")
    imports.modelIndex("models/objects/gibs/sm_metal/tris.md2")
    imports.modelIndex("models/objects/gibs/gear/tris.md2")
  end if
  worldModels = []
  for each entity in runtime.world.entities
    if entity.inUse and entity.model != "" then
      entity.modelIndex = imports.modelIndex(entity.model)
      if containsItemIndex(worldModels, entity.modelIndex) != true then worldModels = worldModels + [entity.modelIndex] end if
    end if
    // g_func.c / g_target.c sound precache.  World movers keep their stock
    // middle/loop sound in WorldEntity.soundIndex; the client consumes the
    // synchronized EntityState.sound value as an autosound.
    if entity.inUse and (entity.className == "func_door_secret" or
        ((entity.className == "func_door" or
          entity.className == "func_door_rotating") and
          entity.sounds != 1)) then
      imports.soundIndex("doors/dr1_strt.wav")
      entity.soundIndex = imports.soundIndex("doors/dr1_mid.wav")
      imports.soundIndex("doors/dr1_end.wav")
    else if entity.inUse and entity.className == "func_plat" then
      imports.soundIndex("plats/pt1_strt.wav")
      entity.soundIndex = imports.soundIndex("plats/pt1_mid.wav")
      imports.soundIndex("plats/pt1_end.wav")
    else if entity.inUse and entity.className == "func_water" and
        entity.sounds != 0 then
      imports.soundIndex("world/mov_watr.wav")
      imports.soundIndex("world/stp_watr.wav")
    else if entity.inUse and entity.className == "func_button" and
        entity.sounds != 1 then
      entity.soundIndex = imports.soundIndex("switches/butn2.wav")
    else if entity.inUse and entity.className == "func_train" and
        entity.noise != "" then
      entity.soundIndex = imports.soundIndex(entity.noise)
    else if entity.inUse and entity.className == "target_speaker" and
        entity.noise != "" then
      entity.soundIndex = imports.soundIndex(entity.noise)
      if (entity.spawnFlags & 1) != 0 then entity.loopSound = entity.soundIndex end if
    else if entity.inUse and entity.className == "target_earthquake" then
      imports.soundIndex("world/quake.wav")
    else if entity.inUse and entity.className == "misc_teleporter" then
      entity.soundIndex = imports.soundIndex("world/amb10.wav")
      entity.loopSound = entity.soundIndex
    end if
    if entity.inUse and entity.className == "misc_explobox" then
      imports.modelIndex("models/objects/debris1/tris.md2")
      imports.modelIndex("models/objects/debris2/tris.md2")
      imports.modelIndex("models/objects/debris3/tris.md2")
      imports.soundIndex("tank/thud.wav")
      imports.soundIndex("tank/pain.wav")
    else if entity.inUse and entity.className == "misc_deadsoldier" then
      imports.modelIndex("models/objects/gibs/sm_meat/tris.md2")
      imports.modelIndex("models/objects/gibs/head2/tris.md2")
      imports.soundIndex("misc/udeath.wav")
    else if entity.inUse and entity.className == "turret_driver" then
      imports.modelIndex("models/objects/gibs/bone/tris.md2")
      imports.modelIndex("models/objects/gibs/sm_meat/tris.md2")
      imports.modelIndex("models/objects/gibs/head2/tris.md2")
      imports.soundIndex("misc/udeath.wav")
    end if
  end for
  return [len(itemIndexes), len(monsterModels), len(worldModels)]
end function

// Bind managed world components to their engine edicts through setmodel so
// inline brush hull bounds/headnodes become authoritative for movement and
// traces. This must run after configureIntegratedRuntime installed linkEntity.
function bindEngineModelsWithMode(runtime, exportTable, imports, refreshGeometry)
  runtime.exportTable = exportTable
  bound = 0
  for each entity in runtime.world.entities
    if entity.inUse and entity.model != "" and entity.number >= 0 and entity.number < exportTable.numEdicts then
      target = exportTable.edicts[entity.number]
      imports.setModel(target, entity.model)
      entity.modelIndex = target.state.modelIndex
      entity.mins = target.mins
      entity.maxs = target.maxs
      entity.size = target.size
      entity.absoluteMins = target.absoluteMins
      entity.absoluteMaxs = target.absoluteMaxs
      if entity.className == "func_object" then ibmisc.shrinkFuncObjectBounds(entity) end if
      if refreshGeometry and entity.solid == ibworldconstants.SOLID_BSP then ibmovers.refreshBrushGeometry(entity, runtime.world) end if
      bound = bound + 1
    end if
  end for
  return bound
end function

function bindEngineModels(runtime, exportTable, imports)
  return bindEngineModelsWithMode(runtime, exportTable, imports, true)
end function

function bindRestoredEngineModels(runtime, exportTable, imports)
  return bindEngineModelsWithMode(runtime, exportTable, imports, false)
end function

// m_move/g_monster startup is delayed until the GameImport collision bridge
// has the retail BSP and inline models linked. Restores re-establish transient
// ground/water references without altering the persisted transform.
function initializeMonsterMovement(runtime, restoring)
  initializedCount = 0
  for each actor in runtime.monsters
    if ibaiprops.isProp(actor) then
      // boss3_stand and commander_body are scripted model state machines,
      // not locomoting monsters; their authored origins are authoritative.
      actor.movementInitialized = true
    else if actor.edict.inUse and
        (actor.spawnFlags & ibaiconstants.SPAWNFLAG_TRIGGER_SPAWN) == 0 then
      if restoring then
        actor.movementInitialized = true
        if (actor.flags & (ibaiconstants.FL_FLY | ibaiconstants.FL_SWIM)) == 0 then
          ibaimove.M_CheckGround(actor, runtime.aiContext)
        end if
        ibaimove.M_CategorizePosition(actor, runtime.aiContext)
      else
        ibaimove.InitializeActor(actor, runtime.aiContext)
      end if
      initializedCount = initializedCount + 1
    else actor.movementInitialized = true
    end if
  end for
  return initializedCount
end function

function findWorldByNumber(runtime, number)
  return ibworld.findByNumber(runtime.world, number)
end function

function findWorldByClass(runtime, className)
  for each entity in runtime.world.entities
    if entity.inUse and entity.className == className then return entity end if
  end for
  return void
end function

function findItemByNumber(runtime, number)
  for each item in runtime.items
    if item.edict.state.number == number then return item end if
  end for
  return void
end function

function findItemByClass(runtime, className)
  for each item in runtime.items
    if item.item.className == className then return item end if
  end for
  return void
end function

function playerWorldProxy(player)
  proxy = ibwtypes.createEntity(player.edict.state.number, "player")
  proxy.inUse = player.edict.inUse
  proxy.isClient = true
  proxy.origin = player.edict.state.origin
  proxy.angles = player.edict.state.angles
  // PlayerData stores velocity as the PMove-compatible three-element array,
  // while WorldEntity deliberately uses Vec3.  Keep this adapter explicit in
  // both directions so touching a trigger never changes the runtime shape.
  proxy.velocity = weaponVector(player.velocity)
  proxy.health = player.health
  proxy.takeDamage = player.takeDamage
  proxy.flags = player.flags
  proxy.serverFlags = player.edict.serverFlags
  return proxy
end function

function touchWorld(runtime, entity, player)
  if entity is void then return false end if
  proxy = playerWorldProxy(player)
  touched = ibworld.touchEntity(runtime.world, entity, proxy)
  player.edict.state.origin = proxy.origin
  player.edict.state.angles = proxy.angles
  player.velocity = [proxy.velocity.x, proxy.velocity.y, proxy.velocity.z]
  return touched
end function

function touchWorldByNumber(runtime, number, player)
  return touchWorld(runtime, findWorldByNumber(runtime, number), player)
end function

function touchWorldByClass(runtime, className, player)
  return touchWorld(runtime, findWorldByClass(runtime, className), player)
end function

function touchItem(runtime, itemEntity, player, playerContext)
  if itemEntity is void or itemEntity.edict.inUse != true or itemEntity.hidden then return ibgtypes.itemAction(false, "item unavailable", 0) end if
  action = ibpowerups.PickupForPlayerData(itemEntity, player, playerContext)
  staysCoop = playerContext.cooperative and (itemEntity.item.flags & ibgpconstants.IT_STAY_COOP) != 0
  if action.success and itemEntity.hidden != true and (itemEntity.flags & ibgpconstants.FL_RESPAWN) == 0 and staysCoop != true then
    itemEntity.freed = true
    itemEntity.edict.inUse = false
    itemEntity.edict.solid = ibgconstants.SOLID_NOT
  end if
  return action
end function

function touchItemByNumber(runtime, number, player, playerContext)
  return touchItem(runtime, findItemByNumber(runtime, number), player, playerContext)
end function

function boundsOverlap(first, second)
  firstMinX = first.state.origin.x + first.mins.x; firstMaxX = first.state.origin.x + first.maxs.x
  firstMinY = first.state.origin.y + first.mins.y; firstMaxY = first.state.origin.y + first.maxs.y
  firstMinZ = first.state.origin.z + first.mins.z; firstMaxZ = first.state.origin.z + first.maxs.z
  secondMinX = second.state.origin.x + second.mins.x; secondMaxX = second.state.origin.x + second.maxs.x
  secondMinY = second.state.origin.y + second.mins.y; secondMaxY = second.state.origin.y + second.maxs.y
  secondMinZ = second.state.origin.z + second.mins.z; secondMaxZ = second.state.origin.z + second.maxs.z
  return firstMaxX >= secondMinX and firstMinX <= secondMaxX and firstMaxY >= secondMinY and firstMinY <= secondMaxY and firstMaxZ >= secondMinZ and firstMinZ <= secondMaxZ
end function

function touchNearbyItems(runtime, player, playerContext)
  touched = 0
  for each item in runtime.items
    if item.edict.inUse and item.hidden != true and boundsOverlap(player.edict, item.edict) then
      action = touchItem(runtime, item, player, playerContext)
      if action.success then touched = touched + 1 end if
    end if
  end for
  return touched
end function

function touchEdict(runtime, edict, player, playerContext)
  if edict is void then return false end if
  item = findItemByNumber(runtime, edict.state.number)
  if item is not void then
    action = touchItem(runtime, item, player, playerContext)
    return action.success
  end if
  return touchWorldByNumber(runtime, edict.state.number, player)
end function

function findAIPlayer(runtime, number)
  for each actor in runtime.aiPlayers
    if actor.edict.state.number == number then return actor end if
  end for
  return void
end function

function syncPlayers(runtime, playerContext)
  runtime.playerContext = playerContext
  runtime.collisionWorldReady = playerContext.imports.collisionWorldReady()
  runtime.weaponContext.deathmatch = playerContext.deathmatch
  runtime.playerTrail.active = not playerContext.deathmatch
  sightClient = void
  for each player in playerContext.players
    actor = findAIPlayer(runtime, player.edict.state.number)
    if actor is void then
      actor = ibaitypes.createClientTarget(player.edict.state.number)
      runtime.aiPlayers = runtime.aiPlayers + [actor]
    end if
    actor.edict = player.edict
    actor.health = player.health
    actor.maxHealth = player.maxHealth
    actor.viewHeight = player.viewHeight
    actor.flags = player.flags
    actor.areaNumber = player.edict.areaNumber
    actor.lightLevel = player.lightLevel
    if actor.lightLevel <= 5 then actor.lightLevel = 128 end if
    actor.isClient = true
    actor.isMonster = false
    if sightClient is void and player.edict.inUse and player.persistent.connected and player.health > 0 and player.respawn.spectator != true then sightClient = actor end if
  end for
  runtime.aiContext.sightClient = sightClient
  return len(runtime.aiPlayers)
end function

function updatePlayerTrail(runtime, playerContext)
  if runtime.playerTrail.active != true then return 0 end if
  lastSpot = ibaitrail.LastSpot(runtime.playerTrail)
  if lastSpot is void then return 0 end if
  added = 0
  for each player in playerContext.players
    if player.edict.inUse and player.persistent.connected and player.health > 0 and
        player.respawn.spectator != true then
      actor = findAIPlayer(runtime, player.edict.state.number)
      if actor is not void and aiVisible(actor, lastSpot) != true then
        if ibaitrail.Add(runtime.playerTrail, player.edict.state.oldOrigin,
            runtime.world.time) then added = added + 1 end if
      end if
    end if
  end for
  return added
end function

function playerForGameplay(runtime, gameplayPlayer)
  if runtime.playerContext is void then return void end if
  for each player in runtime.playerContext.players
    if player.gameplay.edict.state.number == gameplayPlayer.edict.state.number then return player end if
  end for
  return void
end function

function setPlayerGameplayGunFrame(gameplayPlayer, frame)
  gameplayPlayer.gunFrame = frame
  gameplayPlayer.edict.client.playerState.gunFrame = frame
  return frame
end function

function playerMuzzleForAngles(player, item, gunFrame, shotIndex, angles)
  ibPlayerMuzzleAnglesHolder = angles
  ibPlayerMuzzleBasisHolder = ibwpvector.angleVectors(ibPlayerMuzzleAnglesHolder)
  ibPlayerMuzzleForwardHolder = ibPlayerMuzzleBasisHolder[0]
  ibPlayerMuzzleRightHolder = ibPlayerMuzzleBasisHolder[1]
  ibPlayerMuzzleOriginHolder = weaponVector(player.edict.state.origin)
  ibPlayerMuzzleForwardOffset = 0.0
  ibPlayerMuzzleLateralOffset = 8.0
  ibPlayerMuzzleVerticalOffset = player.viewHeight - 8.0
  if item.className == "weapon_blaster" then ibPlayerMuzzleForwardOffset = 24.0
  else if item.className == "weapon_hyperblaster" then
    ibPlayerMuzzleRotation = (gunFrame - 5) * 3.141592653589793 / 3.0
    ibPlayerMuzzleForwardOffset = 24.0 - 4.0 * ibmath.sin(ibPlayerMuzzleRotation)
    ibPlayerMuzzleVerticalOffset = ibPlayerMuzzleVerticalOffset + 4.0 * ibmath.cos(ibPlayerMuzzleRotation)
  else if item.className == "ammo_grenades" or item.className == "weapon_grenadelauncher" or item.className == "weapon_rocketlauncher" or
      item.className == "weapon_bfg" then ibPlayerMuzzleForwardOffset = 8.0
  else if item.className == "weapon_railgun" then ibPlayerMuzzleLateralOffset = 7.0
  else if item.className == "weapon_chaingun" then ibPlayerMuzzleLateralOffset = 7.0
  end if
  if player.persistent.hand == 1 then ibPlayerMuzzleLateralOffset = -ibPlayerMuzzleLateralOffset
  else if player.persistent.hand == 2 then ibPlayerMuzzleLateralOffset = 0.0
  end if
  ibPlayerMuzzleStartHolder = ibwpvector.multiplyAdd(ibPlayerMuzzleOriginHolder,
    ibPlayerMuzzleForwardOffset, ibPlayerMuzzleForwardHolder)
  ibPlayerMuzzleStartHolder = ibwpvector.multiplyAdd(ibPlayerMuzzleStartHolder,
    ibPlayerMuzzleLateralOffset, ibPlayerMuzzleRightHolder)
  ibPlayerMuzzleStartHolder.z = ibPlayerMuzzleStartHolder.z + ibPlayerMuzzleVerticalOffset
  return [ibPlayerMuzzleStartHolder, ibPlayerMuzzleForwardHolder, ibPlayerMuzzleRightHolder]
end function

function playerMuzzle(player, item, gunFrame, shotIndex)
  ibPlayerMuzzleViewAnglesHolder = player.edict.client.playerState.viewAngles
  return playerMuzzleForAngles(player, item, gunFrame, shotIndex, ibPlayerMuzzleViewAnglesHolder)
end function

function playerChaingunMuzzle(player)
  ibChainMuzzleAnglesHolder = player.edict.client.playerState.viewAngles
  ibChainMuzzleBasisHolder = ibwpvector.angleVectors(ibChainMuzzleAnglesHolder)
  ibChainMuzzleForwardHolder = ibChainMuzzleBasisHolder[0]
  ibChainMuzzleRightHolder = ibChainMuzzleBasisHolder[1]
  ibChainMuzzleOriginHolder = weaponVector(player.edict.state.origin)
  ibChainMuzzleLateral = 7.0 + integratedRandomSigned() * 4.0
  ibChainMuzzleVertical = player.viewHeight - 8.0 + integratedRandomSigned() * 4.0
  if player.persistent.hand == 1 then ibChainMuzzleLateral = -ibChainMuzzleLateral
  else if player.persistent.hand == 2 then ibChainMuzzleLateral = 0.0
  end if
  ibChainMuzzleStartHolder = ibwpvector.multiplyAdd(ibChainMuzzleOriginHolder,
    ibChainMuzzleLateral, ibChainMuzzleRightHolder)
  ibChainMuzzleStartHolder.z = ibChainMuzzleStartHolder.z + ibChainMuzzleVertical
  return [ibChainMuzzleStartHolder, ibChainMuzzleForwardHolder]
end function

function beginPlayerAttackAnimation(player)
  player.view.animPriority = ibplayerconstants.ANIM_ATTACK
  if (player.edict.client.playerState.pmove.flags & ibgconstants.PMF_DUCKED) != 0 then
    player.edict.state.frame = ibplayerconstants.FRAME_CROUCH_ATTACK_FIRST - 1
    player.view.animEnd = ibplayerconstants.FRAME_CROUCH_ATTACK_LAST
  else
    player.edict.state.frame = ibplayerconstants.FRAME_ATTACK_FIRST - 1
    player.view.animEnd = ibplayerconstants.FRAME_ATTACK_LAST
  end if
  return true
end function

function applyPlayerWeaponRecoil(runtime, player, item, direction)
  ibPlayerRecoilOrigin = 0.0
  ibPlayerRecoilPitch = 0.0
  ibPlayerRandomRecoil = false
  if item.className == "weapon_blaster" or item.className == "weapon_hyperblaster" or
      item.className == "weapon_grenadelauncher" or item.className == "weapon_rocketlauncher" then
    ibPlayerRecoilOrigin = 2.0; ibPlayerRecoilPitch = -1.0
  else if item.className == "weapon_shotgun" or item.className == "weapon_supershotgun" then
    ibPlayerRecoilOrigin = 2.0; ibPlayerRecoilPitch = -2.0
  else if item.className == "weapon_railgun" then
    ibPlayerRecoilOrigin = 3.0; ibPlayerRecoilPitch = -3.0
  else if item.className == "weapon_bfg" then ibPlayerRecoilOrigin = 2.0
  else if item.className == "weapon_machinegun" then
    // Machinegun_Fire consumes crandom in y/z origin-angle pairs, followed
    // by x origin.  The x angle is the accumulated single-player climb.
    ibMachineRecoilOriginY = integratedRandomSigned() * 0.35
    ibMachineRecoilAngleY = integratedRandomSigned() * 0.7
    ibMachineRecoilOriginZ = integratedRandomSigned() * 0.35
    ibMachineRecoilAngleZ = integratedRandomSigned() * 0.7
    ibMachineRecoilOriginX = integratedRandomSigned() * 0.35
    if not runtime.playerContext.deathmatch then
      ibPlayerRecoilPitch = player.view.machinegunShots * -1.5
      player.view.machinegunShots = player.view.machinegunShots + 1
      if player.view.machinegunShots > 9 then player.view.machinegunShots = 9 end if
    end if
    player.view.kickOrigin = ibqtypes.Vec3(ibMachineRecoilOriginX,
      ibMachineRecoilOriginY, ibMachineRecoilOriginZ)
    player.view.kickAngles = ibqtypes.Vec3(ibPlayerRecoilPitch,
      ibMachineRecoilAngleY, ibMachineRecoilAngleZ)
    ibPlayerRandomRecoil = true
  else if item.className == "weapon_chaingun" then
    // Chaingun_Fire consumes one origin/angle pair for each axis.
    ibChainRecoilOriginX = integratedRandomSigned() * 0.35
    ibChainRecoilAngleX = integratedRandomSigned() * 0.7
    ibChainRecoilOriginY = integratedRandomSigned() * 0.35
    ibChainRecoilAngleY = integratedRandomSigned() * 0.7
    ibChainRecoilOriginZ = integratedRandomSigned() * 0.35
    ibChainRecoilAngleZ = integratedRandomSigned() * 0.7
    player.view.kickOrigin = ibqtypes.Vec3(ibChainRecoilOriginX,
      ibChainRecoilOriginY, ibChainRecoilOriginZ)
    player.view.kickAngles = ibqtypes.Vec3(ibChainRecoilAngleX,
      ibChainRecoilAngleY, ibChainRecoilAngleZ)
    ibPlayerRandomRecoil = true
  end if
  if not ibPlayerRandomRecoil then
    player.view.kickOrigin = ibwpvector.scale(direction, -ibPlayerRecoilOrigin)
    player.view.kickAngles = ibqtypes.Vec3(ibPlayerRecoilPitch, 0.0, 0.0)
  end if
  if item.className == "weapon_bfg" then
    player.view.damagePitch = -40.0
    player.view.damageRoll = integratedRandomSigned() * 8.0
    player.view.damageTime = runtime.playerContext.time + ibplayerconstants.DAMAGE_TIME
  end if
  return true
end function

function emitPlayerWeaponSound(runtime, player, channel, name, attenuation)
  ibPlayerWeaponSoundImportsHolder = runtime.playerContext.imports
  return ibPlayerWeaponSoundImportsHolder.sound(player.edict, channel,
    ibPlayerWeaponSoundImportsHolder.soundIndex(name), 1.0, attenuation, 0.0)
end function

function playerMuzzleFlashForItem(item, shots)
  if item.className == "weapon_blaster" then return ibwpconstants.MZ_BLASTER end if
  if item.className == "weapon_shotgun" then return ibwpconstants.MZ_SHOTGUN end if
  if item.className == "weapon_supershotgun" then return ibwpconstants.MZ_SSHOTGUN end if
  if item.className == "weapon_machinegun" then return ibwpconstants.MZ_MACHINEGUN end if
  if item.className == "weapon_chaingun" then return ibwpconstants.MZ_CHAINGUN1 + shots - 1 end if
  if item.className == "weapon_grenadelauncher" then return ibwpconstants.MZ_GRENADE end if
  if item.className == "weapon_rocketlauncher" then return ibwpconstants.MZ_ROCKET end if
  if item.className == "weapon_hyperblaster" then return ibwpconstants.MZ_HYPERBLASTER end if
  if item.className == "weapon_railgun" then return ibwpconstants.MZ_RAILGUN end if
  if item.className == "weapon_bfg" then return ibwpconstants.MZ_BFG end if
  return error(9693, "unsupported player muzzleflash weapon " + item.className)
end function

function integratedPlayerMuzzleFlash(runtime, shooter, item, shots, silenced)
  if runtime.playerContext is void then return false end if
  encoded = playerMuzzleFlashForItem(item, shots)
  if silenced then encoded = encoded | ibwpconstants.MZ_SILENCED end if
  imports = runtime.playerContext.imports
  imports.writeByte(ibqconstants.SVC_MUZZLEFLASH)
  imports.writeShort(shooter.number)
  imports.writeByte(encoded)
  return imports.multicast(shooter.origin, ibgconstants.MULTICAST_PVS)
end function

function playerWeaponShotCount(gameplayPlayer, item, effectiveFrame)
  if item.className != "weapon_chaingun" then return 1 end if
  shots = 1
  if effectiveFrame > 9 and effectiveFrame <= 14 then
    if (gameplayPlayer.buttons & ibgconstants.BUTTON_ATTACK) != 0 then shots = 2 end if
  else if effectiveFrame > 14 then shots = 3
  end if
  if gameplayPlayer.ammoIndex != 0 and gameplayPlayer.inventory.counts[gameplayPlayer.ammoIndex] < shots then
    shots = gameplayPlayer.inventory.counts[gameplayPlayer.ammoIndex]
  end if
  return shots
end function

function integratedPlayerFire(gameplayPlayer, registry)
  global activeIntegrationRuntime
  runtime = activeIntegrationRuntime
  if runtime is void or runtime.playerContext is void then return ibgpweapons.FireCurrentWeapon(gameplayPlayer, registry) end if
  player = playerForGameplay(runtime, gameplayPlayer)
  if player is void or gameplayPlayer.currentWeapon is void then return false end if
  item = gameplayPlayer.currentWeapon
  preFrame = gameplayPlayer.gunFrame
  attackHeld = (gameplayPlayer.buttons & ibgconstants.BUTTON_ATTACK) != 0
  shooter = playerWeaponTarget(player, registry)
  if item.className == "weapon_shotgun" and preFrame == 9 then
    setPlayerGameplayGunFrame(gameplayPlayer, preFrame + 1)
    return true
  end if
  if item.className == "weapon_bfg" and gameplayPlayer.gunFrame == 9 then
    ibBfgWindupSilenced = gameplayPlayer.silencerShots > 0
    integratedPlayerMuzzleFlash(runtime, shooter, item, 1, ibBfgWindupSilenced)
    if not ibBfgWindupSilenced then integratedPlayerNoise(shooter, shooter.origin, 1) end if
    if ibBfgWindupSilenced then gameplayPlayer.silencerShots = gameplayPlayer.silencerShots - 1 end if
    setPlayerGameplayGunFrame(gameplayPlayer, gameplayPlayer.gunFrame + 1)
    return true
  end if
  if item.className == "weapon_bfg" and gameplayPlayer.ammoIndex != 0 and
      gameplayPlayer.inventory.counts[gameplayPlayer.ammoIndex] < item.quantity then
    setPlayerGameplayGunFrame(gameplayPlayer, gameplayPlayer.gunFrame + 1)
    return true
  end if
  if item.className == "weapon_hyperblaster" and not attackHeld then
    setPlayerGameplayGunFrame(gameplayPlayer, preFrame + 1)
    if gameplayPlayer.gunFrame == 12 then
      player.view.weaponSound = 0
      emitPlayerWeaponSound(runtime, player, ibgconstants.CHAN_AUTO, "weapons/hyprbd1a.wav", ibgconstants.ATTN_NORM)
    end if
    return true
  end if
  if item.className == "weapon_machinegun" and not attackHeld then
    player.view.machinegunShots = 0
    setPlayerGameplayGunFrame(gameplayPlayer, preFrame + 1)
    return true
  end if
  if item.className == "weapon_chaingun" and preFrame == 14 and not attackHeld then
    setPlayerGameplayGunFrame(gameplayPlayer, 32)
    player.view.weaponSound = 0
    emitPlayerWeaponSound(runtime, player, ibgconstants.CHAN_AUTO, "weapons/chngnd1a.wav", ibgconstants.ATTN_IDLE)
    return true
  end if
  effectiveFrame = preFrame + 1
  if item.className == "weapon_chaingun" and preFrame == 21 and attackHeld then effectiveFrame = 15 end if
  shots = playerWeaponShotCount(gameplayPlayer, item, effectiveFrame)
  if shots <= 0 then return false end if
  silenced = gameplayPlayer.silencerShots > 0
  infiniteAmmo = (runtime.playerContext.dmFlags & ibgconstants.DF_INFINITE_AMMO) != 0
  previousAmmo = 0
  if gameplayPlayer.ammoIndex != 0 then previousAmmo = gameplayPlayer.inventory.counts[gameplayPlayer.ammoIndex] end if
  if ibgpweapons.FireCurrentWeapon(gameplayPlayer, registry) != true then return false end if
  if item.className == "weapon_machinegun" then
    if preFrame == 5 then setPlayerGameplayGunFrame(gameplayPlayer, 4)
    else setPlayerGameplayGunFrame(gameplayPlayer, 5)
    end if
  else if item.className == "weapon_chaingun" then setPlayerGameplayGunFrame(gameplayPlayer, effectiveFrame)
  else if item.className == "weapon_hyperblaster" and gameplayPlayer.gunFrame == 12 and
      gameplayPlayer.inventory.counts[gameplayPlayer.ammoIndex] > 0 then
    setPlayerGameplayGunFrame(gameplayPlayer, 6)
  end if
  if not infiniteAmmo and item.className == "weapon_chaingun" and shots > 1 and gameplayPlayer.ammoIndex != 0 then
    gameplayPlayer.inventory.counts[gameplayPlayer.ammoIndex] = gameplayPlayer.inventory.counts[gameplayPlayer.ammoIndex] - (shots - 1)
  end if
  if infiniteAmmo and gameplayPlayer.ammoIndex != 0 then
    gameplayPlayer.inventory.counts[gameplayPlayer.ammoIndex] = previousAmmo
  end if
  muzzle = playerMuzzle(player, item, preFrame, 0)
  start = muzzle[0]
  direction = muzzle[1]
  multiplier = 1
  if player.powerups.quadFrame > runtime.playerContext.frameNumber then multiplier = 4 end if
  if silenced then gameplayPlayer.silencerShots = gameplayPlayer.silencerShots - 1 end if

  applyPlayerWeaponRecoil(runtime, player, item, direction)
  if item.className == "weapon_machinegun" then
    ibMachineFireViewHolder = player.edict.client.playerState.viewAngles
    ibMachineFireAnglesHolder = ibqtypes.Vec3(
      ibMachineFireViewHolder.x + player.view.kickAngles.x,
      ibMachineFireViewHolder.y + player.view.kickAngles.y,
      ibMachineFireViewHolder.z + player.view.kickAngles.z)
    ibMachineFireMuzzleHolder = playerMuzzleForAngles(player, item, preFrame, 0,
      ibMachineFireAnglesHolder)
    start = ibMachineFireMuzzleHolder[0]
    direction = ibMachineFireMuzzleHolder[1]
  end if
  beginPlayerAttackAnimation(player)
  if item.className == "weapon_blaster" then
    ibBlasterDamage = 10
    if runtime.playerContext.deathmatch then ibBlasterDamage = 15 end if
    ibwpprojectiles.fireBlaster(runtime.weaponContext, shooter, start, direction, ibBlasterDamage * multiplier, 1000.0, ibwpconstants.EF_BLASTER, false)
  else if item.className == "weapon_shotgun" then ibwphitscan.fireShotgun(runtime.weaponContext, shooter, start, direction, 4 * multiplier, 8, 500.0, 500.0, 12, ibgpconstants.MOD_SHOTGUN)
  else if item.className == "weapon_supershotgun" then
    ibSuperAnglesLeftHolder = ibqtypes.Vec3(player.edict.client.playerState.viewAngles.x,
      player.edict.client.playerState.viewAngles.y - 5.0, player.edict.client.playerState.viewAngles.z)
    ibSuperDirectionLeftHolder = ibwpvector.angleVectors(ibSuperAnglesLeftHolder)[0]
    ibwphitscan.fireShotgun(runtime.weaponContext, shooter, start, ibSuperDirectionLeftHolder,
      6 * multiplier, 12 * multiplier, 1000.0, 500.0, 10, ibgpconstants.MOD_SSHOTGUN)
    ibSuperAnglesRightHolder = ibqtypes.Vec3(player.edict.client.playerState.viewAngles.x,
      player.edict.client.playerState.viewAngles.y + 5.0, player.edict.client.playerState.viewAngles.z)
    ibSuperDirectionRightHolder = ibwpvector.angleVectors(ibSuperAnglesRightHolder)[0]
    ibwphitscan.fireShotgun(runtime.weaponContext, shooter, start, ibSuperDirectionRightHolder,
      6 * multiplier, 12 * multiplier, 1000.0, 500.0, 10, ibgpconstants.MOD_SSHOTGUN)
  else if item.className == "weapon_machinegun" then ibwphitscan.fireBullet(runtime.weaponContext, shooter, start, direction, 8 * multiplier, 2, 300.0, 500.0, ibgpconstants.MOD_MACHINEGUN)
  else if item.className == "weapon_chaingun" then
    ibChainDamage = 8
    if runtime.playerContext.deathmatch then ibChainDamage = 6 end if
    shot = 0
    while shot < shots
      ibChainShotMuzzleHolder = playerChaingunMuzzle(player)
      start = ibChainShotMuzzleHolder[0]
      direction = ibChainShotMuzzleHolder[1]
      ibwphitscan.fireBullet(runtime.weaponContext, shooter, start, direction,
        ibChainDamage * multiplier, 2 * multiplier, 300.0, 500.0,
        ibgpconstants.MOD_CHAINGUN)
      shot = shot + 1
    end while
  else if item.className == "weapon_grenadelauncher" then ibwpprojectiles.fireGrenade(runtime.weaponContext, shooter, start, direction, 120 * multiplier, 600.0, 2.5, 160.0)
  else if item.className == "weapon_rocketlauncher" then
    ibRocketDamage = 100 + ibmath.floor(integratedRandomUnit() * 20.0)
    ibwpprojectiles.fireRocket(runtime.weaponContext, shooter, start, direction,
      ibRocketDamage * multiplier, 650.0, 120.0, 120 * multiplier)
  else if item.className == "weapon_hyperblaster" then
    ibHyperDamage = 20; if runtime.playerContext.deathmatch then ibHyperDamage = 15 end if
    ibHyperEffect = 0
    if preFrame == 6 or preFrame == 9 then ibHyperEffect = ibwpconstants.EF_HYPERBLASTER end if
    player.view.weaponSound = runtime.playerContext.imports.soundIndex("weapons/hyprbl1a.wav")
    ibwpprojectiles.fireBlaster(runtime.weaponContext, shooter, start, direction, ibHyperDamage * multiplier, 1000.0, ibHyperEffect, true)
  else if item.className == "weapon_railgun" then
    ibRailDamage = 150; ibRailKick = 250
    if runtime.playerContext.deathmatch then ibRailDamage = 100; ibRailKick = 200 end if
    ibwphitscan.fireRail(runtime.weaponContext, shooter, start, direction, ibRailDamage * multiplier, ibRailKick * multiplier)
  else if item.className == "weapon_bfg" then
    ibBfgDamage = 500; if runtime.playerContext.deathmatch then ibBfgDamage = 200 end if
    ibwpprojectiles.fireBfg(runtime.weaponContext, shooter, start, direction, ibBfgDamage * multiplier, 400.0, 1000.0)
  end if
  if item.className != "weapon_bfg" then integratedPlayerMuzzleFlash(runtime, shooter, item, shots, silenced) end if
  if not silenced then integratedPlayerNoise(shooter, start, 1) end if
  if item.className == "weapon_chaingun" then
    if preFrame == 5 then emitPlayerWeaponSound(runtime, player, ibgconstants.CHAN_AUTO, "weapons/chngnu1a.wav", ibgconstants.ATTN_IDLE) end if
    if gameplayPlayer.gunFrame == 22 then
      player.view.weaponSound = 0
      emitPlayerWeaponSound(runtime, player, ibgconstants.CHAN_AUTO, "weapons/chngnd1a.wav", ibgconstants.ATTN_IDLE)
    else player.view.weaponSound = runtime.playerContext.imports.soundIndex("weapons/chngnl1a.wav")
    end if
  end if
  return true
end function

function thinkPlayerHandGrenade(player, playerContext, runtime, item)
  ibHandGameplayHolder = player.gameplay
  if ibHandGameplayHolder.newWeapon is not void and
      ibHandGameplayHolder.weaponState == ibgpconstants.WEAPON_READY then
    ibgpweapons.ChangeWeapon(ibHandGameplayHolder, playerContext.registry)
    player.handGrenadeState = void
    return true
  end if
  if ibHandGameplayHolder.weaponState == ibgpconstants.WEAPON_ACTIVATING then
    ibHandGameplayHolder.weaponState = ibgpconstants.WEAPON_READY
    setPlayerGameplayGunFrame(ibHandGameplayHolder, 16)
    player.handGrenadeState = void
    return true
  end if
  ibHandOwnerHolder = playerWeaponTarget(player, playerContext.registry)
  if player.handGrenadeState is void then
    ibHandAmmoCount = 0
    if ibHandGameplayHolder.ammoIndex != 0 then
      ibHandAmmoCount = ibHandGameplayHolder.inventory.counts[ibHandGameplayHolder.ammoIndex]
    end if
    player.handGrenadeState = ibwptypes.createHandGrenadeState(ibHandOwnerHolder, ibHandAmmoCount)
    player.handGrenadeState.weaponState = ibHandGameplayHolder.weaponState
    player.handGrenadeState.gunFrame = ibHandGameplayHolder.gunFrame
  end if
  ibHandStateHolder = player.handGrenadeState
  ibHandStateHolder.owner = ibHandOwnerHolder
  ibHandStateHolder.weaponState = ibHandGameplayHolder.weaponState
  ibHandStateHolder.gunFrame = ibHandGameplayHolder.gunFrame
  ibHandStateHolder.buttons = ibHandGameplayHolder.buttons
  ibHandStateHolder.latchedButtons = ibHandGameplayHolder.latchedButtons
  if ibHandGameplayHolder.ammoIndex != 0 then
    ibHandStateHolder.ammo = ibHandGameplayHolder.inventory.counts[ibHandGameplayHolder.ammoIndex]
  end if
  ibHandStateHolder.infiniteAmmo = (playerContext.dmFlags & ibgconstants.DF_INFINITE_AMMO) != 0
  ibHandMuzzleHolder = playerMuzzle(player, item, ibHandStateHolder.gunFrame, 0)
  ibHandPreviousProjectileHolder = ibHandStateHolder.lastProjectile
  ibHandDamage = 125
  if player.powerups.quadFrame > playerContext.frameNumber then ibHandDamage = ibHandDamage * 4 end if
  ibHandResultHolder = ibwphandgrenade.step(runtime.weaponContext, ibHandStateHolder,
    ibHandMuzzleHolder[0], ibHandMuzzleHolder[1], ibHandDamage, 165.0)
  ibHandGameplayHolder.weaponState = ibHandStateHolder.weaponState
  setPlayerGameplayGunFrame(ibHandGameplayHolder, ibHandStateHolder.gunFrame)
  ibHandGameplayHolder.latchedButtons = ibHandStateHolder.latchedButtons
  player.latchedButtons = ibHandStateHolder.latchedButtons
  if ibHandGameplayHolder.ammoIndex != 0 then
    ibHandGameplayHolder.inventory.counts[ibHandGameplayHolder.ammoIndex] = ibHandStateHolder.ammo
  end if
  player.view.weaponSound = 0
  if ibHandStateHolder.weaponSound != "" then
    player.view.weaponSound = playerContext.imports.soundIndex(ibHandStateHolder.weaponSound)
  end if
  if ibHandResultHolder is not void and
      (ibHandPreviousProjectileHolder is void or nativeRawValue(ibHandResultHolder) != nativeRawValue(ibHandPreviousProjectileHolder)) then
    beginPlayerAttackAnimation(player)
  end if
  return true
end function

function thinkPlayerWeapon(player, playerContext)
  global activeIntegrationRuntime
  runtime = activeIntegrationRuntime
  if runtime is void or player.gameplay.currentWeapon is void then return false end if
  runtime.playerContext = playerContext
  runtime.weaponContext.deathmatch = playerContext.deathmatch
  item = player.gameplay.currentWeapon
  if item.className == "ammo_grenades" then
    if item.viewModel != "" then player.edict.client.playerState.gunIndex = playerContext.imports.modelIndex(item.viewModel) end if
    return thinkPlayerHandGrenade(player, playerContext, runtime, item)
  end if
  if item.weaponFrames is void then return false end if
  if item.viewModel != "" then player.edict.client.playerState.gunIndex = playerContext.imports.modelIndex(item.viewModel) end if
  ibPreviousWeaponState = player.gameplay.weaponState
  result = ibgpweapons.Weapon_Generic(player.gameplay, item.weaponFrames, playerContext.registry, integratedPlayerFire, 0)
  if ibPreviousWeaponState == ibgpconstants.WEAPON_READY and result.state == ibgpconstants.WEAPON_FIRING then
    beginPlayerAttackAnimation(player)
  end if
  if result.noAmmo then
    emitPlayerWeaponSound(runtime, player, ibgconstants.CHAN_VOICE, "weapons/noammo.wav", ibgconstants.ATTN_NORM)
  end if
  player.latchedButtons = player.gameplay.latchedButtons
  return result
end function

function monsterAttackSupported(actor)
  return ibaicombat.stockProfile(actor.className) is not void
end function

function monsterProjectedStart(actor, offset)
  basis = ibwpvector.angleVectors(actor.edict.state.angles)
  origin = actor.edict.state.origin
  return ibqtypes.Vec3(
    origin.x + basis[0].x * offset.x + basis[1].x * offset.y,
    origin.y + basis[0].y * offset.x + basis[1].y * offset.y,
    origin.z + basis[0].z * offset.x + basis[1].z * offset.y + offset.z
  )
end function

function monsterMuzzleStart(actor, muzzleFlash)
  if muzzleFlash <= 0 then
    fallback = weaponVector(actor.edict.state.origin)
    fallback.z = fallback.z + actor.viewHeight
    return fallback
  end if
  offset = ibflashoffsets.get(muzzleFlash)
  return monsterProjectedStart(actor, offset)
end function

function monsterEnemyAimPoint(actor, enemy)
  height = actor.enemy.viewHeight
  destination = ibqtypes.Vec3(enemy.origin.x, enemy.origin.y, enemy.origin.z + height)
  return destination
end function

function monsterAttackDirection(actor, attackPlan, eventIndex, start, destination, velocity)
  if attackPlan.name == "gunner-grenade" then
    // The 3.19 FIXME is intentional: all four grenades launch straight along
    // the Gunner's facing vector rather than aiming at the enemy.
    return ibwpvector.angleVectors(actor.edict.state.angles)[0]
  end if
  if attackPlan.name == "infantry-machinegun" or attackPlan.name == "gunner-chain" or
      attackPlan.name == "boss2-machineguns" or attackPlan.name == "jorg-machineguns" then
    destination.x = destination.x - 0.2 * velocity[0]
    destination.y = destination.y - 0.2 * velocity[1]
    destination.z = destination.z - 0.2 * velocity[2]
  end if
  aim = ibwpvector.subtract(destination, start)
  if attackPlan.name == "tank-machinegun" then
    // FRAME_attak406..424 performs the original +40..-32..+40 yaw sweep
    // while the pitch continues to track the enemy.
    modelFrame = ibattackseq.modelFrameAt(attackPlan, attackPlan.frameOffsets[eventIndex])
    aimAngles = ibwpvector.vectorToAngles(aim)
    sweepYaw = actor.edict.state.angles.y
    if modelFrame <= 182 then sweepYaw = sweepYaw - 8.0 * (modelFrame - 178)
    else sweepYaw = sweepYaw + 8.0 * (modelFrame - 186)
    end if
    return ibwpvector.angleVectors(ibqtypes.Vec3(aimAngles.x, sweepYaw, 0.0))[0]
  end if
  if attackPlan.name == "makron-hyperblaster" then
    // m_boss32.c retains the stock two-part horizontal sweep while tracking
    // only the target pitch. Offsets 4..20 are FRAME_attak405..421.
    modelFrame = ibattackseq.modelFrameAt(attackPlan, attackPlan.frameOffsets[eventIndex])
    aimAngles = ibwpvector.vectorToAngles(aim)
    sweepYaw = actor.edict.state.angles.y
    if modelFrame <= 221 then sweepYaw = sweepYaw - 10.0 * (modelFrame - 221)
    else sweepYaw = sweepYaw + 10.0 * (modelFrame - 229)
    end if
    return ibwpvector.angleVectors(ibqtypes.Vec3(aimAngles.x, sweepYaw, 0.0))[0]
  end if
  return ibwpvector.normalized(aim)[0]
end function

function monsterSoldierAttackDirection(randomState, start, destination)
  aim = ibwpvector.subtract(destination, start)
  basis = ibwpvector.angleVectors(ibwpvector.vectorToAngles(aim))
  horizontal = ibrandom.signed(randomState) * 1000.0
  vertical = ibrandom.signed(randomState) * 500.0
  // Algebraically equivalent to the stock 8192-unit endpoint, but scaling
  // before normalisation keeps the MiniLang hot path in a compact float range.
  spread = ibwpvector.multiplyAdd(basis[0], horizontal / 8192.0, basis[1])
  spread = ibwpvector.multiplyAdd(spread, vertical / 8192.0, basis[2])
  return ibwpvector.normalized(spread)[0]
end function

function monsterMuzzleAndDirection(runtime, actor, attackPlan, eventIndex, muzzleFlash)
  sourceFlash = ibattackseq.eventSourceFlash(attackPlan, eventIndex)
  start = monsterMuzzleStart(actor, sourceFlash)
  // These two 3.19 attacks intentionally use private offsets rather than an
  // MZ2 table entry. Preserve G_ProjectSource's forward/right projection.
  if attackPlan.name == "parasite-drain" then
    start = monsterProjectedStart(actor, ibqtypes.Vec3(24.0, 0.0, 6.0))
  else if attackPlan.name == "floater-zap" then
    start = monsterProjectedStart(actor, ibqtypes.Vec3(18.5, -0.9, 10.0))
  end if
  enemy = weaponTargetByNumber(runtime, actor.enemy.edict.state.number)
  if enemy is void then return [start, ibqtypes.Vec3(1.0, 0.0, 0.0)] end if
  destination = monsterEnemyAimPoint(actor, enemy)
  if (attackPlan.name == "makron-rail" or attackPlan.name == "gladiator-rail") and
      actor.attackAimValid then
    destination = ibqtypes.Vec3(actor.attackAim.x, actor.attackAim.y, actor.attackAim.z)
  end if
  direction = ibqtypes.Vec3(1.0, 0.0, 0.0)
  if attackPlan.name == "soldier-light-attack1" or attackPlan.name == "soldier-light-attack2" or
      attackPlan.name == "soldier-shotgun-attack1" or attackPlan.name == "soldier-shotgun-attack2" or
      attackPlan.name == "soldier-ss-machinegun" or attackPlan.name == "soldier-duck-shoot" or
      attackPlan.name == "soldier-run-shoot" then
    direction = monsterSoldierAttackDirection(runtime.randomState, start, destination)
  else
    direction = monsterAttackDirection(actor, attackPlan, eventIndex, start, destination,
      enemy.combatant.velocity)
  end if
  // Floater zap passes its unnormalised origin-to-origin vector to both the
  // spark direction encoder and T_Damage. Parasite damage uses the reverse
  // start-to-end vector from m_parasite.c.
  if attackPlan.name == "floater-zap" then
    direction = ibwpvector.subtract(enemy.origin, actor.edict.state.origin)
  else if attackPlan.name == "parasite-drain" then
    direction = ibwpvector.subtract(start, enemy.origin)
  end if
  return [start, direction]
end function

function parasiteDrainPointOk(start, endPosition)
  delta = ibwpvector.subtract(start, endPosition)
  distanceSquared = delta.x * delta.x + delta.y * delta.y + delta.z * delta.z
  if distanceSquared > 65536.0 then return false end if
  pitch = ibwpvector.vectorToAngles(delta).x
  if pitch < -180.0 then pitch = pitch + 360.0 end if
  return ibmath.abs(pitch) <= 30.0
end function

function parasiteDrainCanDamage(runtime, shooter, enemyTarget, start)
  endPosition = ibqtypes.Vec3(enemyTarget.origin.x, enemyTarget.origin.y, enemyTarget.origin.z)
  if parasiteDrainPointOk(start, endPosition) != true then
    endPosition.z = enemyTarget.origin.z + enemyTarget.maxs.z - 8.0
    if parasiteDrainPointOk(start, endPosition) != true then
      endPosition.z = enemyTarget.origin.z + enemyTarget.mins.z + 8.0
      if parasiteDrainPointOk(start, endPosition) != true then return false end if
    end if
  end if

  // Stock validates the alternate heights but deliberately traces and emits
  // the beam to the enemy origin again.
  endPosition = ibqtypes.Vec3(enemyTarget.origin.x, enemyTarget.origin.y, enemyTarget.origin.z)
  trace = runtime.weaponContext.callbacks.trace(start, ibqtypes.zeroVec3(),
    ibqtypes.zeroVec3(), endPosition, shooter, ibqconstants.MASK_SHOT)
  return trace.entity is not void and trace.entity.number == enemyTarget.number
end function

function monsterMeleeAim(actor, attackPlan, eventIndex)
  side = 0.0
  height = 0.0
  if attackPlan.name == "gladiator-cleaver" or attackPlan.name == "berserk-club" or
      attackPlan.name == "chick-slash" then side = actor.mins[0]
  end if
  if attackPlan.name == "gladiator-cleaver" or attackPlan.name == "berserk-club" then height = -4.0 end if
  if attackPlan.name == "berserk-spike" then height = -24.0 end if
  if attackPlan.name == "chick-slash" then height = 10.0 end if
  if attackPlan.name == "brain-tentacle" or
      (attackPlan.name == "brain-tentacle-claws" and eventIndex == 0) then height = 8.0 end if
  if attackPlan.name == "brain-claws" or
      (attackPlan.name == "brain-tentacle-claws" and eventIndex > 0) then
    side = actor.maxs[0]
    if eventIndex % 2 == 1 then side = actor.mins[0] end if
    height = 8.0
  end if
  if attackPlan.name == "flyer-slashes" or attackPlan.name == "mutant-claws" then
    side = actor.mins[0]
    if eventIndex % 2 == 1 then side = actor.maxs[0] end if
    if attackPlan.name == "mutant-claws" then height = 8.0 end if
  end if
  return ibqtypes.Vec3(80.0, side, height)
end function

function monsterAttackDamageFromState(randomState, attackPlan, eventIndex)
  value = ibattackseq.eventDamage(attackPlan, eventIndex)
  modulus = 0
  base = value
  if attackPlan.name == "berserk-spike" then base = 15; modulus = 6
  else if attackPlan.name == "berserk-club" then base = 5; modulus = 6
  else if attackPlan.name == "gladiator-cleaver" then base = 20; modulus = 5
  else if attackPlan.name == "infantry-punch" then base = 5; modulus = 5
  else if attackPlan.name == "chick-slash" then base = 10; modulus = 6
  else if attackPlan.name == "mutant-claws" then base = 10; modulus = 5
  else if attackPlan.name == "brain-claws" then base = 15; modulus = 5
  else if attackPlan.name == "brain-tentacle" then base = 10; modulus = 5
  else if attackPlan.name == "brain-tentacle-claws" then
    base = 15
    if eventIndex == 0 then base = 10 end if
    modulus = 5
  else if attackPlan.name == "floater-wham" or attackPlan.name == "floater-zap" then
    base = 5; modulus = 6
  end if
  if modulus > 0 then return base + (ibrandom.nextInteger(randomState) % modulus) end if
  return value
end function

function monsterAttackDamage(runtime, attackPlan, eventIndex)
  return monsterAttackDamageFromState(runtime.randomState, attackPlan, eventIndex)
end function

function startMutantJump(runtime, actor)
  basis = ibwpvector.angleVectors(actor.edict.state.angles)
  actor.edict.state.origin.z = actor.edict.state.origin.z + 1.0
  actor.attackAim = ibqtypes.Vec3(basis[0].x * 600.0, basis[0].y * 600.0, 250.0)
  actor.attackAimValid = true
  actor.attackCycles = 0
  actor.info.aiFlags = actor.info.aiFlags | ibaiconstants.AI_DUCKED
  actor.info.attackFinished = runtime.aiContext.time + 3.0
  integratedAISound(actor, "mutant/mutsght1.wav", ibgconstants.CHAN_VOICE, ibgconstants.ATTN_NORM)
  if runtime.playerContext is not void then runtime.playerContext.imports.linkEntity(actor.edict) end if
  return true
end function

function damageMutantJumpTarget(runtime, actor, target, velocity, impactPoint)
  if target is void or target.combatant is void or target.combatant.takeDamage != true then return false end if
  speed = ibwpvector.length(velocity)
  if speed <= 400.0 or actor.attackCycles != 0 then return false end if
  normal = ibwpvector.normalized(velocity)[0]
  damage = 40 + ibmath.floor(ibrandom.unit(runtime.randomState) * 10.0)
  shooter = monsterWeaponTarget(actor)
  actor.attackCycles = 1
  return ibwpcore.applyDamage(runtime.weaponContext, target, shooter, shooter, velocity,
    impactPoint, damage, damage, 0, ibgpconstants.MOD_UNKNOWN)
end function

function advanceMutantJumpPhysics(runtime, actor)
  if actor.activity != "mutant-jump" or actor.attackAimValid != true then return false end if
  start = ibqtypes.Vec3(actor.edict.state.origin.x, actor.edict.state.origin.y,
    actor.edict.state.origin.z)
  velocity = actor.attackAim
  velocity.z = velocity.z - 800.0 * ibattackseq.FRAME_TIME
  finish = ibwpvector.multiplyAdd(start, ibattackseq.FRAME_TIME, velocity)
  shooter = monsterWeaponTarget(actor)
  trace = integratedWeaponTrace(start, weaponVector(actor.edict.mins), weaponVector(actor.edict.maxs),
    finish, shooter, ibqconstants.MASK_MONSTERSOLID)
  actor.edict.state.oldOrigin = start
  actor.edict.state.origin = trace.endPosition
  actor.attackAim = velocity
  if trace.fraction < 1.0 then
    target = trace.entity
    normal = ibwpvector.normalized(velocity)[0]
    impactPoint = ibwpvector.multiplyAdd(actor.edict.state.origin, actor.maxs[0], normal)
    damageMutantJumpTarget(runtime, actor, target, velocity, impactPoint)
    if trace.plane.normal.z > 0.7 or trace.allSolid or trace.startSolid then
      actor.attackAimValid = false
      actor.attackAim = ibqtypes.Vec3(0.0, 0.0, 0.0)
    end if
  end if
  if runtime.playerContext is not void then runtime.playerContext.imports.linkEntity(actor.edict) end if
  return true
end function

function monsterFireHit(runtime, actor, enemyTarget, shooter, attackPlan, eventIndex,
    damage, kick)
  aim = monsterMeleeAim(actor, attackPlan, eventIndex)
  origin = actor.edict.state.origin
  direction = ibwpvector.subtract(enemyTarget.origin, origin)
  range = ibwpvector.length(direction)
  if range > aim.x then return false end if

  if aim.y > actor.mins[0] and aim.y < actor.maxs[0] then
    range = range - enemyTarget.maxs.x
  else if aim.y < 0.0 then aim.y = enemyTarget.mins.x
  else aim.y = enemyTarget.maxs.x
  end if

  // Preserve the original fire_hit trace, including its unnormalised first
  // VectorMA. It answers whether solid geometry blocks the intended victim.
  traceEnd = ibwpvector.multiplyAdd(origin, range, direction)
  trace = runtime.weaponContext.callbacks.trace(origin, ibqtypes.zeroVec3(),
    ibqtypes.zeroVec3(), traceEnd, shooter, ibqconstants.MASK_SHOT)
  hitTarget = trace.entity
  if trace.fraction < 1.0 then
    if hitTarget is void or hitTarget.combatant is void or hitTarget.combatant.takeDamage != true then
      return false
    end if
    if hitTarget.isMonster or hitTarget.isClient then hitTarget = enemyTarget end if
  end if
  if hitTarget is void or hitTarget.combatant is void or hitTarget.combatant.takeDamage != true then
    return false
  end if

  basis = ibwpvector.angleVectors(actor.edict.state.angles)
  point = ibwpvector.multiplyAdd(origin, range, basis[0])
  point = ibwpvector.multiplyAdd(point, aim.y, basis[1])
  point = ibwpvector.multiplyAdd(point, aim.z, basis[2])
  damageDirection = ibwpvector.subtract(point, enemyTarget.origin)
  ibwpcore.applyDamage(runtime.weaponContext, hitTarget, shooter, shooter, damageDirection,
    point, damage, kick / 2, ibgpconstants.DAMAGE_NO_KNOCKBACK, ibplayerconstants.MOD_HIT)

  if hitTarget.isMonster != true and hitTarget.isClient != true then return false end if
  center = ibqtypes.Vec3(
    enemyTarget.origin.x + (enemyTarget.mins.x + enemyTarget.maxs.x) * 0.5,
    enemyTarget.origin.y + (enemyTarget.mins.y + enemyTarget.maxs.y) * 0.5,
    enemyTarget.origin.z + (enemyTarget.mins.z + enemyTarget.maxs.z) * 0.5
  )
  kickDirection = ibwpvector.normalized(ibwpvector.subtract(center, point))[0]
  enemyTarget.combatant.velocity[0] = enemyTarget.combatant.velocity[0] + kick * kickDirection.x
  enemyTarget.combatant.velocity[1] = enemyTarget.combatant.velocity[1] + kick * kickDirection.y
  enemyTarget.combatant.velocity[2] = enemyTarget.combatant.velocity[2] + kick * kickDirection.z
  if enemyTarget.combatant.velocity[2] > 0.0 then
    enemyTarget.combatant.edict.groundEntity = void
    kickedPlayer = integratedPlayerByNumber(runtime, enemyTarget.number)
    if kickedPlayer is not void then kickedPlayer.groundEntity = void end if
    kickedWorld = ibworld.findByNumber(runtime.world, enemyTarget.number)
    if kickedWorld is not void then kickedWorld.groundEntity = void end if
  end if
  return true
end function

function integratedMonsterMuzzleFlash(runtime, actor, muzzleFlash, origin)
  if muzzleFlash == 0 or runtime.playerContext is void then return false end if
  imports = runtime.playerContext.imports
  imports.writeByte(ibqconstants.SVC_MUZZLEFLASH2)
  imports.writeShort(actor.edict.state.number)
  imports.writeByte(muzzleFlash)
  return imports.multicast(origin, ibgconstants.MULTICAST_PVS)
end function

function integratedMonsterDrainBeam(runtime, actor, start, endPosition)
  if runtime.playerContext is void then return false end if
  imports = runtime.playerContext.imports
  imports.writeByte(ibqconstants.SVC_TEMP_ENTITY)
  imports.writeByte(ibwpconstants.TE_PARASITE_ATTACK)
  imports.writeShort(actor.edict.state.number)
  imports.writePosition(start)
  imports.writePosition(endPosition)
  return imports.multicast(start, ibgconstants.MULTICAST_PVS)
end function

function integratedResurrectMonster(runtime, medic, patient)
  if patient is void or patient.edict.inUse != true then return false end if
  patient.spawnFlags = 0
  patient.info.aiFlags = 0
  patient.target = ""
  patient.targetName = ""
  patient.combatTarget = ""
  patient.deathTarget = ""
  patient.owner = medic
  // monster_start randomises the resurrected spawn's first frame with one raw
  // CRT rand() call at this exact callback boundary.
  runtime.aiContext.randomFrame = ibrandom.nextInteger(runtime.randomState)
  ibMedicRespawnResult = ibarchetypes.ReinitializeMonster(patient, runtime.aiContext)
  if ibMedicRespawnResult is error then return ibMedicRespawnResult end if
  patient.owner = void
  if runtime.playerContext is not void then
    ibMedicRespawnImportsHolder = runtime.playerContext.imports
    ibMedicRespawnImportsHolder.setModel(patient.edict, patient.model)
    patient.edict.state.modelIndex = ibMedicRespawnImportsHolder.modelIndex(patient.model)
    ibMedicRespawnImportsHolder.linkEntity(patient.edict)
  end if
  patient.info.aiFlags = patient.info.aiFlags | ibaiconstants.AI_RESURRECTING
  if medic.oldEnemy is not void and medic.oldEnemy.isClient then
    patient.enemy = medic.oldEnemy
    ibgaicore.FoundTarget(patient, runtime.aiContext)
  end if
  return true
end function

function integratedMonsterMedicCable(runtime, medic, cableOffsetIndex)
  patient = medic.enemy
  if patient is void or patient.edict.inUse != true or cableOffsetIndex < 1 or
      cableOffsetIndex >= len(medicCableOffsetX) then return false end if
  ibMedicCableOffsetHolder = ibqtypes.Vec3(medicCableOffsetX[cableOffsetIndex],
    medicCableOffsetY[cableOffsetIndex], medicCableOffsetZ[cableOffsetIndex])
  ibMedicCableStartHolder = monsterProjectedStart(medic, ibMedicCableOffsetHolder)
  ibMedicCableDeltaHolder = ibwpvector.subtract(
    ibMedicCableStartHolder, patient.edict.state.origin)
  if ibwpvector.length(ibMedicCableDeltaHolder) > 256.0 then return false end if
  ibMedicCableAnglesHolder = ibwpvector.vectorToAngles(ibMedicCableDeltaHolder)
  ibMedicCablePitch = ibMedicCableAnglesHolder.x
  if ibMedicCablePitch < -180.0 then ibMedicCablePitch = ibMedicCablePitch + 360.0 end if
  if ibmath.abs(ibMedicCablePitch) > 45.0 then return false end if
  if runtime.playerContext is not void then
    ibMedicCableTraceHolder = runtime.playerContext.imports.trace(
      ibMedicCableStartHolder, ibqtypes.zeroVec3(), ibqtypes.zeroVec3(),
      patient.edict.state.origin, medic.edict, ibqconstants.MASK_SHOT)
    if ibMedicCableTraceHolder.fraction != 1.0 and
        (ibMedicCableTraceHolder.entity is void or
          ibMedicCableTraceHolder.entity.state.number != patient.edict.state.number) then
      return false
    end if
  end if

  if cableOffsetIndex == 1 then
    integratedAISound(patient, "medic/medatck3.wav", ibgconstants.CHAN_AUTO,
      ibgconstants.ATTN_NORM)
    patient.info.aiFlags = patient.info.aiFlags | ibaiconstants.AI_RESURRECTING
  else if cableOffsetIndex == 8 then
    ibMedicResurrectionResult = integratedResurrectMonster(runtime, medic, patient)
    if ibMedicResurrectionResult is error then return ibMedicResurrectionResult end if
  else if cableOffsetIndex == 2 then
    integratedAISound(medic, "medic/medatck4.wav", ibgconstants.CHAN_WEAPON,
      ibgconstants.ATTN_NORM)
  end if

  if runtime.playerContext is void then return true end if
  ibMedicCableBasisHolder = ibwpvector.angleVectors(medic.edict.state.angles)
  ibMedicCableBeamStartHolder = ibwpvector.multiplyAdd(
    ibMedicCableStartHolder, 8.0, ibMedicCableBasisHolder[0])
  ibMedicCableBeamEndHolder = ibqtypes.Vec3(patient.edict.state.origin.x,
    patient.edict.state.origin.y, patient.edict.state.origin.z +
      (patient.edict.mins.z + patient.edict.maxs.z) * 0.5)
  ibMedicCableImportsHolder = runtime.playerContext.imports
  ibMedicCableImportsHolder.writeByte(ibqconstants.SVC_TEMP_ENTITY)
  ibMedicCableImportsHolder.writeByte(ibwpconstants.TE_MEDIC_CABLE_ATTACK)
  ibMedicCableImportsHolder.writeShort(medic.edict.state.number)
  ibMedicCableImportsHolder.writePosition(ibMedicCableBeamStartHolder)
  ibMedicCableImportsHolder.writePosition(ibMedicCableBeamEndHolder)
  return ibMedicCableImportsHolder.multicast(
    medic.edict.state.origin, ibgconstants.MULTICAST_PVS)
end function

function integratedMedicCableEvent(runtime, medic, eventIndex)
  if eventIndex == 0 then
    return integratedAISound(medic, "medic/medatck2.wav", ibgconstants.CHAN_WEAPON,
      ibgconstants.ATTN_NORM)
  end if
  if eventIndex == 10 then
    integratedAISound(medic, "medic/medatck5.wav", ibgconstants.CHAN_WEAPON,
      ibgconstants.ATTN_NORM)
    if medic.enemy is not void then
      medic.enemy.info.aiFlags = medic.enemy.info.aiFlags & ~ibaiconstants.AI_RESURRECTING
    end if
    return true
  end if
  return integratedMonsterMedicCable(runtime, medic, eventIndex)
end function

function fireMonsterAttack(runtime, actor, attackPlan, eventIndex, muzzleFlash)
  if actor.enemy is void or attackPlan is void then return false end if
  muzzle = monsterMuzzleAndDirection(runtime, actor, attackPlan, eventIndex, muzzleFlash)
  start = muzzle[0]
  direction = muzzle[1]
  shooter = monsterWeaponTarget(actor)
  enemyTarget = weaponTargetByNumber(runtime, actor.enemy.edict.state.number)
  if enemyTarget is void then return false end if
  kind = attackPlan.attackKind
  attackDamage = monsterAttackDamage(runtime, attackPlan, eventIndex)
  attackKnockback = ibattackseq.eventKnockback(attackPlan, eventIndex)
  if kind == "melee" and attackPlan.name != "floater-zap" then
    return monsterFireHit(runtime, actor, enemyTarget, shooter, attackPlan, eventIndex,
      attackDamage, attackKnockback)
  end if
  damageKnockback = attackKnockback
  if kind == "melee" or kind == "drain" then
    if kind == "drain" and parasiteDrainCanDamage(runtime, shooter, enemyTarget, start) != true then
      return false
    end if
    damageFlags = 0
    if kind == "drain" then damageFlags = ibgpconstants.DAMAGE_NO_KNOCKBACK end if
    if attackPlan.name == "floater-zap" then
      damageFlags = ibgpconstants.DAMAGE_ENERGY
      ibwpcore.emitEffect(runtime.weaponContext, "splash", start, start, direction, 1, 32)
    end if
    ibwpcore.applyDamage(runtime.weaponContext, enemyTarget, shooter, shooter, direction,
      enemyTarget.origin, attackDamage, damageKnockback, damageFlags, ibgpconstants.MOD_UNKNOWN)
    if kind == "drain" then integratedMonsterDrainBeam(runtime, actor, start, enemyTarget.origin) end if
  else if kind == "blaster" then
    monsterBlasterEffect = ibwpconstants.EF_BLASTER
    if ibattackseq.eventUsesHyperblasterEffect(attackPlan, eventIndex) then
      monsterBlasterEffect = ibwpconstants.EF_HYPERBLASTER
    end if
    ibwpprojectiles.fireBlaster(runtime.weaponContext, shooter, start, direction,
      attackDamage, attackPlan.speed, monsterBlasterEffect, false)
  else if kind == "shotgun" then
    ibwphitscan.fireShotgun(runtime.weaponContext, shooter, start, direction,
      attackDamage, attackKnockback, 500.0, 500.0, attackPlan.count, ibgpconstants.MOD_UNKNOWN)
  else if kind == "bullet" then
    ibwphitscan.fireBullet(runtime.weaponContext, shooter, start, direction,
      attackDamage, attackKnockback, 300.0, 500.0, ibgpconstants.MOD_UNKNOWN)
  else if kind == "grenade" then
    ibwpprojectiles.fireGrenade(runtime.weaponContext, shooter, start, direction,
      attackDamage, attackPlan.speed, 2.5, attackDamage)
  else if kind == "rocket" then
    ibwpprojectiles.fireRocket(runtime.weaponContext, shooter, start, direction,
      attackDamage, attackPlan.speed, attackPlan.splashRadius, attackDamage)
  else if kind == "bfg" then
    ibwpprojectiles.fireBfg(runtime.weaponContext, shooter, start, direction,
      attackDamage, attackPlan.speed, attackPlan.splashRadius)
  else if kind == "rail" then
    ibwphitscan.fireRail(runtime.weaponContext, shooter, start, direction,
      attackDamage, attackKnockback)
  else return error(9698, "unsupported monster combat profile " + kind)
  end if
  integratedMonsterMuzzleFlash(runtime, actor, muzzleFlash, start)
  return true
end function

function activeMonsterAttackPlan(actor)
  return ibattackseq.planByNameCycles(actor.className, actor.activity,
    actor.edict.state.number, actor.attackCount, actor.attackCycles)
end function

function monsterRefireDecisionOffset(attackPlan)
  if attackPlan.name == "soldier-run-shoot" then
    return 13 + (len(attackPlan.frameOffsets) - 1) * 12
  end if
  if attackPlan.name == "soldier-light-attack1" then
    return 5 + (len(attackPlan.frameOffsets) - 1) * 5
  end if
  if attackPlan.name == "soldier-light-attack2" then
    return 7 + (len(attackPlan.frameOffsets) - 1) * 5
  end if
  if attackPlan.name == "soldier-shotgun-attack1" then
    return 8 + (len(attackPlan.frameOffsets) - 1) * 8
  end if
  if attackPlan.name == "soldier-shotgun-attack2" then
    return 14 + (len(attackPlan.frameOffsets) - 1) * 12
  end if
  if attackPlan.name == "tank-blasters-hard" then
    return 16 + ((len(attackPlan.frameOffsets) - 3) / 2) * 6
  end if
  if attackPlan.name == "tank-rockets-hard" then
    return 21 + (len(attackPlan.frameOffsets) / 3) * 9
  end if
  if attackPlan.name == "gunner-chain" then
    return 7 + (len(attackPlan.frameOffsets) / 8) * 8
  end if
  if attackPlan.name == "medic-blaster" and len(attackPlan.frameOffsets) == 2 then return 13 end if
  if attackPlan.name == "chick-rockets" then return 12 + len(attackPlan.frameOffsets) * 14 end if
  if attackPlan.name == "chick-slash" then return 2 + len(attackPlan.frameOffsets) * 9 end if
  if attackPlan.name == "flyer-slashes" then
    return 6 + (len(attackPlan.frameOffsets) / 2) * 12
  end if
  if attackPlan.name == "hover-blasters" then
    return 2 + (len(attackPlan.frameOffsets) / 2) * 3
  end if
  if attackPlan.name == "mutant-claws" then
    return (len(attackPlan.frameOffsets) / 2) * 7 - 1
  end if
  if attackPlan.name == "supertank-machinegun" then
    return (len(attackPlan.frameOffsets) / 6) * 6
  end if
  if attackPlan.name == "jorg-machineguns" then
    return 8 + (len(attackPlan.frameOffsets) / 12) * 6
  end if
  if attackPlan.name == "boss2-machineguns" then
    return 8 + (len(attackPlan.frameOffsets) / 10) * 6
  end if
  return -1
end function

function monsterShouldRefire(runtime, actor, attackPlan)
  if actor.enemy is void or actor.enemy.health <= 0 then return false end if
  refireTarget = weaponTargetByNumber(runtime, actor.enemy.edict.state.number)
  refireShooter = monsterWeaponTarget(actor)
  refireDistance = ibwpvector.length(ibwpvector.subtract(
    actor.enemy.edict.state.origin, actor.edict.state.origin))
  if refireTarget is not void then
    refireDistance = ibwpvector.length(ibwpvector.subtract(refireTarget.origin, refireShooter.origin))
  end if
  if attackPlan.name == "soldier-run-shoot" then
    return runtime.aiContext.skill == 3 and refireDistance >= 500.0
  end if
  if attackPlan.name == "soldier-light-attack1" or
      attackPlan.name == "soldier-light-attack2" or
      attackPlan.name == "soldier-shotgun-attack1" or
      attackPlan.name == "soldier-shotgun-attack2" then
    if runtime.aiContext.skill == 3 and ibrandom.unit(runtime.randomState) < 0.5 then return true end if
    return refireDistance < 80.0
  end if
  if attackPlan.name == "tank-blasters-hard" then
    if runtime.aiContext.visible(actor, actor.enemy) != true then return false end if
    return ibrandom.unit(runtime.randomState) <= 0.6
  end if
  if attackPlan.name == "tank-rockets-hard" then
    if runtime.aiContext.visible(actor, actor.enemy) != true then return false end if
    return ibrandom.unit(runtime.randomState) <= 0.4
  end if
  if attackPlan.name == "gunner-chain" then
    if runtime.aiContext.visible(actor, actor.enemy) != true then return false end if
    return ibrandom.unit(runtime.randomState) <= 0.5
  end if
  if attackPlan.name == "medic-blaster" then
    if runtime.aiContext.visible(actor, actor.enemy) != true then return false end if
    return ibrandom.unit(runtime.randomState) <= 0.95
  end if
  if attackPlan.name == "chick-rockets" then
    if refireDistance < 80.0 or runtime.aiContext.visible(actor, actor.enemy) != true then return false end if
    return ibrandom.unit(runtime.randomState) <= 0.6
  end if
  if attackPlan.name == "chick-slash" then
    if refireDistance >= 80.0 then return false end if
    return ibrandom.unit(runtime.randomState) <= 0.9
  end if
  if attackPlan.name == "flyer-slashes" then
    if refireDistance >= 80.0 then return false end if
    return ibrandom.unit(runtime.randomState) <= 0.8
  end if
  if attackPlan.name == "hover-blasters" then
    if runtime.aiContext.visible(actor, actor.enemy) != true then return false end if
    return ibrandom.unit(runtime.randomState) <= 0.6
  end if
  if attackPlan.name == "mutant-claws" then
    if runtime.aiContext.skill == 3 and ibrandom.unit(runtime.randomState) < 0.5 then return true end if
    return refireDistance < 80.0
  end if
  if attackPlan.name == "supertank-machinegun" then
    if runtime.aiContext.visible(actor, actor.enemy) != true then return false end if
    return ibrandom.unit(runtime.randomState) < 0.9
  end if
  if attackPlan.name == "jorg-machineguns" then
    if runtime.aiContext.visible(actor, actor.enemy) != true then return false end if
    return ibrandom.unit(runtime.randomState) < 0.9
  end if
  if attackPlan.name == "boss2-machineguns" then
    if ibgaicore.infront(actor, actor.enemy) != true then return false end if
    return ibrandom.unit(runtime.randomState) <= 0.7
  end if
  return false
end function

function monsterAttackTimelineOffset(actor, attackPlan, now)
  targetOffset = attackPlan.durationFrames - 1
  if attackPlan.name == "infantry-machinegun" and actor.info.nextFrame == -2 then
    targetOffset = 3
  else if actor.info.nextFrame >= 0 and actor.info.nextFrame < len(attackPlan.frameOffsets) then
    targetOffset = attackPlan.frameOffsets[actor.info.nextFrame]
  else if actor.info.nextFrame >= len(attackPlan.frameOffsets) then
    refireOffset = monsterRefireDecisionOffset(attackPlan)
    if refireOffset >= 0 then targetOffset = refireOffset end if
  end if
  remainingFrames = 0
  remainingTime = actor.info.pauseTime - now
  while remainingTime > 0.00001
    remainingFrames = remainingFrames + 1
    remainingTime = remainingTime - ibattackseq.FRAME_TIME
  end while
  timelineOffset = targetOffset - remainingFrames
  if timelineOffset < 0 then timelineOffset = 0 end if
  if timelineOffset >= attackPlan.durationFrames then timelineOffset = attackPlan.durationFrames - 1 end if
  return timelineOffset
end function

function projectMonsterAttackFrame(runtime, actor, attackPlan)
  timelineOffset = monsterAttackTimelineOffset(actor, attackPlan, runtime.aiContext.time)
  actor.edict.state.frame = ibattackseq.modelFrameAt(attackPlan, timelineOffset)
  return timelineOffset
end function

function applyMonsterAttackMovement(actor, attackPlan, timelineOffset, context)
  movement = ibattackseq.movementDistanceAt(attackPlan, timelineOffset) * actor.info.scale
  movementAi = ibattackseq.movementAiAt(attackPlan, timelineOffset)
  if movementAi == ibattackseq.ATTACK_AI_CHARGE then
    return ibgaicore.ai_charge(actor, movement, context)
  end if
  if movementAi == ibattackseq.ATTACK_AI_MOVE then
    return ibgaicore.ai_move(actor, movement, context)
  end if
  return true
end function

function emitMonsterAttackFrameSound(actor, attackPlan, timelineOffset)
  soundName = ibattackseq.frameSoundAt(attackPlan, timelineOffset)
  if soundName == "" then return false end if
  return integratedAISound(actor, soundName,
    ibattackseq.frameSoundChannelAt(attackPlan, timelineOffset),
    ibattackseq.frameSoundAttenuationAt(attackPlan, timelineOffset))
end function

function emitMonsterAttackEventSound(actor, attackPlan, eventIndex, eventFired)
  soundName = ""
  soundActor = actor
  channel = ibgconstants.CHAN_WEAPON
  name = attackPlan.name
  if name == "gladiator-cleaver" then
    channel = ibgconstants.CHAN_AUTO
    if eventFired then soundName = "gladiator/melee2.wav"
    else soundName = "gladiator/melee3.wav" end if
  else if name == "infantry-punch" and eventFired then soundName = "infantry/melee2.wav"
  else if name == "chick-slash" then soundName = "chick/chkatck3.wav"
  else if name == "flyer-slashes" then soundName = "flyer/flyatck2.wav"
  else if name == "brain-claws" and eventFired then soundName = "brain/melee3.wav"
  else if name == "brain-tentacle" then soundName = "brain/brnatck3.wav"
  else if name == "brain-tentacle-claws" then
    if eventIndex == 0 then soundName = "brain/brnatck3.wav"
    else if eventFired then soundName = "brain/melee3.wav" end if
  else if name == "floater-wham" then soundName = "floater/fltatck3.wav"
  else if name == "floater-zap" then soundName = "floater/fltatck2.wav"
  else if name == "mutant-claws" then
    if eventFired then
      if (eventIndex % 2) == 0 then soundName = "mutant/mutatck2.wav"
      else soundName = "mutant/mutatck3.wav" end if
    else soundName = "mutant/mutatck1.wav" end if
  else if name == "parasite-drain" and eventFired then
    if eventIndex == 0 then
      soundName = "parasite/paratck2.wav"
      soundActor = actor.enemy
      channel = ibgconstants.CHAN_AUTO
    else if eventIndex == 1 then soundName = "parasite/paratck3.wav" end if
  end if
  if soundName == "" or soundActor is void then return false end if
  return integratedAISound(soundActor, soundName, channel, ibgconstants.ATTN_NORM)
end function

function setSoldierDuckAttackBounds(runtime, actor, lowered)
  currentlyLowered = (actor.info.aiFlags & ibaiconstants.AI_DUCKED) != 0
  if lowered == currentlyLowered then return false end if
  if lowered then
    actor.info.aiFlags = actor.info.aiFlags | ibaiconstants.AI_DUCKED
    actor.edict.maxs = ibqtypes.Vec3(actor.maxs[0], actor.maxs[1], actor.maxs[2] - 32.0)
    actor.takeDamage = ibplayerconstants.DAMAGE_YES
  else
    actor.info.aiFlags = actor.info.aiFlags & ~ibaiconstants.AI_DUCKED
    actor.edict.maxs = ibqtypes.Vec3(actor.maxs[0], actor.maxs[1], actor.maxs[2])
    actor.takeDamage = ibplayerconstants.DAMAGE_AIM
  end if
  if runtime.playerContext is not void then runtime.playerContext.imports.linkEntity(actor.edict) end if
  return true
end function

function finishMonsterAttack(runtime, actor, attackPlan, lastFrameOffset)
  remaining = attackPlan.cooldown - lastFrameOffset * ibattackseq.FRAME_TIME
  if remaining < runtime.world.frameTime then remaining = runtime.world.frameTime end if
  actor.activity = "run"
  actor.info.nextFrame = 0
  actor.info.pauseTime = 0.0
  actor.info.attackState = ibaiconstants.AS_STRAIGHT
  actor.info.attackFinished = runtime.aiContext.time + remaining
  actor.attackAimValid = false
  actor.attackCycles = 0
  if attackPlan.name == "soldier-duck-shoot" then
    setSoldierDuckAttackBounds(runtime, actor, false)
  end if
  // C attack mmoves end in the class-specific run callback. Reinstalling the
  // exact locomotion move here prevents a stand pose from surviving an attack
  // that began while the monster was stationary.
  if typeof(actor.info.run) == "function" then actor.info.run(actor, runtime.aiContext) end if
  return true
end function

function advanceMonsterAttack(runtime, actor, attackPlan)
  if actor.enemy is void or
      (actor.enemy.health <= 0 and attackPlan.name != "medic-cable") then
    return finishMonsterAttack(runtime, actor, attackPlan, 0)
  end if
  if attackPlan.name == "medic-cable" and actor.enemy.edict.inUse != true then
    return finishMonsterAttack(runtime, actor, attackPlan, 0)
  end if
  eventIndex = actor.info.nextFrame
  if attackPlan.name == "infantry-machinegun" and eventIndex == -2 then
    if runtime.aiContext.time + 0.00001 < actor.info.pauseTime then return false end if
    actor.edict.state.frame = ibattackseq.modelFrameAt(attackPlan, 3)
    actor.attackCycles = 10 + (ibrandom.nextInteger(runtime.randomState) & 15)
    exactInfantryPlan = activeMonsterAttackPlan(actor)
    actor.info.nextFrame = 0
    actor.info.pauseTime = actor.info.pauseTime +
      (exactInfantryPlan.frameOffsets[0] - 3) * ibattackseq.FRAME_TIME
    return false
  end if
  if attackPlan.name == "soldier-ss-machinegun" and eventIndex == 0 and actor.attackCycles == 0 then
    if runtime.aiContext.time + 0.00001 < actor.info.pauseTime then return false end if
    actor.attackCycles = 3 + (ibrandom.nextInteger(runtime.randomState) % 8)
    attackPlan = activeMonsterAttackPlan(actor)
  end if
  timelineOffset = projectMonsterAttackFrame(runtime, actor, attackPlan)
  if attackPlan.name == "soldier-duck-shoot" then
    setSoldierDuckAttackBounds(runtime, actor, timelineOffset >= 2 and timelineOffset < 10)
  end if
  if attackPlan.name == "makron-rail" and timelineOffset == 7 and not actor.attackAimValid then
    railTarget = weaponTargetByNumber(runtime, actor.enemy.edict.state.number)
    if railTarget is not void then
      railAim = monsterEnemyAimPoint(actor, railTarget)
      actor.attackAim = ibqtypes.Vec3(railAim.x, railAim.y, railAim.z)
      actor.attackAimValid = true
    end if
  end if
  if eventIndex < 0 then
    if runtime.aiContext.time + 0.00001 < actor.info.pauseTime then return false end if
    return finishMonsterAttack(runtime, actor, attackPlan, attackPlan.durationFrames - 1)
  end if
  if eventIndex >= len(attackPlan.frameOffsets) then
    if runtime.aiContext.time + 0.00001 < actor.info.pauseTime then return false end if
    decisionOffset = monsterRefireDecisionOffset(attackPlan)
    if decisionOffset >= 0 then
      if monsterShouldRefire(runtime, actor, attackPlan) then
        previousEventCount = len(attackPlan.frameOffsets)
        actor.attackCycles = actor.attackCycles + 1
        extendedPlan = activeMonsterAttackPlan(actor)
        actor.info.nextFrame = previousEventCount
        nextAttackOffset = extendedPlan.frameOffsets[previousEventCount]
        // Endfunc-driven loops (notably Flyer) install the first frame of the
        // next move on the decision tick even when its first hit comes later.
        // Callback-driven loops map to the same old frame at this offset.
        actor.edict.state.frame = ibattackseq.modelFrameAt(extendedPlan, decisionOffset)
        actor.info.pauseTime = actor.info.pauseTime +
          (nextAttackOffset - decisionOffset) * ibattackseq.FRAME_TIME
        if runtime.aiContext.time + 0.00001 < actor.info.pauseTime then return false end if
        return advanceMonsterAttack(runtime, actor, extendedPlan)
      end if
      postFrames = attackPlan.durationFrames - 1 - decisionOffset
      if postFrames <= 0 then return finishMonsterAttack(runtime, actor, attackPlan, decisionOffset) end if
      actor.info.nextFrame = -1
      actor.info.pauseTime = actor.info.pauseTime + postFrames * ibattackseq.FRAME_TIME
      return false
    end if
    actor.edict.state.frame = ibattackseq.modelFrameAt(attackPlan, attackPlan.durationFrames - 1)
    return finishMonsterAttack(runtime, actor, attackPlan, attackPlan.durationFrames - 1)
  end if
  if runtime.aiContext.time + 0.00001 < actor.info.pauseTime then return false end if
  currentFrameOffset = attackPlan.frameOffsets[eventIndex]
  if attackPlan.name == "mutant-jump" and eventIndex == 1 and actor.attackAimValid then
    // mutant_check_landing keeps nextframe on attack05 until server physics
    // reports a floor. Keep the callback live instead of pre-bounding airtime.
    if runtime.aiContext.time <= actor.info.attackFinished then
      actor.edict.state.frame = ibattackseq.modelFrameAt(attackPlan, currentFrameOffset)
      actor.info.pauseTime = actor.info.pauseTime + ibattackseq.FRAME_TIME
      return false
    end if
    actor.attackAimValid = false
  end if
  fired = false
  while eventIndex < len(attackPlan.frameOffsets) and attackPlan.frameOffsets[eventIndex] == currentFrameOffset
    eventFired = false
    if attackPlan.name == "medic-cable" then
      eventFired = integratedMedicCableEvent(runtime, actor, eventIndex)
    else if attackPlan.name == "mutant-jump" then
      if eventIndex == 0 then eventFired = startMutantJump(runtime, actor)
      else
        actor.info.aiFlags = actor.info.aiFlags & ~ibaiconstants.AI_DUCKED
        actor.info.attackFinished = 0.0
        integratedAISound(actor, "mutant/thud1.wav", ibgconstants.CHAN_WEAPON,
          ibgconstants.ATTN_NORM)
      end if
    else
      eventFired = fireMonsterAttack(runtime, actor, attackPlan, eventIndex,
        attackPlan.muzzleFlashes[eventIndex])
      emitMonsterAttackEventSound(actor, attackPlan, eventIndex, eventFired)
    end if
    if eventFired is error then return eventFired end if
    if eventFired then fired = true end if
    if attackPlan.name == "brain-tentacle" and eventIndex == 0 and eventFired and
        runtime.aiContext.skill > 0 then
      // brain_tentacle_attack marks the successful hit; brain_chest_closed on
      // attack211 then changes directly to attack1 instead of finishing attack2.
      actor.activity = "brain-tentacle-claws"
      attackPlan = activeMonsterAttackPlan(actor)
    end if
    eventIndex = eventIndex + 1
  end while
  actor.info.nextFrame = eventIndex
  if eventIndex >= len(attackPlan.frameOffsets) then
    tailTargetOffset = monsterRefireDecisionOffset(attackPlan)
    if tailTargetOffset < 0 then tailTargetOffset = attackPlan.durationFrames - 1 end if
    tailFrames = tailTargetOffset - currentFrameOffset
    if tailFrames <= 0 then finishMonsterAttack(runtime, actor, attackPlan, currentFrameOffset)
    else actor.info.pauseTime = actor.info.pauseTime + tailFrames * ibattackseq.FRAME_TIME
    end if
  else
    frameDelta = attackPlan.frameOffsets[eventIndex] - currentFrameOffset
    actor.info.pauseTime = actor.info.pauseTime + frameDelta * ibattackseq.FRAME_TIME
  end if
  return fired
end function

function beginMonsterAttack(runtime, actor, attackPlan)
  ibattackseq.validatePlan(attackPlan)
  actor.activity = attackPlan.name
  actor.attackAimValid = false
  actor.attackCycles = 0
  if attackPlan.name == "soldier-light-attack1" or attackPlan.name == "soldier-light-attack2" or
      attackPlan.name == "soldier-shotgun-attack1" or attackPlan.name == "soldier-shotgun-attack2" or
      attackPlan.name == "soldier-run-shoot" or
      attackPlan.name == "tank-blasters-hard" or attackPlan.name == "tank-rockets-hard" or
      attackPlan.name == "gunner-chain" or attackPlan.name == "chick-rockets" or
      attackPlan.name == "chick-slash" or attackPlan.name == "flyer-slashes" or
      attackPlan.name == "hover-blasters" or attackPlan.name == "mutant-claws" or
      attackPlan.name == "supertank-machinegun" or attackPlan.name == "jorg-machineguns" or
      attackPlan.name == "boss2-machineguns" then
    actor.attackCycles = 1
  end if
  actor.info.nextFrame = 0
  actor.info.attackState = ibaiconstants.AS_MISSILE
  actor.info.pauseTime = runtime.aiContext.time + attackPlan.frameOffsets[0] * ibattackseq.FRAME_TIME
  if attackPlan.name == "gladiator-rail" then
    gladiatorTarget = weaponTargetByNumber(runtime, actor.enemy.edict.state.number)
    if gladiatorTarget is not void then
      gladiatorAim = monsterEnemyAimPoint(actor, gladiatorTarget)
      actor.attackAim = ibqtypes.Vec3(gladiatorAim.x, gladiatorAim.y, gladiatorAim.z)
      actor.attackAimValid = true
    end if
  end if
  if attackPlan.name == "infantry-machinegun" then
    // infantry_cock_gun runs on FRAME_attak104, seven frames before the first
    // held FRAME_attak111 shot, and consumes the raw rand() shot count there.
    actor.info.nextFrame = -2
    actor.info.pauseTime = runtime.aiContext.time + 3.0 * ibattackseq.FRAME_TIME
  end if
  actor.edict.state.frame = ibattackseq.modelFrameAt(attackPlan, 0)
  applyMonsterAttackMovement(actor, attackPlan, 0, runtime.aiContext)
  emitMonsterAttackFrameSound(actor, attackPlan, 0)
  return advanceMonsterAttack(runtime, actor, attackPlan)
end function

function runMonsterCombat(runtime, actor)
  if actor.health <= 0 or actor.enemy is void or monsterAttackSupported(actor) != true then return false end if
  if ibreactionseq.planByName(actor.className, actor.activity) is not void then return false end if
  if actor.activity == "soldier-run-shoot-pending" then
    return beginMonsterAttack(runtime, actor,
      ibattackseq.soldierRunShootPlanCycles(actor.className, 1))
  end if
  if actor.activity == "soldier-duck-shoot-pending" then
    return beginMonsterAttack(runtime, actor, ibattackseq.soldierDuckShootPlan(actor.className))
  end if
  if actor.activity == "medic-cable-pending" then
    return beginMonsterAttack(runtime, actor, ibattackseq.medicCablePlan())
  end if
  activePlan = activeMonsterAttackPlan(actor)
  if activePlan is not void then
    activeTimelineOffset = monsterAttackTimelineOffset(actor, activePlan, runtime.aiContext.time)
    applyMonsterAttackMovement(actor, activePlan, activeTimelineOffset, runtime.aiContext)
    emitMonsterAttackFrameSound(actor, activePlan, activeTimelineOffset)
    return advanceMonsterAttack(runtime, actor, activePlan)
  end if
  if actor.enemy.health <= 0 or runtime.aiContext.time < actor.info.attackFinished then return false end if
  if runtime.aiContext.visible(actor, actor.enemy) != true then return false end if
  profile = ibaicombat.stockProfile(actor.className)
  target = weaponTargetByNumber(runtime, actor.enemy.edict.state.number)
  if target is void then return false end if
  shooter = monsterWeaponTarget(actor)
  distance = ibwpvector.length(ibwpvector.subtract(target.origin, shooter.origin))
  if distance > profile.maximumRange and actor.className != "monster_mutant" then return false end if
  // ai_run may already have selected AS_MELEE/AS_MISSILE and invoked the
  // callback during this same M_MoveFrame. Consume that pending choice rather
  // than incrementing the class attack counter a second time.
  pendingAiAttack = actor.activity == "attack" or actor.activity == "melee"
  pendingAiMelee = actor.activity == "melee"
  if actor.className == "monster_mutant" and not pendingAiAttack then return false end if
  if not pendingAiAttack then
    if profile.attackKind == "melee" and actor.info.melee is not void then actor.info.melee(actor, runtime.aiContext)
    else if actor.info.attack is not void then actor.info.attack(actor, runtime.aiContext)
    else return false
    end if
  end if
  if actor.className == "monster_gladiator" and not pendingAiMelee and distance <= 112.0 then
    // gladiator_attack intentionally leaves currentmove unchanged inside its
    // 32-unit rail safe zone. Do not turn that no-op into a long-range cleaver.
    if typeof(actor.info.run) == "function" then actor.info.run(actor, runtime.aiContext) end if
    return false
  end if
  selectionUnit = 0.0
  selectionRaw = 0
  selectionKind = ibattackseq.selectionRandomKind(actor.className, distance)
  if selectionKind == 1 then selectionUnit = ibrandom.unit(runtime.randomState)
  else if selectionKind == 2 then selectionRaw = ibrandom.nextInteger(runtime.randomState)
  end if
  attackPlan = void
  if actor.className == "monster_gladiator" then
    if pendingAiMelee or distance < 80.0 then attackPlan = ibattackseq.gladiatorMeleePlan()
    else attackPlan = ibattackseq.gladiatorRailPlan()
    end if
  else if actor.className == "monster_berserk" then
    attackPlan = ibattackseq.berserkPlanWithRaw(selectionRaw)
  else if actor.className == "monster_gunner" then
    attackPlan = ibattackseq.gunnerPlanWithRoll(actor.edict.state.number, actor.attackCount,
      distance, selectionUnit)
  else if actor.className == "monster_soldier_light" or actor.className == "monster_soldier" or
      actor.className == "monster_soldier_ss" then
    attackPlan = ibattackseq.soldierPlanWithRoll(actor.className, actor.edict.state.number,
      actor.attackCount, selectionUnit)
  else if actor.className == "monster_tank" or actor.className == "monster_tank_commander" then
    attackPlan = ibattackseq.tankPlanWithRoll(actor.className, actor.edict.state.number,
      actor.attackCount, distance, runtime.aiContext.skill, selectionUnit)
  else if actor.className == "monster_medic" then
    attackPlan = ibattackseq.medicBlasterPlanContinue(false)
  else if actor.className == "monster_chick" then
    if distance < 80.0 then attackPlan = ibattackseq.chickMeleePlanCycles(1)
    else attackPlan = ibattackseq.chickRocketPlanCycles(1)
    end if
  else if actor.className == "monster_flyer" then
    if distance < 80.0 then attackPlan = ibattackseq.flyerMeleePlanCycles(1)
    else attackPlan = ibattackseq.flyerBlasterPlan()
    end if
  else if actor.className == "monster_brain" then
    attackPlan = ibattackseq.brainPlanWithRoll(runtime.aiContext.skill, selectionUnit)
  else if actor.className == "monster_floater" then
    attackPlan = ibattackseq.floaterPlanWithRoll(distance, selectionUnit)
  else if actor.className == "monster_hover" then
    attackPlan = ibattackseq.hoverBlasterPlanCycles(1)
  else if actor.className == "monster_mutant" then
    if pendingAiMelee or distance < 80.0 then attackPlan = ibattackseq.mutantMeleePlanCycles(1)
    else attackPlan = ibattackseq.mutantJumpPlan()
    end if
  else if actor.className == "monster_supertank" then
    attackPlan = ibattackseq.supertankPlanWithRoll(actor.edict.state.number, actor.attackCount,
      distance, selectionUnit)
  else if actor.className == "monster_jorg" then
    attackPlan = ibattackseq.jorgPlanWithRoll(actor.edict.state.number, actor.attackCount, selectionUnit)
  else if actor.className == "monster_boss2" then
    attackPlan = ibattackseq.boss2PlanWithRoll(actor.edict.state.number, actor.attackCount, distance, selectionUnit)
  else if actor.className == "monster_makron" then attackPlan = ibattackseq.makronPlanWithRoll(selectionUnit)
  else attackPlan = ibattackseq.selectPlan(actor.className, actor.edict.state.number,
    actor.attackCount, distance, runtime.aiContext.skill)
  end if
  return beginMonsterAttack(runtime, actor, attackPlan)
end function

function integratedWorldCollisionProxy(runtime, number)
  entity = ibworld.findByNumber(runtime.world, number)
  if entity is not void then return entity end if
  player = integratedPlayerByNumber(runtime, number)
  if player is not void then return playerWorldProxy(player) end if
  actor = integratedMonsterByNumber(runtime, number)
  if actor is not void then
    proxy = actor.triggerProxy
    if proxy is void then proxy = ibwtypes.createEntity(number, actor.className); actor.triggerProxy = proxy end if
    proxy.number = number; proxy.inUse = actor.edict.inUse
    proxy.health = actor.health; proxy.takeDamage = actor.takeDamage
    proxy.flags = actor.flags
    proxy.serverFlags = actor.edict.serverFlags | ibworldconstants.SVF_MONSTER
    return proxy
  end if
  return void
end function

function advanceWorldTossEntities(runtime)
  if runtime.playerContext is void or runtime.exportTable is void then return 0 end if
  moved = 0
  imports = runtime.playerContext.imports
  for each entity in runtime.world.entities
    if entity.inUse and entity.moveType == ibworldconstants.MOVETYPE_TOSS then
      if entity.velocity.z > 0.0 then entity.groundEntity = void end if
      if entity.groundEntity is not void then
        groundInUse = try(entity.groundEntity.inUse)
        if groundInUse == false then entity.groundEntity = void end if
      end if
      if entity.groundEntity is void then
        entity.oldOrigin.x = entity.origin.x
        entity.oldOrigin.y = entity.origin.y
        entity.oldOrigin.z = entity.origin.z
        entity.velocity.z = entity.velocity.z -
          runtime.playerContext.gravity * runtime.world.frameTime
        finish = ibwpvector.multiplyAdd(entity.origin, runtime.world.frameTime,
          entity.velocity)
        passEdict = void
        if entity.number >= 0 and entity.number < runtime.exportTable.numEdicts then
          passEdict = runtime.exportTable.edicts[entity.number]
        end if
        mask = entity.clipMask
        if mask == 0 then mask = ibqconstants.MASK_MONSTERSOLID end if
        trace = imports.trace(entity.origin, entity.mins, entity.maxs,
          finish, passEdict, mask)
        entity.origin.x = trace.endPosition.x
        entity.origin.y = trace.endPosition.y
        entity.origin.z = trace.endPosition.z
        entity.angles.x = entity.angles.x + entity.angularVelocity.x * runtime.world.frameTime
        entity.angles.y = entity.angles.y + entity.angularVelocity.y * runtime.world.frameTime
        entity.angles.z = entity.angles.z + entity.angularVelocity.z * runtime.world.frameTime
        if trace.fraction < 1.0 then
          hit = void
          if trace.entity is not void then
            hit = integratedWorldCollisionProxy(runtime, trace.entity.state.number)
          end if
          entity.moveDirection.x = trace.plane.normal.x
          entity.moveDirection.y = trace.plane.normal.y
          entity.moveDirection.z = trace.plane.normal.z
          if entity.touch is not void then entity.touch(entity, hit, runtime.world) end if
          backoff = entity.velocity.x * trace.plane.normal.x +
            entity.velocity.y * trace.plane.normal.y +
            entity.velocity.z * trace.plane.normal.z
          entity.velocity.x = entity.velocity.x - trace.plane.normal.x * backoff
          entity.velocity.y = entity.velocity.y - trace.plane.normal.y * backoff
          entity.velocity.z = entity.velocity.z - trace.plane.normal.z * backoff
          if trace.plane.normal.z > 0.7 then
            entity.groundEntity = hit
            entity.velocity.x = 0.0; entity.velocity.y = 0.0
            entity.velocity.z = 0.0
            entity.angularVelocity.x = 0.0
            entity.angularVelocity.y = 0.0
            entity.angularVelocity.z = 0.0
          end if
        end if
        runtime.world.callbacks.linkEntity(entity)
        moved = moved + 1
      end if
    end if
  end for
  return moved
end function

function advanceWeaponProjectiles(runtime)
  context = runtime.weaponContext
  context.time = runtime.world.time
  // Stock G_RunEntity runs due thinks before toss/missile physics. This also
  // prevents an expiring grenade from moving one extra frame before exploding.
  ibwpcore.runDueThinks(context)
  for each projectile in context.projectiles
    if projectile.inUse then ibwpprojectiles.advanceProjectile(context, projectile) end if
  end for
  // The C game reuses freed edicts. Managed projectiles are private records,
  // so drop inactive entries after all due thinks instead of retaining every
  // projectile ever fired for the lifetime of the level.
  activeProjectiles = array(len(context.projectiles))
  activeProjectileCount = 0
  for each retainedProjectile in context.projectiles
    if retainedProjectile.inUse then
      activeProjectiles[activeProjectileCount] = retainedProjectile
      activeProjectileCount = activeProjectileCount + 1
    end if
  end for
  context.projectiles = compactIntegratedValues(activeProjectiles, activeProjectileCount)
  return true
end function

function runFrame(runtime)
  pusherState = ibpusher.capture(runtime)
  ibworld.runFrame(runtime.world)
  ibpusher.resolve(runtime, pusherState)
  advanceWorldTossEntities(runtime)
  runtime.aiContext.time = runtime.world.time
  runtime.weaponContext.time = runtime.world.time
  runtime.aiContext.frameNumber = runtime.aiContext.frameNumber + 1
  for each actor in runtime.monsters
    actor.areaNumber = actor.edict.areaNumber
    advanceMutantJumpPhysics(runtime, actor)
    if actor.nextThink > 0.0 and actor.nextThink <= runtime.aiContext.time then
      refreshAiRandom(runtime)
      ibmonster.MonsterThink(actor, runtime.aiContext)
    end if
    runMonsterCombat(runtime, actor)
  end for
  advanceWeaponProjectiles(runtime)
  for each item in runtime.items
    if item.decaying != true and item.hidden and item.nextThink > 0.0 and item.nextThink <= runtime.world.time then
      // DoRespawn is deterministic and does not require a player/context.
      ibitemrules.DoRespawn(item, runtime.world.time)
    end if
  end for
end function

function runPlayerGameplayFrame(runtime, playerContext)
  pickupContext = ibgtypes.pickupContext(playerContext.deathmatch, playerContext.cooperative, playerContext.dmFlags, playerContext.time)
  pickupContext.skill = runtime.aiContext.skill
  pickupContext.frameNumber = playerContext.frameNumber
  for each item in runtime.items
    if item.decaying and item.nextThink <= playerContext.time then
      owner = item.owner
      ibpowerups.MegaHealthThink(item, pickupContext)
      if owner is not void then
        for each player in playerContext.players
          if nativeRawValue(player.gameplay) == nativeRawValue(owner) then ibpowerups.SyncToPlayerData(player.gameplay, player) end if
        end for
      end if
    end if
  end for
  updatePlayerTrail(runtime, playerContext)
  return true
end function

function damageMonster(runtime, monsterIndex, attacker, damage)
  if typeof(monsterIndex) != "int" or monsterIndex < 0 or monsterIndex >= len(runtime.monsters) then return error(9690, "damageMonster: monster index out of range") end if
  if typeof(damage) != "int" or damage < 0 then return error(9691, "damageMonster: non-negative integer damage required") end if
  actor = runtime.monsters[monsterIndex]
  if actor.health <= 0 then return false end if
  actor.health = actor.health - damage
  if actor.health <= 0 then return ibmonster.DispatchDie(actor, attacker, damage, runtime.aiContext) end if
  return ibmonster.DispatchPain(actor, attacker, damage, runtime.aiContext)
end function

function damageWorldEntity(runtime, entityNumber, attacker, damage)
  if typeof(entityNumber) != "int" or typeof(damage) != "int" or damage < 0 then return error(9692, "damageWorldEntity: invalid arguments") end if
  entity = ibworld.findByNumber(runtime.world, entityNumber)
  if entity is void then return error(9693, "damageWorldEntity: world entity not found") end if
  return integratedWorldDamage(entity, void, attacker, damage, ibworldconstants.MOD_EXPLOSIVE)
end function

function syncGameEdicts(runtime, exportTable)
  for each entity in runtime.world.entities
    // AI prop target proxies deliberately share the actor's edict number so
    // G_UseTargets can find them.  They are dispatch-only records and must
    // never overwrite the authoritative actor EntityState through the shared
    // export-edict reference.
    if entity.className != "ai_prop_target_proxy" and entity.number >= 0 and entity.number < exportTable.numEdicts then
      ibSyncTargetHolder = exportTable.edicts[entity.number]
      ibSyncStateHolder = ibSyncTargetHolder.state
      ibSyncOriginHolder = entity.origin
      ibSyncAnglesHolder = entity.angles
      ibSyncMinsHolder = entity.mins
      ibSyncMaxsHolder = entity.maxs
      ibSyncTargetHolder.inUse = entity.inUse
      ibSyncStateHolder.origin = ibSyncOriginHolder
      ibSyncStateHolder.angles = ibSyncAnglesHolder
      ibSyncStateHolder.oldOrigin = entity.oldOrigin
      ibSyncTargetHolder.state = ibSyncStateHolder
      ibSyncTargetHolder.state.modelIndex = entity.modelIndex
      ibSyncTargetHolder.state.effects = entity.effects
      ibSyncTargetHolder.state.renderFx = entity.renderFx
      ibSyncTargetHolder.state.frame = entity.frame
      if entity.className == "target_laser" then ibSyncTargetHolder.state.skinNumber = entity.style end if
      ibSyncTargetHolder.state.sound = entity.loopSound
      ibSyncTargetHolder.serverFlags = entity.serverFlags
      ibSyncTargetHolder.solid = entity.solid
      ibSyncTargetHolder.clipMask = entity.clipMask
      ibSyncTargetHolder.mins = ibSyncMinsHolder
      ibSyncTargetHolder.maxs = ibSyncMaxsHolder
      ibgametypes.stabilizeEdict(ibSyncTargetHolder)
    end if
  end for
  for each actor in runtime.monsters
    if actor.edict.state.number < exportTable.numEdicts then
      if actor.edict.state.modelIndex <= 0 and actor.model != "" and runtime.playerContext is not void then
        ibSyncActorStateHolder = actor.edict.state
        ibSyncActorStateHolder.modelIndex = runtime.playerContext.imports.modelIndex(actor.model)
        actor.edict.state = ibSyncActorStateHolder
      end if
      ibSyncSecondaryName = monsterSecondaryModelName(actor)
      if actor.edict.state.modelIndex2 <= 0 and ibSyncSecondaryName != "" and runtime.playerContext is not void then
        ibSyncSecondaryState = actor.edict.state
        ibSyncSecondaryState.modelIndex2 = runtime.playerContext.imports.modelIndex(ibSyncSecondaryName)
        actor.edict.state = ibSyncSecondaryState
      end if
      ibActorEdictHolder = ibgametypes.stabilizeEdict(actor.edict)
      exportTable.edicts[actor.edict.state.number] = ibActorEdictHolder
      ibStoredActorEdictHolder = exportTable.edicts[actor.edict.state.number]
      ibStoredActorEdictHolder.state = ibActorEdictHolder.state
      ibStoredActorEdictHolder.mins = ibActorEdictHolder.mins
      ibStoredActorEdictHolder.maxs = ibActorEdictHolder.maxs
      ibgametypes.stabilizeEdict(ibStoredActorEdictHolder)
    end if
  end for
  for each item in runtime.items
    if item.edict.state.number < exportTable.numEdicts then
      ibItemEdictHolder = ibgametypes.stabilizeEdict(item.edict)
      exportTable.edicts[item.edict.state.number] = ibItemEdictHolder
      ibStoredItemEdictHolder = exportTable.edicts[item.edict.state.number]
      ibStoredItemEdictHolder.state = ibItemEdictHolder.state
      ibStoredItemEdictHolder.mins = ibItemEdictHolder.mins
      ibStoredItemEdictHolder.maxs = ibItemEdictHolder.maxs
      ibgametypes.stabilizeEdict(ibStoredItemEdictHolder)
    end if
  end for
  for each ibSyncProjectileHolder in runtime.weaponContext.projectiles
    if ibSyncProjectileHolder.inUse and ibSyncProjectileHolder.engineNumber >= 0 and
        ibSyncProjectileHolder.engineNumber < exportTable.numEdicts then
      ibSyncProjectileEdictHolder = exportTable.edicts[ibSyncProjectileHolder.engineNumber]
      ibSyncProjectileEdictHolder.inUse = true
      ibSyncProjectileEdictHolder.solid = ibSyncProjectileHolder.solid
      ibSyncProjectileEdictHolder.clipMask = ibSyncProjectileHolder.clipMask
      ibSyncProjectileEdictHolder.state.origin = weaponVector(ibSyncProjectileHolder.origin)
      ibSyncProjectileEdictHolder.state.oldOrigin = weaponVector(ibSyncProjectileHolder.oldOrigin)
      ibSyncProjectileEdictHolder.state.angles = weaponVector(ibSyncProjectileHolder.angles)
      ibSyncProjectileEdictHolder.state.effects = ibSyncProjectileHolder.effects
      ibSyncProjectileEdictHolder.state.frame = ibSyncProjectileHolder.frame
      if runtime.playerContext is not void then
        if ibSyncProjectileHolder.modelName != "" and ibSyncProjectileHolder.modelIndex == 0 then
          ibSyncProjectileHolder.modelIndex = runtime.playerContext.imports.modelIndex(
            ibSyncProjectileHolder.modelName)
        end if
        if ibSyncProjectileHolder.soundName != "" and ibSyncProjectileHolder.soundIndex == 0 then
          ibSyncProjectileHolder.soundIndex = runtime.playerContext.imports.soundIndex(
            ibSyncProjectileHolder.soundName)
        end if
      end if
      ibSyncProjectileEdictHolder.state.modelIndex = ibSyncProjectileHolder.modelIndex
      ibSyncProjectileEdictHolder.state.sound = ibSyncProjectileHolder.soundIndex
      ibSyncProjectileEdictHolder.mins = weaponVector(ibSyncProjectileHolder.mins)
      ibSyncProjectileEdictHolder.maxs = weaponVector(ibSyncProjectileHolder.maxs)
      exportTable.edicts[ibSyncProjectileHolder.engineNumber] = ibSyncProjectileEdictHolder
      ibSyncStoredProjectileHolder = exportTable.edicts[ibSyncProjectileHolder.engineNumber]
      ibgametypes.stabilizeEdict(ibSyncStoredProjectileHolder)
      if runtime.playerContext is not void then runtime.playerContext.imports.linkEntity(ibSyncStoredProjectileHolder) end if
    end if
  end for
end function
