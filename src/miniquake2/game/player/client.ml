/* Asset-free core of BaseQ2 p_client.c, with injected engine callbacks. */
package miniquake2.game.player.client

import miniquake2.game.player.constants as gplayerconstants
import miniquake2.game.player.spawn as gplayerspawn
import miniquake2.game.player.types as gplayertypes
import miniquake2.game.player.userinfo as gplayeruserinfo
import miniquake2.game.gameplay.weapons as gplayerweapons
import miniquake2.game.types as gtypes
import miniquake2.qcommon.byteio as qbyteio
import miniquake2.qcommon.info as qinfo
import miniquake2.qcommon.types as qtypes

function copyPmoveState(state)
  return qtypes.PmoveState(state.moveType,
    [state.origin[0], state.origin[1], state.origin[2]],
    [state.velocity[0], state.velocity[1], state.velocity[2]],
    state.flags, state.time, state.gravity,
    [state.deltaAngles[0], state.deltaAngles[1], state.deltaAngles[2]])
end function

function angleToShort(angle)
  value = qbyteio.truncInt(angle * 65536.0 / 360.0) & 65535
  if value >= 32768 then value = value - 65536 end if
  return value
end function

function shortToAngle(value)
  signed = value & 65535
  if signed >= 32768 then signed = signed - 65536 end if
  return signed * (360.0 / 65536.0)
end function

function ThinkWeapon(context, player)
  player.gameplay.buttons = player.buttons
  player.gameplay.latchedButtons = player.latchedButtons
  if context.weaponThink is not void then
    playerWeaponThinkCallback = context.weaponThink
    return playerWeaponThinkCallback(player, context)
  end if
  item = player.gameplay.currentWeapon
  if item is void or item.weaponThink is void then return false end if
  result = item.weaponThink(player.gameplay, item, context.registry, 0)
  player.latchedButtons = player.gameplay.latchedButtons
  return result
end function

function PutClientInServer(context, player)
  selection = gplayerspawn.SelectSpawnPoint(context, player)
  savedUserInfo = player.persistent.userInfo
  savedRespawn = player.respawn
  if context.deathmatch then
    gplayeruserinfo.InitClientPersistent(player, context)
    player.respawn = savedRespawn
    gplayeruserinfo.ClientUserinfoChanged(context, player, savedUserInfo)
  else if context.cooperative then
    player.respawn = savedRespawn
    if len(savedRespawn.cooperativeInventory) == len(player.gameplay.inventory.counts) then
      player.gameplay.inventory.counts = savedRespawn.cooperativeInventory
    end if
    if savedRespawn.score > player.persistent.score then player.persistent.score = savedRespawn.score end if
  else
    player.respawn = gplayertypes.zeroRespawn(len(player.gameplay.inventory.counts))
  end if
  if player.persistent.health <= 0 then gplayeruserinfo.InitClientPersistent(player, context) end if

  player.health = player.persistent.health
  player.maxHealth = player.persistent.maxHealth
  player.takeDamage = gplayerconstants.DAMAGE_AIM
  player.moveType = gplayerconstants.MOVETYPE_WALK
  player.viewHeight = 22.0
  player.edict.inUse = true
  player.edict.solid = miniquake2.game.constants.SOLID_BBOX
  player.edict.clipMask = miniquake2.qcommon.constants.MASK_PLAYERSOLID
  player.deadFlag = gplayerconstants.DEAD_NO
  player.waterLevel = 0
  player.waterType = 0
  player.flags = player.flags & ~miniquake2.game.gameplay.constants.FL_NO_KNOCKBACK
  player.edict.serverFlags = player.edict.serverFlags & ~(miniquake2.game.constants.SVF_DEADMONSTER | miniquake2.game.constants.SVF_NOCLIENT)
  player.edict.mins = qtypes.Vec3(-16.0, -16.0, -24.0)
  player.edict.maxs = qtypes.Vec3(16.0, 16.0, 32.0)
  player.velocity = [0.0, 0.0, 0.0]
  player.view = gplayertypes.zeroPlayerView()
  player.view.airFinished = context.time + 12.0

  state = gtypes.zeroPlayerState()
  state.pmove.origin = [qbyteio.truncInt(selection.origin[0] * 8.0), qbyteio.truncInt(selection.origin[1] * 8.0), qbyteio.truncInt(selection.origin[2] * 8.0)]
  state.fov = player.edict.client.playerState.fov
  if state.fov < 1.0 then state.fov = 90.0 end if
  player.edict.client.playerState = state
  player.oldPmove = copyPmoveState(state.pmove)

  player.edict.state.effects = 0
  player.edict.state.modelIndex = gplayerconstants.PLAYER_MODEL_INDEX
  player.edict.state.modelIndex2 = gplayerconstants.PLAYER_MODEL_INDEX
  player.edict.state.skinNumber = player.edict.state.number - 1
  player.edict.state.frame = 0
  player.edict.state.origin = qtypes.Vec3(selection.origin[0], selection.origin[1], selection.origin[2] + 1.0)
  player.edict.state.oldOrigin = qtypes.Vec3(player.edict.state.origin.x, player.edict.state.origin.y, player.edict.state.origin.z)
  player.edict.state.angles = qtypes.Vec3(0.0, selection.angles[1], 0.0)
  state.viewAngles = qtypes.Vec3(0.0, selection.angles[1], 0.0)
  state.pmove.deltaAngles = [
    angleToShort(selection.angles[0] - player.respawn.commandAngles[0]),
    angleToShort(selection.angles[1] - player.respawn.commandAngles[1]),
    angleToShort(selection.angles[2] - player.respawn.commandAngles[2])
  ]

  if player.persistent.spectator then
    player.chaseTarget = void
    player.respawn.spectator = true
    player.moveType = gplayerconstants.MOVETYPE_NOCLIP
    player.edict.solid = miniquake2.game.constants.SOLID_NOT
    player.edict.serverFlags = player.edict.serverFlags | miniquake2.game.constants.SVF_NOCLIENT
    state.gunIndex = 0
    context.imports.linkEntity(player.edict)
    return selection
  end if
  player.respawn.spectator = false
  if context.killBox is not void then context.killBox(player) end if
  context.imports.linkEntity(player.edict)
  player.gameplay.newWeapon = player.gameplay.currentWeapon
  gplayerweapons.ChangeWeapon(player.gameplay, context.registry)
  return selection
end function

function ClientBegin(context, player)
  if player.persistent.connected != true then return error(9720, "ClientBegin: player is not connected") end if
  if player.edict.inUse != true or context.deathmatch then
    player.respawn = gplayertypes.zeroRespawn(len(player.gameplay.inventory.counts))
    player.respawn.enterFrame = context.frameNumber
    PutClientInServer(context, player)
  end if
  context.messages = context.messages + [player.persistent.netName + " entered the game"]
  return true
end function

function respawn(context, player)
  if context.deathmatch or context.cooperative then
    if player.moveType != gplayerconstants.MOVETYPE_NOCLIP and context.copyBody is not void then context.copyBody(player) end if
    player.edict.serverFlags = player.edict.serverFlags & ~miniquake2.game.constants.SVF_NOCLIENT
    PutClientInServer(context, player)
    player.edict.state.event = miniquake2.game.constants.EV_PLAYER_TELEPORT
    player.edict.client.playerState.pmove.flags = miniquake2.game.constants.PMF_TIME_TELEPORT
    player.edict.client.playerState.pmove.time = 14
    player.respawnTime = context.time
    return true
  end if
  context.imports.addCommandString("menu_loadgame\n")
  return false
end function

function spectator_respawn(context, player)
  if player.persistent.spectator then
    value = qinfo.valueForKey(player.persistent.userInfo, "spectator")
    if gplayeruserinfo.passwordMatches(context.spectatorPassword, value) != true then
      player.persistent.spectator = false
      context.messages = context.messages + ["Spectator password incorrect."]
      return false
    end if
    if gplayeruserinfo.spectatorCount(context, player) >= context.maxSpectators then
      player.persistent.spectator = false
      context.messages = context.messages + ["Server spectator limit is full."]
      return false
    end if
  else
    value = qinfo.valueForKey(player.persistent.userInfo, "password")
    if gplayeruserinfo.passwordMatches(context.password, value) != true then
      player.persistent.spectator = true
      context.messages = context.messages + ["Password incorrect."]
      return false
    end if
  end if
  player.respawn.score = player.persistent.score
  player.edict.serverFlags = player.edict.serverFlags & ~miniquake2.game.constants.SVF_NOCLIENT
  PutClientInServer(context, player)
  if player.persistent.spectator then context.messages = context.messages + [player.persistent.netName + " moved to the sidelines"]
  else context.messages = context.messages + [player.persistent.netName + " joined the game"]
  end if
  return true
end function

function chaseCandidate(context, player)
  for each candidate in context.players
    if nativeRawValue(candidate) != nativeRawValue(player) and candidate.edict.inUse and candidate.respawn.spectator != true then return candidate end if
  end for
  return void
end function

function ClientThink(context, player, command)
  if typeof(command) != "struct" then return error(9721, "ClientThink: user command required") end if
  if context.intermissionTime > 0.0 then
    player.edict.client.playerState.pmove.moveType = miniquake2.game.constants.PM_FREEZE
    if context.time > context.intermissionTime + 5.0 and (command.buttons & miniquake2.game.constants.BUTTON_ANY) != 0 then context.exitIntermission = true end if
    return gplayertypes.FrameResult(false, false, false, context.exitIntermission)
  end if

  moved = false
  if player.chaseTarget is not void then
    player.respawn.commandAngles = [shortToAngle(command.angles[0]), shortToAngle(command.angles[1]), shortToAngle(command.angles[2])]
  else
    pmove = gtypes.zeroPmove(context.pmoveTrace, context.pointContents)
    if player.moveType == gplayerconstants.MOVETYPE_NOCLIP then player.edict.client.playerState.pmove.moveType = miniquake2.game.constants.PM_SPECTATOR
    else if player.edict.state.modelIndex != gplayerconstants.PLAYER_MODEL_INDEX then player.edict.client.playerState.pmove.moveType = miniquake2.game.constants.PM_GIB
    else if player.deadFlag != gplayerconstants.DEAD_NO then player.edict.client.playerState.pmove.moveType = miniquake2.game.constants.PM_DEAD
    else player.edict.client.playerState.pmove.moveType = miniquake2.game.constants.PM_NORMAL
    end if
    player.edict.client.playerState.pmove.gravity = context.gravity
    pmove.state = copyPmoveState(player.edict.client.playerState.pmove)
    pmove.state.origin = [qbyteio.truncInt(player.edict.state.origin.x * 8.0), qbyteio.truncInt(player.edict.state.origin.y * 8.0), qbyteio.truncInt(player.edict.state.origin.z * 8.0)]
    pmove.state.velocity = [qbyteio.truncInt(player.velocity[0] * 8.0), qbyteio.truncInt(player.velocity[1] * 8.0), qbyteio.truncInt(player.velocity[2] * 8.0)]
    pmove.command = command
    pmove.mins = player.edict.mins
    pmove.maxs = player.edict.maxs
    pmove.viewHeight = player.viewHeight
    context.pmove(pmove)
    player.edict.client.playerState.pmove = copyPmoveState(pmove.state)
    player.oldPmove = copyPmoveState(pmove.state)
    player.edict.state.origin = qtypes.Vec3(pmove.state.origin[0] * 0.125, pmove.state.origin[1] * 0.125, pmove.state.origin[2] * 0.125)
    player.velocity = [pmove.state.velocity[0] * 0.125, pmove.state.velocity[1] * 0.125, pmove.state.velocity[2] * 0.125]
    player.edict.mins = pmove.mins
    player.edict.maxs = pmove.maxs
    player.viewHeight = pmove.viewHeight
    player.waterLevel = pmove.waterLevel
    player.waterType = pmove.waterType
    player.groundEntity = pmove.groundEntity
    player.respawn.commandAngles = [shortToAngle(command.angles[0]), shortToAngle(command.angles[1]), shortToAngle(command.angles[2])]
    if player.deadFlag != gplayerconstants.DEAD_NO then player.edict.client.playerState.viewAngles = qtypes.Vec3(-15.0, player.killerYaw, 40.0)
    else player.edict.client.playerState.viewAngles = qtypes.Vec3(pmove.viewAngles.x, pmove.viewAngles.y, pmove.viewAngles.z)
    end if
    context.imports.linkEntity(player.edict)
    if player.moveType != gplayerconstants.MOVETYPE_NOCLIP and context.touchTriggers is not void then context.touchTriggers(player) end if
    if context.touchEntity is not void then
      index = 0
      while index < pmove.numTouch
        duplicate = false
        prior = 0
        while prior < index
          if nativeRawValue(pmove.touchEntities[prior]) == nativeRawValue(pmove.touchEntities[index]) then duplicate = true end if
          prior = prior + 1
        end while
        if duplicate != true then context.touchEntity(pmove.touchEntities[index], player) end if
        index = index + 1
      end while
    end if
    moved = true
  end if

  player.oldButtons = player.buttons
  player.buttons = command.buttons
  player.latchedButtons = player.latchedButtons | (player.buttons & ~player.oldButtons)
  player.lightLevel = command.lightLevel
  fired = false
  if (player.latchedButtons & miniquake2.game.constants.BUTTON_ATTACK) != 0 then
    if player.respawn.spectator then
      player.latchedButtons = 0
      if player.chaseTarget is not void then player.chaseTarget = void; player.edict.client.playerState.pmove.flags = player.edict.client.playerState.pmove.flags & ~miniquake2.game.constants.PMF_NO_PREDICTION
      else player.chaseTarget = chaseCandidate(context, player)
      end if
    else if player.weaponThunk != true then
      player.weaponThunk = true
      fired = ThinkWeapon(context, player) != false
    end if
  end if
  return gplayertypes.FrameResult(moved, fired, false, context.exitIntermission)
end function

function ClientBeginServerFrame(context, player)
  if context.intermissionTime > 0.0 then return gplayertypes.FrameResult(false, false, false, false) end if
  if context.deathmatch and player.persistent.spectator != player.respawn.spectator and context.time - player.respawnTime >= 5.0 then
    changed = spectator_respawn(context, player)
    return gplayertypes.FrameResult(false, false, changed, false)
  end if
  fired = false
  if player.weaponThunk != true and player.respawn.spectator != true then fired = ThinkWeapon(context, player) != false
  else player.weaponThunk = false
  end if
  didRespawn = false
  if player.deadFlag != gplayerconstants.DEAD_NO then
    if context.time > player.respawnTime then
      mask = -1
      if context.deathmatch then mask = miniquake2.game.constants.BUTTON_ATTACK end if
      if (player.latchedButtons & mask) != 0 or (context.deathmatch and (context.dmFlags & miniquake2.game.constants.DF_FORCE_RESPAWN) != 0) then
        didRespawn = respawn(context, player)
        player.latchedButtons = 0
      end if
    end if
    return gplayertypes.FrameResult(false, fired, didRespawn, false)
  end if
  player.latchedButtons = 0
  return gplayertypes.FrameResult(false, fired, false, false)
end function
