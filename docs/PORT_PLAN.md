# MiniQuake2 Ten-Point Port Plan

Each point closes only when its gate evidence exists. Passing a unit test is
necessary but not sufficient where the gate also requires original-binary,
retail-data, visual, or soak evidence. Retail tests run only against legal,
user-supplied assets and never archive those assets.

## Implementation snapshot (2026-08-21)

G01 and G02 are complete. G03-G05 have integrated, deterministic native
implementations; all classic Steam BSPs pass the retail spawn/asset smoke while
the remaining original-differential and manual-device acceptance gates stay
open. G06-G09 now have product-shaped acceptance evidence in addition to their
API and wire-format cores: real UDP signon and map changes, two-client DM/coop,
an independent bidirectional Protocol-34 peer, deterministic OpenGL capture and
pixel diff, and an executable endgame transition slice. The product entry point
reaches `CA_ACTIVE` and renders retail BSPs through WAL textures, lightmaps,
special surfaces, transformed brush models, BSP visibility and interpolated MD2.

All 47 classic retail BSPs now pass the read-only matrix: 36,404 source
entities, 20,935 live edicts, all 138 stock class names, and no unknown or
skipped class. A real UDP map-change test retains Netchan sequence state while
resetting level state and completing a fresh signon. Exact behavior for rare
entities and monsters, dynamic-boss save restoration, paired original-renderer
pixels, and external original-process interoperability remain open. The product
lifecycle smoke reuses one Protocol-34 UDP session
across all 39 single-player maps, completing 38 map changes and re-signons;
three fresh runs produced the same 656-step/3,204-packet result. The behavior
matrix additionally proves the boss2 Jorg/Makron/counter/changelevel chain, and
two live UDP clients prove core DM and coop lifecycle semantics. G10 includes
manifest and asset/source exclusion, native Release/Debug gates, diagnostics,
retail smoke, deterministic packaging, and a 10,000-frame retail session soak
at 20.91 frames/s with zero packet rejects and bounded handles/history. Retail
input hashes and results are recorded in
`docs/RETAIL_VALIDATION.md`; the authoritative machine-readable status and
evidence paths are in `BLOCK_LEDGER.json`.

## 1. Compatibility and reference baseline — G01

Deliver the compatibility, scope, architecture, licensing, and asset contracts.
Fingerprint the exact 3.19 reference and classify every tracked source file and
C function definition by planned subsystem and scope.

Acceptance: the ledger generator and `--check` pass; the expected commit is
clean; 371 tracked files, 187 C translation units, 77 headers, and 4,525 C
function definitions are accounted for. Status: complete.

## 2. Project skeleton and reproducible build — G02

Create the `miniquake2.*` namespace, compiler/std-library discovery, debug and
release builds, native bridge build, test runner, source verifier, package
staging, and `MiniQuake2.exe` client/listen/dedicated entry modes.

Acceptance: clean-checkout builds are reproducible; a MiniLang smoke program,
empty window/event loop, and headless loop start and terminate cleanly; staging
rejects proprietary assets; licenses and manifests are present.

## 3. qcommon and engine foundations — G03

Port shared types/math, endian and buffer primitives, message IO, command
buffer/parser, console, cvars, memory/handles, PAK/search-path filesystem,
checksums/MD4, logging, errors, and host lifecycle.

Acceptance: differential fixtures against 3.19 cover success, limits, malformed
input, command ordering, cvar flags, path precedence, PAK lookup, checksums, and
error transitions. All point-3 reference functions are classified with named
MiniLang targets or approved adapters.

## 4. Formats, collision, visibility, and cinematics — G04

Implement BSP38 lumps, collision brushes/nodes/leafs, traces, contents,
clusters, PVS/PHS, areas/portals, inline models, and PAK/MD2/SP2/WAL/PCX/WAV/CIN
parsers. Every parser is length-, count-, offset-, and overflow-checked.

Acceptance: synthetic malformed corpus fails safely; user-supplied `base1.bsp`
loads; deterministic point-contents, box/point traces, visibility decompression,
headnodes, and area connectivity match the 3.19 reference.

## 5. Windows platform, input, transport, and audio — G05

Implement the narrow Win32 facade, high-resolution time, keyboard/mouse and
controller input, UDP and loopback transports, audio-device output and mixer
handoff, file/console integration, and a device-free dedicated mode.

Acceptance: isolated tests cover window lifecycle, activation, input focus,
mouse capture, monotonic time, UDP/loopback ordering and bounds, audio ring
buffer behavior, clean device loss, and headless execution. Native exports are
allowlisted and contain no gameplay/protocol policy.

## 6. Renderer API v3 and classic OpenGL renderer — G06

Implement internal v3 import/export records, registration lifecycle, BSP and
lightmaps, MD2 interpolation, brush models, sprites, particles, beams, sky,
dynamic lights, transparent/animated surfaces, 2D UI, palette/cinematics, and
video restart/mode changes.

Acceptance: API lifecycle and stale-handle tests pass; fixed-camera reference
scenes meet the documented SSIM floor and content masks; renderer restart,
resize, fullscreen/windowed transition, missing-resource handling, and long
frame loops do not leak resources.

## 7. Protocol 34 client — G07

Port connectionless handshake, netchan, serverdata, configstrings, baselines,
packet-entity/player-state deltas, user commands, prediction/error correction,
snapshot interpolation, effects, downloads, demos, UI, inventory, console,
screen composition, and cinematic control.

Acceptance: MiniQuake2 joins an original unmodified 3.19 server, enters a map,
moves with matching pmove fixtures, receives deltas/events/sounds, survives
reliable retransmission and reconnect, and plays approved original demos to the
same terminal state.

## 8. Server and internal Game API v3 — G08

Port server initialization/map changes, client lifecycle, userinfo/commands,
world linking/traces, snapshot and delta generation, PVS/PHS multicast,
downloads, demo recording, listen/dedicated modes, save orchestration, and the
complete engine side of Game API v3.

Acceptance: an original unmodified 3.19 client joins both MiniQuake2 listen and
dedicated servers, completes signon, moves, receives correct snapshots, and
survives map change/reconnect. API version/lifecycle, invalid edicts, multicast
visibility, and network back-pressure are covered deterministically.

## 9. Complete `baseq2` game module — G09

Port entity parsing/spawning, player lifecycle, items/inventory, weapons,
damage/combat, triggers, movers/targets, physics, monsters/AI, bosses, campaign
transitions, save/load, coop, and deathmatch through the internal v3 boundary.

Acceptance: a maintained map/feature matrix covers the complete base campaign
through the end boss, cross-level transitions, save/load at representative
states, every monster and weapon family, movers/triggers, coop reconnect, and
deathmatch scoring/respawn. Point-9 source functions reach verified ledger
coverage. CTF begins only after this gate is closed.

## 10. Compatibility closure, optimization, and release — G10

Run bidirectional original-binary interoperability, demo/save golden tests,
retail map traversal, renderer comparisons, malformed-input suites, client and
server soak tests, memory/handle checks, performance profiles, license review,
asset scan, source-manifest verification, and reproducible packaging.

Acceptance: G02–G09 remain green in a clean release build; no critical/high
security or correctness defect remains; performance budgets for collision,
delta processing, rendering, audio, and AI are met; staged archives contain no
proprietary data and include complete corresponding source/notices. Deferred
features are neither advertised nor silently enabled.

## Gate discipline

`BLOCK_LEDGER.json` is the machine-readable gate/risk view. A gate changes to
`complete` only with durable evidence paths and measured results. Failures are
classified as implementation defect, test/harness defect, reference dependency,
environment limitation, or scope decision. A deferral requires an explicit
scope revision; it is not a passing result.
