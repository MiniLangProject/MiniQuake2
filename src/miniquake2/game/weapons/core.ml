//! Provides miniquake2 game weapons core facilities for this project.

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

/// Stores module-wide weapon core damage attacker number state for the miniquake2 game weapons core module.
weaponCoreDamageAttackerNumber = 0
/// Defines the max weapon event history constant used by the miniquake2 game weapons core module.
const MAX_WEAPON_EVENT_HISTORY = 1024

/// Append weapon core event.
/// @param context Context that carries state for the operation.
/// @param value Value consumed or transformed by the operation.
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

/// Return the damage attacker number.
function damageAttackerNumber()
  global weaponCoreDamageAttackerNumber
  return weaponCoreDamageAttackerNumber
end function

/// Clear trace.
/// @param start start value consumed by this operation.
/// @param mins mins value consumed by this operation.
/// @param maxs maxs value consumed by this operation.
/// @param endPosition endPosition value consumed by this operation.
/// @param ignore ignore value consumed by this operation.
/// @param mask mask value consumed by this operation.
function clearTrace(start, mins, maxs, endPosition, ignore, mask)
  plane = qt.Plane(qt.Vec3(0.0, 0.0, 1.0), 0.0, 0, 0)
  surface = qt.CollisionSurface("", 0, 0)
  return qt.Trace(false, false, 1.0, wbvector.copy(endPosition), plane, surface, 0, void)
end function
/// Report whether empty contents.
/// @param point point value consumed by this operation.
function emptyContents(point)
  return 0
end function
/// Return the combat damage value.
/// @param target target value consumed by this operation.
/// @param request request value consumed by this operation.
function combatDamage(target, request)
  return gpcombat.T_Damage(target, request)
end function
/// Report whether always can damage.
/// @param target target value consumed by this operation.
/// @param origin origin value consumed by this operation.
function alwaysCanDamage(target, origin)
  return true
end function
/// Report whether no radius targets.
/// @param origin origin value consumed by this operation.
/// @param radius radius value consumed by this operation.
function noRadiusTargets(origin, radius)
  return []
end function
/// Report whether no effect.
/// @param effect effect value consumed by this operation.
function noEffect(effect)
  return true
end function
/// Report whether no sound.
/// @param entity entity value consumed by this operation.
/// @param soundName soundName value consumed by this operation.
function noSound(entity, soundName)
  return true
end function
/// Report whether no link.
/// @param entity entity value consumed by this operation.
function noLink(entity)
  return true
end function
/// Report whether no free.
/// @param entity entity value consumed by this operation.
function noFree(entity)
  return true
end function
/// Report whether no noise.
/// @param owner owner value consumed by this operation.
/// @param position position value consumed by this operation.
/// @param noiseType noiseType value consumed by this operation.
function noNoise(owner, position, noiseType)
  return true
end function
/// Report whether no dodge.
/// @param owner owner value consumed by this operation.
/// @param start start value consumed by this operation.
/// @param direction direction value consumed by this operation.
/// @param speed speed value consumed by this operation.
function noDodge(owner, start, direction, speed)
  return true
end function
/// Return the zero random signed value.
function zeroRandomSigned()
  return 0.0
end function

/// Return the default callbacks value.
function defaultCallbacks()
  return wbtypes.WeaponCallbacks(
    clearTrace, emptyContents, combatDamage, alwaysCanDamage, noRadiusTargets,
    noEffect, noSound, noLink, noFree, noNoise, noDodge, zeroRandomSigned
  )
end function

/// Create context.
/// @param callbacks callbacks value consumed by this operation.
function createContext(callbacks)
  if callbacks is void then callbacks = defaultCallbacks() end if
  return wbtypes.WeaponContext([], 0.0, wbconstants.FRAME_TIME, 1, callbacks, [], false)
end function

/// Add target origin.
/// @param target target value consumed by this operation.
function addTargetOrigin(target)
  target.combatant.edict.state.origin = wbvector.toArray(target.origin)
  return target
end function

/// Spawn projectile.
/// @param context Context that carries state for the operation.
/// @param className className value consumed by this operation.
function spawnProjectile(context, className)
  projectile = wbtypes.createProjectile(context.nextProjectileNumber, className)
  context.nextProjectileNumber = context.nextProjectileNumber + 1
  context.projectiles = context.projectiles + [projectile]
  return projectile
end function

/// Release projectile.
/// @param context Context that carries state for the operation.
/// @param projectile projectile value consumed by this operation.
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

/// Release think.
/// @param projectile projectile value consumed by this operation.
/// @param context Context that carries state for the operation.
function freeThink(projectile, context)
  return freeProjectile(context, projectile)
end function

/// Emit effect.
/// @param context Context that carries state for the operation.
/// @param kind kind value consumed by this operation.
/// @param start start value consumed by this operation.
/// @param endPosition endPosition value consumed by this operation.
/// @param normal normal value consumed by this operation.
/// @param style style value consumed by this operation.
/// @param count Number of items or units to process.
function emitEffect(context, kind, start, endPosition, normal, style, count)
  directionIndex = qdir.encodeDirection(normal)
  effect = wbtypes.WeaponEffect(kind, wbvector.copy(start), wbvector.copy(endPosition), wbvector.copy(normal), directionIndex, style, count)
  weaponCoreAppendEvent(context, [context.time, kind, style, count])
  context.callbacks.effect(effect)
  return effect
end function

/// Apply damage.
/// @param context Context that carries state for the operation.
/// @param target target value consumed by this operation.
/// @param inflictor inflictor value consumed by this operation.
/// @param attacker attacker value consumed by this operation.
/// @param direction direction value consumed by this operation.
/// @param point point value consumed by this operation.
/// @param damage damage value consumed by this operation.
/// @param knockback knockback value consumed by this operation.
/// @param flags Bit flags controlling the operation.
/// @param meansOfDeath meansOfDeath value consumed by this operation.
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

/// Return the radius damage value.
/// @param context Context that carries state for the operation.
/// @param inflictor inflictor value consumed by this operation.
/// @param attacker attacker value consumed by this operation.
/// @param baseDamage baseDamage value consumed by this operation.
/// @param ignore ignore value consumed by this operation.
/// @param radius radius value consumed by this operation.
/// @param meansOfDeath meansOfDeath value consumed by this operation.
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

/// Handle projectile.
/// @param context Context that carries state for the operation.
/// @param projectile projectile value consumed by this operation.
/// @param other other value consumed by this operation.
/// @param trace trace value consumed by this operation.
function touchProjectile(context, projectile, other, trace)
  if projectile is void or projectile.inUse == false or projectile.touch is void then return false end if
  return projectile.touch(projectile, other, trace, context)
end function

/// Run due thinks.
/// @param context Context that carries state for the operation.
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

/// Performs the advance operation for the miniquake2 game weapons core module.
/// @param context Context that carries state for the operation.
/// @param seconds seconds value consumed by this operation.
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

/// Report whether surface is sky.
/// @param trace trace value consumed by this operation.
function surfaceIsSky(trace)
  return trace is not void and trace.surface is not void and (trace.surface.flags & qc.SURF_SKY) != 0
end function
