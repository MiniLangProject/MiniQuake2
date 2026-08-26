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
import miniquake2.physics.types as cplocal

struct MovementPrediction
  state
  viewAngles
  commandsReplayed
  previousOrigin
end struct

// Product prediction replays the same bounded command ring every render
// frame. Keep the Pmove graph, touch array, private slide scratch and result
// storage owned by the client session instead of rebuilding them at 125 Hz.
// A predictInto result remains valid until the next call on its workspace.
struct PredictionWorkspace
  pmove
  localState
  result
end struct

function createWorkspace(traceCallback, pointContentsCallback)
  pmove = cppmove.create(traceCallback, pointContentsCallback)
  result = MovementPrediction(pmove.state, pmove.viewAngles, 0, [0, 0, 0])
  return PredictionWorkspace(pmove, cplocal.createLocal(), result)
end function

function copyPmoveStateInto(output, input)
  if typeof(input) != "struct" or typeof(input.origin) != "array" or
      len(input.origin) != 3 or typeof(input.velocity) != "array" or
      len(input.velocity) != 3 or typeof(input.deltaAngles) != "array" or
      len(input.deltaAngles) != 3 then
    return error(7650, "prediction requires valid player movement state")
  end if
  output.moveType = input.moveType
  output.flags = input.flags
  output.time = input.time
  output.gravity = input.gravity
  axis = 0
  while axis < 3
    output.origin[axis] = input.origin[axis]
    output.velocity[axis] = input.velocity[axis]
    output.deltaAngles[axis] = input.deltaAngles[axis]
    axis = axis + 1
  end while
  return output
end function

function copyUserCmdInto(output, input)
  if typeof(input) != "struct" or typeof(input.angles) != "array" or
      len(input.angles) != 3 then
    return error(7652, "prediction command is malformed")
  end if
  output.msec = input.msec
  output.buttons = input.buttons
  output.forwardMove = input.forwardMove
  output.sideMove = input.sideMove
  output.upMove = input.upMove
  output.impulse = input.impulse
  output.lightLevel = input.lightLevel
  output.angles[0] = input.angles[0]
  output.angles[1] = input.angles[1]
  output.angles[2] = input.angles[2]
  return output
end function

function predictInto(workspace, playerState, commands, commandCount,
    airAcceleration)
  if typeof(workspace) != "struct" or typeof(playerState) != "struct" then
    return error(7650, "prediction requires workspace and player state")
  end if
  if typeof(commands) != "array" or typeof(commandCount) != "int" or
      commandCount < 0 or commandCount > len(commands) then
    return error(7651, "prediction command range is invalid")
  end if
  pmove = workspace.pmove
  copiedState = try(copyPmoveStateInto(pmove.state, playerState.pmove))
  if copiedState is error then return copiedState end if
  previousOrigin = workspace.result.previousOrigin
  previousOrigin[0] = pmove.state.origin[0]
  previousOrigin[1] = pmove.state.origin[1]
  previousOrigin[2] = pmove.state.origin[2]
  index = 0
  while index < commandCount
    previousOrigin[0] = pmove.state.origin[0]
    previousOrigin[1] = pmove.state.origin[1]
    previousOrigin[2] = pmove.state.origin[2]
    copiedCommand = try(copyUserCmdInto(pmove.command, commands[index]))
    if copiedCommand is error then return copiedCommand end if
    moved = try(cppmove.moveWithAirAccelerationUsingLocal(pmove,
      airAcceleration, workspace.localState))
    if moved is error then return moved end if
    index = index + 1
  end while
  if commandCount == 0 then
    pmove.viewAngles.x = playerState.viewAngles[0]
    pmove.viewAngles.y = playerState.viewAngles[1]
    pmove.viewAngles.z = playerState.viewAngles[2]
  end if
  workspace.result.commandsReplayed = commandCount
  return workspace.result
end function

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

function inline signedShort(value)
  while value > 32767
    value = value - 65536
  end while
  while value < -32768
    value = value + 65536
  end while
  return value
end function

// The PMF_NO_PREDICTION branch still updates view angles from the current
// command; only origin replay is disabled. This is the managed equivalent of
// cl.viewangles + SHORT2ANGLE(delta_angles) in CL_PredictMovement.
function commandViewAngles(playerState, command)
  if command is void then
    return cpqt.vec3(playerState.viewAngles[0], playerState.viewAngles[1],
      playerState.viewAngles[2])
  end if
  if typeof(command) != "struct" or typeof(command.angles) != "array" or
      len(command.angles) != 3 then
    return error(7653, "prediction fallback command is malformed")
  end if
  return cpqt.vec3(
    shortToAngle(signedShort(command.angles[0] +
      playerState.pmove.deltaAngles[0])),
    shortToAngle(signedShort(command.angles[1] +
      playerState.pmove.deltaAngles[1])),
    shortToAngle(signedShort(command.angles[2] +
      playerState.pmove.deltaAngles[2])))
end function

function predict(playerState, commands, traceCallback, pointContentsCallback,
    airAcceleration)
  if typeof(playerState) != "struct" then return error(7650, "prediction requires player state") end if
  if typeof(commands) != "array" then return error(7651, "prediction commands must be an array") end if
  pmove = cppmove.create(traceCallback, pointContentsCallback)
  pmove.state = cppt.copyPmoveState(playerState.pmove)
  previousOrigin = [pmove.state.origin[0], pmove.state.origin[1],
    pmove.state.origin[2]]
  index = 0
  while index < len(commands)
    command = commands[index]
    if typeof(command) != "struct" then return error(7652, "prediction command is malformed") end if
    previousOrigin = [pmove.state.origin[0], pmove.state.origin[1],
      pmove.state.origin[2]]
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
    len(commands), previousOrigin)
end function

function predictionEnabled(playerState)
  return (playerState.pmove.flags & cpqc.PMF_NO_PREDICTION) == 0
end function
