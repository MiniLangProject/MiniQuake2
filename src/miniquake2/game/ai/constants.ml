//! Provides miniquake2 game ai constants facilities for this project.

/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* BaseQ2 AI constants from g_local.h. */
package miniquake2.game.ai.constants

/// Defines the frametime constant used by the miniquake2 game ai constants module.
const FRAMETIME = 0.1
/// Defines the melee distance constant used by the miniquake2 game ai constants module.
const MELEE_DISTANCE = 80.0

/// Defines the dead no constant used by the miniquake2 game ai constants module.
const DEAD_NO = 0
/// Defines the dead dying constant used by the miniquake2 game ai constants module.
const DEAD_DYING = 1
/// Defines the dead dead constant used by the miniquake2 game ai constants module.
const DEAD_DEAD = 2
/// Defines the dead respawnable constant used by the miniquake2 game ai constants module.
const DEAD_RESPAWNABLE = 3

/// Defines the range melee constant used by the miniquake2 game ai constants module.
const RANGE_MELEE = 0
/// Defines the range near constant used by the miniquake2 game ai constants module.
const RANGE_NEAR = 1
/// Defines the range mid constant used by the miniquake2 game ai constants module.
const RANGE_MID = 2
/// Defines the range far constant used by the miniquake2 game ai constants module.
const RANGE_FAR = 3

/// Defines the ai stand ground constant used by the miniquake2 game ai constants module.
const AI_STAND_GROUND = 0x00000001
/// Defines the ai temp stand ground constant used by the miniquake2 game ai constants module.
const AI_TEMP_STAND_GROUND = 0x00000002
/// Defines the ai sound target constant used by the miniquake2 game ai constants module.
const AI_SOUND_TARGET = 0x00000004
/// Defines the ai lost sight constant used by the miniquake2 game ai constants module.
const AI_LOST_SIGHT = 0x00000008
/// Defines the ai pursuit last seen constant used by the miniquake2 game ai constants module.
const AI_PURSUIT_LAST_SEEN = 0x00000010
/// Defines the ai pursue next constant used by the miniquake2 game ai constants module.
const AI_PURSUE_NEXT = 0x00000020
/// Defines the ai pursue temp constant used by the miniquake2 game ai constants module.
const AI_PURSUE_TEMP = 0x00000040
/// Defines the ai hold frame constant used by the miniquake2 game ai constants module.
const AI_HOLD_FRAME = 0x00000080
/// Defines the ai good guy constant used by the miniquake2 game ai constants module.
const AI_GOOD_GUY = 0x00000100
/// Defines the ai brutal constant used by the miniquake2 game ai constants module.
const AI_BRUTAL = 0x00000200
/// Defines the ai nostep constant used by the miniquake2 game ai constants module.
const AI_NOSTEP = 0x00000400
/// Defines the ai ducked constant used by the miniquake2 game ai constants module.
const AI_DUCKED = 0x00000800
/// Defines the ai combat point constant used by the miniquake2 game ai constants module.
const AI_COMBAT_POINT = 0x00001000
/// Defines the ai medic constant used by the miniquake2 game ai constants module.
const AI_MEDIC = 0x00002000
/// Defines the ai resurrecting constant used by the miniquake2 game ai constants module.
const AI_RESURRECTING = 0x00004000

/// Defines the as straight constant used by the miniquake2 game ai constants module.
const AS_STRAIGHT = 1
/// Defines the as sliding constant used by the miniquake2 game ai constants module.
const AS_SLIDING = 2
/// Defines the as melee constant used by the miniquake2 game ai constants module.
const AS_MELEE = 3
/// Defines the as missile constant used by the miniquake2 game ai constants module.
const AS_MISSILE = 4

/// Defines the fl fly constant used by the miniquake2 game ai constants module.
const FL_FLY = 0x00000001
/// Defines the fl swim constant used by the miniquake2 game ai constants module.
const FL_SWIM = 0x00000002
/// Defines the fl immune laser constant used by the miniquake2 game ai constants module.
const FL_IMMUNE_LASER = 0x00000004
/// Defines the fl inwater constant used by the miniquake2 game ai constants module.
const FL_INWATER = 0x00000008
/// Defines the fl godmode constant used by the miniquake2 game ai constants module.
const FL_GODMODE = 0x00000010
/// Defines the fl notarget constant used by the miniquake2 game ai constants module.
const FL_NOTARGET = 0x00000020
/// Defines the fl immune slime constant used by the miniquake2 game ai constants module.
const FL_IMMUNE_SLIME = 0x00000040
/// Defines the fl immune lava constant used by the miniquake2 game ai constants module.
const FL_IMMUNE_LAVA = 0x00000080
/// Defines the fl partialground constant used by the miniquake2 game ai constants module.
const FL_PARTIALGROUND = 0x00000100
/// Defines the fl no knockback constant used by the miniquake2 game ai constants module.
const FL_NO_KNOCKBACK = 0x00000800

/// Defines the power armor none constant used by the miniquake2 game ai constants module.
const POWER_ARMOR_NONE = 0
/// Defines the power armor screen constant used by the miniquake2 game ai constants module.
const POWER_ARMOR_SCREEN = 1
/// Defines the power armor shield constant used by the miniquake2 game ai constants module.
const POWER_ARMOR_SHIELD = 2

/// Defines the damage no armor constant used by the miniquake2 game ai constants module.
const DAMAGE_NO_ARMOR = 0x00000002
/// Defines the mod water constant used by the miniquake2 game ai constants module.
const MOD_WATER = 17
/// Defines the mod slime constant used by the miniquake2 game ai constants module.
const MOD_SLIME = 18
/// Defines the mod lava constant used by the miniquake2 game ai constants module.
const MOD_LAVA = 19

/// Defines the movetype none constant used by the miniquake2 game ai constants module.
const MOVETYPE_NONE = 0
/// Defines the movetype step constant used by the miniquake2 game ai constants module.
const MOVETYPE_STEP = 4
/// Defines the movetype toss constant used by the miniquake2 game ai constants module.
const MOVETYPE_TOSS = 6

/// Defines the spawnflag ambush constant used by the miniquake2 game ai constants module.
const SPAWNFLAG_AMBUSH = 1
/// Defines the spawnflag trigger spawn constant used by the miniquake2 game ai constants module.
const SPAWNFLAG_TRIGGER_SPAWN = 2
/// Defines the spawnflag sight constant used by the miniquake2 game ai constants module.
const SPAWNFLAG_SIGHT = 4

/// Defines the insane crawl constant used by the miniquake2 game ai constants module.
const INSANE_CRAWL = 4
/// Defines the insane crucified constant used by the miniquake2 game ai constants module.
const INSANE_CRUCIFIED = 8
/// Defines the insane stand ground constant used by the miniquake2 game ai constants module.
const INSANE_STAND_GROUND = 16
/// Defines the insane always stand constant used by the miniquake2 game ai constants module.
const INSANE_ALWAYS_STAND = 32

/// Defines the te bosstport constant used by the miniquake2 game ai constants module.
const TE_BOSSTPORT = 22
