import miniquake2.audio.mixer as musictestmixer
import miniquake2.qcommon.filesystem as musictestfs

function musicAssert(actual, expected, label)
  if actual != expected then return error(9974, label + ": expected " + expected + ", got " + actual) end if
end function

musicAssert(musictestfs.musicTrackName(2), "track02.ogg", "single-digit track")
musicAssert(musictestfs.musicTrackName(21), "track21.ogg", "two-digit track")
musicAssert(typeof(try(musictestfs.musicTrackName(0))), "error", "track zero rejected")
mixer = musictestmixer.create(44100)
musicAssert(mixer.musicVolume, 0.5, "default music volume")
musicAssert(musictestmixer.setMusicVolume(mixer, 0.75), 0.75, "music volume")
musicAssert(typeof(try(musictestmixer.setMusicVolume(mixer, 1.1))), "error", "music volume range")
filesystem = musictestfs.create("Z:\\MiniQuake2Missing", "")
musicAssert(musictestmixer.synchronizeMusicTrack(mixer, filesystem, "0"), true, "track zero stops")
musicAssert(typeof(try(musictestmixer.synchronizeMusicTrack(mixer, filesystem, "2"))), "error", "missing replacement reported")
musicAssert(musictestmixer.synchronizeMusicTrack(mixer, filesystem, "abc"), false, "invalid track ignored")
print "MiniQuake2 audio music tests passed: 1"
