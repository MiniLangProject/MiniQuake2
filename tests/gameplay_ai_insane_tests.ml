/* Deterministic Classic 3.19 misc_insane archetype and lifecycle goldens. */
import miniquake2.game.ai.archetypes as insanetestarchetypes
import miniquake2.game.ai.constants as insanetestconstants
import miniquake2.game.ai.insane as insanetestinsane
import miniquake2.game.ai.monster as insanetestmonster
import miniquake2.game.ai.reaction_sequences as insanetestreactions
import miniquake2.game.ai.types as insanetesttypes
import miniquake2.game.constants as insanetestgameconstants

insaneTestSounds = []

function insaneTestAssert(value, message)
  if value != true then return error(9827, message) end if
  return true
end function

function insaneTestEqual(actual, expected, message)
  if actual != expected then return error(9828, message + ": expected " + expected + ", got " + actual) end if
  return true
end function

function insaneTestSound(actor, soundName, channel, attenuation)
  global insaneTestSounds
  insaneTestSounds = insaneTestSounds + [soundName]
  insaneTestEqual(channel, insanetestgameconstants.CHAN_VOICE, "insane sound channel")
  insaneTestEqual(attenuation, insanetestgameconstants.ATTN_IDLE,
    "insane sound attenuation for " + soundName)
  return true
end function

function insaneTestContext()
  insaneContext = insanetesttypes.defaultContext()
  insaneContext.randomIdle = 0.0
  insaneContext.randomDelay = 0.0
  insaneContext.randomFrame = 3
  insaneContext.playSound = insaneTestSound
  return insaneContext
end function

insaneRegistry = insanetestarchetypes.defaultRegistry()
insaneTestAssert(insanetestarchetypes.validate(insaneRegistry), "campaign AI registry validates")
insaneTestEqual(len(insaneRegistry.entries), 22, "base monster registry remains duplicate-free")
insaneTestEqual(len(insaneRegistry.campaignEntries), 3, "campaign AI registry count")
insaneTestAssert(insanetestreactions.selectDeathPlan("misc_insane", 76, 1, true) is void,
  "misc_insane keeps its dedicated gib sequence")
insaneDefinition = insanetestarchetypes.find(insaneRegistry, "misc_insane")
insaneTestEqual(insaneDefinition.model, "models/monsters/insane/tris.md2", "Classic insane model")
insaneTestEqual(insaneDefinition.health, 100, "Classic insane health")
insaneTestEqual(insaneDefinition.gibHealth, -50, "Classic insane gib health")
insaneTestEqual(insaneDefinition.mass, 300, "Classic insane mass")

insaneContext = insaneTestContext()
insaneActor = insanetestarchetypes.SpawnMonster(insaneRegistry, "misc_insane", 70, insaneContext)
insaneTestAssert((insaneActor.info.aiFlags & insanetestconstants.AI_GOOD_GUY) != 0, "insane is a good-guy AI")
insaneTestEqual(insaneActor.info.currentMove.name, "insane-stand-normal", "deterministic normal stand")
insaneTestAssert(typeof(insaneActor.pain) == "function" and typeof(insaneActor.die) == "function", "insane pain/die callbacks")
insaneTestAssert(insaneActor.info.attack is void and insaneActor.info.melee is void, "insane has no combat attack")

insaneCrawlHold = insanetestarchetypes.SpawnMonster(insaneRegistry, "misc_insane", 71, insaneContext)
insaneCrawlHold.spawnFlags = insanetestconstants.INSANE_CRAWL | insanetestconstants.INSANE_STAND_GROUND
insanetestinsane.insaneStand(insaneCrawlHold, insaneContext)
insaneTestEqual(insaneCrawlHold.info.currentMove.name, "insane-down", "crawl plus hold-ground starts down")
insaneTestAssert((insaneCrawlHold.info.aiFlags & insanetestconstants.AI_STAND_GROUND) != 0, "hold-ground AI flag")
insanetestinsane.insaneWalk(insaneCrawlHold, insaneContext)
insaneTestEqual(insaneCrawlHold.info.currentMove.name, "insane-crawl", "crawl walk move")

insaneCrucified = insanetestarchetypes.SpawnMonster(insaneRegistry, "misc_insane", 72, insaneContext)
insaneCrucified.spawnFlags = insanetestconstants.INSANE_CRUCIFIED
insanetestinsane.insaneStand(insaneCrucified, insaneContext)
insaneTestEqual(insaneCrucified.info.currentMove.name, "insane-cross", "crucified cross move")
insaneTestAssert((insaneCrucified.info.aiFlags & insanetestconstants.AI_STAND_GROUND) != 0, "crucified stands ground")
insaneTestAssert((insaneCrucified.flags & insanetestconstants.FL_NO_KNOCKBACK) != 0 and
  (insaneCrucified.flags & insanetestconstants.FL_FLY) != 0, "crucified physical flags")
insaneTestAssert(insaneCrucified.edict.mins.x == -16.0 and insaneCrucified.edict.mins.y == 0.0 and
  insaneCrucified.edict.maxs.y == 8.0, "crucified bounds")

insaneAlwaysStand = insanetestarchetypes.SpawnMonster(insaneRegistry, "misc_insane", 73, insaneContext)
insaneAlwaysStand.spawnFlags = insanetestconstants.INSANE_ALWAYS_STAND
insanetestinsane.insaneStand(insaneAlwaysStand, insaneContext)
insaneAlwaysMove = insaneAlwaysStand.info.currentMove.name
insaneTestEqual(insanetestinsane.insaneCheckDown(insaneAlwaysStand, insaneContext), false, "always-stand blocks down transition")
insaneTestEqual(insaneAlwaysStand.info.currentMove.name, insaneAlwaysMove, "always-stand retains stand move")

insaneTestSounds = []
insanePainActor = insanetestarchetypes.SpawnMonster(insaneRegistry, "misc_insane", 74, insaneContext)
insanePainActor.health = 40
insanePainActor.edict.state.frame = 230
insaneContext.time = 10.0
insaneTestAssert(insanetestinsane.insanePain(insanePainActor, void, 10, insaneContext), "crawl pain dispatch")
insaneTestEqual(insanePainActor.info.currentMove.name, "insane-crawl-pain", "crawl pain frames")
insaneTestEqual(insaneTestSounds[0], "player/male/pain50_2.wav", "health-banded deterministic pain sound")
insaneTestEqual(insanetestinsane.insanePain(insanePainActor, void, 1, insaneContext), false, "three-second pain debounce")
insaneTestEqual(insanePainActor.painCount, 1, "pain callback count debounced")

insaneTestSounds = []
insaneDeathActor = insanetestarchetypes.SpawnMonster(insaneRegistry, "misc_insane", 75, insaneContext)
insaneDeathActor.health = 0
insaneDeathActor.edict.state.frame = 160
insaneTestAssert(insanetestmonster.DispatchDie(insaneDeathActor, void, 100, insaneContext), "standing death dispatch")
insaneTestEqual(insaneDeathActor.info.currentMove.name, "insane-stand-death", "standing death animation")
insaneTestAssert(insaneDeathActor.deathUseComplete, "death use completion gate")
insaneDeathActor.edict.state.frame = insaneDeathActor.info.currentMove.lastFrame
insanetestmonster.M_MoveFrame(insaneDeathActor, insaneContext)
insaneTestEqual(insaneDeathActor.activity, "insane-dead", "death move reaches corpse phase")
insaneTestEqual(insaneDeathActor.moveType, insanetestconstants.MOVETYPE_TOSS, "corpse toss movement")
insaneTestAssert(insaneDeathActor.edict.maxs.z == -8.0 and insaneDeathActor.nextThink == 0.0,
  "corpse bounds and think stop")
insaneTestAssert((insaneDeathActor.edict.serverFlags & insanetestgameconstants.SVF_DEADMONSTER) != 0,
  "corpse server flag")

insaneCrucified.health = 0
insaneTestAssert(insanetestmonster.DispatchDie(insaneCrucified, void, 100, insaneContext), "crucified death dispatch")
insaneTestEqual(insaneCrucified.activity, "insane-dead", "crucified becomes corpse immediately")
insaneTestAssert((insaneCrucified.flags & insanetestconstants.FL_FLY) != 0, "crucified corpse remains suspended")

insaneGibActor = insanetestarchetypes.SpawnMonster(insaneRegistry, "misc_insane", 76, insaneContext)
insaneGibActor.health = -60
insaneTestAssert(insanetestmonster.DispatchDie(insaneGibActor, void, 200, insaneContext), "gib death dispatch")
insaneTestEqual(insaneGibActor.activity, "insane-gibbed", "gib terminal phase")
insaneTestEqual(insaneTestSounds[len(insaneTestSounds) - 1], "misc/udeath.wav", "gib sound callback")

print("gameplay_ai_insane_tests: PASS")
