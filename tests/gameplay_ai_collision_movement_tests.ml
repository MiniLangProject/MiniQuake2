/* Deterministic m_move.c stairs, ledges, water and flight regression. */
import miniquake2.game.ai.constants as movementconstants
import miniquake2.game.ai.move as movement
import miniquake2.game.ai.monster as movementmonster
import miniquake2.game.ai.types as movementtypes
import miniquake2.game.types as movementgametypes
import miniquake2.qcommon.constants as movementqconstants
import miniquake2.qcommon.types as movementqtypes

movementGround = movementgametypes.zeroEdict(0)
movementLinkCount = 0
movementTouchCount = 0

function movementAssert(value, message)
  if value != true then return error(9890, message) end if
  return true
end function

function movementNear(actual, expected, tolerance, message)
  difference = actual - expected
  if difference < 0.0 then difference = -difference end if
  if difference > tolerance then return error(9891, message) end if
  return true
end function

// Flat floor, a legal sixteen-unit stair, then a missing bridge edge.
function movementFloorHeight(x)
  if x >= 128.0 then return -1000000.0 end if
  if x >= 64.0 then return 16.0 end if
  return 0.0
end function

function movementContents(point)
  floor = movementFloorHeight(point.x)
  if floor > -999999.0 and point.z <= floor then
    return movementqconstants.CONTENTS_SOLID
  end if
  if point.x < -20.0 and point.z < 64.0 then
    return movementqconstants.CONTENTS_WATER
  end if
  return 0
end function

function movementTrace(start, mins, maxs, finish, actor, mask)
  plane = movementqtypes.Plane(movementqtypes.Vec3(0.0, 0.0, 1.0),
    0.0, 2, 0)
  surface = movementqtypes.CollisionSurface("floor", 0, 0)
  floor = movementFloorHeight(finish.x)
  if finish.z < start.z and floor > -999999.0 then
    contactZ = floor - mins.z
    if start.z >= contactZ and finish.z <= contactZ then
      fraction = (start.z - contactZ) / (start.z - finish.z)
      endPosition = movementqtypes.Vec3(
        start.x + (finish.x - start.x) * fraction,
        start.y + (finish.y - start.y) * fraction,
        contactZ)
      return movementqtypes.Trace(false, false, fraction, endPosition, plane,
        surface, movementqconstants.CONTENTS_SOLID, movementGround)
    end if
  end if
  return movementqtypes.Trace(false, false, 1.0,
    movementqtypes.Vec3(finish.x, finish.y, finish.z), plane, surface, 0, void)
end function

function movementLink(actor)
  global movementLinkCount
  movementLinkCount = movementLinkCount + 1
  actor.edict.linkCount = actor.edict.linkCount + 1
  return true
end function

function movementTouch(actor)
  global movementTouchCount
  movementTouchCount = movementTouchCount + 1
  return true
end function

function movementRandom()
  return 0
end function

function movementContext()
  context = movementtypes.defaultContext()
  context.moveTrace = movementTrace
  context.pointContents = movementContents
  context.linkActor = movementLink
  context.touchActorTriggers = movementTouch
  context.nextRandomInteger = movementRandom
  return context
end function

function movementActor(number)
  actor = movementtypes.createActor(number, "monster_test")
  actor.edict.mins = movementqtypes.Vec3(-16.0, -16.0, -24.0)
  actor.edict.maxs = movementqtypes.Vec3(16.0, 16.0, 32.0)
  actor.edict.state.origin = movementqtypes.Vec3(0.0, 0.0, 100.0)
  return actor
end function

context = movementContext()
actor = movementActor(1)
movementAssert(movement.InitializeActor(actor, context),
  "walk monster did not drop to the floor")
movementNear(actor.edict.state.origin.z, 24.0, 0.0001,
  "drop-to-floor origin")
movementAssert(actor.groundEntity is not void and actor.waterLevel == 0,
  "ground/water initialization")

movementAssert(movement.WalkMove(actor, 0.0, 16.0, context),
  "flat walk failed")
movementNear(actor.edict.state.origin.x, 16.0, 0.0001, "flat walk x")
actor.edict.state.origin.x = 48.0
actor.edict.state.origin.z = 24.0
movementAssert(movement.WalkMove(actor, 0.0, 20.0, context),
  "sixteen-unit stair was rejected")
movementNear(actor.edict.state.origin.x, 68.0, 0.0001, "stair x")
movementNear(actor.edict.state.origin.z, 40.0, 0.0001, "stair z")

movementAssert(movement.WalkMove(actor, 0.0, 56.0, context) == false,
  "unsupported ledge move was accepted")
movementNear(actor.edict.state.origin.x, 68.0, 0.0001,
  "ledge rejection did not restore x")
movementNear(actor.edict.state.origin.z, 40.0, 0.0001,
  "ledge rejection did not restore z")

actor.edict.state.origin.x = 0.0
actor.edict.state.origin.z = 24.0
actor.groundEntity = movementGround
actor.waterLevel = 0
movementAssert(movement.WalkMove(actor, 180.0, 40.0, context) == false,
  "dry walk monster entered water")
movementNear(actor.edict.state.origin.x, 0.0, 0.0001,
  "water rejection changed walk origin")

flyer = movementActor(2)
flyer.flags = flyer.flags | movementconstants.FL_FLY
flyer.edict.state.origin.z = 64.0
flyer.movementInitialized = true
movementAssert(movement.WalkMove(flyer, 180.0, 40.0, context) == false,
  "dry flyer entered water")
movementAssert(movement.WalkMove(flyer, 0.0, 20.0, context),
  "unobstructed flyer move failed")
movementNear(flyer.edict.state.origin.x, 20.0, 0.0001, "flyer x")

actor.edict.state.origin.x = 112.0
actor.edict.state.origin.z = 40.0
actor.groundEntity = movementGround
actor.flags = actor.flags | movementconstants.FL_PARTIALGROUND
movementAssert(movement.WalkMove(actor, 0.0, 32.0, context),
  "partial-ground monster did not follow removed bridge")
movementAssert(actor.groundEntity is void,
  "partial-ground bridge fall retained ground entity")
movementAssert(movementLinkCount > 0 and movementTouchCount > 0,
  "successful movement did not link and touch triggers")

// g_monster.c::monster_think refreshes ground state after a relink and water
// state every frame, not only while an explicit walk move is being attempted.
thinker = movementActor(3)
thinker.edict.state.origin = movementqtypes.Vec3(-40.0, 0.0, 24.0)
thinker.edict.linkCount = 1
thinker.info.linkCount = 0
thinker.info.currentMove = movementtypes.MonsterMove("stand", 0, 0,
  [movementtypes.MonsterFrame(void, 0.0, void)], void)
thinker.edict.state.frame = 0
thinker.activity = "stand"
movementAssert(movementmonster.MonsterThink(thinker, context),
  "monster think failed")
movementAssert(thinker.groundEntity is not void,
  "monster think did not refresh ground after relink")
movementAssert(thinker.waterLevel == 3 and thinker.waterType == movementqconstants.CONTENTS_WATER,
  "monster think did not categorize water position")

print "gameplay_ai_collision_movement_tests: PASS"
