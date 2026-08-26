/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Deterministic Quake II 3.19 pain/death MD2 ranges for stock monsters. */
package miniquake2.game.ai.reaction_sequences

import miniquake2.game.constants as gaireactionconstants

struct MonsterReactionPlan
  className
  name
  reactionKind
  firstFrame
  lastFrame
  soundName
  attenuation
  terminalKind
end struct

// Non-zero mframe_t movement columns from the stock 3.19 pain/death tables.
// Zero-only tables fall through to 0.0 in movementDistanceAt. Keeping these
// arrays package-rooted avoids rebuilding or concatenating them per AI frame.
gaiReactionMoveGunnerPain1 = [2.0, 0.0, -5.0, 3.0, -1.0, 0.0, 0.0, 0.0,
  0.0, 1.0, 1.0, 2.0, 1.0, 0.0, -2.0, -2.0, 0.0, 0.0]
gaiReactionMoveGunnerPain2 = [-2.0, 11.0, 6.0, 2.0, -1.0, -7.0, -2.0, -7.0]
gaiReactionMoveGunnerPain3 = [-3.0, 1.0, 1.0, 0.0, 1.0]
gaiReactionMoveInfantryPain1 = [-3.0, -2.0, -1.0, -2.0, -1.0, 1.0, -1.0, 1.0, 6.0, 2.0]
gaiReactionMoveInfantryPain2 = [-3.0, -3.0, 0.0, -1.0, -2.0, 0.0, 0.0, 2.0, 5.0, 2.0]
gaiReactionMoveSoldierPain1 = [-3.0, 4.0, 1.0, 1.0, 0.0]
gaiReactionMoveSoldierPain2 = [-13.0, -1.0, 2.0, 4.0, 2.0, 3.0, 2.0]
gaiReactionMoveSoldierPain3 = [-8.0, 10.0, -4.0, -1.0, -3.0, 0.0, 3.0, 0.0,
  0.0, 0.0, 0.0, 1.0, 0.0, 1.0, 2.0, 4.0, 3.0, 2.0]
gaiReactionMoveSoldierPain4 = [0.0, 0.0, 0.0, -10.0, -6.0, 8.0, 4.0, 1.0,
  0.0, 2.0, 5.0, 2.0, -1.0, -1.0, 3.0, 2.0, 0.0]
gaiReactionMoveTankPain3 = [-7.0, 0.0, 0.0, 0.0, 2.0, 0.0, 0.0, 3.0,
  0.0, 2.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
gaiReactionMoveChickPain3 = [0.0, 0.0, -6.0, 3.0, 11.0, 3.0, 0.0, 0.0,
  4.0, 1.0, 0.0, -3.0, -4.0, 5.0, 7.0, -2.0, 3.0, -5.0, -2.0, -8.0, 2.0]
gaiReactionMoveParasitePain = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 6.0, 16.0, -6.0, -7.0, 0.0]
gaiReactionMoveBrainPain1 = [-6.0, -2.0, -6.0, 0.0, 0.0, 0.0, 0.0, 0.0,
  0.0, 0.0, 0.0, 0.0, 0.0, 2.0, 0.0, 2.0, 1.0, 7.0, 0.0, 3.0, -1.0]
gaiReactionMoveBrainPain2 = [-2.0, 0.0, 0.0, 0.0, 0.0, 3.0, 1.0, -2.0]
gaiReactionMoveBrainPain3 = [-2.0, 2.0, 1.0, 3.0, 0.0, -4.0]
gaiReactionMoveHoverPain1 = [0.0, 0.0, 2.0, -8.0, -4.0, -6.0, -4.0, -3.0,
  1.0, 0.0, 0.0, 0.0, 3.0, 1.0, 0.0, 2.0, 3.0, 2.0, 7.0, 1.0,
  0.0, 0.0, 2.0, 0.0, 0.0, 5.0, 3.0, 4.0]
gaiReactionMoveMutantPain1 = [4.0, -3.0, -8.0, 2.0, 5.0]
gaiReactionMoveMutantPain2 = [-24.0, 11.0, 5.0, -2.0, 6.0, 4.0]
gaiReactionMoveMutantPain3 = [-22.0, 3.0, 3.0, 2.0, 1.0, 1.0, 6.0, 3.0, 2.0, 0.0, 1.0]
gaiReactionMoveJorgPain3 = [-28.0, -6.0, -3.0, -9.0, 0.0, 0.0, 0.0, 0.0,
  -7.0, 1.0, -11.0, -4.0, 0.0, 0.0, 10.0, 11.0, 0.0, 10.0, 3.0, 10.0,
  7.0, 17.0, 0.0, 0.0, 0.0]

gaiReactionMoveGunnerDeath = [0.0, 0.0, 0.0, -7.0, -3.0, -5.0, 8.0, 6.0, 0.0, 0.0, 0.0]
gaiReactionMoveInfantryDeath1 = [-4.0, 0.0, 0.0, -1.0, -4.0, 0.0, 0.0, 0.0,
  -1.0, 3.0, 1.0, 1.0, -2.0, 2.0, 2.0, 9.0, 9.0, 5.0, -3.0, -3.0]
gaiReactionMoveInfantryDeath2 = [0.0, 1.0, 5.0, -1.0, 0.0, 1.0, 1.0, 4.0,
  3.0, 0.0, -2.0, -2.0, -3.0, -1.0, -2.0, 0.0, 2.0, 2.0, 3.0, -10.0,
  -7.0, -8.0, -6.0, 4.0, 0.0]
gaiReactionMoveInfantryDeath3 = [0.0, 0.0, 0.0, -6.0, -11.0, -3.0, -11.0, 0.0, 0.0]
gaiReactionMoveSoldierDeath1 = [0.0, -10.0, -10.0, -10.0, -5.0, 0.0, 0.0, 0.0,
  0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
  0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
  0.0, 0.0, 0.0, 0.0]
gaiReactionMoveSoldierDeath2 = [-5.0, -5.0, -5.0, 0.0, 0.0, 0.0, 0.0, 0.0,
  0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
  0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
  0.0, 0.0, 0.0]
gaiReactionMoveSoldierDeath3 = [-5.0, -5.0, -5.0, 0.0, 0.0, 0.0, 0.0, 0.0,
  0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
  0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
  0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
gaiReactionMoveSoldierDeath5 = [-5.0, -5.0, -5.0, 0.0, 0.0, 0.0, 0.0, 0.0,
  0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
  0.0, 0.0, 0.0, 0.0]
gaiReactionMoveTankDeath = [-7.0, -2.0, -2.0, 1.0, 3.0, 6.0, 1.0, 1.0,
  2.0, 0.0, 0.0, 0.0, -2.0, 0.0, 0.0, -3.0, 0.0, 0.0, 0.0, 0.0,
  0.0, 0.0, -4.0, -6.0, -4.0, -5.0, -7.0, -15.0, -5.0, 0.0, 0.0, 0.0]
gaiReactionMoveChickDeath1 = [0.0, 0.0, -7.0, 4.0, 11.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
gaiReactionMoveChickDeath2 = [-6.0, 0.0, -1.0, -5.0, 0.0, -1.0, -2.0, 1.0,
  10.0, 2.0, 3.0, 1.0, 2.0, 0.0, 3.0, 3.0, 1.0, -3.0, -5.0, 4.0, 15.0, 14.0, 1.0]
gaiReactionMoveBrainDeath1 = [0.0, 0.0, -2.0, 9.0, 0.0, 0.0, 0.0, 0.0,
  0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
gaiReactionMoveBrainDeath2 = [0.0, 0.0, 0.0, 9.0, 0.0]
gaiReactionMoveHoverDeath = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, -10.0, 3.0, 5.0, 4.0, 7.0]
gaiReactionMoveMakronDeath = [-15.0, 3.0, -12.0, 0.0, 0.0, 0.0, 0.0, 0.0,
  0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 11.0, 12.0, 11.0, 0.0, 0.0,
  0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
  0.0, 5.0, 7.0, 6.0, 0.0, 0.0, -1.0, 2.0, 0.0, 0.0, 0.0, 0.0,
  0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, -6.0, -4.0, -6.0,
  -4.0, -4.0, 0.0, 0.0, 0.0, 0.0, -2.0, -5.0, -3.0, -8.0, -3.0, -7.0,
  -4.0, -4.0, -6.0, -7.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
  0.0, 0.0, 0.0, 0.0, 0.0, -2.0, 0.0, 0.0, 2.0, 0.0, 27.0, 26.0,
  0.0, 0.0, 0.0]

function reactionPlan(className, suffix, reactionKind, firstFrame, lastFrame,
    soundName, attenuation, terminalKind)
  return MonsterReactionPlan(className, className + "-" + suffix,
    reactionKind, firstFrame, lastFrame, soundName, attenuation, terminalKind)
end function

function deterministicValue(actorNumber, count, salt, modulus)
  if modulus <= 0 then return 0 end if
  value = actorNumber * 97 + count * 53 + salt * 31 + 17
  if value < 0 then value = -value end if
  return value % modulus
end function

function soldierPainSound(className)
  if className == "monster_soldier_light" then return "soldier/solpain2.wav" end if
  if className == "monster_soldier_ss" then return "soldier/solpain3.wav" end if
  return "soldier/solpain1.wav"
end function

function soldierDeathSound(className)
  if className == "monster_soldier_light" then return "soldier/soldeth2.wav" end if
  if className == "monster_soldier_ss" then return "soldier/soldeth3.wav" end if
  return "soldier/soldeth1.wav"
end function

function painVariantCount(className)
  if className == "monster_berserk" then return 2 end if
  if className == "monster_gladiator" then return 2 end if
  if className == "monster_gunner" then return 3 end if
  if className == "monster_infantry" then return 2 end if
  if className == "monster_soldier_light" or className == "monster_soldier" or className == "monster_soldier_ss" then return 4 end if
  if className == "monster_tank" or className == "monster_tank_commander" then return 3 end if
  if className == "monster_medic" then return 2 end if
  if className == "monster_flipper" then return 2 end if
  if className == "monster_chick" then return 3 end if
  if className == "monster_parasite" then return 2 end if
  if className == "monster_flyer" then return 3 end if
  if className == "monster_brain" then return 3 end if
  if className == "monster_floater" then return 3 end if
  if className == "monster_hover" then return 3 end if
  if className == "monster_mutant" then return 3 end if
  if className == "monster_supertank" then return 3 end if
  if className == "monster_boss2" then return 3 end if
  if className == "monster_jorg" then return 3 end if
  if className == "monster_makron" then return 3 end if
  return 0
end function

function painVariant(className, variant)
  if className == "monster_berserk" then
    if variant == 0 then return reactionPlan(className, "pain1", "pain", 199, 202, "berserk/berpain2.wav", 1, "run") end if
    if variant == 1 then return reactionPlan(className, "pain2", "pain", 203, 222, "berserk/berpain2.wav", 1, "run") end if
  end if
  if className == "monster_gladiator" then
    if variant == 0 then return reactionPlan(className, "pain1", "pain", 55, 60, "gladiator/pain.wav", 1, "run") end if
    if variant == 1 then return reactionPlan(className, "pain-air", "pain", 83, 89, "gladiator/gldpain2.wav", 1, "run") end if
  end if
  if className == "monster_gunner" then
    if variant == 0 then return reactionPlan(className, "pain1", "pain", 159, 176, "gunner/gunpain2.wav", 1, "run") end if
    if variant == 1 then return reactionPlan(className, "pain2", "pain", 177, 184, "gunner/gunpain1.wav", 1, "run") end if
    if variant == 2 then return reactionPlan(className, "pain3", "pain", 185, 189, "gunner/gunpain2.wav", 1, "run") end if
  end if
  if className == "monster_infantry" then
    if variant == 0 then return reactionPlan(className, "pain1", "pain", 100, 109, "infantry/infpain1.wav", 1, "run") end if
    if variant == 1 then return reactionPlan(className, "pain2", "pain", 110, 119, "infantry/infpain2.wav", 1, "run") end if
  end if
  if className == "monster_soldier_light" or className == "monster_soldier" or className == "monster_soldier_ss" then
    soundName = soldierPainSound(className)
    if variant == 0 then return reactionPlan(className, "pain1", "pain", 50, 54, soundName, 1, "run") end if
    if variant == 1 then return reactionPlan(className, "pain2", "pain", 55, 61, soundName, 1, "run") end if
    if variant == 2 then return reactionPlan(className, "pain3", "pain", 62, 79, soundName, 1, "run") end if
    if variant == 3 then return reactionPlan(className, "pain4", "pain", 80, 96, soundName, 1, "run") end if
  end if
  if className == "monster_tank" or className == "monster_tank_commander" then
    if variant == 0 then return reactionPlan(className, "pain1", "pain", 197, 200, "tank/tnkpain2.wav", 1, "run") end if
    if variant == 1 then return reactionPlan(className, "pain2", "pain", 201, 205, "tank/tnkpain2.wav", 1, "run") end if
    if variant == 2 then return reactionPlan(className, "pain3", "pain", 206, 221, "tank/tnkpain2.wav", 1, "run") end if
  end if
  if className == "monster_medic" then
    if variant == 0 then return reactionPlan(className, "pain1", "pain", 108, 115, "medic/medpain1.wav", 1, "run") end if
    if variant == 1 then return reactionPlan(className, "pain2", "pain", 116, 130, "medic/medpain2.wav", 1, "run") end if
  end if
  if className == "monster_flipper" then
    if variant == 0 then return reactionPlan(className, "pain1", "pain", 99, 103, "flipper/flppain1.wav", 1, "run") end if
    if variant == 1 then return reactionPlan(className, "pain2", "pain", 94, 98, "flipper/flppain2.wav", 1, "run") end if
  end if
  if className == "monster_chick" then
    if variant == 0 then return reactionPlan(className, "pain1", "pain", 90, 94, "chick/chkpain1.wav", 1, "run") end if
    if variant == 1 then return reactionPlan(className, "pain2", "pain", 95, 99, "chick/chkpain2.wav", 1, "run") end if
    if variant == 2 then return reactionPlan(className, "pain3", "pain", 100, 120, "chick/chkpain3.wav", 1, "run") end if
  end if
  if className == "monster_parasite" then
    soundName = "parasite/parpain1.wav"
    if variant == 1 then soundName = "parasite/parpain2.wav" end if
    return reactionPlan(className, "pain" + (variant + 1), "pain", 57, 67, soundName, 1, "run")
  end if
  if className == "monster_flyer" then
    soundName = "flyer/flypain1.wav"
    if variant == 1 then soundName = "flyer/flypain2.wav" end if
    if variant == 0 then return reactionPlan(className, "pain1", "pain", 134, 142, soundName, 1, "run") end if
    if variant == 1 then return reactionPlan(className, "pain2", "pain", 143, 146, soundName, 1, "run") end if
    if variant == 2 then return reactionPlan(className, "pain3", "pain", 147, 150, soundName, 1, "run") end if
  end if
  if className == "monster_brain" then
    soundName = "brain/brnpain1.wav"
    if variant == 1 then soundName = "brain/brnpain2.wav" end if
    if variant == 0 then return reactionPlan(className, "pain1", "pain", 88, 108, soundName, 1, "run") end if
    if variant == 1 then return reactionPlan(className, "pain2", "pain", 109, 116, soundName, 1, "run") end if
    if variant == 2 then return reactionPlan(className, "pain3", "pain", 117, 122, soundName, 1, "run") end if
  end if
  if className == "monster_floater" then
    soundName = "floater/fltpain1.wav"
    if variant == 1 then soundName = "floater/fltpain2.wav" end if
    if variant == 0 then return reactionPlan(className, "pain1", "pain", 117, 123, soundName, 1, "run") end if
    if variant == 1 then return reactionPlan(className, "pain2", "pain", 124, 131, soundName, 1, "run") end if
    if variant == 2 then return reactionPlan(className, "pain3", "pain", 132, 143, soundName, 1, "run") end if
  end if
  if className == "monster_hover" then
    soundName = "hover/hovpain1.wav"
    if variant == 1 then soundName = "hover/hovpain2.wav" end if
    if variant == 0 then return reactionPlan(className, "pain1", "pain", 113, 140, soundName, 1, "run") end if
    if variant == 1 then return reactionPlan(className, "pain2", "pain", 141, 152, soundName, 1, "run") end if
    if variant == 2 then return reactionPlan(className, "pain3", "pain", 153, 161, soundName, 1, "run") end if
  end if
  if className == "monster_mutant" then
    soundName = "mutant/mutpain1.wav"
    if variant == 1 then soundName = "mutant/mutpain2.wav" end if
    if variant == 0 then return reactionPlan(className, "pain1", "pain", 34, 38, soundName, 1, "run") end if
    if variant == 1 then return reactionPlan(className, "pain2", "pain", 39, 44, soundName, 1, "run") end if
    if variant == 2 then return reactionPlan(className, "pain3", "pain", 45, 55, soundName, 1, "run") end if
  end if
  if className == "monster_supertank" then
    if variant == 0 then return reactionPlan(className, "pain1", "pain", 164, 167, "bosstank/btkpain1.wav", 1, "run") end if
    if variant == 1 then return reactionPlan(className, "pain2", "pain", 168, 171, "bosstank/btkpain3.wav", 1, "run") end if
    if variant == 2 then return reactionPlan(className, "pain3", "pain", 172, 175, "bosstank/btkpain2.wav", 1, "run") end if
  end if
  if className == "monster_boss2" then
    if variant == 0 then return reactionPlan(className, "pain-light1", "pain", 128, 131, "bosshovr/bhvpain3.wav", 0, "run") end if
    if variant == 1 then return reactionPlan(className, "pain-light2", "pain", 128, 131, "bosshovr/bhvpain1.wav", 0, "run") end if
    if variant == 2 then return reactionPlan(className, "pain-heavy", "pain", 110, 127, "bosshovr/bhvpain2.wav", 0, "run") end if
  end if
  if className == "monster_jorg" then
    if variant == 0 then return reactionPlan(className, "pain1", "pain", 81, 83, "boss3/bs3pain1.wav", 1, "run") end if
    if variant == 1 then return reactionPlan(className, "pain2", "pain", 84, 86, "boss3/bs3pain2.wav", 1, "run") end if
    if variant == 2 then return reactionPlan(className, "pain3", "pain", 87, 111, "boss3/bs3pain3.wav", 1, "run") end if
  end if
  if className == "monster_makron" then
    if variant == 0 then return reactionPlan(className, "pain4", "pain", 379, 382, "makron/pain3.wav", 0, "run") end if
    if variant == 1 then return reactionPlan(className, "pain5", "pain", 383, 386, "makron/pain2.wav", 0, "run") end if
    if variant == 2 then return reactionPlan(className, "pain6", "pain", 387, 413, "makron/pain1.wav", 0, "run") end if
  end if
  return void
end function

function selectPainPlan(className, actorNumber, painCount, damage, skill)
  if skill == 3 then return void end if
  variantCount = painVariantCount(className)
  if variantCount == 0 then return void end if
  if className == "monster_tank" or className == "monster_tank_commander" then
    if damage <= 10 then return void end if
    if damage <= 30 then
      if deterministicValue(actorNumber, painCount, 151, 100) >= 20 then return void end if
      return painVariant(className, 0)
    end if
    if damage <= 60 then return painVariant(className, 1) end if
    return painVariant(className, 2)
  end if
  if className == "monster_chick" then
    if damage <= 10 then return painVariant(className, 0) end if
    if damage <= 25 then return painVariant(className, 1) end if
    return painVariant(className, 2)
  end if
  if className == "monster_supertank" then
    if damage <= 10 then return painVariant(className, 0) end if
    if damage <= 25 then return painVariant(className, 1) end if
    return painVariant(className, 2)
  end if
  if className == "monster_boss2" then
    if damage < 10 then return painVariant(className, 0) end if
    if damage < 30 then return painVariant(className, 1) end if
    return painVariant(className, 2)
  end if
  if className == "monster_jorg" then
    if damage <= 40 and deterministicValue(actorNumber, painCount, 157, 100) < 60 then return void end if
    if damage <= 50 then return painVariant(className, 0) end if
    if damage <= 100 then return painVariant(className, 1) end if
    if deterministicValue(actorNumber, painCount, 159, 100) <= 30 then return painVariant(className, 2) end if
    return void
  end if
  if className == "monster_makron" then
    if damage <= 25 and deterministicValue(actorNumber, painCount, 163, 100) < 20 then return void end if
    if damage <= 40 then return painVariant(className, 0) end if
    if damage <= 110 then return painVariant(className, 1) end if
    if damage <= 150 and deterministicValue(actorNumber, painCount, 167, 100) <= 45 then return painVariant(className, 2) end if
    if damage > 150 and deterministicValue(actorNumber, painCount, 169, 100) <= 35 then return painVariant(className, 2) end if
    return void
  end if
  return painVariant(className, deterministicValue(actorNumber, painCount, 149, variantCount))
end function

function deathVariantCount(className)
  if painVariantCount(className) == 0 then return 0 end if
  if className == "monster_berserk" then return 2 end if
  if className == "monster_infantry" then return 3 end if
  if className == "monster_soldier_light" or className == "monster_soldier" or className == "monster_soldier_ss" then return 6 end if
  if className == "monster_chick" then return 2 end if
  if className == "monster_brain" then return 2 end if
  if className == "monster_mutant" then return 2 end if
  return 1
end function

function deathVariant(className, variant)
  if className == "monster_berserk" then
    if variant == 0 then return reactionPlan(className, "death1", "death", 223, 235, "berserk/berdeth2.wav", 1, "corpse") end if
    if variant == 1 then return reactionPlan(className, "death2", "death", 236, 243, "berserk/berdeth2.wav", 1, "corpse") end if
  end if
  if className == "monster_gladiator" then return reactionPlan(className, "death", "death", 61, 82, "gladiator/glddeth2.wav", 1, "corpse") end if
  if className == "monster_gunner" then return reactionPlan(className, "death", "death", 190, 200, "gunner/death1.wav", 1, "corpse") end if
  if className == "monster_infantry" then
    soundName = "infantry/infdeth1.wav"; if variant == 1 then soundName = "infantry/infdeth2.wav" end if
    if variant == 0 then return reactionPlan(className, "death1", "death", 125, 144, soundName, 1, "corpse") end if
    if variant == 1 then return reactionPlan(className, "death2", "death", 145, 169, soundName, 1, "corpse") end if
    if variant == 2 then return reactionPlan(className, "death3", "death", 170, 178, soundName, 1, "corpse") end if
  end if
  if className == "monster_soldier_light" or className == "monster_soldier" or className == "monster_soldier_ss" then
    soundName = soldierDeathSound(className)
    if variant == 0 then return reactionPlan(className, "death1", "death", 272, 307, soundName, 1, "corpse") end if
    if variant == 1 then return reactionPlan(className, "death2", "death", 308, 342, soundName, 1, "corpse") end if
    if variant == 2 then return reactionPlan(className, "death3", "death", 343, 387, soundName, 1, "corpse") end if
    if variant == 3 then return reactionPlan(className, "death4", "death", 388, 440, soundName, 1, "corpse") end if
    if variant == 4 then return reactionPlan(className, "death5", "death", 441, 464, soundName, 1, "corpse") end if
    if variant == 5 then return reactionPlan(className, "death6", "death", 465, 474, soundName, 1, "corpse") end if
  end if
  if className == "monster_tank" or className == "monster_tank_commander" then return reactionPlan(className, "death", "death", 222, 253, "tank/death.wav", 1, "corpse") end if
  if className == "monster_medic" then return reactionPlan(className, "death", "death", 147, 176, "medic/meddeth1.wav", 1, "corpse") end if
  if className == "monster_flipper" then return reactionPlan(className, "death", "death", 104, 159, "flipper/flpdeth1.wav", 1, "corpse") end if
  if className == "monster_chick" then
    if variant == 0 then return reactionPlan(className, "death1", "death", 48, 59, "chick/chkdeth1.wav", 1, "corpse") end if
    if variant == 1 then return reactionPlan(className, "death2", "death", 60, 82, "chick/chkdeth2.wav", 1, "corpse") end if
  end if
  if className == "monster_parasite" then return reactionPlan(className, "death", "death", 32, 38, "parasite/pardeth1.wav", 1, "corpse") end if
  if className == "monster_flyer" then return reactionPlan(className, "death", "death", 0, 0, "flyer/flydeth1.wav", 1, "explode") end if
  if className == "monster_brain" then
    if variant == 0 then return reactionPlan(className, "death1", "death", 123, 140, "brain/brndeth1.wav", 1, "corpse") end if
    if variant == 1 then return reactionPlan(className, "death2", "death", 141, 145, "brain/brndeth1.wav", 1, "corpse") end if
  end if
  if className == "monster_floater" then return reactionPlan(className, "death", "death", 104, 116, "floater/fltdeth1.wav", 1, "explode") end if
  if className == "monster_hover" then
    soundName = "hover/hovdeth1.wav"; if variant % 2 == 1 then soundName = "hover/hovdeth2.wav" end if
    return reactionPlan(className, "death", "death", 162, 172, soundName, 1, "explode")
  end if
  if className == "monster_mutant" then
    if variant == 0 then return reactionPlan(className, "death1", "death", 15, 23, "mutant/mutdeth1.wav", 1, "corpse") end if
    if variant == 1 then return reactionPlan(className, "death2", "death", 24, 33, "mutant/mutdeth1.wav", 1, "corpse") end if
  end if
  if className == "monster_supertank" then return reactionPlan(className, "death", "death", 98, 121, "bosstank/btkdeth1.wav", 1, "boss-explode") end if
  if className == "monster_boss2" then return reactionPlan(className, "death", "death", 132, 180, "bosshovr/bhvdeth1.wav", 0, "corpse") end if
  if className == "monster_jorg" then return reactionPlan(className, "death", "death", 31, 80, "boss3/bs3deth1.wav", 1, "jorg") end if
  if className == "monster_makron" then return reactionPlan(className, "death", "death", 251, 345, "makron/death.wav", 0, "corpse") end if
  return void
end function

function selectDeathPlan(className, actorNumber, dieCount, gibbed)
  gaiReactionDeathVariantTotal = deathVariantCount(className)
  if gaiReactionDeathVariantTotal == 0 then return void end if
  // These stock death functions never take the generic over-gib branch.
  if className == "monster_flyer" or className == "monster_floater" or
      className == "monster_supertank" or className == "monster_jorg" then
    return deathVariant(className, deterministicValue(actorNumber, dieCount, 173,
      gaiReactionDeathVariantTotal))
  end if
  if gibbed then return reactionPlan(className, "gib", "death", 0, 0, "misc/udeath.wav", 1, "gib") end if
  return deathVariant(className, deterministicValue(actorNumber, dieCount, 173,
    gaiReactionDeathVariantTotal))
end function

function stockDodgePlan(className)
  if className == "monster_gunner" then return reactionPlan(className, "duck", "dodge", 201, 208, "", 1, "run") end if
  if className == "monster_chick" then return reactionPlan(className, "duck", "dodge", 83, 89, "", 1, "run") end if
  if className == "monster_soldier_light" or className == "monster_soldier" or className == "monster_soldier_ss" then
    return reactionPlan(className, "duck", "dodge", 45, 49, "", 1, "run")
  end if
  if className == "monster_medic" then return reactionPlan(className, "duck", "dodge", 131, 146, "", 1, "run") end if
  if className == "monster_infantry" then return reactionPlan(className, "duck", "dodge", 120, 124, "", 1, "run") end if
  if className == "monster_brain" then return reactionPlan(className, "duck", "dodge", 146, 153, "", 1, "run") end if
  return void
end function

function planByName(className, name)
  if name == className + "-gib" then
    return reactionPlan(className, "gib", "death", 0, 0, "misc/udeath.wav", 1, "gib")
  end if
  painIndex = 0
  while painIndex < painVariantCount(className)
    candidate = painVariant(className, painIndex)
    if candidate is not void and candidate.name == name then return candidate end if
    painIndex = painIndex + 1
  end while
  deathIndex = 0
  while deathIndex < deathVariantCount(className)
    candidate = deathVariant(className, deathIndex)
    if candidate is not void and candidate.name == name then return candidate end if
    deathIndex = deathIndex + 1
  end while
  dodge = stockDodgePlan(className)
  if dodge is not void and dodge.name == name then return dodge end if
  return void
end function

function durationFrames(plan)
  return plan.lastFrame - plan.firstFrame + 1
end function

function inline movementDistanceAt(plan, timelineOffset)
  offset = timelineOffset
  duration = durationFrames(plan)
  if offset < 0 then offset = 0 end if
  if offset >= duration then offset = duration - 1 end if
  className = plan.className
  firstFrame = plan.firstFrame

  if className == "monster_gunner" then
    if firstFrame == 159 then return gaiReactionMoveGunnerPain1[offset] end if
    if firstFrame == 177 then return gaiReactionMoveGunnerPain2[offset] end if
    if firstFrame == 185 then return gaiReactionMoveGunnerPain3[offset] end if
    if firstFrame == 190 then return gaiReactionMoveGunnerDeath[offset] end if
  end if
  if className == "monster_infantry" then
    if firstFrame == 100 then return gaiReactionMoveInfantryPain1[offset] end if
    if firstFrame == 110 then return gaiReactionMoveInfantryPain2[offset] end if
    if firstFrame == 125 then return gaiReactionMoveInfantryDeath1[offset] end if
    if firstFrame == 145 then return gaiReactionMoveInfantryDeath2[offset] end if
    if firstFrame == 170 then return gaiReactionMoveInfantryDeath3[offset] end if
  end if
  if className == "monster_soldier_light" or className == "monster_soldier" or
      className == "monster_soldier_ss" then
    if firstFrame == 50 then return gaiReactionMoveSoldierPain1[offset] end if
    if firstFrame == 55 then return gaiReactionMoveSoldierPain2[offset] end if
    if firstFrame == 62 then return gaiReactionMoveSoldierPain3[offset] end if
    if firstFrame == 80 then return gaiReactionMoveSoldierPain4[offset] end if
    if firstFrame == 272 then return gaiReactionMoveSoldierDeath1[offset] end if
    if firstFrame == 308 then return gaiReactionMoveSoldierDeath2[offset] end if
    if firstFrame == 343 then return gaiReactionMoveSoldierDeath3[offset] end if
    if firstFrame == 441 then return gaiReactionMoveSoldierDeath5[offset] end if
  end if
  if className == "monster_tank" or className == "monster_tank_commander" then
    if firstFrame == 206 then return gaiReactionMoveTankPain3[offset] end if
    if firstFrame == 222 then return gaiReactionMoveTankDeath[offset] end if
  end if
  if className == "monster_chick" then
    if firstFrame == 100 then return gaiReactionMoveChickPain3[offset] end if
    if firstFrame == 48 then return gaiReactionMoveChickDeath1[offset] end if
    if firstFrame == 60 then return gaiReactionMoveChickDeath2[offset] end if
  end if
  if className == "monster_parasite" and firstFrame == 57 then
    return gaiReactionMoveParasitePain[offset]
  end if
  if className == "monster_brain" then
    if firstFrame == 88 then return gaiReactionMoveBrainPain1[offset] end if
    if firstFrame == 109 then return gaiReactionMoveBrainPain2[offset] end if
    if firstFrame == 117 then return gaiReactionMoveBrainPain3[offset] end if
    if firstFrame == 123 then return gaiReactionMoveBrainDeath1[offset] end if
    if firstFrame == 141 then return gaiReactionMoveBrainDeath2[offset] end if
  end if
  if className == "monster_hover" then
    if firstFrame == 113 then return gaiReactionMoveHoverPain1[offset] end if
    if firstFrame == 162 then return gaiReactionMoveHoverDeath[offset] end if
  end if
  if className == "monster_mutant" then
    if firstFrame == 34 then return gaiReactionMoveMutantPain1[offset] end if
    if firstFrame == 39 then return gaiReactionMoveMutantPain2[offset] end if
    if firstFrame == 45 then return gaiReactionMoveMutantPain3[offset] end if
  end if
  if className == "monster_jorg" and firstFrame == 87 then
    return gaiReactionMoveJorgPain3[offset]
  end if
  if className == "monster_makron" and firstFrame == 251 then
    return gaiReactionMoveMakronDeath[offset]
  end if
  return 0.0
end function

// Frame callbacks retained by the stock pain/death mframe_t tables.  Keep the
// routing scalar and literal-only: these functions run inside MonsterThink and
// must not concatenate strings or allocate callback tables per frame.
function inline frameSoundUsesRandom(plan, timelineOffset)
  return plan.className == "monster_makron" and plan.firstFrame == 387 and
    timelineOffset == 23
end function

function inline frameSoundNameAt(plan, timelineOffset, randomRoll)
  className = plan.className
  firstFrame = plan.firstFrame
  if (className == "monster_tank" or className == "monster_tank_commander") then
    if firstFrame == 206 and timelineOffset == 15 then return "tank/step.wav" end if
    if firstFrame == 222 and timelineOffset == 27 then return "tank/thud.wav" end if
  end if
  if className == "monster_jorg" and firstFrame == 87 then
    if timelineOffset == 2 or timelineOffset == 20 then return "boss3/step1.wav" end if
    if timelineOffset == 4 or timelineOffset == 24 then return "boss3/step2.wav" end if
  end if
  if className == "monster_makron" then
    if firstFrame == 387 then
      if timelineOffset == 15 then return "makron/popup.wav" end if
      if timelineOffset == 23 then
        if randomRoll <= 0.3 then return "makron/voice4.wav" end if
        if randomRoll <= 0.6 then return "makron/voice3.wav" end if
        return "makron/voice.wav"
      end if
    end if
    if firstFrame == 251 then
      if timelineOffset == 3 or timelineOffset == 35 or timelineOffset == 57 or
          timelineOffset == 66 or timelineOffset == 72 then return "makron/step1.wav" end if
      if timelineOffset == 17 or timelineOffset == 55 or timelineOffset == 64 or
          timelineOffset == 69 then return "makron/step2.wav" end if
      if timelineOffset == 90 then return "makron/bhit.wav" end if
      if timelineOffset == 92 then return "makron/brain1.wav" end if
    end if
  end if
  return ""
end function

function inline frameSoundChannelAt(plan, timelineOffset)
  if plan.className == "monster_makron" then
    if plan.firstFrame == 387 and timelineOffset == 23 then
      return gaireactionconstants.CHAN_AUTO
    end if
    if plan.firstFrame == 251 and timelineOffset == 90 then
      return gaireactionconstants.CHAN_AUTO
    end if
    if plan.firstFrame == 251 and timelineOffset == 92 then
      return gaireactionconstants.CHAN_VOICE
    end if
  end if
  return gaireactionconstants.CHAN_BODY
end function

function inline frameSoundAttenuationAt(plan, timelineOffset)
  if plan.className == "monster_makron" then
    if plan.firstFrame == 387 and (timelineOffset == 15 or timelineOffset == 23) then
      return gaireactionconstants.ATTN_NONE
    end if
    if plan.firstFrame == 251 and timelineOffset == 90 then
      return gaireactionconstants.ATTN_NONE
    end if
  end if
  return gaireactionconstants.ATTN_NORM
end function

function inline externalFrameEventAt(plan, timelineOffset)
  if plan.className == "monster_infantry" and plan.firstFrame == 145 and
      timelineOffset >= 10 and timelineOffset <= 21 then
    return "infantry-death-machinegun"
  end if
  if (plan.className == "monster_soldier_light" or plan.className == "monster_soldier" or
      plan.className == "monster_soldier_ss") and plan.firstFrame == 272 and
      (timelineOffset == 21 or timelineOffset == 24) then
    return "soldier-death-fire"
  end if
  return ""
end function

function inline startsBossExplosionAt(plan, timelineOffset)
  if plan.className == "monster_supertank" and plan.firstFrame == 98 then
    return timelineOffset == 23
  end if
  if plan.className == "monster_boss2" and plan.firstFrame == 132 then
    return timelineOffset == 48
  end if
  if plan.className == "monster_jorg" and plan.firstFrame == 31 then
    return timelineOffset == 49
  end if
  return false
end function

function modelFrameAt(plan, timelineOffset)
  if timelineOffset < 0 then timelineOffset = 0 end if
  duration = durationFrames(plan)
  if timelineOffset >= duration then timelineOffset = duration - 1 end if
  return plan.firstFrame + timelineOffset
end function

function validatePlan(plan)
  if plan is void or plan.className == "" or plan.name == "" or
      (plan.reactionKind != "pain" and plan.reactionKind != "death" and plan.reactionKind != "dodge") or
      plan.firstFrame < 0 or plan.lastFrame < plan.firstFrame or
      (plan.soundName == "" and plan.reactionKind != "dodge") then
    return error(9670, "invalid monster reaction plan")
  end if
  if plan.attenuation != 0 and plan.attenuation != 1 then return error(9671, "invalid monster reaction attenuation") end if
  if plan.terminalKind != "run" and plan.terminalKind != "corpse" and
      plan.terminalKind != "explode" and plan.terminalKind != "jorg" and
      plan.terminalKind != "gib" and plan.terminalKind != "boss-explode" then
    return error(9672, "invalid monster reaction terminal kind")
  end if
  return true
end function
