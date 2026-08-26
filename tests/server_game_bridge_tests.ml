/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* End-to-end internal Game API v3 lifecycle through the server import table. */
import miniquake2.game.constants as gc
import miniquake2.game.null_game as nullGame
import miniquake2.server.game_bridge as bridge
import miniquake2.collision.model as collision
import miniquake2.format.types as ft
import miniquake2.qcommon.constants as qc

function assertEqual(actual, expected, name)
  if actual != expected then return error(9940, name + ": expected " + expected + ", got " + actual) end if
  return true
end function

function assertTrue(value, name)
  if value != true then return error(9941, name + ": expected true") end if
  return true
end function

runtime = bridge.createRuntime(4)
imports = bridge.makeImports(runtime)
game = nullGame.GetGameApi(imports)
runtime.game = game
assertEqual(game.apiVersion, gc.GAME_API_VERSION, "Game API version")
game.init()
game.spawnEntities("base1", "{\n\"classname\" \"worldspawn\"\n}\n", "")
assertEqual(game.numEdicts, 1, "world edict after spawn")
collisionHit = collision.Trace(false, false, 0.5, ft.Vec3(1.0, 2.0, 3.0),
  collision.TracePlane(ft.Vec3(0.0, 0.0, 1.0), 4.0, 2),
  collision.CollisionSurface("floor", 7, 8), 1)
adaptedHit = bridge.adaptCollisionTrace(runtime, collisionHit)
assertEqual(adaptedHit.entity.state.number, 0, "collision hit maps to world entity")
assertEqual(adaptedHit.plane.signBits, 0, "collision plane sign bits")
index = imports.modelIndex("models/objects/gibs/sm_meat/tris.md2")
assertTrue(index > 1, "model index allocation after map/stock precache")
assertEqual(imports.modelIndex("models/objects/gibs/sm_meat/tris.md2"), index, "model index reuse")
assertEqual(runtime.configStrings[qc.CS_MODELS + 1], "maps/base1.bsp", "reserved map model configstring")
assertEqual(runtime.configStrings[qc.CS_MODELS + index], "models/objects/gibs/sm_meat/tris.md2", "model configstring publication")
allocatedSoundIndex = imports.soundIndex("weapons/blastf1a.wav")
assertEqual(runtime.configStrings[qc.CS_SOUNDS + allocatedSoundIndex], "weapons/blastf1a.wav", "sound configstring publication")
allocatedImageIndex = imports.imageIndex("w_blaster")
assertEqual(runtime.configStrings[qc.CS_IMAGES + allocatedImageIndex], "w_blaster", "image configstring publication")
imports.configString(0, "Unit Test Server")
assertEqual(runtime.configStrings[0], "Unit Test Server", "configstring handoff")
client = game.edicts[1]
assertTrue(game.clientConnect(client, "\\name\\Ranger"), "client connect")
game.clientBegin(client)
game.runFrame()
snapshot = nullGame.lifecycleSnapshot()
assertEqual(snapshot[4], 1, "game frame count")
assertTrue(len(runtime.logs) >= 2, "game debug log handoff")
assertTrue(try(game.writeGame("save/current/server.ssv", false)) is error, "persistence fails explicitly")
game.clientDisconnect(client)
game.shutdown()
print "server_game_bridge_tests: PASS"
