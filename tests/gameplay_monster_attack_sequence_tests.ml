/* Quake II 3.19 monster attack-frame, muzzle and live burst regression. */
import miniquake2.game.ai.attack_sequences as attacksequences
import miniquake2.game.null_game as attacksequencegame
import miniquake2.game.constants as attacksequencegameconstants
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

gunnerPlan = attacksequences.gunnerChainPlan(2, 1)
sequenceAssert(attacksequences.validatePlan(gunnerPlan), "gunner chain validates")
sequenceAssert(len(gunnerPlan.muzzleFlashes) % 8 == 0, "gunner chain uses complete cycles")
gunnerIndex = 0
while gunnerIndex < len(gunnerPlan.muzzleFlashes)
  sequenceAssert(gunnerPlan.muzzleFlashes[gunnerIndex] == 45 + (gunnerIndex % 8),
    "gunner sequential muzzle " + gunnerIndex)
  gunnerIndex = gunnerIndex + 1
end while
gunnerGrenades = attacksequences.gunnerGrenadePlan()
assertConsecutive(gunnerGrenades.muzzleFlashes, 53, 4, "gunner grenade muzzles")
sequenceAssert(gunnerGrenades.frameOffsets == [4, 7, 10, 13], "gunner grenade frames")

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

jorgPlan = attacksequences.jorgPlan(7, 1)
sequenceAssert(len(jorgPlan.muzzleFlashes) % 12 == 0, "Jorg complete six-frame paired cycle")
jorgIndex = 0
while jorgIndex < len(jorgPlan.muzzleFlashes)
  expectedJorg = 120
  if jorgIndex % 2 == 1 then expectedJorg = 126 end if
  sequenceAssert(jorgPlan.muzzleFlashes[jorgIndex] == expectedJorg, "Jorg paired barrels")
  jorgIndex = jorgIndex + 1
end while
boss2Rockets = attacksequences.boss2RocketPlan()
sequenceAssert(boss2Rockets.frameOffsets == [12, 12, 12, 12], "Boss2 simultaneous rocket frame")
assertConsecutive(boss2Rockets.muzzleFlashes, 78, 4, "Boss2 rocket muzzles")
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
while sequenceFrame < 40 and len(sequenceServer.pendingMulticasts) < 8
  sequenceApi.runFrame()
  sequenceFrame = sequenceFrame + 1
end while
sequenceAssert(len(sequenceServer.pendingMulticasts) >= 8, "integrated gunner emitted full chain")
sequenceFlashIndex = 0
while sequenceFlashIndex < 8
  sequenceEvent = sequenceServer.pendingMulticasts[sequenceFlashIndex]
  sequenceAssert(sequenceEvent.destination == attacksequencegameconstants.MULTICAST_PVS and
    len(sequenceEvent.payload) == 4 and sequenceEvent.payload[0] == 2 and
    sequenceEvent.payload[3] == 45 + sequenceFlashIndex,
    "integrated gunner svc_muzzleflash2 " + sequenceFlashIndex)
  sequenceFlashIndex = sequenceFlashIndex + 1
end while
sequenceAssert(attacksequencegame.baseRuntime().monsters[0].attackCount == 1,
  "one AI attack callback owns the complete chain")
sequenceApi.clientDisconnect(sequenceClient)
sequenceApi.shutdown()

print "gameplay_monster_attack_sequence_tests: PASS"
