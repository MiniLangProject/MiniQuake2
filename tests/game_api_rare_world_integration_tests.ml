/* Product-graph wiring for the remaining stock campaign world state machines. */
import miniquake2.game.base.spawn as rareintegrationbase
import miniquake2.game.integration.baseq2 as rareintegration
import miniquake2.game.null_game as rareintegrationgame
import miniquake2.game.constants as rareintegrationgameconstants
import miniquake2.game.world.constants as rareintegrationconstants
import miniquake2.game.world.core as rareintegrationworld
import miniquake2.server.game_bridge as rareintegrationbridge

function requireTrue(value, label)
  if value != true then return error(9991, label) end if
end function

function rareNameIndex(values, value)
  index = 1
  while index < len(values)
    if values[index] == value then return index end if
    index = index + 1
  end while
  return 0
end function

function rareWorldClassCount(runtime, className)
  count = 0
  for each candidate in runtime.world.entities
    if candidate.inUse and candidate.className == className then count = count + 1 end if
  end for
  return count
end function

function rareWorldEvent(runtime, kind)
  found = void
  for each event in runtime.world.events
    if event[1] == kind then found = event end if
  end for
  return found
end function

fixture = "{ \"classname\" \"worldspawn\" }\n" +
  "{ \"classname\" \"info_player_start\" \"origin\" \"0 0 0\" }\n" +
  "{ \"classname\" \"point_combat\" \"targetname\" \"combat\" }\n" +
  "{ \"classname\" \"target_actor\" \"targetname\" \"actor\" }\n" +
  "{ \"classname\" \"target_character\" \"model\" \"*1\" \"count\" \"1\" }\n" +
  "{ \"classname\" \"target_string\" \"targetname\" \"display\" \"message\" \"1\" }\n" +
  "{ \"classname\" \"trigger_key\" \"item\" \"key_data_cd\" \"target\" \"unlocked\" }\n" +
  "{ \"classname\" \"trigger_relay\" \"targetname\" \"unlocked\" }\n" +
  "{ \"classname\" \"func_clock\" \"target\" \"display\" \"count\" \"2\" \"spawnflags\" \"13\" }\n" +
  "{ \"classname\" \"func_train\" \"model\" \"*2\" \"targetname\" \"lift\" \"target\" \"corner\" }\n" +
  "{ \"classname\" \"path_corner\" \"targetname\" \"corner\" }\n" +
  "{ \"classname\" \"trigger_elevator\" \"target\" \"lift\" }\n" +
  "{ \"classname\" \"light\" \"targetname\" \"ramp-light\" \"style\" \"32\" }\n" +
  "{ \"classname\" \"target_lightramp\" \"target\" \"ramp-light\" \"message\" \"az\" \"speed\" \"1\" }\n" +
  "{ \"classname\" \"func_killbox\" \"model\" \"*3\" }\n" +
  "{ \"classname\" \"info_notnull\" \"origin\" \"8 16 24\" \"targetname\" \"marker\" }\n" +
  "{ \"classname\" \"misc_viper\" \"target\" \"flight\" }\n" +
  "{ \"classname\" \"path_corner\" \"targetname\" \"flight\" }\n" +
  "{ \"classname\" \"misc_viper_bomb\" }\n" +
  "{ \"classname\" \"misc_satellite_dish\" }\n" +
  "{ \"classname\" \"misc_blackhole\" }\n" +
  "{ \"classname\" \"misc_eastertank\" }\n" +
  "{ \"classname\" \"misc_easterchick\" }\n" +
  "{ \"classname\" \"misc_easterchick2\" }\n" +
  "{ \"classname\" \"light_mine2\" }\n" +
  "{ \"classname\" \"info_notnull\" \"targetname\" \"turret-muzzle\" \"origin\" \"32 0 16\" }\n" +
  "{ \"classname\" \"turret_base\" \"team\" \"turret-a\" \"model\" \"*4\" }\n" +
  "{ \"classname\" \"turret_breach\" \"team\" \"turret-a\" \"targetname\" \"turret-gun\" \"target\" \"turret-muzzle\" \"model\" \"*5\" \"minpitch\" \"-20\" \"maxpitch\" \"30\" }\n" +
  "{ \"classname\" \"turret_driver\" \"target\" \"turret-gun\" \"origin\" \"0 -32 0\" }\n" +
  "{ \"classname\" \"monster_boss3_stand\" \"targetname\" \"boss-prop\" }\n" +
  "{ \"classname\" \"trigger_relay\" \"targetname\" \"boss-use\" \"target\" \"boss-prop\" }"

spawned = rareintegrationbase.SpawnEntities("rare", fixture, "")
requireTrue(spawned.skippedEntityCount == 0, "rare integration fixture must not skip classes")
runtime = rareintegration.create(spawned)

combat = rareintegration.findWorldByClass(runtime, "point_combat")
actor = rareintegration.findWorldByClass(runtime, "target_actor")
character = rareintegration.findWorldByClass(runtime, "target_character")
display = rareintegration.findWorldByClass(runtime, "target_string")
key = rareintegration.findWorldByClass(runtime, "trigger_key")
clock = rareintegration.findWorldByClass(runtime, "func_clock")
elevator = rareintegration.findWorldByClass(runtime, "trigger_elevator")
lightRamp = rareintegration.findWorldByClass(runtime, "target_lightramp")
killBox = rareintegration.findWorldByClass(runtime, "func_killbox")
marker = rareintegration.findWorldByClass(runtime, "info_notnull")
viper = rareintegration.findWorldByClass(runtime, "misc_viper")
bomb = rareintegration.findWorldByClass(runtime, "misc_viper_bomb")
dish = rareintegration.findWorldByClass(runtime, "misc_satellite_dish")
blackHole = rareintegration.findWorldByClass(runtime, "misc_blackhole")
easterTank = rareintegration.findWorldByClass(runtime, "misc_eastertank")
easterChick = rareintegration.findWorldByClass(runtime, "misc_easterchick")
easterChick2 = rareintegration.findWorldByClass(runtime, "misc_easterchick2")
mineLight = rareintegration.findWorldByClass(runtime, "light_mine2")
turretBase = rareintegration.findWorldByClass(runtime, "turret_base")
turretBreach = rareintegration.findWorldByClass(runtime, "turret_breach")
turretDriver = rareintegration.findWorldByClass(runtime, "turret_driver")
bossUse = void
for each rareBossUseCandidate in runtime.world.entities
  if rareBossUseCandidate.className == "trigger_relay" and rareBossUseCandidate.targetName == "boss-use" then
    bossUse = rareBossUseCandidate
  end if
end for
bossProp = void
for each rareBossCandidate in runtime.monsters
  if rareBossCandidate.className == "monster_boss3_stand" then bossProp = rareBossCandidate end if
end for

requireTrue(combat is not void and combat.touch is not void, "point_combat touch wiring")
requireTrue(combat.solid == rareintegrationconstants.SOLID_TRIGGER, "point_combat trigger shape")
requireTrue(actor is not void and actor.touch is not void, "target_actor touch wiring")
requireTrue(character is not void and character.solid == rareintegrationconstants.SOLID_BSP, "target_character BSP wiring")
requireTrue(display is not void and display.use is not void, "target_string use wiring")
requireTrue(key is not void and key.use is not void and key.itemName == "Data CD", "trigger_key stock inventory wiring")
requireTrue(clock is not void and clock.use is not void, "func_clock start-off wiring")
requireTrue(elevator is not void and elevator.think is not void, "trigger_elevator deferred wiring")
requireTrue(lightRamp is not void and lightRamp.use is not void, "target_lightramp use wiring")
requireTrue(killBox is not void and killBox.use is not void, "func_killbox use wiring")
requireTrue(marker is not void and marker.absoluteMins.x == 8.0 and marker.absoluteMaxs.z == 24.0, "info_notnull positional wiring")
requireTrue(viper is not void and viper.use is not void and viper.model == "models/ships/viper/tris.md2", "misc_viper train wiring")
requireTrue(bomb is not void and bomb.use is not void and bomb.damage == 1000, "misc_viper_bomb wiring")
requireTrue(dish is not void and dish.use is not void, "satellite dish use wiring")
requireTrue(blackHole is not void and blackHole.think is not void, "black hole animation wiring")
requireTrue(easterTank is not void and easterTank.frame == 254, "easter tank model wiring")
requireTrue(easterChick is not void and easterChick.frame == 208, "easter chick model wiring")
requireTrue(easterChick2 is not void and easterChick2.frame == 248, "easter chick2 model wiring")
requireTrue(mineLight is not void and mineLight.model == "models/objects/minelite/light2/tris.md2", "mine light model wiring")
requireTrue(turretBase is not void and turretBase.blocked is not void, "turret base product wiring")
requireTrue(turretBreach is not void and turretBreach.think is not void, "turret breach product wiring")
requireTrue(turretDriver is not void and turretDriver.think is not void, "turret driver product wiring")
requireTrue(turretBase.teamChain == turretBreach and turretBreach.item == turretDriver.item,
  "turret rig shares team and control")
requireTrue(bossUse is not void and bossProp is not void and bossProp.edict.inUse,
  "boss prop target proxy product wiring")
requireTrue(rareintegrationworld.useEntity(runtime.world, bossUse, void, void) and bossProp.edict.inUse == false,
  "world target dispatch reaches boss prop use")

raremeaning = rareintegrationworld.advance(runtime.world, runtime.world.frameTime)
requireTrue(raremeaning, "rare integration scheduler executes elevator initialization")
requireTrue(elevator.use is not void, "trigger_elevator resolves its train")

// Exercise the same turret through the shipped Game API so engine sound,
// projectile, difficulty, damage and physical-gib boundaries cannot drift
// independently from the isolated world state machine.
rareTurretFixture = "{\"classname\" \"worldspawn\"}" +
  "{\"classname\" \"info_player_start\" \"origin\" \"0 -512 0\"}" +
  "{\"classname\" \"info_notnull\" \"targetname\" \"live-muzzle\" \"origin\" \"32 0 16\"}" +
  "{\"classname\" \"turret_base\" \"team\" \"live-turret\" \"model\" \"*1\"}" +
  "{\"classname\" \"turret_breach\" \"team\" \"live-turret\" \"targetname\" \"live-gun\" \"target\" \"live-muzzle\" \"model\" \"*2\"}" +
  "{\"classname\" \"turret_driver\" \"target\" \"live-gun\" \"origin\" \"0 -32 0\"}"
rareTurretServer = rareintegrationbridge.createRuntime(4)
rareTurretApi = rareintegrationgame.GetGameApi(
  rareintegrationbridge.makeImports(rareTurretServer))
rareTurretServer.game = rareTurretApi
rareintegrationgame.configureSkill(3)
rareTurretApi.init()
rareTurretApi.spawnEntities("rare-turret", rareTurretFixture, "")
rareTurretClient = rareTurretApi.edicts[1]
requireTrue(rareTurretApi.clientConnect(rareTurretClient,
  "\\name\\TurretTarget\\skin\\male/grunt"), "turret target connects")
requireTrue(rareTurretApi.clientBegin(rareTurretClient), "turret target begins")
rareTurretRuntime = rareintegrationgame.baseRuntime()
rareTurretRuntime.randomState.seed = 1
rareTurretApi.runFrame(); rareTurretApi.runFrame(); rareTurretApi.runFrame()

rareLiveBreach = rareintegration.findWorldByClass(rareTurretRuntime, "turret_breach")
rareLiveDriver = rareintegration.findWorldByClass(rareTurretRuntime, "turret_driver")
rareFireEvent = rareWorldEvent(rareTurretRuntime, "turret-fire")
requireTrue(rareFireEvent is not void and rareFireEvent[3][0] == 100 and
  rareFireEvent[3][1] == 700,
  "live skill 3 turret consumes stock random damage and fires at speed 700")
requireTrue(rareTurretRuntime.randomState.seed == 2745024 and
  len(rareTurretRuntime.weaponContext.projectiles) == 1 and
  rareTurretRuntime.weaponContext.projectiles[0].className == "rocket" and
  rareTurretRuntime.weaponContext.projectiles[0].damage == 100 and
  rareTurretRuntime.weaponContext.projectiles[0].velocity.x == 700.0,
  "turret rocket uses shared CRT stream and live weapon projectile path")

rareRocketSoundIndex = rareNameIndex(rareTurretServer.soundNames,
  "weapons/rocklf1a.wav")
rarePositionedLaunches = 0
for each rareTurretSound in rareTurretServer.pendingSounds
  if rareTurretSound.soundIndex == rareRocketSoundIndex and
      rareTurretSound.entity == rareLiveBreach.number and
      rareTurretSound.channel == rareintegrationgameconstants.CHAN_WEAPON and
      rareTurretSound.position is not void then
    requireTrue(rareTurretSound.position.x == rareFireEvent[3][2].x and
      rareTurretSound.position.y == rareFireEvent[3][2].y and
      rareTurretSound.position.z == rareFireEvent[3][2].z,
      "turret launch sound is positioned at the exact muzzle")
    rarePositionedLaunches = rarePositionedLaunches + 1
  end if
end for
requireTrue(rarePositionedLaunches == 1, "one positioned launch sound per rocket")

rareGibsBefore = rareWorldClassCount(rareTurretRuntime, "monster_gib")
rareDriverEdictsBefore = rareTurretApi.numEdicts
rareDriverDeath = rareintegration.damageWorldEntity(
  rareTurretRuntime, rareLiveDriver.number, void, 120)
requireTrue(rareDriverDeath.killed and rareLiveDriver.health == -20 and
  rareLiveDriver.inUse == false and rareLiveBreach.owner is void and
  rareTurretApi.edicts[rareLiveDriver.number].inUse == false,
  "DAMAGE_AIM turret driver accepts live damage and detaches on death")
requireTrue(rareWorldClassCount(rareTurretRuntime, "monster_gib") -
  rareGibsBefore == 7 and rareTurretApi.numEdicts - rareDriverEdictsBefore == 7,
  "turret driver death emits the Infantry stock seven-gib inventory")
rareDeathSoundIndex = rareNameIndex(rareTurretServer.soundNames, "misc/udeath.wav")
rareDeathSounds = 0
for each rareTurretDeathSound in rareTurretServer.pendingSounds
  if rareTurretDeathSound.soundIndex == rareDeathSoundIndex and
      rareTurretDeathSound.entity == rareLiveDriver.number and
      rareTurretDeathSound.channel == rareintegrationgameconstants.CHAN_VOICE then
    rareDeathSounds = rareDeathSounds + 1
  end if
end for
requireTrue(rareDeathSounds == 1, "turret driver emits exact Infantry gib sound")

rareTurretApi.clientDisconnect(rareTurretClient)
rareTurretApi.shutdown()
print "game_api_rare_world_integration_tests: PASS"
