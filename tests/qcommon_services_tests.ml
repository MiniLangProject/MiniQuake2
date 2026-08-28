/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Command, cvar and PAK search-service contracts. */
import miniquake2.qcommon.constants as c
import miniquake2.qcommon.byteio as bio
import miniquake2.qcommon.cvar as cvar
import miniquake2.qcommon.cmd as cmd
import miniquake2.qcommon.filesystem as filesystem
import miniquake2.qcommon.info as info

// Store recorder data.
struct Recorder
  calls
end struct

recorder = Recorder([])

// Record state.
function record(arguments)
  recorder.calls = recorder.calls + [arguments]
  return true
end function

// Assert the equal test condition.
function assertEqual(actual, expected, name)
  if actual != expected then return error(9930, name + ": expected " + expected + ", got " + actual) end if
  return true
end function

// Assert the true test condition.
function assertTrue(value, name)
  if value != true then return error(9931, name + ": expected true") end if
  return true
end function

// Verify cvars.
function testCvars()
  registry = cvar.createRegistry()
  cvar.get(registry, "name", "unnamed", c.CVAR_USERINFO)
  cvar.set(registry, "name", "Ranger")
  assertEqual(cvar.variableString(registry, "name"), "Ranger", "cvar set")
  assertEqual(cvar.bitInfo(registry, c.CVAR_USERINFO), "\\name\\Ranger", "userinfo")
  cvar.get(registry, "game", "baseq2", c.CVAR_LATCH)
  cvar.set(registry, "game", "ctf")
  assertEqual(cvar.variableString(registry, "game"), "baseq2", "latched old value")
  assertEqual(cvar.applyLatched(registry), 1, "latched apply count")
  assertEqual(cvar.variableString(registry, "game"), "ctf", "latched new value")
  assertTrue(try(cvar.set(registry, "name", "bad\\value")) is error, "userinfo validation")
  return true
end function

// Verify commands.
function testCommands()
  registry = cvar.createRegistry()
  system = cmd.create(registry)
  cmd.addCommand(system, "record", record)
  cmd.addText(system, "record one; record \"two words\"\nwait\nrecord three\n")
  assertEqual(cmd.executeBuffer(system), 3, "first command batch")
  assertEqual(len(recorder.calls), 2, "wait stops buffer")
  assertEqual(recorder.calls[1][1], "two words", "quoted token")
  assertEqual(cmd.executeBuffer(system), 1, "second command batch")
  assertEqual(recorder.calls[2][1], "three", "post-wait command")
  cmd.addAlias(system, "again", "record alias")
  cmd.executeString(system, "again")
  cmd.executeBuffer(system)
  assertEqual(recorder.calls[3][1], "alias", "alias expansion")
  return true
end function

// Verify pack.
function testPack()
  data = bytes(12 + 3 + 64)
  bio.putU32(data, 0, 0x4b434150)
  bio.putU32(data, 4, 15)
  bio.putU32(data, 8, 64)
  data[12] = 81; data[13] = 50; data[14] = 33
  name = bytes("maps/test.bsp")
  copyBytes(data, 15, name, 0, len(name))
  bio.putU32(data, 15 + 56, 12)
  bio.putU32(data, 15 + 60, 3)
  pack = filesystem.parsePack(data, "fixture.pak")
  assertEqual(len(pack.lookup), 8192, "PACK hashed lookup capacity")
  entry = filesystem.findPackFile(pack, "MAPS\\TEST.BSP")
  assertEqual(decode(slice(pack.data, entry.offset, entry.length)), "Q2!", "PACK lookup")
  assertTrue(filesystem.findPackFile(pack, "maps/missing.bsp") is void,
    "PACK hashed lookup miss")
  assertTrue(filesystem.virtualNameValid("../secret") == false, "traversal rejection")
  assertTrue(filesystem.virtualNameValid("maps/../../secret") == false, "nested traversal rejection")
  assertEqual(filesystem.canonicalVirtualName("models/monsters/tank/../ctank/skin.pcx"), "models/monsters/ctank/skin.pcx", "retail PACK parent segment")

  retailData = bytes(12 + 3 + 64)
  bio.putU32(retailData, 0, 0x4b434150)
  bio.putU32(retailData, 4, 15)
  bio.putU32(retailData, 8, 64)
  retailData[12] = 81; retailData[13] = 50; retailData[14] = 33
  retailName = bytes("models/monsters/tank/../ctank/skin.pcx")
  copyBytes(retailData, 15, retailName, 0, len(retailName))
  bio.putU32(retailData, 15 + 56, 12)
  bio.putU32(retailData, 15 + 60, 3)
  retailPack = filesystem.parsePack(retailData, "retail-fixture.pak")
  retailEntry = filesystem.findPackFile(retailPack, "models/monsters/ctank/skin.pcx")
  assertEqual(decode(slice(retailPack.data, retailEntry.offset, retailEntry.length)), "Q2!", "canonical retail PACK lookup")
  return true
end function

// Verify info strings.
function testInfoStrings()
  value = info.setValueForKey("", "name", "Ranger")
  value = info.setValueForKey(value, "rate", "25000")
  assertEqual(info.valueForKey(value, "name"), "Ranger", "userinfo name")
  assertEqual(info.valueForKey(value, "rate"), "25000", "userinfo rate")
  value = info.setValueForKey(value, "name", "Bitterman")
  assertEqual(info.valueForKey(value, "name"), "Bitterman", "userinfo replace")
  assertTrue(info.validate("\\name\\bad;value") == false, "userinfo illegal character")
  assertTrue(try(info.setValueForKey(value, "bad\\key", "x")) is error, "userinfo invalid key rejection")
  return true
end function

testCvars()
testCommands()
testPack()
testInfoStrings()
print "qcommon_services_tests: PASS"
