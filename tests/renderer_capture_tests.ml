/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Asset-free golden tests for canonical framebuffer capture and TGA output. */
import miniquake2.renderer.capture as rendercapturetest

// Assert the capture equal test condition.
function captureAssertEqual(actual, expected, label)
  if actual != expected then return error(7995, label + ": expected " + expected + ", got " + actual) end if
end function

// Capture golden test.
function captureGoldenTest()
  // OpenGL rows: bottom red/green, then top blue/white.
  glPixels = bytes([
    255, 0, 0, 255, 0, 255, 0, 255,
    0, 0, 255, 255, 255, 255, 255, 255
  ])
  captured = rendercapturetest.canonicalizeOpenGlRgba(2, 2, glPixels)
  canonical = bytes([
    0, 0, 255, 255, 255, 255, 255, 255,
    255, 0, 0, 255, 0, 255, 0, 255
  ])
  captureAssertEqual(captured.rgba, canonical, "top-left canonical rows")

  tga = rendercapturetest.encodeTga(captured)
  captureAssertEqual(len(tga), 34, "TGA byte count")
  captureAssertEqual(tga[2], 2, "TGA uncompressed true-colour type")
  captureAssertEqual(tga[12], 2, "TGA width low byte")
  captureAssertEqual(tga[14], 2, "TGA height low byte")
  captureAssertEqual(tga[16], 32, "TGA pixel depth")
  captureAssertEqual(tga[17], 0x28, "TGA top-left alpha descriptor")
  captureAssertEqual(slice(tga, 18, 8), bytes([255, 0, 0, 255, 255, 255, 255, 255]), "TGA BGRA top row")

  replay = rendercapturetest.image(2, 2, canonical)
  exact = rendercapturetest.compare(captured, replay, 0, false)
  captureAssertEqual(exact.exact, true, "exact replay")
  captureAssertEqual(exact.differingPixels, 0, "exact differing pixels")
  captureAssertEqual(exact.comparedChannels, 3, "RGB comparison")

  changedBytes = bytes(canonical)
  changedBytes[0] = 3
  changedBytes[3] = 0
  changed = rendercapturetest.image(2, 2, changedBytes)
  tolerant = rendercapturetest.compare(captured, changed, 3, false)
  captureAssertEqual(tolerant.exact, true, "channel tolerance")
  captureAssertEqual(tolerant.absoluteError, 3, "RGB absolute error")
  alpha = rendercapturetest.compare(captured, changed, 0, true)
  captureAssertEqual(alpha.differingPixels, 1, "combined RGBA differing pixel")
  captureAssertEqual(alpha.differingChannels, 2, "RGBA differing channels")
  captureAssertEqual(alpha.maxChannelDelta, 255, "RGBA maximum delta")
  captureAssertEqual(alpha.absoluteError, 258, "RGBA absolute error")

  captureAssertEqual(typeof(try(rendercapturetest.image(2, 2, bytes(15)))), "error", "bad payload rejected")
  captureAssertEqual(typeof(try(rendercapturetest.compare(captured, changed, 256, false))), "error", "bad tolerance rejected")
end function

captureGoldenTest()
print "renderer capture tests passed"
