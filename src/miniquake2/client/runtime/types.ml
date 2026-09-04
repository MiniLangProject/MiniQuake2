//! Provides miniquake2 client runtime types facilities for this project.

/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Integrated Protocol-34 client message state and dispatch results. */
package miniquake2.client.runtime.types

/// Store snapshot data.
struct Snapshot
  /// Stores the number value associated with snapshot.
  number
  /// Stores the delta number value associated with snapshot.
  deltaNumber
  /// Stores the suppress count value associated with snapshot.
  suppressCount
  /// Stores the area bits value associated with snapshot.
  areaBits
  /// Stores the player state value associated with snapshot.
  playerState
  /// Stores the entities value associated with snapshot.
  entities
end struct

/// Store dispatch result data.
struct DispatchResult
  /// Stores the accepted value associated with dispatch result.
  accepted
  /// Stores the sequence value associated with dispatch result.
  sequence
  /// Stores the commands value associated with dispatch result.
  commands
  /// Stores the effect commands value associated with dispatch result.
  effectCommands
  /// Stores the frames value associated with dispatch result.
  frames
  /// Stores the reason value associated with dispatch result.
  reason
end struct

/// Store print handoff data.
struct PrintHandoff
  /// Stores the level value associated with print handoff.
  level
  /// Stores the text value associated with print handoff.
  text
  /// Stores the time value associated with print handoff.
  time
  /// Stores the chat value associated with print handoff.
  chat
end struct

/// Store center print handoff data.
struct CenterPrintHandoff
  /// Stores the text value associated with center print handoff.
  text
  /// Stores the time value associated with center print handoff.
  time
end struct

/// Store layout handoff data.
struct LayoutHandoff
  /// Stores the text value associated with layout handoff.
  text
  /// Stores the time value associated with layout handoff.
  time
end struct

/// Store inventory handoff data.
struct InventoryHandoff
  /// Stores the values value associated with inventory handoff.
  values
  /// Stores the time value associated with inventory handoff.
  time
end struct

/// Store frame handoff data.
struct FrameHandoff
  /// Stores the serial value associated with frame handoff.
  serial
  /// Stores the frame number value associated with frame handoff.
  frameNumber
  /// Stores the server time value associated with frame handoff.
  serverTime
  /// Stores the committed at value associated with frame handoff.
  committedAt
  /// Stores the snapshot value associated with frame handoff.
  snapshot
  /// Stores the previous snapshot value associated with frame handoff.
  previousSnapshot
  /// Stores the config strings value associated with frame handoff.
  configStrings
  /// Stores the d lights value associated with frame handoff.
  dLights
  /// Stores the particles value associated with frame handoff.
  particles
  /// Stores the beams value associated with frame handoff.
  beams
  /// Stores the lasers value associated with frame handoff.
  lasers
  /// Stores the explosions value associated with frame handoff.
  explosions
  /// Stores the sustains value associated with frame handoff.
  sustains
  /// Stores the sounds value associated with frame handoff.
  sounds
  /// Stores the prints value associated with frame handoff.
  prints
  /// Stores the center prints value associated with frame handoff.
  centerPrints
  /// Stores the layouts value associated with frame handoff.
  layouts
  /// Stores the inventories value associated with frame handoff.
  inventories
end struct

/// Store runtime data.
struct Runtime
  /// Stores the network value associated with runtime.
  network
  /// Stores the client value associated with runtime.
  client
  /// Stores the effects value associated with runtime.
  effects
  /// Stores the demo value associated with runtime.
  demo
  /// Stores the sequence initialized value associated with runtime.
  sequenceInitialized
  /// Stores the last sequence value associated with runtime.
  lastSequence
  /// Stores the replay sequence value associated with runtime.
  replaySequence
  /// Stores the replay initialized value associated with runtime.
  replayInitialized
  /// Stores the parsed packets value associated with runtime.
  parsedPackets
  /// Stores the rejected packets value associated with runtime.
  rejectedPackets
  /// Stores the prints value associated with runtime.
  prints
  /// Stores the center prints value associated with runtime.
  centerPrints
  /// Stores the layouts value associated with runtime.
  layouts
  /// Stores the inventories value associated with runtime.
  inventories
  /// Stores the committed server frame value associated with runtime.
  committedServerFrame
  /// Stores the handoff serial value associated with runtime.
  handoffSerial
  /// Stores the frame handoffs value associated with runtime.
  frameHandoffs
  /// Stores the allow demo protocol26 value associated with runtime.
  allowDemoProtocol26
  /// Stores the downloads value associated with runtime.
  downloads
end struct

/// Return the snapshot value.
/// @param frame frame value consumed by this operation.
function snapshot(frame)
  return Snapshot(frame.serverFrame, frame.deltaFrame, frame.suppressCount,
    frame.areaBits, frame.playerState, frame.entities)
end function

/// Performs the result operation for the miniquake2 client runtime types module.
/// @param accepted accepted value consumed by this operation.
/// @param sequence sequence value consumed by this operation.
/// @param commands commands value consumed by this operation.
/// @param effectCommands effectCommands value consumed by this operation.
/// @param frames frames value consumed by this operation.
/// @param reason reason value consumed by this operation.
function result(accepted, sequence, commands, effectCommands, frames, reason)
  return DispatchResult(accepted, sequence, commands, effectCommands, frames, reason)
end function

/// Creates create for the miniquake2 client runtime types module.
/// @param networkRuntime networkRuntime value consumed by this operation.
/// @param clientState clientState value consumed by this operation.
/// @param effectState effectState value consumed by this operation.
function create(networkRuntime, clientState, effectState)
  return Runtime(networkRuntime, clientState, effectState, void, false, 0, 0,
    false, 0, 0, [], [], [], [], -1, 0, [], false, void)
end function
