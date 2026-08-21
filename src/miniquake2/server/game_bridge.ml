/* MiniLang implementation of the engine side of game_import_t. */
package miniquake2.server.game_bridge

import miniquake2.qcommon.constants as qc
import miniquake2.qcommon.types as qt
import miniquake2.qcommon.sizebuf as sizebuf
import miniquake2.qcommon.message as message
import miniquake2.qcommon.directions as qdir
import miniquake2.qcommon.cvar as cvars
import miniquake2.qcommon.cmd as commands
import miniquake2.game.types as gt
import miniquake2.game.constants as gc
import miniquake2.collision.model as collision
import miniquake2.format.bsp as bsp
import miniquake2.format.constants as sgbformatconstants
import miniquake2.format.binary as sgbformatbinary
import miniquake2.server.types as st
import miniquake2.server.sound_events as ssoundevents
import miniquake2.server.game_messages as sgmessages
import miniquake2.physics.pmove as phmove
import miniquake2.physics.vector as sgbvector

gameBridgeActiveRuntime = void
const MAX_GAME_BRIDGE_LOGS = 1024

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

function requireActive(operation)
  global gameBridgeActiveRuntime
  if gameBridgeActiveRuntime is void then return error(3900, operation + ": server bridge is not installed") end if
  return gameBridgeActiveRuntime
end function

function appendLog(level, value)
  context = requireActive("print")
  return gameBridgeAppendLog(context, [level, value])
end function

function bprintf(value)
  return appendLog("broadcast", value)
end function

function dprintf(value)
  return appendLog("debug", value)
end function

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

function sound(entity, channel, soundIndex, volume, attenuation, timeOffset)
  context = requireActive("sound")
  event = ssoundevents.enqueue(context, void, entity, channel, soundIndex, volume, attenuation, timeOffset)
  gameBridgeAppendLog(context, ["sound", soundIndex])
  return event
end function

function positionedSound(origin, entity, channel, soundIndex, volume, attenuation, timeOffset)
  context = requireActive("positioned-sound")
  event = ssoundevents.enqueue(context, origin, entity, channel, soundIndex, volume, attenuation, timeOffset)
  gameBridgeAppendLog(context, ["positioned-sound", soundIndex])
  return event
end function

function configString(index, value)
  context = requireActive("configstring")
  if index < 0 or index >= len(context.configStrings) then return error(3901, "configstring index outside table") end if
  context.configStrings[index] = value
  return true
end function

function fail(value)
  return error(3902, value)
end function

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

function bridgeModelIndex(name)
  context = requireActive("modelindex")
  index = findIndex(context.modelNames, name, true)
  if index > 0 then context.configStrings[qc.CS_MODELS + index] = name end if
  return index
end function

function bridgeSoundIndex(name)
  context = requireActive("soundindex")
  index = findIndex(context.soundNames, name, true)
  if index > 0 then context.configStrings[qc.CS_SOUNDS + index] = name end if
  return index
end function

function bridgeImageIndex(name)
  context = requireActive("imageindex")
  index = findIndex(context.imageNames, name, true)
  if index > 0 then context.configStrings[qc.CS_IMAGES + index] = name end if
  return index
end function

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

function adaptCollisionTrace(context, result)
  hitEntity = void
  if (result.fraction < 1.0 or result.startSolid or result.allSolid) and context.game is not void and context.game.numEdicts > 0 then
    hitEntity = context.game.edicts[0]
  end if
  return adaptCollisionTraceWithEntity(context, result, hitEntity)
end function

function traceDot(first, second)
  return first.x * second.x + first.y * second.y + first.z * second.z
end function

function traceToModel(point, origin, basis)
  relative = qt.Vec3(point.x - origin.x, point.y - origin.y, point.z - origin.z)
  return qt.Vec3(traceDot(relative, basis[0]), -traceDot(relative, basis[1]), traceDot(relative, basis[2]))
end function

function traceNormalToWorld(normal, basis)
  return qt.Vec3(
    basis[0].x * normal.x - basis[1].x * normal.y + basis[2].x * normal.z,
    basis[0].y * normal.x - basis[1].y * normal.y + basis[2].y * normal.z,
    basis[0].z * normal.x - basis[1].z * normal.y + basis[2].z * normal.z
  )
end function

function sameTraceEntity(first, second)
  if first is void or second is void then return false end if
  return first.state.number == second.state.number
end function

function trace(start, mins, maxs, finish, passEntity, contentMask)
  context = requireActive("trace")
  if context.collision is void then
    plane = qt.Plane(qt.zeroVec3(), 0.0, 0, 0)
    surface = qt.CollisionSurface("", 0, 0)
    return qt.Trace(false, false, 1.0, finish, plane, surface, 0, void)
  end if
  worldEntity = void
  if context.game is not void and context.game.numEdicts > 0 then worldEntity = context.game.edicts[0] end if
  worldResult = collision.boxTrace(context.collision, start, finish, mins, maxs, 0, contentMask)
  worldHit = void
  if worldResult.fraction < 1.0 or worldResult.startSolid or worldResult.allSolid then worldHit = worldEntity end if
  best = adaptCollisionTraceWithEntity(context, worldResult, worldHit)

  // SV_ClipMoveToEntities: inline BSP edicts have their own hull headnode and
  // are traced in model-local coordinates.  This is the physical collision
  // boundary needed by doors, plats, walls and rotating brushes.
  if context.game is not void then
    index = 1
    while index < context.game.numEdicts
      entity = context.game.edicts[index]
      eligible = entity.inUse and entity.solid == gc.SOLID_BSP and sameTraceEntity(entity, passEntity) != true
      modelName = ""
      if entity.state.modelIndex > 0 and entity.state.modelIndex < len(context.modelNames) then modelName = context.modelNames[entity.state.modelIndex] end if
      inlineNumber = inlineModelNumber(modelName)
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
  return best
end function

function pointContents(point)
  context = requireActive("pointcontents")
  if context.collision is void then return 0 end if
  contents = collision.pointContents(context.collision, point, 0)
  if context.game is not void then
    index = 1
    while index < context.game.numEdicts
      entity = context.game.edicts[index]
      modelName = ""
      if entity.state.modelIndex > 0 and entity.state.modelIndex < len(context.modelNames) then modelName = context.modelNames[entity.state.modelIndex] end if
      inlineNumber = inlineModelNumber(modelName)
      if entity.inUse and entity.solid == gc.SOLID_BSP and inlineNumber >= 0 and inlineNumber < len(context.collision.map.models) then
        basis = sgbvector.angleVectors(entity.state.angles)
        localPoint = traceToModel(point, entity.state.origin, basis)
        contents = contents | collision.pointContents(context.collision, localPoint, entity.headNode)
      end if
      index = index + 1
    end while
  end if
  return contents
end function

function inPVS(first, second)
  context = requireActive("inPVS")
  if context.collision is void then return true end if
  firstLeaf = collision.pointLeafNumber(context.collision, first, 0)
  secondLeaf = collision.pointLeafNumber(context.collision, second, 0)
  firstCluster = context.collision.map.leafs[firstLeaf].cluster
  secondCluster = context.collision.map.leafs[secondLeaf].cluster
  if firstCluster < 0 or secondCluster < 0 then return false end if
  row = bsp.decompressVisibility(context.collision.map.visibility, firstCluster, 0)
  visible = (row[secondCluster >> 3] & (1 << (secondCluster & 7))) != 0
  return visible and collision.areasConnected(context.collision, context.collision.map.leafs[firstLeaf].area, context.collision.map.leafs[secondLeaf].area)
end function

function inPHS(first, second)
  context = requireActive("inPHS")
  if context.collision is void then return true end if
  firstLeaf = collision.pointLeafNumber(context.collision, first, 0)
  secondLeaf = collision.pointLeafNumber(context.collision, second, 0)
  firstCluster = context.collision.map.leafs[firstLeaf].cluster
  secondCluster = context.collision.map.leafs[secondLeaf].cluster
  if firstCluster < 0 or secondCluster < 0 then return false end if
  row = bsp.decompressVisibility(context.collision.map.visibility, firstCluster, 1)
  return (row[secondCluster >> 3] & (1 << (secondCluster & 7))) != 0
end function

function setAreaPortalState(portalNumber, isOpen)
  context = requireActive("SetAreaPortalState")
  if context.collision is void then return error(3904, "no collision map loaded") end if
  return collision.setAreaPortalState(context.collision, portalNumber, isOpen)
end function

function areasConnected(first, second)
  context = requireActive("AreasConnected")
  if context.collision is void then return true end if
  return collision.areasConnected(context.collision, first, second)
end function

function transformedEntityBounds(entity)
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

function linkEntity(entity)
  sgbLinkEntityHolder = entity
  sgbLinkEntityHolder.linkCount = sgbLinkEntityHolder.linkCount + 1
  sgbLinkTransformedHolder = transformedEntityBounds(sgbLinkEntityHolder)
  sgbLinkAbsoluteMinsHolder = sgbLinkTransformedHolder[0]
  sgbLinkAbsoluteMaxsHolder = sgbLinkTransformedHolder[1]
  sgbLinkMinsHolder = sgbLinkEntityHolder.mins
  sgbLinkMaxsHolder = sgbLinkEntityHolder.maxs
  sgbLinkSizeHolder = qt.Vec3(sgbLinkMaxsHolder.x - sgbLinkMinsHolder.x,
    sgbLinkMaxsHolder.y - sgbLinkMinsHolder.y, sgbLinkMaxsHolder.z - sgbLinkMinsHolder.z)
  sgbLinkEntityHolder.absoluteMins = sgbLinkAbsoluteMinsHolder
  sgbLinkEntityHolder.absoluteMaxs = sgbLinkAbsoluteMaxsHolder
  sgbLinkEntityHolder.size = sgbLinkSizeHolder
  gt.stabilizeEdict(sgbLinkEntityHolder)
  return true
end function

function unlinkEntity(entity)
  entity.area.previous = void
  entity.area.next = void
  return true
end function

function boxEdicts(mins, maxs, areaType)
  context = requireActive("BoxEdicts")
  if context.game is void then return [] end if
  result = []
  index = 0
  while index < context.game.numEdicts and len(result) < gc.MAXTOUCH
    entity = context.game.edicts[index]
    include = entity.inUse and entity.solid != gc.SOLID_NOT
    // BaseQ2 AREA_SOLID is 1 and AREA_TRIGGERS is 2.
    if areaType == 1 and entity.solid == gc.SOLID_TRIGGER then include = false end if
    if areaType == 2 and entity.solid != gc.SOLID_TRIGGER then include = false end if
    if include then
      bounds = transformedEntityBounds(entity)
      entityMinX = bounds[0].x
      entityMinY = bounds[0].y
      entityMinZ = bounds[0].z
      entityMaxX = bounds[1].x
      entityMaxY = bounds[1].y
      entityMaxZ = bounds[1].z
      overlap = entityMaxX >= mins.x and entityMinX <= maxs.x and entityMaxY >= mins.y and entityMinY <= maxs.y and entityMaxZ >= mins.z and entityMinZ <= maxs.z
      if overlap then result = result + [entity] end if
    end if
    index = index + 1
  end while
  return result
end function

function pmove(value)
  return phmove.move(value)
end function

function multicast(origin, destination)
  context = requireActive("multicast")
  payload = sizebuf.dataSlice(context.multicastBuffer)
  sgmessages.enqueue(context, origin, destination, payload)
  appendLog("multicast:" + destination, payload)
  sizebuf.clear(context.multicastBuffer)
  return true
end function

function unicast(entity, reliable)
  context = requireActive("unicast")
  payload = sizebuf.dataSlice(context.multicastBuffer)
  sgmessages.enqueueUnicast(context, entity, reliable, payload)
  appendLog("unicast", payload)
  sizebuf.clear(context.multicastBuffer)
  return true
end function

function writeChar(value)
  return message.writeChar(requireActive("WriteChar").multicastBuffer, value)
end function

function writeByte(value)
  return message.writeByte(requireActive("WriteByte").multicastBuffer, value)
end function

function writeShort(value)
  return message.writeShort(requireActive("WriteShort").multicastBuffer, value)
end function

function writeLong(value)
  return message.writeLong(requireActive("WriteLong").multicastBuffer, value)
end function

function writeFloat(value)
  return message.writeFloat(requireActive("WriteFloat").multicastBuffer, value)
end function

function writeString(value)
  return message.writeString(requireActive("WriteString").multicastBuffer, value)
end function

function writePosition(value)
  return message.writePos(requireActive("WritePosition").multicastBuffer, value)
end function

function writeDirection(value)
  return qdir.writeDirection(requireActive("WriteDir").multicastBuffer, value)
end function

function writeAngle(value)
  return message.writeAngle(requireActive("WriteAngle").multicastBuffer, value)
end function

function tagMalloc(size, tag)
  if size < 0 then return error(3907, "negative TagMalloc size") end if
  return bytes(size)
end function

function tagFree(value)
  return true
end function

function freeTags(tag)
  return true
end function

function gameCvar(name, value, flags)
  return cvars.get(requireActive("cvar").cvars, name, value, flags)
end function

function gameCvarSet(name, value)
  return cvars.set(requireActive("cvar_set").cvars, name, value)
end function

function gameCvarForceSet(name, value)
  return cvars.forceSet(requireActive("cvar_forceset").cvars, name, value)
end function

function argc()
  return len(requireActive("argc").commands.arguments)
end function

function argv(index)
  context = requireActive("argv")
  if index < 0 or index >= len(context.commands.arguments) then return "" end if
  return context.commands.arguments[index]
end function

function args()
  return requireActive("args").commands.argumentTail
end function

function addCommandString(value)
  return commands.addText(requireActive("AddCommandString").commands, value)
end function

function debugGraph(value, color)
  return true
end function

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
  return st.ServerRuntime(0, "", 0, 0, 0, maxClients, clients, array(qc.MAX_CONFIGSTRINGS, ""), array(qc.MAX_MODELS, ""), array(qc.MAX_SOUNDS, ""), array(qc.MAX_IMAGES, ""), sizebuf.alloc(qc.MAX_MSGLEN), [], 0, [], 0, [], 0, [], registry, commandSystem, void, void)
end function

function makeImports(context)
  global gameBridgeActiveRuntime
  gameBridgeActiveRuntime = context
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
    argc, argv, args, addCommandString, debugGraph,
  )
end function
