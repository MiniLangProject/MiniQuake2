//! Provides miniquake2 client cinematic picture facilities for this project.

/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Static PCX intermission playback with the cinematic renderer contract. */
package miniquake2.client.cinematic.picture

import miniquake2.format.pcx as cinpicturepcx

/// Store picture playback data.
struct PicturePlayback
  /// Stores the image value associated with picture playback.
  image
  /// Stores the status value associated with picture playback.
  status
  /// Stores the palette active value associated with picture playback.
  paletteActive
end struct

/// Starts start for the miniquake2 client cinematic picture workflow.
/// @param data Input data consumed by the operation.
function start(data)
  if typeof(data) != "bytes" then return error(8360, "picture source must be bytes") end if
  cinpictureImage = cinpicturepcx.parse(data)
  if len(cinpictureImage.palette) != 768 then
    return error(8361, "intermission PCX requires a 768-byte palette")
  end if
  return PicturePlayback(cinpictureImage, "playing", false)
end function

/// Draws draw through the miniquake2 client cinematic picture rendering path.
/// @param playback playback value consumed by this operation.
/// @param screenWidth screenWidth value consumed by this operation.
/// @param screenHeight screenHeight value consumed by this operation.
/// @param exports exports value consumed by this operation.
function draw(playback, screenWidth, screenHeight, exports)
  if screenWidth <= 0 or screenHeight <= 0 then
    return error(8362, "picture draw dimensions must be positive")
  end if
  if playback.status != "playing" then
    if playback.paletteActive then
      exports.CinematicSetPalette(void)
      playback.paletteActive = false
    end if
    return false
  end if
  if not playback.paletteActive then
    exports.CinematicSetPalette(playback.image.palette)
    playback.paletteActive = true
  end if
  exports.DrawStretchRaw(0, 0, screenWidth, screenHeight,
    playback.image.width, playback.image.height, playback.image.pixels)
  return true
end function

/// Stops stop for the miniquake2 client cinematic picture workflow.
/// @param playback playback value consumed by this operation.
function stop(playback)
  if playback.status == "stopped" then return false end if
  playback.status = "stopped"
  return true
end function
