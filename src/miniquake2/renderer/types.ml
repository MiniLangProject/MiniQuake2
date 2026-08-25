/*
Copyright (C) 1997-2001 Id Software, Inc.
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later

Managed Renderer API v3 records. Pointer/count pairs from client/ref.h are
represented by arrays plus their explicit C-compatible counts. Renderer and
engine entry points remain first-class MiniLang function values.
*/
package miniquake2.renderer.types

import miniquake2.qcommon.types as qtypes
import miniquake2.renderer.constants as rc

// Opaque model_s/image_s replacements. A registration generation makes the
// lifetime rule from ref.h observable without exposing native pointers.
struct ResourceHandle
  kind
  id
  name
  generation
end struct

struct Entity
  model
  angles
  origin
  frame
  oldOrigin
  oldFrame
  backLerp
  skinNum
  lightStyle
  alpha
  skin
  flags
end struct

struct DLight
  origin
  color
  intensity
end struct

struct Particle
  origin
  color
  alpha
end struct

struct LightStyle
  rgb
  white
end struct

struct RefDef
  x
  y
  width
  height
  fovX
  fovY
  viewOrigin
  viewAngles
  blend
  time
  rdFlags
  areaBits
  lightStyles
  numEntities
  entities
  numDLights
  dLights
  numParticles
  particles
end struct

struct PicSize
  width
  height
end struct

struct VideoModeInfo
  valid
  width
  height
end struct

struct CVar
  name
  stringValue
  numericValue
  flags
end struct

// refimport_t. Varargs messages become one already-formatted string, file
// output pointers become managed bytes, and video out-parameters become a
// VideoModeInfo return value.
struct RefImport
  sysError
  cmdAddCommand
  cmdRemoveCommand
  cmdArgc
  cmdArgv
  cmdExecuteText
  conPrintf
  fsLoadFile
  fsFreeFile
  fsGameDir
  cvarGet
  cvarSet
  cvarSetValue
  vidGetModeInfo
  vidMenuInit
  vidNewWindow
end struct

// refexport_t. DrawGetPicSize returns PicSize instead of mutating two C
// pointers. Every other field maps one-for-one to the v3 table in ref.h.
struct RefExport
  apiVersion
  Init
  Shutdown
  BeginRegistration
  RegisterModel
  RegisterSkin
  RegisterPic
  SetSky
  EndRegistration
  RenderFrame
  DrawGetPicSize
  DrawPic
  DrawStretchPic
  DrawChar
  DrawTileClear
  DrawFill
  DrawFadeScreen
  DrawStretchRaw
  CinematicSetPalette
  BeginFrame
  EndFrame
  AppActivate
end struct

struct RendererBinding
  state
  exports
end struct

function entity(model, angles, origin, frame, oldOrigin, oldFrame, backLerp, skinNum, lightStyle, alpha, skin, flags)
  return Entity(model, angles, origin, frame, oldOrigin, oldFrame, backLerp, skinNum, lightStyle, alpha, skin, flags)
end function

function emptyEntity()
  return Entity(void, qtypes.zeroVec3(), qtypes.zeroVec3(), 0, qtypes.zeroVec3(), 0, 0.0, 0, 0, 1.0, void, 0)
end function

function dLight(origin, color, intensity)
  return DLight(origin, color, intensity)
end function

function particle(origin, color, alpha)
  return Particle(origin, color, alpha)
end function

function lightStyle(red, green, blue)
  // V_AddLightStyle stores the RGB sum in white; ref_gl uses it solely as a
  // compact change key for cached lightmaps.
  return LightStyle([red, green, blue], red + green + blue)
end function

function defaultLightStyles()
  styles = array(rc.MAX_LIGHTSTYLES)
  index = 0
  while index < rc.MAX_LIGHTSTYLES
    styles[index] = lightStyle(1.0, 1.0, 1.0)
    index = index + 1
  end while
  return styles
end function

function refDef(x, y, width, height, fovX, fovY, viewOrigin, viewAngles, blend, time, rdFlags, areaBits, lightStyles, entities, dLights, particles)
  return RefDef(x, y, width, height, fovX, fovY, viewOrigin, viewAngles, blend, time, rdFlags, areaBits, lightStyles, len(entities), entities, len(dLights), dLights, len(particles), particles)
end function

function defaultRefDef(width, height)
  zero = qtypes.zeroVec3()
  return refDef(0, 0, width, height, 90.0, 73.7398, zero, zero, [0.0, 0.0, 0.0, 0.0], 0.0, 0, void, defaultLightStyles(), [], [], [])
end function
