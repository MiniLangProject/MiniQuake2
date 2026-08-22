/* Installable bridge from effect SoundEvents to the existing audio mixer. */
package miniquake2.client.effects.mixer_adapter

import miniquake2.qcommon.byteio as qbio
import miniquake2.audio.mixer as amixer
import miniquake2.client.effects.audio as ceaudio

activeMixer = void
indexResolver = void
nameResolver = void
entityPositionResolver = void
listenerOrigin = void
listenerRight = void

function resolveIndex(index)
  global indexResolver
  return indexResolver(index)
end function

function resolveName(name)
  global nameResolver
  return nameResolver(name)
end function

function play(event, sound)
  global activeMixer, entityPositionResolver, listenerOrigin, listenerRight
  if activeMixer is void then return error(7340, "effect mixer adapter is not installed") end if
  position = event.position
  if position is void and event.entity != 0 then position = entityPositionResolver(event.entity) end if
  master = event.volume * 255.0
  volumes = [qbio.truncInt(master), qbio.truncInt(master)]
  if position is not void then
    // Quake attenuation units are world-distance scaled, while the managed
    // mixer accepts a direct per-unit coefficient.
    volumes = amixer.spatialVolumes(listenerOrigin, listenerRight, position,
      master, event.attenuation * 0.001)
  end if
  channel = amixer.startSound(activeMixer, sound, event.entity, event.channel, volumes[0], volumes[1])
  channel.sourceFrame = event.timeOffset * sound.sampleRate
  return channel
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
  global activeMixer, indexResolver, nameResolver, entityPositionResolver, listenerOrigin, listenerRight
  activeMixer = void
  indexResolver = void
  nameResolver = void
  entityPositionResolver = void
  listenerOrigin = void
  listenerRight = void
  return true
end function
