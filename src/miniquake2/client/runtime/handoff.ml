/* Atomic renderer/audio/UI-ready snapshot handoff without renderer coupling. */
package miniquake2.client.runtime.handoff

import miniquake2.qcommon.types as qt
import miniquake2.protocol.types as pt
import miniquake2.client.effects.types as cetypes
import miniquake2.client.runtime.types as crtypes

const MAX_FRAME_HANDOFFS = 8

function copyVec(value)
  if value is void then return void end if
  return qt.Vec3(value.x, value.y, value.z)
end function

function copyValues(values)
  output = array(len(values))
  index = 0
  while index < len(values)
    output[index] = values[index]
    index = index + 1
  end while
  return output
end function

function copySnapshot(value)
  if value is void then return void end if
  output = crtypes.Snapshot(value.number, value.deltaNumber, value.suppressCount,
    void, void, void)
  output.areaBits = bytes(value.areaBits)
  output.playerState = pt.copyPlayerState(value.playerState)
  entities = array(len(value.entities))
  index = 0
  while index < len(value.entities)
    entities[index] = pt.copyEntityState(value.entities[index])
    index = index + 1
  end while
  output.entities = entities
  return output
end function

function copyLights(values)
  output = array(len(values))
  index = 0
  while index < len(values)
    value = values[index]
    copied = cetypes.DLight(value.key, void, void, value.radius, value.die, value.decay, value.minLight)
    copied.origin = copyVec(value.origin)
    copied.color = copyValues(value.color)
    output[index] = copied
    index = index + 1
  end while
  return output
end function

function copyParticles(values, count)
  output = array(count)
  index = 0
  while index < count
    value = values[index]
    copied = cetypes.Particle(void, void, void, value.color, value.alpha, value.alphaVelocity, value.startTime)
    copied.origin = copyVec(value.origin)
    copied.velocity = copyVec(value.velocity)
    copied.acceleration = copyVec(value.acceleration)
    output[index] = copied
    index = index + 1
  end while
  return output
end function

function copyBeams(values)
  output = array(len(values))
  index = 0
  while index < len(values)
    value = values[index]
    copied = cetypes.Beam(value.entity, value.destinationEntity, value.modelName,
      value.endTime, void, void, void, value.playerLinked)
    copied.offset = copyVec(value.offset)
    copied.start = copyVec(value.start)
    copied.finish = copyVec(value.finish)
    output[index] = copied
    index = index + 1
  end while
  return output
end function

function copyLasers(values)
  output = array(len(values))
  index = 0
  while index < len(values)
    value = values[index]
    copied = cetypes.Laser(void, void, value.color, value.endTime)
    copied.start = copyVec(value.start)
    copied.finish = copyVec(value.finish)
    output[index] = copied
    index = index + 1
  end while
  return output
end function

function copyExplosions(values)
  output = array(len(values))
  index = 0
  while index < len(values)
    value = values[index]
    copied = cetypes.Explosion(value.kind, void, void, value.modelName, value.frames,
      value.light, void, value.startTime, value.baseFrame, value.flags, value.alpha,
      value.skinNum)
    copied.origin = copyVec(value.origin)
    copied.angles = copyVec(value.angles)
    copied.lightColor = copyValues(value.lightColor)
    output[index] = copied
    index = index + 1
  end while
  return output
end function

function copySustains(values)
  output = array(len(values))
  index = 0
  while index < len(values)
    value = values[index]
    copied = cetypes.Sustain(value.id, value.kind, void, void, value.color,
      value.count, value.magnitude, value.endTime, value.nextThink, value.thinkInterval)
    copied.origin = copyVec(value.origin)
    copied.direction = copyVec(value.direction)
    output[index] = copied
    index = index + 1
  end while
  return output
end function

function copySounds(values)
  output = array(len(values))
  index = 0
  while index < len(values)
    value = values[index]
    copied = cetypes.SoundEvent(void, value.entity, value.channel, value.soundIndex,
      value.soundName, value.volume, value.attenuation, value.timeOffset)
    copied.position = copyVec(value.position)
    output[index] = copied
    index = index + 1
  end while
  return output
end function

function copyPrints(values)
  output = array(len(values))
  index = 0
  while index < len(values)
    value = values[index]
    output[index] = crtypes.PrintHandoff(value.level, value.text, value.time, value.chat)
    index = index + 1
  end while
  return output
end function

function copyCenters(values)
  output = array(len(values))
  index = 0
  while index < len(values)
    value = values[index]
    output[index] = crtypes.CenterPrintHandoff(value.text, value.time)
    index = index + 1
  end while
  return output
end function

function copyLayouts(values)
  output = array(len(values))
  index = 0
  while index < len(values)
    value = values[index]
    output[index] = crtypes.LayoutHandoff(value.text, value.time)
    index = index + 1
  end while
  return output
end function

function copyInventories(values)
  output = array(len(values))
  index = 0
  while index < len(values)
    value = values[index]
    copied = crtypes.InventoryHandoff(void, value.time)
    copied.values = copyValues(value.values)
    output[index] = copied
    index = index + 1
  end while
  return output
end function

function appendBounded(values, value)
  start = 0
  if len(values) >= MAX_FRAME_HANDOFFS then start = len(values) - MAX_FRAME_HANDOFFS + 1 end if
  output = array(len(values) - start + 1)
  outputIndex = 0
  index = start
  while index < len(values)
    output[outputIndex] = values[index]
    outputIndex = outputIndex + 1
    index = index + 1
  end while
  output[outputIndex] = value
  return output
end function

function commit(runtime, now)
  if typeof(now) != "int" then return error(8380, "frame handoff time must be integer milliseconds") end if
  current = runtime.client.current
  if current is void or current.number <= runtime.committedServerFrame then return void end if

  // Construct every owned copy before draining transient queues. Callers can
  // therefore observe either the previous state or one complete new frame.
  value = crtypes.FrameHandoff(runtime.handoffSerial, current.number,
    runtime.client.serverTime, now, void, void, void, void, void, void, void,
    void, void, void, void, void, void, void)
  value.snapshot = copySnapshot(current)
  value.previousSnapshot = copySnapshot(runtime.client.previous)
  value.configStrings = copyValues(runtime.network.configStrings)
  value.dLights = copyLights(runtime.effects.dLights)
  value.particles = copyParticles(runtime.effects.particles, runtime.effects.particleCount)
  value.beams = copyBeams(runtime.effects.beams)
  value.lasers = copyLasers(runtime.effects.lasers)
  value.explosions = copyExplosions(runtime.effects.explosions)
  value.sustains = copySustains(runtime.effects.sustains)
  value.sounds = copySounds(runtime.effects.soundEvents)
  value.prints = copyPrints(runtime.prints)
  value.centerPrints = copyCenters(runtime.centerPrints)
  value.layouts = copyLayouts(runtime.layouts)
  value.inventories = copyInventories(runtime.inventories)

  runtime.effects.soundEvents = []
  runtime.prints = []
  runtime.centerPrints = []
  runtime.layouts = []
  runtime.inventories = []
  runtime.committedServerFrame = current.number
  runtime.handoffSerial = runtime.handoffSerial + 1
  runtime.frameHandoffs = appendBounded(runtime.frameHandoffs, value)
  return value
end function

function take(runtime)
  if len(runtime.frameHandoffs) == 0 then return void end if
  value = runtime.frameHandoffs[0]
  output = array(len(runtime.frameHandoffs) - 1)
  index = 1
  while index < len(runtime.frameHandoffs)
    output[index - 1] = runtime.frameHandoffs[index]
    index = index + 1
  end while
  runtime.frameHandoffs = output
  return value
end function

function takeLatest(runtime)
  if len(runtime.frameHandoffs) == 0 then return void end if
  value = runtime.frameHandoffs[len(runtime.frameHandoffs) - 1]
  runtime.frameHandoffs = []
  return value
end function

function pending(runtime)
  return len(runtime.frameHandoffs)
end function
