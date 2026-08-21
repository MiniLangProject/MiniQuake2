/* Transactional pusher, rider, rotation and team rollback scenarios. */
import miniquake2.game.base.spawn as pushertestspawn
import miniquake2.game.integration.baseq2 as pushertestintegration
import miniquake2.game.integration.pusher as pushertestphysics
import miniquake2.game.world.core as pushertestworld
import miniquake2.game.world.types as pushertesttypes
import miniquake2.game.world.constants as pushertestconstants
import miniquake2.qcommon.types as pushertestqtypes

blockedCount = 0

function pusherAssert(value, message)
  if value != true then return error(9896, message) end if
  return true
end function

function pusherNear(actual, expected, tolerance, message)
  difference = actual - expected
  if difference < 0.0 then difference = -difference end if
  return pusherAssert(difference <= tolerance, message)
end function

function recordBlocked(entity, other, world)
  global blockedCount
  blockedCount = blockedCount + 1
  return true
end function

function emptyRuntime()
  return pushertestintegration.create(pushertestspawn.SpawnEntities("pusher", "{\"classname\" \"worldspawn\"}", ""))
end function

function platform(number)
  entity = pushertesttypes.createEntity(number, "func_train")
  entity.solid = pushertestconstants.SOLID_BSP
  entity.moveType = pushertestconstants.MOVETYPE_PUSH
  entity.mins = pushertestqtypes.Vec3(-10.0, -10.0, -1.0)
  entity.maxs = pushertestqtypes.Vec3(10.0, 10.0, 1.0)
  entity.blocked = recordBlocked
  entity.teamMaster = entity
  return entity
end function

function repeatedRotatingPusherMaps()
  iteration = 0
  while iteration < 96
    repeatedRuntime = emptyRuntime()
    repeatedRiders = []
    pusherIndex = 0
    while pusherIndex < 8
      number = 100 + pusherIndex * 2
      baseX = pusherIndex * 64.0
      repeatedPusher = platform(number)
      repeatedPusher.origin = pushertestqtypes.Vec3(baseX, 0.0, 0.0)
      repeatedPusher.mins = pushertestqtypes.Vec3(-8.0, -8.0, -1.0)
      repeatedPusher.maxs = pushertestqtypes.Vec3(8.0, 8.0, 1.0)
      repeatedPusher.angularVelocity = pushertestqtypes.Vec3(0.0, 900.0, 0.0)
      repeatedRider = pushertesttypes.createEntity(number + 1, "repeated-rider")
      repeatedRider.solid = pushertestconstants.SOLID_BBOX
      repeatedRider.mins = pushertestqtypes.Vec3(-0.5, -0.5, 0.0)
      repeatedRider.maxs = pushertestqtypes.Vec3(0.5, 0.5, 1.0)
      repeatedRider.origin = pushertestqtypes.Vec3(baseX + 5.0, 0.0, 1.0)
      pushertestworld.addEntity(repeatedRuntime.world, repeatedPusher)
      pushertestworld.addEntity(repeatedRuntime.world, repeatedRider)
      repeatedRiders = repeatedRiders + [repeatedRider]
      pusherIndex = pusherIndex + 1
    end while
    repeatedCapture = pushertestphysics.capture(repeatedRuntime)
    pushertestworld.runFrame(repeatedRuntime.world)
    movedTeams = pushertestphysics.resolve(repeatedRuntime, repeatedCapture)
    pusherAssert(movedTeams == 8, "repeated rotated map did not resolve every pusher")
    pusherIndex = 0
    while pusherIndex < len(repeatedRiders)
      expectedX = pusherIndex * 64.0
      pusherNear(repeatedRiders[pusherIndex].origin.x, expectedX, 0.01,
        "repeated rotated rider x")
      pusherNear(repeatedRiders[pusherIndex].origin.y, 5.0, 0.01,
        "repeated rotated rider y")
      pusherIndex = pusherIndex + 1
    end while
    iteration = iteration + 1
  end while
  return true
end function

runtime = emptyRuntime()
moving = platform(10)
moving.velocity = pushertestqtypes.Vec3(10.0, 0.0, 0.0)
rider = pushertesttypes.createEntity(11, "rider")
rider.solid = pushertestconstants.SOLID_BBOX
rider.mins = pushertestqtypes.Vec3(-1.0, -1.0, 0.0)
rider.maxs = pushertestqtypes.Vec3(1.0, 1.0, 2.0)
rider.origin = pushertestqtypes.Vec3(0.0, 0.0, 1.0)
pushertestworld.addEntity(runtime.world, moving)
pushertestworld.addEntity(runtime.world, rider)
state = pushertestphysics.capture(runtime)
pushertestworld.runFrame(runtime.world)
pushertestphysics.resolve(runtime, state)
pusherAssert(moving.origin.x == 1.0 and rider.origin.x == 1.0, "linear platform carries standing rider")

runtime = emptyRuntime()
rotating = platform(20)
rotating.mins = pushertestqtypes.Vec3(-8.0, -8.0, -1.0)
rotating.maxs = pushertestqtypes.Vec3(8.0, 8.0, 1.0)
rotating.angularVelocity = pushertestqtypes.Vec3(0.0, 900.0, 0.0)
rotatingRider = pushertesttypes.createEntity(21, "rotating-rider")
rotatingRider.solid = pushertestconstants.SOLID_BBOX
rotatingRider.mins = pushertestqtypes.Vec3(-0.5, -0.5, 0.0)
rotatingRider.maxs = pushertestqtypes.Vec3(0.5, 0.5, 1.0)
rotatingRider.origin = pushertestqtypes.Vec3(5.0, 0.0, 1.0)
pushertestworld.addEntity(runtime.world, rotating)
pushertestworld.addEntity(runtime.world, rotatingRider)
state = pushertestphysics.capture(runtime)
pushertestworld.runFrame(runtime.world)
pushertestphysics.resolve(runtime, state)
pusherNear(rotatingRider.origin.x, 0.0, 0.01, "rotating platform rider x")
pusherNear(rotatingRider.origin.y, 5.0, 0.01, "rotating platform carries rider around pivot")

runtime = emptyRuntime()
first = platform(30); first.team = "paired"; first.velocity = pushertestqtypes.Vec3(10.0, 0.0, 0.0)
second = platform(31); second.team = "paired"; second.origin = pushertestqtypes.Vec3(20.0, 0.0, 0.0); second.velocity = pushertestqtypes.Vec3(10.0, 0.0, 0.0)
first.mins = pushertestqtypes.Vec3(-1.0, -1.0, -1.0); first.maxs = pushertestqtypes.Vec3(1.0, 1.0, 1.0)
second.mins = pushertestqtypes.Vec3(-1.0, -1.0, -1.0); second.maxs = pushertestqtypes.Vec3(1.0, 1.0, 1.0)
obstacle = pushertesttypes.createEntity(32, "obstacle")
obstacle.solid = pushertestconstants.SOLID_BBOX
obstacle.mins = pushertestqtypes.Vec3(-0.5, -0.5, -0.5); obstacle.maxs = pushertestqtypes.Vec3(0.5, 0.5, 0.5)
obstacle.origin = pushertestqtypes.Vec3(2.0, 0.0, 0.0)
pushertestworld.addEntity(runtime.world, first); pushertestworld.addEntity(runtime.world, second); pushertestworld.addEntity(runtime.world, obstacle)
pushertestphysics.assembleTeams(runtime.world)
state = pushertestphysics.capture(runtime)
pushertestworld.runFrame(runtime.world)
pushertestphysics.resolve(runtime, state)
pusherAssert(first.origin.x == 0.0 and second.origin.x == 20.0, "blocked team rolls every member back")
pusherAssert(first.teamMaster.number == first.number and second.teamMaster.number == first.number, "team master and slave synchronized")
pusherAssert(blockedCount == 1, "blocked callback dispatched once")

repeatedRotatingPusherMaps()
malformedBounds = try(pushertestphysics.rotatedBounds(void, pushertestqtypes.zeroVec3(),
  pushertestqtypes.zeroVec3(), pushertestqtypes.zeroVec3()))
pusherAssert(malformedBounds is error, "malformed rotated bounds were not rejected")
pusherAssert(malformedBounds.message == "rotatedBounds requires Vec3-shaped inputs",
  "malformed rotated bounds diagnostic changed")

print "gameplay_pusher_physics_tests: PASS"
