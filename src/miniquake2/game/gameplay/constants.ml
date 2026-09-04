//! Provides miniquake2 game gameplay constants facilities for this project.

/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Quake II baseq2 gameplay constants from g_local.h. */
package miniquake2.game.gameplay.constants

/// Defines the it weapon constant used by the miniquake2 game gameplay constants module.
const IT_WEAPON = 1
/// Defines the it ammo constant used by the miniquake2 game gameplay constants module.
const IT_AMMO = 2
/// Defines the it armor constant used by the miniquake2 game gameplay constants module.
const IT_ARMOR = 4
/// Defines the it stay coop constant used by the miniquake2 game gameplay constants module.
const IT_STAY_COOP = 8
/// Defines the it key constant used by the miniquake2 game gameplay constants module.
const IT_KEY = 16
/// Defines the it powerup constant used by the miniquake2 game gameplay constants module.
const IT_POWERUP = 32

/// Defines the weap blaster constant used by the miniquake2 game gameplay constants module.
const WEAP_BLASTER = 1
/// Defines the weap shotgun constant used by the miniquake2 game gameplay constants module.
const WEAP_SHOTGUN = 2
/// Defines the weap supershotgun constant used by the miniquake2 game gameplay constants module.
const WEAP_SUPERSHOTGUN = 3
/// Defines the weap machinegun constant used by the miniquake2 game gameplay constants module.
const WEAP_MACHINEGUN = 4
/// Defines the weap chaingun constant used by the miniquake2 game gameplay constants module.
const WEAP_CHAINGUN = 5
/// Defines the weap grenades constant used by the miniquake2 game gameplay constants module.
const WEAP_GRENADES = 6
/// Defines the weap grenadelauncher constant used by the miniquake2 game gameplay constants module.
const WEAP_GRENADELAUNCHER = 7
/// Defines the weap rocketlauncher constant used by the miniquake2 game gameplay constants module.
const WEAP_ROCKETLAUNCHER = 8
/// Defines the weap hyperblaster constant used by the miniquake2 game gameplay constants module.
const WEAP_HYPERBLASTER = 9
/// Defines the weap railgun constant used by the miniquake2 game gameplay constants module.
const WEAP_RAILGUN = 10
/// Defines the weap bfg constant used by the miniquake2 game gameplay constants module.
const WEAP_BFG = 11

/// Defines the ammo bullets constant used by the miniquake2 game gameplay constants module.
const AMMO_BULLETS = 0
/// Defines the ammo shells constant used by the miniquake2 game gameplay constants module.
const AMMO_SHELLS = 1
/// Defines the ammo rockets constant used by the miniquake2 game gameplay constants module.
const AMMO_ROCKETS = 2
/// Defines the ammo grenades constant used by the miniquake2 game gameplay constants module.
const AMMO_GRENADES = 3
/// Defines the ammo cells constant used by the miniquake2 game gameplay constants module.
const AMMO_CELLS = 4
/// Defines the ammo slugs constant used by the miniquake2 game gameplay constants module.
const AMMO_SLUGS = 5

/// Defines the weapon ready constant used by the miniquake2 game gameplay constants module.
const WEAPON_READY = 0
/// Defines the weapon activating constant used by the miniquake2 game gameplay constants module.
const WEAPON_ACTIVATING = 1
/// Defines the weapon dropping constant used by the miniquake2 game gameplay constants module.
const WEAPON_DROPPING = 2
/// Defines the weapon firing constant used by the miniquake2 game gameplay constants module.
const WEAPON_FIRING = 3

/// Defines the item trigger spawn constant used by the miniquake2 game gameplay constants module.
const ITEM_TRIGGER_SPAWN = 0x00000001
/// Defines the item no touch constant used by the miniquake2 game gameplay constants module.
const ITEM_NO_TOUCH = 0x00000002
/// Defines the dropped item constant used by the miniquake2 game gameplay constants module.
const DROPPED_ITEM = 0x00010000
/// Defines the dropped player item constant used by the miniquake2 game gameplay constants module.
const DROPPED_PLAYER_ITEM = 0x00020000
/// Defines the item targets used constant used by the miniquake2 game gameplay constants module.
const ITEM_TARGETS_USED = 0x00040000
/// Defines the fl godmode constant used by the miniquake2 game gameplay constants module.
const FL_GODMODE = 0x00000010
/// Defines the fl notarget constant used by the miniquake2 game gameplay constants module.
const FL_NOTARGET = 0x00000020
/// Defines the fl no knockback constant used by the miniquake2 game gameplay constants module.
const FL_NO_KNOCKBACK = 0x00000800
/// Defines the fl power armor constant used by the miniquake2 game gameplay constants module.
const FL_POWER_ARMOR = 0x00001000
/// Defines the fl respawn constant used by the miniquake2 game gameplay constants module.
const FL_RESPAWN = 0x80000000

/// Defines the armor none constant used by the miniquake2 game gameplay constants module.
const ARMOR_NONE = 0
/// Defines the armor jacket constant used by the miniquake2 game gameplay constants module.
const ARMOR_JACKET = 1
/// Defines the armor combat constant used by the miniquake2 game gameplay constants module.
const ARMOR_COMBAT = 2
/// Defines the armor body constant used by the miniquake2 game gameplay constants module.
const ARMOR_BODY = 3
/// Defines the armor shard constant used by the miniquake2 game gameplay constants module.
const ARMOR_SHARD = 4

/// Defines the power armor none constant used by the miniquake2 game gameplay constants module.
const POWER_ARMOR_NONE = 0
/// Defines the power armor screen constant used by the miniquake2 game gameplay constants module.
const POWER_ARMOR_SCREEN = 1
/// Defines the power armor shield constant used by the miniquake2 game gameplay constants module.
const POWER_ARMOR_SHIELD = 2

/// Defines the health ignore max constant used by the miniquake2 game gameplay constants module.
const HEALTH_IGNORE_MAX = 1
/// Defines the health timed constant used by the miniquake2 game gameplay constants module.
const HEALTH_TIMED = 2

/// Defines the damage radius constant used by the miniquake2 game gameplay constants module.
const DAMAGE_RADIUS = 0x00000001
/// Defines the damage no armor constant used by the miniquake2 game gameplay constants module.
const DAMAGE_NO_ARMOR = 0x00000002
/// Defines the damage energy constant used by the miniquake2 game gameplay constants module.
const DAMAGE_ENERGY = 0x00000004
/// Defines the damage no knockback constant used by the miniquake2 game gameplay constants module.
const DAMAGE_NO_KNOCKBACK = 0x00000008
/// Defines the damage bullet constant used by the miniquake2 game gameplay constants module.
const DAMAGE_BULLET = 0x00000010
/// Defines the damage no protection constant used by the miniquake2 game gameplay constants module.
const DAMAGE_NO_PROTECTION = 0x00000020

/// Defines the mod unknown constant used by the miniquake2 game gameplay constants module.
const MOD_UNKNOWN = 0
/// Defines the mod blaster constant used by the miniquake2 game gameplay constants module.
const MOD_BLASTER = 1
/// Defines the mod shotgun constant used by the miniquake2 game gameplay constants module.
const MOD_SHOTGUN = 2
/// Defines the mod sshotgun constant used by the miniquake2 game gameplay constants module.
const MOD_SSHOTGUN = 3
/// Defines the mod machinegun constant used by the miniquake2 game gameplay constants module.
const MOD_MACHINEGUN = 4
/// Defines the mod chaingun constant used by the miniquake2 game gameplay constants module.
const MOD_CHAINGUN = 5
/// Defines the mod grenade constant used by the miniquake2 game gameplay constants module.
const MOD_GRENADE = 6
/// Defines the mod g splash constant used by the miniquake2 game gameplay constants module.
const MOD_G_SPLASH = 7
/// Defines the mod rocket constant used by the miniquake2 game gameplay constants module.
const MOD_ROCKET = 8
/// Defines the mod r splash constant used by the miniquake2 game gameplay constants module.
const MOD_R_SPLASH = 9
/// Defines the mod hyperblaster constant used by the miniquake2 game gameplay constants module.
const MOD_HYPERBLASTER = 10
/// Defines the mod target blaster constant used by the miniquake2 game gameplay constants module.
const MOD_TARGET_BLASTER = 33
/// Defines the mod telefrag constant used by the miniquake2 game gameplay constants module.
const MOD_TELEFRAG = 21
/// Defines the mod railgun constant used by the miniquake2 game gameplay constants module.
const MOD_RAILGUN = 11
/// Defines the mod bfg laser constant used by the miniquake2 game gameplay constants module.
const MOD_BFG_LASER = 12
/// Defines the mod bfg blast constant used by the miniquake2 game gameplay constants module.
const MOD_BFG_BLAST = 13
/// Defines the mod bfg effect constant used by the miniquake2 game gameplay constants module.
const MOD_BFG_EFFECT = 14
/// Defines the mod handgrenade constant used by the miniquake2 game gameplay constants module.
const MOD_HANDGRENADE = 15
/// Defines the mod hg splash constant used by the miniquake2 game gameplay constants module.
const MOD_HG_SPLASH = 16
/// Defines the mod friendly fire constant used by the miniquake2 game gameplay constants module.
const MOD_FRIENDLY_FIRE = 0x08000000

/// Defines the movetype none constant used by the miniquake2 game gameplay constants module.
const MOVETYPE_NONE = 0
/// Defines the movetype bounce constant used by the miniquake2 game gameplay constants module.
const MOVETYPE_BOUNCE = 10
/// Defines the movetype push constant used by the miniquake2 game gameplay constants module.
const MOVETYPE_PUSH = 7
/// Defines the movetype stop constant used by the miniquake2 game gameplay constants module.
const MOVETYPE_STOP = 8

/// Defines the default max bullets constant used by the miniquake2 game gameplay constants module.
const DEFAULT_MAX_BULLETS = 200
/// Defines the default max shells constant used by the miniquake2 game gameplay constants module.
const DEFAULT_MAX_SHELLS = 100
/// Defines the default max rockets constant used by the miniquake2 game gameplay constants module.
const DEFAULT_MAX_ROCKETS = 50
/// Defines the default max grenades constant used by the miniquake2 game gameplay constants module.
const DEFAULT_MAX_GRENADES = 50
/// Defines the default max cells constant used by the miniquake2 game gameplay constants module.
const DEFAULT_MAX_CELLS = 200
/// Defines the default max slugs constant used by the miniquake2 game gameplay constants module.
const DEFAULT_MAX_SLUGS = 50
