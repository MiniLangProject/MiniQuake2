/* Asset-free Game API combat vertical slice for player and stock monster fire. */
import miniquake2.game.null_game as cvgameapi
import miniquake2.game.integration.baseq2 as cvintegration
import miniquake2.game.player.constants as cvplayerconstants
import miniquake2.game.ai.constants as cvaiconstants
import miniquake2.game.constants as cvgconstants
import miniquake2.qcommon.types as cvqtypes
import miniquake2.server.game_bridge as cvbridge

function assertEqual(actual, expected, name)
  if actual != expected then return error(9980, name + ": values differ") end if
  return true
end function

function assertTrue(value, name)
  if value != true then return error(9981, name + ": expected true") end if
  return true
end function

function install(entityText)
  server = cvbridge.createRuntime(4)
  api = cvgameapi.GetGameApi(cvbridge.makeImports(server))
  server.game = api
  api.init()
  api.spawnEntities("base1", entityText, "")
  client = cvgameapi.edictAt(1)
  assertTrue(api.clientConnect(client, "\\name\\Ranger\\skin\\male/grunt"), "connect")
  assertTrue(api.clientBegin(client), "begin")
  return [server, api, client]
end function

function runFrames(api, count)
  frame = 0
  while frame < count
    api.runFrame()
    frame = frame + 1
  end while
  return count
end function

function command(buttons)
  return cvqtypes.UserCmd(0, buttons, [0, 0, 0], 0, 0, 0, 0, 64)
end function

function damageEventCount(runtime)
  count = 0
  for each event in runtime.weaponContext.events
    if event[1] == "damage" then count = count + 1 end if
  end for
  return count
end function

function testPlayerProjectilePainAndDeath()
  fixture = "{ \"classname\" \"worldspawn\" }\n" +
    "{ \"classname\" \"info_player_start\" \"origin\" \"0 0 0\" \"angle\" \"0\" }\n" +
    "{ \"classname\" \"monster_soldier\" \"origin\" \"80 0 10\" \"angle\" \"180\" }"
  session = install(fixture)
  api = session[1]; client = session[2]
  runtime = cvgameapi.baseRuntime()
  monster = runtime.monsters[0]
  runFrames(api, 5)
  api.clientThink(client, command(cvgconstants.BUTTON_ATTACK))
  api.clientThink(client, command(0))
  assertEqual(len(runtime.weaponContext.projectiles), 1, "blaster projectile spawned")
  api.runFrame()
  assertEqual(monster.health, 15, "blaster health damage")
  assertEqual(monster.painCount, 1, "blaster pain dispatch")
  runFrames(api, 5)
  api.clientThink(client, command(cvgconstants.BUTTON_ATTACK))
  api.clientThink(client, command(0))
  api.runFrame()
  assertTrue(monster.health <= 0, "second blaster killed")
  assertEqual(monster.dieCount, 1, "blaster die dispatch")
  assertEqual(monster.deadFlag, cvaiconstants.DEAD_DEAD, "monster dead state")
  assertTrue(damageEventCount(runtime) >= 2, "ballistics damage events")
  api.clientDisconnect(client); api.shutdown()
  return true
end function

function testRetailSoldierHitscanAndLightProjectile()
  fixture = "{ \"classname\" \"worldspawn\" }\n" +
    "{ \"classname\" \"info_player_start\" \"origin\" \"0 0 0\" \"angle\" \"0\" }\n" +
    "{ \"classname\" \"monster_soldier\" \"origin\" \"96 0 10\" \"angle\" \"180\" }\n" +
    "{ \"classname\" \"monster_soldier_light\" \"origin\" \"-96 0 10\" \"angle\" \"0\" }"
  session = install(fixture)
  api = session[1]; client = session[2]
  player = cvgameapi.playerContext().players[0]
  runtime = cvgameapi.baseRuntime()
  api.clientThink(client, command(0))
  runFrames(api, 14)
  assertTrue(runtime.monsters[0].attackCount >= 1, "soldier attack callback")
  assertTrue(runtime.monsters[1].attackCount >= 1, "light soldier attack callback")
  assertTrue(player.health < 100, "stock attacks damaged player")
  assertTrue(damageEventCount(runtime) >= 2, "hitscan and projectile damage events")
  api.clientDisconnect(client); api.shutdown()
  return true
end function

function testPlayerHitscanWeapon()
  fixture = "{ \"classname\" \"worldspawn\" }\n" +
    "{ \"classname\" \"info_player_start\" \"origin\" \"0 0 0\" \"angle\" \"0\" }\n" +
    "{ \"classname\" \"weapon_machinegun\" \"origin\" \"200 0 10\" }\n" +
    "{ \"classname\" \"monster_soldier\" \"origin\" \"80 0 10\" \"angle\" \"180\" }"
  session = install(fixture)
  api = session[1]; client = session[2]
  player = cvgameapi.playerContext().players[0]
  runtime = cvgameapi.baseRuntime()
  pickup = cvintegration.touchItem(runtime, cvintegration.findItemByClass(runtime, "weapon_machinegun"), player, cvgameapi.playerContext())
  assertTrue(pickup.success, "machinegun pickup")
  runFrames(api, 13)
  assertEqual(player.gameplay.currentWeapon.className, "weapon_machinegun", "machinegun selected")
  healthBefore = runtime.monsters[0].health
  api.clientThink(client, command(cvgconstants.BUTTON_ATTACK))
  api.clientThink(client, command(0))
  assertEqual(runtime.monsters[0].health, healthBefore - 8, "player hitscan health damage")
  assertTrue(runtime.monsters[0].painCount >= 1, "player hitscan pain")
  api.clientDisconnect(client); api.shutdown()
  return true
end function

function testGunnerAndRetailInfantryKillPlayer()
  fixture = "{ \"classname\" \"worldspawn\" }\n" +
    "{ \"classname\" \"info_player_start\" \"origin\" \"0 0 0\" \"angle\" \"0\" }\n" +
    "{ \"classname\" \"monster_gunner\" \"origin\" \"96 0 10\" \"angle\" \"180\" }\n" +
    "{ \"classname\" \"monster_infantry\" \"origin\" \"-96 0 10\" \"angle\" \"0\" }"
  session = install(fixture)
  api = session[1]; client = session[2]
  player = cvgameapi.playerContext().players[0]
  player.health = 6
  player.persistent.health = 6
  player.gameplay.health = 6
  api.clientThink(client, command(0))
  runFrames(api, 14)
  assertTrue(cvgameapi.baseRuntime().monsters[0].attackCount >= 1, "gunner attack callback")
  assertTrue(cvgameapi.baseRuntime().monsters[1].attackCount >= 1, "retail infantry attack callback")
  assertTrue(player.health <= 0, "gunner/infantry health damage")
  assertEqual(player.deadFlag, cvplayerconstants.DEAD_DEAD, "player die state")
  assertTrue(player.obituary != "", "player obituary")
  api.clientDisconnect(client); api.shutdown()
  return true
end function

print "MiniQuake2 Game API combat vertical slice starting: 4"
testPlayerProjectilePainAndDeath()
testRetailSoldierHitscanAndLightProjectile()
testPlayerHitscanWeapon()
testGunnerAndRetailInfantryKillPlayer()
print "MiniQuake2 Game API combat vertical slice passed: 4"
