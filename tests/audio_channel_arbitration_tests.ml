/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Quake-II S_PickChannel fixed-pool and priority parity. */
import miniquake2.audio.wav as acatwav
import miniquake2.audio.mixer as acatmixer

// Assert the acat test condition.
function acatAssert(value, message)
  if value != true then return error(10222, message) end if
  return true
end function

acatSound = acatwav.WavSound("long.wav", 8000, 1, 1, 8000, -1,
  bytes(8000))
acatMixer = acatmixer.create(8000)
acatmixer.setListenerEntity(acatMixer, 1)

// Fill the exact stock 32-channel pool; channel zero belongs to the player.
acatIndex = 0
while acatIndex < acatmixer.MAX_CHANNELS
  acatmixer.startSound(acatMixer, acatSound, acatIndex + 1, 0, 255, 255)
  acatIndex = acatIndex + 1
end while
acatAssert(len(acatMixer.channels) == 32, "stock channel pool size")

// A monster may replace another equally-lived monster, never the player.
acatmixer.startSound(acatMixer, acatSound, 100, 0, 255, 255)
acatAssert(len(acatMixer.channels) == 32, "channel pool remains bounded")
acatAssert(acatMixer.channels[0].entityNumber == 1,
  "non-player sound preserves view-entity channel")
acatAssert(acatMixer.channels[1].entityNumber == 100,
  "shortest eligible non-player channel replaced")

// A named entity channel always overrides its own current sound, even though
// another pool slot has the same remaining life.
acatmixer.startSound(acatMixer, acatSound, 12, 7, 200, 100)
acatOverrideSlot = -1
acatIndex = 0
while acatIndex < len(acatMixer.channels)
  if acatMixer.channels[acatIndex].entityNumber == 12 and
      acatMixer.channels[acatIndex].entityChannel == 7 then
    acatOverrideSlot = acatIndex
  end if
  acatIndex = acatIndex + 1
end while
acatAssert(acatOverrideSlot >= 0, "initial named entity channel")
acatmixer.startSound(acatMixer, acatSound, 12, 7, 17, 19)
acatAssert(acatMixer.channels[acatOverrideSlot].leftVolume == 17 and
  acatMixer.channels[acatOverrideSlot].rightVolume == 19,
  "named entity channel overrides itself")

// If all 32 slots are player-owned, an external sound is rejected exactly as
// S_PickChannel returns NULL when no unprotected victim exists.
acatProtected = acatmixer.create(8000)
acatmixer.setListenerEntity(acatProtected, 1)
acatIndex = 0
while acatIndex < acatmixer.MAX_CHANNELS
  acatmixer.startSound(acatProtected, acatSound, 1, 0, 255, 255)
  acatIndex = acatIndex + 1
end while
acatRejected = acatmixer.startSound(acatProtected, acatSound, 2, 0, 255, 255)
acatAssert(acatRejected is void and len(acatProtected.channels) == 32,
  "all-player pool rejects external replacement")

acatLoops = acatmixer.create(8000)
acatIndex = 0
while acatIndex < acatmixer.MAX_CHANNELS
  acatLoop = acatmixer.startSound(acatLoops, acatSound, acatIndex + 2,
    0, 255, 255)
  acatLoop.looping = true
  acatIndex = acatIndex + 1
end while
acatLoopReplacement = acatmixer.startSound(acatLoops, acatSound, 99, 1,
  255, 255)
acatAssert(acatLoopReplacement is not void and
  len(acatLoops.channels) == 32,
  "finite loop segment remains eligible for S_PickChannel")

// Delayed playsounds live outside the 32 active channels and arbitrate only
// on their paint boundary. The current CHAN_WEAPON must remain audible until
// the scheduled replacement is actually issued.
acatDelayed = acatmixer.create(8000)
acatFirst = acatwav.WavSound("first.wav", 8000, 1, 1, 4, -1,
  bytes([255, 255, 255, 255]))
acatSecond = acatwav.WavSound("second.wav", 8000, 1, 1, 4, -1,
  bytes([0, 0, 0, 0]))
acatmixer.startSound(acatDelayed, acatFirst, 2, 1, 255, 255)
acatmixer.startSoundAt(acatDelayed, acatSecond, 2, 1, 255, 255, 2)
acatAssert(len(acatDelayed.channels) == 1 and
  acatDelayed.channels[0].sound.name == "first.wav" and
  len(acatDelayed.pendingSounds) == 1,
  "delayed replacement claimed channel before begin time")
acatmixer.mix(acatDelayed, 2)
acatAssert(acatDelayed.channels[0].sound.name == "first.wav",
  "active sound replaced before delayed paint boundary")
acatmixer.mix(acatDelayed, 1)
acatAssert(acatDelayed.channels[0].sound.name == "second.wav" and
  len(acatDelayed.pendingSounds) == 0,
  "delayed sound was not issued on paint boundary")

acatEqual = acatmixer.create(8000)
acatmixer.startSound(acatEqual, acatFirst, 2, 1, 255, 255)
acatmixer.startSoundAt(acatEqual, acatFirst, 2, 1, 255, 255, 1)
acatmixer.startSoundAt(acatEqual, acatSecond, 2, 1, 255, 255, 1)
acatmixer.mix(acatEqual, 2)
acatAssert(acatEqual.channels[0].sound.name == "first.wav",
  "equal-time pending list replacement order")

print "audio_channel_arbitration_tests: PASS"
