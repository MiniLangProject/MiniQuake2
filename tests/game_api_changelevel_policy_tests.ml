/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Original g_target.c target_changelevel policies through the live Game API. */
import miniquake2.game.null_game as clgame
import miniquake2.game.integration.baseq2 as clintegration
import miniquake2.game.world.core as clworld
import miniquake2.game.constants as clconstants
import miniquake2.server.game_bridge as clbridge
import std.string as clstring

// Assert the equal test condition.
function assertEqual(actual, expected, name)
  if actual != expected then return error(9650, name + ": values differ") end if
  return true
end function

// Assert the true test condition.
function assertTrue(value, name)
  if value != true then return error(9651, name + ": expected true") end if
  return true
end function

// Return the fixture value.
function fixture(destination)
  return "{ \"classname\" \"worldspawn\" }\n" +
    "{ \"classname\" \"info_player_start\" \"origin\" \"0 0 0\" }\n" +
    "{ \"classname\" \"info_player_intermission\" \"origin\" \"64 0 32\" }\n" +
    "{ \"classname\" \"target_changelevel\" \"map\" \"" +
      destination + "\" }"
end function

// Install state.
function install(mapName, destination)
  server = clbridge.createRuntime(4)
  api = clgame.GetGameApi(clbridge.makeImports(server))
  server.game = api
  api.init()
  api.spawnEntities(mapName, fixture(destination), "")
  client = clgame.edictAt(1)
  assertTrue(api.clientConnect(client,
    "\\name\\Ranger\\skin\\male/grunt"), "connect")
  assertTrue(api.clientBegin(client), "begin")
  return [server, api, client]
end function

// Activate target.
function activateTarget()
  runtime = clgame.baseRuntime()
  player = clgame.playerContext().players[0]
  change = clintegration.findWorldByClass(runtime, "target_changelevel")
  proxy = clintegration.playerWorldProxy(player)
  return change.use(change, proxy, proxy, runtime.world)
end function

// Report whether has broadcast.
function hasBroadcast(server, value)
  for each entry in server.logs
    if entry[0] == "broadcast" and entry[1] == value then return true end if
  end for
  return false
end function

// Verify dead single player guard.
function testDeadSinglePlayerGuard()
  session = install("base1", "base2")
  api = session[1]
  player = clgame.playerContext().players[0]
  player.health = 0
  assertTrue(not activateTarget(), "dead single-player exit rejected")
  assertTrue(not clgame.baseRuntime().world.intermission,
    "dead single-player exit leaves world active")
  assertEqual(clgame.playerContext().intermissionTime, 0.0,
    "dead single-player exit does not begin intermission")
  api.shutdown()
  return true
end function

// Report whether test deathmatch no exit damage.
function testDeathmatchNoExitDamage()
  session = install("q2dm1", "q2dm2")
  api = session[1]
  context = clgame.playerContext()
  context.deathmatch = true
  context.dmFlags = 0
  player = context.players[0]
  assertTrue(not activateTarget(), "deathmatch no-exit rejects transition")
  assertTrue(player.health <= 0, "deathmatch no-exit kills activator")
  assertTrue(clstring.contains(player.obituary, "found a way out"),
    "deathmatch no-exit uses MOD_EXIT obituary")
  assertTrue(not clgame.baseRuntime().world.intermission,
    "deathmatch no-exit leaves world active")
  api.shutdown()
  return true
end function

// Verify deathmatch allowed exit.
function testDeathmatchAllowedExit()
  session = install("q2dm1", "q2dm2")
  server = session[0]; api = session[1]
  context = clgame.playerContext()
  context.deathmatch = true
  context.dmFlags = clconstants.DF_ALLOW_EXIT
  assertTrue(activateTarget(), "deathmatch allow-exit transitions")
  assertTrue(clgame.baseRuntime().world.intermission,
    "deathmatch allow-exit begins intermission")
  assertEqual(context.nextMap, "q2dm2", "deathmatch exit destination")
  assertTrue(hasBroadcast(server, "Ranger exited the level.\n"),
    "deathmatch exit broadcasts activator")
  api.shutdown()
  return true
end function

// Verify fact 1 mapper repair.
function testFact1MapperRepair()
  session = install("FaCt1", "FaCt3")
  api = session[1]
  change = clintegration.findWorldByClass(clgame.baseRuntime(),
    "target_changelevel")
  assertEqual(change.map, "fact3$secret1",
    "fact1 mapper repair occurs during spawn")
  assertTrue(activateTarget(), "fact1 repaired exit activates")
  assertEqual(clgame.playerContext().nextMap, "fact3$secret1",
    "fact1 repaired destination reaches intermission")
  api.shutdown()
  return true
end function

print "MiniQuake2 target_changelevel policy tests starting: 4"
testDeadSinglePlayerGuard()
testDeathmatchNoExitDamage()
testDeathmatchAllowedExit()
testFact1MapperRepair()
print "MiniQuake2 target_changelevel policy tests passed: 4"
