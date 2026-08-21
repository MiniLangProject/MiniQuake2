/* Focused low-heap retention gate for qcommon ASCII text helpers. */
import miniquake2.qcommon.text as qtextgc

function textGcAssert(actual, expected, label)
  if actual != expected then return error(3980, label + ": unexpected value") end if
  return true
end function

function main(args)
  qtextGcRetained = array(64)
  qtextGcIteration = 0
  while qtextGcIteration < 12000
    qtextGcInputHolder = "MAPS/WASTE" + (qtextGcIteration % 39) + ".BSP"
    qtextGcLowerHolder = qtextgc.lower(qtextGcInputHolder)
    textGcAssert(qtextgc.startsWith(qtextGcLowerHolder, "maps/"), true, "prefix")
    textGcAssert(qtextgc.equalInsensitive(qtextGcLowerHolder, qtextGcInputHolder), true, "case fold")
    qtextGcFixedDataHolder = bytes(qtextGcInputHolder + "\0discard")
    qtextGcFixedHolder = qtextgc.fixedString(qtextGcFixedDataHolder, 0, len(qtextGcFixedDataHolder))
    textGcAssert(qtextGcFixedHolder, qtextGcInputHolder, "fixed string")
    qtextGcSlot = qtextGcIteration % len(qtextGcRetained)
    qtextGcRetained[qtextGcSlot] = qtextGcLowerHolder
    qtextGcIteration = qtextGcIteration + 1
  end while
  qtextGcIndex = 0
  while qtextGcIndex < len(qtextGcRetained)
    textGcAssert(qtextgc.startsWith(qtextGcRetained[qtextGcIndex], "maps/"), true, "retained prefix")
    qtextGcIndex = qtextGcIndex + 1
  end while
  if try(qtextgc.lower(void)) is not error then return error(3981, "lower accepted void") end if
  if try(qtextgc.startsWith("value", void)) is not error then return error(3982, "startsWith accepted void") end if
  if try(qtextgc.fixedString("not-bytes", 0, 0)) is not error then return error(3983, "fixedString accepted text") end if
  print("qcommon_text_gc_tests: PASS")
  return 0
end function
