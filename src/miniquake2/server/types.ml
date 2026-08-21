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
  modelNames
  soundNames
  imageNames
  multicastBuffer
  pendingMulticasts
  nextMulticastSerial
  pendingUnicasts
  nextUnicastSerial
  pendingSounds
  nextSoundSerial
  logs
  cvars
  commands
  collision
  game
end struct
