/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Stable-count effect handoff must reuse renderer storage without changing values. */
import miniquake2.qcommon.types as effectscratchtypes
import miniquake2.client.effects.state as effectscratchstate
import miniquake2.client.effects.handoff as effectscratchhandoff

function effectScratchAssert(value, message)
  if not value then return error(9986, message) end if
  return true
end function

effectScratchState = effectscratchstate.createSilent(123)
effectScratchOrigin = effectscratchtypes.Vec3(1.0, 2.0, 3.0)
effectScratchVelocity = effectscratchtypes.Vec3(10.0, 0.0, 0.0)
effectScratchAcceleration = effectscratchtypes.Vec3(0.0, 0.0, 0.0)
effectscratchstate.addParticle(effectScratchState, effectScratchOrigin,
  effectScratchVelocity, effectScratchAcceleration, 7, 1.0, -0.1)

effectScratchFirstParticles = effectscratchhandoff.rendererParticles(
  effectScratchState, 0)
effectScratchParticleArrayIdentity = nativeRawValue(effectScratchFirstParticles)
effectScratchParticleIdentity = nativeRawValue(effectScratchFirstParticles[0])
effectScratchSecondParticles = effectscratchhandoff.rendererParticles(
  effectScratchState, 100)
effectScratchAssert(nativeRawValue(effectScratchSecondParticles) ==
    effectScratchParticleArrayIdentity and
  nativeRawValue(effectScratchSecondParticles[0]) == effectScratchParticleIdentity,
  "stable particle count rebuilt renderer storage")
effectScratchAssert(effectScratchSecondParticles[0].origin.x == 2.0 and
    effectScratchSecondParticles[0].origin.y == 2.0 and
    effectScratchSecondParticles[0].alpha == 0.99,
  "reused particle renderer state was not refreshed")

effectscratchstate.addDLight(effectScratchState, 1, effectScratchOrigin,
  200.0, [1.0, 0.5, 0.25], 1000, 0.0)
effectScratchFirstLights = effectscratchhandoff.rendererDLights(
  effectScratchState)
effectScratchLightArrayIdentity = nativeRawValue(effectScratchFirstLights)
effectScratchLightIdentity = nativeRawValue(effectScratchFirstLights[0])
effectScratchState.dLights[0].origin.x = 9.0
effectScratchState.dLights[0].radius = 175.0
effectScratchSecondLights = effectscratchhandoff.rendererDLights(
  effectScratchState)
effectScratchAssert(nativeRawValue(effectScratchSecondLights) ==
    effectScratchLightArrayIdentity and
  nativeRawValue(effectScratchSecondLights[0]) == effectScratchLightIdentity,
  "stable dlight count rebuilt renderer storage")
effectScratchAssert(effectScratchSecondLights[0].origin.x == 9.0 and
    effectScratchSecondLights[0].intensity == 175.0 and
    effectScratchSecondLights[0].color.y == 0.5,
  "reused dlight renderer state was not refreshed")

print "client_effects_render_scratch_tests: PASS"
