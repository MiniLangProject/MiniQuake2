/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Client snapshot history, interpolation and renderer handoff. */
package miniquake2.client.state

import std.math as cstatemath
import miniquake2.native as cstatenative
import miniquake2.qcommon.constants as qc
import miniquake2.qcommon.types as cqt
import miniquake2.qcommon.text as cstatetext
import miniquake2.protocol.types as pt
import miniquake2.renderer.constants as crc
import miniquake2.renderer.types as crt
import miniquake2.client.effects.constants as cseconstants

// Store client runtime data.
struct ClientRuntime
  state
  snapshots
  current
  previous
  predictedOrigin
  predictedAngles
  predictionError
  predictionValid
  predictedStep
  predictedStepTime
  predictionRealTime
  predictionStepOriginZ
  predictionStepOriginValid
  serverFrame
  serverTime
  lightStyles
  lightStyleMaps
  lightStyleOffset
  entityLookup
  entityLookupEpochs
  entityLookupEpoch
  renderEntities
end struct

// Create state.
function create()
  return ClientRuntime("disconnected", array(qc.UPDATE_BACKUP, void), void, void,
    cqt.zeroVec3(), cqt.zeroVec3(), cqt.zeroVec3(), false,
    0.0, 0.0, 0.0, 0, false, -1, 0, crt.defaultLightStyles(),
    array(qc.MAX_LIGHTSTYLES, ""), -1, array(qc.MAX_EDICTS),
    array(qc.MAX_EDICTS, 0), 0, [])
end function

// CL_SetLightstyle decodes CS_LIGHTS strings lazily at their 10 Hz playback
// rate. Keeping the compact source string avoids a second 256 x MAX_QPATH
// float table and is cheaper than rebuilding every style on every render.
function setLightStyle(client, index, pattern)
  if typeof(index) != "int" or index < 0 or index >= qc.MAX_LIGHTSTYLES then
    return error(7604, "light style index outside table")
  end if
  if typeof(pattern) != "string" or len(bytes(pattern)) >= qc.MAX_QPATH then
    return error(7605, "light style pattern outside protocol path limit")
  end if
  client.lightStyleMaps[index] = pattern
  client.lightStyleOffset = -1
  return true
end function

// Run light styles.
function runLightStyles(client, renderTime)
  offset = cstatemath.floor(renderTime / 100.0)
  if offset == client.lightStyleOffset then return false end if
  client.lightStyleOffset = offset
  index = 0
  while index < qc.MAX_LIGHTSTYLES
    pattern = bytes(client.lightStyleMaps[index])
    value = 1.0
    if len(pattern) > 0 then
      patternIndex = 0
      if len(pattern) > 1 then patternIndex = offset % len(pattern) end if
      value = (pattern[patternIndex] - 97) / 12.0
    end if
    client.lightStyles[index] = crt.lightStyle(value, value, value)
    index = index + 1
  end while
  return true
end function

// Set connection state.
function setConnectionState(client, state)
  if state != "disconnected" and state != "connecting" and state != "connected" and state != "active" then
    return error(7600, "invalid client connection state")
  end if
  client.state = state
end function

// Accept snapshot.
function acceptSnapshot(client, frame)
  if frame.number < 0 then return error(7601, "negative snapshot number") end if
  if client.current is not void and frame.number <= client.current.number then return false end if
  client.previous = client.current
  client.current = frame
  client.serverFrame = frame.number
  client.serverTime = frame.number * 100
  client.snapshots[frame.number & qc.UPDATE_MASK] = frame
  // Sound spatialization and other per-frame consumers query entities by
  // protocol number. Publish the new snapshot into an epoch-indexed table so
  // up to 32 live sound channels do not each rescan the entity array.
  client.entityLookupEpoch = client.entityLookupEpoch + 1
  if client.entityLookupEpoch >= 0x7fffffff then
    client.entityLookupEpoch = 1
    clearIndex = 0
    while clearIndex < len(client.entityLookupEpochs)
      client.entityLookupEpochs[clearIndex] = 0
      clearIndex = clearIndex + 1
    end while
  end if
  for each indexedEntity in frame.entities
    if indexedEntity.number > 0 and indexedEntity.number < qc.MAX_EDICTS then
      client.entityLookup[indexedEntity.number] = indexedEntity
      client.entityLookupEpochs[indexedEntity.number] = client.entityLookupEpoch
    end if
  end for
  if client.state == "connected" then client.state = "active" end if
  return true
end function

// Return the current entity value.
function inline currentEntity(client, number)
  if number <= 0 or number >= qc.MAX_EDICTS or
      client.entityLookupEpochs[number] != client.entityLookupEpoch then
    return void
  end if
  return client.entityLookup[number]
end function

// Find entity.
function findEntity(entities, number)
  index = 0
  while index < len(entities)
    if entities[index].number == number then return entities[index] end if
    if entities[index].number > number then return void end if
    index = index + 1
  end while
  return void
end function

// Clamp fraction.
function inline clampFraction(value)
  if value < 0.0 then return 0.0 end if
  if value > 1.0 then return 1.0 end if
  return value
end function

// Return the lerp value.
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

// Return the interpolation player value.
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

// Return the interpolated origin.
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

// Return the interpolated angles.
function interpolatedAngles(oldState, currentState, fraction)
  if oldState is void then return cqt.vec3(currentState.angles[0], currentState.angles[1], currentState.angles[2]) end if
  return cqt.vec3(
    lerpAngle(oldState.angles[0], currentState.angles[0], fraction),
    lerpAngle(oldState.angles[1], currentState.angles[1], fraction),
    lerpAngle(oldState.angles[2], currentState.angles[2], fraction),
  )
end function

// CL_DeltaEntity deliberately breaks interpolation when an entity changes
// model, moves more than 512 units between server frames, or reports either
// teleport event.  Particle trails already observe this rule; the render
// handoff must use the same predecessor or models visibly sweep through the
// world after teleports and model replacements.
function inline entityRequiresLerpReset(oldState, state)
  if oldState is void then return true end if
  if oldState.modelIndex != state.modelIndex or
      oldState.modelIndex2 != state.modelIndex2 or
      oldState.modelIndex3 != state.modelIndex3 or
      oldState.modelIndex4 != state.modelIndex4 then return true end if
  deltaX = state.origin[0] - oldState.origin[0]
  deltaY = state.origin[1] - oldState.origin[1]
  deltaZ = state.origin[2] - oldState.origin[2]
  if deltaX < -512.0 or deltaX > 512.0 or
      deltaY < -512.0 or deltaY > 512.0 or
      deltaZ < -512.0 or deltaZ > 512.0 then return true end if
  return state.event == cseconstants.EV_PLAYER_TELEPORT or
    state.event == cseconstants.EV_OTHER_TELEPORT
end function

// Render entity origin.
function inline entityRenderOrigin(oldState, state, fraction, reset)
  if not reset then return interpolatedOrigin(oldState, state, fraction) end if
  first = state.oldOrigin
  if state.event == cseconstants.EV_OTHER_TELEPORT then first = state.origin end if
  return cqt.vec3(
    lerp(first[0], state.origin[0], fraction),
    lerp(first[1], state.origin[1], fraction),
    lerp(first[2], state.origin[2], fraction))
end function

// Render entity angles.
function inline entityRenderAngles(oldState, state, fraction, reset)
  if reset then return cqt.vec3(state.angles[0], state.angles[1], state.angles[2]) end if
  return interpolatedAngles(oldState, state, fraction)
end function

// Return the effective effects value.
function inline effectiveEffects(state)
  effects = state.effects
  if (effects & cseconstants.EF_PENT) != 0 then
    effects = (effects & ~cseconstants.EF_PENT) | cseconstants.EF_COLOR_SHELL
  end if
  if (effects & cseconstants.EF_QUAD) != 0 then
    effects = (effects & ~cseconstants.EF_QUAD) | cseconstants.EF_COLOR_SHELL
  end if
  if (effects & cseconstants.EF_DOUBLE) != 0 then
    effects = (effects & ~cseconstants.EF_DOUBLE) | cseconstants.EF_COLOR_SHELL
  end if
  if (effects & cseconstants.EF_HALF_DAMAGE) != 0 then
    effects = (effects & ~cseconstants.EF_HALF_DAMAGE) | cseconstants.EF_COLOR_SHELL
  end if
  return effects
end function

// Render effective fx.
function inline effectiveRenderFx(state)
  flags = state.renderFx
  if (state.effects & cseconstants.EF_PENT) != 0 then flags = flags | crc.RF_SHELL_RED end if
  if (state.effects & cseconstants.EF_QUAD) != 0 then flags = flags | crc.RF_SHELL_BLUE end if
  if (state.effects & cseconstants.EF_DOUBLE) != 0 then flags = flags | crc.RF_SHELL_DOUBLE end if
  if (state.effects & cseconstants.EF_HALF_DAMAGE) != 0 then flags = flags | crc.RF_SHELL_HALF_DAM end if
  return flags
end function

// Return the state model count.
function inline stateModelCount(state)
  count = 0
  if state.modelIndex > 0 then count = count + 1 end if
  if state.modelIndex2 > 0 then count = count + 1 end if
  if state.modelIndex3 > 0 then count = count + 1 end if
  if state.modelIndex4 > 0 then count = count + 1 end if
  effects = effectiveEffects(state)
  if state.modelIndex > 0 and (effects & cseconstants.EF_COLOR_SHELL) != 0 then
    count = count + 1
  end if
  if state.modelIndex > 0 and (effects & cseconstants.EF_POWERSCREEN) != 0 then
    count = count + 1
  end if
  return count
end function

// Return the animated frame value.
function inline animatedFrame(state, effects, renderTime)
  autoAnimation = cstatemath.floor(2.0 * renderTime / 1000.0)
  if (effects & cseconstants.EF_ANIM01) != 0 then return autoAnimation & 1 end if
  if (effects & cseconstants.EF_ANIM23) != 0 then return 2 + (autoAnimation & 1) end if
  if (effects & cseconstants.EF_ANIM_ALL) != 0 then return autoAnimation end if
  if (effects & cseconstants.EF_ANIM_ALLFAST) != 0 then
    return cstatemath.floor(renderTime / 100.0)
  end if
  return state.frame
end function

// Render angles.
function renderAngles(oldState, state, effects, fraction, renderTime, lerpReset)
  if (effects & cseconstants.EF_ROTATE) != 0 then
    yaw = renderTime / 10.0
    yaw = yaw - cstatemath.floor(yaw / 360.0) * 360.0
    return cqt.vec3(0.0, yaw, 0.0)
  end if
  if (effects & cseconstants.EF_SPINNINGLIGHTS) != 0 then
    yaw = renderTime / 2.0
    yaw = yaw - cstatemath.floor(yaw / 360.0) * 360.0
    return cqt.vec3(0.0, yaw + state.angles[1], 180.0)
  end if
  return entityRenderAngles(oldState, state, fraction, lerpReset)
end function

// Return the disguise family value.
function inline disguiseFamily(skin)
  if skin is void or typeof(skin) != "struct" or
      typeof(skin.name) != "string" then return "" end if
  name = cstatetext.lower(skin.name)
  if cstatetext.startsWith(name, "players/male") then return "male" end if
  if cstatetext.startsWith(name, "players/female") then return "female" end if
  if cstatetext.startsWith(name, "players/cyborg") then return "cyborg" end if
  return ""
end function

// Append model entity.
function appendModelEntity(output, outputIndex, state, oldState, modelIndex,
    part, fraction, renderTime, assetResolvers, randomResolver, lerpReset)
  // Keep append model entity phases explicit: validate inputs, update owned state, then publish the result.
  if modelIndex <= 0 then return outputIndex end if
  if outputIndex >= len(output) then return outputIndex end if
  effects = effectiveEffects(state)
  renderFx = effectiveRenderFx(state)
  resolvedIndex = modelIndex
  if part == 1 and modelIndex != 255 and (modelIndex & 0x80) != 0 then
    resolvedIndex = modelIndex & 0x7f
  end if
  playerIndex = state.skinNum & 0xff
  model = void; skin = void
  if part == 0 and modelIndex == 255 then
    model = assetResolvers.playerModel(playerIndex)
    skin = assetResolvers.playerSkin(playerIndex)
    if (renderFx & crc.RF_USE_DISGUISE) != 0 then
      family = disguiseFamily(skin)
      if family != "" then
        model = assetResolvers.modelName("players/" + family + "/tris.md2")
        skin = assetResolvers.skinName("players/" + family + "/disguise.pcx")
      end if
    end if
  else if part == 1 and modelIndex == 255 then
    model = assetResolvers.playerWeapon(playerIndex, state.skinNum >> 8)
  else
    model = assetResolvers.modelIndex(resolvedIndex)
  end if
  origin = entityRenderOrigin(oldState, state, fraction, lerpReset)
  oldOrigin = cqt.vec3(origin.x, origin.y, origin.z)
  if (renderFx & (crc.RF_FRAMELERP | crc.RF_BEAM)) != 0 then
    origin = cqt.vec3(state.origin[0], state.origin[1], state.origin[2])
    oldOrigin = cqt.vec3(state.oldOrigin[0], state.oldOrigin[1], state.oldOrigin[2])
  end if
  angles = renderAngles(oldState, state, effects, fraction, renderTime,
    lerpReset)
  oldFrame = state.frame
  if oldState is not void and not lerpReset then oldFrame = oldState.frame end if
  frame = animatedFrame(state, effects, renderTime)
  skinNum = 0
  flags = 0
  alpha = 1.0
  if part == 0 then
    if modelIndex != 255 then skinNum = state.skinNum end if
    flags = renderFx
    if (effects & cseconstants.EF_COLOR_SHELL) != 0 then flags = 0 end if
    if renderFx == crc.RF_TRANSLUCENT then alpha = 0.70 end if
    if (effects & cseconstants.EF_BFG) != 0 then
      flags = flags | crc.RF_TRANSLUCENT; alpha = 0.30
    end if
    if (effects & cseconstants.EF_PLASMA) != 0 then
      flags = flags | crc.RF_TRANSLUCENT; alpha = 0.60
    end if
    if (effects & cseconstants.EF_SPHERETRANS) != 0 then
      flags = flags | crc.RF_TRANSLUCENT; alpha = 0.30
      if (effects & cseconstants.EF_TRACKERTRAIL) != 0 then alpha = 0.60 end if
    end if
    if (renderFx & crc.RF_BEAM) != 0 then
      selectedByte = randomResolver() % 4
      skinNum = (state.skinNum >> (selectedByte * 8)) & 0xff
      model = void; skin = void; alpha = 0.30
    end if
  else if part == 1 and modelIndex != 255 and (modelIndex & 0x80) != 0 then
    flags = crc.RF_TRANSLUCENT; alpha = 0.32
  end if
  output[outputIndex] = crt.entity(model, angles, origin, frame, oldOrigin,
    oldFrame, 1.0 - fraction, skinNum, 0, alpha, skin, flags)
  return outputIndex + 1
end function

// Append color shell.
function appendColorShell(output, outputIndex, state, oldState, fraction,
    renderTime, assetResolvers, lerpReset)
  effects = effectiveEffects(state)
  if state.modelIndex <= 0 or (effects & cseconstants.EF_COLOR_SHELL) == 0 then
    return outputIndex
  end if
  if outputIndex >= len(output) then return outputIndex end if
  renderFx = effectiveRenderFx(state)
  model = assetResolvers.modelIndex(state.modelIndex); skin = void; skinNum = state.skinNum
  if state.modelIndex == 255 then
    skinNum = 0
    model = assetResolvers.playerModel(state.skinNum & 0xff)
    skin = assetResolvers.playerSkin(state.skinNum & 0xff)
    if (renderFx & crc.RF_USE_DISGUISE) != 0 then
      family = disguiseFamily(skin)
      if family != "" then
        model = assetResolvers.modelName("players/" + family + "/tris.md2")
        skin = assetResolvers.skinName("players/" + family + "/disguise.pcx")
      end if
    end if
  end if
  origin = entityRenderOrigin(oldState, state, fraction, lerpReset)
  oldOrigin = cqt.vec3(origin.x, origin.y, origin.z)
  if (renderFx & (crc.RF_FRAMELERP | crc.RF_BEAM)) != 0 then
    origin = cqt.vec3(state.origin[0], state.origin[1], state.origin[2])
    oldOrigin = cqt.vec3(state.oldOrigin[0], state.oldOrigin[1], state.oldOrigin[2])
  end if
  oldFrame = state.frame
  if oldState is not void and not lerpReset then oldFrame = oldState.frame end if
  output[outputIndex] = crt.entity(model,
    renderAngles(oldState, state, effects, fraction, renderTime, lerpReset), origin,
    animatedFrame(state, effects, renderTime), oldOrigin, oldFrame,
    1.0 - fraction, skinNum, 0, 0.30, skin,
    renderFx | crc.RF_TRANSLUCENT)
  return outputIndex + 1
end function

// Append power screen.
function appendPowerScreen(output, outputIndex, state, oldState, fraction,
    renderTime, assetResolvers, lerpReset)
  effects = effectiveEffects(state)
  if state.modelIndex <= 0 or (effects & cseconstants.EF_POWERSCREEN) == 0 then
    return outputIndex
  end if
  if outputIndex >= len(output) then return outputIndex end if
  model = assetResolvers.modelName("models/items/armor/effect/tris.md2")
  if model is void then return outputIndex end if
  origin = entityRenderOrigin(oldState, state, fraction, lerpReset)
  oldOrigin = cqt.vec3(origin.x, origin.y, origin.z)
  output[outputIndex] = crt.entity(model,
    renderAngles(oldState, state, effects, fraction, renderTime, lerpReset), origin,
    0, oldOrigin, 0, 1.0 - fraction, 0, 0, 0.30, void,
    crc.RF_TRANSLUCENT | crc.RF_SHELL_GREEN)
  return outputIndex + 1
end function

// Append view weapon.
function appendViewWeapon(output, outputIndex, client, fraction, assetResolvers,
    viewOrigin, viewAngles)
  player = client.current.playerState
  if player.gunIndex <= 0 or player.fov > 90.0 then return outputIndex end if
  if outputIndex >= len(output) then return outputIndex end if
  model = assetResolvers.modelIndex(player.gunIndex)
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

// Build entities.
function buildEntities(client, fraction, assetResolvers, localEntityNumber,
    randomResolver, viewOrigin, viewAngles)
  if client.current is void then return [] end if
  fraction = clampFraction(fraction)
  renderTime = client.serverTime - (1.0 - fraction) * 100.0
  oldEntities = []
  if client.previous is not void then oldEntities = client.previous.entities end if
  capacity = 0
  for each countedState in client.current.entities
    if countedState.number != localEntityNumber then
      capacity = capacity + stateModelCount(countedState)
    end if
  end for
  if client.current.playerState.gunIndex > 0 then capacity = capacity + 1 end if
  if capacity > crc.MAX_ENTITIES then capacity = crc.MAX_ENTITIES end if
  if capacity == 0 then return [] end if
  output = client.renderEntities
  if len(output) != capacity then
    output = array(capacity, void)
    client.renderEntities = output
  end if
  outputIndex = 0
  index = 0
  oldIndex = 0
  while index < len(client.current.entities)
    state = client.current.entities[index]
    // Protocol-34 packet entities are sorted by entity number. Merge the old
    // and current snapshots once instead of restarting a linear lookup for
    // every rendered entity (O(n) rather than O(n^2) in busy scenes).
    while oldIndex < len(oldEntities) and
        oldEntities[oldIndex].number < state.number
      oldIndex = oldIndex + 1
    end while
    oldState = void
    if oldIndex < len(oldEntities) and
        oldEntities[oldIndex].number == state.number then
      oldState = oldEntities[oldIndex]
    end if
    if state.number != localEntityNumber then
      lerpReset = entityRequiresLerpReset(oldState, state)
      outputIndex = appendModelEntity(output, outputIndex, state, oldState,
        state.modelIndex, 0, fraction, renderTime, assetResolvers,
        randomResolver, lerpReset)
      outputIndex = appendColorShell(output, outputIndex, state, oldState,
        fraction, renderTime, assetResolvers, lerpReset)
      outputIndex = appendModelEntity(output, outputIndex, state, oldState,
        state.modelIndex2, 1, fraction, renderTime, assetResolvers,
        randomResolver, lerpReset)
      outputIndex = appendModelEntity(output, outputIndex, state, oldState,
        state.modelIndex3, 2, fraction, renderTime, assetResolvers,
        randomResolver, lerpReset)
      outputIndex = appendModelEntity(output, outputIndex, state, oldState,
        state.modelIndex4, 3, fraction, renderTime, assetResolvers,
        randomResolver, lerpReset)
      outputIndex = appendPowerScreen(output, outputIndex, state, oldState,
        fraction, renderTime, assetResolvers, lerpReset)
    end if
    index = index + 1
  end while
  outputIndex = appendViewWeapon(output, outputIndex, client, fraction,
    assetResolvers, viewOrigin, viewAngles)
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

// Update prediction error.
function updatePredictionError(client, predictedFixedOrigin)
  if client.current is void then return cqt.zeroVec3() end if
  server = client.current.playerState.pmove.origin
  deltaX = server[0] - predictedFixedOrigin[0]
  deltaY = server[1] - predictedFixedOrigin[1]
  deltaZ = server[2] - predictedFixedOrigin[2]
  length = cstatemath.abs(deltaX) + cstatemath.abs(deltaY) + cstatemath.abs(deltaZ)
  // A discrepancy above 80 world units is a teleport, not a movement miss.
  if length > 640 then client.predictionError = cqt.zeroVec3()
  else client.predictionError = cqt.vec3(deltaX * 0.125, deltaY * 0.125, deltaZ * 0.125)
  end if
  return client.predictionError
end function

// Accept prediction.
function acceptPrediction(client, fixedOrigin, angles)
  if typeof(fixedOrigin) != "array" or len(fixedOrigin) != 3 then
    return error(7603, "prediction requires a fixed-point origin")
  end if
  client.predictedOrigin = cqt.vec3(fixedOrigin[0] * 0.125,
    fixedOrigin[1] * 0.125, fixedOrigin[2] * 0.125)
  if typeof(angles) == "array" then
    client.predictedAngles = cqt.vec3(angles[0], angles[1], angles[2])
  else
    client.predictedAngles = cqt.vec3(angles.x, angles.y, angles.z)
  end if
  client.predictionValid = true
  return true
end function

// Set prediction real time.
function setPredictionRealTime(client, now)
  if typeof(now) != "int" and typeof(now) != "float" then
    return error(7606, "prediction real time must be numeric")
  end if
  client.predictionRealTime = now * 1.0
  return true
end function

// CL_PredictMovement recognizes one ordinary stair riser in fixed-point
// Pmove coordinates (8..20 world units) and records a half-frame-adjusted
// start time. CL_CalcViewValues then removes that vertical discontinuity over
// the next 100 ms instead of snapping the camera upward.
function notePredictionStep(client, previousFixedOrigin, currentFixedOrigin,
    flags, frameMsec)
  if typeof(previousFixedOrigin) != "array" or len(previousFixedOrigin) != 3 or
      typeof(currentFixedOrigin) != "array" or len(currentFixedOrigin) != 3 then
    return error(7607, "prediction step requires fixed-point origins")
  end if
  step = currentFixedOrigin[2] - previousFixedOrigin[2]
  repeatedOrigin = client.predictionStepOriginValid and
    client.predictionStepOriginZ == currentFixedOrigin[2]
  client.predictionStepOriginZ = currentFixedOrigin[2]
  client.predictionStepOriginValid = true
  if step <= 63 or step >= 160 or (flags & qc.PMF_ON_GROUND) == 0 then
    return false
  end if
  // The product may replay the same unsent preview command more than once
  // between 10-Hz network ticks. Original Quake advanced its outgoing command
  // every render; suppress the duplicate endpoint so the 100-ms easing window
  // is not restarted continuously.
  if repeatedOrigin then return false end if
  client.predictedStep = step * 0.125
  client.predictedStepTime = client.predictionRealTime - frameMsec * 0.5
  return true
end function

// Clear prediction.
function clearPrediction(client)
  client.predictionValid = false
  client.predictionError = cqt.zeroVec3()
  client.predictedStep = 0.0
  client.predictedStepTime = 0.0
  client.predictionRealTime = 0.0
  client.predictionStepOriginZ = 0
  client.predictionStepOriginValid = false
  return true
end function

// Build ref def internal.
function buildRefDefInternal(client, fraction, width, height, assetResolvers,
    localEntityNumber, randomResolver, usePrediction, predictionOffset)
  if client.current is void then return error(7602, "cannot render without a snapshot") end if
  fraction = clampFraction(fraction)
  renderTime = client.serverTime - (1.0 - fraction) * 100.0
  runLightStyles(client, renderTime)
  player = client.current.playerState
  previousPlayer = interpolationPlayer(client)
  predictionAllowed = usePrediction and client.predictionValid and
    (player.pmove.flags & qc.PMF_NO_PREDICTION) == 0
  viewOrigin = cqt.zeroVec3()
  if predictionAllowed then
    backlerp = 1.0 - fraction
    viewOrigin = cqt.vec3(
      client.predictedOrigin.x + lerp(previousPlayer.viewOffset[0], player.viewOffset[0], fraction) - backlerp * client.predictionError.x,
      client.predictedOrigin.y + lerp(previousPlayer.viewOffset[1], player.viewOffset[1], fraction) - backlerp * client.predictionError.y,
      client.predictedOrigin.z + lerp(previousPlayer.viewOffset[2], player.viewOffset[2], fraction) - backlerp * client.predictionError.z)
  else
    viewOrigin = cqt.vec3(
      lerp(previousPlayer.pmove.origin[0] * 0.125 + previousPlayer.viewOffset[0],
        player.pmove.origin[0] * 0.125 + player.viewOffset[0], fraction),
      lerp(previousPlayer.pmove.origin[1] * 0.125 + previousPlayer.viewOffset[1],
        player.pmove.origin[1] * 0.125 + player.viewOffset[1], fraction),
      lerp(previousPlayer.pmove.origin[2] * 0.125 + previousPlayer.viewOffset[2],
        player.pmove.origin[2] * 0.125 + player.viewOffset[2], fraction))
  end if
  if predictionAllowed and client.predictedStep > 0.0 then
    stepDelta = client.predictionRealTime - client.predictedStepTime
    if stepDelta >= 0.0 and stepDelta < 100.0 then
      viewOrigin.z = viewOrigin.z - client.predictedStep *
        (100.0 - stepDelta) * 0.01
    end if
  end if
  // A locally predicted player standing on a pusher otherwise jumps by the
  // brush's complete 100-ms server step while the brush itself interpolates.
  // The live host supplies the pusher's matching interpolation offset; demos
  // and remote-only clients retain the unmodified stock snapshot path.
  if predictionAllowed then
    viewOrigin.x = viewOrigin.x + predictionOffset.x
    viewOrigin.y = viewOrigin.y + predictionOffset.y
    viewOrigin.z = viewOrigin.z + predictionOffset.z
  end if
  viewAngles = cqt.zeroVec3()
  if usePrediction and client.predictionValid and player.pmove.moveType < qc.PM_DEAD then
    viewAngles = cqt.vec3(client.predictedAngles.x, client.predictedAngles.y,
      client.predictedAngles.z)
  else
    viewAngles = cqt.vec3(
      lerpAngle(previousPlayer.viewAngles[0], player.viewAngles[0], fraction),
      lerpAngle(previousPlayer.viewAngles[1], player.viewAngles[1], fraction),
      lerpAngle(previousPlayer.viewAngles[2], player.viewAngles[2], fraction))
  end if
  viewAngles.x = viewAngles.x + lerpAngle(previousPlayer.kickAngles[0], player.kickAngles[0], fraction)
  viewAngles.y = viewAngles.y + lerpAngle(previousPlayer.kickAngles[1], player.kickAngles[1], fraction)
  viewAngles.z = viewAngles.z + lerpAngle(previousPlayer.kickAngles[2], player.kickAngles[2], fraction)
  fov = lerp(previousPlayer.fov, player.fov, fraction)
  if fov <= 0.0 then fov = 90.0 end if
  halfFov = fov * 0.008726646259971648
  projectionDistance = width / (cstatenative.sin(halfFov) / cstatenative.cos(halfFov))
  fovY = cstatenative.atan2(height * 1.0, projectionDistance) * 114.59155902616465
  blend = [player.blend[0], player.blend[1], player.blend[2], player.blend[3]]
  // V_RenderView offsets the camera by half a protocol coordinate quantum so
  // it never lies exactly on a BSP node (most visibly, a water plane).  The
  // view weapon was already positioned from the unshifted origin above.
  renderViewOrigin = cqt.vec3(viewOrigin.x + 0.0625,
    viewOrigin.y + 0.0625, viewOrigin.z + 0.0625)
  return crt.refDef(0, 0, width, height, fov, fovY, renderViewOrigin, viewAngles,
    blend, renderTime * 0.001, player.rdFlags,
    client.current.areaBits,
    client.lightStyles, buildEntities(client, fraction, assetResolvers,
    localEntityNumber, randomResolver, viewOrigin, viewAngles), [], [])
end function

// Demos and deterministic renderer captures intentionally retain pure server
// interpolation.  The live product uses the explicit predicted entry point.
function buildRefDef(client, fraction, width, height, assetResolvers,
    localEntityNumber, randomResolver)
  return buildRefDefInternal(client, fraction, width, height, assetResolvers,
    localEntityNumber, randomResolver, false, cqt.zeroVec3())
end function

// Build predicted ref def.
function buildPredictedRefDef(client, fraction, width, height, assetResolvers,
    localEntityNumber, randomResolver)
  return buildRefDefInternal(client, fraction, width, height, assetResolvers,
    localEntityNumber, randomResolver, true, cqt.zeroVec3())
end function

// Build a predicted refdef while matching a locally ridden pusher's visual
// interpolation. The offset is deliberately explicit so ordinary movement
// prediction, demos and renderer captures cannot accidentally inherit it.
function buildPredictedRefDefWithOffset(client, fraction, width, height,
    assetResolvers, localEntityNumber, randomResolver, predictionOffset)
  return buildRefDefInternal(client, fraction, width, height, assetResolvers,
    localEntityNumber, randomResolver, true, predictionOffset)
end function
