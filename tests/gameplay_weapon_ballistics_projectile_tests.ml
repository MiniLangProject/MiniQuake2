/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Golden projectile, splash, lifetime, BFG and cooked-hand-grenade scenarios. */
import miniquake2.qcommon.constants as qc
import miniquake2.qcommon.types as qt
import miniquake2.game.gameplay.combat as gpcombat
import miniquake2.game.gameplay.constants as gpconstants
import miniquake2.game.weapons.constants as wbconstants
import miniquake2.game.weapons.types as wbtypes
import miniquake2.game.weapons.core as wbcore
import miniquake2.game.weapons.projectiles as wbprojectiles
import miniquake2.game.weapons.hand_grenade as wbhandgrenade
import miniquake2.game.weapons.vector as wbprojectilevector

radiusTargets = []
randomValues = []
randomOffset = 0
traceMode = "clear"
traceCalls = 0
traceTarget = void
effects = []
sounds = []
damageMeans = []
links = []
frees = []

// Assert the equal test condition.
function assertEqual(actual, expected, name)
  if actual != expected then return error(9975, name + ": expected " + expected + ", got " + actual) end if
  return true
end function
// Assert the near test condition.
function assertNear(actual, expected, tolerance, name)
  difference = actual - expected
  if difference < 0.0 then difference = -difference end if
  if difference > tolerance then return error(9976, name + ": outside tolerance") end if
  return true
end function

// Create trace.
function makeTrace(fraction, endPosition, entity, flags)
  plane = qt.Plane(qt.Vec3(-1.0, 0.0, 0.0), 0.0, 0, 0)
  surface = qt.CollisionSurface("wall", flags, 0)
  return qt.Trace(false, false, fraction, endPosition, plane, surface, 0, entity)
end function
// Trace callback.
function traceCallback(start, mins, maxs, endPosition, ignore, mask)
  global traceMode, traceCalls, traceTarget
  traceCalls = traceCalls + 1
  if traceMode == "bfg-laser" then
    if traceCalls == 1 then return makeTrace(0.5, traceTarget.origin, traceTarget, 0) end if
    return makeTrace(1.0, endPosition, void, 0)
  end if
  if traceMode == "bounce" then
    midpoint = qt.Vec3(
      (start.x + endPosition.x) * 0.5,
      (start.y + endPosition.y) * 0.5,
      (start.z + endPosition.z) * 0.5)
    return makeTrace(0.5, midpoint, traceTarget, 0)
  end if
  return makeTrace(1.0, endPosition, void, 0)
end function
// Return the contents callback value.
function contentsCallback(point) return 0 end function
// Return the damage callback value.
function damageCallback(target, request)
  global damageMeans
  damageMeans = damageMeans + [request.meansOfDeath]
  return gpcombat.T_Damage(target, request)
end function
// Report whether can damage callback.
function canDamageCallback(target, origin) return true end function
// Return the radius targets callback value.
function radiusTargetsCallback(origin, radius)
  global radiusTargets
  return radiusTargets
end function
// Return the effect callback value.
function effectCallback(effect)
  global effects
  effects = effects + [[effect.kind, effect.style, effect.directionIndex]]
  return true
end function
// Return the sound callback value.
function soundCallback(entity, soundName)
  global sounds
  sounds = sounds + [soundName]
  return true
end function
// Link callback.
function linkCallback(entity)
  global links
  links = links + [entity.number]
  return true
end function
// Release callback.
function freeCallback(entity)
  global frees
  frees = frees + [entity.number]
  return true
end function
// Return the noise callback value.
function noiseCallback(owner, position, kind) return true end function
// Return the dodge callback value.
function dodgeCallback(owner, start, direction, speed) return true end function
// Return the random callback value.
function randomCallback()
  global randomValues, randomOffset
  value = randomValues[randomOffset]
  randomOffset = randomOffset + 1
  return value
end function

// Create context.
function makeContext()
  callbacks = wbtypes.WeaponCallbacks(
    traceCallback, contentsCallback, damageCallback, canDamageCallback,
    radiusTargetsCallback, effectCallback, soundCallback, linkCallback,
    freeCallback, noiseCallback, dodgeCallback, randomCallback
  )
  return wbcore.createContext(callbacks)
end function
// Reset state.
function reset()
  global radiusTargets, randomValues, randomOffset, traceMode, traceCalls, traceTarget
  global effects, sounds, damageMeans, links, frees
  radiusTargets = []; randomValues = []; randomOffset = 0
  traceMode = "clear"; traceCalls = 0; traceTarget = void
  effects = []; sounds = []; damageMeans = []; links = []; frees = []
end function

// Verify blaster touch and lifetime.
function testBlasterTouchAndLifetime()
  reset()
  context = makeContext()
  owner = wbtypes.createTarget(1, 100); owner.isClient = true
  victim = wbtypes.createTarget(2, 100)
  projectile = wbprojectiles.fireBlaster(context, owner, qt.Vec3(4.0, 0.0, 0.0), qt.Vec3(2.0, 0.0, 0.0), 15, 1000.0, wbconstants.EF_BLASTER, false)
  assertNear(projectile.velocity.x, 1000.0, 0.001, "normalized blaster speed")
  assertNear(projectile.nextThink, 2.0, 0.001, "blaster lifetime")
  hit = makeTrace(0.5, projectile.origin, victim, 0)
  wbcore.touchProjectile(context, projectile, victim, hit)
  assertEqual(victim.combatant.health, 85, "blaster touch damage")
  assertEqual(damageMeans[0], gpconstants.MOD_BLASTER, "blaster MOD")
  assertEqual(projectile.inUse, false, "blaster freed on touch")

  targetBolt = wbprojectiles.fireTargetBlaster(context, owner, qt.zeroVec3(),
    qt.Vec3(1.0, 0.0, 0.0), 5, 1000.0)
  wbcore.touchProjectile(context, targetBolt, victim,
    makeTrace(0.5, targetBolt.origin, victim, 0))
  assertEqual(damageMeans[1], gpconstants.MOD_TARGET_BLASTER,
    "target blaster distinct MOD")

  second = wbprojectiles.fireBlaster(context, owner, qt.zeroVec3(), qt.Vec3(1.0, 0.0, 0.0), 5, 500.0, wbconstants.EF_HYPERBLASTER, true)
  wbcore.advance(context, 2.0)
  assertEqual(second.inUse, false, "blaster lifetime expiry")
  return true
end function

// Verify grenade bounce direct splash and timer.
function testGrenadeBounceDirectSplashAndTimer()
  reset()
  context = makeContext()
  owner = wbtypes.createTarget(1, 100)
  direct = wbtypes.createTarget(2, 200); direct.origin = qt.Vec3(20.0, 0.0, 0.0)
  splash = wbtypes.createTarget(3, 200); splash.origin = qt.Vec3(40.0, 0.0, 0.0)
  wall = wbtypes.createTarget(9, 1); wall.combatant.takeDamage = false
  global radiusTargets, randomValues
  radiusTargets = [direct, splash]; randomValues = [0.5, -0.5, 0.5]
  grenade = wbprojectiles.fireGrenade(context, owner, qt.zeroVec3(), qt.Vec3(1.0, 0.0, 0.0), 100, 600.0, 1.0, 120.0)
  assertNear(grenade.velocity.x, 600.0, 0.001, "grenade forward velocity")
  assertNear(grenade.velocity.y, 5.0, 0.001, "grenade lateral toss")
  assertNear(grenade.velocity.z, 205.0, 0.001, "grenade upward toss")
  wbcore.touchProjectile(context, grenade, wall, makeTrace(0.5, grenade.origin, wall, 0))
  assertEqual(grenade.inUse, true, "grenade bounces from world")
  assertEqual(sounds[0], "weapons/grenlb1b.wav", "launcher grenade bounce")
  wbcore.touchProjectile(context, grenade, direct, makeTrace(0.5, grenade.origin, direct, 0))
  assertEqual(grenade.inUse, false, "grenade freed after direct impact")
  assertEqual(direct.combatant.health, 110, "grenade direct distance falloff")
  assertEqual(splash.combatant.health, 120, "grenade splash falloff")
  assertEqual(damageMeans[0], gpconstants.MOD_GRENADE, "grenade direct MOD")
  assertEqual(damageMeans[1], gpconstants.MOD_G_SPLASH, "grenade splash MOD")

  // SV_Physics_Toss applies gravity before movement and clips a bouncing
  // grenade with the stock 1.5 overbounce factor.
  reset()
  context = makeContext()
  global randomValues, traceMode, traceTarget
  randomValues = [0.0, 0.0]
  bounceWall = wbtypes.createTarget(8, 1)
  bounceWall.combatant.takeDamage = false
  traceMode = "bounce"; traceTarget = bounceWall
  bouncing = wbprojectiles.fireGrenade(context, owner, qt.zeroVec3(),
    qt.Vec3(1.0, 0.0, 0.0), 100, 600.0, 2.5, 160.0)
  wbprojectiles.advanceProjectile(context, bouncing)
  assertNear(bouncing.velocity.z, 120.0, 0.001,
    "grenade receives one stock gravity frame")
  assertNear(bouncing.origin.x, 30.0, 0.001,
    "grenade stops at bounce trace fraction")
  assertNear(bouncing.velocity.x, -300.0, 0.001,
    "grenade uses stock 1.5 overbounce")

  global randomValues, randomOffset
  randomValues = [0.0, 0.0]; randomOffset = 0
  timed = wbprojectiles.fireGrenade(context, owner, qt.zeroVec3(), qt.Vec3(1.0, 0.0, 0.0), 50, 500.0, 0.5, 80.0)
  wbcore.advance(context, 0.5)
  assertEqual(timed.inUse, false, "grenade timer explosion")
  return true
end function

// Verify rocket direct splash and sky.
function testRocketDirectSplashAndSky()
  reset()
  context = makeContext()
  owner = wbtypes.createTarget(1, 100)
  direct = wbtypes.createTarget(2, 200); direct.origin = qt.Vec3(10.0, 0.0, 0.0)
  splash = wbtypes.createTarget(3, 200); splash.origin = qt.Vec3(20.0, 0.0, 0.0)
  global radiusTargets; radiusTargets = [direct, splash]
  rocket = wbprojectiles.fireRocket(context, owner, qt.zeroVec3(), qt.Vec3(1.0, 0.0, 0.0), 40, 650.0, 100.0, 50)
  assertNear(rocket.nextThink, 12.0, 0.001, "C integer rocket lifetime")
  wbcore.touchProjectile(context, rocket, direct, makeTrace(0.2, direct.origin, direct, 0))
  assertEqual(direct.combatant.health, 160, "rocket direct damage")
  assertEqual(splash.combatant.health, 160, "rocket splash damage")
  assertEqual(damageMeans[0], gpconstants.MOD_ROCKET, "rocket direct MOD")
  assertEqual(damageMeans[1], gpconstants.MOD_R_SPLASH, "rocket splash MOD")

  skyRocket = wbprojectiles.fireRocket(context, owner, qt.zeroVec3(), qt.Vec3(1.0, 0.0, 0.0), 40, 800.0, 100.0, 50)
  beforeEffects = len(effects)
  wbcore.touchProjectile(context, skyRocket, void, makeTrace(0.2, qt.Vec3(2.0, 0.0, 0.0), void, qc.SURF_SKY))
  assertEqual(skyRocket.inUse, false, "sky frees rocket")
  assertEqual(len(effects), beforeEffects, "sky has no explosion")
  return true
end function

// Verify bfg laser touch effect frames.
function testBfgLaserTouchEffectFrames()
  reset()
  context = makeContext()
  owner = wbtypes.createTarget(1, 500)
  laserVictim = wbtypes.createTarget(2, 500); laserVictim.isMonster = true; laserVictim.origin = qt.Vec3(50.0, 0.0, 0.0)
  global radiusTargets, traceMode, traceTarget
  radiusTargets = [laserVictim]; traceMode = "bfg-laser"; traceTarget = laserVictim
  bfg = wbprojectiles.fireBfg(context, owner, qt.zeroVec3(), qt.Vec3(1.0, 0.0, 0.0), 200, 400.0, 100.0)
  assertEqual(bfg.modelName, "sprites/s_bfg1.sp2", "BFG flight sprite")
  assertEqual(bfg.soundName, "weapons/bfg__l1a.wav", "BFG flight loop sound")
  assertEqual((bfg.effects & wbconstants.EF_ANIM_ALLFAST) != 0, true,
    "BFG fast flight animation effect")
  wbcore.advance(context, 0.1)
  assertEqual(laserVictim.combatant.health, 490, "BFG scanning laser damage")
  assertEqual(damageMeans[0], gpconstants.MOD_BFG_LASER, "BFG laser MOD")

  immuneVictim = wbtypes.createTarget(5, 500)
  immuneVictim.isMonster = true
  immuneVictim.flags = wbconstants.FL_IMMUNE_LASER
  immuneVictim.origin = qt.Vec3(60.0, 0.0, 0.0)
  radiusTargets = [immuneVictim]
  traceCalls = 0
  traceTarget = immuneVictim
  wbprojectiles.bfgThink(bfg, context)
  assertEqual(immuneVictim.combatant.health, 500,
    "BFG scanning laser respects FL_IMMUNE_LASER")

  traceMode = "clear"
  direct = wbtypes.createTarget(3, 500)
  effectVictim = wbtypes.createTarget(4, 500); effectVictim.origin = qt.Vec3(25.0, 0.0, 0.0)
  radiusTargets = [effectVictim]
  wbcore.touchProjectile(context, bfg, direct, makeTrace(0.2, direct.origin, direct, 0))
  assertEqual(direct.combatant.health, 300, "BFG direct blast")
  assertEqual(bfg.solid, wbconstants.SOLID_NOT, "BFG becomes non-solid")
  assertEqual(bfg.modelName, "sprites/s_bfg3.sp2", "BFG explosion sprite")
  assertEqual(bfg.soundName, "", "BFG flight loop stops on impact")
  assertEqual((bfg.effects & wbconstants.EF_ANIM_ALLFAST) == 0, true,
    "BFG explosion clears fast flight animation")
  wbcore.advance(context, 0.1)
  assertEqual(damageMeans[3], gpconstants.MOD_BFG_EFFECT, "BFG effect MOD")
  wbcore.advance(context, 0.1); wbcore.advance(context, 0.1); wbcore.advance(context, 0.1); wbcore.advance(context, 0.1); wbcore.advance(context, 0.1)
  assertEqual(bfg.inUse, false, "BFG animation lifetime")
  return true
end function

// Advance hand to frame.
function advanceHandToFrame(context, state, targetFrame, start, direction)
  guard = 0
  while state.gunFrame < targetFrame and guard < 64
    wbhandgrenade.step(context, state, start, direction, 125, 165.0)
    context.time = context.time + 0.1
    guard = guard + 1
  end while
  return guard
end function

// Verify hand grenade cook and release.
function testHandGrenadeCookAndRelease()
  reset()
  context = makeContext()
  owner = wbtypes.createTarget(1, 500)
  global radiusTargets, randomValues
  radiusTargets = [owner]
  state = wbtypes.createHandGrenadeState(owner, 2)
  state.buttons = wbconstants.BUTTON_ATTACK
  wbhandgrenade.step(context, state, qt.zeroVec3(), qt.Vec3(1.0, 0.0, 0.0), 125, 165.0)
  advanceHandToFrame(context, state, 11, qt.zeroVec3(), qt.Vec3(1.0, 0.0, 0.0))
  randomValues = [0.0, 0.0]
  wbhandgrenade.step(context, state, qt.zeroVec3(), qt.Vec3(1.0, 0.0, 0.0), 125, 165.0)
  cookUntil = state.grenadeTime
  context.time = cookUntil
  wbhandgrenade.step(context, state, qt.zeroVec3(), qt.Vec3(1.0, 0.0, 0.0), 125, 165.0)
  assertEqual(state.grenadeBlewUp, true, "held grenade detonated")
  assertEqual(state.lastProjectile.spawnFlags, 3, "held hand grenade flags")
  assertEqual(state.lastProjectile.inUse, false, "held grenade explodes immediately")
  assertEqual(state.ammo, 1, "held grenade ammo")
  assertEqual(damageMeans[0], wbconstants.MOD_HELD_GRENADE, "held grenade MOD")

  reset()
  context = makeContext()
  state = wbtypes.createHandGrenadeState(owner, 2)
  state.buttons = wbconstants.BUTTON_ATTACK
  wbhandgrenade.step(context, state, qt.zeroVec3(), qt.Vec3(1.0, 0.0, 0.0), 125, 165.0)
  advanceHandToFrame(context, state, 11, qt.zeroVec3(), qt.Vec3(1.0, 0.0, 0.0))
  randomValues = [0.0, 0.0]
  wbhandgrenade.step(context, state, qt.zeroVec3(), qt.Vec3(1.0, 0.0, 0.0), 125, 165.0)
  state.buttons = 0
  context.time = context.time + 0.1
  wbhandgrenade.step(context, state, qt.zeroVec3(), qt.Vec3(1.0, 0.0, 0.0), 125, 165.0)
  context.time = context.time + 0.1
  wbhandgrenade.step(context, state, qt.zeroVec3(), qt.Vec3(1.0, 0.0, 0.0), 125, 165.0)
  assertEqual(state.lastProjectile.inUse, true, "released grenade is live")
  assertEqual(state.lastProjectile.spawnFlags, 1, "released hand grenade flags")
  assertEqual(state.ammo, 1, "released grenade ammo")
  assertEqual(state.weaponSound, "", "cook sound stopped")
  return true
end function

// Return the replay golden value.
function replayGolden()
  reset()
  context = makeContext()
  owner = wbtypes.createTarget(1, 100)
  direct = wbtypes.createTarget(2, 200); direct.origin = qt.Vec3(20.0, 0.0, 0.0)
  splash = wbtypes.createTarget(3, 200); splash.origin = qt.Vec3(40.0, 0.0, 0.0)
  global radiusTargets, randomValues
  radiusTargets = [direct, splash]; randomValues = [0.25, -0.75]
  grenade = wbprojectiles.fireGrenade(context, owner, qt.Vec3(5.0, 1.0, 2.0), qt.Vec3(1.0, 0.0, 0.0), 100, 600.0, 1.0, 120.0)
  velocity = [grenade.velocity.x, grenade.velocity.y, grenade.velocity.z]
  wbcore.touchProjectile(context, grenade, direct, makeTrace(0.5, direct.origin, direct, 0))
  return [velocity, direct.combatant.health, splash.combatant.health, damageMeans, effects]
end function

// Verify deterministic replay.
function testDeterministicReplay()
  first = replayGolden()
  second = replayGolden()
  assertEqual(second, first, "deterministic replay snapshot")
  return true
end function

// Verify weapon vector gc hardening.
function testWeaponVectorGcHardening()
  assertEqual(typeof(try(wbprojectilevector.copy(17))), "error", "weapon vector rejects scalar shape")
  assertEqual(typeof(try(wbprojectilevector.copy(wbtypes.createTarget(90, 1)))), "error", "weapon vector rejects non-Vec3 struct")
  assertEqual(typeof(try(wbprojectilevector.midpoint(qt.zeroVec3()))), "error", "weapon midpoint rejects wrong struct")

  base = qt.Vec3(3.0, 4.0, 12.0)
  direction = qt.Vec3(-2.0, 5.0, 1.0)
  zeroAngles = qt.Vec3(0.0, 0.0, 0.0)
  target = wbtypes.createTarget(91, 1)
  target.origin = qt.Vec3(10.0, 20.0, 30.0)
  iteration = 0
  checksum = 0.0
  while iteration < 6000
    copied = wbprojectilevector.copy(base)
    copiedX = copied.x; copiedY = copied.y; copiedZ = copied.z
    added = wbprojectilevector.add(base, direction)
    addedX = added.x; addedY = added.y; addedZ = added.z
    subtracted = wbprojectilevector.subtract(base, direction)
    subtractedX = subtracted.x; subtractedY = subtracted.y; subtractedZ = subtracted.z
    scaled = wbprojectilevector.scale(base, 0.5)
    scaledX = scaled.x; scaledY = scaled.y; scaledZ = scaled.z
    multiplied = wbprojectilevector.multiplyAdd(base, 2.0, direction)
    multipliedX = multiplied.x; multipliedY = multiplied.y; multipliedZ = multiplied.z
    dotValue = wbprojectilevector.dot(base, direction)
    lengthValue = wbprojectilevector.length(base)
    normalized = wbprojectilevector.normalized(base)
    normalizedVector = normalized[0]
    normalizedX = normalizedVector.x; normalizedY = normalizedVector.y; normalizedZ = normalizedVector.z
    normalizedLength = normalized[1]
    middle = wbprojectilevector.midpoint(target)
    middleX = middle.x; middleY = middle.y; middleZ = middle.z
    coordinates = wbprojectilevector.toArray(base)
    coordinateX = coordinates[0]; coordinateY = coordinates[1]; coordinateZ = coordinates[2]
    vectorAngles = wbprojectilevector.vectorToAngles(qt.Vec3(1.0, 0.0, 0.0))
    angleX = vectorAngles.x; angleY = vectorAngles.y; angleZ = vectorAngles.z
    basis = wbprojectilevector.angleVectors(zeroAngles)
    forward = basis[0]; right = basis[1]; up = basis[2]
    forwardX = forward.x; rightY = right.y; upZ = up.z

    checksum = copiedX + copiedY + copiedZ + addedX + addedY + addedZ +
      subtractedX + subtractedY + subtractedZ + scaledX + scaledY + scaledZ +
      multipliedX + multipliedY + multipliedZ + dotValue + lengthValue +
      normalizedX + normalizedY + normalizedZ + normalizedLength +
      middleX + middleY + middleZ + coordinateX + coordinateY + coordinateZ +
      angleX + angleY + angleZ + forwardX + rightY + upZ
    iteration = iteration + 1
  end while
  assertNear(checksum, 225.5 + 19.0 / 13.0, 0.0000001, "weapon vector low-GC checksum")
  return true
end function

testBlasterTouchAndLifetime()
testGrenadeBounceDirectSplashAndTimer()
testRocketDirectSplashAndSky()
testBfgLaserTouchEffectFrames()
testHandGrenadeCookAndRelease()
testDeterministicReplay()
testWeaponVectorGcHardening()
print("gameplay weapon projectile tests passed")
