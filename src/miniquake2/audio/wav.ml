/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Strict RIFF/WAVE PCM loader compatible with Quake II's sound cache needs. */
package miniquake2.audio.wav

import miniquake2.qcommon.byteio as awbio

struct WavSound
  name
  sampleRate
  channels
  width
  sampleCount
  loopStart
  pcm
end struct

function chunkName(data, offset)
  value = decode(slice(data, offset, 4))
  if value is void then return error(2940, "invalid WAV chunk id") end if
  return value
end function

function parse(data, name)
  if typeof(data) != "bytes" or len(data) < 12 then return error(2941, "WAV header truncated") end if
  if chunkName(data, 0) != "RIFF" or chunkName(data, 8) != "WAVE" then return error(2942, "WAV RIFF/WAVE signature mismatch") end if
  riffSize = awbio.u32(data, 4)
  if riffSize > len(data) - 8 then return error(2943, "WAV RIFF size exceeds file") end if
  formatFound = false
  dataFound = false
  sampleRate = 0
  channels = 0
  width = 0
  pcm = void
  loopStart = -1
  offset = 12
  while offset + 8 <= len(data)
    id = chunkName(data, offset)
    chunkSize = awbio.u32(data, offset + 4)
    payload = offset + 8
    if chunkSize > len(data) - payload then return error(2944, "WAV chunk exceeds file") end if
    if id == "fmt " then
      if chunkSize < 16 then return error(2945, "WAV fmt chunk truncated") end if
      if awbio.u16(data, payload) != 1 then return error(2946, "only PCM WAV is supported") end if
      channels = awbio.u16(data, payload + 2)
      sampleRate = awbio.u32(data, payload + 4)
      bits = awbio.u16(data, payload + 14)
      if channels != 1 and channels != 2 then return error(2947, "WAV channel count unsupported") end if
      if bits != 8 and bits != 16 then return error(2948, "WAV sample width unsupported") end if
      width = awbio.truncInt(bits / 8)
      formatFound = true
    else if id == "cue " and chunkSize >= 28 then
      cueCount = awbio.u32(data, payload)
      if cueCount > 0 then loopStart = awbio.u32(data, payload + 24) end if
    else if id == "data" then
      pcm = slice(data, payload, chunkSize)
      dataFound = true
    end if
    offset = payload + chunkSize
    if (chunkSize & 1) != 0 then offset = offset + 1 end if
  end while
  if not formatFound or not dataFound then return error(2949, "WAV requires fmt and data chunks") end if
  if sampleRate < 1 or width < 1 then return error(2950, "invalid WAV format") end if
  frameBytes = channels * width
  if len(pcm) % frameBytes != 0 then return error(2951, "WAV data is not whole sample frames") end if
  sampleCount = awbio.truncInt(len(pcm) / frameBytes)
  if loopStart >= sampleCount then return error(2952, "WAV loop start outside samples") end if
  return WavSound(name, sampleRate, channels, width, sampleCount, loopStart, pcm)
end function
