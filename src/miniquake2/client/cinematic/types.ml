/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Deterministic state and callback records for Quake II CIN playback. */
package miniquake2.client.cinematic.types

struct AudioChunk
  sampleRate
  sampleWidth
  channels
  sampleCount
  data
end struct

struct AudioCallbacks
  submit
  pause
  resume
  stop
end struct

struct MixerAdapter
  mixer
  sound
  channel
  sampleRate
  sampleWidth
  channels
  resumeActive
end struct

struct MixerHandoff
  adapter
  callbacks
end struct

struct Playback
  data
  header
  tables
  offset
  frameNumber
  pixels
  palette
  status
  startTime
  pauseTime
  looping
  completions
  droppedFrames
  paletteDirty
  paletteActive
  audio
end struct
