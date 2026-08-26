/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Reproducible physical-input probe for product and campaign acceptance. */
package miniquake2.runtime.campaign_playtest

import miniquake2.game.constants as campaignplaytestgameconstants
import miniquake2.game.null_game as campaignplaytestgame
import miniquake2.qcommon.types as campaignplaytestqtypes
import miniquake2.runtime.play_session as campaignplaytestsession

struct PhysicalPlaytestReport
  mapName
  commandSteps
  snapshots
  startOrigin
  endOrigin
  planarDisplacement
  fireCount
  itemDelta
  health
  packets
  rejectedPackets
end struct

function campaignPlaytestInventoryTotal(player)
  campaignPlaytestInventorySum = 0
  for each campaignPlaytestInventoryCount in player.gameplay.inventory.counts
    campaignPlaytestInventorySum = campaignPlaytestInventorySum + campaignPlaytestInventoryCount
  end for
  return campaignPlaytestInventorySum
end function

function campaignPlaytestSquared(value)
  return value * value
end function

function drive(session, commandSteps)
  if session is void or session.closed then return error(8490, "physical playtest session is closed") end if
  if typeof(commandSteps) != "int" or commandSteps < 8 or commandSteps > 10000 then
    return error(8491, "physical playtest command count outside [8,10000]")
  end if
  if not campaignplaytestsession.signonComplete(session) then
    return error(8492, "physical playtest requires an active session")
  end if
  campaignPlaytestPlayerContext = campaignplaytestgame.playerContext()
  if campaignPlaytestPlayerContext is void or len(campaignPlaytestPlayerContext.players) != 1 then
    return error(8493, "physical playtest requires exactly one player")
  end if
  campaignPlaytestPlayer = campaignPlaytestPlayerContext.players[0]
  campaignPlaytestStartOrigin = campaignplaytestqtypes.Vec3(
    campaignPlaytestPlayer.edict.state.origin.x,
    campaignPlaytestPlayer.edict.state.origin.y,
    campaignPlaytestPlayer.edict.state.origin.z)
  campaignPlaytestStartInventory = campaignPlaytestInventoryTotal(campaignPlaytestPlayer)
  campaignPlaytestStartFireCount = campaignPlaytestPlayer.gameplay.fireCount
  campaignPlaytestSnapshots = 0
  campaignPlaytestUseSpawnDirection = false
  campaignPlaytestIndex = 0
  while campaignPlaytestIndex < commandSteps
    campaignPlaytestButtons = 0
    // Send separated attack edges while retaining the normal Weapon_Generic
    // cadence.  Damage/projectiles must remain on the decoded UDP path.
    if campaignPlaytestIndex == 2 or campaignPlaytestIndex == 18 or
        campaignPlaytestIndex == 34 or campaignPlaytestIndex == 42 then
      campaignPlaytestButtons = campaignplaytestgameconstants.BUTTON_ATTACK
    end if
    campaignPlaytestForward = 300
    campaignPlaytestSide = 0
    if campaignPlaytestIndex >= 28 then campaignPlaytestForward = 0 end if
    if campaignPlaytestIndex == 12 then
      campaignPlaytestProbeDx = campaignPlaytestPlayer.edict.state.origin.x - campaignPlaytestStartOrigin.x
      campaignPlaytestProbeDy = campaignPlaytestPlayer.edict.state.origin.y - campaignPlaytestStartOrigin.y
      campaignPlaytestUseSpawnDirection = campaignPlaytestSquared(campaignPlaytestProbeDx) +
        campaignPlaytestSquared(campaignPlaytestProbeDy) <= 64.0
    end if
    campaignPlaytestYaw = -10194
    if campaignPlaytestUseSpawnDirection then campaignPlaytestYaw = 0 end if
    // base1's default spawn contributes +135 degrees through deltaAngles. The
    // -56 degree command follows its open north-east stock-item corridor. A
    // blocked start automatically retries the authored spawn direction.
    campaignPlaytestCommand = campaignplaytestqtypes.UserCmd(100,
      campaignPlaytestButtons, [0, campaignPlaytestYaw, 0], campaignPlaytestForward,
      campaignPlaytestSide, 0, 0, 64)
    campaignplaytestsession.setUserCmd(session, campaignPlaytestCommand)
    campaignPlaytestStep = campaignplaytestsession.step(session)
    if campaignPlaytestStep.handoff is not void then campaignPlaytestSnapshots = campaignPlaytestSnapshots + 1 end if
    campaignPlaytestIndex = campaignPlaytestIndex + 1
  end while
  campaignPlaytestEndOrigin = campaignplaytestqtypes.Vec3(
    campaignPlaytestPlayer.edict.state.origin.x,
    campaignPlaytestPlayer.edict.state.origin.y,
    campaignPlaytestPlayer.edict.state.origin.z)
  campaignPlaytestDx = campaignPlaytestEndOrigin.x - campaignPlaytestStartOrigin.x
  campaignPlaytestDy = campaignPlaytestEndOrigin.y - campaignPlaytestStartOrigin.y
  campaignPlaytestDistance = campaignPlaytestSquared(campaignPlaytestDx) + campaignPlaytestSquared(campaignPlaytestDy)
  campaignPlaytestFinalInventory = campaignPlaytestInventoryTotal(campaignPlaytestPlayer)
  campaignPlaytestPackets = session.client.packetsReceived + session.server.packetsReceived
  campaignPlaytestRejected = session.client.packetsRejected + session.server.packetsRejected
  return PhysicalPlaytestReport(session.server.mapName, commandSteps,
    campaignPlaytestSnapshots, campaignPlaytestStartOrigin, campaignPlaytestEndOrigin,
    campaignPlaytestDistance, campaignPlaytestPlayer.gameplay.fireCount - campaignPlaytestStartFireCount,
    campaignPlaytestFinalInventory - campaignPlaytestStartInventory,
    campaignPlaytestPlayer.health, campaignPlaytestPackets, campaignPlaytestRejected)
end function
