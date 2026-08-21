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

renderer = recording.createRecordingRenderer()
renderer.exports.Init(void, void)
assertEqual(clayout.draw(commands, renderer.exports), 3, "draw command count")
trace = recording.commandTrace(renderer)
assertEqual(len(bytes(trace)) > 0, true, "renderer command trace")
assertEqual(typeof(try(clayout.parse("if 1 string x", stats, configStrings, 640, 480))), "error", "unterminated conditional rejected")
renderer.exports.Shutdown()
print("MiniQuake2 client layout tests passed: 1")
