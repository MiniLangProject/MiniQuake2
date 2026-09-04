//! Provides miniquake2 runtime crash report facilities for this project.

/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Last-resort Windows crash reporting for the MiniQuake2 product entry point. */
package miniquake2.runtime.crash_report

import std.fs as crashfs
import miniquake2.native as crashnative
import miniquake2.runtime.save_metadata as crashmetadata

/// Defines the crash report path constant used by the miniquake2 runtime crash report module.
const CRASH_REPORT_PATH = "miniquake2-crash.log"
/// Defines the cf unicodetext constant used by the miniquake2 runtime crash report module.
const CF_UNICODETEXT = 13
/// Defines the gmem moveable constant used by the miniquake2 runtime crash report module.
const GMEM_MOVEABLE = 2
/// Defines the gmem zeroinit constant used by the miniquake2 runtime crash report module.
const GMEM_ZEROINIT = 64
/// Defines the cp utf8 constant used by the miniquake2 runtime crash report module.
const CP_UTF8 = 65001
/// Defines the mb ok constant used by the miniquake2 runtime crash report module.
const MB_OK = 0
/// Defines the mb iconerror constant used by the miniquake2 runtime crash report module.
const MB_ICONERROR = 16
/// Defines the mb setforeground constant used by the miniquake2 runtime crash report module.
const MB_SETFOREGROUND = 65536
/// Defines the mb topmost constant used by the miniquake2 runtime crash report module.
const MB_TOPMOST = 262144

/// Invokes the native MessageBoxW entry point used by the miniquake2 runtime crash report module.
/// @param owner owner value consumed by this operation.
/// @param text Text consumed by the operation.
/// @param caption caption value consumed by this operation.
/// @param style style value consumed by this operation.
/// @returns Native i32 result produced by the call.
extern function MessageBoxW(owner as ptr, text as wstr, caption as wstr,
  style as u32) from "user32.dll" symbol "MessageBoxW" returns i32
/// Invokes the native OpenClipboard entry point used by the miniquake2 runtime crash report module.
/// @param owner owner value consumed by this operation.
/// @returns Native bool result produced by the call.
extern function OpenClipboard(owner as ptr) from "user32.dll" symbol "OpenClipboard" returns bool
/// Invokes the native EmptyClipboard entry point used by the miniquake2 runtime crash report module.
/// @returns Native bool result produced by the call.
extern function EmptyClipboard() from "user32.dll" symbol "EmptyClipboard" returns bool
/// Invokes the native SetClipboardData entry point used by the miniquake2 runtime crash report module.
/// @param format format value consumed by this operation.
/// @param memory memory value consumed by this operation.
/// @returns Native ptr result produced by the call.
extern function SetClipboardData(format as u32, memory as ptr) from "user32.dll" symbol "SetClipboardData" returns ptr
/// Invokes the native CloseClipboard entry point used by the miniquake2 runtime crash report module.
/// @returns Native bool result produced by the call.
extern function CloseClipboard() from "user32.dll" symbol "CloseClipboard" returns bool
/// Invokes the native GlobalAlloc entry point used by the miniquake2 runtime crash report module.
/// @param flags Bit flags controlling the operation.
/// @param size Size in the units required by the operation.
/// @returns Native ptr result produced by the call.
extern function GlobalAlloc(flags as u32, size as u64) from "kernel32.dll" symbol "GlobalAlloc" returns ptr
/// Invokes the native GlobalLock entry point used by the miniquake2 runtime crash report module.
/// @param memory memory value consumed by this operation.
/// @returns Native ptr result produced by the call.
extern function GlobalLock(memory as ptr) from "kernel32.dll" symbol "GlobalLock" returns ptr
/// Invokes the native GlobalUnlock entry point used by the miniquake2 runtime crash report module.
/// @param memory memory value consumed by this operation.
/// @returns Native bool result produced by the call.
extern function GlobalUnlock(memory as ptr) from "kernel32.dll" symbol "GlobalUnlock" returns bool
/// Invokes the native GlobalFree entry point used by the miniquake2 runtime crash report module.
/// @param memory memory value consumed by this operation.
/// @returns Native ptr result produced by the call.
extern function GlobalFree(memory as ptr) from "kernel32.dll" symbol "GlobalFree" returns ptr
/// Invokes the native MultiByteToWideChar entry point used by the miniquake2 runtime crash report module.
/// @param codePage codePage value consumed by this operation.
/// @param flags Bit flags controlling the operation.
/// @param source source value consumed by this operation.
/// @param sourceCount Number of source to process.
/// @param output Output collection or buffer populated by the operation.
/// @param outputCount Number of output to process.
/// @returns Native i32 result produced by the call.
extern function MultiByteToWideChar(codePage as u32, flags as u32,
  source as bytes, sourceCount as i32, output as bytes,
  outputCount as i32) from "kernel32.dll" symbol "MultiByteToWideChar" returns i32
/// Invokes the native RtlMoveMemoryToPtr entry point used by the miniquake2 runtime crash report module.
/// @param destination destination value consumed by this operation.
/// @param source source value consumed by this operation.
/// @param length length value consumed by this operation.
extern function RtlMoveMemoryToPtr(destination as ptr, source as bytes,
  length as u64) from "kernel32.dll" symbol "RtlMoveMemory" returns void

/// Format one caught MiniLang error without losing its original source origin.
/// @param caught caught value consumed by this operation.
/// @param version version value consumed by this operation.
/// @param timestamp timestamp value consumed by this operation.
function format(caught, version, timestamp)
  if caught is not error then return error(9985, "crash report requires an error value") end if
  report = "MiniQuake2 crash report\n" +
    "Version: " + version + "\n" +
    "Time: " + timestamp + "\n" +
    "Error: no=" + caught.code + " message=" + caught.message + "\n"
  script = try(caught.script)
  if script is error or typeof(script) != "string" then script = "" end if
  functionName = try(caught.func)
  if functionName is error or typeof(functionName) != "string" then
    functionName = ""
  end if
  line = try(caught.line)
  if line is error or typeof(line) != "int" then line = 0 end if
  if script != "" and functionName != "" and line > 0 then
    report = report + "  at " + script + ":" + line +
      " in " + functionName + "\n"
  end if
  return report
end function

/// Convert managed UTF-8 text to the NUL-terminated UTF-16 clipboard format.
/// @param text Text consumed by the operation.
function utf16Bytes(text)
  source = bytes(text)
  if len(source) == 0 then return bytes(2, 0) end if
  units = MultiByteToWideChar(CP_UTF8, 8, source, len(source), void, 0)
  if units <= 0 then return error(9986, "crash report UTF-16 size query failed") end if
  output = bytes((units + 1) * 2, 0)
  actual = MultiByteToWideChar(CP_UTF8, 8, source, len(source), output, units)
  if actual != units then return error(9986, "crash report UTF-16 conversion failed") end if
  return output
end function

/// Publish the complete report to the Windows clipboard before showing it.
/// @param report report value consumed by this operation.
function copyToClipboard(report)
  wide = try(utf16Bytes(report))
  if wide is error then return wide end if
  if not OpenClipboard(void) then return error(9987, "Windows clipboard is busy") end if
  if not EmptyClipboard() then
    ignoredClose = CloseClipboard()
    return error(9987, "Windows clipboard could not be cleared")
  end if
  memory = GlobalAlloc(GMEM_MOVEABLE | GMEM_ZEROINIT, len(wide))
  if memory == 0 then
    ignoredClose = CloseClipboard()
    return error(9987, "Windows clipboard allocation failed")
  end if
  pointer = GlobalLock(memory)
  if pointer == 0 then
    ignoredFree = GlobalFree(memory)
    ignoredClose = CloseClipboard()
    return error(9987, "Windows clipboard allocation could not be locked")
  end if
  RtlMoveMemoryToPtr(pointer, wide, len(wide))
  ignoredUnlock = GlobalUnlock(memory)
  published = SetClipboardData(CF_UNICODETEXT, memory)
  ignoredClose = CloseClipboard()
  if published == 0 then
    ignoredFree = GlobalFree(memory)
    return error(9987, "Windows clipboard publication failed")
  end if
  return true
end function

/// Leave exclusive display mode and release mouse capture before a modal error.
function prepareDesktop()
  crashnative.winSetCursorCapture(0)
  crashnative.winDestroy()
  crashnative.winRestoreDisplayMode()
  return true
end function

/// Persist, copy and display one otherwise-unhandled product error.
/// @param caught caught value consumed by this operation.
/// @param version version value consumed by this operation.
function handle(caught, version)
  timestamp = crashmetadata.currentTimestamp()
  report = try(format(caught, version, timestamp))
  if report is error then
    report = "MiniQuake2 crash report\nError while formatting caught failure."
  end if
  print report
  writeResult = try(crashfs.writeAllText(CRASH_REPORT_PATH, report))
  desktopResult = try(prepareDesktop())
  clipboardResult = try(copyToClipboard(report))
  copyNotice = "The complete report is already in the clipboard. Paste it with Ctrl+V."
  if clipboardResult is error then
    copyNotice = "Press Ctrl+C while this dialog is focused to copy its complete contents."
  end if
  fileNotice = "A copy was written to " + CRASH_REPORT_PATH + "."
  if writeResult is error then fileNotice = "The crash log could not be written." end if
  ignoredDialog = MessageBoxW(void, report + "\n" + copyNotice + "\n" +
    fileNotice, "MiniQuake2 crashed",
    MB_OK | MB_ICONERROR | MB_SETFOREGROUND | MB_TOPMOST)
  return 1
end function
