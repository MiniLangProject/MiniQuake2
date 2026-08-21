/* Managed state used by the BaseQ2 world state machines. */
package miniquake2.game.world.types

import miniquake2.qcommon.types as qt
import miniquake2.game.world.constants as gwconstants

struct MoveInfo
  state
  speed
  accel
  decel
  wait
  distance
  currentSpeed
  moveSpeed
  nextSpeed
  remainingDistance
  decelDistance
  direction
  startOrigin
  endOrigin
  startAngles
  endAngles
  endFunction
end struct

struct WorldEntity
  number
  inUse
  className
  target
  targetName
  killTarget
  pathTarget
  team
  message
  map
  model
  noise
  spawnFlags
  flags
  serverFlags
  solid
  moveType
  modelIndex
  effects
  renderFx
  frame
  soundIndex
  loopSound
  style
  origin
  angles
  oldOrigin
  velocity
  angularVelocity
  mins
  maxs
  size
  absoluteMins
  absoluteMaxs
  moveDirection
  speed
  accel
  decel
  wait
  delay
  random
  damage
  health
  maxHealth
  mass
  count
  volume
  attenuation
  takeDamage
  isClient
  activator
  owner
  teamMaster
  teamChain
  targetEntity
  use
  think
  touch
  blocked
  die
  nextThink
  touchDebounceTime
  moveInfo
  pauseTime
  lip
  height
end struct

struct WorldCallbacks
  log
  centerPrint
  sound
  areaPortal
  damage
  radiusDamage
  effect
  changeLevel
  spawnExternal
  linkEntity
  killBox
  randomSigned
  randomIndex
end struct

struct WorldState
  entities
  time
  frameTime
  currentEntity
  nextEntityNumber
  callbacks
  events
  helpMessage1
  helpMessage2
  helpChanged
  totalSecrets
  foundSecrets
  totalGoals
  foundGoals
  serverFlags
  intermission
end struct

// Spawn/parser-era components still expose three-element arrays in a few
// adapters.  World simulation owns qcommon Vec3 records exclusively; convert
// once at the producer boundary instead of teaching vector math two shapes.
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

function createEntity(number, className)
  return WorldEntity(
    number, true, className,
    "", "", "", "", "", "", "", "", "",
    0, 0, 0,
    gwconstants.SOLID_NOT, gwconstants.MOVETYPE_NONE,
    0, 0, 0, 0, 0, 0, 0,
    qt.zeroVec3(), qt.zeroVec3(), qt.zeroVec3(),
    qt.zeroVec3(), qt.zeroVec3(),
    qt.zeroVec3(), qt.zeroVec3(), qt.zeroVec3(),
    qt.zeroVec3(), qt.zeroVec3(), qt.zeroVec3(),
    0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
    0, 0, 0, 0, 0, 1.0, 1.0,
    gwconstants.DAMAGE_NO, false,
    void, void, void, void, void,
    void, void, void, void, void,
    0.0, 0.0, zeroMoveInfo(),
    0.0, 0.0, 0.0
  )
end function
