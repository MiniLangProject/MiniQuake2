/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* cl_fx.c-style allocation, deterministic particles and lifecycle. */
package miniquake2.client.effects.state

import std.math as cemath
import miniquake2.qcommon.types as qt
import miniquake2.qcommon.directions as cedirections
import miniquake2.client.effects.constants as ceconstants
import miniquake2.client.effects.types as cetypes
import miniquake2.client.effects.audio as ceaudio

// Create state.
function create(audioCallbacks, randomSeed)
  if typeof(randomSeed) != "int" then return error(7310, "effect random seed must be an integer") end if
  return cetypes.State(0, randomSeed & 0xffffffff, [], [], 0, [], [], [], [], [],
    array(486, 0.0), array(ceconstants.MAX_ENTITY_TRAILS, false), [], [],
    array(ceconstants.MAX_DLIGHTS, void), [], audioCallbacks)
end function

// Report whether create silent.
function createSilent(randomSeed)
  return create(ceaudio.silent(), randomSeed)
end function

// Return the random value.
function inline random(state)
  state.randomSeed = (state.randomSeed * 214013 + 2531011) & 0xffffffff
  return (state.randomSeed >> 16) & 0x7fff
end function

// Copy vec data.
function inline copyVec(value)
  return qt.Vec3(value.x, value.y, value.z)
end function

// Return the vec from array.
function vecFromArray(value)
  if typeof(value) != "array" or len(value) != 3 then return error(7311, "effect vector array must contain three values") end if
  return qt.Vec3(value[0] * 1.0, value[1] * 1.0, value[2] * 1.0)
end function

// Add state.
function inline add(first, second)
  return qt.Vec3(first.x + second.x, first.y + second.y, first.z + second.z)
end function

// Return the scaled value.
function inline scaled(value, amount)
  return qt.Vec3(value.x * amount, value.y * amount, value.z * amount)
end function

// Return the compact value.
function compact(values, count)
  if count == len(values) then return values end if
  if count <= 0 then return [] end if
  output = array(count)
  index = 0
  while index < count
    output[index] = values[index]
    index = index + 1
  end while
  return output
end function

// Allocate d light.
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

// Add d light.
function addDLight(state, key, origin, radius, color, duration, decay)
  light = allocateDLight(state, key)
  light.origin = copyVec(origin)
  light.radius = radius
  light.color = [color[0], color[1], color[2]]
  light.die = state.time + duration
  light.decay = decay
  return light
end function

// Reserve particles.
function reserveParticles(state, requested)
  available = ceconstants.MAX_PARTICLES - state.particleCount
  count = requested
  if count > available then count = available end if
  if count <= 0 then return 0 end if
  if len(state.particles) != ceconstants.MAX_PARTICLES then
    output = array(ceconstants.MAX_PARTICLES)
    index = 0
    while index < state.particleCount
      output[index] = state.particles[index]
      index = index + 1
    end while
    state.particles = output
  end if
  state.particleCount = state.particleCount + count
  return count
end function

// Add particle.
function addParticle(state, origin, velocity, acceleration, color, alpha, alphaVelocity)
  start = state.particleCount
  if reserveParticles(state, 1) == 0 then return false end if
  state.particles[start] = cetypes.Particle(copyVec(origin), copyVec(velocity),
    copyVec(acceleration), color, alpha, alphaVelocity, state.time)
  return true
end function

// Return the unit random value.
function inline unitRandom(state)
  return random(state) / 32767.0
end function

// Return the centered random value.
function inline centeredRandom(state)
  return unitRandom(state) * 2.0 - 1.0
end function

// Return the vector length.
function inline vectorLength(value)
  return cemath.sqrt(value.x * value.x + value.y * value.y + value.z * value.z)
end function

// Return the normalized value.
function inline normalized(value)
  length = vectorLength(value)
  if length <= 0.000001 then return qt.zeroVec3() end if
  return qt.Vec3(value.x / length, value.y / length, value.z / length)
end function

// Return the normal right value.
function inline normalRight(forward)
  right = qt.Vec3(forward.z, -forward.x, forward.y)
  projection = right.x * forward.x + right.y * forward.y + right.z * forward.z
  return normalized(qt.Vec3(right.x - projection * forward.x,
    right.y - projection * forward.y, right.z - projection * forward.z))
end function

// Compute state.
function inline cross(first, second)
  return qt.Vec3(first.y * second.z - first.z * second.y,
    first.z * second.x - first.x * second.z,
    first.x * second.y - first.y * second.x)
end function

// Return the stock directional particles value.
function stockDirectionalParticles(state, origin, direction, color, count, fixedColor, positiveGravity)
  if count < 0 then return error(7314, "negative stock particle count") end if
  start = state.particleCount
  count = reserveParticles(state, count)
  index = 0
  while index < count
    selectedColor = color
    distanceMask = 31
    if fixedColor then distanceMask = 7 else selectedColor = color + (random(state) & 7) end if
    distance = random(state) & distanceMask
    originX = origin.x + ((random(state) & 7) - 4.0) + distance * direction.x
    velocityX = centeredRandom(state) * 20.0
    originY = origin.y + ((random(state) & 7) - 4.0) + distance * direction.y
    velocityY = centeredRandom(state) * 20.0
    originZ = origin.z + ((random(state) & 7) - 4.0) + distance * direction.z
    velocityZ = centeredRandom(state) * 20.0
    particleOrigin = qt.Vec3(originX, originY, originZ)
    velocity = qt.Vec3(velocityX, velocityY, velocityZ)
    gravity = -ceconstants.PARTICLE_GRAVITY
    if positiveGravity then gravity = ceconstants.PARTICLE_GRAVITY end if
    state.particles[start + index] = cetypes.Particle(particleOrigin, velocity,
      qt.Vec3(0.0, 0.0, gravity), selectedColor, 1.0,
      -1.0 / (0.5 + unitRandom(state) * 0.3), state.time)
    index = index + 1
  end while
  return index
end function

// Return the wall particles value.
function wallParticles(state, origin, direction, color, count)
  return stockDirectionalParticles(state, origin, direction, color, count, false, false)
end function

// Return the fixed color particles value.
function fixedColorParticles(state, origin, direction, color, count, positiveGravity)
  return stockDirectionalParticles(state, origin, direction, color, count, true, positiveGravity)
end function

// Return the blaster particles value.
function blasterParticles(state, origin, direction, color)
  start = state.particleCount
  count = reserveParticles(state, 40)
  index = 0
  while index < count
    selectedColor = color + (random(state) & 7)
    distance = random(state) & 15
    originX = origin.x + ((random(state) & 7) - 4.0) + distance * direction.x
    velocityX = direction.x * 30.0 + centeredRandom(state) * 40.0
    originY = origin.y + ((random(state) & 7) - 4.0) + distance * direction.y
    velocityY = direction.y * 30.0 + centeredRandom(state) * 40.0
    originZ = origin.z + ((random(state) & 7) - 4.0) + distance * direction.z
    velocityZ = direction.z * 30.0 + centeredRandom(state) * 40.0
    particleOrigin = qt.Vec3(originX, originY, originZ)
    velocity = qt.Vec3(velocityX, velocityY, velocityZ)
    state.particles[start + index] = cetypes.Particle(particleOrigin, velocity,
      qt.Vec3(0.0, 0.0, -ceconstants.PARTICLE_GRAVITY), selectedColor, 1.0,
      -1.0 / (0.5 + unitRandom(state) * 0.3), state.time)
    index = index + 1
  end while
  return index
end function

// Return the explosion particles value.
function explosionParticles(state, origin, color, colorRun, count, velocityRange)
  start = state.particleCount
  count = reserveParticles(state, count)
  index = 0
  while index < count
    selectedColor = color + (random(state) % colorRun)
    originX = origin.x + (random(state) % 32) - 16.0
    velocityX = (random(state) % velocityRange) - velocityRange / 2.0
    originY = origin.y + (random(state) % 32) - 16.0
    velocityY = (random(state) % velocityRange) - velocityRange / 2.0
    originZ = origin.z + (random(state) % 32) - 16.0
    velocityZ = (random(state) % velocityRange) - velocityRange / 2.0
    particleOrigin = qt.Vec3(originX, originY, originZ)
    velocity = qt.Vec3(velocityX, velocityY, velocityZ)
    state.particles[start + index] = cetypes.Particle(particleOrigin, velocity,
      qt.Vec3(0.0, 0.0, -ceconstants.PARTICLE_GRAVITY), selectedColor, 1.0,
      -0.8 / (0.5 + unitRandom(state) * 0.3), state.time)
    index = index + 1
  end while
  return index
end function

// Return the steam particles value.
function steamParticles(state, origin, direction, color, count, magnitude, noGravity)
  forward = copyVec(direction)
  right = normalRight(forward)
  up = cross(right, forward)
  start = state.particleCount
  count = reserveParticles(state, count)
  index = 0
  while index < count
    selectedColor = color + (random(state) & 7)
    particleOrigin = qt.Vec3(origin.x + magnitude * 0.1 * centeredRandom(state),
      origin.y + magnitude * 0.1 * centeredRandom(state),
      origin.z + magnitude * 0.1 * centeredRandom(state))
    rightAmount = centeredRandom(state) * magnitude / 3.0
    upAmount = centeredRandom(state) * magnitude / 3.0
    velocity = qt.Vec3(forward.x * magnitude + right.x * rightAmount + up.x * upAmount,
      forward.y * magnitude + right.y * rightAmount + up.y * upAmount,
      forward.z * magnitude + right.z * rightAmount + up.z * upAmount)
    gravity = -ceconstants.PARTICLE_GRAVITY / 2.0
    if noGravity then gravity = 0.0 end if
    state.particles[start + index] = cetypes.Particle(particleOrigin, velocity,
      qt.Vec3(0.0, 0.0, gravity), selectedColor, 1.0,
      -1.0 / (0.5 + unitRandom(state) * 0.3), state.time)
    index = index + 1
  end while
  return index
end function

// Return the logout particles value.
function logoutParticles(state, origin, color)
  start = state.particleCount
  count = reserveParticles(state, 500)
  index = 0
  while index < count
    selectedColor = color + (random(state) & 7)
    particleOrigin = qt.Vec3(origin.x - 16.0 + unitRandom(state) * 32.0,
      origin.y - 16.0 + unitRandom(state) * 32.0,
      origin.z - 24.0 + unitRandom(state) * 56.0)
    velocity = qt.Vec3(centeredRandom(state) * 20.0,
      centeredRandom(state) * 20.0, centeredRandom(state) * 20.0)
    state.particles[start + index] = cetypes.Particle(particleOrigin, velocity,
      qt.Vec3(0.0, 0.0, -ceconstants.PARTICLE_GRAVITY), selectedColor,
      1.0, -1.0 / (1.0 + unitRandom(state) * 0.3), state.time)
    index = index + 1
  end while
  return index
end function

// Return the item respawn particles value.
function itemRespawnParticles(state, origin)
  start = state.particleCount
  count = reserveParticles(state, 64)
  index = 0
  while index < count
    selectedColor = 0xd4 + (random(state) & 3)
    particleOrigin = qt.Vec3(origin.x + centeredRandom(state) * 8.0,
      origin.y + centeredRandom(state) * 8.0, origin.z + centeredRandom(state) * 8.0)
    velocity = qt.Vec3(centeredRandom(state) * 8.0,
      centeredRandom(state) * 8.0, centeredRandom(state) * 8.0)
    state.particles[start + index] = cetypes.Particle(particleOrigin, velocity,
      qt.Vec3(0.0, 0.0, -ceconstants.PARTICLE_GRAVITY * 0.2), selectedColor,
      1.0, -1.0 / (1.0 + unitRandom(state) * 0.3), state.time)
    index = index + 1
  end while
  return index
end function

// Return the big teleport particles value.
function bigTeleportParticles(state, origin)
  start = state.particleCount
  count = reserveParticles(state, ceconstants.MAX_PARTICLES)
  index = 0
  while index < count
    colorChoice = random(state) & 3
    color = 16
    if colorChoice == 1 then color = 104 end if
    if colorChoice == 2 then color = 168 end if
    if colorChoice == 3 then color = 144 end if
    angle = 6.283185307179586 * (random(state) & 1023) / 1023.0
    distance = random(state) & 31
    cosine = cemath.cos(angle); sine = cemath.sin(angle)
    originX = origin.x + cosine * distance
    velocityX = cosine * (70.0 + (random(state) & 63))
    originY = origin.y + sine * distance
    velocityY = sine * (70.0 + (random(state) & 63))
    originZ = origin.z + 8.0 + (random(state) % 90)
    velocityZ = -100.0 + (random(state) & 31)
    particleOrigin = qt.Vec3(originX, originY, originZ)
    velocity = qt.Vec3(velocityX, velocityY, velocityZ)
    acceleration = qt.Vec3(-cosine * 100.0, -sine * 100.0,
      ceconstants.PARTICLE_GRAVITY * 4.0)
    state.particles[start + index] = cetypes.Particle(particleOrigin, velocity,
      acceleration, color, 1.0, -0.3 / (0.5 + unitRandom(state) * 0.3), state.time)
    index = index + 1
  end while
  return index
end function

// Return the teleport particles value.
function teleportParticles(state, origin)
  start = state.particleCount
  count = reserveParticles(state, 1053)
  index = 0; x = -16
  while x <= 16 and index < count
    y = -16
    while y <= 16 and index < count
      z = -16
      while z <= 32 and index < count
        color = 7 + (random(state) & 7)
        alphaVelocity = -1.0 / (0.3 + (random(state) & 7) * 0.02)
        particleOrigin = qt.Vec3(origin.x + x + (random(state) & 3),
          origin.y + y + (random(state) & 3), origin.z + z + (random(state) & 3))
        direction = normalized(qt.Vec3(y * 8.0, x * 8.0, z * 8.0))
        speed = 50.0 + (random(state) & 63)
        velocity = scaled(direction, speed)
        state.particles[start + index] = cetypes.Particle(particleOrigin, velocity,
          qt.Vec3(0.0, 0.0, -ceconstants.PARTICLE_GRAVITY), color, 1.0,
          alphaVelocity, state.time)
        index = index + 1; z = z + 4
      end while
      y = y + 4
    end while
    x = x + 4
  end while
  return index
end function

// EF_TELEPORTER is a persistent entity flag fired once for every accepted
// server frame. It is deliberately separate from the 1,053-particle player
// teleport event above.
function teleporterEntityParticles(state, origin)
  start = state.particleCount
  count = reserveParticles(state, 8)
  index = 0
  while index < count
    originX = origin.x - 16.0 + (random(state) & 31)
    velocityX = centeredRandom(state) * 14.0
    originY = origin.y - 16.0 + (random(state) & 31)
    velocityY = centeredRandom(state) * 14.0
    originZ = origin.z - 8.0 + (random(state) & 7)
    velocityZ = 80.0 + (random(state) & 7)
    particleOrigin = qt.Vec3(originX, originY, originZ)
    velocity = qt.Vec3(velocityX, velocityY, velocityZ)
    state.particles[start + index] = cetypes.Particle(particleOrigin, velocity,
      qt.Vec3(0.0, 0.0, -ceconstants.PARTICLE_GRAVITY), 0xdb, 1.0, -0.5,
      state.time)
    index = index + 1
  end while
  return index
end function

// Return the widow splash particles value.
function widowSplashParticles(state, origin)
  start = state.particleCount
  count = reserveParticles(state, 256)
  index = 0
  while index < count
    colorChoice = random(state) & 3
    color = 16
    if colorChoice == 1 then color = 104 end if
    if colorChoice == 2 then color = 168 end if
    if colorChoice == 3 then color = 144 end if
    directionX = centeredRandom(state); directionY = centeredRandom(state)
    directionZ = centeredRandom(state)
    direction = normalized(qt.Vec3(directionX, directionY, directionZ))
    state.particles[start + index] = cetypes.Particle(
      add(origin, scaled(direction, 45.0)), scaled(direction, 40.0), qt.zeroVec3(),
      color, 1.0, -0.8 / (0.5 + unitRandom(state) * 0.3), state.time)
    index = index + 1
  end while
  return index
end function

// Return the sustain radial particles value.
function sustainRadialParticles(state, sustain, now, nuke)
  duration = 2100.0; count = 300; distance = 45.0
  if nuke then duration = 1000.0; count = 700; distance = 200.0 end if
  ratio = 1.0 - (sustain.endTime - now) / duration
  start = state.particleCount
  count = reserveParticles(state, count)
  index = 0
  while index < count
    colorChoice = random(state) & 3
    color = 16
    if nuke then
      color = 110 + colorChoice * 2
    else
      if colorChoice == 1 then color = 104 end if
      if colorChoice == 2 then color = 168 end if
      if colorChoice == 3 then color = 144 end if
    end if
    directionX = centeredRandom(state); directionY = centeredRandom(state)
    directionZ = centeredRandom(state)
    direction = normalized(qt.Vec3(directionX, directionY, directionZ))
    state.particles[start + index] = cetypes.Particle(
      add(sustain.origin, scaled(direction, distance * ratio)), qt.zeroVec3(),
      qt.zeroVec3(), color, 1.0, ceconstants.INSTANT_PARTICLE, now)
    index = index + 1
  end while
  return index
end function

// Return the debug trail value.
function debugTrail(state, startPosition, endPosition)
  delta = qt.Vec3(endPosition.x - startPosition.x, endPosition.y - startPosition.y,
    endPosition.z - startPosition.z)
  length = vectorLength(delta)
  direction = normalized(delta)
  step = scaled(direction, 3.0)
  move = copyVec(startPosition)
  start = state.particleCount
  reserved = reserveParticles(state, ceconstants.MAX_PARTICLES - state.particleCount)
  written = 0
  while length > 0.0 and written < reserved
    length = length - 3.0
    color = 0x74 + (random(state) & 7)
    particleOrigin = qt.Vec3(move.x + centeredRandom(state) * 3.0,
      move.y + centeredRandom(state) * 3.0, move.z + centeredRandom(state) * 3.0)
    velocity = qt.Vec3(0.0, 0.0, 20.0 + centeredRandom(state) * 5.0)
    state.particles[start + written] = cetypes.Particle(particleOrigin, velocity,
      qt.zeroVec3(), color, 1.0, -0.1, state.time)
    move = add(move, step); written = written + 1
  end while
  state.particleCount = start + written
  return written
end function

// Return the bubble trail value.
function bubbleTrail(state, startPosition, endPosition, spacing, rise)
  delta = qt.Vec3(endPosition.x - startPosition.x, endPosition.y - startPosition.y,
    endPosition.z - startPosition.z)
  length = vectorLength(delta)
  direction = normalized(delta)
  step = scaled(direction, spacing * 1.0)
  move = copyVec(startPosition)
  start = state.particleCount
  reserved = reserveParticles(state, ceconstants.MAX_PARTICLES - state.particleCount)
  written = 0; distance = 0
  while distance < length and written < reserved
    alphaVelocity = 0.0
    if spacing == 32 then
      alphaVelocity = -1.0 / (1.0 + unitRandom(state) * 0.2)
    else
      alphaVelocity = -1.0 / (1.0 + unitRandom(state) * 0.1)
    end if
    color = 4 + (random(state) & 7)
    originX = move.x + centeredRandom(state) * 2.0
    velocityX = centeredRandom(state) * 10.0
    originY = move.y + centeredRandom(state) * 2.0
    velocityY = centeredRandom(state) * 10.0
    originZ = move.z + centeredRandom(state) * 2.0
    velocityZ = centeredRandom(state) * 10.0
    if spacing == 32 then
      velocityX = velocityX * 0.5; velocityY = velocityY * 0.5
      velocityZ = velocityZ * 0.5 + rise
    else
      originZ = originZ - 4.0; velocityZ = velocityZ + rise
    end if
    state.particles[start + written] = cetypes.Particle(qt.Vec3(originX, originY, originZ),
      qt.Vec3(velocityX, velocityY, velocityZ), qt.zeroVec3(), color, 1.0,
      alphaVelocity, state.time)
    move = add(move, step); written = written + 1; distance = distance + spacing
  end while
  state.particleCount = start + written
  return written
end function

// Return the force wall particles value.
function forceWallParticles(state, startPosition, endPosition, color)
  delta = qt.Vec3(endPosition.x - startPosition.x, endPosition.y - startPosition.y,
    endPosition.z - startPosition.z)
  length = vectorLength(delta)
  step = scaled(normalized(delta), 4.0)
  move = copyVec(startPosition)
  start = state.particleCount
  reserved = reserveParticles(state, ceconstants.MAX_PARTICLES - state.particleCount)
  written = 0
  while length > 0.0 and written < reserved
    length = length - 4.0
    if unitRandom(state) > 0.3 then
      alphaVelocity = -1.0 / (3.0 + unitRandom(state) * 0.5)
      particleOrigin = qt.Vec3(move.x + centeredRandom(state) * 3.0,
        move.y + centeredRandom(state) * 3.0, move.z + centeredRandom(state) * 3.0)
      velocity = qt.Vec3(0.0, 0.0, -40.0 - centeredRandom(state) * 10.0)
      state.particles[start + written] = cetypes.Particle(particleOrigin, velocity,
        qt.zeroVec3(), color, 1.0, alphaVelocity, state.time)
      written = written + 1
    end if
    move = add(move, step)
  end while
  state.particleCount = start + written
  return written
end function

// Return the rail trail value.
function railTrail(state, startPosition, endPosition)
  delta = qt.Vec3(endPosition.x - startPosition.x, endPosition.y - startPosition.y,
    endPosition.z - startPosition.z)
  length = vectorLength(delta)
  direction = normalized(delta)
  right = normalRight(direction); up = cross(right, direction)
  start = state.particleCount
  reserved = reserveParticles(state, ceconstants.MAX_PARTICLES - state.particleCount)
  written = 0; distance = 0; move = copyVec(startPosition)
  while distance < length and written < reserved
    angle = distance * 0.1
    cosine = cemath.cos(angle); sine = cemath.sin(angle)
    ring = qt.Vec3(right.x * cosine + up.x * sine,
      right.y * cosine + up.y * sine, right.z * cosine + up.z * sine)
    alphaVelocity = -1.0 / (1.0 + unitRandom(state) * 0.2)
    color = 0x74 + (random(state) & 7)
    state.particles[start + written] = cetypes.Particle(add(move, scaled(ring, 3.0)),
      scaled(ring, 6.0), qt.zeroVec3(), color, 1.0, alphaVelocity, state.time)
    move = add(move, direction); written = written + 1; distance = distance + 1
  end while
  remaining = length; move = copyVec(startPosition); step = scaled(direction, 0.75)
  while remaining > 0.0 and written < reserved
    remaining = remaining - 0.75
    alphaVelocity = -1.0 / (0.6 + unitRandom(state) * 0.2)
    color = random(state) & 15
    originX = move.x + centeredRandom(state) * 3.0
    velocityX = centeredRandom(state) * 3.0
    originY = move.y + centeredRandom(state) * 3.0
    velocityY = centeredRandom(state) * 3.0
    originZ = move.z + centeredRandom(state) * 3.0
    velocityZ = centeredRandom(state) * 3.0
    state.particles[start + written] = cetypes.Particle(qt.Vec3(originX, originY, originZ),
      qt.Vec3(velocityX, velocityY, velocityZ), qt.zeroVec3(), color, 1.0,
      alphaVelocity, state.time)
    move = add(move, step); written = written + 1
  end while
  state.particleCount = start + written
  return written
end function

// Return the simple entity trail value.
function simpleEntityTrail(state, startPosition, endPosition, color, originSpread,
    velocitySpread, alpha, alphaBase, alphaRange, inclusive)
  delta = qt.Vec3(endPosition.x - startPosition.x, endPosition.y - startPosition.y,
    endPosition.z - startPosition.z)
  length = vectorLength(delta)
  step = scaled(normalized(delta), 5.0)
  move = copyVec(startPosition)
  start = state.particleCount
  reserved = reserveParticles(state, ceconstants.MAX_PARTICLES - state.particleCount)
  written = 0
  while (length > 0.0 or (inclusive and length >= 0.0)) and written < reserved
    length = length - 5.0
    alphaVelocity = -1.0 / (alphaBase + unitRandom(state) * alphaRange)
    originX = move.x + centeredRandom(state) * originSpread
    velocityX = centeredRandom(state) * velocitySpread
    originY = move.y + centeredRandom(state) * originSpread
    velocityY = centeredRandom(state) * velocitySpread
    originZ = move.z + centeredRandom(state) * originSpread
    velocityZ = centeredRandom(state) * velocitySpread
    state.particles[start + written] = cetypes.Particle(qt.Vec3(originX, originY, originZ),
      qt.Vec3(velocityX, velocityY, velocityZ), qt.zeroVec3(), color, alpha,
      alphaVelocity, state.time)
    move = add(move, step); written = written + 1
  end while
  state.particleCount = start + written
  return written
end function

// Return the blaster trail value.
function blasterTrail(state, startPosition, endPosition, green)
  color = 0xe0
  if green then color = 0xd0 end if
  written = simpleEntityTrail(state, startPosition, endPosition, color, 1.0, 5.0,
    1.0, 0.3, 0.2, false)
  // Interpolation can move a fast bolt by less than the stock five-unit trail
  // spacing at high FPS. Add a short-lived core at the current endpoint so the
  // actual projectile remains continuous instead of blinking between samples.
  deltaX = endPosition.x - startPosition.x
  deltaY = endPosition.y - startPosition.y
  deltaZ = endPosition.z - startPosition.z
  if deltaX * deltaX + deltaY * deltaY + deltaZ * deltaZ > 0.0001 then
    if addParticle(state, endPosition, qt.zeroVec3(), qt.zeroVec3(), color,
        1.0, -12.5) then written = written + 1 end if
  end if
  return written
end function

// Return the flag trail value.
function flagTrail(state, startPosition, endPosition, color, inclusive)
  return simpleEntityTrail(state, startPosition, endPosition, color, 16.0, 5.0,
    1.0, 0.8, 0.2, inclusive)
end function

// Return the ion ripper trail value.
function ionRipperTrail(state, startPosition, endPosition)
  delta = qt.Vec3(endPosition.x - startPosition.x, endPosition.y - startPosition.y,
    endPosition.z - startPosition.z)
  length = vectorLength(delta)
  step = scaled(normalized(delta), 5.0)
  move = copyVec(startPosition)
  start = state.particleCount
  reserved = reserveParticles(state, ceconstants.MAX_PARTICLES - state.particleCount)
  written = 0; left = false
  while length > 0.0 and written < reserved
    length = length - 5.0
    alphaVelocity = -1.0 / (0.3 + unitRandom(state) * 0.2)
    color = 0xe4 + (random(state) & 3)
    velocityX = -10.0
    if left then velocityX = 10.0 end if
    left = not left
    state.particles[start + written] = cetypes.Particle(copyVec(move),
      qt.Vec3(velocityX, 0.0, 0.0), qt.zeroVec3(), color, 0.5,
      alphaVelocity, state.time)
    move = add(move, step); written = written + 1
  end while
  state.particleCount = start + written
  return written
end function

// Return the diminishing trail value.
function diminishingTrail(state, startPosition, endPosition, trail, flags)
  // Keep diminishing trail phases explicit: validate inputs, update owned state, then publish the result.
  delta = qt.Vec3(endPosition.x - startPosition.x, endPosition.y - startPosition.y,
    endPosition.z - startPosition.z)
  length = vectorLength(delta)
  step = scaled(normalized(delta), 0.5)
  move = copyVec(startPosition)
  originScale = 1.0; velocityScale = 5.0
  if trail.trailCount > 900 then
    originScale = 4.0; velocityScale = 15.0
  else if trail.trailCount > 800 then
    originScale = 2.0; velocityScale = 10.0
  end if
  start = state.particleCount
  reserved = reserveParticles(state, ceconstants.MAX_PARTICLES - state.particleCount)
  written = 0
  while length > 0.0 and written < reserved
    length = length - 0.5
    if (random(state) & 1023) < trail.trailCount then
      gib = (flags & ceconstants.EF_GIB) != 0
      greenGib = (flags & ceconstants.EF_GREENGIB) != 0
      alphaRange = 0.2
      if gib or greenGib then alphaRange = 0.4 end if
      alphaVelocity = -1.0 / (1.0 + unitRandom(state) * alphaRange)
      color = 4 + (random(state) & 7)
      if gib then color = 0xe8 + (color - 4) end if
      if greenGib then color = 0xdb + (color - 4) end if
      originX = move.x + centeredRandom(state) * originScale
      velocityX = centeredRandom(state) * velocityScale
      originY = move.y + centeredRandom(state) * originScale
      velocityY = centeredRandom(state) * velocityScale
      originZ = move.z + centeredRandom(state) * originScale
      velocityZ = centeredRandom(state) * velocityScale
      accelerationZ = 20.0
      if gib or greenGib then
        accelerationZ = 0.0; velocityZ = velocityZ - ceconstants.PARTICLE_GRAVITY
      end if
      state.particles[start + written] = cetypes.Particle(
        qt.Vec3(originX, originY, originZ), qt.Vec3(velocityX, velocityY, velocityZ),
        qt.Vec3(0.0, 0.0, accelerationZ), color, 1.0, alphaVelocity, state.time)
      written = written + 1
    end if
    trail.trailCount = trail.trailCount - 5
    if trail.trailCount < 100 then trail.trailCount = 100 end if
    move = add(move, step)
  end while
  state.particleCount = start + written
  return written
end function

// Return the rocket trail value.
function rocketTrail(state, startPosition, endPosition, trail)
  written = diminishingTrail(state, startPosition, endPosition, trail,
    ceconstants.EF_ROCKET)
  delta = qt.Vec3(endPosition.x - startPosition.x, endPosition.y - startPosition.y,
    endPosition.z - startPosition.z)
  length = vectorLength(delta)
  step = normalized(delta); move = copyVec(startPosition)
  start = state.particleCount
  reserved = reserveParticles(state, ceconstants.MAX_PARTICLES - state.particleCount)
  fireCount = 0
  while length > 0.0 and fireCount < reserved
    length = length - 1.0
    if (random(state) & 7) == 0 then
      alphaVelocity = -1.0 / (1.0 + unitRandom(state) * 0.2)
      color = 0xdc + (random(state) & 3)
      originX = move.x + centeredRandom(state) * 5.0
      velocityX = centeredRandom(state) * 20.0
      originY = move.y + centeredRandom(state) * 5.0
      velocityY = centeredRandom(state) * 20.0
      originZ = move.z + centeredRandom(state) * 5.0
      velocityZ = centeredRandom(state) * 20.0
      state.particles[start + fireCount] = cetypes.Particle(
        qt.Vec3(originX, originY, originZ), qt.Vec3(velocityX, velocityY, velocityZ),
        qt.Vec3(0.0, 0.0, -ceconstants.PARTICLE_GRAVITY), color, 1.0,
        alphaVelocity, state.time)
      fireCount = fireCount + 1
    end if
    move = add(move, step)
  end while
  state.particleCount = start + fireCount
  return written + fireCount
end function

// Return the tracker trail value.
function trackerTrail(state, startPosition, endPosition, color)
  delta = qt.Vec3(endPosition.x - startPosition.x, endPosition.y - startPosition.y,
    endPosition.z - startPosition.z)
  length = vectorLength(delta)
  forward = normalized(delta); right = normalRight(forward)
  up = cross(right, forward); step = scaled(forward, 3.0)
  move = copyVec(startPosition)
  start = state.particleCount
  reserved = reserveParticles(state, ceconstants.MAX_PARTICLES - state.particleCount)
  written = 0
  while length > 0.0 and written < reserved
    length = length - 3.0
    distance = move.x * forward.x + move.y * forward.y + move.z * forward.z
    particleOrigin = add(move, scaled(up, 8.0 * cemath.cos(distance)))
    state.particles[start + written] = cetypes.Particle(particleOrigin,
      qt.Vec3(0.0, 0.0, 5.0), qt.zeroVec3(), color, 1.0, -2.0, state.time)
    move = add(move, step); written = written + 1
  end while
  state.particleCount = start + written
  return written
end function

// Return the instant shell particles value.
function instantShellParticles(state, origin, color, count, radius)
  start = state.particleCount
  count = reserveParticles(state, count)
  index = 0
  while index < count
    directionX = centeredRandom(state); directionY = centeredRandom(state)
    directionZ = centeredRandom(state)
    direction = normalized(qt.Vec3(directionX, directionY, directionZ))
    state.particles[start + index] = cetypes.Particle(
      add(origin, scaled(direction, radius)), qt.zeroVec3(), qt.zeroVec3(),
      color, 1.0, ceconstants.INSTANT_PARTICLE, state.time)
    index = index + 1
  end while
  return index
end function

// Ensure angular velocities.
function ensureAngularVelocities(state)
  // The original client owns one static 162x3 table and lazily fills it from
  // the same Visual C random stream used by all other client effects.
  if state.angularVelocities[0] != 0.0 then return true end if
  index = 0
  while index < len(state.angularVelocities)
    state.angularVelocities[index] = (random(state) & 255) * 0.01
    index = index + 1
  end while
  return true
end function

// Return the fly particles value.
function flyParticles(state, origin, count)
  if count > 162 then count = 162 end if
  if count <= 0 then return 0 end if
  ensureAngularVelocities(state)
  requested = (count + 1) / 2
  start = state.particleCount
  available = reserveParticles(state, requested)
  written = 0; directionIndex = 0
  ltime = state.time / 1000.0
  while directionIndex < count and written < available
    velocityIndex = directionIndex * 3
    yaw = ltime * state.angularVelocities[velocityIndex]
    pitch = ltime * state.angularVelocities[velocityIndex + 1]
    cosinePitch = cemath.cos(pitch)
    forward = qt.Vec3(cosinePitch * cemath.cos(yaw),
      cosinePitch * cemath.sin(yaw), -cemath.sin(pitch))
    distance = cemath.sin(ltime + directionIndex) * 64.0
    normal = cedirections.normals[directionIndex]
    particleOrigin = qt.Vec3(origin.x + normal[0] * distance + forward.x * 16.0,
      origin.y + normal[1] * distance + forward.y * 16.0,
      origin.z + normal[2] * distance + forward.z * 16.0)
    state.particles[start + written] = cetypes.Particle(particleOrigin,
      qt.zeroVec3(), qt.zeroVec3(), 0, 1.0, -100.0, state.time)
    directionIndex = directionIndex + 2; written = written + 1
  end while
  state.particleCount = start + written
  return written
end function

// Return the fly effect value.
function flyEffect(state, trail, origin)
  startTime = state.time
  if trail.flyStopTime < state.time then
    startTime = state.time
    trail.flyStopTime = state.time + 60000
  else
    startTime = trail.flyStopTime - 60000
  end if
  elapsed = state.time - startTime
  count = 0
  if elapsed < 20000 then
    count = cemath.floor(elapsed * 162.0 / 20000.0)
  else
    remaining = trail.flyStopTime - state.time
    if remaining < 20000 then count = cemath.floor(remaining * 162.0 / 20000.0)
    else count = 162
    end if
  end if
  return flyParticles(state, origin, count)
end function

// Return the bfg particles value.
function bfgParticles(state, origin)
  ensureAngularVelocities(state)
  start = state.particleCount
  count = reserveParticles(state, 162)
  index = 0
  ltime = state.time / 1000.0
  while index < count
    velocityIndex = index * 3
    yaw = ltime * state.angularVelocities[velocityIndex]
    pitch = ltime * state.angularVelocities[velocityIndex + 1]
    cosinePitch = cemath.cos(pitch)
    forward = qt.Vec3(cosinePitch * cemath.cos(yaw),
      cosinePitch * cemath.sin(yaw), -cemath.sin(pitch))
    orbit = cemath.sin(ltime + index) * 64.0
    normal = cedirections.normals[index]
    particleOrigin = qt.Vec3(origin.x + normal[0] * orbit + forward.x * 16.0,
      origin.y + normal[1] * orbit + forward.y * 16.0,
      origin.z + normal[2] * orbit + forward.z * 16.0)
    distance = vectorLength(qt.Vec3(particleOrigin.x - origin.x,
      particleOrigin.y - origin.y, particleOrigin.z - origin.z)) / 90.0
    state.particles[start + index] = cetypes.Particle(particleOrigin,
      qt.zeroVec3(), qt.zeroVec3(), cemath.floor(0xd0 + distance * 7.0),
      1.0 - distance, -100.0, state.time)
    index = index + 1
  end while
  return index
end function

// Return the trap particles value.
function trapParticles(state, shiftedOrigin)
  start = state.particleCount
  count = reserveParticles(state, 21)
  written = 0
  move = qt.Vec3(shiftedOrigin.x, shiftedOrigin.y, shiftedOrigin.z - 14.0)
  remaining = 64.0
  while remaining > 0.0 and written < count
    remaining = remaining - 5.0
    alphaVelocity = -1.0 / (0.3 + unitRandom(state) * 0.2)
    originX = move.x + centeredRandom(state)
    velocityX = centeredRandom(state) * 15.0
    originY = move.y + centeredRandom(state)
    velocityY = centeredRandom(state) * 15.0
    originZ = move.z + centeredRandom(state)
    velocityZ = centeredRandom(state) * 15.0
    state.particles[start + written] = cetypes.Particle(
      qt.Vec3(originX, originY, originZ),
      qt.Vec3(velocityX, velocityY, velocityZ),
      qt.Vec3(0.0, 0.0, ceconstants.PARTICLE_GRAVITY), 0xe0, 1.0,
      alphaVelocity, state.time)
    move.z = move.z + 5.0; written = written + 1
  end while
  i = -2
  while i <= 2 and written < count
    j = -2
    while j <= 2 and written < count
      k = -2
      while k <= 4 and written < count
        color = 0xe0 + (random(state) & 3)
        alphaVelocity = -1.0 / (0.3 + (random(state) & 7) * 0.02)
        originX = shiftedOrigin.x + i + (random(state) & 23) * centeredRandom(state)
        originY = shiftedOrigin.y + j + (random(state) & 23) * centeredRandom(state)
        originZ = shiftedOrigin.z + k + (random(state) & 23) * centeredRandom(state)
        direction = normalized(qt.Vec3(j * 8.0, i * 8.0, k * 8.0))
        speed = ((50 + random(state)) & 63) * 1.0
        state.particles[start + written] = cetypes.Particle(
          qt.Vec3(originX, originY, originZ), scaled(direction, speed),
          qt.Vec3(0.0, 0.0, -ceconstants.PARTICLE_GRAVITY), color, 1.0,
          alphaVelocity, state.time)
        k = k + 4; written = written + 1
      end while
      j = j + 4
    end while
    i = i + 4
  end while
  state.particleCount = start + written
  return written
end function

// Reset entity trails.
function resetEntityTrails(state)
  index = 0
  while index < len(state.entityTrails)
    state.entityTrails[index] = false
    index = index + 1
  end while
  return state
end function

// Add beam.
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

// Add laser.
function addLaser(state, start, finish, color)
  laser = cetypes.Laser(copyVec(start), copyVec(finish), color, state.time + 100)
  if len(state.lasers) < ceconstants.MAX_LASERS then state.lasers = state.lasers + [laser] end if
  return laser
end function

// Add explosion exact.
function addExplosionExact(state, kind, origin, angles, modelName, frames, light, lightColor,
    startTime, baseFrame, flags, alpha, skinNum)
  explosion = cetypes.Explosion(kind, copyVec(origin), copyVec(angles),
    modelName, frames, light, [lightColor[0], lightColor[1], lightColor[2]], startTime,
    baseFrame, flags, alpha, skinNum)
  if len(state.explosions) < ceconstants.MAX_EXPLOSIONS then
    state.explosions = state.explosions + [explosion]
  else
    state.explosions[0] = explosion
  end if
  return explosion
end function

// Add explosion.
function addExplosion(state, kind, origin, modelName, frames, light, lightColor, flags, alpha)
  skinNum = 0
  if kind == ceconstants.TE_BLASTER2 then skinNum = 1 end if
  if kind == ceconstants.TE_FLECHETTE then skinNum = 2 end if
  return addExplosionExact(state, kind, origin,
    qt.Vec3(0.0, (random(state) % 360) * 1.0, 0.0), modelName, frames,
    light, lightColor, state.time, 0, flags, alpha, skinNum)
end function

// Advance state.
function advance(state, now)
  // Keep advance phases explicit: validate inputs, update owned state, then publish the result.
  if typeof(now) != "int" or now < state.time then return error(7313, "effect time must be monotonic integer milliseconds") end if
  previousTime = state.time
  seconds = (now - previousTime) * 0.001
  state.time = now
  activeSustainCount = 0
  for each sustain in state.sustains
    if sustain.endTime >= now then
      if sustain.nextThink <= now then
        if sustain.kind == ceconstants.TE_WIDOWBEAMOUT then
          sustainRadialParticles(state, sustain, now, false)
        else if sustain.kind == ceconstants.TE_NUKEBLAST then
          sustainRadialParticles(state, sustain, now, true)
        else
          steamParticles(state, sustain.origin, sustain.direction, sustain.color,
            sustain.count, sustain.magnitude * 1.0, false)
        end if
        sustain.nextThink = sustain.nextThink + sustain.thinkInterval
      end if
      state.sustains[activeSustainCount] = sustain
      activeSustainCount = activeSustainCount + 1
    end if
  end for
  state.sustains = compact(state.sustains, activeSustainCount)
  activeLightCount = 0
  for each light in state.dLights
    // The original client parses and draws with one frame-stable `cl.time`.
    // Our packet and render clocks can differ by a few milliseconds, so retain
    // a newly parsed zero-duration muzzle light through its first advance.
    sameFrameLight = light.die >= previousTime and
      light.die <= previousTime + 1.0
    if light.radius > 0.0 and (light.die >= now or sameFrameLight) then
      light.radius = light.radius - seconds * light.decay
      if light.radius > 0.0 then
        state.dLights[activeLightCount] = light
        activeLightCount = activeLightCount + 1
      end if
    end if
  end for
  state.dLights = compact(state.dLights, activeLightCount)
  oldParticleCount = state.particleCount
  activeParticleCount = 0
  particleIndex = 0
  while particleIndex < oldParticleCount
    particle = state.particles[particleIndex]
    elapsed = (now - particle.startTime) * 0.001
    if particle.alphaVelocity == ceconstants.INSTANT_PARTICLE or particle.alpha + elapsed * particle.alphaVelocity > 0.0 then
      state.particles[activeParticleCount] = particle
      activeParticleCount = activeParticleCount + 1
    end if
    particleIndex = particleIndex + 1
  end while
  state.particleCount = activeParticleCount
  activeBeamCount = 0
  for each beam in state.beams
    if beam.endTime >= now then
      state.beams[activeBeamCount] = beam
      activeBeamCount = activeBeamCount + 1
    end if
  end for
  state.beams = compact(state.beams, activeBeamCount)
  activeLaserCount = 0
  for each laser in state.lasers
    if laser.endTime >= now then
      state.lasers[activeLaserCount] = laser
      activeLaserCount = activeLaserCount + 1
    end if
  end for
  state.lasers = compact(state.lasers, activeLaserCount)
  activeExplosionCount = 0
  for each explosion in state.explosions
    frame = (now - explosion.startTime) / 100
    if frame < explosion.frames - 1 then
      state.explosions[activeExplosionCount] = explosion
      activeExplosionCount = activeExplosionCount + 1
    end if
  end for
  state.explosions = compact(state.explosions, activeExplosionCount)
  return state
end function

// Clear state.
function clear(state)
  state.particleCount = 0
  state.dLights = []; state.beams = []; state.lasers = []
  state.explosions = []; state.sustains = []; state.soundEvents = []
  resetEntityTrails(state)
  return state
end function
