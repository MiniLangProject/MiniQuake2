//! Provides miniquake2 protocol constants facilities for this project.

/*
Copyright (C) 1997-2001 Id Software, Inc.
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later

Protocol 34 wire constants.  They intentionally live at the client/server
boundary as well as in qcommon so packet codecs can be used independently.
*/
package miniquake2.protocol.constants

/// Defines the protocol version constant used by the miniquake2 protocol constants module.
const PROTOCOL_VERSION = 34
/// Defines the max msglen constant used by the miniquake2 protocol constants module.
const MAX_MSGLEN = 1400
/// Defines the packet header client constant used by the miniquake2 protocol constants module.
const PACKET_HEADER_CLIENT = 10
/// Defines the packet header server constant used by the miniquake2 protocol constants module.
const PACKET_HEADER_SERVER = 8
/// Defines the reliable buffer size constant used by the miniquake2 protocol constants module.
const RELIABLE_BUFFER_SIZE = MAX_MSGLEN - 16
/// Protocol 34 has no wire-level fragment header.  Larger reliable tails are
const MAX_RELIABLE_QUEUE_FRAGMENTS = 64
/// Defines the max reliable queue bytes constant used by the miniquake2 protocol constants module.
const MAX_RELIABLE_QUEUE_BYTES = RELIABLE_BUFFER_SIZE * MAX_RELIABLE_QUEUE_FRAGMENTS
/// Defines the sequence mask constant used by the miniquake2 protocol constants module.
const SEQUENCE_MASK = 0x7fffffff
/// Defines the sequence reliable bit constant used by the miniquake2 protocol constants module.
const SEQUENCE_RELIABLE_BIT = 0x80000000
/// Defines the connectionless sequence constant used by the miniquake2 protocol constants module.
const CONNECTIONLESS_SEQUENCE = 0xffffffff
/// Defines the ns client constant used by the miniquake2 protocol constants module.
const NS_CLIENT = 0
/// Defines the ns server constant used by the miniquake2 protocol constants module.
const NS_SERVER = 1
/// Defines the max edicts constant used by the miniquake2 protocol constants module.
const MAX_EDICTS = 1024
/// Defines the max stats constant used by the miniquake2 protocol constants module.
const MAX_STATS = 32
/// Defines the rf beam constant used by the miniquake2 protocol constants module.
const RF_BEAM = 128

/// Defines the svc playerinfo constant used by the miniquake2 protocol constants module.
const SVC_PLAYERINFO = 17

/// usercmd_t delta flags
const CM_ANGLE1 = 1 << 0
/// Defines the cm angle2 constant used by the miniquake2 protocol constants module.
const CM_ANGLE2 = 1 << 1
/// Defines the cm angle3 constant used by the miniquake2 protocol constants module.
const CM_ANGLE3 = 1 << 2
/// Defines the cm forward constant used by the miniquake2 protocol constants module.
const CM_FORWARD = 1 << 3
/// Defines the cm side constant used by the miniquake2 protocol constants module.
const CM_SIDE = 1 << 4
/// Defines the cm up constant used by the miniquake2 protocol constants module.
const CM_UP = 1 << 5
/// Defines the cm buttons constant used by the miniquake2 protocol constants module.
const CM_BUTTONS = 1 << 6
/// Defines the cm impulse constant used by the miniquake2 protocol constants module.
const CM_IMPULSE = 1 << 7

/// player_state_t delta flags
const PS_M_TYPE = 1 << 0
/// Defines the ps m origin constant used by the miniquake2 protocol constants module.
const PS_M_ORIGIN = 1 << 1
/// Defines the ps m velocity constant used by the miniquake2 protocol constants module.
const PS_M_VELOCITY = 1 << 2
/// Defines the ps m time constant used by the miniquake2 protocol constants module.
const PS_M_TIME = 1 << 3
/// Defines the ps m flags constant used by the miniquake2 protocol constants module.
const PS_M_FLAGS = 1 << 4
/// Defines the ps m gravity constant used by the miniquake2 protocol constants module.
const PS_M_GRAVITY = 1 << 5
/// Defines the ps m delta angles constant used by the miniquake2 protocol constants module.
const PS_M_DELTA_ANGLES = 1 << 6
/// Defines the ps viewoffset constant used by the miniquake2 protocol constants module.
const PS_VIEWOFFSET = 1 << 7
/// Defines the ps viewangles constant used by the miniquake2 protocol constants module.
const PS_VIEWANGLES = 1 << 8
/// Defines the ps kickangles constant used by the miniquake2 protocol constants module.
const PS_KICKANGLES = 1 << 9
/// Defines the ps blend constant used by the miniquake2 protocol constants module.
const PS_BLEND = 1 << 10
/// Defines the ps fov constant used by the miniquake2 protocol constants module.
const PS_FOV = 1 << 11
/// Defines the ps weaponindex constant used by the miniquake2 protocol constants module.
const PS_WEAPONINDEX = 1 << 12
/// Defines the ps weaponframe constant used by the miniquake2 protocol constants module.
const PS_WEAPONFRAME = 1 << 13
/// Defines the ps rdflags constant used by the miniquake2 protocol constants module.
const PS_RDFLAGS = 1 << 14
/// Defines the ps all constant used by the miniquake2 protocol constants module.
const PS_ALL = 0x7fff

/// entity_state_t delta flags; protocol 34 deliberately has no bit 13.
const U_ORIGIN1 = 1 << 0
/// Defines the u origin2 constant used by the miniquake2 protocol constants module.
const U_ORIGIN2 = 1 << 1
/// Defines the u angle2 constant used by the miniquake2 protocol constants module.
const U_ANGLE2 = 1 << 2
/// Defines the u angle3 constant used by the miniquake2 protocol constants module.
const U_ANGLE3 = 1 << 3
/// Defines the u frame8 constant used by the miniquake2 protocol constants module.
const U_FRAME8 = 1 << 4
/// Defines the u event constant used by the miniquake2 protocol constants module.
const U_EVENT = 1 << 5
/// Defines the u remove constant used by the miniquake2 protocol constants module.
const U_REMOVE = 1 << 6
/// Defines the u morebits1 constant used by the miniquake2 protocol constants module.
const U_MOREBITS1 = 1 << 7
/// Defines the u number16 constant used by the miniquake2 protocol constants module.
const U_NUMBER16 = 1 << 8
/// Defines the u origin3 constant used by the miniquake2 protocol constants module.
const U_ORIGIN3 = 1 << 9
/// Defines the u angle1 constant used by the miniquake2 protocol constants module.
const U_ANGLE1 = 1 << 10
/// Defines the u model constant used by the miniquake2 protocol constants module.
const U_MODEL = 1 << 11
/// Defines the u renderfx8 constant used by the miniquake2 protocol constants module.
const U_RENDERFX8 = 1 << 12
/// Defines the u effects8 constant used by the miniquake2 protocol constants module.
const U_EFFECTS8 = 1 << 14
/// Defines the u morebits2 constant used by the miniquake2 protocol constants module.
const U_MOREBITS2 = 1 << 15
/// Defines the u skin8 constant used by the miniquake2 protocol constants module.
const U_SKIN8 = 1 << 16
/// Defines the u frame16 constant used by the miniquake2 protocol constants module.
const U_FRAME16 = 1 << 17
/// Defines the u renderfx16 constant used by the miniquake2 protocol constants module.
const U_RENDERFX16 = 1 << 18
/// Defines the u effects16 constant used by the miniquake2 protocol constants module.
const U_EFFECTS16 = 1 << 19
/// Defines the u model2 constant used by the miniquake2 protocol constants module.
const U_MODEL2 = 1 << 20
/// Defines the u model3 constant used by the miniquake2 protocol constants module.
const U_MODEL3 = 1 << 21
/// Defines the u model4 constant used by the miniquake2 protocol constants module.
const U_MODEL4 = 1 << 22
/// Defines the u morebits3 constant used by the miniquake2 protocol constants module.
const U_MOREBITS3 = 1 << 23
/// Defines the u oldorigin constant used by the miniquake2 protocol constants module.
const U_OLDORIGIN = 1 << 24
/// Defines the u skin16 constant used by the miniquake2 protocol constants module.
const U_SKIN16 = 1 << 25
/// Defines the u sound constant used by the miniquake2 protocol constants module.
const U_SOUND = 1 << 26
/// Defines the u solid constant used by the miniquake2 protocol constants module.
const U_SOLID = 1 << 27
/// Defines the u all constant used by the miniquake2 protocol constants module.
const U_ALL = 0x0fffffff & ~(1 << 13)
