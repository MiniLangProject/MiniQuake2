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

function requireInteger(value, operation)
  if typeof(value) != "int" then return error(2300, operation + ": integer argument required") end if
  return value
end function

function writeChar(buffer, value)
  integer = requireInteger(value, "MSG_WriteChar")
  offset = sz.getSpace(buffer, 1)
  bio.putI8(buffer.data, offset, integer)
  return buffer
end function

function writeByte(buffer, value)
  integer = requireInteger(value, "MSG_WriteByte")
  offset = sz.getSpace(buffer, 1)
  bio.putU8(buffer.data, offset, integer)
  return buffer
end function

function writeShort(buffer, value)
  integer = requireInteger(value, "MSG_WriteShort")
  offset = sz.getSpace(buffer, 2)
  bio.putI16(buffer.data, offset, integer)
  return buffer
end function

function writeLong(buffer, value)
  integer = requireInteger(value, "MSG_WriteLong")
  offset = sz.getSpace(buffer, 4)
  bio.putI32(buffer.data, offset, integer)
  return buffer
end function

function writeFloat(buffer, value)
  bits = bio.float32Bits(value)
  offset = sz.getSpace(buffer, 4)
  bio.putU32(buffer.data, offset, bits)
  return buffer
end function

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

function writeString(buffer, text)
  if typeof(text) != "string" then return error(2302, "MSG_WriteString requires a string") end if
  return writeStringBytes(buffer, bytes(text))
end function

function writeCoord(buffer, value)
  return writeShort(buffer, bio.truncInt(value * 8.0))
end function

function writePos(buffer, position)
  writeCoord(buffer, position.x)
  writeCoord(buffer, position.y)
  writeCoord(buffer, position.z)
  return buffer
end function

function writeAngle(buffer, value)
  encoded = bio.truncInt(value * 256.0 / 360.0) & 255
  return writeByte(buffer, encoded)
end function

function writeAngle16(buffer, value)
  encoded = bio.truncInt(value * 65536.0 / 360.0) & 0xffff
  return writeShort(buffer, encoded)
end function

function beginReading(buffer)
  buffer.readCount = 0
  return buffer
end function

// Quake II readers advance even after an underrun. Keeping that behavior is
// important because parsers commonly inspect readCount after a failure.
function readAvailable(buffer, width)
  offset = buffer.readCount
  buffer.readCount = buffer.readCount + width
  return [offset, offset >= 0 and offset + width <= buffer.curSize]
end function

function readChar(buffer)
  state = readAvailable(buffer, 1)
  if not state[1] then return -1 end if
  return bio.i8(buffer.data, state[0])
end function

function readByte(buffer)
  state = readAvailable(buffer, 1)
  if not state[1] then return -1 end if
  return bio.u8(buffer.data, state[0])
end function

function readShort(buffer)
  state = readAvailable(buffer, 2)
  if not state[1] then return -1 end if
  return bio.i16(buffer.data, state[0])
end function

function readLong(buffer)
  state = readAvailable(buffer, 4)
  if not state[1] then return -1 end if
  return bio.i32(buffer.data, state[0])
end function

function readFloat(buffer)
  state = readAvailable(buffer, 4)
  if not state[1] then return -1.0 end if
  return bio.f32(buffer.data, state[0])
end function

function readStringBytes(buffer)
  output = bytes(2047)
  count = 0
  while count < 2047
    value = readChar(buffer)
    if value == -1 or value == 0 then break end if
    output[count] = value & 255
    count = count + 1
  end while
  return slice(output, 0, count)
end function

function readString(buffer)
  return decode(readStringBytes(buffer))
end function

function readStringLineBytes(buffer)
  output = bytes(2047)
  count = 0
  while count < 2047
    value = readChar(buffer)
    if value == -1 or value == 0 or value == 10 then break end if
    output[count] = value & 255
    count = count + 1
  end while
  return slice(output, 0, count)
end function

function readStringLine(buffer)
  return decode(readStringLineBytes(buffer))
end function

function readCoord(buffer)
  return readShort(buffer) * 0.125
end function

function readPos(buffer)
  return qt.Vec3(readCoord(buffer), readCoord(buffer), readCoord(buffer))
end function

function readAngle(buffer)
  return readChar(buffer) * (360.0 / 256.0)
end function

function readAngle16(buffer)
  return readShort(buffer) * (360.0 / 65536.0)
end function

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

function remaining(buffer)
  return buffer.curSize - buffer.readCount
end function

function MSG_WriteChar(buffer, value)
  return writeChar(buffer, value)
end function

function MSG_WriteByte(buffer, value)
  return writeByte(buffer, value)
end function

function MSG_WriteShort(buffer, value)
  return writeShort(buffer, value)
end function

function MSG_WriteLong(buffer, value)
  return writeLong(buffer, value)
end function

function MSG_WriteFloat(buffer, value)
  return writeFloat(buffer, value)
end function

function MSG_WriteString(buffer, text)
  return writeString(buffer, text)
end function

function MSG_WriteCoord(buffer, value)
  return writeCoord(buffer, value)
end function

function MSG_WritePos(buffer, position)
  return writePos(buffer, position)
end function

function MSG_WriteAngle(buffer, value)
  return writeAngle(buffer, value)
end function

function MSG_WriteAngle16(buffer, value)
  return writeAngle16(buffer, value)
end function

function MSG_BeginReading(buffer)
  return beginReading(buffer)
end function

function MSG_ReadChar(buffer)
  return readChar(buffer)
end function

function MSG_ReadByte(buffer)
  return readByte(buffer)
end function

function MSG_ReadShort(buffer)
  return readShort(buffer)
end function

function MSG_ReadLong(buffer)
  return readLong(buffer)
end function

function MSG_ReadFloat(buffer)
  return readFloat(buffer)
end function

function MSG_ReadString(buffer)
  return readString(buffer)
end function

function MSG_ReadStringLine(buffer)
  return readStringLine(buffer)
end function

function MSG_ReadCoord(buffer)
  return readCoord(buffer)
end function

function MSG_ReadPos(buffer)
  return readPos(buffer)
end function

function MSG_ReadAngle(buffer)
  return readAngle(buffer)
end function

function MSG_ReadAngle16(buffer)
  return readAngle16(buffer)
end function

function MSG_ReadData(buffer, count)
  return readData(buffer, count)
end function
