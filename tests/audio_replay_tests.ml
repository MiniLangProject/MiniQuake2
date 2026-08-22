/* Byte-exact deterministic multi-channel mixer replay. */
import miniquake2.audio.wav as audioreplaywav
import miniquake2.audio.mixer as audioreplaymixer
import miniquake2.qcommon.byteio as audioreplaybyteio

function audioReplayAssert(value, message)
  if value != true then return error(9823, message) end if
  return true
end function

function audioReplayStereoSound()
  audioReplayPcm = bytes(16)
  audioreplaybyteio.putI16(audioReplayPcm, 0, -32768)
  audioreplaybyteio.putI16(audioReplayPcm, 2, 32767)
  audioreplaybyteio.putI16(audioReplayPcm, 4, -12000)
  audioreplaybyteio.putI16(audioReplayPcm, 6, 9000)
  audioreplaybyteio.putI16(audioReplayPcm, 8, 16000)
  audioreplaybyteio.putI16(audioReplayPcm, 10, -8000)
  audioreplaybyteio.putI16(audioReplayPcm, 12, 0)
  audioreplaybyteio.putI16(audioReplayPcm, 14, 4000)
  return audioreplaywav.WavSound("replay/stereo.wav", 22050, 2, 2, 4, -1,
    audioReplayPcm)
end function

function audioReplayRender()
  audioReplayMonoHolder = audioreplaywav.WavSound("replay/loop.wav", 11025, 1, 1,
    8, 2, bytes([128, 255, 192, 64, 0, 32, 224, 160]))
  audioReplayStereoHolder = audioReplayStereoSound()
  audioReplayMixerHolder = audioreplaymixer.create(44100)
  audioreplaymixer.setMasterVolume(audioReplayMixerHolder, 0.75)
  audioreplaymixer.startSound(audioReplayMixerHolder, audioReplayMonoHolder,
    1, 1, 255, 160)
  audioreplaymixer.startSound(audioReplayMixerHolder, audioReplayStereoHolder,
    2, 0, 96, 255)
  audioReplayFirst = audioreplaymixer.mix(audioReplayMixerHolder, 257)
  // A non-zero entity channel replaces the still-looping first sound at the
  // exact paint boundary, matching the product channel arbitration rule.
  audioreplaymixer.startSound(audioReplayMixerHolder, audioReplayStereoHolder,
    1, 1, 200, 50)
  audioReplaySecond = audioreplaymixer.mix(audioReplayMixerHolder, 255)
  audioReplayOutput = bytes(len(audioReplayFirst) + len(audioReplaySecond))
  audioreplaybyteio.copyInto(audioReplayOutput, 0, audioReplayFirst, 0,
    len(audioReplayFirst))
  audioreplaybyteio.copyInto(audioReplayOutput, len(audioReplayFirst),
    audioReplaySecond, 0, len(audioReplaySecond))
  return audioReplayOutput
end function

function audioReplayHash(data)
  audioReplayHashValue = 2166136261
  audioReplayHashIndex = 0
  while audioReplayHashIndex < len(data)
    audioReplayHashValue = ((audioReplayHashValue ^ data[audioReplayHashIndex]) *
      16777619) & 0xffffffff
    audioReplayHashIndex = audioReplayHashIndex + 1
  end while
  return audioReplayHashValue
end function

audioReplayFirstRun = audioReplayRender()
audioReplaySecondRun = audioReplayRender()
audioReplayAssert(audioReplayFirstRun == audioReplaySecondRun,
  "independent audio mixer replays differ")
audioReplayChecksum = audioReplayHash(audioReplayFirstRun)
audioReplayAssert(len(audioReplayFirstRun) == 2048, "audio replay byte length")
audioReplayAssert(audioReplayChecksum == 630146404,
  "audio replay PCM checksum changed")
print "audio_replay_tests: PASS checksum=" + audioReplayChecksum
