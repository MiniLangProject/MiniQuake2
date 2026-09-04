//! Provides miniquake2 renderer classic materials facilities for this project.

/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* WAL/PCX material conversion, flags and BSP texture animation. */
package miniquake2.renderer.classic.materials

import std.array as rclassicarray
import miniquake2.format.constants as fc
import miniquake2.qcommon.text as qtext
import miniquake2.renderer.classic.constants as rclassicconstants
import miniquake2.renderer.classic.types as rclassictypes

/// Return the rgba from indexed.
/// @param pixels pixels value consumed by this operation.
/// @param palette palette value consumed by this operation.
function rgbaFromIndexed(pixels, palette)
  if typeof(pixels) != "bytes" then return bytes(0) end if
  if typeof(palette) != "bytes" or len(palette) < 768 then return bytes(0) end if
  rgba = bytes(len(pixels) * 4)
  index = 0
  while index < len(pixels)
    color = pixels[index]
    rgba[index * 4] = palette[color * 3]
    rgba[index * 4 + 1] = palette[color * 3 + 1]
    rgba[index * 4 + 2] = palette[color * 3 + 2]
    rgba[index * 4 + 3] = 255
    if color == 255 then rgba[index * 4 + 3] = 0 end if
    index = index + 1
  end while
  return rgba
end function

/// ref_gl uploads mipmapped world/model textures through its intensity table.
/// The stock default is 2; sky and 2-D pictures deliberately stay unscaled.
/// @param pixels pixels value consumed by this operation.
/// @param palette palette value consumed by this operation.
/// @param intensity intensity value consumed by this operation.
function rgbaFromIndexedIntensity(pixels, palette, intensity)
  rgba = rgbaFromIndexed(pixels, palette)
  if len(rgba) == 0 then return rgba end if
  index = 0
  while index < len(pixels)
    red = rgba[index * 4] * intensity
    green = rgba[index * 4 + 1] * intensity
    blue = rgba[index * 4 + 2] * intensity
    if red > 255 then red = 255 end if
    if green > 255 then green = 255 end if
    if blue > 255 then blue = 255 end if
    rgba[index * 4] = red
    rgba[index * 4 + 1] = green
    rgba[index * 4 + 2] = blue
    index = index + 1
  end while
  return rgba
end function

/// Return the image from wal.
/// @param wal wal value consumed by this operation.
/// @param palette palette value consumed by this operation.
function imageFromWal(wal, palette)
  pixels = bytes(0)
  if len(wal.mipPixels) > 0 then pixels = wal.mipPixels[0] end if
  return rclassictypes.ClassicImage(
    wal.name, wal.width, wal.height, pixels, palette,
    rgbaFromIndexedIntensity(pixels, palette, 2), wal.flags, wal.animationName
  )
end function

/// Return the image from pcx.
/// @param name Name of the affected item.
/// @param pcx pcx value consumed by this operation.
function imageFromPcx(name, pcx)
  return rclassictypes.ClassicImage(
    name, pcx.width, pcx.height, pcx.pixels, pcx.palette,
    rgbaFromIndexed(pcx.pixels, pcx.palette), 0, ""
  )
end function

/// Find image.
/// @param images images value consumed by this operation.
/// @param name Name of the affected item.
function findImage(images, name)
  for each image in images
    if qtext.equalInsensitive(image.name, name) then return image end if
  end for
  return void
end function

/// Return the image or fallback value.
/// @param images images value consumed by this operation.
/// @param name Name of the affected item.
function imageOrFallback(images, name)
  image = findImage(images, name)
  if image is void then return rclassictypes.fallbackImage(name) end if
  return image
end function

/// Return the classify value.
/// @param flags Bit flags controlling the operation.
function classify(flags)
  if (flags & fc.SURF_NODRAW) != 0 then return rclassicconstants.MATERIAL_NODRAW end if
  if (flags & fc.SURF_SKY) != 0 then return rclassicconstants.MATERIAL_SKY end if
  if (flags & (fc.SURF_TRANS33 | fc.SURF_TRANS66)) != 0 then return rclassicconstants.MATERIAL_TRANSPARENT end if
  if (flags & fc.SURF_WARP) != 0 then return rclassicconstants.MATERIAL_WARP end if
  return rclassicconstants.MATERIAL_OPAQUE
end function

/// Return the alpha for flags.
/// @param flags Bit flags controlling the operation.
function alphaForFlags(flags)
  if (flags & fc.SURF_TRANS33) != 0 then return 0.33 end if
  if (flags & fc.SURF_TRANS66) != 0 then return 0.66 end if
  return 1.0
end function

/// Return the animation images value.
/// @param map map value consumed by this operation.
/// @param texInfoIndex Zero-based index of tex info.
/// @param images images value consumed by this operation.
function animationImages(map, texInfoIndex, images)
  result = array(len(map.texInfo))
  resultCount = 0
  visited = array(len(map.texInfo), false)
  current = texInfoIndex
  guard = 0
  while current >= 0 and current < len(map.texInfo) and guard < len(map.texInfo) + 1
    if visited[current] then break end if
    visited[current] = true
    texInfo = map.texInfo[current]
    result[resultCount] = imageOrFallback(images, texInfo.texture)
    resultCount = resultCount + 1
    current = texInfo.nextTexInfo
    guard = guard + 1
  end while
  if resultCount == 0 and texInfoIndex >= 0 and texInfoIndex < len(map.texInfo) then
    result[resultCount] = imageOrFallback(images, map.texInfo[texInfoIndex].texture)
    resultCount = resultCount + 1
  end if
  return rclassicarray.slice(result, 0, resultCount)
end function

/// Return the animated image value.
/// @param frames frames value consumed by this operation.
/// @param entityFrame entityFrame value consumed by this operation.
function animatedImage(frames, entityFrame)
  if len(frames) == 0 then return void end if
  index = entityFrame % len(frames)
  if index < 0 then index = index + len(frames) end if
  return frames[index]
end function
