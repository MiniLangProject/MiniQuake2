/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Authoritative single-player pause while server transport epochs stay live. */
import miniquake2.game.null_game as pausetestgame
import miniquake2.runtime.server_session as pausetestsession

function pauseAssert(value, message)
  if not value then return error(9987, message) end if
  return true
end function

entityText = "{ \"classname\" \"worldspawn\" } " +
  "{ \"classname\" \"info_player_start\" \"origin\" \"0 0 24\" }"

single = pausetestsession.createCore("pause-unit", entityText, void,
  "127.0.0.1", 0, 1, false)
pausetestsession.step(single)
gameBeforePause = pausetestgame.lifecycleSnapshot()[4]
serverBeforePause = single.frameNumber
pauseAssert(pausetestsession.setPaused(single, true),
  "single-player pause was not enabled")
pausetestsession.step(single)
pausetestsession.step(single)
pauseAssert(single.frameNumber == serverBeforePause + 2,
  "paused server packet/frame epoch stopped")
pauseAssert(pausetestgame.lifecycleSnapshot()[4] == gameBeforePause,
  "paused Game API world advanced")
pauseAssert(pausetestsession.setPaused(single, false) == false,
  "single-player pause did not clear")
pausetestsession.step(single)
pauseAssert(pausetestgame.lifecycleSnapshot()[4] == gameBeforePause + 1,
  "unpaused Game API world did not resume")
pausetestsession.shutdown(single)

multi = pausetestsession.createCore("pause-multi-unit", entityText, void,
  "127.0.0.1", 0, 2, true)
multiBefore = pausetestgame.lifecycleSnapshot()[4]
pauseAssert(pausetestsession.setPaused(multi, true) == false and not multi.paused,
  "multiplayer server accepted pause")
pausetestsession.step(multi)
pauseAssert(pausetestgame.lifecycleSnapshot()[4] == multiBefore + 1,
  "multiplayer world was paused")
pausetestsession.shutdown(multi)

print "runtime_singleplayer_pause_tests: PASS"
