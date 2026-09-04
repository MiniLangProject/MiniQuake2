//! Provides miniquake2 client screenshot facilities for this project.

/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* User screenshot naming and OpenGL back-buffer capture. */
package miniquake2.client.screenshot

import std.fs as screenshotfs
import miniquake2.renderer.capture as screenshotcapture

/// Invokes the native CreateDirectoryW entry point used by the miniquake2 client screenshot module.
/// @param path Path of the file or directory used by the operation.
/// @param security security value consumed by this operation.
/// @returns Native bool result produced by the call.
extern function CreateDirectoryW(path as wstr, security as ptr) from "kernel32.dll" returns bool

/// Store screenshot state data.
struct ScreenshotState
  /// Stores the directory value associated with screenshot state.
  directory
  /// Stores the next index value associated with screenshot state.
  nextIndex
end struct

/// Creates create for the miniquake2 client screenshot module.
/// @param directory directory value consumed by this operation.
function create(directory)
  if typeof(directory) != "string" or directory == "" then
    return error(9699, "screenshot directory is required")
  end if
  return ScreenshotState(directory, 0)
end function
/// Ensure directory.
/// @param path Path of the file or directory used by the operation.
function ensureDirectory(path)
  if screenshotfs.isDir(path) then return true end if
  if screenshotfs.exists(path) then return error(9700, "screenshot path is not a directory") end if
  if not CreateDirectoryW(path, 0) and not screenshotfs.isDir(path) then
    return error(9701, "could not create screenshot directory")
  end if
  return true
end function

/// Return the padded index.
/// @param index Zero-based index of the affected item.
function paddedIndex(index)
  if typeof(index) != "int" or index < 0 or index > 9999 then
    return error(9702, "screenshot index outside [0,9999]")
  end if
  text = "" + index
  while len(bytes(text)) < 4
    text = "0" + text
  end while
  return text
end function

/// Return the file name.
/// @param index Zero-based index of the affected item.
function fileName(index)
  return "mq2_" + paddedIndex(index) + ".tga"
end function

/// Reserve path.
/// @param state Mutable state inspected or updated by the operation.
function reservePath(state)
  ensureDirectory(state.directory)
  attempts = 0
  while attempts < 10000
    index = (state.nextIndex + attempts) % 10000
    path = screenshotfs.joinPath(state.directory, fileName(index))
    if not screenshotfs.exists(path) then
      state.nextIndex = (index + 1) % 10000
      return path
    end if
    attempts = attempts + 1
  end while
  return error(9703, "all screenshot names are occupied")
end function

/// Call after RenderFrame/UI and before EndFrame swaps the back buffer.
/// @param state Mutable state inspected or updated by the operation.
/// @param width Width in the coordinate or storage units used by the caller.
/// @param height Height in the coordinate or storage units used by the caller.
function capture(state, width, height)
  path = reservePath(state)
  image = screenshotcapture.readOpenGlFrame(width, height)
  screenshotcapture.writeTga(path, image)
  return path
end function

/// Write image.
/// @param state Mutable state inspected or updated by the operation.
/// @param image image value consumed by this operation.
function writeImage(state, image)
  path = reservePath(state)
  screenshotcapture.writeTga(path, image)
  return path
end function
