//! Provides miniquake2 game integration campaign progression facilities for this project.

/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Goal-graph driver for deterministic retail campaign acceptance. */
package miniquake2.game.integration.campaign_progression

import miniquake2.game.integration.baseq2 as campaignbaseq2
import miniquake2.game.world.core as campaignworld

/// Store campaign progress result data.
struct CampaignProgressResult
  /// Stores the reached value associated with campaign progress result.
  reached
  /// Stores the requested map value associated with campaign progress result.
  requestedMap
  /// Stores the selected map spec value associated with campaign progress result.
  selectedMapSpec
  /// Stores the actions value associated with campaign progress result.
  actions
  /// Stores the keys value associated with campaign progress result.
  keys
  /// Stores the monsters value associated with campaign progress result.
  monsters
  /// Stores the direct fallback value associated with campaign progress result.
  directFallback
end struct

/// Map normalized name.
/// @param mapSpec mapSpec value consumed by this operation.
function normalizedMapName(mapSpec)
  if typeof(mapSpec) != "string" or mapSpec == "" then return "" end if
  campaignMapStart = 0
  campaignMapScan = 0
  while campaignMapScan < len(mapSpec)
    if mapSpec[campaignMapScan] == "+" then campaignMapStart = campaignMapScan + 1 end if
    campaignMapScan = campaignMapScan + 1
  end while
  if campaignMapStart < len(mapSpec) and mapSpec[campaignMapStart] == "*" then
    campaignMapStart = campaignMapStart + 1
  end if
  campaignMapEnd = campaignMapStart
  while campaignMapEnd < len(mapSpec) and mapSpec[campaignMapEnd] != "$"
    campaignMapEnd = campaignMapEnd + 1
  end while
  campaignMapResult = ""
  campaignMapIndex = campaignMapStart
  while campaignMapIndex < campaignMapEnd
    campaignMapResult = campaignMapResult + mapSpec[campaignMapIndex]
    campaignMapIndex = campaignMapIndex + 1
  end while
  return campaignMapResult
end function

/// Return the campaign visited value.
/// @param visited visited value consumed by this operation.
/// @param number number value consumed by this operation.
function campaignVisited(visited, number)
  for each campaignVisitedNumber in visited
    if campaignVisitedNumber == number then return true end if
  end for
  return false
end function

/// Return the campaign player value.
/// @param playerContext playerContext value consumed by this operation.
function campaignPlayer(playerContext)
  if playerContext is void then return void end if
  for each campaignCandidatePlayer in playerContext.players
    if campaignCandidatePlayer.edict.inUse and campaignCandidatePlayer.persistent.connected then
      return campaignCandidatePlayer
    end if
  end for
  return void
end function

/// Pick up campaign key.
/// @param runtime runtime value consumed by this operation.
/// @param playerContext playerContext value consumed by this operation.
/// @param player player value consumed by this operation.
/// @param itemClassName itemClassName value consumed by this operation.
function campaignPickupKey(runtime, playerContext, player, itemClassName)
  if itemClassName == "" then return false end if
  campaignKeyEntity = campaignbaseq2.findItemByClass(runtime, itemClassName)
  if campaignKeyEntity is void then return false end if
  campaignKeyAction = campaignbaseq2.touchItem(runtime, campaignKeyEntity, player, playerContext)
  return campaignKeyAction.success
end function

/// Activate campaign world.
/// @param runtime runtime value consumed by this operation.
/// @param playerContext playerContext value consumed by this operation.
/// @param player player value consumed by this operation.
/// @param entity entity value consumed by this operation.
function campaignActivateWorld(runtime, playerContext, player, entity)
  if entity is void or not entity.inUse then return [false, 0] end if
  campaignKeyCount = 0
  if entity.className == "trigger_key" then
    campaignActivator = campaignbaseq2.playerWorldProxy(player)
    campaignAlreadyHasKey = runtime.world.callbacks.hasKeyItem(campaignActivator, entity.item)
    if campaignAlreadyHasKey != true then
      if not campaignPickupKey(runtime, playerContext, player, entity.item) then return [false, 0] end if
      campaignKeyCount = 1
    end if
  end if
  campaignProxy = campaignbaseq2.playerWorldProxy(player)
  campaignActivated = false
  if entity.className == "func_timer" and entity.nextThink != 0.0 then
    // START_ON timers already own the pending objective think. Calling use
    // would toggle them off; the bounded settler below must let them fire.
    campaignActivated = true
  else if entity.className == "trigger_once" or entity.className == "trigger_multiple" then
    campaignActivated = campaignworld.useEntity(runtime.world, entity, void, campaignProxy)
    if not campaignActivated then campaignActivated = campaignworld.touchEntity(runtime.world, entity, campaignProxy) end if
  else if entity.className == "trigger_hurt" or entity.className == "trigger_push" or
      entity.className == "trigger_monsterjump" then
    campaignActivated = campaignworld.touchEntity(runtime.world, entity, campaignProxy)
  else if entity.className == "trigger_counter" then
    campaignCounterUses = entity.count
    if campaignCounterUses < 1 then campaignCounterUses = 1 end if
    campaignCounterIndex = 0
    while campaignCounterIndex < campaignCounterUses and entity.inUse
      if campaignworld.useEntity(runtime.world, entity, void, campaignProxy) then campaignActivated = true end if
      campaignCounterIndex = campaignCounterIndex + 1
    end while
  else
    campaignActivated = campaignworld.useEntity(runtime.world, entity, void, campaignProxy)
    if not campaignActivated then campaignActivated = campaignworld.touchEntity(runtime.world, entity, campaignProxy) end if
  end if
  return [campaignActivated, campaignKeyCount]
end function

/// Kill campaign monster.
/// @param runtime runtime value consumed by this operation.
/// @param actor actor value consumed by this operation.
function campaignKillMonster(runtime, actor)
  campaignMonsterIndex = 0
  while campaignMonsterIndex < len(runtime.monsters)
    if runtime.monsters[campaignMonsterIndex].edict.state.number == actor.edict.state.number then
      if actor.health <= 0 then return false end if
      return campaignbaseq2.damageMonster(runtime, campaignMonsterIndex, void, actor.health)
    end if
    campaignMonsterIndex = campaignMonsterIndex + 1
  end while
  return false
end function

/// Return the campaign drive target value.
/// @param runtime runtime value consumed by this operation.
/// @param playerContext playerContext value consumed by this operation.
/// @param player player value consumed by this operation.
/// @param targetName targetName value consumed by this operation.
/// @param visited visited value consumed by this operation.
/// @param depth depth value consumed by this operation.
function campaignDriveTarget(runtime, playerContext, player, targetName, visited, depth)
  // Keep campaign drive target phases explicit: validate inputs, update owned state, then publish the result.
  if targetName == "" or depth > 32 then return [false, 0, 0, visited] end if
  campaignTargetActivated = false
  campaignTargetKeys = 0
  campaignTargetMonsters = 0
  campaignTargetWorldSnapshot = runtime.world.entities
  for each campaignTargetEntity in campaignTargetWorldSnapshot
    if campaignTargetEntity.inUse and campaignTargetEntity.target == targetName and
        not campaignVisited(visited, campaignTargetEntity.number) then
      visited = visited + [campaignTargetEntity.number]
      if campaignTargetEntity.targetName != "" then
        campaignUpstream = campaignDriveTarget(runtime, playerContext, player,
          campaignTargetEntity.targetName, visited, depth + 1)
        if campaignUpstream[0] then campaignTargetActivated = true end if
        campaignTargetKeys = campaignTargetKeys + campaignUpstream[1]
        campaignTargetMonsters = campaignTargetMonsters + campaignUpstream[2]
        visited = campaignUpstream[3]
      end if
      if campaignTargetEntity.inUse then
        campaignWorldActivation = campaignActivateWorld(runtime, playerContext, player, campaignTargetEntity)
        if campaignWorldActivation[0] then campaignTargetActivated = true end if
        campaignTargetKeys = campaignTargetKeys + campaignWorldActivation[1]
      end if
    end if
  end for
  campaignMonsterPass = 0
  while campaignMonsterPass < 3
    campaignMonsterSnapshot = runtime.monsters
    campaignKilledThisPass = false
    for each campaignTargetActor in campaignMonsterSnapshot
      if campaignTargetActor.health > 0 and
          (campaignTargetActor.target == targetName or campaignTargetActor.deathTarget == targetName) and
          not campaignVisited(visited, campaignTargetActor.edict.state.number) then
        visited = visited + [campaignTargetActor.edict.state.number]
        if campaignKillMonster(runtime, campaignTargetActor) then
          campaignTargetActivated = true
          campaignTargetMonsters = campaignTargetMonsters + 1
          campaignKilledThisPass = true
          if campaignTargetActor.className == "monster_jorg" then
            campaignBossFrame = 0
            while campaignBossFrame < 55
              campaignbaseq2.runFrame(runtime)
              campaignBossFrame = campaignBossFrame + 1
            end while
          end if
        end if
      end if
    end for
    if not campaignKilledThisPass then campaignMonsterPass = 3
    else campaignMonsterPass = campaignMonsterPass + 1 end if
  end while
  return [campaignTargetActivated, campaignTargetKeys, campaignTargetMonsters, visited]
end function

/// Map drive to.
/// @param runtime runtime value consumed by this operation.
/// @param playerContext playerContext value consumed by this operation.
/// @param requestedMap requestedMap value consumed by this operation.
function driveToMap(runtime, playerContext, requestedMap)
  // Keep drive to map phases explicit: validate inputs, update owned state, then publish the result.
  if runtime is void or playerContext is void or typeof(requestedMap) != "string" or requestedMap == "" then
    return error(9710, "campaign progression requires runtime, player context and target map")
  end if
  campaignDrivePlayer = campaignPlayer(playerContext)
  if campaignDrivePlayer is void then return error(9711, "campaign progression requires a connected player") end if
  campaignSelectedTransition = void
  for each campaignTransitionCandidate in runtime.world.entities
    if campaignTransitionCandidate.inUse and campaignTransitionCandidate.className == "target_changelevel" and
        normalizedMapName(campaignTransitionCandidate.map) == requestedMap then
      campaignSelectedTransition = campaignTransitionCandidate
      break
    end if
  end for
  if campaignSelectedTransition is void then return CampaignProgressResult(false, requestedMap, "", 0, 0, 0, false) end if
  campaignDriveActions = 0
  campaignDriveKeys = 0
  campaignDriveMonsters = 0
  campaignDriveFallback = false
  if campaignSelectedTransition.targetName != "" then
    campaignDriveResult = campaignDriveTarget(runtime, playerContext, campaignDrivePlayer,
      campaignSelectedTransition.targetName, [], 0)
    if campaignDriveResult[0] then campaignDriveActions = 1 end if
    campaignDriveKeys = campaignDriveResult[1]
    campaignDriveMonsters = campaignDriveResult[2]
  end if
  campaignSettleFrame = 0
  while normalizedMapName(playerContext.nextMap) != requestedMap and campaignSettleFrame < 4096
    campaignbaseq2.runFrame(runtime)
    campaignSettleFrame = campaignSettleFrame + 1
  end while
  if normalizedMapName(playerContext.nextMap) != requestedMap then
    campaignDriveFallback = true
    campaignDirectProxy = campaignbaseq2.playerWorldProxy(campaignDrivePlayer)
    campaignworld.useEntity(runtime.world, campaignSelectedTransition, void, campaignDirectProxy)
  end if
  campaignDriveReached = normalizedMapName(playerContext.nextMap) == requestedMap and runtime.world.intermission
  return CampaignProgressResult(campaignDriveReached, requestedMap,
    campaignSelectedTransition.map, campaignDriveActions, campaignDriveKeys,
    campaignDriveMonsters, campaignDriveFallback)
end function
