/*
Copyright (C) 1997-2001 Id Software, Inc.
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later

Bit-exact MSG_WriteDeltaUsercmd / MSG_ReadDeltaUsercmd port.
*/
package miniquake2.protocol.usercmd

import miniquake2.qcommon.message as qmsg
import miniquake2.protocol.constants as pc
import miniquake2.protocol.types as pt
import miniquake2.protocol.checked as pchecked

// Write delta.
function writeDelta(buffer, base, command)
  if len(base.angles) != 3 or len(command.angles) != 3 then return error(7020, "usercmd angles must contain three shorts") end if
  bits = 0
  if command.angles[0] != base.angles[0] then bits = bits | pc.CM_ANGLE1 end if
  if command.angles[1] != base.angles[1] then bits = bits | pc.CM_ANGLE2 end if
  if command.angles[2] != base.angles[2] then bits = bits | pc.CM_ANGLE3 end if
  if command.forwardMove != base.forwardMove then bits = bits | pc.CM_FORWARD end if
  if command.sideMove != base.sideMove then bits = bits | pc.CM_SIDE end if
  if command.upMove != base.upMove then bits = bits | pc.CM_UP end if
  if command.buttons != base.buttons then bits = bits | pc.CM_BUTTONS end if
  if command.impulse != base.impulse then bits = bits | pc.CM_IMPULSE end if

  qmsg.writeByte(buffer, bits)
  if (bits & pc.CM_ANGLE1) != 0 then qmsg.writeShort(buffer, command.angles[0]) end if
  if (bits & pc.CM_ANGLE2) != 0 then qmsg.writeShort(buffer, command.angles[1]) end if
  if (bits & pc.CM_ANGLE3) != 0 then qmsg.writeShort(buffer, command.angles[2]) end if
  if (bits & pc.CM_FORWARD) != 0 then qmsg.writeShort(buffer, command.forwardMove) end if
  if (bits & pc.CM_SIDE) != 0 then qmsg.writeShort(buffer, command.sideMove) end if
  if (bits & pc.CM_UP) != 0 then qmsg.writeShort(buffer, command.upMove) end if
  if (bits & pc.CM_BUTTONS) != 0 then qmsg.writeByte(buffer, command.buttons) end if
  if (bits & pc.CM_IMPULSE) != 0 then qmsg.writeByte(buffer, command.impulse) end if
  qmsg.writeByte(buffer, command.msec)
  qmsg.writeByte(buffer, command.lightLevel)
  return bits
end function

// Read delta.
function readDelta(buffer, base)
  command = pt.copyUserCmd(base)
  bits = pchecked.readByte(buffer, "usercmd flags")
  if (bits & pc.CM_ANGLE1) != 0 then command.angles[0] = pchecked.readShort(buffer, "usercmd angle 1") end if
  if (bits & pc.CM_ANGLE2) != 0 then command.angles[1] = pchecked.readShort(buffer, "usercmd angle 2") end if
  if (bits & pc.CM_ANGLE3) != 0 then command.angles[2] = pchecked.readShort(buffer, "usercmd angle 3") end if
  if (bits & pc.CM_FORWARD) != 0 then command.forwardMove = pchecked.readShort(buffer, "usercmd forward") end if
  if (bits & pc.CM_SIDE) != 0 then command.sideMove = pchecked.readShort(buffer, "usercmd side") end if
  if (bits & pc.CM_UP) != 0 then command.upMove = pchecked.readShort(buffer, "usercmd up") end if
  if (bits & pc.CM_BUTTONS) != 0 then command.buttons = pchecked.readByte(buffer, "usercmd buttons") end if
  if (bits & pc.CM_IMPULSE) != 0 then command.impulse = pchecked.readByte(buffer, "usercmd impulse") end if
  command.msec = pchecked.readByte(buffer, "usercmd msec")
  command.lightLevel = pchecked.readByte(buffer, "usercmd light level")
  return command
end function

// Write msg delta usercmd.
function MSG_WriteDeltaUsercmd(buffer, base, command)
  return writeDelta(buffer, base, command)
end function

// Read msg delta usercmd.
function MSG_ReadDeltaUsercmd(buffer, base)
  return readDelta(buffer, base)
end function
