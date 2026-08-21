/* Callback-driven port of g_monster.c frame and lifecycle machinery. */
package miniquake2.game.ai.monster

import miniquake2.game.ai.constants as gaiconstants
import miniquake2.game.ai.core as gaicore
import miniquake2.game.constants as gconstants
import miniquake2.qcommon.constants as qconstants

function StateStand(actor, context)
  actor.activity = "stand"
  return true
end function

function StateIdle(actor, context)
  actor.activity = "idle"
  return true
end function

function StateSearch(actor, context)
  actor.activity = "search"
  return true
end function

function StateWalk(actor, context)
  actor.activity = "walk"
  return true
end function

function StateRun(actor, context)
  actor.activity = "run"
  return true
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

function installDefaultCallbacks(actor, hasAttack, hasMelee)
  actor.info.stand = StateStand
  actor.info.idle = StateIdle
  actor.info.search = StateSearch
  actor.info.walk = StateWalk
  actor.info.run = StateRun
  if hasAttack then actor.info.attack = StateAttack else actor.info.attack = void end if
  if hasMelee then actor.info.melee = StateMelee else actor.info.melee = void end if
  actor.info.sight = StateSight
  actor.info.checkAttack = DefaultCheckAttack
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
  actor.bossPhase = "jorg-complete"
  actor.activity = "jorg-death-complete"
  actor.nextThink = 0.0
  successor = context.spawnMonster(actor.successorClassName, actor)
  if successor is void then return error(9654, "Jorg death continuation did not create Makron") end if
  successor.bossPhase = "makron-active"
  successor.target = actor.target
  successor.enemy = actor.enemy
  return true
end function

function MonsterThink(actor, context)
  if actor.bossPhase == "jorg-death" then
    ContinueBossDeath(actor, context)
    return true
  end if
  // misc_insane owns real post-mortem moves whose end callback shrinks the
  // corpse bounds. Other generic actors have no managed death animation.
  if actor.health <= 0 and actor.className != "misc_insane" then actor.nextThink = 0.0; return false end if
  M_MoveFrame(actor, context)
  actor.info.linkCount = actor.edict.linkCount
  M_SetEffects(actor, context)
  actor.thinkKind = "monster-think"
  return true
end function

function MonsterUse(actor, other, activator, context)
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
  if actor.health <= 0 then return false end if
  if typeof(actor.pain) != "function" then return false end if
  return actor.pain(actor, attacker, damage, context)
end function

function DispatchDie(actor, attacker, damage, context)
  if actor.deathUseComplete then return false end if
  if typeof(actor.die) != "function" then return false end if
  result = actor.die(actor, attacker, damage, context)
  MonsterDeathUse(actor, context)
  actor.deathUseComplete = true
  // Jorg's BSP target is a two-count trigger_counter.  The original death
  // animation tosses Makron, which inherits that same target; only Makron's
  // later death completes the counter and opens the campaign exit.
  if actor.className == "monster_jorg" then
    actor.bossPhase = "jorg-death"
    actor.successorClassName = "monster_makron"
    actor.successorDueTime = context.time + 0.8
    actor.successorSpawned = false
    actor.activity = "jorg-death-staging"
    actor.nextThink = actor.successorDueTime
  else if actor.className == "monster_makron" then
    actor.bossPhase = "makron-complete"
  end if
  return result
end function
