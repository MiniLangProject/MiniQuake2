//! Provides miniquake2 client effects types facilities for this project.

/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Owned deterministic state for transient client effects. */
package miniquake2.client.effects.types

/// Store d light data.
struct DLight
  /// Stores the key value associated with dlight.
  key
  /// Stores the origin value associated with dlight.
  origin
  /// Stores the color value associated with dlight.
  color
  /// Stores the radius value associated with dlight.
  radius
  /// Stores the die value associated with dlight.
  die
  /// Stores the decay value associated with dlight.
  decay
  /// Stores the min light value associated with dlight.
  minLight
end struct

/// Store particle data.
struct Particle
  /// Stores the origin value associated with particle.
  origin
  /// Stores the velocity value associated with particle.
  velocity
  /// Stores the acceleration value associated with particle.
  acceleration
  /// Stores the color value associated with particle.
  color
  /// Stores the alpha value associated with particle.
  alpha
  /// Stores the alpha velocity value associated with particle.
  alphaVelocity
  /// Stores the start time value associated with particle.
  startTime
end struct

/// Store beam data.
struct Beam
  /// Stores the entity value associated with beam.
  entity
  /// Stores the destination entity value associated with beam.
  destinationEntity
  /// Stores the model name value associated with beam.
  modelName
  /// Stores the end time value associated with beam.
  endTime
  /// Stores the offset value associated with beam.
  offset
  /// Stores the start value associated with beam.
  start
  /// Stores the finish value associated with beam.
  finish
  /// Stores the player linked value associated with beam.
  playerLinked
end struct

/// Store laser data.
struct Laser
  /// Stores the start value associated with laser.
  start
  /// Stores the finish value associated with laser.
  finish
  /// Stores the color value associated with laser.
  color
  /// Stores the end time value associated with laser.
  endTime
end struct

/// Store explosion data.
struct Explosion
  /// Stores the kind value associated with explosion.
  kind
  /// Stores the origin value associated with explosion.
  origin
  /// Stores the angles value associated with explosion.
  angles
  /// Stores the model name value associated with explosion.
  modelName
  /// Stores the frames value associated with explosion.
  frames
  /// Stores the light value associated with explosion.
  light
  /// Stores the light color value associated with explosion.
  lightColor
  /// Stores the start time value associated with explosion.
  startTime
  /// Stores the base frame value associated with explosion.
  baseFrame
  /// Stores the flags value associated with explosion.
  flags
  /// Stores the alpha value associated with explosion.
  alpha
  /// Stores the skin num value associated with explosion.
  skinNum
end struct

/// Store sustain data.
struct Sustain
  /// Stores the id value associated with sustain.
  id
  /// Stores the kind value associated with sustain.
  kind
  /// Stores the origin value associated with sustain.
  origin
  /// Stores the direction value associated with sustain.
  direction
  /// Stores the color value associated with sustain.
  color
  /// Stores the count value associated with sustain.
  count
  /// Stores the magnitude value associated with sustain.
  magnitude
  /// Stores the end time value associated with sustain.
  endTime
  /// Stores the next think value associated with sustain.
  nextThink
  /// Stores the think interval value associated with sustain.
  thinkInterval
end struct

/// Store sound event data.
struct SoundEvent
  /// Stores the position value associated with sound event.
  position
  /// Stores the entity value associated with sound event.
  entity
  /// Stores the channel value associated with sound event.
  channel
  /// Stores the sound index value associated with sound event.
  soundIndex
  /// Stores the sound name value associated with sound event.
  soundName
  /// Stores the volume value associated with sound event.
  volume
  /// Stores the attenuation value associated with sound event.
  attenuation
  /// Stores the time offset value associated with sound event.
  timeOffset
end struct

/// Store audio callbacks data.
struct AudioCallbacks
  /// Stores the resolve index value associated with audio callbacks.
  resolveIndex
  /// Stores the resolve name value associated with audio callbacks.
  resolveName
  /// Stores the play value associated with audio callbacks.
  play
end struct

/// Store entity trail data.
struct EntityTrail
  /// Stores the origin value associated with entity trail.
  origin
  /// Stores the trail count value associated with entity trail.
  trailCount
  /// Stores the server frame value associated with entity trail.
  serverFrame
  /// Stores the fly stop time value associated with entity trail.
  flyStopTime
end struct

/// Store state data.
struct State
  /// Stores the time value associated with state.
  time
  /// Stores the random seed value associated with state.
  randomSeed
  /// Stores the d lights value associated with state.
  dLights
  /// Stores the particles value associated with state.
  particles
  /// Stores the particle count value associated with state.
  particleCount
  /// Stores the beams value associated with state.
  beams
  /// Stores the player beams value associated with state.
  playerBeams
  /// Stores the lasers value associated with state.
  lasers
  /// Stores the explosions value associated with state.
  explosions
  /// Stores the sustains value associated with state.
  sustains
  /// Stores the sound events value associated with state.
  soundEvents
  /// Stores the angular velocities value associated with state.
  angularVelocities
  /// Stores the entity trails value associated with state.
  entityTrails
  /// Stores the render particles value associated with state.
  renderParticles
  /// Stores the render dlights value associated with state.
  renderDLights
  /// Stores the entity light scratch value associated with state.
  entityLightScratch
  /// Stores the entity light output value associated with state.
  entityLightOutput
  /// Stores the audio value associated with state.
  audio
end struct
