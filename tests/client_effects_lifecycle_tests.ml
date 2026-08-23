/* Deterministic effect lifecycle and renderer RefDef handoff. */
import miniquake2.qcommon.types as qt
import miniquake2.audio.wav as awav
import miniquake2.audio.mixer as amixer
import miniquake2.renderer.constants as rc
import miniquake2.renderer.types as rt
import miniquake2.renderer.validation as rvalidation
import miniquake2.client.effects.types as cetypes
import miniquake2.client.effects.audio as ceaudio
import miniquake2.client.effects.state as cestate
import miniquake2.client.effects.handoff as cehandoff
import miniquake2.client.effects.mixer_adapter as cemixer

testSound = void

function resolveSoundIndex(index)
  global testSound
  return testSound
end function

function resolveSoundName(name)
  global testSound
  return testSound
end function

function resolveEntityPosition(entity)
  return qt.Vec3(10.0, 0.0, 0.0)
end function

function assertEqual(actual, expected, name)
  if actual != expected then return error(8010, name + ": expected " + expected + ", got " + actual) end if
  return true
end function

function assertTrue(value, name)
  if value != true then return error(8011, name + ": expected true") end if
  return true
end function

function resolveModel(name)
  return rt.ResourceHandle("model", len(bytes(name)), name, 1)
end function

function buildState(seed)
  state = cestate.createSilent(seed)
  origin = qt.Vec3(1.0, 2.0, 3.0)
  cestate.addDLight(state, 4, origin, 200.0, [1.0, 0.5, 0.25], 100.0, 50.0)
  cestate.particleEffect(state, origin, qt.Vec3(1.0, 0.0, 0.0), 0x20, 8, 10.0)
  cestate.addBeam(state, 2, 0, "models/beam.md2", origin, qt.Vec3(10.0, 2.0, 3.0), qt.zeroVec3(), false, 200)
  cestate.addLaser(state, origin, qt.Vec3(1.0, 8.0, 3.0), 0xd0)
  cestate.addExplosion(state, 5, origin, "models/explosion.md2", 4, 150.0,
    [1.0, 0.5, 0.5], 8, 1.0)
  return state
end function

first = buildState(123)
second = buildState(123)
assertEqual(first.particles[0].origin.x, second.particles[0].origin.x, "seeded particle origin")
assertEqual(first.particles[0].velocity.z, second.particles[0].velocity.z, "seeded particle velocity")

frame = rt.defaultRefDef(640, 480)
cehandoff.apply(first, frame, 0, resolveModel)
assertEqual(frame.numDLights, 2, "dlight plus explosion light")
assertEqual(frame.numParticles, 8, "particle handoff")
assertEqual(frame.numEntities, 3, "beam laser explosion entities")
assertEqual(frame.entities[0].flags & rc.RF_BEAM, 0,
  "model cable uses MD2 segments rather than RF_BEAM geometry")
assertEqual(frame.entities[2].frame, 2, "classic explosion current frame")
assertEqual(frame.entities[2].oldFrame, 1, "classic explosion previous frame")
assertEqual(frame.entities[2].alpha, 0.9375, "classic polygon explosion fade")
assertEqual(frame.dLights[1].intensity, 140.625, "explosion light follows alpha")
assertTrue(rvalidation.validateRefDef(frame).valid, "renderer validates effect RefDef")

longBeamState = cestate.createSilent(7)
cestate.addBeam(longBeamState, 9, 0, "models/monsters/parasite/segment/tris.md2",
  qt.zeroVec3(), qt.Vec3(100.0, 0.0, 0.0), qt.zeroVec3(), false, 200)
longBeamFrame = rt.defaultRefDef(640, 480)
cehandoff.apply(longBeamState, longBeamFrame, 0, resolveModel)
assertEqual(longBeamFrame.numEntities, 4, "100-unit cable MD2 segment count")
assertEqual(longBeamFrame.entities[0].angles.x, 0.0, "cable segment pitch")
assertEqual(longBeamFrame.entities[0].angles.y, 0.0, "cable segment yaw")
assertEqual(longBeamFrame.entities[3].model.name,
  "models/monsters/parasite/segment/tris.md2", "cable segment model")

cestate.advance(first, 250)
assertEqual(len(first.dLights), 0, "dlight expiry")
assertEqual(len(first.lasers), 0, "laser expiry")
assertEqual(len(first.beams), 0, "beam expiry")
cestate.advance(first, 2000)
assertEqual(len(first.explosions), 0, "explosion expiry")
assertEqual(len(first.particles), 0, "particle fade expiry")
cestate.clear(first)
assertEqual(len(first.soundEvents), 0, "clear effects")

testSound = awav.WavSound("generated", 8000, 1, 1, 4, -1, bytes([128, 129, 130, 131]))
mixer = amixer.create(8000)
mixerCallbacks = cemixer.install(mixer, resolveSoundIndex, resolveSoundName, resolveEntityPosition,
  qt.zeroVec3(), qt.Vec3(0.0, 1.0, 0.0))
audioState = cestate.create(mixerCallbacks, 1)
event = cetypes.SoundEvent(void, 3, 1, 7, "", 1.0, 1.0, 0.001)
ceaudio.emit(audioState, event)
assertEqual(len(mixer.channels), 1, "audio mixer callback starts channel")
assertEqual(mixer.channels[0].sourceFrame, 8.0, "audio mixer start offset")
print "client_effects_lifecycle_tests: PASS"
