/*
Quake II BSP38 collision model. The public operations mirror the original
CM_PointLeafnum, CM_PointContents, CM_BoxLeafnums, CM_BoxTrace and area-portal
contracts while keeping all runtime state explicit and testable.
*/
package miniquake2.collision.model

import miniquake2.format.types as ft

const DIST_EPSILON = 0.03125

struct CollisionSurface
  name
  flags
  value
end struct

struct TracePlane
  normal
  distance
  type
end struct

struct Trace
  allSolid
  startSolid
  fraction
  endPosition
  plane
  surface
  contents
end struct

struct CollisionModel
  map
  portalOpen
  areaFloods
end struct

function vec3(x, y, z)
  return ft.Vec3(x, y, z)
end function

function requireCollisionVector(value, operation)
  if typeof(value) != "struct" then return error(2814, operation + ": Vec3-shaped value required") end if
  return value
end function

function dot(a, b)
  first = requireCollisionVector(a, "collision dot first operand")
  second = requireCollisionVector(b, "collision dot second operand")
  ax = first.x; ay = first.y; az = first.z
  bx = second.x; by = second.y; bz = second.z
  return ax * bx + ay * by + az * bz
end function

function component(value, axis)
  vector = requireCollisionVector(value, "collision component")
  if axis == 0 then return vector.x end if
  if axis == 1 then return vector.y end if
  return vector.z
end function

function create(map)
  if typeof(map) != "struct" then return error(2815, "collision create requires a BSP map") end if
  mapHolder = map
  portalOpen = array(len(mapHolder.areaPortals), false)
  areaFloods = array(len(mapHolder.areas), 0)
  model = CollisionModel(mapHolder, portalOpen, areaFloods)
  floodAreas(model)
  return model
end function

function pointLeafNumber(model, point, headNode)
  if typeof(model) != "struct" then return error(2816, "pointLeafNumber requires a collision model") end if
  pointHolder = requireCollisionVector(point, "pointLeafNumber point")
  nodeNumber = headNode
  while nodeNumber >= 0
    if nodeNumber >= len(model.map.nodes) then return error(2800, "collision node outside table") end if
    node = model.map.nodes[nodeNumber]
    if node.planeIndex < 0 or node.planeIndex >= len(model.map.planes) then return error(2801, "collision plane outside table") end if
    plane = model.map.planes[node.planeIndex]
    planeNormal = requireCollisionVector(plane.normal, "pointLeafNumber plane normal")
    distance = 0.0
    if plane.type >= 0 and plane.type < 3 then
      distance = component(pointHolder, plane.type) - plane.distance
    else
      distance = dot(pointHolder, planeNormal) - plane.distance
    end if
    if distance < 0.0 then nodeNumber = node.child1 else nodeNumber = node.child0 end if
  end while
  leafNumber = -1 - nodeNumber
  if leafNumber < 0 or leafNumber >= len(model.map.leafs) then return error(2802, "collision leaf outside table") end if
  return leafNumber
end function

function pointContents(model, point, headNode)
  pointHolder = requireCollisionVector(point, "pointContents point")
  leafNumber = pointLeafNumber(model, pointHolder, headNode)
  return model.map.leafs[leafNumber].contents
end function

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
  maxCorner = vec3(minsHolder.x, minsHolder.y, minsHolder.z)
  minCorner = vec3(maxsHolder.x, maxsHolder.y, maxsHolder.z)
  if planeNormal.x >= 0.0 then maxCorner.x = maxsHolder.x; minCorner.x = minsHolder.x end if
  if planeNormal.y >= 0.0 then maxCorner.y = maxsHolder.y; minCorner.y = minsHolder.y end if
  if planeNormal.z >= 0.0 then maxCorner.z = maxsHolder.z; minCorner.z = minsHolder.z end if
  first = dot(maxCorner, planeNormal) - plane.distance
  second = dot(minCorner, planeNormal) - plane.distance
  side = 0
  if first >= 0.0 then side = side | 1 end if
  if second < 0.0 then side = side | 2 end if
  return side
end function

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

function makeDefaultTrace(endPosition)
  endPositionHolder = requireCollisionVector(endPosition, "default trace end position")
  planeNormal = vec3(0.0, 0.0, 0.0)
  tracePlane = TracePlane(planeNormal, 0.0, 0)
  traceSurface = CollisionSurface("", 0, 0)
  return Trace(false, false, 1.0, endPositionHolder, tracePlane, traceSurface, 0)
end function

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

function surfaceForSide(model, side)
  if side.texInfo < 0 or side.texInfo >= len(model.map.texInfo) then return CollisionSurface("", 0, 0) end if
  info = model.map.texInfo[side.texInfo]
  return CollisionSurface(info.texture, info.flags, info.value)
end function

function clipBoxToBrush(model, mins, maxs, start, finish, trace, brush)
  minsHolder = requireCollisionVector(mins, "clipBoxToBrush mins")
  maxsHolder = requireCollisionVector(maxs, "clipBoxToBrush maxs")
  startHolder = requireCollisionVector(start, "clipBoxToBrush start")
  finishHolder = requireCollisionVector(finish, "clipBoxToBrush finish")
  if brush.numSides <= 0 then return trace end if
  enterFraction = -1.0
  leaveFraction = 1.0
  startOutside = false
  getsOutside = false
  leadPlane = void
  leadSurface = CollisionSurface("", 0, 0)
  i = 0
  while i < brush.numSides
    sideIndex = brush.firstSide + i
    if sideIndex < 0 or sideIndex >= len(model.map.brushSides) then return error(2805, "brush side outside table") end if
    side = model.map.brushSides[sideIndex]
    if side.planeIndex < 0 or side.planeIndex >= len(model.map.planes) then return error(2806, "brush plane outside table") end if
    plane = model.map.planes[side.planeIndex]
    planeNormal = requireCollisionVector(plane.normal, "clipBoxToBrush plane normal")
    distance = offsetDistance(plane, minsHolder, maxsHolder)
    d1 = dot(startHolder, planeNormal) - distance
    d2 = dot(finishHolder, planeNormal) - distance
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
          leadSurface = surfaceForSide(model, side)
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
    if getsOutside == false then trace.allSolid = true; trace.fraction = 0.0 end if
    return trace
  end if
  if enterFraction < leaveFraction and enterFraction > -1.0 and enterFraction < trace.fraction then
    if enterFraction < 0.0 then enterFraction = 0.0 end if
    trace.fraction = enterFraction
    leadNormal = requireCollisionVector(leadPlane.normal, "clipBoxToBrush lead plane normal")
    tracePlane = TracePlane(leadNormal, leadPlane.distance, leadPlane.type)
    trace.plane = tracePlane
    trace.surface = leadSurface
    trace.contents = brush.contents
  end if
  return trace
end function

function minValue(a, b)
  if a < b then return a end if
  return b
end function

function maxValue(a, b)
  if a > b then return a end if
  return b
end function

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
  broadMins = vec3(minValue(startX, finishX) + minsX - 1.0, minValue(startY, finishY) + minsY - 1.0, minValue(startZ, finishZ) + minsZ - 1.0)
  broadMaxs = vec3(maxValue(startX, finishX) + maxsX + 1.0, maxValue(startY, finishY) + maxsY + 1.0, maxValue(startZ, finishZ) + maxsZ + 1.0)
  leafNumbers = boxLeafNumbers(model, broadMins, broadMaxs, headNode)
  seen = array(len(model.map.brushes), false)
  i = 0
  while i < len(leafNumbers)
    leaf = model.map.leafs[leafNumbers[i]]
    j = 0
    while j < leaf.numLeafBrushes
      referenceIndex = leaf.firstLeafBrush + j
      if referenceIndex < 0 or referenceIndex >= len(model.map.leafBrushes) then return error(2807, "leaf brush reference outside table") end if
      brushIndex = model.map.leafBrushes[referenceIndex]
      if brushIndex < 0 or brushIndex >= len(model.map.brushes) then return error(2808, "leaf brush outside table") end if
      if seen[brushIndex] == false then
        seen[brushIndex] = true
        brush = model.map.brushes[brushIndex]
        if (brush.contents & brushMask) != 0 then trace = clipBoxToBrush(model, minsHolder, maxsHolder, startHolder, finishHolder, trace, brush) end if
      end if
      j = j + 1
    end while
    i = i + 1
  end while
  endPosition = vec3(startX + trace.fraction * (finishX - startX), startY + trace.fraction * (finishY - startY), startZ + trace.fraction * (finishZ - startZ))
  trace.endPosition = endPosition
  return trace
end function

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

function setAreaPortalState(model, portalNumber, isOpen)
  if portalNumber < 0 or portalNumber >= len(model.portalOpen) then return error(2811, "portal state outside table") end if
  model.portalOpen[portalNumber] = isOpen
  floodAreas(model)
  return true
end function

function areasConnected(model, firstArea, secondArea)
  if firstArea < 0 or firstArea >= len(model.areaFloods) or secondArea < 0 or secondArea >= len(model.areaFloods) then return error(2812, "area outside table") end if
  return model.areaFloods[firstArea] == model.areaFloods[secondArea]
end function

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
