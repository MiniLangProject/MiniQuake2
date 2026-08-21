/* Renderer ResourceHandle and mixer Sound function-value handoff tests. */
import miniquake2.qcommon.constants as rca_qc
import miniquake2.qcommon.types as rca_qt
import miniquake2.audio.mixer as rca_mixer
import miniquake2.audio.wav as rca_wav
import miniquake2.renderer.recording as rca_recording
import miniquake2.client.effects.audio as rca_effect_audio
import miniquake2.client.effects.state as rca_effect_state
import miniquake2.client.effects.types as rca_effect_types
import miniquake2.runtime.client_assets as rca_assets

runtimeMissing = []

function runtimeAssetAssert(value, name)
  if not value then return error(8430, name) end if
  return true
end function

function loadRuntimeSound(name)
  if name == "weapons/missing.wav" then return void end if
  return rca_wav.WavSound(name, 8000, 1, 1, 2, -1, bytes([128, 129]))
end function

function noteRuntimeMissing(value)
  global runtimeMissing
  runtimeMissing = runtimeMissing + [value]
  return true
end function

function entityPosition(number)
  return rca_qt.vec3(number * 1.0, 0.0, 0.0)
end function

renderer = rca_recording.createRecordingRenderer()
renderer.exports.Init(void, void)
renderer.exports.BeginRegistration("maps/runtime_unit.bsp")
state = rca_assets.createForRenderer(renderer.exports, loadRuntimeSound, noteRuntimeMissing)
configStrings = array(rca_qc.MAX_CONFIGSTRINGS, "")
configStrings[rca_qc.CS_MODELS + 1] = "maps/runtime_unit.bsp"
configStrings[rca_qc.CS_MODELS + 2] = "models/runtime_unit.md2"
configStrings[rca_qc.CS_SOUNDS + 7] = "weapons/runtime.wav"
rca_assets.registerConfigStrings(state, configStrings, "runtime_unit")
renderer.exports.EndRegistration()

values = rca_assets.bindings(state)
runtimeAssetAssert(values.modelIndex(1).kind == "model" and
  values.modelIndex(2).name == "models/runtime_unit.md2", "renderer handle binding failed")
runtimeAssetAssert(values.soundIndex(7).sampleCount == 2, "mixer sound binding failed")
runtimeAssetAssert(values.modelIndex(0) is void and values.soundIndex(0) is void,
  "zero asset index did not resolve to void")

mixer = rca_mixer.create(8000)
effects = rca_effect_state.create(rca_effect_audio.silent(), 1)
audioCallbacks = rca_assets.attachMixer(state, effects, mixer, entityPosition,
  rca_qt.zeroVec3(), rca_qt.vec3(1.0, 0.0, 0.0))
runtimeAssetAssert(effects.audio == audioCallbacks, "effect audio callback was not installed")
event = rca_effect_types.SoundEvent(void, 0, 1, 7, "", 1.0, 0.0, 0.0)
runtimeAssetAssert(rca_effect_audio.emit(effects, event) != false and len(mixer.channels) == 1,
  "indexed sound did not reach mixer")
runtimeAssetAssert(mixer.channels[0].sound.name == "weapons/runtime.wav",
  "mixer received wrong sound object")
runtimeAssetAssert(len(rca_mixer.mix(mixer, 2)) == 8, "mixer could not consume resolved sound")

rca_assets.reset(state, "runtime_unit2")
runtimeAssetAssert(values.modelIndex(1) is void and values.soundIndex(7) is void,
  "bindings exposed resources after map reset")
renderer.exports.Shutdown()
print("runtime_client_assets_handoff_tests: PASS")
