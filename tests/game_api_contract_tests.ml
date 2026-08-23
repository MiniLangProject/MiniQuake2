/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later

Contract tests for the managed Quake II Game API v3 boundary. No retail data
or native game DLL is required.
*/
import miniquake2.game.constants as c
import miniquake2.game.types as t
import miniquake2.game.null_game as game
import std.string as text

logLines = []

function assertEqual(actual, expected, name)
  if actual != expected then return error(3900, name + ": expected " + expected + ", got " + actual) end if
  return true
end function

function assertTrue(value, name)
  if value != true then return error(3901, name + ": expected true") end if
  return true
end function

function assertErrorContains(value, fragment, name)
  if value is not error then return error(3902, name + ": expected error") end if
  if text.contains(value.message, fragment) != true then return error(3903, name + ": unexpected message " + value.message) end if
  return true
end function

function noop()
  return true
end function

function entityNoop(entity)
  return true
end function

function stringIndex(name)
  return 1
end function

function setConfigString(index, value)
  return true
end function

function setModel(entity, name)
  entity.state.modelIndex = 1
  return true
end function

function recordDebug(text)
  global logLines
  logLines = logLines + [text]
  return true
end function

function collisionUnavailable()
  return false
end function

function makeImports()
  return t.GameImport(
    noop, recordDebug, noop, noop,
    noop, noop, setConfigString, noop,
    stringIndex, stringIndex, stringIndex, setModel,
    noop, noop, noop, noop, noop, noop,
    entityNoop, entityNoop, noop, noop,
    noop, noop,
    noop, noop, noop, noop, noop, noop, noop, noop, noop,
    noop, noop, noop,
    noop, noop, noop,
    noop, noop, noop,
    noop, noop, collisionUnavailable
  )
end function

function testVersionAndValidation()
  assertEqual(c.GAME_API_VERSION, 3, "game API version constant")
  imports = makeImports()
  invalid = makeImports()
  invalid.trace = void
  rejected = try(game.GetGameApi(invalid))
  assertErrorContains(rejected, "trace", "missing import callback")

  api = game.GetGameApi(imports)
  assertTrue(game.apiInstalled(), "active export installed")
  assertEqual(api.apiVersion, 3, "exported API version")
  assertEqual(typeof(api.init), "function", "Init function value")
  assertEqual(typeof(api.spawnEntities), "function", "SpawnEntities function value")
  assertEqual(typeof(api.clientThink), "function", "ClientThink function value")
  assertEqual(api.edictSize, c.MINILANG_EDICT_STRIDE, "managed edict stride before Init")
  return api
end function

function testLifecycleAndEdicts(api)
  assertErrorContains(try(api.runFrame()), "not initialized", "RunFrame before Init")
  assertTrue(api.init(), "Init dispatch")
  assertEqual(len(logLines), 1, "Init import callback dispatch")
  assertTrue(text.contains(logLines[0], "Init"), "Init callback message")
  assertEqual(api.maxEdicts, 1024, "maximum edicts")
  assertEqual(len(api.edicts), api.maxEdicts, "allocated edict array")
  assertEqual(api.numEdicts, 1, "world edict count")
  assertEqual(api.edictSize, 1, "managed edict stride")
  assertEqual(api.edicts[0].state.number, 0, "world state number")
  assertEqual(api.edicts[0].inUse, true, "world in use")

  entity = game.edictAt(17)
  assertEqual(entity.state.number, 17, "edict index stored in entity state")
  assertEqual(game.edictIndex(entity), 17, "edict reverse index")
  assertEqual(game.edictOffset(17), 17, "logical edict stride offset")
  assertErrorContains(try(game.edictIndex(t.zeroEdict(17))), "not owned", "forged edict rejected")
  assertErrorContains(try(game.edictAt(-1)), "out of range", "negative edict index")
  assertErrorContains(try(game.edictAt(api.maxEdicts)), "out of range", "maximum edict index")
  assertErrorContains(try(api.init()), "already initialized", "double Init")

  assertTrue(api.spawnEntities("base1", "{\"classname\" \"worldspawn\"}", "start"), "SpawnEntities dispatch")
  snapshot = game.lifecycleSnapshot()
  assertEqual(snapshot[1], true, "map loaded")
  assertEqual(snapshot[2], "base1", "map name")
  assertEqual(snapshot[3], "start", "spawn point")
  assertErrorContains(try(api.spawnEntities("", "", "")), "empty map name", "empty map rejected")
  return true
end function

function testClientAndFrameCallbacks(api)
  clientEntity = game.edictAt(2)
  assertTrue(api.clientConnect(clientEntity, "\\name\\Ranger"), "ClientConnect dispatch")
  assertTrue(api.clientBegin(clientEntity), "ClientBegin dispatch")
  assertEqual(api.edicts[2].inUse, true, "client active")
  assertEqual(api.numEdicts, 3, "high-water edict count")
  assertTrue(api.clientUserinfoChanged(clientEntity, "\\name\\Bitterman"), "ClientUserinfoChanged dispatch")
  assertTrue(api.clientCommand(clientEntity), "ClientCommand dispatch")

  command = t.zeroUserCmd()
  command.angles = [100, -200, 300]
  assertTrue(api.clientThink(clientEntity, command), "ClientThink dispatch")
  assertEqual(api.edicts[2].client.playerState.pmove.deltaAngles[1], -200, "ClientThink command transfer")

  api.edicts[2].state.event = c.EV_FOOTSTEP
  assertTrue(api.runFrame(), "RunFrame dispatch")
  assertEqual(api.edicts[2].state.event, c.EV_NONE, "one-frame entity event cleared")
  snapshot = game.lifecycleSnapshot()
  assertEqual(snapshot[4], 1, "frame counter")
  assertEqual(snapshot[5], "\\name\\Bitterman", "latest userinfo")
  assertEqual(snapshot[6], 1, "client command count")

  assertTrue(api.serverCommand(), "ServerCommand dispatch")
  assertEqual(game.lifecycleSnapshot()[7], 1, "server command count")
  assertTrue(api.clientDisconnect(clientEntity), "ClientDisconnect dispatch")
  assertEqual(api.edicts[2].inUse, false, "client inactive")
  assertTrue(api.edicts[2].client is void, "client prefix cleared")
  assertErrorContains(try(api.clientCommand(clientEntity)), "not connected", "command after disconnect")
  return true
end function

function testPersistenceErrorsAndShutdown(api)
  assertErrorContains(try(api.writeGame("", false)), "empty save filename", "WriteGame validates path")
  assertErrorContains(try(api.readGame("")), "empty save filename", "ReadGame validates path")
  assertErrorContains(try(api.writeLevel("")), "empty save filename", "WriteLevel validates path")
  assertErrorContains(try(api.readLevel("")), "empty save filename", "ReadLevel validates path")
  assertErrorContains(try(api.writeGame("", false)), "empty save filename", "empty save filename")

  assertTrue(api.shutdown(), "Shutdown dispatch")
  assertEqual(api.numEdicts, 0, "edict count after Shutdown")
  assertEqual(api.maxEdicts, 0, "maximum edicts after Shutdown")
  assertEqual(len(api.edicts), 0, "edict storage after Shutdown")
  assertEqual(len(logLines), 4, "lifecycle and command debug dispatch")
  assertTrue(text.contains(logLines[3], "Shutdown"), "Shutdown callback message")
  assertErrorContains(try(api.shutdown()), "not initialized", "double Shutdown")
  return true
end function

function main(args)
  print "MiniQuake2 Game API tests starting: 4"
  api = testVersionAndValidation()
  testLifecycleAndEdicts(api)
  testClientAndFrameCallbacks(api)
  testPersistenceErrorsAndShutdown(api)
  print "MiniQuake2 Game API tests passed: 4"
  return 0
end function
