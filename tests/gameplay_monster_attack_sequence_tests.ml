/* Quake II 3.19 monster attack-frame, muzzle and live burst regression. */
import miniquake2.game.ai.attack_sequences as attacksequences
import miniquake2.game.ai.types as attacksequenceaitypes
import miniquake2.game.integration.baseq2 as attacksequencebaseq2
import miniquake2.game.null_game as attacksequencegame
import miniquake2.game.constants as attacksequencegameconstants
import miniquake2.qcommon.constants as attacksequenceqconstants
import miniquake2.qcommon.types as attacksequenceqtypes
import miniquake2.server.game_bridge as attacksequencebridge
import std.math as attacksequencemath

function sequenceAssert(value, message)
  if value != true then return error(9984, message) end if
  return true
end function

function sequenceNear(actual, expected, message)
  sequenceAssert(attacksequencemath.abs(actual - expected) < 0.001, message)
  return true
end function

function sequenceAlwaysVisible(first, second)
  return true
end function

function assertConsecutive(values, first, count, message)
  sequenceAssert(len(values) == count, message + " count")
  index = 0
  while index < count
    sequenceAssert(values[index] == first + index, message + " value " + index)
    index = index + 1
  end while
  return true
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
flyerSlashes = attacksequences.flyerMeleePlan()
sequenceAssert(len(flyerSlashes.frameOffsets) == 16 and
  attacksequences.modelFrameAt(flyerSlashes, 0) == 58 and
  attacksequences.modelFrameAt(flyerSlashes, 6) == 64 and
  attacksequences.modelFrameAt(flyerSlashes, flyerSlashes.durationFrames - 1) == 78,
  "Flyer slash start/refire/end frames")
brainClaws = attacksequences.brainClawPlan()
brainTentacle = attacksequences.brainTentaclePlan(1)
sequenceAssert(brainClaws.frameOffsets == [7, 11] and
  attacksequences.modelFrameAt(brainClaws, 0) == 53 and
  attacksequences.modelFrameAt(brainClaws, 17) == 70 and
  brainTentacle.frameOffsets == [6, 24, 28] and
  attacksequences.eventDamage(brainTentacle, 0) == 12 and
  attacksequences.eventKnockback(brainTentacle, 0) == -600 and
  attacksequences.modelFrameAt(brainTentacle, 16) == 87 and
  attacksequences.modelFrameAt(brainTentacle, 17) == 53,
  "Brain tentacle-to-claw stock transition")
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
chickPlan = attacksequences.chickRocketPlan(2, 1)
sequenceAssert(chickPlan.frameOffsets[0] == 13 and chickPlan.muzzleFlashes[0] == 57 and
  attacksequences.modelFrameAt(chickPlan, 13) == 13 and
  attacksequences.modelFrameAt(chickPlan, chickPlan.durationFrames - 1) == 31,
  "Chick rocket refire frames")
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
supertankChain = attacksequences.supertankMachinegunPlan(2, 1)
supertankRockets = attacksequences.supertankRocketPlan()
sequenceAssert(supertankChain.muzzleFlashes[0] == 64 and supertankChain.muzzleFlashes[5] == 69 and
  attacksequences.modelFrameAt(supertankChain, 0) == 0 and
  attacksequences.modelFrameAt(supertankChain, supertankChain.durationFrames - 1) == 19,
  "Supertank machinegun refire frames")
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
soldierShotgun2 = attacksequences.planByName("monster_soldier", "soldier-shotgun-attack2", 2, 1)
sequenceAssert(soldierShotgun2.muzzleFlashes == [42] and soldierShotgun2.count == 12,
  "soldier shotgun attack2 payload")
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

sequenceAssert(attacksequences.selectionRandomKind("monster_jorg", 500.0) == 1 and
  attacksequences.selectionRandomKind("monster_boss2", 100.0) == 0 and
  attacksequences.selectionRandomKind("monster_berserk", 40.0) == 0,
  "stock attack selection consumes only the original random draw kind")
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
aimStart = attacksequenceqtypes.Vec3(0.0, 0.0, 0.0)
aimDestination = attacksequenceqtypes.Vec3(100.0, 0.0, 0.0)
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
sequenceApi.clientDisconnect(sequenceClient)
sequenceApi.shutdown()

print "gameplay_monster_attack_sequence_tests: PASS"
