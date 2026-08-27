/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Deterministic state and callback records for Quake II CIN playback. */
package miniquake2.client.cinematic.types

// Store audio chunk data.
struct AudioChunk
  sampleRate
  sampleWidth
  channels
  sampleCount
  data
end struct

// Store audio callbacks data.
struct AudioCallbacks
  submit
  pause
  resume
  stop
end struct

// Store mixer adapter data.
struct MixerAdapter
  mixer
  sound
  channel
  sampleRate
  sampleWidth
  channels
  resumeActive
end struct

// Store mixer handoff data.
struct MixerHandoff
  adapter
  callbacks
end struct

// Store playback data.
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
