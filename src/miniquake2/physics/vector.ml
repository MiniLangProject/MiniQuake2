/* Deterministic, allocation-explicit vector helpers for PMove. */
package miniquake2.physics.vector

import std.math as smath
import miniquake2.qcommon.types as qt

// Convert a dynamic Vec3-shaped value into scalars before any public helper
// allocates or calls another mathematical operation.
function physicsVectorComponents(value, operation)
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
  components = array(3)
  components[0] = x; components[1] = y; components[2] = z
  return components
end function

function copy(value)
  components = physicsVectorComponents(value, "physics vector copy")
  x = components[0]; y = components[1]; z = components[2]
  result = qt.Vec3(x, y, z)
  return result
end function

function add(first, second)
  firstComponents = physicsVectorComponents(first, "physics vector add first operand")
  firstX = firstComponents[0]; firstY = firstComponents[1]; firstZ = firstComponents[2]
  secondComponents = physicsVectorComponents(second, "physics vector add second operand")
  secondX = secondComponents[0]; secondY = secondComponents[1]; secondZ = secondComponents[2]
  result = qt.Vec3(firstX + secondX, firstY + secondY, firstZ + secondZ)
  return result
end function

function subtract(first, second)
  firstComponents = physicsVectorComponents(first, "physics vector subtract first operand")
  firstX = firstComponents[0]; firstY = firstComponents[1]; firstZ = firstComponents[2]
  secondComponents = physicsVectorComponents(second, "physics vector subtract second operand")
  secondX = secondComponents[0]; secondY = secondComponents[1]; secondZ = secondComponents[2]
  result = qt.Vec3(firstX - secondX, firstY - secondY, firstZ - secondZ)
  return result
end function

function scale(value, amount)
  components = physicsVectorComponents(value, "physics vector scale")
  x = components[0]; y = components[1]; z = components[2]
  result = qt.Vec3(x * amount, y * amount, z * amount)
  return result
end function

function multiplyAdd(value, amount, direction)
  valueComponents = physicsVectorComponents(value, "physics vector multiplyAdd value")
  valueX = valueComponents[0]; valueY = valueComponents[1]; valueZ = valueComponents[2]
  directionComponents = physicsVectorComponents(direction, "physics vector multiplyAdd direction")
  directionX = directionComponents[0]; directionY = directionComponents[1]; directionZ = directionComponents[2]
  result = qt.Vec3(
    valueX + amount * directionX,
    valueY + amount * directionY,
    valueZ + amount * directionZ
  )
  return result
end function

function dot(first, second)
  firstComponents = physicsVectorComponents(first, "physics vector dot first operand")
  firstX = firstComponents[0]; firstY = firstComponents[1]; firstZ = firstComponents[2]
  secondComponents = physicsVectorComponents(second, "physics vector dot second operand")
  secondX = secondComponents[0]; secondY = secondComponents[1]; secondZ = secondComponents[2]
  return firstX * secondX + firstY * secondY + firstZ * secondZ
end function

function cross(first, second)
  firstComponents = physicsVectorComponents(first, "physics vector cross first operand")
  firstX = firstComponents[0]; firstY = firstComponents[1]; firstZ = firstComponents[2]
  secondComponents = physicsVectorComponents(second, "physics vector cross second operand")
  secondX = secondComponents[0]; secondY = secondComponents[1]; secondZ = secondComponents[2]
  result = qt.Vec3(
    firstY * secondZ - firstZ * secondY,
    firstZ * secondX - firstX * secondZ,
    firstX * secondY - firstY * secondX
  )
  return result
end function

function length(value)
  components = physicsVectorComponents(value, "physics vector length")
  x = components[0]; y = components[1]; z = components[2]
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

// Return [normalized vector, original length], matching VectorNormalize's
// useful result without relying on reference parameters.
function normalized(value)
  components = physicsVectorComponents(value, "physics vector normalized")
  x = components[0]; y = components[1]; z = components[2]
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

function component(value, axis)
  components = physicsVectorComponents(value, "physics vector component")
  x = components[0]; y = components[1]; z = components[2]
  if axis == 0 then return x end if
  if axis == 1 then return y end if
  return z
end function

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

function angleVectors(angles)
  components = physicsVectorComponents(angles, "physics angleVectors")
  angleX = components[0]; angleY = components[1]; angleZ = components[2]
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
