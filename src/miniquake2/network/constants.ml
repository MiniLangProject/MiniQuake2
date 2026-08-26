/*
Copyright (C) 1997-2001 Id Software, Inc.
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
package miniquake2.network.constants

const CA_UNINITIALIZED = 0
const CA_DISCONNECTED = 1
const CA_CONNECTING = 2
const CA_CONNECTED = 3
const CA_ACTIVE = 4

const CS_FREE = 0
const CS_ZOMBIE = 1
const CS_CONNECTED = 2
const CS_SPAWNED = 3

const NA_LOOPBACK = 0
const NA_BROADCAST = 1
const NA_IP = 2
const NA_IPX = 3
const NA_BROADCAST_IPX = 4

const MAX_CHALLENGES = 1024
const MAX_MASTERS = 8
const MAX_PARSE_ENTITIES = 1024
// Quake II reserves UPDATE_BACKUP * 64 states per client as an average-sized
// circular history, not as a per-frame visibility cap. SV_BuildClientFrame
// itself walks every edict. A hard 64-entity cutoff preferentially discarded
// newly spawned, high-numbered missiles in ordinary retail scenes.
const MAX_PACKET_ENTITIES = 1024
const MAX_MAP_AREA_BYTES = 32
const UPDATE_BACKUP = 16
const UPDATE_MASK = 15
const LATENCY_COUNTS = 16
// server.h: ten 10 Hz snapshot sizes form the one-second SV_RateDrop window.
const RATE_MESSAGES = 10
const DELTA_SAFETY_WINDOW = UPDATE_BACKUP - 3
const CONNECT_RETRY_MSEC = 3000
const HEARTBEAT_MSEC = 300000
const DEFAULT_TIMEOUT_MSEC = 125000
const DEFAULT_ZOMBIE_MSEC = 2000
const DEFAULT_RECONNECT_MSEC = 3000

const SVC_PACKETENTITIES = 18
const SVC_FRAME = 20
const CLC_STRINGCMD = 4
