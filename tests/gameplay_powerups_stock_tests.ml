/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Native stock armor/health/powerup/key scenarios from BaseQ2 g_items.c. */
import miniquake2.game.constants as gameconstants
import miniquake2.game.gameplay.combat as gpcombat
import miniquake2.game.gameplay.constants as gpconstants
import miniquake2.game.gameplay.item_rules as gprules
import miniquake2.game.gameplay.powerups as gppowerups
import miniquake2.game.gameplay.precache as gpprecache
import miniquake2.game.gameplay.registry as gpregistry
import miniquake2.game.gameplay.types as gptypes
import miniquake2.game.player.types as gplayertypes
import miniquake2.qcommon.types as qtypes
import miniquake2.server.game_bridge as gbridge

function assertEqual(actual, expected, name)
  if actual != expected then return error(9760, name + ": values differ") end if
  return true
end function

function assertTrue(value, name)
  if value != true then return error(9761, name + ": expected true") end if
  return true
end function

function emptyTrace(start, mins, maxs, finish)
  plane = qtypes.Plane(qtypes.Vec3(0.0, 0.0, 0.0), 0.0, 0, 0)
  surface = qtypes.CollisionSurface("powerups/test", 0, 0)
  return qtypes.Trace(false, false, 1.0, qtypes.Vec3(finish.x, finish.y, finish.z), plane, surface, 0, void)
end function

function itemEntity(registry, pickupName, number)
  item = gprules.findByPickupName(registry, pickupName)
  if item is void then return error(9762, "missing item " + pickupName) end if
  return gptypes.createItemEntity(number, item)
end function

function classEntity(registry, className, number)
  item = gprules.findByClassName(registry, className)
  if item is void then return error(9763, "missing class " + className) end if
  return gptypes.createItemEntity(number, item)
end function

function testRegistryArmorAndCombat()
  assertEqual(len(gpregistry.defaultRegistry().items), 16, "compatible weapon registry")
  registry = gpregistry.stockRegistry()
  assertEqual(len(registry.items), 44, "complete stock registry")
  assertTrue(gpregistry.validate(registry), "stock registry validation")
  assertEqual(gpregistry.inventorySlots(registry), 45, "stock inventory slots")
  assertEqual(typeof(gprules.findByPickupName(registry, "Body Armor").pickup), "function", "armor callback")
  assertEqual(typeof(gprules.findByPickupName(registry, "Quad Damage").use), "function", "powerup callback")
  assertEqual(typeof(gprules.findByClassName(registry, "key_data_cd").drop), "function", "key drop callback")

  player = gptypes.createPlayer(1, gpregistry.inventorySlots(registry))
  context = gptypes.pickupContext(false, false, 0, 0.0)
  jacket = classEntity(registry, "item_armor_jacket", 20)
  assertTrue(gprules.Pickup_Item(jacket, player, context, registry).success, "jacket pickup")
  assertEqual(player.inventory.counts[19], 25, "jacket base count")
  body = classEntity(registry, "item_armor_body", 21)
  gprules.Pickup_Item(body, player, context, registry)
  assertEqual(player.inventory.counts[19], 0, "old jacket removed")
  assertEqual(player.inventory.counts[17], 109, "body armor jacket salvage")
  combat = classEntity(registry, "item_armor_combat", 22)
  gprules.Pickup_Item(combat, player, context, registry)
  assertEqual(player.inventory.counts[17], 146, "inferior combat salvaged into body")
  shard = classEntity(registry, "item_armor_shard", 23)
  gprules.Pickup_Item(shard, player, context, registry)
  assertEqual(player.inventory.counts[17], 148, "armor shard adds two")
  assertEqual(gppowerups.ArmorIndex(player, registry), 17, "active armor index")

  combatant = gptypes.createCombatant(1, 100)
  assertTrue(gppowerups.SyncArmorToCombatant(player, combatant, registry), "armor combat adapter")
  assertEqual(combatant.armor, 148, "combat armor points")
  assertEqual(combatant.armorNormalProtection, 0.80, "body normal protection")
  assertEqual(combatant.armorEnergyProtection, 0.60, "body energy protection")
  request = gptypes.damageRequest([1.0, 0.0, 0.0], [0.0, 0.0, 0.0], 100, 0, 0, gpconstants.MOD_BLASTER)
  damage = gpcombat.T_Damage(combatant, request)
  assertEqual(damage.armorSaved, 80, "body armor save")
  gppowerups.SyncArmorFromCombatant(player, combatant)
  assertEqual(player.inventory.counts[17], 68, "armor writeback")
  return registry
end function

function testPowerArmorAndPowerups(registry)
  player = gptypes.createPlayer(2, gpregistry.inventorySlots(registry))
  deathmatch = gptypes.pickupContext(true, false, 0, 10.0)
  deathmatch.frameNumber = 100
  screen = itemEntity(registry, "Power Screen", 30)
  assertTrue(gprules.Pickup_Item(screen, player, deathmatch, registry).success, "power screen pickup")
  assertEqual((player.flags & gpconstants.FL_POWER_ARMOR), 0, "no cells blocks auto-use")
  cells = gprules.findByPickupName(registry, "Cells")
  player.inventory.counts[cells.index] = 50
  assertTrue(gppowerups.Use_PowerArmor(player, screen.item, deathmatch, registry).success, "power screen enable")
  assertEqual(gppowerups.PowerArmorType(player, registry), gpconstants.POWER_ARMOR_SCREEN, "power screen type")
  screenSave = gppowerups.CheckPowerArmor(player, registry, 90, 0, true)
  assertEqual(screenSave.saved, 30, "power screen one-third save")
  assertEqual(screenSave.cellsUsed, 30, "power screen cell use")
  assertEqual(gppowerups.CheckPowerArmor(player, registry, 90, 0, false).saved, 0, "power screen rear hit")
  player.inventory.counts[cells.index] = 50
  shield = itemEntity(registry, "Power Shield", 31)
  gprules.Pickup_Item(shield, player, deathmatch, registry)
  if (player.flags & gpconstants.FL_POWER_ARMOR) == 0 then gppowerups.Use_PowerArmor(player, shield.item, deathmatch, registry) end if
  assertEqual(gppowerups.PowerArmorType(player, registry), gpconstants.POWER_ARMOR_SHIELD, "shield priority")
  shieldSave = gppowerups.CheckPowerArmor(player, registry, 90, 0, false)
  assertEqual(shieldSave.saved, 60, "power shield two-thirds save")
  assertEqual(shieldSave.cellsUsed, 30, "power shield two damage per cell")
  dropped = gppowerups.Drop_PowerArmor(player, shield.item, registry, 90)
  assertTrue(dropped.success, "power armor drop")
  assertEqual(gppowerups.PowerArmorType(player, registry), gpconstants.POWER_ARMOR_NONE, "dropping active last shield disables power armor")
  gppowerups.Use_PowerArmor(player, screen.item, deathmatch, registry)
  assertEqual(gppowerups.PowerArmorType(player, registry), gpconstants.POWER_ARMOR_SCREEN, "remaining screen can be re-enabled")

  quad = itemEntity(registry, "Quad Damage", 32)
  assertTrue(gprules.Pickup_Item(quad, player, deathmatch, registry).success, "quad pickup")
  assertTrue(gppowerups.Use_Quad(player, quad.item, deathmatch, registry).success, "quad use")
  assertEqual(player.quadFrame, 400, "quad duration")
  player.inventory.counts[quad.item.index] = 1
  gppowerups.Use_Quad(player, quad.item, deathmatch, registry)
  assertEqual(player.quadFrame, 700, "quad duration stacks")

  invulnerability = itemEntity(registry, "Invulnerability", 33)
  instant = gptypes.pickupContext(true, false, gameconstants.DF_INSTANT_ITEMS, 0.0)
  instant.frameNumber = 50
  assertTrue(gprules.Pickup_Item(invulnerability, player, instant, registry).success, "instant invulnerability pickup")
  assertEqual(player.inventory.counts[invulnerability.item.index], 0, "instant item consumed")
  assertEqual(player.invincibleFrame, 350, "invulnerability frame")

  breather = itemEntity(registry, "Rebreather", 34)
  normal = gptypes.pickupContext(false, false, 0, 0.0)
  normal.frameNumber = 25
  gprules.Pickup_Item(breather, player, normal, registry)
  gppowerups.Use_Breather(player, breather.item, normal, registry)
  assertEqual(player.breatherFrame, 325, "breather frame")
  enviro = itemEntity(registry, "Environment Suit", 35)
  gprules.Pickup_Item(enviro, player, normal, registry)
  gppowerups.Use_Envirosuit(player, enviro.item, normal, registry)
  assertEqual(player.enviroFrame, 325, "enviro frame")
  silencer = itemEntity(registry, "Silencer", 36)
  gprules.Pickup_Item(silencer, player, normal, registry)
  gppowerups.Use_Silencer(player, silencer.item, normal, registry)
  assertEqual(player.silencerShots, 30, "silencer shots")

  limitedPlayer = gptypes.createPlayer(3, gpregistry.inventorySlots(registry))
  hard = gptypes.pickupContext(false, false, 0, 0.0)
  hard.skill = 2
  assertTrue(gprules.Pickup_Item(itemEntity(registry, "Quad Damage", 37), limitedPlayer, hard, registry).success, "first hard-skill powerup")
  assertEqual(gprules.Pickup_Item(itemEntity(registry, "Quad Damage", 38), limitedPlayer, hard, registry).success, false, "hard-skill powerup cap")
  return true
end function

function testHealthCapacityAndKeys(registry)
  player = gptypes.createPlayer(4, gpregistry.inventorySlots(registry))
  normal = gptypes.pickupContext(false, false, 0, 0.0)
  player.health = 90
  medium = classEntity(registry, "item_health", 40)
  assertEqual(gprules.Pickup_Item(medium, player, normal, registry).amount, 10, "medium health")
  assertEqual(player.health, 100, "medium health cap")
  small = classEntity(registry, "item_health_small", 41)
  gprules.Pickup_Item(small, player, normal, registry)
  assertEqual(player.health, 102, "stimpack ignores max")

  mega = classEntity(registry, "item_health_mega", 42)
  assertEqual(gprules.Pickup_Item(mega, player, normal, registry).amount, 100, "megahealth pickup")
  assertEqual(player.health, 202, "megahealth ignores max")
  assertTrue(mega.decaying, "megahealth decay scheduled")
  normal.time = 5.0
  assertTrue(gppowerups.MegaHealthThink(mega, normal), "megahealth first decay")
  assertEqual(player.health, 201, "megahealth decays by one")
  player.health = player.maxHealth
  mega.nextThink = 6.0
  normal.time = 6.0
  normal.deathmatch = true
  gppowerups.MegaHealthThink(mega, normal)
  assertEqual(mega.decaying, false, "megahealth decay complete")
  assertEqual(mega.respawnAt, 26.0, "megahealth deathmatch respawn")

  player.health = 50
  adrenaline = itemEntity(registry, "Adrenaline", 43)
  gprules.Pickup_Item(adrenaline, player, normal, registry)
  // deathmatch restores health but does not increase max health.
  assertEqual(player.maxHealth, 100, "DM adrenaline max health")
  assertEqual(player.health, 100, "adrenaline restores max")
  normal.deathmatch = false
  gprules.Pickup_Item(itemEntity(registry, "Ancient Head", 44), player, normal, registry)
  assertEqual(player.maxHealth, 102, "ancient head max health")
  gprules.Pickup_Item(itemEntity(registry, "Adrenaline", 45), player, normal, registry)
  assertEqual(player.maxHealth, 103, "SP adrenaline max health")

  bandolier = itemEntity(registry, "Bandolier", 46)
  gprules.Pickup_Item(bandolier, player, normal, registry)
  assertEqual(player.inventory.maxBullets, 250, "bandolier bullet cap")
  assertEqual(player.inventory.maxShells, 150, "bandolier shell cap")
  assertEqual(player.inventory.counts[13], 50, "bandolier bullets")
  assertEqual(player.inventory.counts[12], 10, "bandolier shells")
  pack = itemEntity(registry, "Ammo Pack", 47)
  gprules.Pickup_Item(pack, player, normal, registry)
  assertEqual(player.inventory.maxRockets, 100, "pack rocket cap")
  assertEqual(player.inventory.maxGrenades, 100, "pack grenade cap")
  assertEqual(player.inventory.maxCells, 300, "pack cell cap")
  assertEqual(player.inventory.maxSlugs, 100, "pack slug cap")

  coop = gptypes.pickupContext(false, true, 0, 0.0)
  dataCd = classEntity(registry, "key_data_cd", 48)
  assertTrue(gprules.Pickup_Item(dataCd, player, coop, registry).success, "coop key pickup")
  assertEqual(gprules.Pickup_Item(classEntity(registry, "key_data_cd", 49), player, coop, registry).success, false, "coop duplicate key")
  cube = classEntity(registry, "key_power_cube", 50)
  cube.spawnFlags = 0x00000100
  assertTrue(gprules.Pickup_Item(cube, player, coop, registry).success, "first power cube")
  sameCube = classEntity(registry, "key_power_cube", 51)
  sameCube.spawnFlags = 0x00000100
  assertEqual(gprules.Pickup_Item(sameCube, player, coop, registry).success, false, "duplicate power cube bit")
  otherCube = classEntity(registry, "key_power_cube", 52)
  otherCube.spawnFlags = 0x00000200
  assertTrue(gprules.Pickup_Item(otherCube, player, coop, registry).success, "different power cube bit")
  assertEqual(player.powerCubes, 3, "power cube mask")
  return true
end function

function testPlayerAdaptersAndPrecache(registry)
  runtime = gbridge.createRuntime(1)
  imports = gbridge.makeImports(runtime)
  playerContext = gplayertypes.createContext(imports, registry, emptyTrace)
  playerData = gplayertypes.createPlayer(1, registry)
  playerContext.players = [playerData]
  jacket = classEntity(registry, "item_armor_jacket", 60)
  playerData.health = 0
  deadAction = gppowerups.PickupForPlayerData(jacket, playerData, playerContext)
  assertEqual(deadAction.success, false, "dead PlayerData cannot pick up items")
  assertEqual(playerData.gameplay.inventory.counts[jacket.item.index], 0,
    "dead pickup leaves inventory unchanged")
  playerData.health = 100
  action = gppowerups.PickupForPlayerData(jacket, playerData, playerContext)
  assertTrue(action.success, "PlayerData pickup adapter")
  assertEqual(runtime.pendingSoundCount, 1, "PlayerData pickup sound count")
  assertEqual(runtime.soundNames[runtime.pendingSounds[0].soundIndex],
    "misc/ar1_pkup.wav", "PlayerData pickup sound")
  assertEqual(playerData.armorItemIndex, 19, "PlayerData armor HUD index")
  assertEqual(playerData.view.bonusAlpha, 0.25, "PlayerData pickup blend")
  assertEqual(playerData.edict.client.playerState.stats[gameconstants.STAT_PICKUP_STRING], qtypes.zeroUserCmd().buttons + miniquake2.qcommon.constants.CS_ITEMS + 19, "PlayerData pickup configstring")

  playerData.health = 90
  smallHealth = classEntity(registry, "item_health_small", 61)
  assertTrue(gppowerups.PickupForPlayerData(smallHealth, playerData, playerContext).success,
    "PlayerData small health pickup")
  assertEqual(runtime.soundNames[runtime.pendingSounds[1].soundIndex],
    "items/s_health.wav", "small health pickup sound")
  customHealth = classEntity(registry, "item_health", 62)
  customHealth.count = 25
  assertTrue(gppowerups.PickupForPlayerData(customHealth, playerData, playerContext).success,
    "PlayerData custom health pickup")
  assertEqual(runtime.soundNames[runtime.pendingSounds[2].soundIndex],
    "items/l_health.wav", "custom-count health pickup sound")

  playerData.gameplay.quadFrame = 350
  playerData.gameplay.invincibleFrame = 360
  playerData.gameplay.breatherFrame = 370
  playerData.gameplay.enviroFrame = 380
  gppowerups.SyncToPlayerData(playerData.gameplay, playerData)
  assertEqual(playerData.powerups.quadFrame, 350, "quad PlayerView adapter")
  assertEqual(playerData.powerups.invincibleFrame, 360, "invulnerability PlayerView adapter")
  assertEqual(playerData.powerups.breatherFrame, 370, "breather PlayerView adapter")
  assertEqual(playerData.powerups.enviroFrame, 380, "enviro PlayerView adapter")

  shield = gprules.findByPickupName(registry, "Power Shield")
  cached = gpprecache.PrecacheItem(registry, shield, imports)
  assertTrue(contains(cached.models, "models/items/armor/shield/tris.md2"), "power shield model precache")
  assertTrue(contains(cached.sounds, "misc/power1.wav"), "power armor enable sound precache")
  assertTrue(contains(cached.sounds, "misc/power2.wav"), "power armor disable sound precache")
  return true
end function

function contains(values, expected)
  for each value in values
    if value == expected then return true end if
  end for
  return false
end function

function runPowerupTests()
  registry = testRegistryArmorAndCombat()
  testPowerArmorAndPowerups(registry)
  testHealthCapacityAndKeys(registry)
  testPlayerAdaptersAndPrecache(registry)
  print "MiniQuake2 gameplay stock powerup tests passed: 4"
end function

runPowerupTests()
