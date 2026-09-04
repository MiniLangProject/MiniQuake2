//! Provides miniquake2 game ai death effects facilities for this project.

/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Stock Quake II corpse bounds, gib inventories and boss explosions. */
package miniquake2.game.ai.death_effects

import miniquake2.qcommon.types as gaideathqtypes

/// Defines the gib organic constant used by the miniquake2 game ai death effects module.
const GIB_ORGANIC = 0
/// Defines the gib metallic constant used by the miniquake2 game ai death effects module.
const GIB_METALLIC = 1
/// Defines the te explosion1 constant used by the miniquake2 game ai death effects module.
const TE_EXPLOSION1 = 5

/// Store corpse bounds data.
struct CorpseBounds
  /// Stores the minimum x value associated with corpse bounds.
  minimumX
  /// Stores the minimum y value associated with corpse bounds.
  minimumY
  /// Stores the minimum z value associated with corpse bounds.
  minimumZ
  /// Stores the maximum x value associated with corpse bounds.
  maximumX
  /// Stores the maximum y value associated with corpse bounds.
  maximumY
  /// Stores the maximum z value associated with corpse bounds.
  maximumZ
end struct

/// Store gib spec data.
struct GibSpec
  /// Stores the model name value associated with gib spec.
  modelName
  /// Stores the count value associated with gib spec.
  count
  /// Stores the gib type value associated with gib spec.
  gibType
  /// Stores the head value associated with gib spec.
  head
end struct

/// Store monster death effect data.
struct MonsterDeathEffect
  /// Stores the kind value associated with monster death effect.
  kind
  /// Stores the model name value associated with monster death effect.
  modelName
  /// Stores the origin value associated with monster death effect.
  origin
  /// Stores the damage value associated with monster death effect.
  damage
  /// Stores the gib type value associated with monster death effect.
  gibType
  /// Stores the head value associated with monster death effect.
  head
  /// Stores the sequence value associated with monster death effect.
  sequence
  /// Stores the effect type value associated with monster death effect.
  effectType
end struct

/// Return the corpse bounds.
/// @param className className value consumed by this operation.
function corpseBounds(className)
  if className == "monster_chick" then return CorpseBounds(-16.0, -16.0, 0.0, 16.0, 16.0, 16.0) end if
  if className == "monster_tank" or className == "monster_tank_commander" then
    return CorpseBounds(-16.0, -16.0, -16.0, 16.0, 16.0, 0.0)
  end if
  if className == "monster_supertank" or className == "monster_makron" then
    return CorpseBounds(-60.0, -60.0, 0.0, 60.0, 60.0, 72.0)
  end if
  if className == "monster_boss2" then return CorpseBounds(-56.0, -56.0, 0.0, 56.0, 56.0, 80.0) end if
  if className == "monster_jorg" then return CorpseBounds(-60.0, -60.0, 0.0, 60.0, 60.0, 72.0) end if
  if className == "monster_berserk" or className == "monster_gladiator" or
      className == "monster_gunner" or className == "monster_infantry" or
      className == "monster_soldier_light" or className == "monster_soldier" or
      className == "monster_soldier_ss" or className == "monster_medic" or
      className == "monster_flipper" or className == "monster_parasite" or
      className == "monster_brain" or className == "monster_hover" or
      className == "monster_mutant" then
    return CorpseBounds(-16.0, -16.0, -24.0, 16.0, 16.0, -8.0)
  end if
  return void
end function

/// Return the organic gibs value.
function organicGibs()
  return [
    GibSpec("models/objects/gibs/bone/tris.md2", 2, GIB_ORGANIC, false),
    GibSpec("models/objects/gibs/sm_meat/tris.md2", 4, GIB_ORGANIC, false),
    GibSpec("models/objects/gibs/head2/tris.md2", 1, GIB_ORGANIC, true),
  ]
end function

/// Return the gib plan value.
/// @param className className value consumed by this operation.
function gibPlan(className)
  if className == "monster_flyer" or className == "monster_floater" or
      className == "monster_supertank" or className == "monster_jorg" then return [] end if
  if className == "monster_soldier_light" or className == "monster_soldier" or className == "monster_soldier_ss" then
    return [
      GibSpec("models/objects/gibs/sm_meat/tris.md2", 3, GIB_ORGANIC, false),
      GibSpec("models/objects/gibs/chest/tris.md2", 1, GIB_ORGANIC, false),
      GibSpec("models/objects/gibs/head2/tris.md2", 1, GIB_ORGANIC, true),
    ]
  end if
  if className == "monster_flipper" or className == "monster_hover" then
    return [
      GibSpec("models/objects/gibs/bone/tris.md2", 2, GIB_ORGANIC, false),
      GibSpec("models/objects/gibs/sm_meat/tris.md2", 2, GIB_ORGANIC, false),
      GibSpec("models/objects/gibs/sm_meat/tris.md2", 1, GIB_ORGANIC, true),
    ]
  end if
  if className == "monster_tank" or className == "monster_tank_commander" then
    return [
      GibSpec("models/objects/gibs/sm_meat/tris.md2", 1, GIB_ORGANIC, false),
      GibSpec("models/objects/gibs/sm_metal/tris.md2", 4, GIB_METALLIC, false),
      GibSpec("models/objects/gibs/chest/tris.md2", 1, GIB_ORGANIC, false),
      GibSpec("models/objects/gibs/gear/tris.md2", 1, GIB_METALLIC, true),
    ]
  end if
  if className == "monster_makron" then
    return [
      GibSpec("models/objects/gibs/sm_meat/tris.md2", 1, GIB_ORGANIC, false),
      GibSpec("models/objects/gibs/sm_metal/tris.md2", 4, GIB_METALLIC, false),
      GibSpec("models/objects/gibs/gear/tris.md2", 1, GIB_METALLIC, true),
    ]
  end if
  return organicGibs()
end function

/// Return the supertank final gibs value.
function supertankFinalGibs()
  return [
    GibSpec("models/objects/gibs/sm_meat/tris.md2", 4, GIB_ORGANIC, false),
    GibSpec("models/objects/gibs/sm_metal/tris.md2", 8, GIB_METALLIC, false),
    GibSpec("models/objects/gibs/chest/tris.md2", 1, GIB_ORGANIC, false),
    GibSpec("models/objects/gibs/gear/tris.md2", 1, GIB_METALLIC, true),
  ]
end function

/// Return the effect value.
/// @param kind kind value consumed by this operation.
/// @param modelName modelName value consumed by this operation.
/// @param origin origin value consumed by this operation.
/// @param damage damage value consumed by this operation.
/// @param gibType gibType value consumed by this operation.
/// @param head head value consumed by this operation.
/// @param sequence sequence value consumed by this operation.
/// @param effectType effectType value consumed by this operation.
function effect(kind, modelName, origin, damage, gibType, head, sequence, effectType)
  if typeof(origin) != "struct" then return error(9680, "monster death effect requires an origin") end if
  gaideathOriginHolder = gaideathqtypes.Vec3(origin.x, origin.y, origin.z)
  return MonsterDeathEffect(kind, modelName, gaideathOriginHolder, damage, gibType, head, sequence, effectType)
end function

/// Performs the emit operation for the miniquake2 game ai death effects module.
/// @param context Context that carries state for the operation.
/// @param actor actor value consumed by this operation.
/// @param event event value consumed by this operation.
function emit(context, actor, event)
  if typeof(context.deathEffect) != "function" then return true end if
  return context.deathEffect(actor, event)
end function

/// Apply corpse.
/// @param actor actor value consumed by this operation.
/// @param context Context that carries state for the operation.
function applyCorpse(actor, context)
  bounds = corpseBounds(actor.className)
  if bounds is void then return false end if
  actor.mins = [bounds.minimumX, bounds.minimumY, bounds.minimumZ]
  actor.maxs = [bounds.maximumX, bounds.maximumY, bounds.maximumZ]
  gaideathMinimumHolder = gaideathqtypes.Vec3(bounds.minimumX, bounds.minimumY, bounds.minimumZ)
  gaideathMaximumHolder = gaideathqtypes.Vec3(bounds.maximumX, bounds.maximumY, bounds.maximumZ)
  actor.edict.mins = gaideathMinimumHolder
  actor.edict.maxs = gaideathMaximumHolder
  return emit(context, actor, effect("corpse", "", actor.edict.state.origin, 0, GIB_ORGANIC, false, 0, 0))
end function

/// Emit gib specs.
/// @param actor actor value consumed by this operation.
/// @param specs specs value consumed by this operation.
/// @param damage damage value consumed by this operation.
/// @param context Context that carries state for the operation.
function emitGibSpecs(actor, specs, damage, context)
  sequence = 0
  for each spec in specs
    part = 0
    while part < spec.count
      emitted = emit(context, actor, effect("gib", spec.modelName, actor.edict.state.origin,
        damage, spec.gibType, spec.head, sequence, 0))
      if emitted is error then return emitted end if
      sequence = sequence + 1
      part = part + 1
    end while
  end for
  return sequence
end function

/// Emit monster gibs.
/// @param actor actor value consumed by this operation.
/// @param damage damage value consumed by this operation.
/// @param context Context that carries state for the operation.
function emitMonsterGibs(actor, damage, context)
  return emitGibSpecs(actor, gibPlan(actor.className), damage, context)
end function

/// Emit supertank final gibs.
/// @param actor actor value consumed by this operation.
/// @param context Context that carries state for the operation.
function emitSupertankFinalGibs(actor, context)
  return emitGibSpecs(actor, supertankFinalGibs(), 500, context)
end function

/// Return the supertank explosion origin.
/// @param actor actor value consumed by this operation.
/// @param stage stage value consumed by this operation.
function supertankExplosionOrigin(actor, stage)
  if stage < 0 or stage > 7 then return error(9681, "supertank explosion stage outside stock range") end if
  xOffset = -24.0
  yOffset = -24.0
  if stage == 1 then xOffset = 24.0; yOffset = 24.0
  else if stage == 2 then xOffset = 24.0; yOffset = -24.0
  else if stage == 3 then xOffset = -24.0; yOffset = 24.0
  else if stage == 4 then xOffset = -48.0; yOffset = -48.0
  else if stage == 5 then xOffset = 48.0; yOffset = 48.0
  else if stage == 6 then xOffset = -48.0; yOffset = 48.0
  else if stage == 7 then xOffset = 48.0; yOffset = -48.0
  end if
  source = actor.edict.state.origin
  zOffset = 24.0 + ((actor.edict.state.number * 13 + stage * 7 + 5) % 16)
  return gaideathqtypes.Vec3(source.x + xOffset, source.y + yOffset, source.z + zOffset)
end function

/// Emit explosion.
/// @param actor actor value consumed by this operation.
/// @param origin origin value consumed by this operation.
/// @param sequence sequence value consumed by this operation.
/// @param context Context that carries state for the operation.
function emitExplosion(actor, origin, sequence, context)
  return emit(context, actor, effect("explosion", "", origin, 0, GIB_ORGANIC, false, sequence, TE_EXPLOSION1))
end function
