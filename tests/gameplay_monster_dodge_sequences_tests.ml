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
dodgeAssert(len(dodgeServer.pendingSounds) == 0, "duck move emits no synthetic sound")

dodgeApi.clientDisconnect(dodgeClient)
dodgeApi.shutdown()
print "gameplay_monster_dodge_sequences_tests: PASS"
