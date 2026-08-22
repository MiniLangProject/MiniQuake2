/* Integrated Protocol-34 client message state and dispatch results. */
package miniquake2.client.runtime.types

struct Snapshot
  number
  deltaNumber
  suppressCount
  areaBits
  playerState
  entities
end struct

struct DispatchResult
  accepted
  sequence
  commands
  effectCommands
  frames
  reason
end struct

struct PrintHandoff
  level
  text
  time
  chat
end struct

struct CenterPrintHandoff
  text
  time
end struct

struct LayoutHandoff
  text
  time
end struct

struct InventoryHandoff
  values
  time
end struct

struct FrameHandoff
  serial
  frameNumber
  serverTime
  committedAt
  snapshot
  previousSnapshot
  configStrings
  dLights
  particles
  beams
  lasers
  explosions
  sustains
  sounds
  prints
  centerPrints
  layouts
  inventories
end struct

struct Runtime
  network
  client
  effects
  demo
  sequenceInitialized
  lastSequence
  replaySequence
  replayInitialized
  parsedPackets
  rejectedPackets
  prints
  centerPrints
  layouts
  inventories
  committedServerFrame
  handoffSerial
  frameHandoffs
  allowDemoProtocol26
end struct

function snapshot(frame)
  return Snapshot(frame.serverFrame, frame.deltaFrame, frame.suppressCount,
    frame.areaBits, frame.playerState, frame.entities)
end function

function result(accepted, sequence, commands, effectCommands, frames, reason)
  return DispatchResult(accepted, sequence, commands, effectCommands, frames, reason)
end function

function create(networkRuntime, clientState, effectState)
  return Runtime(networkRuntime, clientState, effectState, void, false, 0, 0,
    false, 0, 0, [], [], [], [], -1, 0, [], false)
end function
