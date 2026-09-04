//! Provides miniquake2 game world turret types facilities for this project.

/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Typed configuration and engine boundaries for the Classic 3.19 turrets. */
package miniquake2.game.world.turret_types

/// Store turret callbacks data.
struct TurretCallbacks
  /// Stores the acquire target value associated with turret callbacks.
  acquireTarget
  /// Stores the trace visible value associated with turret callbacks.
  traceVisible
  /// Stores the random unit value associated with turret callbacks.
  randomUnit
  /// Stores the skill value value associated with turret callbacks.
  skillValue
  /// Stores the fire rocket value associated with turret callbacks.
  fireRocket
  /// Stores the positioned sound value associated with turret callbacks.
  positionedSound
  /// Stores the crush damage value associated with turret callbacks.
  crushDamage
  /// Stores the driver spawn value associated with turret callbacks.
  driverSpawn
  /// Stores the driver use value associated with turret callbacks.
  driverUse
  /// Stores the driver die value associated with turret callbacks.
  driverDie
end struct

/// Store turret control data.
struct TurretControl
  /// Stores the callbacks value associated with turret control.
  callbacks
  /// Stores the skill value associated with turret control.
  skill
end struct

/// Store turret limits data.
struct TurretLimits
  /// Stores the min pitch value associated with turret limits.
  minPitch
  /// Stores the max pitch value associated with turret limits.
  maxPitch
  /// Stores the min yaw value associated with turret limits.
  minYaw
  /// Stores the max yaw value associated with turret limits.
  maxYaw
end struct

/// Report whether turret no target.
/// @param driver driver value consumed by this operation.
/// @param world world value consumed by this operation.
function turretNoTarget(driver, world)
  return void
end function

/// Report whether turret always visible.
/// @param driver driver value consumed by this operation.
/// @param enemy enemy value consumed by this operation.
/// @param world world value consumed by this operation.
function turretAlwaysVisible(driver, enemy, world)
  return true
end function

/// Return the turret zero random value.
function turretZeroRandom()
  return 0.0
end function

/// Report whether turret no skill.
function turretNoSkill()
  return void
end function

/// Report whether turret no rocket.
/// @param attacker attacker value consumed by this operation.
/// @param start start value consumed by this operation.
/// @param direction direction value consumed by this operation.
/// @param damage damage value consumed by this operation.
/// @param speed speed value consumed by this operation.
/// @param splashRadius splashRadius value consumed by this operation.
/// @param world world value consumed by this operation.
function turretNoRocket(attacker, start, direction, damage, speed, splashRadius, world)
  return true
end function

/// Return the turret entity sound value.
/// @param origin origin value consumed by this operation.
/// @param entity entity value consumed by this operation.
/// @param soundName soundName value consumed by this operation.
/// @param world world value consumed by this operation.
function turretEntitySound(origin, entity, soundName, world)
  return world.callbacks.sound(entity, soundName)
end function

/// Return the turret world crush value.
/// @param target target value consumed by this operation.
/// @param inflictor inflictor value consumed by this operation.
/// @param attacker attacker value consumed by this operation.
/// @param amount amount value consumed by this operation.
/// @param knockback knockback value consumed by this operation.
/// @param means means value consumed by this operation.
/// @param world world value consumed by this operation.
function turretWorldCrush(target, inflictor, attacker, amount, knockback, means, world)
  return world.callbacks.damage(target, inflictor, attacker, amount, means)
end function

/// Report whether turret no driver spawn.
/// @param driver driver value consumed by this operation.
/// @param world world value consumed by this operation.
function turretNoDriverSpawn(driver, world)
  return true
end function

/// Report whether turret no driver use.
/// @param driver driver value consumed by this operation.
/// @param other other value consumed by this operation.
/// @param activator activator value consumed by this operation.
/// @param world world value consumed by this operation.
function turretNoDriverUse(driver, other, activator, world)
  return true
end function

/// Report whether turret no driver die.
/// @param driver driver value consumed by this operation.
/// @param inflictor inflictor value consumed by this operation.
/// @param attacker attacker value consumed by this operation.
/// @param damage damage value consumed by this operation.
/// @param point point value consumed by this operation.
/// @param world world value consumed by this operation.
function turretNoDriverDie(driver, inflictor, attacker, damage, point, world)
  return true
end function

/// Return the default turret callbacks value.
function defaultTurretCallbacks()
  return TurretCallbacks(
    turretNoTarget, turretAlwaysVisible, turretZeroRandom, turretNoSkill,
    turretNoRocket, turretEntitySound, turretWorldCrush,
    turretNoDriverSpawn, turretNoDriverUse, turretNoDriverDie
  )
end function

/// Create turret control.
/// @param callbacks callbacks value consumed by this operation.
/// @param skill skill value consumed by this operation.
function createTurretControl(callbacks, skill)
  if callbacks is void then callbacks = defaultTurretCallbacks() end if
  if typeof(skill) != "int" and typeof(skill) != "float" then skill = 1.0 end if
  if skill < 0.0 then skill = 0.0 end if
  if skill > 3.0 then skill = 3.0 end if
  return TurretControl(callbacks, skill)
end function

/// Return the default turret limits value.
function defaultTurretLimits()
  return TurretLimits(-30.0, 30.0, 0.0, 360.0)
end function

/// Create turret limits.
/// @param minPitch minPitch value consumed by this operation.
/// @param maxPitch maxPitch value consumed by this operation.
/// @param minYaw minYaw value consumed by this operation.
/// @param maxYaw maxYaw value consumed by this operation.
function createTurretLimits(minPitch, maxPitch, minYaw, maxYaw)
  if minPitch == 0.0 then minPitch = -30.0 end if
  if maxPitch == 0.0 then maxPitch = 30.0 end if
  if maxYaw == 0.0 then maxYaw = 360.0 end if
  return TurretLimits(minPitch, maxPitch, minYaw, maxYaw)
end function
