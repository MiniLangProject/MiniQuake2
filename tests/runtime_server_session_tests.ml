/* Asset-free dedicated-session lifecycle over a real ephemeral UDP socket. */
import miniquake2.runtime.server_session as tsession

function assertEqual(actual, expected, name)
  if actual != expected then return error(9980, name + ": values differ") end if
  return true
end function

function assertTrue(value, name)
  if value != true then return error(9981, name + ": expected true") end if
  return true
end function

function main(args)
  print "MiniQuake2 dedicated session tests starting: 1"
  text = "{ \"classname\" \"worldspawn\" } " +
    "{ \"classname\" \"info_player_start\" \"origin\" \"0 0 24\" } " +
    "{ \"classname\" \"monster_soldier\" \"origin\" \"64 0 24\" }"
  session = tsession.createCore("synthetic", text, void, "127.0.0.1", 0, 2, true)
  assertTrue(session.socket.port > 0, "ephemeral UDP binding")
  assertEqual(tsession.run(session, 2), 2, "fixed-step run")
  assertEqual(session.frameNumber, 2, "server frame count")
  assertEqual(session.gameExport.numEdicts, 5, "client-slot-aware map edicts")
  assertEqual(session.gameExport.edicts[4].state.number, 4, "monster edict mapping")
  assertTrue(tsession.shutdown(session), "first shutdown")
  assertEqual(tsession.shutdown(session), false, "idempotent shutdown")
  print "MiniQuake2 dedicated session tests passed: 1"
  return 0
end function
