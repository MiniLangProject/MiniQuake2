/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later

Deterministic Quake II 3.19 challenge/connect/slot/timeout/heartbeat tests.
*/
import miniquake2.qcommon.types as qt
import miniquake2.protocol.packet as ppacket
import miniquake2.protocol.netchan as pnetchan
import miniquake2.network.constants as nc
import miniquake2.network.address as naddress
import miniquake2.network.connectionless as nconnectionless
import miniquake2.network.client as nclient
import miniquake2.network.server as nserver
import miniquake2.network.snapshot as nsnapshot

// Assert the equal test condition.
function assertEqual(actual, expected, name)
  if actual != expected then return error(7950, name + ": expected " + expected + ", got " + actual) end if
  return true
end function

// Verify client-originated OOB rcon framing and injection guards.
function testClientRcon()
  address = ip(10, 20, 30, 40, 27910)
  client = nclient.create(7, 5000)
  action = nclient.rconAction(client, address, "secret", "status")
  request = nconnectionless.parsePacket(action.data)
  assertEqual(action.kind, "rcon", "rcon action kind")
  assertEqual(request.arguments[0], "rcon", "rcon wire command")
  assertEqual(request.arguments[1], "secret", "rcon wire password")
  assertEqual(request.arguments[2], "status", "rcon wire payload")
  assertTrue(try(nclient.rconAction(client, address, "secret",
    "status\nquit")) is error, "rcon line injection rejected")
  return true
end function

// Assert the true test condition.
function assertTrue(value, name)
  if value != true then return error(7951, name + ": expected true") end if
  return true
end function

// Return the ip value.
function ip(a, b, c, d, port)
  return qt.NetAddress(nc.NA_IP, [a, b, c, d], [0, 0, 0, 0, 0, 0, 0, 0, 0, 0], port)
end function

// Return the complete connection value.
function completeConnection(server, client, address, startTime)
  resend = nclient.checkForResend(client, startTime)
  assertEqual(ppacket.decodeConnectionlessText(resend.data), "getchallenge\n", "getchallenge request")
  challengeReply = nserver.handleConnectionless(server, address, resend.data, startTime + 1)
  assertTrue(challengeReply.accepted, "challenge allocated")
  clientReply = nclient.handleConnectionless(client, address, challengeReply.actions[0].data, startTime + 2)
  assertTrue(clientReply.accepted, "client accepts challenge")
  connectRequest = nconnectionless.parsePacket(clientReply.actions[0].data)
  assertEqual(connectRequest.arguments[0], "connect", "connect command")
  assertEqual(connectRequest.arguments[1], "34", "connect protocol")
  accepted = nserver.handleConnectionless(server, address, clientReply.actions[0].data, startTime + 3)
  assertTrue(accepted.accepted, "server accepts connect")
  connected = nclient.handleConnectionless(client, address, accepted.actions[0].data, startTime + 4)
  assertTrue(connected.accepted, "client accepts client_connect")
  return accepted.slot
end function

// Verify handshake and commands.
function testHandshakeAndCommands()
  address = ip(10, 20, 30, 40, 27910)
  server = nserver.create(2, "Test Server", "base1", "\\hostname\\Test Server", true, true)
  client = nclient.create(0x4567, 5000)
  nclient.beginConnect(client, "10.20.30.40", address, "\\name\\Ranger\\rate\\5000", 0)
  slot = completeConnection(server, client, address, 0)
  assertEqual(slot, 0, "first free slot")
  assertEqual(client.state, nc.CA_CONNECTED, "client connected state")
  assertEqual(server.clients[0].state, nc.CS_CONNECTED, "server connected state")
  assertEqual(server.clients[0].name, "Ranger", "userinfo name")
  assertEqual(server.clients[0].qport, 0x4567, "slot qport")
  assertEqual(client.channel.message.curSize, 5, "new command staged reliably")

  duplicate = nclient.handleConnectionless(client, address, nconnectionless.clientConnect(), 10)
  assertEqual(duplicate.accepted, false, "duplicate client_connect ignored")
  ping = nserver.handleConnectionless(server, address, nconnectionless.ping(), 11)
  assertEqual(ppacket.decodeConnectionlessText(ping.actions[0].data), "ack", "ping acknowledgement")
  status = nserver.handleConnectionless(server, address, nconnectionless.status(), 12)
  parsedStatus = nconnectionless.parsePacket(status.actions[0].data)
  assertEqual(parsedStatus.command, "print", "status print command")
  assertTrue(len(bytes(parsedStatus.remainder)) > 0, "status body")
  info = nserver.handleConnectionless(server, address, nconnectionless.info(), 13)
  assertEqual(nconnectionless.parsePacket(info.actions[0].data).command, "info", "info response")

  firstChallenge = nserver.handleConnectionless(server, address, nconnectionless.getChallenge(), 14)
  secondChallenge = nserver.handleConnectionless(server, ip(10, 20, 30, 40, 30000), nconnectionless.getChallenge(), 15)
  assertEqual(firstChallenge.payload, secondChallenge.payload, "challenge reused by base address")
  disconnects = nclient.disconnect(client, 16)
  assertEqual(len(disconnects), 3, "disconnect packet redundancy")
  assertEqual(len(ppacket.decodePacket(disconnects[0], true).payload), 16, "first disconnect includes staged new command")
  assertEqual(len(ppacket.decodePacket(disconnects[1], true).payload), 11, "disconnect strlen wire length")
  assertEqual(client.state, nc.CA_DISCONNECTED, "explicit disconnect state")
  return true
end function

// Verify sequenced routing and nat.
function testSequencedRoutingAndNat()
  serverAddress = ip(192, 0, 2, 1, 27910)
  clientAddress = ip(192, 0, 2, 77, 40000)
  server = nserver.create(2, "Routing", "base1", "\\hostname\\Routing", false, false)
  client = nclient.create(1234, 5000)
  nclient.beginConnect(client, "server", serverAddress, "\\name\\Bitterman", 0)
  // Drive the server side using the client's source address while responses
  // are accepted from the configured server endpoint.
  challenge = nserver.handleConnectionless(server, clientAddress, nconnectionless.getChallenge(), 1)
  clientChallenge = nclient.handleConnectionless(client, serverAddress, challenge.actions[0].data, 2)
  accepted = nserver.handleConnectionless(server, clientAddress, clientChallenge.actions[0].data, 3)
  nclient.handleConnectionless(client, serverAddress, accepted.actions[0].data, 4)
  outbound = pnetchan.transmit(client.channel, bytes([1, 2, 3]), 5)
  routed = nserver.receiveSequenced(server, clientAddress, outbound, 6)
  assertTrue(routed.accepted, "sequenced packet routed by base address and qport")
  assertEqual(routed.slot, 0, "sequenced slot")
  assertEqual(server.clients[0].lastMessage, 6, "sequenced receive refreshes timeout")
  translated = ip(192, 0, 2, 77, 41000)
  second = pnetchan.transmit(client.channel, bytes([4]), 7)
  routed = nserver.receiveSequenced(server, translated, second, 8)
  assertTrue(routed.accepted, "translated source port accepted")
  assertEqual(server.clients[0].address.port, 41000, "translated port fixed up")
  return true
end function

// Verify timeouts and heartbeats.
function testTimeoutsAndHeartbeats()
  address = ip(203, 0, 113, 8, 27910)
  server = nserver.create(1, "Timeout", "base1", "\\hostname\\Timeout", true, true)
  client = nclient.create(42, 1000)
  nclient.beginConnect(client, "timeout", address, "\\name\\Marine", 0)
  slot = completeConnection(server, client, address, 0)
  server.timeoutMsec = 1000
  server.clients[slot].lastMessage = 1
  dropped = nserver.checkTimeouts(server, 1002)
  assertEqual(len(dropped), 1, "server timeout drop count")
  assertEqual(server.clients[slot].state, nc.CS_FREE, "timed out slot freed")

  // Client timeoutcount intentionally takes six checks, matching the debugger
  // grace behavior in CL_ReadPackets.
  client.channel.lastReceived = 0
  index = 0
  timedOut = false
  while index < 6
    timedOut = nclient.checkTimeout(client, 1001 + index)
    index = index + 1
  end while
  assertTrue(timedOut, "client disconnects after timeout grace")
  assertEqual(client.state, nc.CA_DISCONNECTED, "client timeout state")

  masters = [ip(198, 51, 100, 1, 27900), ip(198, 51, 100, 2, 0)]
  assertEqual(len(nserver.heartbeatActions(server, masters, nc.HEARTBEAT_MSEC - 1)), 0, "heartbeat not early")
  heartbeat = nserver.heartbeatActions(server, masters, nc.HEARTBEAT_MSEC)
  assertEqual(len(heartbeat), 1, "heartbeat active master count")
  assertEqual(nconnectionless.parsePacket(heartbeat[0].data).command, "heartbeat", "heartbeat command")
  assertEqual(len(nserver.heartbeatActions(server, masters, nc.HEARTBEAT_MSEC + 1)), 0, "heartbeat interval enforced")
  assertEqual(len(nserver.shutdownActions(server, masters)), 1, "master shutdown count")
  return true
end function

// Verify rejections and loopback.
function testRejectionsAndLoopback()
  remote = ip(100, 64, 0, 9, 27910)
  server = nserver.create(1, "Reject", "base1", "\\hostname\\Reject", false, false)
  noChallenge = nserver.handleConnectionless(server, remote,
    nconnectionless.connect(7, 123, "\\name\\NoChallenge"), 1)
  assertEqual(noChallenge.message, "no-challenge", "connect requires challenge")
  allocated = nserver.handleConnectionless(server, remote, nconnectionless.getChallenge(), 2)
  badChallenge = nserver.handleConnectionless(server, remote,
    nconnectionless.connect(7, allocated.payload + 1, "\\name\\BadChallenge"), 3)
  assertEqual(badChallenge.message, "bad-challenge", "wrong challenge rejected")

  loopback = qt.NetAddress(nc.NA_LOOPBACK, [0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0, 0, 0, 0], 0)
  localClient = nclient.create(9, 1000)
  nclient.beginConnect(localClient, "localhost", loopback, "\\name\\Local", 4)
  localAction = nclient.connectLocal(localClient, loopback, 4)
  localAccepted = nserver.handleConnectionless(server, loopback, localAction.data, 5)
  assertTrue(localAccepted.accepted, "loopback challenge bypass")
  nclient.handleConnectionless(localClient, loopback, localAccepted.actions[0].data, 6)
  assertEqual(localClient.state, nc.CA_CONNECTED, "loopback client connected")
  assertEqual(nserver.handleConnectionless(server, remote, nconnectionless.info(), 7).message,
    "single-player-info-ignored", "single-player info ignored")

  nserver.dropClient(server, 0, 100, true)
  assertEqual(server.clients[0].state, nc.CS_ZOMBIE, "dropped client becomes zombie")
  nserver.checkTimeouts(server, 2101)
  assertEqual(server.clients[0].state, nc.CS_FREE, "expired zombie slot reclaimed")
  return true
end function

// Run this source file's command-line entry point.
function main(args)
  print "MiniQuake2 network connection tests starting: 5"
  result = try(testHandshakeAndCommands())
  if result is error then print "FAIL handshake: " + result.message; return 1 end if
  result = try(testSequencedRoutingAndNat())
  if result is error then print "FAIL routing: " + result.message; return 1 end if
  result = try(testTimeoutsAndHeartbeats())
  if result is error then print "FAIL timeout/heartbeat: " + result.message; return 1 end if
  result = try(testRejectionsAndLoopback())
  if result is error then print "FAIL rejection/loopback: " + result.message; return 1 end if
  result = try(testClientRcon())
  if result is error then print "FAIL client rcon: " + result.message; return 1 end if
  print "MiniQuake2 network connection tests passed: 5"
  return 0
end function
