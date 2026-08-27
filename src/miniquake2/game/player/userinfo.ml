/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* ClientConnect/ClientUserinfoChanged and persistent client initialization. */
package miniquake2.game.player.userinfo

import miniquake2.game.gameplay.item_rules as gprules
import miniquake2.game.player.types as gplayertypes
import miniquake2.qcommon.byteio as qbyteio
import miniquake2.qcommon.constants as qconstants
import miniquake2.qcommon.info as qinfo

// Return the numeric value.
function numeric(text, fallback)
  converted = try(toNumber(text))
  if converted is error or (typeof(converted) != "int" and typeof(converted) != "float") then return fallback end if
  return converted
end function

// Return the password matches value.
function passwordMatches(required, supplied)
  if required == "" or required == "none" then return true end if
  return supplied == required
end function

// Initialize client persistent.
function InitClientPersistent(player, context)
  itemSlots = len(player.gameplay.inventory.counts)
  player.gameplay.inventory.counts = array(itemSlots, 0)
  blaster = gprules.findByPickupName(context.registry, "Blaster")
  if blaster is void then return error(9700, "InitClientPersistent: Blaster is absent from registry") end if
  player.gameplay.inventory.counts[blaster.index] = 1
  player.gameplay.inventory.selectedItem = blaster.index
  player.gameplay.currentWeapon = blaster
  player.gameplay.lastWeapon = void
  player.gameplay.newWeapon = void
  player.gameplay.ammoIndex = 0
  player.persistent.health = 100
  player.persistent.maxHealth = 100
  player.persistent.selectedItem = blaster.index
  player.persistent.connected = true
  return true
end function

// Return the client userinfo changed value.
function ClientUserinfoChanged(context, player, userInfo)
  if qinfo.validate(userInfo) != true then userInfo = "\\name\\badinfo\\skin\\male/grunt" end if
  name = qinfo.valueForKey(userInfo, "name")
  if name == "" then name = "unnamed" end if
  skin = qinfo.valueForKey(userInfo, "skin")
  if skin == "" then skin = "male/grunt" end if
  spectatorValue = qinfo.valueForKey(userInfo, "spectator")
  player.persistent.netName = name
  player.persistent.skin = skin
  player.persistent.spectator = context.deathmatch and spectatorValue != "" and spectatorValue != "0"
  player.persistent.hand = qbyteio.truncInt(numeric(qinfo.valueForKey(userInfo, "hand"), player.persistent.hand))
  player.persistent.userInfo = userInfo

  fov = numeric(qinfo.valueForKey(userInfo, "fov"), 90.0)
  if context.deathmatch and (context.dmFlags & miniquake2.game.constants.DF_FIXED_FOV) != 0 then fov = 90.0 end if
  if fov < 1.0 then fov = 90.0 end if
  if fov > 160.0 then fov = 160.0 end if
  player.edict.client.playerState.fov = fov
  context.imports.configString(qconstants.CS_PLAYERSKINS + player.edict.state.number - 1, name + "\\" + skin)
  return userInfo
end function

// Return the spectator count.
function spectatorCount(context, ignoredPlayer)
  count = 0
  for each candidate in context.players
    if nativeRawValue(candidate) != nativeRawValue(ignoredPlayer) and candidate.edict.inUse and candidate.persistent.spectator then count = count + 1 end if
  end for
  return count
end function

// Reject state.
function reject(userInfo, message)
  updated = try(qinfo.setValueForKey(userInfo, "rejmsg", message))
  if updated is error then updated = "\\rejmsg\\" + message end if
  return gplayertypes.connectResult(false, updated, message)
end function

// Connect client.
function ClientConnect(context, player, userInfo)
  if typeof(userInfo) != "string" then return error(9701, "ClientConnect: userinfo text required") end if
  if qinfo.validate(userInfo) != true then userInfo = "\\name\\badinfo\\skin\\male/grunt" end if
  ip = qinfo.valueForKey(userInfo, "ip")
  if context.banCheck is not void and context.banCheck(ip) then return reject(userInfo, "Banned.") end if

  spectatorValue = qinfo.valueForKey(userInfo, "spectator")
  wantsSpectator = context.deathmatch and spectatorValue != "" and spectatorValue != "0"
  if wantsSpectator then
    if passwordMatches(context.spectatorPassword, spectatorValue) != true then return reject(userInfo, "Spectator password required or incorrect.") end if
    if spectatorCount(context, player) >= context.maxSpectators then return reject(userInfo, "Server spectator limit is full.") end if
  else
    if passwordMatches(context.password, qinfo.valueForKey(userInfo, "password")) != true then return reject(userInfo, "Password required or incorrect.") end if
  end if

  if player.persistent.connected != true then
    player.respawn = gplayertypes.zeroRespawn(len(player.gameplay.inventory.counts))
    InitClientPersistent(player, context)
  end if
  ClientUserinfoChanged(context, player, userInfo)
  player.persistent.connected = true
  context.messages = context.messages + [player.persistent.netName + " connected"]
  return gplayertypes.connectResult(true, userInfo, "")
end function

// Return the client disconnect value.
function ClientDisconnect(context, player)
  if player.persistent.connected != true then return false end if
  context.messages = context.messages + [player.persistent.netName + " disconnected"]
  context.imports.unlinkEntity(player.edict)
  player.edict.state.modelIndex = 0
  player.edict.solid = miniquake2.game.constants.SOLID_NOT
  player.edict.inUse = false
  player.persistent.connected = false
  context.imports.configString(qconstants.CS_PLAYERSKINS + player.edict.state.number - 1, "")
  return true
end function
