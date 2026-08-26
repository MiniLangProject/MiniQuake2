/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Static PCX intermission palette, drawing and stop lifecycle. */
import miniquake2.qcommon.byteio as picturetestbio
import miniquake2.client.cinematic.picture as picturetestplayer
import miniquake2.renderer.recording as picturetestrecording

function pictureTestAssert(value, name)
  if not value then return error(8369, name) end if
  return true
end function

function pictureTestData(withPalette)
  pictureTestSize = 128 + 4
  if withPalette then pictureTestSize = pictureTestSize + 769 end if
  pictureTestBytes = bytes(pictureTestSize)
  pictureTestBytes[0] = 10; pictureTestBytes[1] = 5
  pictureTestBytes[2] = 1; pictureTestBytes[3] = 8
  picturetestbio.putU16(pictureTestBytes, 8, 1)
  picturetestbio.putU16(pictureTestBytes, 10, 1)
  pictureTestBytes[65] = 1
  picturetestbio.putU16(pictureTestBytes, 66, 2)
  pictureTestBytes[128] = 1; pictureTestBytes[129] = 2
  pictureTestBytes[130] = 3; pictureTestBytes[131] = 4
  if withPalette then
    pictureTestBytes[len(pictureTestBytes) - 769] = 12
    pictureTestBytes[len(pictureTestBytes) - 768 + 3] = 255
  end if
  return pictureTestBytes
end function

pictureTestPlayback = picturetestplayer.start(pictureTestData(true))
pictureTestRenderer = picturetestrecording.createRecordingRenderer()
pictureTestRenderer.exports.Init(void, void)
pictureTestAssert(picturetestplayer.draw(pictureTestPlayback, 640, 480,
  pictureTestRenderer.exports), "picture did not draw")
pictureTestSawRaw = false
for each pictureTestCommand in pictureTestRenderer.state.commands
  if pictureTestCommand.operation == "DrawStretchRaw" then pictureTestSawRaw = true end if
end for
pictureTestAssert(pictureTestPlayback.paletteActive and
  len(pictureTestRenderer.state.palette) == 768 and
  pictureTestSawRaw, "picture renderer handoff")
pictureTestAssert(picturetestplayer.stop(pictureTestPlayback), "picture stop")
pictureTestAssert(not picturetestplayer.draw(pictureTestPlayback, 640, 480,
  pictureTestRenderer.exports) and pictureTestRenderer.state.palette is void,
  "picture palette restored")
pictureTestAssert(try(picturetestplayer.start(pictureTestData(false))) is error,
  "palette-less intermission rejected")
pictureTestRenderer.exports.Shutdown()
print("client_picture_playback_tests: PASS")
