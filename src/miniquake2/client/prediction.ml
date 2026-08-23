/*
Copyright (C) 1997-2001 Id Software, Inc.
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later

Quake II 3.19 CL_PredictMovement replay over the shared deterministic Pmove.
The caller owns collision callbacks so the same code serves a listen client,
remote client collision world and isolated tests.
*/
package miniquake2.client.prediction

import miniquake2.qcommon.constants as cpqc
import miniquake2.qcommon.types as cpqt
import miniquake2.protocol.types as cppt
import miniquake2.physics.pmove as cppmove

struct MovementPrediction
  state
  viewAngles
  commandsReplayed
end struct

function inline shortToAngle(value)
  return value * (360.0 / 65536.0)
end function

// cl.viewangles contains the command-space angles; pmove.delta_angles rotates
// them into the server-selected spawn/intermission space.
function localInputAngles(playerState)
  return [
    playerState.viewAngles[0] - shortToAngle(playerState.pmove.deltaAngles[0]),
    playerState.viewAngles[1] - shortToAngle(playerState.pmove.deltaAngles[1]),
    playerState.viewAngles[2] - shortToAngle(playerState.pmove.deltaAngles[2])]
end function

function predict(playerState, commands, traceCallback, pointContentsCallback,
    airAcceleration)
  if typeof(playerState) != "struct" then return error(7650, "prediction requires player state") end if
  if typeof(commands) != "array" then return error(7651, "prediction commands must be an array") end if
  pmove = cppmove.create(traceCallback, pointContentsCallback)
  pmove.state = cppt.copyPmoveState(playerState.pmove)
  index = 0
  while index < len(commands)
    command = commands[index]
    if typeof(command) != "struct" then return error(7652, "prediction command is malformed") end if
    pmove.command = cppt.copyUserCmd(command)
    cppmove.moveWithAirAcceleration(pmove, airAcceleration)
    index = index + 1
  end while
  // With no pending command Pmove has not populated viewAngles. Preserve the
  // exact CL_PredictMovement fallback used when prediction is disabled.
  if len(commands) == 0 then
    pmove.viewAngles = cpqt.vec3(
      playerState.viewAngles[0], playerState.viewAngles[1], playerState.viewAngles[2])
  end if
  return MovementPrediction(cppt.copyPmoveState(pmove.state),
    cpqt.vec3(pmove.viewAngles.x, pmove.viewAngles.y, pmove.viewAngles.z),
    len(commands))
end function

function predictionEnabled(playerState)
  return (playerState.pmove.flags & cpqc.PMF_NO_PREDICTION) == 0
end function
