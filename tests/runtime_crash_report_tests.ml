/*
Copyright (c) 2026 Nils Kopal
SPDX-License-Identifier: GPL-2.0-or-later
*/
/* Pure crash-report formatting tests; no modal dialog is opened here. */
import miniquake2.runtime.crash_report as crashreporttest

// Assert crash-report values without depending on Windows UI state.
function crashReportAssert(actual, expected, name)
  if actual != expected then
    return error(9988, name + ": expected " + expected + ", got " + actual)
  end if
  return true
end function

crashReportError = error(1306, "Struct has no member 'number'")
crashReportText = crashreporttest.format(crashReportError, "test-version",
  "2026-08-27T12:34:56")
crashReportExpected = "MiniQuake2 crash report\n" +
  "Version: test-version\n" +
  "Time: 2026-08-27T12:34:56\n" +
  "Error: no=1306 message=Struct has no member 'number'\n"
crashReportAssert(crashReportText, crashReportExpected,
  "originless error formatted")

// Propagation fills the error origin fields; verify they survive try(...).
function propagatedCrashReportError()
  return error(9604, "invalid product refdef shape")
end function

crashReportPropagated = try(propagatedCrashReportError())
crashReportPropagatedText = crashreporttest.format(crashReportPropagated,
  "test-version", "2026-08-27T12:34:56")
crashReportPropagatedExpected = "MiniQuake2 crash report\n" +
  "Version: test-version\n" +
  "Time: 2026-08-27T12:34:56\n" +
  "Error: no=9604 message=invalid product refdef shape\n" +
  "  at " + crashReportPropagated.script + ":" +
  crashReportPropagated.line + " in " + crashReportPropagated.func + "\n"
crashReportAssert(crashReportPropagatedText, crashReportPropagatedExpected,
  "propagated origin retained")
crashReportAssert(typeof(try(crashreporttest.format(17, "test", "now"))),
  "error", "non-error rejected")
print("MiniQuake2 runtime crash report tests passed: 3")
