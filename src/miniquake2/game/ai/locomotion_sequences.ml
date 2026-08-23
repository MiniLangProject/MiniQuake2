/* Primary Quake II 3.19 stand/idle/walk/run MD2 cycles for stock monsters. */
package miniquake2.game.ai.locomotion_sequences

import miniquake2.game.ai.core as locomotioncore
import miniquake2.game.ai.types as locomotiontypes

struct MonsterLocomotionPlan
  className
  standFirst
  standLast
  idleFirst
  idleLast
  walkFirst
  walkLast
  runFirst
  runLast
end struct

// Variable-distance tables are rooted once per package, mirroring the static
// mframe_t tables in the 3.19 game DLL.  Move construction therefore never
// builds them with quadratic array concatenation.
berserkWalkDistances = [9.1, 6.3, 4.9, 6.7, 6.0, 8.2, 7.2, 6.1, 4.9, 4.7, 4.7]
berserkRunDistances = [21.0, 11.0, 21.0, 25.0, 18.0, 19.0]
gladiatorWalkDistances = [15.0, 7.0, 6.0, 5.0, 2.0, 0.0, 2.0, 8.0, 12.0, 8.0, 5.0, 5.0, 2.0, 2.0, 1.0, 8.0]
gladiatorRunDistances = [23.0, 14.0, 14.0, 21.0, 12.0, 13.0]
gunnerWalkDistances = [0.0, 3.0, 4.0, 5.0, 7.0, 2.0, 6.0, 4.0, 2.0, 7.0, 5.0, 7.0, 4.0]
gunnerRunDistances = [26.0, 9.0, 9.0, 9.0, 15.0, 10.0, 13.0, 6.0]
infantryWalkDistances = [5.0, 4.0, 4.0, 5.0, 4.0, 5.0, 6.0, 4.0, 4.0, 4.0, 4.0, 5.0]
infantryRunDistances = [10.0, 20.0, 5.0, 7.0, 30.0, 35.0, 2.0, 6.0]
infantryFidgetDistances = [1.0, 0.0, 1.0, 3.0, 6.0, 3.0, 0.0, 0.0, 0.0, 0.0,
  1.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, -1.0, 0.0, 0.0, 1.0, 0.0, -2.0, 1.0,
  1.0, 1.0, -1.0, 0.0, 0.0, -1.0, 0.0, 0.0, 0.0, 0.0, 0.0, -1.0, 0.0,
  0.0, 1.0, 0.0, 0.0, -1.0, -1.0, 0.0, -3.0, -2.0, -3.0, -3.0, -2.0]
soldierWalk1Distances = [3.0, 6.0, 2.0, 2.0, 2.0, 1.0, 6.0, 5.0, 3.0, -1.0,
  0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
  0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
soldierWalk2Distances = [4.0, 4.0, 9.0, 8.0, 5.0, 1.0, 3.0, 7.0, 6.0, 7.0]
soldierRunStartDistances = [7.0, 5.0]
soldierRunDistances = [10.0, 11.0, 11.0, 16.0, 10.0, 15.0]
tankStartDistances = [0.0, 6.0, 6.0, 11.0]
tankMoveDistances = [4.0, 5.0, 3.0, 2.0, 5.0, 5.0, 4.0, 4.0, 3.0, 5.0, 4.0, 5.0, 7.0, 7.0, 6.0, 6.0]
medicWalkDistances = [6.2, 18.1, 1.0, 9.0, 10.0, 9.0, 11.0, 11.6, 2.0, 9.9, 14.0, 9.3]
medicRunDistances = [18.0, 22.5, 25.4, 23.4, 24.0, 35.6]
chickRunStartDistances = [1.0, 0.0, 0.0, -1.0, -1.0, 0.0, 1.0, 3.0, 6.0, 3.0]
chickMoveDistances = [6.0, 8.0, 13.0, 5.0, 7.0, 4.0, 11.0, 5.0, 9.0, 7.0]
parasiteStartDistances = [0.0, 30.0]
parasiteMoveDistances = [30.0, 30.0, 22.0, 19.0, 24.0, 28.0, 25.0]
brainWalkDistances = [7.0, 2.0, 3.0, 3.0, 1.0, 0.0, 0.0, 9.0, -4.0, -1.0, 2.0]
brainRunDistances = [9.0, 2.0, 3.0, 3.0, 1.0, 0.0, 0.0, 10.0, -4.0, -1.0, 2.0]
mutantWalkStartDistances = [5.0, 5.0, -2.0, 1.0]
mutantWalkDistances = [3.0, 1.0, 5.0, 10.0, 13.0, 10.0, 0.0, 5.0, 6.0, 16.0, 15.0, 6.0]
mutantRunDistances = [40.0, 40.0, 24.0, 5.0, 17.0, 10.0]
jorgStandDistances = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
  0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
  0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 19.0, 11.0, 0.0,
  0.0, 6.0, 9.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, -2.0, -17.0, 0.0,
  -12.0, -14.0]
jorgMoveDistances = [17.0, 0.0, 0.0, 0.0, 12.0, 8.0, 10.0, 33.0, 0.0, 0.0, 0.0, 9.0, 9.0, 9.0]
makronMoveDistances = [3.0, 12.0, 8.0, 8.0, 8.0, 6.0, 12.0, 9.0, 6.0, 12.0]

function makeLocomotionPlan(className, standFirst, standLast, idleFirst, idleLast,
    walkFirst, walkLast, runFirst, runLast)
  return MonsterLocomotionPlan(className, standFirst, standLast, idleFirst,
    idleLast, walkFirst, walkLast, runFirst, runLast)
end function

function stockPlan(className)
  if className == "monster_berserk" then return makeLocomotionPlan(className, 0, 4, 5, 24, 25, 35, 36, 41) end if
  if className == "monster_gladiator" then return makeLocomotionPlan(className, 0, 6, 0, 6, 7, 22, 23, 28) end if
  if className == "monster_gunner" then return makeLocomotionPlan(className, 0, 29, 30, 69, 76, 88, 94, 101) end if
  if className == "monster_infantry" then return makeLocomotionPlan(className, 50, 71, 1, 49, 74, 85, 92, 99) end if
  if className == "monster_soldier_light" or className == "monster_soldier" or className == "monster_soldier_ss" then
    return makeLocomotionPlan(className, 146, 175, 176, 214, 215, 247, 99, 104)
  end if
  if className == "monster_tank" or className == "monster_tank_commander" then return makeLocomotionPlan(className, 0, 29, 0, 29, 34, 49, 34, 49) end if
  if className == "monster_medic" then return makeLocomotionPlan(className, 12, 101, 12, 101, 0, 11, 102, 107) end if
  if className == "monster_flipper" then return makeLocomotionPlan(className, 41, 41, 41, 41, 41, 64, 70, 93) end if
  if className == "monster_chick" then return makeLocomotionPlan(className, 121, 150, 151, 180, 191, 200, 191, 200) end if
  if className == "monster_parasite" then return makeLocomotionPlan(className, 83, 99, 100, 117, 70, 76, 70, 76) end if
  if className == "monster_flyer" then return makeLocomotionPlan(className, 13, 57, 13, 57, 13, 57, 13, 57) end if
  if className == "monster_brain" then return makeLocomotionPlan(className, 162, 191, 192, 221, 0, 10, 0, 10) end if
  if className == "monster_floater" then return makeLocomotionPlan(className, 144, 195, 196, 247, 144, 195, 144, 195) end if
  if className == "monster_hover" then return makeLocomotionPlan(className, 0, 29, 0, 29, 30, 64, 30, 64) end if
  if className == "monster_mutant" then return makeLocomotionPlan(className, 62, 112, 113, 125, 130, 141, 56, 61) end if
  if className == "monster_supertank" then return makeLocomotionPlan(className, 194, 253, 194, 253, 128, 145, 128, 145) end if
  if className == "monster_boss2" then return makeLocomotionPlan(className, 0, 20, 0, 20, 50, 69, 50, 69) end if
  if className == "monster_jorg" then return makeLocomotionPlan(className, 112, 162, 112, 162, 168, 181, 168, 181) end if
  if className == "monster_makron" then return makeLocomotionPlan(className, 414, 473, 188, 200, 477, 486, 477, 486) end if
  return void
end function

function inline hasStockMoves(className)
  return className == "monster_berserk" or className == "monster_gladiator" or
    className == "monster_gunner" or className == "monster_infantry" or
    className == "monster_soldier_light" or className == "monster_soldier" or
    className == "monster_soldier_ss" or className == "monster_tank" or
    className == "monster_tank_commander" or className == "monster_medic" or
    className == "monster_flipper" or className == "monster_chick" or
    className == "monster_parasite" or className == "monster_flyer" or
    className == "monster_brain" or className == "monster_floater" or
    className == "monster_hover" or className == "monster_mutant" or
    className == "monster_supertank" or className == "monster_boss2" or
    className == "monster_jorg" or className == "monster_makron"
end function

function makeStockMove(name, firstFrame, lastFrame, aiFunction, distances,
    defaultDistance, endFunction)
  frameCount = lastFrame - firstFrame + 1
  frames = array(frameCount)
  frameIndex = 0
  while frameIndex < frameCount
    distance = defaultDistance
    if distances is not void and frameIndex < len(distances) then distance = distances[frameIndex] end if
    frames[frameIndex] = locomotiontypes.MonsterFrame(aiFunction, distance, void)
    frameIndex = frameIndex + 1
  end while
  return locomotiontypes.MonsterMove(name, firstFrame, lastFrame, frames, endFunction)
end function

function stockMove(className, moveKind, endFunction)
  soldierClass = className == "monster_soldier_light" or className == "monster_soldier" or className == "monster_soldier_ss"
  tankClass = className == "monster_tank" or className == "monster_tank_commander"

  if moveKind == "stand" then
    if className == "monster_berserk" then return makeStockMove("berserk-stand", 0, 4, locomotioncore.ai_stand, void, 0.0, endFunction) end if
    if className == "monster_gladiator" then return makeStockMove("gladiator-stand", 0, 6, locomotioncore.ai_stand, void, 0.0, endFunction) end if
    if className == "monster_gunner" then return makeStockMove("gunner-stand", 0, 29, locomotioncore.ai_stand, void, 0.0, endFunction) end if
    if className == "monster_infantry" then return makeStockMove("infantry-stand", 50, 71, locomotioncore.ai_stand, void, 0.0, endFunction) end if
    if soldierClass then return makeStockMove("soldier-stand", 146, 175, locomotioncore.ai_stand, void, 0.0, endFunction) end if
    if tankClass then return makeStockMove("tank-stand", 0, 29, locomotioncore.ai_stand, void, 0.0, endFunction) end if
    if className == "monster_medic" then return makeStockMove("medic-stand", 12, 101, locomotioncore.ai_stand, void, 0.0, endFunction) end if
    if className == "monster_flipper" then return makeStockMove("flipper-stand", 41, 41, locomotioncore.ai_stand, void, 0.0, endFunction) end if
    if className == "monster_chick" then return makeStockMove("chick-stand", 121, 150, locomotioncore.ai_stand, void, 0.0, endFunction) end if
    if className == "monster_parasite" then return makeStockMove("parasite-stand", 83, 99, locomotioncore.ai_stand, void, 0.0, endFunction) end if
    if className == "monster_flyer" then return makeStockMove("flyer-stand", 13, 57, locomotioncore.ai_stand, void, 0.0, endFunction) end if
    if className == "monster_brain" then return makeStockMove("brain-stand", 162, 191, locomotioncore.ai_stand, void, 0.0, endFunction) end if
    if className == "monster_floater" then return makeStockMove("floater-stand", 144, 195, locomotioncore.ai_stand, void, 0.0, endFunction) end if
    if className == "monster_hover" then return makeStockMove("hover-stand", 0, 29, locomotioncore.ai_stand, void, 0.0, endFunction) end if
    if className == "monster_mutant" then return makeStockMove("mutant-stand", 62, 112, locomotioncore.ai_stand, void, 0.0, endFunction) end if
    if className == "monster_supertank" then return makeStockMove("supertank-stand", 194, 253, locomotioncore.ai_stand, void, 0.0, endFunction) end if
    if className == "monster_boss2" then return makeStockMove("boss2-stand", 0, 20, locomotioncore.ai_stand, void, 0.0, endFunction) end if
    if className == "monster_jorg" then return makeStockMove("jorg-stand", 112, 162, locomotioncore.ai_stand, jorgStandDistances, 0.0, endFunction) end if
    if className == "monster_makron" then return makeStockMove("makron-stand", 414, 473, locomotioncore.ai_stand, void, 0.0, endFunction) end if
  end if

  if moveKind == "stand-fidget" then
    if className == "monster_berserk" then return makeStockMove("berserk-stand-fidget", 5, 24, locomotioncore.ai_stand, void, 0.0, endFunction) end if
    if className == "monster_gunner" then return makeStockMove("gunner-stand-fidget", 30, 69, locomotioncore.ai_stand, void, 0.0, endFunction) end if
    if className == "monster_infantry" then return makeStockMove("infantry-stand-fidget", 1, 49, locomotioncore.ai_stand, infantryFidgetDistances, 0.0, endFunction) end if
    if soldierClass then return makeStockMove("soldier-stand-fidget", 176, 214, locomotioncore.ai_stand, void, 0.0, endFunction) end if
    if className == "monster_chick" then return makeStockMove("chick-stand-fidget", 151, 180, locomotioncore.ai_stand, void, 0.0, endFunction) end if
    if className == "monster_brain" then return makeStockMove("brain-stand-fidget", 192, 221, locomotioncore.ai_stand, void, 0.0, endFunction) end if
    if className == "monster_mutant" then return makeStockMove("mutant-stand-fidget", 113, 125, locomotioncore.ai_stand, void, 0.0, endFunction) end if
  end if

  if className == "monster_parasite" then
    if moveKind == "fidget-start" then return makeStockMove("parasite-fidget-start", 100, 103, locomotioncore.ai_stand, void, 0.0, endFunction) end if
    if moveKind == "fidget-loop" then return makeStockMove("parasite-fidget-loop", 104, 109, locomotioncore.ai_stand, void, 0.0, endFunction) end if
    if moveKind == "fidget-end" then return makeStockMove("parasite-fidget-end", 110, 117, locomotioncore.ai_stand, void, 0.0, endFunction) end if
  end if

  if moveKind == "stand2" and className == "monster_floater" then
    return makeStockMove("floater-stand2", 196, 247, locomotioncore.ai_stand, void, 0.0, endFunction)
  end if

  if moveKind == "sight" and className == "monster_makron" then
    return makeStockMove("makron-sight", 188, 200, locomotioncore.ai_move, void, 0.0, endFunction)
  end if

  if moveKind == "walk-start" then
    if className == "monster_mutant" then return makeStockMove("mutant-walk-start", 126, 129, locomotioncore.ai_walk, mutantWalkStartDistances, 0.0, endFunction) end if
    if className == "monster_parasite" then return makeStockMove("parasite-walk-start", 68, 69, locomotioncore.ai_walk, parasiteStartDistances, 0.0, endFunction) end if
  end if

  if moveKind == "walk" then
    if className == "monster_berserk" then return makeStockMove("berserk-walk", 25, 35, locomotioncore.ai_walk, berserkWalkDistances, 0.0, endFunction) end if
    if className == "monster_gladiator" then return makeStockMove("gladiator-walk", 7, 22, locomotioncore.ai_walk, gladiatorWalkDistances, 0.0, endFunction) end if
    if className == "monster_gunner" then return makeStockMove("gunner-walk", 76, 88, locomotioncore.ai_walk, gunnerWalkDistances, 0.0, endFunction) end if
    if className == "monster_infantry" then return makeStockMove("infantry-walk", 74, 85, locomotioncore.ai_walk, infantryWalkDistances, 0.0, endFunction) end if
    if soldierClass then return makeStockMove("soldier-walk1", 215, 247, locomotioncore.ai_walk, soldierWalk1Distances, 0.0, endFunction) end if
    if tankClass then return makeStockMove("tank-walk", 34, 49, locomotioncore.ai_walk, tankMoveDistances, 0.0, endFunction) end if
    if className == "monster_medic" then return makeStockMove("medic-walk", 0, 11, locomotioncore.ai_walk, medicWalkDistances, 0.0, endFunction) end if
    if className == "monster_flipper" then return makeStockMove("flipper-walk", 41, 64, locomotioncore.ai_walk, void, 4.0, endFunction) end if
    if className == "monster_chick" then return makeStockMove("chick-walk", 191, 200, locomotioncore.ai_walk, chickMoveDistances, 0.0, endFunction) end if
    if className == "monster_parasite" then return makeStockMove("parasite-walk", 70, 76, locomotioncore.ai_walk, parasiteMoveDistances, 0.0, endFunction) end if
    if className == "monster_flyer" then return makeStockMove("flyer-walk", 13, 57, locomotioncore.ai_walk, void, 5.0, endFunction) end if
    if className == "monster_brain" then return makeStockMove("brain-walk", 0, 10, locomotioncore.ai_walk, brainWalkDistances, 0.0, endFunction) end if
    if className == "monster_floater" then return makeStockMove("floater-walk", 144, 195, locomotioncore.ai_walk, void, 5.0, endFunction) end if
    if className == "monster_hover" then return makeStockMove("hover-walk", 30, 64, locomotioncore.ai_walk, void, 4.0, endFunction) end if
    if className == "monster_mutant" then return makeStockMove("mutant-walk", 130, 141, locomotioncore.ai_walk, mutantWalkDistances, 0.0, endFunction) end if
    if className == "monster_supertank" then return makeStockMove("supertank-walk", 128, 145, locomotioncore.ai_walk, void, 4.0, endFunction) end if
    if className == "monster_boss2" then return makeStockMove("boss2-walk", 50, 69, locomotioncore.ai_walk, void, 8.0, endFunction) end if
    if className == "monster_jorg" then return makeStockMove("jorg-walk", 168, 181, locomotioncore.ai_walk, jorgMoveDistances, 0.0, endFunction) end if
    if className == "monster_makron" then return makeStockMove("makron-walk", 477, 486, locomotioncore.ai_walk, makronMoveDistances, 0.0, endFunction) end if
  end if

  if moveKind == "soldier-walk2" and soldierClass then
    return makeStockMove("soldier-walk2", 256, 265, locomotioncore.ai_walk, soldierWalk2Distances, 0.0, endFunction)
  end if

  if moveKind == "run-start" then
    if soldierClass then return makeStockMove("soldier-run-start", 97, 98, locomotioncore.ai_run, soldierRunStartDistances, 0.0, endFunction) end if
    if tankClass then return makeStockMove("tank-run-start", 30, 33, locomotioncore.ai_run, tankStartDistances, 0.0, endFunction) end if
    if className == "monster_chick" then return makeStockMove("chick-run-start", 181, 190, locomotioncore.ai_run, chickRunStartDistances, 0.0, endFunction) end if
    if className == "monster_parasite" then return makeStockMove("parasite-run-start", 68, 69, locomotioncore.ai_run, parasiteStartDistances, 0.0, endFunction) end if
    if className == "monster_flipper" then return makeStockMove("flipper-run-start", 65, 70, locomotioncore.ai_run, void, 8.0, endFunction) end if
  end if

  if moveKind == "run-transition" and className == "monster_flipper" then
    return makeStockMove("flipper-run-transition", 41, 45, locomotioncore.ai_run, void, 8.0, endFunction)
  end if

  if moveKind == "run" then
    if className == "monster_berserk" then return makeStockMove("berserk-run", 36, 41, locomotioncore.ai_run, berserkRunDistances, 0.0, endFunction) end if
    if className == "monster_gladiator" then return makeStockMove("gladiator-run", 23, 28, locomotioncore.ai_run, gladiatorRunDistances, 0.0, endFunction) end if
    if className == "monster_gunner" then return makeStockMove("gunner-run", 94, 101, locomotioncore.ai_run, gunnerRunDistances, 0.0, endFunction) end if
    if className == "monster_infantry" then return makeStockMove("infantry-run", 92, 99, locomotioncore.ai_run, infantryRunDistances, 0.0, endFunction) end if
    if soldierClass then return makeStockMove("soldier-run", 99, 104, locomotioncore.ai_run, soldierRunDistances, 0.0, endFunction) end if
    if tankClass then return makeStockMove("tank-run", 34, 49, locomotioncore.ai_run, tankMoveDistances, 0.0, endFunction) end if
    if className == "monster_medic" then return makeStockMove("medic-run", 102, 107, locomotioncore.ai_run, medicRunDistances, 0.0, endFunction) end if
    if className == "monster_flipper" then return makeStockMove("flipper-run", 70, 93, locomotioncore.ai_run, void, 24.0, endFunction) end if
    if className == "monster_chick" then return makeStockMove("chick-run", 191, 200, locomotioncore.ai_run, chickMoveDistances, 0.0, endFunction) end if
    if className == "monster_parasite" then return makeStockMove("parasite-run", 70, 76, locomotioncore.ai_run, parasiteMoveDistances, 0.0, endFunction) end if
    if className == "monster_flyer" then return makeStockMove("flyer-run", 13, 57, locomotioncore.ai_run, void, 10.0, endFunction) end if
    if className == "monster_brain" then return makeStockMove("brain-run", 0, 10, locomotioncore.ai_run, brainRunDistances, 0.0, endFunction) end if
    if className == "monster_floater" then return makeStockMove("floater-run", 144, 195, locomotioncore.ai_run, void, 13.0, endFunction) end if
    if className == "monster_hover" then return makeStockMove("hover-run", 30, 64, locomotioncore.ai_run, void, 10.0, endFunction) end if
    if className == "monster_mutant" then return makeStockMove("mutant-run", 56, 61, locomotioncore.ai_run, mutantRunDistances, 0.0, endFunction) end if
    if className == "monster_supertank" then return makeStockMove("supertank-run", 128, 145, locomotioncore.ai_run, void, 12.0, endFunction) end if
    if className == "monster_boss2" then return makeStockMove("boss2-run", 50, 69, locomotioncore.ai_run, void, 8.0, endFunction) end if
    if className == "monster_jorg" then return makeStockMove("jorg-run", 168, 181, locomotioncore.ai_run, jorgMoveDistances, 0.0, endFunction) end if
    if className == "monster_makron" then return makeStockMove("makron-run", 477, 486, locomotioncore.ai_run, makronMoveDistances, 0.0, endFunction) end if
  end if
  return void
end function

function rangeFirst(plan, activity)
  if activity == "walk" then return plan.walkFirst end if
  if activity == "run" or activity == "attack" or activity == "melee" then return plan.runFirst end if
  if activity == "idle" or activity == "search" or activity == "sight" then return plan.idleFirst end if
  return plan.standFirst
end function

function rangeLast(plan, activity)
  if activity == "walk" then return plan.walkLast end if
  if activity == "run" or activity == "attack" or activity == "melee" then return plan.runLast end if
  if activity == "idle" or activity == "search" or activity == "sight" then return plan.idleLast end if
  return plan.standLast
end function

function modelFrameAt(plan, activity, frameNumber, actorNumber)
  first = rangeFirst(plan, activity)
  last = rangeLast(plan, activity)
  count = last - first + 1
  offset = frameNumber + actorNumber
  if offset < 0 then offset = -offset end if
  return first + (offset % count)
end function

function validatePlan(plan)
  if plan is void or plan.className == "" or plan.standFirst < 0 or
      plan.standLast < plan.standFirst or plan.idleFirst < 0 or plan.idleLast < plan.idleFirst or
      plan.walkFirst < 0 or plan.walkLast < plan.walkFirst or
      plan.runFirst < 0 or plan.runLast < plan.runFirst then
    return error(9675, "invalid monster locomotion plan")
  end if
  return true
end function
