/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* BaseQ2 g_weapon.c/p_weapon.c constants kept local to the ballistics layer. */
package miniquake2.game.weapons.constants

const FL_IMMUNE_LASER = 0x00000004

const MOVETYPE_NONE = 0
const MOVETYPE_FLYMISSILE = 8
const MOVETYPE_BOUNCE = 9

const SOLID_NOT = 0
const SOLID_BBOX = 2

const EF_BLASTER = 0x00000008
const EF_ROCKET = 0x00000010
const EF_GRENADE = 0x00000020
const EF_HYPERBLASTER = 0x00000040
const EF_BFG = 0x00000080
const EF_ANIM_ALLFAST = 0x00002000

const MOD_HELD_GRENADE = 24

const IMPACT_GUNSHOT = 0
const IMPACT_SHOTGUN = 4

const SPLASH_UNKNOWN = 0
const SPLASH_SPARKS = 1
const SPLASH_BLUE_WATER = 2
const SPLASH_BROWN_WATER = 3
const SPLASH_SLIME = 4
const SPLASH_LAVA = 5

const HAND_READY = 0
const HAND_FIRING = 3
const BUTTON_ATTACK = 1
const GRENADE_TIMER = 3.0
const GRENADE_MIN_SPEED = 400.0
const GRENADE_MAX_SPEED = 800.0
const FRAME_TIME = 0.1

// Protocol-34 player muzzle and temp-entity identifiers used by the internal
// GameImport handoff. They intentionally mirror q_shared.h without importing
// client implementation packages into gameplay.
const MZ_BLASTER = 0
const MZ_MACHINEGUN = 1
const MZ_SHOTGUN = 2
const MZ_CHAINGUN1 = 3
const MZ_CHAINGUN2 = 4
const MZ_CHAINGUN3 = 5
const MZ_RAILGUN = 6
const MZ_ROCKET = 7
const MZ_GRENADE = 8
const MZ_BFG = 12
const MZ_SSHOTGUN = 13
const MZ_HYPERBLASTER = 14
const MZ_SILENCED = 128

const TE_GUNSHOT = 0
const TE_BLOOD = 1
const TE_BLASTER = 2
const TE_RAILTRAIL = 3
const TE_SHOTGUN = 4
const TE_EXPLOSION1 = 5
const TE_EXPLOSION2 = 6
const TE_ROCKET_EXPLOSION = 7
const TE_GRENADE_EXPLOSION = 8
const TE_SPARKS = 9
const TE_SPLASH = 10
const TE_BUBBLETRAIL = 11
const TE_BULLET_SPARKS = 14
const TE_LASER_SPARKS = 15
const TE_PARASITE_ATTACK = 16
const TE_MEDIC_CABLE_ATTACK = 19
const TE_ROCKET_EXPLOSION_WATER = 17
const TE_GRENADE_EXPLOSION_WATER = 18
const TE_BFG_EXPLOSION = 20
const TE_BFG_BIGEXPLOSION = 21
const TE_BFG_LASER = 23
