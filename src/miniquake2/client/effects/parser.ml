/* Strict Protocol-34 sound, event, muzzleflash and temp-entity dispatch. */
package miniquake2.client.effects.parser

import std.math as cemath
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
import miniquake2.qcommon.monster_flash_offsets as ceflash

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
  if weapon == ceconstants.MZ_CHAINGUN1 then return [1.0, 0.25, 0.0] end if
  if weapon == ceconstants.MZ_CHAINGUN2 then return [1.0, 0.5, 0.0] end if
  if weapon == ceconstants.MZ_BLUEHYPERBLASTER or weapon == ceconstants.MZ_NUKE4 then return [0.0, 0.0, 1.0] end if
  if weapon == ceconstants.MZ_BFG or weapon == ceconstants.MZ_BLASTER2 then return [0.0, 1.0, 0.0] end if
  if weapon == ceconstants.MZ_TRACKER then return [-1.0, -1.0, -1.0] end if
  if weapon == ceconstants.MZ_RAILGUN then return [0.5, 0.5, 1.0] end if
  if weapon == ceconstants.MZ_ROCKET then return [1.0, 0.5, 0.2] end if
  if weapon == ceconstants.MZ_GRENADE then return [1.0, 0.5, 0.0] end if
  if weapon == ceconstants.MZ_ETF_RIFLE then return [0.9, 0.7, 0.0] end if
  if weapon == ceconstants.MZ_IONRIPPER or weapon == ceconstants.MZ_PHALANX then return [1.0, 0.5, 0.5] end if
  if weapon == ceconstants.MZ_LOGIN then return [0.0, 1.0, 0.0] end if
  if weapon == ceconstants.MZ_LOGOUT or weapon == ceconstants.MZ_NUKE1 then return [1.0, 0.0, 0.0] end if
  if weapon == ceconstants.MZ_NUKE2 then return [1.0, 1.0, 0.0] end if
  if weapon == ceconstants.MZ_NUKE8 then return [0.0, 1.0, 1.0] end if
  if weapon == ceconstants.MZ_BLASTER or weapon == ceconstants.MZ_MACHINEGUN or
      weapon == ceconstants.MZ_SHOTGUN or weapon == ceconstants.MZ_CHAINGUN3 or
      weapon == ceconstants.MZ_SSHOTGUN or weapon == ceconstants.MZ_HYPERBLASTER or
      weapon == ceconstants.MZ_SHOTGUN2 or weapon == ceconstants.MZ_HEATBEAM or
      weapon == ceconstants.MZ_RESPAWN then return [1.0, 1.0, 0.0] end if
  return [0.0, 0.0, 0.0]
end function

function machineGunSound(state)
  variant = cestate.random(state) % 5
  if variant == 1 then return "weapons/machgf2b.wav" end if
  if variant == 2 then return "weapons/machgf3b.wav" end if
  if variant == 3 then return "weapons/machgf4b.wav" end if
  if variant == 4 then return "weapons/machgf5b.wav" end if
  return "weapons/machgf1b.wav"
end function

function emitPlayerMuzzleSounds(state, entityNumber, weapon, volume)
  if weapon == ceconstants.MZ_MACHINEGUN or weapon == ceconstants.MZ_CHAINGUN1 or
      weapon == ceconstants.MZ_CHAINGUN2 or weapon == ceconstants.MZ_CHAINGUN3 then
    namedSound(state, void, entityNumber, 1, machineGunSound(state), volume, 1.0, 0.0)
    if weapon == ceconstants.MZ_CHAINGUN2 then
      namedSound(state, void, entityNumber, 1, machineGunSound(state), volume, 1.0, 0.05)
    end if
    if weapon == ceconstants.MZ_CHAINGUN3 then
      namedSound(state, void, entityNumber, 1, machineGunSound(state), volume, 1.0, 0.033)
      namedSound(state, void, entityNumber, 1, machineGunSound(state), volume, 1.0, 0.066)
    end if
    return true
  end if
  name = playerMuzzleSound(weapon)
  soundVolume = volume
  if weapon == ceconstants.MZ_LOGIN or weapon == ceconstants.MZ_LOGOUT or weapon == ceconstants.MZ_RESPAWN then soundVolume = 1.0 end if
  if name != "" then namedSound(state, void, entityNumber, 1, name, soundVolume, 1.0, 0.0) end if
  if weapon == ceconstants.MZ_SHOTGUN then
    namedSound(state, void, entityNumber, 0, "weapons/shotgr1b.wav", volume, 1.0, 0.1)
  end if
  if weapon == ceconstants.MZ_ROCKET then
    namedSound(state, void, entityNumber, 0, "weapons/rocklr1b.wav", volume, 1.0, 0.1)
  end if
  if weapon == ceconstants.MZ_GRENADE then
    namedSound(state, void, entityNumber, 0, "weapons/grenlr1b.wav", volume, 1.0, 0.1)
  end if
  return name != ""
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
  radius = 200 + (cestate.random(state) & 31)
  volume = 1.0
  if silenced then radius = 100 + (radius - 200); volume = 0.2 end if
  if weapon == ceconstants.MZ_CHAINGUN1 then radius = 200 + (cestate.random(state) & 31) end if
  if weapon == ceconstants.MZ_CHAINGUN2 then radius = 225 + (cestate.random(state) & 31) end if
  if weapon == ceconstants.MZ_CHAINGUN3 then radius = 250 + (cestate.random(state) & 31) end if
  duration = 0.0
  // Preserve the original cl_fx.c millisecond clock literals exactly. The
  // 3.19 source uses +0.1 for the longer chaingun flashes and +1.0 for the
  // login/logout/respawn flash (not seconds).
  if weapon == ceconstants.MZ_CHAINGUN2 or
      weapon == ceconstants.MZ_CHAINGUN3 then duration = 0.1 end if
  if weapon == ceconstants.MZ_LOGIN or weapon == ceconstants.MZ_LOGOUT or
      weapon == ceconstants.MZ_RESPAWN then duration = 1.0 end if
  if weapon == ceconstants.MZ_HEATBEAM or (weapon >= ceconstants.MZ_NUKE1 and weapon <= ceconstants.MZ_NUKE8) then duration = 100.0 end if
  light = cestate.addDLight(state, entityNumber, origin, radius * 1.0,
    playerMuzzleColor(weapon), duration, 0.0)
  light.minLight = 32.0
  emitPlayerMuzzleSounds(state, entityNumber, weapon, volume)
  if weapon == ceconstants.MZ_LOGIN or weapon == ceconstants.MZ_LOGOUT or weapon == ceconstants.MZ_RESPAWN then
    color = 0xe0
    if weapon == ceconstants.MZ_LOGIN then color = 0xd0 end if
    if weapon == ceconstants.MZ_LOGOUT then color = 0x40 end if
    cestate.logoutParticles(state, entityOrigin(entityState), color)
  end if
  return light
end function

function inline soldierMachineGun(flash)
  return flash == 43 or flash == 44 or (flash >= 85 and flash <= 100 and (flash - 85) % 3 == 0)
end function

function inline soldierShotgun(flash)
  return flash == 41 or flash == 42 or (flash >= 84 and flash <= 99 and (flash - 84) % 3 == 0)
end function

function inline soldierBlaster(flash)
  return flash == 39 or flash == 40 or (flash >= 83 and flash <= 98 and (flash - 83) % 3 == 0)
end function

function inline monsterMachineGun(flash)
  return (flash >= 4 and flash <= 22) or (flash >= 26 and flash <= 38) or
    soldierMachineGun(flash) or (flash >= 45 and flash <= 52) or flash == 63 or
    (flash >= 64 and flash <= 69) or (flash >= 73 and flash <= 77) or
    (flash >= 120 and flash <= 131) or (flash >= 133 and flash <= 139) or
    flash == 141 or flash == 152 or flash == 153
end function

function inline monsterRocket(flash)
  return (flash >= 23 and flash <= 25) or flash == 57 or
    (flash >= 70 and flash <= 72) or (flash >= 78 and flash <= 81) or
    flash == 142 or flash == 191
end function

function inline monsterRail(flash)
  return flash == 61 or flash == 147 or flash == 150
end function

function inline monsterGreenBlaster(flash)
  return (flash >= 144 and flash <= 146) or flash == 149 or (flash >= 156 and flash <= 190)
end function

function inline monsterPlasmaBeam(flash)
  return flash == 151 or (flash >= 195 and flash <= 210)
end function

function monsterMuzzleColor(flash)
  if monsterRocket(flash) then return [1.0, 0.5, 0.2] end if
  if flash >= 53 and flash <= 56 or flash == 140 then return [1.0, 0.5, 0.0] end if
  if monsterRail(flash) then return [0.5, 0.5, 1.0] end if
  if flash == 101 or flash == 132 then return [0.5, 1.0, 0.5] end if
  if flash == 148 then return [-1.0, -1.0, -1.0] end if
  if monsterGreenBlaster(flash) then return [0.0, 1.0, 0.0] end if
  yellow = monsterMachineGun(flash) or soldierShotgun(flash) or soldierBlaster(flash) or
    (flash >= 1 and flash <= 3) or (flash >= 58 and flash <= 60) or flash == 62 or
    flash == 82 or (flash >= 102 and flash <= 118) or flash == 143 or monsterPlasmaBeam(flash)
  if yellow then return [1.0, 1.0, 0.0] end if
  return [0.0, 0.0, 0.0]
end function

function tankMachineGunSound(state)
  variant = cestate.random(state) % 5
  if variant == 1 then return "tank/tnkatk2b.wav" end if
  if variant == 2 then return "tank/tnkatk2c.wav" end if
  if variant == 3 then return "tank/tnkatk2d.wav" end if
  if variant == 4 then return "tank/tnkatk2e.wav" end if
  return "tank/tnkatk2a.wav"
end function

function monsterMuzzleSound(state, flash)
  if flash >= 1 and flash <= 3 then return "tank/tnkatck3.wav" end if
  if flash >= 4 and flash <= 22 then return tankMachineGunSound(state) end if
  if flash >= 23 and flash <= 25 then return "tank/tnkatck1.wav" end if
  if flash >= 26 and flash <= 38 then return "infantry/infatck1.wav" end if
  if soldierBlaster(flash) or flash == 143 then return "soldier/solatck2.wav" end if
  if soldierShotgun(flash) then return "soldier/solatck1.wav" end if
  if soldierMachineGun(flash) then return "soldier/solatck3.wav" end if
  if flash >= 45 and flash <= 52 then return "gunner/gunatck2.wav" end if
  if flash >= 53 and flash <= 56 or flash == 140 then return "gunner/gunatck3.wav" end if
  if flash == 57 or flash == 142 then return "chick/chkatck2.wav" end if
  if flash == 58 or flash == 59 then return "flyer/flyatck3.wav" end if
  if flash == 60 then return "medic/medatck1.wav" end if
  if flash == 62 then return "hover/hovatck1.wav" end if
  if flash == 63 or (flash >= 64 and flash <= 69) or flash == 141 then return "infantry/infatck1.wav" end if
  if (flash >= 70 and flash <= 72) or (flash >= 78 and flash <= 81) or flash == 191 then return "tank/rocket.wav" end if
  if flash >= 73 and flash <= 77 or flash == 138 or flash == 152 then return "infantry/infatck1.wav" end if
  if flash == 82 then return "floater/fltatck1.wav" end if
  if flash >= 102 and flash <= 118 then return "makron/blaster.wav" end if
  if flash >= 120 and flash <= 125 then return "boss3/xfire.wav" end if
  if monsterGreenBlaster(flash) then return "tank/tnkatck3.wav" end if
  if flash == 148 then return "weapons/disint2.wav" end if
  return ""
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
  if monsterPlasmaBeam(flash) then radius = 300 + (cestate.random(state) & 100); duration = 200.0 end if
  light = cestate.addDLight(state, entityNumber, origin, radius * 1.0, monsterMuzzleColor(flash), duration, 0.0)
  light.minLight = 32.0
  if monsterMachineGun(flash) then
    cestate.wallParticles(state, origin, qt.zeroVec3(), 0, 40)
    smokeAndFlash(state, origin)
  else if soldierShotgun(flash) then
    smokeAndFlash(state, origin)
  end if
  name = monsterMuzzleSound(state, flash)
  attenuation = 1.0
  if flash >= 73 and flash <= 77 or flash == 138 or flash == 152 then attenuation = 0.0 end if
  if name != "" then namedSound(state, void, entityNumber, 1, name, 1.0, attenuation, 0.0) end if
  return light
end function

function smokeAndFlash(state, position)
  cestate.addExplosionExact(state, "misc", position, qt.zeroVec3(),
    "models/objects/smoke/tris.md2", 4, 0.0, [0.0, 0.0, 0.0], state.time - 100,
    0, rc.RF_TRANSLUCENT, 1.0, 0)
  return cestate.addExplosionExact(state, "flash", position, qt.zeroVec3(),
    "models/objects/flash/tris.md2", 2, 0.0, [0.0, 0.0, 0.0], state.time - 100,
    0, rc.RF_FULLBRIGHT, 1.0, 0)
end function

function impactAngles(direction)
  horizontal = cemath.sqrt(direction.x * direction.x + direction.y * direction.y)
  pitch = cemath.atan2(horizontal, direction.z) * 57.29577951308232
  yaw = 0.0
  if direction.x != 0.0 then
    yaw = cemath.atan2(direction.y, direction.x) * 57.29577951308232
  else if direction.y > 0.0 then
    yaw = 90.0
  else if direction.y < 0.0 then
    yaw = 270.0
  end if
  return qt.Vec3(pitch, yaw, 0.0)
end function

function blasterExplosion(state, type, position, direction)
  color = [1.0, 1.0, 0.0]; skinNum = 0
  if type == ceconstants.TE_BLASTER2 then color = [0.0, 1.0, 0.0]; skinNum = 1 end if
  if type == ceconstants.TE_FLECHETTE then color = [0.19, 0.41, 0.75]; skinNum = 2 end if
  value = cestate.addExplosionExact(state, type, position, impactAngles(direction),
    "models/objects/explode/tris.md2", 4, 150.0, color, state.time - 100,
    0, rc.RF_FULLBRIGHT | rc.RF_TRANSLUCENT, 1.0, skinNum)
  namedSound(state, position, 0, 0, "weapons/lashit.wav", 1.0, 1.0, 0.0)
  return value
end function

function polyExplosion(state, type, position)
  angles = qt.Vec3(0.0, (cestate.random(state) % 360) * 1.0, 0.0)
  frames = 15; baseFrame = 0; model = "models/objects/r_explode/tris.md2"
  particles = true; sound = "weapons/rocklx1a.wav"
  if type == ceconstants.TE_EXPLOSION2 or type == ceconstants.TE_GRENADE_EXPLOSION or
      type == ceconstants.TE_GRENADE_EXPLOSION_WATER then
    frames = 19; baseFrame = 30; sound = "weapons/grenlx1a.wav"
  else
    if cestate.random(state) < 16384 then baseFrame = 15 end if
  end if
  if type == ceconstants.TE_EXPLOSION1_BIG then
    model = "models/objects/r_explode2/tris.md2"; particles = false
  end if
  if type == ceconstants.TE_EXPLOSION1_NP or type == ceconstants.TE_PLAIN_EXPLOSION then particles = false end if
  if type == ceconstants.TE_ROCKET_EXPLOSION_WATER or type == ceconstants.TE_GRENADE_EXPLOSION_WATER then
    sound = "weapons/xpld_wat.wav"
  end if
  value = cestate.addExplosionExact(state, type, position, angles, model, frames,
    350.0, [1.0, 0.5, 0.5], state.time - 100, baseFrame, rc.RF_FULLBRIGHT, 1.0, 0)
  if particles then cestate.explosionParticles(state, position, 0xe0, 8, 256, 384) end if
  namedSound(state, position, 0, 0, sound, 1.0, 1.0, 0.0)
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

function inline splashColor(splash)
  if splash == 1 then return 0xe0 end if
  if splash == 2 then return 0xb0 end if
  if splash == 3 then return 0x50 end if
  if splash == 4 then return 0xd0 end if
  if splash == 5 then return 0xe0 end if
  if splash == 6 then return 0xe8 end if
  return 0
end function

function parseSteam(state, buffer)
  id = pchecked.readShort(buffer, "steam id")
  count = pchecked.readByte(buffer, "steam count")
  position = readPosition(buffer, "steam origin")
  direction = readDirection(buffer, "steam direction")
  color = pchecked.readByte(buffer, "steam color")
  magnitude = pchecked.readShort(buffer, "steam magnitude")
  if id == -1 then return cestate.steamParticles(state, position, direction, color, count, magnitude * 1.0, false) end if
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
  if type == ceconstants.TE_MONSTER_HEATBEAM then return parseBeam(state, buffer, "models/proj/widowbeam/tris.md2", false, false) end if
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
    color = splashColor(splash)
    result = cestate.wallParticles(state, position, direction, color, count)
    if splash == 1 then
      spark = cestate.random(state) & 3
      sound = "world/spark7.wav"
      if spark == 0 then sound = "world/spark5.wav" end if
      if spark == 1 then sound = "world/spark6.wav" end if
      namedSound(state, position, 0, 0, sound, 1.0, 3.0, 0.0)
    end if
    return result
  end if

  if type == ceconstants.TE_LASER_SPARKS or type == ceconstants.TE_WELDING_SPARKS or type == ceconstants.TE_TUNNEL_SPARKS then
    count = pchecked.readByte(buffer, "spark count")
    position = readPosition(buffer, "spark origin")
    direction = readDirection(buffer, "spark direction")
    color = pchecked.readByte(buffer, "spark color")
    result = 0
    if type == ceconstants.TE_TUNNEL_SPARKS then
      result = cestate.fixedColorParticles(state, position, direction, color, count, true)
    else
      result = cestate.fixedColorParticles(state, position, direction, color, count, false)
    end if
    if type == ceconstants.TE_WELDING_SPARKS then
      cestate.addExplosionExact(state, "flash", position, qt.zeroVec3(),
        "models/objects/flash/tris.md2", 2, 100.0 + (cestate.random(state) % 75),
        [1.0, 1.0, 0.3], state.time, 0, rc.RF_BEAM, 1.0, 0)
    end if
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
    return cestate.forceWallParticles(state, start, finish, color)
  end if

  if type == ceconstants.TE_RAILTRAIL or type == ceconstants.TE_RAILTRAIL2 or type == ceconstants.TE_DEBUGTRAIL or
      type == ceconstants.TE_BUBBLETRAIL or type == ceconstants.TE_BUBBLETRAIL2 then
    start = readPosition(buffer, "trail start"); finish = readPosition(buffer, "trail end")
    result = 0
    if type == ceconstants.TE_RAILTRAIL or type == ceconstants.TE_RAILTRAIL2 then result = cestate.railTrail(state, start, finish) end if
    if type == ceconstants.TE_DEBUGTRAIL then result = cestate.debugTrail(state, start, finish) end if
    if type == ceconstants.TE_BUBBLETRAIL then result = cestate.bubbleTrail(state, start, finish, 32, 6.0) end if
    if type == ceconstants.TE_BUBBLETRAIL2 then result = cestate.bubbleTrail(state, start, finish, 8, 20.0) end if
    if type == ceconstants.TE_RAILTRAIL or type == ceconstants.TE_RAILTRAIL2 then namedSound(state, finish, 0, 0, "weapons/railgf1a.wav", 1.0, 1.0, 0.0) end if
    if type == ceconstants.TE_BUBBLETRAIL2 then namedSound(state, start, 0, 0, "weapons/lashit.wav", 1.0, 1.0, 0.0) end if
    return result
  end if

  if type == ceconstants.TE_BLUEHYPERBLASTER then
    position = readPosition(buffer, "blue blaster origin")
    directionAsPosition = readPosition(buffer, "blue blaster direction")
    return cestate.blasterParticles(state, position, directionAsPosition, 0xe0)
  end if

  directionType = type == ceconstants.TE_GUNSHOT or type == ceconstants.TE_BLOOD or
    type == ceconstants.TE_BLASTER or type == ceconstants.TE_SHOTGUN or
    type == ceconstants.TE_SPARKS or type == ceconstants.TE_SCREEN_SPARKS or
    type == ceconstants.TE_SHIELD_SPARKS or type == ceconstants.TE_BULLET_SPARKS or
    type == ceconstants.TE_GREENBLOOD or type == ceconstants.TE_BLASTER2 or
    type == ceconstants.TE_MOREBLOOD or type == ceconstants.TE_HEATBEAM_SPARKS or
    type == ceconstants.TE_HEATBEAM_STEAM or type == ceconstants.TE_ELECTRIC_SPARKS or
    type == ceconstants.TE_FLECHETTE
  if directionType then
    position = readPosition(buffer, "impact origin")
    direction = readDirection(buffer, "impact direction")
    count = 40; color = 0xe0; speed = 45.0
    if type == ceconstants.TE_GUNSHOT then color = 0 end if
    if type == ceconstants.TE_BLOOD then count = 60; color = 0xe8 end if
    if type == ceconstants.TE_SHOTGUN then count = 20; color = 0 end if
    if type == ceconstants.TE_SPARKS or type == ceconstants.TE_BULLET_SPARKS then count = 6 end if
    if type == ceconstants.TE_SCREEN_SPARKS then color = 0xd0 end if
    if type == ceconstants.TE_SHIELD_SPARKS then color = 0xb0 end if
    if type == ceconstants.TE_MOREBLOOD then count = 250; color = 0xe8 end if
    if type == ceconstants.TE_GREENBLOOD then count = 30; color = 0xdf end if
    if type == ceconstants.TE_BLASTER2 then color = 0xd0 end if
    if type == ceconstants.TE_FLECHETTE then color = 0x6f end if
    if type == ceconstants.TE_HEATBEAM_SPARKS then count = 50; color = 8; speed = 60.0 end if
    if type == ceconstants.TE_HEATBEAM_STEAM then count = 20; color = 0xe0; speed = 60.0 end if
    if type == ceconstants.TE_ELECTRIC_SPARKS then color = 0x75 end if
    result = 0
    blasterType = type == ceconstants.TE_BLASTER or type == ceconstants.TE_BLASTER2 or
      type == ceconstants.TE_FLECHETTE
    fixedColorType = type == ceconstants.TE_GREENBLOOD
    steamType = type == ceconstants.TE_HEATBEAM_SPARKS or type == ceconstants.TE_HEATBEAM_STEAM
    if blasterType then
      result = cestate.blasterParticles(state, position, direction, color)
    else if fixedColorType then
      result = cestate.fixedColorParticles(state, position, direction, color, count, false)
    else if steamType then
      result = cestate.steamParticles(state, position, direction, color, count, speed, false)
    else
      result = cestate.wallParticles(state, position, direction, color, count)
    end if
    if type == ceconstants.TE_GUNSHOT or type == ceconstants.TE_BULLET_SPARKS then
      smokeAndFlash(state, position)
      ricochet = cestate.random(state) & 15
      if ricochet == 1 then namedSound(state, position, 0, 0, "world/ric1.wav", 1.0, 1.0, 0.0) end if
      if ricochet == 2 then namedSound(state, position, 0, 0, "world/ric2.wav", 1.0, 1.0, 0.0) end if
      if ricochet == 3 then namedSound(state, position, 0, 0, "world/ric3.wav", 1.0, 1.0, 0.0) end if
    end if
    if type == ceconstants.TE_SHOTGUN then smokeAndFlash(state, position) end if
    if type == ceconstants.TE_SCREEN_SPARKS or type == ceconstants.TE_SHIELD_SPARKS or
        type == ceconstants.TE_HEATBEAM_SPARKS or type == ceconstants.TE_HEATBEAM_STEAM or
        type == ceconstants.TE_ELECTRIC_SPARKS then
      namedSound(state, position, 0, 0, "weapons/lashit.wav", 1.0, 1.0, 0.0)
    end if
    if type == ceconstants.TE_BLASTER or type == ceconstants.TE_BLASTER2 or
        type == ceconstants.TE_FLECHETTE then blasterExplosion(state, type, position, direction) end if
    return result
  end if

  if type == ceconstants.TE_CHAINFIST_SMOKE then
    position = readPosition(buffer, "chainfist smoke origin")
    return cestate.steamParticles(state, position, qt.Vec3(0.0, 0.0, 1.0), 0, 20, 20.0, true)
  end if

  position = readPosition(buffer, "temp entity origin")
  if type == ceconstants.TE_BFG_BIGEXPLOSION then
    return cestate.explosionParticles(state, position, 0xd0, 8, 256, 384)
  end if
  if type == ceconstants.TE_BOSSTPORT then
    result = cestate.bigTeleportParticles(state, position)
    namedSound(state, position, 0, 0, "misc/bigtele.wav", 1.0, 0.0, 0.0)
    return result
  end if
  if type == ceconstants.TE_TELEPORT_EFFECT or type == ceconstants.TE_DBALL_GOAL then
    return cestate.teleportParticles(state, position)
  end if
  if type == ceconstants.TE_WIDOWSPLASH then
    return cestate.widowSplashParticles(state, position)
  end if
  if type == ceconstants.TE_TRACKER_EXPLOSION then
    cestate.addDLight(state, 0, position, 150.0, [-1.0, -1.0, -1.0], 100.0, 0.0)
    result = cestate.explosionParticles(state, position, 0, 1, 128, 256)
    namedSound(state, position, 0, 0, "weapons/disrupthit.wav", 1.0, 1.0, 0.0)
    return result
  end if
  if type == ceconstants.TE_BFG_EXPLOSION then
    return cestate.addExplosionExact(state, type, position, qt.zeroVec3(),
      "sprites/s_bfg2.sp2", 4, 350.0, [0.0, 1.0, 0.0], state.time - 100,
      0, rc.RF_FULLBRIGHT | rc.RF_TRANSLUCENT, 0.30, 0)
  end if
  return polyExplosion(state, type, position)
end function

function handleEntityEvent(state, entityState)
  if entityState is void or entityState.number < 1 or entityState.number >= pc.MAX_EDICTS then return error(7337, "entity event source outside protocol range") end if
  event = entityState.event
  position = entityOrigin(entityState)
  if event == ceconstants.EV_ITEM_RESPAWN then
    namedSound(state, void, entityState.number, 1, "items/respawn1.wav", 1.0, 2.0, 0.0)
    return cestate.itemRespawnParticles(state, position)
  end if
  if event == ceconstants.EV_PLAYER_TELEPORT then
    namedSound(state, void, entityState.number, 1, "misc/tele1.wav", 1.0, 2.0, 0.0)
    return cestate.teleportParticles(state, position)
  end if
  if event == ceconstants.EV_FOOTSTEP then
    step = 1 + (cestate.random(state) & 3)
    sound = "player/step1.wav"
    if step == 2 then sound = "player/step2.wav" end if
    if step == 3 then sound = "player/step3.wav" end if
    if step == 4 then sound = "player/step4.wav" end if
    return namedSound(state, void, entityState.number, 4, sound, 1.0, 1.0, 0.0)
  end if
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
