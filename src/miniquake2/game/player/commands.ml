/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Stock g_cmds.c player weapon-selection commands. */
package miniquake2.game.player.commands

import miniquake2.game.gameplay.constants as gpcconstants
import miniquake2.game.gameplay.item_rules as gpcitems
import miniquake2.game.gameplay.powerups as gpcpowerups
import miniquake2.game.gameplay.types as gpctypes
import miniquake2.game.player.constants as gpcplayerconstants
import miniquake2.game.player.rules as gpcplayerrules
import miniquake2.game.constants as gpcgameconstants

function ownedWeapon(player, item)
  return item is not void and item.use is not void and
    (item.flags & gpcconstants.IT_WEAPON) != 0 and
    item.index > 0 and item.index < len(player.gameplay.inventory.counts) and
    player.gameplay.inventory.counts[item.index] > 0
end function

function useWeapon(player, registry, pickupName)
  item = gpcitems.findByPickupName(registry, pickupName)
  if not ownedWeapon(player, item) then return false end if
  result = item.use(player.gameplay, item, registry, false)
  return result.success
end function

// g_cmds.c SelectNextItem/SelectPrevItem/ValidateSelectedItem.  The managed
// inventory and persistent selected-item fields are kept together because the
// HUD consumes the former while save/respawn state retains the latter.
function selectItem(player, registry, step, itemFlags)
  if step != -1 and step != 1 then
    return error(9701, "inventory selection step must be -1 or 1")
  end if
  if player.chaseTarget is not void then return false end if
  slots = len(player.gameplay.inventory.counts)
  current = player.gameplay.inventory.selectedItem
  offset = 1
  while offset <= slots
    index = current + step * offset
    while index < 0
      index = index + slots
    end while
    while index >= slots
      index = index - slots
    end while
    item = gpcitems.getByIndex(registry, index)
    matchesFlags = itemFlags == -1
    if item is not void and itemFlags != -1 then
      matchesFlags = (item.flags & itemFlags) != 0
    end if
    if item is not void and item.use is not void and matchesFlags and
        index < len(player.gameplay.inventory.counts) and
        player.gameplay.inventory.counts[index] > 0 then
      player.gameplay.inventory.selectedItem = index
      player.persistent.selectedItem = index
      return true
    end if
    offset = offset + 1
  end while
  player.gameplay.inventory.selectedItem = -1
  player.persistent.selectedItem = -1
  return false
end function

function selectNextItem(player, registry, itemFlags)
  return selectItem(player, registry, 1, itemFlags)
end function

function selectPreviousItem(player, registry, itemFlags)
  return selectItem(player, registry, -1, itemFlags)
end function

function validateSelectedItem(player, registry)
  index = player.gameplay.inventory.selectedItem
  if index >= 0 and index < len(player.gameplay.inventory.counts) and
      player.gameplay.inventory.counts[index] > 0 then return true end if
  return selectNextItem(player, registry, -1)
end function

// Cmd_Use_f is not weapon-only. Power armor and carried powerups use the
// existing g_items.c adapters and synchronize their public PlayerData fields.
function useItem(player, context, pickupName)
  item = gpcitems.findByPickupName(context.registry, pickupName)
  if item is void or item.use is void or item.index <= 0 or
      item.index >= len(player.gameplay.inventory.counts) or
      player.gameplay.inventory.counts[item.index] <= 0 then return false end if
  if (item.flags & gpcconstants.IT_WEAPON) != 0 then
    result = item.use(player.gameplay, item, context.registry, false)
    return result.success
  end if
  pickupContext = gpctypes.pickupContext(context.deathmatch,
    context.cooperative, context.dmFlags, context.time)
  pickupContext.frameNumber = context.frameNumber
  gpcpowerups.SyncFromPlayerData(player.gameplay, player)
  oldQuadFrame = player.gameplay.quadFrame
  oldInvincibleFrame = player.gameplay.invincibleFrame
  oldPowerArmor = player.gameplay.flags & gpcconstants.FL_POWER_ARMOR
  result = item.use(player.gameplay, item, pickupContext, context.registry)
  gpcpowerups.SyncToPlayerData(player.gameplay, player)
  if result.success then
    useSound = ""
    if player.gameplay.quadFrame != oldQuadFrame then useSound = "items/damage.wav"
    else if player.gameplay.invincibleFrame != oldInvincibleFrame then useSound = "items/protect.wav"
    else if (player.gameplay.flags & gpcconstants.FL_POWER_ARMOR) != oldPowerArmor then
      if (player.gameplay.flags & gpcconstants.FL_POWER_ARMOR) != 0 then
        useSound = "misc/power1.wav"
      else useSound = "misc/power2.wav"
      end if
    end if
    if useSound != "" then
      context.imports.sound(player.edict, gpcgameconstants.CHAN_ITEM,
        context.imports.soundIndex(useSound), 1.0,
        gpcgameconstants.ATTN_NORM, 0.0)
    end if
  end if
  return result.success
end function

function useSelectedItem(player, context)
  if not validateSelectedItem(player, context.registry) then return false end if
  item = gpcitems.getByIndex(context.registry,
    player.gameplay.inventory.selectedItem)
  if item is void then return false end if
  return useItem(player, context, item.pickupName)
end function

// Cmd_Drop_f/Cmd_InvDrop_f share this dispatch after their command-specific
// diagnostics.  Grenades are both IT_AMMO and IT_WEAPON, so ammo must win the
// arity decision exactly as its gitem_t drop pointer does in stock BaseQ2.
function dropDefinition(player, context, item, worldEntityNumber)
  if item is void or item.drop is void or item.index <= 0 or
      item.index >= len(player.gameplay.inventory.counts) or
      player.gameplay.inventory.counts[item.index] <= 0 then
    return gpctypes.itemAction(false, "item cannot be dropped", 0)
  end if
  if context.cooperative and
      (item.flags & gpcconstants.IT_STAY_COOP) != 0 then
    return gpctypes.itemAction(false, "item stays in cooperative play", 0)
  end if
  gpcpowerups.SyncFromPlayerData(player.gameplay, player)
  oldDropPowerArmor = player.gameplay.flags & gpcconstants.FL_POWER_ARMOR
  result = void
  if (item.flags & gpcconstants.IT_AMMO) != 0 then
    result = item.drop(player.gameplay, item, context.registry,
      worldEntityNumber)
  else if (item.flags & gpcconstants.IT_WEAPON) != 0 then
    result = item.drop(player.gameplay, item, context.registry,
      worldEntityNumber, context.dmFlags)
  else
    result = item.drop(player.gameplay, item, context.registry,
      worldEntityNumber)
  end if
  gpcpowerups.SyncToPlayerData(player.gameplay, player)
  if result.success and
      (player.gameplay.flags & gpcconstants.FL_POWER_ARMOR) !=
      oldDropPowerArmor then
    context.imports.sound(player.edict, gpcgameconstants.CHAN_ITEM,
      context.imports.soundIndex("misc/power2.wav"), 1.0,
      gpcgameconstants.ATTN_NORM, 0.0)
  end if
  if result.success then
    validateSelectedItem(player, context.registry)
    player.persistent.selectedItem = player.gameplay.inventory.selectedItem
  end if
  return result
end function

function dropItem(player, context, pickupName, worldEntityNumber)
  item = gpcitems.findByPickupName(context.registry, pickupName)
  if item is void then return gpctypes.itemAction(false, "unknown item", 0) end if
  return dropDefinition(player, context, item, worldEntityNumber)
end function

function dropSelectedItem(player, context, worldEntityNumber)
  if not validateSelectedItem(player, context.registry) then
    return gpctypes.itemAction(false, "no selected item", 0)
  end if
  item = gpcitems.getByIndex(context.registry,
    player.gameplay.inventory.selectedItem)
  return dropDefinition(player, context, item, worldEntityNumber)
end function

function toggleInventory(player)
  player.showScores = false
  player.showHelp = false
  player.showInventory = not player.showInventory
  return player.showInventory
end function

function toggleScore(player, context)
  player.showInventory = false
  player.showHelp = false
  if not context.deathmatch and not context.cooperative then return false end if
  player.showScores = not player.showScores
  return player.showScores
end function

function toggleHelp(player, context)
  if context.deathmatch then return toggleScore(player, context) end if
  player.showInventory = false
  player.showScores = false
  player.showHelp = not player.showHelp
  return player.showHelp
end function

function putAway(player)
  player.showScores = false
  player.showHelp = false
  player.showInventory = false
  return true
end function

function killPlayer(player, context)
  if context.time - player.respawnTime < 5.0 then return false end if
  player.flags = player.flags & ~gpcconstants.FL_GODMODE
  player.health = 0
  point = [player.edict.state.origin.x, player.edict.state.origin.y,
    player.edict.state.origin.z]
  gpcplayerrules.player_die(context, player, player, player, 100000, point,
    gpcplayerconstants.MOD_SUICIDE)
  return true
end function

function wave(player, choice)
  if (player.edict.client.playerState.pmove.flags &
      gpcgameconstants.PMF_DUCKED) != 0 then return "" end if
  if player.view.animPriority > gpcplayerconstants.ANIM_WAVE then return "" end if
  player.view.animPriority = gpcplayerconstants.ANIM_WAVE
  if choice == 0 then
    player.edict.state.frame = gpcplayerconstants.FRAME_FLIP_FIRST - 1
    player.view.animEnd = gpcplayerconstants.FRAME_FLIP_LAST
    return "flipoff"
  end if
  if choice == 1 then
    player.edict.state.frame = gpcplayerconstants.FRAME_SALUTE_FIRST - 1
    player.view.animEnd = gpcplayerconstants.FRAME_SALUTE_LAST
    return "salute"
  end if
  if choice == 2 then
    player.edict.state.frame = gpcplayerconstants.FRAME_TAUNT_FIRST - 1
    player.view.animEnd = gpcplayerconstants.FRAME_TAUNT_LAST
    return "taunt"
  end if
  if choice == 3 then
    player.edict.state.frame = gpcplayerconstants.FRAME_WAVE_FIRST - 1
    player.view.animEnd = gpcplayerconstants.FRAME_WAVE_LAST
    return "wave"
  end if
  player.edict.state.frame = gpcplayerconstants.FRAME_POINT_FIRST - 1
  player.view.animEnd = gpcplayerconstants.FRAME_POINT_LAST
  return "point"
end function

// g_cmds.c intentionally traverses the item table in opposite directions for
// WeapPrev and WeapNext.  Keep that externally visible order, while stopping
// at the first owned weapon whose ammo policy accepts the selection.
function cycleWeapon(player, registry, step)
  if step != -1 and step != 1 then return error(9700, "weapon cycle step must be -1 or 1") end if
  current = player.gameplay.currentWeapon
  if current is void then return false end if
  slots = len(player.gameplay.inventory.counts)
  offset = 1
  while offset <= slots
    index = current.index + step * offset
    while index < 0
      index = index + slots
    end while
    while index >= slots
      index = index - slots
    end while
    item = gpcitems.getByIndex(registry, index)
    if ownedWeapon(player, item) then
      result = item.use(player.gameplay, item, registry, false)
      if result.success then return true end if
    end if
    offset = offset + 1
  end while
  return false
end function

function weaponPrevious(player, registry)
  return cycleWeapon(player, registry, 1)
end function

function weaponNext(player, registry)
  return cycleWeapon(player, registry, -1)
end function

function weaponLast(player, registry)
  item = player.gameplay.lastWeapon
  if not ownedWeapon(player, item) then return false end if
  result = item.use(player.gameplay, item, registry, false)
  return result.success
end function
