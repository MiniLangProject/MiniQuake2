/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Integrated Protocol-34 client message state and dispatch results. */
package miniquake2.client.runtime.types

// Store snapshot data.
struct Snapshot
  number
  deltaNumber
  suppressCount
  areaBits
  playerState
  entities
end struct

// Store dispatch result data.
struct DispatchResult
  accepted
  sequence
  commands
  effectCommands
  frames
  reason
end struct

// Store print handoff data.
struct PrintHandoff
  level
  text
  time
  chat
end struct

// Store center print handoff data.
struct CenterPrintHandoff
  text
  time
end struct

// Store layout handoff data.
struct LayoutHandoff
  text
  time
end struct

// Store inventory handoff data.
struct InventoryHandoff
  values
  time
end struct

// Store frame handoff data.
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

// Store runtime data.
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
  downloads
end struct

// Return the snapshot value.
function snapshot(frame)
  return Snapshot(frame.serverFrame, frame.deltaFrame, frame.suppressCount,
    frame.areaBits, frame.playerState, frame.entities)
end function

// Return the result value.
function result(accepted, sequence, commands, effectCommands, frames, reason)
  return DispatchResult(accepted, sequence, commands, effectCommands, frames, reason)
end function

// Create state.
function create(networkRuntime, clientState, effectState)
  return Runtime(networkRuntime, clientState, effectState, void, false, 0, 0,
    false, 0, 0, [], [], [], [], -1, 0, [], false, void)
end function
