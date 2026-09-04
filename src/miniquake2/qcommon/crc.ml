//! Provides miniquake2 qcommon crc facilities for this project.

/*
Copyright (C) 1997-2001 Id Software, Inc.
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later

Pure MiniLang pendant of Quake II crc.c / crc.h.
*/
package miniquake2.qcommon.crc

/// Defines the crc init value constant used by the miniquake2 qcommon crc module.
const CRC_INIT_VALUE = 0xffff
/// Defines the crc xor value constant used by the miniquake2 qcommon crc module.
const CRC_XOR_VALUE = 0x0000
/// Defines the crc polynomial constant used by the miniquake2 qcommon crc module.
const CRC_POLYNOMIAL = 0x1021

/// Initialize crc.
function inline CRC_Init()
  return CRC_INIT_VALUE
end function

/// crc.c uses a table; this bitwise transition is the same non-reflected
/// CRC-CCITT operation and keeps the unsigned-short truncation explicit.
/// @param crcValue crcValue value consumed by this operation.
/// @param data Input data consumed by the operation.
function CRC_ProcessByte(crcValue, data)
  if typeof(crcValue) != "int" or typeof(data) != "int" then
    return error(2400, "CRC_ProcessByte requires integers")
  end if
  value = (crcValue & 0xffff) ^ ((data & 255) << 8)
  bit = 0
  while bit < 8
    if (value & 0x8000) != 0 then
      value = ((value << 1) ^ CRC_POLYNOMIAL) & 0xffff
    else
      value = (value << 1) & 0xffff
    end if
    bit = bit + 1
  end while
  return value
end function

/// Return the crc value.
/// @param crcValue crcValue value consumed by this operation.
function inline CRC_Value(crcValue)
  if typeof(crcValue) != "int" then return error(2401, "CRC_Value requires an integer") end if
  return (crcValue ^ CRC_XOR_VALUE) & 0xffff
end function

/// Return the crc block value.
/// @param data Input data consumed by the operation.
/// @param offset Zero-based offset at which processing starts.
/// @param count Number of items or units to process.
function CRC_Block(data, offset, count)
  if typeof(data) != "bytes" then return error(2402, "CRC input must be bytes") end if
  if typeof(offset) != "int" or typeof(count) != "int" then return error(2403, "CRC range must be integral") end if
  if offset < 0 or count < 0 or offset > len(data) or count > len(data) - offset then
    return error(2404, "CRC range outside buffer")
  end if
  value = CRC_Init()
  index = 0
  while index < count
    value = CRC_ProcessByte(value, data[offset + index])
    index = index + 1
  end while
  return CRC_Value(value)
end function

/// Process byte.
/// @param crcValue crcValue value consumed by this operation.
/// @param data Input data consumed by the operation.
function processByte(crcValue, data)
  return CRC_ProcessByte(crcValue, data)
end function

/// Return the block value.
/// @param data Input data consumed by the operation.
/// @param offset Zero-based offset at which processing starts.
/// @param count Number of items or units to process.
function block(data, offset, count)
  return CRC_Block(data, offset, count)
end function
