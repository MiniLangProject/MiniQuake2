//! Provides miniquake2 network runtime unicast dispatch facilities for this project.

/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Ordered, targeted GameImport unicast delivery over Protocol-34 Netchan. */
package miniquake2.network.runtime.unicast_dispatch

import std.array as nrtunicastarray
import miniquake2.protocol.constants as nrtunicastpc
import miniquake2.protocol.netchan as nrtunicastnetchan
import miniquake2.network.constants as nrtunicastnc
import miniquake2.network.runtime.pump as nrtunicastpump
import miniquake2.qcommon.sizebuf as nrtunicastsizebuf
import miniquake2.server.game_messages as nrtunicastmessages

/// Store unicast dispatch result data.
struct UnicastDispatchResult
  /// Stores the sent value associated with unicast dispatch result.
  sent
  /// Stores the delivered value associated with unicast dispatch result.
  delivered
  /// Stores the deferred value associated with unicast dispatch result.
  deferred
end struct

/// Store unicast client plan data.
struct UnicastClientPlan
  /// Stores the slot value associated with unicast client plan.
  slot
  /// Stores the unreliable packets value associated with unicast client plan.
  unreliablePackets
  /// Stores the reliable fragments value associated with unicast client plan.
  reliableFragments
end struct

/// Performs the payloadCapacity operation for the miniquake2 network runtime unicast dispatch module.
/// @param client client value consumed by this operation.
function payloadCapacity(client)
  if client.channel is void then return 0 end if
  reliable = client.channel.reliableLength
  if reliable == 0 and client.channel.message.curSize > 0 then reliable = client.channel.message.curSize end if
  capacity = nrtunicastpc.MAX_MSGLEN - nrtunicastpc.PACKET_HEADER_SERVER - reliable
  if capacity < 0 then return 0 end if
  return capacity
end function

/// Performs the packetize operation for the miniquake2 network runtime unicast dispatch module.
/// @param events events value consumed by this operation.
/// @param last last value consumed by this operation.
/// @param maximumPayload maximumPayload value consumed by this operation.
function packetize(events, last, maximumPayload)
  packets = array(last, void)
  packetCount = 0
  buffer = nrtunicastsizebuf.alloc(maximumPayload)
  index = 0
  while index < last
    fragment = events[index].payload
    if len(fragment) > maximumPayload then return false end if
    if buffer.curSize + len(fragment) > maximumPayload then
      packets[packetCount] = nrtunicastsizebuf.dataSlice(buffer)
      packetCount = packetCount + 1
      nrtunicastsizebuf.clear(buffer)
    end if
    nrtunicastsizebuf.writeBytes(buffer, fragment)
    index = index + 1
  end while
  if buffer.curSize > 0 then
    packets[packetCount] = nrtunicastsizebuf.dataSlice(buffer)
    packetCount = packetCount + 1
  end if
  if packetCount == last then return packets end if
  return nrtunicastarray.slice(packets, 0, packetCount)
end function

/// Build plan.
/// @param runtime runtime value consumed by this operation.
/// @param slot slot value consumed by this operation.
/// @param events events value consumed by this operation.
function buildPlan(runtime, slot, events)
  // Validate the target, partition transient/reliable payloads, then preflight
  // both independent client buffers before the dispatcher mutates Netchan.
  if typeof(events) != "array" then return error(7297, "routed unicast list must be an array") end if
  if len(events) == 0 then return void end if
  if slot < 0 or slot >= runtime.server.maxClients then return error(7298, "routed unicast slot outside range") end if
  nrtunicastmessages.validateUnicastAll(events)
  client = runtime.server.clients[slot]
  if client.state != nrtunicastnc.CS_SPAWNED or client.channel is void then
    return error(7299, "routed unicast recipient is not spawned")
  end if
  if client.channel.fatalError or client.channel.message.overflowed then
    return error(7300, "routed unicast recipient Netchan is corrupt")
  end if

  unreliableCount = 0
  reliableCount = 0
  for each countedEvent in events
    if countedEvent.reliable then reliableCount = reliableCount + 1
    else unreliableCount = unreliableCount + 1
    end if
  end for
  unreliableEvents = array(unreliableCount, void)
  reliableFragments = array(reliableCount, void)
  unreliableIndex = 0
  reliableIndex = 0
  for each classifiedEvent in events
    if classifiedEvent.reliable then
      reliableFragments[reliableIndex] = classifiedEvent.payload
      reliableIndex = reliableIndex + 1
    else
      unreliableEvents[unreliableIndex] = classifiedEvent
      unreliableIndex = unreliableIndex + 1
    end if
  end for
  unreliablePackets = []
  if unreliableCount > 0 then
    capacity = payloadCapacity(client)
    if capacity > 0 then
      unreliablePackets = packetize(unreliableEvents, unreliableCount,
        capacity)
      if unreliablePackets == false then unreliablePackets = [] end if
    end if
  end if

  if reliableCount > 0 then
    if not nrtunicastnetchan.canQueueReliableFragments(client.channel, reliableFragments) then return false end if
  end if
  return UnicastClientPlan(slot, unreliablePackets, reliableFragments)
end function

/// Dispatch routed.
/// @param runtime runtime value consumed by this operation.
/// @param socket socket value consumed by this operation.
/// @param events events value consumed by this operation.
/// @param routedEvents routedEvents value consumed by this operation.
/// @param now now value consumed by this operation.
function dispatchRouted(runtime, socket, events, routedEvents, now)
  // Keep dispatch routed phases explicit: validate inputs, update owned state, then publish the result.
  if typeof(events) != "array" or typeof(routedEvents) != "array" or
      len(routedEvents) != runtime.server.maxClients then
    return error(7301, "routed unicast batch shape is malformed")
  end if
  if len(events) == 0 then return UnicastDispatchResult(0, true, 0) end if
  nrtunicastmessages.validateUnicastAll(events)
  plans = array(runtime.server.maxClients, void)
  planCount = 0
  slot = 0
  while slot < runtime.server.maxClients
    plan = buildPlan(runtime, slot, routedEvents[slot])
    if plan == false then return UnicastDispatchResult(0, false, len(events)) end if
    if plan is not void then
      plans[planCount] = plan
      planCount = planCount + 1
    end if
    slot = slot + 1
  end while

  sent = 0
  planIndex = 0
  while planIndex < planCount
    plan = plans[planIndex]
    packetIndex = 0
    if len(plan.reliableFragments) > 0 then
      client = runtime.server.clients[plan.slot]
      queued = nrtunicastnetchan.queueReliableFragments(client.channel, plan.reliableFragments)
      if queued == false then return error(7303, "unicast fragment preflight became stale") end if
      firstPayload = bytes()
      if len(plan.unreliablePackets) > 0 then
        firstPayload = plan.unreliablePackets[0]
        packetIndex = 1
      end if
      stats = nrtunicastpump.sendServerPayload(runtime, socket, plan.slot, now,
        firstPayload)
      if typeof(stats) != "struct" then return error(7302, "unicast recipient became unavailable") end if
      sent = sent + stats.sent
    end if
    while packetIndex < len(plan.unreliablePackets)
      payload = plan.unreliablePackets[packetIndex]
      stats = nrtunicastpump.sendServerPayload(runtime, socket, plan.slot, now, payload)
      if typeof(stats) != "struct" then return error(7302, "unicast recipient became unavailable") end if
      sent = sent + stats.sent
      packetIndex = packetIndex + 1
    end while
    planIndex = planIndex + 1
  end while
  return UnicastDispatchResult(sent, true, 0)
end function
