/* Player-facing g_main.c frame ordering: begin clients, rules, end clients. */
package miniquake2.game.player.frame

import miniquake2.game.player.client as gplayerclient
import miniquake2.game.player.constants as gplayerconstants
import miniquake2.game.player.hud as gplayerhud
import miniquake2.game.player.rules as gplayerrules

function RunPlayerFrame(context)
  context.frameNumber = context.frameNumber + 1
  context.time = context.frameNumber * gplayerconstants.FRAME_TIME
  if context.exitIntermission then
    context.imports.addCommandString("gamemap \"" + context.nextMap + "\"\n")
    context.exitIntermission = false
    context.intermissionTime = 0.0
    for each player in context.players
      if player.edict.inUse and player.health > player.maxHealth then player.health = player.maxHealth end if
    end for
    return miniquake2.game.player.types.RuleResult(false, "level exited", context.nextMap)
  end if
  for each player in context.players
    if player.edict.inUse and player.persistent.connected then
      player.edict.state.oldOrigin = miniquake2.qcommon.types.Vec3(player.edict.state.origin.x, player.edict.state.origin.y, player.edict.state.origin.z)
      gplayerclient.ClientBeginServerFrame(context, player)
    end if
  end for
  result = gplayerrules.CheckDMRules(context)
  gplayerhud.ClientEndServerFrames(context)
  return result
end function
