/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Asset-free contract test for the real OpenGL refexport adapter. */
import miniquake2.qcommon.types as qt
import miniquake2.qcommon.byteio as oglbyteio
import miniquake2.renderer.constants as rc
import miniquake2.renderer.types as rt
import miniquake2.renderer.opengl as ogl

// Assert the equal test condition.
function assertEqual(actual, expected, name)
  if actual != expected then return error(9960, name + ": expected " + expected + ", got " + actual) end if
end function

// Assert the near test condition.
function assertNear(actual, expected, tolerance, name)
  difference = actual - expected
  if difference < 0.0 then difference = -difference end if
  if difference > tolerance then return error(9961, name + ": expected " + expected + ", got " + actual) end if
end function

// Verify headless lifecycle.
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

// Verify classic drawing helpers.
function testClassicDrawingHelpers()
  // Keep test classic drawing helpers phases explicit: validate inputs, update owned state, then publish the result.
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
  assertEqual(len(particlePixels), 16 * 16 * 4, "soft particle texture size")
  assertEqual(particlePixels[(7 * 16 + 7) * 4 + 3], 253,
    "soft particle center alpha")
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
  assertNear(ogl.md2ModelPitch(17.5), 17.5, 0.000001,
    "Quake II alias-model pitch sign workaround")

  polyBlend = ogl.openGlPolyBlendColor([1.0, 0.5, 0.0, 0.25])
  assertEqual(polyBlend[0], 255, "polyblend red")
  assertEqual(polyBlend[1], 128, "polyblend green")
  assertEqual(polyBlend[2], 0, "polyblend blue")
  assertEqual(polyBlend[3], 64, "polyblend alpha")
  assertEqual(typeof(try(ogl.openGlPolyBlendColor([1.0, 0.0, 0.0]))),
    "error", "polyblend rejects malformed RefDef blend")

  renderer = ogl.createOpenGlRenderer(false)
  shadeRow0 = ogl.md2ShadeRow(renderer, 0.0)
  shadeRow1 = ogl.md2ShadeRow(renderer, 22.5)
  assertEqual(len(shadeRow0), 162 * 4, "MD2 shadedot row size")
  assertNear(oglbyteio.f32(shadeRow0, 0), 1.23, 0.0001,
    "MD2 yaw row zero first shadedot")
  assertNear(oglbyteio.f32(shadeRow0, 18 * 4), 0.82, 0.0001,
    "MD2 negative shadedot attenuation")
  assertNear(oglbyteio.f32(shadeRow1, 0), 1.26, 0.0001,
    "MD2 yaw row one first shadedot")
  assertEqual(nativeRawValue(ogl.md2ShadeRow(renderer, 0.0)),
    nativeRawValue(shadeRow0), "MD2 shadedot row cache reuse")
  shadedotHash = 2166136261
  shadedotRow = 0
  while shadedotRow < 16
    shadedotBytes = ogl.md2ShadeRow(renderer, shadedotRow * 22.5)
    shadedotByte = 0
    while shadedotByte < len(shadedotBytes)
      shadedotHash = ((shadedotHash ^ shadedotBytes[shadedotByte]) *
        16777619) & 0xffffffff
      shadedotByte = shadedotByte + 1
    end while
    shadedotRow = shadedotRow + 1
  end while
  assertEqual(shadedotHash, 869851233,
    "all 2,592 Quake II MD2 shadedots exact")

  shadow = rt.emptyEntity()
  shadow.origin = qt.vec3(4.0, 8.0, 64.0)
  assertEqual(ogl.shadows(renderer), false,
    "stock-compatible MD2 shadows default disabled")
  assertEqual(ogl.md2ShadowEligible(renderer, shadow), false,
    "disabled opaque alias does not cast shadow")
  ogl.setShadows(renderer, true)
  assertNear(ogl.setBrightness(renderer, 0.7), 0.7, 0.000001,
    "renderer brightness accepts video-menu range")
  assertNear(ogl.brightness(renderer), 0.7, 0.000001,
    "renderer brightness retained")
  assertEqual(typeof(try(ogl.setBrightness(renderer, 2.1))), "error",
    "renderer brightness rejects values above menu range")
  assertEqual(ogl.openGlMd2GeometryState(4, 3) !=
    ogl.openGlMd2GeometryState(5, 4), true,
    "MD2 GPU cache distinguishes animation frame pairs")
  assertEqual(ogl.openGlMd2GeometryState(233, 138) !=
    ogl.openGlMd2GeometryState(251, 68), true,
    "MD2 GPU cache key avoids former hash collision")
  assertEqual(ogl.openGlMd2StaticGeometryPass(4, 3, false),
    ogl.openGlMd2GeometryState(4, 3),
    "ordinary MD2 frame pair uses immutable cache")
  assertEqual(ogl.openGlMd2StaticGeometryPass(4, 3, true), -1,
    "backLerp-dependent shell bypasses immutable cache")
  assertEqual(ogl.md2ShadowEligible(renderer, shadow), true,
    "enabled opaque world alias casts shadow")
  shadow.flags = rc.RF_TRANSLUCENT
  assertEqual(ogl.md2ShadowEligible(renderer, shadow), false,
    "translucent alias does not cast shadow")
  shadow.flags = rc.RF_WEAPONMODEL
  assertEqual(ogl.md2ShadowEligible(renderer, shadow), false,
    "view weapon does not cast shadow")
  shadow.flags = rc.RF_FULLBRIGHT
  assertEqual(ogl.md2ShadowEligible(renderer, shadow), false,
    "fullbright flashes and explosions do not cast shadows")
  shadow.flags = 0
  assertNear(ogl.md2ShadowVectorX(0.0), 0.7071067812, 0.000001,
    "classic shadow yaw-zero x vector")
  assertNear(ogl.md2ShadowVectorX(90.0), 0.0, 0.0001,
    "classic shadow yaw-quarter x vector")
  assertNear(ogl.md2ShadowVectorY(90.0), -0.7071067812, 0.00001,
    "classic shadow yaw-quarter y vector")
  assertNear(ogl.md2ShadowLightHeight(shadow, 16.0), 48.0, 0.000001,
    "classic shadow light height")
  assertEqual(ogl.setShadows(renderer, false), false, "disable MD2 shadows")
  assertEqual(ogl.md2ShadowEligible(renderer, shadow), false,
    "disabled aliases do not cast shadows")
  assertEqual(typeof(try(ogl.setShadows(renderer, 1))), "error",
    "shadow setting rejects non-bool")
  ogl.setShadows(renderer, true)

  batchRecord = bytes(16)
  assertEqual(ogl.writeOpenGlMultitextureRecord(batchRecord, 0, shell,
    0x12345678, 0x0a0b0c0d), 16, "multitexture record size")
  assertEqual(batchRecord[8], 0x78, "multitexture base texture low byte")
  assertEqual(batchRecord[11], 0x12, "multitexture base texture high byte")
  assertEqual(batchRecord[12], 0x0d, "multitexture lightmap low byte")
  assertEqual(batchRecord[15], 0x0a, "multitexture lightmap high byte")

  particleRecord = bytes(16)
  assertEqual(ogl.writeOpenGlParticleRecord(particleRecord, 0,
    9 | (8 << 8) | (7 << 16), 123, qt.vec3(1.0, 2.0, 3.0)), 16,
    "particle record size")
  assertEqual(particleRecord[0], 9, "particle record red")
  assertEqual(particleRecord[1], 8, "particle record green")
  assertEqual(particleRecord[2], 7, "particle record blue")
  assertEqual(particleRecord[3], 123, "particle record alpha")
end function

// Verify retained sky clipping capacity and epsilon classification.
function testSkyClipScratchContracts()
  scratch = ogl.ensureOpenGlSkyClipScratch()
  assertEqual(len(scratch.translated), 72,
    "sky clipping reserves six split vertices")
  source = array(66)
  index = 0
  while index < len(source)
    source[index] = qt.vec3(1.0, 1.0, 1.0)
    index = index + 1
  end while
  assertEqual(typeof(try(ogl.clipOpenGlSkyPolygon(
    ogl.createOpenGlSkyBounds(), source, 66, 0))) != "error", true,
    "66-vertex source polygon remains within retained workspace")

  // Prime the retained side byte, then place a vertex exactly inside the
  // epsilon band. It must be classified as ON instead of inheriting history.
  scratch.sides[0][0] = 1
  epsilonVertices = [qt.vec3(1.0, -1.0, 1.0),
    qt.vec3(2.0, 0.0, 1.0), qt.vec3(-2.0, 0.0, 1.0)]
  ogl.clipOpenGlSkyPolygon(ogl.createOpenGlSkyBounds(), epsilonVertices, 3, 0)
  assertEqual(scratch.sides[0][0], 0,
    "sky epsilon vertex clears retained side state")
end function

// Verify the lightweight product RefDef guard used by a live GL context.
function testProductRefDefPreparation()
  frame = rt.defaultRefDef(640, 480)
  frame.entities = [rt.emptyEntity()]
  frame.numEntities = 0
  assertEqual(ogl.prepareProductRefDef(frame), true,
    "product RefDef accepted")
  assertEqual(frame.numEntities, 1,
    "effect-mutated entity count synchronized")
  minimized = rt.defaultRefDef(0, 0)
  assertEqual(ogl.prepareProductRefDef(minimized), false,
    "minimized zero viewport skipped")
  malformed = rt.defaultRefDef(640, 480)
  malformed.lightStyles = []
  assertEqual(typeof(try(ogl.prepareProductRefDef(malformed))), "error",
    "malformed product light styles rejected precisely")
end function

testHeadlessLifecycle()
testClassicDrawingHelpers()
testProductRefDefPreparation()
testSkyClipScratchContracts()
print("MiniQuake2 OpenGL adapter tests passed: 4")
