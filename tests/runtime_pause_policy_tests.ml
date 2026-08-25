import miniquake2.runtime.pause_policy as pausetest
import miniquake2.client.ui.constants as pauseconstants

function pauseAssert(actual, expected, label)
  if actual != expected then return error(9976, label + ": expected " + expected + ", got " + actual) end if
end function

pauseAssert(pausetest.shouldPause(1, true, pauseconstants.KEY_MENU), true, "singleplayer menu")
pauseAssert(pausetest.shouldPause(1, true, pauseconstants.KEY_CONSOLE), true, "singleplayer console")
pauseAssert(pausetest.shouldPause(1, true, pauseconstants.KEY_GAME), false, "singleplayer gameplay")
pauseAssert(pausetest.shouldPause(1, true, pauseconstants.KEY_MESSAGE), false, "chat does not pause")
pauseAssert(pausetest.shouldPause(4, true, pauseconstants.KEY_MENU), false, "multiplayer menu")
pauseAssert(pausetest.shouldPause(1, false, pauseconstants.KEY_MENU), false, "inactive server")
print "MiniQuake2 runtime pause policy tests passed: 1"
