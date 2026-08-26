/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Vec3 producer-boundary regression for MoveInfo and legacy spawn arrays. */
import miniquake2.game.world.core as moverdircore
import miniquake2.game.world.movers as moverdirovers
import miniquake2.game.world.types as moverdiretypes
import miniquake2.game.world.constants as moverdirconstants

function moverDirectionAssert(value, message)
  if value != true then return error(9195, message) end if
  return true
end function

function moverDirectionDone(entity, world)
  entity.count = entity.count + 1
  return true
end function

function main(args)
  moverDirectionWorldHolder = moverdircore.createWorld(moverdircore.defaultCallbacks())
  moverDirectionEntityHolder = moverdircore.spawnEntity(moverDirectionWorldHolder, "func_door")
  // Simulate legacy/parser adapter values at the owned-world boundary.
  moverDirectionEntityHolder.origin = [0.0, 0.0, 0.0]
  moverDirectionEntityHolder.moveDirection = [1.0, 0.0, 0.0]
  moverDirectionEntityHolder.moveInfo.direction = [0.0, 1.0, 0.0]
  moverDirectionEntityHolder.moveInfo.startOrigin = [0.0, 0.0, 0.0]
  moverDirectionEntityHolder.moveInfo.endOrigin = [20.0, 0.0, 0.0]
  moverDirectionEntityHolder.moveInfo.startAngles = [0.0, 0.0, 0.0]
  moverDirectionEntityHolder.moveInfo.endAngles = [0.0, 90.0, 0.0]
  moverDirectionEntityHolder.moveInfo.speed = 10.0
  moverDirectionEntityHolder.moveInfo.accel = 10.0
  moverDirectionEntityHolder.moveInfo.decel = 10.0

  moverdirovers.moveCalc(moverDirectionEntityHolder, [20.0, 0.0, 0.0],
    moverDirectionDone, moverDirectionWorldHolder)
  moverDirectionAssert(typeof(moverDirectionEntityHolder.origin) == "struct", "moveCalc did not convert origin")
  moverDirectionAssert(typeof(moverDirectionEntityHolder.moveInfo.direction) == "struct", "moveCalc did not own direction as Vec3")
  moverDirectionAssert(moverDirectionEntityHolder.moveInfo.direction.x == 1.0 and
    moverDirectionEntityHolder.moveInfo.direction.y == 0.0, "moveCalc direction differs")
  moverdircore.advance(moverDirectionWorldHolder, 3.0)
  moverDirectionAssert(moverDirectionEntityHolder.origin.x == 20.0 and moverDirectionEntityHolder.count == 1,
    "converted linear mover did not complete")

  moverDirectionEntityHolder.moveInfo.direction = [0.0, -1.0, 0.0]
  moverDirectionEntityHolder.moveDirection = [0.0, 0.0, 1.0]
  moverDirectionEntityHolder.nextThink = 1.0
  moverDirectionEntityHolder.moveInfo.state = moverdirconstants.STATE_UP
  moverdirovers.restoreMoverState(moverDirectionEntityHolder, moverDirectionWorldHolder)
  moverDirectionAssert(typeof(moverDirectionEntityHolder.moveInfo.direction) == "struct" and
    moverDirectionEntityHolder.moveInfo.direction.y == -1.0, "restore did not convert MoveInfo.direction")
  moverDirectionAssert(typeof(moverDirectionEntityHolder.moveDirection) == "struct" and
    moverDirectionEntityHolder.moveDirection.z == 1.0, "restore did not convert moveDirection")

  moverDirectionFreshHolder = moverdiretypes.zeroMoveInfo()
  moverDirectionAssert(typeof(moverDirectionFreshHolder.direction) == "struct" and
    typeof(moverDirectionFreshHolder.startOrigin) == "struct" and
    typeof(moverDirectionFreshHolder.endAngles) == "struct", "zeroMoveInfo vector ownership")
  print("gameplay_world_mover_direction_tests: PASS")
  return 0
end function
