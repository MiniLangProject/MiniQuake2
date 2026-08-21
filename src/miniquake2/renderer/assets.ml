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

struct ModelAsset
  handle
  kind
  source
  mesh
  skins
  frameBounds
end struct

struct PictureAsset
  handle
  kind
  source
  width
  height
  textureId
end struct

struct AssetRegistry
  generation
  nextId
  models
  pictures
end struct

function create()
  return AssetRegistry(1, 1, [], [])
end function

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

function nextHandle(registry, kind, name)
  handle = rt.ResourceHandle(kind, registry.nextId, name, registry.generation)
  registry.nextId = registry.nextId + 1
  return handle
end function

function findModel(registry, name)
  for each asset in registry.models
    if qtext.equalInsensitive(asset.handle.name, name) then return asset end if
  end for
  return void
end function

function findPicture(registry, name)
  for each asset in registry.pictures
    if qtext.equalInsensitive(asset.handle.name, name) then return asset end if
  end for
  return void
end function

function findModelByHandle(registry, handle)
  if typeof(handle) != "struct" or handle.kind != "model" or handle.generation != registry.generation then return void end if
  for each asset in registry.models
    if asset.handle.id == handle.id and asset.handle.generation == handle.generation then return asset end if
  end for
  return void
end function

function modelForHandle(registry, handle)
  asset = findModelByHandle(registry, handle)
  if asset is void then return error(9653, "renderer model handle is stale or unknown") end if
  return asset
end function

function findPictureByHandle(registry, handle)
  if typeof(handle) != "struct" or handle.kind != "pic" or handle.generation != registry.generation then return void end if
  for each asset in registry.pictures
    if asset.handle.id == handle.id and asset.handle.generation == handle.generation then return asset end if
  end for
  return void
end function

function pictureForHandle(registry, handle)
  asset = findPictureByHandle(registry, handle)
  if asset is void then return error(9654, "renderer picture handle is stale or unknown") end if
  return asset
end function

function registerMd2Skins(registry, imports, model)
  skins = array(len(model.skins))
  skinIndex = 0
  while skinIndex < len(model.skins)
    if model.skins[skinIndex] == "" then return error(9655, "MD2 contains an empty skin name") end if
    skins[skinIndex] = registerPicture(registry, imports, model.skins[skinIndex])
    if skins[skinIndex].kind != "pcx" then return error(9656, "MD2 skin is not PCX: " + model.skins[skinIndex]) end if
    skinIndex = skinIndex + 1
  end while
  return skins
end function

function md2FrameBounds(model)
  bounds = array(len(model.frames))
  frameIndex = 0
  while frameIndex < len(model.frames)
    bounds[frameIndex] = rgeom.md2FrameBounds(model, frameIndex, frameIndex, 0.0)
    frameIndex = frameIndex + 1
  end while
  return bounds
end function

function adoptBspModel(registry, map, name)
  existing = findModel(registry, name)
  if existing is not void then
    if existing.kind != "bsp" then return error(9657, "renderer model name already belongs to non-BSP asset") end if
    return existing
  end if
  if typeof(map) != "struct" or len(map.models) == 0 then return error(9658, "adopted BSP map has no world model") end if
  // ClassicWorld owns the world polygons, so do not duplicate them as an
  // expanded debug mesh. Inline *n models remain lazily expandable below.
  asset = ModelAsset(nextHandle(registry, "model", name), "bsp", map, void, array(0), array(0))
  registry.models = registry.models + [asset]
  return asset
end function

function loadBytes(imports, name)
  data = imports.fsLoadFile(name)
  if typeof(data) != "bytes" then return error(9650, "renderer file not found: " + name) end if
  return data
end function

function registerModel(registry, imports, name)
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
    asset = ModelAsset(nextHandle(registry, "model", name), "bsp-inline", world.source, mesh, array(0), array(0))
  else
    data = loadBytes(imports, name)
    if endsWith(name, ".bsp") then
      source = fbsp.parse(data, name)
      asset = ModelAsset(nextHandle(registry, "model", name), "bsp", source, rgeom.bspModelMesh(source, 0), array(0), array(0))
    else if endsWith(name, ".md2") then
      source = fmd2.parse(data, name)
      skins = registerMd2Skins(registry, imports, source)
      handle = nextHandle(registry, "model", name)
      initialMesh = rgeom.md2FrameMesh(source, 0, 0, 0.0)
      frameBounds = md2FrameBounds(source)
      asset = ModelAsset(handle, "md2", source, initialMesh, skins, frameBounds)
    else if endsWith(name, ".sp2") then
      source = fsprite.parse(data, name)
      asset = ModelAsset(nextHandle(registry, "model", name), "sprite", source, void, array(0), array(0))
    else
      return error(9652, "unsupported renderer model format: " + name)
    end if
  end if
  registry.models = registry.models + [asset]
  return asset
end function

function registerPicture(registry, imports, name)
  existing = findPicture(registry, name)
  if existing is not void then return existing end if
  data = loadBytes(imports, name)
  asset = void
  if endsWith(name, ".wal") then
    source = fwal.parse(data)
    asset = PictureAsset(nextHandle(registry, "pic", name), "wal", source, source.width, source.height, 0)
  else
    source = fpcx.parse(data)
    asset = PictureAsset(nextHandle(registry, "pic", name), "pcx", source, source.width, source.height, 0)
  end if
  registry.pictures = registry.pictures + [asset]
  return asset
end function

function beginRegistration(registry)
  registry.generation = registry.generation + 1
  registry.models = []
  registry.pictures = []
end function
