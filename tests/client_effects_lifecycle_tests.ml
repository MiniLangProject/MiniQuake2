/* Deterministic effect lifecycle and renderer RefDef handoff. */
import miniquake2.qcommon.types as qt
import miniquake2.audio.wav as awav
import miniquake2.audio.mixer as amixer
import miniquake2.renderer.constants as rc
import miniquake2.renderer.types as rt
import miniquake2.renderer.validation as rvalidation
import miniquake2.protocol.types as pt
import miniquake2.client.runtime.types as crtypes
import miniquake2.client.effects.types as cetypes
import miniquake2.client.effects.constants as ceconstants
import miniquake2.client.effects.audio as ceaudio
import miniquake2.client.effects.state as cestate
import miniquake2.client.effects.handoff as cehandoff
import miniquake2.client.effects.entity as ceentity
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
  cestate.wallParticles(state, origin, qt.Vec3(1.0, 0.0, 0.0), 0x20, 8)
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

instantState = cestate.createSilent(11)
cestate.addParticle(instantState, qt.Vec3(4.0, 5.0, 6.0), qt.zeroVec3(),
  qt.zeroVec3(), 16, 1.0, ceconstants.INSTANT_PARTICLE)
instantFrame = rt.defaultRefDef(640, 480)
cehandoff.apply(instantState, instantFrame, 0, resolveModel)
assertEqual(instantFrame.numParticles, 1, "instant particle renders once")
instantSecondFrame = rt.defaultRefDef(640, 480)
cehandoff.apply(instantState, instantSecondFrame, 1, resolveModel)
assertEqual(instantSecondFrame.numParticles, 0, "instant particle is consumed after handoff")
cestate.advance(instantState, 1)
assertEqual(instantState.particleCount, 0, "consumed instant particle returns to pool")

rocketState = cestate.createSilent(13)
rocketEntity = pt.zeroEntityState()
rocketEntity.number = 8; rocketEntity.modelIndex = 1
rocketEntity.oldOrigin = [0.0, 0.0, 0.0]; rocketEntity.origin = [10.0, 0.0, 0.0]
rocketEntity.effects = ceconstants.EF_ROCKET
rocketSnapshot = crtypes.Snapshot(1, 0, 0, bytes([]), void, [rocketEntity])
rocketFrame = rt.defaultRefDef(640, 480)
rocketParticles = ceentity.emit(rocketState, rocketSnapshot, void, 1.0, 0, 0,
  rocketFrame)
assertTrue(rocketParticles >= 1, "rocket snapshot emits stock smoke/fire trail")
assertEqual(rocketFrame.numDLights, 1, "rocket snapshot emits dynamic light")
assertEqual(rocketFrame.dLights[0].color.x, 1.0, "rocket light red")
rocketCount = rocketState.particleCount
rocketRepeatFrame = rt.defaultRefDef(640, 480)
ceentity.emit(rocketState, rocketSnapshot, void, 1.0, 0, 0, rocketRepeatFrame)
assertEqual(rocketState.particleCount, rocketCount,
  "unchanged interpolated rocket position does not duplicate trail")

blasterState = cestate.createSilent(17)
blasterEntity = pt.zeroEntityState()
blasterEntity.number = 9; blasterEntity.modelIndex = 1
blasterEntity.oldOrigin = [0.0, 0.0, 0.0]; blasterEntity.origin = [10.0, 0.0, 0.0]
blasterEntity.effects = ceconstants.EF_BLASTER
blasterSnapshot = crtypes.Snapshot(1, 0, 0, bytes([]), void, [blasterEntity])
blasterFrame = rt.defaultRefDef(640, 480)
ceentity.emit(blasterState, blasterSnapshot, void, 1.0, 0, 0, blasterFrame)
assertEqual(blasterState.particleCount, 2, "blaster trail stock five-unit spacing")
assertEqual(blasterFrame.dLights[0].color.y, 1.0, "blaster light green")

bfgState = cestate.createSilent(19)
bfgEntity = pt.zeroEntityState()
bfgEntity.number = 10; bfgEntity.modelIndex = 1; bfgEntity.frame = 2
bfgEntity.effects = ceconstants.EF_BFG
bfgSnapshot = crtypes.Snapshot(1, 0, 0, bytes([]), void, [bfgEntity])
bfgFrame = rt.defaultRefDef(640, 480)
ceentity.emit(bfgState, bfgSnapshot, void, 1.0, 0, 0, bfgFrame)
assertEqual(bfgFrame.dLights[0].intensity, 600.0, "BFG stock frame light ramp")

bfgAuraState = cestate.createSilent(29)
bfgAuraEntity = pt.zeroEntityState()
bfgAuraEntity.number = 11; bfgAuraEntity.modelIndex = 1
bfgAuraEntity.effects = ceconstants.EF_BFG | ceconstants.EF_ANIM_ALLFAST
bfgAuraSnapshot = crtypes.Snapshot(1, 0, 0, bytes([]), void, [bfgAuraEntity])
bfgAuraFrame = rt.defaultRefDef(640, 480)
ceentity.emit(bfgAuraState, bfgAuraSnapshot, void, 1.0, 1000, 0, bfgAuraFrame)
assertEqual(bfgAuraState.particleCount, 162, "fast BFG emits stock orbiting aura")
assertEqual(bfgAuraFrame.dLights[0].intensity, 200.0, "fast BFG stock light")

trapState = cestate.createSilent(31)
trapEntity = pt.zeroEntityState()
trapEntity.number = 12; trapEntity.modelIndex = 1
trapEntity.origin = [10.0, 20.0, 30.0]; trapEntity.oldOrigin = [10.0, 20.0, 30.0]
trapEntity.effects = ceconstants.EF_TRAP
trapSnapshot = crtypes.Snapshot(1, 0, 0, bytes([]), void, [trapEntity])
trapFrame = rt.defaultRefDef(640, 480)
ceentity.emit(trapState, trapSnapshot, void, 1.0, 100, 0, trapFrame)
assertEqual(trapState.particleCount, 21, "trap emits stock column and burst")
assertEqual(trapFrame.dLights[0].origin.z, 62.0, "trap light shifts up 32 units")
assertTrue(trapFrame.dLights[0].intensity >= 100.0 and
  trapFrame.dLights[0].intensity <= 199.0, "trap randomized stock light range")

flyState = cestate.createSilent(37)
flyEntity = pt.zeroEntityState()
flyEntity.number = 13; flyEntity.modelIndex = 1; flyEntity.effects = ceconstants.EF_FLIES
flySnapshot = crtypes.Snapshot(1, 0, 0, bytes([]), void, [flyEntity])
flyFrame = rt.defaultRefDef(640, 480)
ceentity.emit(flyState, flySnapshot, void, 1.0, 100, 0, flyFrame)
assertEqual(flyState.particleCount, 0, "fly swarm starts at zero density")
ceentity.emit(flyState, flySnapshot, void, 1.0, 10100, 0, flyFrame)
assertEqual(flyState.particleCount, 41, "fly swarm ramps to half density")

teleporterState = cestate.createSilent(41)
cestate.teleporterEntityParticles(teleporterState, qt.Vec3(1.0, 2.0, 3.0))
assertEqual(teleporterState.particleCount, 8, "persistent teleporter emits eight particles")
assertEqual(teleporterState.particles[0].color, 0xdb, "persistent teleporter color")
assertEqual(teleporterState.particles[0].acceleration.z, -40.0,
  "persistent teleporter gravity")

spinningState = cestate.createSilent(43)
spinningEntity = pt.zeroEntityState()
spinningEntity.number = 14; spinningEntity.modelIndex = 1
spinningEntity.effects = ceconstants.EF_SPINNINGLIGHTS
spinningSnapshot = crtypes.Snapshot(1, 0, 0, bytes([]), void, [spinningEntity])
spinningFrame = rt.defaultRefDef(640, 480)
ceentity.emit(spinningState, spinningSnapshot, void, 1.0, 0, 0, spinningFrame)
assertEqual(spinningFrame.dLights[0].origin.x, 64.0,
  "spinning light projects 64 units forward")
assertEqual(spinningFrame.dLights[0].intensity, 100.0, "spinning light intensity")

localState = cestate.createSilent(23)
localEntity = pt.zeroEntityState()
localEntity.number = 1; localEntity.modelIndex = 1
localEntity.effects = ceconstants.EF_FLAG1
localSnapshot = crtypes.Snapshot(1, 0, 0, bytes([]), void, [localEntity])
localFrame = rt.defaultRefDef(640, 480)
ceentity.emit(localState, localSnapshot, void, 1.0, 0, 1, localFrame)
assertEqual(localState.particleCount, 0, "local player flag omits third-person trail")
assertEqual(localFrame.dLights[0].intensity, 225.0, "local player flag light")

cestate.advance(first, 250)
assertEqual(len(first.dLights), 0, "dlight expiry")
assertEqual(len(first.lasers), 0, "laser expiry")
assertEqual(len(first.beams), 0, "beam expiry")
cestate.advance(first, 2000)
assertEqual(len(first.explosions), 0, "explosion expiry")
assertEqual(first.particleCount, 0, "particle fade expiry")
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
