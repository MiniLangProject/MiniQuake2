/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Focused stock g_combat.c and p_weapon.c damage/sound parity checks. */
import miniquake2.game.null_game as damageSoundGame
import miniquake2.game.integration.baseq2 as damageSoundIntegration
import miniquake2.game.gameplay.constants as damageSoundConstants
import miniquake2.game.gameplay.types as damageSoundTypes
import miniquake2.game.gameplay.item_rules as damageSoundItems
import miniquake2.game.weapons.core as damageSoundWeaponCore
import miniquake2.game.constants as damageSoundGameConstants
import miniquake2.qcommon.types as damageSoundQTypes
import miniquake2.server.game_bridge as damageSoundBridge

// Assert damage/sound parity.
function damageSoundAssert(value, message)
  if value != true then return error(9978, message) end if
  return true
end function

// Configure one integrated weapon fire-frame fixture.
function configureDamageSoundWeapon(player, registry, frame)
  item = damageSoundItems.findByClassName(registry, "weapon_blaster")
  if item is void then return error(9979, "missing Blaster item") end if
  player.gameplay.currentWeapon = item
  player.gameplay.newWeapon = void
  player.gameplay.weaponState = damageSoundConstants.WEAPON_FIRING
  player.gameplay.gunFrame = frame
  player.gameplay.edict.client.playerState.gunFrame = frame
  player.gameplay.buttons = damageSoundGameConstants.BUTTON_ATTACK
  player.gameplay.latchedButtons = 0
  player.buttons = damageSoundGameConstants.BUTTON_ATTACK
  player.latchedButtons = 0
  player.gameplay.ammoIndex = 0
  return item
end function

server = damageSoundBridge.createRuntime(4)
api = damageSoundGame.GetGameApi(damageSoundBridge.makeImports(server))
server.game = api
api.init()
fixture = "{\"classname\" \"worldspawn\"}" +
  "{\"classname\" \"info_player_start\" \"origin\" \"0 0 0\" \"angle\" \"0\"}" +
  "{\"classname\" \"monster_soldier\" \"origin\" \"80 0 10\" \"angle\" \"180\"}"
api.spawnEntities("damage-sound-parity", fixture, "")
client = api.edicts[1]
damageSoundAssert(api.clientConnect(client,
  "\\name\\DamageSoundRanger\\skin\\male/grunt"), "client connect")
damageSoundAssert(api.clientBegin(client), "client begin")
api.runFrame()

runtime = damageSoundGame.baseRuntime()
context = damageSoundGame.playerContext()
registry = context.registry
player = context.players[0]

// Quad's damage3 cue is emitted on declared fire frames only.
player.powerups.quadFrame = context.frameNumber + 100
configureDamageSoundWeapon(player, registry, 6)
quadSounds = server.pendingSoundCount
damageSoundIntegration.thinkPlayerWeapon(player, context)
damageSoundAssert(server.pendingSoundCount == quadSounds,
  "Quad cue emitted on a non-fire animation frame")
configureDamageSoundWeapon(player, registry, 5)
damageSoundIntegration.integratedPlayerFire(player.gameplay, registry)
damageSoundAssert(server.pendingSoundCount == quadSounds + 1 and
  server.soundNames[server.pendingSounds[quadSounds].soundIndex] ==
    "items/damage3.wav", "Quad cue missing from declared fire frame")
player.powerups.quadFrame = context.frameNumber
configureDamageSoundWeapon(player, registry, 5)
damageSoundIntegration.integratedPlayerFire(player.gameplay, registry)
damageSoundAssert(server.pendingSoundCount == quadSounds + 1,
  "expired Quad emitted a fire-frame cue")
player.gameplay.quadFrame = 0

// Invulnerability shares the original two-second pain sound debounce.
player.health = 100
player.powerups.invincibleFrame = context.frameNumber + 100
invulnerabilityTime = context.time
player.view.painDebounceTime = invulnerabilityTime - 0.1
invulnerabilitySounds = server.pendingSoundCount
invulnerabilityRequest = damageSoundTypes.damageRequest(
  [1.0, 0.0, 0.0], [64.0, 0.0, 24.0], 20, 0, 0,
  damageSoundConstants.MOD_BLASTER)
invulnerabilityRequest.currentFrame = context.frameNumber
invulnerabilityTarget = damageSoundIntegration.playerWeaponTarget(player,
  registry)
invulnerabilityResult = damageSoundIntegration.integratedWeaponDamage(
  invulnerabilityTarget.combatant, invulnerabilityRequest)
damageSoundAssert(invulnerabilityResult.taken == 0 and
  invulnerabilityResult.protectedDamage == 20 and
  server.pendingSoundCount == invulnerabilitySounds + 1 and
  server.soundNames[
    server.pendingSounds[invulnerabilitySounds].soundIndex] ==
    "items/protect4.wav", "first invulnerability hit sound/protection")

invulnerabilityTarget = damageSoundIntegration.playerWeaponTarget(player,
  registry)
damageSoundIntegration.integratedWeaponDamage(invulnerabilityTarget.combatant,
  invulnerabilityRequest)
damageSoundAssert(server.pendingSoundCount == invulnerabilitySounds + 1,
  "invulnerability sound ignored its pain debounce")

context.time = invulnerabilityTime + 2.1
invulnerabilityTarget = damageSoundIntegration.playerWeaponTarget(player,
  registry)
damageSoundIntegration.integratedWeaponDamage(invulnerabilityTarget.combatant,
  invulnerabilityRequest)
damageSoundAssert(server.pendingSoundCount == invulnerabilitySounds + 2 and
  server.soundNames[
    server.pendingSounds[invulnerabilitySounds + 1].soundIndex] ==
    "items/protect4.wav", "invulnerability sound did not resume after debounce")

noProtectionRequest = damageSoundTypes.damageRequest(
  [1.0, 0.0, 0.0], [64.0, 0.0, 24.0], 20, 0,
  damageSoundConstants.DAMAGE_NO_PROTECTION,
  damageSoundConstants.MOD_BLASTER)
noProtectionRequest.currentFrame = context.frameNumber
noProtectionTarget = damageSoundIntegration.playerWeaponTarget(player, registry)
noProtectionResult = damageSoundIntegration.integratedWeaponDamage(
  noProtectionTarget.combatant, noProtectionRequest)
damageSoundAssert(noProtectionResult.taken == 20 and
  server.pendingSoundCount == invulnerabilitySounds + 2,
  "DAMAGE_NO_PROTECTION incorrectly emitted/protected invulnerability hit")

// Direct client damage doubles only against a living, unaware monster.
damageSoundAssert(len(runtime.aiPlayers) > 0, "integrated player AI target")
monster = runtime.monsters[0]
attacker = damageSoundIntegration.playerWeaponTarget(player, registry)
monster.health = 100
monster.enemy = void
monsterTarget = damageSoundIntegration.monsterWeaponTarget(monster)
damageSoundWeaponCore.applyDamage(runtime.weaponContext, monsterTarget,
  attacker, attacker, damageSoundQTypes.Vec3(1.0, 0.0, 0.0),
  damageSoundQTypes.Vec3(80.0, 0.0, 10.0), 10, 0, 0,
  damageSoundConstants.MOD_BLASTER)
damageSoundAssert(monster.health == 80,
  "unaware monster did not receive doubled direct damage")

monster.enemy = runtime.aiPlayers[0]
monsterTarget = damageSoundIntegration.monsterWeaponTarget(monster)
damageSoundWeaponCore.applyDamage(runtime.weaponContext, monsterTarget,
  attacker, attacker, damageSoundQTypes.Vec3(1.0, 0.0, 0.0),
  damageSoundQTypes.Vec3(80.0, 0.0, 10.0), 10, 0, 0,
  damageSoundConstants.MOD_BLASTER)
damageSoundAssert(monster.health == 70,
  "aware monster received doubled direct damage")

monster.enemy = void
monsterTarget = damageSoundIntegration.monsterWeaponTarget(monster)
damageSoundWeaponCore.applyDamage(runtime.weaponContext, monsterTarget,
  attacker, attacker, damageSoundQTypes.Vec3(1.0, 0.0, 0.0),
  damageSoundQTypes.Vec3(80.0, 0.0, 10.0), 10, 0,
  damageSoundConstants.DAMAGE_RADIUS, damageSoundConstants.MOD_BLASTER)
damageSoundAssert(monster.health == 60,
  "radius damage incorrectly received surprise bonus")

api.clientDisconnect(client)
api.shutdown()
print "gameplay_damage_sound_parity_tests: PASS"
