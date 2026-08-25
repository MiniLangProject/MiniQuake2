/* Per-client routing and failure-atomic reliable unicast backpressure. */
import miniquake2.qcommon.constants as nrur_qc
import miniquake2.protocol.constants as nrur_pc
import miniquake2.protocol.netchan as nrur_netchan
import miniquake2.network.constants as nrur_nc
import miniquake2.network.server as nrur_server
import miniquake2.network.runtime.types as nrur_nrtypes
import miniquake2.network.runtime.game_adapter as nrur_adapter
import miniquake2.network.runtime.unicast_dispatch as nrur_dispatch
import miniquake2.runtime.server_session as nrur_session
import miniquake2.server.types as nrur_stypes

function unicastRouteAssert(value, label)
  if value != true then return error(8469, label) end if
  return true
end function

server = nrur_server.create(2, "UnicastRoute", "unit",
  "\\hostname\\UnicastRoute", false, false)
slot = 0
while slot < 2
  server.clients[slot].state = nrur_nc.CS_SPAWNED
  server.clients[slot].channel = nrur_netchan.setup(nrur_pc.NS_SERVER, void, 0, 0)
  slot = slot + 1
end while
runtime = nrur_nrtypes.createServer(server, 1, "baseq2", "unit", nrur_adapter.permissive())
session = nrur_session.ServerSession(void, void, runtime, void, void, void,
  "unicast-routing", "", 0, 0, 0, 0, void, "", false, false)
first = nrur_stypes.PendingUnicastEvent(0, 1, false, bytes([nrur_qc.SVC_NOP]))
second = nrur_stypes.PendingUnicastEvent(1, 2, true, bytes([nrur_qc.SVC_NOP]))
routed = nrur_session.routeUnicasts(session, [first, second])
unicastRouteAssert(len(routed[0]) == 1 and routed[0][0].entity == 1 and
  len(routed[1]) == 1 and routed[1][0].entity == 2,
  "unicast events were not isolated by client slot")
server.clients[1].state = nrur_nc.CS_CONNECTED
routedConnected = nrur_session.routeUnicasts(session, [first, second])
unicastRouteAssert(len(routedConnected[0]) == 1 and len(routedConnected[1]) == 0,
  "unicast routing included a client which was not spawned")
server.clients[1].state = nrur_nc.CS_SPAWNED

channel = server.clients[1].channel
fullQueue = array(nrur_pc.MAX_RELIABLE_QUEUE_FRAGMENTS,
  bytes(nrur_pc.RELIABLE_BUFFER_SIZE))
nrur_netchan.queueReliableFragments(channel, fullQueue)
queuedBefore = channel.reliableQueuedBytes
outgoingBefore = channel.outgoingSequence
deferred = nrur_dispatch.dispatchRouted(runtime, void, [second], [[], [second]], 1)
unicastRouteAssert(not deferred.delivered and deferred.sent == 0 and
  channel.reliableQueuedBytes == queuedBefore and channel.outgoingSequence == outgoingBefore,
  "unicast reliable backpressure was not failure-atomic")
unicastRouteAssert(try(nrur_dispatch.dispatchRouted(runtime, void, [second], [], 2)) is error,
  "malformed routed unicast shape was accepted")

print("network_runtime_unicast_routing_tests: PASS")
