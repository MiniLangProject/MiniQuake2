/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Golden deterministic scenarios for BaseQ2 lead, water, shotgun and rail. */
import miniquake2.qcommon.constants as qc
import miniquake2.qcommon.types as qt
import miniquake2.game.gameplay.combat as gpcombat
import miniquake2.game.gameplay.constants as gpconstants
import miniquake2.game.weapons.constants as wbconstants
import miniquake2.game.weapons.types as wbtypes
import miniquake2.game.weapons.core as wbcore
import miniquake2.game.weapons.hitscan as wbhitscan

traceMode = "clear"
traceCalls = 0
randomValues = []
randomOffset = 0
hitTargets = []
effects = []
damageMeans = []

function assertEqual(actual, expected, name)
  if actual != expected then return error(9970, name + ": expected " + expected + ", got " + actual) end if
  return true
end function
function assertNear(actual, expected, tolerance, name)
  difference = actual - expected
  if difference < 0.0 then difference = -difference end if
  if difference > tolerance then return error(9971, name + ": outside tolerance") end if
  return true
end function

function makeTrace(fraction, endPosition, contents, entity, name, flags)
  plane = qt.Plane(qt.Vec3(-1.0, 0.0, 0.0), 0.0, 0, 0)
  surface = qt.CollisionSurface(name, flags, 0)
  return qt.Trace(false, false, fraction, endPosition, plane, surface, contents, entity)
end function

function traceCallback(start, mins, maxs, endPosition, ignore, mask)
  global traceMode, traceCalls, hitTargets
  traceCalls = traceCalls + 1
  if traceMode == "bullet" and traceCalls == 2 then return makeTrace(0.25, qt.Vec3(100.0, 2.0, -1.0), 0, hitTargets[0], "stone", 0) end if
  if traceMode == "shotgun" and (traceCalls == 2 or traceCalls == 4 or traceCalls == 6) then return makeTrace(0.25, qt.Vec3(100.0, 0.0, 0.0), 0, hitTargets[0], "stone", 0) end if
  if traceMode == "water" then
    if traceCalls == 2 then return makeTrace(0.1, qt.Vec3(10.0, 0.0, 0.0), qc.CONTENTS_WATER, void, "*brwater", 0) end if
    if traceCalls == 3 then return makeTrace(0.5, qt.Vec3(50.0, 0.0, 0.0), 0, hitTargets[0], "metal", 0) end if
  end if
  if traceMode == "rail" then
    if traceCalls == 1 then return makeTrace(0.2, qt.Vec3(20.0, 0.0, 0.0), 0, hitTargets[0], "flesh", 0) end if
    if traceCalls == 2 then return makeTrace(0.4, qt.Vec3(40.0, 0.0, 0.0), 0, hitTargets[1], "flesh", 0) end if
    return makeTrace(0.6, qt.Vec3(60.0, 0.0, 0.0), 0, void, "wall", 0)
  end if
  return makeTrace(1.0, endPosition, 0, void, "", 0)
end function
function contentsCallback(point)
  global traceMode
  if traceMode == "water" and point.x >= 8.0 then return qc.CONTENTS_WATER end if
  return 0
end function
function damageCallback(target, request)
  global damageMeans
  damageMeans = damageMeans + [request.meansOfDeath]
  return gpcombat.T_Damage(target, request)
end function
function canDamageCallback(target, origin)
  return true
end function
function radiusTargetsCallback(origin, radius)
  return []
end function
function effectCallback(effect)
  global effects
  effects = effects + [[effect.kind, effect.style, effect.directionIndex]]
  return true
end function
function soundCallback(entity, soundName) return true end function
function linkCallback(entity) return true end function
function freeCallback(entity) return true end function
function noiseCallback(owner, position, kind) return true end function
function dodgeCallback(owner, start, direction, speed) return true end function
function randomCallback()
  global randomValues, randomOffset
  value = randomValues[randomOffset]
  randomOffset = randomOffset + 1
  return value
end function

function makeContext()
  callbacks = wbtypes.WeaponCallbacks(
    traceCallback, contentsCallback, damageCallback, canDamageCallback,
    radiusTargetsCallback, effectCallback, soundCallback, linkCallback,
    freeCallback, noiseCallback, dodgeCallback, randomCallback
  )
  return wbcore.createContext(callbacks)
end function

function reset(mode)
  global traceMode, traceCalls, randomValues, randomOffset
  global hitTargets, effects, damageMeans
  traceMode = mode; traceCalls = 0; randomValues = []; randomOffset = 0
  hitTargets = []; effects = []; damageMeans = []
end function

function testBulletAndSpread()
  reset("bullet")
  context = makeContext()
  shooter = wbtypes.createTarget(1, 100); shooter.isClient = true
  victim = wbtypes.createTarget(2, 100)
  global hitTargets, randomValues
  hitTargets = [victim]; randomValues = [0.5, -0.25]
  wbhitscan.fireBullet(context, shooter, qt.Vec3(1.0, 0.0, 0.0), qt.Vec3(1.0, 0.0, 0.0), 10, 2, 100.0, 200.0, gpconstants.MOD_MACHINEGUN)
  assertEqual(victim.combatant.health, 90, "bullet damage")
  assertEqual(damageMeans[0], gpconstants.MOD_MACHINEGUN, "bullet MOD")
  assertEqual(traceCalls, 2, "muzzle plus lead trace")
  assertEqual(randomOffset, 2, "lead consumes exactly two spread samples")
  return true
end function

function testWaterRefraction()
  reset("water")
  context = makeContext()
  shooter = wbtypes.createTarget(1, 100)
  victim = wbtypes.createTarget(2, 100)
  global hitTargets, randomValues
  hitTargets = [victim]; randomValues = [0.0, 0.0, 0.25, -0.5]
  wbhitscan.fireBullet(context, shooter, qt.Vec3(1.0, 0.0, 0.0), qt.Vec3(1.0, 0.0, 0.0), 8, 1, 10.0, 10.0, gpconstants.MOD_MACHINEGUN)
  assertEqual(victim.combatant.health, 92, "water bullet damage")
  assertEqual(effects[0][0], "splash", "water entry effect")
  assertEqual(effects[0][1], wbconstants.SPLASH_BROWN_WATER, "brown water color")
  assertEqual(effects[1][0], "bubble-trail", "bubble trail effect")
  assertEqual(randomOffset, 4, "water consumes second spread pair")
  return true
end function

function testShotgunAndRailPenetration()
  reset("shotgun")
  context = makeContext()
  shooter = wbtypes.createTarget(1, 100)
  victim = wbtypes.createTarget(2, 100)
  global hitTargets, randomValues
  hitTargets = [victim]; randomValues = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
  wbhitscan.fireShotgun(context, shooter, qt.zeroVec3(), qt.Vec3(1.0, 0.0, 0.0), 3, 1, 0.0, 0.0, 3, gpconstants.MOD_SHOTGUN)
  assertEqual(victim.combatant.health, 91, "three shotgun pellets")

  reset("rail")
  context = makeContext()
  first = wbtypes.createTarget(2, 100); first.isMonster = true
  second = wbtypes.createTarget(3, 100); second.isClient = true
  global hitTargets
  hitTargets = [first, second]
  wbhitscan.fireRail(context, shooter, qt.zeroVec3(), qt.Vec3(1.0, 0.0, 0.0), 30, 4)
  assertEqual(first.combatant.health, 70, "rail first target")
  assertEqual(second.combatant.health, 70, "rail second target")
  assertEqual(traceCalls, 3, "rail penetration trace count")
  assertEqual(effects[0][0], "rail-trail", "rail effect")
  return true
end function

testBulletAndSpread()
testWaterRefraction()
testShotgunAndRailPenetration()
print("gameplay weapon hitscan tests passed")
