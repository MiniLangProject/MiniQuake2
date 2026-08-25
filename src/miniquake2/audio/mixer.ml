/* Deterministic signed-16 stereo channel mixer and Quake-style spatializer. */
package miniquake2.audio.mixer

import std.math as ammath
import miniquake2.qcommon.byteio as ambio

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
end struct

struct Mixer
  sampleRate
  channels
  paintedFrames
  masterVolume
end struct

function create(sampleRate)
  if sampleRate < 8000 or sampleRate > 192000 then return error(2955, "mixer sample rate outside range") end if
  return Mixer(sampleRate, [], 0, 1.0)
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

function startSound(mixer, sound, entityNumber, entityChannel, leftVolume, rightVolume)
  if leftVolume < 0 or leftVolume > 255 or rightVolume < 0 or rightVolume > 255 then return error(2956, "channel volume outside [0,255]") end if
  if entityChannel != 0 then
    for each oldChannel in mixer.channels
      if oldChannel.active and oldChannel.entityNumber == entityNumber and oldChannel.entityChannel == entityChannel then oldChannel.active = false end if
    end for
  end if
  channel = Channel(sound, entityNumber, entityChannel, 0.0,
    mixer.paintedFrames, leftVolume, rightVolume, true, false, false)
  // Reuse a finished slot. Sound events are frequent during combat and an
  // append-only channel array would otherwise retain and scan every expired
  // sound for the rest of the map.
  channelIndex = 0
  while channelIndex < len(mixer.channels)
    if not mixer.channels[channelIndex].active then
      mixer.channels[channelIndex] = channel
      return channel
    end if
    channelIndex = channelIndex + 1
  end while
  mixer.channels = mixer.channels + [channel]
  return channel
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
  if not hasActiveChannel then
    mixer.paintedFrames = mixer.paintedFrames + frameCount
    return output
  end if
  frameIndex = 0
  while frameIndex < frameCount
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
end function
