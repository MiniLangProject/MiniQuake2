/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Stock stand/idle/walk/run MD2 cycle inventory and integrated projection. */
import miniquake2.game.ai.locomotion_sequences as locomotionsequences
import miniquake2.game.ai.archetypes as locomotionarchetypes
import miniquake2.game.ai.monster as locomotionmonster
import miniquake2.game.ai.types as locomotiontypes
import miniquake2.game.constants as locomotiongameconstants
import miniquake2.qcommon.types as locomotionqtypes
import miniquake2.game.null_game as locomotiongame
import miniquake2.server.game_bridge as locomotionbridge

function locomotionAssert(value, message)
  if value != true then return error(9978, message) end if
  return true
end function

function locomotionNear(actual, expected, message)
  delta = actual - expected
  if delta < 0.0 then delta = -delta end if
  return locomotionAssert(delta < 0.001, message)
end function

function locomotionVisible(first, second)
  return true
end function

locomotionCallbackSoundNames = array(32)
locomotionCallbackSoundChannels = array(32)
locomotionCallbackSoundAttenuations = array(32)
locomotionCallbackSoundCount = 0
locomotionCallbackRolls = array(16)
locomotionCallbackRollCount = 0
locomotionCallbackRollPosition = 0

function locomotionCaptureCallbackSound(actor, soundName, channel, attenuation)
  global locomotionCallbackSoundCount
  locomotionCallbackSoundNames[locomotionCallbackSoundCount] = soundName
  locomotionCallbackSoundChannels[locomotionCallbackSoundCount] = channel
  locomotionCallbackSoundAttenuations[locomotionCallbackSoundCount] = attenuation
  locomotionCallbackSoundCount = locomotionCallbackSoundCount + 1
  return true
end function

function locomotionNextCallbackRoll()
  global locomotionCallbackRollPosition
  if locomotionCallbackRollPosition >= locomotionCallbackRollCount then return 0.0 end if
  locomotionCallbackRoll = locomotionCallbackRolls[locomotionCallbackRollPosition]
  locomotionCallbackRollPosition = locomotionCallbackRollPosition + 1
  return locomotionCallbackRoll
end function

function locomotionSetCallbackRoll(value)
  global locomotionCallbackRollCount, locomotionCallbackRollPosition, locomotionCallbackSoundCount
  locomotionCallbackRolls[0] = value
  locomotionCallbackRollCount = 1
  locomotionCallbackRollPosition = 0
  locomotionCallbackSoundCount = 0
  return true
end function

locomotionClasses = [
  "monster_berserk", "monster_gladiator", "monster_gunner", "monster_infantry",
  "monster_soldier_light", "monster_soldier", "monster_soldier_ss", "monster_tank",
  "monster_tank_commander", "monster_medic", "monster_flipper", "monster_chick",
  "monster_parasite", "monster_flyer", "monster_brain", "monster_floater",
  "monster_hover", "monster_mutant", "monster_supertank", "monster_boss2",
  "monster_jorg", "monster_makron",
]
for each locomotionClassName in locomotionClasses
  locomotionPlan = locomotionsequences.stockPlan(locomotionClassName)
  locomotionAssert(locomotionsequences.validatePlan(locomotionPlan), locomotionClassName + " plan validates")
  locomotionAssert(locomotionsequences.modelFrameAt(locomotionPlan, "stand", 0, 0) == locomotionPlan.standFirst and
    locomotionsequences.modelFrameAt(locomotionPlan, "walk", 0, 0) == locomotionPlan.walkFirst and
    locomotionsequences.modelFrameAt(locomotionPlan, "run", 0, 0) == locomotionPlan.runFirst and
    locomotionsequences.modelFrameAt(locomotionPlan, "idle", 0, 0) == locomotionPlan.idleFirst,
    locomotionClassName + " cycle endpoints")
  standMove = locomotionsequences.stockMove(locomotionClassName, "stand", void)
  walkMove = locomotionsequences.stockMove(locomotionClassName, "walk", void)
  runMove = locomotionsequences.stockMove(locomotionClassName, "run", void)
  locomotionAssert(standMove.firstFrame == locomotionPlan.standFirst and standMove.lastFrame == locomotionPlan.standLast and
    walkMove.firstFrame == locomotionPlan.walkFirst and walkMove.lastFrame == locomotionPlan.walkLast and
    runMove.firstFrame == locomotionPlan.runFirst and runMove.lastFrame == locomotionPlan.runLast and
    len(standMove.frames) == standMove.lastFrame - standMove.firstFrame + 1 and
    len(walkMove.frames) == walkMove.lastFrame - walkMove.firstFrame + 1 and
    len(runMove.frames) == runMove.lastFrame - runMove.firstFrame + 1,
    locomotionClassName + " executable move tables")
end for
locomotionAssert(locomotionsequences.stockPlan("misc_insane") is void,
  "dedicated misc_insane state machine remains separate")
locomotionAssert(locomotionsequences.stockPlan("monster_infantry").standFirst == 50 and
  locomotionsequences.stockPlan("monster_infantry").runLast == 99 and
  locomotionsequences.stockPlan("monster_makron").standFirst == 414 and
  locomotionsequences.stockPlan("monster_makron").runLast == 486,
  "reference locomotion endpoints")

berserkWalk = locomotionsequences.stockMove("monster_berserk", "walk", void)
infantryRun = locomotionsequences.stockMove("monster_infantry", "run", void)
medicWalk = locomotionsequences.stockMove("monster_medic", "walk", void)
flipperRun = locomotionsequences.stockMove("monster_flipper", "run", void)
jorgStand = locomotionsequences.stockMove("monster_jorg", "stand", void)
locomotionNear(berserkWalk.frames[0].distance, 9.1, "berserk first walk distance")
locomotionNear(berserkWalk.frames[10].distance, 4.7, "berserk final used walk distance")
locomotionNear(infantryRun.frames[5].distance, 35.0, "infantry run burst distance")
locomotionNear(medicWalk.frames[1].distance, 18.1, "medic variable walk distance")
locomotionNear(flipperRun.frames[23].distance, 24.0, "flipper swim run speed")
locomotionNear(jorgStand.frames[33].distance, 19.0, "Jorg weighted stand motion")
locomotionNear(jorgStand.frames[47].distance, -17.0, "Jorg reverse stand motion")

// Execute the same tables through M_MoveFrame: a complete infantry walk and
// run cycle must cover the exact aggregate 3.19 distances, not merely display
// the corresponding MD2 poses.
moveContext = locomotiontypes.defaultContext()
moveRegistry = locomotionarchetypes.defaultRegistry()
moveActor = locomotionarchetypes.SpawnMonster(moveRegistry, "monster_infantry", 7, moveContext)
moveTarget = locomotiontypes.createActor(8, "path_corner")
moveActor.edict.state.origin = locomotionqtypes.Vec3(0.0, 0.0, 0.0)
moveActor.edict.state.angles = locomotionqtypes.Vec3(0.0, 0.0, 0.0)
moveTarget.edict.state.origin = locomotionqtypes.Vec3(10000.0, 0.0, 0.0)
moveActor.goalEntity = moveTarget
moveActor.moveTarget = moveTarget
moveActor.info.walk(moveActor, moveContext)
moveIndex = 0
while moveIndex < 12
  locomotionmonster.M_MoveFrame(moveActor, moveContext)
  moveContext.time = moveContext.time + 0.1
  moveIndex = moveIndex + 1
end while
locomotionNear(moveActor.edict.state.origin.x, 54.0, "integrated infantry walk distance")
moveActor.info.run(moveActor, moveContext)
moveTarget.isClient = true
moveActor.enemy = moveTarget
moveContext.visible = locomotionVisible
moveIndex = 0
while moveIndex < 8
  locomotionmonster.M_MoveFrame(moveActor, moveContext)
  moveContext.time = moveContext.time + 0.1
  moveIndex = moveIndex + 1
end while
locomotionNear(moveActor.edict.state.origin.x, 169.0, "integrated infantry run distance")

transitionContext = locomotiontypes.defaultContext()
transitionContext.visible = locomotionVisible
transitionTarget = locomotiontypes.createClientTarget(90)
transitionTarget.edict.state.origin = locomotionqtypes.Vec3(10000.0, 0.0, 0.0)

mutantActor = locomotionarchetypes.SpawnMonster(moveRegistry, "monster_mutant", 91, transitionContext)
mutantActor.edict.state.origin = locomotionqtypes.Vec3(0.0, 0.0, 0.0)
mutantActor.goalEntity = transitionTarget; mutantActor.moveTarget = transitionTarget
mutantActor.info.walk(mutantActor, transitionContext)
locomotionAssert(mutantActor.info.currentMove.name == "mutant-walk-start" and
  mutantActor.info.currentMove.firstFrame == 126, "mutant start-walk transition installed")
moveIndex = 0
while moveIndex < 5
  locomotionmonster.M_MoveFrame(mutantActor, transitionContext)
  transitionContext.time = transitionContext.time + 0.1
  moveIndex = moveIndex + 1
end while
locomotionAssert(mutantActor.info.currentMove.name == "mutant-walk" and
  mutantActor.edict.state.frame == 130, "mutant start-walk transitions to loop")

flipperActor = locomotionarchetypes.SpawnMonster(moveRegistry, "monster_flipper", 92, transitionContext)
flipperActor.edict.state.origin = locomotionqtypes.Vec3(0.0, 0.0, 0.0)
flipperActor.goalEntity = transitionTarget; flipperActor.moveTarget = transitionTarget
flipperActor.enemy = transitionTarget
flipperActor.info.run(flipperActor, transitionContext)
locomotionAssert(flipperActor.info.currentMove.name == "flipper-run-transition" and
  flipperActor.info.currentMove.firstFrame == 41, "flipper horizontal-to-vertical transition installed")
moveIndex = 0
while moveIndex < 12
  locomotionmonster.M_MoveFrame(flipperActor, transitionContext)
  transitionContext.time = transitionContext.time + 0.1
  moveIndex = moveIndex + 1
end while
locomotionAssert(flipperActor.info.currentMove.name == "flipper-run" and
  flipperActor.edict.state.frame == 71 and flipperActor.info.currentMove.frames[1].distance == 24.0,
  "flipper two-stage run transition reaches 24-unit loop")

parasiteActor = locomotionarchetypes.SpawnMonster(moveRegistry, "monster_parasite", 93, transitionContext)
transitionContext.randomIdle = 0.5
parasiteActor.info.idle(parasiteActor, transitionContext)
locomotionAssert(parasiteActor.info.currentMove.name == "parasite-fidget-start", "parasite fidget lead-in")
moveIndex = 0
while moveIndex < 5
  locomotionmonster.M_MoveFrame(parasiteActor, transitionContext)
  transitionContext.time = transitionContext.time + 0.1
  moveIndex = moveIndex + 1
end while
locomotionAssert(parasiteActor.info.currentMove.name == "parasite-fidget-loop" and
  parasiteActor.edict.state.frame == 104, "parasite fidget lead-in reaches scratch loop")

jorgCallbackActor = locomotionarchetypes.SpawnMonster(moveRegistry, "monster_jorg", 94, transitionContext)
jorgCallbackActor.goalEntity = transitionTarget; jorgCallbackActor.moveTarget = transitionTarget
jorgCallbackActor.info.walk(jorgCallbackActor, transitionContext)
locomotionAssert(jorgCallbackActor.info.currentMove.name == "jorg-walk" and
  jorgCallbackActor.info.currentMove.frames[0].thinkFunction is void and
  jorgCallbackActor.info.currentMove.frames[7].thinkFunction is void,
  "Jorg walking has no footstep callbacks in the 3.19 table")
jorgCallbackActor.info.run(jorgCallbackActor, transitionContext)
locomotionAssert(typeof(jorgCallbackActor.info.currentMove.frames[0].thinkFunction) == "function" and
  typeof(jorgCallbackActor.info.currentMove.frames[7].thinkFunction) == "function",
  "Jorg running owns left and right step callbacks")

makronCallbackActor = locomotionarchetypes.SpawnMonster(moveRegistry, "monster_makron", 95, transitionContext)
makronCallbackActor.goalEntity = transitionTarget; makronCallbackActor.moveTarget = transitionTarget
makronCallbackActor.info.run(makronCallbackActor, transitionContext)
locomotionAssert(typeof(makronCallbackActor.info.currentMove.frames[0].thinkFunction) == "function" and
  typeof(makronCallbackActor.info.currentMove.frames[4].thinkFunction) == "function",
  "Makron run owns exact left and right step callbacks")

supertankCallbackActor = locomotionarchetypes.SpawnMonster(moveRegistry, "monster_supertank", 96, transitionContext)
supertankCallbackActor.goalEntity = transitionTarget; supertankCallbackActor.moveTarget = transitionTarget
supertankCallbackActor.info.run(supertankCallbackActor, transitionContext)
locomotionAssert(typeof(supertankCallbackActor.info.currentMove.frames[0].thinkFunction) == "function",
  "Supertank tread callback remains on the first movement frame")

// Reachable secondary stand/walk callbacks from the original mframe_t tables.
// Disabled (#if 0) and unreferenced moves are deliberately not invented here.
callbackContext = locomotiontypes.defaultContext()
callbackContext.playSound = locomotionCaptureCallbackSound
callbackContext.nextRandomUnit = locomotionNextCallbackRoll

callbackSoldier = locomotionarchetypes.SpawnMonster(moveRegistry,
  "monster_soldier", 97, callbackContext)
locomotionAssert(callbackSoldier.info.currentMove.name == "soldier-stand" and
  typeof(callbackSoldier.info.currentMove.frames[0].thinkFunction) == "function",
  "Soldier stand1 owns its random idle callback")
callbackSoldier.info.walk(callbackSoldier, callbackContext)
if callbackSoldier.info.currentMove.name != "soldier-walk1" then
  locomotionmonster.SetStockMove(callbackSoldier, "walk", void)
end if
locomotionAssert(typeof(callbackSoldier.info.currentMove.frames[9].thinkFunction) == "function",
  "Soldier walk1 owns its exact cycle callback")

callbackMedic = locomotionarchetypes.SpawnMonster(moveRegistry,
  "monster_medic", 98, callbackContext)
locomotionAssert(typeof(callbackMedic.info.currentMove.frames[0].thinkFunction) == "function",
  "Medic wait1 owns the idle/corpse-search callback")

callbackParasite = locomotionarchetypes.SpawnMonster(moveRegistry,
  "monster_parasite", 99, callbackContext)
callbackParasiteTapCount = 0
callbackParasiteFrame = 0
while callbackParasiteFrame < len(callbackParasite.info.currentMove.frames)
  if typeof(callbackParasite.info.currentMove.frames[callbackParasiteFrame].thinkFunction) ==
      "function" then
    callbackParasiteTapCount = callbackParasiteTapCount + 1
  end if
  callbackParasiteFrame = callbackParasiteFrame + 1
end while
locomotionAssert(callbackParasiteTapCount == 6,
  "Parasite stand owns all six tap callbacks")

callbackJorg = locomotionarchetypes.SpawnMonster(moveRegistry,
  "monster_jorg", 100, callbackContext)
locomotionAssert(typeof(callbackJorg.info.currentMove.frames[0].thinkFunction) == "function" and
  typeof(callbackJorg.info.currentMove.frames[34].thinkFunction) == "function" and
  typeof(callbackJorg.info.currentMove.frames[38].thinkFunction) == "function" and
  typeof(callbackJorg.info.currentMove.frames[47].thinkFunction) == "function" and
  typeof(callbackJorg.info.currentMove.frames[50].thinkFunction) == "function",
  "Jorg stand owns idle and four exact left/right steps")

callbackTank = locomotionarchetypes.SpawnMonster(moveRegistry,
  "monster_tank", 101, callbackContext)
callbackTank.info.run(callbackTank, callbackContext)
locomotionAssert(callbackTank.info.currentMove.name == "tank-run-start" and
  typeof(callbackTank.info.currentMove.frames[3].thinkFunction) == "function",
  "Tank start-run owns its fourth-frame footstep")

locomotionSetCallbackRoll(0.8)
locomotionmonster.StockSoldierIdleFrameSound(callbackSoldier, callbackContext)
locomotionAssert(locomotionCallbackRollPosition == 1 and
  locomotionCallbackSoundCount == 0,
  "Soldier idle uses strict greater-than 0.8 boundary")
locomotionSetCallbackRoll(0.8001)
locomotionmonster.StockSoldierIdleFrameSound(callbackSoldier, callbackContext)
locomotionAssert(locomotionCallbackSoundCount == 1 and
  locomotionCallbackSoundNames[0] == "soldier/solidle1.wav" and
  locomotionCallbackSoundChannels[0] == locomotiongameconstants.CHAN_VOICE and
  locomotionCallbackSoundAttenuations[0] == locomotiongameconstants.ATTN_IDLE,
  "Soldier stand callback consumes one local random and emits idle voice")

callbackChick = locomotionarchetypes.SpawnMonster(moveRegistry,
  "monster_chick", 102, callbackContext)
locomotionSetCallbackRoll(0.5)
locomotionmonster.StockFidgetFrameSound(callbackChick, callbackContext)
locomotionAssert(locomotionCallbackSoundCount == 1 and
  locomotionCallbackSoundNames[0] == "chick/chkidle2.wav" and
  locomotionCallbackRollPosition == 1,
  "ChickMoan exact strict 0.5 branch and local random consumption")

callbackBrain = locomotionarchetypes.SpawnMonster(moveRegistry,
  "monster_brain", 103, callbackContext)
locomotionSetCallbackRoll(0.0)
callbackBrain.info.idle(callbackBrain, callbackContext)
locomotionAssert(locomotionCallbackSoundCount == 1 and
  locomotionCallbackSoundNames[0] == "brain/brnlens1.wav" and
  locomotionCallbackSoundChannels[0] == locomotiongameconstants.CHAN_AUTO,
  "Brain idle uses the stock auto channel")

callbackFlyer = locomotionarchetypes.SpawnMonster(moveRegistry,
  "monster_flyer", 104, callbackContext)
locomotionSetCallbackRoll(0.0)
callbackFlyer.info.idle(callbackFlyer, callbackContext)
locomotionAssert(locomotionCallbackSoundCount == 1 and
  locomotionCallbackSoundNames[0] == "flyer/flyidle1.wav" and
  locomotionCallbackSoundChannels[0] == locomotiongameconstants.CHAN_VOICE,
  "Flyer idle uses flyidle rather than its distinct search asset")

callbackBerserk = locomotionarchetypes.SpawnMonster(moveRegistry,
  "monster_berserk", 105, callbackContext)
locomotionSetCallbackRoll(0.0)
locomotionmonster.StockFidgetFrameSound(callbackBerserk, callbackContext)
locomotionAssert(locomotionCallbackSoundCount == 1 and
  locomotionCallbackSoundNames[0] == "berserk/beridle1.wav" and
  locomotionCallbackSoundChannels[0] == locomotiongameconstants.CHAN_WEAPON,
  "Berserk fidget idle uses the stock weapon channel")

locomotionSetCallbackRoll(0.0)
locomotionmonster.StockParasiteTapSound(callbackParasite, callbackContext)
locomotionAssert(locomotionCallbackSoundNames[0] == "parasite/paridle1.wav" and
  locomotionCallbackSoundChannels[0] == locomotiongameconstants.CHAN_WEAPON and
  locomotionCallbackSoundAttenuations[0] == locomotiongameconstants.ATTN_IDLE,
  "Parasite stand tap uses weapon/idle sound routing")

locomotionSetCallbackRoll(0.1)
callbackSoldier.info.nextFrame = 0
locomotionmonster.StockSoldierWalkCycle(callbackSoldier, callbackContext)
locomotionAssert(callbackSoldier.info.nextFrame == 0,
  "Soldier walk exact 0.1 boundary keeps long tail")
locomotionSetCallbackRoll(0.1001)
locomotionmonster.StockSoldierWalkCycle(callbackSoldier, callbackContext)
locomotionAssert(callbackSoldier.info.nextFrame == 215,
  "Soldier walk callback loops to FRAME_walk101 above 0.1")

locomotionSetCallbackRoll(0.0)
locomotionmonster.StockJorgIdleSound(callbackJorg, callbackContext)
locomotionmonster.StockJorgStepLeft(callbackJorg, callbackContext)
locomotionmonster.StockJorgStepRight(callbackJorg, callbackContext)
locomotionAssert(locomotionCallbackSoundCount == 3 and
  locomotionCallbackSoundNames[0] == "boss3/bs3idle1.wav" and
  locomotionCallbackSoundNames[1] == "boss3/step1.wav" and
  locomotionCallbackSoundNames[2] == "boss3/step2.wav" and
  locomotionCallbackSoundAttenuations[0] == locomotiongameconstants.ATTN_NORM,
  "Jorg stand idle and explicit left/right callbacks")

locomotionServer = locomotionbridge.createRuntime(4)
locomotionApi = locomotiongame.GetGameApi(locomotionbridge.makeImports(locomotionServer))
locomotionServer.game = locomotionApi
locomotionApi.init()
locomotionFixture = "{\"classname\" \"worldspawn\"}" +
  "{\"classname\" \"monster_infantry\" \"origin\" \"128 0 10\" \"angle\" \"180\"}"
locomotionApi.spawnEntities("locomotion-sequence", locomotionFixture, "")
locomotionRuntime = locomotiongame.baseRuntime()
locomotionActor = locomotionRuntime.monsters[0]
locomotionActor.info.idleTime = 100000000.0
locomotionStep = 0
while locomotionStep < 12
  previousFrame = locomotionActor.edict.state.frame
  locomotionApi.runFrame()
  expectedFrame = previousFrame + 1
  if expectedFrame > locomotionActor.info.currentMove.lastFrame then expectedFrame = locomotionActor.info.currentMove.firstFrame end if
  locomotionAssert(locomotionActor.info.currentMove.name == "infantry-stand" and
    locomotionActor.edict.state.frame == expectedFrame,
    "integrated M_MoveFrame stand frame " + locomotionStep)
  locomotionStep = locomotionStep + 1
end while
locomotionApi.shutdown()

print "gameplay_monster_locomotion_sequences_tests: PASS"
