/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Synthetic BSP38 PVS, marksurface, area, frustum and backface selection. */
import miniquake2.format.types as ft
import miniquake2.qcommon.types as qt
import miniquake2.renderer.types as rt
import miniquake2.renderer.opengl as ropengl
import miniquake2.renderer.classic.visibility as rclassicvisibility

// Assert the equal test condition.
function assertEqual(actual, expected, name)
  if actual != expected then return error(7996, name + ": expected " + expected + ", got " + actual) end if
end function

// Write u 32.
function putU32(data, offset, value)
  data[offset] = value & 255; data[offset + 1] = (value >> 8) & 255
  data[offset + 2] = (value >> 16) & 255; data[offset + 3] = (value >> 24) & 255
end function

// Write text.
function putText(data, offset, value)
  encoded = bytes(value)
  index = 0
  while index < len(encoded)
    data[offset + index] = encoded[index]
    index = index + 1
  end while
end function

// Return the visibility palette pcx value.
function visibilityPalettePcx()
  data = bytes(899)
  data[0] = 0x0a; data[1] = 5; data[2] = 1; data[3] = 8
  data[8] = 1; data[65] = 1; data[66] = 2
  data[128] = 1; data[129] = 1; data[130] = 12
  data[134] = 64; data[135] = 96; data[136] = 128
  return data
end function

// Return the visibility wal value.
function visibilityWal()
  data = bytes(107)
  putText(data, 0, "wall")
  putU32(data, 32, 2); putU32(data, 36, 2)
  putU32(data, 40, 100); putU32(data, 44, 104); putU32(data, 48, 105); putU32(data, 52, 106)
  data[100] = 1; data[101] = 1; data[102] = 1; data[103] = 1
  data[104] = 1; data[105] = 1; data[106] = 1
  return data
end function

// Load visibility file.
function loadVisibilityFile(path)
  if path == "pics/colormap.pcx" then return visibilityPalettePcx() end if
  if path == "textures/wall.wal" then return visibilityWal() end if
  return void
end function

// Map visibility.
function visibilityMap()
  vertices = [
    ft.BspVertex(ft.Vec3(10.0, 2.0, -2.0)), ft.BspVertex(ft.Vec3(10.0, 6.0, -2.0)),
    ft.BspVertex(ft.Vec3(10.0, 6.0, 2.0)), ft.BspVertex(ft.Vec3(10.0, 2.0, 2.0)),
    ft.BspVertex(ft.Vec3(20.0, -6.0, -2.0)), ft.BspVertex(ft.Vec3(20.0, -2.0, -2.0)),
    ft.BspVertex(ft.Vec3(20.0, -2.0, 2.0)), ft.BspVertex(ft.Vec3(20.0, -6.0, 2.0))
  ]
  edges = [
    ft.BspEdge(0, 1), ft.BspEdge(1, 2), ft.BspEdge(2, 3), ft.BspEdge(3, 0),
    ft.BspEdge(4, 5), ft.BspEdge(5, 6), ft.BspEdge(6, 7), ft.BspEdge(7, 4)
  ]
  nodePlane = ft.BspPlane(ft.Vec3(0.0, 1.0, 0.0), 0.0, 1)
  facePlane0 = ft.BspPlane(ft.Vec3(-1.0, 0.0, 0.0), -10.0, 0)
  facePlane1 = ft.BspPlane(ft.Vec3(-1.0, 0.0, 0.0), -20.0, 0)
  node = ft.BspNode(0, -1, -2, ft.Vec3(-64.0, -64.0, -64.0), ft.Vec3(64.0, 64.0, 64.0), 0, 2)
  texInfo = ft.BspTexInfo([0.0, 1.0, 0.0, 0.0], [0.0, 0.0, 1.0, 0.0], 0, 0, "wall", -1)
  faces = [
    ft.BspFace(1, 0, 0, 4, 0, bytes([0, 255, 255, 255]), -1),
    ft.BspFace(2, 0, 4, 4, 0, bytes([0, 255, 255, 255]), -1)
  ]
  leaf0 = ft.BspLeaf(0, 0, 0, ft.Vec3(-64.0, 0.0, -64.0), ft.Vec3(64.0, 64.0, 64.0), 0, 2, 0, 0)
  leaf1 = ft.BspLeaf(0, 1, 1, ft.Vec3(-64.0, -64.0, -64.0), ft.Vec3(64.0, -1.0, 64.0), 2, 1, 0, 0)
  visibility = ft.BspVisibility(2, [0, 1], [0, 1], bytes([1, 2]))
  model = ft.BspModel(ft.Vec3(-64.0, -64.0, -64.0), ft.Vec3(64.0, 64.0, 64.0), ft.Vec3(0.0, 0.0, 0.0), 0, 0, 2)
  return ft.BspMap(
    "visibility", bytes(0), [], "", [nodePlane, facePlane0, facePlane1], vertices,
    visibility, [node], [texInfo], faces, bytes(0), [leaf0, leaf1], [0, 0, 1], [],
    edges, [0, 1, 2, 3, 4, 5, 6, 7], [model], [], [], [], []
  )
end function

// Return the view frame value.
function viewFrame(origin)
  frame = rt.defaultRefDef(640, 480)
  frame.viewOrigin = origin
  frame.viewAngles = qt.Vec3(0.0, 0.0, 0.0)
  frame.fovX = 90.0; frame.fovY = 90.0
  return frame
end function

// Find draw.
function findDraw(world, faceIndex)
  for each draw in world.draws
    if draw.surface.index == faceIndex then return draw end if
  end for
  return void
end function

// Verify pvs dedupe areas and transitions.
function testPvsDedupeAreasAndTransitions()
  renderer = ropengl.createOpenGlRenderer(false)
  renderer.exports.Init(void, void)
  renderer.exports.BeginRegistration("visibility")
  map = visibilityMap()
  world = ropengl.prepareClassicWorld(renderer, map, loadVisibilityFile, rt.defaultLightStyles(), 0, 1.0)
  renderer.exports.EndRegistration()

  north = viewFrame(qt.Vec3(-10.0, 4.0, 0.0))
  northStats = ropengl.submitClassicWorld(renderer, world, north)
  assertEqual(northStats.surfaces, 0, "headless submitted surfaces")
  assertEqual(northStats.visibleSurfaces, 1, "cluster zero visible face")
  assertEqual(northStats.culledSurfaces, 1, "cluster zero PVS cull")
  assertEqual(northStats.viewLeaf, 0, "north view leaf")
  assertEqual(northStats.viewCluster, 0, "north view cluster")
  northSelection = rclassicvisibility.selectClassicWorld(world, north)
  assertEqual(len(northSelection.draws), 1, "duplicate marksurface dedupe")
  assertEqual(northSelection.pvsCulled, 1, "PVS cull reason")

  south = viewFrame(qt.Vec3(-10.0, -4.0, 0.0))
  southStats = ropengl.submitClassicWorld(renderer, world, south)
  assertEqual(southStats.visibleSurfaces, 1, "camera cluster transition")
  assertEqual(southStats.viewLeaf, 1, "south view leaf")
  assertEqual(southStats.viewCluster, 1, "south view cluster")
  south.areaBits = bytes([1])
  areaHidden = ropengl.submitClassicWorld(renderer, world, south)
  assertEqual(areaHidden.visibleSurfaces, 0, "area one hidden")
  assertEqual(areaHidden.culledSurfaces, 2, "area and PVS culls accounted")
  assertEqual(rclassicvisibility.selectClassicWorld(world, south).areaCulled, 1, "area cull reason")
  cachedAreaHidden = rclassicvisibility.selectClassicWorldCached(world, south)
  assertEqual(len(cachedAreaHidden.draws), 0,
    "cached selector honors closed area")
  // New arrays with the same contents must hit the semantic cache, while an
  // actual portal-bit change must invalidate it.
  south.areaBits = bytes([1])
  assertEqual(len(rclassicvisibility.selectClassicWorldCached(world,
    south).draws), 0, "cached selector compares area-bit contents")
  south.areaBits = bytes([2])
  assertEqual(len(rclassicvisibility.selectClassicWorldCached(world,
    south).draws), 1, "area-bit change invalidates cached candidates")
  assertEqual(ropengl.submitClassicWorld(renderer, world, south).visibleSurfaces, 1, "area one enabled")

  map.leafs[0].cluster = -1
  clusterless = ropengl.submitClassicWorld(renderer, world, north)
  assertEqual(clusterless.viewCluster, -1, "clusterless view")
  assertEqual(clusterless.visibleSurfaces, 2, "clusterless fallback marks all")
  map.leafs[0].cluster = 0

  map.visibility.data = bytes([0])
  map.visibility.pvsOffsets = [0, 0]
  assertEqual(typeof(try(ropengl.submitClassicWorld(renderer, world, north))), "error", "malformed PVS rejected")
  map.leafs[0].cluster = -1
  assertEqual(ropengl.submitClassicWorld(renderer, world, north).visibleSurfaces, 2, "clusterless view bypasses malformed PVS")
  map.leafs[0].cluster = 0
  map.visibility.data = bytes([1, 2]); map.visibility.pvsOffsets = [0, 1]

  narrow = viewFrame(qt.Vec3(-10.0, 4.0, 0.0))
  narrow.fovX = 10.0
  map.leafs[0].cluster = -1
  narrowStats = ropengl.submitClassicWorld(renderer, world, narrow)
  assertEqual(narrowStats.visibleSurfaces, 1, "surface bounds frustum cull")
  assertEqual(narrowStats.culledSurfaces, 1, "frustum cull accounted")
  assertEqual(rclassicvisibility.selectClassicWorld(world, narrow).frustumCulled, 1, "frustum cull reason")

  reverse = viewFrame(qt.Vec3(30.0, 4.0, 0.0))
  reverse.viewAngles = qt.Vec3(0.0, 180.0, 0.0)
  reverseStats = ropengl.submitClassicWorld(renderer, world, reverse)
  assertEqual(reverseStats.visibleSurfaces, 0, "backfaces culled")
  assertEqual(reverseStats.culledSurfaces, 2, "backface count")
  assertEqual(rclassicvisibility.selectClassicWorld(world, reverse).backfaceCulled, 2, "backface cull reason")
  assertEqual(rclassicvisibility.classicVisibilityFrontFacing(findDraw(world, 0), qt.Vec3(10.0, 4.0, 0.0)), true, "coplanar backface epsilon")

  replay = ropengl.submitClassicWorld(renderer, world, narrow)
  assertEqual(replay.visibleSurfaces, narrowStats.visibleSurfaces, "deterministic visible replay")
  assertEqual(replay.culledSurfaces, narrowStats.culledSurfaces, "deterministic culled replay")
  ropengl.releaseClassicWorld(renderer, world)
  renderer.exports.Shutdown()
end function

// Verify protocol coordinate frustum bounds.
function testProtocolCoordinateFrustumBounds()
  // Aim from the positive Protocol-34 coordinate boundary along the map
  // diagonal.  The far plane is roughly -15286 units here; this reproduced
  // the former fixed-point i32 conversion crash during interactive movement.
  frame = viewFrame(qt.Vec3(4095.875, 4095.875, 4095.875))
  frame.viewAngles = qt.Vec3(-35.2643897, 45.0, 0.0)
  frustum = rclassicvisibility.classicVisibilityFrustum(frame)
  assertEqual(len(frustum), 6, "protocol-boundary frustum plane count")
  assertEqual(frustum[5].distance < 0, true,
    "protocol-boundary far plane remains representable")
end function

testPvsDedupeAreasAndTransitions()
testProtocolCoordinateFrustumBounds()
print("renderer classic visibility tests passed")
