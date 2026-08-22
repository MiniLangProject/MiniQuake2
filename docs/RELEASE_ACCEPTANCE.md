# MiniQuake2 Release Acceptance

This document records the reproducible local acceptance gate for the current
`0.5.0-foundation` compatibility release. Retail data remains external and is
never copied into either archive.

## 2026-08-22 acceptance run

The release gate was executed from a clean `main` worktree at implementation
commit `ae5ef19`:

```powershell
.\scripts\test.ps1 -Configuration Release
```

The run completed in 2,016.6 seconds and passed:

- MiniLang syntax for 335 files;
- source inventory and exact manifest membership for 373 maintained files;
- verifier self-tests and source/build hygiene;
- the complete native contract, integration, multiplayer and soak matrix;
- the Release product build plus version, diagnostics, capabilities and CLI
  smokes.

Retail-dependent tests without an explicit installation argument reported
`SKIP`, as designed. Their installed-data counterparts are covered separately
by the recorded 47-map spawn sweep, 39-map product session gate and the
39-BSP/51-transition two-client cooperative checkpoint gate.

The Debug product graph was then compiled with preflight and post-build
inventory:

```powershell
.\build.ps1 -Configuration Debug -SkipTests
```

It passed with trace calls enabled. The full native matrix was not redundantly
recompiled in Debug after the immediately preceding complete Release run.

## Package gate

The freshly accepted Release executable was packaged twice:

```powershell
.\scripts\package.ps1 -SkipBuild
```

Both runs passed archive policy checks and executed diagnostics plus CLI smoke
from a separately extracted Win64 ZIP. SHA-256 comparison of the two Win64
archives and of the two source archives was byte-identical. Exact hashes are
reported by the release handoff rather than embedded here, because this file is
itself part of the source package.

## Remaining external acceptance

This gate closes the deterministic local build/package portion of P12. It does
not claim completion of the remaining hardware-dependent work: broader GPU and
audio-device coverage, fullscreen/device-loss recovery, manual input latency,
multi-host networking, final performance budgets, or process interoperability
with an original executable on a compatible host.
