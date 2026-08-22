/* Deterministic Quake II 3.19 pain/death MD2 ranges for stock monsters. */
package miniquake2.game.ai.reaction_sequences

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
  if className == "monster_supertank" then return reactionPlan(className, "death", "death", 98, 121, "bosstank/btkdeth1.wav", 1, "corpse") end if
  if className == "monster_boss2" then return reactionPlan(className, "death", "death", 132, 180, "bosshovr/bhvdeth1.wav", 0, "corpse") end if
  if className == "monster_jorg" then return reactionPlan(className, "death", "death", 31, 80, "boss3/bs3deth1.wav", 1, "jorg") end if
  if className == "monster_makron" then return reactionPlan(className, "death", "death", 251, 345, "makron/death.wav", 0, "corpse") end if
  return void
end function

function selectDeathPlan(className, actorNumber, dieCount, gibbed)
  gaiReactionDeathVariantTotal = deathVariantCount(className)
  if gaiReactionDeathVariantTotal == 0 then return void end if
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
      plan.terminalKind != "explode" and plan.terminalKind != "jorg" and plan.terminalKind != "gib" then
    return error(9672, "invalid monster reaction terminal kind")
  end if
  return true
end function
