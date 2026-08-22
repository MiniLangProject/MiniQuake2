/* New Game difficulty reaches the fresh Game API before level construction. */
package tests.runtime_new_game_skill_tests

import miniquake2.game.null_game as newgameskillgame
import miniquake2.runtime.play_session as newgameskillplay

function newGameSkillAssert(value, name)
  if not value then return error(9941, name) end if
  return true
end function

newGameSkillEntities = "{\"classname\" \"worldspawn\"}" +
  "{\"classname\" \"info_player_start\" \"origin\" \"0 0 24\"}" +
  "{\"classname\" \"monster_tank\" \"origin\" \"128 0 24\"}"

newGameEasySession = newgameskillplay.createCoreAtSkill("newgame_easy",
  newGameSkillEntities, void, "", "\\name\\Easy\\skin\\male/grunt", 0)
newgameskillplay.runUntilActive(newGameEasySession, 500)
newGameSkillAssert(newgameskillgame.configuredGameSkill() == 0 and
  newgameskillgame.baseRuntime().aiContext.skill == 0,
  "easy skill applied before spawn")
newgameskillplay.shutdown(newGameEasySession)

newGameHardSession = newgameskillplay.createCoreAtSkill("newgame_hard",
  newGameSkillEntities, void, "", "\\name\\Hard\\skin\\male/grunt", 2)
newgameskillplay.runUntilActive(newGameHardSession, 500)
newGameSkillAssert(newgameskillgame.configuredGameSkill() == 2 and
  newgameskillgame.baseRuntime().aiContext.skill == 2,
  "hard skill applied to replacement runtime")
newgameskillplay.shutdown(newGameHardSession)

newGameSkillAssert(try(newgameskillplay.createCoreAtSkill("invalid",
  newGameSkillEntities, void, "", "\\name\\Invalid", 4)) is error,
  "invalid skill rejected before session")
print "runtime_new_game_skill_tests: PASS"
