/* Native deterministic scenarios for the BaseQ2 player/client rules. */
import miniquake2.game.ai.types as gaitypes
import miniquake2.game.base.spawn as gplayerbasespawn
import miniquake2.game.base.types as btypes
import miniquake2.game.constants as gameconstants
import miniquake2.game.gameplay.constants as gpconstants
import miniquake2.game.gameplay.item_rules as gprules
import miniquake2.game.gameplay.registry as gpregistry
import miniquake2.game.gameplay.types as gptypes
import miniquake2.game.integration.baseq2 as gplayerintegration
import miniquake2.game.player.client as gplayerclient
import miniquake2.game.player.frame as gplayerframe
import miniquake2.game.player.hud as gplayerhud
import miniquake2.game.player.rules as gplayerrules
import miniquake2.game.player.spawn as gplayerspawn
import miniquake2.game.player.types as gplayertypes
import miniquake2.game.player.userinfo as gplayeruserinfo
import miniquake2.qcommon.constants as qconstants
import miniquake2.qcommon.types as qtypes
import miniquake2.server.game_bridge as gbridge
import std.string as gplayerstring

weaponThinkCount = 0

function assertEqual(actual, expected, name)
  if actual != expected then return error(9790, name + ": values differ") end if
  return true
end function

function assertTrue(value, name)
  if value != true then return error(9791, name + ": expected true") end if
  return true
end function

function assertContains(value, expected, name)
  if gplayerstring.contains(value, expected) != true then return error(9792, name + ": missing text " + expected) end if
  return true
end function

function emptyTrace(start, mins, maxs, finish)
  plane = qtypes.Plane(qtypes.Vec3(0.0, 0.0, 0.0), 0.0, 0, 0)
  surface = qtypes.CollisionSurface("player/test", 0, 0)
  return qtypes.Trace(false, false, 1.0, qtypes.Vec3(finish.x, finish.y, finish.z), plane, surface, 0, void)
end function

function banned(ip)
  return ip == "10.0.0.9"
end function

function fixedRandom(count)
  return 0
end function

function weaponThink(player, context)
  global weaponThinkCount
  weaponThinkCount = weaponThinkCount + 1
  return true
end function

function makeContext(maxClients)
  runtime = gbridge.createRuntime(maxClients)
  imports = gbridge.makeImports(runtime)
  registry = gpregistry.defaultRegistry()
  context = gplayertypes.createContext(imports, registry, emptyTrace)
  context.randomIndex = fixedRandom
  return context
end function

function addDefaultSpawns(context)
  context.spawnSpots = [
    gplayertypes.spawnSpot("info_player_start", "", [0.0, 0.0, 0.0], [0.0, 90.0, 0.0]),
    gplayertypes.spawnSpot("info_player_start", "secret", [64.0, 0.0, 0.0], [0.0, 180.0, 0.0]),
    gplayertypes.spawnSpot("info_player_coop", "", [16.0, 0.0, 0.0], [0.0, 45.0, 0.0]),
    gplayertypes.spawnSpot("info_player_deathmatch", "", [0.0, 0.0, 0.0], [0.0, 0.0, 0.0]),
    gplayertypes.spawnSpot("info_player_deathmatch", "", [100.0, 0.0, 0.0], [0.0, 0.0, 0.0]),
    gplayertypes.spawnSpot("info_player_deathmatch", "", [200.0, 0.0, 0.0], [0.0, 0.0, 0.0]),
    gplayertypes.spawnSpot("info_player_deathmatch", "", [300.0, 0.0, 0.0], [0.0, 0.0, 0.0])
  ]
end function

function spawnpointLifetimeText()
  text = "{ \"classname\" \"worldspawn\" }\n"
  index = 0
  while index < 32
    text = text +
      "{ \"classname\" \"info_player_start\" \"targetname\" \"start_" + index +
      "\" \"origin\" \"" + index + " 1 2\" \"angle\" \"90\" }\n" +
      "{ \"classname\" \"info_player_coop\" \"targetname\" \"coop\" " +
      "\"origin\" \"" + index + " 3 4\" \"angle\" \"180\" }\n" +
      "{ \"classname\" \"info_player_deathmatch\" \"origin\" \"" + index +
      " 5 6\" \"angle\" \"270\" }\n"
    index = index + 1
  end while
  return text
end function

function testRepeatedSpawnpointLifetime()
  entityText = spawnpointLifetimeText()
  iteration = 0
  while iteration < 96
    spawned = gplayerbasespawn.SpawnEntities("spawnpoint-lifetime-" + iteration, entityText, "")
    // Allocate the complete integrated level before scanning the retained
    // BaseEdict components, matching the product map-reset ordering that
    // originally exposed the lifetime bug.
    integrated = gplayerintegration.create(spawned)
    assertTrue(len(integrated.world.entities) >= 97,
      "spawnpoint lifetime integrated world count")
    spots = gplayerspawn.spotsFromBaseEdicts(spawned.edicts)
    assertEqual(len(spots), 96, "spawnpoint lifetime count")
    assertEqual(spots[0].className, "info_player_start", "spawnpoint lifetime first class")
    assertEqual(spots[95].className, "info_player_deathmatch", "spawnpoint lifetime last class")
    assertEqual(spots[93].targetName, "start_31", "spawnpoint lifetime target")
    iteration = iteration + 1
  end while

  malformedComponent = btypes.zeroBaseEntity()
  malformedEdict = btypes.makeBaseEdict(0, 0, malformedComponent)
  malformedEdict.component = void
  malformedResult = try(gplayerspawn.spotsFromBaseEdicts([malformedEdict]))
  assertTrue(malformedResult is error, "malformed spawnpoint component rejected")
  assertEqual(malformedResult.message,
    "spawnpoint scan encountered a malformed BaseEntity component",
    "malformed spawnpoint diagnostic")
  return true
end function

function testConnectUserinfoAndSpectator()
  context = makeContext(4)
  addDefaultSpawns(context)
  context.deathmatch = true
  context.password = "play"
  context.spectatorPassword = "watch"
  context.maxSpectators = 1
  context.banCheck = banned
  player = gplayertypes.createPlayer(1, context.registry)
  context.players = [player]

  rejected = gplayeruserinfo.ClientConnect(context, player, "\\name\\Bad\\ip\\10.0.0.9\\password\\play")
  assertEqual(rejected.accepted, false, "banned client rejected")
  assertContains(rejected.userInfo, "Banned.", "rejection userinfo")
  wrong = gplayeruserinfo.ClientConnect(context, player, "\\name\\Bad\\password\\no")
  assertEqual(wrong.accepted, false, "password rejected")
  accepted = gplayeruserinfo.ClientConnect(context, player, "\\name\\Ranger\\skin\\female/athena\\gender\\f\\password\\play\\fov\\200\\hand\\2")
  assertTrue(accepted.accepted, "normal connect")
  assertEqual(player.persistent.netName, "Ranger", "userinfo name")
  assertEqual(player.edict.client.playerState.fov, 160.0, "userinfo fov clamp")
  assertEqual(player.persistent.hand, 2, "userinfo hand")
  assertEqual(player.gameplay.inventory.counts[1], 1, "persistent blaster")

  spectator = gplayertypes.createPlayer(2, context.registry)
  context.players = [player, spectator]
  spectatorResult = gplayeruserinfo.ClientConnect(context, spectator, "\\name\\Observer\\spectator\\watch")
  assertTrue(spectatorResult.accepted, "spectator password")
  assertTrue(spectator.persistent.spectator, "spectator flag")
  return true
end function

function testSpawnSelectionAndPutClient()
  context = makeContext(4)
  addDefaultSpawns(context)
  player = gplayertypes.createPlayer(1, context.registry)
  other = gplayertypes.createPlayer(2, context.registry)
  other.edict.inUse = true
  other.health = 100
  other.edict.state.origin = qtypes.Vec3(0.0, 0.0, 0.0)
  context.players = [player, other]
  gplayeruserinfo.ClientConnect(context, player, "\\name\\Bitterman\\skin\\male/grunt\\fov\\100")

  context.spawnPoint = "secret"
  single = gplayerspawn.SelectSpawnPoint(context, player)
  assertEqual(single.origin[0], 64.0, "targeted single-player spawn")
  context.spawnPoint = ""
  context.deathmatch = true
  context.dmFlags = gameconstants.DF_SPAWN_FARTHEST
  farthest = gplayerspawn.SelectSpawnPoint(context, player)
  assertEqual(farthest.origin[0], 300.0, "farthest deathmatch spawn")
  context.dmFlags = 0
  random = gplayerspawn.SelectSpawnPoint(context, player)
  assertEqual(random.origin[0], 200.0, "random excludes two closest")

  context.deathmatch = false
  context.cooperative = true
  cooperative = gplayerspawn.SelectSpawnPoint(context, other)
  assertEqual(cooperative.origin[0], 16.0, "cooperative client-index spawn")

  context.cooperative = false
  selection = gplayerclient.PutClientInServer(context, player)
  assertEqual(player.health, 100, "spawn health")
  assertEqual(player.edict.solid, gameconstants.SOLID_BBOX, "spawn solid")
  assertEqual(player.edict.state.modelIndex, 255, "player model sentinel")
  assertEqual(player.edict.client.playerState.pmove.origin[2], 72, "spawn pmove origin")
  assertEqual(player.edict.state.origin.z, 10.0, "spawn entity origin offset")
  return true
end function

function testThinkRespawnAndSpectator()
  global weaponThinkCount
  context = makeContext(3)
  addDefaultSpawns(context)
  context.deathmatch = true
  context.weaponThink = weaponThink
  player = gplayertypes.createPlayer(1, context.registry)
  target = gplayertypes.createPlayer(2, context.registry)
  context.players = [player, target]
  gplayeruserinfo.ClientConnect(context, player, "\\name\\Ranger")
  gplayeruserinfo.ClientConnect(context, target, "\\name\\Target")
  gplayerclient.PutClientInServer(context, player)
  gplayerclient.PutClientInServer(context, target)
  before = player.edict.state.origin.x
  command = qtypes.UserCmd(100, gameconstants.BUTTON_ATTACK, [0, 0, 0], 200, 0, 0, 0, 64)
  result = gplayerclient.ClientThink(context, player, command)
  assertTrue(result.moved, "ClientThink invokes PMove")
  assertTrue(player.edict.state.origin.x > before, "PMove origin copied back")
  assertEqual(weaponThinkCount, 1, "latched attack weapon thunk")
  assertEqual(player.lightLevel, 64, "light level copied")

  player.deadFlag = 2
  player.respawnTime = 0.5
  context.time = 1.0
  player.latchedButtons = gameconstants.BUTTON_ATTACK
  respawned = gplayerclient.ClientBeginServerFrame(context, player)
  assertTrue(respawned.respawned, "attack respawn")
  assertEqual(player.edict.state.event, gameconstants.EV_PLAYER_TELEPORT, "respawn event")
  assertEqual(player.edict.client.playerState.pmove.time, 14, "teleport hold")

  gplayeruserinfo.ClientUserinfoChanged(context, player, "\\name\\Ranger\\spectator\\1")
  player.respawn.spectator = false
  player.respawnTime = 0.0
  context.time = 6.0
  changed = gplayerclient.ClientBeginServerFrame(context, player)
  assertTrue(changed.respawned, "spectator transition")
  assertEqual(player.moveType, 8, "spectator noclip")
  assertEqual(player.edict.solid, gameconstants.SOLID_NOT, "spectator non-solid")
  return true
end function

function testDeathScoreRulesAndHud()
  context = makeContext(2)
  addDefaultSpawns(context)
  context.deathmatch = true
  context.mapName = "q2dm1"
  context.mapList = "q2dm1 q2dm2 q2dm3"
  context.fragLimit = 1
  victim = gplayertypes.createPlayer(1, context.registry)
  attacker = gplayertypes.createPlayer(2, context.registry)
  context.players = [victim, attacker]
  gplayeruserinfo.ClientConnect(context, victim, "\\name\\Ranger\\gender\\f")
  gplayeruserinfo.ClientConnect(context, attacker, "\\name\\Bitterman")
  gplayerclient.PutClientInServer(context, victim)
  gplayerclient.PutClientInServer(context, attacker)
  victim.health = -5
  death = gplayerrules.player_die(context, victim, attacker, attacker, 105, [0.0, 0.0, 0.0], gpconstants.MOD_ROCKET)
  assertContains(death.message, "ate Bitterman's rocket", "weapon obituary")
  assertEqual(attacker.respawn.score, 1, "killer frag")
  assertEqual(victim.deadFlag, 2, "player dead flag")
  rule = gplayerrules.CheckDMRules(context)
  assertTrue(rule.ended, "fraglimit ends match")
  assertEqual(rule.nextMap, "q2dm2", "maplist advances")

  context.deathmatch = false
  context.cooperative = true
  coopObituary = gplayerrules.ClientObituary(context, victim, attacker, gpconstants.MOD_BLASTER)
  assertTrue(coopObituary.friendlyFire, "coop player damage is friendly fire")
  context.cooperative = false
  context.deathmatch = true

  context.intermissionTime = 0.0
  context.fragLimit = 0
  attacker.gameplay.ammoIndex = 12
  attacker.gameplay.inventory.counts[12] = 7
  attacker.gameplay.inventory.selectedItem = 2
  attacker.health = 88
  attacker.powerups.quadFrame = 35
  context.frameNumber = 15
  attacker.showInventory = true
  stats = gplayerhud.G_SetStats(context, attacker)
  assertEqual(stats[gameconstants.STAT_HEALTH], 88, "HUD health")
  assertEqual(stats[gameconstants.STAT_AMMO], 7, "HUD ammo")
  assertEqual(stats[gameconstants.STAT_TIMER], 2, "HUD timer")
  assertEqual(stats[gameconstants.STAT_FRAGS], 1, "HUD frags")
  assertEqual(stats[gameconstants.STAT_LAYOUTS], 2, "HUD inventory layout")

  attacker.velocity = [8.0, -4.0, 2.0]
  state = gplayerhud.ClientEndServerFrame(context, attacker)
  assertEqual(state.pmove.velocity[0], 64, "end frame velocity sync")
  assertEqual(state.pmove.origin[0], qtypes.zeroUserCmd().forwardMove + state.pmove.origin[0], "game/qcommon aliases coexist")
  base = btypes.zeroBaseEntity()
  ai = gaitypes.createClientTarget(9)
  gp = gptypes.createPlayer(10, gpregistry.inventorySlots(context.registry))
  assertEqual(base.spawnKind, "unspawned", "base alias coexistence")
  assertEqual(ai.className, "player", "AI alias coexistence")
  assertEqual(gp.edict.state.number, 10, "gameplay alias coexistence")

  frameContext = makeContext(1)
  addDefaultSpawns(frameContext)
  framed = gplayertypes.createPlayer(1, frameContext.registry)
  frameContext.players = [framed]
  frameContext.weaponThink = weaponThink
  gplayeruserinfo.ClientConnect(frameContext, framed, "\\name\\Frame")
  gplayerclient.PutClientInServer(frameContext, framed)
  gplayerframe.RunPlayerFrame(frameContext)
  assertEqual(frameContext.frameNumber, 1, "g_main player frame advances")
  assertEqual(framed.edict.client.playerState.stats[gameconstants.STAT_HEALTH], 100, "g_main ends client frame")
  return true
end function

function runTests()
  testConnectUserinfoAndSpectator()
  testSpawnSelectionAndPutClient()
  testThinkRespawnAndSpectator()
  testDeathScoreRulesAndHud()
  testRepeatedSpawnpointLifetime()
  print "MiniQuake2 gameplay player scenarios passed: 5"
end function

runTests()
