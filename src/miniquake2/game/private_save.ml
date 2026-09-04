//! Provides miniquake2 game private save facilities for this project.

/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Versioned private BaseQ2 component save/restore beside the engine ABI. */
package miniquake2.game.private_save

import miniquake2.qcommon.sizebuf as privatesizebuf
import miniquake2.qcommon.message as privatemessage
import miniquake2.protocol.checked as privatechecked
import miniquake2.game.base.spawn as privatespawn
import miniquake2.game.integration.baseq2 as privateintegration
import miniquake2.game.ai.archetypes as privatesaveaiarchetypes
import miniquake2.game.ai.actor as privatesaveactor
import miniquake2.game.ai.insane as privatesaveinsane
import miniquake2.game.ai.props as privatesaveaiprops
import miniquake2.game.ai.types as privatesaveaitypes
import miniquake2.game.types as privatesavegametypes
import miniquake2.game.world.movers as privatemovers
import miniquake2.game.world.misc as privateworldmisc
import miniquake2.game.world.turret as privateturret
import miniquake2.game.world.types as privateworldtypes
import miniquake2.game.world.core as privateworldcore
import miniquake2.game.player.types as privateplayers
import miniquake2.game.player.constants as privateplayerconstants
import miniquake2.game.gameplay.types as privategameplaytypes
import miniquake2.game.weapons.types as privatesaveweapontypes
import miniquake2.game.weapons.core as privatesaveweaponcore
import miniquake2.game.weapons.projectiles as privatesaveprojectiles

/// Defines the private magic constant used by the miniquake2 game private save module.
const PRIVATE_MAGIC = "MQ2BASEQ2"
/// Defines the private version constant used by the miniquake2 game private save module.
const PRIVATE_VERSION = 21

/// Store private restore data.
struct PrivateRestore
  /// Stores the runtime value associated with private restore.
  runtime
  /// Stores the spawn result value associated with private restore.
  spawnResult
  /// Stores the entity string value associated with private restore.
  entityString
  /// Stores the spawn point value associated with private restore.
  spawnPoint
  /// Stores the skill value associated with private restore.
  skill
end struct

/// Store private monster reference data.
struct PrivateMonsterReference
  /// Stores the actor value associated with private monster reference.
  actor
  /// Stores the enemy number value associated with private monster reference.
  enemyNumber
  /// Stores the old enemy number value associated with private monster reference.
  oldEnemyNumber
  /// Stores the owner number value associated with private monster reference.
  ownerNumber
  /// Stores the goal entity number value associated with private monster reference.
  goalEntityNumber
  /// Stores the move target number value associated with private monster reference.
  moveTargetNumber
end struct

/// Store private world reference data.
struct PrivateWorldReference
  /// Stores the entity value associated with private world reference.
  entity
  /// Stores the activator number value associated with private world reference.
  activatorNumber
  /// Stores the owner number value associated with private world reference.
  ownerNumber
  /// Stores the team master number value associated with private world reference.
  teamMasterNumber
  /// Stores the team chain number value associated with private world reference.
  teamChainNumber
  /// Stores the target entity number value associated with private world reference.
  targetEntityNumber
  /// Stores the enemy number value associated with private world reference.
  enemyNumber
  /// Stores the old enemy number value associated with private world reference.
  oldEnemyNumber
  /// Stores the ground entity number value associated with private world reference.
  groundEntityNumber
end struct

/// Store deferred projectile ownership and collision references.
struct PrivateProjectileReference
  /// Stores the projectile value associated with private projectile reference.
  projectile
  /// Stores the owner number value associated with private projectile reference.
  ownerNumber
  /// Stores the enemy number value associated with private projectile reference.
  enemyNumber
  /// Stores the ground number value associated with private projectile reference.
  groundNumber
  /// Stores the last touch kind value associated with private projectile reference.
  lastTouchKind
  /// Stores the last think kind value associated with private projectile reference.
  lastThinkKind
end struct

/// Store a player's two persistent AI noise markers during deferred restore.
struct PrivateNoiseReference
  /// Stores the owner number value associated with private noise reference.
  ownerNumber
  /// Stores the primary present value associated with private noise reference.
  primaryPresent
  /// Stores the primary origin value associated with private noise reference.
  primaryOrigin
  /// Stores the primary teleport time value associated with private noise reference.
  primaryTeleportTime
  /// Stores the primary area number value associated with private noise reference.
  primaryAreaNumber
  /// Stores the primary in use value associated with private noise reference.
  primaryInUse
  /// Stores the secondary present value associated with private noise reference.
  secondaryPresent
  /// Stores the secondary origin value associated with private noise reference.
  secondaryOrigin
  /// Stores the secondary teleport time value associated with private noise reference.
  secondaryTeleportTime
  /// Stores the secondary area number value associated with private noise reference.
  secondaryAreaNumber
  /// Stores the secondary in use value associated with private noise reference.
  secondaryInUse
end struct

/// Return the private reference number.
/// @param value Value consumed or transformed by the operation.
function privateReferenceNumber(value)
  if value is void then return -1 end if
  privateDirectNumber = try(value.number)
  if typeof(privateDirectNumber) == "int" then return privateDirectNumber end if
  privateEdictNumber = try(value.edict.state.number)
  if typeof(privateEdictNumber) == "int" then return privateEdictNumber end if
  privateEngineEdictNumber = try(value.state.number)
  if typeof(privateEngineEdictNumber) == "int" then return privateEngineEdictNumber end if
  return -1
end function

/// Write private vec.
/// @param buffer Buffer that receives or supplies the operation data.
/// @param value Value consumed or transformed by the operation.
function privateWriteVec(buffer, value)
  privateWriteVectorHolder = privateworldtypes.vec3FromValue(value, "private save vector")
  privatemessage.writeFloat(buffer, privateWriteVectorHolder.x); privatemessage.writeFloat(buffer, privateWriteVectorHolder.y); privatemessage.writeFloat(buffer, privateWriteVectorHolder.z)
end function

/// Read private float.
/// @param buffer Buffer that receives or supplies the operation data.
/// @param label label value consumed by this operation.
function privateReadFloat(buffer, label)
  privatechecked.require(buffer, 4, label)
  return privatemessage.readFloat(buffer)
end function

/// Read private vec.
/// @param buffer Buffer that receives or supplies the operation data.
/// @param label label value consumed by this operation.
function privateReadVec(buffer, label)
  return miniquake2.qcommon.types.Vec3(privateReadFloat(buffer, label + " x"), privateReadFloat(buffer, label + " y"), privateReadFloat(buffer, label + " z"))
end function

/// Write private bool.
/// @param buffer Buffer that receives or supplies the operation data.
/// @param value Value consumed or transformed by the operation.
function privateWriteBool(buffer, value)
  marker = 0
  if value then marker = 1 end if
  privatemessage.writeByte(buffer, marker)
end function

/// Read private bool.
/// @param buffer Buffer that receives or supplies the operation data.
/// @param label label value consumed by this operation.
function privateReadBool(buffer, label)
  marker = privatechecked.readByte(buffer, label)
  if marker != 0 and marker != 1 then return error(3870, label + ": invalid boolean marker") end if
  return marker == 1
end function

/// Return the item index.
/// @param item item value consumed by this operation.
function itemIndex(item)
  if item is void then return 0 end if
  return item.index
end function

/// Return the item by index.
/// @param registry registry value consumed by this operation.
/// @param index Zero-based index of the affected item.
function itemByIndex(registry, index)
  if index == 0 then return void end if
  for each item in registry.items
    if item.index == index then return item end if
  end for
  return void
end function

/// Write a complete pmove state without relying on the engine save envelope.
/// @param buffer Buffer that receives or supplies the operation data.
/// @param state Mutable state inspected or updated by the operation.
function privateWritePmove(buffer, state)
  privatemessage.writeLong(buffer, state.moveType)
  index = 0
  while index < 3
    privatemessage.writeLong(buffer, state.origin[index])
    privatemessage.writeLong(buffer, state.velocity[index])
    privatemessage.writeLong(buffer, state.deltaAngles[index])
    index = index + 1
  end while
  privatemessage.writeLong(buffer, state.flags); privatemessage.writeLong(buffer, state.time)
  privatemessage.writeLong(buffer, state.gravity)
end function

/// Read a complete pmove state.
/// @param buffer Buffer that receives or supplies the operation data.
/// @param label label value consumed by this operation.
function privateReadPmove(buffer, label)
  state = privatesavegametypes.zeroPmoveState()
  state.moveType = privatechecked.readLong(buffer, label + " type")
  index = 0
  while index < 3
    state.origin[index] = privatechecked.readLong(buffer, label + " origin")
    state.velocity[index] = privatechecked.readLong(buffer, label + " velocity")
    state.deltaAngles[index] = privatechecked.readLong(buffer, label + " delta angles")
    index = index + 1
  end while
  state.flags = privatechecked.readLong(buffer, label + " flags")
  state.time = privatechecked.readLong(buffer, label + " time")
  state.gravity = privatechecked.readLong(buffer, label + " gravity")
  return state
end function

/// Return the reconstructible projectile touch callback identity.
/// @param projectile projectile value consumed by this operation.
function privateProjectileTouchKind(projectile)
  if projectile.touch is void then return "" end if
  if projectile.className == "bolt" then return "blaster" end if
  if projectile.className == "grenade" or projectile.className == "hgrenade" then return "grenade" end if
  if projectile.className == "rocket" then return "rocket" end if
  if projectile.className == "bfg blast" then return "bfg" end if
  return error(3893, "private projectile has unsupported touch callback")
end function

/// Return the reconstructible projectile think callback identity.
/// @param projectile projectile value consumed by this operation.
function privateProjectileThinkKind(projectile)
  if projectile.think is void then return "" end if
  if projectile.className == "grenade" or projectile.className == "hgrenade" then return "grenade-explode" end if
  if projectile.className == "bfg blast" and projectile.solid == 0 then
    if projectile.frame >= 5 then return "free" end if
    return "bfg-explode"
  end if
  if projectile.className == "bfg blast" then return "bfg-think" end if
  return "free"
end function

/// Encode the pointer-free private payload in one fixed field order. New fields
/// are append-only within their versioned record so older readers stay explicit.
/// @param runtime runtime value consumed by this operation.
/// @param playerContext playerContext value consumed by this operation.
/// @param entityString entityString value consumed by this operation.
/// @param spawnPoint spawnPoint value consumed by this operation.
function encode(runtime, playerContext, entityString, spawnPoint)
  if runtime is void then return bytes(0) end if
  playerCount = 0
  inventoryWords = 0
  if playerContext is not void then
    playerCount = len(playerContext.players)
    for each player in playerContext.players
      inventoryWords = inventoryWords + len(player.gameplay.inventory.counts)
    end for
  end if
  capacity = 4096 + len(bytes(entityString)) +
    len(runtime.world.entities) * 512 + len(runtime.monsters) * 640 +
    len(runtime.items) * 192 + len(runtime.weaponContext.projectiles) * 384 +
    playerCount * 1024 + inventoryWords * 4
  buffer = privatesizebuf.alloc(capacity)
  privatemessage.writeString(buffer, PRIVATE_MAGIC); privatemessage.writeLong(buffer, PRIVATE_VERSION)
  privateEntityBytes = bytes(entityString)
  privatemessage.writeLong(buffer, len(privateEntityBytes))
  privatesizebuf.writeBytes(buffer, privateEntityBytes)
  privatemessage.writeString(buffer, spawnPoint)
  privatemessage.writeLong(buffer, runtime.aiContext.skill)
  privatemessage.writeLong(buffer, runtime.randomState.seed)
  privatemessage.writeFloat(buffer, runtime.world.time)
  privatemessage.writeLong(buffer, runtime.world.serverFlags)
  privatemessage.writeLong(buffer, runtime.world.totalSecrets); privatemessage.writeLong(buffer, runtime.world.foundSecrets)
  privatemessage.writeLong(buffer, runtime.world.totalGoals); privatemessage.writeLong(buffer, runtime.world.foundGoals)
  privateWriteBool(buffer, runtime.world.intermission)
  privatemessage.writeLong(buffer, runtime.bodyQueueIndex)
  privateFreeTimeCount = 0
  if runtime.exportTable is not void then
    privateFreeTimeCount = runtime.exportTable.numEdicts
  end if
  privatemessage.writeLong(buffer, privateFreeTimeCount)
  privateFreeTimeIndex = 0
  while privateFreeTimeIndex < privateFreeTimeCount
    privatemessage.writeFloat(buffer,
      runtime.edictFreeTimes[privateFreeTimeIndex])
    privateFreeTimeIndex = privateFreeTimeIndex + 1
  end while
  // Persist the level globals consumed by FindTarget plus each client's two
  // reusable noise markers (edict_t::mynoise/mynoise2 in the original game).
  privatemessage.writeLong(buffer, privateReferenceNumber(runtime.aiContext.sightClient))
  privatemessage.writeLong(buffer, privateReferenceNumber(runtime.aiContext.sightEntity))
  privatemessage.writeLong(buffer, runtime.aiContext.sightEntityFrame)
  privatemessage.writeLong(buffer, privateReferenceNumber(runtime.aiContext.soundEntity))
  privatemessage.writeLong(buffer, runtime.aiContext.soundEntityFrame)
  privatemessage.writeLong(buffer, privateReferenceNumber(runtime.aiContext.sound2Entity))
  privatemessage.writeLong(buffer, runtime.aiContext.sound2EntityFrame)
  privateNoiseOwnerCount = 0
  for each privateNoiseOwner in runtime.aiPlayers
    if privateNoiseOwner.noisePrimary is not void or
        privateNoiseOwner.noiseSecondary is not void then
      privateNoiseOwnerCount = privateNoiseOwnerCount + 1
    end if
  end for
  privatemessage.writeLong(buffer, privateNoiseOwnerCount)
  for each privateNoiseOwner in runtime.aiPlayers
    if privateNoiseOwner.noisePrimary is not void or
        privateNoiseOwner.noiseSecondary is not void then
      privatemessage.writeLong(buffer, privateNoiseOwner.edict.state.number)
      privateWriteBool(buffer, privateNoiseOwner.noisePrimary is not void)
      if privateNoiseOwner.noisePrimary is not void then
        privateWriteVec(buffer, privateNoiseOwner.noisePrimary.edict.state.origin)
        privatemessage.writeFloat(buffer, privateNoiseOwner.noisePrimary.teleportTime)
        privatemessage.writeLong(buffer, privateNoiseOwner.noisePrimary.areaNumber)
        privateWriteBool(buffer, privateNoiseOwner.noisePrimary.edict.inUse)
      end if
      privateWriteBool(buffer, privateNoiseOwner.noiseSecondary is not void)
      if privateNoiseOwner.noiseSecondary is not void then
        privateWriteVec(buffer, privateNoiseOwner.noiseSecondary.edict.state.origin)
        privatemessage.writeFloat(buffer, privateNoiseOwner.noiseSecondary.teleportTime)
        privatemessage.writeLong(buffer, privateNoiseOwner.noiseSecondary.areaNumber)
        privateWriteBool(buffer, privateNoiseOwner.noiseSecondary.edict.inUse)
      end if
    end if
  end for

  privatemessage.writeLong(buffer, len(runtime.world.entities))
  for each entity in runtime.world.entities
    privatemessage.writeLong(buffer, entity.number)
    privatemessage.writeString(buffer, entity.className); privatemessage.writeString(buffer, entity.model)
    privatemessage.writeLong(buffer, entity.modelIndex)
    privateWriteBool(buffer, entity.inUse)
    privatemessage.writeString(buffer, entity.target); privatemessage.writeString(buffer, entity.targetName)
    privatemessage.writeString(buffer, entity.killTarget); privatemessage.writeString(buffer, entity.pathTarget)
    privatemessage.writeString(buffer, entity.team); privatemessage.writeString(buffer, entity.message)
    privatemessage.writeString(buffer, entity.map)
    privateWorldItemIsText = typeof(entity.item) == "string"
    privateWriteBool(buffer, privateWorldItemIsText)
    privateWorldItemText = ""
    if privateWorldItemIsText then privateWorldItemText = entity.item end if
    privatemessage.writeString(buffer, privateWorldItemText)
    privatemessage.writeString(buffer, entity.itemName)
    privatemessage.writeLong(buffer, privateReferenceNumber(entity.activator))
    privatemessage.writeLong(buffer, privateReferenceNumber(entity.owner))
    privatemessage.writeLong(buffer, privateReferenceNumber(entity.teamMaster))
    privatemessage.writeLong(buffer, privateReferenceNumber(entity.teamChain))
    privatemessage.writeLong(buffer, privateReferenceNumber(entity.targetEntity))
    privatemessage.writeLong(buffer, privateReferenceNumber(entity.enemy))
    privatemessage.writeLong(buffer, privateReferenceNumber(entity.oldEnemy))
    privatemessage.writeLong(buffer, privateReferenceNumber(entity.groundEntity))
    privatemessage.writeFloat(buffer, entity.delay); privatemessage.writeFloat(buffer, entity.wait)
    privatemessage.writeFloat(buffer, entity.speed)
    privateWriteVec(buffer, entity.origin); privateWriteVec(buffer, entity.angles); privateWriteVec(buffer, entity.oldOrigin)
    privateWriteVec(buffer, entity.velocity); privateWriteVec(buffer, entity.angularVelocity)
    privatemessage.writeLong(buffer, entity.health); privatemessage.writeLong(buffer, entity.maxHealth)
    privatemessage.writeLong(buffer, entity.solid); privatemessage.writeLong(buffer, entity.moveType)
    privatemessage.writeLong(buffer, entity.effects); privatemessage.writeLong(buffer, entity.renderFx)
    privatemessage.writeLong(buffer, entity.frame); privatemessage.writeLong(buffer, entity.loopSound)
    privatemessage.writeLong(buffer, entity.count); privatemessage.writeLong(buffer, entity.spawnFlags)
    privatemessage.writeFloat(buffer, entity.nextThink); privatemessage.writeFloat(buffer, entity.touchDebounceTime)
    privatemessage.writeLong(buffer, entity.moveInfo.state)
    privatemessage.writeFloat(buffer, entity.moveInfo.currentSpeed); privatemessage.writeFloat(buffer, entity.moveInfo.remainingDistance)
    privateWriteVec(buffer, entity.moveInfo.direction)
    privateWriteVec(buffer, entity.moveInfo.startOrigin); privateWriteVec(buffer, entity.moveInfo.endOrigin)
    privateWriteVec(buffer, entity.moveInfo.startAngles); privateWriteVec(buffer, entity.moveInfo.endAngles)
    privatemessage.writeLong(buffer, entity.flags); privatemessage.writeLong(buffer, entity.serverFlags)
    privatemessage.writeLong(buffer, entity.takeDamage); privatemessage.writeLong(buffer, entity.gibHealth)
    privatemessage.writeLong(buffer, entity.clipMask); privatemessage.writeLong(buffer, entity.aiFlags)
    privatemessage.writeFloat(buffer, entity.timestamp); privatemessage.writeFloat(buffer, entity.pauseTime)
    privatemessage.writeFloat(buffer, entity.gravity)
    privateWriteVec(buffer, entity.oldVelocity)
    privatemessage.writeFloat(buffer, entity.flySoundDebounceTime)
    privatemessage.writeLong(buffer, entity.waterType)
    privatemessage.writeLong(buffer, entity.waterLevel)
    privateWriteVec(buffer, entity.mins)
    privateWriteVec(buffer, entity.maxs)
    privatemessage.writeLong(buffer, entity.style)
  end for

  privatemessage.writeLong(buffer, len(runtime.monsters))
  for each actor in runtime.monsters
    privatemessage.writeLong(buffer, actor.edict.state.number); privatemessage.writeString(buffer, actor.className)
    privateWriteBool(buffer, actor.edict.inUse)
    privatemessage.writeLong(buffer, actor.health); privatemessage.writeLong(buffer, actor.maxHealth)
    privatemessage.writeLong(buffer, actor.deadFlag); privatemessage.writeLong(buffer, actor.flags)
    privatemessage.writeLong(buffer, actor.moveType); privatemessage.writeLong(buffer, actor.takeDamage)
    privatemessage.writeFloat(buffer, actor.nextThink); privatemessage.writeFloat(buffer, actor.info.attackFinished)
    privatemessage.writeLong(buffer, actor.painCount); privatemessage.writeLong(buffer, actor.dieCount)
    privatemessage.writeLong(buffer, actor.attackCount); privatemessage.writeLong(buffer, actor.meleeCount)
    privatemessage.writeFloat(buffer, actor.reactionDebounce)
    privatemessage.writeLong(buffer, actor.info.nextFrame); privatemessage.writeFloat(buffer, actor.info.pauseTime)
    privatemessage.writeLong(buffer, actor.info.attackState)
    privatemessage.writeLong(buffer, actor.edict.state.frame); privatemessage.writeString(buffer, actor.activity)
    privatemessage.writeString(buffer, actor.target); privatemessage.writeString(buffer, actor.targetName)
    privatemessage.writeString(buffer, actor.deathTarget); privatemessage.writeString(buffer, actor.combatTarget)
    privateWriteVec(buffer, actor.edict.state.origin); privateWriteVec(buffer, actor.edict.state.angles); privateWriteVec(buffer, actor.edict.state.oldOrigin)
    privatemessage.writeString(buffer, actor.thinkKind)
    privateWriteBool(buffer, actor.deathUseComplete); privatemessage.writeString(buffer, actor.bossPhase)
    privatemessage.writeString(buffer, actor.successorClassName); privatemessage.writeFloat(buffer, actor.successorDueTime)
    privateWriteBool(buffer, actor.successorSpawned)
    privateWriteVec(buffer, actor.attackAim); privateWriteBool(buffer, actor.attackAimValid)
    privatemessage.writeLong(buffer, actor.attackCycles)
    privatemessage.writeLong(buffer, actor.info.aiFlags)
    privatemessage.writeLong(buffer, privateReferenceNumber(actor.oldEnemy))
    privatemessage.writeLong(buffer, privateReferenceNumber(actor.owner))
    enemyNumber = -1
    if actor.enemy is not void then enemyNumber = actor.enemy.edict.state.number end if
    privatemessage.writeLong(buffer, enemyNumber)
    privatemessage.writeFloat(buffer, actor.info.searchTime)
    privatemessage.writeFloat(buffer, actor.info.idleTime)
    privateWriteVec(buffer, actor.info.lastSighting)
    privateWriteVec(buffer, actor.info.savedGoal)
    privatemessage.writeFloat(buffer, actor.info.trailTime)
    privatemessage.writeFloat(buffer, actor.idealYaw)
    privatemessage.writeLong(buffer, actor.info.lefty)
    privatemessage.writeFloat(buffer, actor.showHostile)
    privateWriteVec(buffer, actor.velocity)
    privatemessage.writeLong(buffer, privateReferenceNumber(actor.goalEntity))
    privatemessage.writeLong(buffer, privateReferenceNumber(actor.moveTarget))
    privatemessage.writeFloat(buffer, actor.airFinished)
    privatemessage.writeFloat(buffer, actor.painDebounceTime)
    privatemessage.writeFloat(buffer, actor.damageDebounceTime)
    privatemessage.writeFloat(buffer, actor.powerArmorTime)
    privatemessage.writeLong(buffer, actor.powerArmorType)
    privatemessage.writeLong(buffer, actor.powerArmorPower)
    privatemessage.writeFloat(buffer, actor.gravity)
  end for

  privatemessage.writeLong(buffer, len(runtime.items))
  for each itemEntity in runtime.items
    privatemessage.writeLong(buffer, itemEntity.edict.state.number)
    privatemessage.writeLong(buffer, itemEntity.item.index)
    privateWriteBool(buffer, itemEntity.edict.inUse)
    privateWriteBool(buffer, itemEntity.hidden); privateWriteBool(buffer, itemEntity.freed); privateWriteBool(buffer, itemEntity.decaying)
    privatemessage.writeLong(buffer, itemEntity.count); privatemessage.writeLong(buffer, itemEntity.spawnFlags)
    privatemessage.writeFloat(buffer, itemEntity.nextThink); privatemessage.writeFloat(buffer, itemEntity.respawnAt)
    privateWriteVec(buffer, itemEntity.velocity)
    privatemessage.writeLong(buffer, privateReferenceNumber(itemEntity.owner))
    privateWriteBool(buffer, itemEntity.spawnPending)
    privatemessage.writeLong(buffer, privateReferenceNumber(itemEntity.groundEntity))
    privatemessage.writeLong(buffer, itemEntity.groundLinkCount)
    privatemessage.writeFloat(buffer, itemEntity.gravity)
    privatemessage.writeLong(buffer, itemEntity.waterType)
    privatemessage.writeLong(buffer, itemEntity.waterLevel)
  end for

  // Version 21 persists every active missile/toss edict, including callback
  // identity and ownership, so a level save resumes the exact in-flight fuse.
  privatemessage.writeLong(buffer, len(runtime.weaponContext.projectiles))
  for each projectile in runtime.weaponContext.projectiles
    privatemessage.writeLong(buffer, projectile.number)
    privatemessage.writeLong(buffer, projectile.engineNumber)
    privateWriteBool(buffer, projectile.inUse)
    privatemessage.writeString(buffer, projectile.className)
    privateWriteVec(buffer, projectile.origin); privateWriteVec(buffer, projectile.oldOrigin)
    privateWriteVec(buffer, projectile.angles); privateWriteVec(buffer, projectile.velocity)
    privateWriteVec(buffer, projectile.angularVelocity); privateWriteVec(buffer, projectile.mins)
    privateWriteVec(buffer, projectile.maxs)
    privatemessage.writeLong(buffer, privateReferenceNumber(projectile.owner))
    privatemessage.writeLong(buffer, privateReferenceNumber(projectile.enemy))
    privatemessage.writeLong(buffer, projectile.moveType); privatemessage.writeLong(buffer, projectile.clipMask)
    privatemessage.writeLong(buffer, projectile.solid); privatemessage.writeLong(buffer, projectile.effects)
    privatemessage.writeString(buffer, projectile.modelName); privatemessage.writeString(buffer, projectile.soundName)
    privatemessage.writeLong(buffer, projectile.modelIndex); privatemessage.writeLong(buffer, projectile.soundIndex)
    privatemessage.writeLong(buffer, projectile.spawnFlags); privatemessage.writeLong(buffer, projectile.damage)
    privatemessage.writeLong(buffer, projectile.radiusDamage); privatemessage.writeFloat(buffer, projectile.damageRadius)
    privatemessage.writeLong(buffer, projectile.waterType); privatemessage.writeLong(buffer, projectile.waterLevel)
    privatemessage.writeFloat(buffer, projectile.gravity)
    privatemessage.writeLong(buffer, privateReferenceNumber(projectile.groundEntity))
    privatemessage.writeFloat(buffer, projectile.nextThink); privatemessage.writeLong(buffer, projectile.frame)
    privatemessage.writeString(buffer, privateProjectileTouchKind(projectile))
    privatemessage.writeString(buffer, privateProjectileThinkKind(projectile))
  end for

  privatemessage.writeLong(buffer, playerCount)
  if playerContext is not void then
    for each player in playerContext.players
      privatemessage.writeLong(buffer, player.edict.state.number)
      privatemessage.writeLong(buffer, player.health); privatemessage.writeLong(buffer, player.maxHealth)
      privatemessage.writeString(buffer, player.persistent.userInfo); privatemessage.writeString(buffer, player.persistent.netName); privatemessage.writeString(buffer, player.persistent.skin)
      privateWriteBool(buffer, player.persistent.connected); privateWriteBool(buffer, player.persistent.spectator)
      privatemessage.writeLong(buffer, player.persistent.score); privatemessage.writeLong(buffer, player.respawn.score)
      privatemessage.writeLong(buffer, player.persistent.gameHelpChanged)
      privatemessage.writeLong(buffer, player.persistent.helpChanged)
      privatemessage.writeLong(buffer, len(player.gameplay.inventory.counts))
      for each count in player.gameplay.inventory.counts
        privatemessage.writeLong(buffer, count)
      end for
      privatemessage.writeLong(buffer, itemIndex(player.gameplay.currentWeapon)); privatemessage.writeLong(buffer, itemIndex(player.gameplay.lastWeapon)); privatemessage.writeLong(buffer, itemIndex(player.gameplay.newWeapon))
      privatemessage.writeLong(buffer, player.gameplay.ammoIndex); privatemessage.writeLong(buffer, player.gameplay.weaponState); privatemessage.writeLong(buffer, player.gameplay.gunFrame)
      privatemessage.writeLong(buffer, player.powerups.quadFrame); privatemessage.writeLong(buffer, player.powerups.invincibleFrame)
      privatemessage.writeLong(buffer, player.powerups.enviroFrame); privatemessage.writeLong(buffer, player.powerups.breatherFrame)
      privatemessage.writeLong(buffer, player.armorItemIndex); privatemessage.writeLong(buffer, player.flags)
      privatemessage.writeLong(buffer, player.floodWhenHead)
      privatemessage.writeFloat(buffer, player.floodLockTill)
      for each floodTime in player.floodWhen
        privatemessage.writeFloat(buffer, floodTime)
      end for
      privatemessage.writeFloat(buffer, player.gravity)
      privatemessage.writeFloat(buffer, player.flySoundDebounceTime)
      // Version 18 closes the item-state gap left by the original private
      // payload. Pack/bandolier capacities, selection, silencer shots, power
      // cube identity and the cooperative checkpoint all affect live rules.
      privatemessage.writeLong(buffer, player.gameplay.inventory.maxBullets)
      privatemessage.writeLong(buffer, player.gameplay.inventory.maxShells)
      privatemessage.writeLong(buffer, player.gameplay.inventory.maxRockets)
      privatemessage.writeLong(buffer, player.gameplay.inventory.maxGrenades)
      privatemessage.writeLong(buffer, player.gameplay.inventory.maxCells)
      privatemessage.writeLong(buffer, player.gameplay.inventory.maxSlugs)
      privatemessage.writeLong(buffer, player.gameplay.inventory.selectedItem)
      privatemessage.writeLong(buffer, player.gameplay.silencerShots)
      privatemessage.writeLong(buffer, player.gameplay.powerCubes)
      privatemessage.writeLong(buffer, len(player.respawn.cooperativeInventory))
      for each cooperativeCount in player.respawn.cooperativeInventory
        privatemessage.writeLong(buffer, cooperativeCount)
      end for
      // Version 20 persists edict_t::powerarmor_time so the short client
      // render effect survives a level-save round trip.
      privatemessage.writeFloat(buffer, player.powerArmorTime)
      // Version 21 closes the remaining gclient_t/edict_t transient-state gap.
      privatemessage.writeLong(buffer, player.persistent.hand)
      privateWriteVec(buffer, player.velocity); privateWritePmove(buffer, player.oldPmove)
      privatemessage.writeLong(buffer, player.moveType); privatemessage.writeLong(buffer, player.deadFlag)
      privatemessage.writeLong(buffer, player.takeDamage); privatemessage.writeFloat(buffer, player.viewHeight)
      privatemessage.writeLong(buffer, player.waterLevel); privatemessage.writeLong(buffer, player.waterType)
      privatemessage.writeLong(buffer, privateReferenceNumber(player.groundEntity))
      privatemessage.writeLong(buffer, player.groundLinkCount)
      privatemessage.writeLong(buffer, player.oldButtons); privatemessage.writeLong(buffer, player.buttons)
      privatemessage.writeLong(buffer, player.latchedButtons); privateWriteBool(buffer, player.weaponThunk)
      privatemessage.writeFloat(buffer, player.respawnTime); privatemessage.writeFloat(buffer, player.killerYaw)
      privatemessage.writeLong(buffer, privateReferenceNumber(player.chaseTarget))
      privatemessage.writeLong(buffer, player.lightLevel)
      privateWriteBool(buffer, player.showScores); privateWriteBool(buffer, player.showInventory)
      privateWriteBool(buffer, player.showHelp); privatemessage.writeFloat(buffer, player.pickupMessageTime)
      privatemessage.writeString(buffer, player.obituary)
      privateWriteVec(buffer, player.view.oldVelocity); privateWriteVec(buffer, player.view.oldViewAngles)
      privateWriteVec(buffer, player.view.kickOrigin); privateWriteVec(buffer, player.view.kickAngles)
      privateWriteVec(buffer, player.view.damageFrom); privateWriteVec(buffer, player.view.damageBlend)
      privatemessage.writeLong(buffer, player.view.damageBlood); privatemessage.writeLong(buffer, player.view.damageArmor)
      privatemessage.writeLong(buffer, player.view.damagePowerArmor); privatemessage.writeLong(buffer, player.view.damageKnockback)
      privatemessage.writeFloat(buffer, player.view.damageAlpha); privatemessage.writeFloat(buffer, player.view.bonusAlpha)
      privatemessage.writeFloat(buffer, player.view.damageRoll); privatemessage.writeFloat(buffer, player.view.damagePitch)
      privatemessage.writeFloat(buffer, player.view.damageTime); privatemessage.writeFloat(buffer, player.view.fallValue)
      privatemessage.writeFloat(buffer, player.view.fallTime); privatemessage.writeFloat(buffer, player.view.painDebounceTime)
      privatemessage.writeFloat(buffer, player.view.damageDebounceTime); privatemessage.writeFloat(buffer, player.view.airFinished)
      privatemessage.writeFloat(buffer, player.view.nextDrownTime); privatemessage.writeLong(buffer, player.view.drownDamage)
      privatemessage.writeLong(buffer, player.view.oldWaterLevel); privatemessage.writeLong(buffer, player.view.breatherSound)
      privatemessage.writeFloat(buffer, player.view.bobTime); privatemessage.writeFloat(buffer, player.view.bobMove)
      privatemessage.writeLong(buffer, player.view.bobCycle); privatemessage.writeFloat(buffer, player.view.bobFracSin)
      privatemessage.writeFloat(buffer, player.view.xySpeed); privatemessage.writeLong(buffer, player.view.animPriority)
      privatemessage.writeLong(buffer, player.view.animEnd); privateWriteBool(buffer, player.view.animDuck)
      privateWriteBool(buffer, player.view.animRun); privatemessage.writeLong(buffer, player.view.painCycle)
      privatemessage.writeLong(buffer, player.view.deathCycle); privatemessage.writeLong(buffer, player.view.weaponSound)
      privatemessage.writeLong(buffer, player.view.machinegunShots)
      privatemessage.writeLong(buffer, player.gameplay.buttons); privatemessage.writeLong(buffer, player.gameplay.latchedButtons)
      privatemessage.writeLong(buffer, player.gameplay.fireCount)
      privateWriteBool(buffer, player.handGrenadeState is not void)
      if player.handGrenadeState is not void then
        handState = player.handGrenadeState
        privatemessage.writeLong(buffer, handState.weaponState); privatemessage.writeLong(buffer, handState.gunFrame)
        privatemessage.writeFloat(buffer, handState.grenadeTime); privateWriteBool(buffer, handState.grenadeBlewUp)
        privatemessage.writeLong(buffer, handState.buttons); privatemessage.writeLong(buffer, handState.latchedButtons)
        privatemessage.writeLong(buffer, handState.ammo); privateWriteBool(buffer, handState.infiniteAmmo)
        privatemessage.writeString(buffer, handState.weaponSound)
        handProjectileNumber = -1
        if handState.lastProjectile is not void then handProjectileNumber = handState.lastProjectile.engineNumber end if
        privatemessage.writeLong(buffer, handProjectileNumber)
      end if
    end for
  end if
  return privatesizebuf.dataSlice(buffer)
end function

/// Find monster.
/// @param runtime runtime value consumed by this operation.
/// @param number number value consumed by this operation.
function findMonster(runtime, number)
  for each actor in runtime.monsters
    if actor.edict.inUse and actor.edict.state.number == number then return actor end if
  end for
  return void
end function

/// Find private world.
/// @param runtime runtime value consumed by this operation.
/// @param number number value consumed by this operation.
/// @param className className value consumed by this operation.
function privateFindWorld(runtime, number, className)
  for each entity in runtime.world.entities
    if entity.inUse and entity.number == number and
        entity.className != "ai_prop_target_proxy" and
        entity.className != "ai_monster_target_proxy" and
        entity.itemName != "__item_target_proxy" and
        (className == "" or entity.className == className) then return entity end if
  end for
  return void
end function

/// Resolve private world reference.
/// @param runtime runtime value consumed by this operation.
/// @param playerContext playerContext value consumed by this operation.
/// @param number number value consumed by this operation.
/// @param label label value consumed by this operation.
function privateResolveWorldReference(runtime, playerContext, number, label)
  if number < 0 then return void end if
  // Resolve the current slot owner in stock edict order: reserved client,
  // active monster, active item adapter, then an authoritative world record.
  for each privateReferencePlayer in playerContext.players
    if privateReferencePlayer.edict.state.number == number then
      return privateintegration.playerWorldProxy(privateReferencePlayer)
    end if
  end for
  privateReferenceMonster = findMonster(runtime, number)
  if privateReferenceMonster is not void then
    privateMonsterProxy = privateworldtypes.createEntity(number,
      privateReferenceMonster.className)
    privateMonsterProxy.serverFlags = privateReferenceMonster.edict.serverFlags
    privateMonsterProxy.origin = privateReferenceMonster.edict.state.origin
    privateMonsterProxy.angles = privateReferenceMonster.edict.state.angles
    privateMonsterProxy.mins = privateReferenceMonster.edict.mins
    privateMonsterProxy.maxs = privateReferenceMonster.edict.maxs
    privateMonsterProxy.health = privateReferenceMonster.health
    privateMonsterProxy.maxHealth = privateReferenceMonster.maxHealth
    privateMonsterProxy.mass = privateReferenceMonster.mass
    return privateMonsterProxy
  end if
  for each privateReferenceItem in runtime.items
    if privateReferenceItem.edict.inUse and
        privateReferenceItem.edict.state.number == number then
      if privateReferenceItem.worldTarget is not void then
        return privateReferenceItem.worldTarget
      end if
      privateItemProxy = privateworldtypes.createEntity(number,
        privateReferenceItem.item.className)
      privateItemProxy.origin = privateReferenceItem.edict.state.origin
      privateItemProxy.angles = privateReferenceItem.edict.state.angles
      privateItemProxy.mins = privateReferenceItem.edict.mins
      privateItemProxy.maxs = privateReferenceItem.edict.maxs
      privateItemProxy.serverFlags = privateReferenceItem.edict.serverFlags
      privateItemProxy.solid = privateReferenceItem.edict.solid
      return privateItemProxy
    end if
  end for
  privateReferenceWorld = privateFindWorld(runtime, number, "")
  if privateReferenceWorld is not void then return privateReferenceWorld end if
  return error(3890, "private world " + label + " is unavailable: " + number)
end function

/// Restore private enemy.
/// @param runtime runtime value consumed by this operation.
/// @param number number value consumed by this operation.
/// @param maxClients maxClients value consumed by this operation.
/// @param exportTable exportTable value consumed by this operation.
function privateRestoreEnemy(runtime, number, maxClients, exportTable)
  if number < 0 then return void end if
  privateSavedEnemyHolder = findMonster(runtime, number)
  if privateSavedEnemyHolder is not void then return privateSavedEnemyHolder end if
  if number > 0 and number <= maxClients and number < exportTable.numEdicts then
    privateClientEnemyHolder = privatesaveaitypes.createClientTarget(number)
    privateClientEnemyHolder.edict = exportTable.edicts[number]
    privatesavegametypes.stabilizeEdict(privateClientEnemyHolder.edict)
    return privateClientEnemyHolder
  end if
  return error(3886, "private monster enemy is unavailable")
end function

/// Restore private ai reference.
/// @param runtime runtime value consumed by this operation.
/// @param number number value consumed by this operation.
/// @param maxClients maxClients value consumed by this operation.
/// @param exportTable exportTable value consumed by this operation.
function privateRestoreAIReference(runtime, number, maxClients, exportTable)
  if number < 0 then return void end if
  privateAIActorHolder = findMonster(runtime, number)
  if privateAIActorHolder is not void then return privateAIActorHolder end if
  if number > 0 and number <= maxClients and number < exportTable.numEdicts then
    privateAIClientHolder = privatesaveaitypes.createClientTarget(number)
    privateAIClientHolder.edict = exportTable.edicts[number]
    privatesavegametypes.stabilizeEdict(privateAIClientHolder.edict)
    return privateAIClientHolder
  end if
  privateAIWorldHolder = privateworldcore.findByNumber(runtime.world, number)
  if privateAIWorldHolder is void then return void end if
  privateAIGoalHolder = privatesaveaitypes.createActor(number,
    privateAIWorldHolder.className)
  privateAIGoalHolder.edict.state.origin = privateAIWorldHolder.origin
  privateAIGoalHolder.edict.state.angles = privateAIWorldHolder.angles
  privateAIGoalHolder.edict.inUse = privateAIWorldHolder.inUse
  privateAIGoalHolder.target = privateAIWorldHolder.target
  privateAIGoalHolder.targetName = privateAIWorldHolder.targetName
  privateAIGoalHolder.isMonster = false
  return privateAIGoalHolder
end function

/// Resolve an AI level-global reference, including synthetic player-noise slots.
/// @param runtime runtime value consumed by this operation.
/// @param number number value consumed by this operation.
/// @param maxClients maxClients value consumed by this operation.
/// @param exportTable exportTable value consumed by this operation.
function privateRestoreLevelAIReference(runtime, number, maxClients, exportTable)
  if number == -1 then return void end if
  for each privateLevelAIPlayer in runtime.aiPlayers
    if privateLevelAIPlayer.edict.state.number == number then
      return privateLevelAIPlayer
    end if
    if privateLevelAIPlayer.noisePrimary is not void and
        privateLevelAIPlayer.noisePrimary.number == number then
      return privateLevelAIPlayer.noisePrimary
    end if
    if privateLevelAIPlayer.noiseSecondary is not void and
        privateLevelAIPlayer.noiseSecondary.number == number then
      return privateLevelAIPlayer.noiseSecondary
    end if
  end for
  return privateRestoreAIReference(runtime, number, maxClients, exportTable)
end function

/// Restore the versioned, pointer-free MiniQuake2 payload in two phases: first
/// allocate stable entity/AI slots, then resolve saved numeric relationships.
/// This prevents partially decoded references from escaping on malformed input.
/// @param data Input data consumed by the operation.
/// @param mapName mapName value consumed by this operation.
/// @param maxClients maxClients value consumed by this operation.
/// @param exportTable exportTable value consumed by this operation.
/// @param playerContext playerContext value consumed by this operation.
function restore(data, mapName, maxClients, exportTable, playerContext)
  if typeof(data) != "bytes" or len(data) == 0 then return error(3871, "private BaseQ2 save payload missing") end if
  buffer = privatesizebuf.alloc(len(data)); privatesizebuf.writeBytes(buffer, data); privatemessage.beginReading(buffer)
  if privatemessage.readString(buffer) != PRIVATE_MAGIC then return error(3872, "private BaseQ2 save magic mismatch") end if
  privateSaveVersion = privatechecked.readLong(buffer, "private save version")
  if privateSaveVersion != 7 and privateSaveVersion != 8 and
      privateSaveVersion != 9 and privateSaveVersion != 10 and
      privateSaveVersion != 11 and privateSaveVersion != 12 and
      privateSaveVersion != 13 and privateSaveVersion != 14 and
      privateSaveVersion != 15 and privateSaveVersion != 16 and
      privateSaveVersion != 17 and privateSaveVersion != 18 and
      privateSaveVersion != 19 and privateSaveVersion != 20 and
      privateSaveVersion != PRIVATE_VERSION then
    return error(3873, "unsupported private BaseQ2 save version")
  end if
  entityString = ""
  if privateSaveVersion >= 9 then
    privateEntityLength = privatechecked.readLong(buffer,
      "private entity string length")
    if privateEntityLength < 0 or privateEntityLength > 16 * 1024 * 1024 then
      return error(3889, "private entity string length outside bound")
    end if
    privatechecked.require(buffer, privateEntityLength,
      "private entity string")
    entityString = decode(privatemessage.readData(buffer, privateEntityLength))
  else
    entityString = privatemessage.readString(buffer)
  end if
  spawnPoint = privatemessage.readString(buffer)
  privateSavedSkill = 1
  if privateSaveVersion >= 8 then
    privateSavedSkill = privatechecked.readLong(buffer, "private skill")
    if privateSavedSkill < 0 or privateSavedSkill > 3 then
      return error(3888, "private skill outside [0,3]")
    end if
  end if
  privateSavedRandomSeed = 1
  if privateSaveVersion >= 11 then
    privateSavedRandomSeed = privatechecked.readLong(buffer, "private random seed")
  end if
  spawnResult = privatespawn.SpawnEntitiesForMode(mapName, entityString,
    spawnPoint, privateSavedSkill, playerContext.deathmatch)
  restoredBaseEdicts = spawnResult.edicts
  index = 0
  while index < len(restoredBaseEdicts)
    number = 0
    if index > 0 then
      if privateSaveVersion >= 19 then
        number = maxClients + privateplayerconstants.BODY_QUEUE_SIZE + index
      else number = maxClients + index
      end if
    end if
    restoredBaseEdict = restoredBaseEdicts[index]
    restoredEngineEdict = restoredBaseEdict.edict
    restoredBaseEdict.number = number
    restoredEngineEdict.state.number = number
    index = index + 1
  end while
  runtime = privateintegration.create(spawnResult)
  // Reference reconstruction below uses the live registry and reserved client
  // slots. Bind the player context before restoring projectiles and AI links.
  runtime.playerContext = playerContext
  privateintegration.initializeEdictAllocator(runtime, exportTable, maxClients)
  runtime.aiContext.skill = privateSavedSkill
  runtime.randomState.seed = privateSavedRandomSeed
  runtime.exportTable = exportTable
  runtime.world.time = privateReadFloat(buffer, "private world time")
  runtime.world.serverFlags = privatechecked.readLong(buffer, "private server flags")
  runtime.world.totalSecrets = privatechecked.readLong(buffer, "private total secrets"); runtime.world.foundSecrets = privatechecked.readLong(buffer, "private found secrets")
  runtime.world.totalGoals = privatechecked.readLong(buffer, "private total goals"); runtime.world.foundGoals = privatechecked.readLong(buffer, "private found goals")
  runtime.world.intermission = privateReadBool(buffer, "private intermission")
  privateSavedBodyQueueIndex = 0
  if privateSaveVersion >= 19 then
    privateSavedBodyQueueIndex = privatechecked.readLong(buffer,
      "private body queue index")
    if privateSavedBodyQueueIndex < 0 or
        privateSavedBodyQueueIndex >= privateplayerconstants.BODY_QUEUE_SIZE then
      return error(3893, "private body queue index outside ring")
    end if
    privateFreeTimeCount = privatechecked.readLong(buffer,
      "private edict free-time count")
    if privateFreeTimeCount < 0 or
        privateFreeTimeCount > exportTable.numEdicts then
      return error(3894, "private edict free-time count outside table")
    end if
    privateFreeTimeIndex = 0
    while privateFreeTimeIndex < privateFreeTimeCount
      runtime.edictFreeTimes[privateFreeTimeIndex] = privateReadFloat(buffer,
        "private edict free time")
      privateFreeTimeIndex = privateFreeTimeIndex + 1
    end while
  end if

  privateSavedSightClientNumber = -1
  privateSavedSightEntityNumber = -1
  privateSavedSightEntityFrame = -1000
  privateSavedSoundEntityNumber = -1
  privateSavedSoundEntityFrame = -1000
  privateSavedSound2EntityNumber = -1
  privateSavedSound2EntityFrame = -1000
  privateNoiseReferences = []
  if privateSaveVersion >= 21 then
    privateSavedSightClientNumber = privatechecked.readLong(buffer,
      "private sight client")
    privateSavedSightEntityNumber = privatechecked.readLong(buffer,
      "private sight entity")
    privateSavedSightEntityFrame = privatechecked.readLong(buffer,
      "private sight entity frame")
    privateSavedSoundEntityNumber = privatechecked.readLong(buffer,
      "private sound entity")
    privateSavedSoundEntityFrame = privatechecked.readLong(buffer,
      "private sound entity frame")
    privateSavedSound2EntityNumber = privatechecked.readLong(buffer,
      "private secondary sound entity")
    privateSavedSound2EntityFrame = privatechecked.readLong(buffer,
      "private secondary sound entity frame")
    privateNoiseCount = privatechecked.readLong(buffer,
      "private player noise count")
    if privateNoiseCount < 0 or privateNoiseCount > maxClients then
      return error(3904, "private player noise count outside client bound")
    end if
    while privateNoiseCount > 0
      privateNoiseOwnerNumber = privatechecked.readLong(buffer,
        "private player noise owner")
      privateNoisePrimaryPresent = privateReadBool(buffer,
        "private primary noise marker")
      privateNoisePrimaryOrigin = miniquake2.qcommon.types.Vec3(0.0, 0.0, 0.0)
      privateNoisePrimaryTeleport = 0.0
      privateNoisePrimaryArea = 0
      privateNoisePrimaryInUse = false
      if privateNoisePrimaryPresent then
        privateNoisePrimaryOrigin = privateReadVec(buffer,
          "private primary noise origin")
        privateNoisePrimaryTeleport = privateReadFloat(buffer,
          "private primary noise time")
        privateNoisePrimaryArea = privatechecked.readLong(buffer,
          "private primary noise area")
        privateNoisePrimaryInUse = privateReadBool(buffer,
          "private primary noise inuse")
      end if
      privateNoiseSecondaryPresent = privateReadBool(buffer,
        "private secondary noise marker")
      privateNoiseSecondaryOrigin = miniquake2.qcommon.types.Vec3(0.0, 0.0, 0.0)
      privateNoiseSecondaryTeleport = 0.0
      privateNoiseSecondaryArea = 0
      privateNoiseSecondaryInUse = false
      if privateNoiseSecondaryPresent then
        privateNoiseSecondaryOrigin = privateReadVec(buffer,
          "private secondary noise origin")
        privateNoiseSecondaryTeleport = privateReadFloat(buffer,
          "private secondary noise time")
        privateNoiseSecondaryArea = privatechecked.readLong(buffer,
          "private secondary noise area")
        privateNoiseSecondaryInUse = privateReadBool(buffer,
          "private secondary noise inuse")
      end if
      privateNoiseReferences = privateNoiseReferences + [PrivateNoiseReference(
        privateNoiseOwnerNumber, privateNoisePrimaryPresent,
        privateNoisePrimaryOrigin, privateNoisePrimaryTeleport,
        privateNoisePrimaryArea, privateNoisePrimaryInUse,
        privateNoiseSecondaryPresent, privateNoiseSecondaryOrigin,
        privateNoiseSecondaryTeleport, privateNoiseSecondaryArea,
        privateNoiseSecondaryInUse)]
      privateNoiseCount = privateNoiseCount - 1
    end while
  end if

  worldCount = privatechecked.readLong(buffer, "private world count")
  if worldCount < len(runtime.world.entities) then return error(3874, "private world entity count mismatch") end if
  privateWorldReferences = []
  privateDecodedWorldEntities = []
  while worldCount > 0
    number = privatechecked.readLong(buffer, "private world number")
    className = privatemessage.readString(buffer)
    modelName = privatemessage.readString(buffer)
    modelIndex = privatechecked.readLong(buffer, "private world model index")
    privateWorldInUse = privateReadBool(buffer, "private world inuse")
    privateWorldTarget = ""; privateWorldTargetName = ""
    privateWorldKillTarget = ""; privateWorldPathTarget = ""
    privateWorldTeam = ""; privateWorldMessage = ""; privateWorldMap = ""
    privateWorldItem = ""; privateWorldItemName = ""
    privateWorldItemIsText = true
    privateWorldActivatorNumber = -1
    privateWorldOwnerNumber = -1; privateWorldTeamMasterNumber = -1
    privateWorldTeamChainNumber = -1; privateWorldTargetEntityNumber = -1
    privateWorldEnemyNumber = -1; privateWorldOldEnemyNumber = -1
    privateWorldGroundEntityNumber = -1
    privateWorldDelay = 0.0; privateWorldWait = 0.0; privateWorldSpeed = 0.0
    if privateSaveVersion >= 10 then
      privateWorldTarget = privatemessage.readString(buffer)
      privateWorldTargetName = privatemessage.readString(buffer)
      privateWorldKillTarget = privatemessage.readString(buffer)
      privateWorldPathTarget = privatemessage.readString(buffer)
      privateWorldTeam = privatemessage.readString(buffer)
      privateWorldMessage = privatemessage.readString(buffer)
      privateWorldMap = privatemessage.readString(buffer)
      privateWorldItemIsText = privateReadBool(buffer,
        "private world item text marker")
      privateWorldItem = privatemessage.readString(buffer)
      privateWorldItemName = privatemessage.readString(buffer)
      privateWorldActivatorNumber = privatechecked.readLong(buffer,
        "private world activator")
      privateWorldOwnerNumber = privatechecked.readLong(buffer,
        "private world owner")
      privateWorldTeamMasterNumber = privatechecked.readLong(buffer,
        "private world team master")
      privateWorldTeamChainNumber = privatechecked.readLong(buffer,
        "private world team chain")
      privateWorldTargetEntityNumber = privatechecked.readLong(buffer,
        "private world target entity")
      privateWorldEnemyNumber = privatechecked.readLong(buffer,
        "private world enemy")
      privateWorldOldEnemyNumber = privatechecked.readLong(buffer,
        "private world old enemy")
      privateWorldGroundEntityNumber = privatechecked.readLong(buffer,
        "private world ground entity")
      privateWorldDelay = privateReadFloat(buffer, "private world delay")
      privateWorldWait = privateReadFloat(buffer, "private world wait")
      privateWorldSpeed = privateReadFloat(buffer, "private world speed")
    end if
    entity = void
    for each privateWorldCandidate in runtime.world.entities
      privateWorldCandidateDecoded = false
      for each privateDecodedWorldEntity in privateDecodedWorldEntities
        if nativeRawValue(privateWorldCandidate) ==
            nativeRawValue(privateDecodedWorldEntity) then
          privateWorldCandidateDecoded = true
        end if
      end for
      if not privateWorldCandidateDecoded and
          privateWorldCandidate.number == number and
          privateWorldCandidate.className == className then
        entity = privateWorldCandidate
        break
      end if
    end for
    if entity is void then
      if className != "monster_gib" and className != "body_gib" and
          className != "debris" and className != "bodyque" and
          className != "DelayedUse" and
          privateWorldInUse then
        return error(3875, "active private world entity missing at " + number +
          ": saved=" + className)
      end if
      privateDynamicWorldHolder = privateworldtypes.createEntity(number, className)
      privateworldcore.addEntity(runtime.world, privateDynamicWorldHolder)
      entity = privateDynamicWorldHolder
    else if entity.className != className then
      return error(3887, "private world classname mismatch at " + number +
        ": saved=" + className + " restored=" + entity.className)
    end if
    entity.model = modelName; entity.modelIndex = modelIndex
    entity.inUse = privateWorldInUse
    if privateSaveVersion >= 10 then
      entity.target = privateWorldTarget; entity.targetName = privateWorldTargetName
      entity.killTarget = privateWorldKillTarget; entity.pathTarget = privateWorldPathTarget
      entity.team = privateWorldTeam; entity.message = privateWorldMessage
      entity.map = privateWorldMap
      if privateWorldItemIsText then entity.item = privateWorldItem end if
      entity.itemName = privateWorldItemName
      entity.delay = privateWorldDelay; entity.wait = privateWorldWait
      entity.speed = privateWorldSpeed
    end if
    entity.origin = privateReadVec(buffer, "private world origin"); entity.angles = privateReadVec(buffer, "private world angles"); entity.oldOrigin = privateReadVec(buffer, "private world old origin")
    entity.velocity = privateReadVec(buffer, "private world velocity"); entity.angularVelocity = privateReadVec(buffer, "private world angular velocity")
    entity.health = privatechecked.readLong(buffer, "private world health"); entity.maxHealth = privatechecked.readLong(buffer, "private world max health")
    entity.solid = privatechecked.readLong(buffer, "private world solid"); entity.moveType = privatechecked.readLong(buffer, "private world movetype")
    entity.effects = privatechecked.readLong(buffer, "private world effects"); entity.renderFx = privatechecked.readLong(buffer, "private world renderfx")
    entity.frame = privatechecked.readLong(buffer, "private world frame"); entity.loopSound = privatechecked.readLong(buffer, "private world sound")
    entity.count = privatechecked.readLong(buffer, "private world count field"); entity.spawnFlags = privatechecked.readLong(buffer, "private world spawnflags")
    entity.nextThink = privateReadFloat(buffer, "private world nextthink"); entity.touchDebounceTime = privateReadFloat(buffer, "private world debounce")
    entity.moveInfo.state = privatechecked.readLong(buffer, "private mover state")
    entity.moveInfo.currentSpeed = privateReadFloat(buffer, "private mover speed"); entity.moveInfo.remainingDistance = privateReadFloat(buffer, "private mover remaining")
    entity.moveInfo.direction = privateReadVec(buffer, "private mover direction")
    entity.moveInfo.startOrigin = privateReadVec(buffer, "private mover start"); entity.moveInfo.endOrigin = privateReadVec(buffer, "private mover end")
    entity.moveInfo.startAngles = privateReadVec(buffer, "private mover start angles"); entity.moveInfo.endAngles = privateReadVec(buffer, "private mover end angles")
    if privateSaveVersion >= 13 then
      entity.flags = privatechecked.readLong(buffer, "private world flags")
      entity.serverFlags = privatechecked.readLong(buffer, "private world server flags")
      entity.takeDamage = privatechecked.readLong(buffer, "private world take damage")
      entity.gibHealth = privatechecked.readLong(buffer, "private world gib health")
      entity.clipMask = privatechecked.readLong(buffer, "private world clip mask")
      entity.aiFlags = privatechecked.readLong(buffer, "private world AI flags")
      entity.timestamp = privateReadFloat(buffer, "private world trail time")
      entity.pauseTime = privateReadFloat(buffer, "private world attack finished")
    end if
    if privateSaveVersion >= 16 then
      entity.gravity = privateReadFloat(buffer, "private world gravity")
      entity.oldVelocity = privateReadVec(buffer, "private world old velocity")
      entity.flySoundDebounceTime = privateReadFloat(buffer,
        "private world fly sound debounce")
    end if
    if privateSaveVersion >= 17 then
      entity.waterType = privatechecked.readLong(buffer, "private world water type")
      entity.waterLevel = privatechecked.readLong(buffer, "private world water level")
    end if
    if privateSaveVersion >= 19 then
      entity.mins = privateReadVec(buffer, "private world mins")
      entity.maxs = privateReadVec(buffer, "private world maxs")
      entity.style = privatechecked.readLong(buffer, "private world style")
    end if
    if entity.className == "monster_gib" or entity.className == "body_gib" then
      entity.think = privateworldcore.freeThink
      entity.die = privateworldmisc.gibDie
    else if entity.className == "debris" then
      entity.think = privateworldcore.freeThink
      entity.die = privateworldmisc.debrisDie
    else if entity.className == "DelayedUse" then entity.think = privateworldcore.thinkDelayed
    else privatemovers.restoreMoverState(entity, runtime.world) end if
    privateWorldReferences = privateWorldReferences + [
      PrivateWorldReference(entity, privateWorldActivatorNumber,
        privateWorldOwnerNumber, privateWorldTeamMasterNumber,
        privateWorldTeamChainNumber, privateWorldTargetEntityNumber,
        privateWorldEnemyNumber, privateWorldOldEnemyNumber,
        privateWorldGroundEntityNumber)]
    privateDecodedWorldEntities = privateDecodedWorldEntities + [entity]
    if entity.number >= runtime.world.nextEntityNumber then runtime.world.nextEntityNumber = entity.number + 1 end if
    worldCount = worldCount - 1
  end while

  monsterCount = privatechecked.readLong(buffer, "private monster count")
  if monsterCount < len(runtime.monsters) then return error(3876, "private monster count mismatch") end if
  privateMonsterReferences = []
  privateDecodedMonsters = []
  privateMonstersRemaining = monsterCount
  privateMonsterRegistryHolder = privatesaveaiarchetypes.defaultRegistry()
  while privateMonstersRemaining > 0
    privateMonsterNumber = privatechecked.readLong(buffer, "private monster number")
    privateMonsterClassName = privatemessage.readString(buffer)
    privateMonsterInUse = privateReadBool(buffer, "private monster inuse")
    // A freed slot may already belong to a later live record. Match each saved
    // record once so an inactive historical actor cannot claim that live slot.
    actor = void
    for each privateMonsterCandidate in runtime.monsters
      privateMonsterCandidateDecoded = false
      for each privateDecodedMonster in privateDecodedMonsters
        if nativeRawValue(privateMonsterCandidate) ==
            nativeRawValue(privateDecodedMonster) then
          privateMonsterCandidateDecoded = true
        end if
      end for
      if not privateMonsterCandidateDecoded and
          privateMonsterCandidate.edict.state.number == privateMonsterNumber and
          privateMonsterCandidate.className == privateMonsterClassName then
        actor = privateMonsterCandidate
        break
      end if
    end for
    if actor is void then
      if privateMonsterNumber <= 0 or privateMonsterNumber >= exportTable.numEdicts then return error(3877, "private dynamic monster outside edict table") end if
      if privatesaveaiarchetypes.find(privateMonsterRegistryHolder, privateMonsterClassName) is void then return error(3883, "private dynamic monster class is unavailable") end if
      privateDynamicActorHolder = privatesaveaiarchetypes.SpawnMonster(privateMonsterRegistryHolder, privateMonsterClassName, privateMonsterNumber, runtime.aiContext)
      privateintegration.prepareMonsterRuntimeState(privateDynamicActorHolder)
      runtime.monsters = runtime.monsters + [privateDynamicActorHolder]
      actor = privateDynamicActorHolder
      if privateMonsterNumber >= runtime.world.nextEntityNumber then runtime.world.nextEntityNumber = privateMonsterNumber + 1 end if
    end if
    if privateMonsterInUse then
      actor.edict = exportTable.edicts[privateMonsterNumber]
    else
      actor.edict = privatesavegametypes.zeroEdict(privateMonsterNumber)
    end if
    privatesavegametypes.stabilizeEdict(actor.edict)
    actor.edict.inUse = privateMonsterInUse
    actor.health = privatechecked.readLong(buffer, "private monster health"); actor.maxHealth = privatechecked.readLong(buffer, "private monster max health")
    actor.deadFlag = privatechecked.readLong(buffer, "private monster deadflag"); actor.flags = privatechecked.readLong(buffer, "private monster flags")
    actor.moveType = privatechecked.readLong(buffer, "private monster movetype"); actor.takeDamage = privatechecked.readLong(buffer, "private monster takedamage")
    actor.nextThink = privateReadFloat(buffer, "private monster nextthink"); actor.info.attackFinished = privateReadFloat(buffer, "private monster attack time")
    actor.painCount = privatechecked.readLong(buffer, "private monster pain count"); actor.dieCount = privatechecked.readLong(buffer, "private monster die count")
    actor.attackCount = privatechecked.readLong(buffer, "private monster attack count"); actor.meleeCount = privatechecked.readLong(buffer, "private monster melee count")
    actor.reactionDebounce = privateReadFloat(buffer, "private monster reaction debounce")
    actor.info.nextFrame = privatechecked.readLong(buffer, "private monster attack event")
    actor.info.pauseTime = privateReadFloat(buffer, "private monster attack pause")
    actor.info.attackState = privatechecked.readLong(buffer, "private monster attack state")
    actor.edict.state.frame = privatechecked.readLong(buffer, "private monster frame"); actor.activity = privatemessage.readString(buffer)
    if actor.className == "misc_actor" then privatesaveactor.restoreMove(actor, actor.activity)
    else if actor.className == "misc_insane" then privatesaveinsane.restoreMove(actor, actor.activity) end if
    if privatesaveaiprops.isProp(actor) then privatesaveaiprops.restorePhase(actor) end if
    actor.target = privatemessage.readString(buffer); actor.targetName = privatemessage.readString(buffer)
    actor.deathTarget = privatemessage.readString(buffer); actor.combatTarget = privatemessage.readString(buffer)
    privateMonsterOriginHolder = privateReadVec(buffer, "private monster origin")
    privateMonsterAnglesHolder = privateReadVec(buffer, "private monster angles")
    privateMonsterOldOriginHolder = privateReadVec(buffer, "private monster old origin")
    actor.edict.state.origin = privateMonsterOriginHolder; actor.edict.state.angles = privateMonsterAnglesHolder; actor.edict.state.oldOrigin = privateMonsterOldOriginHolder
    actor.thinkKind = privatemessage.readString(buffer)
    actor.deathUseComplete = privateReadBool(buffer, "private monster death use")
    actor.bossPhase = privatemessage.readString(buffer); actor.successorClassName = privatemessage.readString(buffer)
    actor.successorDueTime = privateReadFloat(buffer, "private monster successor time")
    actor.successorSpawned = privateReadBool(buffer, "private monster successor spawned")
    if privateSaveVersion >= 11 then
      actor.attackAim = privateReadVec(buffer, "private monster attack aim")
      actor.attackAimValid = privateReadBool(buffer, "private monster attack aim valid")
      actor.attackCycles = privatechecked.readLong(buffer, "private monster attack cycles")
    else
      actor.attackAimValid = false
      actor.attackCycles = 0
    end if
    privateMonsterOldEnemyNumber = -1
    privateMonsterOwnerNumber = -1
    if privateSaveVersion >= 12 then
      actor.info.aiFlags = privatechecked.readLong(buffer,
        "private monster AI flags")
      privateMonsterOldEnemyNumber = privatechecked.readLong(buffer,
        "private monster old enemy")
      privateMonsterOwnerNumber = privatechecked.readLong(buffer,
        "private monster owner")
    end if
    privatesavegametypes.stabilizeEdict(actor.edict)
    enemyNumber = privatechecked.readLong(buffer, "private monster enemy")
    // -2 means the legacy record had no serialized reference field; -1 is a
    // v14 field explicitly containing NULL.
    privateMonsterGoalEntityNumber = -2
    privateMonsterMoveTargetNumber = -2
    if privateSaveVersion >= 14 then
      actor.info.searchTime = privateReadFloat(buffer,
        "private monster search time")
      actor.info.idleTime = privateReadFloat(buffer,
        "private monster idle time")
      privateMonsterLastSightingHolder = privateReadVec(buffer,
        "private monster last sighting")
      actor.info.lastSighting[0] = privateMonsterLastSightingHolder.x
      actor.info.lastSighting[1] = privateMonsterLastSightingHolder.y
      actor.info.lastSighting[2] = privateMonsterLastSightingHolder.z
      privateMonsterSavedGoalHolder = privateReadVec(buffer,
        "private monster saved goal")
      actor.info.savedGoal[0] = privateMonsterSavedGoalHolder.x
      actor.info.savedGoal[1] = privateMonsterSavedGoalHolder.y
      actor.info.savedGoal[2] = privateMonsterSavedGoalHolder.z
      actor.info.trailTime = privateReadFloat(buffer,
        "private monster trail time")
      actor.idealYaw = privateReadFloat(buffer, "private monster ideal yaw")
      actor.info.lefty = privatechecked.readLong(buffer,
        "private monster strafe side")
      actor.showHostile = privateReadFloat(buffer,
        "private monster hostile time")
      actor.velocity = privateReadVec(buffer, "private monster velocity")
      privateMonsterGoalEntityNumber = privatechecked.readLong(buffer,
        "private monster goal entity")
      privateMonsterMoveTargetNumber = privatechecked.readLong(buffer,
        "private monster move target")
    end if
    if privateSaveVersion >= 16 then
      actor.airFinished = privateReadFloat(buffer,
        "private monster air finished")
      actor.painDebounceTime = privateReadFloat(buffer,
        "private monster pain debounce")
      actor.damageDebounceTime = privateReadFloat(buffer,
        "private monster damage debounce")
      actor.powerArmorTime = privateReadFloat(buffer,
        "private monster power armor time")
      actor.powerArmorType = privatechecked.readLong(buffer,
        "private monster power armor type")
      actor.powerArmorPower = privatechecked.readLong(buffer,
        "private monster power armor power")
      actor.gravity = privateReadFloat(buffer, "private monster gravity")
    end if
    privateMonsterReferences = privateMonsterReferences + [PrivateMonsterReference(
      actor, enemyNumber, privateMonsterOldEnemyNumber, privateMonsterOwnerNumber,
      privateMonsterGoalEntityNumber, privateMonsterMoveTargetNumber)]
    privateDecodedMonsters = privateDecodedMonsters + [actor]
    privateMonstersRemaining = privateMonstersRemaining - 1
  end while
  if len(runtime.monsters) != monsterCount then return error(3885, "private restored monster count mismatch") end if
  for each privateMonsterReference in privateMonsterReferences
    privateMonsterReference.actor.enemy = privateRestoreEnemy(runtime, privateMonsterReference.enemyNumber, maxClients, exportTable)
    privateMonsterReference.actor.oldEnemy = privateRestoreEnemy(runtime,
      privateMonsterReference.oldEnemyNumber, maxClients, exportTable)
    privateMonsterReference.actor.owner = privateRestoreEnemy(runtime,
      privateMonsterReference.ownerNumber, maxClients, exportTable)
    if privateMonsterReference.goalEntityNumber != -2 then
      if privateMonsterReference.goalEntityNumber ==
          privateMonsterReference.enemyNumber then
        privateMonsterReference.actor.goalEntity = privateMonsterReference.actor.enemy
      else
        privateMonsterReference.actor.goalEntity = privateRestoreAIReference(runtime,
          privateMonsterReference.goalEntityNumber, maxClients, exportTable)
      end if
    end if
    if privateMonsterReference.moveTargetNumber != -2 then
      if privateMonsterReference.moveTargetNumber ==
          privateMonsterReference.enemyNumber then
        privateMonsterReference.actor.moveTarget = privateMonsterReference.actor.enemy
      else
        privateMonsterReference.actor.moveTarget = privateRestoreAIReference(runtime,
          privateMonsterReference.moveTargetNumber, maxClients, exportTable)
      end if
    end if
  end for

  itemCount = privatechecked.readLong(buffer, "private item count")
  if privateSaveVersion < 16 and itemCount != len(runtime.items) then return error(3878, "private item count mismatch") end if
  privateItemOwners = []
  privateItemOwnerNumbers = []
  privateItemGrounds = []
  privateItemGroundNumbers = []
  privateDecodedItems = []
  while itemCount > 0
    privateItemNumber = privatechecked.readLong(buffer, "private item number")
    privateItemIndex = 0
    if privateSaveVersion >= 16 then
      privateItemIndex = privatechecked.readLong(buffer, "private item definition")
    end if
    privateItemInUse = privateReadBool(buffer, "private item inuse")
    // Preserve duplicate historical slot identities just as the monster restore
    // path does; only an active record may bind the shared engine-edict entry.
    itemEntity = void
    for each privateItemCandidate in runtime.items
      privateItemCandidateDecoded = false
      for each privateDecodedItem in privateDecodedItems
        if nativeRawValue(privateItemCandidate) ==
            nativeRawValue(privateDecodedItem) then
          privateItemCandidateDecoded = true
        end if
      end for
      if not privateItemCandidateDecoded and
          privateItemCandidate.edict.state.number == privateItemNumber and
          (privateSaveVersion < 16 or
            privateItemCandidate.item.index == privateItemIndex) then
        itemEntity = privateItemCandidate
        break
      end if
    end for
    if itemEntity is void and privateSaveVersion >= 16 then
      if privateItemNumber < 0 or privateItemNumber >= exportTable.numEdicts then
        return error(3879, "private dynamic item outside edict table")
      end if
      privateItemDefinition = itemByIndex(playerContext.registry,
        privateItemIndex)
      if privateItemDefinition is void then
        return error(3879, "private dynamic item definition missing")
      end if
      itemEntity = privategameplaytypes.createItemEntity(privateItemNumber,
        privateItemDefinition)
      itemEntity.edict = exportTable.edicts[privateItemNumber]
      runtime.items = runtime.items + [itemEntity]
    end if
    if itemEntity is void then return error(3879, "private item missing") end if
    if privateSaveVersion >= 16 and itemEntity.item.index != privateItemIndex then
      return error(3879, "private item definition mismatch")
    end if
    if privateItemInUse and privateItemNumber >= 0 and
        privateItemNumber < exportTable.numEdicts then
      itemEntity.edict = exportTable.edicts[privateItemNumber]
    else if not privateItemInUse then
      itemEntity.edict = privatesavegametypes.zeroEdict(privateItemNumber)
    end if
    privatesavegametypes.stabilizeEdict(itemEntity.edict)
    itemEntity.edict.inUse = privateItemInUse
    itemEntity.hidden = privateReadBool(buffer, "private item hidden"); itemEntity.freed = privateReadBool(buffer, "private item freed"); itemEntity.decaying = privateReadBool(buffer, "private item decaying")
    itemEntity.count = privatechecked.readLong(buffer, "private item count field"); itemEntity.spawnFlags = privatechecked.readLong(buffer, "private item spawnflags")
    itemEntity.nextThink = privateReadFloat(buffer, "private item nextthink"); itemEntity.respawnAt = privateReadFloat(buffer, "private item respawn")
    if privateSaveVersion >= 16 then
      itemEntity.velocity = privateReadVec(buffer, "private item velocity")
      privateItemOwners = privateItemOwners + [itemEntity]
      privateItemOwnerNumbers = privateItemOwnerNumbers + [
        privatechecked.readLong(buffer, "private item owner")]
      itemEntity.spawnPending = privateReadBool(buffer,
        "private item spawn pending")
    end if
    if privateSaveVersion >= 21 then
      privateItemGrounds = privateItemGrounds + [itemEntity]
      privateItemGroundNumbers = privateItemGroundNumbers + [
        privatechecked.readLong(buffer, "private item ground entity")]
      itemEntity.groundLinkCount = privatechecked.readLong(buffer,
        "private item ground link count")
      itemEntity.gravity = privateReadFloat(buffer, "private item gravity")
      itemEntity.waterType = privatechecked.readLong(buffer,
        "private item water type")
      itemEntity.waterLevel = privatechecked.readLong(buffer,
        "private item water level")
    end if
    privateDecodedItems = privateDecodedItems + [itemEntity]
    itemCount = itemCount - 1
  end while

  // Version 21 adds the active projectile edicts between items and clients.
  // Older payloads intentionally resume without missiles, matching their
  // historical writer rather than attempting to infer transient entities.
  runtime.weaponContext.projectiles = []
  runtime.weaponContext.nextProjectileNumber = 1
  privateProjectileReferences = []
  if privateSaveVersion >= 21 then
    privateProjectileCount = privatechecked.readLong(buffer,
      "private projectile count")
    if privateProjectileCount < 0 or privateProjectileCount > exportTable.numEdicts then
      return error(3895, "private projectile count outside edict table")
    end if
    while privateProjectileCount > 0
      privateProjectileNumber = privatechecked.readLong(buffer,
        "private projectile number")
      privateProjectileEngineNumber = privatechecked.readLong(buffer,
        "private projectile engine number")
      if privateProjectileEngineNumber < 0 or
          privateProjectileEngineNumber >= exportTable.numEdicts then
        return error(3896, "private projectile outside edict table")
      end if
      projectile = privatesaveweapontypes.createProjectile(
        privateProjectileNumber, "")
      projectile.engineNumber = privateProjectileEngineNumber
      projectile.inUse = privateReadBool(buffer, "private projectile inuse")
      projectile.className = privatemessage.readString(buffer)
      projectile.origin = privateReadVec(buffer, "private projectile origin")
      projectile.oldOrigin = privateReadVec(buffer, "private projectile old origin")
      projectile.angles = privateReadVec(buffer, "private projectile angles")
      projectile.velocity = privateReadVec(buffer, "private projectile velocity")
      projectile.angularVelocity = privateReadVec(buffer,
        "private projectile angular velocity")
      projectile.mins = privateReadVec(buffer, "private projectile mins")
      projectile.maxs = privateReadVec(buffer, "private projectile maxs")
      privateProjectileOwnerNumber = privatechecked.readLong(buffer,
        "private projectile owner")
      privateProjectileEnemyNumber = privatechecked.readLong(buffer,
        "private projectile enemy")
      projectile.moveType = privatechecked.readLong(buffer,
        "private projectile movetype")
      projectile.clipMask = privatechecked.readLong(buffer,
        "private projectile clipmask")
      projectile.solid = privatechecked.readLong(buffer,
        "private projectile solid")
      projectile.effects = privatechecked.readLong(buffer,
        "private projectile effects")
      projectile.modelName = privatemessage.readString(buffer)
      projectile.soundName = privatemessage.readString(buffer)
      projectile.modelIndex = privatechecked.readLong(buffer,
        "private projectile model index")
      projectile.soundIndex = privatechecked.readLong(buffer,
        "private projectile sound index")
      projectile.spawnFlags = privatechecked.readLong(buffer,
        "private projectile spawnflags")
      projectile.damage = privatechecked.readLong(buffer,
        "private projectile damage")
      projectile.radiusDamage = privatechecked.readLong(buffer,
        "private projectile radius damage")
      projectile.damageRadius = privateReadFloat(buffer,
        "private projectile damage radius")
      projectile.waterType = privatechecked.readLong(buffer,
        "private projectile water type")
      projectile.waterLevel = privatechecked.readLong(buffer,
        "private projectile water level")
      projectile.gravity = privateReadFloat(buffer, "private projectile gravity")
      privateProjectileGroundNumber = privatechecked.readLong(buffer,
        "private projectile ground entity")
      projectile.nextThink = privateReadFloat(buffer,
        "private projectile nextthink")
      projectile.frame = privatechecked.readLong(buffer,
        "private projectile frame")
      privateProjectileTouchName = privatemessage.readString(buffer)
      privateProjectileThinkName = privatemessage.readString(buffer)
      if privateProjectileTouchName == "blaster" then
        projectile.touch = privatesaveprojectiles.blasterTouch
      else if privateProjectileTouchName == "grenade" then
        projectile.touch = privatesaveprojectiles.grenadeTouch
      else if privateProjectileTouchName == "rocket" then
        projectile.touch = privatesaveprojectiles.rocketTouch
      else if privateProjectileTouchName == "bfg" then
        projectile.touch = privatesaveprojectiles.bfgTouch
      else if privateProjectileTouchName != "" then
        return error(3897, "private projectile touch callback unsupported")
      end if
      if privateProjectileThinkName == "free" then
        projectile.think = privatesaveweaponcore.freeThink
      else if privateProjectileThinkName == "grenade-explode" then
        projectile.think = privatesaveprojectiles.grenadeExplode
      else if privateProjectileThinkName == "bfg-think" then
        projectile.think = privatesaveprojectiles.bfgThink
      else if privateProjectileThinkName == "bfg-explode" then
        projectile.think = privatesaveprojectiles.bfgExplode
      else if privateProjectileThinkName != "" then
        return error(3898, "private projectile think callback unsupported")
      end if
      runtime.weaponContext.projectiles = runtime.weaponContext.projectiles +
        [projectile]
      if privateProjectileNumber >= runtime.weaponContext.nextProjectileNumber then
        runtime.weaponContext.nextProjectileNumber = privateProjectileNumber + 1
      end if
      privateProjectileReferences = privateProjectileReferences + [
        PrivateProjectileReference(projectile, privateProjectileOwnerNumber,
          privateProjectileEnemyNumber, privateProjectileGroundNumber,
          privateProjectileTouchName, privateProjectileThinkName)]
      privateProjectileCount = privateProjectileCount - 1
    end while
  end if

  playerContext.players = []
  privatePlayerChasePlayers = []
  privatePlayerChaseNumbers = []
  playerCount = privatechecked.readLong(buffer, "private player count")
  while playerCount > 0
    number = privatechecked.readLong(buffer, "private player number")
    if number <= 0 or number >= exportTable.numEdicts then return error(3880, "private player outside edict table") end if
    player = privateplayers.createPlayer(number, playerContext.registry)
    player.edict = exportTable.edicts[number]; player.gameplay.edict = player.edict
    player.health = privatechecked.readLong(buffer, "private player health"); player.maxHealth = privatechecked.readLong(buffer, "private player max health")
    player.persistent.userInfo = privatemessage.readString(buffer); player.persistent.netName = privatemessage.readString(buffer); player.persistent.skin = privatemessage.readString(buffer)
    player.persistent.connected = privateReadBool(buffer, "private player connected"); player.persistent.spectator = privateReadBool(buffer, "private player spectator")
    player.persistent.score = privatechecked.readLong(buffer, "private player score"); player.respawn.score = privatechecked.readLong(buffer, "private player respawn score")
    if privateSaveVersion >= 19 then
      player.persistent.gameHelpChanged = privatechecked.readLong(buffer,
        "private player game help counter")
      player.persistent.helpChanged = privatechecked.readLong(buffer,
        "private player help reminder counter")
    end if
    inventoryCount = privatechecked.readLong(buffer, "private inventory count")
    if inventoryCount != len(player.gameplay.inventory.counts) then return error(3881, "private inventory size mismatch") end if
    inventoryIndex = 0
    while inventoryIndex < inventoryCount
      player.gameplay.inventory.counts[inventoryIndex] = privatechecked.readLong(buffer, "private inventory value")
      inventoryIndex = inventoryIndex + 1
    end while
    player.gameplay.currentWeapon = itemByIndex(playerContext.registry, privatechecked.readLong(buffer, "private current weapon"))
    player.gameplay.lastWeapon = itemByIndex(playerContext.registry, privatechecked.readLong(buffer, "private last weapon"))
    player.gameplay.newWeapon = itemByIndex(playerContext.registry, privatechecked.readLong(buffer, "private new weapon"))
    player.gameplay.ammoIndex = privatechecked.readLong(buffer, "private ammo index"); player.gameplay.weaponState = privatechecked.readLong(buffer, "private weapon state"); player.gameplay.gunFrame = privatechecked.readLong(buffer, "private gun frame")
    player.powerups.quadFrame = privatechecked.readLong(buffer, "private quad"); player.powerups.invincibleFrame = privatechecked.readLong(buffer, "private invincible")
    player.powerups.enviroFrame = privatechecked.readLong(buffer, "private enviro"); player.powerups.breatherFrame = privatechecked.readLong(buffer, "private breather")
    player.armorItemIndex = privatechecked.readLong(buffer, "private armor item"); player.flags = privatechecked.readLong(buffer, "private player flags")
    if privateSaveVersion >= 15 then
      player.floodWhenHead = privatechecked.readLong(buffer,
        "private flood head")
      if player.floodWhenHead < 0 or
          player.floodWhenHead >= len(player.floodWhen) then
        return error(3890, "private flood head outside ring")
      end if
      player.floodLockTill = privateReadFloat(buffer, "private flood lock")
      privateFloodIndex = 0
      while privateFloodIndex < len(player.floodWhen)
        player.floodWhen[privateFloodIndex] = privateReadFloat(buffer,
          "private flood timestamp")
        privateFloodIndex = privateFloodIndex + 1
      end while
    end if
    if privateSaveVersion >= 16 then
      player.gravity = privateReadFloat(buffer, "private player gravity")
      player.flySoundDebounceTime = privateReadFloat(buffer,
        "private player fly sound debounce")
    end if
    if privateSaveVersion >= 18 then
      player.gameplay.inventory.maxBullets = privatechecked.readLong(buffer,
        "private max bullets")
      player.gameplay.inventory.maxShells = privatechecked.readLong(buffer,
        "private max shells")
      player.gameplay.inventory.maxRockets = privatechecked.readLong(buffer,
        "private max rockets")
      player.gameplay.inventory.maxGrenades = privatechecked.readLong(buffer,
        "private max grenades")
      player.gameplay.inventory.maxCells = privatechecked.readLong(buffer,
        "private max cells")
      player.gameplay.inventory.maxSlugs = privatechecked.readLong(buffer,
        "private max slugs")
      player.gameplay.inventory.selectedItem = privatechecked.readLong(buffer,
        "private selected item")
      if player.gameplay.inventory.selectedItem < -1 or
          player.gameplay.inventory.selectedItem >= inventoryCount then
        return error(3891, "private selected item outside inventory")
      end if
      player.persistent.selectedItem = player.gameplay.inventory.selectedItem
      player.gameplay.silencerShots = privatechecked.readLong(buffer,
        "private silencer shots")
      player.gameplay.powerCubes = privatechecked.readLong(buffer,
        "private power cube mask")
      privateCooperativeCount = privatechecked.readLong(buffer,
        "private cooperative inventory count")
      if privateCooperativeCount != inventoryCount then
        return error(3892, "private cooperative inventory size mismatch")
      end if
      player.respawn.cooperativeInventory = array(privateCooperativeCount, 0)
      privateCooperativeIndex = 0
      while privateCooperativeIndex < privateCooperativeCount
        player.respawn.cooperativeInventory[privateCooperativeIndex] = privatechecked.readLong(buffer, "private cooperative inventory value")
        privateCooperativeIndex = privateCooperativeIndex + 1
      end while
    end if
    if privateSaveVersion >= 20 then
      player.powerArmorTime = privateReadFloat(buffer,
        "private player power armor time")
    end if
    if privateSaveVersion >= 21 then
      player.persistent.hand = privatechecked.readLong(buffer,
        "private player hand")
      privatePlayerVelocity = privateReadVec(buffer, "private player velocity")
      player.velocity = [privatePlayerVelocity.x, privatePlayerVelocity.y,
        privatePlayerVelocity.z]
      player.oldPmove = privateReadPmove(buffer, "private player old pmove")
      player.moveType = privatechecked.readLong(buffer, "private player movetype")
      player.deadFlag = privatechecked.readLong(buffer, "private player deadflag")
      player.takeDamage = privatechecked.readLong(buffer,
        "private player takedamage")
      player.viewHeight = privateReadFloat(buffer, "private player viewheight")
      player.waterLevel = privatechecked.readLong(buffer,
        "private player water level")
      player.waterType = privatechecked.readLong(buffer,
        "private player water type")
      privatePlayerGroundNumber = privatechecked.readLong(buffer,
        "private player ground entity")
      player.groundEntity = void
      if privatePlayerGroundNumber >= 0 and
          privatePlayerGroundNumber < exportTable.numEdicts then
        player.groundEntity = exportTable.edicts[privatePlayerGroundNumber]
      end if
      player.groundLinkCount = privatechecked.readLong(buffer,
        "private player ground link count")
      player.oldButtons = privatechecked.readLong(buffer,
        "private player old buttons")
      player.buttons = privatechecked.readLong(buffer, "private player buttons")
      player.latchedButtons = privatechecked.readLong(buffer,
        "private player latched buttons")
      player.weaponThunk = privateReadBool(buffer, "private player weapon thunk")
      player.respawnTime = privateReadFloat(buffer, "private player respawn time")
      player.killerYaw = privateReadFloat(buffer, "private player killer yaw")
      privatePlayerChasePlayers = privatePlayerChasePlayers + [player]
      privatePlayerChaseNumbers = privatePlayerChaseNumbers + [
        privatechecked.readLong(buffer, "private player chase target")]
      player.lightLevel = privatechecked.readLong(buffer,
        "private player light level")
      player.showScores = privateReadBool(buffer, "private player show scores")
      player.showInventory = privateReadBool(buffer,
        "private player show inventory")
      player.showHelp = privateReadBool(buffer, "private player show help")
      player.pickupMessageTime = privateReadFloat(buffer,
        "private player pickup message time")
      player.obituary = privatemessage.readString(buffer)
      privateOldVelocity = privateReadVec(buffer, "private view old velocity")
      player.view.oldVelocity = [privateOldVelocity.x, privateOldVelocity.y,
        privateOldVelocity.z]
      player.view.oldViewAngles = privateReadVec(buffer,
        "private view old angles")
      player.view.kickOrigin = privateReadVec(buffer, "private view kick origin")
      player.view.kickAngles = privateReadVec(buffer, "private view kick angles")
      player.view.damageFrom = privateReadVec(buffer, "private view damage from")
      privateDamageBlend = privateReadVec(buffer, "private view damage blend")
      player.view.damageBlend = [privateDamageBlend.x, privateDamageBlend.y,
        privateDamageBlend.z]
      player.view.damageBlood = privatechecked.readLong(buffer,
        "private view damage blood")
      player.view.damageArmor = privatechecked.readLong(buffer,
        "private view damage armor")
      player.view.damagePowerArmor = privatechecked.readLong(buffer,
        "private view damage power armor")
      player.view.damageKnockback = privatechecked.readLong(buffer,
        "private view damage knockback")
      player.view.damageAlpha = privateReadFloat(buffer,
        "private view damage alpha")
      player.view.bonusAlpha = privateReadFloat(buffer, "private view bonus alpha")
      player.view.damageRoll = privateReadFloat(buffer, "private view damage roll")
      player.view.damagePitch = privateReadFloat(buffer,
        "private view damage pitch")
      player.view.damageTime = privateReadFloat(buffer, "private view damage time")
      player.view.fallValue = privateReadFloat(buffer, "private view fall value")
      player.view.fallTime = privateReadFloat(buffer, "private view fall time")
      player.view.painDebounceTime = privateReadFloat(buffer,
        "private view pain debounce")
      player.view.damageDebounceTime = privateReadFloat(buffer,
        "private view damage debounce")
      player.view.airFinished = privateReadFloat(buffer,
        "private view air finished")
      player.view.nextDrownTime = privateReadFloat(buffer,
        "private view next drown time")
      player.view.drownDamage = privatechecked.readLong(buffer,
        "private view drown damage")
      player.view.oldWaterLevel = privatechecked.readLong(buffer,
        "private view old water level")
      player.view.breatherSound = privatechecked.readLong(buffer,
        "private view breather sound")
      player.view.bobTime = privateReadFloat(buffer, "private view bob time")
      player.view.bobMove = privateReadFloat(buffer, "private view bob move")
      player.view.bobCycle = privatechecked.readLong(buffer, "private view bob cycle")
      player.view.bobFracSin = privateReadFloat(buffer,
        "private view bob fraction")
      player.view.xySpeed = privateReadFloat(buffer, "private view speed")
      player.view.animPriority = privatechecked.readLong(buffer,
        "private view animation priority")
      player.view.animEnd = privatechecked.readLong(buffer,
        "private view animation end")
      player.view.animDuck = privateReadBool(buffer, "private view animation duck")
      player.view.animRun = privateReadBool(buffer, "private view animation run")
      player.view.painCycle = privatechecked.readLong(buffer,
        "private view pain cycle")
      player.view.deathCycle = privatechecked.readLong(buffer,
        "private view death cycle")
      player.view.weaponSound = privatechecked.readLong(buffer,
        "private view weapon sound")
      player.view.machinegunShots = privatechecked.readLong(buffer,
        "private view machinegun shots")
      player.gameplay.buttons = privatechecked.readLong(buffer,
        "private gameplay buttons")
      player.gameplay.latchedButtons = privatechecked.readLong(buffer,
        "private gameplay latched buttons")
      player.gameplay.fireCount = privatechecked.readLong(buffer,
        "private gameplay fire count")
      privateHasHandGrenade = privateReadBool(buffer,
        "private hand grenade state marker")
      if privateHasHandGrenade then
        privateHandOwner = privateintegration.playerWeaponTarget(player,
          playerContext.registry)
        privateHandAmmo = 0
        handState = privatesaveweapontypes.createHandGrenadeState(
          privateHandOwner, privateHandAmmo)
        handState.weaponState = privatechecked.readLong(buffer,
          "private hand grenade weapon state")
        handState.gunFrame = privatechecked.readLong(buffer,
          "private hand grenade gun frame")
        handState.grenadeTime = privateReadFloat(buffer,
          "private hand grenade time")
        handState.grenadeBlewUp = privateReadBool(buffer,
          "private hand grenade blew up")
        handState.buttons = privatechecked.readLong(buffer,
          "private hand grenade buttons")
        handState.latchedButtons = privatechecked.readLong(buffer,
          "private hand grenade latched buttons")
        handState.ammo = privatechecked.readLong(buffer,
          "private hand grenade ammo")
        handState.infiniteAmmo = privateReadBool(buffer,
          "private hand grenade infinite ammo")
        handState.weaponSound = privatemessage.readString(buffer)
        privateHandProjectileNumber = privatechecked.readLong(buffer,
          "private hand grenade projectile")
        for each privateHandProjectile in runtime.weaponContext.projectiles
          if privateHandProjectile.engineNumber == privateHandProjectileNumber then
            handState.lastProjectile = privateHandProjectile
          end if
        end for
        player.handGrenadeState = handState
      end if
    end if
    playerContext.players = playerContext.players + [player]
    playerCount = playerCount - 1
  end while
  privateItemOwnerIndex = 0
  while privateItemOwnerIndex < len(privateItemOwners)
    privateItemOwnerNumber = privateItemOwnerNumbers[privateItemOwnerIndex]
    if privateItemOwnerNumber >= 0 then
      privateOwnerFound = false
      for each privateOwnerPlayer in playerContext.players
        if privateOwnerPlayer.edict.state.number == privateItemOwnerNumber then
          privateItemOwners[privateItemOwnerIndex].owner = privateOwnerPlayer.gameplay
          privateItemOwners[privateItemOwnerIndex].edict.owner = privateOwnerPlayer.edict
          privateOwnerFound = true
        end if
      end for
      if not privateOwnerFound then
        return error(3879, "private item owner missing")
      end if
    end if
    privateItemOwnerIndex = privateItemOwnerIndex + 1
  end while
  privateItemGroundIndex = 0
  while privateItemGroundIndex < len(privateItemGrounds)
    privateItemGroundNumber = privateItemGroundNumbers[privateItemGroundIndex]
    if privateItemGroundNumber >= 0 then
      if privateItemGroundNumber >= exportTable.numEdicts then
        return error(3899, "private item ground entity outside table")
      end if
      privateItemGrounds[privateItemGroundIndex].groundEntity = exportTable.edicts[privateItemGroundNumber]
    else
      privateItemGrounds[privateItemGroundIndex].groundEntity = void
    end if
    privateItemGroundIndex = privateItemGroundIndex + 1
  end while
  for each privateProjectileReference in privateProjectileReferences
    if privateProjectileReference.ownerNumber >= 0 then
      privateProjectileReference.projectile.owner = privateintegration.weaponTargetByNumber(runtime,
        privateProjectileReference.ownerNumber)
      if privateProjectileReference.projectile.owner is void then
        return error(3900, "private projectile owner missing")
      end if
    end if
    if privateProjectileReference.enemyNumber >= 0 then
      privateProjectileReference.projectile.enemy = privateintegration.weaponTargetByNumber(runtime,
        privateProjectileReference.enemyNumber)
      if privateProjectileReference.projectile.enemy is void then
        return error(3901, "private projectile enemy missing")
      end if
    end if
    if privateProjectileReference.groundNumber >= 0 then
      if privateProjectileReference.groundNumber >= exportTable.numEdicts then
        return error(3902, "private projectile ground entity outside table")
      end if
      privateProjectileReference.projectile.groundEntity = exportTable.edicts[privateProjectileReference.groundNumber]
    end if
  end for
  privatePlayerChaseIndex = 0
  while privatePlayerChaseIndex < len(privatePlayerChasePlayers)
    privatePlayerChaseNumber = privatePlayerChaseNumbers[privatePlayerChaseIndex]
    if privatePlayerChaseNumber >= 0 then
      privatePlayerChaseFound = false
      for each privateChaseCandidate in playerContext.players
        if privateChaseCandidate.edict.state.number == privatePlayerChaseNumber then
          privatePlayerChasePlayers[privatePlayerChaseIndex].chaseTarget = privateChaseCandidate
          privatePlayerChaseFound = true
        end if
      end for
      if not privatePlayerChaseFound then
        return error(3903, "private player chase target missing")
      end if
    end if
    privatePlayerChaseIndex = privatePlayerChaseIndex + 1
  end while
  if privateSaveVersion >= 21 then
    privateintegration.syncPlayers(runtime, playerContext)
    for each privateNoiseReference in privateNoiseReferences
      privateNoiseOwner = privateintegration.findAIPlayer(runtime,
        privateNoiseReference.ownerNumber)
      if privateNoiseOwner is void then
        return error(3905, "private player noise owner missing")
      end if
      if privateNoiseReference.primaryPresent then
        privateintegration.integratedPlayerNoise(privateNoiseOwner,
          privateNoiseReference.primaryOrigin, 1)
        privateNoiseOwner.noisePrimary.teleportTime = privateNoiseReference.primaryTeleportTime
        privateNoiseOwner.noisePrimary.areaNumber = privateNoiseReference.primaryAreaNumber
        privateNoiseOwner.noisePrimary.edict.inUse = privateNoiseReference.primaryInUse
      end if
      if privateNoiseReference.secondaryPresent then
        privateintegration.integratedPlayerNoise(privateNoiseOwner,
          privateNoiseReference.secondaryOrigin, 2)
        privateNoiseOwner.noiseSecondary.teleportTime = privateNoiseReference.secondaryTeleportTime
        privateNoiseOwner.noiseSecondary.areaNumber = privateNoiseReference.secondaryAreaNumber
        privateNoiseOwner.noiseSecondary.edict.inUse = privateNoiseReference.secondaryInUse
      end if
    end for
    runtime.aiContext.sightClient = privateRestoreLevelAIReference(runtime,
      privateSavedSightClientNumber, maxClients, exportTable)
    runtime.aiContext.sightEntity = privateRestoreLevelAIReference(runtime,
      privateSavedSightEntityNumber, maxClients, exportTable)
    runtime.aiContext.sightEntityFrame = privateSavedSightEntityFrame
    runtime.aiContext.soundEntity = privateRestoreLevelAIReference(runtime,
      privateSavedSoundEntityNumber, maxClients, exportTable)
    runtime.aiContext.soundEntityFrame = privateSavedSoundEntityFrame
    runtime.aiContext.sound2Entity = privateRestoreLevelAIReference(runtime,
      privateSavedSound2EntityNumber, maxClients, exportTable)
    runtime.aiContext.sound2EntityFrame = privateSavedSound2EntityFrame
  end if
  if privateSaveVersion >= 10 then
    for each privateWorldReference in privateWorldReferences
      privateWorldReference.entity.activator = privateResolveWorldReference(
        runtime, playerContext, privateWorldReference.activatorNumber, "activator")
      privateWorldReference.entity.owner = privateResolveWorldReference(
        runtime, playerContext, privateWorldReference.ownerNumber, "owner")
      privateWorldReference.entity.teamMaster = privateResolveWorldReference(
        runtime, playerContext, privateWorldReference.teamMasterNumber, "team master")
      privateWorldReference.entity.teamChain = privateResolveWorldReference(
        runtime, playerContext, privateWorldReference.teamChainNumber, "team chain")
      privateWorldReference.entity.targetEntity = privateResolveWorldReference(
        runtime, playerContext, privateWorldReference.targetEntityNumber, "target entity")
      privateWorldReference.entity.enemy = privateResolveWorldReference(
        runtime, playerContext, privateWorldReference.enemyNumber, "enemy")
      privateWorldReference.entity.oldEnemy = privateResolveWorldReference(
        runtime, playerContext, privateWorldReference.oldEnemyNumber, "old enemy")
      privateWorldReference.entity.groundEntity = privateResolveWorldReference(
        runtime, playerContext, privateWorldReference.groundEntityNumber, "ground entity")
      if privateWorldReference.entity.className == "turret_base" or
          privateWorldReference.entity.className == "turret_breach" or
          privateWorldReference.entity.className == "turret_driver" then
        privateturret.restoreTurretState(privateWorldReference.entity, runtime.world)
      end if
    end for
  end if
  if buffer.readCount != buffer.curSize then return error(3882, "trailing private BaseQ2 save data") end if
  if privateSaveVersion >= 19 then
    privateintegration.restoreBodyQueue(runtime)
    runtime.bodyQueueIndex = privateSavedBodyQueueIndex
  end if
  return PrivateRestore(runtime, spawnResult, entityString, spawnPoint, privateSavedSkill)
end function
