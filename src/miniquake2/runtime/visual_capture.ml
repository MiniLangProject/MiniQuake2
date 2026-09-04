//! Provides miniquake2 runtime visual capture facilities for this project.

/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later

Fixed-camera retail renderer capture. This intentionally stays outside the
interactive application loop: no input, wall clock, audio or network state can
change the rendered frame. Retail files are read at runtime and never copied
into the source tree.
*/
package miniquake2.runtime.visual_capture

import std.array as retailcapturearray
import miniquake2.qcommon.filesystem as retailcapturefs
import miniquake2.qcommon.text as retailcapturetext
import miniquake2.qcommon.types as retailcaptureqtypes
import miniquake2.format.bsp as retailcapturebsp
import miniquake2.game.base.entity_parser as retailcaptureentities
import miniquake2.platform.window as retailcapturewindow
import miniquake2.renderer.assets as retailcaptureassets
import miniquake2.renderer.constants as retailcapturerc
import miniquake2.renderer.types as retailcapturert
import miniquake2.renderer.opengl as retailcapturegl
import miniquake2.renderer.capture as retailcaptureimage
import miniquake2.physics.vector as retailcapturevector

/// Store retail capture file system slot data.
struct RetailCaptureFileSystemSlot
  /// Stores the filesystem value associated with retail capture file system slot.
  filesystem
end struct

/// Store retail capture file imports data.
struct RetailCaptureFileImports
  /// Stores the fs load file value associated with retail capture file imports.
  fsLoadFile
end struct

/// Store retail capture result data.
struct RetailCaptureResult
  /// Stores the map name value associated with retail capture result.
  mapName
  /// Stores the map path value associated with retail capture result.
  mapPath
  /// Stores the output path value associated with retail capture result.
  outputPath
  /// Stores the width value associated with retail capture result.
  width
  /// Stores the height value associated with retail capture result.
  height
  /// Stores the rendered frames value associated with retail capture result.
  renderedFrames
  /// Stores the render time value associated with retail capture result.
  renderTime
  /// Stores the view origin value associated with retail capture result.
  viewOrigin
  /// Stores the view angles value associated with retail capture result.
  viewAngles
  /// Stores the rgba checksum value associated with retail capture result.
  rgbaChecksum
  /// Stores the visible surfaces value associated with retail capture result.
  visibleSurfaces
  /// Stores the culled surfaces value associated with retail capture result.
  culledSurfaces
  /// Stores the view cluster value associated with retail capture result.
  viewCluster
  /// Stores the warp surfaces value associated with retail capture result.
  warpSurfaces
  /// Stores the transparent surfaces value associated with retail capture result.
  transparentSurfaces
  /// Stores the sky surfaces value associated with retail capture result.
  skySurfaces
  /// Stores the inline brush entities value associated with retail capture result.
  inlineBrushEntities
  /// Stores the md2 entities value associated with retail capture result.
  md2Entities
  /// Stores the shadow entities value associated with retail capture result.
  shadowEntities
  /// Stores the shadow light height value associated with retail capture result.
  shadowLightHeight
end struct

/// Stores module-wide retail capture file system slot state for the miniquake2 runtime visual capture module.
retailCaptureFileSystemSlot = RetailCaptureFileSystemSlot(void)

/// Capture retail load file.
/// @param path Path of the file or directory used by the operation.
function retailCaptureLoadFile(path)
  slot = retailCaptureFileSystemSlot
  filesystem = slot.filesystem
  if filesystem is void then return error(9940, "retail capture filesystem is not active") end if
  return retailcapturefs.readFile(filesystem, path)
end function

/// Capture retail ends with.
/// @param value Value consumed or transformed by the operation.
/// @param suffix suffix value consumed by this operation.
function retailCaptureEndsWith(value, suffix)
  left = bytes(retailcapturetext.lower(value)); right = bytes(retailcapturetext.lower(suffix))
  leftLength = len(left); rightLength = len(right)
  if rightLength > leftLength then return false end if
  index = 0
  while index < rightLength
    if left[leftLength - rightLength + index] != right[index] then return false end if
    index = index + 1
  end while
  return true
end function

/// Capture retail map path.
/// @param name Name of the affected item.
function retailCaptureMapPath(name)
  if typeof(name) != "string" or name == "" then return error(9941, "retail capture map name required") end if
  result = name
  lower = retailcapturetext.lower(result)
  if not retailcapturetext.startsWith(lower, "maps/") then result = "maps/" + result end if
  if not retailCaptureEndsWith(result, ".bsp") then result = result + ".bsp" end if
  return result
end function

/// Report whether retail capture is inline model.
/// @param name Name of the affected item.
function retailCaptureIsInlineModel(name)
  if typeof(name) != "string" then return false end if
  encoded = bytes(name)
  return len(encoded) > 1 and encoded[0] == 42
end function

/// Capture retail default camera.
/// @param materialized materialized value consumed by this operation.
function retailCaptureDefaultCamera(materialized)
  originResult = retailcaptureqtypes.Vec3(0.0, 0.0, 32.0)
  anglesResult = retailcaptureqtypes.zeroVec3()
  for each component in materialized
    if component.className == "info_player_start" then
      origin = component.origin; angles = component.angles
      originX = origin[0]; originY = origin[1]; originZ = origin[2]
      angleX = angles[0]; angleY = angles[1]; angleZ = angles[2]
      originResult = retailcaptureqtypes.Vec3(originX, originY, originZ + 22.0)
      anglesResult = retailcaptureqtypes.Vec3(angleX, angleY, angleZ)
      break
    end if
  end for
  result = array(2)
  result[0] = originResult; result[1] = anglesResult
  return result
end function

/// Capture retail inline entities.
/// @param renderer renderer value consumed by this operation.
/// @param materialized materialized value consumed by this operation.
/// @param fileImports fileImports value consumed by this operation.
/// @param output Output collection or buffer populated by the operation.
/// @param count Number of items or units to process.
function retailCaptureInlineEntities(renderer, materialized, fileImports, output, count)
  index = 0
  while index < len(materialized) and count < retailcapturerc.MAX_ENTITIES
    component = materialized[index]
    modelName = component.model
    if retailCaptureIsInlineModel(modelName) then
      modelAsset = retailcaptureassets.registerModel(renderer.state.assets, fileImports, modelName)
      sourceOrigin = component.origin; sourceAngles = component.angles
      originX = sourceOrigin[0]; originY = sourceOrigin[1]; originZ = sourceOrigin[2]
      angleX = sourceAngles[0]; angleY = sourceAngles[1]; angleZ = sourceAngles[2]
      entity = retailcapturert.emptyEntity()
      entity.model = modelAsset.handle
      entity.origin = retailcaptureqtypes.Vec3(originX, originY, originZ)
      entity.oldOrigin = retailcaptureqtypes.Vec3(originX, originY, originZ)
      entity.angles = retailcaptureqtypes.Vec3(angleX, angleY, angleZ)
      output[count] = entity
      count = count + 1
    end if
    index = index + 1
  end while
  return count
end function

/// Capture retail md 2 entity.
/// @param renderer renderer value consumed by this operation.
/// @param modelName modelName value consumed by this operation.
/// @param viewOrigin viewOrigin value consumed by this operation.
/// @param viewAngles viewAngles value consumed by this operation.
function retailCaptureMd2Entity(renderer, modelName, viewOrigin, viewAngles)
  handle = retailcapturegl.registerMd2Model(renderer, modelName, retailCaptureLoadFile)
  axes = retailcapturevector.angleVectors(viewAngles)
  forward = axes[0]
  forwardX = forward.x; forwardY = forward.y; forwardZ = forward.z
  viewX = viewOrigin.x; viewY = viewOrigin.y; viewZ = viewOrigin.z
  yaw = viewAngles.y
  entity = retailcapturert.emptyEntity()
  entity.model = handle
  // A repeatable renderer fixture, not a gameplay spawn: one model 96 units
  // ahead, with its feet at player-start floor height and facing the camera.
  entity.origin = retailcaptureqtypes.Vec3(
    viewX + forwardX * 96.0,
    viewY + forwardY * 96.0,
    viewZ - 22.0 + forwardZ * 96.0
  )
  entity.oldOrigin = entity.origin
  entity.angles = retailcaptureqtypes.Vec3(0.0, yaw + 180.0, 0.0)
  entity.flags = retailcapturerc.RF_FULLBRIGHT
  return entity
end function

/// cameraOrigin/cameraAngles may be void to select the first info_player_start.
/// Capture occurs before EndFrame's swap, after the final deterministic time.
/// @param baseDirectory baseDirectory value consumed by this operation.
/// @param mapName mapName value consumed by this operation.
/// @param outputPath Path associated with output.
/// @param width Width in the coordinate or storage units used by the caller.
/// @param height Height in the coordinate or storage units used by the caller.
/// @param renderedFrames renderedFrames value consumed by this operation.
/// @param modelName modelName value consumed by this operation.
/// @param includeInlineBrushModels includeInlineBrushModels value consumed by this operation.
/// @param cameraOrigin cameraOrigin value consumed by this operation.
/// @param cameraAngles cameraAngles value consumed by this operation.
/// @param shadowsEnabled shadowsEnabled value consumed by this operation.
function captureRetailScene(baseDirectory, mapName, outputPath, width, height,
    renderedFrames, modelName, includeInlineBrushModels, cameraOrigin,
    cameraAngles, shadowsEnabled)
  if typeof(baseDirectory) != "string" or baseDirectory == "" then return error(9942, "retail capture root required") end if
  if typeof(outputPath) != "string" or outputPath == "" then return error(9943, "retail capture output path required") end if
  if typeof(width) != "int" or typeof(height) != "int" or width < 64 or height < 64 or width > 4096 or height > 4096 then
    return error(9944, "retail capture dimensions outside [64,4096]")
  end if
  if typeof(renderedFrames) != "int" or renderedFrames < 1 or renderedFrames > 1000 then
    return error(9945, "retail capture frame count outside [1,1000]")
  end if
  if typeof(modelName) != "string" then return error(9946, "retail capture model name must be text") end if

  filesystem = retailcapturefs.initialize(baseDirectory, "")
  filesystemSlot = retailCaptureFileSystemSlot
  filesystemSlot.filesystem = filesystem
  path = retailCaptureMapPath(mapName)
  map = retailcapturebsp.parse(retailcapturefs.readFile(filesystem, path), path)
  materialized = retailcaptureentities.parseMaterializedEntities(map.entityText)
  if cameraOrigin is void or cameraAngles is void then
    defaultCamera = retailCaptureDefaultCamera(materialized)
    cameraOrigin = defaultCamera[0]; cameraAngles = defaultCamera[1]
  end if
  if typeof(cameraOrigin) != "struct" or typeof(cameraAngles) != "struct" then
    filesystemSlot.filesystem = void
    return error(9947, "retail capture camera requires Vec3 values")
  end if

  window = retailcapturewindow.create("MiniQuake2 visual capture - " + mapName, width, height, false)
  renderer = retailcapturegl.createOpenGlRenderer(true)
  retailcapturegl.setShadows(renderer, shadowsEnabled)
  renderer.exports.Init(void, void)
  renderer.exports.BeginRegistration(path)
  retailcapturegl.adoptClassicMapModel(renderer, map, path)
  world = retailcapturegl.prepareClassicWorld(renderer, map, retailCaptureLoadFile,
    retailcapturert.defaultLightStyles(), 0, 1.0)
  fileImports = RetailCaptureFileImports(retailCaptureLoadFile)
  entityCapacity = len(materialized) + 1
  if entityCapacity > retailcapturerc.MAX_ENTITIES then entityCapacity = retailcapturerc.MAX_ENTITIES end if
  if entityCapacity < 1 then entityCapacity = 1 end if
  entityBuffer = array(entityCapacity)
  entityCount = 0
  // Reserve the first RefDef slot for the requested MD2 fixture. Large retail
  // maps can own more than MAX_ENTITIES inline models, which must not silently
  // crowd the explicit model coverage out of a visual gate.
  md2Count = 0
  if modelName != "" then
    entityBuffer[entityCount] = retailCaptureMd2Entity(renderer, modelName, cameraOrigin, cameraAngles)
    entityCount = entityCount + 1
    md2Count = 1
  end if
  if includeInlineBrushModels then
    entityCount = retailCaptureInlineEntities(renderer, materialized, fileImports, entityBuffer, entityCount)
  end if
  renderer.exports.EndRegistration()

  frame = retailcapturert.defaultRefDef(window.width, window.height)
  frame.viewOrigin = cameraOrigin
  frame.viewAngles = cameraAngles
  frame.entities = retailcapturearray.slice(entityBuffer, 0, entityCount)
  frame.numEntities = entityCount
  captured = void
  lastStats = void
  frameIndex = 0
  while frameIndex < renderedFrames
    frame.time = frameIndex * 0.1
    renderer.exports.BeginFrame(0.0)
    lastStats = retailcapturegl.submitClassicWorld(renderer, world, frame)
    renderer.exports.RenderFrame(frame)
    if frameIndex == renderedFrames - 1 then
      captured = retailcaptureimage.readOpenGlFrame(window.width, window.height)
    end if
    renderer.exports.EndFrame()
    frameIndex = frameIndex + 1
  end while

  checksum = retailcaptureimage.rgbaChecksum(captured)
  shadowLightHeight = 0.0
  if md2Count > 0 and renderer.state.md2ShadowValid[0] != 0 then
    shadowLightHeight = frame.entities[0].origin.z -
      renderer.state.md2ShadowSpotZ[0]
  end if
  writeResult = try(retailcaptureimage.writeTga(outputPath, captured))
  retailcapturegl.releaseClassicWorld(renderer, world)
  renderer.exports.Shutdown()
  retailcapturewindow.destroy(window)
  filesystemSlot.filesystem = void
  if writeResult is error then return writeResult end if
  return RetailCaptureResult(mapName, path, outputPath, window.width, window.height,
    renderedFrames, (renderedFrames - 1) * 0.1, cameraOrigin, cameraAngles,
    checksum, lastStats.visibleSurfaces, lastStats.culledSurfaces,
    lastStats.viewCluster, lastStats.warpSurfaces, lastStats.transparentSurfaces,
    lastStats.skySurfaces, lastStats.brushEntities, md2Count,
    retailcapturegl.lastShadowEntities(renderer), shadowLightHeight)
end function
