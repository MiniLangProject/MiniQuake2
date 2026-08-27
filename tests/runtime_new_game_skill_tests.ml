/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* New Game difficulty reaches the fresh Game API before level construction. */
package tests.runtime_new_game_skill_tests

import miniquake2.game.null_game as newgameskillgame
import miniquake2.game.integration.baseq2 as newgameskillintegration
import miniquake2.game.gameplay.types as newgameskilltypes
import miniquake2.runtime.play_session as newgameskillplay

// Assert the new game skill test condition.
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
newGameEasyContext = newgameskillgame.playerContext()
newGameEasyPlayer = newGameEasyContext.players[0]
newGameEasyHealth = newGameEasyPlayer.health
newGameEasyTaken = newGameEasyContext.damagePlayer(newGameEasyContext,
  newGameEasyPlayer, 10, 0, "skill-test")
newGameSkillAssert(newGameEasyTaken == 5 and
    newGameEasyPlayer.health == newGameEasyHealth - 5,
  "easy skill halves live incoming player damage")
newGameEasyWeaponTarget = newgameskillintegration.playerWeaponTarget(
  newGameEasyPlayer, newGameEasyContext.registry)
newGameEasyWeaponRequest = newgameskilltypes.damageRequest(
  [1.0, 0.0, 0.0], [0.0, 0.0, 0.0], 5, 0, 0, "easy-weapon")
newGameEasyWeaponResult = newgameskillintegration.integratedWeaponDamage(
  newGameEasyWeaponTarget.combatant, newGameEasyWeaponRequest)
newGameSkillAssert(newGameEasyWeaponResult.taken == 2,
  "easy skill halves odd weapon-path player damage")
newGameEasyMinimumTarget = newgameskillintegration.playerWeaponTarget(
  newGameEasyPlayer, newGameEasyContext.registry)
newGameEasyMinimumRequest = newgameskilltypes.damageRequest(
  [1.0, 0.0, 0.0], [0.0, 0.0, 0.0], 1, 0, 0, "easy-minimum")
newGameEasyMinimumResult = newgameskillintegration.integratedWeaponDamage(
  newGameEasyMinimumTarget.combatant, newGameEasyMinimumRequest)
newGameSkillAssert(newGameEasyMinimumResult.taken == 1,
  "easy skill preserves one-damage minimum")
newGameEasyMonsterTarget = newgameskillintegration.monsterWeaponTarget(
  newgameskillgame.baseRuntime().monsters[0])
newGameEasyMonsterRequest = newgameskilltypes.damageRequest(
  [1.0, 0.0, 0.0], [0.0, 0.0, 0.0], 5, 0, 0, "easy-monster")
newGameEasyMonsterResult = newgameskillintegration.integratedWeaponDamage(
  newGameEasyMonsterTarget.combatant, newGameEasyMonsterRequest)
newGameSkillAssert(newGameEasyMonsterResult.taken == 5,
  "easy skill does not halve damage against monsters")
newgameskillplay.shutdown(newGameEasySession)

newGameHardSession = newgameskillplay.createCoreAtSkill("newgame_hard",
  newGameSkillEntities, void, "", "\\name\\Hard\\skin\\male/grunt", 2)
newgameskillplay.runUntilActive(newGameHardSession, 500)
newGameSkillAssert(newgameskillgame.configuredGameSkill() == 2 and
  newgameskillgame.baseRuntime().aiContext.skill == 2,
  "hard skill applied to replacement runtime")
newGameHardContext = newgameskillgame.playerContext()
newGameHardPlayer = newGameHardContext.players[0]
newGameHardHealth = newGameHardPlayer.health
newGameHardTaken = newGameHardContext.damagePlayer(newGameHardContext,
  newGameHardPlayer, 10, 0, "skill-test")
newGameSkillAssert(newGameHardTaken == 10 and
    newGameHardPlayer.health == newGameHardHealth - 10,
  "non-easy skill retains full incoming player damage")
newGameHardWeaponTarget = newgameskillintegration.playerWeaponTarget(
  newGameHardPlayer, newGameHardContext.registry)
newGameHardWeaponRequest = newgameskilltypes.damageRequest(
  [1.0, 0.0, 0.0], [0.0, 0.0, 0.0], 5, 0, 0, "hard-weapon")
newGameHardWeaponResult = newgameskillintegration.integratedWeaponDamage(
  newGameHardWeaponTarget.combatant, newGameHardWeaponRequest)
newGameSkillAssert(newGameHardWeaponResult.taken == 5,
  "non-easy skill retains full weapon-path player damage")
newgameskillplay.shutdown(newGameHardSession)

newGameSkillAssert(try(newgameskillplay.createCoreAtSkill("invalid",
  newGameSkillEntities, void, "", "\\name\\Invalid", 4)) is error,
  "invalid skill rejected before session")
print "runtime_new_game_skill_tests: PASS"
