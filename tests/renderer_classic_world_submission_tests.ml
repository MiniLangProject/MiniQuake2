/* Synthetic WAL/palette/BSP test for the productive classic world handoff. */
import miniquake2.format.types as ft
import miniquake2.renderer.types as rt
import miniquake2.renderer.opengl as ropengl
import miniquake2.renderer.classic.world as rclassicworld

function assertEqual(actual, expected, name)
  if actual != expected then return error(7990, name + ": expected " + expected + ", got " + actual) end if
  return true
end function

function putU32(data, offset, value)
  data[offset] = value & 255
  data[offset + 1] = (value >> 8) & 255
  data[offset + 2] = (value >> 16) & 255
  data[offset + 3] = (value >> 24) & 255
end function

function putText(data, offset, value)
  encoded = bytes(value)
  index = 0
  while index < len(encoded)
    data[offset + index] = encoded[index]
    index = index + 1
  end while
end function

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

function loadClassicFile(path)
  if path == "pics/colormap.pcx" then return palettePcx() end if
  if path == "textures/wall.wal" then return wallWal() end if
  return void
end function

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
  model = ft.BspModel(ft.Vec3(0.0, 0.0, 0.0), ft.Vec3(16.0, 16.0, 0.0), ft.Vec3(0.0, 0.0, 0.0), 0, 0, 2)
  return ft.BspMap("synthetic", bytes(0), [], "", [plane], vertices, void, [], texInfo, faces, lighting, [], [], [], edges, [0, 1, 2, 3], [model], [], [], [], [])
end function

function testWorldPlanAndPalette()
  styles = rt.defaultLightStyles()
  styles[1] = rt.lightStyle(0.5, 1.0, 0.25)
  world = rclassicworld.build(makeMap(), loadClassicFile, styles, 0, 1.0, 7)
  assertEqual(len(world.draws), 2, "opaque chained surfaces")
  assertEqual(world.draws[0].surface.index, 1, "texture chain head order")
  assertEqual(len(world.textures), 3, "one shared WAL plus two lightmaps")
  assertEqual(world.draws[0].baseTexture, world.draws[1].baseTexture, "shared base handle")
  assertEqual(world.draws[0].baseTexture.rgbaPixels, bytes([20, 40, 60, 255, 80, 100, 120, 255, 80, 100, 120, 255, 20, 40, 60, 255]), "ref_gl intensity-scaled Quake II palette expansion")
  assertEqual(slice(world.draws[0].lightmapTexture.rgbaPixels, 0, 4), bytes([20, 60, 20, 60]), "second lightstyle contribution")
  assertEqual(slice(world.draws[1].lightmapTexture.rgbaPixels, 0, 4), bytes([100, 80, 60, 100]), "first static lightmap")
  assertEqual(world.draws[0].triangleCount + world.draws[1].triangleCount, 4, "triangle fans")
  assertEqual(rclassicworld.planSignature(world), "synthetic:2:4:1/wall/2x2:0/wall/2x2", "deterministic plan signature")
  assertEqual(world.draws[0].surface.vertices[1].s, 8.0, "base texture coordinate")
  assertEqual(world.draws[0].surface.vertices[2].lightS, 0.75, "lightmap coordinate")
end function

function testBackendLifecycle()
  renderer = ropengl.createOpenGlRenderer(false)
  renderer.exports.Init(void, void)
  renderer.exports.BeginRegistration("maps/synthetic.bsp")
  renderer.exports.EndRegistration()
  frame = rt.defaultRefDef(640, 480)
  first = ropengl.prepareClassicWorld(renderer, makeMap(), loadClassicFile, rt.defaultLightStyles(), 0, 1.0)
  assertEqual(first.textures[0].id, 1, "first backend texture id")
  assertEqual(len(renderer.state.textureRecords), 3, "tracked texture handles")
  stats = ropengl.submitClassicWorld(renderer, first, frame)
  assertEqual(stats.surfaces, 0, "headless submission avoids GL")
  assertEqual(first.textures[0].uploaded, false, "headless texture remains CPU-side")
  signature = rclassicworld.planSignature(first)
  // An uploaded flag in headless mode must still take the logical release
  // path without ever entering the native glDeleteTextures wrapper.
  renderer.state.textureRecords[0].uploaded = true
  assertEqual(ropengl.releaseClassicWorld(renderer, first), 3, "logical release count")
  assertEqual(first.released, true, "world release state")
  assertEqual(renderer.state.textureRecords[0].released, true, "handle release state")
  assertEqual(typeof(try(ropengl.submitClassicWorld(renderer, first, frame))), "error", "released submission rejected")

  replay = ropengl.prepareClassicWorld(renderer, makeMap(), loadClassicFile, rt.defaultLightStyles(), 0, 1.0)
  assertEqual(rclassicworld.planSignature(replay), signature, "deterministic replay")
  assertEqual(replay.textures[0].id, 4, "released ids are not reused")
  renderer.exports.BeginRegistration("maps/next.bsp")
  renderer.exports.EndRegistration()
  assertEqual(typeof(try(ropengl.submitClassicWorld(renderer, replay, frame))), "error", "stale generation rejected")
  renderer.exports.Shutdown()
end function

function testContextModeFactories()
  headless = ropengl.createOpenGlRenderer(false)
  context = ropengl.createOpenGlRenderer(true)
  assertEqual(headless.exports.apiVersion, 3, "headless renderer factory")
  assertEqual(context.exports.apiVersion, 3, "context renderer factory")
  assertEqual(headless.state.contextActive, false, "headless factory mode")
  assertEqual(context.state.contextActive, true, "context factory mode")
end function

testWorldPlanAndPalette()
testBackendLifecycle()
testContextModeFactories()
print("renderer classic world submission tests passed")
