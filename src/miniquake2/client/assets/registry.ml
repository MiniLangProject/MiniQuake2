/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Safe Quake-II client asset registry with explicit map generations. */
package miniquake2.client.assets.registry

import miniquake2.qcommon.constants as carqc
import miniquake2.qcommon.text as cartext
import miniquake2.client.assets.types as cartypes

const MAX_NAMED_ASSETS = 256
const MAX_MISSING_ASSETS = 512
const MAX_CLIENT_WEAPON_MODELS = 20

// The product has one active Quake client. A package-owned mutable holder is
// used instead of nested functions capturing a factory parameter; the latter
// loses its environment in some full-program MiniLang link graphs.
struct ClientAssetBindingSlot
  registry
end struct

clientAssetBindingSlot = ClientAssetBindingSlot(void)

// Report whether ignore missing.
function ignoreMissing(value)
  return true
end function

// Return the callbacks value.
function callbacks(loadModel, loadSkin, loadSound, onMissing)
  if typeof(loadModel) != "function" or typeof(loadSkin) != "function" or
      typeof(loadSound) != "function" or
      typeof(onMissing) != "function" then
    return error(8400, "client asset loaders must be function values")
  end if
  return cartypes.LoaderCallbacks(loadModel, loadSkin, loadSound, onMissing)
end function

// Create state.
function create(loaders)
  if loaders is void then return error(8401, "client asset loader table is missing") end if
  return cartypes.Registry(loaders, 0, "", array(carqc.MAX_MODELS, void),
    array(carqc.MAX_SOUNDS, void), [], [], [], array(carqc.MAX_CLIENTS, void),
    array(carqc.MAX_CLIENTS, ""), void, array(MAX_CLIENT_WEAPON_MODELS, ""), 0, [])
end function

// Create lenient.
function createLenient(loadModel, loadSkin, loadSound)
  return create(callbacks(loadModel, loadSkin, loadSound, ignoreMissing))
end function

// Report whether contains traversal.
function containsTraversal(value)
  source = bytes(value)
  index = 0
  while index + 1 < len(source)
    if source[index] == 46 and source[index + 1] == 46 then return true end if
    index = index + 1
  end while
  return false
end function

// Return the safe regular name.
function safeRegularName(name)
  if typeof(name) != "string" or name == "" then return false end if
  source = bytes(name)
  if len(source) >= carqc.MAX_QPATH then return false end if
  if source[0] == 47 or source[0] == 92 or containsTraversal(name) then return false end if
  for each character in source
    if character < 32 or character == 58 or character == 92 then return false end if
  end for
  return true
end function

// Return the inline model name.
function inlineModelName(name)
  source = bytes(name)
  if len(source) < 2 or source[0] != 42 then return false end if
  index = 1
  value = 0
  while index < len(source)
    if source[index] < 48 or source[index] > 57 then return false end if
    value = value * 10 + source[index] - 48
    if value > 1023 then return false end if
    index = index + 1
  end while
  return value > 0
end function

// Return the safe model name.
function safeModelName(name)
  if typeof(name) != "string" or name == "" then return false end if
  if bytes(name)[0] == 42 then return inlineModelName(name) end if
  return safeRegularName(name)
end function

// Return the safe sound name.
function safeSoundName(name)
  if typeof(name) != "string" or name == "" then return false end if
  if bytes(name)[0] == 42 then return false end if
  return safeRegularName(name)
end function

// Report whether valid model.
function validModel(value)
  if typeof(value) != "struct" then return false end if
  return value.kind == "model" and typeof(value.id) == "int" and value.id > 0 and
    typeof(value.name) == "string" and typeof(value.generation) == "int"
end function

// Report whether valid sound.
function validSound(value)
  if typeof(value) != "struct" or typeof(value.name) != "string" or
      typeof(value.sampleRate) != "int" or value.sampleRate < 1 or
      typeof(value.channels) != "int" or (value.channels != 1 and value.channels != 2) or
      typeof(value.width) != "int" or (value.width != 1 and value.width != 2) or
      typeof(value.sampleCount) != "int" or value.sampleCount < 0 or
      typeof(value.loopStart) != "int" or typeof(value.pcm) != "bytes" then return false end if
  if value.loopStart >= value.sampleCount then return false end if
  return len(value.pcm) == value.sampleCount * value.channels * value.width
end function

// Report whether valid skin.
function validSkin(value)
  if typeof(value) != "struct" then return false end if
  return (value.kind == "skin" or value.kind == "pic") and
    typeof(value.id) == "int" and value.id > 0 and
    typeof(value.name) == "string" and typeof(value.generation) == "int"
end function

// Append bounded.
function appendBounded(values, value, maximum)
  output = []
  start = 0
  if len(values) >= maximum then start = len(values) - maximum + 1 end if
  index = start
  while index < len(values)
    output = output + [values[index]]
    index = index + 1
  end while
  return output + [value]
end function

// Report whether note missing.
function noteMissing(state, kind, index, name, reason)
  missing = cartypes.MissingAsset(kind, index, name, state.generation, reason)
  state.missing = appendBounded(state.missing, missing, MAX_MISSING_ASSETS)
  ignored = try(state.loaders.onMissing(missing))
  return cartypes.AssetEntry(kind, index, name, void, state.generation, false, reason)
end function

// Report whether cached.
function cached(values, name, generation)
  key = cartext.lower(name)
  for each entry in values
    if entry.generation == generation and cartext.lower(entry.name) == key then return entry end if
  end for
  return void
end function

// Return the indexed value.
function indexed(entry, index, name)
  return cartypes.AssetEntry(entry.kind, index, name, entry.value,
    entry.generation, entry.available, entry.reason)
end function

// Cache named.
function cacheNamed(state, kind, entry)
  values = state.namedModels
  if kind == "sound" then values = state.namedSounds end if
  if kind == "skin" then values = state.namedSkins end if
  if len(values) >= MAX_NAMED_ASSETS then return false end if
  values = values + [entry]
  if kind == "model" then state.namedModels = values
  else if kind == "skin" then state.namedSkins = values
  else state.namedSounds = values
  end if
  return true
end function

// Report whether missing named.
function missingNamed(state, kind, index, name, reason)
  entry = noteMissing(state, kind, index, name, reason)
  ignored = cacheNamed(state, kind, indexed(entry, -1, name))
  return entry
end function

// Load model asset.
function loadModelAsset(state, index, name)
  if typeof(name) != "string" or name == "" then
    return noteMissing(state, "model", index, "", "unsafe-name")
  end if
  existing = cached(state.namedModels, name, state.generation)
  if existing is not void then return indexed(existing, index, name) end if
  if not safeModelName(name) then return noteMissing(state, "model", index, name, "unsafe-name") end if
  loaded = try(state.loaders.loadModel(name))
  if loaded is error then return missingNamed(state, "model", index, name, "loader-error") end if
  if loaded is void then return missingNamed(state, "model", index, name, "not-found") end if
  if not validModel(loaded) then return missingNamed(state, "model", index, name, "invalid-loader-result") end if
  entry = cartypes.AssetEntry("model", index, name, loaded, state.generation, true, "")
  ignored = cacheNamed(state, "model", indexed(entry, -1, name))
  return entry
end function

// Load sound asset.
function loadSoundAsset(state, index, name)
  if typeof(name) != "string" or name == "" then
    return noteMissing(state, "sound", index, "", "unsafe-name")
  end if
  existing = cached(state.namedSounds, name, state.generation)
  if existing is not void then return indexed(existing, index, name) end if
  // Protocol configstrings beginning with '*' are player-relative sounds.
  // The full stock client chooses the emitting player's model at playback
  // and falls back to male when that model-specific file is unavailable.
  // The product currently exposes one male player model, so materialize that
  // mandatory fallback instead of leaving every pain/fall/death sound silent.
  if bytes(name)[0] == 42 then
    fallbackName = "player/male/" + textSlice(name, 1,
      len(bytes(name)) - 1)
    fallback = loadSoundAsset(state, -1, fallbackName)
    if fallback.available then
      return cartypes.AssetEntry("sound", index, name, fallback.value,
        state.generation, true, "player-sound-male-fallback")
    end if
    return noteMissing(state, "sound", index, name,
      "player-sound-fallback-missing")
  end if
  if not safeSoundName(name) then
    return noteMissing(state, "sound", index, name, "unsafe-name")
  end if
  loaded = try(state.loaders.loadSound(name))
  if loaded is error then return missingNamed(state, "sound", index, name, "loader-error") end if
  if loaded is void then return missingNamed(state, "sound", index, name, "not-found") end if
  if not validSound(loaded) then return missingNamed(state, "sound", index, name, "invalid-loader-result") end if
  entry = cartypes.AssetEntry("sound", index, name, loaded, state.generation, true, "")
  ignored = cacheNamed(state, "sound", indexed(entry, -1, name))
  return entry
end function

// S_RegisterSexedSound probes a model-specific file without treating absence
// as a missing precache asset: failure is the normal path to the male alias.
function loadOptionalSoundAsset(state, name)
  existing = cached(state.namedSounds, name, state.generation)
  if existing is not void then return existing end if
  if not safeSoundName(name) then
    return cartypes.AssetEntry("sound", -1, name, void, state.generation,
      false, "unsafe-name")
  end if
  loaded = try(state.loaders.loadSound(name))
  available = loaded is not error and loaded is not void and validSound(loaded)
  reason = ""
  if not available then reason = "optional-not-found"; loaded = void end if
  entry = cartypes.AssetEntry("sound", -1, name, loaded, state.generation,
    available, reason)
  ignored = cacheNamed(state, "sound", entry)
  return entry
end function

// Load skin asset.
function loadSkinAsset(state, name)
  if typeof(name) != "string" or name == "" or not safeRegularName(name) then
    return noteMissing(state, "skin", -1, name, "unsafe-name")
  end if
  existing = cached(state.namedSkins, name, state.generation)
  if existing is not void then return existing end if
  loaded = try(state.loaders.loadSkin(name))
  if loaded is error then return missingNamed(state, "skin", -1, name, "loader-error") end if
  if loaded is void then return missingNamed(state, "skin", -1, name, "not-found") end if
  if not validSkin(loaded) then return missingNamed(state, "skin", -1, name,
    "invalid-loader-result") end if
  entry = cartypes.AssetEntry("skin", -1, name, loaded, state.generation, true, "")
  ignored = cacheNamed(state, "skin", entry)
  return entry
end function

// CL_LoadClientinfo probes an authored player skin, optionally retries that
// skin on the male model, and finally uses male/grunt. The first two misses are
// normal fallback control flow and must not pollute the precache-missing list.
function loadOptionalSkinAsset(state, name)
  existing = cached(state.namedSkins, name, state.generation)
  if existing is not void then return existing end if
  if typeof(name) != "string" or name == "" or not safeRegularName(name) then
    return cartypes.AssetEntry("skin", -1, name, void, state.generation,
      false, "unsafe-name")
  end if
  loaded = try(state.loaders.loadSkin(name))
  available = loaded is not error and loaded is not void and validSkin(loaded)
  reason = ""
  if not available then reason = "optional-not-found"; loaded = void end if
  entry = cartypes.AssetEntry("skin", -1, name, loaded, state.generation,
    available, reason)
  ignored = cacheNamed(state, "skin", entry)
  return entry
end function

// Slice text.
function inline textSlice(value, start, count)
  if count <= 0 then return "" end if
  return decode(slice(bytes(value), start, count))
end function

// Return the client identity value.
function clientIdentity(value)
  name = "unnamed"; modelName = "male"; skinName = "grunt"
  if typeof(value) != "string" or value == "" then return [name, modelName, skinName] end if
  source = bytes(value)
  separator = -1; index = 0
  while index < len(source) and separator < 0
    if source[index] == 92 then separator = index end if
    index = index + 1
  end while
  if separator < 0 then return [name, modelName, skinName] end if
  if separator > 0 then name = textSlice(value, 0, separator) end if
  identityStart = separator + 1
  modelSeparator = -1; index = identityStart
  while index < len(source) and modelSeparator < 0
    if source[index] == 47 or source[index] == 92 then modelSeparator = index end if
    index = index + 1
  end while
  if modelSeparator <= identityStart or modelSeparator + 1 >= len(source) then
    return [name, modelName, skinName]
  end if
  candidateModel = textSlice(value, identityStart, modelSeparator - identityStart)
  candidateSkin = textSlice(value, modelSeparator + 1, len(source) - modelSeparator - 1)
  candidateModelPath = "players/" + candidateModel + "/tris.md2"
  candidateSkinPath = "players/" + candidateModel + "/" + candidateSkin + ".pcx"
  if safeRegularName(candidateModelPath) and safeRegularName(candidateSkinPath) then
    modelName = candidateModel; skinName = candidateSkin
  end if
  return [name, modelName, skinName]
end function

// Load client info.
function loadClientInfo(state, value)
  // Keep load client info phases explicit: validate inputs, update owned state, then publish the result.
  identity = clientIdentity(value)
  name = identity[0]; modelName = identity[1]; skinName = identity[2]
  modelEntry = loadModelAsset(state, -1, "players/" + modelName + "/tris.md2")
  if not modelEntry.available then
    modelName = "male"
    modelEntry = loadModelAsset(state, -1, "players/male/tris.md2")
  end if
  skinEntry = loadOptionalSkinAsset(state,
    "players/" + modelName + "/" + skinName + ".pcx")
  if not skinEntry.available and not cartext.equalInsensitive(modelName, "male") then
    modelName = "male"
    modelEntry = loadModelAsset(state, -1, "players/male/tris.md2")
    skinEntry = loadOptionalSkinAsset(state,
      "players/male/" + skinName + ".pcx")
  end if
  if not skinEntry.available then
    skinEntry = loadSkinAsset(state, "players/" + modelName + "/grunt.pcx")
  end if
  weapons = array(MAX_CLIENT_WEAPON_MODELS, void)
  index = 0
  while index < state.weaponModelCount
    weaponEntry = loadModelAsset(state, -1,
      "players/" + modelName + "/" + state.weaponModelNames[index])
    if not weaponEntry.available and cartext.equalInsensitive(modelName, "cyborg") then
      weaponEntry = loadModelAsset(state, -1,
        "players/male/" + state.weaponModelNames[index])
    end if
    if weaponEntry.available then weapons[index] = weaponEntry.value end if
    index = index + 1
  end while
  available = modelEntry.available and skinEntry.available and weapons[0] is not void
  model = void; skin = void
  if modelEntry.available then model = modelEntry.value end if
  if skinEntry.available then skin = skinEntry.value end if
  return cartypes.ClientInfo(name, value, model, skin, weapons, available)
end function

// Refresh client infos.
function refreshClientInfos(state, configStrings)
  if typeof(configStrings) != "array" or len(configStrings) < carqc.MAX_CONFIGSTRINGS then
    return error(8406, "client info configstring table is truncated")
  end if
  index = 0; changed = 0
  while index < carqc.MAX_CLIENTS
    value = configStrings[carqc.CS_PLAYERSKINS + index]
    if typeof(value) != "string" then return error(8407, "player skin configstring is not text") end if
    if value != state.clientConfigStrings[index] then
      state.clientConfigStrings[index] = value
      if value == "" then state.clientInfos[index] = state.baseClientInfo
      else state.clientInfos[index] = loadClientInfo(state, value)
      end if
      changed = changed + 1
    end if
    index = index + 1
  end while
  return changed
end function

// Quake II may allocate model, sound and image configstrings after sign-on.
// Weapon projectiles are the common case: g_weapon.c calls modelindex when a
// shot is spawned, so an active client must register the new indexed asset
// without restarting the whole map registration generation.
function refreshConfigStrings(state, configStrings)
  // Keep refresh config strings phases explicit: validate inputs, update owned state, then publish the result.
  if typeof(configStrings) != "array" or len(configStrings) < carqc.MAX_CONFIGSTRINGS then
    return error(8403, "client asset configstring table is truncated")
  end if
  index = 1
  while index < carqc.MAX_MODELS
    if typeof(configStrings[carqc.CS_MODELS + index]) != "string" then
      return error(8404, "model configstring is not text")
    end if
    index = index + 1
  end while
  index = 1
  while index < carqc.MAX_SOUNDS
    if typeof(configStrings[carqc.CS_SOUNDS + index]) != "string" then
      return error(8405, "sound configstring is not text")
    end if
    index = index + 1
  end while
  index = 0
  while index < carqc.MAX_CLIENTS
    if typeof(configStrings[carqc.CS_PLAYERSKINS + index]) != "string" then
      return error(8407, "player skin configstring is not text")
    end if
    index = index + 1
  end while

  changed = 0
  weaponModelsChanged = false
  index = 1
  while index < carqc.MAX_MODELS
    name = configStrings[carqc.CS_MODELS + index]
    entry = state.modelEntries[index]
    if name == "" then
      if entry is not void and entry.name != "" then
        state.modelEntries[index] = cartypes.AssetEntry("model", index, "", void,
          state.generation, false, "cleared")
        changed = changed + 1
      end if
    else if bytes(name)[0] == 35 then
      if entry is not void and entry.name != "" then
        state.modelEntries[index] = cartypes.AssetEntry("model", index, "", void,
          state.generation, false, "deferred-player-weapon")
        changed = changed + 1
      end if
      if len(bytes(name)) > 1 then
        weaponName = textSlice(name, 1, len(bytes(name)) - 1)
        known = false; weaponIndex = 0
        while weaponIndex < state.weaponModelCount and not known
          if state.weaponModelNames[weaponIndex] == weaponName then known = true end if
          weaponIndex = weaponIndex + 1
        end while
        if not known and state.weaponModelCount < MAX_CLIENT_WEAPON_MODELS then
          state.weaponModelNames[state.weaponModelCount] = weaponName
          state.weaponModelCount = state.weaponModelCount + 1
          weaponModelsChanged = true
          changed = changed + 1
        end if
      end if
    else if entry is void or entry.name != name then
      state.modelEntries[index] = loadModelAsset(state, index, name)
      changed = changed + 1
    end if
    index = index + 1
  end while

  index = 1
  while index < carqc.MAX_SOUNDS
    name = configStrings[carqc.CS_SOUNDS + index]
    entry = state.soundEntries[index]
    if name == "" then
      if entry is not void and entry.name != "" then
        state.soundEntries[index] = cartypes.AssetEntry("sound", index, "", void,
          state.generation, false, "cleared")
        changed = changed + 1
      end if
    else if entry is void or entry.name != name then
      state.soundEntries[index] = loadSoundAsset(state, index, name)
      changed = changed + 1
    end if
    index = index + 1
  end while

  if weaponModelsChanged then
    state.baseClientInfo = loadClientInfo(state, "unnamed\\male/grunt")
    index = 0
    while index < carqc.MAX_CLIENTS
      value = configStrings[carqc.CS_PLAYERSKINS + index]
      state.clientConfigStrings[index] = value
      if value == "" then state.clientInfos[index] = state.baseClientInfo
      else state.clientInfos[index] = loadClientInfo(state, value)
      end if
      index = index + 1
    end while
  end if
  return changed + refreshClientInfos(state, configStrings)
end function

// Return the client info value.
function clientInfo(state, index)
  value = void
  if typeof(index) == "int" and index >= 0 and index < carqc.MAX_CLIENTS then
    value = state.clientInfos[index]
  end if
  if value is void or not value.available then value = state.baseClientInfo end if
  return value
end function

// Resolve player model.
function resolvePlayerModel(state, index)
  value = clientInfo(state, index)
  if value is void then return void end if
  return value.model
end function

// Resolve player skin.
function resolvePlayerSkin(state, index)
  value = clientInfo(state, index)
  if value is void then return void end if
  return value.skin
end function

// Resolve player weapon.
function resolvePlayerWeapon(state, index, weaponIndex)
  value = clientInfo(state, index)
  if value is void then return void end if
  if typeof(weaponIndex) != "int" or weaponIndex < 0 or
      weaponIndex >= state.weaponModelCount then weaponIndex = 0 end if
  weapon = value.weaponModels[weaponIndex]
  if weapon is void then weapon = value.weaponModels[0] end if
  if weapon is void and state.baseClientInfo is not void then
    weapon = state.baseClientInfo.weaponModels[0]
  end if
  return weapon
end function

// Reset state.
function reset(state, mapName)
  if typeof(mapName) != "string" or mapName == "" or len(bytes(mapName)) >= carqc.MAX_QPATH then
    return error(8402, "client asset map name is invalid")
  end if
  state.generation = state.generation + 1
  state.mapName = mapName
  state.modelEntries = array(carqc.MAX_MODELS, void)
  state.soundEntries = array(carqc.MAX_SOUNDS, void)
  state.namedModels = []
  state.namedSkins = []
  state.namedSounds = []
  state.clientInfos = array(carqc.MAX_CLIENTS, void)
  state.clientConfigStrings = array(carqc.MAX_CLIENTS, "")
  state.baseClientInfo = void
  state.weaponModelNames = array(MAX_CLIENT_WEAPON_MODELS, "")
  state.weaponModelCount = 0
  state.missing = []
  return state.generation
end function

// Register config strings.
function registerConfigStrings(state, configStrings, mapName)
  if typeof(configStrings) != "array" or len(configStrings) < carqc.MAX_CONFIGSTRINGS then
    return error(8403, "client asset configstring table is truncated")
  end if
  // Preflight the full table before changing generation or invoking loaders.
  index = 1
  while index < carqc.MAX_MODELS
    if typeof(configStrings[carqc.CS_MODELS + index]) != "string" then
      return error(8404, "model configstring is not text")
    end if
    index = index + 1
  end while
  index = 1
  while index < carqc.MAX_SOUNDS
    if typeof(configStrings[carqc.CS_SOUNDS + index]) != "string" then
      return error(8405, "sound configstring is not text")
    end if
    index = index + 1
  end while
  index = 0
  while index < carqc.MAX_CLIENTS
    if typeof(configStrings[carqc.CS_PLAYERSKINS + index]) != "string" then
      return error(8407, "player skin configstring is not text")
    end if
    index = index + 1
  end while
  reset(state, mapName)
  state.weaponModelNames[0] = "weapon.md2"
  state.weaponModelCount = 1
  index = 1
  while index < carqc.MAX_MODELS
    name = configStrings[carqc.CS_MODELS + index]
    if typeof(name) != "string" then return error(8404, "model configstring is not text") end if
    if name != "" then
      if bytes(name)[0] == 35 then
        if state.weaponModelCount < MAX_CLIENT_WEAPON_MODELS and len(bytes(name)) > 1 then
          state.weaponModelNames[state.weaponModelCount] = textSlice(name, 1,
            len(bytes(name)) - 1)
          state.weaponModelCount = state.weaponModelCount + 1
        end if
      else
        state.modelEntries[index] = loadModelAsset(state, index, name)
      end if
    end if
    index = index + 1
  end while
  index = 1
  while index < carqc.MAX_SOUNDS
    name = configStrings[carqc.CS_SOUNDS + index]
    if typeof(name) != "string" then return error(8405, "sound configstring is not text") end if
    if name != "" then state.soundEntries[index] = loadSoundAsset(state, index, name) end if
    index = index + 1
  end while
  state.baseClientInfo = loadClientInfo(state, "unnamed\\male/grunt")
  refreshClientInfos(state, configStrings)
  return state.generation
end function

// Resolve model index.
function resolveModelIndex(state, index)
  if typeof(index) != "int" or index < 0 or index >= carqc.MAX_MODELS then return void end if
  if index == 0 then return void end if
  entry = state.modelEntries[index]
  if entry is void or entry.generation != state.generation or not entry.available then return void end if
  return entry.value
end function

// Resolve sound index.
function resolveSoundIndex(state, index)
  if typeof(index) != "int" or index < 0 or index >= carqc.MAX_SOUNDS then return void end if
  if index == 0 then return void end if
  entry = state.soundEntries[index]
  if entry is void or entry.generation != state.generation or not entry.available then return void end if
  return entry.value
end function

// Resolve model name.
function resolveModelName(state, name)
  entry = loadModelAsset(state, -1, name)
  if not entry.available then return void end if
  return entry.value
end function

// Resolve skin name.
function resolveSkinName(state, name)
  entry = loadSkinAsset(state, name)
  if not entry.available then return void end if
  return entry.value
end function

// Resolve sound name.
function resolveSoundName(state, name)
  entry = loadSoundAsset(state, -1, name)
  if not entry.available then return void end if
  return entry.value
end function

// Resolve sound for entity.
function resolveSoundForEntity(state, entityNumber, soundIndex, soundName)
  name = soundName
  if name == "" and typeof(soundIndex) == "int" and soundIndex > 0 and
      soundIndex < carqc.MAX_SOUNDS then
    entry = state.soundEntries[soundIndex]
    if entry is not void and entry.generation == state.generation then
      name = entry.name
    end if
  end if
  if typeof(name) != "string" or name == "" or bytes(name)[0] != 42 then
    if soundName != "" then return resolveSoundName(state, soundName) end if
    return resolveSoundIndex(state, soundIndex)
  end if

  modelName = "male"
  slot = entityNumber - 1
  if typeof(entityNumber) == "int" and slot >= 0 and slot < carqc.MAX_CLIENTS then
    identity = clientIdentity(state.clientConfigStrings[slot])
    modelName = identity[1]
  end if
  base = textSlice(name, 1, len(bytes(name)) - 1)
  specific = loadOptionalSoundAsset(state,
    "players/" + modelName + "/" + base)
  if specific.available then return specific.value end if
  fallback = loadSoundAsset(state, -1, "player/male/" + base)
  if fallback.available then return fallback.value end if
  return void
end function

// Return the client asset bound model index.
function clientAssetBoundModelIndex(index)
  state = clientAssetBindingSlot.registry
  if state is void then return void end if
  return resolveModelIndex(state, index)
end function

// Return the client asset bound model name.
function clientAssetBoundModelName(name)
  state = clientAssetBindingSlot.registry
  if state is void then return void end if
  return resolveModelName(state, name)
end function

// Return the client asset bound skin name.
function clientAssetBoundSkinName(name)
  state = clientAssetBindingSlot.registry
  if state is void then return void end if
  return resolveSkinName(state, name)
end function

// Return the client asset bound sound index.
function clientAssetBoundSoundIndex(index)
  state = clientAssetBindingSlot.registry
  if state is void then return void end if
  return resolveSoundIndex(state, index)
end function

// Return the client asset bound sound name.
function clientAssetBoundSoundName(name)
  state = clientAssetBindingSlot.registry
  if state is void then return void end if
  return resolveSoundName(state, name)
end function

// Return the client asset bound sound entity value.
function clientAssetBoundSoundEntity(entityNumber, soundIndex, soundName)
  state = clientAssetBindingSlot.registry
  if state is void then return void end if
  return resolveSoundForEntity(state, entityNumber, soundIndex, soundName)
end function

// Return the client asset bound player model value.
function clientAssetBoundPlayerModel(index)
  state = clientAssetBindingSlot.registry
  if state is void then return void end if
  return resolvePlayerModel(state, index)
end function

// Return the client asset bound player skin value.
function clientAssetBoundPlayerSkin(index)
  state = clientAssetBindingSlot.registry
  if state is void then return void end if
  return resolvePlayerSkin(state, index)
end function

// Return the client asset bound player weapon value.
function clientAssetBoundPlayerWeapon(index, weaponIndex)
  state = clientAssetBindingSlot.registry
  if state is void then return void end if
  return resolvePlayerWeapon(state, index, weaponIndex)
end function

// Return the bindings value.
function bindings(state)
  holder = clientAssetBindingSlot
  holder.registry = state
  return cartypes.ResolverBindings(clientAssetBoundModelIndex, clientAssetBoundModelName,
    clientAssetBoundSkinName, clientAssetBoundSoundIndex, clientAssetBoundSoundName,
    clientAssetBoundSoundEntity,
    clientAssetBoundPlayerModel, clientAssetBoundPlayerSkin,
    clientAssetBoundPlayerWeapon)
end function

// Release bindings.
function releaseBindings()
  // The product intentionally has one active client resolver. Explicitly
  // release its registry when a map/demo session ends so parsed BSP/MD2/WAV
  // graphs do not survive into the next media step.
  holder = clientAssetBindingSlot
  holder.registry = void
  return true
end function

// Report whether missing assets.
function missingAssets(state)
  return state.missing
end function
