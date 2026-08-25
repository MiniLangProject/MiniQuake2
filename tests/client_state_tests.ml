/* Deterministic snapshot interpolation and refdef handoff tests. */
import miniquake2.protocol.types as pt
import miniquake2.renderer.types as rt
import miniquake2.renderer.constants as rc
import miniquake2.renderer.validation as rval
import miniquake2.server.snapshot as ssnap
import miniquake2.client.state as cstate
import miniquake2.client.effects.constants as ceconstants
import miniquake2.client.assets.types as catypes
import miniquake2.qcommon.constants as qc

function assertEqual(actual, expected, name)
  if actual != expected then return error(7980, name + ": expected " + expected + ", got " + actual) end if
end function

function assertNear(actual, expected, tolerance, name)
  delta = actual - expected
  if delta < 0.0 then delta = -delta end if
  if delta > tolerance then return error(7981, name + ": expected " + expected + ", got " + actual) end if
end function

function resolveModel(index)
  return rt.ResourceHandle("model", index, "model" + index, 1)
end function

function resolveNamedModel(name)
  return rt.ResourceHandle("model", len(bytes(name)), name, 1)
end function

function resolveNamedSkin(name)
  return rt.ResourceHandle("skin", len(bytes(name)), name, 1)
end function

function resolveNothing(value)
  return void
end function

function resolveNoEntitySound(entityNumber, soundIndex, soundName)
  return void
end function

function resolvePlayerModel(index)
  return rt.ResourceHandle("model", 1000 + index, "players/custom/tris.md2", 1)
end function

function resolvePlayerSkin(index)
  return rt.ResourceHandle("skin", 2000 + index, "players/male/grunt.pcx", 1)
end function

function resolvePlayerWeapon(index, weaponIndex)
  return rt.ResourceHandle("model", 3000 + weaponIndex,
    "players/custom/weapon" + weaponIndex + ".md2", 1)
end function

testRandomValue = 0
function testRandom()
  global testRandomValue
  value = testRandomValue
  testRandomValue = testRandomValue + 1
  return value
end function

testResolvers = catypes.ResolverBindings(resolveModel, resolveNamedModel,
  resolveNamedSkin, resolveNothing, resolveNothing, resolveNoEntitySound,
  resolvePlayerModel,
  resolvePlayerSkin, resolvePlayerWeapon)

function makeEntity(x, secondModel)
  entity = pt.zeroEntityState()
  entity.number = 1
  entity.modelIndex = 4
  entity.modelIndex2 = secondModel
  entity.origin[0] = x
  entity.frame = x / 8
  return entity
end function

function testSnapshotsAndRefDef()
  global testRandomValue
  client = cstate.create()
  cstate.setConnectionState(client, "connected")
  firstPlayer = pt.zeroPlayerState()
  firstPlayer.fov = 90.0
  firstPlayer.pmove.origin = [80, 40, 16]
  first = ssnap.SnapshotFrame(10, -1, 0, bytes([]), firstPlayer, [makeEntity(0.0, 0)])
  assertEqual(cstate.acceptSnapshot(client, first), true, "first snapshot")
  assertEqual(client.state, "active", "first snapshot activates client")

  secondPlayer = pt.copyPlayerState(firstPlayer)
  secondPlayer.viewOffset = [1.0, 2.0, 3.0]
  secondPlayer.viewAngles = [10.0, 20.0, 30.0]
  secondPlayer.kickAngles = [2.0, 4.0, 6.0]
  firstPlayer.gunIndex = 7
  firstPlayer.gunFrame = 2
  firstPlayer.gunOffset = [0.0, 0.0, 0.0]
  firstPlayer.gunAngles = [0.0, 358.0, -2.0]
  secondPlayer.gunIndex = 7
  secondPlayer.gunFrame = 4
  secondPlayer.gunOffset = [2.0, 4.0, 6.0]
  secondPlayer.gunAngles = [4.0, 2.0, 2.0]
  second = ssnap.SnapshotFrame(11, 10, 0, bytes([]), secondPlayer, [makeEntity(8.0, 5)])
  assertEqual(cstate.acceptSnapshot(client, second), true, "second snapshot")
  assertEqual(cstate.acceptSnapshot(client, second), false, "duplicate snapshot ignored")
  frame = cstate.buildRefDef(client, 0.5, 640, 480, testResolvers, 0, testRandom)
  assertEqual(rval.validateRefDef(frame).valid, true, "generated refdef valid")
  assertEqual(frame.viewOrigin.x, 10.5625,
    "view origin interpolation plus BSP plane nudge")
  assertEqual(frame.viewAngles.x, 6.0, "view and kick angle interpolation")
  assertNear(frame.fovY, 73.739795, 0.0001, "aspect-correct vertical fov")
  assertNear(frame.time, 1.05, 0.000001,
    "render time advances within the server snapshot interval")
  assertEqual(frame.entities[0].origin.x, 4.0, "entity interpolation")
  assertEqual(frame.entities[0].oldFrame, 1,
    "linked-model change resets stale animation frame")
  assertEqual(len(frame.entities), 3, "multi-model entity and view weapon expansion")
  assertEqual(frame.entities[2].model.id, 7, "view weapon model")
  assertEqual(frame.entities[2].frame, 4, "view weapon frame")
  assertEqual(frame.entities[2].oldFrame, 2, "view weapon old frame")
  assertEqual(frame.entities[2].origin.x, 11.5, "view weapon offset interpolation")
  assertEqual(frame.entities[2].angles.x, 8.0,
    "view weapon pitch plus interpolated gun recoil")
  assertEqual(frame.entities[2].angles.y, 372.0,
    "view weapon wrapped yaw recoil interpolation")
  assertEqual(frame.entities[2].flags & rc.RF_WEAPONMODEL, rc.RF_WEAPONMODEL,
    "view weapon render flags")

  bfgClient = cstate.create()
  bfgEntity = makeEntity(0.0, 0)
  bfgEntity.effects = ceconstants.EF_BFG
  cstate.acceptSnapshot(bfgClient, ssnap.SnapshotFrame(1, -1, 0, bytes([]),
    firstPlayer, [bfgEntity]))
  bfgFrame = cstate.buildRefDef(bfgClient, 1.0, 640, 480, testResolvers, 0,
    testRandom)
  assertEqual(bfgFrame.entities[0].flags & rc.RF_TRANSLUCENT, rc.RF_TRANSLUCENT,
    "BFG entity translucency")
  assertNear(bfgFrame.entities[0].alpha, 0.30, 0.0001, "BFG entity source alpha")

  effectPlayer = pt.zeroPlayerState()
  effectPlayer.fov = 90.0
  shellClient = cstate.create()
  shellEntity = makeEntity(0.0, 0)
  shellEntity.effects = ceconstants.EF_QUAD
  cstate.acceptSnapshot(shellClient, ssnap.SnapshotFrame(1, -1, 0, bytes([]),
    effectPlayer, [shellEntity]))
  shellFrame = cstate.buildRefDef(shellClient, 1.0, 640, 480, testResolvers, 0,
    testRandom)
  assertEqual(len(shellFrame.entities), 2, "quad duplicates main model for color shell")
  assertEqual(shellFrame.entities[0].flags, 0, "color shell keeps base model unmodified")
  assertEqual(shellFrame.entities[1].flags & rc.RF_SHELL_BLUE, rc.RF_SHELL_BLUE,
    "quad derives blue shell flag")
  assertNear(shellFrame.entities[1].alpha, 0.30, 0.0001, "color shell alpha")

  linkedClient = cstate.create()
  linkedEntity = makeEntity(0.0, 0x80 | 5)
  linkedEntity.effects = ceconstants.EF_BFG
  cstate.acceptSnapshot(linkedClient, ssnap.SnapshotFrame(1, -1, 0, bytes([]),
    effectPlayer, [linkedEntity]))
  linkedFrame = cstate.buildRefDef(linkedClient, 1.0, 640, 480, testResolvers, 0,
    testRandom)
  assertEqual(linkedFrame.entities[1].model.id, 5, "linked translucent model index mask")
  assertEqual(linkedFrame.entities[1].flags, rc.RF_TRANSLUCENT,
    "linked model owns only its translucent flag")
  assertNear(linkedFrame.entities[1].alpha, 0.32, 0.0001,
    "linked translucent model stock alpha")

  powerClient = cstate.create()
  powerEntity = makeEntity(0.0, 0)
  powerEntity.effects = ceconstants.EF_POWERSCREEN
  cstate.acceptSnapshot(powerClient, ssnap.SnapshotFrame(1, -1, 0, bytes([]),
    effectPlayer, [powerEntity]))
  powerFrame = cstate.buildRefDef(powerClient, 1.0, 640, 480, testResolvers, 0,
    testRandom)
  assertEqual(len(powerFrame.entities), 2, "powerscreen adds linked armor model")
  assertEqual(powerFrame.entities[1].model.name,
    "models/items/armor/effect/tris.md2", "powerscreen stock model")
  assertEqual(powerFrame.entities[1].flags,
    rc.RF_TRANSLUCENT | rc.RF_SHELL_GREEN, "powerscreen render flags")
  assertNear(powerFrame.entities[1].alpha, 0.30, 0.0001, "powerscreen alpha")

  customClient = cstate.create()
  customEntity = makeEntity(0.0, 255)
  customEntity.modelIndex = 255
  customEntity.skinNum = (2 << 8) | 3
  cstate.acceptSnapshot(customClient, ssnap.SnapshotFrame(1, -1, 0, bytes([]),
    effectPlayer, [customEntity]))
  customFrame = cstate.buildRefDef(customClient, 1.0, 640, 480, testResolvers,
    0, testRandom)
  assertEqual(customFrame.entities[0].model.id, 1003,
    "custom player model selected from client index")
  assertEqual(customFrame.entities[0].skin.id, 2003,
    "custom player skin selected from client index")
  assertEqual(customFrame.entities[1].model.id, 3002,
    "custom visible weapon selected from upper skin byte")

  disguiseClient = cstate.create()
  disguiseEntity = makeEntity(0.0, 0)
  disguiseEntity.modelIndex = 255
  disguiseEntity.skinNum = 3
  disguiseEntity.renderFx = rc.RF_USE_DISGUISE
  disguiseEntity.effects = ceconstants.EF_QUAD
  cstate.acceptSnapshot(disguiseClient, ssnap.SnapshotFrame(1, -1, 0, bytes([]),
    effectPlayer, [disguiseEntity]))
  disguiseFrame = cstate.buildRefDef(disguiseClient, 1.0, 640, 480,
    testResolvers, 0, testRandom)
  assertEqual(disguiseFrame.entities[0].model.name, "players/male/tris.md2",
    "disguised player model")
  assertEqual(disguiseFrame.entities[0].skin.name, "players/male/disguise.pcx",
    "disguised player skin")
  assertEqual(disguiseFrame.entities[1].skin.name, "players/male/disguise.pcx",
    "disguised player color shell skin")

  localClient = cstate.create()
  localEntityState = makeEntity(0.0, 0)
  cstate.acceptSnapshot(localClient, ssnap.SnapshotFrame(1, -1, 0, bytes([]),
    effectPlayer, [localEntityState]))
  localRenderFrame = cstate.buildRefDef(localClient, 1.0, 640, 480,
    testResolvers, 1, testRandom)
  assertEqual(len(localRenderFrame.entities), 0,
    "local player third-person entity omitted outside mirrors")

  beamClient = cstate.create()
  beamEntity = makeEntity(0.0, 0)
  beamEntity.renderFx = rc.RF_BEAM
  beamEntity.skinNum = 0x44332211
  cstate.acceptSnapshot(beamClient, ssnap.SnapshotFrame(1, -1, 0, bytes([]),
    effectPlayer, [beamEntity]))
  testRandomValue = 2
  beamFrame = cstate.buildRefDef(beamClient, 1.0, 640, 480, testResolvers, 0,
    testRandom)
  assertEqual(beamFrame.entities[0].model, void, "beam uses procedural model")
  assertEqual(beamFrame.entities[0].skinNum, 0x33, "beam selects packed skin byte")
  assertNear(beamFrame.entities[0].alpha, 0.30, 0.0001, "beam stock alpha")

  areaClient = cstate.create()
  cstate.acceptSnapshot(areaClient, ssnap.SnapshotFrame(1, -1, 0,
    bytes([0x05, 0xa0]), effectPlayer, [makeEntity(0.0, 0)]))
  areaFrame = cstate.buildRefDef(areaClient, 1.0, 640, 480, testResolvers,
    0, testRandom)
  assertEqual(len(areaFrame.areaBits), 2, "snapshot area bits reach renderer")
  assertEqual(areaFrame.areaBits[0], 0x05, "renderer area byte zero")
  assertEqual(areaFrame.areaBits[1], 0xa0, "renderer area byte one")

  lightClient = cstate.create()
  cstate.setLightStyle(lightClient, 3, "az")
  cstate.acceptSnapshot(lightClient, ssnap.SnapshotFrame(1, -1, 0,
    bytes([]), effectPlayer, [makeEntity(0.0, 0)]))
  brightLightFrame = cstate.buildRefDef(lightClient, 1.0, 640, 480,
    testResolvers, 0, testRandom)
  assertNear(brightLightFrame.lightStyles[3].rgb[0], 25.0 / 12.0,
    0.000001, "animated light style z intensity")
  assertNear(brightLightFrame.lightStyles[3].white, 75.0 / 12.0,
    0.000001, "light style cache key is the stock RGB sum")
  assertEqual(rval.validateRefDef(brightLightFrame).valid, true,
    "stock z light style passes renderer contract")
  cstate.acceptSnapshot(lightClient, ssnap.SnapshotFrame(2, 1, 0,
    bytes([]), effectPlayer, [makeEntity(0.0, 0)]))
  darkLightFrame = cstate.buildRefDef(lightClient, 1.0, 640, 480,
    testResolvers, 0, testRandom)
  assertNear(darkLightFrame.lightStyles[3].rgb[0], 0.0, 0.000001,
    "animated light style advances at 10 Hz")

  // CL_DeltaEntity invalidates the render predecessor on teleports, large
  // coordinate jumps and model replacements.  EV_OTHER_TELEPORT starts at
  // the destination immediately instead of sweeping across the map.
  teleportClient = cstate.create()
  teleportOld = makeEntity(0.0, 0)
  teleportNew = makeEntity(1024.0, 0)
  teleportNew.oldOrigin = [0.0, 0.0, 0.0]
  teleportNew.event = ceconstants.EV_OTHER_TELEPORT
  teleportNew.angles = [5.0, 90.0, 15.0]
  cstate.acceptSnapshot(teleportClient, ssnap.SnapshotFrame(1, -1, 0,
    bytes([]), effectPlayer, [teleportOld]))
  cstate.acceptSnapshot(teleportClient, ssnap.SnapshotFrame(2, 1, 0,
    bytes([]), effectPlayer, [teleportNew]))
  teleportFrame = cstate.buildRefDef(teleportClient, 0.25, 640, 480,
    testResolvers, 0, testRandom)
  assertEqual(teleportFrame.entities[0].origin.x, 1024.0,
    "other teleport snaps render origin to destination")
  assertEqual(teleportFrame.entities[0].angles.y, 90.0,
    "teleport does not interpolate stale angles")
  assertEqual(teleportFrame.entities[0].oldFrame, teleportNew.frame,
    "teleport does not interpolate stale animation frame")

  replacementClient = cstate.create()
  replacementOld = makeEntity(16.0, 0)
  replacementOld.angles = [0.0, 0.0, 0.0]
  replacementNew = makeEntity(80.0, 0)
  replacementNew.modelIndex = 9
  replacementNew.oldOrigin = [40.0, 0.0, 0.0]
  replacementNew.angles = [0.0, 120.0, 0.0]
  cstate.acceptSnapshot(replacementClient, ssnap.SnapshotFrame(1, -1, 0,
    bytes([]), effectPlayer, [replacementOld]))
  cstate.acceptSnapshot(replacementClient, ssnap.SnapshotFrame(2, 1, 0,
    bytes([]), effectPlayer, [replacementNew]))
  replacementFrame = cstate.buildRefDef(replacementClient, 0.5, 640, 480,
    testResolvers, 0, testRandom)
  assertEqual(replacementFrame.entities[0].origin.x, 60.0,
    "model replacement interpolates from protocol old origin")
  assertEqual(replacementFrame.entities[0].angles.y, 120.0,
    "model replacement owns current angles")

  denseStates = array(rc.MAX_ENTITIES + 16)
  denseIndex = 0
  while denseIndex < len(denseStates)
    denseEntity = makeEntity(denseIndex * 1.0, 5)
    denseEntity.number = denseIndex + 2
    denseEntity.frame = denseIndex
    denseEntity.effects = ceconstants.EF_COLOR_SHELL | ceconstants.EF_POWERSCREEN
    denseStates[denseIndex] = denseEntity
    denseIndex = denseIndex + 1
  end while
  denseClient = cstate.create()
  cstate.acceptSnapshot(denseClient, ssnap.SnapshotFrame(1, -1, 0, bytes([]),
    effectPlayer, denseStates))
  denseFrame = cstate.buildRefDef(denseClient, 1.0, 640, 480, testResolvers,
    0, testRandom)
  assertEqual(len(denseFrame.entities), rc.MAX_ENTITIES,
    "dense snapshot is capped at stock renderer entity limit")
  denseValidation = rval.validateRefDef(denseFrame)
  assertEqual(denseValidation.valid, true,
    "capped dense snapshot remains a valid refdef (" + denseValidation.code + ")")

  cstate.acceptPrediction(client, [160, 80, 32], [40.0, 50.0, 60.0])
  predictedFrame = cstate.buildPredictedRefDef(client, 0.5, 640, 480,
    testResolvers, 0, testRandom)
  assertEqual(predictedFrame.viewOrigin.x, 20.5625,
    "predicted view origin plus BSP plane nudge")
  assertEqual(predictedFrame.viewOrigin.y, 11.0625,
    "predicted view offset plus BSP plane nudge")
  assertEqual(predictedFrame.viewAngles.x, 41.0, "predicted view plus kick")
  assertEqual(predictedFrame.entities[2].angles.x, 43.0,
    "predicted view weapon angle")

  cstate.setPredictionRealTime(client, 1000)
  assertEqual(cstate.notePredictionStep(client, [160, 80, -40],
    [160, 80, 32], qc.PMF_ON_GROUND, 20), true,
    "8-to-20-unit grounded riser starts stair smoothing")
  assertNear(client.predictedStep, 9.0, 0.000001,
    "fixed-point stair height converted to world units")
  assertNear(client.predictedStepTime, 990.0, 0.000001,
    "stair start time receives original half-frame adjustment")
  cstate.setPredictionRealTime(client, 1005)
  assertEqual(cstate.notePredictionStep(client, [160, 80, -40],
    [160, 80, 32], qc.PMF_ON_GROUND, 20), false,
    "replayed preview endpoint does not restart stair smoothing")
  assertNear(client.predictedStepTime, 990.0, 0.000001,
    "duplicate preview preserves original stair start time")
  cstate.setPredictionRealTime(client, 990)
  stairStartFrame = cstate.buildPredictedRefDef(client, 0.5, 640, 480,
    testResolvers, 0, testRandom)
  assertNear(stairStartFrame.viewOrigin.z, -3.4375, 0.000001,
    "stair camera begins at pre-step height")
  cstate.setPredictionRealTime(client, 1040)
  stairHalfFrame = cstate.buildPredictedRefDef(client, 0.5, 640, 480,
    testResolvers, 0, testRandom)
  assertNear(stairHalfFrame.viewOrigin.z, 1.0625, 0.000001,
    "stair camera eases halfway after 50 ms")
  cstate.setPredictionRealTime(client, 1090)
  stairCompleteFrame = cstate.buildPredictedRefDef(client, 0.5, 640, 480,
    testResolvers, 0, testRandom)
  assertNear(stairCompleteFrame.viewOrigin.z, 5.5625, 0.000001,
    "stair camera reaches predicted height after 100 ms")

  // Dead cameras and demos remain locked to authoritative interpolation.
  secondPlayer.pmove.moveType = qc.PM_DEAD
  deadFrame = cstate.buildPredictedRefDef(client, 0.5, 640, 480,
    testResolvers, 0, testRandom)
  assertEqual(deadFrame.viewOrigin.x, 10.5625,
    "dead camera server origin plus BSP plane nudge")
  assertEqual(deadFrame.viewAngles.x, 6.0, "dead camera server angles")
  secondPlayer.pmove.moveType = qc.PM_NORMAL

  firstPlayer.viewAngles = [0.0, 359.0, 0.0]
  secondPlayer.viewAngles = [0.0, 1.0, 0.0]
  firstPlayer.kickAngles = [0.0, 0.0, 0.0]
  secondPlayer.kickAngles = [0.0, 0.0, 0.0]
  wrappedClient = cstate.create()
  cstate.acceptSnapshot(wrappedClient, ssnap.SnapshotFrame(1, -1, 0, bytes([]),
    firstPlayer, [makeEntity(0.0, 0)]))
  cstate.acceptSnapshot(wrappedClient, ssnap.SnapshotFrame(2, 1, 0, bytes([]),
    secondPlayer, [makeEntity(0.0, 0)]))
  wrappedFrame = cstate.buildRefDef(wrappedClient, 0.5, 640, 480, testResolvers,
    0, testRandom)
  assertEqual(wrappedFrame.viewAngles.y, 360.0, "wrapped view angle interpolation")

  number = 12
  while number <= 30
    next = ssnap.SnapshotFrame(number, number - 1, 0, bytes([]), secondPlayer, [makeEntity(number * 1.0, 0)])
    assertEqual(cstate.acceptSnapshot(client, next), true, "snapshot ring advance")
    number = number + 1
  end while
  assertEqual(len(client.snapshots), 16, "fixed snapshot ring size")
  assertEqual(client.snapshots[30 & 15].number, 30, "snapshot ring replacement")
  assertEqual(client.previous.number, 29, "snapshot interpolation predecessor")

  predictionError = cstate.updatePredictionError(client, [72, 40, 16])
  assertEqual(predictionError.x, 1.0, "prediction reconciliation")
end function

testSnapshotsAndRefDef()
print("MiniQuake2 client state tests passed: 1")
