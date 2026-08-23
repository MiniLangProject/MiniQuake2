/* Original check_dodge handoff and the six stock duck frame tables. */
import miniquake2.game.ai.constants as dodgeconstants
import miniquake2.game.ai.reaction_sequences as dodgesequences
import miniquake2.game.integration.baseq2 as dodgeintegration
import miniquake2.game.null_game as dodgegame
import miniquake2.qcommon.types as dodgeqtypes
import miniquake2.server.game_bridge as dodgebridge

function dodgeAssert(value, message)
  if value != true then return error(9977, message) end if
  return true
end function

dodgeClasses = [
  "monster_gunner", "monster_chick", "monster_soldier_light",
  "monster_soldier", "monster_soldier_ss", "monster_medic",
  "monster_infantry", "monster_brain",
]
dodgeFirstFrames = [201, 83, 45, 45, 45, 131, 120, 146]
dodgeLastFrames = [208, 89, 49, 49, 49, 146, 124, 153]
dodgeIndex = 0
while dodgeIndex < len(dodgeClasses)
  dodgePlan = dodgesequences.stockDodgePlan(dodgeClasses[dodgeIndex])
  dodgeAssert(dodgesequences.validatePlan(dodgePlan) and
    dodgePlan.firstFrame == dodgeFirstFrames[dodgeIndex] and
    dodgePlan.lastFrame == dodgeLastFrames[dodgeIndex] and
    dodgesequences.planByName(dodgeClasses[dodgeIndex], dodgePlan.name).name == dodgePlan.name,
    dodgeClasses[dodgeIndex] + " stock duck frames")
  dodgeIndex = dodgeIndex + 1
end while
dodgeAssert(dodgesequences.stockDodgePlan("monster_tank") is void, "non-dodging stock class remains unsupported")

dodgeServer = dodgebridge.createRuntime(4)
dodgeApi = dodgegame.GetGameApi(dodgebridge.makeImports(dodgeServer))
dodgeServer.game = dodgeApi
dodgeApi.init()
dodgeFixture = "{\"classname\" \"worldspawn\"}" +
  "{\"classname\" \"info_player_start\" \"origin\" \"0 0 0\"}" +
  "{\"classname\" \"monster_gunner\" \"origin\" \"256 0 10\" \"angle\" \"180\"}"
dodgeApi.spawnEntities("dodge-sequence", dodgeFixture, "")
dodgeClient = dodgeApi.edicts[1]
dodgeAssert(dodgeApi.clientConnect(dodgeClient, "\\name\\DodgeShooter\\skin\\male/grunt"), "client connect")
dodgeAssert(dodgeApi.clientBegin(dodgeClient), "client begin")
dodgeRuntime = dodgegame.baseRuntime()
dodgePlayerContext = dodgegame.playerContext()
dodgePlayer = dodgePlayerContext.players[0]
dodgeOwner = dodgeintegration.playerWeaponTarget(dodgePlayer, dodgePlayerContext.registry)
dodgeActor = dodgeRuntime.monsters[0]
dodgePlan = dodgesequences.stockDodgePlan(dodgeActor.className)
dodgeRuntime.randomState.seed = 1

dodgeAssert(dodgeRuntime.weaponContext.callbacks.dodge(dodgeOwner,
  dodgeqtypes.Vec3(0.0, 0.0, 22.0), dodgeqtypes.Vec3(1.0, 0.0, 0.0), 1000.0),
  "projectile check_dodge selects traced monster")
dodgeAssert(dodgeActor.activity == dodgePlan.name and
  (dodgeActor.info.aiFlags & dodgeconstants.AI_DUCKED) != 0 and
  dodgeActor.edict.maxs.z == dodgeActor.maxs[2] - 32.0,
  "duck enters lowered collision bounds")

dodgeFrames = [dodgeActor.edict.state.frame]
dodgeSteps = 0
while dodgeActor.activity == dodgePlan.name and dodgeSteps < dodgesequences.durationFrames(dodgePlan) + 2
  dodgeApi.runFrame()
  if dodgeActor.activity == dodgePlan.name then dodgeFrames = dodgeFrames + [dodgeActor.edict.state.frame] end if
  dodgeSteps = dodgeSteps + 1
end while
dodgeAssert(len(dodgeFrames) == dodgesequences.durationFrames(dodgePlan), "exact integrated dodge duration")
dodgeFrameIndex = 0
while dodgeFrameIndex < len(dodgeFrames)
  dodgeAssert(dodgeFrames[dodgeFrameIndex] == dodgesequences.modelFrameAt(dodgePlan, dodgeFrameIndex),
    "integrated dodge frame " + dodgeFrameIndex)
  dodgeFrameIndex = dodgeFrameIndex + 1
end while
dodgeAssert((dodgeActor.info.aiFlags & dodgeconstants.AI_DUCKED) == 0 and
  dodgeActor.edict.maxs.z == dodgeActor.maxs[2], "duck exit restores collision bounds")
dodgeAssert(dodgeServer.pendingSoundCount == 0, "duck move emits no synthetic sound")

dodgeApi.clientDisconnect(dodgeClient)
dodgeApi.shutdown()

// On skill 2 the Soldier consumes a second callback draw and selects attack3
// for values through 0.66. Seed 1 produces a passing dodge draw followed by
// the attack branch, exercising the real trace-to-combat handoff.
dodgeSoldierServer = dodgebridge.createRuntime(4)
dodgeSoldierApi = dodgegame.GetGameApi(dodgebridge.makeImports(dodgeSoldierServer))
dodgeSoldierServer.game = dodgeSoldierApi
dodgeSoldierApi.init()
dodgeSoldierFixture = "{\"classname\" \"worldspawn\"}" +
  "{\"classname\" \"info_player_start\" \"origin\" \"0 0 0\"}" +
  "{\"classname\" \"monster_soldier_light\" \"origin\" \"256 0 10\" \"angle\" \"180\"}"
dodgeSoldierApi.spawnEntities("dodge-soldier-attack", dodgeSoldierFixture, "")
dodgeSoldierClient = dodgeSoldierApi.edicts[1]
dodgeAssert(dodgeSoldierApi.clientConnect(dodgeSoldierClient,
  "\\name\\DodgeAttackShooter\\skin\\male/grunt"), "Soldier dodge client connect")
dodgeAssert(dodgeSoldierApi.clientBegin(dodgeSoldierClient), "Soldier dodge client begin")
dodgeSoldierRuntime = dodgegame.baseRuntime()
dodgeSoldierRuntime.aiContext.skill = 2
dodgeSoldierRuntime.randomState.seed = 1
dodgeSoldierPlayerContext = dodgegame.playerContext()
dodgeSoldierPlayer = dodgeSoldierPlayerContext.players[0]
dodgeSoldierOwner = dodgeintegration.playerWeaponTarget(dodgeSoldierPlayer,
  dodgeSoldierPlayerContext.registry)
dodgeSoldierActor = dodgeSoldierRuntime.monsters[0]
dodgeAssert(dodgeSoldierRuntime.weaponContext.callbacks.dodge(dodgeSoldierOwner,
  dodgeqtypes.Vec3(0.0, 0.0, 22.0), dodgeqtypes.Vec3(1.0, 0.0, 0.0), 1000.0) and
  dodgeSoldierActor.activity == "soldier-duck-shoot-pending" and
  dodgeSoldierActor.enemy is not void,
  "skill-2 Soldier exact second draw selects attack3")
dodgeSoldierApi.runFrame()
dodgeAssert(dodgeSoldierActor.activity == "soldier-duck-shoot" and
  dodgeSoldierActor.edict.state.frame == 30, "Soldier attack3 starts at attack301")
dodgeSoldierSawLoweredBounds = false
dodgeSoldierSteps = 0
while dodgeSoldierActor.activity == "soldier-duck-shoot" and dodgeSoldierSteps < 20
  if (dodgeSoldierActor.info.aiFlags & dodgeconstants.AI_DUCKED) != 0 and
      dodgeSoldierActor.edict.maxs.z == dodgeSoldierActor.maxs[2] - 32.0 then
    dodgeSoldierSawLoweredBounds = true
  end if
  dodgeSoldierApi.runFrame()
  dodgeSoldierSteps = dodgeSoldierSteps + 1
end while
dodgeAssert(dodgeSoldierSawLoweredBounds and
  (dodgeSoldierActor.info.aiFlags & dodgeconstants.AI_DUCKED) == 0 and
  dodgeSoldierActor.edict.maxs.z == dodgeSoldierActor.maxs[2] and
  dodgeSoldierActor.activity == "run",
  "integrated Soldier attack3 lowers then restores collision bounds")
dodgeSoldierApi.clientDisconnect(dodgeSoldierClient)
dodgeSoldierApi.shutdown()

print "gameplay_monster_dodge_sequences_tests: PASS"
