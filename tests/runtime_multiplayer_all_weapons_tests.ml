/* Every stock weapon fired by a real two-client UDP UserCmd session. */
import miniquake2.network.constants as mpweaponnetwork
import miniquake2.qcommon.types as mpweaponqtypes
import miniquake2.game.constants as mpweapongameconstants
import miniquake2.game.gameplay.constants as mpweapongameplayconstants
import miniquake2.game.gameplay.item_rules as mpweaponitems
import miniquake2.game.player.constants as mpweaponplayerconstants
import miniquake2.game.null_game as mpweapongame
import miniquake2.runtime.multiplayer_session as mpweaponsession

function mpweaponAssert(value, name)
  if not value then return error(8424, name) end if
  return true
end function

function mpweaponEquip(player, registry, className, ammunition)
  mpweaponEquipped = mpweaponitems.findByClassName(registry, className)
  if mpweaponEquipped is void then return error(8425, "missing stock weapon " + className) end if
  player.gameplay.inventory.counts[mpweaponEquipped.index] = 1
  player.gameplay.currentWeapon = mpweaponEquipped
  player.gameplay.newWeapon = void
  player.gameplay.weaponState = mpweapongameplayconstants.WEAPON_READY
  player.gameplay.gunFrame = 16
  if mpweaponEquipped.weaponFrames is not void then
    player.gameplay.gunFrame = mpweaponEquipped.weaponFrames.fireLast + 1
  end if
  player.edict.client.playerState.gunFrame = player.gameplay.gunFrame
  player.gameplay.ammoIndex = 0
  if mpweaponEquipped.ammo != "" then
    mpweaponAmmo = mpweaponitems.findByPickupName(registry,
      mpweaponEquipped.ammo)
    if mpweaponAmmo is void then
      return error(8426, "missing stock ammunition " + mpweaponEquipped.ammo)
    end if
    player.gameplay.ammoIndex = mpweaponAmmo.index
    player.gameplay.inventory.counts[mpweaponAmmo.index] = ammunition
  end if
  player.handGrenadeState = void
  player.buttons = 0
  player.oldButtons = 0
  player.latchedButtons = 0
  player.gameplay.buttons = 0
  player.gameplay.latchedButtons = 0
  return mpweaponEquipped
end function

function mpweaponSawMuzzle(session, clientIndex, entityNumber)
  for each mpweaponHandoff in session.clients[clientIndex].integrated.frameHandoffs
    for each mpweaponLight in mpweaponHandoff.dLights
      if mpweaponLight.key == entityNumber then return true end if
    end for
  end for
  return false
end function

mpweaponEntities = "{\n\"classname\" \"worldspawn\"\n\"message\" \"All Weapons UDP\"\n}\n" +
  "{\n\"classname\" \"info_player_deathmatch\"\n\"origin\" \"0 0 64\"\n}\n" +
  "{\n\"classname\" \"info_player_deathmatch\"\n\"origin\" \"128 0 64\"\n}\n" +
  "{\n\"classname\" \"info_player_deathmatch\"\n\"origin\" \"256 0 64\"\n}\n"
mpweaponSession = mpweaponsession.createCore(mpweaponsession.MODE_DEATHMATCH,
  "dm_all_weapons", mpweaponEntities, void,
  ["\\name\\Arsenal\\skin\\male/grunt",
   "\\name\\Target\\skin\\female/athena"])
mpweaponsession.runUntilActive(mpweaponSession, 500)
mpweaponAttacker = mpweaponsession.player(mpweaponSession, 0)
mpweaponVictim = mpweaponsession.player(mpweaponSession, 1)
mpweaponContext = mpweapongame.playerContext()
mpweaponRuntime = mpweapongame.baseRuntime()
mpweaponRegistry = mpweaponContext.registry
mpweaponClasses = ["weapon_blaster", "weapon_shotgun", "weapon_supershotgun",
  "weapon_machinegun", "weapon_chaingun", "ammo_grenades",
  "weapon_grenadelauncher", "weapon_rocketlauncher",
  "weapon_hyperblaster", "weapon_railgun", "weapon_bfg"]
mpweaponAmmoCosts = [0, 1, 2, 1, 1, 1, 1, 1, 1, 1, 50]
mpweaponIndex = 0
while mpweaponIndex < len(mpweaponClasses)
  mpweaponClass = mpweaponClasses[mpweaponIndex]
  mpweaponAssert(mpweaponsession.prepareDuel(mpweaponSession, 0, 1, 96),
    "weapon duel reset failed: " + mpweaponClass)
  mpweaponVictim.health = 10000
  mpweaponVictim.gameplay.health = 10000
  mpweaponVictim.maxHealth = 10000
  mpweaponVictim.deadFlag = mpweaponplayerconstants.DEAD_NO
  mpweaponVictim.edict.takeDamage = true
  mpweaponItem = mpweaponEquip(mpweaponAttacker, mpweaponRegistry,
    mpweaponClass, 200)
  mpweaponFireBefore = mpweaponAttacker.gameplay.fireCount
  mpweaponProjectilesBefore = len(mpweaponRuntime.weaponContext.projectiles)
  mpweaponAmmoBefore = 0
  if mpweaponAttacker.gameplay.ammoIndex != 0 then
    mpweaponAmmoBefore = mpweaponAttacker.gameplay.inventory.counts[
      mpweaponAttacker.gameplay.ammoIndex]
  end if
  mpweaponSession.clients[0].integrated.frameHandoffs = []
  mpweaponSession.clients[1].integrated.frameHandoffs = []
  mpweaponClientSequenceBefore = mpweaponSession.clients[0].integrated.network.client.channel.outgoingSequence
  mpweaponCommand = mpweaponqtypes.UserCmd(100,
    mpweapongameconstants.BUTTON_ATTACK, [0, 0, 0], 0, 0, 0, 0, 64)
  mpweaponsession.queueUserCmd(mpweaponSession, 0, mpweaponCommand)
  mpweaponFireSteps = 0
  mpweaponFired = false
  while not mpweaponFired and mpweaponFireSteps < 32
    mpweaponsession.step(mpweaponSession)
    if mpweaponClass == "ammo_grenades" then
      mpweaponFired = len(mpweaponRuntime.weaponContext.projectiles) >
        mpweaponProjectilesBefore
    else
      mpweaponFired = mpweaponAttacker.gameplay.fireCount > mpweaponFireBefore
    end if
    mpweaponFireSteps = mpweaponFireSteps + 1
  end while
  mpweaponAssert(mpweaponFired,
    "decoded UDP attack did not fire " + mpweaponClass)
  if mpweaponClass == "ammo_grenades" then
    mpweaponsession.step(mpweaponSession)
    mpweaponsession.step(mpweaponSession)
  end if
  mpweaponAssert(mpweaponSession.clients[0].integrated.network.client.channel.outgoingSequence >
    mpweaponClientSequenceBefore, "weapon command did not advance client Netchan: " + mpweaponClass)
  if mpweaponAttacker.gameplay.ammoIndex != 0 then
    mpweaponAmmoAfter = mpweaponAttacker.gameplay.inventory.counts[
      mpweaponAttacker.gameplay.ammoIndex]
    mpweaponAssert(mpweaponAmmoAfter == mpweaponAmmoBefore -
      mpweaponAmmoCosts[mpweaponIndex], "weapon ammo cost mismatch: " + mpweaponClass)
  end if
  if mpweaponClass == "ammo_grenades" then
    mpweaponHandProjectile = mpweaponRuntime.weaponContext.projectiles[
      len(mpweaponRuntime.weaponContext.projectiles) - 1]
    mpweaponAssert(mpweaponHandProjectile.className == "hgrenade" and
      mpweaponHandProjectile.engineNumber > 0 and
      mpweaponsession.snapshotHasEntity(mpweaponSession, 0,
        mpweaponHandProjectile.engineNumber) and
      mpweaponsession.snapshotHasEntity(mpweaponSession, 1,
        mpweaponHandProjectile.engineNumber),
      "hand grenade projectile did not reach both snapshots")
  else
    mpweaponAssert(mpweaponSawMuzzle(mpweaponSession, 0,
      mpweaponAttacker.edict.state.number) and
      mpweaponSawMuzzle(mpweaponSession, 1,
      mpweaponAttacker.edict.state.number),
      "weapon muzzle handoff did not reach both clients: " + mpweaponClass)
  end if
  mpweaponIndex = mpweaponIndex + 1
end while

mpweaponSoak = 0
while mpweaponSoak < 300
  mpweaponsession.step(mpweaponSession)
  mpweaponSoak = mpweaponSoak + 1
end while
mpweaponFinal = mpweaponsession.result(mpweaponSession)
mpweaponAssert(mpweaponFinal.activeClients == 2 and
  mpweaponFinal.packetsRejected == 0 and
  mpweaponFinal.clientStates[0] == mpweaponnetwork.CA_ACTIVE and
  mpweaponFinal.clientStates[1] == mpweaponnetwork.CA_ACTIVE,
  "all-weapon post-fire UDP soak failed")
mpweaponAssert(mpweaponsession.shutdown(mpweaponSession),
  "all-weapon session shutdown")
print "runtime_multiplayer_all_weapons_tests: PASS"
