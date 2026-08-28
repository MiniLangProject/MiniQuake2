/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Golden coverage for sky, warp, flowing and translucent ClassicWorld paths. */
import miniquake2.format.constants as rspecialtestconstants
import miniquake2.format.types as rspecialtestformattypes
import miniquake2.qcommon.types as rspecialtestqtypes
import miniquake2.renderer.types as rspecialtestrtypes
import miniquake2.renderer.opengl as rspecialtestopengl
import miniquake2.renderer.classic.special as rspecialtestspecial
import miniquake2.renderer.classic.world as rspecialtestworld

// Assert the equal test condition.
function assertEqual(actual, expected, name)
  if actual != expected then return error(7997, name + ": expected " + expected + ", got " + actual) end if
end function

// Assert the near test condition.
function assertNear(actual, expected, epsilon, name)
  delta = actual - expected
  if delta < 0.0 then delta = -delta end if
  if delta > epsilon then return error(7998, name + ": expected " + expected + ", got " + actual) end if
end function

// Write special u 32.
function specialPutU32(data, offset, value)
  data[offset] = value & 255; data[offset + 1] = (value >> 8) & 255
  data[offset + 2] = (value >> 16) & 255; data[offset + 3] = (value >> 24) & 255
end function

// Write special text.
function specialPutText(data, offset, value)
  encoded = bytes(value)
  index = 0
  while index < len(encoded)
    data[offset + index] = encoded[index]
    index = index + 1
  end while
end function

// Return the special palette pcx value.
function specialPalettePcx()
  data = bytes(899)
  data[0] = 0x0a; data[1] = 5; data[2] = 1; data[3] = 8
  data[8] = 1; data[65] = 1; data[66] = 2
  data[128] = 1; data[129] = 1; data[130] = 12
  data[134] = 80; data[135] = 120; data[136] = 160
  return data
end function

// Return the special wal value.
function specialWal(name)
  data = bytes(107)
  specialPutText(data, 0, name)
  specialPutU32(data, 32, 2); specialPutU32(data, 36, 2)
  specialPutU32(data, 40, 100); specialPutU32(data, 44, 104)
  specialPutU32(data, 48, 105); specialPutU32(data, 52, 106)
  data[100] = 1; data[101] = 1; data[102] = 1; data[103] = 1
  data[104] = 1; data[105] = 1; data[106] = 1
  return data
end function

// Load special file.
function loadSpecialFile(path)
  if path == "pics/colormap.pcx" then return specialPalettePcx() end if
  if path == "env/unit_rt.pcx" then return specialPalettePcx() end if
  if path == "env/unit_bk.pcx" then return specialPalettePcx() end if
  if path == "env/unit_lf.pcx" then return specialPalettePcx() end if
  if path == "env/unit_ft.pcx" then return specialPalettePcx() end if
  if path == "env/unit_up.pcx" then return specialPalettePcx() end if
  if path == "env/unit_dn.pcx" then return specialPalettePcx() end if
  if path == "textures/flow.wal" then return specialWal("flow") end if
  if path == "textures/water.wal" then return specialWal("water") end if
  if path == "textures/sky.wal" then return specialWal("sky") end if
  if path == "textures/glass33.wal" then return specialWal("glass33") end if
  if path == "textures/glass66.wal" then return specialWal("glass66") end if
  return void
end function

// Map special.
function specialMap()
  vertices = [
    rspecialtestformattypes.BspVertex(rspecialtestformattypes.Vec3(32.0, -8.0, -8.0)), rspecialtestformattypes.BspVertex(rspecialtestformattypes.Vec3(32.0, 8.0, -8.0)),
    rspecialtestformattypes.BspVertex(rspecialtestformattypes.Vec3(32.0, 8.0, 8.0)), rspecialtestformattypes.BspVertex(rspecialtestformattypes.Vec3(32.0, -8.0, 8.0))
  ]
  edges = [rspecialtestformattypes.BspEdge(0, 1), rspecialtestformattypes.BspEdge(1, 2), rspecialtestformattypes.BspEdge(2, 3), rspecialtestformattypes.BspEdge(3, 0)]
  texInfo = [
    rspecialtestformattypes.BspTexInfo([0.0, 1.0, 0.0, 0.0], [0.0, 0.0, 1.0, 0.0], rspecialtestconstants.SURF_FLOWING, 0, "flow", -1),
    rspecialtestformattypes.BspTexInfo([0.0, 1.0, 0.0, 0.0], [0.0, 0.0, 1.0, 0.0], rspecialtestconstants.SURF_WARP, 0, "water", -1),
    rspecialtestformattypes.BspTexInfo([0.0, 1.0, 0.0, 0.0], [0.0, 0.0, 1.0, 0.0], rspecialtestconstants.SURF_SKY, 0, "sky", -1),
    rspecialtestformattypes.BspTexInfo([0.0, 1.0, 0.0, 0.0], [0.0, 0.0, 1.0, 0.0], rspecialtestconstants.SURF_TRANS33, 0, "glass33", -1),
    rspecialtestformattypes.BspTexInfo([0.0, 1.0, 0.0, 0.0], [0.0, 0.0, 1.0, 0.0], rspecialtestconstants.SURF_WARP | rspecialtestconstants.SURF_FLOWING | rspecialtestconstants.SURF_TRANS66, 0, "glass66", -1)
  ]
  faces = array(5)
  faceIndex = 0
  while faceIndex < 5
    faces[faceIndex] = rspecialtestformattypes.BspFace(0, 0, 0, 4, faceIndex, bytes([0, 255, 255, 255]), -1)
    faceIndex = faceIndex + 1
  end while
  plane = rspecialtestformattypes.BspPlane(rspecialtestformattypes.Vec3(-1.0, 0.0, 0.0), -32.0, 0)
  model = rspecialtestformattypes.BspModel(rspecialtestformattypes.Vec3(32.0, -8.0, -8.0), rspecialtestformattypes.Vec3(32.0, 8.0, 8.0), rspecialtestformattypes.Vec3(0.0, 0.0, 0.0), 0, 0, 5)
  return rspecialtestformattypes.BspMap(
    "special", bytes(0), [], "", [plane], vertices, void, [], texInfo, faces,
    bytes(0), [], [], [], edges, [0, 1, 2, 3], [model], [], [], [], []
  )
end function

// Find special draw.
function findSpecialDraw(world, surfaceIndex)
  for each draw in world.draws
    if draw.surface.index == surfaceIndex then return draw end if
  end for
  return void
end function

// Verify special world plan and golden coordinates.
function testSpecialWorldPlanAndGoldenCoordinates()
  renderer = rspecialtestopengl.createOpenGlRenderer(false)
  renderer.exports.Init(void, void)
  renderer.exports.BeginRegistration("maps/special.bsp")
  renderer.exports.SetSky("unit_", 2.0, rspecialtestqtypes.Vec3(0.0, 0.0, 1.0))
  world = rspecialtestopengl.prepareClassicWorld(renderer, specialMap(), loadSpecialFile, rspecialtestrtypes.defaultLightStyles(), 0, 1.0)
  renderer.exports.EndRegistration()

  assertEqual(len(world.draws), 5, "all renderable special surfaces")
  assertEqual(len(world.textures), 12, "WAL/lightmap plus six PCX sky faces")
  assertEqual(world.skyBox.active, true, "configured PCX skybox")
  assertEqual(world.skyBox.name, "unit_", "sky name handoff")
  assertEqual(world.skyBox.rotate, 2.0, "sky rotation handoff")
  assertEqual(world.skyBox.textures[0].role, "sky", "sky texture role")
  assertEqual(findSpecialDraw(world, 0).lightmapTexture.role, "lightmap", "opaque flow is lit")
  assertEqual(findSpecialDraw(world, 1).lightmapTexture is void, true, "warp has no lightmap")
  assertEqual(findSpecialDraw(world, 2).lightmapTexture is void, true, "sky has no lightmap")
  assertEqual(findSpecialDraw(world, 3).surface.alpha, 0.33, "trans33 alpha")
  assertEqual(findSpecialDraw(world, 4).surface.alpha, 0.66, "trans66 precedence")
  assertEqual(findSpecialDraw(world, 1).triangleCount, 16, "classic axial warp subdivision and center fans")
  assertEqual(findSpecialDraw(world, 4).triangleCount, 16, "transparent warp subdivision")

  flowDraw = findSpecialDraw(world, 0)
  flowCoordinates = rspecialtestspecial.classicSpecialTextureCoordinates(flowDraw, flowDraw.vertices[0], 10.0)
  assertNear(flowCoordinates[0], flowDraw.vertices[0].s - 16.0, 0.000001, "40 second flowing scroll")
  assertNear(rspecialtestspecial.classicSpecialFlowScroll(40.0), -64.0, 0.000001, "flow cycle zero fallback")
  assertNear(rspecialtestspecial.classicSpecialWaterScroll(0.5), -16.0, 0.000001, "two second water scroll")
  assertNear(rspecialtestspecial.classicSpecialWarpSine(0.5), 3.771173, 0.00001, "Quake turbsin table phase")

  frame = rspecialtestrtypes.defaultRefDef(640, 480)
  frame.viewOrigin = rspecialtestqtypes.Vec3(0.0, 0.0, 0.0)
  stats = rspecialtestopengl.submitClassicWorld(renderer, world, frame)
  assertEqual(stats.visibleSurfaces, 5, "special surfaces share visibility")
  assertEqual(stats.opaqueSurfaces, 1, "opaque pass count")
  assertEqual(stats.warpSurfaces, 1, "warp pass count")
  assertEqual(stats.skySurfaces, 1, "sky pass count")
  assertEqual(stats.transparentSurfaces, 2, "alpha pass count")
  assertEqual(stats.passOrder, "o0,w1,s2,a4@0.66,a3@0.33,",
    "classic alpha-chain ordering")

  // Stock alpha ordering follows BSP/head insertion, not center distance.
  nearAlpha = findSpecialDraw(world, 3); farAlpha = findSpecialDraw(world, 4)
  nearAlpha.mins.x = 40.0; nearAlpha.maxs.x = 40.0
  farAlpha.mins.x = 80.0; farAlpha.maxs.x = 80.0
  plan = rspecialtestspecial.classicSpecialPassPlan(world.draws, frame)
  skyBounds = rspecialtestopengl.openGlSkyBounds(plan.skyDraws,
    frame.viewOrigin)
  assertNear(skyBounds.minimumS[0], -0.25, 0.000001,
    "sky portal minimum s")
  assertNear(skyBounds.maximumS[0], 0.25, 0.000001,
    "sky portal maximum s")
  assertNear(skyBounds.minimumT[0], -0.25, 0.000001,
    "sky portal minimum t")
  assertNear(skyBounds.maximumT[0], 0.25, 0.000001,
    "sky portal maximum t")
  assertEqual(skyBounds.minimumS[1] >= skyBounds.maximumS[1], true,
    "hidden sky cube face stays clipped")
  heapBeforeSkySoak = heap_bytes_used()
  skyIteration = 0
  while skyIteration < 1000
    rspecialtestopengl.openGlSkyBounds(plan.skyDraws, frame.viewOrigin)
    skyIteration = skyIteration + 1
  end while
  heapAfterSkySoak = heap_bytes_used()
  assertEqual(heapAfterSkySoak, heapBeforeSkySoak,
    "retained sky clipping scratch avoids hot-path heap growth")
  assertEqual(plan.transparentDraws[0].surface.index, 4, "alpha far surface first")
  assertEqual(plan.transparentDraws[1].surface.index, 3, "alpha near surface last")

  assertEqual(rspecialtestopengl.releaseClassicWorld(renderer, world), 12, "special and sky texture lifecycle")
  assertEqual(world.released, true, "special world released")
  renderer.exports.Shutdown()
end function

// Verify stock-compatible 24-bit TGA sky fallback decoding.
function testTgaSkyDecode()
  data = bytes(24)
  data[2] = 2; data[12] = 2; data[14] = 1; data[16] = 24
  // TGA stores BGR.
  data[18] = 30; data[19] = 20; data[20] = 10
  data[21] = 60; data[22] = 50; data[23] = 40
  image = rspecialtestworld.classicWorldDecodeTga(data, "env/unit_rt.tga")
  assertEqual(image.width, 2, "TGA sky width")
  assertEqual(image.height, 1, "TGA sky height")
  expected = bytes([10, 20, 30, 255, 40, 50, 60, 255])
  assertEqual(len(image.rgba), len(expected), "TGA RGBA byte count")
  pixelIndex = 0
  while pixelIndex < len(expected)
    assertEqual(image.rgba[pixelIndex], expected[pixelIndex],
      "TGA BGR to RGBA channel " + pixelIndex)
    pixelIndex = pixelIndex + 1
  end while
end function

testSpecialWorldPlanAndGoldenCoordinates()
testTgaSkyDecode()
print("renderer classic special surface tests passed")
