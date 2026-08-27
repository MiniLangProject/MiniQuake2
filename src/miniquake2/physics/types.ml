/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Quake II PMove private working state. */
package miniquake2.physics.types

import miniquake2.qcommon.types as qt
import miniquake2.physics.constants as phc

// Store pmove local data.
struct PmoveLocal
  origin
  velocity
  forward
  right
  up
  frameTime
  groundSurface
  groundPlane
  groundContents
  previousOrigin
  ladder
  clipPlanes
end struct

// Create local.
function createLocal()
  planes = array(phc.MAX_CLIP_PLANES, void)
  planeIndex = 0
  while planeIndex < len(planes)
    planes[planeIndex] = qt.zeroVec3()
    planeIndex = planeIndex + 1
  end while
  return PmoveLocal(
    qt.zeroVec3(), qt.zeroVec3(),
    qt.zeroVec3(), qt.zeroVec3(), qt.zeroVec3(),
    0.0, void,
    qt.Plane(qt.zeroVec3(), 0.0, 0, 0),
    0, [0, 0, 0], false, planes
  )
end function
