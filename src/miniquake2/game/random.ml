//! Provides miniquake2 game random facilities for this project.

/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Deterministic Win32 C-runtime random sequence used by Quake II 3.19. */
package miniquake2.game.random

/// Store random state data.
struct RandomState
  /// Stores the seed value associated with random state.
  seed
end struct

/// Creates create for the miniquake2 game random module.
/// @param seed seed value consumed by this operation.
function create(seed)
  if typeof(seed) != "int" then return error(9820, "game random seed must be an integer") end if
  return RandomState(seed & 0xffffffff)
end function

/// Return the next integer value.
/// @param state Mutable state inspected or updated by the operation.
function nextInteger(state)
  if typeof(state) != "struct" or typeof(state.seed) != "int" then
    return error(9821, "game random state is malformed")
  end if
  // Visual C's rand() implementation is the sequence used by the original
  // Win32 Quake II game DLL.  Keep the complete 32-bit state even though the
  // public value is the traditional 15-bit RAND_MAX result.
  state.seed = (state.seed * 214013 + 2531011) & 0xffffffff
  return (state.seed >> 16) & 0x7fff
end function

/// Return the unit value.
/// @param state Mutable state inspected or updated by the operation.
function unit(state)
  return nextInteger(state) / 32767.0
end function

/// Return the signed value.
/// @param state Mutable state inspected or updated by the operation.
function signed(state)
  return 2.0 * (unit(state) - 0.5)
end function
