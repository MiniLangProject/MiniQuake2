/* Deterministic CL_CreateCmd input accumulation. */
package miniquake2.client.ui.input

import miniquake2.client.ui.constants as cuic
import miniquake2.client.ui.keys as cuikeys
import miniquake2.qcommon.types as qt
import std.math as smath

function action(state, name)
  value = cuikeys.findAction(state, name)
  if value is void or value.down == false then return 0.0 end if
  return 1.0
end function

function addMouseDelta(state, dx, dy)
  state.mouseDx = state.mouseDx + dx
  state.mouseDy = state.mouseDy + dy
  return true
end function

function setImpulse(state, value)
  if value < 0 or value > 255 then return error(8210, "impulse outside byte range") end if
  state.impulse = value
  return true
end function

function clampPitch(state)
  if state.viewAngles[0] > 89.0 then state.viewAngles[0] = 89.0 end if
  if state.viewAngles[0] < -89.0 then state.viewAngles[0] = -89.0 end if
end function

function angleShort(value)
  scaled = value * 65536.0 / 360.0
  result = 0
  if scaled < 0.0 then result = -smath.floor(-scaled) else result = smath.floor(scaled) end if
  result = result & 65535
  if result >= 32768 then result = result - 65536 end if
  return result
end function

function createUserCmd(state, frameMsec)
  if frameMsec < 1 then frameMsec = 1 end if
  if frameMsec > 200 then frameMsec = 200 end if
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

  forward = 0.0
  side = 0.0
  up = cfg.upSpeed * (action(state, "moveup") - action(state, "movedown"))
  if strafing then side = side + cfg.sideSpeed * (action(state, "right") - action(state, "left")) end if
  side = side + cfg.sideSpeed * (action(state, "moveright") - action(state, "moveleft"))
  if klook == false then forward = cfg.forwardSpeed * (action(state, "forward") - action(state, "back")) end if

  // Win32 provides raw motion separately from button InputEvents. Accumulation
  // here keeps that platform boundary narrow and makes command creation pure.
  mouseX = state.mouseDx * cfg.sensitivity
  mouseY = state.mouseDy * cfg.sensitivity
  if strafing then side = side + cfg.mouseSide * mouseX
  else state.viewAngles[1] = state.viewAngles[1] - cfg.mouseYaw * mouseX
  end if
  if klook then forward = forward - cfg.mouseForward * mouseY
  else state.viewAngles[0] = state.viewAngles[0] + cfg.mousePitch * mouseY
  end if
  state.mouseDx = 0.0
  state.mouseDy = 0.0

  running = cfg.alwaysRun
  if action(state, "speed") > 0.0 then running = running == false end if
  if running then forward = forward * 2.0; side = side * 2.0; up = up * 2.0 end if
  clampPitch(state)

  buttons = 0
  attack = cuikeys.findAction(state, "attack")
  if attack.down or attack.pressed then buttons = buttons | cuic.BUTTON_ATTACK end if
  attack.pressed = false
  useAction = cuikeys.findAction(state, "use")
  if useAction.down or useAction.pressed then buttons = buttons | cuic.BUTTON_USE end if
  useAction.pressed = false
  if state.destination == cuic.KEY_GAME then
    for each keyDown in state.keys
      if keyDown then buttons = buttons | cuic.BUTTON_ANY end if
    end for
  end if

  impulse = state.impulse
  state.impulse = 0
  return qt.UserCmd(frameMsec, buttons,
    [angleShort(state.viewAngles[0]), angleShort(state.viewAngles[1]), angleShort(state.viewAngles[2])],
    forward, side, up, impulse, state.lightLevel)
end function
