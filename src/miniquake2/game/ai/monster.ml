/* Callback-driven port of g_monster.c frame and lifecycle machinery. */
package miniquake2.game.ai.monster

import miniquake2.game.ai.constants as gaiconstants
import miniquake2.game.ai.core as gaicore
import miniquake2.game.ai.reaction_sequences as gaireactions
import miniquake2.game.ai.death_effects as gaideatheffects
import miniquake2.game.ai.locomotion_sequences as gailocomotion
import miniquake2.game.ai.sounds as gaisounds
import miniquake2.game.ai.props as gaimonsterprops
import miniquake2.game.constants as gconstants
import miniquake2.qcommon.constants as qconstants
import miniquake2.qcommon.types as gaiqtypes

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
  if className == "monster_flyer" then return "flyer/flysrch1.wav" end if
  if className == "monster_mutant" then return "mutant/mutidle1.wav" end if
  if className == "monster_jorg" then return "boss3/bs3idle1.wav" end if
  return ""
end function

function StockFidgetFrameSound(actor, context)
  return EmitStockSound(actor, context, StockIdleSoundName(actor.className),
    gconstants.CHAN_VOICE, gconstants.ATTN_IDLE)
end function

function StockScratchSound(actor, context)
  return EmitStockSound(actor, context, "parasite/paridle2.wav",
    gconstants.CHAN_WEAPON, gconstants.ATTN_IDLE)
end function

function StockSoldierCockSound(actor, context)
  return EmitStockSound(actor, context, "infantry/infatck3.wav",
    gconstants.CHAN_WEAPON, gconstants.ATTN_IDLE)
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
  else if moveName == "parasite-fidget-loop" then
    move.frames[0].thinkFunction = StockScratchSound
    move.frames[3].thinkFunction = StockScratchSound
  else if moveName == "parasite-fidget-end" then move.frames[0].thinkFunction = StockScratchSound
  else if moveName == "mutant-stand-fidget" then move.frames[6].thinkFunction = StockMutantIdleLoop
  else if moveName == "tank-walk" or moveName == "tank-run" then
    move.frames[7].thinkFunction = StockStepSound
    move.frames[15].thinkFunction = StockStepSound
  else if moveName == "supertank-walk" or moveName == "supertank-run" then move.frames[0].thinkFunction = StockStepSound
  else if moveName == "mutant-run" then
    move.frames[1].thinkFunction = StockStepSound
    move.frames[3].thinkFunction = StockStepSound
  else if moveName == "jorg-run" then
    move.frames[0].thinkFunction = StockStepSound
    move.frames[7].thinkFunction = StockStepSound
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
  if threshold < 0.0 or context.randomIdle > threshold then return false end if
  actor.activity = "idle"
  SetStockMove(actor, "stand-fidget", StateStand)
  if actor.className == "monster_berserk" then StockFidgetFrameSound(actor, context) end if
  return true
end function

function StockMutantIdleLoop(actor, context)
  if context.randomIdle < 0.75 then actor.info.nextFrame = 116 end if
  return true
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
  if context.randomIdle <= 0.8 then return SetStockMove(actor, "fidget-loop", FinishParasiteFidgetLoop) end if
  return SetStockMove(actor, "fidget-end", StateStand)
end function

function StateStand(actor, context)
  actor.activity = "stand"
  if not gailocomotion.hasStockMoves(actor.className) then return true end if
  currentName = CurrentMoveName(actor)
  if actor.className == "monster_soldier_light" or actor.className == "monster_soldier" or actor.className == "monster_soldier_ss" then
    if currentName == "soldier-stand-fidget" or context.randomIdle < 0.8 then return SetStockMove(actor, "stand", StateStand) end if
    return SetStockMove(actor, "stand-fidget", StateStand)
  end if
  if actor.className == "monster_floater" and context.randomIdle > 0.5 then return SetStockMove(actor, "stand2", void) end if
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
  return true
end function

function StateWalk(actor, context)
  actor.activity = "walk"
  if not gailocomotion.hasStockMoves(actor.className) then return true end if
  if actor.className == "monster_mutant" or actor.className == "monster_parasite" then
    return SetStockMove(actor, "walk-start", FinishWalkStart)
  end if
  if actor.className == "monster_soldier_light" or actor.className == "monster_soldier" or actor.className == "monster_soldier_ss" then
    if context.randomIdle >= 0.5 then return SetStockMove(actor, "soldier-walk2", void) end if
  end if
  return SetStockMove(actor, "walk", void)
end function

function StateRun(actor, context)
  if (actor.info.aiFlags & gaiconstants.AI_STAND_GROUND) != 0 then return StateStand(actor, context) end if
  actor.activity = "run"
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
  actor.activity = "dead"
  actor.dieCount = actor.dieCount + 1
  actor.deadFlag = gaiconstants.DEAD_DEAD
  actor.edict.serverFlags = actor.edict.serverFlags | gconstants.SVF_DEADMONSTER
  return true
end function

function DefaultCheckAttack(actor, context, enemyRange)
  return gaicore.M_CheckAttack(actor, context, enemyRange)
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
  if actor.className == "monster_mutant" then actor.info.checkAttack = MutantCheckAttack end if
  actor.pain = StatePain
  actor.die = StateDie
  return actor
end function

function M_SetEffects(actor, context)
  actor.edict.state.effects = actor.edict.state.effects & ~(gconstants.EF_COLOR_SHELL | gconstants.EF_POWERSCREEN)
  actor.edict.state.renderFx = actor.edict.state.renderFx & ~(gconstants.RF_SHELL_RED | gconstants.RF_SHELL_GREEN | gconstants.RF_SHELL_BLUE)
  if (actor.info.aiFlags & gaiconstants.AI_RESURRECTING) != 0 then
    actor.edict.state.effects = actor.edict.state.effects | gconstants.EF_COLOR_SHELL
    actor.edict.state.renderFx = actor.edict.state.renderFx | gconstants.RF_SHELL_RED
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

function StartReaction(actor, plan, context)
  gaireactions.validatePlan(plan)
  actor.activity = plan.name
  // The first pose becomes visible in the damage frame itself. The next
  // scheduled think therefore advances to offset one without duplicating it.
  actor.info.nextFrame = 1
  actor.info.pauseTime = context.time + gaiconstants.FRAMETIME
  actor.edict.state.frame = plan.firstFrame
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
  actor.nextThink = 0.0
  return true
end function

function AdvanceReaction(actor, plan, context)
  if context.time + 0.00001 < actor.info.pauseTime then return false end if
  timelineOffset = actor.info.nextFrame
  duration = gaireactions.durationFrames(plan)
  if timelineOffset < 0 then timelineOffset = 0 end if
  if timelineOffset >= duration then return FinishReaction(actor, plan, context) end if
  actor.edict.state.frame = gaireactions.modelFrameAt(plan, timelineOffset)
  if plan.terminalKind == "jorg" and timelineOffset == duration - 2 and not actor.successorSpawned then
    actor.successorDueTime = context.time
    ContinueBossDeath(actor, context)
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

function MonsterThink(actor, context)
  if gaimonsterprops.isProp(actor) then return gaimonsterprops.Think(actor, context) end if
  if actor.activity == "boss-explode" then return AdvanceBossExplosion(actor, context) end if
  reactionPlan = gaireactions.planByName(actor.className, actor.activity)
  if reactionPlan is not void then return AdvanceReaction(actor, reactionPlan, context) end if
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
  actor.info.linkCount = actor.edict.linkCount
  M_SetEffects(actor, context)
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

function MonsterStartGo(actor, context)
  if gaimonsterprops.isProp(actor) then return gaimonsterprops.StartGo(actor, context) end if
  if actor.health <= 0 then return false end if
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
  if (actor.spawnFlags & gaiconstants.SPAWNFLAG_TRIGGER_SPAWN) != 0 then
    actor.edict.solid = gconstants.SOLID_NOT
    actor.moveType = gaiconstants.MOVETYPE_NONE
    actor.edict.serverFlags = actor.edict.serverFlags | gconstants.SVF_NOCLIENT
    actor.nextThink = 0.0
    actor.thinkKind = "triggered-wait"
  end if
  return true
end function

function WalkMonsterStart(actor, context)
  if not MonsterStart(actor, context) then return false end if
  if actor.yawSpeed == 0.0 then actor.yawSpeed = 20.0 end if
  actor.viewHeight = 25.0
  return MonsterStartGo(actor, context)
end function

function FlyMonsterStart(actor, context)
  actor.flags = actor.flags | gaiconstants.FL_FLY
  if not MonsterStart(actor, context) then return false end if
  if actor.yawSpeed == 0.0 then actor.yawSpeed = 10.0 end if
  actor.viewHeight = 25.0
  return MonsterStartGo(actor, context)
end function

function SwimMonsterStart(actor, context)
  actor.flags = actor.flags | gaiconstants.FL_SWIM
  if not MonsterStart(actor, context) then return false end if
  if actor.yawSpeed == 0.0 then actor.yawSpeed = 10.0 end if
  actor.viewHeight = 10.0
  return MonsterStartGo(actor, context)
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
