/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Last-resort Windows crash reporting for the MiniQuake2 product entry point. */
package miniquake2.runtime.crash_report

import std.fs as crashfs
import miniquake2.native as crashnative
import miniquake2.runtime.save_metadata as crashmetadata

const CRASH_REPORT_PATH = "miniquake2-crash.log"
const CF_UNICODETEXT = 13
const GMEM_MOVEABLE = 2
const GMEM_ZEROINIT = 64
const CP_UTF8 = 65001
const MB_OK = 0
const MB_ICONERROR = 16
const MB_SETFOREGROUND = 65536
const MB_TOPMOST = 262144

extern function MessageBoxW(owner as ptr, text as wstr, caption as wstr,
  style as u32) from "user32.dll" symbol "MessageBoxW" returns i32
extern function OpenClipboard(owner as ptr) from "user32.dll" symbol "OpenClipboard" returns bool
extern function EmptyClipboard() from "user32.dll" symbol "EmptyClipboard" returns bool
extern function SetClipboardData(format as u32, memory as ptr) from "user32.dll" symbol "SetClipboardData" returns ptr
extern function CloseClipboard() from "user32.dll" symbol "CloseClipboard" returns bool
extern function GlobalAlloc(flags as u32, size as u64) from "kernel32.dll" symbol "GlobalAlloc" returns ptr
extern function GlobalLock(memory as ptr) from "kernel32.dll" symbol "GlobalLock" returns ptr
extern function GlobalUnlock(memory as ptr) from "kernel32.dll" symbol "GlobalUnlock" returns bool
extern function GlobalFree(memory as ptr) from "kernel32.dll" symbol "GlobalFree" returns ptr
extern function MultiByteToWideChar(codePage as u32, flags as u32,
  source as bytes, sourceCount as i32, output as bytes,
  outputCount as i32) from "kernel32.dll" symbol "MultiByteToWideChar" returns i32
extern function RtlMoveMemoryToPtr(destination as ptr, source as bytes,
  length as u64) from "kernel32.dll" symbol "RtlMoveMemory" returns void

// Format one caught MiniLang error without losing its original source origin.
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

// Convert managed UTF-8 text to the NUL-terminated UTF-16 clipboard format.
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

// Publish the complete report to the Windows clipboard before showing it.
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

// Leave exclusive display mode and release mouse capture before a modal error.
function prepareDesktop()
  crashnative.winSetCursorCapture(0)
  crashnative.winDestroy()
  crashnative.winRestoreDisplayMode()
  return true
end function

// Persist, copy and display one otherwise-unhandled product error.
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
