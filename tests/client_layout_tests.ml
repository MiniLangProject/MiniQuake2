/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Statusbar/layout parser and Renderer API handoff. */
import miniquake2.qcommon.constants as qc
import miniquake2.game.constants as gc
import miniquake2.client.layout as clayout
import miniquake2.renderer.recording as recording

function assertEqual(actual, expected, name)
  if actual != expected then return error(7999, name + ": expected " + expected + ", got " + actual) end if
end function

stats = array(32, 0)
stats[gc.STAT_HEALTH] = 100
stats[2] = 5
stats[3] = 20
configStrings = array(qc.MAX_CONFIGSTRINGS, "")
configStrings[qc.CS_IMAGES + 5] = "pics/i_health.pcx"
layout = "xv 0 yb -24 hnum xv 100 pic 2 if 3 string \"ammo\" endif if 7 string \"hidden\" endif"
commands = clayout.parse(layout, stats, configStrings, 640, 480)
assertEqual(len(commands), 3, "visible layout command count")
assertEqual(commands[0].value, 100, "health number")
assertEqual(commands[1].text, "pics/i_health.pcx", "stat-selected picture")
assertEqual(commands[2].text, "ammo", "conditional string")

stats[gc.STAT_HEALTH] = 20
stats[gc.STAT_FLASHES] = 1
flashing = clayout.parseTokensContext(clayout.tokenize("xl 4 yt 6 hnum"), stats,
  configStrings, 640, 480, 4, 0)
assertEqual(len(flashing), 2, "health flash command count")
assertEqual(flashing[0].text, "field_3", "health flash background")
assertEqual(flashing[1].style, 1, "low-health alternate number set")

centered = clayout.parseTokensContext(clayout.tokenize("xl 10 yt 20 cstring2 hi"),
  stats, configStrings, 640, 480, 4, 0)
assertEqual(centered[0].operation, "center", "centered layout string")
assertEqual(centered[0].x, 10, "centered string uses layout origin")
assertEqual(centered[0].width, 320, "centered string virtual width")
assertEqual(centered[0].style, 128, "alternate character set")

configStrings[qc.CS_PLAYERSKINS + 2] = "Ranger\\male/grunt"
clientBlock = clayout.parseTokensContext(clayout.tokenize(
  "client 0 0 2 42 70 5"), stats, configStrings, 640, 480, 4, 2)
assertEqual(len(clientBlock), 6, "deathmatch client block expansion")
assertEqual(clientBlock[0].text, "Ranger", "client name from playerskin")
assertEqual(clientBlock[5].text, "players/male/grunt_i.pcx", "client icon path")
ctfBlock = clayout.parseTokensContext(clayout.tokenize("ctf 0 0 2 42 1200"),
  stats, configStrings, 640, 480, 4, 2)
assertEqual(ctfBlock[0].style, 128, "local CTF row highlight")

renderer = recording.createRecordingRenderer()
renderer.exports.Init(void, void)
assertEqual(clayout.draw(commands, renderer.exports), 3, "draw command count")
trace = recording.commandTrace(renderer)
assertEqual(len(bytes(trace)) > 0, true, "renderer command trace")
assertEqual(typeof(try(clayout.parse("if 1 string x", stats, configStrings, 640, 480))), "error", "unterminated conditional rejected")
renderer.exports.Shutdown()
print("MiniQuake2 client layout tests passed: 1")
