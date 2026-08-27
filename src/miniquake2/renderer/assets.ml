/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Runtime asset registry joining refimport FS callbacks to strict parsers. */
package miniquake2.renderer.assets

import miniquake2.qcommon.text as qtext
import miniquake2.format.bsp as fbsp
import miniquake2.format.md2 as fmd2
import miniquake2.format.sprite as fsprite
import miniquake2.format.pcx as fpcx
import miniquake2.format.wal as fwal
import miniquake2.renderer.geometry as rgeom
import miniquake2.renderer.types as rt

// Store model asset data.
struct ModelAsset
  handle
  kind
  source
  mesh
  skins
  frameBounds
end struct

// Store picture asset data.
struct PictureAsset
  handle
  kind
  source
  width
  height
  textureId
  usage
end struct

// Store asset registry data.
struct AssetRegistry
  generation
  nextId
  models
  pictures
  resourcesById
end struct

const MAX_REGISTERED_RESOURCES = 4096

// Create state.
function create()
  return AssetRegistry(1, 1, [], [], array(MAX_REGISTERED_RESOURCES))
end function

// Return the ends with value.
function endsWith(value, suffix)
  left = bytes(qtext.lower(value))
  right = bytes(qtext.lower(suffix))
  if len(right) > len(left) then return false end if
  offset = len(left) - len(right)
  index = 0
  while index < len(right)
    if left[offset + index] != right[index] then return false end if
    index = index + 1
  end while
  return true
end function

// Handle next.
function nextHandle(registry, kind, name)
  handle = rt.ResourceHandle(kind, registry.nextId, name, registry.generation)
  registry.nextId = registry.nextId + 1
  return handle
end function

// Find model.
function findModel(registry, name)
  for each asset in registry.models
    if qtext.equalInsensitive(asset.handle.name, name) then return asset end if
  end for
  return void
end function

// Find picture.
function findPicture(registry, name)
  for each asset in registry.pictures
    if qtext.equalInsensitive(asset.handle.name, name) then return asset end if
  end for
  return void
end function

// Return the store resource value.
function storeResource(registry, asset)
  id = asset.handle.id
  if id <= 0 or id >= len(registry.resourcesById) then
    return error(9661, "renderer resource table exhausted")
  end if
  registry.resourcesById[id] = asset
  return asset
end function

// Find model by handle.
function inline findModelByHandle(registry, handle)
  if typeof(handle) != "struct" or handle.kind != "model" or handle.generation != registry.generation then return void end if
  if handle.id <= 0 or handle.id >= len(registry.resourcesById) then return void end if
  asset = registry.resourcesById[handle.id]
  if asset is void or asset.handle.kind != "model" or
      asset.handle.generation != handle.generation then return void end if
  return asset
end function

// Handle model for.
function modelForHandle(registry, handle)
  asset = findModelByHandle(registry, handle)
  if asset is void then return error(9653, "renderer model handle is stale or unknown") end if
  return asset
end function

// Find picture by handle.
function inline findPictureByHandle(registry, handle)
  if typeof(handle) != "struct" or handle.kind != "pic" or handle.generation != registry.generation then return void end if
  if handle.id <= 0 or handle.id >= len(registry.resourcesById) then return void end if
  asset = registry.resourcesById[handle.id]
  if asset is void or asset.handle.kind != "pic" or
      asset.handle.generation != handle.generation then return void end if
  return asset
end function

// Handle picture for.
function pictureForHandle(registry, handle)
  asset = findPictureByHandle(registry, handle)
  if asset is void then return error(9654, "renderer picture handle is stale or unknown") end if
  return asset
end function

// Register md 2 skins.
function registerMd2Skins(registry, imports, model)
  skins = array(len(model.skins))
  skinIndex = 0
  while skinIndex < len(model.skins)
    if model.skins[skinIndex] == "" then return error(9655, "MD2 contains an empty skin name") end if
    skins[skinIndex] = registerPicture(registry, imports, model.skins[skinIndex])
    if skins[skinIndex].kind != "pcx" then return error(9656, "MD2 skin is not PCX: " + model.skins[skinIndex]) end if
    skins[skinIndex].usage = "skin"
    skinIndex = skinIndex + 1
  end while
  return skins
end function

// Register sprite frames.
function registerSpriteFrames(registry, imports, model)
  frames = array(len(model.frames))
  frameIndex = 0
  while frameIndex < len(model.frames)
    imageName = model.frames[frameIndex].imageName
    if imageName == "" then return error(9659, "SP2 contains an empty frame image name") end if
    frames[frameIndex] = registerPicture(registry, imports, imageName)
    if frames[frameIndex].kind != "pcx" then return error(9660, "SP2 frame is not PCX: " + imageName) end if
    frames[frameIndex].usage = "sprite"
    frameIndex = frameIndex + 1
  end while
  return frames
end function

// Return the md 2 frame bounds.
function md2FrameBounds(model)
  bounds = array(len(model.frames))
  frameIndex = 0
  while frameIndex < len(model.frames)
    bounds[frameIndex] = rgeom.md2FrameBounds(model, frameIndex, frameIndex, 0.0)
    frameIndex = frameIndex + 1
  end while
  return bounds
end function

// Return the adopt bsp model value.
function adoptBspModel(registry, map, name)
  existing = findModel(registry, name)
  if existing is not void then
    if existing.kind != "bsp" then return error(9657, "renderer model name already belongs to non-BSP asset") end if
    return existing
  end if
  if typeof(map) != "struct" or len(map.models) == 0 then return error(9658, "adopted BSP map has no world model") end if
  // ClassicWorld owns the world polygons, so do not duplicate them as an
  // expanded debug mesh. Inline *n models remain lazily expandable below.
  asset = ModelAsset(nextHandle(registry, "model", name), "bsp", map, void,
    array(0), array(0))
  registry.models = registry.models + [asset]
  storeResource(registry, asset)
  return asset
end function

// Load bytes.
function loadBytes(imports, name)
  data = imports.fsLoadFile(name)
  if typeof(data) != "bytes" then return error(9650, "renderer file not found: " + name) end if
  return data
end function

// The public Renderer API uses extension-less picture names (for example
// `i_health` and `m_main_logo`).  Files on disk retain the classic
// `pics/<name>.pcx` layout.  Model skins and WAL materials already arrive as
// complete qpaths and must remain unchanged.
function pictureFileName(name)
  if endsWith(name, ".pcx") or endsWith(name, ".wal") then return name end if
  return "pics/" + name + ".pcx"
end function

// Register model.
function registerModel(registry, imports, name)
  // Keep register model phases explicit: validate inputs, update owned state, then publish the result.
  existing = findModel(registry, name)
  if existing is not void then return existing end if
  asset = void
  if len(bytes(name)) > 1 and bytes(name)[0] == 42 then
    world = void
    for each candidate in registry.models
      if candidate.kind == "bsp" then world = candidate end if
    end for
    if world is void then return error(9651, "inline BSP model registered before world") end if
    indexText = decode(slice(bytes(name), 1, len(bytes(name)) - 1))
    modelIndex = toNumber(indexText)
    mesh = rgeom.bspModelMesh(world.source, modelIndex)
    asset = ModelAsset(nextHandle(registry, "model", name), "bsp-inline",
      world.source, mesh, array(0), array(0))
  else
    data = loadBytes(imports, name)
    if endsWith(name, ".bsp") then
      source = fbsp.parse(data, name)
      asset = ModelAsset(nextHandle(registry, "model", name), "bsp", source,
        rgeom.bspModelMesh(source, 0), array(0), array(0))
    else if endsWith(name, ".md2") then
      source = fmd2.parse(data, name)
      skins = registerMd2Skins(registry, imports, source)
      handle = nextHandle(registry, "model", name)
      initialMesh = rgeom.md2FrameMesh(source, 0, 0, 0.0)
      frameBounds = md2FrameBounds(source)
      asset = ModelAsset(handle, "md2", source, initialMesh, skins, frameBounds)
    else if endsWith(name, ".sp2") then
      source = fsprite.parse(data, name)
      frames = registerSpriteFrames(registry, imports, source)
      asset = ModelAsset(nextHandle(registry, "model", name), "sprite", source,
        void, frames, array(0))
    else
      return error(9652, "unsupported renderer model format: " + name)
    end if
  end if
  registry.models = registry.models + [asset]
  storeResource(registry, asset)
  return asset
end function

// Register picture.
function registerPicture(registry, imports, name)
  existing = findPicture(registry, name)
  if existing is not void then return existing end if
  fileName = pictureFileName(name)
  data = loadBytes(imports, fileName)
  asset = void
  if endsWith(fileName, ".wal") then
    source = fwal.parse(data)
    asset = PictureAsset(nextHandle(registry, "pic", name), "wal", source, source.width, source.height, 0, "picture")
  else
    source = fpcx.parse(data)
    asset = PictureAsset(nextHandle(registry, "pic", name), "pcx", source, source.width, source.height, 0, "picture")
  end if
  registry.pictures = registry.pictures + [asset]
  storeResource(registry, asset)
  return asset
end function

// Begin registration.
function beginRegistration(registry)
  registry.generation = registry.generation + 1
  registry.nextId = 1
  registry.models = []
  registry.pictures = []
  registry.resourcesById = array(MAX_REGISTERED_RESOURCES)
end function
