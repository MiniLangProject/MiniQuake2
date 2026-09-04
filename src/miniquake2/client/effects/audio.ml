//! Provides miniquake2 client effects audio facilities for this project.

/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Asset-neutral sound handoff. Host code may resolve to audio.mixer sounds. */
package miniquake2.client.effects.audio

import miniquake2.client.effects.types as cetypes

/// Return the identity index.
/// @param index Zero-based index of the affected item.
function identityIndex(index)
  return index
end function

/// Return the identity name.
/// @param name Name of the affected item.
function identityName(name)
  return name
end function

/// Ignore play.
/// @param event event value consumed by this operation.
/// @param resolvedSound resolvedSound value consumed by this operation.
function ignorePlay(event, resolvedSound)
  return true
end function

/// Performs the callbacks operation for the miniquake2 client effects audio module.
/// @param resolveIndex Zero-based index of resolve.
/// @param resolveName resolveName value consumed by this operation.
/// @param play play value consumed by this operation.
function callbacks(resolveIndex, resolveName, play)
  if typeof(resolveIndex) != "function" or typeof(resolveName) != "function" or typeof(play) != "function" then
    return error(7300, "effect audio handoff requires three function values")
  end if
  return cetypes.AudioCallbacks(resolveIndex, resolveName, play)
end function

/// Report whether silent.
function silent()
  return callbacks(identityIndex, identityName, ignorePlay)
end function

/// Performs the emit operation for the miniquake2 client effects audio module.
/// @param state Mutable state inspected or updated by the operation.
/// @param event event value consumed by this operation.
function emit(state, event)
  state.soundEvents = state.soundEvents + [event]
  resolved = void
  if event.soundName != "" then resolved = state.audio.resolveName(event.soundName) else resolved = state.audio.resolveIndex(event.soundIndex) end if
  if resolved is void then return false end if
  return state.audio.play(event, resolved)
end function

