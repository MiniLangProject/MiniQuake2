/* Deterministic signed-16 stereo channel mixer and Quake-style spatializer. */
package miniquake2.audio.mixer

import std.math as ammath
import miniquake2.qcommon.byteio as ambio

struct Channel
  sound
  entityNumber
  entityChannel
  sourceFrame
  leftVolume
  rightVolume
  active
end struct

struct Mixer
  sampleRate
  channels
  paintedFrames
end struct

function create(sampleRate)
  if sampleRate < 8000 or sampleRate > 192000 then return error(2955, "mixer sample rate outside range") end if
  return Mixer(sampleRate, [], 0)
end function

function clamp16(value)
  if value > 32767 then return 32767 end if
  if value < -32768 then return -32768 end if
  return value
end function

function sampleAt(sound, frame, channel)
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
  channel = Channel(sound, entityNumber, entityChannel, 0.0, leftVolume, rightVolume, true)
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
  distanceScale = 1.0 - distance * attenuation
  if distanceScale < 0.0 then distanceScale = 0.0 end if
  left = masterVolume * distanceScale * (1.0 - dot)
  right = masterVolume * distanceScale * (1.0 + dot)
  if left > 255.0 then left = 255.0 end if
  if right > 255.0 then right = 255.0 end if
  if left < 0.0 then left = 0.0 end if
  if right < 0.0 then right = 0.0 end if
  return [ambio.truncInt(left), ambio.truncInt(right)]
end function

function mix(mixer, frameCount)
  if frameCount < 0 then return error(2957, "negative mix frame count") end if
  output = bytes(frameCount * 4)
  frameIndex = 0
  while frameIndex < frameCount
    mixedLeft = 0
    mixedRight = 0
    for each channel in mixer.channels
      if channel.active then
        sourceIndex = ambio.truncInt(channel.sourceFrame)
        if sourceIndex >= channel.sound.sampleCount then
          if channel.sound.loopStart >= 0 then
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
    ambio.putI16(output, frameIndex * 4, ambio.truncInt(clamp16(mixedLeft)))
    ambio.putI16(output, frameIndex * 4 + 2, ambio.truncInt(clamp16(mixedRight)))
    frameIndex = frameIndex + 1
  end while
  mixer.paintedFrames = mixer.paintedFrames + frameCount
  return output
end function

function stopAll(mixer)
  for each channel in mixer.channels
    channel.active = false
  end for
end function
