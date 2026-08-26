/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Synthetic PHS/area routing and atomic reliable-backpressure tests. */
import miniquake2.qcommon.types as nrroute_qt
import miniquake2.format.types as nrroute_ft
import miniquake2.collision.model as nrroute_collision
import miniquake2.game.constants as nrroute_gc
import miniquake2.game.types as nrroute_gt
import miniquake2.protocol.constants as nrroute_pc
import miniquake2.protocol.netchan as nrroute_netchan
import miniquake2.network.constants as nrroute_nc
import miniquake2.network.server as nrroute_server
import miniquake2.network.runtime.types as nrroute_nrtypes
import miniquake2.network.runtime.game_adapter as nrroute_adapter
import miniquake2.network.runtime.sound_dispatch as nrroute_dispatch
import miniquake2.runtime.server_session as nrroute_session
import miniquake2.server.types as nrroute_st

function routingAssert(value, name)
  if not value then return error(8470, name) end if
  return true
end function

function routingCollision(phsFromFirst)
  plane = nrroute_ft.BspPlane(nrroute_qt.Vec3(1.0, 0.0, 0.0), 0.0, 0)
  node = nrroute_ft.BspNode(0, -1, -2,
    nrroute_qt.Vec3(-32.0, -32.0, -32.0), nrroute_qt.Vec3(32.0, 32.0, 32.0), 0, 0)
  front = nrroute_ft.BspLeaf(0, 0, 1,
    nrroute_qt.Vec3(0.0, -32.0, -32.0), nrroute_qt.Vec3(32.0, 32.0, 32.0), 0, 0, 0, 0)
  back = nrroute_ft.BspLeaf(0, 1, 2,
    nrroute_qt.Vec3(-32.0, -32.0, -32.0), nrroute_qt.Vec3(0.0, 32.0, 32.0), 0, 0, 0, 0)
  // Both area records reference portal zero.  It starts closed.
  areas = [nrroute_ft.BspArea(0, 0), nrroute_ft.BspArea(1, 0), nrroute_ft.BspArea(1, 1)]
  portals = [nrroute_ft.BspAreaPortal(0, 2), nrroute_ft.BspAreaPortal(0, 1)]
  visibility = nrroute_ft.BspVisibility(2, [0, 1], [0, 1], bytes([phsFromFirst, 3]))
  map = nrroute_ft.BspMap("sound-routing", bytes(), [], "", [plane], [], visibility,
    [node], [], [], bytes(), [front, back], [], [], [], [], [], [], [], areas, portals)
  return nrroute_collision.create(map)
end function

function positionedEvent(serial, flags, attenuation)
  return nrroute_st.PendingSoundEvent(serial, false, 0, flags & 7, flags,
    1, 1.0, attenuation, 0.0, nrroute_qt.Vec3(8.0, 0.0, 0.0))
end function

function routingSession(collision)
  return nrroute_session.ServerSession(void, void, void, void, void, collision,
    "sound-routing", "", 0, 0, 0, 0, void, "", false, false)
end function

function routingGameExport(edicts)
  return nrroute_gt.GameExport(3,
    void, void, void, void, void, void, void, void,
    void, void, void, void, void, void, void,
    edicts, 0, len(edicts), len(edicts))
end function

listener = nrroute_gt.zeroEdict(1)
listener.state.origin = nrroute_qt.Vec3(-8.0, 0.0, 0.0)
collision = routingCollision(1)
session = routingSession(collision)
ordinary = positionedEvent(0, nrroute_gc.CHAN_VOICE, nrroute_gc.ATTN_NORM)

// Closed areas reject even a positive PHS bit.  Opening the portal exposes
// the actual cluster mask, whose first row deliberately excludes cluster 1.
routingAssert(not nrroute_session.soundAudibleToClient(session, ordinary, listener),
  "closed area leaked a positioned sound")
nrroute_collision.setAreaPortalState(collision, 0, true)
routingAssert(not nrroute_session.soundAudibleToClient(session, ordinary, listener),
  "PHS-excluded listener received a positioned sound")
collision.map.visibility.data[0] = 3
nrroute_collision.clearVisibilityRows(collision)
routingAssert(nrroute_session.soundAudibleToClient(session, ordinary, listener),
  "PHS-visible listener missed a positioned sound")

frontListener = nrroute_gt.zeroEdict(2)
frontListener.state.origin = nrroute_qt.Vec3(4.0, 0.0, 0.0)
sourceEntity = nrroute_gt.zeroEdict(3)
sourceEntity.state.origin = nrroute_qt.Vec3(6.0, 0.0, 0.0)
sourceEntity.solid = nrroute_gc.SOLID_BSP
sourceEntity.mins = nrroute_qt.Vec3(-4.0, -2.0, -2.0)
sourceEntity.maxs = nrroute_qt.Vec3(8.0, 2.0, 6.0)
session.gameExport = routingGameExport([nrroute_gt.zeroEdict(0), listener, frontListener, sourceEntity])

routingServer = nrroute_server.create(2, "SoundRoute", "unit",
  "\\hostname\\SoundRoute", false, false)
routingServer.clients[0].state = nrroute_nc.CS_SPAWNED
routingServer.clients[0].channel = nrroute_netchan.setup(nrroute_pc.NS_SERVER, void, 0, 0)
routingServer.clients[1].state = nrroute_nc.CS_SPAWNED
routingServer.clients[1].channel = nrroute_netchan.setup(nrroute_pc.NS_SERVER, void, 0, 0)
routingRuntime = nrroute_nrtypes.createServer(routingServer, 1, "baseq2", "unit",
  nrroute_adapter.permissive())
session.networkRuntime = routingRuntime
routed = nrroute_session.routeSounds(session, [ordinary])
routingAssert(len(routed[0]) == 1 and len(routed[1]) == 1,
  "PHS routing did not build per-spawned-client target lists")
routingServer.clients[1].state = nrroute_nc.CS_CONNECTED
routedSpawnedOnly = nrroute_session.routeSounds(session, [ordinary])
routingAssert(len(routedSpawnedOnly[0]) == 1 and len(routedSpawnedOnly[1]) == 0,
  "sound routing included a client which was not spawned")

entityBound = nrroute_st.PendingSoundEvent(3, true, 3, nrroute_gc.CHAN_VOICE,
  nrroute_gc.CHAN_VOICE, 1, 1.0, nrroute_gc.ATTN_NORM, 0.0, void)
derived = nrroute_session.soundEventOrigin(session, entityBound)
routingAssert(derived.x == 8.0 and derived.y == 0.0 and derived.z == 2.0,
  "SOLID_BSP entity sound did not use the bounds-centered origin")
nrroute_collision.setAreaPortalState(collision, 0, false)

noPhs = positionedEvent(1, nrroute_gc.CHAN_VOICE | nrroute_gc.CHAN_NO_PHS_ADD,
  nrroute_gc.ATTN_NORM)
routingAssert(nrroute_session.soundAudibleToClient(session, noPhs, listener),
  "CHAN_NO_PHS_ADD did not override PHS and area filtering")
globalSound = positionedEvent(2, nrroute_gc.CHAN_VOICE, nrroute_gc.ATTN_NONE)
routingAssert(nrroute_session.soundAudibleToClient(session, globalSound, listener),
  "ATTN_NONE sound was incorrectly PHS-filtered")

// A busy reliable holding buffer now retains the next sound tail behind it;
// ACK promotion, rather than a one-packet staging limit, owns the ordering.
server = nrroute_server.create(1, "SoundRoute", "unit",
  "\\hostname\\SoundRoute", false, false)
server.clients[0].state = nrroute_nc.CS_SPAWNED
server.clients[0].channel = nrroute_netchan.setup(nrroute_pc.NS_SERVER, void, 0, 0)
runtime = nrroute_nrtypes.createServer(server, 1, "baseq2", "unit", nrroute_adapter.permissive())
channel = server.clients[0].channel

// Ordinary svc_sound records belong only to the current unreliable datagram.
// A signon/reliable payload which leaves no packet room drops them instead of
// retaining idle sounds across frames until the bridge queue overflows.
channel.reliableLength = nrroute_pc.MAX_MSGLEN - nrroute_pc.PACKET_HEADER_SERVER
ordinaryDropped = nrroute_dispatch.dispatchRouted(runtime, void,
  [ordinary], [[ordinary]], 1)
routingAssert(ordinaryDropped.delivered and ordinaryDropped.sent == 0 and
  ordinaryDropped.deferred == 0,
  "ordinary sound was retained behind a full reliable payload")

// A routed empty list means that PHS/area filtering excluded this client.
// MiniLang's void/false comparison must not turn that intentional no-plan
// result into reliable backpressure for the global bridge queue.
inaudibleConsumed = nrroute_dispatch.dispatchRouted(runtime, void,
  [ordinary], [[]], 1)
routingAssert(inaudibleConsumed.delivered and inaudibleConsumed.sent == 0 and
  inaudibleConsumed.deferred == 0,
  "PHS-filtered no-plan sound was mistaken for backpressure")

channel.reliableLength = 1
channel.reliableBuffer = bytes([77])
reliable = positionedEvent(4, nrroute_gc.CHAN_WEAPON | nrroute_gc.CHAN_RELIABLE,
  nrroute_gc.ATTN_NORM)
outgoingBefore = channel.outgoingSequence
busyPlan = nrroute_dispatch.buildPlan(runtime, 0, [reliable])
routingAssert(busyPlan != false and busyPlan is not void and
  len(busyPlan.reliableFragments) == 1,
  "busy reliable channel rejected an appendable sound tail")
nrroute_netchan.queueReliableFragments(channel, busyPlan.reliableFragments)
routingAssert(channel.outgoingSequence == outgoingBefore and channel.reliableLength == 1 and
  channel.reliableBuffer == bytes([77]) and len(channel.reliableQueue) == 1,
  "queued sound displaced the unacknowledged holding payload")

// Only the bounded retained-fragment limit reports backpressure.  Rejection
// is atomic even with a completely full pending queue.
channel.reliableLength = 0
channel.reliableBuffer = bytes()
channel.reliableQueue = []
channel.reliableQueuedBytes = 0
fullQueue = array(nrroute_pc.MAX_RELIABLE_QUEUE_FRAGMENTS,
  bytes(nrroute_pc.RELIABLE_BUFFER_SIZE))
nrroute_netchan.queueReliableFragments(channel, fullQueue)
queuedBefore = channel.reliableQueuedBytes
capacityDeferred = nrroute_dispatch.dispatchRouted(runtime, void, [reliable], [[reliable]], 2)
routingAssert(not capacityDeferred.delivered and capacityDeferred.sent == 0 and
  channel.reliableQueuedBytes == queuedBefore and
  len(channel.reliableQueue) == nrroute_pc.MAX_RELIABLE_QUEUE_FRAGMENTS and
  channel.outgoingSequence == outgoingBefore,
  "reliable capacity rejection was not atomic")
routingAssert(try(nrroute_dispatch.dispatchRouted(runtime, void, [reliable], [], 3)) is error,
  "malformed routed batch shape was accepted")

print("network_runtime_sound_routing_tests: PASS")
