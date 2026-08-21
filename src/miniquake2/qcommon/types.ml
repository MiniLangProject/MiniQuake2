/*
Copyright (C) 1997-2001 Id Software, Inc.
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later

Foundational Quake II types used on both sides of the game boundary.
*/
package miniquake2.qcommon.types

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

struct Plane
  normal
  dist
  type
  signBits
end struct

struct CollisionSurface
  name
  flags
  value
end struct

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

struct NetAddress
  type
  ip
  ipx
  port
end struct

struct PmoveState
  moveType
  origin
  velocity
  flags
  time
  gravity
  deltaAngles
end struct

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

struct Cvar
  name
  string
  latchedString
  flags
  modified
  value
end struct

struct CvarRegistry
  variables
  userInfoModified
end struct

struct CommandAlias
  name
  value
end struct

struct CommandSystem
  commands
  aliases
  arguments
  argumentTail
  buffer
  wait
  cvars
end struct

struct PackFile
  name
  offset
  length
end struct

struct PackArchive
  filename
  data
  files
end struct

struct SearchPath
  directory
  pack
end struct

struct FileSystem
  baseDirectory
  gameDirectory
  searchPaths
  links
end struct

function vec3(x, y, z)
  return Vec3(x, y, z)
end function

function zeroVec3()
  return Vec3(0.0, 0.0, 0.0)
end function

function zeroUserCmd()
  return UserCmd(0, 0, [0, 0, 0], 0, 0, 0, 0, 0)
end function
