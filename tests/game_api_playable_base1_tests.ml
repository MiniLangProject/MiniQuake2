/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later

Playable, asset-free base1 slice through GetGameApi: spawn diagnostics, player
frames, trigger/mover dispatch, stock pickup/weapon state and monster lifecycle.
*/
import miniquake2.game.null_game as pbgapi
import miniquake2.game.integration.baseq2 as pbgintegration
import miniquake2.game.gameplay.item_rules as pbgitems
import miniquake2.game.ai.constants as pbgaiconstants
import miniquake2.game.world.constants as pbgworldconstants
import miniquake2.game.constants as pbggconstants
import miniquake2.qcommon.types as pbgqtypes
import miniquake2.server.game_bridge as pbgbridge

function assertEqual(actual, expected, name)
  if actual != expected then return error(9970, name + ": values differ") end if
  return true
end function

function assertTrue(value, name)
  if value != true then return error(9971, name + ": expected true") end if
  return true
end function

function base1Fixture()
  return "{ \"classname\" \"worldspawn\" \"message\" \"Playable base1\" }\n" +
    "{ \"classname\" \"info_player_start\" \"origin\" \"0 0 0\" \"angle\" \"0\" }\n" +
    "{ \"classname\" \"info_player_coop\" \"origin\" \"16 0 0\" }\n" +
    "{ \"classname\" \"path_corner\" \"targetname\" \"patrol_a\" \"origin\" \"80 0 10\" }\n" +
    "{ \"classname\" \"func_door\" \"targetname\" \"door_a\" \"origin\" \"128 0 10\" \"speed\" \"80\" }\n" +
    "{ \"classname\" \"trigger_once\" \"target\" \"door_a\" \"origin\" \"128 0 10\" }\n" +
    "{ \"classname\" \"weapon_shotgun\" \"origin\" \"200 0 10\" }\n" +
    "{ \"classname\" \"ammo_shells\" \"origin\" \"210 0 10\" }\n" +
    // Keep the lifecycle target outside the player's +X weapon line.  Real
    // integrated ballistics now damages in-line monsters; that behavior has a
    // separate combat vertical-slice suite and must not pre-kill this fixture.
    "{ \"classname\" \"monster_soldier\" \"origin\" \"96 96 10\" \"angle\" \"180\" \"target\" \"patrol_a\" \"death_target\" \"death_relay\" }\n" +
    "{ \"classname\" \"trigger_relay\" \"targetname\" \"death_relay\" \"target\" \"door_a\" }\n" +
    "{ \"classname\" \"unsupported_base1_probe\" }\n" +
    "{ \"classname\" \"unsupported_base1_probe\" }"
end function

function main(args)
  print "MiniQuake2 playable base1 Game API tests starting: 5"
  server = pbgbridge.createRuntime(4)
  api = pbgapi.GetGameApi(pbgbridge.makeImports(server))
  server.game = api
  api.init()
  api.spawnEntities("base1", base1Fixture(), "")

  // 1. Stock registry dispatch and aggregated unknown-class reporting.
  spawned = pbgapi.spawnResult()
  runtime = pbgapi.baseRuntime()
  assertEqual(spawned.sourceEntityCount, 12, "source entity count")
  assertEqual(spawned.skippedEntityCount, 2, "skipped entity count")
  assertEqual(len(spawned.skippedClasses), 1, "aggregated skipped classes")
  assertEqual(spawned.skippedClasses[0].className, "unsupported_base1_probe", "skipped class name")
  assertEqual(spawned.skippedClasses[0].count, 2, "skipped class aggregate")
  assertEqual(len(runtime.items), 2, "stock item dispatch")
  assertEqual(len(runtime.monsters), 1, "stock monster dispatch")
  assertTrue(pbgintegration.findWorldByClass(runtime, "info_player_coop") is not void, "coop spawn preserved")
  assertTrue(pbgintegration.findWorldByClass(runtime, "path_corner") is not void, "AI path corner preserved")
  assertTrue(runtime.monsters[0].goalEntity is not void, "AI path corner adapted")
  assertEqual(runtime.monsters[0].goalEntity.className, "path_corner", "AI path corner class")
  assertEqual(runtime.monsters[0].goalEntity.edict.state.origin.x, 80.0, "AI path corner origin")

  // 2. The exported callbacks drive real connect/begin/PMove/frame/end state.
  client = pbgapi.edictAt(1)
  assertTrue(api.clientConnect(client, "\\name\\Ranger\\skin\\male/grunt"), "client connect")
  assertTrue(api.clientBegin(client), "client begin")
  player = pbgapi.playerContext().players[0]
  assertEqual(player.edict.state.origin.z, 10.0, "spawn origin")
  activationFrame = 0
  while activationFrame < 5
    api.runFrame()
    activationFrame = activationFrame + 1
  end while
  attack = pbgqtypes.UserCmd(100, pbggconstants.BUTTON_ATTACK, [0, 0, 0], 0, 0, 0, 0, 64)
  assertTrue(api.clientThink(client, attack), "client think")
  assertEqual(player.gameplay.fireCount, 1, "blaster fired through ClientThink")
  assertTrue(api.runFrame(), "server frame")
  assertEqual(pbgapi.playerContext().frameNumber, 6, "player frame advanced")
  assertEqual(client.client.playerState.stats[pbggconstants.STAT_HEALTH], 100, "end-frame HUD")
  release = pbgqtypes.UserCmd(100, 0, [0, 0, 0], 0, 0, 0, 0, 64)
  api.clientThink(client, release)

  // 3. A managed trigger_once reaches the managed func_door callback.
  door = pbgintegration.findWorldByClass(runtime, "func_door")
  trigger = pbgintegration.findWorldByClass(runtime, "trigger_once")
  assertEqual(door.moveInfo.state, pbgworldconstants.STATE_BOTTOM, "door initially closed")
  player.velocity = [1.0, 2.0, 3.0]
  assertTrue(pbgintegration.touchWorld(runtime, trigger, player), "trigger touch")
  assertEqual(player.velocity[0], 1.0, "trigger preserves player velocity x")
  assertEqual(player.velocity[1], 2.0, "trigger preserves player velocity y")
  assertEqual(player.velocity[2], 3.0, "trigger preserves player velocity z")
  assertTrue(door.moveInfo.state != pbgworldconstants.STATE_BOTTOM, "door activated")
  assertTrue(trigger.touch is void, "trigger once consumed")

  // 4. Stock pickup and Weapon_Generic switching/firing stay behind player frames.
  shotgunEntity = pbgintegration.findItemByClass(runtime, "weapon_shotgun")
  shellsEntity = pbgintegration.findItemByClass(runtime, "ammo_shells")
  shotgunAction = pbgintegration.touchItem(runtime, shotgunEntity, player, pbgapi.playerContext())
  shellsAction = pbgintegration.touchItem(runtime, shellsEntity, player, pbgapi.playerContext())
  assertTrue(shotgunAction.success, "shotgun pickup")
  assertTrue(shellsAction.success, "shell pickup")
  shotgun = pbgitems.findByPickupName(pbgapi.playerContext().registry, "Shotgun")
  shells = pbgitems.findByPickupName(pbgapi.playerContext().registry, "Shells")
  assertEqual(player.gameplay.inventory.counts[shotgun.index], 1, "shotgun inventory")
  frame = 0
  while frame < 16
    api.runFrame()
    frame = frame + 1
  end while
  assertEqual(player.gameplay.currentWeapon.className, "weapon_shotgun", "shotgun activated")
  shellsBefore = player.gameplay.inventory.counts[shells.index]
  api.clientThink(client, attack)
  assertEqual(player.gameplay.fireCount, 2, "shotgun fired")
  assertEqual(player.gameplay.inventory.counts[shells.index], shellsBefore - 1, "shotgun ammo consumed")

  // 5. Player visibility, think, pain and death callbacks form one lifecycle.
  api.runFrame()
  monster = runtime.monsters[0]
  assertTrue(monster.enemy is not void, "monster acquired exported player")
  painBefore = monster.painCount
  assertTrue(pbgintegration.damageMonster(runtime, 0, runtime.aiPlayers[0], 5), "monster pain dispatch")
  assertEqual(monster.painCount, painBefore + 1, "monster pain count")
  assertTrue(pbgintegration.damageMonster(runtime, 0, runtime.aiPlayers[0], 100), "monster death dispatch")
  assertEqual(monster.dieCount, 1, "monster death count")
  assertEqual(monster.deadFlag, pbgaiconstants.DEAD_DEAD, "monster dead state")

  api.clientDisconnect(client)
  api.shutdown()
  print "MiniQuake2 playable base1 Game API tests passed: 5"
  return 0
end function
