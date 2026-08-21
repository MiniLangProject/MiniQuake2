/* Function-table driven implementation of g_items.c PrecacheItem. */
package miniquake2.game.gameplay.precache

import miniquake2.game.gameplay.types as gptypes
import miniquake2.qcommon.constants as qconstants
import miniquake2.qcommon.text as qtext

function findByPickupName(registry, pickupName)
  if typeof(pickupName) != "string" then return error(9396, "precache pickup name is not text") end if
  for each item in registry.items
    gpprecachePickupHolder = item.pickupName
    if typeof(gpprecachePickupHolder) != "string" then return error(9397, "precache registry pickup name is not text") end if
    if qtext.equalInsensitive(gpprecachePickupHolder, pickupName) then return item end if
  end for
  return void
end function

function requireImportFunction(imports, fieldValue, fieldName)
  if typeof(imports) != "struct" or typeof(fieldValue) != "function" then return error(9380, "PrecacheItem: missing GameImport." + fieldName) end if
  return true
end function

function cacheModel(result, imports, path)
  if path == "" then return true end if
  requireImportFunction(imports, imports.modelIndex, "modelIndex")
  imports.modelIndex(path)
  result.models = result.models + [path]
  return true
end function

function cacheSound(result, imports, path)
  if path == "" then return true end if
  requireImportFunction(imports, imports.soundIndex, "soundIndex")
  imports.soundIndex(path)
  result.sounds = result.sounds + [path]
  return true
end function

function cacheImage(result, imports, path)
  if path == "" then return true end if
  requireImportFunction(imports, imports.imageIndex, "imageIndex")
  imports.imageIndex(path)
  result.images = result.images + [path]
  return true
end function

function cacheTokens(result, imports, value, itemName)
  source = bytes(value)
  index = 0
  while index < len(source)
    while index < len(source) and source[index] <= 32
      index = index + 1
    end while
    if index >= len(source) then break end if
    start = index
    while index < len(source) and source[index] > 32
      index = index + 1
    end while
    count = index - start
    if count < 5 or count >= qconstants.MAX_QPATH then return error(9381, "PrecacheItem: " + itemName + " has bad precache token") end if
    path = decode(slice(source, start, count))
    extension = decode(slice(source, index - 3, 3))
    if extension == "md2" or extension == "sp2" then cacheModel(result, imports, path)
    else if extension == "wav" then cacheSound(result, imports, path)
    else if extension == "pcx" then cacheImage(result, imports, path)
    end if
  end while
  return true
end function

function precacheInto(registry, item, imports, result, depth)
  if item is void then return true end if
  if depth > len(registry.items) then return error(9382, "PrecacheItem: cyclic ammo dependency") end if
  cacheSound(result, imports, item.pickupSound)
  cacheModel(result, imports, item.worldModel)
  cacheModel(result, imports, item.viewModel)
  cacheImage(result, imports, item.icon)
  if item.ammo != "" then
    ammo = findByPickupName(registry, item.ammo)
    if ammo is void then return error(9383, "PrecacheItem: missing ammo item " + item.ammo) end if
    if ammo.index != item.index then precacheInto(registry, ammo, imports, result, depth + 1) end if
  end if
  if item.precaches != "" then cacheTokens(result, imports, item.precaches, item.className) end if
  return true
end function

function PrecacheItem(registry, item, imports)
  result = gptypes.PrecacheResult([], [], [])
  precacheInto(registry, item, imports, result, 0)
  return result
end function
