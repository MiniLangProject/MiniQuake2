/* Client snapshot history, interpolation and renderer handoff. */
package miniquake2.client.state

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
end struct

function create()
  zero = cqt.zeroVec3()
  return ClientRuntime("disconnected", array(qc.UPDATE_BACKUP, void), void, void, zero, zero, -1, 0)
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

function clampFraction(value)
  if value < 0.0 then return 0.0 end if
  if value > 1.0 then return 1.0 end if
  return value
end function

function lerp(first, second, fraction)
  return first + (second - first) * fraction
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
    lerp(oldState.angles[0], currentState.angles[0], fraction),
    lerp(oldState.angles[1], currentState.angles[1], fraction),
    lerp(oldState.angles[2], currentState.angles[2], fraction),
  )
end function

function appendModelEntity(output, state, oldState, modelIndex, fraction, modelResolver)
  if modelIndex <= 0 then return output end if
  model = modelResolver(modelIndex)
  origin = interpolatedOrigin(oldState, state, fraction)
  angles = interpolatedAngles(oldState, state, fraction)
  oldOrigin = cqt.vec3(state.oldOrigin[0], state.oldOrigin[1], state.oldOrigin[2])
  oldFrame = state.frame
  if oldState is not void then oldFrame = oldState.frame end if
  alpha = 1.0
  if (state.renderFx & crc.RF_TRANSLUCENT) != 0 then alpha = 0.70 end if
  return output + [crt.entity(model, angles, origin, state.frame, oldOrigin, oldFrame, 1.0 - fraction, state.skinNum, 0, alpha, void, state.renderFx)]
end function

function buildEntities(client, fraction, modelResolver)
  if client.current is void then return [] end if
  fraction = clampFraction(fraction)
  oldEntities = []
  if client.previous is not void then oldEntities = client.previous.entities end if
  output = []
  index = 0
  while index < len(client.current.entities)
    state = client.current.entities[index]
    oldState = findEntity(oldEntities, state.number)
    output = appendModelEntity(output, state, oldState, state.modelIndex, fraction, modelResolver)
    output = appendModelEntity(output, state, oldState, state.modelIndex2, fraction, modelResolver)
    output = appendModelEntity(output, state, oldState, state.modelIndex3, fraction, modelResolver)
    output = appendModelEntity(output, state, oldState, state.modelIndex4, fraction, modelResolver)
    index = index + 1
  end while
  return output
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
  player = client.current.playerState
  viewOrigin = cqt.vec3(
    player.pmove.origin[0] * 0.125 + player.viewOffset[0],
    player.pmove.origin[1] * 0.125 + player.viewOffset[1],
    player.pmove.origin[2] * 0.125 + player.viewOffset[2],
  )
  viewAngles = cqt.vec3(player.viewAngles[0], player.viewAngles[1], player.viewAngles[2])
  fov = player.fov
  if fov <= 0.0 then fov = 90.0 end if
  fovY = 73.7398
  blend = [player.blend[0], player.blend[1], player.blend[2], player.blend[3]]
  return crt.refDef(0, 0, width, height, fov, fovY, viewOrigin, viewAngles, blend, client.serverTime * 0.001, player.rdFlags, void, crt.defaultLightStyles(), buildEntities(client, fraction, modelResolver), [], [])
end function
