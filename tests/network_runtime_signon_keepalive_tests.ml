/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Bidirectional signon reliable liveness after dropped payloads and ACKs. */
import miniquake2.platform.system as nrkeep_system
import miniquake2.platform.udp as nrkeep_udp
import miniquake2.qcommon.constants as nrkeep_qconstants
import miniquake2.qcommon.types as nrkeep_qtypes
import miniquake2.protocol.constants as nrkeep_pconstants
import miniquake2.protocol.packet as nrkeep_packet
import miniquake2.protocol.netchan as nrkeep_netchan
import miniquake2.protocol.types as nrkeep_ptypes
import miniquake2.network.constants as nrkeep_nconstants
import miniquake2.network.client as nrkeep_client
import miniquake2.network.server as nrkeep_server
import miniquake2.network.runtime.types as nrkeep_rtypes
import miniquake2.network.runtime.game_adapter as nrkeep_adapter
import miniquake2.network.runtime.pump as nrkeep_pump

function keepaliveAssert(value, name)
  if not value then return error(8500, name) end if
  return true
end function

function receiveOne(socket)
  attempt = 0
  while not nrkeep_udp.pending(socket) and attempt < 100
    nrkeep_system.sleep(1)
    attempt = attempt + 1
  end while
  if not nrkeep_udp.pending(socket) then return error(8501, "keepalive UDP receive timed out") end if
  return nrkeep_udp.receive(socket, nrkeep_pconstants.MAX_MSGLEN)
end function

function waitPending(socket)
  attempt = 0
  while not nrkeep_udp.pending(socket) and attempt < 100
    nrkeep_system.sleep(1)
    attempt = attempt + 1
  end while
  if not nrkeep_udp.pending(socket) then return error(8501, "keepalive UDP receive timed out") end if
  return true
end function

function makePair(clientSocket, serverSocket)
  clientAddress = nrkeep_qtypes.NetAddress(nrkeep_nconstants.NA_IP,
    [127, 0, 0, 1], array(10, 0), clientSocket.port)
  serverAddress = nrkeep_qtypes.NetAddress(nrkeep_nconstants.NA_IP,
    [127, 0, 0, 1], array(10, 0), serverSocket.port)
  client = nrkeep_client.create(0x7799, 5000)
  client.state = nrkeep_nconstants.CA_CONNECTED
  client.serverAddress = serverAddress
  client.channel = nrkeep_netchan.setup(nrkeep_pconstants.NS_CLIENT,
    serverAddress, client.qport, 0)
  clientRuntime = nrkeep_rtypes.createClient(client)
  server = nrkeep_server.create(1, "Keepalive", "unit",
    "\\hostname\\Keepalive", false, false)
  server.clients[0].state = nrkeep_nconstants.CS_CONNECTED
  server.clients[0].channel = nrkeep_netchan.setup(nrkeep_pconstants.NS_SERVER,
    clientAddress, 0, 0)
  serverRuntime = nrkeep_rtypes.createServer(server, 1, "baseq2", "unit",
    nrkeep_adapter.permissive())
  return [clientRuntime, serverRuntime]
end function

function sendClient(runtime, socket, now)
  stats = nrkeep_rtypes.stats()
  keepaliveAssert(nrkeep_pump.flushClient(runtime, socket, now, bytes(), stats),
    "CA_CONNECTED did not emit idle sequenced packet")
  return stats
end function

function sendServer(runtime, socket, now)
  stats = nrkeep_rtypes.stats()
  keepaliveAssert(nrkeep_pump.flushServerClient(runtime, socket, 0, now, stats),
    "CS_CONNECTED did not emit idle sequenced packet")
  return stats
end function

clientSocket = nrkeep_udp.open("127.0.0.1", 0)
serverSocket = nrkeep_udp.open("127.0.0.1", 0)

// Drop the server's first reliable payload while delivering the client's
// crossed reliable command.  Empty connected-state packets advance the ACK
// sequence until classic Netchan parity requests an exact retransmission.
pair = makePair(clientSocket, serverSocket)
clientRuntime = pair[0]
serverRuntime = pair[1]
clientChannel = clientRuntime.client.channel
serverChannel = serverRuntime.server.clients[0].channel
nrkeep_netchan.queueReliable(clientChannel, bytes("CLIENT"))
nrkeep_netchan.queueReliable(serverChannel, bytes("SERVER"))
sendClient(clientRuntime, clientSocket, 1)
sendServer(serverRuntime, serverSocket, 1)
clientWire = receiveOne(serverSocket).data
droppedServerWire = receiveOne(clientSocket).data
receivedClient = nrkeep_netchan.process(serverChannel, clientWire, 2)
keepaliveAssert(receivedClient.accepted and receivedClient.payload == bytes("CLIENT") and
  nrkeep_packet.decodeHeader(droppedServerWire, false).reliable == 1,
  "initial crossed reliable precondition failed")
serverRuntime.ackPending[0] = true

receivedServerPayloads = 0
round = 0
while round < 3
  sendServer(serverRuntime, serverSocket, 10 + round * 4)
  serverWire = receiveOne(clientSocket).data
  serverHeader = nrkeep_packet.decodeHeader(serverWire, false)
  receivedServer = nrkeep_netchan.process(clientChannel, serverWire, 11 + round * 4)
  if receivedServer.accepted and len(receivedServer.payload) > 0 then
    keepaliveAssert(receivedServer.payload == bytes("SERVER"),
      "retransmitted server reliable payload changed")
    receivedServerPayloads = receivedServerPayloads + 1
  end if
  if serverHeader.reliable == 1 then clientRuntime.ackPending = true end if
  sendClient(clientRuntime, clientSocket, 12 + round * 4)
  clientWire = receiveOne(serverSocket).data
  clientHeader = nrkeep_packet.decodeHeader(clientWire, true)
  nrkeep_netchan.process(serverChannel, clientWire, 13 + round * 4)
  if clientHeader.reliable == 1 then serverRuntime.ackPending[0] = true end if
  round = round + 1
end while
keepaliveAssert(receivedServerPayloads == 1 and clientChannel.reliableLength == 0 and
  serverChannel.reliableLength == 0,
  "connected keepalive did not recover dropped bidirectional reliable traffic")

// When both original reliables arrive but their first pure ACK datagrams are
// dropped, the following idle pair must clear both holdings without replaying
// either application payload.
pair = makePair(clientSocket, serverSocket)
clientRuntime = pair[0]
serverRuntime = pair[1]
clientChannel = clientRuntime.client.channel
serverChannel = serverRuntime.server.clients[0].channel
nrkeep_netchan.queueReliable(clientChannel, bytes("C-ACK"))
nrkeep_netchan.queueReliable(serverChannel, bytes("S-ACK"))
sendClient(clientRuntime, clientSocket, 100)
sendServer(serverRuntime, serverSocket, 100)
clientWire = receiveOne(serverSocket).data
serverWire = receiveOne(clientSocket).data
nrkeep_netchan.process(serverChannel, clientWire, 101)
nrkeep_netchan.process(clientChannel, serverWire, 101)
clientRuntime.ackPending = true
serverRuntime.ackPending[0] = true
sendClient(clientRuntime, clientSocket, 102)
sendServer(serverRuntime, serverSocket, 102)
// Deliberately discard the first two ACK datagrams.
receiveOne(serverSocket)
receiveOne(clientSocket)
sendClient(clientRuntime, clientSocket, 103)
sendServer(serverRuntime, serverSocket, 103)
clientAckRetry = receiveOne(serverSocket).data
serverAckRetry = receiveOne(clientSocket).data
keepaliveAssert(len(nrkeep_netchan.process(serverChannel, clientAckRetry, 104).payload) == 0 and
  len(nrkeep_netchan.process(clientChannel, serverAckRetry, 104).payload) == 0 and
  clientChannel.reliableLength == 0 and serverChannel.reliableLength == 0,
  "dropped ACK recovery replayed or retained reliable payload")

// Matching ACK parity from an older epoch must not consume a newly promoted
// holding buffer unless its numeric acknowledgement covers the wire packet.
pair = makePair(clientSocket, serverSocket)
clientChannel = pair[0].client.channel
nrkeep_netchan.queueReliable(clientChannel, bytes("EPOCH"))
nrkeep_netchan.transmit(clientChannel, bytes(), 200)
staleAck = nrkeep_packet.join(nrkeep_packet.encodeHeader(
  nrkeep_ptypes.PacketHeader(1, 0, 0, 1, 0, 0), false), bytes(), bytes())
nrkeep_netchan.process(clientChannel, staleAck, 201)
keepaliveAssert(clientChannel.reliableLength == 5,
  "stale matching reliable parity consumed a newer epoch")
coveringAck = nrkeep_packet.join(nrkeep_packet.encodeHeader(
  nrkeep_ptypes.PacketHeader(2, 0, 1, 1, 0, 0), false), bytes(), bytes())
nrkeep_netchan.process(clientChannel, coveringAck, 202)
keepaliveAssert(clientChannel.reliableLength == 0,
  "covering reliable acknowledgement did not release epoch")

// The current epoch owns a stable first-wire marker.  A retransmission moves
// lastReliableSequence, but a delayed ACK covering the original datagram is
// still authoritative and must leave the following epoch correctly toggled.
pair = makePair(clientSocket, serverSocket)
clientChannel = pair[0].client.channel
nrkeep_netchan.queueReliable(clientChannel, bytes("DELAYED"))
original = nrkeep_netchan.transmit(clientChannel, bytes(), 300)
keepaliveAssert(nrkeep_packet.decodeHeader(original, true).sequence == 1 and
  clientChannel.firstReliableSequence == 1 and
  clientChannel.lastReliableSequence == 2,
  "original reliable epoch markers are incorrect")
clientChannel.incomingAcknowledged = 2
clientChannel.incomingReliableAcknowledged = 0
retransmit = nrkeep_netchan.transmit(clientChannel, bytes(), 301)
keepaliveAssert(nrkeep_packet.decodeHeader(retransmit, true).reliable == 1 and
  clientChannel.firstReliableSequence == 1 and
  clientChannel.lastReliableSequence == 3,
  "retransmit replaced the first-wire reliable marker")
delayedOriginalAck = nrkeep_packet.join(nrkeep_packet.encodeHeader(
  nrkeep_ptypes.PacketHeader(1, 0, 1, 1, 0, 0), false), bytes(), bytes())
nrkeep_netchan.process(clientChannel, delayedOriginalAck, 302)
keepaliveAssert(clientChannel.reliableLength == 0 and
  clientChannel.firstReliableSequence == -1 and
  clientChannel.reliableSequence == 1,
  "delayed original ACK did not release its retransmitted epoch")
nrkeep_netchan.queueReliable(clientChannel, bytes("NEXT"))
nextEpoch = nrkeep_netchan.transmit(clientChannel, bytes(), 303)
keepaliveAssert(nrkeep_packet.decodeHeader(nextEpoch, true).reliable == 1 and
  clientChannel.reliableSequence == 0 and clientChannel.firstReliableSequence == 3,
  "delayed original ACK corrupted the following reliable epoch")

// Product map-transition shape: the client is still active on its previous
// frame and sends moves while the server has returned to CS_CONNECTED.  Drop
// the first server reliable.  pumpServer must emit an otherwise empty
// sequenced packet in this exact mixed state so ACK progress requests a retry.
pair = makePair(clientSocket, serverSocket)
clientRuntime = pair[0]
serverRuntime = pair[1]
clientRuntime.client.state = nrkeep_nconstants.CA_ACTIVE
clientChannel = clientRuntime.client.channel
serverChannel = serverRuntime.server.clients[0].channel
nrkeep_netchan.queueReliable(serverChannel, bytes([nrkeep_qconstants.SVC_NOP]))
sendServer(serverRuntime, serverSocket, 400)
droppedTransition = receiveOne(clientSocket).data
keepaliveAssert(nrkeep_packet.decodeHeader(droppedTransition, false).reliable == 1 and
  serverChannel.outgoingSequence == 2,
  "transition reliable drop precondition failed")

// Lose three consecutive connected-state idle datagrams after the original
// reliable.  Every active client move must still make pumpServer advance the
// server sequence instead of leaving the transition channel parked.
lostIdle = 0
while lostIdle < 3
  activeStats = nrkeep_rtypes.stats()
  nrkeep_pump.flushClient(clientRuntime, clientSocket, 401 + lostIdle * 3,
    bytes([nrkeep_qconstants.CLC_NOP]), activeStats)
  waitPending(serverSocket)
  serverStats = nrkeep_pump.pumpServer(serverRuntime, serverSocket,
    402 + lostIdle * 3, 16)
  keepaliveAssert(serverStats.received == 1 and serverStats.sent == 1 and
    serverChannel.outgoingSequence == 3 + lostIdle,
    "CS_CONNECTED server stopped across repeated lost idle datagrams")
  receiveOne(clientSocket)
  lostIdle = lostIdle + 1
end while

// Deliver the fourth idle packet.  Its numeric sequence lets the following
// active-client packet prove that the original reliable was lost.
activeStats = nrkeep_rtypes.stats()
nrkeep_pump.flushClient(clientRuntime, clientSocket, 411,
  bytes([nrkeep_qconstants.CLC_NOP]), activeStats)
waitPending(serverSocket)
serverStats = nrkeep_pump.pumpServer(serverRuntime, serverSocket, 412, 16)
recoveryIdle = receiveOne(clientSocket).data
keepaliveAssert(len(nrkeep_netchan.process(clientChannel, recoveryIdle, 413).payload) == 0 and
  serverChannel.outgoingSequence == 6,
  "transition recovery idle packet was not delivered")

// Lose the first actual retransmission as well.  A further idle/ACK round must
// request the same payload again without changing its first-wire epoch marker.
activeStats = nrkeep_rtypes.stats()
nrkeep_pump.flushClient(clientRuntime, clientSocket, 414,
  bytes([nrkeep_qconstants.CLC_NOP]), activeStats)
activeAckWire = receiveOne(serverSocket).data
nrkeep_netchan.process(serverChannel, activeAckWire, 415)
serverStats = nrkeep_rtypes.stats()
nrkeep_pump.flushServerClient(serverRuntime, serverSocket, 0, 415, serverStats)
firstTransitionRetry = receiveOne(clientSocket).data
keepaliveAssert(nrkeep_packet.decodeHeader(firstTransitionRetry, false).reliable == 1 and
  serverChannel.firstReliableSequence == 1 and serverChannel.lastReliableSequence == 7,
  "first transition retransmission markers are incorrect")

activeStats = nrkeep_rtypes.stats()
nrkeep_pump.flushClient(clientRuntime, clientSocket, 416,
  bytes([nrkeep_qconstants.CLC_NOP]), activeStats)
activeOldAck = receiveOne(serverSocket).data
nrkeep_netchan.process(serverChannel, activeOldAck, 417)
serverStats = nrkeep_rtypes.stats()
nrkeep_pump.flushServerClient(serverRuntime, serverSocket, 0, 417, serverStats)
postRetryIdle = receiveOne(clientSocket).data
nrkeep_netchan.process(clientChannel, postRetryIdle, 418)

activeStats = nrkeep_rtypes.stats()
nrkeep_pump.flushClient(clientRuntime, clientSocket, 419,
  bytes([nrkeep_qconstants.CLC_NOP]), activeStats)
activeCoveringAck = receiveOne(serverSocket).data
nrkeep_netchan.process(serverChannel, activeCoveringAck, 420)
serverStats = nrkeep_rtypes.stats()
nrkeep_pump.flushServerClient(serverRuntime, serverSocket, 0, 420, serverStats)
transitionRetry = receiveOne(clientSocket).data
retryResult = nrkeep_netchan.process(clientChannel, transitionRetry, 421)
keepaliveAssert(nrkeep_packet.decodeHeader(transitionRetry, false).reliable == 1 and
  retryResult.payload == bytes([nrkeep_qconstants.SVC_NOP]) and
  serverChannel.firstReliableSequence == 1,
  "transition reliable did not survive repeated datagram loss")

activeStats = nrkeep_rtypes.stats()
nrkeep_pump.flushClient(clientRuntime, clientSocket, 422,
  bytes([nrkeep_qconstants.CLC_NOP]), activeStats)
activeFinalAck = receiveOne(serverSocket).data
nrkeep_netchan.process(serverChannel, activeFinalAck, 423)
keepaliveAssert(serverChannel.reliableLength == 0,
  "active client ACK did not release transition reliable")

nrkeep_udp.close(clientSocket)
nrkeep_udp.close(serverSocket)
print("network_runtime_signon_keepalive_tests: PASS")
