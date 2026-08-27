/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Synthetic two-frame CIN golden, 14-fps timing, pause, loop and renderer tests. */
import miniquake2.qcommon.byteio as qbio
import miniquake2.format.cinematic as cinformat
import miniquake2.renderer.recording as recording
import miniquake2.client.cinematic.audio as cinaudio
import miniquake2.client.cinematic.player as cinplayer

cinematicTimingChunks = []

// Submit cinematic timing.
function cinematicTimingSubmit(chunk)
  global cinematicTimingChunks
  cinematicTimingChunks = cinematicTimingChunks + [chunk]
  return true
end function

// Assert the cinematic timing equal test condition.
function cinematicTimingAssertEqual(actual, expected, name)
  if actual != expected then return error(8360, name + ": expected " + expected + ", got " + actual) end if
  return true
end function

// Return the cinematic synthetic value.
function cinematicSynthetic()
  data = bytes(70000)
  qbio.putI32(data, 0, 2)
  qbio.putI32(data, 4, 2)
  qbio.putI32(data, 8, 14)
  qbio.putI32(data, 12, 1)
  qbio.putI32(data, 16, 1)
  row = 0
  while row < 256
    data[20 + row * 256] = 1
    data[20 + row * 256 + 1] = 1
    row = row + 1
  end while
  offset = cinformat.HEADER_BYTES

  qbio.putI32(data, offset, 1); offset = offset + 4
  paletteIndex = 0
  while paletteIndex < 768
    data[offset + paletteIndex] = paletteIndex & 255
    paletteIndex = paletteIndex + 1
  end while
  offset = offset + 768
  qbio.putI32(data, offset, 5); offset = offset + 4
  qbio.putI32(data, offset, 4); data[offset + 4] = 10; offset = offset + 5
  data[offset] = 130; offset = offset + 1

  qbio.putI32(data, offset, 0); offset = offset + 4
  qbio.putI32(data, offset, 5); offset = offset + 4
  qbio.putI32(data, offset, 4); data[offset + 4] = 5; offset = offset + 5
  data[offset] = 140; offset = offset + 1
  qbio.putI32(data, offset, 2); offset = offset + 4
  return slice(data, 0, offset)
end function

cinematicTimingData = cinematicSynthetic()
cinematicTimingAudio = cinaudio.callbacks(cinematicTimingSubmit)
cinematicTimingPlayer = cinplayer.start(cinematicTimingData, 1000, false, cinematicTimingAudio)
cinematicTimingAssertEqual(cinematicTimingPlayer.status, "playing", "initial status")
cinematicTimingAssertEqual(cinematicTimingPlayer.frameNumber, 0, "initial frame")
cinematicTimingAssertEqual(cinematicTimingPlayer.pixels, bytes([0, 1, 0, 1]), "first Huffman frame")
cinematicTimingAssertEqual(len(cinematicTimingChunks), 1, "initial audio handoff")
cinematicTimingAssertEqual(cinematicTimingChunks[0].sampleCount, 1, "initial audio samples")

cinematicTimingRenderer = recording.createRecordingRenderer()
cinematicTimingRenderer.exports.Init(void, void)
cinematicTimingAssertEqual(cinplayer.draw(cinematicTimingPlayer, 640, 480,
  cinematicTimingRenderer.exports), true, "first frame draw")
cinematicTimingAssertEqual(len(cinematicTimingRenderer.state.palette), 768, "cinematic palette installed")
cinematicTimingAssertEqual(len(bytes(recording.commandTrace(cinematicTimingRenderer))) > 0, true, "renderer callback trace")

cinematicTimingAssertEqual(cinplayer.update(cinematicTimingPlayer, 1071), false, "before 14-fps boundary")
cinematicTimingAssertEqual(cinplayer.update(cinematicTimingPlayer, 1072), true, "after 14-fps boundary")
cinematicTimingAssertEqual(cinematicTimingPlayer.frameNumber, 1, "second frame")
cinematicTimingAssertEqual(cinematicTimingPlayer.pixels, bytes([1, 0, 1, 0]), "second Huffman frame")
cinematicTimingAssertEqual(len(cinematicTimingChunks), 2, "second audio handoff")

cinematicTimingAssertEqual(cinplayer.pause(cinematicTimingPlayer, 1080), true, "pause")
cinematicTimingAssertEqual(cinplayer.update(cinematicTimingPlayer, 2000), false, "paused update")
cinematicTimingAssertEqual(cinematicTimingPlayer.frameNumber, 1, "paused frame retained")
cinematicTimingAssertEqual(cinplayer.resume(cinematicTimingPlayer, 2000), true, "resume")
cinematicTimingAssertEqual(cinplayer.update(cinematicTimingPlayer, 2063), true, "completion boundary")
cinematicTimingAssertEqual(cinematicTimingPlayer.status, "completed", "completion status")
cinematicTimingAssertEqual(cinematicTimingPlayer.completions, 1, "completion count")
cinematicTimingAssertEqual(cinplayer.draw(cinematicTimingPlayer, 640, 480,
  cinematicTimingRenderer.exports), false, "completed draw")
cinematicTimingAssertEqual(cinematicTimingRenderer.state.palette, void, "game palette restored")

// Looping returns to frame zero and emits its PCM again without recursion.
cinematicTimingChunks = []
cinematicLoopPlayer = cinplayer.start(cinematicTimingData, 0, true, cinematicTimingAudio)
cinplayer.update(cinematicLoopPlayer, 72)
cinplayer.update(cinematicLoopPlayer, 143)
cinematicTimingAssertEqual(cinematicLoopPlayer.status, "playing", "loop remains active")
cinematicTimingAssertEqual(cinematicLoopPlayer.completions, 1, "loop completion count")
cinematicTimingAssertEqual(cinematicLoopPlayer.frameNumber, 0, "loop returns to first frame")
cinematicTimingAssertEqual(len(cinematicTimingChunks), 3, "loop audio handoffs")

// Late callers advance by one stream frame and rebase, matching Quake II's
// frame-drop behavior instead of consuming an unbounded catch-up burst.
cinematicDropPlayer = cinplayer.start(cinematicTimingData, 0, false, cinaudio.silent())
cinplayer.update(cinematicDropPlayer, 500)
cinematicTimingAssertEqual(cinematicDropPlayer.frameNumber, 1, "late update advances once")
cinematicTimingAssertEqual(cinematicDropPlayer.droppedFrames, 6, "late frame accounting")
cinematicTimingAssertEqual(cinplayer.stop(cinematicLoopPlayer), true, "explicit stop")
cinematicTimingAssertEqual(cinplayer.isFinished(cinematicLoopPlayer), true, "stopped is finished")
cinematicTimingRenderer.exports.Shutdown()
print("MiniQuake2 client cinematic playback tests passed: 1")

