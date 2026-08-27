/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Original g_spawn.c skill/deathmatch entity inhibition coverage. */
import miniquake2.game.base.spawn as sitspawn

// Assert the sit test condition.
function sitAssert(value, name)
  if not value then return error(8470, name) end if
  return true
end function

// Return the sit entity text value.
function sitEntityText()
  return "{ \"classname\" \"worldspawn\" }\n" +
    "{ \"classname\" \"info_player_start\" }\n" +
    "{ \"classname\" \"trigger_relay\" \"targetname\" \"not_easy\" \"spawnflags\" \"256\" }\n" +
    "{ \"classname\" \"trigger_relay\" \"targetname\" \"not_medium\" \"spawnflags\" \"512\" }\n" +
    "{ \"classname\" \"trigger_relay\" \"targetname\" \"not_hard\" \"spawnflags\" \"1024\" }\n" +
    "{ \"classname\" \"trigger_relay\" \"targetname\" \"not_dm\" \"spawnflags\" \"2048\" }\n" +
    "{ \"classname\" \"trigger_relay\" \"targetname\" \"not_coop\" \"spawnflags\" \"4096\" }\n" +
    "{ \"classname\" \"trigger_relay\" \"targetname\" \"all_modes\" \"spawnflags\" \"7936\" }\n"
end function

// Find sit.
function sitFind(result, targetName)
  for each edict in result.edicts
    if edict.component.targetName == targetName then return edict.component end if
  end for
  return void
end function

easy = sitspawn.SpawnEntitiesForMode("audit", sitEntityText(), "", 0, false)
sitAssert(easy.inhibitedEntityCount == 2 and len(easy.edicts) == 6,
  "easy skill inhibition count")
sitAssert(sitFind(easy, "not_easy") is void and
  sitFind(easy, "all_modes") is void, "easy exclusions")
sitAssert(sitFind(easy, "not_medium").spawnFlags == 0 and
  sitFind(easy, "not_coop").spawnFlags == 0,
  "surviving editor mode flags were not cleared")

medium = sitspawn.SpawnEntitiesForMode("audit", sitEntityText(), "", 1, false)
sitAssert(medium.inhibitedEntityCount == 2 and
  sitFind(medium, "not_medium") is void and
  sitFind(medium, "all_modes") is void, "medium skill exclusions")

hard = sitspawn.SpawnEntitiesForMode("audit", sitEntityText(), "", 2, false)
nightmare = sitspawn.SpawnEntitiesForMode("audit", sitEntityText(), "", 3, false)
sitAssert(hard.inhibitedEntityCount == 2 and
  sitFind(hard, "not_hard") is void and sitFind(hard, "all_modes") is void,
  "hard skill exclusions")
sitAssert(nightmare.inhibitedEntityCount == hard.inhibitedEntityCount and
  sitFind(nightmare, "not_hard") is void,
  "nightmare must share hard exclusions")

deathmatch = sitspawn.SpawnEntitiesForMode("audit", sitEntityText(), "", 0, true)
sitAssert(deathmatch.inhibitedEntityCount == 2 and
  sitFind(deathmatch, "not_dm") is void and
  sitFind(deathmatch, "all_modes") is void,
  "deathmatch exclusions")
sitAssert(sitFind(deathmatch, "not_easy") is not void and
  sitFind(deathmatch, "not_easy").spawnFlags == 0,
  "deathmatch incorrectly applied skill exclusion")

commandText = "{ \"classname\" \"worldspawn\" }\n" +
  "{ \"classname\" \"info_player_start\" }\n" +
  "{ \"classname\" \"trigger_once\" \"model\" \"*27\" \"spawnflags\" \"1024\" }\n"
command = sitspawn.SpawnEntitiesForMode("command", commandText, "", 2, false)
sitAssert(command.inhibitedEntityCount == 0 and len(command.edicts) == 3 and
  command.edicts[2].component.spawnFlags == 0,
  "command/*27 hard-skill compatibility hack")

raw = sitspawn.SpawnEntities("audit", sitEntityText(), "")
sitAssert(raw.inhibitedEntityCount == 0 and len(raw.edicts) == 8,
  "unfiltered parser API changed semantics")

print "baseq2_spawn_inhibition_tests: PASS"
