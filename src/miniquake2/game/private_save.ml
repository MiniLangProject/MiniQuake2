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
import miniquake2.game.gameplay.types as privategameplaytypes

const PRIVATE_MAGIC = "MQ2BASEQ2"
const PRIVATE_VERSION = 17

struct PrivateRestore
  runtime
  spawnResult
  entityString
  spawnPoint
  skill
end struct

struct PrivateMonsterReference
  actor
  enemyNumber
  oldEnemyNumber
  ownerNumber
  goalEntityNumber
  moveTargetNumber
end struct

struct PrivateWorldReference
  entity
  activatorNumber
  ownerNumber
  teamMasterNumber
  teamChainNumber
  targetEntityNumber
  enemyNumber
  oldEnemyNumber
  groundEntityNumber
end struct

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

function privateWriteVec(buffer, value)
  privateWriteVectorHolder = privateworldtypes.vec3FromValue(value, "private save vector")
  privatemessage.writeFloat(buffer, privateWriteVectorHolder.x); privatemessage.writeFloat(buffer, privateWriteVectorHolder.y); privatemessage.writeFloat(buffer, privateWriteVectorHolder.z)
end function

function privateReadFloat(buffer, label)
  privatechecked.require(buffer, 4, label)
  return privatemessage.readFloat(buffer)
end function

function privateReadVec(buffer, label)
  return miniquake2.qcommon.types.Vec3(privateReadFloat(buffer, label + " x"), privateReadFloat(buffer, label + " y"), privateReadFloat(buffer, label + " z"))
end function

function privateWriteBool(buffer, value)
  marker = 0
  if value then marker = 1 end if
  privatemessage.writeByte(buffer, marker)
end function

function privateReadBool(buffer, label)
  marker = privatechecked.readByte(buffer, label)
  if marker != 0 and marker != 1 then return error(3870, label + ": invalid boolean marker") end if
  return marker == 1
end function

function itemIndex(item)
  if item is void then return 0 end if
  return item.index
end function

function itemByIndex(registry, index)
  if index == 0 then return void end if
  for each item in registry.items
    if item.index == index then return item end if
  end for
  return void
end function

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
  capacity = 4096 + len(bytes(entityString)) + len(runtime.world.entities) * 512 + len(runtime.monsters) * 640 + len(runtime.items) * 128 + playerCount * 512 + inventoryWords * 4
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
  end for

  privatemessage.writeLong(buffer, playerCount)
  if playerContext is not void then
    for each player in playerContext.players
      privatemessage.writeLong(buffer, player.edict.state.number)
      privatemessage.writeLong(buffer, player.health); privatemessage.writeLong(buffer, player.maxHealth)
      privatemessage.writeString(buffer, player.persistent.userInfo); privatemessage.writeString(buffer, player.persistent.netName); privatemessage.writeString(buffer, player.persistent.skin)
      privateWriteBool(buffer, player.persistent.connected); privateWriteBool(buffer, player.persistent.spectator)
      privatemessage.writeLong(buffer, player.persistent.score); privatemessage.writeLong(buffer, player.respawn.score)
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
    end for
  end if
  return privatesizebuf.dataSlice(buffer)
end function

function findMonster(runtime, number)
  for each actor in runtime.monsters
    if actor.edict.state.number == number then return actor end if
  end for
  return void
end function

function findItem(runtime, number)
  for each itemEntity in runtime.items
    if itemEntity.edict.state.number == number then return itemEntity end if
  end for
  return void
end function

function privateFindWorld(runtime, number, className)
  privateWorldNumberFallback = void
  for each entity in runtime.world.entities
    if entity.number == number then
      if privateWorldNumberFallback is void then
        privateWorldNumberFallback = entity
      end if
      if entity.className == className then return entity end if
    end if
  end for
  return privateWorldNumberFallback
end function

function privateResolveWorldReference(runtime, playerContext, number, label)
  if number < 0 then return void end if
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
  privateReferenceWorld = privateworldcore.findByNumber(runtime.world, number)
  if privateReferenceWorld is void then
    privateReferenceWorld = privateFindWorld(runtime, number, "")
  end if
  if privateReferenceWorld is not void then return privateReferenceWorld end if
  return error(3890, "private world " + label + " is unavailable: " + number)
end function

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

// Restore the versioned, pointer-free MiniQuake2 payload in two phases: first
// allocate stable entity/AI slots, then resolve saved numeric relationships.
// This prevents partially decoded references from escaping on malformed input.
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
    if index > 0 then number = maxClients + index end if
    restoredBaseEdict = restoredBaseEdicts[index]
    restoredEngineEdict = restoredBaseEdict.edict
    restoredBaseEdict.number = number
    restoredEngineEdict.state.number = number
    index = index + 1
  end while
  runtime = privateintegration.create(spawnResult)
  runtime.aiContext.skill = privateSavedSkill
  runtime.randomState.seed = privateSavedRandomSeed
  runtime.exportTable = exportTable
  runtime.world.time = privateReadFloat(buffer, "private world time")
  runtime.world.serverFlags = privatechecked.readLong(buffer, "private server flags")
  runtime.world.totalSecrets = privatechecked.readLong(buffer, "private total secrets"); runtime.world.foundSecrets = privatechecked.readLong(buffer, "private found secrets")
  runtime.world.totalGoals = privatechecked.readLong(buffer, "private total goals"); runtime.world.foundGoals = privatechecked.readLong(buffer, "private found goals")
  runtime.world.intermission = privateReadBool(buffer, "private intermission")

  worldCount = privatechecked.readLong(buffer, "private world count")
  if worldCount < len(runtime.world.entities) then return error(3874, "private world entity count mismatch") end if
  privateWorldReferences = []
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
    entity = privateFindWorld(runtime, number, className)
    if entity is not void and entity.className != className and
        (className == "monster_gib" or className == "DelayedUse") then
      entity = void
    end if
    if entity is void then
      if className != "monster_gib" and className != "DelayedUse" and
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
    if entity.className == "monster_gib" then
      entity.think = privateworldcore.freeThink
      entity.die = privateworldmisc.gibDie
    else if entity.className == "DelayedUse" then entity.think = privateworldcore.thinkDelayed
    else privatemovers.restoreMoverState(entity, runtime.world) end if
    privateWorldReferences = privateWorldReferences + [
      PrivateWorldReference(entity, privateWorldActivatorNumber,
        privateWorldOwnerNumber, privateWorldTeamMasterNumber,
        privateWorldTeamChainNumber, privateWorldTargetEntityNumber,
        privateWorldEnemyNumber, privateWorldOldEnemyNumber,
        privateWorldGroundEntityNumber)]
    if entity.number >= runtime.world.nextEntityNumber then runtime.world.nextEntityNumber = entity.number + 1 end if
    worldCount = worldCount - 1
  end while

  monsterCount = privatechecked.readLong(buffer, "private monster count")
  if monsterCount < len(runtime.monsters) then return error(3876, "private monster count mismatch") end if
  privateMonsterReferences = []
  privateMonstersRemaining = monsterCount
  privateMonsterRegistryHolder = privatesaveaiarchetypes.defaultRegistry()
  while privateMonstersRemaining > 0
    privateMonsterNumber = privatechecked.readLong(buffer, "private monster number")
    privateMonsterClassName = privatemessage.readString(buffer)
    actor = findMonster(runtime, privateMonsterNumber)
    if actor is void then
      if privateMonsterNumber <= 0 or privateMonsterNumber >= exportTable.numEdicts then return error(3877, "private dynamic monster outside edict table") end if
      if privatesaveaiarchetypes.find(privateMonsterRegistryHolder, privateMonsterClassName) is void then return error(3883, "private dynamic monster class is unavailable") end if
      privateDynamicActorHolder = privatesaveaiarchetypes.SpawnMonster(privateMonsterRegistryHolder, privateMonsterClassName, privateMonsterNumber, runtime.aiContext)
      privateintegration.prepareMonsterRuntimeState(privateDynamicActorHolder)
      runtime.monsters = runtime.monsters + [privateDynamicActorHolder]
      actor = privateDynamicActorHolder
      if privateMonsterNumber >= runtime.world.nextEntityNumber then runtime.world.nextEntityNumber = privateMonsterNumber + 1 end if
    else if actor.className != privateMonsterClassName then
      return error(3884, "private monster classname mismatch")
    end if
    actor.edict = exportTable.edicts[privateMonsterNumber]
    privatesavegametypes.stabilizeEdict(actor.edict)
    actor.edict.inUse = privateReadBool(buffer, "private monster inuse")
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
    if actor.className == "misc_insane" then privatesaveinsane.restoreMove(actor, actor.activity) end if
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
  while itemCount > 0
    privateItemNumber = privatechecked.readLong(buffer, "private item number")
    privateItemIndex = 0
    if privateSaveVersion >= 16 then
      privateItemIndex = privatechecked.readLong(buffer, "private item definition")
    end if
    itemEntity = findItem(runtime, privateItemNumber)
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
    if privateSaveVersion >= 16 and privateItemNumber >= 0 and
        privateItemNumber < exportTable.numEdicts then
      itemEntity.edict = exportTable.edicts[privateItemNumber]
    end if
    itemEntity.edict.inUse = privateReadBool(buffer, "private item inuse")
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
    itemCount = itemCount - 1
  end while

  playerContext.players = []
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
  return PrivateRestore(runtime, spawnResult, entityString, spawnPoint, privateSavedSkill)
end function
