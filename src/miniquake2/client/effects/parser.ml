/* Strict Protocol-34 sound, event, muzzleflash and temp-entity dispatch. */
package miniquake2.client.effects.parser

import miniquake2.qcommon.constants as qc
import miniquake2.qcommon.types as qt
import miniquake2.qcommon.directions as qdirections
import miniquake2.protocol.constants as pc
import miniquake2.protocol.checked as pchecked
import miniquake2.physics.vector as pvector
import miniquake2.renderer.constants as rc
import miniquake2.client.effects.constants as ceconstants
import miniquake2.client.effects.types as cetypes
import miniquake2.client.effects.audio as ceaudio
import miniquake2.client.effects.state as cestate
import miniquake2.client.effects.flash_offsets as ceflash

const SOUND_FLAG_MASK = 31

function readPosition(buffer, operation)
  return qt.Vec3(pchecked.readCoord(buffer, operation + " x"),
    pchecked.readCoord(buffer, operation + " y"), pchecked.readCoord(buffer, operation + " z"))
end function

function readDirection(buffer, operation)
  return qdirections.decodeDirection(pchecked.readByte(buffer, operation))
end function

function namedSound(state, position, entity, channel, name, volume, attenuation, offset)
  event = cetypes.SoundEvent(position, entity, channel, -1, name, volume, attenuation, offset)
  ceaudio.emit(state, event)
  return event
end function

function indexedSound(state, position, entity, channel, index, volume, attenuation, offset)
  event = cetypes.SoundEvent(position, entity, channel, index, "", volume, attenuation, offset)
  ceaudio.emit(state, event)
  return event
end function

function parseSound(state, buffer)
  flags = pchecked.readByte(buffer, "sound flags")
  if (flags & ~SOUND_FLAG_MASK) != 0 then return error(7330, "sound packet contains reserved flags") end if
  soundIndex = pchecked.readByte(buffer, "sound index")
  volume = 1.0
  attenuation = 1.0
  timeOffset = 0.0
  if (flags & qc.SND_VOLUME) != 0 then volume = pchecked.readByte(buffer, "sound volume") / 255.0 end if
  if (flags & qc.SND_ATTENUATION) != 0 then attenuation = pchecked.readByte(buffer, "sound attenuation") / 64.0 end if
  if (flags & qc.SND_OFFSET) != 0 then timeOffset = pchecked.readByte(buffer, "sound offset") / 1000.0 end if
  entity = 0
  channel = 0
  if (flags & qc.SND_ENT) != 0 then
    packed = pchecked.readUShort(buffer, "sound entity/channel")
    entity = packed >> 3
    channel = packed & 7
    if entity >= pc.MAX_EDICTS then return error(7331, "sound entity outside protocol range") end if
  end if
  position = void
  if (flags & qc.SND_POS) != 0 then position = readPosition(buffer, "sound position") end if
  return indexedSound(state, position, entity, channel, soundIndex, volume, attenuation, timeOffset)
end function

function entityOrigin(entityState)
  if entityState is void or typeof(entityState) != "struct" or len(entityState.origin) != 3 then return error(7332, "muzzleflash entity state is unavailable") end if
  return cestate.vecFromArray(entityState.origin)
end function

function entityAngles(entityState)
  if entityState is void or typeof(entityState) != "struct" or len(entityState.angles) != 3 then return error(7333, "muzzleflash entity angles are unavailable") end if
  return qt.Vec3(entityState.angles[0], entityState.angles[1], entityState.angles[2])
end function

function playerMuzzleSound(weapon)
  if weapon == ceconstants.MZ_BLASTER or weapon == ceconstants.MZ_BLASTER2 then return "weapons/blastf1a.wav" end if
  if weapon == ceconstants.MZ_MACHINEGUN or weapon == ceconstants.MZ_CHAINGUN1 or weapon == ceconstants.MZ_CHAINGUN2 or weapon == ceconstants.MZ_CHAINGUN3 then return "weapons/machgf1b.wav" end if
  if weapon == ceconstants.MZ_SHOTGUN then return "weapons/shotgf1b.wav" end if
  if weapon == ceconstants.MZ_SSHOTGUN then return "weapons/sshotf1b.wav" end if
  if weapon == ceconstants.MZ_RAILGUN then return "weapons/railgf1a.wav" end if
  if weapon == ceconstants.MZ_ROCKET then return "weapons/rocklf1a.wav" end if
  if weapon == ceconstants.MZ_GRENADE or weapon == ceconstants.MZ_LOGIN or weapon == ceconstants.MZ_LOGOUT or weapon == ceconstants.MZ_RESPAWN then return "weapons/grenlf1a.wav" end if
  if weapon == ceconstants.MZ_BFG then return "weapons/bfg__f1y.wav" end if
  if weapon == ceconstants.MZ_HYPERBLASTER or weapon == ceconstants.MZ_BLUEHYPERBLASTER then return "weapons/hyprbf1a.wav" end if
  if weapon == ceconstants.MZ_IONRIPPER then return "weapons/rippfire.wav" end if
  if weapon == ceconstants.MZ_PHALANX then return "weapons/plasshot.wav" end if
  if weapon == ceconstants.MZ_ETF_RIFLE then return "weapons/nail1.wav" end if
  if weapon == ceconstants.MZ_SHOTGUN2 then return "weapons/shotg2.wav" end if
  if weapon == ceconstants.MZ_TRACKER then return "weapons/disint2.wav" end if
  return ""
end function

function playerMuzzleColor(weapon)
  if weapon == ceconstants.MZ_BLUEHYPERBLASTER or weapon == ceconstants.MZ_NUKE4 then return [0.0, 0.0, 1.0] end if
  if weapon == ceconstants.MZ_BFG or weapon == ceconstants.MZ_BLASTER2 then return [0.0, 1.0, 0.0] end if
  if weapon == ceconstants.MZ_TRACKER then return [-1.0, -1.0, -1.0] end if
  if weapon == ceconstants.MZ_RAILGUN then return [0.5, 0.5, 1.0] end if
  if weapon == ceconstants.MZ_ROCKET then return [1.0, 0.5, 0.2] end if
  if weapon == ceconstants.MZ_GRENADE or weapon == ceconstants.MZ_ETF_RIFLE then return [1.0, 0.5, 0.0] end if
  if weapon == ceconstants.MZ_IONRIPPER or weapon == ceconstants.MZ_PHALANX then return [1.0, 0.5, 0.5] end if
  if weapon == ceconstants.MZ_LOGIN or weapon == ceconstants.MZ_BLASTER2 or weapon == ceconstants.MZ_NUKE8 then return [0.0, 1.0, 0.0] end if
  if weapon == ceconstants.MZ_LOGOUT or weapon == ceconstants.MZ_NUKE1 then return [1.0, 0.0, 0.0] end if
  if weapon == ceconstants.MZ_NUKE2 then return [1.0, 1.0, 0.0] end if
  return [1.0, 1.0, 0.0]
end function

function parseMuzzleFlash(state, buffer, entityResolver)
  entityNumber = pchecked.readShort(buffer, "muzzleflash entity")
  if entityNumber < 1 or entityNumber >= pc.MAX_EDICTS then return error(7334, "muzzleflash entity outside protocol range") end if
  encodedWeapon = pchecked.readByte(buffer, "muzzleflash weapon")
  silenced = (encodedWeapon & ceconstants.MZ_SILENCED) != 0
  weapon = encodedWeapon & ~ceconstants.MZ_SILENCED
  entityState = entityResolver(entityNumber)
  origin = entityOrigin(entityState)
  vectors = pvector.angleVectors(entityAngles(entityState))
  origin = cestate.add(origin, cestate.scaled(vectors[0], 18.0))
  origin = cestate.add(origin, cestate.scaled(vectors[1], 16.0))
  baseRadius = 200
  volume = 1.0
  if silenced then baseRadius = 100; volume = 0.2 end if
  if weapon == ceconstants.MZ_CHAINGUN2 then baseRadius = 225 end if
  if weapon == ceconstants.MZ_CHAINGUN3 then baseRadius = 250 end if
  duration = 0.0
  if weapon == ceconstants.MZ_LOGIN or weapon == ceconstants.MZ_LOGOUT or weapon == ceconstants.MZ_RESPAWN then duration = 1000.0 end if
  if weapon == ceconstants.MZ_HEATBEAM or (weapon >= ceconstants.MZ_NUKE1 and weapon <= ceconstants.MZ_NUKE8) then duration = 100.0 end if
  light = cestate.addDLight(state, entityNumber, origin, (baseRadius + (cestate.random(state) & 31)) * 1.0,
    playerMuzzleColor(weapon), duration, 0.0)
  light.minLight = 32.0
  name = playerMuzzleSound(weapon)
  if name != "" then namedSound(state, void, entityNumber, 1, name, volume, 1.0, 0.0) end if
  if weapon == ceconstants.MZ_LOGIN or weapon == ceconstants.MZ_LOGOUT or weapon == ceconstants.MZ_RESPAWN then
    cestate.particleEffect(state, entityOrigin(entityState), qt.zeroVec3(), 0xd0, 64, 32.0)
  end if
  return light
end function

function monsterMachineGun(flash)
  return (flash >= 4 and flash <= 22) or (flash >= 26 and flash <= 38) or
    (flash >= 43 and flash <= 52) or (flash >= 63 and flash <= 69) or
    (flash >= 73 and flash <= 77) or (flash >= 120 and flash <= 139) or
    flash == 141 or flash == 152 or flash == 153
end function

function monsterRocket(flash)
  return (flash >= 23 and flash <= 25) or flash == 57 or (flash >= 70 and flash <= 81) or
    flash == 142 or (flash >= 191 and flash <= 194)
end function

function monsterRail(flash)
  return flash == 61 or flash == 119 or flash == 147 or flash == 150 or flash == 154 or flash == 155
end function

function monsterMuzzleColor(flash)
  if monsterRocket(flash) then return [1.0, 0.5, 0.2] end if
  if flash >= 53 and flash <= 56 or flash == 140 then return [1.0, 0.5, 0.0] end if
  if monsterRail(flash) then return [0.5, 0.5, 1.0] end if
  if flash == 101 or flash == 132 then return [0.5, 1.0, 0.5] end if
  if flash == 148 then return [-1.0, -1.0, -1.0] end if
  if flash >= 144 and flash <= 190 then return [0.0, 1.0, 0.0] end if
  return [1.0, 1.0, 0.0]
end function

function monsterMuzzleSound(flash)
  if monsterMachineGun(flash) then return "infantry/infatck1.wav" end if
  if monsterRocket(flash) then return "tank/rocket.wav" end if
  if flash >= 53 and flash <= 56 or flash == 140 then return "gunner/gunatck3.wav" end if
  if flash == 148 then return "weapons/disint2.wav" end if
  if monsterRail(flash) or flash == 101 or flash == 132 then return "" end if
  return "tank/tnkatck3.wav"
end function

function parseMuzzleFlash2(state, buffer, entityResolver)
  entityNumber = pchecked.readShort(buffer, "monster muzzleflash entity")
  if entityNumber < 1 or entityNumber >= pc.MAX_EDICTS then return error(7335, "monster muzzleflash entity outside protocol range") end if
  flash = pchecked.readByte(buffer, "monster muzzleflash number")
  offset = ceflash.get(flash)
  entityState = entityResolver(entityNumber)
  origin = entityOrigin(entityState)
  vectors = pvector.angleVectors(entityAngles(entityState))
  origin = cestate.add(origin, cestate.scaled(vectors[0], offset.x))
  origin = cestate.add(origin, cestate.scaled(vectors[1], offset.y))
  origin.z = origin.z + offset.z
  radius = 200 + (cestate.random(state) & 31)
  duration = 0.0
  if flash >= 195 and flash <= 210 then radius = 300 + (cestate.random(state) & 100); duration = 200.0 end if
  light = cestate.addDLight(state, entityNumber, origin, radius * 1.0, monsterMuzzleColor(flash), duration, 0.0)
  light.minLight = 32.0
  if monsterMachineGun(flash) then cestate.particleEffect(state, origin, qt.zeroVec3(), 0, 40, 20.0) end if
  name = monsterMuzzleSound(flash)
  if name != "" then namedSound(state, void, entityNumber, 1, name, 1.0, 1.0, 0.0) end if
  return light
end function

function explosion(state, type, position)
  color = [1.0, 0.5, 0.5]
  model = "models/objects/r_explode/tris.md2"
  frames = 15
  alpha = 1.0
  light = 350.0; flags = rc.RF_FULLBRIGHT
  if type == ceconstants.TE_BFG_EXPLOSION then
    color = [0.0, 1.0, 0.0]; model = "sprites/s_bfg2.sp2"; frames = 4
    flags = flags | rc.RF_TRANSLUCENT
  end if
  if type == ceconstants.TE_BLASTER or type == ceconstants.TE_BLASTER2 or type == ceconstants.TE_FLECHETTE then
    model = "models/objects/explode/tris.md2"; frames = 4; light = 150.0
    flags = flags | rc.RF_TRANSLUCENT
    if type == ceconstants.TE_BLASTER then color = [1.0, 1.0, 0.0] end if
    if type == ceconstants.TE_BLASTER2 then color = [0.0, 1.0, 0.0] end if
    if type == ceconstants.TE_FLECHETTE then color = [0.19, 0.41, 0.75] end if
  end if
  value = cestate.addExplosion(state, type, position, model, frames, light, color, flags, alpha)
  if type != ceconstants.TE_BFG_EXPLOSION then cestate.particleEffect(state, position, qt.zeroVec3(), 0xe0, 64, 50.0) end if
  return value
end function

function parseBeam(state, buffer, modelName, withOffset, playerLinked)
  entity = pchecked.readShort(buffer, "beam entity")
  start = readPosition(buffer, "beam start")
  finish = readPosition(buffer, "beam end")
  offset = qt.zeroVec3()
  if withOffset then offset = readPosition(buffer, "beam offset") end if
  if playerLinked and not withOffset then offset = qt.Vec3(2.0, 7.0, -3.0) end if
  duration = 200
  if playerLinked then duration = 100 end if
  return cestate.addBeam(state, entity, 0, modelName, start, finish, offset, playerLinked, duration)
end function

function parseLightning(state, buffer)
  source = pchecked.readShort(buffer, "lightning source entity")
  destination = pchecked.readShort(buffer, "lightning destination entity")
  start = readPosition(buffer, "lightning start")
  finish = readPosition(buffer, "lightning end")
  beam = cestate.addBeam(state, source, destination, "models/proj/lightning/tris.md2", start, finish, qt.zeroVec3(), false, 200)
  namedSound(state, void, source, 1, "weapons/tesla.wav", 1.0, 1.0, 0.0)
  return beam
end function

function addTrail(state, start, finish, color, count)
  delta = qt.Vec3((finish.x - start.x) / count, (finish.y - start.y) / count, (finish.z - start.z) / count)
  position = cestate.copyVec(start)
  index = 0
  while index < count
    cestate.addParticle(state, position, qt.zeroVec3(), qt.zeroVec3(), color + (index & 7), 1.0, -1.0)
    position = cestate.add(position, delta)
    index = index + 1
  end while
  return count
end function

function parseSteam(state, buffer)
  id = pchecked.readShort(buffer, "steam id")
  count = pchecked.readByte(buffer, "steam count")
  position = readPosition(buffer, "steam origin")
  direction = readDirection(buffer, "steam direction")
  color = pchecked.readByte(buffer, "steam color")
  magnitude = pchecked.readShort(buffer, "steam magnitude")
  if id == -1 then return cestate.particleEffect(state, position, direction, color, count, magnitude * 1.0) end if
  duration = pchecked.readLong(buffer, "steam duration")
  sustain = cetypes.Sustain(id, ceconstants.TE_STEAM, position, direction, color, count, magnitude,
    state.time + duration, state.time, 100)
  if len(state.sustains) < ceconstants.MAX_SUSTAINS then state.sustains = state.sustains + [sustain] end if
  return sustain
end function

function parseTempEntity(state, buffer)
  type = pchecked.readByte(buffer, "temp entity type")
  if type < 0 or type > ceconstants.TE_FLECHETTE or type == ceconstants.TE_FLAME then return error(7336, "unsupported temp entity type " + type) end if

  if type == ceconstants.TE_PARASITE_ATTACK or type == ceconstants.TE_MEDIC_CABLE_ATTACK then return parseBeam(state, buffer, "models/monsters/parasite/segment/tris.md2", false, false) end if
  if type == ceconstants.TE_GRAPPLE_CABLE then return parseBeam(state, buffer, "models/ctf/segment/tris.md2", true, false) end if
  if type == ceconstants.TE_HEATBEAM then return parseBeam(state, buffer, "models/proj/beam/tris.md2", false, true) end if
  if type == ceconstants.TE_MONSTER_HEATBEAM then return parseBeam(state, buffer, "models/proj/beam/tris.md2", false, false) end if
  if type == ceconstants.TE_LIGHTNING then return parseLightning(state, buffer) end if
  if type == ceconstants.TE_STEAM then return parseSteam(state, buffer) end if

  if type == ceconstants.TE_BFG_LASER then
    start = readPosition(buffer, "laser start"); finish = readPosition(buffer, "laser end")
    return cestate.addLaser(state, start, finish, 0xd0)
  end if

  if type == ceconstants.TE_SPLASH then
    count = pchecked.readByte(buffer, "splash count")
    position = readPosition(buffer, "splash origin")
    direction = readDirection(buffer, "splash direction")
    splash = pchecked.readByte(buffer, "splash kind")
    colors = [0x00, 0xe0, 0xb0, 0x50, 0xd0, 0xe0, 0xe8]
    color = 0
    if splash < len(colors) then color = colors[splash] end if
    return cestate.particleEffect(state, position, direction, color, count, 35.0)
  end if

  if type == ceconstants.TE_LASER_SPARKS or type == ceconstants.TE_WELDING_SPARKS or type == ceconstants.TE_TUNNEL_SPARKS then
    count = pchecked.readByte(buffer, "spark count")
    position = readPosition(buffer, "spark origin")
    direction = readDirection(buffer, "spark direction")
    color = pchecked.readByte(buffer, "spark color")
    result = cestate.particleEffect(state, position, direction, color, count, 40.0)
    if type == ceconstants.TE_WELDING_SPARKS then cestate.addDLight(state, 0, position, 100.0, [1.0, 1.0, 0.3], 100.0, 0.0) end if
    return result
  end if

  if type == ceconstants.TE_FLASHLIGHT then
    position = readPosition(buffer, "flashlight origin")
    entity = pchecked.readShort(buffer, "flashlight entity")
    return cestate.addDLight(state, entity, position, 400.0, [1.0, 1.0, 1.0], 100.0, 0.0)
  end if

  if type == ceconstants.TE_WIDOWBEAMOUT then
    id = pchecked.readShort(buffer, "widow sustain id")
    position = readPosition(buffer, "widow sustain origin")
    sustain = cetypes.Sustain(id, type, position, qt.zeroVec3(), 0, 0, 0, state.time + 2100, state.time, 1)
    if len(state.sustains) < ceconstants.MAX_SUSTAINS then state.sustains = state.sustains + [sustain] end if
    return sustain
  end if
  if type == ceconstants.TE_NUKEBLAST then
    position = readPosition(buffer, "nuke origin")
    sustain = cetypes.Sustain(21000, type, position, qt.zeroVec3(), 0, 0, 0, state.time + 1000, state.time, 1)
    if len(state.sustains) < ceconstants.MAX_SUSTAINS then state.sustains = state.sustains + [sustain] end if
    return sustain
  end if

  if type == ceconstants.TE_FORCEWALL then
    start = readPosition(buffer, "forcewall start"); finish = readPosition(buffer, "forcewall end")
    color = pchecked.readByte(buffer, "forcewall color")
    return addTrail(state, start, finish, color, 16)
  end if

  if type == ceconstants.TE_RAILTRAIL or type == ceconstants.TE_RAILTRAIL2 or type == ceconstants.TE_DEBUGTRAIL or
      type == ceconstants.TE_BUBBLETRAIL or type == ceconstants.TE_BUBBLETRAIL2 then
    start = readPosition(buffer, "trail start"); finish = readPosition(buffer, "trail end")
    color = 0x74
    if type == ceconstants.TE_BUBBLETRAIL or type == ceconstants.TE_BUBBLETRAIL2 then color = 4 end if
    result = addTrail(state, start, finish, color, 16)
    if type == ceconstants.TE_RAILTRAIL or type == ceconstants.TE_RAILTRAIL2 then namedSound(state, finish, 0, 0, "weapons/railgf1a.wav", 1.0, 1.0, 0.0) end if
    return result
  end if

  if type == ceconstants.TE_BLUEHYPERBLASTER then
    position = readPosition(buffer, "blue blaster origin")
    directionAsPosition = readPosition(buffer, "blue blaster direction")
    return cestate.particleEffect(state, position, directionAsPosition, 0x74, 40, 30.0)
  end if

  directionTypes = [ceconstants.TE_GUNSHOT, ceconstants.TE_BLOOD, ceconstants.TE_BLASTER,
    ceconstants.TE_SHOTGUN, ceconstants.TE_SPARKS, ceconstants.TE_SCREEN_SPARKS,
    ceconstants.TE_SHIELD_SPARKS, ceconstants.TE_BULLET_SPARKS, ceconstants.TE_GREENBLOOD,
    ceconstants.TE_BLASTER2, ceconstants.TE_MOREBLOOD, ceconstants.TE_HEATBEAM_SPARKS,
    ceconstants.TE_HEATBEAM_STEAM, ceconstants.TE_ELECTRIC_SPARKS, ceconstants.TE_FLECHETTE]
  for each candidate in directionTypes
    if type == candidate then
      position = readPosition(buffer, "impact origin")
      direction = readDirection(buffer, "impact direction")
      count = 40; color = 0xe0
      if type == ceconstants.TE_BLOOD then count = 60; color = 0xe8 end if
      if type == ceconstants.TE_SHOTGUN then count = 20; color = 0 end if
      if type == ceconstants.TE_SPARKS then count = 6 end if
      if type == ceconstants.TE_MOREBLOOD then count = 250; color = 0xe8 end if
      if type == ceconstants.TE_GREENBLOOD then count = 30; color = 0xdf end if
      if type == ceconstants.TE_FLECHETTE then color = 0x6f end if
      result = cestate.particleEffect(state, position, direction, color, count, 45.0)
      if type == ceconstants.TE_BLASTER or type == ceconstants.TE_BLASTER2 or type == ceconstants.TE_FLECHETTE then explosion(state, type, position) end if
      return result
    end if
  end for

  if type == ceconstants.TE_CHAINFIST_SMOKE then
    position = readPosition(buffer, "chainfist smoke origin")
    return cestate.particleEffect(state, position, qt.Vec3(0.0, 0.0, 1.0), 0, 20, 20.0)
  end if

  position = readPosition(buffer, "temp entity origin")
  if type == ceconstants.TE_BFG_BIGEXPLOSION or type == ceconstants.TE_BOSSTPORT or
      type == ceconstants.TE_TELEPORT_EFFECT or type == ceconstants.TE_DBALL_GOAL or type == ceconstants.TE_WIDOWSPLASH then
    return cestate.particleEffect(state, position, qt.zeroVec3(), 0xd0, 128, 60.0)
  end if
  if type == ceconstants.TE_TRACKER_EXPLOSION then
    cestate.addDLight(state, 0, position, 150.0, [-1.0, -1.0, -1.0], 100.0, 0.0)
    return cestate.particleEffect(state, position, qt.zeroVec3(), 0, 64, 40.0)
  end if
  return explosion(state, type, position)
end function

function handleEntityEvent(state, entityState)
  if entityState is void or entityState.number < 1 or entityState.number >= pc.MAX_EDICTS then return error(7337, "entity event source outside protocol range") end if
  event = entityState.event
  position = entityOrigin(entityState)
  if event == ceconstants.EV_ITEM_RESPAWN then
    namedSound(state, void, entityState.number, 1, "items/respawn1.wav", 1.0, 2.0, 0.0)
    return cestate.particleEffect(state, position, qt.zeroVec3(), 0xd4, 64, 30.0)
  end if
  if event == ceconstants.EV_PLAYER_TELEPORT then
    namedSound(state, void, entityState.number, 1, "misc/tele1.wav", 1.0, 2.0, 0.0)
    return cestate.particleEffect(state, position, qt.zeroVec3(), 0xd0, 128, 50.0)
  end if
  if event == ceconstants.EV_FOOTSTEP then return namedSound(state, void, entityState.number, 4, "player/step1.wav", 1.0, 1.0, 0.0) end if
  if event == ceconstants.EV_FALLSHORT then return namedSound(state, void, entityState.number, 0, "player/land1.wav", 1.0, 1.0, 0.0) end if
  if event == ceconstants.EV_FALL then return namedSound(state, void, entityState.number, 0, "*fall2.wav", 1.0, 1.0, 0.0) end if
  if event == ceconstants.EV_FALLFAR then return namedSound(state, void, entityState.number, 0, "*fall1.wav", 1.0, 1.0, 0.0) end if
  return false
end function

function parseServiceCommand(state, buffer, opcode, entityResolver)
  if opcode == qc.SVC_SOUND then return parseSound(state, buffer) end if
  if opcode == qc.SVC_MUZZLEFLASH then return parseMuzzleFlash(state, buffer, entityResolver) end if
  if opcode == qc.SVC_MUZZLEFLASH2 then return parseMuzzleFlash2(state, buffer, entityResolver) end if
  if opcode == qc.SVC_TEMP_ENTITY then return parseTempEntity(state, buffer) end if
  return error(7338, "opcode is not a client effect service command")
end function
