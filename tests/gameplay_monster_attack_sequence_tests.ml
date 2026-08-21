/* Quake II 3.19 monster attack-frame, muzzle and live burst regression. */
import miniquake2.game.ai.attack_sequences as attacksequences
import miniquake2.game.null_game as attacksequencegame
import miniquake2.game.constants as attacksequencegameconstants
import miniquake2.qcommon.constants as attacksequenceqconstants
import miniquake2.qcommon.types as attacksequenceqtypes
import miniquake2.server.game_bridge as attacksequencebridge

function sequenceAssert(value, message)
  if value != true then return error(9984, message) end if
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
floaterPlan = attacksequences.floaterBlasterPlan()
sequenceAssert(len(floaterPlan.frameOffsets) == 7 and attacksequences.modelFrameAt(floaterPlan, 3) == 34,
  "Floater blaster burst frames")
hoverPlan = attacksequences.hoverBlasterPlan(2, 1)
sequenceAssert(hoverPlan.frameOffsets[0] == 3 and hoverPlan.frameOffsets[1] == 4 and
  attacksequences.modelFrameAt(hoverPlan, 3) == 200 and
  attacksequences.modelFrameAt(hoverPlan, hoverPlan.durationFrames - 1) == 204,
  "Hover blaster refire frames")
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

jorgPlan = attacksequences.jorgPlan(7, 1)
sequenceAssert(len(jorgPlan.muzzleFlashes) % 12 == 0, "Jorg complete six-frame paired cycle")
jorgIndex = 0
while jorgIndex < len(jorgPlan.muzzleFlashes)
  expectedJorg = 120
  if jorgIndex % 2 == 1 then expectedJorg = 126 end if
  sequenceAssert(jorgPlan.muzzleFlashes[jorgIndex] == expectedJorg, "Jorg paired barrels")
  jorgIndex = jorgIndex + 1
end while
sequenceAssert(attacksequences.modelFrameAt(jorgPlan, 0) == 0 and
  attacksequences.modelFrameAt(jorgPlan, 8) == 8 and
  attacksequences.modelFrameAt(jorgPlan, jorgPlan.durationFrames - 1) == 17,
  "Jorg stock start/fire/end model frames")
boss2Rockets = attacksequences.boss2RocketPlan()
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
sequenceAssert(makronRail.frameOffsets == [8] and makronRail.muzzleFlashes == [119], "Makron rail frame")
sequenceAssert(attacksequences.modelFrameAt(makronBfg, 3) == 204 and
  attacksequences.modelFrameAt(makronHyper, 4) == 213 and
  attacksequences.modelFrameAt(makronHyper, 20) == 229 and
  attacksequences.modelFrameAt(makronRail, 8) == 243,
  "Makron stock attack model frames")

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
sequenceApi.clientDisconnect(sequenceClient)
sequenceApi.shutdown()

print "gameplay_monster_attack_sequence_tests: PASS"
