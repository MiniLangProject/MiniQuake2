//! Provides miniquake2 server types facilities for this project.

/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Explicit server and Game API bridge state. */
package miniquake2.server.types

/// Store client slot data.
struct ClientSlot
  /// Stores the state value associated with client slot.
  state
  /// Stores the user info value associated with client slot.
  userInfo
  /// Stores the name value associated with client slot.
  name
  /// Stores the rate value associated with client slot.
  rate
  /// Stores the message level value associated with client slot.
  messageLevel
  /// Stores the last message time value associated with client slot.
  lastMessageTime
  /// Stores the edict value associated with client slot.
  edict
end struct

/// Store pending sound event data.
struct PendingSoundEvent
  /// Stores the serial value associated with pending sound event.
  serial
  /// Indicates whether has entity is active for the pending sound event value.
  hasEntity
  /// Stores the entity value associated with pending sound event.
  entity
  /// Stores the channel value associated with pending sound event.
  channel
  /// Stores the channel flags value associated with pending sound event.
  channelFlags
  /// Stores the sound index value associated with pending sound event.
  soundIndex
  /// Stores the volume value associated with pending sound event.
  volume
  /// Stores the attenuation value associated with pending sound event.
  attenuation
  /// Stores the time offset value associated with pending sound event.
  timeOffset
  /// Stores the position value associated with pending sound event.
  position
  /// Stores the routing position value associated with pending sound event.
  routingPosition
end struct

/// Store pending multicast event data.
struct PendingMulticastEvent
  /// Stores the serial value associated with pending multicast event.
  serial
  /// Stores the destination value associated with pending multicast event.
  destination
  /// Stores the origin value associated with pending multicast event.
  origin
  /// Stores the payload value associated with pending multicast event.
  payload
end struct

/// Store pending unicast event data.
struct PendingUnicastEvent
  /// Stores the serial value associated with pending unicast event.
  serial
  /// Stores the entity value associated with pending unicast event.
  entity
  /// Stores the reliable value associated with pending unicast event.
  reliable
  /// Stores the payload value associated with pending unicast event.
  payload
end struct

/// Store server runtime data.
struct ServerRuntime
  /// Stores the state value associated with server runtime.
  state
  /// Stores the map name value associated with server runtime.
  mapName
  /// Stores the spawn count value associated with server runtime.
  spawnCount
  /// Stores the time milliseconds value associated with server runtime.
  timeMilliseconds
  /// Stores the frame number value associated with server runtime.
  frameNumber
  /// Stores the max clients value associated with server runtime.
  maxClients
  /// Stores the clients value associated with server runtime.
  clients
  /// Stores the config strings value associated with server runtime.
  configStrings
  /// Stores the config string dirty value associated with server runtime.
  configStringDirty
  /// Stores the model names value associated with server runtime.
  modelNames
  /// Stores the sound names value associated with server runtime.
  soundNames
  /// Stores the image names value associated with server runtime.
  imageNames
  /// Stores the multicast buffer value associated with server runtime.
  multicastBuffer
  /// Stores the multicast queue value associated with server runtime.
  multicastQueue
  /// Stores the pending multicast count value associated with server runtime.
  pendingMulticastCount
  /// Stores the pending multicast bytes value associated with server runtime.
  pendingMulticastBytes
  /// Stores the pending multicasts value associated with server runtime.
  pendingMulticasts
  /// Stores the next multicast serial value associated with server runtime.
  nextMulticastSerial
  /// Stores the unicast queue value associated with server runtime.
  unicastQueue
  /// Stores the pending unicast count value associated with server runtime.
  pendingUnicastCount
  /// Stores the pending unicast bytes value associated with server runtime.
  pendingUnicastBytes
  /// Stores the pending unicasts value associated with server runtime.
  pendingUnicasts
  /// Stores the next unicast serial value associated with server runtime.
  nextUnicastSerial
  /// Stores the retain message views value associated with server runtime.
  retainMessageViews
  /// Stores the pending sounds value associated with server runtime.
  pendingSounds
  /// Stores the pending sound count value associated with server runtime.
  pendingSoundCount
  /// Stores the next sound serial value associated with server runtime.
  nextSoundSerial
  /// Stores the logs value associated with server runtime.
  logs
  /// Stores the cvars value associated with server runtime.
  cvars
  /// Stores the commands value associated with server runtime.
  commands
  /// Stores the collision value associated with server runtime.
  collision
  /// Stores the game value associated with server runtime.
  game
  /// Stores the inline brushes value associated with server runtime.
  inlineBrushes
  /// Stores the inline brush count value associated with server runtime.
  inlineBrushCount
  /// Stores the inline brush positions value associated with server runtime.
  inlineBrushPositions
  /// Stores the inline brush model numbers value associated with server runtime.
  inlineBrushModelNumbers
  /// Stores the trigger edicts value associated with server runtime.
  triggerEdicts
  /// Stores the trigger positions value associated with server runtime.
  triggerPositions
  /// Stores the trigger count value associated with server runtime.
  triggerCount
  /// Stores the solid box edicts value associated with server runtime.
  solidBoxEdicts
  /// Stores the solid box positions value associated with server runtime.
  solidBoxPositions
  /// Stores the solid box count value associated with server runtime.
  solidBoxCount
end struct
