//! Provides miniquake2 qcommon sizebuf facilities for this project.

/*
Copyright (C) 1997-2001 Id Software, Inc.
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later

Memory-safe MiniLang port of Quake II 3.19 SZ_*.
*/
package miniquake2.qcommon.sizebuf

import miniquake2.qcommon.types as qt
import miniquake2.qcommon.byteio as bio

/// Performs the init operation for the miniquake2 qcommon sizebuf module.
/// @param data Input data consumed by the operation.
/// @param length length value consumed by this operation.
function init(data, length)
  if typeof(data) != "bytes" then return error(2200, "SZ_Init requires bytes") end if
  if typeof(length) != "int" or length < 0 or length > len(data) then
    return error(2201, "SZ_Init length outside backing buffer")
  end if
  return qt.SizeBuffer(false, false, data, length, 0, 0)
end function

/// Return the alloc value.
/// @param maxSize maxSize value consumed by this operation.
function alloc(maxSize)
  if typeof(maxSize) != "int" or maxSize < 0 then return error(2202, "invalid size buffer capacity") end if
  return init(bytes(maxSize), maxSize)
end function

/// Return the alloc overflowing value.
/// @param maxSize maxSize value consumed by this operation.
function allocOverflowing(maxSize)
  buffer = alloc(maxSize)
  buffer.allowOverflow = true
  return buffer
end function

/// Clear state.
/// @param buffer Buffer that receives or supplies the operation data.
function clear(buffer)
  buffer.curSize = 0
  buffer.overflowed = false
  return buffer
end function

/// Return space.
/// @param buffer Buffer that receives or supplies the operation data.
/// @param count Number of items or units to process.
function getSpace(buffer, count)
  if typeof(count) != "int" or count < 0 then return error(2203, "negative or non-integer SZ_GetSpace length") end if
  if buffer.curSize < 0 or buffer.curSize > buffer.maxSize then return error(2204, "corrupt size buffer cursor") end if
  if buffer.curSize + count > buffer.maxSize then
    if not buffer.allowOverflow then return error(2205, "SZ_GetSpace overflow without allowOverflow") end if
    if count > buffer.maxSize then return error(2206, "SZ_GetSpace request exceeds full buffer") end if
    clear(buffer)
    buffer.overflowed = true
  end if
  offset = buffer.curSize
  buffer.curSize = buffer.curSize + count
  return offset
end function

/// Write state.
/// @param buffer Buffer that receives or supplies the operation data.
/// @param source source value consumed by this operation.
/// @param sourceOffset sourceOffset value consumed by this operation.
/// @param count Number of items or units to process.
function write(buffer, source, sourceOffset, count)
  bio.requireRange(source, sourceOffset, count)
  offset = getSpace(buffer, count)
  bio.copyInto(buffer.data, offset, source, sourceOffset, count)
  return offset
end function

/// Write bytes.
/// @param buffer Buffer that receives or supplies the operation data.
/// @param source source value consumed by this operation.
function writeBytes(buffer, source)
  if typeof(source) != "bytes" then return error(2207, "SZ_Write requires bytes") end if
  return write(buffer, source, 0, len(source))
end function

/// Print bytes.
/// @param buffer Buffer that receives or supplies the operation data.
/// @param source source value consumed by this operation.
function printBytes(buffer, source)
  if typeof(source) != "bytes" then return error(2208, "SZ_Print requires bytes") end if
  count = 0
  while count < len(source) and source[count] != 0
    count = count + 1
  end while
  encodedLength = count + 1
  replaceTerminator = buffer.curSize > 0 and buffer.data[buffer.curSize - 1] == 0
  offset = 0

  if replaceTerminator and buffer.curSize + count > buffer.maxSize then
    // The C routine subtracts one after an overflow clear and writes before
    // data[0]. Define that invalid edge as a safe, complete restart.
    if not buffer.allowOverflow then return error(2205, "SZ_GetSpace overflow without allowOverflow") end if
    if encodedLength > buffer.maxSize then return error(2206, "SZ_GetSpace request exceeds full buffer") end if
    clear(buffer)
    buffer.overflowed = true
    offset = getSpace(buffer, encodedLength)
  else if replaceTerminator then
    offset = getSpace(buffer, count) - 1
  else
    offset = getSpace(buffer, encodedLength)
  end if

  if count > 0 then bio.copyInto(buffer.data, offset, source, 0, count) end if
  buffer.data[offset + count] = 0
  return offset
end function

/// Print text.
/// @param buffer Buffer that receives or supplies the operation data.
/// @param text Text consumed by the operation.
function printText(buffer, text)
  if typeof(text) != "string" then return error(2209, "SZ_Print requires a string") end if
  return printBytes(buffer, bytes(text))
end function

/// Slice data.
/// @param buffer Buffer that receives or supplies the operation data.
function dataSlice(buffer)
  return slice(buffer.data, 0, buffer.curSize)
end function

/// Initialize sz.
/// @param data Input data consumed by the operation.
/// @param length length value consumed by this operation.
function SZ_Init(data, length)
  return init(data, length)
end function

/// Clear sz.
/// @param buffer Buffer that receives or supplies the operation data.
function SZ_Clear(buffer)
  return clear(buffer)
end function

/// Return sz space.
/// @param buffer Buffer that receives or supplies the operation data.
/// @param count Number of items or units to process.
function SZ_GetSpace(buffer, count)
  return getSpace(buffer, count)
end function

/// Write sz.
/// @param buffer Buffer that receives or supplies the operation data.
/// @param source source value consumed by this operation.
/// @param sourceOffset sourceOffset value consumed by this operation.
/// @param count Number of items or units to process.
function SZ_Write(buffer, source, sourceOffset, count)
  return write(buffer, source, sourceOffset, count)
end function

/// Print sz.
/// @param buffer Buffer that receives or supplies the operation data.
/// @param text Text consumed by the operation.
function SZ_Print(buffer, text)
  return printText(buffer, text)
end function
