/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Stock g_target.c target_laser/target_earthquake regression tests. */
import miniquake2.game.world.constants as hzconstants
import miniquake2.game.world.core as hzcore
import miniquake2.game.world.targets as hztargets
import miniquake2.game.world.types as hztypes
import miniquake2.qcommon.types as hzqtypes

hazardTraceIndex = 0
hazardVictim = void
hazardImmune = void
hazardBlocker = void
hazardDamageNumbers = []
hazardSparkCounts = []
hazardSparkColor = 0
hazardQuakeCalls = 0
hazardQuakeSounds = 0
hazardBlasterCalls = 0
hazardBlasterDamage = 0
hazardBlasterSpeed = 0.0
hazardBlasterDirection = void

function assertEqual(actual, expected, name)
  if actual != expected then return error(9940, name + ": values differ") end if
  return true
end function

function assertTrue(value, name)
  if value != true then return error(9941, name + ": expected true") end if
  return true
end function

function hazardDamage(target, inflictor, attacker, amount, means)
  global hazardDamageNumbers
  hazardDamageNumbers = hazardDamageNumbers + [[target.number, amount, means]]
  return true
end function

function hazardTrace(start, finish, ignore)
  global hazardTraceIndex, hazardVictim, hazardImmune, hazardBlocker
  target = hazardBlocker
  position = hzqtypes.Vec3(96.0, 0.0, 0.0)
  normal = hzqtypes.Vec3(-1.0, 0.0, 0.0)
  if hazardTraceIndex == 0 then
    target = hazardVictim
    position = hzqtypes.Vec3(24.0, 0.0, 0.0)
  else if hazardTraceIndex == 1 then
    target = hazardImmune
    position = hzqtypes.Vec3(56.0, 0.0, 0.0)
  end if
  hazardTraceIndex = hazardTraceIndex + 1
  return hztypes.WorldTrace(true, position, normal, target)
end function

function hazardSparks(origin, normal, count, color)
  global hazardSparkCounts, hazardSparkColor
  hazardSparkCounts = hazardSparkCounts + [count]
  hazardSparkColor = color
  return true
end function

function hazardQuake(entity, speed, playSound)
  global hazardQuakeCalls, hazardQuakeSounds
  hazardQuakeCalls = hazardQuakeCalls + 1
  if playSound then hazardQuakeSounds = hazardQuakeSounds + 1 end if
  return 1
end function

function hazardFireBlaster(entity, direction, damage, speed)
  global hazardBlasterCalls, hazardBlasterDamage, hazardBlasterSpeed
  global hazardBlasterDirection
  hazardBlasterCalls = hazardBlasterCalls + 1
  hazardBlasterDamage = damage
  hazardBlasterSpeed = speed
  hazardBlasterDirection = direction
  return true
end function

function makeHazardWorld()
  callbacks = hzcore.defaultCallbacks()
  callbacks.damage = hazardDamage
  callbacks.traceLine = hazardTrace
  callbacks.laserSparks = hazardSparks
  callbacks.earthquake = hazardQuake
  callbacks.fireBlaster = hazardFireBlaster
  return hzcore.createWorld(callbacks)
end function

function resetLaserTrace()
  global hazardTraceIndex
  hazardTraceIndex = 0
  return true
end function

function testTargetLaserStockTraceAndState()
  global hazardVictim, hazardImmune, hazardBlocker, hazardDamageNumbers
  global hazardSparkCounts, hazardSparkColor
  hazardDamageNumbers = []
  hazardSparkCounts = []
  world = makeHazardWorld()

  aim = hztypes.createEntity(5, "info_notnull")
  aim.targetName = "laser_aim"
  aim.origin = hzqtypes.Vec3(128.0, 0.0, 0.0)
  hzcore.addEntity(world, aim)

  hazardVictim = hztypes.createEntity(2, "player")
  hazardVictim.takeDamage = hzconstants.DAMAGE_AIM
  hazardVictim.isClient = true
  hazardImmune = hztypes.createEntity(3, "monster_boss2")
  hazardImmune.takeDamage = hzconstants.DAMAGE_AIM
  hazardImmune.serverFlags = hzconstants.SVF_MONSTER
  hazardImmune.flags = hzconstants.FL_IMMUNE_LASER
  hazardBlocker = hztypes.createEntity(4, "worldspawn")

  laser = hztypes.createEntity(1, "target_laser")
  laser.target = "laser_aim"
  laser.spawnFlags = 1 | 2 | 64
  laser.damage = 7
  hzcore.addEntity(world, laser)
  hztargets.spawnLaser(laser, world)
  assertEqual(laser.modelIndex, 0, "laser initialization is delayed")

  resetLaserTrace()
  hzcore.advance(world, 1.0)
  assertEqual(laser.modelIndex, 1, "beam requires nonzero model index")
  assertTrue((laser.renderFx & hzconstants.RF_BEAM) != 0,
    "laser publishes RF_BEAM")
  assertTrue((laser.renderFx & hzconstants.RF_TRANSLUCENT) != 0,
    "laser publishes RF_TRANSLUCENT")
  assertEqual(laser.frame, 16, "fat laser diameter")
  assertEqual(laser.style, 0xf2f2f0f0, "red laser packed skin color")
  assertTrue((laser.serverFlags & hzconstants.SVF_NOCLIENT) == 0,
    "start-on laser is visible")
  assertEqual(len(hazardDamageNumbers), 1,
    "laser damages player but not immune boss or world")
  assertEqual(hazardDamageNumbers[0][0], hazardVictim.number,
    "laser damage target")
  assertEqual(hazardDamageNumbers[0][1], 7, "laser authored damage")
  assertEqual(hazardDamageNumbers[0][2], hzconstants.MOD_TARGET_LASER,
    "laser means of death")
  assertEqual(laser.oldOrigin.x, 96.0, "beam endpoint stops on world")
  assertEqual(hazardSparkCounts[0], 8, "initial dirty beam spark count")
  assertEqual(hazardSparkColor & 255, 0xf0, "laser sparks use beam color")

  // A target direction change sets the dirty bit after the frame's initial
  // count selection, matching g_target.c's four-spark moving-target case.
  aim.origin = hzqtypes.Vec3(128.0, 32.0, 0.0)
  resetLaserTrace()
  hzcore.advance(world, world.time + 0.1)
  assertEqual(hazardSparkCounts[1], 4, "moving target spark count")

  hzcore.useEntity(world, laser, void, hazardVictim)
  assertTrue((laser.serverFlags & hzconstants.SVF_NOCLIENT) != 0,
    "laser toggle hides beam")
  assertEqual(laser.nextThink, 0.0, "laser off cancels think")
  resetLaserTrace()
  hzcore.useEntity(world, laser, void, hazardVictim)
  assertTrue((laser.serverFlags & hzconstants.SVF_NOCLIENT) == 0,
    "laser second toggle shows beam")
  assertTrue(laser.nextThink > world.time, "laser on thinks immediately and reschedules")
  return true
end function

function testTargetEarthquakeStockTiming()
  global hazardQuakeCalls, hazardQuakeSounds
  hazardQuakeCalls = 0
  hazardQuakeSounds = 0
  world = makeHazardWorld()
  quake = hztypes.createEntity(1, "target_earthquake")
  quake.targetName = "quake"
  quake.count = 1
  quake.speed = 300.0
  hzcore.addEntity(world, quake)
  hztargets.spawnEarthquake(quake, world)
  assertTrue((quake.serverFlags & hzconstants.SVF_NOCLIENT) != 0,
    "earthquake is no-client")

  hzcore.useEntity(world, quake, void, void)
  hzcore.advance(world, 0.1)
  assertEqual(hazardQuakeCalls, 1, "earthquake first frame effect")
  assertEqual(hazardQuakeSounds, 1, "earthquake first sound")
  hzcore.advance(world, 0.6)
  assertEqual(hazardQuakeSounds, 1, "quake sound waits at least half a second")
  hzcore.advance(world, 0.7)
  assertEqual(hazardQuakeSounds, 2, "quake repeating sound cadence")

  previousEnd = quake.timestamp
  assertTrue(hzcore.useEntity(world, quake, void, void),
    "active earthquake accepts retrigger")
  assertTrue(quake.timestamp > previousEnd,
    "earthquake retrigger extends end time")
  hzcore.advance(world, 1.8)
  assertEqual(quake.nextThink, 0.0, "earthquake stops after duration")
  return true
end function

function testTargetBlasterUsesProjectileBoundary()
  global hazardBlasterCalls, hazardBlasterDamage, hazardBlasterSpeed
  global hazardBlasterDirection
  hazardBlasterCalls = 0
  world = makeHazardWorld()
  blaster = hztypes.createEntity(1, "target_blaster")
  blaster.angles = hzqtypes.Vec3(0.0, 90.0, 0.0)
  hzcore.addEntity(world, blaster)
  hztargets.spawnBlaster(blaster, world)
  assertEqual(blaster.damage, 15, "target blaster default damage")
  assertEqual(blaster.speed, 1000.0, "target blaster default speed")
  hzcore.useEntity(world, blaster, void, void)
  assertEqual(hazardBlasterCalls, 1, "target blaster fires projectile callback")
  assertEqual(hazardBlasterDamage, 15, "target blaster callback damage")
  assertEqual(hazardBlasterSpeed, 1000.0, "target blaster callback speed")
  assertTrue(hazardBlasterDirection.y > 0.99,
    "target blaster callback movedir")
  return true
end function

print "MiniQuake2 target hazard tests starting: 3"
testTargetLaserStockTraceAndState()
testTargetEarthquakeStockTiming()
testTargetBlasterUsesProjectileBoundary()
print "MiniQuake2 target hazard tests passed: 3"
