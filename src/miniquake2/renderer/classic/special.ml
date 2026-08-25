/*
Copyright (C) 1997-2001 Id Software, Inc.
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later

CPU-side special-surface preparation from ref_gl/gl_rsurf.c and gl_warp.c.
This keeps pass ordering, alpha selection, flowing coordinates and water
turbulence deterministic and independently testable from the native GL bridge.
*/
package miniquake2.renderer.classic.special

import std.array as rspecialarray
import std.math as rspecialmath
import miniquake2.format.constants as rspecialformatconstants
import miniquake2.format.types as rspecialformattypes
import miniquake2.qcommon.byteio as rspecialbyteio
import miniquake2.renderer.classic.constants as rclassicconstants
import miniquake2.renderer.classic.types as rclassictypes
import miniquake2.renderer.classic.surfaces as rclassicsurfaces

const SPECIAL_PI2 = 6.283185307179586
const SPECIAL_TURB_SCALE = 40.74366543152521
const SPECIAL_SUBDIVIDE_SIZE = 64.0
const SPECIAL_SUBDIVIDE_MARGIN = 8.0

function classicSpecialFlowScroll(time)
  phase = time / 40.0
  scroll = -64.0 * (phase - rspecialmath.floor(phase))
  if scroll == 0.0 then return -64.0 end if
  return scroll
end function

function classicSpecialWaterScroll(time)
  phase = time * 0.5
  return -64.0 * (phase - rspecialmath.floor(phase))
end function

function classicSpecialWarpSine(value)
  index = rspecialbyteio.truncInt(value * SPECIAL_TURB_SCALE) & 255
  return rspecialmath.sin(index * SPECIAL_PI2 / 256.0) * 8.0
end function

function classicSpecialTextureCoordinates(draw, vertex, time)
  flags = draw.surface.texInfo.flags
  if (flags & rspecialformatconstants.SURF_WARP) != 0 then
    rawS = vertex.s * draw.surface.image.width
    rawT = vertex.t * draw.surface.image.height
    scroll = 0.0
    if (flags & rspecialformatconstants.SURF_FLOWING) != 0 then scroll = classicSpecialWaterScroll(time) end if
    warpedS = (rawS + classicSpecialWarpSine(rawT * 0.125 + time) + scroll) / 64.0
    warpedT = (rawT + classicSpecialWarpSine(rawS * 0.125 + time)) / 64.0
    return [warpedS, warpedT]
  end if
  if (flags & rspecialformatconstants.SURF_FLOWING) != 0 then return [vertex.s + classicSpecialFlowScroll(time), vertex.t] end if
  return [vertex.s, vertex.t]
end function

function classicSpecialBaseTexture(draw, time)
  if len(draw.baseTextures) == 0 then return draw.baseTexture end if
  frame = rspecialbyteio.truncInt(time * 2.0)
  index = frame % len(draw.baseTextures)
  if index < 0 then index = index + len(draw.baseTextures) end if
  return draw.baseTextures[index]
end function

function classicSpecialTriangleVertices(surface)
  triangleCount = len(surface.vertices) - 2
  if triangleCount < 1 then return error(9760, "classic special surface has fewer than three vertices") end if
  result = array(triangleCount * 3)
  resultIndex = 0
  offset = 1
  while offset < len(surface.vertices) - 1
    result[resultIndex] = surface.vertices[0]
    result[resultIndex + 1] = surface.vertices[offset]
    result[resultIndex + 2] = surface.vertices[offset + 1]
    resultIndex = resultIndex + 3
    offset = offset + 1
  end while
  return result
end function

function classicSpecialPositionAxis(position, axis)
  if axis == 0 then return position.x end if
  if axis == 1 then return position.y end if
  return position.z
end function

function classicSpecialBounds(positions)
  first = positions[0]
  mins = rspecialformattypes.Vec3(first.x, first.y, first.z)
  maxs = rspecialformattypes.Vec3(first.x, first.y, first.z)
  index = 1
  while index < len(positions)
    position = positions[index]
    if position.x < mins.x then mins.x = position.x end if
    if position.y < mins.y then mins.y = position.y end if
    if position.z < mins.z then mins.z = position.z end if
    if position.x > maxs.x then maxs.x = position.x end if
    if position.y > maxs.y then maxs.y = position.y end if
    if position.z > maxs.z then maxs.z = position.z end if
    index = index + 1
  end while
  return [mins, maxs]
end function

function classicSpecialInterpolate(first, second, fraction)
  return rspecialformattypes.Vec3(
    first.x + (second.x - first.x) * fraction,
    first.y + (second.y - first.y) * fraction,
    first.z + (second.z - first.z) * fraction
  )
end function

function classicSpecialSplitPolygon(positions, axis, split)
  front = array(len(positions) * 2)
  back = array(len(positions) * 2)
  frontCount = 0; backCount = 0
  index = 0
  while index < len(positions)
    nextIndex = index + 1
    if nextIndex == len(positions) then nextIndex = 0 end if
    current = positions[index]
    next = positions[nextIndex]
    currentDistance = classicSpecialPositionAxis(current, axis) - split
    nextDistance = classicSpecialPositionAxis(next, axis) - split
    if currentDistance >= 0.0 then front[frontCount] = current; frontCount = frontCount + 1 end if
    if currentDistance <= 0.0 then back[backCount] = current; backCount = backCount + 1 end if
    if currentDistance != 0.0 and nextDistance != 0.0 and ((currentDistance > 0.0) != (nextDistance > 0.0)) then
      fraction = currentDistance / (currentDistance - nextDistance)
      intersection = classicSpecialInterpolate(current, next, fraction)
      front[frontCount] = intersection; frontCount = frontCount + 1
      back[backCount] = intersection; backCount = backCount + 1
    end if
    index = index + 1
  end while
  return [
    rspecialarray.slice(front, 0, frontCount),
    rspecialarray.slice(back, 0, backCount)
  ]
end function

function classicSpecialSurfaceVertex(surface, position)
  rawS = rclassicsurfaces.projected(position, surface.texInfo.s)
  rawT = rclassicsurfaces.projected(position, surface.texInfo.t)
  return rclassictypes.surfaceVertex(position, rawS / surface.image.width, rawT / surface.image.height, 0.0, 0.0)
end function

function classicSpecialFan(surface, positions)
  count = len(positions)
  if count < 3 then return array(0) end if
  centerX = 0.0; centerY = 0.0; centerZ = 0.0
  for each position in positions
    centerX = centerX + position.x; centerY = centerY + position.y; centerZ = centerZ + position.z
  end for
  center = classicSpecialSurfaceVertex(surface, rspecialformattypes.Vec3(centerX / count, centerY / count, centerZ / count))
  triangles = array(count * 3)
  index = 0
  while index < count
    nextIndex = index + 1
    if nextIndex == count then nextIndex = 0 end if
    triangles[index * 3] = center
    triangles[index * 3 + 1] = classicSpecialSurfaceVertex(surface, positions[index])
    triangles[index * 3 + 2] = classicSpecialSurfaceVertex(surface, positions[nextIndex])
    index = index + 1
  end while
  return triangles
end function

function classicSpecialSubdivide(surface, positions)
  if len(positions) < 3 then return array(0) end if
  bounds = classicSpecialBounds(positions)
  mins = bounds[0]; maxs = bounds[1]
  axis = 0
  while axis < 3
    minimum = classicSpecialPositionAxis(mins, axis)
    maximum = classicSpecialPositionAxis(maxs, axis)
    midpoint = (minimum + maximum) * 0.5
    split = SPECIAL_SUBDIVIDE_SIZE * rspecialmath.floor(midpoint / SPECIAL_SUBDIVIDE_SIZE + 0.5)
    if maximum - split >= SPECIAL_SUBDIVIDE_MARGIN and split - minimum >= SPECIAL_SUBDIVIDE_MARGIN then
      halves = classicSpecialSplitPolygon(positions, axis, split)
      front = classicSpecialSubdivide(surface, halves[0])
      back = classicSpecialSubdivide(surface, halves[1])
      return front + back
    end if
    axis = axis + 1
  end while
  return classicSpecialFan(surface, positions)
end function

function classicSpecialWarpVertices(surface)
  positions = array(len(surface.vertices))
  index = 0
  while index < len(surface.vertices)
    positions[index] = surface.vertices[index].position
    index = index + 1
  end while
  return classicSpecialSubdivide(surface, positions)
end function

function classicSpecialDrawVertices(surface)
  if (surface.texInfo.flags & rspecialformatconstants.SURF_WARP) != 0 then return classicSpecialWarpVertices(surface) end if
  return classicSpecialTriangleVertices(surface)
end function

function classicSpecialDistanceSquared(draw, origin)
  centerX = (draw.mins.x + draw.maxs.x) * 0.5
  centerY = (draw.mins.y + draw.maxs.y) * 0.5
  centerZ = (draw.mins.z + draw.maxs.z) * 0.5
  deltaX = centerX - origin.x; deltaY = centerY - origin.y; deltaZ = centerZ - origin.z
  return deltaX * deltaX + deltaY * deltaY + deltaZ * deltaZ
end function

function classicSpecialTransparentBefore(candidate, previous, origin)
  candidateDistance = classicSpecialDistanceSquared(candidate, origin)
  previousDistance = classicSpecialDistanceSquared(previous, origin)
  if candidateDistance > previousDistance then return true end if
  if candidateDistance < previousDistance then return false end if
  return candidate.surface.index < previous.surface.index
end function

function classicSpecialSortTransparent(draws, origin)
  sorted = array(len(draws))
  count = 0
  for each draw in draws
    insert = count
    while insert > 0 and classicSpecialTransparentBefore(draw, sorted[insert - 1], origin)
      sorted[insert] = sorted[insert - 1]
      insert = insert - 1
    end while
    sorted[insert] = draw
    count = count + 1
  end for
  return sorted
end function

function classicSpecialPassPlanOrigin(draws, viewOrigin)
  opaqueCount = 0; warpCount = 0; skyCount = 0; transparentCount = 0
  for each draw in draws
    category = draw.surface.category
    if category == rclassicconstants.MATERIAL_OPAQUE then opaqueCount = opaqueCount + 1
    else if category == rclassicconstants.MATERIAL_WARP then warpCount = warpCount + 1
    else if category == rclassicconstants.MATERIAL_SKY then skyCount = skyCount + 1
    else if category == rclassicconstants.MATERIAL_TRANSPARENT then transparentCount = transparentCount + 1
    end if
  end for
  // Count first and allocate the exact pass sizes. The old one-pass builder
  // allocated four arrays at the full visible-surface count and then sliced
  // all four, copying hundreds of references on every rendered frame.
  opaque = array(opaqueCount); warp = array(warpCount)
  sky = array(skyCount); transparent = array(transparentCount)
  opaqueIndex = 0; warpIndex = 0; skyIndex = 0; transparentIndex = 0
  for each draw in draws
    category = draw.surface.category
    if category == rclassicconstants.MATERIAL_OPAQUE then
      opaque[opaqueIndex] = draw; opaqueIndex = opaqueIndex + 1
    else if category == rclassicconstants.MATERIAL_WARP then
      warp[warpIndex] = draw; warpIndex = warpIndex + 1
    else if category == rclassicconstants.MATERIAL_SKY then
      sky[skyIndex] = draw; skyIndex = skyIndex + 1
    else if category == rclassicconstants.MATERIAL_TRANSPARENT then
      transparent[transparentIndex] = draw
      transparentIndex = transparentIndex + 1
    end if
  end for
  transparentDraws = classicSpecialSortTransparent(transparent, viewOrigin)
  return rclassictypes.ClassicSpecialPassPlan(
    opaque, warp, sky, transparentDraws
  )
end function

function classicSpecialPassPlan(draws, frame)
  return classicSpecialPassPlanOrigin(draws, frame.viewOrigin)
end function

function classicSpecialPassSignature(plan)
  result = ""
  for each draw in plan.opaqueDraws result = result + "o" + draw.surface.index + "," end for
  for each draw in plan.warpDraws result = result + "w" + draw.surface.index + "," end for
  for each draw in plan.skyDraws result = result + "s" + draw.surface.index + "," end for
  for each draw in plan.transparentDraws result = result + "a" + draw.surface.index + "@" + draw.surface.alpha + "," end for
  return result
end function
