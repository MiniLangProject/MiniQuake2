//! Provides miniquake2 runtime campaign session facilities for this project.

/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Goal-confirmed campaign progression over a persistent Protocol-34 session. */
package miniquake2.runtime.campaign_session

import miniquake2.game.integration.campaign_progression as campaignobjectives
import miniquake2.game.null_game as campaignsessiongame
import miniquake2.runtime.play_session as campaignplay

/// Store campaign advance result data.
struct CampaignAdvanceResult
  /// Stores the advanced value associated with campaign advance result.
  advanced
  /// Stores the source map value associated with campaign advance result.
  sourceMap
  /// Stores the target map value associated with campaign advance result.
  targetMap
  /// Stores the objective value associated with campaign advance result.
  objective
  /// Stores the spawn count value associated with campaign advance result.
  spawnCount
  /// Stores the steps value associated with campaign advance result.
  steps
end struct

/// Commit campaign core.
/// @param session session value consumed by this operation.
/// @param targetMap targetMap value consumed by this operation.
/// @param entityText entityText value consumed by this operation.
/// @param collision collision value consumed by this operation.
/// @param maximumSteps maximumSteps value consumed by this operation.
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

/// Commit campaign retail.
/// @param session session value consumed by this operation.
/// @param baseDirectory baseDirectory value consumed by this operation.
/// @param targetMap targetMap value consumed by this operation.
/// @param maximumSteps maximumSteps value consumed by this operation.
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

/// Prepare campaign advance.
/// @param session session value consumed by this operation.
/// @param targetMap targetMap value consumed by this operation.
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

/// Advance core.
/// @param session session value consumed by this operation.
/// @param targetMap targetMap value consumed by this operation.
/// @param entityText entityText value consumed by this operation.
/// @param collision collision value consumed by this operation.
/// @param maximumSteps maximumSteps value consumed by this operation.
function advanceCore(session, targetMap, entityText, collision, maximumSteps)
  if maximumSteps < 1 then return error(8477, "campaign maximum steps must be positive") end if
  campaignCorePrepared = campaignPrepareAdvance(session, targetMap)
  campaignCommitCore(session, campaignCorePrepared[1].selectedMapSpec,
    entityText, collision, maximumSteps)
  campaignplay.runUntilActive(session, maximumSteps)
  return CampaignAdvanceResult(true, campaignCorePrepared[0], targetMap,
    campaignCorePrepared[1], session.server.networkRuntime.spawnCount, session.steps)
end function

/// Advance retail.
/// @param session session value consumed by this operation.
/// @param baseDirectory baseDirectory value consumed by this operation.
/// @param targetMap targetMap value consumed by this operation.
/// @param maximumSteps maximumSteps value consumed by this operation.
function advanceRetail(session, baseDirectory, targetMap, maximumSteps)
  if maximumSteps < 1 then return error(8477, "campaign maximum steps must be positive") end if
  if typeof(baseDirectory) != "string" or baseDirectory == "" then return error(8478, "campaign retail root is required") end if
  campaignRetailPrepared = campaignPrepareAdvance(session, targetMap)
  campaignCommitRetail(session, baseDirectory,
    campaignRetailPrepared[1].selectedMapSpec, maximumSteps)
  campaignplay.runUntilActive(session, maximumSteps)
  return CampaignAdvanceResult(true, campaignRetailPrepared[0], targetMap,
    campaignRetailPrepared[1], session.server.networkRuntime.spawnCount, session.steps)
end function

/// Return the complete value.
/// @param session session value consumed by this operation.
/// @param terminalTarget terminalTarget value consumed by this operation.
function complete(session, terminalTarget)
  campaignTerminalPrepared = campaignPrepareAdvance(session, terminalTarget)
  return CampaignAdvanceResult(true, campaignTerminalPrepared[0], terminalTarget,
    campaignTerminalPrepared[1], session.server.networkRuntime.spawnCount, session.steps)
end function
