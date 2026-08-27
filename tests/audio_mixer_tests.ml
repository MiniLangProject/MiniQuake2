/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Asset-free RIFF loader, spatializer and PCM mixer tests. */
import miniquake2.qcommon.types as qt
import miniquake2.qcommon.byteio as tbio
import miniquake2.audio.wav as awav
import miniquake2.audio.mixer as amix

// Assert the equal test condition.
function assertEqual(actual, expected, name)
  if actual != expected then return error(7996, name + ": expected " + expected + ", got " + actual) end if
end function

// Return the mono wav value.
function monoWav()
  data = bytes(48)
  tbio.copyInto(data, 0, bytes("RIFF"), 0, 4); tbio.putU32(data, 4, 40)
  tbio.copyInto(data, 8, bytes("WAVEfmt "), 0, 8); tbio.putU32(data, 16, 16)
  tbio.putU16(data, 20, 1); tbio.putU16(data, 22, 1); tbio.putU32(data, 24, 8000)
  tbio.putU32(data, 28, 8000); tbio.putU16(data, 32, 1); tbio.putU16(data, 34, 8)
  tbio.copyInto(data, 36, bytes("data"), 0, 4); tbio.putU32(data, 40, 4)
  data[44] = 128; data[45] = 255; data[46] = 0; data[47] = 128
  return data
end function

sound = awav.parse(monoWav(), "sound/unit.wav")
assertEqual(sound.sampleRate, 8000, "WAV rate")
assertEqual(sound.sampleCount, 4, "WAV sample count")
mixer = amix.create(8000)
silentMixer = amix.create(8000)
silentOutput = amix.mix(silentMixer, 1024)
assertEqual(len(silentOutput), 4096, "silent fast-path byte count")
assertEqual(silentMixer.paintedFrames, 1024, "silent fast-path painted frames")
silentReusable = amix.mixReusable(silentMixer, 4)
silentReusable[0] = 123
silentReusable = amix.mixReusable(silentMixer, 4)
assertEqual(silentReusable[0], 0, "reusable silent block is cleared")
assertEqual(typeof(try(amix.mixInto(silentMixer, bytes(3), 1))), "error",
  "mixer rejects a wrongly sized output buffer")
amix.startSound(mixer, sound, 1, 1, 255, 255)
output = amix.mix(mixer, 4)
assertEqual(tbio.i16(output, 0), 0, "sample zero")
assertEqual(tbio.i16(output, 4), 32512, "positive sample")
assertEqual(tbio.i16(output, 8), -32768, "negative sample")
assertEqual(mixer.channels[0].active, true, "channel ends on next paint boundary")
amix.mix(mixer, 1)
assertEqual(mixer.channels[0].active, false, "nonlooping channel stopped")
amix.startSound(mixer, sound, 2, 2, 255, 255)
assertEqual(len(mixer.channels), 1, "finished channel slot reused")

volumeMixer = amix.create(8000)
amix.setMasterVolume(volumeMixer, 0.5)
amix.startSound(volumeMixer, sound, 1, 1, 255, 255)
volumeOutput = amix.mix(volumeMixer, 2)
assertEqual(tbio.i16(volumeOutput, 4), 16256, "runtime master volume")
assertEqual(typeof(try(amix.setMasterVolume(volumeMixer, 1.1))), "error", "master volume upper bound")
assertEqual(typeof(try(amix.setMasterVolume(volumeMixer, 0.0 / 0.0))), "error", "master volume NaN guard")

volumes = amix.spatialVolumes(qt.zeroVec3(), qt.Vec3(1.0, 0.0, 0.0), qt.Vec3(10.0, 0.0, 0.0), 255.0, 0.01)
assertEqual(volumes[0], 0, "hard-right left volume")
assertEqual(volumes[1], 255, "hard-right volume clamp")
globalVolumes = amix.spatialVolumes(qt.zeroVec3(), qt.Vec3(1.0, 0.0, 0.0),
  qt.Vec3(400.0, 0.0, 0.0), 255.0, 0.0)
assertEqual(globalVolumes[0], 255, "ATTN_NONE global left volume")
assertEqual(globalVolumes[1], 255, "ATTN_NONE global right volume")
fullRadiusVolumes = amix.spatialVolumes(qt.zeroVec3(), qt.Vec3(0.0, 1.0, 0.0),
  qt.Vec3(80.0, 0.0, 0.0), 255.0, 0.0005)
assertEqual(fullRadiusVolumes[0], 127, "stock full-volume radius left")
assertEqual(fullRadiusVolumes[1], 127, "stock full-volume radius right")
bad = monoWav(); bad[0] = 0
assertEqual(typeof(try(awav.parse(bad, "bad"))), "error", "bad RIFF rejected")
print("MiniQuake2 audio mixer tests passed: 2")
