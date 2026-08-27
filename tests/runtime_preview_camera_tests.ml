/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
import miniquake2.runtime.preview_camera as pcamera
import miniquake2.qcommon.types as qtypes

// Assert the near test condition.
function assertNear(actual, expected, tolerance, label)
  difference = actual - expected
  if difference < 0.0 then difference = -difference end if
  if difference > tolerance then return error(9980, label + ": expected " + expected + " got " + actual) end if
end function

// Run this source file's command-line entry point.
function main(args)
  camera = pcamera.create(qtypes.Vec3(10.0, 20.0, 30.0), qtypes.zeroVec3())
  command = qtypes.UserCmd(100, 0, [0, 0, 0], 200.0, 100.0, 50.0, 0, 0)
  pcamera.applyUserCmd(camera, command, [0.0, 0.0, 0.0], 100)
  assertNear(camera.origin.x, 30.0, 0.0001, "forward")
  assertNear(camera.origin.y, 10.0, 0.0001, "right")
  assertNear(camera.origin.z, 35.0, 0.0001, "up")

  camera = pcamera.create(qtypes.zeroVec3(), qtypes.zeroVec3())
  pcamera.applyUserCmd(camera, qtypes.UserCmd(100, 0, [0, 0, 0], 100.0, 0.0, 0.0, 0, 0), [0.0, 90.0, 0.0], 100)
  assertNear(camera.origin.x, 0.0, 0.001, "yaw x")
  assertNear(camera.origin.y, 10.0, 0.001, "yaw y")
  print "MiniQuake2 runtime preview camera tests passed: 2"
  return 0
end function
