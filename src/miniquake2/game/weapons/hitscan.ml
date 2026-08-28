/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* BaseQ2 fire_lead, fire_bullet, fire_shotgun and fire_rail. */
package miniquake2.game.weapons.hitscan

import miniquake2.qcommon.constants as qc
import miniquake2.qcommon.text as qtext
import miniquake2.qcommon.types as qt
import miniquake2.game.gameplay.constants as gpconstants
import miniquake2.game.weapons.constants as wbconstants
import miniquake2.game.weapons.core as wbcore
import miniquake2.game.weapons.vector as wbvector

// Return the water splash style value.
function waterSplashStyle(trace)
  if (trace.contents & qc.CONTENTS_WATER) != 0 then
    if trace.surface is not void and trace.surface.name == "*brwater" then return wbconstants.SPLASH_BROWN_WATER end if
    return wbconstants.SPLASH_BLUE_WATER
  end if
  if (trace.contents & qc.CONTENTS_SLIME) != 0 then return wbconstants.SPLASH_SLIME end if
  if (trace.contents & qc.CONTENTS_LAVA) != 0 then return wbconstants.SPLASH_LAVA end if
  return wbconstants.SPLASH_UNKNOWN
end function

// Fire lead.
function fireLead(context, shooter, start, aimDirection, damage, kick, impact, horizontalSpread, verticalSpread, meansOfDeath)
  // Keep fire lead phases explicit: validate inputs, update owned state, then publish the result.
  zero = qt.zeroVec3()
  trace = context.callbacks.trace(shooter.origin, zero, zero, start, shooter, qc.MASK_SHOT)
  water = false
  waterStart = wbvector.copy(start)
  endPosition = wbvector.copy(start)

  if trace.fraction >= 1.0 then
    basis = wbvector.angleVectors(wbvector.vectorToAngles(aimDirection))
    forward = basis[0]; right = basis[1]; up = basis[2]
    horizontal = context.callbacks.randomSigned() * horizontalSpread
    vertical = context.callbacks.randomSigned() * verticalSpread
    endPosition = wbvector.multiplyAdd(start, 8192.0, forward)
    endPosition = wbvector.multiplyAdd(endPosition, horizontal, right)
    endPosition = wbvector.multiplyAdd(endPosition, vertical, up)
    mask = qc.MASK_SHOT | qc.MASK_WATER
    if (context.callbacks.pointContents(start) & qc.MASK_WATER) != 0 then
      water = true
      waterStart = wbvector.copy(start)
      mask = mask & ~qc.MASK_WATER
    end if

    trace = context.callbacks.trace(start, zero, zero, endPosition, shooter, mask)
    if (trace.contents & qc.MASK_WATER) != 0 then
      water = true
      waterStart = wbvector.copy(trace.endPosition)
      if wbvector.length(wbvector.subtract(start, trace.endPosition)) != 0.0 then
        style = waterSplashStyle(trace)
        if style != wbconstants.SPLASH_UNKNOWN then
          wbcore.emitEffect(context, "splash", trace.endPosition, trace.endPosition, trace.plane.normal, style, 8)
        end if
        throughWater = wbvector.subtract(endPosition, start)
        waterBasis = wbvector.angleVectors(wbvector.vectorToAngles(throughWater))
        forward = waterBasis[0]; right = waterBasis[1]; up = waterBasis[2]
        horizontal = context.callbacks.randomSigned() * horizontalSpread * 2.0
        vertical = context.callbacks.randomSigned() * verticalSpread * 2.0
        endPosition = wbvector.multiplyAdd(waterStart, 8192.0, forward)
        endPosition = wbvector.multiplyAdd(endPosition, horizontal, right)
        endPosition = wbvector.multiplyAdd(endPosition, vertical, up)
      end if
      trace = context.callbacks.trace(waterStart, zero, zero, endPosition, shooter, qc.MASK_SHOT)
    end if
  end if

  if wbcore.surfaceIsSky(trace) == false and trace.fraction < 1.0 then
    target = trace.entity
    if target is not void and target.combatant is not void and target.combatant.takeDamage then
      wbcore.applyDamage(context, target, shooter, shooter, aimDirection, trace.endPosition, damage, kick, gpconstants.DAMAGE_BULLET, meansOfDeath)
    else
      surfaceName = ""
      if trace.surface is not void then surfaceName = trace.surface.name end if
      if qtext.startsWith(surfaceName, "sky") == false then
        wbcore.emitEffect(context, "impact", trace.endPosition, trace.endPosition, trace.plane.normal, impact, 1)
        if shooter.isClient then context.callbacks.playerNoise(shooter, trace.endPosition, 2) end if
      end if
    end if
  end if

  if water then
    directionResult = wbvector.normalized(wbvector.subtract(trace.endPosition, waterStart))
    position = wbvector.multiplyAdd(trace.endPosition, -2.0, directionResult[0])
    bubbleEnd = wbvector.copy(trace.endPosition)
    if (context.callbacks.pointContents(position) & qc.MASK_WATER) != 0 then
      bubbleEnd = position
    else
      reverse = context.callbacks.trace(position, zero, zero, waterStart, trace.entity, qc.MASK_WATER)
      bubbleEnd = reverse.endPosition
    end if
    wbcore.emitEffect(context, "bubble-trail", waterStart, bubbleEnd, qt.Vec3(0.0, 0.0, 1.0), 0, 1)
  end if
  return trace
end function

// Fire bullet.
function fireBullet(context, shooter, start, aimDirection, damage, kick, horizontalSpread, verticalSpread, meansOfDeath)
  return fireLead(context, shooter, start, aimDirection, damage, kick, wbconstants.IMPACT_GUNSHOT, horizontalSpread, verticalSpread, meansOfDeath)
end function

// Fire shotgun.
function fireShotgun(context, shooter, start, aimDirection, damage, kick, horizontalSpread, verticalSpread, count, meansOfDeath)
  traces = []
  pellet = 0
  while pellet < count
    traces = traces + [fireLead(context, shooter, start, aimDirection, damage, kick, wbconstants.IMPACT_SHOTGUN, horizontalSpread, verticalSpread, meansOfDeath)]
    pellet = pellet + 1
  end while
  return traces
end function

// Fire rail.
function fireRail(context, shooter, start, aimDirection, damage, kick)
  zero = qt.zeroVec3()
  endPosition = wbvector.multiplyAdd(start, 8192.0, aimDirection)
  traceStart = wbvector.copy(start)
  ignore = shooter
  mask = qc.MASK_SHOT | qc.CONTENTS_SLIME | qc.CONTENTS_LAVA
  water = false
  trace = void
  pass = 0
  keepTracing = true
  while keepTracing and pass < 64
    pass = pass + 1
    trace = context.callbacks.trace(traceStart, zero, zero, endPosition, ignore, mask)
    if (trace.contents & (qc.CONTENTS_SLIME | qc.CONTENTS_LAVA)) != 0 then
      mask = mask & ~(qc.CONTENTS_SLIME | qc.CONTENTS_LAVA)
      water = true
    else
      target = trace.entity
      keepTracing = false
      if target is not void and (target.isMonster or target.isClient) then
        ignore = target
        keepTracing = true
      end if
      if target is not void and target.number != shooter.number and target.combatant is not void and target.combatant.takeDamage then
        wbcore.applyDamage(context, target, shooter, shooter, aimDirection, trace.endPosition, damage, kick, 0, gpconstants.MOD_RAILGUN)
      end if
    end if
    traceStart = wbvector.copy(trace.endPosition)
  end while
  // Rail trails do not transmit a direction. Reuse the effect normal as the
  // multicast anchor so the integration layer can preserve BaseQ2's distinct
  // shooter-origin and water-endpoint PHS routing without widening the ABI.
  wbcore.emitEffect(context, "rail-trail", start, trace.endPosition,
    shooter.origin, 0, 1)
  if water then
    wbcore.emitEffect(context, "rail-trail-water", start, trace.endPosition,
      trace.endPosition, 0, 1)
  end if
  if shooter.isClient then context.callbacks.playerNoise(shooter, trace.endPosition, 2) end if
  return trace
end function

// Fire bullet.
function fire_bullet(context, shooter, start, aimDirection, damage, kick, horizontalSpread, verticalSpread, meansOfDeath)
  return fireBullet(context, shooter, start, aimDirection, damage, kick, horizontalSpread, verticalSpread, meansOfDeath)
end function
// Fire shotgun.
function fire_shotgun(context, shooter, start, aimDirection, damage, kick, horizontalSpread, verticalSpread, count, meansOfDeath)
  return fireShotgun(context, shooter, start, aimDirection, damage, kick, horizontalSpread, verticalSpread, count, meansOfDeath)
end function
// Fire rail.
function fire_rail(context, shooter, start, aimDirection, damage, kick)
  return fireRail(context, shooter, start, aimDirection, damage, kick)
end function
