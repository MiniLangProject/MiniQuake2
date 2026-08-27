/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* CIN malformed boundaries and append-only managed mixer handoff tests. */
import miniquake2.qcommon.byteio as qbio
import miniquake2.format.cinematic as cinformat
import miniquake2.audio.mixer as amixer
import miniquake2.client.cinematic.audio as cinaudio
import miniquake2.client.cinematic.player as cinplayer
import miniquake2.client.cinematic.types as cintypes

// Assert the cinematic safety equal test condition.
function cinematicSafetyAssertEqual(actual, expected, name)
  if actual != expected then return error(8370, name + ": expected " + expected + ", got " + actual) end if
  return true
end function

// Return the cinematic safety synthetic value.
function cinematicSafetySynthetic()
  data = bytes(70000)
  qbio.putI32(data, 0, 2); qbio.putI32(data, 4, 2)
  qbio.putI32(data, 8, 14); qbio.putI32(data, 12, 1); qbio.putI32(data, 16, 1)
  row = 0
  while row < 256
    data[20 + row * 256] = 1; data[20 + row * 256 + 1] = 1; row = row + 1
  end while
  offset = cinformat.HEADER_BYTES
  qbio.putI32(data, offset, 1); offset = offset + 4
  offset = offset + 768
  qbio.putI32(data, offset, 5); offset = offset + 4
  qbio.putI32(data, offset, 4); data[offset + 4] = 10; offset = offset + 5
  data[offset] = 128; offset = offset + 1
  qbio.putI32(data, offset, 0); offset = offset + 4
  qbio.putI32(data, offset, 5); offset = offset + 4
  qbio.putI32(data, offset, 4); data[offset + 4] = 5; offset = offset + 5
  data[offset] = 129; offset = offset + 1
  qbio.putI32(data, offset, 2); offset = offset + 4
  return slice(data, 0, offset)
end function

cinematicSafetyData = cinematicSafetySynthetic()
cinematicSafetyAssertEqual(typeof(try(cinplayer.start(slice(cinematicSafetyData, 0, 100),
  0, false, cinaudio.silent()))), "error", "truncated header rejected")

cinematicBadDimensions = bytes(cinematicSafetyData)
qbio.putI32(cinematicBadDimensions, 0, 0)
cinematicSafetyAssertEqual(typeof(try(cinplayer.start(cinematicBadDimensions,
  0, false, cinaudio.silent()))), "error", "invalid dimensions rejected")

cinematicBadTree = bytes(cinematicSafetyData)
cinematicTreeIndex = 20
while cinematicTreeIndex < cinformat.HEADER_BYTES
  cinematicBadTree[cinematicTreeIndex] = 0
  cinematicTreeIndex = cinematicTreeIndex + 1
end while
cinematicZeroTreePlayer = cinplayer.start(cinematicBadTree, 0, false, cinaudio.silent())
cinematicSafetyAssertEqual(cinematicZeroTreePlayer.pixels, bytes([255, 255, 255, 255]),
  "classic empty Huffman rows use leaf-255 fallback")

cinematicBadCommand = bytes(cinematicSafetyData)
qbio.putI32(cinematicBadCommand, cinformat.HEADER_BYTES, 3)
cinematicSafetyAssertEqual(typeof(try(cinplayer.start(cinematicBadCommand,
  0, false, cinaudio.silent()))), "error", "invalid frame command rejected")

cinematicBadPixels = bytes(cinematicSafetyData)
qbio.putI32(cinematicBadPixels, cinformat.HEADER_BYTES + 4 + 768 + 4, 3)
cinematicSafetyAssertEqual(typeof(try(cinplayer.start(cinematicBadPixels,
  0, false, cinaudio.silent()))), "error", "short decompressed frame rejected")

cinematicTruncatedPalette = slice(cinematicSafetyData, 0, cinformat.HEADER_BYTES + 4 + 700)
cinematicSafetyAssertEqual(typeof(try(cinplayer.start(cinematicTruncatedPalette,
  0, false, cinaudio.silent()))), "error", "truncated palette rejected")

cinematicLateTruncated = slice(cinematicSafetyData, 0, len(cinematicSafetyData) - 5)
cinematicLatePlayer = cinplayer.start(cinematicLateTruncated, 0, false, cinaudio.silent())
cinematicSafetyAssertEqual(typeof(try(cinplayer.update(cinematicLatePlayer, 72))), "error", "truncated later audio rejected")
cinematicSafetyAssertEqual(cinematicLatePlayer.status, "stopped", "malformed playback stopped")

cinematicClockPlayer = cinplayer.start(cinematicSafetyData, 100, false, cinaudio.silent())
cinematicSafetyAssertEqual(typeof(try(cinplayer.update(cinematicClockPlayer, 99))), "error", "backward playback clock rejected")
cinplayer.pause(cinematicClockPlayer, 120)
cinematicSafetyAssertEqual(typeof(try(cinplayer.resume(cinematicClockPlayer, 119))), "error", "backward resume rejected")

// Mixer handoff grows one live WavSound, so frame chunks are sequential rather
// than overlapping or restarting at every CIN frame boundary.
cinematicMixer = amixer.create(8000)
cinematicMixerHandoff = cinaudio.mixerHandoff(cinematicMixer)
cinematicMixerHandoff.callbacks.submit(cintypes.AudioChunk(8000, 1, 1, 2, bytes([128, 255])))
cinematicMixerHandoff.callbacks.submit(cintypes.AudioChunk(8000, 1, 1, 2, bytes([0, 128])))
cinematicSafetyAssertEqual(cinematicMixerHandoff.adapter.sound.sampleCount, 4, "mixer stream append")
cinematicSafetyAssertEqual(len(cinematicMixerHandoff.adapter.sound.pcm), 4, "mixer PCM append")
cinematicMixerHandoff.callbacks.pause()
cinematicSafetyAssertEqual(cinematicMixerHandoff.adapter.channel.active, false, "mixer stream pause")
cinematicMixerHandoff.callbacks.resume()
cinematicSafetyAssertEqual(cinematicMixerHandoff.adapter.channel.active, true, "mixer stream resume")
cinematicMixed = amixer.mix(cinematicMixer, 4)
cinematicSafetyAssertEqual(len(cinematicMixed), 16, "mixer stereo output")
amixer.mix(cinematicMixer, 1)
cinematicSafetyAssertEqual(cinematicMixerHandoff.adapter.channel.active, false, "mixer reaches stream end")
cinematicMixerHandoff.callbacks.submit(cintypes.AudioChunk(8000, 1, 1, 1, bytes([128])))
cinematicSafetyAssertEqual(cinematicMixerHandoff.adapter.sound.sampleCount, 1, "consumed PCM compacted")
cinematicSafetyAssertEqual(cinematicMixerHandoff.adapter.channel.sourceFrame, 0.0, "compacted stream cursor")
cinematicSafetyAssertEqual(cinematicMixerHandoff.adapter.channel.active, true, "new PCM resumes stream")
cinematicSafetyAssertEqual(typeof(try(cinematicMixerHandoff.callbacks.submit(
  cintypes.AudioChunk(11025, 1, 1, 1, bytes([128]))))), "error", "mid-stream format change rejected")
cinaudio.stopMixerAdapter(cinematicMixerHandoff.adapter)
print("MiniQuake2 client cinematic malformed/audio tests passed: 1")
