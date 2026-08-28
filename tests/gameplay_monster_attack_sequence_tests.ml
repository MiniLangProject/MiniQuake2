/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Quake II 3.19 monster attack-frame, muzzle and live burst regression. */
import miniquake2.game.ai.attack_sequences as attacksequences
import miniquake2.game.ai.types as attacksequenceaitypes
import miniquake2.game.ai.constants as attacksequenceaiconstants
import miniquake2.game.integration.baseq2 as attacksequencebaseq2
import miniquake2.game.random as attacksequencerandom
import miniquake2.game.null_game as attacksequencegame
import miniquake2.game.constants as attacksequencegameconstants
import miniquake2.qcommon.constants as attacksequenceqconstants
import miniquake2.qcommon.types as attacksequenceqtypes
import miniquake2.server.game_bridge as attacksequencebridge
import std.math as attacksequencemath

// Assert the sequence test condition.
function sequenceAssert(value, message)
  if value != true then return error(9984, message) end if
  return true
end function

// Return the sequence near value.
function sequenceNear(actual, expected, message)
  sequenceAssert(attacksequencemath.abs(actual - expected) < 0.001, message)
  return true
end function

// Report whether sequence always visible.
function sequenceAlwaysVisible(first, second)
  return true
end function

// Assert the consecutive test condition.
function assertConsecutive(values, first, count, message)
  sequenceAssert(len(values) == count, message + " count")
  index = 0
  while index < count
    sequenceAssert(values[index] == first + index, message + " value " + index)
    index = index + 1
  end while
  return true
end function

// Return the movement total value.
function movementTotal(plan)
  total = 0.0
  offset = 0
  while offset < plan.durationFrames
    total = total + attacksequences.movementDistanceAt(plan, offset)
    offset = offset + 1
  end while
  return total
end function

infantryPlan = attacksequences.infantryPlan(2, 1)
sequenceAssert(attacksequences.validatePlan(infantryPlan), "infantry plan validates")
sequenceAssert(len(infantryPlan.frameOffsets) >= 10 and len(infantryPlan.frameOffsets) <= 25,
  "infantry hold-frame count")
sequenceAssert(infantryPlan.frameOffsets[0] == 10 and infantryPlan.muzzleFlashes[0] == 26,
  "infantry attack111 muzzle")
for each infantryFlash in infantryPlan.muzzleFlashes
  sequenceAssert(infantryFlash == 26, "infantry held muzzle remains MZ2_INFANTRY_MACHINEGUN_1")
end for
sequenceAssert(attacksequences.modelFrameAt(infantryPlan, 0) == 184 and
  attacksequences.modelFrameAt(infantryPlan, 10) == 194 and
  attacksequences.modelFrameAt(infantryPlan, 10 + len(infantryPlan.frameOffsets) - 1) == 194 and
  attacksequences.modelFrameAt(infantryPlan, infantryPlan.durationFrames - 1) == 198,
  "infantry stock windup/held-fire/postfire model frames")
sequenceAssert(len(attacksequences.infantryPlanShots(10).frameOffsets) == 10 and
  len(attacksequences.infantryPlanShots(25).frameOffsets) == 25,
  "Infantry exact raw-rand shot-count builders")

gunnerPlan = attacksequences.gunnerChainPlan(2, 1)
sequenceAssert(attacksequences.validatePlan(gunnerPlan), "gunner chain validates")
sequenceAssert(len(gunnerPlan.muzzleFlashes) % 8 == 0, "gunner chain uses complete cycles")
gunnerIndex = 0
while gunnerIndex < len(gunnerPlan.muzzleFlashes)
  sequenceAssert(gunnerPlan.muzzleFlashes[gunnerIndex] == 45 + (gunnerIndex % 8),
    "gunner sequential muzzle " + gunnerIndex)
  gunnerIndex = gunnerIndex + 1
end while
sequenceAssert(attacksequences.modelFrameAt(gunnerPlan, 0) == 137 and
  attacksequences.modelFrameAt(gunnerPlan, 7) == 144 and
  attacksequences.modelFrameAt(gunnerPlan, 14) == 151 and
  attacksequences.modelFrameAt(gunnerPlan, gunnerPlan.durationFrames - 1) == 158,
  "gunner stock open/fire/close model frames")
gunnerOneCycle = attacksequences.gunnerChainPlanCycles(1)
gunnerTwoCycles = attacksequences.gunnerChainPlanCycles(2)
sequenceAssert(attacksequencebaseq2.monsterRefireDecisionOffset(gunnerOneCycle) == 15 and
  attacksequencebaseq2.monsterRefireDecisionOffset(gunnerTwoCycles) == 23 and
  gunnerTwoCycles.frameOffsets[8] == 15,
  "Gunner live refire decision fires the next chain frame immediately")
gunnerGrenades = attacksequences.gunnerGrenadePlan()
assertConsecutive(gunnerGrenades.muzzleFlashes, 53, 4, "gunner grenade muzzles")
sequenceAssert(gunnerGrenades.frameOffsets == [4, 7, 10, 13], "gunner grenade frames")
sequenceAssert(attacksequences.modelFrameAt(gunnerGrenades, 4) == 112 and
  attacksequences.modelFrameAt(gunnerGrenades, 13) == 121 and
  attacksequences.modelFrameAt(gunnerGrenades, 20) == 128,
  "gunner grenade model frames")

gladiatorRail = attacksequences.gladiatorRailPlan()
gladiatorCleaver = attacksequences.gladiatorMeleePlan()
sequenceAssert(gladiatorRail.frameOffsets == [3] and gladiatorRail.muzzleFlashes == [61] and
  attacksequences.modelFrameAt(gladiatorRail, 3) == 49 and
  gladiatorCleaver.frameOffsets == [6, 13] and attacksequences.modelFrameAt(gladiatorCleaver, 13) == 42,
  "Gladiator rail/cleaver stock frames")

berserkPlan = attacksequences.berserkMeleePlan(2, 1)
sequenceAssert((berserkPlan.name == "berserk-spike" and
    attacksequences.modelFrameAt(berserkPlan, 0) == 76 and
    attacksequences.modelFrameAt(berserkPlan, 7) == 83) or
  (berserkPlan.name == "berserk-club" and
    attacksequences.modelFrameAt(berserkPlan, 0) == 84 and
    attacksequences.modelFrameAt(berserkPlan, 11) == 95),
  "Berserk spike/club stock frames")
infantryPunch = attacksequences.infantryMeleePlan()
sequenceAssert(infantryPunch.frameOffsets == [5] and
  attacksequences.modelFrameAt(infantryPunch, 0) == 199 and
  attacksequences.modelFrameAt(infantryPunch, 7) == 206,
  "Infantry punch stock frames")

chickSlash = attacksequences.chickMeleePlan(2, 1)
sequenceAssert(chickSlash.frameOffsets[0] == 4 and
  attacksequences.modelFrameAt(chickSlash, 0) == 32 and
  attacksequences.modelFrameAt(chickSlash, 3) == 35 and
  attacksequences.modelFrameAt(chickSlash, chickSlash.durationFrames - 1) == 47,
  "Chick slash start/refire/end frames")
chickSlashTwoCycles = attacksequences.chickMeleePlanCycles(2)
sequenceAssert(attacksequencebaseq2.monsterRefireDecisionOffset(
    attacksequences.chickMeleePlanCycles(1)) == 11 and
  attacksequencebaseq2.monsterRefireDecisionOffset(chickSlashTwoCycles) == 20 and
  chickSlashTwoCycles.frameOffsets[1] == 13,
  "Chick slash live refire preserves its start-frame restart")
flyerSlashes = attacksequences.flyerMeleePlan()
sequenceAssert(len(flyerSlashes.frameOffsets) == 16 and
  attacksequences.modelFrameAt(flyerSlashes, 0) == 58 and
  attacksequences.modelFrameAt(flyerSlashes, 6) == 64 and
  attacksequences.modelFrameAt(flyerSlashes, flyerSlashes.durationFrames - 1) == 78,
  "Flyer slash start/refire/end frames")
flyerTwoCycles = attacksequences.flyerMeleePlanCycles(2)
sequenceAssert(attacksequencebaseq2.monsterRefireDecisionOffset(
    attacksequences.flyerMeleePlanCycles(1)) == 18 and
  attacksequencebaseq2.monsterRefireDecisionOffset(flyerTwoCycles) == 30 and
  flyerTwoCycles.frameOffsets[2] == 20,
  "Flyer live melee refire preserves the twelve-frame loop")
brainClaws = attacksequences.brainClawPlan()
brainTentacle = attacksequences.brainTentaclePlan(1)
sequenceAssert(brainClaws.frameOffsets == [7, 11] and
  attacksequences.modelFrameAt(brainClaws, 0) == 53 and
  attacksequences.modelFrameAt(brainClaws, 17) == 70 and
  brainTentacle.frameOffsets == [6, 18, 22] and
  attacksequences.eventDamage(brainTentacle, 0) == 12 and
  attacksequences.eventKnockback(brainTentacle, 0) == -600 and
  attacksequences.modelFrameAt(brainTentacle, 10) == 81 and
  attacksequences.modelFrameAt(brainTentacle, 11) == 53 and
  attacksequences.modelFrameAt(brainTentacle, 28) == 70,
  "Brain successful tentacle-to-claw stock transition")
floaterWham = attacksequences.floaterWhamPlan()
floaterZap = attacksequences.floaterZapPlan()
sequenceAssert(attacksequences.modelFrameAt(floaterWham, 0) == 45 and
  attacksequences.modelFrameAt(floaterWham, 24) == 69 and
  attacksequences.modelFrameAt(floaterZap, 0) == 70 and
  attacksequences.modelFrameAt(floaterZap, 33) == 103,
  "Floater wham/zap stock frames")
mutantClaws = attacksequences.mutantMeleePlan()
sequenceAssert(mutantClaws.frameOffsets[0] == 2 and mutantClaws.frameOffsets[1] == 5 and
  attacksequences.modelFrameAt(mutantClaws, 0) == 8 and
  attacksequences.modelFrameAt(mutantClaws, 7) == 8,
  "Mutant claw loop frames")
mutantTwoCycles = attacksequences.mutantMeleePlanCycles(2)
sequenceAssert(attacksequencebaseq2.monsterRefireDecisionOffset(
    attacksequences.mutantMeleePlanCycles(1)) == 6 and
  attacksequencebaseq2.monsterRefireDecisionOffset(mutantTwoCycles) == 13 and
  mutantTwoCycles.frameOffsets[2] == 9,
  "Mutant nextframe refire returns to attack09")
mutantJump = attacksequences.mutantJumpPlan()
sequenceAssert(mutantJump.frameOffsets == [2, 4] and mutantJump.attackKind == "jump" and
  attacksequences.modelFrameAt(mutantJump, 0) == 0 and
  attacksequences.modelFrameAt(mutantJump, 7) == 7,
  "Mutant stock attack03 takeoff and attack05 landing check")
parasiteDrain = attacksequences.parasiteDrainPlan()
sequenceAssert(len(parasiteDrain.frameOffsets) == 11 and
  attacksequences.eventDamage(parasiteDrain, 0) == 5 and
  attacksequences.eventDamage(parasiteDrain, 1) == 2 and
  attacksequences.modelFrameAt(parasiteDrain, 0) == 39 and
  attacksequences.modelFrameAt(parasiteDrain, 17) == 56,
  "Parasite drain frames and first-hit damage")
flipperBites = attacksequences.flipperBitePlan()
sequenceAssert(flipperBites.frameOffsets == [13, 18] and
  attacksequences.modelFrameAt(flipperBites, 0) == 0 and
  attacksequences.modelFrameAt(flipperBites, 19) == 19,
  "Flipper bite stock frames")

tankChain = attacksequences.tankMachinegunPlan("monster_tank")
tankBlasters = attacksequences.tankBlasterPlan("monster_tank", 2, 1, 1)
tankRockets = attacksequences.tankRocketPlan("monster_tank", 2, 1, 1)
sequenceAssert(len(tankChain.frameOffsets) == 19 and tankChain.frameOffsets[0] == 5 and
  tankChain.frameOffsets[18] == 23 and tankChain.muzzleFlashes[0] == 4 and
  tankChain.muzzleFlashes[18] == 22 and attacksequences.modelFrameAt(tankChain, 5) == 173 and
  attacksequences.modelFrameAt(tankChain, 28) == 196,
  "Tank machinegun sweep frames/muzzles")
sequenceAssert(tankBlasters.frameOffsets == [9, 12, 15] and tankBlasters.muzzleFlashes == [1, 2, 3] and
  attacksequences.modelFrameAt(tankBlasters, 9) == 64 and
  attacksequences.modelFrameAt(tankBlasters, 21) == 76,
  "Tank blaster frames/muzzles")
sequenceAssert(tankRockets.frameOffsets == [23, 26, 29] and tankRockets.muzzleFlashes == [23, 24, 25] and
  attacksequences.modelFrameAt(tankRockets, 23) == 138 and
  attacksequences.modelFrameAt(tankRockets, 52) == 167,
  "Tank rocket windup/fire/post frames")
tankBlasterHardOne = attacksequences.tankBlasterPlanCycles("monster_tank", 1, true)
tankBlasterHardTwo = attacksequences.tankBlasterPlanCycles("monster_tank", 2, true)
tankRocketHardOne = attacksequences.tankRocketPlanCycles("monster_tank", 1, true)
tankRocketHardTwo = attacksequences.tankRocketPlanCycles("monster_tank", 2, true)
sequenceAssert(attacksequencebaseq2.monsterRefireDecisionOffset(tankBlasterHardOne) == 16 and
  attacksequencebaseq2.monsterRefireDecisionOffset(tankBlasterHardTwo) == 22 and
  tankBlasterHardTwo.frameOffsets[3] == 18 and
  attacksequencebaseq2.monsterRefireDecisionOffset(tankRocketHardOne) == 30 and
  attacksequencebaseq2.monsterRefireDecisionOffset(tankRocketHardTwo) == 39 and
  tankRocketHardTwo.frameOffsets[3] == 32,
  "Tank hard-mode live blaster and rocket refire points")

medicPlan = attacksequences.medicBlasterPlan(2, 1)
sequenceAssert(medicPlan.frameOffsets[0] == 8 and medicPlan.frameOffsets[1] == 11 and
  attacksequences.modelFrameAt(medicPlan, 8) == 185 and
  attacksequences.modelFrameAt(medicPlan, medicPlan.durationFrames - 1) == 206,
  "Medic blaster/hyperblaster frames")
if len(medicPlan.frameOffsets) > 2 then
  sequenceAssert(attacksequences.eventUsesHyperblasterEffect(medicPlan, 2) and
    not attacksequences.eventUsesHyperblasterEffect(medicPlan, 3) and
    attacksequences.eventUsesHyperblasterEffect(medicPlan, 5),
    "Medic hyperblaster trail cadence")
end if
medicBase = attacksequences.medicBlasterPlanContinue(false)
medicHyper = attacksequences.medicBlasterPlanContinue(true)
sequenceAssert(attacksequencebaseq2.monsterRefireDecisionOffset(medicBase) == 13 and
  attacksequencebaseq2.monsterRefireDecisionOffset(medicHyper) == -1 and
  medicHyper.frameOffsets[2] == 18,
  "Medic performs one live continue decision before attack19 hyperfire")
chickPlan = attacksequences.chickRocketPlan(2, 1)
sequenceAssert(chickPlan.frameOffsets[0] == 13 and chickPlan.muzzleFlashes[0] == 57 and
  attacksequences.modelFrameAt(chickPlan, 13) == 13 and
  attacksequences.modelFrameAt(chickPlan, chickPlan.durationFrames - 1) == 31,
  "Chick rocket refire frames")
chickRocketTwoCycles = attacksequences.chickRocketPlanCycles(2)
sequenceAssert(attacksequencebaseq2.monsterRefireDecisionOffset(
    attacksequences.chickRocketPlanCycles(1)) == 26 and
  attacksequencebaseq2.monsterRefireDecisionOffset(chickRocketTwoCycles) == 40 and
  chickRocketTwoCycles.frameOffsets[1] == 27,
  "Chick live rocket refire restarts at attack114")
flyerPlan = attacksequences.flyerBlasterPlan()
sequenceAssert(flyerPlan.frameOffsets == [3, 4, 5, 6, 7, 8, 9, 10] and
  flyerPlan.muzzleFlashes == [58, 59, 58, 59, 58, 59, 58, 59] and
  attacksequences.modelFrameAt(flyerPlan, 3) == 82,
  "Flyer alternating blaster frames")
sequenceAssert(attacksequences.eventUsesHyperblasterEffect(flyerPlan, 0) and
  attacksequences.eventUsesHyperblasterEffect(flyerPlan, 3) and
  attacksequences.eventUsesHyperblasterEffect(flyerPlan, 6) and
  not attacksequences.eventUsesHyperblasterEffect(flyerPlan, 7),
  "Flyer exact hyperblaster trail frames")
floaterPlan = attacksequences.floaterBlasterPlan()
sequenceAssert(len(floaterPlan.frameOffsets) == 7 and attacksequences.modelFrameAt(floaterPlan, 3) == 34,
  "Floater blaster burst frames")
sequenceAssert(attacksequences.eventUsesHyperblasterEffect(floaterPlan, 0) and
  attacksequences.eventUsesHyperblasterEffect(floaterPlan, 3) and
  not attacksequences.eventUsesHyperblasterEffect(floaterPlan, 1),
  "Floater exact hyperblaster trail frames")
hoverPlan = attacksequences.hoverBlasterPlan(2, 1)
sequenceAssert(hoverPlan.frameOffsets[0] == 3 and hoverPlan.frameOffsets[1] == 4 and
  attacksequences.modelFrameAt(hoverPlan, 3) == 200 and
  attacksequences.modelFrameAt(hoverPlan, hoverPlan.durationFrames - 1) == 204,
  "Hover blaster refire frames")
sequenceAssert(attacksequences.eventUsesHyperblasterEffect(hoverPlan, 0) and
  not attacksequences.eventUsesHyperblasterEffect(hoverPlan, 1),
  "Hover first bolt of each pair uses hyperblaster trail")
hoverTwoCycles = attacksequences.hoverBlasterPlanCycles(2)
sequenceAssert(attacksequencebaseq2.monsterRefireDecisionOffset(
    attacksequences.hoverBlasterPlanCycles(1)) == 5 and
  attacksequencebaseq2.monsterRefireDecisionOffset(hoverTwoCycles) == 8 and
  hoverTwoCycles.frameOffsets[2] == 6,
  "Hover live refire restarts on the next frame")
supertankChain = attacksequences.supertankMachinegunPlan(2, 1)
supertankRockets = attacksequences.supertankRocketPlan()
sequenceAssert(supertankChain.muzzleFlashes[0] == 64 and supertankChain.muzzleFlashes[5] == 69 and
  attacksequences.modelFrameAt(supertankChain, 0) == 0 and
  attacksequences.modelFrameAt(supertankChain, supertankChain.durationFrames - 1) == 19,
  "Supertank machinegun refire frames")
supertankTwoCycles = attacksequences.supertankMachinegunPlanCycles(2)
sequenceAssert(attacksequencebaseq2.monsterRefireDecisionOffset(
    attacksequences.supertankMachinegunPlanCycles(1)) == 6 and
  attacksequencebaseq2.monsterRefireDecisionOffset(supertankTwoCycles) == 12 and
  supertankTwoCycles.frameOffsets[6] == 6,
  "Supertank live machinegun refire fires again on the decision tick")
sequenceAssert(supertankRockets.frameOffsets == [7, 10, 13] and
  supertankRockets.muzzleFlashes == [70, 71, 72] and
  attacksequences.modelFrameAt(supertankRockets, 7) == 27,
  "Supertank rocket frames")

soldierLight1 = attacksequences.planByName("monster_soldier_light", "soldier-light-attack1", 2, 1)
soldierLight2 = attacksequences.planByName("monster_soldier_light", "soldier-light-attack2", 2, 1)
sequenceAssert(soldierLight1.frameOffsets == [2] and soldierLight1.muzzleFlashes == [39],
  "soldier light attack1 frame/muzzle")
sequenceAssert(soldierLight2.frameOffsets == [4] and soldierLight2.muzzleFlashes == [40],
  "soldier light attack2 frame/muzzle")
soldierLight1Two = attacksequences.soldierLightPlanCycles("monster_soldier_light", false, 2)
soldierLight2Two = attacksequences.soldierLightPlanCycles("monster_soldier_light", true, 2)
sequenceAssert(soldierLight1Two.frameOffsets == [2, 7] and
  attacksequencebaseq2.monsterRefireDecisionOffset(soldierLight1Two) == 10 and
  attacksequences.modelFrameAt(soldierLight1Two, 6) == 1 and
  attacksequences.modelFrameAt(soldierLight1Two, 11) == 9 and
  soldierLight2Two.frameOffsets == [4, 9] and
  attacksequencebaseq2.monsterRefireDecisionOffset(soldierLight2Two) == 12 and
  attacksequences.modelFrameAt(soldierLight2Two, 8) == 15,
  "light Soldier exact attack102/attack204 nextframe loops")
soldierShotgun2 = attacksequences.planByName("monster_soldier", "soldier-shotgun-attack2", 2, 1)
sequenceAssert(soldierShotgun2.muzzleFlashes == [42] and soldierShotgun2.count == 12,
  "soldier shotgun attack2 payload")
soldierShotgun1Two = attacksequences.soldierShotgunPlanCycles("monster_soldier", false, 2)
soldierShotgun2Two = attacksequences.soldierShotgunPlanCycles("monster_soldier", true, 2)
sequenceAssert(soldierShotgun1Two.frameOffsets == [2, 10] and
  attacksequencebaseq2.monsterRefireDecisionOffset(soldierShotgun1Two) == 16 and
  attacksequences.modelFrameAt(soldierShotgun1Two, 9) == 1 and
  soldierShotgun2Two.frameOffsets == [4, 16] and
  attacksequencebaseq2.monsterRefireDecisionOffset(soldierShotgun2Two) == 26 and
  attacksequences.modelFrameAt(soldierShotgun2Two, 15) == 15,
  "shotgun Soldier exact post-cock nextframe loops")
soldierMachinegun = attacksequences.soldierPlan("monster_soldier_ss", 2, 1)
sequenceAssert(len(soldierMachinegun.muzzleFlashes) >= 3 and len(soldierMachinegun.muzzleFlashes) <= 10,
  "soldier machinegun hold count")
for each soldierFlash in soldierMachinegun.muzzleFlashes
  sequenceAssert(soldierFlash == 88, "soldier attack4 uses fourth machinegun muzzle")
end for
sequenceAssert(attacksequences.modelFrameAt(soldierMachinegun, 0) == 39 and
  attacksequences.modelFrameAt(soldierMachinegun, 2) == 41 and
  attacksequences.modelFrameAt(soldierMachinegun, 2 + len(soldierMachinegun.frameOffsets) - 1) == 41 and
  attacksequences.modelFrameAt(soldierMachinegun, soldierMachinegun.durationFrames - 1) == 44,
  "soldier held machinegun model frames")
sequenceAssert(len(attacksequences.soldierMachinegunPlanShots("monster_soldier_ss", 3).frameOffsets) == 3 and
  len(attacksequences.soldierMachinegunPlanShots("monster_soldier_ss", 10).frameOffsets) == 10,
  "machinegun Soldier exact raw-rand shot-count builders")
soldierDuckLight = attacksequences.soldierDuckShootPlan("monster_soldier_light")
soldierDuckShotgun = attacksequences.soldierDuckShootPlan("monster_soldier")
soldierDuckMachinegun = attacksequences.soldierDuckShootPlan("monster_soldier_ss")
sequenceAssert(soldierDuckLight.frameOffsets == [2, 6] and
  soldierDuckLight.muzzleFlashes == [83, 83] and
  soldierDuckShotgun.muzzleFlashes == [84, 84] and soldierDuckShotgun.count == 12 and
  soldierDuckMachinegun.muzzleFlashes == [85, 85] and
  attacksequences.modelFrameAt(soldierDuckLight, 0) == 30 and
  attacksequences.modelFrameAt(soldierDuckLight, 6) == 32 and
  attacksequences.modelFrameAt(soldierDuckLight, 10) == 36 and
  attacksequences.modelFrameAt(soldierDuckLight, 12) == 38,
  "Soldier attack3 exact duck/refire frames and third muzzle set")
soldierRunShoot = attacksequences.soldierRunShootPlanCycles("monster_soldier_light", 1)
soldierRunShootTwo = attacksequences.soldierRunShootPlanCycles("monster_soldier_ss", 2)
sequenceAssert(soldierRunShoot.frameOffsets == [3] and soldierRunShoot.muzzleFlashes == [98] and
  soldierRunShootTwo.frameOffsets == [3, 15] and soldierRunShootTwo.muzzleFlashes == [100, 100] and
  attacksequencebaseq2.monsterRefireDecisionOffset(soldierRunShootTwo) == 25 and
  attacksequences.modelFrameAt(soldierRunShootTwo, 0) == 109 and
  attacksequences.modelFrameAt(soldierRunShootTwo, 14) == 111 and
  attacksequences.modelFrameAt(soldierRunShootTwo, 15) == 112 and
  attacksequences.modelFrameAt(soldierRunShootTwo, 25) == 122 and
  movementTotal(soldierRunShoot) == 168.0 and movementTotal(soldierRunShootTwo) == 322.0,
  "Soldier attack6 exact run distances, eighth muzzle set and runs03 loop")
sequenceAssert(not attacksequences.soldierDodgeUsesAttack(0, 0.0) and
  attacksequences.soldierDodgeUsesAttack(1, 0.33) and
  not attacksequences.soldierDodgeUsesAttack(1, 0.3301) and
  attacksequences.soldierDodgeUsesAttack(2, 0.66) and
  not attacksequences.soldierDodgeUsesAttack(3, 0.6601),
  "Soldier skill-specific duck/attack3 random boundaries")

jorgAttackPlan = attacksequences.jorgPlan(7, 1)
sequenceAssert(len(jorgAttackPlan.muzzleFlashes) % 12 == 0, "Jorg complete six-frame paired cycle")
jorgIndex = 0
while jorgIndex < len(jorgAttackPlan.muzzleFlashes)
  expectedJorg = 120
  if jorgIndex % 2 == 1 then expectedJorg = 126 end if
  sequenceAssert(jorgAttackPlan.muzzleFlashes[jorgIndex] == expectedJorg, "Jorg paired barrels")
  jorgIndex = jorgIndex + 1
end while
sequenceAssert(attacksequences.modelFrameAt(jorgAttackPlan, 0) == 0 and
  attacksequences.modelFrameAt(jorgAttackPlan, 8) == 8 and
  attacksequences.modelFrameAt(jorgAttackPlan, jorgAttackPlan.durationFrames - 1) == 17,
  "Jorg stock start/fire/end model frames")
jorgOneCycle = attacksequences.jorgPlanCycles(1)
jorgTwoCycles = attacksequences.jorgPlanCycles(2)
sequenceAssert(len(jorgOneCycle.frameOffsets) == 12 and len(jorgTwoCycles.frameOffsets) == 24 and
  jorgOneCycle.frameOffsets[0] == 8 and jorgOneCycle.frameOffsets[11] == 13 and
  jorgTwoCycles.frameOffsets[12] == 14 and
  attacksequencebaseq2.monsterRefireDecisionOffset(jorgOneCycle) == 14 and
  attacksequencebaseq2.monsterRefireDecisionOffset(jorgTwoCycles) == 20,
  "Jorg live refire cycle extension points")
boss2Rockets = attacksequences.boss2RocketPlan()
boss2Machineguns = attacksequences.boss2MachinegunPlan(7, 1)
sequenceAssert(len(boss2Machineguns.muzzleFlashes) % 10 == 0,
  "Boss2 complete five-fire-frame paired cycle")
boss2Index = 0
while boss2Index < len(boss2Machineguns.muzzleFlashes)
  expectedBoss2 = 73
  if boss2Index % 2 == 1 then expectedBoss2 = 133 end if
  sequenceAssert(boss2Machineguns.muzzleFlashes[boss2Index] == expectedBoss2,
    "Boss2 paired barrels")
  boss2Index = boss2Index + 1
end while
sequenceAssert(attacksequences.modelFrameAt(boss2Machineguns, 9) == 79 and
  attacksequences.modelFrameAt(boss2Machineguns, boss2Machineguns.durationFrames - 1) == 88,
  "Boss2 stock start/fire/end machinegun frames")
boss2OneCycle = attacksequences.boss2MachinegunPlanCycles(1)
boss2TwoCycles = attacksequences.boss2MachinegunPlanCycles(2)
sequenceAssert(len(boss2OneCycle.frameOffsets) == 10 and len(boss2TwoCycles.frameOffsets) == 20 and
  boss2OneCycle.frameOffsets[0] == 9 and boss2OneCycle.frameOffsets[9] == 13 and
  boss2TwoCycles.frameOffsets[10] == 15 and
  attacksequencebaseq2.monsterRefireDecisionOffset(boss2OneCycle) == 14 and
  attacksequencebaseq2.monsterRefireDecisionOffset(boss2TwoCycles) == 20,
  "Boss2 live refire decision and next-cycle separation")
sequenceAssert(boss2Rockets.frameOffsets == [12, 12, 12, 12], "Boss2 simultaneous rocket frame")
assertConsecutive(boss2Rockets.muzzleFlashes, 78, 4, "Boss2 rocket muzzles")
sequenceAssert(attacksequences.modelFrameAt(boss2Rockets, 12) == 101 and
  attacksequences.modelFrameAt(boss2Rockets, boss2Rockets.durationFrames - 1) == 109,
  "Boss2 rocket model frames")
jorgBfg = attacksequences.jorgBfgPlan()
sequenceAssert(jorgBfg.attackKind == "bfg" and jorgBfg.frameOffsets == [6] and
  jorgBfg.muzzleFlashes == [132], "Jorg BFG attack2")
makronBfg = attacksequences.makronBfgPlan()
makronHyper = attacksequences.makronHyperblasterPlan()
makronRail = attacksequences.makronRailPlan()
sequenceAssert(makronBfg.frameOffsets == [3] and makronBfg.muzzleFlashes == [101], "Makron BFG frame")
sequenceAssert(len(makronHyper.frameOffsets) == 17 and makronHyper.frameOffsets[0] == 4 and
  makronHyper.frameOffsets[16] == 20, "Makron hyperblaster frames")
for each makronFlash in makronHyper.muzzleFlashes
  sequenceAssert(makronFlash == 102, "Makron 3.19 hyperblaster uses constant wire flash")
end for
sequenceAssert(attacksequences.eventSourceFlash(makronHyper, 0) == 102 and
  attacksequences.eventSourceFlash(makronHyper, 16) == 118,
  "Makron hyperblaster uses consecutive projectile-source offsets")
sequenceAssert(makronRail.frameOffsets == [8] and makronRail.muzzleFlashes == [119], "Makron rail frame")
sequenceAssert(attacksequences.modelFrameAt(makronBfg, 3) == 204 and
  attacksequences.modelFrameAt(makronHyper, 4) == 213 and
  attacksequences.modelFrameAt(makronHyper, 20) == 229 and
  attacksequences.modelFrameAt(makronRail, 8) == 243,
  "Makron stock attack model frames")

// The C mframe_t movement column is part of an attack, not just visual pose.
// Verify direct, held-frame and composite callback moves without rebuilding
// any arrays in the live lookup path.
sequenceNear(attacksequences.movementDistanceAt(infantryPlan, 0), 4.0,
  "Infantry attack first charge distance")
sequenceNear(attacksequences.movementDistanceAt(infantryPlan, 11), 0.0,
  "Infantry held attack111 suppresses repeated distance")
sequenceNear(attacksequences.movementDistanceAt(infantryPlan,
  10 + len(infantryPlan.frameOffsets)), 5.0, "Infantry postfire resumes frame distance")
sequenceNear(movementTotal(infantryPlan), 0.0, "Infantry complete attack displacement")
sequenceNear(movementTotal(infantryPunch), 39.0, "Infantry punch advances 39 units")
sequenceNear(movementTotal(attacksequences.medicBlasterPlanContinue(true)), 15.0,
  "Medic blaster advances during windup only")
sequenceNear(movementTotal(attacksequences.chickRocketPlanCycles(2)), 77.0,
  "Chick two-rocket live chain movement")
sequenceNear(movementTotal(attacksequences.chickMeleePlanCycles(2)), 1.0,
  "Chick two-slash live chain movement")
sequenceNear(movementTotal(flyerPlan), -80.0, "Flyer firing recoil movement")
sequenceNear(movementTotal(brainClaws), 0.0, "Brain claw balanced movement")
sequenceNear(movementTotal(brainTentacle), 0.0, "Brain conditional chain balanced movement")
sequenceNear(movementTotal(attacksequences.hoverBlasterPlanCycles(1)), -15.0,
  "Hover blaster recoil movement")
sequenceNear(movementTotal(mutantJump), 65.0, "Mutant jump animation charge movement")
sequenceNear(movementTotal(parasiteDrain), -2.0, "Parasite drain movement")
sequenceNear(movementTotal(attacksequences.tankBlasterPlanCycles("monster_tank", 2, true)), 0.0,
  "Tank repeated blaster movement")
sequenceNear(movementTotal(attacksequences.tankRocketPlanCycles("monster_tank", 2, true)), -4.0,
  "Tank repeated rocket movement")
sequenceNear(movementTotal(boss2Machineguns), boss2Machineguns.durationFrames,
  "Boss2 machinegun charges one unit per frame")
sequenceNear(movementTotal(boss2Rockets), 0.0, "Boss2 rocket recoil balances its charge")
sequenceAssert(attacksequences.movementAiAt(tankChain, 4) == attacksequences.ATTACK_AI_CHARGE and
  attacksequences.movementAiAt(tankChain, 5) == attacksequences.ATTACK_AI_NONE and
  attacksequences.movementAiAt(tankChain, 24) == attacksequences.ATTACK_AI_CHARGE and
  attacksequences.movementAiAt(tankBlasters, 16) == attacksequences.ATTACK_AI_MOVE and
  attacksequences.movementAiAt(boss2Rockets, 12) == attacksequences.ATTACK_AI_MOVE and
  attacksequences.movementAiAt(makronRail, 8) == attacksequences.ATTACK_AI_MOVE,
  "stock attack ai_charge/NULL/ai_move boundaries")
sequenceAssert(attacksequences.frameSoundAt(infantryPlan, 3) == "infantry/infatck3.wav" and
  attacksequences.frameSoundAt(gunnerOneCycle, 0) == "gunner/gunatck1.wav" and
  attacksequences.frameSoundAttenuationAt(gunnerOneCycle, 0) == 2 and
  attacksequences.frameSoundAt(attacksequences.chickRocketPlanCycles(2), 20) ==
    "chick/chkatck5.wav" and
  attacksequences.frameSoundAt(attacksequences.chickRocketPlanCycles(2), 34) ==
    "chick/chkatck5.wav" and
  attacksequences.frameSoundAt(brainTentacle, 4) == "brain/brnatck1.wav" and
  attacksequences.frameSoundAt(brainTentacle, 15) == "brain/melee1.wav" and
  attacksequences.frameSoundAt(parasiteDrain, 13) == "parasite/paratck4.wav" and
  attacksequences.frameSoundAt(tankRockets, 15) == "tank/step.wav" and
  attacksequences.frameSoundAt(makronRail, 0) == "makron/rail_up.wav",
  "stock attack mechanical sound callback offsets")

movementContext = attacksequenceaitypes.defaultContext()
movementEnemy = attacksequenceaitypes.createClientTarget(301)
movementEnemy.edict.state.origin = attacksequenceqtypes.Vec3(1000.0, 0.0, 0.0)
movementActor = attacksequenceaitypes.createActor(300, "monster_infantry")
movementActor.enemy = movementEnemy
movementActor.edict.state.origin = attacksequenceqtypes.Vec3(0.0, 0.0, 0.0)
movementActor.edict.state.angles = attacksequenceqtypes.Vec3(0.0, 0.0, 0.0)
attacksequencebaseq2.applyMonsterAttackMovement(movementActor, infantryPunch, 0, movementContext)
attacksequencebaseq2.applyMonsterAttackMovement(movementActor, infantryPunch, 1, movementContext)
sequenceNear(movementActor.edict.state.origin.x, 9.0,
  "integrated attack movement executes exact consecutive charge distances")
attacksequencebaseq2.applyMonsterAttackMovement(movementActor, boss2Rockets, 12, movementContext)
sequenceNear(movementActor.edict.state.origin.x, -11.0,
  "integrated ai_move recoil retains actor yaw instead of charging toward target")

sequenceAssert(attacksequences.selectionRandomKind("monster_jorg", 500.0) == 1 and
  attacksequences.selectionRandomKind("monster_boss2", 100.0) == 0 and
  attacksequences.selectionRandomKind("monster_berserk", 40.0) == 2 and
  attacksequences.selectionRandomKind("monster_tank", 40.0) == 1 and
  attacksequences.selectionRandomKind("monster_soldier_ss", 500.0) == 0,
  "stock attack selection consumes only the original random draw kind")
sequenceAssert(attacksequences.berserkPlanWithRaw(40).name == "berserk-spike" and
  attacksequences.berserkPlanWithRaw(41).name == "berserk-club",
  "Berserk uses exact raw rand parity")
sequenceAssert(attacksequences.gunnerPlanWithRoll(7, 1, 81.0, 0.5).name == "gunner-grenade" and
  attacksequences.gunnerPlanWithRoll(7, 1, 81.0, 0.5001).name == "gunner-chain" and
  attacksequences.gunnerPlanWithRoll(7, 1, 80.0, 0.0).name == "gunner-grenade" and
  attacksequences.gunnerPlanWithRoll(7, 1, 79.999, 0.0).name == "gunner-chain",
  "Gunner exact selection range and random boundary")
sequenceAssert(attacksequences.soldierPlanWithRoll("monster_soldier_light", 7, 1, 0.4999).name ==
    "soldier-light-attack1" and
  attacksequences.soldierPlanWithRoll("monster_soldier_light", 7, 1, 0.5).name ==
    "soldier-light-attack2",
  "Soldier exact attack-layout random boundary")
sequenceAssert(attacksequences.brainPlanWithRoll(1, 0.5).name == "brain-claws" and
  attacksequences.brainPlanWithRoll(1, 0.5001).name == "brain-tentacle",
  "Brain exact melee random boundary defers chaining until fire_hit")
sequenceAssert(attacksequences.floaterPlanWithRoll(79.999, 0.4999).name == "floater-zap" and
  attacksequences.floaterPlanWithRoll(79.999, 0.5).name == "floater-wham" and
  attacksequences.floaterPlanWithRoll(80.0, 0.0).name == "floater-blasters",
  "Floater exact melee selection boundary")
sequenceAssert(attacksequences.supertankPlanWithRoll(7, 1, 160.0, 1.0).name ==
    "supertank-machinegun" and
  attacksequences.supertankPlanWithRoll(7, 1, 160.1, 0.2999).name ==
    "supertank-machinegun" and
  attacksequences.supertankPlanWithRoll(7, 1, 160.1, 0.3).name == "supertank-rockets",
  "Supertank exact range and random boundary")
jorgRandomLow = attacksequences.jorgPlanWithRoll(7, 1, 0.75)
jorgRandomHigh = attacksequences.jorgPlanWithRoll(7, 1, 0.7501)
sequenceAssert(jorgRandomLow is not void, "Jorg low randomized plan exists")
sequenceAssert(jorgRandomHigh is not void, "Jorg high randomized plan exists")
sequenceAssert(jorgRandomLow.name == "jorg-machineguns" and jorgRandomHigh.name == "jorg-bfg",
  "Jorg exact random boundary")
boss2RandomNear = attacksequences.boss2PlanWithRoll(7, 1, 100.0, 1.0)
boss2RandomLow = attacksequences.boss2PlanWithRoll(7, 1, 500.0, 0.6)
boss2RandomHigh = attacksequences.boss2PlanWithRoll(7, 1, 500.0, 0.6001)
sequenceAssert(boss2RandomNear is not void and boss2RandomLow is not void and boss2RandomHigh is not void,
  "Boss2 randomized plans exist")
sequenceAssert(boss2RandomNear.name == "boss2-machineguns" and
  boss2RandomLow.name == "boss2-machineguns" and boss2RandomHigh.name == "boss2-rockets",
  "Boss2 range and exact random boundary")
makronRandomLow = attacksequences.makronPlanWithRoll(0.3)
makronRandomMiddle = attacksequences.makronPlanWithRoll(0.6)
makronRandomHigh = attacksequences.makronPlanWithRoll(0.6001)
sequenceAssert(makronRandomLow is not void and makronRandomMiddle is not void and makronRandomHigh is not void,
  "Makron randomized plans exist")
sequenceAssert(makronRandomLow.name == "makron-bfg" and
  makronRandomMiddle.name == "makron-hyperblaster" and makronRandomHigh.name == "makron-rail",
  "Makron exact random boundaries")

// Server and client now consume the same exact m_flash.c table. At yaw zero,
// G_ProjectSource maps forward to +X and right to -Y.
muzzleActor = attacksequenceaitypes.createActor(17, "monster_boss2")
muzzleActor.edict.state.origin = attacksequenceqtypes.Vec3(10.0, 20.0, 30.0)
muzzleActor.edict.state.angles = attacksequenceqtypes.Vec3(0.0, 0.0, 0.0)
muzzleStart = attacksequencebaseq2.monsterMuzzleStart(muzzleActor, 73)
sequenceNear(muzzleStart.x, 14.6, "Boss2 exact muzzle X")
sequenceNear(muzzleStart.y, 18.85, "Boss2 exact muzzle Y")
sequenceNear(muzzleStart.z, 13.2, "Boss2 exact muzzle Z")
parasiteStart = attacksequencebaseq2.monsterProjectedStart(muzzleActor,
  attacksequenceqtypes.Vec3(24.0, 0.0, 6.0))
sequenceNear(parasiteStart.x, 34.0, "Parasite private muzzle X")
sequenceNear(parasiteStart.y, 20.0, "Parasite private muzzle Y")
sequenceNear(parasiteStart.z, 36.0, "Parasite private muzzle Z")
floaterZapStart = attacksequencebaseq2.monsterProjectedStart(muzzleActor,
  attacksequenceqtypes.Vec3(18.5, -0.9, 10.0))
sequenceNear(floaterZapStart.x, 28.5, "Floater zap private muzzle X")
sequenceNear(floaterZapStart.y, 20.9, "Floater zap private muzzle Y")
sequenceNear(floaterZapStart.z, 40.0, "Floater zap private muzzle Z")
sequenceAssert(attacksequencebaseq2.parasiteDrainPointOk(
    attacksequenceqtypes.Vec3(0.0, 0.0, 0.0), attacksequenceqtypes.Vec3(256.0, 0.0, 0.0)),
  "Parasite accepts exact 256-unit horizontal drain")
sequenceAssert(not attacksequencebaseq2.parasiteDrainPointOk(
    attacksequenceqtypes.Vec3(0.0, 0.0, 0.0), attacksequenceqtypes.Vec3(256.01, 0.0, 0.0)),
  "Parasite rejects drain beyond 256 units")
sequenceAssert(not attacksequencebaseq2.parasiteDrainPointOk(
    attacksequenceqtypes.Vec3(0.0, 0.0, 0.0), attacksequenceqtypes.Vec3(100.0, 0.0, 70.0)),
  "Parasite rejects drain pitch beyond 30 degrees")
meleeAimActor = attacksequenceaitypes.createActor(18, "monster_brain")
meleeAimActor.mins[0] = -24.0; meleeAimActor.maxs[0] = 24.0
brainRightAim = attacksequencebaseq2.monsterMeleeAim(meleeAimActor, brainClaws, 0)
brainLeftAim = attacksequencebaseq2.monsterMeleeAim(meleeAimActor, brainClaws, 1)
mutantLeftAim = attacksequencebaseq2.monsterMeleeAim(meleeAimActor, mutantClaws, 0)
mutantRightAim = attacksequencebaseq2.monsterMeleeAim(meleeAimActor, mutantClaws, 1)
sequenceAssert(brainRightAim.y == 24.0 and brainLeftAim.y == -24.0 and
  brainRightAim.z == 8.0 and mutantLeftAim.y == -24.0 and mutantRightAim.y == 24.0,
  "fire_hit uses exact left/right claw aim offsets")
damageRandom = attacksequencerandom.create(1)
sequenceAssert(attacksequencebaseq2.monsterAttackDamageFromState(damageRandom,
    attacksequences.gladiatorMeleePlan(), 0) == 21,
  "Gladiator consumes exact rand percent-five damage")
damageRandom = attacksequencerandom.create(1)
sequenceAssert(attacksequencebaseq2.monsterAttackDamageFromState(damageRandom,
    attacksequences.infantryMeleePlan(), 0) == 6,
  "Infantry consumes exact rand percent-five damage")
damageRandom = attacksequencerandom.create(1)
sequenceAssert(attacksequencebaseq2.monsterAttackDamageFromState(damageRandom,
    attacksequences.chickMeleePlan(1, 1), 0) == 15,
  "Chick consumes exact rand percent-six damage")
aimStart = attacksequenceqtypes.Vec3(0.0, 0.0, 0.0)
aimDestination = attacksequenceqtypes.Vec3(100.0, 0.0, 0.0)
aimEnemy = attacksequencebaseq2.monsterWeaponTarget(
  attacksequenceaitypes.createClientTarget(18))
muzzleActor.enemy = attacksequenceaitypes.createClientTarget(18)
muzzleActor.enemy.viewHeight = 22.0
aimEnemy.origin = attacksequenceqtypes.Vec3(100.0, 20.0, 30.0)
aimPoint = attacksequencebaseq2.monsterEnemyAimPoint(muzzleActor, aimEnemy)
sequenceNear(aimPoint.z, 52.0, "monster aim reaches player view height")
gunnerStraight = attacksequencebaseq2.monsterAttackDirection(muzzleActor,
  attacksequences.gunnerGrenadePlan(), 0, aimStart, aimDestination, [0.0, 0.0, 0.0])
sequenceNear(gunnerStraight.x, 1.0, "Gunner grenade straight-forward X")
sequenceNear(gunnerStraight.y, 0.0, "Gunner grenade straight-forward Y")
gunnerLead = attacksequencebaseq2.monsterAttackDirection(muzzleActor,
  attacksequences.gunnerChainPlan(2, 1), 0, aimStart, aimDestination, [0.0, 10.0, 0.0])
sequenceAssert(gunnerLead.y < -0.019 and gunnerLead.y > -0.021,
  "Gunner machinegun leads target back by 0.2 seconds")
tankSweepFirst = attacksequencebaseq2.monsterAttackDirection(muzzleActor,
  tankChain, 0, aimStart, aimDestination, [0.0, 0.0, 0.0])
tankSweepMiddle = attacksequencebaseq2.monsterAttackDirection(muzzleActor,
  tankChain, 9, aimStart, aimDestination, [0.0, 0.0, 0.0])
tankSweepLast = attacksequencebaseq2.monsterAttackDirection(muzzleActor,
  tankChain, 18, aimStart, aimDestination, [0.0, 0.0, 0.0])
sequenceNear(tankSweepFirst.x, 0.766044, "Tank sweep first X")
sequenceNear(tankSweepFirst.y, 0.642788, "Tank sweep first +40 yaw")
sequenceNear(tankSweepMiddle.x, 0.848048, "Tank sweep middle X")
sequenceNear(tankSweepMiddle.y, -0.529919, "Tank sweep middle -32 yaw")
sequenceNear(tankSweepLast.y, 0.642788, "Tank sweep returns to +40 yaw")
makronSweepFirst = attacksequencebaseq2.monsterAttackDirection(muzzleActor,
  makronHyper, 0, aimStart, aimDestination, [0.0, 0.0, 0.0])
makronSweepCenter = attacksequencebaseq2.monsterAttackDirection(muzzleActor,
  makronHyper, 8, aimStart, aimDestination, [0.0, 0.0, 0.0])
makronSweepSecond = attacksequencebaseq2.monsterAttackDirection(muzzleActor,
  makronHyper, 9, aimStart, aimDestination, [0.0, 0.0, 0.0])
sequenceNear(makronSweepFirst.y, 0.984808, "Makron sweep starts at +80 yaw")
sequenceNear(makronSweepCenter.y, 0.0, "Makron sweep reaches center")
sequenceNear(makronSweepSecond.y, -0.939693, "Makron sweep restarts at -70 yaw")
soldierSpreadState = attacksequencerandom.create(1)
soldierSpread = attacksequencebaseq2.monsterSoldierAttackDirection(soldierSpreadState,
  attacksequenceqtypes.Vec3(0.0, 0.0, 0.0), attacksequenceqtypes.Vec3(100.0, 0.0, 0.0))
sequenceAssert(soldierSpread.x > 0.992 and soldierSpread.x < 0.994 and
  soldierSpread.y > 0.120 and soldierSpread.y < 0.122 and
  soldierSpread.z > 0.007 and soldierSpread.z < 0.009 and
  soldierSpreadState.seed == 3357800067,
  "Soldier outer crandom spread consumes two exact CRT values")

// Product-shaped GameImport integration: a real Gunner chain must emit all
// eight svc_muzzleflash2 messages, in order, instead of one approximation.
sequenceServer = attacksequencebridge.createRuntime(4)
sequenceApi = attacksequencegame.GetGameApi(attacksequencebridge.makeImports(sequenceServer))
sequenceServer.game = sequenceApi
sequenceApi.init()
sequenceFixture = "{\"classname\" \"worldspawn\"}" +
  "{\"classname\" \"info_player_start\" \"origin\" \"0 0 0\"}" +
  "{\"classname\" \"monster_gunner\" \"origin\" \"160 0 10\" \"angle\" \"180\"}"
sequenceApi.spawnEntities("attack-sequence", sequenceFixture, "")
sequenceClient = sequenceApi.edicts[1]
sequenceAssert(sequenceApi.clientConnect(sequenceClient, "\\name\\BurstTarget\\skin\\male/grunt"), "client connect")
sequenceAssert(sequenceApi.clientBegin(sequenceClient), "client begin")
sequencePlayer = attacksequencegame.playerContext().players[0]
sequenceAssert(len(attacksequencegame.baseRuntime().aiPlayers) == 1 and
  attacksequencegame.baseRuntime().aiPlayers[0].viewHeight == sequencePlayer.viewHeight,
  "AI target mirrors exact player viewheight")
sequencePlayer.health = 5000; sequencePlayer.maxHealth = 5000
sequencePlayer.edict.health = 5000; sequencePlayer.edict.maxHealth = 5000
sequenceApi.clientThink(sequenceClient, attacksequenceqtypes.UserCmd(0, 0, [0, 0, 0], 0, 0, 0, 0, 64))
sequenceFrame = 0
sequenceMuzzleEvents = []
while sequenceFrame < 40 and len(sequenceMuzzleEvents) < 8
  sequenceApi.runFrame()
  sequenceMuzzleEvents = []
  for each sequencePendingEvent in sequenceServer.pendingMulticasts
    if len(sequencePendingEvent.payload) == 4 and
        sequencePendingEvent.payload[0] == attacksequenceqconstants.SVC_MUZZLEFLASH2 then
      sequenceMuzzleEvents = sequenceMuzzleEvents + [sequencePendingEvent]
    end if
  end for
  sequenceFrame = sequenceFrame + 1
end while
sequenceAssert(len(sequenceMuzzleEvents) >= 8, "integrated gunner emitted full chain")
sequenceFlashIndex = 0
while sequenceFlashIndex < 8
  sequenceEvent = sequenceMuzzleEvents[sequenceFlashIndex]
  sequenceAssert(sequenceEvent.destination == attacksequencegameconstants.MULTICAST_PVS and
    len(sequenceEvent.payload) == 4 and
    sequenceEvent.payload[0] == attacksequenceqconstants.SVC_MUZZLEFLASH2 and
    sequenceEvent.payload[3] == 45 + sequenceFlashIndex,
    "integrated gunner svc_muzzleflash2 " + sequenceFlashIndex)
  sequenceFlashIndex = sequenceFlashIndex + 1
end while
sequenceAssert(attacksequencegame.baseRuntime().monsters[0].attackCount == 1,
  "one AI attack callback owns the complete chain")

// Drive the exact live decision boundary without waiting for boss acquisition.
// The next Win32 CRT value for seed 1 is below both refire thresholds.
sequenceRuntime = attacksequencegame.baseRuntime()
sequenceRuntime.aiContext.visible = sequenceAlwaysVisible
sequenceRuntime.aiContext.time = 10.0
sequenceRuntime.randomState.seed = 1
liveEnemy = attacksequenceaitypes.createClientTarget(99)
liveEnemy.health = 100
liveEnemy.edict.state.origin = attacksequenceqtypes.Vec3(128.0, 0.0, 0.0)
liveJorg = attacksequenceaitypes.createActor(98, "monster_jorg")
liveJorg.enemy = liveEnemy
liveJorg.activity = "jorg-machineguns"
liveJorg.attackCycles = 1
liveJorg.info.nextFrame = 12
liveJorg.info.pauseTime = 10.0
attacksequencebaseq2.advanceMonsterAttack(sequenceRuntime, liveJorg,
  attacksequences.jorgPlanCycles(1))
sequenceAssert(liveJorg.attackCycles == 2 and liveJorg.info.nextFrame == 14 and
  liveJorg.info.pauseTime > 10.09 and liveJorg.info.pauseTime < 10.11,
  "Jorg live visible 90-percent refire extends and fires at decision frame")

// Seed 9521 produces a value above .95, so Jorg must enter its three-frame
// post-fire tail without consuming or fabricating another cycle.
sequenceRuntime.randomState.seed = 9521
liveJorgStop = attacksequenceaitypes.createActor(97, "monster_jorg")
liveJorgStop.enemy = liveEnemy
liveJorgStop.activity = "jorg-machineguns"
liveJorgStop.attackCycles = 1
liveJorgStop.info.nextFrame = 12
liveJorgStop.info.pauseTime = 10.0
attacksequencebaseq2.advanceMonsterAttack(sequenceRuntime, liveJorgStop,
  attacksequences.jorgPlanCycles(1))
sequenceAssert(liveJorgStop.attackCycles == 1 and liveJorgStop.info.nextFrame == -1 and
  liveJorgStop.info.pauseTime > 10.29 and liveJorgStop.info.pauseTime < 10.31,
  "Jorg failed refire enters exact post-fire tail")

sequenceRuntime.randomState.seed = 1
liveBoss2 = attacksequenceaitypes.createActor(96, "monster_boss2")
liveBoss2.enemy = liveEnemy
liveBoss2.activity = "boss2-machineguns"
liveBoss2.attackCycles = 1
liveBoss2.info.nextFrame = 10
liveBoss2.info.pauseTime = 10.0
attacksequencebaseq2.advanceMonsterAttack(sequenceRuntime, liveBoss2,
  attacksequences.boss2MachinegunPlanCycles(1))
sequenceAssert(liveBoss2.attackCycles == 2 and liveBoss2.info.nextFrame == 10 and
  liveBoss2.info.pauseTime > 10.09 and liveBoss2.info.pauseTime < 10.11,
  "Boss2 refire decision waits one frame before next attack10 pair")

sequenceRuntime.randomState.seed = 1
liveGunner = attacksequenceaitypes.createActor(95, "monster_gunner")
liveGunner.enemy = liveEnemy
liveGunner.activity = "gunner-chain"
liveGunner.attackCycles = 1
liveGunner.info.nextFrame = 8
liveGunner.info.pauseTime = 10.0
attacksequencebaseq2.advanceMonsterAttack(sequenceRuntime, liveGunner,
  attacksequences.gunnerChainPlanCycles(1))
sequenceAssert(liveGunner.attackCycles == 2 and liveGunner.info.nextFrame == 9 and
  liveGunner.info.pauseTime > 10.09 and liveGunner.info.pauseTime < 10.11,
  "Gunner live refire emits attack216 on the decision tick")

sequenceRuntime.randomState.seed = 1
liveMedic = attacksequenceaitypes.createActor(94, "monster_medic")
liveMedic.enemy = liveEnemy
liveMedic.activity = "medic-blaster"
liveMedic.attackCycles = 0
liveMedic.info.nextFrame = 2
liveMedic.info.pauseTime = 10.0
attacksequencebaseq2.advanceMonsterAttack(sequenceRuntime, liveMedic,
  attacksequences.medicBlasterPlanContinue(false))
sequenceAssert(liveMedic.attackCycles == 1 and liveMedic.info.nextFrame == 2 and
  liveMedic.info.pauseTime > 10.49 and liveMedic.info.pauseTime < 10.51,
  "Medic live continue waits through attack15..18 before hyperfire")

sequenceRuntime.randomState.seed = 1
liveChickRocket = attacksequenceaitypes.createActor(93, "monster_chick")
liveChickRocket.enemy = liveEnemy
liveChickRocket.activity = "chick-rockets"
liveChickRocket.attackCycles = 1
liveChickRocket.info.nextFrame = 1
liveChickRocket.info.pauseTime = 10.0
attacksequencebaseq2.advanceMonsterAttack(sequenceRuntime, liveChickRocket,
  attacksequences.chickRocketPlanCycles(1))
sequenceAssert(liveChickRocket.attackCycles == 2 and liveChickRocket.info.nextFrame == 1 and
  liveChickRocket.info.pauseTime > 10.09 and liveChickRocket.info.pauseTime < 10.11,
  "Chick live rerocket enters attack114 on the following tick")

liveMeleeEnemy = attacksequenceaitypes.createClientTarget(92)
liveMeleeEnemy.health = 100
liveMeleeEnemy.edict.state.origin = attacksequenceqtypes.Vec3(64.0, 0.0, 0.0)
sequenceRuntime.randomState.seed = 1
liveChickSlash = attacksequenceaitypes.createActor(91, "monster_chick")
liveChickSlash.enemy = liveMeleeEnemy
liveChickSlash.activity = "chick-slash"
liveChickSlash.attackCycles = 1
liveChickSlash.info.nextFrame = 1
liveChickSlash.info.pauseTime = 10.0
attacksequencebaseq2.advanceMonsterAttack(sequenceRuntime, liveChickSlash,
  attacksequences.chickMeleePlanCycles(1))
sequenceAssert(liveChickSlash.attackCycles == 2 and liveChickSlash.info.nextFrame == 1 and
  liveChickSlash.info.pauseTime > 10.19 and liveChickSlash.info.pauseTime < 10.21,
  "Chick live reslash preserves the attack204 restart frame")

sequenceRuntime.randomState.seed = 1
liveFlyer = attacksequenceaitypes.createActor(90, "monster_flyer")
liveFlyer.enemy = liveMeleeEnemy
liveFlyer.activity = "flyer-slashes"
liveFlyer.attackCycles = 1
liveFlyer.info.nextFrame = 2
liveFlyer.info.pauseTime = 10.0
attacksequencebaseq2.advanceMonsterAttack(sequenceRuntime, liveFlyer,
  attacksequences.flyerMeleePlanCycles(1))
sequenceAssert(liveFlyer.attackCycles == 2 and liveFlyer.info.nextFrame == 2 and
  liveFlyer.info.pauseTime > 10.19 and liveFlyer.info.pauseTime < 10.21 and
  sequenceRuntime.randomState.seed != 1,
  "Flyer live melee loop consumes the stock 80-percent refire draw")

sequenceRuntime.randomState.seed = 1
liveHover = attacksequenceaitypes.createActor(89, "monster_hover")
liveHover.enemy = liveEnemy
liveHover.activity = "hover-blasters"
liveHover.attackCycles = 1
liveHover.info.nextFrame = 2
liveHover.info.pauseTime = 10.0
attacksequencebaseq2.advanceMonsterAttack(sequenceRuntime, liveHover,
  attacksequences.hoverBlasterPlanCycles(1))
sequenceAssert(liveHover.attackCycles == 2 and liveHover.info.nextFrame == 2 and
  liveHover.info.pauseTime > 10.09 and liveHover.info.pauseTime < 10.11,
  "Hover live reattack restarts at attack104")

sequenceRuntime.aiContext.skill = 2
sequenceRuntime.randomState.seed = 1
liveMutant = attacksequenceaitypes.createActor(88, "monster_mutant")
liveMutant.enemy = liveMeleeEnemy
liveMutant.activity = "mutant-claws"
liveMutant.attackCycles = 1
liveMutant.info.nextFrame = 2
liveMutant.info.pauseTime = 10.0
attacksequencebaseq2.advanceMonsterAttack(sequenceRuntime, liveMutant,
  attacksequences.mutantMeleePlanCycles(1))
sequenceAssert(liveMutant.attackCycles == 2 and liveMutant.info.nextFrame == 2 and
  liveMutant.info.pauseTime > 10.29 and liveMutant.info.pauseTime < 10.31 and
  sequenceRuntime.randomState.seed == 1,
  "Mutant melee-range nextframe loop consumes no non-nightmare random draw")

sequenceRuntime.randomState.seed = 1
liveSupertank = attacksequenceaitypes.createActor(87, "monster_supertank")
liveSupertank.enemy = liveEnemy
liveSupertank.activity = "supertank-machinegun"
liveSupertank.attackCycles = 1
liveSupertank.info.nextFrame = 6
liveSupertank.info.pauseTime = 10.0
attacksequencebaseq2.advanceMonsterAttack(sequenceRuntime, liveSupertank,
  attacksequences.supertankMachinegunPlanCycles(1))
sequenceAssert(liveSupertank.attackCycles == 2 and liveSupertank.info.nextFrame == 7 and
  liveSupertank.info.pauseTime > 10.09 and liveSupertank.info.pauseTime < 10.11,
  "Supertank live reattack emits attack1_1 on the decision tick")

sequenceRuntime.aiContext.skill = 3
sequenceRuntime.randomState.seed = 1
liveSoldier = attacksequenceaitypes.createActor(86, "monster_soldier_light")
liveSoldier.enemy = liveEnemy
liveSoldier.activity = "soldier-light-attack1"
liveSoldier.attackCycles = 1
liveSoldier.info.nextFrame = 1
liveSoldier.info.pauseTime = 10.0
attacksequencebaseq2.advanceMonsterAttack(sequenceRuntime, liveSoldier,
  attacksequences.soldierLightPlanCycles("monster_soldier_light", false, 1))
sequenceAssert(liveSoldier.attackCycles == 2 and liveSoldier.info.nextFrame == 1 and
  liveSoldier.info.pauseTime > 10.19 and liveSoldier.info.pauseTime < 10.21,
  "nightmare light Soldier performs the exact attack102 refire jump")

sequenceRuntime.randomState.seed = 1
liveShotgunSoldier = attacksequenceaitypes.createActor(85, "monster_soldier")
liveShotgunSoldier.enemy = liveEnemy
liveShotgunSoldier.activity = "soldier-shotgun-attack2"
liveShotgunSoldier.attackCycles = 1
liveShotgunSoldier.info.nextFrame = 1
liveShotgunSoldier.info.pauseTime = 10.0
attacksequencebaseq2.advanceMonsterAttack(sequenceRuntime, liveShotgunSoldier,
  attacksequences.soldierShotgunPlanCycles("monster_soldier", true, 1))
sequenceAssert(liveShotgunSoldier.attackCycles == 2 and liveShotgunSoldier.info.nextFrame == 1 and
  liveShotgunSoldier.info.pauseTime > 10.19 and liveShotgunSoldier.info.pauseTime < 10.21,
  "nightmare shotgun Soldier performs the exact post-cock attack204 refire jump")

savedSequencePlayerContext = sequenceRuntime.playerContext
sequenceRuntime.playerContext = void
sequenceRuntime.aiContext.time = 10.0
liveRunShootEnemy = attacksequenceaitypes.createClientTarget(78)
liveRunShootEnemy.health = 100
liveRunShootEnemy.edict.state.origin = attacksequenceqtypes.Vec3(600.0, 0.0, 0.0)
liveRunShootSoldier = attacksequenceaitypes.createActor(77, "monster_soldier_light")
liveRunShootSoldier.enemy = liveRunShootEnemy
liveRunShootSoldier.activity = "soldier-run-shoot-pending"
liveRunShootSoldier.edict.state.angles = attacksequenceqtypes.Vec3(0.0, 0.0, 0.0)
sequenceAssert(not attacksequencebaseq2.runMonsterCombat(sequenceRuntime, liveRunShootSoldier) and
  liveRunShootSoldier.activity == "soldier-run-shoot" and liveRunShootSoldier.attackCycles == 1 and
  liveRunShootSoldier.edict.state.frame == 109 and liveRunShootSoldier.edict.state.origin.x == 10.0 and
  liveRunShootSoldier.info.pauseTime > 10.29 and liveRunShootSoldier.info.pauseTime < 10.31,
  "Soldier sight marker starts attack6 at runs01 with its first charge distance")
liveRunShootSoldier.info.nextFrame = 1
liveRunShootSoldier.info.pauseTime = 10.0
attacksequencebaseq2.advanceMonsterAttack(sequenceRuntime, liveRunShootSoldier,
  attacksequences.soldierRunShootPlanCycles("monster_soldier_light", 1))
sequenceAssert(liveRunShootSoldier.attackCycles == 2 and liveRunShootSoldier.info.nextFrame == 1 and
  liveRunShootSoldier.info.pauseTime > 10.19 and liveRunShootSoldier.info.pauseTime < 10.21,
  "nightmare Soldier attack6 loops from runs14 to runs03 without a random draw")

liveDuckShootSoldier = attacksequenceaitypes.createActor(76, "monster_soldier")
liveDuckShootSoldier.enemy = liveRunShootEnemy
liveDuckShootSoldier.activity = "soldier-duck-shoot-pending"
sequenceRuntime.aiContext.time = 10.0
sequenceAssert(not attacksequencebaseq2.runMonsterCombat(sequenceRuntime, liveDuckShootSoldier) and
  liveDuckShootSoldier.activity == "soldier-duck-shoot" and
  liveDuckShootSoldier.edict.state.frame == 30,
  "Soldier dodge marker starts attack3 at attack301")
sequenceRuntime.aiContext.time = 10.2
attacksequencebaseq2.advanceMonsterAttack(sequenceRuntime, liveDuckShootSoldier,
  attacksequences.soldierDuckShootPlan("monster_soldier"))
sequenceAssert((liveDuckShootSoldier.info.aiFlags & attacksequenceaiconstants.AI_DUCKED) != 0 and
  liveDuckShootSoldier.edict.maxs.z == liveDuckShootSoldier.maxs[2] - 32.0 and
  liveDuckShootSoldier.takeDamage == 1,
  "Soldier attack303 lowers collision bounds before firing")
sequenceRuntime.aiContext.time = 11.0
attacksequencebaseq2.advanceMonsterAttack(sequenceRuntime, liveDuckShootSoldier,
  attacksequences.soldierDuckShootPlan("monster_soldier"))
attacksequencebaseq2.advanceMonsterAttack(sequenceRuntime, liveDuckShootSoldier,
  attacksequences.soldierDuckShootPlan("monster_soldier"))
sequenceAssert((liveDuckShootSoldier.info.aiFlags & attacksequenceaiconstants.AI_DUCKED) == 0 and
  liveDuckShootSoldier.edict.maxs.z == liveDuckShootSoldier.maxs[2] and
  liveDuckShootSoldier.takeDamage == 2,
  "Soldier attack307 restores collision bounds after the second shot")
sequenceRuntime.playerContext = savedSequencePlayerContext
sequenceRuntime.aiContext.time = 10.0

sequenceRuntime.aiContext.skill = 2
sequenceRuntime.randomState.seed = 1
liveTankBlaster = attacksequenceaitypes.createActor(84, "monster_tank")
liveTankBlaster.enemy = liveEnemy
liveTankBlaster.activity = "tank-blasters-hard"
liveTankBlaster.attackCycles = 1
liveTankBlaster.info.nextFrame = 3
liveTankBlaster.info.pauseTime = 10.0
attacksequencebaseq2.advanceMonsterAttack(sequenceRuntime, liveTankBlaster,
  attacksequences.tankBlasterPlanCycles("monster_tank", 1, true))
sequenceAssert(liveTankBlaster.attackCycles == 2 and liveTankBlaster.info.nextFrame == 3 and
  liveTankBlaster.info.pauseTime > 10.19 and liveTankBlaster.info.pauseTime < 10.21,
  "hard Tank live blaster refire enters attack111")

sequenceRuntime.randomState.seed = 1
liveTankRocket = attacksequenceaitypes.createActor(83, "monster_tank")
liveTankRocket.enemy = liveEnemy
liveTankRocket.activity = "tank-rockets-hard"
liveTankRocket.attackCycles = 1
liveTankRocket.info.nextFrame = 3
liveTankRocket.info.pauseTime = 10.0
attacksequencebaseq2.advanceMonsterAttack(sequenceRuntime, liveTankRocket,
  attacksequences.tankRocketPlanCycles("monster_tank", 1, true))
sequenceAssert(liveTankRocket.attackCycles == 2 and liveTankRocket.info.nextFrame == 3 and
  liveTankRocket.info.pauseTime > 10.19 and liveTankRocket.info.pauseTime < 10.21,
  "hard Tank live rocket refire enters attack322")

sequenceRuntime.aiContext.skill = 2
liveBrainEnemy = sequenceRuntime.aiPlayers[0]
liveBrainEnemy.health = sequencePlayer.health
safeGladiator = attacksequenceaitypes.createActor(80, "monster_gladiator")
safeGladiator.edict.state.origin = attacksequenceqtypes.Vec3(
  sequencePlayer.edict.state.origin.x + 112.0, sequencePlayer.edict.state.origin.y,
  sequencePlayer.edict.state.origin.z)
safeGladiator.edict.state.angles = attacksequenceqtypes.Vec3(0.0, 180.0, 0.0)
safeGladiator.enemy = liveBrainEnemy
safeGladiator.activity = "attack"
sequenceAssert(not attacksequencebaseq2.runMonsterCombat(sequenceRuntime, safeGladiator) and
  attacksequencebaseq2.activeMonsterAttackPlan(safeGladiator) is void,
  "Gladiator exact 112-unit rail safe zone is an attack no-op")
savedAimGladiator = attacksequenceaitypes.createActor(79, "monster_gladiator")
savedAimGladiator.edict.state.origin = attacksequenceqtypes.Vec3(
  sequencePlayer.edict.state.origin.x + 113.0, sequencePlayer.edict.state.origin.y,
  sequencePlayer.edict.state.origin.z)
savedAimGladiator.edict.state.angles = attacksequenceqtypes.Vec3(0.0, 180.0, 0.0)
savedAimGladiator.enemy = liveBrainEnemy
savedAimGladiator.activity = "attack"
attacksequencebaseq2.runMonsterCombat(sequenceRuntime, savedAimGladiator)
sequenceAssert(savedAimGladiator.activity == "gladiator-rail" and
  savedAimGladiator.attackAimValid and savedAimGladiator.attackAim.y == 0.0,
  "Gladiator snapshots the rail target at attack start")
savedGladiatorBefore = attacksequencebaseq2.monsterMuzzleAndDirection(sequenceRuntime,
  savedAimGladiator, attacksequences.gladiatorRailPlan(), 0, 61)
sequencePlayer.edict.state.origin.y = 100.0
savedGladiatorMuzzle = attacksequencebaseq2.monsterMuzzleAndDirection(sequenceRuntime,
  savedAimGladiator, attacksequences.gladiatorRailPlan(), 0, 61)
sequenceNear(savedGladiatorMuzzle[1].x, savedGladiatorBefore[1].x,
  "Gladiator rail saved x direction")
sequenceNear(savedGladiatorMuzzle[1].y, savedGladiatorBefore[1].y,
  "Gladiator rail saved y direction")
sequenceNear(savedGladiatorMuzzle[1].z, savedGladiatorBefore[1].z,
  "Gladiator rail saved z direction")
sequencePlayer.edict.state.origin.y = 0.0
liveMutantJump = attacksequenceaitypes.createActor(81, "monster_mutant")
liveMutantJump.edict.state.origin = attacksequenceqtypes.Vec3(100.0, 0.0, 0.0)
liveMutantJump.edict.state.angles = attacksequenceqtypes.Vec3(0.0, 180.0, 0.0)
liveMutantJump.enemy = liveBrainEnemy
liveMutantJump.activity = "mutant-jump"
liveMutantJump.info.nextFrame = 0
liveMutantJump.info.pauseTime = 10.0
attacksequencebaseq2.advanceMonsterAttack(sequenceRuntime, liveMutantJump,
  attacksequences.mutantJumpPlan())
sequenceAssert(liveMutantJump.attackAimValid and liveMutantJump.info.nextFrame == 1 and
  liveMutantJump.info.pauseTime > 10.19 and liveMutantJump.info.pauseTime < 10.21 and
  liveMutantJump.attackAim.x < -599.9 and liveMutantJump.attackAim.z == 250.0 and
  (liveMutantJump.info.aiFlags & 0x00000800) != 0,
  "Mutant attack03 launches at stock 600/250 velocity")
sequenceRuntime.randomState.seed = 1
jumpTarget = attacksequencebaseq2.weaponTargetByNumber(sequenceRuntime,
  liveBrainEnemy.edict.state.number)
jumpHealthBefore = sequencePlayer.health
attacksequencebaseq2.damageMutantJumpTarget(sequenceRuntime, liveMutantJump, jumpTarget,
  liveMutantJump.attackAim, liveBrainEnemy.edict.state.origin)
attacksequencebaseq2.damageMutantJumpTarget(sequenceRuntime, liveMutantJump, jumpTarget,
  liveMutantJump.attackAim, liveBrainEnemy.edict.state.origin)
sequenceAssert(jumpHealthBefore - sequencePlayer.health == 40 and liveMutantJump.attackCycles == 1,
  "Mutant high-speed jump touch applies one exact 40-plus-random impact")
liveMutantJump.attackAimValid = false
sequenceRuntime.aiContext.time = 10.2
attacksequencebaseq2.advanceMonsterAttack(sequenceRuntime, liveMutantJump,
  attacksequences.mutantJumpPlan())
sequenceAssert(liveMutantJump.info.nextFrame == 2 and
  liveMutantJump.info.pauseTime > 10.49 and liveMutantJump.info.pauseTime < 10.51 and
  (liveMutantJump.info.aiFlags & 0x00000800) == 0,
  "Mutant grounded attack05 enters the three-frame landing tail")
sequenceRuntime.aiContext.time = 10.0
liveBrain = attacksequenceaitypes.createActor(82, "monster_brain")
liveBrain.edict.state.origin = attacksequenceqtypes.Vec3(64.0, 0.0, 0.0)
liveBrain.edict.state.angles = attacksequenceqtypes.Vec3(0.0, 180.0, 0.0)
liveBrain.enemy = liveBrainEnemy
liveBrain.activity = "brain-tentacle"
liveBrain.info.nextFrame = 0
liveBrain.info.pauseTime = 10.0
brainHealthBefore = sequencePlayer.health
attacksequencebaseq2.advanceMonsterAttack(sequenceRuntime, liveBrain,
  attacksequences.brainTentaclePlan(0))
sequenceAssert(liveBrain.activity == "brain-tentacle-claws" and
  liveBrain.info.nextFrame == 1 and
  liveBrain.info.pauseTime > 11.19 and liveBrain.info.pauseTime < 11.21 and
  sequencePlayer.health < brainHealthBefore,
  "Brain chains attack1 only after a successful stock tentacle fire_hit")
sequenceApi.clientDisconnect(sequenceClient)
sequenceApi.shutdown()

print "gameplay_monster_attack_sequence_tests: PASS"
