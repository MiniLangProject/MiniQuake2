/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Campaign settle regression for queue-only reliable Netchan state. */
import miniquake2.qcommon.constants as rcsqueue_qc
import miniquake2.protocol.netchan as rcsqueue_netchan
import miniquake2.network.connectionless as rcsqueue_connectionless
import miniquake2.runtime.application as rcsqueue_application
import miniquake2.runtime.play_session as rcsqueue_play

function campaignQueueAssert(value, name)
  if not value then return error(9896, name) end if
  return true
end function

function nopPayload(count)
  output = bytes(count)
  index = 0
  while index < count
    output[index] = rcsqueue_qc.SVC_NOP
    index = index + 1
  end while
  return output
end function

function syntheticCampaignQueue()
  oldEntities = "{\n\"classname\" \"worldspawn\"\n}\n" +
    "{\n\"classname\" \"info_player_start\"\n\"origin\" \"0 0 24\"\n}\n"
  newEntities = "{\n\"classname\" \"worldspawn\"\n\"message\" \"queue-next\"\n}\n" +
    "{\n\"classname\" \"info_player_start\"\n\"origin\" \"64 0 24\"\n}\n"
  session = rcsqueue_play.createCore("queue-old", oldEntities, void,
    "\\name\\CampaignQueue\\rate\\25000")
  rcsqueue_play.runUntilActive(session, 256)
  rcsqueue_application.settleCampaignSession(session, 256)
  channel = session.server.networkRuntime.server.clients[0].channel

  // Both payloads are individually valid Protocol-34 command streams.  They
  // live only in reliableQueue: holding/message are intentionally empty.
  rcsqueue_netchan.queueReliableFragments(channel,
    [nopPayload(1000), nopPayload(1000)])
  campaignQueueAssert(channel.reliableLength == 0 and
    channel.message.curSize == 0 and channel.reliableQueuedBytes == 2000 and
    len(channel.reliableQueue) == 2,
    "queue-only reliable precondition was not constructed")
  drainedSteps = rcsqueue_application.settleCampaignSession(session, 256)
  campaignQueueAssert(drainedSteps > 0 and
    rcsqueue_netchan.pendingReliableBytes(channel) == 0,
    "campaign settler ignored or failed to ACK-drain reliableQueue")

  changed = rcsqueue_play.changeMapCore(session, "queue-new", newEntities, void)
  campaignQueueAssert(changed.changed and not changed.deferred,
    "synthetic campaign map transition did not commit")
  rcsqueue_play.runUntilActive(session, 256)
  rcsqueue_application.settleCampaignSession(session, 256)
  campaignQueueAssert(rcsqueue_play.signonComplete(session) and
    session.server.mapName == "queue-new" and
    rcsqueue_netchan.pendingReliableBytes(channel) == 0,
    "stale reliable tail crossed the synthetic map transition")
  rcsqueue_play.shutdown(session)
  return true
end function

function main(args)
  syntheticCampaignQueue()
  if len(args) == 1 or len(args) == 2 then
    mapCount = 8
    if len(args) == 2 then mapCount = rcsqueue_connectionless.parseDecimal(args[1]) end if
    result = rcsqueue_application.runCampaignSessionSmoke(args[0], mapCount)
    campaignQueueAssert(result[0] == mapCount and result[1] == mapCount - 1,
      "retail campaign session did not complete requested map count")
    print("runtime_campaign_session_reliable_queue_tests: PASS (synthetic + retail " +
      mapCount + "-map)")
  else
    if len(args) != 0 then return error(9897, "expected optional Quake II install root and map count") end if
    print("runtime_campaign_session_reliable_queue_tests: PASS (synthetic)")
  end if
  return 0
end function
