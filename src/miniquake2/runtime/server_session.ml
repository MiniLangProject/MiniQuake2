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
import miniquake2.qcommon.checksum as sschecksum
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
import miniquake2.protocol.netchan as ssnetchan
import miniquake2.network.constants as ssnc
import miniquake2.network.server as ssserver
import miniquake2.network.snapshot as sssnapshot
import miniquake2.network.runtime.types as ssnrtypes
import miniquake2.network.runtime.game_adapter as ssgameadapter
import miniquake2.network.runtime.messages as ssmessages
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
import miniquake2.server.administration as ssadministration

// Store server session data.
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
  paused
end struct

// Store map change result data.
struct MapChangeResult
  changed
  deferred
  spawnCount
  mapName
  reason
end struct

// One recipient-specific GameImport fragment ordered against all other message
// classes emitted during the same game frame.
struct ServerMessageFragment
  serial
  payload
end struct

// SV_FatPVS uses a fixed 64-leaf work array. The server is single-threaded,
// so the same storage can be reused for every 10 Hz client snapshot.
serverSessionFatPvsLeafScratch = array(64, 0)
serverSessionClientPacketEntityScratch = array(ssnc.MAX_PACKET_ENTITIES, void)
serverSessionEmptyMessageRouteCache = array(257)

// Return immutable empty recipient routes for a server width. Snapshot code
// only reads these prefixes, so all sessions with the same maxclients value
// can safely share the once-allocated routing shape.
function emptyServerMessageRoutes(maxClients)
  routes = serverSessionEmptyMessageRouteCache[maxClients]
  if routes is not void then return routes end if
  routes = array(maxClients)
  slot = 0
  while slot < maxClients
    routes[slot] = []
    slot = slot + 1
  end while
  serverSessionEmptyMessageRouteCache[maxClients] = routes
  return routes
end function

// Split a classic level specification into the BSP map and optional named
// spawn point.  A preceding cinematic/picture segment and the unit marker are
// server-side metadata; the persistent game session loads the final BSP.
function mapChangeComponents(specification)
  if typeof(specification) != "string" or specification == "" then
    return error(9986, "map transition specification is empty")
  end if
  // Resolve the final +chain entry first, strip the unit-reset marker, then
  // split its optional $spawnpoint suffix under the protocol path limits.
  start = 0
  scan = 0
  while scan < len(specification)
    if specification[scan] == "+" then start = scan + 1 end if
    scan = scan + 1
  end while
  if start < len(specification) and specification[start] == "*" then
    start = start + 1
  end if
  separator = len(specification)
  scan = start
  while scan < len(specification)
    if specification[scan] == "$" then separator = scan; break end if
    scan = scan + 1
  end while
  mapName = ""
  scan = start
  while scan < separator
    mapName = mapName + specification[scan]
    scan = scan + 1
  end while
  spawnPoint = ""
  scan = separator + 1
  while scan < len(specification)
    spawnPoint = spawnPoint + specification[scan]
    scan = scan + 1
  end while
  if mapName == "" or len(bytes(mapName)) >= ssqc.MAX_QPATH or
      len(bytes(spawnPoint)) >= ssqc.MAX_QPATH then
    return error(9986, "map transition specification is invalid")
  end if
  return [mapName, spawnPoint]
end function

// Return the vector value.
function vector(value)
  if typeof(value) == "array" then return [value[0], value[1], value[2]] end if
  return [value.x, value.y, value.z]
end function

// Return the protocol entity value.
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

// Return the protocol player value.
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

// Return the packet entities value.
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

// Report whether linked bounds visible.
function linkedBoundsVisible(collisionModel, nodeNumber, mins, maxs, row)
  if nodeNumber < 0 then
    leafNumber = -1 - nodeNumber
    if leafNumber < 0 or leafNumber >= len(collisionModel.map.leafs) then
      return false
    end if
    cluster = collisionModel.map.leafs[leafNumber].cluster
    if cluster < 0 then return false end if
    byteIndex = cluster >> 3
    return byteIndex >= 0 and byteIndex < len(row) and
      (row[byteIndex] & (1 << (cluster & 7))) != 0
  end if
  if nodeNumber >= len(collisionModel.map.nodes) then return false end if
  node = collisionModel.map.nodes[nodeNumber]
  plane = collisionModel.map.planes[node.planeIndex]
  side = sscollision.boxOnPlaneSide(mins, maxs, plane)
  if (side & 1) != 0 and linkedBoundsVisible(collisionModel, node.child0,
      mins, maxs, row) then return true end if
  return (side & 2) != 0 and linkedBoundsVisible(collisionModel, node.child1,
    mins, maxs, row)
end function

// SV_BuildClientFrame starts its fat-PVS query at the rendered eye position,
// not at the player edict origin near the middle of the collision hull. BSP
// leaves can split vertically between those points (notably at base1's spawn),
// which otherwise makes muzzle-height projectiles invisible to their owner.
function clientViewOrigin(viewer)
  origin = viewer.state.origin
  x = origin.x; y = origin.y; z = origin.z
  if viewer.client is not void and viewer.client.playerState is not void and
      viewer.client.playerState.viewOffset is not void then
    offset = viewer.client.playerState.viewOffset
    x = x + offset.x; y = y + offset.y; z = z + offset.z
  end if
  return ssqtypes.Vec3(x, y, z)
end function

// Return the fat pvs row value.
function fatPvsRow(collisionModel, origin)
  global serverSessionFatPvsLeafScratch
  visibility = collisionModel.map.visibility
  if visibility is void or visibility.numClusters == 0 then return bytes() end if
  mins = ssqtypes.Vec3(origin.x - 8.0, origin.y - 8.0, origin.z - 8.0)
  maxs = ssqtypes.Vec3(origin.x + 8.0, origin.y + 8.0, origin.z + 8.0)
  count = sscollision.collectBoxLeafs(collisionModel, 0, mins, maxs,
    serverSessionFatPvsLeafScratch, 0)
  output = bytes((visibility.numClusters + 7) >> 3)
  index = 0
  while index < count
    leafNumber = serverSessionFatPvsLeafScratch[index]
    cluster = collisionModel.map.leafs[leafNumber].cluster
    if cluster >= 0 and cluster < visibility.numClusters then
      source = sscollision.visibilityRow(collisionModel, cluster, 0)
      byteIndex = 0
      while byteIndex < len(output) and byteIndex < len(source)
        output[byteIndex] = output[byteIndex] | source[byteIndex]
        byteIndex = byteIndex + 1
      end while
    end if
    index = index + 1
  end while
  return output
end function

// Report whether entity visible from prepared pvs.
function entityVisibleFromPreparedPvs(session, viewer, viewLeaf, preparedPvs,
    edict)
  if session.collision is void then return true end if
  if edict.state.number == viewer.state.number then return true end if
  view = session.collision.map.leafs[viewLeaf]
  visibility = session.collision.map.visibility
  if visibility is void or visibility.numClusters == 0 then return true end if
  if view.cluster < 0 or view.cluster >= visibility.numClusters then return false end if

  // Doors may legally straddle two areas.  The original SV_BuildClientFrame
  // accepts either linked area; looking up only s.origin can select a solid or
  // disconnected leaf and suppress an otherwise visible brush entity.
  if edict.areaNumber != 0 then
    areaVisible = sscollision.areasConnected(session.collision, view.area,
      edict.areaNumber)
    if areaVisible != true and edict.areaNumber2 != 0 then
      areaVisible = sscollision.areasConnected(session.collision, view.area,
        edict.areaNumber2)
    end if
    if areaVisible != true then return false end if
  end if

  row = preparedPvs
  // SV_BuildClientFrame tests persistent beams against the source cluster's
  // PHS rather than the ordinary entity fat-PVS. This keeps target_laser and
  // similar beams present through portals where their source is hearable.
  if (edict.state.renderFx & ssgc.RF_BEAM) != 0 then
    row = sscollision.visibilityRow(session.collision, view.cluster, 1)
  end if
  // Stock SV_BuildClientFrame intentionally uses fatpvs here even for
  // entities with a loop sound (the clientphs alternative is commented out).
  // Sound-event routing has its own PHS path below and must not replace model
  // visibility for missiles such as the blaster bolt with lasfly.wav.
  if typeof(row) != "bytes" then
    row = sscollision.visibilityRow(session.collision, view.cluster, 0)
  end if
  if edict.numClusters >= 0 then
    clusterIndex = 0
    while clusterIndex < edict.numClusters
      cluster = edict.clusterNumbers[clusterIndex]
      byteIndex = cluster >> 3
      if byteIndex >= 0 and byteIndex < len(row) and
          (row[byteIndex] & (1 << (cluster & 7))) != 0 then return true end if
      clusterIndex = clusterIndex + 1
    end while
    return false
  end if

  // MAX_ENT_CLUSTERS overflow is uncommon (large trains/rotating brushes), but
  // it must remain correct. Traverse only BSP branches crossed by the cached
  // bounds, allocation-free, equivalent to CM_HeadnodeVisible without
  // confusing the inline collision hull headnode stored by this bridge.
  return linkedBoundsVisible(session.collision, 0, edict.absoluteMins,
    edict.absoluteMaxs, row)
end function

// Report whether entity visible from leaf.
function entityVisibleFromLeaf(session, viewer, viewLeaf, edict)
  return entityVisibleFromPreparedPvs(session, viewer, viewLeaf, void, edict)
end function

// Report whether entity visible.
function entityVisible(session, viewer, edict)
  if session.collision is void then return true end if
  origin = clientViewOrigin(viewer)
  viewLeaf = sscollision.pointLeafNumber(session.collision, origin, 0)
  return entityVisibleFromPreparedPvs(session, viewer, viewLeaf,
    fatPvsRow(session.collision, origin), edict)
end function

// Return the packet entities for client value.
function packetEntitiesForClient(session, viewer)
  ssClientPacketSessionHolder = session
  ssClientPacketViewerHolder = viewer
  // A protocol frame can never retain more than MAX_PACKET_ENTITIES.  Retail
  // maps commonly expose hundreds of edicts, so sizing this scratch array to
  // numEdicts needlessly multiplied snapshot allocation by every client.
  ssClientPacketEntitiesHolder = serverSessionClientPacketEntityScratch
  ssClientPacketEntityCount = 0
  ssClientPacketViewLeaf = -1
  ssClientPacketPvs = void
  ssClientPacketViewOrigin = clientViewOrigin(ssClientPacketViewerHolder)
  if ssClientPacketSessionHolder.collision is not void then
    ssClientPacketViewLeaf = sscollision.pointLeafNumber(ssClientPacketSessionHolder.collision,
      ssClientPacketViewOrigin, 0)
    ssClientPacketPvs = fatPvsRow(ssClientPacketSessionHolder.collision,
      ssClientPacketViewOrigin)
  end if
  ssClientPacketIndex = 1
  while ssClientPacketIndex < ssClientPacketSessionHolder.gameExport.numEdicts and
      ssClientPacketEntityCount < ssnc.MAX_PACKET_ENTITIES
    ssClientPacketEdictHolder = ssgtypes.stabilizeEdict(ssClientPacketSessionHolder.gameExport.edicts[ssClientPacketIndex])
    ssClientPacketStateHolder = ssgtypes.stabilizeEntityState(ssClientPacketEdictHolder.state)
    ssClientPacketNetworked = ssClientPacketStateHolder.modelIndex != 0 or ssClientPacketStateHolder.modelIndex2 != 0 or ssClientPacketStateHolder.modelIndex3 != 0 or ssClientPacketStateHolder.modelIndex4 != 0 or
      ssClientPacketStateHolder.effects != 0 or ssClientPacketStateHolder.sound != 0 or ssClientPacketStateHolder.event != 0
    ssClientPacketVisible = true
    if ssClientPacketEdictHolder.inUse and
        (ssClientPacketEdictHolder.serverFlags & ssgc.SVF_NOCLIENT) == 0 and
        ssClientPacketNetworked and ssClientPacketSessionHolder.collision is not void then
      ssClientPacketVisible = entityVisibleFromPreparedPvs(
        ssClientPacketSessionHolder, ssClientPacketViewerHolder,
        ssClientPacketViewLeaf, ssClientPacketPvs, ssClientPacketEdictHolder)
    end if
    // Stock Quake II drops distant sound-only entity states even when their
    // cluster is visible because normal attenuation makes them inaudible.
    if ssClientPacketVisible and ssClientPacketStateHolder.modelIndex == 0 then
      ssClientPacketDeltaX = ssClientPacketViewOrigin.x - ssClientPacketStateHolder.origin.x
      ssClientPacketDeltaY = ssClientPacketViewOrigin.y - ssClientPacketStateHolder.origin.y
      ssClientPacketDeltaZ = ssClientPacketViewOrigin.z - ssClientPacketStateHolder.origin.z
      ssClientPacketDistanceSquared = ssClientPacketDeltaX * ssClientPacketDeltaX +
        ssClientPacketDeltaY * ssClientPacketDeltaY +
        ssClientPacketDeltaZ * ssClientPacketDeltaZ
      if ssClientPacketDistanceSquared > 160000.0 then ssClientPacketVisible = false end if
    end if
    if ssClientPacketEdictHolder.inUse and (ssClientPacketEdictHolder.serverFlags & ssgc.SVF_NOCLIENT) == 0 and ssClientPacketNetworked and ssClientPacketVisible then
      ssClientPacketProtocolStateHolder = protocolEntity(ssClientPacketStateHolder)
      // The client prediction world must never clip the shooter against its
      // own missiles. Other clients still receive the authored solid value.
      if ssClientPacketEdictHolder.owner is not void and
          ssClientPacketEdictHolder.owner.state.number == ssClientPacketViewerHolder.state.number then
        ssClientPacketProtocolStateHolder.solid = 0
      end if
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

// Return the sound event origin.
function soundEventOrigin(session, event)
  if event.routingPosition is not void then return event.routingPosition end if
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

// Return the sound audible to client from leaf.
function soundAudibleToClientFromLeaf(session, event, listener, listenerLeafNumber)
  if (event.channelFlags & ssgc.CHAN_NO_PHS_ADD) != 0 or event.attenuation == ssgc.ATTN_NONE then return true end if
  if session.collision is void then return true end if
  origin = soundEventOrigin(session, event)
  if origin is void then return true end if
  sourceLeafNumber = sscollision.pointLeafNumber(session.collision, origin, 0)
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
  row = sscollision.visibilityRow(session.collision, sourceLeaf.cluster, 1)
  byteIndex = listenerLeaf.cluster >> 3
  if byteIndex < 0 or byteIndex >= len(row) then return error(9976, "sound PHS row is malformed") end if
  return (row[byteIndex] & (1 << (listenerLeaf.cluster & 7))) != 0
end function

// Return the sound audible to client value.
function soundAudibleToClient(session, event, listener)
  if session.collision is void then return true end if
  listenerLeafNumber = sscollision.pointLeafNumber(session.collision,
    listener.state.origin, 0)
  return soundAudibleToClientFromLeaf(session, event, listener,
    listenerLeafNumber)
end function

// Return the route sounds value.
function routeSounds(session, events)
  // The full queue is validated before any target list is exposed.
  ssoundevents.encodeAll(events)
  runtime = session.networkRuntime
  routed = array(runtime.server.maxClients, void)
  slot = 0
  while slot < runtime.server.maxClients
    audible = array(len(events), void)
    audibleCount = 0
    client = runtime.server.clients[slot]
    if client.state == ssnc.CS_SPAWNED and client.channel is not void then
      if session.gameExport is void or slot + 1 >= session.gameExport.numEdicts then
        return error(9977, "spawned sound recipient has no client edict")
      end if
      listener = session.gameExport.edicts[slot + 1]
      listenerLeafNumber = -1
      if session.collision is not void then
        listenerLeafNumber = sscollision.pointLeafNumber(session.collision,
          listener.state.origin, 0)
      end if
      for each event in events
        if soundAudibleToClientFromLeaf(session, event, listener,
            listenerLeafNumber) then
          audible[audibleCount] = event
          audibleCount = audibleCount + 1
        end if
      end for
    end if
    routed[slot] = sssessionarray.slice(audible, 0, audibleCount)
    slot = slot + 1
  end while
  return routed
end function

// Report whether multicast visible to client from leaf.
function multicastVisibleToClientFromLeaf(session, event, listenerLeafNumber)
  destination = ssgamemessages.baseDestination(event.destination)
  if destination == ssgc.MULTICAST_ALL or session.collision is void then return true end if
  sourceLeafNumber = sscollision.pointLeafNumber(session.collision, event.origin, 0)
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
  row = sscollision.visibilityRow(session.collision, sourceLeaf.cluster, kind)
  byteIndex = listenerLeaf.cluster >> 3
  if byteIndex < 0 or byteIndex >= len(row) then return error(9986, "multicast visibility row is malformed") end if
  return (row[byteIndex] & (1 << (listenerLeaf.cluster & 7))) != 0
end function

// Report whether multicast visible to client.
function multicastVisibleToClient(session, event, listener)
  listenerLeafNumber = -1
  if session.collision is not void then
    listenerLeafNumber = sscollision.pointLeafNumber(session.collision,
      listener.state.origin, 0)
  end if
  return multicastVisibleToClientFromLeaf(session, event, listenerLeafNumber)
end function

// Return the route multicasts value.
function routeMulticasts(session, events)
  ssgamemessages.validateAll(events)
  runtime = session.networkRuntime
  routed = array(runtime.server.maxClients, void)
  slot = 0
  while slot < runtime.server.maxClients
    visible = array(len(events), void)
    visibleCount = 0
    client = runtime.server.clients[slot]
    if client.state == ssnc.CS_SPAWNED and client.channel is not void then
      if session.gameExport is void or slot + 1 >= session.gameExport.numEdicts then
        return error(9987, "spawned multicast recipient has no client edict")
      end if
      listener = session.gameExport.edicts[slot + 1]
      listenerLeafNumber = -1
      if session.collision is not void then
        listenerLeafNumber = sscollision.pointLeafNumber(session.collision,
          listener.state.origin, 0)
      end if
      for each event in events
        if multicastVisibleToClientFromLeaf(session, event,
            listenerLeafNumber) then
          visible[visibleCount] = event
          visibleCount = visibleCount + 1
        end if
      end for
    end if
    routed[slot] = sssessionarray.slice(visible, 0, visibleCount)
    slot = slot + 1
  end while
  return routed
end function

// Return the route unicasts value.
function routeUnicasts(session, events)
  ssgamemessages.validateUnicastAll(events)
  runtime = session.networkRuntime
  routed = array(runtime.server.maxClients, void)
  counts = array(runtime.server.maxClients, 0)
  for each countedEvent in events
    countedSlot = countedEvent.entity - 1
    if countedSlot >= 0 and countedSlot < runtime.server.maxClients then
      countedClient = runtime.server.clients[countedSlot]
      if countedClient.state == ssnc.CS_SPAWNED and
          countedClient.channel is not void then
        counts[countedSlot] = counts[countedSlot] + 1
      end if
    end if
  end for
  slot = 0
  while slot < runtime.server.maxClients
    routed[slot] = array(counts[slot], void)
    slot = slot + 1
  end while
  offsets = array(runtime.server.maxClients, 0)
  for each targetedEvent in events
    targetedSlot = targetedEvent.entity - 1
    if targetedSlot >= 0 and targetedSlot < runtime.server.maxClients and
        counts[targetedSlot] > 0 then
      targetedOffset = offsets[targetedSlot]
      routed[targetedSlot][targetedOffset] = targetedEvent
      offsets[targetedSlot] = targetedOffset + 1
    end if
  end for
  return routed
end function

// Return only multicast events whose destination has the requested reliable
// class. Original Quake II writes reliable messages and transient datagrams to
// separate client buffers, so one blocked ACK must never retain later effects.
function multicastReliabilitySubset(events, reliable)
  count = 0
  for each countedEvent in events
    if ssgamemessages.reliableDestination(countedEvent.destination) ==
        reliable then count = count + 1 end if
  end for
  output = array(count, void)
  index = 0
  for each selectedEvent in events
    if ssgamemessages.reliableDestination(selectedEvent.destination) ==
        reliable then
      output[index] = selectedEvent
      index = index + 1
    end if
  end for
  return output
end function

// Return only unicast events with the requested reliability class.
function unicastReliabilitySubset(events, reliable)
  count = 0
  for each countedEvent in events
    if countedEvent.reliable == reliable then count = count + 1 end if
  end for
  output = array(count, void)
  index = 0
  for each selectedEvent in events
    if selectedEvent.reliable == reliable then
      output[index] = selectedEvent
      index = index + 1
    end if
  end for
  return output
end function

// Return only sound events with the requested CHAN_RELIABLE state.
function soundReliabilitySubset(events, reliable)
  count = 0
  for each countedEvent in events
    eventReliable = (countedEvent.channelFlags & ssgc.CHAN_RELIABLE) != 0
    if eventReliable == reliable then count = count + 1 end if
  end for
  output = array(count, void)
  index = 0
  for each selectedEvent in events
    eventReliable = (selectedEvent.channelFlags & ssgc.CHAN_RELIABLE) != 0
    if eventReliable == reliable then
      output[index] = selectedEvent
      index = index + 1
    end if
  end for
  return output
end function

// Synchronize config strings.
function synchronizeConfigStrings(session)
  runtime = session.networkRuntime
  bridge = session.bridgeRuntime
  index = 0
  while index < len(bridge.configStrings)
    if bridge.configStringDirty[index] then
      value = bridge.configStrings[index]
      if runtime.configStrings[index] != value then
        slot = 0
        while slot < runtime.server.maxClients
          client = runtime.server.clients[slot]
          if client.state == ssnc.CS_SPAWNED and client.channel is not void then
            buffer = ssqsz.alloc(ssqc.MAX_STRING_CHARS + 4)
            ssmessages.writeConfigString(buffer, index, value)
            // Stage on the recipient's ordinary reliable message exactly like
            // SV_Configstring. The following unicast/multicast/sound dispatch
            // can then coalesce same-frame commands into one ordered reliable
            // payload instead of forcing the sound queue behind a new ACK.
            ssnetchan.queueReliable(client.channel, ssqsz.dataSlice(buffer))
          end if
          slot = slot + 1
        end while
        runtime.configStrings[index] = value
      end if
      bridge.configStringDirty[index] = false
    end if
    index = index + 1
  end while
  // SP_worldspawn publishes the authored level title through CS_NAME.  Keep
  // the engine-side map name only as a fallback for synthetic/core callers
  // whose entity document did not provide that Game API configstring.
  if runtime.configStrings[ssqc.CS_NAME] == "" then
    runtime.configStrings[ssqc.CS_NAME] = session.mapName
  end if
  runtime.configStrings[ssqc.CS_MAXCLIENTS] = runtime.server.maxClients + ""
  runtime.configStrings[ssqc.CS_MODELS + 1] = "maps/" + session.mapName + ".bsp"
  return true
end function

// Synchronize baselines.
function synchronizeBaselines(session)
  runtime = session.networkRuntime
  for each entity in packetEntities(session.gameExport)
    runtime.baselines[entity.number] = sspt.copyEntityState(entity)
  end for
  return true
end function

// Synchronize server state.
function synchronizeServerState(session)
  synchronizeConfigStrings(session)
  synchronizeBaselines(session)
  return true
end function

// Protocol 34 download clients compare the BSP's original COM_BlockChecksum
// before publishing a downloaded map. Core constructors intentionally accept
// parsed state only, so retail/bootstrap callers attach the raw bytes here.
function setMapChecksum(session, mapBytes)
  if session is void or typeof(mapBytes) != "bytes" or len(mapBytes) < 1 then
    return error(9989, "server map checksum requires BSP bytes")
  end if
  serverSessionMapChecksum = sschecksum.blockChecksum(mapBytes, 0,
    len(mapBytes)) + ""
  session.networkRuntime.configStrings[ssqc.CS_MAPCHECKSUM] = serverSessionMapChecksum
  session.bridgeRuntime.configStrings[ssqc.CS_MAPCHECKSUM] = serverSessionMapChecksum
  session.bridgeRuntime.configStringDirty[ssqc.CS_MAPCHECKSUM] = false
  return serverSessionMapChecksum
end function

// Create core mode at skill.
function createCoreModeAtSkill(mapName, entityText, collision, spawnPoint, bindAddress,
    port, maxClients, dedicated, deathmatch, cooperative, skill)
  if mapName == "" or typeof(entityText) != "string" then return error(9970, "server session requires map and entity text") end if
  if typeof(spawnPoint) != "string" or len(bytes(spawnPoint)) >= ssqc.MAX_QPATH then
    return error(9984, "server session spawn point is invalid")
  end if
  if maxClients < 1 or maxClients > 256 then return error(9971, "server session maxclients outside range") end if
  if typeof(deathmatch) != "bool" or typeof(cooperative) != "bool" or (deathmatch and cooperative) then
    return error(9983, "server session requires one valid game mode")
  end if
  if typeof(skill) != "int" or skill < 0 or skill > 3 then
    return error(9985, "server session skill outside [0,3]")
  end if
  bridgeRuntime = ssbridge.createRuntime(maxClients)
  ssgamemessages.enableOptimizedQueues(bridgeRuntime)
  bridgeRuntime.collision = collision
  imports = ssbridge.makeImports(bridgeRuntime)
  gameExport = ssgame.GetGameApi(imports)
  ssgame.configureMaxClients(maxClients)
  ssgame.configureSkill(skill)
  bridgeRuntime.game = gameExport
  gameExport.init()
  serverSessionModeContextHolder = ssgame.playerContext()
  serverSessionModeContextHolder.deathmatch = deathmatch
  serverSessionModeContextHolder.cooperative = cooperative
  gameExport.spawnEntities(mapName, entityText, spawnPoint)
  bridgeRuntime.mapName = mapName
  bridgeRuntime.spawnCount = 1

  callbacks = ssgameadapter.installGameExportWithCommands(gameExport,
    bridgeRuntime.commands)
  serverInfo = "\\hostname\\MiniQuake2\\mapname\\" + mapName + "\\maxclients\\" + maxClients + "\\protocol\\34"
  server = ssserver.create(maxClients, "MiniQuake2", mapName, serverInfo, dedicated, false)
  networkRuntime = ssnrtypes.createServer(server, 1, "baseq2", mapName, callbacks)
  ssadministration.activate(networkRuntime.administration)
  ssadministration.setWritePath(networkRuntime.administration, "listip.cfg")
  socket = ssudp.open(bindAddress, port)
  clock = sssystem.createClock()
  session = ServerSession(bridgeRuntime, gameExport, networkRuntime, socket, clock,
    collision, mapName, entityText, 0, 0, 0, 0, void, "", false, false)
  synchronizeServerState(session)
  return session
end function

// Create core mode at.
function createCoreModeAt(mapName, entityText, collision, spawnPoint, bindAddress,
    port, maxClients, dedicated, deathmatch, cooperative)
  return createCoreModeAtSkill(mapName, entityText, collision, spawnPoint,
    bindAddress, port, maxClients, dedicated, deathmatch, cooperative, 1)
end function

// Create core mode.
function createCoreMode(mapName, entityText, collision, bindAddress, port, maxClients, dedicated, deathmatch, cooperative)
  return createCoreModeAt(mapName, entityText, collision, "", bindAddress, port,
    maxClients, dedicated, deathmatch, cooperative)
end function

// Create core at.
function createCoreAt(mapName, entityText, collision, spawnPoint, bindAddress, port, maxClients, dedicated)
  return createCoreModeAt(mapName, entityText, collision, spawnPoint, bindAddress,
    port, maxClients, dedicated, false, false)
end function

// Create core at skill.
function createCoreAtSkill(mapName, entityText, collision, spawnPoint, bindAddress,
    port, maxClients, dedicated, skill)
  return createCoreModeAtSkill(mapName, entityText, collision, spawnPoint,
    bindAddress, port, maxClients, dedicated, false, false, skill)
end function

// Create core.
function createCore(mapName, entityText, collision, bindAddress, port, maxClients, dedicated)
  return createCoreAt(mapName, entityText, collision, "", bindAddress, port, maxClients, dedicated)
end function

// Create retail mode at.
function createRetailModeAt(baseDirectory, mapName, spawnPoint, bindAddress, port, maxClients, dedicated, deathmatch, cooperative)
  filesystem = ssfs.initialize(baseDirectory, "")
  path = "maps/" + mapName + ".bsp"
  serverSessionRetailBytes = ssfs.readFile(filesystem, path)
  map = ssbsp.parse(serverSessionRetailBytes, path)
  session = createCoreModeAt(mapName, map.entityText, sscollision.create(map), spawnPoint,
    bindAddress, port, maxClients, dedicated, deathmatch, cooperative)
  session.retailFileSystem = filesystem
  session.retailBaseDirectory = baseDirectory
  setMapChecksum(session, serverSessionRetailBytes)
  ssadministration.setWritePath(session.networkRuntime.administration,
    baseDirectory + "\\baseq2\\listip.cfg")
  return session
end function

// Create retail mode at skill.
function createRetailModeAtSkill(baseDirectory, mapName, spawnPoint, bindAddress,
    port, maxClients, dedicated, deathmatch, cooperative, skill)
  serverSessionSkillFileSystem = ssfs.initialize(baseDirectory, "")
  serverSessionSkillPath = "maps/" + mapName + ".bsp"
  serverSessionSkillBytes = ssfs.readFile(serverSessionSkillFileSystem,
    serverSessionSkillPath)
  serverSessionSkillMap = ssbsp.parse(serverSessionSkillBytes,
    serverSessionSkillPath)
  serverSessionSkillValue = createCoreModeAtSkill(mapName,
    serverSessionSkillMap.entityText, sscollision.create(serverSessionSkillMap),
    spawnPoint, bindAddress, port, maxClients, dedicated, deathmatch, cooperative, skill)
  serverSessionSkillValue.retailFileSystem = serverSessionSkillFileSystem
  serverSessionSkillValue.retailBaseDirectory = baseDirectory
  setMapChecksum(serverSessionSkillValue, serverSessionSkillBytes)
  ssadministration.setWritePath(serverSessionSkillValue.networkRuntime.administration,
    baseDirectory + "\\baseq2\\listip.cfg")
  return serverSessionSkillValue
end function

// Create retail mode.
function createRetailMode(baseDirectory, mapName, bindAddress, port, maxClients, dedicated, deathmatch, cooperative)
  return createRetailModeAt(baseDirectory, mapName, "", bindAddress, port,
    maxClients, dedicated, deathmatch, cooperative)
end function

// Create retail at.
function createRetailAt(baseDirectory, mapName, spawnPoint, bindAddress, port, maxClients, dedicated)
  return createRetailModeAt(baseDirectory, mapName, spawnPoint, bindAddress,
    port, maxClients, dedicated, false, false)
end function

// Create retail at skill.
function createRetailAtSkill(baseDirectory, mapName, spawnPoint, bindAddress,
    port, maxClients, dedicated, skill)
  return createRetailModeAtSkill(baseDirectory, mapName, spawnPoint, bindAddress,
    port, maxClients, dedicated, false, false, skill)
end function

// Create retail.
function createRetail(baseDirectory, mapName, bindAddress, port, maxClients, dedicated)
  return createRetailAt(baseDirectory, mapName, "", bindAddress, port, maxClients, dedicated)
end function

// Reset bridge level.
function resetBridgeLevel(bridge, mapName, spawnCount, collision)
  bridge.mapName = mapName
  bridge.spawnCount = spawnCount
  bridge.timeMilliseconds = 0
  bridge.frameNumber = 0
  bridge.configStrings = array(ssqc.MAX_CONFIGSTRINGS, "")
  bridge.configStringDirty = array(ssqc.MAX_CONFIGSTRINGS, false)
  bridge.modelNames = array(ssqc.MAX_MODELS, "")
  bridge.soundNames = array(ssqc.MAX_SOUNDS, "")
  bridge.imageNames = array(ssqc.MAX_IMAGES, "")
  ssqsz.clear(bridge.multicastBuffer)
  ssgamemessages.clearMulticasts(bridge)
  bridge.nextMulticastSerial = 0
  ssgamemessages.clearUnicasts(bridge)
  bridge.nextUnicastSerial = 0
  ssoundevents.clearPending(bridge)
  bridge.nextSoundSerial = 0
  bridge.collision = collision
  ssbridge.clearSpatialCaches(bridge)
  return true
end function

// Map change core.
function changeMapCore(session, mapName, entityText, collision)
  serverSessionChangeSessionHolder = session
  serverSessionChangeComponentsHolder = mapChangeComponents(mapName)
  serverSessionChangeMapNameHolder = serverSessionChangeComponentsHolder[0]
  serverSessionChangeSpawnPointHolder = serverSessionChangeComponentsHolder[1]
  serverSessionChangeEntityTextHolder = entityText
  serverSessionChangeCollisionHolder = collision
  if serverSessionChangeSessionHolder.closed then return error(9978, "cannot change map on a closed server session") end if
  if typeof(mapName) != "string" or mapName == "" or len(bytes(mapName)) >= ssqc.MAX_QPATH or
      typeof(entityText) != "string" then return error(9979, "map transition input is invalid") end if
  // Parse and materialize the complete entity document before touching the
  // live game, bridge, network clients, or reliable queues.
  serverSessionChangeModeHolder = ssgame.playerContext()
  serverSessionChangeParsedHolder = ssbasespawn.SpawnEntitiesForMode(
    serverSessionChangeMapNameHolder, serverSessionChangeEntityTextHolder, "",
    ssgame.configuredGameSkill(), serverSessionChangeModeHolder.deathmatch)
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
  serverSessionChangeOldConfigStringDirtyHolder = serverSessionChangeBridgeHolder.configStringDirty
  serverSessionChangeOldModelNamesHolder = serverSessionChangeBridgeHolder.modelNames
  serverSessionChangeOldSoundNamesHolder = serverSessionChangeBridgeHolder.soundNames
  serverSessionChangeOldImageNamesHolder = serverSessionChangeBridgeHolder.imageNames
  serverSessionChangeOldMulticastHolder = ssqsz.dataSlice(serverSessionChangeBridgeHolder.multicastBuffer)
  serverSessionChangeOldPendingMulticastsHolder = ssgamemessages.pendingMulticastSnapshot(
    serverSessionChangeBridgeHolder)
  serverSessionChangeOldNextMulticastSerial = serverSessionChangeBridgeHolder.nextMulticastSerial
  serverSessionChangeOldPendingUnicastsHolder = ssgamemessages.pendingUnicastSnapshot(
    serverSessionChangeBridgeHolder)
  serverSessionChangeOldNextUnicastSerial = serverSessionChangeBridgeHolder.nextUnicastSerial
  serverSessionChangeOldPendingSoundsHolder = ssoundevents.pendingSnapshot(
    serverSessionChangeBridgeHolder)
  serverSessionChangeOldNextSoundSerial = serverSessionChangeBridgeHolder.nextSoundSerial
  serverSessionChangeOldLogsHolder = serverSessionChangeBridgeHolder.logs
  serverSessionChangeOldSpawnPointHolder = ssgame.playerContext().spawnPoint

  resetBridgeLevel(serverSessionChangeBridgeHolder, serverSessionChangeMapNameHolder,
    serverSessionChangePlanHolder.spawnCount, serverSessionChangeCollisionHolder)
  serverSessionChangeSpawnedHolder = try(serverSessionChangeSessionHolder.gameExport.spawnEntities(
    serverSessionChangeMapNameHolder, serverSessionChangeEntityTextHolder,
    serverSessionChangeSpawnPointHolder))
  if serverSessionChangeSpawnedHolder is error then
    serverSessionChangeBridgeHolder.mapName = serverSessionChangeOldBridgeMapHolder
    serverSessionChangeBridgeHolder.spawnCount = serverSessionChangeOldBridgeSpawn
    serverSessionChangeBridgeHolder.timeMilliseconds = serverSessionChangeOldBridgeTime
    serverSessionChangeBridgeHolder.frameNumber = serverSessionChangeOldBridgeFrame
    serverSessionChangeBridgeHolder.configStrings = serverSessionChangeOldConfigStringsHolder
    serverSessionChangeBridgeHolder.configStringDirty = serverSessionChangeOldConfigStringDirtyHolder
    serverSessionChangeBridgeHolder.modelNames = serverSessionChangeOldModelNamesHolder
    serverSessionChangeBridgeHolder.soundNames = serverSessionChangeOldSoundNamesHolder
    serverSessionChangeBridgeHolder.imageNames = serverSessionChangeOldImageNamesHolder
    serverSessionChangeBridgeHolder.collision = serverSessionChangeOldCollisionHolder
    ssbridge.clearSpatialCaches(serverSessionChangeBridgeHolder)
    ssqsz.clear(serverSessionChangeBridgeHolder.multicastBuffer)
    ssqsz.writeBytes(serverSessionChangeBridgeHolder.multicastBuffer, serverSessionChangeOldMulticastHolder)
    serverSessionChangeRestoredHolder = try(
      serverSessionChangeSessionHolder.gameExport.spawnEntities(
        serverSessionChangeOldMapNameHolder, serverSessionChangeOldEntityTextHolder,
        serverSessionChangeOldSpawnPointHolder))
    ssgamemessages.restoreMulticasts(serverSessionChangeBridgeHolder,
      serverSessionChangeOldPendingMulticastsHolder)
    serverSessionChangeBridgeHolder.nextMulticastSerial = serverSessionChangeOldNextMulticastSerial
    ssgamemessages.restoreUnicasts(serverSessionChangeBridgeHolder,
      serverSessionChangeOldPendingUnicastsHolder)
    serverSessionChangeBridgeHolder.nextUnicastSerial = serverSessionChangeOldNextUnicastSerial
    ssoundevents.restorePending(serverSessionChangeBridgeHolder,
      serverSessionChangeOldPendingSoundsHolder)
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

// Map change retail.
function changeMapRetail(session, baseDirectory, mapName)
  if typeof(baseDirectory) != "string" or baseDirectory == "" then return error(9982, "map transition base directory is invalid") end if
  filesystem = session.retailFileSystem
  if filesystem is void or session.retailBaseDirectory != baseDirectory then
    filesystem = ssfs.initialize(baseDirectory, "")
    session.retailFileSystem = filesystem
    session.retailBaseDirectory = baseDirectory
  end if
  serverSessionRetailComponentsHolder = mapChangeComponents(mapName)
  serverSessionRetailMapNameHolder = serverSessionRetailComponentsHolder[0]
  path = "maps/" + serverSessionRetailMapNameHolder + ".bsp"
  serverSessionChangeRetailBytes = ssfs.readFile(filesystem, path)
  map = ssbsp.parse(serverSessionChangeRetailBytes, path)
  serverSessionChangeRetailResult = changeMapCore(session, mapName,
    map.entityText, sscollision.create(map))
  if serverSessionChangeRetailResult.changed then
    setMapChecksum(session, serverSessionChangeRetailBytes)
  end if
  return serverSessionChangeRetailResult
end function

// Return the area bits value.
function areaBits(session, clientEdict)
  if session.collision is void then return bytes() end if
  area = clientEdict.areaNumber
  if area < 0 or area >= len(session.collision.areaFloods) then area = 0 end if
  return sscollision.writeAreaBits(session.collision, area)
end function

// Merge one client's typed GameImport queues by their shared emission serial.
// Reliable and transient buffers remain separate, but neither buffer may
// reorder sound around multicast/unicast commands emitted before it.
function frameMessageFragments(unicasts, multicasts, sounds, reliable)
  count = 0
  for each event in unicasts
    if event.reliable == reliable then count = count + 1 end if
  end for
  for each event in multicasts
    if ssgamemessages.reliableDestination(event.destination) == reliable then
      count = count + 1
    end if
  end for
  for each event in sounds
    if (((event.channelFlags & ssgc.CHAN_RELIABLE) != 0) == reliable) then
      count = count + 1
    end if
  end for
  output = array(count, void)
  index = 0
  for each event in unicasts
    if event.reliable == reliable then
      output[index] = ServerMessageFragment(event.serial, event.payload)
      index = index + 1
    end if
  end for
  for each event in multicasts
    if ssgamemessages.reliableDestination(event.destination) == reliable then
      output[index] = ServerMessageFragment(event.serial, event.payload)
      index = index + 1
    end if
  end for
  for each event in sounds
    if (((event.channelFlags & ssgc.CHAN_RELIABLE) != 0) == reliable) then
      output[index] = ServerMessageFragment(event.serial,
        ssoundevents.encode(event))
      index = index + 1
    end if
  end for
  // Queues are individually ordered; a compact stable insertion merge keeps
  // the normal tiny per-frame batch allocation-free beyond the result itself.
  index = 1
  while index < len(output)
    selected = output[index]
    insertion = index
    while insertion > 0 and output[insertion - 1].serial > selected.serial
      output[insertion] = output[insertion - 1]
      insertion = insertion - 1
    end while
    output[insertion] = selected
    index = index + 1
  end while
  return output
end function

// Return only the encoded bytes from ordered frame fragments.
function frameFragmentPayloads(fragments)
  output = array(len(fragments), void)
  index = 0
  while index < len(fragments)
    output[index] = fragments[index].payload
    index = index + 1
  end while
  return output
end function

// Preflight every recipient before mutating any reliable Netchan queue. A
// blocked client retains the shared reliable source queues for a later frame.
function queueReliableFrameMessages(runtime, routedUnicasts,
    routedMulticasts, routedSounds)
  plans = array(runtime.server.maxClients, void)
  slot = 0
  ready = true
  while slot < runtime.server.maxClients
    fragments = frameMessageFragments(routedUnicasts[slot],
      routedMulticasts[slot], routedSounds[slot], true)
    payloads = frameFragmentPayloads(fragments)
    plans[slot] = payloads
    if len(payloads) > 0 then
      client = runtime.server.clients[slot]
      canQueue = ssnetchan.canQueueReliableFragments(client.channel, payloads)
      if canQueue == false then ready = false end if
    end if
    slot = slot + 1
  end while
  if not ready then return false end if
  slot = 0
  while slot < runtime.server.maxClients
    if len(plans[slot]) > 0 then
      queued = ssnetchan.queueReliableFragments(
        runtime.server.clients[slot].channel, plans[slot])
      if queued == false then return error(9988,
        "reliable frame-message preflight became stale") end if
    end if
    slot = slot + 1
  end while
  return true
end function

// Append the complete transient tail or drop the entire unreliable message.
// This mirrors SZ_AllowOverflow + SV_SendClientDatagram: an event is never sent
// without the snapshot entity state it references.
function composeClientDatagram(snapshotPayload, fragments, maximumPayload)
  total = len(snapshotPayload)
  for each fragment in fragments
    total = total + len(fragment.payload)
  end for
  if total > maximumPayload then return bytes() end if
  message = ssqsz.alloc(maximumPayload)
  ssqsz.writeBytes(message, snapshotPayload)
  for each fragment in fragments
    ssqsz.writeBytes(message, fragment.payload)
  end for
  return ssqsz.dataSlice(message)
end function

// Send one stock-shaped snapshot plus accumulated transient datagram per client.
function sendSnapshots(session, now, transientRoutes)
  runtime = session.networkRuntime
  slot = 0
  sent = 0
  while slot < runtime.server.maxClients
    client = runtime.server.clients[slot]
    if client.state == ssnc.CS_SPAWNED and client.channel is not void then
      // SV_RateDrop runs before SV_SendClientDatagram, so a skipped frame
      // neither mutates delta history nor resets the accumulated suppressCount.
      droppedForRate = ssserver.rateDrop(runtime.server, slot, session.frameNumber)
      if not droppedForRate then
        edict = session.gameExport.edicts[slot + 1]
        entities = packetEntitiesForClient(session, edict)
        maximumPayload = sspc.MAX_MSGLEN - sspc.PACKET_HEADER_SERVER
        candidate = ssqsz.alloc(maximumPayload)
        snapshotAreaBits = areaBits(session, edict)
        snapshotPlayer = protocolPlayer(edict)
        frame = sssnapshot.createFrame(session.frameNumber, snapshotAreaBits,
          snapshotPlayer, entities)
        encoded = try(ssserver.writeClientFrame(runtime.server, slot, frame,
          runtime.baselines, candidate))
        snapshotPayload = bytes()
        if encoded is not error then snapshotPayload = ssqsz.dataSlice(candidate) end if
        payload = composeClientDatagram(snapshotPayload, transientRoutes[slot],
          maximumPayload)
        // A snapshot encoding failure is an overflowing unreliable message in
        // stock SV_SendClientDatagram. Do not let a transient-only tail escape.
        if encoded is error then payload = bytes() end if
        stats = sspump.sendServerPayload(runtime, session.socket, slot, now, payload)
        ssserver.recordClientMessage(runtime.server, slot, session.frameNumber, len(payload))
        if typeof(stats) == "struct" then sent = sent + stats.sent end if
      end if
    end if
    slot = slot + 1
  end while
  return sent
end function

// Advance state.
function step(session)
  if session.closed then return error(9972, "server session is closed") end if
  now = ssqbyteio.truncInt(sssystem.milliseconds(session.clock))
  serverPaused = session.paused and session.networkRuntime.server.maxClients == 1
  stats = sspump.pumpServerPaused(session.networkRuntime, session.socket, now, 128,
    serverPaused)
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
  if not serverPaused then session.gameExport.runFrame() end if
  // Baselines describe the immutable level-start state used during signon.
  // Rebuilding them from live edicts every frame both destroys that contract
  // and allocates a complete duplicate entity set twice per server tick.
  // Runtime configstrings remain dynamic and are synchronized after gameplay.
  synchronizeConfigStrings(session)
  session.frameNumber = session.frameNumber + 1
  session.networkRuntime.server.realTime = now
  // Most 10 Hz gameplay ticks emit no GameImport messages. Route directly to
  // a retained empty shape in that common case; only an occupied fixed queue
  // materializes snapshots and per-recipient fragment arrays.
  bridge = session.bridgeRuntime
  noFrameMessages = bridge.pendingUnicastCount == 0 and
    bridge.pendingMulticastCount == 0 and bridge.pendingSoundCount == 0
  transientRoutes = void
  if noFrameMessages then
    transientRoutes = emptyServerMessageRoutes(
      session.networkRuntime.server.maxClients)
  else
    // Route all GameImport message classes before mutating Netchan. Reliable
    // fragments are queued atomically; transient fragments are consumed
    // exactly once and appended after svc_frame/entities by sendSnapshots.
    pendingUnicasts = ssgamemessages.pendingUnicastSnapshot(bridge)
    pendingMulticasts = ssgamemessages.pendingMulticastSnapshot(bridge)
    pendingSoundBatch = ssoundevents.pendingSnapshot(bridge)
    routedUnicasts = routeUnicasts(session, pendingUnicasts)
    routedMulticasts = routeMulticasts(session, pendingMulticasts)
    routedSounds = routeSounds(session, pendingSoundBatch)
    reliableQueued = queueReliableFrameMessages(session.networkRuntime,
      routedUnicasts, routedMulticasts, routedSounds)
    transientRoutes = array(session.networkRuntime.server.maxClients, void)
    transientSlot = 0
    while transientSlot < session.networkRuntime.server.maxClients
      transientRoutes[transientSlot] = frameMessageFragments(
        routedUnicasts[transientSlot], routedMulticasts[transientSlot],
        routedSounds[transientSlot], false)
      transientSlot = transientSlot + 1
    end while
    if reliableQueued then
      ssgamemessages.clearUnicasts(bridge)
      ssgamemessages.clearMulticasts(bridge)
      ssoundevents.clearPending(bridge)
    else
      ssgamemessages.restoreUnicasts(bridge,
        unicastReliabilitySubset(pendingUnicasts, true))
      ssgamemessages.restoreMulticasts(bridge,
        multicastReliabilitySubset(pendingMulticasts, true))
      ssoundevents.restorePending(bridge,
        soundReliabilitySubset(pendingSoundBatch, true))
    end if
  end if
  session.packetsSent = session.packetsSent + sendSnapshots(session, now,
    transientRoutes)
  if (session.frameNumber % 10) == 0 then sscommands.replenishCommandMsec(session.networkRuntime) end if
  return session.frameNumber
end function

// Listen-server pause is authoritative: client commands continue to be
// received and acknowledged, but neither ClientThink nor the Game API world
// frame advances. Multiplayer always remains live.
function setPaused(session, value)
  if typeof(value) != "bool" then return error(9986, "server pause state must be boolean") end if
  if session.networkRuntime.server.maxClients != 1 then
    session.paused = false
    return false
  end if
  session.paused = value
  return session.paused
end function

// Run state.
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

// Shut down state.
function shutdown(session)
  if session.closed then return false end if
  shutdownStats = sspump.shutdownServer(session.networkRuntime, session.socket)
  session.packetsSent = session.packetsSent + shutdownStats.sent
  ssudp.close(session.socket)
  session.gameExport.shutdown()
  session.closed = true
  return true
end function
