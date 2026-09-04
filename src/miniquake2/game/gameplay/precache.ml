//! Provides miniquake2 game gameplay precache facilities for this project.

/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Function-table driven implementation of g_items.c PrecacheItem. */
package miniquake2.game.gameplay.precache

import miniquake2.game.gameplay.types as gptypes
import miniquake2.qcommon.constants as qconstants
import miniquake2.qcommon.text as qtext

/// Finds by pickup name used by the miniquake2 game gameplay precache module.
/// @param registry registry value consumed by this operation.
/// @param pickupName pickupName value consumed by this operation.
function findByPickupName(registry, pickupName)
  if typeof(pickupName) != "string" then return error(9396, "precache pickup name is not text") end if
  for each item in registry.items
    gpprecachePickupHolder = item.pickupName
    if typeof(gpprecachePickupHolder) != "string" then return error(9397, "precache registry pickup name is not text") end if
    if qtext.equalInsensitive(gpprecachePickupHolder, pickupName) then return item end if
  end for
  return void
end function

/// Require import function.
/// @param imports imports value consumed by this operation.
/// @param fieldValue fieldValue value consumed by this operation.
/// @param fieldName fieldName value consumed by this operation.
function requireImportFunction(imports, fieldValue, fieldName)
  if typeof(imports) != "struct" or typeof(fieldValue) != "function" then return error(9380, "PrecacheItem: missing GameImport." + fieldName) end if
  return true
end function

/// Cache model.
/// @param result Result object populated or inspected by the operation.
/// @param imports imports value consumed by this operation.
/// @param path Path of the file or directory used by the operation.
function cacheModel(result, imports, path)
  if path == "" then return true end if
  requireImportFunction(imports, imports.modelIndex, "modelIndex")
  imports.modelIndex(path)
  result.models = result.models + [path]
  return true
end function

/// Cache sound.
/// @param result Result object populated or inspected by the operation.
/// @param imports imports value consumed by this operation.
/// @param path Path of the file or directory used by the operation.
function cacheSound(result, imports, path)
  if path == "" then return true end if
  requireImportFunction(imports, imports.soundIndex, "soundIndex")
  imports.soundIndex(path)
  result.sounds = result.sounds + [path]
  return true
end function

/// Cache image.
/// @param result Result object populated or inspected by the operation.
/// @param imports imports value consumed by this operation.
/// @param path Path of the file or directory used by the operation.
function cacheImage(result, imports, path)
  if path == "" then return true end if
  requireImportFunction(imports, imports.imageIndex, "imageIndex")
  imports.imageIndex(path)
  result.images = result.images + [path]
  return true
end function

/// Cache tokens.
/// @param result Result object populated or inspected by the operation.
/// @param imports imports value consumed by this operation.
/// @param value Value consumed or transformed by the operation.
/// @param itemName itemName value consumed by this operation.
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

/// Populate the precache destination.
/// @param registry registry value consumed by this operation.
/// @param item item value consumed by this operation.
/// @param imports imports value consumed by this operation.
/// @param result Result object populated or inspected by the operation.
/// @param depth depth value consumed by this operation.
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

/// Return the precache item value.
/// @param registry registry value consumed by this operation.
/// @param item item value consumed by this operation.
/// @param imports imports value consumed by this operation.
function PrecacheItem(registry, item, imports)
  result = gptypes.PrecacheResult([], [], [])
  precacheInto(registry, item, imports, result, 0)
  return result
end function
