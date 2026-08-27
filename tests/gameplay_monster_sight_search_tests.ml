/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Quake II 3.19 class-specific sight/search callbacks and Soldier sight attack. */
import miniquake2.game.ai.archetypes as sightsarchetypes
import miniquake2.game.ai.monster as sightsmonster
import miniquake2.game.ai.sounds as sightssounds
import miniquake2.game.ai.types as sightstypes
import miniquake2.game.constants as sightsgameconstants
import miniquake2.qcommon.types as sightsqtypes

// Assert the sights test condition.
function sightsAssert(value, message)
  if value != true then return error(9971, message) end if
  return true
end function

capturedSightNames = array(32)
capturedSightChannels = array(32)
capturedSightAttenuations = array(32)
capturedSightCount = 0
testSightRolls = array(8)
testSightRollCount = 0
testSightRollPosition = 0
testSightRawRandom = 0

// Capture sight sound.
function captureSightSound(actor, soundName, channel, attenuation)
  global capturedSightCount
  capturedSightNames[capturedSightCount] = soundName
  capturedSightChannels[capturedSightCount] = channel
  capturedSightAttenuations[capturedSightCount] = attenuation
  capturedSightCount = capturedSightCount + 1
  return true
end function

// Return the next sight roll value.
function nextSightRoll()
  global testSightRollPosition
  if testSightRollPosition >= testSightRollCount then return 0.0 end if
  value = testSightRolls[testSightRollPosition]
  testSightRollPosition = testSightRollPosition + 1
  return value
end function

// Return the next sight raw random value.
function nextSightRawRandom()
  return testSightRawRandom
end function

// Reset sight capture.
function resetSightCapture()
  global capturedSightCount, testSightRollCount, testSightRollPosition
  capturedSightCount = 0
  testSightRollCount = 0
  testSightRollPosition = 0
  return true
end function

// Set sight rolls.
function setSightRolls(first, second)
  global testSightRollCount, testSightRollPosition
  testSightRolls[0] = first
  testSightRolls[1] = second
  testSightRollCount = 2
  testSightRollPosition = 0
  return true
end function

sightsRegistry = sightsarchetypes.defaultRegistry()
sightsContext = sightstypes.defaultContext()
sightsContext.playSound = captureSightSound
sightsContext.nextRandomUnit = nextSightRoll
sightsContext.nextRandomInteger = nextSightRawRandom
sightsContext.skill = 1

// Callback installation must mirror the original spawn functions, including
// classes that precache a search asset but never assign monsterinfo.search.
sightsBerserk = sightsarchetypes.SpawnMonster(sightsRegistry, "monster_berserk", 20, sightsContext)
sightsInfantry = sightsarchetypes.SpawnMonster(sightsRegistry, "monster_infantry", 21, sightsContext)
sightsParasite = sightsarchetypes.SpawnMonster(sightsRegistry, "monster_parasite", 22, sightsContext)
sightsSupertank = sightsarchetypes.SpawnMonster(sightsRegistry, "monster_supertank", 23, sightsContext)
sightsBoss2 = sightsarchetypes.SpawnMonster(sightsRegistry, "monster_boss2", 24, sightsContext)
sightsJorg = sightsarchetypes.SpawnMonster(sightsRegistry, "monster_jorg", 25, sightsContext)
sightsAssert(typeof(sightsBerserk.info.sight) == "function" and
  typeof(sightsBerserk.info.search) == "function", "Berserk owns sight and search callbacks")
sightsAssert(typeof(sightsInfantry.info.sight) == "function" and sightsInfantry.info.search is void,
  "Infantry owns sight but no search callback")
sightsAssert(typeof(sightsParasite.info.sight) == "function" and sightsParasite.info.search is void,
  "Parasite's unassigned search function remains unreachable")
sightsAssert(sightsSupertank.info.sight is void and typeof(sightsSupertank.info.search) == "function" and
  sightsBoss2.info.sight is void and typeof(sightsBoss2.info.search) == "function" and
  sightsJorg.info.sight is void and typeof(sightsJorg.info.search) == "function",
  "three stock bosses expose search without a sight callback")

resetSightCapture()
sightsEnemy = sightstypes.createClientTarget(1)
sightsInfantry.info.sight(sightsInfantry, sightsEnemy, sightsContext)
sightsAssert(capturedSightCount == 1 and capturedSightNames[0] == "infantry/infsght1.wav" and
  capturedSightChannels[0] == sightsgameconstants.CHAN_BODY and
  capturedSightAttenuations[0] == sightsgameconstants.ATTN_NORM,
  "Infantry sight uses the original body channel")

resetSightCapture()
sightsParasite.info.sight(sightsParasite, sightsEnemy, sightsContext)
sightsAssert(capturedSightCount == 1 and capturedSightNames[0] == "parasite/parsght1.wav" and
  capturedSightChannels[0] == sightsgameconstants.CHAN_WEAPON,
  "Parasite sight uses the original weapon channel")

sightsHover = sightsarchetypes.SpawnMonster(sightsRegistry, "monster_hover", 26, sightsContext)
resetSightCapture(); setSightRolls(0.75, 0.0)
sightsHover.info.search(sightsHover, sightsContext)
sightsAssert(testSightRollPosition == 1 and capturedSightCount == 1 and
  capturedSightNames[0] == "hover/hovsrch2.wav", "Hover random search2 callback")

resetSightCapture(); setSightRolls(0.75, 0.0)
sightsBoss2.info.search(sightsBoss2, sightsContext)
sightsAssert(testSightRollPosition == 1 and capturedSightCount == 0,
  "Boss2 consumes its failed 50-percent search draw without sound")
resetSightCapture(); setSightRolls(0.25, 0.0)
sightsBoss2.info.search(sightsBoss2, sightsContext)
sightsAssert(capturedSightCount == 1 and capturedSightNames[0] == "bosshovr/bhvunqv1.wav" and
  capturedSightAttenuations[0] == sightsgameconstants.ATTN_NONE,
  "Boss2 successful search uses global attenuation")

resetSightCapture(); setSightRolls(0.6001, 0.0)
sightsJorg.info.search(sightsJorg, sightsContext)
sightsAssert(capturedSightCount == 1 and capturedSightNames[0] == "boss3/bs3srch3.wav",
  "Jorg third search branch begins above 0.6")

sightsMedic = sightsarchetypes.SpawnMonster(sightsRegistry, "monster_medic", 27, sightsContext)
resetSightCapture()
sightsMedic.info.search(sightsMedic, sightsContext)
sightsAssert(capturedSightCount == 1 and capturedSightNames[0] == "medic/medsrch1.wav" and
  capturedSightAttenuations[0] == sightsgameconstants.ATTN_IDLE,
  "Medic search uses idle attenuation")

// soldier_sight consumes one draw for the voice and a second draw for the
// skill/range-gated run-and-shoot transition.
sightsSoldier = sightsarchetypes.SpawnMonster(sightsRegistry, "monster_soldier_light", 28, sightsContext)
sightsSoldier.edict.state.origin = sightsqtypes.Vec3(0.0, 0.0, 0.0)
sightsEnemy.edict.state.origin = sightsqtypes.Vec3(600.0, 0.0, 0.0)
resetSightCapture(); setSightRolls(0.75, 0.75)
sightsSoldier.info.sight(sightsSoldier, sightsEnemy, sightsContext)
sightsAssert(testSightRollPosition == 2 and capturedSightCount == 1 and
  capturedSightNames[0] == "soldier/solsrch1.wav" and
  sightsSoldier.activity == "soldier-run-shoot-pending",
  "Soldier second sight draw selects attack6 at mid range")
resetSightCapture(); setSightRolls(0.5, 0.5)
sightsSoldier.info.sight(sightsSoldier, sightsEnemy, sightsContext)
sightsAssert(testSightRollPosition == 2 and capturedSightNames[0] == "soldier/solsrch1.wav" and
  sightsSoldier.activity == "sight", "Soldier exact strict 0.5 sight/attack6 boundaries")

sightsMakron = sightsarchetypes.SpawnMonster(sightsRegistry, "monster_makron", 29, sightsContext)
resetSightCapture()
sightsAssert(sightsMakron.activity == "sight" and sightsMakron.info.currentMove.name == "makron-sight",
  "Makron spawn enters its active sight move")
sightsMakron.info.sight(sightsMakron, sightsEnemy, sightsContext)
sightsAssert(capturedSightCount == 0 and sightsMakron.activity == "sight" and
  sightsMakron.info.currentMove.name == "makron-sight" and
  sightsMakron.info.currentMove.firstFrame == 188 and sightsMakron.info.currentMove.lastFrame == 200 and
  typeof(sightsMakron.info.currentMove.endFunction) == "function",
  "Makron sight installs the exact silent 13-frame active move")

// mutant_step calls raw rand()%3 and uses CHAN_VOICE; it must not derive the
// variant from the current model frame.
sightsMutant = sightsarchetypes.SpawnMonster(sightsRegistry, "monster_mutant", 30, sightsContext)
sightsMutant.edict.state.frame = 57
testSightRawRandom = 5
resetSightCapture()
sightsmonster.StockStepSound(sightsMutant, sightsContext)
sightsAssert(capturedSightCount == 1 and capturedSightNames[0] == "mutant/step3.wav" and
  capturedSightChannels[0] == sightsgameconstants.CHAN_VOICE,
  "Mutant step consumes raw rand modulo three on the voice channel")

print "gameplay_monster_sight_search_tests: PASS"
