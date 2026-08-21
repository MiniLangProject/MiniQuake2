/* Ordered preflighted delivery of server sound fragments over Netchan. */
package miniquake2.network.runtime.sound_dispatch

import std.array as nrtsoundarray
import miniquake2.game.constants as nrtsoundgc
import miniquake2.protocol.constants as nrtsoundpc
import miniquake2.protocol.netchan as nrtsoundnetchan
import miniquake2.network.constants as nrtsoundnc
import miniquake2.network.runtime.pump as nrtsoundpump
import miniquake2.server.sound_events as nrtsoundevents

struct SoundDispatchResult
  sent
  delivered
  deferred
end struct

struct SoundClientPlan
  slot
  unreliablePackets
  reliableFragments
end struct

function payloadCapacity(client)
  if client.channel is void then return 0 end if
  reliable = client.channel.reliableLength
  if reliable == 0 and client.channel.message.curSize > 0 then reliable = client.channel.message.curSize end if
  capacity = nrtsoundpc.MAX_MSGLEN - nrtsoundpc.PACKET_HEADER_SERVER - reliable
  if capacity < 0 then return 0 end if
  return capacity
end function

function firstReliable(events)
  index = 0
  while index < len(events)
    if (events[index].channelFlags & nrtsoundgc.CHAN_RELIABLE) != 0 then return index end if
    index = index + 1
  end while
  return len(events)
end function

// Build every datagram/staging mutation before touching a Netchan.  Once a
// reliable sound occurs, the remaining ordered fragments for that recipient
// are upgraded into the same reliable tail.  This prevents an ordinary sound
// later in the frame from overtaking a reliable one while its ACK is pending.
function buildPlan(runtime, slot, events)
  if typeof(events) != "array" then return error(7276, "routed sound list must be an array") end if
  if len(events) == 0 then return void end if
  if slot < 0 or slot >= runtime.server.maxClients then return error(7277, "routed sound slot outside range") end if
  client = runtime.server.clients[slot]
  if client.state != nrtsoundnc.CS_SPAWNED or client.channel is void then
    return error(7278, "routed sound recipient is not spawned")
  end if
  if client.channel.fatalError or client.channel.message.overflowed then
    return error(7279, "routed sound recipient Netchan is corrupt")
  end if

  fragments = nrtsoundevents.encodeAll(events)
  reliableStart = firstReliable(events)
  unreliablePackets = []
  if reliableStart > 0 then
    capacity = payloadCapacity(client)
    if reliableStart < len(events) then
      // A pre-existing staged message would be transmitted with the prefix,
      // leaving the new reliable tail blocked behind an outstanding ACK.
      if client.channel.message.curSize > 0 then return false end if
      capacity = nrtsoundpc.MAX_MSGLEN - nrtsoundpc.PACKET_HEADER_SERVER
    end if
    if capacity < nrtsoundevents.MAX_SOUND_FRAGMENT_BYTES then return false end if
    unreliablePackets = nrtsoundevents.packetize(nrtsoundarray.slice(fragments, 0, reliableStart), capacity)
  end if

  reliableFragments = []
  if reliableStart < len(events) then
    index = reliableStart
    while index < len(fragments)
      reliableFragments = reliableFragments + [fragments[index]]
      index = index + 1
    end while
    if not nrtsoundnetchan.canQueueReliableFragments(client.channel,
        reliableFragments) then return false end if
  end if
  return SoundClientPlan(slot, unreliablePackets, reliableFragments)
end function

// routedEvents has one ordered event list per server slot.  The original
// events list is separately supplied so zero-recipient sounds are still
// validated and consumed as one atomic bridge queue.
function dispatchRouted(runtime, socket, events, routedEvents, now)
  if typeof(events) != "array" or typeof(routedEvents) != "array" or
      len(routedEvents) != runtime.server.maxClients then
    return error(7284, "routed sound batch shape is malformed")
  end if
  if len(events) == 0 then return SoundDispatchResult(0, true, 0) end if
  nrtsoundevents.encodeAll(events)
  plans = []
  slot = 0
  while slot < runtime.server.maxClients
    plan = buildPlan(runtime, slot, routedEvents[slot])
    if plan == false then return SoundDispatchResult(0, false, len(events)) end if
    if plan is not void then plans = plans + [plan] end if
    slot = slot + 1
  end while

  // No Netchan state was changed before this point.  All capacity and event
  // validation therefore fails atomically and leaves the bridge queue intact.
  sent = 0
  for each plan in plans
    for each payload in plan.unreliablePackets
      stats = nrtsoundpump.sendServerPayload(runtime, socket, plan.slot, now, payload)
      if typeof(stats) != "struct" then return error(7275, "sound recipient became unavailable") end if
      sent = sent + stats.sent
    end for
    if len(plan.reliableFragments) > 0 then
      client = runtime.server.clients[plan.slot]
      queued = nrtsoundnetchan.queueReliableFragments(client.channel,
        plan.reliableFragments)
      if queued == false then return error(7285, "sound fragment preflight became stale") end if
      stats = nrtsoundpump.sendServerPayload(runtime, socket, plan.slot, now, bytes())
      if typeof(stats) != "struct" then return error(7275, "sound recipient became unavailable") end if
      sent = sent + stats.sent
    end if
  end for
  return SoundDispatchResult(sent, true, 0)
end function

// Compatibility broadcast entry point retained for callers which do not own
// collision/PHS state.  ServerSession uses dispatchRouted instead.
function dispatch(runtime, socket, events, now)
  routed = array(runtime.server.maxClients, void)
  slot = 0
  while slot < runtime.server.maxClients
    client = runtime.server.clients[slot]
    if client.state == nrtsoundnc.CS_SPAWNED and client.channel is not void then routed[slot] = events
    else routed[slot] = []
    end if
    slot = slot + 1
  end while
  return dispatchRouted(runtime, socket, events, routed, now)
end function
