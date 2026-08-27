/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Live-edict TossClientWeapon, Quad drop and cooked-grenade death tests. */
import miniquake2.game.null_game as ddgame
import miniquake2.game.integration.baseq2 as ddintegration
import miniquake2.game.gameplay.item_rules as dditems
import miniquake2.game.gameplay.constants as dditemconstants
import miniquake2.game.player.rules as ddrules
import miniquake2.game.weapons.types as ddweapontypes
import miniquake2.game.constants as ddconstants
import miniquake2.server.game_bridge as ddbridge

// Assert the equal test condition.
function assertEqual(actual, expected, name)
  if actual != expected then return error(9660, name + ": values differ") end if
  return true
end function

// Assert the true test condition.
function assertTrue(value, name)
  if value != true then return error(9661, name + ": expected true") end if
  return true
end function

// Install state.
function install()
  fixture = "{ \"classname\" \"worldspawn\" }\n" +
    "{ \"classname\" \"info_player_start\" \"origin\" \"0 0 0\" }"
  server = ddbridge.createRuntime(4)
  api = ddgame.GetGameApi(ddbridge.makeImports(server))
  server.game = api
  api.init()
  api.spawnEntities("base1", fixture, "")
  client = ddgame.edictAt(1)
  assertTrue(api.clientConnect(client,
    "\\name\\Ranger\\skin\\male/grunt"), "connect")
  assertTrue(api.clientBegin(client), "begin")
  return [server, api, client]
end function

// Find runtime item.
function findRuntimeItem(runtime, className)
  for each itemEntity in runtime.items
    if itemEntity.item.className == className then return itemEntity end if
  end for
  return void
end function

// Report whether has weapon event.
function hasWeaponEvent(runtime, kind)
  for each event in runtime.weaponContext.events
    if event[1] == kind then return true end if
  end for
  return false
end function

// Verify weapon and quad death drops.
function testWeaponAndQuadDeathDrops()
  session = install()
  api = session[1]
  context = ddgame.playerContext()
  runtime = ddgame.baseRuntime()
  context.deathmatch = true
  context.dmFlags = ddconstants.DF_QUAD_DROP
  context.time = 1.0
  context.frameNumber = 10
  player = context.players[0]
  shotgun = dditems.findByClassName(context.registry, "weapon_shotgun")
  shells = dditems.findByPickupName(context.registry, "Shells")
  player.gameplay.currentWeapon = shotgun
  player.gameplay.ammoIndex = shells.index
  player.gameplay.inventory.counts[shotgun.index] = 1
  player.gameplay.inventory.counts[shells.index] = 5
  player.powerups.quadFrame = 60
  player.health = -10

  ddrules.player_die(context, player, void, void, 110,
    [0.0, 0.0, 0.0], dditemconstants.MOD_ROCKET)
  assertEqual(len(runtime.items), 2, "weapon and Quad create two item records")
  weaponDrop = findRuntimeItem(runtime, "weapon_shotgun")
  quadDrop = findRuntimeItem(runtime, "item_quad")
  assertTrue(weaponDrop is not void, "current weapon dropped")
  assertEqual(weaponDrop.spawnFlags,
    dditemconstants.DROPPED_PLAYER_ITEM,
    "death weapon uses DROPPED_PLAYER_ITEM exactly")
  assertTrue(weaponDrop.owner is not void and
      weaponDrop.nextThink == 2.0,
    "death weapon retains one-second owner immunity")
  assertTrue(weaponDrop.edict.inUse and
      api.edicts[weaponDrop.edict.state.number].inUse,
    "death weapon owns live export edict")
  assertTrue(weaponDrop.edict.state.modelIndex > 0,
    "death weapon owns world model")

  assertTrue(quadDrop is not void, "Quad dropped")
  assertEqual(quadDrop.spawnFlags, dditemconstants.DROPPED_ITEM |
    dditemconstants.DROPPED_PLAYER_ITEM,
    "Quad retains Drop_Item and player-drop flags")
  assertTrue(quadDrop.owner is void and quadDrop.edict.owner is void,
    "Quad is immediately touchable")
  assertEqual(quadDrop.nextThink, 6.0,
    "Quad expiry preserves remaining powerup duration")
  assertEqual(quadDrop.respawnAt, 6.0,
    "Quad real item expiry matches think deadline")
  assertTrue(quadDrop.velocity.y > 0.0 and weaponDrop.velocity.y < 0.0,
    "weapon and Quad use stock opposite yaw spread")
  api.shutdown()
  return true
end function

// Report whether test cooked grenade on death.
function testCookedGrenadeOnDeath()
  session = install()
  api = session[1]
  context = ddgame.playerContext()
  runtime = ddgame.baseRuntime()
  context.time = 3.0
  runtime.weaponContext.time = context.time
  player = context.players[0]
  grenades = dditems.findByClassName(context.registry, "ammo_grenades")
  player.gameplay.currentWeapon = grenades
  player.gameplay.ammoIndex = grenades.index
  player.gameplay.inventory.counts[grenades.index] = 2
  owner = ddintegration.playerWeaponTarget(player, context.registry)
  state = ddweapontypes.createHandGrenadeState(owner, 2)
  state.grenadeTime = context.time + 2.0
  state.gunFrame = 11
  player.handGrenadeState = state
  player.health = -10

  ddrules.player_die(context, player, void, void, 110,
    [0.0, 0.0, 0.0], dditemconstants.MOD_ROCKET)
  assertTrue(player.handGrenadeState is void,
    "death consumes cooked hand-grenade state")
  assertEqual(len(runtime.weaponContext.projectiles), 1,
    "death grenade uses real projectile runtime")
  projectile = runtime.weaponContext.projectiles[0]
  assertEqual(projectile.className, "hgrenade", "death projectile class")
  assertEqual(projectile.damage, 125, "death grenade is not Quad scaled")
  assertEqual(projectile.spawnFlags, 1,
    "death grenade is thrown, not marked held")
  assertTrue(not projectile.inUse,
    "zero-timer ChangeWeapon grenade detonates immediately")
  assertTrue(hasWeaponEvent(runtime, "free"),
    "death grenade completes projectile free lifecycle")
  api.shutdown()
  return true
end function

print "MiniQuake2 player death-drop tests starting: 2"
testWeaponAndQuadDeathDrops()
testCookedGrenadeOnDeath()
print "MiniQuake2 player death-drop tests passed: 2"
