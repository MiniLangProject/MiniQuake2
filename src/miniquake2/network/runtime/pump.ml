/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Nonblocking UDP pump joining connection orchestration and pure Netchan. */
package miniquake2.network.runtime.pump

import miniquake2.platform.udp as pudp
import miniquake2.qcommon.byteio as qbio
import miniquake2.qcommon.sizebuf as qsz
import miniquake2.protocol.constants as pc
import miniquake2.protocol.packet as ppacket
import miniquake2.protocol.netchan as pnetchan
import miniquake2.network.constants as nc
import miniquake2.network.client as nclient
import miniquake2.network.server as nserver
import miniquake2.network.runtime.types as nrtypes
import miniquake2.network.runtime.messages as rmessages
import miniquake2.network.runtime.commands as rcommands
import miniquake2.network.runtime.transport as rtransport
import miniquake2.server.administration as rpumpadmin
import miniquake2.client.runtime.dispatcher as crdispatcher
import miniquake2.client.runtime.handoff as crhandoff

// Send datagram.
function sendDatagram(socket, address, data, stats)
  pudp.send(socket, rtransport.host(address), address.port, data)
  stats.sent = stats.sent + 1
  return true
end function

// Send actions.
function sendActions(socket, actions, stats)
  for each action in actions
    sendDatagram(socket, action.address, action.data, stats)
  end for
  return len(actions)
end function

// Flush client.
function flushClient(runtime, socket, now, unreliable, stats)
  client = runtime.client
  if client.state < nc.CA_CONNECTED or client.channel is void then return false end if
  hasPayload = typeof(unreliable) == "bytes" and len(unreliable) > 0
  if client.state != nc.CA_CONNECTED and not runtime.ackPending and not hasPayload and
      not pnetchan.needReliable(client.channel) then return false end if
  packet = pnetchan.transmit(client.channel, unreliable, now)
  sendDatagram(socket, client.channel.remoteAddress, packet, stats)
  runtime.ackPending = false
  return true
end function

// CL_SendCmd throttles a connected (not yet active) client with no reliable
// work to one keepalive per second. The lower-level flushClient deliberately
// remains an unconditional Netchan transmit primitive for callers/tests.
function flushClientForPump(runtime, socket, now, stats)
  client = runtime.client
  if client.state == nc.CA_CONNECTED and client.channel is not void and
      not runtime.ackPending and not pnetchan.needReliable(client.channel) and
      now - client.channel.lastSent <= 1000 then return false end if
  return flushClient(runtime, socket, now, bytes(), stats)
end function

// Pump client.
function pumpClient(runtime, socket, now, maximumPackets)
  if typeof(maximumPackets) != "int" or maximumPackets < 1 then return error(7280, "client pump packet limit must be positive") end if
  stats = nrtypes.stats()
  resend = nclient.checkForResend(runtime.client, now)
  if resend is not void then sendActions(socket, [resend], stats) end if
  count = 0
  while count < maximumPackets and pudp.pending(socket)
    datagram = pudp.receive(socket, pc.MAX_MSGLEN)
    if datagram is void then break end if
    sender = rtransport.fromUdp(datagram.address, datagram.port)
    stats.received = stats.received + 1
    if ppacket.isConnectionless(datagram.data) then
      result = nclient.handleConnectionless(runtime.client, sender, datagram.data, now)
      sendActions(socket, result.actions, stats)
      if not result.accepted then stats.rejected = stats.rejected + 1 end if
    else
      header = ppacket.decodeHeader(datagram.data, false)
      result = nclient.receiveSequenced(runtime.client, sender, datagram.data, now)
      if result.accepted then
        if header.reliable == 1 then runtime.ackPending = true end if
        if len(result.payload) > 0 then rmessages.parsePayload(runtime, result.payload) end if
      else
        stats.rejected = stats.rejected + 1
      end if
    end if
    count = count + 1
  end while
  nclient.checkTimeout(runtime.client, now)
  flushClientForPump(runtime, socket, now, stats)
  return stats
end function

// Product client path: identical transport/Netchan handling, with accepted
// payloads committed through the transactional effects/snapshot/demo
// dispatcher instead of the legacy protocol-only parser.
function dispatchIntegratedPayload(integrated, payload, sequence, now)
  dispatched = try(crdispatcher.dispatch(integrated, payload, sequence, now))
  if dispatched is error then return dispatched end if
  if not dispatched.accepted then return false end if
  committed = try(crhandoff.commit(integrated, now))
  if committed is error then return committed end if
  return true
end function

// Pump integrated client.
function pumpIntegratedClient(integrated, socket, now, maximumPackets)
  runtime = integrated.network
  if typeof(maximumPackets) != "int" or maximumPackets < 1 then return error(7280, "client pump packet limit must be positive") end if
  stats = nrtypes.stats()
  resend = nclient.checkForResend(runtime.client, now)
  if resend is not void then sendActions(socket, [resend], stats) end if
  count = 0
  while count < maximumPackets and pudp.pending(socket)
    datagram = pudp.receive(socket, pc.MAX_MSGLEN)
    if datagram is void then break end if
    sender = rtransport.fromUdp(datagram.address, datagram.port)
    stats.received = stats.received + 1
    if ppacket.isConnectionless(datagram.data) then
      result = nclient.handleConnectionless(runtime.client, sender, datagram.data, now)
      sendActions(socket, result.actions, stats)
      if not result.accepted then stats.rejected = stats.rejected + 1 end if
    else
      header = ppacket.decodeHeader(datagram.data, false)
      result = nclient.receiveSequenced(runtime.client, sender, datagram.data, now)
      if result.accepted then
        if header.reliable == 1 then runtime.ackPending = true end if
        if len(result.payload) > 0 then
          acceptedPayload = try(dispatchIntegratedPayload(integrated,
            result.payload, header.sequence, now))
          // CL_ParseServerMessage raises ERR_DROP for malformed service data;
          // checksum/precache errors have the same connection-fatal contract.
          // Stale duplicate payloads remain ordinary rejected packets.
          if acceptedPayload is error then return acceptedPayload end if
          if not acceptedPayload then stats.rejected = stats.rejected + 1 end if
        end if
      else
        stats.rejected = stats.rejected + 1
      end if
    end if
    count = count + 1
  end while
  nclient.checkTimeout(runtime.client, now)
  flushClientForPump(runtime, socket, now, stats)
  return stats
end function

// Flush server client.
function flushServerClient(runtime, socket, slot, now, stats)
  client = runtime.server.clients[slot]
  if client.state < nc.CS_CONNECTED or client.channel is void then return false end if
  if client.state != nc.CS_CONNECTED and not runtime.ackPending[slot] and
      not pnetchan.needReliable(client.channel) then return false end if
  packet = pnetchan.transmit(client.channel, bytes(), now)
  sendDatagram(socket, client.channel.remoteAddress, packet, stats)
  runtime.ackPending[slot] = false
  return true
end function

// Send one unreliable server payload while preserving any staged reliable
// bytes in the same Netchan packet. Runtime/session uses this for snapshots;
// the regular pump retains responsibility for pure ACK/reliable flushes.
function sendServerPayload(runtime, socket, slot, now, payload)
  if typeof(slot) != "int" or slot < 0 or slot >= runtime.server.maxClients then return error(7282, "server payload slot outside range") end if
  if typeof(payload) != "bytes" or len(payload) > pc.MAX_MSGLEN then return error(7283, "server payload outside MAX_MSGLEN") end if
  client = runtime.server.clients[slot]
  if client.state < nc.CS_CONNECTED or client.channel is void then return false end if
  stats = nrtypes.stats()
  packet = pnetchan.transmit(client.channel, payload, now)
  sendDatagram(socket, client.channel.remoteAddress, packet, stats)
  runtime.ackPending[slot] = false
  return stats
end function

// SV_CheckTimeouts routes spawned clients through SV_DropClient before the
// slot is reclaimed.  SV_DropClient calls the game DLL's ClientDisconnect,
// which removes the player entity and other game-owned state.  Keep that
// callback boundary in the managed runtime; connected clients have not
// entered the game yet and therefore deliberately do not receive it.
function expireTimedOutClients(runtime, now)
  dropPoint = now - runtime.server.timeoutMsec
  slot = 0
  while slot < runtime.server.maxClients
    client = runtime.server.clients[slot]
    if client.state == nc.CS_SPAWNED and client.lastMessage < dropPoint then
      runtime.callbacks.clientDisconnect(slot)
    end if
    slot = slot + 1
  end while

  dropped = nserver.checkTimeouts(runtime.server, now)
  for each droppedSlot in dropped
    runtime.transfers[droppedSlot] = nrtypes.DownloadTransfer("", bytes(), -1)
    runtime.deferredReliable[droppedSlot] = []
    runtime.ackPending[droppedSlot] = false
  end for
  return dropped
end function

// SV_CalcPings averages the positive samples in frame_latency and publishes
// the result both on client_t and the corresponding game client.  Keeping the
// Game API write behind a callback avoids coupling the transport runtime to a
// concrete game implementation.
function calculatePings(runtime)
  slot = 0
  while slot < runtime.server.maxClients
    client = runtime.server.clients[slot]
    if client.state == nc.CS_SPAWNED then
      total = 0
      count = 0
      index = 0
      while index < nc.LATENCY_COUNTS
        if client.frameLatencies[index] > 0 then
          total = total + client.frameLatencies[index]
          count = count + 1
        end if
        index = index + 1
      end while
      if count == 0 then client.ping = 0
      else client.ping = qbio.truncInt(total / count)
      end if
      runtime.callbacks.clientPing(slot, client.ping)
    end if
    slot = slot + 1
  end while
  return true
end function

// Pump server paused.
function pumpServerPaused(runtime, socket, now, maximumPackets, paused)
  // Keep pump server paused phases explicit: validate inputs, update owned state, then publish the result.
  if typeof(maximumPackets) != "int" or maximumPackets < 1 then return error(7281, "server pump packet limit must be positive") end if
  if typeof(paused) != "bool" then return error(7284, "server paused state must be boolean") end if
  stats = nrtypes.stats()
  count = 0
  while count < maximumPackets and pudp.pending(socket)
    datagram = pudp.receive(socket, pc.MAX_MSGLEN)
    if datagram is void then break end if
    sender = rtransport.fromUdp(datagram.address, datagram.port)
    stats.received = stats.received + 1
    if ppacket.isConnectionless(datagram.data) then
      result = rcommands.handleConnectionless(runtime, sender, datagram.data, now)
      sendActions(socket, result.actions, stats)
      if not result.accepted then stats.rejected = stats.rejected + 1 end if
    else
      header = ppacket.decodeHeader(datagram.data, true)
      result = nserver.receiveSequenced(runtime.server, sender, datagram.data, now)
      if result.accepted then
        slot = result.slot
        if header.reliable == 1 then runtime.ackPending[slot] = true end if
        if len(result.payload) > 0 then
          channel = runtime.server.clients[slot].channel
          rcommands.parseClientPayload(runtime, slot, result.payload,
            channel.incomingSequence, channel.dropped, paused)
        end if
      else
        stats.rejected = stats.rejected + 1
      end if
    end if
    count = count + 1
  end while
  calculatePings(runtime)
  expireTimedOutClients(runtime, now)
  slot = 0
  while slot < runtime.server.maxClients
    client = runtime.server.clients[slot]
    if client.state >= nc.CS_CONNECTED and client.channel is not void then
      rcommands.retryDeferredReliable(runtime, slot)
    end if
    flushServerClient(runtime, socket, slot, now, stats)
    slot = slot + 1
  end while
  if rpumpadmin.takeMasterPing(runtime.administration) then
    sendActions(socket, nserver.masterPingActions(runtime.administration.masters), stats)
  end if
  sendActions(socket, nserver.heartbeatActions(runtime.server,
    runtime.administration.masters, now), stats)
  return stats
end function

// Pump server.
function pumpServer(runtime, socket, now, maximumPackets)
  return pumpServerPaused(runtime, socket, now, maximumPackets, false)
end function

// Pump pair.
function pumpPair(clientRuntime, serverRuntime, clientSocket, serverSocket, now, maximumPackets)
  clientFirst = pumpClient(clientRuntime, clientSocket, now, maximumPackets)
  serverStats = pumpServer(serverRuntime, serverSocket, now, maximumPackets)
  clientSecond = pumpClient(clientRuntime, clientSocket, now, maximumPackets)
  return nrtypes.PumpStats(clientFirst.received + serverStats.received + clientSecond.received,
    clientFirst.sent + serverStats.sent + clientSecond.sent,
    clientFirst.rejected + serverStats.rejected + clientSecond.rejected)
end function

// Master addresses are already-resolved managed endpoints. DNS discovery is a
// platform/bootstrap concern and deliberately stays outside this UDP pump.
function pumpHeartbeats(serverRuntime, serverSocket, masters, now)
  stats = nrtypes.stats()
  sendActions(serverSocket, nserver.heartbeatActions(serverRuntime.server, masters, now), stats)
  return stats
end function

// Shut down server.
function shutdownServer(serverRuntime, serverSocket)
  stats = nrtypes.stats()
  sendActions(serverSocket, nserver.shutdownActions(serverRuntime.server,
    serverRuntime.administration.masters), stats)
  return stats
end function
