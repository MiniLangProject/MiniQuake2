/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later

Deterministic OpenGL framebuffer capture and lossless TGA serialization.
The canonical in-memory layout is top-left RGBA, independent of OpenGL's
bottom-left readback origin and TGA's selectable image origin.
*/
package miniquake2.renderer.capture

import std.fs as rendercapturefs
import miniquake2.native as rendercapturenative

const RENDERCAPTURE_GL_DITHER = 0x0BD0
const RENDERCAPTURE_GL_RGBA = 0x1908
const RENDERCAPTURE_GL_UNSIGNED_BYTE = 0x1401

struct CaptureImage
  width
  height
  rgba
end struct

struct PixelDiff
  width
  height
  totalPixels
  comparedChannels
  differingPixels
  differingChannels
  maxChannelDelta
  absoluteError
  exact
end struct

function validateCaptureDimensions(width, height)
  if typeof(width) != "int" or typeof(height) != "int" then
    return error(9690, "capture dimensions must be integers")
  end if
  if width < 1 or height < 1 or width > 65535 or height > 65535 then
    return error(9691, "capture dimensions outside TGA range")
  end if
  return width * height * 4
end function

function image(width, height, rgba)
  expected = validateCaptureDimensions(width, height)
  if typeof(rgba) != "bytes" or len(rgba) != expected then
    return error(9692, "capture RGBA payload has invalid size")
  end if
  return CaptureImage(width, height, rgba)
end function

// Convert GL's bottom-left RGBA rows to the one canonical top-left layout.
function canonicalizeOpenGlRgba(width, height, pixels)
  expected = validateCaptureDimensions(width, height)
  if typeof(pixels) != "bytes" or len(pixels) != expected then
    return error(9693, "OpenGL readback payload has invalid size")
  end if
  canonical = bytes(expected)
  rowBytes = width * 4
  targetY = 0
  while targetY < height
    sourceOffset = (height - targetY - 1) * rowBytes
    targetOffset = targetY * rowBytes
    x = 0
    while x < rowBytes
      canonical[targetOffset + x] = pixels[sourceOffset + x]
      x = x + 1
    end while
    targetY = targetY + 1
  end while
  return CaptureImage(width, height, canonical)
end function

// Read the current back buffer before EndFrame swaps it. Dithering is disabled
// so repeated captures on one GL implementation do not depend on pixel phase.
function readOpenGlFrame(width, height)
  expected = validateCaptureDimensions(width, height)
  pixels = bytes(expected)
  rendercapturenative.glDisable(RENDERCAPTURE_GL_DITHER)
  rendercapturenative.glFinish()
  rendercapturenative.glReadPixels(0, 0, width, height,
    RENDERCAPTURE_GL_RGBA, RENDERCAPTURE_GL_UNSIGNED_BYTE, pixels)
  return canonicalizeOpenGlRgba(width, height, pixels)
end function

// Uncompressed true-colour TGA, top-left origin, 8 alpha bits. This stays
// compatible with original ref_gl screenshots while preserving alpha exactly.
function encodeTga(captureImage)
  if typeof(captureImage) != "struct" then return error(9694, "CaptureImage required") end if
  width = captureImage.width; height = captureImage.height; rgba = captureImage.rgba
  expected = validateCaptureDimensions(width, height)
  if typeof(rgba) != "bytes" or len(rgba) != expected then return error(9692, "capture RGBA payload has invalid size") end if
  encoded = bytes(18 + expected)
  encoded[2] = 2
  encoded[12] = width & 255
  encoded[13] = (width >> 8) & 255
  encoded[14] = height & 255
  encoded[15] = (height >> 8) & 255
  encoded[16] = 32
  encoded[17] = 0x28
  pixel = 0
  while pixel < width * height
    source = pixel * 4
    target = 18 + source
    encoded[target] = rgba[source + 2]
    encoded[target + 1] = rgba[source + 1]
    encoded[target + 2] = rgba[source]
    encoded[target + 3] = rgba[source + 3]
    pixel = pixel + 1
  end while
  return encoded
end function

function writeTga(path, captureImage)
  if typeof(path) != "string" or path == "" then return error(9695, "capture output path required") end if
  return rendercapturefs.writeAllBytes(path, encodeTga(captureImage))
end function

function rgbaChecksum(captureImage)
  if typeof(captureImage) != "struct" or typeof(captureImage.rgba) != "bytes" then
    return error(9694, "CaptureImage required")
  end if
  // FNV-1a kept in the unsigned 32-bit domain for a compact capture identity.
  hash = 2166136261
  index = 0
  while index < len(captureImage.rgba)
    hash = ((hash ^ captureImage.rgba[index]) * 16777619) & 0xffffffff
    index = index + 1
  end while
  return hash
end function

// Exact counts plus an explicit per-channel tolerance form a driver-robust,
// machine-consumable metric without hiding large localized errors in one mean.
function compare(expectedImage, actualImage, channelTolerance, includeAlpha)
  if typeof(expectedImage) != "struct" or typeof(actualImage) != "struct" then
    return error(9696, "two CaptureImage values required")
  end if
  width = expectedImage.width; height = expectedImage.height
  if actualImage.width != width or actualImage.height != height then
    return error(9697, "capture dimensions differ")
  end if
  expectedRgba = expectedImage.rgba; actualRgba = actualImage.rgba
  expectedSize = validateCaptureDimensions(width, height)
  if typeof(expectedRgba) != "bytes" or typeof(actualRgba) != "bytes" or
      len(expectedRgba) != expectedSize or len(actualRgba) != expectedSize then
    return error(9692, "capture RGBA payload has invalid size")
  end if
  if typeof(channelTolerance) != "int" or channelTolerance < 0 or channelTolerance > 255 then
    return error(9698, "channel tolerance outside [0,255]")
  end if
  channelCount = 3
  if includeAlpha then channelCount = 4 end if
  differingPixels = 0; differingChannels = 0; maxChannelDelta = 0; absoluteError = 0
  pixel = 0
  while pixel < width * height
    pixelDiffers = false
    channel = 0
    while channel < channelCount
      offset = pixel * 4 + channel
      delta = actualRgba[offset] - expectedRgba[offset]
      if delta < 0 then delta = -delta end if
      absoluteError = absoluteError + delta
      if delta > maxChannelDelta then maxChannelDelta = delta end if
      if delta > channelTolerance then
        differingChannels = differingChannels + 1
        pixelDiffers = true
      end if
      channel = channel + 1
    end while
    if pixelDiffers then differingPixels = differingPixels + 1 end if
    pixel = pixel + 1
  end while
  return PixelDiff(width, height, width * height, channelCount,
    differingPixels, differingChannels, maxChannelDelta, absoluteError,
    differingChannels == 0)
end function
