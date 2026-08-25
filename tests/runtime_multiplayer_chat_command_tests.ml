/* Original g_cmds.c global/team/fallback chat and flood protection over UDP. */
import miniquake2.game.constants as mccgameconstants
import miniquake2.game.null_game as mccgame
import miniquake2.qcommon.cvar as mcccvar
import miniquake2.runtime.client_session as mccclient
import miniquake2.runtime.multiplayer_session as mccsession
import miniquake2.platform.system as mccsystem

function mccAssert(value, name)
  if not value then return error(8471, name) end if
  return true
end function

function mccSend(session, clientIndex, text)
  before = mccgame.lifecycleSnapshot()[6]
  mccAssert(mccclient.sendStringCommand(session.clients[clientIndex], text, 0),
    "failed to send chat command")
  steps = 0
  while mccgame.lifecycleSnapshot()[6] == before and steps < 32
    mccsession.step(session)
    steps = steps + 1
  end while
  mccAssert(mccgame.lifecycleSnapshot()[6] == before + 1,
    "chat ClientCommand timeout")
  return true
end function

function mccSawPrint(session, clientIndex, text)
  for each value in session.clients[clientIndex].integrated.prints
    if value.text == text then return true end if
  end for
  for each handoff in session.clients[clientIndex].integrated.frameHandoffs
    for each value in handoff.prints
      if value.text == text then return true end if
    end for
  end for
  return false
end function

function mccWaitForPrint(session, clientIndex, text)
  steps = 0
  while not mccSawPrint(session, clientIndex, text) and steps < 512
    mccsession.step(session)
    steps = steps + 1
    if not mccSawPrint(session, clientIndex, text) then mccsystem.sleep(1) end if
  end while
  return mccSawPrint(session, clientIndex, text)
end function

function mccWaitReliableIdle(session)
  steps = 0
  idle = false
  while not idle and steps < 150
    idle = len(session.server.bridgeRuntime.pendingUnicasts) == 0
    index = 0
    while index < len(session.server.networkRuntime.server.clients)
      channel = session.server.networkRuntime.server.clients[index].channel
      if channel is not void and
          (channel.reliableLength > 0 or len(channel.reliableQueue) > 0 or
          channel.message.curSize > 0) then
        idle = false
      end if
      index = index + 1
    end while
    if not idle then
      mccsession.step(session)
      mccsystem.sleep(10)
      steps = steps + 1
    end if
  end while
  return idle
end function

function mccLogCount(session, text)
  count = 0
  for each entry in session.server.bridgeRuntime.logs
    if entry[0] == "client:3" and entry[1] == text then count = count + 1 end if
  end for
  return count
end function

entities = "{ \"classname\" \"worldspawn\" }\n" +
  "{ \"classname\" \"info_player_deathmatch\" \"origin\" \"0 0 64\" }\n" +
  "{ \"classname\" \"info_player_deathmatch\" \"origin\" \"128 0 64\" }\n" +
  "{ \"classname\" \"info_player_deathmatch\" \"origin\" \"256 0 64\" }\n"
session = mccsession.createCore(mccsession.MODE_DEATHMATCH, "chat_audit",
  entities, void, ["\\name\\Alpha\\skin\\male/grunt",
    "\\name\\Bravo\\skin\\male/athena",
    "\\name\\Charlie\\skin\\female/athena"])
mccsession.runUntilActive(session, 500)
context = mccgame.playerContext()

mccSend(session, 0, "say global audit")
index = 0
while index < 3
  mccAssert(mccWaitForPrint(session, index, "Alpha: global audit\n"),
    "global chat recipient " + index)
  index = index + 1
end while
mccAssert(mccWaitReliableIdle(session), "global chat reliable ack timeout")

context.dmFlags = mccgameconstants.DF_MODELTEAMS
mccSend(session, 0, "say_team model audit")
mccAssert(mccLogCount(session, "(Alpha): model audit\n") == 2,
  "model-team chat recipient filter")

// Unknown commands retain the original arg0 chat fallback.
mccSend(session, 1, "hello fallback")
mccAssert(mccLogCount(session, "Bravo: hello fallback\n") == 3,
  "unknown command chat fallback recipients")

// Four messages are allowed inside four seconds; the fifth locks the sender.
alpha = mccsession.player(session, 0)
alpha.floodWhen = array(10, 0.0)
alpha.floodWhenHead = 0
alpha.floodLockTill = 0.0
mcccvar.forceSet(session.server.bridgeRuntime.cvars,
  "flood_persecond", "1000")
context.dmFlags = 0
floodIndex = 0
while floodIndex < 5
  mccSend(session, 0, "say flood" + floodIndex)
  floodIndex = floodIndex + 1
end while
mccAssert(alpha.floodLockTill > context.time,
  "fifth fast message did not engage flood lock")
mccAssert(mccLogCount(session,
  "Flood protection:  You can't talk for 10 seconds.\n") == 1,
  "flood warning was not returned to sender")
mccAssert(mccLogCount(session, "Alpha: flood4\n") == 0,
  "flooded message reached another client")

mccAssert(mccsession.shutdown(session), "chat session shutdown")
print "runtime_multiplayer_chat_command_tests: PASS"
