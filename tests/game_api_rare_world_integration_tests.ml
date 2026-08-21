/* Product-graph wiring for the remaining stock campaign world state machines. */
import miniquake2.game.base.spawn as rareintegrationbase
import miniquake2.game.integration.baseq2 as rareintegration
import miniquake2.game.world.constants as rareintegrationconstants
import miniquake2.game.world.core as rareintegrationworld

function requireTrue(value, label)
  if value != true then return error(9991, label) end if
end function

fixture = "{ \"classname\" \"worldspawn\" }\n" +
  "{ \"classname\" \"info_player_start\" \"origin\" \"0 0 0\" }\n" +
  "{ \"classname\" \"point_combat\" \"targetname\" \"combat\" }\n" +
  "{ \"classname\" \"target_actor\" \"targetname\" \"actor\" }\n" +
  "{ \"classname\" \"target_character\" \"model\" \"*1\" \"count\" \"1\" }\n" +
  "{ \"classname\" \"target_string\" \"targetname\" \"display\" \"message\" \"1\" }\n" +
  "{ \"classname\" \"trigger_key\" \"item\" \"key_data_cd\" \"target\" \"unlocked\" }\n" +
  "{ \"classname\" \"trigger_relay\" \"targetname\" \"unlocked\" }\n" +
  "{ \"classname\" \"func_clock\" \"target\" \"display\" \"count\" \"2\" \"spawnflags\" \"13\" }\n" +
  "{ \"classname\" \"func_train\" \"model\" \"*2\" \"targetname\" \"lift\" \"target\" \"corner\" }\n" +
  "{ \"classname\" \"path_corner\" \"targetname\" \"corner\" }\n" +
  "{ \"classname\" \"trigger_elevator\" \"target\" \"lift\" }"

spawned = rareintegrationbase.SpawnEntities("rare", fixture, "")
requireTrue(spawned.skippedEntityCount == 0, "rare integration fixture must not skip classes")
runtime = rareintegration.create(spawned)

combat = rareintegration.findWorldByClass(runtime, "point_combat")
actor = rareintegration.findWorldByClass(runtime, "target_actor")
character = rareintegration.findWorldByClass(runtime, "target_character")
display = rareintegration.findWorldByClass(runtime, "target_string")
key = rareintegration.findWorldByClass(runtime, "trigger_key")
clock = rareintegration.findWorldByClass(runtime, "func_clock")
elevator = rareintegration.findWorldByClass(runtime, "trigger_elevator")

requireTrue(combat is not void and combat.touch is not void, "point_combat touch wiring")
requireTrue(combat.solid == rareintegrationconstants.SOLID_TRIGGER, "point_combat trigger shape")
requireTrue(actor is not void and actor.touch is not void, "target_actor touch wiring")
requireTrue(character is not void and character.solid == rareintegrationconstants.SOLID_BSP, "target_character BSP wiring")
requireTrue(display is not void and display.use is not void, "target_string use wiring")
requireTrue(key is not void and key.use is not void and key.itemName == "Data CD", "trigger_key stock inventory wiring")
requireTrue(clock is not void and clock.use is not void, "func_clock start-off wiring")
requireTrue(elevator is not void and elevator.think is not void, "trigger_elevator deferred wiring")

raremeaning = rareintegrationworld.advance(runtime.world, runtime.world.frameTime)
requireTrue(raremeaning, "rare integration scheduler executes elevator initialization")
requireTrue(elevator.use is not void, "trigger_elevator resolves its train")

print "MiniQuake2 rare world integration tests passed: 2"
