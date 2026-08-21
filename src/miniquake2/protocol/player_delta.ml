/*
Copyright (C) 1997-2001 Id Software, Inc.
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later

SV_WritePlayerstateToClient and CL_ParsePlayerstate wire-compatible body codepc.
*/
package miniquake2.protocol.player_delta

import miniquake2.qcommon.byteio as qbio
import miniquake2.qcommon.message as qmsg
import miniquake2.protocol.constants as pc
import miniquake2.protocol.types as pt
import miniquake2.protocol.checked as pchecked

function validateState(state, operation)
  if len(state.pmove.origin) != 3 or len(state.pmove.velocity) != 3 or len(state.pmove.deltaAngles) != 3 then
    return error(7040, operation + ": malformed pmove vectors")
  end if
  if len(state.viewAngles) != 3 or len(state.viewOffset) != 3 or len(state.kickAngles) != 3 then
    return error(7041, operation + ": malformed view vectors")
  end if
  if len(state.gunAngles) != 3 or len(state.gunOffset) != 3 or len(state.blend) != 4 then
    return error(7042, operation + ": malformed render vectors")
  end if
  if len(state.stats) != pc.MAX_STATS then return error(7043, operation + ": stats must contain 32 shorts") end if
  return true
end function

function vec3Changed(a, b)
  return a[0] != b[0] or a[1] != b[1] or a[2] != b[2]
end function

function vec4Changed(a, b)
  return a[0] != b[0] or a[1] != b[1] or a[2] != b[2] or a[3] != b[3]
end function

function computeFlags(base, target)
  validateState(base, "player baseline")
  validateState(target, "player target")
  flags = pc.PS_WEAPONINDEX
  if target.pmove.moveType != base.pmove.moveType then flags = flags | pc.PS_M_TYPE end if
  if vec3Changed(target.pmove.origin, base.pmove.origin) then flags = flags | pc.PS_M_ORIGIN end if
  if vec3Changed(target.pmove.velocity, base.pmove.velocity) then flags = flags | pc.PS_M_VELOCITY end if
  if target.pmove.time != base.pmove.time then flags = flags | pc.PS_M_TIME end if
  if target.pmove.flags != base.pmove.flags then flags = flags | pc.PS_M_FLAGS end if
  if target.pmove.gravity != base.pmove.gravity then flags = flags | pc.PS_M_GRAVITY end if
  if vec3Changed(target.pmove.deltaAngles, base.pmove.deltaAngles) then flags = flags | pc.PS_M_DELTA_ANGLES end if
  if vec3Changed(target.viewOffset, base.viewOffset) then flags = flags | pc.PS_VIEWOFFSET end if
  if vec3Changed(target.viewAngles, base.viewAngles) then flags = flags | pc.PS_VIEWANGLES end if
  if vec3Changed(target.kickAngles, base.kickAngles) then flags = flags | pc.PS_KICKANGLES end if
  if vec4Changed(target.blend, base.blend) then flags = flags | pc.PS_BLEND end if
  if target.fov != base.fov then flags = flags | pc.PS_FOV end if
  if target.rdFlags != base.rdFlags then flags = flags | pc.PS_RDFLAGS end if
  if target.gunFrame != base.gunFrame then flags = flags | pc.PS_WEAPONFRAME end if
  return flags
end function

function writeBody(buffer, base, target)
  flags = computeFlags(base, target)
  qmsg.writeShort(buffer, flags)
  if (flags & pc.PS_M_TYPE) != 0 then qmsg.writeByte(buffer, target.pmove.moveType) end if
  if (flags & pc.PS_M_ORIGIN) != 0 then
    qmsg.writeShort(buffer, target.pmove.origin[0]); qmsg.writeShort(buffer, target.pmove.origin[1]); qmsg.writeShort(buffer, target.pmove.origin[2])
  end if
  if (flags & pc.PS_M_VELOCITY) != 0 then
    qmsg.writeShort(buffer, target.pmove.velocity[0]); qmsg.writeShort(buffer, target.pmove.velocity[1]); qmsg.writeShort(buffer, target.pmove.velocity[2])
  end if
  if (flags & pc.PS_M_TIME) != 0 then qmsg.writeByte(buffer, target.pmove.time) end if
  if (flags & pc.PS_M_FLAGS) != 0 then qmsg.writeByte(buffer, target.pmove.flags) end if
  if (flags & pc.PS_M_GRAVITY) != 0 then qmsg.writeShort(buffer, target.pmove.gravity) end if
  if (flags & pc.PS_M_DELTA_ANGLES) != 0 then
    qmsg.writeShort(buffer, target.pmove.deltaAngles[0]); qmsg.writeShort(buffer, target.pmove.deltaAngles[1]); qmsg.writeShort(buffer, target.pmove.deltaAngles[2])
  end if
  if (flags & pc.PS_VIEWOFFSET) != 0 then
    qmsg.writeChar(buffer, qbio.truncInt(target.viewOffset[0] * 4.0)); qmsg.writeChar(buffer, qbio.truncInt(target.viewOffset[1] * 4.0)); qmsg.writeChar(buffer, qbio.truncInt(target.viewOffset[2] * 4.0))
  end if
  if (flags & pc.PS_VIEWANGLES) != 0 then
    qmsg.writeAngle16(buffer, target.viewAngles[0]); qmsg.writeAngle16(buffer, target.viewAngles[1]); qmsg.writeAngle16(buffer, target.viewAngles[2])
  end if
  if (flags & pc.PS_KICKANGLES) != 0 then
    qmsg.writeChar(buffer, qbio.truncInt(target.kickAngles[0] * 4.0)); qmsg.writeChar(buffer, qbio.truncInt(target.kickAngles[1] * 4.0)); qmsg.writeChar(buffer, qbio.truncInt(target.kickAngles[2] * 4.0))
  end if
  if (flags & pc.PS_WEAPONINDEX) != 0 then qmsg.writeByte(buffer, target.gunIndex) end if
  if (flags & pc.PS_WEAPONFRAME) != 0 then
    qmsg.writeByte(buffer, target.gunFrame)
    qmsg.writeChar(buffer, qbio.truncInt(target.gunOffset[0] * 4.0)); qmsg.writeChar(buffer, qbio.truncInt(target.gunOffset[1] * 4.0)); qmsg.writeChar(buffer, qbio.truncInt(target.gunOffset[2] * 4.0))
    qmsg.writeChar(buffer, qbio.truncInt(target.gunAngles[0] * 4.0)); qmsg.writeChar(buffer, qbio.truncInt(target.gunAngles[1] * 4.0)); qmsg.writeChar(buffer, qbio.truncInt(target.gunAngles[2] * 4.0))
  end if
  if (flags & pc.PS_BLEND) != 0 then
    qmsg.writeByte(buffer, qbio.truncInt(target.blend[0] * 255.0)); qmsg.writeByte(buffer, qbio.truncInt(target.blend[1] * 255.0))
    qmsg.writeByte(buffer, qbio.truncInt(target.blend[2] * 255.0)); qmsg.writeByte(buffer, qbio.truncInt(target.blend[3] * 255.0))
  end if
  if (flags & pc.PS_FOV) != 0 then qmsg.writeByte(buffer, qbio.truncInt(target.fov)) end if
  if (flags & pc.PS_RDFLAGS) != 0 then qmsg.writeByte(buffer, target.rdFlags) end if

  statBits = 0
  index = 0
  while index < pc.MAX_STATS
    if target.stats[index] != base.stats[index] then statBits = statBits | (1 << index) end if
    index = index + 1
  end while
  qmsg.writeLong(buffer, statBits)
  index = 0
  while index < pc.MAX_STATS
    if (statBits & (1 << index)) != 0 then qmsg.writeShort(buffer, target.stats[index]) end if
    index = index + 1
  end while
  return flags
end function

function writeMessage(buffer, base, target)
  qmsg.writeByte(buffer, pc.SVC_PLAYERINFO)
  return writeBody(buffer, base, target)
end function

function readBody(buffer, base)
  target = pt.copyPlayerState(base)
  flags = pchecked.readUShort(buffer, "player delta flags")
  if (flags & ~pc.PS_ALL) != 0 then return error(7044, "player delta contains reserved flags") end if
  if (flags & pc.PS_M_TYPE) != 0 then target.pmove.moveType = pchecked.readByte(buffer, "player pm_type") end if
  if (flags & pc.PS_M_ORIGIN) != 0 then
    target.pmove.origin[0] = pchecked.readShort(buffer, "player origin1"); target.pmove.origin[1] = pchecked.readShort(buffer, "player origin2"); target.pmove.origin[2] = pchecked.readShort(buffer, "player origin3")
  end if
  if (flags & pc.PS_M_VELOCITY) != 0 then
    target.pmove.velocity[0] = pchecked.readShort(buffer, "player velocity1"); target.pmove.velocity[1] = pchecked.readShort(buffer, "player velocity2"); target.pmove.velocity[2] = pchecked.readShort(buffer, "player velocity3")
  end if
  if (flags & pc.PS_M_TIME) != 0 then target.pmove.time = pchecked.readByte(buffer, "player pm_time") end if
  if (flags & pc.PS_M_FLAGS) != 0 then target.pmove.flags = pchecked.readByte(buffer, "player pm_flags") end if
  if (flags & pc.PS_M_GRAVITY) != 0 then target.pmove.gravity = pchecked.readShort(buffer, "player gravity") end if
  if (flags & pc.PS_M_DELTA_ANGLES) != 0 then
    target.pmove.deltaAngles[0] = pchecked.readShort(buffer, "player delta angle1"); target.pmove.deltaAngles[1] = pchecked.readShort(buffer, "player delta angle2"); target.pmove.deltaAngles[2] = pchecked.readShort(buffer, "player delta angle3")
  end if
  if (flags & pc.PS_VIEWOFFSET) != 0 then
    target.viewOffset[0] = pchecked.readChar(buffer, "player view offset1") * 0.25; target.viewOffset[1] = pchecked.readChar(buffer, "player view offset2") * 0.25; target.viewOffset[2] = pchecked.readChar(buffer, "player view offset3") * 0.25
  end if
  if (flags & pc.PS_VIEWANGLES) != 0 then
    target.viewAngles[0] = pchecked.readAngle16(buffer, "player view angle1"); target.viewAngles[1] = pchecked.readAngle16(buffer, "player view angle2"); target.viewAngles[2] = pchecked.readAngle16(buffer, "player view angle3")
  end if
  if (flags & pc.PS_KICKANGLES) != 0 then
    target.kickAngles[0] = pchecked.readChar(buffer, "player kick angle1") * 0.25; target.kickAngles[1] = pchecked.readChar(buffer, "player kick angle2") * 0.25; target.kickAngles[2] = pchecked.readChar(buffer, "player kick angle3") * 0.25
  end if
  if (flags & pc.PS_WEAPONINDEX) != 0 then target.gunIndex = pchecked.readByte(buffer, "player gun index") end if
  if (flags & pc.PS_WEAPONFRAME) != 0 then
    target.gunFrame = pchecked.readByte(buffer, "player gun frame")
    target.gunOffset[0] = pchecked.readChar(buffer, "player gun offset1") * 0.25; target.gunOffset[1] = pchecked.readChar(buffer, "player gun offset2") * 0.25; target.gunOffset[2] = pchecked.readChar(buffer, "player gun offset3") * 0.25
    target.gunAngles[0] = pchecked.readChar(buffer, "player gun angle1") * 0.25; target.gunAngles[1] = pchecked.readChar(buffer, "player gun angle2") * 0.25; target.gunAngles[2] = pchecked.readChar(buffer, "player gun angle3") * 0.25
  end if
  if (flags & pc.PS_BLEND) != 0 then
    target.blend[0] = pchecked.readByte(buffer, "player blend r") / 255.0; target.blend[1] = pchecked.readByte(buffer, "player blend g") / 255.0
    target.blend[2] = pchecked.readByte(buffer, "player blend b") / 255.0; target.blend[3] = pchecked.readByte(buffer, "player blend a") / 255.0
  end if
  if (flags & pc.PS_FOV) != 0 then target.fov = pchecked.readByte(buffer, "player fov") * 1.0 end if
  if (flags & pc.PS_RDFLAGS) != 0 then target.rdFlags = pchecked.readByte(buffer, "player rdflags") end if

  statBits = pchecked.readLong(buffer, "player stat bits")
  index = 0
  while index < pc.MAX_STATS
    if (statBits & (1 << index)) != 0 then target.stats[index] = pchecked.readShort(buffer, "player stat") end if
    index = index + 1
  end while
  return target
end function

function readMessage(buffer, base)
  opcode = pchecked.readByte(buffer, "playerinfo opcode")
  if opcode != pc.SVC_PLAYERINFO then return error(7045, "expected svc_playerinfo") end if
  return readBody(buffer, base)
end function
