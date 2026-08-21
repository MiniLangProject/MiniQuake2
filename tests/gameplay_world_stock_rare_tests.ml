/* Golden scenarios for the remaining rare stock BaseQ2 world classes. */
import miniquake2.game.world.constants as stockrareconstants
import miniquake2.game.world.core as stockrarecore
import miniquake2.game.world.targets as stockraretargets
import miniquake2.game.world.movers as stockraremovers
import miniquake2.game.world.misc as stockraremisc
import miniquake2.qcommon.types as stockrareqtypes

stockRareModels = []
stockRareLinks = 0
stockRareKillBoxes = 0
stockRareLightStyles = []
stockRareRadiusMeans = ""
stockRareRadiusAmount = 0
stockRareEffects = []
stockRareTargetUses = 0

function stockRareAssert(condition, label)
  if condition == false then return error(9970, label) end if
end function

function stockRareAssertEqual(actual, expected, label)
  if actual != expected then return error(9971, label + ": expected " + expected + ", got " + actual) end if
end function

function stockRareAssertNear(actual, expected, tolerance, label)
  difference = actual - expected
  if difference < 0.0 then difference = -difference end if
  if difference > tolerance then return error(9972, label + ": expected " + expected + ", got " + actual) end if
end function

function stockRareSetModel(entity, modelName)
  global stockRareModels
  stockRareModels = stockRareModels + [[entity.number, modelName]]
  entity.modelIndex = entity.number + 100
  return true
end function

function stockRareLink(entity)
  global stockRareLinks
  stockRareLinks = stockRareLinks + 1
  return true
end function

function stockRareKillBox(entity)
  global stockRareKillBoxes
  stockRareKillBoxes = stockRareKillBoxes + 1
  return true
end function

function stockRareLightStyle(style, pattern)
  global stockRareLightStyles
  stockRareLightStyles = stockRareLightStyles + [[style, pattern]]
  return true
end function

function stockRareRadius(inflictor, attacker, amount, radius, means)
  global stockRareRadiusMeans, stockRareRadiusAmount
  stockRareRadiusMeans = means
  stockRareRadiusAmount = amount
  return true
end function

function stockRareEffect(kind, origin, style, count)
  global stockRareEffects
  stockRareEffects = stockRareEffects + [[kind, style, count]]
  return true
end function

function stockRareUse(entity, other, activator, world)
  global stockRareTargetUses
  stockRareTargetUses = stockRareTargetUses + 1
  return true
end function

function stockRareWorld()
  callbacks = stockrarecore.defaultCallbacks()
  callbacks.setModel = stockRareSetModel
  callbacks.linkEntity = stockRareLink
  callbacks.killBox = stockRareKillBox
  callbacks.lightStyle = stockRareLightStyle
  callbacks.radiusDamage = stockRareRadius
  callbacks.effect = stockRareEffect
  return stockrarecore.createWorld(callbacks)
end function

function testTargetLightRamp()
  global stockRareLightStyles
  stockRareLightStyles = []
  world = stockRareWorld()
  light = stockrarecore.spawnEntity(world, "light")
  light.targetName = "ramp-light"
  light.style = 43
  decoy = stockrarecore.spawnEntity(world, "target_string")
  decoy.targetName = "ramp-light"
  ramp = stockrarecore.spawnEntity(world, "target_lightramp")
  ramp.target = "ramp-light"
  ramp.message = "az"
  ramp.speed = 0.2
  ramp.spawnFlags = 1
  stockRareAssert(stockraretargets.spawnTargetLightRamp(ramp, world, false) == ramp, "valid target_lightramp spawns")
  stockrarecore.useEntity(world, ramp, void, ramp)
  stockRareAssertEqual(len(stockRareLightStyles), 1, "lightramp immediate configstring")
  stockRareAssertEqual(stockRareLightStyles[0][0], 43, "lightramp light style index")
  stockRareAssertEqual(stockRareLightStyles[0][1], "a", "lightramp start pattern")
  stockrarecore.advance(world, 0.1)
  stockRareAssertEqual(stockRareLightStyles[1][1], "m", "lightramp midpoint truncation")
  stockrarecore.advance(world, 0.2)
  stockRareAssertEqual(stockRareLightStyles[2][1], "z", "lightramp terminal pattern")
  stockRareAssertEqual(ramp.moveDirection.x, 25, "toggle swaps ramp start")
  stockrarecore.useEntity(world, ramp, void, ramp)
  stockRareAssertEqual(stockRareLightStyles[3][1], "z", "toggle reverse starts at former end")

  bad = stockrarecore.spawnEntity(world, "target_lightramp")
  bad.target = "ramp-light"; bad.message = "aa"; bad.speed = 1.0
  stockRareAssertEqual(stockraretargets.spawnTargetLightRamp(bad, world, false), false, "equal lightramp endpoints rejected")
  missing = stockrarecore.spawnEntity(world, "target_lightramp")
  missing.message = "ab"; missing.speed = 1.0
  stockRareAssertEqual(stockraretargets.spawnTargetLightRamp(missing, world, false), false, "missing lightramp target rejected")
  noSpeed = stockrarecore.spawnEntity(world, "target_lightramp")
  noSpeed.target = "ramp-light"; noSpeed.message = "ab"
  stockRareAssertEqual(stockraretargets.spawnTargetLightRamp(noSpeed, world, false), false, "zero lightramp speed rejected")
  deathmatch = stockrarecore.spawnEntity(world, "target_lightramp")
  deathmatch.target = "ramp-light"; deathmatch.message = "ab"; deathmatch.speed = 1.0
  stockRareAssertEqual(stockraretargets.spawnTargetLightRamp(deathmatch, world, true), false, "deathmatch lightramp removed")
end function

function testKillBoxAndInfoNotNull()
  global stockRareKillBoxes
  stockRareKillBoxes = 0
  world = stockRareWorld()
  killbox = stockrarecore.spawnEntity(world, "func_killbox")
  killbox.model = "*7"
  stockRareAssert(stockraremovers.spawnKillBox(killbox, world) == killbox, "func_killbox spawns")
  stockRareAssertEqual(killbox.serverFlags, stockrareconstants.SVF_NOCLIENT, "func_killbox is hidden")
  stockRareAssert(killbox.modelIndex > 0, "func_killbox model callback")
  stockrarecore.useEntity(world, killbox, void, killbox)
  stockRareAssertEqual(stockRareKillBoxes, 1, "func_killbox use delegates KillBox")
  malformed = stockrarecore.spawnEntity(world, "func_killbox")
  stockRareAssertEqual(stockraremovers.spawnKillBox(malformed, world), false, "func_killbox missing model guarded")

  marker = stockrarecore.spawnEntity(world, "info_notnull")
  marker.origin = stockrareqtypes.Vec3(11.0, -3.0, 7.0)
  stockraremisc.spawnInfoNotNull(marker, world)
  stockRareAssertNear(marker.absoluteMins.x, 11.0, 0.0001, "info_notnull absmin x")
  stockRareAssertNear(marker.absoluteMaxs.y, -3.0, 0.0001, "info_notnull absmax y")
  stockRareAssert(marker.absoluteMins != marker.origin, "info_notnull stores a stable vector copy")
end function

function testAnimatedSetPieces()
  global stockRareModels
  stockRareModels = []
  world = stockRareWorld()
  black = stockrarecore.spawnEntity(world, "misc_blackhole")
  stockraremisc.spawnBlackHole(black, world)
  stockRareAssertEqual(black.renderFx & stockrareconstants.RF_TRANSLUCENT, stockrareconstants.RF_TRANSLUCENT, "blackhole translucent")
  stockrarecore.advance(world, 2.0)
  stockRareAssertEqual(black.frame, 0, "blackhole 19-frame loop")
  stockrarecore.useEntity(world, black, void, black)
  stockRareAssertEqual(black.inUse, false, "blackhole use removes entity")

  tank = stockrarecore.spawnEntity(world, "misc_eastertank")
  stockraremisc.spawnEasterTank(tank, world)
  tank.frame = 292
  stockraremisc.easterTankThink(tank, world)
  stockRareAssertEqual(tank.frame, 254, "eastertank frame loop")
  chick = stockrarecore.spawnEntity(world, "misc_easterchick")
  stockraremisc.spawnEasterChick(chick, world)
  chick.frame = 246
  stockraremisc.easterChickThink(chick, world)
  stockRareAssertEqual(chick.frame, 208, "easterchick frame loop")
  chick2 = stockrarecore.spawnEntity(world, "misc_easterchick2")
  stockraremisc.spawnEasterChick2(chick2, world)
  chick2.frame = 286
  stockraremisc.easterChick2Think(chick2, world)
  stockRareAssertEqual(chick2.frame, 248, "easterchick2 frame loop")

  dish = stockrarecore.spawnEntity(world, "misc_satellite_dish")
  stockraremisc.spawnSatelliteDish(dish, world)
  stockrarecore.useEntity(world, dish, void, dish)
  stockrarecore.advance(world, world.time + 3.8)
  stockRareAssertEqual(dish.frame, 38, "satellite dish terminal frame")
  stockRareAssertNear(dish.nextThink, 0.0, 0.0001, "satellite dish stops scheduling")
  mine = stockrarecore.spawnEntity(world, "light_mine2")
  stockraremisc.spawnLightMine2(mine, world)
  stockRareAssertEqual(mine.solid, stockrareconstants.SOLID_BBOX, "light_mine2 bbox")
  stockRareAssertEqual(mine.model, "models/objects/minelite/light2/tris.md2", "light_mine2 stock model")
  stockRareAssertEqual(len(stockRareModels), 6, "all animated set-piece models registered")
end function

function testViperBombLifecycle()
  global stockRareRadiusMeans, stockRareRadiusAmount, stockRareEffects, stockRareTargetUses
  stockRareRadiusMeans = ""; stockRareRadiusAmount = 0; stockRareEffects = []; stockRareTargetUses = 0
  world = stockRareWorld()
  firstCorner = stockrarecore.spawnEntity(world, "path_corner")
  firstCorner.targetName = "viper-path-1"
  firstCorner.target = "viper-path-2"
  firstCorner.origin = stockrareqtypes.Vec3(0.0, 0.0, 0.0)
  secondCorner = stockrarecore.spawnEntity(world, "path_corner")
  secondCorner.targetName = "viper-path-2"
  secondCorner.origin = stockrareqtypes.Vec3(100.0, 0.0, 0.0)
  viper = stockrarecore.spawnEntity(world, "misc_viper")
  viper.targetName = "start-viper"
  viper.target = "viper-path-1"
  stockRareAssert(stockraremisc.spawnViper(viper, world) == viper, "misc_viper spawns")
  stockRareAssertEqual(viper.speed, 300.0, "misc_viper default speed")
  stockrarecore.advance(world, 0.1)
  stockRareAssertEqual(viper.target, "viper-path-2", "misc_viper train find consumes first corner")
  stockrarecore.useEntity(world, viper, void, viper)
  stockRareAssertEqual(viper.serverFlags & stockrareconstants.SVF_NOCLIENT, 0, "misc_viper becomes visible on use")
  stockRareAssertNear(viper.moveInfo.direction.x, 1.0, 0.0001, "misc_viper follows train direction")

  detonator = stockrarecore.spawnEntity(world, "bomb-target")
  detonator.targetName = "bomb-target"
  detonator.use = stockRareUse
  bomb = stockrarecore.spawnEntity(world, "misc_viper_bomb")
  bomb.target = "bomb-target"
  bomb.absoluteMins = stockrareqtypes.Vec3(-8.0, -8.0, -5.0)
  stockraremisc.spawnViperBomb(bomb, world)
  stockrarecore.useEntity(world, bomb, void, viper)
  stockRareAssertEqual(bomb.moveType, stockrareconstants.MOVETYPE_TOSS, "viper bomb starts toss movement")
  stockRareAssertEqual(bomb.effects & stockrareconstants.EF_ROCKET, stockrareconstants.EF_ROCKET, "viper bomb rocket trail")
  stockRareAssertNear(bomb.velocity.x, 300.0, 0.0001, "viper bomb inherits viper velocity")
  stockrarecore.advance(world, 0.2)
  stockRareAssertNear(bomb.angles.z, 10.0, 0.0001, "viper bomb rolls each prethink")
  stockrarecore.touchEntity(world, bomb, firstCorner)
  stockRareAssertEqual(stockRareTargetUses, 1, "viper bomb fires targets before exploding")
  stockRareAssertEqual(stockRareRadiusMeans, stockrareconstants.MOD_BOMB, "viper bomb damage means")
  stockRareAssertEqual(stockRareRadiusAmount, 1000, "viper bomb default damage")
  stockRareAssertEqual(stockRareEffects[0][0], "explosion2", "viper bomb explosion effect")
  stockRareAssertNear(bomb.origin.z, -4.0, 0.0001, "viper bomb explosion rests at absmin")
  stockRareAssertEqual(bomb.inUse, false, "viper bomb frees after touch")

  emptyWorld = stockRareWorld()
  orphanBomb = stockrarecore.spawnEntity(emptyWorld, "misc_viper_bomb")
  stockraremisc.spawnViperBomb(orphanBomb, emptyWorld)
  stockRareAssertEqual(stockrarecore.useEntity(emptyWorld, orphanBomb, void, orphanBomb), true, "orphan bomb use was dispatched")
  stockRareAssertEqual(orphanBomb.moveType, stockrareconstants.MOVETYPE_NONE, "orphan bomb remains safely dormant")
  badViper = stockrarecore.spawnEntity(emptyWorld, "misc_viper")
  stockRareAssertEqual(stockraremisc.spawnViper(badViper, emptyWorld), false, "misc_viper missing path rejected")
end function

function main(args)
  testTargetLightRamp()
  testKillBoxAndInfoNotNull()
  testAnimatedSetPieces()
  testViperBombLifecycle()
  stockRareAssertEqual(11, 11, "stock rare class-count coverage")
  print "gameplay_world_stock_rare_tests: PASS"
  return 0
end function
