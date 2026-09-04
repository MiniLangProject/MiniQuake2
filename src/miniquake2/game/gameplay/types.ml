//! Provides miniquake2 game gameplay types facilities for this project.

/*
Copyright (C) 1997-2001 Id Software, Inc.
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later

Managed gameplay components appended beside the stable game/types.ml ABI.
*/
package miniquake2.game.gameplay.types

import miniquake2.game.gameplay.constants as gpconstants
import miniquake2.game.types as gtypes
import miniquake2.qcommon.types as gpqtypes

/// Store weapon frames data.
struct WeaponFrames
  /// Stores the activate last value associated with weapon frames.
  activateLast
  /// Stores the fire last value associated with weapon frames.
  fireLast
  /// Stores the idle last value associated with weapon frames.
  idleLast
  /// Stores the deactivate last value associated with weapon frames.
  deactivateLast
  /// Stores the pause frames value associated with weapon frames.
  pauseFrames
  /// Stores the fire frames value associated with weapon frames.
  fireFrames
end struct

/// Function-valued equivalent of the relevant gitem_t portion.
struct ItemDefinition
  /// Stores the index value associated with item definition.
  index
  /// Stores the class name value associated with item definition.
  className
  /// Stores the pickup value associated with item definition.
  pickup
  /// Stores the use value associated with item definition.
  use
  /// Stores the drop value associated with item definition.
  drop
  /// Stores the weapon think value associated with item definition.
  weaponThink
  /// Stores the pickup sound value associated with item definition.
  pickupSound
  /// Stores the world model value associated with item definition.
  worldModel
  /// Stores the view model value associated with item definition.
  viewModel
  /// Stores the icon value associated with item definition.
  icon
  /// Stores the pickup name value associated with item definition.
  pickupName
  /// Stores the quantity value associated with item definition.
  quantity
  /// Stores the ammo value associated with item definition.
  ammo
  /// Stores the flags value associated with item definition.
  flags
  /// Stores the weapon model value associated with item definition.
  weaponModel
  /// Stores the tag value associated with item definition.
  tag
  /// Stores the precaches value associated with item definition.
  precaches
  /// Stores the weapon frames value associated with item definition.
  weaponFrames
  /// Stores the rule data value associated with item definition.
  ruleData
end struct

/// Store item rule data data.
struct ItemRuleData
  /// Stores the kind value associated with item rule data.
  kind
  /// Stores the armor base value associated with item rule data.
  armorBase
  /// Stores the armor max value associated with item rule data.
  armorMax
  /// Stores the normal protection value associated with item rule data.
  normalProtection
  /// Stores the energy protection value associated with item rule data.
  energyProtection
  /// Stores the health count value associated with item rule data.
  healthCount
  /// Stores the health style value associated with item rule data.
  healthStyle
  /// Stores the duration value associated with item rule data.
  duration
end struct

/// Store item registry data.
struct ItemRegistry
  /// Stores the items value associated with item registry.
  items
end struct

/// Store inventory data.
struct Inventory
  /// Stores the counts value associated with inventory.
  counts
  /// Stores the max bullets value associated with inventory.
  maxBullets
  /// Stores the max shells value associated with inventory.
  maxShells
  /// Stores the max rockets value associated with inventory.
  maxRockets
  /// Stores the max grenades value associated with inventory.
  maxGrenades
  /// Stores the max cells value associated with inventory.
  maxCells
  /// Stores the max slugs value associated with inventory.
  maxSlugs
  /// Stores the selected item value associated with inventory.
  selectedItem
end struct

/// Store gameplay player data.
struct GameplayPlayer
  /// Stores the edict value associated with gameplay player.
  edict
  /// Stores the inventory value associated with gameplay player.
  inventory
  /// Stores the current weapon value associated with gameplay player.
  currentWeapon
  /// Stores the last weapon value associated with gameplay player.
  lastWeapon
  /// Stores the new weapon value associated with gameplay player.
  newWeapon
  /// Stores the ammo index value associated with gameplay player.
  ammoIndex
  /// Stores the weapon state value associated with gameplay player.
  weaponState
  /// Stores the gun frame value associated with gameplay player.
  gunFrame
  /// Stores the buttons value associated with gameplay player.
  buttons
  /// Stores the latched buttons value associated with gameplay player.
  latchedButtons
  /// Stores the fire count value associated with gameplay player.
  fireCount
  /// Stores the health value associated with gameplay player.
  health
  /// Stores the max health value associated with gameplay player.
  maxHealth
  /// Stores the flags value associated with gameplay player.
  flags
  /// Stores the armor index value associated with gameplay player.
  armorIndex
  /// Stores the quad frame value associated with gameplay player.
  quadFrame
  /// Stores the invincible frame value associated with gameplay player.
  invincibleFrame
  /// Stores the breather frame value associated with gameplay player.
  breatherFrame
  /// Stores the enviro frame value associated with gameplay player.
  enviroFrame
  /// Stores the silencer shots value associated with gameplay player.
  silencerShots
  /// Stores the power cubes value associated with gameplay player.
  powerCubes
end struct

/// Store item entity data.
struct ItemEntity
  /// Stores the edict value associated with item entity.
  edict
  /// Stores the item value associated with item entity.
  item
  /// Stores the count value associated with item entity.
  count
  /// Stores the spawn flags value associated with item entity.
  spawnFlags
  /// Stores the flags value associated with item entity.
  flags
  /// Stores the next think value associated with item entity.
  nextThink
  /// Stores the hidden value associated with item entity.
  hidden
  /// Stores the respawn at value associated with item entity.
  respawnAt
  /// Stores the owner value associated with item entity.
  owner
  /// Stores the decaying value associated with item entity.
  decaying
  /// Stores the freed value associated with item entity.
  freed
  /// Stores the velocity value associated with item entity.
  velocity
  /// Stores the ground entity value associated with item entity.
  groundEntity
  /// Stores the ground link count value associated with item entity.
  groundLinkCount
  /// Stores the gravity value associated with item entity.
  gravity
  /// Stores the water type value associated with item entity.
  waterType
  /// Stores the water level value associated with item entity.
  waterLevel
  /// Stores the world target value associated with item entity.
  worldTarget
  /// Stores the spawn pending value associated with item entity.
  spawnPending
end struct

/// Store pickup context data.
struct PickupContext
  /// Stores the deathmatch value associated with pickup context.
  deathmatch
  /// Stores the cooperative value associated with pickup context.
  cooperative
  /// Stores the dm flags value associated with pickup context.
  dmFlags
  /// Stores the time value associated with pickup context.
  time
  /// Stores the skill value associated with pickup context.
  skill
  /// Stores the frame number value associated with pickup context.
  frameNumber
  /// Stores the quad drop frames value associated with pickup context.
  quadDropFrames
end struct

/// Store item action data.
struct ItemAction
  /// Stores the success value associated with item action.
  success
  /// Stores the reason value associated with item action.
  reason
  /// Stores the amount value associated with item action.
  amount
  /// Stores the dropped entity value associated with item action.
  droppedEntity
  /// Stores the respawn scheduled value associated with item action.
  respawnScheduled
end struct

/// Store weapon step data.
struct WeaponStep
  /// Stores the fired value associated with weapon step.
  fired
  /// Stores the changed value associated with weapon step.
  changed
  /// Stores the no ammo value associated with weapon step.
  noAmmo
  /// Stores the state value associated with weapon step.
  state
  /// Stores the gun frame value associated with weapon step.
  gunFrame
end struct

/// Store precache result data.
struct PrecacheResult
  /// Stores the models value associated with precache result.
  models
  /// Stores the sounds value associated with precache result.
  sounds
  /// Stores the images value associated with precache result.
  images
end struct

/// Store combatant data.
struct Combatant
  /// Stores the edict value associated with combatant.
  edict
  /// Stores the health value associated with combatant.
  health
  /// Stores the take damage value associated with combatant.
  takeDamage
  /// Stores the flags value associated with combatant.
  flags
  /// Stores the move type value associated with combatant.
  moveType
  /// Stores the mass value associated with combatant.
  mass
  /// Stores the velocity value associated with combatant.
  velocity
  /// Stores the armor value associated with combatant.
  armor
  /// Stores the armor normal protection value associated with combatant.
  armorNormalProtection
  /// Stores the armor energy protection value associated with combatant.
  armorEnergyProtection
  /// Stores the invincible until frame value associated with combatant.
  invincibleUntilFrame
  /// Stores the dead value associated with combatant.
  dead
  /// Stores the damage armor value associated with combatant.
  damageArmor
  /// Stores the damage blood value associated with combatant.
  damageBlood
  /// Stores the damage knockback value associated with combatant.
  damageKnockback
  /// Stores the damage from value associated with combatant.
  damageFrom
end struct

/// Store damage request data.
struct DamageRequest
  /// Stores the direction value associated with damage request.
  direction
  /// Stores the point value associated with damage request.
  point
  /// Stores the damage value associated with damage request.
  damage
  /// Stores the knockback value associated with damage request.
  knockback
  /// Stores the flags value associated with damage request.
  flags
  /// Stores the means of death value associated with damage request.
  meansOfDeath
  /// Stores the self damage value associated with damage request.
  selfDamage
  /// Stores the same team value associated with damage request.
  sameTeam
  /// Stores the no friendly fire value associated with damage request.
  noFriendlyFire
  /// Stores the easy mode value associated with damage request.
  easyMode
  /// Stores the current frame value associated with damage request.
  currentFrame
end struct

/// Store damage result data.
struct DamageResult
  /// Stores the applied value associated with damage result.
  applied
  /// Stores the taken value associated with damage result.
  taken
  /// Stores the armor saved value associated with damage result.
  armorSaved
  /// Stores the protected damage value associated with damage result.
  protectedDamage
  /// Stores the knockback applied value associated with damage result.
  knockbackApplied
  /// Stores the killed value associated with damage result.
  killed
  /// Stores the means of death value associated with damage result.
  meansOfDeath
end struct

/// Store power armor result data.
struct PowerArmorResult
  /// Stores the saved value associated with power armor result.
  saved
  /// Stores the cells used value associated with power armor result.
  cellsUsed
  /// Stores the armor type value associated with power armor result.
  armorType
end struct

/// Create inventory.
/// @param itemSlots itemSlots value consumed by this operation.
function createInventory(itemSlots)
  return Inventory(
    array(itemSlots, 0),
    gpconstants.DEFAULT_MAX_BULLETS,
    gpconstants.DEFAULT_MAX_SHELLS,
    gpconstants.DEFAULT_MAX_ROCKETS,
    gpconstants.DEFAULT_MAX_GRENADES,
    gpconstants.DEFAULT_MAX_CELLS,
    gpconstants.DEFAULT_MAX_SLUGS,
    0
  )
end function

/// Create player.
/// @param number number value consumed by this operation.
/// @param itemSlots itemSlots value consumed by this operation.
function createPlayer(number, itemSlots)
  edict = gtypes.zeroEdict(number)
  edict.inUse = true
  edict.client = gtypes.zeroGameClient()
  inventory = createInventory(itemSlots)
  return GameplayPlayer(
    edict, inventory, void, void, void, 0,
    gpconstants.WEAPON_READY, 0, 0, 0, 0,
    100, 100, 0, 0, 0, 0, 0, 0, 0, 0
  )
end function

/// Create item entity.
/// @param number number value consumed by this operation.
/// @param item item value consumed by this operation.
function createItemEntity(number, item)
  edict = gtypes.zeroEdict(number)
  edict.inUse = true
  return ItemEntity(edict, item, 0, 0, 0, 0.0, false, 0.0, void, false, false,
    gpqtypes.Vec3(0.0, 0.0, 0.0), void, 0, 1.0, 0, 0, void, false)
end function

/// Pick up context.
/// @param deathmatch deathmatch value consumed by this operation.
/// @param cooperative cooperative value consumed by this operation.
/// @param dmFlags dmFlags value consumed by this operation.
/// @param time time value consumed by this operation.
function pickupContext(deathmatch, cooperative, dmFlags, time)
  return PickupContext(deathmatch, cooperative, dmFlags, time, 1, 0, 0)
end function

/// Return the item rule data value.
/// @param kind kind value consumed by this operation.
/// @param armorBase armorBase value consumed by this operation.
/// @param armorMax armorMax value consumed by this operation.
/// @param normalProtection normalProtection value consumed by this operation.
/// @param energyProtection energyProtection value consumed by this operation.
/// @param healthCount Number of health to process.
/// @param healthStyle healthStyle value consumed by this operation.
/// @param duration duration value consumed by this operation.
function itemRuleData(kind, armorBase, armorMax, normalProtection, energyProtection, healthCount, healthStyle, duration)
  return ItemRuleData(kind, armorBase, armorMax, normalProtection, energyProtection, healthCount, healthStyle, duration)
end function

/// Return the item action value.
/// @param success success value consumed by this operation.
/// @param reason reason value consumed by this operation.
/// @param amount amount value consumed by this operation.
function itemAction(success, reason, amount)
  return ItemAction(success, reason, amount, void, false)
end function

/// Create combatant.
/// @param number number value consumed by this operation.
/// @param health health value consumed by this operation.
function createCombatant(number, health)
  edict = gtypes.zeroEdict(number)
  edict.inUse = true
  velocity = [0.0, 0.0, 0.0]
  damageFrom = [0.0, 0.0, 0.0]
  return Combatant(
    edict, health, true, 0, 1, 100, velocity,
    0, 0.0, 0.0, 0, false, 0, 0, 0, damageFrom
  )
end function

/// Return the damage request value.
/// @param direction direction value consumed by this operation.
/// @param point point value consumed by this operation.
/// @param damage damage value consumed by this operation.
/// @param knockback knockback value consumed by this operation.
/// @param flags Bit flags controlling the operation.
/// @param meansOfDeath meansOfDeath value consumed by this operation.
function damageRequest(direction, point, damage, knockback, flags, meansOfDeath)
  return DamageRequest(direction, point, damage, knockback, flags, meansOfDeath, false, false, false, false, 0)
end function
