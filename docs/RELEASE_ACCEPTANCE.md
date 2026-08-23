# MiniQuake2 Release Acceptance

This document records the reproducible local acceptance gate for the current
`0.5.0-foundation` compatibility release. Retail data remains external and is
never copied into either archive.

## 2026-08-22 acceptance run

The release gate was executed from a clean `main` worktree at implementation
commit `8e3800e`:

```powershell
.\scripts\test.ps1 -Configuration Release
```

The run completed in 2,139.1 seconds and passed:

- MiniLang syntax for 341 files;
- source inventory and exact manifest membership for 384 maintained files;
- verifier self-tests and source/build hygiene;
- all 151 native contract, integration, renderer, multiplayer and soak test
  programs, freshly compiled and executed;
- the Release product build plus version, diagnostics, capabilities and CLI
  smokes.

Retail-dependent tests without an explicit installation argument reported
`SKIP`, as designed. Their installed-data counterparts are covered separately
by the recorded 47-map spawn sweep, 39-map product session gate,
39-BSP/51-transition two-client cooperative checkpoint gate, the 39-map
physical-input matrix and the 20,000-frame local hardware/session acceptance.

The Debug product graph was then compiled with preflight and post-build
inventory:

```powershell
.\build.ps1 -Configuration Debug -SkipTests
```

It passed with trace calls enabled and a clean post-build inventory. The full native matrix was not redundantly
recompiled in Debug after the immediately preceding complete Release run.

## Package gate

The freshly accepted Release executable was packaged twice:

```powershell
.\scripts\package.ps1 -SkipBuild
```

Both runs passed archive policy checks and executed diagnostics plus CLI smoke
from a separately extracted Win64 ZIP. SHA-256 comparison of the two Win64
archives and of the two source archives was byte-identical. The source archive
contains all maintained MiniLang, native bridge, test, tool and documentation
files but no retail assets or original reference source. Exact final hashes are
reported by the release handoff rather than embedded here, because this file is
itself part of the source package.

## Local hardware and performance gate

The accepted Release product additionally passed the reproducible local host
gate on Windows 11, Ryzen 9 9900X and an NVIDIA RTX 5080 compatibility context:

- real 640x480 window to 1280x720 fullscreen GL/window/context restart;
- identical 60 visible `base1` surfaces before and after registration rebuild;
- complete `idlog.cin` decode/render/mix through the opened default audio
  device, with zero drops in the accepted rerun;
- 20,000 unpaced retail session frames at 43.89 fps, 40,740/40,740 packets,
  zero rejects, bounded histories and zero residual engine-command bytes.

The extended soak exposed and closed the previously unconsumed
`menu_loadgame` AddCommandString boundary. See
[`HARDWARE_ACCEPTANCE.md`](HARDWARE_ACCEPTANCE.md) for exact measurements and
the reproducible command.

## Remaining external acceptance

This gate closes the deterministic local build/package and single-host
performance portion of P12. It does not claim completion of the remaining
external work: a second physical GPU/driver family, explicit alternate audio
endpoints, hot-unplug/device-loss, controller hardware, manual input latency,
multi-host networking, or process interoperability with an original executable
on a compatible host.
