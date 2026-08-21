/* cl_fx.c-style allocation, deterministic particles and lifecycle. */
package miniquake2.client.effects.state

import miniquake2.qcommon.types as qt
import miniquake2.client.effects.constants as ceconstants
import miniquake2.client.effects.types as cetypes
import miniquake2.client.effects.audio as ceaudio

function create(audioCallbacks, randomSeed)
  if typeof(randomSeed) != "int" then return error(7310, "effect random seed must be an integer") end if
  return cetypes.State(0, randomSeed & 0x7fffffff, [], [], [], [], [], [], [], audioCallbacks)
end function

function createSilent(randomSeed)
  return create(ceaudio.silent(), randomSeed)
end function

function random(state)
  state.randomSeed = (state.randomSeed * 1103515245 + 12345) & 0x7fffffff
  return (state.randomSeed >> 16) & 0x7fff
end function

function copyVec(value)
  return qt.Vec3(value.x, value.y, value.z)
end function

function vecFromArray(value)
  if typeof(value) != "array" or len(value) != 3 then return error(7311, "effect vector array must contain three values") end if
  return qt.Vec3(value[0] * 1.0, value[1] * 1.0, value[2] * 1.0)
end function

function add(first, second)
  return qt.Vec3(first.x + second.x, first.y + second.y, first.z + second.z)
end function

function scaled(value, amount)
  return qt.Vec3(value.x * amount, value.y * amount, value.z * amount)
end function

function allocateDLight(state, key)
  if key != 0 then
    for each light in state.dLights
      if light.key == key then
        light.origin = qt.zeroVec3(); light.color = [0.0, 0.0, 0.0]
        light.radius = 0.0; light.die = 0.0; light.decay = 0.0; light.minLight = 0.0
        return light
      end if
    end for
  end if
  light = cetypes.DLight(key, qt.zeroVec3(), [0.0, 0.0, 0.0], 0.0, 0.0, 0.0, 0.0)
  if len(state.dLights) < ceconstants.MAX_DLIGHTS then
    state.dLights = state.dLights + [light]
  else
    state.dLights[0] = light
  end if
  return light
end function

function addDLight(state, key, origin, radius, color, duration, decay)
  light = allocateDLight(state, key)
  light.origin = copyVec(origin)
  light.radius = radius
  light.color = [color[0], color[1], color[2]]
  light.die = state.time + duration
  light.decay = decay
  return light
end function

function addParticle(state, origin, velocity, acceleration, color, alpha, alphaVelocity)
  if len(state.particles) >= ceconstants.MAX_PARTICLES then return false end if
  state.particles = state.particles + [cetypes.Particle(copyVec(origin), copyVec(velocity),
    copyVec(acceleration), color, alpha, alphaVelocity, state.time)]
  return true
end function

function particleEffect(state, origin, direction, color, count, speed)
  if count < 0 then return error(7312, "negative effect particle count") end if
  index = 0
  while index < count and len(state.particles) < ceconstants.MAX_PARTICLES
    jitter = qt.Vec3((random(state) & 7) - 4.0, (random(state) & 7) - 4.0, (random(state) & 7) - 4.0)
    velocity = qt.Vec3(direction.x * speed + ((random(state) & 31) - 16.0),
      direction.y * speed + ((random(state) & 31) - 16.0),
      direction.z * speed + ((random(state) & 31) - 16.0))
    selectedColor = color + (random(state) & 7)
    addParticle(state, add(origin, jitter), velocity, qt.Vec3(0.0, 0.0, -ceconstants.PARTICLE_GRAVITY),
      selectedColor, 1.0, -1.0 / (0.5 + (random(state) & 7) * 0.1))
    index = index + 1
  end while
  return index
end function

function addBeam(state, entity, destinationEntity, modelName, start, finish, offset, playerLinked, duration)
  for each beam in state.beams
    if beam.entity == entity and (not playerLinked or beam.playerLinked) and
        (destinationEntity == 0 or beam.destinationEntity == destinationEntity) then
      beam.destinationEntity = destinationEntity; beam.modelName = modelName
      beam.endTime = state.time + duration; beam.start = copyVec(start); beam.finish = copyVec(finish)
      beam.offset = copyVec(offset); beam.playerLinked = playerLinked
      return beam
    end if
  end for
  beam = cetypes.Beam(entity, destinationEntity, modelName, state.time + duration,
    copyVec(offset), copyVec(start), copyVec(finish), playerLinked)
  if len(state.beams) < ceconstants.MAX_BEAMS then state.beams = state.beams + [beam] end if
  return beam
end function

function addLaser(state, start, finish, color)
  laser = cetypes.Laser(copyVec(start), copyVec(finish), color, state.time + 100)
  if len(state.lasers) < ceconstants.MAX_LASERS then state.lasers = state.lasers + [laser] end if
  return laser
end function

function addExplosion(state, kind, origin, modelName, frames, light, lightColor, flags, alpha)
  explosion = cetypes.Explosion(kind, copyVec(origin), qt.Vec3(0.0, (random(state) % 360) * 1.0, 0.0),
    modelName, frames, light, [lightColor[0], lightColor[1], lightColor[2]], state.time - 100,
    0, flags, alpha)
  if len(state.explosions) < ceconstants.MAX_EXPLOSIONS then
    state.explosions = state.explosions + [explosion]
  else
    state.explosions[0] = explosion
  end if
  return explosion
end function

function advance(state, now)
  if typeof(now) != "int" or now < state.time then return error(7313, "effect time must be monotonic integer milliseconds") end if
  seconds = (now - state.time) * 0.001
  activeSustains = []
  for each sustain in state.sustains
    if sustain.endTime >= now then
      if sustain.nextThink <= now then
        count = sustain.count
        if count <= 0 then count = 8 end if
        particleEffect(state, sustain.origin, sustain.direction, sustain.color, count, sustain.magnitude * 1.0)
        sustain.nextThink = now + sustain.thinkInterval
      end if
      activeSustains = activeSustains + [sustain]
    end if
  end for
  state.sustains = activeSustains
  activeLights = []
  for each light in state.dLights
    if light.radius > 0.0 and light.die >= now then
      light.radius = light.radius - seconds * light.decay
      if light.radius > 0.0 then activeLights = activeLights + [light] end if
    end if
  end for
  state.dLights = activeLights
  activeParticles = []
  for each particle in state.particles
    elapsed = (now - particle.startTime) * 0.001
    if particle.alphaVelocity == ceconstants.INSTANT_PARTICLE or particle.alpha + elapsed * particle.alphaVelocity > 0.0 then
      activeParticles = activeParticles + [particle]
    end if
  end for
  state.particles = activeParticles
  activeBeams = []
  for each beam in state.beams
    if beam.endTime >= now then activeBeams = activeBeams + [beam] end if
  end for
  state.beams = activeBeams
  activeLasers = []
  for each laser in state.lasers
    if laser.endTime >= now then activeLasers = activeLasers + [laser] end if
  end for
  state.lasers = activeLasers
  activeExplosions = []
  for each explosion in state.explosions
    frame = (now - explosion.startTime) / 100
    if frame < explosion.frames then activeExplosions = activeExplosions + [explosion] end if
  end for
  state.explosions = activeExplosions
  state.time = now
  return state
end function

function clear(state)
  state.dLights = []; state.particles = []; state.beams = []; state.lasers = []
  state.explosions = []; state.sustains = []; state.soundEvents = []
  return state
end function
