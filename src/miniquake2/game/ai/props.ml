//! Provides miniquake2 game ai props facilities for this project.

/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Classic 3.19 boss3 stand and commander-body scripted AI props. */
package miniquake2.game.ai.props

import miniquake2.game.ai.constants as aipropconstants
import miniquake2.game.constants as aipropgameconstants
import miniquake2.qcommon.types as aipropqtypes

/// Report whether is prop.
/// @param actor actor value consumed by this operation.
function isProp(actor)
  return actor.className == "monster_boss3_stand" or actor.className == "monster_commander_body"
end function

/// Return the prop sound value.
/// @param actor actor value consumed by this operation.
/// @param context Context that carries state for the operation.
/// @param soundName soundName value consumed by this operation.
function propSound(actor, context, soundName)
  if typeof(context.playSound) == "function" then
    context.playSound(actor, soundName, aipropgameconstants.CHAN_BODY, aipropgameconstants.ATTN_NORM)
  end if
  return soundName
end function

/// Configure boss 3 stand.
/// @param actor actor value consumed by this operation.
/// @param context Context that carries state for the operation.
function configureBoss3Stand(actor, context)
  actor.mins = [-32.0, -32.0, 0.0]; actor.maxs = [32.0, 32.0, 90.0]
  actor.edict.mins = aipropqtypes.Vec3(-32.0, -32.0, 0.0); actor.edict.maxs = aipropqtypes.Vec3(32.0, 32.0, 90.0)
  actor.moveType = aipropconstants.MOVETYPE_STEP
  actor.edict.solid = aipropgameconstants.SOLID_BBOX
  actor.takeDamage = 0
  actor.info.currentMove = void
  actor.info.stand = void; actor.info.walk = void; actor.info.run = void
  actor.info.attack = void; actor.info.melee = void; actor.pain = void; actor.die = void
  if context.deathmatch then
    actor.edict.inUse = false
    actor.activity = "boss3-inhibited-deathmatch"
    actor.thinkKind = "none"
    actor.nextThink = 0.0
    return actor
  end if
  actor.edict.state.frame = 414
  actor.activity = "boss3-stand"
  actor.thinkKind = "boss3-stand"
  actor.nextThink = context.time + aipropconstants.FRAMETIME
  return actor
end function

/// Configure commander body.
/// @param actor actor value consumed by this operation.
/// @param context Context that carries state for the operation.
function configureCommanderBody(actor, context)
  actor.mins = [-32.0, -32.0, 0.0]; actor.maxs = [32.0, 32.0, 48.0]
  actor.edict.mins = aipropqtypes.Vec3(-32.0, -32.0, 0.0); actor.edict.maxs = aipropqtypes.Vec3(32.0, 32.0, 48.0)
  actor.moveType = aipropconstants.MOVETYPE_NONE
  actor.edict.solid = aipropgameconstants.SOLID_BBOX
  actor.takeDamage = 1
  actor.flags = actor.flags | aipropconstants.FL_GODMODE
  actor.edict.state.renderFx = actor.edict.state.renderFx | aipropgameconstants.RF_FRAMELERP
  actor.info.currentMove = void
  actor.info.stand = void; actor.info.walk = void; actor.info.run = void
  actor.info.attack = void; actor.info.melee = void; actor.pain = void; actor.die = void
  actor.activity = "commander-drop-wait"
  actor.thinkKind = "commander-drop"
  actor.nextThink = context.time + 5.0 * aipropconstants.FRAMETIME
  return actor
end function

/// Performs the configure operation for the miniquake2 game ai props module.
/// @param actor actor value consumed by this operation.
/// @param context Context that carries state for the operation.
function configure(actor, context)
  if actor.className == "monster_boss3_stand" then return configureBoss3Stand(actor, context) end if
  if actor.className == "monster_commander_body" then return configureCommanderBody(actor, context) end if
  return error(9635, "unsupported scripted AI prop " + actor.className)
end function

/// Starts start for the miniquake2 game ai props workflow.
/// @param actor actor value consumed by this operation.
/// @param context Context that carries state for the operation.
function Start(actor, context)
  return configure(actor, context)
end function

/// Start go.
/// @param actor actor value consumed by this operation.
/// @param context Context that carries state for the operation.
function StartGo(actor, context)
  return isProp(actor)
end function

/// Run boss 3.
/// @param actor actor value consumed by this operation.
/// @param context Context that carries state for the operation.
function boss3Think(actor, context)
  if actor.edict.inUse != true then return false end if
  if actor.edict.state.frame == 473 then actor.edict.state.frame = 414
  else actor.edict.state.frame = actor.edict.state.frame + 1 end if
  actor.activity = "boss3-stand"
  actor.thinkKind = "boss3-stand"
  actor.nextThink = context.time + aipropconstants.FRAMETIME
  return true
end function

/// Use boss 3.
/// @param actor actor value consumed by this operation.
/// @param other other value consumed by this operation.
/// @param activator activator value consumed by this operation.
/// @param context Context that carries state for the operation.
function boss3Use(actor, other, activator, context)
  if actor.edict.inUse != true then return false end if
  if typeof(context.tempEntity) == "function" then context.tempEntity(actor, aipropconstants.TE_BOSSTPORT) end if
  actor.edict.inUse = false
  actor.activity = "boss3-teleported"
  actor.thinkKind = "none"
  actor.nextThink = 0.0
  return true
end function

/// Drop commander.
/// @param actor actor value consumed by this operation.
/// @param context Context that carries state for the operation.
function commanderDrop(actor, context)
  aipropOriginHolder = actor.edict.state.origin
  actor.edict.state.origin = aipropqtypes.Vec3(aipropOriginHolder.x, aipropOriginHolder.y, aipropOriginHolder.z + 2.0)
  actor.moveType = aipropconstants.MOVETYPE_TOSS
  actor.activity = "commander-idle"
  actor.thinkKind = "none"
  actor.nextThink = 0.0
  return true
end function

/// Run commander.
/// @param actor actor value consumed by this operation.
/// @param context Context that carries state for the operation.
function commanderThink(actor, context)
  actor.edict.state.frame = actor.edict.state.frame + 1
  if actor.edict.state.frame == 22 then propSound(actor, context, "tank/thud.wav") end if
  if actor.edict.state.frame < 24 then
    actor.activity = "commander-animate"
    actor.thinkKind = "commander-body"
    actor.nextThink = context.time + aipropconstants.FRAMETIME
  else
    actor.activity = "commander-idle"
    actor.thinkKind = "none"
    actor.nextThink = 0.0
  end if
  return true
end function

/// Use commander.
/// @param actor actor value consumed by this operation.
/// @param other other value consumed by this operation.
/// @param activator activator value consumed by this operation.
/// @param context Context that carries state for the operation.
function commanderUse(actor, other, activator, context)
  if actor.edict.inUse != true then return false end if
  actor.activity = "commander-animate"
  actor.thinkKind = "commander-body"
  actor.nextThink = context.time + aipropconstants.FRAMETIME
  propSound(actor, context, "tank/pain.wav")
  return true
end function

/// Performs the Think operation for the miniquake2 game ai props module.
/// @param actor actor value consumed by this operation.
/// @param context Context that carries state for the operation.
function Think(actor, context)
  if actor.className == "monster_boss3_stand" then return boss3Think(actor, context) end if
  if actor.className == "monster_commander_body" then
    if actor.activity == "commander-drop-wait" then return commanderDrop(actor, context) end if
    if actor.activity == "commander-animate" then return commanderThink(actor, context) end if
    return false
  end if
  return error(9636, "scripted AI prop think on unsupported class")
end function

/// Use state.
/// @param actor actor value consumed by this operation.
/// @param other other value consumed by this operation.
/// @param activator activator value consumed by this operation.
/// @param context Context that carries state for the operation.
function Use(actor, other, activator, context)
  if actor.className == "monster_boss3_stand" then return boss3Use(actor, other, activator, context) end if
  if actor.className == "monster_commander_body" then return commanderUse(actor, other, activator, context) end if
  return error(9637, "scripted AI prop use on unsupported class")
end function

/// Restore phase.
/// @param actor actor value consumed by this operation.
function restorePhase(actor)
  actor.info.currentMove = void
  if actor.className == "monster_boss3_stand" then
    actor.mins = [-32.0, -32.0, 0.0]; actor.maxs = [32.0, 32.0, 90.0]
    actor.edict.mins = aipropqtypes.Vec3(-32.0, -32.0, 0.0); actor.edict.maxs = aipropqtypes.Vec3(32.0, 32.0, 90.0)
    if actor.activity == "boss3-teleported" then actor.edict.inUse = false; actor.nextThink = 0.0 end if
    return actor
  end if
  if actor.className == "monster_commander_body" then
    actor.mins = [-32.0, -32.0, 0.0]; actor.maxs = [32.0, 32.0, 48.0]
    actor.edict.mins = aipropqtypes.Vec3(-32.0, -32.0, 0.0); actor.edict.maxs = aipropqtypes.Vec3(32.0, 32.0, 48.0)
    actor.flags = actor.flags | aipropconstants.FL_GODMODE
    return actor
  end if
  return error(9638, "scripted AI prop restore on unsupported class")
end function
