/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later

End-to-end managed Game API test with real BaseQ2 dispatch and player PMove.
*/
import miniquake2.game.null_game as e2egame
import miniquake2.game.types as e2egtypes
import miniquake2.qcommon.types as e2eqtypes
import miniquake2.server.game_bridge as e2ebridge
import miniquake2.game.integration.baseq2 as e2eintegration
import miniquake2.game.world.core as e2eworld
import miniquake2.game.ai.constants as e2eai
import miniquake2.game.constants as e2econstants

function assertEqual(actual, expected, name)
  if actual != expected then return error(9960, name + ": values differ") end if
  return true
end function

function assertTrue(value, name)
  if value != true then return error(9961, name + ": expected true") end if
  return true
end function

function entityText()
  return "{ \"classname\" \"worldspawn\" }\n" +
    "{ \"classname\" \"info_player_start\" \"origin\" \"16 24 32\" \"angle\" \"90\" }\n" +
    "{ \"classname\" \"trigger_multiple\" \"target\" \"exit\" }\n" +
    "{ \"classname\" \"weapon_shotgun\" \"origin\" \"40 40 40\" }\n" +
    "{ \"classname\" \"monster_infantry\" \"origin\" \"80 0 24\" }\n" +
    "{ \"classname\" \"monster_infantry\" \"targetname\" \"wake-monster\" \"spawnflags\" \"2\" \"origin\" \"96 0 24\" }\n" +
    "{ \"classname\" \"trigger_relay\" \"target\" \"wake-monster\" }\n" +
    "{ \"classname\" \"monster_brain\" \"origin\" \"128 0 24\" }\n" +
    "{ \"classname\" \"trigger_gravity\" \"gravity\" \"0.5\" }\n" +
    "{ \"classname\" \"trigger_push\" \"angle\" \"90\" \"speed\" \"100\" }\n" +
    "{ \"classname\" \"func_door\" \"model\" \"*1\" }"
end function

function e2eFindMonster(runtime, className, targetName)
  for each actor in runtime.monsters
    if actor.className == className and actor.targetName == targetName then
      return actor
    end if
  end for
  return void
end function

function main(args)
  print "MiniQuake2 Game API BaseQ2 integration starting: 1"
  server = e2ebridge.createRuntime(4)
  api = e2egame.GetGameApi(e2ebridge.makeImports(server))
  api.init()
  api.spawnEntities("base1", entityText(), "")
  assertEqual(api.edicts[0].state.number, 0, "world edict")
  assertEqual(api.edicts[5].state.number, 5, "map entities follow client slots")
  assertEqual(api.edicts[8].state.number, 8, "monster edict mapping")

  client = e2egame.edictAt(1)
  assertTrue(api.clientConnect(client, "\\name\\Ranger\\skin\\male/grunt"), "client connect")
  assertTrue(api.clientBegin(client), "client begin")
  assertTrue(client.inUse, "client linked")
  assertEqual(client.state.origin.x, 16.0, "player spawn x")
  assertEqual(client.state.origin.z, 42.0, "player spawn z")

  command = e2eqtypes.UserCmd(100, 0, [0, 0, 0], 200, 0, 0, 0, 32)
  api.clientThink(client, command)
  api.runFrame()
  base = e2egame.baseRuntime()
  players = e2egame.playerContext()
  assertEqual(base.world.time, 0.1, "world frame")
  assertEqual(base.monsters[0].thinkKind, "monster-think", "monster frame")
  assertEqual(players.frameNumber, 1, "player frame")
  assertTrue(client.state.origin.x != 16.0 or client.state.origin.y != 24.0, "PMove handoff")
  assertEqual(api.numEdicts, 16, "dynamic door trigger owns an engine edict")
  assertTrue(e2eintegration.findWorldByClass(base, "door_trigger") is not void,
    "untargeted door creates its live trigger")

  triggered = e2eFindMonster(base, "monster_infantry", "wake-monster")
  assertEqual(triggered.thinkKind, "triggered-wait",
    "trigger-spawn monster remains hidden")
  relay = e2eintegration.findWorldByClass(base, "trigger_relay")
  activator = e2eintegration.playerWorldProxy(players.players[0])
  assertTrue(e2eworld.useEntity(base.world, relay, void, activator),
    "relay resolves monster target proxy")
  assertEqual(triggered.thinkKind, "triggered-spawn",
    "monster target use schedules spawn")
  api.runFrame()
  assertEqual(triggered.edict.solid, e2econstants.SOLID_BBOX,
    "triggered monster becomes solid")
  assertEqual(triggered.edict.serverFlags & e2econstants.SVF_NOCLIENT, 0,
    "triggered monster becomes visible")

  brain = e2eFindMonster(base, "monster_brain", "")
  taken = base.aiContext.damage(brain, 30, 0, e2eai.MOD_LAVA)
  assertEqual(taken, 20, "Brain screen absorbs one third")
  assertEqual(brain.health, 280, "Brain takes post-screen damage")
  assertEqual(brain.powerArmorPower, 90, "Brain consumes screen cells")

  gravity = e2eintegration.findWorldByClass(base, "trigger_gravity")
  assertTrue(e2eintegration.touchWorld(base, gravity, players.players[0]),
    "live player touches gravity trigger")
  assertEqual(players.players[0].gravity, 0.5,
    "gravity trigger reaches player PMove state")
  push = e2eintegration.findWorldByClass(base, "trigger_push")
  assertTrue(e2eintegration.touchWorld(base, push, players.players[0]),
    "live player touches push trigger")
  assertEqual(players.players[0].view.oldVelocity[1],
    players.players[0].velocity[1], "push copies prediction velocity")
  assertTrue(players.players[0].flySoundDebounceTime > base.world.time,
    "push persists client sound debounce")

  api.clientDisconnect(client)
  api.shutdown()
  print "MiniQuake2 Game API BaseQ2 integration passed: 1"
  return 0
end function
