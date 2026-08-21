/* Ordered, preflighted GameImport multicast delivery over Protocol-34 Netchan. */
package miniquake2.network.runtime.multicast_dispatch

import std.array as nrtmulticastarray
import miniquake2.protocol.constants as nrtmulticastpc
import miniquake2.protocol.netchan as nrtmulticastnetchan
import miniquake2.network.constants as nrtmulticastnc
import miniquake2.network.runtime.pump as nrtmulticastpump
import miniquake2.qcommon.sizebuf as nrtmulticastsizebuf
import miniquake2.server.game_messages as nrtmulticastmessages

struct MulticastDispatchResult
  sent
  delivered
  deferred
end struct

struct MulticastClientPlan
  slot
  unreliablePackets
  reliableFragments
end struct

function payloadCapacity(client)
  if client.channel is void then return 0 end if
  reliable = client.channel.reliableLength
  if reliable == 0 and client.channel.message.curSize > 0 then reliable = client.channel.message.curSize end if
  capacity = nrtmulticastpc.MAX_MSGLEN - nrtmulticastpc.PACKET_HEADER_SERVER - reliable
  if capacity < 0 then return 0 end if
  return capacity
end function

function firstReliable(events)
  index = 0
  while index < len(events)
    if nrtmulticastmessages.reliableDestination(events[index].destination) then return index end if
    index = index + 1
  end while
  return len(events)
end function

function packetize(events, first, last, maximumPayload)
  packets = []
  buffer = nrtmulticastsizebuf.alloc(maximumPayload)
  index = first
  while index < last
    fragment = events[index].payload
    if len(fragment) > maximumPayload then return false end if
    if buffer.curSize + len(fragment) > maximumPayload then
      packets = packets + [nrtmulticastsizebuf.dataSlice(buffer)]
      nrtmulticastsizebuf.clear(buffer)
    end if
    nrtmulticastsizebuf.writeBytes(buffer, fragment)
    index = index + 1
  end while
  if buffer.curSize > 0 then packets = packets + [nrtmulticastsizebuf.dataSlice(buffer)] end if
  return packets
end function

function buildPlan(runtime, slot, events)
  if typeof(events) != "array" then return error(7290, "routed multicast list must be an array") end if
  if len(events) == 0 then return void end if
  if slot < 0 or slot >= runtime.server.maxClients then return error(7291, "routed multicast slot outside range") end if
  nrtmulticastmessages.validateAll(events)
  client = runtime.server.clients[slot]
  if client.state != nrtmulticastnc.CS_SPAWNED or client.channel is void then
    return error(7292, "routed multicast recipient is not spawned")
  end if
  if client.channel.fatalError or client.channel.message.overflowed then
    return error(7293, "routed multicast recipient Netchan is corrupt")
  end if

  reliableStart = firstReliable(events)
  unreliablePackets = []
  if reliableStart > 0 then
    capacity = payloadCapacity(client)
    if reliableStart < len(events) then
      if client.channel.message.curSize > 0 then return false end if
      capacity = nrtmulticastpc.MAX_MSGLEN - nrtmulticastpc.PACKET_HEADER_SERVER
    end if
    if capacity <= 0 then return false end if
    unreliablePackets = packetize(events, 0, reliableStart, capacity)
    if unreliablePackets == false then return false end if
  end if

  reliableFragments = []
  if reliableStart < len(events) then
    index = reliableStart
    while index < len(events)
      reliableFragments = reliableFragments + [events[index].payload]
      index = index + 1
    end while
    if not nrtmulticastnetchan.canQueueReliableFragments(client.channel, reliableFragments) then return false end if
  end if
  return MulticastClientPlan(slot, unreliablePackets, reliableFragments)
end function

function dispatchRouted(runtime, socket, events, routedEvents, now)
  if typeof(events) != "array" or typeof(routedEvents) != "array" or
      len(routedEvents) != runtime.server.maxClients then
    return error(7294, "routed multicast batch shape is malformed")
  end if
  if len(events) == 0 then return MulticastDispatchResult(0, true, 0) end if
  nrtmulticastmessages.validateAll(events)
  plans = []
  slot = 0
  while slot < runtime.server.maxClients
    plan = buildPlan(runtime, slot, routedEvents[slot])
    if plan == false then return MulticastDispatchResult(0, false, len(events)) end if
    if plan is not void then plans = plans + [plan] end if
    slot = slot + 1
  end while

  sent = 0
  for each plan in plans
    for each payload in plan.unreliablePackets
      stats = nrtmulticastpump.sendServerPayload(runtime, socket, plan.slot, now, payload)
      if typeof(stats) != "struct" then return error(7295, "multicast recipient became unavailable") end if
      sent = sent + stats.sent
    end for
    if len(plan.reliableFragments) > 0 then
      client = runtime.server.clients[plan.slot]
      queued = nrtmulticastnetchan.queueReliableFragments(client.channel, plan.reliableFragments)
      if queued == false then return error(7296, "multicast fragment preflight became stale") end if
      stats = nrtmulticastpump.sendServerPayload(runtime, socket, plan.slot, now, bytes())
      if typeof(stats) != "struct" then return error(7295, "multicast recipient became unavailable") end if
      sent = sent + stats.sent
    end if
  end for
  return MulticastDispatchResult(sent, true, 0)
end function
