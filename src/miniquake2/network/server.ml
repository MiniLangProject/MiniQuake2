//! Provides miniquake2 network server facilities for this project.

/*
Copyright (C) 1997-2001 Id Software, Inc.
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later

Server connectionless dispatch, client-slot ownership, packet routing,
timeouts and master heartbeat scheduling.
*/
package miniquake2.network.server

import miniquake2.qcommon.info as qinfo
import miniquake2.protocol.constants as pc
import miniquake2.protocol.packet as ppacket
import miniquake2.protocol.netchan as pnetchan
import miniquake2.network.constants as nc
import miniquake2.network.types as nt
import miniquake2.network.address as naddress
import miniquake2.network.connectionless as nconnectionless
import miniquake2.network.snapshot as nsnapshot

/// Report whether empty client.
/// @param slot slot value consumed by this operation.
function emptyClient(slot)
  return nt.ServerClient(slot, nc.CS_FREE, "", "", 0, 0, void, 0, 0, 0, 0,
    void, array(nc.UPDATE_BACKUP, void), 0, 0,
    array(nc.LATENCY_COUNTS, 0), array(nc.UPDATE_BACKUP, 0), 5000,
    array(nc.RATE_MESSAGES, 0))
end function

/// Creates create for the miniquake2 network server module.
/// @param maxClients maxClients value consumed by this operation.
/// @param hostname hostname value consumed by this operation.
/// @param mapName mapName value consumed by this operation.
/// @param serverInfo serverInfo value consumed by this operation.
/// @param dedicated dedicated value consumed by this operation.
/// @param publicServer publicServer value consumed by this operation.
function create(maxClients, hostname, mapName, serverInfo, dedicated, publicServer)
  if typeof(maxClients) != "int" or maxClients < 1 or maxClients > 256 then return error(7120, "server maxClients outside protocol range") end if
  if not qinfo.validate(serverInfo) then return error(7121, "serverinfo string is invalid") end if
  clients = array(maxClients, void)
  index = 0
  while index < maxClients
    clients[index] = emptyClient(index)
    index = index + 1
  end while
  return nt.ServerState(0, hostname, mapName, serverInfo, maxClients, clients,
    array(nc.MAX_CHALLENGES, void), 0, dedicated, publicServer, false,
    nc.DEFAULT_TIMEOUT_MSEC, nc.DEFAULT_ZOMBIE_MSEC, nc.DEFAULT_RECONNECT_MSEC, 1)
end function

/// Return the status string value.
/// @param server server value consumed by this operation.
function statusString(server)
  output = server.serverInfo + "\n"
  index = 0
  while index < server.maxClients
    client = server.clients[index]
    if client.state == nc.CS_CONNECTED or client.state == nc.CS_SPAWNED then
      line = client.score + " " + client.ping + " \"" + client.name + "\"\n"
      if len(bytes(output)) + len(bytes(line)) >= pc.MAX_MSGLEN - 16 then break end if
      output = output + line
    end if
    index = index + 1
  end while
  return output
end function

/// Report whether connected count.
/// @param server server value consumed by this operation.
function connectedCount(server)
  count = 0
  for each client in server.clients
    if client.state >= nc.CS_CONNECTED then count = count + 1 end if
  end for
  return count
end function

/// Return the info string value.
/// @param server server value consumed by this operation.
/// @param version version value consumed by this operation.
function infoString(server, version)
  if version != pc.PROTOCOL_VERSION then return server.hostname + ": wrong version\n" end if
  return nconnectionless.padLeft(server.hostname, 16) + " " +
    nconnectionless.padLeft(server.mapName, 8) + " " +
    nconnectionless.padLeft(connectedCount(server), 2) + "/" +
    nconnectionless.padLeft(server.maxClients, 2) + "\n"
end function

/// Return the next challenge value.
/// @param server server value consumed by this operation.
function nextChallenge(server)
  server.challengeSeed = (server.challengeSeed * 1103515245 + 12345) & 0x7fffffff
  return (server.challengeSeed >> 16) & 0x7fff
end function

/// Return the challenge for the requested input.
/// @param server server value consumed by this operation.
/// @param address address value consumed by this operation.
/// @param now now value consumed by this operation.
function challengeFor(server, address, now)
  oldest = 0
  oldestTime = 0x7fffffff
  index = 0
  while index < nc.MAX_CHALLENGES
    entry = server.challenges[index]
    if entry is not void and naddress.compareBase(address, entry.address) then return entry.value end if
    entryTime = 0
    if entry is not void then entryTime = entry.time end if
    if entryTime < oldestTime then oldestTime = entryTime; oldest = index end if
    index = index + 1
  end while
  value = nextChallenge(server)
  server.challenges[oldest] = nt.Challenge(naddress.copy(address), value, now)
  return value
end function

/// Report whether challenge valid.
/// @param server server value consumed by this operation.
/// @param address address value consumed by this operation.
/// @param value Value consumed or transformed by the operation.
function challengeValid(server, address, value)
  if naddress.isLocal(address) then return true end if
  for each entry in server.challenges
    if entry is not void and naddress.compareBase(address, entry.address) then return entry.value == value end if
  end for
  return false
end function

/// Report whether has challenge.
/// @param server server value consumed by this operation.
/// @param address address value consumed by this operation.
function hasChallenge(server, address)
  if naddress.isLocal(address) then return true end if
  for each entry in server.challenges
    if entry is not void and naddress.compareBase(address, entry.address) then return true end if
  end for
  return false
end function

/// Return the sanitized name.
/// @param userInfo userInfo value consumed by this operation.
function sanitizedName(userInfo)
  name = qinfo.valueForKey(userInfo, "name")
  source = bytes(name)
  output = bytes(len(source))
  index = 0
  while index < len(source)
    output[index] = source[index] & 127
    index = index + 1
  end while
  return decode(output)
end function

/// SV_UserinfoChanged clamps the client-requested one-second snapshot budget.
/// Missing or non-numeric values retain the stock 5000 byte default.
/// @param userInfo userInfo value consumed by this operation.
function clientRate(userInfo)
  value = qinfo.valueForKey(userInfo, "rate")
  if value == "" then return 5000 end if
  parsed = try(nconnectionless.parseDecimal(value))
  rate = 0
  if parsed is not error then rate = parsed end if
  if rate < 100 then return 100 end if
  if rate > 15000 then return 15000 end if
  return rate
end function

/// Apply user info.
/// @param client client value consumed by this operation.
/// @param userInfo userInfo value consumed by this operation.
function applyUserInfo(client, userInfo)
  client.userInfo = userInfo
  client.name = sanitizedName(userInfo)
  client.rate = clientRate(userInfo)
  return client
end function

/// Return the reply value.
/// @param kind kind value consumed by this operation.
/// @param address address value consumed by this operation.
/// @param data Input data consumed by the operation.
/// @param slot slot value consumed by this operation.
/// @param text Text consumed by the operation.
function reply(kind, address, data, slot, text)
  return nt.action(kind, naddress.copy(address), data, slot, text)
end function

/// Handle connect.
/// @param server server value consumed by this operation.
/// @param address address value consumed by this operation.
/// @param request request value consumed by this operation.
/// @param now now value consumed by this operation.
function handleConnect(server, address, request, now)
  // Keep handle connect phases explicit: validate inputs, update owned state, then publish the result.
  if len(request.arguments) < 5 then return error(7122, "connect request is truncated") end if
  version = nconnectionless.parseDecimal(request.arguments[1])
  if version != pc.PROTOCOL_VERSION then
    action = reply("print", address, nconnectionless.printReply("Server is version 3.19.\n"), -1, "wrong-version")
    return nt.result(false, -1, [action], "wrong-version", void)
  end if
  qport = nconnectionless.parseDecimal(request.arguments[2]) & 0xffff
  challenge = nconnectionless.parseDecimal(request.arguments[3])
  userInfo = request.arguments[4]
  if not qinfo.validate(userInfo) then
    action = reply("print", address, nconnectionless.printReply("Invalid userinfo.\n"), -1, "invalid-userinfo")
    return nt.result(false, -1, [action], "invalid-userinfo", void)
  end if
  if server.attractLoop and not naddress.isLocal(address) then
    action = reply("print", address, nconnectionless.printReply("Connection refused.\n"), -1, "attract-loop")
    return nt.result(false, -1, [action], "attract-loop", void)
  end if
  if not naddress.isLocal(address) then
    if not hasChallenge(server, address) then
      action = reply("print", address, nconnectionless.printReply("No challenge for address.\n"), -1, "no-challenge")
      return nt.result(false, -1, [action], "no-challenge", void)
    end if
    if not challengeValid(server, address, challenge) then
      action = reply("print", address, nconnectionless.printReply("Bad challenge.\n"), -1, "bad-challenge")
      return nt.result(false, -1, [action], "bad-challenge", void)
    end if
  end if

  slot = -1
  index = 0
  while index < server.maxClients
    client = server.clients[index]
    if client.state != nc.CS_FREE and naddress.compareBase(address, client.address) and
        (client.qport == qport or address.port == client.address.port) then
      if not naddress.isLocal(address) and now - client.lastConnect < server.reconnectMsec then
        return nt.result(false, index, [], "reconnect-too-soon", void)
      end if
      slot = index
      break
    end if
    index = index + 1
  end while
  if slot < 0 then
    index = 0
    while index < server.maxClients
      if server.clients[index].state == nc.CS_FREE then slot = index; break end if
      index = index + 1
    end while
  end if
  if slot < 0 then
    action = reply("print", address, nconnectionless.printReply("Server is full.\n"), -1, "server-full")
    return nt.result(false, -1, [action], "server-full", void)
  end if

  userInfo = qinfo.setValueForKey(userInfo, "ip", naddress.text(address))
  channel = pnetchan.setup(pc.NS_SERVER, naddress.copy(address), qport, now)
  client = nt.ServerClient(slot, nc.CS_CONNECTED, userInfo, sanitizedName(userInfo), 0, 0,
    naddress.copy(address), qport, now, now, challenge, channel,
    array(nc.UPDATE_BACKUP, void), 0, 0,
    array(nc.LATENCY_COUNTS, 0), array(nc.UPDATE_BACKUP, 0), clientRate(userInfo),
    array(nc.RATE_MESSAGES, 0))
  server.clients[slot] = client
  action = reply("client_connect", address, nconnectionless.clientConnect(), slot, "client_connect")
  return nt.result(true, slot, [action], "connected", void)
end function

/// Handles connectionless for the miniquake2 network server workflow.
/// @param server server value consumed by this operation.
/// @param address address value consumed by this operation.
/// @param datagram datagram value consumed by this operation.
/// @param now now value consumed by this operation.
function handleConnectionless(server, address, datagram, now)
  request = nconnectionless.parsePacket(datagram)
  server.realTime = now
  if request.command == "ping" then
    return nt.result(true, -1, [reply("ack", address, nconnectionless.acknowledgement(), -1, "ack")], "ping", void)
  end if
  if request.command == "ack" then return nt.result(true, -1, [], "ack", void) end if
  if request.command == "status" then
    return nt.result(true, -1, [reply("print", address, nconnectionless.printReply(statusString(server)), -1, "status")], "status", void)
  end if
  if request.command == "info" then
    if server.maxClients == 1 then return nt.result(false, -1, [], "single-player-info-ignored", void) end if
    version = 0
    if len(request.arguments) >= 2 then version = nconnectionless.parseDecimal(request.arguments[1]) end if
    value = infoString(server, version)
    return nt.result(true, -1, [reply("info", address, nconnectionless.infoReply(value), -1, value)], "info", void)
  end if
  if request.command == "getchallenge" then
    value = challengeFor(server, address, now)
    return nt.result(true, -1, [reply("challenge", address, nconnectionless.challenge(value), -1, value)], "challenge", value)
  end if
  if request.command == "connect" then return handleConnect(server, address, request, now) end if
  return nt.result(false, -1, [], "unknown-connectionless-command", void)
end function

/// Receive sequenced.
/// @param server server value consumed by this operation.
/// @param address address value consumed by this operation.
/// @param datagram datagram value consumed by this operation.
/// @param now now value consumed by this operation.
function receiveSequenced(server, address, datagram, now)
  header = ppacket.decodeHeader(datagram, true)
  slot = -1
  index = 0
  while index < server.maxClients
    client = server.clients[index]
    if client.state != nc.CS_FREE and naddress.compareBase(address, client.address) and client.qport == header.qport then slot = index; break end if
    index = index + 1
  end while
  if slot < 0 then return nt.result(false, -1, [], "no-channel", void) end if
  client = server.clients[slot]
  if client.address.port != address.port then
    client.address.port = address.port
    client.channel.remoteAddress.port = address.port
  end if
  processed = pnetchan.process(client.channel, datagram, now)
  if not processed.accepted then return nt.result(false, slot, [], processed.reason, void) end if
  if client.state != nc.CS_ZOMBIE then client.lastMessage = now end if
  server.realTime = now
  return nt.result(true, slot, [], "sequenced", processed.payload)
end function

/// Drop client.
/// @param server server value consumed by this operation.
/// @param slot slot value consumed by this operation.
/// @param now now value consumed by this operation.
/// @param zombie zombie value consumed by this operation.
function dropClient(server, slot, now, zombie)
  if slot < 0 or slot >= server.maxClients then return error(7123, "drop client slot outside range") end if
  client = server.clients[slot]
  if zombie then client.state = nc.CS_ZOMBIE else client.state = nc.CS_FREE end if
  client.lastMessage = now
  client.name = ""
  return client
end function

/// Validate timeouts.
/// @param server server value consumed by this operation.
/// @param now now value consumed by this operation.
function checkTimeouts(server, now)
  server.realTime = now
  dropped = []
  dropPoint = now - server.timeoutMsec
  zombiePoint = now - server.zombieMsec
  index = 0
  while index < server.maxClients
    client = server.clients[index]
    if client.lastMessage > now then client.lastMessage = now end if
    if client.state == nc.CS_ZOMBIE and client.lastMessage < zombiePoint then
      client.state = nc.CS_FREE
    else if (client.state == nc.CS_CONNECTED or client.state == nc.CS_SPAWNED) and client.lastMessage < dropPoint then
      client.state = nc.CS_FREE
      client.name = ""
      dropped = dropped + [index]
    end if
    index = index + 1
  end while
  return dropped
end function

/// Mark spawned.
/// @param server server value consumed by this operation.
/// @param slot slot value consumed by this operation.
function markSpawned(server, slot)
  if slot < 0 or slot >= server.maxClients then return error(7124, "spawn slot outside range") end if
  if server.clients[slot].state != nc.CS_CONNECTED then return false end if
  server.clients[slot].state = nc.CS_SPAWNED
  return true
end function

/// Return the acknowledge frame value.
/// @param server server value consumed by this operation.
/// @param slot slot value consumed by this operation.
/// @param frameNumber frameNumber value consumed by this operation.
function acknowledgeFrame(server, slot, frameNumber)
  if slot < 0 or slot >= server.maxClients then return error(7125, "frame acknowledgement slot outside range") end if
  if typeof(frameNumber) != "int" then return error(7126, "frame acknowledgement must be an integer") end if
  client = server.clients[slot]
  // sv_user.c records one RTT sample only when lastframe changes.  The wire
  // frame number addresses both rings with their respective power-of-two
  // masks, exactly like client->frames / frame_latency in Quake II 3.19.
  if frameNumber != client.lastFrame then
    client.lastFrame = frameNumber
    if frameNumber > 0 then
      sentTime = client.frameSentTimes[frameNumber & nc.UPDATE_MASK]
      client.frameLatencies[frameNumber & (nc.LATENCY_COUNTS - 1)] = server.realTime - sentTime
    end if
  end if
  return frameNumber
end function

/// Write client frame.
/// @param server server value consumed by this operation.
/// @param slot slot value consumed by this operation.
/// @param current current value consumed by this operation.
/// @param baselines baselines value consumed by this operation.
/// @param buffer Buffer that receives or supplies the operation data.
function writeClientFrame(server, slot, current, baselines, buffer)
  if slot < 0 or slot >= server.maxClients then return error(7127, "frame client slot outside range") end if
  client = server.clients[slot]
  if client.state < nc.CS_CONNECTED then return error(7128, "cannot write frame for a free client slot") end if
  selected = nsnapshot.writeFrameForClient(buffer, current, client.lastFrame,
    client.frames, baselines, server.maxClients, client.suppressCount)
  client.frameSentTimes[current.serverFrame & nc.UPDATE_MASK] = server.realTime
  client.suppressCount = 0
  return selected
end function

/// sv_send.c: SV_RateDrop sums the previous ten 10 Hz datagram sizes. Remote
/// clients over their advertised rate skip this frame and expose the number of
/// skipped frames in the next svc_frame. Loopback is deliberately unlimited.
/// @param server server value consumed by this operation.
/// @param slot slot value consumed by this operation.
/// @param frameNumber frameNumber value consumed by this operation.
function rateDrop(server, slot, frameNumber)
  if slot < 0 or slot >= server.maxClients then return error(7129, "rate-drop client slot outside range") end if
  if typeof(frameNumber) != "int" or frameNumber < 0 then return error(7130, "rate-drop frame must be non-negative") end if
  client = server.clients[slot]
  if naddress.isLocal(client.address) then return false end if
  total = 0
  index = 0
  while index < nc.RATE_MESSAGES
    total = total + client.messageSizes[index]
    index = index + 1
  end while
  if total > client.rate then
    client.suppressCount = client.suppressCount + 1
    client.messageSizes[frameNumber % nc.RATE_MESSAGES] = 0
    return true
  end if
  return false
end function

/// Record client message.
/// @param server server value consumed by this operation.
/// @param slot slot value consumed by this operation.
/// @param frameNumber frameNumber value consumed by this operation.
/// @param messageSize messageSize value consumed by this operation.
function recordClientMessage(server, slot, frameNumber, messageSize)
  if slot < 0 or slot >= server.maxClients then return error(7129, "message-size client slot outside range") end if
  if typeof(frameNumber) != "int" or frameNumber < 0 then return error(7130, "message-size frame must be non-negative") end if
  if typeof(messageSize) != "int" or messageSize < 0 or messageSize > pc.MAX_MSGLEN then
    return error(7131, "client message size outside protocol range")
  end if
  server.clients[slot].messageSizes[frameNumber % nc.RATE_MESSAGES] = messageSize
  return messageSize
end function

/// Return the heartbeat actions value.
/// @param server server value consumed by this operation.
/// @param masters masters value consumed by this operation.
/// @param now now value consumed by this operation.
function heartbeatActions(server, masters, now)
  server.realTime = now
  if not server.dedicated or not server.publicServer then return [] end if
  if server.lastHeartbeat > now then server.lastHeartbeat = now end if
  if now - server.lastHeartbeat < nc.HEARTBEAT_MSEC then return [] end if
  server.lastHeartbeat = now
  payload = nconnectionless.heartbeat(statusString(server))
  actions = []
  index = 0
  while index < len(masters) and index < nc.MAX_MASTERS
    if masters[index] is not void and masters[index].port != 0 then actions = actions + [reply("heartbeat", masters[index], payload, -1, "heartbeat")] end if
    index = index + 1
  end while
  return actions
end function

/// Return the master ping actions value.
/// @param masters masters value consumed by this operation.
function masterPingActions(masters)
  actions = []
  index = 0
  while index < len(masters) and index < nc.MAX_MASTERS
    if masters[index] is not void and masters[index].port != 0 then
      actions = actions + [reply("master-ping", masters[index],
        nconnectionless.ping(), -1, "master-ping")]
    end if
    index = index + 1
  end while
  return actions
end function

/// Shut down actions.
/// @param server server value consumed by this operation.
/// @param masters masters value consumed by this operation.
function shutdownActions(server, masters)
  if not server.dedicated or not server.publicServer then return [] end if
  payload = nconnectionless.shutdown()
  actions = []
  index = 0
  while index < len(masters) and index < nc.MAX_MASTERS
    if masters[index] is not void and masters[index].port != 0 then actions = actions + [reply("shutdown", masters[index], payload, -1, "shutdown")] end if
    index = index + 1
  end while
  return actions
end function
