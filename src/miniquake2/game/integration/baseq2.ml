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
import miniquake2.game.ai.constants as ibaiconstants
import miniquake2.game.ai.combat_profiles as ibaicombat
import miniquake2.game.ai.attack_sequences as ibattackseq
import miniquake2.game.ai.reaction_sequences as ibreactionseq
import miniquake2.game.ai.death_effects as ibdeatheffects
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
end struct

activeIntegrationRuntime = void

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
  used = false
  for each targetEntity in ibworld.matchingTargets(activeIntegrationRuntime.world, actor.target)
    if ibworld.useEntity(activeIntegrationRuntime.world, targetEntity, void, activator) then used = true end if
  end for
  return used
end function

function aiVisible(actor, other)
  // Collision-aware visibility can replace this callback when the BSP trace
  // adapter exposes entity-to-entity line tests. The base1 slice remains
  // deterministic and range/front gated in the AI core.
  return true
end function

function aiInPHS(first, second)
  return true
end function

function aiAreasConnected(first, second)
  return true
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

function configureAI(context)
  context.pickTarget = aiPickTarget
  context.useTargets = aiUseTargets
  context.visible = aiVisible
  context.clearShot = aiVisible
  context.inPHS = aiInPHS
  context.areasConnected = aiAreasConnected
  context.spawnMonster = integratedSpawnMonster
  context.playSound = integratedAISound
  context.tempEntity = integratedAITempEntity
  context.deathEffect = integratedAIDeathEffect
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
  target.combatant.edict.state.number = entity.number
  target.combatant.edict.state.origin = weaponVector(entity.origin)
  target.combatant.edict.mins = weaponVector(entity.mins)
  target.combatant.edict.maxs = weaponVector(entity.maxs)
  target.combatant.health = entity.health
  target.combatant.takeDamage = entity.takeDamage == ibworldconstants.DAMAGE_YES
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
  if worldEntity is not void and worldEntity.takeDamage == ibworldconstants.DAMAGE_YES then return worldWeaponTarget(worldEntity) end if
  return void
end function

function integratedWeaponTargets(runtime)
  targets = []
  if runtime.playerContext is not void then
    for each player in runtime.playerContext.players
      if player.edict.inUse and player.health > 0 then targets = targets + [playerWeaponTarget(player, runtime.playerContext.registry)] end if
    end for
  end if
  for each actor in runtime.monsters
    if actor.edict.inUse and actor.health > 0 then targets = targets + [monsterWeaponTarget(actor)] end if
  end for
  for each entity in runtime.world.entities
    if entity.inUse and entity.takeDamage == ibworldconstants.DAMAGE_YES then targets = targets + [worldWeaponTarget(entity)] end if
  end for
  return targets
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
  result = []
  for each target in integratedWeaponTargets(runtime)
    if ibwpvector.length(ibwpvector.subtract(target.origin, origin)) <= radius then result = result + [target] end if
  end for
  return result
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
  return ibplayerconstants.MOD_EXPLOSIVE
end function

function integratedWorldDamage(targetEntity, inflictor, attacker, amount, means)
  global activeIntegrationRuntime
  runtime = activeIntegrationRuntime
  if runtime is void or targetEntity is void then return false end if
  target = weaponTargetByNumber(runtime, targetEntity.number)
  if target is void then return false end if
  inflictorTarget = void
  attackerTarget = void
  if inflictor is not void then inflictorTarget = weaponTargetByNumber(runtime, inflictor.number) end if
  if attacker is not void then attackerTarget = weaponTargetByNumber(runtime, attacker.number) end if
  return ibwpcore.applyDamage(runtime.weaponContext, target, inflictorTarget, attackerTarget,
    ibqtypes.zeroVec3(), target.origin, amount, 1, 0, integratedWorldMeans(means))
end function

function integratedWorldRadiusDamage(inflictor, attacker, amount, radius, means)
  global activeIntegrationRuntime
  runtime = activeIntegrationRuntime
  if runtime is void or inflictor is void then return false end if
  inflictorTarget = worldWeaponTarget(inflictor)
  attackerTarget = void
  if attacker is not void then attackerTarget = weaponTargetByNumber(runtime, attacker.number) end if
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
  ibProjectileModelName = ""
  ibProjectileSoundName = ""
  if entity.className == "bolt" then
    ibProjectileModelName = "models/objects/laser/tris.md2"
    ibProjectileSoundName = "misc/lasfly.wav"
  else if entity.className == "grenade" then ibProjectileModelName = "models/objects/grenade/tris.md2"
  else if entity.className == "hgrenade" then
    ibProjectileModelName = "models/objects/grenade2/tris.md2"
    ibProjectileSoundName = "weapons/hgrenc1b.wav"
  else if entity.className == "rocket" then
    ibProjectileModelName = "models/objects/rocket/tris.md2"
    ibProjectileSoundName = "weapons/rockfly.wav"
  else if entity.className == "bfg blast" then
    ibProjectileModelName = "sprites/s_bfg1.sp2"
    ibProjectileSoundName = "weapons/bfg__l1a.wav"
  end if
  if ibProjectileModelName != "" then ibProjectileEdictHolder.state.modelIndex = ibProjectileImportsHolder.modelIndex(ibProjectileModelName) end if
  if ibProjectileSoundName != "" then ibProjectileEdictHolder.state.sound = ibProjectileImportsHolder.soundIndex(ibProjectileSoundName) end if
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
  if runtime is void then return false end if
  source = findAIPlayer(runtime, owner.number)
  if source is void then return false end if
  runtime.aiContext.soundEntity = source
  runtime.aiContext.soundEntityFrame = runtime.aiContext.frameNumber
  return true
end function

function integratedDodge(owner, start, direction, speed)
  global activeIntegrationRuntime
  ibDodgeRuntimeHolder = activeIntegrationRuntime
  if ibDodgeRuntimeHolder is void or speed <= 0.0 then return false end if
  // g_weapon.c applies a separate easy-skill 25% gate before tracing.  Each
  // stock dodge callback then applies its own 25% gate on every skill.  Keep
  // both decisions replay-stable while preserving those original odds.
  ibDodgeFrameNumber = ibDodgeRuntimeHolder.aiContext.frameNumber
  ibDodgeEndHolder = ibwpvector.multiplyAdd(start, 8192.0, direction)
  ibDodgeTraceHolder = integratedWeaponTrace(start, ibqtypes.zeroVec3(), ibqtypes.zeroVec3(),
    ibDodgeEndHolder, owner, ibqconstants.MASK_SHOT)
  if ibDodgeTraceHolder.entity is void then return false end if
  ibDodgeActorHolder = integratedMonsterByNumber(ibDodgeRuntimeHolder, ibDodgeTraceHolder.entity.number)
  if ibDodgeActorHolder is void or ibDodgeActorHolder.health <= 0 then return false end if
  ibDodgePlanHolder = ibreactionseq.stockDodgePlan(ibDodgeActorHolder.className)
  if ibDodgePlanHolder is void or ibreactionseq.planByName(ibDodgeActorHolder.className, ibDodgeActorHolder.activity) is not void then return false end if
  if ibDodgeRuntimeHolder.aiContext.skill == 0 and
      ibreactionseq.deterministicValue(ibDodgeActorHolder.edict.state.number,
        ibDodgeFrameNumber, 179, 100) >= 25 then return false end if
  if ibreactionseq.deterministicValue(ibDodgeActorHolder.edict.state.number,
      ibDodgeFrameNumber, 181, 100) >= 25 then return false end if
  ibDodgeAttackerActorHolder = findAIPlayer(ibDodgeRuntimeHolder, owner.number)
  if ibDodgeAttackerActorHolder is void then
    ibDodgeAttackerActorHolder = integratedMonsterByNumber(ibDodgeRuntimeHolder, owner.number)
  end if
  if ibDodgeAttackerActorHolder is not void and
      ibgaicore.infront(ibDodgeActorHolder, ibDodgeAttackerActorHolder) != true then return false end if
  return ibmonster.StartReaction(ibDodgeActorHolder, ibDodgePlanHolder, ibDodgeRuntimeHolder.aiContext)
end function

function integratedRandomSigned()
  return 0.0
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
  return 0.5
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

function integratedTurretDriverSpawn(driver, world)
  return true
end function

function integratedTurretDriverUse(driver, other, activator, world)
  return true
end function

function integratedTurretDriverDie(driver, inflictor, attacker, damage, point, world)
  return true
end function

function integratedTurretControl()
  ibTurretCallbacksHolder = ibturrettypes.defaultTurretCallbacks()
  ibTurretCallbacksHolder.acquireTarget = integratedTurretAcquire
  ibTurretCallbacksHolder.traceVisible = integratedTurretVisible
  ibTurretCallbacksHolder.randomUnit = integratedTurretRandomUnit
  ibTurretCallbacksHolder.fireRocket = integratedTurretFire
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
  if name == "func_water" then entity.wait = -1.0; return ibmovers.spawnDoor(entity, world) end if
  if name == "func_door_secret" then return ibmovers.spawnDoor(entity, world) end if
  if name == "func_door_rotating" then return ibmovers.spawnRotatingDoor(entity, world) end if
  if name == "func_plat" then return ibmovers.spawnPlat(entity, world) end if
  if name == "func_train" then return ibmovers.spawnTrain(entity, world) end if
  if name == "trigger_elevator" then return ibmovers.spawnElevator(entity, world) end if
  if name == "func_timer" then return ibmovers.spawnTimer(entity, world) end if
  if name == "func_clock" then return ibmisc.spawnWorldClock(entity, world) end if
  if name == "func_killbox" then return ibmovers.spawnKillBox(entity, world) end if
  if name == "func_explosive" then return ibmovers.spawnExplosive(entity, world, false) end if
  if name == "func_wall" then return ibmisc.spawnWall(entity, world) end if
  if name == "func_object" then return ibmisc.spawnWall(entity, world) end if
  if name == "func_rotating" then return ibmisc.spawnRotating(entity, world) end if
  if name == "misc_explobox" then return ibmisc.spawnExplobox(entity, world) end if
  if name == "misc_banner" then return ibmisc.spawnBanner(entity, world) end if
  if name == "misc_deadsoldier" then return ibmisc.spawnDeadSoldier(entity, world) end if
  if name == "misc_strogg_ship" then return ibmisc.spawnStroggShip(entity, world) end if
  if name == "misc_gib_head" then return ibmisc.spawnGibHead(entity, world) end if
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
    end if
  end for
  weaponContext = ibwpcore.createContext(integratedWeaponCallbacks())
  runtime = IntegratedBaseQ2(world, aiContext, monsters, items, [], weaponContext, void, void)
  activeIntegrationRuntime = runtime
  configureAI(aiContext)
  installTurretRigs(runtime)
  installPropTargetProxies(runtime)
  ibpusher.assembleTeams(runtime.world)
  // SpawnMonster establishes defaults before the parsed fields are copied.
  // Re-running the generic start boundary applies target/trigger-spawn state.
  for each actor in runtime.monsters
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
    if ibPrecacheActorHolder.className == "monster_commander_body" then
      imports.soundIndex("tank/thud.wav")
      imports.soundIndex("tank/pain.wav")
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
  runtime.weaponContext.deathmatch = playerContext.deathmatch
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
    actor.flags = player.flags
    actor.lightLevel = player.lightLevel
    if actor.lightLevel <= 5 then actor.lightLevel = 128 end if
    actor.isClient = true
    actor.isMonster = false
    if sightClient is void and player.edict.inUse and player.persistent.connected and player.health > 0 and player.respawn.spectator != true then sightClient = actor end if
  end for
  runtime.aiContext.sightClient = sightClient
  return len(runtime.aiPlayers)
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

function playerMuzzle(player, item, gunFrame, shotIndex)
  ibPlayerMuzzleAnglesHolder = player.edict.client.playerState.viewAngles
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
  if item.className == "weapon_blaster" or item.className == "weapon_hyperblaster" or
      item.className == "weapon_grenadelauncher" or item.className == "weapon_rocketlauncher" then
    ibPlayerRecoilOrigin = 2.0; ibPlayerRecoilPitch = -1.0
  else if item.className == "weapon_shotgun" or item.className == "weapon_supershotgun" then
    ibPlayerRecoilOrigin = 2.0; ibPlayerRecoilPitch = -2.0
  else if item.className == "weapon_railgun" then
    ibPlayerRecoilOrigin = 3.0; ibPlayerRecoilPitch = -3.0
  else if item.className == "weapon_bfg" then ibPlayerRecoilOrigin = 2.0
  else if item.className == "weapon_machinegun" then
    if not runtime.playerContext.deathmatch then
      ibPlayerRecoilPitch = player.view.machinegunShots * -1.5
      player.view.machinegunShots = player.view.machinegunShots + 1
      if player.view.machinegunShots > 9 then player.view.machinegunShots = 9 end if
    end if
  end if
  player.view.kickOrigin = ibwpvector.scale(direction, -ibPlayerRecoilOrigin)
  player.view.kickAngles = ibqtypes.Vec3(ibPlayerRecoilPitch, 0.0, 0.0)
  if item.className == "weapon_bfg" then
    player.view.damagePitch = -40.0
    player.view.damageRoll = 0.0
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
    integratedPlayerNoise(shooter, shooter.origin, 1)
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
      ibwphitscan.fireBullet(runtime.weaponContext, shooter, start, direction, ibChainDamage * multiplier, 2 * multiplier, 300.0, 500.0, ibgpconstants.MOD_CHAINGUN)
      shot = shot + 1
    end while
  else if item.className == "weapon_grenadelauncher" then ibwpprojectiles.fireGrenade(runtime.weaponContext, shooter, start, direction, 120 * multiplier, 600.0, 2.5, 160.0)
  else if item.className == "weapon_rocketlauncher" then ibwpprojectiles.fireRocket(runtime.weaponContext, shooter, start, direction, 100 * multiplier, 650.0, 120.0, 120 * multiplier)
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
  integratedPlayerNoise(shooter, start, 1)
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
    integratedPlayerNoise(ibHandOwnerHolder, ibHandMuzzleHolder[0], 1)
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

function monsterMuzzleAndDirection(runtime, actor)
  start = weaponVector(actor.edict.state.origin)
  start.z = start.z + actor.viewHeight
  enemy = weaponTargetByNumber(runtime, actor.enemy.edict.state.number)
  if enemy is void then return [start, ibqtypes.Vec3(1.0, 0.0, 0.0)] end if
  destination = ibwpvector.midpoint(enemy)
  direction = ibwpvector.normalized(ibwpvector.subtract(destination, start))[0]
  return [start, direction]
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

function fireMonsterAttack(runtime, actor, attackPlan, eventIndex, muzzleFlash)
  if actor.enemy is void or attackPlan is void then return false end if
  muzzle = monsterMuzzleAndDirection(runtime, actor)
  start = muzzle[0]
  direction = muzzle[1]
  shooter = monsterWeaponTarget(actor)
  enemyTarget = weaponTargetByNumber(runtime, actor.enemy.edict.state.number)
  if enemyTarget is void then return false end if
  distance = ibwpvector.length(ibwpvector.subtract(enemyTarget.origin, shooter.origin))
  if distance > attackPlan.maximumRange then return false end if
  kind = attackPlan.attackKind
  attackDamage = ibattackseq.eventDamage(attackPlan, eventIndex)
  attackKnockback = ibattackseq.eventKnockback(attackPlan, eventIndex)
  damageKnockback = attackKnockback
  // Quake II fire_hit accepts a negative special kick and applies it after a
  // DAMAGE_NO_KNOCKBACK T_Damage call. The shared combat request deliberately
  // rejects negative magnitudes, so keep that signed move metadata out of it.
  if damageKnockback < 0 then damageKnockback = 0 end if
  if kind == "melee" or kind == "drain" then
    ibwpcore.applyDamage(runtime.weaponContext, enemyTarget, shooter, shooter, direction,
      enemyTarget.origin, attackDamage, damageKnockback, 0, ibgpconstants.MOD_UNKNOWN)
    if kind == "drain" then integratedMonsterDrainBeam(runtime, actor, start, enemyTarget.origin) end if
  else if kind == "blaster" then
    ibwpprojectiles.fireBlaster(runtime.weaponContext, shooter, start, direction,
      attackDamage, attackPlan.speed, ibwpconstants.EF_BLASTER, false)
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
  return ibattackseq.planByName(actor.className, actor.activity,
    actor.edict.state.number, actor.attackCount)
end function

function monsterAttackTimelineOffset(actor, attackPlan, now)
  targetOffset = attackPlan.durationFrames - 1
  if actor.info.nextFrame >= 0 and actor.info.nextFrame < len(attackPlan.frameOffsets) then
    targetOffset = attackPlan.frameOffsets[actor.info.nextFrame]
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

function finishMonsterAttack(runtime, actor, attackPlan, lastFrameOffset)
  remaining = attackPlan.cooldown - lastFrameOffset * ibattackseq.FRAME_TIME
  if remaining < runtime.world.frameTime then remaining = runtime.world.frameTime end if
  actor.activity = "run"
  actor.info.nextFrame = 0
  actor.info.pauseTime = 0.0
  actor.info.attackState = ibaiconstants.AS_STRAIGHT
  actor.info.attackFinished = runtime.aiContext.time + remaining
  return true
end function

function advanceMonsterAttack(runtime, actor, attackPlan)
  if actor.enemy is void or actor.enemy.health <= 0 then
    return finishMonsterAttack(runtime, actor, attackPlan, 0)
  end if
  eventIndex = actor.info.nextFrame
  projectMonsterAttackFrame(runtime, actor, attackPlan)
  if eventIndex < 0 then
    return finishMonsterAttack(runtime, actor, attackPlan, attackPlan.durationFrames - 1)
  end if
  if eventIndex >= len(attackPlan.frameOffsets) then
    if runtime.aiContext.time + 0.00001 < actor.info.pauseTime then return false end if
    actor.edict.state.frame = ibattackseq.modelFrameAt(attackPlan, attackPlan.durationFrames - 1)
    return finishMonsterAttack(runtime, actor, attackPlan, attackPlan.durationFrames - 1)
  end if
  if runtime.aiContext.time + 0.00001 < actor.info.pauseTime then return false end if
  currentFrameOffset = attackPlan.frameOffsets[eventIndex]
  fired = false
  while eventIndex < len(attackPlan.frameOffsets) and attackPlan.frameOffsets[eventIndex] == currentFrameOffset
    if fireMonsterAttack(runtime, actor, attackPlan, eventIndex, attackPlan.muzzleFlashes[eventIndex]) then fired = true end if
    eventIndex = eventIndex + 1
  end while
  actor.info.nextFrame = eventIndex
  if eventIndex >= len(attackPlan.frameOffsets) then
    tailFrames = attackPlan.durationFrames - 1 - currentFrameOffset
    if tailFrames <= 0 then finishMonsterAttack(runtime, actor, attackPlan, currentFrameOffset)
    else actor.info.pauseTime = actor.info.pauseTime + tailFrames * ibattackseq.FRAME_TIME
    end if
  else
    frameDelta = attackPlan.frameOffsets[eventIndex] - currentFrameOffset
    actor.info.pauseTime = actor.info.pauseTime + frameDelta * ibattackseq.FRAME_TIME
  end if
  return fired
end function

function runMonsterCombat(runtime, actor)
  if actor.health <= 0 or actor.enemy is void or monsterAttackSupported(actor) != true then return false end if
  if ibreactionseq.planByName(actor.className, actor.activity) is not void then return false end if
  activePlan = activeMonsterAttackPlan(actor)
  if activePlan is not void then return advanceMonsterAttack(runtime, actor, activePlan) end if
  if actor.enemy.health <= 0 or runtime.aiContext.time < actor.info.attackFinished then return false end if
  if runtime.aiContext.visible(actor, actor.enemy) != true then return false end if
  profile = ibaicombat.stockProfile(actor.className)
  target = weaponTargetByNumber(runtime, actor.enemy.edict.state.number)
  if target is void then return false end if
  shooter = monsterWeaponTarget(actor)
  distance = ibwpvector.length(ibwpvector.subtract(target.origin, shooter.origin))
  if distance > profile.maximumRange then return false end if
  if profile.attackKind == "melee" and actor.info.melee is not void then actor.info.melee(actor, runtime.aiContext)
  else if actor.info.attack is not void then actor.info.attack(actor, runtime.aiContext)
  else return false
  end if
  attackPlan = ibattackseq.selectPlan(actor.className, actor.edict.state.number,
    actor.attackCount, distance, runtime.aiContext.skill)
  ibattackseq.validatePlan(attackPlan)
  actor.activity = attackPlan.name
  actor.info.nextFrame = 0
  actor.info.attackState = ibaiconstants.AS_MISSILE
  actor.info.pauseTime = runtime.aiContext.time + attackPlan.frameOffsets[0] * ibattackseq.FRAME_TIME
  actor.edict.state.frame = ibattackseq.modelFrameAt(attackPlan, 0)
  return advanceMonsterAttack(runtime, actor, attackPlan)
end function

function advanceWeaponProjectiles(runtime)
  context = runtime.weaponContext
  context.time = runtime.world.time
  for each projectile in context.projectiles
    if projectile.inUse then
      projectile.oldOrigin = ibwpvector.copy(projectile.origin)
      finish = ibwpvector.multiplyAdd(projectile.origin, context.frameTime, projectile.velocity)
      trace = context.callbacks.trace(projectile.origin, projectile.mins, projectile.maxs, finish, projectile, projectile.clipMask)
      projectile.origin = ibwpvector.copy(trace.endPosition)
      projectile.angles = ibwpvector.multiplyAdd(projectile.angles, context.frameTime, projectile.angularVelocity)
      if trace.fraction < 1.0 then ibwpcore.touchProjectile(context, projectile, trace.entity, trace) end if
    end if
  end for
  ibwpcore.runDueThinks(context)
  // The C game reuses freed edicts. Managed projectiles are private records,
  // so drop inactive entries after all due thinks instead of retaining every
  // projectile ever fired for the lifetime of the level.
  activeProjectiles = []
  for each retainedProjectile in context.projectiles
    if retainedProjectile.inUse then activeProjectiles = activeProjectiles + [retainedProjectile] end if
  end for
  context.projectiles = activeProjectiles
  return true
end function

function runFrame(runtime)
  pusherState = ibpusher.capture(runtime)
  ibworld.runFrame(runtime.world)
  ibpusher.resolve(runtime, pusherState)
  runtime.aiContext.time = runtime.world.time
  runtime.weaponContext.time = runtime.world.time
  runtime.aiContext.frameNumber = runtime.aiContext.frameNumber + 1
  for each actor in runtime.monsters
    if actor.nextThink > 0.0 and actor.nextThink <= runtime.aiContext.time then ibmonster.MonsterThink(actor, runtime.aiContext) end if
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
      ibSyncTargetHolder.state = ibSyncStateHolder
      ibSyncTargetHolder.state.modelIndex = entity.modelIndex
      ibSyncTargetHolder.state.effects = entity.effects
      ibSyncTargetHolder.state.renderFx = entity.renderFx
      ibSyncTargetHolder.state.frame = entity.frame
      ibSyncTargetHolder.state.sound = entity.loopSound
      ibSyncTargetHolder.serverFlags = entity.serverFlags
      ibSyncTargetHolder.solid = entity.solid
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
      ibSyncProjectileEdictHolder.mins = weaponVector(ibSyncProjectileHolder.mins)
      ibSyncProjectileEdictHolder.maxs = weaponVector(ibSyncProjectileHolder.maxs)
      exportTable.edicts[ibSyncProjectileHolder.engineNumber] = ibSyncProjectileEdictHolder
      ibSyncStoredProjectileHolder = exportTable.edicts[ibSyncProjectileHolder.engineNumber]
      ibgametypes.stabilizeEdict(ibSyncStoredProjectileHolder)
      if runtime.playerContext is not void then runtime.playerContext.imports.linkEntity(ibSyncStoredProjectileHolder) end if
    end if
  end for
end function
