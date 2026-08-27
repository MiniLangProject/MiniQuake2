/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Exact registration inventory for Quake II 3.19 game/g_spawn.c. */
import miniquake2.game.base.spawn_registry as originalspawnregistry
import miniquake2.game.gameplay.registry as originalitemregistry

// Assert the original spawn test condition.
function originalSpawnAssert(value, message)
  if value != true then return error(9796, message) end if
  return true
end function

// Order and spelling follow spawns[] at bundled reference commit
// 372afde46e7defc9dd2d719a1732b8ace1fa096e.
originalSpawnClasses = [
  "item_health", "item_health_small", "item_health_large", "item_health_mega", "info_player_start",
  "info_player_deathmatch", "info_player_coop", "info_player_intermission", "func_plat", "func_button",
  "func_door", "func_door_secret", "func_door_rotating", "func_rotating", "func_train",
  "func_water", "func_conveyor", "func_areaportal", "func_clock", "func_wall",
  "func_object", "func_timer", "func_explosive", "func_killbox", "trigger_always",
  "trigger_once", "trigger_multiple", "trigger_relay", "trigger_push", "trigger_hurt",
  "trigger_key", "trigger_counter", "trigger_elevator", "trigger_gravity", "trigger_monsterjump",
  "target_temp_entity", "target_speaker", "target_explosion", "target_changelevel", "target_secret",
  "target_goal", "target_splash", "target_spawner", "target_blaster", "target_crosslevel_trigger",
  "target_crosslevel_target", "target_laser", "target_help", "target_actor", "target_lightramp",
  "target_earthquake", "target_character", "target_string", "worldspawn", "viewthing",
  "light", "light_mine1", "light_mine2", "info_null", "func_group",
  "info_notnull", "path_corner", "point_combat", "misc_explobox", "misc_banner",
  "misc_satellite_dish", "misc_actor", "misc_gib_arm", "misc_gib_leg", "misc_gib_head",
  "misc_insane", "misc_deadsoldier", "misc_viper", "misc_viper_bomb", "misc_bigviper",
  "misc_strogg_ship", "misc_teleporter", "misc_teleporter_dest", "misc_blackhole", "misc_eastertank",
  "misc_easterchick", "misc_easterchick2", "monster_berserk", "monster_gladiator", "monster_gunner",
  "monster_infantry", "monster_soldier_light", "monster_soldier", "monster_soldier_ss", "monster_tank",
  "monster_tank_commander", "monster_medic", "monster_flipper", "monster_chick", "monster_parasite",
  "monster_flyer", "monster_brain", "monster_floater", "monster_hover", "monster_mutant",
  "monster_supertank", "monster_boss2", "monster_boss3_stand", "monster_jorg", "monster_commander_body",
  "turret_breach", "turret_base", "turret_driver",
]

originalSpawnAssert(len(originalSpawnClasses) == 108,
  "bundled g_spawn.c class count changed")
registry = originalspawnregistry.defaultRegistry()
for each className in originalSpawnClasses
  originalSpawnAssert(originalspawnregistry.find(registry, className) is not void,
    "unregistered original spawn class " + className)
end for

// ED_CallSpawn checks itemlist before spawns[]. Cover that second source of
// stock classnames instead of mistaking the explicit table for the whole API.
items = originalitemregistry.stockRegistry()
originalSpawnAssert(len(items.items) == 44, "stock itemlist count changed")
for each item in items.items
  originalSpawnAssert(originalspawnregistry.find(registry,
    item.className) is not void, "unregistered stock item " + item.className)
end for

// Makron is created internally by Jorg rather than appearing in spawns[].
originalSpawnAssert(originalspawnregistry.find(registry,
  "monster_makron") is not void, "internal Makron spawn is unregistered")
originalSpawnAssert(len(registry.entries) == 149,
  "default registry contains an unexpected omission or extra class")

print "baseq2_original_spawn_table_tests: PASS"
