/* Vec3 math shared by classic light and sprite preparation. */
package miniquake2.renderer.classic.vector

import std.math as smath
import miniquake2.format.types as ft

function copy(value)
  return ft.Vec3(value.x, value.y, value.z)
end function
function add(first, second)
  return ft.Vec3(first.x + second.x, first.y + second.y, first.z + second.z)
end function
function subtract(first, second)
  return ft.Vec3(first.x - second.x, first.y - second.y, first.z - second.z)
end function
function scale(value, amount)
  return ft.Vec3(value.x * amount, value.y * amount, value.z * amount)
end function
function multiplyAdd(value, amount, direction)
  return ft.Vec3(value.x + amount * direction.x, value.y + amount * direction.y, value.z + amount * direction.z)
end function
function dot(first, second)
  return first.x * second.x + first.y * second.y + first.z * second.z
end function
function length(value)
  return smath.sqrt(dot(value, value))
end function

