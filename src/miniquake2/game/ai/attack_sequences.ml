/* Deterministic Quake II 3.19 attack-frame schedules for stock monsters. */
package miniquake2.game.ai.attack_sequences

import miniquake2.game.ai.combat_profiles as attackprofiles

const FRAME_TIME = 0.1

struct MonsterAttackPlan
  className
  name
  attackKind
  damage
  knockback
  speed
  splashRadius
  maximumRange
  count
  frameOffsets
  muzzleFlashes
  durationFrames
  cooldown
end struct

function attackPlan(className, name, attackKind, damage, knockback, speed, splashRadius,
    maximumRange, count, frameOffsets, muzzleFlashes, durationFrames)
  return MonsterAttackPlan(className, name, attackKind, damage, knockback, speed,
    splashRadius, maximumRange, count, frameOffsets, muzzleFlashes, durationFrames,
    durationFrames * FRAME_TIME)
end function

function deterministicValue(actorNumber, attackCount, salt, modulus)
  if modulus <= 0 then return 0 end if
  value = actorNumber * 97 + attackCount * 53 + salt * 31 + 17
  if value < 0 then value = -value end if
  return value % modulus
end function

function appendRepeatedFrames(frameOffsets, muzzleFlashes, firstFrame, cycles, flashes)
  cycle = 0
  while cycle < cycles
    flashIndex = 0
    while flashIndex < len(flashes)
      frameOffsets = frameOffsets + [firstFrame + cycle]
      muzzleFlashes = muzzleFlashes + [flashes[flashIndex]]
      flashIndex = flashIndex + 1
    end while
    cycle = cycle + 1
  end while
  return [frameOffsets, muzzleFlashes]
end function

function appendSequentialFrames(frameOffsets, muzzleFlashes, firstFrame, cycles, firstFlash)
  cycle = 0
  while cycle < cycles
    frameOffsets = frameOffsets + [firstFrame + cycle]
    muzzleFlashes = muzzleFlashes + [firstFlash + cycle]
    cycle = cycle + 1
  end while
  return [frameOffsets, muzzleFlashes]
end function

function repeatedCycleCount(actorNumber, attackCount, salt, chancePercent, maximumCycles)
  cycles = 1
  while cycles < maximumCycles and deterministicValue(actorNumber, attackCount, salt + cycles, 100) < chancePercent
    cycles = cycles + 1
  end while
  return cycles
end function

function infantryPlan(actorNumber, attackCount)
  // m_infantry.c holds FRAME_attak111 for (rand() & 15) + 10 frames.
  shotCount = 10 + deterministicValue(actorNumber, attackCount, 11, 16)
  built = appendRepeatedFrames([], [], 10, shotCount, [26])
  return attackPlan("monster_infantry", "infantry-machinegun", "bullet", 3, 4,
    0.0, 0.0, 2048.0, 1, built[0], built[1], 15 + shotCount - 1)
end function

function gunnerChainPlan(actorNumber, attackCount)
  // Seven wind-up frames, eight consecutive muzzle positions, then a 50% refire.
  cycles = repeatedCycleCount(actorNumber, attackCount, 29, 50, 8)
  offsets = []
  flashes = []
  cycle = 0
  while cycle < cycles
    built = appendSequentialFrames(offsets, flashes, 7 + cycle * 8, 8, 45)
    offsets = built[0]
    flashes = built[1]
    cycle = cycle + 1
  end while
  return attackPlan("monster_gunner", "gunner-chain", "bullet", 3, 4,
    0.0, 0.0, 2048.0, 1, offsets, flashes, 22 + (cycles - 1) * 8)
end function

function gunnerGrenadePlan()
  return attackPlan("monster_gunner", "gunner-grenade", "grenade", 50, 0,
    600.0, 0.0, 2048.0, 1, [4, 7, 10, 13], [53, 54, 55, 56], 21)
end function

function soldierPlan(className, actorNumber, attackCount)
  secondAttack = deterministicValue(actorNumber, attackCount, 41, 2) == 1
  if className == "monster_soldier_light" then
    if secondAttack then
      return attackPlan(className, "soldier-light-attack2", "blaster", 5, 0,
        600.0, 0.0, 2048.0, 1, [4], [40], 18)
    end if
    return attackPlan(className, "soldier-light-attack1", "blaster", 5, 0,
      600.0, 0.0, 2048.0, 1, [2], [39], 12)
  end if
  if className == "monster_soldier" then
    if secondAttack then
      return attackPlan(className, "soldier-shotgun-attack2", "shotgun", 2, 1,
        0.0, 0.0, 2048.0, 12, [4], [42], 18)
    end if
    return attackPlan(className, "soldier-shotgun-attack1", "shotgun", 2, 1,
      0.0, 0.0, 2048.0, 12, [2], [41], 12)
  end if
  // m_soldier.c attack4 holds FRAME_attak403 for 3..10 shots and uses
  // machinegun_flash[3] (MZ2_SOLDIER_MACHINEGUN_4 == 88).
  shotCount = 3 + deterministicValue(actorNumber, attackCount, 43, 8)
  built = appendRepeatedFrames([], [], 2, shotCount, [88])
  return attackPlan(className, "soldier-ss-machinegun", "bullet", 2, 4,
    0.0, 0.0, 2048.0, 1, built[0], built[1], 6 + shotCount - 1)
end function

function jorgPlan(actorNumber, attackCount)
  // Six frames fire left and right barrels together; visible targets refire at 90%.
  cycles = repeatedCycleCount(actorNumber, attackCount, 59, 90, 8)
  offsets = []
  flashes = []
  cycle = 0
  while cycle < cycles
    built = appendRepeatedFrames(offsets, flashes, 8 + cycle * 6, 6, [120, 126])
    offsets = built[0]
    flashes = built[1]
    cycle = cycle + 1
  end while
  return attackPlan("monster_jorg", "jorg-machineguns", "bullet", 6, 4,
    0.0, 0.0, 2048.0, 1, offsets, flashes, 18 + (cycles - 1) * 6)
end function

function jorgBfgPlan()
  return attackPlan("monster_jorg", "jorg-bfg", "bfg", 50, 100,
    300.0, 200.0, 2048.0, 1, [6], [132], 13)
end function

function boss2MachinegunPlan(actorNumber, attackCount)
  cycles = repeatedCycleCount(actorNumber, attackCount, 71, 70, 8)
  offsets = []
  flashes = []
  cycle = 0
  while cycle < cycles
    built = appendRepeatedFrames(offsets, flashes, 9 + cycle * 6, 5, [73, 133])
    offsets = built[0]
    flashes = built[1]
    cycle = cycle + 1
  end while
  return attackPlan("monster_boss2", "boss2-machineguns", "bullet", 6, 4,
    0.0, 0.0, 2048.0, 1, offsets, flashes, 19 + (cycles - 1) * 6)
end function

function boss2RocketPlan()
  return attackPlan("monster_boss2", "boss2-rockets", "rocket", 50, 0,
    500.0, 70.0, 2048.0, 1, [12, 12, 12, 12], [78, 79, 80, 81], 21)
end function

function makronBfgPlan()
  return attackPlan("monster_makron", "makron-bfg", "bfg", 50, 100,
    300.0, 300.0, 2048.0, 1, [3], [101], 8)
end function

function makronHyperblasterPlan()
  built = appendRepeatedFrames([], [], 4, 17, [102])
  return attackPlan("monster_makron", "makron-hyperblaster", "blaster", 15, 0,
    1000.0, 0.0, 2048.0, 1, built[0], built[1], 26)
end function

function makronRailPlan()
  return attackPlan("monster_makron", "makron-rail", "rail", 50, 100,
    0.0, 0.0, 2048.0, 1, [8], [119], 16)
end function

function fallbackPlan(className)
  profile = attackprofiles.stockProfile(className)
  if profile is void then return void end if
  flashes = []
  if profile.muzzleFlash != 0 then flashes = [profile.muzzleFlash]
  else flashes = [0] end if
  plan = attackPlan(className, className + "-single", profile.attackKind,
    profile.damage, profile.knockback, profile.speed, profile.splashRadius,
    profile.maximumRange, profile.count, [0], flashes, 1)
  plan.cooldown = profile.cooldown
  return plan
end function

function selectPlan(className, actorNumber, attackCount, distance, skill)
  if className == "monster_infantry" then return infantryPlan(actorNumber, attackCount) end if
  if className == "monster_gunner" then
    if distance > 80.0 and deterministicValue(actorNumber, attackCount, 31, 2) == 0 then return gunnerGrenadePlan() end if
    return gunnerChainPlan(actorNumber, attackCount)
  end if
  if className == "monster_soldier_light" or className == "monster_soldier" or className == "monster_soldier_ss" then
    return soldierPlan(className, actorNumber, attackCount)
  end if
  if className == "monster_jorg" and deterministicValue(actorNumber, attackCount, 61, 100) < 75 then
    return jorgPlan(actorNumber, attackCount)
  end if
  if className == "monster_jorg" then return jorgBfgPlan() end if
  if className == "monster_boss2" then
    if distance <= 125.0 or deterministicValue(actorNumber, attackCount, 73, 100) < 60 then
      return boss2MachinegunPlan(actorNumber, attackCount)
    end if
    return boss2RocketPlan()
  end if
  if className == "monster_makron" then
    makronRoll = deterministicValue(actorNumber, attackCount, 79, 100)
    if makronRoll < 30 then return makronBfgPlan() end if
    if makronRoll < 60 then return makronHyperblasterPlan() end if
    return makronRailPlan()
  end if
  return fallbackPlan(className)
end function

function planByName(className, name, actorNumber, attackCount)
  if name == "infantry-machinegun" then return infantryPlan(actorNumber, attackCount) end if
  if name == "gunner-chain" then return gunnerChainPlan(actorNumber, attackCount) end if
  if name == "gunner-grenade" then return gunnerGrenadePlan() end if
  if name == "soldier-light-attack1" then
    return attackPlan(className, name, "blaster", 5, 0, 600.0, 0.0, 2048.0, 1, [2], [39], 12)
  end if
  if name == "soldier-light-attack2" then
    return attackPlan(className, name, "blaster", 5, 0, 600.0, 0.0, 2048.0, 1, [4], [40], 18)
  end if
  if name == "soldier-shotgun-attack1" then
    return attackPlan(className, name, "shotgun", 2, 1, 0.0, 0.0, 2048.0, 12, [2], [41], 12)
  end if
  if name == "soldier-shotgun-attack2" then
    return attackPlan(className, name, "shotgun", 2, 1, 0.0, 0.0, 2048.0, 12, [4], [42], 18)
  end if
  if name == "soldier-ss-machinegun" then return soldierPlan(className, actorNumber, attackCount) end if
  if name == "jorg-machineguns" then return jorgPlan(actorNumber, attackCount) end if
  if name == "jorg-bfg" then return jorgBfgPlan() end if
  if name == "boss2-machineguns" then return boss2MachinegunPlan(actorNumber, attackCount) end if
  if name == "boss2-rockets" then return boss2RocketPlan() end if
  if name == "makron-bfg" then return makronBfgPlan() end if
  if name == "makron-hyperblaster" then return makronHyperblasterPlan() end if
  if name == "makron-rail" then return makronRailPlan() end if
  fallback = fallbackPlan(className)
  if fallback is not void and fallback.name == name then return fallback end if
  return void
end function

function validatePlan(plan)
  if plan is void or plan.className == "" or plan.name == "" or len(plan.frameOffsets) == 0 or
      len(plan.frameOffsets) != len(plan.muzzleFlashes) or plan.durationFrames <= 0 or plan.cooldown <= 0.0 then
    return error(9650, "invalid monster attack plan")
  end if
  index = 0
  previous = -1
  while index < len(plan.frameOffsets)
    if plan.frameOffsets[index] < previous or plan.frameOffsets[index] >= plan.durationFrames then
      return error(9651, "monster attack plan frame order is invalid")
    end if
    if plan.muzzleFlashes[index] < 0 or plan.muzzleFlashes[index] > 255 then
      return error(9652, "monster attack plan muzzle flash is invalid")
    end if
    previous = plan.frameOffsets[index]
    index = index + 1
  end while
  return true
end function
