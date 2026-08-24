/* Deterministic textured MD2 registration, interpolation and lifecycle. */
import miniquake2.format.constants as fc
import miniquake2.native as md2testnative
import miniquake2.qcommon.byteio as md2testbyteio
import miniquake2.renderer.types as rt
import miniquake2.renderer.constants as rc
import miniquake2.renderer.geometry as rgeom
import miniquake2.renderer.opengl as ropengl

function assertEqual(actual, expected, name)
  if actual != expected then return error(7992, name + ": expected " + expected + ", got " + actual) end if
end function

function assertNear(actual, expected, tolerance, name)
  difference = actual - expected
  if difference < 0.0 then difference = -difference end if
  if difference > tolerance then return error(7993, name + ": outside tolerance") end if
end function

function putText(data, offset, value)
  encoded = bytes(value)
  md2testbyteio.copyInto(data, offset, encoded, 0, len(encoded))
end function

function putFrame(data, offset, name, xOffset)
  md2testbyteio.putF32(data, offset, 1.0)
  md2testbyteio.putF32(data, offset + 4, 1.0)
  md2testbyteio.putF32(data, offset + 8, 1.0)
  md2testbyteio.putF32(data, offset + 12, 0.0)
  md2testbyteio.putF32(data, offset + 16, 0.0)
  md2testbyteio.putF32(data, offset + 20, 0.0)
  putText(data, offset + 24, name)
  data[offset + 40] = xOffset; data[offset + 41] = 0; data[offset + 42] = 0; data[offset + 43] = 0
  data[offset + 44] = xOffset + 8; data[offset + 45] = 0; data[offset + 46] = 0; data[offset + 47] = 0
  data[offset + 48] = xOffset; data[offset + 49] = 8; data[offset + 50] = 0; data[offset + 51] = 0
end function

function md2Bytes()
  data = bytes(260)
  md2testbyteio.putU32(data, 0, fc.IDALIASHEADER)
  md2testbyteio.putI32(data, 4, fc.ALIAS_VERSION)
  md2testbyteio.putI32(data, 8, 2); md2testbyteio.putI32(data, 12, 2)
  md2testbyteio.putI32(data, 16, 52)
  md2testbyteio.putI32(data, 20, 1); md2testbyteio.putI32(data, 24, 3)
  md2testbyteio.putI32(data, 28, 3); md2testbyteio.putI32(data, 32, 1)
  md2testbyteio.putI32(data, 36, 0); md2testbyteio.putI32(data, 40, 2)
  md2testbyteio.putI32(data, 44, 68); md2testbyteio.putI32(data, 48, 132)
  md2testbyteio.putI32(data, 52, 144); md2testbyteio.putI32(data, 56, 156)
  md2testbyteio.putI32(data, 60, 260); md2testbyteio.putI32(data, 64, 260)
  putText(data, 68, "models/test/skin.pcx")
  md2testbyteio.putI16(data, 132, 0); md2testbyteio.putI16(data, 134, 0)
  md2testbyteio.putI16(data, 136, 2); md2testbyteio.putI16(data, 138, 0)
  md2testbyteio.putI16(data, 140, 0); md2testbyteio.putI16(data, 142, 2)
  md2testbyteio.putU16(data, 144, 0); md2testbyteio.putU16(data, 146, 1); md2testbyteio.putU16(data, 148, 2)
  md2testbyteio.putU16(data, 150, 0); md2testbyteio.putU16(data, 152, 1); md2testbyteio.putU16(data, 154, 2)
  putFrame(data, 156, "idle01", 0)
  putFrame(data, 208, "idle02", 4)
  return data
end function

function skinPcxBytes()
  data = bytes(901)
  data[0] = 0x0a; data[1] = 5; data[2] = 1; data[3] = 8
  data[8] = 1; data[10] = 1
  data[65] = 1; md2testbyteio.putU16(data, 66, 2)
  data[128] = 1; data[129] = 2; data[130] = 2; data[131] = 1
  data[132] = 12
  palette = 133
  data[palette + 3] = 20; data[palette + 4] = 40; data[palette + 5] = 60
  data[palette + 6] = 80; data[palette + 7] = 100; data[palette + 8] = 120
  return data
end function

function loadMd2File(path)
  if path == "models/test/tris.md2" then return md2Bytes() end if
  if path == "models/test/skin.pcx" then return skinPcxBytes() end if
  return void
end function

function testFfiScalarLifetimeSoak(renderer, entity)
  replaySignature = -1.0
  allocationPressure = array(16, void)
  iteration = 0
  while iteration < 1000
    plan = ropengl.prepareMd2Entity(renderer, entity)
    assertNear(plan.mesh.vertices[0].position.x, 2.0, 0.0001, "GC-rooted mesh position")
    scalars = plan.glVertices
    assertEqual(len(scalars), 15, "flattened GL scalar count")
    scalarIndex = 0
    signature = 0.0
    while scalarIndex < len(scalars)
      // Match drawOpenGlMd2Plan: all five primitives are rooted before the
      // first FFI boundary. floatBits is a harmless native lifetime barrier.
      textureS = scalars[scalarIndex]
      textureT = scalars[scalarIndex + 1]
      positionX = scalars[scalarIndex + 2]
      positionY = scalars[scalarIndex + 3]
      positionZ = scalars[scalarIndex + 4]
      md2testnative.floatBits(textureS)
      md2testnative.floatBits(textureT)
      md2testnative.floatBits(positionX)
      md2testnative.floatBits(positionY)
      md2testnative.floatBits(positionZ)
      signature = signature + textureS + textureT + positionX + positionY + positionZ
      scalarIndex = scalarIndex + 5
    end while
    assertNear(signature, 24.0, 0.0001, "FFI-rooted MD2 scalar signature")
    if iteration == 0 then replaySignature = signature end if
    assertEqual(signature, replaySignature, "1000-frame MD2 FFI replay")
    allocationPressure[iteration & 15] = array(4096, iteration)
    iteration = iteration + 1
  end while
end function

function testRegistrationInterpolationAndBounds()
  renderer = ropengl.createOpenGlRenderer(false)
  renderer.exports.Init(void, void)
  renderer.exports.BeginRegistration("md2-test")
  handle = ropengl.registerMd2Model(renderer, "models/test/tris.md2", loadMd2File)
  renderer.exports.EndRegistration()
  assertEqual(handle.kind, "model", "MD2 resource handle")
  assertEqual(handle.generation, renderer.state.assets.generation, "registration generation")
  assertEqual(len(renderer.state.textureRecords), 1, "PCX texture handle allocated")
  assertEqual(renderer.state.textureRecords[0].uploaded, false, "headless PCX remains CPU-side")

  entity = rt.emptyEntity()
  entity.model = handle
  entity.frame = 1
  entity.oldFrame = 0
  entity.backLerp = 0.5
  entity.skinNum = 99
  plan = ropengl.prepareMd2Entity(renderer, entity)
  assertEqual(plan.skinAsset.handle.name, "models/test/skin.pcx", "MD2 default PCX skin")
  assertEqual(len(plan.modelAsset.source.frames), 2, "registered MD2 frames")
  assertEqual(plan.modelAsset.source.frames[1].name, "idle02", "registered frame name")
  assertEqual(ropengl.picturePixels(plan.skinAsset), bytes([20, 40, 60, 255, 80, 100, 120, 255, 80, 100, 120, 255, 20, 40, 60, 255]), "PCX skin palette expansion")
  assertEqual(ropengl.pictureUploadPixels(plan.skinAsset), bytes([40, 80, 120, 255, 160, 200, 240, 255, 160, 200, 240, 255, 40, 80, 120, 255]), "ref_gl intensity-scaled PCX skin upload")
  assertEqual(plan.mesh.triangleCount, 1, "MD2 triangle count")
  entity.flags = rc.RF_WEAPONMODEL
  assertEqual(ropengl.setHandedness(renderer, 1), 1, "left-hand renderer state")
  assertEqual(ropengl.handedness(renderer), 1, "left-hand state retained")
  assertEqual(ropengl.md2EntityVisible(renderer, entity), true,
    "left-hand view weapon remains visible")
  ropengl.setHandedness(renderer, 2)
  assertEqual(ropengl.md2EntityVisible(renderer, entity), false,
    "center-hand view weapon hidden by renderer")
  hiddenStats = ropengl.submitMd2Entity(renderer, entity)
  assertEqual(hiddenStats.triangles, 0, "center-hand view weapon not submitted")
  ropengl.setHandedness(renderer, 0)
  entity.flags = 0
  assertNear(plan.mesh.vertices[0].position.x, 2.0, 0.0001, "interpolated first vertex")
  assertNear(plan.mesh.vertices[1].position.x, 10.0, 0.0001, "interpolated second vertex")
  assertNear(plan.mesh.vertices[1].s, 1.0, 0.0001, "normalized skin coordinate")
  shellScalars = rgeom.md2PowerShellFrameScalars(plan.modelAsset.source, 1, 0, 0.5)
  assertNear(shellScalars[2], 2.0 - 0.525731 * 4.0, 0.0001,
    "power-shell normal expansion x")
  assertNear(shellScalars[4], 0.850651 * 4.0, 0.0001,
    "power-shell normal expansion z")
  assertNear(plan.bounds.mins.x, 2.0, 0.0001, "interpolated bounds minimum")
  assertNear(plan.bounds.maxs.x, 10.0, 0.0001, "interpolated bounds maximum")
  frameBounds = ropengl.md2ModelFrameBounds(renderer, handle, 1)
  assertNear(frameBounds.mins.x, 4.0, 0.0001, "registered frame bounds minimum")
  assertNear(frameBounds.maxs.x, 12.0, 0.0001, "registered frame bounds maximum")
  replay = ropengl.prepareMd2Entity(renderer, entity)
  assertEqual(replay.mesh.vertices[0].position.x, plan.mesh.vertices[0].position.x, "deterministic interpolation replay")
  testFfiScalarLifetimeSoak(renderer, entity)
  stats = ropengl.submitMd2Entity(renderer, entity)
  assertEqual(stats.submitted, false, "headless GL submission")
  assertEqual(stats.triangles, 1, "headless planned triangles")
  assertEqual(typeof(try(ropengl.md2ModelFrameBounds(renderer, handle, 7))), "error", "bad bounds frame rejected")
  entity.frame = 7
  fallback = ropengl.prepareMd2Entity(renderer, entity)
  assertEqual(fallback.frame, 0, "bad entity frame falls back to zero")
  assertEqual(fallback.oldFrame, 0, "bad entity old frame falls back with current")
  assertNear(fallback.mesh.vertices[0].position.x, 0.0, 0.0001,
    "fallback uses first MD2 frame")

  renderer.state.textureRecords[0].uploaded = true
  renderer.exports.BeginRegistration("next-generation")
  assertEqual(renderer.state.textureRecords[0].released, true, "headless logical texture release")
  assertEqual(renderer.state.textureRecords[0].uploaded, false, "released upload state cleared")
  assertEqual(typeof(try(ropengl.prepareMd2Entity(renderer, entity))), "error", "stale model handle rejected")
  replacement = ropengl.registerMd2Model(renderer, "models/test/tris.md2", loadMd2File)
  renderer.exports.EndRegistration()
  assertEqual(replacement.generation, handle.generation + 1, "next model generation")
  assertEqual(renderer.state.textureRecords[1].id, renderer.state.textureRecords[0].id + 1, "texture ids are not reused")
  renderer.state.textureRecords[1].uploaded = true
  renderer.exports.Shutdown()
  assertEqual(renderer.state.textureRecords[1].released, true, "shutdown texture release")
end function

testRegistrationInterpolationAndBounds()
print("renderer MD2 submission tests passed")
