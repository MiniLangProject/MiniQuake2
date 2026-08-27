/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Dynamic SOLID_BBOX SV_ClipMoveToEntities and PMove regressions. */
import miniquake2.server.game_bridge as bboxbridge
import miniquake2.game.constants as bboxgc
import miniquake2.game.types as bboxgt
import miniquake2.qcommon.constants as bboxqc
import miniquake2.qcommon.types as bboxqt

bboxImports = void
bboxPmovePass = void

// Store bbox game data.
struct BboxGame
  edicts
  numEdicts
end struct

// Assert the bbox test condition.
function bboxAssert(value, message)
  if value != true then return error(9890, message) end if
  return true
end function

// Return the bbox near value.
function bboxNear(actual, expected, tolerance, message)
  difference = actual - expected
  if difference < 0.0 then difference = -difference end if
  if difference > tolerance then return error(9891, message) end if
  return true
end function

// Create bbox.
function bboxMake(number, x, y, z, serverFlags)
  global bboxImports
  entity = bboxgt.zeroEdict(number)
  entity.inUse = true
  entity.solid = bboxgc.SOLID_BBOX
  entity.serverFlags = serverFlags
  entity.state.origin = bboxqt.Vec3(x, y, z)
  entity.mins = bboxqt.Vec3(-16.0, -16.0, -24.0)
  entity.maxs = bboxqt.Vec3(16.0, 16.0, 32.0)
  bboxImports.linkEntity(entity)
  return entity
end function

// Trace bbox pmove.
function bboxPmoveTrace(start, mins, maxs, finish)
  global bboxImports
  global bboxPmovePass
  return bboxImports.trace(start, mins, maxs, finish, bboxPmovePass,
    bboxqc.MASK_PLAYERSOLID)
end function

// Return the bbox pmove contents value.
function bboxPmoveContents(point)
  return 0
end function

runtime = bboxbridge.createRuntime(1)
bboxImports = bboxbridge.makeImports(runtime)
world = bboxgt.zeroEdict(0)
world.inUse = true
runtime.game = BboxGame([world], 1)

player = bboxMake(1, 0.0, 0.0, 32.0, 0)
monster = bboxMake(2, 50.0, 0.0, 32.0, bboxgc.SVF_MONSTER)
bboxAssert(runtime.solidBoxCount == 2 and
  runtime.solidBoxPositions[1] > 0 and runtime.solidBoxPositions[2] > 0,
  "linked SOLID_BBOX index membership")
bboxAssert(player.state.solid == (2 | (3 << 5) | (8 << 10)) and
  monster.state.solid == player.state.solid,
  "SV_LinkEdict Protocol-34 BBOX encoding")

zero = bboxqt.zeroVec3()
forward = bboxImports.trace(bboxqt.Vec3(0.0, 0.0, 32.0), zero, zero,
  bboxqt.Vec3(100.0, 0.0, 32.0), player, bboxqc.MASK_PLAYERSOLID)
bboxNear(forward.fraction, 0.3396875, 0.00001,
  "point sweep against monster fraction")
bboxAssert(forward.entity is not void and forward.entity.state.number == monster.state.number and
  forward.contents == bboxqc.CONTENTS_MONSTER,
  "player trace identifies monster and hull contents")
bboxAssert(forward.plane.normal.x == -1.0 and forward.plane.type == 3 and
  forward.plane.signBits == 1 and forward.plane.dist == 16.0,
  "minimum-X box plane semantics")

reverse = bboxImports.trace(bboxqt.Vec3(100.0, 0.0, 32.0), zero, zero,
  bboxqt.Vec3(0.0, 0.0, 32.0), player, bboxqc.MASK_PLAYERSOLID)
bboxNear(reverse.fraction, 0.3396875, 0.00001,
  "reverse point sweep fraction")
bboxAssert(reverse.plane.normal.x == 1.0 and reverse.plane.type == 0 and
  reverse.plane.signBits == 0 and reverse.plane.dist == 16.0,
  "maximum-X box plane semantics")
vertical = bboxImports.trace(bboxqt.Vec3(50.0, 0.0, 100.0), zero, zero,
  bboxqt.Vec3(50.0, 0.0, 0.0), player, bboxqc.MASK_PLAYERSOLID)
bboxNear(vertical.fraction, 0.3596875, 0.00001,
  "vertical point sweep fraction")
bboxAssert(vertical.plane.normal.z == 1.0 and vertical.plane.type == 2 and
  vertical.plane.dist == 32.0,
  "maximum-Z box plane semantics")

playerMins = bboxqt.Vec3(-16.0, -16.0, -24.0)
playerMaxs = bboxqt.Vec3(16.0, 16.0, 32.0)
hull = bboxImports.trace(bboxqt.Vec3(0.0, 0.0, 32.0), playerMins,
  playerMaxs, bboxqt.Vec3(100.0, 0.0, 32.0), player,
  bboxqc.MASK_PLAYERSOLID)
bboxNear(hull.fraction, 0.1796875, 0.00001,
  "moving player hull Minkowski fraction")

stationary = bboxImports.trace(bboxqt.Vec3(50.0, 0.0, 32.0), zero, zero,
  bboxqt.Vec3(50.0, 0.0, 32.0), player, bboxqc.MASK_PLAYERSOLID)
bboxAssert(stationary.entity is not void and stationary.entity.state.number == monster.state.number and stationary.startSolid and
  stationary.allSolid and stationary.fraction == 0.0,
  "stationary CM_TestBoxInBrush start/all solid")
leaving = bboxImports.trace(bboxqt.Vec3(50.0, 0.0, 32.0), zero, zero,
  bboxqt.Vec3(100.0, 0.0, 32.0), player, bboxqc.MASK_PLAYERSOLID)
bboxAssert(leaving.entity is not void and leaving.entity.state.number == monster.state.number and leaving.startSolid and
  leaving.allSolid == false and leaving.fraction == 1.0,
  "moving trace may leave a start-solid box")

wrongMask = bboxImports.trace(bboxqt.Vec3(0.0, 0.0, 32.0), zero, zero,
  bboxqt.Vec3(100.0, 0.0, 32.0), player, bboxqc.MASK_SOLID)
bboxAssert(wrongMask.fraction == 1.0 and wrongMask.entity is void,
  "temporary box hull requires CONTENTS_MONSTER")

ownedMissile = bboxMake(3, 60.0, 100.0, 32.0, 0)
ownedMissile.owner = player
ownerSkip = bboxImports.trace(bboxqt.Vec3(0.0, 100.0, 32.0), zero, zero,
  bboxqt.Vec3(100.0, 100.0, 32.0), player, bboxqc.MASK_SHOT)
bboxAssert(ownerSkip.fraction == 1.0,
  "passed owner excludes owned missile")
passMissile = bboxgt.zeroEdict(4)
passMissile.owner = ownedMissile
missileOwnerSkip = bboxImports.trace(bboxqt.Vec3(0.0, 100.0, 32.0), zero,
  zero, bboxqt.Vec3(100.0, 100.0, 32.0), passMissile, bboxqc.MASK_SHOT)
bboxAssert(missileOwnerSkip.fraction == 1.0,
  "passed missile excludes its owner")

deadMonster = bboxMake(5, 60.0, 200.0, 32.0,
  bboxgc.SVF_MONSTER | bboxgc.SVF_DEADMONSTER)
bboxAssert(deadMonster.state.solid == 0,
  "dead monster is not published as a predictive packet solid")
deadSkipped = bboxImports.trace(bboxqt.Vec3(0.0, 200.0, 32.0), zero, zero,
  bboxqt.Vec3(100.0, 200.0, 32.0), void, bboxqc.MASK_PLAYERSOLID)
bboxAssert(deadSkipped.fraction == 1.0,
  "SVF_DEADMONSTER excluded without CONTENTS_DEADMONSTER")
deadShot = bboxImports.trace(bboxqt.Vec3(0.0, 200.0, 32.0), zero, zero,
  bboxqt.Vec3(100.0, 200.0, 32.0), void, bboxqc.MASK_SHOT)
bboxAssert(deadShot.entity is not void and deadShot.entity.state.number == deadMonster.state.number and
  deadShot.fraction < 1.0,
  "MASK_SHOT includes a dead monster box")

beforeUnlink = runtime.solidBoxCount
bboxImports.unlinkEntity(ownedMissile)
bboxAssert(runtime.solidBoxCount == beforeUnlink - 1 and
  runtime.solidBoxPositions[3] == 0 and runtime.solidBoxPositions[5] > 0,
  "indexed BBOX swap-delete remains coherent")
unlinkedTrace = bboxImports.trace(bboxqt.Vec3(0.0, 100.0, 32.0), zero, zero,
  bboxqt.Vec3(100.0, 100.0, 32.0), void, bboxqc.MASK_SHOT)
bboxAssert(unlinkedTrace.fraction == 1.0,
  "unlinked BBOX is absent without an allocated-edict scan")

// Asset-free save/game graphs may link a BSP-shaped helper without a loaded
// collision map. It remains indexed for later activation, but tracing must
// retain the valid empty-world behavior rather than dereference map on void.
runtime.modelNames[1] = "*1"
headlessBrush = bboxgt.zeroEdict(6)
headlessBrush.inUse = true
headlessBrush.solid = bboxgc.SOLID_BSP
headlessBrush.state.modelIndex = 1
headlessBrush.state.origin = bboxqt.Vec3(60.0, 300.0, 32.0)
headlessBrush.mins = bboxqt.Vec3(-8.0, -8.0, -8.0)
headlessBrush.maxs = bboxqt.Vec3(8.0, 8.0, 8.0)
bboxImports.linkEntity(headlessBrush)
headlessTrace = bboxImports.trace(bboxqt.Vec3(0.0, 300.0, 32.0), zero,
  zero, bboxqt.Vec3(100.0, 300.0, 32.0), void, bboxqc.MASK_SOLID)
bboxAssert(runtime.inlineBrushCount == 1 and headlessTrace.fraction == 1.0,
  "headless inline cache trace does not dereference a void collision map")

// Exercise the actual PMove callback graph: a moving player must clip and
// report the linked monster instead of passing through it.
bboxPmovePass = player
move = bboxgt.zeroPmove(bboxPmoveTrace, bboxPmoveContents)
move.state.origin = [0, 0, 256]
move.state.velocity = [3200, 0, 0]
move.state.gravity = 0
move.command.msec = 100
bboxImports.pmove(move)
bboxAssert(move.state.origin[0] <= 144 and move.numTouch > 0,
  "authoritative PMove stops at linked monster BBOX")
touchedMonster = false
touchIndex = 0
while touchIndex < move.numTouch
  if move.touchEntities[touchIndex] is not void and
      move.touchEntities[touchIndex].state.number == monster.state.number then
    touchedMonster = true
  end if
  touchIndex = touchIndex + 1
end while
bboxAssert(touchedMonster, "PMove touch list retains monster identity")

print "server_game_bridge_bbox_trace_tests: PASS"
