/* SelectSpawnPoint semantics for single-player, cooperative and deathmatch. */
package miniquake2.game.player.spawn

import miniquake2.game.player.types as gplayertypes
import miniquake2.qcommon.text as qtext
import std.math as gplayermath

function spotsFromBaseEdicts(baseEdicts)
  if typeof(baseEdicts) != "array" then return error(9712, "spawnpoint scan requires a BaseEdict array") end if
  spots = []
  for each baseEdict in baseEdicts
    if typeof(baseEdict) != "struct" then return error(9713, "spawnpoint scan encountered a malformed BaseEdict") end if
    component = baseEdict.component
    if typeof(component) != "struct" then return error(9714, "spawnpoint scan encountered a malformed BaseEntity component") end if
    className = component.className
    if className == "info_player_start" or className == "info_player_coop" or className == "info_player_deathmatch" then
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

function distance(first, second)
  dx = first[0] - second[0]
  dy = first[1] - second[1]
  dz = first[2] - second[2]
  return gplayermath.sqrt(dx * dx + dy * dy + dz * dz)
end function

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

function deathmatchSpots(context)
  result = []
  for each spot in context.spawnSpots
    if spot.className == "info_player_deathmatch" then result = result + [spot] end if
  end for
  return result
end function

function SelectFarthestDeathmatchSpawnPoint(context, player)
  selected = void
  bestDistance = -1.0
  for each spot in deathmatchSpots(context)
    current = nearestPlayerDistance(context, spot, player)
    if current > bestDistance then selected = spot; bestDistance = current end if
  end for
  return selected
end function

function deterministicIndex(context, count)
  if count <= 0 then return 0 end if
  index = context.frameNumber % count
  if context.randomIndex is not void then index = context.randomIndex(count) end if
  if typeof(index) != "int" or index < 0 or index >= count then return error(9710, "spawn random callback returned an invalid index") end if
  return index
end function

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

function SelectDeathmatchSpawnPoint(context, player)
  if (context.dmFlags & miniquake2.game.constants.DF_SPAWN_FARTHEST) != 0 then return SelectFarthestDeathmatchSpawnPoint(context, player) end if
  return SelectRandomDeathmatchSpawnPoint(context, player)
end function

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
