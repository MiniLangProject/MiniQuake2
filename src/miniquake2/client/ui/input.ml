//! Provides miniquake2 client ui input facilities for this project.

/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Deterministic CL_CreateCmd input accumulation. */
package miniquake2.client.ui.input

import miniquake2.client.ui.constants as cuic
import miniquake2.client.ui.keys as cuikeys
import miniquake2.qcommon.types as qt
import std.math as smath

/// Performs the action operation for the miniquake2 client ui input module.
/// @param state Mutable state inspected or updated by the operation.
/// @param name Name of the affected item.
function action(state, name)
  value = cuikeys.findAction(state, name)
  if value is void or value.down == false then return 0.0 end if
  return 1.0
end function

/// Return the fraction of this command interval for which an action was held.
/// Key-up events contribute their exact timestamped duration; a still-held key
/// contributes from its last down time through the command endpoint.
/// @param state Mutable state inspected or updated by the operation.
/// @param name Name of the affected item.
/// @param frameMsec frameMsec value consumed by this operation.
/// @param consume consume value consumed by this operation.
function actionFraction(state, name, frameMsec, consume)
  value = cuikeys.findAction(state, name)
  if value is void then return 0.0 end if
  frameStart = state.commandTime
  if frameStart < 0 then frameStart = 0 end if
  frameEnd = frameStart + frameMsec
  heldMsec = value.msec
  if value.down then
    heldStart = value.downTime
    if heldStart < frameStart then heldStart = frameStart end if
    if heldStart < frameEnd then heldMsec = heldMsec + frameEnd - heldStart end if
  end if
  fraction = heldMsec / (frameMsec * 1.0)
  if fraction < 0.0 then fraction = 0.0 end if
  if fraction > 1.0 then fraction = 1.0 end if
  if consume then
    value.msec = 0
    if value.down then value.downTime = frameEnd end if
  end if
  return fraction
end function

/// Add mouse delta.
/// @param state Mutable state inspected or updated by the operation.
/// @param dx dx value consumed by this operation.
/// @param dy dy value consumed by this operation.
function addMouseDelta(state, dx, dy)
  state.mouseDx = state.mouseDx + dx
  state.mouseDy = state.mouseDy + dy
  return true
end function

/// Set impulse.
/// @param state Mutable state inspected or updated by the operation.
/// @param value Value consumed or transformed by the operation.
function setImpulse(state, value)
  if value < 0 or value > 255 then return error(8210, "impulse outside byte range") end if
  state.impulse = value
  return true
end function

/// Clamp pitch.
/// @param state Mutable state inspected or updated by the operation.
function clampPitch(state)
  if state.viewAngles[0] > 89.0 then state.viewAngles[0] = 89.0 end if
  if state.viewAngles[0] < -89.0 then state.viewAngles[0] = -89.0 end if
end function

/// Clamp command msec.
/// @param frameMsec frameMsec value consumed by this operation.
function inline clampCommandMsec(frameMsec)
  if frameMsec < 1 then return 1 end if
  if frameMsec > 200 then return 200 end if
  return frameMsec
end function

/// Return the angle short value.
/// @param value Value consumed or transformed by the operation.
function angleShort(value)
  scaled = value * 65536.0 / 360.0
  result = 0
  if scaled < 0.0 then result = -smath.floor(-scaled) else result = smath.floor(scaled) end if
  result = result & 65535
  if result >= 32768 then result = result - 65536 end if
  return result
end function

/// Apply view changes independently from the network command cadence.  The
/// product samples this once per rendered frame, matching Quake II's
/// CL_AdjustAngles/IN_Move split and removing the former 100 ms mouse-look lag.
/// Mouse axes routed to strafe/klook deliberately remain accumulated until the
/// next UserCmd because those axes are movement rather than view input.
/// @param state Mutable state inspected or updated by the operation.
/// @param frameMsec frameMsec value consumed by this operation.
function sampleView(state, frameMsec)
  frameMsec = clampCommandMsec(frameMsec)
  seconds = frameMsec / 1000.0
  cfg = state.config
  angleScale = seconds
  if action(state, "speed") > 0.0 then angleScale = angleScale * cfg.angleSpeedKey end if
  strafing = action(state, "strafe") > 0.0
  klook = action(state, "klook") > 0.0

  if strafing == false then
    state.viewAngles[1] = state.viewAngles[1] - angleScale * cfg.yawSpeed * action(state, "right")
    state.viewAngles[1] = state.viewAngles[1] + angleScale * cfg.yawSpeed * action(state, "left")
  end if
  if klook then
    state.viewAngles[0] = state.viewAngles[0] - angleScale * cfg.pitchSpeed * action(state, "forward")
    state.viewAngles[0] = state.viewAngles[0] + angleScale * cfg.pitchSpeed * action(state, "back")
  end if
  state.viewAngles[0] = state.viewAngles[0] - angleScale * cfg.pitchSpeed * action(state, "lookup")
  state.viewAngles[0] = state.viewAngles[0] + angleScale * cfg.pitchSpeed * action(state, "lookdown")

  mouseX = state.mouseDx * cfg.sensitivity
  mouseY = state.mouseDy * cfg.sensitivity
  if strafing == false then
    state.viewAngles[1] = state.viewAngles[1] - cfg.mouseYaw * mouseX
    state.mouseDx = 0.0
  end if
  if klook == false then
    state.viewAngles[0] = state.viewAngles[0] + cfg.mousePitch * mouseY
    state.mouseDy = 0.0
  end if
  clampPitch(state)
  return true
end function

/// Construct a command after sampleView has already consumed this render
/// frame's look input.  consumeTransient=false is the side-effect-free preview
/// used by client prediction between network ticks.
/// @param state Mutable state inspected or updated by the operation.
/// @param frameMsec frameMsec value consumed by this operation.
/// @param consumeTransient consumeTransient value consumed by this operation.
function buildSampledUserCmd(state, frameMsec, consumeTransient)
  frameMsec = clampCommandMsec(frameMsec)
  cfg = state.config
  strafing = action(state, "strafe") > 0.0
  klook = action(state, "klook") > 0.0
  moveUpFraction = actionFraction(state, "moveup", frameMsec, consumeTransient)
  moveDownFraction = actionFraction(state, "movedown", frameMsec, consumeTransient)
  rightFraction = actionFraction(state, "right", frameMsec, consumeTransient)
  leftFraction = actionFraction(state, "left", frameMsec, consumeTransient)
  moveRightFraction = actionFraction(state, "moveright", frameMsec, consumeTransient)
  moveLeftFraction = actionFraction(state, "moveleft", frameMsec, consumeTransient)
  forwardFraction = actionFraction(state, "forward", frameMsec, consumeTransient)
  backFraction = actionFraction(state, "back", frameMsec, consumeTransient)

  forward = 0.0
  side = 0.0
  up = cfg.upSpeed * (moveUpFraction - moveDownFraction)
  forward = forward + cfg.forwardSpeed * state.controllerForward
  side = side + cfg.sideSpeed * state.controllerSide
  if (state.controllerButtons & 4) != 0 then up = up + cfg.upSpeed end if
  if (state.controllerButtons & 8) != 0 then up = up - cfg.upSpeed end if
  if strafing then side = side + cfg.sideSpeed * (rightFraction - leftFraction) end if
  side = side + cfg.sideSpeed * (moveRightFraction - moveLeftFraction)
  if klook == false then forward = forward + cfg.forwardSpeed *
    (forwardFraction - backFraction) end if

  // Axes left behind by sampleView are strafe/klook movement.  A prediction
  // preview observes them without consuming them; the transmitted command is
  // the single owner that clears the accumulators.
  mouseX = state.mouseDx * cfg.sensitivity
  mouseY = state.mouseDy * cfg.sensitivity
  if strafing then side = side + cfg.mouseSide * mouseX end if
  if klook then forward = forward - cfg.mouseForward * mouseY end if
  if consumeTransient then state.mouseDx = 0.0; state.mouseDy = 0.0 end if

  running = cfg.alwaysRun
  if action(state, "speed") > 0.0 then running = running == false end if
  if running then forward = forward * 2.0; side = side * 2.0; up = up * 2.0 end if

  buttons = 0
  attack = cuikeys.findAction(state, "attack")
  if attack.down or attack.pressed or (state.controllerButtons & 1) != 0 then
    buttons = buttons | cuic.BUTTON_ATTACK
  end if
  if consumeTransient then attack.pressed = false end if
  useAction = cuikeys.findAction(state, "use")
  if useAction.down or useAction.pressed or (state.controllerButtons & 2) != 0 then
    buttons = buttons | cuic.BUTTON_USE
  end if
  if consumeTransient then useAction.pressed = false end if
  if state.destination == cuic.KEY_GAME then
    for each keyDown in state.keys
      if keyDown then buttons = buttons | cuic.BUTTON_ANY end if
    end for
    if state.controllerButtons != 0 then buttons = buttons | cuic.BUTTON_ANY end if
  end if

  impulse = state.impulse
  if consumeTransient then state.impulse = 0 end if
  if consumeTransient then
    if state.commandTime < 0 then state.commandTime = 0 end if
    state.commandTime = state.commandTime + frameMsec
  end if
  return qt.UserCmd(frameMsec, buttons,
    [angleShort(state.viewAngles[0]), angleShort(state.viewAngles[1]), angleShort(state.viewAngles[2])],
    forward, side, up, impulse, state.lightLevel)
end function

/// Create sampled user cmd.
/// @param state Mutable state inspected or updated by the operation.
/// @param frameMsec frameMsec value consumed by this operation.
function createSampledUserCmd(state, frameMsec)
  return buildSampledUserCmd(state, frameMsec, true)
end function

/// Return the preview user cmd value.
/// @param state Mutable state inspected or updated by the operation.
/// @param frameMsec frameMsec value consumed by this operation.
function previewUserCmd(state, frameMsec)
  return buildSampledUserCmd(state, frameMsec, false)
end function

/// Create user cmd.
/// @param state Mutable state inspected or updated by the operation.
/// @param frameMsec frameMsec value consumed by this operation.
function createUserCmd(state, frameMsec)
  sampleView(state, frameMsec)
  return createSampledUserCmd(state, frameMsec)
end function
