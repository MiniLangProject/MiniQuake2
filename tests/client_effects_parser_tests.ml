/* Protocol-34 golden parser vectors; no sound or model assets are loaded. */
import miniquake2.qcommon.constants as qc
import miniquake2.qcommon.sizebuf as qsz
import miniquake2.qcommon.message as qmsg
import miniquake2.protocol.types as pt
import miniquake2.renderer.constants as rc
import miniquake2.client.effects.constants as ceconstants
import miniquake2.client.effects.audio as ceaudio
import miniquake2.client.effects.state as cestate
import miniquake2.client.effects.parser as ceparser

played = []
entities = array(1024, void)

function resolveIndex(index)
  return "index:" + index
end function

function resolveName(name)
  return name
end function

function playSound(event, resolved)
  global played
  played = played + [[event, resolved]]
  return true
end function

function resolveEntity(number)
  global entities
  return entities[number]
end function

function assertEqual(actual, expected, name)
  if actual != expected then return error(8000, name + ": expected " + expected + ", got " + actual) end if
  return true
end function

function assertNear(actual, expected, tolerance, name)
  difference = actual - expected
  if difference < 0.0 then difference = -difference end if
  if difference > tolerance then return error(8001, name + ": values differ") end if
  return true
end function

function assertTrue(value, name)
  if value != true then return error(8002, name + ": expected true") end if
  return true
end function

function reading(data)
  buffer = qsz.alloc(len(data))
  qsz.writeBytes(buffer, data)
  qmsg.beginReading(buffer)
  return buffer
end function

function testSoundGolden()
  global played
  played = []
  state = cestate.create(ceaudio.callbacks(resolveIndex, resolveName, playSound), 1)
  // flags=all, sound=7, volume=128, attenuation=64, offset=25ms,
  // packed entity/channel=(3<<3)|2, position=(1,-2,3).
  golden = bytes([31, 7, 128, 64, 25, 26, 0, 8, 0, 240, 255, 24, 0])
  event = ceparser.parseSound(state, reading(golden))
  assertEqual(event.entity, 3, "sound entity")
  assertEqual(event.channel, 2, "sound channel")
  assertNear(event.volume, 128.0 / 255.0, 0.0001, "sound volume")
  assertNear(event.position.x, 1.0, 0.0001, "sound position x")
  assertNear(event.position.y, -2.0, 0.0001, "sound position y")
  assertEqual(played[0][1], "index:7", "sound resolver handoff")
  assertTrue(try(ceparser.parseSound(state, reading(bytes([32, 1])))) is error,
    "reserved sound flags rejected")
  return true
end function

function testMuzzleFlashes()
  global entities, played
  played = []
  entity = pt.zeroEntityState()
  entity.number = 1
  entity.origin = [10.0, 20.0, 30.0]
  entity.angles = [0.0, 0.0, 0.0]
  entities[1] = entity
  state = cestate.create(ceaudio.callbacks(resolveIndex, resolveName, playSound), 7)
  light = ceparser.parseMuzzleFlash(state, reading(bytes([1, 0, ceconstants.MZ_ROCKET])), resolveEntity)
  assertNear(light.origin.x, 28.0, 0.0001, "player muzzle forward offset")
  assertNear(light.origin.y, 4.0, 0.0001, "player muzzle right offset")
  assertEqual(light.color[0], 1.0, "rocket light red")
  assertEqual(light.color[1], 0.5, "rocket light green")
  assertEqual(played[0][1], "weapons/rocklf1a.wav", "rocket sound handoff")
  assertEqual(played[1][1], "weapons/rocklr1b.wav", "rocket reload sound handoff")
  assertNear(played[1][0].timeOffset, 0.1, 0.0001, "rocket reload delay")

  monster = ceparser.parseMuzzleFlash2(state, reading(bytes([1, 0, 1])), resolveEntity)
  assertNear(monster.origin.x, 30.7, 0.0001, "monster muzzle forward offset")
  assertNear(monster.origin.y, 38.5, 0.0001, "monster muzzle right offset")
  assertNear(monster.origin.z, 58.7, 0.0001, "monster muzzle vertical offset")
  assertEqual(state.soundEvents[2].soundName, "tank/tnkatck3.wav", "tank blaster sound")

  soldierState = cestate.createSilent(9)
  ceparser.parseMuzzleFlash2(soldierState, reading(bytes([1, 0, 43])), resolveEntity)
  assertEqual(soldierState.particleCount, 40, "soldier machinegun particles")
  assertEqual(len(soldierState.explosions), 2, "soldier machinegun smoke and flash")
  assertEqual(soldierState.soundEvents[0].soundName, "soldier/solatck3.wav",
    "soldier machinegun sound")

  bossState = cestate.createSilent(13)
  ceparser.parseMuzzleFlash2(bossState, reading(bytes([1, 0, 73])), resolveEntity)
  assertNear(bossState.soundEvents[0].attenuation, 0.0, 0.0001,
    "boss machinegun global attenuation")

  chainState = cestate.createSilent(17)
  chainLight = ceparser.parseMuzzleFlash(chainState, reading(bytes([1, 0, ceconstants.MZ_CHAINGUN3])), resolveEntity)
  assertEqual(len(chainState.soundEvents), 3, "chaingun three layered shots")
  assertNear(chainState.soundEvents[1].timeOffset, 0.033, 0.0001, "chaingun second delay")
  assertNear(chainState.soundEvents[2].timeOffset, 0.066, 0.0001, "chaingun third delay")
  assertNear(chainLight.die, 0.1, 0.0001, "chaingun source dlight lifetime")

  loginState = cestate.createSilent(19)
  loginLight = ceparser.parseMuzzleFlash(loginState, reading(bytes([1, 0, ceconstants.MZ_LOGIN])), resolveEntity)
  assertEqual(loginState.particleCount, 500, "login effect stock particle count")
  assertNear(loginState.particles[0].acceleration.z, -40.0, 0.0001,
    "login effect stock gravity")
  assertTrue(loginState.particles[0].color >= 0xd0 and loginState.particles[0].color <= 0xd7,
    "login effect stock color range")
  assertNear(loginLight.die, 1.0, 0.0001, "login source dlight lifetime")
  assertTrue(try(ceparser.parseMuzzleFlash2(state, reading(bytes([1, 0, 0])), resolveEntity)) is error,
    "unused monster flash zero rejected")
  return true
end function

function testTempEntities()
  state = cestate.createSilent(11)
  explosionMessage = bytes([ceconstants.TE_EXPLOSION1, 8, 0, 16, 0, 24, 0])
  ceparser.parseTempEntity(state, reading(explosionMessage))
  assertEqual(len(state.explosions), 1, "explosion allocated")
  assertNear(state.explosions[0].origin.z, 3.0, 0.0001, "explosion origin")
  assertEqual(state.explosions[0].frames, 15, "rocket explosion frame count")
  assertEqual(state.particleCount, 256, "rocket explosion particle count")
  assertEqual(state.soundEvents[0].soundName, "weapons/rocklx1a.wav", "rocket explosion sound")

  bfgMessage = bytes([ceconstants.TE_BFG_EXPLOSION, 8, 0, 16, 0, 24, 0])
  ceparser.parseTempEntity(state, reading(bfgMessage))
  assertEqual(state.explosions[1].modelName, "sprites/s_bfg2.sp2",
    "BFG sprite model")
  assertEqual(state.explosions[1].flags & rc.RF_TRANSLUCENT,
    rc.RF_TRANSLUCENT, "BFG sprite translucency")
  assertNear(state.explosions[1].alpha, 0.30, 0.0001, "BFG sprite source alpha")

  rail = bytes([ceconstants.TE_RAILTRAIL, 0, 0, 0, 0, 0, 0, 128, 0, 0, 0, 0, 0])
  railStart = state.particleCount
  ceparser.parseTempEntity(state, reading(rail))
  assertEqual(state.particleCount - railStart, 38, "rail trail ring and spray particles")
  assertEqual(len(state.soundEvents), 2, "explosion and rail sound events")
  assertEqual(state.soundEvents[1].soundName, "weapons/railgf1a.wav", "rail sound event")

  beam = bytes([ceconstants.TE_PARASITE_ATTACK, 5, 0,
    0, 0, 0, 0, 0, 0, 80, 0, 0, 0, 0, 0])
  ceparser.parseTempEntity(state, reading(beam))
  assertEqual(state.beams[0].entity, 5, "beam entity")
  assertNear(state.beams[0].finish.x, 10.0, 0.0001, "beam endpoint")
  assertTrue(try(ceparser.parseTempEntity(state, reading(bytes([ceconstants.TE_FLAME])))) is error,
    "reference-unsupported TE_FLAME rejected")
  assertTrue(try(ceparser.parseTempEntity(state, reading(bytes([ceconstants.TE_BLOOD, 0])))) is error,
    "truncated temp entity rejected")
  return true
end function

function testStockImpactParity()
  gunshotState = cestate.createSilent(3)
  gunshot = bytes([ceconstants.TE_GUNSHOT, 0, 0, 0, 0, 0, 0, 52])
  ceparser.parseTempEntity(gunshotState, reading(gunshot))
  assertEqual(gunshotState.particleCount, 40, "gunshot particle count")
  assertEqual(len(gunshotState.explosions), 2, "gunshot smoke and flash")
  assertEqual(gunshotState.explosions[0].modelName, "models/objects/smoke/tris.md2",
    "gunshot smoke model")
  assertEqual(gunshotState.explosions[1].modelName, "models/objects/flash/tris.md2",
    "gunshot flash model")

  blasterState = cestate.createSilent(5)
  blaster = bytes([ceconstants.TE_BLASTER, 0, 0, 0, 0, 0, 0, 52])
  ceparser.parseTempEntity(blasterState, reading(blaster))
  assertEqual(blasterState.particleCount, 40, "blaster does not add generic explosion particles")
  assertEqual(len(blasterState.explosions), 1, "blaster impact model")
  assertNear(blasterState.explosions[0].angles.x, 90.0, 0.001, "blaster impact pitch")
  assertNear(blasterState.explosions[0].angles.y, 0.0, 0.001, "blaster impact yaw")
  assertEqual(blasterState.soundEvents[0].soundName, "weapons/lashit.wav", "blaster impact sound")

  screenState = cestate.createSilent(7)
  screen = bytes([ceconstants.TE_SCREEN_SPARKS, 0, 0, 0, 0, 0, 0, 5])
  ceparser.parseTempEntity(screenState, reading(screen))
  assertEqual(screenState.soundEvents[0].soundName, "weapons/lashit.wav", "screen sparks sound")

  grenadeState = cestate.createSilent(11)
  grenade = bytes([ceconstants.TE_GRENADE_EXPLOSION_WATER, 0, 0, 0, 0, 0, 0])
  ceparser.parseTempEntity(grenadeState, reading(grenade))
  assertEqual(grenadeState.explosions[0].frames, 19, "grenade explosion frame count")
  assertEqual(grenadeState.explosions[0].baseFrame, 30, "grenade explosion base frame")
  assertEqual(grenadeState.particleCount, 256, "grenade explosion particles")
  assertEqual(grenadeState.soundEvents[0].soundName, "weapons/xpld_wat.wav",
    "underwater explosion sound")

  bigState = cestate.createSilent(13)
  big = bytes([ceconstants.TE_EXPLOSION1_BIG, 0, 0, 0, 0, 0, 0])
  ceparser.parseTempEntity(bigState, reading(big))
  assertEqual(bigState.explosions[0].modelName, "models/objects/r_explode2/tris.md2",
    "large explosion model")
  assertEqual(bigState.particleCount, 0, "large explosion omits stock particles")

  trackerState = cestate.createSilent(15)
  tracker = bytes([ceconstants.TE_TRACKER_EXPLOSION, 0, 0, 0, 0, 0, 0])
  ceparser.parseTempEntity(trackerState, reading(tracker))
  assertEqual(trackerState.particleCount, 128, "tracker particle count")
  assertEqual(trackerState.soundEvents[0].soundName, "weapons/disrupthit.wav",
    "tracker explosion sound")

  tunnelState = cestate.createSilent(17)
  tunnel = bytes([ceconstants.TE_TUNNEL_SPARKS, 1, 0, 0, 0, 0, 0, 0, 5, 0x74])
  ceparser.parseTempEntity(tunnelState, reading(tunnel))
  assertNear(tunnelState.particles[0].acceleration.z, 40.0, 0.0001,
    "tunnel sparks rise with stock positive gravity")

  splashState = cestate.createSilent(19)
  splash = bytes([ceconstants.TE_SPLASH, 1, 0, 0, 0, 0, 0, 0, 5, 1])
  ceparser.parseTempEntity(splashState, reading(splash))
  assertEqual(len(splashState.soundEvents), 1, "spark splash sound")
  assertNear(splashState.soundEvents[0].attenuation, 3.0, 0.0001,
    "spark splash static attenuation")

  heatState = cestate.createSilent(21)
  heat = bytes([ceconstants.TE_MONSTER_HEATBEAM, 5, 0,
    0, 0, 0, 0, 0, 0, 80, 0, 0, 0, 0, 0])
  ceparser.parseTempEntity(heatState, reading(heat))
  assertEqual(heatState.beams[0].modelName, "models/proj/widowbeam/tris.md2",
    "monster heatbeam model")

  bossTeleportState = cestate.createSilent(23)
  bossTeleport = bytes([ceconstants.TE_BOSSTPORT, 0, 0, 0, 0, 0, 0])
  ceparser.parseTempEntity(bossTeleportState, reading(bossTeleport))
  assertEqual(bossTeleportState.particleCount, 4096, "boss teleport fills stock particle pool")
  assertEqual(bossTeleportState.soundEvents[0].soundName, "misc/bigtele.wav",
    "boss teleport sound")
  assertNear(bossTeleportState.soundEvents[0].attenuation, 0.0, 0.0001,
    "boss teleport global attenuation")
  assertNear(bossTeleportState.particles[0].acceleration.z, 160.0, 0.0001,
    "boss teleport stock upward acceleration")
  return true
end function

function testStockParticleFamilies()
  randomState = cestate.createSilent(1)
  assertEqual(cestate.random(randomState), 41, "client effects Visual C rand first value")
  assertEqual(cestate.random(randomState), 18467, "client effects Visual C rand second value")

  steamState = cestate.createSilent(29)
  steam = bytes([ceconstants.TE_STEAM, 255, 255, 3,
    0, 0, 0, 0, 0, 0, 5, 0xe0, 60, 0])
  ceparser.parseTempEntity(steamState, reading(steam))
  assertEqual(steamState.particleCount, 3, "instant steam particle count")
  assertNear(steamState.particles[0].acceleration.z, -20.0, 0.0001,
    "instant steam half gravity")
  assertTrue(steamState.particles[0].color >= 0xe0 and steamState.particles[0].color <= 0xe7,
    "instant steam color range")

  smokeState = cestate.createSilent(31)
  smoke = bytes([ceconstants.TE_CHAINFIST_SMOKE, 0, 0, 0, 0, 0, 0])
  ceparser.parseTempEntity(smokeState, reading(smoke))
  assertEqual(smokeState.particleCount, 20, "chainfist smoke particle count")
  assertNear(smokeState.particles[0].acceleration.z, 0.0, 0.0001,
    "chainfist smoke ignores gravity")

  teleportState = cestate.createSilent(37)
  teleport = bytes([ceconstants.TE_TELEPORT_EFFECT, 0, 0, 0, 0, 0, 0])
  ceparser.parseTempEntity(teleportState, reading(teleport))
  assertEqual(teleportState.particleCount, 1053, "teleport lattice particle count")
  assertNear(teleportState.particles[0].acceleration.z, -40.0, 0.0001,
    "teleport lattice gravity")

  debugState = cestate.createSilent(41)
  debugTrail = bytes([ceconstants.TE_DEBUGTRAIL,
    0, 0, 0, 0, 0, 0, 80, 0, 0, 0, 0, 0])
  ceparser.parseTempEntity(debugState, reading(debugTrail))
  assertEqual(debugState.particleCount, 4, "debug trail stock spacing")
  assertTrue(debugState.particles[0].velocity.z >= 15.0 and
    debugState.particles[0].velocity.z <= 25.0, "debug trail stock upward impulse")

  bubbleState = cestate.createSilent(43)
  bubble = bytes([ceconstants.TE_BUBBLETRAIL,
    0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0])
  ceparser.parseTempEntity(bubbleState, reading(bubble))
  assertEqual(bubbleState.particleCount, 2, "classic bubble trail stock spacing")

  bubble2State = cestate.createSilent(47)
  bubble2 = bytes([ceconstants.TE_BUBBLETRAIL2,
    0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0])
  ceparser.parseTempEntity(bubble2State, reading(bubble2))
  assertEqual(bubble2State.particleCount, 8, "Rogue bubble trail stock spacing")
  assertTrue(bubble2State.particles[0].velocity.z >= 10.0,
    "Rogue bubble trail stock upward impulse")
  assertEqual(bubble2State.soundEvents[0].soundName, "weapons/lashit.wav",
    "Rogue bubble trail sound")

  widowState = cestate.createSilent(53)
  widow = bytes([ceconstants.TE_WIDOWBEAMOUT, 7, 0, 0, 0, 0, 0, 0, 0])
  ceparser.parseTempEntity(widowState, reading(widow))
  cestate.advance(widowState, 1)
  assertEqual(widowState.particleCount, 300, "widow beamout stock radial count")
  assertEqual(widowState.particles[0].alphaVelocity, ceconstants.INSTANT_PARTICLE,
    "widow beamout instant lifetime")

  nukeState = cestate.createSilent(59)
  nuke = bytes([ceconstants.TE_NUKEBLAST, 0, 0, 0, 0, 0, 0])
  ceparser.parseTempEntity(nukeState, reading(nuke))
  cestate.advance(nukeState, 1)
  assertEqual(nukeState.particleCount, 700, "nuke blast stock radial count")
  assertTrue(nukeState.particles[0].color >= 110 and nukeState.particles[0].color <= 116,
    "nuke blast stock color table")
  return true
end function

function testEntityEvents()
  global entities
  state = cestate.createSilent(5)
  entity = pt.zeroEntityState()
  entity.number = 2; entity.origin = [1.0, 2.0, 3.0]; entity.event = ceconstants.EV_ITEM_RESPAWN
  ceparser.handleEntityEvent(state, entity)
  assertEqual(state.soundEvents[0].soundName, "items/respawn1.wav", "respawn event sound")
  assertEqual(state.particleCount, 64, "respawn event particles")
  assertNear(state.particles[0].acceleration.z, -8.0, 0.0001,
    "respawn event stock gravity")

  teleporter = pt.zeroEntityState()
  teleporter.number = 3; teleporter.origin = [4.0, 5.0, 6.0]
  teleporter.event = ceconstants.EV_PLAYER_TELEPORT
  ceparser.handleEntityEvent(state, teleporter)
  assertEqual(state.particleCount, 1117, "player teleport uses stock lattice")

  footstepState = cestate.createSilent(1)
  footstep = pt.zeroEntityState()
  footstep.number = 4; footstep.event = ceconstants.EV_FOOTSTEP
  ceparser.handleEntityEvent(footstepState, footstep)
  assertEqual(footstepState.soundEvents[0].soundName, "player/step2.wav",
    "footstep selects from stock Visual C random sequence")
  return true
end function

testSoundGolden()
testMuzzleFlashes()
testTempEntities()
testStockImpactParity()
testStockParticleFamilies()
testEntityEvents()
print "client_effects_parser_tests: PASS"
