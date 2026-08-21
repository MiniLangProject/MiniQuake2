/* Asset-free contract test for the real OpenGL refexport adapter. */
import miniquake2.qcommon.types as qt
import miniquake2.renderer.types as rt
import miniquake2.renderer.opengl as ogl

function assertEqual(actual, expected, name)
  if actual != expected then return error(9960, name + ": expected " + expected + ", got " + actual) end if
end function

function testHeadlessLifecycle()
  renderer = ogl.createOpenGlRenderer(false)
  assertEqual(renderer.exports.apiVersion, 3, "renderer API")
  assertEqual(renderer.exports.Init(void, void), true, "init")
  renderer.exports.BeginRegistration("maps/test.bsp")
  model = renderer.exports.RegisterModel("models/test/tris.md2")
  assertEqual(model.kind, "model", "managed resource")
  renderer.exports.EndRegistration()

  origin = qt.zeroVec3()
  entity = rt.emptyEntity()
  entity.origin = qt.vec3(16.0, 8.0, 4.0)
  particle = rt.particle(qt.vec3(4.0, 2.0, 1.0), 17, 0.75)
  frame = rt.refDef(0, 0, 640, 480, 90.0, 73.0, origin, origin, [0.0, 0.0, 0.0, 0.0], 0.1, 0, void, rt.defaultLightStyles(), [entity], [], [particle])
  renderer.exports.BeginFrame(0.0)
  renderer.exports.RenderFrame(frame)
  renderer.exports.EndFrame()

  assertEqual(renderer.state.submittedFrames, 1, "submitted frame")
  assertEqual(renderer.state.submittedEntities, 0, "headless entity GL submissions")
  assertEqual(renderer.state.submittedParticles, 0, "headless particle GL submissions")
  assertEqual(renderer.state.core.state.frameCount, 1, "validated base frame")
  assertEqual(ogl.backendDescription(renderer), "OpenGL 1.1 (headless contract mode)", "headless description")
  assertEqual(ogl.submitTriangleMesh(renderer, void, origin, origin, 255, 255, 255, 255), 0, "headless mesh submission")
  renderer.exports.Shutdown()
end function

testHeadlessLifecycle()
print("MiniQuake2 OpenGL adapter tests passed: 1")
