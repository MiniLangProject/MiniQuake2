/* BaseQ2 world, trigger, target and mover constants. */
package miniquake2.game.world.constants

const FRAME_TIME = 0.1

const STATE_TOP = 0
const STATE_BOTTOM = 1
const STATE_UP = 2
const STATE_DOWN = 3

const MOVETYPE_NONE = 0
const MOVETYPE_STEP = 4
const MOVETYPE_TOSS = 6
const MOVETYPE_PUSH = 7
const MOVETYPE_STOP = 8

const SOLID_NOT = 0
const SOLID_TRIGGER = 1
const SOLID_BBOX = 2
const SOLID_BSP = 3

const SVF_NOCLIENT = 0x00000001
const SVF_DEADMONSTER = 0x00000002
const SVF_MONSTER = 0x00000004

const FL_TEAMSLAVE = 0x00000400
const FL_FLY = 0x00000001
const FL_SWIM = 0x00000002

const DAMAGE_NO = 0
const DAMAGE_YES = 1

const EF_ANIM01 = 0x00000400
const EF_ANIM23 = 0x00000800
const EF_ANIM_ALL = 0x00001000
const EF_ANIM_ALLFAST = 0x00002000
const EF_ROCKET = 0x00000010

const RF_TRANSLUCENT = 32

const DOOR_START_OPEN = 1
const DOOR_REVERSE = 2
const DOOR_CRUSHER = 4
const DOOR_NOMONSTER = 8
const DOOR_TOGGLE = 32
const DOOR_X_AXIS = 64
const DOOR_Y_AXIS = 128

const PLAT_LOW_TRIGGER = 1
const TRAIN_START_ON = 1
const TRAIN_TOGGLE = 2
const TRAIN_BLOCK_STOPS = 4

const TRIGGER_MONSTER = 1
const TRIGGER_NOT_PLAYER = 2
const TRIGGER_TRIGGERED = 4

const ACTOR_JUMP = 1
const ACTOR_SHOOT = 2
const ACTOR_ATTACK = 4
const ACTOR_HOLD = 16
const ACTOR_BRUTAL = 32

const CLOCK_TIMER_UP = 1
const CLOCK_TIMER_DOWN = 2
const CLOCK_START_OFF = 4
const CLOCK_MULTI_USE = 8

const MOD_CRUSH = "crush"
const MOD_EXPLOSIVE = "explosive"
const MOD_BARREL = "barrel"
const MOD_BOMB = "bomb"
const SFL_CROSS_TRIGGER_MASK = 0x000000ff
