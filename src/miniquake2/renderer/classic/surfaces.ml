//! Provides miniquake2 renderer classic surfaces facilities for this project.

/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* BSP38 face expansion and classic 16-unit lightmap extents. */
package miniquake2.renderer.classic.surfaces

import std.math as smath
import miniquake2.format.types as ft
import miniquake2.qcommon.byteio as qbyteio
import miniquake2.renderer.classic.constants as rclassicconstants
import miniquake2.renderer.classic.types as rclassictypes
import miniquake2.renderer.classic.materials as rclassicmaterials

/// Return the projected value.
/// @param position position value consumed by this operation.
/// @param vector vector value consumed by this operation.
function projected(position, vector)
  return position.x * vector[0] + position.y * vector[1] + position.z * vector[2] + vector[3]
end function

/// Return the face vertex position.
/// @param map map value consumed by this operation.
/// @param face face value consumed by this operation.
/// @param edgeOffset edgeOffset value consumed by this operation.
function faceVertexPosition(map, face, edgeOffset)
  surfaceEdgeIndex = face.firstEdge + edgeOffset
  if surfaceEdgeIndex < 0 or surfaceEdgeIndex >= len(map.surfaceEdges) then return error(9710, "classic surface edge range outside table") end if
  surfaceEdge = map.surfaceEdges[surfaceEdgeIndex]
  edgeIndex = surfaceEdge
  if edgeIndex < 0 then edgeIndex = -edgeIndex end if
  if edgeIndex < 0 or edgeIndex >= len(map.edges) then return error(9711, "classic edge outside table") end if
  edge = map.edges[edgeIndex]
  vertexIndex = edge.vertex0
  if surfaceEdge < 0 then vertexIndex = edge.vertex1 end if
  if vertexIndex < 0 or vertexIndex >= len(map.vertices) then return error(9712, "classic vertex outside table") end if
  return map.vertices[vertexIndex].position
end function

/// Return the surface extents value.
/// @param map map value consumed by this operation.
/// @param face face value consumed by this operation.
/// @param texInfo texInfo value consumed by this operation.
function surfaceExtents(map, face, texInfo)
  if face.numEdges <= 0 then return error(9713, "classic face has no edges") end if
  first = faceVertexPosition(map, face, 0)
  minS = projected(first, texInfo.s); maxS = minS
  minT = projected(first, texInfo.t); maxT = minT
  edgeOffset = 1
  while edgeOffset < face.numEdges
    position = faceVertexPosition(map, face, edgeOffset)
    valueS = projected(position, texInfo.s)
    valueT = projected(position, texInfo.t)
    if valueS < minS then minS = valueS end if
    if valueS > maxS then maxS = valueS end if
    if valueT < minT then minT = valueT end if
    if valueT > maxT then maxT = valueT end if
    edgeOffset = edgeOffset + 1
  end while
  blockMinS = smath.floor(minS / rclassicconstants.LIGHTMAP_SAMPLE_SIZE)
  blockMaxS = smath.ceil(maxS / rclassicconstants.LIGHTMAP_SAMPLE_SIZE)
  blockMinT = smath.floor(minT / rclassicconstants.LIGHTMAP_SAMPLE_SIZE)
  blockMaxT = smath.ceil(maxT / rclassicconstants.LIGHTMAP_SAMPLE_SIZE)
  textureMins = [
    qbyteio.truncInt(blockMinS * rclassicconstants.LIGHTMAP_SAMPLE_SIZE),
    qbyteio.truncInt(blockMinT * rclassicconstants.LIGHTMAP_SAMPLE_SIZE)
  ]
  extents = [
    qbyteio.truncInt((blockMaxS - blockMinS) * rclassicconstants.LIGHTMAP_SAMPLE_SIZE),
    qbyteio.truncInt((blockMaxT - blockMinT) * rclassicconstants.LIGHTMAP_SAMPLE_SIZE)
  ]
  return [textureMins, extents]
end function

/// Map light count.
/// @param styles styles value consumed by this operation.
function lightMapCount(styles)
  count = 0
  while count < rclassicconstants.MAX_LIGHTMAPS and count < len(styles) and styles[count] != 255
    count = count + 1
  end while
  return count
end function

/// Build surface.
/// @param map map value consumed by this operation.
/// @param faceIndex Zero-based index of face.
/// @param images images value consumed by this operation.
/// @param entityFrame entityFrame value consumed by this operation.
function buildSurface(map, faceIndex, images, entityFrame)
  // Keep build surface phases explicit: validate inputs, update owned state, then publish the result.
  if faceIndex < 0 or faceIndex >= len(map.faces) then return error(9714, "classic face outside table") end if
  face = map.faces[faceIndex]
  if face.texInfo < 0 or face.texInfo >= len(map.texInfo) then return error(9715, "classic face texinfo outside table") end if
  if face.planeIndex < 0 or face.planeIndex >= len(map.planes) then return error(9716, "classic face plane outside table") end if
  texInfo = map.texInfo[face.texInfo]
  extentResult = surfaceExtents(map, face, texInfo)
  textureMins = extentResult[0]
  extents = extentResult[1]
  lightWidth = qbyteio.truncInt(extents[0] / rclassicconstants.LIGHTMAP_SAMPLE_SIZE) + 1
  lightHeight = qbyteio.truncInt(extents[1] / rclassicconstants.LIGHTMAP_SAMPLE_SIZE) + 1
  frames = rclassicmaterials.animationImages(map, face.texInfo, images)
  image = rclassicmaterials.animatedImage(frames, entityFrame)
  if image is void then image = rclassictypes.fallbackImage(texInfo.texture) end if

  vertices = []
  edgeOffset = 0
  while edgeOffset < face.numEdges
    position = faceVertexPosition(map, face, edgeOffset)
    rawS = projected(position, texInfo.s)
    rawT = projected(position, texInfo.t)
    baseS = rawS / image.width
    baseT = rawT / image.height
    lightS = (rawS - textureMins[0] + 8.0) / (lightWidth * rclassicconstants.LIGHTMAP_SAMPLE_SIZE)
    lightT = (rawT - textureMins[1] + 8.0) / (lightHeight * rclassicconstants.LIGHTMAP_SAMPLE_SIZE)
    vertices = vertices + [rclassictypes.surfaceVertex(position, baseS, baseT, lightS, lightT)]
    edgeOffset = edgeOffset + 1
  end while

  samples = void
  mapCount = lightMapCount(face.styles)
  sampleBytes = lightWidth * lightHeight * 3 * mapCount
  if face.lightOffset >= 0 then
    if face.lightOffset > len(map.lighting) or sampleBytes > len(map.lighting) - face.lightOffset then return error(9717, "classic light samples outside BSP lighting lump") end if
    samples = slice(map.lighting, face.lightOffset, sampleBytes)
  end if
  cachedLight = array(rclassicconstants.MAX_LIGHTMAPS, -1.0)
  return rclassictypes.ClassicSurface(
    faceIndex, face, map.planes[face.planeIndex], texInfo, image, frames,
    rclassicmaterials.classify(texInfo.flags), rclassicmaterials.alphaForFlags(texInfo.flags),
    textureMins, extents, lightWidth, lightHeight, vertices, samples, face.styles,
    0, bytes(0), cachedLight
  )
end function

/// Build surfaces.
/// @param map map value consumed by this operation.
/// @param images images value consumed by this operation.
/// @param entityFrame entityFrame value consumed by this operation.
function buildSurfaces(map, images, entityFrame)
  // Retail worlds contain thousands of faces.  Fill one exact table instead
  // of repeatedly copying a growing array for every BSP surface.
  result = array(len(map.faces))
  faceIndex = 0
  while faceIndex < len(map.faces)
    result[faceIndex] = buildSurface(map, faceIndex, images, entityFrame)
    faceIndex = faceIndex + 1
  end while
  return result
end function
