/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Explicit server and Game API bridge state. */
package miniquake2.server.types

struct ClientSlot
  state
  userInfo
  name
  rate
  messageLevel
  lastMessageTime
  edict
end struct

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

struct PendingMulticastEvent
  serial
  destination
  origin
  payload
end struct

struct PendingUnicastEvent
  serial
  entity
  reliable
  payload
end struct

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
end struct
