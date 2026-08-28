/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Installable bridge from effect SoundEvents to the existing audio mixer. */
package miniquake2.client.effects.mixer_adapter

import miniquake2.qcommon.byteio as qbio
import miniquake2.qcommon.constants as qconstants
import miniquake2.qcommon.types as qtypes
import miniquake2.audio.mixer as amixer
import miniquake2.client.effects.audio as ceaudio

activeMixer = void
indexResolver = void
nameResolver = void
entitySoundResolver = void
entityPositionResolver = void
listenerOrigin = void
listenerRight = void
listenerEntityNumber = -1
mixerSpatialScratch = array(2, 0)
loopSoundEpoch = 0
loopSoundSeen = array(qconstants.MAX_SOUNDS, 0)
loopSoundIndices = array(qconstants.MAX_SOUNDS, 0)
loopSoundLeft = array(qconstants.MAX_SOUNDS, 0)
loopSoundRight = array(qconstants.MAX_SOUNDS, 0)
loopSoundResolved = array(qconstants.MAX_SOUNDS, void)
loopSoundAvailable = array(qconstants.MAX_SOUNDS, false)

// Resolve index.
function resolveIndex(index)
  global indexResolver
  return indexResolver(index)
end function

// Resolve name.
function resolveName(name)
  global nameResolver
  return nameResolver(name)
end function

// Play state.
function play(event, sound)
  global activeMixer, entitySoundResolver, entityPositionResolver, listenerOrigin, listenerRight, listenerEntityNumber
  if activeMixer is void then return error(7340, "effect mixer adapter is not installed") end if
  entitySound = entitySoundResolver(event.entity, event.soundIndex,
    event.soundName)
  if entitySound is not void then sound = entitySound end if
  position = event.position
  localSound = position is void and event.entity == listenerEntityNumber
  if position is void and event.entity != 0 and not localSound then
    position = entityPositionResolver(event.entity)
  end if
  master = event.volume * 255.0
  distanceMultiplier = event.attenuation * 0.0005
  // S_IssuePlaysound gives ATTN_STATIC its own, deliberately steeper
  // coefficient. Ordinary entity sounds retain the normal 0.0005 scale.
  if event.attenuation == 3.0 then
    distanceMultiplier = event.attenuation * 0.001
  end if
  volumes = mixerSpatialScratch
  volumes[0] = qbio.truncInt(master)
  volumes[1] = volumes[0]
  if position is not void then
    amixer.spatialVolumesInto(volumes, listenerOrigin, listenerRight,
      position, master, distanceMultiplier)
  end if
  startFrame = activeMixer.paintedFrames +
    qbio.truncInt(event.timeOffset * activeMixer.sampleRate)
  channel = amixer.startSoundAt(activeMixer, sound, event.entity,
    event.channel, volumes[0], volumes[1], startFrame)
  if channel is void then return false end if
  // Keep the source metadata which stock channel_t retains. S_Update uses it
  // to re-spatialize every live one-shot when either listener or entity moves.
  channel.spatialized = true
  channel.masterVolume = master
  channel.distanceMultiplier = distanceMultiplier
  channel.fixedOrigin = event.position is not void
  channel.origin = event.position
  // Protocol timeofs delays the start; it is not an offset into the WAV.
  return channel
end function

// Return the respatialize dynamic value.
function respatializeDynamic(mixer, entityPositionCallback, origin, right,
    localEntityNumber)
  if mixer is void or typeof(entityPositionCallback) != "function" or
      origin is void or right is void then
    return error(7345, "dynamic sound spatialization requires mixer, resolver, and listener")
  end if
  updated = 0
  for each channel in mixer.channels
    if channel.active and channel.spatialized and not channel.autoSound then
      if channel.entityNumber == localEntityNumber then
        channel.leftVolume = qbio.truncInt(channel.masterVolume)
        channel.rightVolume = qbio.truncInt(channel.masterVolume)
        updated = updated + 1
      else
        position = channel.origin
        if not channel.fixedOrigin then
          position = entityPositionCallback(channel.entityNumber)
        end if
        if position is not void then
          volumes = mixerSpatialScratch
          amixer.spatialVolumesInto(volumes, origin, right, position,
            channel.masterVolume, channel.distanceMultiplier)
          channel.leftVolume = volumes[0]
          channel.rightVolume = volumes[1]
          updated = updated + 1
          // S_Update frees a dynamic channel once it is no longer audible.
          if volumes[0] == 0 and volumes[1] == 0 then channel.active = false end if
        end if
      end if
    end if
  end for
  // Pending playsounds are spatialized at S_IssuePlaysound time in the
  // original. Refresh their cached volumes as the listener/entity moves, but
  // do not discard an inaudible future sound before its begin time.
  for each channel in mixer.pendingSounds
    if channel.active and channel.spatialized then
      if channel.entityNumber == localEntityNumber then
        channel.leftVolume = qbio.truncInt(channel.masterVolume)
        channel.rightVolume = qbio.truncInt(channel.masterVolume)
        updated = updated + 1
      else
        position = channel.origin
        if not channel.fixedOrigin then
          position = entityPositionCallback(channel.entityNumber)
        end if
        if position is not void then
          volumes = mixerSpatialScratch
          amixer.spatialVolumesInto(volumes, origin, right, position,
            channel.masterVolume, channel.distanceMultiplier)
          channel.leftVolume = volumes[0]
          channel.rightVolume = volumes[1]
          updated = updated + 1
        end if
      end if
    end if
  end for
  return updated
end function

// Set listener entity.
function setListenerEntity(number)
  global activeMixer, listenerEntityNumber
  if typeof(number) != "int" or number < 1 then
    return error(7344, "listener entity number must be positive")
  end if
  listenerEntityNumber = number
  if activeMixer is not void then amixer.setListenerEntity(activeMixer, number) end if
  return number
end function

// Reproduce S_AddLoopSounds for EntityState.sound. Identical sound indexes
// are merged into one autosound channel and their spatial contributions are
// summed, exactly as the stock client does for doors, plats, ambients and
// projectile flight loops.
function syncEntityLoopsPaused(mixer, snapshot, paused)
  global indexResolver, listenerOrigin, listenerRight, loopSoundEpoch
  if mixer is void then return error(7343, "loop sound sync requires a mixer") end if
  amixer.clearAutoSounds(mixer)
  if paused then return 0 end if
  if snapshot is void then return 0 end if
  loopSoundEpoch = loopSoundEpoch + 1
  if loopSoundEpoch >= 0x7fffffff then
    loopSoundEpoch = 1
    index = 0
    while index < len(loopSoundSeen)
      loopSoundSeen[index] = 0
      index = index + 1
    end while
  end if
  activeCount = 0
  for each entity in snapshot.entities
    soundIndex = entity.sound
    if soundIndex > 0 and soundIndex < qconstants.MAX_SOUNDS then
      if loopSoundSeen[soundIndex] != loopSoundEpoch then
        loopSoundSeen[soundIndex] = loopSoundEpoch
        loopSoundIndices[activeCount] = soundIndex
        activeCount = activeCount + 1
        loopSoundLeft[soundIndex] = 0
        loopSoundRight[soundIndex] = 0
        resolvedSound = indexResolver(soundIndex)
        loopSoundAvailable[soundIndex] = resolvedSound is not void
        // MiniLang deliberately rejects assigning void through an array index.
        // Keep the previous handle in the scratch slot and gate it with the
        // current epoch's availability bit when a configstring is unresolved.
        if resolvedSound is not void then
          loopSoundResolved[soundIndex] = resolvedSound
        end if
      end if
      if loopSoundAvailable[soundIndex] then
        position = qtypes.Vec3(entity.origin[0], entity.origin[1],
          entity.origin[2])
        volumes = mixerSpatialScratch
        amixer.spatialVolumesInto(volumes, listenerOrigin, listenerRight,
          position, 255.0, 0.003)
        loopSoundLeft[soundIndex] = loopSoundLeft[soundIndex] + volumes[0]
        loopSoundRight[soundIndex] = loopSoundRight[soundIndex] + volumes[1]
      end if
    end if
  end for
  started = 0
  index = 0
  while index < activeCount
    soundIndex = loopSoundIndices[index]
    sound = loopSoundResolved[soundIndex]
    if loopSoundAvailable[soundIndex] then
        left = loopSoundLeft[soundIndex]
        right = loopSoundRight[soundIndex]
        if left > 255 then left = 255 end if
        if right > 255 then right = 255 end if
        if left > 0 or right > 0 then
          channel = amixer.startAutoSound(mixer, sound, left, right)
          if channel is not void then started = started + 1 end if
        end if
    end if
    index = index + 1
  end while
  return started
end function

// Backwards-compatible active-game entry point. Runtime owners that implement
// cl_paused should call syncEntityLoopsPaused with their pause state.
function syncEntityLoops(mixer, snapshot)
  return syncEntityLoopsPaused(mixer, snapshot, false)
end function

// Install state.
function install(mixer, resolveIndexCallback, resolveNameCallback, resolveEntitySoundCallback, entityPositionCallback, origin, right)
  global activeMixer, indexResolver, nameResolver, entitySoundResolver, entityPositionResolver, listenerOrigin, listenerRight
  if typeof(resolveIndexCallback) != "function" or typeof(resolveNameCallback) != "function" or
      typeof(resolveEntitySoundCallback) != "function" or
      typeof(entityPositionCallback) != "function" then return error(7341, "mixer adapter resolvers must be function values") end if
  if mixer is void or origin is void or right is void then return error(7342, "mixer adapter requires mixer and listener vectors") end if
  activeMixer = mixer
  if listenerEntityNumber > 0 then
    amixer.setListenerEntity(mixer, listenerEntityNumber)
  end if
  indexResolver = resolveIndexCallback
  nameResolver = resolveNameCallback
  entitySoundResolver = resolveEntitySoundCallback
  entityPositionResolver = entityPositionCallback
  listenerOrigin = origin
  listenerRight = right
  respatializeDynamic(mixer, entityPositionCallback, origin, right,
    listenerEntityNumber)
  return ceaudio.callbacks(resolveIndex, resolveName, play)
end function

// Release state.
function release()
  global activeMixer, indexResolver, nameResolver, entitySoundResolver, entityPositionResolver, listenerOrigin, listenerRight, listenerEntityNumber
  activeMixer = void
  indexResolver = void
  nameResolver = void
  entitySoundResolver = void
  entityPositionResolver = void
  listenerOrigin = void
  listenerRight = void
  listenerEntityNumber = -1
  return true
end function
