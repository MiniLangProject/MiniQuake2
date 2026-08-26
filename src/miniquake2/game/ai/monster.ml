/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Callback-driven port of g_monster.c frame and lifecycle machinery. */
package miniquake2.game.ai.monster

import miniquake2.game.ai.constants as gaiconstants
import miniquake2.game.ai.core as gaicore
import miniquake2.game.ai.move as gaimove
import miniquake2.game.ai.reaction_sequences as gaireactions
import miniquake2.game.ai.death_effects as gaideatheffects
import miniquake2.game.ai.locomotion_sequences as gailocomotion
import miniquake2.game.ai.sounds as gaisounds
import miniquake2.game.ai.props as gaimonsterprops
import miniquake2.game.constants as gconstants
import miniquake2.qcommon.constants as qconstants
import miniquake2.qcommon.types as gaiqtypes
import std.math as gaimath

function CurrentMoveName(actor)
  if actor.info.currentMove is void then return "" end if
  return actor.info.currentMove.name
end function

function EmitStockSound(actor, context, soundName, channel, attenuation)
  if soundName != "" and typeof(context.playSound) == "function" then
    context.playSound(actor, soundName, channel, attenuation)
  end if
  return soundName
end function

function NextStockRandomUnit(context, fallback)
  if typeof(context.nextRandomUnit) == "function" then return context.nextRandomUnit() end if
  return fallback
end function

function NextStockRandomInteger(context, fallback)
  if typeof(context.nextRandomInteger) == "function" then return context.nextRandomInteger() end if
  return fallback
end function

function StockIdleSoundName(className)
  if className == "monster_berserk" then return "berserk/beridle1.wav" end if
  if className == "monster_gladiator" then return "gladiator/gldidle1.wav" end if
  if className == "monster_gunner" then return "gunner/gunidle1.wav" end if
  if className == "monster_infantry" then return "infantry/infidle1.wav" end if
  if className == "monster_soldier_light" or className == "monster_soldier" or className == "monster_soldier_ss" then return "soldier/solidle1.wav" end if
  if className == "monster_tank" or className == "monster_tank_commander" then return "tank/tnkidle1.wav" end if
  if className == "monster_medic" then return "medic/idle.wav" end if
  if className == "monster_flipper" then return "flipper/flpidle1.wav" end if
  if className == "monster_chick" then return "chick/chkidle1.wav" end if
  if className == "monster_brain" then return "brain/brnlens1.wav" end if
  if className == "monster_floater" then return "floater/fltidle1.wav" end if
  if className == "monster_flyer" then return "flyer/flyidle1.wav" end if
  if className == "monster_mutant" then return "mutant/mutidle1.wav" end if
  if className == "monster_jorg" then return "boss3/bs3idle1.wav" end if
  return ""
end function

function StockFidgetFrameSound(actor, context)
  soundName = StockIdleSoundName(actor.className)
  channel = gconstants.CHAN_VOICE
  if actor.className == "monster_brain" then channel = gconstants.CHAN_AUTO end if
  if actor.className == "monster_berserk" then channel = gconstants.CHAN_WEAPON end if
  if actor.className == "monster_chick" then
    if NextStockRandomUnit(context, context.randomIdle) < 0.5 then
      soundName = "chick/chkidle1.wav"
    else soundName = "chick/chkidle2.wav" end if
  end if
  return EmitStockSound(actor, context, soundName, channel, gconstants.ATTN_IDLE)
end function

function StockScratchSound(actor, context)
  return EmitStockSound(actor, context, "parasite/paridle2.wav",
    gconstants.CHAN_WEAPON, gconstants.ATTN_IDLE)
end function

function StockSoldierCockSound(actor, context)
  return EmitStockSound(actor, context, "infantry/infatck3.wav",
    gconstants.CHAN_WEAPON, gconstants.ATTN_IDLE)
end function

function StockSoldierIdleFrameSound(actor, context)
  if NextStockRandomUnit(context, context.randomIdle) <= 0.8 then return "" end if
  return EmitStockSound(actor, context, "soldier/solidle1.wav",
    gconstants.CHAN_VOICE, gconstants.ATTN_IDLE)
end function

function StockSoldierWalkCycle(actor, context)
  if NextStockRandomUnit(context, context.randomIdle) > 0.1 then
    actor.info.nextFrame = 215
  end if
  return true
end function

function StockMedicIdleFrame(actor, context)
  EmitStockSound(actor, context, "medic/idle.wav",
    gconstants.CHAN_VOICE, gconstants.ATTN_IDLE)
  FindMedicPatient(actor, false, context)
  return true
end function

function StockParasiteTapSound(actor, context)
  return EmitStockSound(actor, context, "parasite/paridle1.wav",
    gconstants.CHAN_WEAPON, gconstants.ATTN_IDLE)
end function

function StockJorgIdleSound(actor, context)
  return EmitStockSound(actor, context, "boss3/bs3idle1.wav",
    gconstants.CHAN_VOICE, gconstants.ATTN_NORM)
end function

function StockJorgStepLeft(actor, context)
  return EmitStockSound(actor, context, "boss3/step1.wav",
    gconstants.CHAN_BODY, gconstants.ATTN_NORM)
end function

function StockJorgStepRight(actor, context)
  return EmitStockSound(actor, context, "boss3/step2.wav",
    gconstants.CHAN_BODY, gconstants.ATTN_NORM)
end function

function StockStepSound(actor, context)
  soundName = ""
  channel = gconstants.CHAN_BODY
  if actor.className == "monster_tank" or actor.className == "monster_tank_commander" then soundName = "tank/step.wav"
  else if actor.className == "monster_supertank" then
    soundName = "bosstank/btkengn1.wav"
    channel = gconstants.CHAN_VOICE
  else if actor.className == "monster_jorg" then
    if (actor.edict.state.frame % 2) == 0 then soundName = "boss3/step1.wav" else soundName = "boss3/step2.wav" end if
  else if actor.className == "monster_makron" then
    if actor.edict.state.frame == 477 then soundName = "makron/step1.wav" else soundName = "makron/step2.wav" end if
  else if actor.className == "monster_mutant" then
    stepVariant = NextStockRandomInteger(context, context.randomFrame) % 3
    if stepVariant == 0 then soundName = "mutant/step1.wav"
    else if stepVariant == 1 then soundName = "mutant/step2.wav"
    else soundName = "mutant/step3.wav" end if
    channel = gconstants.CHAN_VOICE
  end if
  return EmitStockSound(actor, context, soundName, channel, gconstants.ATTN_NORM)
end function

function ConfigureStockMoveCallbacks(actor, move)
  if move is void then return move end if
  moveName = move.name
  if moveName == "berserk-stand" then move.frames[0].thinkFunction = StockStandFidgetProbe
  else if moveName == "gunner-stand" then
    move.frames[9].thinkFunction = StockStandFidgetProbe
    move.frames[19].thinkFunction = StockStandFidgetProbe
    move.frames[29].thinkFunction = StockStandFidgetProbe
  else if moveName == "chick-stand" then move.frames[29].thinkFunction = StockStandFidgetProbe
  else if moveName == "gunner-stand-fidget" then move.frames[7].thinkFunction = StockFidgetFrameSound
  else if moveName == "chick-stand-fidget" then move.frames[8].thinkFunction = StockFidgetFrameSound
  else if moveName == "soldier-stand-fidget" then move.frames[21].thinkFunction = StockSoldierCockSound
  else if moveName == "soldier-stand" then move.frames[0].thinkFunction = StockSoldierIdleFrameSound
  else if moveName == "soldier-walk1" then move.frames[9].thinkFunction = StockSoldierWalkCycle
  else if moveName == "medic-stand" then move.frames[0].thinkFunction = StockMedicIdleFrame
  else if moveName == "parasite-stand" then
    move.frames[2].thinkFunction = StockParasiteTapSound
    move.frames[4].thinkFunction = StockParasiteTapSound
    move.frames[8].thinkFunction = StockParasiteTapSound
    move.frames[10].thinkFunction = StockParasiteTapSound
    move.frames[14].thinkFunction = StockParasiteTapSound
    move.frames[16].thinkFunction = StockParasiteTapSound
  else if moveName == "parasite-fidget-loop" then
    move.frames[0].thinkFunction = StockScratchSound
    move.frames[3].thinkFunction = StockScratchSound
  else if moveName == "parasite-fidget-end" then move.frames[0].thinkFunction = StockScratchSound
  else if moveName == "mutant-stand-fidget" then move.frames[6].thinkFunction = StockMutantIdleLoop
  else if moveName == "tank-walk" or moveName == "tank-run" then
    move.frames[7].thinkFunction = StockStepSound
    move.frames[15].thinkFunction = StockStepSound
  else if moveName == "tank-run-start" then move.frames[3].thinkFunction = StockStepSound
  else if moveName == "supertank-walk" or moveName == "supertank-run" then move.frames[0].thinkFunction = StockStepSound
  else if moveName == "mutant-run" then
    move.frames[1].thinkFunction = StockStepSound
    move.frames[3].thinkFunction = StockStepSound
  else if moveName == "jorg-stand" then
    move.frames[0].thinkFunction = StockJorgIdleSound
    move.frames[34].thinkFunction = StockJorgStepLeft
    move.frames[38].thinkFunction = StockJorgStepRight
    move.frames[47].thinkFunction = StockJorgStepLeft
    move.frames[50].thinkFunction = StockJorgStepRight
  else if moveName == "jorg-run" then
    move.frames[0].thinkFunction = StockJorgStepLeft
    move.frames[7].thinkFunction = StockJorgStepRight
  else if moveName == "makron-walk" or moveName == "makron-run" then
    move.frames[0].thinkFunction = StockStepSound
    move.frames[4].thinkFunction = StockStepSound
  end if
  return move
end function

function SetStockMove(actor, moveKind, endFunction)
  move = gailocomotion.stockMove(actor.className, moveKind, endFunction)
  if move is void then return error(9655, "missing stock locomotion move " + actor.className + "/" + moveKind) end if
  ConfigureStockMoveCallbacks(actor, move)
  actor.info.currentMove = move
  return move
end function

function StockStandFidgetProbe(actor, context)
  if (actor.info.aiFlags & gaiconstants.AI_STAND_GROUND) != 0 then return false end if
  threshold = -1.0
  if actor.className == "monster_berserk" then threshold = 0.15
  else if actor.className == "monster_gunner" then threshold = 0.05
  else if actor.className == "monster_chick" then threshold = 0.30 end if
  if threshold < 0.0 or
      NextStockRandomUnit(context, context.randomIdle) > threshold then return false end if
  actor.activity = "idle"
  SetStockMove(actor, "stand-fidget", StateStand)
  if actor.className == "monster_berserk" then StockFidgetFrameSound(actor, context) end if
  return true
end function

function StockMutantIdleLoop(actor, context)
  if NextStockRandomUnit(context, context.randomIdle) < 0.75 then
    actor.info.nextFrame = 116
  end if
  return true
end function

function ClaimMedicPatient(actor, patient, preserveEnemy, context)
  if patient is void then return false end if
  if preserveEnemy then actor.oldEnemy = actor.enemy end if
  actor.enemy = patient
  patient.owner = actor
  actor.info.aiFlags = actor.info.aiFlags | gaiconstants.AI_MEDIC
  gaicore.FoundTarget(actor, context)
  return true
end function

function FindMedicPatient(actor, preserveEnemy, context)
  if typeof(context.findDeadMonster) != "function" then return false end if
  return ClaimMedicPatient(actor, context.findDeadMonster(actor), preserveEnemy, context)
end function

function FinishWalkStart(actor, context)
  actor.activity = "walk"
  return SetStockMove(actor, "walk", void)
end function

function FinishRunStart(actor, context)
  actor.activity = "run"
  return SetStockMove(actor, "run", void)
end function

function FinishFlipperRunTransition(actor, context)
  actor.activity = "run"
  return SetStockMove(actor, "run-start", FinishRunStart)
end function

function FinishParasiteFidgetStart(actor, context)
  actor.activity = "idle"
  return SetStockMove(actor, "fidget-loop", FinishParasiteFidgetLoop)
end function

function FinishParasiteFidgetLoop(actor, context)
  actor.activity = "idle"
  if NextStockRandomUnit(context, context.randomIdle) <= 0.8 then
    return SetStockMove(actor, "fidget-loop", FinishParasiteFidgetLoop)
  end if
  return SetStockMove(actor, "fidget-end", StateStand)
end function

function StateStand(actor, context)
  actor.activity = "stand"
  if not gailocomotion.hasStockMoves(actor.className) then return true end if
  currentName = CurrentMoveName(actor)
  if actor.className == "monster_soldier_light" or actor.className == "monster_soldier" or actor.className == "monster_soldier_ss" then
    if currentName == "soldier-stand-fidget" or
        NextStockRandomUnit(context, context.randomIdle) < 0.8 then
      return SetStockMove(actor, "stand", StateStand)
    end if
    return SetStockMove(actor, "stand-fidget", StateStand)
  end if
  if actor.className == "monster_floater" and
      NextStockRandomUnit(context, context.randomIdle) > 0.5 then
    return SetStockMove(actor, "stand2", void)
  end if
  if actor.className == "monster_parasite" then return SetStockMove(actor, "stand", StateStand) end if
  return SetStockMove(actor, "stand", void)
end function

function StateIdle(actor, context)
  actor.activity = "idle"
  if actor.className == "monster_infantry" or actor.className == "monster_brain" or
      actor.className == "monster_mutant" then
    StockFidgetFrameSound(actor, context)
    return SetStockMove(actor, "stand-fidget", StateStand)
  end if
  if actor.className == "monster_parasite" then
    return SetStockMove(actor, "fidget-start", FinishParasiteFidgetStart)
  end if
  StockFidgetFrameSound(actor, context)
  // medic_idle plays its idle voice first and then claims the strongest
  // visible unowned corpse in range without preserving the prior enemy.
  if actor.className == "monster_medic" then FindMedicPatient(actor, false, context) end if
  return true
end function

function StateSearch(actor, context)
  actor.activity = "search"
  searchRoll = 0.0
  if gaisounds.searchUsesRandom(actor.className) then
    searchRoll = NextStockRandomUnit(context, context.randomIdle)
  end if
  EmitStockSound(actor, context, gaisounds.searchName(actor.className, searchRoll),
    gconstants.CHAN_VOICE, gaisounds.searchAttenuation(actor.className))
  // medic_search only interrupts the current hunt when it has no saved enemy.
  if actor.className == "monster_medic" and actor.oldEnemy is void then
    FindMedicPatient(actor, true, context)
  end if
  return true
end function

function StateWalk(actor, context)
  actor.activity = "walk"
  if not gailocomotion.hasStockMoves(actor.className) then return true end if
  if actor.className == "monster_mutant" or actor.className == "monster_parasite" then
    return SetStockMove(actor, "walk-start", FinishWalkStart)
  end if
  if actor.className == "monster_soldier_light" or actor.className == "monster_soldier" or actor.className == "monster_soldier_ss" then
    if NextStockRandomUnit(context, context.randomIdle) >= 0.5 then
      return SetStockMove(actor, "soldier-walk2", void)
    end if
  end if
  return SetStockMove(actor, "walk", void)
end function

function StateRun(actor, context)
  // medic_run opportunistically scans whenever it is not already committed to
  // a patient. FoundTarget re-enters this callback with AI_MEDIC set, so the
  // second invocation installs the run move without recursing again.
  if actor.className == "monster_medic" and
      (actor.info.aiFlags & gaiconstants.AI_MEDIC) == 0 then
    if FindMedicPatient(actor, true, context) then return true end if
  end if
  if (actor.info.aiFlags & gaiconstants.AI_STAND_GROUND) != 0 then return StateStand(actor, context) end if
  actor.activity = "run"
  if actor.className == "monster_brain" then
    actor.powerArmorType = gaiconstants.POWER_ARMOR_SCREEN
  end if
  if not gailocomotion.hasStockMoves(actor.className) then return true end if
  currentName = CurrentMoveName(actor)
  if actor.className == "monster_soldier_light" or actor.className == "monster_soldier" or actor.className == "monster_soldier_ss" then
    if currentName == "soldier-walk1" or currentName == "soldier-walk2" or currentName == "soldier-run-start" then return SetStockMove(actor, "run", void) end if
    return SetStockMove(actor, "run-start", FinishRunStart)
  end if
  if actor.className == "monster_tank" or actor.className == "monster_tank_commander" then
    if currentName == "tank-walk" or currentName == "tank-run-start" then return SetStockMove(actor, "run", void) end if
    return SetStockMove(actor, "run-start", FinishRunStart)
  end if
  if actor.className == "monster_chick" then
    if currentName == "chick-walk" or currentName == "chick-run-start" then return SetStockMove(actor, "run", void) end if
    return SetStockMove(actor, "run-start", FinishRunStart)
  end if
  if actor.className == "monster_parasite" then
    return SetStockMove(actor, "run-start", FinishRunStart)
  end if
  if actor.className == "monster_flipper" then
    return SetStockMove(actor, "run-transition", FinishFlipperRunTransition)
  end if
  return SetStockMove(actor, "run", void)
end function

function StateAttack(actor, context)
  actor.activity = "attack"
  actor.attackCount = actor.attackCount + 1
  return true
end function

function StateMelee(actor, context)
  actor.activity = "melee"
  actor.meleeCount = actor.meleeCount + 1
  return true
end function

function StateSight(actor, enemy, context)
  actor.activity = "sight"
  sightRoll = 0.0
  if gaisounds.sightUsesRandom(actor.className) then
    sightRoll = NextStockRandomUnit(context, context.randomIdle)
  end if
  EmitStockSound(actor, context, gaisounds.sightName(actor.className, sightRoll),
    gaisounds.sightChannel(actor.className), gconstants.ATTN_NORM)
  if gaisounds.isSoldier(actor.className) and enemy is not void and context.skill > 0 and
      gaicore.range(actor, enemy) >= gaiconstants.RANGE_MID then
    if NextStockRandomUnit(context, context.randomAttack) > 0.5 then
      // soldier_sight swaps directly to soldier_move_attack6. The integrated
      // combat layer consumes this pending marker and installs its exact table.
      actor.activity = "soldier-run-shoot-pending"
      actor.info.nextFrame = 0
      actor.info.pauseTime = 0.0
      actor.attackCycles = 0
    end if
  else if actor.className == "monster_makron" then
    SetStockMove(actor, "sight", StateRun)
  end if
  return true
end function

function StatePain(actor, attacker, damage, context)
  actor.activity = "pain"
  actor.painCount = actor.painCount + 1
  return true
end function

function StateDie(actor, attacker, damage, context)
  if actor.className == "monster_medic" and actor.enemy is not void and
      actor.enemy.owner is not void and
      nativeRawValue(actor.enemy.owner) == nativeRawValue(actor) then
    // medic_die releases a reserved patient so another Medic can take over.
    actor.enemy.owner = void
  end if
  actor.activity = "dead"
  if actor.className == "monster_brain" then
    actor.edict.state.effects = 0
    actor.powerArmorType = gaiconstants.POWER_ARMOR_NONE
  end if
  actor.dieCount = actor.dieCount + 1
  actor.deadFlag = gaiconstants.DEAD_DEAD
  actor.edict.serverFlags = actor.edict.serverFlags | gconstants.SVF_DEADMONSTER
  return true
end function

function DefaultCheckAttack(actor, context, enemyRange)
  return gaicore.M_CheckAttack(actor, context, enemyRange)
end function

function MedicCheckAttack(actor, context, enemyRange)
  if (actor.info.aiFlags & gaiconstants.AI_MEDIC) != 0 then
    StateAttack(actor, context)
    actor.activity = "medic-cable-pending"
    return true
  end if
  return DefaultCheckAttack(actor, context, enemyRange)
end function

function MutantCheckAttack(actor, context, enemyRange)
  if actor.enemy is void or actor.enemy.edict.inUse != true or actor.enemy.health <= 0 then return false end if
  if enemyRange == gaiconstants.RANGE_MELEE then
    actor.info.attackState = gaiconstants.AS_MELEE
    return true
  end if
  actorBottom = actor.edict.state.origin.z + actor.mins[2]
  actorTop = actor.edict.state.origin.z + actor.maxs[2]
  enemyBottom = actor.enemy.edict.state.origin.z + actor.enemy.mins[2]
  enemyHeight = actor.enemy.maxs[2] - actor.enemy.mins[2]
  if actorBottom > enemyBottom + 0.75 * enemyHeight then return false end if
  if actorTop < enemyBottom + 0.25 * enemyHeight then return false end if
  deltaX = actor.edict.state.origin.x - actor.enemy.edict.state.origin.x
  deltaY = actor.edict.state.origin.y - actor.enemy.edict.state.origin.y
  horizontalSquared = deltaX * deltaX + deltaY * deltaY
  if horizontalSquared < 10000.0 then return false end if
  if horizontalSquared > 10000.0 and context.randomAttack < 0.9 then return false end if
  actor.info.attackState = gaiconstants.AS_MISSILE
  return true
end function

function installDefaultCallbacks(actor, hasAttack, hasMelee)
  actor.info.stand = StateStand
  actor.info.idle = void
  if actor.className == "monster_gladiator" or actor.className == "monster_infantry" or
      actor.className == "monster_tank" or actor.className == "monster_tank_commander" or
      actor.className == "monster_medic" or actor.className == "monster_parasite" or
      actor.className == "monster_flyer" or actor.className == "monster_brain" or
      actor.className == "monster_floater" or actor.className == "monster_mutant" then
    actor.info.idle = StateIdle
  end if
  if gaisounds.hasSearchCallback(actor.className) then actor.info.search = StateSearch
  else actor.info.search = void end if
  actor.info.walk = StateWalk
  actor.info.run = StateRun
  if hasAttack then actor.info.attack = StateAttack else actor.info.attack = void end if
  if hasMelee then actor.info.melee = StateMelee else actor.info.melee = void end if
  if gaisounds.hasSightCallback(actor.className) then actor.info.sight = StateSight
  else actor.info.sight = void end if
  actor.info.checkAttack = DefaultCheckAttack
  if actor.className == "monster_medic" then actor.info.checkAttack = MedicCheckAttack end if
  if actor.className == "monster_mutant" then actor.info.checkAttack = MutantCheckAttack end if
  actor.pain = StatePain
  actor.die = StateDie
  return actor
end function

function M_FliesOff(actor, context)
  actor.edict.state.effects = actor.edict.state.effects & ~gconstants.EF_FLIES
  actor.edict.state.sound = 0
  actor.thinkKind = "none"
  actor.nextThink = 0.0
  return true
end function

function M_FliesOn(actor, context)
  actor.thinkKind = "none"
  actor.nextThink = 0.0
  if actor.waterLevel != 0 then return false end if
  actor.edict.state.effects = actor.edict.state.effects | gconstants.EF_FLIES
  if typeof(context.soundIndex) == "function" then
    actor.edict.state.sound = context.soundIndex("infantry/inflies1.wav")
  end if
  actor.thinkKind = "flies-off"
  actor.nextThink = context.time + 60.0
  return true
end function

function M_FlyCheck(actor, context)
  if actor.waterLevel != 0 then return false end if
  if NextStockRandomUnit(context, context.randomIdle) > 0.5 then return false end if
  actor.thinkKind = "flies-on"
  actor.nextThink = context.time + 5.0 +
    10.0 * NextStockRandomUnit(context, context.randomDelay)
  return true
end function

function ApplyWorldDamage(actor, amount, damageFlags, meansOfDeath, context)
  if typeof(context.damage) == "function" then
    return context.damage(actor, amount, damageFlags, meansOfDeath)
  end if
  actor.health = actor.health - amount
  if actor.health <= 0 then return DispatchDie(actor, void, amount, context) end if
  DispatchPain(actor, void, amount, context)
  return amount
end function

function M_WorldEffects(actor, context)
  if actor.health > 0 then
    if (actor.flags & gaiconstants.FL_SWIM) == 0 then
      if actor.waterLevel < 3 then
        actor.airFinished = context.time + 12.0
      else if actor.airFinished < context.time and
          actor.painDebounceTime < context.time then
        damage = 2 + 2 * gaimath.floor(context.time - actor.airFinished)
        if damage > 15 then damage = 15 end if
        ApplyWorldDamage(actor, damage, gaiconstants.DAMAGE_NO_ARMOR,
          gaiconstants.MOD_WATER, context)
        actor.painDebounceTime = context.time + 1.0
      end if
    else
      if actor.waterLevel > 0 then
        actor.airFinished = context.time + 9.0
      else if actor.airFinished < context.time and
          actor.painDebounceTime < context.time then
        damage = 2 + 2 * gaimath.floor(context.time - actor.airFinished)
        if damage > 15 then damage = 15 end if
        ApplyWorldDamage(actor, damage, gaiconstants.DAMAGE_NO_ARMOR,
          gaiconstants.MOD_WATER, context)
        actor.painDebounceTime = context.time + 1.0
      end if
    end if
  end if

  if actor.waterLevel == 0 then
    if (actor.flags & gaiconstants.FL_INWATER) != 0 then
      EmitStockSound(actor, context, "player/watr_out.wav",
        gconstants.CHAN_BODY, gconstants.ATTN_NORM)
      actor.flags = actor.flags & ~gaiconstants.FL_INWATER
    end if
    return true
  end if

  if (actor.waterType & qconstants.CONTENTS_LAVA) != 0 and
      (actor.flags & gaiconstants.FL_IMMUNE_LAVA) == 0 and
      actor.damageDebounceTime < context.time then
    actor.damageDebounceTime = context.time + 0.2
    ApplyWorldDamage(actor, 10 * actor.waterLevel, 0,
      gaiconstants.MOD_LAVA, context)
  end if
  if (actor.waterType & qconstants.CONTENTS_SLIME) != 0 and
      (actor.flags & gaiconstants.FL_IMMUNE_SLIME) == 0 and
      actor.damageDebounceTime < context.time then
    actor.damageDebounceTime = context.time + 1.0
    ApplyWorldDamage(actor, 4 * actor.waterLevel, 0,
      gaiconstants.MOD_SLIME, context)
  end if

  if (actor.flags & gaiconstants.FL_INWATER) == 0 then
    if (actor.edict.serverFlags & gconstants.SVF_DEADMONSTER) == 0 then
      if (actor.waterType & qconstants.CONTENTS_LAVA) != 0 then
        soundName = "player/lava1.wav"
        if NextStockRandomUnit(context, context.randomIdle) > 0.5 then
          soundName = "player/lava2.wav"
        end if
        EmitStockSound(actor, context, soundName,
          gconstants.CHAN_BODY, gconstants.ATTN_NORM)
      else if (actor.waterType & (qconstants.CONTENTS_SLIME | qconstants.CONTENTS_WATER)) != 0 then
        EmitStockSound(actor, context, "player/watr_in.wav",
          gconstants.CHAN_BODY, gconstants.ATTN_NORM)
      end if
    end if
    actor.flags = actor.flags | gaiconstants.FL_INWATER
    actor.damageDebounceTime = 0.0
  end if
  return true
end function

function M_SetEffects(actor, context)
  actor.edict.state.effects = actor.edict.state.effects & ~(gconstants.EF_COLOR_SHELL | gconstants.EF_POWERSCREEN)
  actor.edict.state.renderFx = actor.edict.state.renderFx & ~(gconstants.RF_SHELL_RED | gconstants.RF_SHELL_GREEN | gconstants.RF_SHELL_BLUE)
  if (actor.info.aiFlags & gaiconstants.AI_RESURRECTING) != 0 then
    actor.edict.state.effects = actor.edict.state.effects | gconstants.EF_COLOR_SHELL
    actor.edict.state.renderFx = actor.edict.state.renderFx | gconstants.RF_SHELL_RED
  end if
  if actor.health <= 0 then return true end if
  if actor.powerArmorTime > context.time then
    if actor.powerArmorType == gaiconstants.POWER_ARMOR_SCREEN then
      actor.edict.state.effects = actor.edict.state.effects | gconstants.EF_POWERSCREEN
    else if actor.powerArmorType == gaiconstants.POWER_ARMOR_SHIELD then
      actor.edict.state.effects = actor.edict.state.effects | gconstants.EF_COLOR_SHELL
      actor.edict.state.renderFx = actor.edict.state.renderFx | gconstants.RF_SHELL_GREEN
    end if
  end if
  return true
end function

function M_MoveFrame(actor, context)
  move = actor.info.currentMove
  if move is void then return error(9650, "M_MoveFrame: monster has no current move") end if
  if len(move.frames) != move.lastFrame - move.firstFrame + 1 then return error(9651, "M_MoveFrame: frame table length mismatch for " + move.name) end if
  actor.nextThink = context.time + gaiconstants.FRAMETIME
  if actor.info.nextFrame != 0 and actor.info.nextFrame >= move.firstFrame and actor.info.nextFrame <= move.lastFrame then
    actor.edict.state.frame = actor.info.nextFrame
    actor.info.nextFrame = 0
  else
    if actor.edict.state.frame == move.lastFrame and typeof(move.endFunction) == "function" then
      move.endFunction(actor, context)
      move = actor.info.currentMove
      if (actor.edict.serverFlags & gconstants.SVF_DEADMONSTER) != 0 then return true end if
    end if
    if actor.edict.state.frame < move.firstFrame or actor.edict.state.frame > move.lastFrame then
      actor.info.aiFlags = actor.info.aiFlags & ~gaiconstants.AI_HOLD_FRAME
      actor.edict.state.frame = move.firstFrame
    else if (actor.info.aiFlags & gaiconstants.AI_HOLD_FRAME) == 0 then
      actor.edict.state.frame = actor.edict.state.frame + 1
      if actor.edict.state.frame > move.lastFrame then actor.edict.state.frame = move.firstFrame end if
    end if
  end if
  index = actor.edict.state.frame - move.firstFrame
  frame = move.frames[index]
  if typeof(frame.aiFunction) == "function" then
    distance = frame.distance * actor.info.scale
    if (actor.info.aiFlags & gaiconstants.AI_HOLD_FRAME) != 0 then distance = 0.0 end if
    frame.aiFunction(actor, distance, context)
  end if
  if typeof(frame.thinkFunction) == "function" then frame.thinkFunction(actor, context) end if
  return true
end function

function ContinueBossDeath(actor, context)
  if actor.bossPhase != "jorg-death" or actor.successorSpawned then return false end if
  if context.time < actor.successorDueTime then
    actor.nextThink = actor.successorDueTime
    return false
  end if
  if typeof(context.spawnMonster) != "function" then return error(9653, "Jorg death continuation requires spawnMonster callback") end if

  // Mark the transition before invoking the external spawn boundary.  A
  // restored frame or re-entrant think can therefore never toss Makron twice.
  actor.successorSpawned = true
  actor.bossPhase = "jorg-makron-tossed"
  successor = context.spawnMonster(actor.successorClassName, actor)
  if successor is void then return error(9654, "Jorg death continuation did not create Makron") end if
  successor.bossPhase = "makron-active"
  successor.target = actor.target
  successor.enemy = actor.enemy
  return true
end function

function RunReactionFrameCallbacks(actor, plan, timelineOffset, context)
  gaiReactionFrameRoll = 0.0
  if gaireactions.frameSoundUsesRandom(plan, timelineOffset) then
    gaiReactionFrameRoll = NextStockRandomUnit(context, context.randomAttack)
  end if
  gaiReactionFrameSound = gaireactions.frameSoundNameAt(
    plan, timelineOffset, gaiReactionFrameRoll)
  if gaiReactionFrameSound != "" then
    EmitStockSound(actor, context, gaiReactionFrameSound,
      gaireactions.frameSoundChannelAt(plan, timelineOffset),
      gaireactions.frameSoundAttenuationAt(plan, timelineOffset))
  end if
  gaiReactionExternalEvent = gaireactions.externalFrameEventAt(plan, timelineOffset)
  if gaiReactionExternalEvent != "" and typeof(context.reactionFrameEvent) == "function" then
    return context.reactionFrameEvent(actor, plan, timelineOffset, gaiReactionExternalEvent)
  end if
  return true
end function

function StartReaction(actor, plan, context)
  gaireactions.validatePlan(plan)
  actor.activity = plan.name
  // Changing currentmove clears a prior held attack frame in M_MoveFrame.
  // attackCycles is then reused only by the stock SS death-fire hold and is
  // persisted together with AI_HOLD_FRAME for a mid-burst level save.
  actor.info.aiFlags = actor.info.aiFlags & ~gaiconstants.AI_HOLD_FRAME
  actor.attackCycles = 0
  // The first pose becomes visible in the damage frame itself. The next
  // scheduled think therefore advances to offset one without duplicating it.
  actor.info.nextFrame = 1
  actor.info.pauseTime = context.time + gaiconstants.FRAMETIME
  actor.edict.state.frame = plan.firstFrame
  gaicore.ai_move(actor, gaireactions.movementDistanceAt(plan, 0) * actor.info.scale, context)
  gaiReactionStartCallbackResult = RunReactionFrameCallbacks(actor, plan, 0, context)
  if gaiReactionStartCallbackResult is error then return gaiReactionStartCallbackResult end if
  actor.nextThink = context.time + gaiconstants.FRAMETIME
  if plan.reactionKind == "dodge" then
    actor.info.aiFlags = actor.info.aiFlags | gaiconstants.AI_DUCKED
    gaiDodgeMaximumHolder = actor.edict.maxs
    actor.edict.maxs = gaiqtypes.Vec3(gaiDodgeMaximumHolder.x, gaiDodgeMaximumHolder.y, gaiDodgeMaximumHolder.z - 32.0)
  end if
  if plan.soundName != "" and typeof(context.playSound) == "function" then
    context.playSound(actor, plan.soundName, gconstants.CHAN_VOICE, plan.attenuation)
  end if
  return true
end function

function FinishReaction(actor, plan, context)
  actor.info.nextFrame = 0
  actor.info.pauseTime = 0.0
  if plan.terminalKind == "run" then
    if plan.reactionKind == "dodge" then
      actor.info.aiFlags = actor.info.aiFlags & ~gaiconstants.AI_DUCKED
      actor.edict.maxs = gaiqtypes.Vec3(actor.maxs[0], actor.maxs[1], actor.maxs[2])
    end if
    if typeof(actor.info.run) == "function" then actor.info.run(actor, context)
    else actor.activity = "run" end if
    actor.nextThink = context.time + gaiconstants.FRAMETIME
    return true
  end if
  actor.deadFlag = gaiconstants.DEAD_DEAD
  actor.edict.serverFlags = actor.edict.serverFlags | gconstants.SVF_DEADMONSTER
  if plan.terminalKind == "boss-explode" then
    actor.activity = "boss-explode"
    actor.bossPhase = "supertank-explode"
    actor.info.nextFrame = 0
    actor.nextThink = context.time + gaiconstants.FRAMETIME
    return true
  end if
  if plan.terminalKind == "explode" then
    gaiExplosionResult = gaideatheffects.emitExplosion(actor, actor.edict.state.origin, 0, context)
    if gaiExplosionResult is error then return gaiExplosionResult end if
    actor.edict.inUse = false
    actor.activity = plan.terminalKind
    actor.nextThink = 0.0
    return true
  end if
  if plan.terminalKind == "gib" then
    actor.edict.inUse = false
    actor.activity = plan.terminalKind
    actor.nextThink = 0.0
    return true
  end if
  actor.moveType = gaiconstants.MOVETYPE_TOSS
  actor.activity = "corpse"
  actor.nextThink = 0.0
  gaiCorpseResult = gaideatheffects.applyCorpse(actor, context)
  if gaiCorpseResult is error then return gaiCorpseResult end if
  if actor.className == "monster_infantry" or actor.className == "monster_mutant" then
    M_FlyCheck(actor, context)
  end if
  if plan.terminalKind == "jorg" then actor.bossPhase = "jorg-complete" end if
  return true
end function

function AdvanceBossExplosion(actor, context)
  stage = actor.info.nextFrame
  if stage < 0 then stage = 0 end if
  if stage < 8 then
    gaideathExplosionOriginHolder = gaideatheffects.supertankExplosionOrigin(actor, stage)
    gaiBossExplosionResult = gaideatheffects.emitExplosion(actor, gaideathExplosionOriginHolder, stage, context)
    if gaiBossExplosionResult is error then return gaiBossExplosionResult end if
    actor.info.nextFrame = stage + 1
    actor.nextThink = context.time + gaiconstants.FRAMETIME
    return true
  end if
  gaiBossGibResult = gaideatheffects.emitSupertankFinalGibs(actor, context)
  if gaiBossGibResult is error then return gaiBossGibResult end if
  actor.edict.inUse = false
  actor.activity = "gib"
  actor.bossPhase = "supertank-complete"
  if actor.className == "monster_boss2" then actor.bossPhase = "boss2-complete"
  else if actor.className == "monster_jorg" then actor.bossPhase = "jorg-complete" end if
  actor.nextThink = 0.0
  return true
end function

function BeginBossExplosion(actor, context)
  actor.activity = "boss-explode"
  actor.bossPhase = "supertank-explode"
  if actor.className == "monster_boss2" then actor.bossPhase = "boss2-explode"
  else if actor.className == "monster_jorg" then actor.bossPhase = "jorg-explode" end if
  actor.info.nextFrame = 0
  return AdvanceBossExplosion(actor, context)
end function

function AdvanceReaction(actor, plan, context)
  if context.time + 0.00001 < actor.info.pauseTime then return false end if
  timelineOffset = actor.info.nextFrame
  duration = gaireactions.durationFrames(plan)
  if timelineOffset < 0 then timelineOffset = 0 end if
  if timelineOffset >= duration then return FinishReaction(actor, plan, context) end if
  actor.edict.state.frame = gaireactions.modelFrameAt(plan, timelineOffset)
  gaicore.ai_move(actor,
    gaireactions.movementDistanceAt(plan, timelineOffset) * actor.info.scale,
    context)
  gaiReactionAdvanceCallbackResult = RunReactionFrameCallbacks(
    actor, plan, timelineOffset, context)
  if gaiReactionAdvanceCallbackResult is error then return gaiReactionAdvanceCallbackResult end if
  if (actor.info.aiFlags & gaiconstants.AI_HOLD_FRAME) != 0 then
    actor.info.pauseTime = actor.info.pauseTime + gaiconstants.FRAMETIME
    actor.nextThink = context.time + gaiconstants.FRAMETIME
    return true
  end if
  if plan.terminalKind == "jorg" and timelineOffset == duration - 2 and not actor.successorSpawned then
    actor.successorDueTime = context.time
    ContinueBossDeath(actor, context)
  end if
  if gaireactions.startsBossExplosionAt(plan, timelineOffset) then
    return BeginBossExplosion(actor, context)
  end if
  actor.info.nextFrame = timelineOffset + 1
  actor.info.pauseTime = actor.info.pauseTime + gaiconstants.FRAMETIME
  actor.nextThink = context.time + gaiconstants.FRAMETIME
  return true
end function

function inline IsLocomotionActivity(activity)
  return activity == "started" or activity == "stand" or activity == "idle" or
    activity == "search" or activity == "walk" or activity == "run" or activity == "sight"
end function

function M_EndFrame(actor, context)
  if actor.edict.linkCount != actor.info.linkCount then
    actor.info.linkCount = actor.edict.linkCount
    if typeof(context.moveTrace) == "function" then gaimove.M_CheckGround(actor, context) end if
  end if
  // The live engine always installs pointContents. Narrow plan-only unit
  // contexts deliberately omit collision callbacks.
  if typeof(context.pointContents) == "function" then gaimove.M_CategorizePosition(actor, context) end if
  M_WorldEffects(actor, context)
  M_SetEffects(actor, context)
  return true
end function

function MonsterThink(actor, context)
  if actor.thinkKind == "triggered-spawn" then
    return MonsterTriggeredSpawn(actor, context)
  end if
  if actor.thinkKind == "flies-on" then return M_FliesOn(actor, context) end if
  if actor.thinkKind == "flies-off" then return M_FliesOff(actor, context) end if
  if gaimonsterprops.isProp(actor) then return gaimonsterprops.Think(actor, context) end if
  if actor.activity == "boss-explode" then return AdvanceBossExplosion(actor, context) end if
  reactionPlan = gaireactions.planByName(actor.className, actor.activity)
  if reactionPlan is not void then
    reactionResult = AdvanceReaction(actor, reactionPlan, context)
    if actor.edict.inUse then M_EndFrame(actor, context) end if
    return reactionResult
  end if
  if actor.bossPhase == "jorg-death" then return ContinueBossDeath(actor, context) end if
  // misc_insane owns real post-mortem moves whose end callback shrinks the
  // corpse bounds. Other generic actors have no managed death animation.
  if actor.health <= 0 and actor.className != "misc_insane" then actor.nextThink = 0.0; return false end if
  // Stock attack timelines are projected by the integrated combat layer. Do
  // not advance the prior run move underneath them: the original game swaps
  // currentmove to an attack table and therefore never gains a hidden run
  // distance while firing.
  if actor.className == "misc_insane" or IsLocomotionActivity(actor.activity) then M_MoveFrame(actor, context)
  else actor.nextThink = context.time + gaiconstants.FRAMETIME end if
  M_EndFrame(actor, context)
  actor.thinkKind = "monster-think"
  return true
end function

function MonsterUse(actor, other, activator, context)
  if gaimonsterprops.isProp(actor) then return gaimonsterprops.Use(actor, other, activator, context) end if
  if actor.enemy is not void or actor.health <= 0 then return false end if
  if activator is void or (activator.flags & gaiconstants.FL_NOTARGET) != 0 then return false end if
  if activator.isClient != true and (activator.info.aiFlags & gaiconstants.AI_GOOD_GUY) == 0 then return false end if
  actor.enemy = activator
  gaicore.FoundTarget(actor, context)
  return true
end function

function MonsterDeathUse(actor, context)
  if actor.className == "misc_insane" and (actor.spawnFlags & gaiconstants.INSANE_CRUCIFIED) != 0 then
    actor.flags = (actor.flags & ~gaiconstants.FL_SWIM) | gaiconstants.FL_FLY
  else
    actor.flags = actor.flags & ~(gaiconstants.FL_FLY | gaiconstants.FL_SWIM)
  end if
  actor.info.aiFlags = actor.info.aiFlags & gaiconstants.AI_GOOD_GUY
  if actor.item is not void then
    if typeof(context.dropItem) == "function" then context.dropItem(actor, actor.item) end if
    actor.item = void
  end if
  if actor.deathTarget != "" then actor.target = actor.deathTarget end if
  if actor.target == "" then return false end if
  if typeof(context.useTargets) != "function" then return error(9652, "MonsterDeathUse: useTargets callback missing") end if
  context.useTargets(actor, actor.enemy)
  return true
end function

function MonsterStart(actor, context)
  if gaimonsterprops.isProp(actor) then return gaimonsterprops.Start(actor, context) end if
  if context.deathmatch then actor.edict.inUse = false; actor.activity = "inhibited-deathmatch"; return false end if
  if (actor.spawnFlags & gaiconstants.SPAWNFLAG_SIGHT) != 0 and (actor.info.aiFlags & gaiconstants.AI_GOOD_GUY) == 0 then
    actor.spawnFlags = (actor.spawnFlags & ~gaiconstants.SPAWNFLAG_SIGHT) | gaiconstants.SPAWNFLAG_AMBUSH
  end if
  actor.nextThink = context.time + gaiconstants.FRAMETIME
  actor.edict.serverFlags = actor.edict.serverFlags | gconstants.SVF_MONSTER
  actor.edict.state.renderFx = actor.edict.state.renderFx | gconstants.RF_FRAMELERP
  actor.takeDamage = 2
  actor.airFinished = context.time + 12.0
  actor.maxHealth = actor.health
  actor.edict.clipMask = qconstants.MASK_MONSTERSOLID
  actor.deadFlag = gaiconstants.DEAD_NO
  actor.edict.serverFlags = actor.edict.serverFlags & ~gconstants.SVF_DEADMONSTER
  if typeof(actor.info.checkAttack) != "function" then actor.info.checkAttack = DefaultCheckAttack end if
  // Both vectors are managed immutable-at-spawn values here; movement code
  // replaces neither before the first think, so retaining the rooted vector is
  // equivalent to VectorCopy for this lifecycle boundary.
  actor.edict.state.oldOrigin = actor.edict.state.origin
  if actor.info.currentMove is not void then
    frameCount = actor.info.currentMove.lastFrame - actor.info.currentMove.firstFrame + 1
    frameOffset = context.randomFrame % frameCount
    actor.edict.state.frame = actor.info.currentMove.firstFrame + frameOffset
  end if
  actor.activity = "started"
  return true
end function

function NormalizeCombatTarget(actor, context)
  if actor.target != "" and typeof(context.findTargets) == "function" then
    targets = context.findTargets(actor.target)
    fixup = false
    notCombat = false
    for each target in targets
      if target.className == "point_combat" then
        actor.combatTarget = actor.target
        fixup = true
      else notCombat = true end if
    end for
    if notCombat and actor.combatTarget != "" and typeof(context.log) == "function" then
      context.log(actor.className + " has target with mixed types")
    end if
    if fixup then actor.target = "" end if
  end if
  if actor.combatTarget != "" and typeof(context.findTargets) == "function" then
    combatTargets = context.findTargets(actor.combatTarget)
    for each combatTarget in combatTargets
      if combatTarget.className != "point_combat" and typeof(context.log) == "function" then
        context.log(actor.className + " has a bad combattarget " +
          actor.combatTarget + ": " + combatTarget.className)
      end if
    end for
  end if
  return true
end function

function MonsterStartGo(actor, context)
  if gaimonsterprops.isProp(actor) then return gaimonsterprops.StartGo(actor, context) end if
  if actor.health <= 0 then return false end if
  NormalizeCombatTarget(actor, context)
  if actor.target != "" and typeof(context.pickTarget) == "function" then
    destination = context.pickTarget(actor.target)
    if destination is not void and destination.className == "path_corner" then
      actor.goalEntity = destination
      actor.moveTarget = destination
      actor.idealYaw = gaicore.vectorToYaw(gaicore.directionTo(actor, destination))
      gaicore.setActorYaw(actor, actor.idealYaw)
      if typeof(actor.info.walk) == "function" then actor.info.walk(actor, context) end if
      actor.target = ""
    else
      actor.goalEntity = void
      actor.moveTarget = void
      actor.info.pauseTime = 100000000.0
      if typeof(actor.info.stand) == "function" then actor.info.stand(actor, context) end if
    end if
  else
    actor.info.pauseTime = 100000000.0
    if typeof(actor.info.stand) == "function" then actor.info.stand(actor, context) end if
  end if
  actor.thinkKind = "monster-think"
  actor.nextThink = context.time + gaiconstants.FRAMETIME
  return true
end function

function MonsterTriggeredStart(actor, context)
  actor.edict.solid = gconstants.SOLID_NOT
  actor.moveType = gaiconstants.MOVETYPE_NONE
  actor.edict.serverFlags = actor.edict.serverFlags | gconstants.SVF_NOCLIENT
  actor.nextThink = 0.0
  actor.thinkKind = "triggered-wait"
  return true
end function

function MonsterTriggeredSpawnUse(actor, other, activator, context)
  actor.thinkKind = "triggered-spawn"
  actor.nextThink = context.time + gaiconstants.FRAMETIME
  if activator is not void and activator.isClient == true then actor.enemy = activator end if
  return true
end function

function MonsterTriggeredSpawn(actor, context)
  actor.edict.state.origin.z = actor.edict.state.origin.z + 1.0
  if typeof(context.killBox) == "function" then
    killResult = context.killBox(actor)
    if killResult is error then return killResult end if
  end if
  actor.edict.solid = gconstants.SOLID_BBOX
  actor.moveType = gaiconstants.MOVETYPE_STEP
  actor.edict.serverFlags = actor.edict.serverFlags & ~gconstants.SVF_NOCLIENT
  actor.airFinished = context.time + 12.0
  if typeof(context.linkActor) == "function" then context.linkActor(actor) end if
  MonsterStartGo(actor, context)
  if actor.enemy is not void and
      (actor.spawnFlags & gaiconstants.SPAWNFLAG_AMBUSH) == 0 and
      (actor.enemy.flags & gaiconstants.FL_NOTARGET) == 0 then
    gaicore.FoundTarget(actor, context)
  else actor.enemy = void end if
  return true
end function

function MonsterTargetUse(actor, other, activator, context)
  if actor.thinkKind == "triggered-wait" then
    return MonsterTriggeredSpawnUse(actor, other, activator, context)
  end if
  return MonsterUse(actor, other, activator, context)
end function

function WalkMonsterStart(actor, context)
  if not MonsterStart(actor, context) then return false end if
  if actor.yawSpeed == 0.0 then actor.yawSpeed = 20.0 end if
  actor.viewHeight = 25.0
  result = MonsterStartGo(actor, context)
  if result and (actor.spawnFlags & gaiconstants.SPAWNFLAG_TRIGGER_SPAWN) != 0 then
    MonsterTriggeredStart(actor, context)
  end if
  return result
end function

function FlyMonsterStart(actor, context)
  actor.flags = actor.flags | gaiconstants.FL_FLY
  if not MonsterStart(actor, context) then return false end if
  if actor.yawSpeed == 0.0 then actor.yawSpeed = 10.0 end if
  actor.viewHeight = 25.0
  result = MonsterStartGo(actor, context)
  if result and (actor.spawnFlags & gaiconstants.SPAWNFLAG_TRIGGER_SPAWN) != 0 then
    MonsterTriggeredStart(actor, context)
  end if
  return result
end function

function SwimMonsterStart(actor, context)
  actor.flags = actor.flags | gaiconstants.FL_SWIM
  if not MonsterStart(actor, context) then return false end if
  if actor.yawSpeed == 0.0 then actor.yawSpeed = 10.0 end if
  actor.viewHeight = 10.0
  result = MonsterStartGo(actor, context)
  if result and (actor.spawnFlags & gaiconstants.SPAWNFLAG_TRIGGER_SPAWN) != 0 then
    MonsterTriggeredStart(actor, context)
  end if
  return result
end function

function DispatchPain(actor, attacker, damage, context)
  if gaimonsterprops.isProp(actor) then actor.health = actor.maxHealth; return false end if
  if actor.health <= 0 then return false end if
  if typeof(actor.pain) != "function" or context.time < actor.reactionDebounce then return false end if
  nextPainCount = actor.painCount + 1
  plan = gaireactions.selectPainPlan(actor.className, actor.edict.state.number,
    nextPainCount, damage, context.skill)
  result = actor.pain(actor, attacker, damage, context)
  actor.reactionDebounce = context.time + 3.0
  if plan is not void then StartReaction(actor, plan, context) end if
  return result
end function

function DispatchDie(actor, attacker, damage, context)
  if gaimonsterprops.isProp(actor) then actor.health = actor.maxHealth; return false end if
  if actor.deathUseComplete then return false end if
  if typeof(actor.die) != "function" then return false end if
  result = actor.die(actor, attacker, damage, context)
  plan = gaireactions.selectDeathPlan(actor.className, actor.edict.state.number,
    actor.dieCount, actor.health <= actor.gibHealth)
  if plan is not void then
    StartReaction(actor, plan, context)
    if plan.terminalKind == "gib" then
      gaiGibResult = gaideatheffects.emitMonsterGibs(actor, damage, context)
      if gaiGibResult is error then return gaiGibResult end if
    end if
  end if
  MonsterDeathUse(actor, context)
  actor.deathUseComplete = true
  // Jorg's BSP target is a two-count trigger_counter.  The original death
  // animation tosses Makron, which inherits that same target; only Makron's
  // later death completes the counter and opens the campaign exit.
  if actor.className == "monster_jorg" then
    actor.bossPhase = "jorg-death"
    actor.successorClassName = "monster_makron"
    actor.successorDueTime = context.time + 4.9
    actor.successorSpawned = false
    if plan is void then actor.activity = "jorg-death-staging"; actor.nextThink = actor.successorDueTime end if
  else if actor.className == "monster_makron" then
    actor.bossPhase = "makron-complete"
  end if
  return result
end function
