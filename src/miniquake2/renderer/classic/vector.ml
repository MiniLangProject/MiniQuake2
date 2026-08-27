/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Vec3 math shared by classic light and sprite preparation. */
package miniquake2.renderer.classic.vector

import std.math as smath
import miniquake2.format.types as ft

// Copy state.
function inline copy(value)
  return ft.Vec3(value.x, value.y, value.z)
end function
// Add state.
function inline add(first, second)
  return ft.Vec3(first.x + second.x, first.y + second.y, first.z + second.z)
end function
// Subtract state.
function inline subtract(first, second)
  return ft.Vec3(first.x - second.x, first.y - second.y, first.z - second.z)
end function
// Scale state.
function inline scale(value, amount)
  return ft.Vec3(value.x * amount, value.y * amount, value.z * amount)
end function
// Add multiply.
function inline multiplyAdd(value, amount, direction)
  return ft.Vec3(value.x + amount * direction.x, value.y + amount * direction.y, value.z + amount * direction.z)
end function
// Compute state.
function inline dot(first, second)
  return first.x * second.x + first.y * second.y + first.z * second.z
end function
// Return the length.
function length(value)
  return smath.sqrt(dot(value, value))
end function
