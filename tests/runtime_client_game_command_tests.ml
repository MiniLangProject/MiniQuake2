/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Real Protocol-34 coverage for the remaining bounded g_cmds.c surface. */
import miniquake2.qcommon.constants as gccqconstants
import miniquake2.game.null_game as gccgame
import miniquake2.game.gameplay.item_rules as gccitems
import miniquake2.game.gameplay.constants as gccgameplayconstants
import miniquake2.game.constants as gccgameconstants
import miniquake2.game.integration.baseq2 as gccintegration
import miniquake2.game.player.constants as gccplayerconstants
import miniquake2.runtime.client_session as gccclient
import miniquake2.runtime.play_session as gccplay

// Assert the gcc test condition.
function gccAssert(value, name)
  if not value then return error(8435, name) end if
  return true
end function

// Send gcc.
function gccSend(session, text)
  before = gccgame.lifecycleSnapshot()[6]
  gccAssert(gccclient.sendStringCommand(session.client, text, 0),
    "failed to send " + text)
  steps = 0
  result = void
  while gccgame.lifecycleSnapshot()[6] == before and steps < 32
    result = gccplay.step(session)
    steps = steps + 1
  end while
  gccAssert(gccgame.lifecycleSnapshot()[6] == before + 1,
    "ClientCommand timeout for " + text)
  return result
end function

// Return the gcc wait for message value.
function gccWaitForMessage(session, result, kind)
  steps = 0
  while steps < 24
    if result is not void and result.handoff is not void then
      if kind == "inventory" and len(result.handoff.inventories) > 0 then
        return result.handoff
      end if
      if kind == "layout" and len(result.handoff.layouts) > 0 then
        return result.handoff
      end if
      if kind == "print" and len(result.handoff.prints) > 0 then
        return result.handoff
      end if
    end if
    result = gccplay.step(session)
    steps = steps + 1
  end while
  return void
end function

gccEntities = "{\n\"classname\" \"worldspawn\"\n\"message\" \"Command Audit\"\n}\n" +
  "{\n\"classname\" \"info_player_start\"\n\"origin\" \"0 0 64\"\n}\n"
gccSession = gccplay.createCore("game_commands", gccEntities, void,
  "\\name\\CommandAudit\\skin\\male/grunt")
gccplay.runUntilActive(gccSession, 256)
gccContext = gccgame.playerContext()
gccPlayer = gccContext.players[0]
gccRegistry = gccContext.registry
gccQuad = gccitems.findByPickupName(gccRegistry, "Quad Damage")
gccInvulnerability = gccitems.findByPickupName(gccRegistry, "Invulnerability")
gccShotgun = gccitems.findByPickupName(gccRegistry, "Shotgun")
gccShells = gccitems.findByPickupName(gccRegistry, "Shells")

// Cmd_Use_f must dispatch carried powerups as well as weapons.
gccPlayer.gameplay.inventory.counts[gccQuad.index] = 1
gccSend(gccSession, "use Quad Damage")
gccAssert(gccPlayer.gameplay.inventory.counts[gccQuad.index] == 0 and
  gccPlayer.powerups.quadFrame > gccContext.frameNumber,
  "generic use command did not activate Quad Damage")

// Filtered inventory cycling, full SVC_INVENTORY delivery and invuse.
gccPlayer.gameplay.inventory.counts[gccQuad.index] = 1
gccPlayer.gameplay.inventory.counts[gccInvulnerability.index] = 1
gccPlayer.gameplay.inventory.counts[gccShotgun.index] = 1
gccPlayer.gameplay.inventory.counts[gccShells.index] = 20
gccPlayer.gameplay.inventory.selectedItem = gccShotgun.index
gccSend(gccSession, "invnextp")
gccAssert(gccPlayer.gameplay.inventory.selectedItem == gccQuad.index,
  "invnextp did not select first owned powerup")
gccInventoryResult = gccSend(gccSession, "inven")
gccInventoryHandoff = gccWaitForMessage(gccSession, gccInventoryResult, "inventory")
gccAssert(gccPlayer.showInventory and gccInventoryHandoff is not void,
  "inven did not open or deliver SVC_INVENTORY")
gccInventory = gccInventoryHandoff.inventories[
  len(gccInventoryHandoff.inventories) - 1].values
gccAssert(len(gccInventory) == gccqconstants.MAX_ITEMS and
  gccInventory[gccQuad.index] == 1 and gccInventory[gccShells.index] == 20,
  "SVC_INVENTORY did not preserve the full inventory vector")
gccSend(gccSession, "invuse")
gccAssert(gccPlayer.gameplay.inventory.counts[gccQuad.index] == 0,
  "invuse did not consume selected powerup")

// Cmd_Drop_f creates the stock toss entity, changes inventory and prevents
// the owner from immediately reclaiming it.  Once drop_make_touchable's
// one-second deadline passes, the normal pickup path accepts it again.
gccRuntime = gccgame.baseRuntime()
gccPlayer.gameplay.inventory.counts[gccShells.index] = 20
gccDropCountBefore = len(gccRuntime.items)
gccSend(gccSession, "drop Shells")
gccAssert(gccPlayer.gameplay.inventory.counts[gccShells.index] == 10 and
  len(gccRuntime.items) == gccDropCountBefore + 1,
  "drop command did not publish inventory/entity change")
gccDroppedShells = gccRuntime.items[len(gccRuntime.items) - 1]
gccAssert(gccDroppedShells.count == 10 and
  (gccDroppedShells.spawnFlags & gccgameplayconstants.DROPPED_ITEM) != 0 and
  gccDroppedShells.edict.state.modelIndex > 0 and
  gccDroppedShells.edict.state.renderFx == gccgameconstants.RF_GLOW and
  gccDroppedShells.velocity.z != 0.0,
  "Drop_Item toss/model/render contract")
gccOwnerPickup = gccintegration.touchItem(gccRuntime, gccDroppedShells,
  gccPlayer, gccContext)
gccAssert(not gccOwnerPickup.success and
  gccOwnerPickup.reason == "drop owner immunity",
  "drop_temp_touch did not reject owner")
gccSavedCommandTime = gccContext.time
gccContext.time = gccDroppedShells.nextThink
gccOwnerPickup = gccintegration.touchItem(gccRuntime, gccDroppedShells,
  gccPlayer, gccContext)
gccContext.time = gccSavedCommandTime
gccAssert(gccOwnerPickup.success and
  gccPlayer.gameplay.inventory.counts[gccShells.index] == 20 and
  not gccDroppedShells.edict.inUse,
  "drop_make_touchable did not enable normal pickup")

// Cmd_InvDrop_f uses the selected definition and validates the selection.
gccPlayer.gameplay.inventory.counts[gccQuad.index] = 1
gccPlayer.gameplay.inventory.selectedItem = gccQuad.index
gccInvDropCountBefore = len(gccRuntime.items)
gccSend(gccSession, "invdrop")
gccAssert(gccPlayer.gameplay.inventory.counts[gccQuad.index] == 0 and
  len(gccRuntime.items) == gccInvDropCountBefore + 1 and
  gccRuntime.items[len(gccRuntime.items) - 1].item.index == gccQuad.index,
  "invdrop did not drop the selected carried item")

// Score/help produce real layouts and putaway clears every overlay.
gccContext.deathmatch = true
gccScoreResult = gccSend(gccSession, "score")
gccScoreHandoff = gccWaitForMessage(gccSession, gccScoreResult, "layout")
gccAssert(gccPlayer.showScores and gccScoreHandoff is not void,
  "score did not toggle or deliver scoreboard layout")
gccContext.deathmatch = false
gccHelpResult = gccSend(gccSession, "help")
gccHelpHandoff = gccWaitForMessage(gccSession, gccHelpResult, "layout")
gccAssert(gccPlayer.showHelp and not gccPlayer.showScores and
  gccHelpHandoff is not void,
  "help did not replace scoreboard with help layout")
gccSend(gccSession, "putaway")
gccAssert(not gccPlayer.showHelp and not gccPlayer.showScores and
  not gccPlayer.showInventory, "putaway did not close overlays")

// Intermission blocks gameplay commands but leaves score/help/player queries.
gccPlayer.gameplay.inventory.selectedItem = gccQuad.index
gccContext.intermissionTime = 1.0
gccSend(gccSession, "invnext")
gccAssert(gccPlayer.gameplay.inventory.selectedItem == gccQuad.index,
  "intermission accepted gameplay inventory command")
gccContext.intermissionTime = 0.0

// Stock single-player cheats, followed by the deathmatch cheats gate.
gccSend(gccSession, "give health 77")
gccAssert(gccPlayer.health == 77, "give health did not set requested value")
gccSend(gccSession, "god")
gccAssert((gccPlayer.flags & gccgameplayconstants.FL_GODMODE) != 0,
  "single-player god command")
gccSend(gccSession, "notarget")
gccAssert((gccPlayer.flags & gccgameplayconstants.FL_NOTARGET) != 0,
  "single-player notarget command")
gccSend(gccSession, "noclip")
gccAssert(gccPlayer.moveType == gccplayerconstants.MOVETYPE_NOCLIP,
  "single-player noclip command")
gccSend(gccSession, "noclip")
gccAssert(gccPlayer.moveType == gccplayerconstants.MOVETYPE_WALK,
  "noclip command did not toggle off")
gccContext.deathmatch = true
gccOldFlags = gccPlayer.flags
gccSend(gccSession, "god")
gccAssert(gccPlayer.flags == gccOldFlags,
  "deathmatch cheat bypassed cheats cvar gate")
gccContext.deathmatch = false

// Explicit and fallback chat both travel as reliable PRINT_CHAT messages.
gccSayResult = gccSend(gccSession, "say audit message")
gccSayHandoff = gccWaitForMessage(gccSession, gccSayResult, "print")
gccAssert(gccSayHandoff is not void and
  gccSayHandoff.prints[len(gccSayHandoff.prints) - 1].text ==
    "CommandAudit: audit message\n", "say command formatting/delivery")
gccFallbackResult = gccSend(gccSession, "hello command fallback")
gccFallbackHandoff = gccWaitForMessage(gccSession, gccFallbackResult, "print")
gccAssert(gccFallbackHandoff is not void and
  gccFallbackHandoff.prints[len(gccFallbackHandoff.prints) - 1].text ==
    "CommandAudit: hello command fallback\n",
  "unknown command did not fall back to chat")

// The collision-free fixture continuously falls; isolate the command from the
// jump animation that would correctly reject a wave in normal gameplay.
gccPlayer.view.animPriority = gccplayerconstants.ANIM_BASIC
gccPlayer.edict.client.playerState.pmove.flags = 0
gccWaveResult = gccSend(gccSession, "wave 1")
gccWaveHandoff = gccWaitForMessage(gccSession, gccWaveResult, "print")
gccAssert(gccWaveHandoff is not void and
  gccWaveHandoff.prints[len(gccWaveHandoff.prints) - 1].text == "salute\n",
  "wave command did not select and announce the stock salute animation")

// Cmd_Kill_f refuses the first five seconds, then uses the normal death path.
gccPlayer.respawnTime = gccContext.time
gccSend(gccSession, "kill")
gccAssert(gccPlayer.deadFlag == gccplayerconstants.DEAD_NO,
  "kill bypassed five-second respawn guard")
gccPlayer.respawnTime = gccContext.time - 5.0
gccSend(gccSession, "kill")
gccAssert(gccPlayer.deadFlag == gccplayerconstants.DEAD_DEAD and
  gccPlayer.health <= 0, "kill did not use stock suicide death path")

gccPlayersResult = gccSend(gccSession, "players")
gccPlayersHandoff = gccWaitForMessage(gccSession, gccPlayersResult, "print")
gccAssert(gccPlayersHandoff is not void,
  "players command did not return a client print")
gccAssert(gccplay.shutdown(gccSession), "game command session shutdown")
print "runtime_client_game_command_tests: PASS"
