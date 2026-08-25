/* Managed weapon entities and callback boundary for deterministic ballistics. */
package miniquake2.game.weapons.types

import miniquake2.qcommon.types as qt
import miniquake2.game.gameplay.types as gptypes
import miniquake2.game.weapons.constants as wbconstants

struct WeaponTarget
  number
  inUse
  className
  origin
  mins
  maxs
  combatant
  isClient
  isMonster
  flags
end struct

struct WeaponEffect
  kind
  start
  endPosition
  normal
  directionIndex
  style
  count
end struct

struct WeaponCallbacks
  trace
  pointContents
  damage
  canDamage
  radiusTargets
  effect
  sound
  linkEntity
  freeEntity
  playerNoise
  dodge
  randomSigned
end struct

struct Projectile
  number
  inUse
  className
  origin
  oldOrigin
  angles
  velocity
  angularVelocity
  mins
  maxs
  owner
  enemy
  moveType
  clipMask
  solid
  effects
  modelName
  soundName
  modelIndex
  soundIndex
  spawnFlags
  damage
  radiusDamage
  damageRadius
  waterLevel
  groundEntity
  touch
  think
  nextThink
  frame
  engineNumber
end struct

struct WeaponContext
  projectiles
  time
  frameTime
  nextProjectileNumber
  callbacks
  events
  deathmatch
end struct

struct HandGrenadeState
  owner
  weaponState
  gunFrame
  grenadeTime
  grenadeBlewUp
  buttons
  latchedButtons
  ammo
  infiniteAmmo
  weaponSound
  lastProjectile
end struct

function createTarget(number, health)
  combatant = gptypes.createCombatant(number, health)
  return WeaponTarget(
    number, true, "target", qt.zeroVec3(), qt.Vec3(-16.0, -16.0, -16.0),
    qt.Vec3(16.0, 16.0, 16.0), combatant, false, false, 0
  )
end function

function createProjectile(number, className)
  zero = qt.zeroVec3()
  return Projectile(
    number, true, className, qt.zeroVec3(), qt.zeroVec3(), qt.zeroVec3(),
    qt.zeroVec3(), qt.zeroVec3(), qt.zeroVec3(), qt.zeroVec3(), void, void,
    wbconstants.MOVETYPE_NONE, 0, wbconstants.SOLID_NOT, 0, "", "", 0, 0,
    0, 0, 0, 0.0,
    0, void, void, void, 0.0, 0, -1
  )
end function

function createHandGrenadeState(owner, ammo)
  return HandGrenadeState(
    owner, wbconstants.HAND_READY, 16, 0.0, false, 0, 0, ammo, false, "", void
  )
end function
