/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Golden/scenario tests for the managed p_view.c environment and view core. */
import miniquake2.game.constants as gameconstants
import miniquake2.game.gameplay.constants as gpconstants
import miniquake2.game.gameplay.registry as gpregistry
import miniquake2.game.player.client as gplayerclient
import miniquake2.game.player.constants as gplayerconstants
import miniquake2.game.player.hud as gplayerhud
import miniquake2.game.player.types as gplayertypes
import miniquake2.game.player.userinfo as gplayeruserinfo
import miniquake2.game.player.view as gplayerview
import miniquake2.qcommon.constants as qconstants
import miniquake2.qcommon.types as qtypes
import miniquake2.server.game_bridge as gbridge

testContents = 0

// Store view fixture data.
struct ViewFixture
  context
  player
  runtime
end struct

// Assert the equal test condition.
function assertEqual(actual, expected, name)
  if actual != expected then return error(9780, name + ": values differ") end if
  return true
end function

// Assert the true test condition.
function assertTrue(value, name)
  if value != true then return error(9781, name + ": expected true") end if
  return true
end function

// Assert the near test condition.
function assertNear(actual, expected, tolerance, name)
  difference = actual - expected
  if difference < 0.0 then difference = -difference end if
  if difference > tolerance then return error(9782, name + ": outside tolerance") end if
  return true
end function

// Report whether contains.
function contains(values, expected)
  for each value in values
    if value == expected then return true end if
  end for
  return false
end function

// Report whether empty trace.
function emptyTrace(start, mins, maxs, finish)
  plane = qtypes.Plane(qtypes.Vec3(0.0, 0.0, 0.0), 0.0, 0, 0)
  surface = qtypes.CollisionSurface("player-view/test", 0, 0)
  return qtypes.Trace(false, false, 1.0, qtypes.Vec3(finish.x, finish.y, finish.z), plane, surface, 0, void)
end function

// Return the point contents value.
function pointContents(point)
  global testContents
  return testContents
end function

// Return the fixed random value.
function fixedRandom(count)
  return 0
end function

// Return the fixture value.
function fixture()
  runtime = gbridge.createRuntime(2)
  imports = gbridge.makeImports(runtime)
  registry = gpregistry.defaultRegistry()
  context = gplayertypes.createContext(imports, registry, emptyTrace)
  context.pointContents = pointContents
  context.randomIndex = fixedRandom
  context.spawnSpots = [gplayertypes.spawnSpot("info_player_start", "", [0.0, 0.0, 0.0], [0.0, 0.0, 0.0])]
  player = gplayertypes.createPlayer(1, registry)
  context.players = [player]
  gplayeruserinfo.ClientConnect(context, player, "\\name\\ViewTester")
  gplayerclient.PutClientInServer(context, player)
  return ViewFixture(context, player, runtime)
end function

// Verify world effects.
function testWorldEffects()
  water = fixture()
  context = water.context
  player = water.player
  context.time = 2.0
  context.frameNumber = 20
  player.waterLevel = 3
  player.waterType = qconstants.CONTENTS_WATER
  player.view.airFinished = 0.0
  player.view.nextDrownTime = 0.0
  damage = gplayerview.P_WorldEffects(context, player)
  assertEqual(damage, 4, "first drowning damage")
  assertEqual(player.health, 96, "drowning health")
  assertEqual(player.view.drownDamage, 4, "drowning escalation")
  assertTrue((player.flags & gplayerconstants.FL_INWATER) != 0, "water entry flag")
  assertTrue(contains(water.runtime.soundNames, "player/watr_un.wav"), "submerge sound")
  assertTrue(contains(water.runtime.soundNames, "*gurp2.wav"), "deterministic drowning sound")
  context.time = 2.5
  assertEqual(gplayerview.P_WorldEffects(context, player), 0, "drowning one-second debounce")
  player.waterLevel = 0
  gplayerview.P_WorldEffects(context, player)
  assertEqual(player.view.drownDamage, 2, "air resets drown damage")
  assertTrue((player.flags & gplayerconstants.FL_INWATER) == 0, "water exit clears flag")

  lava = fixture()
  lava.context.time = 1.0
  lava.context.frameNumber = 10
  lava.player.waterLevel = 2
  lava.player.waterType = qconstants.CONTENTS_LAVA
  lava.player.powerups.enviroFrame = 50
  assertEqual(gplayerview.P_WorldEffects(lava.context, lava.player), 2, "enviro suit lava reduction")
  assertEqual(lava.player.health, 98, "reduced lava health")
  lava.player.waterType = qconstants.CONTENTS_SLIME
  assertEqual(gplayerview.P_WorldEffects(lava.context, lava.player), 0, "enviro suit blocks slime")

  lava.player.moveType = gplayerconstants.MOVETYPE_NOCLIP
  lava.context.time = 7.0
  gplayerview.P_WorldEffects(lava.context, lava.player)
  assertEqual(lava.player.view.airFinished, 19.0, "noclip receives air")
  return true
end function

// Verify falling damage.
function testFallingDamage()
  falling = fixture()
  context = falling.context
  player = falling.player
  context.time = 3.0
  player.groundEntity = "world"
  player.view.oldVelocity = [0.0, 0.0, -600.0]
  player.velocity = [0.0, 0.0, 0.0]
  damage = gplayerview.P_FallingDamage(context, player)
  assertEqual(damage, 3, "fall damage formula")
  assertEqual(player.health, 97, "fall health")
  assertEqual(player.edict.state.event, gameconstants.EV_FALL, "medium fall event")
  assertEqual(player.view.fallValue, 18.0, "fall kick value")
  assertEqual(player.view.fallTime, 3.3, "fall kick time")

  protected = fixture()
  protected.context.deathmatch = true
  protected.context.dmFlags = gameconstants.DF_NO_FALLING
  protected.player.groundEntity = "world"
  protected.player.view.oldVelocity = [0.0, 0.0, -800.0]
  protected.player.velocity = [0.0, 0.0, 0.0]
  assertEqual(gplayerview.P_FallingDamage(protected.context, protected.player), 0, "DF_NO_FALLING")
  assertEqual(protected.player.health, 100, "no-falling health")
  assertEqual(protected.player.edict.state.event, gameconstants.EV_FALLFAR, "no-falling retains landing event")

  submerged = fixture()
  submerged.player.groundEntity = "world"
  submerged.player.waterLevel = 3
  submerged.player.view.oldVelocity = [0.0, 0.0, -900.0]
  assertEqual(gplayerview.P_FallingDamage(submerged.context, submerged.player), 0, "underwater fall ignored")
  return true
end function

// Verify damage feedback.
function testDamageFeedback()
  feedback = fixture()
  context = feedback.context
  player = feedback.player
  context.time = 1.0
  context.frameNumber = 10
  player.health = 80
  gplayerview.RecordDamage(player, 20, 10, 5, 30, qtypes.Vec3(20.0, 10.0, 10.0))
  forward = qtypes.Vec3(1.0, 0.0, 0.0)
  right = qtypes.Vec3(0.0, -1.0, 0.0)
  assertTrue(gplayerview.P_DamageFeedback(context, player, forward, right), "damage feedback applied")
  assertEqual(player.edict.client.playerState.stats[gameconstants.STAT_FLASHES], 3, "damage HUD flashes")
  assertNear(player.view.damageAlpha, 0.35, 0.00001, "damage alpha")
  assertNear(player.view.damageBlend[0], 30.0 / 35.0, 0.00001, "damage blend red")
  assertNear(player.view.damageBlend[1], 15.0 / 35.0, 0.00001, "damage blend green")
  assertNear(player.view.damageBlend[2], 10.0 / 35.0, 0.00001, "damage blend blue")
  assertTrue(player.view.damagePitch < 0.0, "forward damage pitch kick")
  assertEqual(player.view.animPriority, gplayerconstants.ANIM_PAIN, "pain animation priority")
  assertEqual(player.edict.state.frame, gplayerconstants.FRAME_PAIN2_FIRST - 1, "deterministic pain sequence")
  assertEqual(player.view.damageBlood, 0, "damage totals cleared")
  assertTrue(contains(feedback.runtime.soundNames, "*pain100_1.wav"), "pain sound")
  return true
end function

// Verify offsets blend effects animation and integration.
function testOffsetsBlendEffectsAnimationAndIntegration()
  global testContents
  view = fixture()
  context = view.context
  player = view.player
  context.time = 1.0
  context.frameNumber = 10
  player.groundEntity = "world"
  player.velocity = [240.0, 0.0, 0.0]
  player.view.oldVelocity = [240.0, 0.0, 0.0]
  player.edict.client.playerState.viewAngles = qtypes.Vec3(0.0, 0.0, 0.0)
  player.view.oldViewAngles = qtypes.Vec3(0.0, 10.0, 0.0)
  context.viewSettings.gunX = 1.0
  context.viewSettings.gunY = 2.0
  context.viewSettings.gunZ = 3.0
  assertNear(gplayerview.UpdateBob(player), 240.0, 0.00001, "xy speed")
  assertEqual(player.view.bobMove, 0.25, "running bob rate")
  basis = miniquake2.physics.vector.angleVectors(player.edict.client.playerState.viewAngles)
  offset = gplayerview.SV_CalcViewOffset(context, player, basis[0], basis[1])
  assertTrue(offset.z > 22.0 and offset.z <= 28.0, "bounded bob view height")
  gun = gplayerview.SV_CalcGunOffset(context, player, basis[0], basis[1], basis[2])
  assertNear(gun.x, 2.0, 0.00001, "gun forward offset")
  assertNear(gun.y, -1.0, 0.00001, "gun right offset")
  assertNear(gun.z, -3.0, 0.00001, "gun vertical offset")
  assertTrue(player.edict.client.playerState.gunAngles.z > 0.0, "gun yaw-delta roll")

  testContents = qconstants.CONTENTS_WATER
  player.powerups.quadFrame = 50
  player.view.damageAlpha = 0.2
  player.view.damageBlend = [1.0, 0.0, 0.0]
  player.view.bonusAlpha = 0.1
  blend = gplayerview.SV_CalcBlend(context, player)
  assertTrue(blend[3] > 0.5, "stacked water/powerup/damage/bonus alpha")
  assertTrue((player.edict.client.playerState.rdFlags & gameconstants.RDF_UNDERWATER) != 0, "underwater render flag")
  assertEqual(player.view.damageAlpha, 0.14, "damage blend decay")
  assertEqual(player.view.bonusAlpha, 0.0, "bonus blend decay")
  player.flags = player.flags | gpconstants.FL_GODMODE
  effects = gplayerview.G_SetClientEffects(context, player)
  assertTrue((effects & gameconstants.EF_QUAD) != 0, "quad effect")
  assertTrue((effects & gameconstants.EF_COLOR_SHELL) != 0, "godmode shell")

  bfg = miniquake2.game.gameplay.item_rules.findByPickupName(context.registry, "BFG10K")
  player.gameplay.currentWeapon = bfg
  bfgSound = gplayerview.G_SetClientSound(context, player)
  assertTrue(bfgSound > 0, "BFG loop sound")
  player.gameplay.currentWeapon = miniquake2.game.gameplay.item_rules.findByPickupName(context.registry, "Blaster")
  context.helpChanged = 2
  context.frameNumber = 64
  player.persistent.gameHelpChanged = 1
  player.persistent.helpChanged = 0
  gplayerview.G_SetClientSound(context, player)
  assertEqual(player.persistent.gameHelpChanged, 2,
    "player help generation acknowledgement")
  assertEqual(player.persistent.helpChanged, 2,
    "player help reminder cadence")
  assertTrue(contains(view.runtime.soundNames, "misc/pc_up.wav"),
    "player-specific help reminder sound")
  player.view.xySpeed = 120.0
  player.view.animPriority = gplayerconstants.ANIM_BASIC
  player.view.animRun = false
  assertEqual(gplayerview.G_SetClientFrame(player), gplayerconstants.FRAME_RUN_FIRST, "run animation")
  player.edict.client.playerState.pmove.flags = player.edict.client.playerState.pmove.flags | gameconstants.PMF_DUCKED
  assertEqual(gplayerview.G_SetClientFrame(player), gplayerconstants.FRAME_CROUCH_WALK_FIRST, "crouch walk animation")
  player.edict.client.playerState.pmove.flags = player.edict.client.playerState.pmove.flags & ~gameconstants.PMF_DUCKED
  player.groundEntity = void
  player.view.animPriority = gplayerconstants.ANIM_BASIC
  assertEqual(gplayerview.G_SetClientFrame(player), gplayerconstants.FRAME_JUMP_FIRST, "jump animation")

  player.groundEntity = "world"
  player.velocity = [120.0, 0.0, 0.0]
  player.view.oldVelocity = [120.0, 0.0, 0.0]
  player.view.kickOrigin = qtypes.Vec3(1.0, 2.0, 3.0)
  gplayerhud.ClientEndServerFrame(context, player)
  assertEqual(player.view.oldVelocity[0], 120.0, "end frame old velocity")
  assertEqual(player.view.kickOrigin.x, 0.0, "end frame clears weapon kick")
  assertTrue(player.edict.client.playerState.viewOffset.z > 0.0, "end frame view offset")
  return true
end function

// Run view tests.
function runViewTests()
  testWorldEffects()
  testFallingDamage()
  testDamageFeedback()
  testOffsetsBlendEffectsAnimationAndIntegration()
  print "MiniQuake2 gameplay player view scenarios passed: 4"
end function

runViewTests()
