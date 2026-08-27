/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
import miniquake2.runtime.save_metadata as metadatatest
import std.fs as metadatafs

// Assert the metadata test condition.
function metadataAssert(actual, expected, label)
  if actual != expected then return error(9973, label + ": expected " + expected + ", got " + actual) end if
end function

value = metadatatest.SaveSlotMetadata("base1", 123, "2026-08-25T12:34:56", "mq2_0001.tga")
decoded = metadatatest.decode(metadatatest.encode(value))
metadataAssert(decoded.mapName, "base1", "map")
metadataAssert(decoded.frameNumber, 123, "frame")
metadataAssert(decoded.timestamp, "2026-08-25T12:34:56", "timestamp")
metadataAssert(decoded.screenshot, "mq2_0001.tga", "screenshot")
emptyShot = metadatatest.decode(metadatatest.encode(
  metadatatest.SaveSlotMetadata("boss2", 9, "2026-08-25T12:00:00", "")))
metadataAssert(emptyShot.screenshot, "", "empty screenshot")
metadataAssert(typeof(try(metadatatest.decode("native save"))), "error", "foreign metadata rejected")
stamp = metadatatest.currentTimestamp()
metadataAssert(len(bytes(stamp)), 19, "timestamp width")
metadataPath = "build/runtime_save_metadata_test.meta"
metadatatest.save(metadataPath, value)
metadataLoaded = metadatatest.decode(metadatafs.readAllText(metadataPath))
metadataAssert(metadataLoaded.mapName, "base1", "disk metadata map")
metadataAssert(metadataLoaded.screenshot, "mq2_0001.tga",
  "disk metadata screenshot")
metadatafs.delete(metadataPath)
print "MiniQuake2 runtime save metadata tests passed: 1"
