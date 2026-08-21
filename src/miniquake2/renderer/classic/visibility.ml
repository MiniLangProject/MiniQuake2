/*
Copyright (C) 1997-2001 Id Software, Inc.
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later

Deterministic BSP38 PVS, marksurface, frustum and backface selection for the
opaque ClassicWorld submission path.
*/
package miniquake2.renderer.classic.visibility

import std.array as rvisibilityarray
import std.math as rvisibilitymath
import miniquake2.format.bsp as fbsp
import miniquake2.format.types as ft
import miniquake2.renderer.constants as rc
import miniquake2.renderer.classic.types as rclassictypes

const VISIBILITY_DEG_TO_RAD = 0.017453292519943295
const VISIBILITY_NEAR = 4.0
const VISIBILITY_FAR = 8192.0
const BACKFACE_EPSILON = 0.01

function classicVisibilityPointLeaf(map, origin)
  if len(map.leafs) == 0 then return -1 end if
  if len(map.nodes) == 0 then
    if len(map.leafs) == 1 then return 0 end if
    for leafIndex = 0 to(len(map.leafs) - 1)
      leaf = map.leafs[leafIndex]
      if origin.x >= leaf.mins.x and origin.x <= leaf.maxs.x and
          origin.y >= leaf.mins.y and origin.y <= leaf.maxs.y and
          origin.z >= leaf.mins.z and origin.z <= leaf.maxs.z then return leafIndex end if
    end for
    return error(9750, "view origin is outside BSP leaf bounds")
  end if
  nodeIndex = 0
  if len(map.models) > 0 then nodeIndex = map.models[0].headNode end if
  guard = 0
  while nodeIndex >= 0
    if nodeIndex >= len(map.nodes) then return error(9751, "BSP visibility node outside table") end if
    node = map.nodes[nodeIndex]
    if node.planeIndex < 0 or node.planeIndex >= len(map.planes) then return error(9752, "BSP visibility plane outside table") end if
    plane = map.planes[node.planeIndex]
    distance = origin.x * plane.normal.x + origin.y * plane.normal.y + origin.z * plane.normal.z - plane.distance
    if distance >= 0.0 then nodeIndex = node.child0 else nodeIndex = node.child1 end if
    guard = guard + 1
    if guard > len(map.nodes) + 1 then return error(9753, "BSP visibility node cycle") end if
  end while
  leafIndex = -1 - nodeIndex
  if leafIndex < 0 or leafIndex >= len(map.leafs) then return error(9754, "BSP visibility leaf outside table") end if
  return leafIndex
end function

function classicVisibilityAreaAllowed(areaBits, area)
  if areaBits is void then return true end if
  if area < 0 then return false end if
  byteIndex = area >> 3
  if byteIndex < 0 or byteIndex >= len(areaBits) then return false end if
  return (areaBits[byteIndex] & (1 << (area & 7))) != 0
end function

function classicVisibilityMarkLeafFaces(map, leaf, marked)
  if leaf.firstLeafFace < 0 or leaf.numLeafFaces < 0 or leaf.firstLeafFace > len(map.leafFaces) or leaf.numLeafFaces > len(map.leafFaces) - leaf.firstLeafFace then
    return error(9755, "BSP leaf marksurface range outside table")
  end if
  offset = 0
  while offset < leaf.numLeafFaces
    faceIndex = map.leafFaces[leaf.firstLeafFace + offset]
    if faceIndex < 0 or faceIndex >= len(map.faces) then return error(9756, "BSP leaf marksurface outside face table") end if
    marked[faceIndex] = true
    offset = offset + 1
  end while
end function

function classicVisibilityPvsRow(map, cluster)
  visibility = map.visibility
  if visibility is void or visibility.numClusters <= 0 then return bytes(0) end if
  if cluster < 0 or cluster >= visibility.numClusters then return error(9757, "view cluster outside BSP visibility table") end if
  if typeof(visibility.pvsOffsets) != "array" or len(visibility.pvsOffsets) != visibility.numClusters then return error(9758, "BSP PVS offset table is malformed") end if
  return fbsp.decompressVisibility(visibility, cluster, 0)
end function

function classicVisibilityPvsContains(row, cluster)
  if cluster < 0 then return false end if
  byteIndex = cluster >> 3
  if byteIndex < 0 or byteIndex >= len(row) then return false end if
  return (row[byteIndex] & (1 << (cluster & 7))) != 0
end function

function classicVisibilityAngleAxes(angles)
  pitch = angles.x * VISIBILITY_DEG_TO_RAD
  yaw = angles.y * VISIBILITY_DEG_TO_RAD
  roll = angles.z * VISIBILITY_DEG_TO_RAD
  pitchSine = rvisibilitymath.sin(pitch); pitchCosine = rvisibilitymath.cos(pitch)
  yawSine = rvisibilitymath.sin(yaw); yawCosine = rvisibilitymath.cos(yaw)
  rollSine = rvisibilitymath.sin(roll); rollCosine = rvisibilitymath.cos(roll)
  forward = ft.Vec3(pitchCosine * yawCosine, pitchCosine * yawSine, -pitchSine)
  right = ft.Vec3(
    -rollSine * pitchSine * yawCosine + rollCosine * yawSine,
    -rollSine * pitchSine * yawSine - rollCosine * yawCosine,
    -rollSine * pitchCosine
  )
  up = ft.Vec3(
    rollCosine * pitchSine * yawCosine + rollSine * yawSine,
    rollCosine * pitchSine * yawSine - rollSine * yawCosine,
    rollCosine * pitchCosine
  )
  return [forward, right, up]
end function

function classicVisibilityBoxOutsidePlane(draw, normalX, normalY, normalZ, planeDistance)
  centerX = (draw.mins.x + draw.maxs.x) * 0.5
  centerY = (draw.mins.y + draw.maxs.y) * 0.5
  centerZ = (draw.mins.z + draw.maxs.z) * 0.5
  extentX = (draw.maxs.x - draw.mins.x) * 0.5
  extentY = (draw.maxs.y - draw.mins.y) * 0.5
  extentZ = (draw.maxs.z - draw.mins.z) * 0.5
  absX = normalX; if absX < 0.0 then absX = -absX end if
  absY = normalY; if absY < 0.0 then absY = -absY end if
  absZ = normalZ; if absZ < 0.0 then absZ = -absZ end if
  radius = absX * extentX + absY * extentY + absZ * extentZ
  distance = normalX * centerX + normalY * centerY + normalZ * centerZ - planeDistance
  return distance + radius < 0.0
end function

function classicVisibilityInsideFrustum(draw, frame)
  axes = classicVisibilityAngleAxes(frame.viewAngles)
  forward = axes[0]; right = axes[1]; up = axes[2]
  halfX = frame.fovX * VISIBILITY_DEG_TO_RAD * 0.5
  halfY = frame.fovY * VISIBILITY_DEG_TO_RAD * 0.5
  tanX = rvisibilitymath.sin(halfX) / rvisibilitymath.cos(halfX)
  tanY = rvisibilitymath.sin(halfY) / rvisibilitymath.cos(halfY)

  normalX = forward.x * tanX + right.x; normalY = forward.y * tanX + right.y; normalZ = forward.z * tanX + right.z
  planeDistance = frame.viewOrigin.x * normalX + frame.viewOrigin.y * normalY + frame.viewOrigin.z * normalZ
  if classicVisibilityBoxOutsidePlane(draw, normalX, normalY, normalZ, planeDistance) then return false end if
  normalX = forward.x * tanX - right.x; normalY = forward.y * tanX - right.y; normalZ = forward.z * tanX - right.z
  planeDistance = frame.viewOrigin.x * normalX + frame.viewOrigin.y * normalY + frame.viewOrigin.z * normalZ
  if classicVisibilityBoxOutsidePlane(draw, normalX, normalY, normalZ, planeDistance) then return false end if
  normalX = forward.x * tanY + up.x; normalY = forward.y * tanY + up.y; normalZ = forward.z * tanY + up.z
  planeDistance = frame.viewOrigin.x * normalX + frame.viewOrigin.y * normalY + frame.viewOrigin.z * normalZ
  if classicVisibilityBoxOutsidePlane(draw, normalX, normalY, normalZ, planeDistance) then return false end if
  normalX = forward.x * tanY - up.x; normalY = forward.y * tanY - up.y; normalZ = forward.z * tanY - up.z
  planeDistance = frame.viewOrigin.x * normalX + frame.viewOrigin.y * normalY + frame.viewOrigin.z * normalZ
  if classicVisibilityBoxOutsidePlane(draw, normalX, normalY, normalZ, planeDistance) then return false end if
  planeDistance = frame.viewOrigin.x * forward.x + frame.viewOrigin.y * forward.y + frame.viewOrigin.z * forward.z + VISIBILITY_NEAR
  if classicVisibilityBoxOutsidePlane(draw, forward.x, forward.y, forward.z, planeDistance) then return false end if
  normalX = -forward.x; normalY = -forward.y; normalZ = -forward.z
  planeDistance = frame.viewOrigin.x * normalX + frame.viewOrigin.y * normalY + frame.viewOrigin.z * normalZ - VISIBILITY_FAR
  if classicVisibilityBoxOutsidePlane(draw, normalX, normalY, normalZ, planeDistance) then return false end if
  return true
end function

function classicVisibilityFrontFacing(draw, viewOrigin)
  plane = draw.surface.plane
  distance = viewOrigin.x * plane.normal.x + viewOrigin.y * plane.normal.y + viewOrigin.z * plane.normal.z - plane.distance
  if draw.surface.face.side == 0 then return distance >= -BACKFACE_EPSILON end if
  return distance <= BACKFACE_EPSILON
end function

function classicVisibilityBrushBounds(brushModel, entity)
  model = brushModel.model
  origin = entity.origin
  angles = entity.angles
  if angles.x == 0.0 and angles.y == 0.0 and angles.z == 0.0 then
    return rclassictypes.ClassicWorldDraw(
      void, void, array(0), void, array(0), 0,
      ft.Vec3(origin.x + model.mins.x, origin.y + model.mins.y, origin.z + model.mins.z),
      ft.Vec3(origin.x + model.maxs.x, origin.y + model.maxs.y, origin.z + model.maxs.z)
    )
  end if
  extentX = model.mins.x; if extentX < 0.0 then extentX = -extentX end if
  candidate = model.maxs.x; if candidate < 0.0 then candidate = -candidate end if
  if candidate > extentX then extentX = candidate end if
  extentY = model.mins.y; if extentY < 0.0 then extentY = -extentY end if
  candidate = model.maxs.y; if candidate < 0.0 then candidate = -candidate end if
  if candidate > extentY then extentY = candidate end if
  extentZ = model.mins.z; if extentZ < 0.0 then extentZ = -extentZ end if
  candidate = model.maxs.z; if candidate < 0.0 then candidate = -candidate end if
  if candidate > extentZ then extentZ = candidate end if
  radius = rvisibilitymath.sqrt(extentX * extentX + extentY * extentY + extentZ * extentZ)
  return rclassictypes.ClassicWorldDraw(
    void, void, array(0), void, array(0), 0,
    ft.Vec3(origin.x - radius, origin.y - radius, origin.z - radius),
    ft.Vec3(origin.x + radius, origin.y + radius, origin.z + radius)
  )
end function

function classicVisibilityBrushWorldPoint(entity, localPoint)
  origin = entity.origin
  angles = entity.angles
  if angles.x == 0.0 and angles.y == 0.0 and angles.z == 0.0 then
    return ft.Vec3(origin.x + localPoint.x, origin.y + localPoint.y, origin.z + localPoint.z)
  end if
  axes = classicVisibilityAngleAxes(angles)
  forward = axes[0]; right = axes[1]; up = axes[2]
  return ft.Vec3(
    origin.x + localPoint.x * forward.x - localPoint.y * right.x + localPoint.z * up.x,
    origin.y + localPoint.x * forward.y - localPoint.y * right.y + localPoint.z * up.y,
    origin.z + localPoint.x * forward.z - localPoint.y * right.z + localPoint.z * up.z
  )
end function

function classicVisibilityBrushLocalView(entity, viewOrigin)
  origin = entity.origin
  deltaX = viewOrigin.x - origin.x; deltaY = viewOrigin.y - origin.y; deltaZ = viewOrigin.z - origin.z
  angles = entity.angles
  if angles.x == 0.0 and angles.y == 0.0 and angles.z == 0.0 then return ft.Vec3(deltaX, deltaY, deltaZ) end if
  axes = classicVisibilityAngleAxes(angles)
  forward = axes[0]; right = axes[1]; up = axes[2]
  return ft.Vec3(
    deltaX * forward.x + deltaY * forward.y + deltaZ * forward.z,
    -(deltaX * right.x + deltaY * right.y + deltaZ * right.z),
    deltaX * up.x + deltaY * up.y + deltaZ * up.z
  )
end function

function classicVisibilityBrushModelVisible(brushModel, entity, frame)
  if len(brushModel.draws) == 0 then return false end if
  bounds = classicVisibilityBrushBounds(brushModel, entity)
  return classicVisibilityInsideFrustum(bounds, frame)
end function

function selectClassicBrushModel(brushModel, entity, frame)
  if not classicVisibilityBrushModelVisible(brushModel, entity, frame) then return array(0) end if
  localView = classicVisibilityBrushLocalView(entity, frame.viewOrigin)
  selected = array(len(brushModel.draws))
  selectedCount = 0
  for each draw in brushModel.draws
    if classicVisibilityFrontFacing(draw, localView) then
      selected[selectedCount] = draw
      selectedCount = selectedCount + 1
    end if
  end for
  return rvisibilityarray.slice(selected, 0, selectedCount)
end function

function selectClassicWorld(world, frame)
  total = len(world.draws)
  if (frame.rdFlags & rc.RDF_NOWORLDMODEL) != 0 then
    return rclassictypes.ClassicVisibilitySelection(array(0), -1, -1, total, 0, 0, 0)
  end if
  map = world.map
  pvsMarked = array(len(map.faces), false)
  areaMarked = array(len(map.faces), false)
  viewLeaf = classicVisibilityPointLeaf(map, frame.viewOrigin)
  viewCluster = -1
  if viewLeaf >= 0 then viewCluster = map.leafs[viewLeaf].cluster end if

  if len(map.leafs) == 0 then
    for each draw in world.draws
      pvsMarked[draw.surface.index] = true
      areaMarked[draw.surface.index] = true
    end for
  else
    row = bytes(0)
    if viewCluster >= 0 then row = classicVisibilityPvsRow(map, viewCluster) end if
    usePvs = viewCluster >= 0 and len(row) > 0
    leafIndex = 0
    while leafIndex < len(map.leafs)
      leaf = map.leafs[leafIndex]
      clusterVisible = not usePvs
      if usePvs then
        if leaf.cluster >= map.visibility.numClusters then return error(9759, "BSP leaf cluster outside visibility table") end if
        clusterVisible = classicVisibilityPvsContains(row, leaf.cluster)
      end if
      if clusterVisible then
        classicVisibilityMarkLeafFaces(map, leaf, pvsMarked)
        if classicVisibilityAreaAllowed(frame.areaBits, leaf.area) then classicVisibilityMarkLeafFaces(map, leaf, areaMarked) end if
      end if
      leafIndex = leafIndex + 1
    end while
  end if

  selected = array(total)
  selectedCount = 0
  pvsCulled = 0; areaCulled = 0; frustumCulled = 0; backfaceCulled = 0
  for each draw in world.draws
    faceIndex = draw.surface.index
    if not pvsMarked[faceIndex] then
      pvsCulled = pvsCulled + 1
    else if not areaMarked[faceIndex] then
      areaCulled = areaCulled + 1
    else if not classicVisibilityInsideFrustum(draw, frame) then
      frustumCulled = frustumCulled + 1
    else if not classicVisibilityFrontFacing(draw, frame.viewOrigin) then
      backfaceCulled = backfaceCulled + 1
    else
      selected[selectedCount] = draw
      selectedCount = selectedCount + 1
    end if
  end for
  return rclassictypes.ClassicVisibilitySelection(
    rvisibilityarray.slice(selected, 0, selectedCount), viewLeaf, viewCluster,
    pvsCulled, areaCulled, frustumCulled, backfaceCulled
  )
end function

function classicVisibilityCulledCount(selection)
  return selection.pvsCulled + selection.areaCulled + selection.frustumCulled + selection.backfaceCulled
end function
