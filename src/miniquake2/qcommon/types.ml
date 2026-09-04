//! Provides miniquake2 qcommon types facilities for this project.

/*
Copyright (C) 1997-2001 Id Software, Inc.
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later

Foundational Quake II types used on both sides of the game boundary.
*/
package miniquake2.qcommon.types

/// Store vec 3 data.
struct Vec3
  /// Stores the x value associated with vec3.
  x
  /// Stores the y value associated with vec3.
  y
  /// Stores the z value associated with vec3.
  z
end struct

/// MiniLang owns the backing bytes. maxSize may intentionally be smaller than
/// len(data), matching SZ_Init over a caller-owned C array.
struct SizeBuffer
  /// Stores the allow overflow value associated with size buffer.
  allowOverflow
  /// Stores the overflowed value associated with size buffer.
  overflowed
  /// Stores the data value associated with size buffer.
  data
  /// Stores the max size value associated with size buffer.
  maxSize
  /// Stores the cur size value associated with size buffer.
  curSize
  /// Stores the read count value associated with size buffer.
  readCount
end struct

/// Store plane data.
struct Plane
  /// Stores the normal value associated with plane.
  normal
  /// Stores the dist value associated with plane.
  dist
  /// Stores the type value associated with plane.
  type
  /// Stores the sign bits value associated with plane.
  signBits
end struct

/// Store collision surface data.
struct CollisionSurface
  /// Stores the name value associated with collision surface.
  name
  /// Stores the flags value associated with collision surface.
  flags
  /// Stores the value value associated with collision surface.
  value
end struct

/// Store trace data.
struct Trace
  /// Stores the all solid value associated with trace.
  allSolid
  /// Stores the start solid value associated with trace.
  startSolid
  /// Stores the fraction value associated with trace.
  fraction
  /// Stores the end position value associated with trace.
  endPosition
  /// Stores the plane value associated with trace.
  plane
  /// Stores the surface value associated with trace.
  surface
  /// Stores the contents value associated with trace.
  contents
  /// Stores the entity value associated with trace.
  entity
end struct

/// Store net address data.
struct NetAddress
  /// Stores the type value associated with net address.
  type
  /// Stores the ip value associated with net address.
  ip
  /// Stores the ipx value associated with net address.
  ipx
  /// Stores the port value associated with net address.
  port
end struct

/// Store pmove state data.
struct PmoveState
  /// Stores the move type value associated with pmove state.
  moveType
  /// Stores the origin value associated with pmove state.
  origin
  /// Stores the velocity value associated with pmove state.
  velocity
  /// Stores the flags value associated with pmove state.
  flags
  /// Stores the time value associated with pmove state.
  time
  /// Stores the gravity value associated with pmove state.
  gravity
  /// Stores the delta angles value associated with pmove state.
  deltaAngles
end struct

/// Store user cmd data.
struct UserCmd
  /// Stores the msec value associated with user cmd.
  msec
  /// Stores the buttons value associated with user cmd.
  buttons
  /// Stores the angles value associated with user cmd.
  angles
  /// Stores the forward move value associated with user cmd.
  forwardMove
  /// Stores the side move value associated with user cmd.
  sideMove
  /// Stores the up move value associated with user cmd.
  upMove
  /// Stores the impulse value associated with user cmd.
  impulse
  /// Stores the light level value associated with user cmd.
  lightLevel
end struct

/// Store cvar data.
struct Cvar
  /// Stores the canonical console-variable name used by qcommon.
  name
  /// Stores the string value associated with cvar.
  string
  /// Stores the latched string value associated with cvar.
  latchedString
  /// Stores qcommon persistence and behavior flags for the variable.
  flags
  /// Stores the modified value associated with cvar.
  modified
  /// Stores the value value associated with cvar.
  value
end struct

/// Store cvar registry data.
struct CvarRegistry
  /// Stores the variables value associated with cvar registry.
  variables
  /// Stores the user info modified value associated with cvar registry.
  userInfoModified
end struct

/// Store command alias data.
struct CommandAlias
  /// Stores the name value associated with command alias.
  name
  /// Stores the value value associated with command alias.
  value
end struct

/// Store command system data.
struct CommandSystem
  /// Stores the commands value associated with command system.
  commands
  /// Stores the aliases value associated with command system.
  aliases
  /// Stores the arguments value associated with command system.
  arguments
  /// Stores the argument tail value associated with command system.
  argumentTail
  /// Stores the buffer value associated with command system.
  buffer
  /// Stores the wait value associated with command system.
  wait
  /// Stores the cvars value associated with command system.
  cvars
end struct

/// Store pack file data.
struct PackFile
  /// Stores the name value associated with pack file.
  name
  /// Stores the offset value associated with pack file.
  offset
  /// Stores the length value associated with pack file.
  length
end struct

/// Store pack archive data.
struct PackArchive
  /// Stores the filename value associated with pack archive.
  filename
  /// Stores the data value associated with pack archive.
  data
  /// Stores the files value associated with pack archive.
  files
  /// Stores the lookup value associated with pack archive.
  lookup
end struct

/// Store search path data.
struct SearchPath
  /// Stores the directory value associated with search path.
  directory
  /// Stores the pack value associated with search path.
  pack
end struct

/// Store file system data.
struct FileSystem
  /// Stores the base directory value associated with file system.
  baseDirectory
  /// Stores the game directory value associated with file system.
  gameDirectory
  /// Stores the search paths value associated with file system.
  searchPaths
  /// Stores the links value associated with file system.
  links
end struct

/// Return the vec 3 value.
/// @param x Horizontal coordinate used by the operation.
/// @param y Vertical coordinate used by the operation.
/// @param z z value consumed by this operation.
function vec3(x, y, z)
  return Vec3(x, y, z)
end function

/// Return the zero vec 3 value.
function zeroVec3()
  return Vec3(0.0, 0.0, 0.0)
end function

/// Return the zero user cmd value.
function zeroUserCmd()
  return UserCmd(0, 0, [0, 0, 0], 0, 0, 0, 0, 0)
end function
