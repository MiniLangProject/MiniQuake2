//! Provides miniquake2 game types facilities for this project.

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

/// Store cvar data.
struct Cvar
  /// Stores the game-module console-variable name.
  name
  /// Stores the string value associated with cvar.
  string
  /// Stores the latched string value associated with cvar.
  latchedString
  /// Stores game-module behavior flags for the variable.
  flags
  /// Stores the modified value associated with cvar.
  modified
  /// Stores the value value associated with cvar.
  value
  /// Stores the next value associated with cvar.
  next
end struct

/// Store entity state data.
struct EntityState
  /// Stores the number value associated with entity state.
  number
  /// Stores the origin value associated with entity state.
  origin
  /// Stores the angles value associated with entity state.
  angles
  /// Stores the old origin value associated with entity state.
  oldOrigin
  /// Stores the model index value associated with entity state.
  modelIndex
  /// Stores the model index2 value associated with entity state.
  modelIndex2
  /// Stores the model index3 value associated with entity state.
  modelIndex3
  /// Stores the model index4 value associated with entity state.
  modelIndex4
  /// Stores the frame value associated with entity state.
  frame
  /// Stores the skin number value associated with entity state.
  skinNumber
  /// Stores the effects value associated with entity state.
  effects
  /// Stores the render fx value associated with entity state.
  renderFx
  /// Stores the solid value associated with entity state.
  solid
  /// Stores the sound value associated with entity state.
  sound
  /// Stores the event value associated with entity state.
  event
end struct

/// Store player state data.
struct PlayerState
  /// Stores the pmove value associated with player state.
  pmove
  /// Stores the view angles value associated with player state.
  viewAngles
  /// Stores the view offset value associated with player state.
  viewOffset
  /// Stores the kick angles value associated with player state.
  kickAngles
  /// Stores the gun angles value associated with player state.
  gunAngles
  /// Stores the gun offset value associated with player state.
  gunOffset
  /// Stores the gun index value associated with player state.
  gunIndex
  /// Stores the gun frame value associated with player state.
  gunFrame
  /// Stores the blend value associated with player state.
  blend
  /// Stores the fov value associated with player state.
  fov
  /// Stores the rd flags value associated with player state.
  rdFlags
  /// Stores the stats value associated with player state.
  stats
end struct

/// Store pmove data.
struct Pmove
  /// Stores the state value associated with pmove.
  state
  /// Stores the command value associated with pmove.
  command
  /// Stores the snap initial value associated with pmove.
  snapInitial
  /// Stores the num touch value associated with pmove.
  numTouch
  /// Stores the touch entities value associated with pmove.
  touchEntities
  /// Stores the view angles value associated with pmove.
  viewAngles
  /// Stores the view height value associated with pmove.
  viewHeight
  /// Stores the mins value associated with pmove.
  mins
  /// Stores the maxs value associated with pmove.
  maxs
  /// Stores the ground entity value associated with pmove.
  groundEntity
  /// Stores the water type value associated with pmove.
  waterType
  /// Stores the water level value associated with pmove.
  waterLevel
  /// Stores the trace value associated with pmove.
  trace
  /// Stores the point contents value associated with pmove.
  pointContents
end struct

/// Store link data.
struct Link
  /// Stores the previous value associated with link.
  previous
  /// Stores the next value associated with link.
  next
end struct

/// The fields through owner are the exact server-visible prefix from game.h.
/// Future baseq2-private fields must only be appended after owner.
struct GameClient
  /// Stores the player state value associated with game client.
  playerState
  /// Stores the ping value associated with game client.
  ping
end struct

/// Store edict data.
struct Edict
  /// Stores the state value associated with edict.
  state
  /// Stores the client value associated with edict.
  client
  /// Stores the in use value associated with edict.
  inUse
  /// Stores the link count value associated with edict.
  linkCount
  /// Stores the area value associated with edict.
  area
  /// Stores the num clusters value associated with edict.
  numClusters
  /// Stores the cluster numbers value associated with edict.
  clusterNumbers
  /// Stores the head node value associated with edict.
  headNode
  /// Stores the area number value associated with edict.
  areaNumber
  /// Stores the area number2 value associated with edict.
  areaNumber2
  /// Stores the server flags value associated with edict.
  serverFlags
  /// Stores the mins value associated with edict.
  mins
  /// Stores the maxs value associated with edict.
  maxs
  /// Stores the absolute mins value associated with edict.
  absoluteMins
  /// Stores the absolute maxs value associated with edict.
  absoluteMaxs
  /// Stores the size value associated with edict.
  size
  /// Stores the solid value associated with edict.
  solid
  /// Stores the clip mask value associated with edict.
  clipMask
  /// Stores the owner value associated with edict.
  owner
end struct

/// Function-valued form of game_import_t. Variadic C print functions take one
/// already-formatted MiniLang string. collisionWorldReady is the sole appended
/// MiniQuake2 extension: asset-free test/runtime graphs can distinguish their
/// intentional lack of a BSP hull from an ordinary unobstructed trace.
struct GameImport
  /// Stores the bprintf value associated with game import.
  bprintf
  /// Stores the dprintf value associated with game import.
  dprintf
  /// Stores the cprintf value associated with game import.
  cprintf
  /// Stores the centerprintf value associated with game import.
  centerprintf
  /// Stores the sound value associated with game import.
  sound
  /// Stores the positioned sound value associated with game import.
  positionedSound
  /// Stores the config string value associated with game import.
  configString
  /// Stores the fail value associated with game import.
  fail
  /// Stores the model index value associated with game import.
  modelIndex
  /// Stores the sound index value associated with game import.
  soundIndex
  /// Stores the image index value associated with game import.
  imageIndex
  /// Stores the set model value associated with game import.
  setModel
  /// Stores the trace value associated with game import.
  trace
  /// Stores the point contents value associated with game import.
  pointContents
  /// Stores the in pvs value associated with game import.
  inPVS
  /// Stores the in phs value associated with game import.
  inPHS
  /// Stores the set area portal state value associated with game import.
  setAreaPortalState
  /// Stores the areas connected value associated with game import.
  areasConnected
  /// Stores the link entity value associated with game import.
  linkEntity
  /// Stores the unlink entity value associated with game import.
  unlinkEntity
  /// Stores the box edicts value associated with game import.
  boxEdicts
  /// Stores the pmove value associated with game import.
  pmove
  /// Stores the multicast value associated with game import.
  multicast
  /// Stores the unicast value associated with game import.
  unicast
  /// Stores the write char value associated with game import.
  writeChar
  /// Stores the write byte value associated with game import.
  writeByte
  /// Stores the write short value associated with game import.
  writeShort
  /// Stores the write long value associated with game import.
  writeLong
  /// Stores the write float value associated with game import.
  writeFloat
  /// Stores the write string value associated with game import.
  writeString
  /// Stores the write position value associated with game import.
  writePosition
  /// Stores the write direction value associated with game import.
  writeDirection
  /// Stores the write angle value associated with game import.
  writeAngle
  /// Stores the tag malloc value associated with game import.
  tagMalloc
  /// Stores the tag free value associated with game import.
  tagFree
  /// Stores the free tags value associated with game import.
  freeTags
  /// Stores the cvar value associated with game import.
  cvar
  /// Stores the cvar set value associated with game import.
  cvarSet
  /// Stores the cvar force set value associated with game import.
  cvarForceSet
  /// Stores the argc value associated with game import.
  argc
  /// Stores the argv value associated with game import.
  argv
  /// Stores the args value associated with game import.
  args
  /// Stores the add command string value associated with game import.
  addCommandString
  /// Stores the debug graph value associated with game import.
  debugGraph
  /// Stores the collision world ready value associated with game import.
  collisionWorldReady
end struct

/// Function-valued form of game_export_t. The last four members retain the
/// original shared-global semantics. edictSize is a logical MiniLang stride.
struct GameExport
  /// Stores the api version value associated with game export.
  apiVersion
  /// Stores the init value associated with game export.
  init
  /// Stores the shutdown value associated with game export.
  shutdown
  /// Stores the spawn entities value associated with game export.
  spawnEntities
  /// Stores the write game value associated with game export.
  writeGame
  /// Stores the read game value associated with game export.
  readGame
  /// Stores the write level value associated with game export.
  writeLevel
  /// Stores the read level value associated with game export.
  readLevel
  /// Stores the client connect value associated with game export.
  clientConnect
  /// Stores the client begin value associated with game export.
  clientBegin
  /// Stores the client userinfo changed value associated with game export.
  clientUserinfoChanged
  /// Stores the client disconnect value associated with game export.
  clientDisconnect
  /// Stores the client command value associated with game export.
  clientCommand
  /// Stores the client think value associated with game export.
  clientThink
  /// Stores the run frame value associated with game export.
  runFrame
  /// Stores the server command value associated with game export.
  serverCommand
  /// Stores the edicts value associated with game export.
  edicts
  /// Stores the edict size value associated with game export.
  edictSize
  /// Stores the num edicts value associated with game export.
  numEdicts
  /// Stores the max edicts value associated with game export.
  maxEdicts
end struct

/// Return the zero pmove state.
function zeroPmoveState()
  return qt.PmoveState(gc.PM_NORMAL, [0, 0, 0], [0, 0, 0], 0, 0, 0, [0, 0, 0])
end function

/// Return the zero user cmd value.
function zeroUserCmd()
  return qt.UserCmd(0, 0, [0, 0, 0], 0, 0, 0, 0, 0)
end function

/// Return the zero entity state.
/// @param number number value consumed by this operation.
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

/// Return the stabilize entity state.
/// @param gtypesStateValue gtypesStateValue value consumed by this operation.
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

/// Return the zero player state.
function zeroPlayerState()
  return PlayerState(
    zeroPmoveState(),
    qt.zeroVec3(), qt.zeroVec3(), qt.zeroVec3(),
    qt.zeroVec3(), qt.zeroVec3(),
    0, 0, [0.0, 0.0, 0.0, 0.0], 0.0, 0, array(gc.MAX_STATS, 0)
  )
end function

/// Return the zero game client value.
function zeroGameClient()
  return GameClient(zeroPlayerState(), 0)
end function

/// Return the zero edict value.
/// @param number number value consumed by this operation.
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

/// Return the stabilize edict value.
/// @param gtypesEdictValue gtypesEdictValue value consumed by this operation.
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

/// Return the zero pmove value.
/// @param traceCallback traceCallback value consumed by this operation.
/// @param pointContentsCallback pointContentsCallback value consumed by this operation.
function zeroPmove(traceCallback, pointContentsCallback)
  return Pmove(
    zeroPmoveState(), zeroUserCmd(), false,
    0, array(gc.MAXTOUCH), qt.zeroVec3(), 0.0,
    qt.zeroVec3(), qt.zeroVec3(), void, 0, 0,
    traceCallback, pointContentsCallback
  )
end function

/// Return the cvar value.
/// @param name Name of the affected item.
/// @param value Value consumed or transformed by the operation.
/// @param flags Bit flags controlling the operation.
function cvar(name, value, flags)
  return Cvar(name, value, "", flags, false, toNumber(value), void)
end function
