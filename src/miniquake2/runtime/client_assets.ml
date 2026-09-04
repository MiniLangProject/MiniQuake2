//! Provides miniquake2 runtime client assets facilities for this project.

/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Product-facing function-value handoff for renderer and mixer resources. */
package miniquake2.runtime.client_assets

import miniquake2.client.assets.registry as caregistry
import miniquake2.client.effects.mixer_adapter as cameffects

/// Creates create for the miniquake2 runtime client assets module.
/// @param modelLoader modelLoader value consumed by this operation.
/// @param skinLoader skinLoader value consumed by this operation.
/// @param soundLoader soundLoader value consumed by this operation.
/// @param missingCallback missingCallback value consumed by this operation.
function create(modelLoader, skinLoader, soundLoader, missingCallback)
  return caregistry.create(caregistry.callbacks(modelLoader, skinLoader,
    soundLoader, missingCallback))
end function

/// Create lenient.
/// @param modelLoader modelLoader value consumed by this operation.
/// @param skinLoader skinLoader value consumed by this operation.
/// @param soundLoader soundLoader value consumed by this operation.
function createLenient(modelLoader, skinLoader, soundLoader)
  return caregistry.createLenient(modelLoader, skinLoader, soundLoader)
end function

/// Create for renderer.
/// @param rendererExports rendererExports value consumed by this operation.
/// @param soundLoader soundLoader value consumed by this operation.
/// @param missingCallback missingCallback value consumed by this operation.
function createForRenderer(rendererExports, soundLoader, missingCallback)
  if rendererExports is void or typeof(rendererExports.RegisterModel) != "function" or
      typeof(rendererExports.RegisterSkin) != "function" then
    return error(8410, "client assets require Renderer RegisterModel/RegisterSkin")
  end if
  return create(rendererExports.RegisterModel, rendererExports.RegisterSkin,
    soundLoader, missingCallback)
end function

/// Register config strings.
/// @param state Mutable state inspected or updated by the operation.
/// @param configStrings configStrings value consumed by this operation.
/// @param mapName mapName value consumed by this operation.
function registerConfigStrings(state, configStrings, mapName)
  return caregistry.registerConfigStrings(state, configStrings, mapName)
end function

/// Performs the reset operation for the miniquake2 runtime client assets module.
/// @param state Mutable state inspected or updated by the operation.
/// @param mapName mapName value consumed by this operation.
function reset(state, mapName)
  return caregistry.reset(state, mapName)
end function

/// Refresh client infos.
/// @param state Mutable state inspected or updated by the operation.
/// @param configStrings configStrings value consumed by this operation.
function refreshClientInfos(state, configStrings)
  return caregistry.refreshClientInfos(state, configStrings)
end function

/// Refresh config strings.
/// @param state Mutable state inspected or updated by the operation.
/// @param configStrings configStrings value consumed by this operation.
function refreshConfigStrings(state, configStrings)
  return caregistry.refreshConfigStrings(state, configStrings)
end function

/// Return the bindings value.
/// @param state Mutable state inspected or updated by the operation.
function bindings(state)
  return caregistry.bindings(state)
end function

/// Release bindings.
function releaseBindings()
  cameffects.release()
  return caregistry.releaseBindings()
end function

/// Attach mixer.
/// @param state Mutable state inspected or updated by the operation.
/// @param effectState effectState value consumed by this operation.
/// @param mixer mixer value consumed by this operation.
/// @param entityPositionResolver entityPositionResolver value consumed by this operation.
/// @param listenerOrigin listenerOrigin value consumed by this operation.
/// @param listenerRight listenerRight value consumed by this operation.
function attachMixer(state, effectState, mixer, entityPositionResolver, listenerOrigin, listenerRight)
  values = bindings(state)
  audioCallbacks = cameffects.install(mixer, values.soundIndex, values.soundName,
    values.soundEntity, entityPositionResolver, listenerOrigin, listenerRight)
  effectState.audio = audioCallbacks
  return audioCallbacks
end function

/// Synchronize entity loops.
/// @param mixer mixer value consumed by this operation.
/// @param snapshot snapshot value consumed by this operation.
function syncEntityLoops(mixer, snapshot)
  return cameffects.syncEntityLoops(mixer, snapshot)
end function

/// Synchronize or suppress EntityState autosounds for the current pause state.
/// @param mixer mixer value consumed by this operation.
/// @param snapshot snapshot value consumed by this operation.
/// @param paused paused value consumed by this operation.
function syncEntityLoopsPaused(mixer, snapshot, paused)
  return cameffects.syncEntityLoopsPaused(mixer, snapshot, paused)
end function

/// Set mixer listener entity.
/// @param number number value consumed by this operation.
function setMixerListenerEntity(number)
  return cameffects.setListenerEntity(number)
end function

/// Report whether missing assets.
/// @param state Mutable state inspected or updated by the operation.
function missingAssets(state)
  return caregistry.missingAssets(state)
end function
