//! Provides miniquake2 format constants facilities for this project.

/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Quake II 3.19 on-disk format constants from qcommon/qfiles.h. */
package miniquake2.format.constants

/// Defines the idpakheader constant used by the miniquake2 format constants module.
const IDPAKHEADER = 0x4b434150
/// Defines the idaliasheader constant used by the miniquake2 format constants module.
const IDALIASHEADER = 0x32504449
/// Defines the idspriteheader constant used by the miniquake2 format constants module.
const IDSPRITEHEADER = 0x32534449
/// Defines the idbspheader constant used by the miniquake2 format constants module.
const IDBSPHEADER = 0x50534249

/// Defines the alias version constant used by the miniquake2 format constants module.
const ALIAS_VERSION = 8
/// Defines the sprite version constant used by the miniquake2 format constants module.
const SPRITE_VERSION = 2
/// Defines the bsp version constant used by the miniquake2 format constants module.
const BSP_VERSION = 38
/// Defines the header lumps constant used by the miniquake2 format constants module.
const HEADER_LUMPS = 19
/// Defines the miplevels constant used by the miniquake2 format constants module.
const MIPLEVELS = 4

/// Defines the lump entities constant used by the miniquake2 format constants module.
const LUMP_ENTITIES = 0
/// Defines the lump planes constant used by the miniquake2 format constants module.
const LUMP_PLANES = 1
/// Defines the lump vertexes constant used by the miniquake2 format constants module.
const LUMP_VERTEXES = 2
/// Defines the lump visibility constant used by the miniquake2 format constants module.
const LUMP_VISIBILITY = 3
/// Defines the lump nodes constant used by the miniquake2 format constants module.
const LUMP_NODES = 4
/// Defines the lump texinfo constant used by the miniquake2 format constants module.
const LUMP_TEXINFO = 5
/// Defines the lump faces constant used by the miniquake2 format constants module.
const LUMP_FACES = 6
/// Defines the lump lighting constant used by the miniquake2 format constants module.
const LUMP_LIGHTING = 7
/// Defines the lump leafs constant used by the miniquake2 format constants module.
const LUMP_LEAFS = 8
/// Defines the lump leaffaces constant used by the miniquake2 format constants module.
const LUMP_LEAFFACES = 9
/// Defines the lump leafbrushes constant used by the miniquake2 format constants module.
const LUMP_LEAFBRUSHES = 10
/// Defines the lump edges constant used by the miniquake2 format constants module.
const LUMP_EDGES = 11
/// Defines the lump surfedges constant used by the miniquake2 format constants module.
const LUMP_SURFEDGES = 12
/// Defines the lump models constant used by the miniquake2 format constants module.
const LUMP_MODELS = 13
/// Defines the lump brushes constant used by the miniquake2 format constants module.
const LUMP_BRUSHES = 14
/// Defines the lump brushsides constant used by the miniquake2 format constants module.
const LUMP_BRUSHSIDES = 15
/// Defines the lump pop constant used by the miniquake2 format constants module.
const LUMP_POP = 16
/// Defines the lump areas constant used by the miniquake2 format constants module.
const LUMP_AREAS = 17
/// Defines the lump areaportals constant used by the miniquake2 format constants module.
const LUMP_AREAPORTALS = 18

/// Defines the max files in pack constant used by the miniquake2 format constants module.
const MAX_FILES_IN_PACK = 4096
/// Defines the max triangles constant used by the miniquake2 format constants module.
const MAX_TRIANGLES = 4096
/// Defines the max verts constant used by the miniquake2 format constants module.
const MAX_VERTS = 2048
/// Defines the max frames constant used by the miniquake2 format constants module.
const MAX_FRAMES = 512
/// Defines the max md2 skins constant used by the miniquake2 format constants module.
const MAX_MD2SKINS = 32
/// Defines the max skinname constant used by the miniquake2 format constants module.
const MAX_SKINNAME = 64
/// Defines the numvertexnormals constant used by the miniquake2 format constants module.
const NUMVERTEXNORMALS = 162

/// Defines the contents solid constant used by the miniquake2 format constants module.
const CONTENTS_SOLID = 1
/// Defines the contents window constant used by the miniquake2 format constants module.
const CONTENTS_WINDOW = 2
/// Defines the contents aux constant used by the miniquake2 format constants module.
const CONTENTS_AUX = 4
/// Defines the contents lava constant used by the miniquake2 format constants module.
const CONTENTS_LAVA = 8
/// Defines the contents slime constant used by the miniquake2 format constants module.
const CONTENTS_SLIME = 16
/// Defines the contents water constant used by the miniquake2 format constants module.
const CONTENTS_WATER = 32
/// Defines the contents mist constant used by the miniquake2 format constants module.
const CONTENTS_MIST = 64
/// Defines the contents areaportal constant used by the miniquake2 format constants module.
const CONTENTS_AREAPORTAL = 0x8000
/// Defines the contents playerclip constant used by the miniquake2 format constants module.
const CONTENTS_PLAYERCLIP = 0x10000
/// Defines the contents monsterclip constant used by the miniquake2 format constants module.
const CONTENTS_MONSTERCLIP = 0x20000
/// Defines the contents ladder constant used by the miniquake2 format constants module.
const CONTENTS_LADDER = 0x20000000

/// Defines the surf light constant used by the miniquake2 format constants module.
const SURF_LIGHT = 0x1
/// Defines the surf slick constant used by the miniquake2 format constants module.
const SURF_SLICK = 0x2
/// Defines the surf sky constant used by the miniquake2 format constants module.
const SURF_SKY = 0x4
/// Defines the surf warp constant used by the miniquake2 format constants module.
const SURF_WARP = 0x8
/// Defines the surf trans33 constant used by the miniquake2 format constants module.
const SURF_TRANS33 = 0x10
/// Defines the surf trans66 constant used by the miniquake2 format constants module.
const SURF_TRANS66 = 0x20
/// Defines the surf flowing constant used by the miniquake2 format constants module.
const SURF_FLOWING = 0x40
/// Defines the surf nodraw constant used by the miniquake2 format constants module.
const SURF_NODRAW = 0x80
