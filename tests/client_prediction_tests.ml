/* Exact CL_PredictMovement command replay over shared Pmove. */
import miniquake2.client.prediction as cprediction
import miniquake2.protocol.types as pt
import miniquake2.qcommon.constants as qc
import miniquake2.qcommon.types as qt

function predictionAssertEqual(actual, expected, name)
  if actual != expected then
    return error(7660, name + ": expected " + expected + ", got " + actual)
  end if
  return true
end function

function predictionAssertNear(actual, expected, tolerance, name)
  delta = actual - expected
  if delta < 0.0 then delta = -delta end if
  if delta > tolerance then return error(7661, name + ": outside tolerance") end if
  return true
end function

function predictionEmptyTrace(start, mins, maxs, finish)
  return qt.Trace(false, false, 1.0,
    qt.Vec3(finish.x, finish.y, finish.z),
    qt.Plane(qt.zeroVec3(), 0.0, 0, 0),
    qt.CollisionSurface("prediction/empty", 0, 0), 0, void)
end function

function predictionEmptyContents(point)
  return 0
end function

player = pt.zeroPlayerState()
player.pmove.moveType = qc.PM_SPECTATOR
player.pmove.deltaAngles = [0, 16384, 0]
player.viewAngles = [0.0, 90.0, 0.0]
localAngles = cprediction.localInputAngles(player)
predictionAssertNear(localAngles[1], 0.0, 0.0001,
  "spawn delta removed from command angles")

command = qt.UserCmd(100, 0, [0, 0, 0], 200, 0, 0, 0, 0)
result = cprediction.predict(player, [command], predictionEmptyTrace,
  predictionEmptyContents, 0.0)
predictionAssertEqual(result.commandsReplayed, 1, "replayed command count")
predictionAssertEqual(result.state.origin[1], 159,
  "spectator command predicted in fixed-point space")
predictionAssertNear(result.viewAngles.y, 90.0, 0.0001,
  "delta angle applied by prediction")
predictionAssertEqual(player.pmove.origin[1], 0,
  "authoritative player state remains immutable")

print("MiniQuake2 client prediction tests passed: 1")
