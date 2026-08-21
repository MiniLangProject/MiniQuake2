/*
Copyright (C) 1997-2001 Id Software, Inc.
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later

Protocol 34 wire constants.  They intentionally live at the client/server
boundary as well as in qcommon so packet codecs can be used independently.
*/
package miniquake2.protocol.constants

const PROTOCOL_VERSION = 34
const MAX_MSGLEN = 1400
const PACKET_HEADER_CLIENT = 10
const PACKET_HEADER_SERVER = 8
const RELIABLE_BUFFER_SIZE = MAX_MSGLEN - 16
// Protocol 34 has no wire-level fragment header.  Larger reliable tails are
// therefore retained as a bounded queue of independently parseable payload
// chunks and promoted one at a time only after the previous reliable ACK.
const MAX_RELIABLE_QUEUE_FRAGMENTS = 64
const MAX_RELIABLE_QUEUE_BYTES = RELIABLE_BUFFER_SIZE * MAX_RELIABLE_QUEUE_FRAGMENTS
const SEQUENCE_MASK = 0x7fffffff
const SEQUENCE_RELIABLE_BIT = 0x80000000
const CONNECTIONLESS_SEQUENCE = 0xffffffff
const NS_CLIENT = 0
const NS_SERVER = 1
const MAX_EDICTS = 1024
const MAX_STATS = 32
const RF_BEAM = 128

const SVC_PLAYERINFO = 17

// usercmd_t delta flags
const CM_ANGLE1 = 1 << 0
const CM_ANGLE2 = 1 << 1
const CM_ANGLE3 = 1 << 2
const CM_FORWARD = 1 << 3
const CM_SIDE = 1 << 4
const CM_UP = 1 << 5
const CM_BUTTONS = 1 << 6
const CM_IMPULSE = 1 << 7

// player_state_t delta flags
const PS_M_TYPE = 1 << 0
const PS_M_ORIGIN = 1 << 1
const PS_M_VELOCITY = 1 << 2
const PS_M_TIME = 1 << 3
const PS_M_FLAGS = 1 << 4
const PS_M_GRAVITY = 1 << 5
const PS_M_DELTA_ANGLES = 1 << 6
const PS_VIEWOFFSET = 1 << 7
const PS_VIEWANGLES = 1 << 8
const PS_KICKANGLES = 1 << 9
const PS_BLEND = 1 << 10
const PS_FOV = 1 << 11
const PS_WEAPONINDEX = 1 << 12
const PS_WEAPONFRAME = 1 << 13
const PS_RDFLAGS = 1 << 14
const PS_ALL = 0x7fff

// entity_state_t delta flags; protocol 34 deliberately has no bit 13.
const U_ORIGIN1 = 1 << 0
const U_ORIGIN2 = 1 << 1
const U_ANGLE2 = 1 << 2
const U_ANGLE3 = 1 << 3
const U_FRAME8 = 1 << 4
const U_EVENT = 1 << 5
const U_REMOVE = 1 << 6
const U_MOREBITS1 = 1 << 7
const U_NUMBER16 = 1 << 8
const U_ORIGIN3 = 1 << 9
const U_ANGLE1 = 1 << 10
const U_MODEL = 1 << 11
const U_RENDERFX8 = 1 << 12
const U_EFFECTS8 = 1 << 14
const U_MOREBITS2 = 1 << 15
const U_SKIN8 = 1 << 16
const U_FRAME16 = 1 << 17
const U_RENDERFX16 = 1 << 18
const U_EFFECTS16 = 1 << 19
const U_MODEL2 = 1 << 20
const U_MODEL3 = 1 << 21
const U_MODEL4 = 1 << 22
const U_MOREBITS3 = 1 << 23
const U_OLDORIGIN = 1 << 24
const U_SKIN16 = 1 << 25
const U_SOUND = 1 << 26
const U_SOLID = 1 << 27
const U_ALL = 0x0fffffff & ~(1 << 13)
