/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Asset-free native tests for managed baseq2 items, weapons and damage. */
import miniquake2.game.constants as gameconstants
import miniquake2.game.base.types as btypes
import miniquake2.game.gameplay.combat as gpcombat
import miniquake2.game.gameplay.constants as gpconstants
import miniquake2.game.gameplay.item_rules as gprules
import miniquake2.game.gameplay.precache as gpprecache
import miniquake2.game.gameplay.registry as gpregistry
import miniquake2.game.gameplay.types as gptypes
import miniquake2.game.gameplay.weapons as gpweapons
import miniquake2.server.game_bridge as gbridge
import std.string as gpstring

function assertEqual(actual, expected, name)
  if actual != expected then return error(9500, name + ": values differ") end if
  return true
end function

function assertTrue(value, name)
  if value != true then return error(9501, name + ": expected true") end if
  return true
end function

function assertErrorContains(value, fragment, name)
  if value is not error then return error(9502, name + ": expected error") end if
  if gpstring.contains(value.message, fragment) != true then return error(9503, name + ": unexpected message " + value.message) end if
  return true
end function

function contains(values, expected)
  for each value in values
    if value == expected then return true end if
  end for
  return false
end function

function allowDamage(target)
  return true
end function

function testRegistryAndPrecache()
  baseEntity = btypes.zeroBaseEntity()
  assertEqual(baseEntity.spawnKind, "unspawned", "base/gameplay type aliases coexist")
  registry = gpregistry.defaultRegistry()
  assertTrue(gpregistry.validate(registry), "registry validation")
  assertEqual(len(registry.items), 16, "weapon and ammo registry count")
  shotgun = gprules.findByPickupName(registry, "shotgun")
  rockets = gprules.findByClassName(registry, "AMMO_ROCKETS")
  assertEqual(shotgun.className, "weapon_shotgun", "case-insensitive pickup lookup")
  assertEqual(rockets.pickupName, "Rockets", "case-insensitive classname lookup")
  assertEqual(typeof(shotgun.pickup), "function", "pickup callback value")
  assertEqual(typeof(shotgun.use), "function", "use callback value")
  assertEqual(typeof(shotgun.drop), "function", "drop callback value")
  assertEqual(typeof(shotgun.weaponThink), "function", "weapon think callback value")

  runtime = gbridge.createRuntime(1)
  imports = gbridge.makeImports(runtime)
  rocketLauncher = gprules.findByPickupName(registry, "Rocket Launcher")
  cached = gpprecache.PrecacheItem(registry, rocketLauncher, imports)
  assertEqual(len(cached.models), 5, "recursive model precache count")
  assertEqual(len(cached.sounds), 5, "recursive sound precache count")
  assertEqual(len(cached.images), 2, "recursive image precache count")
  assertTrue(contains(cached.models, "models/items/ammo/rockets/medium/tris.md2"), "ammo model recursion")
  assertTrue(contains(cached.models, "models/objects/rocket/tris.md2"), "projectile model precache")
  assertTrue(contains(cached.sounds, "weapons/rockfly.wav"), "flight sound precache")
  assertTrue(contains(cached.images, "w_rlauncher"), "weapon icon precache")
  return registry
end function

function testItemsAmmoDropAndRespawn(registry)
  slots = gpregistry.inventorySlots(registry)
  player = gptypes.createPlayer(1, slots)
  blaster = gprules.findByPickupName(registry, "Blaster")
  shells = gprules.findByPickupName(registry, "Shells")
  shotgun = gprules.findByPickupName(registry, "Shotgun")
  player.inventory.counts[blaster.index] = 1
  player.currentWeapon = blaster

  shellEntity = gptypes.createItemEntity(20, shells)
  deathmatch = gptypes.pickupContext(true, false, 0, 12.0)
  picked = gprules.Pickup_Item(shellEntity, player, deathmatch, registry)
  assertTrue(picked.success, "ammo pickup")
  assertEqual(picked.amount, 10, "default ammo pickup amount")
  assertEqual(player.inventory.counts[shells.index], 10, "shell inventory")
  assertTrue(picked.respawnScheduled, "deathmatch ammo respawn")
  assertEqual(shellEntity.hidden, true, "respawning item hidden")
  assertEqual(shellEntity.respawnAt, 42.0, "respawn time")
  assertEqual(shellEntity.edict.solid, gameconstants.SOLID_NOT, "hidden item solid")
  assertEqual(gprules.DoRespawn(shellEntity, 41.9), false, "early respawn rejected")
  assertTrue(gprules.DoRespawn(shellEntity, 42.0), "on-time respawn")
  assertEqual(shellEntity.edict.solid, gameconstants.SOLID_TRIGGER, "respawned item trigger")
  assertEqual(shellEntity.edict.state.event, gameconstants.EV_ITEM_RESPAWN, "respawn event")

  player.inventory.counts[shells.index] = 97
  cappedEntity = gptypes.createItemEntity(21, shells)
  cappedEntity.count = 7
  capped = gprules.Pickup_Item(cappedEntity, player, gptypes.pickupContext(false, false, 0, 0.0), registry)
  assertEqual(capped.amount, 3, "ammo cap delta")
  assertEqual(player.inventory.counts[shells.index], 100, "shell maximum")
  assertEqual(gprules.Pickup_Item(gptypes.createItemEntity(22, shells), player, deathmatch, registry).success, false, "full ammo refused")

  weaponPlayer = gptypes.createPlayer(2, slots)
  weaponPlayer.inventory.counts[blaster.index] = 1
  weaponPlayer.currentWeapon = blaster
  shotgunEntity = gptypes.createItemEntity(23, shotgun)
  weaponPickup = gprules.Pickup_Item(shotgunEntity, weaponPlayer, gptypes.pickupContext(false, false, 0, 0.0), registry)
  assertTrue(weaponPickup.success, "weapon pickup")
  assertEqual(weaponPlayer.inventory.counts[shotgun.index], 1, "shotgun inventory")
  assertEqual(weaponPlayer.inventory.counts[shells.index], 10, "weapon grants ammo")
  assertEqual(weaponPlayer.newWeapon.index, shotgun.index, "first weapon auto-selection")

  weaponPlayer.inventory.counts[shells.index] = 17
  droppedAmmo = gprules.Drop_Ammo(weaponPlayer, shells, registry, 30)
  assertTrue(droppedAmmo.success, "drop ammo")
  assertEqual(droppedAmmo.amount, 10, "drop ammo quantity")
  assertEqual(droppedAmmo.droppedEntity.count, 10, "dropped entity count")
  assertEqual(weaponPlayer.inventory.counts[shells.index], 7, "inventory after ammo drop")

  weaponPlayer.inventory.counts[shotgun.index] = 2
  weaponPlayer.currentWeapon = shotgun
  weaponPlayer.newWeapon = void
  droppedWeapon = gprules.Drop_Weapon(weaponPlayer, shotgun, registry, 31, 0)
  assertTrue(droppedWeapon.success, "drop duplicate current weapon")
  assertEqual(weaponPlayer.inventory.counts[shotgun.index], 1, "weapon inventory after drop")
  refusedWeapon = gprules.Drop_Weapon(weaponPlayer, shotgun, registry, 32, 0)
  assertEqual(refusedWeapon.success, false, "last current weapon retained")

  grenades = gprules.findByPickupName(registry, "Grenades")
  weaponPlayer.currentWeapon = grenades
  weaponPlayer.inventory.counts[grenades.index] = 5
  assertEqual(gprules.Drop_Ammo(weaponPlayer, grenades, registry, 33).success, false, "last grenade weapon retained")
  return true
end function

function testWeaponStateMachine(registry)
  player = gptypes.createPlayer(3, gpregistry.inventorySlots(registry))
  blaster = gprules.findByPickupName(registry, "Blaster")
  shotgun = gprules.findByPickupName(registry, "Shotgun")
  shells = gprules.findByPickupName(registry, "Shells")
  machinegun = gprules.findByPickupName(registry, "Machinegun")
  bullets = gprules.findByPickupName(registry, "Bullets")
  player.inventory.counts[blaster.index] = 1
  player.currentWeapon = blaster
  player.edict.state.modelIndex = 255
  player.edict.state.skinNumber = player.edict.state.number - 1
  player.weaponState = gpconstants.WEAPON_ACTIVATING
  player.gunFrame = 0
  count = 0
  while count < 5
    blaster.weaponThink(player, blaster, registry, 0)
    count = count + 1
  end while
  assertEqual(player.weaponState, gpconstants.WEAPON_READY, "activation to ready")
  assertEqual(player.gunFrame, 9, "blaster idle first")
  assertEqual(player.edict.client.playerState.gunFrame, 9, "shared gunframe mirror")

  player.buttons = gameconstants.BUTTON_ATTACK
  fired = blaster.weaponThink(player, blaster, registry, 0)
  assertTrue(fired.fired, "blaster fire frame")
  assertEqual(player.fireCount, 1, "fire callback count")
  assertEqual(player.weaponState, gpconstants.WEAPON_FIRING, "weapon firing state")
  player.buttons = 0
  while player.weaponState == gpconstants.WEAPON_FIRING
    blaster.weaponThink(player, blaster, registry, 0)
  end while
  assertEqual(player.weaponState, gpconstants.WEAPON_READY, "firing to ready")

  player.inventory.counts[shotgun.index] = 1
  player.inventory.counts[shells.index] = 0
  player.inventory.counts[machinegun.index] = 1
  player.inventory.counts[bullets.index] = 10
  player.currentWeapon = shotgun
  player.weaponState = gpconstants.WEAPON_READY
  player.gunFrame = 19
  player.buttons = gameconstants.BUTTON_ATTACK
  noAmmo = shotgun.weaponThink(player, shotgun, registry, 0)
  assertTrue(noAmmo.noAmmo, "no-ammo branch")
  assertEqual(player.newWeapon.index, machinegun.index, "no-ammo fallback priority")

  player.buttons = 0
  dropping = shotgun.weaponThink(player, shotgun, registry, 0)
  assertEqual(dropping.state, gpconstants.WEAPON_DROPPING, "pending weapon starts drop")
  while player.weaponState == gpconstants.WEAPON_DROPPING
    shotgun.weaponThink(player, shotgun, registry, 0)
  end while
  assertEqual(player.currentWeapon.index, machinegun.index, "change weapon after drop")
  assertEqual(player.edict.state.skinNumber,
    (machinegun.weaponModel << 8) | (player.edict.state.number - 1),
    "visible player weapon encoded in upper skin byte: actual=" +
      player.edict.state.skinNumber + " expected=" +
      ((machinegun.weaponModel << 8) | (player.edict.state.number - 1)))
  assertEqual(player.weaponState, gpconstants.WEAPON_ACTIVATING, "new weapon activates")
  assertEqual(player.ammoIndex, bullets.index, "new weapon ammo index")
  return true
end function

function testDamageFoundations()
  target = gptypes.createCombatant(40, 100)
  target.armor = 50
  target.armorNormalProtection = 0.3
  target.armorEnergyProtection = 0.6
  request = gptypes.damageRequest([1.0, 0.0, 0.0], [5.0, 6.0, 7.0], 40, 20, 0, gpconstants.MOD_SHOTGUN)
  result = gpcombat.T_Damage(target, request)
  assertEqual(result.armorSaved, 12, "normal armor save")
  assertEqual(result.taken, 28, "damage after armor")
  assertEqual(target.health, 72, "health after damage")
  assertEqual(target.armor, 38, "armor inventory after damage")
  assertEqual(target.velocity[0], 100.0, "knockback momentum")
  assertEqual(target.damageFrom[2], 7.0, "damage source")

  pullTarget = gptypes.createCombatant(44, 100)
  pullRequest = gptypes.damageRequest([1.0, 0.0, 0.0], [0.0, 0.0, 0.0], 5, -10,
    gpconstants.DAMAGE_ENERGY, gpconstants.MOD_UNKNOWN)
  pullResult = gpcombat.T_Damage(pullTarget, pullRequest)
  assertEqual(pullResult.knockbackApplied, -50.0, "signed Floater-style knockback scale")
  assertEqual(pullTarget.velocity[0], -50.0, "signed knockback pulls target")

  target.flags = target.flags | gpconstants.FL_GODMODE
  protectedRequest = gptypes.damageRequest([0.0, 1.0, 0.0], [0.0, 0.0, 0.0], 20, 0, 0, gpconstants.MOD_BLASTER)
  protected = gpcombat.T_Damage(target, protectedRequest)
  assertEqual(protected.taken, 0, "godmode damage")
  assertEqual(protected.protectedDamage, 20, "godmode protection accounting")
  assertEqual(target.health, 72, "godmode health")

  friendly = gptypes.createCombatant(41, 100)
  friendlyRequest = gptypes.damageRequest([1.0, 0.0, 0.0], [0.0, 0.0, 0.0], 25, 10, 0, gpconstants.MOD_MACHINEGUN)
  friendlyRequest.sameTeam = true
  friendlyRequest.noFriendlyFire = true
  friendlyResult = gpcombat.T_Damage(friendly, friendlyRequest)
  assertEqual(friendlyResult.taken, 0, "friendly fire suppression")
  assertTrue(friendlyResult.knockbackApplied > 0.0, "friendly knockback retained")

  victim = gptypes.createCombatant(42, 30)
  victim.edict.state.origin = [10.0, 0.0, 0.0]
  attacker = gptypes.createCombatant(43, 100)
  attacker.edict.state.origin = [0.0, 0.0, 0.0]
  radiusResults = gpcombat.T_RadiusDamage([victim, attacker], [0.0, 0.0, 0.0], 43, 50.0, 100.0, -1, allowDamage, gpconstants.MOD_R_SPLASH)
  assertEqual(radiusResults[0].taken, 45, "radius falloff")
  assertEqual(victim.dead, true, "radius kill")
  assertEqual(radiusResults[1].taken, 25, "radius self-damage half")
  return true
end function

function main(args)
  print "MiniQuake2 gameplay items/weapons tests starting: 4"
  registry = testRegistryAndPrecache()
  testItemsAmmoDropAndRespawn(registry)
  testWeaponStateMachine(registry)
  testDamageFoundations()
  print "MiniQuake2 gameplay items/weapons tests passed: 4"
  return 0
end function
