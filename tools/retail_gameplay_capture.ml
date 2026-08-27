/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Standalone entry point for full product level-start gallery captures. */

import miniquake2.runtime.application as gameplaycaptureapplication
import miniquake2.qcommon.byteio as gameplaycapturebyteio

// Print the supported retail gameplay-capture invocation.
function gameplayCaptureUsage()
  print "usage: retail_gameplay_capture ROOT MAP OUTPUT.tga [FRAMES]"
  print "default: FRAMES=120"
  return 2
end function

// Capture one complete gameplay framebuffer and report its stable identity.
function main(args)
  if len(args) < 3 or len(args) > 4 then return gameplayCaptureUsage() end if
  gameplayCaptureFrames = 120
  if len(args) == 4 then
    gameplayCaptureFrames = gameplaycapturebyteio.truncInt(toNumber(args[3]))
  end if
  gameplayCaptureResult = gameplaycaptureapplication.captureLevelStart(
    args[0], args[1], args[2], gameplayCaptureFrames)
  print "MiniQuake2 gameplay capture: PASS"
  print "  map=" + args[1] + " output=" + args[2]
  print "  size=" + gameplayCaptureResult[2] + "x" +
    gameplayCaptureResult[3] + " frames=" + gameplayCaptureResult[0]
  print "  checksum-fnv1a=" + gameplayCaptureResult[1] +
    " missing-assets=" + gameplayCaptureResult[4]
  return 0
end function
