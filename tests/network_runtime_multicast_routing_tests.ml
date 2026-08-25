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

function multicastRouteAssert(value, label)
  if value != true then return error(8467, label) end if
  return true
end function

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

print("network_runtime_multicast_routing_tests: PASS")
