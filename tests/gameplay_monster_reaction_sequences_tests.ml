/* Stock pain/death frame tables plus integrated sound/corpse lifecycle. */
import miniquake2.game.ai.reaction_sequences as reactionsequences
import miniquake2.game.integration.baseq2 as reactionintegration
import miniquake2.game.null_game as reactiongame
import miniquake2.qcommon.types as reactionqtypes
import miniquake2.server.game_bridge as reactionbridge

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
    reactionPainPlans = reactionPainPlans + 1
    reactionPainIndex = reactionPainIndex + 1
  end while
  reactionDeathIndex = 0
  while reactionDeathIndex < reactionsequences.deathVariantCount(reactionClassName)
    reactionDeathPlan = reactionsequences.deathVariant(reactionClassName, reactionDeathIndex)
    reactionAssert(reactionsequences.validatePlan(reactionDeathPlan), reactionClassName + " death plan validates")
    reactionAssert(reactionsequences.planByName(reactionClassName, reactionDeathPlan.name).name == reactionDeathPlan.name,
      reactionClassName + " death plan reconstructs")
    reactionDeathPlans = reactionDeathPlans + 1
    reactionDeathIndex = reactionDeathIndex + 1
  end while
end for
reactionAssert(reactionPainPlans == 63 and reactionDeathPlans == 43,
  "complete stock pain/death variant inventory")

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

reactionAssert(reactionintegration.damageMonster(reactionRuntime, 0, void, 20), "integrated pain dispatch")
reactionPain = reactionsequences.planByName(reactionActor.className, reactionActor.activity)
reactionAssert(reactionPain is not void and reactionPain.reactionKind == "pain", "integrated pain plan selected")
reactionAssert(len(reactionServer.pendingSounds) == 1, "pain sound queued")
collectIntegratedReaction(reactionApi, reactionActor, reactionPain)

reactionActor.health = 1
reactionAssert(reactionintegration.damageMonster(reactionRuntime, 0, void, 1), "integrated normal death dispatch")
reactionDeath = reactionsequences.planByName(reactionActor.className, reactionActor.activity)
reactionAssert(reactionDeath is not void and reactionDeath.reactionKind == "death", "integrated death plan selected")
reactionAssert(len(reactionServer.pendingSounds) == 2, "death sound queued")
reactionDeathFrames = collectIntegratedReaction(reactionApi, reactionActor, reactionDeath)
reactionAssert(reactionActor.activity == "corpse" and reactionActor.nextThink == 0.0 and
  reactionActor.edict.state.frame == reactionDeath.lastFrame,
  "death reaches persistent terminal corpse")

reactionApi.clientDisconnect(reactionClient)
reactionApi.shutdown()

print "gameplay_monster_reaction_sequences_tests: PASS"
