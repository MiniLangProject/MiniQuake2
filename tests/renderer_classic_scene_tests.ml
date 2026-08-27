/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Synthetic BSP/WAL/PCX material chains and sprite-frame preparation. */
import miniquake2.format.constants as fc
import miniquake2.format.types as ft
import miniquake2.qcommon.types as qt
import miniquake2.renderer.constants as rc
import miniquake2.renderer.types as rt
import miniquake2.renderer.classic.constants as rclassicconstants
import miniquake2.renderer.classic.materials as rclassicmaterials
import miniquake2.renderer.classic.scene as rclassicscene
import miniquake2.renderer.classic.sprites as rclassicsprites

// Assert the equal test condition.
function assertEqual(actual, expected, name)
  if actual != expected then return error(7985, name + ": expected " + expected + ", got " + actual) end if
  return true
end function
// Assert the near test condition.
function assertNear(actual, expected, tolerance, name)
  difference = actual - expected
  if difference < 0.0 then difference = -difference end if
  if difference > tolerance then return error(7986, name + ": outside tolerance") end if
  return true
end function

// Return the palette value.
function palette()
  result = bytes(768)
  result[3] = 10; result[4] = 20; result[5] = 30
  result[255 * 3] = 200; result[255 * 3 + 1] = 210; result[255 * 3 + 2] = 220
  return result
end function

// Create images.
function makeImages()
  pal = palette()
  mip = [bytes([1, 255, 1, 1]), bytes([1]), bytes([1]), bytes([1])]
  baseWal = ft.WalTexture("base", 2, 2, [100, 104, 105, 106], mip, "alt", 0, 0, 0)
  altWal = ft.WalTexture("alt", 2, 2, [100, 104, 105, 106], mip, "base", 0, 0, 0)
  pcx = ft.PcxImage(2, 1, bytes([1, 255]), pal)
  baseImage = rclassicmaterials.imageFromWal(baseWal, pal)
  altImage = rclassicmaterials.imageFromWal(altWal, pal)
  skyImage = rclassicmaterials.imageFromPcx("sky", pcx)
  transparent = rclassicmaterials.imageFromPcx("glass", pcx)
  warp = rclassicmaterials.imageFromPcx("water", pcx)
  hidden = rclassicmaterials.imageFromPcx("hidden", pcx)
  return [baseImage, altImage, skyImage, transparent, warp, hidden]
end function

// Create map.
function makeMap()
  vertices = [
    ft.BspVertex(ft.Vec3(0.0, 0.0, 0.0)), ft.BspVertex(ft.Vec3(16.0, 0.0, 0.0)),
    ft.BspVertex(ft.Vec3(16.0, 16.0, 0.0)), ft.BspVertex(ft.Vec3(0.0, 16.0, 0.0))
  ]
  edges = [ft.BspEdge(0, 1), ft.BspEdge(1, 2), ft.BspEdge(2, 3), ft.BspEdge(3, 0)]
  projectionS = [1.0, 0.0, 0.0, 0.0]
  projectionT = [0.0, 1.0, 0.0, 0.0]
  texInfo = [
    ft.BspTexInfo(projectionS, projectionT, 0, 0, "base", 1),
    ft.BspTexInfo(projectionS, projectionT, fc.SURF_FLOWING, 0, "alt", 0),
    ft.BspTexInfo(projectionS, projectionT, fc.SURF_TRANS33, 0, "glass", -1),
    ft.BspTexInfo(projectionS, projectionT, fc.SURF_TRANS66 | fc.SURF_WARP, 0, "water", -1),
    ft.BspTexInfo(projectionS, projectionT, fc.SURF_SKY, 0, "sky", -1),
    ft.BspTexInfo(projectionS, projectionT, fc.SURF_WARP, 0, "water", -1),
    ft.BspTexInfo(projectionS, projectionT, fc.SURF_NODRAW, 0, "hidden", -1)
  ]
  faces = []
  index = 0
  while index < len(texInfo)
    faces = faces + [ft.BspFace(0, 0, 0, 4, index, bytes([0, 255, 255, 255]), -1)]
    index = index + 1
  end while
  plane = ft.BspPlane(ft.Vec3(0.0, 0.0, 1.0), 0.0, 2)
  model = ft.BspModel(ft.Vec3(0.0, 0.0, 0.0), ft.Vec3(16.0, 16.0, 0.0), ft.Vec3(0.0, 0.0, 0.0), 0, 0, len(faces))
  return ft.BspMap("synthetic", bytes(0), [], "", [plane], vertices, void, [], texInfo, faces, bytes(0), [], [], [], edges, [0, 1, 2, 3], [model], [], [], [], [])
end function

// Verify images animation and chains.
function testImagesAnimationAndChains()
  images = makeImages()
  assertEqual(slice(images[0].rgbaPixels, 0, 4), bytes([20, 40, 60, 255]), "ref_gl intensity-scaled WAL palette expansion")
  assertEqual(images[0].rgbaPixels[7], 0, "palette index 255 transparent")
  assertEqual(len(images[2].rgbaPixels), 8, "PCX RGBA expansion")
  map = makeMap()
  styles = [rt.lightStyle(1.0, 1.0, 1.0)]
  scene = rclassicscene.prepareMap(map, images, 1, styles, [], 1.0)
  assertEqual(scene.surfaces[0].image.name, "alt", "animated BSP texture frame")
  assertEqual(scene.surfaces[1].image.name, "base", "animation cycle from alternate")
  assertEqual(scene.surfaces[2].category, rclassicconstants.MATERIAL_TRANSPARENT, "trans33 classification")
  assertNear(scene.surfaces[2].alpha, 0.33, 0.0001, "trans33 alpha")
  assertEqual(scene.transparentSurfaces[0].index, 3, "transparent chain back-to-front")
  assertEqual(len(scene.skySurfaces), 1, "sky chain")
  assertEqual(len(scene.warpSurfaces), 2, "warp including translucent water")
  assertEqual(len(scene.noDrawSurfaces), 1, "nodraw chain")
  assertEqual(len(scene.textureChains), 3, "opaque/flowing/warp texture chains")
  assertEqual(scene.surfaces[0].lightmap, bytes([255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255]), "two by two fullbright lightmap")
  assertNear(scene.surfaces[0].vertices[1].s, 8.0, 0.0001, "WAL-width base coordinate")
  assertNear(scene.surfaces[0].vertices[2].lightS, 0.75, 0.0001, "local lightmap coordinate")
  replay = rclassicscene.prepareMap(map, images, 1, styles, [], 1.0)
  assertEqual(replay.surfaces[0].lightmap, scene.surfaces[0].lightmap, "deterministic scene replay")
  assertEqual(replay.transparentSurfaces[0].index, scene.transparentSurfaces[0].index, "deterministic chain replay")
  return true
end function

// Verify sprite frames.
function testSpriteFrames()
  frames = [ft.SpriteFrame(2, 4, 0, 0, "first.pcx"), ft.SpriteFrame(4, 6, 1, 2, "second.pcx")]
  model = ft.SpriteModel("sprite", frames)
  entity = rt.emptyEntity()
  entity.frame = 3
  entity.origin = qt.Vec3(10.0, 20.0, 30.0)
  entity.flags = rc.RF_TRANSLUCENT
  entity.alpha = 0.5
  draw = rclassicsprites.prepare(model, entity, qt.Vec3(0.0, 0.0, 1.0), qt.Vec3(0.0, 1.0, 0.0))
  assertEqual(draw.frameIndex, 1, "sprite modulo frame")
  assertEqual(draw.imageName, "second.pcx", "sprite frame image")
  assertNear(draw.vertices[0].position.y, 19.0, 0.0001, "sprite lower-left right axis")
  assertNear(draw.vertices[0].position.z, 28.0, 0.0001, "sprite lower-left up axis")
  assertNear(draw.vertices[2].position.y, 23.0, 0.0001, "sprite upper-right right axis")
  assertNear(draw.vertices[2].position.z, 34.0, 0.0001, "sprite upper-right up axis")
  assertEqual(draw.blend, true, "translucent sprite blend")
  assertEqual(draw.alphaTest, false, "translucent sprite alpha test")
  assertNear(draw.alpha, 0.5, 0.0001, "translucent sprite alpha")
  entity.flags = 0
  opaque = rclassicsprites.prepare(model, entity, qt.Vec3(0.0, 0.0, 1.0), qt.Vec3(0.0, 1.0, 0.0))
  assertEqual(opaque.alphaTest, true, "opaque sprite alpha test")
  return true
end function

testImagesAnimationAndChains()
testSpriteFrames()
print("renderer classic scene tests passed")
