//! Provides miniquake2 game player spawn facilities for this project.

/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* SelectSpawnPoint semantics for single-player, cooperative and deathmatch. */
package miniquake2.game.player.spawn

import miniquake2.game.player.types as gplayertypes
import miniquake2.qcommon.text as qtext
import std.math as gplayermath

/// Return the spots from base edicts.
/// @param baseEdicts baseEdicts value consumed by this operation.
function spotsFromBaseEdicts(baseEdicts)
  if typeof(baseEdicts) != "array" then return error(9712, "spawnpoint scan requires a BaseEdict array") end if
  spots = []
  for each baseEdict in baseEdicts
    if typeof(baseEdict) != "struct" then return error(9713, "spawnpoint scan encountered a malformed BaseEdict") end if
    component = baseEdict.component
    if typeof(component) != "struct" then return error(9714, "spawnpoint scan encountered a malformed BaseEntity component") end if
    className = component.className
    if className == "info_player_start" or className == "info_player_coop" or
        className == "info_player_deathmatch" or
        className == "info_player_intermission" then
      componentOrigin = component.origin
      componentAngles = component.angles
      if typeof(componentOrigin) != "array" or len(componentOrigin) != 3 or
          typeof(componentAngles) != "array" or len(componentAngles) != 3 then
        return error(9715, "spawnpoint component vectors must contain three values")
      end if
      spotOrigin = [componentOrigin[0], componentOrigin[1], componentOrigin[2]]
      spotAngles = [componentAngles[0], componentAngles[1], componentAngles[2]]
      targetName = component.targetName
      spot = gplayertypes.spawnSpot(className, targetName, spotOrigin, spotAngles)
      spots = spots + [spot]
    end if
  end for
  return spots
end function

/// Map stock coop fix.
/// @param mapName mapName value consumed by this operation.
function stockCoopFixMap(mapName)
  return qtext.equalInsensitive(mapName, "jail2") or
    qtext.equalInsensitive(mapName, "jail4") or
    qtext.equalInsensitive(mapName, "mine1") or
    qtext.equalInsensitive(mapName, "mine2") or
    qtext.equalInsensitive(mapName, "mine3") or
    qtext.equalInsensitive(mapName, "mine4") or
    qtext.equalInsensitive(mapName, "lab") or
    qtext.equalInsensitive(mapName, "boss1") or
    qtext.equalInsensitive(mapName, "fact3") or
    qtext.equalInsensitive(mapName, "biggun") or
    qtext.equalInsensitive(mapName, "space") or
    qtext.equalInsensitive(mapName, "command") or
    qtext.equalInsensitive(mapName, "power2") or
    qtext.equalInsensitive(mapName, "strike")
end function

/// Stock p_client.c applies these corrections one frame after entity spawn.
/// The managed layer extracts immutable spawn records before clients begin, so
/// applying the same map-specific data correction here is equivalent and keeps
/// the live BaseEdict graph untouched.
/// @param mapName mapName value consumed by this operation.
/// @param spots spots value consumed by this operation.
function ApplyStockCoopSpawnFixups(mapName, spots)
  if typeof(spots) != "array" then return error(9722,
    "cooperative spawn fixups require a SpawnSpot array") end if
  if qtext.equalInsensitive(mapName, "security") then
    spots = spots + [
      gplayertypes.spawnSpot("info_player_coop", "jail3",
        [124.0, -164.0, 80.0], [0.0, 90.0, 0.0]),
      gplayertypes.spawnSpot("info_player_coop", "jail3",
        [252.0, -164.0, 80.0], [0.0, 90.0, 0.0]),
      gplayertypes.spawnSpot("info_player_coop", "jail3",
        [316.0, -164.0, 80.0], [0.0, 90.0, 0.0])
    ]
    return spots
  end if
  if not stockCoopFixMap(mapName) then return spots end if
  for each coopSpot in spots
    if coopSpot.className == "info_player_coop" then
      fixed = false
      for each startSpot in spots
        if not fixed and startSpot.className == "info_player_start" and
            startSpot.targetName != "" and
            distance(coopSpot.origin, startSpot.origin) < 384.0 then
          coopSpot.targetName = startSpot.targetName
          fixed = true
        end if
      end for
    end if
  end for
  return spots
end function

/// Return the distance value.
/// @param first first value consumed by this operation.
/// @param second second value consumed by this operation.
function distance(first, second)
  dx = first[0] - second[0]
  dy = first[1] - second[1]
  dz = first[2] - second[2]
  return gplayermath.sqrt(dx * dx + dy * dy + dz * dz)
end function

/// Return the nearest player distance value.
/// @param context Context that carries state for the operation.
/// @param spot spot value consumed by this operation.
/// @param spawningPlayer spawningPlayer value consumed by this operation.
function nearestPlayerDistance(context, spot, spawningPlayer)
  nearest = 999999999.0
  found = false
  for each player in context.players
    if nativeRawValue(player) != nativeRawValue(spawningPlayer) and player.edict.inUse and player.health > 0 and player.respawn.spectator != true then
      otherOrigin = [player.edict.state.origin.x, player.edict.state.origin.y, player.edict.state.origin.z]
      current = distance(spot.origin, otherOrigin)
      if current < nearest then nearest = current end if
      found = true
    end if
  end for
  if found != true then return 999999999.0 end if
  return nearest
end function

/// Return the deathmatch spots value.
/// @param context Context that carries state for the operation.
function deathmatchSpots(context)
  result = []
  for each spot in context.spawnSpots
    if spot.className == "info_player_deathmatch" then result = result + [spot] end if
  end for
  return result
end function

/// Select farthest deathmatch spawn point.
/// @param context Context that carries state for the operation.
/// @param player player value consumed by this operation.
function SelectFarthestDeathmatchSpawnPoint(context, player)
  selected = void
  bestDistance = -1.0
  for each spot in deathmatchSpots(context)
    current = nearestPlayerDistance(context, spot, player)
    if current > bestDistance then selected = spot; bestDistance = current end if
  end for
  return selected
end function

/// Return the deterministic index.
/// @param context Context that carries state for the operation.
/// @param count Number of items or units to process.
function deterministicIndex(context, count)
  if count <= 0 then return 0 end if
  index = context.frameNumber % count
  if context.randomIndex is not void then index = context.randomIndex(count) end if
  if typeof(index) != "int" or index < 0 or index >= count then return error(9710, "spawn random callback returned an invalid index") end if
  return index
end function

/// Select intermission point.
/// @param context Context that carries state for the operation.
function SelectIntermissionPoint(context)
  intermissionSpots = []
  firstStart = void
  firstDeathmatch = void
  for each spot in context.spawnSpots
    if spot.className == "info_player_intermission" then
      intermissionSpots = intermissionSpots + [spot]
    else if spot.className == "info_player_start" and firstStart is void then
      firstStart = spot
    else if spot.className == "info_player_deathmatch" and
        firstDeathmatch is void then firstDeathmatch = spot
    end if
  end for
  if len(intermissionSpots) > 0 then
    // BaseQ2 chooses rand() & 3 and wraps when fewer than four spots exist.
    return intermissionSpots[deterministicIndex(context, 4) %
      len(intermissionSpots)]
  end if
  if firstStart is not void then return firstStart end if
  return firstDeathmatch
end function

/// Select random deathmatch spawn point.
/// @param context Context that carries state for the operation.
/// @param player player value consumed by this operation.
function SelectRandomDeathmatchSpawnPoint(context, player)
  spots = deathmatchSpots(context)
  if len(spots) <= 2 then
    if len(spots) == 0 then return void end if
    return spots[deterministicIndex(context, len(spots))]
  end if

  closestIndex = -1
  secondIndex = -1
  closestDistance = 999999999.0
  secondDistance = 999999999.0
  index = 0
  while index < len(spots)
    current = nearestPlayerDistance(context, spots[index], player)
    if current < closestDistance then
      secondDistance = closestDistance; secondIndex = closestIndex
      closestDistance = current; closestIndex = index
    else if current < secondDistance then
      secondDistance = current; secondIndex = index
    end if
    index = index + 1
  end while
  eligible = []
  index = 0
  while index < len(spots)
    if index != closestIndex and index != secondIndex then eligible = eligible + [spots[index]] end if
    index = index + 1
  end while
  return eligible[deterministicIndex(context, len(eligible))]
end function

/// Select deathmatch spawn point.
/// @param context Context that carries state for the operation.
/// @param player player value consumed by this operation.
function SelectDeathmatchSpawnPoint(context, player)
  if (context.dmFlags & miniquake2.game.constants.DF_SPAWN_FARTHEST) != 0 then return SelectFarthestDeathmatchSpawnPoint(context, player) end if
  return SelectRandomDeathmatchSpawnPoint(context, player)
end function

/// Select coop spawn point.
/// @param context Context that carries state for the operation.
/// @param player player value consumed by this operation.
function SelectCoopSpawnPoint(context, player)
  clientIndex = player.edict.state.number - 1
  if clientIndex <= 0 then return void end if
  matchIndex = 0
  for each spot in context.spawnSpots
    gplayerCoopTargetHolder = spot.targetName
    gplayerCoopSpawnPointHolder = context.spawnPoint
    if typeof(gplayerCoopTargetHolder) != "string" or typeof(gplayerCoopSpawnPointHolder) != "string" then
      return error(9720, "cooperative spawnpoint names are not text")
    end if
    if spot.className == "info_player_coop" and qtext.equalInsensitive(gplayerCoopTargetHolder, gplayerCoopSpawnPointHolder) then
      matchIndex = matchIndex + 1
      if matchIndex == clientIndex then return spot end if
    end if
  end for
  return void
end function

/// Select single player spawn point.
/// @param context Context that carries state for the operation.
function SelectSinglePlayerSpawnPoint(context)
  fallback = void
  for each spot in context.spawnSpots
    if spot.className == "info_player_start" then
      if fallback is void then fallback = spot end if
      if context.spawnPoint == "" and spot.targetName == "" then return spot end if
      gplayerSingleSpawnPointHolder = context.spawnPoint
      gplayerSingleTargetHolder = spot.targetName
      if typeof(gplayerSingleSpawnPointHolder) != "string" or typeof(gplayerSingleTargetHolder) != "string" then
        return error(9721, "single-player spawnpoint names are not text")
      end if
      if gplayerSingleSpawnPointHolder != "" and gplayerSingleTargetHolder != "" and qtext.equalInsensitive(gplayerSingleSpawnPointHolder, gplayerSingleTargetHolder) then return spot end if
    end if
  end for
  if context.spawnPoint == "" then return fallback end if
  return void
end function

/// Select spawn point.
/// @param context Context that carries state for the operation.
/// @param player player value consumed by this operation.
function SelectSpawnPoint(context, player)
  spot = void
  if context.deathmatch then spot = SelectDeathmatchSpawnPoint(context, player)
  else if context.cooperative then spot = SelectCoopSpawnPoint(context, player)
  end if
  if spot is void then spot = SelectSinglePlayerSpawnPoint(context) end if
  if spot is void then return error(9711, "Couldn't find spawn point " + context.spawnPoint) end if
  origin = [spot.origin[0], spot.origin[1], spot.origin[2] + 9.0]
  angles = [spot.angles[0], spot.angles[1], spot.angles[2]]
  return gplayertypes.SpawnSelection(spot, origin, angles)
end function
