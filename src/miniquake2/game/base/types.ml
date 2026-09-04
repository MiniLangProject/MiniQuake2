//! Provides miniquake2 game base types facilities for this project.

/*
Copyright (C) 1997-2001 Id Software, Inc.
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later

Managed baseq2 entity records.  These deliberately sit beside, rather than
inside, the stable Game API prefix: game/types.ml remains the engine ABI while
BaseEntity owns the private fields populated by g_spawn.c/g_save.c.
*/
package miniquake2.game.base.types

import miniquake2.game.types as gtypes
import miniquake2.qcommon.types as bqtypes

/// Store entity token data.
struct EntityToken
  /// Stores the kind value associated with entity token.
  kind
  /// Stores the text value associated with entity token.
  text
  /// Stores the offset value associated with entity token.
  offset
end struct

/// Store entity scanner data.
struct EntityScanner
  /// Stores the data value associated with entity scanner.
  data
  /// Stores the offset value associated with entity scanner.
  offset
end struct

/// Store entity pair data.
struct EntityPair
  /// Stores the key value associated with entity pair.
  key
  /// Stores the value value associated with entity pair.
  value
end struct

/// Store parsed entity data.
struct ParsedEntity
  /// Stores the pairs value associated with parsed entity.
  pairs
end struct

/// Temporary spawn fields are reset for every parsed entity in the C game DLL.
struct SpawnTemp
  /// Stores the lip value associated with spawn temp.
  lip
  /// Stores the distance value associated with spawn temp.
  distance
  /// Stores the height value associated with spawn temp.
  height
  /// Stores the noise value associated with spawn temp.
  noise
  /// Stores the pause time value associated with spawn temp.
  pauseTime
  /// Stores the item value associated with spawn temp.
  item
  /// Stores the gravity value associated with spawn temp.
  gravity
  /// Stores the sky value associated with spawn temp.
  sky
  /// Stores the sky rotate value associated with spawn temp.
  skyRotate
  /// Stores the sky axis value associated with spawn temp.
  skyAxis
  /// Stores the min yaw value associated with spawn temp.
  minYaw
  /// Stores the max yaw value associated with spawn temp.
  maxYaw
  /// Stores the min pitch value associated with spawn temp.
  minPitch
  /// Stores the max pitch value associated with spawn temp.
  maxPitch
  /// Stores the next map value associated with spawn temp.
  nextMap
  /// Stores the gravity specified value associated with spawn temp.
  gravitySpecified
end struct

/// First baseq2-private component.  It covers the common target, trigger and
/// mover fields from the original field_t table.  Later gameplay milestones
/// may append combat/AI state without changing the shared engine Edict prefix.
struct BaseEntity
  /// Stores the class name value associated with base entity.
  className
  /// Stores the model value associated with base entity.
  model
  /// Stores the spawn flags value associated with base entity.
  spawnFlags
  /// Stores the origin value associated with base entity.
  origin
  /// Stores the angles value associated with base entity.
  angles
  /// Stores the target value associated with base entity.
  target
  /// Stores the target name value associated with base entity.
  targetName
  /// Stores the kill target value associated with base entity.
  killTarget
  /// Stores the team value associated with base entity.
  team
  /// Stores the path target value associated with base entity.
  pathTarget
  /// Stores the death target value associated with base entity.
  deathTarget
  /// Stores the combat target value associated with base entity.
  combatTarget
  /// Stores the message value associated with base entity.
  message
  /// Stores the map value associated with base entity.
  map
  /// Stores the speed value associated with base entity.
  speed
  /// Stores the accel value associated with base entity.
  accel
  /// Stores the decel value associated with base entity.
  decel
  /// Stores the wait value associated with base entity.
  wait
  /// Stores the delay value associated with base entity.
  delay
  /// Stores the random value associated with base entity.
  random
  /// Stores the style value associated with base entity.
  style
  /// Stores the count value associated with base entity.
  count
  /// Stores the health value associated with base entity.
  health
  /// Stores the sounds value associated with base entity.
  sounds
  /// Stores the damage value associated with base entity.
  damage
  /// Stores the mass value associated with base entity.
  mass
  /// Stores the volume value associated with base entity.
  volume
  /// Stores the attenuation value associated with base entity.
  attenuation
  /// Stores the move origin value associated with base entity.
  moveOrigin
  /// Stores the move angles value associated with base entity.
  moveAngles
  /// Stores the spawn temp value associated with base entity.
  spawnTemp
  /// Stores the spawn kind value associated with base entity.
  spawnKind
  /// Stores the move type value associated with base entity.
  moveType
  /// Stores the solid value associated with base entity.
  solid
  /// Stores the unknown fields value associated with base entity.
  unknownFields
end struct

/// sourceIndex records the deterministic order in the BSP text.  number is the
/// compact live-edict number after unknown classes have been skipped.
struct BaseEdict
  /// Stores the number value associated with base edict.
  number
  /// Stores the source index value associated with base edict.
  sourceIndex
  /// Stores the edict value associated with base edict.
  edict
  /// Stores the component value associated with base edict.
  component
end struct

/// Store spawn entry data.
struct SpawnEntry
  /// Stores the class name value associated with spawn entry.
  className
  /// Stores the spawn value associated with spawn entry.
  spawn
end struct

/// Store spawn registry data.
struct SpawnRegistry
  /// Stores the entries value associated with spawn registry.
  entries
end struct

/// Store skipped class count data.
struct SkippedClassCount
  /// Stores the class name value associated with skipped class count.
  className
  /// Stores the count value associated with skipped class count.
  count
end struct

/// Store spawn result data.
struct SpawnResult
  /// Stores the map name value associated with spawn result.
  mapName
  /// Stores the spawn point value associated with spawn result.
  spawnPoint
  /// Stores the edicts value associated with spawn result.
  edicts
  /// Stores the diagnostics value associated with spawn result.
  diagnostics
  /// Stores the source entity count value associated with spawn result.
  sourceEntityCount
  /// Stores the skipped entity count value associated with spawn result.
  skippedEntityCount
  /// Stores the skipped classes value associated with spawn result.
  skippedClasses
  /// Stores the inhibited entity count value associated with spawn result.
  inhibitedEntityCount
end struct

/// Spawn zero temp.
function zeroSpawnTemp()
  skyAxis = [0.0, 0.0, 0.0]
  return SpawnTemp(0, 0, 0, "", 0.0, "", "", "", 0.0, skyAxis, 0.0, 0.0, 0.0, 0.0, "", false)
end function

/// Return the zero base entity value.
function zeroBaseEntity()
  origin = [0.0, 0.0, 0.0]
  angles = [0.0, 0.0, 0.0]
  moveOrigin = [0.0, 0.0, 0.0]
  moveAngles = [0.0, 0.0, 0.0]
  spawnTemp = zeroSpawnTemp()
  return BaseEntity(
    "", "", 0, origin, angles,
    "", "", "", "", "", "", "", "", "",
    0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
    0, 0, 0, 0, 0, 0,
    0.0, 0.0, moveOrigin, moveAngles,
    spawnTemp, "unspawned", 0, 0, []
  )
end function

/// Create base edict.
/// @param number number value consumed by this operation.
/// @param sourceIndex Zero-based index of source.
/// @param component component value consumed by this operation.
function makeBaseEdict(number, sourceIndex, component)
  if typeof(component) != "struct" then return error(9079, "makeBaseEdict requires a BaseEntity component") end if
  componentHolder = component
  componentOrigin = componentHolder.origin
  componentAngles = componentHolder.angles
  componentOriginHolder = bqtypes.Vec3(componentOrigin[0], componentOrigin[1], componentOrigin[2])
  componentAnglesHolder = bqtypes.Vec3(componentAngles[0], componentAngles[1], componentAngles[2])
  engineEdict = gtypes.zeroEdict(number)
  engineState = engineEdict.state
  engineEdict.inUse = true
  engineState.origin = componentOriginHolder
  engineState.angles = componentAnglesHolder
  engineEdict.state = engineState
  engineEdict.solid = componentHolder.solid
  if componentHolder.spawnKind == "worldspawn" then engineState.modelIndex = 1 end if
  result = BaseEdict(number, sourceIndex, engineEdict, componentHolder)
  // Repeat the two managed references after the BaseEdict allocation so the
  // write barrier sees both children even under a late campaign collection.
  result.edict = engineEdict
  result.component = componentHolder
  gtypes.stabilizeEdict(result.edict)
  return result
end function
