/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Typed configuration and engine boundaries for the Classic 3.19 turrets. */
package miniquake2.game.world.turret_types

// Store turret callbacks data.
struct TurretCallbacks
  acquireTarget
  traceVisible
  randomUnit
  skillValue
  fireRocket
  positionedSound
  crushDamage
  driverSpawn
  driverUse
  driverDie
end struct

// Store turret control data.
struct TurretControl
  callbacks
  skill
end struct

// Store turret limits data.
struct TurretLimits
  minPitch
  maxPitch
  minYaw
  maxYaw
end struct

// Report whether turret no target.
function turretNoTarget(driver, world)
  return void
end function

// Report whether turret always visible.
function turretAlwaysVisible(driver, enemy, world)
  return true
end function

// Return the turret zero random value.
function turretZeroRandom()
  return 0.0
end function

// Report whether turret no skill.
function turretNoSkill()
  return void
end function

// Report whether turret no rocket.
function turretNoRocket(attacker, start, direction, damage, speed, splashRadius, world)
  return true
end function

// Return the turret entity sound value.
function turretEntitySound(origin, entity, soundName, world)
  return world.callbacks.sound(entity, soundName)
end function

// Return the turret world crush value.
function turretWorldCrush(target, inflictor, attacker, amount, knockback, means, world)
  return world.callbacks.damage(target, inflictor, attacker, amount, means)
end function

// Report whether turret no driver spawn.
function turretNoDriverSpawn(driver, world)
  return true
end function

// Report whether turret no driver use.
function turretNoDriverUse(driver, other, activator, world)
  return true
end function

// Report whether turret no driver die.
function turretNoDriverDie(driver, inflictor, attacker, damage, point, world)
  return true
end function

// Return the default turret callbacks value.
function defaultTurretCallbacks()
  return TurretCallbacks(
    turretNoTarget, turretAlwaysVisible, turretZeroRandom, turretNoSkill,
    turretNoRocket, turretEntitySound, turretWorldCrush,
    turretNoDriverSpawn, turretNoDriverUse, turretNoDriverDie
  )
end function

// Create turret control.
function createTurretControl(callbacks, skill)
  if callbacks is void then callbacks = defaultTurretCallbacks() end if
  if typeof(skill) != "int" and typeof(skill) != "float" then skill = 1.0 end if
  if skill < 0.0 then skill = 0.0 end if
  if skill > 3.0 then skill = 3.0 end if
  return TurretControl(callbacks, skill)
end function

// Return the default turret limits value.
function defaultTurretLimits()
  return TurretLimits(-30.0, 30.0, 0.0, 360.0)
end function

// Create turret limits.
function createTurretLimits(minPitch, maxPitch, minYaw, maxYaw)
  if minPitch == 0.0 then minPitch = -30.0 end if
  if maxPitch == 0.0 then maxPitch = 30.0 end if
  if maxYaw == 0.0 then maxYaw = 360.0 end if
  return TurretLimits(minPitch, maxPitch, minYaw, maxYaw)
end function
