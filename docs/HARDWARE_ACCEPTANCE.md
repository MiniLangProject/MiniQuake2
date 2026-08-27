# Local Hardware and Performance Acceptance

This gate records real product behavior on one Windows host. It is deliberately
not presented as a multi-device compatibility matrix. Retail data is read from
the user's installation and is never copied into the repository or packages.

## Reproduce

Build the Release product and the `runtime_session_soak_tests.exe` test, then
run:

```powershell
.\scripts\hardware_acceptance.ps1 `
  -Quake2Root "C:\Games\Quake2" `
  -Map base1 -Cinematic idlog -SoakFrames 100000
```

`-SkipCinematic` and `-SkipSoak` provide a short GL-only rerun. The cinematic
gate allows at most one scheduler drop by default; `-MaximumCinematicDrops`
can tighten that policy. Decode errors, incomplete playback and failure to open
the native audio device always fail.

## Accepted host (updated 2026-08-26)

| Component | Local evidence |
|---|---|
| OS | Windows 11 Pro 64-bit, 10.0.26200 build 26200 |
| CPU | AMD Ryzen 9 9900X, 12 cores / 24 logical processors |
| Display adapters | NVIDIA GeForce RTX 5080, driver 32.0.15.9649; AMD Radeon Graphics, driver 32.0.21036.18 |
| NVIDIA desktop mode | 1920x1200 at the time of the gate |
| Audio inventory | working USB Audio, Realtek HD Audio, NVIDIA/AMD HDMI and NVIDIA Virtual Audio endpoints enumerated by Windows |

Only the active OpenGL compatibility context and the current Windows default
audio endpoint are exercised. Merely enumerating the other endpoints is not a
claim that playback ran through each one.

## Product results

- the live renderer changed from a 640x480 window to 1920x1080 exclusive fullscreen;
- a requested 3840x2160 fullscreen restart on the current 2560x1440 primary
  output remained live through the desktop-resolution borderless fallback;
- an injected replacement-window failure rebuilt the last known-good window,
  OpenGL context and renderer instead of terminating the product;
- the native window and GL context were destroyed and recreated exactly once;
- `base1` BSP/WAL/lightmap/model resources were registered again;
- Win32 desktop metrics changed to 1920x1080 for the exclusive mode and were restored on shutdown;
- visible world surfaces were exactly `68` before and after restart;
- installed `idlog.cin` reached stream frame 81 and completed exactly once;
- the final full run rendered 310 host frames, reached stream frame 81,
  completed exactly once, mixed 269,312 stereo frames and reported
  `audio-device=true`;
- that run observed one scheduler drop, while the deterministic preview
  reported zero, which establishes the bounded one-drop host policy rather
  than hiding timing variance.

Focused low-heap regressions also pass for scan-key/mouse/wheel/focus-release
input, renderer/window ownership and deterministic mixer replay. The audio
replay checksum is FNV-1a `630146404` for 2,048 PCM bytes.

## Long retail session budget

The unpaced product-shaped listen session completed:

| Metric | Result |
|---|---:|
| Retail map | `base1` |
| Frames | 100,000 |
| Server frame | 100,012 |
| Elapsed | 392,527.224 ms |
| Throughput | 254.759 fps |
| UDP packets | 212,822 sent / 212,822 received |
| Rejected packets | 0 |
| First Winsock handle delta | +3 |
| Final server command bytes | 0 |
| Validated load-menu commands | 4,988 |
| Bridge diagnostic history | bounded at 1,024 entries |

The 20,000-frame extension exposed a harness/product integration defect that
the former 10,000-frame gate did not reach: repeated single-player deaths queued
the original `menu_loadgame` engine command without a consumer. The product now
opens its Load Game page through an exact, atomic command parser. The fixed-map
soak validates and drains the same command boundary, rejects any unknown queued
command and proves a zero-byte command buffer at completion.

## External remainder

The local gate does not close testing on a second physical GPU/driver family,
explicit selection of every enumerated audio endpoint, controller hardware,
device hot-unplug/loss, alt-tab latency, manual end-to-end input latency or
hardware-gamma behavior across additional displays. The ramp is implemented
and covered by deterministic lifecycle tests, but those device-specific claims
require additional hosts or manual intervention rather than inference from
this one machine.
