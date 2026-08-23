/*
Copyright (C) 1997-2001 Id Software, Inc.
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later

Validated internal Game API v3 adapter and managed BaseQ2 composition. It owns
world/map edicts, player slots, item/monster/world runtimes and persists the
managed Game API prefix through a versioned pointer-free save image.
*/
package miniquake2.game.null_game

import miniquake2.qcommon.constants as qc
import miniquake2.game.constants as gc
import miniquake2.game.types as gt
import miniquake2.game.persistence as gpersist
import miniquake2.game.private_save as ngprivatesave
import miniquake2.game.base.spawn as bspawn
import miniquake2.game.integration.baseq2 as ngbaseq2
import miniquake2.game.gameplay.registry as ngregistry
import miniquake2.game.gameplay.types as nggtypes
import miniquake2.game.gameplay.combat as ngcombat
import miniquake2.game.gameplay.powerups as ngpowerups
import miniquake2.game.player.types as ngplayertypes
import miniquake2.game.player.userinfo as ngplayerinfo
import miniquake2.game.player.spawn as ngplayerspawn
import miniquake2.game.player.client as ngplayerclient
import miniquake2.game.player.frame as ngplayerframe
import miniquake2.game.player.view as ngplayerview
import miniquake2.qcommon.types as ngqtypes

// Original BaseQ2 layout programs. Keeping each program in one immutable
// literal avoids the repeated string concatenation used by the C source while
// preserving the wire-visible CS_STATUSBAR contract.
const SINGLE_STATUSBAR = "yb -24 xv 0 hnum xv 50 pic 0 if 2 xv 100 anum xv 150 pic 2 endif if 4 xv 200 rnum xv 250 pic 4 endif if 6 xv 296 pic 6 endif yb -50 if 7 xv 0 pic 7 xv 26 yb -42 stat_string 8 yb -50 endif if 9 xv 262 num 2 10 xv 296 pic 9 endif if 11 xv 148 pic 11 endif"
const DEATHMATCH_STATUSBAR = "yb -24 xv 0 hnum xv 50 pic 0 if 2 xv 100 anum xv 150 pic 2 endif if 4 xv 200 rnum xv 250 pic 4 endif if 6 xv 296 pic 6 endif yb -50 if 7 xv 0 pic 7 xv 26 yb -42 stat_string 8 yb -50 endif if 9 xv 246 num 2 10 xv 296 pic 9 endif if 11 xv 148 pic 11 endif xr -50 yt 2 num 3 14 if 17 xv 0 yb -58 string2 \"SPECTATOR MODE\" endif if 16 xv 0 yb -68 string \"Chasing\" xv 64 stat_string 16 endif"

activeImports = void
activeExport = void
initialized = false
mapLoaded = false
currentMap = ""
currentSpawnPoint = ""
currentEntityString = ""
frameNumber = 0
lastUserInfo = ""
clientCommandCount = 0
serverCommandCount = 0
spawnedBaseEdicts = []
lastSpawnResult = void
activeBaseRuntime = void
activePlayerContext = void
activeMaxClients = 4
activeSkill = 1

function playerPmoveTrace(start, mins, maxs, finish)
  global activeImports
  return activeImports.trace(start, mins, maxs, finish, void, qc.MASK_PLAYERSOLID)
end function

function runtimeEdict(number)
  global activeExport
  if activeExport is void or number < 0 or number >= activeExport.maxEdicts then return void end if
  return activeExport.edicts[number]
end function

function baseWorldLog(message)
  global activeImports
  return activeImports.dprintf("MiniQuake2 BaseQ2 world: " + message)
end function

function baseWorldCenter(entity, message)
  global activeImports
  target = runtimeEdict(entity.number)
  if target is void then return false end if
  return activeImports.centerprintf(target, message)
end function

function baseWorldSound(entity, soundName)
  global activeImports
  target = runtimeEdict(entity.number)
  if target is void then return false end if
  return activeImports.sound(target, gc.CHAN_AUTO, activeImports.soundIndex(soundName), 1.0, gc.ATTN_NORM, 0.0)
end function

function baseWorldAreaPortal(style, isOpen)
  global activeImports
  return activeImports.setAreaPortalState(style, isOpen)
end function

function baseWorldChangeLevel(entity, mapName)
  global activePlayerContext, currentMap
  if activePlayerContext is void or typeof(mapName) != "string" or mapName == "" then return false end if
  ngChangePlayerContextHolder = activePlayerContext
  ngChangeDestinationHolder = mapName
  // Retail fact1 shipped with this exact compatibility correction.
  if currentMap == "fact1" and ngChangeDestinationHolder == "fact3" then ngChangeDestinationHolder = "fact3$secret1" end if
  ngChangePlayerContextHolder.nextMap = ngChangeDestinationHolder
  ngChangePlayerContextHolder.exitIntermission = false
  ngChangePlayerContextHolder.intermissionTime = ngChangePlayerContextHolder.time
  if ngChangePlayerContextHolder.intermissionTime <= 0.0 then ngChangePlayerContextHolder.intermissionTime = 0.000001 end if
  return true
end function

function baseWorldLink(entity)
  global activeImports
  ngLinkTargetHolder = runtimeEdict(entity.number)
  if ngLinkTargetHolder is void then return false end if
  ngLinkStateHolder = ngLinkTargetHolder.state
  ngLinkOriginHolder = entity.origin
  ngLinkAnglesHolder = entity.angles
  ngLinkMinsHolder = entity.mins
  ngLinkMaxsHolder = entity.maxs
  ngLinkStateHolder.origin = ngLinkOriginHolder
  ngLinkStateHolder.angles = ngLinkAnglesHolder
  ngLinkTargetHolder.state = ngLinkStateHolder
  ngLinkTargetHolder.state.modelIndex = entity.modelIndex
  ngLinkTargetHolder.state.effects = entity.effects
  ngLinkTargetHolder.state.renderFx = entity.renderFx
  ngLinkTargetHolder.state.frame = entity.frame
  ngLinkTargetHolder.state.sound = entity.loopSound
  ngLinkTargetHolder.serverFlags = entity.serverFlags
  ngLinkTargetHolder.mins = ngLinkMinsHolder
  ngLinkTargetHolder.maxs = ngLinkMaxsHolder
  ngLinkTargetHolder.solid = entity.solid
  gt.stabilizeEdict(ngLinkTargetHolder)
  return activeImports.linkEntity(ngLinkTargetHolder)
end function

function aiTraceVisible(actor, other)
  global activeImports
  zeroBounds = ngqtypes.Vec3(0.0, 0.0, 0.0)
  result = activeImports.trace(actor.edict.state.origin, zeroBounds, zeroBounds, other.edict.state.origin, actor.edict, qc.MASK_OPAQUE)
  if result.fraction == 1.0 then return true end if
  return result.entity is not void and result.entity.state.number == other.edict.state.number
end function

function aiInPHS(first, second)
  global activeImports
  return activeImports.inPHS(first, second)
end function

function aiAreasConnected(first, second)
  global activeImports
  return activeImports.areasConnected(first, second)
end function

function playerTouchTriggers(player)
  global activeBaseRuntime, activePlayerContext, activeImports
  if activeBaseRuntime is void then return 0 end if
  origin = player.edict.state.origin
  mins = ngqtypes.Vec3(origin.x + player.edict.mins.x, origin.y + player.edict.mins.y, origin.z + player.edict.mins.z)
  maxs = ngqtypes.Vec3(origin.x + player.edict.maxs.x, origin.y + player.edict.maxs.y, origin.z + player.edict.maxs.z)
  candidates = activeImports.boxEdicts(mins, maxs, 2)
  touched = 0
  for each candidate in candidates
    if candidate.state.number != player.edict.state.number and ngbaseq2.touchEdict(activeBaseRuntime, candidate, player, activePlayerContext) then touched = touched + 1 end if
  end for
  if len(candidates) == 0 then touched = ngbaseq2.touchNearbyItems(activeBaseRuntime, player, activePlayerContext) end if
  return touched
end function

function playerTouchEntity(entity, player)
  global activeBaseRuntime, activePlayerContext
  if activeBaseRuntime is void then return false end if
  return ngbaseq2.touchEdict(activeBaseRuntime, entity, player, activePlayerContext)
end function

function playerDamage(context, player, amount, damageFlags, meansOfDeath)
  combatant = nggtypes.createCombatant(player.edict.state.number, player.health)
  combatant.edict = player.edict
  combatant.flags = player.flags
  combatant.moveType = player.moveType
  combatant.mass = 200
  combatant.velocity = player.velocity
  combatant.invincibleUntilFrame = player.powerups.invincibleFrame
  ngpowerups.SyncFromPlayerData(player.gameplay, player)
  ngpowerups.SyncArmorToCombatant(player.gameplay, combatant, context.registry)
  point = [player.edict.state.origin.x, player.edict.state.origin.y, player.edict.state.origin.z]
  request = nggtypes.damageRequest([0.0, 0.0, 0.0], point, amount, 0, damageFlags, meansOfDeath)
  request.currentFrame = context.frameNumber
  result = ngcombat.T_Damage(combatant, request)
  player.health = combatant.health
  ngpowerups.SyncArmorFromCombatant(player.gameplay, combatant)
  if result.armorSaved > 0 then ngplayerview.RecordDamage(player, 0, result.armorSaved, 0, 0, point) end if
  return result.taken
end function

function configureIntegratedRuntime(runtime, playerContext)
  runtime.world.callbacks.log = baseWorldLog
  runtime.world.callbacks.centerPrint = baseWorldCenter
  runtime.world.callbacks.sound = baseWorldSound
  runtime.world.callbacks.areaPortal = baseWorldAreaPortal
  runtime.world.callbacks.damage = ngbaseq2.integratedWorldDamage
  runtime.world.callbacks.radiusDamage = ngbaseq2.integratedWorldRadiusDamage
  runtime.world.callbacks.changeLevel = baseWorldChangeLevel
  runtime.world.callbacks.linkEntity = baseWorldLink
  runtime.aiContext.visible = ngbaseq2.aiVisible
  runtime.aiContext.clearShot = ngbaseq2.aiClearShot
  runtime.aiContext.inPHS = ngbaseq2.aiInPHS
  runtime.aiContext.areasConnected = ngbaseq2.aiAreasConnected
  playerContext.touchTriggers = playerTouchTriggers
  playerContext.touchEntity = playerTouchEntity
  playerContext.weaponThink = ngbaseq2.thinkPlayerWeapon
  playerContext.damagePlayer = playerDamage
  return true
end function

function linkManagedEdicts()
  global activeExport, activeImports
  exportTable = activeExport
  index = 0
  while index < exportTable.numEdicts
    engineEdict = exportTable.edicts[index]
    if engineEdict.inUse then
      if typeof(engineEdict.state) != "struct" then
        return error(3829, "linkManagedEdicts: malformed state at edict " + index)
      end if
      activeImports.linkEntity(engineEdict)
    end if
    index = index + 1
  end while
  return true
end function

function findPlayer(index)
  global activePlayerContext
  if activePlayerContext is void then return void end if
  for each player in activePlayerContext.players
    if player.edict.state.number == index then return player end if
  end for
  return void
end function

function playerForEdict(slot, operation, createIfMissing)
  global activePlayerContext, activeMaxClients
  index = slot.state.number
  if index <= 0 or index > activeMaxClients then return error(3826, operation + ": edict is outside configured client slots") end if
  player = findPlayer(index)
  if player is void and createIfMissing then
    if slot.client is void then slot.client = gt.zeroGameClient() end if
    player = ngplayertypes.createPlayer(index, activePlayerContext.registry)
    player.edict = slot
    player.gameplay.edict = slot
    context = activePlayerContext
    context.players = context.players + [player]
  end if
  if player is void then return error(3827, operation + ": client slot is not connected") end if
  return player
end function

function requireFunction(value, name)
  if typeof(value) != "function" then
    return error(3800, "GetGameApi: missing game import callback " + name)
  end if
  return true
end function

function validateGameImport(imports)
  if typeof(imports) != "struct" then return error(3801, "GetGameApi: game import table is not a struct") end if
  requireFunction(imports.bprintf, "bprintf")
  requireFunction(imports.dprintf, "dprintf")
  requireFunction(imports.cprintf, "cprintf")
  requireFunction(imports.centerprintf, "centerprintf")
  requireFunction(imports.sound, "sound")
  requireFunction(imports.positionedSound, "positioned_sound")
  requireFunction(imports.configString, "configstring")
  requireFunction(imports.fail, "error")
  requireFunction(imports.modelIndex, "modelindex")
  requireFunction(imports.soundIndex, "soundindex")
  requireFunction(imports.imageIndex, "imageindex")
  requireFunction(imports.setModel, "setmodel")
  requireFunction(imports.trace, "trace")
  requireFunction(imports.pointContents, "pointcontents")
  requireFunction(imports.inPVS, "inPVS")
  requireFunction(imports.inPHS, "inPHS")
  requireFunction(imports.setAreaPortalState, "SetAreaPortalState")
  requireFunction(imports.areasConnected, "AreasConnected")
  requireFunction(imports.linkEntity, "linkentity")
  requireFunction(imports.unlinkEntity, "unlinkentity")
  requireFunction(imports.boxEdicts, "BoxEdicts")
  requireFunction(imports.pmove, "Pmove")
  requireFunction(imports.multicast, "multicast")
  requireFunction(imports.unicast, "unicast")
  requireFunction(imports.writeChar, "WriteChar")
  requireFunction(imports.writeByte, "WriteByte")
  requireFunction(imports.writeShort, "WriteShort")
  requireFunction(imports.writeLong, "WriteLong")
  requireFunction(imports.writeFloat, "WriteFloat")
  requireFunction(imports.writeString, "WriteString")
  requireFunction(imports.writePosition, "WritePosition")
  requireFunction(imports.writeDirection, "WriteDir")
  requireFunction(imports.writeAngle, "WriteAngle")
  requireFunction(imports.tagMalloc, "TagMalloc")
  requireFunction(imports.tagFree, "TagFree")
  requireFunction(imports.freeTags, "FreeTags")
  requireFunction(imports.cvar, "cvar")
  requireFunction(imports.cvarSet, "cvar_set")
  requireFunction(imports.cvarForceSet, "cvar_forceset")
  requireFunction(imports.argc, "argc")
  requireFunction(imports.argv, "argv")
  requireFunction(imports.args, "args")
  requireFunction(imports.addCommandString, "AddCommandString")
  requireFunction(imports.debugGraph, "DebugGraph")
  requireFunction(imports.collisionWorldReady, "collisionWorldReady")
  return true
end function

function requireInstalled(operation)
  global activeExport
  if activeExport is void then return error(3802, operation + ": game API is not installed") end if
  return true
end function

function requireInitialized(operation)
  global initialized
  requireInstalled(operation)
  if initialized != true then return error(3803, operation + ": game is not initialized") end if
  return true
end function

function makeEdicts(count)
  ngEdictArrayHolder = array(count)
  ngEdictArrayIndex = 0
  while ngEdictArrayIndex < count
    ngCreatedEdictHolder = gt.zeroEdict(ngEdictArrayIndex)
    ngEdictArrayHolder[ngEdictArrayIndex] = ngCreatedEdictHolder
    ngStoredEdictHolder = ngEdictArrayHolder[ngEdictArrayIndex]
    ngStoredEdictHolder.state = ngCreatedEdictHolder.state
    ngStoredEdictHolder.mins = ngCreatedEdictHolder.mins
    ngStoredEdictHolder.maxs = ngCreatedEdictHolder.maxs
    ngStoredEdictHolder.absoluteMins = ngCreatedEdictHolder.absoluteMins
    ngStoredEdictHolder.absoluteMaxs = ngCreatedEdictHolder.absoluteMaxs
    ngStoredEdictHolder.size = ngCreatedEdictHolder.size
    gt.stabilizeEdict(ngStoredEdictHolder)
    ngEdictArrayIndex = ngEdictArrayIndex + 1
  end while
  return ngEdictArrayHolder
end function

function Init()
  global initialized, mapLoaded, currentMap, currentSpawnPoint, currentEntityString, frameNumber, lastUserInfo, clientCommandCount, serverCommandCount, spawnedBaseEdicts, lastSpawnResult, activeBaseRuntime, activePlayerContext, activeMaxClients
  requireInstalled("Init")
  if initialized then return error(3804, "Init: game is already initialized") end if
  exportTable = activeExport
  ngInitializedEdictsHolder = makeEdicts(qc.MAX_EDICTS)
  exportTable.edicts = ngInitializedEdictsHolder
  exportTable.edictSize = gc.MINILANG_EDICT_STRIDE
  exportTable.numEdicts = 1
  exportTable.maxEdicts = qc.MAX_EDICTS
  exportTable.edicts[0].inUse = true
  initialized = true
  mapLoaded = false
  currentMap = ""
  currentSpawnPoint = ""
  currentEntityString = ""
  frameNumber = 0
  lastUserInfo = ""
  clientCommandCount = 0
  serverCommandCount = 0
  spawnedBaseEdicts = []
  lastSpawnResult = void
  activeBaseRuntime = void
  activePlayerContext = ngplayertypes.createContext(activeImports, ngregistry.stockRegistry(), playerPmoveTrace)
  playerContext = activePlayerContext
  playerContext.damagePlayer = playerDamage
  activeImports.dprintf("MiniQuake2 BaseQ2: Init (managed gameplay runtime)")
  return true
end function

function Shutdown()
  global initialized, mapLoaded, currentMap, currentSpawnPoint, currentEntityString, spawnedBaseEdicts, lastSpawnResult, activeBaseRuntime, activePlayerContext
  requireInitialized("Shutdown")
  activeImports.dprintf("MiniQuake2 BaseQ2: Shutdown")
  exportTable = activeExport
  exportTable.edicts = []
  exportTable.edictSize = gc.MINILANG_EDICT_STRIDE
  exportTable.numEdicts = 0
  exportTable.maxEdicts = 0
  initialized = false
  mapLoaded = false
  currentMap = ""
  currentSpawnPoint = ""
  currentEntityString = ""
  spawnedBaseEdicts = []
  lastSpawnResult = void
  activeBaseRuntime = void
  activePlayerContext = void
  return true
end function

function SpawnEntities(mapName, entityString, spawnPoint)
  global mapLoaded, currentMap, currentSpawnPoint, currentEntityString, frameNumber, spawnedBaseEdicts, lastSpawnResult, activeBaseRuntime, activePlayerContext, activeMaxClients, activeSkill
  requireInitialized("SpawnEntities")
  if typeof(mapName) != "string" or len(bytes(mapName)) == 0 then return error(3805, "SpawnEntities: empty map name") end if
  if typeof(entityString) != "string" then return error(3806, "SpawnEntities: entity string must be text") end if
  if typeof(spawnPoint) != "string" then return error(3807, "SpawnEntities: spawn point must be text") end if
  spawned = bspawn.SpawnEntities(mapName, entityString, spawnPoint)
  spawnedEdicts = spawned.edicts
  if len(spawnedEdicts) + activeMaxClients > qc.MAX_EDICTS then return error(3809, "SpawnEntities: parsed edict count exceeds engine limit") end if
  // Extract the small player-spawn view before integrated world/item/monster
  // construction allocates the rest of the level graph.
  levelSpawnSpots = ngplayerspawn.spotsFromBaseEdicts(spawnedEdicts)
  exportTable = activeExport
  exportTable.numEdicts = 1
  spawnedBaseEdicts = spawnedEdicts
  lastSpawnResult = spawned
  index = 0
  while index < len(spawnedEdicts)
    number = 0
    if index > 0 then number = activeMaxClients + index end if
    spawnedBaseEdict = spawnedEdicts[index]
    ngSpawnEngineEdictHolder = gt.stabilizeEdict(spawnedBaseEdict.edict)
    spawnedBaseEdict.number = number
    ngSpawnEngineEdictHolder.state.number = number
    exportTable.edicts[number] = ngSpawnEngineEdictHolder
    ngSpawnStoredEdictHolder = exportTable.edicts[number]
    ngSpawnStoredEdictHolder.state = ngSpawnEngineEdictHolder.state
    ngSpawnStoredEdictHolder.mins = ngSpawnEngineEdictHolder.mins
    ngSpawnStoredEdictHolder.maxs = ngSpawnEngineEdictHolder.maxs
    ngSpawnStoredEdictHolder.absoluteMins = ngSpawnEngineEdictHolder.absoluteMins
    ngSpawnStoredEdictHolder.absoluteMaxs = ngSpawnEngineEdictHolder.absoluteMaxs
    ngSpawnStoredEdictHolder.size = ngSpawnEngineEdictHolder.size
    gt.stabilizeEdict(ngSpawnStoredEdictHolder)
    if number >= exportTable.numEdicts then exportTable.numEdicts = number + 1 end if
    index = index + 1
  end while
  activeBaseRuntime = ngbaseq2.create(spawned)
  ngSkillRuntimeHolder = activeBaseRuntime
  ngSkillAiContextHolder = ngSkillRuntimeHolder.aiContext
  ngSkillAiContextHolder.skill = activeSkill
  ngbaseq2.syncGameEdicts(activeBaseRuntime, exportTable)
  playerContext = activePlayerContext
  playerContext.spawnSpots = levelSpawnSpots
  playerContext.spawnPoint = spawnPoint
  playerContext.mapName = mapName
  playerContext.frameNumber = 0
  playerContext.time = 0.0
  configureIntegratedRuntime(activeBaseRuntime, playerContext)
  // Protocol 34 reserves model slot one for the map; reserve it before any
  // managed stock entity asks the engine for a model index.
  activeImports.modelIndex("maps/" + mapName + ".bsp")
  statusBar = SINGLE_STATUSBAR
  if playerContext.deathmatch then statusBar = DEATHMATCH_STATUSBAR end if
  activeImports.configString(qc.CS_STATUSBAR, statusBar)
  activeImports.imageIndex("i_health")
  activeImports.imageIndex("i_help")
  ngbaseq2.precacheSpawned(activeBaseRuntime, playerContext)
  ngbaseq2.bindEngineModels(activeBaseRuntime, exportTable, activeImports)
  ngbaseq2.syncGameEdicts(activeBaseRuntime, exportTable)
  ngbaseq2.syncPlayers(activeBaseRuntime, playerContext)
  linkManagedEdicts()
  ngbaseq2.initializeMonsterMovement(activeBaseRuntime, false)
  ngbaseq2.syncGameEdicts(activeBaseRuntime, exportTable)
  mapLoaded = true
  currentMap = mapName
  currentSpawnPoint = spawnPoint
  currentEntityString = entityString
  frameNumber = 0
  for each diagnostic in spawned.diagnostics
    activeImports.dprintf("MiniQuake2 BaseQ2: " + diagnostic)
  end for
  for each skipped in spawned.skippedClasses
    activeImports.dprintf("MiniQuake2 BaseQ2: skipped classname=" + skipped.className + " count=" + skipped.count)
  end for
  activeImports.dprintf("MiniQuake2 BaseQ2: SpawnEntities " + mapName + " edicts=" + len(spawned.edicts))
  return true
end function

function WriteGame(filename, autosave)
  if typeof(autosave) != "bool" then return error(3810, "WriteGame: autosave must be bool") end if
  requireInitialized("WriteGame")
  privateData = ngprivatesave.encode(activeBaseRuntime, activePlayerContext, currentEntityString, currentSpawnPoint)
  return gpersist.writeFileWithPrivate(activeExport, "game", currentMap, frameNumber, privateData, filename)
end function

function restoreManagedImage(image)
  global currentMap, currentSpawnPoint, currentEntityString, frameNumber, mapLoaded, activeBaseRuntime, activePlayerContext, spawnedBaseEdicts, lastSpawnResult, activeMaxClients, activeImports, activeExport, activeSkill
  exportTable = activeExport
  ngRestoredEdictsHolder = image.edicts
  ngRestoreIndex = 0
  while ngRestoreIndex < len(ngRestoredEdictsHolder)
    gt.stabilizeEdict(ngRestoredEdictsHolder[ngRestoreIndex])
    ngRestoreIndex = ngRestoreIndex + 1
  end while
  exportTable.edicts = ngRestoredEdictsHolder
  exportTable.numEdicts = image.numEdicts
  currentMap = image.mapName
  frameNumber = image.frameNumber
  mapLoaded = currentMap != ""
  if len(image.privateData) == 0 then
    activeBaseRuntime = void
    legacyPlayerContext = activePlayerContext
    legacyPlayerContext.players = []
    currentSpawnPoint = ""
    currentEntityString = ""
    return true
  end if
  restored = ngprivatesave.restore(image.privateData, currentMap, activeMaxClients, exportTable, activePlayerContext)
  restoredRuntime = restored.runtime
  restoredSpawnResult = restored.spawnResult
  restoredBaseEdicts = restoredSpawnResult.edicts
  restoredSpawnSpots = ngplayerspawn.spotsFromBaseEdicts(restoredBaseEdicts)
  activeBaseRuntime = restoredRuntime
  spawnedBaseEdicts = restoredBaseEdicts
  lastSpawnResult = restoredSpawnResult
  currentSpawnPoint = restored.spawnPoint
  currentEntityString = restored.entityString
  activeSkill = restored.skill
  playerContext = activePlayerContext
  playerContext.spawnSpots = restoredSpawnSpots
  playerContext.spawnPoint = currentSpawnPoint
  playerContext.mapName = currentMap
  playerContext.frameNumber = frameNumber
  playerContext.time = activeBaseRuntime.world.time
  configureIntegratedRuntime(activeBaseRuntime, playerContext)
  activeImports.modelIndex("maps/" + currentMap + ".bsp")
  ngbaseq2.precacheSpawned(activeBaseRuntime, playerContext)
  ngbaseq2.bindRestoredEngineModels(activeBaseRuntime, exportTable, activeImports)
  ngbaseq2.syncGameEdicts(activeBaseRuntime, exportTable)
  ngbaseq2.syncPlayers(activeBaseRuntime, playerContext)
  linkManagedEdicts()
  ngbaseq2.initializeMonsterMovement(activeBaseRuntime, true)
  return true
end function

function ReadGame(filename)
  requireInitialized("ReadGame")
  image = gpersist.readFile(filename, activeExport.maxEdicts)
  if image.kind != "game" then return error(3809, "ReadGame: save image is not a game save") end if
  return restoreManagedImage(image)
end function

function WriteLevel(filename)
  requireInitialized("WriteLevel")
  privateData = ngprivatesave.encode(activeBaseRuntime, activePlayerContext, currentEntityString, currentSpawnPoint)
  return gpersist.writeFileWithPrivate(activeExport, "level", currentMap, frameNumber, privateData, filename)
end function

function ReadLevel(filename)
  requireInitialized("ReadLevel")
  image = gpersist.readFile(filename, activeExport.maxEdicts)
  if image.kind != "level" then return error(3809, "ReadLevel: save image is not a level save") end if
  return restoreManagedImage(image)
end function

function checkedClientEdict(entity, operation)
  global activeExport
  requireInitialized(operation)
  if typeof(entity) != "struct" then return error(3811, operation + ": edict must be a struct") end if
  index = entity.state.number
  if index <= 0 or index >= activeExport.maxEdicts then return error(3812, operation + ": invalid client edict index") end if
  if activeExport.edicts[index].state.number != index then return error(3813, operation + ": corrupt edict index mapping") end if
  if nativeRawValue(entity) != nativeRawValue(activeExport.edicts[index]) then return error(3825, operation + ": edict is not owned by this game export") end if
  return activeExport.edicts[index]
end function

function ClientConnect(entity, userInfo)
  global activeExport, lastUserInfo
  slot = checkedClientEdict(entity, "ClientConnect")
  if typeof(userInfo) != "string" then return error(3814, "ClientConnect: userinfo must be text") end if
  if slot.client is void then slot.client = gt.zeroGameClient() end if
  player = playerForEdict(slot, "ClientConnect", true)
  context = activePlayerContext
  if len(context.spawnSpots) == 0 then
    lastUserInfo = userInfo
    return true
  end if
  result = ngplayerinfo.ClientConnect(context, player, userInfo)
  lastUserInfo = result.userInfo
  return result.accepted
end function

function ClientBegin(entity)
  slot = checkedClientEdict(entity, "ClientBegin")
  player = playerForEdict(slot, "ClientBegin", false)
  context = activePlayerContext
  if len(context.spawnSpots) > 0 then ngplayerclient.ClientBegin(context, player)
  else slot.inUse = true end if
  if activeBaseRuntime is not void then ngbaseq2.syncPlayers(activeBaseRuntime, context) end if
  index = slot.state.number
  exportTable = activeExport
  if index >= exportTable.numEdicts then exportTable.numEdicts = index + 1 end if
  return true
end function

function ClientUserinfoChanged(entity, userInfo)
  global activeExport, lastUserInfo
  slot = checkedClientEdict(entity, "ClientUserinfoChanged")
  if slot.client is void then return error(3815, "ClientUserinfoChanged: client is not connected") end if
  if typeof(userInfo) != "string" then return error(3816, "ClientUserinfoChanged: userinfo must be text") end if
  player = playerForEdict(slot, "ClientUserinfoChanged", false)
  context = activePlayerContext
  if len(context.spawnSpots) == 0 then lastUserInfo = userInfo
  else lastUserInfo = ngplayerinfo.ClientUserinfoChanged(context, player, userInfo) end if
  return true
end function

function ClientDisconnect(entity)
  global activeExport
  slot = checkedClientEdict(entity, "ClientDisconnect")
  player = playerForEdict(slot, "ClientDisconnect", false)
  if player.persistent.connected then ngplayerinfo.ClientDisconnect(activePlayerContext, player)
  else slot.inUse = false end if
  slot.client = void
  slot.state.event = gc.EV_NONE
  return true
end function

function ClientCommand(entity)
  global activeExport, clientCommandCount
  slot = checkedClientEdict(entity, "ClientCommand")
  if slot.client is void then return error(3817, "ClientCommand: client is not connected") end if
  clientCommandCount = clientCommandCount + 1
  return true
end function

function ClientThink(entity, command)
  global activeExport
  slot = checkedClientEdict(entity, "ClientThink")
  if slot.client is void then return error(3818, "ClientThink: client is not connected") end if
  if typeof(command) != "struct" then return error(3819, "ClientThink: usercmd must be a struct") end if
  player = playerForEdict(slot, "ClientThink", false)
  context = activePlayerContext
  if len(context.spawnSpots) > 0 then ngplayerclient.ClientThink(context, player, command)
  else
    // The no-map compatibility contract has no spawn state from which real
    // delta angles can be derived.
    slot.client.playerState.pmove.deltaAngles = [command.angles[0], command.angles[1], command.angles[2]]
  end if
  return true
end function

function RunFrame()
  global frameNumber, activeBaseRuntime, activePlayerContext
  requireInitialized("RunFrame")
  if mapLoaded != true then return error(3820, "RunFrame: no level has been spawned") end if
  index = 0
  exportTable = activeExport
  while index < exportTable.numEdicts
    exportTable.edicts[index].state.event = gc.EV_NONE
    index = index + 1
  end while
  frameNumber = frameNumber + 1
  if activeBaseRuntime is not void then
    runtime = activeBaseRuntime
    if activePlayerContext is not void then ngbaseq2.syncPlayers(runtime, activePlayerContext) end if
    ngbaseq2.runFrame(runtime)
  end if
  if activePlayerContext is not void then
    playerContext = activePlayerContext
    ngplayerframe.RunPlayerFrame(playerContext)
    if activeBaseRuntime is not void then
      ngbaseq2.runPlayerGameplayFrame(activeBaseRuntime, playerContext)
      ngbaseq2.syncPlayers(activeBaseRuntime, playerContext)
      // World, monster and item state is published once after both the world
      // and player phases. Publishing the identical aggregate before the
      // player phase doubled every per-edict stabilization/write barrier
      // without exposing an intermediate snapshot to any consumer.
      ngbaseq2.syncGameEdicts(activeBaseRuntime, exportTable)
    end if
    for each player in playerContext.players
      playerNumber = player.edict.state.number
      if playerNumber > 0 and playerNumber < exportTable.maxEdicts then
        ngFramePlayerEdictHolder = gt.stabilizeEdict(player.edict)
        exportTable.edicts[playerNumber] = ngFramePlayerEdictHolder
        ngFrameStoredPlayerEdictHolder = exportTable.edicts[playerNumber]
        ngFrameStoredPlayerEdictHolder.state = ngFramePlayerEdictHolder.state
        ngFrameStoredPlayerEdictHolder.mins = ngFramePlayerEdictHolder.mins
        ngFrameStoredPlayerEdictHolder.maxs = ngFramePlayerEdictHolder.maxs
        ngFrameStoredPlayerEdictHolder.absoluteMins = ngFramePlayerEdictHolder.absoluteMins
        ngFrameStoredPlayerEdictHolder.absoluteMaxs = ngFramePlayerEdictHolder.absoluteMaxs
        ngFrameStoredPlayerEdictHolder.size = ngFramePlayerEdictHolder.size
        gt.stabilizeEdict(ngFrameStoredPlayerEdictHolder)
        if player.edict.inUse and playerNumber >= exportTable.numEdicts then exportTable.numEdicts = playerNumber + 1 end if
      end if
    end for
  else if activeBaseRuntime is not void then
    ngbaseq2.syncGameEdicts(activeBaseRuntime, exportTable)
  end if
  return true
end function

function ServerCommand()
  global activeImports, serverCommandCount
  requireInitialized("ServerCommand")
  serverCommandCount = serverCommandCount + 1
  activeImports.dprintf("MiniQuake2 BaseQ2: ServerCommand (extended admin set pending)")
  return true
end function

function GetGameApi(imports)
  global activeImports, activeExport, initialized, mapLoaded, currentMap, currentSpawnPoint, currentEntityString, frameNumber, lastUserInfo, clientCommandCount, serverCommandCount, activeBaseRuntime, activePlayerContext, activeMaxClients, activeSkill
  validateGameImport(imports)
  if initialized then return error(3821, "GetGameApi: active game must be shut down before replacement") end if
  activeImports = imports
  initialized = false
  mapLoaded = false
  currentMap = ""
  currentSpawnPoint = ""
  currentEntityString = ""
  frameNumber = 0
  lastUserInfo = ""
  clientCommandCount = 0
  serverCommandCount = 0
  activeBaseRuntime = void
  activePlayerContext = void
  activeMaxClients = 4
  activeSkill = 1
  activeExport = gt.GameExport(
    gc.GAME_API_VERSION,
    Init, Shutdown, SpawnEntities,
    WriteGame, ReadGame, WriteLevel, ReadLevel,
    ClientConnect, ClientBegin, ClientUserinfoChanged, ClientDisconnect,
    ClientCommand, ClientThink, RunFrame, ServerCommand,
    [], gc.MINILANG_EDICT_STRIDE, 0, 0
  )
  return activeExport
end function

function configureMaxClients(count)
  global activeMaxClients, initialized
  requireInstalled("configureMaxClients")
  if initialized then return error(3828, "configureMaxClients: game is already initialized") end if
  if typeof(count) != "int" or count < 1 or count > qc.MAX_CLIENTS then return error(3829, "configureMaxClients: count outside protocol range") end if
  activeMaxClients = count
  return true
end function

function configureSkill(skill)
  global activeSkill, initialized
  requireInstalled("configureSkill")
  if initialized then return error(3830, "configureSkill: game is already initialized") end if
  if typeof(skill) != "int" or skill < 0 or skill > 3 then
    return error(3831, "configureSkill: difficulty outside [0,3]")
  end if
  activeSkill = skill
  return true
end function

function configuredGameSkill()
  global activeSkill
  return activeSkill
end function

function edictAt(index)
  global activeExport
  requireInitialized("edictAt")
  if typeof(index) != "int" or index < 0 or index >= activeExport.maxEdicts then return error(3822, "edictAt: index out of range") end if
  return activeExport.edicts[index]
end function

function edictIndex(entity)
  global activeExport
  requireInitialized("edictIndex")
  if typeof(entity) != "struct" then return error(3823, "edictIndex: edict must be a struct") end if
  index = entity.state.number
  if index < 0 or index >= activeExport.maxEdicts then return error(3824, "edictIndex: state number out of range") end if
  if nativeRawValue(entity) != nativeRawValue(activeExport.edicts[index]) then return error(3825, "edictIndex: edict is not owned by this game export") end if
  return index
end function

function edictOffset(index)
  global activeExport
  requireInitialized("edictOffset")
  if typeof(index) != "int" or index < 0 or index >= activeExport.maxEdicts then return error(3822, "edictOffset: index out of range") end if
  return index * activeExport.edictSize
end function

function lifecycleSnapshot()
  global initialized, mapLoaded, currentMap, currentSpawnPoint, frameNumber, lastUserInfo, clientCommandCount, serverCommandCount
  return [initialized, mapLoaded, currentMap, currentSpawnPoint, frameNumber, lastUserInfo, clientCommandCount, serverCommandCount]
end function

function baseEdicts()
  global spawnedBaseEdicts
  return spawnedBaseEdicts
end function

function spawnResult()
  global lastSpawnResult
  return lastSpawnResult
end function

function baseRuntime()
  global activeBaseRuntime
  return activeBaseRuntime
end function

function playerContext()
  global activePlayerContext
  return activePlayerContext
end function

function apiInstalled()
  global activeExport
  return activeExport is not void
end function
