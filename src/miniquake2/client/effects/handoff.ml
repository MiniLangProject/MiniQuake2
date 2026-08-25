/* Append live effects to renderer.types.RefDef without proprietary assets. */
package miniquake2.client.effects.handoff

import std.math as cemath
import miniquake2.qcommon.types as qt
import miniquake2.qcommon.byteio as qbio
import miniquake2.renderer.constants as rc
import miniquake2.renderer.types as rt
import miniquake2.client.effects.constants as ceconstants
import miniquake2.client.effects.state as cestate

function appendLimited(values, additions, maximum)
  if len(additions) == 0 and len(values) <= maximum then return values end if
  if len(values) == 0 and len(additions) <= maximum then return additions end if
  total = len(values) + len(additions)
  if total > maximum then total = maximum end if
  if total <= 0 then return [] end if
  result = array(total)
  outputIndex = 0
  while outputIndex < len(values) and outputIndex < total
    result[outputIndex] = values[outputIndex]
    outputIndex = outputIndex + 1
  end while
  additionIndex = 0
  while outputIndex < total
    result[outputIndex] = additions[additionIndex]
    outputIndex = outputIndex + 1
    additionIndex = additionIndex + 1
  end while
  return result
end function

function trim(values, count)
  if count == len(values) then return values end if
  if count <= 0 then return [] end if
  compact = array(count)
  index = 0
  while index < count
    compact[index] = values[index]
    index = index + 1
  end while
  return compact
end function

function particleOrigin(particle, now)
  elapsed = (now - particle.startTime) * 0.001
  squared = elapsed * elapsed
  return qt.Vec3(
    particle.origin.x + particle.velocity.x * elapsed + particle.acceleration.x * squared,
    particle.origin.y + particle.velocity.y * elapsed + particle.acceleration.y * squared,
    particle.origin.z + particle.velocity.z * elapsed + particle.acceleration.z * squared)
end function

function rendererParticles(state, now)
  if state.particleCount <= 0 then return [] end if
  output = array(state.particleCount)
  outputIndex = 0
  particleIndex = 0
  while particleIndex < state.particleCount
    particle = state.particles[particleIndex]
    elapsed = (now - particle.startTime) * 0.001
    instant = particle.alphaVelocity == ceconstants.INSTANT_PARTICLE
    alpha = particle.alpha + elapsed * particle.alphaVelocity
    if instant then alpha = particle.alpha end if
    if alpha > 1.0 then alpha = 1.0 end if
    if alpha > 0.0 then
      origin = particleOrigin(particle, now)
      if instant then origin = cestate.copyVec(particle.origin) end if
      output[outputIndex] = rt.particle(origin, particle.color & 255, alpha)
      outputIndex = outputIndex + 1
    end if
    if instant then particle.alpha = 0.0; particle.alphaVelocity = 0.0 end if
    particleIndex = particleIndex + 1
  end while
  return trim(output, outputIndex)
end function

function rendererDLights(state)
  if len(state.dLights) == 0 then return [] end if
  output = array(len(state.dLights))
  outputIndex = 0
  for each light in state.dLights
    color = qt.Vec3(light.color[0], light.color[1], light.color[2])
    output[outputIndex] = rt.dLight(cestate.copyVec(light.origin), color, light.radius)
    outputIndex = outputIndex + 1
  end for
  return trim(output, outputIndex)
end function

function beamOrigin(beam, refDef)
  if not beam.playerLinked then return cestate.add(beam.start, beam.offset) end if
  pitch = refDef.viewAngles.x * 0.017453292519943295
  yaw = refDef.viewAngles.y * 0.017453292519943295
  roll = refDef.viewAngles.z * 0.017453292519943295
  pitchSine = cemath.sin(pitch); pitchCosine = cemath.cos(pitch)
  yawSine = cemath.sin(yaw); yawCosine = cemath.cos(yaw)
  rollSine = cemath.sin(roll); rollCosine = cemath.cos(roll)
  forwardX = pitchCosine * yawCosine; forwardY = pitchCosine * yawSine; forwardZ = -pitchSine
  rightX = -rollSine * pitchSine * yawCosine + rollCosine * yawSine
  rightY = -rollSine * pitchSine * yawSine - rollCosine * yawCosine
  rightZ = -rollSine * pitchCosine
  upX = rollCosine * pitchSine * yawCosine + rollSine * yawSine
  upY = rollCosine * pitchSine * yawSine - rollSine * yawCosine
  upZ = rollCosine * pitchCosine
  offset = beam.offset; origin = refDef.viewOrigin
  return qt.Vec3(
    origin.x + rightX * offset.x + forwardX * offset.y + upX * offset.z,
    origin.y + rightY * offset.x + forwardY * offset.y + upY * offset.z,
    origin.z + rightZ * offset.x + forwardZ * offset.y + upZ * offset.z)
end function

function appendBeamEntities(output, count, maximum, beam, now, modelResolver, refDef)
  if count >= maximum then return count end if
  model = modelResolver(beam.modelName)
  origin = beamOrigin(beam, refDef)
  finish = beam.finish
  directionX = finish.x - origin.x; directionY = finish.y - origin.y; directionZ = finish.z - origin.z
  distance = cemath.sqrt(directionX * directionX + directionY * directionY + directionZ * directionZ)
  if distance <= 0.000001 then return count end if
  normalizedX = directionX / distance; normalizedY = directionY / distance; normalizedZ = directionZ / distance
  yaw = 0.0; pitch = 0.0
  if directionX == 0.0 and directionY == 0.0 then
    if directionZ > 0.0 then pitch = 90.0 else pitch = 270.0 end if
  else
    yaw = cemath.atan2(directionY, directionX) * 57.29577951308232
    if yaw < 0.0 then yaw = yaw + 360.0 end if
    forward = cemath.sqrt(directionX * directionX + directionY * directionY)
    pitch = cemath.atan2(directionZ, forward) * -57.29577951308232
    if pitch < 0.0 then pitch = pitch + 360.0 end if
  end if

  lightning = beam.modelName == "models/proj/lightning/tris.md2"
  heatBeam = beam.modelName == "models/proj/beam/tris.md2"
  modelLength = 30.0
  if heatBeam then modelLength = 32.0 end if
  if lightning then modelLength = 35.0; distance = distance - 20.0 end if
  if distance <= 0.0 then distance = modelLength end if
  steps = qbio.truncInt(cemath.ceil(distance / modelLength))
  spacing = modelLength
  if steps > 1 then spacing = (distance - modelLength) / (steps - 1) end if

  if lightning and distance <= modelLength then
    angles = qt.Vec3(pitch, yaw, ((now + beam.entity * 31) % 360) * 1.0)
    output[count] = rt.entity(model, angles, cestate.copyVec(finish), 0,
      cestate.copyVec(finish), 0, 0.0, 0, 0, 1.0, void, rc.RF_FULLBRIGHT)
    return count + 1
  end if

  remaining = distance; segment = 0
  while remaining > 0.0 and count < maximum
    flags = 0; frame = 0
    roll = ((now + beam.entity * 31 + segment * 67) % 360) * 1.0
    segmentPitch = pitch; segmentYaw = yaw
    if heatBeam then
      flags = rc.RF_FULLBRIGHT
      segmentPitch = -pitch; segmentYaw = yaw + 180.0
      roll = (now % 360) * 1.0
      if beam.playerLinked then frame = 1 else frame = 2 end if
    else if lightning then
      flags = rc.RF_FULLBRIGHT
      segmentPitch = -pitch; segmentYaw = yaw + 180.0
    end if
    segmentOrigin = qt.Vec3(origin.x + normalizedX * spacing * segment,
      origin.y + normalizedY * spacing * segment,
      origin.z + normalizedZ * spacing * segment)
    output[count] = rt.entity(model, qt.Vec3(segmentPitch, segmentYaw, roll),
      segmentOrigin, frame, cestate.copyVec(segmentOrigin), frame, 0.0,
      0, 0, 1.0, void, flags)
    count = count + 1; segment = segment + 1; remaining = remaining - modelLength
  end while
  return count
end function

function laserEntity(laser)
  return rt.entity(void, qt.zeroVec3(), cestate.copyVec(laser.start), 4,
    cestate.copyVec(laser.finish), 0, 0.0, laser.color, 0, 0.3, void,
    rc.RF_TRANSLUCENT | rc.RF_BEAM)
end function

function explosionFrame(explosion, now)
  return qbio.truncInt((now - explosion.startTime) / 100.0)
end function

function explosionAlpha(explosion, now)
  if typeof(explosion.kind) != "int" then return explosion.alpha end if
  fraction = (now - explosion.startTime) / 100.0
  frame = qbio.truncInt(fraction)
  misc = explosion.kind == ceconstants.TE_BLASTER or
    explosion.kind == ceconstants.TE_BLASTER2 or
    explosion.kind == ceconstants.TE_FLECHETTE or explosion.kind == "misc"
  alpha = (16.0 - frame) / 16.0
  if misc then alpha = 1.0 - fraction / (explosion.frames - 1) end if
  if alpha < 0.0 then alpha = 0.0 end if
  if alpha > 1.0 then alpha = 1.0 end if
  return alpha
end function

function explosionEntity(explosion, now, modelResolver)
  fraction = (now - explosion.startTime) / 100.0
  frame = qbio.truncInt(fraction)
  if frame < 0 then frame = 0 end if
  flags = explosion.flags; skinNum = explosion.skinNum
  if typeof(explosion.kind) == "int" and frame >= 10 then
    flags = flags | rc.RF_TRANSLUCENT
    if frame < 13 then skinNum = 5 else skinNum = 6 end if
  else if typeof(explosion.kind) == "int" and frame < 10 and
      explosion.kind != ceconstants.TE_BLASTER and
      explosion.kind != ceconstants.TE_BLASTER2 and
      explosion.kind != ceconstants.TE_FLECHETTE then
    skinNum = frame >> 1
  end if
  interpolation = fraction - frame
  if interpolation < 0.0 then interpolation = 0.0 end if
  if interpolation > 1.0 then interpolation = 1.0 end if
  return rt.entity(modelResolver(explosion.modelName), cestate.copyVec(explosion.angles),
    cestate.copyVec(explosion.origin), explosion.baseFrame + frame + 1, cestate.copyVec(explosion.origin),
    explosion.baseFrame + frame, 1.0 - interpolation, skinNum, 0,
    explosionAlpha(explosion, now), void, flags)
end function

// Product rendering calls entity.emit first, which already advances the shared
// effect state. Keep that prepared path separate so one frame never scans and
// compacts every effect collection twice at the same timestamp.
function applyPrepared(state, refDef, now, modelResolver)
  // A cable/lightning effect is a chain of 30-35 unit MD2 segments in the
  // original client. Reserve the renderer ceiling once and fill it in-place.
  effectEntities = []
  if len(state.beams) > 0 or len(state.lasers) > 0 or
      len(state.explosions) > 0 then
    effectEntities = array(rc.MAX_ENTITIES)
  end if
  effectEntityCount = 0
  for each beam in state.beams
    effectEntityCount = appendBeamEntities(effectEntities, effectEntityCount,
      rc.MAX_ENTITIES, beam, now, modelResolver, refDef)
  end for
  for each laser in state.lasers
    if effectEntityCount < rc.MAX_ENTITIES then
      effectEntities[effectEntityCount] = laserEntity(laser)
      effectEntityCount = effectEntityCount + 1
    end if
  end for
  for each explosion in state.explosions
    if effectEntityCount < rc.MAX_ENTITIES then
      effectEntities[effectEntityCount] = explosionEntity(explosion, now, modelResolver)
      effectEntityCount = effectEntityCount + 1
    end if
  end for
  effectEntities = trim(effectEntities, effectEntityCount)
  effectLights = rendererDLights(state)
  extraLightCount = 0
  for each countedExplosion in state.explosions
    if countedExplosion.light > 0.0 then extraLightCount = extraLightCount + 1 end if
  end for
  combinedLights = effectLights
  if extraLightCount > 0 then
    combinedLights = array(len(effectLights) + extraLightCount)
  end if
  effectLightCount = 0
  for each existingLight in effectLights
    combinedLights[effectLightCount] = existingLight
    effectLightCount = effectLightCount + 1
  end for
  for each explosion in state.explosions
    if explosion.light > 0.0 then
      combinedLights[effectLightCount] = rt.dLight(cestate.copyVec(explosion.origin),
        qt.Vec3(explosion.lightColor[0], explosion.lightColor[1], explosion.lightColor[2]),
        explosion.light * explosionAlpha(explosion, now))
      effectLightCount = effectLightCount + 1
    end if
  end for
  effectLights = trim(combinedLights, effectLightCount)
  refDef.entities = appendLimited(refDef.entities, effectEntities, rc.MAX_ENTITIES)
  refDef.dLights = appendLimited(refDef.dLights, effectLights, rc.MAX_DLIGHTS)
  refDef.particles = appendLimited(refDef.particles, rendererParticles(state, now), rc.MAX_PARTICLES)
  refDef.numEntities = len(refDef.entities)
  refDef.numDLights = len(refDef.dLights)
  refDef.numParticles = len(refDef.particles)
  return refDef
end function

function apply(state, refDef, now, modelResolver)
  cestate.advance(state, now)
  return applyPrepared(state, refDef, now, modelResolver)
end function
