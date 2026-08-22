/* Original SV_Map level-string grammar and campaign media-chain tests. */
import miniquake2.runtime.media_sequence as mediatestseq
import miniquake2.qcommon.cmd as mediatestcmd
import miniquake2.qcommon.cvar as mediatestcvar

function mediaSequenceAssert(value, name)
  if not value then return error(8499, name) end if
  return true
end function

mediaUnit = mediatestseq.parse("eou1_.cin+*bunk1$start")
mediaSequenceAssert(len(mediaUnit.steps) == 2, "unit sequence width")
mediaSequenceAssert(mediaUnit.steps[0].kind == mediatestseq.MEDIA_CIN and
  mediaUnit.steps[0].name == "eou1_.cin", "unit cinematic step")
mediaSequenceAssert(mediaUnit.steps[1].kind == mediatestseq.MEDIA_MAP and
  mediaUnit.steps[1].name == "bunk1" and mediaUnit.steps[1].spawnPoint == "start" and
  mediaUnit.steps[1].endOfUnit, "unit target map step")

mediaEnding = mediatestseq.parse("end.cin+victory.pcx")
mediaSequenceAssert(len(mediaEnding.steps) == 2 and
  mediaEnding.steps[0].kind == mediatestseq.MEDIA_CIN and
  mediaEnding.steps[1].kind == mediatestseq.MEDIA_PCX,
  "ending cinematic and picture sequence")

mediaMap = mediatestseq.parse("base3$base2a")
mediaSequenceAssert(len(mediaMap.steps) == 1 and
  mediaMap.steps[0].kind == mediatestseq.MEDIA_MAP and
  mediaMap.steps[0].spawnPoint == "base2a" and not mediaMap.steps[0].endOfUnit,
  "ordinary map and spawn point")
mediaDemo = mediatestseq.parse("demo1.dm2")
mediaSequenceAssert(mediaDemo.steps[0].kind == mediatestseq.MEDIA_DM2 and
  mediatestseq.kindName(mediaDemo.steps[0].kind) == "dm2", "demo step")

mediaSequenceAssert(try(mediatestseq.parse("end.cin++victory.pcx")) is error,
  "empty chained step rejected")
mediaSequenceAssert(try(mediatestseq.parse("../end.cin")) is error,
  "path traversal rejected")
mediaSequenceAssert(try(mediatestseq.parse("movie.cin$spawn")) is error,
  "media spawn point rejected")
mediaSequenceAssert(try(mediatestseq.parse("*movie.cin")) is error,
  "media unit marker rejected")

mediaCommandSystem = mediatestcmd.create(mediatestcvar.createRegistry())
mediatestcmd.addText(mediaCommandSystem, "gamemap \"eou2_.cin+*jail1\"\nstatus\n")
mediaSequenceAssert(mediatestseq.takeQueuedGameMap(mediaCommandSystem) ==
  "eou2_.cin+*jail1", "queued gamemap extracted")
mediaSequenceAssert(mediaCommandSystem.buffer == "status\n" and
  mediatestseq.takeQueuedGameMap(mediaCommandSystem) == "" and
  mediaCommandSystem.buffer == "status\n", "unrelated command preserved")
mediaMalformedCommandSystem = mediatestcmd.create(mediatestcvar.createRegistry())
mediatestcmd.addText(mediaMalformedCommandSystem, "gamemap \"end.cin++victory.pcx\"\n")
mediaSequenceAssert(try(mediatestseq.takeQueuedGameMap(mediaMalformedCommandSystem)) is error and
  mediaMalformedCommandSystem.buffer != "", "invalid queued gamemap retained atomically")
print("runtime_media_sequence_tests: PASS")
