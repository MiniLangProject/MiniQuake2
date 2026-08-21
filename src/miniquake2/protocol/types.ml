/*
Copyright (C) 1997-2001 Id Software, Inc.
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later

Owned protocol state.  Arrays are copied explicitly by the codec modules so a
failed decode never aliases or partially modifies its baseline.
*/
package miniquake2.protocol.types

import miniquake2.qcommon.types as qt

struct EntityState
  number
  origin
  angles
  oldOrigin
  modelIndex
  modelIndex2
  modelIndex3
  modelIndex4
  frame
  skinNum
  effects
  renderFx
  solid
  sound
  event
end struct

struct PlayerState
  pmove
  viewAngles
  viewOffset
  kickAngles
  gunAngles
  gunOffset
  gunIndex
  gunFrame
  blend
  fov
  rdFlags
  stats
end struct

struct EntityDeltaHeader
  number
  bits
  remove
  endMarker
end struct

struct PacketHeader
  sequence
  reliable
  acknowledge
  reliableAcknowledged
  qport
  headerBytes
end struct

struct Packet
  header
  payload
end struct

struct ProcessedPacket
  accepted
  payload
  header
  dropped
  reason
end struct

struct NetChannel
  fatalError
  sock
  dropped
  lastReceived
  lastSent
  remoteAddress
  qport
  incomingSequence
  incomingAcknowledged
  incomingReliableAcknowledged
  incomingReliableSequence
  outgoingSequence
  reliableSequence
  lastReliableSequence
  firstReliableSequence
  message
  reliableLength
  reliableBuffer
  reliableQueue
  reliableQueuedBytes
end struct

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

function zeroEntityState()
  output = EntityState(0, void, void, void, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)
  output.origin = [0.0, 0.0, 0.0]
  output.angles = [0.0, 0.0, 0.0]
  output.oldOrigin = [0.0, 0.0, 0.0]
  return output
end function

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

function zeroPmoveState()
  output = qt.PmoveState(0, void, void, 0, 0, 0, void)
  output.origin = [0, 0, 0]
  output.velocity = [0, 0, 0]
  output.deltaAngles = [0, 0, 0]
  return output
end function

function copyPmoveState(state)
  output = qt.PmoveState(state.moveType, void, void,
    state.flags, state.time, state.gravity, void)
  output.origin = copyNumbers(state.origin, 3, "pmove origin")
  output.velocity = copyNumbers(state.velocity, 3, "pmove velocity")
  output.deltaAngles = copyNumbers(state.deltaAngles, 3, "pmove delta angles")
  return output
end function

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

function copyUserCmd(command)
  output = qt.UserCmd(command.msec, command.buttons, void, command.forwardMove,
    command.sideMove, command.upMove, command.impulse, command.lightLevel)
  output.angles = copyNumbers(command.angles, 3, "usercmd angles")
  return output
end function
