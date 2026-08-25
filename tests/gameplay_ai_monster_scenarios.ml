/* Native deterministic scenarios for the managed baseq2 AI/monster core. */
import miniquake2.game.ai.archetypes as gaiarchetypes
import miniquake2.game.ai.constants as gaiconstants
import miniquake2.game.ai.core as gaicore
import miniquake2.game.ai.monster as gaimonster
import miniquake2.game.ai.trail as gaitrail
import miniquake2.game.ai.types as gaitypes
import miniquake2.game.base.types as btypes
import miniquake2.game.constants as gameconstants
import miniquake2.game.gameplay.types as gptypes
import miniquake2.qcommon.types as gaiqtypes
import std.string as gaistring

walkDistances = []
frameThinkCount = 0
moveEndCount = 0
usedTargetCount = 0
droppedItemCount = 0
visibilityEnabled = true
clearShotEnabled = true
lostTrailMarker = void

function assertEqual(actual, expected, name)
  if actual != expected then return error(9700, name + ": values differ") end if
  return true
end function

function assertTrue(value, name)
  if value != true then return error(9701, name + ": expected true") end if
  return true
end function

function assertErrorContains(value, fragment, name)
  if value is not error then return error(9702, name + ": expected error") end if
  if gaistring.contains(value.message, fragment) != true then return error(9703, name + ": unexpected message " + value.message) end if
  return true
end function

function recordWalk(actor, yaw, distance)
  global walkDistances
  walkDistances = walkDistances + [distance]
  return true
end function

function recordFrameThink(actor, context)
  global frameThinkCount
  frameThinkCount = frameThinkCount + 1
  return true
end function

function recordMoveEnd(actor, context)
  global moveEndCount
  moveEndCount = moveEndCount + 1
  actor.activity = "move-ended"
  return true
end function

function testVisible(actor, other)
  global visibilityEnabled
  return visibilityEnabled
end function

function testClearShot(actor, other)
  global clearShotEnabled
  return clearShotEnabled
end function

function alwaysPHS(first, second)
  return true
end function

function areasConnected(first, second)
  return true
end function

function pickLostTrailFirst(actor)
  global lostTrailMarker
  return lostTrailMarker
end function

function pickLostTrailNext(actor)
  global lostTrailMarker
  return lostTrailMarker
end function

function courseCorrectionTrace(start, mins, maxs, finish, actor, mask)
  fraction = 0.25
  if finish.y < -0.1 then fraction = 0.9
  else if finish.y > 0.1 then fraction = 0.2
  end if
  plane = gaiqtypes.Plane(gaiqtypes.Vec3(1.0, 0.0, 0.0), 0.0, 0, 0)
  surface = gaiqtypes.CollisionSurface("course", 0, 0)
  endPosition = gaiqtypes.Vec3(
    start.x + (finish.x - start.x) * fraction,
    start.y + (finish.y - start.y) * fraction,
    start.z + (finish.z - start.z) * fraction)
  return gaiqtypes.Trace(false, false, fraction, endPosition, plane, surface,
    0, void)
end function

function useTargets(actor, activator)
  global usedTargetCount
  usedTargetCount = usedTargetCount + 1
  return true
end function

function dropItem(actor, item)
  global droppedItemCount
  droppedItemCount = droppedItemCount + 1
  return true
end function

function makeContext()
  context = gaitypes.defaultContext()
  context.walkMove = recordWalk
  context.visible = testVisible
  context.clearShot = testClearShot
  context.inPHS = alwaysPHS
  context.areasConnected = areasConnected
  context.useTargets = useTargets
  context.dropItem = dropItem
  return context
end function

function testArchetypesAndSpawn()
  // Compile-time integration guard for all three private component namespaces.
  assertEqual(btypes.zeroBaseEntity().spawnKind, "unspawned", "base alias")
  assertEqual(len(gptypes.createInventory(2).counts), 2, "gameplay alias")
  registry = gaiarchetypes.defaultRegistry()
  assertTrue(gaiarchetypes.validate(registry), "stock archetype validation")
  assertEqual(len(registry.entries), 22, "active stock spawn class count")
  assertEqual(len(registry.campaignEntries), 3, "campaign AI spawn class count")
  insaneDef = gaiarchetypes.find(registry, "MISC_INSANE")
  assertEqual(insaneDef.health, 100, "misc_insane health")
  assertEqual(insaneDef.gibHealth, -50, "misc_insane gib health")
  assertEqual(gaiarchetypes.find(registry, "monster_boss3_stand").maxs[2], 90.0, "boss3 stand bounds")
  assertEqual(gaiarchetypes.find(registry, "monster_commander_body").model,
    "models/monsters/commandr/tris.md2", "commander body model")
  commander = gaiarchetypes.find(registry, "MONSTER_TANK_COMMANDER")
  assertEqual(commander.health, 1000, "tank commander health")
  assertEqual(commander.gibHealth, -225, "tank commander gib health")
  flipperDef = gaiarchetypes.find(registry, "monster_flipper")
  assertEqual(flipperDef.movement, "swim", "flipper movement")
  jorgDef = gaiarchetypes.find(registry, "monster_jorg")
  assertEqual(jorgDef.maxs[2], 140.0, "Jorg bounds")
  boss2 = gaiarchetypes.SpawnMonster(registry, "monster_boss2", 14, makeContext())
  assertTrue((boss2.flags & gaiconstants.FL_IMMUNE_LASER) != 0,
    "Boss2 stock laser immunity")

  context = makeContext()
  context.time = 5.0
  flyer = gaiarchetypes.SpawnMonster(registry, "monster_flyer", 12, context)
  assertEqual(flyer.health, 50, "flyer health")
  assertEqual(flyer.mass, 50, "flyer mass")
  assertTrue((flyer.flags & gaiconstants.FL_FLY) != 0, "flyer flag")
  assertTrue((flyer.edict.serverFlags & gameconstants.SVF_MONSTER) != 0, "monster server flag")
  assertEqual(flyer.viewHeight, 25.0, "flyer viewheight")
  assertEqual(flyer.nextThink, 5.1, "monster next think")
  assertEqual(typeof(flyer.info.attack), "function", "archetype attack callback")
  assertEqual(typeof(flyer.info.melee), "function", "archetype melee callback")

  deathmatchContext = makeContext()
  deathmatchContext.deathmatch = true
  inhibited = gaiarchetypes.SpawnMonster(registry, "monster_berserk", 13, deathmatchContext)
  assertEqual(inhibited.edict.inUse, false, "deathmatch monster inhibited")
  assertEqual(inhibited.activity, "inhibited-deathmatch", "deathmatch state")
  assertErrorContains(try(gaiarchetypes.SpawnMonster(registry, "monster_future", 1, context)), "unknown stock", "unknown archetype")
  return registry
end function

function testMoveFrameGolden()
  actor = gaitypes.createActor(20, "monster_test")
  gaimonster.installDefaultCallbacks(actor, true, true)
  actor.info.scale = 2.0
  frames = [
    gaitypes.MonsterFrame(gaicore.ai_move, 1.0, void),
    gaitypes.MonsterFrame(gaicore.ai_move, 2.0, recordFrameThink),
    gaitypes.MonsterFrame(gaicore.ai_move, 3.0, void)
  ]
  actor.info.currentMove = gaitypes.MonsterMove("golden", 10, 12, frames, recordMoveEnd)
  actor.edict.state.frame = 0
  context = makeContext()
  context.time = 1.0

  gaimonster.M_MoveFrame(actor, context)
  assertEqual(actor.edict.state.frame, 10, "out-of-range starts first frame")
  assertEqual(walkDistances[0], 2.0, "scaled first movement")
  assertEqual(actor.nextThink, 1.1, "move frame think time")
  gaimonster.M_MoveFrame(actor, context)
  assertEqual(actor.edict.state.frame, 11, "frame advance")
  assertEqual(walkDistances[1], 4.0, "scaled second movement")
  assertEqual(frameThinkCount, 1, "frame think callback")
  actor.info.nextFrame = 12
  gaimonster.M_MoveFrame(actor, context)
  assertEqual(actor.edict.state.frame, 12, "explicit next frame")
  assertEqual(actor.info.nextFrame, 0, "next frame consumed")
  gaimonster.M_MoveFrame(actor, context)
  assertEqual(moveEndCount, 1, "move end callback")
  assertEqual(actor.edict.state.frame, 10, "move loops after end")
  actor.info.aiFlags = actor.info.aiFlags | gaiconstants.AI_HOLD_FRAME
  gaimonster.M_MoveFrame(actor, context)
  assertEqual(actor.edict.state.frame, 10, "held frame does not advance")
  assertEqual(walkDistances[len(walkDistances) - 1], 0.0, "held frame zero movement")
  return true
end function

function testSightMovementAndAttack()
  global visibilityEnabled, clearShotEnabled
  context = makeContext()
  context.time = 10.0
  context.frameNumber = 100
  quietMonster = gaitypes.createActor(29, "monster_quiet")
  gaimonster.installDefaultCallbacks(quietMonster, true, false)
  assertEqual(gaicore.FindTarget(quietMonster, context), false, "no target available")
  monster = gaitypes.createActor(30, "monster_gunner")
  gaimonster.installDefaultCallbacks(monster, true, false)
  monster.edict.state.origin = [0.0, 0.0, 0.0]
  monster.edict.state.angles = [0.0, 0.0, 0.0]
  player = gaitypes.createClientTarget(1)
  player.edict.state.origin = [100.0, 0.0, 0.0]
  player.lightLevel = 128
  context.sightClient = player
  visibilityEnabled = true
  assertEqual(gaicore.range(monster, player), gaiconstants.RANGE_NEAR, "near range")
  assertTrue(gaicore.infront(monster, player), "target in front")
  assertTrue(gaicore.FindTarget(monster, context), "visible target acquired")
  assertEqual(monster.enemy.edict.state.number, 1, "enemy assignment")
  assertEqual(monster.goalEntity.edict.state.number, 1, "hunt goal")
  assertEqual(monster.info.lastSighting[0], 100.0, "last sighting")
  assertEqual(context.sightEntity.edict.state.number, 30, "found target sight publication")
  assertEqual(context.sightEntityFrame, 100, "found target sight frame")
  assertEqual(monster.lightLevel, 128, "found target light publication")
  assertEqual(monster.activity, "sight", "sight callback dispatch")
  beforeMoves = len(walkDistances)
  gaicore.ai_charge(monster, 3.0, context)
  assertEqual(len(walkDistances), beforeMoves + 1, "charge movement callback")
  monster.info.attackFinished = 1000.0
  monster.goalEntity = player
  gaicore.ai_run(monster, 4.0, context)
  assertTrue(len(walkDistances) >= beforeMoves + 2, "run movement callback")

  behind = gaitypes.createClientTarget(2)
  behind.edict.state.origin = [-600.0, 0.0, 0.0]
  other = gaitypes.createActor(31, "monster_infantry")
  gaimonster.installDefaultCallbacks(other, true, false)
  other.edict.state.angles = [0.0, 0.0, 0.0]
  context.sightEntity = void
  context.sightEntityFrame = -1000
  context.sightClient = behind
  assertEqual(gaicore.FindTarget(other, context), false, "midrange target behind rejected")
  behind.edict.state.origin = [600.0, 0.0, 0.0]
  behind.lightLevel = 5
  assertEqual(gaicore.FindTarget(other, context), false, "dark target rejected")

  noise = gaitypes.createActor(40, "player_noise")
  noise.isMonster = false
  noise.owner = player
  noise.edict.state.origin = [0.0, 200.0, 0.0]
  noise.areaNumber = 2
  listener = gaitypes.createActor(41, "monster_soldier")
  listener.areaNumber = 1
  gaimonster.installDefaultCallbacks(listener, true, false)
  soundContext = makeContext()
  soundContext.time = 2.0
  soundContext.frameNumber = 20
  soundContext.soundEntity = noise
  soundContext.soundEntityFrame = 20
  assertTrue(gaicore.FindTarget(listener, soundContext), "sound target acquired")
  assertTrue((listener.info.aiFlags & gaiconstants.AI_SOUND_TARGET) != 0, "sound target flag")
  assertEqual(listener.enemy.className, "player_noise", "sound enemy")
  waypoint = gaitypes.createActor(42, "path_corner")
  listener.moveTarget = waypoint
  noise.teleportTime = 2.0
  soundContext.time = 7.1
  gaicore.ai_checkattack(listener, 0.0, soundContext)
  assertEqual(listener.goalEntity.edict.state.number, 42, "expired sound target restores move target")
  assertTrue((listener.info.aiFlags & gaiconstants.AI_SOUND_TARGET) == 0,
    "expired sound target flag cleared")

  brutal = gaitypes.createActor(43, "monster_brutal")
  gaimonster.installDefaultCallbacks(brutal, true, false)
  brutalEnemy = gaitypes.createClientTarget(44)
  brutalEnemy.health = -1
  brutal.enemy = brutalEnemy
  brutal.info.aiFlags = brutal.info.aiFlags | gaiconstants.AI_BRUTAL
  gaicore.ai_checkattack(brutal, 0.0, soundContext)
  assertEqual(brutal.enemy.edict.state.number, 44, "brutal wounded target retained")
  brutalEnemy.health = -80
  assertTrue(gaicore.ai_checkattack(brutal, 0.0, soundContext),
    "brutal monster releases gibbed target")
  assertTrue(brutal.enemy is void, "brutal gibbed target cleared")

  melee = gaitypes.createActor(50, "monster_berserk")
  gaimonster.installDefaultCallbacks(melee, false, true)
  closePlayer = gaitypes.createClientTarget(3)
  closePlayer.edict.state.origin = [40.0, 0.0, 0.0]
  melee.enemy = closePlayer
  attackContext = makeContext()
  attackContext.skill = 1
  attackContext.randomAttack = 0.0
  clearShotEnabled = true
  assertTrue(gaicore.M_CheckAttack(melee, attackContext, gaiconstants.RANGE_MELEE), "melee attack chosen")
  assertEqual(melee.info.attackState, gaiconstants.AS_MELEE, "melee state")
  assertTrue(gaicore.DispatchAttackState(melee, attackContext, 0.0), "melee dispatch")
  assertEqual(melee.meleeCount, 1, "melee callback count")

  missile = gaitypes.createActor(51, "monster_gunner")
  gaimonster.installDefaultCallbacks(missile, true, false)
  missile.enemy = player
  attackContext.time = 5.0
  attackContext.randomAttack = 0.01
  attackContext.randomDelay = 0.5
  assertTrue(gaicore.M_CheckAttack(missile, attackContext, gaiconstants.RANGE_NEAR), "missile attack chosen")
  assertEqual(missile.info.attackFinished, 6.0, "attack cooldown")
  assertTrue(gaicore.DispatchAttackState(missile, attackContext, 0.0), "missile dispatch")
  assertEqual(missile.attackCount, 1, "attack callback count")

  mutant = gaitypes.createActor(52, "monster_mutant")
  gaimonster.installDefaultCallbacks(mutant, true, true)
  mutantEnemy = gaitypes.createClientTarget(53)
  mutant.enemy = mutantEnemy
  mutant.edict.state.origin.x = 0.0; mutant.edict.state.origin.y = 0.0
  mutant.edict.state.origin.z = 0.0
  mutantEnemy.edict.state.origin.x = 40.0; mutantEnemy.edict.state.origin.y = 0.0
  mutantEnemy.edict.state.origin.z = 0.0
  attackContext.randomAttack = 0.0
  assertTrue(mutant.info.checkAttack(mutant, attackContext, gaiconstants.RANGE_MELEE),
    "Mutant exact melee check")
  assertEqual(mutant.info.attackState, gaiconstants.AS_MELEE, "Mutant melee state")
  mutantEnemy.edict.state.origin.x = 100.0
  assertTrue(mutant.info.checkAttack(mutant, attackContext, gaiconstants.RANGE_NEAR),
    "Mutant exact 100-unit jump boundary")
  assertEqual(mutant.info.attackState, gaiconstants.AS_MISSILE, "Mutant jump state")
  mutantEnemy.edict.state.origin.x = 101.0
  attackContext.randomAttack = 0.8999
  assertEqual(mutant.info.checkAttack(mutant, attackContext, gaiconstants.RANGE_NEAR), false,
    "Mutant rejects below 90-percent far-jump boundary")
  attackContext.randomAttack = 0.9
  assertTrue(mutant.info.checkAttack(mutant, attackContext, gaiconstants.RANGE_NEAR),
    "Mutant accepts exact 90-percent far-jump boundary")
  mutantEnemy.edict.state.origin.z = 200.0
  assertEqual(mutant.info.checkAttack(mutant, attackContext, gaiconstants.RANGE_NEAR), false,
    "Mutant rejects vertically disjoint jump target")
  return true
end function

function testLifecyclePainDeath(registry)
  global usedTargetCount, droppedItemCount
  context = makeContext()
  context.time = 3.0
  actor = gaiarchetypes.SpawnMonster(registry, "monster_infantry", 60, context)
  activator = gaitypes.createClientTarget(4)
  activator.edict.state.origin = [20.0, 0.0, 0.0]
  assertTrue(gaimonster.MonsterUse(actor, void, activator, context), "monster use wakes actor")
  assertEqual(actor.enemy.edict.state.number, 4, "use activator enemy")
  assertEqual(gaimonster.MonsterUse(actor, void, activator, context), false, "already angry use ignored")
  assertTrue(gaimonster.DispatchPain(actor, activator, 10, context), "pain callback")
  assertEqual(actor.painCount, 1, "pain count")

  actor.item = "ammo_shells"
  actor.deathTarget = "death_relay"
  actor.target = "old_target"
  actor.health = -5
  assertTrue(gaimonster.DispatchDie(actor, activator, 105, context), "die callback")
  assertEqual(actor.deadFlag, gaiconstants.DEAD_DEAD, "dead flag")
  assertTrue((actor.edict.serverFlags & gameconstants.SVF_DEADMONSTER) != 0, "dead monster server flag")
  assertEqual(actor.dieCount, 1, "die count")
  assertEqual(actor.target, "death_relay", "death target promoted")
  assertEqual(droppedItemCount, 1, "death item drop callback")
  assertEqual(usedTargetCount, 1, "death use-target callback")
  assertEqual(gaimonster.DispatchDie(actor, activator, 1, context), false, "repeated die dispatch ignored")
  assertEqual(actor.dieCount, 1, "die callback remains exactly once")
  assertEqual(usedTargetCount, 1, "death targets remain exactly once")

  triggered = gaitypes.createActor(61, "monster_test")
  gaimonster.installDefaultCallbacks(triggered, true, false)
  triggered.info.currentMove = gaiarchetypes.idleMove()
  triggered.spawnFlags = gaiconstants.SPAWNFLAG_TRIGGER_SPAWN | gaiconstants.SPAWNFLAG_SIGHT
  assertTrue(gaimonster.WalkMonsterStart(triggered, context), "triggered monster start")
  assertEqual(triggered.thinkKind, "triggered-wait", "triggered wait state")
  assertEqual(triggered.edict.solid, gameconstants.SOLID_NOT, "triggered monster hidden")
  assertTrue((triggered.edict.serverFlags & gameconstants.SVF_NOCLIENT) != 0, "triggered no-client flag")
  assertTrue((triggered.spawnFlags & gaiconstants.SPAWNFLAG_AMBUSH) != 0, "legacy sight flag fixed to ambush")
  return true
end function

function testPlayerTrailAndLostSight()
  global visibilityEnabled, lostTrailMarker
  trail = gaitrail.create(true)
  gaitrail.Add(trail, gaiqtypes.Vec3(40.0, 0.0, 0.0), 1.0)
  gaitrail.Add(trail, gaiqtypes.Vec3(80.0, 20.0, 0.0), 2.0)
  gaitrail.Add(trail, gaiqtypes.Vec3(120.0, 20.0, 0.0), 3.0)
  picker = gaitypes.createActor(70, "monster_picker")
  picker.info.trailTime = 1.5
  marker = gaitrail.PickNext(trail, picker)
  assertEqual(marker.timestamp, 2.0, "trail next timestamp")
  assertEqual(marker.edict.state.origin.x, 80.0, "trail next origin")
  assertTrue(marker.edict.state.angles.y > 0.0, "trail marker heading")

  context = makeContext()
  context.time = 10.0
  context.trailPickFirst = pickLostTrailFirst
  context.trailPickNext = pickLostTrailNext
  visibilityEnabled = false
  hunter = gaitypes.createActor(71, "monster_hunter")
  gaimonster.installDefaultCallbacks(hunter, true, false)
  enemy = gaitypes.createClientTarget(72)
  enemy.edict.state.origin = gaiqtypes.Vec3(200.0, 0.0, 0.0)
  hunter.enemy = enemy
  hunter.goalEntity = enemy
  hunter.info.lastSighting[0] = 100.0
  hunter.info.lastSighting[1] = 0.0
  hunter.info.lastSighting[2] = 0.0
  originalGoal = hunter.goalEntity
  assertTrue(gaicore.ai_run(hunter, 10.0, context), "lost-sight first run")
  assertTrue((hunter.info.aiFlags & gaiconstants.AI_LOST_SIGHT) != 0,
    "lost-sight flag")
  assertTrue((hunter.info.aiFlags & gaiconstants.AI_PURSUIT_LAST_SEEN) != 0,
    "last-seen pursuit flag")
  assertTrue(nativeRawValue(hunter.goalEntity) == nativeRawValue(originalGoal),
    "temporary pursuit goal was not restored")

  lostTrailMarker = marker
  hunter.info.aiFlags = hunter.info.aiFlags | gaiconstants.AI_PURSUE_NEXT
  assertTrue(gaicore.ai_run(hunter, 10.0, context), "trail marker pursuit")
  assertEqual(hunter.info.trailTime, 2.0, "pursuit marker timestamp")
  assertEqual(hunter.info.lastSighting[0], 80.0, "pursuit marker x")
  assertTrue((hunter.info.aiFlags & gaiconstants.AI_PURSUIT_LAST_SEEN) == 0,
    "last-seen pursuit consumed")

  correction = gaitypes.createActor(73, "monster_course")
  gaimonster.installDefaultCallbacks(correction, true, false)
  correction.enemy = enemy
  correction.goalEntity = enemy
  correction.edict.state.origin = gaiqtypes.Vec3(0.0, 0.0, 0.0)
  correction.edict.mins = gaiqtypes.Vec3(-16.0, -16.0, -24.0)
  correction.edict.maxs = gaiqtypes.Vec3(16.0, 16.0, 32.0)
  correction.info.lastSighting[0] = 100.0
  correction.info.lastSighting[1] = 0.0
  correction.info.lastSighting[2] = 0.0
  courseContext = makeContext()
  courseContext.time = 10.0
  courseContext.moveTrace = courseCorrectionTrace
  visibilityEnabled = false
  assertTrue(gaicore.ai_run(correction, 10.0, courseContext),
    "course-corrected pursuit")
  assertTrue((correction.info.aiFlags & gaiconstants.AI_PURSUE_TEMP) != 0,
    "temporary course flag")
  assertEqual(correction.info.savedGoal[0], 100.0, "saved pursuit goal")
  assertTrue(correction.info.lastSighting[1] < 0.0,
    "left course correction was not selected")

  timedOut = gaitypes.createActor(74, "monster_timeout")
  gaimonster.installDefaultCallbacks(timedOut, true, false)
  timedOut.enemy = enemy
  timedOut.goalEntity = enemy
  timedOut.info.searchTime = 1.0
  courseContext.time = 21.1
  courseContext.moveTrace = void
  gaicore.ai_run(timedOut, 4.0, courseContext)
  assertEqual(timedOut.info.searchTime, 0.0, "pursuit search timeout")
  visibilityEnabled = true
  return true
end function

function main(args)
  print "MiniQuake2 gameplay AI/monster scenarios starting: 5"
  registry = testArchetypesAndSpawn()
  testMoveFrameGolden()
  testSightMovementAndAttack()
  testLifecyclePainDeath(registry)
  testPlayerTrailAndLostSight()
  print "MiniQuake2 gameplay AI/monster scenarios passed: 5"
  return 0
end function
