//! Provides miniquake2 renderer classic vector facilities for this project.

/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Vec3 math shared by classic light and sprite preparation. */
package miniquake2.renderer.classic.vector

import std.math as smath
import miniquake2.format.types as ft

/// Performs the copy operation for the miniquake2 renderer classic vector module.
/// @param value Value consumed or transformed by the operation.
function inline copy(value)
  return ft.Vec3(value.x, value.y, value.z)
end function
/// Adds add to the state managed by the miniquake2 renderer classic vector module.
/// @param first first value consumed by this operation.
/// @param second second value consumed by this operation.
function inline add(first, second)
  return ft.Vec3(first.x + second.x, first.y + second.y, first.z + second.z)
end function
/// Performs the subtract operation for the miniquake2 renderer classic vector module.
/// @param first first value consumed by this operation.
/// @param second second value consumed by this operation.
function inline subtract(first, second)
  return ft.Vec3(first.x - second.x, first.y - second.y, first.z - second.z)
end function
/// Performs the scale operation for the miniquake2 renderer classic vector module.
/// @param value Value consumed or transformed by the operation.
/// @param amount amount value consumed by this operation.
function inline scale(value, amount)
  return ft.Vec3(value.x * amount, value.y * amount, value.z * amount)
end function
/// Performs the multiplyAdd operation for the miniquake2 renderer classic vector module.
/// @param value Value consumed or transformed by the operation.
/// @param amount amount value consumed by this operation.
/// @param direction direction value consumed by this operation.
function inline multiplyAdd(value, amount, direction)
  return ft.Vec3(value.x + amount * direction.x, value.y + amount * direction.y, value.z + amount * direction.z)
end function
/// Performs the dot operation for the miniquake2 renderer classic vector module.
/// @param first first value consumed by this operation.
/// @param second second value consumed by this operation.
function inline dot(first, second)
  return first.x * second.x + first.y * second.y + first.z * second.z
end function
/// Performs the length operation for the miniquake2 renderer classic vector module.
/// @param value Value consumed or transformed by the operation.
function length(value)
  return smath.sqrt(dot(value, value))
end function
