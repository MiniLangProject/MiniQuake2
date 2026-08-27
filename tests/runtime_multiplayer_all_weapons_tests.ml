/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Every stock weapon fired by a real two-client UDP UserCmd session. */
import miniquake2.network.constants as mpweaponnetwork
import miniquake2.qcommon.constants as mpweaponqconstants
import miniquake2.qcommon.types as mpweaponqtypes
import miniquake2.game.constants as mpweapongameconstants
import miniquake2.game.gameplay.constants as mpweapongameplayconstants
import miniquake2.game.gameplay.item_rules as mpweaponitems
import miniquake2.game.gameplay.weapons as mpweaponrules
import miniquake2.game.player.constants as mpweaponplayerconstants
import miniquake2.game.null_game as mpweapongame
import miniquake2.runtime.multiplayer_session as mpweaponsession
import miniquake2.client.state as mpweaponclientstate
import miniquake2.client.assets.types as mpweaponassettypes
import miniquake2.client.effects.entity as mpweaponentityeffects
import miniquake2.client.effects.handoff as mpweaponeffecthandoff
import miniquake2.renderer.types as mpweaponrenderertypes

// Assert the mpweapon test condition.
function mpweaponAssert(value, name)
  if not value then return error(8424, name) end if
  return true
end function

// Return the mpweapon equip value.
function mpweaponEquip(player, registry, className, ammunition)
  mpweaponEquipped = mpweaponitems.findByClassName(registry, className)
  if mpweaponEquipped is void then return error(8425, "missing stock weapon " + className) end if
  player.gameplay.inventory.counts[mpweaponEquipped.index] = 1
  player.gameplay.newWeapon = mpweaponEquipped
  mpweaponrules.ChangeWeapon(player.gameplay, registry)
  player.gameplay.weaponState = mpweapongameplayconstants.WEAPON_READY
  player.gameplay.gunFrame = 16
  if mpweaponEquipped.weaponFrames is not void then
    player.gameplay.gunFrame = mpweaponEquipped.weaponFrames.fireLast + 1
  end if
  player.edict.client.playerState.gunFrame = player.gameplay.gunFrame
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

// Return the mpweapon snapshot skin value.
function mpweaponSnapshotSkin(session, clientIndex, entityNumber)
  mpweaponFrame = session.clients[clientIndex].integrated.network.client.currentFrame
  if mpweaponFrame is void then return -1 end if
  for each mpweaponEntity in mpweaponFrame.entities
    if mpweaponEntity.number == entityNumber then return mpweaponEntity.skinNum end if
  end for
  return -1
end function

// Return the mpweapon snapshot entity value.
function mpweaponSnapshotEntity(session, clientIndex, entityNumber)
  mpweaponEntityFrame = session.clients[clientIndex].integrated.network.client.currentFrame
  if mpweaponEntityFrame is void then return void end if
  for each mpweaponSnapshotValue in mpweaponEntityFrame.entities
    if mpweaponSnapshotValue.number == entityNumber then return mpweaponSnapshotValue end if
  end for
  return void
end function

// Return the mpweapon new projectile value.
function mpweaponNewProjectile(runtime, minimumNumber, className)
  for each mpweaponProjectileValue in runtime.weaponContext.projectiles
    if mpweaponProjectileValue.number >= minimumNumber and
        mpweaponProjectileValue.className == className then
      return mpweaponProjectileValue
    end if
  end for
  return void
end function

// Return the mpweapon saw muzzle value.
function mpweaponSawMuzzle(session, clientIndex, entityNumber)
  for each mpweaponHandoff in session.clients[clientIndex].integrated.frameHandoffs
    for each mpweaponLight in mpweaponHandoff.dLights
      if mpweaponLight.key == entityNumber then return true end if
    end for
  end for
  return false
end function

// Resolve mpweapon model.
function mpweaponResolveModel(index)
  return mpweaponrenderertypes.ResourceHandle("model", index,
    "model" + index, 1)
end function

// Resolve mpweapon named model.
function mpweaponResolveNamedModel(name)
  return mpweaponrenderertypes.ResourceHandle("model", 4096 + len(bytes(name)),
    name, 1)
end function

// Resolve mpweapon named skin.
function mpweaponResolveNamedSkin(name)
  return mpweaponrenderertypes.ResourceHandle("skin", 8192 + len(bytes(name)),
    name, 1)
end function

// Resolve mpweapon nothing.
function mpweaponResolveNothing(value)
  return void
end function

// Resolve mpweapon entity sound.
function mpweaponResolveEntitySound(entityNumber, soundIndex, soundName)
  return void
end function

// Resolve mpweapon player model.
function mpweaponResolvePlayerModel(index)
  return mpweaponrenderertypes.ResourceHandle("model", 12288 + index,
    "players/test/tris.md2", 1)
end function

// Resolve mpweapon player skin.
function mpweaponResolvePlayerSkin(index)
  return mpweaponrenderertypes.ResourceHandle("skin", 16384 + index,
    "players/test/skin.pcx", 1)
end function

// Resolve mpweapon player weapon.
function mpweaponResolvePlayerWeapon(index, weaponIndex)
  return mpweaponrenderertypes.ResourceHandle("model", 20480 + weaponIndex,
    "players/test/weapon.md2", 1)
end function

// Return the mpweapon visual random value.
function mpweaponVisualRandom()
  return 0
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
mpweaponAssetBindings = mpweaponassettypes.ResolverBindings(
  mpweaponResolveModel, mpweaponResolveNamedModel, mpweaponResolveNamedSkin,
  mpweaponResolveNothing, mpweaponResolveNothing, mpweaponResolveEntitySound,
  mpweaponResolvePlayerModel, mpweaponResolvePlayerSkin,
  mpweaponResolvePlayerWeapon)
mpweaponClasses = ["weapon_blaster", "weapon_shotgun", "weapon_supershotgun",
  "weapon_machinegun", "weapon_chaingun", "ammo_grenades",
  "weapon_grenadelauncher", "weapon_rocketlauncher",
  "weapon_hyperblaster", "weapon_railgun", "weapon_bfg"]
mpweaponAmmoCosts = [0, 1, 2, 1, 1, 1, 1, 1, 1, 1, 50]
mpweaponProjectileClasses = ["bolt", "", "", "", "", "hgrenade",
  "grenade", "rocket", "bolt", "", "bfg blast"]
mpweaponProjectileModels = ["models/objects/laser/tris.md2", "", "", "", "",
  "models/objects/grenade2/tris.md2", "models/objects/grenade/tris.md2",
  "models/objects/rocket/tris.md2", "models/objects/laser/tris.md2", "",
  "sprites/s_bfg1.sp2"]
mpweaponProjectileSounds = ["misc/lasfly.wav", "", "", "", "",
  "weapons/hgrenc1b.wav", "", "weapons/rockfly.wav", "misc/lasfly.wav", "",
  "weapons/bfg__l1a.wav"]
mpweaponIndex = 0
while mpweaponIndex < len(mpweaponClasses)
  mpweaponClass = mpweaponClasses[mpweaponIndex]
  mpweaponDuelDistance = 96
  if mpweaponProjectileClasses[mpweaponIndex] != "" then mpweaponDuelDistance = 512 end if
  mpweaponAssert(mpweaponsession.prepareDuel(mpweaponSession, 0, 1,
    mpweaponDuelDistance),
    "weapon duel reset failed: " + mpweaponClass)
  mpweaponVictim.health = 10000
  mpweaponVictim.gameplay.health = 10000
  mpweaponVictim.maxHealth = 10000
  mpweaponVictim.deadFlag = mpweaponplayerconstants.DEAD_NO
  mpweaponVictim.edict.takeDamage = true
  mpweaponItem = mpweaponEquip(mpweaponAttacker, mpweaponRegistry,
    mpweaponClass, 200)
  mpweaponFireBefore = mpweaponAttacker.gameplay.fireCount
  mpweaponProjectileNumberBefore = mpweaponRuntime.weaponContext.nextProjectileNumber
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
    if mpweaponProjectileClasses[mpweaponIndex] != "" then
      mpweaponFired = mpweaponNewProjectile(mpweaponRuntime,
        mpweaponProjectileNumberBefore,
        mpweaponProjectileClasses[mpweaponIndex]) is not void
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
  if mpweaponProjectileClasses[mpweaponIndex] != "" then
    // A player weapon fires during ClientBeginServerFrame, after the managed
    // projectile physics pass.  Observe the following authoritative frame so
    // oldOrigin/origin prove actual visible motion rather than spawn presence.
    mpweaponsession.step(mpweaponSession)
  end if
  mpweaponAssert(mpweaponSession.clients[0].integrated.network.client.channel.outgoingSequence >
    mpweaponClientSequenceBefore, "weapon command did not advance client Netchan: " + mpweaponClass)
  mpweaponExpectedSkin = (mpweaponAttacker.edict.state.number - 1) |
    ((mpweaponItem.weaponModel & 0xff) << 8)
  mpweaponAssert(mpweaponSnapshotSkin(mpweaponSession, 0,
    mpweaponAttacker.edict.state.number) == mpweaponExpectedSkin and
    mpweaponSnapshotSkin(mpweaponSession, 1,
      mpweaponAttacker.edict.state.number) == mpweaponExpectedSkin,
    "visible player weapon did not reach both snapshots: " + mpweaponClass)
  if mpweaponAttacker.gameplay.ammoIndex != 0 then
    mpweaponAmmoAfter = mpweaponAttacker.gameplay.inventory.counts[
      mpweaponAttacker.gameplay.ammoIndex]
    mpweaponAssert(mpweaponAmmoAfter == mpweaponAmmoBefore -
      mpweaponAmmoCosts[mpweaponIndex], "weapon ammo cost mismatch: " + mpweaponClass)
  end if
  if mpweaponProjectileClasses[mpweaponIndex] != "" then
    mpweaponMovingProjectile = mpweaponNewProjectile(mpweaponRuntime,
      mpweaponProjectileNumberBefore,
      mpweaponProjectileClasses[mpweaponIndex])
    mpweaponAssert(mpweaponMovingProjectile is not void and
      mpweaponMovingProjectile.engineNumber > 0,
      "moving projectile did not own an engine edict: " + mpweaponClass)
    mpweaponProjectileSnapshot0 = mpweaponSnapshotEntity(mpweaponSession, 0,
      mpweaponMovingProjectile.engineNumber)
    mpweaponProjectileSnapshot1 = mpweaponSnapshotEntity(mpweaponSession, 1,
      mpweaponMovingProjectile.engineNumber)
    mpweaponAssert(mpweaponProjectileSnapshot0 is not void and
      mpweaponProjectileSnapshot1 is not void,
      "moving projectile did not reach both snapshots: " + mpweaponClass)
    mpweaponAssert(mpweaponProjectileSnapshot0.modelIndex > 0 and
      mpweaponProjectileSnapshot1.modelIndex == mpweaponProjectileSnapshot0.modelIndex and
      mpweaponMovingProjectile.modelIndex == mpweaponProjectileSnapshot0.modelIndex,
      "moving projectile model index mismatch: " + mpweaponClass)
    mpweaponAssert(mpweaponProjectileSnapshot0.effects ==
        mpweaponMovingProjectile.effects and
        mpweaponProjectileSnapshot1.effects == mpweaponProjectileSnapshot0.effects,
      "moving projectile effects did not survive Protocol-34: " + mpweaponClass)
    mpweaponAssert(mpweaponProjectileSnapshot0.origin[0] !=
        mpweaponProjectileSnapshot0.oldOrigin[0] or
        mpweaponProjectileSnapshot0.origin[1] !=
        mpweaponProjectileSnapshot0.oldOrigin[1] or
        mpweaponProjectileSnapshot0.origin[2] !=
        mpweaponProjectileSnapshot0.oldOrigin[2],
      "projectile snapshot did not retain visible motion: " + mpweaponClass)
    mpweaponAssert(mpweaponSession.clients[0].integrated.network.configStrings[
      mpweaponqconstants.CS_MODELS + mpweaponProjectileSnapshot0.modelIndex] ==
      mpweaponProjectileModels[mpweaponIndex] and
      mpweaponSession.clients[1].integrated.network.configStrings[
      mpweaponqconstants.CS_MODELS + mpweaponProjectileSnapshot1.modelIndex] ==
      mpweaponProjectileModels[mpweaponIndex],
      "moving projectile model configstring missing: " + mpweaponClass)
    mpweaponVisualFrame = mpweaponclientstate.buildRefDef(
      mpweaponSession.clients[0].integrated.client, 1.0, 640, 480,
      mpweaponAssetBindings, mpweaponAttacker.edict.state.number,
      mpweaponVisualRandom)
    mpweaponRenderedProjectile = void
    for each mpweaponRenderedEntity in mpweaponVisualFrame.entities
      if mpweaponRenderedEntity.model is not void and
          mpweaponRenderedEntity.model.id == mpweaponProjectileSnapshot0.modelIndex then
        mpweaponRenderedProjectile = mpweaponRenderedEntity
        break
      end if
    end for
    mpweaponAssert(mpweaponRenderedProjectile is not void and
        mpweaponRenderedProjectile.origin.x == mpweaponProjectileSnapshot0.origin[0] and
        mpweaponRenderedProjectile.origin.y == mpweaponProjectileSnapshot0.origin[1] and
        mpweaponRenderedProjectile.origin.z == mpweaponProjectileSnapshot0.origin[2],
      "moving projectile did not become a drawable client entity: " +
        mpweaponClass)
    mpweaponentityeffects.emit(mpweaponSession.clients[0].integrated.effects,
      mpweaponSession.clients[0].integrated.client.current,
      mpweaponSession.clients[0].integrated.client.previous, 1.0,
      mpweaponSession.clients[0].integrated.client.serverTime,
      mpweaponAttacker.edict.state.number, mpweaponVisualFrame)
    mpweaponeffecthandoff.applyPrepared(
      mpweaponSession.clients[0].integrated.effects, mpweaponVisualFrame,
      mpweaponSession.clients[0].integrated.client.serverTime,
      mpweaponResolveNamedModel)
    if mpweaponClass == "weapon_blaster" then
      mpweaponAssert(mpweaponVisualFrame.numDLights > 0 and
          mpweaponVisualFrame.numParticles > 0,
        "blaster projectile produced no visible trail/light handoff")
    end if
    if mpweaponProjectileSounds[mpweaponIndex] != "" then
      mpweaponAssert(mpweaponProjectileSnapshot0.sound > 0 and
        mpweaponProjectileSnapshot1.sound == mpweaponProjectileSnapshot0.sound and
        mpweaponSession.clients[0].integrated.network.configStrings[
          mpweaponqconstants.CS_SOUNDS + mpweaponProjectileSnapshot0.sound] ==
          mpweaponProjectileSounds[mpweaponIndex] and
        mpweaponSession.clients[1].integrated.network.configStrings[
          mpweaponqconstants.CS_SOUNDS + mpweaponProjectileSnapshot1.sound] ==
          mpweaponProjectileSounds[mpweaponIndex],
        "moving projectile loop sound missing: " + mpweaponClass)
    end if
  end if
  if mpweaponClass != "ammo_grenades" then
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
