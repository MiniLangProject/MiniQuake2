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

struct EntityToken
  kind
  text
  offset
end struct

struct EntityScanner
  data
  offset
end struct

struct EntityPair
  key
  value
end struct

struct ParsedEntity
  pairs
end struct

// Temporary spawn fields are reset for every parsed entity in the C game DLL.
struct SpawnTemp
  lip
  distance
  height
  noise
  pauseTime
  item
  gravity
  sky
  skyRotate
  skyAxis
  minYaw
  maxYaw
  minPitch
  maxPitch
  nextMap
end struct

// First baseq2-private component.  It covers the common target, trigger and
// mover fields from the original field_t table.  Later gameplay milestones
// may append combat/AI state without changing the shared engine Edict prefix.
struct BaseEntity
  className
  model
  spawnFlags
  origin
  angles
  target
  targetName
  killTarget
  team
  pathTarget
  deathTarget
  combatTarget
  message
  map
  speed
  accel
  decel
  wait
  delay
  random
  style
  count
  health
  sounds
  damage
  mass
  volume
  attenuation
  moveOrigin
  moveAngles
  spawnTemp
  spawnKind
  moveType
  solid
  unknownFields
end struct

// sourceIndex records the deterministic order in the BSP text.  number is the
// compact live-edict number after unknown classes have been skipped.
struct BaseEdict
  number
  sourceIndex
  edict
  component
end struct

struct SpawnEntry
  className
  spawn
end struct

struct SpawnRegistry
  entries
end struct

struct SkippedClassCount
  className
  count
end struct

struct SpawnResult
  mapName
  spawnPoint
  edicts
  diagnostics
  sourceEntityCount
  skippedEntityCount
  skippedClasses
  inhibitedEntityCount
end struct

function zeroSpawnTemp()
  skyAxis = [0.0, 0.0, 0.0]
  return SpawnTemp(0, 0, 0, "", 0.0, "", "", "", 0.0, skyAxis, 0.0, 0.0, 0.0, 0.0, "")
end function

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
