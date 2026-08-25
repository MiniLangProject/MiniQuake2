/* Real Protocol-34 string commands drive the stock player weapon state. */
import miniquake2.game.null_game as wcgame
import miniquake2.game.gameplay.item_rules as wcitems
import miniquake2.runtime.client_session as wcclient
import miniquake2.runtime.play_session as wcplay

function wcAssert(value, name)
  if not value then return error(8434, name) end if
  return true
end function

function wcSend(session, player, text, expectedIndex)
  wcAssert(wcclient.sendStringCommand(session.client, text, 0),
    "failed to send " + text)
  wcIndex = 0
  while wcIndex < 24
    wcplay.step(session)
    wcIndex = wcIndex + 1
    if player.gameplay.currentWeapon is not void and
        player.gameplay.currentWeapon.index == expectedIndex then return true end if
  end while
  return error(8434, "weapon transition timed out for " + text)
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
wcAssert(wcPlayer.gameplay.currentWeapon.index == wcShotgunIndex,
  "unowned named weapon changed selection")
wcAssert(wcgame.lifecycleSnapshot()[6] == 5,
  "Game API did not receive every weapon string command")
wcAssert(wcplay.shutdown(wcSession), "weapon command session shutdown")
print "runtime_client_weapon_command_tests: PASS"
