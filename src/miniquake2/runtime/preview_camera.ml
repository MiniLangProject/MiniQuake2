/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Deterministic free-camera adapter used by the retail BSP renderer preview. */
package miniquake2.runtime.preview_camera

import miniquake2.qcommon.types as pctypes
import miniquake2.physics.vector as pcvector

struct PreviewCamera
  origin
  angles
end struct

function create(origin, angles)
  return PreviewCamera(
    pctypes.Vec3(origin.x, origin.y, origin.z),
    pctypes.Vec3(angles.x, angles.y, angles.z)
  )
end function

function applyUserCmd(camera, command, viewAngles, frameMsec)
  if frameMsec < 1 then frameMsec = 1 end if
  if frameMsec > 200 then frameMsec = 200 end if
  camera.angles = pctypes.Vec3(viewAngles[0], viewAngles[1], viewAngles[2])
  axes = pcvector.angleVectors(camera.angles)
  seconds = frameMsec / 1000.0
  camera.origin = pcvector.multiplyAdd(camera.origin, command.forwardMove * seconds, axes[0])
  camera.origin = pcvector.multiplyAdd(camera.origin, command.sideMove * seconds, axes[1])
  camera.origin.z = camera.origin.z + command.upMove * seconds
  return camera
end function
