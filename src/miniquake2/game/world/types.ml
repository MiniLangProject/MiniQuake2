//! Provides miniquake2 game world types facilities for this project.

/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Managed state used by the BaseQ2 world state machines. */
package miniquake2.game.world.types

import miniquake2.qcommon.types as qt
import miniquake2.game.world.constants as gwconstants

/// Store move info data.
struct MoveInfo
  /// Stores the state value associated with move info.
  state
  /// Stores the speed value associated with move info.
  speed
  /// Stores the accel value associated with move info.
  accel
  /// Stores the decel value associated with move info.
  decel
  /// Stores the wait value associated with move info.
  wait
  /// Stores the distance value associated with move info.
  distance
  /// Stores the current speed value associated with move info.
  currentSpeed
  /// Stores the move speed value associated with move info.
  moveSpeed
  /// Stores the next speed value associated with move info.
  nextSpeed
  /// Stores the remaining distance value associated with move info.
  remainingDistance
  /// Stores the decel distance value associated with move info.
  decelDistance
  /// Stores the direction value associated with move info.
  direction
  /// Stores the start origin value associated with move info.
  startOrigin
  /// Stores the end origin value associated with move info.
  endOrigin
  /// Stores the start angles value associated with move info.
  startAngles
  /// Stores the end angles value associated with move info.
  endAngles
  /// Stores the end function value associated with move info.
  endFunction
end struct

/// Narrow trace result owned by the world layer.  Keeping the engine trace
/// behind this adapter lets target_laser retain the stock penetration rules in
/// deterministic unit tests without coupling g_target state machines to an
/// engine Edict or collision implementation.
struct WorldTrace
  /// Stores the hit value associated with world trace.
  hit
  /// Stores the end position value associated with world trace.
  endPosition
  /// Stores the plane normal value associated with world trace.
  planeNormal
  /// Stores the entity value associated with world trace.
  entity
end struct

/// Store world entity data.
struct WorldEntity
  /// Stores the number value associated with world entity.
  number
  /// Stores the in use value associated with world entity.
  inUse
  /// Stores the class name value associated with world entity.
  className
  /// Stores the target value associated with world entity.
  target
  /// Stores the target name value associated with world entity.
  targetName
  /// Stores the kill target value associated with world entity.
  killTarget
  /// Stores the path target value associated with world entity.
  pathTarget
  /// Stores the team value associated with world entity.
  team
  /// Stores the message value associated with world entity.
  message
  /// Stores the map value associated with world entity.
  map
  /// Stores the model value associated with world entity.
  model
  /// Stores the noise value associated with world entity.
  noise
  /// Stores the spawn flags value associated with world entity.
  spawnFlags
  /// Stores the flags value associated with world entity.
  flags
  /// Stores the server flags value associated with world entity.
  serverFlags
  /// Stores the solid value associated with world entity.
  solid
  /// Stores the move type value associated with world entity.
  moveType
  /// Stores the model index value associated with world entity.
  modelIndex
  /// Stores the effects value associated with world entity.
  effects
  /// Stores the render fx value associated with world entity.
  renderFx
  /// Stores the frame value associated with world entity.
  frame
  /// Stores the sound index value associated with world entity.
  soundIndex
  /// Stores the sounds value associated with world entity.
  sounds
  /// Stores the loop sound value associated with world entity.
  loopSound
  /// Stores the style value associated with world entity.
  style
  /// Stores the origin value associated with world entity.
  origin
  /// Stores the angles value associated with world entity.
  angles
  /// Stores the old origin value associated with world entity.
  oldOrigin
  /// Stores the velocity value associated with world entity.
  velocity
  /// Stores the angular velocity value associated with world entity.
  angularVelocity
  /// Stores the mins value associated with world entity.
  mins
  /// Stores the maxs value associated with world entity.
  maxs
  /// Stores the size value associated with world entity.
  size
  /// Stores the absolute mins value associated with world entity.
  absoluteMins
  /// Stores the absolute maxs value associated with world entity.
  absoluteMaxs
  /// Stores the move direction value associated with world entity.
  moveDirection
  /// Stores the speed value associated with world entity.
  speed
  /// Stores the accel value associated with world entity.
  accel
  /// Stores the decel value associated with world entity.
  decel
  /// Stores the wait value associated with world entity.
  wait
  /// Stores the delay value associated with world entity.
  delay
  /// Stores the random value associated with world entity.
  random
  /// Stores the damage value associated with world entity.
  damage
  /// Stores the health value associated with world entity.
  health
  /// Stores the max health value associated with world entity.
  maxHealth
  /// Stores the mass value associated with world entity.
  mass
  /// Stores the gravity value associated with world entity.
  gravity
  /// Stores the count value associated with world entity.
  count
  /// Stores the volume value associated with world entity.
  volume
  /// Stores the attenuation value associated with world entity.
  attenuation
  /// Stores the take damage value associated with world entity.
  takeDamage
  /// Indicates whether is client is active for the world entity value.
  isClient
  /// Stores the activator value associated with world entity.
  activator
  /// Stores the owner value associated with world entity.
  owner
  /// Stores the team master value associated with world entity.
  teamMaster
  /// Stores the team chain value associated with world entity.
  teamChain
  /// Stores the target entity value associated with world entity.
  targetEntity
  /// Stores the use value associated with world entity.
  use
  /// Stores the think value associated with world entity.
  think
  /// Stores the touch value associated with world entity.
  touch
  /// Stores the blocked value associated with world entity.
  blocked
  /// Stores the die value associated with world entity.
  die
  /// Stores the next think value associated with world entity.
  nextThink
  /// Stores the touch debounce time value associated with world entity.
  touchDebounceTime
  /// Stores the timestamp value associated with world entity.
  timestamp
  /// Stores the move info value associated with world entity.
  moveInfo
  /// Stores the pause time value associated with world entity.
  pauseTime
  /// Stores the lip value associated with world entity.
  lip
  /// Stores the height value associated with world entity.
  height
  /// Stores the item value associated with world entity.
  item
  /// Stores the item name value associated with world entity.
  itemName
  /// Stores the enemy value associated with world entity.
  enemy
  /// Stores the old enemy value associated with world entity.
  oldEnemy
  /// Stores the ground entity value associated with world entity.
  groundEntity
  /// Stores the gib health value associated with world entity.
  gibHealth
  /// Stores the clip mask value associated with world entity.
  clipMask
  /// Stores the ai flags value associated with world entity.
  aiFlags
  /// Stores the old velocity value associated with world entity.
  oldVelocity
  /// Stores the fly sound debounce time value associated with world entity.
  flySoundDebounceTime
  /// Stores the water type value associated with world entity.
  waterType
  /// Stores the water level value associated with world entity.
  waterLevel
  /// Stores the gravity specified value associated with world entity.
  gravitySpecified
end struct

/// Store world callbacks data.
struct WorldCallbacks
  /// Stores the log value associated with world callbacks.
  log
  /// Stores the center print value associated with world callbacks.
  centerPrint
  /// Stores the sound value associated with world callbacks.
  sound
  /// Stores the area portal value associated with world callbacks.
  areaPortal
  /// Stores the damage value associated with world callbacks.
  damage
  /// Stores the radius damage value associated with world callbacks.
  radiusDamage
  /// Stores the effect value associated with world callbacks.
  effect
  /// Stores the change level value associated with world callbacks.
  changeLevel
  /// Stores the spawn external value associated with world callbacks.
  spawnExternal
  /// Stores the link entity value associated with world callbacks.
  linkEntity
  /// Stores the kill box value associated with world callbacks.
  killBox
  /// Stores the random signed value associated with world callbacks.
  randomSigned
  /// Stores the random index value associated with world callbacks.
  randomIndex
  /// Stores the resolve key item value associated with world callbacks.
  resolveKeyItem
  /// Indicates whether has key item is active for the world callbacks value.
  hasKeyItem
  /// Stores the consume key item value associated with world callbacks.
  consumeKeyItem
  /// Stores the actor message value associated with world callbacks.
  actorMessage
  /// Stores the actor transition value associated with world callbacks.
  actorTransition
  /// Stores the combat point transition value associated with world callbacks.
  combatPointTransition
  /// Stores the clock seconds value associated with world callbacks.
  clockSeconds
  /// Stores the set model value associated with world callbacks.
  setModel
  /// Stores the light style value associated with world callbacks.
  lightStyle
  /// Stores the trace line value associated with world callbacks.
  traceLine
  /// Stores the laser sparks value associated with world callbacks.
  laserSparks
  /// Stores the earthquake value associated with world callbacks.
  earthquake
  /// Stores the fire blaster value associated with world callbacks.
  fireBlaster
  /// Stores the target explosion value associated with world callbacks.
  targetExplosion
  /// Stores the target splash value associated with world callbacks.
  targetSplash
end struct

/// Store world state data.
struct WorldState
  /// Stores the entities value associated with world state.
  entities
  /// Stores the time value associated with world state.
  time
  /// Stores the frame time value associated with world state.
  frameTime
  /// Stores the current entity value associated with world state.
  currentEntity
  /// Stores the next entity number value associated with world state.
  nextEntityNumber
  /// Stores the callbacks value associated with world state.
  callbacks
  /// Stores the events value associated with world state.
  events
  /// Stores the help message1 value associated with world state.
  helpMessage1
  /// Stores the help message2 value associated with world state.
  helpMessage2
  /// Stores the help changed value associated with world state.
  helpChanged
  /// Stores the total secrets value associated with world state.
  totalSecrets
  /// Stores the found secrets value associated with world state.
  foundSecrets
  /// Stores the total goals value associated with world state.
  totalGoals
  /// Stores the found goals value associated with world state.
  foundGoals
  /// Stores the server flags value associated with world state.
  serverFlags
  /// Stores the intermission value associated with world state.
  intermission
end struct

/// Spawn/parser-era components still expose three-element arrays in a few
/// adapters.  World simulation owns qcommon Vec3 records exclusively; convert
/// once at the producer boundary instead of teaching vector math two shapes.
/// @param value Value consumed or transformed by the operation.
/// @param label label value consumed by this operation.
function vec3FromValue(value, label)
  if typeof(value) == "array" then
    if len(value) != 3 then return error(9180, label + ": three vector components required") end if
    return qt.Vec3(value[0], value[1], value[2])
  end if
  if typeof(value) != "struct" then return error(9180, label + ": Vec3 or legacy vector array required") end if
  gwtypesVectorX = try(value.x); gwtypesVectorY = try(value.y); gwtypesVectorZ = try(value.z)
  if gwtypesVectorX is error or gwtypesVectorY is error or gwtypesVectorZ is error then
    return error(9180, label + ": Vec3 members required")
  end if
  return qt.Vec3(gwtypesVectorX, gwtypesVectorY, gwtypesVectorZ)
end function

/// Move stabilize info.
/// @param moveInfo moveInfo value consumed by this operation.
function stabilizeMoveInfo(moveInfo)
  if typeof(moveInfo) != "struct" then return error(9181, "MoveInfo record required") end if
  gwtypesMoveInfoHolder = moveInfo
  gwtypesDirectionHolder = vec3FromValue(gwtypesMoveInfoHolder.direction, "MoveInfo.direction")
  gwtypesStartOriginHolder = vec3FromValue(gwtypesMoveInfoHolder.startOrigin, "MoveInfo.startOrigin")
  gwtypesEndOriginHolder = vec3FromValue(gwtypesMoveInfoHolder.endOrigin, "MoveInfo.endOrigin")
  gwtypesStartAnglesHolder = vec3FromValue(gwtypesMoveInfoHolder.startAngles, "MoveInfo.startAngles")
  gwtypesEndAnglesHolder = vec3FromValue(gwtypesMoveInfoHolder.endAngles, "MoveInfo.endAngles")
  gwtypesMoveInfoHolder.direction = gwtypesDirectionHolder
  gwtypesMoveInfoHolder.startOrigin = gwtypesStartOriginHolder
  gwtypesMoveInfoHolder.endOrigin = gwtypesEndOriginHolder
  gwtypesMoveInfoHolder.startAngles = gwtypesStartAnglesHolder
  gwtypesMoveInfoHolder.endAngles = gwtypesEndAnglesHolder
  return gwtypesMoveInfoHolder
end function

/// Move zero info.
function zeroMoveInfo()
  gwtypesZeroDirectionHolder = qt.zeroVec3()
  gwtypesZeroStartOriginHolder = qt.zeroVec3()
  gwtypesZeroEndOriginHolder = qt.zeroVec3()
  gwtypesZeroStartAnglesHolder = qt.zeroVec3()
  gwtypesZeroEndAnglesHolder = qt.zeroVec3()
  gwtypesZeroMoveInfoHolder = MoveInfo(
    gwconstants.STATE_BOTTOM,
    0.0, 0.0, 0.0, 0.0, 0.0,
    0.0, 0.0, 0.0, 0.0, 0.0,
    gwtypesZeroDirectionHolder, gwtypesZeroStartOriginHolder, gwtypesZeroEndOriginHolder,
    gwtypesZeroStartAnglesHolder, gwtypesZeroEndAnglesHolder, void
  )
  gwtypesZeroMoveInfoHolder.direction = gwtypesZeroDirectionHolder
  gwtypesZeroMoveInfoHolder.startOrigin = gwtypesZeroStartOriginHolder
  gwtypesZeroMoveInfoHolder.endOrigin = gwtypesZeroEndOriginHolder
  gwtypesZeroMoveInfoHolder.startAngles = gwtypesZeroStartAnglesHolder
  gwtypesZeroMoveInfoHolder.endAngles = gwtypesZeroEndAnglesHolder
  return gwtypesZeroMoveInfoHolder
end function

/// Create entity.
/// @param number number value consumed by this operation.
/// @param className className value consumed by this operation.
function createEntity(number, className)
  return WorldEntity(
    number, true, className,
    "", "", "", "", "", "", "", "", "",
    0, 0, 0,
    gwconstants.SOLID_NOT, gwconstants.MOVETYPE_NONE,
    0, 0, 0, 0, 0, 0, 0, 0,
    qt.zeroVec3(), qt.zeroVec3(), qt.zeroVec3(),
    qt.zeroVec3(), qt.zeroVec3(),
    qt.zeroVec3(), qt.zeroVec3(), qt.zeroVec3(),
    qt.zeroVec3(), qt.zeroVec3(), qt.zeroVec3(),
    0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
    0, 0, 0, 0, 1.0, 0, 1.0, 1.0,
    gwconstants.DAMAGE_NO, false,
    void, void, void, void, void,
    void, void, void, void, void,
    0.0, 0.0, 0.0, zeroMoveInfo(),
    0.0, 0.0, 0.0,
    "", "", void, void, void,
    0, 0, 0, qt.zeroVec3(), 0.0, 0, 0, false
  )
end function
