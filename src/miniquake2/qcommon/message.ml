/*
Copyright (C) 1997-2001 Id Software, Inc.
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later

Quake II protocol-34 scalar message primitives.
*/
package miniquake2.qcommon.message

import miniquake2.qcommon.types as qt
import miniquake2.qcommon.byteio as bio
import miniquake2.qcommon.sizebuf as sz

// Require integer.
function requireInteger(value, operation)
  if typeof(value) != "int" then return error(2300, operation + ": integer argument required") end if
  return value
end function

// Write char.
function writeChar(buffer, value)
  integer = requireInteger(value, "MSG_WriteChar")
  offset = sz.getSpace(buffer, 1)
  bio.putI8(buffer.data, offset, integer)
  return buffer
end function

// Write byte.
function writeByte(buffer, value)
  integer = requireInteger(value, "MSG_WriteByte")
  offset = sz.getSpace(buffer, 1)
  bio.putU8(buffer.data, offset, integer)
  return buffer
end function

// Write short.
function writeShort(buffer, value)
  integer = requireInteger(value, "MSG_WriteShort")
  offset = sz.getSpace(buffer, 2)
  bio.putI16(buffer.data, offset, integer)
  return buffer
end function

// Write long.
function writeLong(buffer, value)
  integer = requireInteger(value, "MSG_WriteLong")
  offset = sz.getSpace(buffer, 4)
  bio.putI32(buffer.data, offset, integer)
  return buffer
end function

// Write float.
function writeFloat(buffer, value)
  bits = bio.float32Bits(value)
  offset = sz.getSpace(buffer, 4)
  bio.putU32(buffer.data, offset, bits)
  return buffer
end function

// Write string bytes.
function writeStringBytes(buffer, source)
  if typeof(source) != "bytes" then return error(2301, "MSG_WriteString requires bytes") end if
  count = 0
  while count < len(source) and source[count] != 0
    count = count + 1
  end while
  offset = sz.getSpace(buffer, count + 1)
  if count > 0 then bio.copyInto(buffer.data, offset, source, 0, count) end if
  buffer.data[offset + count] = 0
  return buffer
end function

// Write string.
function writeString(buffer, text)
  if typeof(text) != "string" then return error(2302, "MSG_WriteString requires a string") end if
  return writeStringBytes(buffer, bytes(text))
end function

// Write coord.
function writeCoord(buffer, value)
  return writeShort(buffer, bio.truncInt(value * 8.0))
end function

// Write pos.
function writePos(buffer, position)
  writeCoord(buffer, position.x)
  writeCoord(buffer, position.y)
  writeCoord(buffer, position.z)
  return buffer
end function

// Write angle.
function writeAngle(buffer, value)
  encoded = bio.truncInt(value * 256.0 / 360.0) & 255
  return writeByte(buffer, encoded)
end function

// Write angle 16.
function writeAngle16(buffer, value)
  encoded = bio.truncInt(value * 65536.0 / 360.0) & 0xffff
  return writeShort(buffer, encoded)
end function

// Begin reading.
function beginReading(buffer)
  buffer.readCount = 0
  return buffer
end function

// Read char.
function readChar(buffer)
  offset = buffer.readCount
  buffer.readCount = offset + 1
  if offset < 0 or offset + 1 > buffer.curSize then return -1 end if
  return bio.i8(buffer.data, offset)
end function

// Read byte.
function readByte(buffer)
  offset = buffer.readCount
  buffer.readCount = offset + 1
  if offset < 0 or offset + 1 > buffer.curSize then return -1 end if
  return bio.u8(buffer.data, offset)
end function

// Read short.
function readShort(buffer)
  offset = buffer.readCount
  buffer.readCount = offset + 2
  if offset < 0 or offset + 2 > buffer.curSize then return -1 end if
  return bio.i16(buffer.data, offset)
end function

// Read long.
function readLong(buffer)
  offset = buffer.readCount
  buffer.readCount = offset + 4
  if offset < 0 or offset + 4 > buffer.curSize then return -1 end if
  return bio.i32(buffer.data, offset)
end function

// Read float.
function readFloat(buffer)
  offset = buffer.readCount
  buffer.readCount = offset + 4
  if offset < 0 or offset + 4 > buffer.curSize then return -1.0 end if
  return bio.f32(buffer.data, offset)
end function

// Read string bytes.
function readStringBytes(buffer)
  start = buffer.readCount
  count = 0
  while count < 2047
    value = readChar(buffer)
    if value == -1 or value == 0 then break end if
    count = count + 1
  end while
  if count == 0 then return bytes() end if
  output = bytes(count)
  bio.copyInto(output, 0, buffer.data, start, count)
  return output
end function

// Read string.
function readString(buffer)
  return decode(readStringBytes(buffer))
end function

// Read string line bytes.
function readStringLineBytes(buffer)
  start = buffer.readCount
  count = 0
  while count < 2047
    value = readChar(buffer)
    if value == -1 or value == 0 or value == 10 then break end if
    count = count + 1
  end while
  if count == 0 then return bytes() end if
  output = bytes(count)
  bio.copyInto(output, 0, buffer.data, start, count)
  return output
end function

// Read string line.
function readStringLine(buffer)
  return decode(readStringLineBytes(buffer))
end function

// Read coord.
function readCoord(buffer)
  return readShort(buffer) * 0.125
end function

// Read pos.
function readPos(buffer)
  return qt.Vec3(readCoord(buffer), readCoord(buffer), readCoord(buffer))
end function

// Read angle.
function readAngle(buffer)
  return readChar(buffer) * (360.0 / 256.0)
end function

// Read angle 16.
function readAngle16(buffer)
  return readShort(buffer) * (360.0 / 65536.0)
end function

// Read data.
function readData(buffer, count)
  if typeof(count) != "int" or count < 0 then return error(2303, "MSG_ReadData requires a non-negative length") end if
  output = bytes(count)
  index = 0
  while index < count
    output[index] = readByte(buffer) & 255
    index = index + 1
  end while
  return output
end function

// Return the remaining value.
function remaining(buffer)
  return buffer.curSize - buffer.readCount
end function

// Write msg char.
function MSG_WriteChar(buffer, value)
  return writeChar(buffer, value)
end function

// Write msg byte.
function MSG_WriteByte(buffer, value)
  return writeByte(buffer, value)
end function

// Write msg short.
function MSG_WriteShort(buffer, value)
  return writeShort(buffer, value)
end function

// Write msg long.
function MSG_WriteLong(buffer, value)
  return writeLong(buffer, value)
end function

// Write msg float.
function MSG_WriteFloat(buffer, value)
  return writeFloat(buffer, value)
end function

// Write msg string.
function MSG_WriteString(buffer, text)
  return writeString(buffer, text)
end function

// Write msg coord.
function MSG_WriteCoord(buffer, value)
  return writeCoord(buffer, value)
end function

// Write msg pos.
function MSG_WritePos(buffer, position)
  return writePos(buffer, position)
end function

// Write msg angle.
function MSG_WriteAngle(buffer, value)
  return writeAngle(buffer, value)
end function

// Write msg angle 16.
function MSG_WriteAngle16(buffer, value)
  return writeAngle16(buffer, value)
end function

// Begin msg reading.
function MSG_BeginReading(buffer)
  return beginReading(buffer)
end function

// Read msg char.
function MSG_ReadChar(buffer)
  return readChar(buffer)
end function

// Read msg byte.
function MSG_ReadByte(buffer)
  return readByte(buffer)
end function

// Read msg short.
function MSG_ReadShort(buffer)
  return readShort(buffer)
end function

// Read msg long.
function MSG_ReadLong(buffer)
  return readLong(buffer)
end function

// Read msg float.
function MSG_ReadFloat(buffer)
  return readFloat(buffer)
end function

// Read msg string.
function MSG_ReadString(buffer)
  return readString(buffer)
end function

// Read msg string line.
function MSG_ReadStringLine(buffer)
  return readStringLine(buffer)
end function

// Read msg coord.
function MSG_ReadCoord(buffer)
  return readCoord(buffer)
end function

// Read msg pos.
function MSG_ReadPos(buffer)
  return readPos(buffer)
end function

// Read msg angle.
function MSG_ReadAngle(buffer)
  return readAngle(buffer)
end function

// Read msg angle 16.
function MSG_ReadAngle16(buffer)
  return readAngle16(buffer)
end function

// Read msg data.
function MSG_ReadData(buffer, count)
  return readData(buffer, count)
end function
