/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Asset-free native MiniLang tests for the Quake II Renderer API v3 port. */
import miniquake2.qcommon.types as qtypes
import miniquake2.renderer.constants as c
import miniquake2.renderer.types as t
import miniquake2.renderer.validation as validation
import miniquake2.renderer.recording as recording

// Assert the equal test condition.
function assertEqual(actual, expected, name)
  if actual != expected then return error(9950, name + ": expected " + expected + ", got " + actual) end if
  return true
end function

// Assert the true test condition.
function assertTrue(value, name)
  if value != true then return error(9951, name + ": expected true") end if
  return true
end function

// Report whether no result 0.
function noResult0()
end function

// Report whether no result 1.
function noResult1(a)
end function

// Report whether no result 2.
function noResult2(a, b)
end function

// Report whether no result 3.
function noResult3(a, b, c)
end function

// Report whether no result 4.
function noResult4(a, b, c, d)
end function

// Return zero 0.
function returnZero0()
  return 0
end function

// Report whether return empty 1.
function returnEmpty1(a)
  return ""
end function

// Return void 1.
function returnVoid1(a)
  return void
end function

// Return mode 1.
function returnMode1(mode)
  return t.VideoModeInfo(false, 0, 0)
end function

// Create imports.
function makeImports()
  return t.RefImport(noResult2, noResult2, noResult1, returnZero0, returnEmpty1, noResult2, noResult2, returnVoid1, noResult1, returnZero0, noResult3, noResult2, noResult2, returnMode1, noResult0, noResult2)
end function

// Return the populated frame value.
function populatedFrame()
  zero = qtypes.zeroVec3()
  entity = t.entity(void, zero, qtypes.vec3(1.0, 2.0, 3.0), 2, zero, 1, 0.25, 4, 0, 0.75, void, c.RF_TRANSLUCENT)
  light = t.dLight(qtypes.vec3(4.0, 5.0, 6.0), qtypes.vec3(1.0, 0.5, 0.25), 240.0)
  particle = t.particle(qtypes.vec3(7.0, 8.0, 9.0), 17, 0.5)
  return t.refDef(10, 20, 640, 480, 90.0, 73.0, zero, zero, [0.1, 0.2, 0.3, 0.4], 12.5, c.RDF_UNDERWATER, bytes([3]), t.defaultLightStyles(), [entity], [light], [particle])
end function

// Verify constants and types.
function testConstantsAndTypes()
  assertEqual(c.API_VERSION, 3, "API version")
  assertEqual(c.MAX_DLIGHTS, 32, "dynamic light limit")
  assertEqual(c.MAX_ENTITIES, 128, "entity limit")
  assertEqual(c.MAX_PARTICLES, 4096, "particle limit")
  assertEqual(c.MAX_LIGHTSTYLES, 256, "light style limit")
  assertEqual(c.ENTITY_FLAGS, 68, "entity flags wire offset")
  frame = populatedFrame()
  assertEqual(frame.numEntities, 1, "managed entity count")
  assertEqual(frame.numDLights, 1, "managed dlight count")
  assertEqual(frame.numParticles, 1, "managed particle count")
  assertEqual(len(frame.lightStyles), 256, "managed light styles")
  assertTrue(validation.validateRefDef(frame).valid, "valid populated refdef")
end function

// Verify validation failures.
function testValidationFailures()
  frame = populatedFrame()
  frame.numEntities = 2
  checked = validation.validateRefDef(frame)
  assertEqual(checked.valid, false, "count mismatch rejected")
  assertEqual(checked.code, "refdef.entities.count", "count mismatch code")
  frame = populatedFrame()
  frame.fovX = 180.0
  assertEqual(validation.validateRefDef(frame).code, "refdef.fov", "invalid fov code")
  frame = populatedFrame()
  frame.particles[0].alpha = 1.5
  assertEqual(validation.validateRefDef(frame).code, "particle.alpha", "invalid particle alpha code")
end function

// Verify api tables.
function testApiTables()
  imports = makeImports()
  checked = validation.validateRefImport(imports)
  assertTrue(checked.valid, "complete refimport table")
  renderer = recording.getRefAPI(imports, "recording")
  assertTrue(renderer.state.imports == imports, "GetRefAPI retains imports")
  badImports = makeImports()
  badImports.vidNewWindow = void
  assertEqual(validation.validateRefImport(badImports).code, "api.function", "missing import function rejected")
  rejected = try(recording.getRefAPI(badImports, "recording"))
  assertEqual(typeof(rejected), "error", "GetRefAPI rejects malformed imports")
  checked = validation.validateRefExport(renderer.exports)
  assertTrue(checked.valid, "complete refexport table")
  assertEqual(typeof(renderer.exports.RenderFrame), "function", "RenderFrame is first-class")
  malformed = renderer.exports
  malformed.apiVersion = 2
  assertEqual(validation.validateRefExport(malformed).code, "export.version", "API mismatch rejected")
end function

// Verify recording renderer.
function testRecordingRenderer()
  renderer = recording.createRecordingRenderer()
  api = renderer.exports
  assertEqual(api.Init(void, void), true, "recording Init")
  api.BeginRegistration("base1")
  model = api.RegisterModel("models/objects/barrels/tris.md2")
  sameModel = api.RegisterModel("models/objects/barrels/tris.md2")
  skin = api.RegisterSkin("players/male/grunt.pcx")
  picture = api.RegisterPic("inventory")
  assertEqual(model.id, sameModel.id, "registration deduplicates model")
  assertTrue(model.id != skin.id, "resource ids are stable and distinct")
  assertTrue(recording.isHandleCurrent(renderer, model), "new handle current")
  api.SetSky("unit1_", 3.0, qtypes.vec3(0.0, 0.0, 1.0))
  api.EndRegistration()
  api.BeginFrame(0.0)
  api.RenderFrame(populatedFrame())
  api.DrawPic(4, 8, "inventory")
  api.DrawStretchPic(8, 16, 64, 32, "inventory")
  api.DrawChar(12, 20, 65)
  api.DrawTileClear(0, 0, 320, 8, "backtile")
  api.DrawFill(0, 0, 16, 16, 7)
  api.DrawFadeScreen()
  api.DrawStretchRaw(0, 0, 2, 2, 2, 2, bytes([1, 2, 3, 4]))
  size = api.DrawGetPicSize("missing")
  assertEqual(size.width, 0, "null picture width")
  assertEqual(size.height, 0, "null picture height")
  api.CinematicSetPalette(bytes(768))
  api.CinematicSetPalette(void)
  api.EndFrame()
  api.AppActivate(false)
  api.Shutdown()
  assertEqual(renderer.state.frameCount, 1, "recorded frame count")
  assertEqual(renderer.state.appActive, false, "application activation state")
  assertEqual(renderer.state.commands[0].operation, "Init", "first command")
  assertEqual(renderer.state.commands[1].arguments, "base1:1", "registration generation trace")
  assertEqual(renderer.state.commands[2].arguments, "models/objects/barrels/tris.md2:1", "deterministic model trace")
  assertEqual(renderer.state.commands[3].arguments, "models/objects/barrels/tris.md2:1", "deduplicated model trace")
  assertEqual(renderer.state.commands[len(renderer.state.commands) - 1].operation, "Shutdown", "last command")
  assertEqual(len(renderer.state.commands), 23, "all v3 entry points recorded")
  traceA = recording.commandTrace(renderer)
  second = recording.createRecordingRenderer()
  second.exports.Init(void, void)
  second.exports.BeginRegistration("base1")
  second.exports.RegisterModel("models/objects/barrels/tris.md2")
  second.exports.RegisterModel("models/objects/barrels/tris.md2")
  second.exports.RegisterSkin("players/male/grunt.pcx")
  second.exports.RegisterPic("inventory")
  second.exports.SetSky("unit1_", 3.0, qtypes.vec3(0.0, 0.0, 1.0))
  second.exports.EndRegistration()
  second.exports.BeginFrame(0.0)
  second.exports.RenderFrame(populatedFrame())
  second.exports.DrawPic(4, 8, "inventory")
  second.exports.DrawStretchPic(8, 16, 64, 32, "inventory")
  second.exports.DrawChar(12, 20, 65)
  second.exports.DrawTileClear(0, 0, 320, 8, "backtile")
  second.exports.DrawFill(0, 0, 16, 16, 7)
  second.exports.DrawFadeScreen()
  second.exports.DrawStretchRaw(0, 0, 2, 2, 2, 2, bytes([1, 2, 3, 4]))
  second.exports.DrawGetPicSize("missing")
  second.exports.CinematicSetPalette(bytes(768))
  second.exports.CinematicSetPalette(void)
  second.exports.EndFrame()
  second.exports.AppActivate(false)
  second.exports.Shutdown()
  assertEqual(recording.commandTrace(second), traceA, "deterministic replay trace")
end function

// Verify null renderer.
function testNullRenderer()
  renderer = recording.createNullRenderer()
  api = renderer.exports
  api.Init(void, void)
  api.BeginFrame(0.0)
  api.RenderFrame(t.defaultRefDef(320, 200))
  api.EndFrame()
  assertEqual(renderer.state.frameCount, 1, "null renderer consumes frame")
  assertEqual(len(renderer.state.commands), 0, "null renderer retains no commands")
  api.Shutdown()
end function

// Verify lifecycle errors.
function testLifecycleErrors()
  renderer = recording.createRecordingRenderer()
  beforeInit = try(renderer.exports.BeginFrame(0.0))
  assertEqual(typeof(beforeInit), "error", "frame before Init rejected")
  renderer.exports.Init(void, void)
  renderer.exports.BeginFrame(0.0)
  nestedFrame = try(renderer.exports.BeginFrame(0.0))
  assertEqual(typeof(nestedFrame), "error", "nested BeginFrame rejected")
  renderer.exports.EndFrame()
  extraEnd = try(renderer.exports.EndFrame())
  assertEqual(typeof(extraEnd), "error", "unpaired EndFrame rejected")
  badRaw = try(renderer.exports.DrawStretchRaw(0, 0, 4, 4, 4, 4, bytes(15)))
  assertEqual(typeof(badRaw), "error", "truncated cinematic frame rejected")
  badPalette = try(renderer.exports.CinematicSetPalette(bytes(767)))
  assertEqual(typeof(badPalette), "error", "short cinematic palette rejected")
  renderer.exports.Shutdown()
end function

testConstantsAndTypes()
testValidationFailures()
testApiTables()
testRecordingRenderer()
testNullRenderer()
testLifecycleErrors()
print "renderer_contract_tests: PASS"
