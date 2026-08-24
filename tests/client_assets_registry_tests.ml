/* Asset-free model/sound registration, cache and generation tests. */
import miniquake2.qcommon.constants as car_test_qc
import miniquake2.renderer.types as car_test_rt
import miniquake2.audio.wav as car_test_wav
import miniquake2.client.assets.registry as car_test_registry

modelCalls = []
skinCalls = []
soundCalls = []
missingCalls = []
loaderGeneration = 1
nextModelId = 1

function registryAssert(value, name)
  if not value then return error(8420, name) end if
  return true
end function

function fakeLoadModel(name)
  global modelCalls, loaderGeneration, nextModelId
  modelCalls = modelCalls + [name]
  if name == "models/missing.md2" then return void end if
  if name == "models/bad.md2" then return car_test_rt.ResourceHandle("pic", 999, name, loaderGeneration) end if
  value = car_test_rt.ResourceHandle("model", nextModelId, name, loaderGeneration)
  nextModelId = nextModelId + 1
  return value
end function

function fakeLoadSkin(name)
  global skinCalls, loaderGeneration, nextModelId
  skinCalls = skinCalls + [name]
  value = car_test_rt.ResourceHandle("skin", nextModelId, name, loaderGeneration)
  nextModelId = nextModelId + 1
  return value
end function

function fakeLoadSound(name)
  global soundCalls
  soundCalls = soundCalls + [name]
  if name == "weapons/missing.wav" then return void end if
  if name == "weapons/bad.wav" then return car_test_wav.WavSound(name, 11025, 1, 1, 2, -1, bytes([128])) end if
  return car_test_wav.WavSound(name, 11025, 1, 1, 1, -1, bytes([128]))
end function

function fakeOnMissing(value)
  global missingCalls
  missingCalls = missingCalls + [value]
  return true
end function

configStrings = array(car_test_qc.MAX_CONFIGSTRINGS, "")
configStrings[car_test_qc.CS_MODELS + 1] = "maps/unit.bsp"
configStrings[car_test_qc.CS_MODELS + 2] = "models/unit.md2"
configStrings[car_test_qc.CS_MODELS + 3] = "*1"
configStrings[car_test_qc.CS_MODELS + 4] = "#w_unit.md2"
configStrings[car_test_qc.CS_MODELS + 5] = "../escape.md2"
configStrings[car_test_qc.CS_MODELS + 6] = "models/bad.md2"
configStrings[car_test_qc.CS_SOUNDS + 1] = "weapons/unit.wav"
configStrings[car_test_qc.CS_SOUNDS + 2] = "weapons/missing.wav"
configStrings[car_test_qc.CS_SOUNDS + 3] = "*pain100_1.wav"
configStrings[car_test_qc.CS_SOUNDS + 4] = "weapons/bad.wav"
configStrings[car_test_qc.CS_PLAYERSKINS] = "Unit\\female/athena"

state = car_test_registry.create(car_test_registry.callbacks(fakeLoadModel,
  fakeLoadSkin, fakeLoadSound, fakeOnMissing))
registryAssert(car_test_registry.registerConfigStrings(state, configStrings, "unit") == 1,
  "initial registration generation mismatch")
registryAssert(car_test_registry.resolveModelIndex(state, 1).name == "maps/unit.bsp",
  "world model handle missing")
registryAssert(car_test_registry.resolveModelIndex(state, 2).name == "models/unit.md2",
  "entity model handle missing")
registryAssert(car_test_registry.resolveModelIndex(state, 3).name == "*1",
  "inline model handle missing")
registryAssert(car_test_registry.resolveModelIndex(state, 4) is void and
  car_test_registry.resolveModelIndex(state, 5) is void, "deferred/unsafe model resolved")
registryAssert(car_test_registry.resolveSoundIndex(state, 1).name == "weapons/unit.wav",
  "indexed mixer sound missing")
registryAssert(car_test_registry.resolveSoundIndex(state, 2) is void and
  car_test_registry.resolveSoundIndex(state, 3) is void, "missing/deferred sound resolved")
registryAssert(len(modelCalls) == 10, "indexed/player model registration mismatch")
registryAssert(len(skinCalls) == 2, "base and configured player skins not registered")
registryAssert(len(soundCalls) == 3, "deferred player sound reached loader")
registryAssert(len(car_test_registry.missingAssets(state)) == 5 and len(missingCalls) == 5,
  "missing asset diagnostics mismatch")

bindings = car_test_registry.bindings(state)
registryAssert(bindings.playerModel(0).name == "players/female/tris.md2",
  "configured player model resolver failed")
registryAssert(bindings.playerSkin(0).name == "players/female/athena.pcx",
  "configured player skin resolver failed")
registryAssert(bindings.playerWeapon(0, 1).name == "players/female/w_unit.md2",
  "configured visible weapon resolver failed")
configStrings[car_test_qc.CS_PLAYERSKINS] = "Unit\\male/grunt"
registryAssert(car_test_registry.refreshClientInfos(state, configStrings) == 1 and
  bindings.playerModel(0).name == "players/male/tris.md2",
  "live player configstring refresh failed")
effectModel = bindings.modelName("models/objects/unit.md2")
registryAssert(effectModel is not void and effectModel.name == "models/objects/unit.md2",
  "effect model name resolver failed")
modelCallCount = len(modelCalls)
registryAssert(bindings.modelName("MODELS/OBJECTS/UNIT.MD2").id == effectModel.id,
  "case-insensitive model cache failed")
registryAssert(len(modelCalls) == modelCallCount, "cached model loaded twice")
registryAssert(bindings.soundName("weapons/unit2.wav").name == "weapons/unit2.wav",
  "named sound resolver failed")
soundCallCount = len(soundCalls)
registryAssert(bindings.soundName("WEAPONS/UNIT2.WAV").name == "weapons/unit2.wav" and
  len(soundCalls) == soundCallCount, "case-insensitive sound cache failed")

configStrings[car_test_qc.CS_MODELS + 7] = "models/objects/laser/tris.md2"
configStrings[car_test_qc.CS_SOUNDS + 5] = "misc/lasfly.wav"
registryAssert(car_test_registry.refreshConfigStrings(state, configStrings) == 2,
  "live indexed asset refresh count mismatch")
registryAssert(bindings.modelIndex(7).name == "models/objects/laser/tris.md2" and
  bindings.soundIndex(5).name == "misc/lasfly.wav",
  "live projectile model/sound configstrings were not registered")
configStrings[car_test_qc.CS_MODELS + 8] = "#w_dynamic.md2"
registryAssert(car_test_registry.refreshConfigStrings(state, configStrings) == 1 and
  bindings.playerWeapon(0, 2).name == "players/male/w_dynamic.md2",
  "live player weapon model configstring was not registered")
configStrings[car_test_qc.CS_MODELS + 7] = ""
configStrings[car_test_qc.CS_SOUNDS + 5] = ""
registryAssert(car_test_registry.refreshConfigStrings(state, configStrings) == 2 and
  bindings.modelIndex(7) is void and bindings.soundIndex(5) is void,
  "cleared live indexed assets remained bound")

registryAssert(bindings.modelName("models/missing.md2") is void, "missing model resolved")
missingModelCallCount = len(modelCalls)
registryAssert(bindings.modelName("models/missing.md2") is void and
  len(modelCalls) == missingModelCallCount, "negative model cache failed")

oldWorld = bindings.modelIndex(1)
loaderGeneration = 2
registryAssert(car_test_registry.reset(state, "unit2") == 2, "map reset generation mismatch")
registryAssert(bindings.modelIndex(1) is void and bindings.soundIndex(1) is void,
  "map reset retained indexed assets")
registryAssert(len(car_test_registry.missingAssets(state)) == 0, "map reset retained missing diagnostics")
configStrings[car_test_qc.CS_MODELS + 1] = "maps/unit2.bsp"
registryAssert(car_test_registry.registerConfigStrings(state, configStrings, "unit2") == 3,
  "second registration generation mismatch")
newWorld = bindings.modelIndex(1)
registryAssert(newWorld is not void and newWorld.id != oldWorld.id and newWorld.generation == 2,
  "new generation reused stale model handle")

generationBeforeMalformed = state.generation
malformed = array(car_test_qc.MAX_CONFIGSTRINGS, "")
malformed[car_test_qc.CS_MODELS + 9] = 42
registryAssert(try(car_test_registry.registerConfigStrings(state, malformed, "bad")) is error,
  "non-text configstring accepted")
registryAssert(state.generation == generationBeforeMalformed and bindings.modelIndex(1) == newWorld,
  "malformed table partially reset live registry")
print("client_assets_registry_tests: PASS")
