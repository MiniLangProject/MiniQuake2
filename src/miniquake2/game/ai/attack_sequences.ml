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

function gladiatorRailPlan()
  return attackPlan("monster_gladiator", "gladiator-rail", "rail", 50, 100,
    0.0, 0.0, 2048.0, 1, [3], [61], 9)
end function

function gladiatorMeleePlan()
  return attackPlan("monster_gladiator", "gladiator-cleaver", "melee", 22, 300,
    0.0, 0.0, 112.0, 1, [6, 13], [0, 0], 17)
end function

function berserkMeleePlan(actorNumber, attackCount)
  if deterministicValue(actorNumber, attackCount, 117, 2) == 0 then
    return attackPlan("monster_berserk", "berserk-spike", "melee", 18, 400,
      0.0, 0.0, 80.0, 1, [3], [0], 8)
  end if
  return attackPlan("monster_berserk", "berserk-club", "melee", 8, 400,
    0.0, 0.0, 80.0, 1, [8], [0], 12)
end function

function infantryMeleePlan()
  return attackPlan("monster_infantry", "infantry-punch", "melee", 7, 50,
    0.0, 0.0, 80.0, 1, [5], [0], 8)
end function

function chickMeleePlan(actorNumber, attackCount)
  cycles = repeatedCycleCount(actorNumber, attackCount, 119, 90, 8)
  offsets = []
  flashes = []
  cycle = 0
  while cycle < cycles
    offsets = offsets + [4 + cycle * 9]
    flashes = flashes + [0]
    cycle = cycle + 1
  end while
  return attackPlan("monster_chick", "chick-slash", "melee", 13, 100,
    0.0, 0.0, 80.0, 1, offsets, flashes, 16 + (cycles - 1) * 9)
end function

function flyerMeleePlan()
  // The C loop continues while melee range is maintained. Bound it to eight
  // complete cycles like the other deterministic refire plans.
  cycles = 8
  offsets = []
  flashes = []
  cycle = 0
  while cycle < cycles
    offsets = offsets + [8 + cycle * 12, 13 + cycle * 12]
    flashes = flashes + [0, 0]
    cycle = cycle + 1
  end while
  return attackPlan("monster_flyer", "flyer-slashes", "melee", 5, 0,
    0.0, 0.0, 80.0, 1, offsets, flashes, 21 + (cycles - 1) * 12)
end function

function brainClawPlan()
  return attackPlan("monster_brain", "brain-claws", "melee", 17, 40,
    0.0, 0.0, 80.0, 1, [7, 11], [0, 0], 18)
end function

function brainTentaclePlan(skill)
  if skill <= 0 then
    return attackPlan("monster_brain", "brain-tentacle", "melee", 12, -600,
      0.0, 0.0, 80.0, 1, [6], [0], 17)
  end if
  // A successful tentacle hit chains directly into the claw move.
  return attackPlan("monster_brain", "brain-tentacle-claws", "melee", 17, 40,
    0.0, 0.0, 80.0, 1, [6, 24, 28], [0, 0, 0], 35)
end function

function floaterWhamPlan()
  return attackPlan("monster_floater", "floater-wham", "melee", 8, -50,
    0.0, 0.0, 80.0, 1, [11], [0], 25)
end function

function floaterZapPlan()
  return attackPlan("monster_floater", "floater-zap", "melee", 8, -10,
    0.0, 0.0, 80.0, 1, [8], [0], 34)
end function

function mutantMeleePlan()
  cycles = 8
  offsets = []
  flashes = []
  cycle = 0
  while cycle < cycles
    offsets = offsets + [2 + cycle * 7, 5 + cycle * 7]
    flashes = flashes + [0, 0]
    cycle = cycle + 1
  end while
  return attackPlan("monster_mutant", "mutant-claws", "melee", 12, 100,
    0.0, 0.0, 80.0, 1, offsets, flashes, cycles * 7)
end function

function parasiteDrainPlan()
  return attackPlan("monster_parasite", "parasite-drain", "drain", 2, 0,
    0.0, 0.0, 256.0, 1, [2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], 18)
end function

function flipperBitePlan()
  return attackPlan("monster_flipper", "flipper-bites", "melee", 5, 0,
    0.0, 0.0, 80.0, 1, [13, 18], [0, 0], 20)
end function

function medicBlasterPlan(actorNumber, attackCount)
  offsets = [8, 11]
  flashes = [60, 60]
  duration = 14
  // medic_continue enters the contiguous attack15..30 hyperblaster move at
  // 95% while the target remains visible.
  if deterministicValue(actorNumber, attackCount, 83, 100) < 95 then
    hyperOffset = 18
    while hyperOffset <= 29
      offsets = offsets + [hyperOffset]
      flashes = flashes + [60]
      hyperOffset = hyperOffset + 1
    end while
    duration = 30
  end if
  return attackPlan("monster_medic", "medic-blaster", "blaster", 2, 0,
    1000.0, 0.0, 2048.0, 1, offsets, flashes, duration)
end function

function chickRocketPlan(actorNumber, attackCount)
  cycles = repeatedCycleCount(actorNumber, attackCount, 89, 60, 8)
  offsets = []
  flashes = []
  cycle = 0
  while cycle < cycles
    offsets = offsets + [13 + cycle * 14]
    flashes = flashes + [57]
    cycle = cycle + 1
  end while
  return attackPlan("monster_chick", "chick-rockets", "rocket", 50, 0,
    500.0, 70.0, 2048.0, 1, offsets, flashes, 32 + (cycles - 1) * 14)
end function

function flyerBlasterPlan()
  return attackPlan("monster_flyer", "flyer-blasters", "blaster", 1, 0,
    1000.0, 0.0, 2048.0, 1,
    [3, 4, 5, 6, 7, 8, 9, 10], [58, 59, 58, 59, 58, 59, 58, 59], 17)
end function

function floaterBlasterPlan()
  return attackPlan("monster_floater", "floater-blasters", "blaster", 1, 0,
    1000.0, 0.0, 2048.0, 1, [3, 4, 5, 6, 7, 8, 9], [82, 82, 82, 82, 82, 82, 82], 14)
end function

function hoverBlasterPlan(actorNumber, attackCount)
  cycles = repeatedCycleCount(actorNumber, attackCount, 97, 60, 8)
  offsets = []
  flashes = []
  cycle = 0
  while cycle < cycles
    offsets = offsets + [3 + cycle * 3, 4 + cycle * 3]
    flashes = flashes + [62, 62]
    cycle = cycle + 1
  end while
  return attackPlan("monster_hover", "hover-blasters", "blaster", 1, 0,
    1000.0, 0.0, 2048.0, 1, offsets, flashes, 8 + (cycles - 1) * 3)
end function

function supertankMachinegunPlan(actorNumber, attackCount)
  cycles = repeatedCycleCount(actorNumber, attackCount, 101, 90, 8)
  offsets = []
  flashes = []
  cycle = 0
  while cycle < cycles
    built = appendSequentialFrames(offsets, flashes, cycle * 6, 6, 64)
    offsets = built[0]
    flashes = built[1]
    cycle = cycle + 1
  end while
  return attackPlan("monster_supertank", "supertank-machinegun", "bullet", 6, 4,
    0.0, 0.0, 2048.0, 1, offsets, flashes, 20 + (cycles - 1) * 6)
end function

function supertankRocketPlan()
  return attackPlan("monster_supertank", "supertank-rockets", "rocket", 50, 0,
    500.0, 70.0, 2048.0, 1, [7, 10, 13], [70, 71, 72], 27)
end function

function tankMachinegunPlan(className)
  built = appendSequentialFrames([], [], 5, 19, 4)
  return attackPlan(className, "tank-machinegun", "bullet", 20, 4,
    0.0, 0.0, 2048.0, 1, built[0], built[1], 29)
end function

function tankBlasterPlan(className, actorNumber, attackCount, skill)
  cycles = 1
  if skill >= 2 then cycles = repeatedCycleCount(actorNumber, attackCount, 107, 60, 8) end if
  planName = "tank-blasters"
  if skill >= 2 then planName = "tank-blasters-hard" end if
  offsets = [9, 12, 15]
  flashes = [1, 2, 3]
  cycle = 1
  while cycle < cycles
    offsets = offsets + [18 + (cycle - 1) * 6, 21 + (cycle - 1) * 6]
    flashes = flashes + [2, 3]
    cycle = cycle + 1
  end while
  return attackPlan(className, planName, "blaster", 30, 0,
    800.0, 0.0, 2048.0, 1, offsets, flashes, 22 + (cycles - 1) * 6)
end function

function tankRocketPlan(className, actorNumber, attackCount, skill)
  cycles = 1
  if skill >= 2 then cycles = repeatedCycleCount(actorNumber, attackCount, 109, 40, 8) end if
  planName = "tank-rockets"
  if skill >= 2 then planName = "tank-rockets-hard" end if
  offsets = []
  flashes = []
  cycle = 0
  while cycle < cycles
    offsets = offsets + [23 + cycle * 9, 26 + cycle * 9, 29 + cycle * 9]
    flashes = flashes + [23, 24, 25]
    cycle = cycle + 1
  end while
  return attackPlan(className, planName, "rocket", 50, 0,
    550.0, 70.0, 2048.0, 1, offsets, flashes, 53 + (cycles - 1) * 9)
end function

function tankPlanWithRoll(className, actorNumber, attackCount, distance, skill, roll)
  if distance <= 125.0 then
    if roll < 0.4 then return tankMachinegunPlan(className) end if
    return tankBlasterPlan(className, actorNumber, attackCount, skill)
  end if
  if distance <= 250.0 then
    if roll < 0.5 then return tankMachinegunPlan(className) end if
    return tankBlasterPlan(className, actorNumber, attackCount, skill)
  end if
  if roll < 0.33 then return tankMachinegunPlan(className) end if
  if roll < 0.66 then return tankRocketPlan(className, actorNumber, attackCount, skill) end if
  return tankBlasterPlan(className, actorNumber, attackCount, skill)
end function

function tankPlan(className, actorNumber, attackCount, distance, skill)
  roll = deterministicValue(actorNumber, attackCount, 113, 100) / 100.0
  return tankPlanWithRoll(className, actorNumber, attackCount, distance, skill, roll)
end function

function soldierPlanVariant(className, actorNumber, attackCount, secondAttack)
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

function soldierPlan(className, actorNumber, attackCount)
  secondAttack = deterministicValue(actorNumber, attackCount, 41, 2) == 1
  return soldierPlanVariant(className, actorNumber, attackCount, secondAttack)
end function

function jorgPlanCycles(cycles)
  if cycles < 1 then cycles = 1 end if
  eventCount = cycles * 12
  offsets = array(eventCount)
  flashes = array(eventCount)
  cycle = 0
  while cycle < cycles
    frame = 0
    while frame < 6
      event = cycle * 12 + frame * 2
      offsets[event] = 8 + cycle * 6 + frame
      offsets[event + 1] = 8 + cycle * 6 + frame
      flashes[event] = 120
      flashes[event + 1] = 126
      frame = frame + 1
    end while
    cycle = cycle + 1
  end while
  return attackPlan("monster_jorg", "jorg-machineguns", "bullet", 6, 4,
    0.0, 0.0, 2048.0, 1, offsets, flashes, 18 + (cycles - 1) * 6)
end function

function jorgPlan(actorNumber, attackCount)
  // Legacy deterministic construction remains available to unit callers;
  // the integrated runtime grows one cycle at each original refire callback.
  return jorgPlanCycles(repeatedCycleCount(actorNumber, attackCount, 59, 90, 8))
end function

function jorgBfgPlan()
  return attackPlan("monster_jorg", "jorg-bfg", "bfg", 50, 100,
    300.0, 200.0, 2048.0, 1, [6], [132], 13)
end function

function boss2MachinegunPlanCycles(cycles)
  if cycles < 1 then cycles = 1 end if
  eventCount = cycles * 10
  offsets = array(eventCount)
  flashes = array(eventCount)
  cycle = 0
  while cycle < cycles
    // m_boss2.c attack10..14 fires both barrels; attack15 is the refire
    // decision callback and does not emit another pair.
    frame = 0
    while frame < 5
      event = cycle * 10 + frame * 2
      offsets[event] = 9 + cycle * 6 + frame
      offsets[event + 1] = 9 + cycle * 6 + frame
      flashes[event] = 73
      flashes[event + 1] = 133
      frame = frame + 1
    end while
    cycle = cycle + 1
  end while
  return attackPlan("monster_boss2", "boss2-machineguns", "bullet", 6, 4,
    0.0, 0.0, 2048.0, 1, offsets, flashes, 19 + (cycles - 1) * 6)
end function

function boss2MachinegunPlan(actorNumber, attackCount)
  return boss2MachinegunPlanCycles(repeatedCycleCount(actorNumber, attackCount, 71, 70, 8))
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
  if className == "monster_berserk" then return berserkMeleePlan(actorNumber, attackCount) end if
  if className == "monster_gladiator" then
    if distance <= 112.0 then return gladiatorMeleePlan() end if
    return gladiatorRailPlan()
  end if
  if className == "monster_infantry" then
    if distance <= 80.0 then return infantryMeleePlan() end if
    return infantryPlan(actorNumber, attackCount)
  end if
  if className == "monster_gunner" then
    if distance > 80.0 and deterministicValue(actorNumber, attackCount, 31, 2) == 0 then return gunnerGrenadePlan() end if
    return gunnerChainPlan(actorNumber, attackCount)
  end if
  if className == "monster_soldier_light" or className == "monster_soldier" or className == "monster_soldier_ss" then
    return soldierPlan(className, actorNumber, attackCount)
  end if
  if className == "monster_tank" or className == "monster_tank_commander" then
    return tankPlan(className, actorNumber, attackCount, distance, skill)
  end if
  if className == "monster_medic" then return medicBlasterPlan(actorNumber, attackCount) end if
  if className == "monster_flipper" then return flipperBitePlan() end if
  if className == "monster_chick" then
    if distance <= 80.0 then return chickMeleePlan(actorNumber, attackCount) end if
    return chickRocketPlan(actorNumber, attackCount)
  end if
  if className == "monster_parasite" then return parasiteDrainPlan() end if
  if className == "monster_flyer" then
    if distance <= 80.0 then return flyerMeleePlan() end if
    return flyerBlasterPlan()
  end if
  if className == "monster_brain" then
    if deterministicValue(actorNumber, attackCount, 127, 2) == 0 then return brainClawPlan() end if
    return brainTentaclePlan(skill)
  end if
  if className == "monster_floater" then
    if distance <= 80.0 then
      if deterministicValue(actorNumber, attackCount, 131, 2) == 0 then return floaterWhamPlan() end if
      return floaterZapPlan()
    end if
    return floaterBlasterPlan()
  end if
  if className == "monster_hover" then return hoverBlasterPlan(actorNumber, attackCount) end if
  if className == "monster_mutant" then return mutantMeleePlan() end if
  if className == "monster_supertank" then
    if distance <= 160.0 or deterministicValue(actorNumber, attackCount, 103, 100) < 30 then
      return supertankMachinegunPlan(actorNumber, attackCount)
    end if
    return supertankRocketPlan()
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

function selectionRandomKind(className, distance)
  // 0 = no selection draw, 1 = random()/unit draw, 2 = raw rand() draw.
  if className == "monster_jorg" then return 1 end if
  if className == "monster_boss2" and distance > 125.0 then return 1 end if
  if className == "monster_makron" then return 1 end if
  return 0
end function

function jorgPlanWithRoll(actorNumber, attackCount, roll)
  if roll <= 0.75 then return jorgPlanCycles(1) end if
  return jorgBfgPlan()
end function

function boss2PlanWithRoll(actorNumber, attackCount, distance, roll)
  if distance <= 125.0 or roll <= 0.6 then return boss2MachinegunPlanCycles(1) end if
  return boss2RocketPlan()
end function

function makronPlanWithRoll(roll)
  if roll <= 0.3 then return makronBfgPlan() end if
  if roll <= 0.6 then return makronHyperblasterPlan() end if
  return makronRailPlan()
end function

function planByName(className, name, actorNumber, attackCount)
  if name == "berserk-spike" or name == "berserk-club" then return berserkMeleePlan(actorNumber, attackCount) end if
  if name == "gladiator-rail" then return gladiatorRailPlan() end if
  if name == "gladiator-cleaver" then return gladiatorMeleePlan() end if
  if name == "infantry-machinegun" then return infantryPlan(actorNumber, attackCount) end if
  if name == "infantry-punch" then return infantryMeleePlan() end if
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
  if name == "tank-machinegun" then return tankMachinegunPlan(className) end if
  if name == "tank-blasters" then return tankBlasterPlan(className, actorNumber, attackCount, 1) end if
  if name == "tank-blasters-hard" then return tankBlasterPlan(className, actorNumber, attackCount, 3) end if
  if name == "tank-rockets" then return tankRocketPlan(className, actorNumber, attackCount, 1) end if
  if name == "tank-rockets-hard" then return tankRocketPlan(className, actorNumber, attackCount, 3) end if
  if name == "medic-blaster" then return medicBlasterPlan(actorNumber, attackCount) end if
  if name == "flipper-bites" then return flipperBitePlan() end if
  if name == "chick-rockets" then return chickRocketPlan(actorNumber, attackCount) end if
  if name == "chick-slash" then return chickMeleePlan(actorNumber, attackCount) end if
  if name == "parasite-drain" then return parasiteDrainPlan() end if
  if name == "flyer-blasters" then return flyerBlasterPlan() end if
  if name == "flyer-slashes" then return flyerMeleePlan() end if
  if name == "brain-claws" then return brainClawPlan() end if
  if name == "brain-tentacle" then return brainTentaclePlan(0) end if
  if name == "brain-tentacle-claws" then return brainTentaclePlan(1) end if
  if name == "floater-blasters" then return floaterBlasterPlan() end if
  if name == "floater-wham" then return floaterWhamPlan() end if
  if name == "floater-zap" then return floaterZapPlan() end if
  if name == "hover-blasters" then return hoverBlasterPlan(actorNumber, attackCount) end if
  if name == "mutant-claws" then return mutantMeleePlan() end if
  if name == "supertank-machinegun" then return supertankMachinegunPlan(actorNumber, attackCount) end if
  if name == "supertank-rockets" then return supertankRocketPlan() end if
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

function planByNameCycles(className, name, actorNumber, attackCount, cycles)
  if name == "jorg-machineguns" and cycles > 0 then return jorgPlanCycles(cycles) end if
  if name == "boss2-machineguns" and cycles > 0 then return boss2MachinegunPlanCycles(cycles) end if
  return planByName(className, name, actorNumber, attackCount)
end function

function eventDamage(plan, eventIndex)
  if plan.name == "parasite-drain" and eventIndex == 0 then return 5 end if
  if plan.name == "brain-tentacle-claws" and eventIndex == 0 then return 12 end if
  return plan.damage
end function

function eventKnockback(plan, eventIndex)
  if plan.name == "brain-tentacle-claws" and eventIndex == 0 then return -600 end if
  return plan.knockback
end function

function eventSourceFlash(plan, eventIndex)
  // Makron's 3.19 hyperblaster projects each bolt from the consecutive
  // MZ2_MAKRON_BLASTER_1..17 offsets but deliberately sends the constant
  // MZ2_MAKRON_BLASTER_1 protocol flash. Preserve that original distinction.
  if plan.name == "makron-hyperblaster" then return 102 + eventIndex end if
  return plan.muzzleFlashes[eventIndex]
end function

function eventUsesHyperblasterEffect(plan, eventIndex)
  if plan.name == "flyer-blasters" then return eventIndex == 0 or eventIndex == 3 or eventIndex == 6 end if
  if plan.name == "floater-blasters" then return eventIndex == 0 or eventIndex == 3 end if
  if plan.name == "hover-blasters" then return eventIndex % 2 == 0 end if
  if plan.name == "medic-blaster" then
    offset = plan.frameOffsets[eventIndex]
    return offset == 18 or offset == 21 or offset == 24 or offset == 27
  end if
  return false
end function

function clampTimelineOffset(plan, timelineOffset)
  if timelineOffset < 0 then return 0 end if
  if timelineOffset >= plan.durationFrames then return plan.durationFrames - 1 end if
  return timelineOffset
end function

function modelFrameAt(plan, timelineOffset)
  // Translate the deterministic event timeline back to the stock MD2 frame.
  // Several C moves hold or loop a short frame range while firing; a simple
  // firstFrame + timelineOffset mapping would visibly run into unrelated
  // animation frames during those refire cycles.
  offset = clampTimelineOffset(plan, timelineOffset)
  name = plan.name
  if name == "berserk-spike" then return 76 + offset end if
  if name == "berserk-club" then return 84 + offset end if
  if name == "gladiator-rail" then return 46 + offset end if
  if name == "gladiator-cleaver" then return 29 + offset end if
  if name == "infantry-punch" then return 199 + offset end if
  if name == "infantry-machinegun" then
    shots = len(plan.frameOffsets)
    if offset <= 10 then return 184 + offset end if
    if offset < 10 + shots then return 194 end if
    return 195 + offset - (10 + shots)
  end if
  if name == "gunner-chain" then
    cycles = len(plan.frameOffsets) / 8
    if offset < 7 then return 137 + offset end if
    if offset < 7 + cycles * 8 then return 144 + ((offset - 7) % 8) end if
    return 152 + offset - (7 + cycles * 8)
  end if
  if name == "gunner-grenade" then return 108 + offset end if
  if name == "soldier-light-attack1" or name == "soldier-shotgun-attack1" then return offset end if
  if name == "soldier-light-attack2" or name == "soldier-shotgun-attack2" then return 12 + offset end if
  if name == "soldier-ss-machinegun" then
    soldierShots = len(plan.frameOffsets)
    if offset < 2 then return 39 + offset end if
    if offset < 2 + soldierShots then return 41 end if
    return 42 + offset - (2 + soldierShots)
  end if
  if name == "tank-machinegun" then return 168 + offset end if
  if name == "tank-blasters" or name == "tank-blasters-hard" then
    tankBlasterCycles = (len(plan.frameOffsets) - 1) / 2
    if offset < 16 then return 55 + offset end if
    if offset < 16 + (tankBlasterCycles - 1) * 6 then return 65 + ((offset - 16) % 6) end if
    return 71 + offset - (16 + (tankBlasterCycles - 1) * 6)
  end if
  if name == "tank-rockets" or name == "tank-rockets-hard" then
    tankRocketCycles = len(plan.frameOffsets) / 3
    if offset < 21 then return 115 + offset end if
    if offset < 21 + tankRocketCycles * 9 then return 136 + ((offset - 21) % 9) end if
    return 145 + offset - (21 + tankRocketCycles * 9)
  end if
  if name == "medic-blaster" then return 177 + offset end if
  if name == "flipper-bites" then return offset end if
  if name == "chick-slash" then
    chickSlashCycles = len(plan.frameOffsets)
    if offset < 3 then return 32 + offset end if
    if offset < 3 + chickSlashCycles * 9 then return 35 + ((offset - 3) % 9) end if
    return 44 + offset - (3 + chickSlashCycles * 9)
  end if
  if name == "chick-rockets" then
    chickCycles = len(plan.frameOffsets)
    if offset < 13 then return offset end if
    if offset < 13 + chickCycles * 14 then return 13 + ((offset - 13) % 14) end if
    return 27 + offset - (13 + chickCycles * 14)
  end if
  if name == "parasite-drain" then return 39 + offset end if
  if name == "flyer-slashes" then
    flyerSlashCycles = len(plan.frameOffsets) / 2
    if offset < 6 then return 58 + offset end if
    if offset < 6 + flyerSlashCycles * 12 then return 64 + ((offset - 6) % 12) end if
    return 76 + offset - (6 + flyerSlashCycles * 12)
  end if
  if name == "flyer-blasters" then return 79 + offset end if
  if name == "brain-claws" then return 53 + offset end if
  if name == "brain-tentacle" then return 71 + offset end if
  if name == "brain-tentacle-claws" then
    if offset < 17 then return 71 + offset end if
    return 53 + offset - 17
  end if
  if name == "floater-wham" then return 45 + offset end if
  if name == "floater-zap" then return 70 + offset end if
  if name == "floater-blasters" then return 31 + offset end if
  if name == "hover-blasters" then
    hoverCycles = len(plan.frameOffsets) / 2
    if offset < 3 then return 197 + offset end if
    if offset < 3 + hoverCycles * 3 then return 200 + ((offset - 3) % 3) end if
    return 203 + offset - (3 + hoverCycles * 3)
  end if
  if name == "mutant-claws" then return 8 + (offset % 7) end if
  if name == "supertank-machinegun" then
    supertankCycles = len(plan.frameOffsets) / 6
    if offset < supertankCycles * 6 then return offset % 6 end if
    return 6 + offset - supertankCycles * 6
  end if
  if name == "supertank-rockets" then return 20 + offset end if
  if name == "jorg-machineguns" then
    jorgCycles = len(plan.frameOffsets) / 12
    if offset < 8 then return offset end if
    if offset < 8 + jorgCycles * 6 then return 8 + ((offset - 8) % 6) end if
    return 14 + offset - (8 + jorgCycles * 6)
  end if
  if name == "jorg-bfg" then return 18 + offset end if
  if name == "boss2-machineguns" then
    bossCycles = len(plan.frameOffsets) / 10
    if offset < 9 then return 70 + offset end if
    if offset < 9 + bossCycles * 6 then return 79 + ((offset - 9) % 6) end if
    return 85 + offset - (9 + bossCycles * 6)
  end if
  if name == "boss2-rockets" then return 89 + offset end if
  if name == "makron-bfg" then return 201 + offset end if
  if name == "makron-hyperblaster" then return 209 + offset end if
  if name == "makron-rail" then return 235 + offset end if

  // The remaining single-event profiles are intentionally one-frame plans
  // until their complete C move tables are ported. Keep their visible firing
  // pose correct instead of falling back to model frame zero.
  if plan.className == "monster_berserk" then return 211 end if
  if plan.className == "monster_gladiator" then return 49 end if
  if plan.className == "monster_tank" or plan.className == "monster_tank_commander" then return 138 end if
  if plan.className == "monster_medic" then return 185 end if
  if plan.className == "monster_flipper" then return 53 end if
  if plan.className == "monster_chick" then return 13 end if
  if plan.className == "monster_parasite" then return 73 end if
  if plan.className == "monster_flyer" then return 82 end if
  if plan.className == "monster_brain" then return 101 end if
  if plan.className == "monster_floater" then return 34 end if
  if plan.className == "monster_hover" then return 200 end if
  if plan.className == "monster_mutant" then return 42 end if
  if plan.className == "monster_supertank" then return 27 end if
  return offset
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
  firstModelFrame = modelFrameAt(plan, 0)
  lastModelFrame = modelFrameAt(plan, plan.durationFrames - 1)
  if typeof(firstModelFrame) != "int" or firstModelFrame < 0 or
      typeof(lastModelFrame) != "int" or lastModelFrame < 0 then
    return error(9653, "invalid monster attack model-frame projection")
  end if
  return true
end function
