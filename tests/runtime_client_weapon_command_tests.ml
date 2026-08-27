/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Real Protocol-34 string commands drive the stock player weapon state. */
import miniquake2.game.null_game as wcgame
import miniquake2.game.gameplay.item_rules as wcitems
import miniquake2.client.ui.constants as wcuiconstants
import miniquake2.client.ui.keys as wcuikeys
import miniquake2.platform.window as wcwindow
import miniquake2.qcommon.types as wcqtypes
import miniquake2.runtime.client_session as wcclient
import miniquake2.runtime.play_session as wcplay

// Assert the wc test condition.
function wcAssert(value, name)
  if not value then return error(8434, name) end if
  return true
end function

// Return the wc stabilize value.
function wcStabilize(player)
  // The synthetic protocol fixture has no BSP floor. Keep it inside the PMove
  // range so a long wheel-burst regression does not turn into a void-respawn
  // test before the pending weapon has finished lowering and activating.
  player.edict.state.origin = wcqtypes.Vec3(0.0, 0.0, 64.0)
  player.edict.state.oldOrigin = wcqtypes.Vec3(0.0, 0.0, 64.0)
  player.edict.client.playerState.pmove.origin = [0, 0, 512]
  player.edict.client.playerState.pmove.velocity = [0, 0, 0]
  player.oldPmove.origin = [0, 0, 512]
  player.oldPmove.velocity = [0, 0, 0]
  player.velocity = [0.0, 0.0, 0.0]
  return true
end function

// Send wc.
function wcSend(session, player, text, expectedIndex)
  wcAssert(wcclient.sendStringCommand(session.client, text, 0),
    "failed to send " + text)
  wcIndex = 0
  while wcIndex < 24
    wcStabilize(player)
    wcplay.step(session)
    wcIndex = wcIndex + 1
    if player.gameplay.currentWeapon is not void and
        player.gameplay.currentWeapon.index == expectedIndex then return true end if
  end while
  wcCurrentIndex = -1; wcPendingIndex = -1
  if player.gameplay.currentWeapon is not void then
    wcCurrentIndex = player.gameplay.currentWeapon.index
  end if
  if player.gameplay.newWeapon is not void then
    wcPendingIndex = player.gameplay.newWeapon.index
  end if
  return error(8434, "weapon transition timed out for " + text +
    ": expected=" + expectedIndex + " current=" + wcCurrentIndex +
    " pending=" + wcPendingIndex + " state=" + player.gameplay.weaponState +
    " frame=" + player.gameplay.gunFrame)
end function

// Return the wc wheel value.
function wcWheel(session, player, input, value, expectedCommand, expectedIndex)
  wcAssert(wcuikeys.handleEvent(input,
    wcwindow.InputEvent(wcuiconstants.EVENT_MOUSE_WHEEL, 0, value), 0),
    "wheel event was rejected")
  wcPending = wcuikeys.drainCommands(input)
  wcAssert(len(wcPending) == 1, "wheel event did not produce exactly one command")
  wcAssert(wcPending[0] == expectedCommand, "wheel event produced " + wcPending[0])
  return wcSend(session, player, wcPending[0], expectedIndex)
end function

wcEntities = "{\n\"classname\" \"worldspawn\"\n\"message\" \"Weapon Commands\"\n}\n" +
  "{\n\"classname\" \"info_player_start\"\n\"origin\" \"0 0 64\"\n}\n"
wcSession = wcplay.createCore("weapon_commands", wcEntities, void,
  "\\name\\CommandTest\\skin\\male/grunt")
wcplay.runUntilActive(wcSession, 256)
wcPlayer = wcgame.playerContext().players[0]
wcRegistry = wcgame.playerContext().registry
wcShotgun = wcitems.findByPickupName(wcRegistry, "Shotgun")
wcShells = wcitems.findByPickupName(wcRegistry, "Shells")
wcRocket = wcitems.findByPickupName(wcRegistry, "Rocket Launcher")
wcRockets = wcitems.findByPickupName(wcRegistry, "Rockets")
wcShotgunIndex = wcShotgun.index
wcShellsIndex = wcShells.index
wcRocketIndex = wcRocket.index
wcRocketsIndex = wcRockets.index
wcPlayer.gameplay.inventory.counts[wcShotgunIndex] = 1
wcPlayer.gameplay.inventory.counts[wcShellsIndex] = 20
wcPlayer.gameplay.inventory.counts[wcRocketIndex] = 1
wcPlayer.gameplay.inventory.counts[wcRocketsIndex] = 10

wcSend(wcSession, wcPlayer, "use Rocket Launcher", wcRocketIndex)
wcAssert(wcPlayer.gameplay.currentWeapon.index == wcRocketIndex,
  "named use command did not select Rocket Launcher")
wcAssert(wcSession.client.integrated.client.current.playerState.gunIndex > 0,
  "weapon command did not reach the client view model")

// Stock g_cmds.c WeapNext scans downward through itemlist; from the Rocket
// Launcher the first owned/usable entry is the Shotgun in this inventory.
wcSend(wcSession, wcPlayer, "weapnext", wcShotgunIndex)
wcAssert(wcPlayer.gameplay.currentWeapon.index == wcShotgunIndex,
  "weapnext did not select the next owned usable weapon")
wcSend(wcSession, wcPlayer, "weapprev", wcRocketIndex)
wcAssert(wcPlayer.gameplay.currentWeapon.index == wcRocketIndex,
  "weapprev did not select the previous owned usable weapon")
// The collision-free protocol fixture has no floor; retain the owned item
// explicitly so an unrelated eventual void respawn cannot invalidate this
// command-specific assertion.
wcPlayer.gameplay.inventory.counts[wcShotgunIndex] = 1
wcPlayer.gameplay.inventory.counts[wcShellsIndex] = 20
wcSend(wcSession, wcPlayer, "weaplast", wcShotgunIndex)
wcAssert(wcPlayer.gameplay.currentWeapon.index == wcShotgunIndex,
  "weaplast did not restore the previous weapon")

// Exercise the complete Win32-shaped wheel event -> binding -> Protocol-34
// string-command -> Game API transition path in both directions.
wcWheelInput = wcuikeys.bindDefaultGame(wcuikeys.createInputState())
wcWheel(wcSession, wcPlayer, wcWheelInput, 255, "weapprev", wcRocketIndex)
wcPlayer.gameplay.inventory.counts[wcShotgunIndex] = 1
wcPlayer.gameplay.inventory.counts[wcShellsIndex] = 20
wcPlayer.gameplay.inventory.counts[wcRocketIndex] = 1
wcPlayer.gameplay.inventory.counts[wcRocketsIndex] = 10
wcWheel(wcSession, wcPlayer, wcWheelInput, 1, "weapnext", wcShotgunIndex)

// One Windows poll can contain a large detent burst. It must stay bounded and
// yield one effective transition rather than copying and transmitting 128
// identical command arrays.
wcBurst = 0
while wcBurst < 128
  wcuikeys.handleEvent(wcWheelInput,
    wcwindow.InputEvent(wcuiconstants.EVENT_MOUSE_WHEEL, 0, 255), wcBurst)
  wcBurst = wcBurst + 1
end while
wcBurstCommands = wcuikeys.drainCommands(wcWheelInput)
wcAssert(len(wcBurstCommands) == 1, "wheel burst was not bounded")
wcAssert(wcBurstCommands[0] == "weapprev", "wheel burst direction changed")
wcPlayer.gameplay.inventory.counts[wcShotgunIndex] = 1
wcPlayer.gameplay.inventory.counts[wcShellsIndex] = 20
wcPlayer.gameplay.inventory.counts[wcRocketIndex] = 1
wcPlayer.gameplay.inventory.counts[wcRocketsIndex] = 10
wcSend(wcSession, wcPlayer, wcBurstCommands[0], wcRocketIndex)

// An unavailable named weapon is rejected without disturbing the selection.
wcRejectedBefore = wcgame.lifecycleSnapshot()[6]
wcAssert(wcclient.sendStringCommand(wcSession.client, "use BFG10K", 0),
  "failed to send unavailable BFG command")
wcRejectedSteps = 0
while wcgame.lifecycleSnapshot()[6] == wcRejectedBefore and wcRejectedSteps < 24
  wcplay.step(wcSession)
  wcRejectedSteps = wcRejectedSteps + 1
end while
wcAssert(wcgame.lifecycleSnapshot()[6] == wcRejectedBefore + 1,
  "unavailable BFG command did not reach Game API")
wcAssert(wcPlayer.gameplay.currentWeapon.index == wcRocketIndex,
  "unowned named weapon changed selection")
wcAssert(wcgame.lifecycleSnapshot()[6] == 8,
  "Game API did not receive every weapon string command")
wcAssert(wcplay.shutdown(wcSession), "weapon command session shutdown")
print "runtime_client_weapon_command_tests: PASS"
