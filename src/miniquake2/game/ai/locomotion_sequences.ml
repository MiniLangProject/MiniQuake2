/* Primary Quake II 3.19 stand/idle/walk/run MD2 cycles for stock monsters. */
package miniquake2.game.ai.locomotion_sequences

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

function makeLocomotionPlan(className, standFirst, standLast, idleFirst, idleLast,
    walkFirst, walkLast, runFirst, runLast)
  return MonsterLocomotionPlan(className, standFirst, standLast, idleFirst,
    idleLast, walkFirst, walkLast, runFirst, runLast)
end function

function stockPlan(className)
  if className == "monster_berserk" then return makeLocomotionPlan(className, 0, 4, 5, 24, 25, 35, 36, 41) end if
  if className == "monster_gladiator" then return makeLocomotionPlan(className, 0, 6, 0, 6, 7, 22, 23, 28) end if
  if className == "monster_gunner" then return makeLocomotionPlan(className, 0, 29, 0, 29, 76, 88, 94, 101) end if
  if className == "monster_infantry" then return makeLocomotionPlan(className, 50, 71, 50, 71, 74, 85, 92, 99) end if
  if className == "monster_soldier_light" or className == "monster_soldier" or className == "monster_soldier_ss" then
    return makeLocomotionPlan(className, 146, 175, 176, 214, 215, 247, 99, 104)
  end if
  if className == "monster_tank" or className == "monster_tank_commander" then return makeLocomotionPlan(className, 0, 29, 0, 29, 34, 49, 34, 49) end if
  if className == "monster_medic" then return makeLocomotionPlan(className, 12, 101, 12, 101, 0, 11, 102, 107) end if
  if className == "monster_flipper" then return makeLocomotionPlan(className, 41, 41, 41, 41, 41, 64, 70, 93) end if
  if className == "monster_chick" then return makeLocomotionPlan(className, 121, 150, 121, 150, 191, 200, 191, 200) end if
  if className == "monster_parasite" then return makeLocomotionPlan(className, 83, 99, 83, 99, 70, 76, 70, 76) end if
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
