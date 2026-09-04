//! Provides miniquake2 renderer classic constants facilities for this project.

/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Deterministic constants from the Quake II 3.19 ref_gl surface path. */
package miniquake2.renderer.classic.constants

/// Defines the max lightmaps constant used by the miniquake2 renderer classic constants module.
const MAX_LIGHTMAPS = 4
/// Defines the lightmap sample size constant used by the miniquake2 renderer classic constants module.
const LIGHTMAP_SAMPLE_SIZE = 16
/// Defines the lightmap bytes constant used by the miniquake2 renderer classic constants module.
const LIGHTMAP_BYTES = 4
/// Defines the max blocklights constant used by the miniquake2 renderer classic constants module.
const MAX_BLOCKLIGHTS = 34 * 34
/// Defines the dlight cutoff constant used by the miniquake2 renderer classic constants module.
const DLIGHT_CUTOFF = 64.0

/// Hot visibility tests use tagged integers instead of allocating boxed float
const CULL_COORD_SCALE = 16
/// Protocol-34 coordinates span signed-short / 8.  A 4096 normal scale keeps
const CULL_NORMAL_SCALE = 4096
/// Defines the cull product scale constant used by the miniquake2 renderer classic constants module.
const CULL_PRODUCT_SCALE = 65536
/// Defines the cull margin constant used by the miniquake2 renderer classic constants module.
const CULL_MARGIN = 65536
/// Defines the backface fixed epsilon constant used by the miniquake2 renderer classic constants module.
const BACKFACE_FIXED_EPSILON = 655

/// Defines the material opaque constant used by the miniquake2 renderer classic constants module.
const MATERIAL_OPAQUE = 0
/// Defines the material warp constant used by the miniquake2 renderer classic constants module.
const MATERIAL_WARP = 1
/// Defines the material transparent constant used by the miniquake2 renderer classic constants module.
const MATERIAL_TRANSPARENT = 2
/// Defines the material sky constant used by the miniquake2 renderer classic constants module.
const MATERIAL_SKY = 3
/// Defines the material nodraw constant used by the miniquake2 renderer classic constants module.
const MATERIAL_NODRAW = 4
