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
  -Map base1 -Cinematic idlog -SoakFrames 20000
```

`-SkipCinematic` and `-SkipSoak` provide a short GL-only rerun. The cinematic
gate allows at most one scheduler drop by default; `-MaximumCinematicDrops`
can tighten that policy. Decode errors, incomplete playback and failure to open
the native audio device always fail.

## Accepted host (2026-08-22)

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

- the live renderer changed from a 640x480 window to 1280x720 fullscreen;
- the native window and GL context were destroyed and recreated exactly once;
- `base1` BSP/WAL/lightmap/model resources were registered again;
- visible world surfaces were exactly `60` before and after restart;
- installed `idlog.cin` reached stream frame 81 and completed exactly once;
- the accepted rerun rendered 358 host frames, dropped zero stream frames,
  mixed 254,976 stereo frames and reported `audio-device=true`;
- a separate same-build run observed one scheduler drop while still completing
  and producing 258,048 mixed frames, which establishes the bounded one-drop
  host policy rather than hiding timing variance.

Focused low-heap regressions also pass for scan-key/mouse/wheel/focus-release
input, renderer/window ownership and deterministic mixer replay. The audio
replay checksum is FNV-1a `630146404` for 2,048 PCM bytes.

## Long retail session budget

The unpaced product-shaped listen session completed:

| Metric | Result |
|---|---:|
| Retail map | `base1` |
| Frames | 20,000 |
| Server frame | 20,014 |
| Elapsed | 455,711.083 ms |
| Throughput | 43.887 fps |
| UDP packets | 40,740 sent / 40,740 received |
| Rejected packets | 0 |
| First Winsock handle delta | +3 |
| Final server command bytes | 0 |
| Validated load-menu commands | 987 |
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
device hot-unplug/loss, alt-tab latency, manual end-to-end input latency or the
persisted-but-unimplemented hardware gamma ramp. Those require additional hosts
or manual device intervention and remain release-handoff items rather than
being inferred from this one machine.
