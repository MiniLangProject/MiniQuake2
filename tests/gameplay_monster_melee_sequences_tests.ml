/* Product-shaped stock melee/drain timelines and Protocol-34 beam regression. */
import miniquake2.game.ai.attack_sequences as meleesequences
import miniquake2.game.null_game as meleegame
import miniquake2.game.constants as meleegameconstants
import miniquake2.game.weapons.constants as meleeweaponconstants
import miniquake2.qcommon.constants as meleeqconstants
import miniquake2.qcommon.types as meleeqtypes
import miniquake2.server.game_bridge as meleebridge

function meleeAssert(value, message)
  if value != true then return error(9974, message) end if
  return true
end function

function runMeleeSequence(className, origin, expectDrain)
  meleeServer = meleebridge.createRuntime(4)
  meleeApi = meleegame.GetGameApi(meleebridge.makeImports(meleeServer))
  meleeServer.game = meleeApi
  meleeApi.init()
  meleeFixture = "{\"classname\" \"worldspawn\"}" +
    "{\"classname\" \"info_player_start\" \"origin\" \"0 0 0\"}" +
    "{\"classname\" \"" + className + "\" \"origin\" \"" + origin + "\" \"angle\" \"180\"}"
  meleeApi.spawnEntities("melee-sequence", meleeFixture, "")
  meleeClient = meleeApi.edicts[1]
  meleeAssert(meleeApi.clientConnect(meleeClient, "\\name\\MeleeTarget\\skin\\male/grunt"),
    className + " connect")
  meleeAssert(meleeApi.clientBegin(meleeClient), className + " begin")
  meleePlayer = meleegame.playerContext().players[0]
  meleePlayer.health = 100000; meleePlayer.maxHealth = 100000
  meleePlayer.edict.health = 100000; meleePlayer.edict.maxHealth = 100000
  meleeApi.clientThink(meleeClient, meleeqtypes.UserCmd(0, 0, [0, 0, 0], 0, 0, 0, 0, 64))

  meleeActor = meleegame.baseRuntime().monsters[0]
  meleePlan = void
  meleePlanName = ""
  meleePlanCycles = 0
  meleeLoopTargetMoved = false
  meleeFrames = []
  meleeStep = 0
  meleeFinished = false
  while meleeStep < 280 and meleeFinished != true
    meleeApi.runFrame()
    if meleePlan is void then
      meleeCandidate = meleesequences.planByNameCycles(className, meleeActor.activity,
        meleeActor.edict.state.number, meleeActor.attackCount, meleeActor.attackCycles)
      if meleeCandidate is not void then
        meleePlan = meleeCandidate
        meleePlanName = meleeActor.activity
      end if
    end if
    if meleePlan is not void then
      if meleePlanName == "brain-tentacle" and
          meleeActor.activity == "brain-tentacle-claws" then
        meleePlanName = meleeActor.activity
        meleePlan = meleesequences.planByName(className, meleePlanName,
          meleeActor.edict.state.number, meleeActor.attackCount)
      end if
      if meleeActor.attackCycles > meleePlanCycles then meleePlanCycles = meleeActor.attackCycles end if
      meleeFrames = meleeFrames + [meleeActor.edict.state.frame]
      // Stock Chick/Flyer/Mutant refires are live rather than pre-bounded. A
      // stationary melee target can keep Mutant in attack09 forever, so move
      // the shared player/AI edict away after observing the second real cycle.
      if meleeLoopTargetMoved != true and meleePlanCycles >= 2 and
          (meleePlanName == "chick-slash" or meleePlanName == "flyer-slashes" or
           meleePlanName == "mutant-claws") then
        meleePlayer.edict.state.origin = meleeqtypes.Vec3(-160.0, 0.0, 0.0)
        meleeLoopTargetMoved = true
      end if
      if meleeActor.activity != meleePlan.name then meleeFinished = true end if
    end if
    meleeStep = meleeStep + 1
  end while

  if meleePlanCycles > 0 then
    meleePlan = meleesequences.planByNameCycles(className, meleePlanName,
      meleeActor.edict.state.number, meleeActor.attackCount, meleePlanCycles)
  end if
  meleeAssert(meleePlan is not void and meleesequences.validatePlan(meleePlan),
    className + " selected validated stock plan")
  meleeAssert(meleeFinished and len(meleeFrames) == meleePlan.durationFrames,
    className + " completed exact model timeline")
  meleeTimeline = 0
  while meleeTimeline < len(meleeFrames)
    meleeAssert(meleeFrames[meleeTimeline] == meleesequences.modelFrameAt(meleePlan, meleeTimeline),
      className + " model timeline frame " + meleeTimeline)
    meleeTimeline = meleeTimeline + 1
  end while

  meleeMuzzleCount = 0
  meleeBeamCount = 0
  for each meleeEvent in meleeServer.pendingMulticasts
    if len(meleeEvent.payload) >= 1 and meleeEvent.payload[0] == meleeqconstants.SVC_MUZZLEFLASH2 then
      meleeMuzzleCount = meleeMuzzleCount + 1
    end if
    if len(meleeEvent.payload) == 16 and
        meleeEvent.payload[0] == meleeqconstants.SVC_TEMP_ENTITY and
        meleeEvent.payload[1] == meleeweaponconstants.TE_PARASITE_ATTACK then
      meleeAssert(meleeEvent.destination == meleegameconstants.MULTICAST_PVS,
        className + " drain beam destination")
      meleeBeamCount = meleeBeamCount + 1
    end if
  end for
  meleeAssert(meleeMuzzleCount == 0, className + " melee emits no muzzle flash")
  if expectDrain then
    expectedDrainDamage = 0
    meleeDamageIndex = 0
    while meleeDamageIndex < len(meleePlan.frameOffsets)
      expectedDrainDamage = expectedDrainDamage + meleesequences.eventDamage(meleePlan, meleeDamageIndex)
      meleeDamageIndex = meleeDamageIndex + 1
    end while
    meleeAssert(meleePlan.name == "parasite-drain" and
      meleeBeamCount == len(meleePlan.frameOffsets), className + " exact drain beam count")
    meleeAssert(100000 - meleePlayer.health == expectedDrainDamage,
      className + " exact first/subsequent drain damage")
  else
    meleeAssert(meleeBeamCount == 0, className + " non-drain emits no parasite beam")
  end if
  meleeAssert(meleeActor.attackCount + meleeActor.meleeCount == 1,
    className + " one combat callback owns timeline")

  meleeApi.clientDisconnect(meleeClient)
  meleeApi.shutdown()
  return true
end function

runMeleeSequence("monster_berserk", "72 0 10", false)
runMeleeSequence("monster_infantry", "72 0 10", false)
runMeleeSequence("monster_flipper", "72 0 10", false)
runMeleeSequence("monster_chick", "72 0 10", false)
runMeleeSequence("monster_parasite", "96 0 10", true)
runMeleeSequence("monster_flyer", "72 0 10", false)
runMeleeSequence("monster_brain", "72 0 10", false)
runMeleeSequence("monster_floater", "72 0 10", false)
runMeleeSequence("monster_mutant", "72 0 10", false)

print "gameplay_monster_melee_sequences_tests: PASS"
