/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
import miniquake2.client.ui.gamepad as gamepadtest

function gamepadAssert(actual, expected, label)
  if actual != expected then return error(9971, label + ": expected " + expected + ", got " + actual) end if
end function

state = gamepadtest.GamepadState(true, true, 12, true, 0, 65535, 0.2, 10.0)
center = gamepadtest.sampleRaw(state, [32768, 32768, 32768, 32768], 0, 65535)
gamepadAssert(center.side, 0.0, "center side dead zone")
gamepadAssert(center.forward, 0.0, "center forward dead zone")
rightAttack = gamepadtest.sampleRaw(state, [65535, 0, 65535, 0], 1, 9000)
gamepadAssert(rightAttack.side, 1.0, "full side")
gamepadAssert(rightAttack.forward, 1.0, "full forward")
gamepadAssert(rightAttack.lookX, 10.0, "full look x")
gamepadAssert(rightAttack.lookY, -10.0, "full look y")
gamepadAssert(rightAttack.pressed, 1, "button edge")
gamepadAssert(rightAttack.povPressed, 2, "pov right edge")
held = gamepadtest.sampleRaw(state, [65535, 0, 65535, 0], 1, 9000)
gamepadAssert(held.pressed, 0, "held button no repeat")
gamepadAssert(held.povPressed, 0, "held pov no repeat")
released = gamepadtest.sampleRaw(state, [32768, 32768, 32768, 32768], 0, 65535)
gamepadAssert(released.released, 1, "button release edge")
print "MiniQuake2 client UI gamepad tests passed: 1"
