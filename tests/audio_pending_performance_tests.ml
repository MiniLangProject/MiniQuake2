/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Delayed playsound hot-path benchmark and ordering regression. */
import miniquake2.audio.wav as pendingperfavaw
import miniquake2.audio.mixer as pendingperfamix
import miniquake2.platform.system as pendingperfsystem

function pendingPerfAssert(value, message)
  if not value then return error(9985, message) end if
  return true
end function

pendingPerfSound = pendingperfavaw.WavSound("perf/delayed.wav", 44100, 1, 1,
  4, -1, bytes([128, 128, 128, 128]))
pendingPerfMixer = pendingperfamix.create(44100)
pendingPerfIndex = 0
while pendingPerfIndex < pendingperfamix.MAX_PLAYSOUNDS
  pendingperfamix.startSoundAt(pendingPerfMixer, pendingPerfSound,
    pendingPerfIndex + 2, 0, 255, 255, 1000000 + pendingPerfIndex)
  pendingPerfIndex = pendingPerfIndex + 1
end while
pendingPerfClock = pendingperfsystem.createClock()
pendingPerfStarted = pendingperfsystem.counter(pendingPerfClock)
pendingPerfIteration = 0
while pendingPerfIteration < 5
  pendingPerfOutput = pendingperfamix.mixReusable(pendingPerfMixer, 65536)
  pendingPerfAssert(pendingPerfOutput[0] == 0 and
    pendingPerfOutput[len(pendingPerfOutput) - 1] == 0,
    "future playsounds produced PCM before their paint boundary")
  pendingPerfIteration = pendingPerfIteration + 1
end while
pendingPerfElapsed = pendingperfsystem.counter(pendingPerfClock) - pendingPerfStarted
pendingPerfMilliseconds = pendingPerfElapsed * 1000 / pendingPerfClock.frequency
pendingPerfAssert(len(pendingPerfMixer.pendingSounds) ==
  pendingperfamix.MAX_PLAYSOUNDS, "future playsound queue changed")
print "audio_pending_performance_tests: PASS frames=327680 pending=128 milliseconds=" +
  pendingPerfMilliseconds
