//! Provides miniquake2 format sprite facilities for this project.

/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Quake II SP2 sprite loader. */
package miniquake2.format.sprite

import miniquake2.format.constants as fc
import miniquake2.format.types as ft
import miniquake2.format.binary as fbio

/// Parses parse for the miniquake2 format sprite workflow.
/// @param data Input data consumed by the operation.
/// @param name Name of the affected item.
function parse(data, name)
  if len(data) < 12 then return error(2400, "SP2 header is truncated") end if
  if fbio.u32(data, 0) != fc.IDSPRITEHEADER then return error(2401, "SP2 ident mismatch") end if
  if fbio.i32(data, 4) != fc.SPRITE_VERSION then return error(2402, "unsupported SP2 version") end if
  count = fbio.i32(data, 8)
  if count < 0 or count > fc.MAX_FRAMES or count * 80 > len(data) - 12 then return error(2403, "invalid SP2 frame table") end if
  frames = array(count)
  i = 0
  while i < count
    at = 12 + i * 80
    width = fbio.i32(data, at)
    height = fbio.i32(data, at + 4)
    if width <= 0 or height <= 0 then return error(2404, "invalid SP2 frame dimensions") end if
    frames[i] = ft.SpriteFrame(width, height, fbio.i32(data, at + 8), fbio.i32(data, at + 12), fbio.fixedString(data, at + 16, 64))
    i = i + 1
  end while
  return ft.SpriteModel(name, frames)
end function
