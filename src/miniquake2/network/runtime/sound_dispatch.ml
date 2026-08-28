/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Ordered preflighted delivery of server sound fragments over Netchan. */
package miniquake2.network.runtime.sound_dispatch

import std.array as nrtsoundarray
import miniquake2.game.constants as nrtsoundgc
import miniquake2.protocol.constants as nrtsoundpc
import miniquake2.protocol.netchan as nrtsoundnetchan
import miniquake2.network.constants as nrtsoundnc
import miniquake2.network.runtime.pump as nrtsoundpump
import miniquake2.server.sound_events as nrtsoundevents

// Store sound dispatch result data.
struct SoundDispatchResult
  sent
  delivered
  deferred
end struct

// Store sound client plan data.
struct SoundClientPlan
  slot
  unreliablePackets
  reliableFragments
end struct

// Return the payload capacity value.
function payloadCapacity(client)
  if client.channel is void then return 0 end if
  reliable = client.channel.reliableLength
  if reliable == 0 and client.channel.message.curSize > 0 then reliable = client.channel.message.curSize end if
  capacity = nrtsoundpc.MAX_MSGLEN - nrtsoundpc.PACKET_HEADER_SERVER - reliable
  if capacity < 0 then return 0 end if
  return capacity
end function

// Build every datagram/staging mutation before touching a Netchan. Stock
// SV_StartSound routes each fragment independently: CHAN_RELIABLE enters the
// Netchan message, while ordinary weapon and movement sounds remain transient
// client datagrams even when they occur later in the same server frame.
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
  unreliableCount = 0
  reliableCount = 0
  for each countedEvent in events
    if (countedEvent.channelFlags & nrtsoundgc.CHAN_RELIABLE) != 0 then
      reliableCount = reliableCount + 1
    else unreliableCount = unreliableCount + 1
    end if
  end for
  unreliableFragments = array(unreliableCount, void)
  reliableFragments = array(reliableCount, void)
  unreliableIndex = 0
  reliableIndex = 0
  index = 0
  while index < len(events)
    if (events[index].channelFlags & nrtsoundgc.CHAN_RELIABLE) != 0 then
      reliableFragments[reliableIndex] = fragments[index]
      reliableIndex = reliableIndex + 1
    else
      unreliableFragments[unreliableIndex] = fragments[index]
      unreliableIndex = unreliableIndex + 1
    end if
    index = index + 1
  end while
  unreliablePackets = []
  if unreliableCount > 0 then
    capacity = payloadCapacity(client)
    if capacity < nrtsoundevents.MAX_SOUND_FRAGMENT_BYTES then
      // Stock svc_sound events without CHAN_RELIABLE live only in this
      // frame's datagram and are discarded when no packet room remains.
      unreliablePackets = []
    else
      unreliablePackets = nrtsoundevents.packetize(unreliableFragments,
        capacity)
    end if
  end if

  if reliableCount > 0 then
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
  planBuffer = array(runtime.server.maxClients, void)
  planCount = 0
  slot = 0
  while slot < runtime.server.maxClients
    plan = buildPlan(runtime, slot, routedEvents[slot])
    if typeof(plan) == "bool" and plan == false then
      return SoundDispatchResult(0, false, len(events))
    end if
    if plan is not void then
      planBuffer[planCount] = plan
      planCount = planCount + 1
    end if
    slot = slot + 1
  end while
  plans = nrtsoundarray.slice(planBuffer, 0, planCount)

  // No Netchan state was changed before this point.  All capacity and event
  // validation therefore fails atomically and leaves the bridge queue intact.
  sent = 0
  for each plan in plans
    packetIndex = 0
    if len(plan.reliableFragments) > 0 then
      client = runtime.server.clients[plan.slot]
      queued = nrtsoundnetchan.queueReliableFragments(client.channel,
        plan.reliableFragments)
      if queued == false then return error(7285, "sound fragment preflight became stale") end if
      firstPayload = bytes()
      if len(plan.unreliablePackets) > 0 then
        firstPayload = plan.unreliablePackets[0]
        packetIndex = 1
      end if
      stats = nrtsoundpump.sendServerPayload(runtime, socket, plan.slot, now,
        firstPayload)
      if typeof(stats) != "struct" then return error(7275, "sound recipient became unavailable") end if
      sent = sent + stats.sent
    end if
    while packetIndex < len(plan.unreliablePackets)
      payload = plan.unreliablePackets[packetIndex]
      stats = nrtsoundpump.sendServerPayload(runtime, socket, plan.slot, now, payload)
      if typeof(stats) != "struct" then return error(7275, "sound recipient became unavailable") end if
      sent = sent + stats.sent
      packetIndex = packetIndex + 1
    end while
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
