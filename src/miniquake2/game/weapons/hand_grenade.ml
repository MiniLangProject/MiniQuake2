/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* The special cook/hold/release state from p_weapon.c:Weapon_Grenade. */
package miniquake2.game.weapons.hand_grenade

import miniquake2.qcommon.byteio as qbyteio
import miniquake2.game.weapons.constants as wbconstants
import miniquake2.game.weapons.projectiles as wbprojectiles

// Fire weapon grenade.
function weaponGrenadeFire(context, state, start, direction, damage, radius, held)
  timer = state.grenadeTime - context.time
  speed = wbconstants.GRENADE_MIN_SPEED + (wbconstants.GRENADE_TIMER - timer) * ((wbconstants.GRENADE_MAX_SPEED - wbconstants.GRENADE_MIN_SPEED) / wbconstants.GRENADE_TIMER)
  speed = qbyteio.truncInt(speed)
  projectile = wbprojectiles.fireGrenade2(context, state.owner, start, direction, damage, speed, timer, radius, held)
  if state.infiniteAmmo == false then state.ammo = state.ammo - 1 end if
  state.grenadeTime = context.time + 1.0
  state.lastProjectile = projectile
  return projectile
end function

// Advance state.
function step(context, state, start, direction, damage, radius)
  // Keep step phases explicit: validate inputs, update owned state, then publish the result.
  if state.weaponState == wbconstants.HAND_READY then
    attacking = ((state.latchedButtons | state.buttons) & wbconstants.BUTTON_ATTACK) != 0
    if attacking then
      state.latchedButtons = state.latchedButtons & ~wbconstants.BUTTON_ATTACK
      if state.ammo > 0 then
        state.gunFrame = 1
        state.weaponState = wbconstants.HAND_FIRING
        state.grenadeTime = 0.0
      else
        context.callbacks.sound(state.owner, "weapons/noammo.wav")
      end if
      return state.lastProjectile
    end if
    state.gunFrame = state.gunFrame + 1
    if state.gunFrame > 48 then state.gunFrame = 16 end if
    return state.lastProjectile
  end if

  if state.weaponState != wbconstants.HAND_FIRING then return state.lastProjectile end if
  if state.gunFrame == 5 then context.callbacks.sound(state.owner, "weapons/hgrena1b.wav") end if
  if state.gunFrame == 11 then
    if state.grenadeTime == 0.0 then
      state.grenadeTime = context.time + wbconstants.GRENADE_TIMER + 0.2
      state.weaponSound = "weapons/hgrenc1b.wav"
    end if
    if state.grenadeBlewUp == false and context.time >= state.grenadeTime then
      state.weaponSound = ""
      weaponGrenadeFire(context, state, start, direction, damage, radius, true)
      state.grenadeBlewUp = true
    end if
    if (state.buttons & wbconstants.BUTTON_ATTACK) != 0 then return state.lastProjectile end if
    if state.grenadeBlewUp then
      if context.time >= state.grenadeTime then
        state.gunFrame = 15
        state.grenadeBlewUp = false
      else
        return state.lastProjectile
      end if
    end if
  end if

  if state.gunFrame == 12 then
    state.weaponSound = ""
    weaponGrenadeFire(context, state, start, direction, damage, radius, false)
  end if
  if state.gunFrame == 15 and context.time < state.grenadeTime then return state.lastProjectile end if
  state.gunFrame = state.gunFrame + 1
  if state.gunFrame == 16 then
    state.grenadeTime = 0.0
    state.weaponState = wbconstants.HAND_READY
  end if
  return state.lastProjectile
end function

// Fire weapon grenade.
function weapon_grenade_fire(context, state, start, direction, damage, radius, held)
  return weaponGrenadeFire(context, state, start, direction, damage, radius, held)
end function
// Return the weapon grenade value.
function Weapon_Grenade(context, state, start, direction, damage, radius)
  return step(context, state, start, direction, damage, radius)
end function
