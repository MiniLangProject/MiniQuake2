/*
Copyright (C) 1997-2001 Id Software, Inc.
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later

Function-valued first baseq2 spawn registry.  It intentionally implements only
the entity classes covered by this milestone.
*/
package miniquake2.game.base.spawn_registry

import miniquake2.game.base.types as btypes
import miniquake2.game.constants as gconstants
import miniquake2.game.gameplay.registry as gpregistry
import miniquake2.game.gameplay.item_rules as gprules
import miniquake2.game.ai.archetypes as gaiarchetypes
import std.string as bstring

const MOVETYPE_NONE = 0
const MOVETYPE_PUSH = 7

function SP_worldspawn(entity)
  entity.spawnKind = "worldspawn"
  entity.moveType = MOVETYPE_PUSH
  entity.solid = gconstants.SOLID_BSP
  return ""
end function

function SP_info_player_start(entity)
  entity.spawnKind = "info-player-start"
  entity.moveType = MOVETYPE_NONE
  entity.solid = gconstants.SOLID_NOT
  return ""
end function

function SP_info_player(entity)
  entity.spawnKind = "info-player:" + entity.className
  entity.moveType = MOVETYPE_NONE
  entity.solid = gconstants.SOLID_NOT
  return ""
end function

function SP_func_door(entity)
  entity.spawnKind = "mover-door"
  entity.moveType = MOVETYPE_PUSH
  entity.solid = gconstants.SOLID_BSP
  if entity.speed == 0.0 then entity.speed = 100.0 end if
  if entity.accel == 0.0 then entity.accel = entity.speed end if
  if entity.decel == 0.0 then entity.decel = entity.speed end if
  if entity.wait == 0.0 then entity.wait = 3.0 end if
  if entity.spawnTemp.lip == 0 then entity.spawnTemp.lip = 8 end if
  if entity.damage == 0 then entity.damage = 2 end if
  return ""
end function

function SP_trigger_once(entity)
  entity.spawnKind = "trigger-once"
  entity.moveType = MOVETYPE_NONE
  entity.solid = gconstants.SOLID_TRIGGER
  // Compatibility fix from g_trigger.c: early maps used bit 1 for TRIGGERED.
  if (entity.spawnFlags & 1) != 0 then
    entity.spawnFlags = (entity.spawnFlags & ~1) | 4
  end if
  entity.wait = -1.0
  return ""
end function

function SP_target_speaker(entity)
  entity.spawnKind = "target-speaker"
  entity.moveType = MOVETYPE_NONE
  entity.solid = gconstants.SOLID_NOT
  if entity.spawnTemp.noise == "" then
    entity.spawnKind = "target-speaker-unconfigured"
    return "target_speaker with no noise"
  end if
  // Preserve g_target.c's strstr test, including its case-sensitive behavior.
  if bstring.contains(entity.spawnTemp.noise, ".wav") != true then
    entity.spawnTemp.noise = entity.spawnTemp.noise + ".wav"
  end if
  if entity.volume == 0.0 then entity.volume = 1.0 end if
  if entity.attenuation == 0.0 then entity.attenuation = 1.0
  else if entity.attenuation == -1.0 then entity.attenuation = 0.0
  end if
  return ""
end function

function SP_gameplay_item(entity)
  item = gprules.findByClassName(gpregistry.stockRegistry(), entity.className)
  if item is void then return "unregistered gameplay item " + entity.className end if
  entity.spawnKind = "item:" + item.index
  entity.moveType = MOVETYPE_NONE
  entity.solid = gconstants.SOLID_TRIGGER
  return ""
end function

function SP_world_component(entity)
  entity.spawnKind = "world:" + entity.className
  entity.moveType = MOVETYPE_NONE
  entity.solid = gconstants.SOLID_NOT
  if bstring.startsWith(entity.className, "trigger_") then entity.solid = gconstants.SOLID_TRIGGER end if
  if bstring.startsWith(entity.className, "func_") then entity.moveType = MOVETYPE_PUSH; entity.solid = gconstants.SOLID_BSP end if
  return ""
end function

function SP_consumed(entity)
  entity.spawnKind = "consumed:" + entity.className
  entity.moveType = MOVETYPE_NONE
  entity.solid = gconstants.SOLID_NOT
  return ""
end function

function SP_light(entity)
  // g_misc.c frees un-targeted static lights; the BSP lightmaps already own
  // their illumination.  Targeted lights remain live for style switching.
  if entity.targetName == "" then return SP_consumed(entity) end if
  return SP_world_component(entity)
end function

function SP_brush_component(entity)
  entity.spawnKind = "world:" + entity.className
  entity.moveType = MOVETYPE_PUSH
  entity.solid = gconstants.SOLID_BSP
  return ""
end function

function SP_func_water(entity)
  SP_func_door(entity)
  entity.spawnKind = "world:func_water"
  entity.wait = -1.0
  return ""
end function

function SP_monster(entity)
  archetype = gaiarchetypes.find(gaiarchetypes.defaultRegistry(), entity.className)
  if archetype is void then return "unregistered monster " + entity.className end if
  entity.spawnKind = "monster:" + entity.className
  entity.moveType = 4
  entity.solid = gconstants.SOLID_BBOX
  if entity.health == 0 then entity.health = archetype.health end if
  if entity.mass == 0 then entity.mass = archetype.mass end if
  entity.model = archetype.model
  return ""
end function

function createRegistry()
  return btypes.SpawnRegistry([])
end function

function find(registry, className)
  for each entry in registry.entries
    if entry.className == className then return entry end if
  end for
  return void
end function

function register(registry, className, spawnFunction)
  if typeof(registry) != "struct" then return error(9050, "spawn registry required") end if
  if typeof(className) != "string" or len(bytes(className)) == 0 then return error(9051, "spawn classname required") end if
  if typeof(spawnFunction) != "function" then return error(9052, "spawn callback must be a function") end if
  if find(registry, className) is not void then return error(9053, "duplicate spawn classname " + className) end if
  registry.entries = registry.entries + [btypes.SpawnEntry(className, spawnFunction)]
  return registry
end function

function defaultRegistry()
  registry = createRegistry()
  register(registry, "worldspawn", SP_worldspawn)
  register(registry, "info_player_start", SP_info_player_start)
  register(registry, "info_player_deathmatch", SP_info_player)
  register(registry, "info_player_coop", SP_info_player)
  register(registry, "info_player_intermission", SP_info_player)
  register(registry, "func_door", SP_func_door)
  register(registry, "trigger_once", SP_trigger_once)
  register(registry, "target_speaker", SP_target_speaker)
  gameplayItems = gpregistry.stockRegistry()
  for each item in gameplayItems.items
    register(registry, item.className, SP_gameplay_item)
  end for
  worldClasses = [
    "trigger_multiple", "trigger_relay", "trigger_always",
    "func_button", "func_plat", "func_train", "func_timer", "func_conveyor", "func_explosive",
    "target_temp_entity", "target_help", "target_secret", "target_goal",
    "target_explosion", "target_changelevel", "target_splash", "target_spawner",
    "target_blaster", "target_crosslevel_trigger", "target_crosslevel_target",
    "func_areaportal", "path_corner", "point_combat", "info_notnull",
    "func_wall", "func_rotating", "misc_explobox",
    "misc_banner", "misc_deadsoldier", "misc_strogg_ship", "misc_gib_head",
  ]
  for each className in worldClasses
    register(registry, className, SP_world_component)
  end for
  register(registry, "light", SP_light)
  register(registry, "func_group", SP_consumed)
  register(registry, "info_null", SP_consumed)
  register(registry, "func_door_rotating", SP_brush_component)
  register(registry, "func_door_secret", SP_brush_component)
  register(registry, "func_object", SP_brush_component)
  register(registry, "func_water", SP_func_water)
  register(registry, "turret_base", SP_brush_component)
  register(registry, "turret_breach", SP_brush_component)
  campaignClasses = [
    "func_clock", "func_killbox",
    "light_mine2", "misc_blackhole", "misc_easterchick", "misc_easterchick2", "misc_eastertank",
    "misc_insane", "misc_satellite_dish", "misc_teleporter", "misc_teleporter_dest",
    "misc_viper", "misc_viper_bomb", "monster_boss3_stand", "monster_commander_body",
    "target_actor", "target_character", "target_earthquake", "target_laser", "target_lightramp", "target_string",
    "trigger_counter", "trigger_elevator", "trigger_gravity", "trigger_hurt", "trigger_key", "trigger_monsterjump", "trigger_push",
    "turret_driver",
  ]
  for each className in campaignClasses
    register(registry, className, SP_world_component)
  end for
  monsterRegistry = gaiarchetypes.defaultRegistry()
  for each archetype in monsterRegistry.entries
    register(registry, archetype.className, SP_monster)
  end for
  return registry
end function
