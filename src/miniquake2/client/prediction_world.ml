//! Provides miniquake2 client prediction world facilities for this project.

/*
Copyright (C) 1997-2001 Id Software, Inc.
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later

Protocol-34 CL_PMTrace/CL_PMpointcontents collision world.  A remote client
only owns the BSP and the current packet entities, so prediction must clip the
world trace against encoded entity boxes and moving inline brush models.
*/
package miniquake2.client.prediction_world

import miniquake2.qcommon.constants as pwqc
import miniquake2.qcommon.types as pwqt
import miniquake2.collision.model as pwcollision
import miniquake2.physics.vector as pwvector
import miniquake2.client.prediction as pwprediction

/// Defines the box epsilon constant used by the miniquake2 client prediction world module.
const BOX_EPSILON = 0.03125

/// Store prediction world data.
struct PredictionWorld
  /// Stores the collision value associated with prediction world.
  collision
  /// Stores the config strings value associated with prediction world.
  configStrings
  /// Stores the snapshot value associated with prediction world.
  snapshot
  /// Stores the local entity number value associated with prediction world.
  localEntityNumber
end struct

/// Stores module-wide active prediction world state for the miniquake2 client prediction world module.
activePredictionWorld = void

/// Create world.
function createWorld()
  return PredictionWorld(void, [], void, -1)
end function

/// Create prediction workspace.
function createPredictionWorkspace()
  return pwprediction.createWorkspace(predictionTrace,
    predictionPointContents)
end function

/// Return the vec value.
/// @param values values value consumed by this operation.
function inline vec(values)
  return pwqt.Vec3(values[0], values[1], values[2])
end function

/// Report whether empty trace.
/// @param finish finish value consumed by this operation.
function emptyTrace(finish)
  return pwqt.Trace(false, false, 1.0,
    pwqt.Vec3(finish.x, finish.y, finish.z),
    pwqt.Plane(pwqt.zeroVec3(), 0.0, 0, 0),
    pwqt.CollisionSurface("", 0, 0), 0, void)
end function

/// Trace collision.
/// @param result Result object populated or inspected by the operation.
/// @param entity entity value consumed by this operation.
function collisionTrace(result, entity)
  normal = pwqt.Vec3(result.plane.normal.x, result.plane.normal.y,
    result.plane.normal.z)
  signBits = 0
  if normal.x < 0.0 then signBits = signBits | 1 end if
  if normal.y < 0.0 then signBits = signBits | 2 end if
  if normal.z < 0.0 then signBits = signBits | 4 end if
  return pwqt.Trace(result.allSolid, result.startSolid, result.fraction,
    pwqt.Vec3(result.endPosition.x, result.endPosition.y, result.endPosition.z),
    pwqt.Plane(normal, result.plane.distance, result.plane.type, signBits),
    pwqt.CollisionSurface(result.surface.name, result.surface.flags,
      result.surface.value), result.contents, entity)
end function

/// CM_HeadnodeForBox + CM_TransformedBoxTrace, expressed directly as a swept
/// point against the Minkowski-expanded encoded entity bounds. Keep the three
/// slab axes scalar: Pmove calls this for every solid entity and temporary
/// arrays/structs here measurably dominate remote-client prediction.
/// @param start start value consumed by this operation.
/// @param mins mins value consumed by this operation.
/// @param maxs maxs value consumed by this operation.
/// @param finish finish value consumed by this operation.
/// @param entity entity value consumed by this operation.
function boxEntityTrace(start, mins, maxs, finish, entity)
  // Keep box entity trace phases explicit: validate inputs, update owned state, then publish the result.
  horizontal = 8 * (entity.solid & 31)
  down = 8 * ((entity.solid >> 5) & 31)
  up = 8 * ((entity.solid >> 10) & 63) - 32
  originX = entity.origin[0]; originY = entity.origin[1]
  originZ = entity.origin[2]
  minimumX = originX - horizontal - maxs.x
  minimumY = originY - horizontal - maxs.y
  minimumZ = originZ - down - maxs.z
  maximumX = originX + horizontal - mins.x
  maximumY = originY + horizontal - mins.y
  maximumZ = originZ + up - mins.z
  output = emptyTrace(finish)
  startInside = start.x >= minimumX and start.x <= maximumX and
    start.y >= minimumY and start.y <= maximumY and
    start.z >= minimumZ and start.z <= maximumZ
  if startInside then
    output.startSolid = true
    output.allSolid = finish.x >= minimumX and finish.x <= maximumX and
      finish.y >= minimumY and finish.y <= maximumY and
      finish.z >= minimumZ and finish.z <= maximumZ
    output.contents = pwqc.CONTENTS_MONSTER
    output.entity = entity
    return output
  end if
  enter = -99999999.0; leave = 1.0; hitAxis = -1; hitSign = 0
  delta = finish.x - start.x
  if delta == 0.0 then
    if start.x < minimumX or start.x > maximumX then return output end if
  else
    axisEnter = 0.0; axisLeave = 0.0; axisSign = 0
    if delta > 0.0 then
      axisEnter = (minimumX - start.x - BOX_EPSILON) / delta
      axisLeave = (maximumX - start.x + BOX_EPSILON) / delta
      axisSign = -1
    else
      axisEnter = (maximumX - start.x + BOX_EPSILON) / delta
      axisLeave = (minimumX - start.x - BOX_EPSILON) / delta
      axisSign = 1
    end if
    if axisEnter > enter then enter = axisEnter; hitAxis = 0; hitSign = axisSign end if
    if axisLeave < leave then leave = axisLeave end if
  end if
  delta = finish.y - start.y
  if delta == 0.0 then
    if start.y < minimumY or start.y > maximumY then return output end if
  else
    axisEnter = 0.0; axisLeave = 0.0; axisSign = 0
    if delta > 0.0 then
      axisEnter = (minimumY - start.y - BOX_EPSILON) / delta
      axisLeave = (maximumY - start.y + BOX_EPSILON) / delta
      axisSign = -1
    else
      axisEnter = (maximumY - start.y + BOX_EPSILON) / delta
      axisLeave = (minimumY - start.y - BOX_EPSILON) / delta
      axisSign = 1
    end if
    if axisEnter > enter then enter = axisEnter; hitAxis = 1; hitSign = axisSign end if
    if axisLeave < leave then leave = axisLeave end if
  end if
  delta = finish.z - start.z
  if delta == 0.0 then
    if start.z < minimumZ or start.z > maximumZ then return output end if
  else
    axisEnter = 0.0; axisLeave = 0.0; axisSign = 0
    if delta > 0.0 then
      axisEnter = (minimumZ - start.z - BOX_EPSILON) / delta
      axisLeave = (maximumZ - start.z + BOX_EPSILON) / delta
      axisSign = -1
    else
      axisEnter = (maximumZ - start.z + BOX_EPSILON) / delta
      axisLeave = (minimumZ - start.z - BOX_EPSILON) / delta
      axisSign = 1
    end if
    if axisEnter > enter then enter = axisEnter; hitAxis = 2; hitSign = axisSign end if
    if axisLeave < leave then leave = axisLeave end if
  end if
  if enter > leave or leave < 0.0 or enter > 1.0 then return output end if
  if enter < 0.0 then enter = 0.0 end if
  output.fraction = enter
  output.endPosition = pwqt.Vec3(
    start.x + enter * (finish.x - start.x),
    start.y + enter * (finish.y - start.y),
    start.z + enter * (finish.z - start.z))
  normal = pwqt.zeroVec3()
  if hitAxis == 0 then normal.x = hitSign * 1.0 end if
  if hitAxis == 1 then normal.y = hitSign * 1.0 end if
  if hitAxis == 2 then normal.z = hitSign * 1.0 end if
  signBits = 0
  if normal.x < 0.0 then signBits = signBits | 1 end if
  if normal.y < 0.0 then signBits = signBits | 2 end if
  if normal.z < 0.0 then signBits = signBits | 4 end if
  output.plane = pwqt.Plane(normal, 0.0, hitAxis, signBits)
  output.contents = pwqc.CONTENTS_MONSTER
  output.entity = entity
  return output
end function

/// Performs the textSlice operation for the miniquake2 client prediction world module.
/// @param value Value consumed or transformed by the operation.
/// @param start start value consumed by this operation.
/// @param count Number of items or units to process.
function textSlice(value, start, count)
  if count <= 0 then return "" end if
  return decode(slice(bytes(value), start, count))
end function

/// Return the inline model number.
/// @param world world value consumed by this operation.
/// @param modelIndex Zero-based index of model.
function inlineModelNumber(world, modelIndex)
  configIndex = pwqc.CS_MODELS + modelIndex
  if modelIndex <= 0 or configIndex < 0 or
      configIndex >= len(world.configStrings) then return -1 end if
  name = world.configStrings[configIndex]
  if typeof(name) != "string" or len(bytes(name)) < 2 or
      bytes(name)[0] != 42 then return -1 end if
  parsed = try(toNumber(textSlice(name, 1, len(bytes(name)) - 1)))
  if parsed is error or typeof(parsed) != "int" or parsed <= 0 then return -1 end if
  if world.collision is void or parsed >= len(world.collision.map.models) then
    return -1
  end if
  return parsed
end function

/// Performs the dot operation for the miniquake2 client prediction world module.
/// @param first first value consumed by this operation.
/// @param second second value consumed by this operation.
function inline dot(first, second)
  return first.x * second.x + first.y * second.y + first.z * second.z
end function

/// Return the to model value.
/// @param point point value consumed by this operation.
/// @param origin origin value consumed by this operation.
/// @param basis basis value consumed by this operation.
function toModel(point, origin, basis)
  relative = pwqt.Vec3(point.x - origin.x, point.y - origin.y,
    point.z - origin.z)
  return pwqt.Vec3(dot(relative, basis[0]), -dot(relative, basis[1]),
    dot(relative, basis[2]))
end function

/// Return the normal to world value.
/// @param normal normal value consumed by this operation.
/// @param basis basis value consumed by this operation.
function normalToWorld(normal, basis)
  return pwqt.Vec3(
    basis[0].x * normal.x - basis[1].x * normal.y + basis[2].x * normal.z,
    basis[0].y * normal.x - basis[1].y * normal.y + basis[2].y * normal.z,
    basis[0].z * normal.x - basis[1].z * normal.y + basis[2].z * normal.z)
end function

/// Merge trace.
/// @param best best value consumed by this operation.
/// @param candidate candidate value consumed by this operation.
function mergeTrace(best, candidate)
  if candidate.allSolid or candidate.startSolid or
      candidate.fraction < best.fraction then
    previousStartSolid = best.startSolid
    best = candidate
    if previousStartSolid then best.startSolid = true end if
  else if candidate.startSolid then best.startSolid = true end if
  return best
end function

/// Trace entities.
/// @param world world value consumed by this operation.
/// @param start start value consumed by this operation.
/// @param mins mins value consumed by this operation.
/// @param maxs maxs value consumed by this operation.
/// @param finish finish value consumed by this operation.
/// @param best best value consumed by this operation.
function traceEntities(world, start, mins, maxs, finish, best)
  if world.snapshot is void then return best end if
  for each entity in world.snapshot.entities
    if entity.solid == 0 or entity.number == world.localEntityNumber then
      continue
    end if
    if best.allSolid then return best end if
    if entity.solid == 31 then
      modelNumber = inlineModelNumber(world, entity.modelIndex)
      if modelNumber < 0 then continue end if
      model = world.collision.map.models[modelNumber]
      origin = vec(entity.origin)
      angles = vec(entity.angles)
      basis = pwvector.angleVectors(angles)
      localStart = toModel(start, origin, basis)
      localFinish = toModel(finish, origin, basis)
      result = pwcollision.boxTrace(world.collision, localStart, localFinish,
        mins, maxs, model.headNode, pwqc.MASK_PLAYERSOLID)
      if result.fraction < 1.0 or result.startSolid or result.allSolid then
        result.endPosition = pwqt.Vec3(
          start.x + result.fraction * (finish.x - start.x),
          start.y + result.fraction * (finish.y - start.y),
          start.z + result.fraction * (finish.z - start.z))
        worldNormal = normalToWorld(result.plane.normal, basis)
        result.plane.normal = worldNormal
        result.plane.distance = result.plane.distance + dot(worldNormal, origin)
      end if
      best = mergeTrace(best, collisionTrace(result, entity))
    else
      best = mergeTrace(best,
        boxEntityTrace(start, mins, maxs, finish, entity))
    end if
  end for
  return best
end function

/// Trace state.
/// @param world world value consumed by this operation.
/// @param start start value consumed by this operation.
/// @param mins mins value consumed by this operation.
/// @param maxs maxs value consumed by this operation.
/// @param finish finish value consumed by this operation.
function trace(world, start, mins, maxs, finish)
  best = emptyTrace(finish)
  if world.collision is not void then
    worldResult = pwcollision.boxTrace(world.collision, start, finish,
      mins, maxs, 0, pwqc.MASK_PLAYERSOLID)
    worldEntity = void
    // Original CL_PMTrace uses the non-null sentinel (edict_t *)1. Pmove uses
    // this identity to establish PMF_ON_GROUND; a void world hit makes remote
    // clients fall through otherwise-solid floors.
    if worldResult.fraction < 1.0 or worldResult.startSolid or
        worldResult.allSolid then worldEntity = world end if
    best = collisionTrace(worldResult, worldEntity)
  end if
  return traceEntities(world, start, mins, maxs, finish, best)
end function

/// Performs the pointContents operation for the miniquake2 client prediction world module.
/// @param world world value consumed by this operation.
/// @param point point value consumed by this operation.
function pointContents(world, point)
  contents = 0
  if world.collision is not void then
    contents = pwcollision.pointContents(world.collision, point, 0)
  end if
  if world.snapshot is void or world.collision is void then return contents end if
  for each entity in world.snapshot.entities
    if entity.solid != 31 or entity.number == world.localEntityNumber then
      continue
    end if
    modelNumber = inlineModelNumber(world, entity.modelIndex)
    if modelNumber < 0 then continue end if
    origin = vec(entity.origin)
    localPoint = toModel(point, origin,
      pwvector.angleVectors(vec(entity.angles)))
    contents = contents | pwcollision.pointContents(world.collision,
      localPoint, world.collision.map.models[modelNumber].headNode)
  end for
  return contents
end function

/// Trace prediction.
/// @param start start value consumed by this operation.
/// @param mins mins value consumed by this operation.
/// @param maxs maxs value consumed by this operation.
/// @param finish finish value consumed by this operation.
function predictionTrace(start, mins, maxs, finish)
  global activePredictionWorld
  if activePredictionWorld is void then
    return error(7665, "packet prediction world is not active")
  end if
  return trace(activePredictionWorld, start, mins, maxs, finish)
end function

/// Return the prediction point contents value.
/// @param point point value consumed by this operation.
function predictionPointContents(point)
  global activePredictionWorld
  if activePredictionWorld is void then
    return error(7665, "packet prediction world is not active")
  end if
  return pointContents(activePredictionWorld, point)
end function

/// Return the predict value.
/// @param playerState playerState value consumed by this operation.
/// @param commands commands value consumed by this operation.
/// @param collision collision value consumed by this operation.
/// @param configStrings configStrings value consumed by this operation.
/// @param snapshot snapshot value consumed by this operation.
/// @param localEntityNumber localEntityNumber value consumed by this operation.
/// @param airAcceleration airAcceleration value consumed by this operation.
function predict(playerState, commands, collision, configStrings, snapshot,
    localEntityNumber, airAcceleration)
  global activePredictionWorld
  if typeof(configStrings) != "array" or typeof(snapshot) != "struct" or
      typeof(localEntityNumber) != "int" then
    return error(7666, "packet prediction inputs are malformed")
  end if
  world = PredictionWorld(collision, configStrings, snapshot,
    localEntityNumber)
  activePredictionWorld = world
  result = try(pwprediction.predict(playerState, commands, predictionTrace,
    predictionPointContents, airAcceleration))
  activePredictionWorld = void
  if result is error then return result end if
  return result
end function

/// Session-owned form for the render loop. Both the collision-world wrapper
/// and Pmove workspace retain identity across frames; only their live snapshot
/// references and scalar inputs are updated before synchronous replay.
/// @param world world value consumed by this operation.
/// @param workspace workspace value consumed by this operation.
/// @param playerState playerState value consumed by this operation.
/// @param commands commands value consumed by this operation.
/// @param commandCount Number of command to process.
/// @param collision collision value consumed by this operation.
/// @param configStrings configStrings value consumed by this operation.
/// @param snapshot snapshot value consumed by this operation.
/// @param localEntityNumber localEntityNumber value consumed by this operation.
/// @param airAcceleration airAcceleration value consumed by this operation.
function predictInto(world, workspace, playerState, commands, commandCount,
    collision, configStrings, snapshot, localEntityNumber, airAcceleration)
  global activePredictionWorld
  if typeof(world) != "struct" or typeof(configStrings) != "array" or
      typeof(snapshot) != "struct" or typeof(localEntityNumber) != "int" then
    return error(7666, "packet prediction inputs are malformed")
  end if
  world.collision = collision
  world.configStrings = configStrings
  world.snapshot = snapshot
  world.localEntityNumber = localEntityNumber
  activePredictionWorld = world
  result = try(pwprediction.predictInto(workspace, playerState, commands,
    commandCount, airAcceleration))
  activePredictionWorld = void
  if result is error then return result end if
  return result
end function
