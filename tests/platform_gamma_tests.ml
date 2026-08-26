/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
import miniquake2.platform.gamma as gammatest

function gammaAssert(actual, expected, label)
  if actual != expected then return error(9970, label + ": expected " + expected + ", got " + actual) end if
end function

ramp = gammatest.buildRamp(1.0)
gammaAssert(len(ramp), 1536, "ramp bytes")
gammaAssert(ramp[0], 0, "black low")
gammaAssert(ramp[1], 0, "black high")
gammaAssert(ramp[256], 128, "midpoint low")
gammaAssert(ramp[257], 128, "midpoint high")
gammaAssert(ramp[510], 255, "white low")
gammaAssert(ramp[511], 255, "white high")
gammaAssert(typeof(try(gammatest.buildRamp(0.49))), "error", "low gamma rejected")
gammaAssert(typeof(try(gammatest.buildRamp(2.01))), "error", "high gamma rejected")
print "MiniQuake2 platform gamma tests passed: 1"
