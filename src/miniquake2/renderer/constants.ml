//! Provides miniquake2 renderer constants facilities for this project.

/*
Copyright (C) 1997-2001 Id Software, Inc.
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later

Quake II 3.19 refresh contract constants from client/ref.h and
game/q_shared.h. The names intentionally mirror the C interface.
*/
package miniquake2.renderer.constants

/// Defines the api version constant used by the miniquake2 renderer constants module.
const API_VERSION = 3

/// Defines the max dlights constant used by the miniquake2 renderer constants module.
const MAX_DLIGHTS = 32
/// Defines the max entities constant used by the miniquake2 renderer constants module.
const MAX_ENTITIES = 128
/// Defines the max particles constant used by the miniquake2 renderer constants module.
const MAX_PARTICLES = 4096
/// Defines the max lightstyles constant used by the miniquake2 renderer constants module.
const MAX_LIGHTSTYLES = 256
/// Defines the entity flags constant used by the miniquake2 renderer constants module.
const ENTITY_FLAGS = 68

/// Defines the powersuit scale constant used by the miniquake2 renderer constants module.
const POWERSUIT_SCALE = 4.0

/// Defines the shell red color constant used by the miniquake2 renderer constants module.
const SHELL_RED_COLOR = 0xf2
/// Defines the shell green color constant used by the miniquake2 renderer constants module.
const SHELL_GREEN_COLOR = 0xd0
/// Defines the shell blue color constant used by the miniquake2 renderer constants module.
const SHELL_BLUE_COLOR = 0xf3
/// Defines the shell rg color constant used by the miniquake2 renderer constants module.
const SHELL_RG_COLOR = 0xdc
/// Defines the shell rb color constant used by the miniquake2 renderer constants module.
const SHELL_RB_COLOR = 0x68
/// Defines the shell bg color constant used by the miniquake2 renderer constants module.
const SHELL_BG_COLOR = 0x78
/// Defines the shell double color constant used by the miniquake2 renderer constants module.
const SHELL_DOUBLE_COLOR = 0xdf
/// Defines the shell half dam color constant used by the miniquake2 renderer constants module.
const SHELL_HALF_DAM_COLOR = 0x90
/// Defines the shell cyan color constant used by the miniquake2 renderer constants module.
const SHELL_CYAN_COLOR = 0x72
/// Defines the shell white color constant used by the miniquake2 renderer constants module.
const SHELL_WHITE_COLOR = 0xd7

/// Defines the rf minlight constant used by the miniquake2 renderer constants module.
const RF_MINLIGHT = 1
/// Defines the rf viewermodel constant used by the miniquake2 renderer constants module.
const RF_VIEWERMODEL = 2
/// Defines the rf weaponmodel constant used by the miniquake2 renderer constants module.
const RF_WEAPONMODEL = 4
/// Defines the rf fullbright constant used by the miniquake2 renderer constants module.
const RF_FULLBRIGHT = 8
/// Defines the rf depthhack constant used by the miniquake2 renderer constants module.
const RF_DEPTHHACK = 16
/// Defines the rf translucent constant used by the miniquake2 renderer constants module.
const RF_TRANSLUCENT = 32
/// Defines the rf framelerp constant used by the miniquake2 renderer constants module.
const RF_FRAMELERP = 64
/// Defines the rf beam constant used by the miniquake2 renderer constants module.
const RF_BEAM = 128
/// Defines the rf customskin constant used by the miniquake2 renderer constants module.
const RF_CUSTOMSKIN = 256
/// Defines the rf glow constant used by the miniquake2 renderer constants module.
const RF_GLOW = 512
/// Defines the rf shell red constant used by the miniquake2 renderer constants module.
const RF_SHELL_RED = 1024
/// Defines the rf shell green constant used by the miniquake2 renderer constants module.
const RF_SHELL_GREEN = 2048
/// Defines the rf shell blue constant used by the miniquake2 renderer constants module.
const RF_SHELL_BLUE = 4096
/// Defines the rf ir visible constant used by the miniquake2 renderer constants module.
const RF_IR_VISIBLE = 0x00008000
/// Defines the rf shell double constant used by the miniquake2 renderer constants module.
const RF_SHELL_DOUBLE = 0x00010000
/// Defines the rf shell half dam constant used by the miniquake2 renderer constants module.
const RF_SHELL_HALF_DAM = 0x00020000
/// Defines the rf use disguise constant used by the miniquake2 renderer constants module.
const RF_USE_DISGUISE = 0x00040000

/// Defines the rdf underwater constant used by the miniquake2 renderer constants module.
const RDF_UNDERWATER = 1
/// Defines the rdf noworldmodel constant used by the miniquake2 renderer constants module.
const RDF_NOWORLDMODEL = 2
/// Defines the rdf irgoggles constant used by the miniquake2 renderer constants module.
const RDF_IRGOGGLES = 4
/// Defines the rdf uvgoggles constant used by the miniquake2 renderer constants module.
const RDF_UVGOGGLES = 8
