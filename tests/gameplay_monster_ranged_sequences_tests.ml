/* Product-shaped stock ranged monster timeline and muzzle regression. */
import miniquake2.game.ai.attack_sequences as rangedsequences
import miniquake2.game.null_game as rangedgame
import miniquake2.game.constants as rangedgameconstants
import miniquake2.qcommon.constants as rangedqconstants
import miniquake2.qcommon.types as rangedqtypes
import miniquake2.server.game_bridge as rangedbridge

function rangedAssert(value, message)
  if value != true then return error(9969, message) end if
  return true
end function

function runRangedSequence(className, origin)
  rangedServer = rangedbridge.createRuntime(4)
  rangedApi = rangedgame.GetGameApi(rangedbridge.makeImports(rangedServer))
  rangedServer.game = rangedApi
  rangedApi.init()
  rangedFixture = "{\"classname\" \"worldspawn\"}" +
    "{\"classname\" \"info_player_start\" \"origin\" \"0 0 0\"}" +
    "{\"classname\" \"" + className + "\" \"origin\" \"" + origin + "\" \"angle\" \"180\"}"
  rangedApi.spawnEntities("ranged-sequence", rangedFixture, "")
  rangedClient = rangedApi.edicts[1]
  rangedAssert(rangedApi.clientConnect(rangedClient, "\\name\\TimelineTarget\\skin\\male/grunt"),
    className + " connect")
  rangedAssert(rangedApi.clientBegin(rangedClient), className + " begin")
  rangedPlayer = rangedgame.playerContext().players[0]
  rangedPlayer.health = 100000; rangedPlayer.maxHealth = 100000
  rangedPlayer.edict.health = 100000; rangedPlayer.edict.maxHealth = 100000
  rangedApi.clientThink(rangedClient, rangedqtypes.UserCmd(0, 0, [0, 0, 0], 0, 0, 0, 0, 64))

  rangedActor = rangedgame.baseRuntime().monsters[0]
  rangedPlan = void
  rangedPlanName = ""
  rangedPlanCycles = 0
  rangedFrames = []
  rangedStep = 0
  rangedFinished = false
  while rangedStep < 240 and rangedFinished != true
    rangedApi.runFrame()
    if rangedPlan is void then
      rangedCandidate = rangedsequences.planByNameCycles(className, rangedActor.activity,
        rangedActor.edict.state.number, rangedActor.attackCount, rangedActor.attackCycles)
      if rangedCandidate is not void then
        rangedPlan = rangedCandidate
        rangedPlanName = rangedActor.activity
      end if
    end if
    if rangedPlan is not void then
      if rangedActor.attackCycles > rangedPlanCycles then
        rangedPlanCycles = rangedActor.attackCycles
      end if
      rangedFrames = rangedFrames + [rangedActor.edict.state.frame]
      if rangedActor.activity != rangedPlan.name then rangedFinished = true end if
    end if
    rangedStep = rangedStep + 1
  end while

  if rangedPlanCycles > 0 then
    rangedPlan = rangedsequences.planByNameCycles(className, rangedPlanName,
      rangedActor.edict.state.number, rangedActor.attackCount, rangedPlanCycles)
  end if
  rangedAssert(rangedPlan is not void and rangedsequences.validatePlan(rangedPlan),
    className + " selected validated stock plan")
  rangedAssert(rangedFinished and len(rangedFrames) == rangedPlan.durationFrames,
    className + " completed exact model timeline")
  rangedAssert(rangedFrames[0] == rangedsequences.modelFrameAt(rangedPlan, 0) and
    rangedFrames[len(rangedFrames) - 1] == rangedsequences.modelFrameAt(rangedPlan, rangedPlan.durationFrames - 1),
    className + " first/last stock model frame")
  rangedTimeline = 0
  while rangedTimeline < len(rangedFrames)
    rangedAssert(rangedFrames[rangedTimeline] == rangedsequences.modelFrameAt(rangedPlan, rangedTimeline),
      className + " model timeline frame " + rangedTimeline)
    rangedTimeline = rangedTimeline + 1
  end while

  rangedFlashes = []
  for each rangedEvent in rangedServer.pendingMulticasts
    if len(rangedEvent.payload) == 4 and rangedEvent.payload[0] == rangedqconstants.SVC_MUZZLEFLASH2 then
      rangedAssert(rangedEvent.destination == rangedgameconstants.MULTICAST_PVS,
        className + " muzzle destination")
      rangedFlashes = rangedFlashes + [rangedEvent.payload[3]]
    end if
  end for
  rangedAssert(rangedFlashes == rangedPlan.muzzleFlashes,
    className + " exact ordered muzzle sequence")
  rangedAssert(rangedActor.attackCount == 1, className + " one attack callback owns timeline")

  rangedApi.clientDisconnect(rangedClient)
  rangedApi.shutdown()
  return true
end function

runRangedSequence("monster_gladiator", "320 0 10")
runRangedSequence("monster_tank", "320 0 10")
runRangedSequence("monster_tank_commander", "320 0 10")
runRangedSequence("monster_medic", "240 0 10")
runRangedSequence("monster_chick", "320 0 10")
runRangedSequence("monster_flyer", "240 0 10")
runRangedSequence("monster_floater", "240 0 10")
runRangedSequence("monster_hover", "240 0 10")
runRangedSequence("monster_supertank", "320 0 10")

print "gameplay_monster_ranged_sequences_tests: PASS"
