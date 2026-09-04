//! Provides miniquake2 game world constants facilities for this project.

/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* BaseQ2 world, trigger, target and mover constants. */
package miniquake2.game.world.constants

/// Defines the frame time constant used by the miniquake2 game world constants module.
const FRAME_TIME = 0.1

/// Defines the state top constant used by the miniquake2 game world constants module.
const STATE_TOP = 0
/// Defines the state bottom constant used by the miniquake2 game world constants module.
const STATE_BOTTOM = 1
/// Defines the state up constant used by the miniquake2 game world constants module.
const STATE_UP = 2
/// Defines the state down constant used by the miniquake2 game world constants module.
const STATE_DOWN = 3

/// Defines the movetype none constant used by the miniquake2 game world constants module.
const MOVETYPE_NONE = 0
/// Defines the movetype step constant used by the miniquake2 game world constants module.
const MOVETYPE_STEP = 4
/// Defines the movetype toss constant used by the miniquake2 game world constants module.
const MOVETYPE_TOSS = 6
/// Defines the movetype push constant used by the miniquake2 game world constants module.
const MOVETYPE_PUSH = 7
/// Defines the movetype stop constant used by the miniquake2 game world constants module.
const MOVETYPE_STOP = 8
/// Defines the movetype bounce constant used by the miniquake2 game world constants module.
const MOVETYPE_BOUNCE = 10

/// Defines the solid not constant used by the miniquake2 game world constants module.
const SOLID_NOT = 0
/// Defines the solid trigger constant used by the miniquake2 game world constants module.
const SOLID_TRIGGER = 1
/// Defines the solid bbox constant used by the miniquake2 game world constants module.
const SOLID_BBOX = 2
/// Defines the solid bsp constant used by the miniquake2 game world constants module.
const SOLID_BSP = 3

/// Defines the svf noclient constant used by the miniquake2 game world constants module.
const SVF_NOCLIENT = 0x00000001
/// Defines the svf deadmonster constant used by the miniquake2 game world constants module.
const SVF_DEADMONSTER = 0x00000002
/// Defines the svf monster constant used by the miniquake2 game world constants module.
const SVF_MONSTER = 0x00000004

/// Defines the fl teamslave constant used by the miniquake2 game world constants module.
const FL_TEAMSLAVE = 0x00000400
/// Defines the fl fly constant used by the miniquake2 game world constants module.
const FL_FLY = 0x00000001
/// Defines the fl swim constant used by the miniquake2 game world constants module.
const FL_SWIM = 0x00000002

/// Defines the damage no constant used by the miniquake2 game world constants module.
const DAMAGE_NO = 0
/// Defines the damage yes constant used by the miniquake2 game world constants module.
const DAMAGE_YES = 1
/// Defines the damage aim constant used by the miniquake2 game world constants module.
const DAMAGE_AIM = 2

/// Defines the ef anim01 constant used by the miniquake2 game world constants module.
const EF_ANIM01 = 0x00000400
/// Defines the ef anim23 constant used by the miniquake2 game world constants module.
const EF_ANIM23 = 0x00000800
/// Defines the ef anim all constant used by the miniquake2 game world constants module.
const EF_ANIM_ALL = 0x00001000
/// Defines the ef anim allfast constant used by the miniquake2 game world constants module.
const EF_ANIM_ALLFAST = 0x00002000
/// Defines the ef rocket constant used by the miniquake2 game world constants module.
const EF_ROCKET = 0x00000010

/// Defines the rf translucent constant used by the miniquake2 game world constants module.
const RF_TRANSLUCENT = 32
/// Defines the rf beam constant used by the miniquake2 game world constants module.
const RF_BEAM = 128

/// Defines the fl immune laser constant used by the miniquake2 game world constants module.
const FL_IMMUNE_LASER = 0x00000004

/// Defines the door start open constant used by the miniquake2 game world constants module.
const DOOR_START_OPEN = 1
/// Defines the door reverse constant used by the miniquake2 game world constants module.
const DOOR_REVERSE = 2
/// Defines the door crusher constant used by the miniquake2 game world constants module.
const DOOR_CRUSHER = 4
/// Defines the door nomonster constant used by the miniquake2 game world constants module.
const DOOR_NOMONSTER = 8
/// Defines the door toggle constant used by the miniquake2 game world constants module.
const DOOR_TOGGLE = 32
/// Defines the door x axis constant used by the miniquake2 game world constants module.
const DOOR_X_AXIS = 64
/// Defines the door y axis constant used by the miniquake2 game world constants module.
const DOOR_Y_AXIS = 128

/// Defines the plat low trigger constant used by the miniquake2 game world constants module.
const PLAT_LOW_TRIGGER = 1
/// Defines the train start on constant used by the miniquake2 game world constants module.
const TRAIN_START_ON = 1
/// Defines the train toggle constant used by the miniquake2 game world constants module.
const TRAIN_TOGGLE = 2
/// Defines the train block stops constant used by the miniquake2 game world constants module.
const TRAIN_BLOCK_STOPS = 4

/// Defines the trigger monster constant used by the miniquake2 game world constants module.
const TRIGGER_MONSTER = 1
/// Defines the trigger not player constant used by the miniquake2 game world constants module.
const TRIGGER_NOT_PLAYER = 2
/// Defines the trigger triggered constant used by the miniquake2 game world constants module.
const TRIGGER_TRIGGERED = 4
/// Defines the push once constant used by the miniquake2 game world constants module.
const PUSH_ONCE = 1

/// Defines the actor jump constant used by the miniquake2 game world constants module.
const ACTOR_JUMP = 1
/// Defines the actor shoot constant used by the miniquake2 game world constants module.
const ACTOR_SHOOT = 2
/// Defines the actor attack constant used by the miniquake2 game world constants module.
const ACTOR_ATTACK = 4
/// Defines the actor hold constant used by the miniquake2 game world constants module.
const ACTOR_HOLD = 16
/// Defines the actor brutal constant used by the miniquake2 game world constants module.
const ACTOR_BRUTAL = 32

/// Defines the clock timer up constant used by the miniquake2 game world constants module.
const CLOCK_TIMER_UP = 1
/// Defines the clock timer down constant used by the miniquake2 game world constants module.
const CLOCK_TIMER_DOWN = 2
/// Defines the clock start off constant used by the miniquake2 game world constants module.
const CLOCK_START_OFF = 4
/// Defines the clock multi use constant used by the miniquake2 game world constants module.
const CLOCK_MULTI_USE = 8

/// Defines the mod crush constant used by the miniquake2 game world constants module.
const MOD_CRUSH = "crush"
/// Defines the mod explosive constant used by the miniquake2 game world constants module.
const MOD_EXPLOSIVE = "explosive"
/// Defines the mod barrel constant used by the miniquake2 game world constants module.
const MOD_BARREL = "barrel"
/// Defines the mod bomb constant used by the miniquake2 game world constants module.
const MOD_BOMB = "bomb"
/// Defines the mod target laser constant used by the miniquake2 game world constants module.
const MOD_TARGET_LASER = "target-laser"
/// Defines the mod trigger hurt constant used by the miniquake2 game world constants module.
const MOD_TRIGGER_HURT = "trigger-hurt"
/// Defines the mod trigger hurt no protection constant used by the miniquake2 game world constants module.
const MOD_TRIGGER_HURT_NO_PROTECTION = "trigger-hurt-no-protection"
/// Defines the sfl cross trigger mask constant used by the miniquake2 game world constants module.
const SFL_CROSS_TRIGGER_MASK = 0x000000ff
