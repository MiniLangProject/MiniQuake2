/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Deterministic, asset-free p_view.c core for managed PlayerData. */
package miniquake2.game.player.view

import miniquake2.game.gameplay.constants as gpconstants
import miniquake2.game.player.constants as gplayerconstants
import miniquake2.game.player.rules as gplayerrules
import miniquake2.qcommon.byteio as qbyteio
import miniquake2.qcommon.constants as qconstants
import miniquake2.qcommon.types as qtypes
import miniquake2.physics.vector as phv
import std.math as gplayermath

// Emit sound.
function emitSound(context, player, channel, name, attenuation)
  sound = context.imports.soundIndex(name)
  context.imports.sound(player.edict, channel, sound, 1.0, attenuation, 0.0)
  return name
end function

// Return the random index.
function randomIndex(context, count)
  if count <= 0 then return 0 end if
  result = context.frameNumber % count
  if context.randomIndex is not void then result = context.randomIndex(count) end if
  if typeof(result) != "int" or result < 0 or result >= count then return error(9740, "view random callback returned invalid index") end if
  return result
end function

// Return the point vector value.
function pointVector(point)
  if typeof(point) != "struct" then return qtypes.Vec3(point[0], point[1], point[2]) end if
  return qtypes.Vec3(point.x, point.y, point.z)
end function

// Public adapter for the damage accumulators normally filled by T_Damage.
function RecordDamage(player, blood, armor, powerArmor, knockback, point)
  player.view.damageBlood = player.view.damageBlood + blood
  player.view.damageArmor = player.view.damageArmor + armor
  player.view.damagePowerArmor = player.view.damagePowerArmor + powerArmor
  player.view.damageKnockback = player.view.damageKnockback + knockback
  player.view.damageFrom = pointVector(point)
  return true
end function

// A custom callback may apply armor/team/death rules and returns actual health
// damage. The default keeps the environment layer useful before full wiring.
function ApplyDamage(context, player, amount, damageFlags, meansOfDeath)
  if amount <= 0 or player.health <= 0 then return 0 end if
  if (damageFlags & gpconstants.DAMAGE_NO_PROTECTION) == 0 then
    if (player.flags & gpconstants.FL_GODMODE) != 0 or player.powerups.invincibleFrame > context.frameNumber then return 0 end if
  end if
  applied = amount
  if context.damagePlayer is not void then
    applied = context.damagePlayer(context, player, amount, damageFlags, meansOfDeath)
    if typeof(applied) != "int" or applied < 0 then return error(9741, "damage callback must return a non-negative integer") end if
  else
    player.health = player.health - applied
  end if
  if applied > 0 then RecordDamage(player, applied, 0, 0, 0, player.edict.state.origin) end if
  if player.health <= 0 and player.deadFlag == gplayerconstants.DEAD_NO then
    gplayerrules.player_die(context, player, void, void, applied, [player.edict.state.origin.x, player.edict.state.origin.y, player.edict.state.origin.z], meansOfDeath)
  end if
  return applied
end function

// Return the p world effects value.
function P_WorldEffects(context, player)
  // Keep p world effects phases explicit: validate inputs, update owned state, then publish the result.
  if player.moveType == gplayerconstants.MOVETYPE_NOCLIP then player.view.airFinished = context.time + 12.0; return 0 end if
  waterLevel = player.waterLevel
  oldWaterLevel = player.view.oldWaterLevel
  player.view.oldWaterLevel = waterLevel
  breather = player.powerups.breatherFrame > context.frameNumber
  enviroSuit = player.powerups.enviroFrame > context.frameNumber
  damage = 0

  if oldWaterLevel == 0 and waterLevel != 0 then
    if (player.waterType & qconstants.CONTENTS_LAVA) != 0 then emitSound(context, player, miniquake2.game.constants.CHAN_BODY, "player/lava_in.wav", miniquake2.game.constants.ATTN_NORM)
    else emitSound(context, player, miniquake2.game.constants.CHAN_BODY, "player/watr_in.wav", miniquake2.game.constants.ATTN_NORM)
    end if
    player.flags = player.flags | gplayerconstants.FL_INWATER
    player.view.damageDebounceTime = context.time - 1.0
  end if
  if oldWaterLevel != 0 and waterLevel == 0 then
    emitSound(context, player, miniquake2.game.constants.CHAN_BODY, "player/watr_out.wav", miniquake2.game.constants.ATTN_NORM)
    player.flags = player.flags & ~gplayerconstants.FL_INWATER
  end if
  if oldWaterLevel != 3 and waterLevel == 3 then emitSound(context, player, miniquake2.game.constants.CHAN_BODY, "player/watr_un.wav", miniquake2.game.constants.ATTN_NORM) end if
  if oldWaterLevel == 3 and waterLevel != 3 then
    if player.view.airFinished < context.time then emitSound(context, player, miniquake2.game.constants.CHAN_VOICE, "player/gasp1.wav", miniquake2.game.constants.ATTN_NORM)
    else if player.view.airFinished < context.time + 11.0 then emitSound(context, player, miniquake2.game.constants.CHAN_VOICE, "player/gasp2.wav", miniquake2.game.constants.ATTN_NORM)
    end if
  end if

  if waterLevel == 3 then
    if breather or enviroSuit then
      player.view.airFinished = context.time + 10.0
      remaining = player.powerups.breatherFrame - context.frameNumber
      if remaining % 25 == 0 then
        breathName = "player/u_breath1.wav"
        if player.view.breatherSound != 0 then breathName = "player/u_breath2.wav" end if
        emitSound(context, player, miniquake2.game.constants.CHAN_AUTO, breathName, miniquake2.game.constants.ATTN_NORM)
        player.view.breatherSound = player.view.breatherSound ^ 1
      end if
    end if
    if player.view.airFinished < context.time and player.view.nextDrownTime < context.time and player.health > 0 then
      player.view.nextDrownTime = context.time + 1.0
      player.view.drownDamage = player.view.drownDamage + 2
      if player.view.drownDamage > 15 then player.view.drownDamage = 15 end if
      if player.health <= player.view.drownDamage then emitSound(context, player, miniquake2.game.constants.CHAN_VOICE, "player/drown1.wav", miniquake2.game.constants.ATTN_NORM)
      else if randomIndex(context, 2) != 0 then emitSound(context, player, miniquake2.game.constants.CHAN_VOICE, "*gurp1.wav", miniquake2.game.constants.ATTN_NORM)
      else emitSound(context, player, miniquake2.game.constants.CHAN_VOICE, "*gurp2.wav", miniquake2.game.constants.ATTN_NORM)
      end if
      player.view.painDebounceTime = context.time
      damage = damage + ApplyDamage(context, player, player.view.drownDamage, gpconstants.DAMAGE_NO_ARMOR, gplayerconstants.MOD_WATER)
    end if
  else
    player.view.airFinished = context.time + 12.0
    player.view.drownDamage = 2
  end if

  if waterLevel != 0 and (player.waterType & (qconstants.CONTENTS_LAVA | qconstants.CONTENTS_SLIME)) != 0 then
    if (player.waterType & qconstants.CONTENTS_LAVA) != 0 then
      if player.health > 0 and player.view.painDebounceTime <= context.time and player.powerups.invincibleFrame < context.frameNumber then
        burnName = "player/burn1.wav"
        if randomIndex(context, 2) == 0 then burnName = "player/burn2.wav" end if
        emitSound(context, player, miniquake2.game.constants.CHAN_VOICE, burnName, miniquake2.game.constants.ATTN_NORM)
        player.view.painDebounceTime = context.time + 1.0
      end if
      lavaDamage = 3 * waterLevel
      if enviroSuit then lavaDamage = waterLevel end if
      damage = damage + ApplyDamage(context, player, lavaDamage, 0, gplayerconstants.MOD_LAVA)
    end if
    if (player.waterType & qconstants.CONTENTS_SLIME) != 0 and enviroSuit != true then damage = damage + ApplyDamage(context, player, waterLevel, 0, gplayerconstants.MOD_SLIME) end if
  end if
  return damage
end function

// Return the p falling damage value.
function P_FallingDamage(context, player)
  if player.edict.state.modelIndex != gplayerconstants.PLAYER_MODEL_INDEX or player.moveType == gplayerconstants.MOVETYPE_NOCLIP then return 0 end if
  oldZ = player.view.oldVelocity[2]
  delta = 0.0
  if oldZ < 0.0 and player.velocity[2] > oldZ and player.groundEntity is void then delta = oldZ
  else
    if player.groundEntity is void then return 0 end if
    delta = player.velocity[2] - oldZ
  end if
  delta = delta * delta * 0.0001
  if player.waterLevel == 3 then return 0 end if
  if player.waterLevel == 2 then delta = delta * 0.25 end if
  if player.waterLevel == 1 then delta = delta * 0.5 end if
  if delta < 1.0 then return 0 end if
  if delta < 15.0 then player.edict.state.event = miniquake2.game.constants.EV_FOOTSTEP; return 0 end if

  player.view.fallValue = delta * 0.5
  if player.view.fallValue > 40.0 then player.view.fallValue = 40.0 end if
  player.view.fallTime = context.time + gplayerconstants.FALL_TIME
  if delta <= 30.0 then player.edict.state.event = miniquake2.game.constants.EV_FALLSHORT; return 0 end if
  if player.health > 0 then
    if delta >= 55.0 then player.edict.state.event = miniquake2.game.constants.EV_FALLFAR
    else player.edict.state.event = miniquake2.game.constants.EV_FALL
    end if
  end if
  player.view.painDebounceTime = context.time
  damage = qbyteio.truncInt((delta - 30.0) / 2.0)
  if damage < 1 then damage = 1 end if
  if context.deathmatch and (context.dmFlags & miniquake2.game.constants.DF_NO_FALLING) != 0 then return 0 end if
  return ApplyDamage(context, player, damage, 0, gplayerconstants.MOD_FALLING)
end function

// Return the p damage feedback value.
function P_DamageFeedback(context, player, forward, right)
  // Keep p damage feedback phases explicit: validate inputs, update owned state, then publish the result.
  stats = player.edict.client.playerState.stats
  stats[miniquake2.game.constants.STAT_FLASHES] = 0
  if player.view.damageBlood != 0 then stats[miniquake2.game.constants.STAT_FLASHES] = stats[miniquake2.game.constants.STAT_FLASHES] | 1 end if
  if player.view.damageArmor != 0 and (player.flags & gpconstants.FL_GODMODE) == 0 and player.powerups.invincibleFrame <= context.frameNumber then stats[miniquake2.game.constants.STAT_FLASHES] = stats[miniquake2.game.constants.STAT_FLASHES] | 2 end if
  total = player.view.damageBlood + player.view.damageArmor + player.view.damagePowerArmor
  if total == 0 then return false end if

  if player.view.animPriority < gplayerconstants.ANIM_PAIN and player.edict.state.modelIndex == gplayerconstants.PLAYER_MODEL_INDEX then
    player.view.animPriority = gplayerconstants.ANIM_PAIN
    if (player.edict.client.playerState.pmove.flags & miniquake2.game.constants.PMF_DUCKED) != 0 then
      player.edict.state.frame = gplayerconstants.FRAME_CROUCH_PAIN_FIRST - 1
      player.view.animEnd = gplayerconstants.FRAME_CROUCH_PAIN_LAST
    else
      player.view.painCycle = (player.view.painCycle + 1) % 3
      if player.view.painCycle == 0 then player.edict.state.frame = gplayerconstants.FRAME_PAIN1_FIRST - 1; player.view.animEnd = gplayerconstants.FRAME_PAIN1_LAST
      else if player.view.painCycle == 1 then player.edict.state.frame = gplayerconstants.FRAME_PAIN2_FIRST - 1; player.view.animEnd = gplayerconstants.FRAME_PAIN2_LAST
      else player.edict.state.frame = gplayerconstants.FRAME_PAIN3_FIRST - 1; player.view.animEnd = gplayerconstants.FRAME_PAIN3_LAST
      end if
    end if
  end if

  realCount = total * 1.0
  visibleCount = realCount
  if visibleCount < 10.0 then visibleCount = 10.0 end if
  if context.time > player.view.painDebounceTime and (player.flags & gpconstants.FL_GODMODE) == 0 and player.powerups.invincibleFrame <= context.frameNumber then
    level = 100
    if player.health < 25 then level = 25
    else if player.health < 50 then level = 50
    else if player.health < 75 then level = 75
    end if
    emitSound(context, player, miniquake2.game.constants.CHAN_VOICE, "*pain" + level + "_" + (randomIndex(context, 2) + 1) + ".wav", miniquake2.game.constants.ATTN_NORM)
    player.view.painDebounceTime = context.time + 0.7
  end if
  if player.view.damageAlpha < 0.0 then player.view.damageAlpha = 0.0 end if
  player.view.damageAlpha = player.view.damageAlpha + visibleCount * 0.01
  if player.view.damageAlpha < 0.2 then player.view.damageAlpha = 0.2 end if
  if player.view.damageAlpha > 0.6 then player.view.damageAlpha = 0.6 end if
  player.view.damageBlend = [
    (player.view.damageArmor + player.view.damageBlood) / realCount,
    (player.view.damagePowerArmor + player.view.damageArmor) / realCount,
    player.view.damageArmor / realCount
  ]

  kick = player.view.damageKnockback
  if kick < 0 then kick = -kick end if
  if kick != 0 and player.health > 0 then
    kick = kick * 100.0 / player.health
    if kick < visibleCount * 0.5 then kick = visibleCount * 0.5 end if
    if kick > 50.0 then kick = 50.0 end if
    direction = phv.subtract(player.view.damageFrom, player.edict.state.origin)
    direction = phv.normalized(direction)[0]
    player.view.damageRoll = kick * phv.dot(direction, right) * 0.3
    player.view.damagePitch = kick * -phv.dot(direction, forward) * 0.3
    player.view.damageTime = context.time + gplayerconstants.DAMAGE_TIME
  end if
  player.view.damageBlood = 0
  player.view.damageArmor = 0
  player.view.damagePowerArmor = 0
  player.view.damageKnockback = 0
  return true
end function

// Clamp state.
function clamp(value, minimum, maximum)
  if value < minimum then return minimum end if
  if value > maximum then return maximum end if
  return value
end function

// Return the sv calc roll value.
function SV_CalcRoll(context, player, right)
  side = player.velocity[0] * right.x + player.velocity[1] * right.y + player.velocity[2] * right.z
  sign = 1.0
  if side < 0.0 then sign = -1.0; side = -side end if
  value = context.viewSettings.rollAngle
  if side < context.viewSettings.rollSpeed then side = side * value / context.viewSettings.rollSpeed
  else side = value
  end if
  return side * sign
end function

// Return the sv calc view offset.
function SV_CalcViewOffset(context, player, forward, right)
  // Keep sv calc view offset phases explicit: validate inputs, update owned state, then publish the result.
  state = player.edict.client.playerState
  if player.deadFlag != gplayerconstants.DEAD_NO then
    state.kickAngles = qtypes.Vec3(0.0, 0.0, 0.0)
    state.viewAngles = qtypes.Vec3(-15.0, player.killerYaw, 40.0)
  else
    state.kickAngles = qtypes.Vec3(player.view.kickAngles.x, player.view.kickAngles.y, player.view.kickAngles.z)
    ratio = (player.view.damageTime - context.time) / gplayerconstants.DAMAGE_TIME
    if ratio < 0.0 then ratio = 0.0; player.view.damagePitch = 0.0; player.view.damageRoll = 0.0 end if
    state.kickAngles.x = state.kickAngles.x + ratio * player.view.damagePitch
    state.kickAngles.z = state.kickAngles.z + ratio * player.view.damageRoll
    fallRatio = (player.view.fallTime - context.time) / gplayerconstants.FALL_TIME
    if fallRatio < 0.0 then fallRatio = 0.0 end if
    state.kickAngles.x = state.kickAngles.x + fallRatio * player.view.fallValue
    forwardDelta = player.velocity[0] * forward.x + player.velocity[1] * forward.y + player.velocity[2] * forward.z
    sideDelta = player.velocity[0] * right.x + player.velocity[1] * right.y + player.velocity[2] * right.z
    state.kickAngles.x = state.kickAngles.x + forwardDelta * context.viewSettings.runPitch
    state.kickAngles.z = state.kickAngles.z + sideDelta * context.viewSettings.runRoll
    bobPitch = player.view.bobFracSin * context.viewSettings.bobPitch * player.view.xySpeed
    bobRoll = player.view.bobFracSin * context.viewSettings.bobRoll * player.view.xySpeed
    if (state.pmove.flags & miniquake2.game.constants.PMF_DUCKED) != 0 then bobPitch = bobPitch * 6.0; bobRoll = bobRoll * 6.0 end if
    if (player.view.bobCycle & 1) != 0 then bobRoll = -bobRoll end if
    state.kickAngles.x = state.kickAngles.x + bobPitch
    state.kickAngles.z = state.kickAngles.z + bobRoll
  end if
  offset = qtypes.Vec3(player.view.kickOrigin.x, player.view.kickOrigin.y, player.view.kickOrigin.z + player.viewHeight)
  fallRatio = (player.view.fallTime - context.time) / gplayerconstants.FALL_TIME
  if fallRatio < 0.0 then fallRatio = 0.0 end if
  offset.z = offset.z - fallRatio * player.view.fallValue * 0.4
  bob = player.view.bobFracSin * player.view.xySpeed * context.viewSettings.bobUp
  if bob > 6.0 then bob = 6.0 end if
  offset.z = offset.z + bob
  offset.x = clamp(offset.x, -14.0, 14.0)
  offset.y = clamp(offset.y, -14.0, 14.0)
  offset.z = clamp(offset.z, -22.0, 30.0)
  state.viewOffset = offset
  return offset
end function

// Return the sv calc gun offset.
function SV_CalcGunOffset(context, player, forward, right, up)
  state = player.edict.client.playerState
  roll = player.view.xySpeed * player.view.bobFracSin * 0.005
  yaw = player.view.xySpeed * player.view.bobFracSin * 0.01
  if (player.view.bobCycle & 1) != 0 then roll = -roll; yaw = -yaw end if
  state.gunAngles = qtypes.Vec3(player.view.xySpeed * player.view.bobFracSin * 0.005, yaw, roll)
  deltas = [
    player.view.oldViewAngles.x - state.viewAngles.x,
    player.view.oldViewAngles.y - state.viewAngles.y,
    player.view.oldViewAngles.z - state.viewAngles.z
  ]
  index = 0
  while index < 3
    delta = deltas[index]
    if delta > 180.0 then delta = delta - 360.0 end if
    if delta < -180.0 then delta = delta + 360.0 end if
    delta = clamp(delta, -45.0, 45.0)
    if index == 0 then state.gunAngles.x = state.gunAngles.x + 0.2 * delta
    else if index == 1 then state.gunAngles.y = state.gunAngles.y + 0.2 * delta; state.gunAngles.z = state.gunAngles.z + 0.1 * delta
    else state.gunAngles.z = state.gunAngles.z + 0.2 * delta
    end if
    index = index + 1
  end while
  state.gunOffset = qtypes.Vec3(
    forward.x * context.viewSettings.gunY + right.x * context.viewSettings.gunX + up.x * -context.viewSettings.gunZ,
    forward.y * context.viewSettings.gunY + right.y * context.viewSettings.gunX + up.y * -context.viewSettings.gunZ,
    forward.z * context.viewSettings.gunY + right.z * context.viewSettings.gunX + up.z * -context.viewSettings.gunZ
  )
  return state.gunOffset
end function

// Add sv blend.
function SV_AddBlend(red, green, blue, alpha, blend)
  if alpha <= 0.0 then return blend end if
  totalAlpha = blend[3] + (1.0 - blend[3]) * alpha
  oldFraction = blend[3] / totalAlpha
  blend[0] = blend[0] * oldFraction + red * (1.0 - oldFraction)
  blend[1] = blend[1] * oldFraction + green * (1.0 - oldFraction)
  blend[2] = blend[2] * oldFraction + blue * (1.0 - oldFraction)
  blend[3] = totalAlpha
  return blend
end function

// Return the sv calc blend value.
function SV_CalcBlend(context, player)
  // Keep sv calc blend phases explicit: validate inputs, update owned state, then publish the result.
  state = player.edict.client.playerState
  state.blend = [0.0, 0.0, 0.0, 0.0]
  viewOrigin = qtypes.Vec3(player.edict.state.origin.x + state.viewOffset.x, player.edict.state.origin.y + state.viewOffset.y, player.edict.state.origin.z + state.viewOffset.z)
  contents = context.pointContents(viewOrigin)
  if (contents & (qconstants.CONTENTS_LAVA | qconstants.CONTENTS_SLIME | qconstants.CONTENTS_WATER)) != 0 then state.rdFlags = state.rdFlags | miniquake2.game.constants.RDF_UNDERWATER
  else state.rdFlags = state.rdFlags & ~miniquake2.game.constants.RDF_UNDERWATER
  end if
  if (contents & (qconstants.CONTENTS_SOLID | qconstants.CONTENTS_LAVA)) != 0 then SV_AddBlend(1.0, 0.3, 0.0, 0.6, state.blend)
  else if (contents & qconstants.CONTENTS_SLIME) != 0 then SV_AddBlend(0.0, 0.1, 0.05, 0.6, state.blend)
  else if (contents & qconstants.CONTENTS_WATER) != 0 then SV_AddBlend(0.5, 0.3, 0.2, 0.4, state.blend)
  end if
  if player.powerups.quadFrame > context.frameNumber then
    remaining = player.powerups.quadFrame - context.frameNumber
    if remaining == 30 then emitSound(context, player, miniquake2.game.constants.CHAN_ITEM, "items/damage2.wav", miniquake2.game.constants.ATTN_NORM) end if
    if remaining > 30 or (remaining & 4) != 0 then SV_AddBlend(0.0, 0.0, 1.0, 0.08, state.blend) end if
  else if player.powerups.invincibleFrame > context.frameNumber then
    remaining = player.powerups.invincibleFrame - context.frameNumber
    if remaining == 30 then emitSound(context, player, miniquake2.game.constants.CHAN_ITEM, "items/protect2.wav", miniquake2.game.constants.ATTN_NORM) end if
    if remaining > 30 or (remaining & 4) != 0 then SV_AddBlend(1.0, 1.0, 0.0, 0.08, state.blend) end if
  else if player.powerups.enviroFrame > context.frameNumber then
    remaining = player.powerups.enviroFrame - context.frameNumber
    if remaining == 30 then emitSound(context, player, miniquake2.game.constants.CHAN_ITEM, "items/airout.wav", miniquake2.game.constants.ATTN_NORM) end if
    if remaining > 30 or (remaining & 4) != 0 then SV_AddBlend(0.0, 1.0, 0.0, 0.08, state.blend) end if
  else if player.powerups.breatherFrame > context.frameNumber then
    remaining = player.powerups.breatherFrame - context.frameNumber
    if remaining == 30 then emitSound(context, player, miniquake2.game.constants.CHAN_ITEM, "items/airout.wav", miniquake2.game.constants.ATTN_NORM) end if
    if remaining > 30 or (remaining & 4) != 0 then SV_AddBlend(0.4, 1.0, 0.4, 0.04, state.blend) end if
  end if
  if player.view.damageAlpha > 0.0 then SV_AddBlend(player.view.damageBlend[0], player.view.damageBlend[1], player.view.damageBlend[2], player.view.damageAlpha, state.blend) end if
  if player.view.bonusAlpha > 0.0 then SV_AddBlend(0.85, 0.7, 0.3, player.view.bonusAlpha, state.blend) end if
  player.view.damageAlpha = player.view.damageAlpha - 0.06
  if player.view.damageAlpha < 0.0 then player.view.damageAlpha = 0.0 end if
  player.view.bonusAlpha = player.view.bonusAlpha - 0.1
  if player.view.bonusAlpha < 0.0 then player.view.bonusAlpha = 0.0 end if
  return state.blend
end function

// Set g client effects.
function G_SetClientEffects(context, player)
  player.edict.state.effects = 0
  player.edict.state.renderFx = 0
  if player.health <= 0 or context.intermissionTime > 0.0 then return 0 end if
  if player.powerups.quadFrame > context.frameNumber then
    remaining = player.powerups.quadFrame - context.frameNumber
    if remaining > 30 or (remaining & 4) != 0 then player.edict.state.effects = player.edict.state.effects | miniquake2.game.constants.EF_QUAD end if
  end if
  if player.powerups.invincibleFrame > context.frameNumber then
    remaining = player.powerups.invincibleFrame - context.frameNumber
    if remaining > 30 or (remaining & 4) != 0 then player.edict.state.effects = player.edict.state.effects | miniquake2.game.constants.EF_PENT end if
  end if
  if (player.flags & gpconstants.FL_GODMODE) != 0 then
    player.edict.state.effects = player.edict.state.effects | miniquake2.game.constants.EF_COLOR_SHELL
    player.edict.state.renderFx = player.edict.state.renderFx | miniquake2.game.constants.RF_SHELL_RED | miniquake2.game.constants.RF_SHELL_GREEN | miniquake2.game.constants.RF_SHELL_BLUE
  end if
  return player.edict.state.effects
end function

// Set g client event.
function G_SetClientEvent(player)
  if player.edict.state.event != miniquake2.game.constants.EV_NONE then return player.edict.state.event end if
  if player.groundEntity is not void and player.view.xySpeed > 225.0 and qbyteio.truncInt(player.view.bobTime + player.view.bobMove) != player.view.bobCycle then player.edict.state.event = miniquake2.game.constants.EV_FOOTSTEP end if
  return player.edict.state.event
end function

// Set g client sound.
function G_SetClientSound(context, player)
  // p_view.c keeps acknowledgement and reminder cadence in client->pers.
  // A target_help update therefore notifies every connected player exactly
  // once, without one player's F1 action acknowledging it for everybody.
  if player.persistent.gameHelpChanged != context.helpChanged then
    player.persistent.gameHelpChanged = context.helpChanged
    player.persistent.helpChanged = 1
  end if
  if player.persistent.helpChanged != 0 and
      player.persistent.helpChanged <= 3 and
      (context.frameNumber & 63) == 0 then
    player.persistent.helpChanged = player.persistent.helpChanged + 1
    context.imports.sound(player.edict, miniquake2.game.constants.CHAN_VOICE,
      context.imports.soundIndex("misc/pc_up.wav"), 1.0,
      miniquake2.game.constants.ATTN_STATIC, 0.0)
  end if
  weaponClass = ""
  if player.gameplay.currentWeapon is not void then weaponClass = player.gameplay.currentWeapon.className end if
  if player.waterLevel != 0 and (player.waterType & (qconstants.CONTENTS_LAVA | qconstants.CONTENTS_SLIME)) != 0 then player.edict.state.sound = context.imports.soundIndex("player/fry.wav")
  else if weaponClass == "weapon_railgun" then player.edict.state.sound = context.imports.soundIndex("weapons/rg_hum.wav")
  else if weaponClass == "weapon_bfg" then player.edict.state.sound = context.imports.soundIndex("weapons/bfg_hum.wav")
  else player.edict.state.sound = player.view.weaponSound
  end if
  return player.edict.state.sound
end function

// Set g client frame.
function G_SetClientFrame(player)
  // Keep g set client frame phases explicit: validate inputs, update owned state, then publish the result.
  if player.edict.state.modelIndex != gplayerconstants.PLAYER_MODEL_INDEX then return player.edict.state.frame end if
  duck = (player.edict.client.playerState.pmove.flags & miniquake2.game.constants.PMF_DUCKED) != 0
  run = player.view.xySpeed != 0.0
  newAnimation = duck != player.view.animDuck and player.view.animPriority < gplayerconstants.ANIM_DEATH
  if run != player.view.animRun and player.view.animPriority == gplayerconstants.ANIM_BASIC then newAnimation = true end if
  if player.groundEntity is void and player.view.animPriority <= gplayerconstants.ANIM_WAVE then newAnimation = true end if
  if newAnimation != true then
    if player.view.animPriority == gplayerconstants.ANIM_REVERSE then
      if player.edict.state.frame > player.view.animEnd then player.edict.state.frame = player.edict.state.frame - 1; return player.edict.state.frame end if
    else if player.edict.state.frame < player.view.animEnd then player.edict.state.frame = player.edict.state.frame + 1; return player.edict.state.frame
    end if
    if player.view.animPriority == gplayerconstants.ANIM_DEATH then return player.edict.state.frame end if
    if player.view.animPriority == gplayerconstants.ANIM_JUMP then
      if player.groundEntity is void then return player.edict.state.frame end if
      player.view.animPriority = gplayerconstants.ANIM_WAVE
      player.edict.state.frame = gplayerconstants.FRAME_JUMP_LAND_FIRST
      player.view.animEnd = gplayerconstants.FRAME_JUMP_LAND_LAST
      return player.edict.state.frame
    end if
  end if
  player.view.animPriority = gplayerconstants.ANIM_BASIC
  player.view.animDuck = duck
  player.view.animRun = run
  if player.groundEntity is void then
    player.view.animPriority = gplayerconstants.ANIM_JUMP
    if player.edict.state.frame != gplayerconstants.FRAME_JUMP_LAST then player.edict.state.frame = gplayerconstants.FRAME_JUMP_FIRST end if
    player.view.animEnd = gplayerconstants.FRAME_JUMP_LAST
  else if run then
    if duck then player.edict.state.frame = gplayerconstants.FRAME_CROUCH_WALK_FIRST; player.view.animEnd = gplayerconstants.FRAME_CROUCH_WALK_LAST
    else player.edict.state.frame = gplayerconstants.FRAME_RUN_FIRST; player.view.animEnd = gplayerconstants.FRAME_RUN_LAST
    end if
  else
    if duck then player.edict.state.frame = gplayerconstants.FRAME_CROUCH_STAND_FIRST; player.view.animEnd = gplayerconstants.FRAME_CROUCH_STAND_LAST
    else player.edict.state.frame = gplayerconstants.FRAME_STAND_FIRST; player.view.animEnd = gplayerconstants.FRAME_STAND_LAST
    end if
  end if
  return player.edict.state.frame
end function

// Update bob.
function UpdateBob(player)
  player.view.xySpeed = gplayermath.sqrt(player.velocity[0] * player.velocity[0] + player.velocity[1] * player.velocity[1])
  if player.view.xySpeed < 5.0 then player.view.bobMove = 0.0; player.view.bobTime = 0.0
  else if player.groundEntity is not void then
    if player.view.xySpeed > 210.0 then player.view.bobMove = 0.25
    else if player.view.xySpeed > 100.0 then player.view.bobMove = 0.125
    else player.view.bobMove = 0.0625
    end if
  end if
  player.view.bobTime = player.view.bobTime + player.view.bobMove
  cycleTime = player.view.bobTime
  if (player.edict.client.playerState.pmove.flags & miniquake2.game.constants.PMF_DUCKED) != 0 then cycleTime = cycleTime * 4.0 end if
  player.view.bobCycle = qbyteio.truncInt(cycleTime)
  player.view.bobFracSin = gplayermath.abs(gplayermath.sin(cycleTime * 3.141592653589793))
  return player.view.xySpeed
end function

// Return the client view frame value.
function ClientViewFrame(context, player)
  state = player.edict.client.playerState
  basis = phv.angleVectors(state.viewAngles)
  forward = basis[0]
  right = basis[1]
  up = basis[2]
  P_WorldEffects(context, player)
  if state.viewAngles.x > 180.0 then player.edict.state.angles.x = (-360.0 + state.viewAngles.x) / 3.0
  else player.edict.state.angles.x = state.viewAngles.x / 3.0
  end if
  player.edict.state.angles.y = state.viewAngles.y
  player.edict.state.angles.z = SV_CalcRoll(context, player, right) * 4.0
  UpdateBob(player)
  P_FallingDamage(context, player)
  P_DamageFeedback(context, player, forward, right)
  SV_CalcViewOffset(context, player, forward, right)
  SV_CalcGunOffset(context, player, forward, right, up)
  SV_CalcBlend(context, player)
  G_SetClientEvent(player)
  G_SetClientEffects(context, player)
  G_SetClientSound(context, player)
  G_SetClientFrame(player)
  player.view.oldVelocity = [player.velocity[0], player.velocity[1], player.velocity[2]]
  player.view.oldViewAngles = qtypes.Vec3(state.viewAngles.x, state.viewAngles.y, state.viewAngles.z)
  player.view.kickOrigin = qtypes.Vec3(0.0, 0.0, 0.0)
  player.view.kickAngles = qtypes.Vec3(0.0, 0.0, 0.0)
  return true
end function
