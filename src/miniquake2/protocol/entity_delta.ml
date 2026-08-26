/*
Copyright (C) 1997-2001 Id Software, Inc.
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later

Protocol-34 entity_state_t delta writer and strict client-side parser.
*/
package miniquake2.protocol.entity_delta

import miniquake2.qcommon.message as qmsg
import miniquake2.protocol.constants as pc
import miniquake2.protocol.types as pt
import miniquake2.protocol.checked as pchecked

function validateState(state, operation)
  if len(state.origin) != 3 or len(state.angles) != 3 or len(state.oldOrigin) != 3 then
    return error(7030, operation + ": entity vectors must have three components")
  end if
  return true
end function

// Derive the exact Protocol-34 U_* mask before any bytes are emitted. Width
// extension flags are added by writeHeader, so callers can also use this mask
// to decide whether an unchanged entity may be omitted.
function computeBits(base, target, newEntity)
  validateState(base, "entity baseline")
  validateState(target, "entity target")
  if typeof(target.number) != "int" or target.number <= 0 or target.number >= pc.MAX_EDICTS then
    return error(7031, "entity number outside protocol-34 range")
  end if

  bits = 0
  if target.number >= 256 then bits = bits | pc.U_NUMBER16 end if
  if target.origin[0] != base.origin[0] then bits = bits | pc.U_ORIGIN1 end if
  if target.origin[1] != base.origin[1] then bits = bits | pc.U_ORIGIN2 end if
  if target.origin[2] != base.origin[2] then bits = bits | pc.U_ORIGIN3 end if
  if target.angles[0] != base.angles[0] then bits = bits | pc.U_ANGLE1 end if
  if target.angles[1] != base.angles[1] then bits = bits | pc.U_ANGLE2 end if
  if target.angles[2] != base.angles[2] then bits = bits | pc.U_ANGLE3 end if

  if target.skinNum != base.skinNum then
    unsignedSkin = target.skinNum & 0xffffffff
    if unsignedSkin < 256 then
      bits = bits | pc.U_SKIN8
    else if unsignedSkin < 0x10000 then
      bits = bits | pc.U_SKIN16
    else
      bits = bits | pc.U_SKIN8 | pc.U_SKIN16
    end if
  end if

  if target.frame != base.frame then
    if target.frame < 256 then bits = bits | pc.U_FRAME8 else bits = bits | pc.U_FRAME16 end if
  end if

  if target.effects != base.effects then
    unsignedEffects = target.effects & 0xffffffff
    if unsignedEffects < 256 then
      bits = bits | pc.U_EFFECTS8
    else if unsignedEffects < 0x8000 then
      bits = bits | pc.U_EFFECTS16
    else
      bits = bits | pc.U_EFFECTS8 | pc.U_EFFECTS16
    end if
  end if

  if target.renderFx != base.renderFx then
    if target.renderFx < 256 then
      bits = bits | pc.U_RENDERFX8
    else if target.renderFx < 0x8000 then
      bits = bits | pc.U_RENDERFX16
    else
      bits = bits | pc.U_RENDERFX8 | pc.U_RENDERFX16
    end if
  end if

  if target.solid != base.solid then bits = bits | pc.U_SOLID end if
  if target.event != 0 then bits = bits | pc.U_EVENT end if
  if target.modelIndex != base.modelIndex then bits = bits | pc.U_MODEL end if
  if target.modelIndex2 != base.modelIndex2 then bits = bits | pc.U_MODEL2 end if
  if target.modelIndex3 != base.modelIndex3 then bits = bits | pc.U_MODEL3 end if
  if target.modelIndex4 != base.modelIndex4 then bits = bits | pc.U_MODEL4 end if
  if target.sound != base.sound then bits = bits | pc.U_SOUND end if
  if newEntity or (target.renderFx & pc.RF_BEAM) != 0 then bits = bits | pc.U_OLDORIGIN end if
  return bits
end function

function addContinuationBits(bits)
  if (bits & 0xff000000) != 0 then
    return bits | pc.U_MOREBITS3 | pc.U_MOREBITS2 | pc.U_MOREBITS1
  end if
  if (bits & 0x00ff0000) != 0 then return bits | pc.U_MOREBITS2 | pc.U_MOREBITS1 end if
  if (bits & 0x0000ff00) != 0 then return bits | pc.U_MOREBITS1 end if
  return bits
end function

function writeHeader(buffer, number, rawBits)
  bits = addContinuationBits(rawBits)
  qmsg.writeByte(buffer, bits & 255)
  if (bits & 0xff000000) != 0 then
    qmsg.writeByte(buffer, (bits >> 8) & 255)
    qmsg.writeByte(buffer, (bits >> 16) & 255)
    qmsg.writeByte(buffer, (bits >> 24) & 255)
  else if (bits & 0x00ff0000) != 0 then
    qmsg.writeByte(buffer, (bits >> 8) & 255)
    qmsg.writeByte(buffer, (bits >> 16) & 255)
  else if (bits & 0x0000ff00) != 0 then
    qmsg.writeByte(buffer, (bits >> 8) & 255)
  end if
  if (bits & pc.U_NUMBER16) != 0 then qmsg.writeShort(buffer, number) else qmsg.writeByte(buffer, number) end if
  return bits
end function

// Emit fields in the original MSG_WriteDeltaEntity order; several flags share
// bytes, making this ordering part of the wire and demo compatibility contract.
function writeDelta(buffer, base, target, force, newEntity)
  rawBits = computeBits(base, target, newEntity)
  if rawBits == 0 and not force then return 0 end if
  bits = writeHeader(buffer, target.number, rawBits)

  if (bits & pc.U_MODEL) != 0 then qmsg.writeByte(buffer, target.modelIndex) end if
  if (bits & pc.U_MODEL2) != 0 then qmsg.writeByte(buffer, target.modelIndex2) end if
  if (bits & pc.U_MODEL3) != 0 then qmsg.writeByte(buffer, target.modelIndex3) end if
  if (bits & pc.U_MODEL4) != 0 then qmsg.writeByte(buffer, target.modelIndex4) end if
  if (bits & pc.U_FRAME8) != 0 then qmsg.writeByte(buffer, target.frame) end if
  if (bits & pc.U_FRAME16) != 0 then qmsg.writeShort(buffer, target.frame) end if

  if (bits & (pc.U_SKIN8 | pc.U_SKIN16)) == (pc.U_SKIN8 | pc.U_SKIN16) then
    qmsg.writeLong(buffer, target.skinNum)
  else if (bits & pc.U_SKIN8) != 0 then
    qmsg.writeByte(buffer, target.skinNum)
  else if (bits & pc.U_SKIN16) != 0 then
    qmsg.writeShort(buffer, target.skinNum)
  end if

  if (bits & (pc.U_EFFECTS8 | pc.U_EFFECTS16)) == (pc.U_EFFECTS8 | pc.U_EFFECTS16) then
    qmsg.writeLong(buffer, target.effects)
  else if (bits & pc.U_EFFECTS8) != 0 then
    qmsg.writeByte(buffer, target.effects)
  else if (bits & pc.U_EFFECTS16) != 0 then
    qmsg.writeShort(buffer, target.effects)
  end if

  if (bits & (pc.U_RENDERFX8 | pc.U_RENDERFX16)) == (pc.U_RENDERFX8 | pc.U_RENDERFX16) then
    qmsg.writeLong(buffer, target.renderFx)
  else if (bits & pc.U_RENDERFX8) != 0 then
    qmsg.writeByte(buffer, target.renderFx)
  else if (bits & pc.U_RENDERFX16) != 0 then
    qmsg.writeShort(buffer, target.renderFx)
  end if

  if (bits & pc.U_ORIGIN1) != 0 then qmsg.writeCoord(buffer, target.origin[0]) end if
  if (bits & pc.U_ORIGIN2) != 0 then qmsg.writeCoord(buffer, target.origin[1]) end if
  if (bits & pc.U_ORIGIN3) != 0 then qmsg.writeCoord(buffer, target.origin[2]) end if
  if (bits & pc.U_ANGLE1) != 0 then qmsg.writeAngle(buffer, target.angles[0]) end if
  if (bits & pc.U_ANGLE2) != 0 then qmsg.writeAngle(buffer, target.angles[1]) end if
  if (bits & pc.U_ANGLE3) != 0 then qmsg.writeAngle(buffer, target.angles[2]) end if
  if (bits & pc.U_OLDORIGIN) != 0 then
    qmsg.writeCoord(buffer, target.oldOrigin[0])
    qmsg.writeCoord(buffer, target.oldOrigin[1])
    qmsg.writeCoord(buffer, target.oldOrigin[2])
  end if
  if (bits & pc.U_SOUND) != 0 then qmsg.writeByte(buffer, target.sound) end if
  if (bits & pc.U_EVENT) != 0 then qmsg.writeByte(buffer, target.event) end if
  if (bits & pc.U_SOLID) != 0 then qmsg.writeShort(buffer, target.solid) end if
  return bits
end function

function writeRemoval(buffer, number)
  if typeof(number) != "int" or number <= 0 or number >= pc.MAX_EDICTS then return error(7032, "removed entity number outside protocol-34 range") end if
  bits = pc.U_REMOVE
  if number >= 256 then bits = bits | pc.U_NUMBER16 end if
  return writeHeader(buffer, number, bits)
end function

function writeEndMarker(buffer)
  qmsg.writeShort(buffer, 0)
  return buffer
end function

function readHeader(buffer)
  total = pchecked.readByte(buffer, "entity delta flags")
  if (total & pc.U_MOREBITS1) != 0 then total = total | (pchecked.readByte(buffer, "entity delta flags byte 2") << 8) end if
  if (total & pc.U_MOREBITS2) != 0 then total = total | (pchecked.readByte(buffer, "entity delta flags byte 3") << 16) end if
  if (total & pc.U_MOREBITS3) != 0 then total = total | (pchecked.readByte(buffer, "entity delta flags byte 4") << 24) end if
  if (total & ~pc.U_ALL) != 0 then return error(7033, "entity delta contains reserved protocol-34 flags") end if
  if (total & (pc.U_FRAME8 | pc.U_FRAME16)) == (pc.U_FRAME8 | pc.U_FRAME16) then
    return error(7039, "entity delta contains contradictory frame widths")
  end if
  number = 0
  if (total & pc.U_NUMBER16) != 0 then
    number = pchecked.readUShort(buffer, "entity number16")
  else
    number = pchecked.readByte(buffer, "entity number")
  end if
  if number >= pc.MAX_EDICTS then return error(7034, "entity delta number " + number + " exceeds MAX_EDICTS") end if
  endMarker = number == 0
  if endMarker and total != 0 then return error(7035, "entity end marker contains flags") end if
  structural = pc.U_REMOVE | pc.U_NUMBER16 | pc.U_MOREBITS1 | pc.U_MOREBITS2 | pc.U_MOREBITS3
  if (total & pc.U_REMOVE) != 0 and (total & ~structural) != 0 then
    return error(7039, "entity removal contains state payload flags")
  end if
  return pt.EntityDeltaHeader(number, total, (total & pc.U_REMOVE) != 0, endMarker)
end function

// Reconstruct a complete state from its baseline without retaining references
// to mutable baseline vectors. Checked reads keep malformed packets atomic.
function readDelta(buffer, base, header)
  if header.endMarker then return error(7036, "cannot decode an entity end marker as state") end if
  if header.remove then return error(7037, "cannot decode an entity removal as state") end if
  if header.number <= 0 or header.number >= pc.MAX_EDICTS then return error(7038, "invalid entity delta number") end if
  bits = header.bits
  if (bits & ~pc.U_ALL) != 0 then return error(7033, "entity delta contains reserved protocol-34 flags") end if
  if (bits & (pc.U_FRAME8 | pc.U_FRAME16)) == (pc.U_FRAME8 | pc.U_FRAME16) then return error(7039, "entity delta contains contradictory frame widths") end if
  target = pt.copyEntityState(base)
  target.oldOrigin[0] = base.origin[0]
  target.oldOrigin[1] = base.origin[1]
  target.oldOrigin[2] = base.origin[2]
  target.number = header.number

  if (bits & pc.U_MODEL) != 0 then target.modelIndex = pchecked.readByte(buffer, "entity model") end if
  if (bits & pc.U_MODEL2) != 0 then target.modelIndex2 = pchecked.readByte(buffer, "entity model2") end if
  if (bits & pc.U_MODEL3) != 0 then target.modelIndex3 = pchecked.readByte(buffer, "entity model3") end if
  if (bits & pc.U_MODEL4) != 0 then target.modelIndex4 = pchecked.readByte(buffer, "entity model4") end if
  if (bits & pc.U_FRAME8) != 0 then target.frame = pchecked.readByte(buffer, "entity frame8") end if
  if (bits & pc.U_FRAME16) != 0 then target.frame = pchecked.readShort(buffer, "entity frame16") end if

  if (bits & (pc.U_SKIN8 | pc.U_SKIN16)) == (pc.U_SKIN8 | pc.U_SKIN16) then
    target.skinNum = pchecked.readLong(buffer, "entity skin32")
  else if (bits & pc.U_SKIN8) != 0 then
    target.skinNum = pchecked.readByte(buffer, "entity skin8")
  else if (bits & pc.U_SKIN16) != 0 then
    target.skinNum = pchecked.readShort(buffer, "entity skin16")
  end if

  if (bits & (pc.U_EFFECTS8 | pc.U_EFFECTS16)) == (pc.U_EFFECTS8 | pc.U_EFFECTS16) then
    target.effects = pchecked.readULong(buffer, "entity effects32")
  else if (bits & pc.U_EFFECTS8) != 0 then
    target.effects = pchecked.readByte(buffer, "entity effects8")
  else if (bits & pc.U_EFFECTS16) != 0 then
    target.effects = pchecked.readShort(buffer, "entity effects16")
  end if

  if (bits & (pc.U_RENDERFX8 | pc.U_RENDERFX16)) == (pc.U_RENDERFX8 | pc.U_RENDERFX16) then
    target.renderFx = pchecked.readLong(buffer, "entity renderfx32")
  else if (bits & pc.U_RENDERFX8) != 0 then
    target.renderFx = pchecked.readByte(buffer, "entity renderfx8")
  else if (bits & pc.U_RENDERFX16) != 0 then
    target.renderFx = pchecked.readShort(buffer, "entity renderfx16")
  end if

  if (bits & pc.U_ORIGIN1) != 0 then target.origin[0] = pchecked.readCoord(buffer, "entity origin1") end if
  if (bits & pc.U_ORIGIN2) != 0 then target.origin[1] = pchecked.readCoord(buffer, "entity origin2") end if
  if (bits & pc.U_ORIGIN3) != 0 then target.origin[2] = pchecked.readCoord(buffer, "entity origin3") end if
  if (bits & pc.U_ANGLE1) != 0 then target.angles[0] = pchecked.readAngle(buffer, "entity angle1") end if
  if (bits & pc.U_ANGLE2) != 0 then target.angles[1] = pchecked.readAngle(buffer, "entity angle2") end if
  if (bits & pc.U_ANGLE3) != 0 then target.angles[2] = pchecked.readAngle(buffer, "entity angle3") end if
  if (bits & pc.U_OLDORIGIN) != 0 then
    target.oldOrigin[0] = pchecked.readCoord(buffer, "entity old origin1")
    target.oldOrigin[1] = pchecked.readCoord(buffer, "entity old origin2")
    target.oldOrigin[2] = pchecked.readCoord(buffer, "entity old origin3")
  end if
  if (bits & pc.U_SOUND) != 0 then target.sound = pchecked.readByte(buffer, "entity sound") end if
  if (bits & pc.U_EVENT) != 0 then target.event = pchecked.readByte(buffer, "entity event") else target.event = 0 end if
  if (bits & pc.U_SOLID) != 0 then target.solid = pchecked.readShort(buffer, "entity solid") end if
  return target
end function

function MSG_WriteDeltaEntity(base, target, buffer, force, newEntity)
  return writeDelta(buffer, base, target, force, newEntity)
end function
