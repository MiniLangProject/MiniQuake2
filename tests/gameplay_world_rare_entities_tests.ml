/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Golden scenarios for rare BaseQ2 world target/trigger/mover entities. */
import miniquake2.game.world.constants as rareworldconstants
import miniquake2.game.world.core as rareworldcore
import miniquake2.game.world.types as rareworldtypes
import miniquake2.game.world.targets as rareworldtargets
import miniquake2.game.world.triggers as rareworldtriggers
import miniquake2.game.world.movers as rareworldmovers
import miniquake2.game.world.misc as rareworldmisc
import miniquake2.qcommon.types as rareworldqtypes

rareKeyCount = 0
rareCenterCount = 0
rareSoundCount = 0
rareSetModelCount = 0
rareDisplayCount = 0
rareLastDisplay = ""
rareTargetUseCount = 0
rareActorMessageCount = 0
rareActorAction = ""
rareActorNext = 0
rareCombatHold = false
rareCombatClear = false
rareCombatNext = 0
rareClockSeconds = 0

// Assert the rare equal test condition.
function rareAssertEqual(actual, expected, label)
  if actual != expected then return error(9993, label + ": expected " + expected + ", got " + actual) end if
end function

// Assert the rare near test condition.
function rareAssertNear(actual, expected, tolerance, label)
  delta = actual - expected
  if delta < 0.0 then delta = -delta end if
  if delta > tolerance then return error(9994, label + ": expected " + expected + ", got " + actual) end if
end function

// Resolve rare key.
function rareResolveKey(itemClassName)
  if itemClassName == "key_data_cd" then return "Data CD" end if
  return void
end function

// Report whether rare has key.
function rareHasKey(activator, itemClassName)
  global rareKeyCount
  return rareKeyCount > 0
end function

// Consume rare key.
function rareConsumeKey(activator, itemClassName)
  global rareKeyCount
  if rareKeyCount <= 0 then return false end if
  rareKeyCount = rareKeyCount - 1
  return true
end function

// Return the rare center value.
function rareCenter(entity, message)
  global rareCenterCount
  rareCenterCount = rareCenterCount + 1
  return true
end function

// Return the rare sound value.
function rareSound(entity, soundName)
  global rareSoundCount
  rareSoundCount = rareSoundCount + 1
  return true
end function

// Set rare model.
function rareSetModel(entity, modelName)
  global rareSetModelCount
  rareSetModelCount = rareSetModelCount + 1
  entity.modelIndex = entity.number
  return true
end function

// Use rare display.
function rareDisplayUse(entity, other, activator, world)
  global rareDisplayCount, rareLastDisplay
  rareDisplayCount = rareDisplayCount + 1
  rareLastDisplay = entity.message
  return true
end function

// Use rare target.
function rareTargetUse(entity, other, activator, world)
  global rareTargetUseCount
  rareTargetUseCount = rareTargetUseCount + 1
  return true
end function

// Return the rare actor message value.
function rareActorMessage(actor, message)
  global rareActorMessageCount
  rareActorMessageCount = rareActorMessageCount + 1
  return true
end function

// Return the rare actor transition value.
function rareActorTransition(actor, waypoint, action, actionTarget, nextTarget, wait, flags)
  global rareActorAction, rareActorNext
  rareActorAction = action
  rareActorNext = 0
  if nextTarget is not void then rareActorNext = nextTarget.number end if
  return true
end function

// Return the rare combat transition value.
function rareCombatTransition(actor, point, nextTarget, hold, clearCombatPoint)
  global rareCombatHold, rareCombatClear, rareCombatNext
  rareCombatHold = hold
  rareCombatClear = clearCombatPoint
  rareCombatNext = 0
  if nextTarget is not void then rareCombatNext = nextTarget.number end if
  return true
end function

// Return the rare time of day value.
function rareTimeOfDay()
  global rareClockSeconds
  return rareClockSeconds
end function

// Return the rare world value.
function rareWorld()
  callbacks = rareworldcore.defaultCallbacks()
  callbacks.resolveKeyItem = rareResolveKey
  callbacks.hasKeyItem = rareHasKey
  callbacks.consumeKeyItem = rareConsumeKey
  callbacks.centerPrint = rareCenter
  callbacks.sound = rareSound
  callbacks.setModel = rareSetModel
  callbacks.actorMessage = rareActorMessage
  callbacks.actorTransition = rareActorTransition
  callbacks.combatPointTransition = rareCombatTransition
  callbacks.clockSeconds = rareTimeOfDay
  return rareworldcore.createWorld(callbacks)
end function

// Verify target string and characters.
function testTargetStringAndCharacters()
  global rareSetModelCount
  rareSetModelCount = 0
  world = rareWorld()
  stringTarget = rareworldcore.spawnEntity(world, "target_string")
  stringTarget.message = "9-:X"
  rareworldmisc.spawnTargetString(stringTarget, world)
  previous = stringTarget
  index = 1
  while index <= 5
    character = rareworldcore.spawnEntity(world, "target_character")
    character.model = "*" + index
    character.count = index
    rareworldmisc.spawnTargetCharacter(character, world)
    previous.teamChain = character
    previous = character
    index = index + 1
  end while
  stringTarget.teamMaster = stringTarget
  rareworldcore.useEntity(world, stringTarget, void, void)
  first = stringTarget.teamChain
  rareAssertEqual(first.frame, 9, "target_string digit")
  rareAssertEqual(first.teamChain.frame, 10, "target_string dash")
  rareAssertEqual(first.teamChain.teamChain.frame, 11, "target_string colon")
  rareAssertEqual(first.teamChain.teamChain.teamChain.frame, 12, "target_string blank glyph")
  rareAssertEqual(first.teamChain.teamChain.teamChain.teamChain.frame, 12, "target_string out-of-range blank")
  rareAssertEqual(rareSetModelCount, 5, "target_character model callback")
  badCharacter = rareworldcore.spawnEntity(world, "bad-character")
  rareAssertEqual(rareworldmisc.spawnTargetCharacter(badCharacter, world), false, "missing character model guarded")
  previous.teamChain = first
  rareAssertEqual(typeof(try(rareworldmisc.useTargetString(stringTarget, void, void, world))), "error", "target_string team cycle rejected")
end function

// Verify clock state machine.
function testClockStateMachine()
  global rareDisplayCount, rareLastDisplay, rareTargetUseCount, rareClockSeconds
  rareDisplayCount = 0; rareLastDisplay = ""; rareTargetUseCount = 0
  world = rareWorld()
  display = rareworldcore.spawnEntity(world, "target_string")
  display.targetName = "clock-display"
  display.use = rareDisplayUse
  done = rareworldcore.spawnEntity(world, "clock-done")
  done.targetName = "clock-done"
  done.use = rareTargetUse
  player = rareworldcore.spawnEntity(world, "player")
  player.isClient = true

  clock = rareworldcore.spawnEntity(world, "func_clock")
  clock.target = "clock-display"
  clock.pathTarget = "clock-done"
  clock.count = 2
  clock.style = 0
  clock.spawnFlags = rareworldconstants.CLOCK_TIMER_UP | rareworldconstants.CLOCK_START_OFF | rareworldconstants.CLOCK_MULTI_USE
  rareworldmisc.spawnWorldClock(clock, world)
  rareAssertEqual(clock.nextThink, 0.0, "START_OFF clock is idle")
  rareworldcore.useEntity(world, clock, player, player)
  rareAssertEqual(rareLastDisplay, " 0", "timer-up immediate zero")
  rareworldcore.advance(world, 1.0)
  rareAssertEqual(rareLastDisplay, " 1", "timer-up second")
  rareworldcore.advance(world, 2.0)
  rareAssertEqual(rareLastDisplay, " 2", "timer-up inclusive terminal value")
  rareAssertEqual(rareTargetUseCount, 1, "clock pathtarget fires once")
  rareAssertEqual(clock.nextThink, 0.0, "multi START_OFF resets idle")
  rareworldcore.useEntity(world, clock, player, player)
  rareAssertEqual(rareLastDisplay, " 0", "multi-use reset")

  dayWorld = rareWorld()
  dayDisplay = rareworldcore.spawnEntity(dayWorld, "target_string")
  dayDisplay.targetName = "day-display"; dayDisplay.use = rareDisplayUse
  dayClock = rareworldcore.spawnEntity(dayWorld, "func_clock")
  dayClock.target = "day-display"; dayClock.style = 2
  rareClockSeconds = 3661
  rareworldmisc.spawnWorldClock(dayClock, dayWorld)
  rareworldcore.advance(dayWorld, 1.0)
  rareAssertEqual(rareLastDisplay, " 1:01:01", "injected deterministic time of day")

  bad = rareworldcore.spawnEntity(dayWorld, "func_clock")
  rareAssertEqual(rareworldmisc.spawnWorldClock(bad, dayWorld), false, "clock missing target rejected")
  down = rareworldcore.spawnEntity(dayWorld, "func_clock")
  down.target = "day-display"; down.spawnFlags = rareworldconstants.CLOCK_TIMER_DOWN
  rareAssertEqual(rareworldmisc.spawnWorldClock(down, dayWorld), false, "countdown missing count rejected")
end function

// Verify trigger key.
function testTriggerKey()
  global rareKeyCount, rareCenterCount, rareSoundCount, rareTargetUseCount
  rareKeyCount = 0; rareCenterCount = 0; rareSoundCount = 0; rareTargetUseCount = 0
  world = rareWorld()
  receiver = rareworldcore.spawnEntity(world, "receiver")
  receiver.targetName = "unlock"; receiver.use = rareTargetUse
  player = rareworldcore.spawnEntity(world, "player"); player.isClient = true
  key = rareworldcore.spawnEntity(world, "trigger_key")
  key.item = "key_data_cd"; key.target = "unlock"
  rareworldtriggers.spawnKey(key, world)
  rareworldcore.useEntity(world, key, player, player)
  rareworldcore.useEntity(world, key, player, player)
  rareAssertEqual(rareCenterCount, 1, "missing key message debounced")
  rareAssertEqual(rareSoundCount, 1, "missing key sound debounced")
  rareworldcore.advance(world, 5.0)
  rareworldcore.useEntity(world, key, player, player)
  rareAssertEqual(rareCenterCount, 2, "missing key retries after five seconds")
  rareKeyCount = 1
  rareworldcore.useEntity(world, key, player, player)
  rareAssertEqual(rareKeyCount, 0, "key callback consumes inventory")
  rareAssertEqual(rareTargetUseCount, 1, "key fires targets")
  rareAssertEqual(key.use is void, true, "key trigger is single-use")

  invalid = rareworldcore.spawnEntity(world, "trigger_key")
  invalid.item = "missing_key"; invalid.target = "unlock"
  rareAssertEqual(rareworldtriggers.spawnKey(invalid, world), false, "unknown key rejected")
end function

// Verify target actor and combat point.
function testTargetActorAndCombatPoint()
  global rareActorMessageCount, rareActorAction, rareActorNext
  global rareCombatHold, rareCombatClear, rareCombatNext, rareTargetUseCount
  rareActorMessageCount = 0; rareActorAction = ""; rareActorNext = 0
  rareTargetUseCount = 0
  world = rareWorld()
  action = rareworldcore.spawnEntity(world, "actor-action")
  action.targetName = "actor-action"; action.use = rareTargetUse
  nextWaypoint = rareworldcore.spawnEntity(world, "target_actor")
  nextWaypoint.targetName = "actor-next"
  waypoint = rareworldcore.spawnEntity(world, "target_actor")
  waypoint.targetName = "actor-first"; waypoint.target = "actor-next"; waypoint.pathTarget = "actor-action"
  waypoint.message = "Move out"; waypoint.spawnFlags = rareworldconstants.ACTOR_JUMP
  waypoint.speed = 300.0; waypoint.height = 250.0; waypoint.angles = rareworldqtypes.Vec3(0.0, 90.0, 0.0)
  rareworldtargets.spawnTargetActor(waypoint, world)
  actor = rareworldcore.spawnEntity(world, "misc_actor")
  actor.targetEntity = waypoint; actor.groundEntity = waypoint
  rareworldcore.touchEntity(world, waypoint, actor)
  rareAssertNear(actor.velocity.y, 300.0, 0.01, "actor jump forward velocity")
  rareAssertEqual(actor.velocity.z, 250.0, "actor jump height")
  rareAssertEqual(actor.targetEntity, nextWaypoint, "actor next waypoint")
  rareAssertEqual(rareActorAction, "move", "actor move transition")
  rareAssertEqual(rareActorNext, nextWaypoint.number, "actor transition next id")
  rareAssertEqual(rareActorMessageCount, 1, "actor message callback")
  rareAssertEqual(rareTargetUseCount, 1, "actor pathtarget chain")

  enemy = rareworldcore.spawnEntity(world, "player"); enemy.targetName = "actor-enemy"; enemy.isClient = true
  attackPoint = rareworldcore.spawnEntity(world, "target_actor")
  attackPoint.targetName = "attack"; attackPoint.pathTarget = "actor-enemy"
  attackPoint.spawnFlags = rareworldconstants.ACTOR_ATTACK | rareworldconstants.ACTOR_HOLD | rareworldconstants.ACTOR_BRUTAL
  rareworldtargets.spawnTargetActor(attackPoint, world)
  actor.targetEntity = attackPoint; actor.enemy = void
  rareworldcore.touchEntity(world, attackPoint, actor)
  rareAssertEqual(actor.enemy, enemy, "actor attack target")
  rareAssertEqual(rareActorAction, "attack", "actor attack transition")

  nextCombat = rareworldcore.spawnEntity(world, "point_combat")
  nextCombat.targetName = "combat-next"
  combatAction = rareworldcore.spawnEntity(world, "combat-action")
  combatAction.targetName = "combat-action"; combatAction.use = rareTargetUse
  point = rareworldcore.spawnEntity(world, "point_combat")
  point.target = "combat-next"; point.pathTarget = "combat-action"
  rareworldmisc.spawnPointCombat(point, world, false)
  actor.enemy = enemy; actor.targetEntity = point
  rareCombatHold = false; rareCombatClear = false; rareCombatNext = 0
  rareworldcore.touchEntity(world, point, actor)
  rareAssertEqual(actor.targetEntity, nextCombat, "combat point next target")
  rareAssertEqual(point.target, "", "combat route target consumed")
  rareAssertEqual(rareCombatNext, nextCombat.number, "combat transition next id")
  rareAssertEqual(rareCombatClear, false, "combat flag retained for next point")
  rareAssertEqual(rareTargetUseCount, 2, "combat pathtarget chain")

  terminal = rareworldcore.spawnEntity(world, "point_combat")
  terminal.spawnFlags = 1
  rareworldmisc.spawnPointCombat(terminal, world, false)
  actor.targetEntity = terminal
  rareworldcore.touchEntity(world, terminal, actor)
  rareAssertEqual(rareCombatHold, true, "terminal combat HOLD")
  rareAssertEqual(rareCombatClear, true, "terminal clears AI_COMBAT_POINT")
  rareAssertEqual(actor.targetEntity is void, true, "terminal clears move target")
  flyingTerminal = rareworldcore.spawnEntity(world, "point_combat")
  flyingTerminal.spawnFlags = 1
  rareworldmisc.spawnPointCombat(flyingTerminal, world, false)
  actor.flags = rareworldconstants.FL_FLY; actor.targetEntity = flyingTerminal
  rareworldcore.touchEntity(world, flyingTerminal, actor)
  rareAssertEqual(rareCombatHold, false, "flying actor ignores combat HOLD")
  rareAssertEqual(rareCombatClear, true, "flying terminal still clears combat point")
  actor.flags = 0
  deathmatchPoint = rareworldcore.spawnEntity(world, "point_combat")
  rareworldmisc.spawnPointCombat(deathmatchPoint, world, true)
  rareAssertEqual(deathmatchPoint.inUse, false, "deathmatch point_combat removed")
end function

// Verify elevator.
function testElevator()
  world = rareWorld()
  corner = rareworldcore.spawnEntity(world, "path_corner")
  corner.targetName = "upper"; corner.origin = rareworldqtypes.Vec3(100.0, 0.0, 0.0)
  train = rareworldcore.spawnEntity(world, "func_train")
  train.targetName = "lift"; train.origin = rareworldqtypes.zeroVec3(); train.mins = rareworldqtypes.zeroVec3()
  rareworldmovers.spawnTrain(train, world)
  elevator = rareworldcore.spawnEntity(world, "trigger_elevator")
  elevator.target = "lift"
  rareworldmovers.spawnElevator(elevator, world)
  rareworldcore.advance(world, world.frameTime)
  rareAssertEqual(elevator.targetEntity, train, "elevator resolves train")
  caller = rareworldcore.spawnEntity(world, "elevator-button"); caller.pathTarget = "upper"
  player = rareworldcore.spawnEntity(world, "player"); player.isClient = true
  rareworldcore.useEntity(world, elevator, caller, player)
  rareAssertEqual(train.targetEntity, corner, "elevator resolves requested corner")
  rareAssertEqual(train.nextThink > world.time, true, "elevator resumes train")
  rareAssertEqual(rareworldmovers.elevatorUse(elevator, caller, player, world), false, "busy elevator ignored")

  bad = rareworldcore.spawnEntity(world, "trigger_elevator")
  bad.target = "missing"
  rareworldmovers.spawnElevator(bad, world)
  rareworldcore.advance(world, world.time + world.frameTime)
  rareAssertEqual(bad.use is void, true, "bad elevator remains disabled")
end function

// Run this source file's command-line entry point.
function main(args)
  testTargetStringAndCharacters()
  testClockStateMachine()
  testTriggerKey()
  testTargetActorAndCombatPoint()
  testElevator()
  print "gameplay_world_rare_entities_tests: PASS"
  return 0
end function
