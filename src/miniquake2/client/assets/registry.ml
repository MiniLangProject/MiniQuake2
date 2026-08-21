/* Safe Quake-II client asset registry with explicit map generations. */
package miniquake2.client.assets.registry

import miniquake2.qcommon.constants as carqc
import miniquake2.qcommon.text as cartext
import miniquake2.client.assets.types as cartypes

const MAX_NAMED_ASSETS = 256
const MAX_MISSING_ASSETS = 512

// The product has one active Quake client. A package-owned mutable holder is
// used instead of nested functions capturing a factory parameter; the latter
// loses its environment in some full-program MiniLang link graphs.
struct ClientAssetBindingSlot
  registry
end struct

clientAssetBindingSlot = ClientAssetBindingSlot(void)

function ignoreMissing(value)
  return true
end function

function callbacks(loadModel, loadSound, onMissing)
  if typeof(loadModel) != "function" or typeof(loadSound) != "function" or
      typeof(onMissing) != "function" then
    return error(8400, "client asset loaders must be function values")
  end if
  return cartypes.LoaderCallbacks(loadModel, loadSound, onMissing)
end function

function create(loaders)
  if loaders is void then return error(8401, "client asset loader table is missing") end if
  return cartypes.Registry(loaders, 0, "", array(carqc.MAX_MODELS, void),
    array(carqc.MAX_SOUNDS, void), [], [], [])
end function

function createLenient(loadModel, loadSound)
  return create(callbacks(loadModel, loadSound, ignoreMissing))
end function

function containsTraversal(value)
  source = bytes(value)
  index = 0
  while index + 1 < len(source)
    if source[index] == 46 and source[index + 1] == 46 then return true end if
    index = index + 1
  end while
  return false
end function

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

function safeModelName(name)
  if typeof(name) != "string" or name == "" then return false end if
  if bytes(name)[0] == 42 then return inlineModelName(name) end if
  return safeRegularName(name)
end function

function safeSoundName(name)
  if typeof(name) != "string" or name == "" then return false end if
  if bytes(name)[0] == 42 then return false end if
  return safeRegularName(name)
end function

function validModel(value)
  if typeof(value) != "struct" then return false end if
  return value.kind == "model" and typeof(value.id) == "int" and value.id > 0 and
    typeof(value.name) == "string" and typeof(value.generation) == "int"
end function

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

function noteMissing(state, kind, index, name, reason)
  missing = cartypes.MissingAsset(kind, index, name, state.generation, reason)
  state.missing = appendBounded(state.missing, missing, MAX_MISSING_ASSETS)
  ignored = try(state.loaders.onMissing(missing))
  return cartypes.AssetEntry(kind, index, name, void, state.generation, false, reason)
end function

function cached(values, name, generation)
  key = cartext.lower(name)
  for each entry in values
    if entry.generation == generation and cartext.lower(entry.name) == key then return entry end if
  end for
  return void
end function

function indexed(entry, index, name)
  return cartypes.AssetEntry(entry.kind, index, name, entry.value,
    entry.generation, entry.available, entry.reason)
end function

function cacheNamed(state, kind, entry)
  values = state.namedModels
  if kind == "sound" then values = state.namedSounds end if
  if len(values) >= MAX_NAMED_ASSETS then return false end if
  values = values + [entry]
  if kind == "model" then state.namedModels = values else state.namedSounds = values end if
  return true
end function

function missingNamed(state, kind, index, name, reason)
  entry = noteMissing(state, kind, index, name, reason)
  ignored = cacheNamed(state, kind, indexed(entry, -1, name))
  return entry
end function

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

function loadSoundAsset(state, index, name)
  if typeof(name) != "string" or name == "" then
    return noteMissing(state, "sound", index, "", "unsafe-name")
  end if
  existing = cached(state.namedSounds, name, state.generation)
  if existing is not void then return indexed(existing, index, name) end if
  if not safeSoundName(name) then
    reason = "unsafe-name"
    if typeof(name) == "string" and name != "" and bytes(name)[0] == 42 then reason = "player-sound-deferred" end if
    return noteMissing(state, "sound", index, name, reason)
  end if
  loaded = try(state.loaders.loadSound(name))
  if loaded is error then return missingNamed(state, "sound", index, name, "loader-error") end if
  if loaded is void then return missingNamed(state, "sound", index, name, "not-found") end if
  if not validSound(loaded) then return missingNamed(state, "sound", index, name, "invalid-loader-result") end if
  entry = cartypes.AssetEntry("sound", index, name, loaded, state.generation, true, "")
  ignored = cacheNamed(state, "sound", indexed(entry, -1, name))
  return entry
end function

function reset(state, mapName)
  if typeof(mapName) != "string" or mapName == "" or len(bytes(mapName)) >= carqc.MAX_QPATH then
    return error(8402, "client asset map name is invalid")
  end if
  state.generation = state.generation + 1
  state.mapName = mapName
  state.modelEntries = array(carqc.MAX_MODELS, void)
  state.soundEntries = array(carqc.MAX_SOUNDS, void)
  state.namedModels = []
  state.namedSounds = []
  state.missing = []
  return state.generation
end function

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
  reset(state, mapName)
  index = 1
  while index < carqc.MAX_MODELS
    name = configStrings[carqc.CS_MODELS + index]
    if typeof(name) != "string" then return error(8404, "model configstring is not text") end if
    if name != "" then
      if bytes(name)[0] == 35 then
        state.modelEntries[index] = noteMissing(state, "model", index, name, "weapon-model-deferred")
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
  return state.generation
end function

function resolveModelIndex(state, index)
  if typeof(index) != "int" or index < 0 or index >= carqc.MAX_MODELS then return void end if
  if index == 0 then return void end if
  entry = state.modelEntries[index]
  if entry is void or entry.generation != state.generation or not entry.available then return void end if
  return entry.value
end function

function resolveSoundIndex(state, index)
  if typeof(index) != "int" or index < 0 or index >= carqc.MAX_SOUNDS then return void end if
  if index == 0 then return void end if
  entry = state.soundEntries[index]
  if entry is void or entry.generation != state.generation or not entry.available then return void end if
  return entry.value
end function

function resolveModelName(state, name)
  entry = loadModelAsset(state, -1, name)
  if not entry.available then return void end if
  return entry.value
end function

function resolveSoundName(state, name)
  entry = loadSoundAsset(state, -1, name)
  if not entry.available then return void end if
  return entry.value
end function

function clientAssetBoundModelIndex(index)
  state = clientAssetBindingSlot.registry
  if state is void then return void end if
  return resolveModelIndex(state, index)
end function

function clientAssetBoundModelName(name)
  state = clientAssetBindingSlot.registry
  if state is void then return void end if
  return resolveModelName(state, name)
end function

function clientAssetBoundSoundIndex(index)
  state = clientAssetBindingSlot.registry
  if state is void then return void end if
  return resolveSoundIndex(state, index)
end function

function clientAssetBoundSoundName(name)
  state = clientAssetBindingSlot.registry
  if state is void then return void end if
  return resolveSoundName(state, name)
end function

function bindings(state)
  holder = clientAssetBindingSlot
  holder.registry = state
  return cartypes.ResolverBindings(clientAssetBoundModelIndex, clientAssetBoundModelName,
    clientAssetBoundSoundIndex, clientAssetBoundSoundName)
end function

function missingAssets(state)
  return state.missing
end function
