/* Asset-neutral sound handoff. Host code may resolve to audio.mixer sounds. */
package miniquake2.client.effects.audio

import miniquake2.client.effects.types as cetypes

function identityIndex(index)
  return index
end function

function identityName(name)
  return name
end function

function ignorePlay(event, resolvedSound)
  return true
end function

function callbacks(resolveIndex, resolveName, play)
  if typeof(resolveIndex) != "function" or typeof(resolveName) != "function" or typeof(play) != "function" then
    return error(7300, "effect audio handoff requires three function values")
  end if
  return cetypes.AudioCallbacks(resolveIndex, resolveName, play)
end function

function silent()
  return callbacks(identityIndex, identityName, ignorePlay)
end function

function emit(state, event)
  state.soundEvents = state.soundEvents + [event]
  resolved = void
  if event.soundName != "" then resolved = state.audio.resolveName(event.soundName) else resolved = state.audio.resolveIndex(event.soundIndex) end if
  if resolved is void then return false end if
  return state.audio.play(event, resolved)
end function

