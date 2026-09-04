//! Provides miniquake2 client runtime handoff facilities for this project.

/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Atomic renderer/audio/UI-ready snapshot handoff without renderer coupling. */
package miniquake2.client.runtime.handoff

import miniquake2.qcommon.types as qt
import miniquake2.protocol.types as pt
import miniquake2.client.effects.types as cetypes
import miniquake2.client.runtime.types as crtypes

/// Defines the max frame handoffs constant used by the miniquake2 client runtime handoff module.
const MAX_FRAME_HANDOFFS = 8

/// Copy vec data.
/// @param value Value consumed or transformed by the operation.
function copyVec(value)
  if value is void then return void end if
  return qt.Vec3(value.x, value.y, value.z)
end function

/// Copy values data.
/// @param values values value consumed by this operation.
function copyValues(values)
  output = array(len(values))
  index = 0
  while index < len(values)
    output[index] = values[index]
    index = index + 1
  end while
  return output
end function

/// Copy snapshot data.
/// @param value Value consumed or transformed by the operation.
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

/// Copy lights data.
/// @param values values value consumed by this operation.
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

/// Copy particles data.
/// @param values values value consumed by this operation.
/// @param count Number of items or units to process.
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

/// Copy beams data.
/// @param values values value consumed by this operation.
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

/// Copy lasers data.
/// @param values values value consumed by this operation.
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

/// Copy explosions data.
/// @param values values value consumed by this operation.
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

/// Copy sustains data.
/// @param values values value consumed by this operation.
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

/// Copy sounds data.
/// @param values values value consumed by this operation.
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

/// Copy prints data.
/// @param values values value consumed by this operation.
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

/// Copy centers data.
/// @param values values value consumed by this operation.
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

/// Copy layouts data.
/// @param values values value consumed by this operation.
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

/// Copy inventories data.
/// @param values values value consumed by this operation.
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

/// Append bounded.
/// @param values values value consumed by this operation.
/// @param value Value consumed or transformed by the operation.
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

/// Append two small transient event collections. Persistent render state is
/// read directly from the latest immutable client snapshot; only one-shot UI
/// and audio events need ordered aggregation when several packets arrive in a
/// single product pump.
/// @param first first value consumed by this operation.
/// @param second second value consumed by this operation.
function appendEvents(first, second)
  if len(first) == 0 then return second end if
  if len(second) == 0 then return first end if
  output = array(len(first) + len(second))
  index = 0
  while index < len(first)
    output[index] = first[index]
    index = index + 1
  end while
  secondIndex = 0
  while secondIndex < len(second)
    output[index + secondIndex] = second[secondIndex]
    secondIndex = secondIndex + 1
  end while
  return output
end function

/// Commit state.
/// @param runtime runtime value consumed by this operation.
/// @param now now value consumed by this operation.
function commit(runtime, now)
  if typeof(now) != "int" then return error(8380, "frame handoff time must be integer milliseconds") end if
  current = runtime.client.current
  if current is void or current.number <= runtime.committedServerFrame then return void end if

  // Snapshots are immutable after publication and config strings are a
  // same-thread read-only view. Transfer transient queues instead of deep
  // copying the complete renderer/effect state every 10-Hz server frame.
  value = crtypes.FrameHandoff(runtime.handoffSerial, current.number,
    runtime.client.serverTime, now, void, void, void, void, void, void, void,
    void, void, void, void, void, void, void)
  value.snapshot = current
  value.previousSnapshot = runtime.client.previous
  value.configStrings = runtime.network.configStrings
  // Persistent collections are shallow same-thread views. The latest consumer
  // uses them before the next simulation advance; no per-element copy is
  // required, while legacy diagnostics can still inspect the committed FX.
  value.dLights = runtime.effects.dLights; value.particles = []
  value.beams = runtime.effects.beams; value.lasers = runtime.effects.lasers
  value.explosions = runtime.effects.explosions
  value.sustains = runtime.effects.sustains
  value.sounds = runtime.effects.soundEvents
  value.prints = runtime.prints
  value.centerPrints = runtime.centerPrints
  value.layouts = runtime.layouts
  value.inventories = runtime.inventories

  runtime.effects.soundEvents = []
  runtime.prints = []
  runtime.centerPrints = []
  runtime.layouts = []
  runtime.inventories = []
  runtime.committedServerFrame = current.number
  runtime.handoffSerial = runtime.handoffSerial + 1
  // Coalesce queued snapshots immediately: only the newest persistent state is
  // meaningful, while every one-shot event remains ordered and owned.
  if len(runtime.frameHandoffs) > 0 then
    sounds = []; prints = []; centers = []; layouts = []; inventories = []
    for each queuedValue in runtime.frameHandoffs
      sounds = appendEvents(sounds, queuedValue.sounds)
      prints = appendEvents(prints, queuedValue.prints)
      centers = appendEvents(centers, queuedValue.centerPrints)
      layouts = appendEvents(layouts, queuedValue.layouts)
      inventories = appendEvents(inventories, queuedValue.inventories)
    end for
    value.sounds = appendEvents(sounds, value.sounds)
    value.prints = appendEvents(prints, value.prints)
    value.centerPrints = appendEvents(centers, value.centerPrints)
    value.layouts = appendEvents(layouts, value.layouts)
    value.inventories = appendEvents(inventories, value.inventories)
  end if
  runtime.frameHandoffs = [value]
  return value
end function

/// Consume state.
/// @param runtime runtime value consumed by this operation.
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

/// Consume latest.
/// @param runtime runtime value consumed by this operation.
function takeLatest(runtime)
  if len(runtime.frameHandoffs) == 0 then return void end if
  value = runtime.frameHandoffs[len(runtime.frameHandoffs) - 1]
  if len(runtime.frameHandoffs) > 1 then
    sounds = []; prints = []; centers = []; layouts = []; inventories = []
    for each pendingValue in runtime.frameHandoffs
      sounds = appendEvents(sounds, pendingValue.sounds)
      prints = appendEvents(prints, pendingValue.prints)
      centers = appendEvents(centers, pendingValue.centerPrints)
      layouts = appendEvents(layouts, pendingValue.layouts)
      inventories = appendEvents(inventories, pendingValue.inventories)
    end for
    value.sounds = sounds; value.prints = prints
    value.centerPrints = centers; value.layouts = layouts
    value.inventories = inventories
  end if
  runtime.frameHandoffs = []
  return value
end function

/// Report whether pending.
/// @param runtime runtime value consumed by this operation.
function pending(runtime)
  return len(runtime.frameHandoffs)
end function
