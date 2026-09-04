//! Provides miniquake2 game weapons types facilities for this project.

/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Managed weapon entities and callback boundary for deterministic ballistics. */
package miniquake2.game.weapons.types

import miniquake2.qcommon.types as qt
import miniquake2.game.gameplay.types as gptypes
import miniquake2.game.weapons.constants as wbconstants

/// Store weapon target data.
struct WeaponTarget
  /// Stores the number value associated with weapon target.
  number
  /// Stores the in use value associated with weapon target.
  inUse
  /// Stores the class name value associated with weapon target.
  className
  /// Stores the origin value associated with weapon target.
  origin
  /// Stores the mins value associated with weapon target.
  mins
  /// Stores the maxs value associated with weapon target.
  maxs
  /// Stores the combatant value associated with weapon target.
  combatant
  /// Indicates whether is client is active for the weapon target value.
  isClient
  /// Indicates whether is monster is active for the weapon target value.
  isMonster
  /// Stores the flags value associated with weapon target.
  flags
end struct

/// Store weapon effect data.
struct WeaponEffect
  /// Stores the kind value associated with weapon effect.
  kind
  /// Stores the start value associated with weapon effect.
  start
  /// Stores the end position value associated with weapon effect.
  endPosition
  /// Stores the normal value associated with weapon effect.
  normal
  /// Stores the direction index value associated with weapon effect.
  directionIndex
  /// Stores the style value associated with weapon effect.
  style
  /// Stores the count value associated with weapon effect.
  count
end struct

/// Store weapon callbacks data.
struct WeaponCallbacks
  /// Stores the trace value associated with weapon callbacks.
  trace
  /// Stores the point contents value associated with weapon callbacks.
  pointContents
  /// Stores the damage value associated with weapon callbacks.
  damage
  /// Indicates whether can damage is active for the weapon callbacks value.
  canDamage
  /// Stores the radius targets value associated with weapon callbacks.
  radiusTargets
  /// Stores the effect value associated with weapon callbacks.
  effect
  /// Stores the sound value associated with weapon callbacks.
  sound
  /// Stores the link entity value associated with weapon callbacks.
  linkEntity
  /// Stores the free entity value associated with weapon callbacks.
  freeEntity
  /// Stores the player noise value associated with weapon callbacks.
  playerNoise
  /// Stores the dodge value associated with weapon callbacks.
  dodge
  /// Stores the random signed value associated with weapon callbacks.
  randomSigned
end struct

/// Store projectile data.
struct Projectile
  /// Stores the number value associated with projectile.
  number
  /// Stores the in use value associated with projectile.
  inUse
  /// Stores the class name value associated with projectile.
  className
  /// Stores the origin value associated with projectile.
  origin
  /// Stores the old origin value associated with projectile.
  oldOrigin
  /// Stores the angles value associated with projectile.
  angles
  /// Stores the velocity value associated with projectile.
  velocity
  /// Stores the angular velocity value associated with projectile.
  angularVelocity
  /// Stores the mins value associated with projectile.
  mins
  /// Stores the maxs value associated with projectile.
  maxs
  /// Stores the owner value associated with projectile.
  owner
  /// Stores the enemy value associated with projectile.
  enemy
  /// Stores the move type value associated with projectile.
  moveType
  /// Stores the clip mask value associated with projectile.
  clipMask
  /// Stores the solid value associated with projectile.
  solid
  /// Stores the effects value associated with projectile.
  effects
  /// Stores the model name value associated with projectile.
  modelName
  /// Stores the sound name value associated with projectile.
  soundName
  /// Stores the model index value associated with projectile.
  modelIndex
  /// Stores the sound index value associated with projectile.
  soundIndex
  /// Stores the spawn flags value associated with projectile.
  spawnFlags
  /// Stores the damage value associated with projectile.
  damage
  /// Stores the radius damage value associated with projectile.
  radiusDamage
  /// Stores the damage radius value associated with projectile.
  damageRadius
  /// Stores the water type value associated with projectile.
  waterType
  /// Stores the water level value associated with projectile.
  waterLevel
  /// Stores the gravity value associated with projectile.
  gravity
  /// Stores the ground entity value associated with projectile.
  groundEntity
  /// Stores the touch value associated with projectile.
  touch
  /// Stores the think value associated with projectile.
  think
  /// Stores the next think value associated with projectile.
  nextThink
  /// Stores the frame value associated with projectile.
  frame
  /// Stores the engine number value associated with projectile.
  engineNumber
end struct

/// Store weapon context data.
struct WeaponContext
  /// Stores the projectiles value associated with weapon context.
  projectiles
  /// Stores the time value associated with weapon context.
  time
  /// Stores the frame time value associated with weapon context.
  frameTime
  /// Stores the next projectile number value associated with weapon context.
  nextProjectileNumber
  /// Stores the callbacks value associated with weapon context.
  callbacks
  /// Stores the events value associated with weapon context.
  events
  /// Stores the deathmatch value associated with weapon context.
  deathmatch
end struct

/// Store hand grenade state data.
struct HandGrenadeState
  /// Stores the owner value associated with hand grenade state.
  owner
  /// Stores the weapon state value associated with hand grenade state.
  weaponState
  /// Stores the gun frame value associated with hand grenade state.
  gunFrame
  /// Stores the grenade time value associated with hand grenade state.
  grenadeTime
  /// Stores the grenade blew up value associated with hand grenade state.
  grenadeBlewUp
  /// Stores the buttons value associated with hand grenade state.
  buttons
  /// Stores the latched buttons value associated with hand grenade state.
  latchedButtons
  /// Stores the ammo value associated with hand grenade state.
  ammo
  /// Stores the infinite ammo value associated with hand grenade state.
  infiniteAmmo
  /// Stores the weapon sound value associated with hand grenade state.
  weaponSound
  /// Stores the last projectile value associated with hand grenade state.
  lastProjectile
end struct

/// Create target.
/// @param number number value consumed by this operation.
/// @param health health value consumed by this operation.
function createTarget(number, health)
  combatant = gptypes.createCombatant(number, health)
  return WeaponTarget(
    number, true, "target", qt.zeroVec3(), qt.Vec3(-16.0, -16.0, -16.0),
    qt.Vec3(16.0, 16.0, 16.0), combatant, false, false, 0
  )
end function

/// Create projectile.
/// @param number number value consumed by this operation.
/// @param className className value consumed by this operation.
function createProjectile(number, className)
  zero = qt.zeroVec3()
  return Projectile(
    number, true, className, qt.zeroVec3(), qt.zeroVec3(), qt.zeroVec3(),
    qt.zeroVec3(), qt.zeroVec3(), qt.zeroVec3(), qt.zeroVec3(), void, void,
    wbconstants.MOVETYPE_NONE, 0, wbconstants.SOLID_NOT, 0, "", "", 0, 0,
    0, 0, 0, 0.0,
    0, 0, 1.0, void, void, void, 0.0, 0, -1
  )
end function

/// Create hand grenade state.
/// @param owner owner value consumed by this operation.
/// @param ammo ammo value consumed by this operation.
function createHandGrenadeState(owner, ammo)
  return HandGrenadeState(
    owner, wbconstants.HAND_READY, 16, 0.0, false, 0, 0, ammo, false, "", void
  )
end function
