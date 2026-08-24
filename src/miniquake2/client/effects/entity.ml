/* cl_ents.c automatic entity trails and per-frame projectile lights. */
package miniquake2.client.effects.entity

import std.math as eemath
import miniquake2.qcommon.types as qt
import miniquake2.renderer.constants as rc
import miniquake2.renderer.types as rt
import miniquake2.client.effects.constants as constants
import miniquake2.client.effects.types as types
import miniquake2.client.effects.state as statefx

function inline arrayOrigin(value)
  return qt.Vec3(value[0], value[1], value[2])
end function

function inline interpolatedOrigin(previous, current, fraction, reset)
  first = void
  if previous is not void and not reset then first = previous.origin
  else first = current.oldOrigin
  end if
  if current.event == constants.EV_OTHER_TELEPORT then first = current.origin end if
  return qt.Vec3(first[0] + fraction * (current.origin[0] - first[0]),
    first[1] + fraction * (current.origin[1] - first[1]),
    first[2] + fraction * (current.origin[2] - first[2]))
end function

function inline requiresReset(previous, current)
  if previous is void then return true end if
  if previous.modelIndex != current.modelIndex or
      previous.modelIndex2 != current.modelIndex2 or
      previous.modelIndex3 != current.modelIndex3 or
      previous.modelIndex4 != current.modelIndex4 then return true end if
  deltaX = current.origin[0] - previous.origin[0]
  deltaY = current.origin[1] - previous.origin[1]
  deltaZ = current.origin[2] - previous.origin[2]
  if deltaX < -512.0 or deltaX > 512.0 or deltaY < -512.0 or deltaY > 512.0 or
      deltaZ < -512.0 or deltaZ > 512.0 then return true end if
  return current.event == constants.EV_PLAYER_TELEPORT or
    current.event == constants.EV_OTHER_TELEPORT
end function

function appendLight(output, count, origin, intensity, red, green, blue)
  if count >= len(output) then return count end if
  output[count] = rt.dLight(statefx.copyVec(origin), qt.Vec3(red, green, blue), intensity)
  return count + 1
end function

function compactLights(values, count)
  if count == 0 then return [] end if
  if count == len(values) then return values end if
  output = array(count)
  index = 0
  while index < count
    output[index] = values[index]
    index = index + 1
  end while
  return output
end function

function emitLocalLight(lights, lightCount, effects, origin, now)
  if (effects & constants.EF_FLAG1) != 0 then
    return appendLight(lights, lightCount, origin, 225.0, 1.0, 0.1, 0.1)
  end if
  if (effects & constants.EF_FLAG2) != 0 then
    return appendLight(lights, lightCount, origin, 225.0, 0.1, 0.1, 1.0)
  end if
  if (effects & constants.EF_TAGTRAIL) != 0 then
    return appendLight(lights, lightCount, origin, 225.0, 1.0, 1.0, 0.0)
  end if
  if (effects & constants.EF_TRACKERTRAIL) != 0 then
    return appendLight(lights, lightCount, origin, 225.0, -1.0, -1.0, -1.0)
  end if
  return lightCount
end function

function emitSpinningLight(lights, lightCount, entity, origin, now)
  if (entity.effects & constants.EF_SPINNINGLIGHTS) == 0 then return lightCount end if
  yaw = now / 2.0 + entity.angles[1]
  yaw = yaw - eemath.floor(yaw / 360.0) * 360.0
  radians = yaw * 0.017453292519943295
  lightOrigin = qt.Vec3(origin.x + eemath.cos(radians) * 64.0,
    origin.y + eemath.sin(radians) * 64.0, origin.z)
  return appendLight(lights, lightCount, lightOrigin, 100.0, 1.0, 0.0, 0.0)
end function

function emitAutomatic(state, trail, entity, startPosition, endPosition, now,
    lights, lightCount)
  effects = entity.effects
  if (effects & constants.EF_ROCKET) != 0 then
    statefx.rocketTrail(state, startPosition, endPosition, trail)
    return appendLight(lights, lightCount, endPosition, 200.0, 1.0, 1.0, 0.0)
  end if
  if (effects & constants.EF_BLASTER) != 0 then
    green = (effects & constants.EF_TRACKER) != 0
    statefx.blasterTrail(state, startPosition, endPosition, green)
    if green then return appendLight(lights, lightCount, endPosition, 200.0, 0.0, 1.0, 0.0) end if
    return appendLight(lights, lightCount, endPosition, 200.0, 1.0, 1.0, 0.0)
  end if
  if (effects & constants.EF_HYPERBLASTER) != 0 then
    if (effects & constants.EF_TRACKER) != 0 then
      return appendLight(lights, lightCount, endPosition, 200.0, 0.0, 1.0, 0.0)
    end if
    return appendLight(lights, lightCount, endPosition, 200.0, 1.0, 1.0, 0.0)
  end if
  if (effects & constants.EF_GIB) != 0 then
    statefx.diminishingTrail(state, startPosition, endPosition, trail, effects)
    return lightCount
  end if
  if (effects & constants.EF_GRENADE) != 0 then
    statefx.diminishingTrail(state, startPosition, endPosition, trail, effects)
    return lightCount
  end if
  if (effects & constants.EF_FLIES) != 0 then
    statefx.flyEffect(state, trail, endPosition)
    return lightCount
  end if
  if (effects & constants.EF_BFG) != 0 then
    intensity = 300.0
    if entity.frame == 1 then intensity = 400.0 end if
    if entity.frame == 2 then intensity = 600.0 end if
    if entity.frame == 3 then intensity = 300.0 end if
    if entity.frame == 4 then intensity = 150.0 end if
    if entity.frame == 5 then intensity = 75.0 end if
    if (effects & constants.EF_ANIM_ALLFAST) != 0 then
      statefx.bfgParticles(state, endPosition)
      intensity = 200.0
    end if
    return appendLight(lights, lightCount, endPosition, intensity, 0.0, 1.0, 0.0)
  end if
  if (effects & constants.EF_TRAP) != 0 then
    trapOrigin = qt.Vec3(endPosition.x, endPosition.y, endPosition.z + 32.0)
    statefx.trapParticles(state, trapOrigin)
    intensity = 100.0 + (statefx.random(state) % 100)
    return appendLight(lights, lightCount, trapOrigin, intensity, 1.0, 0.8, 0.1)
  end if
  if (effects & constants.EF_FLAG1) != 0 then
    statefx.flagTrail(state, startPosition, endPosition, 242, false)
    return appendLight(lights, lightCount, endPosition, 225.0, 1.0, 0.1, 0.1)
  end if
  if (effects & constants.EF_FLAG2) != 0 then
    statefx.flagTrail(state, startPosition, endPosition, 115, false)
    return appendLight(lights, lightCount, endPosition, 225.0, 0.1, 0.1, 1.0)
  end if
  if (effects & constants.EF_TAGTRAIL) != 0 then
    statefx.flagTrail(state, startPosition, endPosition, 220, true)
    return appendLight(lights, lightCount, endPosition, 225.0, 1.0, 1.0, 0.0)
  end if
  if (effects & constants.EF_TRACKERTRAIL) != 0 then
    if (effects & constants.EF_TRACKER) != 0 then
      intensity = 50.0 + 500.0 * (eemath.sin(now / 500.0) + 1.0)
      return appendLight(lights, lightCount, endPosition, intensity, -1.0, -1.0, -1.0)
    end if
    statefx.instantShellParticles(state, startPosition, 0, 300, 40.0)
    return appendLight(lights, lightCount, endPosition, 155.0, -1.0, -1.0, -1.0)
  end if
  if (effects & constants.EF_TRACKER) != 0 then
    statefx.trackerTrail(state, startPosition, endPosition, 0)
    return appendLight(lights, lightCount, endPosition, 200.0, -1.0, -1.0, -1.0)
  end if
  if (effects & constants.EF_GREENGIB) != 0 then
    statefx.diminishingTrail(state, startPosition, endPosition, trail, effects)
    return lightCount
  end if
  if (effects & constants.EF_IONRIPPER) != 0 then
    statefx.ionRipperTrail(state, startPosition, endPosition)
    return appendLight(lights, lightCount, endPosition, 100.0, 1.0, 0.5, 0.5)
  end if
  if (effects & constants.EF_BLUEHYPERBLASTER) != 0 then
    return appendLight(lights, lightCount, endPosition, 200.0, 0.0, 0.0, 1.0)
  end if
  if (effects & constants.EF_PLASMA) != 0 then
    if (effects & constants.EF_ANIM_ALLFAST) != 0 then
      statefx.blasterTrail(state, startPosition, endPosition, false)
    end if
    return appendLight(lights, lightCount, endPosition, 130.0, 1.0, 0.5, 0.5)
  end if
  return lightCount
end function

function emit(state, currentSnapshot, previousSnapshot, fraction, now,
    localEntityNumber, refDef)
  if currentSnapshot is void or typeof(fraction) != "float" and typeof(fraction) != "int" then return 0 end if
  if fraction < 0.0 then fraction = 0.0 end if
  if fraction > 1.0 then fraction = 1.0 end if
  statefx.advance(state, now)
  lights = array(rc.MAX_DLIGHTS)
  lightCount = 0
  for each existingLight in refDef.dLights
    if lightCount < len(lights) then
      lights[lightCount] = existingLight; lightCount = lightCount + 1
    end if
  end for
  previousEntities = []
  if previousSnapshot is not void and
      previousSnapshot.number == currentSnapshot.number - 1 then
    previousEntities = previousSnapshot.entities
  end if
  emitted = 0
  previousIndex = 0
  for each entity in currentSnapshot.entities
    if entity.number > 0 and entity.number < constants.MAX_ENTITY_TRAILS then
      while previousIndex < len(previousEntities) and
          previousEntities[previousIndex].number < entity.number
        previousIndex = previousIndex + 1
      end while
      previous = void
      if previousIndex < len(previousEntities) and
          previousEntities[previousIndex].number == entity.number then
        previous = previousEntities[previousIndex]
      end if
      reset = requiresReset(previous, entity)
      trail = state.entityTrails[entity.number]
      if typeof(trail) != "struct" then
        initialOrigin = arrayOrigin(entity.oldOrigin)
        if entity.event == constants.EV_OTHER_TELEPORT then initialOrigin = arrayOrigin(entity.origin) end if
        trail = types.EntityTrail(initialOrigin, 1024, currentSnapshot.number, 0)
        state.entityTrails[entity.number] = trail
      else if trail.serverFrame != currentSnapshot.number then
        if trail.serverFrame != currentSnapshot.number - 1 or reset then
          trail.origin = arrayOrigin(entity.oldOrigin)
          if entity.event == constants.EV_OTHER_TELEPORT then trail.origin = arrayOrigin(entity.origin) end if
          trail.trailCount = 1024
        end if
        trail.serverFrame = currentSnapshot.number
      end if
      target = interpolatedOrigin(previous, entity, fraction, reset)
      effects = entity.effects
      lightCount = emitSpinningLight(lights, lightCount, entity, target, now)
      if entity.number == localEntityNumber then
        lightCount = emitLocalLight(lights, lightCount, effects, target, now)
      else if entity.modelIndex > 0 and (effects & ~constants.EF_ROTATE) != 0 then
        before = state.particleCount
        lightCount = emitAutomatic(state, trail, entity, trail.origin, target,
          now, lights, lightCount)
        emitted = emitted + state.particleCount - before
      end if
      trail.origin = target
    end if
  end for
  refDef.dLights = compactLights(lights, lightCount)
  refDef.numDLights = lightCount
  return emitted
end function
