/* Append live effects to renderer.types.RefDef without proprietary assets. */
package miniquake2.client.effects.handoff

import miniquake2.qcommon.types as qt
import miniquake2.qcommon.byteio as qbio
import miniquake2.renderer.constants as rc
import miniquake2.renderer.types as rt
import miniquake2.client.effects.state as cestate

function appendLimited(values, additions, maximum)
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
  if count <= 0 then return [] end if
  if count == len(values) then return values end if
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
  output = array(len(state.particles))
  outputIndex = 0
  for each particle in state.particles
    elapsed = (now - particle.startTime) * 0.001
    alpha = particle.alpha + elapsed * particle.alphaVelocity
    if alpha > 1.0 then alpha = 1.0 end if
    if alpha > 0.0 then
      output[outputIndex] = rt.particle(particleOrigin(particle, now),
        particle.color & 255, alpha)
      outputIndex = outputIndex + 1
    end if
  end for
  return trim(output, outputIndex)
end function

function rendererDLights(state)
  output = array(len(state.dLights))
  outputIndex = 0
  for each light in state.dLights
    color = qt.Vec3(light.color[0], light.color[1], light.color[2])
    output[outputIndex] = rt.dLight(cestate.copyVec(light.origin), color, light.radius)
    outputIndex = outputIndex + 1
  end for
  return trim(output, outputIndex)
end function

function beamEntity(beam, modelResolver)
  model = modelResolver(beam.modelName)
  origin = cestate.add(beam.start, beam.offset)
  return rt.entity(model, qt.zeroVec3(), origin, 4, cestate.copyVec(beam.finish), 0,
    0.0, 0, 0, 0.3, void, rc.RF_TRANSLUCENT | rc.RF_BEAM)
end function

function laserEntity(laser)
  return rt.entity(void, qt.zeroVec3(), cestate.copyVec(laser.start), 4,
    cestate.copyVec(laser.finish), 0, 0.0, laser.color, 0, 0.3, void,
    rc.RF_TRANSLUCENT | rc.RF_BEAM)
end function

function explosionEntity(explosion, now, modelResolver)
  frame = qbio.truncInt((now - explosion.startTime) / 100)
  if frame < 0 then frame = 0 end if
  return rt.entity(modelResolver(explosion.modelName), cestate.copyVec(explosion.angles),
    cestate.copyVec(explosion.origin), explosion.baseFrame + frame, cestate.copyVec(explosion.origin),
    explosion.baseFrame + frame - 1, 0.0, 0, 0, explosion.alpha, void, explosion.flags)
end function

function apply(state, refDef, now, modelResolver)
  cestate.advance(state, now)
  effectEntities = array(len(state.beams) + len(state.lasers) + len(state.explosions))
  effectEntityCount = 0
  for each beam in state.beams
    effectEntities[effectEntityCount] = beamEntity(beam, modelResolver)
    effectEntityCount = effectEntityCount + 1
  end for
  for each laser in state.lasers
    effectEntities[effectEntityCount] = laserEntity(laser)
    effectEntityCount = effectEntityCount + 1
  end for
  for each explosion in state.explosions
    effectEntities[effectEntityCount] = explosionEntity(explosion, now, modelResolver)
    effectEntityCount = effectEntityCount + 1
  end for
  effectEntities = trim(effectEntities, effectEntityCount)
  effectLights = rendererDLights(state)
  extraLightCount = 0
  for each countedExplosion in state.explosions
    if countedExplosion.light > 0.0 then extraLightCount = extraLightCount + 1 end if
  end for
  combinedLights = array(len(effectLights) + extraLightCount)
  effectLightCount = 0
  for each existingLight in effectLights
    combinedLights[effectLightCount] = existingLight
    effectLightCount = effectLightCount + 1
  end for
  for each explosion in state.explosions
    if explosion.light > 0.0 then
      combinedLights[effectLightCount] = rt.dLight(cestate.copyVec(explosion.origin),
        qt.Vec3(explosion.lightColor[0], explosion.lightColor[1], explosion.lightColor[2]),
        explosion.light)
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
