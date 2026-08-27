/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Stock pain/death frame tables plus integrated sound/corpse lifecycle. */
import miniquake2.game.ai.reaction_sequences as reactionsequences
import miniquake2.game.ai.monster as reactionmonster
import miniquake2.game.ai.types as reactionaitypes
import miniquake2.game.integration.baseq2 as reactionintegration
import miniquake2.game.null_game as reactiongame
import miniquake2.game.constants as reactionconstants
import miniquake2.qcommon.constants as reactionprotocolconstants
import miniquake2.qcommon.types as reactionqtypes
import miniquake2.server.game_bridge as reactionbridge

// Assert the reaction test condition.
function reactionAssert(value, message)
  if value != true then return error(9976, message) end if
  return true
end function

reactionClasses = [
  "monster_berserk", "monster_gladiator", "monster_gunner", "monster_infantry",
  "monster_soldier_light", "monster_soldier", "monster_soldier_ss", "monster_tank",
  "monster_tank_commander", "monster_medic", "monster_flipper", "monster_chick",
  "monster_parasite", "monster_flyer", "monster_brain", "monster_floater",
  "monster_hover", "monster_mutant", "monster_supertank", "monster_boss2",
  "monster_jorg", "monster_makron",
]

reactionPainPlans = 0
reactionDeathPlans = 0
reactionMovementFrames = 0
reactionMovementSum = 0.0
reactionMovementWeighted = 0.0
reactionMovementAbsWeighted = 0.0
reactionMovementSquareWeighted = 0.0
reactionFrameSoundCallbacks = 0
reactionFrameRandomCallbacks = 0
reactionExternalFrameCallbacks = 0
reactionBossExplosionCallbacks = 0
for each reactionClassName in reactionClasses
  reactionPainIndex = 0
  while reactionPainIndex < reactionsequences.painVariantCount(reactionClassName)
    reactionPainPlan = reactionsequences.painVariant(reactionClassName, reactionPainIndex)
    reactionAssert(reactionsequences.validatePlan(reactionPainPlan), reactionClassName + " pain plan validates")
    reactionAssert(reactionsequences.planByName(reactionClassName, reactionPainPlan.name).name == reactionPainPlan.name,
      reactionClassName + " pain plan reconstructs")
    reactionAssert(reactionsequences.modelFrameAt(reactionPainPlan, 0) == reactionPainPlan.firstFrame and
      reactionsequences.modelFrameAt(reactionPainPlan, reactionsequences.durationFrames(reactionPainPlan) - 1) == reactionPainPlan.lastFrame,
      reactionClassName + " pain frame projection")
    reactionMovementOffset = 0
    while reactionMovementOffset < reactionsequences.durationFrames(reactionPainPlan)
      reactionMovementDistance = reactionsequences.movementDistanceAt(
        reactionPainPlan, reactionMovementOffset)
      reactionMovementFrames = reactionMovementFrames + 1
      reactionMovementSum = reactionMovementSum + reactionMovementDistance
      reactionMovementWeighted = reactionMovementWeighted +
        reactionMovementDistance * reactionMovementFrames
      reactionMovementAbsolute = reactionMovementDistance
      if reactionMovementAbsolute < 0.0 then reactionMovementAbsolute = -reactionMovementAbsolute end if
      reactionMovementAbsWeighted = reactionMovementAbsWeighted +
        reactionMovementAbsolute * reactionMovementFrames
      reactionMovementSquareWeighted = reactionMovementSquareWeighted +
        reactionMovementDistance * reactionMovementDistance * reactionMovementFrames
      if reactionsequences.frameSoundNameAt(reactionPainPlan,
          reactionMovementOffset, 0.5) != "" then
        reactionFrameSoundCallbacks = reactionFrameSoundCallbacks + 1
      end if
      if reactionsequences.frameSoundUsesRandom(reactionPainPlan,
          reactionMovementOffset) then
        reactionFrameRandomCallbacks = reactionFrameRandomCallbacks + 1
      end if
      if reactionsequences.externalFrameEventAt(reactionPainPlan,
          reactionMovementOffset) != "" then
        reactionExternalFrameCallbacks = reactionExternalFrameCallbacks + 1
      end if
      if reactionsequences.startsBossExplosionAt(reactionPainPlan,
          reactionMovementOffset) then
        reactionBossExplosionCallbacks = reactionBossExplosionCallbacks + 1
      end if
      reactionMovementOffset = reactionMovementOffset + 1
    end while
    reactionPainPlans = reactionPainPlans + 1
    reactionPainIndex = reactionPainIndex + 1
  end while
  reactionDeathIndex = 0
  while reactionDeathIndex < reactionsequences.deathVariantCount(reactionClassName)
    reactionDeathPlan = reactionsequences.deathVariant(reactionClassName, reactionDeathIndex)
    reactionAssert(reactionsequences.validatePlan(reactionDeathPlan), reactionClassName + " death plan validates")
    reactionAssert(reactionsequences.planByName(reactionClassName, reactionDeathPlan.name).name == reactionDeathPlan.name,
      reactionClassName + " death plan reconstructs")
    reactionMovementOffset = 0
    while reactionMovementOffset < reactionsequences.durationFrames(reactionDeathPlan)
      reactionMovementDistance = reactionsequences.movementDistanceAt(
        reactionDeathPlan, reactionMovementOffset)
      reactionMovementFrames = reactionMovementFrames + 1
      reactionMovementSum = reactionMovementSum + reactionMovementDistance
      reactionMovementWeighted = reactionMovementWeighted +
        reactionMovementDistance * reactionMovementFrames
      reactionMovementAbsolute = reactionMovementDistance
      if reactionMovementAbsolute < 0.0 then reactionMovementAbsolute = -reactionMovementAbsolute end if
      reactionMovementAbsWeighted = reactionMovementAbsWeighted +
        reactionMovementAbsolute * reactionMovementFrames
      reactionMovementSquareWeighted = reactionMovementSquareWeighted +
        reactionMovementDistance * reactionMovementDistance * reactionMovementFrames
      if reactionsequences.frameSoundNameAt(reactionDeathPlan,
          reactionMovementOffset, 0.5) != "" then
        reactionFrameSoundCallbacks = reactionFrameSoundCallbacks + 1
      end if
      if reactionsequences.frameSoundUsesRandom(reactionDeathPlan,
          reactionMovementOffset) then
        reactionFrameRandomCallbacks = reactionFrameRandomCallbacks + 1
      end if
      if reactionsequences.externalFrameEventAt(reactionDeathPlan,
          reactionMovementOffset) != "" then
        reactionExternalFrameCallbacks = reactionExternalFrameCallbacks + 1
      end if
      if reactionsequences.startsBossExplosionAt(reactionDeathPlan,
          reactionMovementOffset) then
        reactionBossExplosionCallbacks = reactionBossExplosionCallbacks + 1
      end if
      reactionMovementOffset = reactionMovementOffset + 1
    end while
    reactionDeathPlans = reactionDeathPlans + 1
    reactionDeathIndex = reactionDeathIndex + 1
  end while
end for
reactionAssert(reactionPainPlans == 63 and reactionDeathPlans == 43,
  "complete stock pain/death variant inventory")
reactionAssert(reactionMovementFrames == 1813 and reactionMovementSum == -189.0 and
  reactionMovementWeighted == -46630.0 and
  reactionMovementAbsWeighted == 1822090.0 and
  reactionMovementSquareWeighted == 16890674.0,
  "all 3.19 pain/death movement columns match reference fingerprints")
reactionAssert(reactionFrameSoundCallbacks == 21 and reactionFrameRandomCallbacks == 1 and
  reactionExternalFrameCallbacks == 18 and reactionBossExplosionCallbacks == 3,
  "all stock pain/death frame callback inventories match reference")

reactionAssert(reactionsequences.painVariant("monster_berserk", 0).firstFrame == 199 and
  reactionsequences.painVariant("monster_berserk", 1).lastFrame == 222 and
  reactionsequences.deathVariant("monster_soldier", 5).lastFrame == 474 and
  reactionsequences.deathVariant("monster_makron", 0).firstFrame == 251 and
  reactionsequences.deathVariant("monster_makron", 0).lastFrame == 345,
  "reference frame endpoints")
reactionAssert(reactionsequences.selectPainPlan("monster_tank", 2, 1, 10, 1) is void and
  reactionsequences.selectPainPlan("monster_chick", 2, 1, 10, 1).name == "monster_chick-pain1" and
  reactionsequences.selectPainPlan("monster_chick", 2, 1, 25, 1).name == "monster_chick-pain2" and
  reactionsequences.selectPainPlan("monster_chick", 2, 1, 26, 1).name == "monster_chick-pain3" and
  reactionsequences.selectPainPlan("monster_chick", 2, 1, 99, 3) is void,
  "damage/skill pain selection")

reactionMakronPain6 = reactionsequences.painVariant("monster_makron", 2)
reactionMakronDeath = reactionsequences.deathVariant("monster_makron", 0)
reactionJorgPain3 = reactionsequences.painVariant("monster_jorg", 2)
reactionTankDeath = reactionsequences.deathVariant("monster_tank", 0)
reactionAssert(reactionsequences.frameSoundNameAt(reactionMakronPain6, 15, 0.0) ==
    "makron/popup.wav" and
  reactionsequences.frameSoundNameAt(reactionMakronPain6, 23, 0.3) ==
    "makron/voice4.wav" and
  reactionsequences.frameSoundNameAt(reactionMakronPain6, 23, 0.6) ==
    "makron/voice3.wav" and
  reactionsequences.frameSoundNameAt(reactionMakronPain6, 23, 0.6001) ==
    "makron/voice.wav",
  "Makron popup and exact taunt random boundaries")
reactionAssert(reactionsequences.frameSoundChannelAt(reactionMakronPain6, 23) ==
    reactionconstants.CHAN_AUTO and
  reactionsequences.frameSoundAttenuationAt(reactionMakronPain6, 23) ==
    reactionconstants.ATTN_NONE and
  reactionsequences.frameSoundNameAt(reactionMakronDeath, 90, 0.0) ==
    "makron/bhit.wav" and
  reactionsequences.frameSoundNameAt(reactionMakronDeath, 92, 0.0) ==
    "makron/brain1.wav" and
  reactionsequences.frameSoundChannelAt(reactionMakronDeath, 92) ==
    reactionconstants.CHAN_VOICE,
  "Makron callback channels and terminal sounds")
reactionAssert(reactionsequences.frameSoundNameAt(reactionJorgPain3, 2, 0.0) ==
    "boss3/step1.wav" and
  reactionsequences.frameSoundNameAt(reactionJorgPain3, 24, 0.0) ==
    "boss3/step2.wav" and
  reactionsequences.frameSoundNameAt(reactionTankDeath, 27, 0.0) ==
    "tank/thud.wav",
  "Jorg and Tank pain/death callback sounds")
reactionAssert(reactionsequences.externalFrameEventAt(
    reactionsequences.deathVariant("monster_infantry", 1), 10) ==
    "infantry-death-machinegun" and
  reactionsequences.externalFrameEventAt(
    reactionsequences.deathVariant("monster_soldier_ss", 0), 24) ==
    "soldier-death-fire" and
  reactionsequences.startsBossExplosionAt(
    reactionsequences.deathVariant("monster_boss2", 0), 48),
  "weapon and boss death callbacks retain exact frame offsets")

reactionRecordedFrameSounds = []
reactionRecordedRandomCalls = 0

// Record reaction frame sound.
function reactionRecordFrameSound(actor, soundName, channel, attenuation)
  global reactionRecordedFrameSounds
  reactionRecordedFrameSounds = reactionRecordedFrameSounds + [
    [soundName, channel, attenuation]]
  return true
end function

// Return the reaction fixed frame random value.
function reactionFixedFrameRandom()
  global reactionRecordedRandomCalls
  reactionRecordedRandomCalls = reactionRecordedRandomCalls + 1
  return 0.6
end function

reactionCallbackContext = reactionaitypes.defaultContext()
reactionCallbackContext.playSound = reactionRecordFrameSound
reactionCallbackContext.nextRandomUnit = reactionFixedFrameRandom
reactionCallbackActor = reactionaitypes.createActor(901, "monster_makron")
reactionAssert(reactionmonster.StartReaction(reactionCallbackActor,
  reactionMakronPain6, reactionCallbackContext), "Makron callback sequence starts")
reactionCallbackSteps = 0
while reactionCallbackActor.activity == reactionMakronPain6.name and
    reactionCallbackSteps < 32
  reactionCallbackContext.time = reactionCallbackContext.time + 0.1
  reactionmonster.MonsterThink(reactionCallbackActor, reactionCallbackContext)
  reactionCallbackSteps = reactionCallbackSteps + 1
end while
reactionAssert(len(reactionRecordedFrameSounds) == 3 and
  reactionRecordedFrameSounds[0][0] == "makron/pain1.wav" and
  reactionRecordedFrameSounds[1][0] == "makron/popup.wav" and
  reactionRecordedFrameSounds[1][1] == reactionconstants.CHAN_BODY and
  reactionRecordedFrameSounds[1][2] == reactionconstants.ATTN_NONE and
  reactionRecordedFrameSounds[2][0] == "makron/voice3.wav" and
  reactionRecordedFrameSounds[2][1] == reactionconstants.CHAN_AUTO and
  reactionRecordedRandomCalls == 1,
  "live Makron sequence emits exact sounds and consumes one random value")

// Collect integrated reaction.
function collectIntegratedReaction(api, actor, plan)
  frames = [actor.edict.state.frame]
  steps = 0
  while actor.activity == plan.name and steps < reactionsequences.durationFrames(plan) + 2
    api.runFrame()
    if actor.activity == plan.name then frames = frames + [actor.edict.state.frame] end if
    steps = steps + 1
  end while
  reactionAssert(len(frames) == reactionsequences.durationFrames(plan), plan.name + " exact duration")
  frameIndex = 0
  while frameIndex < len(frames)
    reactionAssert(frames[frameIndex] == reactionsequences.modelFrameAt(plan, frameIndex),
      plan.name + " frame " + frameIndex)
    frameIndex = frameIndex + 1
  end while
  return frames
end function

reactionServer = reactionbridge.createRuntime(4)
reactionApi = reactiongame.GetGameApi(reactionbridge.makeImports(reactionServer))
reactionServer.game = reactionApi
reactionApi.init()
reactionFixture = "{\"classname\" \"worldspawn\"}" +
  "{\"classname\" \"info_player_start\" \"origin\" \"0 0 0\"}" +
  "{\"classname\" \"monster_infantry\" \"origin\" \"256 0 10\" \"angle\" \"180\"}"
reactionApi.spawnEntities("reaction-sequence", reactionFixture, "")
reactionClient = reactionApi.edicts[1]
reactionAssert(reactionApi.clientConnect(reactionClient, "\\name\\ReactionTarget\\skin\\male/grunt"), "client connect")
reactionAssert(reactionApi.clientBegin(reactionClient), "client begin")
reactionApi.clientThink(reactionClient, reactionqtypes.UserCmd(0, 0, [0, 0, 0], 0, 0, 0, 0, 64))
reactionRuntime = reactiongame.baseRuntime()
reactionActor = reactionRuntime.monsters[0]

reactionPainStartX = reactionActor.edict.state.origin.x
reactionAssert(reactionintegration.damageMonster(reactionRuntime, 0, void, 20), "integrated pain dispatch")
reactionPain = reactionsequences.planByName(reactionActor.className, reactionActor.activity)
reactionAssert(reactionPain is not void and reactionPain.reactionKind == "pain", "integrated pain plan selected")
reactionAssert(reactionServer.pendingSoundCount == 1, "pain sound queued")
collectIntegratedReaction(reactionApi, reactionActor, reactionPain)
reactionPainTotal = 0.0
reactionPainOffset = 0
while reactionPainOffset < reactionsequences.durationFrames(reactionPain)
  reactionPainTotal = reactionPainTotal +
    reactionsequences.movementDistanceAt(reactionPain, reactionPainOffset)
  reactionPainOffset = reactionPainOffset + 1
end while
reactionPainDeltaError = reactionActor.edict.state.origin.x - reactionPainStartX +
  reactionPainTotal
reactionAssert(reactionPainDeltaError > -0.001 and reactionPainDeltaError < 0.001,
  "integrated pain executes every movement column")

reactionActor.health = 1
reactionDeathStartX = reactionActor.edict.state.origin.x
reactionAssert(reactionintegration.damageMonster(reactionRuntime, 0, void, 1), "integrated normal death dispatch")
reactionDeath = reactionsequences.planByName(reactionActor.className, reactionActor.activity)
reactionAssert(reactionDeath is not void and reactionDeath.reactionKind == "death", "integrated death plan selected")
reactionAssert(reactionServer.pendingSoundCount == 2, "death sound queued")
reactionDeathFrames = collectIntegratedReaction(reactionApi, reactionActor, reactionDeath)
reactionAssert(reactionActor.activity == "corpse" and reactionActor.nextThink == 0.0 and
  reactionActor.edict.state.frame == reactionDeath.lastFrame,
  "death reaches persistent terminal corpse")
reactionDeathTotal = 0.0
reactionDeathOffset = 0
while reactionDeathOffset < reactionsequences.durationFrames(reactionDeath)
  reactionDeathTotal = reactionDeathTotal +
    reactionsequences.movementDistanceAt(reactionDeath, reactionDeathOffset)
  reactionDeathOffset = reactionDeathOffset + 1
end while
reactionDeathDeltaError = reactionActor.edict.state.origin.x - reactionDeathStartX +
  reactionDeathTotal
if reactionDeathDeltaError <= -0.001 or reactionDeathDeltaError >= 0.001 then
  print "reaction death movement diagnostic: plan=" + reactionDeath.name +
    " start=" + reactionDeathStartX + " end=" + reactionActor.edict.state.origin.x +
    " total=" + reactionDeathTotal + " error=" + reactionDeathDeltaError +
    " yaw=" + reactionActor.edict.state.angles.y
end if
reactionAssert(reactionDeathDeltaError > -0.001 and reactionDeathDeltaError < 0.001,
  "integrated death executes every movement column")

reactionApi.clientDisconnect(reactionClient)
reactionApi.shutdown()

// Return the reaction muzzle flash count.
function reactionMuzzleFlashCount(events, flash)
  reactionMuzzleCount = 0
  for each reactionMuzzleEvent in events
    if len(reactionMuzzleEvent.payload) == 4 and
        reactionMuzzleEvent.payload[0] == reactionprotocolconstants.SVC_MUZZLEFLASH2 and
        reactionMuzzleEvent.payload[3] == flash then
      reactionMuzzleCount = reactionMuzzleCount + 1
    end if
  end for
  return reactionMuzzleCount
end function

// Run all fixed-direction death weapons through the real GameImport boundary.
// The resulting svc_muzzleflash2 inventory is a compact protocol-level proof
// that every callback uses its stock flash number; SS death frames remain held
// for their original randomized burst instead of collapsing to one bullet.
reactionFireServer = reactionbridge.createRuntime(4)
reactionFireApi = reactiongame.GetGameApi(reactionbridge.makeImports(reactionFireServer))
reactionFireServer.game = reactionFireApi
reactionFireApi.init()
reactionFireFixture = "{\"classname\" \"worldspawn\"}" +
  "{\"classname\" \"info_player_start\" \"origin\" \"0 0 0\"}" +
  "{\"classname\" \"monster_infantry\" \"origin\" \"128 400 10\"}" +
  "{\"classname\" \"monster_soldier_light\" \"origin\" \"128 800 10\"}" +
  "{\"classname\" \"monster_soldier\" \"origin\" \"128 1200 10\"}" +
  "{\"classname\" \"monster_soldier_ss\" \"origin\" \"128 1600 10\"}"
reactionFireApi.spawnEntities("reaction-death-fire", reactionFireFixture, "")
reactionFireRuntime = reactiongame.baseRuntime()
reactionFireIndex = 0
while reactionFireIndex < len(reactionFireRuntime.monsters)
  reactionFireActor = reactionFireRuntime.monsters[reactionFireIndex]
  reactionFireActor.health = 0
  reactionFireActor.edict.health = 0
  reactionFirePlan = reactionsequences.deathVariant(reactionFireActor.className, 0)
  if reactionFireActor.className == "monster_infantry" then
    reactionFirePlan = reactionsequences.deathVariant(reactionFireActor.className, 1)
  end if
  reactionAssert(reactionmonster.StartReaction(reactionFireActor,
    reactionFirePlan, reactionFireRuntime.aiContext),
    reactionFireActor.className + " fixed death fire starts")
  reactionFireIndex = reactionFireIndex + 1
end while
reactionFireFrames = 0
while reactionFireFrames < 64
  reactionFireApi.runFrame()
  reactionFireFrames = reactionFireFrames + 1
end while
reactionFireMuzzles = 0
for each reactionFireEvent in reactionFireServer.pendingMulticasts
  if len(reactionFireEvent.payload) == 4 and
      reactionFireEvent.payload[0] == reactionprotocolconstants.SVC_MUZZLEFLASH2 then
    reactionFireMuzzles = reactionFireMuzzles + 1
  end if
end for
reactionSsFirstBurst = reactionMuzzleFlashCount(
  reactionFireServer.pendingMulticasts, 94)
reactionSsSecondBurst = reactionMuzzleFlashCount(
  reactionFireServer.pendingMulticasts, 97)
reactionAssert(reactionFireMuzzles == 16 + reactionSsFirstBurst +
    reactionSsSecondBurst and
  reactionSsFirstBurst >= 3 and reactionSsFirstBurst <= 10 and
  reactionSsSecondBurst >= 3 and reactionSsSecondBurst <= 10,
  "Infantry/Soldier deaths emit fixed flashes plus two held SS bursts")
reactionInfantryFlash = 27
while reactionInfantryFlash <= 38
  reactionAssert(reactionMuzzleFlashCount(reactionFireServer.pendingMulticasts,
    reactionInfantryFlash) == 1,
    "Infantry death muzzle flash " + reactionInfantryFlash)
  reactionInfantryFlash = reactionInfantryFlash + 1
end while
reactionSoldierFlash = 92
while reactionSoldierFlash <= 97
  reactionSoldierExpectedCount = 1
  if reactionSoldierFlash == 94 then reactionSoldierExpectedCount = reactionSsFirstBurst end if
  if reactionSoldierFlash == 97 then reactionSoldierExpectedCount = reactionSsSecondBurst end if
  reactionAssert(reactionMuzzleFlashCount(reactionFireServer.pendingMulticasts,
    reactionSoldierFlash) == reactionSoldierExpectedCount,
    "Soldier death muzzle flash " + reactionSoldierFlash)
  reactionSoldierFlash = reactionSoldierFlash + 1
end while
reactionFireApi.shutdown()

print "gameplay_monster_reaction_sequences_tests: PASS"
