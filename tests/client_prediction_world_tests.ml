/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Remote CL_ClipMoveToEntities parity for encoded boxes and inline BSPs. */
import miniquake2.qcommon.constants as pwtqc
import miniquake2.qcommon.types as pwtqt
import miniquake2.format.types as pwtt
import miniquake2.format.constants as pwtfc
import miniquake2.collision.model as pwtcollision
import miniquake2.protocol.types as pwtpt
import miniquake2.client.runtime.types as pwtcrt
import miniquake2.client.prediction_world as pwtworld

// Assert the prediction world test condition.
function predictionWorldAssert(value, name)
  if not value then return error(7670, name) end if
  return true
end function

// Return the prediction world near value.
function predictionWorldNear(actual, expected, tolerance, name)
  difference = actual - expected
  if difference < 0.0 then difference = -difference end if
  if difference > tolerance then return error(7671, name + ": outside tolerance") end if
  return true
end function

// Return the prediction world fixture value.
function predictionWorldFixture()
  planes = [
    pwtt.BspPlane(pwtt.Vec3(1.0, 0.0, 0.0), 0.0, 0),
    pwtt.BspPlane(pwtt.Vec3(1.0, 0.0, 0.0), 1.0, 0),
    pwtt.BspPlane(pwtt.Vec3(-1.0, 0.0, 0.0), 1.0, 3),
    pwtt.BspPlane(pwtt.Vec3(0.0, 1.0, 0.0), 1.0, 1),
    pwtt.BspPlane(pwtt.Vec3(0.0, -1.0, 0.0), 1.0, 4),
    pwtt.BspPlane(pwtt.Vec3(0.0, 0.0, 1.0), 1.0, 2),
    pwtt.BspPlane(pwtt.Vec3(0.0, 0.0, -1.0), 1.0, 5)]
  nodes = [pwtt.BspNode(0, -1, -2, pwtt.Vec3(-16.0, -16.0, -16.0),
    pwtt.Vec3(16.0, 16.0, 16.0), 0, 0)]
  texture = pwtt.BspTexInfo([], [], 0, 0, "prediction/mover", -1)
  sides = [pwtt.BspBrushSide(1, 0), pwtt.BspBrushSide(2, 0),
    pwtt.BspBrushSide(3, 0), pwtt.BspBrushSide(4, 0),
    pwtt.BspBrushSide(5, 0), pwtt.BspBrushSide(6, 0)]
  leafs = [
    pwtt.BspLeaf(0, 0, 0, pwtt.Vec3(0.0, -16.0, -16.0),
      pwtt.Vec3(16.0, 16.0, 16.0), 0, 0, 0, 0),
    pwtt.BspLeaf(pwtfc.CONTENTS_SOLID, -1, 0,
      pwtt.Vec3(-16.0, -16.0, -16.0), pwtt.Vec3(0.0, 16.0, 16.0),
      0, 0, 0, 1)]
  model = pwtt.BspModel(pwtt.Vec3(-1.0, -1.0, -1.0),
    pwtt.Vec3(1.0, 1.0, 1.0), pwtt.Vec3(0.0, 0.0, 0.0), 0, 0, 0)
  map = pwtt.BspMap("prediction", bytes(), [], "", planes, [],
    pwtt.BspVisibility(0, [], [], bytes()), nodes, [texture], [], bytes(),
    leafs, [], [0], [], [], [model, model],
    [pwtt.BspBrush(0, 6, pwtfc.CONTENTS_SOLID)], sides,
    [pwtt.BspArea(0, 0)], [])
  return pwtcollision.create(map)
end function

player = pwtpt.zeroPlayerState()
snapshot = pwtcrt.Snapshot(1, -1, 0, bytes(), player, [])
box = pwtpt.zeroEntityState()
box.number = 7
box.origin = [50.0, 0.0, 0.0]
box.solid = 2 | (3 << 5) | (8 << 10)
snapshot.entities = [box]
world = pwtworld.PredictionWorld(void, [], snapshot, 1)
zero = pwtqt.zeroVec3()
boxTrace = pwtworld.trace(world, zero, zero, zero,
  pwtqt.Vec3(100.0, 0.0, 0.0))
predictionWorldNear(boxTrace.fraction, 0.3396875, 0.00001,
  "encoded bbox sweep fraction")
predictionWorldAssert(boxTrace.entity.number == 7 and
  boxTrace.contents == pwtqc.CONTENTS_MONSTER,
  "encoded bbox trace entity and contents")

world.localEntityNumber = 7
skipped = pwtworld.trace(world, zero, zero, zero,
  pwtqt.Vec3(100.0, 0.0, 0.0))
predictionWorldAssert(skipped.fraction == 1.0,
  "local packet entity excluded")
world.localEntityNumber = 1
snapshot.entities = [box]
insideBox = pwtworld.trace(world, pwtqt.Vec3(50.0, 0.0, 0.0), zero,
  zero, pwtqt.Vec3(51.0, 0.0, 0.0))
predictionWorldAssert(insideBox.startSolid and insideBox.allSolid,
  "encoded bbox start/all solid semantics")

collision = predictionWorldFixture()
configStrings = array(pwtqc.MAX_CONFIGSTRINGS, "")
configStrings[pwtqc.CS_MODELS + 2] = "*1"
mover = pwtpt.zeroEntityState()
mover.number = 8; mover.modelIndex = 2; mover.solid = 31
mover.origin = [10.0, 0.0, 0.0]
mover.angles = [0.0, 0.0, 0.0]
snapshot.entities = [mover]
world = pwtworld.PredictionWorld(collision, configStrings, snapshot, 1)
worldTrace = pwtworld.trace(world, pwtqt.Vec3(2.0, 0.0, 0.0), zero,
  zero, pwtqt.Vec3(-2.0, 0.0, 0.0))
predictionWorldAssert(worldTrace.fraction < 1.0 and worldTrace.entity is not void,
  "world collision keeps original non-null ground sentinel")
moverTrace = pwtworld.trace(world, pwtqt.Vec3(14.0, 0.0, 0.0), zero,
  zero, pwtqt.Vec3(6.0, 0.0, 0.0))
predictionWorldNear(moverTrace.fraction, 0.37109375, 0.00001,
  "inline BSP mover trace fraction")
predictionWorldAssert(moverTrace.entity.number == 8,
  "inline BSP mover identity")
predictionWorldAssert((pwtworld.pointContents(world,
  pwtqt.Vec3(9.5, 0.0, 0.0)) & pwtqc.CONTENTS_SOLID) != 0,
  "inline BSP mover point contents")
mover.angles = [0.0, 90.0, 0.0]
rotatedTrace = pwtworld.trace(world, pwtqt.Vec3(10.0, 4.0, 0.0), zero,
  zero, pwtqt.Vec3(10.0, -4.0, 0.0))
predictionWorldNear(rotatedTrace.fraction, 0.37109375, 0.00001,
  "rotated inline BSP mover trace fraction")
predictionWorldAssert(rotatedTrace.entity.number == 8 and
  (pwtworld.pointContents(world, pwtqt.Vec3(10.0, -0.5, 0.0)) &
  pwtqc.CONTENTS_SOLID) != 0, "rotated mover trace and contents identity")

// The remote product path must retain its world/Pmove/result graph while
// remaining bit-identical to the original allocating prediction wrapper.
reusePlayer = pwtpt.zeroPlayerState()
reusePlayer.pmove.moveType = pwtqc.PM_SPECTATOR
reuseSnapshot = pwtcrt.Snapshot(2, 1, 0, bytes(), reusePlayer, [])
reuseCommand = pwtqt.UserCmd(100, 0, [0, 0, 0], 200, 0, 0, 0, 0)
legacyResult = pwtworld.predict(reusePlayer, [reuseCommand], void,
  configStrings, reuseSnapshot, 1, 0.0)
reuseWorld = pwtworld.createWorld()
reuseWorkspace = pwtworld.createPredictionWorkspace()
reuseCommands = array(65, void)
reuseCommands[0] = reuseCommand
reuseResult = pwtworld.predictInto(reuseWorld, reuseWorkspace, reusePlayer,
  reuseCommands, 1, void, configStrings, reuseSnapshot, 1, 0.0)
predictionWorldAssert(reuseResult.state.origin[0] == legacyResult.state.origin[0] and
  reuseResult.state.origin[1] == legacyResult.state.origin[1] and
  reuseResult.state.origin[2] == legacyResult.state.origin[2],
  "reused remote prediction matches allocating wrapper")
reuseWorldIdentity = nativeRawValue(reuseWorld)
reusePmoveIdentity = nativeRawValue(reuseWorkspace.pmove)
reuseResultIdentity = nativeRawValue(reuseResult)
reuseResult = pwtworld.predictInto(reuseWorld, reuseWorkspace, reusePlayer,
  reuseCommands, 1, void, configStrings, reuseSnapshot, 1, 0.0)
predictionWorldAssert(nativeRawValue(reuseWorld) == reuseWorldIdentity and
  nativeRawValue(reuseWorkspace.pmove) == reusePmoveIdentity and
  nativeRawValue(reuseResult) == reuseResultIdentity and
  reuseResult.state.origin[1] == legacyResult.state.origin[1],
  "remote prediction retains world, Pmove and result identity")

print("client_prediction_world_tests: PASS")
