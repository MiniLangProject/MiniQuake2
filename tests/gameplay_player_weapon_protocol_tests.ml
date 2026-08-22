/* Player muzzle, impact, trail and explosion GameImport protocol handoff. */
import miniquake2.game.null_game as weaponprotocolgame
import miniquake2.game.integration.baseq2 as weaponprotocolintegration
import miniquake2.game.gameplay.registry as weaponprotocolregistry
import miniquake2.game.gameplay.item_rules as weaponprotocolitems
import miniquake2.game.gameplay.constants as weaponprotocolgameplayconstants
import miniquake2.game.weapons.constants as weaponprotocolconstants
import miniquake2.game.weapons.types as weaponprotocoltypes
import miniquake2.game.weapons.core as weaponprotocolcore
import miniquake2.game.constants as weaponprotocolgameconstants
import miniquake2.game.random as weaponprotocolrandom
import miniquake2.qcommon.constants as weaponprotocolqconstants
import miniquake2.qcommon.types as weaponprotocolqtypes
import miniquake2.server.game_bridge as weaponprotocolbridge

function weaponProtocolAssert(value, message)
  if value != true then return error(9985, message) end if
  return true
end function

function weaponProtocolItem(registry, className)
  item = weaponprotocolitems.findByClassName(registry, className)
  if item is void then return error(9986, "missing weapon item " + className) end if
  return item
end function

function weaponProtocolConfigure(player, registry, className, gunFrame, buttons, ammoCount)
  configuredItem = weaponProtocolItem(registry, className)
  player.gameplay.currentWeapon = configuredItem
  player.gameplay.newWeapon = void
  player.gameplay.weaponState = weaponprotocolgameplayconstants.WEAPON_FIRING
  player.gameplay.gunFrame = gunFrame
  player.gameplay.edict.client.playerState.gunFrame = gunFrame
  player.gameplay.buttons = buttons
  player.gameplay.latchedButtons = 0
  player.buttons = buttons
  player.latchedButtons = 0
  player.gameplay.ammoIndex = 0
  if configuredItem.ammo != "" then
    configuredAmmo = weaponprotocolitems.findByPickupName(registry, configuredItem.ammo)
    if configuredAmmo is void then return error(9987, "missing configured ammo " + configuredItem.ammo) end if
    player.gameplay.ammoIndex = configuredAmmo.index
    player.gameplay.inventory.counts[configuredAmmo.index] = ammoCount
  end if
  return configuredItem
end function

weaponRegistry = weaponprotocolregistry.stockRegistry()
weaponProtocolAssert(weaponprotocolintegration.playerMuzzleFlashForItem(weaponProtocolItem(weaponRegistry, "weapon_blaster"), 1) == weaponprotocolconstants.MZ_BLASTER, "Blaster muzzle")
weaponProtocolAssert(weaponprotocolintegration.playerMuzzleFlashForItem(weaponProtocolItem(weaponRegistry, "weapon_shotgun"), 1) == weaponprotocolconstants.MZ_SHOTGUN, "Shotgun muzzle")
weaponProtocolAssert(weaponprotocolintegration.playerMuzzleFlashForItem(weaponProtocolItem(weaponRegistry, "weapon_supershotgun"), 1) == weaponprotocolconstants.MZ_SSHOTGUN, "Super Shotgun muzzle")
weaponProtocolAssert(weaponprotocolintegration.playerMuzzleFlashForItem(weaponProtocolItem(weaponRegistry, "weapon_machinegun"), 1) == weaponprotocolconstants.MZ_MACHINEGUN, "Machinegun muzzle")
weaponProtocolAssert(weaponprotocolintegration.playerMuzzleFlashForItem(weaponProtocolItem(weaponRegistry, "weapon_chaingun"), 1) == weaponprotocolconstants.MZ_CHAINGUN1 and
  weaponprotocolintegration.playerMuzzleFlashForItem(weaponProtocolItem(weaponRegistry, "weapon_chaingun"), 2) == weaponprotocolconstants.MZ_CHAINGUN2 and
  weaponprotocolintegration.playerMuzzleFlashForItem(weaponProtocolItem(weaponRegistry, "weapon_chaingun"), 3) == weaponprotocolconstants.MZ_CHAINGUN3,
  "Chaingun shot-count muzzles")
weaponProtocolAssert(weaponprotocolintegration.playerMuzzleFlashForItem(weaponProtocolItem(weaponRegistry, "weapon_grenadelauncher"), 1) == weaponprotocolconstants.MZ_GRENADE, "Grenade muzzle")
weaponProtocolAssert(weaponprotocolintegration.playerMuzzleFlashForItem(weaponProtocolItem(weaponRegistry, "weapon_rocketlauncher"), 1) == weaponprotocolconstants.MZ_ROCKET, "Rocket muzzle")
weaponProtocolAssert(weaponprotocolintegration.playerMuzzleFlashForItem(weaponProtocolItem(weaponRegistry, "weapon_hyperblaster"), 1) == weaponprotocolconstants.MZ_HYPERBLASTER, "HyperBlaster muzzle")
weaponProtocolAssert(weaponprotocolintegration.playerMuzzleFlashForItem(weaponProtocolItem(weaponRegistry, "weapon_railgun"), 1) == weaponprotocolconstants.MZ_RAILGUN, "Railgun muzzle")
weaponProtocolAssert(weaponprotocolintegration.playerMuzzleFlashForItem(weaponProtocolItem(weaponRegistry, "weapon_bfg"), 1) == weaponprotocolconstants.MZ_BFG, "BFG muzzle")

weaponServer = weaponprotocolbridge.createRuntime(4)
weaponApi = weaponprotocolgame.GetGameApi(weaponprotocolbridge.makeImports(weaponServer))
weaponServer.game = weaponApi
weaponApi.init()
weaponFixture = "{\"classname\" \"worldspawn\"}" +
  "{\"classname\" \"info_player_start\" \"origin\" \"0 0 24\" \"angle\" \"0\"}"
weaponApi.spawnEntities("weapon-protocol", weaponFixture, "")
weaponClient = weaponApi.edicts[1]
weaponProtocolAssert(weaponApi.clientConnect(weaponClient, "\\name\\ProtocolRanger\\skin\\male/grunt"), "client connect")
weaponProtocolAssert(weaponApi.clientBegin(weaponClient), "client begin")
weaponFrame = 0
while weaponFrame < 5
  weaponApi.runFrame()
  weaponFrame = weaponFrame + 1
end while
weaponPlayer = weaponprotocolgame.playerContext().players[0]
weaponPlayer.gameplay.silencerShots = 1
weaponApi.clientThink(weaponClient, weaponprotocolqtypes.UserCmd(0, weaponprotocolgameconstants.BUTTON_ATTACK, [0, 0, 0], 0, 0, 0, 0, 64))
weaponApi.clientThink(weaponClient, weaponprotocolqtypes.UserCmd(0, 0, [0, 0, 0], 0, 0, 0, 0, 64))
weaponProtocolAssert(len(weaponServer.pendingMulticasts) == 1, "real Blaster muzzle queued")
weaponMuzzleEvent = weaponServer.pendingMulticasts[0]
weaponProtocolAssert(weaponMuzzleEvent.destination == weaponprotocolgameconstants.MULTICAST_PVS and
  len(weaponMuzzleEvent.payload) == 4 and weaponMuzzleEvent.payload[0] == weaponprotocolqconstants.SVC_MUZZLEFLASH and
  weaponMuzzleEvent.payload[3] == (weaponprotocolconstants.MZ_BLASTER | weaponprotocolconstants.MZ_SILENCED),
  "silenced player muzzle framing")
weaponProtocolAssert(weaponPlayer.gameplay.silencerShots == 0, "silencer shot consumed")
weaponLinkedBolt = weaponprotocolgame.baseRuntime().weaponContext.projectiles[0]
weaponProtocolAssert(weaponLinkedBolt.engineNumber > weaponClient.state.number and
  weaponLinkedBolt.engineNumber < weaponApi.numEdicts,
  "Blaster projectile did not allocate an export edict")
weaponLinkedBoltEdict = weaponApi.edicts[weaponLinkedBolt.engineNumber]
weaponProtocolAssert(weaponLinkedBoltEdict.inUse and
  weaponLinkedBoltEdict.state.modelIndex > 0 and weaponLinkedBoltEdict.state.sound > 0 and
  weaponLinkedBoltEdict.state.effects == weaponprotocolconstants.EF_BLASTER,
  "Blaster projectile export state")

weaponOrigin = weaponprotocolqtypes.Vec3(8.0, 16.0, 24.0)
weaponEnd = weaponprotocolqtypes.Vec3(32.0, 40.0, 48.0)
weaponNormal = weaponprotocolqtypes.Vec3(0.0, 0.0, 1.0)

weaponBaseEvents = len(weaponServer.pendingMulticasts)
weaponprotocolintegration.integratedWeaponEffect(weaponprotocoltypes.WeaponEffect(
  "impact", weaponOrigin, weaponEnd, weaponNormal, 5, weaponprotocolconstants.TE_GUNSHOT, 1))
weaponImpact = weaponServer.pendingMulticasts[weaponBaseEvents]
weaponProtocolAssert(len(weaponImpact.payload) == 9 and
  weaponImpact.payload[0] == weaponprotocolqconstants.SVC_TEMP_ENTITY and
  weaponImpact.payload[1] == weaponprotocolconstants.TE_GUNSHOT,
  "gunshot impact framing")

weaponprotocolintegration.integratedWeaponEffect(weaponprotocoltypes.WeaponEffect(
  "splash", weaponOrigin, weaponEnd, weaponNormal, 5, 2, 8))
weaponSplash = weaponServer.pendingMulticasts[weaponBaseEvents + 1]
weaponProtocolAssert(len(weaponSplash.payload) == 11 and
  weaponSplash.payload[1] == weaponprotocolconstants.TE_SPLASH and
  weaponSplash.payload[2] == 8 and weaponSplash.payload[10] == 2,
  "water splash framing")

weaponprotocolintegration.integratedWeaponEffect(weaponprotocoltypes.WeaponEffect(
  "rail-trail", weaponOrigin, weaponEnd, weaponNormal, 0, 0, 1))
weaponRail = weaponServer.pendingMulticasts[weaponBaseEvents + 2]
weaponProtocolAssert(len(weaponRail.payload) == 14 and
  weaponRail.payload[1] == weaponprotocolconstants.TE_RAILTRAIL and
  weaponRail.destination == weaponprotocolgameconstants.MULTICAST_PHS,
  "rail trail framing")

weaponprotocolintegration.integratedWeaponEffect(weaponprotocoltypes.WeaponEffect(
  "rocket-explosion", weaponOrigin, weaponEnd, weaponNormal, 0, 0, 1))
weaponExplosion = weaponServer.pendingMulticasts[weaponBaseEvents + 3]
weaponProtocolAssert(len(weaponExplosion.payload) == 8 and
  weaponExplosion.payload[1] == weaponprotocolconstants.TE_ROCKET_EXPLOSION,
  "rocket explosion framing")

weaponprotocolintegration.integratedWeaponEffect(weaponprotocoltypes.WeaponEffect(
  "bfg-laser", weaponOrigin, weaponEnd, weaponNormal, 0, 0, 1))
weaponBfgLaser = weaponServer.pendingMulticasts[weaponBaseEvents + 4]
weaponProtocolAssert(len(weaponBfgLaser.payload) == 14 and
  weaponBfgLaser.payload[1] == weaponprotocolconstants.TE_BFG_LASER,
  "BFG laser framing")

weaponprotocolintegration.integratedDamageEffect(weaponEnd, weaponNormal, true, false)
weaponBlood = weaponServer.pendingMulticasts[weaponBaseEvents + 5]
weaponProtocolAssert(len(weaponBlood.payload) == 9 and
  weaponBlood.payload[1] == weaponprotocolconstants.TE_BLOOD,
  "blood feedback framing")

weaponprotocolintegration.integratedDamageEffect(weaponEnd, weaponNormal, false, true)
weaponBulletSparks = weaponServer.pendingMulticasts[weaponBaseEvents + 6]
weaponProtocolAssert(len(weaponBulletSparks.payload) == 9 and
  weaponBulletSparks.payload[1] == weaponprotocolconstants.TE_BULLET_SPARKS,
  "bullet armor spark framing")

// Weapon-specific p_weapon.c fire-frame boundaries.
weaponSequencePlayer = weaponPlayer
weaponSequenceGameplay = weaponSequencePlayer.gameplay
weaponSequenceAttack = weaponprotocolgameconstants.BUTTON_ATTACK

weaponProtocolConfigure(weaponSequencePlayer, weaponRegistry, "weapon_shotgun", 9, weaponSequenceAttack, 8)
weaponSequenceFireBefore = weaponSequenceGameplay.fireCount
weaponSequenceAmmoBefore = weaponSequenceGameplay.inventory.counts[weaponSequenceGameplay.ammoIndex]
weaponSequenceMulticastBefore = len(weaponServer.pendingMulticasts)
weaponprotocolintegration.integratedPlayerFire(weaponSequenceGameplay, weaponRegistry)
weaponProtocolAssert(weaponSequenceGameplay.gunFrame == 10 and
  weaponSequenceGameplay.fireCount == weaponSequenceFireBefore and
  weaponSequenceGameplay.inventory.counts[weaponSequenceGameplay.ammoIndex] == weaponSequenceAmmoBefore and
  len(weaponServer.pendingMulticasts) == weaponSequenceMulticastBefore,
  "Shotgun pump frame fired a second shot")

weaponProtocolConfigure(weaponSequencePlayer, weaponRegistry, "weapon_bfg", 9, weaponSequenceAttack, 100)
weaponSequenceGameplay.silencerShots = 1
weaponSequenceFireBefore = weaponSequenceGameplay.fireCount
weaponSequenceMulticastBefore = len(weaponServer.pendingMulticasts)
weaponprotocolintegration.integratedPlayerFire(weaponSequenceGameplay, weaponRegistry)
weaponBfgWindup = weaponServer.pendingMulticasts[weaponSequenceMulticastBefore]
weaponProtocolAssert(weaponSequenceGameplay.gunFrame == 10 and
  weaponSequenceGameplay.fireCount == weaponSequenceFireBefore and
  weaponSequenceGameplay.inventory.counts[weaponSequenceGameplay.ammoIndex] == 100 and
  weaponSequenceGameplay.silencerShots == 0 and
  weaponBfgWindup.payload[0] == weaponprotocolqconstants.SVC_MUZZLEFLASH and
  weaponBfgWindup.payload[3] == (weaponprotocolconstants.MZ_BFG | weaponprotocolconstants.MZ_SILENCED),
  "BFG windup framing/state")

weaponProtocolConfigure(weaponSequencePlayer, weaponRegistry, "weapon_bfg", 17, weaponSequenceAttack, 40)
weaponSequenceFireBefore = weaponSequenceGameplay.fireCount
weaponSequenceMulticastBefore = len(weaponServer.pendingMulticasts)
weaponprotocolintegration.integratedPlayerFire(weaponSequenceGameplay, weaponRegistry)
weaponProtocolAssert(weaponSequenceGameplay.gunFrame == 18 and
  weaponSequenceGameplay.fireCount == weaponSequenceFireBefore and
  weaponSequenceGameplay.inventory.counts[weaponSequenceGameplay.ammoIndex] == 40 and
  len(weaponServer.pendingMulticasts) == weaponSequenceMulticastBefore,
  "BFG post-windup ammo recheck")

weaponProtocolConfigure(weaponSequencePlayer, weaponRegistry, "weapon_machinegun", 4, weaponSequenceAttack, 10)
weaponprotocolintegration.integratedPlayerFire(weaponSequenceGameplay, weaponRegistry)
weaponProtocolAssert(weaponSequenceGameplay.gunFrame == 5 and
  weaponSequenceGameplay.inventory.counts[weaponSequenceGameplay.ammoIndex] == 9,
  "Machinegun first toggle frame")
weaponprotocolintegration.integratedPlayerFire(weaponSequenceGameplay, weaponRegistry)
weaponProtocolAssert(weaponSequenceGameplay.gunFrame == 4 and
  weaponSequenceGameplay.inventory.counts[weaponSequenceGameplay.ammoIndex] == 8,
  "Machinegun held toggle frame")
weaponSequenceGameplay.buttons = 0
weaponSequenceFireBefore = weaponSequenceGameplay.fireCount
weaponprotocolintegration.integratedPlayerFire(weaponSequenceGameplay, weaponRegistry)
weaponProtocolAssert(weaponSequenceGameplay.gunFrame == 5 and
  weaponSequenceGameplay.fireCount == weaponSequenceFireBefore,
  "Machinegun release frame")

weaponProtocolConfigure(weaponSequencePlayer, weaponRegistry, "weapon_chaingun", 9, weaponSequenceAttack, 20)
weaponSequenceMulticastBefore = len(weaponServer.pendingMulticasts)
weaponprotocolintegration.integratedPlayerFire(weaponSequenceGameplay, weaponRegistry)
weaponChainTwo = weaponServer.pendingMulticasts[weaponSequenceMulticastBefore]
weaponProtocolAssert(weaponSequenceGameplay.gunFrame == 10 and
  weaponSequenceGameplay.inventory.counts[weaponSequenceGameplay.ammoIndex] == 18 and
  weaponChainTwo.payload[3] == weaponprotocolconstants.MZ_CHAINGUN2,
  "Chaingun two-shot stage")
weaponProtocolConfigure(weaponSequencePlayer, weaponRegistry, "weapon_chaingun", 21, weaponSequenceAttack, 20)
weaponSequenceMulticastBefore = len(weaponServer.pendingMulticasts)
weaponprotocolintegration.integratedPlayerFire(weaponSequenceGameplay, weaponRegistry)
weaponChainThree = weaponServer.pendingMulticasts[weaponSequenceMulticastBefore]
weaponProtocolAssert(weaponSequenceGameplay.gunFrame == 15 and
  weaponSequenceGameplay.inventory.counts[weaponSequenceGameplay.ammoIndex] == 17 and
  weaponChainThree.payload[3] == weaponprotocolconstants.MZ_CHAINGUN3,
  "Chaingun loop-back three-shot stage")
weaponProtocolConfigure(weaponSequencePlayer, weaponRegistry, "weapon_chaingun", 14, 0, 20)
weaponSequenceFireBefore = weaponSequenceGameplay.fireCount
weaponprotocolintegration.integratedPlayerFire(weaponSequenceGameplay, weaponRegistry)
weaponProtocolAssert(weaponSequenceGameplay.gunFrame == 32 and
  weaponSequenceGameplay.fireCount == weaponSequenceFireBefore and
  weaponSequenceGameplay.inventory.counts[weaponSequenceGameplay.ammoIndex] == 20,
  "Chaingun release wind-down")

weaponProtocolConfigure(weaponSequencePlayer, weaponRegistry, "weapon_hyperblaster", 11, weaponSequenceAttack, 5)
weaponprotocolintegration.integratedPlayerFire(weaponSequenceGameplay, weaponRegistry)
weaponProtocolAssert(weaponSequenceGameplay.gunFrame == 6 and
  weaponSequenceGameplay.inventory.counts[weaponSequenceGameplay.ammoIndex] == 4 and
  weaponSequencePlayer.view.weaponSound != 0,
  "HyperBlaster held loop")
weaponProtocolConfigure(weaponSequencePlayer, weaponRegistry, "weapon_hyperblaster", 11, 0, 5)
weaponSequencePlayer.view.weaponSound = 1
weaponSequenceFireBefore = weaponSequenceGameplay.fireCount
weaponprotocolintegration.integratedPlayerFire(weaponSequenceGameplay, weaponRegistry)
weaponProtocolAssert(weaponSequenceGameplay.gunFrame == 12 and
  weaponSequenceGameplay.fireCount == weaponSequenceFireBefore and
  weaponSequencePlayer.view.weaponSound == 0,
  "HyperBlaster release spin-down")

weaponprotocolgame.playerContext().dmFlags = weaponprotocolgameconstants.DF_INFINITE_AMMO
weaponProtocolConfigure(weaponSequencePlayer, weaponRegistry, "weapon_chaingun", 14, weaponSequenceAttack, 10)
weaponprotocolintegration.integratedPlayerFire(weaponSequenceGameplay, weaponRegistry)
weaponProtocolAssert(weaponSequenceGameplay.inventory.counts[weaponSequenceGameplay.ammoIndex] == 10,
  "infinite-ammo Chaingun consumed bullets")
weaponprotocolgame.playerContext().dmFlags = 0

weaponSequencePlayer.edict.state.origin = weaponprotocolqtypes.Vec3(0.0, 0.0, 0.0)
weaponSequencePlayer.edict.client.playerState.viewAngles = weaponprotocolqtypes.Vec3(0.0, 0.0, 0.0)
weaponSequencePlayer.persistent.hand = 0
weaponMuzzleRight = weaponprotocolintegration.playerMuzzle(weaponSequencePlayer,
  weaponProtocolItem(weaponRegistry, "weapon_blaster"), 5, 0)[0]
weaponSequencePlayer.persistent.hand = 1
weaponMuzzleLeft = weaponprotocolintegration.playerMuzzle(weaponSequencePlayer,
  weaponProtocolItem(weaponRegistry, "weapon_blaster"), 5, 0)[0]
weaponProtocolAssert(weaponMuzzleRight.x == 24.0 and weaponMuzzleRight.y == -8.0 and
  weaponMuzzleLeft.x == 24.0 and weaponMuzzleLeft.y == 8.0,
  "handed player muzzle projection")
weaponprotocolintegration.applyPlayerWeaponRecoil(weaponprotocolgame.baseRuntime(),
  weaponSequencePlayer, weaponProtocolItem(weaponRegistry, "weapon_railgun"),
  weaponprotocolqtypes.Vec3(1.0, 0.0, 0.0))
weaponProtocolAssert(weaponSequencePlayer.view.kickOrigin.x == -3.0 and
  weaponSequencePlayer.view.kickAngles.x == -3.0,
  "Railgun recoil")

weaponprotocolgame.baseRuntime().randomState = weaponprotocolrandom.create(1)
weaponSequencePlayer.view.machinegunShots = 0
weaponprotocolintegration.applyPlayerWeaponRecoil(weaponprotocolgame.baseRuntime(),
  weaponSequencePlayer, weaponProtocolItem(weaponRegistry, "weapon_machinegun"),
  weaponprotocolqtypes.Vec3(1.0, 0.0, 0.0))
weaponProtocolAssert(weaponprotocolgame.baseRuntime().randomState.seed == 3403800452 and
  weaponSequencePlayer.view.machinegunShots == 1 and
  weaponSequencePlayer.view.kickOrigin.x > 0.059 and weaponSequencePlayer.view.kickOrigin.x < 0.060 and
  weaponSequencePlayer.view.kickOrigin.y < -0.349 and
  weaponSequencePlayer.view.kickAngles.y > 0.089 and weaponSequencePlayer.view.kickAngles.y < 0.090,
  "Machinegun Win32-rand recoil sequence")

weaponprotocolgame.baseRuntime().randomState = weaponprotocolrandom.create(1)
weaponprotocolintegration.applyPlayerWeaponRecoil(weaponprotocolgame.baseRuntime(),
  weaponSequencePlayer, weaponProtocolItem(weaponRegistry, "weapon_chaingun"),
  weaponprotocolqtypes.Vec3(1.0, 0.0, 0.0))
weaponProtocolAssert(weaponprotocolgame.baseRuntime().randomState.seed == 1030492215 and
  weaponSequencePlayer.view.kickOrigin.x < -0.349 and
  weaponSequencePlayer.view.kickAngles.x > 0.089 and weaponSequencePlayer.view.kickAngles.x < 0.090,
  "Chaingun Win32-rand recoil sequence")

weaponprotocolgame.baseRuntime().randomState = weaponprotocolrandom.create(1)
weaponprotocolintegration.applyPlayerWeaponRecoil(weaponprotocolgame.baseRuntime(),
  weaponSequencePlayer, weaponProtocolItem(weaponRegistry, "weapon_bfg"),
  weaponprotocolqtypes.Vec3(1.0, 0.0, 0.0))
weaponProtocolAssert(weaponprotocolgame.baseRuntime().randomState.seed == 2745024 and
  weaponSequencePlayer.view.damagePitch == -40.0 and
  weaponSequencePlayer.view.damageRoll < -7.97,
  "BFG Win32-rand damage recoil")

weaponprotocolgame.baseRuntime().randomState = weaponprotocolrandom.create(2745024)
weaponProtocolConfigure(weaponSequencePlayer, weaponRegistry,
  "weapon_rocketlauncher", 4, weaponSequenceAttack, 5)
weaponRocketCountBefore = len(weaponprotocolgame.baseRuntime().weaponContext.projectiles)
weaponprotocolintegration.integratedPlayerFire(weaponSequenceGameplay, weaponRegistry)
weaponProtocolAssert(len(weaponprotocolgame.baseRuntime().weaponContext.projectiles) ==
    weaponRocketCountBefore + 1 and
  weaponprotocolgame.baseRuntime().weaponContext.projectiles[weaponRocketCountBefore].damage == 111 and
  weaponprotocolgame.baseRuntime().randomState.seed == 3357800067,
  "Rocket 100-plus-random-20 damage")

weaponHandItem = weaponProtocolConfigure(weaponSequencePlayer, weaponRegistry,
  "ammo_grenades", 0, 0, 2)
weaponSequenceGameplay.weaponState = weaponprotocolgameplayconstants.WEAPON_ACTIVATING
weaponprotocolintegration.thinkPlayerWeapon(weaponSequencePlayer, weaponprotocolgame.playerContext())
weaponProtocolAssert(weaponSequenceGameplay.weaponState == weaponprotocolgameplayconstants.WEAPON_READY and
  weaponSequenceGameplay.gunFrame == 16,
  "hand grenade activation")
weaponSequenceGameplay.buttons = weaponSequenceAttack
weaponSequenceGameplay.latchedButtons = weaponSequenceAttack
weaponprotocolintegration.thinkPlayerWeapon(weaponSequencePlayer, weaponprotocolgame.playerContext())
weaponProtocolAssert(weaponSequenceGameplay.weaponState == weaponprotocolgameplayconstants.WEAPON_FIRING and
  weaponSequenceGameplay.gunFrame == 1,
  "hand grenade attack latch")
weaponHandAdvance = 0
while weaponSequenceGameplay.gunFrame < 11 and weaponHandAdvance < 16
  weaponprotocolintegration.thinkPlayerWeapon(weaponSequencePlayer, weaponprotocolgame.playerContext())
  weaponHandAdvance = weaponHandAdvance + 1
end while
weaponprotocolintegration.thinkPlayerWeapon(weaponSequencePlayer, weaponprotocolgame.playerContext())
weaponProtocolAssert(weaponSequenceGameplay.gunFrame == 11 and
  weaponSequencePlayer.handGrenadeState.grenadeTime > 0.0,
  "hand grenade cook frame")
weaponSequenceGameplay.buttons = 0
weaponprotocolintegration.thinkPlayerWeapon(weaponSequencePlayer, weaponprotocolgame.playerContext())
weaponprotocolintegration.thinkPlayerWeapon(weaponSequencePlayer, weaponprotocolgame.playerContext())
weaponProtocolAssert(weaponSequencePlayer.handGrenadeState.lastProjectile is not void and
  weaponSequenceGameplay.inventory.counts[weaponSequenceGameplay.ammoIndex] == 1 and
  weaponSequenceGameplay.gunFrame == 13,
  "hand grenade release/projectile/ammo")

weaponProtocolAssert(weaponprotocolcore.freeProjectile(weaponprotocolgame.baseRuntime().weaponContext,
  weaponLinkedBolt), "projectile free")
weaponProtocolAssert(not weaponApi.edicts[weaponLinkedBolt.engineNumber].inUse,
  "freed projectile export edict remained live")

weaponApi.clientDisconnect(weaponClient)
weaponApi.shutdown()
print "gameplay_player_weapon_protocol_tests: PASS"
