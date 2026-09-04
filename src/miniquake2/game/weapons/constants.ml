//! Provides miniquake2 game weapons constants facilities for this project.

/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* BaseQ2 g_weapon.c/p_weapon.c constants kept local to the ballistics layer. */
package miniquake2.game.weapons.constants

/// Defines the fl immune laser constant used by the miniquake2 game weapons constants module.
const FL_IMMUNE_LASER = 0x00000004

/// Defines the movetype none constant used by the miniquake2 game weapons constants module.
const MOVETYPE_NONE = 0
/// Defines the movetype flymissile constant used by the miniquake2 game weapons constants module.
const MOVETYPE_FLYMISSILE = 8
/// Defines the movetype bounce constant used by the miniquake2 game weapons constants module.
const MOVETYPE_BOUNCE = 9

/// Defines the solid not constant used by the miniquake2 game weapons constants module.
const SOLID_NOT = 0
/// Defines the solid bbox constant used by the miniquake2 game weapons constants module.
const SOLID_BBOX = 2

/// Defines the ef blaster constant used by the miniquake2 game weapons constants module.
const EF_BLASTER = 0x00000008
/// Defines the ef rocket constant used by the miniquake2 game weapons constants module.
const EF_ROCKET = 0x00000010
/// Defines the ef grenade constant used by the miniquake2 game weapons constants module.
const EF_GRENADE = 0x00000020
/// Defines the ef hyperblaster constant used by the miniquake2 game weapons constants module.
const EF_HYPERBLASTER = 0x00000040
/// Defines the ef bfg constant used by the miniquake2 game weapons constants module.
const EF_BFG = 0x00000080
/// Defines the ef anim allfast constant used by the miniquake2 game weapons constants module.
const EF_ANIM_ALLFAST = 0x00002000

/// Defines the mod held grenade constant used by the miniquake2 game weapons constants module.
const MOD_HELD_GRENADE = 24

/// Defines the impact gunshot constant used by the miniquake2 game weapons constants module.
const IMPACT_GUNSHOT = 0
/// Defines the impact shotgun constant used by the miniquake2 game weapons constants module.
const IMPACT_SHOTGUN = 4

/// Defines the splash unknown constant used by the miniquake2 game weapons constants module.
const SPLASH_UNKNOWN = 0
/// Defines the splash sparks constant used by the miniquake2 game weapons constants module.
const SPLASH_SPARKS = 1
/// Defines the splash blue water constant used by the miniquake2 game weapons constants module.
const SPLASH_BLUE_WATER = 2
/// Defines the splash brown water constant used by the miniquake2 game weapons constants module.
const SPLASH_BROWN_WATER = 3
/// Defines the splash slime constant used by the miniquake2 game weapons constants module.
const SPLASH_SLIME = 4
/// Defines the splash lava constant used by the miniquake2 game weapons constants module.
const SPLASH_LAVA = 5

/// Defines the hand ready constant used by the miniquake2 game weapons constants module.
const HAND_READY = 0
/// Defines the hand firing constant used by the miniquake2 game weapons constants module.
const HAND_FIRING = 3
/// Defines the button attack constant used by the miniquake2 game weapons constants module.
const BUTTON_ATTACK = 1
/// Defines the grenade timer constant used by the miniquake2 game weapons constants module.
const GRENADE_TIMER = 3.0
/// Defines the grenade min speed constant used by the miniquake2 game weapons constants module.
const GRENADE_MIN_SPEED = 400.0
/// Defines the grenade max speed constant used by the miniquake2 game weapons constants module.
const GRENADE_MAX_SPEED = 800.0
/// Defines the frame time constant used by the miniquake2 game weapons constants module.
const FRAME_TIME = 0.1

/// Protocol-34 player muzzle and temp-entity identifiers used by the internal
const MZ_BLASTER = 0
/// Defines the mz machinegun constant used by the miniquake2 game weapons constants module.
const MZ_MACHINEGUN = 1
/// Defines the mz shotgun constant used by the miniquake2 game weapons constants module.
const MZ_SHOTGUN = 2
/// Defines the mz chaingun1 constant used by the miniquake2 game weapons constants module.
const MZ_CHAINGUN1 = 3
/// Defines the mz chaingun2 constant used by the miniquake2 game weapons constants module.
const MZ_CHAINGUN2 = 4
/// Defines the mz chaingun3 constant used by the miniquake2 game weapons constants module.
const MZ_CHAINGUN3 = 5
/// Defines the mz railgun constant used by the miniquake2 game weapons constants module.
const MZ_RAILGUN = 6
/// Defines the mz rocket constant used by the miniquake2 game weapons constants module.
const MZ_ROCKET = 7
/// Defines the mz grenade constant used by the miniquake2 game weapons constants module.
const MZ_GRENADE = 8
/// Defines the mz bfg constant used by the miniquake2 game weapons constants module.
const MZ_BFG = 12
/// Defines the mz sshotgun constant used by the miniquake2 game weapons constants module.
const MZ_SSHOTGUN = 13
/// Defines the mz hyperblaster constant used by the miniquake2 game weapons constants module.
const MZ_HYPERBLASTER = 14
/// Defines the mz silenced constant used by the miniquake2 game weapons constants module.
const MZ_SILENCED = 128

/// Defines the te gunshot constant used by the miniquake2 game weapons constants module.
const TE_GUNSHOT = 0
/// Defines the te blood constant used by the miniquake2 game weapons constants module.
const TE_BLOOD = 1
/// Defines the te blaster constant used by the miniquake2 game weapons constants module.
const TE_BLASTER = 2
/// Defines the te railtrail constant used by the miniquake2 game weapons constants module.
const TE_RAILTRAIL = 3
/// Defines the te shotgun constant used by the miniquake2 game weapons constants module.
const TE_SHOTGUN = 4
/// Defines the te explosion1 constant used by the miniquake2 game weapons constants module.
const TE_EXPLOSION1 = 5
/// Defines the te explosion2 constant used by the miniquake2 game weapons constants module.
const TE_EXPLOSION2 = 6
/// Defines the te rocket explosion constant used by the miniquake2 game weapons constants module.
const TE_ROCKET_EXPLOSION = 7
/// Defines the te grenade explosion constant used by the miniquake2 game weapons constants module.
const TE_GRENADE_EXPLOSION = 8
/// Defines the te sparks constant used by the miniquake2 game weapons constants module.
const TE_SPARKS = 9
/// Defines the te splash constant used by the miniquake2 game weapons constants module.
const TE_SPLASH = 10
/// Defines the te bubbletrail constant used by the miniquake2 game weapons constants module.
const TE_BUBBLETRAIL = 11
/// Defines the te screen sparks constant used by the miniquake2 game weapons constants module.
const TE_SCREEN_SPARKS = 12
/// Defines the te shield sparks constant used by the miniquake2 game weapons constants module.
const TE_SHIELD_SPARKS = 13
/// Defines the te bullet sparks constant used by the miniquake2 game weapons constants module.
const TE_BULLET_SPARKS = 14
/// Defines the te laser sparks constant used by the miniquake2 game weapons constants module.
const TE_LASER_SPARKS = 15
/// Defines the te parasite attack constant used by the miniquake2 game weapons constants module.
const TE_PARASITE_ATTACK = 16
/// Defines the te medic cable attack constant used by the miniquake2 game weapons constants module.
const TE_MEDIC_CABLE_ATTACK = 19
/// Defines the te rocket explosion water constant used by the miniquake2 game weapons constants module.
const TE_ROCKET_EXPLOSION_WATER = 17
/// Defines the te grenade explosion water constant used by the miniquake2 game weapons constants module.
const TE_GRENADE_EXPLOSION_WATER = 18
/// Defines the te bfg explosion constant used by the miniquake2 game weapons constants module.
const TE_BFG_EXPLOSION = 20
/// Defines the te bfg bigexplosion constant used by the miniquake2 game weapons constants module.
const TE_BFG_BIGEXPLOSION = 21
/// Defines the te bfg laser constant used by the miniquake2 game weapons constants module.
const TE_BFG_LASER = 23
/// Defines the te teleport effect constant used by the miniquake2 game weapons constants module.
const TE_TELEPORT_EFFECT = 48
