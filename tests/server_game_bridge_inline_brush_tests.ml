/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Inline BSP setmodel bounds and dynamic brush trace regression. */
import miniquake2.server.game_bridge as inbridge
import miniquake2.game.null_game as ingameapi
import miniquake2.game.ai.constants as inaiconstants
import miniquake2.game.constants as ingameconstants
import miniquake2.game.types as ingametypes
import miniquake2.game.player.constants as inplayerconstants
import miniquake2.collision.model as incollision
import miniquake2.format.constants as informatconstants
import miniquake2.format.types as informattypes
import miniquake2.qcommon.constants as inqconstants
import miniquake2.qcommon.types as inqtypes
import miniquake2.runtime.application as inproductapplication
import miniquake2.runtime.play_session as inproductplay
import miniquake2.runtime.server_session as inserversession

// Assert the inline test condition.
function inlineAssert(value, message)
  if value != true then return error(9880, message) end if
  return true
end function

// Return the inline near value.
function inlineNear(actual, expected, tolerance, message)
  difference = actual - expected
  if difference < 0.0 then difference = -difference end if
  if difference > tolerance then return error(9881, message) end if
  return true
end function

// Return the inline fixture value.
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
    informattypes.BspLeaf(0, 0, 1, informattypes.Vec3(-32.0, -32.0, -32.0), informattypes.Vec3(32.0, 32.0, 32.0), 0, 0, 0, 0),
    informattypes.BspLeaf(informatconstants.CONTENTS_SOLID, -1, 1, informattypes.Vec3(-2.0, -2.0, -2.0), informattypes.Vec3(0.0, 2.0, 2.0), 0, 0, 0, 1),
  ]
  models = [
    informattypes.BspModel(informattypes.Vec3(-32.0, -32.0, -32.0), informattypes.Vec3(32.0, 32.0, 32.0), informattypes.Vec3(0.0, 0.0, 0.0), 0, 0, 0),
    informattypes.BspModel(informattypes.Vec3(-1.0, -1.0, -1.0), informattypes.Vec3(1.0, 1.0, 1.0), informattypes.Vec3(0.0, 0.0, 0.0), 1, 0, 0),
  ]
  map = informattypes.BspMap("inline-fixture", bytes(0), [], "", planes, [],
    informattypes.BspVisibility(0, [], [], bytes(0)), nodes, [texture], [], bytes(0), leafs, [], [0], [], [], models,
    brushes, sides, [informattypes.BspArea(0, 0), informattypes.BspArea(0, 0)], [])
  return incollision.create(map)
end function

// Return the inline visibility fixture value.
function inlineVisibilityFixture()
  plane = informattypes.BspPlane(informattypes.Vec3(1.0, 0.0, 0.0), 0.0, 0)
  node = informattypes.BspNode(0, -1, -2,
    informattypes.Vec3(-32.0, -32.0, -32.0),
    informattypes.Vec3(32.0, 32.0, 32.0), 0, 0)
  front = informattypes.BspLeaf(0, 0, 1,
    informattypes.Vec3(0.0, -32.0, -32.0),
    informattypes.Vec3(32.0, 32.0, 32.0), 0, 0, 0, 0)
  back = informattypes.BspLeaf(0, 1, 2,
    informattypes.Vec3(-32.0, -32.0, -32.0),
    informattypes.Vec3(0.0, 32.0, 32.0), 0, 0, 0, 0)
  map = informattypes.BspMap("inline-visibility", bytes(0), [], "", [plane], [],
    informattypes.BspVisibility(2, [0, 1], [0, 1], bytes([1, 2])),
    [node], [], [], bytes(0), [front, back], [], [], [], [], [], [], [],
    [informattypes.BspArea(0, 0), informattypes.BspArea(0, 0),
      informattypes.BspArea(0, 0)], [])
  return incollision.create(map)
end function

// Return the inline repeated brush text value.
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

// Return the inline repeated brush lifetime value.
function inlineRepeatedBrushLifetime(runtime, imports, game)
  entityText = inlineRepeatedBrushText()
  firstMapEdict = 2 + inplayerconstants.BODY_QUEUE_SIZE
  iteration = 0
  while iteration < 96
    // Match the per-level bridge tables discarded by resetBridgeLevel while
    // retaining one Game export and one callback/import graph.
    runtime.configStrings = array(inqconstants.MAX_CONFIGSTRINGS, "")
    runtime.modelNames = array(inqconstants.MAX_MODELS, "")
    runtime.soundNames = array(inqconstants.MAX_SOUNDS, "")
    runtime.imageNames = array(inqconstants.MAX_IMAGES, "")
    game.spawnEntities("inline-repeat-" + iteration, entityText, "")
    inlineAssert(game.numEdicts == firstMapEdict + 32,
      "repeated brush edict count changed")
    index = firstMapEdict
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
firstMapEdict = 2 + inplayerconstants.BODY_QUEUE_SIZE
brush = game.edicts[firstMapEdict]

inlineAssert(brush.headNode == 1, "setmodel adopts inline hull headnode")
inlineAssert(brush.mins.x == -1.0 and brush.maxs.x == 1.0, "setmodel adopts inline hull bounds")
inlineAssert(brush.size.x == 2.0 and brush.areaNumber == 1 and
  game.numEdicts == firstMapEdict + 1,
  "Game API binds stock body queue plus brush edict and BSP area")
hit = imports.trace(inqtypes.Vec3(14.0, 0.0, 0.0), inqtypes.zeroVec3(), inqtypes.zeroVec3(),
  inqtypes.Vec3(6.0, 0.0, 0.0), void, inqconstants.MASK_SOLID)
inlineAssert(hit.entity is not void and
  hit.entity.state.number == firstMapEdict,
  "trace hits dynamic inline brush edict")
inlineNear(hit.endPosition.x, 11.03125, 0.0001, "translated inline brush hit position")
inlineAssert(hit.surface.name == "inline/brush", "inline brush surface propagated")
inlineAssert((imports.pointContents(inqtypes.Vec3(9.5, 0.0, 0.0)) & informatconstants.CONTENTS_SOLID) != 0, "dynamic inline brush contributes point contents")
inlineAssert(runtime.inlineBrushCount == 1 and runtime.inlineBrushModelNumbers[0] == 1,
  "linked inline brush publishes its cached model number")
inlineAssert(brush.numClusters == 1 and brush.clusterNumbers[0] == 0,
  "linked inline brush caches its complete-bounds PVS cluster")
inlineAssert(brush.state.solid == 31,
  "linked inline brush publishes Protocol-34 BSP solidity")
inlineManagedRuntime = ingameapi.baseRuntime()
inlineManagedDoor = void
for each inlineManagedEntity in inlineManagedRuntime.world.entities
  if inlineManagedEntity.className == "func_door" then
    inlineManagedDoor = inlineManagedEntity
  end if
end for
inlineAssert(inlineManagedDoor is not void and
  inlineManagedDoor.absoluteMins.x == 8.0 and
  inlineManagedDoor.absoluteMaxs.x == 12.0,
  "managed door did not retain linked absolute BSP bounds")
game.runFrame()
inlineDoorTrigger = void
for each inlineManagedEntity in inlineManagedRuntime.world.entities
  if inlineManagedEntity.className == "door_trigger" then
    inlineDoorTrigger = inlineManagedEntity
  end if
end for
inlineAssert(inlineDoorTrigger is not void and
  inlineDoorTrigger.mins.x == -52.0 and inlineDoorTrigger.maxs.x == 72.0 and
  runtime.triggerCount == 1,
  "door touch field was not built around the linked brush bounds")

// The origin lies in hidden cluster 1/area 2, while the complete brush
// bounds straddle into visible cluster 0/area 1. Point-origin culling used to
// remove this entity from every client snapshot even though the door surface
// was in view.
mainCollision = runtime.collision
runtime.collision = inlineVisibilityFixture()
visibilityBrush = ingametypes.zeroEdict(77)
visibilityBrush.inUse = true
visibilityBrush.solid = ingameconstants.SOLID_BSP
visibilityBrush.state.modelIndex = brush.state.modelIndex
visibilityBrush.state.origin = inqtypes.Vec3(-0.5, 0.0, 0.0)
visibilityBrush.mins = inqtypes.Vec3(-1.0, -1.0, -1.0)
visibilityBrush.maxs = inqtypes.Vec3(1.0, 1.0, 1.0)
imports.linkEntity(visibilityBrush)
visibilityOriginLeaf = incollision.pointLeafNumber(runtime.collision,
  visibilityBrush.state.origin, 0)
inlineAssert(runtime.collision.map.leafs[visibilityOriginLeaf].cluster == 1,
  "straddling-door regression origin unexpectedly lies in the viewer cluster")
inlineAssert(visibilityBrush.areaNumber == 1 and visibilityBrush.areaNumber2 == 2 and
  visibilityBrush.numClusters == 2 and visibilityBrush.clusterNumbers[0] == 0 and
  visibilityBrush.clusterNumbers[1] == 1,
  "straddling door publishes both areas and its visible cluster")
visibilityViewer = ingametypes.zeroEdict(1)
visibilityViewer.inUse = true
visibilityViewer.state.origin = inqtypes.Vec3(10.0, 0.0, 0.0)
visibilityViewer.client = ingametypes.zeroGameClient()
visibilityViewer.client.playerState.viewOffset = inqtypes.Vec3(1.0, 2.0, 22.0)
visibilityViewOrigin = inserversession.clientViewOrigin(visibilityViewer)
inlineAssert(visibilityViewOrigin.x == 11.0 and visibilityViewOrigin.y == 2.0 and
  visibilityViewOrigin.z == 22.0,
  "snapshot visibility did not use the rendered eye origin")
visibilitySession = inserversession.ServerSession(void, void, void, void, void,
  runtime.collision, "inline-fixture", "", 0, 0, 0, 0, void, "", false, false)
inlineAssert(inserversession.entityVisibleFromLeaf(visibilitySession,
  visibilityViewer, 0, visibilityBrush),
  "snapshot PVS rejected door whose bounds touch the viewer cluster")
visibilityOwnedProjectile = ingametypes.zeroEdict(78)
visibilityOwnedProjectile.inUse = true
visibilityOwnedProjectile.owner = visibilityViewer
visibilityOwnedProjectile.numClusters = 0
inlineAssert(inserversession.entityVisibleFromLeaf(visibilitySession,
  visibilityViewer, 0, visibilityOwnedProjectile),
  "snapshot PVS rejected the viewer's own projectile")
visibilityProtocolState = inserversession.protocolEntity(visibilityBrush.state)
inlineAssert(visibilityProtocolState.modelIndex == visibilityBrush.state.modelIndex and
  visibilityProtocolState.solid == 31 and visibilityProtocolState.origin[0] == -0.5,
  "visible door transform/model/solidity did not reach Protocol 34")
visibilityBrush.numClusters = -1
inlineAssert(inserversession.entityVisibleFromLeaf(visibilitySession,
  visibilityViewer, 0, visibilityBrush),
  "large moving-brush PVS overflow fallback rejected visible bounds")
imports.unlinkEntity(visibilityBrush)
runtime.collision = mainCollision

// A spatially remote trace must never enter this hull. Deliberately poison the
// headnode to turn the performance broad phase into a behavioral regression:
// an all-brush scan would fail, while SV_AreaEdicts-style filtering stays clear.
savedHeadNode = brush.headNode
brush.headNode = 999999
remoteTrace = imports.trace(inqtypes.Vec3(-100.0, 0.0, 0.0),
  inqtypes.zeroVec3(), inqtypes.zeroVec3(),
  inqtypes.Vec3(-90.0, 0.0, 0.0), void, inqconstants.MASK_SOLID)
inlineAssert(remoteTrace.fraction == 1.0 and remoteTrace.entity is void,
  "remote trace was not rejected by inline-brush broadphase")
brush.headNode = savedHeadNode

brush.mins = inqtypes.Vec3(-4.0, -1.0, -1.0)
brush.maxs = inqtypes.Vec3(4.0, 1.0, 1.0)
brush.state.angles = inqtypes.Vec3(0.0, 90.0, 0.0)
imports.linkEntity(brush)
rotatedHits = imports.boxEdicts(inqtypes.Vec3(9.5, 3.0, -0.5), inqtypes.Vec3(10.5, 4.0, 0.5), 1)
inlineAssert(len(rotatedHits) == 1 and rotatedHits[0].state.number == brush.state.number, "rotated brush broadphase uses transformed bounds")

// Product-level g_ai.c visibility and M_CheckAttack traces must use the same
// live inline-brush collision boundary as ordinary server traces.
aiFixture = "{\"classname\" \"worldspawn\"}" +
  "{\"classname\" \"info_player_start\" \"origin\" \"-64 0 0\" \"angle\" \"0\"}" +
  "{\"classname\" \"func_door\" \"model\" \"*1\" \"origin\" \"0 0 24\" \"angle\" \"0\"}" +
  "{\"classname\" \"monster_soldier\" \"origin\" \"64 0 0\" \"angle\" \"180\"}"
game.spawnEntities("inline-ai-fixture", aiFixture, "")
aiClient = game.edicts[1]
inlineAssert(game.clientConnect(aiClient, "\\name\\InlineRanger\\skin\\male/grunt"),
  "inline AI client connect")
inlineAssert(game.clientBegin(aiClient), "inline AI client begin")
aiDoor = game.edicts[firstMapEdict + 1]
aiDoor.mins = inqtypes.Vec3(-1.0, -32.0, -64.0)
aiDoor.maxs = inqtypes.Vec3(1.0, 32.0, 64.0)
imports.linkEntity(aiDoor)
aiRuntime = ingameapi.baseRuntime()
aiMonster = aiRuntime.monsters[0]
aiPlayer = aiRuntime.aiPlayers[0]
aiSightStart = inqtypes.Vec3(aiMonster.edict.state.origin.x,
  aiMonster.edict.state.origin.y, aiMonster.edict.state.origin.z + aiMonster.viewHeight)
aiSightEnd = inqtypes.Vec3(aiPlayer.edict.state.origin.x,
  aiPlayer.edict.state.origin.y, aiPlayer.edict.state.origin.z + aiPlayer.viewHeight)
aiDoor.state.origin = inqtypes.Vec3(0.0, 0.0, (aiSightStart.z + aiSightEnd.z) * 0.5)
imports.linkEntity(aiDoor)
aiKnownDoorTrace = imports.trace(inqtypes.Vec3(64.0, 0.0, aiDoor.state.origin.z),
  inqtypes.zeroVec3(), inqtypes.zeroVec3(),
  inqtypes.Vec3(-64.0, 0.0, aiDoor.state.origin.z), void, inqconstants.MASK_OPAQUE)
inlineAssert(aiKnownDoorTrace.entity is not void and
  aiKnownDoorTrace.entity.state.number == aiDoor.state.number,
  "known-height trace missed the closed inline door")
aiDoorTrace = imports.trace(aiSightStart, inqtypes.zeroVec3(), inqtypes.zeroVec3(),
  aiSightEnd, aiMonster.edict, inqconstants.MASK_OPAQUE)
inlineAssert(aiDoorTrace.entity is not void and aiDoorTrace.entity.state.number == aiDoor.state.number,
  "raw eye trace missed the closed inline door start-z=" + aiSightStart.z +
    " end-z=" + aiSightEnd.z + " door-z=" + aiDoor.state.origin.z)
inlineAssert(aiRuntime.aiContext.visible(aiMonster, aiPlayer) == false,
  "monster visibility crossed a closed inline door")
inlineAssert(aiRuntime.aiContext.clearShot(aiMonster, aiPlayer) == false,
  "monster clear-shot trace crossed a closed inline door")
aiMonster.flags = aiMonster.flags | inaiconstants.FL_FLY
aiMonster.enemy = void
aiMonster.goalEntity = aiPlayer
aiMonster.movementInitialized = true
aiClosedMoveX = aiMonster.edict.state.origin.x
inlineAssert(aiRuntime.aiContext.walkMove(aiMonster, 180.0, 80.0) == false,
  "monster hull crossed a closed inline door")
inlineNear(aiMonster.edict.state.origin.x, aiClosedMoveX, 0.0001,
  "blocked monster movement changed origin")
aiDoor.state.origin = inqtypes.Vec3(200.0, 0.0, aiDoor.state.origin.z)
imports.linkEntity(aiDoor)
inlineAssert(aiRuntime.aiContext.visible(aiMonster, aiPlayer),
  "monster visibility stayed blocked after door moved away")
inlineAssert(aiRuntime.aiContext.clearShot(aiMonster, aiPlayer),
  "monster clear-shot trace did not hit the live player target")
inlineAssert(aiRuntime.aiContext.walkMove(aiMonster, 180.0, 80.0),
  "monster remained blocked after inline door moved away")
inlineAssert(aiMonster.edict.state.origin.x < aiClosedMoveX,
  "unblocked monster hull did not advance")
game.clientDisconnect(aiClient)

// Every stock moving-brush family reaches the same SetModel -> LinkEdict PVS
// path. Keep a product Game-API regression for doors, plats, buttons and both
// rotating variants rather than proving only one classname.
moverFixture = "{\"classname\" \"worldspawn\"}" +
  "{\"classname\" \"func_door\" \"model\" \"*1\" \"origin\" \"10 0 0\"}" +
  "{\"classname\" \"func_plat\" \"model\" \"*1\" \"origin\" \"10 0 0\"}" +
  "{\"classname\" \"func_button\" \"model\" \"*1\" \"origin\" \"10 0 0\"}" +
  "{\"classname\" \"func_door_rotating\" \"model\" \"*1\" \"origin\" \"10 0 0\"}" +
  "{\"classname\" \"func_rotating\" \"model\" \"*1\" \"origin\" \"10 0 0\"}" +
  "{\"classname\" \"func_train\" \"model\" \"*1\" \"origin\" \"10 0 0\"}"
game.spawnEntities("inline-mover-families", moverFixture, "")
inlineAssert(game.numEdicts == firstMapEdict + 6,
  "moving-brush family edict count")
moverIndex = firstMapEdict
while moverIndex < game.numEdicts
  mover = game.edicts[moverIndex]
  inlineAssert(mover.state.modelIndex > 0 and mover.numClusters == 1 and
    mover.clusterNumbers[0] == 0,
    "moving-brush family lost model/PVS linkage at edict " + moverIndex)
  moverIndex = moverIndex + 1
end while

// SV_Push links the brush immediately after moving it. Without that relink the
// authoritative origin advances while absmin/absmax remain at the old floor,
// so the next server Pmove trace can pass straight through a retail elevator.
inlineMoverRuntime = ingameapi.baseRuntime()
inlineTrain = void
for each inlineMoverEntity in inlineMoverRuntime.world.entities
  if inlineMoverEntity.className == "func_train" then inlineTrain = inlineMoverEntity end if
end for
inlineAssert(inlineTrain is not void, "moving train managed entity")
inlineTrain.velocity = inqtypes.Vec3(0.0, 0.0, 100.0)
inlineTrainEdict = game.edicts[inlineTrain.number]
inlineOldTrainMaxZ = inlineTrainEdict.absoluteMaxs.z
game.runFrame()
inlineAssert(inlineTrainEdict.state.origin.z == 10.0 and
  inlineTrainEdict.absoluteMins.z > inlineOldTrainMaxZ,
  "successful elevator push did not relink final broadphase bounds")
inlineElevatorTrace = imports.trace(inqtypes.Vec3(14.0, 0.0, 14.0),
  inqtypes.zeroVec3(), inqtypes.zeroVec3(),
  inqtypes.Vec3(6.0, 0.0, 6.0), void, inqconstants.MASK_PLAYERSOLID)
inlineAssert(inlineElevatorTrace.entity is not void and
  inlineElevatorTrace.entity.state.number == inlineTrainEdict.state.number,
  "server Pmove trace crossed the moved elevator fraction=" +
    inlineElevatorTrace.fraction + " startSolid=" + inlineElevatorTrace.startSolid +
    " origin=" + inlineTrainEdict.state.origin.z +
    " abs=" + inlineTrainEdict.absoluteMins.z + ":" + inlineTrainEdict.absoluteMaxs.z)

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
