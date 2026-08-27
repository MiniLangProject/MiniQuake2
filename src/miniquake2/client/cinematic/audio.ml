/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Raw CIN PCM handoff and append-only bridge into the managed audio mixer. */
package miniquake2.client.cinematic.audio

import miniquake2.qcommon.byteio as qbio
import miniquake2.audio.mixer as amixer
import miniquake2.audio.wav as awav
import miniquake2.client.cinematic.types as cintypes

// Ignore chunk.
function ignoreChunk(chunk)
  return true
end function

// Ignore lifecycle.
function ignoreLifecycle()
  return true
end function

// Return the callbacks value.
function callbacks(submit)
  if typeof(submit) != "function" then return error(8330, "cinematic audio submit callback must be a function") end if
  return cintypes.AudioCallbacks(submit, ignoreLifecycle, ignoreLifecycle, ignoreLifecycle)
end function

// Report whether silent.
function silent()
  return callbacks(ignoreChunk)
end function

// Append bytes.
function appendBytes(first, second)
  output = bytes(len(first) + len(second))
  if len(first) > 0 then qbio.copyInto(output, 0, first, 0, len(first)) end if
  if len(second) > 0 then qbio.copyInto(output, len(first), second, 0, len(second)) end if
  return output
end function

// Create mixer adapter.
function createMixerAdapter(mixer)
  if mixer is void then return error(8331, "cinematic mixer adapter requires a mixer") end if
  return cintypes.MixerAdapter(mixer, void, void, 0, 0, 0, false)
end function

// Submit to mixer.
function submitToMixer(adapter, chunk)
  if chunk.sampleRate <= 0 or chunk.sampleRate > 192000 or
      (chunk.sampleWidth != 1 and chunk.sampleWidth != 2) or
      (chunk.channels != 1 and chunk.channels != 2) then
    return error(8334, "cinematic audio chunk format is invalid")
  end if
  if chunk.sampleCount < 0 or len(chunk.data) != chunk.sampleCount * chunk.sampleWidth * chunk.channels then
    return error(8332, "cinematic audio chunk size mismatch")
  end if
  if adapter.sound is void then
    adapter.sampleRate = chunk.sampleRate
    adapter.sampleWidth = chunk.sampleWidth
    adapter.channels = chunk.channels
    adapter.sound = awav.WavSound("cinematic", chunk.sampleRate, chunk.channels,
      chunk.sampleWidth, chunk.sampleCount, -1, bytes(chunk.data))
    adapter.channel = amixer.startSound(adapter.mixer, adapter.sound, -1, 255, 255, 255)
  else
    if chunk.sampleRate != adapter.sampleRate or chunk.sampleWidth != adapter.sampleWidth or chunk.channels != adapter.channels then
      return error(8333, "cinematic audio format changed during stream")
    end if
    // Mixer channel cursors use Q16 source frames so the 44.1-kHz hot path
    // stays allocation-free. Convert only at this low-frequency CIN append.
    consumed = adapter.channel.sourceFrame >> 16
    if consumed > adapter.sound.sampleCount then consumed = adapter.sound.sampleCount end if
    if consumed > 0 then
      frameBytes = adapter.sampleWidth * adapter.channels
      remaining = adapter.sound.sampleCount - consumed
      adapter.sound.pcm = slice(adapter.sound.pcm, consumed * frameBytes, remaining * frameBytes)
      adapter.sound.sampleCount = remaining
      adapter.channel.sourceFrame = adapter.channel.sourceFrame - (consumed << 16)
    end if
    adapter.sound.pcm = appendBytes(adapter.sound.pcm, chunk.data)
    adapter.sound.sampleCount = adapter.sound.sampleCount + chunk.sampleCount
    // If the mixer reached the previous end before this chunk arrived, its
    // sourceFrame still points at that boundary and playback can resume there.
    if adapter.channel.active == false then adapter.channel.active = true end if
  end if
  return chunk.sampleCount
end function

// Return the mixer handoff value.
function mixerHandoff(mixer)
  adapter = createMixerAdapter(mixer)
  function submit(chunk)
    return submitToMixer(adapter, chunk)
  end function
  function pauseStream()
    adapter.resumeActive = adapter.channel is not void and adapter.channel.active
    if adapter.channel is not void then adapter.channel.active = false end if
    return true
  end function
  function resumeStream()
    if adapter.channel is not void and adapter.resumeActive then adapter.channel.active = true end if
    adapter.resumeActive = false
    return true
  end function
  function stopStream()
    adapter.resumeActive = false
    return stopMixerAdapter(adapter)
  end function
  values = cintypes.AudioCallbacks(submit, pauseStream, resumeStream, stopStream)
  return cintypes.MixerHandoff(adapter, values)
end function

// Stop mixer adapter.
function stopMixerAdapter(adapter)
  if adapter.channel is not void then adapter.channel.active = false end if
  return true
end function
