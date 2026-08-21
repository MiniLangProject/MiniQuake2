/* Quake II PMove private working state. */
package miniquake2.physics.types

import miniquake2.qcommon.types as qt

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
end struct

function createLocal()
  return PmoveLocal(
    qt.zeroVec3(), qt.zeroVec3(),
    qt.zeroVec3(), qt.zeroVec3(), qt.zeroVec3(),
    0.0, void,
    qt.Plane(qt.zeroVec3(), 0.0, 0, 0),
    0, [0, 0, 0], false
  )
end function

