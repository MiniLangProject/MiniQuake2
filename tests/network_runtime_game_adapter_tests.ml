/* Function-valued runtime adapter exercised against the managed Game API v3. */
import miniquake2.qcommon.types as qt
import miniquake2.game.constants as gc
import miniquake2.game.null_game as nullGame
import miniquake2.server.game_bridge as bridge
import miniquake2.network.runtime.game_adapter as rgame

function assertEqual(actual, expected, name)
  if actual != expected then return error(7995, name + ": expected " + expected + ", got " + actual) end if
  return true
end function

function assertTrue(value, name)
  if value != true then return error(7996, name + ": expected true") end if
  return true
end function

serverRuntime = bridge.createRuntime(2)
imports = bridge.makeImports(serverRuntime)
game = nullGame.GetGameApi(imports)
serverRuntime.game = game
assertEqual(game.apiVersion, gc.GAME_API_VERSION, "Game API version")
game.init()
callbacks = rgame.installGameExportWithCommands(game, serverRuntime.commands)
assertTrue(callbacks.clientConnect(0, "\\name\\Adapter"), "ClientConnect accepted")
assertTrue(callbacks.clientUserinfoChanged(0, "\\name\\Adapter2"), "userinfo callback")
assertTrue(callbacks.clientBegin(0), "begin callback")
command = qt.UserCmd(16, 1, [1, 2, 3], 100, 0, 0, 0, 10)
assertTrue(callbacks.clientThink(0, command), "think callback")
assertTrue(callbacks.clientCommand(0, "say adapter"), "command callback")
assertTrue(callbacks.clientPing(0, 73), "ping callback")
assertEqual(game.edicts[1].client.ping, 73, "Game API client ping synchronized")
assertEqual(imports.argc(), 2, "GameImport command argc")
assertEqual(imports.argv(0), "say", "GameImport command argv0")
assertEqual(imports.argv(1), "adapter", "GameImport command argv1")
assertEqual(imports.args(), "adapter", "GameImport command args")
snapshot = nullGame.lifecycleSnapshot()
assertEqual(snapshot[6], 1, "game command count")
game.clientDisconnect(game.edicts[1])
game.shutdown()
print "network_runtime_game_adapter_tests: PASS"
