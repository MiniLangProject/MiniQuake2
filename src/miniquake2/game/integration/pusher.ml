/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Transactional BaseQ2 pusher/rider physics across managed gameplay records. */
package miniquake2.game.integration.pusher

import miniquake2.qcommon.types as pushqtypes
import miniquake2.qcommon.constants as pushqconstants
import miniquake2.game.world.types as pushworldtypes
import miniquake2.game.world.core as pushworldcore
import miniquake2.game.world.constants as pushworldconstants
import miniquake2.game.weapons.vector as pushvector

struct PusherSnapshot
  entity
  origin
  angles
end struct

struct BodySnapshot
  kind
  value
  edict
  number
  origin
  angles
  mins
  maxs
  solid
  groundNumber
end struct

struct PusherCapture
  pushers
  bodies
end struct

function pushCopy(value)
  if typeof(value) != "struct" then return error(9694, "pusher Vec3 value required") end if
  return pushqtypes.Vec3(value.x, value.y, value.z)
end function

function isPusher(entity)
  return entity.number > 0 and entity.inUse and entity.solid == pushworldconstants.SOLID_BSP and
    (entity.moveType == pushworldconstants.MOVETYPE_PUSH or entity.moveType == pushworldconstants.MOVETYPE_STOP) and
    entity.maxs.x > entity.mins.x and entity.maxs.y > entity.mins.y and entity.maxs.z > entity.mins.z
end function

function pusherMasterNumber(entity)
  if entity.teamMaster is not void then return entity.teamMaster.number end if
  return entity.number
end function

function assembleTeams(world)
  for each entity in world.entities
    if entity.team != "" then entity.teamMaster = void; entity.teamChain = void; entity.flags = entity.flags & ~pushworldconstants.FL_TEAMSLAVE end if
  end for
  for each entity in world.entities
    if entity.inUse and entity.team != "" then
      master = void
      for each candidate in world.entities
        if candidate.number == entity.number then break end if
        if candidate.inUse and candidate.team == entity.team then master = candidate.teamMaster; if master is void then master = candidate end if; break end if
      end for
      if master is void then entity.teamMaster = entity
      else
        entity.teamMaster = master
        entity.flags = entity.flags | pushworldconstants.FL_TEAMSLAVE
        tail = master
        while tail.teamChain is not void
          tail = tail.teamChain
        end while
        tail.teamChain = entity
      end if
    end if
  end for
  return true
end function

function worldBody(entity)
  bodyOrigin = pushCopy(entity.origin)
  bodyAngles = pushCopy(entity.angles)
  bodyMins = pushCopy(entity.mins)
  bodyMaxs = pushCopy(entity.maxs)
  return BodySnapshot("world", entity, void, entity.number, bodyOrigin, bodyAngles,
    bodyMins, bodyMaxs, entity.solid, -1)
end function

function playerBody(player)
  playerEdict = player.edict
  playerState = playerEdict.state
  groundNumber = -1
  if player.groundEntity is not void then groundNumber = player.groundEntity.state.number end if
  bodyOrigin = pushCopy(playerState.origin)
  bodyAngles = pushCopy(playerState.angles)
  bodyMins = pushCopy(playerEdict.mins)
  bodyMaxs = pushCopy(playerEdict.maxs)
  return BodySnapshot("player", player, playerEdict, playerState.number, bodyOrigin, bodyAngles,
    bodyMins, bodyMaxs, playerEdict.solid, groundNumber)
end function

function monsterBody(actor)
  monsterEdict = actor.edict
  monsterState = monsterEdict.state
  bodyOrigin = pushCopy(monsterState.origin)
  bodyAngles = pushCopy(monsterState.angles)
  bodyMins = pushCopy(monsterEdict.mins)
  bodyMaxs = pushCopy(monsterEdict.maxs)
  return BodySnapshot("monster", actor, monsterEdict, monsterState.number, bodyOrigin, bodyAngles,
    bodyMins, bodyMaxs, monsterEdict.solid, -1)
end function

function capture(runtime)
  pushers = []
  bodies = []
  for each entity in runtime.world.entities
    if isPusher(entity) then
      pusherOrigin = pushCopy(entity.origin)
      pusherAngles = pushCopy(entity.angles)
      pusherSnapshot = PusherSnapshot(entity, pusherOrigin, pusherAngles)
      pushers = pushers + [pusherSnapshot]
    end if
    if entity.number > 0 and entity.inUse and entity.solid != pushworldconstants.SOLID_NOT and entity.solid != pushworldconstants.SOLID_TRIGGER then
      worldSnapshot = worldBody(entity)
      bodies = bodies + [worldSnapshot]
    end if
  end for
  if runtime.playerContext is not void then
    for each player in runtime.playerContext.players
      if player.edict.inUse and player.edict.solid != pushworldconstants.SOLID_NOT then
        playerSnapshot = playerBody(player)
        bodies = bodies + [playerSnapshot]
      end if
    end for
  end if
  for each actor in runtime.monsters
    if actor.edict.inUse and actor.edict.solid != pushworldconstants.SOLID_NOT then
      monsterSnapshot = monsterBody(actor)
      bodies = bodies + [monsterSnapshot]
    end if
  end for
  return PusherCapture(pushers, bodies)
end function

function moved(snapshot)
  entity = snapshot.entity
  return entity.origin.x != snapshot.origin.x or entity.origin.y != snapshot.origin.y or entity.origin.z != snapshot.origin.z or
    entity.angles.x != snapshot.angles.x or entity.angles.y != snapshot.angles.y or entity.angles.z != snapshot.angles.z
end function

function rotatedBounds(origin, angles, mins, maxs)
  if typeof(origin) != "struct" or typeof(angles) != "struct" or
      typeof(mins) != "struct" or typeof(maxs) != "struct" then
    return error(9695, "rotatedBounds requires Vec3-shaped inputs")
  end if
  boundsOrigin = origin
  boundsAngles = angles
  boundsMins = mins
  boundsMaxs = maxs
  basis = pushvector.angleVectors(boundsAngles)
  forward = basis[0]
  right = basis[1]
  up = basis[2]
  if typeof(forward) != "struct" or typeof(right) != "struct" or typeof(up) != "struct" then
    return error(9696, "rotatedBounds produced a malformed angle basis")
  end if
  low = pushqtypes.Vec3(999999999.0, 999999999.0, 999999999.0)
  high = pushqtypes.Vec3(-999999999.0, -999999999.0, -999999999.0)
  index = 0
  while index < 8
    x = boundsMins.x; y = boundsMins.y; z = boundsMins.z
    if (index & 1) != 0 then x = boundsMaxs.x end if
    if (index & 2) != 0 then y = boundsMaxs.y end if
    if (index & 4) != 0 then z = boundsMaxs.z end if
    rotatedX = forward.x * x - right.x * y + up.x * z
    rotatedY = forward.y * x - right.y * y + up.y * z
    rotatedZ = forward.z * x - right.z * y + up.z * z
    wx = boundsOrigin.x + rotatedX; wy = boundsOrigin.y + rotatedY; wz = boundsOrigin.z + rotatedZ
    if wx < low.x then low.x = wx end if; if wy < low.y then low.y = wy end if; if wz < low.z then low.z = wz end if
    if wx > high.x then high.x = wx end if; if wy > high.y then high.y = wy end if; if wz > high.z then high.z = wz end if
    index = index + 1
  end while
  return [low, high]
end function

function currentOrigin(body)
  if body.kind == "world" then return body.value.origin end if
  return body.edict.state.origin
end function

function currentAngles(body)
  if body.kind == "world" then return body.value.angles end if
  return body.edict.state.angles
end function

function bodyBoundsAt(body, origin, angles)
  return rotatedBounds(origin, angles, body.mins, body.maxs)
end function

function strictOverlap(first, second)
  return first[1].x > second[0].x and first[0].x < second[1].x and first[1].y > second[0].y and first[0].y < second[1].y and first[1].z > second[0].z and first[0].z < second[1].z
end function

function standingOn(body, pusherSnapshot)
  if body.groundNumber == pusherSnapshot.entity.number then return true end if
  pusherBox = rotatedBounds(pusherSnapshot.origin, pusherSnapshot.angles, pusherSnapshot.entity.mins, pusherSnapshot.entity.maxs)
  bodyBox = bodyBoundsAt(body, body.origin, body.angles)
  gap = bodyBox[0].z - pusherBox[1].z
  return gap >= -0.25 and gap <= 2.0 and bodyBox[1].x > pusherBox[0].x and bodyBox[0].x < pusherBox[1].x and bodyBox[1].y > pusherBox[0].y and bodyBox[0].y < pusherBox[1].y
end function

function setBody(body, origin, angles)
  newOrigin = pushCopy(origin)
  newAngles = pushCopy(angles)
  if body.kind == "world" then body.value.origin = newOrigin; body.value.angles = newAngles
  else body.edict.state.origin = newOrigin; body.edict.state.angles = newAngles
  end if
  return true
end function

function carryOrigin(body, pusherSnapshot)
  bodyOrigin = pushCopy(body.origin)
  previousPusherOrigin = pushCopy(pusherSnapshot.origin)
  currentPusherOrigin = pushCopy(pusherSnapshot.entity.origin)
  currentPusherAngles = pushCopy(pusherSnapshot.entity.angles)
  previousPusherAngles = pushCopy(pusherSnapshot.angles)
  relative = pushvector.subtract(bodyOrigin, previousPusherOrigin)
  deltaAngles = pushvector.subtract(currentPusherAngles, previousPusherAngles)
  basis = pushvector.angleVectors(deltaAngles)
  forward = basis[0]
  right = basis[1]
  up = basis[2]
  rotated = pushqtypes.Vec3(
    forward.x * relative.x - right.x * relative.y + up.x * relative.z,
    forward.y * relative.x - right.y * relative.y + up.y * relative.z,
    forward.z * relative.x - right.z * relative.y + up.z * relative.z
  )
  return pushvector.add(currentPusherOrigin, rotated)
end function

function teamHas(team, number)
  for each snapshot in team
    if snapshot.entity.number == number then return true end if
  end for
  return false
end function

function proxyFor(body)
  if body.kind == "world" then return body.value end if
  proxy = pushworldtypes.createEntity(body.number, body.kind)
  bodyOrigin = currentOrigin(body)
  bodyAngles = currentAngles(body)
  proxyOrigin = pushCopy(bodyOrigin)
  proxyAngles = pushCopy(bodyAngles)
  proxyMins = pushCopy(body.mins)
  proxyMaxs = pushCopy(body.maxs)
  proxy.origin = proxyOrigin
  proxy.angles = proxyAngles
  proxy.mins = proxyMins
  proxy.maxs = proxyMaxs
  if body.kind == "player" then proxy.isClient = true; proxy.health = body.value.health end if
  if body.kind == "monster" then proxy.serverFlags = proxy.serverFlags | pushworldconstants.SVF_MONSTER; proxy.health = body.value.health; proxy.mass = body.value.mass end if
  return proxy
end function

function resolveTeam(runtime, captureState, masterNumber)
  team = []
  anyMoved = false
  for each snapshot in captureState.pushers
    if pusherMasterNumber(snapshot.entity) == masterNumber then team = team + [snapshot]; if moved(snapshot) then anyMoved = true end if end if
  end for
  if anyMoved == false then return false end if

  blocker = void
  blockedPusher = void
  for each body in captureState.bodies
    if teamHas(team, body.number) == false then
      rider = void
      for each pusherSnapshot in team
        if standingOn(body, pusherSnapshot) then rider = pusherSnapshot; break end if
      end for
      if rider is not void then
        destination = carryOrigin(body, rider)
        destinationAngles = pushCopy(body.angles)
        if body.kind != "player" then
          riderAngleDelta = pushvector.subtract(rider.entity.angles, rider.angles)
          destinationAngles = pushvector.add(body.angles, riderAngleDelta)
        end if
        if runtime.playerContext is not void and runtime.exportTable is not void then
          passEntity = runtime.exportTable.edicts[rider.entity.number]
          trace = runtime.playerContext.imports.trace(body.origin, body.mins, body.maxs, destination, passEntity, pushqconstants.MASK_PLAYERSOLID)
          if trace.fraction < 1.0 or trace.startSolid or trace.allSolid then blocker = body; blockedPusher = rider.entity
          else destination = trace.endPosition
          end if
        end if
        if blocker is void then setBody(body, destination, destinationAngles) end if
      end if
      if blocker is void then
        liveBodyOrigin = currentOrigin(body)
        liveBodyAngles = currentAngles(body)
        bodyBox = bodyBoundsAt(body, liveBodyOrigin, liveBodyAngles)
        for each pusherSnapshot in team
          pusherBox = rotatedBounds(pusherSnapshot.entity.origin, pusherSnapshot.entity.angles, pusherSnapshot.entity.mins, pusherSnapshot.entity.maxs)
          if strictOverlap(bodyBox, pusherBox) then blocker = body; blockedPusher = pusherSnapshot.entity; break end if
        end for
      end if
    end if
    if blocker is not void then break end if
  end for
  if blocker is void then return true end if

  for each snapshot in team
    restoredOrigin = pushCopy(snapshot.origin)
    restoredAngles = pushCopy(snapshot.angles)
    snapshot.entity.origin = restoredOrigin
    snapshot.entity.angles = restoredAngles
    runtime.world.callbacks.linkEntity(snapshot.entity)
  end for
  for each body in captureState.bodies
    setBody(body, body.origin, body.angles)
  end for
  blockerProxy = proxyFor(blocker)
  pushworldcore.blockedEntity(runtime.world, blockedPusher, blockerProxy)
  return false
end function

function resolve(runtime, captureState)
  masters = []
  movedTeams = 0
  for each snapshot in captureState.pushers
    masterNumber = pusherMasterNumber(snapshot.entity)
    seen = false
    for each prior in masters
      if prior == masterNumber then seen = true end if
    end for
    if seen == false then
      masters = masters + [masterNumber]
      if resolveTeam(runtime, captureState, masterNumber) then movedTeams = movedTeams + 1 end if
    end if
  end for
  return movedTeams
end function
