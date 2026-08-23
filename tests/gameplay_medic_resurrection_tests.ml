/* Exact m_medic.c corpse selection, cable timeline and live resurrection. */
import miniquake2.game.ai.attack_sequences as medicattack
import miniquake2.game.ai.constants as medicaiconstants
import miniquake2.game.ai.death_effects as medicdeath
import miniquake2.game.ai.archetypes as medicarchetypes
import miniquake2.game.ai.types as medicaitypes
import miniquake2.game.integration.baseq2 as medicintegration
import miniquake2.game.null_game as medicgame
import miniquake2.game.constants as medicgameconstants
import miniquake2.game.weapons.constants as medicweaponconstants
import miniquake2.qcommon.constants as medicqconstants
import miniquake2.server.game_bridge as medicbridge
import miniquake2.server.sound_events as medicsoundevents
import std.math as medicmath

function medicAssert(value, message)
  if value != true then return error(9968, message) end if
  return true
end function

function medicNear(actual, expected, message)
  return medicAssert(medicmath.abs(actual - expected) < 0.001, message)
end function

function findMedicActor(runtime, className)
  for each actor in runtime.monsters
    if actor.className == className then return actor end if
  end for
  return void
end function

function findMedicName(names, value)
  index = 0
  while index < len(names)
    if names[index] == value then return index end if
    index = index + 1
  end while
  return -1
end function

function prepareMedicCorpse(actor, context)
  actor.health = -25
  actor.deadFlag = medicaiconstants.DEAD_DEAD
  actor.nextThink = 0.0
  actor.activity = "corpse"
  actor.deathUseComplete = true
  actor.owner = void
  actor.info.aiFlags = 0
  actor.edict.inUse = true
  actor.edict.solid = medicgameconstants.SOLID_BBOX
  actor.edict.serverFlags = actor.edict.serverFlags |
    medicgameconstants.SVF_MONSTER | medicgameconstants.SVF_DEADMONSTER
  medicdeath.applyCorpse(actor, context)
  return actor
end function

// The table itself retains every original attack33..60 movement and callback
// boundary before the product-shaped test exercises it.
medicCableAttackPlan = medicattack.medicCablePlan()
medicAssert(medicattack.validatePlan(medicCableAttackPlan) and
  medicCableAttackPlan.durationFrames == 28 and
  medicCableAttackPlan.frameOffsets == [9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19] and
  medicattack.modelFrameAt(medicCableAttackPlan, 0) == 209 and
  medicattack.modelFrameAt(medicCableAttackPlan, 27) == 236,
  "Medic exact attack33..60 cable table")
medicDirectPlanProbe = medicattack.planByName("monster_medic", "medic-cable", 1, 1)
medicCyclePlanProbe = medicattack.planByNameCycles("monster_medic", "medic-cable", 1, 1, 0)
medicAssert(medicDirectPlanProbe is not void and medicCyclePlanProbe is not void,
  "Medic cable remains addressable as an active zero-cycle plan")
medicMovementTotal = 0.0
medicMovementOffset = 0
while medicMovementOffset < medicCableAttackPlan.durationFrames
  medicMovementTotal = medicMovementTotal +
    medicattack.movementDistanceAt(medicCableAttackPlan, medicMovementOffset)
  expectedAi = medicattack.ATTACK_AI_MOVE
  if medicMovementOffset >= 4 and medicMovementOffset <= 8 then
    expectedAi = medicattack.ATTACK_AI_CHARGE
  end if
  medicAssert(medicattack.movementAiAt(medicCableAttackPlan, medicMovementOffset) == expectedAi,
    "Medic cable movement AI " + medicMovementOffset)
  medicMovementOffset = medicMovementOffset + 1
end while
medicNear(medicMovementTotal, 14.9, "Medic cable exact net movement")

medicServer = medicbridge.createRuntime(4)
medicApi = medicgame.GetGameApi(medicbridge.makeImports(medicServer))
medicServer.game = medicApi
medicApi.init()
medicFixture = "{\"classname\" \"worldspawn\"}" +
  "{\"classname\" \"info_player_start\" \"origin\" \"-512 0 0\"}" +
  "{\"classname\" \"monster_medic\" \"origin\" \"0 0 10\" \"angle\" \"0\"}" +
  "{\"classname\" \"monster_soldier_light\" \"origin\" \"96 160 10\"}" +
  "{\"classname\" \"monster_gunner\" \"origin\" \"128 0 10\"}"
medicApi.spawnEntities("medic-resurrection", medicFixture, "")
medicClient = medicApi.edicts[1]
medicAssert(medicApi.clientConnect(medicClient,
  "\\name\\MedicWitness\\skin\\male/grunt"), "Medic client connect")
medicAssert(medicApi.clientBegin(medicClient), "Medic client begin")

medicRuntime = medicgame.baseRuntime()
medicContext = medicgame.playerContext()
medicActor = findMedicActor(medicRuntime, "monster_medic")
medicWeakCorpse = findMedicActor(medicRuntime, "monster_soldier_light")
medicStrongCorpse = findMedicActor(medicRuntime, "monster_gunner")
prepareMedicCorpse(medicWeakCorpse, medicRuntime.aiContext)
prepareMedicCorpse(medicStrongCorpse, medicRuntime.aiContext)

medicAssert(nativeRawValue(medicRuntime.aiContext.findDeadMonster(medicActor)) ==
  nativeRawValue(medicStrongCorpse),
  "Medic chooses the highest-max-health visible corpse")
medicStrongCorpse.owner = medicActor
medicAssert(nativeRawValue(medicRuntime.aiContext.findDeadMonster(medicActor)) ==
  nativeRawValue(medicWeakCorpse), "reserved corpse is skipped")
medicStrongCorpse.owner = void

medicOldEnemy = medicRuntime.aiPlayers[0]
medicActor.enemy = medicOldEnemy
medicActor.oldEnemy = void
medicActor.info.search(medicActor, medicRuntime.aiContext)
medicAssert(nativeRawValue(medicActor.enemy) == nativeRawValue(medicStrongCorpse) and
  nativeRawValue(medicActor.oldEnemy) == nativeRawValue(medicOldEnemy) and
  nativeRawValue(medicStrongCorpse.owner) == nativeRawValue(medicActor) and
  (medicActor.info.aiFlags & medicaiconstants.AI_MEDIC) != 0,
  "medic_search reserves patient and preserves old enemy")

medicFrames = array(28)
medicFrameCount = 0
medicCableStarted = false
medicCableFinished = false
medicSteps = 0
while medicSteps < 80 and medicCableFinished != true
  medicApi.runFrame()
  if medicActor.activity == "medic-cable" then
    medicCableStarted = true
    medicFrames[medicFrameCount] = medicActor.edict.state.frame
    medicFrameCount = medicFrameCount + 1
  else if medicCableStarted then
    // finishMonsterAttack installs the run move after projecting attack60;
    // retain that final visible model frame before observing the transition.
    medicFrames[medicFrameCount] = medicActor.edict.state.frame
    medicFrameCount = medicFrameCount + 1
    medicCableFinished = true
  end if
  medicSteps = medicSteps + 1
end while
medicAssert(medicCableFinished and medicFrameCount == 28,
  "integrated Medic cable completes exact duration")
medicFrameIndex = 0
while medicFrameIndex < medicFrameCount
  medicAssert(medicFrames[medicFrameIndex] ==
    medicattack.modelFrameAt(medicCableAttackPlan, medicFrameIndex),
    "integrated Medic cable model frame " + medicFrameIndex)
  medicFrameIndex = medicFrameIndex + 1
end while

medicAssert(medicStrongCorpse.health == 175 and
  medicStrongCorpse.maxHealth == 175 and
  medicStrongCorpse.deadFlag == medicaiconstants.DEAD_NO and
  medicStrongCorpse.deathUseComplete != true and medicStrongCorpse.owner is void and
  (medicStrongCorpse.edict.serverFlags & medicgameconstants.SVF_DEADMONSTER) == 0 and
  (medicStrongCorpse.info.aiFlags & medicaiconstants.AI_RESURRECTING) == 0 and
  medicStrongCorpse.edict.mins.x == -16.0 and medicStrongCorpse.edict.maxs.z == 32.0,
  "attack50 respawns the original Gunner in place and attack52 clears shell state")
medicAssert(medicStrongCorpse.enemy is not void and medicStrongCorpse.enemy.isClient,
  "resurrected patient inherits Medic old player enemy")

medicBeamCount = 0
for each medicEvent in medicServer.pendingMulticasts
  if len(medicEvent.payload) == 16 and
      medicEvent.payload[0] == medicqconstants.SVC_TEMP_ENTITY and
      medicEvent.payload[1] == medicweaponconstants.TE_MEDIC_CABLE_ATTACK then
    medicAssert(medicEvent.destination == medicgameconstants.MULTICAST_PVS,
      "Medic cable multicast destination")
    medicBeamCount = medicBeamCount + 1
  end if
end for
medicAssert(medicBeamCount == 9, "attack43..51 emit nine Medic cable beams")

medicLaunchIndex = findMedicName(medicServer.soundNames, "medic/medatck2.wav")
medicHitIndex = findMedicName(medicServer.soundNames, "medic/medatck3.wav")
medicHealIndex = findMedicName(medicServer.soundNames, "medic/medatck4.wav")
medicRetractIndex = findMedicName(medicServer.soundNames, "medic/medatck5.wav")
medicLaunchCount = 0; medicHitCount = 0; medicHealCount = 0; medicRetractCount = 0
for each medicSound in medicsoundevents.pendingSnapshot(medicServer)
  if medicSound.soundIndex == medicLaunchIndex and
      medicSound.entity == medicActor.edict.state.number and
      medicSound.channel == medicgameconstants.CHAN_WEAPON then
    medicLaunchCount = medicLaunchCount + 1
  else if medicSound.soundIndex == medicHitIndex and
      medicSound.entity == medicStrongCorpse.edict.state.number and
      medicSound.channel == medicgameconstants.CHAN_AUTO then
    medicHitCount = medicHitCount + 1
  else if medicSound.soundIndex == medicHealIndex and
      medicSound.entity == medicActor.edict.state.number and
      medicSound.channel == medicgameconstants.CHAN_WEAPON then
    medicHealCount = medicHealCount + 1
  else if medicSound.soundIndex == medicRetractIndex and
      medicSound.entity == medicActor.edict.state.number and
      medicSound.channel == medicgameconstants.CHAN_WEAPON then
    medicRetractCount = medicRetractCount + 1
  end if
end for
medicAssert(medicLaunchCount == 1 and medicHitCount == 1 and
  medicHealCount == 1 and medicRetractCount == 1,
  "Medic launch/hit/heal/retract sounds use exact entities and channels")

// On the next run frame ai_checkattack sees the patient alive, clears AI_MEDIC
// and restores the saved player target exactly like the C path.
// The weaker fixture corpse only exists to verify strongest-patient selection;
// remove it here so medic_run cannot immediately start a second valid rescue.
medicWeakCorpse.edict.inUse = false
medicApi.runFrame()
medicAssert((medicActor.info.aiFlags & medicaiconstants.AI_MEDIC) == 0 and
  medicActor.enemy is not void and medicActor.enemy.isClient,
  "Medic returns to old player enemy after resurrection")

// medic_die frees a still-reserved patient for another Medic.
releaseContext = medicaitypes.defaultContext()
releaseMedic = medicarchetypes.SpawnMonster(medicarchetypes.defaultRegistry(),
  "monster_medic", 90, releaseContext)
releasePatient = medicarchetypes.SpawnMonster(medicarchetypes.defaultRegistry(),
  "monster_gunner", 91, releaseContext)
releaseMedic.enemy = releasePatient
releasePatient.owner = releaseMedic
releaseMedic.die(releaseMedic, void, 10, releaseContext)
medicAssert(releasePatient.owner is void, "dying Medic releases reserved patient")

medicApi.clientDisconnect(medicClient)
medicApi.shutdown()
print "gameplay_medic_resurrection_tests: PASS"
