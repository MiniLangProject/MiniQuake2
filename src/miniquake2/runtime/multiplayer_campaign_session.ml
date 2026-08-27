/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Goal-confirmed campaign progression for the two-client UDP session. */
package miniquake2.runtime.multiplayer_campaign_session

import miniquake2.game.integration.campaign_progression as mpcampaignobjectives
import miniquake2.game.null_game as mpcampaigngame
import miniquake2.runtime.multiplayer_session as mpcampaignsession

// Store multiplayer campaign advance result data.
struct MultiplayerCampaignAdvanceResult
  advanced
  sourceMap
  targetMap
  objective
  spawnCount
  steps
end struct

// Prepare advance.
function prepareAdvance(session, targetMap)
  if session is void or session.closed or
      session.mode != mpcampaignsession.MODE_COOP then
    return error(8486, "multiplayer campaign requires an active coop session")
  end if
  mpcampaignSourceMap = session.server.mapName
  mpcampaignObjective = mpcampaignobjectives.driveToMap(
    mpcampaigngame.baseRuntime(), mpcampaigngame.playerContext(), targetMap)
  if not mpcampaignObjective.reached then
    return error(8487, "multiplayer objective did not reach " + targetMap)
  end if
  if mpcampaignObjective.directFallback then
    return error(8488, "multiplayer objective required direct changelevel fallback: " +
      targetMap)
  end if
  mpcampaignContext = mpcampaigngame.playerContext()
  mpcampaignContext.exitIntermission = true
  mpcampaignsession.step(session)
  mpcampaignQueuedMap = mpcampaignsession.takeQueuedMap(session)
  if mpcampaignobjectives.normalizedMapName(mpcampaignQueuedMap) != targetMap then
    return error(8489, "multiplayer objective queued unexpected map: " +
      mpcampaignQueuedMap)
  end if
  return [mpcampaignSourceMap, mpcampaignObjective]
end function

// Advance core.
function advanceCore(session, targetMap, entityText, collision, maximumSteps)
  if typeof(maximumSteps) != "int" or maximumSteps < 1 then
    return error(8490, "multiplayer campaign step limit must be positive")
  end if
  mpcampaignCorePrepared = prepareAdvance(session, targetMap)
  mpcampaignCoreChanged = mpcampaignsession.changeMapCore(session, targetMap,
    entityText, collision, maximumSteps)
  if not mpcampaignCoreChanged.changed then
    return error(8491, "multiplayer core campaign change did not commit")
  end if
  return MultiplayerCampaignAdvanceResult(true, mpcampaignCorePrepared[0],
    targetMap, mpcampaignCorePrepared[1],
    session.server.networkRuntime.spawnCount, session.steps)
end function

// Advance retail.
function advanceRetail(session, baseDirectory, targetMap, maximumSteps)
  if typeof(baseDirectory) != "string" or baseDirectory == "" then
    return error(8492, "multiplayer retail campaign root is required")
  end if
  if typeof(maximumSteps) != "int" or maximumSteps < 1 then
    return error(8490, "multiplayer campaign step limit must be positive")
  end if
  mpcampaignRetailPrepared = prepareAdvance(session, targetMap)
  mpcampaignRetailChanged = mpcampaignsession.changeMapRetail(session,
    baseDirectory, targetMap, maximumSteps)
  if not mpcampaignRetailChanged.changed then
    return error(8493, "multiplayer retail campaign change did not commit")
  end if
  return MultiplayerCampaignAdvanceResult(true, mpcampaignRetailPrepared[0],
    targetMap, mpcampaignRetailPrepared[1],
    session.server.networkRuntime.spawnCount, session.steps)
end function

// Return the complete value.
function complete(session, terminalTarget)
  mpcampaignTerminalObjective = mpcampaignobjectives.driveToMap(
    mpcampaigngame.baseRuntime(), mpcampaigngame.playerContext(), terminalTarget)
  if not mpcampaignTerminalObjective.reached or
      mpcampaignTerminalObjective.directFallback then
    return error(8494, "multiplayer terminal objective did not reach " +
      terminalTarget)
  end if
  return MultiplayerCampaignAdvanceResult(true, session.server.mapName,
    terminalTarget, mpcampaignTerminalObjective,
    session.server.networkRuntime.spawnCount, session.steps)
end function
