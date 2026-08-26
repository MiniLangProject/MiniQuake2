/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Bounds-checked little-endian reads shared by all Quake II formats. */
package miniquake2.format.binary

import miniquake2.native as native

function requireRange(data, offset, count)
  if typeof(data) != "bytes" then return error(2100, "byte buffer required") end if
  if offset < 0 or count < 0 or offset > len(data) or count > len(data) - offset then
    return error(2101, "byte range outside buffer")
  end if
  return true
end function

function inline u8(data, offset)
  requireRange(data, offset, 1)
  return data[offset]
end function

function inline i8(data, offset)
  value = u8(data, offset)
  if value >= 128 then value = value - 256 end if
  return value
end function

function inline u16(data, offset)
  requireRange(data, offset, 2)
  return data[offset] | (data[offset + 1] << 8)
end function

function inline i16(data, offset)
  value = u16(data, offset)
  if value >= 0x8000 then value = value - 0x10000 end if
  return value
end function

function u32(data, offset)
  requireRange(data, offset, 4)
  return data[offset] | (data[offset + 1] << 8) | (data[offset + 2] << 16) | (data[offset + 3] << 24)
end function

function i32(data, offset)
  value = u32(data, offset)
  if value >= 0x80000000 then value = value - 0x100000000 end if
  return value
end function

function inline f32(data, offset)
  return native.bitsFloat(u32(data, offset))
end function

function fixedString(data, offset, capacity)
  requireRange(data, offset, capacity)
  count = 0
  while count < capacity and data[offset + count] != 0
    count = count + 1
  end while
  if count == 0 then return "" end if
  value = decode(slice(data, offset, count))
  if value is void then return error(2102, "invalid string encoding") end if
  return value
end function

function putU16(data, offset, value)
  requireRange(data, offset, 2)
  data[offset] = value & 255
  data[offset + 1] = (value >> 8) & 255
  return offset + 2
end function

function putU32(data, offset, value)
  requireRange(data, offset, 4)
  data[offset] = value & 255
  data[offset + 1] = (value >> 8) & 255
  data[offset + 2] = (value >> 16) & 255
  data[offset + 3] = (value >> 24) & 255
  return offset + 4
end function
