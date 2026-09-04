//! Provides miniquake2 client effects constants facilities for this project.

/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Quake II 3.19 client effect constants from q_shared.h/client.h. */
package miniquake2.client.effects.constants

/// Defines the max dlights constant used by the miniquake2 client effects constants module.
const MAX_DLIGHTS = 32
/// Defines the max particles constant used by the miniquake2 client effects constants module.
const MAX_PARTICLES = 4096
/// Defines the max beams constant used by the miniquake2 client effects constants module.
const MAX_BEAMS = 32
/// Defines the max lasers constant used by the miniquake2 client effects constants module.
const MAX_LASERS = 32
/// Defines the max explosions constant used by the miniquake2 client effects constants module.
const MAX_EXPLOSIONS = 32
/// Defines the max sustains constant used by the miniquake2 client effects constants module.
const MAX_SUSTAINS = 32
/// Defines the max entity trails constant used by the miniquake2 client effects constants module.
const MAX_ENTITY_TRAILS = 1024
/// Defines the particle gravity constant used by the miniquake2 client effects constants module.
const PARTICLE_GRAVITY = 40.0
/// Defines the instant particle constant used by the miniquake2 client effects constants module.
const INSTANT_PARTICLE = -10000.0

/// Defines the ef rotate constant used by the miniquake2 client effects constants module.
const EF_ROTATE = 0x00000001
/// Defines the ef gib constant used by the miniquake2 client effects constants module.
const EF_GIB = 0x00000002
/// Defines the ef blaster constant used by the miniquake2 client effects constants module.
const EF_BLASTER = 0x00000008
/// Defines the ef rocket constant used by the miniquake2 client effects constants module.
const EF_ROCKET = 0x00000010
/// Defines the ef grenade constant used by the miniquake2 client effects constants module.
const EF_GRENADE = 0x00000020
/// Defines the ef hyperblaster constant used by the miniquake2 client effects constants module.
const EF_HYPERBLASTER = 0x00000040
/// Defines the ef bfg constant used by the miniquake2 client effects constants module.
const EF_BFG = 0x00000080
/// Defines the ef color shell constant used by the miniquake2 client effects constants module.
const EF_COLOR_SHELL = 0x00000100
/// Defines the ef powerscreen constant used by the miniquake2 client effects constants module.
const EF_POWERSCREEN = 0x00000200
/// Defines the ef anim01 constant used by the miniquake2 client effects constants module.
const EF_ANIM01 = 0x00000400
/// Defines the ef anim23 constant used by the miniquake2 client effects constants module.
const EF_ANIM23 = 0x00000800
/// Defines the ef anim all constant used by the miniquake2 client effects constants module.
const EF_ANIM_ALL = 0x00001000
/// Defines the ef anim allfast constant used by the miniquake2 client effects constants module.
const EF_ANIM_ALLFAST = 0x00002000
/// Defines the ef flies constant used by the miniquake2 client effects constants module.
const EF_FLIES = 0x00004000
/// Defines the ef quad constant used by the miniquake2 client effects constants module.
const EF_QUAD = 0x00008000
/// Defines the ef pent constant used by the miniquake2 client effects constants module.
const EF_PENT = 0x00010000
/// Defines the ef teleporter constant used by the miniquake2 client effects constants module.
const EF_TELEPORTER = 0x00020000
/// Defines the ef flag1 constant used by the miniquake2 client effects constants module.
const EF_FLAG1 = 0x00040000
/// Defines the ef flag2 constant used by the miniquake2 client effects constants module.
const EF_FLAG2 = 0x00080000
/// Defines the ef ionripper constant used by the miniquake2 client effects constants module.
const EF_IONRIPPER = 0x00100000
/// Defines the ef greengib constant used by the miniquake2 client effects constants module.
const EF_GREENGIB = 0x00200000
/// Defines the ef bluehyperblaster constant used by the miniquake2 client effects constants module.
const EF_BLUEHYPERBLASTER = 0x00400000
/// Defines the ef spinninglights constant used by the miniquake2 client effects constants module.
const EF_SPINNINGLIGHTS = 0x00800000
/// Defines the ef plasma constant used by the miniquake2 client effects constants module.
const EF_PLASMA = 0x01000000
/// Defines the ef trap constant used by the miniquake2 client effects constants module.
const EF_TRAP = 0x02000000
/// Defines the ef tracker constant used by the miniquake2 client effects constants module.
const EF_TRACKER = 0x04000000
/// Defines the ef double constant used by the miniquake2 client effects constants module.
const EF_DOUBLE = 0x08000000
/// Defines the ef spheretrans constant used by the miniquake2 client effects constants module.
const EF_SPHERETRANS = 0x10000000
/// Defines the ef tagtrail constant used by the miniquake2 client effects constants module.
const EF_TAGTRAIL = 0x20000000
/// Defines the ef half damage constant used by the miniquake2 client effects constants module.
const EF_HALF_DAMAGE = 0x40000000
/// Defines the ef trackertrail constant used by the miniquake2 client effects constants module.
const EF_TRACKERTRAIL = 0x80000000

/// Defines the mz blaster constant used by the miniquake2 client effects constants module.
const MZ_BLASTER = 0
/// Defines the mz machinegun constant used by the miniquake2 client effects constants module.
const MZ_MACHINEGUN = 1
/// Defines the mz shotgun constant used by the miniquake2 client effects constants module.
const MZ_SHOTGUN = 2
/// Defines the mz chaingun1 constant used by the miniquake2 client effects constants module.
const MZ_CHAINGUN1 = 3
/// Defines the mz chaingun2 constant used by the miniquake2 client effects constants module.
const MZ_CHAINGUN2 = 4
/// Defines the mz chaingun3 constant used by the miniquake2 client effects constants module.
const MZ_CHAINGUN3 = 5
/// Defines the mz railgun constant used by the miniquake2 client effects constants module.
const MZ_RAILGUN = 6
/// Defines the mz rocket constant used by the miniquake2 client effects constants module.
const MZ_ROCKET = 7
/// Defines the mz grenade constant used by the miniquake2 client effects constants module.
const MZ_GRENADE = 8
/// Defines the mz login constant used by the miniquake2 client effects constants module.
const MZ_LOGIN = 9
/// Defines the mz logout constant used by the miniquake2 client effects constants module.
const MZ_LOGOUT = 10
/// Defines the mz respawn constant used by the miniquake2 client effects constants module.
const MZ_RESPAWN = 11
/// Defines the mz bfg constant used by the miniquake2 client effects constants module.
const MZ_BFG = 12
/// Defines the mz sshotgun constant used by the miniquake2 client effects constants module.
const MZ_SSHOTGUN = 13
/// Defines the mz hyperblaster constant used by the miniquake2 client effects constants module.
const MZ_HYPERBLASTER = 14
/// Defines the mz itemrespawn constant used by the miniquake2 client effects constants module.
const MZ_ITEMRESPAWN = 15
/// Defines the mz ionripper constant used by the miniquake2 client effects constants module.
const MZ_IONRIPPER = 16
/// Defines the mz bluehyperblaster constant used by the miniquake2 client effects constants module.
const MZ_BLUEHYPERBLASTER = 17
/// Defines the mz phalanx constant used by the miniquake2 client effects constants module.
const MZ_PHALANX = 18
/// Defines the mz silenced constant used by the miniquake2 client effects constants module.
const MZ_SILENCED = 128
/// Defines the mz etf rifle constant used by the miniquake2 client effects constants module.
const MZ_ETF_RIFLE = 30
/// Defines the mz shotgun2 constant used by the miniquake2 client effects constants module.
const MZ_SHOTGUN2 = 32
/// Defines the mz heatbeam constant used by the miniquake2 client effects constants module.
const MZ_HEATBEAM = 33
/// Defines the mz blaster2 constant used by the miniquake2 client effects constants module.
const MZ_BLASTER2 = 34
/// Defines the mz tracker constant used by the miniquake2 client effects constants module.
const MZ_TRACKER = 35
/// Defines the mz nuke1 constant used by the miniquake2 client effects constants module.
const MZ_NUKE1 = 36
/// Defines the mz nuke2 constant used by the miniquake2 client effects constants module.
const MZ_NUKE2 = 37
/// Defines the mz nuke4 constant used by the miniquake2 client effects constants module.
const MZ_NUKE4 = 38
/// Defines the mz nuke8 constant used by the miniquake2 client effects constants module.
const MZ_NUKE8 = 39

/// Defines the te gunshot constant used by the miniquake2 client effects constants module.
const TE_GUNSHOT = 0
/// Defines the te blood constant used by the miniquake2 client effects constants module.
const TE_BLOOD = 1
/// Defines the te blaster constant used by the miniquake2 client effects constants module.
const TE_BLASTER = 2
/// Defines the te railtrail constant used by the miniquake2 client effects constants module.
const TE_RAILTRAIL = 3
/// Defines the te shotgun constant used by the miniquake2 client effects constants module.
const TE_SHOTGUN = 4
/// Defines the te explosion1 constant used by the miniquake2 client effects constants module.
const TE_EXPLOSION1 = 5
/// Defines the te explosion2 constant used by the miniquake2 client effects constants module.
const TE_EXPLOSION2 = 6
/// Defines the te rocket explosion constant used by the miniquake2 client effects constants module.
const TE_ROCKET_EXPLOSION = 7
/// Defines the te grenade explosion constant used by the miniquake2 client effects constants module.
const TE_GRENADE_EXPLOSION = 8
/// Defines the te sparks constant used by the miniquake2 client effects constants module.
const TE_SPARKS = 9
/// Defines the te splash constant used by the miniquake2 client effects constants module.
const TE_SPLASH = 10
/// Defines the te bubbletrail constant used by the miniquake2 client effects constants module.
const TE_BUBBLETRAIL = 11
/// Defines the te screen sparks constant used by the miniquake2 client effects constants module.
const TE_SCREEN_SPARKS = 12
/// Defines the te shield sparks constant used by the miniquake2 client effects constants module.
const TE_SHIELD_SPARKS = 13
/// Defines the te bullet sparks constant used by the miniquake2 client effects constants module.
const TE_BULLET_SPARKS = 14
/// Defines the te laser sparks constant used by the miniquake2 client effects constants module.
const TE_LASER_SPARKS = 15
/// Defines the te parasite attack constant used by the miniquake2 client effects constants module.
const TE_PARASITE_ATTACK = 16
/// Defines the te rocket explosion water constant used by the miniquake2 client effects constants module.
const TE_ROCKET_EXPLOSION_WATER = 17
/// Defines the te grenade explosion water constant used by the miniquake2 client effects constants module.
const TE_GRENADE_EXPLOSION_WATER = 18
/// Defines the te medic cable attack constant used by the miniquake2 client effects constants module.
const TE_MEDIC_CABLE_ATTACK = 19
/// Defines the te bfg explosion constant used by the miniquake2 client effects constants module.
const TE_BFG_EXPLOSION = 20
/// Defines the te bfg bigexplosion constant used by the miniquake2 client effects constants module.
const TE_BFG_BIGEXPLOSION = 21
/// Defines the te bosstport constant used by the miniquake2 client effects constants module.
const TE_BOSSTPORT = 22
/// Defines the te bfg laser constant used by the miniquake2 client effects constants module.
const TE_BFG_LASER = 23
/// Defines the te grapple cable constant used by the miniquake2 client effects constants module.
const TE_GRAPPLE_CABLE = 24
/// Defines the te welding sparks constant used by the miniquake2 client effects constants module.
const TE_WELDING_SPARKS = 25
/// Defines the te greenblood constant used by the miniquake2 client effects constants module.
const TE_GREENBLOOD = 26
/// Defines the te bluehyperblaster constant used by the miniquake2 client effects constants module.
const TE_BLUEHYPERBLASTER = 27
/// Defines the te plasma explosion constant used by the miniquake2 client effects constants module.
const TE_PLASMA_EXPLOSION = 28
/// Defines the te tunnel sparks constant used by the miniquake2 client effects constants module.
const TE_TUNNEL_SPARKS = 29
/// Defines the te blaster2 constant used by the miniquake2 client effects constants module.
const TE_BLASTER2 = 30
/// Defines the te railtrail2 constant used by the miniquake2 client effects constants module.
const TE_RAILTRAIL2 = 31
/// Defines the te flame constant used by the miniquake2 client effects constants module.
const TE_FLAME = 32
/// Defines the te lightning constant used by the miniquake2 client effects constants module.
const TE_LIGHTNING = 33
/// Defines the te debugtrail constant used by the miniquake2 client effects constants module.
const TE_DEBUGTRAIL = 34
/// Defines the te plain explosion constant used by the miniquake2 client effects constants module.
const TE_PLAIN_EXPLOSION = 35
/// Defines the te flashlight constant used by the miniquake2 client effects constants module.
const TE_FLASHLIGHT = 36
/// Defines the te forcewall constant used by the miniquake2 client effects constants module.
const TE_FORCEWALL = 37
/// Defines the te heatbeam constant used by the miniquake2 client effects constants module.
const TE_HEATBEAM = 38
/// Defines the te monster heatbeam constant used by the miniquake2 client effects constants module.
const TE_MONSTER_HEATBEAM = 39
/// Defines the te steam constant used by the miniquake2 client effects constants module.
const TE_STEAM = 40
/// Defines the te bubbletrail2 constant used by the miniquake2 client effects constants module.
const TE_BUBBLETRAIL2 = 41
/// Defines the te moreblood constant used by the miniquake2 client effects constants module.
const TE_MOREBLOOD = 42
/// Defines the te heatbeam sparks constant used by the miniquake2 client effects constants module.
const TE_HEATBEAM_SPARKS = 43
/// Defines the te heatbeam steam constant used by the miniquake2 client effects constants module.
const TE_HEATBEAM_STEAM = 44
/// Defines the te chainfist smoke constant used by the miniquake2 client effects constants module.
const TE_CHAINFIST_SMOKE = 45
/// Defines the te electric sparks constant used by the miniquake2 client effects constants module.
const TE_ELECTRIC_SPARKS = 46
/// Defines the te tracker explosion constant used by the miniquake2 client effects constants module.
const TE_TRACKER_EXPLOSION = 47
/// Defines the te teleport effect constant used by the miniquake2 client effects constants module.
const TE_TELEPORT_EFFECT = 48
/// Defines the te dball goal constant used by the miniquake2 client effects constants module.
const TE_DBALL_GOAL = 49
/// Defines the te widowbeamout constant used by the miniquake2 client effects constants module.
const TE_WIDOWBEAMOUT = 50
/// Defines the te nukeblast constant used by the miniquake2 client effects constants module.
const TE_NUKEBLAST = 51
/// Defines the te widowsplash constant used by the miniquake2 client effects constants module.
const TE_WIDOWSPLASH = 52
/// Defines the te explosion1 big constant used by the miniquake2 client effects constants module.
const TE_EXPLOSION1_BIG = 53
/// Defines the te explosion1 np constant used by the miniquake2 client effects constants module.
const TE_EXPLOSION1_NP = 54
/// Defines the te flechette constant used by the miniquake2 client effects constants module.
const TE_FLECHETTE = 55

/// Defines the ev item respawn constant used by the miniquake2 client effects constants module.
const EV_ITEM_RESPAWN = 1
/// Defines the ev footstep constant used by the miniquake2 client effects constants module.
const EV_FOOTSTEP = 2
/// Defines the ev fallshort constant used by the miniquake2 client effects constants module.
const EV_FALLSHORT = 3
/// Defines the ev fall constant used by the miniquake2 client effects constants module.
const EV_FALL = 4
/// Defines the ev fallfar constant used by the miniquake2 client effects constants module.
const EV_FALLFAR = 5
/// Defines the ev player teleport constant used by the miniquake2 client effects constants module.
const EV_PLAYER_TELEPORT = 6
/// Defines the ev other teleport constant used by the miniquake2 client effects constants module.
const EV_OTHER_TELEPORT = 7
