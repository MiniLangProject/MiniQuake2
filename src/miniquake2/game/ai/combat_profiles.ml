/* Data-driven Classic 3.19 attack families for every active stock monster. */
package miniquake2.game.ai.combat_profiles

struct MonsterCombatProfile
  className
  attackKind
  damage
  knockback
  speed
  splashRadius
  maximumRange
  cooldown
  count
  muzzleFlash
end struct

function combatProfile(className, attackKind, damage, knockback, speed, splashRadius, maximumRange, cooldown, count, muzzleFlash)
  return MonsterCombatProfile(className, attackKind, damage, knockback, speed,
    splashRadius, maximumRange, cooldown, count, muzzleFlash)
end function

function stockProfiles()
  return [
    combatProfile("monster_berserk", "melee", 18, 400, 0.0, 0.0, 80.0, 1.0, 1, 0),
    combatProfile("monster_gladiator", "rail", 50, 100, 0.0, 0.0, 2048.0, 1.4, 1, 61),
    combatProfile("monster_gunner", "bullet", 3, 4, 0.0, 0.0, 2048.0, 1.0, 1, 45),
    combatProfile("monster_infantry", "bullet", 3, 4, 0.0, 0.0, 2048.0, 1.0, 1, 26),
    combatProfile("monster_soldier_light", "blaster", 5, 0, 600.0, 0.0, 2048.0, 1.0, 1, 39),
    combatProfile("monster_soldier", "shotgun", 2, 1, 0.0, 0.0, 2048.0, 1.0, 12, 41),
    combatProfile("monster_soldier_ss", "bullet", 2, 4, 0.0, 0.0, 2048.0, 1.0, 1, 43),
    combatProfile("monster_tank", "rocket", 50, 0, 550.0, 70.0, 2048.0, 1.5, 1, 23),
    combatProfile("monster_tank_commander", "rocket", 50, 0, 550.0, 70.0, 2048.0, 1.5, 1, 23),
    combatProfile("monster_medic", "blaster", 2, 0, 1000.0, 0.0, 2048.0, 1.0, 1, 60),
    combatProfile("monster_flipper", "melee", 5, 0, 0.0, 0.0, 80.0, 0.8, 1, 0),
    combatProfile("monster_chick", "rocket", 50, 0, 500.0, 70.0, 2048.0, 1.4, 1, 57),
    combatProfile("monster_parasite", "drain", 10, 0, 0.0, 0.0, 256.0, 1.0, 1, 0),
    combatProfile("monster_flyer", "blaster", 1, 0, 1000.0, 0.0, 2048.0, 0.8, 1, 58),
    combatProfile("monster_brain", "melee", 17, 40, 0.0, 0.0, 80.0, 1.0, 1, 0),
    combatProfile("monster_floater", "blaster", 1, 0, 1000.0, 0.0, 2048.0, 0.8, 1, 82),
    combatProfile("monster_hover", "blaster", 1, 0, 1000.0, 0.0, 2048.0, 0.8, 1, 62),
    combatProfile("monster_mutant", "melee", 12, 100, 0.0, 0.0, 80.0, 1.0, 1, 0),
    combatProfile("monster_supertank", "rocket", 50, 0, 500.0, 70.0, 2048.0, 1.5, 1, 70),
    combatProfile("monster_boss2", "rocket", 50, 0, 500.0, 70.0, 2048.0, 1.5, 1, 78),
    combatProfile("monster_jorg", "bullet", 6, 4, 0.0, 0.0, 2048.0, 0.8, 1, 126),
    combatProfile("monster_makron", "rail", 50, 100, 0.0, 0.0, 2048.0, 1.2, 1, 119),
  ]
end function

function findProfile(profiles, className)
  for each profile in profiles
    if profile.className == className then return profile end if
  end for
  return void
end function

function stockProfile(className)
  return findProfile(stockProfiles(), className)
end function

function validateProfiles(profiles)
  if len(profiles) != 22 then return error(9640, "stock combat profile count must remain 22") end if
  validKinds = ["melee", "drain", "bullet", "shotgun", "blaster", "rocket", "rail"]
  index = 0
  while index < len(profiles)
    profile = profiles[index]
    if profile.className == "" or profile.damage <= 0 or profile.maximumRange <= 0.0 or
        profile.cooldown <= 0.0 or profile.count <= 0 or typeof(profile.muzzleFlash) != "int" or
        profile.muzzleFlash < 0 or profile.muzzleFlash > 255 then
      return error(9641, "invalid stock combat profile at index " + index)
    end if
    kindFound = false
    for each kind in validKinds
      if profile.attackKind == kind then kindFound = true end if
    end for
    if kindFound != true then return error(9642, "invalid stock combat attack kind " + profile.attackKind) end if
    duplicate = 0
    for each candidate in profiles
      if candidate.className == profile.className then duplicate = duplicate + 1 end if
    end for
    if duplicate != 1 then return error(9643, "duplicate stock combat profile " + profile.className) end if
    index = index + 1
  end while
  return true
end function
