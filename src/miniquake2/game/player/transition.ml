//! Provides miniquake2 game player transition facilities for this project.

/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Typed process-local equivalent of BaseQ2 SaveClientData/FetchClientEntData. */
package miniquake2.game.player.transition

import miniquake2.game.gameplay.constants as transitionconstants
import miniquake2.game.gameplay.item_rules as transitionitems

/// Defines the persistent flag mask constant used by the miniquake2 game player transition module.
const PERSISTENT_FLAG_MASK = transitionconstants.FL_GODMODE |
  transitionconstants.FL_NOTARGET | transitionconstants.FL_POWER_ARMOR

/// The original game keeps this data in game.clients and game.serverflags while
/// TAG_LEVEL allocations are replaced.  The product host replaces the complete
/// Game API graph instead, so an owned value snapshot must cross that boundary.
struct PlayerLevelHandover
  /// Stores the health value associated with player level handover.
  health
  /// Stores the max health value associated with player level handover.
  maxHealth
  /// Stores the inventory counts value associated with player level handover.
  inventoryCounts
  /// Stores the max bullets value associated with player level handover.
  maxBullets
  /// Stores the max shells value associated with player level handover.
  maxShells
  /// Stores the max rockets value associated with player level handover.
  maxRockets
  /// Stores the max grenades value associated with player level handover.
  maxGrenades
  /// Stores the max cells value associated with player level handover.
  maxCells
  /// Stores the max slugs value associated with player level handover.
  maxSlugs
  /// Stores the selected item value associated with player level handover.
  selectedItem
  /// Stores the current weapon index value associated with player level handover.
  currentWeaponIndex
  /// Stores the last weapon index value associated with player level handover.
  lastWeaponIndex
  /// Stores the saved flags value associated with player level handover.
  savedFlags
  /// Stores the power cubes value associated with player level handover.
  powerCubes
  /// Stores the persistent score value associated with player level handover.
  persistentScore
  /// Stores the respawn score value associated with player level handover.
  respawnScore
  /// Stores the game help changed value associated with player level handover.
  gameHelpChanged
  /// Stores the player help changed value associated with player level handover.
  playerHelpChanged
  /// Stores the server flags value associated with player level handover.
  serverFlags
  /// Stores the help message1 value associated with player level handover.
  helpMessage1
  /// Stores the help message2 value associated with player level handover.
  helpMessage2
  /// Stores the help changed value associated with player level handover.
  helpChanged
end struct

/// Copy counts data.
/// @param counts counts value consumed by this operation.
function copyCounts(counts)
  transitionCopiedCounts = array(len(counts), 0)
  transitionCopyIndex = 0
  while transitionCopyIndex < len(counts)
    transitionCopiedCounts[transitionCopyIndex] = counts[transitionCopyIndex]
    transitionCopyIndex = transitionCopyIndex + 1
  end while
  return transitionCopiedCounts
end function

/// Return the item index.
/// @param item item value consumed by this operation.
function itemIndex(item)
  if item is void then return 0 end if
  return item.index
end function

/// Return the checked item value.
/// @param registry registry value consumed by this operation.
/// @param index Zero-based index of the affected item.
/// @param label label value consumed by this operation.
function checkedItem(registry, index, label)
  if index == 0 then return void end if
  transitionResolvedItem = transitionitems.getByIndex(registry, index)
  if transitionResolvedItem is void then
    return error(9780, "level handover has unknown " + label + " index")
  end if
  return transitionResolvedItem
end function

/// Capture state.
/// @param playerContext playerContext value consumed by this operation.
/// @param runtime runtime value consumed by this operation.
/// @param playerIndex Zero-based index of player.
function capture(playerContext, runtime, playerIndex)
  if playerContext is void or runtime is void then
    return error(9781, "level handover requires active game state")
  end if
  if typeof(playerIndex) != "int" or playerIndex < 0 or
      playerIndex >= len(playerContext.players) then
    return error(9782, "level handover player index is out of range")
  end if
  transitionCapturePlayer = playerContext.players[playerIndex]
  transitionCaptureInventory = transitionCapturePlayer.gameplay.inventory
  return PlayerLevelHandover(
    transitionCapturePlayer.health, transitionCapturePlayer.maxHealth,
    copyCounts(transitionCaptureInventory.counts),
    transitionCaptureInventory.maxBullets,
    transitionCaptureInventory.maxShells,
    transitionCaptureInventory.maxRockets,
    transitionCaptureInventory.maxGrenades,
    transitionCaptureInventory.maxCells,
    transitionCaptureInventory.maxSlugs,
    transitionCaptureInventory.selectedItem,
    itemIndex(transitionCapturePlayer.gameplay.currentWeapon),
    itemIndex(transitionCapturePlayer.gameplay.lastWeapon),
    transitionCapturePlayer.flags & PERSISTENT_FLAG_MASK,
    transitionCapturePlayer.gameplay.powerCubes,
    transitionCapturePlayer.persistent.score,
    transitionCapturePlayer.respawn.score,
    transitionCapturePlayer.persistent.gameHelpChanged,
    transitionCapturePlayer.persistent.helpChanged,
    runtime.world.serverFlags,
    runtime.world.helpMessage1,
    runtime.world.helpMessage2,
    runtime.world.helpChanged)
end function

/// Restore state.
/// @param playerContext playerContext value consumed by this operation.
/// @param runtime runtime value consumed by this operation.
/// @param playerIndex Zero-based index of player.
/// @param handover handover value consumed by this operation.
function restore(playerContext, runtime, playerIndex, handover)
  if playerContext is void or runtime is void or typeof(handover) != "struct" then
    return error(9783, "level handover restore requires active typed state")
  end if
  if typeof(playerIndex) != "int" or playerIndex < 0 or
      playerIndex >= len(playerContext.players) then
    return error(9782, "level handover player index is out of range")
  end if
  transitionRestorePlayer = playerContext.players[playerIndex]
  transitionRestoreInventory = transitionRestorePlayer.gameplay.inventory
  if len(handover.inventoryCounts) != len(transitionRestoreInventory.counts) then
    return error(9784, "level handover inventory layout changed")
  end if
  transitionRestoreCurrent = checkedItem(playerContext.registry,
    handover.currentWeaponIndex, "current weapon")
  transitionRestoreLast = checkedItem(playerContext.registry,
    handover.lastWeaponIndex, "last weapon")

  transitionRestoreInventory.counts = copyCounts(handover.inventoryCounts)
  transitionRestoreInventory.maxBullets = handover.maxBullets
  transitionRestoreInventory.maxShells = handover.maxShells
  transitionRestoreInventory.maxRockets = handover.maxRockets
  transitionRestoreInventory.maxGrenades = handover.maxGrenades
  transitionRestoreInventory.maxCells = handover.maxCells
  transitionRestoreInventory.maxSlugs = handover.maxSlugs
  transitionRestoreInventory.selectedItem = handover.selectedItem

  transitionRestorePlayer.health = handover.health
  transitionRestorePlayer.maxHealth = handover.maxHealth
  transitionRestorePlayer.persistent.health = handover.health
  transitionRestorePlayer.persistent.maxHealth = handover.maxHealth
  transitionRestorePlayer.persistent.selectedItem = handover.selectedItem
  transitionRestorePlayer.persistent.score = handover.persistentScore
  transitionRestorePlayer.respawn.score = handover.respawnScore
  transitionRestorePlayer.persistent.gameHelpChanged = handover.gameHelpChanged
  transitionRestorePlayer.persistent.helpChanged = handover.playerHelpChanged
  transitionRestorePlayer.gameplay.health = handover.health
  transitionRestorePlayer.gameplay.maxHealth = handover.maxHealth
  transitionRestorePlayer.gameplay.currentWeapon = transitionRestoreCurrent
  transitionRestorePlayer.gameplay.lastWeapon = transitionRestoreLast
  transitionRestorePlayer.gameplay.newWeapon = void
  transitionRestorePlayer.gameplay.powerCubes = handover.powerCubes
  transitionRestorePlayer.flags = (transitionRestorePlayer.flags &
    ~PERSISTENT_FLAG_MASK) | handover.savedFlags
  transitionRestorePlayer.gameplay.flags = (transitionRestorePlayer.gameplay.flags &
    ~PERSISTENT_FLAG_MASK) | handover.savedFlags

  // PutClientInServer already established the successor spawn transform. Only
  // rebuild weapon-derived presentation and the cooperative respawn snapshot.
  transitionRestorePlayer.gameplay.ammoIndex = 0
  if transitionRestoreCurrent is void then
    transitionRestorePlayer.edict.client.playerState.gunIndex = 0
  else
    if transitionRestoreCurrent.ammo != "" then
      transitionRestoreAmmo = transitionitems.findByPickupName(
        playerContext.registry, transitionRestoreCurrent.ammo)
      if transitionRestoreAmmo is not void then
        transitionRestorePlayer.gameplay.ammoIndex = transitionRestoreAmmo.index
      end if
    end if
    if transitionRestoreCurrent.viewModel != "" then
      transitionRestoreGunIndex = playerContext.imports.modelIndex(
        transitionRestoreCurrent.viewModel)
      transitionRestorePlayer.edict.client.playerState.gunIndex = transitionRestoreGunIndex
    end if
    if transitionRestorePlayer.edict.state.modelIndex == 255 then
      transitionRestoreSkinNumber = (transitionRestorePlayer.edict.state.number - 1) |
        ((transitionRestoreCurrent.weaponModel & 0xff) << 8)
      transitionRestorePlayer.edict.state.skinNumber = transitionRestoreSkinNumber
    end if
  end if
  if playerContext.cooperative then
    transitionRestoreCoopInventory = copyCounts(transitionRestoreInventory.counts)
    transitionRestorePlayer.respawn.cooperativeInventory = transitionRestoreCoopInventory
  end if
  runtime.world.serverFlags = handover.serverFlags
  runtime.world.helpMessage1 = handover.helpMessage1
  runtime.world.helpMessage2 = handover.helpMessage2
  runtime.world.helpChanged = handover.helpChanged
  return true
end function
