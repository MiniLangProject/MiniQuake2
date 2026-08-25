/* Deterministic signed-16 stereo channel mixer and Quake-style spatializer. */
package miniquake2.audio.mixer

import std.math as ammath
import miniquake2.qcommon.byteio as ambio
import miniquake2.qcommon.filesystem as amfilesystem
import miniquake2.native as amnative

const MAX_CHANNELS = 32
const MAX_PLAYSOUNDS = 128
const MUSIC_DECODE_FRAMES = 4096

struct Channel
  sound
  entityNumber
  entityChannel
  sourceFrame
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

struct MusicTrack
  number
  source
  samples
  rate
  channels
  frames
  position
  looping
  playing
  paused
  sampleBase
  sampleFrames
end struct

struct Mixer
  sampleRate
  channels
  pendingSounds
  paintedFrames
  masterVolume
  listenerEntityNumber
  music
  musicVolume
end struct

function create(sampleRate)
  if sampleRate < 8000 or sampleRate > 192000 then return error(2955, "mixer sample rate outside range") end if
  return Mixer(sampleRate, [], [], 0, 1.0, -1, void, 0.5)
end function

function setMusicVolume(mixer, value)
  if mixer is void or (typeof(value) != "int" and typeof(value) != "float") or
      value != value or value < 0.0 or value > 1.0 then
    return error(2960, "music volume outside [0,1]")
  end if
  mixer.musicVolume = value * 1.0
  return mixer.musicVolume
end function

function stopMusic(mixer)
  if mixer is void then return false end if
  if mixer.music is not void then amnative.oggClose() end if
  mixer.music = void
  return true
end function

function pauseMusic(mixer)
  if mixer is void or mixer.music is void or not mixer.music.playing then return false end if
  mixer.music.paused = true
  return true
end function

function resumeMusic(mixer)
  if mixer is void or mixer.music is void or not mixer.music.playing then return false end if
  mixer.music.paused = false
  return true
end function

function playMusic(mixer, filesystem, track, looping)
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
  if decoded < 1 or amnative.oggSeekStart() == 0 then
    amnative.oggClose()
    return error(2966, "Ogg Vorbis music decode failed for track " + track)
  end if
  mixer.music = MusicTrack(track, source, bytes(), rate, channels, frames,
    0, looping, true, false, 0, 0)
  return true
end function

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

function setListenerEntity(mixer, number)
  if mixer is void or typeof(number) != "int" or number < 1 then
    return error(2959, "mixer listener entity must be positive")
  end if
  mixer.listenerEntityNumber = number
  return number
end function

function setMasterVolume(mixer, value)
  if mixer is void or (typeof(value) != "int" and typeof(value) != "float") or
      value != value or value < 0.0 or value > 1.0 then
    return error(2958, "mixer master volume outside [0,1]")
  end if
  mixer.masterVolume = value * 1.0
  return mixer.masterVolume
end function

function inline clamp16(value)
  if value > 32767 then return 32767 end if
  if value < -32768 then return -32768 end if
  return value
end function

function inline sampleAt(sound, frame, channel)
  if sound.channels == 1 then channel = 0 end if
  sampleIndex = frame * sound.channels + channel
  if sound.width == 1 then return (sound.pcm[sampleIndex] - 128) << 8 end if
  return ambio.i16(sound.pcm, sampleIndex * 2)
end function

function inline channelLifeLeft(mixer, channel)
  waiting = channel.startFrame - mixer.paintedFrames
  if waiting < 0 then waiting = 0 end if
  remaining = channel.sound.sampleCount - channel.sourceFrame
  if remaining < 0.0 then remaining = 0.0 end if
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

function startSound(mixer, sound, entityNumber, entityChannel, leftVolume, rightVolume)
  if leftVolume < 0 or leftVolume > 255 or rightVolume < 0 or rightVolume > 255 then return error(2956, "channel volume outside [0,255]") end if
  slot = pickChannelSlot(mixer, entityNumber, entityChannel)
  if slot < 0 then return void end if
  channel = Channel(sound, entityNumber, entityChannel, 0.0,
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
  if len(mixer.pendingSounds) >= MAX_PLAYSOUNDS then return void end if
  channel = Channel(sound, entityNumber, entityChannel, 0.0, startFrame,
    leftVolume, rightVolume, true, false, false, false, 255.0, 0.0,
    false, void)
  // Match S_StartSound's sorted pending list. New entries precede an existing
  // entry with the same begin frame, which also preserves stock replacement
  // order for equal-time sounds on the same entity channel.
  pending = array(len(mixer.pendingSounds) + 1)
  sourceIndex = 0
  outputIndex = 0
  inserted = false
  while sourceIndex < len(mixer.pendingSounds)
    if not inserted and mixer.pendingSounds[sourceIndex].startFrame >= startFrame then
      pending[outputIndex] = channel
      outputIndex = outputIndex + 1
      inserted = true
    end if
    pending[outputIndex] = mixer.pendingSounds[sourceIndex]
    outputIndex = outputIndex + 1
    sourceIndex = sourceIndex + 1
  end while
  if not inserted then pending[outputIndex] = channel end if
  mixer.pendingSounds = pending
  return channel
end function

function issuePending(mixer, absoluteFrame)
  due = false
  for each pending in mixer.pendingSounds
    if pending.startFrame <= absoluteFrame then due = true; break end if
  end for
  if not due then return 0 end if
  remaining = array(len(mixer.pendingSounds))
  remainingCount = 0
  issued = 0
  for each pending in mixer.pendingSounds
    if pending.startFrame <= absoluteFrame then
      slot = pickChannelSlot(mixer, pending.entityNumber,
        pending.entityChannel)
      if slot < 0 then pending.active = false
      else
        if slot < len(mixer.channels) then mixer.channels[slot] = pending
        else mixer.channels = mixer.channels + [pending]
        end if
        issued = issued + 1
      end if
    else
      remaining[remainingCount] = pending
      remainingCount = remainingCount + 1
    end if
  end for
  if remainingCount == 0 then mixer.pendingSounds = []
  else if remainingCount == len(remaining) then mixer.pendingSounds = remaining
  else
    compact = array(remainingCount)
    index = 0
    while index < remainingCount
      compact[index] = remaining[index]
      index = index + 1
    end while
    mixer.pendingSounds = compact
  end if
  return issued
end function

function spatialVolumes(listenerOrigin, listenerRight, sourceOrigin, masterVolume, attenuation)
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
  return [ambio.truncInt(left), ambio.truncInt(right)]
end function

function mix(mixer, frameCount)
  if frameCount < 0 then return error(2957, "negative mix frame count") end if
  output = bytes(frameCount * 4)
  // Fresh byte buffers are already zero-filled. Avoid 2,048 interpreted
  // sample writes per 1,024-frame block while no sound is active; this is the
  // common state while traversing quiet parts of a map or using the menus.
  hasActiveChannel = false
  for each activeChannel in mixer.channels
    if activeChannel.active then hasActiveChannel = true; break end if
  end for
  if len(mixer.pendingSounds) > 0 then hasActiveChannel = true end if
  if mixer.music is not void and mixer.music.playing and
      not mixer.music.paused and mixer.musicVolume > 0.0 then
    hasActiveChannel = true
  end if
  if not hasActiveChannel then
    mixer.paintedFrames = mixer.paintedFrames + frameCount
    return output
  end if
  frameIndex = 0
  while frameIndex < frameCount
    issuePending(mixer, mixer.paintedFrames + frameIndex)
    mixedLeft = 0
    mixedRight = 0
    for each channel in mixer.channels
      if channel.active and mixer.paintedFrames + frameIndex >= channel.startFrame then
        sourceIndex = ambio.truncInt(channel.sourceFrame)
        if sourceIndex >= channel.sound.sampleCount then
          if channel.looping then
            sourceIndex = 0
            channel.sourceFrame = 0.0
          else if channel.sound.loopStart >= 0 then
            sourceIndex = channel.sound.loopStart
            channel.sourceFrame = sourceIndex * 1.0
          else
            channel.active = false
          end if
        end if
        if channel.active then
          mixedLeft = mixedLeft + sampleAt(channel.sound, sourceIndex, 0) * channel.leftVolume / 255
          mixedRight = mixedRight + sampleAt(channel.sound, sourceIndex, 1) * channel.rightVolume / 255
          channel.sourceFrame = channel.sourceFrame + channel.sound.sampleRate / (mixer.sampleRate * 1.0)
        end if
      end if
    end for
    track = mixer.music
    if track is not void and track.playing and not track.paused and
        mixer.musicVolume > 0.0 then
      sourceFrame = ambio.truncInt(track.position * track.rate /
        (mixer.sampleRate * 1.0))
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
        mixedLeft = mixedLeft + musicLeft * mixer.musicVolume
        mixedRight = mixedRight + musicRight * mixer.musicVolume
        track.position = track.position + 1
      end if
    end if
    mixedLeft = mixedLeft * mixer.masterVolume
    mixedRight = mixedRight * mixer.masterVolume
    ambio.putI16(output, frameIndex * 4, ambio.truncInt(clamp16(mixedLeft)))
    ambio.putI16(output, frameIndex * 4 + 2, ambio.truncInt(clamp16(mixedRight)))
    frameIndex = frameIndex + 1
  end while
  mixer.paintedFrames = mixer.paintedFrames + frameCount
  return output
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

function startAutoSound(mixer, sound, leftVolume, rightVolume)
  channel = startSound(mixer, sound, 0, 0, leftVolume, rightVolume)
  if channel is void then return void end if
  channel.looping = true
  channel.autoSound = true
  if sound.sampleCount > 0 then
    phase = ambio.truncInt(mixer.paintedFrames * sound.sampleRate /
      (mixer.sampleRate * 1.0)) % sound.sampleCount
    channel.sourceFrame = phase * 1.0
  end if
  return channel
end function

function stopAll(mixer)
  for each channel in mixer.channels
    channel.active = false
  end for
  for each pending in mixer.pendingSounds
    pending.active = false
  end for
  mixer.pendingSounds = []
end function
