/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Quake II WAL texture loader. */
package miniquake2.format.wal

import miniquake2.format.constants as fc
import miniquake2.format.types as ft
import miniquake2.format.binary as fbio

// Parse state.
function parse(data)
  if len(data) < 100 then return error(2500, "WAL header is truncated") end if
  name = fbio.fixedString(data, 0, 32)
  width = fbio.u32(data, 32)
  height = fbio.u32(data, 36)
  if width <= 0 or height <= 0 or width > 8192 or height > 8192 then return error(2501, "invalid WAL dimensions") end if
  offsets = array(fc.MIPLEVELS)
  pixels = array(fc.MIPLEVELS)
  levelWidth = width
  levelHeight = height
  i = 0
  while i < fc.MIPLEVELS
    offsets[i] = fbio.u32(data, 40 + i * 4)
    levelBytes = levelWidth * levelHeight
    if offsets[i] < 100 or offsets[i] > len(data) or levelBytes > len(data) - offsets[i] then return error(2502, "WAL mip level outside file") end if
    pixels[i] = slice(data, offsets[i], levelBytes)
    if levelWidth > 1 then levelWidth = levelWidth / 2 end if
    if levelHeight > 1 then levelHeight = levelHeight / 2 end if
    i = i + 1
  end while
  return ft.WalTexture(name, width, height, offsets, pixels, fbio.fixedString(data, 56, 32), fbio.i32(data, 88), fbio.i32(data, 92), fbio.i32(data, 96))
end function
