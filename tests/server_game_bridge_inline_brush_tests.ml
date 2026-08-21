/* Inline BSP setmodel bounds and dynamic brush trace regression. */
import miniquake2.server.game_bridge as inbridge
import miniquake2.game.null_game as ingameapi
import miniquake2.game.types as ingametypes
import miniquake2.collision.model as incollision
import miniquake2.format.constants as informatconstants
import miniquake2.format.types as informattypes
import miniquake2.qcommon.constants as inqconstants
import miniquake2.qcommon.types as inqtypes
import miniquake2.runtime.application as inproductapplication
import miniquake2.runtime.play_session as inproductplay

function inlineAssert(value, message)
  if value != true then return error(9880, message) end if
  return true
end function

function inlineNear(actual, expected, tolerance, message)
  difference = actual - expected
  if difference < 0.0 then difference = -difference end if
  if difference > tolerance then return error(9881, message) end if
  return true
end function

function inlineFixture()
  planes = [
    informattypes.BspPlane(informattypes.Vec3(1.0, 0.0, 0.0), 0.0, 0),
    informattypes.BspPlane(informattypes.Vec3(1.0, 0.0, 0.0), 1.0, 0),
    informattypes.BspPlane(informattypes.Vec3(-1.0, 0.0, 0.0), 1.0, 3),
    informattypes.BspPlane(informattypes.Vec3(0.0, 1.0, 0.0), 1.0, 1),
    informattypes.BspPlane(informattypes.Vec3(0.0, -1.0, 0.0), 1.0, 4),
    informattypes.BspPlane(informattypes.Vec3(0.0, 0.0, 1.0), 1.0, 2),
    informattypes.BspPlane(informattypes.Vec3(0.0, 0.0, -1.0), 1.0, 5),
  ]
  nodes = [
    informattypes.BspNode(0, -1, -1, informattypes.Vec3(-32.0, -32.0, -32.0), informattypes.Vec3(32.0, 32.0, 32.0), 0, 0),
    informattypes.BspNode(0, -1, -2, informattypes.Vec3(-2.0, -2.0, -2.0), informattypes.Vec3(2.0, 2.0, 2.0), 0, 0),
  ]
  texture = informattypes.BspTexInfo([], [], 0, 0, "inline/brush", -1)
  sides = [
    informattypes.BspBrushSide(1, 0), informattypes.BspBrushSide(2, 0),
    informattypes.BspBrushSide(3, 0), informattypes.BspBrushSide(4, 0),
    informattypes.BspBrushSide(5, 0), informattypes.BspBrushSide(6, 0),
  ]
  brushes = [informattypes.BspBrush(0, 6, informatconstants.CONTENTS_SOLID)]
  leafs = [
    informattypes.BspLeaf(0, 0, 0, informattypes.Vec3(-32.0, -32.0, -32.0), informattypes.Vec3(32.0, 32.0, 32.0), 0, 0, 0, 0),
    informattypes.BspLeaf(informatconstants.CONTENTS_SOLID, -1, 0, informattypes.Vec3(-2.0, -2.0, -2.0), informattypes.Vec3(0.0, 2.0, 2.0), 0, 0, 0, 1),
  ]
  models = [
    informattypes.BspModel(informattypes.Vec3(-32.0, -32.0, -32.0), informattypes.Vec3(32.0, 32.0, 32.0), informattypes.Vec3(0.0, 0.0, 0.0), 0, 0, 0),
    informattypes.BspModel(informattypes.Vec3(-1.0, -1.0, -1.0), informattypes.Vec3(1.0, 1.0, 1.0), informattypes.Vec3(0.0, 0.0, 0.0), 1, 0, 0),
  ]
  map = informattypes.BspMap("inline-fixture", bytes(0), [], "", planes, [],
    informattypes.BspVisibility(0, [], [], bytes(0)), nodes, [texture], [], bytes(0), leafs, [], [0], [], [], models,
    brushes, sides, [informattypes.BspArea(0, 0)], [])
  return incollision.create(map)
end function

function inlineRepeatedBrushText()
  text = "{ \"classname\" \"worldspawn\" }\n"
  index = 0
  while index < 32
    text = text + "{ \"classname\" \"func_door\" \"model\" \"*1\" " +
      "\"origin\" \"10 0 0\" \"angle\" \"" + (index * 11) + "\" }\n"
    index = index + 1
  end while
  return text
end function

function inlineRepeatedBrushLifetime(runtime, imports, game)
  entityText = inlineRepeatedBrushText()
  iteration = 0
  while iteration < 96
    // Match the per-level bridge tables discarded by resetBridgeLevel while
    // retaining one Game export and one callback/import graph.
    runtime.configStrings = array(inqconstants.MAX_CONFIGSTRINGS, "")
    runtime.modelNames = array(inqconstants.MAX_MODELS, "")
    runtime.soundNames = array(inqconstants.MAX_SOUNDS, "")
    runtime.imageNames = array(inqconstants.MAX_IMAGES, "")
    game.spawnEntities("inline-repeat-" + iteration, entityText, "")
    inlineAssert(game.numEdicts == 34, "repeated brush edict count changed")
    index = 2
    while index < game.numEdicts
      brush = game.edicts[index]
      inlineAssert(typeof(brush) == "struct" and typeof(brush.state) == "struct",
        "repeated brush lost Edict/state shape")
      inlineAssert(typeof(brush.state.origin) == "struct" and typeof(brush.state.angles) == "struct" and
        typeof(brush.state.oldOrigin) == "struct" and typeof(brush.mins) == "struct" and typeof(brush.maxs) == "struct",
        "repeated brush lost persistent vector child")
      inlineRepeatedAnglesHolder = inqtypes.Vec3(0.0, (iteration * 17 + index * 7) % 360, 0.0)
      brush.state.angles = inlineRepeatedAnglesHolder
      ingametypes.stabilizeEdict(brush)
      imports.linkEntity(brush)
      inlineAssert(typeof(brush.absoluteMins) == "struct" and typeof(brush.absoluteMaxs) == "struct",
        "repeated brush lost transformed bounds")
      index = index + 1
    end while
    hits = imports.boxEdicts(inqtypes.Vec3(5.0, -5.0, -5.0),
      inqtypes.Vec3(15.0, 5.0, 5.0), 1)
    inlineAssert(len(hits) > 0, "repeated brush broadphase lost every brush")
    iteration = iteration + 1
  end while
  return true
end function

runtime = inbridge.createRuntime(1)
inlineProductGraphFunctions = [typeof(inproductapplication.campaignMapNames), typeof(inproductplay.createRetail)]
inlineAssert(inlineProductGraphFunctions == ["function", "function"], "product graph imports missing")
runtime.collision = inlineFixture()
imports = inbridge.makeImports(runtime)
game = ingameapi.GetGameApi(imports)
runtime.game = game
ingameapi.configureMaxClients(1)
game.init()
game.spawnEntities("inline-fixture", "{\"classname\" \"worldspawn\"}{\"classname\" \"func_door\" \"model\" \"*1\" \"origin\" \"10 0 0\" \"angle\" \"0\"}", "")
brush = game.edicts[2]

inlineAssert(brush.headNode == 1, "setmodel adopts inline hull headnode")
inlineAssert(brush.mins.x == -1.0 and brush.maxs.x == 1.0, "setmodel adopts inline hull bounds")
inlineAssert(brush.size.x == 2.0 and game.numEdicts == 3, "Game API binds compact brush edict")
hit = imports.trace(inqtypes.Vec3(14.0, 0.0, 0.0), inqtypes.zeroVec3(), inqtypes.zeroVec3(),
  inqtypes.Vec3(6.0, 0.0, 0.0), void, inqconstants.MASK_SOLID)
inlineAssert(hit.entity is not void and hit.entity.state.number == 2, "trace hits dynamic inline brush edict")
inlineNear(hit.endPosition.x, 11.03125, 0.0001, "translated inline brush hit position")
inlineAssert(hit.surface.name == "inline/brush", "inline brush surface propagated")
inlineAssert((imports.pointContents(inqtypes.Vec3(9.5, 0.0, 0.0)) & informatconstants.CONTENTS_SOLID) != 0, "dynamic inline brush contributes point contents")

brush.mins = inqtypes.Vec3(-4.0, -1.0, -1.0)
brush.maxs = inqtypes.Vec3(4.0, 1.0, 1.0)
brush.state.angles = inqtypes.Vec3(0.0, 90.0, 0.0)
imports.linkEntity(brush)
rotatedHits = imports.boxEdicts(inqtypes.Vec3(9.5, 3.0, -0.5), inqtypes.Vec3(10.5, 4.0, 0.5), 1)
inlineAssert(len(rotatedHits) == 1 and rotatedHits[0].state.number == brush.state.number, "rotated brush broadphase uses transformed bounds")
inlineRepeatedBrushLifetime(runtime, imports, game)
malformedBrush = ingametypes.zeroEdict(99)
malformedBrush.inUse = true
malformedBrush.state = void
malformedResult = try(imports.linkEntity(malformedBrush))
inlineAssert(malformedResult is error, "malformed Edict state was not rejected")
inlineAssert(malformedResult.message == "transformed bounds require an Edict state",
  "malformed Edict state did not use the bounded bridge diagnostic")
game.shutdown()

print "server_game_bridge_inline_brush_tests: PASS"
