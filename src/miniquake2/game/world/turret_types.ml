/* Typed configuration and engine boundaries for the Classic 3.19 turrets. */
package miniquake2.game.world.turret_types

struct TurretCallbacks
  acquireTarget
  traceVisible
  randomUnit
  fireRocket
  driverSpawn
  driverUse
  driverDie
end struct

struct TurretControl
  callbacks
  skill
  lostSight
  trailTime
  attackFinished
end struct

struct TurretLimits
  minPitch
  maxPitch
  minYaw
  maxYaw
end struct

function turretNoTarget(driver, world)
  return void
end function

function turretAlwaysVisible(driver, enemy, world)
  return true
end function

function turretZeroRandom()
  return 0.0
end function

function turretNoRocket(attacker, start, direction, damage, speed, splashRadius, world)
  return true
end function

function turretNoDriverSpawn(driver, world)
  return true
end function

function turretNoDriverUse(driver, other, activator, world)
  return true
end function

function turretNoDriverDie(driver, inflictor, attacker, damage, point, world)
  return true
end function

function defaultTurretCallbacks()
  return TurretCallbacks(
    turretNoTarget, turretAlwaysVisible, turretZeroRandom, turretNoRocket,
    turretNoDriverSpawn, turretNoDriverUse, turretNoDriverDie
  )
end function

function createTurretControl(callbacks, skill)
  if callbacks is void then callbacks = defaultTurretCallbacks() end if
  if typeof(skill) != "int" and typeof(skill) != "float" then skill = 1.0 end if
  if skill < 0.0 then skill = 0.0 end if
  if skill > 3.0 then skill = 3.0 end if
  return TurretControl(callbacks, skill, false, 0.0, 0.0)
end function

function defaultTurretLimits()
  return TurretLimits(-30.0, 30.0, 0.0, 360.0)
end function

function createTurretLimits(minPitch, maxPitch, minYaw, maxYaw)
  if minPitch == 0.0 then minPitch = -30.0 end if
  if maxPitch == 0.0 then maxPitch = 30.0 end if
  if maxYaw == 0.0 then maxYaw = 360.0 end if
  return TurretLimits(minPitch, maxPitch, minYaw, maxYaw)
end function
