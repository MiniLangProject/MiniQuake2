/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Original SV_Map level-string grammar and campaign media-chain tests. */
import miniquake2.runtime.media_sequence as mediatestseq
import miniquake2.qcommon.cmd as mediatestcmd
import miniquake2.qcommon.cvar as mediatestcvar
import miniquake2.client.ui.keys as mediatestkeys
import miniquake2.client.ui.constants as mediatestui

// Assert the media sequence test condition.
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
mediaMapPolicy = mediatestseq.gameMapPolicy(mediaMap.steps[0], true)
mediaUnitPolicy = mediatestseq.gameMapPolicy(mediaUnit.steps[1], true)
mediaSequenceAssert(mediaMapPolicy.archiveCurrent and
  not mediaMapPolicy.wipeUnit and mediaMapPolicy.autosaveSuccessor,
  "ordinary gamemap archives current level and autosaves successor")
mediaSequenceAssert(not mediaUnitPolicy.archiveCurrent and
  mediaUnitPolicy.wipeUnit and mediaUnitPolicy.autosaveSuccessor,
  "end-of-unit gamemap wipes current archive and autosaves successor")
mediaSequenceAssert(mediatestseq.cooperativePictureSuccessor(
  mediaEnding.steps[1], true) == "*base1" and
  mediatestseq.cooperativePictureSuccessor(mediaEnding.steps[1], false) == "",
  "cooperative victory picture returns to a fresh base1 unit")
mediaTimedemo = mediatestseq.timedemoMetrics(250, 2000)
mediaSequenceAssert(mediaTimedemo.framesPerSecond == 125.0 and
  mediaTimedemo.elapsedMsec == 2000,
  "timedemo reports explicit elapsed time and throughput")
mediaDemo = mediatestseq.parse("demo1.dm2")
mediaSequenceAssert(mediaDemo.steps[0].kind == mediatestseq.MEDIA_DM2 and
  mediatestseq.kindName(mediaDemo.steps[0].kind) == "dm2", "demo step")

mediaSequenceAssert(try(mediatestseq.parse("end.cin++victory.pcx")) is error,
  "empty chained step rejected")
mediaSequenceAssert(try(mediatestseq.parse("../end.cin")) is error,
  "path traversal rejected")
mediaSequenceAssert(try(mediatestseq.parse("movie.cin$spawn")) is error,
  "media spawn point rejected")
mediaNewGame = mediatestseq.parse(mediatestseq.stockNewGameSpecification())
mediaSequenceAssert(len(mediaNewGame.steps) == 2 and
  mediaNewGame.steps[0].kind == mediatestseq.MEDIA_CIN and
  mediaNewGame.steps[0].name == "ntro.cin" and
  mediaNewGame.steps[0].endOfUnit and
  mediaNewGame.steps[1].name == "base1",
  "stock new-game intro sequence")
mediaSequenceAssert(mediatestseq.MAX_MEDIA_TRANSITIONS == 64,
  "campaign transition chain has a finite recursion-free safety bound")
mediaSequenceAssert(mediatestseq.stockAttractStep(0).name == "idlog.cin" and
  mediatestseq.stockAttractStep(1).name == "demo1.dm2" and
  mediatestseq.stockAttractStep(2).name == "idlog.cin" and
  mediatestseq.stockAttractStep(3).name == "demo2.dm2" and
  mediatestseq.nextStockAttractIndex(3) == 0,
  "stock d1 through d4 attract cycle")
mediaAttractInput = mediatestkeys.createInputState()
mediaSequenceAssert(not mediatestseq.attractInterrupted(mediaAttractInput),
  "idle attract input retained")
mediaAttractInput.keys[65] = true
mediaSequenceAssert(mediatestseq.gameButtonDown(mediaAttractInput) and
  mediatestseq.attractInterrupted(mediaAttractInput),
  "ordinary attract key interrupts")
mediaAttractInput.keys[65] = false
mediaAttractInput.focused = false
mediaAttractInput.destination = mediatestui.KEY_MENU
mediaSequenceAssert(not mediatestseq.attractInterrupted(mediaAttractInput),
  "focus loss does not masquerade as attract input")
mediaAttractInput.focused = true
mediaSequenceAssert(mediatestseq.attractInterrupted(mediaAttractInput),
  "attract menu destination interrupts")

mediaCommandSystem = mediatestcmd.create(mediatestcvar.createRegistry())
mediatestcmd.addText(mediaCommandSystem, "gamemap \"eou2_.cin+*jail1\"\nstatus\n")
mediaSequenceAssert(mediatestseq.takeQueuedGameMap(mediaCommandSystem) ==
  "eou2_.cin+*jail1", "queued gamemap extracted")
mediaSequenceAssert(mediaCommandSystem.buffer == "status\n" and
  mediatestseq.takeQueuedGameMap(mediaCommandSystem) == "" and
  mediaCommandSystem.buffer == "status\n", "unrelated command preserved")
mediaLoadCommandSystem = mediatestcmd.create(mediatestcvar.createRegistry())
mediatestcmd.addText(mediaLoadCommandSystem,
  "menu_loadgame\ngamemap \"base1\"\nstatus\n")
mediaSequenceAssert(mediatestseq.takeQueuedLoadMenu(mediaLoadCommandSystem),
  "queued load menu extracted")
mediaSequenceAssert(mediatestseq.takeQueuedGameMap(mediaLoadCommandSystem) == "base1" and
  mediaLoadCommandSystem.buffer == "status\n", "load menu preserves following map command")
mediaSequenceAssert(not mediatestseq.takeQueuedLoadMenu(mediaLoadCommandSystem) and
  mediaLoadCommandSystem.buffer == "status\n", "unrelated load-menu command preserved")
mediaMalformedLoadSystem = mediatestcmd.create(mediatestcvar.createRegistry())
mediatestcmd.addText(mediaMalformedLoadSystem, "menu_loadgame unexpected\n")
mediaSequenceAssert(try(mediatestseq.takeQueuedLoadMenu(mediaMalformedLoadSystem)) is error and
  mediaMalformedLoadSystem.buffer != "", "invalid queued load menu retained atomically")
mediaMalformedCommandSystem = mediatestcmd.create(mediatestcvar.createRegistry())
mediatestcmd.addText(mediaMalformedCommandSystem, "gamemap \"end.cin++victory.pcx\"\n")
mediaSequenceAssert(try(mediatestseq.takeQueuedGameMap(mediaMalformedCommandSystem)) is error and
  mediaMalformedCommandSystem.buffer != "", "invalid queued gamemap retained atomically")
print("runtime_media_sequence_tests: PASS")
