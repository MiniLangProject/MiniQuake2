/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Win32 Quake II 3.19 rand/random/crandom compatibility vectors. */
import miniquake2.game.random as gameplayrandom

// Assert the random parity test condition.
function randomParityAssert(value, message)
  if value != true then return error(9822, message) end if
  return true
end function

randomParityState = gameplayrandom.create(1)
randomParityExpected = [41, 18467, 6334, 26500, 19169, 15724, 11478, 29358]
randomParityIndex = 0
while randomParityIndex < len(randomParityExpected)
  randomParityActual = gameplayrandom.nextInteger(randomParityState)
  randomParityAssert(randomParityActual == randomParityExpected[randomParityIndex],
    "Visual C rand sequence mismatch")
  randomParityIndex = randomParityIndex + 1
end while
randomParityAssert(randomParityState.seed == 1924036713,
  "Visual C rand state mismatch")

randomParityUnitState = gameplayrandom.create(1)
randomParityUnit = gameplayrandom.unit(randomParityUnitState)
randomParitySigned = gameplayrandom.signed(randomParityUnitState)
randomParityAssert(randomParityUnit > 0.0012 and randomParityUnit < 0.0013,
  "Quake random macro mismatch")
randomParityAssert(randomParitySigned > 0.127 and randomParitySigned < 0.128,
  "Quake crandom macro mismatch")

print "gameplay_random_parity_tests: PASS"
