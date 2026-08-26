/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Goal-confirmed campaign progression over a persistent Protocol-34 session. */
package miniquake2.runtime.campaign_session

import miniquake2.game.integration.campaign_progression as campaignobjectives
import miniquake2.game.null_game as campaignsessiongame
import miniquake2.runtime.play_session as campaignplay

struct CampaignAdvanceResult
  advanced
  sourceMap
  targetMap
  objective
  spawnCount
  steps
end struct

function campaignCommitCore(session, targetMap, entityText, collision, maximumSteps)
  campaignCoreAttempt = 0
  while campaignCoreAttempt < maximumSteps
    campaignCoreChange = campaignplay.changeMapCore(session, targetMap, entityText, collision)
    if campaignCoreChange.changed then return campaignCoreChange end if
    if not campaignCoreChange.deferred then return error(8470, "goal-confirmed core map change rejected: " + campaignCoreChange.reason) end if
    campaignplay.step(session)
    campaignCoreAttempt = campaignCoreAttempt + 1
  end while
  return error(8471, "goal-confirmed core map change remained deferred")
end function

function campaignCommitRetail(session, baseDirectory, targetMap, maximumSteps)
  campaignRetailAttempt = 0
  while campaignRetailAttempt < maximumSteps
    campaignRetailChange = campaignplay.changeMapRetail(session, baseDirectory, targetMap)
    if campaignRetailChange.changed then return campaignRetailChange end if
    if not campaignRetailChange.deferred then return error(8472, "goal-confirmed retail map change rejected: " + campaignRetailChange.reason) end if
    campaignplay.step(session)
    campaignRetailAttempt = campaignRetailAttempt + 1
  end while
  return error(8473, "goal-confirmed retail map change remained deferred")
end function

function campaignPrepareAdvance(session, targetMap)
  if session is void or session.closed then return error(8474, "campaign session is closed") end if
  campaignSourceMap = session.server.mapName
  campaignObjectiveResult = campaignobjectives.driveToMap(
    campaignsessiongame.baseRuntime(), campaignsessiongame.playerContext(), targetMap)
  if not campaignObjectiveResult.reached then return error(8475, "campaign objective did not reach " + targetMap) end if
  if campaignObjectiveResult.directFallback then
    return error(8476, "campaign objective required direct changelevel fallback: " + targetMap +
      " selected=" + campaignObjectiveResult.selectedMapSpec +
      " actions=" + campaignObjectiveResult.actions + " keys=" + campaignObjectiveResult.keys +
      " monsters=" + campaignObjectiveResult.monsters)
  end if
  campaignPlayerContext = campaignsessiongame.playerContext()
  campaignPlayerContext.exitIntermission = true
  campaignplay.step(session)
  return [campaignSourceMap, campaignObjectiveResult]
end function

function advanceCore(session, targetMap, entityText, collision, maximumSteps)
  if maximumSteps < 1 then return error(8477, "campaign maximum steps must be positive") end if
  campaignCorePrepared = campaignPrepareAdvance(session, targetMap)
  campaignCommitCore(session, targetMap, entityText, collision, maximumSteps)
  campaignplay.runUntilActive(session, maximumSteps)
  return CampaignAdvanceResult(true, campaignCorePrepared[0], targetMap,
    campaignCorePrepared[1], session.server.networkRuntime.spawnCount, session.steps)
end function

function advanceRetail(session, baseDirectory, targetMap, maximumSteps)
  if maximumSteps < 1 then return error(8477, "campaign maximum steps must be positive") end if
  if typeof(baseDirectory) != "string" or baseDirectory == "" then return error(8478, "campaign retail root is required") end if
  campaignRetailPrepared = campaignPrepareAdvance(session, targetMap)
  campaignCommitRetail(session, baseDirectory, targetMap, maximumSteps)
  campaignplay.runUntilActive(session, maximumSteps)
  return CampaignAdvanceResult(true, campaignRetailPrepared[0], targetMap,
    campaignRetailPrepared[1], session.server.networkRuntime.spawnCount, session.steps)
end function

function complete(session, terminalTarget)
  campaignTerminalPrepared = campaignPrepareAdvance(session, terminalTarget)
  return CampaignAdvanceResult(true, campaignTerminalPrepared[0], terminalTarget,
    campaignTerminalPrepared[1], session.server.networkRuntime.spawnCount, session.steps)
end function
