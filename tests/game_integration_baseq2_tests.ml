/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later

Asset-free integration contract for BaseQ2 entity dispatch and frame handoff.
*/
import miniquake2.game.base.spawn as itbspawn
import miniquake2.game.integration.baseq2 as itbaseq2
import miniquake2.game.types as itgtypes
import miniquake2.qcommon.constants as itqconstants

function assertEqual(actual, expected, name)
  if actual != expected then return error(9950, name + ": values differ") end if
  return true
end function

function assertTrue(value, name)
  if value != true then return error(9951, name + ": expected true") end if
  return true
end function

function fixtureText()
  return "{ \"classname\" \"worldspawn\" \"message\" \"Integration Base\" }\n" +
    "{ \"classname\" \"trigger_multiple\" \"target\" \"door_a\" \"wait\" \"0.5\" }\n" +
    "{ \"classname\" \"func_button\" \"targetname\" \"door_a\" \"speed\" \"40\" }\n" +
    "{ \"classname\" \"weapon_railgun\" \"origin\" \"10 20 30\" }\n" +
    "{ \"classname\" \"monster_soldier\" \"origin\" \"64 32 16\" \"angle\" \"90\" }"
end function

function testDispatch()
  spawned = itbspawn.SpawnEntities("base1", fixtureText(), "")
  runtime = itbaseq2.create(spawned)
  assertEqual(len(runtime.world.entities), 3, "world entity count")
  assertEqual(len(runtime.items), 1, "item entity count")
  assertEqual(len(runtime.monsters), 1, "monster entity count")
  assertEqual(runtime.world.entities[0].className, "worldspawn", "world class")
  assertEqual(typeof(runtime.world.entities[1].touch), "function", "trigger callback")
  assertEqual(typeof(runtime.world.entities[2].use), "function", "button callback")
  assertEqual(runtime.items[0].item.className, "weapon_railgun", "item definition")
  assertEqual(runtime.items[0].edict.state.origin.z, 30.0, "item origin")
  assertEqual(runtime.monsters[0].health, 30, "soldier health")
  assertEqual(runtime.monsters[0].edict.state.origin.x, 64.0, "monster origin")
  return true
end function

function testFrameAndEdictHandoff()
  runtime = itbaseq2.create(itbspawn.SpawnEntities("base1", fixtureText(), ""))
  exportTable = itgtypes.GameExport(
    3,
    void, void, void, void, void, void, void,
    void, void, void, void, void, void, void, void,
    [], 0, 0, 0
  )
  exportTable.edicts = array(itqconstants.MAX_EDICTS)
  index = 0
  while index < itqconstants.MAX_EDICTS
    exportTable.edicts[index] = itgtypes.zeroEdict(index)
    index = index + 1
  end while
  exportTable.numEdicts = 5
  exportTable.maxEdicts = itqconstants.MAX_EDICTS
  itbaseq2.syncGameEdicts(runtime, exportTable)
  assertTrue(exportTable.edicts[0].inUse, "world edict synchronized")
  assertEqual(exportTable.edicts[3].state.origin.z, 30.0, "item edict synchronized")
  assertEqual(exportTable.edicts[4].state.origin.x, 64.0, "monster edict synchronized")
  itbaseq2.runFrame(runtime)
  assertEqual(runtime.world.time, 0.1, "world frame time")
  assertEqual(runtime.aiContext.frameNumber, 1, "AI frame count")
  assertEqual(runtime.monsters[0].thinkKind, "monster-think", "monster frame dispatch")
  return true
end function

function main(args)
  print "MiniQuake2 BaseQ2 integration tests starting: 2"
  testDispatch()
  testFrameAndEdictHandoff()
  print "MiniQuake2 BaseQ2 integration tests passed: 2"
  return 0
end function
