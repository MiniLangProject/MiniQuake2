//! Provides miniquake2 renderer validation facilities for this project.

/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Renderer API v3 contract validation independent of any graphics backend. */
package miniquake2.renderer.validation

import miniquake2.renderer.constants as rc
import miniquake2.renderer.types as rt

/// Store validation result data.
struct ValidationResult
  /// Stores the valid value associated with validation result.
  valid
  /// Stores the code value associated with validation result.
  code
  /// Stores the message value associated with validation result.
  message
end struct

/// Report whether valid.
function valid()
  return ValidationResult(true, "ok", "")
end function

/// Return the invalid value.
/// @param code code value consumed by this operation.
/// @param message Human-readable message associated with the operation.
function invalid(code, message)
  return ValidationResult(false, code, message)
end function

/// Performs the numeric operation for the miniquake2 renderer validation module.
/// @param value Value consumed or transformed by the operation.
function numeric(value)
  kind = typeof(value)
  return kind == "int" or kind == "float"
end function

/// Validate vec 3.
/// @param value Value consumed or transformed by the operation.
/// @param fieldName fieldName value consumed by this operation.
function validateVec3(value, fieldName)
  if value is void then return invalid("vec3.void", fieldName + " is void") end if
  if typeof(value) != "struct" then return invalid("vec3.type", fieldName + " must be a Vec3 record") end if
  if not numeric(value.x) or not numeric(value.y) or not numeric(value.z) then
    return invalid("vec3.component", fieldName + " has a non-numeric component")
  end if
  return valid()
end function

/// Validate entity.
/// @param value Value consumed or transformed by the operation.
/// @param index Zero-based index of the affected item.
function validateEntity(value, index)
  if typeof(value) != "struct" then return invalid("entity.type", "entities[" + index + "] must be an Entity record") end if
  checked = validateVec3(value.angles, "entities[" + index + "].angles")
  if not checked.valid then return checked end if
  checked = validateVec3(value.origin, "entities[" + index + "].origin")
  if not checked.valid then return checked end if
  checked = validateVec3(value.oldOrigin, "entities[" + index + "].oldOrigin")
  if not checked.valid then return checked end if
  if value.backLerp < 0.0 or value.backLerp > 1.0 then return invalid("entity.backlerp", "entity backLerp must be in [0,1]") end if
  if value.alpha < 0.0 or value.alpha > 1.0 then return invalid("entity.alpha", "entity alpha must be in [0,1]") end if
  if typeof(value.frame) != "int" or typeof(value.oldFrame) != "int" or typeof(value.skinNum) != "int" or typeof(value.lightStyle) != "int" or typeof(value.flags) != "int" then
    return invalid("entity.integer", "entity frame, skin, light style and flags fields must be integers")
  end if
  return valid()
end function

/// Validate d light.
/// @param value Value consumed or transformed by the operation.
/// @param index Zero-based index of the affected item.
function validateDLight(value, index)
  if typeof(value) != "struct" then return invalid("dlight.type", "dLights[" + index + "] must be a DLight record") end if
  checked = validateVec3(value.origin, "dLights[" + index + "].origin")
  if not checked.valid then return checked end if
  checked = validateVec3(value.color, "dLights[" + index + "].color")
  if not checked.valid then return checked end if
  return valid()
end function

/// Validate particle.
/// @param value Value consumed or transformed by the operation.
/// @param index Zero-based index of the affected item.
function validateParticle(value, index)
  if typeof(value) != "struct" then return invalid("particle.type", "particles[" + index + "] must be a Particle record") end if
  checked = validateVec3(value.origin, "particles[" + index + "].origin")
  if not checked.valid then return checked end if
  if typeof(value.color) != "int" or value.color < 0 or value.color > 255 then return invalid("particle.color", "particle palette index must be an integer in [0,255]") end if
  if value.alpha < 0.0 or value.alpha > 1.0 then return invalid("particle.alpha", "particle alpha must be in [0,1]") end if
  return valid()
end function

/// Validate light style.
/// @param value Value consumed or transformed by the operation.
/// @param index Zero-based index of the affected item.
function validateLightStyle(value, index)
  if typeof(value) != "struct" then return invalid("lightstyle.type", "lightStyles[" + index + "] must be a LightStyle record") end if
  if typeof(value.rgb) != "array" or len(value.rgb) != 3 then return invalid("lightstyle.rgb", "lightStyles[" + index + "].rgb must contain three values") end if
  component = 0
  while component < 3
    if not numeric(value.rgb[component]) or value.rgb[component] < 0.0 or
        value.rgb[component] > 25.0 / 12.0 then
      return invalid("lightstyle.range", "light style RGB must be in [0,25/12]")
    end if
    component = component + 1
  end while
  difference = value.white - (value.rgb[0] + value.rgb[1] + value.rgb[2])
  if difference < 0.0 then difference = -difference end if
  if difference > 0.00001 then return invalid("lightstyle.white",
    "light style white must equal its RGB sum") end if
  return valid()
end function

/// Validate ref def.
/// @param frame frame value consumed by this operation.
function validateRefDef(frame)
  // Keep validate ref def phases explicit: validate inputs, update owned state, then publish the result.
  if frame is void then return invalid("refdef.void", "refdef is void") end if
  if typeof(frame) != "struct" then return invalid("refdef.type", "refdef must be a RefDef record") end if
  if typeof(frame.x) != "int" or typeof(frame.y) != "int" or typeof(frame.width) != "int" or typeof(frame.height) != "int" then return invalid("refdef.viewport.type", "viewport fields must be integers") end if
  if not numeric(frame.fovX) or not numeric(frame.fovY) or not numeric(frame.time) then return invalid("refdef.numeric", "FOV and time fields must be numeric") end if
  if frame.width <= 0 or frame.height <= 0 then return invalid("refdef.viewport", "viewport dimensions must be positive") end if
  if frame.fovX <= 0.0 or frame.fovX >= 180.0 or frame.fovY <= 0.0 or frame.fovY >= 180.0 then
    return invalid("refdef.fov", "field of view must be between zero and 180 degrees")
  end if
  checked = validateVec3(frame.viewOrigin, "viewOrigin")
  if not checked.valid then return checked end if
  checked = validateVec3(frame.viewAngles, "viewAngles")
  if not checked.valid then return checked end if
  if typeof(frame.blend) != "array" or len(frame.blend) != 4 then return invalid("refdef.blend", "blend must contain RGBA") end if
  blendIndex = 0
  while blendIndex < 4
    if frame.blend[blendIndex] < 0.0 or frame.blend[blendIndex] > 1.0 then return invalid("refdef.blend.range", "blend components must be in [0,1]") end if
    blendIndex = blendIndex + 1
  end while
  if frame.areaBits is not void and typeof(frame.areaBits) != "bytes" then return invalid("refdef.areabits", "areaBits must be bytes or void") end if
  if typeof(frame.entities) != "array" or frame.numEntities != len(frame.entities) then return invalid("refdef.entities.count", "numEntities does not match entities") end if
  if typeof(frame.dLights) != "array" or frame.numDLights != len(frame.dLights) then return invalid("refdef.dlights.count", "numDLights does not match dLights") end if
  if typeof(frame.particles) != "array" or frame.numParticles != len(frame.particles) then return invalid("refdef.particles.count", "numParticles does not match particles") end if
  if frame.numEntities < 0 or frame.numEntities > rc.MAX_ENTITIES then return invalid("refdef.entities.limit", "entity limit exceeded") end if
  if frame.numDLights < 0 or frame.numDLights > rc.MAX_DLIGHTS then return invalid("refdef.dlights.limit", "dynamic light limit exceeded") end if
  if frame.numParticles < 0 or frame.numParticles > rc.MAX_PARTICLES then return invalid("refdef.particles.limit", "particle limit exceeded") end if
  if typeof(frame.lightStyles) != "array" or len(frame.lightStyles) != rc.MAX_LIGHTSTYLES then return invalid("refdef.lightstyles.count", "exactly 256 light styles are required") end if
  index = 0
  while index < frame.numEntities
    checked = validateEntity(frame.entities[index], index)
    if not checked.valid then return checked end if
    index = index + 1
  end while
  index = 0
  while index < frame.numDLights
    checked = validateDLight(frame.dLights[index], index)
    if not checked.valid then return checked end if
    index = index + 1
  end while
  index = 0
  while index < frame.numParticles
    checked = validateParticle(frame.particles[index], index)
    if not checked.valid then return checked end if
    index = index + 1
  end while
  index = 0
  while index < rc.MAX_LIGHTSTYLES
    checked = validateLightStyle(frame.lightStyles[index], index)
    if not checked.valid then return checked end if
    index = index + 1
  end while
  return valid()
end function

/// Require function.
/// @param value Value consumed or transformed by the operation.
/// @param fieldName fieldName value consumed by this operation.
function requireFunction(value, fieldName)
  if typeof(value) != "function" then return invalid("api.function", fieldName + " must be a function value") end if
  return valid()
end function

/// Validate ref import.
/// @param imports imports value consumed by this operation.
function validateRefImport(imports)
  if imports is void then return invalid("import.void", "refimport_t is void") end if
  if typeof(imports) != "struct" then return invalid("import.type", "refimport_t must be a RefImport record") end if
  entries = [
    ["Sys_Error", imports.sysError], ["Cmd_AddCommand", imports.cmdAddCommand],
    ["Cmd_RemoveCommand", imports.cmdRemoveCommand], ["Cmd_Argc", imports.cmdArgc],
    ["Cmd_Argv", imports.cmdArgv], ["Cmd_ExecuteText", imports.cmdExecuteText],
    ["Con_Printf", imports.conPrintf], ["FS_LoadFile", imports.fsLoadFile],
    ["FS_FreeFile", imports.fsFreeFile], ["FS_Gamedir", imports.fsGameDir],
    ["Cvar_Get", imports.cvarGet], ["Cvar_Set", imports.cvarSet],
    ["Cvar_SetValue", imports.cvarSetValue], ["Vid_GetModeInfo", imports.vidGetModeInfo],
    ["Vid_MenuInit", imports.vidMenuInit], ["Vid_NewWindow", imports.vidNewWindow],
  ]
  index = 0
  while index < len(entries)
    checked = requireFunction(entries[index][1], entries[index][0])
    if not checked.valid then return checked end if
    index = index + 1
  end while
  return valid()
end function

/// Validate ref export.
/// @param exports exports value consumed by this operation.
function validateRefExport(exports)
  if exports is void then return invalid("export.void", "refexport_t is void") end if
  if typeof(exports) != "struct" then return invalid("export.type", "refexport_t must be a RefExport record") end if
  if exports.apiVersion != rc.API_VERSION then return invalid("export.version", "renderer API version must be 3") end if
  entries = [
    ["Init", exports.Init], ["Shutdown", exports.Shutdown],
    ["BeginRegistration", exports.BeginRegistration], ["RegisterModel", exports.RegisterModel],
    ["RegisterSkin", exports.RegisterSkin], ["RegisterPic", exports.RegisterPic],
    ["SetSky", exports.SetSky], ["EndRegistration", exports.EndRegistration],
    ["RenderFrame", exports.RenderFrame], ["DrawGetPicSize", exports.DrawGetPicSize],
    ["DrawPic", exports.DrawPic], ["DrawStretchPic", exports.DrawStretchPic],
    ["DrawChar", exports.DrawChar], ["DrawTileClear", exports.DrawTileClear],
    ["DrawFill", exports.DrawFill], ["DrawFadeScreen", exports.DrawFadeScreen],
    ["DrawStretchRaw", exports.DrawStretchRaw], ["CinematicSetPalette", exports.CinematicSetPalette],
    ["BeginFrame", exports.BeginFrame], ["EndFrame", exports.EndFrame],
    ["AppActivate", exports.AppActivate],
  ]
  index = 0
  while index < len(entries)
    checked = requireFunction(entries[index][1], entries[index][0])
    if not checked.valid then return checked end if
    index = index + 1
  end while
  return valid()
end function
