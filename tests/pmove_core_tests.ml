/* Golden and deterministic replay tests for Quake II 3.19 PMove. */
import miniquake2.qcommon.constants as qc
import miniquake2.qcommon.types as qt
import miniquake2.game.constants as gc
import miniquake2.game.types as gt
import miniquake2.physics.pmove as phmove
import miniquake2.physics.vector as pmcorevector

WORLD_EMPTY = 0
WORLD_FLOOR = 1
WORLD_STAIR = 2
WORLD_SNAP = 3
WORLD_WALL = 4
WORLD_LADDER = 5

collisionWorld = WORLD_EMPTY
waterContents = 0

function assertEqual(actual, expected, name)
  if actual != expected then return error(9950, name + ": expected " + expected + ", got " + actual) end if
  return true
end function

function assertNear(actual, expected, tolerance, name)
  difference = actual - expected
  if difference < 0.0 then difference = -difference end if
  if difference > tolerance then return error(9951, name + ": outside tolerance; expected " + expected + ", got " + actual) end if
  return true
end function

function defaultPlane()
  return qt.Plane(qt.zeroVec3(), 0.0, 0, 0)
end function

function movementTrace(fraction, endPosition, normal, entity, contents, allSolid, startSolid)
  surface = qt.CollisionSurface("pmove/synthetic", 0, 0)
  return qt.Trace(allSolid, startSolid, fraction, endPosition, qt.Plane(normal, 0.0, 0, 0), surface, contents, entity)
end function

function emptyTrace(start, mins, maxs, finish)
  return movementTrace(1.0, qt.Vec3(finish.x, finish.y, finish.z), qt.zeroVec3(), void, 0, false, false)
end function

function syntheticTrace(start, mins, maxs, finish)
  global collisionWorld
  if collisionWorld == WORLD_EMPTY then return emptyTrace(start, mins, maxs, finish) end if
  if collisionWorld == WORLD_SNAP then
    if start.x == finish.x and start.y == finish.y and start.z == finish.z and start.x < 0.1 then
      return movementTrace(0.0, qt.Vec3(start.x, start.y, start.z), qt.Vec3(0.0, 0.0, 1.0), "snap-obstacle", qc.CONTENTS_SOLID, true, true)
    end if
    return emptyTrace(start, mins, maxs, finish)
  end if
  if collisionWorld == WORLD_LADDER and finish.z == start.z and finish.x - start.x > 0.9 and finish.x - start.x < 1.1 then
    midpoint = qt.Vec3((start.x + finish.x) * 0.5, start.y, start.z)
    return movementTrace(0.5, midpoint, qt.Vec3(-1.0, 0.0, 0.0), "ladder", qc.CONTENTS_LADDER, false, false)
  end if

  startBottom = start.z + mins.z
  finishBottom = finish.z + mins.z
  startTop = start.z + maxs.z
  stepRegion = false
  if collisionWorld == WORLD_STAIR and start.x + maxs.x >= 24.0 then stepRegion = true end if
  if collisionWorld == WORLD_STAIR and finish.x + maxs.x >= 24.0 then stepRegion = true end if
  floorHeight = 0.0
  if stepRegion then floorHeight = 18.0 end if

  // Stationary hull tests are used by ducking and snap validation.
  if start.x == finish.x and start.y == finish.y and start.z == finish.z then
    embedded = startBottom < floorHeight
    if collisionWorld == WORLD_STAIR and stepRegion and startBottom < 18.0 and startTop > 0.0 then embedded = true end if
    if collisionWorld == WORLD_WALL and start.x + maxs.x > 24.0 then embedded = true end if
    if embedded then return movementTrace(0.0, qt.Vec3(start.x, start.y, start.z), qt.Vec3(0.0, 0.0, 1.0), "world", qc.CONTENTS_SOLID, true, true) end if
    return emptyTrace(start, mins, maxs, finish)
  end if

  // The vertical face begins where the player's positive X hull reaches x=24.
  hitsVerticalFace = false
  if collisionWorld == WORLD_STAIR and startBottom < 18.0 then hitsVerticalFace = true end if
  if collisionWorld == WORLD_WALL then hitsVerticalFace = true end if
  if hitsVerticalFace and finish.x > start.x then
    startEdge = start.x + maxs.x
    finishEdge = finish.x + maxs.x
    if startEdge < 24.0 and finishEdge >= 24.0 then
      fraction = (24.0 - startEdge) / (finishEdge - startEdge)
      stopped = qt.Vec3(
        start.x + (finish.x - start.x) * fraction,
        start.y + (finish.y - start.y) * fraction,
        start.z + (finish.z - start.z) * fraction
      )
      return movementTrace(fraction, stopped, qt.Vec3(-1.0, 0.0, 0.0), "step-wall", qc.CONTENTS_SOLID, false, false)
    end if
  end if

  // Swept floor/top test. Starting exactly on a plane is not startsolid.
  if finishBottom < startBottom and startBottom >= floorHeight and finishBottom <= floorHeight then
    fraction = (startBottom - floorHeight) / (startBottom - finishBottom)
    stopped = qt.Vec3(
      start.x + (finish.x - start.x) * fraction,
      start.y + (finish.y - start.y) * fraction,
      start.z + (finish.z - start.z) * fraction
    )
    entity = "floor"
    if floorHeight == 18.0 then entity = "step-top" end if
    return movementTrace(fraction, stopped, qt.Vec3(0.0, 0.0, 1.0), entity, qc.CONTENTS_SOLID, false, false)
  end if
  return emptyTrace(start, mins, maxs, finish)
end function

function syntheticContents(point)
  global waterContents
  return waterContents
end function

function newMove(world, origin, velocity)
  global collisionWorld
  global waterContents
  collisionWorld = world
  waterContents = 0
  value = gt.zeroPmove(syntheticTrace, syntheticContents)
  value.state.origin = [origin[0], origin[1], origin[2]]
  value.state.velocity = [velocity[0], velocity[1], velocity[2]]
  value.state.gravity = 800
  value.command.msec = 100
  return value
end function

function testGroundAccelerationAndFriction()
  accelerated = newMove(WORLD_FLOOR, [0, 0, 192], [0, 0, 0])
  accelerated.command.forwardMove = 300
  phmove.move(accelerated)
  assertEqual(accelerated.state.velocity[0], 2400, "ground acceleration velocity")
  assertEqual(accelerated.state.origin[0], 240, "ground acceleration origin")
  assertEqual(accelerated.state.flags & gc.PMF_ON_GROUND, gc.PMF_ON_GROUND, "ground flag")

  slowed = newMove(WORLD_FLOOR, [0, 0, 192], [1600, 0, 0])
  phmove.move(slowed)
  assertEqual(slowed.state.velocity[0], 640, "ground friction velocity")
  assertEqual(slowed.state.origin[0], 64, "ground friction origin")
  return true
end function

function testAirAndJump()
  airborne = newMove(WORLD_EMPTY, [0, 0, 1600], [0, 0, 0])
  airborne.command.forwardMove = 300
  phmove.move(airborne)
  assertEqual(airborne.state.velocity[0], 240, "air acceleration velocity")
  assertEqual(airborne.state.velocity[2], -640, "air gravity velocity")
  assertEqual(airborne.state.origin[0], 24, "air origin x")
  assertEqual(airborne.state.origin[2], 1536, "air origin z")

  jumped = newMove(WORLD_FLOOR, [0, 0, 192], [0, 0, 0])
  jumped.command.upMove = 10
  phmove.move(jumped)
  assertEqual(jumped.state.velocity[2], 1520, "jump velocity")
  assertEqual(jumped.state.origin[2], 344, "jump origin")
  assertEqual(jumped.state.flags & gc.PMF_JUMP_HELD, gc.PMF_JUMP_HELD, "jump held")
  assertEqual(jumped.state.flags & gc.PMF_ON_GROUND, 0, "jump leaves ground")

  airControlled = newMove(WORLD_EMPTY, [0, 0, 1600], [0, 0, 0])
  airControlled.command.forwardMove = 300
  phmove.moveWithAirAcceleration(airControlled, 1.0)
  assertEqual(airControlled.state.velocity[0], 240, "Quake airaccelerate switch cap")
  return true
end function

function testWaterMove()
  global waterContents
  swimming = newMove(WORLD_FLOOR, [0, 0, 192], [0, 0, 0])
  waterContents = qc.CONTENTS_WATER
  swimming.command.forwardMove = 300
  phmove.move(swimming)
  assertEqual(swimming.waterLevel, 3, "water level")
  assertEqual(swimming.waterType, qc.CONTENTS_WATER, "water type")
  assertEqual(swimming.state.velocity[0], 1200, "water acceleration velocity")
  assertEqual(swimming.state.origin[0], 120, "water movement origin")

  sinking = newMove(WORLD_EMPTY, [0, 0, 1600], [0, 0, 0])
  waterContents = qc.CONTENTS_WATER
  phmove.move(sinking)
  assertEqual(sinking.state.velocity[2], -240, "idle water drift velocity")
  assertEqual(sinking.state.origin[2], 1576, "idle water drift origin")
  waterContents = 0
  return true
end function

function testStairStep()
  stairMove = newMove(WORLD_STAIR, [0, 0, 192], [0, 0, 0])
  stairMove.command.forwardMove = 300
  phmove.move(stairMove)
  assertEqual(stairMove.state.origin[0], 240, "stair horizontal distance")
  assertEqual(stairMove.state.origin[2], 336, "stair top height")
  assertEqual(stairMove.groundEntity, "step-top", "stair ground entity")
  return true
end function

function testWallSlide()
  sliding = newMove(WORLD_WALL, [0, 0, 192], [0, 0, 0])
  sliding.command.forwardMove = 200
  sliding.command.sideMove = 200
  phmove.move(sliding)
  assertEqual(sliding.state.origin[0], 63, "wall slide clipped x")
  assertEqual(sliding.state.origin[1], -160, "wall slide preserved tangent distance")
  assertEqual(sliding.state.velocity[0], -16, "wall slide overbounce x velocity")
  assertEqual(sliding.state.velocity[1], -1600, "wall slide tangent velocity")
  return true
end function

function testLadderMove()
  climbing = newMove(WORLD_LADDER, [0, 0, 192], [0, 0, 0])
  climbing.command.angles[0] = -5461
  climbing.command.forwardMove = 300
  phmove.move(climbing)
  assertEqual(climbing.state.velocity[0], 200, "ladder horizontal clamp")
  assertEqual(climbing.state.velocity[2], 1600, "ladder climb velocity")
  assertEqual(climbing.state.origin[0], 20, "ladder horizontal origin")
  assertEqual(climbing.state.origin[2], 352, "ladder vertical origin")
  return true
end function

function testSpectatorDuckDeadAndGib()
  spectator = newMove(WORLD_EMPTY, [0, 0, 0], [0, 0, 0])
  spectator.state.moveType = gc.PM_SPECTATOR
  spectator.command.forwardMove = 300
  phmove.move(spectator)
  assertEqual(spectator.state.origin[0], 240, "spectator origin")
  assertEqual(spectator.state.velocity[0], 2400, "spectator velocity")
  assertEqual(spectator.viewHeight, 22.0, "spectator view height")

  ducked = newMove(WORLD_FLOOR, [0, 0, 192], [0, 0, 0])
  ducked.state.flags = gc.PMF_ON_GROUND
  ducked.command.upMove = -1
  phmove.move(ducked)
  assertEqual(ducked.state.flags & gc.PMF_DUCKED, gc.PMF_DUCKED, "duck flag")
  assertEqual(ducked.maxs.z, 4.0, "duck max z")
  assertEqual(ducked.viewHeight, -2.0, "duck view height")

  dead = newMove(WORLD_FLOOR, [0, 0, 192], [1600, 0, 0])
  dead.state.moveType = gc.PM_DEAD
  dead.command.forwardMove = 300
  phmove.move(dead)
  assertEqual(dead.command.forwardMove, 0, "dead input cleared")
  assertEqual(dead.state.flags & gc.PMF_DUCKED, gc.PMF_DUCKED, "dead duck flag")
  assertEqual(dead.state.velocity[0], 576, "dead friction velocity")

  gib = newMove(WORLD_FLOOR, [0, 0, 0], [0, 0, 0])
  gib.state.moveType = gc.PM_GIB
  phmove.move(gib)
  assertEqual(gib.mins.z, 0.0, "gib mins")
  assertEqual(gib.maxs.z, 16.0, "gib maxs")
  assertEqual(gib.viewHeight, 8.0, "gib view")
  return true
end function

function testTeleportAndTimeFlags()
  teleported = newMove(WORLD_FLOOR, [0, 0, 192], [0, 0, 0])
  teleported.state.flags = gc.PMF_ON_GROUND | gc.PMF_TIME_TELEPORT
  teleported.state.time = 2
  teleported.command.msec = 8
  teleported.command.forwardMove = 300
  teleported.command.angles[0] = 16384
  phmove.move(teleported)
  assertEqual(teleported.state.time, 1, "teleport timer decrement")
  assertEqual(teleported.state.origin[0], 0, "teleport pause origin")
  assertEqual(teleported.viewAngles.x, 0.0, "teleport pitch clamp")

  phmove.move(teleported)
  assertEqual(teleported.state.time, 0, "teleport timer expiration")
  assertEqual(teleported.state.flags & gc.PMF_TIME_TELEPORT, 0, "teleport flag expiration")
  assertEqual(teleported.state.origin[0], 1, "movement resumes on expiration frame")

  landing = newMove(WORLD_FLOOR, [0, 0, 192], [0, 0, 0])
  landing.state.flags = gc.PMF_ON_GROUND | gc.PMF_TIME_LAND
  landing.state.time = 2
  landing.command.msec = 8
  landing.command.upMove = 20
  phmove.move(landing)
  assertEqual(landing.state.velocity[2], 0, "land timer suppresses jump")
  phmove.move(landing)
  assertEqual(landing.state.velocity[2] > 0, true, "jump resumes on land timer expiration")

  waterJump = newMove(WORLD_EMPTY, [0, 0, 1600], [400, 0, 80])
  waterJump.state.flags = gc.PMF_TIME_WATERJUMP
  waterJump.state.time = 100
  phmove.move(waterJump)
  assertEqual(waterJump.state.flags & gc.PMF_TIME_WATERJUMP, 0, "falling cancels waterjump")
  assertEqual(waterJump.state.time, 0, "waterjump cancellation clears timer")
  assertEqual(waterJump.state.velocity[2], -560, "waterjump gravity")
  return true
end function

function testAngleClampAndFreeze()
  frozen = newMove(WORLD_EMPTY, [8, 16, 1600], [80, 0, 0])
  frozen.state.moveType = gc.PM_FREEZE
  frozen.command.angles = [16384, 32767, 0]
  frozen.state.deltaAngles = [0, 1, 0]
  phmove.move(frozen)
  assertEqual(frozen.viewAngles.x, 89.0, "pitch clamp")
  assertEqual(frozen.viewAngles.y, -180.0, "signed short angle wrap")
  assertEqual(frozen.state.origin[0], 8, "freeze origin")
  assertEqual(frozen.state.velocity[0], 80, "freeze velocity")
  assertEqual(frozen.viewHeight, 0.0, "freeze skips hull setup")
  return true
end function

function testSnapJitterAndShortWrap()
  snapped = newMove(WORLD_SNAP, [0, 0, 1600], [0, 0, 0])
  snapped.command.forwardMove = 1
  phmove.move(snapped)
  assertEqual(snapped.state.origin[0], 1, "snap jitter selects positive eighth")

  initial = newMove(WORLD_SNAP, [0, 0, 1600], [0, 0, 0])
  initial.snapInitial = true
  initial.command.msec = 0
  phmove.move(initial)
  assertEqual(initial.state.origin[0], 1, "initial snap searches x offsets")

  wrapped = newMove(WORLD_EMPTY, [0, 0, 1600], [40000, 0, 0])
  wrapped.command.msec = 0
  phmove.move(wrapped)
  assertEqual(wrapped.state.velocity[0], -25536, "fixed-point signed short wrap")
  return true
end function

function runReplay()
  replay = newMove(WORLD_FLOOR, [0, 0, 192], [0, 0, 0])
  frame = 0
  while frame < 12
    replay.command.msec = 16
    replay.command.forwardMove = 200
    replay.command.sideMove = 0
    replay.command.upMove = 0
    if frame == 3 then replay.command.upMove = 20 end if
    if frame >= 6 then replay.command.forwardMove = 0; replay.command.sideMove = 160 end if
    phmove.move(replay)
    frame = frame + 1
  end while
  return [
    replay.state.origin[0], replay.state.origin[1], replay.state.origin[2],
    replay.state.velocity[0], replay.state.velocity[1], replay.state.velocity[2],
    replay.state.flags, replay.state.time
  ]
end function

function testDeterministicReplay()
  first = runReplay()
  second = runReplay()
  assertEqual(len(first), len(second), "replay state length")
  index = 0
  while index < len(first)
    assertEqual(first[index], second[index], "replay component " + index)
    index = index + 1
  end while
  // This is the fixed-point golden state for the synthetic 12-frame stream.
  assertEqual(first[0], 116, "replay golden origin x")
  assertEqual(first[1], -3, "replay golden origin y")
  assertEqual(first[2], 424, "replay golden origin z")
  return true
end function

function testVectorGcHardening()
  assertEqual(typeof(try(pmcorevector.copy(17))), "error", "physics vector rejects scalar shape")
  assertEqual(typeof(try(pmcorevector.copy(defaultPlane()))), "error", "physics vector rejects non-Vec3 struct")
  assertEqual(typeof(try(pmcorevector.setComponent("bad", 0, 1.0))), "error", "physics setComponent rejects shape")

  base = qt.Vec3(3.0, 4.0, 12.0)
  direction = qt.Vec3(-2.0, 5.0, 1.0)
  zeroAngles = qt.Vec3(0.0, 0.0, 0.0)
  iteration = 0
  checksum = 0.0
  while iteration < 6000
    copied = pmcorevector.copy(base)
    copiedX = copied.x; copiedY = copied.y; copiedZ = copied.z
    added = pmcorevector.add(base, direction)
    addedX = added.x; addedY = added.y; addedZ = added.z
    subtracted = pmcorevector.subtract(base, direction)
    subtractedX = subtracted.x; subtractedY = subtracted.y; subtractedZ = subtracted.z
    scaled = pmcorevector.scale(base, 0.5)
    scaledX = scaled.x; scaledY = scaled.y; scaledZ = scaled.z
    multiplied = pmcorevector.multiplyAdd(base, 2.0, direction)
    multipliedX = multiplied.x; multipliedY = multiplied.y; multipliedZ = multiplied.z
    dotValue = pmcorevector.dot(base, direction)
    crossed = pmcorevector.cross(base, direction)
    crossedX = crossed.x; crossedY = crossed.y; crossedZ = crossed.z
    lengthValue = pmcorevector.length(base)
    normalized = pmcorevector.normalized(base)
    normalizedVector = normalized[0]
    normalizedX = normalizedVector.x; normalizedY = normalizedVector.y; normalizedZ = normalizedVector.z
    normalizedLength = normalized[1]
    componentValue = pmcorevector.component(base, 1)
    mutableValue = pmcorevector.copy(base)
    mutableValue = pmcorevector.setComponent(mutableValue, 2, -7.0)
    mutableZ = mutableValue.z
    basis = pmcorevector.angleVectors(zeroAngles)
    forward = basis[0]; right = basis[1]; up = basis[2]
    forwardX = forward.x; rightY = right.y; upZ = up.z

    checksum = copiedX + copiedY + copiedZ + addedX + addedY + addedZ +
      subtractedX + subtractedY + subtractedZ + scaledX + scaledY + scaledZ +
      multipliedX + multipliedY + multipliedZ + dotValue + crossedX + crossedY + crossedZ +
      lengthValue + normalizedX + normalizedY + normalizedZ + normalizedLength +
      componentValue + mutableZ + forwardX + rightY + upZ
    iteration = iteration + 1
  end while
  assertNear(checksum, 83.5 + 19.0 / 13.0, 0.0000001, "physics vector low-GC checksum")
  return true
end function

function main(args)
  testGroundAccelerationAndFriction()
  testAirAndJump()
  testWaterMove()
  testStairStep()
  testWallSlide()
  testLadderMove()
  testSpectatorDuckDeadAndGib()
  testTeleportAndTimeFlags()
  testAngleClampAndFreeze()
  testSnapJitterAndShortWrap()
  testDeterministicReplay()
  testVectorGcHardening()
  print "pmove_core_tests: PASS"
  return 0
end function
