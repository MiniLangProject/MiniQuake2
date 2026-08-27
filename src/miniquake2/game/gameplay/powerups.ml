/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Stock BaseQ2 armor, health, powerup, capacity and key rules from g_items.c. */
package miniquake2.game.gameplay.powerups

import miniquake2.game.gameplay.constants as gpconstants
import miniquake2.game.gameplay.item_rules as gprules
import miniquake2.game.gameplay.types as gptypes
import miniquake2.qcommon.byteio as qbyteio

// Return the metadata value.
function metadata(item, expectedKind)
  if item.ruleData is void or item.ruleData.kind != expectedKind then return error(9420, item.className + ": expected " + expectedKind + " metadata") end if
  return item.ruleData
end function

// Return the armor item value.
function armorItem(registry, tag)
  for each item in registry.items
    if item.ruleData is not void and item.ruleData.kind == "armor" and item.tag == tag then return item end if
  end for
  return void
end function

// Return the armor index.
function ArmorIndex(player, registry)
  jacket = armorItem(registry, gpconstants.ARMOR_JACKET)
  combat = armorItem(registry, gpconstants.ARMOR_COMBAT)
  body = armorItem(registry, gpconstants.ARMOR_BODY)
  if jacket is not void and player.inventory.counts[jacket.index] > 0 then return jacket.index end if
  if combat is not void and player.inventory.counts[combat.index] > 0 then return combat.index end if
  if body is not void and player.inventory.counts[body.index] > 0 then return body.index end if
  return 0
end function

// Return the armor by index.
function armorByIndex(registry, index)
  item = gprules.getByIndex(registry, index)
  if item is void or item.ruleData is void or item.ruleData.kind != "armor" then return void end if
  return item
end function

// Pick up armor.
function Pickup_Armor(itemEntity, player, context, registry)
  // Keep pickup armor phases explicit: validate inputs, update owned state, then publish the result.
  if context.deathmatch and (context.dmFlags & miniquake2.game.constants.DF_NO_ARMOR) != 0 then return gptypes.itemAction(false, "armor disabled", 0) end if
  item = itemEntity.item
  oldIndex = ArmorIndex(player, registry)
  if item.tag == gpconstants.ARMOR_SHARD then
    if oldIndex == 0 then
      jacket = armorItem(registry, gpconstants.ARMOR_JACKET)
      if jacket is void then return error(9421, "Jacket Armor missing from registry") end if
      player.inventory.counts[jacket.index] = 2
      player.armorIndex = jacket.index
    else
      player.inventory.counts[oldIndex] = player.inventory.counts[oldIndex] + 2
      player.armorIndex = oldIndex
    end if
  else
    newInfo = metadata(item, "armor")
    if oldIndex == 0 then
      player.inventory.counts[item.index] = newInfo.armorBase
      player.armorIndex = item.index
    else
      oldItem = armorByIndex(registry, oldIndex)
      oldInfo = metadata(oldItem, "armor")
      if newInfo.normalProtection > oldInfo.normalProtection then
        salvage = oldInfo.normalProtection / newInfo.normalProtection
        salvageCount = qbyteio.truncInt(salvage * player.inventory.counts[oldIndex])
        newCount = newInfo.armorBase + salvageCount
        if newCount > newInfo.armorMax then newCount = newInfo.armorMax end if
        player.inventory.counts[oldIndex] = 0
        player.inventory.counts[item.index] = newCount
        player.armorIndex = item.index
      else
        salvage = newInfo.normalProtection / oldInfo.normalProtection
        salvageCount = qbyteio.truncInt(salvage * newInfo.armorBase)
        newCount = player.inventory.counts[oldIndex] + salvageCount
        if newCount > oldInfo.armorMax then newCount = oldInfo.armorMax end if
        if player.inventory.counts[oldIndex] >= newCount then return gptypes.itemAction(false, "armor already full", 0) end if
        player.inventory.counts[oldIndex] = newCount
        player.armorIndex = oldIndex
      end if
    end if
  end if
  action = gptypes.itemAction(true, "", 1)
  if context.deathmatch and (itemEntity.spawnFlags & gpconstants.DROPPED_ITEM) == 0 then gprules.SetRespawn(itemEntity, 20.0, context.time); action.respawnScheduled = true end if
  return action
end function

// Return the power armor type value.
function PowerArmorType(player, registry)
  if (player.flags & gpconstants.FL_POWER_ARMOR) == 0 then return gpconstants.POWER_ARMOR_NONE end if
  shield = gprules.findByPickupName(registry, "Power Shield")
  screen = gprules.findByPickupName(registry, "Power Screen")
  if shield is not void and player.inventory.counts[shield.index] > 0 then return gpconstants.POWER_ARMOR_SHIELD end if
  if screen is not void and player.inventory.counts[screen.index] > 0 then return gpconstants.POWER_ARMOR_SCREEN end if
  return gpconstants.POWER_ARMOR_NONE
end function

// Cell consumption half of g_combat.c::CheckPowerArmor. The screen-facing
// test is supplied by the caller because this package does not own view axes.
function CheckPowerArmor(player, registry, damage, damageFlags, inFront)
  armorType = PowerArmorType(player, registry)
  if damage <= 0 or (damageFlags & gpconstants.DAMAGE_NO_ARMOR) != 0 or armorType == gpconstants.POWER_ARMOR_NONE then return gptypes.PowerArmorResult(0, 0, armorType) end if
  cells = gprules.findByPickupName(registry, "Cells")
  if cells is void then return error(9422, "Cells missing from power armor registry") end if
  power = player.inventory.counts[cells.index]
  if power <= 0 then return gptypes.PowerArmorResult(0, 0, armorType) end if
  damagePerCell = 0
  maximumSave = 0
  if armorType == gpconstants.POWER_ARMOR_SCREEN then
    if inFront != true then return gptypes.PowerArmorResult(0, 0, armorType) end if
    damagePerCell = 1
    maximumSave = qbyteio.truncInt(damage / 3)
  else
    damagePerCell = 2
    maximumSave = qbyteio.truncInt((2 * damage) / 3)
  end if
  saved = power * damagePerCell
  if saved > maximumSave then saved = maximumSave end if
  cellsUsed = qbyteio.truncInt(saved / damagePerCell)
  player.inventory.counts[cells.index] = power - cellsUsed
  return gptypes.PowerArmorResult(saved, cellsUsed, armorType)
end function

// Use power armor.
function Use_PowerArmor(player, item, context, registry)
  if (player.flags & gpconstants.FL_POWER_ARMOR) != 0 then
    player.flags = player.flags & ~gpconstants.FL_POWER_ARMOR
    return gptypes.itemAction(true, "power armor disabled", 0)
  end if
  cells = gprules.findByPickupName(registry, "Cells")
  if cells is void or player.inventory.counts[cells.index] <= 0 then return gptypes.itemAction(false, "no cells for power armor", 0) end if
  player.flags = player.flags | gpconstants.FL_POWER_ARMOR
  return gptypes.itemAction(true, "power armor enabled", 0)
end function

// Pick up power armor.
function Pickup_PowerArmor(itemEntity, player, context, registry)
  if context.deathmatch and (context.dmFlags & miniquake2.game.constants.DF_NO_ARMOR) != 0 then return gptypes.itemAction(false, "armor disabled", 0) end if
  item = itemEntity.item
  oldCount = player.inventory.counts[item.index]
  player.inventory.counts[item.index] = oldCount + 1
  action = gptypes.itemAction(true, "", 1)
  if context.deathmatch then
    if (itemEntity.spawnFlags & gpconstants.DROPPED_ITEM) == 0 then gprules.SetRespawn(itemEntity, item.quantity * 1.0, context.time); action.respawnScheduled = true end if
    if oldCount == 0 then Use_PowerArmor(player, item, context, registry) end if
  end if
  return action
end function

// Drop general.
function Drop_General(player, item, registry, worldEntityNumber)
  if player.inventory.counts[item.index] <= 0 then return gptypes.itemAction(false, "item not owned", 0) end if
  dropped = gptypes.createItemEntity(worldEntityNumber, item)
  dropped.spawnFlags = gpconstants.DROPPED_ITEM
  dropped.edict.solid = miniquake2.game.constants.SOLID_TRIGGER
  player.inventory.counts[item.index] = player.inventory.counts[item.index] - 1
  action = gptypes.itemAction(true, "", 1)
  action.droppedEntity = dropped
  return action
end function

// Drop power armor.
function Drop_PowerArmor(player, item, registry, worldEntityNumber)
  if (player.flags & gpconstants.FL_POWER_ARMOR) != 0 and player.inventory.counts[item.index] == 1 then
    temporary = gptypes.pickupContext(false, false, 0, 0.0)
    Use_PowerArmor(player, item, temporary, registry)
  end if
  return Drop_General(player, item, registry, worldEntityNumber)
end function

// Consume powerup.
function consumePowerup(player, item)
  if player.inventory.counts[item.index] <= 0 then return false end if
  player.inventory.counts[item.index] = player.inventory.counts[item.index] - 1
  if player.inventory.selectedItem == item.index and player.inventory.counts[item.index] == 0 then player.inventory.selectedItem = 0 end if
  return true
end function

// Return the extend frame value.
function extendFrame(existing, current, duration)
  if existing > current then return existing + duration end if
  return current + duration
end function

// Use quad.
function Use_Quad(player, item, context, registry)
  if consumePowerup(player, item) != true then return gptypes.itemAction(false, "quad not owned", 0) end if
  duration = 300
  if context.quadDropFrames > 0 then duration = context.quadDropFrames; context.quadDropFrames = 0 end if
  player.quadFrame = extendFrame(player.quadFrame, context.frameNumber, duration)
  return gptypes.itemAction(true, "", duration)
end function

// Use invulnerability.
function Use_Invulnerability(player, item, context, registry)
  if consumePowerup(player, item) != true then return gptypes.itemAction(false, "invulnerability not owned", 0) end if
  player.invincibleFrame = extendFrame(player.invincibleFrame, context.frameNumber, 300)
  return gptypes.itemAction(true, "", 300)
end function

// Use breather.
function Use_Breather(player, item, context, registry)
  if consumePowerup(player, item) != true then return gptypes.itemAction(false, "rebreather not owned", 0) end if
  player.breatherFrame = extendFrame(player.breatherFrame, context.frameNumber, 300)
  return gptypes.itemAction(true, "", 300)
end function

// Use envirosuit.
function Use_Envirosuit(player, item, context, registry)
  if consumePowerup(player, item) != true then return gptypes.itemAction(false, "environment suit not owned", 0) end if
  player.enviroFrame = extendFrame(player.enviroFrame, context.frameNumber, 300)
  return gptypes.itemAction(true, "", 300)
end function

// Use silencer.
function Use_Silencer(player, item, context, registry)
  if consumePowerup(player, item) != true then return gptypes.itemAction(false, "silencer not owned", 0) end if
  player.silencerShots = player.silencerShots + 30
  return gptypes.itemAction(true, "", 30)
end function

// Pick up powerup.
function Pickup_Powerup(itemEntity, player, context, registry)
  if context.deathmatch and (context.dmFlags & miniquake2.game.constants.DF_NO_ITEMS) != 0 then return gptypes.itemAction(false, "items disabled", 0) end if
  item = itemEntity.item
  quantity = player.inventory.counts[item.index]
  if (context.skill == 1 and quantity >= 2) or (context.skill >= 2 and quantity >= 1) then return gptypes.itemAction(false, "skill powerup limit", 0) end if
  if context.cooperative and (item.flags & gpconstants.IT_STAY_COOP) != 0 and quantity > 0 then return gptypes.itemAction(false, "coop powerup stays", 0) end if
  player.inventory.counts[item.index] = quantity + 1
  action = gptypes.itemAction(true, "", 1)
  if context.deathmatch then
    if (itemEntity.spawnFlags & gpconstants.DROPPED_ITEM) == 0 then gprules.SetRespawn(itemEntity, item.quantity * 1.0, context.time); action.respawnScheduled = true end if
    instant = (context.dmFlags & miniquake2.game.constants.DF_INSTANT_ITEMS) != 0
    droppedQuad = item.use == Use_Quad and (itemEntity.spawnFlags & gpconstants.DROPPED_PLAYER_ITEM) != 0
    if instant or droppedQuad then
      if droppedQuad and itemEntity.nextThink > context.time then context.quadDropFrames = qbyteio.truncInt((itemEntity.nextThink - context.time) / 0.1) end if
      item.use(player, item, context, registry)
    end if
  end if
  return action
end function

// Pick up adrenaline.
function Pickup_Adrenaline(itemEntity, player, context, registry)
  if context.deathmatch != true then player.maxHealth = player.maxHealth + 1 end if
  if player.health < player.maxHealth then player.health = player.maxHealth end if
  action = gptypes.itemAction(true, "", 1)
  if context.deathmatch and (itemEntity.spawnFlags & gpconstants.DROPPED_ITEM) == 0 then gprules.SetRespawn(itemEntity, itemEntity.item.quantity * 1.0, context.time); action.respawnScheduled = true end if
  return action
end function

// Pick up ancient head.
function Pickup_AncientHead(itemEntity, player, context, registry)
  player.maxHealth = player.maxHealth + 2
  action = gptypes.itemAction(true, "", 2)
  if context.deathmatch and (itemEntity.spawnFlags & gpconstants.DROPPED_ITEM) == 0 then gprules.SetRespawn(itemEntity, itemEntity.item.quantity * 1.0, context.time); action.respawnScheduled = true end if
  return action
end function

// Return the grant ammo value.
function grantAmmo(player, registry, name)
  item = gprules.findByPickupName(registry, name)
  if item is not void then gprules.Add_Ammo(player, item, item.quantity) end if
  return true
end function

// Pick up bandolier.
function Pickup_Bandolier(itemEntity, player, context, registry)
  if player.inventory.maxBullets < 250 then player.inventory.maxBullets = 250 end if
  if player.inventory.maxShells < 150 then player.inventory.maxShells = 150 end if
  if player.inventory.maxCells < 250 then player.inventory.maxCells = 250 end if
  if player.inventory.maxSlugs < 75 then player.inventory.maxSlugs = 75 end if
  grantAmmo(player, registry, "Bullets")
  grantAmmo(player, registry, "Shells")
  action = gptypes.itemAction(true, "", 1)
  if context.deathmatch and (itemEntity.spawnFlags & gpconstants.DROPPED_ITEM) == 0 then gprules.SetRespawn(itemEntity, itemEntity.item.quantity * 1.0, context.time); action.respawnScheduled = true end if
  return action
end function

// Pick up pack.
function Pickup_Pack(itemEntity, player, context, registry)
  if player.inventory.maxBullets < 300 then player.inventory.maxBullets = 300 end if
  if player.inventory.maxShells < 200 then player.inventory.maxShells = 200 end if
  if player.inventory.maxRockets < 100 then player.inventory.maxRockets = 100 end if
  if player.inventory.maxGrenades < 100 then player.inventory.maxGrenades = 100 end if
  if player.inventory.maxCells < 300 then player.inventory.maxCells = 300 end if
  if player.inventory.maxSlugs < 100 then player.inventory.maxSlugs = 100 end if
  grantAmmo(player, registry, "Bullets")
  grantAmmo(player, registry, "Shells")
  grantAmmo(player, registry, "Cells")
  grantAmmo(player, registry, "Grenades")
  grantAmmo(player, registry, "Rockets")
  grantAmmo(player, registry, "Slugs")
  action = gptypes.itemAction(true, "", 1)
  if context.deathmatch and (itemEntity.spawnFlags & gpconstants.DROPPED_ITEM) == 0 then gprules.SetRespawn(itemEntity, itemEntity.item.quantity * 1.0, context.time); action.respawnScheduled = true end if
  return action
end function

// Pick up key.
function Pickup_Key(itemEntity, player, context, registry)
  item = itemEntity.item
  if context.cooperative then
    if item.className == "key_power_cube" then
      cube = (itemEntity.spawnFlags & 0x0000ff00) >> 8
      if (player.powerCubes & cube) != 0 then return gptypes.itemAction(false, "power cube already owned", 0) end if
      player.inventory.counts[item.index] = player.inventory.counts[item.index] + 1
      player.powerCubes = player.powerCubes | cube
    else
      if player.inventory.counts[item.index] != 0 then return gptypes.itemAction(false, "coop key already owned", 0) end if
      player.inventory.counts[item.index] = 1
    end if
  else player.inventory.counts[item.index] = player.inventory.counts[item.index] + 1
  end if
  return gptypes.itemAction(true, "", 1)
end function

// Pick up health.
function Pickup_Health(itemEntity, player, context, registry)
  if context.deathmatch and (context.dmFlags & miniquake2.game.constants.DF_NO_HEALTH) != 0 then return gptypes.itemAction(false, "health disabled", 0) end if
  info = metadata(itemEntity.item, "health")
  count = info.healthCount
  if itemEntity.count > 0 then count = itemEntity.count end if
  if (info.healthStyle & gpconstants.HEALTH_IGNORE_MAX) == 0 and player.health >= player.maxHealth then return gptypes.itemAction(false, "health already full", 0) end if
  oldHealth = player.health
  player.health = player.health + count
  if (info.healthStyle & gpconstants.HEALTH_IGNORE_MAX) == 0 and player.health > player.maxHealth then player.health = player.maxHealth end if
  action = gptypes.itemAction(true, "", player.health - oldHealth)
  if (info.healthStyle & gpconstants.HEALTH_TIMED) != 0 then
    itemEntity.owner = player
    itemEntity.decaying = true
    itemEntity.nextThink = context.time + 5.0
    itemEntity.flags = itemEntity.flags | gpconstants.FL_RESPAWN
    itemEntity.edict.serverFlags = itemEntity.edict.serverFlags | miniquake2.game.constants.SVF_NOCLIENT
    itemEntity.edict.solid = miniquake2.game.constants.SOLID_NOT
    itemEntity.hidden = true
  else if context.deathmatch and (itemEntity.spawnFlags & gpconstants.DROPPED_ITEM) == 0 then
    gprules.SetRespawn(itemEntity, 30.0, context.time)
    action.respawnScheduled = true
  end if
  return action
end function

// Run mega health.
function MegaHealthThink(itemEntity, context)
  if itemEntity.decaying != true or itemEntity.owner is void then return false end if
  if context.time < itemEntity.nextThink then return false end if
  owner = itemEntity.owner
  if owner.health > owner.maxHealth then
    owner.health = owner.health - 1
    itemEntity.nextThink = context.time + 1.0
    return true
  end if
  itemEntity.decaying = false
  itemEntity.owner = void
  if context.deathmatch and (itemEntity.spawnFlags & gpconstants.DROPPED_ITEM) == 0 then gprules.SetRespawn(itemEntity, 20.0, context.time)
  else itemEntity.freed = true; itemEntity.edict.inUse = false
  end if
  return true
end function

// Synchronize from player data.
function SyncFromPlayerData(gameplayPlayer, playerData)
  gameplayPlayer.health = playerData.health
  gameplayPlayer.maxHealth = playerData.maxHealth
  gameplayPlayer.flags = playerData.flags
  gameplayPlayer.armorIndex = playerData.armorItemIndex
  gameplayPlayer.quadFrame = playerData.powerups.quadFrame
  gameplayPlayer.invincibleFrame = playerData.powerups.invincibleFrame
  gameplayPlayer.breatherFrame = playerData.powerups.breatherFrame
  gameplayPlayer.enviroFrame = playerData.powerups.enviroFrame
  return true
end function

// Synchronize to player data.
function SyncToPlayerData(gameplayPlayer, playerData)
  playerData.health = gameplayPlayer.health
  playerData.maxHealth = gameplayPlayer.maxHealth
  playerData.persistent.health = gameplayPlayer.health
  playerData.persistent.maxHealth = gameplayPlayer.maxHealth
  playerData.flags = gameplayPlayer.flags
  playerData.armorItemIndex = gameplayPlayer.armorIndex
  playerData.powerups.quadFrame = gameplayPlayer.quadFrame
  playerData.powerups.invincibleFrame = gameplayPlayer.invincibleFrame
  playerData.powerups.breatherFrame = gameplayPlayer.breatherFrame
  playerData.powerups.enviroFrame = gameplayPlayer.enviroFrame
  return true
end function

// Synchronize armor to combatant.
function SyncArmorToCombatant(player, combatant, registry)
  index = ArmorIndex(player, registry)
  item = armorByIndex(registry, index)
  if item is void then combatant.armor = 0; combatant.armorNormalProtection = 0.0; combatant.armorEnergyProtection = 0.0; return false end if
  info = metadata(item, "armor")
  combatant.armor = player.inventory.counts[index]
  combatant.armorNormalProtection = info.normalProtection
  combatant.armorEnergyProtection = info.energyProtection
  player.armorIndex = index
  return true
end function

// Synchronize armor from combatant.
function SyncArmorFromCombatant(player, combatant)
  if player.armorIndex > 0 then player.inventory.counts[player.armorIndex] = combatant.armor end if
  return true
end function

// Pick up for player data at skill.
function PickupForPlayerDataAtSkill(itemEntity, playerData, playerContext, skill)
  // g_items.c::Touch_Item rejects dead clients before invoking any pickup
  // callback, so inventory and one-shot items remain untouched by corpses.
  if playerData.health < 1 then return gptypes.itemAction(false, "dead player", 0) end if
  context = gptypes.pickupContext(playerContext.deathmatch, playerContext.cooperative, playerContext.dmFlags, playerContext.time)
  context.skill = skill
  context.frameNumber = playerContext.frameNumber
  SyncFromPlayerData(playerData.gameplay, playerData)
  oldQuadFrame = playerData.gameplay.quadFrame
  oldInvincibleFrame = playerData.gameplay.invincibleFrame
  oldPowerArmor = playerData.gameplay.flags & gpconstants.FL_POWER_ARMOR
  action = gprules.Pickup_Item(itemEntity, playerData.gameplay, context, playerContext.registry)
  SyncToPlayerData(playerData.gameplay, playerData)
  if action.success then
    activationSound = ""
    if playerData.gameplay.quadFrame != oldQuadFrame then
      activationSound = "items/damage.wav"
    else if playerData.gameplay.invincibleFrame != oldInvincibleFrame then
      activationSound = "items/protect.wav"
    else if (playerData.gameplay.flags & gpconstants.FL_POWER_ARMOR) !=
        oldPowerArmor then
      if (playerData.gameplay.flags & gpconstants.FL_POWER_ARMOR) != 0 then
        activationSound = "misc/power1.wav"
      else activationSound = "misc/power2.wav"
      end if
    end if
    if activationSound != "" then
      playerContext.imports.sound(playerData.edict,
        miniquake2.game.constants.CHAN_ITEM,
        playerContext.imports.soundIndex(activationSound), 1.0,
        miniquake2.game.constants.ATTN_NORM, 0.0)
    end if
    pickupSound = itemEntity.item.pickupSound
    if itemEntity.item.ruleData is not void and itemEntity.item.ruleData.kind == "health" then
      healthCount = itemEntity.count
      if healthCount <= 0 then healthCount = itemEntity.item.ruleData.healthCount end if
      if healthCount == 2 then pickupSound = "items/s_health.wav"
      else if healthCount == 10 then pickupSound = "items/n_health.wav"
      else if healthCount == 25 then pickupSound = "items/l_health.wav"
      else pickupSound = "items/m_health.wav"
      end if
    end if
    if pickupSound != "" then
      playerContext.imports.sound(playerData.edict, miniquake2.game.constants.CHAN_ITEM,
        playerContext.imports.soundIndex(pickupSound), 1.0,
        miniquake2.game.constants.ATTN_NORM, 0.0)
    end if
    playerData.view.bonusAlpha = 0.25
    playerData.edict.client.playerState.stats[miniquake2.game.constants.STAT_PICKUP_ICON] = playerContext.imports.imageIndex(itemEntity.item.icon)
    playerData.edict.client.playerState.stats[miniquake2.game.constants.STAT_PICKUP_STRING] = miniquake2.qcommon.constants.CS_ITEMS + itemEntity.item.index
    playerData.pickupMessageTime = playerContext.time + 3.0
    if itemEntity.item.use is not void then
      playerData.gameplay.inventory.selectedItem = itemEntity.item.index
      playerData.edict.client.playerState.stats[miniquake2.game.constants.STAT_SELECTED_ITEM] = itemEntity.item.index
    end if
  end if
  return action
end function

// Pick up for player data.
function PickupForPlayerData(itemEntity, playerData, playerContext)
  return PickupForPlayerDataAtSkill(itemEntity, playerData, playerContext, 1)
end function
