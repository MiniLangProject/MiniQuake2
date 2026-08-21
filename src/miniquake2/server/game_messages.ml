/* Typed bounded GameImport multicast queue at the API-v3/Protocol-34 boundary. */
package miniquake2.server.game_messages

import miniquake2.qcommon.types as sgmqtypes
import miniquake2.protocol.constants as sgmpc
import miniquake2.game.constants as sgmgc
import miniquake2.server.types as sgmtypes

const MAX_PENDING_MULTICAST_EVENTS = 256
const MAX_PENDING_MULTICAST_BYTES = 88576
const MAX_MULTICAST_FRAGMENT_BYTES = 1392

function numeric(value)
  return typeof(value) == "int" or typeof(value) == "float"
end function

function copiedOrigin(origin)
  if typeof(origin) != "struct" or not numeric(origin.x) or not numeric(origin.y) or not numeric(origin.z) then
    return error(3940, "multicast origin must be a Vec3")
  end if
  if origin.x != origin.x or origin.y != origin.y or origin.z != origin.z then
    return error(3941, "multicast origin must be finite")
  end if
  return sgmqtypes.Vec3(origin.x * 1.0, origin.y * 1.0, origin.z * 1.0)
end function

function reliableDestination(destination)
  return destination == sgmgc.MULTICAST_ALL_R or destination == sgmgc.MULTICAST_PHS_R or
    destination == sgmgc.MULTICAST_PVS_R
end function

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

function enqueue(runtime, origin, destination, payload)
  baseDestination(destination)
  ownedOrigin = copiedOrigin(origin)
  if typeof(payload) != "bytes" or len(payload) <= 0 or len(payload) > MAX_MULTICAST_FRAGMENT_BYTES then
    return error(3944, "multicast payload outside one Protocol-34 packet")
  end if
  if len(runtime.pendingMulticasts) >= MAX_PENDING_MULTICAST_EVENTS or
      queuedBytes(runtime.pendingMulticasts) + len(payload) > MAX_PENDING_MULTICAST_BYTES then
    return error(3945, "pending server multicast queue is full")
  end if
  ownedPayload = bytes(len(payload))
  payloadIndex = 0
  while payloadIndex < len(payload)
    ownedPayload[payloadIndex] = payload[payloadIndex]
    payloadIndex = payloadIndex + 1
  end while
  event = sgmtypes.PendingMulticastEvent(runtime.nextMulticastSerial,
    destination, ownedOrigin, ownedPayload)
  runtime.pendingMulticasts = runtime.pendingMulticasts + [event]
  runtime.nextMulticastSerial = runtime.nextMulticastSerial + 1
  return event
end function

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
