/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* 14-fps Quake II CIN playback, palette lifecycle and safe API handoffs. */
package miniquake2.client.cinematic.player

import miniquake2.format.cinematic as cinformat
import miniquake2.client.cinematic.audio as cinaudio
import miniquake2.client.cinematic.types as cintypes

function audioChunk(header, data)
  frameBytes = header.sampleWidth * header.sampleChannels
  if frameBytes <= 0 or len(data) % frameBytes != 0 then return error(8340, "cinematic audio is not whole sample frames") end if
  return cintypes.AudioChunk(header.sampleRate, header.sampleWidth,
    header.sampleChannels, len(data) / frameBytes, bytes(data))
end function

function emitAudio(playback, data)
  if len(data) == 0 then return 0 end if
  chunk = audioChunk(playback.header, data)
  playback.audio.submit(chunk)
  return chunk.sampleCount
end function

function readNext(playback, frameNumber)
  decoded = try(cinformat.readFrame(playback.data, playback.offset, frameNumber,
    playback.header, playback.tables))
  if decoded is error then playback.status = "stopped"; playback.audio.stop(); return decoded end if
  playback.offset = decoded.nextOffset
  if decoded.command == 2 then return false end if
  expectedPixels = playback.header.width * playback.header.height
  if len(decoded.pixels) != expectedPixels then playback.status = "stopped"; playback.audio.stop(); return error(8341, "CIN frame does not cover the declared dimensions") end if
  playback.frameNumber = frameNumber
  playback.pixels = decoded.pixels
  if len(decoded.palette) > 0 then
    if len(decoded.palette) != 768 then playback.status = "stopped"; playback.audio.stop(); return error(8342, "CIN palette length mismatch") end if
    playback.palette = decoded.palette
    playback.paletteDirty = true
  end if
  emitAudio(playback, decoded.audio)
  return true
end function

function start(data, now, looping, audioCallbacks)
  if typeof(data) != "bytes" then return error(8343, "cinematic source must be bytes") end if
  if typeof(now) != "int" then return error(8344, "cinematic start time must be integer milliseconds") end if
  if audioCallbacks is void or typeof(audioCallbacks.submit) != "function" or
      typeof(audioCallbacks.pause) != "function" or typeof(audioCallbacks.resume) != "function" or
      typeof(audioCallbacks.stop) != "function" then return error(8345, "cinematic audio callbacks are invalid") end if
  header = cinformat.parseHeader(data)
  tables = cinformat.buildTables(header)
  playback = cintypes.Playback(data, header, tables, header.frameDataOffset, -1,
    bytes(), bytes(), "playing", now, 0, looping, 0, 0, false, false, audioCallbacks)
  loaded = readNext(playback, 0)
  if loaded == false then playback.status = "stopped"; return error(8346, "CIN contains no video frames") end if
  return playback
end function

function pause(playback, now)
  if typeof(now) != "int" then return error(8347, "cinematic pause time must be integer milliseconds") end if
  if playback.status != "playing" then return false end if
  playback.status = "paused"
  playback.pauseTime = now
  playback.audio.pause()
  return true
end function

function resume(playback, now)
  if typeof(now) != "int" then return error(8348, "cinematic resume time must be integer milliseconds") end if
  if playback.status != "paused" then return false end if
  if now < playback.pauseTime then return error(8349, "cinematic resume precedes pause") end if
  playback.startTime = playback.startTime + now - playback.pauseTime
  playback.pauseTime = 0
  playback.status = "playing"
  playback.audio.resume()
  return true
end function

function stop(playback)
  if playback.status == "stopped" then return false end if
  playback.status = "stopped"
  playback.audio.stop()
  return true
end function

function restartLoop(playback, now)
  playback.completions = playback.completions + 1
  playback.offset = playback.header.frameDataOffset
  playback.frameNumber = -1
  playback.startTime = now
  loaded = readNext(playback, 0)
  if loaded == false then playback.status = "stopped"; return error(8350, "looping CIN contains no frames") end if
  playback.status = "playing"
  return true
end function

function update(playback, now)
  if typeof(now) != "int" then return error(8351, "cinematic update time must be integer milliseconds") end if
  if playback.status != "playing" then return false end if
  if now < playback.startTime then return error(8352, "cinematic clock moved before start") end if
  elapsed = now - playback.startTime
  numerator = elapsed * 14
  desired = (numerator - (numerator % 1000)) / 1000
  if desired <= playback.frameNumber then return false end if

  nextNumber = playback.frameNumber + 1
  wasLate = desired > nextNumber
  if wasLate then playback.droppedFrames = playback.droppedFrames + desired - nextNumber end if
  loaded = readNext(playback, nextNumber)
  if loaded == false then
    if playback.looping then return restartLoop(playback, now) end if
    playback.completions = playback.completions + 1
    playback.status = "completed"
    playback.audio.stop()
    return true
  end if
  if wasLate then
    frameMsec = (playback.frameNumber * 1000 - ((playback.frameNumber * 1000) % 14)) / 14
    playback.startTime = now - frameMsec
  end if
  return true
end function

function draw(playback, screenWidth, screenHeight, exports)
  if screenWidth <= 0 or screenHeight <= 0 then return error(8353, "cinematic draw dimensions must be positive") end if
  if playback.status == "stopped" or playback.status == "completed" then
    if playback.paletteActive then exports.CinematicSetPalette(void); playback.paletteActive = false end if
    return false
  end if
  if playback.paletteDirty then
    exports.CinematicSetPalette(playback.palette)
    playback.paletteDirty = false
    playback.paletteActive = true
  end if
  if len(playback.pixels) != playback.header.width * playback.header.height then return error(8354, "cinematic draw frame is incomplete") end if
  exports.DrawStretchRaw(0, 0, screenWidth, screenHeight,
    playback.header.width, playback.header.height, playback.pixels)
  return true
end function

function isFinished(playback)
  return playback.status == "completed" or playback.status == "stopped"
end function
