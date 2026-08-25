/* Product-facing function-value handoff for renderer and mixer resources. */
package miniquake2.runtime.client_assets

import miniquake2.client.assets.registry as caregistry
import miniquake2.client.effects.mixer_adapter as cameffects

function create(modelLoader, skinLoader, soundLoader, missingCallback)
  return caregistry.create(caregistry.callbacks(modelLoader, skinLoader,
    soundLoader, missingCallback))
end function

function createLenient(modelLoader, skinLoader, soundLoader)
  return caregistry.createLenient(modelLoader, skinLoader, soundLoader)
end function

function createForRenderer(rendererExports, soundLoader, missingCallback)
  if rendererExports is void or typeof(rendererExports.RegisterModel) != "function" or
      typeof(rendererExports.RegisterSkin) != "function" then
    return error(8410, "client assets require Renderer RegisterModel/RegisterSkin")
  end if
  return create(rendererExports.RegisterModel, rendererExports.RegisterSkin,
    soundLoader, missingCallback)
end function

function registerConfigStrings(state, configStrings, mapName)
  return caregistry.registerConfigStrings(state, configStrings, mapName)
end function

function reset(state, mapName)
  return caregistry.reset(state, mapName)
end function

function refreshClientInfos(state, configStrings)
  return caregistry.refreshClientInfos(state, configStrings)
end function

function refreshConfigStrings(state, configStrings)
  return caregistry.refreshConfigStrings(state, configStrings)
end function

function bindings(state)
  return caregistry.bindings(state)
end function

function releaseBindings()
  cameffects.release()
  return caregistry.releaseBindings()
end function

function attachMixer(state, effectState, mixer, entityPositionResolver, listenerOrigin, listenerRight)
  values = bindings(state)
  audioCallbacks = cameffects.install(mixer, values.soundIndex, values.soundName,
    entityPositionResolver, listenerOrigin, listenerRight)
  effectState.audio = audioCallbacks
  return audioCallbacks
end function

function syncEntityLoops(mixer, snapshot)
  return cameffects.syncEntityLoops(mixer, snapshot)
end function

function setMixerListenerEntity(number)
  return cameffects.setListenerEntity(number)
end function

function missingAssets(state)
  return caregistry.missingAssets(state)
end function
