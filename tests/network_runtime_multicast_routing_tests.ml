/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Synthetic PVS/PHS routing and failure-atomic multicast backpressure tests. */
import miniquake2.qcommon.constants as nrmr_qc
import miniquake2.qcommon.types as nrmr_qtypes
import miniquake2.format.types as nrmr_ftypes
import miniquake2.collision.model as nrmr_collision
import miniquake2.game.constants as nrmr_gc
import miniquake2.game.types as nrmr_gtypes
import miniquake2.protocol.constants as nrmr_pc
import miniquake2.protocol.netchan as nrmr_netchan
import miniquake2.network.constants as nrmr_nc
import miniquake2.network.server as nrmr_server
import miniquake2.network.runtime.types as nrmr_nrtypes
import miniquake2.network.runtime.game_adapter as nrmr_adapter
import miniquake2.network.runtime.multicast_dispatch as nrmr_dispatch
import miniquake2.runtime.server_session as nrmr_session
import miniquake2.server.types as nrmr_stypes
import miniquake2.server.game_bridge as nrmr_bridge
import miniquake2.server.game_messages as nrmr_messages
import miniquake2.server.sound_events as nrmr_sounds

// Assert the multicast route test condition.
function multicastRouteAssert(value, label)
  if value != true then return error(8467, label) end if
  return true
end function

// Return the multicast route collision value.
function multicastRouteCollision()
  plane = nrmr_ftypes.BspPlane(nrmr_qtypes.Vec3(1.0, 0.0, 0.0), 0.0, 0)
  node = nrmr_ftypes.BspNode(0, -1, -2,
    nrmr_qtypes.Vec3(-32.0, -32.0, -32.0), nrmr_qtypes.Vec3(32.0, 32.0, 32.0), 0, 0)
  front = nrmr_ftypes.BspLeaf(0, 0, 1,
    nrmr_qtypes.Vec3(0.0, -32.0, -32.0), nrmr_qtypes.Vec3(32.0, 32.0, 32.0), 0, 0, 0, 0)
  back = nrmr_ftypes.BspLeaf(0, 1, 2,
    nrmr_qtypes.Vec3(-32.0, -32.0, -32.0), nrmr_qtypes.Vec3(0.0, 32.0, 32.0), 0, 0, 0, 0)
  areas = [nrmr_ftypes.BspArea(0, 0), nrmr_ftypes.BspArea(1, 0), nrmr_ftypes.BspArea(1, 1)]
  portals = [nrmr_ftypes.BspAreaPortal(0, 2), nrmr_ftypes.BspAreaPortal(0, 1)]
  // Cluster 0 PVS sees only itself; its PHS sees both clusters.
  visibility = nrmr_ftypes.BspVisibility(2, [0, 1], [2, 3], bytes([1, 3, 3, 3]))
  map = nrmr_ftypes.BspMap("multicast-routing", bytes(), [], "", [plane], [], visibility,
    [node], [], [], bytes(), [front, back], [], [], [], [], [], [], [], areas, portals)
  return nrmr_collision.create(map)
end function

// Every typed GameImport queue claims from one shared emission clock.
orderingBridge = nrmr_bridge.createRuntime(1)
orderingClient = nrmr_gtypes.zeroEdict(1)
orderingMulticast = nrmr_messages.enqueue(orderingBridge,
  nrmr_qtypes.zeroVec3(), nrmr_gc.MULTICAST_ALL,
  bytes([nrmr_qc.SVC_NOP]))
orderingSound = nrmr_sounds.enqueue(orderingBridge, void,
  nrmr_qtypes.zeroVec3(), orderingClient, nrmr_gc.CHAN_AUTO, 1, 1.0,
  nrmr_gc.ATTN_NORM, 0.0)
orderingUnicast = nrmr_messages.enqueueUnicast(orderingBridge,
  orderingClient, false, bytes([nrmr_qc.SVC_NOP]))
multicastRouteAssert(orderingMulticast.serial == 0 and
  orderingSound.serial == 1 and orderingUnicast.serial == 2,
  "typed GameImport queues did not share an emission serial")

// Export multicast route game.
function multicastRouteGameExport(edicts)
  return nrmr_gtypes.GameExport(3,
    void, void, void, void, void, void, void, void,
    void, void, void, void, void, void, void,
    edicts, 0, len(edicts), len(edicts))
end function

collision = multicastRouteCollision()
listener = nrmr_gtypes.zeroEdict(1)
listener.state.origin = nrmr_qtypes.Vec3(-8.0, 0.0, 0.0)
source = nrmr_qtypes.Vec3(8.0, 0.0, 0.0)
pvsEvent = nrmr_stypes.PendingMulticastEvent(0, nrmr_gc.MULTICAST_PVS,
  source, bytes([nrmr_qc.SVC_NOP]))
phsEvent = nrmr_stypes.PendingMulticastEvent(1, nrmr_gc.MULTICAST_PHS,
  source, bytes([nrmr_qc.SVC_NOP]))
allEvent = nrmr_stypes.PendingMulticastEvent(2, nrmr_gc.MULTICAST_ALL,
  source, bytes([nrmr_qc.SVC_NOP]))
session = nrmr_session.ServerSession(void, multicastRouteGameExport([
  nrmr_gtypes.zeroEdict(0), listener]), void, void, void, collision,
  "multicast-routing", "", 0, 0, 0, 0, void, "", false, false)

multicastRouteAssert(not nrmr_session.multicastVisibleToClient(session, pvsEvent, listener) and
  not nrmr_session.multicastVisibleToClient(session, phsEvent, listener),
  "closed area leaked PVS/PHS multicast")
nrmr_collision.setAreaPortalState(collision, 0, true)
multicastRouteAssert(not nrmr_session.multicastVisibleToClient(session, pvsEvent, listener),
  "PVS-excluded listener received multicast")
multicastRouteAssert(nrmr_session.multicastVisibleToClient(session, phsEvent, listener),
  "PHS-visible listener missed multicast")
multicastRouteAssert(nrmr_session.multicastVisibleToClient(session, allEvent, listener),
  "MULTICAST_ALL was visibility filtered")

server = nrmr_server.create(1, "MulticastRoute", "unit",
  "\\hostname\\MulticastRoute", false, false)
server.clients[0].state = nrmr_nc.CS_SPAWNED
server.clients[0].channel = nrmr_netchan.setup(nrmr_pc.NS_SERVER, void, 0, 0)
runtime = nrmr_nrtypes.createServer(server, 1, "baseq2", "unit", nrmr_adapter.permissive())
session.networkRuntime = runtime
routed = nrmr_session.routeMulticasts(session, [pvsEvent, phsEvent, allEvent])
multicastRouteAssert(len(routed[0]) == 2 and routed[0][0].serial == 1 and routed[0][1].serial == 2,
  "multicast route did not preserve visible event order")

reliable = nrmr_stypes.PendingMulticastEvent(3, nrmr_gc.MULTICAST_ALL_R,
  source, bytes([nrmr_qc.SVC_NOP]))
channel = server.clients[0].channel
laterTransient = nrmr_stypes.PendingMulticastEvent(4,
  nrmr_gc.MULTICAST_ALL, source, bytes([nrmr_qc.SVC_NOP]))
mixedPlan = nrmr_dispatch.buildPlan(runtime, 0,
  [phsEvent, reliable, laterTransient])
multicastRouteAssert(mixedPlan != false and mixedPlan is not void and
  len(mixedPlan.unreliablePackets) == 1 and
  len(mixedPlan.unreliablePackets[0]) == 2 and
  len(mixedPlan.reliableFragments) == 1,
  "transient multicast after reliable event was upgraded into ACK backlog")
mixedTransient = nrmr_session.multicastReliabilitySubset(
  [phsEvent, reliable, laterTransient], false)
mixedReliable = nrmr_session.multicastReliabilitySubset(
  [phsEvent, reliable, laterTransient], true)
multicastRouteAssert(len(mixedTransient) == 2 and
  mixedTransient[0].serial == 1 and mixedTransient[1].serial == 4 and
  len(mixedReliable) == 1 and mixedReliable[0].serial == 3,
  "server frame did not split multicast reliability in original order")
fullQueue = array(nrmr_pc.MAX_RELIABLE_QUEUE_FRAGMENTS,
  bytes(nrmr_pc.RELIABLE_BUFFER_SIZE))
nrmr_netchan.queueReliableFragments(channel, fullQueue)
queuedBefore = channel.reliableQueuedBytes
outgoingBefore = channel.outgoingSequence
deferred = nrmr_dispatch.dispatchRouted(runtime, void, [reliable], [[reliable]], 1)
multicastRouteAssert(not deferred.delivered and deferred.sent == 0 and
  channel.reliableQueuedBytes == queuedBefore and channel.outgoingSequence == outgoingBefore,
  "multicast reliable backpressure was not failure-atomic")
multicastRouteAssert(try(nrmr_dispatch.dispatchRouted(runtime, void, [reliable], [], 2)) is error,
  "malformed routed multicast shape was accepted")

// Snapshot and typed GameImport queues share one unreliable datagram. The
// merged tail follows svc_frame and preserves the original cross-type serial.
orderedUnicast = nrmr_stypes.PendingUnicastEvent(12, 1, false,
  bytes([nrmr_qc.SVC_CENTERPRINT, 0]))
orderedSound = nrmr_stypes.PendingSoundEvent(11, true, 1,
  nrmr_gc.CHAN_WEAPON, nrmr_gc.CHAN_WEAPON, 1, 1.0,
  nrmr_gc.ATTN_NORM, 0.0, void, nrmr_qtypes.Vec3(8.0, 0.0, 0.0))
orderedMulticast = nrmr_stypes.PendingMulticastEvent(10,
  nrmr_gc.MULTICAST_ALL, source, bytes([nrmr_qc.SVC_NOP]))
ordered = nrmr_session.frameMessageFragments([orderedUnicast],
  [orderedMulticast], [orderedSound], false)
multicastRouteAssert(len(ordered) == 3 and ordered[0].serial == 10 and
  ordered[1].serial == 11 and ordered[2].serial == 12,
  "cross-type transient emission order was not preserved")
composed = nrmr_session.composeClientDatagram(
  bytes([nrmr_qc.SVC_FRAME, 77]), ordered, 64)
multicastRouteAssert(len(composed) > 4 and composed[0] == nrmr_qc.SVC_FRAME and
  composed[2] == nrmr_qc.SVC_NOP and composed[3] == nrmr_qc.SVC_SOUND,
  "transient commands were not appended after the snapshot")
overflowed = nrmr_session.composeClientDatagram(bytes(62),
  [nrmr_session.ServerMessageFragment(0, bytes([1, 2, 3]))], 64)
multicastRouteAssert(len(overflowed) == 0,
  "overflow retained an orphan transient tail")

print("network_runtime_multicast_routing_tests: PASS")
