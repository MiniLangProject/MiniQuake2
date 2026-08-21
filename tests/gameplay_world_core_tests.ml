/* Golden tests for G_UseTargets, triggers and self-contained targets. */
import miniquake2.qcommon.types as qt
import miniquake2.game.world.constants as gwconstants
import miniquake2.game.world.types as gwtypes
import miniquake2.game.world.core as gwcore
import miniquake2.game.world.triggers as gwtriggers
import miniquake2.game.world.targets as gwtargets
import miniquake2.game.world.vector as gwtestvector

callbackEvents = []

function assertEqual(actual, expected, name)
  if actual != expected then return error(9960, name + ": expected " + expected + ", got " + actual) end if
  return true
end function

function assertNear(actual, expected, tolerance, name)
  difference = actual - expected
  if difference < 0.0 then difference = -difference end if
  if difference > tolerance then return error(9961, name + ": outside tolerance") end if
  return true
end function

function record(kind, value)
  global callbackEvents
  callbackEvents = callbackEvents + [[kind, value]]
  return true
end function
function callbackLog(message)
  return record("log", message)
end function
function callbackCenter(entity, message)
  return record("center", message)
end function
function callbackSound(entity, soundName)
  return record("sound", soundName)
end function
function callbackPortal(style, isOpen)
  return record("portal", [style, isOpen])
end function
function callbackDamage(target, inflictor, attacker, amount, means)
  return record("damage", [target.number, amount, means])
end function
function callbackRadius(inflictor, attacker, amount, radius, means)
  return record("radius", [amount, radius, means])
end function
function callbackEffect(kind, origin, style, count)
  return record("effect", [kind, style, count])
end function
function callbackChange(entity, mapName)
  return record("change", mapName)
end function
function callbackSpawn(className, origin, angles, velocity)
  return record("spawn", className)
end function
function callbackLink(entity)
  return record("link", entity.number)
end function
function callbackKillBox(entity)
  return record("killbox", entity.number)
end function
function callbackRandomSigned()
  return 0.0
end function
function callbackRandomIndex(count)
  return 0
end function
function callbackResolveKey(itemClassName)
  return void
end function
function callbackHasKey(activator, itemClassName)
  return false
end function
function callbackConsumeKey(activator, itemClassName)
  return false
end function
function callbackActorMessage(actor, message)
  return true
end function
function callbackActorTransition(actor, waypoint, action, actionTarget, nextTarget, wait, flags)
  return true
end function
function callbackCombatPointTransition(actor, point, nextTarget, hold, clearCombatPoint)
  return true
end function
function callbackClockSeconds()
  return 0
end function
function callbackSetModel(entity, modelName)
  return true
end function

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
    callbackSetModel
  )
  return gwcore.createWorld(callbacks)
end function

function countUses(entity, other, activator, world)
  entity.count = entity.count + 1
  return true
end function

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

  secret = gwcore.spawnEntity(world, "target_secret")
  gwtargets.spawnSecret(secret, world)
  gwcore.useEntity(world, secret, activator, activator)
  assertEqual(world.totalSecrets, 1, "secret total")
  assertEqual(world.foundSecrets, 1, "secret found")
  assertEqual(secret.inUse, false, "secret single use")

  splash = gwcore.spawnEntity(world, "target_splash")
  splash.count = 0
  splash.damage = 5
  gwtargets.spawnSplash(splash, world)
  gwcore.useEntity(world, splash, activator, activator)
  assertEqual(splash.count, 32, "splash default count")

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
  return true
end function

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
  return true
end function

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

function main(args)
  testUseTargetsAndDelay()
  testMultipleOnceRelay()
  testTargets()
  testCrossLevel()
  testWorldVectorGcSoak()
  print "gameplay_world_core_tests: PASS"
  return 0
end function
