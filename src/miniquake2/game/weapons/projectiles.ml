/* BaseQ2 blaster, grenade, rocket and BFG projectile state machines. */
package miniquake2.game.weapons.projectiles

import std.math as smath
import miniquake2.qcommon.byteio as qbyteio
import miniquake2.qcommon.constants as qc
import miniquake2.qcommon.types as qt
import miniquake2.game.gameplay.constants as gpconstants
import miniquake2.game.weapons.constants as wbconstants
import miniquake2.game.weapons.core as wbcore
import miniquake2.game.weapons.vector as wbvector

function ownerImpactNoise(projectile, context)
  if projectile.owner is not void and projectile.owner.isClient then
    return context.callbacks.playerNoise(projectile.owner, projectile.origin, 2)
  end if
  return false
end function

function blasterTouch(projectile, other, trace, context)
  if other is not void and projectile.owner is not void and other.number == projectile.owner.number then return false end if
  if wbcore.surfaceIsSky(trace) then return wbcore.freeProjectile(context, projectile) end if
  ownerImpactNoise(projectile, context)
  if other is not void and other.combatant is not void and other.combatant.takeDamage then
    means = gpconstants.MOD_BLASTER
    if (projectile.spawnFlags & 1) != 0 then means = gpconstants.MOD_HYPERBLASTER end if
    normal = qt.zeroVec3()
    if trace is not void and trace.plane is not void then normal = trace.plane.normal end if
    wbcore.applyDamage(context, other, projectile, projectile.owner, projectile.velocity, projectile.origin, projectile.damage, 1, gpconstants.DAMAGE_ENERGY, means)
  else
    normal = qt.zeroVec3()
    if trace is not void and trace.plane is not void then normal = trace.plane.normal end if
    wbcore.emitEffect(context, "blaster-impact", projectile.origin, projectile.origin, normal, 0, 1)
  end if
  return wbcore.freeProjectile(context, projectile)
end function

function fireBlaster(context, owner, start, direction, damage, speed, effect, hyper)
  normalized = wbvector.normalized(direction)[0]
  projectile = wbcore.spawnProjectile(context, "bolt")
  projectile.origin = wbvector.copy(start)
  projectile.oldOrigin = wbvector.copy(start)
  projectile.angles = wbvector.vectorToAngles(normalized)
  projectile.velocity = wbvector.scale(normalized, speed)
  projectile.moveType = wbconstants.MOVETYPE_FLYMISSILE
  projectile.clipMask = qc.MASK_SHOT
  projectile.solid = wbconstants.SOLID_BBOX
  projectile.effects = effect
  projectile.owner = owner
  projectile.touch = blasterTouch
  projectile.nextThink = context.time + 2.0
  projectile.think = wbcore.freeThink
  projectile.damage = damage
  if hyper then projectile.spawnFlags = 1 end if
  context.callbacks.dodge(owner, start, normalized, speed)
  context.callbacks.linkEntity(projectile)
  zero = qt.zeroVec3()
  trace = context.callbacks.trace(owner.origin, zero, zero, projectile.origin, projectile, qc.MASK_SHOT)
  if trace.fraction < 1.0 then
    projectile.origin = wbvector.multiplyAdd(projectile.origin, -10.0, normalized)
    blasterTouch(projectile, trace.entity, trace, context)
  end if
  return projectile
end function

function grenadeExplode(projectile, context)
  ownerImpactNoise(projectile, context)
  if projectile.enemy is not void and projectile.enemy.combatant is not void and projectile.enemy.combatant.takeDamage then
    center = wbvector.midpoint(projectile.enemy)
    points = projectile.damage - 0.5 * wbvector.length(wbvector.subtract(projectile.origin, center))
    amount = qbyteio.truncInt(points)
    means = gpconstants.MOD_GRENADE
    if (projectile.spawnFlags & 1) != 0 then means = gpconstants.MOD_HANDGRENADE end if
    if amount > 0 then
      wbcore.applyDamage(context, projectile.enemy, projectile, projectile.owner, wbvector.subtract(projectile.enemy.origin, projectile.origin), projectile.origin, amount, amount, gpconstants.DAMAGE_RADIUS, means)
    end if
  end if
  splashMeans = gpconstants.MOD_G_SPLASH
  if (projectile.spawnFlags & 2) != 0 then splashMeans = wbconstants.MOD_HELD_GRENADE
  else if (projectile.spawnFlags & 1) != 0 then splashMeans = gpconstants.MOD_HG_SPLASH
  end if
  wbcore.radiusDamage(context, projectile, projectile.owner, projectile.damage, projectile.enemy, projectile.damageRadius, splashMeans)
  effect = "rocket-explosion"
  if projectile.groundEntity is not void then effect = "grenade-explosion" end if
  if projectile.waterLevel != 0 then
    effect = "rocket-explosion-water"
    if projectile.groundEntity is not void then effect = "grenade-explosion-water" end if
  end if
  effectOrigin = wbvector.multiplyAdd(projectile.origin, -0.02, projectile.velocity)
  wbcore.emitEffect(context, effect, effectOrigin, effectOrigin, qt.Vec3(0.0, 0.0, 1.0), 0, 1)
  return wbcore.freeProjectile(context, projectile)
end function

function grenadeTouch(projectile, other, trace, context)
  if other is not void and projectile.owner is not void and other.number == projectile.owner.number then return false end if
  if wbcore.surfaceIsSky(trace) then return wbcore.freeProjectile(context, projectile) end if
  if other is void or other.combatant is void or other.combatant.takeDamage == false then
    soundName = "weapons/grenlb1b.wav"
    if (projectile.spawnFlags & 1) != 0 then
      if context.callbacks.randomSigned() > 0.0 then soundName = "weapons/hgrenb1a.wav" else soundName = "weapons/hgrenb2a.wav" end if
    end if
    context.callbacks.sound(projectile, soundName)
    return false
  end if
  projectile.enemy = other
  return grenadeExplode(projectile, context)
end function

function grenadeVelocity(context, direction, speed)
  basis = wbvector.angleVectors(wbvector.vectorToAngles(direction))
  velocity = wbvector.scale(direction, speed)
  velocity = wbvector.multiplyAdd(velocity, 200.0 + context.callbacks.randomSigned() * 10.0, basis[2])
  velocity = wbvector.multiplyAdd(velocity, context.callbacks.randomSigned() * 10.0, basis[1])
  return velocity
end function

function configureGrenade(context, owner, start, direction, damage, speed, timer, damageRadius, hand, held)
  className = "grenade"
  if hand then className = "hgrenade" end if
  projectile = wbcore.spawnProjectile(context, className)
  projectile.origin = wbvector.copy(start)
  projectile.oldOrigin = wbvector.copy(start)
  projectile.velocity = grenadeVelocity(context, direction, speed)
  projectile.angularVelocity = qt.Vec3(300.0, 300.0, 300.0)
  projectile.moveType = wbconstants.MOVETYPE_BOUNCE
  projectile.clipMask = qc.MASK_SHOT
  projectile.solid = wbconstants.SOLID_BBOX
  projectile.effects = wbconstants.EF_GRENADE
  projectile.owner = owner
  projectile.touch = grenadeTouch
  projectile.think = grenadeExplode
  projectile.nextThink = context.time + timer
  projectile.damage = damage
  projectile.damageRadius = damageRadius
  if hand then
    projectile.spawnFlags = 1
    if held then projectile.spawnFlags = 3 end if
  end if
  if timer <= 0.0 then
    grenadeExplode(projectile, context)
  else
    context.callbacks.linkEntity(projectile)
    if hand then context.callbacks.sound(owner, "weapons/hgrent1a.wav") end if
  end if
  return projectile
end function

function fireGrenade(context, owner, start, direction, damage, speed, timer, damageRadius)
  return configureGrenade(context, owner, start, direction, damage, speed, timer, damageRadius, false, false)
end function

function fireGrenade2(context, owner, start, direction, damage, speed, timer, damageRadius, held)
  return configureGrenade(context, owner, start, direction, damage, speed, timer, damageRadius, true, held)
end function

function rocketTouch(projectile, other, trace, context)
  if other is not void and projectile.owner is not void and other.number == projectile.owner.number then return false end if
  if wbcore.surfaceIsSky(trace) then return wbcore.freeProjectile(context, projectile) end if
  ownerImpactNoise(projectile, context)
  if other is not void and other.combatant is not void and other.combatant.takeDamage then
    wbcore.applyDamage(context, other, projectile, projectile.owner, projectile.velocity, projectile.origin, projectile.damage, 0, 0, gpconstants.MOD_ROCKET)
  end if
  wbcore.radiusDamage(context, projectile, projectile.owner, projectile.radiusDamage, other, projectile.damageRadius, gpconstants.MOD_R_SPLASH)
  effect = "rocket-explosion"
  if projectile.waterLevel != 0 then effect = "rocket-explosion-water" end if
  effectOrigin = wbvector.multiplyAdd(projectile.origin, -0.02, projectile.velocity)
  wbcore.emitEffect(context, effect, effectOrigin, effectOrigin, qt.Vec3(0.0, 0.0, 1.0), 0, 1)
  return wbcore.freeProjectile(context, projectile)
end function

function fireRocket(context, owner, start, direction, damage, speed, damageRadius, radiusDamage)
  projectile = wbcore.spawnProjectile(context, "rocket")
  projectile.origin = wbvector.copy(start)
  projectile.oldOrigin = wbvector.copy(start)
  projectile.angles = wbvector.vectorToAngles(direction)
  projectile.velocity = wbvector.scale(direction, speed)
  projectile.moveType = wbconstants.MOVETYPE_FLYMISSILE
  projectile.clipMask = qc.MASK_SHOT
  projectile.solid = wbconstants.SOLID_BBOX
  projectile.effects = wbconstants.EF_ROCKET
  projectile.owner = owner
  projectile.touch = rocketTouch
  projectile.damage = damage
  projectile.radiusDamage = radiusDamage
  projectile.damageRadius = damageRadius
  projectile.think = wbcore.freeThink
  lifetime = 0
  if speed > 0.0 then lifetime = qbyteio.truncInt(8000.0 / speed) end if
  projectile.nextThink = context.time + lifetime
  context.callbacks.dodge(owner, start, direction, speed)
  context.callbacks.linkEntity(projectile)
  return projectile
end function

function bfgThink(projectile, context)
  candidates = context.callbacks.radiusTargets(projectile.origin, 256.0)
  for each target in candidates
    validClass = target.isMonster or target.isClient or target.className == "misc_explobox"
    if target.inUse and validClass and target.combatant is not void and target.combatant.takeDamage and projectile.owner is not void and target.number != projectile.owner.number then
      endPosition = wbvector.midpoint(target)
      direction = wbvector.normalized(wbvector.subtract(endPosition, projectile.origin))[0]
      damage = 10
      if context.deathmatch then damage = 5 end if
      traceFrom = wbvector.copy(projectile.origin)
      ignore = projectile
      tracing = true
      pass = 0
      laserEnd = wbvector.copy(endPosition)
      laserNormal = qt.Vec3(0.0, 0.0, 1.0)
      while tracing and pass < 32
        pass = pass + 1
        trace = context.callbacks.trace(traceFrom, qt.zeroVec3(), qt.zeroVec3(), endPosition, ignore, qc.MASK_SOLID | qc.CONTENTS_MONSTER | qc.CONTENTS_DEADMONSTER)
        hit = trace.entity
        laserEnd = wbvector.copy(trace.endPosition)
        laserNormal = wbvector.copy(trace.plane.normal)
        if hit is not void and hit.combatant is not void and hit.combatant.takeDamage and (projectile.owner is void or hit.number != projectile.owner.number) then
          wbcore.applyDamage(context, hit, projectile, projectile.owner, direction, trace.endPosition, damage, 1, gpconstants.DAMAGE_ENERGY, gpconstants.MOD_BFG_LASER)
        end if
        tracing = hit is not void and (hit.isMonster or hit.isClient)
        if tracing then ignore = hit; traceFrom = wbvector.copy(trace.endPosition) end if
      end while
      wbcore.emitEffect(context, "bfg-laser", projectile.origin, laserEnd, laserNormal, 0, 1)
    end if
  end for
  projectile.nextThink = context.time + context.frameTime
  return true
end function

function bfgExplode(projectile, context)
  if projectile.frame == 0 then
    candidates = context.callbacks.radiusTargets(projectile.origin, projectile.damageRadius)
    for each target in candidates
      if target.inUse and target.combatant is not void and target.combatant.takeDamage and projectile.owner is not void and target.number != projectile.owner.number then
        if context.callbacks.canDamage(target, projectile.origin) and context.callbacks.canDamage(target, projectile.owner.origin) then
          distance = wbvector.length(wbvector.subtract(projectile.origin, wbvector.midpoint(target)))
          ratio = distance / projectile.damageRadius
          if ratio < 0.0 then ratio = 0.0 end if
          points = projectile.radiusDamage * (1.0 - smath.sqrt(ratio))
          amount = qbyteio.truncInt(points)
          if amount > 0 then
            wbcore.emitEffect(context, "bfg-target-explosion", target.origin, target.origin, qt.Vec3(0.0, 0.0, 1.0), 0, 1)
            wbcore.applyDamage(context, target, projectile, projectile.owner, projectile.velocity, target.origin, amount, 0, gpconstants.DAMAGE_ENERGY, gpconstants.MOD_BFG_EFFECT)
          end if
        end if
      end if
    end for
  end if
  projectile.nextThink = context.time + context.frameTime
  projectile.frame = projectile.frame + 1
  if projectile.frame == 5 then projectile.think = wbcore.freeThink end if
  return true
end function

function bfgTouch(projectile, other, trace, context)
  if other is not void and projectile.owner is not void and other.number == projectile.owner.number then return false end if
  if wbcore.surfaceIsSky(trace) then return wbcore.freeProjectile(context, projectile) end if
  ownerImpactNoise(projectile, context)
  if other is not void and other.combatant is not void and other.combatant.takeDamage then
    wbcore.applyDamage(context, other, projectile, projectile.owner, projectile.velocity, projectile.origin, 200, 0, 0, gpconstants.MOD_BFG_BLAST)
  end if
  wbcore.radiusDamage(context, projectile, projectile.owner, 200, other, 100.0, gpconstants.MOD_BFG_BLAST)
  projectile.solid = wbconstants.SOLID_NOT
  projectile.touch = void
  projectile.origin = wbvector.multiplyAdd(projectile.origin, -context.frameTime, projectile.velocity)
  projectile.velocity = qt.zeroVec3()
  projectile.think = bfgExplode
  projectile.nextThink = context.time + context.frameTime
  projectile.frame = 0
  context.callbacks.sound(projectile, "weapons/bfg__x1b.wav")
  wbcore.emitEffect(context, "bfg-big-explosion", projectile.origin, projectile.origin, qt.Vec3(0.0, 0.0, 1.0), 0, 1)
  return true
end function

function fireBfg(context, owner, start, direction, damage, speed, damageRadius)
  projectile = wbcore.spawnProjectile(context, "bfg blast")
  projectile.origin = wbvector.copy(start)
  projectile.oldOrigin = wbvector.copy(start)
  projectile.angles = wbvector.vectorToAngles(direction)
  projectile.velocity = wbvector.scale(direction, speed)
  projectile.moveType = wbconstants.MOVETYPE_FLYMISSILE
  projectile.clipMask = qc.MASK_SHOT
  projectile.solid = wbconstants.SOLID_BBOX
  projectile.effects = wbconstants.EF_BFG
  projectile.owner = owner
  projectile.touch = bfgTouch
  projectile.think = bfgThink
  projectile.nextThink = context.time + context.frameTime
  projectile.radiusDamage = damage
  projectile.damageRadius = damageRadius
  context.callbacks.dodge(owner, start, direction, speed)
  context.callbacks.linkEntity(projectile)
  return projectile
end function

function fire_blaster(context, owner, start, direction, damage, speed, effect, hyper)
  return fireBlaster(context, owner, start, direction, damage, speed, effect, hyper)
end function
function fire_grenade(context, owner, start, direction, damage, speed, timer, damageRadius)
  return fireGrenade(context, owner, start, direction, damage, speed, timer, damageRadius)
end function
function fire_grenade2(context, owner, start, direction, damage, speed, timer, damageRadius, held)
  return fireGrenade2(context, owner, start, direction, damage, speed, timer, damageRadius, held)
end function
function fire_rocket(context, owner, start, direction, damage, speed, damageRadius, radiusDamage)
  return fireRocket(context, owner, start, direction, damage, speed, damageRadius, radiusDamage)
end function
function fire_bfg(context, owner, start, direction, damage, speed, damageRadius)
  return fireBfg(context, owner, start, direction, damage, speed, damageRadius)
end function
