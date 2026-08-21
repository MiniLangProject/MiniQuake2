/* Optional read-only Classic Steam campaign spawn smoke.
   Run with the Quake II install root; the normal asset-free test invocation
   deliberately skips retail access. */
import miniquake2.qcommon.filesystem as retfilesystem
import miniquake2.format.bsp as retbsp
import miniquake2.game.base.spawn as retspawn

function retailSmoke(root)
  maps = [
    "base1", "base2", "base3", "biggun", "boss1", "boss2", "bunk1", "city1", "city2", "city3",
    "command", "cool1", "fact1", "fact2", "fact3", "hangar1", "hangar2", "jail1", "jail2", "jail3",
    "jail4", "jail5", "lab", "mine1", "mine2", "mine3", "mine4", "mintro", "power1", "power2",
    "q2dm1", "q2dm2", "q2dm3", "q2dm4", "q2dm5", "q2dm6", "q2dm7", "q2dm8", "security", "space",
    "strike", "train", "ware1", "ware2", "waste1", "waste2", "waste3",
  ]
  filesystem = retfilesystem.initialize(root, "")
  totalRaw = 0
  totalLive = 0
  maxLive = 0
  maxMap = ""
  for each mapName in maps
    path = "maps/" + mapName + ".bsp"
    map = retbsp.parse(retfilesystem.readFile(filesystem, path), path)
    result = retspawn.SpawnEntities(mapName, map.entityText, "")
    if result.skippedEntityCount != 0 then return error(9890, mapName + ": skipped campaign entities " + result.skippedEntityCount) end if
    if len(result.edicts) + 4 > 1024 then return error(9891, mapName + ": live edicts exceed protocol maximum") end if
    totalRaw = totalRaw + result.sourceEntityCount
    totalLive = totalLive + len(result.edicts)
    if len(result.edicts) > maxLive then maxLive = len(result.edicts); maxMap = mapName end if
  end for
  if totalRaw != 36404 then return error(9892, "retail raw entity aggregate changed") end if
  print "baseq2_campaign_retail_smoke_tests: PASS"
  print "  maps=" + len(maps) + " raw=" + totalRaw + " live=" + totalLive + " skipped=0"
  print "  max-live=" + maxLive + " map=" + maxMap
  return true
end function

function main(args)
  if len(args) == 0 then
    print "baseq2_campaign_retail_smoke_tests: SKIP (no retail root)"
    return 0
  end if
  if len(args) != 1 then return error(9893, "expected optional Quake II install root") end if
  retailSmoke(args[0])
  return 0
end function
