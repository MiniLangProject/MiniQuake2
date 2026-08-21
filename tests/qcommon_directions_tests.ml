/* Exact 162-entry Quake II bytedirs codec contract. */
import miniquake2.qcommon.types as qt
import miniquake2.qcommon.sizebuf as qsz
import miniquake2.qcommon.message as qmsg
import miniquake2.qcommon.directions as qdir

function assertEqual(actual, expected, name)
  if actual != expected then return error(7995, name + ": expected " + expected + ", got " + actual) end if
end function

assertEqual(len(qdir.normals), 162, "bytedirs count")
assertEqual(qdir.encodeDirection(qt.Vec3(1.0, 0.0, 0.0)), 52, "+x index")
assertEqual(qdir.encodeDirection(qt.Vec3(0.0, 0.0, 1.0)), 5, "+z index")
buffer = qsz.alloc(2)
qdir.writeDirection(buffer, qt.Vec3(0.0, 0.0, -1.0))
assertEqual(buffer.data[0], 84, "-z wire index")
qmsg.beginReading(buffer)
decoded = qdir.readDirection(buffer)
assertEqual(decoded.z, -1.0, "-z decode")
bad = qsz.alloc(1); bad.data[0] = 200; bad.curSize = 1; qmsg.beginReading(bad)
assertEqual(typeof(try(qdir.readDirection(bad))), "error", "out-of-range direction rejected")
print("MiniQuake2 qcommon direction tests passed: 1")
