/* Asset-free contract for the product retail-session rotation matrix. */
import miniquake2.runtime.application as rcampaignapp
import miniquake2.qcommon.text as rcampaigntext

function campaignAssert(value, message)
  if not value then return error(9925, message) end if
  return true
end function

maps = rcampaignapp.campaignMapNames()
campaignAssert(len(maps) == 39, "classic single-player map count")
campaignAssert(maps[0] == "base1" and maps[len(maps) - 1] == "waste3",
  "campaign matrix boundary names")
outer = 0
while outer < len(maps)
  campaignAssert(len(bytes(maps[outer])) > 0, "empty campaign map name")
  campaignAssert(not rcampaigntext.startsWith(maps[outer], "q2dm"),
    "deathmatch map leaked into campaign matrix")
  inner = outer + 1
  while inner < len(maps)
    campaignAssert(maps[outer] != maps[inner], "duplicate campaign map name")
    inner = inner + 1
  end while
  outer = outer + 1
end while

print "runtime_campaign_matrix_tests: PASS"
