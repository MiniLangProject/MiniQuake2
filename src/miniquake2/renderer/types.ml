//! Provides miniquake2 renderer types facilities for this project.

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

/// Opaque model_s/image_s replacements. A registration generation makes the
/// lifetime rule from ref.h observable without exposing native pointers.
struct ResourceHandle
  /// Stores the kind value associated with resource handle.
  kind
  /// Stores the id value associated with resource handle.
  id
  /// Stores the name value associated with resource handle.
  name
  /// Stores the generation value associated with resource handle.
  generation
end struct

/// Store entity data.
struct Entity
  /// Stores the model value associated with entity.
  model
  /// Stores the angles value associated with entity.
  angles
  /// Stores the origin value associated with entity.
  origin
  /// Stores the frame value associated with entity.
  frame
  /// Stores the old origin value associated with entity.
  oldOrigin
  /// Stores the old frame value associated with entity.
  oldFrame
  /// Stores the back lerp value associated with entity.
  backLerp
  /// Stores the skin num value associated with entity.
  skinNum
  /// Stores the light style value associated with entity.
  lightStyle
  /// Stores the alpha value associated with entity.
  alpha
  /// Stores the skin value associated with entity.
  skin
  /// Stores the flags value associated with entity.
  flags
end struct

/// Store d light data.
struct DLight
  /// Stores the origin value associated with dlight.
  origin
  /// Stores the color value associated with dlight.
  color
  /// Stores the intensity value associated with dlight.
  intensity
end struct

/// Store particle data.
struct Particle
  /// Stores the origin value associated with particle.
  origin
  /// Stores the color value associated with particle.
  color
  /// Stores the alpha value associated with particle.
  alpha
end struct

/// Store light style data.
struct LightStyle
  /// Stores the rgb value associated with light style.
  rgb
  /// Stores the white value associated with light style.
  white
end struct

/// Store ref def data.
struct RefDef
  /// Stores the x value associated with ref def.
  x
  /// Stores the y value associated with ref def.
  y
  /// Stores the width value associated with ref def.
  width
  /// Stores the height value associated with ref def.
  height
  /// Stores the fov x value associated with ref def.
  fovX
  /// Stores the fov y value associated with ref def.
  fovY
  /// Stores the view origin value associated with ref def.
  viewOrigin
  /// Stores the view angles value associated with ref def.
  viewAngles
  /// Stores the blend value associated with ref def.
  blend
  /// Stores the time value associated with ref def.
  time
  /// Stores the rd flags value associated with ref def.
  rdFlags
  /// Stores the area bits value associated with ref def.
  areaBits
  /// Stores the light styles value associated with ref def.
  lightStyles
  /// Stores the num entities value associated with ref def.
  numEntities
  /// Stores the entities value associated with ref def.
  entities
  /// Stores the num dlights value associated with ref def.
  numDLights
  /// Stores the d lights value associated with ref def.
  dLights
  /// Stores the num particles value associated with ref def.
  numParticles
  /// Stores the particles value associated with ref def.
  particles
end struct

/// Store pic size data.
struct PicSize
  /// Stores the width value associated with pic size.
  width
  /// Stores the height value associated with pic size.
  height
end struct

/// Store video mode info data.
struct VideoModeInfo
  /// Stores the valid value associated with video mode info.
  valid
  /// Stores the width value associated with video mode info.
  width
  /// Stores the height value associated with video mode info.
  height
end struct

/// Store c var data.
struct CVar
  /// Stores the renderer-facing console-variable name.
  name
  /// Stores the string value value associated with cvar.
  stringValue
  /// Stores the numeric value value associated with cvar.
  numericValue
  /// Stores renderer-specific behavior flags for the variable.
  flags
end struct

/// refimport_t. Varargs messages become one already-formatted string, file
/// output pointers become managed bytes, and video out-parameters become a
/// VideoModeInfo return value.
struct RefImport
  /// Stores the sys error value associated with ref import.
  sysError
  /// Stores the cmd add command value associated with ref import.
  cmdAddCommand
  /// Stores the cmd remove command value associated with ref import.
  cmdRemoveCommand
  /// Stores the cmd argc value associated with ref import.
  cmdArgc
  /// Stores the cmd argv value associated with ref import.
  cmdArgv
  /// Stores the cmd execute text value associated with ref import.
  cmdExecuteText
  /// Stores the con printf value associated with ref import.
  conPrintf
  /// Stores the fs load file value associated with ref import.
  fsLoadFile
  /// Stores the fs free file value associated with ref import.
  fsFreeFile
  /// Stores the fs game dir value associated with ref import.
  fsGameDir
  /// Stores the cvar get value associated with ref import.
  cvarGet
  /// Stores the cvar set value associated with ref import.
  cvarSet
  /// Stores the cvar set value value associated with ref import.
  cvarSetValue
  /// Stores the vid get mode info value associated with ref import.
  vidGetModeInfo
  /// Stores the vid menu init value associated with ref import.
  vidMenuInit
  /// Stores the vid new window value associated with ref import.
  vidNewWindow
end struct

/// refexport_t. DrawGetPicSize returns PicSize instead of mutating two C
/// pointers. Every other field maps one-for-one to the v3 table in ref.h.
struct RefExport
  /// Stores the api version value associated with ref export.
  apiVersion
  /// Stores the init value associated with ref export.
  Init
  /// Stores the shutdown value associated with ref export.
  Shutdown
  /// Stores the begin registration value associated with ref export.
  BeginRegistration
  /// Stores the register model value associated with ref export.
  RegisterModel
  /// Stores the register skin value associated with ref export.
  RegisterSkin
  /// Stores the register pic value associated with ref export.
  RegisterPic
  /// Stores the set sky value associated with ref export.
  SetSky
  /// Stores the end registration value associated with ref export.
  EndRegistration
  /// Stores the render frame value associated with ref export.
  RenderFrame
  /// Stores the draw get pic size value associated with ref export.
  DrawGetPicSize
  /// Stores the draw pic value associated with ref export.
  DrawPic
  /// Stores the draw stretch pic value associated with ref export.
  DrawStretchPic
  /// Stores the draw char value associated with ref export.
  DrawChar
  /// Stores the draw tile clear value associated with ref export.
  DrawTileClear
  /// Stores the draw fill value associated with ref export.
  DrawFill
  /// Stores the draw fade screen value associated with ref export.
  DrawFadeScreen
  /// Stores the draw stretch raw value associated with ref export.
  DrawStretchRaw
  /// Stores the cinematic set palette value associated with ref export.
  CinematicSetPalette
  /// Stores the begin frame value associated with ref export.
  BeginFrame
  /// Stores the end frame value associated with ref export.
  EndFrame
  /// Stores the app activate value associated with ref export.
  AppActivate
end struct

/// Store renderer binding data.
struct RendererBinding
  /// Stores the state value associated with renderer binding.
  state
  /// Stores the exports value associated with renderer binding.
  exports
end struct

/// Return the entity value.
/// @param model model value consumed by this operation.
/// @param angles angles value consumed by this operation.
/// @param origin origin value consumed by this operation.
/// @param frame frame value consumed by this operation.
/// @param oldOrigin oldOrigin value consumed by this operation.
/// @param oldFrame oldFrame value consumed by this operation.
/// @param backLerp backLerp value consumed by this operation.
/// @param skinNum skinNum value consumed by this operation.
/// @param lightStyle lightStyle value consumed by this operation.
/// @param alpha alpha value consumed by this operation.
/// @param skin skin value consumed by this operation.
/// @param flags Bit flags controlling the operation.
function entity(model, angles, origin, frame, oldOrigin, oldFrame, backLerp, skinNum, lightStyle, alpha, skin, flags)
  return Entity(model, angles, origin, frame, oldOrigin, oldFrame, backLerp, skinNum, lightStyle, alpha, skin, flags)
end function

/// Report whether empty entity.
function emptyEntity()
  return Entity(void, qtypes.zeroVec3(), qtypes.zeroVec3(), 0, qtypes.zeroVec3(), 0, 0.0, 0, 0, 1.0, void, 0)
end function

/// Return the d light value.
/// @param origin origin value consumed by this operation.
/// @param color color value consumed by this operation.
/// @param intensity intensity value consumed by this operation.
function dLight(origin, color, intensity)
  return DLight(origin, color, intensity)
end function

/// Return the particle value.
/// @param origin origin value consumed by this operation.
/// @param color color value consumed by this operation.
/// @param alpha alpha value consumed by this operation.
function particle(origin, color, alpha)
  return Particle(origin, color, alpha)
end function

/// Return the light style value.
/// @param red red value consumed by this operation.
/// @param green green value consumed by this operation.
/// @param blue blue value consumed by this operation.
function lightStyle(red, green, blue)
  // V_AddLightStyle stores the RGB sum in white; ref_gl uses it solely as a
  // compact change key for cached lightmaps.
  return LightStyle([red, green, blue], red + green + blue)
end function

/// Return the default light styles value.
function defaultLightStyles()
  styles = array(rc.MAX_LIGHTSTYLES)
  index = 0
  while index < rc.MAX_LIGHTSTYLES
    styles[index] = lightStyle(1.0, 1.0, 1.0)
    index = index + 1
  end while
  return styles
end function

/// Return the ref def value.
/// @param x Horizontal coordinate used by the operation.
/// @param y Vertical coordinate used by the operation.
/// @param width Width in the coordinate or storage units used by the caller.
/// @param height Height in the coordinate or storage units used by the caller.
/// @param fovX fovX value consumed by this operation.
/// @param fovY fovY value consumed by this operation.
/// @param viewOrigin viewOrigin value consumed by this operation.
/// @param viewAngles viewAngles value consumed by this operation.
/// @param blend blend value consumed by this operation.
/// @param time time value consumed by this operation.
/// @param rdFlags rdFlags value consumed by this operation.
/// @param areaBits areaBits value consumed by this operation.
/// @param lightStyles lightStyles value consumed by this operation.
/// @param entities entities value consumed by this operation.
/// @param dLights dLights value consumed by this operation.
/// @param particles particles value consumed by this operation.
function refDef(x, y, width, height, fovX, fovY, viewOrigin, viewAngles, blend, time, rdFlags, areaBits, lightStyles, entities, dLights, particles)
  return RefDef(x, y, width, height, fovX, fovY, viewOrigin, viewAngles, blend, time, rdFlags, areaBits, lightStyles, len(entities), entities, len(dLights), dLights, len(particles), particles)
end function

/// Return the default ref def value.
/// @param width Width in the coordinate or storage units used by the caller.
/// @param height Height in the coordinate or storage units used by the caller.
function defaultRefDef(width, height)
  zero = qtypes.zeroVec3()
  return refDef(0, 0, width, height, 90.0, 73.7398, zero, zero, [0.0, 0.0, 0.0, 0.0], 0.0, 0, void, defaultLightStyles(), [], [], [])
end function
