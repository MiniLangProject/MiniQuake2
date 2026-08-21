/*
Copyright (C) 1997-2001 Id Software, Inc.
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later

Managed gameplay components appended beside the stable game/types.ml ABI.
*/
package miniquake2.game.gameplay.types

import miniquake2.game.gameplay.constants as gpconstants
import miniquake2.game.types as gtypes

struct WeaponFrames
  activateLast
  fireLast
  idleLast
  deactivateLast
  pauseFrames
  fireFrames
end struct

// Function-valued equivalent of the relevant gitem_t portion.
struct ItemDefinition
  index
  className
  pickup
  use
  drop
  weaponThink
  pickupSound
  worldModel
  viewModel
  icon
  pickupName
  quantity
  ammo
  flags
  weaponModel
  tag
  precaches
  weaponFrames
  ruleData
end struct

struct ItemRuleData
  kind
  armorBase
  armorMax
  normalProtection
  energyProtection
  healthCount
  healthStyle
  duration
end struct

struct ItemRegistry
  items
end struct

struct Inventory
  counts
  maxBullets
  maxShells
  maxRockets
  maxGrenades
  maxCells
  maxSlugs
  selectedItem
end struct

struct GameplayPlayer
  edict
  inventory
  currentWeapon
  lastWeapon
  newWeapon
  ammoIndex
  weaponState
  gunFrame
  buttons
  latchedButtons
  fireCount
  health
  maxHealth
  flags
  armorIndex
  quadFrame
  invincibleFrame
  breatherFrame
  enviroFrame
  silencerShots
  powerCubes
end struct

struct ItemEntity
  edict
  item
  count
  spawnFlags
  flags
  nextThink
  hidden
  respawnAt
  owner
  decaying
  freed
end struct

struct PickupContext
  deathmatch
  cooperative
  dmFlags
  time
  skill
  frameNumber
  quadDropFrames
end struct

struct ItemAction
  success
  reason
  amount
  droppedEntity
  respawnScheduled
end struct

struct WeaponStep
  fired
  changed
  noAmmo
  state
  gunFrame
end struct

struct PrecacheResult
  models
  sounds
  images
end struct

struct Combatant
  edict
  health
  takeDamage
  flags
  moveType
  mass
  velocity
  armor
  armorNormalProtection
  armorEnergyProtection
  invincibleUntilFrame
  dead
  damageArmor
  damageBlood
  damageKnockback
  damageFrom
end struct

struct DamageRequest
  direction
  point
  damage
  knockback
  flags
  meansOfDeath
  selfDamage
  sameTeam
  noFriendlyFire
  easyMode
  currentFrame
end struct

struct DamageResult
  applied
  taken
  armorSaved
  protectedDamage
  knockbackApplied
  killed
  meansOfDeath
end struct

struct PowerArmorResult
  saved
  cellsUsed
  armorType
end struct

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

function createItemEntity(number, item)
  edict = gtypes.zeroEdict(number)
  edict.inUse = true
  return ItemEntity(edict, item, 0, 0, 0, 0.0, false, 0.0, void, false, false)
end function

function pickupContext(deathmatch, cooperative, dmFlags, time)
  return PickupContext(deathmatch, cooperative, dmFlags, time, 1, 0, 0)
end function

function itemRuleData(kind, armorBase, armorMax, normalProtection, energyProtection, healthCount, healthStyle, duration)
  return ItemRuleData(kind, armorBase, armorMax, normalProtection, energyProtection, healthCount, healthStyle, duration)
end function

function itemAction(success, reason, amount)
  return ItemAction(success, reason, amount, void, false)
end function

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

function damageRequest(direction, point, damage, knockback, flags, meansOfDeath)
  return DamageRequest(direction, point, damage, knockback, flags, meansOfDeath, false, false, false, false, 0)
end function
