//! Provides miniquake2 audio device facilities for this project.

/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Native PCM queue used by the MiniLang Quake II mixer. */
package miniquake2.audio.device

import miniquake2.native as native

/// Store device data.
struct Device
  /// Stores the sample rate value associated with device.
  sampleRate
  /// Stores the channels value associated with device.
  channels
  /// Stores the bits per sample value associated with device.
  bitsPerSample
  /// Stores the open value associated with device.
  open
end struct

/// Opens open for the miniquake2 audio device module.
/// @param sampleRate sampleRate value consumed by this operation.
/// @param channels channels value consumed by this operation.
/// @param bitsPerSample bitsPerSample value consumed by this operation.
function open(sampleRate, channels, bitsPerSample)
  if sampleRate < 8000 or sampleRate > 192000 then return error(2930, "sample rate outside range") end if
  if channels != 1 and channels != 2 then return error(2931, "unsupported channel count") end if
  if bitsPerSample != 8 and bitsPerSample != 16 then return error(2932, "unsupported PCM width") end if
  if native.audioOpen(sampleRate, channels, bitsPerSample) == 0 then return error(2933, "audio device open failed") end if
  return Device(sampleRate, channels, bitsPerSample, true)
end function

/// Submit state.
/// @param device device value consumed by this operation.
/// @param samples samples value consumed by this operation.
function submit(device, samples)
  if device.open == false then return error(2934, "audio device is closed") end if
  if typeof(samples) != "bytes" then return error(2935, "PCM samples must be bytes") end if
  return native.audioSubmit(samples, len(samples))
end function

/// Report whether queued.
/// @param device device value consumed by this operation.
function queued(device)
  if device.open == false then return 0 end if
  return native.audioQueued()
end function

/// Report whether submitted.
/// @param device device value consumed by this operation.
function submitted(device)
  if device.open == false then return 0 end if
  return native.audioSubmitted()
end function

/// Report whether completed.
/// @param device device value consumed by this operation.
function completed(device)
  if device.open == false then return 0 end if
  return native.audioCompleted()
end function

/// Return the underruns value.
/// @param device device value consumed by this operation.
function underruns(device)
  if device is void then return 0 end if
  return native.audioUnderruns()
end function

/// Return the capacity value.
/// @param device device value consumed by this operation.
function capacity(device)
  if device.open == false then return 0 end if
  return native.audioCapacity()
end function

/// Performs the reset operation for the miniquake2 audio device module.
/// @param device device value consumed by this operation.
function reset(device)
  if device.open == false then return false end if
  return native.audioReset() != 0
end function

/// Close state.
/// @param device device value consumed by this operation.
function close(device)
  if device.open then native.audioClose(); device.open = false end if
  return true
end function
