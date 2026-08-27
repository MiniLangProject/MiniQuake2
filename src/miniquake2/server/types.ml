/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Explicit server and Game API bridge state. */
package miniquake2.server.types

// Store client slot data.
struct ClientSlot
  state
  userInfo
  name
  rate
  messageLevel
  lastMessageTime
  edict
end struct

// Store pending sound event data.
struct PendingSoundEvent
  serial
  hasEntity
  entity
  channel
  channelFlags
  soundIndex
  volume
  attenuation
  timeOffset
  position
end struct

// Store pending multicast event data.
struct PendingMulticastEvent
  serial
  destination
  origin
  payload
end struct

// Store pending unicast event data.
struct PendingUnicastEvent
  serial
  entity
  reliable
  payload
end struct

// Store server runtime data.
struct ServerRuntime
  state
  mapName
  spawnCount
  timeMilliseconds
  frameNumber
  maxClients
  clients
  configStrings
  configStringDirty
  modelNames
  soundNames
  imageNames
  multicastBuffer
  pendingMulticasts
  nextMulticastSerial
  pendingUnicasts
  nextUnicastSerial
  pendingSounds
  pendingSoundCount
  nextSoundSerial
  logs
  cvars
  commands
  collision
  game
  inlineBrushes
  inlineBrushCount
  inlineBrushPositions
  inlineBrushModelNumbers
  triggerEdicts
  triggerPositions
  triggerCount
  solidBoxEdicts
  solidBoxPositions
  solidBoxCount
end struct
