/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Quake-II S_Update dynamic one-shot spatialization parity. */
import miniquake2.qcommon.types as castqtypes
import miniquake2.audio.wav as castwav
import miniquake2.audio.mixer as castmixer
import miniquake2.client.effects.types as casttypes
import miniquake2.client.effects.audio as castaudio
import miniquake2.client.effects.state as caststate
import miniquake2.client.effects.mixer_adapter as castadapter

castSound = castwav.WavSound("unit.wav", 8000, 1, 1, 64, -1,
  bytes(64))
castEntityPosition = castqtypes.Vec3(100.0, 0.0, 0.0)

function castResolveIndex(index)
  global castSound
  return castSound
end function

function castResolveName(name)
  global castSound
  return castSound
end function

function castResolveEntitySound(entityNumber, soundIndex, soundName)
  global castSound
  return castSound
end function

function castResolvePosition(entityNumber)
  global castEntityPosition
  return castEntityPosition
end function

function castAssert(value, message)
  if value != true then return error(10221, message) end if
  return true
end function

castMixer = castmixer.create(8000)
castCallbacks = castadapter.install(castMixer, castResolveIndex,
  castResolveName, castResolveEntitySound, castResolvePosition,
  castqtypes.zeroVec3(),
  castqtypes.Vec3(1.0, 0.0, 0.0))
castadapter.setListenerEntity(1)
castState = caststate.create(castCallbacks, 1)

// A NULL protocol origin is entity-bound. Its pan must follow the entity on
// the next listener update, matching S_Spatialize(CL_GetEntitySoundOrigin()).
castEvent = casttypes.SoundEvent(void, 2, 1, 7, "", 1.0, 1.0, 0.0)
castaudio.emit(castState, castEvent)
castAssert(castMixer.channels[0].leftVolume == 0 and
  castMixer.channels[0].rightVolume == 252,
  "entity-bound one-shot initial pan")
castEntityPosition = castqtypes.Vec3(-100.0, 0.0, 0.0)
castadapter.install(castMixer, castResolveIndex, castResolveName,
  castResolveEntitySound, castResolvePosition, castqtypes.zeroVec3(),
  castqtypes.Vec3(1.0, 0.0, 0.0))
castAssert(castMixer.channels[0].leftVolume == 252 and
  castMixer.channels[0].rightVolume == 0,
  "entity-bound one-shot follows moving entity")

// Explicit origins remain fixed even when the referenced entity moves.
castFixed = casttypes.SoundEvent(castqtypes.Vec3(100.0, 0.0, 0.0),
  3, 2, 7, "", 1.0, 1.0, 0.0)
castaudio.emit(castState, castFixed)
castEntityPosition = castqtypes.Vec3(-100.0, 0.0, 0.0)
castadapter.install(castMixer, castResolveIndex, castResolveName,
  castResolveEntitySound, castResolvePosition, castqtypes.zeroVec3(),
  castqtypes.Vec3(1.0, 0.0, 0.0))
castAssert(castMixer.channels[1].leftVolume == 0 and
  castMixer.channels[1].rightVolume == 252,
  "fixed-origin one-shot does not follow entity")

// Listener-owned channels are full-volume and unpanned in S_Spatialize.
castLocal = casttypes.SoundEvent(void, 1, 3, 7, "", 0.5, 1.0, 0.0)
castaudio.emit(castState, castLocal)
castadapter.install(castMixer, castResolveIndex, castResolveName,
  castResolveEntitySound, castResolvePosition,
  castqtypes.Vec3(500.0, 0.0, 0.0),
  castqtypes.Vec3(1.0, 0.0, 0.0))
castAssert(castMixer.channels[2].leftVolume == 127 and
  castMixer.channels[2].rightVolume == 127,
  "listener entity one-shot remains local")

// ATTN_STATIC uses attenuation * 0.001, not the ordinary * 0.0005.
castadapter.install(castMixer, castResolveIndex, castResolveName,
  castResolveEntitySound, castResolvePosition, castqtypes.zeroVec3(),
  castqtypes.Vec3(1.0, 0.0, 0.0))
castStatic = casttypes.SoundEvent(castqtypes.Vec3(180.0, 0.0, 0.0),
  4, 4, 7, "", 1.0, 3.0, 0.0)
castaudio.emit(castState, castStatic)
castAssert(castMixer.channels[3].rightVolume == 178,
  "ATTN_STATIC stock distance multiplier")

// Once an active dynamic channel becomes inaudible, stock S_Update drops it.
castEntityPosition = castqtypes.Vec3(10000.0, 0.0, 0.0)
castadapter.respatializeDynamic(castMixer, castResolvePosition,
  castqtypes.zeroVec3(), castqtypes.Vec3(1.0, 0.0, 0.0), 1)
castAssert(not castMixer.channels[0].active,
  "inaudible dynamic channel is released")

castEntityPosition = castqtypes.Vec3(100.0, 0.0, 0.0)
castDelayed = casttypes.SoundEvent(void, 2, 5, 7, "", 1.0, 1.0, 0.01)
castaudio.emit(castState, castDelayed)
castAssert(len(castMixer.pendingSounds) == 1 and
  castMixer.pendingSounds[0].rightVolume == 252,
  "pending entity sound initial pan")
castEntityPosition = castqtypes.Vec3(-100.0, 0.0, 0.0)
castadapter.install(castMixer, castResolveIndex, castResolveName,
  castResolveEntitySound, castResolvePosition, castqtypes.zeroVec3(),
  castqtypes.Vec3(1.0, 0.0, 0.0))
castAssert(castMixer.pendingSounds[0].leftVolume == 252 and
  castMixer.pendingSounds[0].rightVolume == 0,
  "pending entity sound spatialized at current source")

castadapter.release()
print "client_audio_spatialization_tests: PASS"
