/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Golden tests for BaseQ2 linear mover state machines. */
import miniquake2.qcommon.types as qt
import miniquake2.game.world.constants as gwconstants
import miniquake2.game.world.core as gwcore
import miniquake2.game.world.movers as gwmovers
import miniquake2.game.world.triggers as gwtriggers

portalEvents = []
damageEvents = []
effectEvents = []
soundEvents = []
centerEvents = []
killBoxCount = 0

// Assert the equal test condition.
function assertEqual(actual, expected, name)
  if actual != expected then return error(9970, name + ": expected " + expected + ", got " + actual) end if
  return true
end function

// Assert the near test condition.
function assertNear(actual, expected, tolerance, name)
  difference = actual - expected
  if difference < 0.0 then difference = -difference end if
  if difference > tolerance then return error(9971, name + ": outside tolerance; expected " + expected + ", got " + actual) end if
  return true
end function

// Record portal.
function recordPortal(style, isOpen)
  global portalEvents
  portalEvents = portalEvents + [[style, isOpen]]
  return true
end function
// Record damage.
function recordDamage(target, inflictor, attacker, amount, means)
  global damageEvents
  damageEvents = damageEvents + [[target.number, amount, means]]
  return true
end function
// Record radius.
function recordRadius(inflictor, attacker, amount, radius, means)
  global damageEvents
  damageEvents = damageEvents + [[inflictor.number, amount, radius]]
  return true
end function
// Record effect.
function recordEffect(kind, origin, style, count)
  global effectEvents
  effectEvents = effectEvents + [[kind, style, count]]
  return true
end function
// Record sound.
function recordSound(entity, soundName)
  global soundEvents
  soundEvents = soundEvents + [soundName]
  return true
end function
// Record center.
function recordCenter(entity, message)
  global centerEvents
  centerEvents = centerEvents + [message]
  return true
end function
// Record kill box.
function recordKillBox(entity)
  global killBoxCount
  killBoxCount = killBoxCount + 1
  return true
end function

// Create world.
function makeWorld()
  global portalEvents
  global damageEvents
  global effectEvents
  global soundEvents
  global centerEvents
  global killBoxCount
  portalEvents = []
  damageEvents = []
  effectEvents = []
  soundEvents = []
  centerEvents = []
  killBoxCount = 0
  callbacks = gwcore.defaultCallbacks()
  callbacks.areaPortal = recordPortal
  callbacks.damage = recordDamage
  callbacks.radiusDamage = recordRadius
  callbacks.effect = recordEffect
  callbacks.sound = recordSound
  callbacks.centerPrint = recordCenter
  callbacks.killBox = recordKillBox
  return gwcore.createWorld(callbacks)
end function

// Verify trigger counter and hurt parity.
function testTriggerCounterAndHurtParity()
  global centerEvents
  global soundEvents
  global damageEvents

  world = makeWorld()
  activator = gwcore.spawnEntity(world, "player")
  activator.isClient = true
  counter = gwcore.spawnEntity(world, "trigger_counter")
  counter.count = 2
  gwtriggers.spawnCounter(counter, world)
  gwcore.useEntity(world, counter, counter, activator)
  assertEqual(centerEvents[0], "1 more to go...", "counter remaining message")
  assertEqual(soundEvents[0], "misc/talk1.wav", "counter remaining sound")
  assertEqual(counter.message, "", "counter does not overwrite mapper message")
  gwcore.useEntity(world, counter, counter, activator)
  assertEqual(centerEvents[1], "Sequence completed!", "counter completion message")
  assertEqual(soundEvents[1], "misc/talk1.wav", "counter completion sound")

  world = makeWorld()
  activator = gwcore.spawnEntity(world, "player")
  activator.isClient = true
  silentCounter = gwcore.spawnEntity(world, "trigger_counter")
  silentCounter.spawnFlags = 1
  silentCounter.count = 2
  gwtriggers.spawnCounter(silentCounter, world)
  gwcore.useEntity(world, silentCounter, silentCounter, activator)
  gwcore.useEntity(world, silentCounter, silentCounter, activator)
  assertEqual(len(centerEvents), 0, "counter nomessage suppresses centerprint")
  assertEqual(len(soundEvents), 0, "counter nomessage suppresses talk sound")

  world = makeWorld()
  hurt = gwcore.spawnEntity(world, "trigger_hurt")
  gwtriggers.spawnHurt(hurt, world)
  inert = gwcore.spawnEntity(world, "inert")
  hurt.touch(hurt, inert, world)
  assertEqual(len(damageEvents), 0, "trigger_hurt ignores non-damageable entity")
  victim = gwcore.spawnEntity(world, "victim")
  victim.takeDamage = gwconstants.DAMAGE_YES
  hurt.touch(hurt, victim, world)
  assertEqual(len(damageEvents), 1, "trigger_hurt damages damageable entity")
  assertEqual(damageEvents[0][1], 5, "trigger_hurt default damage")

  startOff = gwcore.spawnEntity(world, "trigger_hurt")
  startOff.spawnFlags = 1
  gwtriggers.spawnHurt(startOff, world)
  assertEqual(startOff.solid, gwconstants.SOLID_NOT, "start-off hurt starts disabled")
  assertEqual(startOff.use is void, true, "start-off hurt without toggle cannot be enabled")

  toggle = gwcore.spawnEntity(world, "trigger_hurt")
  toggle.spawnFlags = 3
  gwtriggers.spawnHurt(toggle, world)
  assertEqual(toggle.use is void, false, "toggle hurt installs use callback")
  gwcore.useEntity(world, toggle, activator, activator)
  assertEqual(toggle.solid, gwconstants.SOLID_TRIGGER, "toggle hurt enables")
  assertEqual(toggle.use is void, false, "toggle hurt keeps use callback")
  return true
end function

// Verify trigger message sounds.
function testTriggerMessageSounds()
  global soundEvents
  world = makeWorld()
  activator = gwcore.spawnEntity(world, "player")
  activator.isClient = true

  trigger = gwcore.spawnEntity(world, "trigger_multiple")
  trigger.message = "A secret is revealed."
  trigger.sounds = 1
  gwtriggers.spawnMultiple(trigger, world)
  gwcore.useEntity(world, trigger, trigger, activator)
  assertEqual(trigger.noise, "misc/secret.wav", "trigger secret sound selection")
  assertEqual(soundEvents[0], "misc/secret.wav", "trigger message uses selected sound")

  trigger2 = gwcore.spawnEntity(world, "trigger_multiple")
  trigger2.sounds = 2
  gwtriggers.spawnMultiple(trigger2, world)
  assertEqual(trigger2.noise, "misc/talk.wav", "trigger talk sound selection")
  trigger3 = gwcore.spawnEntity(world, "trigger_multiple")
  trigger3.sounds = 3
  gwtriggers.spawnMultiple(trigger3, world)
  assertEqual(trigger3.noise, "misc/trigger1.wav", "trigger switch sound selection")
  return true
end function

// Find class.
function findClass(world, className)
  for each entity in world.entities
    if entity.inUse and entity.className == className then return entity end if
  end for
  return void
end function

// Verify stock trigger parity gaps.
function testStockTriggerParityGaps()
  global damageEvents
  global soundEvents

  world = makeWorld()
  hurt = gwcore.spawnEntity(world, "trigger_hurt")
  hurt.spawnFlags = 8
  gwtriggers.spawnHurt(hurt, world)
  victim = gwcore.spawnEntity(world, "victim")
  victim.takeDamage = gwconstants.DAMAGE_YES
  gwcore.touchEntity(world, hurt, victim)
  assertEqual(soundEvents[0], "world/electro.wav", "hurt stock electrical sound")
  assertEqual(damageEvents[0][2], gwconstants.MOD_TRIGGER_HURT_NO_PROTECTION,
    "hurt no-protection damage path")

  silent = gwcore.spawnEntity(world, "trigger_hurt")
  silent.spawnFlags = 4
  gwtriggers.spawnHurt(silent, world)
  gwcore.touchEntity(world, silent, victim)
  assertEqual(len(soundEvents), 1, "silent hurt suppresses electrical sound")
  assertEqual(damageEvents[1][2], gwconstants.MOD_TRIGGER_HURT,
    "regular hurt damage path")

  world = makeWorld()
  push = gwcore.spawnEntity(world, "trigger_push")
  push.angles.y = 90.0
  gwtriggers.spawnPush(push, world)
  player = gwcore.spawnEntity(world, "player")
  player.isClient = true
  player.health = 100
  gwcore.advance(world, 0.1)
  gwcore.touchEntity(world, push, player)
  assertNear(player.velocity.y, 10000.0, 0.1, "push stock velocity")
  assertNear(player.oldVelocity.y, player.velocity.y, 0.000001,
    "push copies client old velocity")
  assertEqual(soundEvents[0], "misc/windfly.wav", "push stock wind sound")
  gwcore.touchEntity(world, push, player)
  assertEqual(len(soundEvents), 1, "push wind sound is debounced")

  pushOnce = gwcore.spawnEntity(world, "trigger_push")
  pushOnce.spawnFlags = gwconstants.PUSH_ONCE
  gwtriggers.spawnPush(pushOnce, world)
  inert = gwcore.spawnEntity(world, "inert")
  gwcore.touchEntity(world, pushOnce, inert)
  assertEqual(pushOnce.inUse, false, "push-once frees on every touch")

  world = makeWorld()
  missingGravity = gwcore.spawnEntity(world, "trigger_gravity")
  assertEqual(gwtriggers.spawnGravity(missingGravity, world), false,
    "gravity trigger without value is rejected")
  assertEqual(missingGravity.inUse, false, "invalid gravity trigger freed")
  gravity = gwcore.spawnEntity(world, "trigger_gravity")
  gravity.gravity = 3.0
  gwtriggers.spawnGravity(gravity, world)
  actor = gwcore.spawnEntity(world, "actor")
  gwcore.touchEntity(world, gravity, actor)
  assertEqual(actor.gravity, 3.0, "gravity trigger updates touched entity")
  return true
end function

// Verify conveyor parity.
function testConveyorParity()
  world = makeWorld()
  conveyor = gwcore.spawnEntity(world, "func_conveyor")
  gwmovers.spawnConveyor(conveyor, world)
  assertEqual(conveyor.speed, 0.0, "conveyor defaults off")
  assertEqual(conveyor.count, 100.0, "conveyor remembers stock speed")
  gwcore.useEntity(world, conveyor, conveyor, conveyor)
  assertEqual(conveyor.speed, 100.0, "conveyor switches on")
  assertEqual(conveyor.count, 0, "non-toggle conveyor consumes stored speed")
  gwcore.useEntity(world, conveyor, conveyor, conveyor)
  gwcore.useEntity(world, conveyor, conveyor, conveyor)
  assertEqual(conveyor.speed, 0, "non-toggle conveyor cannot restart")

  toggle = gwcore.spawnEntity(world, "func_conveyor")
  toggle.spawnFlags = 2
  toggle.speed = 250.0
  gwmovers.spawnConveyor(toggle, world)
  gwcore.useEntity(world, toggle, toggle, toggle)
  gwcore.useEntity(world, toggle, toggle, toggle)
  gwcore.useEntity(world, toggle, toggle, toggle)
  assertEqual(toggle.speed, 250.0, "toggle conveyor retains restart speed")
  return true
end function

// Verify automatic door and plat triggers.
function testAutomaticDoorAndPlatTriggers()
  world = makeWorld()
  door = gwcore.spawnEntity(world, "func_door")
  door.size = qt.Vec3(32.0, 16.0, 24.0)
  door.absoluteMins = qt.Vec3(10.0, 20.0, 30.0)
  door.absoluteMaxs = qt.Vec3(42.0, 36.0, 54.0)
  gwmovers.spawnDoor(door, world)
  gwcore.advance(world, world.frameTime)
  doorTrigger = findClass(world, "door_trigger")
  assertEqual(doorTrigger is void, false, "untargeted door creates touch field")
  assertNear(doorTrigger.mins.x, -50.0, 0.000001, "door trigger expands minimum x")
  assertNear(doorTrigger.maxs.y, 96.0, 0.000001, "door trigger expands maximum y")
  player = gwcore.spawnEntity(world, "player")
  player.isClient = true
  player.health = 100
  gwcore.touchEntity(world, doorTrigger, player)
  assertEqual(door.moveInfo.state, gwconstants.STATE_UP, "door trigger opens owner")
  gwcore.blockedEntity(world, door, player)
  assertEqual(damageEvents[len(damageEvents) - 1][1], 2,
    "ordinary door applies stock two-point crush damage")
  assertEqual(door.moveInfo.state, gwconstants.STATE_DOWN,
    "ordinary door reverses after blocking a player")

  world = makeWorld()
  noMonsterDoor = gwcore.spawnEntity(world, "func_door")
  noMonsterDoor.size = qt.Vec3(32.0, 16.0, 24.0)
  noMonsterDoor.absoluteMaxs = qt.Vec3(32.0, 16.0, 24.0)
  noMonsterDoor.spawnFlags = gwconstants.DOOR_NOMONSTER
  gwmovers.spawnDoor(noMonsterDoor, world)
  gwcore.advance(world, world.frameTime)
  doorTrigger = findClass(world, "door_trigger")
  monster = gwcore.spawnEntity(world, "monster")
  monster.serverFlags = gwconstants.SVF_MONSTER
  monster.health = 100
  gwcore.touchEntity(world, doorTrigger, monster)
  assertEqual(noMonsterDoor.moveInfo.state, gwconstants.STATE_BOTTOM,
    "no-monster door rejects monster touch")

  world = makeWorld()
  plat = gwcore.spawnEntity(world, "func_plat")
  plat.origin = qt.Vec3(0.0, 0.0, 64.0)
  plat.mins = qt.Vec3(-32.0, -32.0, 0.0)
  plat.maxs = qt.Vec3(32.0, 32.0, 16.0)
  plat.height = 32.0
  plat.spawnFlags = gwconstants.PLAT_LOW_TRIGGER
  gwmovers.spawnPlat(plat, world)
  gwcore.advance(world, world.frameTime)
  platTrigger = findClass(world, "plat_trigger")
  assertEqual(platTrigger is void, false, "plat creates inside trigger")
  assertNear(platTrigger.mins.x, -7.0, 0.000001, "plat trigger horizontal inset")
  assertNear(platTrigger.maxs.z - platTrigger.mins.z, 8.0, 0.000001,
    "plat low-trigger height")
  player = gwcore.spawnEntity(world, "player")
  player.isClient = true
  player.health = 100
  gwcore.touchEntity(world, platTrigger, player)
  assertEqual(plat.moveInfo.state, gwconstants.STATE_UP, "plat trigger raises platform")
  return true
end function

// Report whether movement finished.
function movementFinished(entity, world)
  entity.count = entity.count + 1
  return true
end function

// Return the count uses value.
function countUses(entity, other, activator, world)
  entity.count = entity.count + 1
  return true
end function

// Verify linear and accelerated move.
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

// Verify button.
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

// Verify door and portal.
function testDoorAndPortal()
  // Keep test door and portal phases explicit: validate inputs, update owned state, then publish the result.
  global centerEvents
  global soundEvents
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

  messageDoor = gwcore.spawnEntity(world, "func_door")
  messageDoor.size = qt.Vec3(18.0, 8.0, 8.0)
  messageDoor.targetName = "remote-door"
  messageDoor.message = "Remote switch required."
  gwmovers.spawnDoor(messageDoor, world)
  visitor = gwcore.spawnEntity(world, "player")
  visitor.isClient = true
  visitor.health = 100
  gwcore.touchEntity(world, messageDoor, visitor)
  assertEqual(centerEvents[len(centerEvents) - 1], "Remote switch required.",
    "targeted door touch message")
  assertEqual(soundEvents[len(soundEvents) - 1], "misc/talk1.wav",
    "targeted door touch sound")
  gwcore.useEntity(world, messageDoor, visitor, visitor)
  assertEqual(messageDoor.touch is void, true, "used door clears touch message")

  master = gwcore.spawnEntity(world, "func_door")
  master.size = qt.Vec3(108.0, 8.0, 8.0)
  gwmovers.spawnDoor(master, world)
  slave = gwcore.spawnEntity(world, "func_door")
  slave.size = qt.Vec3(58.0, 8.0, 8.0)
  gwmovers.spawnDoor(slave, world)
  master.teamChain = slave
  slave.teamMaster = master
  slave.flags = slave.flags | gwconstants.FL_TEAMSLAVE
  gwcore.advance(world, world.time + world.frameTime)
  assertNear(master.moveInfo.speed, 200.0, 0.000001,
    "long door team member synchronized speed")
  assertNear(slave.moveInfo.speed, 100.0, 0.000001,
    "short door team member synchronized speed")

  startOpenRotating = gwcore.spawnEntity(world, "func_door_rotating")
  startOpenRotating.spawnFlags = gwconstants.DOOR_START_OPEN
  startOpenRotating.moveInfo.distance = 90.0
  gwmovers.spawnRotatingDoor(startOpenRotating, world)
  assertNear(startOpenRotating.angles.y, 90.0, 0.000001,
    "start-open rotating door initial angle")
  assertNear(startOpenRotating.moveInfo.endAngles.y, 0.0, 0.000001,
    "start-open rotating door closed angle")

  rotatingMaster = gwcore.spawnEntity(world, "func_door_rotating")
  rotatingMaster.moveInfo.distance = 90.0
  rotatingMaster.spawnFlags = gwconstants.DOOR_TOGGLE
  rotatingMaster.target = "door-chain"
  gwmovers.spawnRotatingDoor(rotatingMaster, world)
  rotatingSlave = gwcore.spawnEntity(world, "func_door_rotating")
  rotatingSlave.moveInfo.distance = 45.0
  rotatingSlave.spawnFlags = gwconstants.DOOR_TOGGLE
  gwmovers.spawnRotatingDoor(rotatingSlave, world)
  rotatingMaster.teamChain = rotatingSlave
  rotatingSlave.teamMaster = rotatingMaster
  rotatingSlave.flags = rotatingSlave.flags | gwconstants.FL_TEAMSLAVE
  gwcore.advance(world, world.time + world.frameTime)
  assertNear(rotatingMaster.moveInfo.speed, 200.0, 0.000001,
    "rotating door team synchronized speed")
  gwcore.useEntity(world, rotatingMaster, visitor, visitor)
  assertEqual(rotatingMaster.moveInfo.state, gwconstants.STATE_UP,
    "rotating team master opens")
  assertEqual(rotatingSlave.moveInfo.state, gwconstants.STATE_UP,
    "rotating team slave opens")
  assertEqual(receiver.count, 2, "rotating door fires targets on opening")
  assertEqual(portalEvents[len(portalEvents) - 1][1], true,
    "rotating door opens area portal")
  gwcore.advance(world, world.time + 0.5)
  assertEqual(rotatingMaster.moveInfo.state, gwconstants.STATE_TOP,
    "rotating team master reaches top")
  assertEqual(rotatingSlave.moveInfo.state, gwconstants.STATE_TOP,
    "rotating team slave reaches top")
  gwcore.useEntity(world, rotatingMaster, visitor, visitor)
  gwcore.advance(world, world.time + 0.5)
  assertEqual(rotatingMaster.moveInfo.state, gwconstants.STATE_BOTTOM,
    "rotating team master closes")
  assertEqual(rotatingSlave.moveInfo.state, gwconstants.STATE_BOTTOM,
    "rotating team slave closes")
  assertEqual(portalEvents[len(portalEvents) - 1][1], false,
    "rotating door closes area portal")

  shootDoor = gwcore.spawnEntity(world, "func_door_rotating")
  shootDoor.health = 10
  gwmovers.spawnRotatingDoor(shootDoor, world)
  assertEqual(shootDoor.takeDamage, gwconstants.DAMAGE_YES,
    "shootable rotating door takes damage")
  gwcore.killEntity(world, shootDoor, visitor, visitor, 10, qt.zeroVec3())
  assertEqual(shootDoor.moveInfo.state, gwconstants.STATE_UP,
    "shot rotating door opens")
  return true
end function

// Verify water and secret door.
function testWaterAndSecretDoor()
  global soundEvents
  world = makeWorld()
  water = gwcore.spawnEntity(world, "func_water")
  water.size = qt.Vec3(50.0, 16.0, 16.0)
  water.sounds = 1
  gwmovers.spawnWater(water, world)
  assertEqual(water.speed, 25.0, "water stock speed")
  assertEqual(water.wait, -1.0, "water stock wait")
  assertNear(water.moveInfo.endOrigin.x, 50.0, 0.000001, "water keeps zero lip")
  assertEqual(water.blocked is void, true, "water has no door blocked callback")
  assertEqual((water.spawnFlags & gwconstants.DOOR_TOGGLE) != 0, true,
    "water wait -1 enables toggle")
  gwcore.useEntity(world, water, water, water)
  assertEqual(soundEvents[0], "world/mov_watr.wav", "water start sound")
  gwcore.advance(world, 2.2)
  assertNear(water.origin.x, 50.0, 0.000001, "water reaches open position")
  assertEqual(soundEvents[1], "world/stp_watr.wav", "water stop sound")
  gwcore.useEntity(world, water, water, water)
  gwcore.advance(world, 4.4)
  assertNear(water.origin.x, 0.0, 0.000001, "water toggle closes")

  portal = gwcore.spawnEntity(world, "func_areaportal")
  portal.targetName = "secret-chain"
  portal.style = 9
  secret = gwcore.spawnEntity(world, "func_door_secret")
  secret.target = "secret-chain"
  secret.size = qt.Vec3(100.0, 20.0, 40.0)
  secret.wait = 0.5
  gwmovers.spawnSecretDoor(secret, world)
  assertEqual(secret.speed, 50.0, "secret door fixed stock speed")
  assertNear(secret.moveInfo.startOrigin.y, -20.0, 0.000001,
    "secret door first sideways leg")
  assertNear(secret.moveInfo.endOrigin.x, 100.0, 0.000001,
    "secret door second forward leg")
  gwcore.useEntity(world, secret, secret, secret)
  assertEqual(portalEvents[len(portalEvents) - 1][1], true,
    "secret door opens area portal")
  gwcore.advance(world, world.time + 0.8)
  assertNear(secret.origin.y, -20.0, 0.000001,
    "secret door pauses after first leg")
  gwcore.advance(world, world.time + 3.0)
  assertNear(secret.origin.x, 100.0, 0.000001,
    "secret door reaches open position")
  gwcore.advance(world, world.time + 4.5)
  assertNear(secret.origin.x, 0.0, 0.000001, "secret door returns x")
  assertNear(secret.origin.y, 0.0, 0.000001, "secret door returns y")
  assertEqual(secret.moveInfo.state, gwconstants.STATE_BOTTOM,
    "secret door returns to bottom state")
  assertEqual(portalEvents[len(portalEvents) - 1][1], false,
    "secret door closes area portal")
  return true
end function

// Verify plat and train.
function testPlatAndTrain()
  world = makeWorld()
  plat = gwcore.spawnEntity(world, "func_plat")
  plat.targetName = "remote-plat"
  plat.origin = qt.Vec3(0.0, 0.0, 20.0)
  plat.height = 20.0
  gwmovers.spawnPlat(plat, world)
  assertEqual(plat.moveInfo.state, gwconstants.STATE_UP, "targeted plat starts top")
  gwcore.advance(world, world.frameTime)
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

// Verify timer.
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

// Verify explosive.
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

// Verify repeated linear and rotating mover maps.
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

// Run this source file's command-line entry point.
function main(args)
  testTriggerCounterAndHurtParity()
  testTriggerMessageSounds()
  testStockTriggerParityGaps()
  testConveyorParity()
  testAutomaticDoorAndPlatTriggers()
  testLinearAndAcceleratedMove()
  testButton()
  testDoorAndPortal()
  testWaterAndSecretDoor()
  testPlatAndTrain()
  testTimer()
  testExplosive()
  testRepeatedLinearAndRotatingMoverMaps()
  print "gameplay_world_mover_tests: PASS"
  return 0
end function
