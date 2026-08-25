/* GameImport sound -> UDP/Netchan -> integrated client -> mixer loopback. */
import miniquake2.qcommon.constants as nrsl_qc
import miniquake2.qcommon.types as nrsl_qt
import miniquake2.game.constants as nrsl_gc
import miniquake2.audio.mixer as nrsl_mixer
import miniquake2.audio.wav as nrsl_wav
import miniquake2.renderer.types as nrsl_rt
import miniquake2.server.game_bridge as nrsl_bridge
import miniquake2.runtime.client_assets as nrsl_assets
import miniquake2.runtime.play_session as nrsl_play
import miniquake2.game.integration.baseq2 as nrsl_integration
import miniquake2.game.null_game as nrsl_game

nextLoopbackModelId = 1

function soundLoopAssert(value, name)
  if not value then return error(8460, name) end if
  return true
end function

function loopbackModelLoader(name)
  global nextLoopbackModelId
  handle = nrsl_rt.ResourceHandle("model", nextLoopbackModelId, name, 1)
  nextLoopbackModelId = nextLoopbackModelId + 1
  return handle
end function

function loopbackSkinLoader(name)
  return nrsl_rt.ResourceHandle("skin", 1, name, 1)
end function

function loopbackSoundLoader(name)
  return nrsl_wav.WavSound(name, 8000, 1, 1, 2, -1, bytes([128, 129]))
end function

function loopbackMissing(value)
  return true
end function

function loopbackEntityPosition(number)
  return nrsl_qt.vec3(number * 8.0, 0.0, 0.0)
end function

function activeAutoSounds(mixer)
  count = 0
  for each channel in mixer.channels
    if channel.active and channel.autoSound then count = count + 1 end if
  end for
  return count
end function

entities = "{\n\"classname\" \"worldspawn\"\n}\n" +
  "{\n\"classname\" \"info_player_start\"\n\"origin\" \"0 0 24\"\n}\n" +
  "{\n\"classname\" \"target_speaker\"\n\"noise\" \"weapons/loop\"\n\"spawnflags\" \"1\"\n\"origin\" \"32 0 24\"\n}\n"
session = nrsl_play.createCore("sound_loop", entities, void,
  "\\name\\SoundLoop\\rate\\25000")
nrsl_play.runUntilActive(session, 500)

imports = nrsl_bridge.makeImports(session.server.bridgeRuntime)
loopbackSoundIndexValue = imports.soundIndex("weapons/loop.wav")
assetConfig = array(nrsl_qc.MAX_CONFIGSTRINGS, "")
assetConfig[nrsl_qc.CS_SOUNDS + loopbackSoundIndexValue] = "weapons/loop.wav"
assets = nrsl_assets.create(loopbackModelLoader, loopbackSkinLoader,
  loopbackSoundLoader, loopbackMissing)
nrsl_assets.registerConfigStrings(assets, assetConfig, "sound_loop")
mixer = nrsl_mixer.create(8000)
nrsl_assets.attachMixer(assets, session.client.integrated.effects, mixer,
  loopbackEntityPosition, nrsl_qt.zeroVec3(), nrsl_qt.vec3(1.0, 0.0, 0.0))

player = session.server.gameExport.edicts[1]
imports.sound(player, nrsl_gc.CHAN_WEAPON | nrsl_gc.CHAN_RELIABLE,
  loopbackSoundIndexValue, 0.5, nrsl_gc.ATTN_NORM, 0.0)
imports.positionedSound(nrsl_qt.vec3(16.0, 24.0, 32.0), player,
  nrsl_gc.CHAN_VOICE, loopbackSoundIndexValue, 1.0, nrsl_gc.ATTN_NONE, 0.025)
result = nrsl_play.step(session)
handoff = result.handoff
soundLoopAssert(handoff is not void and len(handoff.sounds) == 2,
  "sound events did not join snapshot handoff")
soundLoopAssert(handoff.sounds[0].entity == 1 and handoff.sounds[0].channel == nrsl_gc.CHAN_WEAPON,
  "entity sound wire fields mismatch")
soundLoopAssert(handoff.sounds[0].position is void and handoff.sounds[0].volume > 0.49 and
  handoff.sounds[0].volume < 0.51, "entity sound optional fields mismatch")
soundLoopAssert(handoff.sounds[1].entity == 1 and handoff.sounds[1].channel == nrsl_gc.CHAN_VOICE,
  "positioned sound wire fields mismatch")
soundLoopAssert(handoff.sounds[1].position.x == 16.0 and handoff.sounds[1].position.y == 24.0 and
  handoff.sounds[1].position.z == 32.0 and handoff.sounds[1].timeOffset == 0.025,
  "positioned sound optional fields mismatch")
soundLoopAssert(len(mixer.channels) == 2 and
  mixer.channels[0].sound.name == "weapons/loop.wav" and
  mixer.channels[1].sound.name == "weapons/loop.wav",
  "integrated sound resolver did not reach mixer callbacks")
soundLoopAssert(session.server.bridgeRuntime.pendingSoundCount == 0,
  "delivered server sound queue was not drained")
serverChannel = session.server.networkRuntime.server.clients[0].channel
soundLoopAssert(serverChannel.reliableLength > 0 and serverChannel.message.curSize == 0,
  "CHAN_RELIABLE sound was not held by Netchan until acknowledgement")
soundLoopAssert(len(nrsl_mixer.mix(mixer, 2)) == 8, "resolved sounds could not be mixed")
soundLoopAssert(nrsl_assets.syncEntityLoops(mixer,
  session.client.integrated.client.current) == 1 and
  activeAutoSounds(mixer) == 1,
  "server EntityState.sound did not reach client autosound mixer")

// The integrated client ACK is emitted by its poll phase.  The next server
// pump consumes that ACK and releases the reliable holding buffer.
nrsl_play.step(session)
soundLoopAssert(serverChannel.reliableLength == 0,
  "reliable sound acknowledgement did not release Netchan holding buffer")

speaker = nrsl_integration.findWorldByClass(
  nrsl_game.baseRuntime(), "target_speaker")
speaker.loopSound = 0
nrsl_play.step(session)
nrsl_assets.syncEntityLoops(mixer, session.client.integrated.client.current)
soundLoopAssert(activeAutoSounds(mixer) == 0,
  "cleared server EntityState.sound left client autosound playing")

nrsl_play.shutdown(session)
print("network_runtime_sound_loopback_tests: PASS")
