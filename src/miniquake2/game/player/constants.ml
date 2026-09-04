//! Provides miniquake2 game player constants facilities for this project.

/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* BaseQ2 player-side constants from g_local.h/p_client.c. */
package miniquake2.game.player.constants

/// Defines the movetype none constant used by the miniquake2 game player constants module.
const MOVETYPE_NONE = 0
/// Defines the movetype walk constant used by the miniquake2 game player constants module.
const MOVETYPE_WALK = 3
/// Defines the movetype noclip constant used by the miniquake2 game player constants module.
const MOVETYPE_NOCLIP = 8
/// Defines the movetype toss constant used by the miniquake2 game player constants module.
const MOVETYPE_TOSS = 6

/// Defines the damage no constant used by the miniquake2 game player constants module.
const DAMAGE_NO = 0
/// Defines the damage yes constant used by the miniquake2 game player constants module.
const DAMAGE_YES = 1
/// Defines the damage aim constant used by the miniquake2 game player constants module.
const DAMAGE_AIM = 2

/// Defines the dead no constant used by the miniquake2 game player constants module.
const DEAD_NO = 0
/// Defines the dead dying constant used by the miniquake2 game player constants module.
const DEAD_DYING = 1
/// Defines the dead dead constant used by the miniquake2 game player constants module.
const DEAD_DEAD = 2

/// Defines the body queue size constant used by the miniquake2 game player constants module.
const BODY_QUEUE_SIZE = 8
/// Defines the frame time constant used by the miniquake2 game player constants module.
const FRAME_TIME = 0.1
/// Defines the damage time constant used by the miniquake2 game player constants module.
const DAMAGE_TIME = 0.5
/// Defines the fall time constant used by the miniquake2 game player constants module.
const FALL_TIME = 0.3
/// Defines the fl inwater constant used by the miniquake2 game player constants module.
const FL_INWATER = 0x00000008

/// Defines the anim basic constant used by the miniquake2 game player constants module.
const ANIM_BASIC = 0
/// Defines the anim wave constant used by the miniquake2 game player constants module.
const ANIM_WAVE = 1
/// Defines the anim jump constant used by the miniquake2 game player constants module.
const ANIM_JUMP = 2
/// Defines the anim pain constant used by the miniquake2 game player constants module.
const ANIM_PAIN = 3
/// Defines the anim attack constant used by the miniquake2 game player constants module.
const ANIM_ATTACK = 4
/// Defines the anim death constant used by the miniquake2 game player constants module.
const ANIM_DEATH = 5
/// Defines the anim reverse constant used by the miniquake2 game player constants module.
const ANIM_REVERSE = 6

/// Defines the frame stand first constant used by the miniquake2 game player constants module.
const FRAME_STAND_FIRST = 0
/// Defines the frame stand last constant used by the miniquake2 game player constants module.
const FRAME_STAND_LAST = 39
/// Defines the frame run first constant used by the miniquake2 game player constants module.
const FRAME_RUN_FIRST = 40
/// Defines the frame run last constant used by the miniquake2 game player constants module.
const FRAME_RUN_LAST = 45
/// Defines the frame attack first constant used by the miniquake2 game player constants module.
const FRAME_ATTACK_FIRST = 46
/// Defines the frame attack last constant used by the miniquake2 game player constants module.
const FRAME_ATTACK_LAST = 53
/// Defines the frame pain1 first constant used by the miniquake2 game player constants module.
const FRAME_PAIN1_FIRST = 54
/// Defines the frame pain1 last constant used by the miniquake2 game player constants module.
const FRAME_PAIN1_LAST = 57
/// Defines the frame pain2 first constant used by the miniquake2 game player constants module.
const FRAME_PAIN2_FIRST = 58
/// Defines the frame pain2 last constant used by the miniquake2 game player constants module.
const FRAME_PAIN2_LAST = 61
/// Defines the frame pain3 first constant used by the miniquake2 game player constants module.
const FRAME_PAIN3_FIRST = 62
/// Defines the frame pain3 last constant used by the miniquake2 game player constants module.
const FRAME_PAIN3_LAST = 65
/// Defines the frame jump first constant used by the miniquake2 game player constants module.
const FRAME_JUMP_FIRST = 66
/// Defines the frame jump last constant used by the miniquake2 game player constants module.
const FRAME_JUMP_LAST = 67
/// Defines the frame jump land first constant used by the miniquake2 game player constants module.
const FRAME_JUMP_LAND_FIRST = 68
/// Defines the frame jump land last constant used by the miniquake2 game player constants module.
const FRAME_JUMP_LAND_LAST = 71
/// Defines the frame flip first constant used by the miniquake2 game player constants module.
const FRAME_FLIP_FIRST = 72
/// Defines the frame flip last constant used by the miniquake2 game player constants module.
const FRAME_FLIP_LAST = 83
/// Defines the frame salute first constant used by the miniquake2 game player constants module.
const FRAME_SALUTE_FIRST = 84
/// Defines the frame salute last constant used by the miniquake2 game player constants module.
const FRAME_SALUTE_LAST = 94
/// Defines the frame taunt first constant used by the miniquake2 game player constants module.
const FRAME_TAUNT_FIRST = 95
/// Defines the frame taunt last constant used by the miniquake2 game player constants module.
const FRAME_TAUNT_LAST = 111
/// Defines the frame wave first constant used by the miniquake2 game player constants module.
const FRAME_WAVE_FIRST = 112
/// Defines the frame wave last constant used by the miniquake2 game player constants module.
const FRAME_WAVE_LAST = 122
/// Defines the frame point first constant used by the miniquake2 game player constants module.
const FRAME_POINT_FIRST = 123
/// Defines the frame point last constant used by the miniquake2 game player constants module.
const FRAME_POINT_LAST = 134
/// Defines the frame crouch stand first constant used by the miniquake2 game player constants module.
const FRAME_CROUCH_STAND_FIRST = 135
/// Defines the frame crouch stand last constant used by the miniquake2 game player constants module.
const FRAME_CROUCH_STAND_LAST = 153
/// Defines the frame crouch walk first constant used by the miniquake2 game player constants module.
const FRAME_CROUCH_WALK_FIRST = 154
/// Defines the frame crouch walk last constant used by the miniquake2 game player constants module.
const FRAME_CROUCH_WALK_LAST = 159
/// Defines the frame crouch attack first constant used by the miniquake2 game player constants module.
const FRAME_CROUCH_ATTACK_FIRST = 160
/// Defines the frame crouch attack last constant used by the miniquake2 game player constants module.
const FRAME_CROUCH_ATTACK_LAST = 168
/// Defines the frame crouch pain first constant used by the miniquake2 game player constants module.
const FRAME_CROUCH_PAIN_FIRST = 169
/// Defines the frame crouch pain last constant used by the miniquake2 game player constants module.
const FRAME_CROUCH_PAIN_LAST = 172
/// Defines the frame crouch death first constant used by the miniquake2 game player constants module.
const FRAME_CROUCH_DEATH_FIRST = 173
/// Defines the frame crouch death last constant used by the miniquake2 game player constants module.
const FRAME_CROUCH_DEATH_LAST = 177
/// Defines the frame death1 first constant used by the miniquake2 game player constants module.
const FRAME_DEATH1_FIRST = 178
/// Defines the frame death1 last constant used by the miniquake2 game player constants module.
const FRAME_DEATH1_LAST = 183
/// Defines the frame death2 first constant used by the miniquake2 game player constants module.
const FRAME_DEATH2_FIRST = 184
/// Defines the frame death2 last constant used by the miniquake2 game player constants module.
const FRAME_DEATH2_LAST = 189
/// Defines the frame death3 first constant used by the miniquake2 game player constants module.
const FRAME_DEATH3_FIRST = 190
/// Defines the frame death3 last constant used by the miniquake2 game player constants module.
const FRAME_DEATH3_LAST = 197

/// Defines the mod water constant used by the miniquake2 game player constants module.
const MOD_WATER = 17
/// Defines the mod slime constant used by the miniquake2 game player constants module.
const MOD_SLIME = 18
/// Defines the mod lava constant used by the miniquake2 game player constants module.
const MOD_LAVA = 19
/// Defines the mod crush constant used by the miniquake2 game player constants module.
const MOD_CRUSH = 20
/// Defines the mod telefrag constant used by the miniquake2 game player constants module.
const MOD_TELEFRAG = 21
/// Defines the mod falling constant used by the miniquake2 game player constants module.
const MOD_FALLING = 22
/// Defines the mod suicide constant used by the miniquake2 game player constants module.
const MOD_SUICIDE = 23
/// Defines the mod held grenade constant used by the miniquake2 game player constants module.
const MOD_HELD_GRENADE = 24
/// Defines the mod explosive constant used by the miniquake2 game player constants module.
const MOD_EXPLOSIVE = 25
/// Defines the mod barrel constant used by the miniquake2 game player constants module.
const MOD_BARREL = 26
/// Defines the mod bomb constant used by the miniquake2 game player constants module.
const MOD_BOMB = 27
/// Defines the mod exit constant used by the miniquake2 game player constants module.
const MOD_EXIT = 28
/// Defines the mod splash constant used by the miniquake2 game player constants module.
const MOD_SPLASH = 29
/// Defines the mod target laser constant used by the miniquake2 game player constants module.
const MOD_TARGET_LASER = 30
/// Defines the mod trigger hurt constant used by the miniquake2 game player constants module.
const MOD_TRIGGER_HURT = 31
/// Defines the mod hit constant used by the miniquake2 game player constants module.
const MOD_HIT = 32
/// Defines the mod target blaster constant used by the miniquake2 game player constants module.
const MOD_TARGET_BLASTER = 33

/// Defines the player model index constant used by the miniquake2 game player constants module.
const PLAYER_MODEL_INDEX = 255
/// Defines the default gravity constant used by the miniquake2 game player constants module.
const DEFAULT_GRAVITY = 800
/// Defines the default fov constant used by the miniquake2 game player constants module.
const DEFAULT_FOV = 90
/// Defines the max fov constant used by the miniquake2 game player constants module.
const MAX_FOV = 160
