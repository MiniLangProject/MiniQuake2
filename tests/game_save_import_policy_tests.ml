import miniquake2.game.persistence as savepolicytest

function savePolicyAssert(actual, expected, label)
  if actual != expected then return error(9977, label + ": expected " + expected + ", got " + actual) end if
end function

foreign = bytes(64)
foreign[0] = 103; foreign[1] = 97; foreign[2] = 109; foreign[3] = 101
savePolicyAssert(savepolicytest.saveFormat(foreign), "native-or-foreign", "native save classified")
rejected = try(savepolicytest.decodeSaveImage(foreign, 1024))
savePolicyAssert(typeof(rejected), "error", "native save rejected")
savePolicyAssert(rejected.message,
  "original Quake II native saves are machine-layout dumps and cannot be imported safely; use a MiniQuake2 save slot",
  "explicit import policy")
savePolicyAssert(savepolicytest.saveFormat(bytes(2)), "truncated", "truncated save classified")
print "MiniQuake2 game save import policy tests passed: 1"
