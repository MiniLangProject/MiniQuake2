/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Deterministic Quake II on-disk format contracts without retail assets. */
import miniquake2.format.constants as c
import miniquake2.format.types as t
import miniquake2.format.binary as bio
import miniquake2.format.bsp as bsp
import miniquake2.format.md2 as md2
import miniquake2.format.sprite as sprite
import miniquake2.format.wal as wal
import miniquake2.format.pcx as pcx
import miniquake2.format.cinematic as cinematic

function assertEqual(actual, expected, name)
  if actual != expected then return error(9900, name + ": expected " + expected + ", got " + actual) end if
  return true
end function

function assertTrue(value, name)
  if value != true then return error(9901, name + ": expected true") end if
  return true
end function

function testBspHeaderAndVisibility()
  data = bytes(160)
  bio.putU32(data, 0, c.IDBSPHEADER)
  bio.putU32(data, 4, c.BSP_VERSION)
  lumps = bsp.parseLumps(data)
  assertEqual(len(lumps), 19, "BSP lump count")
  visibilityBytes = bytes(14)
  bio.putU32(visibilityBytes, 0, 1)
  bio.putU32(visibilityBytes, 4, 12)
  bio.putU32(visibilityBytes, 8, 12)
  visibilityBytes[12] = 0
  visibilityBytes[13] = 1
  visibility = bsp.parseVisibility(visibilityBytes, t.Lump(0, 14))
  row = bsp.decompressVisibility(visibility, 0, 0)
  assertEqual(len(row), 1, "visibility row bytes")
  assertEqual(row[0], 0, "visibility zero run")
  bad = bytes(data)
  bio.putU32(bad, 4, 37)
  assertTrue(try(bsp.parseLumps(bad)) is error, "BSP version rejection")
  return true
end function

function testSprite()
  data = bytes(92)
  bio.putU32(data, 0, c.IDSPRITEHEADER)
  bio.putU32(data, 4, c.SPRITE_VERSION)
  bio.putU32(data, 8, 1)
  bio.putU32(data, 12, 32)
  bio.putU32(data, 16, 16)
  data[28] = 112; data[29] = 105; data[30] = 99; data[31] = 115; data[32] = 47; data[33] = 97; data[34] = 46; data[35] = 112; data[36] = 99; data[37] = 120
  model = sprite.parse(data, "smoke.sp2")
  assertEqual(model.frames[0].width, 32, "SP2 width")
  assertEqual(model.frames[0].imageName, "pics/a.pcx", "SP2 image")
  return true
end function

function testWal()
  data = bytes(185)
  data[0] = 116; data[1] = 101; data[2] = 115; data[3] = 116
  bio.putU32(data, 32, 8); bio.putU32(data, 36, 8)
  bio.putU32(data, 40, 100); bio.putU32(data, 44, 164); bio.putU32(data, 48, 180); bio.putU32(data, 52, 184)
  texture = wal.parse(data)
  assertEqual(texture.name, "test", "WAL name")
  assertEqual(len(texture.mipPixels[0]), 64, "WAL base mip")
  assertEqual(len(texture.mipPixels[3]), 1, "WAL final mip")
  return true
end function

function testPcx()
  data = bytes(128 + 4 + 769)
  data[0] = 10; data[1] = 5; data[2] = 1; data[3] = 8
  bio.putU16(data, 8, 1); bio.putU16(data, 10, 1)
  data[65] = 1; bio.putU16(data, 66, 2)
  data[128] = 1; data[129] = 2; data[130] = 3; data[131] = 4
  data[len(data) - 769] = 12
  image = pcx.parse(data)
  assertEqual(image.width, 2, "PCX width")
  assertEqual(image.pixels[3], 4, "PCX final pixel")
  assertEqual(len(image.palette), 768, "PCX palette")
  return true
end function

function testMd2Validation()
  data = bytes(68)
  bio.putU32(data, 0, c.IDALIASHEADER)
  bio.putU32(data, 4, c.ALIAS_VERSION)
  bio.putU32(data, 8, 64); bio.putU32(data, 12, 64); bio.putU32(data, 16, 44)
  bio.putU32(data, 24, 1); bio.putU32(data, 32, 1); bio.putU32(data, 40, 1); bio.putU32(data, 64, 68)
  assertTrue(try(md2.parse(data, "bad.md2")) is error, "MD2 section rejection")
  return true
end function

function testCinematicHeader()
  data = bytes(cinematic.HEADER_BYTES)
  bio.putU32(data, 0, 320); bio.putU32(data, 4, 240); bio.putU32(data, 8, 22050); bio.putU32(data, 12, 2); bio.putU32(data, 16, 1)
  previous = 0
  while previous < 256
    data[20 + previous * 256] = 1
    data[20 + previous * 256 + 1] = 1
    previous = previous + 1
  end while
  header = cinematic.parseHeader(data)
  assertEqual(header.width, 320, "CIN width")
  assertEqual(header.frameDataOffset, cinematic.HEADER_BYTES, "CIN frame offset")
  tables = cinematic.buildTables(header)
  compressed = bytes([4, 0, 0, 0, 10])
  pixels = cinematic.decompress(compressed, tables, 16)
  assertEqual(pixels[0], 0, "CIN Huffman first symbol")
  assertEqual(pixels[1], 1, "CIN Huffman second symbol")
  assertEqual(pixels[3], 1, "CIN Huffman final symbol")
  return true
end function

testBspHeaderAndVisibility()
testSprite()
testWal()
testPcx()
testMd2Validation()
testCinematicHeader()
print "format_contract_tests: PASS"
