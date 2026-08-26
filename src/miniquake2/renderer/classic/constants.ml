/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Deterministic constants from the Quake II 3.19 ref_gl surface path. */
package miniquake2.renderer.classic.constants

const MAX_LIGHTMAPS = 4
const LIGHTMAP_SAMPLE_SIZE = 16
const LIGHTMAP_BYTES = 4
const MAX_BLOCKLIGHTS = 34 * 34
const DLIGHT_CUTOFF = 64.0

// Hot visibility tests use tagged integers instead of allocating boxed float
// intermediates for every BSP draw and frustum plane.
const CULL_COORD_SCALE = 16
// Protocol-34 coordinates span signed-short / 8.  A 4096 normal scale keeps
// the six frustum distances (including the 8192-unit far clip plane) inside
// signed i32 even when the camera is at a protocol boundary and points along
// the map diagonal.  The previous 16384 scale could exceed i32 during normal
// movement despite all source coordinates being valid.
const CULL_NORMAL_SCALE = 4096
const CULL_PRODUCT_SCALE = 65536
const CULL_MARGIN = 65536
const BACKFACE_FIXED_EPSILON = 655

const MATERIAL_OPAQUE = 0
const MATERIAL_WARP = 1
const MATERIAL_TRANSPARENT = 2
const MATERIAL_SKY = 3
const MATERIAL_NODRAW = 4
