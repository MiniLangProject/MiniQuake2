/*
Copyright (C) 1997-2001 Id Software, Inc.
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later

Deterministic CPU preparation for the BSP OpenGL path.  Files are read
only through a function value so this layer is independent of the runtime FS.
*/
package miniquake2.renderer.classic.world

import miniquake2.format.pcx as fpcx
import miniquake2.format.wal as fwal
import miniquake2.format.types as ft
import miniquake2.qcommon.text as qtext
import std.string as rclassicworldstring
import miniquake2.renderer.classic.constants as rclassicconstants
import miniquake2.renderer.classic.types as rclassictypes
import miniquake2.renderer.classic.materials as rclassicmaterials
import miniquake2.renderer.classic.scene as rclassicscene
import miniquake2.renderer.classic.special as rclassicspecial

const PALETTE_PATH = "pics/colormap.pcx"

function readBytes(loadFile, path)
  data = loadFile(path)
  if typeof(data) != "bytes" then return error(9740, "classic renderer file not found: " + path) end if
  return data
end function

function quakePalette(loadFile)
  pcx = fpcx.parse(readBytes(loadFile, PALETTE_PATH))
  if len(pcx.palette) != 768 then return error(9741, "pics/colormap.pcx has no Quake II palette") end if
  return pcx.palette
end function

function texturePath(name)
  return "textures/" + name + ".wal"
end function

function loadImages(map, loadFile, palette)
  images = []
  for each texInfo in map.texInfo
    if rclassicmaterials.findImage(images, texInfo.texture) is void then
      wal = fwal.parse(readBytes(loadFile, texturePath(texInfo.texture)))
      image = rclassicmaterials.imageFromWal(wal, palette)
      // BSP texinfo is authoritative for lookup.  Retail WAL headers normally
      // agree, but aliases and synthetic fixtures need not do so.
      image.name = texInfo.texture
      images = images + [image]
    end if
  end for
  return images
end function

function findTexture(textures, role, name)
  for each texture in textures
    if texture.role == role and qtext.equalInsensitive(texture.name, name) then return texture end if
  end for
  return void
end function

function addBaseTexture(textures, image, generation)
  existing = findTexture(textures, "base", image.name)
  if existing is not void then return [textures, existing] end if
  expected = image.width * image.height * 4
  if image.width <= 0 or image.height <= 0 or len(image.rgbaPixels) != expected then
    return error(9742, "invalid RGBA WAL image: " + image.name)
  end if
  texture = rclassictypes.ClassicTexture(0, image.name, image.width, image.height, image.rgbaPixels, "base", generation, false, false)
  return [textures + [texture], texture]
end function

function surfaceBounds(surface)
  if len(surface.vertices) < 3 then return error(9745, "classic surface bounds require at least three vertices") end if
  first = surface.vertices[0].position
  minX = first.x; minY = first.y; minZ = first.z
  maxX = first.x; maxY = first.y; maxZ = first.z
  vertexIndex = 1
  while vertexIndex < len(surface.vertices)
    position = surface.vertices[vertexIndex].position
    if position.x < minX then minX = position.x end if
    if position.y < minY then minY = position.y end if
    if position.z < minZ then minZ = position.z end if
    if position.x > maxX then maxX = position.x end if
    if position.y > maxY then maxY = position.y end if
    if position.z > maxZ then maxZ = position.z end if
    vertexIndex = vertexIndex + 1
  end while
  return [
    ft.Vec3(minX, minY, minZ),
    ft.Vec3(maxX, maxY, maxZ)
  ]
end function

function addWorldDraw(textures, draws, surface, generation)
  animationCount = len(surface.animationImages)
  if animationCount == 0 then animationCount = 1 end if
  baseTextures = array(animationCount)
  animationIndex = 0
  while animationIndex < animationCount
    animationImage = surface.image
    if len(surface.animationImages) > 0 then animationImage = surface.animationImages[animationIndex] end if
    baseResult = addBaseTexture(textures, animationImage, generation)
    textures = baseResult[0]
    baseTextures[animationIndex] = baseResult[1]
    animationIndex = animationIndex + 1
  end while
  baseTexture = baseTextures[0]
  for each candidate in baseTextures
    if qtext.equalInsensitive(candidate.name, surface.image.name) then baseTexture = candidate end if
  end for
  lightmapTexture = void
  if surface.category == rclassicconstants.MATERIAL_OPAQUE then
    expected = surface.lightWidth * surface.lightHeight * 4
    if len(surface.lightmap) != expected then return error(9743, "invalid lightmap payload for BSP surface " + surface.index) end if
    lightmapTexture = rclassictypes.ClassicTexture(
      0, "@lightmap/" + surface.index, surface.lightWidth, surface.lightHeight,
      surface.lightmap, "lightmap", generation, false, false
    )
    textures = textures + [lightmapTexture]
  end if
  vertices = rclassicspecial.classicSpecialDrawVertices(surface)
  triangleCount = len(vertices) / 3
  if triangleCount < 1 then return error(9744, "BSP surface has fewer than three render vertices") end if
  bounds = surfaceBounds(surface)
  draw = rclassictypes.ClassicWorldDraw(surface, baseTexture, baseTextures, lightmapTexture, vertices, triangleCount, bounds[0], bounds[1])
  return [textures, draws + [draw]]
end function

function classicWorldEntityValue(entityText, key)
  if typeof(entityText) != "string" or entityText == "" then return "" end if
  parts = rclassicworldstring.split(entityText, "\"")
  index = 1
  while index + 2 < len(parts)
    if rclassicworldstring.trim(parts[index]) == key then return rclassicworldstring.trim(parts[index + 2]) end if
    index = index + 2
  end while
  return ""
end function

function classicWorldSkyAxis(entityText)
  text = classicWorldEntityValue(entityText, "skyaxis")
  if text == "" then return ft.Vec3(0.0, 0.0, 1.0) end if
  parts = rclassicworldstring.split(text, " ")
  values = array(3, 0.0)
  count = 0
  for each part in parts
    value = rclassicworldstring.trim(part)
    if value != "" and count < 3 then
      parsed = try(toNumber(value))
      if parsed is error then return ft.Vec3(0.0, 0.0, 1.0) end if
      values[count] = parsed
      count = count + 1
    end if
  end for
  if count != 3 then return ft.Vec3(0.0, 0.0, 1.0) end if
  return ft.Vec3(values[0], values[1], values[2])
end function

function classicWorldSkyRotate(entityText)
  text = classicWorldEntityValue(entityText, "skyrotate")
  if text == "" then return 0.0 end if
  parsed = try(toNumber(text))
  if parsed is error then return 0.0 end if
  return parsed
end function

function classicWorldSkyTexture(loadFile, skyName, suffix, generation, fallbackPalette)
  path = "env/" + skyName + suffix + ".pcx"
  data = loadFile(path)
  if typeof(data) != "bytes" then return void end if
  pcx = fpcx.parse(data)
  palette = pcx.palette
  if len(palette) != 768 then palette = fallbackPalette end if
  rgba = rclassicmaterials.rgbaFromIndexed(pcx.pixels, palette)
  if len(rgba) != pcx.width * pcx.height * 4 then return error(9746, "invalid sky PCX palette: " + path) end if
  return rclassictypes.ClassicTexture(0, "@sky/" + skyName + suffix, pcx.width, pcx.height, rgba, "sky", generation, false, false)
end function

function configureSky(world, loadFile, name, rotate, axis)
  if name == "" or len(world.scene.skySurfaces) == 0 then return false end if
  suffixes = ["rt", "bk", "lf", "ft", "up", "dn"]
  skyTextures = array(6)
  palette = quakePalette(loadFile)
  index = 0
  while index < 6
    texture = classicWorldSkyTexture(loadFile, name, suffixes[index], world.generation, palette)
    if texture is void then return false end if
    skyTextures[index] = texture
    index = index + 1
  end while
  for each texture in skyTextures world.textures = world.textures + [texture] end for
  world.skyBox = rclassictypes.ClassicSkyBox(name, rotate, axis, skyTextures, true)
  return true
end function

function buildModelDraws(scene, textures, generation, model)
  firstFace = model.firstFace
  endFace = firstFace + model.numFaces
  if firstFace < 0 or model.numFaces < 0 or endFace > len(scene.surfaces) then return error(9747, "BSP model face range outside classic scene") end if
  draws = []
  for each chain in scene.textureChains
    for each surface in chain.surfaces
      if surface.index >= firstFace and surface.index < endFace then
        drawResult = addWorldDraw(textures, draws, surface, generation)
        textures = drawResult[0]
        draws = drawResult[1]
      end if
    end for
  end for
  for each surface in scene.skySurfaces
    if surface.index >= firstFace and surface.index < endFace then
      drawResult = addWorldDraw(textures, draws, surface, generation)
      textures = drawResult[0]; draws = drawResult[1]
    end if
  end for
  for each surface in scene.transparentSurfaces
    if surface.index >= firstFace and surface.index < endFace then
      drawResult = addWorldDraw(textures, draws, surface, generation)
      textures = drawResult[0]; draws = drawResult[1]
    end if
  end for
  return [textures, draws]
end function

function findBrushModel(world, modelIndex)
  for each brushModel in world.brushModels
    if brushModel.modelIndex == modelIndex then return brushModel end if
  end for
  return void
end function

function build(map, loadFile, lightStyles, entityFrame, modulate, generation)
  palette = quakePalette(loadFile)
  images = loadImages(map, loadFile, palette)
  scene = rclassicscene.prepareMap(map, images, entityFrame, lightStyles, [], modulate)
  textures = []
  draws = []
  if len(map.models) == 0 then return error(9748, "classic BSP world has no models") end if
  worldResult = buildModelDraws(scene, textures, generation, map.models[0])
  textures = worldResult[0]; draws = worldResult[1]
  brushModels = array(len(map.models) - 1)
  modelIndex = 1
  while modelIndex < len(map.models)
    brushResult = buildModelDraws(scene, textures, generation, map.models[modelIndex])
    textures = brushResult[0]
    brushModels[modelIndex - 1] = rclassictypes.ClassicBrushModel(modelIndex, map.models[modelIndex], brushResult[1])
    modelIndex = modelIndex + 1
  end while
  skyBox = rclassictypes.ClassicSkyBox("", 0.0, ft.Vec3(0.0, 0.0, 1.0), array(0), false)
  return rclassictypes.ClassicWorld(map.name, generation, map, scene, textures, draws, brushModels, skyBox, modulate, false)
end function

function triangleCount(world)
  total = 0
  for each draw in world.draws
    total = total + draw.triangleCount
  end for
  return total
end function

function planSignature(world)
  // Compact deterministic replay signature used by tests and diagnostics.
  result = world.name + ":" + len(world.draws) + ":" + triangleCount(world)
  for each draw in world.draws
    result = result + ":" + draw.surface.index + "/" + draw.baseTexture.name + "/" + draw.surface.lightWidth + "x" + draw.surface.lightHeight
  end for
  return result
end function
