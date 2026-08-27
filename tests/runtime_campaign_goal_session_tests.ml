/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Persistent UDP map changes may commit only after real Game goal callbacks. */
import miniquake2.runtime.campaign_session as goalruntime
import miniquake2.runtime.play_session as goalruntimeplay

// Assert the goal runtime test condition.
function goalRuntimeAssert(value, message)
  if value != true then return error(8480, message) end if
  return true
end function

// Return the goal runtime entities value.
function goalRuntimeEntities(nextMap, origin)
  return "{\"classname\" \"worldspawn\"}" +
    "{\"classname\" \"info_player_start\" \"origin\" \"" + origin + "\"}" +
    "{\"classname\" \"trigger_once\" \"target\" \"exit_goal\"}" +
    "{\"classname\" \"target_changelevel\" \"targetname\" \"exit_goal\" \"map\" \"" + nextMap + "$start\"}"
end function

// Map goal runtime unique count.
function goalRuntimeUniqueMapCount(sourceMap, targets)
  goalRuntimeUniqueMaps = [sourceMap]
  for each goalRuntimeMapCandidate in targets
    goalRuntimeSeen = false
    for each goalRuntimeKnownMap in goalRuntimeUniqueMaps
      if goalRuntimeKnownMap == goalRuntimeMapCandidate then goalRuntimeSeen = true end if
    end for
    if not goalRuntimeSeen then goalRuntimeUniqueMaps = goalRuntimeUniqueMaps + [goalRuntimeMapCandidate] end if
  end for
  return len(goalRuntimeUniqueMaps)
end function

// Return the goal runtime synthetic value.
function goalRuntimeSynthetic()
  goalCoreSession = goalruntimeplay.createCore("goal-a", goalRuntimeEntities("goal-b", "0 0 0"), void,
    "\\name\\GoalSession\\skin\\male/grunt\\rate\\25000")
  goalruntimeplay.runUntilActive(goalCoreSession, 256)
  goalCoreSpawn = goalCoreSession.server.networkRuntime.spawnCount
  goalCoreResult = goalruntime.advanceCore(goalCoreSession, "goal-b",
    goalRuntimeEntities("goal-c", "64 0 0"), void, 256)
  goalRuntimeAssert(goalCoreResult.advanced and goalCoreResult.sourceMap == "goal-a" and
    goalCoreResult.targetMap == "goal-b", "core goal-confirmed transition")
  goalRuntimeAssert(goalCoreResult.objective.reached and not goalCoreResult.objective.directFallback and
    goalCoreResult.spawnCount == goalCoreSpawn + 1, "core transition objective and spawn epoch")
  goalRuntimeAssert(goalruntimeplay.signonComplete(goalCoreSession), "core transition re-signon")
  goalruntimeplay.shutdown(goalCoreSession)
  return true
end function

// Return the goal runtime retail value.
function goalRuntimeRetail(baseDirectory)
  goalRetailSession = goalruntimeplay.createRetail(baseDirectory, "base1",
    "\\name\\GoalRetail\\skin\\male/grunt\\rate\\25000")
  goalruntimeplay.runUntilActive(goalRetailSession, 512)
  goalRetailSpawn = goalRetailSession.server.networkRuntime.spawnCount
  goalRetailMaps = [
    "base2", "base3", "train", "base3", "base2", "bunk1",
    "ware1", "bunk1", "ware2", "jail1",
    "jail2", "jail3", "jail4", "jail3", "jail5", "jail3", "security", "mintro",
    "mine1", "mine2", "mine3", "mine4", "mine3", "fact1",
    "fact2", "fact1", "fact3", "fact1", "power1",
    "power2", "cool1", "power2", "waste1", "waste2", "waste3", "waste1", "power2", "biggun",
    "hangar1", "space", "hangar1", "lab", "hangar1", "hangar2", "command", "strike", "city1",
    "city2", "city3", "boss1", "boss2",
  ]
  goalRuntimeAssert(len(goalRetailMaps) == 51 and goalRuntimeUniqueMapCount("base1", goalRetailMaps) == 39,
    "retail route must cover all 39 campaign BSPs")
  for each goalRetailTarget in goalRetailMaps
    goalRetailAdvance = goalruntime.advanceRetail(goalRetailSession, baseDirectory, goalRetailTarget, 512)
    goalRuntimeAssert(goalRetailAdvance.advanced and goalRetailAdvance.targetMap == goalRetailTarget and
      goalRetailAdvance.objective.reached and not goalRetailAdvance.objective.directFallback,
      "retail goal transition " + goalRetailTarget)
    goalRuntimeAssert(goalruntimeplay.signonComplete(goalRetailSession) and
      goalRetailSession.server.mapName == goalRetailTarget, "retail re-signon " + goalRetailTarget)
  end for
  goalRuntimeAssert(goalRetailSession.server.networkRuntime.spawnCount == goalRetailSpawn + len(goalRetailMaps),
    "retail goal transition spawn epochs")
  goalTerminal = goalruntime.complete(goalRetailSession, "victory.pcx")
  goalRuntimeAssert(goalTerminal.advanced and goalTerminal.targetMap == "victory.pcx" and
    goalTerminal.objective.reached and not goalTerminal.objective.directFallback,
    "retail boss2 terminal goal")
  goalruntimeplay.shutdown(goalRetailSession)
  return true
end function

// Run this source file's command-line entry point.
function main(args)
  if len(args) > 1 then return error(8481, "expected optional Quake II install root") end if
  goalRuntimeSynthetic()
  if len(args) == 1 then
    goalRuntimeRetail(args[0])
    print("runtime_campaign_goal_session_tests: PASS (synthetic + full retail goal route)")
  else
    print("runtime_campaign_goal_session_tests: PASS (synthetic)")
  end if
  return 0
end function
