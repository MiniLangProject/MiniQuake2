/* Real two-client UDP deathmatch session: signon, kill, score, respawn, snapshots. */
import miniquake2.network.constants as mpdtestnetworkconstants
import miniquake2.qcommon.constants as mpdtestqconstants
import miniquake2.qcommon.types as mpdtestqtypes
import miniquake2.game.constants as mpdtestgameconstants
import miniquake2.game.player.constants as mpdtestplayerconstants
import miniquake2.game.gameplay.constants as mpdtestgameplayconstants
import miniquake2.game.null_game as mpdtestgameapi
import miniquake2.game.integration.baseq2 as mpdtestintegration
import miniquake2.game.weapons.projectiles as mpdtestprojectiles
import miniquake2.game.weapons.constants as mpdtestweaponconstants
import miniquake2.game.weapons.core as mpdtestweaponcore
import miniquake2.runtime.multiplayer_session as mpdtestsession

function mpdAssert(value, name)
  if not value then return error(8420, name) end if
  return true
end function

mpdEntities = "{\n\"classname\" \"worldspawn\"\n\"message\" \"Two Player Deathmatch\"\n}\n" +
  "{\n\"classname\" \"info_player_start\"\n\"origin\" \"0 0 24\"\n}\n" +
  "{\n\"classname\" \"info_player_deathmatch\"\n\"origin\" \"0 0 24\"\n}\n" +
  "{\n\"classname\" \"info_player_deathmatch\"\n\"origin\" \"128 0 24\"\n}\n" +
  "{\n\"classname\" \"info_player_deathmatch\"\n\"origin\" \"256 0 24\"\n}\n"

mpdSession = mpdtestsession.createCore(mpdtestsession.MODE_DEATHMATCH,
  "dm_two", mpdEntities, void,
  ["\\name\\Alpha\\skin\\male/grunt", "\\name\\Bravo\\skin\\female/athena"])
mpdActive = mpdtestsession.runUntilActive(mpdSession, 500)
mpdAssert(mpdActive.activeClients == 2, "both deathmatch clients did not become active")
mpdAssert(mpdActive.clientStates[0] == mpdtestnetworkconstants.CA_ACTIVE and
  mpdActive.clientStates[1] == mpdtestnetworkconstants.CA_ACTIVE,
  "deathmatch client state mismatch")
mpdAssert(mpdActive.serverStates[0] == mpdtestnetworkconstants.CS_SPAWNED and
  mpdActive.serverStates[1] == mpdtestnetworkconstants.CS_SPAWNED,
  "deathmatch server slot state mismatch")
mpdContext = mpdtestgameapi.playerContext()
mpdAssert(mpdContext.deathmatch and not mpdContext.cooperative,
  "deathmatch mode was not installed before spawn")
mpdSlot0 = mpdtestsession.serverSlot(mpdSession, 0)
mpdSlot1 = mpdtestsession.serverSlot(mpdSession, 1)
mpdAssert(mpdSlot0 >= 0 and mpdSlot1 >= 0 and mpdSlot0 != mpdSlot1,
  "clients did not own distinct server slots")
mpdPlayer0 = mpdtestsession.player(mpdSession, 0)
mpdPlayer1 = mpdtestsession.player(mpdSession, 1)
mpdAssert(mpdPlayer0.persistent.netName == "Alpha" and mpdPlayer1.persistent.netName == "Bravo",
  "deathmatch userinfo names did not reach live players")

// Void collision exposes every networked edict to both snapshot builders.
mpdtestsession.step(mpdSession)
mpdAssert(mpdtestsession.snapshotHasEntity(mpdSession, 0, mpdPlayer0.edict.state.number) and
  mpdtestsession.snapshotHasEntity(mpdSession, 0, mpdPlayer1.edict.state.number),
  "client zero snapshot cannot see both players")
mpdAssert(mpdtestsession.snapshotHasEntity(mpdSession, 1, mpdPlayer0.edict.state.number) and
  mpdtestsession.snapshotHasEntity(mpdSession, 1, mpdPlayer1.edict.state.number),
  "client one snapshot cannot see both players")

// Keep a slow probe alive for one complete server frame to prove that the
// managed projectile owns a real engine edict and reaches both snapshots.
mpdProbeRuntime = mpdtestgameapi.baseRuntime()
mpdProbeShooter = mpdtestintegration.playerWeaponTarget(mpdPlayer0,
  mpdtestgameapi.playerContext().registry)
mpdProbeStart = mpdtestqtypes.Vec3(mpdPlayer0.edict.state.origin.x,
  mpdPlayer0.edict.state.origin.y, mpdPlayer0.edict.state.origin.z + 16.0)
mpdProbe = mpdtestprojectiles.fireBlaster(mpdProbeRuntime.weaponContext,
  mpdProbeShooter, mpdProbeStart, mpdtestqtypes.Vec3(1.0, 0.0, 0.0),
  15, 100.0, mpdtestweaponconstants.EF_BLASTER, false)
mpdtestsession.step(mpdSession)
mpdAssert(mpdProbe.engineNumber >= 0 and
  mpdtestsession.snapshotHasEntity(mpdSession, 0, mpdProbe.engineNumber) and
  mpdtestsession.snapshotHasEntity(mpdSession, 1, mpdProbe.engineNumber),
  "live Blaster projectile was absent from two-client snapshots")
mpdAssert(mpdProbe.modelIndex > 0 and mpdProbe.soundIndex > 0 and
  mpdSession.server.gameExport.edicts[mpdProbe.engineNumber].state.modelIndex ==
    mpdProbe.modelIndex,
  "live Blaster projectile did not publish its model/sound indexes")
mpdAssert(mpdSession.clients[0].integrated.network.configStrings[
    mpdtestqconstants.CS_MODELS + mpdProbe.modelIndex] == mpdProbe.modelName and
  mpdSession.clients[1].integrated.network.configStrings[
    mpdtestqconstants.CS_MODELS + mpdProbe.modelIndex] == mpdProbe.modelName and
  mpdSession.clients[0].integrated.network.configStrings[
    mpdtestqconstants.CS_SOUNDS + mpdProbe.soundIndex] == mpdProbe.soundName and
  mpdSession.clients[1].integrated.network.configStrings[
    mpdtestqconstants.CS_SOUNDS + mpdProbe.soundIndex] == mpdProbe.soundName,
  "live Blaster model/sound configstrings did not reach both clients")
mpdtestweaponcore.freeProjectile(mpdProbeRuntime.weaponContext, mpdProbe)

// Let initial blaster activation finish, then establish an unobstructed
// duel.  prepareDuel changes only pose/aim; combat remains on
// the normal UDP UserCmd and managed projectile path.
mpdReadySteps = 0
while mpdPlayer0.gameplay.weaponState != mpdtestgameplayconstants.WEAPON_READY and mpdReadySteps < 16
  mpdtestsession.step(mpdSession)
  mpdReadySteps = mpdReadySteps + 1
end while
mpdAssert(mpdPlayer0.gameplay.weaponState == mpdtestgameplayconstants.WEAPON_READY,
  "attacker blaster did not become ready")
mpdAssert(mpdtestsession.prepareDuel(mpdSession, 0, 1, 96),
  "deterministic duel setup failed")
mpdAssert(mpdPlayer1.health == 100,
  "duel helper changed victim health")
mpdFireCount = mpdPlayer0.gameplay.fireCount
mpdShots = 0
while mpdPlayer1.deadFlag == mpdtestplayerconstants.DEAD_NO and mpdShots < 7
  mpdCycleSteps = 0
  while mpdPlayer0.gameplay.weaponState != mpdtestgameplayconstants.WEAPON_READY and mpdCycleSteps < 16
    mpdtestsession.step(mpdSession)
    mpdCycleSteps = mpdCycleSteps + 1
  end while
  mpdAssert(mpdPlayer0.gameplay.weaponState == mpdtestgameplayconstants.WEAPON_READY,
    "blaster did not return to ready between shots")
  mpdShotAttack = mpdtestqtypes.UserCmd(100, mpdtestgameconstants.BUTTON_ATTACK,
    [0, 0, 0], 0, 0, 0, 0, 64)
  mpdtestsession.queueUserCmd(mpdSession, 0, mpdShotAttack)
  mpdShotFireCount = mpdPlayer0.gameplay.fireCount
  mpdShotSteps = 0
  while mpdPlayer0.gameplay.fireCount == mpdShotFireCount and mpdShotSteps < 8
    mpdtestsession.step(mpdSession)
    mpdShotSteps = mpdShotSteps + 1
  end while
  mpdAssert(mpdPlayer0.gameplay.fireCount == mpdShotFireCount + 1,
    "queued BUTTON_ATTACK did not reach the blaster fire frame")
  mpdShots = mpdShots + 1
end while
mpdAssert(mpdShots == 7 and mpdPlayer0.gameplay.fireCount == mpdFireCount + 7,
  "full-health kill did not require seven blaster attacks")
mpdAssert(mpdPlayer1.deadFlag != mpdtestplayerconstants.DEAD_NO and mpdPlayer1.health <= 0,
  "blaster projectile did not kill live victim")
mpdSawWeaponDamage = false
for each mpdWeaponEvent in mpdtestgameapi.baseRuntime().weaponContext.events
  if mpdWeaponEvent[1] == "damage" and mpdWeaponEvent[2] == mpdPlayer1.edict.state.number and
      mpdWeaponEvent[3][1] == mpdtestgameplayconstants.MOD_BLASTER then
    mpdSawWeaponDamage = true
  end if
end for
mpdAssert(mpdSawWeaponDamage,
  "weapon event history did not record blaster damage to victim")
mpdSawMuzzleLight = [false, false]
mpdSawMuzzleSound = [false, false]
mpdSawDamageParticles = [false, false]
mpdClientIndex = 0
while mpdClientIndex < 2
  // Integrated dispatch drains transient sounds into bounded, atomic frame
  // handoffs. Inspect that renderer/audio-ready boundary rather than the
  // already-drained mutable effect queue.
  for each mpdWeaponHandoff in mpdSession.clients[mpdClientIndex].integrated.frameHandoffs
    for each mpdLight in mpdWeaponHandoff.dLights
      if mpdLight.key == mpdPlayer0.edict.state.number then mpdSawMuzzleLight[mpdClientIndex] = true end if
    end for
    for each mpdSound in mpdWeaponHandoff.sounds
      if mpdSound.entity == mpdPlayer0.edict.state.number and mpdSound.soundName == "weapons/blastf1a.wav" then
        mpdSawMuzzleSound[mpdClientIndex] = true
      end if
    end for
    if len(mpdWeaponHandoff.particles) > 0 then mpdSawDamageParticles[mpdClientIndex] = true end if
  end for
  mpdClientIndex = mpdClientIndex + 1
end while
mpdAssert(mpdSawMuzzleLight[0] and mpdSawMuzzleLight[1] and
  mpdSawMuzzleSound[0] and mpdSawMuzzleSound[1],
  "player svc_muzzleflash did not reach both-client effect state")
mpdAssert(mpdSawDamageParticles[0] and mpdSawDamageParticles[1],
  "blaster damage blood feedback did not reach both clients")
mpdAssert(mpdPlayer1.obituary == "Bravo was blasted by Alpha.", "deathmatch obituary mismatch")
mpdAssert(mpdPlayer0.respawn.score == 1 and mpdPlayer1.respawn.score == 0,
  "deathmatch score mismatch")
mpdAssert(mpdtestsession.snapshotHasEntity(mpdSession, 0, mpdPlayer1.edict.state.number) and
  mpdtestsession.snapshotHasEntity(mpdSession, 1, mpdPlayer0.edict.state.number),
  "death frame did not preserve two-client snapshot visibility")
mpdServerChannel0 = mpdSession.server.networkRuntime.server.clients[mpdSlot0].channel
mpdServerChannel1 = mpdSession.server.networkRuntime.server.clients[mpdSlot1].channel
mpdAssert(mpdServerChannel0.incomingAcknowledged > 0 and mpdServerChannel1.incomingAcknowledged > 0 and
  mpdSession.clients[0].integrated.network.client.channel.incomingAcknowledged > 0 and
  mpdSession.clients[1].integrated.network.client.channel.incomingAcknowledged > 0,
  "two-client netchannels did not advance bidirectional acknowledgements")
mpdAssert(mpdSession.server.networkRuntime.server.clients[mpdSlot0].score == 1,
  "server status score was not synchronized")
mpdAssert(mpdPlayer1.deadFlag != mpdtestplayerconstants.DEAD_NO and mpdPlayer1.showScores,
  "victim did not enter death/scoreboard state")

mpdWait = 0
while mpdWait < 12
  mpdtestsession.step(mpdSession)
  mpdWait = mpdWait + 1
end while
mpdRespawnAttack = mpdtestqtypes.UserCmd(100, mpdtestgameconstants.BUTTON_ATTACK,
  [0, 0, 0], 0, 0, 0, 0, 64)
mpdtestsession.queueUserCmd(mpdSession, 1, mpdRespawnAttack)
mpdAssert(mpdContext.time > mpdPlayer1.respawnTime,
  "deathmatch clock did not pass respawn time")
mpdRespawnSteps = 0
while mpdPlayer1.deadFlag != mpdtestplayerconstants.DEAD_NO and mpdRespawnSteps < 20
  mpdtestsession.step(mpdSession)
  mpdRespawnSteps = mpdRespawnSteps + 1
end while
mpdAssert(mpdPlayer1.deadFlag == mpdtestplayerconstants.DEAD_NO and mpdPlayer1.health == 100,
  "attack command did not respawn victim")
mpdAssert(mpdContext.dmFlags == 0,
  "respawn unexpectedly depended on a deathmatch force flag")
mpdAssert(mpdtestsession.snapshotHasEntity(mpdSession, 0, mpdPlayer1.edict.state.number),
  "respawned player was not visible in attacker snapshot")
mpdFinal = mpdtestsession.result(mpdSession)
mpdAssert(mpdFinal.packetsRejected == 0 and mpdActive.packetsReceived > 0 and mpdActive.packetsSent > 0,
  "deathmatch UDP transport counters mismatch")
mpdAssert(mpdtestsession.shutdown(mpdSession), "deathmatch shutdown failed")
mpdAssert(not mpdtestsession.shutdown(mpdSession), "deathmatch shutdown was not idempotent")
print("runtime_multiplayer_deathmatch_tests: PASS")
