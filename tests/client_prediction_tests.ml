/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Exact CL_PredictMovement command replay over shared Pmove. */
import miniquake2.client.prediction as cprediction
import miniquake2.protocol.types as pt
import miniquake2.qcommon.constants as qc
import miniquake2.qcommon.types as qt

// Assert the prediction equal test condition.
function predictionAssertEqual(actual, expected, name)
  if actual != expected then
    return error(7660, name + ": expected " + expected + ", got " + actual)
  end if
  return true
end function

// Assert the prediction near test condition.
function predictionAssertNear(actual, expected, tolerance, name)
  delta = actual - expected
  if delta < 0.0 then delta = -delta end if
  if delta > tolerance then return error(7661, name + ": outside tolerance") end if
  return true
end function

// Report whether prediction empty trace.
function predictionEmptyTrace(start, mins, maxs, finish)
  return qt.Trace(false, false, 1.0,
    qt.Vec3(finish.x, finish.y, finish.z),
    qt.Plane(qt.zeroVec3(), 0.0, 0, 0),
    qt.CollisionSurface("prediction/empty", 0, 0), 0, void)
end function

// Report whether prediction empty contents.
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

fallbackCommand = qt.UserCmd(16, 0, [0, 8192, 0], 0, 0, 0, 0, 0)
fallbackAngles = cprediction.commandViewAngles(player, fallbackCommand)
predictionAssertNear(fallbackAngles.y, 135.0, 0.0001,
  "no-prediction branch retains live command view angle")
player.pmove.deltaAngles[1] = 10000
fallbackCommand.angles[1] = 30000
fallbackAngles = cprediction.commandViewAngles(player, fallbackCommand)
predictionAssertNear(fallbackAngles.y, -140.2734375, 0.0001,
  "no-prediction command angle preserves signed-short wrap")
player.pmove.deltaAngles[1] = 16384

command = qt.UserCmd(100, 0, [0, 0, 0], 200, 0, 0, 0, 0)
result = cprediction.predict(player, [command], predictionEmptyTrace,
  predictionEmptyContents, 0.0)
predictionAssertEqual(result.commandsReplayed, 1, "replayed command count")
predictionAssertEqual(result.previousOrigin[1], 0,
  "stair detector retains origin before final replayed command")
predictionAssertEqual(result.state.origin[1], 159,
  "spectator command predicted in fixed-point space")
predictionAssertNear(result.viewAngles.y, 90.0, 0.0001,
  "delta angle applied by prediction")
predictionAssertEqual(player.pmove.origin[1], 0,
  "authoritative player state remains immutable")

// The product path owns one workspace for its whole play session. Replaying
// through it must preserve the allocating API's exact fixed-point result and
// must be safe to repeat after its previous output has been consumed.
workspace = cprediction.createWorkspace(predictionEmptyTrace,
  predictionEmptyContents)
commandScratch = array(65, void)
commandScratch[0] = command
workspaceResult = cprediction.predictInto(workspace, player,
  commandScratch, 1, 0.0)
predictionAssertEqual(workspaceResult.state.origin[1], result.state.origin[1],
  "workspace replay matches allocating replay")
predictionAssertNear(workspaceResult.viewAngles.y, result.viewAngles.y, 0.0001,
  "workspace view angles match allocating replay")
workspaceResult = cprediction.predictInto(workspace, player,
  commandScratch, 1, 0.0)
predictionAssertEqual(workspaceResult.state.origin[1], 159,
  "workspace replay resets from authoritative state")
predictionAssertEqual(workspaceResult.commandsReplayed, 1,
  "workspace reports bounded replay count")

print("MiniQuake2 client prediction tests passed: 1")
