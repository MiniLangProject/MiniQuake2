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
import miniquake2.renderer.classic.constants as rclassicconstants
import miniquake2.qcommon.byteio as rvisibilitybyteio

const VISIBILITY_DEG_TO_RAD = 0.017453292519943295
const VISIBILITY_NEAR = 4.0
const VISIBILITY_FAR = 8192.0
const BACKFACE_EPSILON = 0.01

// Store classic frustum plane data.
struct ClassicFrustumPlane
  normalX
  normalY
  normalZ
  distance
  absX
  absY
  absZ
end struct

// Store classic pvs selection data.
struct ClassicPvsSelection
  draws
  viewLeaf
  viewCluster
  pvsCulled
  areaCulled
end struct

// Store classic visibility cache slot data.
struct ClassicVisibilityCacheSlot
  world
  cluster
  areaBits
  draws
  pvsCulled
  areaCulled
end struct

// Minimal per-frame brush bounds used by the frustum culler. Keeping this
// separate from ClassicWorldDraw avoids allocating empty texture/vertex arrays
// and a full draw record for every moving door, platform and lift each frame.
struct ClassicBrushBounds
  mins
  maxs
  centerX
  centerY
  centerZ
  extentX
  extentY
  extentZ
end struct

// Pair the visible brush prefix with the already-computed local camera point
// so the OpenGL planner does not repeat rotated-axis trigonometry.
struct ClassicBrushSelection
  draws
  count
  localView
end struct

// Store the three view axes in one record. The former `[forward, right, up]`
// representation allocated an array and three Vec3 values on every frustum
// build and again for each rotated brush transform.
struct ClassicVisibilityAxes
  forwardX
  forwardY
  forwardZ
  rightX
  rightY
  rightZ
  upX
  upY
  upZ
end struct

classicVisibilityCacheSlot = ClassicVisibilityCacheSlot(void, -999999, void,
  [], 0, 0)
classicVisibilitySelectionScratch = []
classicVisibilityFrustumScratch = [
  ClassicFrustumPlane(0, 0, 0, 0, 0, 0, 0),
  ClassicFrustumPlane(0, 0, 0, 0, 0, 0, 0),
  ClassicFrustumPlane(0, 0, 0, 0, 0, 0, 0),
  ClassicFrustumPlane(0, 0, 0, 0, 0, 0, 0),
  ClassicFrustumPlane(0, 0, 0, 0, 0, 0, 0),
  ClassicFrustumPlane(0, 0, 0, 0, 0, 0, 0)
]

// Report whether classic visibility area bits equal.
function inline classicVisibilityAreaBitsEqual(first, second)
  if first is void or second is void then return first is void and second is void end if
  if len(first) != len(second) then return false end if
  index = 0
  while index < len(first)
    if first[index] != second[index] then return false end if
    index = index + 1
  end while
  return true
end function

// Copy classic visibility area bits.
function classicVisibilityCopyAreaBits(value)
  if value is void then return void end if
  copy = bytes(len(value))
  index = 0
  while index < len(value)
    copy[index] = value[index]
    index = index + 1
  end while
  return copy
end function

// Return the classic visibility point leaf value.
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

// Return the classic visibility area allowed value.
function inline classicVisibilityAreaAllowed(areaBits, area)
  if areaBits is void then return true end if
  if area < 0 then return false end if
  byteIndex = area >> 3
  if byteIndex < 0 or byteIndex >= len(areaBits) then return false end if
  return (areaBits[byteIndex] & (1 << (area & 7))) != 0
end function

// Mark classic visibility leaf faces.
function classicVisibilityMarkLeafFaces(map, leaf, marked)
  if leaf.firstLeafFace < 0 or leaf.numLeafFaces < 0 or leaf.firstLeafFace > len(map.leafFaces) or leaf.numLeafFaces > len(map.leafFaces) - leaf.firstLeafFace then
    return error(9755, "BSP leaf marksurface range outside table")
  end if
  offset = 0
  while offset < leaf.numLeafFaces
    faceIndex = map.leafFaces[leaf.firstLeafFace + offset]
    if faceIndex < 0 or faceIndex >= len(map.faces) then return error(9756, "BSP leaf marksurface outside face table") end if
    marked[faceIndex] = 1
    offset = offset + 1
  end while
end function

// Return the classic visibility pvs row value.
function classicVisibilityPvsRow(map, cluster)
  visibility = map.visibility
  if visibility is void or visibility.numClusters <= 0 then return bytes(0) end if
  if cluster < 0 or cluster >= visibility.numClusters then return error(9757, "view cluster outside BSP visibility table") end if
  if typeof(visibility.pvsOffsets) != "array" or len(visibility.pvsOffsets) != visibility.numClusters then return error(9758, "BSP PVS offset table is malformed") end if
  return fbsp.decompressVisibility(visibility, cluster, 0)
end function

// Report whether classic visibility pvs contains.
function inline classicVisibilityPvsContains(row, cluster)
  if cluster < 0 then return false end if
  byteIndex = cluster >> 3
  if byteIndex < 0 or byteIndex >= len(row) then return false end if
  return (row[byteIndex] & (1 << (cluster & 7))) != 0
end function

// Return the classic visibility angle axes value.
function classicVisibilityAngleAxes(angles)
  pitch = angles.x * VISIBILITY_DEG_TO_RAD
  yaw = angles.y * VISIBILITY_DEG_TO_RAD
  roll = angles.z * VISIBILITY_DEG_TO_RAD
  pitchSine = rvisibilitymath.sin(pitch); pitchCosine = rvisibilitymath.cos(pitch)
  yawSine = rvisibilitymath.sin(yaw); yawCosine = rvisibilitymath.cos(yaw)
  rollSine = rvisibilitymath.sin(roll); rollCosine = rvisibilitymath.cos(roll)
  forwardX = pitchCosine * yawCosine
  forwardY = pitchCosine * yawSine
  forwardZ = -pitchSine
  rightX = -rollSine * pitchSine * yawCosine + rollCosine * yawSine
  rightY = -rollSine * pitchSine * yawSine - rollCosine * yawCosine
  rightZ = -rollSine * pitchCosine
  upX = rollCosine * pitchSine * yawCosine + rollSine * yawSine
  upY = rollCosine * pitchSine * yawSine - rollSine * yawCosine
  upZ = rollCosine * pitchCosine
  return ClassicVisibilityAxes(forwardX, forwardY, forwardZ,
    rightX, rightY, rightZ, upX, upY, upZ)
end function

// Return the classic visibility box outside plane value.
function inline classicVisibilityBoxOutsidePlane(draw, plane)
  radius = plane.absX * draw.extentX + plane.absY * draw.extentY +
    plane.absZ * draw.extentZ
  distance = plane.normalX * draw.centerX + plane.normalY * draw.centerY +
    plane.normalZ * draw.centerZ - plane.distance
  return distance + radius < -rclassicconstants.CULL_MARGIN
end function

// Return the classic visibility plane value.
function inline classicVisibilityPlane(normalX, normalY, normalZ, distance)
  fixedX = rvisibilitybyteio.truncInt(normalX * rclassicconstants.CULL_NORMAL_SCALE)
  fixedY = rvisibilitybyteio.truncInt(normalY * rclassicconstants.CULL_NORMAL_SCALE)
  fixedZ = rvisibilitybyteio.truncInt(normalZ * rclassicconstants.CULL_NORMAL_SCALE)
  fixedDistance = rvisibilitybyteio.truncInt(distance *
    rclassicconstants.CULL_PRODUCT_SCALE)
  absX = fixedX; if absX < 0 then absX = -absX end if
  absY = fixedY; if absY < 0 then absY = -absY end if
  absZ = fixedZ; if absZ < 0 then absZ = -absZ end if
  return ClassicFrustumPlane(fixedX, fixedY, fixedZ, fixedDistance,
    absX, absY, absZ)
end function

// Update one reusable fixed-point frustum plane without allocating a record.
function inline classicVisibilitySetPlane(plane, normalX, normalY, normalZ,
    distance)
  fixedX = rvisibilitybyteio.truncInt(normalX * rclassicconstants.CULL_NORMAL_SCALE)
  fixedY = rvisibilitybyteio.truncInt(normalY * rclassicconstants.CULL_NORMAL_SCALE)
  fixedZ = rvisibilitybyteio.truncInt(normalZ * rclassicconstants.CULL_NORMAL_SCALE)
  fixedDistance = rvisibilitybyteio.truncInt(distance *
    rclassicconstants.CULL_PRODUCT_SCALE)
  absX = fixedX; if absX < 0 then absX = -absX end if
  absY = fixedY; if absY < 0 then absY = -absY end if
  absZ = fixedZ; if absZ < 0 then absZ = -absZ end if
  plane.normalX = fixedX; plane.normalY = fixedY; plane.normalZ = fixedZ
  plane.distance = fixedDistance
  plane.absX = absX; plane.absY = absY; plane.absZ = absZ
end function

// Return the classic visibility frustum value.
function classicVisibilityFrustum(frame)
  axes = classicVisibilityAngleAxes(frame.viewAngles)
  halfX = frame.fovX * VISIBILITY_DEG_TO_RAD * 0.5
  halfY = frame.fovY * VISIBILITY_DEG_TO_RAD * 0.5
  tanX = rvisibilitymath.sin(halfX) / rvisibilitymath.cos(halfX)
  tanY = rvisibilitymath.sin(halfY) / rvisibilitymath.cos(halfY)

  planes = classicVisibilityFrustumScratch
  normalX = axes.forwardX * tanX + axes.rightX; normalY = axes.forwardY * tanX + axes.rightY; normalZ = axes.forwardZ * tanX + axes.rightZ
  planeDistance = frame.viewOrigin.x * normalX + frame.viewOrigin.y * normalY + frame.viewOrigin.z * normalZ
  classicVisibilitySetPlane(planes[0], normalX, normalY, normalZ, planeDistance)
  normalX = axes.forwardX * tanX - axes.rightX; normalY = axes.forwardY * tanX - axes.rightY; normalZ = axes.forwardZ * tanX - axes.rightZ
  planeDistance = frame.viewOrigin.x * normalX + frame.viewOrigin.y * normalY + frame.viewOrigin.z * normalZ
  classicVisibilitySetPlane(planes[1], normalX, normalY, normalZ, planeDistance)
  normalX = axes.forwardX * tanY + axes.upX; normalY = axes.forwardY * tanY + axes.upY; normalZ = axes.forwardZ * tanY + axes.upZ
  planeDistance = frame.viewOrigin.x * normalX + frame.viewOrigin.y * normalY + frame.viewOrigin.z * normalZ
  classicVisibilitySetPlane(planes[2], normalX, normalY, normalZ, planeDistance)
  normalX = axes.forwardX * tanY - axes.upX; normalY = axes.forwardY * tanY - axes.upY; normalZ = axes.forwardZ * tanY - axes.upZ
  planeDistance = frame.viewOrigin.x * normalX + frame.viewOrigin.y * normalY + frame.viewOrigin.z * normalZ
  classicVisibilitySetPlane(planes[3], normalX, normalY, normalZ, planeDistance)
  planeDistance = frame.viewOrigin.x * axes.forwardX + frame.viewOrigin.y * axes.forwardY + frame.viewOrigin.z * axes.forwardZ + VISIBILITY_NEAR
  classicVisibilitySetPlane(planes[4], axes.forwardX, axes.forwardY, axes.forwardZ, planeDistance)
  normalX = -axes.forwardX; normalY = -axes.forwardY; normalZ = -axes.forwardZ
  planeDistance = frame.viewOrigin.x * normalX + frame.viewOrigin.y * normalY + frame.viewOrigin.z * normalZ - VISIBILITY_FAR
  classicVisibilitySetPlane(planes[5], normalX, normalY, normalZ, planeDistance)
  return planes
end function

// Report whether classic visibility inside prepared frustum.
function inline classicVisibilityInsidePreparedFrustum(draw, planes)
  // A frustum always has six planes. The explicit checks make this small hot
  // predicate eligible for compiler inlining and remove the generic loop and
  // repeated bounds/absolute-value work for every visible BSP surface.
  if classicVisibilityBoxOutsidePlane(draw, planes[0]) then return false end if
  if classicVisibilityBoxOutsidePlane(draw, planes[1]) then return false end if
  if classicVisibilityBoxOutsidePlane(draw, planes[2]) then return false end if
  if classicVisibilityBoxOutsidePlane(draw, planes[3]) then return false end if
  if classicVisibilityBoxOutsidePlane(draw, planes[4]) then return false end if
  if classicVisibilityBoxOutsidePlane(draw, planes[5]) then return false end if
  return true
end function

// Report whether classic visibility inside frustum.
function classicVisibilityInsideFrustum(draw, frame)
  return classicVisibilityInsidePreparedFrustum(draw,
    classicVisibilityFrustum(frame))
end function

// Return the classic visibility front facing fixed value.
function inline classicVisibilityFrontFacingFixed(draw, viewX, viewY, viewZ)
  distance = viewX * draw.planeNormalX + viewY * draw.planeNormalY +
    viewZ * draw.planeNormalZ - draw.planeDistance
  if draw.planeSide == 0 then
    return distance >= -rclassicconstants.BACKFACE_FIXED_EPSILON
  end if
  return distance <= rclassicconstants.BACKFACE_FIXED_EPSILON
end function

// Return the classic visibility front facing value.
function classicVisibilityFrontFacing(draw, viewOrigin)
  return classicVisibilityFrontFacingFixed(draw,
    rvisibilitybyteio.truncInt(viewOrigin.x * rclassicconstants.CULL_COORD_SCALE),
    rvisibilitybyteio.truncInt(viewOrigin.y * rclassicconstants.CULL_COORD_SCALE),
    rvisibilitybyteio.truncInt(viewOrigin.z * rclassicconstants.CULL_COORD_SCALE))
end function

// Return the classic visibility brush bounds.
function classicVisibilityBrushBounds(brushModel, entity)
  // Keep classic visibility brush bounds phases explicit: validate inputs, update owned state, then publish the result.
  model = brushModel.model
  origin = entity.origin
  angles = entity.angles
  if angles.x == 0.0 and angles.y == 0.0 and angles.z == 0.0 then
    mins = ft.Vec3(origin.x + model.mins.x, origin.y + model.mins.y,
      origin.z + model.mins.z)
    maxs = ft.Vec3(origin.x + model.maxs.x, origin.y + model.maxs.y,
      origin.z + model.maxs.z)
    return ClassicBrushBounds(mins, maxs,
      rvisibilitybyteio.truncInt((mins.x + maxs.x) * 0.5 *
        rclassicconstants.CULL_COORD_SCALE),
      rvisibilitybyteio.truncInt((mins.y + maxs.y) * 0.5 *
        rclassicconstants.CULL_COORD_SCALE),
      rvisibilitybyteio.truncInt((mins.z + maxs.z) * 0.5 *
        rclassicconstants.CULL_COORD_SCALE),
      rvisibilitybyteio.truncInt((maxs.x - mins.x) * 0.5 *
        rclassicconstants.CULL_COORD_SCALE) + 1,
      rvisibilitybyteio.truncInt((maxs.y - mins.y) * 0.5 *
        rclassicconstants.CULL_COORD_SCALE) + 1,
      rvisibilitybyteio.truncInt((maxs.z - mins.z) * 0.5 *
        rclassicconstants.CULL_COORD_SCALE) + 1
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
  return ClassicBrushBounds(
    ft.Vec3(origin.x - radius, origin.y - radius, origin.z - radius),
    ft.Vec3(origin.x + radius, origin.y + radius, origin.z + radius),
    rvisibilitybyteio.truncInt(origin.x * rclassicconstants.CULL_COORD_SCALE),
    rvisibilitybyteio.truncInt(origin.y * rclassicconstants.CULL_COORD_SCALE),
    rvisibilitybyteio.truncInt(origin.z * rclassicconstants.CULL_COORD_SCALE),
    rvisibilitybyteio.truncInt(radius * rclassicconstants.CULL_COORD_SCALE) + 1,
    rvisibilitybyteio.truncInt(radius * rclassicconstants.CULL_COORD_SCALE) + 1,
    rvisibilitybyteio.truncInt(radius * rclassicconstants.CULL_COORD_SCALE) + 1
  )
end function

// Return the classic visibility brush world point value.
function classicVisibilityBrushWorldPoint(entity, localPoint)
  origin = entity.origin
  angles = entity.angles
  if angles.x == 0.0 and angles.y == 0.0 and angles.z == 0.0 then
    return ft.Vec3(origin.x + localPoint.x, origin.y + localPoint.y, origin.z + localPoint.z)
  end if
  axes = classicVisibilityAngleAxes(angles)
  return ft.Vec3(
    origin.x + localPoint.x * axes.forwardX - localPoint.y * axes.rightX + localPoint.z * axes.upX,
    origin.y + localPoint.x * axes.forwardY - localPoint.y * axes.rightY + localPoint.z * axes.upY,
    origin.z + localPoint.x * axes.forwardZ - localPoint.y * axes.rightZ + localPoint.z * axes.upZ
  )
end function

// Return the classic visibility brush local view value.
function classicVisibilityBrushLocalView(entity, viewOrigin)
  origin = entity.origin
  deltaX = viewOrigin.x - origin.x; deltaY = viewOrigin.y - origin.y; deltaZ = viewOrigin.z - origin.z
  angles = entity.angles
  if angles.x == 0.0 and angles.y == 0.0 and angles.z == 0.0 then return ft.Vec3(deltaX, deltaY, deltaZ) end if
  axes = classicVisibilityAngleAxes(angles)
  return ft.Vec3(
    deltaX * axes.forwardX + deltaY * axes.forwardY + deltaZ * axes.forwardZ,
    -(deltaX * axes.rightX + deltaY * axes.rightY + deltaZ * axes.rightZ),
    deltaX * axes.upX + deltaY * axes.upY + deltaZ * axes.upZ
  )
end function

// Report whether classic visibility brush model visible.
function classicVisibilityBrushModelVisible(brushModel, entity, frame)
  if len(brushModel.draws) == 0 then return false end if
  bounds = classicVisibilityBrushBounds(brushModel, entity)
  return classicVisibilityInsideFrustum(bounds, frame)
end function

// Report whether classic visibility brush model visible in prepared frustum.
function classicVisibilityBrushModelVisiblePrepared(brushModel, entity, planes)
  if len(brushModel.draws) == 0 then return false end if
  return classicVisibilityInsidePreparedFrustum(
    classicVisibilityBrushBounds(brushModel, entity), planes)
end function

// Select a classic brush model using the frame-owned frustum and retain the
// local view point needed by the special-surface planner.
function selectClassicBrushModelPrepared(brushModel, entity, frame, planes)
  if not classicVisibilityBrushModelVisiblePrepared(brushModel, entity,
      planes) then return ClassicBrushSelection(brushModel.selectionScratch,
        0, void) end if
  localView = classicVisibilityBrushLocalView(entity, frame.viewOrigin)
  localViewX = rvisibilitybyteio.truncInt(localView.x * rclassicconstants.CULL_COORD_SCALE)
  localViewY = rvisibilitybyteio.truncInt(localView.y * rclassicconstants.CULL_COORD_SCALE)
  localViewZ = rvisibilitybyteio.truncInt(localView.z * rclassicconstants.CULL_COORD_SCALE)
  selected = brushModel.selectionScratch
  if len(selected) != len(brushModel.draws) then
    selected = array(len(brushModel.draws))
    brushModel.selectionScratch = selected
  end if
  selectedCount = 0
  for each draw in brushModel.draws
    if classicVisibilityFrontFacingFixed(draw, localViewX, localViewY,
        localViewZ) then
      selected[selectedCount] = draw
      selectedCount = selectedCount + 1
    end if
  end for
  return ClassicBrushSelection(selected, selectedCount, localView)
end function

// Select classic brush model.
function selectClassicBrushModel(brushModel, entity, frame)
  selection = selectClassicBrushModelPrepared(brushModel, entity, frame,
    classicVisibilityFrustum(frame))
  if selection.count == len(selection.draws) then return selection.draws end if
  if selection.count == 0 then return array(0) end if
  return rvisibilityarray.slice(selection.draws, 0, selection.count)
end function

// Return the compact classic draws value.
function compactClassicDraws(values, count)
  if count <= 0 then return array(0) end if
  if count == len(values) then return values end if
  output = array(count)
  index = 0
  while index < count
    output[index] = values[index]
    index = index + 1
  end while
  return output
end function

// Select classic visibility pvs.
function classicVisibilitySelectPvs(world, frame)
  // Keep classic visibility select pvs phases explicit: validate inputs, update owned state, then publish the result.
  total = len(world.draws)
  if (frame.rdFlags & rc.RDF_NOWORLDMODEL) != 0 then
    return ClassicPvsSelection(array(0), -1, -1, total, 0)
  end if
  map = world.map
  // One byte per face is sufficient and avoids two pointer-width managed
  // arrays on every PVS cache miss.
  pvsMarked = bytes(len(map.faces))
  areaMarked = bytes(len(map.faces))
  viewLeaf = classicVisibilityPointLeaf(map, frame.viewOrigin)
  viewCluster = -1
  if viewLeaf >= 0 then viewCluster = map.leafs[viewLeaf].cluster end if

  if len(map.leafs) == 0 then
    for each draw in world.draws
      pvsMarked[draw.surface.index] = 1
      areaMarked[draw.surface.index] = 1
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

  candidates = array(total)
  candidateCount = 0
  pvsCulled = 0; areaCulled = 0
  for each draw in world.draws
    faceIndex = draw.surface.index
    if pvsMarked[faceIndex] == 0 then
      pvsCulled = pvsCulled + 1
    else if areaMarked[faceIndex] == 0 then
      areaCulled = areaCulled + 1
    else
      candidates[candidateCount] = draw
      candidateCount = candidateCount + 1
    end if
  end for
  return ClassicPvsSelection(compactClassicDraws(candidates, candidateCount),
    viewLeaf, viewCluster, pvsCulled, areaCulled)
end function

// Finish classic visibility selection.
function classicVisibilityFinishSelection(pvs, frame)
  selected = classicVisibilitySelectionScratch
  if len(selected) < len(pvs.draws) then
    selected = array(len(pvs.draws), void)
    classicVisibilitySelectionScratch = selected
  end if
  selectedCount = 0
  frustumCulled = 0; backfaceCulled = 0
  frustum = classicVisibilityFrustum(frame)
  viewX = rvisibilitybyteio.truncInt(frame.viewOrigin.x * rclassicconstants.CULL_COORD_SCALE)
  viewY = rvisibilitybyteio.truncInt(frame.viewOrigin.y * rclassicconstants.CULL_COORD_SCALE)
  viewZ = rvisibilitybyteio.truncInt(frame.viewOrigin.z * rclassicconstants.CULL_COORD_SCALE)
  for each draw in pvs.draws
    if not classicVisibilityInsidePreparedFrustum(draw, frustum) then
      frustumCulled = frustumCulled + 1
    else if not classicVisibilityFrontFacingFixed(draw, viewX, viewY, viewZ) then
      backfaceCulled = backfaceCulled + 1
    else
      selected[selectedCount] = draw
      selectedCount = selectedCount + 1
    end if
  end for
  visibleDraws = pvs.draws
  if selectedCount != len(pvs.draws) then
    visibleDraws = compactClassicDraws(selected, selectedCount)
  end if
  return rclassictypes.ClassicVisibilitySelection(
    visibleDraws, pvs.viewLeaf, pvs.viewCluster,
    pvs.pvsCulled, pvs.areaCulled, frustumCulled, backfaceCulled
  )
end function

// Select classic world.
function selectClassicWorld(world, frame)
  return classicVisibilityFinishSelection(
    classicVisibilitySelectPvs(world, frame), frame)
end function

// Product snapshots carry an area-bit array on every frame even when no door
// changed. Key the cached candidate list by its contents as well as cluster;
// treating every non-void array as an override forced a full BSP/PVS scan of
// roughly 7k surfaces every rendered frame.
function selectClassicWorldCached(world, frame)
  if (frame.rdFlags & rc.RDF_NOWORLDMODEL) != 0 then
    return selectClassicWorld(world, frame)
  end if
  viewLeaf = classicVisibilityPointLeaf(world.map, frame.viewOrigin)
  viewCluster = -1
  if viewLeaf >= 0 then viewCluster = world.map.leafs[viewLeaf].cluster end if
  cache = classicVisibilityCacheSlot
  if cache.world == world and cache.cluster == viewCluster and
      classicVisibilityAreaBitsEqual(cache.areaBits, frame.areaBits) then
    cached = ClassicPvsSelection(cache.draws, viewLeaf, viewCluster,
      cache.pvsCulled, cache.areaCulled)
    return classicVisibilityFinishSelection(cached, frame)
  end if
  pvs = classicVisibilitySelectPvs(world, frame)
  cache.world = world
  cache.cluster = pvs.viewCluster
  cache.areaBits = classicVisibilityCopyAreaBits(frame.areaBits)
  cache.draws = pvs.draws
  cache.pvsCulled = pvs.pvsCulled
  cache.areaCulled = pvs.areaCulled
  return classicVisibilityFinishSelection(pvs, frame)
end function

// Return the classic visibility culled count.
function classicVisibilityCulledCount(selection)
  return selection.pvsCulled + selection.areaCulled + selection.frustumCulled + selection.backfaceCulled
end function
