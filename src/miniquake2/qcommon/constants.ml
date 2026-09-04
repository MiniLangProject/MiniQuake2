//! Provides miniquake2 qcommon constants facilities for this project.

/*
Copyright (C) 1997-2001 Id Software, Inc.
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later

Quake II 3.19 constants shared by the MiniLang client and server.
*/
package miniquake2.qcommon.constants

/// Defines the version constant used by the miniquake2 qcommon constants module.
const VERSION = 3.19
/// Defines the basedirname constant used by the miniquake2 qcommon constants module.
const BASEDIRNAME = "baseq2"

/// Defines the pitch constant used by the miniquake2 qcommon constants module.
const PITCH = 0
/// Defines the yaw constant used by the miniquake2 qcommon constants module.
const YAW = 1
/// Defines the roll constant used by the miniquake2 qcommon constants module.
const ROLL = 2

/// Defines the max string chars constant used by the miniquake2 qcommon constants module.
const MAX_STRING_CHARS = 1024
/// Defines the max string tokens constant used by the miniquake2 qcommon constants module.
const MAX_STRING_TOKENS = 80
/// Defines the max token chars constant used by the miniquake2 qcommon constants module.
const MAX_TOKEN_CHARS = 128
/// Defines the max qpath constant used by the miniquake2 qcommon constants module.
const MAX_QPATH = 64
/// Defines the max ospath constant used by the miniquake2 qcommon constants module.
const MAX_OSPATH = 128
/// Defines the max info key constant used by the miniquake2 qcommon constants module.
const MAX_INFO_KEY = 64
/// Defines the max info value constant used by the miniquake2 qcommon constants module.
const MAX_INFO_VALUE = 64
/// Defines the max info string constant used by the miniquake2 qcommon constants module.
const MAX_INFO_STRING = 512

/// Defines the max clients constant used by the miniquake2 qcommon constants module.
const MAX_CLIENTS = 256
/// Defines the max edicts constant used by the miniquake2 qcommon constants module.
const MAX_EDICTS = 1024
/// Defines the max lightstyles constant used by the miniquake2 qcommon constants module.
const MAX_LIGHTSTYLES = 256
/// Defines the max models constant used by the miniquake2 qcommon constants module.
const MAX_MODELS = 256
/// Defines the max sounds constant used by the miniquake2 qcommon constants module.
const MAX_SOUNDS = 256
/// Defines the max images constant used by the miniquake2 qcommon constants module.
const MAX_IMAGES = 256
/// Defines the max items constant used by the miniquake2 qcommon constants module.
const MAX_ITEMS = 256
/// Defines the max general constant used by the miniquake2 qcommon constants module.
const MAX_GENERAL = 512

/// Defines the protocol version constant used by the miniquake2 qcommon constants module.
const PROTOCOL_VERSION = 34
/// Defines the port master constant used by the miniquake2 qcommon constants module.
const PORT_MASTER = 27900
/// Defines the port client constant used by the miniquake2 qcommon constants module.
const PORT_CLIENT = 27901
/// Defines the port server constant used by the miniquake2 qcommon constants module.
const PORT_SERVER = 27910
/// Defines the port any constant used by the miniquake2 qcommon constants module.
const PORT_ANY = -1
/// Defines the update backup constant used by the miniquake2 qcommon constants module.
const UPDATE_BACKUP = 16
/// Defines the update mask constant used by the miniquake2 qcommon constants module.
const UPDATE_MASK = 15
/// Defines the max msglen constant used by the miniquake2 qcommon constants module.
const MAX_MSGLEN = 1400
/// Defines the packet header constant used by the miniquake2 qcommon constants module.
const PACKET_HEADER = 10

/// server-to-client protocol opcodes (svc_ops_e)
const SVC_BAD = 0
/// Defines the svc muzzleflash constant used by the miniquake2 qcommon constants module.
const SVC_MUZZLEFLASH = 1
/// Defines the svc muzzleflash2 constant used by the miniquake2 qcommon constants module.
const SVC_MUZZLEFLASH2 = 2
/// Defines the svc temp entity constant used by the miniquake2 qcommon constants module.
const SVC_TEMP_ENTITY = 3
/// Defines the svc layout constant used by the miniquake2 qcommon constants module.
const SVC_LAYOUT = 4
/// Defines the svc inventory constant used by the miniquake2 qcommon constants module.
const SVC_INVENTORY = 5
/// Defines the svc nop constant used by the miniquake2 qcommon constants module.
const SVC_NOP = 6
/// Defines the svc disconnect constant used by the miniquake2 qcommon constants module.
const SVC_DISCONNECT = 7
/// Defines the svc reconnect constant used by the miniquake2 qcommon constants module.
const SVC_RECONNECT = 8
/// Defines the svc sound constant used by the miniquake2 qcommon constants module.
const SVC_SOUND = 9
/// Defines the svc print constant used by the miniquake2 qcommon constants module.
const SVC_PRINT = 10
/// Defines the svc stufftext constant used by the miniquake2 qcommon constants module.
const SVC_STUFFTEXT = 11
/// Defines the svc serverdata constant used by the miniquake2 qcommon constants module.
const SVC_SERVERDATA = 12
/// Defines the svc configstring constant used by the miniquake2 qcommon constants module.
const SVC_CONFIGSTRING = 13
/// Defines the svc spawnbaseline constant used by the miniquake2 qcommon constants module.
const SVC_SPAWNBASELINE = 14
/// Defines the svc centerprint constant used by the miniquake2 qcommon constants module.
const SVC_CENTERPRINT = 15
/// Defines the svc download constant used by the miniquake2 qcommon constants module.
const SVC_DOWNLOAD = 16
/// Defines the svc playerinfo constant used by the miniquake2 qcommon constants module.
const SVC_PLAYERINFO = 17
/// Defines the svc packetentities constant used by the miniquake2 qcommon constants module.
const SVC_PACKETENTITIES = 18
/// Defines the svc deltapacketentities constant used by the miniquake2 qcommon constants module.
const SVC_DELTAPACKETENTITIES = 19
/// Defines the svc frame constant used by the miniquake2 qcommon constants module.
const SVC_FRAME = 20

/// client-to-server protocol opcodes (clc_ops_e)
const CLC_BAD = 0
/// Defines the clc nop constant used by the miniquake2 qcommon constants module.
const CLC_NOP = 1
/// Defines the clc move constant used by the miniquake2 qcommon constants module.
const CLC_MOVE = 2
/// Defines the clc userinfo constant used by the miniquake2 qcommon constants module.
const CLC_USERINFO = 3
/// Defines the clc stringcmd constant used by the miniquake2 qcommon constants module.
const CLC_STRINGCMD = 4

/// player_state_t delta flags
const PS_M_TYPE = 1 << 0
/// Defines the ps m origin constant used by the miniquake2 qcommon constants module.
const PS_M_ORIGIN = 1 << 1
/// Defines the ps m velocity constant used by the miniquake2 qcommon constants module.
const PS_M_VELOCITY = 1 << 2
/// Defines the ps m time constant used by the miniquake2 qcommon constants module.
const PS_M_TIME = 1 << 3
/// Defines the ps m flags constant used by the miniquake2 qcommon constants module.
const PS_M_FLAGS = 1 << 4
/// Defines the ps m gravity constant used by the miniquake2 qcommon constants module.
const PS_M_GRAVITY = 1 << 5
/// Defines the ps m delta angles constant used by the miniquake2 qcommon constants module.
const PS_M_DELTA_ANGLES = 1 << 6
/// Defines the ps viewoffset constant used by the miniquake2 qcommon constants module.
const PS_VIEWOFFSET = 1 << 7
/// Defines the ps viewangles constant used by the miniquake2 qcommon constants module.
const PS_VIEWANGLES = 1 << 8
/// Defines the ps kickangles constant used by the miniquake2 qcommon constants module.
const PS_KICKANGLES = 1 << 9
/// Defines the ps blend constant used by the miniquake2 qcommon constants module.
const PS_BLEND = 1 << 10
/// Defines the ps fov constant used by the miniquake2 qcommon constants module.
const PS_FOV = 1 << 11
/// Defines the ps weaponindex constant used by the miniquake2 qcommon constants module.
const PS_WEAPONINDEX = 1 << 12
/// Defines the ps weaponframe constant used by the miniquake2 qcommon constants module.
const PS_WEAPONFRAME = 1 << 13
/// Defines the ps rdflags constant used by the miniquake2 qcommon constants module.
const PS_RDFLAGS = 1 << 14

/// usercmd_t delta flags
const CM_ANGLE1 = 1 << 0
/// Defines the cm angle2 constant used by the miniquake2 qcommon constants module.
const CM_ANGLE2 = 1 << 1
/// Defines the cm angle3 constant used by the miniquake2 qcommon constants module.
const CM_ANGLE3 = 1 << 2
/// Defines the cm forward constant used by the miniquake2 qcommon constants module.
const CM_FORWARD = 1 << 3
/// Defines the cm side constant used by the miniquake2 qcommon constants module.
const CM_SIDE = 1 << 4
/// Defines the cm up constant used by the miniquake2 qcommon constants module.
const CM_UP = 1 << 5
/// Defines the cm buttons constant used by the miniquake2 qcommon constants module.
const CM_BUTTONS = 1 << 6
/// Defines the cm impulse constant used by the miniquake2 qcommon constants module.
const CM_IMPULSE = 1 << 7

/// sound packet flags
const SND_VOLUME = 1 << 0
/// Defines the snd attenuation constant used by the miniquake2 qcommon constants module.
const SND_ATTENUATION = 1 << 1
/// Defines the snd pos constant used by the miniquake2 qcommon constants module.
const SND_POS = 1 << 2
/// Defines the snd ent constant used by the miniquake2 qcommon constants module.
const SND_ENT = 1 << 3
/// Defines the snd offset constant used by the miniquake2 qcommon constants module.
const SND_OFFSET = 1 << 4
/// Defines the default sound packet volume constant used by the miniquake2 qcommon constants module.
const DEFAULT_SOUND_PACKET_VOLUME = 1.0
/// Defines the default sound packet attenuation constant used by the miniquake2 qcommon constants module.
const DEFAULT_SOUND_PACKET_ATTENUATION = 1.0

/// entity_state_t delta flags. The missing bit 13 is intentional in protocol 34.
const U_ORIGIN1 = 1 << 0
/// Defines the u origin2 constant used by the miniquake2 qcommon constants module.
const U_ORIGIN2 = 1 << 1
/// Defines the u angle2 constant used by the miniquake2 qcommon constants module.
const U_ANGLE2 = 1 << 2
/// Defines the u angle3 constant used by the miniquake2 qcommon constants module.
const U_ANGLE3 = 1 << 3
/// Defines the u frame8 constant used by the miniquake2 qcommon constants module.
const U_FRAME8 = 1 << 4
/// Defines the u event constant used by the miniquake2 qcommon constants module.
const U_EVENT = 1 << 5
/// Defines the u remove constant used by the miniquake2 qcommon constants module.
const U_REMOVE = 1 << 6
/// Defines the u morebits1 constant used by the miniquake2 qcommon constants module.
const U_MOREBITS1 = 1 << 7
/// Defines the u number16 constant used by the miniquake2 qcommon constants module.
const U_NUMBER16 = 1 << 8
/// Defines the u origin3 constant used by the miniquake2 qcommon constants module.
const U_ORIGIN3 = 1 << 9
/// Defines the u angle1 constant used by the miniquake2 qcommon constants module.
const U_ANGLE1 = 1 << 10
/// Defines the u model constant used by the miniquake2 qcommon constants module.
const U_MODEL = 1 << 11
/// Defines the u renderfx8 constant used by the miniquake2 qcommon constants module.
const U_RENDERFX8 = 1 << 12
/// Defines the u effects8 constant used by the miniquake2 qcommon constants module.
const U_EFFECTS8 = 1 << 14
/// Defines the u morebits2 constant used by the miniquake2 qcommon constants module.
const U_MOREBITS2 = 1 << 15
/// Defines the u skin8 constant used by the miniquake2 qcommon constants module.
const U_SKIN8 = 1 << 16
/// Defines the u frame16 constant used by the miniquake2 qcommon constants module.
const U_FRAME16 = 1 << 17
/// Defines the u renderfx16 constant used by the miniquake2 qcommon constants module.
const U_RENDERFX16 = 1 << 18
/// Defines the u effects16 constant used by the miniquake2 qcommon constants module.
const U_EFFECTS16 = 1 << 19
/// Defines the u model2 constant used by the miniquake2 qcommon constants module.
const U_MODEL2 = 1 << 20
/// Defines the u model3 constant used by the miniquake2 qcommon constants module.
const U_MODEL3 = 1 << 21
/// Defines the u model4 constant used by the miniquake2 qcommon constants module.
const U_MODEL4 = 1 << 22
/// Defines the u morebits3 constant used by the miniquake2 qcommon constants module.
const U_MOREBITS3 = 1 << 23
/// Defines the u oldorigin constant used by the miniquake2 qcommon constants module.
const U_OLDORIGIN = 1 << 24
/// Defines the u skin16 constant used by the miniquake2 qcommon constants module.
const U_SKIN16 = 1 << 25
/// Defines the u sound constant used by the miniquake2 qcommon constants module.
const U_SOUND = 1 << 26
/// Defines the u solid constant used by the miniquake2 qcommon constants module.
const U_SOLID = 1 << 27

/// Defines the print low constant used by the miniquake2 qcommon constants module.
const PRINT_LOW = 0
/// Defines the print medium constant used by the miniquake2 qcommon constants module.
const PRINT_MEDIUM = 1
/// Defines the print high constant used by the miniquake2 qcommon constants module.
const PRINT_HIGH = 2
/// Defines the print chat constant used by the miniquake2 qcommon constants module.
const PRINT_CHAT = 3
/// Defines the err fatal constant used by the miniquake2 qcommon constants module.
const ERR_FATAL = 0
/// Defines the err drop constant used by the miniquake2 qcommon constants module.
const ERR_DROP = 1
/// Defines the err disconnect constant used by the miniquake2 qcommon constants module.
const ERR_DISCONNECT = 2

/// Defines the cvar archive constant used by the miniquake2 qcommon constants module.
const CVAR_ARCHIVE = 1
/// Defines the cvar userinfo constant used by the miniquake2 qcommon constants module.
const CVAR_USERINFO = 2
/// Defines the cvar serverinfo constant used by the miniquake2 qcommon constants module.
const CVAR_SERVERINFO = 4
/// Defines the cvar noset constant used by the miniquake2 qcommon constants module.
const CVAR_NOSET = 8
/// Defines the cvar latch constant used by the miniquake2 qcommon constants module.
const CVAR_LATCH = 16

/// Defines the contents solid constant used by the miniquake2 qcommon constants module.
const CONTENTS_SOLID = 0x00000001
/// Defines the contents window constant used by the miniquake2 qcommon constants module.
const CONTENTS_WINDOW = 0x00000002
/// Defines the contents aux constant used by the miniquake2 qcommon constants module.
const CONTENTS_AUX = 0x00000004
/// Defines the contents lava constant used by the miniquake2 qcommon constants module.
const CONTENTS_LAVA = 0x00000008
/// Defines the contents slime constant used by the miniquake2 qcommon constants module.
const CONTENTS_SLIME = 0x00000010
/// Defines the contents water constant used by the miniquake2 qcommon constants module.
const CONTENTS_WATER = 0x00000020
/// Defines the contents mist constant used by the miniquake2 qcommon constants module.
const CONTENTS_MIST = 0x00000040
/// Defines the last visible contents constant used by the miniquake2 qcommon constants module.
const LAST_VISIBLE_CONTENTS = 0x00000040
/// Defines the contents areaportal constant used by the miniquake2 qcommon constants module.
const CONTENTS_AREAPORTAL = 0x00008000
/// Defines the contents playerclip constant used by the miniquake2 qcommon constants module.
const CONTENTS_PLAYERCLIP = 0x00010000
/// Defines the contents monsterclip constant used by the miniquake2 qcommon constants module.
const CONTENTS_MONSTERCLIP = 0x00020000
/// Defines the contents current 0 constant used by the miniquake2 qcommon constants module.
const CONTENTS_CURRENT_0 = 0x00040000
/// Defines the contents current 90 constant used by the miniquake2 qcommon constants module.
const CONTENTS_CURRENT_90 = 0x00080000
/// Defines the contents current 180 constant used by the miniquake2 qcommon constants module.
const CONTENTS_CURRENT_180 = 0x00100000
/// Defines the contents current 270 constant used by the miniquake2 qcommon constants module.
const CONTENTS_CURRENT_270 = 0x00200000
/// Defines the contents current up constant used by the miniquake2 qcommon constants module.
const CONTENTS_CURRENT_UP = 0x00400000
/// Defines the contents current down constant used by the miniquake2 qcommon constants module.
const CONTENTS_CURRENT_DOWN = 0x00800000
/// Defines the contents origin constant used by the miniquake2 qcommon constants module.
const CONTENTS_ORIGIN = 0x01000000
/// Defines the contents monster constant used by the miniquake2 qcommon constants module.
const CONTENTS_MONSTER = 0x02000000
/// Defines the contents deadmonster constant used by the miniquake2 qcommon constants module.
const CONTENTS_DEADMONSTER = 0x04000000
/// Defines the contents detail constant used by the miniquake2 qcommon constants module.
const CONTENTS_DETAIL = 0x08000000
/// Defines the contents translucent constant used by the miniquake2 qcommon constants module.
const CONTENTS_TRANSLUCENT = 0x10000000
/// Defines the contents ladder constant used by the miniquake2 qcommon constants module.
const CONTENTS_LADDER = 0x20000000

/// Defines the surf light constant used by the miniquake2 qcommon constants module.
const SURF_LIGHT = 0x01
/// Defines the surf slick constant used by the miniquake2 qcommon constants module.
const SURF_SLICK = 0x02
/// Defines the surf sky constant used by the miniquake2 qcommon constants module.
const SURF_SKY = 0x04
/// Defines the surf warp constant used by the miniquake2 qcommon constants module.
const SURF_WARP = 0x08
/// Defines the surf trans33 constant used by the miniquake2 qcommon constants module.
const SURF_TRANS33 = 0x10
/// Defines the surf trans66 constant used by the miniquake2 qcommon constants module.
const SURF_TRANS66 = 0x20
/// Defines the surf flowing constant used by the miniquake2 qcommon constants module.
const SURF_FLOWING = 0x40
/// Defines the surf nodraw constant used by the miniquake2 qcommon constants module.
const SURF_NODRAW = 0x80

/// Defines the mask all constant used by the miniquake2 qcommon constants module.
const MASK_ALL = -1
/// Defines the mask solid constant used by the miniquake2 qcommon constants module.
const MASK_SOLID = CONTENTS_SOLID | CONTENTS_WINDOW
/// Defines the mask playersolid constant used by the miniquake2 qcommon constants module.
const MASK_PLAYERSOLID = CONTENTS_SOLID | CONTENTS_PLAYERCLIP | CONTENTS_WINDOW | CONTENTS_MONSTER
/// Defines the mask deadsolid constant used by the miniquake2 qcommon constants module.
const MASK_DEADSOLID = CONTENTS_SOLID | CONTENTS_PLAYERCLIP | CONTENTS_WINDOW
/// Defines the mask monstersolid constant used by the miniquake2 qcommon constants module.
const MASK_MONSTERSOLID = CONTENTS_SOLID | CONTENTS_MONSTERCLIP | CONTENTS_WINDOW | CONTENTS_MONSTER
/// Defines the mask water constant used by the miniquake2 qcommon constants module.
const MASK_WATER = CONTENTS_WATER | CONTENTS_LAVA | CONTENTS_SLIME
/// Defines the mask opaque constant used by the miniquake2 qcommon constants module.
const MASK_OPAQUE = CONTENTS_SOLID | CONTENTS_SLIME | CONTENTS_LAVA
/// Defines the mask shot constant used by the miniquake2 qcommon constants module.
const MASK_SHOT = CONTENTS_SOLID | CONTENTS_MONSTER | CONTENTS_WINDOW | CONTENTS_DEADMONSTER
/// Defines the mask current constant used by the miniquake2 qcommon constants module.
const MASK_CURRENT = CONTENTS_CURRENT_0 | CONTENTS_CURRENT_90 | CONTENTS_CURRENT_180 | CONTENTS_CURRENT_270 | CONTENTS_CURRENT_UP | CONTENTS_CURRENT_DOWN

/// Defines the pm normal constant used by the miniquake2 qcommon constants module.
const PM_NORMAL = 0
/// Defines the pm spectator constant used by the miniquake2 qcommon constants module.
const PM_SPECTATOR = 1
/// Defines the pm dead constant used by the miniquake2 qcommon constants module.
const PM_DEAD = 2
/// Defines the pm gib constant used by the miniquake2 qcommon constants module.
const PM_GIB = 3
/// Defines the pm freeze constant used by the miniquake2 qcommon constants module.
const PM_FREEZE = 4
/// Defines the pmf ducked constant used by the miniquake2 qcommon constants module.
const PMF_DUCKED = 1
/// Defines the pmf jump held constant used by the miniquake2 qcommon constants module.
const PMF_JUMP_HELD = 2
/// Defines the pmf on ground constant used by the miniquake2 qcommon constants module.
const PMF_ON_GROUND = 4
/// Defines the pmf time waterjump constant used by the miniquake2 qcommon constants module.
const PMF_TIME_WATERJUMP = 8
/// Defines the pmf time land constant used by the miniquake2 qcommon constants module.
const PMF_TIME_LAND = 16
/// Defines the pmf time teleport constant used by the miniquake2 qcommon constants module.
const PMF_TIME_TELEPORT = 32
/// Defines the pmf no prediction constant used by the miniquake2 qcommon constants module.
const PMF_NO_PREDICTION = 64
/// Defines the button attack constant used by the miniquake2 qcommon constants module.
const BUTTON_ATTACK = 1
/// Defines the button use constant used by the miniquake2 qcommon constants module.
const BUTTON_USE = 2
/// Defines the button any constant used by the miniquake2 qcommon constants module.
const BUTTON_ANY = 128
/// Defines the maxtouch constant used by the miniquake2 qcommon constants module.
const MAXTOUCH = 32

/// Defines the cs name constant used by the miniquake2 qcommon constants module.
const CS_NAME = 0
/// Defines the cs cdtrack constant used by the miniquake2 qcommon constants module.
const CS_CDTRACK = 1
/// Defines the cs sky constant used by the miniquake2 qcommon constants module.
const CS_SKY = 2
/// Defines the cs skyaxis constant used by the miniquake2 qcommon constants module.
const CS_SKYAXIS = 3
/// Defines the cs skyrotate constant used by the miniquake2 qcommon constants module.
const CS_SKYROTATE = 4
/// Defines the cs statusbar constant used by the miniquake2 qcommon constants module.
const CS_STATUSBAR = 5
/// Defines the cs airaccel constant used by the miniquake2 qcommon constants module.
const CS_AIRACCEL = 29
/// Defines the cs maxclients constant used by the miniquake2 qcommon constants module.
const CS_MAXCLIENTS = 30
/// Defines the cs mapchecksum constant used by the miniquake2 qcommon constants module.
const CS_MAPCHECKSUM = 31
/// Defines the cs models constant used by the miniquake2 qcommon constants module.
const CS_MODELS = 32
/// Defines the cs sounds constant used by the miniquake2 qcommon constants module.
const CS_SOUNDS = CS_MODELS + MAX_MODELS
/// Defines the cs images constant used by the miniquake2 qcommon constants module.
const CS_IMAGES = CS_SOUNDS + MAX_SOUNDS
/// Defines the cs lights constant used by the miniquake2 qcommon constants module.
const CS_LIGHTS = CS_IMAGES + MAX_IMAGES
/// Defines the cs items constant used by the miniquake2 qcommon constants module.
const CS_ITEMS = CS_LIGHTS + MAX_LIGHTSTYLES
/// Defines the cs playerskins constant used by the miniquake2 qcommon constants module.
const CS_PLAYERSKINS = CS_ITEMS + MAX_ITEMS
/// Defines the cs general constant used by the miniquake2 qcommon constants module.
const CS_GENERAL = CS_PLAYERSKINS + MAX_CLIENTS
/// Defines the max configstrings constant used by the miniquake2 qcommon constants module.
const MAX_CONFIGSTRINGS = CS_GENERAL + MAX_GENERAL
