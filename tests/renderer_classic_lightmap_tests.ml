/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Asset-free golden tests for static/dynamic classic RGBA lightmaps. */
import miniquake2.format.constants as fc
import miniquake2.format.types as ft
import miniquake2.qcommon.types as qt
import miniquake2.renderer.types as rt
import miniquake2.renderer.classic.constants as rclassicconstants
import miniquake2.renderer.classic.types as rclassictypes
import miniquake2.renderer.classic.lightmaps as rclassiclightmaps

function assertEqual(actual, expected, name)
  if actual != expected then return error(7980, name + ": expected " + expected + ", got " + actual) end if
  return true
end function

function makeSurface(width, height, styles, samples, flags)
  texInfo = ft.BspTexInfo([1.0, 0.0, 0.0, 0.0], [0.0, 1.0, 0.0, 0.0], flags, 0, "light", -1)
  face = ft.BspFace(0, 0, 0, 4, 0, styles, 0)
  plane = ft.BspPlane(ft.Vec3(0.0, 0.0, 1.0), 0.0, 2)
  image = rclassictypes.fallbackImage("light")
  return rclassictypes.ClassicSurface(
    0, face, plane, texInfo, image, [image], rclassicconstants.MATERIAL_OPAQUE,
    1.0, [0, 0], [(width - 1) * 16, (height - 1) * 16], width, height,
    [], samples, styles, 0, bytes(0), array(4, -1.0)
  )
end function

function testSingleAndMultipleStyles()
  styles = [rt.lightStyle(1.0, 0.5, 2.0), rt.lightStyle(1.0, 0.5, 1.0)]
  samples = bytes([100, 50, 25, 100, 50, 25, 100, 50, 25, 100, 50, 25])
  surface = makeSurface(2, 2, bytes([0, 255, 255, 255]), samples, 0)
  result = rclassiclightmaps.buildLightmap(surface, styles, [], 1.0)
  assertEqual(slice(result, 0, 4), bytes([100, 25, 50, 100]), "single style RGB scale")
  assertEqual(len(result), 16, "two by two RGBA size")

  combined = makeSurface(1, 1, bytes([0, 1, 255, 255]), bytes([100, 0, 0, 0, 100, 0]), 0)
  result = rclassiclightmaps.buildLightmap(combined, styles, [], 1.0)
  assertEqual(result, bytes([100, 50, 0, 100]), "multiple style accumulation")
  return true
end function

function testFullbrightAndRescale()
  styles = [rt.lightStyle(1.0, 1.0, 1.0)]
  surface = makeSurface(1, 1, bytes([0, 255, 255, 255]), void, 0)
  assertEqual(rclassiclightmaps.buildLightmap(surface, styles, [], 4.0), bytes([255, 255, 255, 255]), "missing samples fullbright")
  bright = makeSurface(1, 1, bytes([0, 255, 255, 255]), bytes([255, 128, 64]), 0)
  assertEqual(rclassiclightmaps.buildLightmap(bright, styles, [], 2.0), bytes([255, 128, 64, 255]), "overbright ratio rescale")
  invalid = makeSurface(1, 1, bytes([0, 255, 255, 255]), bytes([0, 0, 0]), fc.SURF_WARP)
  assertEqual(typeof(try(rclassiclightmaps.buildLightmap(invalid, styles, [], 1.0))), "error", "warp lightmap rejected")
  return true
end function

function testDynamicContributionAndCache()
  styles = [rt.lightStyle(1.0, 1.0, 1.0)]
  surface = makeSurface(2, 2, bytes([0, 255, 255, 255]), bytes(12), 0)
  light = rt.dLight(qt.Vec3(0.0, 0.0, 0.0), qt.Vec3(1.0, 0.5, 0.25), 128.0)
  assertEqual(rclassiclightmaps.markDynamicLights(surface, [light]), 1, "dynamic light bit")
  result = rclassiclightmaps.buildLightmap(surface, styles, [light], 1.0)
  assertEqual(slice(result, 0, 4), bytes([128, 64, 32, 128]), "dynamic center luxel")
  assertEqual(slice(result, 4, 4), bytes([112, 56, 28, 112]), "dynamic distance falloff")
  rclassiclightmaps.setCacheState(surface, styles)
  assertEqual(surface.cachedLight[0], 3.0,
    "cached style white uses stock RGB sum")
  assertEqual(surface.cachedLight[1], -1.0, "unused cached style")
  return true
end function

testSingleAndMultipleStyles()
testFullbrightAndRescale()
testDynamicContributionAndCache()
print("renderer classic lightmap tests passed")
