/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* MiniLang implementation of the engine side of game_import_t. */
package miniquake2.server.game_bridge

import miniquake2.qcommon.constants as qc
import miniquake2.qcommon.types as qt
import miniquake2.qcommon.sizebuf as sizebuf
import miniquake2.qcommon.message as message
import miniquake2.qcommon.byteio as sgbbyteio
import miniquake2.qcommon.directions as qdir
import miniquake2.qcommon.cvar as cvars
import miniquake2.qcommon.cmd as commands
import miniquake2.game.types as gt
import miniquake2.game.constants as gc
import miniquake2.collision.model as collision
import miniquake2.format.constants as sgbformatconstants
import miniquake2.format.binary as sgbformatbinary
import miniquake2.server.types as st
import miniquake2.server.sound_events as ssoundevents
import miniquake2.server.game_messages as sgmessages
import miniquake2.physics.pmove as phmove
import miniquake2.physics.vector as sgbvector

gameBridgeActiveRuntime = void
const MAX_GAME_BRIDGE_LOGS = 1024

// Append game bridge log.
function gameBridgeAppendLog(context, value)
  if len(context.logs) < MAX_GAME_BRIDGE_LOGS then
    context.logs = context.logs + [value]
    return true
  end if
  output = array(MAX_GAME_BRIDGE_LOGS, void)
  index = 1
  while index < MAX_GAME_BRIDGE_LOGS
    output[index - 1] = context.logs[index]
    index = index + 1
  end while
  output[MAX_GAME_BRIDGE_LOGS - 1] = value
  context.logs = output
  return true
end function

// Report whether require active.
function requireActive(operation)
  global gameBridgeActiveRuntime
  if gameBridgeActiveRuntime is void then return error(3900, operation + ": server bridge is not installed") end if
  return gameBridgeActiveRuntime
end function

// Listen-client prediction shares the exact live collision bridge with the
// authoritative server. Explicit activation prevents a second test/listen
// session from leaving the module-global callback context on the wrong map.
function activateRuntime(context)
  global gameBridgeActiveRuntime
  if typeof(context) != "struct" then return error(3900, "invalid server bridge runtime") end if
  gameBridgeActiveRuntime = context
  return context
end function

// Append log.
function appendLog(level, value)
  context = requireActive("print")
  return gameBridgeAppendLog(context, [level, value])
end function

// Return the bprintf value.
function bprintf(value)
  return appendLog("broadcast", value)
end function

// Return the dprintf value.
function dprintf(value)
  return appendLog("debug", value)
end function

// Return the cprintf value.
function cprintf(entity, level, value)
  if typeof(level) != "int" or level < qc.PRINT_LOW or level > qc.PRINT_CHAT then
    return error(3956, "client print level outside Protocol-34 range")
  end if
  context = requireActive("cprintf")
  if entity is void then
    gameBridgeAppendLog(context, ["console:" + level, value])
    return true
  end if
  buffer = sizebuf.alloc(qc.MAX_MSGLEN)
  message.writeByte(buffer, qc.SVC_PRINT)
  message.writeByte(buffer, level)
  message.writeString(buffer, value)
  event = sgmessages.enqueueUnicast(context, entity, true, sizebuf.dataSlice(buffer))
  gameBridgeAppendLog(context, ["client:" + level, value])
  return event
end function

// Return the centerprintf value.
function centerprintf(entity, value)
  context = requireActive("centerprintf")
  targetNumber = try(sgmessages.unicastEntityNumber(context, entity))
  if targetNumber is error then
    // Quake II 3.19 PF_centerprintf deliberately ignores non-client edicts.
    gameBridgeAppendLog(context, ["center-drop", value])
    return false
  end if
  buffer = sizebuf.alloc(qc.MAX_MSGLEN)
  message.writeByte(buffer, qc.SVC_CENTERPRINT)
  message.writeString(buffer, value)
  event = sgmessages.enqueueUnicast(context, entity, true, sizebuf.dataSlice(buffer))
  gameBridgeAppendLog(context, ["center", value])
  return event
end function

// Return the sound value.
function sound(entity, channel, soundIndex, volume, attenuation, timeOffset)
  context = requireActive("sound")
  soundPosition = void
  if entity is not void and ((entity.serverFlags & gc.SVF_NOCLIENT) != 0 or
      entity.solid == gc.SOLID_BSP) then
    entityOrigin = entity.state.origin
    if entity.solid == gc.SOLID_BSP then
      // SV_StartSound sends an explicit midpoint for inline brush models.
      // Their model origins are mapper-defined and can be far from the audible
      // door, platform or train, so entity-origin attenuation is incorrect.
      soundPosition = qt.Vec3(
        entityOrigin.x + 0.5 * (entity.mins.x + entity.maxs.x),
        entityOrigin.y + 0.5 * (entity.mins.y + entity.maxs.y),
        entityOrigin.z + 0.5 * (entity.mins.z + entity.maxs.z)
      )
    else
      // The client has no snapshot origin for SVF_NOCLIENT entities.
      soundPosition = qt.Vec3(entityOrigin.x, entityOrigin.y, entityOrigin.z)
    end if
  end if
  event = ssoundevents.enqueue(context, soundPosition, entity, channel,
    soundIndex, volume, attenuation, timeOffset)
  gameBridgeAppendLog(context, ["sound", soundIndex])
  return event
end function

// Return the positioned sound value.
function positionedSound(origin, entity, channel, soundIndex, volume, attenuation, timeOffset)
  context = requireActive("positioned-sound")
  event = ssoundevents.enqueue(context, origin, entity, channel, soundIndex, volume, attenuation, timeOffset)
  gameBridgeAppendLog(context, ["positioned-sound", soundIndex])
  return event
end function

// Return the config string value.
function configString(index, value)
  context = requireActive("configstring")
  if index < 0 or index >= len(context.configStrings) then return error(3901, "configstring index outside table") end if
  if context.configStrings[index] != value then
    context.configStrings[index] = value
    context.configStringDirty[index] = true
  end if
  return true
end function

// Return the fail value.
function fail(value)
  return error(3902, value)
end function

// Find index.
function findIndex(values, name, create)
  if name == "" then return 0 end if
  i = 1
  while i < len(values)
    if values[i] == name then return i end if
    i = i + 1
  end while
  if create == false then return 0 end if
  i = 1
  while i < len(values)
    if values[i] == "" then values[i] = name; return i end if
    i = i + 1
  end while
  return error(3903, "config index table is full")
end function

// Return the bridge model index.
function bridgeModelIndex(name)
  context = requireActive("modelindex")
  index = findIndex(context.modelNames, name, true)
  if index > 0 then configString(qc.CS_MODELS + index, name) end if
  return index
end function

// Return the bridge sound index.
function bridgeSoundIndex(name)
  context = requireActive("soundindex")
  index = findIndex(context.soundNames, name, true)
  if index > 0 then configString(qc.CS_SOUNDS + index, name) end if
  return index
end function

// Return the bridge image index.
function bridgeImageIndex(name)
  context = requireActive("imageindex")
  index = findIndex(context.imageNames, name, true)
  if index > 0 then configString(qc.CS_IMAGES + index, name) end if
  return index
end function

// Return the inline model number.
function inlineModelNumber(name)
  source = bytes(name)
  if len(source) < 2 or source[0] != 42 then return -1 end if
  value = 0
  index = 1
  while index < len(source)
    if source[index] < 48 or source[index] > 57 then return error(3910, "malformed inline model name " + name) end if
    value = value * 10 + source[index] - 48
    index = index + 1
  end while
  return value
end function

// Set model.
function setModel(entity, name)
  sgbSetModelContextHolder = requireActive("setmodel")
  sgbSetModelEntityHolder = entity
  sgbSetModelEntityHolder.state.modelIndex = bridgeModelIndex(name)
  sgbInlineNumber = inlineModelNumber(name)
  if sgbInlineNumber >= 0 then
    // Headless Game-API tests may intentionally spawn before a BSP collision
    // map is attached. Keep the model index and bind the hull once a real
    // server collision map is present.
    if sgbSetModelContextHolder.collision is void then return true end if
    if sgbInlineNumber >= len(sgbSetModelContextHolder.collision.map.models) then return error(3912, "inline model outside BSP model table") end if
    sgbCollisionMapHolder = sgbSetModelContextHolder.collision.map
    sgbInlineModelHolder = sgbCollisionMapHolder.models[sgbInlineNumber]
    if typeof(sgbInlineModelHolder) != "struct" then return error(3933, "inline BSP model record is unavailable") end if
    sgbInlineMinsHolder = try(sgbInlineModelHolder.mins)
    sgbInlineMaxsHolder = try(sgbInlineModelHolder.maxs)
    sgbInlineHeadNodeProbe = try(sgbInlineModelHolder.headNode)
    sgbInlineModelOffset = void
    sgbInlineMinX = 0.0; sgbInlineMinY = 0.0; sgbInlineMinZ = 0.0
    sgbInlineMaxX = 0.0; sgbInlineMaxY = 0.0; sgbInlineMaxZ = 0.0
    if typeof(sgbInlineMinsHolder) == "struct" and typeof(sgbInlineMaxsHolder) == "struct" then
      sgbInlineMinX = sgbInlineMinsHolder.x; sgbInlineMinY = sgbInlineMinsHolder.y; sgbInlineMinZ = sgbInlineMinsHolder.z
      sgbInlineMaxX = sgbInlineMaxsHolder.x; sgbInlineMaxY = sgbInlineMaxsHolder.y; sgbInlineMaxZ = sgbInlineMaxsHolder.z
    else
      // The raw BSP lump is the canonical immutable source. Re-materialize
      // inline bounds if a late full-product collection lost a nested Vec3.
      if typeof(sgbCollisionMapHolder.data) != "bytes" or typeof(sgbCollisionMapHolder.lumps) != "array" then
        return error(3934, "inline BSP model bounds and source lump are unavailable")
      end if
      sgbModelLumpHolder = sgbCollisionMapHolder.lumps[sgbformatconstants.LUMP_MODELS]
      if typeof(sgbModelLumpHolder) != "struct" or sgbInlineNumber * 48 + 48 > sgbModelLumpHolder.length then
        return error(3934, "inline BSP model bounds and source lump are unavailable")
      end if
      sgbInlineModelOffset = sgbModelLumpHolder.offset + sgbInlineNumber * 48
      sgbInlineMinX = sgbformatbinary.f32(sgbCollisionMapHolder.data, sgbInlineModelOffset)
      sgbInlineMinY = sgbformatbinary.f32(sgbCollisionMapHolder.data, sgbInlineModelOffset + 4)
      sgbInlineMinZ = sgbformatbinary.f32(sgbCollisionMapHolder.data, sgbInlineModelOffset + 8)
      sgbInlineMaxX = sgbformatbinary.f32(sgbCollisionMapHolder.data, sgbInlineModelOffset + 12)
      sgbInlineMaxY = sgbformatbinary.f32(sgbCollisionMapHolder.data, sgbInlineModelOffset + 16)
      sgbInlineMaxZ = sgbformatbinary.f32(sgbCollisionMapHolder.data, sgbInlineModelOffset + 20)
    end if
    sgbEntityMinsHolder = qt.Vec3(sgbInlineMinX, sgbInlineMinY, sgbInlineMinZ)
    sgbEntityMaxsHolder = qt.Vec3(sgbInlineMaxX, sgbInlineMaxY, sgbInlineMaxZ)
    sgbEntitySizeHolder = qt.Vec3(sgbInlineMaxX - sgbInlineMinX, sgbInlineMaxY - sgbInlineMinY, sgbInlineMaxZ - sgbInlineMinZ)
    sgbSetModelEntityHolder.mins = sgbEntityMinsHolder
    sgbSetModelEntityHolder.maxs = sgbEntityMaxsHolder
    sgbSetModelEntityHolder.size = sgbEntitySizeHolder
    if sgbInlineHeadNodeProbe is error then
      if sgbInlineModelOffset is void then
        sgbModelLumpHolder = sgbCollisionMapHolder.lumps[sgbformatconstants.LUMP_MODELS]
        sgbInlineModelOffset = sgbModelLumpHolder.offset + sgbInlineNumber * 48
      end if
      sgbInlineHeadNodeProbe = sgbformatbinary.i32(sgbCollisionMapHolder.data, sgbInlineModelOffset + 36)
    end if
    sgbSetModelEntityHolder.headNode = sgbInlineHeadNodeProbe
    gt.stabilizeEdict(sgbSetModelEntityHolder)
  end if
  return true
end function

// Trace adapt collision with entity.
function adaptCollisionTraceWithEntity(context, result, hitEntity)
  signBits = 0
  if result.plane.normal.x < 0.0 then signBits = signBits | 1 end if
  if result.plane.normal.y < 0.0 then signBits = signBits | 2 end if
  if result.plane.normal.z < 0.0 then signBits = signBits | 4 end if
  plane = qt.Plane(result.plane.normal, result.plane.distance, result.plane.type, signBits)
  surface = qt.CollisionSurface(result.surface.name, result.surface.flags, result.surface.value)
  return qt.Trace(result.allSolid, result.startSolid, result.fraction, result.endPosition,
    plane, surface, result.contents, hitEntity)
end function

// Trace adapt collision.
function adaptCollisionTrace(context, result)
  hitEntity = void
  if (result.fraction < 1.0 or result.startSolid or result.allSolid) and context.game is not void and context.game.numEdicts > 0 then
    hitEntity = context.game.edicts[0]
  end if
  return adaptCollisionTraceWithEntity(context, result, hitEntity)
end function

// Trace dot.
function traceDot(first, second)
  return first.x * second.x + first.y * second.y + first.z * second.z
end function

// Trace to model.
function traceToModel(point, origin, basis)
  relative = qt.Vec3(point.x - origin.x, point.y - origin.y, point.z - origin.z)
  return qt.Vec3(traceDot(relative, basis[0]), -traceDot(relative, basis[1]), traceDot(relative, basis[2]))
end function

// Trace normal to world.
function traceNormalToWorld(normal, basis)
  return qt.Vec3(
    basis[0].x * normal.x - basis[1].x * normal.y + basis[2].x * normal.z,
    basis[0].y * normal.x - basis[1].y * normal.y + basis[2].y * normal.z,
    basis[0].z * normal.x - basis[1].z * normal.y + basis[2].z * normal.z
  )
end function

// Trace same entity.
function sameTraceEntity(first, second)
  if first is void or second is void then return false end if
  return first.state.number == second.state.number
end function

// Trace entity excluded.
function traceEntityExcluded(entity, passEntity, contentMask)
  if sameTraceEntity(entity, passEntity) then return true end if
  if passEntity is not void then
    // SV_ClipMoveToEntities ignores both directions of the owner relation:
    // missiles do not hit their owner and owners do not hit their missiles.
    if sameTraceEntity(entity.owner, passEntity) then return true end if
    if sameTraceEntity(passEntity.owner, entity) then return true end if
  end if
  if (contentMask & qc.CONTENTS_DEADMONSTER) == 0 and
      (entity.serverFlags & gc.SVF_DEADMONSTER) != 0 then return true end if
  return false
end function

// Report whether empty bridge trace.
function emptyBridgeTrace(finish)
  return qt.Trace(false, false, 1.0,
    qt.Vec3(finish.x, finish.y, finish.z),
    qt.Plane(qt.zeroVec3(), 0.0, 0, 0),
    qt.CollisionSurface("", 0, 0), 0, void)
end function

// CM_HeadnodeForBox + CM_TransformedBoxTrace for a linked SOLID_BBOX. The
// original collision model implements this as a temporary BSP hull; scalar
// Minkowski slabs are identical and avoid rebuilding or allocating that hull
// in every authoritative Pmove trace.
function solidBoxTrace(start, mins, maxs, finish, entity)
  entityOrigin = entity.state.origin
  minimumX = entityOrigin.x + entity.mins.x - maxs.x
  minimumY = entityOrigin.y + entity.mins.y - maxs.y
  minimumZ = entityOrigin.z + entity.mins.z - maxs.z
  maximumX = entityOrigin.x + entity.maxs.x - mins.x
  maximumY = entityOrigin.y + entity.maxs.y - mins.y
  maximumZ = entityOrigin.z + entity.maxs.z - mins.z
  output = emptyBridgeTrace(finish)
  startInside = start.x >= minimumX and start.x <= maximumX and
    start.y >= minimumY and start.y <= maximumY and
    start.z >= minimumZ and start.z <= maximumZ
  if startInside then
    output.startSolid = true
    output.allSolid = finish.x >= minimumX and finish.x <= maximumX and
      finish.y >= minimumY and finish.y <= maximumY and
      finish.z >= minimumZ and finish.z <= maximumZ
    // CM_BoxTrace's stationary CM_TestBoxInBrush path returns fraction zero.
    if start.x == finish.x and start.y == finish.y and start.z == finish.z then
      output.fraction = 0.0
    end if
    output.contents = qc.CONTENTS_MONSTER
    output.entity = entity
    return output
  end if

  enterFraction = -99999999.0
  leaveFraction = 1.0
  hitAxis = -1
  hitSign = 0
  axisEnter = 0.0
  axisLeave = 0.0
  axisSign = 0
  delta = finish.x - start.x
  if delta == 0.0 then
    if start.x < minimumX or start.x > maximumX then return output end if
  else
    if delta > 0.0 then
      axisEnter = (minimumX - start.x - collision.DIST_EPSILON) / delta
      axisLeave = (maximumX - start.x + collision.DIST_EPSILON) / delta
      axisSign = -1
    else
      axisEnter = (maximumX - start.x + collision.DIST_EPSILON) / delta
      axisLeave = (minimumX - start.x - collision.DIST_EPSILON) / delta
      axisSign = 1
    end if
    if axisEnter > enterFraction then
      enterFraction = axisEnter; hitAxis = 0; hitSign = axisSign
    end if
    if axisLeave < leaveFraction then leaveFraction = axisLeave end if
  end if
  delta = finish.y - start.y
  if delta == 0.0 then
    if start.y < minimumY or start.y > maximumY then return output end if
  else
    if delta > 0.0 then
      axisEnter = (minimumY - start.y - collision.DIST_EPSILON) / delta
      axisLeave = (maximumY - start.y + collision.DIST_EPSILON) / delta
      axisSign = -1
    else
      axisEnter = (maximumY - start.y + collision.DIST_EPSILON) / delta
      axisLeave = (minimumY - start.y - collision.DIST_EPSILON) / delta
      axisSign = 1
    end if
    if axisEnter > enterFraction then
      enterFraction = axisEnter; hitAxis = 1; hitSign = axisSign
    end if
    if axisLeave < leaveFraction then leaveFraction = axisLeave end if
  end if
  delta = finish.z - start.z
  if delta == 0.0 then
    if start.z < minimumZ or start.z > maximumZ then return output end if
  else
    if delta > 0.0 then
      axisEnter = (minimumZ - start.z - collision.DIST_EPSILON) / delta
      axisLeave = (maximumZ - start.z + collision.DIST_EPSILON) / delta
      axisSign = -1
    else
      axisEnter = (maximumZ - start.z + collision.DIST_EPSILON) / delta
      axisLeave = (minimumZ - start.z - collision.DIST_EPSILON) / delta
      axisSign = 1
    end if
    if axisEnter > enterFraction then
      enterFraction = axisEnter; hitAxis = 2; hitSign = axisSign
    end if
    if axisLeave < leaveFraction then leaveFraction = axisLeave end if
  end if
  if enterFraction > leaveFraction or leaveFraction < 0.0 or
      enterFraction > 1.0 then return output end if
  if enterFraction < 0.0 then enterFraction = 0.0 end if
  output.fraction = enterFraction
  output.endPosition = qt.Vec3(
    start.x + enterFraction * (finish.x - start.x),
    start.y + enterFraction * (finish.y - start.y),
    start.z + enterFraction * (finish.z - start.z))
  normal = qt.zeroVec3()
  if hitAxis == 0 then normal.x = hitSign * 1.0 end if
  if hitAxis == 1 then normal.y = hitSign * 1.0 end if
  if hitAxis == 2 then normal.z = hitSign * 1.0 end if
  signBits = 0
  if normal.x < 0.0 then signBits = signBits | 1 end if
  if normal.y < 0.0 then signBits = signBits | 2 end if
  if normal.z < 0.0 then signBits = signBits | 4 end if
  planeType = hitAxis
  planeDistance = 0.0
  if hitSign < 0 then
    planeType = 3 + hitAxis
    if hitAxis == 0 then planeDistance = -entity.mins.x end if
    if hitAxis == 1 then planeDistance = -entity.mins.y end if
    if hitAxis == 2 then planeDistance = -entity.mins.z end if
  else
    if hitAxis == 0 then planeDistance = entity.maxs.x end if
    if hitAxis == 1 then planeDistance = entity.maxs.y end if
    if hitAxis == 2 then planeDistance = entity.maxs.z end if
  end if
  output.plane = qt.Plane(normal, planeDistance, planeType, signBits)
  output.contents = qc.CONTENTS_MONSTER
  output.entity = entity
  return output
end function

// Trace state.
function trace(start, mins, maxs, finish, passEntity, contentMask)
  context = requireActive("trace")
  worldEntity = void
  best = void
  if context.game is not void and context.game.numEdicts > 0 then worldEntity = context.game.edicts[0] end if
  if context.collision is not void then
    worldResult = collision.boxTrace(context.collision, start, finish, mins, maxs, 0, contentMask)
    worldHit = void
    if worldResult.fraction < 1.0 or worldResult.startSolid or worldResult.allSolid then worldHit = worldEntity end if
    best = adaptCollisionTraceWithEntity(context, worldResult, worldHit)
    // The original SV_Trace never clips entities after a fraction-zero world hit.
    if best.fraction == 0.0 then return best end if
  else
    best = emptyBridgeTrace(finish)
  end if

  // SV_ClipMoveToEntities: inline BSP edicts have their own hull headnode and
  // are traced in model-local coordinates. SV_AreaEdicts first restricts the
  // candidates to the swept hull bounds; the same scalar broad phase here is
  // essential on maps with hundreds of doors and plats.
  if context.game is not void then
    traceMinX = start.x + mins.x; traceMinY = start.y + mins.y
    traceMinZ = start.z + mins.z
    finishMinX = finish.x + mins.x; finishMinY = finish.y + mins.y
    finishMinZ = finish.z + mins.z
    if finishMinX < traceMinX then traceMinX = finishMinX end if
    if finishMinY < traceMinY then traceMinY = finishMinY end if
    if finishMinZ < traceMinZ then traceMinZ = finishMinZ end if
    traceMaxX = start.x + maxs.x; traceMaxY = start.y + maxs.y
    traceMaxZ = start.z + maxs.z
    finishMaxX = finish.x + maxs.x; finishMaxY = finish.y + maxs.y
    finishMaxZ = finish.z + maxs.z
    if finishMaxX > traceMaxX then traceMaxX = finishMaxX end if
    if finishMaxY > traceMaxY then traceMaxY = finishMaxY end if
    if finishMaxZ > traceMaxZ then traceMaxZ = finishMaxZ end if
    traceMinX = traceMinX - 1.0; traceMinY = traceMinY - 1.0
    traceMinZ = traceMinZ - 1.0
    traceMaxX = traceMaxX + 1.0; traceMaxY = traceMaxY + 1.0
    traceMaxZ = traceMaxZ + 1.0
    if context.collision is not void then
      index = 0
      while index < context.inlineBrushCount and best.allSolid != true
        entity = context.inlineBrushes[index]
        eligible = entity.inUse and entity.solid == gc.SOLID_BSP and
          traceEntityExcluded(entity, passEntity, contentMask) != true
        if eligible then
          entityMins = entity.absoluteMins; entityMaxs = entity.absoluteMaxs
          eligible = entityMaxs.x >= traceMinX and entityMins.x <= traceMaxX and
            entityMaxs.y >= traceMinY and entityMins.y <= traceMaxY and
            entityMaxs.z >= traceMinZ and entityMins.z <= traceMaxZ
        end if
        inlineNumber = context.inlineBrushModelNumbers[index]
        if eligible and inlineNumber >= 0 and inlineNumber < len(context.collision.map.models) then
          basis = sgbvector.angleVectors(entity.state.angles)
          localStart = traceToModel(start, entity.state.origin, basis)
          localFinish = traceToModel(finish, entity.state.origin, basis)
          inlineResult = collision.boxTrace(context.collision, localStart, localFinish, mins, maxs, entity.headNode, contentMask)
          if inlineResult.fraction < best.fraction or inlineResult.startSolid or inlineResult.allSolid then
            inlineResult.endPosition = qt.Vec3(
              start.x + inlineResult.fraction * (finish.x - start.x),
              start.y + inlineResult.fraction * (finish.y - start.y),
              start.z + inlineResult.fraction * (finish.z - start.z)
            )
            worldNormal = traceNormalToWorld(inlineResult.plane.normal, basis)
            inlineResult.plane.normal = worldNormal
            inlineResult.plane.distance = inlineResult.plane.distance + traceDot(worldNormal, entity.state.origin)
            previousStartSolid = best.startSolid
            best = adaptCollisionTraceWithEntity(context, inlineResult, entity)
            if previousStartSolid then best.startSolid = true end if
          end if
        end if
        index = index + 1
      end while
    end if

    // CM_HeadnodeForBox gives every non-BSP solid CONTENTS_MONSTER. Iterate
    // only the linked SOLID_BBOX index, matching SV_AreaEdicts without a full
    // allocated-edict scan in each player/monster movement trace.
    if (contentMask & qc.CONTENTS_MONSTER) != 0 then
      index = 0
      while index < context.solidBoxCount and best.allSolid != true
        entity = context.solidBoxEdicts[index]
        eligible = entity.inUse and entity.solid == gc.SOLID_BBOX and
          traceEntityExcluded(entity, passEntity, contentMask) != true
        if eligible then
          entityMins = entity.absoluteMins; entityMaxs = entity.absoluteMaxs
          eligible = entityMaxs.x >= traceMinX and entityMins.x <= traceMaxX and
            entityMaxs.y >= traceMinY and entityMins.y <= traceMaxY and
            entityMaxs.z >= traceMinZ and entityMins.z <= traceMaxZ
        end if
        if eligible then
          boxResult = solidBoxTrace(start, mins, maxs, finish, entity)
          if boxResult.allSolid or boxResult.startSolid or
              boxResult.fraction < best.fraction then
            previousStartSolid = best.startSolid
            best = boxResult
            if previousStartSolid then best.startSolid = true end if
          end if
        end if
        index = index + 1
      end while
    end if
  end if
  return best
end function

// Return the point contents value.
function pointContents(point)
  context = requireActive("pointcontents")
  if context.collision is void then return 0 end if
  contents = collision.pointContents(context.collision, point, 0)
  if context.game is not void then
    index = 0
    while index < context.inlineBrushCount
      entity = context.inlineBrushes[index]
      entityMins = entity.absoluteMins; entityMaxs = entity.absoluteMaxs
      eligible = entity.inUse and entity.solid == gc.SOLID_BSP and
        point.x >= entityMins.x and point.x <= entityMaxs.x and
        point.y >= entityMins.y and point.y <= entityMaxs.y and
        point.z >= entityMins.z and point.z <= entityMaxs.z
      inlineNumber = context.inlineBrushModelNumbers[index]
      if eligible and inlineNumber >= 0 and inlineNumber < len(context.collision.map.models) then
        basis = sgbvector.angleVectors(entity.state.angles)
        localPoint = traceToModel(point, entity.state.origin, basis)
        contents = contents | collision.pointContents(context.collision, localPoint, entity.headNode)
      end if
      index = index + 1
    end while
  end if
  return contents
end function

// Return the in pvs value.
function inPVS(first, second)
  context = requireActive("inPVS")
  if context.collision is void then return true end if
  firstLeaf = collision.pointLeafNumber(context.collision, first, 0)
  secondLeaf = collision.pointLeafNumber(context.collision, second, 0)
  firstCluster = context.collision.map.leafs[firstLeaf].cluster
  secondCluster = context.collision.map.leafs[secondLeaf].cluster
  if firstCluster < 0 or secondCluster < 0 then return false end if
  row = collision.visibilityRow(context.collision, firstCluster, 0)
  visible = (row[secondCluster >> 3] & (1 << (secondCluster & 7))) != 0
  return visible and collision.areasConnected(context.collision, context.collision.map.leafs[firstLeaf].area, context.collision.map.leafs[secondLeaf].area)
end function

// Return the in phs value.
function inPHS(first, second)
  context = requireActive("inPHS")
  if context.collision is void then return true end if
  firstLeaf = collision.pointLeafNumber(context.collision, first, 0)
  secondLeaf = collision.pointLeafNumber(context.collision, second, 0)
  firstCluster = context.collision.map.leafs[firstLeaf].cluster
  secondCluster = context.collision.map.leafs[secondLeaf].cluster
  if firstCluster < 0 or secondCluster < 0 then return false end if
  row = collision.visibilityRow(context.collision, firstCluster, 1)
  return (row[secondCluster >> 3] & (1 << (secondCluster & 7))) != 0
end function

// Set area portal state.
function setAreaPortalState(portalNumber, isOpen)
  context = requireActive("SetAreaPortalState")
  if context.collision is void then return error(3904, "no collision map loaded") end if
  return collision.setAreaPortalState(context.collision, portalNumber, isOpen)
end function

// Report whether areas connected.
function areasConnected(first, second)
  context = requireActive("AreasConnected")
  if context.collision is void then return true end if
  return collision.areasConnected(context.collision, first, second)
end function

// Report whether collision world ready.
function collisionWorldReady()
  context = requireActive("collisionWorldReady")
  return context.collision is not void
end function

// Return the transformed entity bounds.
function transformedEntityBounds(entity)
  // Keep transformed entity bounds phases explicit: validate inputs, update owned state, then publish the result.
  if typeof(entity) != "struct" then return error(3930, "transformed bounds require an Edict") end if
  sgbBoundsEntityHolder = entity
  sgbBoundsStateHolder = sgbBoundsEntityHolder.state
  if typeof(sgbBoundsStateHolder) != "struct" then return error(3931, "transformed bounds require an Edict state") end if
  sgbBoundsAnglesHolder = sgbBoundsStateHolder.angles
  sgbBoundsOriginHolder = sgbBoundsStateHolder.origin
  sgbBoundsMinsHolder = sgbBoundsEntityHolder.mins
  sgbBoundsMaxsHolder = sgbBoundsEntityHolder.maxs
  if typeof(sgbBoundsAnglesHolder) != "struct" or typeof(sgbBoundsOriginHolder) != "struct" or
      typeof(sgbBoundsMinsHolder) != "struct" or typeof(sgbBoundsMaxsHolder) != "struct" then
    return error(3932, "transformed bounds require vector-shaped Edict fields")
  end if
  gt.stabilizeEdict(sgbBoundsEntityHolder)
  sgbBoundsOriginX = sgbBoundsOriginHolder.x; sgbBoundsOriginY = sgbBoundsOriginHolder.y; sgbBoundsOriginZ = sgbBoundsOriginHolder.z
  sgbBoundsMinSourceX = sgbBoundsMinsHolder.x; sgbBoundsMinSourceY = sgbBoundsMinsHolder.y; sgbBoundsMinSourceZ = sgbBoundsMinsHolder.z
  sgbBoundsMaxSourceX = sgbBoundsMaxsHolder.x; sgbBoundsMaxSourceY = sgbBoundsMaxsHolder.y; sgbBoundsMaxSourceZ = sgbBoundsMaxsHolder.z
  sgbBoundsBasisHolder = sgbvector.angleVectors(sgbBoundsAnglesHolder)
  sgbBoundsMinX = 999999999.0; sgbBoundsMinY = 999999999.0; sgbBoundsMinZ = 999999999.0
  sgbBoundsMaxX = -999999999.0; sgbBoundsMaxY = -999999999.0; sgbBoundsMaxZ = -999999999.0
  sgbBoundsCornerIndex = 0
  while sgbBoundsCornerIndex < 8
    sgbBoundsLocalX = sgbBoundsMinSourceX; sgbBoundsLocalY = sgbBoundsMinSourceY; sgbBoundsLocalZ = sgbBoundsMinSourceZ
    if (sgbBoundsCornerIndex & 1) != 0 then sgbBoundsLocalX = sgbBoundsMaxSourceX end if
    if (sgbBoundsCornerIndex & 2) != 0 then sgbBoundsLocalY = sgbBoundsMaxSourceY end if
    if (sgbBoundsCornerIndex & 4) != 0 then sgbBoundsLocalZ = sgbBoundsMaxSourceZ end if
    sgbBoundsCornerHolder = qt.Vec3(sgbBoundsLocalX, sgbBoundsLocalY, sgbBoundsLocalZ)
    sgbBoundsRotatedHolder = traceNormalToWorld(sgbBoundsCornerHolder, sgbBoundsBasisHolder)
    sgbBoundsWorldX = sgbBoundsOriginX + sgbBoundsRotatedHolder.x
    sgbBoundsWorldY = sgbBoundsOriginY + sgbBoundsRotatedHolder.y
    sgbBoundsWorldZ = sgbBoundsOriginZ + sgbBoundsRotatedHolder.z
    if sgbBoundsWorldX < sgbBoundsMinX then sgbBoundsMinX = sgbBoundsWorldX end if
    if sgbBoundsWorldY < sgbBoundsMinY then sgbBoundsMinY = sgbBoundsWorldY end if
    if sgbBoundsWorldZ < sgbBoundsMinZ then sgbBoundsMinZ = sgbBoundsWorldZ end if
    if sgbBoundsWorldX > sgbBoundsMaxX then sgbBoundsMaxX = sgbBoundsWorldX end if
    if sgbBoundsWorldY > sgbBoundsMaxY then sgbBoundsMaxY = sgbBoundsWorldY end if
    if sgbBoundsWorldZ > sgbBoundsMaxZ then sgbBoundsMaxZ = sgbBoundsWorldZ end if
    sgbBoundsCornerIndex = sgbBoundsCornerIndex + 1
  end while
  sgbBoundsResultMinsHolder = qt.Vec3(sgbBoundsMinX - 1.0, sgbBoundsMinY - 1.0, sgbBoundsMinZ - 1.0)
  sgbBoundsResultMaxsHolder = qt.Vec3(sgbBoundsMaxX + 1.0, sgbBoundsMaxY + 1.0, sgbBoundsMaxZ + 1.0)
  return [sgbBoundsResultMinsHolder, sgbBoundsResultMaxsHolder]
end function

// Cache inline brush index.
function inlineBrushCacheIndex(context, entity)
  number = entity.state.number
  if number < 0 or number >= len(context.inlineBrushPositions) then return -1 end if
  index = context.inlineBrushPositions[number] - 1
  if index >= 0 and index < context.inlineBrushCount and
      context.inlineBrushes[index].state.number == number then return index end if
  return -1
end function

// SV_ClipMoveToEntities previously scanned every allocated edict for every
// Pmove trace. Maintain the tiny linked inline-brush set instead; retail maps
// typically reduce this hot loop from hundreds of entries to a few doors.
function updateInlineBrushCache(context, entity, linked)
  existing = inlineBrushCacheIndex(context, entity)
  modelName = ""
  if entity.state.modelIndex > 0 and entity.state.modelIndex < len(context.modelNames) then
    modelName = context.modelNames[entity.state.modelIndex]
  end if
  modelNumber = inlineModelNumber(modelName)
  eligible = linked and entity.inUse and entity.state.number > 0 and
    entity.solid == gc.SOLID_BSP and modelNumber >= 0
  if eligible then
    if existing < 0 then
      if context.inlineBrushCount >= len(context.inlineBrushes) then
        return error(3935, "inline brush cache overflow")
      end if
      context.inlineBrushes[context.inlineBrushCount] = entity
      context.inlineBrushModelNumbers[context.inlineBrushCount] = modelNumber
      context.inlineBrushPositions[entity.state.number] = context.inlineBrushCount + 1
      context.inlineBrushCount = context.inlineBrushCount + 1
    else
      context.inlineBrushes[existing] = entity
      context.inlineBrushModelNumbers[existing] = modelNumber
    end if
  else if existing >= 0 then
    last = context.inlineBrushCount - 1
    context.inlineBrushPositions[entity.state.number] = 0
    if existing != last then
      moved = context.inlineBrushes[last]
      context.inlineBrushes[existing] = moved
      context.inlineBrushModelNumbers[existing] = context.inlineBrushModelNumbers[last]
      context.inlineBrushPositions[moved.state.number] = existing + 1
    end if
    context.inlineBrushCount = last
  end if
  return true
end function

// Cache trigger index.
function triggerCacheIndex(context, entity)
  number = entity.state.number
  if number < 0 or number >= len(context.triggerPositions) then return -1 end if
  index = context.triggerPositions[number] - 1
  if index >= 0 and index < context.triggerCount and
      context.triggerEdicts[index].state.number == number then return index end if
  return -1
end function

// AREA_TRIGGERS is a linked spatial set in the original server. Keep an
// allocation-free indexed set here as well so each walking monster does not
// rescan every retail-map edict merely to touch nearby triggers.
function updateTriggerCache(context, entity, linked)
  existing = triggerCacheIndex(context, entity)
  eligible = linked and entity.inUse and entity.state.number > 0 and
    entity.solid == gc.SOLID_TRIGGER
  if eligible then
    if existing < 0 then
      if context.triggerCount >= len(context.triggerEdicts) then
        return error(3938, "trigger cache overflow")
      end if
      context.triggerEdicts[context.triggerCount] = entity
      context.triggerPositions[entity.state.number] = context.triggerCount + 1
      context.triggerCount = context.triggerCount + 1
    else
      context.triggerEdicts[existing] = entity
    end if
  else if existing >= 0 then
    last = context.triggerCount - 1
    context.triggerPositions[entity.state.number] = 0
    if existing != last then
      moved = context.triggerEdicts[last]
      context.triggerEdicts[existing] = moved
      context.triggerPositions[moved.state.number] = existing + 1
    end if
    context.triggerCount = last
  end if
  return true
end function

// Cache solid box index.
function solidBoxCacheIndex(context, entity)
  number = entity.state.number
  if number < 0 or number >= len(context.solidBoxPositions) then return -1 end if
  index = context.solidBoxPositions[number] - 1
  if index >= 0 and index < context.solidBoxCount and
      context.solidBoxEdicts[index].state.number == number then return index end if
  return -1
end function

// AREA_SOLID is a spatial linked list in BaseQ2. Keep the dynamic BBOX subset
// as an allocation-free indexed set so the authoritative PMove hot path visits
// only currently linked players, monsters and other box solids.
function updateSolidBoxCache(context, entity, linked)
  existing = solidBoxCacheIndex(context, entity)
  eligible = linked and entity.inUse and entity.state.number > 0 and
    entity.solid == gc.SOLID_BBOX
  if eligible then
    if existing < 0 then
      if context.solidBoxCount >= len(context.solidBoxEdicts) then
        return error(3939, "solid box cache overflow")
      end if
      context.solidBoxEdicts[context.solidBoxCount] = entity
      context.solidBoxPositions[entity.state.number] = context.solidBoxCount + 1
      context.solidBoxCount = context.solidBoxCount + 1
    else
      context.solidBoxEdicts[existing] = entity
    end if
  else if existing >= 0 then
    last = context.solidBoxCount - 1
    context.solidBoxPositions[entity.state.number] = 0
    if existing != last then
      moved = context.solidBoxEdicts[last]
      context.solidBoxEdicts[existing] = moved
      context.solidBoxPositions[moved.state.number] = existing + 1
    end if
    context.solidBoxCount = last
  end if
  return true
end function

// SV_LinkEdict records every distinct PVS cluster touched by the complete
// linked bounds, not merely the leaf containing s.origin.  Inline BSP origins
// commonly lie in solid or on the far side of an area boundary, so a point
// lookup makes doors, plats and buttons disappear even while their geometry is
// visible.  Fold cluster collection into the existing allocation-free BSP
// traversal.  MAX_ENT_CLUSTERS overflow retains Quake II's -1 sentinel; the
// per-client snapshot path then tests all leaves covered by the cached bounds.
function collectLinkedEntityVisibility(context, nodeNumber, mins, maxs, entity)
  // Keep collect linked entity visibility phases explicit: validate inputs, update owned state, then publish the result.
  if nodeNumber < 0 then
    sgbAreaLeafNumber = -1 - nodeNumber
    if sgbAreaLeafNumber < 0 or sgbAreaLeafNumber >= len(context.collision.map.leafs) then
      return error(3936, "linked entity leaf outside table")
    end if
    sgbAreaLeafHolder = context.collision.map.leafs[sgbAreaLeafNumber]
    sgbAreaNumber = sgbAreaLeafHolder.area
    if sgbAreaNumber != 0 then
      if entity.areaNumber == 0 then entity.areaNumber = sgbAreaNumber
      else if entity.areaNumber != sgbAreaNumber and entity.areaNumber2 == 0 then
        entity.areaNumber2 = sgbAreaNumber
      end if
    end if
    sgbVisibilityCluster = sgbAreaLeafHolder.cluster
    if sgbVisibilityCluster >= 0 and entity.numClusters >= 0 then
      sgbVisibilityDuplicate = false
      sgbVisibilityIndex = 0
      while sgbVisibilityIndex < entity.numClusters
        if entity.clusterNumbers[sgbVisibilityIndex] == sgbVisibilityCluster then
          sgbVisibilityDuplicate = true
        end if
        sgbVisibilityIndex = sgbVisibilityIndex + 1
      end while
      if sgbVisibilityDuplicate != true then
        if entity.numClusters >= gc.MAX_ENT_CLUSTERS then entity.numClusters = -1
        else
          entity.clusterNumbers[entity.numClusters] = sgbVisibilityCluster
          entity.numClusters = entity.numClusters + 1
        end if
      end if
    end if
    return true
  end if
  if nodeNumber >= len(context.collision.map.nodes) then
    return error(3937, "linked entity node outside table")
  end if
  sgbAreaNodeHolder = context.collision.map.nodes[nodeNumber]
  sgbAreaPlaneHolder = context.collision.map.planes[sgbAreaNodeHolder.planeIndex]
  sgbAreaSide = collision.boxOnPlaneSide(mins, maxs, sgbAreaPlaneHolder)
  if (sgbAreaSide & 1) != 0 then
    collectLinkedEntityVisibility(context, sgbAreaNodeHolder.child0, mins, maxs, entity)
  end if
  if (sgbAreaSide & 2) != 0 then
    collectLinkedEntityVisibility(context, sgbAreaNodeHolder.child1, mins, maxs, entity)
  end if
  return true
end function

// Link entity.
function linkEntity(entity)
  sgbLinkContextHolder = requireActive("linkentity")
  if typeof(entity) != "struct" then return error(3930, "transformed bounds require an Edict") end if
  sgbLinkStateProbe = try(entity.state)
  if sgbLinkStateProbe is error or typeof(sgbLinkStateProbe) != "struct" then
    return error(3931, "transformed bounds require an Edict state")
  end if
  sgbLinkEntityHolder = gt.stabilizeEdict(entity)
  if sgbLinkEntityHolder.linkCount == 0 then
    sgbFirstLinkOriginHolder = sgbLinkEntityHolder.state.origin
    sgbLinkEntityHolder.state.oldOrigin = qt.Vec3(sgbFirstLinkOriginHolder.x,
      sgbFirstLinkOriginHolder.y, sgbFirstLinkOriginHolder.z)
  end if
  sgbLinkEntityHolder.linkCount = sgbLinkEntityHolder.linkCount + 1
  sgbLinkMinsHolder = sgbLinkEntityHolder.mins
  sgbLinkMaxsHolder = sgbLinkEntityHolder.maxs
  sgbLinkAbsoluteMinsHolder = sgbLinkEntityHolder.absoluteMins
  sgbLinkAbsoluteMaxsHolder = sgbLinkEntityHolder.absoluteMaxs
  // Quake II rotates only SOLID_BSP bounds. BBOX monsters and ordinary
  // triggers use a direct origin-plus-extents path, avoiding sixteen managed
  // vector allocations on every successful AI step.
  if sgbLinkEntityHolder.solid == gc.SOLID_BSP then
    // Protocol 34 reserves 31 for inline BSP solidity; ordinary encoded BBOX
    // dimensions cannot produce this value (SV_LinkEdict).
    sgbLinkEntityHolder.state.solid = 31
    sgbLinkTransformedHolder = transformedEntityBounds(sgbLinkEntityHolder)
    sgbLinkAbsoluteMinsHolder = sgbLinkTransformedHolder[0]
    sgbLinkAbsoluteMaxsHolder = sgbLinkTransformedHolder[1]
    sgbLinkEntityHolder.absoluteMins = sgbLinkAbsoluteMinsHolder
    sgbLinkEntityHolder.absoluteMaxs = sgbLinkAbsoluteMaxsHolder
  else
    sgbLinkEntityHolder.state.solid = 0
    if sgbLinkEntityHolder.solid == gc.SOLID_BBOX and
        (sgbLinkEntityHolder.serverFlags & gc.SVF_DEADMONSTER) == 0 then
      // Protocol 34 packs horizontal radius, downward extent and upward
      // extent exactly as SV_LinkEdict; remote prediction decodes this value.
      sgbSolidHorizontal = sgbbyteio.truncInt(sgbLinkMaxsHolder.x / 8.0)
      if sgbSolidHorizontal < 1 then sgbSolidHorizontal = 1 end if
      if sgbSolidHorizontal > 31 then sgbSolidHorizontal = 31 end if
      sgbSolidDown = sgbbyteio.truncInt((-sgbLinkMinsHolder.z) / 8.0)
      if sgbSolidDown < 1 then sgbSolidDown = 1 end if
      if sgbSolidDown > 31 then sgbSolidDown = 31 end if
      sgbSolidUp = sgbbyteio.truncInt((sgbLinkMaxsHolder.z + 32.0) / 8.0)
      if sgbSolidUp < 1 then sgbSolidUp = 1 end if
      if sgbSolidUp > 63 then sgbSolidUp = 63 end if
      sgbLinkEntityHolder.state.solid = (sgbSolidUp << 10) |
        (sgbSolidDown << 5) | sgbSolidHorizontal
    end if
    sgbLinkOriginHolder = sgbLinkEntityHolder.state.origin
    sgbLinkAbsoluteMinsHolder.x = sgbLinkOriginHolder.x + sgbLinkMinsHolder.x - 1.0
    sgbLinkAbsoluteMinsHolder.y = sgbLinkOriginHolder.y + sgbLinkMinsHolder.y - 1.0
    sgbLinkAbsoluteMinsHolder.z = sgbLinkOriginHolder.z + sgbLinkMinsHolder.z - 1.0
    sgbLinkAbsoluteMaxsHolder.x = sgbLinkOriginHolder.x + sgbLinkMaxsHolder.x + 1.0
    sgbLinkAbsoluteMaxsHolder.y = sgbLinkOriginHolder.y + sgbLinkMaxsHolder.y + 1.0
    sgbLinkAbsoluteMaxsHolder.z = sgbLinkOriginHolder.z + sgbLinkMaxsHolder.z + 1.0
  end if
  sgbLinkSizeHolder = sgbLinkEntityHolder.size
  sgbLinkSizeHolder.x = sgbLinkMaxsHolder.x - sgbLinkMinsHolder.x
  sgbLinkSizeHolder.y = sgbLinkMaxsHolder.y - sgbLinkMinsHolder.y
  sgbLinkSizeHolder.z = sgbLinkMaxsHolder.z - sgbLinkMinsHolder.z
  // SV_LinkEdict publishes the BSP areas occupied by the entity. Monster
  // hearing and snapshot visibility use these fields to respect closed area
  // portals. It also caches the PVS clusters touched by the full bounds.
  sgbLinkEntityHolder.numClusters = 0
  sgbLinkEntityHolder.areaNumber = 0
  sgbLinkEntityHolder.areaNumber2 = 0
  if sgbLinkContextHolder.collision is not void then
    collectLinkedEntityVisibility(sgbLinkContextHolder, 0, sgbLinkAbsoluteMinsHolder,
      sgbLinkAbsoluteMaxsHolder, sgbLinkEntityHolder)
  end if
  updateInlineBrushCache(sgbLinkContextHolder, sgbLinkEntityHolder, true)
  updateTriggerCache(sgbLinkContextHolder, sgbLinkEntityHolder, true)
  updateSolidBoxCache(sgbLinkContextHolder, sgbLinkEntityHolder, true)
  return true
end function

// Return the unlink entity value.
function unlinkEntity(entity)
  context = requireActive("unlinkentity")
  updateInlineBrushCache(context, entity, false)
  updateTriggerCache(context, entity, false)
  updateSolidBoxCache(context, entity, false)
  entity.area.previous = void
  entity.area.next = void
  return true
end function

// Return the box edicts value.
function boxEdicts(mins, maxs, areaType)
  context = requireActive("BoxEdicts")
  if context.game is void then return [] end if
  result = array(gc.MAXTOUCH)
  resultCount = 0
  index = 0
  candidateCount = context.game.numEdicts
  if areaType == 2 then candidateCount = context.triggerCount end if
  while index < candidateCount and resultCount < gc.MAXTOUCH
    entity = void
    if areaType == 2 then entity = context.triggerEdicts[index]
    else entity = context.game.edicts[index]
    end if
    include = entity.inUse and entity.solid != gc.SOLID_NOT and entity.linkCount > 0
    // BaseQ2 AREA_SOLID is 1 and AREA_TRIGGERS is 2.
    if areaType == 1 and entity.solid == gc.SOLID_TRIGGER then include = false end if
    if include then
      entityMinX = entity.absoluteMins.x
      entityMinY = entity.absoluteMins.y
      entityMinZ = entity.absoluteMins.z
      entityMaxX = entity.absoluteMaxs.x
      entityMaxY = entity.absoluteMaxs.y
      entityMaxZ = entity.absoluteMaxs.z
      overlap = entityMaxX >= mins.x and entityMinX <= maxs.x and entityMaxY >= mins.y and entityMinY <= maxs.y and entityMaxZ >= mins.z and entityMinZ <= maxs.z
      if overlap then result[resultCount] = entity; resultCount = resultCount + 1 end if
    end if
    index = index + 1
  end while
  if resultCount == 0 then return [] end if
  if resultCount == len(result) then return result end if
  output = array(resultCount)
  index = 0
  while index < resultCount
    output[index] = result[index]
    index = index + 1
  end while
  return output
end function

// Return the pmove value.
function pmove(value)
  return phmove.move(value)
end function

// Return the multicast value.
function multicast(origin, destination)
  context = requireActive("multicast")
  payload = sizebuf.dataSlice(context.multicastBuffer)
  sgmessages.enqueue(context, origin, destination, payload)
  appendLog("multicast:" + destination, payload)
  sizebuf.clear(context.multicastBuffer)
  return true
end function

// Return the unicast value.
function unicast(entity, reliable)
  context = requireActive("unicast")
  payload = sizebuf.dataSlice(context.multicastBuffer)
  sgmessages.enqueueUnicast(context, entity, reliable, payload)
  appendLog("unicast", payload)
  sizebuf.clear(context.multicastBuffer)
  return true
end function

// Write char.
function writeChar(value)
  return message.writeChar(requireActive("WriteChar").multicastBuffer, value)
end function

// Write byte.
function writeByte(value)
  return message.writeByte(requireActive("WriteByte").multicastBuffer, value)
end function

// Write short.
function writeShort(value)
  return message.writeShort(requireActive("WriteShort").multicastBuffer, value)
end function

// Write long.
function writeLong(value)
  return message.writeLong(requireActive("WriteLong").multicastBuffer, value)
end function

// Write float.
function writeFloat(value)
  return message.writeFloat(requireActive("WriteFloat").multicastBuffer, value)
end function

// Write string.
function writeString(value)
  return message.writeString(requireActive("WriteString").multicastBuffer, value)
end function

// Write position.
function writePosition(value)
  return message.writePos(requireActive("WritePosition").multicastBuffer, value)
end function

// Write direction.
function writeDirection(value)
  return qdir.writeDirection(requireActive("WriteDir").multicastBuffer, value)
end function

// Write angle.
function writeAngle(value)
  return message.writeAngle(requireActive("WriteAngle").multicastBuffer, value)
end function

// Return the tag malloc value.
function tagMalloc(size, tag)
  if size < 0 then return error(3907, "negative TagMalloc size") end if
  return bytes(size)
end function

// Release tag.
function tagFree(value)
  return true
end function

// Release tags.
function freeTags(tag)
  return true
end function

// Return the game cvar value.
function gameCvar(name, value, flags)
  return cvars.get(requireActive("cvar").cvars, name, value, flags)
end function

// Set game cvar.
function gameCvarSet(name, value)
  return cvars.set(requireActive("cvar_set").cvars, name, value)
end function

// Set game cvar force.
function gameCvarForceSet(name, value)
  return cvars.forceSet(requireActive("cvar_forceset").cvars, name, value)
end function

// Return the argc value.
function argc()
  return len(requireActive("argc").commands.arguments)
end function

// Return the argv value.
function argv(index)
  context = requireActive("argv")
  if index < 0 or index >= len(context.commands.arguments) then return "" end if
  return context.commands.arguments[index]
end function

// Return the args value.
function args()
  return requireActive("args").commands.argumentTail
end function

// Add command string.
function addCommandString(value)
  return commands.addText(requireActive("AddCommandString").commands, value)
end function

// Return the debug graph value.
function debugGraph(value, color)
  return true
end function

// Create runtime.
function createRuntime(maxClients)
  if maxClients <= 0 or maxClients > qc.MAX_CLIENTS then return error(3908, "maxclients outside range") end if
  registry = cvars.createRegistry()
  commandSystem = commands.create(registry)
  clients = array(maxClients)
  i = 0
  while i < maxClients
    clients[i] = st.ClientSlot(0, "", "", 0, 0, 0, void)
    i = i + 1
  end while
  pendingSoundStorage = array(ssoundevents.MAX_PENDING_SOUND_EVENTS, void)
  return st.ServerRuntime(0, "", 0, 0, 0, maxClients, clients,
    array(qc.MAX_CONFIGSTRINGS, ""), array(qc.MAX_CONFIGSTRINGS, false),
    array(qc.MAX_MODELS, ""), array(qc.MAX_SOUNDS, ""), array(qc.MAX_IMAGES, ""),
    sizebuf.alloc(qc.MAX_MSGLEN), [], 0, [], 0, pendingSoundStorage, 0, 0,
    [], registry, commandSystem, void, void,
    array(qc.MAX_EDICTS, void), 0, array(qc.MAX_EDICTS, 0),
    array(qc.MAX_EDICTS, -1),
    array(qc.MAX_EDICTS, void), array(qc.MAX_EDICTS, 0), 0,
    array(qc.MAX_EDICTS, void), array(qc.MAX_EDICTS, 0), 0)
end function

// Create imports.
function makeImports(context)
  activateRuntime(context)
  return gt.GameImport(
    bprintf, dprintf, cprintf, centerprintf,
    sound, positionedSound, configString, fail,
    bridgeModelIndex, bridgeSoundIndex, bridgeImageIndex, setModel,
    trace, pointContents, inPVS, inPHS,
    setAreaPortalState, areasConnected, linkEntity, unlinkEntity, boxEdicts, pmove,
    multicast, unicast,
    writeChar, writeByte, writeShort, writeLong, writeFloat, writeString, writePosition, writeDirection, writeAngle,
    tagMalloc, tagFree, freeTags,
    gameCvar, gameCvarSet, gameCvarForceSet,
    argc, argv, args, addCommandString, debugGraph, collisionWorldReady,
  )
end function
