/*
Copyright (C) 1997-2001 Id Software, Inc.
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later

Deterministic MiniLang port of Quake II 3.19 qcommon/pmove.c. Collision and
contents queries are exclusively dispatched through the Pmove callbacks.
*/
package miniquake2.physics.pmove

import miniquake2.qcommon.constants as qc
import miniquake2.qcommon.types as qt
import miniquake2.qcommon.byteio as qbyteio
import miniquake2.game.constants as gc
import miniquake2.game.types as gt
import miniquake2.physics.constants as phc
import miniquake2.physics.types as pht
import miniquake2.physics.vector as phv

function create(traceCallback, pointContentsCallback)
  return gt.zeroPmove(traceCallback, pointContentsCallback)
end function

function clipVelocity(inputVelocity, normal, overbounce)
  backoff = phv.dot(inputVelocity, normal) * overbounce
  output = qt.Vec3(
    inputVelocity.x - normal.x * backoff,
    inputVelocity.y - normal.y * backoff,
    inputVelocity.z - normal.z * backoff
  )
  if output.x > -phc.STOP_EPSILON and output.x < phc.STOP_EPSILON then output.x = 0.0 end if
  if output.y > -phc.STOP_EPSILON and output.y < phc.STOP_EPSILON then output.y = 0.0 end if
  if output.z > -phc.STOP_EPSILON and output.z < phc.STOP_EPSILON then output.z = 0.0 end if
  return output
end function

function addTouch(pmove, entity)
  if entity is not void and pmove.numTouch < gc.MAXTOUCH then
    pmove.touchEntities[pmove.numTouch] = entity
    pmove.numTouch = pmove.numTouch + 1
  end if
  return true
end function

function stepSlideMoveCore(pmove, localState)
  primalVelocity = phv.copy(localState.velocity)
  planes = array(phc.MAX_CLIP_PLANES)
  numPlanes = 0
  timeLeft = localState.frameTime
  bumpCount = 0

  while bumpCount < phc.MAX_BUMPS
    finish = phv.multiplyAdd(localState.origin, timeLeft, localState.velocity)
    movementTrace = pmove.trace(localState.origin, pmove.mins, pmove.maxs, finish)

    if movementTrace.allSolid then
      localState.velocity.z = 0.0
      return true
    end if

    if movementTrace.fraction > 0.0 then
      localState.origin = phv.copy(movementTrace.endPosition)
      numPlanes = 0
    end if
    if movementTrace.fraction == 1.0 then break end if

    addTouch(pmove, movementTrace.entity)
    timeLeft = timeLeft - timeLeft * movementTrace.fraction

    if numPlanes >= phc.MAX_CLIP_PLANES then
      localState.velocity = qt.zeroVec3()
      break
    end if
    planes[numPlanes] = phv.copy(movementTrace.plane.normal)
    numPlanes = numPlanes + 1

    planeIndex = 0
    acceptedPlane = false
    while planeIndex < numPlanes and acceptedPlane == false
      localState.velocity = clipVelocity(localState.velocity, planes[planeIndex], 1.01)
      comparisonIndex = 0
      while comparisonIndex < numPlanes
        if comparisonIndex != planeIndex and phv.dot(localState.velocity, planes[comparisonIndex]) < 0.0 then break end if
        comparisonIndex = comparisonIndex + 1
      end while
      if comparisonIndex == numPlanes then
        acceptedPlane = true
      else
        planeIndex = planeIndex + 1
      end if
    end while

    if acceptedPlane == false then
      if numPlanes != 2 then
        localState.velocity = qt.zeroVec3()
        break
      end if
      direction = phv.cross(planes[0], planes[1])
      localState.velocity = phv.scale(direction, phv.dot(direction, localState.velocity))
    end if

    if phv.dot(localState.velocity, primalVelocity) <= 0.0 then
      localState.velocity = qt.zeroVec3()
      break
    end if
    bumpCount = bumpCount + 1
  end while

  if pmove.state.time != 0 then localState.velocity = phv.copy(primalVelocity) end if
  return true
end function

function stepSlideMove(pmove, localState)
  startOrigin = phv.copy(localState.origin)
  startVelocity = phv.copy(localState.velocity)

  stepSlideMoveCore(pmove, localState)
  downOrigin = phv.copy(localState.origin)
  downVelocity = phv.copy(localState.velocity)

  elevated = phv.copy(startOrigin)
  elevated.z = elevated.z + phc.STEP_SIZE
  elevatedTrace = pmove.trace(elevated, pmove.mins, pmove.maxs, elevated)
  if elevatedTrace.allSolid then return true end if

  localState.origin = phv.copy(elevated)
  localState.velocity = phv.copy(startVelocity)
  stepSlideMoveCore(pmove, localState)

  lowered = phv.copy(localState.origin)
  lowered.z = lowered.z - phc.STEP_SIZE
  downTrace = pmove.trace(localState.origin, pmove.mins, pmove.maxs, lowered)
  if downTrace.allSolid == false then localState.origin = phv.copy(downTrace.endPosition) end if

  selectedUp = phv.copy(localState.origin)
  downX = downOrigin.x - startOrigin.x
  downY = downOrigin.y - startOrigin.y
  upX = selectedUp.x - startOrigin.x
  upY = selectedUp.y - startOrigin.y
  downDistance = downX * downX + downY * downY
  upDistance = upX * upX + upY * upY

  if downDistance > upDistance or downTrace.plane.normal.z < phc.MIN_STEP_NORMAL then
    localState.origin = downOrigin
    localState.velocity = downVelocity
    return true
  end if

  // Preserve the vertical result of the non-step path, as in the original.
  localState.velocity.z = downVelocity.z
  return true
end function

function friction(pmove, localState)
  speed = phv.length(localState.velocity)
  if speed < 1.0 then
    localState.velocity.x = 0.0
    localState.velocity.y = 0.0
    return true
  end if

  drop = 0.0
  groundFriction = false
  if pmove.groundEntity is not void and localState.groundSurface is not void then
    groundFriction = (localState.groundSurface.flags & qc.SURF_SLICK) == 0
  end if
  if groundFriction or localState.ladder then
    control = speed
    if speed < phc.STOP_SPEED then control = phc.STOP_SPEED end if
    drop = drop + control * phc.FRICTION * localState.frameTime
  end if
  if pmove.waterLevel != 0 and localState.ladder == false then
    drop = drop + speed * phc.WATER_FRICTION * pmove.waterLevel * localState.frameTime
  end if

  newSpeed = speed - drop
  if newSpeed < 0.0 then newSpeed = 0.0 end if
  newSpeed = newSpeed / speed
  localState.velocity = phv.scale(localState.velocity, newSpeed)
  return true
end function

function accelerate(localState, wishDirection, wishSpeed, acceleration)
  currentSpeed = phv.dot(localState.velocity, wishDirection)
  addSpeed = wishSpeed - currentSpeed
  if addSpeed <= 0.0 then return true end if
  accelerationSpeed = acceleration * localState.frameTime * wishSpeed
  if accelerationSpeed > addSpeed then accelerationSpeed = addSpeed end if
  localState.velocity = phv.multiplyAdd(localState.velocity, accelerationSpeed, wishDirection)
  return true
end function

function airAccelerate(localState, wishDirection, wishSpeed, acceleration)
  clampedWishSpeed = wishSpeed
  if clampedWishSpeed > 30.0 then clampedWishSpeed = 30.0 end if
  currentSpeed = phv.dot(localState.velocity, wishDirection)
  addSpeed = clampedWishSpeed - currentSpeed
  if addSpeed <= 0.0 then return true end if
  accelerationSpeed = acceleration * wishSpeed * localState.frameTime
  if accelerationSpeed > addSpeed then accelerationSpeed = addSpeed end if
  localState.velocity = phv.multiplyAdd(localState.velocity, accelerationSpeed, wishDirection)
  return true
end function

function addCurrents(pmove, localState, wishVelocity)
  if localState.ladder and (localState.velocity.z >= -200.0 and localState.velocity.z <= 200.0) then
    if pmove.viewAngles.x <= -15.0 and pmove.command.forwardMove > 0 then
      wishVelocity.z = 200.0
    else if pmove.viewAngles.x >= 15.0 and pmove.command.forwardMove > 0 then
      wishVelocity.z = -200.0
    else if pmove.command.upMove > 0 then
      wishVelocity.z = 200.0
    else if pmove.command.upMove < 0 then
      wishVelocity.z = -200.0
    else
      wishVelocity.z = 0.0
    end if

    if wishVelocity.x < -25.0 then wishVelocity.x = -25.0 end if
    if wishVelocity.x > 25.0 then wishVelocity.x = 25.0 end if
    if wishVelocity.y < -25.0 then wishVelocity.y = -25.0 end if
    if wishVelocity.y > 25.0 then wishVelocity.y = 25.0 end if
  end if

  if (pmove.waterType & qc.MASK_CURRENT) != 0 then
    current = qt.zeroVec3()
    if (pmove.waterType & qc.CONTENTS_CURRENT_0) != 0 then current.x = current.x + 1.0 end if
    if (pmove.waterType & qc.CONTENTS_CURRENT_90) != 0 then current.y = current.y + 1.0 end if
    if (pmove.waterType & qc.CONTENTS_CURRENT_180) != 0 then current.x = current.x - 1.0 end if
    if (pmove.waterType & qc.CONTENTS_CURRENT_270) != 0 then current.y = current.y - 1.0 end if
    if (pmove.waterType & qc.CONTENTS_CURRENT_UP) != 0 then current.z = current.z + 1.0 end if
    if (pmove.waterType & qc.CONTENTS_CURRENT_DOWN) != 0 then current.z = current.z - 1.0 end if
    currentSpeed = phc.WATER_SPEED
    if pmove.waterLevel == 1 and pmove.groundEntity is not void then currentSpeed = currentSpeed / 2.0 end if
    wishVelocity = phv.multiplyAdd(wishVelocity, currentSpeed, current)
  end if

  if pmove.groundEntity is not void then
    conveyor = qt.zeroVec3()
    if (localState.groundContents & qc.CONTENTS_CURRENT_0) != 0 then conveyor.x = conveyor.x + 1.0 end if
    if (localState.groundContents & qc.CONTENTS_CURRENT_90) != 0 then conveyor.y = conveyor.y + 1.0 end if
    if (localState.groundContents & qc.CONTENTS_CURRENT_180) != 0 then conveyor.x = conveyor.x - 1.0 end if
    if (localState.groundContents & qc.CONTENTS_CURRENT_270) != 0 then conveyor.y = conveyor.y - 1.0 end if
    if (localState.groundContents & qc.CONTENTS_CURRENT_UP) != 0 then conveyor.z = conveyor.z + 1.0 end if
    if (localState.groundContents & qc.CONTENTS_CURRENT_DOWN) != 0 then conveyor.z = conveyor.z - 1.0 end if
    wishVelocity = phv.multiplyAdd(wishVelocity, 100.0, conveyor)
  end if
  return wishVelocity
end function

function waterMove(pmove, localState)
  wishVelocity = qt.Vec3(
    localState.forward.x * pmove.command.forwardMove + localState.right.x * pmove.command.sideMove,
    localState.forward.y * pmove.command.forwardMove + localState.right.y * pmove.command.sideMove,
    localState.forward.z * pmove.command.forwardMove + localState.right.z * pmove.command.sideMove
  )
  if pmove.command.forwardMove == 0 and pmove.command.sideMove == 0 and pmove.command.upMove == 0 then
    wishVelocity.z = wishVelocity.z - 60.0
  else
    wishVelocity.z = wishVelocity.z + pmove.command.upMove
  end if

  wishVelocity = addCurrents(pmove, localState, wishVelocity)
  normalization = phv.normalized(wishVelocity)
  wishDirection = normalization[0]
  wishSpeed = normalization[1]
  if wishSpeed > phc.MAX_SPEED then
    wishVelocity = phv.scale(wishVelocity, phc.MAX_SPEED / wishSpeed)
    wishSpeed = phc.MAX_SPEED
  end if
  wishSpeed = wishSpeed * 0.5
  accelerate(localState, wishDirection, wishSpeed, phc.WATER_ACCELERATE)
  stepSlideMove(pmove, localState)
  return true
end function

function airMove(pmove, localState, airAcceleration)
  wishVelocity = qt.Vec3(
    localState.forward.x * pmove.command.forwardMove + localState.right.x * pmove.command.sideMove,
    localState.forward.y * pmove.command.forwardMove + localState.right.y * pmove.command.sideMove,
    0.0
  )
  wishVelocity = addCurrents(pmove, localState, wishVelocity)
  normalization = phv.normalized(wishVelocity)
  wishDirection = normalization[0]
  wishSpeed = normalization[1]

  maximumSpeed = phc.MAX_SPEED
  if (pmove.state.flags & gc.PMF_DUCKED) != 0 then maximumSpeed = phc.DUCK_SPEED end if
  if wishSpeed > maximumSpeed then
    wishVelocity = phv.scale(wishVelocity, maximumSpeed / wishSpeed)
    wishSpeed = maximumSpeed
  end if

  if localState.ladder then
    accelerate(localState, wishDirection, wishSpeed, phc.ACCELERATE)
    if wishVelocity.z == 0.0 then
      if localState.velocity.z > 0.0 then
        localState.velocity.z = localState.velocity.z - pmove.state.gravity * localState.frameTime
        if localState.velocity.z < 0.0 then localState.velocity.z = 0.0 end if
      else
        localState.velocity.z = localState.velocity.z + pmove.state.gravity * localState.frameTime
        if localState.velocity.z > 0.0 then localState.velocity.z = 0.0 end if
      end if
    end if
    stepSlideMove(pmove, localState)
  else if pmove.groundEntity is not void then
    localState.velocity.z = 0.0
    accelerate(localState, wishDirection, wishSpeed, phc.ACCELERATE)
    if pmove.state.gravity > 0 then
      localState.velocity.z = 0.0
    else
      localState.velocity.z = localState.velocity.z - pmove.state.gravity * localState.frameTime
    end if
    if localState.velocity.x != 0.0 or localState.velocity.y != 0.0 then stepSlideMove(pmove, localState) end if
  else
    if airAcceleration != 0.0 then
      // Quake II uses pm_airaccelerate as a switch but pm_accelerate as the
      // acceleration amount passed to PM_AirAccelerate.
      airAccelerate(localState, wishDirection, wishSpeed, phc.ACCELERATE)
    else
      accelerate(localState, wishDirection, wishSpeed, 1.0)
    end if
    localState.velocity.z = localState.velocity.z - pmove.state.gravity * localState.frameTime
    stepSlideMove(pmove, localState)
  end if
  return true
end function

function categorizePosition(pmove, localState)
  samplePoint = qt.Vec3(localState.origin.x, localState.origin.y, localState.origin.z - 0.25)
  if localState.velocity.z > 180.0 then
    pmove.state.flags = pmove.state.flags & ~gc.PMF_ON_GROUND
    pmove.groundEntity = void
  else
    groundTrace = pmove.trace(localState.origin, pmove.mins, pmove.maxs, samplePoint)
    localState.groundPlane = groundTrace.plane
    localState.groundSurface = groundTrace.surface
    localState.groundContents = groundTrace.contents

    if groundTrace.entity is void or (groundTrace.plane.normal.z < 0.7 and groundTrace.startSolid == false) then
      pmove.groundEntity = void
      pmove.state.flags = pmove.state.flags & ~gc.PMF_ON_GROUND
    else
      pmove.groundEntity = groundTrace.entity
      if (pmove.state.flags & gc.PMF_TIME_WATERJUMP) != 0 then
        pmove.state.flags = pmove.state.flags & ~(gc.PMF_TIME_WATERJUMP | gc.PMF_TIME_LAND | gc.PMF_TIME_TELEPORT)
        pmove.state.time = 0
      end if
      if (pmove.state.flags & gc.PMF_ON_GROUND) == 0 then
        pmove.state.flags = pmove.state.flags | gc.PMF_ON_GROUND
        if localState.velocity.z < -200.0 then
          pmove.state.flags = pmove.state.flags | gc.PMF_TIME_LAND
          if localState.velocity.z < -400.0 then pmove.state.time = 25 else pmove.state.time = 18 end if
        end if
      end if
    end if
    addTouch(pmove, groundTrace.entity)
  end if

  pmove.waterLevel = 0
  pmove.waterType = 0
  sample2 = qbyteio.truncInt(pmove.viewHeight - pmove.mins.z)
  sample1 = qbyteio.truncInt(sample2 / 2.0)

  samplePoint.z = localState.origin.z + pmove.mins.z + 1.0
  contents = pmove.pointContents(samplePoint)
  if (contents & qc.MASK_WATER) != 0 then
    pmove.waterType = contents
    pmove.waterLevel = 1
    samplePoint.z = localState.origin.z + pmove.mins.z + sample1
    contents = pmove.pointContents(samplePoint)
    if (contents & qc.MASK_WATER) != 0 then
      pmove.waterLevel = 2
      samplePoint.z = localState.origin.z + pmove.mins.z + sample2
      contents = pmove.pointContents(samplePoint)
      if (contents & qc.MASK_WATER) != 0 then pmove.waterLevel = 3 end if
    end if
  end if
  return true
end function

function checkJump(pmove, localState)
  if (pmove.state.flags & gc.PMF_TIME_LAND) != 0 then return true end if
  if pmove.command.upMove < 10 then
    pmove.state.flags = pmove.state.flags & ~gc.PMF_JUMP_HELD
    return true
  end if
  if (pmove.state.flags & gc.PMF_JUMP_HELD) != 0 then return true end if
  if pmove.state.moveType == gc.PM_DEAD then return true end if

  if pmove.waterLevel >= 2 then
    pmove.groundEntity = void
    if localState.velocity.z <= -300.0 then return true end if
    if pmove.waterType == qc.CONTENTS_WATER then
      localState.velocity.z = 100.0
    else if pmove.waterType == qc.CONTENTS_SLIME then
      localState.velocity.z = 80.0
    else
      localState.velocity.z = 50.0
    end if
    return true
  end if

  if pmove.groundEntity is void then return true end if
  pmove.state.flags = pmove.state.flags | gc.PMF_JUMP_HELD
  pmove.groundEntity = void
  localState.velocity.z = localState.velocity.z + 270.0
  if localState.velocity.z < 270.0 then localState.velocity.z = 270.0 end if
  return true
end function

function checkSpecialMovement(pmove, localState)
  if pmove.state.time != 0 then return true end if
  localState.ladder = false

  flatNormalization = phv.normalized(qt.Vec3(localState.forward.x, localState.forward.y, 0.0))
  flatForward = flatNormalization[0]
  spot = phv.multiplyAdd(localState.origin, 1.0, flatForward)
  ladderTrace = pmove.trace(localState.origin, pmove.mins, pmove.maxs, spot)
  if ladderTrace.fraction < 1.0 and (ladderTrace.contents & qc.CONTENTS_LADDER) != 0 then localState.ladder = true end if

  if pmove.waterLevel != 2 then return true end if
  spot = phv.multiplyAdd(localState.origin, 30.0, flatForward)
  spot.z = spot.z + 4.0
  contents = pmove.pointContents(spot)
  if (contents & qc.CONTENTS_SOLID) == 0 then return true end if
  spot.z = spot.z + 16.0
  contents = pmove.pointContents(spot)
  if contents != 0 then return true end if

  localState.velocity = phv.scale(flatForward, 50.0)
  localState.velocity.z = 350.0
  pmove.state.flags = pmove.state.flags | gc.PMF_TIME_WATERJUMP
  pmove.state.time = 255
  return true
end function

function flyMove(pmove, localState, doClip)
  pmove.viewHeight = 22.0
  speed = phv.length(localState.velocity)
  if speed < 1.0 then
    localState.velocity = qt.zeroVec3()
  else
    frictionAmount = phc.FRICTION * 1.5
    control = speed
    if speed < phc.STOP_SPEED then control = phc.STOP_SPEED end if
    drop = control * frictionAmount * localState.frameTime
    newSpeed = speed - drop
    if newSpeed < 0.0 then newSpeed = 0.0 end if
    localState.velocity = phv.scale(localState.velocity, newSpeed / speed)
  end if

  forwardNormalization = phv.normalized(localState.forward)
  rightNormalization = phv.normalized(localState.right)
  localState.forward = forwardNormalization[0]
  localState.right = rightNormalization[0]
  wishVelocity = qt.Vec3(
    localState.forward.x * pmove.command.forwardMove + localState.right.x * pmove.command.sideMove,
    localState.forward.y * pmove.command.forwardMove + localState.right.y * pmove.command.sideMove,
    localState.forward.z * pmove.command.forwardMove + localState.right.z * pmove.command.sideMove + pmove.command.upMove
  )
  wishNormalization = phv.normalized(wishVelocity)
  wishDirection = wishNormalization[0]
  wishSpeed = wishNormalization[1]
  if wishSpeed > phc.MAX_SPEED then
    wishVelocity = phv.scale(wishVelocity, phc.MAX_SPEED / wishSpeed)
    wishSpeed = phc.MAX_SPEED
  end if

  currentSpeed = phv.dot(localState.velocity, wishDirection)
  addSpeed = wishSpeed - currentSpeed
  if addSpeed <= 0.0 then return true end if
  accelerationSpeed = phc.ACCELERATE * localState.frameTime * wishSpeed
  if accelerationSpeed > addSpeed then accelerationSpeed = addSpeed end if
  localState.velocity = phv.multiplyAdd(localState.velocity, accelerationSpeed, wishDirection)

  finish = phv.multiplyAdd(localState.origin, localState.frameTime, localState.velocity)
  if doClip then
    movementTrace = pmove.trace(localState.origin, pmove.mins, pmove.maxs, finish)
    localState.origin = phv.copy(movementTrace.endPosition)
  else
    localState.origin = finish
  end if
  return true
end function

function checkDuck(pmove, localState)
  pmove.mins.x = -16.0
  pmove.mins.y = -16.0
  pmove.maxs.x = 16.0
  pmove.maxs.y = 16.0

  if pmove.state.moveType == gc.PM_GIB then
    pmove.mins.z = 0.0
    pmove.maxs.z = 16.0
    pmove.viewHeight = 8.0
    return true
  end if

  pmove.mins.z = -24.0
  if pmove.state.moveType == gc.PM_DEAD then
    pmove.state.flags = pmove.state.flags | gc.PMF_DUCKED
  else if pmove.command.upMove < 0 and (pmove.state.flags & gc.PMF_ON_GROUND) != 0 then
    pmove.state.flags = pmove.state.flags | gc.PMF_DUCKED
  else if (pmove.state.flags & gc.PMF_DUCKED) != 0 then
    pmove.maxs.z = 32.0
    standingTrace = pmove.trace(localState.origin, pmove.mins, pmove.maxs, localState.origin)
    if standingTrace.allSolid == false then pmove.state.flags = pmove.state.flags & ~gc.PMF_DUCKED end if
  end if

  if (pmove.state.flags & gc.PMF_DUCKED) != 0 then
    pmove.maxs.z = 4.0
    pmove.viewHeight = -2.0
  else
    pmove.maxs.z = 32.0
    pmove.viewHeight = 22.0
  end if
  return true
end function

function deadMove(pmove, localState)
  if pmove.groundEntity is void then return true end if
  forwardSpeed = phv.length(localState.velocity) - 20.0
  if forwardSpeed <= 0.0 then
    localState.velocity = qt.zeroVec3()
  else
    normalization = phv.normalized(localState.velocity)
    localState.velocity = phv.scale(normalization[0], forwardSpeed)
  end if
  return true
end function

function goodPosition(pmove)
  if pmove.state.moveType == gc.PM_SPECTATOR then return true end if
  origin = qt.Vec3(pmove.state.origin[0] * 0.125, pmove.state.origin[1] * 0.125, pmove.state.origin[2] * 0.125)
  positionTrace = pmove.trace(origin, pmove.mins, pmove.maxs, origin)
  return positionTrace.allSolid == false
end function

function snapPosition(pmove, localState)
  // pmove_state_t stores signed C shorts. Preserve their wrap semantics even
  // though the managed ABI uses general MiniLang integer array elements.
  pmove.state.velocity[0] = signedShort(qbyteio.truncInt(localState.velocity.x * 8.0))
  pmove.state.velocity[1] = signedShort(qbyteio.truncInt(localState.velocity.y * 8.0))
  pmove.state.velocity[2] = signedShort(qbyteio.truncInt(localState.velocity.z * 8.0))

  signs = [0, 0, 0]
  base = [0, 0, 0]
  axis = 0
  while axis < 3
    localComponent = phv.component(localState.origin, axis)
    if localComponent >= 0.0 then signs[axis] = 1 else signs[axis] = -1 end if
    snapped = signedShort(qbyteio.truncInt(localComponent * 8.0))
    pmove.state.origin[axis] = snapped
    base[axis] = snapped
    if snapped * 0.125 == localComponent then signs[axis] = 0 end if
    axis = axis + 1
  end while

  jitterBits = [0, 4, 1, 2, 3, 5, 6, 7]
  combination = 0
  while combination < 8
    bits = jitterBits[combination]
    axis = 0
    while axis < 3
      pmove.state.origin[axis] = base[axis]
      if (bits & (1 << axis)) != 0 then pmove.state.origin[axis] = signedShort(pmove.state.origin[axis] + signs[axis]) end if
      axis = axis + 1
    end while
    if goodPosition(pmove) then return true end if
    combination = combination + 1
  end while

  pmove.state.origin[0] = localState.previousOrigin[0]
  pmove.state.origin[1] = localState.previousOrigin[1]
  pmove.state.origin[2] = localState.previousOrigin[2]
  return false
end function

function initialSnapPosition(pmove, localState)
  base = [signedShort(pmove.state.origin[0]), signedShort(pmove.state.origin[1]), signedShort(pmove.state.origin[2])]
  offsets = [0, -1, 1]
  zIndex = 0
  while zIndex < 3
    pmove.state.origin[2] = signedShort(base[2] + offsets[zIndex])
    yIndex = 0
    while yIndex < 3
      pmove.state.origin[1] = signedShort(base[1] + offsets[yIndex])
      xIndex = 0
      while xIndex < 3
        pmove.state.origin[0] = signedShort(base[0] + offsets[xIndex])
        if goodPosition(pmove) then
          localState.origin = qt.Vec3(pmove.state.origin[0] * 0.125, pmove.state.origin[1] * 0.125, pmove.state.origin[2] * 0.125)
          localState.previousOrigin = [pmove.state.origin[0], pmove.state.origin[1], pmove.state.origin[2]]
          return true
        end if
        xIndex = xIndex + 1
      end while
      yIndex = yIndex + 1
    end while
    zIndex = zIndex + 1
  end while
  return false
end function

function signedShort(value)
  wrapped = value & 65535
  if wrapped >= 32768 then return wrapped - 65536 end if
  return wrapped
end function

function shortToAngle(value)
  return value * (360.0 / 65536.0)
end function

function clampAngles(pmove, localState)
  if (pmove.state.flags & gc.PMF_TIME_TELEPORT) != 0 then
    pmove.viewAngles.x = 0.0
    pmove.viewAngles.y = shortToAngle(signedShort(pmove.command.angles[1] + pmove.state.deltaAngles[1]))
    pmove.viewAngles.z = 0.0
  else
    pmove.viewAngles.x = shortToAngle(signedShort(pmove.command.angles[0] + pmove.state.deltaAngles[0]))
    pmove.viewAngles.y = shortToAngle(signedShort(pmove.command.angles[1] + pmove.state.deltaAngles[1]))
    pmove.viewAngles.z = shortToAngle(signedShort(pmove.command.angles[2] + pmove.state.deltaAngles[2]))
    if pmove.viewAngles.x > 89.0 and pmove.viewAngles.x < 180.0 then
      pmove.viewAngles.x = 89.0
    else if pmove.viewAngles.x < 271.0 and pmove.viewAngles.x >= 180.0 then
      pmove.viewAngles.x = 271.0
    end if
  end if

  vectors = phv.angleVectors(pmove.viewAngles)
  localState.forward = vectors[0]
  localState.right = vectors[1]
  localState.up = vectors[2]
  return true
end function

function moveWithAirAcceleration(pmove, airAcceleration)
  pmove.numTouch = 0
  pmove.viewAngles = qt.zeroVec3()
  pmove.viewHeight = 0.0
  pmove.groundEntity = void
  pmove.waterType = 0
  pmove.waterLevel = 0

  localState = pht.createLocal()
  originX = signedShort(pmove.state.origin[0])
  originY = signedShort(pmove.state.origin[1])
  originZ = signedShort(pmove.state.origin[2])
  velocityX = signedShort(pmove.state.velocity[0])
  velocityY = signedShort(pmove.state.velocity[1])
  velocityZ = signedShort(pmove.state.velocity[2])
  localState.origin = qt.Vec3(originX * 0.125, originY * 0.125, originZ * 0.125)
  localState.velocity = qt.Vec3(velocityX * 0.125, velocityY * 0.125, velocityZ * 0.125)
  localState.previousOrigin = [originX, originY, originZ]
  localState.frameTime = pmove.command.msec * 0.001

  clampAngles(pmove, localState)
  if pmove.state.moveType == gc.PM_SPECTATOR then
    flyMove(pmove, localState, false)
    snapPosition(pmove, localState)
    return pmove
  end if

  if pmove.state.moveType >= gc.PM_DEAD then
    pmove.command.forwardMove = 0
    pmove.command.sideMove = 0
    pmove.command.upMove = 0
  end if
  if pmove.state.moveType == gc.PM_FREEZE then return pmove end if

  checkDuck(pmove, localState)
  if pmove.snapInitial then initialSnapPosition(pmove, localState) end if
  categorizePosition(pmove, localState)
  if pmove.state.moveType == gc.PM_DEAD then deadMove(pmove, localState) end if
  checkSpecialMovement(pmove, localState)

  if pmove.state.time != 0 then
    elapsed = pmove.command.msec >> 3
    if elapsed == 0 then elapsed = 1 end if
    if elapsed >= pmove.state.time then
      pmove.state.flags = pmove.state.flags & ~(gc.PMF_TIME_WATERJUMP | gc.PMF_TIME_LAND | gc.PMF_TIME_TELEPORT)
      pmove.state.time = 0
    else
      pmove.state.time = pmove.state.time - elapsed
    end if
  end if

  if (pmove.state.flags & gc.PMF_TIME_TELEPORT) == 0 then
    if (pmove.state.flags & gc.PMF_TIME_WATERJUMP) != 0 then
      localState.velocity.z = localState.velocity.z - pmove.state.gravity * localState.frameTime
      if localState.velocity.z < 0.0 then
        pmove.state.flags = pmove.state.flags & ~(gc.PMF_TIME_WATERJUMP | gc.PMF_TIME_LAND | gc.PMF_TIME_TELEPORT)
        pmove.state.time = 0
      end if
      stepSlideMove(pmove, localState)
    else
      checkJump(pmove, localState)
      friction(pmove, localState)
      if pmove.waterLevel >= 2 then
        waterMove(pmove, localState)
      else
        movementAngles = phv.copy(pmove.viewAngles)
        if movementAngles.x > 180.0 then movementAngles.x = movementAngles.x - 360.0 end if
        movementAngles.x = movementAngles.x / 3.0
        vectors = phv.angleVectors(movementAngles)
        localState.forward = vectors[0]
        localState.right = vectors[1]
        localState.up = vectors[2]
        airMove(pmove, localState, airAcceleration)
      end if
    end if
  end if

  categorizePosition(pmove, localState)
  snapPosition(pmove, localState)
  return pmove
end function

function move(pmove)
  return moveWithAirAcceleration(pmove, phc.DEFAULT_AIR_ACCELERATE)
end function
