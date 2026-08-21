/* Nonblocking UDP pump joining connection orchestration and pure Netchan. */
package miniquake2.network.runtime.pump

import miniquake2.platform.udp as pudp
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
import miniquake2.client.runtime.dispatcher as crdispatcher
import miniquake2.client.runtime.handoff as crhandoff

function sendDatagram(socket, address, data, stats)
  pudp.send(socket, rtransport.host(address), address.port, data)
  stats.sent = stats.sent + 1
  return true
end function

function sendActions(socket, actions, stats)
  for each action in actions
    sendDatagram(socket, action.address, action.data, stats)
  end for
  return len(actions)
end function

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
  flushClient(runtime, socket, now, bytes(), stats)
  return stats
end function

// Product client path: identical transport/Netchan handling, with accepted
// payloads committed through the transactional effects/snapshot/demo
// dispatcher instead of the legacy protocol-only parser.
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
          dispatched = crdispatcher.dispatch(integrated, result.payload, header.sequence, now)
          if dispatched is error or not dispatched.accepted then stats.rejected = stats.rejected + 1
          else crhandoff.commit(integrated, now)
          end if
        end if
      else
        stats.rejected = stats.rejected + 1
      end if
    end if
    count = count + 1
  end while
  nclient.checkTimeout(runtime.client, now)
  flushClient(runtime, socket, now, bytes(), stats)
  return stats
end function

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

function pumpServer(runtime, socket, now, maximumPackets)
  if typeof(maximumPackets) != "int" or maximumPackets < 1 then return error(7281, "server pump packet limit must be positive") end if
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
            channel.incomingSequence, channel.dropped, false)
        end if
      else
        stats.rejected = stats.rejected + 1
      end if
    end if
    count = count + 1
  end while
  dropped = nserver.checkTimeouts(runtime.server, now)
  for each slot in dropped
    runtime.transfers[slot] = nrtypes.DownloadTransfer("", bytes(), -1)
    runtime.deferredReliable[slot] = []
    runtime.ackPending[slot] = false
  end for
  slot = 0
  while slot < runtime.server.maxClients
    client = runtime.server.clients[slot]
    if client.state >= nc.CS_CONNECTED and client.channel is not void then
      rcommands.retryDeferredReliable(runtime, slot)
    end if
    flushServerClient(runtime, socket, slot, now, stats)
    slot = slot + 1
  end while
  return stats
end function

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
