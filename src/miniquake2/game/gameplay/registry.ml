/* Managed subset of baseq2's gitem_t registry: all stock weapons and ammo. */
package miniquake2.game.gameplay.registry

import miniquake2.game.gameplay.constants as gpconstants
import miniquake2.game.gameplay.item_rules as gprules
import miniquake2.game.gameplay.powerups as gppowerups
import miniquake2.game.gameplay.types as gptypes
import miniquake2.game.gameplay.weapons as gpweapons

function frames(activateLast, fireLast, idleLast, deactivateLast, pauseFrames, fireFrames)
  return gptypes.WeaponFrames(activateLast, fireLast, idleLast, deactivateLast, pauseFrames, fireFrames)
end function

function weapon(index, className, pickupName, quantity, ammo, weaponModel, worldModel, viewModel, icon, precaches, frameContract)
  pickupCallback = gprules.Pickup_Weapon
  dropCallback = gprules.Drop_Weapon
  if index == 1 then pickupCallback = void; dropCallback = void end if
  thinkCallback = gpweapons.Think_CurrentWeapon
  if weaponModel == gpconstants.WEAP_BFG then thinkCallback = gpweapons.Think_Bfg end if
  return gptypes.ItemDefinition(
    index, className, pickupCallback, gprules.Use_Weapon, dropCallback, thinkCallback,
    "misc/w_pkup.wav", worldModel, viewModel, icon, pickupName,
    quantity, ammo, gpconstants.IT_WEAPON | gpconstants.IT_STAY_COOP,
    weaponModel, 0, precaches, frameContract, void
  )
end function

function ammo(index, className, pickupName, quantity, tag, worldModel, icon)
  return gptypes.ItemDefinition(
    index, className, gprules.Pickup_Ammo, void, gprules.Drop_Ammo, void,
    "misc/am_pkup.wav", worldModel, "", icon, pickupName,
    quantity, "", gpconstants.IT_AMMO, 0, tag, "", void, void
  )
end function

function grenades(index)
  return gptypes.ItemDefinition(
    index, "ammo_grenades", gprules.Pickup_Ammo, gprules.Use_Weapon, gprules.Drop_Ammo, void,
    "misc/am_pkup.wav", "models/items/ammo/grenades/medium/tris.md2",
    "models/weapons/v_handgr/tris.md2", "a_grenades", "Grenades",
    5, "Grenades", gpconstants.IT_AMMO | gpconstants.IT_WEAPON,
    gpconstants.WEAP_GRENADES, gpconstants.AMMO_GRENADES,
    "weapons/hgrent1a.wav weapons/hgrena1b.wav weapons/hgrenc1b.wav weapons/hgrenb1a.wav weapons/hgrenb2a.wav",
    void, void
  )
end function

function defaultRegistry()
  blasterFrames = frames(4, 8, 52, 55, [19, 32], [5])
  shotgunFrames = frames(7, 18, 36, 39, [22, 28, 34], [8, 9])
  superShotgunFrames = frames(6, 17, 57, 61, [29, 42, 57], [7])
  machinegunFrames = frames(3, 5, 45, 49, [23, 45], [4, 5])
  chaingunFrames = frames(4, 31, 61, 64, [38, 43, 51, 61], [5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21])
  grenadeLauncherFrames = frames(5, 16, 59, 64, [34, 51, 59], [6])
  rocketLauncherFrames = frames(4, 12, 50, 54, [25, 33, 42, 50], [5])
  hyperBlasterFrames = frames(5, 20, 49, 53, [], [6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20])
  railgunFrames = frames(3, 18, 56, 61, [56], [4])
  bfgFrames = frames(8, 32, 55, 58, [39, 45, 50, 55], [9, 17])
  items = [
    weapon(1, "weapon_blaster", "Blaster", 0, "", gpconstants.WEAP_BLASTER, "", "models/weapons/v_blast/tris.md2", "w_blaster", "weapons/blastf1a.wav misc/lasfly.wav", blasterFrames),
    weapon(2, "weapon_shotgun", "Shotgun", 1, "Shells", gpconstants.WEAP_SHOTGUN, "models/weapons/g_shotg/tris.md2", "models/weapons/v_shotg/tris.md2", "w_shotgun", "weapons/shotgf1b.wav weapons/shotgr1b.wav", shotgunFrames),
    weapon(3, "weapon_supershotgun", "Super Shotgun", 2, "Shells", gpconstants.WEAP_SUPERSHOTGUN, "models/weapons/g_shotg2/tris.md2", "models/weapons/v_shotg2/tris.md2", "w_sshotgun", "weapons/sshotf1b.wav", superShotgunFrames),
    weapon(4, "weapon_machinegun", "Machinegun", 1, "Bullets", gpconstants.WEAP_MACHINEGUN, "models/weapons/g_machn/tris.md2", "models/weapons/v_machn/tris.md2", "w_machinegun", "weapons/machgf1b.wav weapons/machgf2b.wav weapons/machgf3b.wav weapons/machgf4b.wav weapons/machgf5b.wav", machinegunFrames),
    weapon(5, "weapon_chaingun", "Chaingun", 1, "Bullets", gpconstants.WEAP_CHAINGUN, "models/weapons/g_chain/tris.md2", "models/weapons/v_chain/tris.md2", "w_chaingun", "weapons/chngnu1a.wav weapons/chngnl1a.wav weapons/chngnd1a.wav", chaingunFrames),
    grenades(6),
    weapon(7, "weapon_grenadelauncher", "Grenade Launcher", 1, "Grenades", gpconstants.WEAP_GRENADELAUNCHER, "models/weapons/g_launch/tris.md2", "models/weapons/v_launch/tris.md2", "w_glauncher", "models/objects/grenade/tris.md2 weapons/grenlf1a.wav weapons/grenlr1b.wav weapons/grenlb1b.wav", grenadeLauncherFrames),
    weapon(8, "weapon_rocketlauncher", "Rocket Launcher", 1, "Rockets", gpconstants.WEAP_ROCKETLAUNCHER, "models/weapons/g_rocket/tris.md2", "models/weapons/v_rocket/tris.md2", "w_rlauncher", "models/objects/rocket/tris.md2 weapons/rockfly.wav weapons/rocklf1a.wav weapons/rocklr1b.wav models/objects/debris2/tris.md2", rocketLauncherFrames),
    weapon(9, "weapon_hyperblaster", "HyperBlaster", 1, "Cells", gpconstants.WEAP_HYPERBLASTER, "models/weapons/g_hyperb/tris.md2", "models/weapons/v_hyperb/tris.md2", "w_hyperblaster", "weapons/hyprbu1a.wav weapons/hyprbl1a.wav weapons/hyprbf1a.wav weapons/hyprbd1a.wav misc/lasfly.wav", hyperBlasterFrames),
    weapon(10, "weapon_railgun", "Railgun", 1, "Slugs", gpconstants.WEAP_RAILGUN, "models/weapons/g_rail/tris.md2", "models/weapons/v_rail/tris.md2", "w_railgun", "weapons/rg_hum.wav", railgunFrames),
    weapon(11, "weapon_bfg", "BFG10K", 50, "Cells", gpconstants.WEAP_BFG, "models/weapons/g_bfg/tris.md2", "models/weapons/v_bfg/tris.md2", "w_bfg", "sprites/s_bfg1.sp2 sprites/s_bfg2.sp2 sprites/s_bfg3.sp2 weapons/bfg__f1y.wav weapons/bfg__l1a.wav weapons/bfg__x1b.wav weapons/bfg_hum.wav", bfgFrames),
    ammo(12, "ammo_shells", "Shells", 10, gpconstants.AMMO_SHELLS, "models/items/ammo/shells/medium/tris.md2", "a_shells"),
    ammo(13, "ammo_bullets", "Bullets", 50, gpconstants.AMMO_BULLETS, "models/items/ammo/bullets/medium/tris.md2", "a_bullets"),
    ammo(14, "ammo_cells", "Cells", 50, gpconstants.AMMO_CELLS, "models/items/ammo/cells/medium/tris.md2", "a_cells"),
    ammo(15, "ammo_rockets", "Rockets", 5, gpconstants.AMMO_ROCKETS, "models/items/ammo/rockets/medium/tris.md2", "a_rockets"),
    ammo(16, "ammo_slugs", "Slugs", 10, gpconstants.AMMO_SLUGS, "models/items/ammo/slugs/medium/tris.md2", "a_slugs")
  ]
  return gptypes.ItemRegistry(items)
end function

function inventorySlots(registry)
  maximum = 0
  for each item in registry.items
    if item.index > maximum then maximum = item.index end if
  end for
  return maximum + 1
end function

function stockItem(index, className, pickup, use, drop, pickupSound, worldModel, icon, pickupName, quantity, flags, tag, precaches, ruleData)
  return gptypes.ItemDefinition(
    index, className, pickup, use, drop, void,
    pickupSound, worldModel, "", icon, pickupName,
    quantity, "", flags, 0, tag, precaches, void, ruleData
  )
end function

function armorData(baseCount, maxCount, normalProtection, energyProtection)
  return gptypes.itemRuleData("armor", baseCount, maxCount, normalProtection, energyProtection, 0, 0, 0)
end function

function simpleData(kind, duration)
  return gptypes.itemRuleData(kind, 0, 0, 0.0, 0.0, 0, 0, duration)
end function

function healthData(count, style)
  return gptypes.itemRuleData("health", 0, 0, 0.0, 0.0, count, style, 0)
end function

// Additive complete stock registry. defaultRegistry deliberately remains the
// original weapon/ammo subset so its established indices and golden tests are
// stable until the integration layer opts into this registry.
function stockRegistry()
  items = defaultRegistry().items
  extras = [
    stockItem(17, "item_armor_body", gppowerups.Pickup_Armor, void, void, "misc/ar1_pkup.wav", "models/items/armor/body/tris.md2", "i_bodyarmor", "Body Armor", 0, gpconstants.IT_ARMOR, gpconstants.ARMOR_BODY, "", armorData(100, 200, 0.80, 0.60)),
    stockItem(18, "item_armor_combat", gppowerups.Pickup_Armor, void, void, "misc/ar1_pkup.wav", "models/items/armor/combat/tris.md2", "i_combatarmor", "Combat Armor", 0, gpconstants.IT_ARMOR, gpconstants.ARMOR_COMBAT, "", armorData(50, 100, 0.60, 0.30)),
    stockItem(19, "item_armor_jacket", gppowerups.Pickup_Armor, void, void, "misc/ar1_pkup.wav", "models/items/armor/jacket/tris.md2", "i_jacketarmor", "Jacket Armor", 0, gpconstants.IT_ARMOR, gpconstants.ARMOR_JACKET, "", armorData(25, 50, 0.30, 0.0)),
    stockItem(20, "item_armor_shard", gppowerups.Pickup_Armor, void, void, "misc/ar2_pkup.wav", "models/items/armor/shard/tris.md2", "i_jacketarmor", "Armor Shard", 0, gpconstants.IT_ARMOR, gpconstants.ARMOR_SHARD, "", simpleData("armor-shard", 0)),
    stockItem(21, "item_power_screen", gppowerups.Pickup_PowerArmor, gppowerups.Use_PowerArmor, gppowerups.Drop_PowerArmor, "misc/ar3_pkup.wav", "models/items/armor/screen/tris.md2", "i_powerscreen", "Power Screen", 60, gpconstants.IT_ARMOR, gpconstants.POWER_ARMOR_SCREEN, "misc/power2.wav misc/power1.wav", simpleData("power-armor", 0)),
    stockItem(22, "item_power_shield", gppowerups.Pickup_PowerArmor, gppowerups.Use_PowerArmor, gppowerups.Drop_PowerArmor, "misc/ar3_pkup.wav", "models/items/armor/shield/tris.md2", "i_powershield", "Power Shield", 60, gpconstants.IT_ARMOR, gpconstants.POWER_ARMOR_SHIELD, "misc/power2.wav misc/power1.wav", simpleData("power-armor", 0)),
    stockItem(23, "item_quad", gppowerups.Pickup_Powerup, gppowerups.Use_Quad, gppowerups.Drop_General, "items/pkup.wav", "models/items/quaddama/tris.md2", "p_quad", "Quad Damage", 60, gpconstants.IT_POWERUP, 0, "items/damage.wav items/damage2.wav items/damage3.wav", simpleData("powerup", 300)),
    stockItem(24, "item_invulnerability", gppowerups.Pickup_Powerup, gppowerups.Use_Invulnerability, gppowerups.Drop_General, "items/pkup.wav", "models/items/invulner/tris.md2", "p_invulnerability", "Invulnerability", 300, gpconstants.IT_POWERUP, 0, "items/protect.wav items/protect2.wav items/protect4.wav", simpleData("powerup", 300)),
    stockItem(25, "item_silencer", gppowerups.Pickup_Powerup, gppowerups.Use_Silencer, gppowerups.Drop_General, "items/pkup.wav", "models/items/silencer/tris.md2", "p_silencer", "Silencer", 60, gpconstants.IT_POWERUP, 0, "", simpleData("powerup", 30)),
    stockItem(26, "item_breather", gppowerups.Pickup_Powerup, gppowerups.Use_Breather, gppowerups.Drop_General, "items/pkup.wav", "models/items/breather/tris.md2", "p_rebreather", "Rebreather", 60, gpconstants.IT_STAY_COOP | gpconstants.IT_POWERUP, 0, "items/airout.wav", simpleData("powerup", 300)),
    stockItem(27, "item_enviro", gppowerups.Pickup_Powerup, gppowerups.Use_Envirosuit, gppowerups.Drop_General, "items/pkup.wav", "models/items/enviro/tris.md2", "p_envirosuit", "Environment Suit", 60, gpconstants.IT_STAY_COOP | gpconstants.IT_POWERUP, 0, "items/airout.wav", simpleData("powerup", 300)),
    stockItem(28, "item_ancient_head", gppowerups.Pickup_AncientHead, void, void, "items/pkup.wav", "models/items/c_head/tris.md2", "i_fixme", "Ancient Head", 60, 0, 0, "", simpleData("capacity", 0)),
    stockItem(29, "item_adrenaline", gppowerups.Pickup_Adrenaline, void, void, "items/pkup.wav", "models/items/adrenal/tris.md2", "p_adrenaline", "Adrenaline", 60, 0, 0, "", simpleData("capacity", 0)),
    stockItem(30, "item_bandolier", gppowerups.Pickup_Bandolier, void, void, "items/pkup.wav", "models/items/band/tris.md2", "p_bandolier", "Bandolier", 60, 0, 0, "", simpleData("capacity", 0)),
    stockItem(31, "item_pack", gppowerups.Pickup_Pack, void, void, "items/pkup.wav", "models/items/pack/tris.md2", "i_pack", "Ammo Pack", 180, 0, 0, "", simpleData("capacity", 0)),
    stockItem(32, "key_data_cd", gppowerups.Pickup_Key, void, gppowerups.Drop_General, "items/pkup.wav", "models/items/keys/data_cd/tris.md2", "k_datacd", "Data CD", 0, gpconstants.IT_STAY_COOP | gpconstants.IT_KEY, 0, "", simpleData("key", 0)),
    stockItem(33, "key_power_cube", gppowerups.Pickup_Key, void, gppowerups.Drop_General, "items/pkup.wav", "models/items/keys/power/tris.md2", "k_powercube", "Power Cube", 0, gpconstants.IT_STAY_COOP | gpconstants.IT_KEY, 0, "", simpleData("key", 0)),
    stockItem(34, "key_pyramid", gppowerups.Pickup_Key, void, gppowerups.Drop_General, "items/pkup.wav", "models/items/keys/pyramid/tris.md2", "k_pyramid", "Pyramid Key", 0, gpconstants.IT_STAY_COOP | gpconstants.IT_KEY, 0, "", simpleData("key", 0)),
    stockItem(35, "key_data_spinner", gppowerups.Pickup_Key, void, gppowerups.Drop_General, "items/pkup.wav", "models/items/keys/spinner/tris.md2", "k_dataspin", "Data Spinner", 0, gpconstants.IT_STAY_COOP | gpconstants.IT_KEY, 0, "", simpleData("key", 0)),
    stockItem(36, "key_pass", gppowerups.Pickup_Key, void, gppowerups.Drop_General, "items/pkup.wav", "models/items/keys/pass/tris.md2", "k_security", "Security Pass", 0, gpconstants.IT_STAY_COOP | gpconstants.IT_KEY, 0, "", simpleData("key", 0)),
    stockItem(37, "key_blue_key", gppowerups.Pickup_Key, void, gppowerups.Drop_General, "items/pkup.wav", "models/items/keys/key/tris.md2", "k_bluekey", "Blue Key", 0, gpconstants.IT_STAY_COOP | gpconstants.IT_KEY, 0, "", simpleData("key", 0)),
    stockItem(38, "key_red_key", gppowerups.Pickup_Key, void, gppowerups.Drop_General, "items/pkup.wav", "models/items/keys/red_key/tris.md2", "k_redkey", "Red Key", 0, gpconstants.IT_STAY_COOP | gpconstants.IT_KEY, 0, "", simpleData("key", 0)),
    stockItem(39, "key_commander_head", gppowerups.Pickup_Key, void, gppowerups.Drop_General, "items/pkup.wav", "models/monsters/commandr/head/tris.md2", "k_comhead", "Commander's Head", 0, gpconstants.IT_STAY_COOP | gpconstants.IT_KEY, 0, "", simpleData("key", 0)),
    stockItem(40, "key_airstrike_target", gppowerups.Pickup_Key, void, gppowerups.Drop_General, "items/pkup.wav", "models/items/keys/target/tris.md2", "i_airstrike", "Airstrike Marker", 0, gpconstants.IT_STAY_COOP | gpconstants.IT_KEY, 0, "", simpleData("key", 0)),
    stockItem(41, "item_health", gppowerups.Pickup_Health, void, void, "items/n_health.wav", "models/items/healing/medium/tris.md2", "i_health", "Health", 0, 0, 0, "items/s_health.wav items/n_health.wav items/l_health.wav items/m_health.wav", healthData(10, 0)),
    stockItem(42, "item_health_small", gppowerups.Pickup_Health, void, void, "items/s_health.wav", "models/items/healing/stimpack/tris.md2", "i_health", "Health", 0, 0, 0, "", healthData(2, gpconstants.HEALTH_IGNORE_MAX)),
    stockItem(43, "item_health_large", gppowerups.Pickup_Health, void, void, "items/l_health.wav", "models/items/healing/large/tris.md2", "i_health", "Health", 0, 0, 0, "", healthData(25, 0)),
    stockItem(44, "item_health_mega", gppowerups.Pickup_Health, void, void, "items/m_health.wav", "models/items/mega_h/tris.md2", "i_health", "Health", 0, 0, 0, "", healthData(100, gpconstants.HEALTH_IGNORE_MAX | gpconstants.HEALTH_TIMED))
  ]
  return gptypes.ItemRegistry(items + extras)
end function

function baseq2Registry()
  return stockRegistry()
end function

function validate(registry)
  for each item in registry.items
    if item.index <= 0 or item.className == "" or item.pickupName == "" then return error(9360, "invalid item registry entry") end if
    otherIndex = 0
    while otherIndex < len(registry.items)
      other = registry.items[otherIndex]
      duplicatePickup = item.pickupName == other.pickupName
      if duplicatePickup and item.ruleData is not void and other.ruleData is not void and item.ruleData.kind == "health" and other.ruleData.kind == "health" then duplicatePickup = false end if
      if nativeRawValue(item) != nativeRawValue(other) and (item.index == other.index or item.className == other.className or duplicatePickup) then
        return error(9361, "duplicate item registry entry " + item.pickupName)
      end if
      otherIndex = otherIndex + 1
    end while
  end for
  return true
end function
