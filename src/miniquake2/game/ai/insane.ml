/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Classic 3.19 misc_insane state machine from m_insane.c. */
package miniquake2.game.ai.insane

import miniquake2.game.ai.constants as insaneconstants
import miniquake2.game.ai.core as insanecore
import miniquake2.game.ai.types as insanetypes
import miniquake2.game.constants as insanegameconstants
import miniquake2.qcommon.types as insaneqtypes

// Emit insane.
function insaneEmit(actor, context, soundName)
  if typeof(context.playSound) == "function" then
    context.playSound(actor, soundName, insanegameconstants.CHAN_VOICE, insanegameconstants.ATTN_IDLE)
  end if
  return soundName
end function

// Return the insane fist value.
function insaneFist(actor, context)
  insaneEmit(actor, context, "insane/insane11.wav")
end function

// Return the insane shake value.
function insaneShake(actor, context)
  insaneEmit(actor, context, "insane/insane5.wav")
end function

// Return the insane moan value.
function insaneMoan(actor, context)
  insaneEmit(actor, context, "insane/insane7.wav")
end function

// Return the insane scream value.
function insaneScream(actor, context)
  insaneScreams = [
    "insane/insane1.wav", "insane/insane2.wav", "insane/insane3.wav", "insane/insane4.wav",
    "insane/insane6.wav", "insane/insane8.wav", "insane/insane9.wav", "insane/insane10.wav",
  ]
  insaneScreamIndex = context.randomFrame % 8
  insaneEmit(actor, context, insaneScreams[insaneScreamIndex])
end function

// Return the insane zeros value.
function insaneZeros(count)
  insaneZeroResult = []
  insaneZeroIndex = 0
  while insaneZeroIndex < count
    insaneZeroResult = insaneZeroResult + [0.0]
    insaneZeroIndex = insaneZeroIndex + 1
  end while
  return insaneZeroResult
end function

// Create insane move.
function insaneMakeMove(name, firstFrame, lastFrame, aiFunction, distances, endFunction)
  insaneMoveFrames = []
  insaneMoveCount = lastFrame - firstFrame + 1
  insaneMoveIndex = 0
  while insaneMoveIndex < insaneMoveCount
    insaneMoveDistance = 0.0
    if insaneMoveIndex < len(distances) then insaneMoveDistance = distances[insaneMoveIndex] end if
    insaneMoveFrames = insaneMoveFrames + [insanetypes.MonsterFrame(aiFunction, insaneMoveDistance, void)]
    insaneMoveIndex = insaneMoveIndex + 1
  end while
  return insanetypes.MonsterMove(name, firstFrame, lastFrame, insaneMoveFrames, endFunction)
end function

// Move insane stand normal.
function insaneStandNormalMove()
  insaneMove = insaneMakeMove("insane-stand-normal", 59, 64, insanecore.ai_stand, insaneZeros(6), insaneStand)
  insaneMove.frames[5].thinkFunction = insaneCheckDown
  return insaneMove
end function

// Move insane stand insane.
function insaneStandInsaneMove()
  insaneMove = insaneMakeMove("insane-stand-insane", 64, 93, insanecore.ai_stand, insaneZeros(30), insaneStand)
  insaneMove.frames[0].thinkFunction = insaneShake
  insaneMove.frames[29].thinkFunction = insaneCheckDown
  return insaneMove
end function

// Move insane up to down.
function insaneUpToDownMove()
  insaneDistances = insaneZeros(40)
  insaneDistances[20] = 2.7; insaneDistances[21] = 4.1; insaneDistances[22] = 6.0
  insaneDistances[23] = 7.6; insaneDistances[24] = 3.6
  insaneMove = insaneMakeMove("insane-up-to-down", 0, 39, insanecore.ai_move, insaneDistances, insaneOnGround)
  insaneMove.frames[7].thinkFunction = insaneMoan
  insaneMove.frames[27].thinkFunction = insaneFist; insaneMove.frames[33].thinkFunction = insaneFist
  return insaneMove
end function

// Move insane down to up.
function insaneDownToUpMove()
  insaneDistances = [-0.7, -1.2, -1.5, -4.5, -3.5, -0.2, 0.0, -1.3, -3.0, -2.0,
    0.0, 0.0, 0.0, -3.3, -1.6, -0.3, 0.0, 0.0, 0.0]
  return insaneMakeMove("insane-down-to-up", 40, 58, insanecore.ai_move, insaneDistances, insaneStand)
end function

// Move insane jump down.
function insaneJumpDownMove()
  return insaneMakeMove("insane-jump-down", 95, 99, insanecore.ai_move, [0.2, 11.5, 5.1, 7.1, 0.0], insaneOnGround)
end function

// Move insane down.
function insaneDownMove()
  insaneDistances = insaneZeros(61)
  insaneDistances[11] = -1.7; insaneDistances[12] = -1.6
  insaneDistances[51] = 0.5; insaneDistances[53] = -0.2; insaneDistances[55] = 0.2
  insaneDistances[56] = 0.4; insaneDistances[57] = 0.6; insaneDistances[58] = 0.8; insaneDistances[59] = 0.7
  insaneMove = insaneMakeMove("insane-down", 99, 159, insanecore.ai_move, insaneDistances, insaneOnGround)
  insaneMove.frames[16].thinkFunction = insaneFist
  insaneMove.frames[33].thinkFunction = insaneMoan
  insaneMove.frames[53].thinkFunction = insaneScream
  insaneMove.frames[60].thinkFunction = insaneCheckUp
  return insaneMove
end function

// Move insane walk normal.
function insaneWalkNormalMove(runMove)
  insaneName = "insane-walk-normal"
  if runMove then insaneName = "insane-run-normal" end if
  insaneMove = insaneMakeMove(insaneName, 160, 172, insanecore.ai_walk,
    [0.0, 2.5, 3.5, 1.7, 2.3, 2.4, 2.2, 4.2, 5.6, 3.3, 2.4, 0.9, 0.0], insaneWalk)
  if runMove then insaneMove.endFunction = insaneRun end if
  insaneMove.frames[0].thinkFunction = insaneScream
  return insaneMove
end function

// Move insane walk insane.
function insaneWalkInsaneMove(runMove)
  insaneName = "insane-walk-insane"
  if runMove then insaneName = "insane-run-insane" end if
  insaneMove = insaneMakeMove(insaneName, 173, 198, insanecore.ai_walk,
    [0.0, 3.4, 3.6, 2.9, 2.2, 2.6, 0.0, 0.7, 4.8, 5.3, 1.1, 2.0, 0.5,
      0.0, 0.0, 4.9, 6.7, 3.8, 2.0, 0.2, 0.0, 3.4, 6.4, 5.0, 1.8, 0.0], insaneWalk)
  if runMove then insaneMove.endFunction = insaneRun end if
  insaneMove.frames[0].thinkFunction = insaneScream
  return insaneMove
end function

// Handle insane stand move.
function insaneStandPainMove()
  return insaneMakeMove("insane-stand-pain", 199, 209, insanecore.ai_move, insaneZeros(11), insaneRun)
end function

// Move insane stand death.
function insaneStandDeathMove()
  return insaneMakeMove("insane-stand-death", 210, 226, insanecore.ai_move, insaneZeros(17), insaneDead)
end function

// Move insane crawl.
function insaneCrawlMove(runMove)
  insaneName = "insane-crawl"
  if runMove then insaneName = "insane-run-crawl" end if
  insaneMove = insaneMakeMove(insaneName, 227, 235, insanecore.ai_walk,
    [0.0, 1.5, 2.1, 3.6, 2.0, 0.9, 3.0, 3.4, 2.4], void)
  insaneMove.frames[0].thinkFunction = insaneScream
  return insaneMove
end function

// Handle insane crawl move.
function insaneCrawlPainMove()
  return insaneMakeMove("insane-crawl-pain", 236, 244, insanecore.ai_move, insaneZeros(9), insaneRun)
end function

// Move insane crawl death.
function insaneCrawlDeathMove()
  return insaneMakeMove("insane-crawl-death", 245, 251, insanecore.ai_move, insaneZeros(7), insaneDead)
end function

// Compute insane move.
function insaneCrossMove(struggle)
  insaneName = "insane-cross"
  insaneFirst = 252; insaneLast = 266; insaneSound = insaneMoan
  if struggle then insaneName = "insane-cross-struggle"; insaneFirst = 267; insaneLast = 281; insaneSound = insaneScream end if
  insaneMove = insaneMakeMove(insaneName, insaneFirst, insaneLast, insanecore.ai_move, insaneZeros(15), insaneCross)
  insaneMove.frames[0].thinkFunction = insaneSound
  return insaneMove
end function

// Set insane move.
function insaneSetMove(actor, move)
  actor.info.currentMove = move
  actor.activity = move.name
  actor.thinkKind = "monster-think"
  return move
end function

// Apply insane spawn flags.
function insaneApplySpawnFlags(actor)
  if (actor.spawnFlags & insaneconstants.INSANE_STAND_GROUND) != 0 then
    actor.info.aiFlags = actor.info.aiFlags | insaneconstants.AI_STAND_GROUND
  end if
  if (actor.spawnFlags & insaneconstants.INSANE_CRUCIFIED) != 0 then
    actor.mins = [-16.0, 0.0, 0.0]; actor.maxs = [16.0, 8.0, 32.0]
    actor.edict.mins = insaneqtypes.Vec3(-16.0, 0.0, 0.0); actor.edict.maxs = insaneqtypes.Vec3(16.0, 8.0, 32.0)
    actor.flags = actor.flags | insaneconstants.FL_NO_KNOCKBACK | insaneconstants.FL_FLY
  else
    actor.mins = [-16.0, -16.0, -24.0]; actor.maxs = [16.0, 16.0, 32.0]
    actor.edict.mins = insaneqtypes.Vec3(-16.0, -16.0, -24.0); actor.edict.maxs = insaneqtypes.Vec3(16.0, 16.0, 32.0)
  end if
  return true
end function

// Compute insane.
function insaneCross(actor, context)
  return insaneSetMove(actor, insaneCrossMove(context.randomIdle >= 0.8))
end function

// Return the insane walk value.
function insaneWalk(actor, context)
  if (actor.spawnFlags & insaneconstants.INSANE_STAND_GROUND) != 0 and actor.edict.state.frame == 244 then
    return insaneSetMove(actor, insaneDownMove())
  end if
  if (actor.spawnFlags & insaneconstants.INSANE_CRAWL) != 0 then return insaneSetMove(actor, insaneCrawlMove(false)) end if
  if context.randomIdle <= 0.5 then return insaneSetMove(actor, insaneWalkNormalMove(false)) end if
  return insaneSetMove(actor, insaneWalkInsaneMove(false))
end function

// Run insane.
function insaneRun(actor, context)
  if (actor.spawnFlags & insaneconstants.INSANE_STAND_GROUND) != 0 and actor.edict.state.frame == 244 then
    return insaneSetMove(actor, insaneDownMove())
  end if
  if (actor.spawnFlags & insaneconstants.INSANE_CRAWL) != 0 then return insaneSetMove(actor, insaneCrawlMove(true)) end if
  if context.randomIdle <= 0.5 then return insaneSetMove(actor, insaneWalkNormalMove(true)) end if
  return insaneSetMove(actor, insaneWalkInsaneMove(true))
end function

// Report whether insane on ground.
function insaneOnGround(actor, context)
  return insaneSetMove(actor, insaneDownMove())
end function

// Validate insane down.
function insaneCheckDown(actor, context)
  if (actor.spawnFlags & insaneconstants.INSANE_ALWAYS_STAND) != 0 then return false end if
  if context.randomIdle >= 0.3 then return false end if
  if context.randomDelay < 0.5 then insaneSetMove(actor, insaneUpToDownMove())
  else insaneSetMove(actor, insaneJumpDownMove()) end if
  return true
end function

// Validate insane up.
function insaneCheckUp(actor, context)
  if (actor.spawnFlags & insaneconstants.INSANE_CRAWL) != 0 and
      (actor.spawnFlags & insaneconstants.INSANE_STAND_GROUND) != 0 then return false end if
  if context.randomIdle < 0.5 then insaneSetMove(actor, insaneDownToUpMove()); return true end if
  return false
end function

// Return the insane stand value.
function insaneStand(actor, context)
  insaneApplySpawnFlags(actor)
  if (actor.spawnFlags & insaneconstants.INSANE_CRUCIFIED) != 0 then
    actor.info.aiFlags = actor.info.aiFlags | insaneconstants.AI_STAND_GROUND
    return insaneSetMove(actor, insaneCrossMove(false))
  end if
  if (actor.spawnFlags & insaneconstants.INSANE_CRAWL) != 0 and
      (actor.spawnFlags & insaneconstants.INSANE_STAND_GROUND) != 0 then
    return insaneSetMove(actor, insaneDownMove())
  end if
  if context.randomIdle < 0.5 then return insaneSetMove(actor, insaneStandNormalMove()) end if
  return insaneSetMove(actor, insaneStandInsaneMove())
end function

// Handle insane.
function insanePain(actor, attacker, damage, context)
  if context.time < actor.info.attackFinished then return false end if
  actor.info.attackFinished = context.time + 3.0
  actor.painCount = actor.painCount + 1
  insanePainLevel = 100
  if actor.health < 25 then insanePainLevel = 25
  else if actor.health < 50 then insanePainLevel = 50
  else if actor.health < 75 then insanePainLevel = 75 end if
  insanePainVariant = 1 + (context.randomFrame % 2)
  insaneEmit(actor, context, "player/male/pain" + insanePainLevel + "_" + insanePainVariant + ".wav")
  if context.skill == 3 then return true end if
  if (actor.spawnFlags & insaneconstants.INSANE_CRUCIFIED) != 0 then insaneSetMove(actor, insaneCrossMove(true)); return true end if
  insanePainFrame = actor.edict.state.frame
  if (insanePainFrame >= 227 and insanePainFrame <= 235) or (insanePainFrame >= 98 and insanePainFrame <= 159) then
    insaneSetMove(actor, insaneCrawlPainMove()); return true
  end if
  insaneSetMove(actor, insaneStandPainMove())
  return true
end function

// Return the insane dead value.
function insaneDead(actor, context)
  if (actor.spawnFlags & insaneconstants.INSANE_CRUCIFIED) != 0 then
    actor.flags = actor.flags | insaneconstants.FL_FLY
  else
    actor.mins = [-16.0, -16.0, -24.0]; actor.maxs = [16.0, 16.0, -8.0]
    actor.edict.mins = insaneqtypes.Vec3(-16.0, -16.0, -24.0); actor.edict.maxs = insaneqtypes.Vec3(16.0, 16.0, -8.0)
    actor.moveType = insaneconstants.MOVETYPE_TOSS
  end if
  actor.edict.serverFlags = actor.edict.serverFlags | insanegameconstants.SVF_DEADMONSTER
  actor.nextThink = 0.0
  actor.activity = "insane-dead"
  actor.thinkKind = "none"
  return true
end function

// Handle insane.
function insaneDie(actor, attacker, damage, context)
  if actor.health <= actor.gibHealth then
    insaneEmit(actor, context, "misc/udeath.wav")
    actor.deadFlag = insaneconstants.DEAD_DEAD
    actor.dieCount = actor.dieCount + 1
    actor.activity = "insane-gibbed"
    actor.edict.serverFlags = actor.edict.serverFlags | insanegameconstants.SVF_DEADMONSTER
    actor.nextThink = 0.0
    return true
  end if
  if actor.deadFlag == insaneconstants.DEAD_DEAD then return false end if
  insaneDeathVariant = 1 + (context.randomFrame % 4)
  insaneEmit(actor, context, "player/male/death" + insaneDeathVariant + ".wav")
  actor.deadFlag = insaneconstants.DEAD_DEAD
  actor.takeDamage = 1
  actor.dieCount = actor.dieCount + 1
  if (actor.spawnFlags & insaneconstants.INSANE_CRUCIFIED) != 0 then insaneDead(actor, context); return true end if
  insaneDeathFrame = actor.edict.state.frame
  if (insaneDeathFrame >= 227 and insaneDeathFrame <= 235) or (insaneDeathFrame >= 98 and insaneDeathFrame <= 159) then
    insaneSetMove(actor, insaneCrawlDeathMove()); return true
  end if
  insaneSetMove(actor, insaneStandDeathMove())
  return true
end function

// Configure state.
function configure(actor, context)
  actor.info.aiFlags = actor.info.aiFlags | insaneconstants.AI_GOOD_GUY
  actor.info.stand = insaneStand; actor.info.walk = insaneWalk; actor.info.run = insaneRun
  actor.info.dodge = void; actor.info.attack = void; actor.info.melee = void; actor.info.sight = void
  actor.pain = insanePain; actor.die = insaneDie
  insaneSetMove(actor, insaneStandNormalMove())
  insaneApplySpawnFlags(actor)
  actor.edict.state.skinNumber = context.randomFrame % 3
  return actor
end function

// Restore move.
function restoreMove(actor, moveName)
  if moveName == "insane-stand-normal" then actor.info.currentMove = insaneStandNormalMove()
  else if moveName == "insane-stand-insane" then actor.info.currentMove = insaneStandInsaneMove()
  else if moveName == "insane-up-to-down" then actor.info.currentMove = insaneUpToDownMove()
  else if moveName == "insane-down-to-up" then actor.info.currentMove = insaneDownToUpMove()
  else if moveName == "insane-jump-down" then actor.info.currentMove = insaneJumpDownMove()
  else if moveName == "insane-down" then actor.info.currentMove = insaneDownMove()
  else if moveName == "insane-walk-normal" then actor.info.currentMove = insaneWalkNormalMove(false)
  else if moveName == "insane-run-normal" then actor.info.currentMove = insaneWalkNormalMove(true)
  else if moveName == "insane-walk-insane" then actor.info.currentMove = insaneWalkInsaneMove(false)
  else if moveName == "insane-run-insane" then actor.info.currentMove = insaneWalkInsaneMove(true)
  else if moveName == "insane-stand-pain" then actor.info.currentMove = insaneStandPainMove()
  else if moveName == "insane-stand-death" then actor.info.currentMove = insaneStandDeathMove()
  else if moveName == "insane-crawl" then actor.info.currentMove = insaneCrawlMove(false)
  else if moveName == "insane-run-crawl" then actor.info.currentMove = insaneCrawlMove(true)
  else if moveName == "insane-crawl-pain" then actor.info.currentMove = insaneCrawlPainMove()
  else if moveName == "insane-crawl-death" then actor.info.currentMove = insaneCrawlDeathMove()
  else if moveName == "insane-cross" then actor.info.currentMove = insaneCrossMove(false)
  else if moveName == "insane-cross-struggle" then actor.info.currentMove = insaneCrossMove(true)
  else if moveName == "insane-dead" then insaneDead(actor, void)
  else if moveName == "insane-gibbed" then
    actor.edict.serverFlags = actor.edict.serverFlags | insanegameconstants.SVF_DEADMONSTER
    actor.nextThink = 0.0
  else return error(9645, "unknown misc_insane saved move " + moveName) end if
  actor.activity = moveName
  return actor
end function
