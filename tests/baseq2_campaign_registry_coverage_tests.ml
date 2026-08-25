/* Campaign-wide registry and live-edict compaction golden regression. */
import miniquake2.game.base.spawn_registry as campregistry
import miniquake2.game.base.spawn as campspawn
import miniquake2.game.base.entity_parser as campparser

function campAssert(value, message)
  if value != true then return error(9870, message) end if
  return true
end function

function campAssertEqual(actual, expected, message)
  if actual != expected then return error(9871, message + ": expected " + expected + ", got " + actual) end if
  return true
end function

registry = campregistry.defaultRegistry()
campAssertEqual(len(registry.entries), 143, "stock registry entry count")

previouslyMissing = [
  "func_clock", "func_conveyor", "func_door_rotating", "func_door_secret", "func_killbox", "func_object", "func_water", "info_null",
  "light_mine2", "misc_blackhole", "misc_easterchick", "misc_easterchick2", "misc_eastertank", "misc_insane",
  "misc_satellite_dish", "misc_teleporter", "misc_teleporter_dest", "misc_viper", "misc_viper_bomb",
  "monster_boss3_stand", "monster_commander_body", "target_actor", "target_character", "target_earthquake",
  "target_laser", "target_lightramp", "target_string", "trigger_counter", "trigger_elevator", "trigger_gravity", "trigger_hurt",
  "trigger_key", "trigger_monsterjump", "trigger_push", "turret_base", "turret_breach", "turret_driver",
]
for each className in previouslyMissing
  campAssert(campregistry.find(registry, className) is not void, "campaign classname registered: " + className)
end for

// More raw map entities than MAX_EDICTS are valid: static lights and compiler
// groups are freed while parsing/spawning and never occupy the live table.
entityText = "{\"classname\" \"worldspawn\"}"
index = 0
while index < 1100
  entityText = entityText + "{\"classname\" \"light\" \"origin\" \"0 0 0\"}"
  index = index + 1
end while
entityText = entityText + "{\"classname\" \"func_group\"}{\"classname\" \"func_door\" \"model\" \"*1\"}"
spawned = campspawn.SpawnEntities("campaign_large", entityText, "")
campAssertEqual(spawned.sourceEntityCount, 1103, "raw source entity count")
campAssertEqual(len(spawned.edicts), 2, "compacted live entity count")
campAssertEqual(spawned.skippedEntityCount, 0, "registered consumed entities are not skipped")
campAssertEqual(campparser.parseNumber(".1.25", "delay"), 0.1, "C atof prefix compatibility")

print "baseq2_campaign_registry_coverage_tests: PASS"
