/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later

Asset-free contract tests for the first managed baseq2 gameplay package.
*/
import miniquake2.game.base.entity_parser as bparser
import miniquake2.game.base.spawn_registry as bregistry
import miniquake2.game.base.spawn as bspawn
import std.string as stext

loggedDiagnostics = []

function assertEqual(actual, expected, name)
  if actual != expected then return error(9200, name + ": values differ") end if
  return true
end function

function assertTrue(value, name)
  if value != true then return error(9201, name + ": expected true") end if
  return true
end function

function assertErrorContains(value, fragment, name)
  if value is not error then return error(9202, name + ": expected error") end if
  if stext.contains(value.message, fragment) != true then return error(9203, name + ": unexpected message " + value.message) end if
  return true
end function

function recordDiagnostic(message)
  global loggedDiagnostics
  loggedDiagnostics = loggedDiagnostics + [message]
  return true
end function

function testNewStringAndQuotedParsing()
  assertEqual(bparser.ED_NewString("line1\\nline2"), "line1\nline2", "newline escape")
  assertEqual(bparser.ED_NewString("a\\tb"), "a\\b", "non-newline escape")
  assertEqual(bparser.parseNumber(".2", "delay"), 0.2, "leading decimal point")
  assertEqual(bparser.parseNumber("-.2", "delay"), -0.2, "signed leading decimal point")
  assertEqual(bparser.parseNumber("+.2", "delay"), 0.2, "positive leading decimal point")
  assertEqual(bparser.parseNumber(".1.25", "delay"), 0.1, "retail atof numeric prefix")
  parsed = bparser.parseEntities("// comment\n{ \"classname\" \"worldspawn\" \"message\" \"Welcome marine\" }")
  assertEqual(len(parsed), 1, "quoted entity count")
  assertEqual(parsed[0].pairs[1].value, "Welcome marine", "quoted whitespace")
  world = bparser.materialize(parsed[0])
  assertEqual(world.className, "worldspawn", "classname materialized")
  assertEqual(world.message, "Welcome marine", "message materialized")
  return true
end function

function fixtureText()
  return "{\n" +
    "\"classname\" \"worldspawn\"\n" +
    "\"message\" \"Outer Base\\nEntry\"\n" +
    "\"sky\" \"unit1_\"\n" +
    "\"skyaxis\" \"0 0 1\"\n" +
    "\"skyrotate\" \"2.5\"\n" +
    "\"sounds\" \"3\"\n" +
    "\"gravity\" \"700\"\n" +
    "\"_editor_note\" \"ignored\"\n" +
    "}\n" +
    "{\n" +
    "\"classname\" \"info_player_start\"\n" +
    "\"origin\" \"1 2 3\"\n" +
    "\"angle\" \"90\"\n" +
    "\"targetname\" \"start_a\"\n" +
    "}\n" +
    "{\n" +
    "\"classname\" \"func_door\"\n" +
    "\"model\" \"*1\"\n" +
    "\"origin\" \"16 -8 4.5\"\n" +
    "\"angles\" \"0 180 0\"\n" +
    "\"spawnflags\" \"64\"\n" +
    "\"speed\" \"120\"\n" +
    "\"wait\" \"2.5\"\n" +
    "\"lip\" \"4\"\n" +
    "\"health\" \"25\"\n" +
    "\"dmg\" \"7\"\n" +
    "\"mystery_field\" \"kept-as-diagnostic\"\n" +
    "}\n" +
    "{\n" +
    "\"classname\" \"trigger_once\"\n" +
    "\"spawnflags\" \"1\"\n" +
    "\"target\" \"door_a\"\n" +
    "\"delay\" \"0.25\"\n" +
    "}\n" +
    "{\n" +
    "\"classname\" \"target_speaker\"\n" +
    "\"noise\" \"world/alarm\"\n" +
    "\"origin\" \"10 20 30\"\n" +
    "\"volume\" \"0.5\"\n" +
    "\"attenuation\" \"-1\"\n" +
    "}\n" +
    "{ \"classname\" \"future_monster\" \"origin\" \"9 8 7\" }\n"
end function

function testSpawnEntities()
  registry = bregistry.defaultRegistry()
  assertEqual(len(registry.entries), 141, "registry entry count")
  assertTrue(bregistry.find(registry, "weapon_railgun") is not void, "gameplay item spawn registered")
  assertTrue(bregistry.find(registry, "item_quad") is not void, "stock powerup spawn registered")
  assertEqual(typeof(registry.entries[0].spawn), "function", "registry function value")
  assertErrorContains(try(bregistry.register(registry, "worldspawn", registry.entries[0].spawn)), "duplicate", "duplicate registry entry")

  result = bspawn.SpawnEntities("base1", fixtureText(), "start_a")
  assertEqual(result.mapName, "base1", "map name")
  assertEqual(result.spawnPoint, "start_a", "spawn point")
  assertEqual(result.sourceEntityCount, 6, "source entity count")
  assertEqual(result.skippedEntityCount, 1, "unknown class skipped")
  assertEqual(len(result.skippedClasses), 1, "unknown class aggregate count")
  assertEqual(result.skippedClasses[0].className, "future_monster", "unknown class aggregate name")
  assertEqual(result.skippedClasses[0].count, 1, "unknown class aggregate occurrences")
  assertEqual(len(result.edicts), 5, "live edict count")
  assertEqual(len(result.diagnostics), 2, "field and class diagnostics")
  assertTrue(stext.contains(result.diagnostics[0], "mystery_field"), "unknown field diagnostic")
  assertTrue(stext.contains(result.diagnostics[1], "future_monster"), "unknown class diagnostic")

  world = result.edicts[0]
  assertEqual(world.number, 0, "world edict number")
  assertEqual(world.sourceIndex, 0, "world source index")
  assertEqual(world.edict.inUse, true, "world in use")
  assertEqual(world.edict.state.modelIndex, 1, "world model index")
  assertEqual(world.component.spawnKind, "worldspawn", "world spawn kind")
  assertEqual(world.component.message, "Outer Base\nEntry", "world newline message")
  assertEqual(world.component.spawnTemp.sky, "unit1_", "world sky")
  assertEqual(world.component.spawnTemp.skyAxis[2], 1, "world sky axis")
  assertEqual(world.component.sounds, 3, "world sounds integer")
  assertEqual(world.component.spawnTemp.gravity, "700", "world gravity text")

  start = result.edicts[1]
  assertEqual(start.component.spawnKind, "info-player-start", "player start spawn kind")
  assertEqual(start.component.origin[0], 1, "player start origin")
  assertEqual(start.component.angles[0], 0.0, "anglehack pitch")
  assertEqual(start.component.angles[1], 90, "anglehack yaw")
  assertEqual(start.edict.state.origin.z, 3, "engine edict origin transfer")

  door = result.edicts[2].component
  assertEqual(door.spawnKind, "mover-door", "door spawn kind")
  assertEqual(door.model, "*1", "door model")
  assertEqual(door.spawnFlags, 64, "door spawnflags")
  assertEqual(door.origin[2], 4.5, "door float vector")
  assertEqual(door.speed, 120, "door speed")
  assertEqual(door.accel, 120, "door accel default")
  assertEqual(door.decel, 120, "door decel default")
  assertEqual(door.wait, 2.5, "door wait")
  assertEqual(door.spawnTemp.lip, 4, "door lip")
  assertEqual(door.health, 25, "door health")
  assertEqual(door.damage, 7, "door damage")

  trigger = result.edicts[3].component
  assertEqual(trigger.spawnKind, "trigger-once", "trigger spawn kind")
  assertEqual(trigger.spawnFlags, 4, "legacy trigger flag correction")
  assertEqual(trigger.wait, -1.0, "trigger once wait")
  assertEqual(trigger.target, "door_a", "trigger target")
  assertEqual(trigger.delay, 0.25, "trigger delay")

  speaker = result.edicts[4].component
  assertEqual(speaker.spawnKind, "target-speaker", "speaker spawn kind")
  assertEqual(speaker.spawnTemp.noise, "world/alarm.wav", "speaker wav suffix")
  assertEqual(speaker.volume, 0.5, "speaker volume")
  assertEqual(speaker.attenuation, 0.0, "speaker global attenuation")

  logged = bspawn.spawnEntitiesLogged("base1", fixtureText(), "", recordDiagnostic)
  assertEqual(len(loggedDiagnostics), len(logged.diagnostics), "diagnostic logger dispatch")
  return true
end function

function testMalformedInput()
  terminatedSource = bytes("{ \"classname\" \"worldspawn\" }")
  terminated = bytes(len(terminatedSource) + 1)
  copyBytes(terminated, 0, terminatedSource, 0, len(terminatedSource))
  assertEqual(len(bparser.parseEntities(decode(terminated))), 1, "terminal NUL accepted")
  embedded = bytes(len(terminatedSource) + 2)
  copyBytes(embedded, 0, terminatedSource, 0, len(terminatedSource))
  embedded[len(terminatedSource)] = 0
  embedded[len(terminatedSource) + 1] = 120
  assertErrorContains(try(bparser.parseEntities(decode(embedded))), "embedded NUL", "embedded NUL rejection")
  assertErrorContains(try(bparser.parseEntities("{ \"classname\" \"worldspawn\"")), "closing brace", "missing close")
  assertErrorContains(try(bparser.parseEntities("{ \"classname\" }")), "without field data", "missing value")
  assertErrorContains(try(bparser.parseEntities("{ { } }")), "key must be text", "nested brace")
  assertErrorContains(try(bparser.parseEntities("{ \"classname\" \"worldspawn }")), "unterminated", "unterminated quote")
  assertErrorContains(try(bspawn.SpawnEntities("base1", "", "")), "no worldspawn", "empty entity text")
  assertErrorContains(try(bspawn.SpawnEntities("base1", "{ \"classname\" \"info_player_start\" }", "")), "first entity", "missing first worldspawn")
  assertErrorContains(try(bspawn.SpawnEntities("base1", "{ \"classname\" \"worldspawn\" } { \"classname\" \"worldspawn\" }", "")), "duplicate worldspawn", "duplicate worldspawn")
  assertErrorContains(try(bspawn.SpawnEntities("base1", "{ \"classname\" \"worldspawn\" } { \"classname\" \"func_door\" \"speed\" \"fast\" }", "")), "invalid numeric", "invalid number")
  assertErrorContains(try(bspawn.SpawnEntities("base1", "{ \"classname\" \"worldspawn\" } { \"classname\" \"info_player_start\" \"origin\" \"1 2\" }", "")), "exactly three", "short vector")
  return true
end function

function main(args)
  print "MiniQuake2 baseq2 entity tests starting: 3"
  testNewStringAndQuotedParsing()
  testSpawnEntities()
  testMalformedInput()
  print "MiniQuake2 baseq2 entity tests passed: 3"
  return 0
end function
