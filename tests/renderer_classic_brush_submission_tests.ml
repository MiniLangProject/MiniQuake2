/* Product-shaped inline BSP (*n) registration, visibility and submission. */
import miniquake2.format.constants as rbrushtestformatconstants
import miniquake2.format.types as rbrushtestformattypes
import miniquake2.qcommon.types as rbrushtestqtypes
import miniquake2.renderer.constants as rbrushtestrendererconstants
import miniquake2.renderer.types as rbrushtestrenderertypes
import miniquake2.renderer.opengl as rbrushtestopengl
import miniquake2.renderer.classic.visibility as rbrushtestvisibility
import miniquake2.renderer.classic.special as rbrushtestspecial

function assertEqual(actual, expected, name)
  if actual != expected then return error(7999, name + ": expected " + expected + ", got " + actual) end if
end function

function assertNear(actual, expected, epsilon, name)
  delta = actual - expected
  if delta < 0.0 then delta = -delta end if
  if delta > epsilon then return error(8000, name + ": expected " + expected + ", got " + actual) end if
end function

function brushNoResult0()
end function
function brushNoResult1(a)
end function
function brushNoResult2(a, b)
end function
function brushNoResult3(a, b, c)
end function
function brushReturnZero0()
  return 0
end function
function brushReturnEmpty1(a)
  return ""
end function
function brushReturnMode1(mode)
  return rbrushtestrenderertypes.VideoModeInfo(false, 0, 0)
end function

function brushPutU32(data, offset, value)
  data[offset] = value & 255; data[offset + 1] = (value >> 8) & 255
  data[offset + 2] = (value >> 16) & 255; data[offset + 3] = (value >> 24) & 255
end function

function brushPutText(data, offset, value)
  encoded = bytes(value)
  index = 0
  while index < len(encoded)
    data[offset + index] = encoded[index]
    index = index + 1
  end while
end function

function brushPalettePcx()
  data = bytes(899)
  data[0] = 0x0a; data[1] = 5; data[2] = 1; data[3] = 8
  data[8] = 1; data[65] = 1; data[66] = 2
  data[128] = 1; data[129] = 1; data[130] = 12
  data[134] = 40; data[135] = 80; data[136] = 120
  return data
end function

function brushWal(name)
  data = bytes(107)
  brushPutText(data, 0, name)
  brushPutU32(data, 32, 2); brushPutU32(data, 36, 2)
  brushPutU32(data, 40, 100); brushPutU32(data, 44, 104)
  brushPutU32(data, 48, 105); brushPutU32(data, 52, 106)
  data[100] = 1; data[101] = 1; data[102] = 1; data[103] = 1
  data[104] = 1; data[105] = 1; data[106] = 1
  return data
end function

function loadBrushFile(path)
  if path == "pics/colormap.pcx" then return brushPalettePcx() end if
  if path == "textures/world.wal" then return brushWal("world") end if
  if path == "textures/worldglass.wal" then return brushWal("worldglass") end if
  if path == "textures/door.wal" then return brushWal("door") end if
  if path == "textures/door2.wal" then return brushWal("door2") end if
  if path == "textures/water.wal" then return brushWal("water") end if
  if path == "textures/glass.wal" then return brushWal("glass") end if
  if path == "textures/sky.wal" then return brushWal("sky") end if
  return void
end function

function brushImports()
  return rbrushtestrenderertypes.RefImport(
    brushNoResult2, brushNoResult2, brushNoResult1, brushReturnZero0,
    brushReturnEmpty1, brushNoResult2, brushNoResult2, loadBrushFile,
    brushNoResult1, brushReturnZero0, brushNoResult3, brushNoResult2,
    brushNoResult2, brushReturnMode1, brushNoResult0, brushNoResult2
  )
end function

function brushMap()
  vertices = [
    rbrushtestformattypes.BspVertex(rbrushtestformattypes.Vec3(8.0, -8.0, -8.0)),
    rbrushtestformattypes.BspVertex(rbrushtestformattypes.Vec3(8.0, 8.0, -8.0)),
    rbrushtestformattypes.BspVertex(rbrushtestformattypes.Vec3(8.0, 8.0, 8.0)),
    rbrushtestformattypes.BspVertex(rbrushtestformattypes.Vec3(8.0, -8.0, 8.0))
  ]
  edges = [
    rbrushtestformattypes.BspEdge(0, 1), rbrushtestformattypes.BspEdge(1, 2),
    rbrushtestformattypes.BspEdge(2, 3), rbrushtestformattypes.BspEdge(3, 0)
  ]
  textureVectorS = [0.0, 1.0, 0.0, 0.0]
  textureVectorT = [0.0, 0.0, 1.0, 0.0]
  texInfo = [
    rbrushtestformattypes.BspTexInfo(textureVectorS, textureVectorT, 0, 0, "world", -1),
    rbrushtestformattypes.BspTexInfo(textureVectorS, textureVectorT, rbrushtestformatconstants.SURF_TRANS66, 0, "worldglass", -1),
    rbrushtestformattypes.BspTexInfo(textureVectorS, textureVectorT, rbrushtestformatconstants.SURF_FLOWING, 0, "door", 6),
    rbrushtestformattypes.BspTexInfo(textureVectorS, textureVectorT, rbrushtestformatconstants.SURF_WARP, 0, "water", -1),
    rbrushtestformattypes.BspTexInfo(textureVectorS, textureVectorT, rbrushtestformatconstants.SURF_TRANS33, 0, "glass", -1),
    rbrushtestformattypes.BspTexInfo(textureVectorS, textureVectorT, rbrushtestformatconstants.SURF_SKY, 0, "sky", -1),
    rbrushtestformattypes.BspTexInfo(textureVectorS, textureVectorT, rbrushtestformatconstants.SURF_FLOWING, 0, "door2", 2)
  ]
  faces = array(6)
  faceIndex = 0
  while faceIndex < 6
    faces[faceIndex] = rbrushtestformattypes.BspFace(0, 0, 0, 4, faceIndex, bytes([0, 255, 255, 255]), -1)
    faceIndex = faceIndex + 1
  end while
  faces[2].lightOffset = 0
  plane = rbrushtestformattypes.BspPlane(rbrushtestformattypes.Vec3(-1.0, 0.0, 0.0), -8.0, 0)
  worldModel = rbrushtestformattypes.BspModel(
    rbrushtestformattypes.Vec3(8.0, -8.0, -8.0), rbrushtestformattypes.Vec3(8.0, 8.0, 8.0),
    rbrushtestformattypes.Vec3(0.0, 0.0, 0.0), 0, 0, 2
  )
  brushModel = rbrushtestformattypes.BspModel(
    rbrushtestformattypes.Vec3(8.0, -8.0, -8.0), rbrushtestformattypes.Vec3(8.0, 8.0, 8.0),
    rbrushtestformattypes.Vec3(0.0, 0.0, 0.0), 0, 2, 4
  )
  lighting = bytes(27)
  lightIndex = 0
  while lightIndex < len(lighting)
    lighting[lightIndex] = 20
    lightIndex = lightIndex + 1
  end while
  return rbrushtestformattypes.BspMap(
    "maps/brush.bsp", bytes(0), [], "", [plane], vertices, void, [], texInfo,
    faces, lighting, [], [], [], edges, [0, 1, 2, 3], [worldModel, brushModel], [], [], [], []
  )
end function

function brushFrame(handle, origin, angles, flags, alpha)
  entity = rbrushtestrenderertypes.entity(
    handle, angles, origin, 0, origin, 0, 0.0, 0, 0, alpha, void, flags
  )
  zero = rbrushtestqtypes.zeroVec3()
  return rbrushtestrenderertypes.refDef(
    0, 0, 640, 480, 90.0, 73.0, zero, zero,
    [0.0, 0.0, 0.0, 0.0], 1.25, 0, void,
    rbrushtestrenderertypes.defaultLightStyles(), [entity], [], []
  )
end function

function testProductShapedInlineBrushSubmission()
  renderer = rbrushtestopengl.getRefAPI(brushImports(), false)
  renderer.exports.Init(void, void)
  renderer.exports.BeginRegistration("maps/brush.bsp")
  map = brushMap()
  worldHandle = rbrushtestopengl.adoptClassicMapModel(renderer, map, "maps/brush.bsp")
  world = rbrushtestopengl.prepareClassicWorld(renderer, map, loadBrushFile, rbrushtestrenderertypes.defaultLightStyles(), 0, 1.0)
  inlineHandle = renderer.exports.RegisterModel("*1")
  repeated = renderer.exports.RegisterModel("*1")
  renderer.exports.EndRegistration()

  assertEqual(inlineHandle.id, repeated.id, "product RegisterModel inline cache")
  assertEqual(worldHandle.generation, inlineHandle.generation, "shared registration generation")
  assertEqual(len(world.brushModels), 1, "prepared inline model table")
  assertEqual(len(world.brushModels[0].draws), 4, "inline face range only")
  assertEqual(len(world.textures), 9, "animated world and inline shared lifecycle resources")

  frame = brushFrame(inlineHandle, rbrushtestqtypes.Vec3(64.0, 0.0, 0.0), rbrushtestqtypes.zeroVec3(), 0, 1.0)
  brushPlan = rbrushtestopengl.prepareClassicBrushFrame(renderer, world, frame)
  assertEqual(rbrushtestopengl.classicBrushFrameSignature(brushPlan), "1:0:4:22:*1@64.,0.,0./o2,w3,s5,a4@0.33,", "inline special pass golden")
  doorDraw = brushPlan.submissions[0].plan.opaqueDraws[0]
  assertEqual(len(doorDraw.baseTextures), 2, "texinfo animation resources retained")
  assertEqual(rbrushtestspecial.classicSpecialBaseTexture(doorDraw, 0.0).name, "door", "runtime animation frame zero")
  assertEqual(rbrushtestspecial.classicSpecialBaseTexture(doorDraw, 0.5).name, "door2", "runtime animation frame one")
  assertEqual(rbrushtestspecial.classicSpecialBaseTexture(doorDraw, 1.0).name, "door", "runtime animation cycle")
  worldSelection = rbrushtestvisibility.selectClassicWorld(world, frame)
  worldPlan = rbrushtestspecial.classicSpecialPassPlan(worldSelection.draws, frame)
  transparentFrame = rbrushtestopengl.prepareClassicTransparentFrame(worldPlan, brushPlan, frame)
  assertEqual(rbrushtestopengl.classicTransparentFrameSignature(transparentFrame), "b4@0.33,w1@0.66,", "world and brush polygon alpha sort")
  stats = rbrushtestopengl.submitClassicWorld(renderer, world, frame)
  assertEqual(stats.brushEntities, 1, "visible brush entity")
  assertEqual(stats.brushSurfaces, 4, "visible brush surfaces")
  assertEqual(stats.brushTriangles, 22, "subdivided brush triangles")
  assertEqual(stats.brushCulledEntities, 0, "visible brush cull count")
  assertEqual(stats.transparentDraws, 2, "combined transparent draw count")

  dynamicLight = rbrushtestrenderertypes.dLight(
    rbrushtestqtypes.Vec3(72.0, 0.0, 0.0), rbrushtestqtypes.Vec3(1.0, 0.0, 0.0), 200.0
  )
  frame.dLights = [dynamicLight]; frame.numDLights = 1
  litPlan = rbrushtestopengl.prepareClassicBrushFrame(renderer, world, frame)
  assertEqual(litPlan.dirtyLightmaps, 1, "transformed brush dynamic light dirty count")
  assertEqual(litPlan.submissions[0].dynamicLightmaps[0].dirty, true, "brush lightmap marked dirty")
  staticPixels = litPlan.submissions[0].dynamicLightmaps[0].draw.surface.lightmap
  dynamicPixels = litPlan.submissions[0].dynamicLightmaps[0].rgbaPixels
  assertEqual(dynamicPixels != staticPixels, true, "dynamic brush light contribution")
  assertEqual(rbrushtestopengl.submitClassicWorld(renderer, world, frame).brushDirtyLightmaps, 1, "dirty lightmap submit stats")
  frame.dLights = []; frame.numDLights = 0

  frame.entities[0].angles = rbrushtestqtypes.Vec3(0.0, 90.0, 0.0)
  rotatedPlan = rbrushtestopengl.prepareClassicBrushFrame(renderer, world, frame)
  assertEqual(len(rotatedPlan.submissions), 1, "rotated brush remains visible")
  localView = rbrushtestvisibility.classicVisibilityBrushLocalView(frame.entities[0], frame.viewOrigin)
  assertNear(localView.y, 64.0, 0.001, "rotated local model view")
  rotatedBounds = rbrushtestvisibility.classicVisibilityBrushBounds(world.brushModels[0], frame.entities[0])
  assertNear(rotatedBounds.maxs.x, 77.856406, 0.0001, "rotated radius visibility bounds")

  frame.entities[0].origin = rbrushtestqtypes.Vec3(-256.0, 0.0, 0.0)
  frame.entities[0].angles = rbrushtestqtypes.zeroVec3()
  hidden = rbrushtestopengl.submitClassicWorld(renderer, world, frame)
  assertEqual(hidden.brushEntities, 0, "behind-camera brush omitted")
  assertEqual(hidden.brushCulledEntities, 1, "brush frustum cull accounted")

  frame.entities[0].origin = rbrushtestqtypes.Vec3(64.0, 0.0, 0.0)
  frame.entities[0].flags = rbrushtestrendererconstants.RF_TRANSLUCENT
  frame.entities[0].alpha = 0.5
  assertEqual(rbrushtestopengl.prepareClassicBrushFrame(renderer, world, frame).surfaces, 4, "translucent entity retains special surfaces")

  soak = 0
  while soak < 1000
    frame.entities[0].flags = 0; frame.entities[0].alpha = 1.0
    frame.entities[0].origin = rbrushtestqtypes.Vec3(64.0 + (soak % 3) * 8.0, 0.0, 0.0)
    frame.time = (soak % 2) * 0.5
    if (soak & 1) == 0 then
      movingLight = rbrushtestrenderertypes.dLight(
        rbrushtestqtypes.Vec3(frame.entities[0].origin.x + 8.0, 0.0, 0.0),
        rbrushtestqtypes.Vec3(1.0, 0.0, 0.0), 200.0
      )
      frame.dLights = [movingLight]; frame.numDLights = 1
    else
      frame.dLights = []; frame.numDLights = 0
    end if
    soakStats = rbrushtestopengl.submitClassicWorld(renderer, world, frame)
    assertEqual(soakStats.brushEntities, 1, "1000-frame moving brush visibility")
    assertEqual(soakStats.transparentDraws, 2, "1000-frame combined alpha plan")
    expectedDirty = 0; if (soak & 1) == 0 then expectedDirty = 1 end if
    assertEqual(soakStats.brushDirtyLightmaps, expectedDirty, "1000-frame dirty light replay")
    soak = soak + 1
  end while

  assertEqual(rbrushtestopengl.releaseClassicWorld(renderer, world), 9, "inline shared texture release")
  assertEqual(typeof(try(rbrushtestopengl.submitClassicWorld(renderer, world, frame))), "error", "released inline submission rejected")
  renderer.exports.Shutdown()
end function

testProductShapedInlineBrushSubmission()
print("renderer classic brush submission tests passed")
