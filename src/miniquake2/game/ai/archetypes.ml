/* Data-driven stock baseq2 monster spawn defaults from m_*.c. */
package miniquake2.game.ai.archetypes

import miniquake2.game.ai.constants as gaiconstants
import miniquake2.game.ai.core as gaicore
import miniquake2.game.ai.monster as gaimonster
import miniquake2.game.ai.insane as gaiinsane
import miniquake2.game.ai.props as gaiprops
import miniquake2.game.ai.types as gaitypes
import miniquake2.game.constants as gconstants
import miniquake2.qcommon.text as qtext

function archetype(className, model, mins, maxs, health, gibHealth, mass, movement, hasAttack, hasMelee)
  return gaitypes.MonsterArchetype(className, model, mins, maxs, health, gibHealth, mass, movement, hasAttack, hasMelee, 1.0)
end function

function defaultRegistry()
  commonMins = [-16.0, -16.0, -24.0]
  commonMaxs = [16.0, 16.0, 32.0]
  entries = [
    archetype("monster_berserk", "models/monsters/berserk/tris.md2", commonMins, commonMaxs, 240, -60, 250, "walk", false, true),
    archetype("monster_gladiator", "models/monsters/gladiatr/tris.md2", [-32.0, -32.0, -24.0], [32.0, 32.0, 64.0], 400, -175, 400, "walk", true, true),
    archetype("monster_gunner", "models/monsters/gunner/tris.md2", commonMins, commonMaxs, 175, -70, 200, "walk", true, false),
    archetype("monster_infantry", "models/monsters/infantry/tris.md2", commonMins, commonMaxs, 100, -40, 200, "walk", true, false),
    archetype("monster_soldier_light", "models/monsters/soldier/tris.md2", commonMins, commonMaxs, 20, -30, 100, "walk", true, false),
    archetype("monster_soldier", "models/monsters/soldier/tris.md2", commonMins, commonMaxs, 30, -30, 100, "walk", true, false),
    archetype("monster_soldier_ss", "models/monsters/soldier/tris.md2", commonMins, commonMaxs, 40, -30, 100, "walk", true, false),
    archetype("monster_tank", "models/monsters/tank/tris.md2", [-32.0, -32.0, -16.0], [32.0, 32.0, 72.0], 750, -200, 500, "walk", true, false),
    archetype("monster_tank_commander", "models/monsters/tank/tris.md2", [-32.0, -32.0, -16.0], [32.0, 32.0, 72.0], 1000, -225, 500, "walk", true, false),
    archetype("monster_medic", "models/monsters/medic/tris.md2", [-24.0, -24.0, -24.0], [24.0, 24.0, 32.0], 300, -130, 400, "walk", true, false),
    archetype("monster_flipper", "models/monsters/flipper/tris.md2", [-16.0, -16.0, 0.0], [16.0, 16.0, 32.0], 50, -30, 100, "swim", false, true),
    archetype("monster_chick", "models/monsters/bitch/tris.md2", [-16.0, -16.0, 0.0], [16.0, 16.0, 56.0], 175, -70, 200, "walk", true, true),
    archetype("monster_parasite", "models/monsters/parasite/tris.md2", commonMins, [16.0, 16.0, 24.0], 175, -50, 250, "walk", true, false),
    archetype("monster_flyer", "models/monsters/flyer/tris.md2", commonMins, commonMaxs, 50, 0, 50, "fly", true, true),
    archetype("monster_brain", "models/monsters/brain/tris.md2", commonMins, commonMaxs, 300, -150, 400, "walk", false, true),
    archetype("monster_floater", "models/monsters/float/tris.md2", [-24.0, -24.0, -24.0], [24.0, 24.0, 32.0], 200, -80, 300, "fly", true, true),
    archetype("monster_hover", "models/monsters/hover/tris.md2", [-24.0, -24.0, -24.0], [24.0, 24.0, 32.0], 240, -100, 150, "fly", true, false),
    archetype("monster_mutant", "models/monsters/mutant/tris.md2", [-32.0, -32.0, -24.0], [32.0, 32.0, 48.0], 300, -120, 300, "walk", true, true),
    archetype("monster_supertank", "models/monsters/boss1/tris.md2", [-64.0, -64.0, 0.0], [64.0, 64.0, 112.0], 1500, -500, 800, "walk", true, false),
    archetype("monster_boss2", "models/monsters/boss2/tris.md2", [-56.0, -56.0, 0.0], [56.0, 56.0, 80.0], 2000, -200, 1000, "fly", true, false),
    archetype("monster_jorg", "models/monsters/boss3/rider/tris.md2", [-80.0, -80.0, 0.0], [80.0, 80.0, 140.0], 3000, -2000, 1000, "walk", true, false),
    archetype("monster_makron", "models/monsters/boss3/rider/tris.md2", [-30.0, -30.0, 0.0], [30.0, 30.0, 90.0], 3000, -2000, 500, "walk", true, false)
  ]
  campaignEntries = [
    archetype("misc_insane", "models/monsters/insane/tris.md2", commonMins, commonMaxs, 100, -50, 300, "walk", false, false),
    archetype("monster_boss3_stand", "models/monsters/boss3/rider/tris.md2", [-32.0, -32.0, 0.0], [32.0, 32.0, 90.0], 1, -1, 1, "walk", false, false),
    archetype("monster_commander_body", "models/monsters/commandr/tris.md2", [-32.0, -32.0, 0.0], [32.0, 32.0, 48.0], 1, -1, 1, "walk", false, false),
  ]
  return gaitypes.ArchetypeRegistry(entries, campaignEntries)
end function

function find(registry, className)
  if typeof(className) != "string" then return error(9683, "monster classname is not text") end if
  for each entry in registry.entries
    gaiArchetypeClassHolder = entry.className
    if typeof(gaiArchetypeClassHolder) != "string" then return error(9684, "monster registry classname is not text") end if
    if qtext.equalInsensitive(gaiArchetypeClassHolder, className) then return entry end if
  end for
  for each entry in registry.campaignEntries
    gaiCampaignArchetypeClassHolder = entry.className
    if typeof(gaiCampaignArchetypeClassHolder) != "string" then return error(9684, "campaign monster registry classname is not text") end if
    if qtext.equalInsensitive(gaiCampaignArchetypeClassHolder, className) then return entry end if
  end for
  return void
end function

function validate(registry)
  if len(registry.entries) != 22 then return error(9680, "stock monster registry must contain 22 active spawn classes") end if
  for each entry in registry.entries
    if entry.className == "" or entry.model == "" or entry.health <= 0 or entry.mass <= 0 then return error(9681, "invalid monster archetype") end if
    if entry.movement != "walk" and entry.movement != "fly" and entry.movement != "swim" then return error(9682, "invalid monster movement kind") end if
  end for
  if len(registry.campaignEntries) != 3 or registry.campaignEntries[0].className != "misc_insane" or
      registry.campaignEntries[1].className != "monster_boss3_stand" or
      registry.campaignEntries[2].className != "monster_commander_body" then
    return error(9685, "campaign AI registry must contain misc_insane and scripted boss props")
  end if
  return true
end function

function idleMove()
  frame = gaitypes.MonsterFrame(gaicore.ai_stand, 0.0, void)
  return gaitypes.MonsterMove("spawn-stand", 0, 0, [frame], void)
end function

function SpawnMonster(registry, className, number, context)
  definition = find(registry, className)
  if definition is void then return error(9683, "unknown stock monster classname " + className) end if
  actor = gaitypes.createActor(number, definition.className)
  actor.model = definition.model
  actor.mins = [definition.mins[0], definition.mins[1], definition.mins[2]]
  actor.maxs = [definition.maxs[0], definition.maxs[1], definition.maxs[2]]
  actor.health = definition.health
  actor.maxHealth = definition.health
  actor.gibHealth = definition.gibHealth
  actor.mass = definition.mass
  actor.moveType = gaiconstants.MOVETYPE_STEP
  actor.edict.solid = gconstants.SOLID_BBOX
  actor.info.scale = definition.scale
  actor.info.currentMove = idleMove()
  if gaiprops.isProp(actor) then return gaiprops.configure(actor, context) end if
  if actor.className == "misc_insane" then gaiinsane.configure(actor, context)
  else gaimonster.installDefaultCallbacks(actor, definition.hasAttack, definition.hasMelee) end if
  if definition.movement == "fly" then gaimonster.FlyMonsterStart(actor, context)
  else if definition.movement == "swim" then gaimonster.SwimMonsterStart(actor, context)
  else gaimonster.WalkMonsterStart(actor, context)
  end if
  // SP_monster_makron enters makron_move_sight immediately; the same callback
  // is reused whenever Makron later acquires a new visible enemy.
  if actor.className == "monster_makron" and typeof(actor.info.sight) == "function" then
    actor.info.sight(actor, void, context)
  end if
  return actor
end function
