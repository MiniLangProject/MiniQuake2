/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later

Deterministic protocol-34 qcommon tests. Byte vectors are independent of host
endianness and can be compared directly with Quake II 3.19 common.c.
*/
import miniquake2.qcommon.constants as c
import miniquake2.qcommon.types as t
import miniquake2.qcommon.byteio as bio
import miniquake2.qcommon.sizebuf as sz
import miniquake2.qcommon.message as msg
import miniquake2.qcommon.crc as crc
import miniquake2.qcommon.checksum as checksum

function assertEqual(actual, expected, name)
  if actual != expected then return error(2900, name + ": expected " + expected + ", got " + actual) end if
  return true
end function

function assertTrue(value, name)
  if value != true then return error(2901, name + ": expected true") end if
  return true
end function

function assertNear(actual, expected, tolerance, name)
  difference = actual - expected
  if difference < 0 then difference = -difference end if
  if difference > tolerance then return error(2902, name + ": values differ") end if
  return true
end function

function assertBytes(actual, expected, name)
  assertEqual(len(actual), len(expected), name + " length")
  index = 0
  while index < len(expected)
    assertEqual(actual[index], expected[index], name + " byte " + index)
    index = index + 1
  end while
  return true
end function

function testConstantsAndTypes()
  assertEqual(c.VERSION, 3.19, "engine version")
  assertEqual(c.PROTOCOL_VERSION, 34, "protocol version")
  assertEqual(c.MAX_MSGLEN, 1400, "network message limit")
  assertEqual(c.SVC_FRAME, 20, "svc enum continuity")
  assertEqual(c.CLC_STRINGCMD, 4, "clc enum continuity")
  assertEqual(c.CS_GENERAL, 1568, "configstring layout")
  assertEqual(c.MAX_CONFIGSTRINGS, 2080, "configstring count")
  command = t.zeroUserCmd()
  assertEqual(command.angles[2], 0, "zero usercmd angles")
  assertEqual(command.lightLevel, 0, "zero usercmd lightlevel")
  return true
end function

function testByteIo()
  data = bytes(16)
  bio.putU16(data, 0, 0xabcd)
  bio.putI16(data, 2, -1234)
  bio.putU32(data, 4, 0x89abcdef)
  bio.putF32(data, 8, 12.5)
  assertBytes(slice(data, 0, 12), bytes([
    0xcd, 0xab, 0x2e, 0xfb,
    0xef, 0xcd, 0xab, 0x89,
    0x00, 0x00, 0x48, 0x41,
  ]), "little endian vector")
  assertEqual(bio.u16(data, 0), 0xabcd, "u16 decode")
  assertEqual(bio.i16(data, 2), -1234, "i16 decode")
  assertEqual(bio.u32(data, 4), 0x89abcdef, "u32 decode")
  assertEqual(bio.i32(data, 4), -1985229329, "i32 decode")
  assertEqual(bio.f32(data, 8), 12.5, "f32 decode")
  assertEqual(bio.float32Bits(1.0), 0x3f800000, "f32 one bits")
  assertEqual(bio.float32Bits(-2.5), 0xc0200000, "f32 negative bits")
  assertEqual(bio.float32Bits(bio.float32FromBits(1)), 1, "f32 minimum subnormal")
  assertEqual(bio.float32Bits(1.0 + bio.powerOfTwo(-24)), 0x3f800000, "f32 tie rounds to even")
  oddHalf = bio.float32FromBits(0x3f800001) + bio.powerOfTwo(-24)
  assertEqual(bio.float32Bits(oddHalf), 0x3f800002, "f32 odd tie rounds upward")
  assertNear(bio.float32FromBits(0x3eaaaaab), 0.3333333432674408, 0.0000000001, "f32 third")
  assertTrue(try(bio.u32(bytes(3), 0)) is error, "truncated u32 rejected")
  assertTrue(try(bio.putU16(bytes(1), 0, 1)) is error, "truncated put rejected")
  assertTrue(try(bio.requireRange(bytes(2), -1, 1)) is error, "negative range rejected")
  return true
end function

function testSizeBuffer()
  buffer = sz.alloc(8)
  sz.writeBytes(buffer, bytes([1, 2, 3]))
  assertEqual(buffer.curSize, 3, "SZ_Write cursor")
  assertBytes(sz.dataSlice(buffer), bytes([1, 2, 3]), "SZ_Write bytes")
  assertTrue(try(sz.writeBytes(buffer, bytes([4, 5, 6, 7, 8, 9]))) is error, "non-overflowing buffer rejects overflow")
  assertEqual(buffer.curSize, 3, "failed write preserves cursor")

  wrapping = sz.allocOverflowing(4)
  sz.writeBytes(wrapping, bytes([1, 2, 3, 4]))
  sz.writeBytes(wrapping, bytes([9, 8]))
  assertEqual(wrapping.overflowed, true, "overflow flag")
  assertEqual(wrapping.curSize, 2, "overflow restarts buffer")
  assertBytes(sz.dataSlice(wrapping), bytes([9, 8]), "overflow replacement")
  sz.clear(wrapping)
  assertEqual(wrapping.overflowed, false, "Quake II SZ_Clear resets overflow flag")

  printable = sz.alloc(16)
  sz.printText(printable, "one")
  sz.printText(printable, "two")
  assertBytes(sz.dataSlice(printable), bytes([111, 110, 101, 116, 119, 111, 0]), "SZ_Print concatenation")
  assertTrue(try(sz.getSpace(printable, -1)) is error, "negative size rejected")
  assertTrue(try(sz.write(printable, bytes([1]), 1, 1)) is error, "source bounds rejected")
  return true
end function

function testMessages()
  buffer = sz.alloc(128)
  msg.writeChar(buffer, -2)
  msg.writeByte(buffer, 200)
  msg.writeShort(buffer, -1234)
  msg.writeLong(buffer, 0x12345678)
  msg.writeFloat(buffer, 12.5)
  msg.writeString(buffer, "quake")
  msg.writeCoord(buffer, -10.25)
  msg.writePos(buffer, t.Vec3(1.0, -2.0, 3.125))
  msg.writeAngle(buffer, 90.0)
  msg.writeAngle16(buffer, 45.0)

  assertBytes(sz.dataSlice(buffer), bytes([
    0xfe, 0xc8, 0x2e, 0xfb, 0x78, 0x56, 0x34, 0x12,
    0x00, 0x00, 0x48, 0x41,
    0x71, 0x75, 0x61, 0x6b, 0x65, 0x00,
    0xae, 0xff,
    0x08, 0x00, 0xf0, 0xff, 0x19, 0x00,
    0x40, 0x00, 0x20,
  ]), "protocol primitive vector")

  msg.beginReading(buffer)
  assertEqual(msg.readChar(buffer), -2, "MSG_ReadChar")
  assertEqual(msg.readByte(buffer), 200, "MSG_ReadByte")
  assertEqual(msg.readShort(buffer), -1234, "MSG_ReadShort")
  assertEqual(msg.readLong(buffer), 0x12345678, "MSG_ReadLong")
  assertEqual(msg.readFloat(buffer), 12.5, "MSG_ReadFloat")
  assertEqual(msg.readString(buffer), "quake", "MSG_ReadString")
  assertEqual(msg.readCoord(buffer), -10.25, "MSG_ReadCoord")
  position = msg.readPos(buffer)
  assertEqual(position.x, 1.0, "MSG_ReadPos x")
  assertEqual(position.y, -2.0, "MSG_ReadPos y")
  assertEqual(position.z, 3.125, "MSG_ReadPos z")
  assertEqual(msg.readAngle(buffer), 90.0, "MSG_ReadAngle")
  assertEqual(msg.readAngle16(buffer), 45.0, "MSG_ReadAngle16")
  assertEqual(msg.remaining(buffer), 0, "message fully consumed")

  angleBuffer = sz.alloc(4)
  msg.writeAngle(angleBuffer, 180.0)
  msg.writeAngle16(angleBuffer, 180.0)
  msg.beginReading(angleBuffer)
  assertEqual(msg.readAngle(angleBuffer), -180.0, "signed byte angle")
  assertEqual(msg.readAngle16(angleBuffer), -180.0, "signed short angle")

  lineBuffer = sz.alloc(16)
  msg.writeStringBytes(lineBuffer, bytes([97, 98, 10, 99, 0]))
  msg.beginReading(lineBuffer)
  assertEqual(msg.readStringLine(lineBuffer), "ab", "line terminator")
  assertEqual(lineBuffer.readCount, 3, "line reader consumes newline")

  shortBuffer = sz.alloc(1)
  shortBuffer.data[0] = 7
  shortBuffer.curSize = 1
  msg.beginReading(shortBuffer)
  assertEqual(msg.readLong(shortBuffer), -1, "underrun sentinel")
  assertEqual(shortBuffer.readCount, 4, "underrun advances by width")
  assertEqual(msg.readByte(shortBuffer), -1, "subsequent underrun sentinel")
  assertEqual(shortBuffer.readCount, 5, "subsequent underrun advances")
  msg.beginReading(shortBuffer)
  assertBytes(msg.readData(shortBuffer, 3), bytes([7, 255, 255]), "MSG_ReadData underrun byte conversion")
  return true
end function

function testCrc()
  assertEqual(crc.CRC_Init(), 0xffff, "CRC init")
  assertEqual(crc.CRC_Block(bytes("123456789"), 0, 9), 0x29b1, "CRC-CCITT check vector")
  quake = bytes("Quake")
  assertEqual(crc.CRC_Block(quake, 0, len(quake)), 0x17d7, "Quake CRC vector")
  assertEqual(crc.CRC_Block(bytes(), 0, 0), 0xffff, "empty CRC")
  assertTrue(try(crc.CRC_Block(bytes(2), 1, 2)) is error, "CRC truncated range rejected")
  assertTrue(try(crc.CRC_Block("not bytes", 0, 1)) is error, "CRC type rejected")

  assertBytes(checksum.md4(bytes(), 0, 0), bytes([
    0x31, 0xd6, 0xcf, 0xe0, 0xd1, 0x6a, 0xe9, 0x31,
    0xb7, 0x3c, 0x59, 0xd7, 0xe0, 0xc0, 0x89, 0xc0,
  ]), "MD4 empty vector")
  abc = bytes("abc")
  assertBytes(checksum.md4(abc, 0, len(abc)), bytes([
    0xa4, 0x48, 0x01, 0x7a, 0xaf, 0x21, 0xd8, 0x52,
    0x5f, 0xc1, 0x0a, 0xe8, 0x7a, 0xa6, 0x72, 0x9d,
  ]), "MD4 abc vector")
  assertEqual(checksum.Com_BlockChecksum(abc, 0, len(abc)), 0x5da10e2e, "Quake II block checksum")
  longMd4Input = bytes("xxABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789")
  assertBytes(checksum.md4(longMd4Input, 2, 62), bytes([
    0x04, 0x3f, 0x85, 0x82, 0xf2, 0x41, 0xdb, 0x35,
    0x1c, 0xe6, 0x27, 0xe1, 0x53, 0xe7, 0xf0, 0xe4,
  ]), "MD4 multi-block offset vector")
  assertTrue(try(checksum.md4(bytes(2), 1, 2)) is error, "MD4 truncated range rejected")
  return true
end function

function main(args)
  print "MiniQuake2 qcommon tests starting: 5"
  result = try(testConstantsAndTypes())
  if result is error then print "FAIL constants/types: " + result.message; return 1 end if
  result = try(testByteIo())
  if result is error then print "FAIL byte I/O: " + result.message; return 1 end if
  result = try(testSizeBuffer())
  if result is error then print "FAIL sizebuf: " + result.message; return 1 end if
  result = try(testMessages())
  if result is error then print "FAIL messages: " + result.message; return 1 end if
  result = try(testCrc())
  if result is error then print "FAIL CRC: " + result.message; return 1 end if
  print "MiniQuake2 qcommon tests passed: 5"
  return 0
end function
