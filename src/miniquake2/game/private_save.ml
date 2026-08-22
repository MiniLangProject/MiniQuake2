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
import miniquake2.game.world.types as privateworldtypes
import miniquake2.game.world.core as privateworldcore
import miniquake2.game.player.types as privateplayers

const PRIVATE_MAGIC = "MQ2BASEQ2"
const PRIVATE_VERSION = 7

struct PrivateRestore
  runtime
  spawnResult
  entityString
  spawnPoint
end struct

struct PrivateMonsterReference
  actor
  enemyNumber
end struct

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
  capacity = 4096 + len(bytes(entityString)) + len(runtime.world.entities) * 512 + len(runtime.monsters) * 512 + len(runtime.items) * 128 + playerCount * 512 + inventoryWords * 4
  buffer = privatesizebuf.alloc(capacity)
  privatemessage.writeString(buffer, PRIVATE_MAGIC); privatemessage.writeLong(buffer, PRIVATE_VERSION)
  privatemessage.writeString(buffer, entityString); privatemessage.writeString(buffer, spawnPoint)
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
    enemyNumber = -1
    if actor.enemy is not void then enemyNumber = actor.enemy.edict.state.number end if
    privatemessage.writeLong(buffer, enemyNumber)
  end for

  privatemessage.writeLong(buffer, len(runtime.items))
  for each itemEntity in runtime.items
    privatemessage.writeLong(buffer, itemEntity.edict.state.number); privateWriteBool(buffer, itemEntity.edict.inUse)
    privateWriteBool(buffer, itemEntity.hidden); privateWriteBool(buffer, itemEntity.freed); privateWriteBool(buffer, itemEntity.decaying)
    privatemessage.writeLong(buffer, itemEntity.count); privatemessage.writeLong(buffer, itemEntity.spawnFlags)
    privatemessage.writeFloat(buffer, itemEntity.nextThink); privatemessage.writeFloat(buffer, itemEntity.respawnAt)
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

function privateFindWorld(runtime, number)
  for each entity in runtime.world.entities
    if entity.number == number then return entity end if
  end for
  return void
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

function restore(data, mapName, maxClients, exportTable, playerContext)
  if typeof(data) != "bytes" or len(data) == 0 then return error(3871, "private BaseQ2 save payload missing") end if
  buffer = privatesizebuf.alloc(len(data)); privatesizebuf.writeBytes(buffer, data); privatemessage.beginReading(buffer)
  if privatemessage.readString(buffer) != PRIVATE_MAGIC then return error(3872, "private BaseQ2 save magic mismatch") end if
  if privatechecked.readLong(buffer, "private save version") != PRIVATE_VERSION then return error(3873, "unsupported private BaseQ2 save version") end if
  entityString = privatemessage.readString(buffer); spawnPoint = privatemessage.readString(buffer)
  spawnResult = privatespawn.SpawnEntities(mapName, entityString, spawnPoint)
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
  runtime.exportTable = exportTable
  runtime.world.time = privateReadFloat(buffer, "private world time")
  runtime.world.serverFlags = privatechecked.readLong(buffer, "private server flags")
  runtime.world.totalSecrets = privatechecked.readLong(buffer, "private total secrets"); runtime.world.foundSecrets = privatechecked.readLong(buffer, "private found secrets")
  runtime.world.totalGoals = privatechecked.readLong(buffer, "private total goals"); runtime.world.foundGoals = privatechecked.readLong(buffer, "private found goals")
  runtime.world.intermission = privateReadBool(buffer, "private intermission")

  worldCount = privatechecked.readLong(buffer, "private world count")
  if worldCount < len(runtime.world.entities) then return error(3874, "private world entity count mismatch") end if
  while worldCount > 0
    number = privatechecked.readLong(buffer, "private world number")
    className = privatemessage.readString(buffer)
    modelName = privatemessage.readString(buffer)
    modelIndex = privatechecked.readLong(buffer, "private world model index")
    entity = privateFindWorld(runtime, number)
    if entity is void then
      if className != "monster_gib" then return error(3875, "private world entity missing") end if
      privateDynamicWorldHolder = privateworldtypes.createEntity(number, className)
      privateworldcore.addEntity(runtime.world, privateDynamicWorldHolder)
      entity = privateDynamicWorldHolder
    else if entity.className != className then
      return error(3887, "private world classname mismatch")
    end if
    entity.model = modelName; entity.modelIndex = modelIndex
    entity.inUse = privateReadBool(buffer, "private world inuse")
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
    if entity.className == "monster_gib" then entity.think = privateworldcore.freeThink
    else privatemovers.restoreMoverState(entity, runtime.world) end if
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
    privatesavegametypes.stabilizeEdict(actor.edict)
    enemyNumber = privatechecked.readLong(buffer, "private monster enemy")
    privateMonsterReferences = privateMonsterReferences + [PrivateMonsterReference(actor, enemyNumber)]
    privateMonstersRemaining = privateMonstersRemaining - 1
  end while
  if len(runtime.monsters) != monsterCount then return error(3885, "private restored monster count mismatch") end if
  for each privateMonsterReference in privateMonsterReferences
    privateMonsterReference.actor.enemy = privateRestoreEnemy(runtime, privateMonsterReference.enemyNumber, maxClients, exportTable)
  end for

  itemCount = privatechecked.readLong(buffer, "private item count")
  if itemCount != len(runtime.items) then return error(3878, "private item count mismatch") end if
  while itemCount > 0
    itemEntity = findItem(runtime, privatechecked.readLong(buffer, "private item number"))
    if itemEntity is void then return error(3879, "private item missing") end if
    itemEntity.edict.inUse = privateReadBool(buffer, "private item inuse")
    itemEntity.hidden = privateReadBool(buffer, "private item hidden"); itemEntity.freed = privateReadBool(buffer, "private item freed"); itemEntity.decaying = privateReadBool(buffer, "private item decaying")
    itemEntity.count = privatechecked.readLong(buffer, "private item count field"); itemEntity.spawnFlags = privatechecked.readLong(buffer, "private item spawnflags")
    itemEntity.nextThink = privateReadFloat(buffer, "private item nextthink"); itemEntity.respawnAt = privateReadFloat(buffer, "private item respawn")
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
    playerContext.players = playerContext.players + [player]
    playerCount = playerCount - 1
  end while
  if buffer.readCount != buffer.curSize then return error(3882, "trailing private BaseQ2 save data") end if
  return PrivateRestore(runtime, spawnResult, entityString, spawnPoint)
end function
