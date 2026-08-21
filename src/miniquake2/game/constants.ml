/*
Copyright (C) 1997-2001 Id Software, Inc.
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later

Constants at the Quake II 3.19 engine/game API boundary. Values come from
game/game.h and game/q_shared.h. Protocol and collision constants live in
miniquake2.qcommon.constants and are intentionally not duplicated here.
*/
package miniquake2.game.constants

const GAME_API_VERSION = 3

const SVF_NOCLIENT = 0x00000001
const SVF_DEADMONSTER = 0x00000002
const SVF_MONSTER = 0x00000004

const SOLID_NOT = 0
const SOLID_TRIGGER = 1
const SOLID_BBOX = 2
const SOLID_BSP = 3

const MAX_ENT_CLUSTERS = 16
const MAXTOUCH = 32
const MAX_STATS = 32

// One MiniLang array element is the portable edict stride. It deliberately
// does not claim to be sizeof(edict_t), which is a native DLL ABI concept.
const MINILANG_EDICT_STRIDE = 1

const MULTICAST_ALL = 0
const MULTICAST_PHS = 1
const MULTICAST_PVS = 2
const MULTICAST_ALL_R = 3
const MULTICAST_PHS_R = 4
const MULTICAST_PVS_R = 5

const PM_NORMAL = 0
const PM_SPECTATOR = 1
const PM_DEAD = 2
const PM_GIB = 3
const PM_FREEZE = 4

const PMF_DUCKED = 1
const PMF_JUMP_HELD = 2
const PMF_ON_GROUND = 4
const PMF_TIME_WATERJUMP = 8
const PMF_TIME_LAND = 16
const PMF_TIME_TELEPORT = 32
const PMF_NO_PREDICTION = 64

const BUTTON_ATTACK = 1
const BUTTON_USE = 2
const BUTTON_ANY = 128

// entity_state_t effects used across the game/renderer boundary.
const EF_ROTATE = 0x00000001
const EF_GIB = 0x00000002
const EF_BLASTER = 0x00000008
const EF_ROCKET = 0x00000010
const EF_GRENADE = 0x00000020
const EF_HYPERBLASTER = 0x00000040
const EF_BFG = 0x00000080
const EF_COLOR_SHELL = 0x00000100
const EF_POWERSCREEN = 0x00000200
const EF_ANIM01 = 0x00000400
const EF_ANIM23 = 0x00000800
const EF_ANIM_ALL = 0x00001000
const EF_ANIM_ALLFAST = 0x00002000
const EF_FLIES = 0x00004000
const EF_QUAD = 0x00008000
const EF_PENT = 0x00010000
const EF_TELEPORTER = 0x00020000
const EF_FLAG1 = 0x00040000
const EF_FLAG2 = 0x00080000
const EF_IONRIPPER = 0x00100000
const EF_GREENGIB = 0x00200000
const EF_BLUEHYPERBLASTER = 0x00400000
const EF_SPINNINGLIGHTS = 0x00800000
const EF_PLASMA = 0x01000000
const EF_TRAP = 0x02000000
const EF_TRACKER = 0x04000000
const EF_DOUBLE = 0x08000000
const EF_SPHERETRANS = 0x10000000
const EF_TAGTRAIL = 0x20000000
const EF_HALF_DAMAGE = 0x40000000
const EF_TRACKERTRAIL = 0x80000000

const RF_MINLIGHT = 1
const RF_VIEWERMODEL = 2
const RF_WEAPONMODEL = 4
const RF_FULLBRIGHT = 8
const RF_DEPTHHACK = 16
const RF_TRANSLUCENT = 32
const RF_FRAMELERP = 64
const RF_BEAM = 128
const RF_CUSTOMSKIN = 256
const RF_GLOW = 512
const RF_SHELL_RED = 1024
const RF_SHELL_GREEN = 2048
const RF_SHELL_BLUE = 4096
const RF_IR_VISIBLE = 0x00008000
const RF_SHELL_DOUBLE = 0x00010000
const RF_SHELL_HALF_DAM = 0x00020000
const RF_USE_DISGUISE = 0x00040000

const RDF_UNDERWATER = 1
const RDF_NOWORLDMODEL = 2
const RDF_IRGOGGLES = 4
const RDF_UVGOGGLES = 8

// gi.sound / gi.positioned_sound channel and attenuation contract.
const CHAN_AUTO = 0
const CHAN_WEAPON = 1
const CHAN_VOICE = 2
const CHAN_ITEM = 3
const CHAN_BODY = 4
const CHAN_NO_PHS_ADD = 8
const CHAN_RELIABLE = 16

const ATTN_NONE = 0
const ATTN_NORM = 1
const ATTN_IDLE = 2
const ATTN_STATIC = 3

// player_state_t.stats indexes.
const STAT_HEALTH_ICON = 0
const STAT_HEALTH = 1
const STAT_AMMO_ICON = 2
const STAT_AMMO = 3
const STAT_ARMOR_ICON = 4
const STAT_ARMOR = 5
const STAT_SELECTED_ICON = 6
const STAT_PICKUP_ICON = 7
const STAT_PICKUP_STRING = 8
const STAT_TIMER_ICON = 9
const STAT_TIMER = 10
const STAT_HELPICON = 11
const STAT_SELECTED_ITEM = 12
const STAT_LAYOUTS = 13
const STAT_FRAGS = 14
const STAT_FLASHES = 15
const STAT_CHASE = 16
const STAT_SPECTATOR = 17

const DF_NO_HEALTH = 0x00000001
const DF_NO_ITEMS = 0x00000002
const DF_WEAPONS_STAY = 0x00000004
const DF_NO_FALLING = 0x00000008
const DF_INSTANT_ITEMS = 0x00000010
const DF_SAME_LEVEL = 0x00000020
const DF_SKINTEAMS = 0x00000040
const DF_MODELTEAMS = 0x00000080
const DF_NO_FRIENDLY_FIRE = 0x00000100
const DF_SPAWN_FARTHEST = 0x00000200
const DF_FORCE_RESPAWN = 0x00000400
const DF_NO_ARMOR = 0x00000800
const DF_ALLOW_EXIT = 0x00001000
const DF_INFINITE_AMMO = 0x00002000
const DF_QUAD_DROP = 0x00004000
const DF_FIXED_FOV = 0x00008000
const DF_QUADFIRE_DROP = 0x00010000
const DF_NO_MINES = 0x00020000
const DF_NO_STACK_DOUBLE = 0x00040000
const DF_NO_NUKES = 0x00080000
const DF_NO_SPHERES = 0x00100000

const EV_NONE = 0
const EV_ITEM_RESPAWN = 1
const EV_FOOTSTEP = 2
const EV_FALLSHORT = 3
const EV_FALL = 4
const EV_FALLFAR = 5
const EV_PLAYER_TELEPORT = 6
const EV_OTHER_TELEPORT = 7
