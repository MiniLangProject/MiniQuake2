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

// Store weapon frames data.
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

// Store item rule data data.
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

// Store item registry data.
struct ItemRegistry
  items
end struct

// Store inventory data.
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

// Store gameplay player data.
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

// Store item entity data.
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
  velocity
  groundEntity
  groundLinkCount
  gravity
  waterType
  waterLevel
  worldTarget
  spawnPending
end struct

// Store pickup context data.
struct PickupContext
  deathmatch
  cooperative
  dmFlags
  time
  skill
  frameNumber
  quadDropFrames
end struct

// Store item action data.
struct ItemAction
  success
  reason
  amount
  droppedEntity
  respawnScheduled
end struct

// Store weapon step data.
struct WeaponStep
  fired
  changed
  noAmmo
  state
  gunFrame
end struct

// Store precache result data.
struct PrecacheResult
  models
  sounds
  images
end struct

// Store combatant data.
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

// Store damage request data.
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

// Store damage result data.
struct DamageResult
  applied
  taken
  armorSaved
  protectedDamage
  knockbackApplied
  killed
  meansOfDeath
end struct

// Store power armor result data.
struct PowerArmorResult
  saved
  cellsUsed
  armorType
end struct

// Create inventory.
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

// Create player.
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

// Create item entity.
function createItemEntity(number, item)
  edict = gtypes.zeroEdict(number)
  edict.inUse = true
  return ItemEntity(edict, item, 0, 0, 0, 0.0, false, 0.0, void, false, false,
    gpqtypes.Vec3(0.0, 0.0, 0.0), void, 0, 1.0, 0, 0, void, false)
end function

// Pick up context.
function pickupContext(deathmatch, cooperative, dmFlags, time)
  return PickupContext(deathmatch, cooperative, dmFlags, time, 1, 0, 0)
end function

// Return the item rule data value.
function itemRuleData(kind, armorBase, armorMax, normalProtection, energyProtection, healthCount, healthStyle, duration)
  return ItemRuleData(kind, armorBase, armorMax, normalProtection, energyProtection, healthCount, healthStyle, duration)
end function

// Return the item action value.
function itemAction(success, reason, amount)
  return ItemAction(success, reason, amount, void, false)
end function

// Create combatant.
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

// Return the damage request value.
function damageRequest(direction, point, damage, knockback, flags, meansOfDeath)
  return DamageRequest(direction, point, damage, knockback, flags, meansOfDeath, false, false, false, false, 0)
end function
