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
  "{ \"classname\" \"trigger_elevator\" \"target\" \"lift\" }\n" +
  "{ \"classname\" \"light\" \"targetname\" \"ramp-light\" \"style\" \"32\" }\n" +
  "{ \"classname\" \"target_lightramp\" \"target\" \"ramp-light\" \"message\" \"az\" \"speed\" \"1\" }\n" +
  "{ \"classname\" \"func_killbox\" \"model\" \"*3\" }\n" +
  "{ \"classname\" \"info_notnull\" \"origin\" \"8 16 24\" \"targetname\" \"marker\" }\n" +
  "{ \"classname\" \"misc_viper\" \"target\" \"flight\" }\n" +
  "{ \"classname\" \"path_corner\" \"targetname\" \"flight\" }\n" +
  "{ \"classname\" \"misc_viper_bomb\" }\n" +
  "{ \"classname\" \"misc_satellite_dish\" }\n" +
  "{ \"classname\" \"misc_blackhole\" }\n" +
  "{ \"classname\" \"misc_eastertank\" }\n" +
  "{ \"classname\" \"misc_easterchick\" }\n" +
  "{ \"classname\" \"misc_easterchick2\" }\n" +
  "{ \"classname\" \"light_mine2\" }"

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
lightRamp = rareintegration.findWorldByClass(runtime, "target_lightramp")
killBox = rareintegration.findWorldByClass(runtime, "func_killbox")
marker = rareintegration.findWorldByClass(runtime, "info_notnull")
viper = rareintegration.findWorldByClass(runtime, "misc_viper")
bomb = rareintegration.findWorldByClass(runtime, "misc_viper_bomb")
dish = rareintegration.findWorldByClass(runtime, "misc_satellite_dish")
blackHole = rareintegration.findWorldByClass(runtime, "misc_blackhole")
easterTank = rareintegration.findWorldByClass(runtime, "misc_eastertank")
easterChick = rareintegration.findWorldByClass(runtime, "misc_easterchick")
easterChick2 = rareintegration.findWorldByClass(runtime, "misc_easterchick2")
mineLight = rareintegration.findWorldByClass(runtime, "light_mine2")

requireTrue(combat is not void and combat.touch is not void, "point_combat touch wiring")
requireTrue(combat.solid == rareintegrationconstants.SOLID_TRIGGER, "point_combat trigger shape")
requireTrue(actor is not void and actor.touch is not void, "target_actor touch wiring")
requireTrue(character is not void and character.solid == rareintegrationconstants.SOLID_BSP, "target_character BSP wiring")
requireTrue(display is not void and display.use is not void, "target_string use wiring")
requireTrue(key is not void and key.use is not void and key.itemName == "Data CD", "trigger_key stock inventory wiring")
requireTrue(clock is not void and clock.use is not void, "func_clock start-off wiring")
requireTrue(elevator is not void and elevator.think is not void, "trigger_elevator deferred wiring")
requireTrue(lightRamp is not void and lightRamp.use is not void, "target_lightramp use wiring")
requireTrue(killBox is not void and killBox.use is not void, "func_killbox use wiring")
requireTrue(marker is not void and marker.absoluteMins.x == 8.0 and marker.absoluteMaxs.z == 24.0, "info_notnull positional wiring")
requireTrue(viper is not void and viper.use is not void and viper.model == "models/ships/viper/tris.md2", "misc_viper train wiring")
requireTrue(bomb is not void and bomb.use is not void and bomb.damage == 1000, "misc_viper_bomb wiring")
requireTrue(dish is not void and dish.use is not void, "satellite dish use wiring")
requireTrue(blackHole is not void and blackHole.think is not void, "black hole animation wiring")
requireTrue(easterTank is not void and easterTank.frame == 254, "easter tank model wiring")
requireTrue(easterChick is not void and easterChick.frame == 208, "easter chick model wiring")
requireTrue(easterChick2 is not void and easterChick2.frame == 248, "easter chick2 model wiring")
requireTrue(mineLight is not void and mineLight.model == "models/objects/minelite/light2/tris.md2", "mine light model wiring")

raremeaning = rareintegrationworld.advance(runtime.world, runtime.world.frameTime)
requireTrue(raremeaning, "rare integration scheduler executes elevator initialization")
requireTrue(elevator.use is not void, "trigger_elevator resolves its train")

print "MiniQuake2 rare world integration tests passed: 2"
