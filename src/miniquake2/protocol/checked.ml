/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later

Strict protocol readers layered over the reference-compatible MSG_Read*
primitives.  qcommon retains Quake II's -1 underrun sentinel; network parsers
must reject an underrun before consuming a value.
*/
package miniquake2.protocol.checked

import miniquake2.qcommon.message as qmsg

function require(buffer, count, operation)
  if typeof(count) != "int" or count < 0 then return error(7010, operation + ": invalid width") end if
  if typeof(buffer.data) != "bytes" or buffer.maxSize < 0 or buffer.maxSize > len(buffer.data) then
    return error(7011, operation + ": corrupt message backing buffer")
  end if
  if buffer.readCount < 0 or buffer.curSize < 0 or buffer.curSize > buffer.maxSize then
    return error(7011, operation + ": corrupt message cursors")
  end if
  if buffer.readCount > buffer.curSize or count > buffer.curSize - buffer.readCount then
    return error(7012, operation + ": truncated protocol message")
  end if
  return true
end function

function readByte(buffer, operation)
  require(buffer, 1, operation)
  return qmsg.readByte(buffer)
end function

function readChar(buffer, operation)
  require(buffer, 1, operation)
  return qmsg.readChar(buffer)
end function

function readShort(buffer, operation)
  require(buffer, 2, operation)
  return qmsg.readShort(buffer)
end function

function readUShort(buffer, operation)
  return readShort(buffer, operation) & 0xffff
end function

function readLong(buffer, operation)
  require(buffer, 4, operation)
  return qmsg.readLong(buffer)
end function

function readULong(buffer, operation)
  return readLong(buffer, operation) & 0xffffffff
end function

function readCoord(buffer, operation)
  return readShort(buffer, operation) * 0.125
end function

function readAngle(buffer, operation)
  return readChar(buffer, operation) * (360.0 / 256.0)
end function

function readAngle16(buffer, operation)
  return readShort(buffer, operation) * (360.0 / 65536.0)
end function

function readBytes(buffer, count, operation)
  require(buffer, count, operation)
  output = slice(buffer.data, buffer.readCount, count)
  buffer.readCount = buffer.readCount + count
  return output
end function
