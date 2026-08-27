/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Golden tests for G_UseTargets, triggers and self-contained targets. */
import miniquake2.qcommon.types as qt
import miniquake2.game.world.constants as gwconstants
import miniquake2.game.world.types as gwtypes
import miniquake2.game.world.core as gwcore
import miniquake2.game.world.triggers as gwtriggers
import miniquake2.game.world.targets as gwtargets
import miniquake2.game.world.vector as gwtestvector

callbackEvents = []

// Assert the equal test condition.
function assertEqual(actual, expected, name)
  if actual != expected then return error(9960, name + ": expected " + expected + ", got " + actual) end if
  return true
end function

// Assert the near test condition.
function assertNear(actual, expected, tolerance, name)
  difference = actual - expected
  if difference < 0.0 then difference = -difference end if
  if difference > tolerance then return error(9961, name + ": expected " + expected + ", got " + actual) end if
  return true
end function

// Record state.
function record(kind, value)
  global callbackEvents
  callbackEvents = callbackEvents + [[kind, value]]
  return true
end function
// Return the callback log value.
function callbackLog(message)
  return record("log", message)
end function
// Return the callback center value.
function callbackCenter(entity, message)
  return record("center", message)
end function
// Return the callback sound value.
function callbackSound(entity, soundName)
  return record("sound", soundName)
end function
// Return the callback portal value.
function callbackPortal(style, isOpen)
  return record("portal", [style, isOpen])
end function
// Return the callback damage value.
function callbackDamage(target, inflictor, attacker, amount, means)
  return record("damage", [target.number, amount, means])
end function
// Return the callback radius value.
function callbackRadius(inflictor, attacker, amount, radius, means)
  return record("radius", [amount, radius, means])
end function
// Return the callback effect value.
function callbackEffect(kind, origin, style, count)
  return record("effect", [kind, style, count])
end function
// Return the callback change value.
function callbackChange(entity, other, activator, mapName)
  otherNumber = -1
  activatorNumber = -1
  if other is not void then otherNumber = other.number end if
  if activator is not void then activatorNumber = activator.number end if
  return record("change", [mapName, otherNumber, activatorNumber])
end function
// Spawn callback.
function callbackSpawn(className, origin, angles, velocity)
  return record("spawn", className)
end function
// Link callback.
function callbackLink(entity)
  return record("link", entity.number)
end function
// Kill callback box.
function callbackKillBox(entity)
  return record("killbox", entity.number)
end function
// Return the callback random signed value.
function callbackRandomSigned()
  return 0.0
end function
// Return the callback random index.
function callbackRandomIndex(count)
  return 0
end function
// Resolve callback key.
function callbackResolveKey(itemClassName)
  return void
end function
// Report whether callback has key.
function callbackHasKey(activator, itemClassName)
  return false
end function
// Consume callback key.
function callbackConsumeKey(activator, itemClassName)
  return false
end function
// Return the callback actor message value.
function callbackActorMessage(actor, message)
  return true
end function
// Return the callback actor transition value.
function callbackActorTransition(actor, waypoint, action, actionTarget, nextTarget, wait, flags)
  return true
end function
// Return the callback combat point transition value.
function callbackCombatPointTransition(actor, point, nextTarget, hold, clearCombatPoint)
  return true
end function
// Return the callback clock seconds value.
function callbackClockSeconds()
  return 0
end function
// Set callback model.
function callbackSetModel(entity, modelName)
  return true
end function
// Return the callback light style value.
function callbackLightStyle(style, pattern)
  return true
end function
// Trace callback line.
function callbackTraceLine(start, finish, ignore)
  return gwtypes.WorldTrace(false, finish, qt.zeroVec3(), void)
end function
// Return the callback laser sparks value.
function callbackLaserSparks(origin, normal, count, color)
  return true
end function
// Return the callback earthquake value.
function callbackEarthquake(entity, speed, playSound)
  return 0
end function
// Fire callback blaster.
function callbackFireBlaster(entity, direction, damage, speed)
  return void
end function
// Return the callback target explosion value.
function callbackTargetExplosion(origin)
  return record("target-explosion", [origin.x, origin.y, origin.z])
end function
// Return the callback target splash value.
function callbackTargetSplash(origin, direction, count, sounds)
  return record("target-splash", [origin.x, origin.y, origin.z,
    direction.x, direction.y, direction.z, count, sounds])
end function

// Create world.
function makeWorld()
  global callbackEvents
  callbackEvents = []
  callbacks = gwtypes.WorldCallbacks(
    callbackLog, callbackCenter, callbackSound, callbackPortal,
    callbackDamage, callbackRadius, callbackEffect, callbackChange,
    callbackSpawn, callbackLink, callbackKillBox,
    callbackRandomSigned, callbackRandomIndex,
    callbackResolveKey, callbackHasKey, callbackConsumeKey,
    callbackActorMessage, callbackActorTransition, callbackCombatPointTransition, callbackClockSeconds,
    callbackSetModel, callbackLightStyle,
    callbackTraceLine, callbackLaserSparks, callbackEarthquake, callbackFireBlaster,
    callbackTargetExplosion, callbackTargetSplash
  )
  return gwcore.createWorld(callbacks)
end function

// Return the count uses value.
function countUses(entity, other, activator, world)
  entity.count = entity.count + 1
  return true
end function

// Verify use targets and delay.
function testUseTargetsAndDelay()
  world = makeWorld()
  activator = gwcore.spawnEntity(world, "player")
  activator.isClient = true
  target = gwcore.spawnEntity(world, "target_counter")
  target.targetName = "FireMe"
  target.use = countUses
  victim = gwcore.spawnEntity(world, "victim")
  victim.targetName = "erase"
  source = gwcore.spawnEntity(world, "trigger_relay")
  source.target = "fireme"
  source.killTarget = "ERASE"
  source.message = "Access granted"

  gwcore.useTargets(world, source, activator)
  assertEqual(target.count, 1, "immediate target use")
  assertEqual(victim.inUse, false, "killtarget removal")
  assertEqual(callbackEvents[0][0], "center", "message callback ordering")

  delayed = gwcore.spawnEntity(world, "trigger_relay")
  delayed.target = "fireme"
  delayed.delay = 0.3
  gwcore.useTargets(world, delayed, activator)
  assertEqual(target.count, 1, "delay does not fire synchronously")
  gwcore.advance(world, 0.299)
  assertEqual(target.count, 1, "delay remains pending")
  gwcore.advance(world, 0.3)
  assertEqual(target.count, 2, "delayed target fires")
  return true
end function

// Verify multiple once relay.
function testMultipleOnceRelay()
  world = makeWorld()
  target = gwcore.spawnEntity(world, "receiver")
  target.targetName = "out"
  target.use = countUses
  player = gwcore.spawnEntity(world, "player")
  player.isClient = true
  player.health = 100

  multiple = gwcore.spawnEntity(world, "trigger_multiple")
  multiple.target = "out"
  multiple.wait = 0.2
  gwtriggers.spawnMultiple(multiple, world)
  gwcore.touchEntity(world, multiple, player)
  gwcore.touchEntity(world, multiple, player)
  assertEqual(target.count, 1, "multiple debounce")
  gwcore.advance(world, 0.2)
  gwcore.touchEntity(world, multiple, player)
  assertEqual(target.count, 2, "multiple rearms")

  once = gwcore.spawnEntity(world, "trigger_once")
  once.target = "out"
  gwtriggers.spawnOnce(once, world)
  gwcore.useEntity(world, once, player, player)
  assertEqual(target.count, 3, "once fires")
  assertEqual(once.inUse, true, "once deferred free")
  gwcore.advance(world, 0.3)
  assertEqual(once.inUse, false, "once freed next frame")

  enabled = gwcore.spawnEntity(world, "trigger_once")
  enabled.spawnFlags = 1
  enabled.target = "out"
  gwtriggers.spawnOnce(enabled, world)
  assertEqual(enabled.solid, gwconstants.SOLID_NOT, "legacy triggered starts disabled")
  gwcore.useEntity(world, enabled, player, player)
  assertEqual(enabled.solid, gwconstants.SOLID_TRIGGER, "trigger enabled")
  gwcore.useEntity(world, enabled, player, player)
  assertEqual(target.count, 4, "enabled trigger fires")

  relay = gwcore.spawnEntity(world, "trigger_relay")
  relay.target = "out"
  gwtriggers.spawnRelay(relay, world)
  gwcore.useEntity(world, relay, player, player)
  assertEqual(target.count, 5, "relay fires target")
  return true
end function

// Verify push and monster jump.
function testPushAndMonsterJump()
  world = makeWorld()
  player = gwcore.spawnEntity(world, "player")
  player.isClient = true
  player.health = 100

  push = gwcore.spawnEntity(world, "trigger_push")
  gwtriggers.spawnPush(push, world)
  assertEqual(push.speed, 1000.0, "trigger_push stock default speed")
  gwcore.touchEntity(world, push, player)
  assertNear(player.velocity.x, 10000.0, 0.000001,
    "trigger_push applies stock tenfold default speed")

  pushOnce = gwcore.spawnEntity(world, "trigger_push")
  pushOnce.spawnFlags = gwconstants.PUSH_ONCE
  pushOnce.speed = 100.0
  gwtriggers.spawnPush(pushOnce, world)
  gwcore.touchEntity(world, pushOnce, player)
  assertEqual(pushOnce.inUse, false, "PUSH_ONCE frees after touch")

  grenade = gwcore.spawnEntity(world, "grenade")
  grenade.health = 0
  grenadePush = gwcore.spawnEntity(world, "trigger_push")
  grenadePush.speed = 20.0
  gwtriggers.spawnPush(grenadePush, world)
  gwcore.touchEntity(world, grenadePush, grenade)
  assertNear(grenade.velocity.x, 200.0, 0.000001,
    "trigger_push moves grenades without health")

  jump = gwcore.spawnEntity(world, "trigger_monsterjump")
  jump.angles.y = 90.0
  jump.speed = 400.0
  jump.height = 300.0
  gwtriggers.spawnMonsterJump(jump, world)
  monster = gwcore.spawnEntity(world, "monster_soldier")
  monster.serverFlags = monster.serverFlags | gwconstants.SVF_MONSTER
  monster.groundEntity = player
  gwcore.touchEntity(world, jump, monster)
  assertNear(monster.velocity.y, 400.0, 0.01,
    "monsterjump sets horizontal launch")
  assertNear(monster.velocity.z, 300.0, 0.000001,
    "grounded monsterjump sets vertical launch")
  assertEqual(monster.groundEntity is void, true,
    "monsterjump clears ground entity")

  airborne = gwcore.spawnEntity(world, "monster_infantry")
  airborne.serverFlags = airborne.serverFlags | gwconstants.SVF_MONSTER
  airborne.velocity.z = 17.0
  gwcore.touchEntity(world, jump, airborne)
  assertNear(airborne.velocity.y, 400.0, 0.01,
    "airborne monsterjump still sets horizontal launch")
  assertNear(airborne.velocity.z, 17.0, 0.000001,
    "airborne monsterjump preserves vertical velocity")

  flyer = gwcore.spawnEntity(world, "monster_flyer")
  flyer.serverFlags = flyer.serverFlags | gwconstants.SVF_MONSTER
  flyer.flags = flyer.flags | gwconstants.FL_FLY
  flyer.groundEntity = player
  gwcore.touchEntity(world, jump, flyer)
  assertNear(flyer.velocity.y, 0.0, 0.000001,
    "monsterjump ignores flying monsters")
  return true
end function

// Verify targets.
function testTargets()
  world = makeWorld()
  activator = gwcore.spawnEntity(world, "player")
  activator.isClient = true

  speaker = gwcore.spawnEntity(world, "target_speaker")
  speaker.noise = "misc/alarm"
  speaker.spawnFlags = 1
  gwtargets.spawnSpeaker(speaker, world)
  assertEqual(speaker.noise, "misc/alarm.wav", "speaker extension")
  assertEqual(speaker.loopSound != 0, true, "speaker starts looped")
  gwcore.useEntity(world, speaker, activator, activator)
  assertEqual(speaker.loopSound, 0, "speaker loop toggles off")

  help = gwcore.spawnEntity(world, "target_help")
  help.message = "Find the exit"
  help.spawnFlags = 1
  gwtargets.spawnHelp(help, world)
  gwcore.useEntity(world, help, activator, activator)
  assertEqual(world.helpMessage1, "Find the exit", "help message")
  assertEqual(world.helpChanged, 1, "help change counter")

  receiver = gwcore.spawnEntity(world, "receiver")
  receiver.targetName = "after_boom"
  receiver.use = countUses
  explosion = gwcore.spawnEntity(world, "target_explosion")
  explosion.target = "after_boom"
  explosion.delay = 0.25
  explosion.damage = 40
  gwtargets.spawnExplosion(explosion, world)
  gwcore.useEntity(world, explosion, activator, activator)
  assertEqual(receiver.count, 0, "explosion delay")
  gwcore.advance(world, 0.25)
  assertEqual(receiver.count, 1, "explosion target chain")
  explosionEvent = callbackEvents[len(callbackEvents) - 2]
  assertEqual(explosionEvent[0], "target-explosion", "explosion temp entity callback")
  assertEqual(explosionEvent[1], [0.0, 0.0, 0.0], "explosion temp entity origin")

  secret = gwcore.spawnEntity(world, "target_secret")
  gwtargets.spawnSecret(secret, world)
  gwcore.useEntity(world, secret, activator, activator)
  assertEqual(world.totalSecrets, 1, "secret total")
  assertEqual(world.foundSecrets, 1, "secret found")
  assertEqual(secret.inUse, false, "secret single use")

  splash = gwcore.spawnEntity(world, "target_splash")
  splash.count = 0
  splash.damage = 5
  splash.sounds = 4
  splash.angles.y = 90.0
  gwtargets.spawnSplash(splash, world)
  gwcore.useEntity(world, splash, activator, activator)
  assertEqual(splash.count, 32, "splash default count")
  splashEvent = callbackEvents[len(callbackEvents) - 2]
  assertEqual(splashEvent[0], "target-splash", "splash temp entity callback")
  assertNear(splashEvent[1][4], 1.0, 0.00001, "splash wire direction")
  assertEqual(splashEvent[1][6], 32, "splash wire count")
  assertEqual(splashEvent[1][7], 4, "splash uses sounds as wire color")

  spawner = gwcore.spawnEntity(world, "target_spawner")
  spawner.target = "monster_soldier"
  spawner.speed = 300.0
  gwtargets.spawnSpawner(spawner, world)
  gwcore.useEntity(world, spawner, activator, activator)

  change = gwcore.spawnEntity(world, "target_changelevel")
  change.map = "*unit2"
  world.serverFlags = 255
  gwtargets.spawnChangeLevel(change, world)
  gwcore.useEntity(world, change, activator, activator)
  assertEqual(world.intermission, true, "changelevel enters intermission")
  assertEqual(world.serverFlags, 0, "new unit clears cross triggers")
  changeEvent = callbackEvents[len(callbackEvents) - 1]
  assertEqual(changeEvent[0], "change", "changelevel callback event")
  assertEqual(changeEvent[1], ["*unit2", activator.number,
    activator.number], "changelevel forwards other and activator")
  return true
end function

// Verify cross level.
function testCrossLevel()
  world = makeWorld()
  receiver = gwcore.spawnEntity(world, "receiver")
  receiver.targetName = "cross-out"
  receiver.use = countUses
  setter = gwcore.spawnEntity(world, "target_crosslevel_trigger")
  setter.spawnFlags = 4
  gwtargets.spawnCrossLevelTrigger(setter, world)
  gwcore.useEntity(world, setter, setter, setter)
  assertEqual(world.serverFlags, 4, "crosslevel bit set")

  checker = gwcore.spawnEntity(world, "target_crosslevel_target")
  checker.spawnFlags = 4
  checker.target = "cross-out"
  checker.delay = 0.2
  gwtargets.spawnCrossLevelTarget(checker, world)
  gwcore.advance(world, 0.2)
  assertEqual(receiver.count, 0, "crosslevel preserves G_UseTargets delay")
  assertEqual(checker.inUse, false, "crosslevel source frees after check")
  gwcore.advance(world, 0.4)
  assertEqual(receiver.count, 1, "crosslevel target fires")

  unsatisfied = gwcore.spawnEntity(world, "target_crosslevel_target")
  unsatisfied.spawnFlags = 8
  unsatisfied.target = "cross-out"
  unsatisfied.delay = 0.1
  gwtargets.spawnCrossLevelTarget(unsatisfied, world)
  gwcore.advance(world, 0.5)
  assertEqual(unsatisfied.inUse, false,
    "unsatisfied crosslevel target is still a one-shot check")
  assertEqual(receiver.count, 1,
    "unsatisfied crosslevel target does not fire")
  return true
end function

// Verify world vector gc soak.
function testWorldVectorGcSoak()
  iteration = 0
  while iteration < 4096
    first = qt.Vec3(3.0, 4.0, 0.0)
    second = qt.Vec3(-1.0, 2.0, 5.0)
    copied = gwtestvector.copy(first)
    sum = gwtestvector.add(first, second)
    difference = gwtestvector.subtract(first, second)
    scaled = gwtestvector.scale(first, 2.0)
    multiplied = gwtestvector.multiplyAdd(first, 2.0, second)
    product = gwtestvector.dot(first, second)
    magnitude = gwtestvector.length(first)
    normalization = gwtestvector.normalized(first)
    unit = normalization[0]
    angles = qt.Vec3(0.0, 90.0, 0.0)
    direction = gwtestvector.movedir(angles)
    upAngles = qt.Vec3(0.0, -1.0, 0.0)
    up = gwtestvector.movedir(upAngles)

    assertEqual(gwtestvector.equal(copied, first), true, "vector copy/equal soak")
    assertEqual(sum.x, 2.0, "vector add soak")
    assertEqual(difference.z, -5.0, "vector subtract soak")
    assertEqual(scaled.y, 8.0, "vector scale soak")
    assertEqual(multiplied.z, 10.0, "vector multiplyAdd soak")
    assertEqual(product, 5.0, "vector dot soak")
    assertEqual(magnitude, 5.0, "vector length soak")
    assertNear(unit.x, 0.6, 0.000001, "vector normalized x soak")
    assertEqual(normalization[1], 5.0, "vector normalized magnitude soak")
    assertNear(direction.y, 1.0, 0.00001, "vector movedir soak")
    assertEqual(up.z, 1.0, "vector special movedir soak")
    iteration = iteration + 1
  end while

  validDirection = qt.Vec3(1.0, 0.0, 0.0)
  malformed = try(gwtestvector.multiplyAdd(void, 1.0, validDirection))
  assertEqual(malformed is error, true, "malformed world vector rejected")
  assertEqual(malformed.message, "world vector multiplyAdd value: Vec3-shaped value required",
    "malformed world vector diagnostic")
  return true
end function

// Run this source file's command-line entry point.
function main(args)
  testUseTargetsAndDelay()
  testMultipleOnceRelay()
  testPushAndMonsterJump()
  testTargets()
  testCrossLevel()
  testWorldVectorGcSoak()
  print "gameplay_world_core_tests: PASS"
  return 0
end function
