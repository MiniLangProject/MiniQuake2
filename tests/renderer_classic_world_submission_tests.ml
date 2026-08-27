/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Synthetic WAL/palette/BSP test for the productive classic world handoff. */
import miniquake2.format.types as ft
import miniquake2.renderer.constants as rc
import miniquake2.renderer.types as rt
import miniquake2.renderer.opengl as ropengl
import miniquake2.renderer.classic.world as rclassicworld

// Assert the equal test condition.
function assertEqual(actual, expected, name)
  if actual != expected then return error(7990, name + ": expected " + expected + ", got " + actual) end if
  return true
end function

// Write u 32.
function putU32(data, offset, value)
  data[offset] = value & 255
  data[offset + 1] = (value >> 8) & 255
  data[offset + 2] = (value >> 16) & 255
  data[offset + 3] = (value >> 24) & 255
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

// Return the palette pcx value.
function palettePcx()
  data = bytes(899)
  data[0] = 0x0a; data[1] = 5; data[2] = 1; data[3] = 8
  data[8] = 1; data[9] = 0
  data[65] = 1; data[66] = 2; data[67] = 0
  data[128] = 1; data[129] = 2
  data[130] = 12
  palette = 131
  data[palette + 3] = 10; data[palette + 4] = 20; data[palette + 5] = 30
  data[palette + 6] = 40; data[palette + 7] = 50; data[palette + 8] = 60
  return data
end function

// Return the wall wal value.
function wallWal()
  data = bytes(107)
  putText(data, 0, "wall")
  putU32(data, 32, 2); putU32(data, 36, 2)
  putU32(data, 40, 100); putU32(data, 44, 104)
  putU32(data, 48, 105); putU32(data, 52, 106)
  data[100] = 1; data[101] = 2; data[102] = 2; data[103] = 1
  data[104] = 1; data[105] = 2; data[106] = 1
  return data
end function

// Load classic file.
function loadClassicFile(path)
  if path == "pics/colormap.pcx" then return palettePcx() end if
  if path == "textures/wall.wal" then return wallWal() end if
  return void
end function

// Create map.
function makeMap()
  vertices = [
    ft.BspVertex(ft.Vec3(0.0, 0.0, 0.0)), ft.BspVertex(ft.Vec3(16.0, 0.0, 0.0)),
    ft.BspVertex(ft.Vec3(16.0, 16.0, 0.0)), ft.BspVertex(ft.Vec3(0.0, 16.0, 0.0))
  ]
  edges = [ft.BspEdge(0, 1), ft.BspEdge(1, 2), ft.BspEdge(2, 3), ft.BspEdge(3, 0)]
  texInfo = [ft.BspTexInfo([1.0, 0.0, 0.0, 0.0], [0.0, 1.0, 0.0, 0.0], 0, 0, "wall", -1)]
  faces = [
    ft.BspFace(0, 0, 0, 4, 0, bytes([0, 255, 255, 255]), 0),
    ft.BspFace(0, 0, 0, 4, 0, bytes([1, 255, 255, 255]), 12)
  ]
  lighting = bytes([
    100, 80, 60, 100, 80, 60, 100, 80, 60, 100, 80, 60,
    40, 60, 80, 40, 60, 80, 40, 60, 80, 40, 60, 80
  ])
  plane = ft.BspPlane(ft.Vec3(0.0, 0.0, 1.0), 0.0, 2)
  node = ft.BspNode(0, -1, -2, ft.Vec3(0.0, 0.0, -2048.0),
    ft.Vec3(16.0, 16.0, 2048.0), 0, 2)
  model = ft.BspModel(ft.Vec3(0.0, 0.0, 0.0), ft.Vec3(16.0, 16.0, 0.0), ft.Vec3(0.0, 0.0, 0.0), 0, 0, 2)
  return ft.BspMap("synthetic", bytes(0), [], "", [plane], vertices, void,
    [node], texInfo, faces, lighting, [], [], [], edges, [0, 1, 2, 3],
    [model], [], [], [], [])
end function

// Verify world plan and palette.
function testWorldPlanAndPalette()
  styles = rt.defaultLightStyles()
  styles[1] = rt.lightStyle(0.5, 1.0, 0.25)
  world = rclassicworld.build(makeMap(), loadClassicFile, styles, 0, 1.0, 7)
  assertEqual(len(world.draws), 2, "opaque chained surfaces")
  assertEqual(world.draws[0].surface.index, 1, "texture chain head order")
  assertEqual(len(world.textures), 2, "one shared WAL plus one lightmap atlas")
  assertEqual(world.draws[0].baseTexture, world.draws[1].baseTexture, "shared base handle")
  assertEqual(world.draws[0].baseTexture.rgbaPixels, bytes([20, 40, 60, 255, 80, 100, 120, 255, 80, 100, 120, 255, 20, 40, 60, 255]), "ref_gl intensity-scaled Quake II palette expansion")
  firstLightmapOffset = (world.draws[0].lightmapY * 256 +
    world.draws[0].lightmapX) * 4
  secondLightmapOffset = (world.draws[1].lightmapY * 256 +
    world.draws[1].lightmapX) * 4
  assertEqual(slice(world.draws[0].lightmapTexture.rgbaPixels,
    firstLightmapOffset, 4), bytes([20, 60, 20, 60]),
    "second lightstyle contribution in atlas")
  assertEqual(slice(world.draws[1].lightmapTexture.rgbaPixels,
    secondLightmapOffset, 4), bytes([100, 80, 60, 100]),
    "first static lightmap in atlas")
  assertEqual(world.draws[0].lightmapTexture,
    world.draws[1].lightmapTexture, "opaque surfaces share lightmap atlas")
  assertEqual(world.draws[0].triangleCount + world.draws[1].triangleCount, 4, "triangle fans")
  assertEqual(rclassicworld.planSignature(world), "synthetic:2:4:1/wall/2x2:0/wall/2x2", "deterministic plan signature")
  assertEqual(world.draws[0].surface.vertices[1].s, 8.0, "base texture coordinate")
  assertEqual(world.draws[0].surface.vertices[2].lightS, 0.009765625,
    "atlas lightmap coordinate")
end function

// Verify backend lifecycle.
function testBackendLifecycle()
  renderer = ropengl.createOpenGlRenderer(false)
  renderer.exports.Init(void, void)
  renderer.exports.BeginRegistration("maps/synthetic.bsp")
  renderer.exports.EndRegistration()
  frame = rt.defaultRefDef(640, 480)
  first = ropengl.prepareClassicWorld(renderer, makeMap(), loadClassicFile, rt.defaultLightStyles(), 0, 1.0)
  assertEqual(first.textures[0].id, 1, "first backend texture id")
  assertEqual(len(renderer.state.textureRecords), 2, "tracked texture handles")
  stats = ropengl.submitClassicWorld(renderer, first, frame)
  assertEqual(stats.surfaces, 0, "headless submission avoids GL")
  assertEqual(first.textures[0].uploaded, false, "headless texture remains CPU-side")
  signature = rclassicworld.planSignature(first)
  // An uploaded flag in headless mode must still take the logical release
  // path without ever entering the native glDeleteTextures wrapper.
  renderer.state.textureRecords[0].uploaded = true
  assertEqual(ropengl.releaseClassicWorld(renderer, first), 2, "logical release count")
  assertEqual(first.released, true, "world release state")
  assertEqual(renderer.state.textureRecords[0].released, true, "handle release state")
  assertEqual(typeof(try(ropengl.submitClassicWorld(renderer, first, frame))), "error", "released submission rejected")

  replay = ropengl.prepareClassicWorld(renderer, makeMap(), loadClassicFile, rt.defaultLightStyles(), 0, 1.0)
  assertEqual(rclassicworld.planSignature(replay), signature, "deterministic replay")
  assertEqual(replay.textures[0].id, 3, "released ids are not reused")
  renderer.exports.BeginRegistration("maps/next.bsp")
  renderer.exports.EndRegistration()
  assertEqual(typeof(try(ropengl.submitClassicWorld(renderer, replay, frame))), "error", "stale generation rejected")
  renderer.exports.Shutdown()
end function

// Verify context mode factories.
function testContextModeFactories()
  headless = ropengl.createOpenGlRenderer(false)
  context = ropengl.createOpenGlRenderer(true)
  assertEqual(headless.exports.apiVersion, 3, "headless renderer factory")
  assertEqual(context.exports.apiVersion, 3, "context renderer factory")
  assertEqual(headless.state.contextActive, false, "headless factory mode")
  assertEqual(context.state.contextActive, true, "context factory mode")
end function

// Verify alias point lighting.
function testAliasPointLighting()
  renderer = ropengl.createOpenGlRenderer(false)
  renderer.exports.Init(void, void)
  renderer.exports.BeginRegistration("maps/synthetic.bsp")
  renderer.exports.EndRegistration()
  world = ropengl.prepareClassicWorld(renderer, makeMap(), loadClassicFile,
    rt.defaultLightStyles(), 0, 1.0)
  frame = rt.defaultRefDef(640, 480)
  entity = rt.emptyEntity()
  entity.origin = ft.Vec3(8.0, 8.0, 64.0)
  entity.flags = rc.RF_WEAPONMODEL
  assertEqual(ropengl.md2EntityShade(renderer, frame, entity),
    100 | (80 << 8) | (60 << 16), "BSP point-lit alias color")
  assertEqual(renderer.state.md2LightSpotValid, true,
    "alias light query retains BSP shadow spot")
  assertEqual(renderer.state.md2LightSpotZ, 0.0,
    "alias shadow spot lies on synthetic floor")
  assertEqual(ropengl.lightLevel(renderer), 58,
    "view weapon publishes sampled light level")
  frame.lightStyles[0] = rt.lightStyle(0.5, 1.0, 0.25)
  entity.flags = 0
  assertEqual(ropengl.md2EntityShade(renderer, frame, entity),
    50 | (80 << 8) | (15 << 16), "colored alias light style")
  frame.lightStyles[0] = rt.lightStyle(1.0, 1.0, 1.0)

  entity.origin = ft.Vec3(32.0, 8.0, 64.0)
  entity.flags = rc.RF_MINLIGHT
  assertEqual(ropengl.md2EntityShade(renderer, frame, entity),
    26 | (26 << 8) | (26 << 16), "alias minimum light")
  frame.dLights = [rt.dLight(entity.origin, ft.Vec3(1.0, 0.5, 0.25), 128.0)]
  frame.numDLights = 1
  entity.flags = 0
  assertEqual(ropengl.md2EntityShade(renderer, frame, entity),
    128 | (64 << 8) | (32 << 16), "alias dynamic point light")

  frame.rdFlags = rc.RDF_IRGOGGLES
  entity.flags = rc.RF_FULLBRIGHT | rc.RF_IR_VISIBLE
  assertEqual(ropengl.md2EntityShade(renderer, frame, entity), 255,
    "IR goggles alias override")
  ropengl.releaseClassicWorld(renderer, world)
  assertEqual(renderer.state.activeWorld is void, true,
    "released point-light world detached")
  renderer.exports.Shutdown()
end function

testWorldPlanAndPalette()
testBackendLifecycle()
testContextModeFactories()
testAliasPointLighting()
print("renderer classic world submission tests passed")
