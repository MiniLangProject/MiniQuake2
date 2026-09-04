//! Provides miniquake2 physics constants facilities for this project.

/*
Copyright (C) 1997-2001 Id Software, Inc.
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later

Movement constants from Quake II 3.19 qcommon/pmove.c.
*/
package miniquake2.physics.constants

/// Defines the step size constant used by the miniquake2 physics constants module.
const STEP_SIZE = 18.0
/// Defines the min step normal constant used by the miniquake2 physics constants module.
const MIN_STEP_NORMAL = 0.7
/// Defines the max clip planes constant used by the miniquake2 physics constants module.
const MAX_CLIP_PLANES = 5
/// Defines the max bumps constant used by the miniquake2 physics constants module.
const MAX_BUMPS = 4
/// Defines the stop epsilon constant used by the miniquake2 physics constants module.
const STOP_EPSILON = 0.1

/// Defines the stop speed constant used by the miniquake2 physics constants module.
const STOP_SPEED = 100.0
/// Defines the max speed constant used by the miniquake2 physics constants module.
const MAX_SPEED = 300.0
/// Defines the duck speed constant used by the miniquake2 physics constants module.
const DUCK_SPEED = 100.0
/// Defines the accelerate constant used by the miniquake2 physics constants module.
const ACCELERATE = 10.0
/// Defines the default air accelerate constant used by the miniquake2 physics constants module.
const DEFAULT_AIR_ACCELERATE = 0.0
/// Defines the water accelerate constant used by the miniquake2 physics constants module.
const WATER_ACCELERATE = 10.0
/// Defines the friction constant used by the miniquake2 physics constants module.
const FRICTION = 6.0
/// Defines the water friction constant used by the miniquake2 physics constants module.
const WATER_FRICTION = 1.0
/// Defines the water speed constant used by the miniquake2 physics constants module.
const WATER_SPEED = 400.0

