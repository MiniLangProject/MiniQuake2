/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Regression coverage for process-local BaseQ2 level-persistent state. */
import miniquake2.game.base.spawn as handoverspawn
import miniquake2.game.gameplay.constants as handoverconstants
import miniquake2.game.gameplay.item_rules as handoveritems
import miniquake2.game.gameplay.registry as handoverregistry
import miniquake2.game.integration.baseq2 as handoverbaseq2
import miniquake2.game.player.transition as handovertransition
import miniquake2.game.player.types as handoverplayertypes
import miniquake2.server.game_bridge as handoverbridge

// Assert the handover test condition.
function handoverAssert(value, message)
  if value != true then return error(9789, message) end if
  return true
end function

// Return the handover context and runtime value.
function handoverContextAndRuntime()
  handoverServer = handoverbridge.createRuntime(1)
  handoverImports = handoverbridge.makeImports(handoverServer)
  handoverSpawned = handoverspawn.SpawnEntities("handover-test",
    "{\"classname\" \"worldspawn\"}{\"classname\" \"info_player_start\"}", "")
  handoverRuntime = handoverbaseq2.create(handoverSpawned)
  handoverContext = handoverplayertypes.createContext(handoverImports,
    handoverregistry.baseq2Registry(), void)
  handoverContext.cooperative = true
  handoverPlayer = handoverplayertypes.createPlayer(1, handoverContext.registry)
  handoverPlayer.edict.inUse = true
  handoverPlayer.persistent.connected = true
  handoverContext.players = [handoverPlayer]
  handoverRuntime.playerContext = handoverContext
  return [handoverContext, handoverRuntime]
end function

handoverSourcePair = handoverContextAndRuntime()
handoverSourceContext = handoverSourcePair[0]
handoverSourceRuntime = handoverSourcePair[1]
handoverSourcePlayer = handoverSourceContext.players[0]
handoverRocket = handoveritems.findByPickupName(handoverSourceContext.registry,
  "Rocket Launcher")
handoverShotgun = handoveritems.findByPickupName(handoverSourceContext.registry,
  "Shotgun")
handoverRockets = handoveritems.findByPickupName(handoverSourceContext.registry,
  "Rockets")
handoverSourcePlayer.health = 73
handoverSourcePlayer.maxHealth = 125
handoverSourcePlayer.gameplay.inventory.counts[handoverRocket.index] = 1
handoverSourcePlayer.gameplay.inventory.counts[handoverRockets.index] = 37
handoverSourcePlayer.gameplay.inventory.maxBullets = 311
handoverSourcePlayer.gameplay.inventory.maxShells = 122
handoverSourcePlayer.gameplay.inventory.maxRockets = 77
handoverSourcePlayer.gameplay.inventory.maxGrenades = 66
handoverSourcePlayer.gameplay.inventory.maxCells = 333
handoverSourcePlayer.gameplay.inventory.maxSlugs = 88
handoverSourcePlayer.gameplay.inventory.selectedItem = handoverRocket.index
handoverSourcePlayer.gameplay.currentWeapon = handoverRocket
handoverSourcePlayer.gameplay.lastWeapon = handoverShotgun
handoverSourcePlayer.flags = handoverconstants.FL_GODMODE |
  handoverconstants.FL_NOTARGET | handoverconstants.FL_POWER_ARMOR | 2
handoverSourcePlayer.gameplay.flags = handoverSourcePlayer.flags
handoverSourcePlayer.gameplay.powerCubes = 0x15
handoverSourcePlayer.persistent.score = 9
handoverSourcePlayer.respawn.score = 17
handoverSourceRuntime.world.serverFlags = 0x2a
handoverSourceRuntime.world.helpMessage1 = "find the warehouse data cd"
handoverSourceRuntime.world.helpMessage2 = "use security terminals"
handoverSourceRuntime.world.helpChanged = 3

handoverSnapshot = handovertransition.capture(handoverSourceContext,
  handoverSourceRuntime, 0)
handoverSourcePlayer.gameplay.inventory.counts[handoverRockets.index] = 0
handoverAssert(handoverSnapshot.inventoryCounts[handoverRockets.index] == 37,
  "capture must own an inventory copy")

handoverTargetPair = handoverContextAndRuntime()
handoverTargetContext = handoverTargetPair[0]
handoverTargetRuntime = handoverTargetPair[1]
handoverTargetPlayer = handoverTargetContext.players[0]
handoverTargetPlayer.flags = 2
handoverTargetPlayer.gameplay.flags = 2
handovertransition.restore(handoverTargetContext, handoverTargetRuntime, 0,
  handoverSnapshot)

handoverAssert(handoverTargetPlayer.health == 73 and
  handoverTargetPlayer.maxHealth == 125, "health and max health handover")
handoverAssert(handoverTargetPlayer.persistent.health == 73 and
  handoverTargetPlayer.gameplay.health == 73, "health mirrors handover")
handoverAssert(handoverTargetPlayer.gameplay.inventory.counts[handoverRockets.index] == 37,
  "inventory handover")
handoverAssert(handoverTargetPlayer.gameplay.inventory.maxBullets == 311 and
  handoverTargetPlayer.gameplay.inventory.maxShells == 122 and
  handoverTargetPlayer.gameplay.inventory.maxRockets == 77 and
  handoverTargetPlayer.gameplay.inventory.maxGrenades == 66 and
  handoverTargetPlayer.gameplay.inventory.maxCells == 333 and
  handoverTargetPlayer.gameplay.inventory.maxSlugs == 88,
  "ammo capacity handover")
handoverAssert(handoverTargetPlayer.gameplay.inventory.selectedItem ==
  handoverRocket.index and handoverTargetPlayer.persistent.selectedItem ==
  handoverRocket.index, "selected item handover")
handoverAssert(handoverTargetPlayer.gameplay.currentWeapon.index ==
  handoverRocket.index and handoverTargetPlayer.gameplay.lastWeapon.index ==
  handoverShotgun.index, "current and last weapon handover")
handoverAssert((handoverTargetPlayer.flags & 2) != 0 and
  (handoverTargetPlayer.flags & handoverconstants.FL_GODMODE) != 0 and
  (handoverTargetPlayer.flags & handoverconstants.FL_NOTARGET) != 0 and
  (handoverTargetPlayer.flags & handoverconstants.FL_POWER_ARMOR) != 0,
  "saved flags merge")
handoverAssert(handoverTargetPlayer.gameplay.powerCubes == 0x15,
  "power cube handover")
handoverAssert(handoverTargetPlayer.persistent.score == 9 and
  handoverTargetPlayer.respawn.score == 17, "score handover")
handoverAssert(handoverTargetRuntime.world.serverFlags == 0x2a,
  "server flags handover")
handoverAssert(handoverTargetRuntime.world.helpMessage1 ==
  "find the warehouse data cd" and
  handoverTargetRuntime.world.helpMessage2 == "use security terminals" and
  handoverTargetRuntime.world.helpChanged == 3, "game help handover")
handoverAssert(handoverTargetPlayer.respawn.cooperativeInventory[
  handoverRockets.index] == 37, "cooperative respawn checkpoint handover")

handoverSnapshot.inventoryCounts[handoverRockets.index] = 5
handoverAssert(handoverTargetPlayer.gameplay.inventory.counts[
  handoverRockets.index] == 37, "restore must own an inventory copy")

handoverInvalidSnapshot = handovertransition.capture(handoverSourceContext,
  handoverSourceRuntime, 0)
handoverInvalidSnapshot.inventoryCounts = []
handoverInvalidPair = handoverContextAndRuntime()
handoverInvalidContext = handoverInvalidPair[0]
handoverInvalidRuntime = handoverInvalidPair[1]
handoverInvalidPlayer = handoverInvalidContext.players[0]
handoverInvalidCountBefore = handoverInvalidPlayer.gameplay.inventory.counts[1]
handoverInvalidResult = try(handovertransition.restore(handoverInvalidContext,
  handoverInvalidRuntime, 0, handoverInvalidSnapshot))
handoverAssert(handoverInvalidResult is error,
  "invalid inventory layout must reject successor state")
handoverAssert(handoverInvalidPlayer.gameplay.inventory.counts[1] ==
  handoverInvalidCountBefore and handoverInvalidPlayer.health == 0,
  "rejected restore must not mutate successor state")

print "gameplay_level_handover_tests: PASS"
