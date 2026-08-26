# MiniQuake2 Compatibility Contract

This document is the normative scope contract for the first MiniQuake2
compatibility release. When an implementation shortcut conflicts with this
contract, the contract wins until it is deliberately revised together with
the ledgers and acceptance evidence.

## Canonical reference

| Property | Contract |
| --- | --- |
| Source | id Software Quake II source release, version 3.19 |
| Git commit | `372afde46e7defc9dd2d719a1732b8ace1fa096e` |
| Behavioral platform reference | Original Win32/x86 client and server |
| Target platform | Windows x64 |
| Network protocol | 34 |
| BSP format | Version 38 |
| Game module API | Version 3 |
| Renderer API | Version 3 |
| Base game | `baseq2` |

`PORT_LEDGER.json` fingerprints the reference tree and is the machine-readable
authority for its files and C function definitions. Reference-source changes
must never be silently absorbed: changing the commit requires an explicit
contract revision, a regenerated inventory, and a compatibility impact review.

## Required first-release behavior

The following behavior is release scope:

1. Windows x64 client, listen server, and headless dedicated server.
2. Original `baseq2` single-player campaign, cooperative mode, and deathmatch.
3. Protocol 34 connectionless handshake, netchan reliability and sequencing,
   configstrings, baselines, entity/player-state deltas, user commands,
   downloads, demos, prediction, interpolation, and temporary events.
4. Bidirectional network interoperability: MiniQuake2 client against the
   original 3.19 server and the original 3.19 client against MiniQuake2.
5. BSP38 collision, visibility, areas/portals, inline brush models, and the
   Quake II PAK, MD2, SP2, WAL, PCX, WAV, and CIN formats.
6. Classic OpenGL rendering of worlds, lightmaps, dynamic lights, lit MD2 models
   and planar alias shadows, brush models, sprites, beams, particles, sky, transparent/animated
   surfaces, 2D UI, console, HUD, and cinematics.
7. Keyboard, mouse, controller, UDP/loopback, audio mixing, configuration,
   console, menus, inventory, saves, and map transitions.
8. Internal Game API v3 and Renderer API v3 contracts implemented as MiniLang
   function-valued records, with the same ordering and lifecycle semantics as
   the reference interfaces.

The reference behavior includes bugs or quirks that affect wire bytes, demo
playback, map progression, scripts, save state, entity behavior, or player
movement. Security, bounds, lifetime, and 64-bit correctness fixes are allowed
when they do not change those observable contracts.

## Compatibility measurements

Compatibility is measured at stable boundaries rather than by comparing
implementation structure:

- Protocol messages, file headers, checksums, command quantization, entity
  deltas, and other deterministic encodings must match byte-for-byte.
- Collision contents, trace fraction/end position/plane, leaf/cluster,
  PVS/PHS, area connectivity, pmove state, gameplay state transitions, and
  random-seed fixtures must match the reference. Floating-point comparisons
  may use a documented tolerance before their protocol or file quantization;
  quantized output must match exactly.
- Reference demos must play to the same terminal state without parser errors,
  drift caused by message handling, or missing effects. New demos must be
  readable by the original client where Protocol 34 permits it.
- Classic renderer scenes use fixed maps, view state, cvars, resolution, and
  captured frame number. Required geometry/UI content must match, with an SSIM
  floor of 0.95 for approved reference crops. Differences must be classified;
  pixel identity is not required across drivers.
- Single-player saves must preserve gameplay across save/load and level
  transitions. Import/export of original Win32 3.19 save files is a release
  goal and must use an explicit disk-layout adapter; raw MiniLang or x64 memory
  images are forbidden. A known unsupported reference-save variant must be
  declared and tested rather than accepted silently.
- Stability requires bounded memory/handle growth and successful long-running
  client, listen-server, and dedicated-server soak tests.

## Source and module accountability

Every reference C function begins with status `reference`. As implementation
lands, its ledger status may change only when a MiniLang target or an approved
technical adapter and corresponding test evidence are named. Valid future
implementation statuses are to be defined by the verifier before first use;
`reference` must never be treated as implicit coverage.

Static helpers are included. Conditional duplicate definitions are separate
entries. Header prototypes are represented by the complete header-file
inventory but are not counted as function definitions. Assembly, Objective-C,
build metadata, and other artifacts are inventoried as files even when they
are deferred or out of scope.

## Asset contract

No proprietary Quake II data may be copied into MiniQuake2 source, tests,
fixtures, screenshots, build output, release archives, or CI artifacts. This
includes retail/shareware maps, BSP entity text, models, skins, textures,
sounds, music, cinematics, demos, player data, and CTF content.

The reference repository contains three files below `baseq2/`; they are marked
`asset_excluded` and `do_not_redistribute` in the ledger. They are reference
metadata only and may not be copied into a MiniQuake2 package.

Retail validation accepts a user-provided `-basedir` and writes results that do
not embed the source assets. Synthetic fixtures must be independently created,
small, and documented. Hashes, dimensions, aggregate metrics, and textual test
results may be stored; extracted proprietary payloads may not.

Release packaging must fail closed if it encounters `pak*.pak`, retail BSP,
MD2, WAL, PCX, WAV, CIN, DM2, or other unapproved data beneath the package
staging root.

## Licensing contract

The id Software source release is GPL-2.0-or-later. MiniLang code derived from
or translating that source must be distributed under compatible terms, with
complete corresponding source and retained notices. The special RSA Data
Security attribution in `qcommon/md4.c` must remain attached to an MD4-derived
implementation. Third-party native libraries require a recorded license and
redistribution review before inclusion.

The GPL source grant does not grant rights to Quake II game data or trademarks.
The product and documentation must state that MiniQuake2 is an unofficial port
and requires legally obtained game data.

## Explicitly deferred scope

- CTF source and data.
- Loading original native `gamex86.dll` mods.
- Loading original native renderer DLLs through their binary ABI.
- Software renderer parity and its x86 assembly optimizations.
- Linux, IRIX, Solaris, Rhapsody/macOS, and other non-Windows targets.
- Direct3D 9, Vulkan, high-resolution UI, enhanced lighting, texture
  replacement/upscaling, music formats or playlist features beyond the
  implemented `CS_CDTRACK` OGG replacement path, and other modernization
  features.
- Compatibility with later Quake II protocols, rereleases, or source ports
  unless separately profiled.

Deferred work must not weaken Protocol 34 or base-game compatibility. It is
activated only by revising the scope and adding dedicated acceptance gates.

## Non-goals

The first release does not promise binary layout identity between C structs and
MiniLang values, timing-identical packet arrival, driver-identical pixels, or
support for undocumented native mods that depend on address layout, undefined
behavior, or x87 precision accidents. It does promise the observable,
versioned contracts above.
