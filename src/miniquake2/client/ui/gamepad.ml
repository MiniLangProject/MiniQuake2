//! Provides miniquake2 client ui gamepad facilities for this project.

/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* WinMM joystick/controller sampling with deterministic dead-zone mapping. */
package miniquake2.client.ui.gamepad

import miniquake2.native as gamepadnative

/// Store gamepad state data.
struct GamepadState
  /// Stores the enabled value associated with gamepad state.
  enabled
  /// Stores the available value associated with gamepad state.
  available
  /// Stores the button count value associated with gamepad state.
  buttonCount
  /// Indicates whether has pov is active for the gamepad state value.
  hasPov
  /// Stores the old buttons value associated with gamepad state.
  oldButtons
  /// Stores the old pov value associated with gamepad state.
  oldPov
  /// Stores the dead zone value associated with gamepad state.
  deadZone
  /// Stores the look scale value associated with gamepad state.
  lookScale
end struct

/// Store gamepad sample data.
struct GamepadSample
  /// Stores the connected value associated with gamepad sample.
  connected
  /// Stores the side value associated with gamepad sample.
  side
  /// Stores the forward value associated with gamepad sample.
  forward
  /// Stores the look x value associated with gamepad sample.
  lookX
  /// Stores the look y value associated with gamepad sample.
  lookY
  /// Stores the buttons value associated with gamepad sample.
  buttons
  /// Stores the pressed value associated with gamepad sample.
  pressed
  /// Stores the released value associated with gamepad sample.
  released
  /// Stores the pov value associated with gamepad sample.
  pov
  /// Stores the pov pressed value associated with gamepad sample.
  povPressed
end struct

/// Creates create for the miniquake2 client ui gamepad module.
/// @param enabled enabled value consumed by this operation.
function create(enabled)
  if typeof(enabled) != "bool" then return error(8310, "gamepad enabled state must be boolean") end if
  available = false
  buttons = 0
  hasPov = false
  if enabled then
    available = gamepadnative.winJoyStartup() != 0
    if available then
      buttons = gamepadnative.winJoyButtonCount()
      hasPov = gamepadnative.winJoyHasPov() != 0
    end if
  end if
  return GamepadState(enabled, available, buttons, hasPov, 0, 65535,
    0.18, 30.0)
end function

/// Normalize axis.
/// @param raw raw value consumed by this operation.
/// @param deadZone deadZone value consumed by this operation.
function inline normalizeAxis(raw, deadZone)
  value = (raw - 32768) / 32767.0
  if value < -1.0 then value = -1.0 end if
  if value > 1.0 then value = 1.0 end if
  magnitude = value
  if magnitude < 0.0 then magnitude = -magnitude end if
  if magnitude <= deadZone then return 0.0 end if
  scaled = (magnitude - deadZone) / (1.0 - deadZone)
  if value < 0.0 then return -scaled end if
  return scaled
end function

/// Sample raw.
/// @param state Mutable state inspected or updated by the operation.
/// @param axes axes value consumed by this operation.
/// @param buttons buttons value consumed by this operation.
/// @param pov pov value consumed by this operation.
function sampleRaw(state, axes, buttons, pov)
  if typeof(axes) != "array" or len(axes) < 4 then
    return error(8311, "gamepad sample requires at least four axes")
  end if
  side = normalizeAxis(axes[0], state.deadZone)
  forward = -normalizeAxis(axes[1], state.deadZone)
  lookX = normalizeAxis(axes[2], state.deadZone) * state.lookScale
  lookY = normalizeAxis(axes[3], state.deadZone) * state.lookScale
  pressed = buttons & (~state.oldButtons)
  released = state.oldButtons & (~buttons)
  povPressed = 0
  if pov != state.oldPov then
    if pov == 0 then povPressed = 1
    else if pov == 9000 then povPressed = 2
    else if pov == 18000 then povPressed = 4
    else if pov == 27000 then povPressed = 8
    end if
  end if
  state.oldButtons = buttons
  state.oldPov = pov
  return GamepadSample(true, side, forward, lookX, lookY, buttons,
    pressed, released, pov, povPressed)
end function

/// Performs the poll operation for the miniquake2 client ui gamepad module.
/// @param state Mutable state inspected or updated by the operation.
function poll(state)
  if state is void or not state.enabled or not state.available then
    return GamepadSample(false, 0.0, 0.0, 0.0, 0.0, 0, 0, 0, 65535, 0)
  end if
  if gamepadnative.winJoyRead() == 0 then
    state.available = false
    return GamepadSample(false, 0.0, 0.0, 0.0, 0.0, 0, 0, 0, 65535, 0)
  end if
  // WinMM exposes X/Y/Z/R/U/V. X/Y are movement and Z/R are the common
  // right-stick mapping used by XInput-compatible controllers.
  axes = [gamepadnative.winJoyAxis(0), gamepadnative.winJoyAxis(1),
    gamepadnative.winJoyAxis(2), gamepadnative.winJoyAxis(3)]
  pov = 65535
  if state.hasPov then pov = gamepadnative.winJoyPov() end if
  return sampleRaw(state, axes, gamepadnative.winJoyButtons(), pov)
end function
