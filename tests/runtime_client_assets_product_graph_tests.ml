/* Full product import graph gate for capture-safe asset resolver bindings. */
import miniquake2.runtime.diagnostics as asset_graph_diagnostics
import miniquake2.runtime.application as asset_graph_application
import miniquake2.runtime.client_assets as asset_graph_runtime
import miniquake2.qcommon.constants as asset_graph_qc
import miniquake2.audio.wav as asset_graph_wav
import miniquake2.renderer.recording as asset_graph_recording

function assetGraphAssert(value, name)
  if not value then return error(8440, name) end if
  return true
end function

function assetGraphSoundLoader(name)
  return asset_graph_wav.WavSound(name, 8000, 1, 1, 1, -1, bytes([128]))
end function

function assetGraphMissing(value)
  return true
end function

// Keep all three requested product roots live in the executable closure.
linked = [typeof(asset_graph_diagnostics.capabilityLines),
  typeof(asset_graph_application.runPlay), typeof(asset_graph_runtime.createForRenderer)]
assetGraphAssert(linked == ["function", "function", "function"], "product graph imports missing")

renderer = asset_graph_recording.createRecordingRenderer()
renderer.exports.Init(void, void)
renderer.exports.BeginRegistration("maps/asset_graph.bsp")
assets = asset_graph_runtime.createForRenderer(renderer.exports,
  assetGraphSoundLoader, assetGraphMissing)
configStrings = array(asset_graph_qc.MAX_CONFIGSTRINGS, "")
configStrings[asset_graph_qc.CS_MODELS + 1] = "maps/asset_graph.bsp"
configStrings[asset_graph_qc.CS_MODELS + 2] = "models/asset_graph.md2"
configStrings[asset_graph_qc.CS_SOUNDS + 3] = "weapons/asset_graph.wav"
asset_graph_runtime.registerConfigStrings(assets, configStrings, "asset_graph")
resolver = asset_graph_runtime.bindings(assets)

assetGraphAssert(resolver.modelIndex(2).name == "models/asset_graph.md2",
  "model binding lost package-owned state")
assetGraphAssert(resolver.soundIndex(3).name == "weapons/asset_graph.wav",
  "sound binding lost package-owned state")
assetGraphAssert(resolver.modelName("models/objects/asset_graph.md2") is not void,
  "named effect model binding lost state")

asset_graph_runtime.reset(assets, "asset_graph_reset")
assetGraphAssert(resolver.modelIndex(2) is void and resolver.soundIndex(3) is void,
  "binding did not observe reset generation")
renderer.exports.EndRegistration()
renderer.exports.Shutdown()
print("runtime_client_assets_product_graph_tests: PASS")
