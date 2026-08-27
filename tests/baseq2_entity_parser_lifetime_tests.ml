/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later

Regression for entity-token and pair lifetime under repeated BSP ingestion.
The optional retail path mirrors the first eight campaign transitions which
originally exposed void key/value fields after bunk1.
*/
import miniquake2.qcommon.filesystem as lifetimefilesystem
import miniquake2.format.bsp as lifetimebsp
import miniquake2.game.base.spawn as lifetimespawn

// Assert the parser lifetime test condition.
function parserLifetimeAssert(value, message)
  if not value then return error(9894, message) end if
  return true
end function

// Return the parser lifetime synthetic text value.
function parserLifetimeSyntheticText()
  text = "{ \"classname\" \"worldspawn\" \"message\" \"lifetime regression\" }\n"
  index = 0
  while index < 320
    text = text + "{ \"classname\" \"info_player_start\" \"origin\" \"1 2 3\" " +
      "\"angle\" \"90\" \"targetname\" \"gc_spawn_" + index + "\" " +
      "\"wait\" \"0.25\" \"count\" \"7\" \"health\" \"100\" " +
      "\"dmg\" \"4\" \"mass\" \"200\" \"speed\" \"120\" " +
      "\"style\" \"1\" }\n"
    index = index + 1
  end while
  return text
end function

// Return the parser lifetime synthetic value.
function parserLifetimeSynthetic()
  entityText = parserLifetimeSyntheticText()
  iteration = 0
  while iteration < 12
    result = lifetimespawn.SpawnEntities("gc_lifetime", entityText, "")
    parserLifetimeAssert(result.sourceEntityCount == 321,
      "synthetic source entity count changed")
    parserLifetimeAssert(len(result.edicts) == 321,
      "synthetic live entity count changed")
    last = result.edicts[len(result.edicts) - 1].component
    parserLifetimeAssert(last.className == "info_player_start",
      "synthetic classname lifetime changed")
    parserLifetimeAssert(last.targetName == "gc_spawn_319",
      "synthetic value lifetime changed")
    parserLifetimeAssert(last.health == 100 and last.speed == 120,
      "synthetic grown-pair fields changed")
    iteration = iteration + 1
  end while
  return true
end function

// Return the parser lifetime campaign maps value.
function parserLifetimeCampaignMaps()
  return [
    "base1", "base2", "base3", "biggun", "boss1", "boss2", "bunk1",
    "city1", "city2", "city3", "command", "cool1", "fact1", "fact2",
    "fact3", "hangar1", "hangar2", "jail1", "jail2", "jail3", "jail4",
    "jail5", "lab", "mine1", "mine2", "mine3", "mine4", "mintro",
    "power1", "power2", "security", "space", "strike", "train", "ware1",
    "ware2", "waste1", "waste2", "waste3",
  ]
end function

// Return the parser lifetime full retail maps value.
function parserLifetimeFullRetailMaps()
  return [
    "base1", "base2", "base3", "biggun", "boss1", "boss2", "bunk1", "city1", "city2", "city3",
    "command", "cool1", "fact1", "fact2", "fact3", "hangar1", "hangar2", "jail1", "jail2", "jail3",
    "jail4", "jail5", "lab", "mine1", "mine2", "mine3", "mine4", "mintro", "power1", "power2",
    "q2dm1", "q2dm2", "q2dm3", "q2dm4", "q2dm5", "q2dm6", "q2dm7", "q2dm8", "security", "space",
    "strike", "train", "ware1", "ware2", "waste1", "waste2", "waste3",
  ]
end function

// Return the parser lifetime retail sequence value.
function parserLifetimeRetailSequence(root, maps, expectedRaw)
  totalRaw = 0
  index = 0
  while index < len(maps)
    // Re-open the PAK set just like repeated retail map-session setup.  The
    // previous filesystem becomes collectible at the next iteration.
    filesystem = lifetimefilesystem.initialize(root, "")
    path = "maps/" + maps[index] + ".bsp"
    map = lifetimebsp.parse(lifetimefilesystem.readFile(filesystem, path), path)
    result = lifetimespawn.SpawnEntities(maps[index], map.entityText, "")
    parserLifetimeAssert(result.sourceEntityCount > 0,
      maps[index] + ": no retail source entities")
    parserLifetimeAssert(result.skippedEntityCount == 0,
      maps[index] + ": skipped retail entities")
    totalRaw = totalRaw + result.sourceEntityCount
    index = index + 1
  end while
  parserLifetimeAssert(totalRaw == expectedRaw, "retail sequence aggregate changed")
  return totalRaw
end function

// Return the parser lifetime retail value.
function parserLifetimeRetail(root)
  campaignRaw = parserLifetimeRetailSequence(root, parserLifetimeCampaignMaps(), 34298)
  fullRaw = parserLifetimeRetailSequence(root, parserLifetimeFullRetailMaps(), 36404)
  parserLifetimeAssert(campaignRaw + 2106 == fullRaw,
    "deathmatch retail aggregate changed")
  return true
end function

// Run this source file's command-line entry point.
function main(args)
  parserLifetimeSynthetic()
  if len(args) == 1 then
    parserLifetimeRetail(args[0])
    print "baseq2_entity_parser_lifetime_tests: PASS (synthetic + retail 39/47-map)"
  else
    if len(args) != 0 then return error(9895, "expected optional Quake II install root") end if
    print "baseq2_entity_parser_lifetime_tests: PASS (synthetic)"
  end if
  return 0
end function
