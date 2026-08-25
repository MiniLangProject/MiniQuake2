/* Installable bridge from effect SoundEvents to the existing audio mixer. */
package miniquake2.client.effects.mixer_adapter

import miniquake2.qcommon.byteio as qbio
import miniquake2.qcommon.types as qtypes
import miniquake2.audio.mixer as amixer
import miniquake2.client.effects.audio as ceaudio

activeMixer = void
indexResolver = void
nameResolver = void
entityPositionResolver = void
listenerOrigin = void
listenerRight = void
listenerEntityNumber = -1

function resolveIndex(index)
  global indexResolver
  return indexResolver(index)
end function

function resolveName(name)
  global nameResolver
  return nameResolver(name)
end function

function play(event, sound)
  global activeMixer, entityPositionResolver, listenerOrigin, listenerRight, listenerEntityNumber
  if activeMixer is void then return error(7340, "effect mixer adapter is not installed") end if
  position = event.position
  localSound = position is void and event.entity == listenerEntityNumber
  if position is void and event.entity != 0 and not localSound then
    position = entityPositionResolver(event.entity)
  end if
  master = event.volume * 255.0
  volumes = [qbio.truncInt(master), qbio.truncInt(master)]
  if position is not void then
    // Quake attenuation units are world-distance scaled, while the managed
    // mixer accepts a direct per-unit coefficient.
    volumes = amixer.spatialVolumes(listenerOrigin, listenerRight, position,
      master, event.attenuation * 0.0005)
  end if
  channel = amixer.startSound(activeMixer, sound, event.entity, event.channel, volumes[0], volumes[1])
  // Protocol timeofs delays the start; it is not an offset into the WAV.
  channel.startFrame = activeMixer.paintedFrames +
    qbio.truncInt(event.timeOffset * activeMixer.sampleRate)
  return channel
end function

function setListenerEntity(number)
  global listenerEntityNumber
  if typeof(number) != "int" or number < 1 then
    return error(7344, "listener entity number must be positive")
  end if
  listenerEntityNumber = number
  return number
end function

// Reproduce S_AddLoopSounds for EntityState.sound. Identical sound indexes
// are merged into one autosound channel and their spatial contributions are
// summed, exactly as the stock client does for doors, plats, ambients and
// projectile flight loops.
function syncEntityLoops(mixer, snapshot)
  global indexResolver, listenerOrigin, listenerRight
  if mixer is void then return error(7343, "loop sound sync requires a mixer") end if
  amixer.clearAutoSounds(mixer)
  if snapshot is void then return 0 end if
  started = 0
  index = 0
  while index < len(snapshot.entities)
    soundIndex = snapshot.entities[index].sound
    firstSource = soundIndex > 0
    prior = 0
    while prior < index and firstSource
      if snapshot.entities[prior].sound == soundIndex then firstSource = false end if
      prior = prior + 1
    end while
    if firstSource then
      sound = indexResolver(soundIndex)
      if sound is not void then
        entity = snapshot.entities[index]
        position = qtypes.Vec3(entity.origin[0],
          entity.origin[1], entity.origin[2])
        volumes = amixer.spatialVolumes(listenerOrigin, listenerRight,
          position, 255.0, 0.003)
        left = volumes[0]
        right = volumes[1]
        other = index + 1
        while other < len(snapshot.entities)
          if snapshot.entities[other].sound == soundIndex then
            otherEntity = snapshot.entities[other]
            otherPosition = qtypes.Vec3(
              otherEntity.origin[0], otherEntity.origin[1],
              otherEntity.origin[2])
            otherVolumes = amixer.spatialVolumes(listenerOrigin,
              listenerRight, otherPosition, 255.0, 0.003)
            left = left + otherVolumes[0]
            right = right + otherVolumes[1]
          end if
          other = other + 1
        end while
        if left > 255 then left = 255 end if
        if right > 255 then right = 255 end if
        if left > 0 or right > 0 then
          amixer.startAutoSound(mixer, sound, left, right)
          started = started + 1
        end if
      end if
    end if
    index = index + 1
  end while
  return started
end function

function install(mixer, resolveIndexCallback, resolveNameCallback, entityPositionCallback, origin, right)
  global activeMixer, indexResolver, nameResolver, entityPositionResolver, listenerOrigin, listenerRight
  if typeof(resolveIndexCallback) != "function" or typeof(resolveNameCallback) != "function" or
      typeof(entityPositionCallback) != "function" then return error(7341, "mixer adapter resolvers must be function values") end if
  if mixer is void or origin is void or right is void then return error(7342, "mixer adapter requires mixer and listener vectors") end if
  activeMixer = mixer
  indexResolver = resolveIndexCallback
  nameResolver = resolveNameCallback
  entityPositionResolver = entityPositionCallback
  listenerOrigin = origin
  listenerRight = right
  return ceaudio.callbacks(resolveIndex, resolveName, play)
end function

function release()
  global activeMixer, indexResolver, nameResolver, entityPositionResolver, listenerOrigin, listenerRight, listenerEntityNumber
  activeMixer = void
  indexResolver = void
  nameResolver = void
  entityPositionResolver = void
  listenerOrigin = void
  listenerRight = void
  listenerEntityNumber = -1
  return true
end function
