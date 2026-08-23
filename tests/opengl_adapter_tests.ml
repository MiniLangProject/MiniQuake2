/* Asset-free contract test for the real OpenGL refexport adapter. */
import miniquake2.qcommon.types as qt
import miniquake2.renderer.constants as rc
import miniquake2.renderer.types as rt
import miniquake2.renderer.opengl as ogl

function assertEqual(actual, expected, name)
  if actual != expected then return error(9960, name + ": expected " + expected + ", got " + actual) end if
end function

function assertNear(actual, expected, tolerance, name)
  difference = actual - expected
  if difference < 0.0 then difference = -difference end if
  if difference > tolerance then return error(9961, name + ": expected " + expected + ", got " + actual) end if
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
  assertEqual(len(renderer.state.core.state.commands), 0,
    "product OpenGL core does not retain a frame trace")
  assertEqual(ogl.backendDescription(renderer), "OpenGL 1.1 (headless contract mode)", "headless description")
  assertEqual(ogl.submitTriangleMesh(renderer, void, origin, origin, 255, 255, 255, 255), 0, "headless mesh submission")
  renderer.exports.Shutdown()
end function

function testClassicDrawingHelpers()
  palette = bytes(768)
  palette[17 * 3] = 10; palette[17 * 3 + 1] = 20; palette[17 * 3 + 2] = 30
  assertEqual(ogl.openGlPaletteColor(palette, 17), 10 | (20 << 8) | (30 << 16),
    "Quake palette lookup")

  raw = ogl.prepareOpenGlRawFrame(2, 2, bytes([17, 0, 0, 17]), palette, bytes(0))
  assertEqual(len(raw.rgba), 256 * 256 * 4, "cinematic upload size")
  assertEqual(raw.rgba[0], 10, "cinematic first red")
  assertEqual(raw.rgba[1], 20, "cinematic first green")
  assertEqual(raw.rgba[2], 30, "cinematic first blue")
  assertEqual(raw.rgba[255 * 4], 0, "cinematic horizontal resample")
  assertNear(raw.textureT, 2.0 / 256.0, 0.000001, "cinematic texture height")

  particlePixels = ogl.openGlParticlePixels()
  assertEqual(len(particlePixels), 8 * 8 * 4, "particle texture size")
  assertEqual(particlePixels[(1 * 8 + 2) * 4 + 3], 255, "particle dot alpha")
  assertEqual(particlePixels[0 * 4 + 3], 0, "particle transparent alpha")

  beam = rt.emptyEntity()
  beam.origin = qt.vec3(0.0, 0.0, 0.0)
  beam.oldOrigin = qt.vec3(0.0, 0.0, 10.0)
  beam.frame = 4
  beam.flags = rc.RF_BEAM
  beamScalars = ogl.openGlBeamScalars(beam)
  assertEqual(len(beamScalars), 72, "six-sided beam scalar count")
  assertNear(beamScalars[0], 2.0, 0.000001, "beam radius")
  assertNear(beamScalars[5], 10.0, 0.000001, "beam endpoint")

  shell = rt.emptyEntity()
  shell.flags = rc.RF_SHELL_DOUBLE
  assertEqual(ogl.openGlMd2Shade(shell, 0.0), 230 | (179 << 8),
    "double-damage shell color")
end function

testHeadlessLifecycle()
testClassicDrawingHelpers()
print("MiniQuake2 OpenGL adapter tests passed: 2")
