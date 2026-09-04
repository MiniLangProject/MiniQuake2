//! Provides miniquake2 game gameplay item rules facilities for this project.

/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Item pickup, use, drop, ammo and deterministic respawn rules from g_items.c. */
package miniquake2.game.gameplay.item_rules

import miniquake2.game.constants as gconstants
import miniquake2.game.gameplay.constants as gpconstants
import miniquake2.game.gameplay.types as gptypes
import miniquake2.qcommon.text as qtext

/// Finds by pickup name used by the miniquake2 game gameplay item rules module.
/// @param registry registry value consumed by this operation.
/// @param pickupName pickupName value consumed by this operation.
function findByPickupName(registry, pickupName)
  if typeof(pickupName) != "string" then return error(9392, "item pickup name is not text") end if
  for each item in registry.items
    gpitemPickupHolder = item.pickupName
    if typeof(gpitemPickupHolder) != "string" then return error(9393, "item registry pickup name is not text") end if
    if qtext.equalInsensitive(gpitemPickupHolder, pickupName) then return item end if
  end for
  return void
end function

/// Find by class name.
/// @param registry registry value consumed by this operation.
/// @param className className value consumed by this operation.
function findByClassName(registry, className)
  if typeof(className) != "string" then return error(9394, "item classname is not text") end if
  for each item in registry.items
    gpitemClassHolder = item.className
    if typeof(gpitemClassHolder) != "string" then return error(9395, "item registry classname is not text") end if
    if qtext.equalInsensitive(gpitemClassHolder, className) then return item end if
  end for
  return void
end function

/// Return by index.
/// @param registry registry value consumed by this operation.
/// @param index Zero-based index of the affected item.
function getByIndex(registry, index)
  // Stock itemlist indices are dense and match their array position. Weapon
  // cycling calls this once for every candidate slot, so use the direct path
  // instead of turning one mouse-wheel notch into an O(items squared) scan.
  // Custom registries remain supported by the bounded compatibility fallback.
  if typeof(index) == "int" and index > 0 and index <= len(registry.items) then
    direct = registry.items[index - 1]
    if direct.index == index then return direct end if
  end if
  for each item in registry.items
    if item.index == index then return item end if
  end for
  return void
end function

/// Return the inventory count.
/// @param player player value consumed by this operation.
/// @param item item value consumed by this operation.
function inventoryCount(player, item)
  if item is void then return 0 end if
  if item.index <= 0 or item.index >= len(player.inventory.counts) then return error(9300, "item index outside inventory") end if
  return player.inventory.counts[item.index]
end function

/// Return the ammo maximum value.
/// @param inventory inventory value consumed by this operation.
/// @param tag tag value consumed by this operation.
function ammoMaximum(inventory, tag)
  if tag == gpconstants.AMMO_BULLETS then return inventory.maxBullets end if
  if tag == gpconstants.AMMO_SHELLS then return inventory.maxShells end if
  if tag == gpconstants.AMMO_ROCKETS then return inventory.maxRockets end if
  if tag == gpconstants.AMMO_GRENADES then return inventory.maxGrenades end if
  if tag == gpconstants.AMMO_CELLS then return inventory.maxCells end if
  if tag == gpconstants.AMMO_SLUGS then return inventory.maxSlugs end if
  return error(9301, "unknown ammo tag " + tag)
end function

/// Add ammo.
/// @param player player value consumed by this operation.
/// @param item item value consumed by this operation.
/// @param count Number of items or units to process.
function Add_Ammo(player, item, count)
  if typeof(player) != "struct" or typeof(item) != "struct" then return error(9302, "Add_Ammo: player and item required") end if
  if (item.flags & gpconstants.IT_AMMO) == 0 then return error(9303, "Add_Ammo: item is not ammo") end if
  if typeof(count) != "int" or count < 0 then return error(9304, "Add_Ammo: non-negative integer count required") end if
  maximum = ammoMaximum(player.inventory, item.tag)
  oldCount = inventoryCount(player, item)
  if oldCount == maximum then return false end if
  newCount = oldCount + count
  if newCount > maximum then newCount = maximum end if
  player.inventory.counts[item.index] = newCount
  return true
end function

/// Set respawn.
/// @param itemEntity itemEntity value consumed by this operation.
/// @param delay delay value consumed by this operation.
/// @param time time value consumed by this operation.
function SetRespawn(itemEntity, delay, time)
  if delay < 0.0 then return error(9305, "SetRespawn: negative delay") end if
  itemEntity.flags = itemEntity.flags | gpconstants.FL_RESPAWN
  itemEntity.edict.serverFlags = itemEntity.edict.serverFlags | gconstants.SVF_NOCLIENT
  itemEntity.edict.solid = gconstants.SOLID_NOT
  itemEntity.hidden = true
  itemEntity.nextThink = time + delay
  itemEntity.respawnAt = itemEntity.nextThink
  return true
end function

/// Return the do respawn value.
/// @param itemEntity itemEntity value consumed by this operation.
/// @param time time value consumed by this operation.
function DoRespawn(itemEntity, time)
  if itemEntity.hidden != true then return error(9306, "DoRespawn: item is not waiting for respawn") end if
  if time < itemEntity.respawnAt then return false end if
  itemEntity.edict.serverFlags = itemEntity.edict.serverFlags & ~gconstants.SVF_NOCLIENT
  itemEntity.edict.solid = gconstants.SOLID_TRIGGER
  itemEntity.edict.state.event = gconstants.EV_ITEM_RESPAWN
  itemEntity.hidden = false
  itemEntity.nextThink = 0.0
  return true
end function

/// Pick up ammo.
/// @param itemEntity itemEntity value consumed by this operation.
/// @param player player value consumed by this operation.
/// @param context Context that carries state for the operation.
/// @param registry registry value consumed by this operation.
function Pickup_Ammo(itemEntity, player, context, registry)
  item = itemEntity.item
  count = item.quantity
  if itemEntity.count > 0 then count = itemEntity.count end if
  if (item.flags & gpconstants.IT_WEAPON) != 0 and (context.dmFlags & gconstants.DF_INFINITE_AMMO) != 0 then count = 1000 end if
  oldCount = inventoryCount(player, item)
  if Add_Ammo(player, item, count) != true then return gptypes.itemAction(false, "ammo full", 0) end if
  if (item.flags & gpconstants.IT_WEAPON) != 0 and oldCount == 0 then
    blaster = findByPickupName(registry, "Blaster")
    if player.currentWeapon is void or context.deathmatch != true or player.currentWeapon.index == blaster.index then player.newWeapon = item end if
  end if
  action = gptypes.itemAction(true, "", inventoryCount(player, item) - oldCount)
  if (itemEntity.spawnFlags & (gpconstants.DROPPED_ITEM | gpconstants.DROPPED_PLAYER_ITEM)) == 0 and context.deathmatch then
    SetRespawn(itemEntity, 30.0, context.time)
    action.respawnScheduled = true
  end if
  return action
end function

/// Pick up weapon.
/// @param itemEntity itemEntity value consumed by this operation.
/// @param player player value consumed by this operation.
/// @param context Context that carries state for the operation.
/// @param registry registry value consumed by this operation.
function Pickup_Weapon(itemEntity, player, context, registry)
  item = itemEntity.item
  oldCount = inventoryCount(player, item)
  stays = (context.dmFlags & gconstants.DF_WEAPONS_STAY) != 0 or context.cooperative
  dropped = (itemEntity.spawnFlags & (gpconstants.DROPPED_ITEM | gpconstants.DROPPED_PLAYER_ITEM)) != 0
  if stays and oldCount > 0 and not dropped then return gptypes.itemAction(false, "weapon stays", 0) end if
  player.inventory.counts[item.index] = oldCount + 1
  if (itemEntity.spawnFlags & gpconstants.DROPPED_ITEM) == 0 and item.ammo != "" then
    ammo = findByPickupName(registry, item.ammo)
    if ammo is not void then
      amount = ammo.quantity
      if (context.dmFlags & gconstants.DF_INFINITE_AMMO) != 0 then amount = 1000 end if
      Add_Ammo(player, ammo, amount)
    end if
  end if
  action = gptypes.itemAction(true, "", 1)
  if (itemEntity.spawnFlags & gpconstants.DROPPED_PLAYER_ITEM) == 0 then
    if context.deathmatch then
      if (context.dmFlags & gconstants.DF_WEAPONS_STAY) != 0 then itemEntity.flags = itemEntity.flags | gpconstants.FL_RESPAWN
      else SetRespawn(itemEntity, 30.0, context.time); action.respawnScheduled = true
      end if
    else if context.cooperative then itemEntity.flags = itemEntity.flags | gpconstants.FL_RESPAWN
    end if
  end if
  blaster = findByPickupName(registry, "Blaster")
  if (player.currentWeapon is void or player.currentWeapon.index != item.index) and oldCount == 0 then
    if context.deathmatch != true or player.currentWeapon is void or player.currentWeapon.index == blaster.index then player.newWeapon = item end if
  end if
  return action
end function

/// Pick up item.
/// @param itemEntity itemEntity value consumed by this operation.
/// @param player player value consumed by this operation.
/// @param context Context that carries state for the operation.
/// @param registry registry value consumed by this operation.
function Pickup_Item(itemEntity, player, context, registry)
  if itemEntity.item.pickup is void then return gptypes.itemAction(false, "item cannot be picked up", 0) end if
  return itemEntity.item.pickup(itemEntity, player, context, registry)
end function

/// Use weapon.
/// @param player player value consumed by this operation.
/// @param item item value consumed by this operation.
/// @param registry registry value consumed by this operation.
/// @param selectEmpty selectEmpty value consumed by this operation.
function Use_Weapon(player, item, registry, selectEmpty)
  if player.currentWeapon is not void and player.currentWeapon.index == item.index then return gptypes.itemAction(false, "already selected", 0) end if
  if item.ammo != "" and selectEmpty != true and (item.flags & gpconstants.IT_AMMO) == 0 then
    ammo = findByPickupName(registry, item.ammo)
    available = inventoryCount(player, ammo)
    if available == 0 then return gptypes.itemAction(false, "no ammo", 0) end if
    if available < item.quantity then return gptypes.itemAction(false, "not enough ammo", 0) end if
  end if
  player.newWeapon = item
  return gptypes.itemAction(true, "", 0)
end function

/// Drop ammo.
/// @param player player value consumed by this operation.
/// @param item item value consumed by this operation.
/// @param registry registry value consumed by this operation.
/// @param worldEntityNumber worldEntityNumber value consumed by this operation.
function Drop_Ammo(player, item, registry, worldEntityNumber)
  available = inventoryCount(player, item)
  if available <= 0 then return gptypes.itemAction(false, "no ammo to drop", 0) end if
  amount = item.quantity
  if amount > available then amount = available end if
  if player.currentWeapon is not void and player.currentWeapon.weaponModel == gpconstants.WEAP_GRENADES and item.tag == gpconstants.AMMO_GRENADES and available - amount <= 0 then
    return gptypes.itemAction(false, "cannot drop current grenade weapon", 0)
  end if
  dropped = gptypes.createItemEntity(worldEntityNumber, item)
  dropped.count = amount
  dropped.spawnFlags = gpconstants.DROPPED_ITEM
  dropped.edict.solid = gconstants.SOLID_TRIGGER
  player.inventory.counts[item.index] = available - amount
  action = gptypes.itemAction(true, "", amount)
  action.droppedEntity = dropped
  return action
end function

/// Drop weapon.
/// @param player player value consumed by this operation.
/// @param item item value consumed by this operation.
/// @param registry registry value consumed by this operation.
/// @param worldEntityNumber worldEntityNumber value consumed by this operation.
/// @param dmFlags dmFlags value consumed by this operation.
function Drop_Weapon(player, item, registry, worldEntityNumber, dmFlags)
  if (dmFlags & gconstants.DF_WEAPONS_STAY) != 0 then return gptypes.itemAction(false, "weapons stay", 0) end if
  available = inventoryCount(player, item)
  selected = player.currentWeapon is not void and player.currentWeapon.index == item.index
  pending = player.newWeapon is not void and player.newWeapon.index == item.index
  if (selected or pending) and available == 1 then return gptypes.itemAction(false, "cannot drop current weapon", 0) end if
  if available <= 0 then return gptypes.itemAction(false, "weapon not owned", 0) end if
  dropped = gptypes.createItemEntity(worldEntityNumber, item)
  dropped.count = 1
  dropped.spawnFlags = gpconstants.DROPPED_ITEM
  dropped.edict.solid = gconstants.SOLID_TRIGGER
  player.inventory.counts[item.index] = available - 1
  action = gptypes.itemAction(true, "", 1)
  action.droppedEntity = dropped
  return action
end function
