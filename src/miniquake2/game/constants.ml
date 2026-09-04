//! Provides miniquake2 game constants facilities for this project.

/*
Copyright (C) 1997-2001 Id Software, Inc.
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later

Constants at the Quake II 3.19 engine/game API boundary. Values come from
game/game.h and game/q_shared.h. Protocol and collision constants live in
miniquake2.qcommon.constants and are intentionally not duplicated here.
*/
package miniquake2.game.constants

/// Defines the game api version constant used by the miniquake2 game constants module.
const GAME_API_VERSION = 3

/// Defines the svf noclient constant used by the miniquake2 game constants module.
const SVF_NOCLIENT = 0x00000001
/// Defines the svf deadmonster constant used by the miniquake2 game constants module.
const SVF_DEADMONSTER = 0x00000002
/// Defines the svf monster constant used by the miniquake2 game constants module.
const SVF_MONSTER = 0x00000004

/// Defines the solid not constant used by the miniquake2 game constants module.
const SOLID_NOT = 0
/// Defines the solid trigger constant used by the miniquake2 game constants module.
const SOLID_TRIGGER = 1
/// Defines the solid bbox constant used by the miniquake2 game constants module.
const SOLID_BBOX = 2
/// Defines the solid bsp constant used by the miniquake2 game constants module.
const SOLID_BSP = 3

/// Defines the max ent clusters constant used by the miniquake2 game constants module.
const MAX_ENT_CLUSTERS = 16
/// Defines the maxtouch constant used by the miniquake2 game constants module.
const MAXTOUCH = 32
/// Defines the max stats constant used by the miniquake2 game constants module.
const MAX_STATS = 32

/// One MiniLang array element is the portable edict stride. It deliberately
const MINILANG_EDICT_STRIDE = 1

/// Defines the multicast all constant used by the miniquake2 game constants module.
const MULTICAST_ALL = 0
/// Defines the multicast phs constant used by the miniquake2 game constants module.
const MULTICAST_PHS = 1
/// Defines the multicast pvs constant used by the miniquake2 game constants module.
const MULTICAST_PVS = 2
/// Defines the multicast all r constant used by the miniquake2 game constants module.
const MULTICAST_ALL_R = 3
/// Defines the multicast phs r constant used by the miniquake2 game constants module.
const MULTICAST_PHS_R = 4
/// Defines the multicast pvs r constant used by the miniquake2 game constants module.
const MULTICAST_PVS_R = 5

/// Defines the pm normal constant used by the miniquake2 game constants module.
const PM_NORMAL = 0
/// Defines the pm spectator constant used by the miniquake2 game constants module.
const PM_SPECTATOR = 1
/// Defines the pm dead constant used by the miniquake2 game constants module.
const PM_DEAD = 2
/// Defines the pm gib constant used by the miniquake2 game constants module.
const PM_GIB = 3
/// Defines the pm freeze constant used by the miniquake2 game constants module.
const PM_FREEZE = 4

/// Defines the pmf ducked constant used by the miniquake2 game constants module.
const PMF_DUCKED = 1
/// Defines the pmf jump held constant used by the miniquake2 game constants module.
const PMF_JUMP_HELD = 2
/// Defines the pmf on ground constant used by the miniquake2 game constants module.
const PMF_ON_GROUND = 4
/// Defines the pmf time waterjump constant used by the miniquake2 game constants module.
const PMF_TIME_WATERJUMP = 8
/// Defines the pmf time land constant used by the miniquake2 game constants module.
const PMF_TIME_LAND = 16
/// Defines the pmf time teleport constant used by the miniquake2 game constants module.
const PMF_TIME_TELEPORT = 32
/// Defines the pmf no prediction constant used by the miniquake2 game constants module.
const PMF_NO_PREDICTION = 64

/// Defines the button attack constant used by the miniquake2 game constants module.
const BUTTON_ATTACK = 1
/// Defines the button use constant used by the miniquake2 game constants module.
const BUTTON_USE = 2
/// Defines the button any constant used by the miniquake2 game constants module.
const BUTTON_ANY = 128

/// Player muzzleflash effects from q_shared.h. The game emits these on
const MZ_LOGIN = 9
/// Defines the mz logout constant used by the miniquake2 game constants module.
const MZ_LOGOUT = 10

/// entity_state_t effects used across the game/renderer boundary.
const EF_ROTATE = 0x00000001
/// Defines the ef gib constant used by the miniquake2 game constants module.
const EF_GIB = 0x00000002
/// Defines the ef blaster constant used by the miniquake2 game constants module.
const EF_BLASTER = 0x00000008
/// Defines the ef rocket constant used by the miniquake2 game constants module.
const EF_ROCKET = 0x00000010
/// Defines the ef grenade constant used by the miniquake2 game constants module.
const EF_GRENADE = 0x00000020
/// Defines the ef hyperblaster constant used by the miniquake2 game constants module.
const EF_HYPERBLASTER = 0x00000040
/// Defines the ef bfg constant used by the miniquake2 game constants module.
const EF_BFG = 0x00000080
/// Defines the ef color shell constant used by the miniquake2 game constants module.
const EF_COLOR_SHELL = 0x00000100
/// Defines the ef powerscreen constant used by the miniquake2 game constants module.
const EF_POWERSCREEN = 0x00000200
/// Defines the ef anim01 constant used by the miniquake2 game constants module.
const EF_ANIM01 = 0x00000400
/// Defines the ef anim23 constant used by the miniquake2 game constants module.
const EF_ANIM23 = 0x00000800
/// Defines the ef anim all constant used by the miniquake2 game constants module.
const EF_ANIM_ALL = 0x00001000
/// Defines the ef anim allfast constant used by the miniquake2 game constants module.
const EF_ANIM_ALLFAST = 0x00002000
/// Defines the ef flies constant used by the miniquake2 game constants module.
const EF_FLIES = 0x00004000
/// Defines the ef quad constant used by the miniquake2 game constants module.
const EF_QUAD = 0x00008000
/// Defines the ef pent constant used by the miniquake2 game constants module.
const EF_PENT = 0x00010000
/// Defines the ef teleporter constant used by the miniquake2 game constants module.
const EF_TELEPORTER = 0x00020000
/// Defines the ef flag1 constant used by the miniquake2 game constants module.
const EF_FLAG1 = 0x00040000
/// Defines the ef flag2 constant used by the miniquake2 game constants module.
const EF_FLAG2 = 0x00080000
/// Defines the ef ionripper constant used by the miniquake2 game constants module.
const EF_IONRIPPER = 0x00100000
/// Defines the ef greengib constant used by the miniquake2 game constants module.
const EF_GREENGIB = 0x00200000
/// Defines the ef bluehyperblaster constant used by the miniquake2 game constants module.
const EF_BLUEHYPERBLASTER = 0x00400000
/// Defines the ef spinninglights constant used by the miniquake2 game constants module.
const EF_SPINNINGLIGHTS = 0x00800000
/// Defines the ef plasma constant used by the miniquake2 game constants module.
const EF_PLASMA = 0x01000000
/// Defines the ef trap constant used by the miniquake2 game constants module.
const EF_TRAP = 0x02000000
/// Defines the ef tracker constant used by the miniquake2 game constants module.
const EF_TRACKER = 0x04000000
/// Defines the ef double constant used by the miniquake2 game constants module.
const EF_DOUBLE = 0x08000000
/// Defines the ef spheretrans constant used by the miniquake2 game constants module.
const EF_SPHERETRANS = 0x10000000
/// Defines the ef tagtrail constant used by the miniquake2 game constants module.
const EF_TAGTRAIL = 0x20000000
/// Defines the ef half damage constant used by the miniquake2 game constants module.
const EF_HALF_DAMAGE = 0x40000000
/// Defines the ef trackertrail constant used by the miniquake2 game constants module.
const EF_TRACKERTRAIL = 0x80000000

/// Defines the rf minlight constant used by the miniquake2 game constants module.
const RF_MINLIGHT = 1
/// Defines the rf viewermodel constant used by the miniquake2 game constants module.
const RF_VIEWERMODEL = 2
/// Defines the rf weaponmodel constant used by the miniquake2 game constants module.
const RF_WEAPONMODEL = 4
/// Defines the rf fullbright constant used by the miniquake2 game constants module.
const RF_FULLBRIGHT = 8
/// Defines the rf depthhack constant used by the miniquake2 game constants module.
const RF_DEPTHHACK = 16
/// Defines the rf translucent constant used by the miniquake2 game constants module.
const RF_TRANSLUCENT = 32
/// Defines the rf framelerp constant used by the miniquake2 game constants module.
const RF_FRAMELERP = 64
/// Defines the rf beam constant used by the miniquake2 game constants module.
const RF_BEAM = 128
/// Defines the rf customskin constant used by the miniquake2 game constants module.
const RF_CUSTOMSKIN = 256
/// Defines the rf glow constant used by the miniquake2 game constants module.
const RF_GLOW = 512
/// Defines the rf shell red constant used by the miniquake2 game constants module.
const RF_SHELL_RED = 1024
/// Defines the rf shell green constant used by the miniquake2 game constants module.
const RF_SHELL_GREEN = 2048
/// Defines the rf shell blue constant used by the miniquake2 game constants module.
const RF_SHELL_BLUE = 4096
/// Defines the rf ir visible constant used by the miniquake2 game constants module.
const RF_IR_VISIBLE = 0x00008000
/// Defines the rf shell double constant used by the miniquake2 game constants module.
const RF_SHELL_DOUBLE = 0x00010000
/// Defines the rf shell half dam constant used by the miniquake2 game constants module.
const RF_SHELL_HALF_DAM = 0x00020000
/// Defines the rf use disguise constant used by the miniquake2 game constants module.
const RF_USE_DISGUISE = 0x00040000

/// Defines the rdf underwater constant used by the miniquake2 game constants module.
const RDF_UNDERWATER = 1
/// Defines the rdf noworldmodel constant used by the miniquake2 game constants module.
const RDF_NOWORLDMODEL = 2
/// Defines the rdf irgoggles constant used by the miniquake2 game constants module.
const RDF_IRGOGGLES = 4
/// Defines the rdf uvgoggles constant used by the miniquake2 game constants module.
const RDF_UVGOGGLES = 8

/// gi.sound / gi.positioned_sound channel and attenuation contract.
const CHAN_AUTO = 0
/// Defines the chan weapon constant used by the miniquake2 game constants module.
const CHAN_WEAPON = 1
/// Defines the chan voice constant used by the miniquake2 game constants module.
const CHAN_VOICE = 2
/// Defines the chan item constant used by the miniquake2 game constants module.
const CHAN_ITEM = 3
/// Defines the chan body constant used by the miniquake2 game constants module.
const CHAN_BODY = 4
/// Defines the chan no phs add constant used by the miniquake2 game constants module.
const CHAN_NO_PHS_ADD = 8
/// Defines the chan reliable constant used by the miniquake2 game constants module.
const CHAN_RELIABLE = 16

/// Defines the attn none constant used by the miniquake2 game constants module.
const ATTN_NONE = 0
/// Defines the attn norm constant used by the miniquake2 game constants module.
const ATTN_NORM = 1
/// Defines the attn idle constant used by the miniquake2 game constants module.
const ATTN_IDLE = 2
/// Defines the attn static constant used by the miniquake2 game constants module.
const ATTN_STATIC = 3

/// player_state_t.stats indexes.
const STAT_HEALTH_ICON = 0
/// Defines the stat health constant used by the miniquake2 game constants module.
const STAT_HEALTH = 1
/// Defines the stat ammo icon constant used by the miniquake2 game constants module.
const STAT_AMMO_ICON = 2
/// Defines the stat ammo constant used by the miniquake2 game constants module.
const STAT_AMMO = 3
/// Defines the stat armor icon constant used by the miniquake2 game constants module.
const STAT_ARMOR_ICON = 4
/// Defines the stat armor constant used by the miniquake2 game constants module.
const STAT_ARMOR = 5
/// Defines the stat selected icon constant used by the miniquake2 game constants module.
const STAT_SELECTED_ICON = 6
/// Defines the stat pickup icon constant used by the miniquake2 game constants module.
const STAT_PICKUP_ICON = 7
/// Defines the stat pickup string constant used by the miniquake2 game constants module.
const STAT_PICKUP_STRING = 8
/// Defines the stat timer icon constant used by the miniquake2 game constants module.
const STAT_TIMER_ICON = 9
/// Defines the stat timer constant used by the miniquake2 game constants module.
const STAT_TIMER = 10
/// Defines the stat helpicon constant used by the miniquake2 game constants module.
const STAT_HELPICON = 11
/// Defines the stat selected item constant used by the miniquake2 game constants module.
const STAT_SELECTED_ITEM = 12
/// Defines the stat layouts constant used by the miniquake2 game constants module.
const STAT_LAYOUTS = 13
/// Defines the stat frags constant used by the miniquake2 game constants module.
const STAT_FRAGS = 14
/// Defines the stat flashes constant used by the miniquake2 game constants module.
const STAT_FLASHES = 15
/// Defines the stat chase constant used by the miniquake2 game constants module.
const STAT_CHASE = 16
/// Defines the stat spectator constant used by the miniquake2 game constants module.
const STAT_SPECTATOR = 17

/// Defines the df no health constant used by the miniquake2 game constants module.
const DF_NO_HEALTH = 0x00000001
/// Defines the df no items constant used by the miniquake2 game constants module.
const DF_NO_ITEMS = 0x00000002
/// Defines the df weapons stay constant used by the miniquake2 game constants module.
const DF_WEAPONS_STAY = 0x00000004
/// Defines the df no falling constant used by the miniquake2 game constants module.
const DF_NO_FALLING = 0x00000008
/// Defines the df instant items constant used by the miniquake2 game constants module.
const DF_INSTANT_ITEMS = 0x00000010
/// Defines the df same level constant used by the miniquake2 game constants module.
const DF_SAME_LEVEL = 0x00000020
/// Defines the df skinteams constant used by the miniquake2 game constants module.
const DF_SKINTEAMS = 0x00000040
/// Defines the df modelteams constant used by the miniquake2 game constants module.
const DF_MODELTEAMS = 0x00000080
/// Defines the df no friendly fire constant used by the miniquake2 game constants module.
const DF_NO_FRIENDLY_FIRE = 0x00000100
/// Defines the df spawn farthest constant used by the miniquake2 game constants module.
const DF_SPAWN_FARTHEST = 0x00000200
/// Defines the df force respawn constant used by the miniquake2 game constants module.
const DF_FORCE_RESPAWN = 0x00000400
/// Defines the df no armor constant used by the miniquake2 game constants module.
const DF_NO_ARMOR = 0x00000800
/// Defines the df allow exit constant used by the miniquake2 game constants module.
const DF_ALLOW_EXIT = 0x00001000
/// Defines the df infinite ammo constant used by the miniquake2 game constants module.
const DF_INFINITE_AMMO = 0x00002000
/// Defines the df quad drop constant used by the miniquake2 game constants module.
const DF_QUAD_DROP = 0x00004000
/// Defines the df fixed fov constant used by the miniquake2 game constants module.
const DF_FIXED_FOV = 0x00008000
/// Defines the df quadfire drop constant used by the miniquake2 game constants module.
const DF_QUADFIRE_DROP = 0x00010000
/// Defines the df no mines constant used by the miniquake2 game constants module.
const DF_NO_MINES = 0x00020000
/// Defines the df no stack double constant used by the miniquake2 game constants module.
const DF_NO_STACK_DOUBLE = 0x00040000
/// Defines the df no nukes constant used by the miniquake2 game constants module.
const DF_NO_NUKES = 0x00080000
/// Defines the df no spheres constant used by the miniquake2 game constants module.
const DF_NO_SPHERES = 0x00100000

/// Defines the ev none constant used by the miniquake2 game constants module.
const EV_NONE = 0
/// Defines the ev item respawn constant used by the miniquake2 game constants module.
const EV_ITEM_RESPAWN = 1
/// Defines the ev footstep constant used by the miniquake2 game constants module.
const EV_FOOTSTEP = 2
/// Defines the ev fallshort constant used by the miniquake2 game constants module.
const EV_FALLSHORT = 3
/// Defines the ev fall constant used by the miniquake2 game constants module.
const EV_FALL = 4
/// Defines the ev fallfar constant used by the miniquake2 game constants module.
const EV_FALLFAR = 5
/// Defines the ev player teleport constant used by the miniquake2 game constants module.
const EV_PLAYER_TELEPORT = 6
/// Defines the ev other teleport constant used by the miniquake2 game constants module.
const EV_OTHER_TELEPORT = 7
