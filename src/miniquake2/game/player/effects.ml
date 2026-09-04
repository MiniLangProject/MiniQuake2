//! Provides miniquake2 game player effects facilities for this project.

/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Stock player connection effects shared by begin and disconnect paths. */
package miniquake2.game.player.effects

import miniquake2.game.constants as gpeconstants
import miniquake2.qcommon.constants as gpeqconstants

/// Emit the four-byte Protocol-34 player muzzleflash used for login/logout.
/// @param context Context that carries state for the operation.
/// @param player player value consumed by this operation.
/// @param flash flash value consumed by this operation.
function EmitConnectionEffect(context, player, flash)
  if flash != gpeconstants.MZ_LOGIN and flash != gpeconstants.MZ_LOGOUT then
    return error(9750, "unsupported player connection effect")
  end if
  context.imports.writeByte(gpeqconstants.SVC_MUZZLEFLASH)
  context.imports.writeShort(player.edict.state.number)
  context.imports.writeByte(flash)
  return context.imports.multicast(player.edict.state.origin,
    gpeconstants.MULTICAST_PVS)
end function
