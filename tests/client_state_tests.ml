/* Deterministic snapshot interpolation and refdef handoff tests. */
import miniquake2.protocol.types as pt
import miniquake2.renderer.types as rt
import miniquake2.renderer.validation as rval
import miniquake2.server.snapshot as ssnap
import miniquake2.client.state as cstate

function assertEqual(actual, expected, name)
  if actual != expected then return error(7980, name + ": expected " + expected + ", got " + actual) end if
end function

function resolveModel(index)
  return rt.ResourceHandle("model", index, "model" + index, 1)
end function

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
  second = ssnap.SnapshotFrame(11, 10, 0, bytes([]), secondPlayer, [makeEntity(8.0, 5)])
  assertEqual(cstate.acceptSnapshot(client, second), true, "second snapshot")
  assertEqual(cstate.acceptSnapshot(client, second), false, "duplicate snapshot ignored")
  frame = cstate.buildRefDef(client, 0.5, 640, 480, resolveModel)
  assertEqual(rval.validateRefDef(frame).valid, true, "generated refdef valid")
  assertEqual(frame.viewOrigin.x, 11.0, "view origin")
  assertEqual(frame.entities[0].origin.x, 4.0, "entity interpolation")
  assertEqual(frame.entities[0].oldFrame, 0, "old animation frame")
  assertEqual(len(frame.entities), 2, "multi-model entity expansion")

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
