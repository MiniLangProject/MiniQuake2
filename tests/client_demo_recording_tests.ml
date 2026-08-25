import miniquake2.client.demo as demorecordtest
import miniquake2.client.demo_recording as demorecordproducttest

function demoRecordAssert(actual, expected, label)
  if actual != expected then return error(9975, label + ": expected " + expected + ", got " + actual) end if
end function

demoRecordAssert(demorecordproducttest.safeName("base1_run-01"), true, "safe demo name")
demoRecordAssert(demorecordproducttest.safeName("../escape"), false, "traversal name")
demoRecordAssert(demorecordproducttest.safeName("bad name"), false, "space name")
demo = demorecordtest.create()
demorecordtest.beginLiveRecording(demo)
demorecordtest.appendLive(demo, bytes([1]), 0, -1)
demoRecordAssert(demorecordtest.packetCount(demo), 1, "setup packet retained")
demorecordtest.appendLive(demo, bytes([2]), 1, 10)
demoRecordAssert(demorecordtest.packetCount(demo), 1, "delta startup frame skipped")
demorecordtest.appendLive(demo, bytes([3]), 1, -1)
demoRecordAssert(demorecordtest.packetCount(demo), 2, "full startup frame retained")
demorecordtest.appendLive(demo, bytes([4]), 1, 3)
demoRecordAssert(demorecordtest.packetCount(demo), 3, "later delta retained")
decoded = demorecordtest.decodeDemo(demorecordtest.encodeDemo(demo))
demoRecordAssert(len(decoded.packets), 3, "recorded DM2 round trip")
print "MiniQuake2 client demo recording tests passed: 1"
