//! Provides miniquake2 renderer classic visibility facilities for this project.

/*
Copyright (C) 1997-2001 Id Software, Inc.
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later

Deterministic BSP38 PVS, marksurface, frustum and backface selection for the
opaque ClassicWorld submission path.
*/
package miniquake2.renderer.classic.visibility

import std.array as rvisibilityarray
import std.bytes as rvisibilitybytes
import std.math as rvisibilitymath
import miniquake2.format.bsp as fbsp
import miniquake2.format.types as ft
import miniquake2.format.constants as fc
import miniquake2.renderer.constants as rc
import miniquake2.renderer.classic.types as rclassictypes
import miniquake2.renderer.classic.constants as rclassicconstants
import miniquake2.qcommon.byteio as rvisibilitybyteio

/// Defines the visibility deg to rad constant used by the miniquake2 renderer classic visibility module.
const VISIBILITY_DEG_TO_RAD = 0.017453292519943295
/// Defines the visibility near constant used by the miniquake2 renderer classic visibility module.
const VISIBILITY_NEAR = 4.0
/// Defines the visibility far constant used by the miniquake2 renderer classic visibility module.
const VISIBILITY_FAR = 8192.0
/// Defines the backface epsilon constant used by the miniquake2 renderer classic visibility module.
const BACKFACE_EPSILON = 0.01

/// Store classic frustum plane data.
struct ClassicFrustumPlane
  /// Stores the normal x value associated with classic frustum plane.
  normalX
  /// Stores the normal y value associated with classic frustum plane.
  normalY
  /// Stores the normal z value associated with classic frustum plane.
  normalZ
  /// Stores the distance value associated with classic frustum plane.
  distance
  /// Stores the abs x value associated with classic frustum plane.
  absX
  /// Stores the abs y value associated with classic frustum plane.
  absY
  /// Stores the abs z value associated with classic frustum plane.
  absZ
end struct

/// Store classic pvs selection data.
struct ClassicPvsSelection
  /// Stores the draws value associated with classic pvs selection.
  draws
  /// Stores the view leaf value associated with classic pvs selection.
  viewLeaf
  /// Stores the view cluster value associated with classic pvs selection.
  viewCluster
  /// Stores the view cluster2 value associated with classic pvs selection.
  viewCluster2
  /// Stores the pvs culled value associated with classic pvs selection.
  pvsCulled
  /// Stores the area culled value associated with classic pvs selection.
  areaCulled
end struct

/// Store classic visibility cache slot data.
struct ClassicVisibilityCacheSlot
  /// Stores the world value associated with classic visibility cache slot.
  world
  /// Stores the cluster value associated with classic visibility cache slot.
  cluster
  /// Stores the cluster2 value associated with classic visibility cache slot.
  cluster2
  /// Stores the area bits value associated with classic visibility cache slot.
  areaBits
  /// Stores the draws value associated with classic visibility cache slot.
  draws
  /// Stores the pvs culled value associated with classic visibility cache slot.
  pvsCulled
  /// Stores the area culled value associated with classic visibility cache slot.
  areaCulled
end struct

/// Primary and water-boundary visibility clusters for one camera origin.
struct ClassicViewClusters
  /// Stores the leaf value associated with classic view clusters.
  leaf
  /// Stores the cluster value associated with classic view clusters.
  cluster
  /// Stores the cluster2 value associated with classic view clusters.
  cluster2
end struct

/// Mutable accumulator for the original far-node / reversed-node / near-node
/// alpha-chain order.
struct ClassicAlphaOrderState
  /// Stores the map value associated with classic alpha order state.
  map
  /// Stores the draw by face value associated with classic alpha order state.
  drawByFace
  /// Stores the marked value associated with classic alpha order state.
  marked
  /// Stores the output value associated with classic alpha order state.
  output
  /// Stores the count value associated with classic alpha order state.
  count
  /// Stores the view origin value associated with classic alpha order state.
  viewOrigin
end struct

/// Minimal per-frame brush bounds used by the frustum culler. Keeping this
/// separate from ClassicWorldDraw avoids allocating empty texture/vertex arrays
/// and a full draw record for every moving door, platform and lift each frame.
struct ClassicBrushBounds
  /// Stores the mins value associated with classic brush bounds.
  mins
  /// Stores the maxs value associated with classic brush bounds.
  maxs
  /// Stores the center x value associated with classic brush bounds.
  centerX
  /// Stores the center y value associated with classic brush bounds.
  centerY
  /// Stores the center z value associated with classic brush bounds.
  centerZ
  /// Stores the extent x value associated with classic brush bounds.
  extentX
  /// Stores the extent y value associated with classic brush bounds.
  extentY
  /// Stores the extent z value associated with classic brush bounds.
  extentZ
end struct

/// Pair the visible brush prefix with the already-computed local camera point
/// so the OpenGL planner does not repeat rotated-axis trigonometry.
struct ClassicBrushSelection
  /// Stores the draws value associated with classic brush selection.
  draws
  /// Stores the count value associated with classic brush selection.
  count
  /// Stores the local view value associated with classic brush selection.
  localView
end struct

/// Store the three view axes in one record. The former `[forward, right, up]`
/// representation allocated an array and three Vec3 values on every frustum
/// build and again for each rotated brush transform.
struct ClassicVisibilityAxes
  /// Stores the forward x value associated with classic visibility axes.
  forwardX
  /// Stores the forward y value associated with classic visibility axes.
  forwardY
  /// Stores the forward z value associated with classic visibility axes.
  forwardZ
  /// Stores the right x value associated with classic visibility axes.
  rightX
  /// Stores the right y value associated with classic visibility axes.
  rightY
  /// Stores the right z value associated with classic visibility axes.
  rightZ
  /// Stores the up x value associated with classic visibility axes.
  upX
  /// Stores the up y value associated with classic visibility axes.
  upY
  /// Stores the up z value associated with classic visibility axes.
  upZ
end struct

/// Stores module-wide classic visibility cache slot state for the miniquake2 renderer classic visibility module.
classicVisibilityCacheSlot = ClassicVisibilityCacheSlot(void, -999999,
  -999999, void,
  [], 0, 0)
/// Stores module-wide classic visibility selection scratch state for the miniquake2 renderer classic visibility module.
classicVisibilitySelectionScratch = []
/// Stores module-wide classic visibility frustum scratch state for the miniquake2 renderer classic visibility module.
classicVisibilityFrustumScratch = [
  ClassicFrustumPlane(0, 0, 0, 0, 0, 0, 0),
  ClassicFrustumPlane(0, 0, 0, 0, 0, 0, 0),
  ClassicFrustumPlane(0, 0, 0, 0, 0, 0, 0),
  ClassicFrustumPlane(0, 0, 0, 0, 0, 0, 0),
  ClassicFrustumPlane(0, 0, 0, 0, 0, 0, 0),
  ClassicFrustumPlane(0, 0, 0, 0, 0, 0, 0)
]

/// Report whether classic visibility area bits equal.
/// @param first first value consumed by this operation.
/// @param second second value consumed by this operation.
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

/// Copy classic visibility area bits.
/// @param value Value consumed or transformed by the operation.
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

/// Return the classic visibility point leaf value.
/// @param map map value consumed by this operation.
/// @param origin origin value consumed by this operation.
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

/// Return the classic visibility area allowed value.
/// @param areaBits areaBits value consumed by this operation.
/// @param area area value consumed by this operation.
function inline classicVisibilityAreaAllowed(areaBits, area)
  if areaBits is void then return true end if
  if area < 0 then return false end if
  byteIndex = area >> 3
  if byteIndex < 0 or byteIndex >= len(areaBits) then return false end if
  return (areaBits[byteIndex] & (1 << (area & 7))) != 0
end function

/// Mark classic visibility leaf faces.
/// @param map map value consumed by this operation.
/// @param leaf leaf value consumed by this operation.
/// @param marked marked value consumed by this operation.
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

/// Return the classic visibility pvs row value.
/// @param map map value consumed by this operation.
/// @param cluster cluster value consumed by this operation.
function classicVisibilityPvsRow(map, cluster)
  visibility = map.visibility
  if visibility is void or visibility.numClusters <= 0 then return bytes(0) end if
  if cluster < 0 or cluster >= visibility.numClusters then return error(9757, "view cluster outside BSP visibility table") end if
  if typeof(visibility.pvsOffsets) != "array" or len(visibility.pvsOffsets) != visibility.numClusters then return error(9758, "BSP PVS offset table is malformed") end if
  return fbsp.decompressVisibility(visibility, cluster, 0)
end function

/// Report whether classic visibility pvs contains.
/// @param row row value consumed by this operation.
/// @param cluster cluster value consumed by this operation.
function inline classicVisibilityPvsContains(row, cluster)
  if cluster < 0 then return false end if
  byteIndex = cluster >> 3
  if byteIndex < 0 or byteIndex >= len(row) then return false end if
  return (row[byteIndex] & (1 << (cluster & 7))) != 0
end function

/// Return the classic visibility angle axes value.
/// @param angles angles value consumed by this operation.
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

/// Match R_SetupFrame's second-cluster probe so crossing a solid water boundary
/// exposes both PVS rows instead of popping the opposite side of the surface.
/// @param map map value consumed by this operation.
/// @param origin origin value consumed by this operation.
function classicVisibilityViewClusters(map, origin)
  viewLeaf = classicVisibilityPointLeaf(map, origin)
  viewCluster = -1; viewCluster2 = -1
  if viewLeaf < 0 then return ClassicViewClusters(viewLeaf, -1, -1) end if
  leaf = map.leafs[viewLeaf]
  viewCluster = leaf.cluster; viewCluster2 = viewCluster
  probeZ = origin.z + 16.0
  if leaf.contents == 0 then probeZ = origin.z - 16.0 end if
  probe = ft.Vec3(origin.x, origin.y, probeZ)
  probeLeafIndex = classicVisibilityPointLeaf(map, probe)
  if probeLeafIndex >= 0 then
    probeLeaf = map.leafs[probeLeafIndex]
    if (probeLeaf.contents & fc.CONTENTS_SOLID) == 0 and
        probeLeaf.cluster != viewCluster2 then
      viewCluster2 = probeLeaf.cluster
    end if
  end if
  return ClassicViewClusters(viewLeaf, viewCluster, viewCluster2)
end function

/// Return the classic visibility box outside plane value.
/// @param draw draw value consumed by this operation.
/// @param plane plane value consumed by this operation.
function inline classicVisibilityBoxOutsidePlane(draw, plane)
  radius = plane.absX * draw.extentX + plane.absY * draw.extentY +
    plane.absZ * draw.extentZ
  distance = plane.normalX * draw.centerX + plane.normalY * draw.centerY +
    plane.normalZ * draw.centerZ - plane.distance
  return distance + radius < -rclassicconstants.CULL_MARGIN
end function

/// Return the classic visibility plane value.
/// @param normalX normalX value consumed by this operation.
/// @param normalY normalY value consumed by this operation.
/// @param normalZ normalZ value consumed by this operation.
/// @param distance distance value consumed by this operation.
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

/// Update one reusable fixed-point frustum plane without allocating a record.
/// @param plane plane value consumed by this operation.
/// @param normalX normalX value consumed by this operation.
/// @param normalY normalY value consumed by this operation.
/// @param normalZ normalZ value consumed by this operation.
/// @param distance distance value consumed by this operation.
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

/// Return the classic visibility frustum value.
/// @param frame frame value consumed by this operation.
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

/// Report whether classic visibility inside prepared frustum.
/// @param draw draw value consumed by this operation.
/// @param planes planes value consumed by this operation.
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

/// Report whether classic visibility inside frustum.
/// @param draw draw value consumed by this operation.
/// @param frame frame value consumed by this operation.
function classicVisibilityInsideFrustum(draw, frame)
  return classicVisibilityInsidePreparedFrustum(draw,
    classicVisibilityFrustum(frame))
end function

/// Test a conservative world-space sphere against the prepared fixed-point
/// frustum. Alias models use this with their current/previous pose union radius
/// so no interpolated vertex can be clipped prematurely.
/// @param origin origin value consumed by this operation.
/// @param radius radius value consumed by this operation.
/// @param frame frame value consumed by this operation.
function classicVisibilitySphereInsideFrustum(origin, radius, frame)
  centerX = rvisibilitybyteio.truncInt(origin.x *
    rclassicconstants.CULL_COORD_SCALE)
  centerY = rvisibilitybyteio.truncInt(origin.y *
    rclassicconstants.CULL_COORD_SCALE)
  centerZ = rvisibilitybyteio.truncInt(origin.z *
    rclassicconstants.CULL_COORD_SCALE)
  extent = rvisibilitybyteio.truncInt(radius *
    rclassicconstants.CULL_COORD_SCALE) + 1
  bounds = ClassicBrushBounds(origin, origin, centerX, centerY, centerZ,
    extent, extent, extent)
  return classicVisibilityInsidePreparedFrustum(bounds,
    classicVisibilityFrustum(frame))
end function

/// Return the classic visibility front facing fixed value.
/// @param draw draw value consumed by this operation.
/// @param viewX viewX value consumed by this operation.
/// @param viewY viewY value consumed by this operation.
/// @param viewZ viewZ value consumed by this operation.
function inline classicVisibilityFrontFacingFixed(draw, viewX, viewY, viewZ)
  distance = viewX * draw.planeNormalX + viewY * draw.planeNormalY +
    viewZ * draw.planeNormalZ - draw.planeDistance
  if draw.planeSide == 0 then
    return distance >= -rclassicconstants.BACKFACE_FIXED_EPSILON
  end if
  return distance <= rclassicconstants.BACKFACE_FIXED_EPSILON
end function

/// Return the classic visibility front facing value.
/// @param draw draw value consumed by this operation.
/// @param viewOrigin viewOrigin value consumed by this operation.
function classicVisibilityFrontFacing(draw, viewOrigin)
  return classicVisibilityFrontFacingFixed(draw,
    rvisibilitybyteio.truncInt(viewOrigin.x * rclassicconstants.CULL_COORD_SCALE),
    rvisibilitybyteio.truncInt(viewOrigin.y * rclassicconstants.CULL_COORD_SCALE),
    rvisibilitybyteio.truncInt(viewOrigin.z * rclassicconstants.CULL_COORD_SCALE))
end function

/// Return the classic visibility brush bounds.
/// @param brushModel brushModel value consumed by this operation.
/// @param entity entity value consumed by this operation.
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

/// Return the classic visibility brush world point value.
/// @param entity entity value consumed by this operation.
/// @param localPoint localPoint value consumed by this operation.
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

/// Return the classic visibility brush local view value.
/// @param entity entity value consumed by this operation.
/// @param viewOrigin viewOrigin value consumed by this operation.
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

/// Report whether classic visibility brush model visible.
/// @param brushModel brushModel value consumed by this operation.
/// @param entity entity value consumed by this operation.
/// @param frame frame value consumed by this operation.
function classicVisibilityBrushModelVisible(brushModel, entity, frame)
  if len(brushModel.draws) == 0 then return false end if
  bounds = classicVisibilityBrushBounds(brushModel, entity)
  return classicVisibilityInsideFrustum(bounds, frame)
end function

/// Report whether classic visibility brush model visible in prepared frustum.
/// @param brushModel brushModel value consumed by this operation.
/// @param entity entity value consumed by this operation.
/// @param planes planes value consumed by this operation.
function classicVisibilityBrushModelVisiblePrepared(brushModel, entity, planes)
  if len(brushModel.draws) == 0 then return false end if
  return classicVisibilityInsidePreparedFrustum(
    classicVisibilityBrushBounds(brushModel, entity), planes)
end function

/// Select a classic brush model using the frame-owned frustum and retain the
/// local view point needed by the special-surface planner.
/// @param brushModel brushModel value consumed by this operation.
/// @param entity entity value consumed by this operation.
/// @param frame frame value consumed by this operation.
/// @param planes planes value consumed by this operation.
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

/// Select classic brush model.
/// @param brushModel brushModel value consumed by this operation.
/// @param entity entity value consumed by this operation.
/// @param frame frame value consumed by this operation.
function selectClassicBrushModel(brushModel, entity, frame)
  selection = selectClassicBrushModelPrepared(brushModel, entity, frame,
    classicVisibilityFrustum(frame))
  if selection.count == len(selection.draws) then return selection.draws end if
  if selection.count == 0 then return array(0) end if
  return rvisibilityarray.slice(selection.draws, 0, selection.count)
end function

/// Return the compact classic draws value.
/// @param values values value consumed by this operation.
/// @param count Number of items or units to process.
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

/// Select classic visibility pvs.
/// @param world world value consumed by this operation.
/// @param frame frame value consumed by this operation.
function classicVisibilitySelectPvs(world, frame)
  // Keep classic visibility select pvs phases explicit: validate inputs, update owned state, then publish the result.
  total = len(world.draws)
  if (frame.rdFlags & rc.RDF_NOWORLDMODEL) != 0 then
    return ClassicPvsSelection(array(0), -1, -1, -1, total, 0)
  end if
  map = world.map
  // One byte per face is sufficient and avoids two pointer-width managed
  // arrays on every PVS cache miss.
  pvsMarked = bytes(len(map.faces))
  areaMarked = bytes(len(map.faces))
  view = classicVisibilityViewClusters(map, frame.viewOrigin)
  viewLeaf = view.leaf; viewCluster = view.cluster
  viewCluster2 = view.cluster2

  if len(map.leafs) == 0 then
    for each draw in world.draws
      pvsMarked[draw.surface.index] = 1
      areaMarked[draw.surface.index] = 1
    end for
  else
    row = bytes(0); row2 = bytes(0)
    if viewCluster >= 0 then row = classicVisibilityPvsRow(map, viewCluster) end if
    if viewCluster2 >= 0 and viewCluster2 != viewCluster then
      row2 = classicVisibilityPvsRow(map, viewCluster2)
    end if
    usePvs = viewCluster >= 0 and len(row) > 0
    leafIndex = 0
    while leafIndex < len(map.leafs)
      leaf = map.leafs[leafIndex]
      clusterVisible = not usePvs
      if usePvs then
        if leaf.cluster >= map.visibility.numClusters then return error(9759, "BSP leaf cluster outside visibility table") end if
        clusterVisible = classicVisibilityPvsContains(row, leaf.cluster)
        if not clusterVisible and len(row2) > 0 then
          clusterVisible = classicVisibilityPvsContains(row2, leaf.cluster)
        end if
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
    viewLeaf, viewCluster, viewCluster2, pvsCulled, areaCulled)
end function

/// Finish classic visibility selection into reusable prefix storage. The count
/// is authoritative; live rendering must not scan the unused capacity tail.
/// @param pvs pvs value consumed by this operation.
/// @param frame frame value consumed by this operation.
function classicVisibilityFinishSelectionPrefix(pvs, frame)
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
  return rclassictypes.ClassicVisibilitySelection(
    selected, selectedCount, pvs.viewLeaf, pvs.viewCluster,
    pvs.pvsCulled, pvs.areaCulled, frustumCulled, backfaceCulled
  )
end function

/// Finish classic visibility selection with a compact public array. This keeps
/// the diagnostic API while product rendering avoids the per-frame copy.
/// @param pvs pvs value consumed by this operation.
/// @param frame frame value consumed by this operation.
function classicVisibilityFinishSelection(pvs, frame)
  prefix = classicVisibilityFinishSelectionPrefix(pvs, frame)
  visibleDraws = compactClassicDraws(prefix.draws, prefix.count)
  return rclassictypes.ClassicVisibilitySelection(
    visibleDraws, prefix.count, prefix.viewLeaf, prefix.viewCluster,
    prefix.pvsCulled, prefix.areaCulled, prefix.frustumCulled,
    prefix.backfaceCulled)
end function

/// Select classic world.
/// @param world world value consumed by this operation.
/// @param frame frame value consumed by this operation.
function selectClassicWorld(world, frame)
  return classicVisibilityFinishSelection(
    classicVisibilitySelectPvs(world, frame), frame)
end function

/// Select the world into reusable prefix storage for live OpenGL submission.
/// @param world world value consumed by this operation.
/// @param frame frame value consumed by this operation.
function selectClassicWorldPrefix(world, frame)
  return classicVisibilityFinishSelectionPrefix(
    classicVisibilitySelectPvs(world, frame), frame)
end function

/// Product snapshots carry an area-bit array on every frame even when no door
/// changed. Key the cached candidate list by its contents as well as cluster;
/// treating every non-void array as an override forced a full BSP/PVS scan of
/// roughly 7k surfaces every rendered frame.
/// @param world world value consumed by this operation.
/// @param frame frame value consumed by this operation.
function selectClassicWorldCached(world, frame)
  if (frame.rdFlags & rc.RDF_NOWORLDMODEL) != 0 then
    return selectClassicWorld(world, frame)
  end if
  view = classicVisibilityViewClusters(world.map, frame.viewOrigin)
  viewLeaf = view.leaf; viewCluster = view.cluster
  viewCluster2 = view.cluster2
  cache = classicVisibilityCacheSlot
  if cache.world == world and cache.cluster == viewCluster and
      cache.cluster2 == viewCluster2 and
      classicVisibilityAreaBitsEqual(cache.areaBits, frame.areaBits) then
    cached = ClassicPvsSelection(cache.draws, viewLeaf, viewCluster,
      viewCluster2,
      cache.pvsCulled, cache.areaCulled)
    return classicVisibilityFinishSelection(cached, frame)
  end if
  pvs = classicVisibilitySelectPvs(world, frame)
  cache.world = world
  cache.cluster = pvs.viewCluster
  cache.cluster2 = pvs.viewCluster2
  cache.areaBits = classicVisibilityCopyAreaBits(frame.areaBits)
  cache.draws = pvs.draws
  cache.pvsCulled = pvs.pvsCulled
  cache.areaCulled = pvs.areaCulled
  return classicVisibilityFinishSelection(pvs, frame)
end function

/// Cached product selection retaining the capacity-sized reusable output.
/// @param world world value consumed by this operation.
/// @param frame frame value consumed by this operation.
function selectClassicWorldCachedPrefix(world, frame)
  if (frame.rdFlags & rc.RDF_NOWORLDMODEL) != 0 then
    return selectClassicWorldPrefix(world, frame)
  end if
  view = classicVisibilityViewClusters(world.map, frame.viewOrigin)
  viewLeaf = view.leaf; viewCluster = view.cluster
  viewCluster2 = view.cluster2
  cache = classicVisibilityCacheSlot
  if cache.world == world and cache.cluster == viewCluster and
      cache.cluster2 == viewCluster2 and
      classicVisibilityAreaBitsEqual(cache.areaBits, frame.areaBits) then
    cached = ClassicPvsSelection(cache.draws, viewLeaf, viewCluster,
      viewCluster2, cache.pvsCulled, cache.areaCulled)
    return classicVisibilityFinishSelectionPrefix(cached, frame)
  end if
  pvs = classicVisibilitySelectPvs(world, frame)
  cache.world = world
  cache.cluster = pvs.viewCluster
  cache.cluster2 = pvs.viewCluster2
  cache.areaBits = classicVisibilityCopyAreaBits(frame.areaBits)
  cache.draws = pvs.draws
  cache.pvsCulled = pvs.pvsCulled
  cache.areaCulled = pvs.areaCulled
  return classicVisibilityFinishSelectionPrefix(pvs, frame)
end function

/// Append one BSP node in the order produced when R_RecursiveWorldNode's
/// front-to-back traversal inserts transparent surfaces at the chain head.
/// @param state Mutable state inspected or updated by the operation.
/// @param nodeIndex Zero-based index of node.
function classicVisibilityAppendAlphaNode(state, nodeIndex)
  if nodeIndex < 0 then return state.count end if
  if nodeIndex >= len(state.map.nodes) then return error(9769,
    "BSP alpha node outside table") end if
  node = state.map.nodes[nodeIndex]
  if node.planeIndex < 0 or node.planeIndex >= len(state.map.planes) then
    return error(9770, "BSP alpha plane outside table")
  end if
  plane = state.map.planes[node.planeIndex]
  origin = state.viewOrigin
  distance = origin.x * plane.normal.x + origin.y * plane.normal.y +
    origin.z * plane.normal.z - plane.distance
  nearChild = node.child0; farChild = node.child1
  if distance < 0.0 then nearChild = node.child1; farChild = node.child0 end if
  classicVisibilityAppendAlphaNode(state, farChild)
  faceIndex = node.firstFace + node.numFaces - 1
  while faceIndex >= node.firstFace
    if faceIndex >= 0 and faceIndex < len(state.marked) and
        state.marked[faceIndex] != 0 then
      state.output[state.count] = state.drawByFace[faceIndex]
      state.count = state.count + 1
    end if
    faceIndex = faceIndex - 1
  end while
  classicVisibilityAppendAlphaNode(state, nearChild)
  return state.count
end function

/// Order visible world alpha polygons exactly like ref_gl's global alpha chain.
/// @param world world value consumed by this operation.
/// @param draws draws value consumed by this operation.
/// @param viewOrigin viewOrigin value consumed by this operation.
function classicVisibilityStockAlphaDraws(world, draws, viewOrigin)
  if len(draws) <= 1 or len(world.map.nodes) == 0 then return draws end if
  drawByFace = array(len(world.map.faces), void)
  marked = bytes(len(world.map.faces))
  for each draw in draws
    faceIndex = draw.surface.index
    if faceIndex >= 0 and faceIndex < len(marked) then
      marked[faceIndex] = 1; drawByFace[faceIndex] = draw
    end if
  end for
  output = array(len(draws))
  headNode = 0
  if len(world.map.models) > 0 then headNode = world.map.models[0].headNode end if
  state = ClassicAlphaOrderState(world.map, drawByFace, marked, output, 0,
    viewOrigin)
  classicVisibilityAppendAlphaNode(state, headNode)
  if state.count == len(draws) then return output end if
  // Malformed or synthetic BSPs can omit node ownership. Preserve their
  // deterministic prepared chain instead of silently dropping a face.
  return draws
end function

/// Order a visible alpha prefix using world-owned scratch storage. This is the
/// live equivalent of classicVisibilityStockAlphaDraws without allocating two
/// face tables and an output array on every rendered frame.
/// @param world world value consumed by this operation.
/// @param draws draws value consumed by this operation.
/// @param drawCount Number of draw to process.
/// @param viewOrigin viewOrigin value consumed by this operation.
function classicVisibilityStockAlphaDrawsPrefix(world, draws, drawCount,
    viewOrigin)
  if drawCount <= 1 or len(world.map.nodes) == 0 then return draws end if
  drawByFace = world.alphaDrawByFaceScratch
  marked = world.alphaMarkedScratch
  rvisibilitybytes.fill(marked, 0)
  drawIndex = 0
  while drawIndex < drawCount
    draw = draws[drawIndex]
    faceIndex = draw.surface.index
    if faceIndex >= 0 and faceIndex < len(marked) then
      marked[faceIndex] = 1
      drawByFace[faceIndex] = draw
    end if
    drawIndex = drawIndex + 1
  end while
  output = world.alphaOutputScratch
  headNode = 0
  if len(world.map.models) > 0 then headNode = world.map.models[0].headNode end if
  state = ClassicAlphaOrderState(world.map, drawByFace, marked, output, 0,
    viewOrigin)
  classicVisibilityAppendAlphaNode(state, headNode)
  if state.count == drawCount then return output end if
  return draws
end function

/// Return the classic visibility culled count.
/// @param selection selection value consumed by this operation.
function classicVisibilityCulledCount(selection)
  return selection.pvsCulled + selection.areaCulled + selection.frustumCulled + selection.backfaceCulled
end function
