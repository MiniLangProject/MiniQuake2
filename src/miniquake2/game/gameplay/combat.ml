/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/*
Foundational, deterministic T_Damage/T_RadiusDamage rules.  World traces,
power armor, monster reactions and pain/die callbacks remain later milestones.
*/
package miniquake2.game.gameplay.combat

import miniquake2.game.gameplay.constants as gpconstants
import miniquake2.game.gameplay.types as gptypes
import miniquake2.qcommon.byteio as qbyteio
import std.math as gpmath

function validateVector(value, name)
  if typeof(value) != "array" or len(value) != 3 then return error(9400, name + " must be a three-component vector") end if
  index = 0
  while index < 3
    if typeof(value[index]) != "int" and typeof(value[index]) != "float" then return error(9401, name + " contains a non-numeric component") end if
    index = index + 1
  end while
  return true
end function

function normalized(value)
  validateVector(value, "damage direction")
  length = gpmath.sqrt(value[0] * value[0] + value[1] * value[1] + value[2] * value[2])
  if length == 0.0 then return [0.0, 0.0, 0.0] end if
  return [value[0] / length, value[1] / length, value[2] / length]
end function

function armorSave(target, damage, damageFlags)
  if damage <= 0 or target.armor <= 0 or (damageFlags & gpconstants.DAMAGE_NO_ARMOR) != 0 then return 0 end if
  protection = target.armorNormalProtection
  if (damageFlags & gpconstants.DAMAGE_ENERGY) != 0 then protection = target.armorEnergyProtection end if
  saved = qbyteio.truncInt(gpmath.ceil(protection * damage))
  if saved > target.armor then saved = target.armor end if
  target.armor = target.armor - saved
  return saved
end function

function applyKnockback(target, direction, knockback, selfDamage)
  if knockback == 0 then return 0.0 end if
  if (target.flags & gpconstants.FL_NO_KNOCKBACK) != 0 then return 0.0 end if
  if target.moveType == gpconstants.MOVETYPE_NONE or target.moveType == gpconstants.MOVETYPE_BOUNCE or target.moveType == gpconstants.MOVETYPE_PUSH or target.moveType == gpconstants.MOVETYPE_STOP then return 0.0 end if
  mass = target.mass
  if mass < 50 then mass = 50 end if
  scale = 500.0 * knockback / mass
  if selfDamage then scale = 1600.0 * knockback / mass end if
  target.velocity[0] = target.velocity[0] + direction[0] * scale
  target.velocity[1] = target.velocity[1] + direction[1] * scale
  target.velocity[2] = target.velocity[2] + direction[2] * scale
  return scale
end function

function T_Damage(target, request)
  if typeof(target) != "struct" or typeof(request) != "struct" then return error(9402, "T_Damage: target and request required") end if
  validateVector(request.point, "damage point")
  if typeof(request.damage) != "int" or request.damage < 0 then return error(9403, "T_Damage: non-negative integer damage required") end if
  // Stock T_Damage accepts signed knockback. Floater's electrical zap uses
  // -10 to pull its victim toward the attacker.
  if typeof(request.knockback) != "int" then return error(9404, "T_Damage: integer knockback required") end if
  if target.takeDamage != true then return gptypes.DamageResult(false, 0, 0, 0, 0.0, target.dead, request.meansOfDeath) end if

  damage = request.damage
  meansOfDeath = request.meansOfDeath
  if request.sameTeam and not request.selfDamage then
    if request.noFriendlyFire then damage = 0
    else meansOfDeath = meansOfDeath | gpconstants.MOD_FRIENDLY_FIRE
    end if
  end if
  if request.easyMode and damage > 0 then
    damage = qbyteio.truncInt(damage * 0.5)
    if damage == 0 then damage = 1 end if
  end if

  direction = normalized(request.direction)
  knockbackApplied = 0.0
  if (request.flags & gpconstants.DAMAGE_NO_KNOCKBACK) == 0 then knockbackApplied = applyKnockback(target, direction, request.knockback, request.selfDamage) end if

  take = damage
  protectedDamage = 0
  if (request.flags & gpconstants.DAMAGE_NO_PROTECTION) == 0 then
    if (target.flags & gpconstants.FL_GODMODE) != 0 or target.invincibleUntilFrame > request.currentFrame then
      protectedDamage = take
      take = 0
    end if
  end if
  saved = armorSave(target, take, request.flags)
  take = take - saved
  if take > 0 then
    target.health = target.health - take
    if target.health <= 0 then target.dead = true end if
  end if
  target.damageArmor = target.damageArmor + saved + protectedDamage
  target.damageBlood = target.damageBlood + take
  target.damageKnockback = target.damageKnockback + request.knockback
  target.damageFrom = [request.point[0], request.point[1], request.point[2]]
  return gptypes.DamageResult(true, take, saved, protectedDamage, knockbackApplied, target.dead, meansOfDeath)
end function

function distance(first, second)
  x = first[0] - second[0]
  y = first[1] - second[1]
  z = first[2] - second[2]
  return gpmath.sqrt(x * x + y * y + z * z)
end function

// Visibility/CanDamage is intentionally supplied as a callback so this layer
// stays independent of a concrete collision world while retaining game logic.
function T_RadiusDamage(targets, inflictorOrigin, attackerNumber, baseDamage, radius, ignoreNumber, canDamageCallback, meansOfDeath)
  validateVector(inflictorOrigin, "inflictor origin")
  if typeof(canDamageCallback) != "function" then return error(9405, "T_RadiusDamage: CanDamage callback required") end if
  // MiniLang arrays reject explicit void assignment; false marks targets that
  // were ignored, occluded or outside the radius.
  results = array(len(targets), false)
  index = 0
  while index < len(targets)
    target = targets[index]
    number = target.edict.state.number
    if number != ignoreNumber and target.takeDamage and canDamageCallback(target) then
      points = baseDamage - 0.5 * distance(target.edict.state.origin, inflictorOrigin)
      selfDamage = number == attackerNumber
      if selfDamage then points = points * 0.5 end if
      amount = qbyteio.truncInt(points)
      if amount > 0 and distance(target.edict.state.origin, inflictorOrigin) <= radius then
        direction = [
          target.edict.state.origin[0] - inflictorOrigin[0],
          target.edict.state.origin[1] - inflictorOrigin[1],
          target.edict.state.origin[2] - inflictorOrigin[2]
        ]
        request = gptypes.damageRequest(direction, inflictorOrigin, amount, amount, gpconstants.DAMAGE_RADIUS, meansOfDeath)
        request.selfDamage = selfDamage
        results[index] = T_Damage(target, request)
      end if
    end if
    index = index + 1
  end while
  return results
end function
