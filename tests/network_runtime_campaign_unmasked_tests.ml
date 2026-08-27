/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Retail campaign probe which deliberately preserves the original signon error. */
import miniquake2.network.connectionless as nrcampaign_connectionless
import miniquake2.runtime.application as nrcampaign_application
import miniquake2.runtime.play_session as nrcampaign_play

// Run this source file's command-line entry point.
function main(args)
  if len(args) == 0 then
    print "network_runtime_campaign_unmasked_tests: SKIP (no retail root)"
    return 0
  end if
  if len(args) != 1 and len(args) != 2 then return error(8502, "expected Quake II install root and optional map count") end if
  count = 39
  if len(args) == 2 then
    count = nrcampaign_connectionless.parseDecimal(args[1])
  end if
  maps = nrcampaign_application.campaignMapNames()
  session = nrcampaign_play.createRetail(args[0], maps[0],
    "\\name\\CampaignUnmasked\\skin\\male/grunt\\rate\\25000")
  nrcampaign_play.runUntilActive(session, 512)
  nrcampaign_application.settleCampaignSession(session, 512)
  completed = 1
  while completed < count
    changed = nrcampaign_play.changeMapRetail(session, args[0], maps[completed])
    if not changed.changed or changed.deferred then
      return error(8503, "map transition did not commit: " + maps[completed])
    end if
    // Do not wrap this in try(): application.runCampaignSessionSmoke replaces
    // any parser/game/runtime failure with a generic signon timeout snapshot.
    nrcampaign_play.runUntilActive(session, 512)
    nrcampaign_application.settleCampaignSession(session, 512)
    completed = completed + 1
  end while
  nrcampaign_play.shutdown(session)
  print("network_runtime_campaign_unmasked_tests: PASS " + completed)
  return 0
end function
