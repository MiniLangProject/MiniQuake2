//! Provides miniquake2 game ai attack sequences facilities for this project.

/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Deterministic Quake II 3.19 attack-frame schedules for stock monsters. */
package miniquake2.game.ai.attack_sequences

import miniquake2.game.ai.combat_profiles as attackprofiles
import miniquake2.game.constants as attackconstants

/// Defines the frame time constant used by the miniquake2 game ai attack sequences module.
const FRAME_TIME = 0.1

/// Store monster attack plan data.
struct MonsterAttackPlan
  /// Stores the class name value associated with monster attack plan.
  className
  /// Stores the name value associated with monster attack plan.
  name
  /// Stores the attack kind value associated with monster attack plan.
  attackKind
  /// Stores the damage value associated with monster attack plan.
  damage
  /// Stores the knockback value associated with monster attack plan.
  knockback
  /// Stores the speed value associated with monster attack plan.
  speed
  /// Stores the splash radius value associated with monster attack plan.
  splashRadius
  /// Stores the maximum range value associated with monster attack plan.
  maximumRange
  /// Stores the count value associated with monster attack plan.
  count
  /// Stores the frame offsets value associated with monster attack plan.
  frameOffsets
  /// Stores the muzzle flashes value associated with monster attack plan.
  muzzleFlashes
  /// Stores the duration frames value associated with monster attack plan.
  durationFrames
  /// Stores the cooldown value associated with monster attack plan.
  cooldown
end struct

/// Defines the attack ai none constant used by the miniquake2 game ai attack sequences module.
const ATTACK_AI_NONE = 0
/// Defines the attack ai charge constant used by the miniquake2 game ai attack sequences module.
const ATTACK_AI_CHARGE = 1
/// Defines the attack ai move constant used by the miniquake2 game ai attack sequences module.
const ATTACK_AI_MOVE = 2

/// Exact movement columns from the Quake II 3.19 mframe_t attack tables. Keep
infantryMachinegunDistances = [4.0, -1.0, -1.0, 0.0, -1.0, 1.0, 1.0, 2.0,
  -2.0, -3.0, 1.0, 5.0, -1.0, -2.0, -3.0]
/// Stores module-wide infantry punch distances state for the miniquake2 game ai attack sequences module.
infantryPunchDistances = [3.0, 6.0, 0.0, 8.0, 5.0, 8.0, 6.0, 3.0]
/// Stores module-wide soldier run shoot distances state for the miniquake2 game ai attack sequences module.
soldierRunShootDistances = [10.0, 4.0, 12.0, 11.0, 13.0, 18.0, 15.0,
  14.0, 11.0, 8.0, 11.0, 12.0, 12.0, 17.0]
/// Stores module-wide medic blaster distances state for the miniquake2 game ai attack sequences module.
medicBlasterDistances = [0.0, 5.0, 5.0, 3.0, 2.0, 0.0, 0.0, 0.0,
  0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
/// Stores module-wide medic cable distances state for the miniquake2 game ai attack sequences module.
medicCableDistances = [2.0, 3.0, 5.0, 4.4, 4.7, 5.0, 6.0, 4.0,
  0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, -15.0,
  -1.5, -1.2, -3.0, -2.0, 0.3, 0.7, 1.2, 1.3]
/// Stores module-wide chick rocket start distances state for the miniquake2 game ai attack sequences module.
chickRocketStartDistances = [0.0, 0.0, 0.0, 4.0, 0.0, -3.0, 3.0, 5.0,
  7.0, 0.0, 0.0, 0.0, 0.0]
/// Stores module-wide chick rocket cycle distances state for the miniquake2 game ai attack sequences module.
chickRocketCycleDistances = [19.0, -6.0, -5.0, -2.0, -7.0, 0.0, 1.0,
  10.0, 4.0, 5.0, 6.0, 6.0, 4.0, 3.0]
/// Stores module-wide chick rocket end distances state for the miniquake2 game ai attack sequences module.
chickRocketEndDistances = [-3.0, 0.0, -6.0, -4.0, -2.0]
/// Stores module-wide chick slash start distances state for the miniquake2 game ai attack sequences module.
chickSlashStartDistances = [1.0, 8.0, 3.0]
/// Stores module-wide chick slash cycle distances state for the miniquake2 game ai attack sequences module.
chickSlashCycleDistances = [1.0, 7.0, -7.0, 1.0, -1.0, 1.0, 0.0, 1.0, -2.0]
/// Stores module-wide chick slash end distances state for the miniquake2 game ai attack sequences module.
chickSlashEndDistances = [-6.0, -1.0, -6.0, 0.0]
/// Stores module-wide flyer blaster distances state for the miniquake2 game ai attack sequences module.
flyerBlasterDistances = [0.0, 0.0, 0.0, -10.0, -10.0, -10.0, -10.0,
  -10.0, -10.0, -10.0, -10.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
/// Stores module-wide brain claw distances state for the miniquake2 game ai attack sequences module.
brainClawDistances = [8.0, 3.0, 5.0, 0.0, -3.0, 0.0, -5.0, -7.0,
  0.0, 6.0, 1.0, 2.0, -3.0, 6.0, -1.0, -3.0, 2.0, -11.0]
/// Stores module-wide brain tentacle distances state for the miniquake2 game ai attack sequences module.
brainTentacleDistances = [5.0, -4.0, -4.0, -3.0, 0.0, 0.0, 13.0, 0.0,
  2.0, 0.0, -9.0, 0.0, 4.0, 3.0, 2.0, -3.0, -6.0]
/// Stores module-wide hover start distances state for the miniquake2 game ai attack sequences module.
hoverStartDistances = [1.0, 1.0, 1.0]
/// Stores module-wide hover cycle distances state for the miniquake2 game ai attack sequences module.
hoverCycleDistances = [-10.0, -10.0, 0.0]
/// Stores module-wide hover end distances state for the miniquake2 game ai attack sequences module.
hoverEndDistances = [1.0, 1.0]
/// Stores module-wide mutant jump distances state for the miniquake2 game ai attack sequences module.
mutantJumpDistances = [0.0, 17.0, 15.0, 15.0, 15.0, 0.0, 3.0, 0.0]
/// Stores module-wide parasite drain distances state for the miniquake2 game ai attack sequences module.
parasiteDrainDistances = [0.0, 0.0, 15.0, 0.0, 0.0, 0.0, 0.0, -2.0,
  -2.0, -3.0, -2.0, 0.0, -1.0, 0.0, -2.0, -2.0, -3.0, 0.0]
/// Stores module-wide tank blaster distances state for the miniquake2 game ai attack sequences module.
tankBlasterDistances = [0.0, 0.0, 0.0, 0.0, -1.0, -2.0, -1.0, -1.0,
  0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
/// Stores module-wide tank blaster post distances state for the miniquake2 game ai attack sequences module.
tankBlasterPostDistances = [0.0, 0.0, 2.0, 3.0, 2.0, -2.0]
/// Stores module-wide tank rocket pre distances state for the miniquake2 game ai attack sequences module.
tankRocketPreDistances = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
  0.0, 0.0, 0.0, 1.0, 2.0, 7.0, 7.0, 7.0, 0.0, 0.0, 0.0, 0.0, -3.0]
/// Stores module-wide tank rocket cycle distances state for the miniquake2 game ai attack sequences module.
tankRocketCycleDistances = [-3.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, -1.0]
/// Stores module-wide tank rocket post distances state for the miniquake2 game ai attack sequences module.
tankRocketPostDistances = [0.0, -1.0, -1.0, 0.0, 2.0, 3.0, 4.0, 2.0,
  0.0, 0.0, 0.0, -9.0, -8.0, -7.0, -1.0, -1.0, 0.0, 0.0, 0.0,
  0.0, 0.0, 0.0, 0.0]

/// Run bounded offset.
/// @param plan plan value consumed by this operation.
/// @param timelineOffset timelineOffset value consumed by this operation.
function boundedAttackOffset(plan, timelineOffset)
  if timelineOffset < 0 then return 0 end if
  if timelineOffset >= plan.durationFrames then return plan.durationFrames - 1 end if
  return timelineOffset
end function

/// Return the movement distance for the requested position.
/// @param plan plan value consumed by this operation.
/// @param timelineOffset timelineOffset value consumed by this operation.
function movementDistanceAt(plan, timelineOffset)
  // Keep movement distance at phases explicit: validate inputs, update owned state, then publish the result.
  offset = boundedAttackOffset(plan, timelineOffset)
  name = plan.name
  if name == "misc_actor-single" then
    shots = len(plan.frameOffsets)
    if offset < shots then return -2.0 end if
    tail = offset - shots
    if tail == 0 then return -2.0 end if
    if tail == 1 then return 3.0 end if
    return 2.0
  end if
  if name == "infantry-machinegun" then
    shots = len(plan.frameOffsets)
    if offset <= 10 then return infantryMachinegunDistances[offset] end if
    if offset < 10 + shots then return 0.0 end if
    return infantryMachinegunDistances[11 + offset - (10 + shots)]
  end if
  if name == "infantry-punch" then return infantryPunchDistances[offset] end if
  if name == "soldier-run-shoot" then
    if offset < 14 then return soldierRunShootDistances[offset] end if
    return soldierRunShootDistances[2 + ((offset - 14) % 12)]
  end if
  if name == "medic-blaster" and offset < len(medicBlasterDistances) then
    return medicBlasterDistances[offset]
  end if
  if name == "medic-cable" then return medicCableDistances[offset] end if
  if name == "chick-rockets" then
    if offset < 13 then return chickRocketStartDistances[offset] end if
    cycles = len(plan.frameOffsets)
    cycleEnd = 13 + cycles * 14
    if offset < cycleEnd then return chickRocketCycleDistances[(offset - 13) % 14] end if
    return chickRocketEndDistances[offset - cycleEnd]
  end if
  if name == "chick-slash" then
    if offset < 3 then return chickSlashStartDistances[offset] end if
    cycles = len(plan.frameOffsets)
    cycleEnd = 3 + cycles * 9
    if offset < cycleEnd then return chickSlashCycleDistances[(offset - 3) % 9] end if
    return chickSlashEndDistances[offset - cycleEnd]
  end if
  if name == "flyer-blasters" then return flyerBlasterDistances[offset] end if
  if name == "brain-claws" then return brainClawDistances[offset] end if
  if name == "brain-tentacle" then return brainTentacleDistances[offset] end if
  if name == "brain-tentacle-claws" then
    if offset <= 10 then return brainTentacleDistances[offset] end if
    return brainClawDistances[offset - 11]
  end if
  if name == "hover-blasters" then
    if offset < 3 then return hoverStartDistances[offset] end if
    cycles = len(plan.frameOffsets) / 2
    cycleEnd = 3 + cycles * 3
    if offset < cycleEnd then return hoverCycleDistances[(offset - 3) % 3] end if
    return hoverEndDistances[offset - cycleEnd]
  end if
  if name == "mutant-jump" then return mutantJumpDistances[offset] end if
  if name == "parasite-drain" then return parasiteDrainDistances[offset] end if
  if name == "tank-blasters" or name == "tank-blasters-hard" then
    if offset < 16 then return tankBlasterDistances[offset] end if
    cycles = (len(plan.frameOffsets) - 1) / 2
    postStart = 16 + (cycles - 1) * 6
    if offset < postStart then return 0.0 end if
    return tankBlasterPostDistances[offset - postStart]
  end if
  if name == "tank-rockets" or name == "tank-rockets-hard" then
    if offset < 21 then return tankRocketPreDistances[offset] end if
    cycles = len(plan.frameOffsets) / 3
    postStart = 21 + cycles * 9
    if offset < postStart then return tankRocketCycleDistances[(offset - 21) % 9] end if
    return tankRocketPostDistances[offset - postStart]
  end if
  if name == "boss2-machineguns" then return 1.0 end if
  if name == "boss2-rockets" then
    if offset == 12 then return -20.0 end if
    return 1.0
  end if
  return 0.0
end function

/// Return the movement ai for the requested position.
/// @param plan plan value consumed by this operation.
/// @param timelineOffset timelineOffset value consumed by this operation.
function movementAiAt(plan, timelineOffset)
  offset = boundedAttackOffset(plan, timelineOffset)
  name = plan.name
  if name == "medic-cable" then
    if offset >= 4 and offset <= 8 then return ATTACK_AI_CHARGE end if
    return ATTACK_AI_MOVE
  end if
  if name == "tank-machinegun" and offset >= 5 and offset <= 23 then return ATTACK_AI_NONE end if
  if name == "tank-blasters" or name == "tank-blasters-hard" then
    cycles = (len(plan.frameOffsets) - 1) / 2
    if offset >= 16 + (cycles - 1) * 6 then return ATTACK_AI_MOVE end if
  end if
  if name == "supertank-machinegun" then
    cycles = len(plan.frameOffsets) / 6
    if offset >= cycles * 6 then return ATTACK_AI_MOVE end if
  end if
  if name == "supertank-rockets" and offset >= 8 then return ATTACK_AI_MOVE end if
  if name == "jorg-machineguns" then
    cycles = len(plan.frameOffsets) / 12
    if offset >= 8 + cycles * 6 then return ATTACK_AI_MOVE end if
  end if
  if name == "jorg-bfg" and offset >= 7 then return ATTACK_AI_MOVE end if
  if name == "makron-bfg" and offset >= 4 then return ATTACK_AI_MOVE end if
  if name == "makron-hyperblaster" and offset >= 4 then return ATTACK_AI_MOVE end if
  if name == "makron-rail" and offset >= 8 then return ATTACK_AI_MOVE end if
  if name == "boss2-rockets" and offset == 12 then return ATTACK_AI_MOVE end if
  return ATTACK_AI_CHARGE
end function

/// Return the frame sound for the requested position.
/// @param plan plan value consumed by this operation.
/// @param timelineOffset timelineOffset value consumed by this operation.
function frameSoundAt(plan, timelineOffset)
  // Keep frame sound at phases explicit: validate inputs, update owned state, then publish the result.
  offset = boundedAttackOffset(plan, timelineOffset)
  name = plan.name
  if name == "berserk-spike" and offset == 2 then return "berserk/attack.wav" end if
  if name == "berserk-club" and offset == 4 then return "berserk/attack.wav" end if
  if name == "gladiator-cleaver" and (offset == 4 or offset == 10) then return "gladiator/melee1.wav" end if
  if name == "gunner-chain" and offset == 0 then return "gunner/gunatck1.wav" end if
  if name == "infantry-machinegun" and offset == 3 then return "infantry/infatck3.wav" end if
  if name == "infantry-punch" and offset == 2 then return "infantry/infatck2.wav" end if
  if name == "soldier-shotgun-attack1" and offset >= 7 and ((offset - 7) % 8) == 0 then
    return "infantry/infatck3.wav"
  end if
  if name == "soldier-shotgun-attack2" and offset >= 12 and ((offset - 12) % 12) == 0 then
    return "infantry/infatck3.wav"
  end if
  if name == "chick-rockets" then
    if offset == 0 then return "chick/chkatck1.wav" end if
    cycles = len(plan.frameOffsets)
    if offset >= 13 and offset < 13 + cycles * 14 and ((offset - 13) % 14) == 7 then
      return "chick/chkatck5.wav"
    end if
  end if
  if name == "flipper-bites" and offset == 0 then return "flipper/flpatck1.wav" end if
  if name == "flyer-slashes" and offset == 0 then return "flyer/flyatck1.wav" end if
  if name == "brain-claws" then
    if offset == 4 then return "brain/melee1.wav" end if
    if offset == 9 then return "brain/melee2.wav" end if
  end if
  if name == "brain-tentacle" and offset == 4 then return "brain/brnatck1.wav" end if
  if name == "brain-tentacle-claws" then
    if offset == 4 then return "brain/brnatck1.wav" end if
    if offset == 15 then return "brain/melee1.wav" end if
    if offset == 20 then return "brain/melee2.wav" end if
  end if
  if name == "parasite-drain" then
    if offset == 0 then return "parasite/paratck1.wav" end if
    if offset == 13 then return "parasite/paratck4.wav" end if
  end if
  if name == "tank-blasters" or name == "tank-blasters-hard" then
    cycles = (len(plan.frameOffsets) - 1) / 2
    if offset == 21 + (cycles - 1) * 6 then return "tank/step.wav" end if
  end if
  if name == "tank-rockets" or name == "tank-rockets-hard" then
    cycles = len(plan.frameOffsets) / 3
    if offset == 15 or offset == 21 + cycles * 9 + 15 then return "tank/step.wav" end if
  end if
  if name == "makron-rail" and offset == 0 then return "makron/rail_up.wav" end if
  return ""
end function

/// Return the frame sound channel for the requested position.
/// @param plan plan value consumed by this operation.
/// @param timelineOffset timelineOffset value consumed by this operation.
function frameSoundChannelAt(plan, timelineOffset)
  soundName = frameSoundAt(plan, timelineOffset)
  if soundName == "gunner/gunatck1.wav" or soundName == "chick/chkatck1.wav" or
      soundName == "chick/chkatck5.wav" or soundName == "flyer/flyatck1.wav" then
    return attackconstants.CHAN_VOICE
  end if
  if soundName == "brain/melee1.wav" or soundName == "brain/melee2.wav" or
      soundName == "brain/brnatck1.wav" or soundName == "tank/step.wav" then
    return attackconstants.CHAN_BODY
  end if
  return attackconstants.CHAN_WEAPON
end function

/// Return the frame sound attenuation for the requested position.
/// @param plan plan value consumed by this operation.
/// @param timelineOffset timelineOffset value consumed by this operation.
function frameSoundAttenuationAt(plan, timelineOffset)
  if frameSoundAt(plan, timelineOffset) == "gunner/gunatck1.wav" then
    return attackconstants.ATTN_IDLE
  end if
  return attackconstants.ATTN_NORM
end function

/// Run plan.
/// @param className className value consumed by this operation.
/// @param name Name of the affected item.
/// @param attackKind attackKind value consumed by this operation.
/// @param damage damage value consumed by this operation.
/// @param knockback knockback value consumed by this operation.
/// @param speed speed value consumed by this operation.
/// @param splashRadius splashRadius value consumed by this operation.
/// @param maximumRange maximumRange value consumed by this operation.
/// @param count Number of items or units to process.
/// @param frameOffsets frameOffsets value consumed by this operation.
/// @param muzzleFlashes muzzleFlashes value consumed by this operation.
/// @param durationFrames durationFrames value consumed by this operation.
function attackPlan(className, name, attackKind, damage, knockback, speed, splashRadius,
    maximumRange, count, frameOffsets, muzzleFlashes, durationFrames)
  return MonsterAttackPlan(className, name, attackKind, damage, knockback, speed,
    splashRadius, maximumRange, count, frameOffsets, muzzleFlashes, durationFrames,
    durationFrames * FRAME_TIME)
end function

/// Return the actor machinegun plan shots value.
/// @param shotCount Number of shot to process.
function actorMachinegunPlanShots(shotCount)
  if shotCount < 10 then shotCount = 10 end if
  if shotCount > 25 then shotCount = 25 end if
  offsets = array(shotCount)
  flashes = array(shotCount)
  shot = 0
  while shot < shotCount
    // actor_fire holds FRAME_attak01 and is called once per 0.1-second frame.
    offsets[shot] = shot
    flashes[shot] = 63
    shot = shot + 1
  end while
  return attackPlan("misc_actor", "misc_actor-single", "bullet", 3, 4,
    0.0, 0.0, 2048.0, 1, offsets, flashes, shotCount + 3)
end function

/// Return the actor machinegun plan value.
/// @param raw raw value consumed by this operation.
function actorMachinegunPlan(raw)
  return actorMachinegunPlanShots(10 + (raw & 15))
end function

/// Return the deterministic value.
/// @param actorNumber actorNumber value consumed by this operation.
/// @param attackCount Number of attack to process.
/// @param salt salt value consumed by this operation.
/// @param modulus modulus value consumed by this operation.
function deterministicValue(actorNumber, attackCount, salt, modulus)
  if modulus <= 0 then return 0 end if
  value = actorNumber * 97 + attackCount * 53 + salt * 31 + 17
  if value < 0 then value = -value end if
  return value % modulus
end function

/// Return the repeated cycle count.
/// @param actorNumber actorNumber value consumed by this operation.
/// @param attackCount Number of attack to process.
/// @param salt salt value consumed by this operation.
/// @param chancePercent chancePercent value consumed by this operation.
/// @param maximumCycles maximumCycles value consumed by this operation.
function repeatedCycleCount(actorNumber, attackCount, salt, chancePercent, maximumCycles)
  cycles = 1
  while cycles < maximumCycles and deterministicValue(actorNumber, attackCount, salt + cycles, 100) < chancePercent
    cycles = cycles + 1
  end while
  return cycles
end function

/// Return the infantry plan shots value.
/// @param shotCount Number of shot to process.
function infantryPlanShots(shotCount)
  if shotCount < 10 then shotCount = 10 end if
  if shotCount > 25 then shotCount = 25 end if
  offsets = array(shotCount)
  flashes = array(shotCount)
  shot = 0
  while shot < shotCount
    offsets[shot] = 10 + shot
    flashes[shot] = 26
    shot = shot + 1
  end while
  return attackPlan("monster_infantry", "infantry-machinegun", "bullet", 3, 4,
    0.0, 0.0, 2048.0, 1, offsets, flashes, 15 + shotCount - 1)
end function

/// Return the infantry plan value.
/// @param actorNumber actorNumber value consumed by this operation.
/// @param attackCount Number of attack to process.
function infantryPlan(actorNumber, attackCount)
  // Legacy deterministic construction for isolated callers. The integrated
  // runtime consumes rand() at FRAME_attak104 and stores the exact shot count.
  return infantryPlanShots(10 + deterministicValue(actorNumber, attackCount, 11, 16))
end function

/// Return the gunner chain plan cycles value.
/// @param cycles cycles value consumed by this operation.
function gunnerChainPlanCycles(cycles)
  if cycles < 1 then cycles = 1 end if
  offsets = array(cycles * 8)
  flashes = array(cycles * 8)
  cycle = 0
  while cycle < cycles
    frame = 0
    while frame < 8
      index = cycle * 8 + frame
      offsets[index] = 7 + cycle * 8 + frame
      flashes[index] = 45 + frame
      frame = frame + 1
    end while
    cycle = cycle + 1
  end while
  return attackPlan("monster_gunner", "gunner-chain", "bullet", 3, 4,
    0.0, 0.0, 2048.0, 1, offsets, flashes, 22 + (cycles - 1) * 8)
end function

/// Return the gunner chain plan value.
/// @param actorNumber actorNumber value consumed by this operation.
/// @param attackCount Number of attack to process.
function gunnerChainPlan(actorNumber, attackCount)
  return gunnerChainPlanCycles(repeatedCycleCount(actorNumber, attackCount, 29, 50, 8))
end function

/// Return the gunner grenade plan value.
function gunnerGrenadePlan()
  return attackPlan("monster_gunner", "gunner-grenade", "grenade", 50, 0,
    600.0, 0.0, 2048.0, 1, [4, 7, 10, 13], [53, 54, 55, 56], 21)
end function

/// Return the gladiator rail plan value.
function gladiatorRailPlan()
  return attackPlan("monster_gladiator", "gladiator-rail", "rail", 50, 100,
    0.0, 0.0, 2048.0, 1, [3], [61], 9)
end function

/// Return the gladiator melee plan value.
function gladiatorMeleePlan()
  return attackPlan("monster_gladiator", "gladiator-cleaver", "melee", 22, 300,
    0.0, 0.0, 112.0, 1, [6, 13], [0, 0], 17)
end function

/// Return the berserk melee plan value.
/// @param actorNumber actorNumber value consumed by this operation.
/// @param attackCount Number of attack to process.
function berserkMeleePlan(actorNumber, attackCount)
  if deterministicValue(actorNumber, attackCount, 117, 2) == 0 then
    return attackPlan("monster_berserk", "berserk-spike", "melee", 18, 400,
      0.0, 0.0, 80.0, 1, [3], [0], 8)
  end if
  return attackPlan("monster_berserk", "berserk-club", "melee", 8, 400,
    0.0, 0.0, 80.0, 1, [8], [0], 12)
end function

/// Return the infantry melee plan value.
function infantryMeleePlan()
  return attackPlan("monster_infantry", "infantry-punch", "melee", 7, 50,
    0.0, 0.0, 80.0, 1, [5], [0], 8)
end function

/// Return the chick melee plan cycles value.
/// @param cycles cycles value consumed by this operation.
function chickMeleePlanCycles(cycles)
  if cycles < 1 then cycles = 1 end if
  offsets = array(cycles)
  flashes = array(cycles)
  cycle = 0
  while cycle < cycles
    offsets[cycle] = 4 + cycle * 9
    flashes[cycle] = 0
    cycle = cycle + 1
  end while
  return attackPlan("monster_chick", "chick-slash", "melee", 13, 100,
    0.0, 0.0, 80.0, 1, offsets, flashes, 16 + (cycles - 1) * 9)
end function

/// Return the chick melee plan value.
/// @param actorNumber actorNumber value consumed by this operation.
/// @param attackCount Number of attack to process.
function chickMeleePlan(actorNumber, attackCount)
  return chickMeleePlanCycles(repeatedCycleCount(actorNumber, attackCount, 119, 90, 8))
end function

/// Return the flyer melee plan cycles value.
/// @param cycles cycles value consumed by this operation.
function flyerMeleePlanCycles(cycles)
  if cycles < 1 then cycles = 1 end if
  offsets = array(cycles * 2)
  flashes = array(cycles * 2)
  cycle = 0
  while cycle < cycles
    index = cycle * 2
    offsets[index] = 8 + cycle * 12
    offsets[index + 1] = 13 + cycle * 12
    flashes[index] = 0
    flashes[index + 1] = 0
    cycle = cycle + 1
  end while
  return attackPlan("monster_flyer", "flyer-slashes", "melee", 5, 0,
    0.0, 0.0, 80.0, 1, offsets, flashes, 21 + (cycles - 1) * 12)
end function

/// Return the flyer melee plan value.
function flyerMeleePlan()
  return flyerMeleePlanCycles(8)
end function

/// Return the brain claw plan value.
function brainClawPlan()
  return attackPlan("monster_brain", "brain-claws", "melee", 17, 40,
    0.0, 0.0, 80.0, 1, [7, 11], [0, 0], 18)
end function

/// Return the brain tentacle plan value.
/// @param skill skill value consumed by this operation.
function brainTentaclePlan(skill)
  if skill <= 0 then
    return attackPlan("monster_brain", "brain-tentacle", "melee", 12, -600,
      0.0, 0.0, 80.0, 1, [6], [0], 17)
  end if
  // brain_chest_closed changes to attack1 on attack211 only after a successful
  // tentacle hit. The integrated runtime selects this combined plan at that
  // callback; attack101 therefore starts at timeline offset 11.
  return attackPlan("monster_brain", "brain-tentacle-claws", "melee", 17, 40,
    0.0, 0.0, 80.0, 1, [6, 18, 22], [0, 0, 0], 29)
end function

/// Return the floater wham plan value.
function floaterWhamPlan()
  return attackPlan("monster_floater", "floater-wham", "melee", 8, -50,
    0.0, 0.0, 80.0, 1, [11], [0], 25)
end function

/// Return the floater zap plan value.
function floaterZapPlan()
  return attackPlan("monster_floater", "floater-zap", "melee", 8, -10,
    0.0, 0.0, 80.0, 1, [8], [0], 34)
end function

/// Return the mutant melee plan cycles value.
/// @param cycles cycles value consumed by this operation.
function mutantMeleePlanCycles(cycles)
  if cycles < 1 then cycles = 1 end if
  offsets = array(cycles * 2)
  flashes = array(cycles * 2)
  cycle = 0
  while cycle < cycles
    index = cycle * 2
    offsets[index] = 2 + cycle * 7
    offsets[index + 1] = 5 + cycle * 7
    flashes[index] = 0
    flashes[index + 1] = 0
    cycle = cycle + 1
  end while
  return attackPlan("monster_mutant", "mutant-claws", "melee", 12, 100,
    0.0, 0.0, 80.0, 1, offsets, flashes, cycles * 7)
end function

/// Return the mutant melee plan value.
function mutantMeleePlan()
  return mutantMeleePlanCycles(8)
end function

/// Return the mutant jump plan value.
function mutantJumpPlan()
  // attack03 launches; attack05 is a live landing check that holds while the
  // MOVETYPE_STEP body remains airborne.
  return attackPlan("monster_mutant", "mutant-jump", "jump", 40, 40,
    600.0, 0.0, 2048.0, 1, [2, 4], [0, 0], 8)
end function

/// Drain parasite plan.
function parasiteDrainPlan()
  return attackPlan("monster_parasite", "parasite-drain", "drain", 2, 0,
    0.0, 0.0, 256.0, 1, [2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], 18)
end function

/// Return the flipper bite plan value.
function flipperBitePlan()
  return attackPlan("monster_flipper", "flipper-bites", "melee", 5, 0,
    0.0, 0.0, 80.0, 1, [13, 18], [0, 0], 20)
end function

/// Return the medic blaster plan continue value.
/// @param includeHyper includeHyper value consumed by this operation.
function medicBlasterPlanContinue(includeHyper)
  eventCount = 2
  if includeHyper then eventCount = 14 end if
  offsets = array(eventCount)
  flashes = array(eventCount)
  offsets[0] = 8; offsets[1] = 11
  flashes[0] = 60; flashes[1] = 60
  duration = 14
  if includeHyper then
    hyperOffset = 18
    hyperEvent = 2
    while hyperOffset <= 29
      offsets[hyperEvent] = hyperOffset
      flashes[hyperEvent] = 60
      hyperEvent = hyperEvent + 1
      hyperOffset = hyperOffset + 1
    end while
    duration = 30
  end if
  return attackPlan("monster_medic", "medic-blaster", "blaster", 2, 0,
    1000.0, 0.0, 2048.0, 1, offsets, flashes, duration)
end function

/// Return the medic blaster plan value.
/// @param actorNumber actorNumber value consumed by this operation.
/// @param attackCount Number of attack to process.
function medicBlasterPlan(actorNumber, attackCount)
  return medicBlasterPlanContinue(deterministicValue(actorNumber, attackCount, 83, 100) < 95)
end function

/// Return the medic cable plan value.
function medicCablePlan()
  // attack42 launches, attack43..51 update the cable, and attack52 retracts.
  return attackPlan("monster_medic", "medic-cable", "medic-cable", 0, 0,
    0.0, 0.0, 256.0, 1,
    [9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], 28)
end function

/// Return the chick rocket plan cycles value.
/// @param cycles cycles value consumed by this operation.
function chickRocketPlanCycles(cycles)
  if cycles < 1 then cycles = 1 end if
  offsets = array(cycles)
  flashes = array(cycles)
  cycle = 0
  while cycle < cycles
    offsets[cycle] = 13 + cycle * 14
    flashes[cycle] = 57
    cycle = cycle + 1
  end while
  return attackPlan("monster_chick", "chick-rockets", "rocket", 50, 0,
    500.0, 70.0, 2048.0, 1, offsets, flashes, 32 + (cycles - 1) * 14)
end function

/// Return the chick rocket plan value.
/// @param actorNumber actorNumber value consumed by this operation.
/// @param attackCount Number of attack to process.
function chickRocketPlan(actorNumber, attackCount)
  return chickRocketPlanCycles(repeatedCycleCount(actorNumber, attackCount, 89, 60, 8))
end function

/// Return the flyer blaster plan value.
function flyerBlasterPlan()
  return attackPlan("monster_flyer", "flyer-blasters", "blaster", 1, 0,
    1000.0, 0.0, 2048.0, 1,
    [3, 4, 5, 6, 7, 8, 9, 10], [58, 59, 58, 59, 58, 59, 58, 59], 17)
end function

/// Return the floater blaster plan value.
function floaterBlasterPlan()
  return attackPlan("monster_floater", "floater-blasters", "blaster", 1, 0,
    1000.0, 0.0, 2048.0, 1, [3, 4, 5, 6, 7, 8, 9], [82, 82, 82, 82, 82, 82, 82], 14)
end function

/// Return the hover blaster plan cycles value.
/// @param cycles cycles value consumed by this operation.
function hoverBlasterPlanCycles(cycles)
  if cycles < 1 then cycles = 1 end if
  offsets = array(cycles * 2)
  flashes = array(cycles * 2)
  cycle = 0
  while cycle < cycles
    index = cycle * 2
    offsets[index] = 3 + cycle * 3
    offsets[index + 1] = 4 + cycle * 3
    flashes[index] = 62
    flashes[index + 1] = 62
    cycle = cycle + 1
  end while
  return attackPlan("monster_hover", "hover-blasters", "blaster", 1, 0,
    1000.0, 0.0, 2048.0, 1, offsets, flashes, 8 + (cycles - 1) * 3)
end function

/// Return the hover blaster plan value.
/// @param actorNumber actorNumber value consumed by this operation.
/// @param attackCount Number of attack to process.
function hoverBlasterPlan(actorNumber, attackCount)
  return hoverBlasterPlanCycles(repeatedCycleCount(actorNumber, attackCount, 97, 60, 8))
end function

/// Return the supertank machinegun plan cycles value.
/// @param cycles cycles value consumed by this operation.
function supertankMachinegunPlanCycles(cycles)
  if cycles < 1 then cycles = 1 end if
  offsets = array(cycles * 6)
  flashes = array(cycles * 6)
  cycle = 0
  while cycle < cycles
    frame = 0
    while frame < 6
      index = cycle * 6 + frame
      offsets[index] = cycle * 6 + frame
      flashes[index] = 64 + frame
      frame = frame + 1
    end while
    cycle = cycle + 1
  end while
  return attackPlan("monster_supertank", "supertank-machinegun", "bullet", 6, 4,
    0.0, 0.0, 2048.0, 1, offsets, flashes, 20 + (cycles - 1) * 6)
end function

/// Return the supertank machinegun plan value.
/// @param actorNumber actorNumber value consumed by this operation.
/// @param attackCount Number of attack to process.
function supertankMachinegunPlan(actorNumber, attackCount)
  return supertankMachinegunPlanCycles(repeatedCycleCount(actorNumber, attackCount, 101, 90, 8))
end function

/// Return the supertank rocket plan value.
function supertankRocketPlan()
  return attackPlan("monster_supertank", "supertank-rockets", "rocket", 50, 0,
    500.0, 70.0, 2048.0, 1, [7, 10, 13], [70, 71, 72], 27)
end function

/// Return the tank machinegun plan value.
/// @param className className value consumed by this operation.
function tankMachinegunPlan(className)
  offsets = array(19)
  flashes = array(19)
  frame = 0
  while frame < 19
    offsets[frame] = 5 + frame
    flashes[frame] = 4 + frame
    frame = frame + 1
  end while
  return attackPlan(className, "tank-machinegun", "bullet", 20, 4,
    0.0, 0.0, 2048.0, 1, offsets, flashes, 29)
end function

/// Return the tank blaster plan cycles value.
/// @param className className value consumed by this operation.
/// @param cycles cycles value consumed by this operation.
/// @param allowRefire allowRefire value consumed by this operation.
function tankBlasterPlanCycles(className, cycles, allowRefire)
  if cycles < 1 then cycles = 1 end if
  planName = "tank-blasters"
  if allowRefire then planName = "tank-blasters-hard" end if
  eventCount = 3 + (cycles - 1) * 2
  offsets = array(eventCount)
  flashes = array(eventCount)
  offsets[0] = 9; offsets[1] = 12; offsets[2] = 15
  flashes[0] = 1; flashes[1] = 2; flashes[2] = 3
  cycle = 1
  while cycle < cycles
    index = 3 + (cycle - 1) * 2
    offsets[index] = 18 + (cycle - 1) * 6
    offsets[index + 1] = 21 + (cycle - 1) * 6
    flashes[index] = 2
    flashes[index + 1] = 3
    cycle = cycle + 1
  end while
  return attackPlan(className, planName, "blaster", 30, 0,
    800.0, 0.0, 2048.0, 1, offsets, flashes, 22 + (cycles - 1) * 6)
end function

/// Return the tank blaster plan value.
/// @param className className value consumed by this operation.
/// @param actorNumber actorNumber value consumed by this operation.
/// @param attackCount Number of attack to process.
/// @param skill skill value consumed by this operation.
function tankBlasterPlan(className, actorNumber, attackCount, skill)
  cycles = 1
  if skill >= 2 then cycles = repeatedCycleCount(actorNumber, attackCount, 107, 60, 8) end if
  return tankBlasterPlanCycles(className, cycles, skill >= 2)
end function

/// Return the tank rocket plan cycles value.
/// @param className className value consumed by this operation.
/// @param cycles cycles value consumed by this operation.
/// @param allowRefire allowRefire value consumed by this operation.
function tankRocketPlanCycles(className, cycles, allowRefire)
  if cycles < 1 then cycles = 1 end if
  planName = "tank-rockets"
  if allowRefire then planName = "tank-rockets-hard" end if
  offsets = array(cycles * 3)
  flashes = array(cycles * 3)
  cycle = 0
  while cycle < cycles
    index = cycle * 3
    offsets[index] = 23 + cycle * 9
    offsets[index + 1] = 26 + cycle * 9
    offsets[index + 2] = 29 + cycle * 9
    flashes[index] = 23
    flashes[index + 1] = 24
    flashes[index + 2] = 25
    cycle = cycle + 1
  end while
  return attackPlan(className, planName, "rocket", 50, 0,
    550.0, 70.0, 2048.0, 1, offsets, flashes, 53 + (cycles - 1) * 9)
end function

/// Return the tank rocket plan value.
/// @param className className value consumed by this operation.
/// @param actorNumber actorNumber value consumed by this operation.
/// @param attackCount Number of attack to process.
/// @param skill skill value consumed by this operation.
function tankRocketPlan(className, actorNumber, attackCount, skill)
  cycles = 1
  if skill >= 2 then cycles = repeatedCycleCount(actorNumber, attackCount, 109, 40, 8) end if
  return tankRocketPlanCycles(className, cycles, skill >= 2)
end function

/// Return the tank plan with roll value.
/// @param className className value consumed by this operation.
/// @param actorNumber actorNumber value consumed by this operation.
/// @param attackCount Number of attack to process.
/// @param distance distance value consumed by this operation.
/// @param skill skill value consumed by this operation.
/// @param roll roll value consumed by this operation.
function tankPlanWithRoll(className, actorNumber, attackCount, distance, skill, roll)
  if distance <= 125.0 then
    if roll < 0.4 then return tankMachinegunPlan(className) end if
    return tankBlasterPlanCycles(className, 1, skill >= 2)
  end if
  if distance <= 250.0 then
    if roll < 0.5 then return tankMachinegunPlan(className) end if
    return tankBlasterPlanCycles(className, 1, skill >= 2)
  end if
  if roll < 0.33 then return tankMachinegunPlan(className) end if
  if roll < 0.66 then return tankRocketPlanCycles(className, 1, skill >= 2) end if
  return tankBlasterPlanCycles(className, 1, skill >= 2)
end function

/// Return the tank plan value.
/// @param className className value consumed by this operation.
/// @param actorNumber actorNumber value consumed by this operation.
/// @param attackCount Number of attack to process.
/// @param distance distance value consumed by this operation.
/// @param skill skill value consumed by this operation.
function tankPlan(className, actorNumber, attackCount, distance, skill)
  roll = deterministicValue(actorNumber, attackCount, 113, 100) / 100.0
  return tankPlanWithRoll(className, actorNumber, attackCount, distance, skill, roll)
end function

/// Return the soldier light plan cycles value.
/// @param className className value consumed by this operation.
/// @param secondAttack secondAttack value consumed by this operation.
/// @param cycles cycles value consumed by this operation.
function soldierLightPlanCycles(className, secondAttack, cycles)
  if cycles < 1 then cycles = 1 end if
  firstOffset = 2
  duration = 9 + (cycles - 1) * 5
  flash = 39
  name = "soldier-light-attack1"
  if secondAttack then
    firstOffset = 4
    duration = 11 + (cycles - 1) * 5
    flash = 40
    name = "soldier-light-attack2"
  end if
  offsets = array(cycles)
  flashes = array(cycles)
  cycle = 0
  while cycle < cycles
    offsets[cycle] = firstOffset + cycle * 5
    flashes[cycle] = flash
    cycle = cycle + 1
  end while
  return attackPlan(className, name, "blaster", 5, 0,
    600.0, 0.0, 2048.0, 1, offsets, flashes, duration)
end function

/// Return the soldier shotgun plan cycles value.
/// @param className className value consumed by this operation.
/// @param secondAttack secondAttack value consumed by this operation.
/// @param cycles cycles value consumed by this operation.
function soldierShotgunPlanCycles(className, secondAttack, cycles)
  if cycles < 1 then cycles = 1 end if
  firstOffset = 2
  cycleFrames = 8
  duration = 12 + (cycles - 1) * cycleFrames
  flash = 41
  name = "soldier-shotgun-attack1"
  if secondAttack then
    firstOffset = 4
    cycleFrames = 12
    duration = 18 + (cycles - 1) * cycleFrames
    flash = 42
    name = "soldier-shotgun-attack2"
  end if
  offsets = array(cycles)
  flashes = array(cycles)
  cycle = 0
  while cycle < cycles
    offsets[cycle] = firstOffset + cycle * cycleFrames
    flashes[cycle] = flash
    cycle = cycle + 1
  end while
  return attackPlan(className, name, "shotgun", 2, 1,
    0.0, 0.0, 2048.0, 12, offsets, flashes, duration)
end function

/// Return the soldier plan variant value.
/// @param className className value consumed by this operation.
/// @param actorNumber actorNumber value consumed by this operation.
/// @param attackCount Number of attack to process.
/// @param secondAttack secondAttack value consumed by this operation.
function soldierPlanVariant(className, actorNumber, attackCount, secondAttack)
  if className == "monster_soldier_light" then
    return soldierLightPlanCycles(className, secondAttack, 1)
  end if
  if className == "monster_soldier" then
    return soldierShotgunPlanCycles(className, secondAttack, 1)
  end if
  return soldierMachinegunPlanShots(className,
    3 + deterministicValue(actorNumber, attackCount, 43, 8))
end function

/// Return the soldier machinegun plan shots value.
/// @param className className value consumed by this operation.
/// @param shotCount Number of shot to process.
function soldierMachinegunPlanShots(className, shotCount)
  // m_soldier.c attack4 holds FRAME_attak403 for 3..10 shots and uses
  // machinegun_flash[3] (MZ2_SOLDIER_MACHINEGUN_4 == 88).
  if shotCount < 3 then shotCount = 3 end if
  if shotCount > 10 then shotCount = 10 end if
  offsets = array(shotCount)
  flashes = array(shotCount)
  shot = 0
  while shot < shotCount
    offsets[shot] = 2 + shot
    flashes[shot] = 88
    shot = shot + 1
  end while
  return attackPlan(className, "soldier-ss-machinegun", "bullet", 2, 4,
    0.0, 0.0, 2048.0, 1, offsets, flashes, 6 + shotCount - 1)
end function

/// Run soldier flash.
/// @param className className value consumed by this operation.
/// @param flashNumber flashNumber value consumed by this operation.
function soldierAttackFlash(className, flashNumber)
  if flashNumber == 2 then
    if className == "monster_soldier_light" then return 83 end if
    if className == "monster_soldier" then return 84 end if
    return 85
  end if
  if className == "monster_soldier_light" then return 98 end if
  if className == "monster_soldier" then return 99 end if
  return 100
end function

/// Return the soldier special plan value.
/// @param className className value consumed by this operation.
/// @param name Name of the affected item.
/// @param offsets offsets value consumed by this operation.
/// @param flashes flashes value consumed by this operation.
/// @param duration duration value consumed by this operation.
function soldierSpecialPlan(className, name, offsets, flashes, duration)
  if className == "monster_soldier_light" then
    return attackPlan(className, name, "blaster", 5, 0,
      600.0, 0.0, 2048.0, 1, offsets, flashes, duration)
  end if
  if className == "monster_soldier" then
    return attackPlan(className, name, "shotgun", 2, 1,
      0.0, 0.0, 2048.0, 12, offsets, flashes, duration)
  end if
  return attackPlan(className, name, "bullet", 2, 4,
    0.0, 0.0, 2048.0, 1, offsets, flashes, duration)
end function

/// Return the soldier duck shoot plan value.
/// @param className className value consumed by this operation.
function soldierDuckShootPlan(className)
  flash = soldierAttackFlash(className, 2)
  return soldierSpecialPlan(className, "soldier-duck-shoot", [2, 6],
    [flash, flash], 13)
end function

/// Run soldier shoot plan cycles.
/// @param className className value consumed by this operation.
/// @param cycles cycles value consumed by this operation.
function soldierRunShootPlanCycles(className, cycles)
  if cycles < 1 then cycles = 1 end if
  offsets = array(cycles)
  flashes = array(cycles)
  cycle = 0
  flash = soldierAttackFlash(className, 7)
  while cycle < cycles
    offsets[cycle] = 3 + cycle * 12
    flashes[cycle] = flash
    cycle = cycle + 1
  end while
  return soldierSpecialPlan(className, "soldier-run-shoot", offsets, flashes,
    14 + (cycles - 1) * 12)
end function

/// Run soldier dodge uses.
/// @param skill skill value consumed by this operation.
/// @param roll roll value consumed by this operation.
function inline soldierDodgeUsesAttack(skill, roll)
  if skill <= 0 then return false end if
  if skill == 1 then return roll <= 0.33 end if
  return roll <= 0.66
end function

/// Return the soldier plan value.
/// @param className className value consumed by this operation.
/// @param actorNumber actorNumber value consumed by this operation.
/// @param attackCount Number of attack to process.
function soldierPlan(className, actorNumber, attackCount)
  secondAttack = deterministicValue(actorNumber, attackCount, 41, 2) == 1
  return soldierPlanVariant(className, actorNumber, attackCount, secondAttack)
end function

/// Return the jorg plan cycles value.
/// @param cycles cycles value consumed by this operation.
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

/// Return the jorg plan value.
/// @param actorNumber actorNumber value consumed by this operation.
/// @param attackCount Number of attack to process.
function jorgPlan(actorNumber, attackCount)
  // Legacy deterministic construction remains available to unit callers;
  // the integrated runtime grows one cycle at each original refire callback.
  return jorgPlanCycles(repeatedCycleCount(actorNumber, attackCount, 59, 90, 8))
end function

/// Return the jorg bfg plan value.
function jorgBfgPlan()
  return attackPlan("monster_jorg", "jorg-bfg", "bfg", 50, 100,
    300.0, 200.0, 2048.0, 1, [6], [132], 13)
end function

/// Return the boss 2 machinegun plan cycles value.
/// @param cycles cycles value consumed by this operation.
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

/// Return the boss 2 machinegun plan value.
/// @param actorNumber actorNumber value consumed by this operation.
/// @param attackCount Number of attack to process.
function boss2MachinegunPlan(actorNumber, attackCount)
  return boss2MachinegunPlanCycles(repeatedCycleCount(actorNumber, attackCount, 71, 70, 8))
end function

/// Return the boss 2 rocket plan value.
function boss2RocketPlan()
  return attackPlan("monster_boss2", "boss2-rockets", "rocket", 50, 0,
    500.0, 70.0, 2048.0, 1, [12, 12, 12, 12], [78, 79, 80, 81], 21)
end function

/// Return the makron bfg plan value.
function makronBfgPlan()
  return attackPlan("monster_makron", "makron-bfg", "bfg", 50, 100,
    300.0, 300.0, 2048.0, 1, [3], [101], 8)
end function

/// Return the makron hyperblaster plan value.
function makronHyperblasterPlan()
  offsets = array(17)
  flashes = array(17)
  frame = 0
  while frame < 17
    offsets[frame] = 4 + frame
    flashes[frame] = 102
    frame = frame + 1
  end while
  return attackPlan("monster_makron", "makron-hyperblaster", "blaster", 15, 0,
    1000.0, 0.0, 2048.0, 1, offsets, flashes, 26)
end function

/// Return the makron rail plan value.
function makronRailPlan()
  return attackPlan("monster_makron", "makron-rail", "rail", 50, 100,
    0.0, 0.0, 2048.0, 1, [8], [119], 16)
end function

/// Return the fallback plan value.
/// @param className className value consumed by this operation.
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

/// Select plan.
/// @param className className value consumed by this operation.
/// @param actorNumber actorNumber value consumed by this operation.
/// @param attackCount Number of attack to process.
/// @param distance distance value consumed by this operation.
/// @param skill skill value consumed by this operation.
function selectPlan(className, actorNumber, attackCount, distance, skill)
  // Keep select plan phases explicit: validate inputs, update owned state, then publish the result.
  if className == "misc_actor" then
    return actorMachinegunPlan(actorNumber * 97 + attackCount * 53 + 17)
  end if
  if className == "monster_berserk" then return berserkMeleePlan(actorNumber, attackCount) end if
  if className == "monster_gladiator" then
    if distance <= 112.0 then return gladiatorMeleePlan() end if
    return gladiatorRailPlan()
  end if
  if className == "monster_infantry" then
    if distance < 80.0 then return infantryMeleePlan() end if
    return infantryPlan(actorNumber, attackCount)
  end if
  if className == "monster_gunner" then
    if distance >= 80.0 and deterministicValue(actorNumber, attackCount, 31, 2) == 0 then return gunnerGrenadePlan() end if
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
    if distance < 80.0 then return chickMeleePlan(actorNumber, attackCount) end if
    return chickRocketPlan(actorNumber, attackCount)
  end if
  if className == "monster_parasite" then return parasiteDrainPlan() end if
  if className == "monster_flyer" then
    if distance < 80.0 then return flyerMeleePlan() end if
    return flyerBlasterPlan()
  end if
  if className == "monster_brain" then
    if deterministicValue(actorNumber, attackCount, 127, 2) == 0 then return brainClawPlan() end if
    return brainTentaclePlan(0)
  end if
  if className == "monster_floater" then
    if distance < 80.0 then
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

/// Return the selection random kind value.
/// @param className className value consumed by this operation.
/// @param distance distance value consumed by this operation.
function selectionRandomKind(className, distance)
  // 0 = no selection draw, 1 = random()/unit draw, 2 = raw rand() draw.
  if className == "misc_actor" then return 2 end if
  if className == "monster_berserk" then return 2 end if
  if className == "monster_gunner" and distance >= 80.0 then return 1 end if
  if className == "monster_soldier_light" or className == "monster_soldier" then return 1 end if
  if className == "monster_tank" or className == "monster_tank_commander" then return 1 end if
  if className == "monster_brain" then return 1 end if
  if className == "monster_floater" and distance < 80.0 then return 1 end if
  if className == "monster_supertank" and distance > 160.0 then return 1 end if
  if className == "monster_jorg" then return 1 end if
  if className == "monster_boss2" and distance > 125.0 then return 1 end if
  if className == "monster_makron" then return 1 end if
  return 0
end function

/// Return the berserk plan with raw value.
/// @param raw raw value consumed by this operation.
function berserkPlanWithRaw(raw)
  if raw % 2 == 0 then
    return attackPlan("monster_berserk", "berserk-spike", "melee", 18, 400,
      0.0, 0.0, 80.0, 1, [3], [0], 8)
  end if
  return attackPlan("monster_berserk", "berserk-club", "melee", 8, 400,
    0.0, 0.0, 80.0, 1, [8], [0], 12)
end function

/// Return the gunner plan with roll value.
/// @param actorNumber actorNumber value consumed by this operation.
/// @param attackCount Number of attack to process.
/// @param distance distance value consumed by this operation.
/// @param roll roll value consumed by this operation.
function gunnerPlanWithRoll(actorNumber, attackCount, distance, roll)
  if distance >= 80.0 and roll <= 0.5 then return gunnerGrenadePlan() end if
  return gunnerChainPlanCycles(1)
end function

/// Return the soldier plan with roll value.
/// @param className className value consumed by this operation.
/// @param actorNumber actorNumber value consumed by this operation.
/// @param attackCount Number of attack to process.
/// @param roll roll value consumed by this operation.
function soldierPlanWithRoll(className, actorNumber, attackCount, roll)
  if className == "monster_soldier_ss" then
    return soldierPlanVariant(className, actorNumber, attackCount, false)
  end if
  return soldierPlanVariant(className, actorNumber, attackCount, roll >= 0.5)
end function

/// Return the brain plan with roll value.
/// @param skill skill value consumed by this operation.
/// @param roll roll value consumed by this operation.
function brainPlanWithRoll(skill, roll)
  if roll <= 0.5 then return brainClawPlan() end if
  // Whether attack2 chains is decided later by the real fire_hit result, not
  // by skill alone at selection time.
  return brainTentaclePlan(0)
end function

/// Return the floater plan with roll value.
/// @param distance distance value consumed by this operation.
/// @param roll roll value consumed by this operation.
function floaterPlanWithRoll(distance, roll)
  if distance >= 80.0 then return floaterBlasterPlan() end if
  if roll < 0.5 then return floaterZapPlan() end if
  return floaterWhamPlan()
end function

/// Return the supertank plan with roll value.
/// @param actorNumber actorNumber value consumed by this operation.
/// @param attackCount Number of attack to process.
/// @param distance distance value consumed by this operation.
/// @param roll roll value consumed by this operation.
function supertankPlanWithRoll(actorNumber, attackCount, distance, roll)
  if distance <= 160.0 or roll < 0.3 then return supertankMachinegunPlanCycles(1) end if
  return supertankRocketPlan()
end function

/// Return the jorg plan with roll value.
/// @param actorNumber actorNumber value consumed by this operation.
/// @param attackCount Number of attack to process.
/// @param roll roll value consumed by this operation.
function jorgPlanWithRoll(actorNumber, attackCount, roll)
  if roll <= 0.75 then return jorgPlanCycles(1) end if
  return jorgBfgPlan()
end function

/// Return the boss 2 plan with roll value.
/// @param actorNumber actorNumber value consumed by this operation.
/// @param attackCount Number of attack to process.
/// @param distance distance value consumed by this operation.
/// @param roll roll value consumed by this operation.
function boss2PlanWithRoll(actorNumber, attackCount, distance, roll)
  if distance <= 125.0 or roll <= 0.6 then return boss2MachinegunPlanCycles(1) end if
  return boss2RocketPlan()
end function

/// Return the makron plan with roll value.
/// @param roll roll value consumed by this operation.
function makronPlanWithRoll(roll)
  if roll <= 0.3 then return makronBfgPlan() end if
  if roll <= 0.6 then return makronHyperblasterPlan() end if
  return makronRailPlan()
end function

/// Return the plan by name.
/// @param className className value consumed by this operation.
/// @param name Name of the affected item.
/// @param actorNumber actorNumber value consumed by this operation.
/// @param attackCount Number of attack to process.
function planByName(className, name, actorNumber, attackCount)
  // Keep plan by name phases explicit: validate inputs, update owned state, then publish the result.
  if name == "misc_actor-single" then
    return actorMachinegunPlan(actorNumber * 97 + attackCount * 53 + 17)
  end if
  if name == "berserk-spike" or name == "berserk-club" then return berserkMeleePlan(actorNumber, attackCount) end if
  if name == "gladiator-rail" then return gladiatorRailPlan() end if
  if name == "gladiator-cleaver" then return gladiatorMeleePlan() end if
  if name == "infantry-machinegun" then return infantryPlan(actorNumber, attackCount) end if
  if name == "infantry-punch" then return infantryMeleePlan() end if
  if name == "gunner-chain" then return gunnerChainPlan(actorNumber, attackCount) end if
  if name == "gunner-grenade" then return gunnerGrenadePlan() end if
  if name == "soldier-light-attack1" then
    return soldierLightPlanCycles(className, false, 1)
  end if
  if name == "soldier-light-attack2" then
    return soldierLightPlanCycles(className, true, 1)
  end if
  if name == "soldier-shotgun-attack1" then
    return soldierShotgunPlanCycles(className, false, 1)
  end if
  if name == "soldier-shotgun-attack2" then
    return soldierShotgunPlanCycles(className, true, 1)
  end if
  if name == "soldier-ss-machinegun" then return soldierPlan(className, actorNumber, attackCount) end if
  if name == "soldier-duck-shoot" then return soldierDuckShootPlan(className) end if
  if name == "soldier-run-shoot" then return soldierRunShootPlanCycles(className, 1) end if
  if name == "tank-machinegun" then return tankMachinegunPlan(className) end if
  if name == "tank-blasters" then return tankBlasterPlan(className, actorNumber, attackCount, 1) end if
  if name == "tank-blasters-hard" then return tankBlasterPlan(className, actorNumber, attackCount, 3) end if
  if name == "tank-rockets" then return tankRocketPlan(className, actorNumber, attackCount, 1) end if
  if name == "tank-rockets-hard" then return tankRocketPlan(className, actorNumber, attackCount, 3) end if
  if name == "medic-blaster" then return medicBlasterPlan(actorNumber, attackCount) end if
  if name == "medic-cable" then return medicCablePlan() end if
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
  if name == "mutant-jump" then return mutantJumpPlan() end if
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

/// Return the plan by name cycles value.
/// @param className className value consumed by this operation.
/// @param name Name of the affected item.
/// @param actorNumber actorNumber value consumed by this operation.
/// @param attackCount Number of attack to process.
/// @param cycles cycles value consumed by this operation.
function planByNameCycles(className, name, actorNumber, attackCount, cycles)
  // Keep plan by name cycles phases explicit: validate inputs, update owned state, then publish the result.
  if name == "misc_actor-single" and cycles >= 10 then
    return actorMachinegunPlanShots(cycles)
  end if
  if name == "infantry-machinegun" and cycles >= 10 then return infantryPlanShots(cycles) end if
  if name == "soldier-ss-machinegun" and cycles >= 3 then
    return soldierMachinegunPlanShots(className, cycles)
  end if
  if name == "soldier-light-attack1" and cycles > 0 then
    return soldierLightPlanCycles(className, false, cycles)
  end if
  if name == "soldier-light-attack2" and cycles > 0 then
    return soldierLightPlanCycles(className, true, cycles)
  end if
  if name == "soldier-shotgun-attack1" and cycles > 0 then
    return soldierShotgunPlanCycles(className, false, cycles)
  end if
  if name == "soldier-shotgun-attack2" and cycles > 0 then
    return soldierShotgunPlanCycles(className, true, cycles)
  end if
  if name == "soldier-run-shoot" and cycles > 0 then
    return soldierRunShootPlanCycles(className, cycles)
  end if
  if name == "tank-blasters-hard" and cycles > 0 then
    return tankBlasterPlanCycles(className, cycles, true)
  end if
  if name == "tank-rockets-hard" and cycles > 0 then
    return tankRocketPlanCycles(className, cycles, true)
  end if
  if name == "gunner-chain" and cycles > 0 then return gunnerChainPlanCycles(cycles) end if
  if name == "medic-blaster" then return medicBlasterPlanContinue(cycles > 0) end if
  if name == "medic-cable" then return medicCablePlan() end if
  if name == "chick-rockets" and cycles > 0 then return chickRocketPlanCycles(cycles) end if
  if name == "chick-slash" and cycles > 0 then return chickMeleePlanCycles(cycles) end if
  if name == "flyer-slashes" and cycles > 0 then return flyerMeleePlanCycles(cycles) end if
  if name == "hover-blasters" and cycles > 0 then return hoverBlasterPlanCycles(cycles) end if
  if name == "mutant-claws" and cycles > 0 then return mutantMeleePlanCycles(cycles) end if
  if name == "supertank-machinegun" and cycles > 0 then return supertankMachinegunPlanCycles(cycles) end if
  if name == "jorg-machineguns" and cycles > 0 then return jorgPlanCycles(cycles) end if
  if name == "boss2-machineguns" and cycles > 0 then return boss2MachinegunPlanCycles(cycles) end if
  return planByName(className, name, actorNumber, attackCount)
end function

/// Return the event damage value.
/// @param plan plan value consumed by this operation.
/// @param eventIndex Zero-based index of event.
function inline eventDamage(plan, eventIndex)
  if plan.name == "parasite-drain" and eventIndex == 0 then return 5 end if
  if plan.name == "brain-tentacle-claws" and eventIndex == 0 then return 12 end if
  return plan.damage
end function

/// Return the event knockback value.
/// @param plan plan value consumed by this operation.
/// @param eventIndex Zero-based index of event.
function inline eventKnockback(plan, eventIndex)
  if plan.name == "brain-tentacle-claws" and eventIndex == 0 then return -600 end if
  return plan.knockback
end function

/// Return the event source flash value.
/// @param plan plan value consumed by this operation.
/// @param eventIndex Zero-based index of event.
function inline eventSourceFlash(plan, eventIndex)
  // Makron's 3.19 hyperblaster projects each bolt from the consecutive
  // MZ2_MAKRON_BLASTER_1..17 offsets but deliberately sends the constant
  // MZ2_MAKRON_BLASTER_1 protocol flash. Preserve that original distinction.
  if plan.name == "makron-hyperblaster" then return 102 + eventIndex end if
  return plan.muzzleFlashes[eventIndex]
end function

/// Return the event uses hyperblaster effect value.
/// @param plan plan value consumed by this operation.
/// @param eventIndex Zero-based index of event.
function inline eventUsesHyperblasterEffect(plan, eventIndex)
  if plan.name == "flyer-blasters" then return eventIndex == 0 or eventIndex == 3 or eventIndex == 6 end if
  if plan.name == "floater-blasters" then return eventIndex == 0 or eventIndex == 3 end if
  if plan.name == "hover-blasters" then return eventIndex % 2 == 0 end if
  if plan.name == "medic-blaster" then
    offset = plan.frameOffsets[eventIndex]
    return offset == 18 or offset == 21 or offset == 24 or offset == 27
  end if
  return false
end function

/// Clamp timeline offset.
/// @param plan plan value consumed by this operation.
/// @param timelineOffset timelineOffset value consumed by this operation.
function clampTimelineOffset(plan, timelineOffset)
  if timelineOffset < 0 then return 0 end if
  if timelineOffset >= plan.durationFrames then return plan.durationFrames - 1 end if
  return timelineOffset
end function

/// Performs the modelFrameAt operation for the miniquake2 game ai attack sequences module.
/// @param plan plan value consumed by this operation.
/// @param timelineOffset timelineOffset value consumed by this operation.
function modelFrameAt(plan, timelineOffset)
  // Translate the deterministic event timeline back to the stock MD2 frame.
  // Several C moves hold or loop a short frame range while firing; a simple
  // firstFrame + timelineOffset mapping would visibly run into unrelated
  // animation frames during those refire cycles.
  offset = clampTimelineOffset(plan, timelineOffset)
  name = plan.name
  if name == "misc_actor-single" then
    actorShots = len(plan.frameOffsets)
    if offset < actorShots then return 0 end if
    return 1 + offset - actorShots
  end if
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
  if name == "soldier-light-attack1" then
    soldierLightCycles = len(plan.frameOffsets)
    soldierLightDecision = 5 + (soldierLightCycles - 1) * 5
    if offset <= 5 then return offset end if
    if offset <= soldierLightDecision then return 1 + ((offset - 6) % 5) end if
    return 9 + offset - soldierLightDecision - 1
  end if
  if name == "soldier-light-attack2" then
    soldierLightCycles = len(plan.frameOffsets)
    soldierLightDecision = 7 + (soldierLightCycles - 1) * 5
    if offset <= 7 then return 12 + offset end if
    if offset <= soldierLightDecision then return 15 + ((offset - 8) % 5) end if
    return 27 + offset - soldierLightDecision - 1
  end if
  if name == "soldier-shotgun-attack1" then
    soldierShotgunCycles = len(plan.frameOffsets)
    soldierShotgunDecision = 8 + (soldierShotgunCycles - 1) * 8
    if offset <= 8 then return offset end if
    if offset <= soldierShotgunDecision then return 1 + ((offset - 9) % 8) end if
    return 9 + offset - soldierShotgunDecision - 1
  end if
  if name == "soldier-shotgun-attack2" then
    soldierShotgunCycles = len(plan.frameOffsets)
    soldierShotgunDecision = 14 + (soldierShotgunCycles - 1) * 12
    if offset <= 14 then return 12 + offset end if
    if offset <= soldierShotgunDecision then return 15 + ((offset - 15) % 12) end if
    return 27 + offset - soldierShotgunDecision - 1
  end if
  if name == "soldier-ss-machinegun" then
    soldierShots = len(plan.frameOffsets)
    if offset < 2 then return 39 + offset end if
    if offset < 2 + soldierShots then return 41 end if
    return 42 + offset - (2 + soldierShots)
  end if
  if name == "soldier-duck-shoot" then
    if offset <= 5 then return 30 + offset end if
    if offset <= 9 then return 32 + offset - 6 end if
    return 36 + offset - 10
  end if
  if name == "soldier-run-shoot" then
    if offset < 14 then return 109 + offset end if
    return 111 + ((offset - 14) % 12)
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
  if name == "medic-cable" then return 209 + offset end if
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
    if offset <= 10 then return 71 + offset end if
    return 53 + offset - 11
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
  if name == "mutant-jump" then return offset end if
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

/// Validates plan for the miniquake2 game ai attack sequences workflow.
/// @param plan plan value consumed by this operation.
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
