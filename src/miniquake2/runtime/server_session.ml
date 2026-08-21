/*
Copyright (C) 1997-2001 Id Software, Inc.
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later

Fixed-step dedicated/listen-server core joining retail BSP state, Game API v3,
Protocol 34 snapshots, Netchan and the nonblocking WinSock transport.
*/
package miniquake2.runtime.server_session

import std.array as sssessionarray
import miniquake2.qcommon.constants as ssqc
import miniquake2.qcommon.byteio as ssqbyteio
import miniquake2.qcommon.filesystem as ssfs
import miniquake2.qcommon.sizebuf as ssqsz
import miniquake2.qcommon.types as ssqtypes
import miniquake2.format.bsp as ssbsp
import miniquake2.collision.model as sscollision
import miniquake2.game.constants as ssgc
import miniquake2.game.types as ssgtypes
import miniquake2.game.null_game as ssgame
import miniquake2.game.base.spawn as ssbasespawn
import miniquake2.protocol.constants as sspc
import miniquake2.protocol.types as sspt
import miniquake2.network.constants as ssnc
import miniquake2.network.server as ssserver
import miniquake2.network.snapshot as sssnapshot
import miniquake2.network.runtime.types as ssnrtypes
import miniquake2.network.runtime.game_adapter as ssgameadapter
import miniquake2.network.runtime.commands as sscommands
import miniquake2.network.runtime.pump as sspump
import miniquake2.network.runtime.sound_dispatch as ssounddispatch
import miniquake2.network.runtime.multicast_dispatch as ssmulticastdispatch
import miniquake2.network.runtime.unicast_dispatch as ssunicastdispatch
import miniquake2.network.runtime.lifecycle as sslifecycle
import miniquake2.platform.system as sssystem
import miniquake2.platform.udp as ssudp
import miniquake2.server.game_bridge as ssbridge
import miniquake2.server.sound_events as ssoundevents
import miniquake2.server.game_messages as ssgamemessages

struct ServerSession
  bridgeRuntime
  gameExport
  networkRuntime
  socket
  clock
  collision
  mapName
  entityText
  frameNumber
  packetsReceived
  packetsSent
  packetsRejected
  retailFileSystem
  retailBaseDirectory
  closed
end struct

struct MapChangeResult
  changed
  deferred
  spawnCount
  mapName
  reason
end struct

function vector(value)
  if typeof(value) == "array" then return [value[0], value[1], value[2]] end if
  return [value.x, value.y, value.z]
end function

function protocolEntity(state)
  ssProtocolGameStateHolder = ssgtypes.stabilizeEntityState(state)
  ssProtocolOutputHolder = sspt.EntityState(
    ssProtocolGameStateHolder.number, void, void, void,
    ssProtocolGameStateHolder.modelIndex, ssProtocolGameStateHolder.modelIndex2, ssProtocolGameStateHolder.modelIndex3, ssProtocolGameStateHolder.modelIndex4,
    ssProtocolGameStateHolder.frame, ssProtocolGameStateHolder.skinNumber, ssProtocolGameStateHolder.effects, ssProtocolGameStateHolder.renderFx,
    ssProtocolGameStateHolder.solid, ssProtocolGameStateHolder.sound, ssProtocolGameStateHolder.event
  )
  ssProtocolOriginHolder = vector(ssProtocolGameStateHolder.origin)
  ssProtocolAnglesHolder = vector(ssProtocolGameStateHolder.angles)
  ssProtocolOldOriginHolder = vector(ssProtocolGameStateHolder.oldOrigin)
  ssProtocolOutputHolder.origin = ssProtocolOriginHolder
  ssProtocolOutputHolder.angles = ssProtocolAnglesHolder
  ssProtocolOutputHolder.oldOrigin = ssProtocolOldOriginHolder
  return ssProtocolOutputHolder
end function

function protocolPlayer(edict)
  if edict.client is void then return sspt.zeroPlayerState() end if
  state = edict.client.playerState
  output = sspt.PlayerState(void, void, void, void, void, void,
    state.gunIndex, state.gunFrame, void, state.fov, state.rdFlags, void)
  output.pmove = sspt.copyPmoveState(state.pmove)
  output.viewAngles = vector(state.viewAngles)
  output.viewOffset = vector(state.viewOffset)
  output.kickAngles = vector(state.kickAngles)
  output.gunAngles = vector(state.gunAngles)
  output.gunOffset = vector(state.gunOffset)
  output.blend = [state.blend[0], state.blend[1], state.blend[2], state.blend[3]]
  output.stats = sspt.copyNumbers(state.stats, ssgc.MAX_STATS, "server player stats")
  return output
end function

function packetEntities(gameExport)
  ssPacketExportHolder = gameExport
  ssPacketEntitiesHolder = array(ssPacketExportHolder.numEdicts)
  ssPacketEntityCount = 0
  ssPacketIndex = 1
  while ssPacketIndex < ssPacketExportHolder.numEdicts
    ssPacketEdictHolder = ssgtypes.stabilizeEdict(ssPacketExportHolder.edicts[ssPacketIndex])
    ssPacketStateHolder = ssgtypes.stabilizeEntityState(ssPacketEdictHolder.state)
    ssPacketNetworked = ssPacketStateHolder.modelIndex != 0 or ssPacketStateHolder.modelIndex2 != 0 or ssPacketStateHolder.modelIndex3 != 0 or ssPacketStateHolder.modelIndex4 != 0 or
      ssPacketStateHolder.effects != 0 or ssPacketStateHolder.sound != 0 or ssPacketStateHolder.event != 0
    if ssPacketEdictHolder.inUse and (ssPacketEdictHolder.serverFlags & ssgc.SVF_NOCLIENT) == 0 and ssPacketNetworked then
      ssPacketProtocolStateHolder = protocolEntity(ssPacketStateHolder)
      ssPacketEntitiesHolder[ssPacketEntityCount] = ssPacketProtocolStateHolder
      ssPacketStoredStateHolder = ssPacketEntitiesHolder[ssPacketEntityCount]
      ssPacketStoredStateHolder.origin = ssPacketProtocolStateHolder.origin
      ssPacketStoredStateHolder.angles = ssPacketProtocolStateHolder.angles
      ssPacketStoredStateHolder.oldOrigin = ssPacketProtocolStateHolder.oldOrigin
      ssPacketEntityCount = ssPacketEntityCount + 1
    end if
    ssPacketIndex = ssPacketIndex + 1
  end while
  return sssessionarray.slice(ssPacketEntitiesHolder, 0, ssPacketEntityCount)
end function

function entityVisible(session, viewer, edict)
  if session.collision is void then return true end if
  if edict.state.number == viewer.state.number then return true end if
  viewLeaf = sscollision.pointLeafNumber(session.collision, viewer.state.origin, 0)
  entityLeaf = sscollision.pointLeafNumber(session.collision, edict.state.origin, 0)
  view = session.collision.map.leafs[viewLeaf]
  target = session.collision.map.leafs[entityLeaf]
  if view.cluster < 0 or target.cluster < 0 then return false end if
  if not sscollision.areasConnected(session.collision, view.area, target.area) then return false end if
  kind = 0
  if edict.state.sound != 0 then kind = 1 end if
  row = ssbsp.decompressVisibility(session.collision.map.visibility, view.cluster, kind)
  byteIndex = target.cluster >> 3
  if byteIndex < 0 or byteIndex >= len(row) then return false end if
  return (row[byteIndex] & (1 << (target.cluster & 7))) != 0
end function

function packetEntitiesForClient(session, viewer)
  ssClientPacketSessionHolder = session
  ssClientPacketViewerHolder = viewer
  ssClientPacketEntitiesHolder = array(ssClientPacketSessionHolder.gameExport.numEdicts)
  ssClientPacketEntityCount = 0
  ssClientPacketIndex = 1
  while ssClientPacketIndex < ssClientPacketSessionHolder.gameExport.numEdicts and
      ssClientPacketEntityCount < ssnc.MAX_PACKET_ENTITIES
    ssClientPacketEdictHolder = ssgtypes.stabilizeEdict(ssClientPacketSessionHolder.gameExport.edicts[ssClientPacketIndex])
    ssClientPacketStateHolder = ssgtypes.stabilizeEntityState(ssClientPacketEdictHolder.state)
    ssClientPacketNetworked = ssClientPacketStateHolder.modelIndex != 0 or ssClientPacketStateHolder.modelIndex2 != 0 or ssClientPacketStateHolder.modelIndex3 != 0 or ssClientPacketStateHolder.modelIndex4 != 0 or
      ssClientPacketStateHolder.effects != 0 or ssClientPacketStateHolder.sound != 0 or ssClientPacketStateHolder.event != 0
    if ssClientPacketEdictHolder.inUse and (ssClientPacketEdictHolder.serverFlags & ssgc.SVF_NOCLIENT) == 0 and ssClientPacketNetworked and entityVisible(ssClientPacketSessionHolder, ssClientPacketViewerHolder, ssClientPacketEdictHolder) then
      ssClientPacketProtocolStateHolder = protocolEntity(ssClientPacketStateHolder)
      ssClientPacketEntitiesHolder[ssClientPacketEntityCount] = ssClientPacketProtocolStateHolder
      ssClientPacketStoredStateHolder = ssClientPacketEntitiesHolder[ssClientPacketEntityCount]
      ssClientPacketStoredStateHolder.origin = ssClientPacketProtocolStateHolder.origin
      ssClientPacketStoredStateHolder.angles = ssClientPacketProtocolStateHolder.angles
      ssClientPacketStoredStateHolder.oldOrigin = ssClientPacketProtocolStateHolder.oldOrigin
      ssClientPacketEntityCount = ssClientPacketEntityCount + 1
    end if
    ssClientPacketIndex = ssClientPacketIndex + 1
  end while
  return sssessionarray.slice(ssClientPacketEntitiesHolder, 0, ssClientPacketEntityCount)
end function

function soundEventOrigin(session, event)
  if event.position is not void then return event.position end if
  if not event.hasEntity or session.gameExport is void or event.entity < 0 or
      event.entity >= session.gameExport.numEdicts then return void end if
  edict = session.gameExport.edicts[event.entity]
  if edict.solid == ssgc.SOLID_BSP then
    return ssqtypes.Vec3(
      edict.state.origin.x + 0.5 * (edict.mins.x + edict.maxs.x),
      edict.state.origin.y + 0.5 * (edict.mins.y + edict.maxs.y),
      edict.state.origin.z + 0.5 * (edict.mins.z + edict.maxs.z))
  end if
  return ssqtypes.Vec3(edict.state.origin.x, edict.state.origin.y, edict.state.origin.z)
end function

function soundAudibleToClient(session, event, listener)
  if (event.channelFlags & ssgc.CHAN_NO_PHS_ADD) != 0 or event.attenuation == ssgc.ATTN_NONE then return true end if
  if session.collision is void then return true end if
  origin = soundEventOrigin(session, event)
  if origin is void then return true end if
  sourceLeafNumber = sscollision.pointLeafNumber(session.collision, origin, 0)
  listenerLeafNumber = sscollision.pointLeafNumber(session.collision, listener.state.origin, 0)
  if sourceLeafNumber < 0 or sourceLeafNumber >= len(session.collision.map.leafs) or
      listenerLeafNumber < 0 or listenerLeafNumber >= len(session.collision.map.leafs) then
    return error(9974, "sound PHS leaf outside collision map")
  end if
  sourceLeaf = session.collision.map.leafs[sourceLeafNumber]
  listenerLeaf = session.collision.map.leafs[listenerLeafNumber]
  if sourceLeaf.cluster < 0 or listenerLeaf.cluster < 0 then return false end if
  if not sscollision.areasConnected(session.collision, sourceLeaf.area, listenerLeaf.area) then return false end if
  visibility = session.collision.map.visibility
  if visibility is void or visibility.numClusters == 0 then return true end if
  if sourceLeaf.cluster >= visibility.numClusters or listenerLeaf.cluster >= visibility.numClusters then
    return error(9975, "sound PHS cluster outside visibility table")
  end if
  row = ssbsp.decompressVisibility(visibility, sourceLeaf.cluster, 1)
  byteIndex = listenerLeaf.cluster >> 3
  if byteIndex < 0 or byteIndex >= len(row) then return error(9976, "sound PHS row is malformed") end if
  return (row[byteIndex] & (1 << (listenerLeaf.cluster & 7))) != 0
end function

function routeSounds(session, events)
  // The full queue is validated before any target list is exposed.
  ssoundevents.encodeAll(events)
  runtime = session.networkRuntime
  routed = array(runtime.server.maxClients, void)
  slot = 0
  while slot < runtime.server.maxClients
    routed[slot] = []
    client = runtime.server.clients[slot]
    if client.state == ssnc.CS_SPAWNED and client.channel is not void then
      if session.gameExport is void or slot + 1 >= session.gameExport.numEdicts then
        return error(9977, "spawned sound recipient has no client edict")
      end if
      listener = session.gameExport.edicts[slot + 1]
      for each event in events
        if soundAudibleToClient(session, event, listener) then routed[slot] = routed[slot] + [event] end if
      end for
    end if
    slot = slot + 1
  end while
  return routed
end function

function multicastVisibleToClient(session, event, listener)
  destination = ssgamemessages.baseDestination(event.destination)
  if destination == ssgc.MULTICAST_ALL or session.collision is void then return true end if
  sourceLeafNumber = sscollision.pointLeafNumber(session.collision, event.origin, 0)
  listenerLeafNumber = sscollision.pointLeafNumber(session.collision, listener.state.origin, 0)
  if sourceLeafNumber < 0 or sourceLeafNumber >= len(session.collision.map.leafs) or
      listenerLeafNumber < 0 or listenerLeafNumber >= len(session.collision.map.leafs) then
    return error(9984, "multicast leaf outside collision map")
  end if
  sourceLeaf = session.collision.map.leafs[sourceLeafNumber]
  listenerLeaf = session.collision.map.leafs[listenerLeafNumber]
  if sourceLeaf.cluster < 0 or listenerLeaf.cluster < 0 then return false end if
  if not sscollision.areasConnected(session.collision, sourceLeaf.area, listenerLeaf.area) then return false end if
  visibility = session.collision.map.visibility
  if visibility is void or visibility.numClusters == 0 then return true end if
  if sourceLeaf.cluster >= visibility.numClusters or listenerLeaf.cluster >= visibility.numClusters then
    return error(9985, "multicast cluster outside visibility table")
  end if
  kind = 0
  if destination == ssgc.MULTICAST_PHS then kind = 1 end if
  row = ssbsp.decompressVisibility(visibility, sourceLeaf.cluster, kind)
  byteIndex = listenerLeaf.cluster >> 3
  if byteIndex < 0 or byteIndex >= len(row) then return error(9986, "multicast visibility row is malformed") end if
  return (row[byteIndex] & (1 << (listenerLeaf.cluster & 7))) != 0
end function

function routeMulticasts(session, events)
  ssgamemessages.validateAll(events)
  runtime = session.networkRuntime
  routed = array(runtime.server.maxClients, void)
  slot = 0
  while slot < runtime.server.maxClients
    routed[slot] = []
    client = runtime.server.clients[slot]
    if client.state == ssnc.CS_SPAWNED and client.channel is not void then
      if session.gameExport is void or slot + 1 >= session.gameExport.numEdicts then
        return error(9987, "spawned multicast recipient has no client edict")
      end if
      listener = session.gameExport.edicts[slot + 1]
      for each event in events
        if multicastVisibleToClient(session, event, listener) then routed[slot] = routed[slot] + [event] end if
      end for
    end if
    slot = slot + 1
  end while
  return routed
end function

function routeUnicasts(session, events)
  ssgamemessages.validateUnicastAll(events)
  runtime = session.networkRuntime
  routed = array(runtime.server.maxClients, void)
  slot = 0
  while slot < runtime.server.maxClients
    routed[slot] = []
    client = runtime.server.clients[slot]
    if client.state == ssnc.CS_SPAWNED and client.channel is not void then
      for each event in events
        if event.entity == slot + 1 then routed[slot] = routed[slot] + [event] end if
      end for
    end if
    slot = slot + 1
  end while
  return routed
end function

function synchronizeConfigStrings(session)
  runtime = session.networkRuntime
  bridge = session.bridgeRuntime
  index = 0
  while index < len(bridge.configStrings)
    if bridge.configStrings[index] != "" then runtime.configStrings[index] = bridge.configStrings[index] end if
    index = index + 1
  end while
  runtime.configStrings[ssqc.CS_NAME] = session.mapName
  runtime.configStrings[ssqc.CS_MAXCLIENTS] = runtime.server.maxClients + ""
  runtime.configStrings[ssqc.CS_MODELS + 1] = "maps/" + session.mapName + ".bsp"
  return true
end function

function synchronizeBaselines(session)
  runtime = session.networkRuntime
  for each entity in packetEntities(session.gameExport)
    runtime.baselines[entity.number] = sspt.copyEntityState(entity)
  end for
  return true
end function

function synchronizeServerState(session)
  synchronizeConfigStrings(session)
  synchronizeBaselines(session)
  return true
end function

function createCoreMode(mapName, entityText, collision, bindAddress, port, maxClients, dedicated, deathmatch, cooperative)
  if mapName == "" or typeof(entityText) != "string" then return error(9970, "server session requires map and entity text") end if
  if maxClients < 1 or maxClients > 256 then return error(9971, "server session maxclients outside range") end if
  if typeof(deathmatch) != "bool" or typeof(cooperative) != "bool" or (deathmatch and cooperative) then
    return error(9983, "server session requires one valid game mode")
  end if
  bridgeRuntime = ssbridge.createRuntime(maxClients)
  bridgeRuntime.collision = collision
  imports = ssbridge.makeImports(bridgeRuntime)
  gameExport = ssgame.GetGameApi(imports)
  ssgame.configureMaxClients(maxClients)
  bridgeRuntime.game = gameExport
  gameExport.init()
  serverSessionModeContextHolder = ssgame.playerContext()
  serverSessionModeContextHolder.deathmatch = deathmatch
  serverSessionModeContextHolder.cooperative = cooperative
  gameExport.spawnEntities(mapName, entityText, "")
  bridgeRuntime.mapName = mapName
  bridgeRuntime.spawnCount = 1

  callbacks = ssgameadapter.installGameExport(gameExport)
  serverInfo = "\\hostname\\MiniQuake2\\mapname\\" + mapName + "\\maxclients\\" + maxClients + "\\protocol\\34"
  server = ssserver.create(maxClients, "MiniQuake2", mapName, serverInfo, dedicated, false)
  networkRuntime = ssnrtypes.createServer(server, 1, "baseq2", mapName, callbacks)
  socket = ssudp.open(bindAddress, port)
  clock = sssystem.createClock()
  session = ServerSession(bridgeRuntime, gameExport, networkRuntime, socket, clock,
    collision, mapName, entityText, 0, 0, 0, 0, void, "", false)
  synchronizeServerState(session)
  return session
end function

function createCore(mapName, entityText, collision, bindAddress, port, maxClients, dedicated)
  return createCoreMode(mapName, entityText, collision, bindAddress, port, maxClients, dedicated, false, false)
end function

function createRetailMode(baseDirectory, mapName, bindAddress, port, maxClients, dedicated, deathmatch, cooperative)
  filesystem = ssfs.initialize(baseDirectory, "")
  path = "maps/" + mapName + ".bsp"
  map = ssbsp.parse(ssfs.readFile(filesystem, path), path)
  session = createCoreMode(mapName, map.entityText, sscollision.create(map), bindAddress, port, maxClients, dedicated, deathmatch, cooperative)
  session.retailFileSystem = filesystem
  session.retailBaseDirectory = baseDirectory
  return session
end function

function createRetail(baseDirectory, mapName, bindAddress, port, maxClients, dedicated)
  return createRetailMode(baseDirectory, mapName, bindAddress, port, maxClients, dedicated, false, false)
end function

function resetBridgeLevel(bridge, mapName, spawnCount, collision)
  bridge.mapName = mapName
  bridge.spawnCount = spawnCount
  bridge.timeMilliseconds = 0
  bridge.frameNumber = 0
  bridge.configStrings = array(ssqc.MAX_CONFIGSTRINGS, "")
  bridge.modelNames = array(ssqc.MAX_MODELS, "")
  bridge.soundNames = array(ssqc.MAX_SOUNDS, "")
  bridge.imageNames = array(ssqc.MAX_IMAGES, "")
  ssqsz.clear(bridge.multicastBuffer)
  bridge.pendingMulticasts = []
  bridge.nextMulticastSerial = 0
  bridge.pendingUnicasts = []
  bridge.nextUnicastSerial = 0
  bridge.pendingSounds = []
  bridge.nextSoundSerial = 0
  bridge.collision = collision
  return true
end function

function changeMapCore(session, mapName, entityText, collision)
  serverSessionChangeSessionHolder = session
  serverSessionChangeMapNameHolder = mapName
  serverSessionChangeEntityTextHolder = entityText
  serverSessionChangeCollisionHolder = collision
  if serverSessionChangeSessionHolder.closed then return error(9978, "cannot change map on a closed server session") end if
  if typeof(mapName) != "string" or mapName == "" or len(bytes(mapName)) >= ssqc.MAX_QPATH or
      typeof(entityText) != "string" then return error(9979, "map transition input is invalid") end if
  // Parse and materialize the complete entity document before touching the
  // live game, bridge, network clients, or reliable queues.
  serverSessionChangeParsedHolder = ssbasespawn.SpawnEntities(serverSessionChangeMapNameHolder, serverSessionChangeEntityTextHolder, "")
  if len(serverSessionChangeParsedHolder.edicts) + serverSessionChangeSessionHolder.networkRuntime.server.maxClients > ssqc.MAX_EDICTS then
    return error(9980, "map transition edict count exceeds server capacity")
  end if
  serverSessionChangePlanHolder = sslifecycle.prepareServerLevel(serverSessionChangeSessionHolder.networkRuntime, serverSessionChangeMapNameHolder)
  if not serverSessionChangePlanHolder.ready then
    return MapChangeResult(false, serverSessionChangePlanHolder.deferred, serverSessionChangeSessionHolder.networkRuntime.spawnCount,
      serverSessionChangeSessionHolder.mapName, serverSessionChangePlanHolder.reason)
  end if

  serverSessionChangeBridgeHolder = serverSessionChangeSessionHolder.bridgeRuntime
  serverSessionChangeOldMapNameHolder = serverSessionChangeSessionHolder.mapName
  serverSessionChangeOldEntityTextHolder = serverSessionChangeSessionHolder.entityText
  serverSessionChangeOldCollisionHolder = serverSessionChangeSessionHolder.collision
  serverSessionChangeOldBridgeMapHolder = serverSessionChangeBridgeHolder.mapName
  serverSessionChangeOldBridgeSpawn = serverSessionChangeBridgeHolder.spawnCount
  serverSessionChangeOldBridgeTime = serverSessionChangeBridgeHolder.timeMilliseconds
  serverSessionChangeOldBridgeFrame = serverSessionChangeBridgeHolder.frameNumber
  serverSessionChangeOldConfigStringsHolder = serverSessionChangeBridgeHolder.configStrings
  serverSessionChangeOldModelNamesHolder = serverSessionChangeBridgeHolder.modelNames
  serverSessionChangeOldSoundNamesHolder = serverSessionChangeBridgeHolder.soundNames
  serverSessionChangeOldImageNamesHolder = serverSessionChangeBridgeHolder.imageNames
  serverSessionChangeOldMulticastHolder = ssqsz.dataSlice(serverSessionChangeBridgeHolder.multicastBuffer)
  serverSessionChangeOldPendingMulticastsHolder = serverSessionChangeBridgeHolder.pendingMulticasts
  serverSessionChangeOldNextMulticastSerial = serverSessionChangeBridgeHolder.nextMulticastSerial
  serverSessionChangeOldPendingUnicastsHolder = serverSessionChangeBridgeHolder.pendingUnicasts
  serverSessionChangeOldNextUnicastSerial = serverSessionChangeBridgeHolder.nextUnicastSerial
  serverSessionChangeOldPendingSoundsHolder = serverSessionChangeBridgeHolder.pendingSounds
  serverSessionChangeOldNextSoundSerial = serverSessionChangeBridgeHolder.nextSoundSerial
  serverSessionChangeOldLogsHolder = serverSessionChangeBridgeHolder.logs

  resetBridgeLevel(serverSessionChangeBridgeHolder, serverSessionChangeMapNameHolder,
    serverSessionChangePlanHolder.spawnCount, serverSessionChangeCollisionHolder)
  serverSessionChangeSpawnedHolder = try(serverSessionChangeSessionHolder.gameExport.spawnEntities(
    serverSessionChangeMapNameHolder, serverSessionChangeEntityTextHolder, ""))
  if serverSessionChangeSpawnedHolder is error then
    serverSessionChangeBridgeHolder.mapName = serverSessionChangeOldBridgeMapHolder
    serverSessionChangeBridgeHolder.spawnCount = serverSessionChangeOldBridgeSpawn
    serverSessionChangeBridgeHolder.timeMilliseconds = serverSessionChangeOldBridgeTime
    serverSessionChangeBridgeHolder.frameNumber = serverSessionChangeOldBridgeFrame
    serverSessionChangeBridgeHolder.configStrings = serverSessionChangeOldConfigStringsHolder
    serverSessionChangeBridgeHolder.modelNames = serverSessionChangeOldModelNamesHolder
    serverSessionChangeBridgeHolder.soundNames = serverSessionChangeOldSoundNamesHolder
    serverSessionChangeBridgeHolder.imageNames = serverSessionChangeOldImageNamesHolder
    serverSessionChangeBridgeHolder.collision = serverSessionChangeOldCollisionHolder
    ssqsz.clear(serverSessionChangeBridgeHolder.multicastBuffer)
    ssqsz.writeBytes(serverSessionChangeBridgeHolder.multicastBuffer, serverSessionChangeOldMulticastHolder)
    serverSessionChangeRestoredHolder = try(serverSessionChangeSessionHolder.gameExport.spawnEntities(
      serverSessionChangeOldMapNameHolder, serverSessionChangeOldEntityTextHolder, ""))
    serverSessionChangeBridgeHolder.pendingMulticasts = serverSessionChangeOldPendingMulticastsHolder
    serverSessionChangeBridgeHolder.nextMulticastSerial = serverSessionChangeOldNextMulticastSerial
    serverSessionChangeBridgeHolder.pendingUnicasts = serverSessionChangeOldPendingUnicastsHolder
    serverSessionChangeBridgeHolder.nextUnicastSerial = serverSessionChangeOldNextUnicastSerial
    serverSessionChangeBridgeHolder.pendingSounds = serverSessionChangeOldPendingSoundsHolder
    serverSessionChangeBridgeHolder.nextSoundSerial = serverSessionChangeOldNextSoundSerial
    serverSessionChangeBridgeHolder.logs = serverSessionChangeOldLogsHolder
    if serverSessionChangeRestoredHolder is error then
      return error(9981, "map transition failed: " + serverSessionChangeSpawnedHolder.message +
        "; rollback failed: " + serverSessionChangeRestoredHolder.message)
    end if
    return serverSessionChangeSpawnedHolder
  end if

  sslifecycle.commitServerLevel(serverSessionChangeSessionHolder.networkRuntime, serverSessionChangePlanHolder)
  serverSessionChangeSessionHolder.collision = serverSessionChangeCollisionHolder
  serverSessionChangeSessionHolder.mapName = serverSessionChangeMapNameHolder
  serverSessionChangeSessionHolder.entityText = serverSessionChangeEntityTextHolder
  serverSessionChangeSessionHolder.frameNumber = 0
  synchronizeServerState(serverSessionChangeSessionHolder)
  return MapChangeResult(true, false, serverSessionChangePlanHolder.spawnCount, serverSessionChangeMapNameHolder, "changed")
end function

function changeMapRetail(session, baseDirectory, mapName)
  if typeof(baseDirectory) != "string" or baseDirectory == "" then return error(9982, "map transition base directory is invalid") end if
  filesystem = session.retailFileSystem
  if filesystem is void or session.retailBaseDirectory != baseDirectory then
    filesystem = ssfs.initialize(baseDirectory, "")
    session.retailFileSystem = filesystem
    session.retailBaseDirectory = baseDirectory
  end if
  path = "maps/" + mapName + ".bsp"
  map = ssbsp.parse(ssfs.readFile(filesystem, path), path)
  return changeMapCore(session, mapName, map.entityText, sscollision.create(map))
end function

function areaBits(session, clientEdict)
  if session.collision is void then return bytes() end if
  area = clientEdict.areaNumber
  if area < 0 or area >= len(session.collision.areaFloods) then area = 0 end if
  return sscollision.writeAreaBits(session.collision, area)
end function

function sendSnapshots(session, now)
  runtime = session.networkRuntime
  slot = 0
  sent = 0
  while slot < runtime.server.maxClients
    client = runtime.server.clients[slot]
    if client.state == ssnc.CS_SPAWNED and client.channel is not void then
      edict = session.gameExport.edicts[slot + 1]
      entities = packetEntitiesForClient(session, edict)
      // Netchan's MAX_MSGLEN includes its eight-byte server header.  Encoding
      // into a 1400-byte payload buffer could therefore succeed only for
      // transmit() to discard that unreliable tail.  Dense retail scenes can
      // reach exactly that narrow 1393..1400-byte window and leave a freshly
      // spawned client waiting forever for its first frame.
      //
      // Preserve entity-number order and trim only the tail until the complete
      // frame fits.  Failed attempts cannot update frame history because
      // writeFrameForClient commits history only after the final entity marker.
      maximumPayload = sspc.MAX_MSGLEN - sspc.PACKET_HEADER_SERVER
      entityCount = len(entities)
      message = void
      while entityCount >= 0 and message is void
        selected = sssessionarray.slice(entities, 0, entityCount)
        frame = sssnapshot.createFrame(session.frameNumber, areaBits(session, edict),
          protocolPlayer(edict), selected)
        candidate = ssqsz.alloc(maximumPayload)
        encoded = try(ssserver.writeClientFrame(runtime.server, slot, frame,
          runtime.baselines, candidate))
        if encoded is not error then message = candidate
        else entityCount = entityCount - 1
        end if
      end while
      if message is void then return error(9978, "snapshot player state exceeds packet payload budget") end if
      stats = sspump.sendServerPayload(runtime, session.socket, slot, now, ssqsz.dataSlice(message))
      if typeof(stats) == "struct" then sent = sent + stats.sent end if
    end if
    slot = slot + 1
  end while
  return sent
end function

function step(session)
  if session.closed then return error(9972, "server session is closed") end if
  now = ssqbyteio.truncInt(sssystem.milliseconds(session.clock))
  stats = sspump.pumpServer(session.networkRuntime, session.socket, now, 128)
  session.packetsReceived = session.packetsReceived + stats.received
  session.packetsSent = session.packetsSent + stats.sent
  session.packetsRejected = session.packetsRejected + stats.rejected
  // Keep the live product session progressing while a map-change client is
  // connected but not spawned.  The generic pump has the same policy, but
  // retaining it at this rooted session boundary prevents a full-graph local
  // capture from starving the one empty packet needed to expose a lost
  // transition reliable/ACK epoch.
  keepaliveSlot = 0
  while keepaliveSlot < session.networkRuntime.server.maxClients
    keepaliveClient = session.networkRuntime.server.clients[keepaliveSlot]
    if keepaliveClient.state == ssnc.CS_CONNECTED and keepaliveClient.channel is not void then
      keepaliveStats = sspump.sendServerPayload(session.networkRuntime,
        session.socket, keepaliveSlot, now, bytes())
      if typeof(keepaliveStats) == "struct" then
        session.packetsSent = session.packetsSent + keepaliveStats.sent
      end if
    end if
    keepaliveSlot = keepaliveSlot + 1
  end while
  session.gameExport.runFrame()
  // Baselines describe the immutable level-start state used during signon.
  // Rebuilding them from live edicts every frame both destroys that contract
  // and allocates a complete duplicate entity set twice per server tick.
  // Runtime configstrings remain dynamic and are synchronized after gameplay.
  synchronizeConfigStrings(session)
  session.frameNumber = session.frameNumber + 1
  session.networkRuntime.server.realTime = now
  routedUnicasts = routeUnicasts(session, session.bridgeRuntime.pendingUnicasts)
  unicastResult = ssunicastdispatch.dispatchRouted(session.networkRuntime, session.socket,
    session.bridgeRuntime.pendingUnicasts, routedUnicasts, now)
  session.packetsSent = session.packetsSent + unicastResult.sent
  if unicastResult.delivered then session.bridgeRuntime.pendingUnicasts = [] end if
  routedMulticasts = routeMulticasts(session, session.bridgeRuntime.pendingMulticasts)
  multicastResult = ssmulticastdispatch.dispatchRouted(session.networkRuntime, session.socket,
    session.bridgeRuntime.pendingMulticasts, routedMulticasts, now)
  session.packetsSent = session.packetsSent + multicastResult.sent
  if multicastResult.delivered then session.bridgeRuntime.pendingMulticasts = [] end if
  routedSounds = routeSounds(session, session.bridgeRuntime.pendingSounds)
  soundResult = ssounddispatch.dispatchRouted(session.networkRuntime, session.socket,
    session.bridgeRuntime.pendingSounds, routedSounds, now)
  session.packetsSent = session.packetsSent + soundResult.sent
  if soundResult.delivered then session.bridgeRuntime.pendingSounds = [] end if
  session.packetsSent = session.packetsSent + sendSnapshots(session, now)
  if (session.frameNumber % 10) == 0 then sscommands.replenishCommandMsec(session.networkRuntime) end if
  return session.frameNumber
end function

function run(session, frameLimit)
  if typeof(frameLimit) != "int" or frameLimit < 0 then return error(9973, "server frame limit must be non-negative") end if
  frames = 0
  while frameLimit == 0 or frames < frameLimit
    started = sssystem.milliseconds(session.clock)
    step(session)
    frames = frames + 1
    elapsed = sssystem.milliseconds(session.clock) - started
    if elapsed < 100 then sssystem.sleep(ssqbyteio.truncInt(100 - elapsed)) end if
  end while
  return frames
end function

function shutdown(session)
  if session.closed then return false end if
  ssudp.close(session.socket)
  session.gameExport.shutdown()
  session.closed = true
  return true
end function
