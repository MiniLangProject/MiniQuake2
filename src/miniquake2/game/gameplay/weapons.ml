//! Provides miniquake2 game gameplay weapons facilities for this project.

/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Deterministic Weapon_Generic-style state machine from p_weapon.c. */
package miniquake2.game.gameplay.weapons

import miniquake2.game.constants as gconstants
import miniquake2.game.gameplay.constants as gpconstants
import miniquake2.game.gameplay.types as gptypes
import miniquake2.qcommon.text as qtext

/// Finds by pickup name used by the miniquake2 game gameplay weapons module.
/// @param registry registry value consumed by this operation.
/// @param pickupName pickupName value consumed by this operation.
function findByPickupName(registry, pickupName)
  if typeof(pickupName) != "string" then return error(9390, "weapon pickup name is not text") end if
  for each item in registry.items
    gpweaponPickupHolder = item.pickupName
    if typeof(gpweaponPickupHolder) != "string" then return error(9391, "weapon registry pickup name is not text") end if
    if qtext.equalInsensitive(gpweaponPickupHolder, pickupName) then return item end if
  end for
  return void
end function

/// Return the owned value.
/// @param player player value consumed by this operation.
/// @param item item value consumed by this operation.
function owned(player, item)
  return item is not void and player.inventory.counts[item.index] > 0
end function

/// Report whether ammo available.
/// @param player player value consumed by this operation.
/// @param item item value consumed by this operation.
/// @param registry registry value consumed by this operation.
function ammoAvailable(player, item, registry)
  if item is void then return false end if
  if item.ammo == "" then return true end if
  ammo = findByPickupName(registry, item.ammo)
  if ammo is void then return false end if
  return player.inventory.counts[ammo.index] >= item.quantity
end function

/// Return the mirror gun frame value.
/// @param player player value consumed by this operation.
function mirrorGunFrame(player)
  if player.edict.client is not void then player.edict.client.playerState.gunFrame = player.gunFrame end if
  return player.gunFrame
end function

/// Return the change weapon value.
/// @param player player value consumed by this operation.
/// @param registry registry value consumed by this operation.
function ChangeWeapon(player, registry)
  player.lastWeapon = player.currentWeapon
  player.currentWeapon = player.newWeapon
  player.newWeapon = void
  if player.edict.state.modelIndex == 255 then
    visibleWeapon = 0
    if player.currentWeapon is not void then
      visibleWeapon = (player.currentWeapon.weaponModel & 0xff) << 8
    end if
    player.edict.state.skinNumber = (player.edict.state.number - 1) | visibleWeapon
  end if
  player.ammoIndex = 0
  if player.currentWeapon is not void and player.currentWeapon.ammo != "" then
    ammo = findByPickupName(registry, player.currentWeapon.ammo)
    if ammo is not void then player.ammoIndex = ammo.index end if
  end if
  if player.currentWeapon is void then
    player.gunFrame = 0
    if player.edict.client is not void then player.edict.client.playerState.gunIndex = 0 end if
    mirrorGunFrame(player)
    return true
  end if
  player.weaponState = gpconstants.WEAPON_ACTIVATING
  player.gunFrame = 0
  mirrorGunFrame(player)
  return true
end function

/// Report whether no ammo weapon change.
/// @param player player value consumed by this operation.
/// @param registry registry value consumed by this operation.
function NoAmmoWeaponChange(player, registry)
  slugs = findByPickupName(registry, "Slugs")
  railgun = findByPickupName(registry, "Railgun")
  cells = findByPickupName(registry, "Cells")
  hyperblaster = findByPickupName(registry, "HyperBlaster")
  bullets = findByPickupName(registry, "Bullets")
  chaingun = findByPickupName(registry, "Chaingun")
  machinegun = findByPickupName(registry, "Machinegun")
  shells = findByPickupName(registry, "Shells")
  superShotgun = findByPickupName(registry, "Super Shotgun")
  shotgun = findByPickupName(registry, "Shotgun")
  if owned(player, railgun) and player.inventory.counts[slugs.index] > 0 then player.newWeapon = railgun; return railgun end if
  if owned(player, hyperblaster) and player.inventory.counts[cells.index] > 0 then player.newWeapon = hyperblaster; return hyperblaster end if
  if owned(player, chaingun) and player.inventory.counts[bullets.index] > 0 then player.newWeapon = chaingun; return chaingun end if
  if owned(player, machinegun) and player.inventory.counts[bullets.index] > 0 then player.newWeapon = machinegun; return machinegun end if
  if owned(player, superShotgun) and player.inventory.counts[shells.index] > 1 then player.newWeapon = superShotgun; return superShotgun end if
  if owned(player, shotgun) and player.inventory.counts[shells.index] > 0 then player.newWeapon = shotgun; return shotgun end if
  player.newWeapon = findByPickupName(registry, "Blaster")
  return player.newWeapon
end function

/// Report whether has frame.
/// @param frames frames value consumed by this operation.
/// @param value Value consumed or transformed by the operation.
function hasFrame(frames, value)
  for each frame in frames
    if frame == value then return true end if
  end for
  return false
end function

/// Basic fire callback used until weapon-specific projectile/hitscan code lands.
/// It preserves the important contract: weapon callbacks own fire-frame advance.
/// @param player player value consumed by this operation.
/// @param registry registry value consumed by this operation.
function FireCurrentWeapon(player, registry)
  if player.currentWeapon is void then return error(9350, "FireCurrentWeapon: no current weapon") end if
  if player.ammoIndex != 0 then
    required = player.currentWeapon.quantity
    if player.inventory.counts[player.ammoIndex] < required then return false end if
    player.inventory.counts[player.ammoIndex] = player.inventory.counts[player.ammoIndex] - required
  end if
  player.fireCount = player.fireCount + 1
  player.gunFrame = player.gunFrame + 1
  mirrorGunFrame(player)
  return true
end function

/// Return the weapon generic value.
/// @param player player value consumed by this operation.
/// @param frames frames value consumed by this operation.
/// @param registry registry value consumed by this operation.
/// @param fireCallback fireCallback value consumed by this operation.
/// @param pauseRoll pauseRoll value consumed by this operation.
function Weapon_Generic(player, frames, registry, fireCallback, pauseRoll)
  if typeof(fireCallback) != "function" then return error(9351, "Weapon_Generic: fire callback required") end if
  if typeof(pauseRoll) != "int" or pauseRoll < 0 or pauseRoll > 15 then return error(9352, "Weapon_Generic: pause roll must be 0..15") end if
  fired = false
  changed = false
  noAmmo = false
  fireFirst = frames.activateLast + 1
  idleFirst = frames.fireLast + 1
  deactivateFirst = frames.idleLast + 1

  if player.weaponState == gpconstants.WEAPON_DROPPING then
    if player.gunFrame == frames.deactivateLast then
      ChangeWeapon(player, registry)
      changed = true
    else
      player.gunFrame = player.gunFrame + 1
      mirrorGunFrame(player)
    end if
    return gptypes.WeaponStep(fired, changed, noAmmo, player.weaponState, player.gunFrame)
  end if

  if player.weaponState == gpconstants.WEAPON_ACTIVATING then
    if player.gunFrame == frames.activateLast then
      player.weaponState = gpconstants.WEAPON_READY
      player.gunFrame = idleFirst
    else
      player.gunFrame = player.gunFrame + 1
    end if
    mirrorGunFrame(player)
    return gptypes.WeaponStep(fired, changed, noAmmo, player.weaponState, player.gunFrame)
  end if

  if player.newWeapon is not void and player.weaponState != gpconstants.WEAPON_FIRING then
    player.weaponState = gpconstants.WEAPON_DROPPING
    player.gunFrame = deactivateFirst
    mirrorGunFrame(player)
    return gptypes.WeaponStep(fired, changed, noAmmo, player.weaponState, player.gunFrame)
  end if

  if player.weaponState == gpconstants.WEAPON_READY then
    attacking = ((player.latchedButtons | player.buttons) & gconstants.BUTTON_ATTACK) != 0
    if attacking then
      player.latchedButtons = player.latchedButtons & ~gconstants.BUTTON_ATTACK
      if ammoAvailable(player, player.currentWeapon, registry) then
        player.gunFrame = fireFirst
        player.weaponState = gpconstants.WEAPON_FIRING
      else
        NoAmmoWeaponChange(player, registry)
        noAmmo = true
      end if
    else
      if player.gunFrame == frames.idleLast then player.gunFrame = idleFirst
      else if hasFrame(frames.pauseFrames, player.gunFrame) and pauseRoll != 0 then
        // Deterministic caller-provided equivalent of rand() & 15.
      else player.gunFrame = player.gunFrame + 1
      end if
    end if
    mirrorGunFrame(player)
  end if

  if player.weaponState == gpconstants.WEAPON_FIRING then
    if hasFrame(frames.fireFrames, player.gunFrame) then
      callbackFrame = player.gunFrame
      fired = fireCallback(player, registry)
      // Stock p_weapon.c callbacks return void and may legally emit no shot
      // after ammo is exhausted during a multi-frame firing sequence.  Treat a
      // false result as that no-ammo outcome, preserve any weapon-specific
      // frame change, and guarantee progress for the component fallback.
      if fired != true then
        NoAmmoWeaponChange(player, registry)
        noAmmo = true
        if player.gunFrame == callbackFrame then
          player.gunFrame = player.gunFrame + 1
          mirrorGunFrame(player)
        end if
      end if
    else
      player.gunFrame = player.gunFrame + 1
      mirrorGunFrame(player)
    end if
    if player.gunFrame == idleFirst + 1 then player.weaponState = gpconstants.WEAPON_READY end if
  end if
  return gptypes.WeaponStep(fired, changed, noAmmo, player.weaponState, player.gunFrame)
end function

/// Run current weapon.
/// @param player player value consumed by this operation.
/// @param item item value consumed by this operation.
/// @param registry registry value consumed by this operation.
/// @param pauseRoll pauseRoll value consumed by this operation.
function Think_CurrentWeapon(player, item, registry, pauseRoll)
  if player.currentWeapon is void or player.currentWeapon.index != item.index then return error(9354, "weapon think called for inactive weapon") end if
  if item.weaponFrames is void then return error(9355, "weapon has no frame contract") end if
  return Weapon_Generic(player, item.weaponFrames, registry, FireCurrentWeapon, pauseRoll)
end function

/// Performs the FireBfg operation for the miniquake2 game gameplay weapons module.
/// @param player player value consumed by this operation.
/// @param registry registry value consumed by this operation.
function FireBfg(player, registry)
  // p_weapon.c frame 9 is wind-up only; frame 17 emits and consumes 50 cells.
  if player.gunFrame == 9 then
    player.gunFrame = player.gunFrame + 1
    mirrorGunFrame(player)
    return true
  end if
  return FireCurrentWeapon(player, registry)
end function

/// Run bfg.
/// @param player player value consumed by this operation.
/// @param item item value consumed by this operation.
/// @param registry registry value consumed by this operation.
/// @param pauseRoll pauseRoll value consumed by this operation.
function Think_Bfg(player, item, registry, pauseRoll)
  if player.currentWeapon is void or player.currentWeapon.index != item.index then return error(9354, "weapon think called for inactive BFG") end if
  return Weapon_Generic(player, item.weaponFrames, registry, FireBfg, pauseRoll)
end function
