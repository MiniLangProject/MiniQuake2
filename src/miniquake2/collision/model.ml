/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/*
Quake II BSP38 collision model. The public operations mirror the original
CM_PointLeafnum, CM_PointContents, CM_BoxLeafnums, CM_BoxTrace and area-portal
contracts while keeping all runtime state explicit and testable.
*/
package miniquake2.collision.model

import miniquake2.format.types as ft
import miniquake2.format.bsp as cbsp

const DIST_EPSILON = 0.03125

// Store collision surface data.
struct CollisionSurface
  name
  flags
  value
end struct

// Store trace plane data.
struct TracePlane
  normal
  distance
  type
end struct

// Store trace data.
struct Trace
  allSolid
  startSolid
  fraction
  endPosition
  plane
  surface
  contents
end struct

// Store collision model data.
struct CollisionModel
  map
  portalOpen
  areaFloods
  traceLeafScratch
  brushCheckCounts
  traceCheckCount
  traceBroadMins
  traceBroadMaxs
  traceNodeStack
  traceP1FractionStack
  traceP2FractionStack
  traceP1XStack
  traceP1YStack
  traceP1ZStack
  traceP2XStack
  traceP2YStack
  traceP2ZStack
  pvsRows
  phsRows
end struct

// Return the vec 3 value.
function vec3(x, y, z)
  return ft.Vec3(x, y, z)
end function

// Require collision vector.
function requireCollisionVector(value, operation)
  if typeof(value) != "struct" then return error(2814, operation + ": Vec3-shaped value required") end if
  return value
end function

// Compute state.
function dot(a, b)
  first = requireCollisionVector(a, "collision dot first operand")
  second = requireCollisionVector(b, "collision dot second operand")
  ax = first.x; ay = first.y; az = first.z
  bx = second.x; by = second.y; bz = second.z
  return ax * bx + ay * by + az * bz
end function

// Return the component value.
function component(value, axis)
  vector = requireCollisionVector(value, "collision component")
  if axis == 0 then return vector.x end if
  if axis == 1 then return vector.y end if
  return vector.z
end function

// Create state.
function create(map)
  if typeof(map) != "struct" then return error(2815, "collision create requires a BSP map") end if
  mapHolder = map
  portalOpen = array(len(mapHolder.areaPortals), false)
  areaFloods = array(len(mapHolder.areas), 0)
  traceLeafScratch = array(len(mapHolder.leafs), 0)
  brushCheckCounts = array(len(mapHolder.brushes), 0)
  traceBroadMins = vec3(0.0, 0.0, 0.0)
  traceBroadMaxs = vec3(0.0, 0.0, 0.0)
  traceStackCapacity = len(mapHolder.nodes) + 1
  traceNodeStack = array(traceStackCapacity, 0)
  traceP1FractionStack = array(traceStackCapacity, 0.0)
  traceP2FractionStack = array(traceStackCapacity, 0.0)
  traceP1XStack = array(traceStackCapacity, 0.0)
  traceP1YStack = array(traceStackCapacity, 0.0)
  traceP1ZStack = array(traceStackCapacity, 0.0)
  traceP2XStack = array(traceStackCapacity, 0.0)
  traceP2YStack = array(traceStackCapacity, 0.0)
  traceP2ZStack = array(traceStackCapacity, 0.0)
  visibilityClusters = mapHolder.visibility.numClusters
  pvsRows = array(visibilityClusters, void)
  phsRows = array(visibilityClusters, void)
  model = CollisionModel(mapHolder, portalOpen, areaFloods,
    traceLeafScratch, brushCheckCounts, 0, traceBroadMins, traceBroadMaxs,
    traceNodeStack, traceP1FractionStack, traceP2FractionStack,
    traceP1XStack, traceP1YStack, traceP1ZStack,
    traceP2XStack, traceP2YStack, traceP2ZStack,
    pvsRows, phsRows)
  floodAreas(model)
  return model
end function

// Return the point leaf number.
function pointLeafNumber(model, point, headNode)
  if typeof(model) != "struct" then return error(2816, "pointLeafNumber requires a collision model") end if
  pointHolder = requireCollisionVector(point, "pointLeafNumber point")
  nodeNumber = headNode
  while nodeNumber >= 0
    if nodeNumber >= len(model.map.nodes) then return error(2800, "collision node outside table") end if
    node = model.map.nodes[nodeNumber]
    if node.planeIndex < 0 or node.planeIndex >= len(model.map.planes) then return error(2801, "collision plane outside table") end if
    plane = model.map.planes[node.planeIndex]
    planeNormal = plane.normal
    distance = 0.0
    if plane.type == 0 then distance = pointHolder.x - plane.distance
    else if plane.type == 1 then distance = pointHolder.y - plane.distance
    else if plane.type == 2 then distance = pointHolder.z - plane.distance
    else distance = pointHolder.x * planeNormal.x + pointHolder.y * planeNormal.y +
      pointHolder.z * planeNormal.z - plane.distance
    end if
    if distance < 0.0 then nodeNumber = node.child1 else nodeNumber = node.child0 end if
  end while
  leafNumber = -1 - nodeNumber
  if leafNumber < 0 or leafNumber >= len(model.map.leafs) then return error(2802, "collision leaf outside table") end if
  return leafNumber
end function

// BSP visibility lumps are immutable after load in the product. Cache each
// decompressed cluster row once, matching the original engine's pointer-like
// visibility access instead of rebuilding RLE output for every entity/sound.
function visibilityRow(model, cluster, kind)
  if typeof(model) != "struct" then return error(2816, "visibilityRow requires a collision model") end if
  visibility = model.map.visibility
  if visibility is void or visibility.numClusters == 0 then return bytes() end if
  if cluster < 0 or cluster >= visibility.numClusters then
    return error(2818, "visibility cluster outside table")
  end if
  cache = model.pvsRows
  if kind == 1 then cache = model.phsRows end if
  cached = cache[cluster]
  if typeof(cached) == "bytes" then return cached end if
  row = cbsp.decompressVisibility(visibility, cluster, kind)
  cache[cluster] = row
  return row
end function

// Clear visibility rows.
function clearVisibilityRows(model)
  clusters = model.map.visibility.numClusters
  model.pvsRows = array(clusters, void)
  model.phsRows = array(clusters, void)
  return true
end function

// Return the point contents value.
function pointContents(model, point, headNode)
  pointHolder = requireCollisionVector(point, "pointContents point")
  leafNumber = pointLeafNumber(model, pointHolder, headNode)
  return model.map.leafs[leafNumber].contents
end function

// Report whether box on plane side.
function boxOnPlaneSide(mins, maxs, plane)
  minsHolder = requireCollisionVector(mins, "boxOnPlaneSide mins")
  maxsHolder = requireCollisionVector(maxs, "boxOnPlaneSide maxs")
  if typeof(plane) != "struct" then return error(2817, "boxOnPlaneSide requires a plane") end if
  planeNormal = requireCollisionVector(plane.normal, "boxOnPlaneSide plane normal")
  if plane.type >= 0 and plane.type < 3 then
    if component(minsHolder, plane.type) >= plane.distance then return 1 end if
    if component(maxsHolder, plane.type) < plane.distance then return 2 end if
    return 3
  end if
  maxX = minsHolder.x; minX = maxsHolder.x
  maxY = minsHolder.y; minY = maxsHolder.y
  maxZ = minsHolder.z; minZ = maxsHolder.z
  if planeNormal.x >= 0.0 then maxX = maxsHolder.x; minX = minsHolder.x end if
  if planeNormal.y >= 0.0 then maxY = maxsHolder.y; minY = minsHolder.y end if
  if planeNormal.z >= 0.0 then maxZ = maxsHolder.z; minZ = minsHolder.z end if
  first = maxX * planeNormal.x + maxY * planeNormal.y + maxZ * planeNormal.z - plane.distance
  second = minX * planeNormal.x + minY * planeNormal.y + minZ * planeNormal.z - plane.distance
  side = 0
  if first >= 0.0 then side = side | 1 end if
  if second < 0.0 then side = side | 2 end if
  return side
end function

// Collect box leafs.
function collectBoxLeafs(model, nodeNumber, mins, maxs, output, count)
  if nodeNumber < 0 then
    leafNumber = -1 - nodeNumber
    if leafNumber < 0 or leafNumber >= len(model.map.leafs) then return error(2803, "box traversal leaf outside table") end if
    if count < len(output) then output[count] = leafNumber; count = count + 1 end if
    return count
  end if
  if nodeNumber >= len(model.map.nodes) then return error(2804, "box traversal node outside table") end if
  node = model.map.nodes[nodeNumber]
  plane = model.map.planes[node.planeIndex]
  side = boxOnPlaneSide(mins, maxs, plane)
  if side == 1 then return collectBoxLeafs(model, node.child0, mins, maxs, output, count) end if
  if side == 2 then return collectBoxLeafs(model, node.child1, mins, maxs, output, count) end if
  count = collectBoxLeafs(model, node.child0, mins, maxs, output, count)
  return collectBoxLeafs(model, node.child1, mins, maxs, output, count)
end function

// Return the box leaf numbers value.
function boxLeafNumbers(model, mins, maxs, headNode)
  minsHolder = requireCollisionVector(mins, "boxLeafNumbers mins")
  maxsHolder = requireCollisionVector(maxs, "boxLeafNumbers maxs")
  output = array(len(model.map.leafs), 0)
  count = collectBoxLeafs(model, headNode, minsHolder, maxsHolder, output, 0)
  compact = array(count, 0)
  i = 0
  while i < count
    compact[i] = output[i]
    i = i + 1
  end while
  return compact
end function

// Create default trace.
function makeDefaultTrace(endPosition)
  endPositionHolder = requireCollisionVector(endPosition, "default trace end position")
  planeNormal = vec3(0.0, 0.0, 0.0)
  tracePlane = TracePlane(planeNormal, 0.0, 0)
  traceSurface = CollisionSurface("", 0, 0)
  return Trace(false, false, 1.0, endPositionHolder, tracePlane, traceSurface, 0)
end function

// Return the offset distance value.
function offsetDistance(plane, mins, maxs)
  minsHolder = requireCollisionVector(mins, "offsetDistance mins")
  maxsHolder = requireCollisionVector(maxs, "offsetDistance maxs")
  planeNormal = requireCollisionVector(plane.normal, "offsetDistance plane normal")
  ox = minsHolder.x
  oy = minsHolder.y
  oz = minsHolder.z
  if planeNormal.x < 0.0 then ox = maxsHolder.x end if
  if planeNormal.y < 0.0 then oy = maxsHolder.y end if
  if planeNormal.z < 0.0 then oz = maxsHolder.z end if
  return plane.distance - (ox * planeNormal.x + oy * planeNormal.y + oz * planeNormal.z)
end function

// Return the surface for side value.
function surfaceForSide(model, side)
  if side.texInfo < 0 or side.texInfo >= len(model.map.texInfo) then return CollisionSurface("", 0, 0) end if
  info = model.map.texInfo[side.texInfo]
  return CollisionSurface(info.texture, info.flags, info.value)
end function

// Clip box to brush.
function inline clipBoxToBrush(model, mins, maxs, start, finish, trace, brush)
  // Keep clip box to brush phases explicit: validate inputs, update owned state, then publish the result.
  minsHolder = mins
  maxsHolder = maxs
  startHolder = start
  finishHolder = finish
  if brush.numSides <= 0 then return trace end if
  enterFraction = -1.0
  leaveFraction = 1.0
  startOutside = false
  getsOutside = false
  leadPlane = void
  leadSide = void
  i = 0
  while i < brush.numSides
    sideIndex = brush.firstSide + i
    if sideIndex < 0 or sideIndex >= len(model.map.brushSides) then return error(2805, "brush side outside table") end if
    side = model.map.brushSides[sideIndex]
    if side.planeIndex < 0 or side.planeIndex >= len(model.map.planes) then return error(2806, "brush plane outside table") end if
    plane = model.map.planes[side.planeIndex]
    planeNormal = plane.normal
    offsetX = minsHolder.x; offsetY = minsHolder.y; offsetZ = minsHolder.z
    if planeNormal.x < 0.0 then offsetX = maxsHolder.x end if
    if planeNormal.y < 0.0 then offsetY = maxsHolder.y end if
    if planeNormal.z < 0.0 then offsetZ = maxsHolder.z end if
    distance = plane.distance - (offsetX * planeNormal.x +
      offsetY * planeNormal.y + offsetZ * planeNormal.z)
    d1 = startHolder.x * planeNormal.x + startHolder.y * planeNormal.y +
      startHolder.z * planeNormal.z - distance
    d2 = finishHolder.x * planeNormal.x + finishHolder.y * planeNormal.y +
      finishHolder.z * planeNormal.z - distance
    if d2 > 0.0 then getsOutside = true end if
    if d1 > 0.0 then startOutside = true end if
    if d1 > 0.0 and d2 >= d1 then return trace end if
    if d1 > 0.0 or d2 > 0.0 then
      denominator = d1 - d2
      if d1 > d2 then
        fraction = (d1 - DIST_EPSILON) / denominator
        if fraction > enterFraction then
          enterFraction = fraction
          leadPlane = plane
          leadSide = side
        end if
      else
        fraction = (d1 + DIST_EPSILON) / denominator
        if fraction < leaveFraction then leaveFraction = fraction end if
      end if
    end if
    i = i + 1
  end while
  if startOutside == false then
    trace.startSolid = true
    trace.contents = brush.contents
    if getsOutside == false then trace.allSolid = true end if
    return trace
  end if
  if enterFraction < leaveFraction and enterFraction > -1.0 and enterFraction < trace.fraction then
    if enterFraction < 0.0 then enterFraction = 0.0 end if
    trace.fraction = enterFraction
    leadNormal = leadPlane.normal
    tracePlane = TracePlane(leadNormal, leadPlane.distance, leadPlane.type)
    trace.plane = tracePlane
    trace.surface = surfaceForSide(model, leadSide)
    trace.contents = brush.contents
  end if
  return trace
end function

// Return the min value.
function minValue(a, b)
  if a < b then return a end if
  return b
end function

// Return the max value.
function maxValue(a, b)
  if a > b then return a end if
  return b
end function

// Exact CM_TestBoxInBrush position test. Swept traces use the recursive BSP
// hull walk below; a stationary hull must instead visit every leaf touched by
// its expanded bounds and test whether the complete box starts in a brush.
function inline testBoxInBrush(model, mins, maxs, start, trace, brush)
  if brush.numSides <= 0 then return trace end if
  i = 0
  while i < brush.numSides
    side = model.map.brushSides[brush.firstSide + i]
    plane = model.map.planes[side.planeIndex]
    planeNormal = plane.normal
    offsetX = mins.x; offsetY = mins.y; offsetZ = mins.z
    if planeNormal.x < 0.0 then offsetX = maxs.x end if
    if planeNormal.y < 0.0 then offsetY = maxs.y end if
    if planeNormal.z < 0.0 then offsetZ = maxs.z end if
    distance = plane.distance - (offsetX * planeNormal.x +
      offsetY * planeNormal.y + offsetZ * planeNormal.z)
    d1 = start.x * planeNormal.x + start.y * planeNormal.y +
      start.z * planeNormal.z - distance
    if d1 > 0.0 then return trace end if
    i = i + 1
  end while
  trace.startSolid = true
  trace.allSolid = true
  trace.fraction = 0.0
  trace.contents = brush.contents
  return trace
end function

// Verify in leaf.
function testInLeaf(model, leafNumber, mins, maxs, start, brushMask, trace, checkCount)
  leaf = model.map.leafs[leafNumber]
  if (leaf.contents & brushMask) == 0 then return trace end if
  i = 0
  while i < leaf.numLeafBrushes
    brushIndex = model.map.leafBrushes[leaf.firstLeafBrush + i]
    if model.brushCheckCounts[brushIndex] != checkCount then
      model.brushCheckCounts[brushIndex] = checkCount
      brush = model.map.brushes[brushIndex]
      if (brush.contents & brushMask) != 0 then
        trace = testBoxInBrush(model, mins, maxs, start, trace, brush)
        if trace.fraction == 0.0 then return trace end if
      end if
    end if
    i = i + 1
  end while
  return trace
end function

// Exact CM_TraceToLeaf brush filtering with a generation table instead of
// clearing/copying a brush array for every trace.
function inline traceToLeaf(model, leafNumber, mins, maxs, start, finish,
    brushMask, trace, checkCount)
  leaf = model.map.leafs[leafNumber]
  if (leaf.contents & brushMask) == 0 then return trace end if
  i = 0
  while i < leaf.numLeafBrushes
    brushIndex = model.map.leafBrushes[leaf.firstLeafBrush + i]
    if model.brushCheckCounts[brushIndex] != checkCount then
      model.brushCheckCounts[brushIndex] = checkCount
      brush = model.map.brushes[brushIndex]
      if (brush.contents & brushMask) != 0 then
        trace = clipBoxToBrush(model, mins, maxs, start, finish, trace, brush)
        if trace.fraction == 0.0 then return trace end if
      end if
    end if
    i = i + 1
  end while
  return trace
end function

// Quake II CM_RecursiveHullCheck as an allocation-free iterative DFS. A
// MiniLang function call carries dynamic values, so the original C recursion
// is substantially more expensive here. The preallocated per-map stack keeps
// identical near-before-far BSP traversal and fraction pruning semantics.
function hullCheck(model, headNode, startX, startY, startZ,
    finishX, finishY, finishZ, mins, maxs, start, finish,
    brushMask, trace, checkCount, isPoint, extentX, extentY, extentZ)
  nodeStack = model.traceNodeStack
  p1FractionStack = model.traceP1FractionStack
  p2FractionStack = model.traceP2FractionStack
  p1XStack = model.traceP1XStack; p1YStack = model.traceP1YStack
  p1ZStack = model.traceP1ZStack; p2XStack = model.traceP2XStack
  p2YStack = model.traceP2YStack; p2ZStack = model.traceP2ZStack
  stackCount = 0
  nodeNumber = headNode
  p1Fraction = 0.0; p2Fraction = 1.0
  p1x = startX; p1y = startY; p1z = startZ
  p2x = finishX; p2y = finishY; p2z = finishZ

  while true
    if trace.fraction > p1Fraction then
      if nodeNumber < 0 then
        trace = traceToLeaf(model, -1 - nodeNumber, mins, maxs, start,
          finish, brushMask, trace, checkCount)
      else
        node = model.map.nodes[nodeNumber]
        plane = model.map.planes[node.planeIndex]
        planeNormal = plane.normal
        t1 = 0.0; t2 = 0.0; offset = 0.0
        if plane.type == 0 then
          t1 = p1x - plane.distance
          t2 = p2x - plane.distance
          offset = extentX
        else if plane.type == 1 then
          t1 = p1y - plane.distance
          t2 = p2y - plane.distance
          offset = extentY
        else if plane.type == 2 then
          t1 = p1z - plane.distance
          t2 = p2z - plane.distance
          offset = extentZ
        else
          t1 = planeNormal.x * p1x + planeNormal.y * p1y +
            planeNormal.z * p1z - plane.distance
          t2 = planeNormal.x * p2x + planeNormal.y * p2y +
            planeNormal.z * p2z - plane.distance
          if isPoint == false then
            nx = planeNormal.x; ny = planeNormal.y; nz = planeNormal.z
            if nx < 0.0 then nx = -nx end if
            if ny < 0.0 then ny = -ny end if
            if nz < 0.0 then nz = -nz end if
            offset = extentX * nx + extentY * ny + extentZ * nz
          end if
        end if

        if t1 >= offset and t2 >= offset then
          nodeNumber = node.child0
          continue
        end if
        if t1 < -offset and t2 < -offset then
          nodeNumber = node.child1
          continue
        end if

        side = 0
        fraction = 0.0; fraction2 = 0.0
        if t1 < t2 then
          inverseDistance = 1.0 / (t1 - t2)
          side = 1
          fraction2 = (t1 + offset + DIST_EPSILON) * inverseDistance
          fraction = (t1 - offset + DIST_EPSILON) * inverseDistance
        else if t1 > t2 then
          inverseDistance = 1.0 / (t1 - t2)
          fraction2 = (t1 - offset - DIST_EPSILON) * inverseDistance
          fraction = (t1 + offset + DIST_EPSILON) * inverseDistance
        else
          fraction = 1.0
        end if

        if fraction < 0.0 then fraction = 0.0 end if
        if fraction > 1.0 then fraction = 1.0 end if
        nearFraction = p1Fraction + (p2Fraction - p1Fraction) * fraction
        nearX = p1x + fraction * (p2x - p1x)
        nearY = p1y + fraction * (p2y - p1y)
        nearZ = p1z + fraction * (p2z - p1z)

        if fraction2 < 0.0 then fraction2 = 0.0 end if
        if fraction2 > 1.0 then fraction2 = 1.0 end if
        farFraction = p1Fraction + (p2Fraction - p1Fraction) * fraction2
        farX = p1x + fraction2 * (p2x - p1x)
        farY = p1y + fraction2 * (p2y - p1y)
        farZ = p1z + fraction2 * (p2z - p1z)

        // Save the far segment and immediately descend through the near side.
        if side == 0 then nodeStack[stackCount] = node.child1
        else nodeStack[stackCount] = node.child0
        end if
        p1FractionStack[stackCount] = farFraction
        p2FractionStack[stackCount] = p2Fraction
        p1XStack[stackCount] = farX; p1YStack[stackCount] = farY
        p1ZStack[stackCount] = farZ; p2XStack[stackCount] = p2x
        p2YStack[stackCount] = p2y; p2ZStack[stackCount] = p2z
        stackCount = stackCount + 1

        if side == 0 then nodeNumber = node.child0
        else nodeNumber = node.child1
        end if
        p2Fraction = nearFraction
        p2x = nearX; p2y = nearY; p2z = nearZ
        continue
      end if
    end if

    if stackCount == 0 then return trace end if
    stackCount = stackCount - 1
    nodeNumber = nodeStack[stackCount]
    p1Fraction = p1FractionStack[stackCount]
    p2Fraction = p2FractionStack[stackCount]
    p1x = p1XStack[stackCount]; p1y = p1YStack[stackCount]
    p1z = p1ZStack[stackCount]; p2x = p2XStack[stackCount]
    p2y = p2YStack[stackCount]; p2z = p2ZStack[stackCount]
  end while
end function

// Trace box.
function boxTrace(model, start, finish, mins, maxs, headNode, brushMask)
  if typeof(model) != "struct" then return error(2816, "boxTrace requires a collision model") end if
  startHolder = requireCollisionVector(start, "boxTrace start")
  finishHolder = requireCollisionVector(finish, "boxTrace finish")
  minsHolder = requireCollisionVector(mins, "boxTrace mins")
  maxsHolder = requireCollisionVector(maxs, "boxTrace maxs")
  startX = startHolder.x; startY = startHolder.y; startZ = startHolder.z
  finishX = finishHolder.x; finishY = finishHolder.y; finishZ = finishHolder.z
  minsX = minsHolder.x; minsY = minsHolder.y; minsZ = minsHolder.z
  maxsX = maxsHolder.x; maxsY = maxsHolder.y; maxsZ = maxsHolder.z
  trace = makeDefaultTrace(finishHolder)
  model.traceCheckCount = model.traceCheckCount + 1
  checkCount = model.traceCheckCount

  // CM_BoxTrace's stationary position-test special case.
  if startX == finishX and startY == finishY and startZ == finishZ then
    broadMins = model.traceBroadMins
    broadMaxs = model.traceBroadMaxs
    broadMins.x = startX + minsX - 1.0
    broadMins.y = startY + minsY - 1.0
    broadMins.z = startZ + minsZ - 1.0
    broadMaxs.x = startX + maxsX + 1.0
    broadMaxs.y = startY + maxsY + 1.0
    broadMaxs.z = startZ + maxsZ + 1.0
    leafNumbers = model.traceLeafScratch
    leafCount = collectBoxLeafs(model, headNode, broadMins, broadMaxs,
      leafNumbers, 0)
    i = 0
    while i < leafCount
      trace = testInLeaf(model, leafNumbers[i], minsHolder, maxsHolder,
        startHolder, brushMask, trace, checkCount)
      if trace.allSolid then i = leafCount else i = i + 1 end if
    end while
  else
    isPoint = minsX == 0.0 and minsY == 0.0 and minsZ == 0.0 and
      maxsX == 0.0 and maxsY == 0.0 and maxsZ == 0.0
    extentX = 0.0; extentY = 0.0; extentZ = 0.0
    if isPoint == false then
      extentX = maxsX; if -minsX > extentX then extentX = -minsX end if
      extentY = maxsY; if -minsY > extentY then extentY = -minsY end if
      extentZ = maxsZ; if -minsZ > extentZ then extentZ = -minsZ end if
    end if
    trace = hullCheck(model, headNode, startX, startY, startZ,
      finishX, finishY, finishZ, minsHolder, maxsHolder, startHolder,
      finishHolder, brushMask, trace, checkCount, isPoint,
      extentX, extentY, extentZ)
  end if
  endPosition = vec3(startX + trace.fraction * (finishX - startX), startY + trace.fraction * (finishY - startY), startZ + trace.fraction * (finishZ - startZ))
  trace.endPosition = endPosition
  return trace
end function

// Return the flood area value.
function floodArea(model, areaNumber, floodNumber)
  if areaNumber <= 0 or areaNumber >= len(model.map.areas) then return true end if
  if model.areaFloods[areaNumber] != 0 then return true end if
  model.areaFloods[areaNumber] = floodNumber
  area = model.map.areas[areaNumber]
  i = 0
  while i < area.numAreaPortals
    portalIndex = area.firstAreaPortal + i
    if portalIndex < 0 or portalIndex >= len(model.map.areaPortals) then return error(2809, "area portal outside table") end if
    portal = model.map.areaPortals[portalIndex]
    if portal.portalNumber < 0 or portal.portalNumber >= len(model.portalOpen) then return error(2810, "portal number outside state table") end if
    if model.portalOpen[portal.portalNumber] then floodArea(model, portal.otherArea, floodNumber) end if
    i = i + 1
  end while
  return true
end function

// Return the flood areas value.
function floodAreas(model)
  model.areaFloods = array(len(model.map.areas), 0)
  floodNumber = 0
  i = 1
  while i < len(model.map.areas)
    if model.areaFloods[i] == 0 then floodNumber = floodNumber + 1; floodArea(model, i, floodNumber) end if
    i = i + 1
  end while
  return floodNumber
end function

// Set area portal state.
function setAreaPortalState(model, portalNumber, isOpen)
  if portalNumber < 0 or portalNumber >= len(model.portalOpen) then return error(2811, "portal state outside table") end if
  model.portalOpen[portalNumber] = isOpen
  floodAreas(model)
  return true
end function

// Report whether areas connected.
function areasConnected(model, firstArea, secondArea)
  if firstArea < 0 or firstArea >= len(model.areaFloods) or secondArea < 0 or secondArea >= len(model.areaFloods) then return error(2812, "area outside table") end if
  return model.areaFloods[firstArea] == model.areaFloods[secondArea]
end function

// Write area bits.
function writeAreaBits(model, areaNumber)
  if areaNumber < 0 or areaNumber >= len(model.areaFloods) then return error(2813, "area outside table") end if
  output = bytes((len(model.areaFloods) + 7) >> 3)
  floodNumber = model.areaFloods[areaNumber]
  i = 0
  while i < len(model.areaFloods)
    if areaNumber == 0 or model.areaFloods[i] == floodNumber then output[i >> 3] = output[i >> 3] | (1 << (i & 7)) end if
    i = i + 1
  end while
  return output
end function
