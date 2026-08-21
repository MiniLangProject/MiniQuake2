/* Protocol-34 golden parser vectors; no sound or model assets are loaded. */
import miniquake2.qcommon.constants as qc
import miniquake2.qcommon.sizebuf as qsz
import miniquake2.qcommon.message as qmsg
import miniquake2.protocol.types as pt
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

  monster = ceparser.parseMuzzleFlash2(state, reading(bytes([1, 0, 1])), resolveEntity)
  assertNear(monster.origin.x, 30.7, 0.0001, "monster muzzle forward offset")
  assertNear(monster.origin.y, 38.5, 0.0001, "monster muzzle right offset")
  assertNear(monster.origin.z, 58.7, 0.0001, "monster muzzle vertical offset")
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

  rail = bytes([ceconstants.TE_RAILTRAIL, 0, 0, 0, 0, 0, 0, 128, 0, 0, 0, 0, 0])
  ceparser.parseTempEntity(state, reading(rail))
  assertTrue(len(state.particles) >= 16, "rail trail particles")
  assertEqual(len(state.soundEvents), 1, "rail sound event")

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

function testEntityEvents()
  global entities
  state = cestate.createSilent(5)
  entity = pt.zeroEntityState()
  entity.number = 2; entity.origin = [1.0, 2.0, 3.0]; entity.event = ceconstants.EV_ITEM_RESPAWN
  ceparser.handleEntityEvent(state, entity)
  assertEqual(state.soundEvents[0].soundName, "items/respawn1.wav", "respawn event sound")
  assertEqual(len(state.particles), 64, "respawn event particles")
  return true
end function

testSoundGolden()
testMuzzleFlashes()
testTempEntities()
testEntityEvents()
print "client_effects_parser_tests: PASS"

