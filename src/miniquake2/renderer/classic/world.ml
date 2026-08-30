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
import miniquake2.qcommon.byteio as rclassicworldbyteio
import std.string as rclassicworldstring
import miniquake2.renderer.classic.constants as rclassicconstants
import miniquake2.renderer.classic.types as rclassictypes
import miniquake2.renderer.classic.materials as rclassicmaterials
import miniquake2.renderer.classic.scene as rclassicscene
import miniquake2.renderer.classic.special as rclassicspecial

const PALETTE_PATH = "pics/colormap.pcx"
const LIGHTMAP_ATLAS_SIZE = 256

// Store lightmap atlas state data.
struct LightmapAtlasState
  textures
  current
  x
  y
  rowHeight
  generation
  faceTextures
  faceX
  faceY
  facePacked
end struct

// Decoded true-colour TGA used by stock-compatible environment maps.
struct ClassicTgaImage
  width
  height
  rgba
end struct

// Read bytes.
function readBytes(loadFile, path)
  data = loadFile(path)
  if typeof(data) != "bytes" then return error(9740, "classic renderer file not found: " + path) end if
  return data
end function

// Return the quake palette value.
function quakePalette(loadFile)
  pcx = fpcx.parse(readBytes(loadFile, PALETTE_PATH))
  if len(pcx.palette) != 768 then return error(9741, "pics/colormap.pcx has no Quake II palette") end if
  return pcx.palette
end function

// Return the texture path.
function texturePath(name)
  return "textures/" + name + ".wal"
end function

// Load images.
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

// Find texture.
function findTexture(textures, role, name)
  for each texture in textures
    if texture.role == role and qtext.equalInsensitive(texture.name, name) then return texture end if
  end for
  return void
end function

// Add base texture.
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

// Return the surface bounds.
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

// Add world draw.
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
  end if
  vertices = rclassicspecial.classicSpecialDrawVertices(surface)
  triangleCount = len(vertices) / 3
  if triangleCount < 1 then return error(9744, "BSP surface has fewer than three render vertices") end if
  bounds = surfaceBounds(surface)
  centerX = rclassicworldbyteio.truncInt((bounds[0].x + bounds[1].x) * 0.5 *
    rclassicconstants.CULL_COORD_SCALE)
  centerY = rclassicworldbyteio.truncInt((bounds[0].y + bounds[1].y) * 0.5 *
    rclassicconstants.CULL_COORD_SCALE)
  centerZ = rclassicworldbyteio.truncInt((bounds[0].z + bounds[1].z) * 0.5 *
    rclassicconstants.CULL_COORD_SCALE)
  // One fixed unit of padding absorbs truncation toward zero and keeps the
  // integer AABB test conservative at exact frustum boundaries.
  extentX = rclassicworldbyteio.truncInt((bounds[1].x - bounds[0].x) * 0.5 *
    rclassicconstants.CULL_COORD_SCALE) + 1
  extentY = rclassicworldbyteio.truncInt((bounds[1].y - bounds[0].y) * 0.5 *
    rclassicconstants.CULL_COORD_SCALE) + 1
  extentZ = rclassicworldbyteio.truncInt((bounds[1].z - bounds[0].z) * 0.5 *
    rclassicconstants.CULL_COORD_SCALE) + 1
  planeNormalX = rclassicworldbyteio.truncInt(surface.plane.normal.x *
    rclassicconstants.CULL_NORMAL_SCALE)
  planeNormalY = rclassicworldbyteio.truncInt(surface.plane.normal.y *
    rclassicconstants.CULL_NORMAL_SCALE)
  planeNormalZ = rclassicworldbyteio.truncInt(surface.plane.normal.z *
    rclassicconstants.CULL_NORMAL_SCALE)
  planeDistance = rclassicworldbyteio.truncInt(surface.plane.distance *
    rclassicconstants.CULL_PRODUCT_SCALE)
  draw = rclassictypes.ClassicWorldDraw(surface, baseTexture, baseTextures,
    lightmapTexture, 0, 0, vertices, triangleCount, bounds[0], bounds[1],
    centerX, centerY, centerZ, extentX, extentY, extentZ,
    planeNormalX, planeNormalY, planeNormalZ, planeDistance, surface.face.side)
  return [textures, draws + [draw]]
end function

// Return the new lightmap atlas value.
function newLightmapAtlas(state)
  index = len(state.textures)
  texture = rclassictypes.ClassicTexture(0, "@lightmap/atlas" + index,
    LIGHTMAP_ATLAS_SIZE, LIGHTMAP_ATLAS_SIZE,
    bytes(LIGHTMAP_ATLAS_SIZE * LIGHTMAP_ATLAS_SIZE * 4), "lightmap",
    state.generation, false, false)
  state.textures = state.textures + [texture]
  state.current = texture
  state.x = 0; state.y = 0; state.rowHeight = 0
  return texture
end function

// Copy lightmap atlas row.
function copyLightmapAtlasRow(destination, destinationPixel, source,
    sourcePixel, pixels)
  copyBytes(destination, destinationPixel * 4, source, sourcePixel * 4,
    pixels * 4)
  return pixels
end function

// Copy lightmap into atlas.
function copyLightmapIntoAtlas(texture, x, y, width, height, source)
  destination = texture.rgbaPixels
  row = 0
  while row < height
    destinationPixel = (y + row) * LIGHTMAP_ATLAS_SIZE + x
    sourcePixel = row * width
    copyLightmapAtlasRow(destination, destinationPixel, source, sourcePixel,
      width)
    // Duplicate edge texels into the one-pixel gutter used by GL_LINEAR.
    copyLightmapAtlasRow(destination, destinationPixel - 1, source,
      sourcePixel, 1)
    copyLightmapAtlasRow(destination, destinationPixel + width, source,
      sourcePixel + width - 1, 1)
    row = row + 1
  end while
  topPixel = (y - 1) * LIGHTMAP_ATLAS_SIZE + x - 1
  firstPixel = y * LIGHTMAP_ATLAS_SIZE + x - 1
  bottomPixel = (y + height) * LIGHTMAP_ATLAS_SIZE + x - 1
  lastPixel = (y + height - 1) * LIGHTMAP_ATLAS_SIZE + x - 1
  copyLightmapAtlasRow(destination, topPixel, destination, firstPixel,
    width + 2)
  copyLightmapAtlasRow(destination, bottomPixel, destination, lastPixel,
    width + 2)
  return true
end function

// Pack lightmap draw.
function packLightmapDraw(state, draw)
  if draw.surface.category != rclassicconstants.MATERIAL_OPAQUE then return false end if
  faceIndex = draw.surface.index
  if state.facePacked[faceIndex] != 0 then
    draw.lightmapTexture = state.faceTextures[faceIndex]
    draw.lightmapX = state.faceX[faceIndex]
    draw.lightmapY = state.faceY[faceIndex]
    return true
  end if
  width = draw.surface.lightWidth; height = draw.surface.lightHeight
  paddedWidth = width + 2; paddedHeight = height + 2
  if paddedWidth > LIGHTMAP_ATLAS_SIZE or
      paddedHeight > LIGHTMAP_ATLAS_SIZE then
    return error(9749, "BSP lightmap exceeds atlas size")
  end if
  if state.current is void then newLightmapAtlas(state) end if
  if state.x + paddedWidth > LIGHTMAP_ATLAS_SIZE then
    state.x = 0
    state.y = state.y + state.rowHeight
    state.rowHeight = 0
  end if
  if state.y + paddedHeight > LIGHTMAP_ATLAS_SIZE then
    newLightmapAtlas(state)
  end if
  atlasX = state.x + 1; atlasY = state.y + 1
  copyLightmapIntoAtlas(state.current, atlasX, atlasY, width, height,
    draw.surface.lightmap)
  draw.lightmapTexture = state.current
  draw.lightmapX = atlasX; draw.lightmapY = atlasY
  state.faceTextures[faceIndex] = state.current
  state.faceX[faceIndex] = atlasX; state.faceY[faceIndex] = atlasY
  state.facePacked[faceIndex] = 1
  // Triangle lists retain these SurfaceVertex records by reference, so update
  // each source polygon vertex exactly once.
  for each vertex in draw.surface.vertices
    vertex.lightS = (atlasX + vertex.lightS * width) /
      (LIGHTMAP_ATLAS_SIZE * 1.0)
    vertex.lightT = (atlasY + vertex.lightT * height) /
      (LIGHTMAP_ATLAS_SIZE * 1.0)
  end for
  state.x = state.x + paddedWidth
  if paddedHeight > state.rowHeight then state.rowHeight = paddedHeight end if
  return true
end function

// Pack lightmap atlases.
function packLightmapAtlases(draws, brushModels, generation, faceCount)
  state = LightmapAtlasState([], void, 0, 0, 0, generation,
    array(faceCount), array(faceCount, 0), array(faceCount, 0),
    bytes(faceCount))
  for each draw in draws packLightmapDraw(state, draw) end for
  for each brushModel in brushModels
    for each brushDraw in brushModel.draws
      packLightmapDraw(state, brushDraw)
    end for
  end for
  return state.textures
end function

// Return the classic world entity value.
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

// Return the classic world sky axis value.
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

// Rotate classic world sky.
function classicWorldSkyRotate(entityText)
  text = classicWorldEntityValue(entityText, "skyrotate")
  if text == "" then return 0.0 end if
  parsed = try(toNumber(text))
  if parsed is error then return 0.0 end if
  return parsed
end function

// Decode the uncompressed and RLE true-colour TGA variants accepted by ref_gl.
// The decoder remains MiniLang-owned so custom-server sky data is validated
// before it enters the renderer resource graph.
function classicWorldDecodeTga(data, path)
  // Validate the fixed header, decode raw/RLE packets, then publish one
  // bottom-up RGBA image matching ref_gl's LoadTGA orientation.
  if typeof(data) != "bytes" or len(data) < 18 then
    return error(9766, "truncated sky TGA: " + path)
  end if
  imageType = data[2]; pixelBits = data[16]
  if data[1] != 0 or (imageType != 2 and imageType != 10) or
      (pixelBits != 24 and pixelBits != 32) then
    return error(9767, "unsupported sky TGA format: " + path)
  end if
  width = rclassicworldbyteio.u16(data, 12)
  height = rclassicworldbyteio.u16(data, 14)
  if width <= 0 or height <= 0 then return error(9768,
    "invalid sky TGA dimensions: " + path) end if
  bytesPerPixel = pixelBits >> 3
  source = 18 + data[0]
  rgba = bytes(width * height * 4)
  pixelIndex = 0
  while pixelIndex < width * height
    packetCount = 1; repeated = false
    if imageType == 10 then
      if source >= len(data) then return error(9766, "truncated sky TGA packet: " + path) end if
      packetHeader = data[source]; source = source + 1
      packetCount = (packetHeader & 127) + 1
      repeated = (packetHeader & 128) != 0
    end if
    blue = 0; green = 0; red = 0; alpha = 255
    packetIndex = 0
    while packetIndex < packetCount and pixelIndex < width * height
      if packetIndex == 0 or not repeated then
        if source + bytesPerPixel > len(data) then return error(9766,
          "truncated sky TGA pixels: " + path) end if
        blue = data[source]; green = data[source + 1]; red = data[source + 2]
        alpha = 255
        if bytesPerPixel == 4 then alpha = data[source + 3] end if
        source = source + bytesPerPixel
      end if
      sourceRow = rclassicworldbyteio.truncInt(pixelIndex / width)
      column = pixelIndex - sourceRow * width
      destinationRow = height - 1 - sourceRow
      destination = (destinationRow * width + column) * 4
      rgba[destination] = red; rgba[destination + 1] = green
      rgba[destination + 2] = blue; rgba[destination + 3] = alpha
      pixelIndex = pixelIndex + 1; packetIndex = packetIndex + 1
    end while
  end while
  return ClassicTgaImage(width, height, rgba)
end function

// Return the classic world sky texture value.
function classicWorldSkyTexture(loadFile, skyName, suffix, generation, fallbackPalette)
  path = "env/" + skyName + suffix + ".pcx"
  data = loadFile(path)
  if typeof(data) != "bytes" then
    path = "env/" + skyName + suffix + ".tga"
    data = loadFile(path)
    if typeof(data) != "bytes" then return void end if
    tga = classicWorldDecodeTga(data, path)
    return rclassictypes.ClassicTexture(0, "@sky/" + skyName + suffix,
      tga.width, tga.height, tga.rgba, "sky", generation, false, false)
  end if
  pcx = fpcx.parse(data)
  palette = pcx.palette
  if len(palette) != 768 then palette = fallbackPalette end if
  rgba = rclassicmaterials.rgbaFromIndexed(pcx.pixels, palette)
  if len(rgba) != pcx.width * pcx.height * 4 then return error(9746, "invalid sky PCX palette: " + path) end if
  return rclassictypes.ClassicTexture(0, "@sky/" + skyName + suffix, pcx.width, pcx.height, rgba, "sky", generation, false, false)
end function

// Configure sky.
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

// Build model draws.
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

// Find brush model.
function findBrushModel(world, modelIndex)
  for each brushModel in world.brushModels
    if brushModel.modelIndex == modelIndex then return brushModel end if
  end for
  return void
end function

// Build state.
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
    brushModels[modelIndex - 1] = rclassictypes.ClassicBrushModel(modelIndex,
      map.models[modelIndex], brushResult[1], array(len(brushResult[1])),
      rclassicspecial.createClassicSpecialPassScratch(len(brushResult[1])))
    modelIndex = modelIndex + 1
  end while
  lightmapAtlases = packLightmapAtlases(draws, brushModels, generation,
    len(scene.surfaces))
  for each lightmapAtlas in lightmapAtlases
    textures = textures + [lightmapAtlas]
  end for
  skyBox = rclassictypes.ClassicSkyBox("", 0.0, ft.Vec3(0.0, 0.0, 1.0), array(0), false)
  pointStackSize = len(map.nodes) + 1
  return rclassictypes.ClassicWorld(map.name, generation, map, scene, textures,
    draws, brushModels, skyBox, modulate, false,
    array(pointStackSize, 0), array(pointStackSize, 0),
    array(pointStackSize, 0.0), array(pointStackSize, 0.0),
    array(pointStackSize, 0.0), array(pointStackSize, 0.0),
    array(pointStackSize, 0.0), array(pointStackSize, 0.0),
    rclassicspecial.createClassicSpecialPassScratch(len(draws)),
    array(len(map.faces), void), bytes(len(map.faces)), array(len(draws)))
end function

// Return the triangle count.
function triangleCount(world)
  total = 0
  for each draw in world.draws
    total = total + draw.triangleCount
  end for
  return total
end function

// Return the plan signature value.
function planSignature(world)
  // Compact deterministic replay signature used by tests and diagnostics.
  result = world.name + ":" + len(world.draws) + ":" + triangleCount(world)
  for each draw in world.draws
    result = result + ":" + draw.surface.index + "/" + draw.baseTexture.name + "/" + draw.surface.lightWidth + "x" + draw.surface.lightHeight
  end for
  return result
end function
