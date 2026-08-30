/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Deterministic signed-16 stereo channel mixer and Quake-style spatializer. */
package miniquake2.audio.mixer

import std.math as ammath
import std.bytes as ambytes
import miniquake2.qcommon.byteio as ambio
import miniquake2.qcommon.filesystem as amfilesystem
import miniquake2.native as amnative

const MAX_CHANNELS = 32
const MAX_PLAYSOUNDS = 128
const MUSIC_DECODE_FRAMES = 4096
const MIX_FRAC_BITS = 16
const MIX_FRAC_ONE = 65536
const MIX_VOLUME_BITS = 16
const MIX_VOLUME_ONE = 65536

// Store channel data.
struct Channel
  sound
  entityNumber
  entityChannel
  sourceFrame
  sourceStep
  startFrame
  leftVolume
  rightVolume
  active
  looping
  autoSound
  spatialized
  masterVolume
  distanceMultiplier
  fixedOrigin
  origin
end struct

// Store music track data.
struct MusicTrack
  number
  source
  samples
  rate
  channels
  frames
  position
  sourceStep
  looping
  playing
  paused
  sampleBase
  sampleFrames
end struct

// Store mixer data.
struct Mixer
  sampleRate
  channels
  pendingSounds
  pendingSoundQueue
  pendingSoundCount
  retainPendingView
  paintedFrames
  masterVolume
  masterVolumeFixed
  listenerEntityNumber
  music
  musicVolume
  musicVolumeFixed
  outputScratch
end struct

// Create state.
function create(sampleRate)
  if sampleRate < 8000 or sampleRate > 192000 then return error(2955, "mixer sample rate outside range") end if
  return Mixer(sampleRate, [], [], array(MAX_PLAYSOUNDS, void), 0, true,
    0, 1.0, MIX_VOLUME_ONE, -1,
    void, 0.5, MIX_VOLUME_ONE / 2, bytes())
end function

// Disable the compact compatibility view in latency-sensitive product paths.
// The fixed queue remains authoritative and avoids copying every future sound
// whenever a new playsound is inserted or issued.
function enableOptimizedStorage(mixer)
  if mixer is void then return false end if
  mixer.retainPendingView = false
  mixer.pendingSounds = []
  return true
end function

// Return the number of pending sounds without exposing queue capacity.
function pendingCount(mixer)
  if mixer is void then return 0 end if
  return mixer.pendingSoundCount
end function

// Return one pending sound from the authoritative fixed queue.
function pendingAt(mixer, index)
  if mixer is void or typeof(index) != "int" or index < 0 or
      index >= mixer.pendingSoundCount then return void end if
  return mixer.pendingSoundQueue[index]
end function

// Rebuild the legacy compact view only for component tests and API clients
// that explicitly retain it. Product mixers disable this allocation path.
function refreshPendingView(mixer)
  if not mixer.retainPendingView then return false end if
  view = array(mixer.pendingSoundCount)
  index = 0
  while index < mixer.pendingSoundCount
    view[index] = mixer.pendingSoundQueue[index]
    index = index + 1
  end while
  mixer.pendingSounds = view
  return true
end function

// Set music volume.
function setMusicVolume(mixer, value)
  if mixer is void or (typeof(value) != "int" and typeof(value) != "float") or
      value != value or value < 0.0 or value > 1.0 then
    return error(2960, "music volume outside [0,1]")
  end if
  mixer.musicVolume = value * 1.0
  mixer.musicVolumeFixed = ambio.truncInt(value * MIX_VOLUME_ONE)
  return mixer.musicVolume
end function

// Stop music.
function stopMusic(mixer)
  if mixer is void then return false end if
  if mixer.music is not void then amnative.oggClose() end if
  mixer.music = void
  return true
end function

// Pause music.
function pauseMusic(mixer)
  if mixer is void or mixer.music is void or not mixer.music.playing then return false end if
  mixer.music.paused = true
  return true
end function

// Resume music.
function resumeMusic(mixer)
  if mixer is void or mixer.music is void or not mixer.music.playing then return false end if
  mixer.music.paused = false
  return true
end function

// Play music.
function playMusic(mixer, filesystem, track, looping)
  // Keep play music phases explicit: validate inputs, update owned state, then publish the result.
  if mixer is void or filesystem is void then return error(2961, "music mixer/filesystem unavailable") end if
  if typeof(track) != "int" or track < 1 or track > 99 then
    return error(2962, "music track outside [1,99]")
  end if
  if typeof(looping) != "bool" then return error(2963, "music loop state must be boolean") end if
  if mixer.music is not void and mixer.music.number == track and mixer.music.playing then
    mixer.music.looping = looping
    mixer.music.paused = false
    return true
  end if
  stopMusic(mixer)
  source = bytes()
  path = amfilesystem.musicTrackPath(filesystem, track)
  opened = 0
  if path != "" then opened = amnative.oggOpenFile(path)
  else
    sourceResult = try(amfilesystem.readMusicTrack(filesystem, track))
    if sourceResult is error then return sourceResult end if
    source = sourceResult
    opened = amnative.oggOpen(source, len(source))
  end if
  if opened == 0 then return error(2964, "invalid Ogg Vorbis music track " + track) end if
  rate = amnative.oggRate()
  channels = amnative.oggChannels()
  frames = amnative.oggFrames()
  if rate < 1 or channels < 1 or channels > 2 or frames < 1 or frames > 0x10000000 then
    amnative.oggClose()
    return error(2965, "unsupported Ogg Vorbis music track " + track)
  end if
  probe = bytes(MUSIC_DECODE_FRAMES * channels * 2)
  decoded = amnative.oggDecode(probe, MUSIC_DECODE_FRAMES)
  if decoded < 1 then
    amnative.oggClose()
    return error(2966, "Ogg Vorbis music decode failed for track " + track)
  end if
  sourceStep = ambio.truncInt(rate * MIX_FRAC_ONE / (mixer.sampleRate * 1.0))
  if sourceStep < 1 then sourceStep = 1 end if
  // Retain the validation decode as the first streaming block. Seeking and
  // decoding those same 4096 frames again on the first mix caused a visible
  // startup spike precisely when level presentation begins.
  mixer.music = MusicTrack(track, source, probe, rate, channels, frames,
    0, sourceStep, looping, true, false, 0, decoded)
  return true
end function

// Decode music chunk.
function decodeMusicChunk(track, restart)
  if restart then
    if amnative.oggSeekStart() == 0 then return false end if
    track.sampleBase = 0
  else
    track.sampleBase = track.sampleBase + track.sampleFrames
  end if
  pcmSize = MUSIC_DECODE_FRAMES * track.channels * 2
  pcm = track.samples
  if len(pcm) != pcmSize then pcm = bytes(pcmSize) end if
  decoded = amnative.oggDecode(pcm, MUSIC_DECODE_FRAMES)
  if decoded < 1 then track.sampleFrames = 0; return false end if
  track.samples = pcm
  track.sampleFrames = decoded
  return true
end function

// Synchronize music track.
function synchronizeMusicTrack(mixer, filesystem, configValue)
  if typeof(configValue) != "string" then return false end if
  parsed = try(toNumber(configValue))
  if parsed is error or
      (typeof(parsed) != "int" and typeof(parsed) != "float") then return false end if
  track = ambio.truncInt(parsed)
  if parsed != track then return false end if
  if track == 0 then return stopMusic(mixer) end if
  if track < 1 or track > 99 then return false end if
  return playMusic(mixer, filesystem, track, true)
end function

// Set listener entity.
function setListenerEntity(mixer, number)
  if mixer is void or typeof(number) != "int" or number < 1 then
    return error(2959, "mixer listener entity must be positive")
  end if
  mixer.listenerEntityNumber = number
  return number
end function

// Set master volume.
function setMasterVolume(mixer, value)
  if mixer is void or (typeof(value) != "int" and typeof(value) != "float") or
      value != value or value < 0.0 or value > 1.0 then
    return error(2958, "mixer master volume outside [0,1]")
  end if
  mixer.masterVolume = value * 1.0
  mixer.masterVolumeFixed = ambio.truncInt(value * MIX_VOLUME_ONE)
  return mixer.masterVolume
end function

// Clamp 16.
function inline clamp16(value)
  if value > 32767 then return 32767 end if
  if value < -32768 then return -32768 end if
  return value
end function

// Sample at.
function inline sampleAt(sound, frame, channel)
  if sound.channels == 1 then channel = 0 end if
  sampleIndex = frame * sound.channels + channel
  if sound.width == 1 then return (sound.pcm[sampleIndex] - 128) << 8 end if
  offset = sampleIndex * 2
  value = sound.pcm[offset] | (sound.pcm[offset + 1] << 8)
  if value >= 0x8000 then return value - 0x10000 end if
  return value
end function

// Divide 255 positive.
function inline divide255Positive(value)
  // Exact for every magnitude reachable from a signed-16 sample, an 8-bit
  // channel volume and the Q16 remainder expansion below.
  return (value * 8421505) >> 31
end function

// Scale channel sample fixed.
function inline scaleChannelSampleFixed(sample, volume)
  // Preserve /255 channel fractions in Q16. The old floating mixer summed
  // these fractions across channels and rounded only the final PCM sample;
  // truncating each channel independently changes deterministic replays.
  product = sample * volume
  negative = product < 0
  magnitude = product
  if negative then magnitude = -magnitude end if
  whole = divide255Positive(magnitude)
  remainder = magnitude - whole * 255
  fraction = divide255Positive(remainder << MIX_VOLUME_BITS)
  fixed = (whole << MIX_VOLUME_BITS) + fraction
  if negative then return -fixed end if
  return fixed
end function

// Return the channel life left value.
function inline channelLifeLeft(mixer, channel)
  waiting = channel.startFrame - mixer.paintedFrames
  if waiting < 0 then waiting = 0 end if
  remaining = channel.sound.sampleCount -
    (channel.sourceFrame >> MIX_FRAC_BITS)
  if remaining < 0 then remaining = 0 end if
  return waiting + ambio.truncInt(remaining * mixer.sampleRate /
    (channel.sound.sampleRate * 1.0))
end function

// S_PickChannel: explicit entity channels override themselves; otherwise the
// shortest-lived channel is replaced. A non-player sound may never evict a
// live channel owned by the view entity.
function pickChannelSlot(mixer, entityNumber, entityChannel)
  if entityChannel != 0 then
    index = 0
    while index < len(mixer.channels)
      channel = mixer.channels[index]
      if channel.active and channel.entityNumber == entityNumber and
          channel.entityChannel == entityChannel then return index end if
      index = index + 1
    end while
  end if
  index = 0
  while index < len(mixer.channels)
    if not mixer.channels[index].active then return index end if
    index = index + 1
  end while
  if len(mixer.channels) < MAX_CHANNELS then return len(mixer.channels) end if

  selected = -1
  shortest = 0x7fffffff
  index = 0
  while index < len(mixer.channels)
    channel = mixer.channels[index]
    protectedPlayer = channel.entityNumber == mixer.listenerEntityNumber and
      entityNumber != mixer.listenerEntityNumber
    if not protectedPlayer then
      lifeLeft = channelLifeLeft(mixer, channel)
      if lifeLeft < shortest then
        shortest = lifeLeft
        selected = index
      end if
    end if
    index = index + 1
  end while
  return selected
end function

// Start sound.
function startSound(mixer, sound, entityNumber, entityChannel, leftVolume, rightVolume)
  if leftVolume < 0 or leftVolume > 255 or rightVolume < 0 or rightVolume > 255 then return error(2956, "channel volume outside [0,255]") end if
  slot = pickChannelSlot(mixer, entityNumber, entityChannel)
  if slot < 0 then return void end if
  sourceStep = ambio.truncInt(sound.sampleRate * MIX_FRAC_ONE /
    (mixer.sampleRate * 1.0))
  if sourceStep < 1 then sourceStep = 1 end if
  channel = Channel(sound, entityNumber, entityChannel, 0, sourceStep,
    mixer.paintedFrames, leftVolume, rightVolume, true, false, false,
    false, 255.0, 0.0, false, void)
  // Reuse a finished slot. Sound events are frequent during combat and an
  // append-only channel array would otherwise retain and scan every expired
  // sound for the rest of the map.
  if slot < len(mixer.channels) then mixer.channels[slot] = channel
  else mixer.channels = mixer.channels + [channel]
  end if
  return channel
end function

// Start sound at.
function startSoundAt(mixer, sound, entityNumber, entityChannel, leftVolume,
    rightVolume, startFrame)
  if startFrame <= mixer.paintedFrames then
    return startSound(mixer, sound, entityNumber, entityChannel, leftVolume,
      rightVolume)
  end if
  if leftVolume < 0 or leftVolume > 255 or rightVolume < 0 or
      rightVolume > 255 then
    return error(2956, "channel volume outside [0,255]")
  end if
  if mixer.pendingSoundCount >= MAX_PLAYSOUNDS then return void end if
  sourceStep = ambio.truncInt(sound.sampleRate * MIX_FRAC_ONE /
    (mixer.sampleRate * 1.0))
  if sourceStep < 1 then sourceStep = 1 end if
  channel = Channel(sound, entityNumber, entityChannel, 0, sourceStep, startFrame,
    leftVolume, rightVolume, true, false, false, false, 255.0, 0.0,
    false, void)
  // Match S_StartSound's sorted pending list. New entries precede an existing
  // entry with the same begin frame, which also preserves stock replacement
  // order for equal-time sounds on the same entity channel.
  insertIndex = 0
  while insertIndex < mixer.pendingSoundCount and
      mixer.pendingSoundQueue[insertIndex].startFrame < startFrame
    insertIndex = insertIndex + 1
  end while
  moveIndex = mixer.pendingSoundCount
  while moveIndex > insertIndex
    mixer.pendingSoundQueue[moveIndex] = mixer.pendingSoundQueue[moveIndex - 1]
    moveIndex = moveIndex - 1
  end while
  mixer.pendingSoundQueue[insertIndex] = channel
  mixer.pendingSoundCount = mixer.pendingSoundCount + 1
  refreshPendingView(mixer)
  return channel
end function

// Report whether issue pending.
function issuePending(mixer, absoluteFrame)
  // startSoundAt keeps this queue ordered by startFrame.  Looking only at the
  // head avoids scanning every future sound for every painted sample.
  if mixer.pendingSoundCount == 0 or
      mixer.pendingSoundQueue[0].startFrame > absoluteFrame then return 0 end if
  dueCount = 0
  while dueCount < mixer.pendingSoundCount and
      mixer.pendingSoundQueue[dueCount].startFrame <= absoluteFrame
    dueCount = dueCount + 1
  end while
  issued = 0
  pendingIndex = 0
  while pendingIndex < dueCount
    pending = mixer.pendingSoundQueue[pendingIndex]
    slot = pickChannelSlot(mixer, pending.entityNumber,
      pending.entityChannel)
    if slot < 0 then pending.active = false
    else
      if slot < len(mixer.channels) then mixer.channels[slot] = pending
      else mixer.channels = mixer.channels + [pending]
      end if
      issued = issued + 1
    end if
    pendingIndex = pendingIndex + 1
  end while
  remainingCount = mixer.pendingSoundCount - dueCount
  pendingIndex = 0
  while pendingIndex < remainingCount
    mixer.pendingSoundQueue[pendingIndex] = mixer.pendingSoundQueue[pendingIndex + dueCount]
    pendingIndex = pendingIndex + 1
  end while
  while pendingIndex < mixer.pendingSoundCount
    pendingIndex = pendingIndex + 1
  end while
  mixer.pendingSoundCount = remainingCount
  refreshPendingView(mixer)
  return issued
end function

// Populate the spatial volumes destination.
function spatialVolumesInto(output, listenerOrigin, listenerRight, sourceOrigin,
    masterVolume, attenuation)
  dx = sourceOrigin.x - listenerOrigin.x
  dy = sourceOrigin.y - listenerOrigin.y
  dz = sourceOrigin.z - listenerOrigin.z
  distance = ammath.sqrt(dx * dx + dy * dy + dz * dz)
  dot = 0.0
  if distance > 0.0 then dot = (dx * listenerRight.x + dy * listenerRight.y + dz * listenerRight.z) / distance end if
  // S_SpatializeOrigin keeps an 80-unit full-volume radius and receives the
  // already-scaled dist_mult (normal one-shot sounds use 0.0005).  With no
  // attenuation Quake also disables stereo separation, making ATTN_NONE a
  // genuinely global sound instead of panning it toward the source.
  distance = distance - 80.0
  if distance < 0.0 then distance = 0.0 end if
  distanceScale = 1.0 - distance * attenuation
  if distanceScale < 0.0 then distanceScale = 0.0 end if
  leftScale = 1.0
  rightScale = 1.0
  if attenuation != 0.0 then
    leftScale = 0.5 * (1.0 - dot)
    rightScale = 0.5 * (1.0 + dot)
  end if
  left = masterVolume * distanceScale * leftScale
  right = masterVolume * distanceScale * rightScale
  if left > 255.0 then left = 255.0 end if
  if right > 255.0 then right = 255.0 end if
  if left < 0.0 then left = 0.0 end if
  if right < 0.0 then right = 0.0 end if
  output[0] = ambio.truncInt(left)
  output[1] = ambio.truncInt(right)
  return output
end function

// Return the spatial volumes value.
function spatialVolumes(listenerOrigin, listenerRight, sourceOrigin,
    masterVolume, attenuation)
  return spatialVolumesInto(array(2, 0), listenerOrigin, listenerRight,
    sourceOrigin, masterVolume, attenuation)
end function

// Paint exactly frameCount interleaved signed-16 stereo frames into caller-
// owned storage. Pending sounds are issued in timestamp order and every active
// channel advances once, preserving deterministic mixer time across reuse.
function mixInto(mixer, output, frameCount)
  if frameCount < 0 then return error(2957, "negative mix frame count") end if
  if typeof(output) != "bytes" or len(output) != frameCount * 4 then
    return error(2967, "mixer output buffer has the wrong size")
  end if
  // Fresh byte buffers are already zero-filled. Avoid 2,048 interpreted
  // sample writes per 1,024-frame block while no sound is active; this is the
  // common state while traversing quiet parts of a map or using the menus.
  hasActiveChannel = false
  for each activeChannel in mixer.channels
    if activeChannel.active then hasActiveChannel = true; break end if
  end for
  if mixer.pendingSoundCount > 0 then hasActiveChannel = true end if
  if mixer.music is not void and mixer.music.playing and
      not mixer.music.paused and mixer.musicVolume > 0.0 then
    hasActiveChannel = true
  end if
  if not hasActiveChannel then
    // Reusable product buffers can still contain the preceding sound block.
    // Clear them through the native bytes primitive instead of allocating a
    // fresh zero-filled value on every quiet frame.
    ambytes.fill(output, 0)
    mixer.paintedFrames = mixer.paintedFrames + frameCount
    return output
  end if
  track = mixer.music
  frameIndex = 0
  while frameIndex < frameCount
    paintedFrame = mixer.paintedFrames + frameIndex
    if mixer.pendingSoundCount > 0 then issuePending(mixer, paintedFrame) end if
    mixedLeft = 0
    mixedRight = 0
    for each channel in mixer.channels
      if channel.active and paintedFrame >= channel.startFrame then
        sourceIndex = channel.sourceFrame >> MIX_FRAC_BITS
        if sourceIndex >= channel.sound.sampleCount then
          if channel.looping then
            sourceIndex = 0
            channel.sourceFrame = 0
          else if channel.sound.loopStart >= 0 then
            sourceIndex = channel.sound.loopStart
            channel.sourceFrame = sourceIndex << MIX_FRAC_BITS
          else
            channel.active = false
          end if
        end if
        if channel.active then
          mixedLeft = mixedLeft + scaleChannelSampleFixed(
            sampleAt(channel.sound, sourceIndex, 0), channel.leftVolume)
          mixedRight = mixedRight + scaleChannelSampleFixed(
            sampleAt(channel.sound, sourceIndex, 1), channel.rightVolume)
          channel.sourceFrame = channel.sourceFrame + channel.sourceStep
        end if
      end if
    end for
    if track is not void and track.playing and not track.paused and
        mixer.musicVolume > 0.0 then
      sourceFrame = track.position >> MIX_FRAC_BITS
      if sourceFrame >= track.frames then
        if track.looping then
          track.position = 0
          sourceFrame = 0
          if not decodeMusicChunk(track, true) then track.playing = false end if
        else track.playing = false
        end if
      end if
      if track.playing and track.sampleFrames == 0 then
        if not decodeMusicChunk(track, track.sampleBase != 0) then track.playing = false end if
      end if
      while track.playing and sourceFrame >= track.sampleBase + track.sampleFrames
        if not decodeMusicChunk(track, false) then
          if track.looping then
            track.position = 0
            sourceFrame = 0
            if not decodeMusicChunk(track, true) then track.playing = false end if
          else track.playing = false
          end if
        end if
      end while
      if track.playing then
        chunkFrame = sourceFrame - track.sampleBase
        musicLeft = 0
        musicRight = 0
        if track.channels == 1 then
          sampleOffset = chunkFrame * 2
          musicLeft = track.samples[sampleOffset] |
            (track.samples[sampleOffset + 1] << 8)
          if musicLeft >= 0x8000 then musicLeft = musicLeft - 0x10000 end if
          musicRight = musicLeft
        else
          sampleOffset = chunkFrame * 4
          musicLeft = track.samples[sampleOffset] |
            (track.samples[sampleOffset + 1] << 8)
          musicRight = track.samples[sampleOffset + 2] |
            (track.samples[sampleOffset + 3] << 8)
          if musicLeft >= 0x8000 then musicLeft = musicLeft - 0x10000 end if
          if musicRight >= 0x8000 then musicRight = musicRight - 0x10000 end if
        end if
        mixedLeft = mixedLeft + musicLeft * mixer.musicVolumeFixed
        mixedRight = mixedRight + musicRight * mixer.musicVolumeFixed
        track.position = track.position + track.sourceStep
      end if
    end if
    mixedLeftScaled = mixedLeft * mixer.masterVolumeFixed
    mixedRightScaled = mixedRight * mixer.masterVolumeFixed
    if mixedLeftScaled < 0 then mixedLeft = -((-mixedLeftScaled) >> 32)
    else mixedLeft = mixedLeftScaled >> 32
    end if
    if mixedRightScaled < 0 then mixedRight = -((-mixedRightScaled) >> 32)
    else mixedRight = mixedRightScaled >> 32
    end if
    mixedLeft = clamp16(mixedLeft)
    mixedRight = clamp16(mixedRight)
    outputOffset = frameIndex * 4
    output[outputOffset] = mixedLeft & 255
    output[outputOffset + 1] = (mixedLeft >> 8) & 255
    output[outputOffset + 2] = mixedRight & 255
    output[outputOffset + 3] = (mixedRight >> 8) & 255
    frameIndex = frameIndex + 1
  end while
  mixer.paintedFrames = mixer.paintedFrames + frameCount
  return output
end function

// Mix state.
function mix(mixer, frameCount)
  if frameCount < 0 then return error(2957, "negative mix frame count") end if
  return mixInto(mixer, bytes(frameCount * 4), frameCount)
end function

// The waveOut bridge copies submitted PCM into its own ring.  The real-time
// product can therefore reuse one mixer-owned block and avoid a fresh bytes
// allocation (and later GC scan) for every audio submission.
function mixReusable(mixer, frameCount)
  if frameCount < 0 then return error(2957, "negative mix frame count") end if
  size = frameCount * 4
  if len(mixer.outputScratch) != size then mixer.outputScratch = bytes(size) end if
  return mixInto(mixer, mixer.outputScratch, frameCount)
end function

// EntityState.sound values are Quake "autosounds": they are rebuilt from the
// current snapshot every client frame and loop even when the WAV has no cue
// chunk.  Their phase follows painted time so a refreshed channel does not
// restart at sample zero on every rendered frame.
function clearAutoSounds(mixer)
  for each channel in mixer.channels
    if channel.autoSound then channel.active = false end if
  end for
  return true
end function

// Start auto sound.
function startAutoSound(mixer, sound, leftVolume, rightVolume)
  // S_AddLoopSounds rebuilds the logical autosound set every render frame.
  // Reuse one of the autosound Channel records disabled by clearAutoSounds;
  // allocating a replacement for every door/ambient loop every frame caused
  // avoidable GC spikes in both the renderer and the waveOut producer.
  channel = void
  for each reusable in mixer.channels
    if reusable.autoSound and not reusable.active then
      channel = reusable
      break
    end if
  end for
  if channel is void then
    channel = startSound(mixer, sound, 0, 0, leftVolume, rightVolume)
    if channel is void then return void end if
  else
    channel.sound = sound
    channel.entityNumber = 0
    channel.entityChannel = 0
    channel.sourceStep = ambio.truncInt(sound.sampleRate * MIX_FRAC_ONE /
      (mixer.sampleRate * 1.0))
    if channel.sourceStep < 1 then channel.sourceStep = 1 end if
    channel.startFrame = mixer.paintedFrames
    channel.leftVolume = leftVolume
    channel.rightVolume = rightVolume
    channel.active = true
    channel.spatialized = false
    channel.masterVolume = 255
    channel.distanceMultiplier = 0.0
    channel.fixedOrigin = false
    channel.origin = void
  end if
  channel.looping = true
  channel.autoSound = true
  if sound.sampleCount > 0 then
    phase = ambio.truncInt(mixer.paintedFrames * sound.sampleRate /
      (mixer.sampleRate * 1.0)) % sound.sampleCount
    channel.sourceFrame = phase << MIX_FRAC_BITS
  end if
  return channel
end function

// Stop all.
function stopAll(mixer)
  for each channel in mixer.channels
    channel.active = false
  end for
  pendingIndex = 0
  while pendingIndex < mixer.pendingSoundCount
    mixer.pendingSoundQueue[pendingIndex].active = false
    pendingIndex = pendingIndex + 1
  end while
  mixer.pendingSoundCount = 0
  mixer.pendingSounds = []
end function
