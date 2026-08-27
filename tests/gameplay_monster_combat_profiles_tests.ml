/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Stock monster combat-profile coverage plus integrated melee/projectile gates. */
import miniquake2.game.ai.combat_profiles as monstercombatprofiles
import miniquake2.game.null_game as monstercombatgame
import miniquake2.game.constants as monstercombatgameconstants
import miniquake2.qcommon.constants as monstercombatqconstants
import miniquake2.qcommon.types as monstercombatqtypes
import miniquake2.server.game_bridge as monstercombatbridge

// Assert the monster combat test condition.
function monsterCombatAssert(value, label)
  if value != true then return error(9975, label) end if
  return true
end function

// Install monster combat.
function monsterCombatInstall(className, origin)
  monsterCombatServer = monstercombatbridge.createRuntime(4)
  monsterCombatApi = monstercombatgame.GetGameApi(monstercombatbridge.makeImports(monsterCombatServer))
  monsterCombatServer.game = monsterCombatApi
  monsterCombatApi.init()
  monsterCombatFixture = "{ \"classname\" \"worldspawn\" }\n" +
    "{ \"classname\" \"info_player_start\" \"origin\" \"0 0 0\" \"angle\" \"0\" }\n" +
    "{ \"classname\" \"" + className + "\" \"origin\" \"" + origin + "\" \"angle\" \"180\" }"
  monsterCombatApi.spawnEntities("combat-profile", monsterCombatFixture, "")
  monsterCombatClient = monstercombatgame.edictAt(1)
  monsterCombatAssert(monsterCombatApi.clientConnect(monsterCombatClient,
    "\\name\\Target\\skin\\male/grunt"), className + " client connect")
  monsterCombatAssert(monsterCombatApi.clientBegin(monsterCombatClient), className + " client begin")
  return [monsterCombatServer, monsterCombatApi, monsterCombatClient]
end function

// Run monster combat.
function monsterCombatRun(className, origin, frames, expectMelee, expectProjectile)
  // Keep monster combat run phases explicit: validate inputs, update owned state, then publish the result.
  monsterCombatSession = monsterCombatInstall(className, origin)
  monsterCombatServer = monsterCombatSession[0]
  monsterCombatApi = monsterCombatSession[1]
  monsterCombatClient = monsterCombatSession[2]
  monsterCombatRuntime = monstercombatgame.baseRuntime()
  monsterCombatPlayer = monstercombatgame.playerContext().players[0]
  monsterCombatApi.clientThink(monsterCombatClient,
    monstercombatqtypes.UserCmd(0, 0, [0, 0, 0], 0, 0, 0, 0, 64))
  monsterCombatFrame = 0
  while monsterCombatFrame < frames and monsterCombatPlayer.health > 0
    monsterCombatApi.runFrame()
    monsterCombatFrame = monsterCombatFrame + 1
  end while
  monsterCombatActor = monsterCombatRuntime.monsters[0]
  if expectMelee then monsterCombatAssert(monsterCombatActor.meleeCount > 0, className + " melee callback")
  else monsterCombatAssert(monsterCombatActor.attackCount > 0, className + " attack callback")
  end if
  monsterCombatAssert(monsterCombatPlayer.health < 100, className + " damages player")
  if expectProjectile then
    monsterCombatAssert(monsterCombatRuntime.weaponContext.nextProjectileNumber > 1,
      className + " emits projectile")
  end if
  monsterCombatProfile = monstercombatprofiles.stockProfile(className)
  if monsterCombatProfile.muzzleFlash != 0 then
    monsterCombatFlashEvent = void
    for each monsterCombatPendingEvent in monsterCombatServer.pendingMulticasts
      if len(monsterCombatPendingEvent.payload) == 4 and
          monsterCombatPendingEvent.payload[0] == monstercombatqconstants.SVC_MUZZLEFLASH2 and
          monsterCombatPendingEvent.payload[3] == monsterCombatProfile.muzzleFlash then
        monsterCombatFlashEvent = monsterCombatPendingEvent
      end if
    end for
    monsterCombatAssert(monsterCombatFlashEvent is not void,
      className + " queues its multicast muzzle flash")
    monsterCombatAssert(monsterCombatFlashEvent.destination == monstercombatgameconstants.MULTICAST_PVS and
      len(monsterCombatFlashEvent.payload) == 4 and
      monsterCombatFlashEvent.payload[0] == monstercombatqconstants.SVC_MUZZLEFLASH2 and
      monsterCombatFlashEvent.payload[3] == monsterCombatProfile.muzzleFlash,
      className + " multicast muzzle flash framing")
  end if
  monsterCombatApi.clientDisconnect(monsterCombatClient)
  monsterCombatApi.shutdown()
  return true
end function

monsterCombatProfiles = monstercombatprofiles.stockProfiles()
monsterCombatAssert(monstercombatprofiles.validateProfiles(monsterCombatProfiles), "profile registry validation")
monsterCombatExpected = [
  "monster_berserk", "monster_gladiator", "monster_gunner", "monster_infantry",
  "monster_soldier_light", "monster_soldier", "monster_soldier_ss", "monster_tank",
  "monster_tank_commander", "monster_medic", "monster_flipper", "monster_chick",
  "monster_parasite", "monster_flyer", "monster_brain", "monster_floater",
  "monster_hover", "monster_mutant", "monster_supertank", "monster_boss2",
  "monster_jorg", "monster_makron",
]
for each monsterCombatClassName in monsterCombatExpected
  monsterCombatAssert(monstercombatprofiles.stockProfile(monsterCombatClassName) is not void,
    monsterCombatClassName + " profile exists")
end for
monsterCombatAssert(monstercombatprofiles.stockProfile("monster_gladiator").muzzleFlash == 61,
  "gladiator rail uses stock MZ2 id")
monsterCombatAssert(monstercombatprofiles.stockProfile("monster_chick").muzzleFlash == 57,
  "chick rocket uses stock MZ2 id")
monsterCombatAssert(monstercombatprofiles.stockProfile("monster_jorg").muzzleFlash == 126 and
  monstercombatprofiles.stockProfile("monster_makron").muzzleFlash == 119,
  "boss attacks use stock MZ2 ids")
monsterCombatAssert(monstercombatprofiles.stockProfile("misc_insane") is void,
  "non-combat scripted AI has no attack profile")
monsterCombatAssert(monstercombatprofiles.stockProfile("monster_boss3_stand") is void,
  "scripted boss prop has no attack profile")

monsterCombatRun("monster_berserk", "48 0 10", 16, true, false)
// Exact locomotion covers roughly 160 units during HuntTarget's one-second
// attack delay. Keep this fixture at rail range instead of letting the
// Gladiator correctly close from the old stationary 160-unit setup to cleaver.
monsterCombatRun("monster_gladiator", "512 0 10", 24, false, false)
// The complete stock rocket move includes its 13-frame wind-up and possible
// bounded refire tail; leave enough product frames for the projectile impact.
monsterCombatRun("monster_chick", "160 0 10", 64, false, true)
monsterCombatRun("monster_parasite", "96 0 10", 16, false, false)

print "gameplay_monster_combat_profiles_tests: PASS"
