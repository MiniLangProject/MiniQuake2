/* Obituary/score/death and deathmatch frame rules from p_client.c/g_main.c. */
package miniquake2.game.player.rules

import miniquake2.game.gameplay.constants as gpconstants
import miniquake2.game.player.constants as gplayerconstants
import miniquake2.game.player.types as gplayertypes
import miniquake2.qcommon.info as qinfo
import miniquake2.qcommon.text as qtext
import std.math as gplayermath
import std.string as gplayerstring

function genderPronoun(player, neutralWord, femaleWord, maleWord)
  gender = qinfo.valueForKey(player.persistent.userInfo, "gender")
  if gender == "f" or gender == "F" then return femaleWord end if
  if gender == "m" or gender == "M" then return maleWord end if
  return neutralWord
end function

function environmentMessage(mod)
  if mod == gplayerconstants.MOD_SUICIDE then return "suicides" end if
  if mod == gplayerconstants.MOD_FALLING then return "cratered" end if
  if mod == gplayerconstants.MOD_CRUSH then return "was squished" end if
  if mod == gplayerconstants.MOD_WATER then return "sank like a rock" end if
  if mod == gplayerconstants.MOD_SLIME then return "melted" end if
  if mod == gplayerconstants.MOD_LAVA then return "does a back flip into the lava" end if
  if mod == gplayerconstants.MOD_EXPLOSIVE or mod == gplayerconstants.MOD_BARREL then return "blew up" end if
  if mod == gplayerconstants.MOD_EXIT then return "found a way out" end if
  if mod == gplayerconstants.MOD_TARGET_LASER then return "saw the light" end if
  if mod == gplayerconstants.MOD_TARGET_BLASTER then return "got blasted" end if
  if mod == gplayerconstants.MOD_BOMB or mod == gplayerconstants.MOD_SPLASH or mod == gplayerconstants.MOD_TRIGGER_HURT then return "was in the wrong place" end if
  return ""
end function

function selfMessage(player, mod)
  if mod == gplayerconstants.MOD_HELD_GRENADE then return "tried to put the pin back in" end if
  if mod == gpconstants.MOD_HG_SPLASH or mod == gpconstants.MOD_G_SPLASH then return "tripped on " + genderPronoun(player, "its", "her", "his") + " own grenade" end if
  if mod == gpconstants.MOD_R_SPLASH then return "blew " + genderPronoun(player, "itself", "herself", "himself") + " up" end if
  if mod == gpconstants.MOD_BFG_BLAST then return "should have used a smaller gun" end if
  return "killed " + genderPronoun(player, "itself", "herself", "himself")
end function

function weaponMessage(mod)
  if mod == gpconstants.MOD_BLASTER then return ["was blasted by", ""] end if
  if mod == gpconstants.MOD_SHOTGUN then return ["was gunned down by", ""] end if
  if mod == gpconstants.MOD_SSHOTGUN then return ["was blown away by", "'s super shotgun"] end if
  if mod == gpconstants.MOD_MACHINEGUN then return ["was machinegunned by", ""] end if
  if mod == gpconstants.MOD_CHAINGUN then return ["was cut in half by", "'s chaingun"] end if
  if mod == gpconstants.MOD_GRENADE then return ["was popped by", "'s grenade"] end if
  if mod == gpconstants.MOD_G_SPLASH then return ["was shredded by", "'s shrapnel"] end if
  if mod == gpconstants.MOD_ROCKET then return ["ate", "'s rocket"] end if
  if mod == gpconstants.MOD_R_SPLASH then return ["almost dodged", "'s rocket"] end if
  if mod == gpconstants.MOD_HYPERBLASTER then return ["was melted by", "'s hyperblaster"] end if
  if mod == gpconstants.MOD_RAILGUN then return ["was railed by", ""] end if
  if mod == gpconstants.MOD_BFG_LASER then return ["saw the pretty lights from", "'s BFG"] end if
  if mod == gpconstants.MOD_BFG_BLAST then return ["was disintegrated by", "'s BFG blast"] end if
  if mod == gpconstants.MOD_BFG_EFFECT then return ["couldn't hide from", "'s BFG"] end if
  if mod == gpconstants.MOD_HANDGRENADE then return ["caught", "'s handgrenade"] end if
  if mod == gpconstants.MOD_HG_SPLASH then return ["didn't see", "'s handgrenade"] end if
  if mod == gplayerconstants.MOD_HELD_GRENADE then return ["feels", "'s pain"] end if
  if mod == gplayerconstants.MOD_TELEFRAG then return ["tried to invade", "'s personal space"] end if
  return ["", ""]
end function

function samePlayer(first, second)
  if first is void or second is void then return false end if
  return nativeRawValue(first) == nativeRawValue(second)
end function

function ClientObituary(context, victim, attacker, meansOfDeath)
  friendlyFire = (meansOfDeath & gpconstants.MOD_FRIENDLY_FIRE) != 0
  if context.cooperative and attacker is not void then friendlyFire = true end if
  mod = meansOfDeath & ~gpconstants.MOD_FRIENDLY_FIRE
  phrase = ""
  if context.deathmatch or context.cooperative then phrase = environmentMessage(mod) end if
  message = ""

  if (context.deathmatch or context.cooperative) and samePlayer(attacker, victim) then phrase = selfMessage(victim, mod) end if
  if phrase != "" then
    message = victim.persistent.netName + " " + phrase + "."
    if context.deathmatch then victim.respawn.score = victim.respawn.score - 1 end if
  else if attacker is not void and (context.deathmatch or context.cooperative) then
    weapon = weaponMessage(mod)
    if weapon[0] != "" then
      message = victim.persistent.netName + " " + weapon[0] + " " + attacker.persistent.netName + weapon[1] + "."
      if context.deathmatch then
        if friendlyFire then attacker.respawn.score = attacker.respawn.score - 1
        else attacker.respawn.score = attacker.respawn.score + 1
        end if
      end if
    end if
  end if
  if message == "" then
    message = victim.persistent.netName + " died."
    if context.deathmatch then victim.respawn.score = victim.respawn.score - 1 end if
  end if
  victim.obituary = message
  context.messages = context.messages + [message]
  attackerScore = 0
  if attacker is not void then attackerScore = attacker.respawn.score end if
  return gplayertypes.DeathResult(message, victim.respawn.score, attackerScore, friendlyFire)
end function

function LookAtKiller(victim, inflictor, attacker)
  source = void
  if attacker is not void and samePlayer(attacker, victim) != true then source = attacker.edict.state.origin
  else if inflictor is not void then source = inflictor.edict.state.origin
  end if
  if source is void then victim.killerYaw = victim.edict.state.angles.y; return victim.killerYaw end if
  dx = source.x - victim.edict.state.origin.x
  dy = source.y - victim.edict.state.origin.y
  if dx != 0.0 then victim.killerYaw = gplayermath.atan2(dy, dx) * 180.0 / 3.141592653589793
  else if dy > 0.0 then victim.killerYaw = 90.0
  else if dy < 0.0 then victim.killerYaw = -90.0
  else victim.killerYaw = 0.0
  end if
  if victim.killerYaw < 0.0 then victim.killerYaw = victim.killerYaw + 360.0 end if
  return victim.killerYaw
end function

function player_die(context, victim, inflictor, attacker, damage, point, meansOfDeath)
  result = gplayertypes.DeathResult(victim.obituary, victim.respawn.score, 0, false)
  victim.takeDamage = gplayerconstants.DAMAGE_YES
  victim.moveType = gplayerconstants.MOVETYPE_TOSS
  victim.edict.state.modelIndex2 = 0
  victim.edict.state.angles.x = 0.0
  victim.edict.state.angles.z = 0.0
  victim.edict.state.sound = 0
  victim.edict.maxs.z = -8.0
  victim.edict.serverFlags = victim.edict.serverFlags | miniquake2.game.constants.SVF_DEADMONSTER
  if victim.deadFlag == gplayerconstants.DEAD_NO then
    victim.respawnTime = context.time + 1.0
    LookAtKiller(victim, inflictor, attacker)
    victim.edict.client.playerState.pmove.moveType = miniquake2.game.constants.PM_DEAD
    result = ClientObituary(context, victim, attacker, meansOfDeath)
    oldInventory = victim.gameplay.inventory.counts
    retained = array(len(oldInventory), 0)
    index = 0
    while index < len(context.registry.items)
      item = context.registry.items[index]
      if context.cooperative and (item.flags & gpconstants.IT_KEY) != 0 then retained[item.index] = oldInventory[item.index] end if
      index = index + 1
    end while
    victim.respawn.cooperativeInventory = retained
    victim.gameplay.inventory.counts = array(len(oldInventory), 0)
    if context.deathmatch then victim.showScores = true end if
    if victim.health >= -40 then
      victim.view.animPriority = gplayerconstants.ANIM_DEATH
      if (victim.edict.client.playerState.pmove.flags & miniquake2.game.constants.PMF_DUCKED) != 0 then
        victim.edict.state.frame = gplayerconstants.FRAME_CROUCH_DEATH_FIRST - 1
        victim.view.animEnd = gplayerconstants.FRAME_CROUCH_DEATH_LAST
      else
        victim.view.deathCycle = (victim.view.deathCycle + 1) % 3
        if victim.view.deathCycle == 0 then victim.edict.state.frame = gplayerconstants.FRAME_DEATH1_FIRST - 1; victim.view.animEnd = gplayerconstants.FRAME_DEATH1_LAST
        else if victim.view.deathCycle == 1 then victim.edict.state.frame = gplayerconstants.FRAME_DEATH2_FIRST - 1; victim.view.animEnd = gplayerconstants.FRAME_DEATH2_LAST
        else victim.edict.state.frame = gplayerconstants.FRAME_DEATH3_FIRST - 1; victim.view.animEnd = gplayerconstants.FRAME_DEATH3_LAST
        end if
      end if
      deathSound = context.imports.soundIndex("*death" + ((context.frameNumber % 4) + 1) + ".wav")
      context.imports.sound(victim.edict, miniquake2.game.constants.CHAN_VOICE, deathSound, 1.0, miniquake2.game.constants.ATTN_NORM, 0.0)
    end if
  end if
  victim.powerups.quadFrame = 0
  victim.powerups.invincibleFrame = 0
  victim.powerups.breatherFrame = 0
  victim.powerups.enviroFrame = 0
  if victim.health < -40 then victim.takeDamage = gplayerconstants.DAMAGE_NO; victim.edict.state.modelIndex = 0 end if
  victim.deadFlag = gplayerconstants.DEAD_DEAD
  context.imports.linkEntity(victim.edict)
  return result
end function

function nextListedMap(context)
  if context.mapList == "" then return "" end if
  maps = gplayerstring.split(context.mapList, " ")
  first = ""
  index = 0
  while index < len(maps)
    gplayerRulesMapHolder = maps[index]
    gplayerRulesCurrentMapHolder = context.mapName
    if typeof(gplayerRulesMapHolder) != "string" or typeof(gplayerRulesCurrentMapHolder) != "string" then
      return error(9760, "map rotation names are not text")
    end if
    if gplayerRulesMapHolder != "" then
      if first == "" then first = gplayerRulesMapHolder end if
      if qtext.equalInsensitive(gplayerRulesMapHolder, gplayerRulesCurrentMapHolder) then
        following = index + 1
        while following < len(maps) and maps[following] == ""; following = following + 1 end while
        if following < len(maps) then return maps[following] end if
        return first
      end if
    end if
    index = index + 1
  end while
  return ""
end function

function EndDMLevel(context, reason)
  destination = ""
  if (context.dmFlags & miniquake2.game.constants.DF_SAME_LEVEL) != 0 then destination = context.mapName
  else destination = nextListedMap(context)
  end if
  if destination == "" then destination = context.nextMap end if
  if destination == "" then destination = context.mapName end if
  context.nextMap = destination
  context.intermissionTime = context.time
  context.messages = context.messages + [reason]
  return gplayertypes.RuleResult(true, reason, destination)
end function

function CheckDMRules(context)
  if context.intermissionTime > 0.0 or context.deathmatch != true then return gplayertypes.RuleResult(false, "", "") end if
  if context.timeLimit > 0.0 and context.time >= context.timeLimit * 60.0 then return EndDMLevel(context, "Timelimit hit.") end if
  if context.fragLimit > 0 then
    for each player in context.players
      if player.edict.inUse and player.respawn.score >= context.fragLimit then return EndDMLevel(context, "Fraglimit hit.") end if
    end for
  end if
  return gplayertypes.RuleResult(false, "", "")
end function
