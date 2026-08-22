/* Explicit $spawnpoint propagation through server and PlaySession factories. */
import miniquake2.game.null_game as spawnpointtestgame
import miniquake2.runtime.play_session as spawnpointtestplay

function spawnPointAssert(value, name)
  if not value then return error(8397, name) end if
  return true
end function

spawnPointEntities = "{\"classname\" \"worldspawn\"}" +
  "{\"classname\" \"info_player_start\" \"origin\" \"0 0 24\"}" +
  "{\"classname\" \"info_player_start\" \"targetname\" \"secret\" \"origin\" \"128 16 24\"}"
spawnPointSession = spawnpointtestplay.createCoreAt("spawnpoint", spawnPointEntities,
  void, "secret", "\\name\\SpawnPoint\\skin\\male/grunt")
spawnpointtestplay.runUntilActive(spawnPointSession, 500)
spawnPointPlayer = spawnpointtestgame.playerContext().players[0]
spawnPointAssert(spawnPointSession.server.bridgeRuntime.commands is not void and
  spawnPointPlayer.edict.state.origin.x == 128.0 and
  spawnPointPlayer.edict.state.origin.y == 16.0,
  "named spawn point did not reach PutClientInServer")
spawnpointtestplay.shutdown(spawnPointSession)
print("runtime_session_spawnpoint_tests: PASS")
