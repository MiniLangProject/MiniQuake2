/* Golden tests for BaseQ2 linear mover state machines. */
import miniquake2.qcommon.types as qt
import miniquake2.game.world.constants as gwconstants
import miniquake2.game.world.core as gwcore
import miniquake2.game.world.movers as gwmovers

portalEvents = []
damageEvents = []
effectEvents = []
killBoxCount = 0

function assertEqual(actual, expected, name)
  if actual != expected then return error(9970, name + ": expected " + expected + ", got " + actual) end if
  return true
end function

function assertNear(actual, expected, tolerance, name)
  difference = actual - expected
  if difference < 0.0 then difference = -difference end if
  if difference > tolerance then return error(9971, name + ": outside tolerance; expected " + expected + ", got " + actual) end if
  return true
end function

function recordPortal(style, isOpen)
  global portalEvents
  portalEvents = portalEvents + [[style, isOpen]]
  return true
end function
function recordDamage(target, inflictor, attacker, amount, means)
  global damageEvents
  damageEvents = damageEvents + [[target.number, amount, means]]
  return true
end function
function recordRadius(inflictor, attacker, amount, radius, means)
  global damageEvents
  damageEvents = damageEvents + [[inflictor.number, amount, radius]]
  return true
end function
function recordEffect(kind, origin, style, count)
  global effectEvents
  effectEvents = effectEvents + [[kind, style, count]]
  return true
end function
function recordKillBox(entity)
  global killBoxCount
  killBoxCount = killBoxCount + 1
  return true
end function

function makeWorld()
  global portalEvents
  global damageEvents
  global effectEvents
  global killBoxCount
  portalEvents = []
  damageEvents = []
  effectEvents = []
  killBoxCount = 0
  callbacks = gwcore.defaultCallbacks()
  callbacks.areaPortal = recordPortal
  callbacks.damage = recordDamage
  callbacks.radiusDamage = recordRadius
  callbacks.effect = recordEffect
  callbacks.killBox = recordKillBox
  return gwcore.createWorld(callbacks)
end function

function movementFinished(entity, world)
  entity.count = entity.count + 1
  return true
end function

function countUses(entity, other, activator, world)
  entity.count = entity.count + 1
  return true
end function

function testLinearAndAcceleratedMove()
  world = makeWorld()
  linear = gwcore.spawnEntity(world, "linear")
  linear.moveInfo.speed = 10.0
  linear.moveInfo.accel = 10.0
  linear.moveInfo.decel = 10.0
  gwmovers.moveCalc(linear, qt.Vec3(25.0, 0.0, 0.0), movementFinished, world)
  assertEqual(linear.nextThink, 0.1, "linear starts next frame")
  gwcore.advance(world, 3.0)
  assertNear(linear.origin.x, 25.0, 0.000001, "linear destination")
  assertEqual(linear.count, 1, "linear completion callback")
  assertEqual(linear.velocity.x, 0.0, "linear stopped")

  accelerated = gwcore.spawnEntity(world, "accelerated")
  accelerated.moveInfo.speed = 10.0
  accelerated.moveInfo.accel = 2.0
  accelerated.moveInfo.decel = 2.0
  gwmovers.moveCalc(accelerated, qt.Vec3(30.0, 0.0, 0.0), movementFinished, world)
  gwcore.advance(world, 10.0)
  assertNear(accelerated.origin.x, 30.0, 0.000001, "accelerated destination")
  assertEqual(accelerated.count, 1, "accelerated completion")
  return true
end function

function testButton()
  world = makeWorld()
  receiver = gwcore.spawnEntity(world, "receiver")
  receiver.targetName = "button-out"
  receiver.use = countUses
  button = gwcore.spawnEntity(world, "func_button")
  button.size = qt.Vec3(16.0, 8.0, 8.0)
  button.target = "button-out"
  button.wait = 0.2
  gwmovers.spawnButton(button, world)
  gwcore.useEntity(world, button, receiver, receiver)
  gwcore.advance(world, 0.39)
  assertEqual(receiver.count, 0, "button target waits for top")
  gwcore.advance(world, 0.4)
  assertEqual(button.moveInfo.state, gwconstants.STATE_TOP, "button reaches top")
  assertEqual(receiver.count, 1, "button fires at top")
  assertNear(button.origin.x, 12.0, 0.000001, "button top position")
  gwcore.advance(world, 1.0)
  assertEqual(button.moveInfo.state, gwconstants.STATE_BOTTOM, "button returns")
  assertNear(button.origin.x, 0.0, 0.000001, "button bottom position")
  return true
end function

function testDoorAndPortal()
  world = makeWorld()
  portal = gwcore.spawnEntity(world, "func_areaportal")
  portal.targetName = "door-chain"
  portal.style = 7
  receiver = gwcore.spawnEntity(world, "receiver")
  receiver.targetName = "door-chain"
  receiver.use = countUses
  door = gwcore.spawnEntity(world, "func_door")
  door.size = qt.Vec3(108.0, 16.0, 32.0)
  door.target = "door-chain"
  door.wait = 0.2
  gwmovers.spawnDoor(door, world)
  gwcore.useEntity(world, door, receiver, receiver)
  assertEqual(receiver.count, 1, "door fires non-portal target on opening")
  assertEqual(portalEvents[0][0], 7, "door portal style")
  assertEqual(portalEvents[0][1], true, "door opens portal")
  gwcore.advance(world, 1.1)
  assertEqual(door.moveInfo.state, gwconstants.STATE_TOP, "door top")
  assertNear(door.origin.x, 100.0, 0.000001, "door open position")
  gwcore.advance(world, 2.3)
  assertEqual(door.moveInfo.state, gwconstants.STATE_BOTTOM, "door bottom")
  assertNear(door.origin.x, 0.0, 0.000001, "door closed position")
  assertEqual(portalEvents[len(portalEvents) - 1][1], false, "door closes portal")

  toggle = gwcore.spawnEntity(world, "func_door")
  toggle.size = qt.Vec3(18.0, 8.0, 8.0)
  toggle.spawnFlags = gwconstants.DOOR_TOGGLE
  gwmovers.spawnDoor(toggle, world)
  gwcore.useEntity(world, toggle, receiver, receiver)
  gwcore.advance(world, world.time + 0.3)
  assertEqual(toggle.moveInfo.state, gwconstants.STATE_TOP, "toggle remains open")
  gwcore.useEntity(world, toggle, receiver, receiver)
  gwcore.advance(world, world.time + 0.3)
  assertEqual(toggle.moveInfo.state, gwconstants.STATE_BOTTOM, "toggle closes on use")
  return true
end function

function testPlatAndTrain()
  world = makeWorld()
  plat = gwcore.spawnEntity(world, "func_plat")
  plat.targetName = "remote-plat"
  plat.origin = qt.Vec3(0.0, 0.0, 20.0)
  plat.height = 20.0
  gwmovers.spawnPlat(plat, world)
  assertEqual(plat.moveInfo.state, gwconstants.STATE_UP, "targeted plat starts top")
  gwcore.useEntity(world, plat, plat, plat)
  gwcore.advance(world, 5.0)
  assertEqual(plat.moveInfo.state, gwconstants.STATE_BOTTOM, "plat reaches bottom")
  assertNear(plat.origin.z, 0.0, 0.000001, "plat bottom position")

  corner1 = gwcore.spawnEntity(world, "path_corner")
  corner1.targetName = "p1"
  corner1.target = "p2"
  corner1.origin = qt.Vec3(10.0, 0.0, 0.0)
  corner2 = gwcore.spawnEntity(world, "path_corner")
  corner2.targetName = "p2"
  corner2.origin = qt.Vec3(30.0, 0.0, 0.0)
  train = gwcore.spawnEntity(world, "func_train")
  train.target = "p1"
  gwmovers.spawnTrain(train, world)
  gwcore.advance(world, 5.5)
  assertNear(train.origin.x, 30.0, 0.000001, "train second corner")
  assertEqual(train.targetEntity.number, corner2.number, "train target entity")
  assertEqual(train.velocity.x, 0.0, "train stops without next target")
  return true
end function

function testTimer()
  world = makeWorld()
  receiver = gwcore.spawnEntity(world, "receiver")
  receiver.targetName = "tick"
  receiver.use = countUses
  timer = gwcore.spawnEntity(world, "func_timer")
  timer.target = "tick"
  timer.wait = 0.5
  timer.random = 0.1
  gwmovers.spawnTimer(timer, world)
  gwcore.useEntity(world, timer, receiver, receiver)
  assertEqual(receiver.count, 1, "timer immediate first tick")
  gwcore.advance(world, 1.0)
  assertEqual(receiver.count, 3, "timer deterministic repeated ticks")
  gwcore.useEntity(world, timer, receiver, receiver)
  assertEqual(timer.nextThink, 0.0, "timer toggles off")
  gwcore.advance(world, 2.0)
  assertEqual(receiver.count, 3, "disabled timer stays silent")
  return true
end function

function testExplosive()
  world = makeWorld()
  attacker = gwcore.spawnEntity(world, "player")
  attacker.origin = qt.Vec3(-10.0, 0.0, 0.0)
  explosive = gwcore.spawnEntity(world, "func_explosive")
  explosive.size = qt.Vec3(20.0, 20.0, 20.0)
  explosive.absoluteMins = qt.Vec3(0.0, 0.0, 0.0)
  explosive.damage = 50
  explosive.mass = 250
  gwmovers.spawnExplosive(explosive, world, false)
  assertEqual(explosive.health, 100, "explosive default health")
  gwcore.killEntity(world, explosive, attacker, attacker, 100, qt.zeroVec3())
  assertEqual(explosive.inUse, false, "explosive freed")
  assertEqual(damageEvents[0][1], 50, "explosive radius damage")
  assertEqual(effectEvents[0][2], 2, "explosive large debris count")
  assertEqual(effectEvents[1][2], 10, "explosive small debris count")

  hidden = gwcore.spawnEntity(world, "func_explosive")
  hidden.spawnFlags = 1
  gwmovers.spawnExplosive(hidden, world, false)
  assertEqual(hidden.solid, gwconstants.SOLID_NOT, "trigger-spawn explosive hidden")
  gwcore.useEntity(world, hidden, attacker, attacker)
  assertEqual(hidden.solid, gwconstants.SOLID_BSP, "trigger-spawn explosive appears")
  assertEqual(killBoxCount, 1, "trigger-spawn killbox")
  return true
end function

function testRepeatedLinearAndRotatingMoverMaps()
  iteration = 0
  while iteration < 256
    world = makeWorld()

    linear = gwcore.spawnEntity(world, "soak-linear")
    linear.moveInfo.speed = 100.0
    linear.moveInfo.accel = 100.0
    linear.moveInfo.decel = 100.0
    destination = qt.Vec3(10.0, 5.0, 0.0)
    gwmovers.moveCalc(linear, destination, movementFinished, world)

    rotating = gwcore.spawnEntity(world, "func_door_rotating")
    rotating.spawnFlags = gwconstants.DOOR_X_AXIS | gwconstants.DOOR_TOGGLE
    rotating.speed = 900.0
    rotating.moveInfo.distance = 90.0
    gwmovers.spawnRotatingDoor(rotating, world)
    gwcore.useEntity(world, rotating, linear, linear)

    gwcore.advance(world, 1.0)
    assertNear(linear.origin.x, 10.0, 0.000001, "repeated linear mover x")
    assertNear(linear.origin.y, 5.0, 0.000001, "repeated linear mover y")
    assertEqual(linear.count, 1, "repeated linear mover callback")
    assertEqual(rotating.moveInfo.state, gwconstants.STATE_TOP, "repeated rotating mover top")
    assertNear(rotating.angles.z, 90.0, 0.000001, "repeated rotating mover angle")

    gwcore.useEntity(world, rotating, linear, linear)
    gwcore.advance(world, 1.2)
    assertEqual(rotating.moveInfo.state, gwconstants.STATE_BOTTOM, "repeated rotating mover bottom")
    assertNear(rotating.angles.z, 0.0, 0.000001, "repeated rotating mover reset")
    iteration = iteration + 1
  end while
  return true
end function

function main(args)
  testLinearAndAcceleratedMove()
  testButton()
  testDoorAndPortal()
  testPlatAndTrain()
  testTimer()
  testExplosive()
  testRepeatedLinearAndRotatingMoverMaps()
  print "gameplay_world_mover_tests: PASS"
  return 0
end function
