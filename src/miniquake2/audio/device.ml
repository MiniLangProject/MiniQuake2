/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Native PCM queue used by the MiniLang Quake II mixer. */
package miniquake2.audio.device

import miniquake2.native as native

// Store device data.
struct Device
  sampleRate
  channels
  bitsPerSample
  open
end struct

// Open state.
function open(sampleRate, channels, bitsPerSample)
  if sampleRate < 8000 or sampleRate > 192000 then return error(2930, "sample rate outside range") end if
  if channels != 1 and channels != 2 then return error(2931, "unsupported channel count") end if
  if bitsPerSample != 8 and bitsPerSample != 16 then return error(2932, "unsupported PCM width") end if
  if native.audioOpen(sampleRate, channels, bitsPerSample) == 0 then return error(2933, "audio device open failed") end if
  return Device(sampleRate, channels, bitsPerSample, true)
end function

// Submit state.
function submit(device, samples)
  if device.open == false then return error(2934, "audio device is closed") end if
  if typeof(samples) != "bytes" then return error(2935, "PCM samples must be bytes") end if
  return native.audioSubmit(samples, len(samples))
end function

// Report whether queued.
function queued(device)
  if device.open == false then return 0 end if
  return native.audioQueued()
end function

// Report whether submitted.
function submitted(device)
  if device.open == false then return 0 end if
  return native.audioSubmitted()
end function

// Report whether completed.
function completed(device)
  if device.open == false then return 0 end if
  return native.audioCompleted()
end function

// Return the underruns value.
function underruns(device)
  if device is void then return 0 end if
  return native.audioUnderruns()
end function

// Return the capacity value.
function capacity(device)
  if device.open == false then return 0 end if
  return native.audioCapacity()
end function

// Reset state.
function reset(device)
  if device.open == false then return false end if
  return native.audioReset() != 0
end function

// Close state.
function close(device)
  if device.open then native.audioClose(); device.open = false end if
  return true
end function
