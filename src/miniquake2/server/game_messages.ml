/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Typed bounded GameImport multicast queue at the API-v3/Protocol-34 boundary. */
package miniquake2.server.game_messages

import miniquake2.qcommon.types as sgmqtypes
import miniquake2.protocol.constants as sgmpc
import miniquake2.game.constants as sgmgc
import miniquake2.server.types as sgmtypes

const MAX_PENDING_MULTICAST_EVENTS = 256
const MAX_PENDING_MULTICAST_BYTES = 88576
const MAX_MULTICAST_FRAGMENT_BYTES = 1392
const MAX_PENDING_UNICAST_EVENTS = 256
const MAX_PENDING_UNICAST_BYTES = 88576

// Claim one ordering token shared by every GameImport message class. Stock
// Quake II appends multicast, unicast and sound commands to client buffers at
// the instant they are emitted; independent per-type counters lose that order
// when the managed bridge drains its typed queues at the frame boundary.
function claimEmissionSerial(runtime)
  serial = runtime.nextMulticastSerial
  if runtime.nextUnicastSerial > serial then serial = runtime.nextUnicastSerial end if
  if runtime.nextSoundSerial > serial then serial = runtime.nextSoundSerial end if
  next = serial + 1
  runtime.nextMulticastSerial = next
  runtime.nextUnicastSerial = next
  runtime.nextSoundSerial = next
  return serial
end function

// Return the numeric value.
function numeric(value)
  return typeof(value) == "int" or typeof(value) == "float"
end function

// Return the copied origin.
function copiedOrigin(origin)
  if typeof(origin) != "struct" or not numeric(origin.x) or not numeric(origin.y) or not numeric(origin.z) then
    return error(3940, "multicast origin must be a Vec3")
  end if
  if origin.x != origin.x or origin.y != origin.y or origin.z != origin.z then
    return error(3941, "multicast origin must be finite")
  end if
  return sgmqtypes.Vec3(origin.x * 1.0, origin.y * 1.0, origin.z * 1.0)
end function

// Return the reliable destination value.
function reliableDestination(destination)
  return destination == sgmgc.MULTICAST_ALL_R or destination == sgmgc.MULTICAST_PHS_R or
    destination == sgmgc.MULTICAST_PVS_R
end function

// Return the base destination value.
function baseDestination(destination)
  if destination == sgmgc.MULTICAST_ALL or destination == sgmgc.MULTICAST_ALL_R then
    return sgmgc.MULTICAST_ALL
  end if
  if destination == sgmgc.MULTICAST_PHS or destination == sgmgc.MULTICAST_PHS_R then
    return sgmgc.MULTICAST_PHS
  end if
  if destination == sgmgc.MULTICAST_PVS or destination == sgmgc.MULTICAST_PVS_R then
    return sgmgc.MULTICAST_PVS
  end if
  return error(3942, "multicast destination outside Game API range")
end function

// Report whether queued bytes.
function queuedBytes(events)
  total = 0
  for each event in events
    if typeof(event) != "struct" or typeof(event.payload) != "bytes" then
      return error(3943, "pending multicast queue is malformed")
    end if
    total = total + len(event.payload)
  end for
  return total
end function

// Disable compatibility array views for the live server. Tests and component
// callers can retain the compact public arrays, while the product uses the
// fixed queues below and materializes one frame snapshot only when routing.
function enableOptimizedQueues(runtime)
  runtime.retainMessageViews = false
  runtime.pendingMulticasts = []
  runtime.pendingUnicasts = []
  return runtime
end function

// Copy the active multicast prefix for one routing transaction.
function pendingMulticastSnapshot(runtime)
  output = array(runtime.pendingMulticastCount)
  index = 0
  while index < runtime.pendingMulticastCount
    output[index] = runtime.multicastQueue[index]
    index = index + 1
  end while
  return output
end function

// Clear multicast queue state while retaining its fixed storage.
function clearMulticasts(runtime)
  // The active prefix is governed by the count; stale references are
  // overwritten on enqueue and never observed by routing.
  runtime.pendingMulticastCount = 0
  runtime.pendingMulticastBytes = 0
  if runtime.retainMessageViews then runtime.pendingMulticasts = [] end if
  return true
end function

// Restore multicast events after a failed atomic reliable routing attempt.
function restoreMulticasts(runtime, events)
  clearMulticasts(runtime)
  if typeof(events) != "array" then return error(3946, "pending multicast list must be an array") end if
  validateAll(events)
  for each event in events
    runtime.multicastQueue[runtime.pendingMulticastCount] = event
    runtime.pendingMulticastCount = runtime.pendingMulticastCount + 1
    runtime.pendingMulticastBytes = runtime.pendingMulticastBytes + len(event.payload)
  end for
  if runtime.retainMessageViews then runtime.pendingMulticasts = events end if
  return true
end function

// Validate event.
function validateEvent(event)
  if typeof(event) != "struct" or typeof(event.serial) != "int" or event.serial < 0 then
    return error(3943, "pending multicast event is malformed")
  end if
  baseDestination(event.destination)
  copiedOrigin(event.origin)
  if typeof(event.payload) != "bytes" or len(event.payload) <= 0 or
      len(event.payload) > MAX_MULTICAST_FRAGMENT_BYTES then
    return error(3944, "multicast payload outside one Protocol-34 packet")
  end if
  return true
end function

// Return the enqueue value.
function enqueue(runtime, origin, destination, payload)
  baseDestination(destination)
  ownedOrigin = copiedOrigin(origin)
  if typeof(payload) != "bytes" or len(payload) <= 0 or len(payload) > MAX_MULTICAST_FRAGMENT_BYTES then
    return error(3944, "multicast payload outside one Protocol-34 packet")
  end if
  if runtime.pendingMulticastCount >= MAX_PENDING_MULTICAST_EVENTS or
      runtime.pendingMulticastBytes + len(payload) > MAX_PENDING_MULTICAST_BYTES then
    // Stock unreliable datagrams are allowed to overflow and be discarded;
    // a visual burst must never tear down the server. Reliable GameImport
    // traffic remains failure-atomic because silently losing it would corrupt
    // client state.
    if not reliableDestination(destination) then return false end if
    return error(3945, "pending server multicast queue is full")
  end if
  ownedPayload = bytes(len(payload))
  payloadIndex = 0
  while payloadIndex < len(payload)
    ownedPayload[payloadIndex] = payload[payloadIndex]
    payloadIndex = payloadIndex + 1
  end while
  event = sgmtypes.PendingMulticastEvent(claimEmissionSerial(runtime),
    destination, ownedOrigin, ownedPayload)
  runtime.multicastQueue[runtime.pendingMulticastCount] = event
  runtime.pendingMulticastCount = runtime.pendingMulticastCount + 1
  runtime.pendingMulticastBytes = runtime.pendingMulticastBytes + len(ownedPayload)
  if runtime.retainMessageViews then
    runtime.pendingMulticasts = runtime.pendingMulticasts + [event]
  end if
  return event
end function

// Validate all.
function validateAll(events)
  if typeof(events) != "array" then return error(3946, "pending multicast list must be an array") end if
  previousSerial = -1
  total = 0
  for each event in events
    validateEvent(event)
    if event.serial <= previousSerial then return error(3947, "pending multicast ordering is malformed") end if
    total = total + len(event.payload)
    previousSerial = event.serial
  end for
  if len(events) > MAX_PENDING_MULTICAST_EVENTS or total > MAX_PENDING_MULTICAST_BYTES then
    return error(3945, "pending server multicast queue is full")
  end if
  return true
end function

// Return the unicast entity number.
function unicastEntityNumber(runtime, entity)
  if typeof(entity) != "struct" or typeof(entity.state) != "struct" or
      typeof(entity.state.number) != "int" or entity.state.number < 1 or
      entity.state.number > runtime.maxClients then
    return error(3948, "unicast target is not a client edict")
  end if
  return entity.state.number
end function

// Report whether queued unicast bytes.
function queuedUnicastBytes(events)
  total = 0
  for each event in events
    if typeof(event) != "struct" or typeof(event.payload) != "bytes" then
      return error(3949, "pending unicast queue is malformed")
    end if
    total = total + len(event.payload)
  end for
  return total
end function

// Copy the active unicast prefix for one routing transaction.
function pendingUnicastSnapshot(runtime)
  output = array(runtime.pendingUnicastCount)
  index = 0
  while index < runtime.pendingUnicastCount
    output[index] = runtime.unicastQueue[index]
    index = index + 1
  end while
  return output
end function

// Clear unicast queue state while retaining its fixed storage.
function clearUnicasts(runtime)
  // Retain storage and reset only the authoritative prefix counters.
  runtime.pendingUnicastCount = 0
  runtime.pendingUnicastBytes = 0
  if runtime.retainMessageViews then runtime.pendingUnicasts = [] end if
  return true
end function

// Restore unicast events after a failed atomic reliable routing attempt.
function restoreUnicasts(runtime, events)
  clearUnicasts(runtime)
  if typeof(events) != "array" then return error(3954, "pending unicast list must be an array") end if
  validateUnicastAll(events)
  for each event in events
    runtime.unicastQueue[runtime.pendingUnicastCount] = event
    runtime.pendingUnicastCount = runtime.pendingUnicastCount + 1
    runtime.pendingUnicastBytes = runtime.pendingUnicastBytes + len(event.payload)
  end for
  if runtime.retainMessageViews then runtime.pendingUnicasts = events end if
  return true
end function

// Copy payload data.
function copyPayload(payload)
  ownedPayload = bytes(len(payload))
  payloadIndex = 0
  while payloadIndex < len(payload)
    ownedPayload[payloadIndex] = payload[payloadIndex]
    payloadIndex = payloadIndex + 1
  end while
  return ownedPayload
end function

// Return the enqueue unicast value.
function enqueueUnicast(runtime, entity, reliable, payload)
  entityNumber = unicastEntityNumber(runtime, entity)
  if typeof(reliable) != "bool" then return error(3950, "unicast reliability must be boolean") end if
  if typeof(payload) != "bytes" or len(payload) <= 0 or len(payload) > MAX_MULTICAST_FRAGMENT_BYTES then
    return error(3951, "unicast payload outside one Protocol-34 packet")
  end if
  if runtime.pendingUnicastCount >= MAX_PENDING_UNICAST_EVENTS or
      runtime.pendingUnicastBytes + len(payload) > MAX_PENDING_UNICAST_BYTES then
    if not reliable then return false end if
    return error(3952, "pending server unicast queue is full")
  end if
  event = sgmtypes.PendingUnicastEvent(claimEmissionSerial(runtime), entityNumber,
    reliable, copyPayload(payload))
  runtime.unicastQueue[runtime.pendingUnicastCount] = event
  runtime.pendingUnicastCount = runtime.pendingUnicastCount + 1
  runtime.pendingUnicastBytes = runtime.pendingUnicastBytes + len(event.payload)
  if runtime.retainMessageViews then
    runtime.pendingUnicasts = runtime.pendingUnicasts + [event]
  end if
  return event
end function

// Validate unicast event.
function validateUnicastEvent(event)
  if typeof(event) != "struct" or typeof(event.serial) != "int" or event.serial < 0 or
      typeof(event.entity) != "int" or event.entity < 1 or typeof(event.reliable) != "bool" or
      typeof(event.payload) != "bytes" or len(event.payload) <= 0 or
      len(event.payload) > MAX_MULTICAST_FRAGMENT_BYTES then
    return error(3953, "pending unicast event is malformed")
  end if
  return true
end function

// Validate unicast all.
function validateUnicastAll(events)
  if typeof(events) != "array" then return error(3954, "pending unicast list must be an array") end if
  previousSerial = -1
  total = 0
  for each event in events
    validateUnicastEvent(event)
    if event.serial <= previousSerial then return error(3955, "pending unicast ordering is malformed") end if
    total = total + len(event.payload)
    previousSerial = event.serial
  end for
  if len(events) > MAX_PENDING_UNICAST_EVENTS or total > MAX_PENDING_UNICAST_BYTES then
    return error(3952, "pending server unicast queue is full")
  end if
  return true
end function
