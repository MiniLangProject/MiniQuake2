/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Shared projectile lifetime, damage and event machinery. */
package miniquake2.game.weapons.core

import miniquake2.qcommon.constants as qc
import miniquake2.qcommon.directions as qdir
import miniquake2.qcommon.types as qt
import miniquake2.game.gameplay.combat as gpcombat
import miniquake2.game.gameplay.constants as gpconstants
import miniquake2.game.gameplay.types as gptypes
import miniquake2.game.weapons.constants as wbconstants
import miniquake2.game.weapons.types as wbtypes
import miniquake2.game.weapons.vector as wbvector
import miniquake2.qcommon.byteio as qbyteio

weaponCoreDamageAttackerNumber = 0
const MAX_WEAPON_EVENT_HISTORY = 1024

function weaponCoreAppendEvent(context, value)
  if len(context.events) < MAX_WEAPON_EVENT_HISTORY then
    context.events = context.events + [value]
    return true
  end if
  output = array(MAX_WEAPON_EVENT_HISTORY, void)
  index = 1
  while index < MAX_WEAPON_EVENT_HISTORY
    output[index - 1] = context.events[index]
    index = index + 1
  end while
  output[MAX_WEAPON_EVENT_HISTORY - 1] = value
  context.events = output
  return true
end function

function damageAttackerNumber()
  global weaponCoreDamageAttackerNumber
  return weaponCoreDamageAttackerNumber
end function

function clearTrace(start, mins, maxs, endPosition, ignore, mask)
  plane = qt.Plane(qt.Vec3(0.0, 0.0, 1.0), 0.0, 0, 0)
  surface = qt.CollisionSurface("", 0, 0)
  return qt.Trace(false, false, 1.0, wbvector.copy(endPosition), plane, surface, 0, void)
end function
function emptyContents(point)
  return 0
end function
function combatDamage(target, request)
  return gpcombat.T_Damage(target, request)
end function
function alwaysCanDamage(target, origin)
  return true
end function
function noRadiusTargets(origin, radius)
  return []
end function
function noEffect(effect)
  return true
end function
function noSound(entity, soundName)
  return true
end function
function noLink(entity)
  return true
end function
function noFree(entity)
  return true
end function
function noNoise(owner, position, noiseType)
  return true
end function
function noDodge(owner, start, direction, speed)
  return true
end function
function zeroRandomSigned()
  return 0.0
end function

function defaultCallbacks()
  return wbtypes.WeaponCallbacks(
    clearTrace, emptyContents, combatDamage, alwaysCanDamage, noRadiusTargets,
    noEffect, noSound, noLink, noFree, noNoise, noDodge, zeroRandomSigned
  )
end function

function createContext(callbacks)
  if callbacks is void then callbacks = defaultCallbacks() end if
  return wbtypes.WeaponContext([], 0.0, wbconstants.FRAME_TIME, 1, callbacks, [], false)
end function

function addTargetOrigin(target)
  target.combatant.edict.state.origin = wbvector.toArray(target.origin)
  return target
end function

function spawnProjectile(context, className)
  projectile = wbtypes.createProjectile(context.nextProjectileNumber, className)
  context.nextProjectileNumber = context.nextProjectileNumber + 1
  context.projectiles = context.projectiles + [projectile]
  return projectile
end function

function freeProjectile(context, projectile)
  if projectile is void or projectile.inUse == false then return false end if
  projectile.inUse = false
  projectile.solid = wbconstants.SOLID_NOT
  projectile.touch = void
  projectile.think = void
  projectile.nextThink = 0.0
  context.callbacks.freeEntity(projectile)
  weaponCoreAppendEvent(context, [context.time, "free", projectile.number, projectile.className])
  return true
end function

function freeThink(projectile, context)
  return freeProjectile(context, projectile)
end function

function emitEffect(context, kind, start, endPosition, normal, style, count)
  directionIndex = qdir.encodeDirection(normal)
  effect = wbtypes.WeaponEffect(kind, wbvector.copy(start), wbvector.copy(endPosition), wbvector.copy(normal), directionIndex, style, count)
  weaponCoreAppendEvent(context, [context.time, kind, style, count])
  context.callbacks.effect(effect)
  return effect
end function

function applyDamage(context, target, inflictor, attacker, direction, point, damage, knockback, flags, meansOfDeath)
  global weaponCoreDamageAttackerNumber
  if target is void or target.inUse == false or target.combatant is void or target.combatant.takeDamage == false then return false end if
  request = gptypes.damageRequest(wbvector.toArray(direction), wbvector.toArray(point), damage, knockback, flags, meansOfDeath)
  if attacker is not void and attacker.number == target.number then request.selfDamage = true end if
  request.currentFrame = qbyteio.truncInt(context.time / context.frameTime)
  weaponCoreDamageAttackerNumber = 0
  if attacker is not void then weaponCoreDamageAttackerNumber = attacker.number end if
  result = context.callbacks.damage(target.combatant, request)
  weaponCoreDamageAttackerNumber = 0
  weaponCoreAppendEvent(context, [context.time, "damage", target.number, [damage, meansOfDeath]])
  return result
end function

function radiusDamage(context, inflictor, attacker, baseDamage, ignore, radius, meansOfDeath)
  results = []
  targets = context.callbacks.radiusTargets(inflictor.origin, radius)
  for each target in targets
    if target.inUse and target.combatant is not void and target.combatant.takeDamage then
      ignored = ignore is not void and target.number == ignore.number
      if ignored == false and context.callbacks.canDamage(target, inflictor.origin) then
        center = wbvector.midpoint(target)
        distance = wbvector.length(wbvector.subtract(center, inflictor.origin))
        points = baseDamage - 0.5 * distance
        if attacker is not void and target.number == attacker.number then points = points * 0.5 end if
        amount = qbyteio.truncInt(points)
        if amount > 0 and distance <= radius then
          result = applyDamage(context, target, inflictor, attacker, wbvector.subtract(target.origin, inflictor.origin), inflictor.origin, amount, amount, gpconstants.DAMAGE_RADIUS, meansOfDeath)
          results = results + [result]
        end if
      end if
    end if
  end for
  return results
end function

function touchProjectile(context, projectile, other, trace)
  if projectile is void or projectile.inUse == false or projectile.touch is void then return false end if
  return projectile.touch(projectile, other, trace, context)
end function

function runDueThinks(context)
  progressed = true
  guard = 0
  while progressed and guard < 1024
    progressed = false
    guard = guard + 1
    for each projectile in context.projectiles
      if projectile.inUse and projectile.think is not void and projectile.nextThink > 0.0 and projectile.nextThink <= context.time + 0.00001 then
        projectile.nextThink = 0.0
        projectile.think(projectile, context)
        progressed = true
      end if
    end for
  end while
  return guard
end function

function advance(context, seconds)
  if seconds < 0.0 then return error(9750, "weapon time cannot run backwards") end if
  context.time = context.time + seconds
  for each projectile in context.projectiles
    if projectile.inUse then
      projectile.oldOrigin = wbvector.copy(projectile.origin)
      projectile.origin = wbvector.multiplyAdd(projectile.origin, seconds, projectile.velocity)
      projectile.angles = wbvector.multiplyAdd(projectile.angles, seconds, projectile.angularVelocity)
    end if
  end for
  runDueThinks(context)
  return context.time
end function

function surfaceIsSky(trace)
  return trace is not void and trace.surface is not void and (trace.surface.flags & qc.SURF_SKY) != 0
end function
