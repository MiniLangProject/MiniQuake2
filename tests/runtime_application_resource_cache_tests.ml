/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Process-wide retail filesystem and decoded-sound cache lifecycle. */
import miniquake2.runtime.application as resourcecacheapplication

// Assert the resource-cache test condition.
function resourceCacheAssert(condition, message)
  if not condition then return error(8497, message) end if
  return true
end function

// Verify same-root reuse and different-root invalidation.
function resourceCacheCore()
  first = resourcecacheapplication.applicationSharedFileSystem(
    "synthetic-cache-root-a")
  first.links = ["sentinel"]
  same = resourcecacheapplication.applicationSharedFileSystem(
    "SYNTHETIC-CACHE-ROOT-A")
  resourceCacheAssert(len(same.links) == 1 and same.links[0] == "sentinel",
    "same retail root rebuilt the PAK filesystem")

  soundCache = resourcecacheapplication.applicationSynchronizeSoundCache(first)
  soundCache.soundNames[0] = "sound/test.wav"
  soundCache.sounds[0] = bytes([1, 2, 3])
  soundCache.soundCount = 1
  retained = resourcecacheapplication.applicationSynchronizeSoundCache(first)
  resourceCacheAssert(retained.soundCount == 1 and
      retained.soundNames[0] == "sound/test.wav",
    "same retail root discarded decoded sounds")

  different = resourcecacheapplication.applicationSharedFileSystem(
    "synthetic-cache-root-b")
  replaced = resourcecacheapplication.applicationSynchronizeSoundCache(different)
  resourceCacheAssert(len(different.links) == 0 and replaced.soundCount == 0,
    "different retail root retained stale resources")
  return true
end function

resourceCacheCore()
print("runtime_application_resource_cache_tests: PASS")
