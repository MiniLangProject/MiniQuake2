/* Synthetic collision fixtures for the Quake II CM contract. */
import miniquake2.format.constants as c
import miniquake2.format.types as t
import miniquake2.collision.model as cm
import miniquake2.game.weapons.vector as cmvector

function assertEqual(actual, expected, name)
  if actual != expected then return error(9910, name + ": expected " + expected + ", got " + actual) end if
  return true
end function

function assertNear(actual, expected, tolerance, name)
  difference = actual - expected
  if difference < 0.0 then difference = -difference end if
  if difference > tolerance then return error(9911, name + ": outside tolerance") end if
  return true
end function

function makeFixture()
  planes = [
    t.BspPlane(t.Vec3(1.0, 0.0, 0.0), 0.0, 0),
    t.BspPlane(t.Vec3(1.0, 0.0, 0.0), 1.0, 0),
    t.BspPlane(t.Vec3(-1.0, 0.0, 0.0), 1.0, 3),
    t.BspPlane(t.Vec3(0.0, 1.0, 0.0), 1.0, 1),
    t.BspPlane(t.Vec3(0.0, -1.0, 0.0), 1.0, 4),
    t.BspPlane(t.Vec3(0.0, 0.0, 1.0), 1.0, 2),
    t.BspPlane(t.Vec3(0.0, 0.0, -1.0), 1.0, 5),
  ]
  nodes = [t.BspNode(0, -1, -2, t.Vec3(-16.0, -16.0, -16.0), t.Vec3(16.0, 16.0, 16.0), 0, 0)]
  texture = t.BspTexInfo([], [], c.SURF_SLICK, 7, "collision/test", -1)
  sides = [t.BspBrushSide(1, 0), t.BspBrushSide(2, 0), t.BspBrushSide(3, 0), t.BspBrushSide(4, 0), t.BspBrushSide(5, 0), t.BspBrushSide(6, 0)]
  brushes = [t.BspBrush(0, 6, c.CONTENTS_SOLID)]
  leafs = [
    t.BspLeaf(0, 0, 1, t.Vec3(0.0, -16.0, -16.0), t.Vec3(16.0, 16.0, 16.0), 0, 0, 0, 0),
    t.BspLeaf(c.CONTENTS_SOLID, -1, 2, t.Vec3(-16.0, -16.0, -16.0), t.Vec3(0.0, 16.0, 16.0), 0, 0, 0, 1),
  ]
  areas = [t.BspArea(0, 0), t.BspArea(1, 0), t.BspArea(1, 1)]
  portals = [t.BspAreaPortal(0, 2), t.BspAreaPortal(0, 1)]
  map = t.BspMap("fixture", bytes(0), [], "", planes, [], t.BspVisibility(0, [], [], bytes(0)), nodes, [texture], [], bytes(0), leafs, [], [0], [], [], [], brushes, sides, areas, portals)
  return cm.create(map)
end function

function testPointAndLeaves()
  model = makeFixture()
  assertEqual(cm.pointLeafNumber(model, t.Vec3(2.0, 0.0, 0.0), 0), 0, "front leaf")
  assertEqual(cm.pointLeafNumber(model, t.Vec3(-2.0, 0.0, 0.0), 0), 1, "back leaf")
  assertEqual(cm.pointContents(model, t.Vec3(-2.0, 0.0, 0.0), 0), c.CONTENTS_SOLID, "solid point contents")
  leaves = cm.boxLeafNumbers(model, t.Vec3(-2.0, -1.0, -1.0), t.Vec3(2.0, 1.0, 1.0), 0)
  assertEqual(len(leaves), 2, "straddling box leaf count")
  return true
end function

function testTrace()
  model = makeFixture()
  trace = cm.boxTrace(model, t.Vec3(2.0, 0.0, 0.0), t.Vec3(-2.0, 0.0, 0.0), t.Vec3(0.0, 0.0, 0.0), t.Vec3(0.0, 0.0, 0.0), 0, c.CONTENTS_SOLID)
  assertNear(trace.fraction, 0.2421875, 0.00001, "point trace fraction")
  assertNear(trace.endPosition.x, 1.03125, 0.00001, "point trace end")
  assertEqual(trace.surface.name, "collision/test", "trace surface")
  inside = cm.boxTrace(model, t.Vec3(0.0, 0.0, 0.0), t.Vec3(0.0, 0.0, 0.0), t.Vec3(0.0, 0.0, 0.0), t.Vec3(0.0, 0.0, 0.0), 0, c.CONTENTS_SOLID)
  assertEqual(inside.startSolid, true, "inside startsolid")
  assertEqual(inside.allSolid, true, "inside allsolid")
  return true
end function

function testAreaPortals()
  model = makeFixture()
  assertEqual(cm.areasConnected(model, 1, 2), false, "closed areas")
  cm.setAreaPortalState(model, 0, true)
  assertEqual(cm.areasConnected(model, 1, 2), true, "open areas")
  bits = cm.writeAreaBits(model, 1)
  assertEqual(bits[0] & 6, 6, "connected area bits")
  cm.setAreaPortalState(model, 0, false)
  assertEqual(cm.areasConnected(model, 1, 2), false, "reclosed areas")
  return true
end function

function collisionLocalToWorld(localPoint, origin, angles)
  basis = cmvector.angleVectors(angles)
  forward = basis[0]
  right = basis[1]
  up = basis[2]
  return t.Vec3(
    origin.x + forward.x * localPoint.x - right.x * localPoint.y + up.x * localPoint.z,
    origin.y + forward.y * localPoint.x - right.y * localPoint.y + up.y * localPoint.z,
    origin.z + forward.z * localPoint.x - right.z * localPoint.y + up.z * localPoint.z
  )
end function

function collisionWorldToLocal(worldPoint, origin, angles)
  basis = cmvector.angleVectors(angles)
  forward = basis[0]
  right = basis[1]
  up = basis[2]
  relative = t.Vec3(worldPoint.x - origin.x, worldPoint.y - origin.y, worldPoint.z - origin.z)
  localX = cm.dot(relative, forward)
  localY = -cm.dot(relative, right)
  localZ = cm.dot(relative, up)
  return t.Vec3(localX, localY, localZ)
end function

function testRepeatedRotatedBspCollision()
  iteration = 0
  while iteration < 512
    model = makeFixture()
    origin = t.Vec3(10.0 + (iteration % 7), -4.0, 3.0)
    angles = t.Vec3((iteration * 5) % 360, (iteration * 17) % 360, (iteration * 3) % 360)
    sourceStart = t.Vec3(2.0, 0.0, 0.0)
    sourceFinish = t.Vec3(-2.0, 0.0, 0.0)
    worldStart = collisionLocalToWorld(sourceStart, origin, angles)
    worldFinish = collisionLocalToWorld(sourceFinish, origin, angles)
    localStart = collisionWorldToLocal(worldStart, origin, angles)
    localFinish = collisionWorldToLocal(worldFinish, origin, angles)
    zeroMins = t.Vec3(0.0, 0.0, 0.0)
    zeroMaxs = t.Vec3(0.0, 0.0, 0.0)
    trace = cm.boxTrace(model, localStart, localFinish, zeroMins, zeroMaxs, 0, c.CONTENTS_SOLID)
    assertNear(trace.fraction, 0.2421875, 0.00001, "repeated rotated trace fraction")
    insideSource = t.Vec3(-0.5, 0.0, 0.0)
    insideWorld = collisionLocalToWorld(insideSource, origin, angles)
    insideLocal = collisionWorldToLocal(insideWorld, origin, angles)
    assertEqual(cm.pointContents(model, insideLocal, 0), c.CONTENTS_SOLID,
      "repeated rotated point contents")
    leafMins = t.Vec3(-2.0, -1.0, -1.0)
    leafMaxs = t.Vec3(2.0, 1.0, 1.0)
    leaves = cm.boxLeafNumbers(model, leafMins, leafMaxs, 0)
    assertEqual(len(leaves), 2, "repeated rotated leaf count")
    iteration = iteration + 1
  end while
  malformed = try(cm.dot(void, t.Vec3(0.0, 0.0, 0.0)))
  assertEqual(malformed is error, true, "malformed collision vector rejected")
  assertEqual(malformed.message, "collision dot first operand: Vec3-shaped value required",
    "malformed collision vector diagnostic")
  return true
end function

testPointAndLeaves()
testTrace()
testAreaPortals()
testRepeatedRotatedBspCollision()
print "collision_model_tests: PASS"
