//! Provides miniquake2 protocol types facilities for this project.

/*
Copyright (C) 1997-2001 Id Software, Inc.
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later

Owned protocol state.  Arrays are copied explicitly by the codec modules so a
failed decode never aliases or partially modifies its baseline.
*/
package miniquake2.protocol.types

import miniquake2.qcommon.types as qt

/// Store entity state data.
struct EntityState
  /// Stores the number value associated with entity state.
  number
  /// Stores the origin value associated with entity state.
  origin
  /// Stores the angles value associated with entity state.
  angles
  /// Stores the old origin value associated with entity state.
  oldOrigin
  /// Stores the model index value associated with entity state.
  modelIndex
  /// Stores the model index2 value associated with entity state.
  modelIndex2
  /// Stores the model index3 value associated with entity state.
  modelIndex3
  /// Stores the model index4 value associated with entity state.
  modelIndex4
  /// Stores the frame value associated with entity state.
  frame
  /// Stores the skin num value associated with entity state.
  skinNum
  /// Stores the effects value associated with entity state.
  effects
  /// Stores the render fx value associated with entity state.
  renderFx
  /// Stores the solid value associated with entity state.
  solid
  /// Stores the sound value associated with entity state.
  sound
  /// Stores the event value associated with entity state.
  event
end struct

/// Store player state data.
struct PlayerState
  /// Stores the pmove value associated with player state.
  pmove
  /// Stores the view angles value associated with player state.
  viewAngles
  /// Stores the view offset value associated with player state.
  viewOffset
  /// Stores the kick angles value associated with player state.
  kickAngles
  /// Stores the gun angles value associated with player state.
  gunAngles
  /// Stores the gun offset value associated with player state.
  gunOffset
  /// Stores the gun index value associated with player state.
  gunIndex
  /// Stores the gun frame value associated with player state.
  gunFrame
  /// Stores the blend value associated with player state.
  blend
  /// Stores the fov value associated with player state.
  fov
  /// Stores the rd flags value associated with player state.
  rdFlags
  /// Stores the stats value associated with player state.
  stats
end struct

/// Store entity delta header data.
struct EntityDeltaHeader
  /// Stores the number value associated with entity delta header.
  number
  /// Stores the bits value associated with entity delta header.
  bits
  /// Stores the remove value associated with entity delta header.
  remove
  /// Stores the end marker value associated with entity delta header.
  endMarker
end struct

/// Store packet header data.
struct PacketHeader
  /// Stores the sequence value associated with packet header.
  sequence
  /// Stores the reliable value associated with packet header.
  reliable
  /// Stores the acknowledge value associated with packet header.
  acknowledge
  /// Stores the reliable acknowledged value associated with packet header.
  reliableAcknowledged
  /// Stores the qport value associated with packet header.
  qport
  /// Stores the header bytes value associated with packet header.
  headerBytes
end struct

/// Store packet data.
struct Packet
  /// Stores the header value associated with packet.
  header
  /// Stores the payload value associated with packet.
  payload
end struct

/// Store processed packet data.
struct ProcessedPacket
  /// Stores the accepted value associated with processed packet.
  accepted
  /// Stores the payload value associated with processed packet.
  payload
  /// Stores the header value associated with processed packet.
  header
  /// Stores the dropped value associated with processed packet.
  dropped
  /// Stores the reason value associated with processed packet.
  reason
end struct

/// Store net channel data.
struct NetChannel
  /// Stores the fatal error value associated with net channel.
  fatalError
  /// Stores the sock value associated with net channel.
  sock
  /// Stores the dropped value associated with net channel.
  dropped
  /// Stores the last received value associated with net channel.
  lastReceived
  /// Stores the last sent value associated with net channel.
  lastSent
  /// Stores the remote address value associated with net channel.
  remoteAddress
  /// Stores the qport value associated with net channel.
  qport
  /// Stores the incoming sequence value associated with net channel.
  incomingSequence
  /// Stores the incoming acknowledged value associated with net channel.
  incomingAcknowledged
  /// Stores the incoming reliable acknowledged value associated with net channel.
  incomingReliableAcknowledged
  /// Stores the incoming reliable sequence value associated with net channel.
  incomingReliableSequence
  /// Stores the outgoing sequence value associated with net channel.
  outgoingSequence
  /// Stores the reliable sequence value associated with net channel.
  reliableSequence
  /// Stores the last reliable sequence value associated with net channel.
  lastReliableSequence
  /// Stores the first reliable sequence value associated with net channel.
  firstReliableSequence
  /// Stores the message value associated with net channel.
  message
  /// Stores the reliable length value associated with net channel.
  reliableLength
  /// Stores the reliable buffer value associated with net channel.
  reliableBuffer
  /// Stores the reliable queue value associated with net channel.
  reliableQueue
  /// Stores the reliable queued bytes value associated with net channel.
  reliableQueuedBytes
end struct

/// Copy numbers data.
/// @param values values value consumed by this operation.
/// @param expected expected value consumed by this operation.
/// @param operation operation value consumed by this operation.
function copyNumbers(values, expected, operation)
  if typeof(values) != "array" or len(values) != expected then
    return error(7000, operation + ": invalid array length")
  end if
  output = array(expected, 0)
  index = 0
  while index < expected
    output[index] = values[index]
    index = index + 1
  end while
  return output
end function

/// Return the zero entity state.
function zeroEntityState()
  output = EntityState(0, void, void, void, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)
  output.origin = [0.0, 0.0, 0.0]
  output.angles = [0.0, 0.0, 0.0]
  output.oldOrigin = [0.0, 0.0, 0.0]
  return output
end function

/// Copy entity state.
/// @param state Mutable state inspected or updated by the operation.
function copyEntityState(state)
  output = EntityState(state.number, void, void, void,
    state.modelIndex, state.modelIndex2, state.modelIndex3, state.modelIndex4,
    state.frame, state.skinNum, state.effects, state.renderFx, state.solid,
    state.sound, state.event)
  output.origin = copyNumbers(state.origin, 3, "entity origin " + state.number)
  output.angles = copyNumbers(state.angles, 3, "entity angles " + state.number)
  output.oldOrigin = copyNumbers(state.oldOrigin, 3, "entity old origin " + state.number)
  return output
end function

/// Return the zero pmove state.
function zeroPmoveState()
  output = qt.PmoveState(0, void, void, 0, 0, 0, void)
  output.origin = [0, 0, 0]
  output.velocity = [0, 0, 0]
  output.deltaAngles = [0, 0, 0]
  return output
end function

/// Copy pmove state.
/// @param state Mutable state inspected or updated by the operation.
function copyPmoveState(state)
  output = qt.PmoveState(state.moveType, void, void,
    state.flags, state.time, state.gravity, void)
  output.origin = copyNumbers(state.origin, 3, "pmove origin")
  output.velocity = copyNumbers(state.velocity, 3, "pmove velocity")
  output.deltaAngles = copyNumbers(state.deltaAngles, 3, "pmove delta angles")
  return output
end function

/// Return the zero player state.
function zeroPlayerState()
  output = PlayerState(void, void, void, void, void, void,
    0, 0, void, 0.0, 0, void)
  output.pmove = zeroPmoveState()
  output.viewAngles = [0.0, 0.0, 0.0]
  output.viewOffset = [0.0, 0.0, 0.0]
  output.kickAngles = [0.0, 0.0, 0.0]
  output.gunAngles = [0.0, 0.0, 0.0]
  output.gunOffset = [0.0, 0.0, 0.0]
  output.blend = [0.0, 0.0, 0.0, 0.0]
  output.stats = array(32, 0)
  return output
end function

/// Copy player state.
/// @param state Mutable state inspected or updated by the operation.
function copyPlayerState(state)
  output = PlayerState(void, void, void, void, void, void,
    state.gunIndex, state.gunFrame, void, state.fov, state.rdFlags, void)
  output.pmove = copyPmoveState(state.pmove)
  output.viewAngles = copyNumbers(state.viewAngles, 3, "player view angles")
  output.viewOffset = copyNumbers(state.viewOffset, 3, "player view offset")
  output.kickAngles = copyNumbers(state.kickAngles, 3, "player kick angles")
  output.gunAngles = copyNumbers(state.gunAngles, 3, "player gun angles")
  output.gunOffset = copyNumbers(state.gunOffset, 3, "player gun offset")
  output.blend = copyNumbers(state.blend, 4, "player blend")
  output.stats = copyNumbers(state.stats, 32, "player stats")
  return output
end function

/// Copy user cmd.
/// @param command command value consumed by this operation.
function copyUserCmd(command)
  output = qt.UserCmd(command.msec, command.buttons, void, command.forwardMove,
    command.sideMove, command.upMove, command.impulse, command.lightLevel)
  output.angles = copyNumbers(command.angles, 3, "usercmd angles")
  return output
end function
