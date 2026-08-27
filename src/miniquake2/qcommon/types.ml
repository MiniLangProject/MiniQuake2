/*
Copyright (C) 1997-2001 Id Software, Inc.
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later

Foundational Quake II types used on both sides of the game boundary.
*/
package miniquake2.qcommon.types

// Store vec 3 data.
struct Vec3
  x
  y
  z
end struct

// MiniLang owns the backing bytes. maxSize may intentionally be smaller than
// len(data), matching SZ_Init over a caller-owned C array.
struct SizeBuffer
  allowOverflow
  overflowed
  data
  maxSize
  curSize
  readCount
end struct

// Store plane data.
struct Plane
  normal
  dist
  type
  signBits
end struct

// Store collision surface data.
struct CollisionSurface
  name
  flags
  value
end struct

// Store trace data.
struct Trace
  allSolid
  startSolid
  fraction
  endPosition
  plane
  surface
  contents
  entity
end struct

// Store net address data.
struct NetAddress
  type
  ip
  ipx
  port
end struct

// Store pmove state data.
struct PmoveState
  moveType
  origin
  velocity
  flags
  time
  gravity
  deltaAngles
end struct

// Store user cmd data.
struct UserCmd
  msec
  buttons
  angles
  forwardMove
  sideMove
  upMove
  impulse
  lightLevel
end struct

// Store cvar data.
struct Cvar
  name
  string
  latchedString
  flags
  modified
  value
end struct

// Store cvar registry data.
struct CvarRegistry
  variables
  userInfoModified
end struct

// Store command alias data.
struct CommandAlias
  name
  value
end struct

// Store command system data.
struct CommandSystem
  commands
  aliases
  arguments
  argumentTail
  buffer
  wait
  cvars
end struct

// Store pack file data.
struct PackFile
  name
  offset
  length
end struct

// Store pack archive data.
struct PackArchive
  filename
  data
  files
end struct

// Store search path data.
struct SearchPath
  directory
  pack
end struct

// Store file system data.
struct FileSystem
  baseDirectory
  gameDirectory
  searchPaths
  links
end struct

// Return the vec 3 value.
function vec3(x, y, z)
  return Vec3(x, y, z)
end function

// Return the zero vec 3 value.
function zeroVec3()
  return Vec3(0.0, 0.0, 0.0)
end function

// Return the zero user cmd value.
function zeroUserCmd()
  return UserCmd(0, 0, [0, 0, 0], 0, 0, 0, 0, 0)
end function
