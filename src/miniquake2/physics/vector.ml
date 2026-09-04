//! Provides miniquake2 physics vector facilities for this project.

/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Deterministic, allocation-explicit vector helpers for PMove. */
package miniquake2.physics.vector

import std.math as smath
import miniquake2.qcommon.types as qt

/// Validate dynamic Vec3-shaped values without materializing a temporary
/// three-element array. Pmove calls dot/length/multiplyAdd hundreds of times
/// per prediction frame, so the former component array dominated its GC rate.
/// @param value Value consumed or transformed by the operation.
/// @param operation operation value consumed by this operation.
function inline validatePhysicsVector(value, operation)
  if typeof(value) != "struct" then
    return error(2840, operation + ": Vec3-shaped value required")
  end if
  x = try(value.x)
  y = try(value.y)
  z = try(value.z)
  xType = typeof(x); yType = typeof(y); zType = typeof(z)
  if (xType != "int" and xType != "float") or
      (yType != "int" and yType != "float") or
      (zType != "int" and zType != "float") then
    return error(2840, operation + ": numeric Vec3 components required")
  end if
  return true
end function

/// Return the physics vector components value.
/// @param value Value consumed or transformed by the operation.
/// @param operation operation value consumed by this operation.
function physicsVectorComponents(value, operation)
  valid = try(validatePhysicsVector(value, operation))
  if valid is error then return valid end if
  return [value.x, value.y, value.z]
end function

/// Performs the copy operation for the miniquake2 physics vector module.
/// @param value Value consumed or transformed by the operation.
function copy(value)
  valid = try(validatePhysicsVector(value, "physics vector copy"))
  if valid is error then return valid end if
  result = qt.Vec3(value.x, value.y, value.z)
  return result
end function

/// Adds add to the state managed by the miniquake2 physics vector module.
/// @param first first value consumed by this operation.
/// @param second second value consumed by this operation.
function add(first, second)
  valid = try(validatePhysicsVector(first, "physics vector add first operand"))
  if valid is error then return valid end if
  valid = try(validatePhysicsVector(second, "physics vector add second operand"))
  if valid is error then return valid end if
  result = qt.Vec3(first.x + second.x, first.y + second.y, first.z + second.z)
  return result
end function

/// Performs the subtract operation for the miniquake2 physics vector module.
/// @param first first value consumed by this operation.
/// @param second second value consumed by this operation.
function subtract(first, second)
  valid = try(validatePhysicsVector(first, "physics vector subtract first operand"))
  if valid is error then return valid end if
  valid = try(validatePhysicsVector(second, "physics vector subtract second operand"))
  if valid is error then return valid end if
  result = qt.Vec3(first.x - second.x, first.y - second.y, first.z - second.z)
  return result
end function

/// Performs the scale operation for the miniquake2 physics vector module.
/// @param value Value consumed or transformed by the operation.
/// @param amount amount value consumed by this operation.
function scale(value, amount)
  valid = try(validatePhysicsVector(value, "physics vector scale"))
  if valid is error then return valid end if
  result = qt.Vec3(value.x * amount, value.y * amount, value.z * amount)
  return result
end function

/// Performs the multiplyAdd operation for the miniquake2 physics vector module.
/// @param value Value consumed or transformed by the operation.
/// @param amount amount value consumed by this operation.
/// @param direction direction value consumed by this operation.
function multiplyAdd(value, amount, direction)
  valid = try(validatePhysicsVector(value, "physics vector multiplyAdd value"))
  if valid is error then return valid end if
  valid = try(validatePhysicsVector(direction,
    "physics vector multiplyAdd direction"))
  if valid is error then return valid end if
  result = qt.Vec3(
    value.x + amount * direction.x,
    value.y + amount * direction.y,
    value.z + amount * direction.z
  )
  return result
end function

/// Performs the dot operation for the miniquake2 physics vector module.
/// @param first first value consumed by this operation.
/// @param second second value consumed by this operation.
function dot(first, second)
  valid = try(validatePhysicsVector(first, "physics vector dot first operand"))
  if valid is error then return valid end if
  valid = try(validatePhysicsVector(second, "physics vector dot second operand"))
  if valid is error then return valid end if
  return first.x * second.x + first.y * second.y + first.z * second.z
end function

/// Performs the cross operation for the miniquake2 physics vector module.
/// @param first first value consumed by this operation.
/// @param second second value consumed by this operation.
function cross(first, second)
  valid = try(validatePhysicsVector(first, "physics vector cross first operand"))
  if valid is error then return valid end if
  valid = try(validatePhysicsVector(second, "physics vector cross second operand"))
  if valid is error then return valid end if
  result = qt.Vec3(
    first.y * second.z - first.z * second.y,
    first.z * second.x - first.x * second.z,
    first.x * second.y - first.y * second.x
  )
  return result
end function

/// Performs the length operation for the miniquake2 physics vector module.
/// @param value Value consumed or transformed by the operation.
function length(value)
  valid = try(validatePhysicsVector(value, "physics vector length"))
  if valid is error then return valid end if
  x = value.x; y = value.y; z = value.z
  // Keep the axis-aligned cases exact. They dominate player input and avoid
  // turning a mathematically integral network velocity into the next lower
  // truncation bucket through a sub-ulp Newton approximation.
  if y == 0.0 and z == 0.0 then return smath.abs(x) end if
  if x == 0.0 and z == 0.0 then return smath.abs(y) end if
  if x == 0.0 and y == 0.0 then return smath.abs(z) end if
  magnitude = smath.sqrt(x * x + y * y + z * z)
  nearest = smath.round(magnitude)
  if smath.abs(magnitude - nearest) < 0.0000000001 then return nearest * 1.0 end if
  return magnitude
end function

/// Return [normalized vector, original length], matching VectorNormalize's
/// useful result without relying on reference parameters.
/// @param value Value consumed or transformed by the operation.
function normalized(value)
  valid = try(validatePhysicsVector(value, "physics vector normalized"))
  if valid is error then return valid end if
  x = value.x; y = value.y; z = value.z
  magnitude = 0.0
  if y == 0.0 and z == 0.0 then
    magnitude = smath.abs(x)
  else if x == 0.0 and z == 0.0 then
    magnitude = smath.abs(y)
  else if x == 0.0 and y == 0.0 then
    magnitude = smath.abs(z)
  else
    magnitude = smath.sqrt(x * x + y * y + z * z)
    nearest = smath.round(magnitude)
    if smath.abs(magnitude - nearest) < 0.0000000001 then magnitude = nearest * 1.0 end if
  end if
  result = array(2)
  if magnitude == 0.0 then
    normalizedValue = qt.Vec3(0.0, 0.0, 0.0)
    result[0] = normalizedValue; result[1] = 0.0
    return result
  end if
  inverseMagnitude = 1.0 / magnitude
  normalizedValue = qt.Vec3(x * inverseMagnitude, y * inverseMagnitude, z * inverseMagnitude)
  result[0] = normalizedValue; result[1] = magnitude
  return result
end function

/// Return the component value.
/// @param value Value consumed or transformed by the operation.
/// @param axis axis value consumed by this operation.
function component(value, axis)
  valid = try(validatePhysicsVector(value, "physics vector component"))
  if valid is error then return valid end if
  if axis == 0 then return value.x end if
  if axis == 1 then return value.y end if
  return value.z
end function

/// Set component.
/// @param value Value consumed or transformed by the operation.
/// @param axis axis value consumed by this operation.
/// @param componentValue componentValue value consumed by this operation.
function setComponent(value, axis, componentValue)
  // This operation intentionally mutates its input. Validate and extract in
  // this frame so no helper allocation separates the store from the parameter.
  if typeof(value) != "struct" then return error(2840, "physics vector setComponent: Vec3-shaped value required") end if
  x = try(value.x); y = try(value.y); z = try(value.z)
  xType = typeof(x); yType = typeof(y); zType = typeof(z)
  if (xType != "int" and xType != "float") or
      (yType != "int" and yType != "float") or
      (zType != "int" and zType != "float") then
    return error(2840, "physics vector setComponent: numeric Vec3 components required")
  end if
  rootedValue = value
  if axis == 0 then rootedValue.x = componentValue; return rootedValue end if
  if axis == 1 then rootedValue.y = componentValue; return rootedValue end if
  rootedValue.z = componentValue
  return rootedValue
end function

/// Return the angle vectors value.
/// @param angles angles value consumed by this operation.
function angleVectors(angles)
  valid = try(validatePhysicsVector(angles, "physics angleVectors"))
  if valid is error then return valid end if
  angleX = angles.x; angleY = angles.y; angleZ = angles.z
  pitch = smath.degToRad(angleX)
  yaw = smath.degToRad(angleY)
  roll = smath.degToRad(angleZ)

  pitchSine = smath.sin(pitch)
  pitchCosine = smath.cos(pitch)
  yawSine = smath.sin(yaw)
  yawCosine = smath.cos(yaw)
  rollSine = smath.sin(roll)
  rollCosine = smath.cos(roll)

  forwardX = pitchCosine * yawCosine
  forwardY = pitchCosine * yawSine
  forwardZ = -pitchSine
  rightX = -rollSine * pitchSine * yawCosine + rollCosine * yawSine
  rightY = -rollSine * pitchSine * yawSine - rollCosine * yawCosine
  rightZ = -rollSine * pitchCosine
  upX = rollCosine * pitchSine * yawCosine + rollSine * yawSine
  upY = rollCosine * pitchSine * yawSine - rollSine * yawCosine
  upZ = rollCosine * pitchCosine

  result = array(3)
  forward = qt.Vec3(forwardX, forwardY, forwardZ)
  result[0] = forward
  right = qt.Vec3(rightX, rightY, rightZ)
  result[1] = right
  up = qt.Vec3(upX, upY, upZ)
  result[2] = up
  return result
end function
