//! Provides miniquake2 client cinematic types facilities for this project.

/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Deterministic state and callback records for Quake II CIN playback. */
package miniquake2.client.cinematic.types

/// Store audio chunk data.
struct AudioChunk
  /// Stores the sample rate value associated with audio chunk.
  sampleRate
  /// Stores the sample width value associated with audio chunk.
  sampleWidth
  /// Stores the channels value associated with audio chunk.
  channels
  /// Stores the sample count value associated with audio chunk.
  sampleCount
  /// Stores the data value associated with audio chunk.
  data
end struct

/// Store audio callbacks data.
struct AudioCallbacks
  /// Stores the submit value associated with audio callbacks.
  submit
  /// Stores the pause value associated with audio callbacks.
  pause
  /// Stores the resume value associated with audio callbacks.
  resume
  /// Stores the stop value associated with audio callbacks.
  stop
end struct

/// Store mixer adapter data.
struct MixerAdapter
  /// Stores the mixer value associated with mixer adapter.
  mixer
  /// Stores the sound value associated with mixer adapter.
  sound
  /// Stores the channel value associated with mixer adapter.
  channel
  /// Stores the sample rate value associated with mixer adapter.
  sampleRate
  /// Stores the sample width value associated with mixer adapter.
  sampleWidth
  /// Stores the channels value associated with mixer adapter.
  channels
  /// Stores the resume active value associated with mixer adapter.
  resumeActive
end struct

/// Store mixer handoff data.
struct MixerHandoff
  /// Stores the adapter value associated with mixer handoff.
  adapter
  /// Stores the callbacks value associated with mixer handoff.
  callbacks
end struct

/// Store playback data.
struct Playback
  /// Stores the data value associated with playback.
  data
  /// Stores the header value associated with playback.
  header
  /// Stores the tables value associated with playback.
  tables
  /// Stores the offset value associated with playback.
  offset
  /// Stores the frame number value associated with playback.
  frameNumber
  /// Stores the pixels value associated with playback.
  pixels
  /// Stores the palette value associated with playback.
  palette
  /// Stores the status value associated with playback.
  status
  /// Stores the start time value associated with playback.
  startTime
  /// Stores the pause time value associated with playback.
  pauseTime
  /// Stores the looping value associated with playback.
  looping
  /// Stores the completions value associated with playback.
  completions
  /// Stores the dropped frames value associated with playback.
  droppedFrames
  /// Stores the palette dirty value associated with playback.
  paletteDirty
  /// Stores the palette active value associated with playback.
  paletteActive
  /// Stores the audio value associated with playback.
  audio
end struct
