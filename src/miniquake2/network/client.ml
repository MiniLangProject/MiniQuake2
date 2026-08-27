/*
Copyright (C) 1997-2001 Id Software, Inc.
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later

Client connection-state orchestration from CL_CheckForResend,
CL_ConnectionlessPacket and CL_ReadPackets.
*/
package miniquake2.network.client

import miniquake2.qcommon.info as qinfo
import miniquake2.protocol.constants as pc
import miniquake2.protocol.netchan as pnetchan
import miniquake2.network.constants as nc
import miniquake2.network.types as nt
import miniquake2.network.address as naddress
import miniquake2.network.connectionless as nconnectionless
import miniquake2.network.snapshot as nsnapshot

// Create state.
function create(qport, timeoutMsec)
  if typeof(qport) != "int" or qport < 0 or qport > 0xffff then return error(7110, "client qport outside unsigned-short range") end if
  if typeof(timeoutMsec) != "int" or timeoutMsec <= 0 then return error(7111, "client timeout must be positive milliseconds") end if
  return nt.ClientState(nc.CA_DISCONNECTED, "", void, qport, 0, "", 0, 0,
    void, 0, timeoutMsec, array(nc.UPDATE_BACKUP, void), void, "", "")
end function

// Begin connect.
function beginConnect(client, serverName, serverAddress, userInfo, now)
  if serverAddress is void then return error(7112, "client server address is missing") end if
  if not qinfo.validate(userInfo) then return error(7113, "client userinfo is invalid") end if
  if typeof(now) != "int" then return error(7114, "client time must be integer milliseconds") end if
  client.state = nc.CA_CONNECTING
  client.serverName = serverName
  client.serverAddress = naddress.copy(serverAddress)
  client.userInfo = userInfo
  client.challenge = 0
  client.connectTime = -99999
  client.realTime = now
  client.channel = void
  client.timeoutCount = 0
  client.frames = array(nc.UPDATE_BACKUP, void)
  client.currentFrame = void
  return client
end function

// Return the reconnect value.
function reconnect(client, now)
  if client.serverAddress is void or client.serverName == "" then
    return error(7118, "client reconnect has no previous server")
  end if
  return beginConnect(client, client.serverName, client.serverAddress,
    client.userInfo, now)
end function

// Validate for resend.
function checkForResend(client, now)
  client.realTime = now
  if client.state != nc.CA_CONNECTING then return void end if
  if now - client.connectTime < nc.CONNECT_RETRY_MSEC then return void end if
  client.connectTime = now
  return nt.action("getchallenge", client.serverAddress, nconnectionless.getChallenge(), -1, "getchallenge")
end function

// Listen-server loopback skips the challenge round trip in Quake II 3.19.
function connectLocal(client, loopbackAddress, now)
  if client.state != nc.CA_CONNECTING or not naddress.isLocal(loopbackAddress) then return error(7116, "local connect requires a connecting client and loopback address") end if
  client.connectTime = now
  return nt.action("connect", loopbackAddress,
    nconnectionless.connect(client.qport, 0, client.userInfo), -1, "local-connect")
end function

// Return the sender matches value.
function senderMatches(client, sender)
  if client.serverAddress is void then return false end if
  return naddress.compare(sender, client.serverAddress)
end function

// Return the new command value.
function newCommand()
  return bytes([nc.CLC_STRINGCMD, 110, 101, 119, 0])
end function

// Return the disconnect command value.
function disconnectCommand()
  // CL_Disconnect uses strlen(final), so the strcpy terminator is not sent.
  return bytes([nc.CLC_STRINGCMD, 100, 105, 115, 99, 111, 110, 110, 101, 99, 116])
end function

// Handle connectionless.
function handleConnectionless(client, sender, datagram, now)
  // Keep handle connectionless phases explicit: validate inputs, update owned state, then publish the result.
  request = nconnectionless.parsePacket(datagram)
  client.realTime = now
  actions = []

  if request.command == "client_connect" then
    if client.state >= nc.CA_CONNECTED then return nt.result(false, -1, actions, "duplicate-client-connect", void) end if
    if client.state != nc.CA_CONNECTING or not senderMatches(client, sender) then return nt.result(false, -1, actions, "unexpected-client-connect", void) end if
    client.channel = pnetchan.setup(pc.NS_CLIENT, naddress.copy(sender), client.qport, now)
    pnetchan.queueReliable(client.channel, newCommand())
    client.state = nc.CA_CONNECTED
    client.timeoutCount = 0
    return nt.result(true, -1, actions, "connected", void)
  end if

  if request.command == "challenge" then
    if client.state != nc.CA_CONNECTING or not senderMatches(client, sender) then return nt.result(false, -1, actions, "unexpected-challenge", void) end if
    if len(request.arguments) < 2 then return error(7115, "challenge reply has no value") end if
    client.challenge = nconnectionless.parseDecimal(request.arguments[1])
    data = nconnectionless.connect(client.qport, client.challenge, client.userInfo)
    actions = [nt.action("connect", client.serverAddress, data, -1, "connect")]
    return nt.result(true, -1, actions, "challenge-accepted", void)
  end if

  if request.command == "ping" then
    actions = [nt.action("ack", sender, nconnectionless.acknowledgement(), -1, "ack")]
    return nt.result(true, -1, actions, "ping", void)
  end if
  if request.command == "info" then
    client.lastInfo = request.remainder
    return nt.result(true, -1, actions, "info", request.remainder)
  end if
  if request.command == "print" then
    client.lastPrint = request.remainder
    return nt.result(true, -1, actions, "print", request.remainder)
  end if
  if request.command == "echo" and len(request.arguments) >= 2 then
    actions = [nt.action("echo", sender, nconnectionless.frameText(request.arguments[1]), -1, request.arguments[1])]
    return nt.result(true, -1, actions, "echo", void)
  end if
  if request.command == "ack" then return nt.result(true, -1, actions, "ack", void) end if
  return nt.result(false, -1, actions, "unknown-connectionless-command", void)
end function

// Receive sequenced.
function receiveSequenced(client, sender, datagram, now)
  if client.state < nc.CA_CONNECTED or client.channel is void then return nt.result(false, -1, [], "not-connected", void) end if
  if not naddress.compare(sender, client.channel.remoteAddress) then return nt.result(false, -1, [], "wrong-server-address", void) end if
  processed = pnetchan.process(client.channel, datagram, now)
  if not processed.accepted then return nt.result(false, -1, [], processed.reason, void) end if
  client.timeoutCount = 0
  client.realTime = now
  return nt.result(true, -1, [], "sequenced", processed.payload)
end function

// Validate timeout.
function checkTimeout(client, now)
  client.realTime = now
  if client.state < nc.CA_CONNECTED or client.channel is void then client.timeoutCount = 0; return false end if
  if now - client.channel.lastReceived > client.timeoutMsec then
    client.timeoutCount = client.timeoutCount + 1
    if client.timeoutCount > 5 then client.state = nc.CA_DISCONNECTED; client.channel = void; return true end if
  else
    client.timeoutCount = 0
  end if
  return false
end function

// Accept frame.
function acceptFrame(client, frame)
  if client.state < nc.CA_CONNECTED or not frame.valid then return false end if
  client.frames[frame.serverFrame & nc.UPDATE_MASK] = frame
  client.currentFrame = frame
  client.state = nc.CA_ACTIVE
  return true
end function

// Parse frame.
function parseFrame(client, buffer, baselines)
  return parseFrameProtocol(client, buffer, baselines, 34)
end function

// Parse frame protocol.
function parseFrameProtocol(client, buffer, baselines, protocol)
  if client.state < nc.CA_CONNECTED then return error(7117, "frame received before client connection") end if
  frame = nsnapshot.readFrameProtocol(buffer, client.frames, baselines, protocol)
  acceptFrame(client, frame)
  return frame
end function

// Return the disconnect value.
function disconnect(client, now)
  packets = []
  if client.state >= nc.CA_CONNECTED and client.channel is not void then
    command = disconnectCommand()
    index = 0
    while index < 3
      packets = packets + [pnetchan.transmit(client.channel, command, now)]
      index = index + 1
    end while
  end if
  client.state = nc.CA_DISCONNECTED
  client.channel = void
  client.connectTime = 0
  client.timeoutCount = 0
  client.currentFrame = void
  client.frames = array(nc.UPDATE_BACKUP, void)
  return packets
end function
