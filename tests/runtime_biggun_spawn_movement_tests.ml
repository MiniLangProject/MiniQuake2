/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Retail biggun bstart PMove regression. */
import miniquake2.runtime.campaign_playtest as biggunplaytest
import miniquake2.runtime.play_session as biggunsession
import miniquake2.game.null_game as biggungame
import miniquake2.qcommon.constants as biggunconstants
import miniquake2.qcommon.types as bigguntypes

// Assert the biggun movement test condition.
function biggunAssert(value, message)
  if value != true then return error(8488, message) end if
  return true
end function

// Run the retail biggun movement regression when retail data is supplied.
function main(args)
  if len(args) > 1 then return error(8489,
    "expected optional Quake II install root") end if
  if len(args) == 0 then
    print("runtime_biggun_spawn_movement_tests: SKIP (no retail root)")
    return 0
  end if
  session = biggunsession.createRetailAtSkill(args[0], "biggun", "bstart",
    "\\name\\BiggunMove\\skin\\male/grunt\\rate\\25000", 0)
  biggunsession.runUntilActive(session, 512)
  player = biggungame.playerContext().players[0]
  origin = player.edict.state.origin
  directions = [
    bigguntypes.Vec3(64.0, 0.0, 0.0),
    bigguntypes.Vec3(-64.0, 0.0, 0.0),
    bigguntypes.Vec3(0.0, 64.0, 0.0),
    bigguntypes.Vec3(0.0, -64.0, 0.0)]
  openDirections = 0
  for each direction in directions
    finish = bigguntypes.Vec3(origin.x + direction.x,
      origin.y + direction.y, origin.z)
    trace = biggungame.playerContext().imports.trace(origin,
      player.edict.mins, player.edict.maxs, finish, player.edict,
      biggunconstants.MASK_PLAYERSOLID)
    if not trace.startSolid and not trace.allSolid and trace.fraction > 0.0 then
      openDirections = openDirections + 1
    end if
  end for
  report = biggunplaytest.drive(session, 48)
  biggunAssert(openDirections > 0, "biggun bstart is blocked in every direction")
  biggunAssert(report.planarDisplacement > 64.0,
    "biggun bstart did not move through PMove")
  biggunAssert(report.snapshots == 48 and report.fireCount > 0,
    "biggun input did not retain snapshots and weapon input")
  biggunsession.shutdown(session)
  print("runtime_biggun_spawn_movement_tests: PASS displacement2=" +
    report.planarDisplacement)
  return 0
end function
