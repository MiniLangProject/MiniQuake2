//! Provides miniquake2 network constants facilities for this project.

/*
Copyright (C) 1997-2001 Id Software, Inc.
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
package miniquake2.network.constants

/// Defines the ca uninitialized constant used by the miniquake2 network constants module.
const CA_UNINITIALIZED = 0
/// Defines the ca disconnected constant used by the miniquake2 network constants module.
const CA_DISCONNECTED = 1
/// Defines the ca connecting constant used by the miniquake2 network constants module.
const CA_CONNECTING = 2
/// Defines the ca connected constant used by the miniquake2 network constants module.
const CA_CONNECTED = 3
/// Defines the ca active constant used by the miniquake2 network constants module.
const CA_ACTIVE = 4

/// Defines the cs free constant used by the miniquake2 network constants module.
const CS_FREE = 0
/// Defines the cs zombie constant used by the miniquake2 network constants module.
const CS_ZOMBIE = 1
/// Defines the cs connected constant used by the miniquake2 network constants module.
const CS_CONNECTED = 2
/// Defines the cs spawned constant used by the miniquake2 network constants module.
const CS_SPAWNED = 3

/// Defines the na loopback constant used by the miniquake2 network constants module.
const NA_LOOPBACK = 0
/// Defines the na broadcast constant used by the miniquake2 network constants module.
const NA_BROADCAST = 1
/// Defines the na ip constant used by the miniquake2 network constants module.
const NA_IP = 2
/// Defines the na ipx constant used by the miniquake2 network constants module.
const NA_IPX = 3
/// Defines the na broadcast ipx constant used by the miniquake2 network constants module.
const NA_BROADCAST_IPX = 4

/// Defines the max challenges constant used by the miniquake2 network constants module.
const MAX_CHALLENGES = 1024
/// Defines the max masters constant used by the miniquake2 network constants module.
const MAX_MASTERS = 8
/// Defines the max parse entities constant used by the miniquake2 network constants module.
const MAX_PARSE_ENTITIES = 1024
/// Quake II reserves UPDATE_BACKUP * 64 states per client as an average-sized
const MAX_PACKET_ENTITIES = 1024
/// Defines the max map area bytes constant used by the miniquake2 network constants module.
const MAX_MAP_AREA_BYTES = 32
/// Defines the update backup constant used by the miniquake2 network constants module.
const UPDATE_BACKUP = 16
/// Defines the update mask constant used by the miniquake2 network constants module.
const UPDATE_MASK = 15
/// Defines the latency counts constant used by the miniquake2 network constants module.
const LATENCY_COUNTS = 16
/// server.h: ten 10 Hz snapshot sizes form the one-second SV_RateDrop window.
const RATE_MESSAGES = 10
/// Defines the delta safety window constant used by the miniquake2 network constants module.
const DELTA_SAFETY_WINDOW = UPDATE_BACKUP - 3
/// Defines the connect retry msec constant used by the miniquake2 network constants module.
const CONNECT_RETRY_MSEC = 3000
/// Defines the heartbeat msec constant used by the miniquake2 network constants module.
const HEARTBEAT_MSEC = 300000
/// Defines the default timeout msec constant used by the miniquake2 network constants module.
const DEFAULT_TIMEOUT_MSEC = 125000
/// Defines the default zombie msec constant used by the miniquake2 network constants module.
const DEFAULT_ZOMBIE_MSEC = 2000
/// Defines the default reconnect msec constant used by the miniquake2 network constants module.
const DEFAULT_RECONNECT_MSEC = 3000

/// Defines the svc packetentities constant used by the miniquake2 network constants module.
const SVC_PACKETENTITIES = 18
/// Defines the svc frame constant used by the miniquake2 network constants module.
const SVC_FRAME = 20
/// Defines the clc stringcmd constant used by the miniquake2 network constants module.
const CLC_STRINGCMD = 4
