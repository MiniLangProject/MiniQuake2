/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Deterministic p_hud.c stats and the synchronization core of p_view.c. */
package miniquake2.game.player.hud

import miniquake2.game.gameplay.item_rules as gprules
import miniquake2.game.player.view as gplayerview
import miniquake2.qcommon.byteio as qbyteio

function imageIndex(context, name)
  if name == "" then return 0 end if
  return context.imports.imageIndex(name)
end function

function timerStats(context, player, stats)
  if player.powerups.quadFrame > context.frameNumber then
    stats[miniquake2.game.constants.STAT_TIMER_ICON] = imageIndex(context, "p_quad")
    stats[miniquake2.game.constants.STAT_TIMER] = qbyteio.truncInt((player.powerups.quadFrame - context.frameNumber) / 10)
  else if player.powerups.invincibleFrame > context.frameNumber then
    stats[miniquake2.game.constants.STAT_TIMER_ICON] = imageIndex(context, "p_invulnerability")
    stats[miniquake2.game.constants.STAT_TIMER] = qbyteio.truncInt((player.powerups.invincibleFrame - context.frameNumber) / 10)
  else if player.powerups.enviroFrame > context.frameNumber then
    stats[miniquake2.game.constants.STAT_TIMER_ICON] = imageIndex(context, "p_envirosuit")
    stats[miniquake2.game.constants.STAT_TIMER] = qbyteio.truncInt((player.powerups.enviroFrame - context.frameNumber) / 10)
  else if player.powerups.breatherFrame > context.frameNumber then
    stats[miniquake2.game.constants.STAT_TIMER_ICON] = imageIndex(context, "p_rebreather")
    stats[miniquake2.game.constants.STAT_TIMER] = qbyteio.truncInt((player.powerups.breatherFrame - context.frameNumber) / 10)
  else
    stats[miniquake2.game.constants.STAT_TIMER_ICON] = 0
    stats[miniquake2.game.constants.STAT_TIMER] = 0
  end if
end function

function G_SetStats(context, player)
  stats = player.edict.client.playerState.stats
  stats[miniquake2.game.constants.STAT_HEALTH_ICON] = imageIndex(context, "i_health")
  stats[miniquake2.game.constants.STAT_HEALTH] = player.health

  ammoIndex = player.gameplay.ammoIndex
  ammo = gprules.getByIndex(context.registry, ammoIndex)
  if ammo is void then
    stats[miniquake2.game.constants.STAT_AMMO_ICON] = 0
    stats[miniquake2.game.constants.STAT_AMMO] = 0
  else
    stats[miniquake2.game.constants.STAT_AMMO_ICON] = imageIndex(context, ammo.icon)
    stats[miniquake2.game.constants.STAT_AMMO] = player.gameplay.inventory.counts[ammo.index]
  end if

  armor = gprules.getByIndex(context.registry, player.armorItemIndex)
  if armor is void then
    stats[miniquake2.game.constants.STAT_ARMOR_ICON] = 0
    stats[miniquake2.game.constants.STAT_ARMOR] = 0
  else
    stats[miniquake2.game.constants.STAT_ARMOR_ICON] = imageIndex(context, armor.icon)
    stats[miniquake2.game.constants.STAT_ARMOR] = player.gameplay.inventory.counts[armor.index]
  end if

  if context.time > player.pickupMessageTime then
    stats[miniquake2.game.constants.STAT_PICKUP_ICON] = 0
    stats[miniquake2.game.constants.STAT_PICKUP_STRING] = 0
  end if
  timerStats(context, player, stats)

  selectedIndex = player.gameplay.inventory.selectedItem
  selected = gprules.getByIndex(context.registry, selectedIndex)
  if selected is void then stats[miniquake2.game.constants.STAT_SELECTED_ICON] = 0
  else stats[miniquake2.game.constants.STAT_SELECTED_ICON] = imageIndex(context, selected.icon)
  end if
  stats[miniquake2.game.constants.STAT_SELECTED_ITEM] = selectedIndex

  layout = 0
  if context.deathmatch then
    if player.health <= 0 or context.intermissionTime > 0.0 or player.showScores then layout = layout | 1 end if
  else
    if player.showScores or player.showHelp then layout = layout | 1 end if
  end if
  if player.showInventory and player.health > 0 then layout = layout | 2 end if
  stats[miniquake2.game.constants.STAT_LAYOUTS] = layout
  stats[miniquake2.game.constants.STAT_FRAGS] = player.respawn.score

  if player.showHelp and (context.frameNumber & 8) != 0 then stats[miniquake2.game.constants.STAT_HELPICON] = imageIndex(context, "i_help")
  else if player.gameplay.currentWeapon is not void and (player.persistent.hand == 2 or player.edict.client.playerState.fov > 91.0) then stats[miniquake2.game.constants.STAT_HELPICON] = imageIndex(context, player.gameplay.currentWeapon.icon)
  else stats[miniquake2.game.constants.STAT_HELPICON] = 0
  end if
  stats[miniquake2.game.constants.STAT_SPECTATOR] = 0
  return stats
end function

function copyStats(source, target)
  index = 0
  while index < miniquake2.game.constants.MAX_STATS
    target[index] = source[index]
    index = index + 1
  end while
  return target
end function

function G_SetSpectatorStats(context, player)
  if player.chaseTarget is void then G_SetStats(context, player)
  else copyStats(player.chaseTarget.edict.client.playerState.stats, player.edict.client.playerState.stats)
  end if
  stats = player.edict.client.playerState.stats
  stats[miniquake2.game.constants.STAT_SPECTATOR] = 1
  layout = 0
  if player.health <= 0 or context.intermissionTime > 0.0 or player.showScores then layout = layout | 1 end if
  if player.showInventory and player.health > 0 then layout = layout | 2 end if
  stats[miniquake2.game.constants.STAT_LAYOUTS] = layout
  if player.chaseTarget is not void and player.chaseTarget.edict.inUse then stats[miniquake2.game.constants.STAT_CHASE] = miniquake2.qcommon.constants.CS_PLAYERSKINS + player.chaseTarget.edict.state.number - 1
  else stats[miniquake2.game.constants.STAT_CHASE] = 0
  end if
  return stats
end function

function G_CheckChaseStats(context, target)
  updated = 0
  for each player in context.players
    if player.edict.inUse and player.chaseTarget is not void and nativeRawValue(player.chaseTarget) == nativeRawValue(target) then
      copyStats(target.edict.client.playerState.stats, player.edict.client.playerState.stats)
      G_SetSpectatorStats(context, player)
      updated = updated + 1
    end if
  end for
  return updated
end function

function ClientEndServerFrame(context, player)
  state = player.edict.client.playerState
  state.pmove.origin = [qbyteio.truncInt(player.edict.state.origin.x * 8.0), qbyteio.truncInt(player.edict.state.origin.y * 8.0), qbyteio.truncInt(player.edict.state.origin.z * 8.0)]
  state.pmove.velocity = [qbyteio.truncInt(player.velocity[0] * 8.0), qbyteio.truncInt(player.velocity[1] * 8.0), qbyteio.truncInt(player.velocity[2] * 8.0)]
  if context.intermissionTime > 0.0 then
    state.blend[3] = 0.0
    state.fov = 90.0
  else
    gplayerview.ClientViewFrame(context, player)
  end if
  player.persistent.health = player.health
  if player.respawn.spectator then G_SetSpectatorStats(context, player)
  else G_SetStats(context, player)
  end if
  G_CheckChaseStats(context, player)
  return state
end function

function ClientEndServerFrames(context)
  count = 0
  for each player in context.players
    if player.edict.inUse and player.persistent.connected then ClientEndServerFrame(context, player); count = count + 1 end if
  end for
  return count
end function
