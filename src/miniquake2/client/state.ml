/* Client snapshot history, interpolation and renderer handoff. */
package miniquake2.client.state

import std.math as cstatemath
import miniquake2.native as cstatenative
import miniquake2.qcommon.constants as qc
import miniquake2.qcommon.types as cqt
import miniquake2.protocol.types as pt
import miniquake2.renderer.constants as crc
import miniquake2.renderer.types as crt

struct ClientRuntime
  state
  snapshots
  current
  previous
  predictedOrigin
  predictionError
  serverFrame
  serverTime
  lightStyles
end struct

function create()
  zero = cqt.zeroVec3()
  return ClientRuntime("disconnected", array(qc.UPDATE_BACKUP, void), void, void,
    zero, zero, -1, 0, crt.defaultLightStyles())
end function

function setConnectionState(client, state)
  if state != "disconnected" and state != "connecting" and state != "connected" and state != "active" then
    return error(7600, "invalid client connection state")
  end if
  client.state = state
end function

function acceptSnapshot(client, frame)
  if frame.number < 0 then return error(7601, "negative snapshot number") end if
  if client.current is not void and frame.number <= client.current.number then return false end if
  client.previous = client.current
  client.current = frame
  client.serverFrame = frame.number
  client.serverTime = frame.number * 100
  client.snapshots[frame.number & qc.UPDATE_MASK] = frame
  if client.state == "connected" then client.state = "active" end if
  return true
end function

function findEntity(entities, number)
  index = 0
  while index < len(entities)
    if entities[index].number == number then return entities[index] end if
    if entities[index].number > number then return void end if
    index = index + 1
  end while
  return void
end function

function inline clampFraction(value)
  if value < 0.0 then return 0.0 end if
  if value > 1.0 then return 1.0 end if
  return value
end function

function inline lerp(first, second, fraction)
  return first + (second - first) * fraction
end function

// Quake II angles wrap at 360 degrees. A scalar interpolation would spin the
// long way around when a snapshot crosses north (for example 359 -> 1).
function inline lerpAngle(first, second, fraction)
  delta = second - first
  if delta > 180.0 then delta = delta - 360.0 end if
  if delta < -180.0 then delta = delta + 360.0 end if
  return first + fraction * delta
end function

function interpolationPlayer(client)
  player = client.current.playerState
  if client.previous is void or client.previous.number != client.current.number - 1 then
    return player
  end if
  previous = client.previous.playerState
  if cstatemath.abs(previous.pmove.origin[0] - player.pmove.origin[0]) > 2048 or
      cstatemath.abs(previous.pmove.origin[1] - player.pmove.origin[1]) > 2048 or
      cstatemath.abs(previous.pmove.origin[2] - player.pmove.origin[2]) > 2048 then
    return player
  end if
  return previous
end function

function interpolatedOrigin(oldState, currentState, fraction)
  if oldState is void then
    return cqt.vec3(currentState.origin[0], currentState.origin[1], currentState.origin[2])
  end if
  return cqt.vec3(
    lerp(oldState.origin[0], currentState.origin[0], fraction),
    lerp(oldState.origin[1], currentState.origin[1], fraction),
    lerp(oldState.origin[2], currentState.origin[2], fraction),
  )
end function

function interpolatedAngles(oldState, currentState, fraction)
  if oldState is void then return cqt.vec3(currentState.angles[0], currentState.angles[1], currentState.angles[2]) end if
  return cqt.vec3(
    lerpAngle(oldState.angles[0], currentState.angles[0], fraction),
    lerpAngle(oldState.angles[1], currentState.angles[1], fraction),
    lerpAngle(oldState.angles[2], currentState.angles[2], fraction),
  )
end function

function inline stateModelCount(state)
  count = 0
  if state.modelIndex > 0 then count = count + 1 end if
  if state.modelIndex2 > 0 then count = count + 1 end if
  if state.modelIndex3 > 0 then count = count + 1 end if
  if state.modelIndex4 > 0 then count = count + 1 end if
  return count
end function

function appendModelEntity(output, outputIndex, state, oldState, modelIndex,
    fraction, modelResolver)
  if modelIndex <= 0 then return outputIndex end if
  model = modelResolver(modelIndex)
  origin = interpolatedOrigin(oldState, state, fraction)
  angles = interpolatedAngles(oldState, state, fraction)
  oldOrigin = cqt.vec3(state.oldOrigin[0], state.oldOrigin[1], state.oldOrigin[2])
  oldFrame = state.frame
  if oldState is not void then oldFrame = oldState.frame end if
  alpha = 1.0
  if (state.renderFx & crc.RF_TRANSLUCENT) != 0 then alpha = 0.70 end if
  output[outputIndex] = crt.entity(model, angles, origin, state.frame, oldOrigin,
    oldFrame, 1.0 - fraction, state.skinNum, 0, alpha, void, state.renderFx)
  return outputIndex + 1
end function

function appendViewWeapon(output, outputIndex, client, fraction, modelResolver,
    viewOrigin, viewAngles)
  player = client.current.playerState
  if player.gunIndex <= 0 or player.fov > 90.0 then return outputIndex end if
  model = modelResolver(player.gunIndex)
  if model is void then return outputIndex end if
  previousPlayer = interpolationPlayer(client)
  gunOrigin = cqt.vec3(
    viewOrigin.x + lerp(previousPlayer.gunOffset[0], player.gunOffset[0], fraction),
    viewOrigin.y + lerp(previousPlayer.gunOffset[1], player.gunOffset[1], fraction),
    viewOrigin.z + lerp(previousPlayer.gunOffset[2], player.gunOffset[2], fraction))
  gunAngles = cqt.vec3(
    viewAngles.x + lerpAngle(previousPlayer.gunAngles[0], player.gunAngles[0], fraction),
    viewAngles.y + lerpAngle(previousPlayer.gunAngles[1], player.gunAngles[1], fraction),
    viewAngles.z + lerpAngle(previousPlayer.gunAngles[2], player.gunAngles[2], fraction))
  oldGunFrame = previousPlayer.gunFrame
  if player.gunFrame == 0 then oldGunFrame = 0 end if
  output[outputIndex] = crt.entity(model, gunAngles, gunOrigin, player.gunFrame,
    gunOrigin, oldGunFrame, 1.0 - fraction, 0, 0, 1.0, void,
    crc.RF_MINLIGHT | crc.RF_DEPTHHACK | crc.RF_WEAPONMODEL)
  return outputIndex + 1
end function

function buildEntities(client, fraction, modelResolver, viewOrigin, viewAngles)
  if client.current is void then return [] end if
  fraction = clampFraction(fraction)
  oldEntities = []
  if client.previous is not void then oldEntities = client.previous.entities end if
  capacity = 0
  for each countedState in client.current.entities
    capacity = capacity + stateModelCount(countedState)
  end for
  if client.current.playerState.gunIndex > 0 then capacity = capacity + 1 end if
  if capacity == 0 then return [] end if
  output = array(capacity)
  outputIndex = 0
  index = 0
  while index < len(client.current.entities)
    state = client.current.entities[index]
    oldState = findEntity(oldEntities, state.number)
    outputIndex = appendModelEntity(output, outputIndex, state, oldState,
      state.modelIndex, fraction, modelResolver)
    outputIndex = appendModelEntity(output, outputIndex, state, oldState,
      state.modelIndex2, fraction, modelResolver)
    outputIndex = appendModelEntity(output, outputIndex, state, oldState,
      state.modelIndex3, fraction, modelResolver)
    outputIndex = appendModelEntity(output, outputIndex, state, oldState,
      state.modelIndex4, fraction, modelResolver)
    index = index + 1
  end while
  outputIndex = appendViewWeapon(output, outputIndex, client, fraction,
    modelResolver, viewOrigin, viewAngles)
  if outputIndex == len(output) then return output end if
  if outputIndex == 0 then return [] end if
  compact = array(outputIndex)
  compactIndex = 0
  while compactIndex < outputIndex
    compact[compactIndex] = output[compactIndex]
    compactIndex = compactIndex + 1
  end while
  return compact
end function

function updatePredictionError(client, predictedFixedOrigin)
  if client.current is void then return cqt.zeroVec3() end if
  server = client.current.playerState.pmove.origin
  client.predictedOrigin = cqt.vec3(predictedFixedOrigin[0] * 0.125, predictedFixedOrigin[1] * 0.125, predictedFixedOrigin[2] * 0.125)
  client.predictionError = cqt.vec3(
    (server[0] - predictedFixedOrigin[0]) * 0.125,
    (server[1] - predictedFixedOrigin[1]) * 0.125,
    (server[2] - predictedFixedOrigin[2]) * 0.125,
  )
  return client.predictionError
end function

function buildRefDef(client, fraction, width, height, modelResolver)
  if client.current is void then return error(7602, "cannot render without a snapshot") end if
  fraction = clampFraction(fraction)
  player = client.current.playerState
  previousPlayer = interpolationPlayer(client)
  viewOrigin = cqt.vec3(
    lerp(previousPlayer.pmove.origin[0] * 0.125 + previousPlayer.viewOffset[0],
      player.pmove.origin[0] * 0.125 + player.viewOffset[0], fraction),
    lerp(previousPlayer.pmove.origin[1] * 0.125 + previousPlayer.viewOffset[1],
      player.pmove.origin[1] * 0.125 + player.viewOffset[1], fraction),
    lerp(previousPlayer.pmove.origin[2] * 0.125 + previousPlayer.viewOffset[2],
      player.pmove.origin[2] * 0.125 + player.viewOffset[2], fraction),
  )
  viewAngles = cqt.vec3(
    lerpAngle(previousPlayer.viewAngles[0], player.viewAngles[0], fraction) +
      lerpAngle(previousPlayer.kickAngles[0], player.kickAngles[0], fraction),
    lerpAngle(previousPlayer.viewAngles[1], player.viewAngles[1], fraction) +
      lerpAngle(previousPlayer.kickAngles[1], player.kickAngles[1], fraction),
    lerpAngle(previousPlayer.viewAngles[2], player.viewAngles[2], fraction) +
      lerpAngle(previousPlayer.kickAngles[2], player.kickAngles[2], fraction))
  fov = lerp(previousPlayer.fov, player.fov, fraction)
  if fov <= 0.0 then fov = 90.0 end if
  halfFov = fov * 0.008726646259971648
  projectionDistance = width / (cstatenative.sin(halfFov) / cstatenative.cos(halfFov))
  fovY = cstatenative.atan2(height * 1.0, projectionDistance) * 114.59155902616465
  blend = [player.blend[0], player.blend[1], player.blend[2], player.blend[3]]
  return crt.refDef(0, 0, width, height, fov, fovY, viewOrigin, viewAngles,
    blend, client.serverTime * 0.001, player.rdFlags, void,
    client.lightStyles, buildEntities(client, fraction, modelResolver,
    viewOrigin, viewAngles), [], [])
end function
