//! Provides miniquake2 game world vector facilities for this project.

/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Small vector layer for BaseQ2 world state. */
package miniquake2.game.world.vector

import std.math as smath
import miniquake2.qcommon.types as qt

/// Require world vector.
/// @param value Value consumed or transformed by the operation.
/// @param operation operation value consumed by this operation.
function requireWorldVector(value, operation)
  if typeof(value) != "struct" then return error(9190, operation + ": Vec3-shaped value required") end if
  return value
end function

/// Performs the copy operation for the miniquake2 game world vector module.
/// @param value Value consumed or transformed by the operation.
function copy(value)
  vector = requireWorldVector(value, "world vector copy")
  x = vector.x; y = vector.y; z = vector.z
  return qt.Vec3(x, y, z)
end function

/// Adds add to the state managed by the miniquake2 game world vector module.
/// @param first first value consumed by this operation.
/// @param second second value consumed by this operation.
function add(first, second)
  firstVector = requireWorldVector(first, "world vector add first operand")
  secondVector = requireWorldVector(second, "world vector add second operand")
  firstX = firstVector.x; firstY = firstVector.y; firstZ = firstVector.z
  secondX = secondVector.x; secondY = secondVector.y; secondZ = secondVector.z
  return qt.Vec3(firstX + secondX, firstY + secondY, firstZ + secondZ)
end function

/// Performs the subtract operation for the miniquake2 game world vector module.
/// @param first first value consumed by this operation.
/// @param second second value consumed by this operation.
function subtract(first, second)
  firstVector = requireWorldVector(first, "world vector subtract first operand")
  secondVector = requireWorldVector(second, "world vector subtract second operand")
  firstX = firstVector.x; firstY = firstVector.y; firstZ = firstVector.z
  secondX = secondVector.x; secondY = secondVector.y; secondZ = secondVector.z
  return qt.Vec3(firstX - secondX, firstY - secondY, firstZ - secondZ)
end function

/// Performs the scale operation for the miniquake2 game world vector module.
/// @param value Value consumed or transformed by the operation.
/// @param amount amount value consumed by this operation.
function scale(value, amount)
  vector = requireWorldVector(value, "world vector scale")
  x = vector.x; y = vector.y; z = vector.z
  return qt.Vec3(x * amount, y * amount, z * amount)
end function

/// Performs the multiplyAdd operation for the miniquake2 game world vector module.
/// @param value Value consumed or transformed by the operation.
/// @param amount amount value consumed by this operation.
/// @param direction direction value consumed by this operation.
function multiplyAdd(value, amount, direction)
  vector = requireWorldVector(value, "world vector multiplyAdd value")
  directionVector = requireWorldVector(direction, "world vector multiplyAdd direction")
  x = vector.x; y = vector.y; z = vector.z
  directionX = directionVector.x; directionY = directionVector.y; directionZ = directionVector.z
  return qt.Vec3(x + amount * directionX, y + amount * directionY, z + amount * directionZ)
end function

/// Performs the dot operation for the miniquake2 game world vector module.
/// @param first first value consumed by this operation.
/// @param second second value consumed by this operation.
function dot(first, second)
  firstVector = requireWorldVector(first, "world vector dot first operand")
  secondVector = requireWorldVector(second, "world vector dot second operand")
  firstX = firstVector.x; firstY = firstVector.y; firstZ = firstVector.z
  secondX = secondVector.x; secondY = secondVector.y; secondZ = secondVector.z
  return firstX * secondX + firstY * secondY + firstZ * secondZ
end function

/// Performs the length operation for the miniquake2 game world vector module.
/// @param value Value consumed or transformed by the operation.
function length(value)
  vector = requireWorldVector(value, "world vector length")
  x = vector.x; y = vector.y; z = vector.z
  if y == 0.0 and z == 0.0 then return smath.abs(x) end if
  if x == 0.0 and z == 0.0 then return smath.abs(y) end if
  if x == 0.0 and y == 0.0 then return smath.abs(z) end if
  squaredLength = x * x + y * y + z * z
  return smath.sqrt(squaredLength)
end function

/// Performs the normalized operation for the miniquake2 game world vector module.
/// @param value Value consumed or transformed by the operation.
function normalized(value)
  vector = requireWorldVector(value, "world vector normalized")
  x = vector.x; y = vector.y; z = vector.z
  squaredLength = x * x + y * y + z * z
  if squaredLength == 0.0 then
    zero = qt.zeroVec3()
    return [zero, 0.0]
  end if
  magnitude = smath.sqrt(squaredLength)
  inverseMagnitude = 1.0 / magnitude
  unit = qt.Vec3(x * inverseMagnitude, y * inverseMagnitude, z * inverseMagnitude)
  return [unit, magnitude]
end function

/// Report whether equal.
/// @param first first value consumed by this operation.
/// @param second second value consumed by this operation.
function equal(first, second)
  firstVector = requireWorldVector(first, "world vector equal first operand")
  secondVector = requireWorldVector(second, "world vector equal second operand")
  firstX = firstVector.x; firstY = firstVector.y; firstZ = firstVector.z
  secondX = secondVector.x; secondY = secondVector.y; secondZ = secondVector.z
  return firstX == secondX and firstY == secondY and firstZ == secondZ
end function

/// Return the movedir value.
/// @param angles angles value consumed by this operation.
function movedir(angles)
  angleVector = requireWorldVector(angles, "world vector movedir angles")
  angleX = angleVector.x; angleY = angleVector.y; angleZ = angleVector.z
  if angleX == 0.0 and angleY == -1.0 and angleZ == 0.0 then return qt.Vec3(0.0, 0.0, 1.0) end if
  if angleX == 0.0 and angleY == -2.0 and angleZ == 0.0 then return qt.Vec3(0.0, 0.0, -1.0) end if
  pitch = smath.degToRad(angleX)
  yaw = smath.degToRad(angleY)
  pitchCosine = smath.cos(pitch)
  yawCosine = smath.cos(yaw)
  yawSine = smath.sin(yaw)
  pitchSine = smath.sin(pitch)
  return qt.Vec3(pitchCosine * yawCosine, pitchCosine * yawSine, -pitchSine)
end function

/// Convert an authored entity angle to a movement direction and clear the
/// render angles exactly as Quake II's G_SetMovedir does.  Brush movers must
/// not retain this angle: it describes translation, not model rotation.
/// @param entity entity value consumed by this operation.
function setMovedir(entity)
  direction = movedir(entity.angles)
  entity.angles = qt.zeroVec3()
  return direction
end function

/// Return the to angles.
/// @param direction direction value consumed by this operation.
function toAngles(direction)
  vector = requireWorldVector(direction, "world vector toAngles")
  x = vector.x; y = vector.y; z = vector.z
  yaw = 0.0
  pitch = 0.0
  if x == 0.0 and y == 0.0 then
    if z > 0.0 then pitch = 90.0 else pitch = 270.0 end if
  else
    yaw = smath.radToDeg(smath.atan2(y, x))
    if yaw < 0.0 then yaw = yaw + 360.0 end if
    forward = smath.sqrt(x * x + y * y)
    pitch = smath.radToDeg(smath.atan2(z, forward))
    if pitch < 0.0 then pitch = pitch + 360.0 end if
  end if
  return qt.Vec3(-pitch, yaw, 0.0)
end function
