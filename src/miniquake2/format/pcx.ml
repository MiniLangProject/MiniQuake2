//! Provides miniquake2 format pcx facilities for this project.

/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Strict 8-bit single-plane PCX decoder used by Quake II pictures and skins. */
package miniquake2.format.pcx

import miniquake2.format.types as ft
import miniquake2.format.binary as fbio

/// Parses parse for the miniquake2 format pcx workflow.
/// @param data Input data consumed by the operation.
function parse(data)
  // Keep parse phases explicit: validate inputs, update owned state, then publish the result.
  if len(data) < 128 then return error(2600, "PCX header is truncated") end if
  if data[0] != 0x0a or data[1] != 5 or data[2] != 1 or data[3] != 8 then return error(2601, "unsupported PCX encoding") end if
  xmin = fbio.u16(data, 4)
  ymin = fbio.u16(data, 6)
  xmax = fbio.u16(data, 8)
  ymax = fbio.u16(data, 10)
  if xmax < xmin or ymax < ymin then return error(2602, "invalid PCX bounds") end if
  width = xmax - xmin + 1
  height = ymax - ymin + 1
  planes = data[65]
  bytesPerLine = fbio.u16(data, 66)
  if width <= 0 or height <= 0 or width > 8192 or height > 8192 or planes != 1 or bytesPerLine < width then return error(2603, "invalid PCX layout") end if
  pixels = bytes(width * height)
  input = 128
  y = 0
  while y < height
    x = 0
    decoded = 0
    while decoded < bytesPerLine
      if input >= len(data) then return error(2604, "truncated PCX RLE stream") end if
      value = data[input]
      input = input + 1
      run = 1
      if (value & 0xc0) == 0xc0 then
        run = value & 0x3f
        if run == 0 or input >= len(data) then return error(2605, "invalid PCX RLE run") end if
        value = data[input]
        input = input + 1
      end if
      if run > bytesPerLine - decoded then return error(2606, "PCX RLE crosses scanline") end if
      j = 0
      while j < run
        if x < width then pixels[y * width + x] = value end if
        x = x + 1
        decoded = decoded + 1
        j = j + 1
      end while
    end while
    y = y + 1
  end while
  palette = bytes(0)
  if len(data) >= 769 and data[len(data) - 769] == 12 then palette = slice(data, len(data) - 768, 768) end if
  return ft.PcxImage(width, height, pixels, palette)
end function
