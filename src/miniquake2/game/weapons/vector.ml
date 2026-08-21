/* Vec3 operations and the exact AngleVectors convention used by BaseQ2. */
package miniquake2.game.weapons.vector

import std.math as smath
import miniquake2.qcommon.types as qt

// Validate the dynamic MiniLang value once and copy every component into a
// scalar array before callers allocate a result or enter another helper.
function weaponVectorComponents(value, operation)
  if typeof(value) != "struct" then
    return error(9480, operation + ": Vec3-shaped value required")
  end if
  x = try(value.x)
  y = try(value.y)
  z = try(value.z)
  xType = typeof(x); yType = typeof(y); zType = typeof(z)
  if (xType != "int" and xType != "float") or
      (yType != "int" and yType != "float") or
      (zType != "int" and zType != "float") then
    return error(9480, operation + ": numeric Vec3 components required")
  end if
  components = array(3)
  components[0] = x; components[1] = y; components[2] = z
  return components
end function

function copy(value)
  components = weaponVectorComponents(value, "weapon vector copy")
  x = components[0]; y = components[1]; z = components[2]
  result = qt.Vec3(x, y, z)
  return result
end function

function add(first, second)
  firstComponents = weaponVectorComponents(first, "weapon vector add first operand")
  firstX = firstComponents[0]; firstY = firstComponents[1]; firstZ = firstComponents[2]
  secondComponents = weaponVectorComponents(second, "weapon vector add second operand")
  secondX = secondComponents[0]; secondY = secondComponents[1]; secondZ = secondComponents[2]
  result = qt.Vec3(firstX + secondX, firstY + secondY, firstZ + secondZ)
  return result
end function

function subtract(first, second)
  firstComponents = weaponVectorComponents(first, "weapon vector subtract first operand")
  firstX = firstComponents[0]; firstY = firstComponents[1]; firstZ = firstComponents[2]
  secondComponents = weaponVectorComponents(second, "weapon vector subtract second operand")
  secondX = secondComponents[0]; secondY = secondComponents[1]; secondZ = secondComponents[2]
  result = qt.Vec3(firstX - secondX, firstY - secondY, firstZ - secondZ)
  return result
end function

function scale(value, amount)
  components = weaponVectorComponents(value, "weapon vector scale")
  x = components[0]; y = components[1]; z = components[2]
  result = qt.Vec3(x * amount, y * amount, z * amount)
  return result
end function

function multiplyAdd(value, amount, direction)
  valueComponents = weaponVectorComponents(value, "weapon vector multiplyAdd value")
  valueX = valueComponents[0]; valueY = valueComponents[1]; valueZ = valueComponents[2]
  directionComponents = weaponVectorComponents(direction, "weapon vector multiplyAdd direction")
  directionX = directionComponents[0]; directionY = directionComponents[1]; directionZ = directionComponents[2]
  result = qt.Vec3(
    valueX + amount * directionX,
    valueY + amount * directionY,
    valueZ + amount * directionZ
  )
  return result
end function

function dot(first, second)
  firstComponents = weaponVectorComponents(first, "weapon vector dot first operand")
  firstX = firstComponents[0]; firstY = firstComponents[1]; firstZ = firstComponents[2]
  secondComponents = weaponVectorComponents(second, "weapon vector dot second operand")
  secondX = secondComponents[0]; secondY = secondComponents[1]; secondZ = secondComponents[2]
  return firstX * secondX + firstY * secondY + firstZ * secondZ
end function

function length(value)
  components = weaponVectorComponents(value, "weapon vector length")
  x = components[0]; y = components[1]; z = components[2]
  squared = x * x + y * y + z * z
  return smath.sqrt(squared)
end function

function normalized(value)
  components = weaponVectorComponents(value, "weapon vector normalized")
  x = components[0]; y = components[1]; z = components[2]
  magnitude = smath.sqrt(x * x + y * y + z * z)
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

function midpoint(target)
  if typeof(target) != "struct" then return error(9481, "weapon midpoint: target record required") end if
  origin = try(target.origin)
  mins = try(target.mins)
  maxs = try(target.maxs)
  if typeof(origin) != "struct" or typeof(mins) != "struct" or typeof(maxs) != "struct" then
    return error(9481, "weapon midpoint: origin/mins/maxs Vec3 values required")
  end if
  originComponents = weaponVectorComponents(origin, "weapon midpoint origin")
  originX = originComponents[0]; originY = originComponents[1]; originZ = originComponents[2]
  minsComponents = weaponVectorComponents(mins, "weapon midpoint mins")
  minsX = minsComponents[0]; minsY = minsComponents[1]; minsZ = minsComponents[2]
  maxsComponents = weaponVectorComponents(maxs, "weapon midpoint maxs")
  maxsX = maxsComponents[0]; maxsY = maxsComponents[1]; maxsZ = maxsComponents[2]
  result = qt.Vec3(
    originX + (minsX + maxsX) * 0.5,
    originY + (minsY + maxsY) * 0.5,
    originZ + (minsZ + maxsZ) * 0.5
  )
  return result
end function

function toArray(value)
  components = weaponVectorComponents(value, "weapon vector toArray")
  x = components[0]; y = components[1]; z = components[2]
  result = array(3)
  result[0] = x; result[1] = y; result[2] = z
  return result
end function

function vectorToAngles(direction)
  components = weaponVectorComponents(direction, "weapon vectorToAngles")
  directionX = components[0]; directionY = components[1]; directionZ = components[2]
  yaw = 0.0
  pitch = 0.0
  if directionX == 0.0 and directionY == 0.0 then
    if directionZ > 0.0 then pitch = 90.0 else pitch = 270.0 end if
  else
    yaw = smath.radToDeg(smath.atan2(directionY, directionX))
    if yaw < 0.0 then yaw = yaw + 360.0 end if
    forward = smath.sqrt(directionX * directionX + directionY * directionY)
    pitch = smath.radToDeg(smath.atan2(directionZ, forward))
    if pitch < 0.0 then pitch = pitch + 360.0 end if
  end if
  result = qt.Vec3(-pitch, yaw, 0.0)
  return result
end function

function angleVectors(angles)
  components = weaponVectorComponents(angles, "weapon angleVectors")
  angleX = components[0]; angleY = components[1]; angleZ = components[2]
  pitch = smath.degToRad(angleX)
  yaw = smath.degToRad(angleY)
  roll = smath.degToRad(angleZ)
  sp = smath.sin(pitch); cp = smath.cos(pitch)
  sy = smath.sin(yaw); cy = smath.cos(yaw)
  sr = smath.sin(roll); cr = smath.cos(roll)

  forwardX = cp * cy; forwardY = cp * sy; forwardZ = -sp
  rightX = -sr * sp * cy + -cr * -sy
  rightY = -sr * sp * sy + -cr * cy
  rightZ = -sr * cp
  upX = cr * sp * cy + -sr * -sy
  upY = cr * sp * sy + -sr * cy
  upZ = cr * cp

  result = array(3)
  forward = qt.Vec3(forwardX, forwardY, forwardZ)
  result[0] = forward
  right = qt.Vec3(rightX, rightY, rightZ)
  result[1] = right
  up = qt.Vec3(upX, upY, upZ)
  result[2] = up
  return result
end function
