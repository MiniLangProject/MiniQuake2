/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Mixed-domain G_RunFrame global numeric-edict ordering regression. */
import miniquake2.server.game_bridge as schedbridge
import miniquake2.game.null_game as schedgame
import miniquake2.game.integration.baseq2 as schedintegration
import miniquake2.game.world.constants as schedworldconstants
import miniquake2.game.weapons.projectiles as schedprojectiles
import miniquake2.game.weapons.types as schedweapontypes
import miniquake2.qcommon.types as schedtypes

schedulerOrder = []
schedulerKinds = []

// Assert a numeric scheduler invariant.
function schedulerAssert(value, message)
  if not value then return error(9895, message) end if
  return true
end function

// Record one authoritative non-client domain dispatch.
function schedulerProbe(number, kind)
  global schedulerOrder, schedulerKinds
  schedulerOrder = schedulerOrder + [number]
  schedulerKinds = schedulerKinds + [kind]
  return true
end function

// Report whether the frame visited a requested domain.
function schedulerSawKind(kind)
  for each candidate in schedulerKinds
    if candidate == kind then return true end if
  end for
  return false
end function

server = schedbridge.createRuntime(1)
api = schedgame.GetGameApi(schedbridge.makeImports(server))
server.game = api
api.init()
fixture = "{\"classname\" \"worldspawn\"}" +
  "{\"classname\" \"info_player_start\" \"origin\" \"0 0 0\"}" +
  "{\"classname\" \"target_delay\" \"targetname\" \"ordered-think\"}" +
  "{\"classname\" \"monster_soldier\" \"origin\" \"96 0 24\"}" +
  "{\"classname\" \"func_door\" \"model\" \"*1\" \"targetname\" \"ordered-door\"}" +
  "{\"classname\" \"ammo_shells\" \"origin\" \"160 0 24\"}" +
  "{\"classname\" \"misc_explobox\" \"origin\" \"224 0 24\"}"
api.spawnEntities("numeric-order", fixture, "")
runtime = schedgame.baseRuntime()
runtime.frameDispatchProbe = schedulerProbe
toss = schedintegration.findWorldByClass(runtime, "misc_explobox")
toss.moveType = schedworldconstants.MOVETYPE_TOSS
toss.velocity = schedtypes.Vec3(0.0, 0.0, 0.0)
owner = schedweapontypes.createTarget(1, 100)
projectile = schedprojectiles.fireRocket(runtime.weaponContext, owner,
  schedtypes.Vec3(300.0, 0.0, 24.0), schedtypes.Vec3(1.0, 0.0, 0.0),
  100, 650.0, 120.0, 110)
schedulerAssert(projectile.engineNumber >= 0,
  "projectile fixture did not acquire a global edict slot")
api.runFrame()
schedulerAssert(len(schedulerOrder) >= 5,
  "numeric scheduler did not visit the mixed-domain fixture")
index = 1
while index < len(schedulerOrder)
  schedulerAssert(schedulerOrder[index] > schedulerOrder[index - 1],
    "non-client domains were not dispatched in strict global edict order")
  index = index + 1
end while
schedulerAssert(schedulerSawKind("world-think"), "world think domain missing")
schedulerAssert(schedulerSawKind("monster"), "monster domain missing")
schedulerAssert(schedulerSawKind("pusher"), "pusher domain missing")
schedulerAssert(schedulerSawKind("item"), "item domain missing")
schedulerAssert(schedulerSawKind("world-toss"), "world toss domain missing")
schedulerAssert(schedulerSawKind("projectile"), "projectile domain missing")
api.shutdown()
print "gameplay_numeric_edict_scheduler_tests: PASS"
