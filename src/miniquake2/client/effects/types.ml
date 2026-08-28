/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Owned deterministic state for transient client effects. */
package miniquake2.client.effects.types

// Store d light data.
struct DLight
  key
  origin
  color
  radius
  die
  decay
  minLight
end struct

// Store particle data.
struct Particle
  origin
  velocity
  acceleration
  color
  alpha
  alphaVelocity
  startTime
end struct

// Store beam data.
struct Beam
  entity
  destinationEntity
  modelName
  endTime
  offset
  start
  finish
  playerLinked
end struct

// Store laser data.
struct Laser
  start
  finish
  color
  endTime
end struct

// Store explosion data.
struct Explosion
  kind
  origin
  angles
  modelName
  frames
  light
  lightColor
  startTime
  baseFrame
  flags
  alpha
  skinNum
end struct

// Store sustain data.
struct Sustain
  id
  kind
  origin
  direction
  color
  count
  magnitude
  endTime
  nextThink
  thinkInterval
end struct

// Store sound event data.
struct SoundEvent
  position
  entity
  channel
  soundIndex
  soundName
  volume
  attenuation
  timeOffset
end struct

// Store audio callbacks data.
struct AudioCallbacks
  resolveIndex
  resolveName
  play
end struct

// Store entity trail data.
struct EntityTrail
  origin
  trailCount
  serverFrame
  flyStopTime
end struct

// Store state data.
struct State
  time
  randomSeed
  dLights
  particles
  particleCount
  beams
  playerBeams
  lasers
  explosions
  sustains
  soundEvents
  angularVelocities
  entityTrails
  renderParticles
  renderDLights
  entityLightScratch
  entityLightOutput
  audio
end struct
