/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Transactional BaseQ2 pusher/rider physics across managed gameplay records. */
package miniquake2.game.integration.pusher

import miniquake2.qcommon.types as pushqtypes
import miniquake2.qcommon.constants as pushqconstants
import miniquake2.qcommon.byteio as pushqbyteio
import miniquake2.game.world.types as pushworldtypes
import miniquake2.game.world.core as pushworldcore
import miniquake2.game.world.constants as pushworldconstants
import miniquake2.game.weapons.vector as pushvector

// Store pusher snapshot data.
struct PusherSnapshot
  entity
  origin
  angles
  nextThink
  think
  thinkDue
end struct

// Store body snapshot data.
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
  clipMask
  deltaYaw
end struct

// Store pusher capture data.
struct PusherCapture
  pushers
  bodies
  masters
end struct

// Copy push data.
function pushCopy(value)
  if typeof(value) != "struct" then return error(9694, "pusher Vec3 value required") end if
  return pushqtypes.Vec3(value.x, value.y, value.z)
end function

// Populate the push copy destination.
function inline pushCopyInto(output, value)
  if typeof(output) != "struct" or typeof(value) != "struct" then
    return error(9694, "pusher Vec3 value required")
  end if
  output.x = value.x; output.y = value.y; output.z = value.z
  return output
end function

// Report whether is pusher.
function isPusher(entity)
  return entity.number > 0 and entity.inUse and
    (entity.moveType == pushworldconstants.MOVETYPE_PUSH or
     entity.moveType == pushworldconstants.MOVETYPE_STOP)
end function

// Report whether this mover has a linked brush volume that can contact bodies.
function pusherCanContactBodies(entity)
  return entity.solid == pushworldconstants.SOLID_BSP and
    entity.maxs.x > entity.mins.x and entity.maxs.y > entity.mins.y and
    entity.maxs.z > entity.mins.z
end function

// Return the pusher master number.
function pusherMasterNumber(entity)
  if entity.teamMaster is not void then return entity.teamMaster.number end if
  return entity.number
end function

// Assemble teams.
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

// Return the body ground number.
function bodyGroundNumber(groundEntity)
  if groundEntity is void or typeof(groundEntity) != "struct" then return -1 end if
  directNumber = try(groundEntity.number)
  if directNumber is not error and typeof(directNumber) == "int" then return directNumber end if
  stateNumber = try(groundEntity.state.number)
  if stateNumber is not error and typeof(stateNumber) == "int" then return stateNumber end if
  return -1
end function

// Return the player delta yaw.
function playerDeltaYaw(edict)
  if edict is void or edict.client is void then return 0 end if
  angles = edict.client.playerState.pmove.deltaAngles
  if typeof(angles) != "array" or len(angles) < 2 then return 0 end if
  return angles[1]
end function

// Populate the body snapshot destination.
function bodySnapshotInto(snapshot, kind, value, edict, number, origin, angles,
    mins, maxs, solid, groundNumber, clipMask, deltaYaw)
  if snapshot is void then
    snapshot = BodySnapshot(kind, value, edict, number,
      pushqtypes.zeroVec3(), pushqtypes.zeroVec3(), pushqtypes.zeroVec3(),
      pushqtypes.zeroVec3(), solid, groundNumber, clipMask, deltaYaw)
  end if
  snapshot.kind = kind; snapshot.value = value; snapshot.edict = edict
  snapshot.number = number; snapshot.solid = solid
  snapshot.groundNumber = groundNumber; snapshot.clipMask = clipMask
  snapshot.deltaYaw = deltaYaw
  pushCopyInto(snapshot.origin, origin); pushCopyInto(snapshot.angles, angles)
  pushCopyInto(snapshot.mins, mins); pushCopyInto(snapshot.maxs, maxs)
  return snapshot
end function

// Populate the world body destination.
function worldBodyInto(snapshot, entity)
  return bodySnapshotInto(snapshot, "world", entity, void, entity.number,
    entity.origin, entity.angles, entity.mins, entity.maxs, entity.solid,
    bodyGroundNumber(entity.groundEntity), entity.clipMask, 0)
end function

// Populate the player body destination.
function playerBodyInto(snapshot, player)
  playerEdict = player.edict
  playerState = playerEdict.state
  if player.groundEntity is not void then
    playerGroundLinkProbe = try(player.groundEntity.linkCount)
    if playerGroundLinkProbe is error or
        typeof(playerGroundLinkProbe) != "int" or
        playerGroundLinkProbe != player.groundLinkCount then
      player.groundEntity = void
      player.groundLinkCount = 0
    end if
  end if
  groundNumber = bodyGroundNumber(player.groundEntity)
  return bodySnapshotInto(snapshot, "player", player, playerEdict,
    playerState.number, playerState.origin, playerState.angles,
    playerEdict.mins, playerEdict.maxs, playerEdict.solid, groundNumber,
    playerEdict.clipMask, playerDeltaYaw(playerEdict))
end function

// Populate the monster body destination.
function monsterBodyInto(snapshot, actor)
  monsterEdict = actor.edict
  monsterState = monsterEdict.state
  return bodySnapshotInto(snapshot, "monster", actor, monsterEdict,
    monsterState.number, monsterState.origin, monsterState.angles,
    monsterEdict.mins, monsterEdict.maxs, monsterEdict.solid,
    bodyGroundNumber(actor.groundEntity), monsterEdict.clipMask, 0)
end function

// Populate a MOVETYPE_FLYMISSILE/BOUNCE projectile body destination.
function projectileBodyInto(snapshot, runtime, projectile)
  projectileEdict = void
  if runtime.exportTable is not void and projectile.engineNumber >= 0 and
      projectile.engineNumber < runtime.exportTable.numEdicts then
    projectileEdict = runtime.exportTable.edicts[projectile.engineNumber]
  end if
  return bodySnapshotInto(snapshot, "projectile", projectile,
    projectileEdict, projectile.engineNumber, projectile.origin,
    projectile.angles, projectile.mins, projectile.maxs, projectile.solid,
    bodyGroundNumber(projectile.groundEntity), projectile.clipMask, 0)
end function

// Populate the pusher snapshot destination.
function pusherSnapshotInto(snapshot, entity)
  if snapshot is void then
    snapshot = PusherSnapshot(entity, pushqtypes.zeroVec3(),
      pushqtypes.zeroVec3(), 0.0, void, false)
  end if
  snapshot.entity = entity
  pushCopyInto(snapshot.origin, entity.origin)
  pushCopyInto(snapshot.angles, entity.angles)
  snapshot.nextThink = entity.nextThink
  snapshot.think = entity.think
  snapshot.thinkDue = false
  return snapshot
end function

// g_phys.c excludes MOVETYPE_NONE/PUSH/STOP/NOCLIP entities before testing a
// pusher overlap. Managed world bodies that can actually be displaced use one
// of these three locomotion modes; static bbox/BSP helpers must never jam a
// door merely because their authored bounds intersect its swept volume.
function worldBodyCanBePushed(entity)
  return entity.moveType == pushworldconstants.MOVETYPE_STEP or
    entity.moveType == pushworldconstants.MOVETYPE_TOSS or
    entity.moveType == pushworldconstants.MOVETYPE_BOUNCE
end function

// Capture state.
function capture(runtime)
  // Keep capture phases explicit: validate inputs, update owned state, then publish the result.
  pusherCount = 0
  bodyCount = 0
  for each countedEntity in runtime.world.entities
    if isPusher(countedEntity) then pusherCount = pusherCount + 1 end if
    if countedEntity.number > 0 and countedEntity.inUse and
        countedEntity.solid != pushworldconstants.SOLID_NOT and
        countedEntity.solid != pushworldconstants.SOLID_TRIGGER and
        worldBodyCanBePushed(countedEntity) then
      bodyCount = bodyCount + 1
    end if
  end for
  if runtime.playerContext is not void then
    for each countedPlayer in runtime.playerContext.players
      if countedPlayer.edict.inUse and
          countedPlayer.edict.solid != pushworldconstants.SOLID_NOT then
        bodyCount = bodyCount + 1
      end if
    end for
  end if
  for each countedActor in runtime.monsters
    if countedActor.edict.inUse and
        countedActor.edict.solid != pushworldconstants.SOLID_NOT then
      bodyCount = bodyCount + 1
    end if
  end for
  for each countedProjectile in runtime.weaponContext.projectiles
    if countedProjectile.inUse and
        countedProjectile.engineNumber >= 0 and
        countedProjectile.solid != pushworldconstants.SOLID_NOT then
      bodyCount = bodyCount + 1
    end if
  end for
  captureState = runtime.pusherCapture
  if captureState is void then
    captureState = PusherCapture(array(pusherCount, void),
      array(bodyCount, void), array(pusherCount, -1))
    runtime.pusherCapture = captureState
  end if
  if len(captureState.pushers) != pusherCount then
    captureState.pushers = array(pusherCount, void)
    captureState.masters = array(pusherCount, -1)
  end if
  if len(captureState.bodies) != bodyCount then
    captureState.bodies = array(bodyCount, void)
  end if
  pushers = captureState.pushers
  bodies = captureState.bodies
  pusherIndex = 0
  bodyIndex = 0
  for each entity in runtime.world.entities
    if isPusher(entity) then
      pushers[pusherIndex] = pusherSnapshotInto(pushers[pusherIndex], entity)
      pusherIndex = pusherIndex + 1
    end if
    if entity.number > 0 and entity.inUse and
        entity.solid != pushworldconstants.SOLID_NOT and
        entity.solid != pushworldconstants.SOLID_TRIGGER and
        worldBodyCanBePushed(entity) then
      bodies[bodyIndex] = worldBodyInto(bodies[bodyIndex], entity)
      bodyIndex = bodyIndex + 1
    end if
  end for
  if runtime.playerContext is not void then
    for each player in runtime.playerContext.players
      if player.edict.inUse and player.edict.solid != pushworldconstants.SOLID_NOT then
        bodies[bodyIndex] = playerBodyInto(bodies[bodyIndex], player)
        bodyIndex = bodyIndex + 1
      end if
    end for
  end if
  for each actor in runtime.monsters
    if actor.edict.inUse and actor.edict.solid != pushworldconstants.SOLID_NOT then
      bodies[bodyIndex] = monsterBodyInto(bodies[bodyIndex], actor)
      bodyIndex = bodyIndex + 1
    end if
  end for
  for each projectile in runtime.weaponContext.projectiles
    if projectile.inUse and projectile.engineNumber >= 0 and
        projectile.solid != pushworldconstants.SOLID_NOT then
      bodies[bodyIndex] = projectileBodyInto(bodies[bodyIndex], runtime,
        projectile)
      bodyIndex = bodyIndex + 1
    end if
  end for
  return captureState
end function

// Defer due mover thinks until the enclosing SV_Push transaction succeeds.
function deferDueThinks(captureState, targetTime)
  deferred = 0
  for each snapshot in captureState.pushers
    if snapshot.nextThink > 0.0 and snapshot.nextThink <= targetTime and
        snapshot.think is not void then
      snapshot.thinkDue = true
      snapshot.entity.nextThink = 0.0
      deferred = deferred + 1
    end if
  end for
  return deferred
end function

// Report whether moved.
function moved(snapshot)
  entity = snapshot.entity
  return entity.origin.x != snapshot.origin.x or entity.origin.y != snapshot.origin.y or entity.origin.z != snapshot.origin.z or
    entity.angles.x != snapshot.angles.x or entity.angles.y != snapshot.angles.y or entity.angles.z != snapshot.angles.z
end function

// Move snapped pusher.
function inline snappedPusherMove(value)
  scaled = value * 8.0
  if scaled > 0.0 then scaled = scaled + 0.5 else scaled = scaled - 0.5 end if
  return pushqbyteio.truncInt(scaled) * 0.125
end function

// Publish pusher move.
function publishPusherMove(runtime, snapshot)
  entity = snapshot.entity
  // SV_Push clamps translations to 1/8 unit before moving and immediately
  // calls gi.linkentity. The relink is not optional: server Pmove broad phase
  // consumes absmin/absmax, which otherwise remain at the elevator's old floor.
  entity.origin.x = snapshot.origin.x + snappedPusherMove(entity.origin.x - snapshot.origin.x)
  entity.origin.y = snapshot.origin.y + snappedPusherMove(entity.origin.y - snapshot.origin.y)
  entity.origin.z = snapshot.origin.z + snappedPusherMove(entity.origin.z - snapshot.origin.z)
  runtime.world.callbacks.linkEntity(entity)
  return true
end function

// Return the rotated bounds.
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

// Return the current origin.
function currentOrigin(body)
  if body.kind == "world" or body.kind == "projectile" then
    return body.value.origin
  end if
  return body.edict.state.origin
end function

// Return the current angles.
function currentAngles(body)
  if body.kind == "world" or body.kind == "projectile" then
    return body.value.angles
  end if
  return body.edict.state.angles
end function

// Return the body bounds for the requested position.
function bodyBoundsAt(body, origin, angles)
  return rotatedBounds(origin, angles, body.mins, body.maxs)
end function

// Return the strict overlap value.
function strictOverlap(first, second)
  return first[1].x > second[0].x and first[0].x < second[1].x and first[1].y > second[0].y and first[0].y < second[1].y and first[1].z > second[0].z and first[0].z < second[1].z
end function

// Report whether body can be pushed.
function bodyCanBePushed(body)
  if body.kind == "player" or body.kind == "monster" or
      body.kind == "projectile" then return true end if
  if body.kind != "world" then return false end if
  return worldBodyCanBePushed(body.value)
end function

// Report whether standing on.
function standingOn(body, pusherSnapshot)
  if body.groundNumber == pusherSnapshot.entity.number then return true end if
  // MOVETYPE_STOP may carry only an explicit groundentity rider. The geometric
  // recovery below is reserved for PUSH brushes whose final overlap would have
  // displaced the body in stock SV_Push anyway.
  if pusherSnapshot.entity.moveType == pushworldconstants.MOVETYPE_STOP then return false end if
  pusherBox = rotatedBounds(pusherSnapshot.origin, pusherSnapshot.angles, pusherSnapshot.entity.mins, pusherSnapshot.entity.maxs)
  bodyBox = bodyBoundsAt(body, body.origin, body.angles)
  gap = bodyBox[0].z - pusherBox[1].z
  return gap >= -0.25 and gap <= 2.0 and bodyBox[1].x > pusherBox[0].x and bodyBox[0].x < pusherBox[1].x and bodyBox[1].y > pusherBox[0].y and bodyBox[0].y < pusherBox[1].y
end function

// Set body.
function setBody(body, origin, angles)
  newOrigin = pushCopy(origin)
  newAngles = pushCopy(angles)
  if body.kind == "world" or body.kind == "projectile" then
    body.value.origin = newOrigin; body.value.angles = newAngles
  else body.edict.state.origin = newOrigin; body.edict.state.angles = newAngles
  end if
  return true
end function

// Report whether body moved.
function bodyMoved(body)
  liveOrigin = currentOrigin(body)
  liveAngles = currentAngles(body)
  return liveOrigin.x != body.origin.x or liveOrigin.y != body.origin.y or
    liveOrigin.z != body.origin.z or liveAngles.x != body.angles.x or
    liveAngles.y != body.angles.y or liveAngles.z != body.angles.z
end function

// Link body.
function linkBody(runtime, body)
  if runtime.playerContext is void or runtime.exportTable is void then return true end if
  if body.kind == "world" then
    runtime.world.callbacks.linkEntity(body.value)
  else if body.kind == "projectile" then
    runtime.weaponContext.callbacks.linkEntity(body.value)
  else
    runtime.playerContext.imports.linkEntity(body.edict)
  end if
  return true
end function

// Return the body pass entity value.
function bodyPassEntity(runtime, body)
  if body.kind != "world" then return body.edict end if
  if runtime.exportTable is void or body.number < 0 or
      body.number >= len(runtime.exportTable.edicts) then return void end if
  return runtime.exportTable.edicts[body.number]
end function

// Report whether body position blocked.
function bodyPositionBlocked(runtime, body, position)
  if runtime.playerContext is void or runtime.exportTable is void then return false end if
  mask = body.clipMask
  if mask == 0 then mask = pushqconstants.MASK_SOLID end if
  // SV_TestEntityPosition is a stationary trace at the candidate origin. A
  // swept trace changes stock pusher behavior by rejecting valid final poses.
  trace = runtime.playerContext.imports.trace(position, body.mins, body.maxs,
    position, bodyPassEntity(runtime, body), mask)
  return trace.startSolid
end function

// Return the body intersects final pusher value.
function bodyIntersectsFinalPusher(runtime, body)
  if runtime.playerContext is void or runtime.exportTable is void then return true end if
  return bodyPositionBlocked(runtime, body, currentOrigin(body))
end function

// Return the translated fallback value.
function translatedFallback(destination, pusherSnapshot)
  return pushqtypes.Vec3(
    destination.x - (pusherSnapshot.entity.origin.x - pusherSnapshot.origin.x),
    destination.y - (pusherSnapshot.entity.origin.y - pusherSnapshot.origin.y),
    destination.z - (pusherSnapshot.entity.origin.z - pusherSnapshot.origin.z))
end function

// Add player delta yaw.
function addPlayerDeltaYaw(body, amount)
  if body.kind != "player" or body.edict is void or body.edict.client is void then return false end if
  angles = body.edict.client.playerState.pmove.deltaAngles
  if typeof(angles) != "array" or len(angles) < 2 then return false end if
  angles[1] = pushqbyteio.truncInt(angles[1] + amount)
  return true
end function

// Restore player delta yaw.
function restorePlayerDeltaYaw(body)
  if body.kind != "player" or body.edict is void or body.edict.client is void then return false end if
  angles = body.edict.client.playerState.pmove.deltaAngles
  if typeof(angles) != "array" or len(angles) < 2 then return false end if
  angles[1] = body.deltaYaw
  return true
end function

// Clear ground unless riding.
function clearGroundUnlessRiding(body, pusherSnapshot)
  if body.groundNumber == pusherSnapshot.entity.number then return false end if
  if body.kind == "world" or body.kind == "projectile" then
    body.value.groundEntity = void
  else body.value.groundEntity = void
  end if
  return true
end function

// Return the carry origin.
function carryOrigin(body, pusherSnapshot)
  // A team can contain several moving brush parts. Use the live position so a
  // body contacted by a later team member continues from its already-carried
  // position, matching the original pushed[] transaction order.
  bodyOrigin = pushCopy(currentOrigin(body))
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

// BaseQ2 SV_Push first moves a contacted bbox with a MOVETYPE_PUSH brush and
// reports a block only when the carried position is obstructed. Treating the
// first overlap as a block leaves the player embedded at the reversal point;
// the door then toggles direction and applies crush damage every server frame.
function pushBody(runtime, body, pusherSnapshot)
  if pusherSnapshot.entity.moveType != pushworldconstants.MOVETYPE_PUSH or
      bodyCanBePushed(body) == false then return false end if
  start = currentOrigin(body)
  destination = carryOrigin(body, pusherSnapshot)
  if bodyPositionBlocked(runtime, body, destination) then
    // The stock fallback subtracts only the translation. This lets a rider
    // stay behind when its carried pose is blocked but its old pose is clear.
    fallback = translatedFallback(destination, pusherSnapshot)
    if bodyPositionBlocked(runtime, body, fallback) then return false end if
    destination = fallback
  end if
  setBody(body, destination, currentAngles(body))
  clearGroundUnlessRiding(body, pusherSnapshot)
  addPlayerDeltaYaw(body, pusherSnapshot.entity.angles.y - pusherSnapshot.angles.y)
  linkBody(runtime, body)
  return true
end function

// Report whether team has.
function teamHas(team, number)
  for each snapshot in team
    if snapshot.entity.number == number then return true end if
  end for
  return false
end function

// Return the proxy for the requested input.
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

// Finish a pusher team's deferred thinks with g_phys.c ordering.
function finishTeamThinks(runtime, team, blocked)
  if blocked then
    for each snapshot in team
      if snapshot.nextThink > 0.0 then
        snapshot.entity.nextThink = snapshot.nextThink +
          runtime.world.frameTime
      end if
    end for
    return false
  end if
  for each snapshot in team
    if snapshot.thinkDue and snapshot.entity.inUse and
        snapshot.think is not void then
      snapshot.entity.nextThink = 0.0
      runtime.world.currentEntity = snapshot.entity
      snapshot.think(snapshot.entity, runtime.world)
      runtime.world.currentEntity = void
    end if
  end for
  return true
end function

// Run trigger passes only after the complete pusher team commits.
// g_phys.c defers G_TouchTriggers until SV_Push succeeds, so a rolled-back
// rider must never activate a trigger at its temporary carried position.
function touchCommittedBodies(runtime, bodies, movedBodies)
  touched = 0
  bodyTouchProbe = try(runtime.pusherTriggerTouch)
  index = 0
  while index < len(bodies)
    body = bodies[index]
    if movedBodies[index] and typeof(bodyTouchProbe) == "function" then
      bodyTouchCallback = bodyTouchProbe
      touched = touched + bodyTouchCallback(runtime, body.kind, body.value)
    else if movedBodies[index] and body.kind == "player" and
        runtime.playerContext is not void and
        runtime.playerContext.touchTriggers is not void then
      touchTriggersCallback = runtime.playerContext.touchTriggers
      touchTriggersCallback(body.value)
      touched = touched + 1
    end if
    index = index + 1
  end while
  return touched
end function

// Resolve team.
function resolveTeam(runtime, captureState, masterNumber)
  teamCount = 0
  anyMoved = false
  for each countedSnapshot in captureState.pushers
    if pusherMasterNumber(countedSnapshot.entity) == masterNumber then
      teamCount = teamCount + 1
      if moved(countedSnapshot) then anyMoved = true end if
    end if
  end for
  team = array(teamCount, void)
  teamIndex = 0
  for each snapshot in captureState.pushers
    if pusherMasterNumber(snapshot.entity) == masterNumber then
      team[teamIndex] = snapshot
      teamIndex = teamIndex + 1
    end if
  end for
  if anyMoved == false then
    finishTeamThinks(runtime, team, false)
    return false
  end if

  blocker = void
  blockedPusher = void
  movedBodies = array(len(captureState.bodies), false)
  // SV_Physics_Pusher calls SV_Push for each team-chain part in order.  Each
  // part is linked and tested before the next part moves, while pushed[] keeps
  // one transaction for the complete team.  In particular, traces for the
  // first part must still see every later part at its old linked transform.
  for each pusherSnapshot in team
    if moved(pusherSnapshot) then
      publishPusherMove(runtime, pusherSnapshot)
      bodyIndex = 0
      for each body in captureState.bodies
        if teamHas(team, body.number) == false then
          rider = pusherCanContactBodies(pusherSnapshot.entity) and
            standingOn(body, pusherSnapshot)
          if rider then
            destination = carryOrigin(body, pusherSnapshot)
            destinationAngles = pushCopy(body.angles)
            if bodyPositionBlocked(runtime, body, destination) then
              destination = translatedFallback(destination, pusherSnapshot)
              if bodyPositionBlocked(runtime, body, destination) then
                blocker = body; blockedPusher = pusherSnapshot.entity
              end if
            end if
            if blocker is void then
              setBody(body, destination, destinationAngles)
              addPlayerDeltaYaw(body, pusherSnapshot.entity.angles.y -
                pusherSnapshot.angles.y)
              linkBody(runtime, body)
              movedBodies[bodyIndex] = true
            end if
          else if pusherCanContactBodies(pusherSnapshot.entity) then
            liveBodyOrigin = currentOrigin(body)
            liveBodyAngles = currentAngles(body)
            bodyBox = bodyBoundsAt(body, liveBodyOrigin, liveBodyAngles)
            pusherBox = rotatedBounds(pusherSnapshot.entity.origin,
              pusherSnapshot.entity.angles, pusherSnapshot.entity.mins,
              pusherSnapshot.entity.maxs)
            if strictOverlap(bodyBox, pusherBox) and
                bodyIntersectsFinalPusher(runtime, body) then
              if pushBody(runtime, body, pusherSnapshot) then
                movedBodies[bodyIndex] = true
              else
                blocker = body; blockedPusher = pusherSnapshot.entity
              end if
            end if
          end if
        end if
        if blocker is not void then break end if
        bodyIndex = bodyIndex + 1
      end for
    end if
    if blocker is not void then break end if
  end for
  if blocker is void then
    touchCommittedBodies(runtime, captureState.bodies, movedBodies)
    finishTeamThinks(runtime, team, false)
    return true
  end if

  for each snapshot in team
    restoredOrigin = pushCopy(snapshot.origin)
    restoredAngles = pushCopy(snapshot.angles)
    snapshot.entity.origin = restoredOrigin
    snapshot.entity.angles = restoredAngles
    runtime.world.callbacks.linkEntity(snapshot.entity)
  end for
  for each body in captureState.bodies
    if bodyMoved(body) then
      setBody(body, body.origin, body.angles)
      linkBody(runtime, body)
    end if
    restorePlayerDeltaYaw(body)
  end for
  blockerProxy = proxyFor(blocker)
  finishTeamThinks(runtime, team, true)
  pushworldcore.blockedEntity(runtime.world, blockedPusher, blockerProxy)
  return false
end function

// Resolve state.
function resolve(runtime, captureState)
  masters = captureState.masters
  masterCount = 0
  movedTeams = 0
  for each snapshot in captureState.pushers
    masterNumber = pusherMasterNumber(snapshot.entity)
    seen = false
    priorIndex = 0
    while priorIndex < masterCount
      if masters[priorIndex] == masterNumber then seen = true end if
      priorIndex = priorIndex + 1
    end while
    if seen == false then
      masters[masterCount] = masterNumber
      masterCount = masterCount + 1
      if resolveTeam(runtime, captureState, masterNumber) then movedTeams = movedTeams + 1 end if
    end if
  end for
  return movedTeams
end function
