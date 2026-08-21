/*
Copyright (C) 1997-2001 Id Software, Inc.
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later

Managed representation of game.h and the q_shared.h records that cross the
engine/game boundary. This is an internal MiniLang ABI: no native DLL layout is
promised. Field order follows the C declarations so review remains mechanical.
*/
package miniquake2.game.types

import miniquake2.qcommon.types as qt
import miniquake2.game.constants as gc

struct Cvar
  name
  string
  latchedString
  flags
  modified
  value
  next
end struct

struct EntityState
  number
  origin
  angles
  oldOrigin
  modelIndex
  modelIndex2
  modelIndex3
  modelIndex4
  frame
  skinNumber
  effects
  renderFx
  solid
  sound
  event
end struct

struct PlayerState
  pmove
  viewAngles
  viewOffset
  kickAngles
  gunAngles
  gunOffset
  gunIndex
  gunFrame
  blend
  fov
  rdFlags
  stats
end struct

struct Pmove
  state
  command
  snapInitial
  numTouch
  touchEntities
  viewAngles
  viewHeight
  mins
  maxs
  groundEntity
  waterType
  waterLevel
  trace
  pointContents
end struct

struct Link
  previous
  next
end struct

// The fields through owner are the exact server-visible prefix from game.h.
// Future baseq2-private fields must only be appended after owner.
struct GameClient
  playerState
  ping
end struct

struct Edict
  state
  client
  inUse
  linkCount
  area
  numClusters
  clusterNumbers
  headNode
  areaNumber
  areaNumber2
  serverFlags
  mins
  maxs
  absoluteMins
  absoluteMaxs
  size
  solid
  clipMask
  owner
end struct

// Function-valued form of game_import_t. Variadic C print functions take one
// already-formatted MiniLang string; that is the only intentional signature
// adaptation in the managed boundary.
struct GameImport
  bprintf
  dprintf
  cprintf
  centerprintf
  sound
  positionedSound
  configString
  fail
  modelIndex
  soundIndex
  imageIndex
  setModel
  trace
  pointContents
  inPVS
  inPHS
  setAreaPortalState
  areasConnected
  linkEntity
  unlinkEntity
  boxEdicts
  pmove
  multicast
  unicast
  writeChar
  writeByte
  writeShort
  writeLong
  writeFloat
  writeString
  writePosition
  writeDirection
  writeAngle
  tagMalloc
  tagFree
  freeTags
  cvar
  cvarSet
  cvarForceSet
  argc
  argv
  args
  addCommandString
  debugGraph
end struct

// Function-valued form of game_export_t. The last four members retain the
// original shared-global semantics. edictSize is a logical MiniLang stride.
struct GameExport
  apiVersion
  init
  shutdown
  spawnEntities
  writeGame
  readGame
  writeLevel
  readLevel
  clientConnect
  clientBegin
  clientUserinfoChanged
  clientDisconnect
  clientCommand
  clientThink
  runFrame
  serverCommand
  edicts
  edictSize
  numEdicts
  maxEdicts
end struct

function zeroPmoveState()
  return qt.PmoveState(gc.PM_NORMAL, [0, 0, 0], [0, 0, 0], 0, 0, 0, [0, 0, 0])
end function

function zeroUserCmd()
  return qt.UserCmd(0, 0, [0, 0, 0], 0, 0, 0, 0, 0)
end function

function zeroEntityState(number)
  gtypesStateOriginHolder = qt.zeroVec3()
  gtypesStateAnglesHolder = qt.zeroVec3()
  gtypesStateOldOriginHolder = qt.zeroVec3()
  gtypesStateRecord = EntityState(
    number,
    gtypesStateOriginHolder, gtypesStateAnglesHolder, gtypesStateOldOriginHolder,
    0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, gc.EV_NONE
  )
  gtypesStateRecord.origin = gtypesStateOriginHolder
  gtypesStateRecord.angles = gtypesStateAnglesHolder
  gtypesStateRecord.oldOrigin = gtypesStateOldOriginHolder
  return gtypesStateRecord
end function

function stabilizeEntityState(gtypesStateValue)
  if typeof(gtypesStateValue) != "struct" then return error(3740, "EntityState record required") end if
  gtypesStateHolder = gtypesStateValue
  gtypesStateNumberProbe = try(gtypesStateHolder.number)
  gtypesStateModel1Probe = try(gtypesStateHolder.modelIndex)
  gtypesStateModel2Probe = try(gtypesStateHolder.modelIndex2)
  gtypesStateModel3Probe = try(gtypesStateHolder.modelIndex3)
  gtypesStateModel4Probe = try(gtypesStateHolder.modelIndex4)
  gtypesStateFrameProbe = try(gtypesStateHolder.frame)
  gtypesStateSkinProbe = try(gtypesStateHolder.skinNumber)
  gtypesStateEffectsProbe = try(gtypesStateHolder.effects)
  gtypesStateRenderProbe = try(gtypesStateHolder.renderFx)
  gtypesStateSolidProbe = try(gtypesStateHolder.solid)
  gtypesStateSoundProbe = try(gtypesStateHolder.sound)
  gtypesStateEventProbe = try(gtypesStateHolder.event)
  if gtypesStateNumberProbe is error or gtypesStateModel1Probe is error or gtypesStateModel2Probe is error or
      gtypesStateModel3Probe is error or gtypesStateModel4Probe is error or gtypesStateFrameProbe is error or
      gtypesStateSkinProbe is error or gtypesStateEffectsProbe is error or gtypesStateRenderProbe is error or
      gtypesStateSolidProbe is error or gtypesStateSoundProbe is error or gtypesStateEventProbe is error then
    return error(3744, "EntityState scalar shape is unavailable")
  end if
  gtypesStableOriginHolder = gtypesStateHolder.origin
  gtypesStableAnglesHolder = gtypesStateHolder.angles
  gtypesStableOldOriginHolder = gtypesStateHolder.oldOrigin
  if typeof(gtypesStableOriginHolder) != "struct" or typeof(gtypesStableAnglesHolder) != "struct" or
      typeof(gtypesStableOldOriginHolder) != "struct" then
    return error(3741, "EntityState vectors are unavailable")
  end if
  gtypesStateHolder.origin = gtypesStableOriginHolder
  gtypesStateHolder.angles = gtypesStableAnglesHolder
  gtypesStateHolder.oldOrigin = gtypesStableOldOriginHolder
  return gtypesStateHolder
end function

function zeroPlayerState()
  return PlayerState(
    zeroPmoveState(),
    qt.zeroVec3(), qt.zeroVec3(), qt.zeroVec3(),
    qt.zeroVec3(), qt.zeroVec3(),
    0, 0, [0.0, 0.0, 0.0, 0.0], 0.0, 0, array(gc.MAX_STATS, 0)
  )
end function

function zeroGameClient()
  return GameClient(zeroPlayerState(), 0)
end function

function zeroEdict(number)
  // Every value survives several subsequent managed allocations before the
  // final Edict constructor.  Keep explicit roots: late campaign-map spawns
  // otherwise made the early EntityState constructor temporary collectible.
  gtypesEdictStateHolder = zeroEntityState(number)
  gtypesEdictAreaHolder = Link(void, void)
  gtypesEdictClustersHolder = array(gc.MAX_ENT_CLUSTERS, 0)
  gtypesEdictMinsHolder = qt.zeroVec3()
  gtypesEdictMaxsHolder = qt.zeroVec3()
  gtypesEdictAbsoluteMinsHolder = qt.zeroVec3()
  gtypesEdictAbsoluteMaxsHolder = qt.zeroVec3()
  gtypesEdictSizeHolder = qt.zeroVec3()
  gtypesEdictRecord = Edict(
    gtypesEdictStateHolder, void, false, 0,
    gtypesEdictAreaHolder, 0, gtypesEdictClustersHolder, 0, 0, 0,
    0,
    gtypesEdictMinsHolder, gtypesEdictMaxsHolder, gtypesEdictAbsoluteMinsHolder, gtypesEdictAbsoluteMaxsHolder, gtypesEdictSizeHolder,
    gc.SOLID_NOT, 0, void
  )
  gtypesEdictRecord.state = gtypesEdictStateHolder
  gtypesEdictRecord.area = gtypesEdictAreaHolder
  gtypesEdictRecord.clusterNumbers = gtypesEdictClustersHolder
  gtypesEdictRecord.mins = gtypesEdictMinsHolder
  gtypesEdictRecord.maxs = gtypesEdictMaxsHolder
  gtypesEdictRecord.absoluteMins = gtypesEdictAbsoluteMinsHolder
  gtypesEdictRecord.absoluteMaxs = gtypesEdictAbsoluteMaxsHolder
  gtypesEdictRecord.size = gtypesEdictSizeHolder
  return gtypesEdictRecord
end function

function stabilizeEdict(gtypesEdictValue)
  if typeof(gtypesEdictValue) != "struct" then return error(3742, "Edict record required") end if
  gtypesStableEdictHolder = gtypesEdictValue
  gtypesEdictStateProbe = try(gtypesStableEdictHolder.state)
  gtypesEdictAreaProbe = try(gtypesStableEdictHolder.area)
  gtypesEdictClustersProbe = try(gtypesStableEdictHolder.clusterNumbers)
  gtypesEdictMinsProbe = try(gtypesStableEdictHolder.mins)
  gtypesEdictMaxsProbe = try(gtypesStableEdictHolder.maxs)
  gtypesEdictAbsoluteMinsProbe = try(gtypesStableEdictHolder.absoluteMins)
  gtypesEdictAbsoluteMaxsProbe = try(gtypesStableEdictHolder.absoluteMaxs)
  gtypesEdictSizeProbe = try(gtypesStableEdictHolder.size)
  gtypesEdictInUseProbe = try(gtypesStableEdictHolder.inUse)
  gtypesEdictServerFlagsProbe = try(gtypesStableEdictHolder.serverFlags)
  if gtypesEdictStateProbe is error or gtypesEdictAreaProbe is error or gtypesEdictClustersProbe is error or
      gtypesEdictMinsProbe is error or gtypesEdictMaxsProbe is error or gtypesEdictAbsoluteMinsProbe is error or
      gtypesEdictAbsoluteMaxsProbe is error or gtypesEdictSizeProbe is error or gtypesEdictInUseProbe is error or
      gtypesEdictServerFlagsProbe is error then return error(3745, "Edict field shape is unavailable") end if
  gtypesStableStateHolder = stabilizeEntityState(gtypesEdictStateProbe)
  gtypesStableAreaHolder = gtypesEdictAreaProbe
  gtypesStableClustersHolder = gtypesEdictClustersProbe
  gtypesStableMinsHolder = gtypesEdictMinsProbe
  gtypesStableMaxsHolder = gtypesEdictMaxsProbe
  gtypesStableAbsoluteMinsHolder = gtypesEdictAbsoluteMinsProbe
  gtypesStableAbsoluteMaxsHolder = gtypesEdictAbsoluteMaxsProbe
  gtypesStableSizeHolder = gtypesEdictSizeProbe
  if typeof(gtypesStableAreaHolder) != "struct" or typeof(gtypesStableClustersHolder) != "array" or
      typeof(gtypesStableMinsHolder) != "struct" or typeof(gtypesStableMaxsHolder) != "struct" or
      typeof(gtypesStableAbsoluteMinsHolder) != "struct" or typeof(gtypesStableAbsoluteMaxsHolder) != "struct" or
      typeof(gtypesStableSizeHolder) != "struct" then
    return error(3743, "Edict managed children are unavailable")
  end if
  gtypesStableEdictHolder.state = gtypesStableStateHolder
  gtypesStableEdictHolder.area = gtypesStableAreaHolder
  gtypesStableEdictHolder.clusterNumbers = gtypesStableClustersHolder
  gtypesStableEdictHolder.mins = gtypesStableMinsHolder
  gtypesStableEdictHolder.maxs = gtypesStableMaxsHolder
  gtypesStableEdictHolder.absoluteMins = gtypesStableAbsoluteMinsHolder
  gtypesStableEdictHolder.absoluteMaxs = gtypesStableAbsoluteMaxsHolder
  gtypesStableEdictHolder.size = gtypesStableSizeHolder
  return gtypesStableEdictHolder
end function

function zeroPmove(traceCallback, pointContentsCallback)
  return Pmove(
    zeroPmoveState(), zeroUserCmd(), false,
    0, array(gc.MAXTOUCH), qt.zeroVec3(), 0.0,
    qt.zeroVec3(), qt.zeroVec3(), void, 0, 0,
    traceCallback, pointContentsCallback
  )
end function

function cvar(name, value, flags)
  return Cvar(name, value, "", flags, false, toNumber(value), void)
end function
