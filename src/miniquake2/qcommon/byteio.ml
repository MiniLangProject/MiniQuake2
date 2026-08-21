/*
Copyright (C) 1997-2001 Id Software, Inc.
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later

Bounds-checked little-endian byte I/O for Quake II wire and file formats.
The IEEE-754 conversion is deliberately pure MiniLang.
*/
package miniquake2.qcommon.byteio

function requireRange(data, offset, count)
  if typeof(data) != "bytes" then return error(2100, "byte buffer required") end if
  if typeof(offset) != "int" or typeof(count) != "int" then
    return error(2101, "byte range requires integer offset and count")
  end if
  if offset < 0 or count < 0 or offset > len(data) or count > len(data) - offset then
    return error(2102, "byte range outside buffer")
  end if
  return true
end function

function inline u8(data, offset)
  requireRange(data, offset, 1)
  return data[offset]
end function

function inline i8(data, offset)
  value = u8(data, offset)
  if value >= 128 then return value - 256 end if
  return value
end function

function inline u16(data, offset)
  requireRange(data, offset, 2)
  return data[offset] | (data[offset + 1] << 8)
end function

function inline i16(data, offset)
  value = u16(data, offset)
  if value >= 0x8000 then return value - 0x10000 end if
  return value
end function

function u32(data, offset)
  requireRange(data, offset, 4)
  return data[offset] |
    (data[offset + 1] << 8) |
    (data[offset + 2] << 16) |
    (data[offset + 3] << 24)
end function

function i32(data, offset)
  value = u32(data, offset)
  if value >= 0x80000000 then return value - 0x100000000 end if
  return value
end function

function inline putU8(data, offset, value)
  requireRange(data, offset, 1)
  if typeof(value) != "int" then return error(2103, "byte value must be an integer") end if
  data[offset] = value & 255
  return offset + 1
end function

function inline putI8(data, offset, value)
  return putU8(data, offset, value)
end function

function inline putU16(data, offset, value)
  requireRange(data, offset, 2)
  if typeof(value) != "int" then return error(2104, "short value must be an integer") end if
  data[offset] = value & 255
  data[offset + 1] = (value >> 8) & 255
  return offset + 2
end function

function inline putI16(data, offset, value)
  return putU16(data, offset, value)
end function

function putU32(data, offset, value)
  requireRange(data, offset, 4)
  if typeof(value) != "int" then return error(2105, "long value must be an integer") end if
  data[offset] = value & 255
  data[offset + 1] = (value >> 8) & 255
  data[offset + 2] = (value >> 16) & 255
  data[offset + 3] = (value >> 24) & 255
  return offset + 4
end function

function inline putI32(data, offset, value)
  return putU32(data, offset, value)
end function

function copyInto(destination, destinationOffset, source, sourceOffset, count)
  requireRange(destination, destinationOffset, count)
  requireRange(source, sourceOffset, count)
  index = 0
  while index < count
    destination[destinationOffset + index] = source[sourceOffset + index]
    index = index + 1
  end while
  return destinationOffset + count
end function

// Convert an integer or finite MiniLang float to a C-style truncating int.
// Constructing the result bit by bit avoids a native float-to-int helper.
function truncInt(value)
  if typeof(value) == "int" then return value end if
  if typeof(value) != "float" then return error(2106, "numeric value required") end if
  if value != value then return error(2107, "cannot convert NaN to integer") end if

  negative = value < 0.0
  remaining = value
  if negative then remaining = -remaining end if
  if remaining > 2147483647.0 then return error(2108, "integer conversion outside i32") end if

  result = 0
  unit = 1
  while unit <= 0x40000000 and (unit * 2) <= remaining
    unit = unit << 1
  end while
  while unit > 0
    if remaining >= unit then
      result = result + unit
      remaining = remaining - unit
    end if
    unit = unit >> 1
  end while
  if negative then return -result end if
  return result
end function

// Round a binary fractional tail to nearest, ties to even.
function shouldRoundUp(remainder, leastBit)
  if remainder > 0.5 then return true end if
  if remainder == 0.5 and (leastBit & 1) != 0 then return true end if
  return false
end function

// Emit 23 fraction bits from a value in [0, 1), returning [bits, tail].
function fractionBits23(fraction)
  bits = 0
  bit = 22
  while bit >= 0
    fraction = fraction * 2.0
    if fraction >= 1.0 then
      bits = bits | (1 << bit)
      fraction = fraction - 1.0
    end if
    bit = bit - 1
  end while
  return [bits, fraction]
end function

function powerOfTwo(exponent)
  value = 1.0
  while exponent > 0
    value = value * 2.0
    exponent = exponent - 1
  end while
  while exponent < 0
    value = value * 0.5
    exponent = exponent + 1
  end while
  return value
end function

// Encode IEEE-754 binary32 using round-to-nearest-even. Negative zero is
// normalized to positive zero because MiniLang has no signbit primitive.
function float32Bits(value)
  magnitude = 0.0
  if typeof(value) == "int" then
    if value == 0 then return 0 end if
    magnitude = value * 1.0
  else if typeof(value) == "float" then
    magnitude = value
  else
    return error(2109, "float32 value must be numeric")
  end if

  if magnitude != magnitude then return 0x7fc00000 end if
  sign = 0
  if magnitude < 0.0 then
    sign = 0x80000000
    magnitude = -magnitude
  end if
  if magnitude == 0.0 then return sign end if
  // Subnormal values encode magnitude / 2^-126 directly as 23 bits.
  minNormal = powerOfTwo(-126)
  if magnitude < minNormal then
    fractionResult = fractionBits23(magnitude / minNormal)
    mantissa = fractionResult[0]
    if shouldRoundUp(fractionResult[1], mantissa) then mantissa = mantissa + 1 end if
    if mantissa >= 0x800000 then return sign | 0x00800000 end if
    return sign | mantissa
  end if

  normalized = magnitude
  exponent = 0
  while normalized >= 2.0
    normalized = normalized * 0.5
    exponent = exponent + 1
    if exponent > 127 then return sign | 0x7f800000 end if
  end while
  while normalized < 1.0
    normalized = normalized * 2.0
    exponent = exponent - 1
  end while

  fractionResult = fractionBits23(normalized - 1.0)
  mantissa = fractionResult[0]
  if shouldRoundUp(fractionResult[1], mantissa) then
    mantissa = mantissa + 1
    if mantissa == 0x800000 then
      mantissa = 0
      exponent = exponent + 1
    end if
  end if
  if exponent > 127 then return sign | 0x7f800000 end if
  return sign | ((exponent + 127) << 23) | mantissa
end function

function float32FromBits(bits)
  if typeof(bits) != "int" then return error(2110, "float32 bits must be an integer") end if
  sign = 1.0
  if (bits & 0x80000000) != 0 then sign = -1.0 end if
  exponentBits = (bits >> 23) & 255
  mantissa = bits & 0x7fffff
  if exponentBits == 255 then return error(2111, "non-finite float32 is not representable") end if
  if exponentBits == 0 and mantissa == 0 then return sign * 0.0 end if

  value = 0.0
  exponent = 0
  if exponentBits == 0 then
    value = mantissa / 8388608.0
    exponent = -126
  else
    value = 1.0 + (mantissa / 8388608.0)
    exponent = exponentBits - 127
  end if
  while exponent > 0
    value = value * 2.0
    exponent = exponent - 1
  end while
  while exponent < 0
    value = value * 0.5
    exponent = exponent + 1
  end while
  return sign * value
end function

function inline f32(data, offset)
  return float32FromBits(u32(data, offset))
end function

function inline putF32(data, offset, value)
  return putU32(data, offset, float32Bits(value))
end function

function shortSwap(value)
  swapped = ((value & 255) << 8) | ((value >> 8) & 255)
  if swapped >= 0x8000 then return swapped - 0x10000 end if
  return swapped
end function

function longSwap(value)
  swapped = ((value & 255) << 24) |
    (((value >> 8) & 255) << 16) |
    (((value >> 16) & 255) << 8) |
    ((value >> 24) & 255)
  if swapped >= 0x80000000 then return swapped - 0x100000000 end if
  return swapped
end function

// The supported MiniQuake2 release platform is little-endian Windows x64.
function inline littleShort(value)
  narrowed = value & 0xffff
  if narrowed >= 0x8000 then return narrowed - 0x10000 end if
  return narrowed
end function

function inline littleLong(value)
  narrowed = value & 0xffffffff
  if narrowed >= 0x80000000 then return narrowed - 0x100000000 end if
  return narrowed
end function

function bigShort(value)
  return shortSwap(value)
end function

function bigLong(value)
  return longSwap(value)
end function
