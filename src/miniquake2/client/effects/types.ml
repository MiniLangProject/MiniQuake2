/* Owned deterministic state for transient client effects. */
package miniquake2.client.effects.types

struct DLight
  key
  origin
  color
  radius
  die
  decay
  minLight
end struct

struct Particle
  origin
  velocity
  acceleration
  color
  alpha
  alphaVelocity
  startTime
end struct

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

struct Laser
  start
  finish
  color
  endTime
end struct

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

struct AudioCallbacks
  resolveIndex
  resolveName
  play
end struct

struct EntityTrail
  origin
  trailCount
  serverFrame
end struct

struct State
  time
  randomSeed
  dLights
  particles
  particleCount
  beams
  lasers
  explosions
  sustains
  soundEvents
  entityTrails
  audio
end struct
