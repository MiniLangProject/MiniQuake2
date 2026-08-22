/* Stock Quake II corpse bounds, gib inventories and boss explosions. */
package miniquake2.game.ai.death_effects

import miniquake2.qcommon.types as gaideathqtypes

const GIB_ORGANIC = 0
const GIB_METALLIC = 1
const TE_EXPLOSION1 = 5

struct CorpseBounds
  minimumX
  minimumY
  minimumZ
  maximumX
  maximumY
  maximumZ
end struct

struct GibSpec
  modelName
  count
  gibType
  head
end struct

struct MonsterDeathEffect
  kind
  modelName
  origin
  damage
  gibType
  head
  sequence
  effectType
end struct

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

function organicGibs()
  return [
    GibSpec("models/objects/gibs/bone/tris.md2", 2, GIB_ORGANIC, false),
    GibSpec("models/objects/gibs/sm_meat/tris.md2", 4, GIB_ORGANIC, false),
    GibSpec("models/objects/gibs/head2/tris.md2", 1, GIB_ORGANIC, true),
  ]
end function

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

function supertankFinalGibs()
  return [
    GibSpec("models/objects/gibs/sm_meat/tris.md2", 4, GIB_ORGANIC, false),
    GibSpec("models/objects/gibs/sm_metal/tris.md2", 8, GIB_METALLIC, false),
    GibSpec("models/objects/gibs/chest/tris.md2", 1, GIB_ORGANIC, false),
    GibSpec("models/objects/gibs/gear/tris.md2", 1, GIB_METALLIC, true),
  ]
end function

function effect(kind, modelName, origin, damage, gibType, head, sequence, effectType)
  if typeof(origin) != "struct" then return error(9680, "monster death effect requires an origin") end if
  gaideathOriginHolder = gaideathqtypes.Vec3(origin.x, origin.y, origin.z)
  return MonsterDeathEffect(kind, modelName, gaideathOriginHolder, damage, gibType, head, sequence, effectType)
end function

function emit(context, actor, event)
  if typeof(context.deathEffect) != "function" then return true end if
  return context.deathEffect(actor, event)
end function

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

function emitMonsterGibs(actor, damage, context)
  return emitGibSpecs(actor, gibPlan(actor.className), damage, context)
end function

function emitSupertankFinalGibs(actor, context)
  return emitGibSpecs(actor, supertankFinalGibs(), 500, context)
end function

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

function emitExplosion(actor, origin, sequence, context)
  return emit(context, actor, effect("explosion", "", origin, 0, GIB_ORGANIC, false, sequence, TE_EXPLOSION1))
end function
