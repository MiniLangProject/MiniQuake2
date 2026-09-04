//! Provides miniquake2 physics types facilities for this project.

/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Quake II PMove private working state. */
package miniquake2.physics.types

import miniquake2.qcommon.types as qt
import miniquake2.physics.constants as phc

/// Store pmove local data.
struct PmoveLocal
  /// Stores the origin value associated with pmove local.
  origin
  /// Stores the velocity value associated with pmove local.
  velocity
  /// Stores the forward value associated with pmove local.
  forward
  /// Stores the right value associated with pmove local.
  right
  /// Stores the up value associated with pmove local.
  up
  /// Stores the frame time value associated with pmove local.
  frameTime
  /// Stores the ground surface value associated with pmove local.
  groundSurface
  /// Stores the ground plane value associated with pmove local.
  groundPlane
  /// Stores the ground contents value associated with pmove local.
  groundContents
  /// Stores the previous origin value associated with pmove local.
  previousOrigin
  /// Stores the ladder value associated with pmove local.
  ladder
  /// Stores the clip planes value associated with pmove local.
  clipPlanes
end struct

/// Create local.
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
