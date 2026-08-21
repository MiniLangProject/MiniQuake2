/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later

Golden protocol-34 vectors derived from Quake II 3.19 common.c, sv_ents.c,
and cl_ents.pc.  No host ABI or C fallback participates in this executable.
*/
import miniquake2.qcommon.types as qt
import miniquake2.qcommon.sizebuf as qsz
import miniquake2.qcommon.message as qmsg
import miniquake2.protocol.constants as pc
import miniquake2.protocol.types as pt
import miniquake2.protocol.usercmd as pusercmd
import miniquake2.protocol.entity_delta as pentity
import miniquake2.protocol.player_delta as pplayer

function assertEqual(actual, expected, name)
  if actual != expected then return error(7900, name + ": expected " + expected + ", got " + actual) end if
  return true
end function

function assertNear(actual, expected, tolerance, name)
  difference = actual - expected
  if difference < 0 then difference = -difference end if
  if difference > tolerance then return error(7901, name + ": values differ") end if
  return true
end function

function assertTrue(value, name)
  if value != true then return error(7902, name + ": expected true") end if
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

function readingBuffer(data)
  buffer = qsz.alloc(len(data))
  qsz.writeBytes(buffer, data)
  qmsg.beginReading(buffer)
  return buffer
end function

function testUserCmdGolden()
  base = qt.zeroUserCmd()
  command = qt.UserCmd(16, 5, [0x1234, -2, 0], 300, 0, -40, 9, 128)
  buffer = qsz.alloc(64)
  bits = pusercmd.writeDelta(buffer, base, command)
  assertEqual(bits, 0xeb, "usercmd bits")
  golden = bytes([0xeb, 0x34, 0x12, 0xfe, 0xff, 0x2c, 0x01, 0xd8, 0xff, 0x05, 0x09, 0x10, 0x80])
  assertBytes(qsz.dataSlice(buffer), golden, "MSG_WriteDeltaUsercmd C vector")
  decoded = pusercmd.readDelta(readingBuffer(golden), base)
  assertEqual(decoded.angles[0], 0x1234, "usercmd angle1")
  assertEqual(decoded.angles[1], -2, "usercmd angle2")
  assertEqual(decoded.forwardMove, 300, "usercmd forward")
  assertEqual(decoded.sideMove, 0, "usercmd inherited side")
  assertEqual(decoded.upMove, -40, "usercmd up")
  assertEqual(decoded.buttons, 5, "usercmd buttons")
  assertEqual(decoded.impulse, 9, "usercmd impulse")
  assertEqual(decoded.msec, 16, "usercmd msec")
  assertEqual(decoded.lightLevel, 128, "usercmd light")
  assertTrue(try(pusercmd.readDelta(readingBuffer(slice(golden, 0, len(golden) - 1)), base)) is error, "truncated usercmd rejected")
  return true
end function

function testEntityGolden()
  base = pt.zeroEntityState()
  target = pt.zeroEntityState()
  target.number = 300
  target.origin = [1.0, -2.0, 3.125]
  target.angles = [90.0, 180.0, -90.0]
  target.oldOrigin = [0.5, 1.5, -0.5]
  target.modelIndex = 7; target.modelIndex2 = 8; target.modelIndex3 = 9; target.modelIndex4 = 10
  target.frame = 300
  target.skinNum = 0x12345678
  target.effects = 0x8000
  target.renderFx = 300
  target.solid = 0x1234
  target.sound = 11
  target.event = 2
  buffer = qsz.alloc(128)
  bits = pentity.writeDelta(buffer, base, target, true, true)
  assertEqual(bits, 0x0fffcfaf, "entity delta flags")
  golden = bytes([
    0xaf, 0xcf, 0xff, 0x0f, 0x2c, 0x01,
    0x07, 0x08, 0x09, 0x0a, 0x2c, 0x01,
    0x78, 0x56, 0x34, 0x12, 0x00, 0x80, 0x00, 0x00, 0x2c, 0x01,
    0x08, 0x00, 0xf0, 0xff, 0x19, 0x00, 0x40, 0x80, 0xc0,
    0x04, 0x00, 0x0c, 0x00, 0xfc, 0xff, 0x0b, 0x02, 0x34, 0x12,
  ])
  assertBytes(qsz.dataSlice(buffer), golden, "MSG_WriteDeltaEntity C vector")
  readBuffer = readingBuffer(golden)
  header = pentity.readHeader(readBuffer)
  assertEqual(header.number, 300, "entity header number")
  assertEqual(header.bits, bits, "entity header bits")
  decoded = pentity.readDelta(readBuffer, base, header)
  assertEqual(decoded.modelIndex4, 10, "entity model4")
  assertEqual(decoded.frame, 300, "entity frame16")
  assertEqual(decoded.skinNum, 0x12345678, "entity skin32")
  assertEqual(decoded.effects, 0x8000, "entity effects32")
  assertEqual(decoded.renderFx, 300, "entity renderfx16")
  assertEqual(decoded.origin[2], 3.125, "entity origin")
  assertEqual(decoded.angles[0], 90.0, "entity angle1")
  assertEqual(decoded.angles[1], -180.0, "entity signed wire angle2")
  assertEqual(decoded.angles[2], -90.0, "entity angle3")
  assertEqual(decoded.oldOrigin[1], 1.5, "entity old origin")
  assertEqual(decoded.solid, 0x1234, "entity solid")
  assertEqual(readBuffer.readCount, len(golden), "entity message consumed")

  removal = qsz.alloc(8)
  pentity.writeRemoval(removal, 300)
  assertBytes(qsz.dataSlice(removal), bytes([0xc0, 0x01, 0x2c, 0x01]), "entity removal vector")
  removalHeader = pentity.readHeader(readingBuffer(qsz.dataSlice(removal)))
  assertTrue(removalHeader.remove, "entity removal bit")
  endBuffer = qsz.alloc(2)
  pentity.writeEndMarker(endBuffer)
  assertTrue(pentity.readHeader(readingBuffer(qsz.dataSlice(endBuffer))).endMarker, "entity end marker")
  assertTrue(try(pentity.readHeader(readingBuffer(bytes([0x80])))) is error, "truncated continuation rejected")
  assertTrue(try(pentity.readHeader(readingBuffer(bytes([0x80, 0x20, 0x01])))) is error, "reserved entity bit rejected")
  assertTrue(try(pentity.readHeader(readingBuffer(bytes([0x90, 0x80, 0x02, 0x01])))) is error, "contradictory entity frame widths rejected")
  assertTrue(try(pentity.readHeader(readingBuffer(bytes([0xc1, 0x01, 0x2c, 0x01])))) is error, "entity removal payload flags rejected")
  truncated = readingBuffer(slice(golden, 0, len(golden) - 1))
  truncatedHeader = pentity.readHeader(truncated)
  assertTrue(try(pentity.readDelta(truncated, base, truncatedHeader)) is error, "truncated entity payload rejected")
  return true
end function

function testCompletePlayerRoundtrip()
  base = pt.zeroPlayerState()
  target = pt.zeroPlayerState()
  target.pmove.moveType = 1
  target.pmove.origin = [1, 2, 3]
  target.pmove.velocity = [-4, 5, -6]
  target.pmove.time = 7
  target.pmove.flags = 8
  target.pmove.gravity = 750
  target.pmove.deltaAngles = [100, -200, 300]
  target.viewOffset = [0.25, -0.5, 0.75]
  target.viewAngles = [45.0, -90.0, 135.0]
  target.kickAngles = [-1.0, 1.25, -1.5]
  target.gunIndex = 9
  target.gunFrame = 10
  target.gunOffset = [2.0, -2.25, 2.5]
  target.gunAngles = [-3.0, 3.25, -3.5]
  target.blend = [0.1, 0.2, 0.3, 0.4]
  target.fov = 100.0
  target.rdFlags = 3
  target.stats[7] = -321
  buffer = qsz.alloc(256)
  flags = pplayer.writeBody(buffer, base, target)
  assertEqual(flags, pc.PS_ALL, "complete player flags")
  decoded = pplayer.readBody(readingBuffer(qsz.dataSlice(buffer)), base)
  assertEqual(decoded.pmove.velocity[2], -6, "complete player velocity")
  assertEqual(decoded.pmove.deltaAngles[1], -200, "complete player delta angle")
  assertEqual(decoded.viewAngles[1], -90.0, "complete player view angle")
  assertEqual(decoded.kickAngles[2], -1.5, "complete player kick angle")
  assertEqual(decoded.gunFrame, 10, "complete player gun frame")
  assertEqual(decoded.gunOffset[1], -2.25, "complete player gun offset")
  assertEqual(decoded.gunAngles[0], -3.0, "complete player gun angle")
  assertEqual(decoded.stats[7], -321, "complete player stat")
  return true
end function

function testPlayerGolden()
  base = pt.zeroPlayerState()
  target = pt.zeroPlayerState()
  target.pmove.moveType = 2
  target.pmove.origin = [8, -16, 24]
  target.pmove.flags = 5
  target.pmove.gravity = 800
  target.viewOffset = [1.0, -2.0, 3.25]
  target.gunIndex = 4
  target.blend = [1.0, 0.5, 0.0, 0.25]
  target.fov = 90.0
  target.rdFlags = 2
  target.stats[0] = 100
  target.stats[31] = -1
  buffer = qsz.alloc(128)
  flags = pplayer.writeBody(buffer, base, target)
  assertEqual(flags, 0x5cb3, "player delta flags")
  golden = bytes([
    0xb3, 0x5c, 0x02, 0x08, 0x00, 0xf0, 0xff, 0x18, 0x00,
    0x05, 0x20, 0x03, 0x04, 0xf8, 0x0d, 0x04,
    0xff, 0x7f, 0x00, 0x3f, 0x5a, 0x02,
    0x01, 0x00, 0x00, 0x80, 0x64, 0x00, 0xff, 0xff,
  ])
  assertBytes(qsz.dataSlice(buffer), golden, "SV_WritePlayerstateToClient C vector")
  decoded = pplayer.readBody(readingBuffer(golden), base)
  assertEqual(decoded.pmove.moveType, 2, "player pm type")
  assertEqual(decoded.pmove.origin[1], -16, "player origin")
  assertEqual(decoded.pmove.gravity, 800, "player gravity")
  assertEqual(decoded.viewOffset[2], 3.25, "player view offset")
  assertEqual(decoded.gunIndex, 4, "player gun index")
  assertNear(decoded.blend[1], 127.0 / 255.0, 0.000001, "player blend quantization")
  assertEqual(decoded.fov, 90.0, "player fov")
  assertEqual(decoded.stats[0], 100, "player stat zero")
  assertEqual(decoded.stats[31], -1, "player stat 31")
  assertTrue(try(pplayer.readBody(readingBuffer(slice(golden, 0, len(golden) - 1)), base)) is error, "truncated player delta rejected")
  return true
end function

function testCopyRootingSoak()
  entity = pt.zeroEntityState()
  entity.number = 17
  entity.origin = [1.0, 2.0, 3.0]
  entity.angles = [4.0, 5.0, 6.0]
  entity.oldOrigin = [7.0, 8.0, 9.0]
  player = pt.zeroPlayerState()
  player.pmove.origin = [10, 11, 12]
  player.viewAngles = [13.0, 14.0, 15.0]
  player.stats[7] = 77
  command = qt.UserCmd(16, 1, [100, 200, 300], 400, 500, 600, 7, 8)
  entityRing = array(32, void)
  playerRing = array(32, void)
  nestedEntityRing = array(32, void)
  pressure = array(16, void)
  iteration = 0
  while iteration < 2000
    entity = pt.copyEntityState(entity)
    player = pt.copyPlayerState(player)
    command = pt.copyUserCmd(command)
    slot = iteration & 31
    entityRing[slot] = entity
    playerRing[slot] = player
    nestedEntityRing[slot] = [pt.copyEntityState(entity)]
    pressure[iteration & 15] = array(2048, iteration)
    iteration = iteration + 1
  end while
  index = 0
  while index < 32
    assertEqual(entityRing[index].origin, [1.0, 2.0, 3.0], "rooted entity origin " + index)
    assertEqual(entityRing[index].oldOrigin, [7.0, 8.0, 9.0], "rooted entity old origin " + index)
    assertEqual(nestedEntityRing[index][0].origin, [1.0, 2.0, 3.0], "nested rooted entity origin " + index)
    assertEqual(playerRing[index].pmove.origin, [10, 11, 12], "rooted pmove origin " + index)
    assertEqual(playerRing[index].viewAngles, [13.0, 14.0, 15.0], "rooted view angles " + index)
    assertEqual(playerRing[index].stats[7], 77, "rooted stats " + index)
    index = index + 1
  end while
  assertEqual(command.angles, [100, 200, 300], "rooted usercmd angles")
  return true
end function

function main(args)
  print "MiniQuake2 protocol delta tests starting: 5"
  result = try(testUserCmdGolden())
  if result is error then print "FAIL usercmd: " + result.message; return 1 end if
  result = try(testEntityGolden())
  if result is error then print "FAIL entity: " + result.message; return 1 end if
  result = try(testPlayerGolden())
  if result is error then print "FAIL player: " + result.message; return 1 end if
  result = try(testCompletePlayerRoundtrip())
  if result is error then print "FAIL complete player: " + result.message; return 1 end if
  result = try(testCopyRootingSoak())
  if result is error then print "FAIL copy rooting soak: " + result.message; return 1 end if
  print "MiniQuake2 protocol delta tests passed: 5"
  return 0
end function
