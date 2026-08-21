/*
Copyright (C) 1997-2001 Id Software, Inc.
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later

Quake II 3.19 refresh contract constants from client/ref.h and
game/q_shared.h. The names intentionally mirror the C interface.
*/
package miniquake2.renderer.constants

const API_VERSION = 3

const MAX_DLIGHTS = 32
const MAX_ENTITIES = 128
const MAX_PARTICLES = 4096
const MAX_LIGHTSTYLES = 256
const ENTITY_FLAGS = 68

const POWERSUIT_SCALE = 4.0

const SHELL_RED_COLOR = 0xf2
const SHELL_GREEN_COLOR = 0xd0
const SHELL_BLUE_COLOR = 0xf3
const SHELL_RG_COLOR = 0xdc
const SHELL_RB_COLOR = 0x68
const SHELL_BG_COLOR = 0x78
const SHELL_DOUBLE_COLOR = 0xdf
const SHELL_HALF_DAM_COLOR = 0x90
const SHELL_CYAN_COLOR = 0x72
const SHELL_WHITE_COLOR = 0xd7

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
