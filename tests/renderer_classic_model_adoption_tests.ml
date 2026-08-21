/* Cached adoption of an already parsed BSP and lazy inline-model expansion. */
import miniquake2.format.types as ft
import miniquake2.renderer.opengl as ropengl
import miniquake2.renderer.assets as rassets

struct AdoptionTestImports
  fsLoadFile
end struct

function assertEqual(actual, expected, name)
  if actual != expected then return error(7994, name + ": expected " + expected + ", got " + actual) end if
end function

function rejectFileLoad(path)
  return error(7995, "adopted BSP unexpectedly reloaded: " + path)
end function

function adoptionMap()
  vertices = [
    ft.BspVertex(ft.Vec3(0.0, 0.0, 0.0)), ft.BspVertex(ft.Vec3(8.0, 0.0, 0.0)),
    ft.BspVertex(ft.Vec3(8.0, 8.0, 0.0)), ft.BspVertex(ft.Vec3(0.0, 8.0, 0.0))
  ]
  edges = [ft.BspEdge(0, 1), ft.BspEdge(1, 2), ft.BspEdge(2, 3), ft.BspEdge(3, 0)]
  texInfo = ft.BspTexInfo([1.0, 0.0, 0.0, 0.0], [0.0, 1.0, 0.0, 0.0], 0, 0, "wall", -1)
  face = ft.BspFace(0, 0, 0, 4, 0, bytes([255, 255, 255, 255]), -1)
  world = ft.BspModel(ft.Vec3(0.0, 0.0, 0.0), ft.Vec3(8.0, 8.0, 0.0), ft.Vec3(0.0, 0.0, 0.0), 0, 0, 1)
  inlineModel = ft.BspModel(ft.Vec3(0.0, 0.0, 0.0), ft.Vec3(8.0, 8.0, 0.0), ft.Vec3(4.0, 4.0, 0.0), 0, 0, 1)
  return ft.BspMap("maps/adopted.bsp", bytes(0), [], "", [], vertices, void, [], [texInfo], [face], bytes(0), [], [], [], edges, [0, 1, 2, 3], [world, inlineModel], [], [], [], [])
end function

function testAdoptionCacheInlineAndGeneration()
  renderer = ropengl.createOpenGlRenderer(false)
  renderer.exports.Init(void, void)
  renderer.exports.BeginRegistration("maps/adopted.bsp")
  imports = AdoptionTestImports(rejectFileLoad)
  map = adoptionMap()
  handle = ropengl.adoptClassicMapModel(renderer, map, "maps/adopted.bsp")
  repeated = ropengl.adoptClassicMapModel(renderer, map, "maps/adopted.bsp")
  assertEqual(repeated.id, handle.id, "adoption dedupe")
  cached = rassets.registerModel(renderer.state.assets, imports, "maps/adopted.bsp")
  assertEqual(cached.handle.id, handle.id, "RegisterModel cache hit")
  assertEqual(cached.source, map, "shared parsed BSP")
  assertEqual(cached.mesh, void, "world debug mesh remains lazy")
  inlineAsset = rassets.registerModel(renderer.state.assets, imports, "*1")
  assertEqual(inlineAsset.kind, "bsp-inline", "inline model kind")
  assertEqual(inlineAsset.mesh.triangleCount, 2, "inline fan expansion")
  renderer.exports.EndRegistration()

  renderer.exports.BeginRegistration("maps/next.bsp")
  assertEqual(typeof(try(rassets.modelForHandle(renderer.state.assets, handle))), "error", "adopted handle becomes stale")
  assertEqual(typeof(try(rassets.registerModel(renderer.state.assets, imports, "*1"))), "error", "inline registration requires world first")
  next = ropengl.adoptClassicMapModel(renderer, map, "maps/adopted.bsp")
  assertEqual(next.generation, handle.generation + 1, "adopted next generation")
  assertEqual(rassets.registerModel(renderer.state.assets, imports, "*1").handle.generation, next.generation, "inline current generation")
  renderer.exports.EndRegistration()
  renderer.exports.Shutdown()
end function

testAdoptionCacheInlineAndGeneration()
print("renderer classic BSP adoption tests passed")
