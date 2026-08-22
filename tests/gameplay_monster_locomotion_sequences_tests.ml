/* Stock stand/idle/walk/run MD2 cycle inventory and integrated projection. */
import miniquake2.game.ai.locomotion_sequences as locomotionsequences
import miniquake2.game.null_game as locomotiongame
import miniquake2.server.game_bridge as locomotionbridge

function locomotionAssert(value, message)
  if value != true then return error(9978, message) end if
  return true
end function

locomotionClasses = [
  "monster_berserk", "monster_gladiator", "monster_gunner", "monster_infantry",
  "monster_soldier_light", "monster_soldier", "monster_soldier_ss", "monster_tank",
  "monster_tank_commander", "monster_medic", "monster_flipper", "monster_chick",
  "monster_parasite", "monster_flyer", "monster_brain", "monster_floater",
  "monster_hover", "monster_mutant", "monster_supertank", "monster_boss2",
  "monster_jorg", "monster_makron",
]
for each locomotionClassName in locomotionClasses
  locomotionPlan = locomotionsequences.stockPlan(locomotionClassName)
  locomotionAssert(locomotionsequences.validatePlan(locomotionPlan), locomotionClassName + " plan validates")
  locomotionAssert(locomotionsequences.modelFrameAt(locomotionPlan, "stand", 0, 0) == locomotionPlan.standFirst and
    locomotionsequences.modelFrameAt(locomotionPlan, "walk", 0, 0) == locomotionPlan.walkFirst and
    locomotionsequences.modelFrameAt(locomotionPlan, "run", 0, 0) == locomotionPlan.runFirst and
    locomotionsequences.modelFrameAt(locomotionPlan, "idle", 0, 0) == locomotionPlan.idleFirst,
    locomotionClassName + " cycle endpoints")
end for
locomotionAssert(locomotionsequences.stockPlan("misc_insane") is void,
  "dedicated misc_insane state machine remains separate")
locomotionAssert(locomotionsequences.stockPlan("monster_infantry").standFirst == 50 and
  locomotionsequences.stockPlan("monster_infantry").runLast == 99 and
  locomotionsequences.stockPlan("monster_makron").standFirst == 414 and
  locomotionsequences.stockPlan("monster_makron").runLast == 486,
  "reference locomotion endpoints")

locomotionServer = locomotionbridge.createRuntime(4)
locomotionApi = locomotiongame.GetGameApi(locomotionbridge.makeImports(locomotionServer))
locomotionServer.game = locomotionApi
locomotionApi.init()
locomotionFixture = "{\"classname\" \"worldspawn\"}" +
  "{\"classname\" \"monster_infantry\" \"origin\" \"128 0 10\" \"angle\" \"180\"}"
locomotionApi.spawnEntities("locomotion-sequence", locomotionFixture, "")
locomotionRuntime = locomotiongame.baseRuntime()
locomotionActor = locomotionRuntime.monsters[0]
locomotionPlan = locomotionsequences.stockPlan(locomotionActor.className)
locomotionStep = 0
while locomotionStep < 12
  locomotionApi.runFrame()
  locomotionAssert(locomotionActor.edict.state.frame == locomotionsequences.modelFrameAt(
    locomotionPlan, locomotionActor.activity, locomotionRuntime.aiContext.frameNumber,
    locomotionActor.edict.state.number), "integrated stand frame " + locomotionStep)
  locomotionStep = locomotionStep + 1
end while
locomotionApi.shutdown()

print "gameplay_monster_locomotion_sequences_tests: PASS"
