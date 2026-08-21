# MiniQuake2

MiniQuake2 is an executable Windows x64 port of Quake II 3.19 to MiniLang.
The engine, client, server, renderer front end, and `baseq2` game logic are to
be implemented in MiniLang. Native code is restricted to thin operating-system
and device bridges.

> [!IMPORTANT]
> MiniQuake2 does not include Quake II game data. You must own and supply a
> legal Quake II installation containing `baseq2/pak0.pak`. Retail maps,
> models, textures, sounds, cinematics, music, player data, and CTF data must
> never be committed to or distributed with this project.

## Current status

The integrated native MiniLang executable now links the qcommon foundation,
strict retail-format loaders, BSP38 collision/visibility, Win32 platform
bridges, PCM mixer, Protocol 34/Netchan and UDP runtime, snapshot client/server,
PMove, Renderer API v3 plus an OpenGL 1.1 asset/geometry path, Game API v3,
entity spawning, persistence, player/view/environment logic,
items/weapons/ballistics/combat, movers/targets, and the data-driven monster/AI
core. A transactional client dispatcher joins snapshots, effects, demos,
downloads, console/HUD messages and UI; real loopback UDP tests complete the
challenge/connect/configstring/baseline/begin/snapshot path. Every maintained
MiniLang test is compiled and executed by `build.ps1`; no proprietary data is
required for that suite.

The current product vertical slice loads the user-owned classic PAKs, prepares
a BSP with WAL textures and static lightmaps, starts an internal
Protocol-34 listen server through Game API v3, reaches `CA_ACTIVE`, registers
configstring-driven MD2/PCX models and WAV sounds, submits snapshots/effects/UI
to the renderer and mixer, and accepts live movement commands. BSP PVS,
frustum, area and backface selection now bound the submitted world surfaces;
sky, warp/turbulence, flowing, translucent world passes and transformed inline
brush models are integrated. The read-only campaign gate now parses and spawns
all 47 classic retail BSPs (39 single-player and 8 deathmatch): 36,404 source
entities across all 138 stock class names produce 20,935 live edicts with zero
unknown or skipped classes. Normal map changes retain Netchan sequencing and
perform a complete reconnect/signon; server restarts establish a fresh sequence
generation. A persistent internal UDP session now loads, spawns, signs on and
changes through all 39 single-player maps; three fresh product runs completed
the earlier lifecycle trace without a failure. The current attack-sequence
build completes in 660 steps and 3,229 processed packets. An executable
campaign matrix now covers every retail classname and proves the `boss2`
Jorg-to-Makron-to-changelevel chain across a versioned save/restore boundary.
The retail behavior matrix now classifies `point_combat`, `trigger_key`,
`target_actor`, `target_character`, `target_string`, `func_clock` and
`trigger_elevator` as functional world state machines. The following stock pass
also closes `target_lightramp`, `func_killbox`, the Viper/bomb set piece, the
remaining decorative thinkers, `info_notnull`, `light_mine2`, and all 60
`misc_insane` entities. Scripted boss props and the coupled
`turret_base`/`turret_breach`/`turret_driver` rigs close the final retail
class-state-machine tail: the 39-map behavior matrix now reports zero
explicitly simplified instances or classes. All 21 combat-capable monster
classes present in those BSPs, plus the dynamically spawned Makron, now route
through validated 3.19 damage/speed profiles and real MiniLang melee, hitscan,
rail, blaster or rocket emission. Infantry, Gunner, the three Soldier variants,
Jorg and Boss2 additionally use stock frame-relative weapon-event timing and
MZ2 sequences; Private-Save v5 resumes a running sequence at its next
event. Other monster families retain the validated single-emission profile and
remain explicit frame-parity work. Muzzle events travel through the typed
Game-API multicast queue, PVS/PHS routing and real Protocol-34 UDP into client
DLight/sound handoff; `misc_insane` and the two scripted props are intentionally
non-combat states. Two real local UDP clients
complete cooperative item/disconnect/reconnect scenarios; the deathmatch gate
now kills a 100-health peer through seven genuine UDP Blaster commands and
respawns it through the normal attack latch.
Game-API `unicast`, `cprintf` and `centerprintf` now use a separate bounded
per-client queue: reliable text is ACK-retained, unreliable service commands
remain sequenced, and transactional client handoff exposes prints only to the
target slot.
An active-session persistence gate writes and restores both Game and Level
images without resetting the live UDP/Netchan sequence, then proves the next
snapshot and failure-atomic rollback after a deliberately corrupted private
payload.
Cross-map checkpoints additionally perform a transactional map change, full
Protocol-34 re-signon, Game+Level restore and a valid next snapshot; a failed
target restore returns to the source map with a new legal spawn epoch while
Netchan sequences only move forward.
An independent raw Protocol-34 peer validates both client and server wire
directions, and deterministic OpenGL readback produces stable TGA captures,
JSON pixel metrics and heatmaps. The unpaced full retail session passes 10,000
frames at 20.91 frames/s with 20,391 accepted packets, zero rejected packets
and bounded diagnostic/event histories.

These results are strong vertical-slice and compatibility evidence, not a claim
that every original campaign behavior or pixel is already identical. The
remaining release work is concentrated in original-process interoperability
(the installed 3.20 binary exits before networking on this host), paired
original `ref_gl` reference captures, the remaining monster/weapon/turret/boss
model-animation sequencing and remaining per-frame/refire event exactness, and manual device
acceptance. Retail class and stock monster damage-emission coverage are closed,
but that is deliberately narrower than a full campaign
playthrough or frame-for-frame AI parity claim.

The canonical local reference remains commit
`372afde46e7defc9dd2d719a1732b8ace1fa096e`. Its 4,525 C definitions remain in
[`PORT_LEDGER.json`](PORT_LEDGER.json) as a reference inventory; implementation
gate status and remaining interoperability/visual/campaign evidence are tracked
separately in [`BLOCK_LEDGER.json`](BLOCK_LEDGER.json); the player-facing
scenario baseline is [`docs/PLAYABILITY_MATRIX.md`](docs/PLAYABILITY_MATRIX.md).
A green unit suite is
not by itself a claim of complete original-client/server, visual, or campaign
parity.

The first playable release targets:

- Quake II 3.19 behavior and Protocol 34.
- BSP version 38 and the original Quake II asset formats.
- Game API v3 and Renderer API v3 semantics through internal MiniLang records.
- Original 3.19 client/server interoperability.
- The complete `baseq2` campaign, save/load, cooperative play, and deathmatch.
- Windows x64, an OpenGL compatibility renderer, and listen/dedicated servers.

CTF, native `gamex86.dll`/renderer DLL compatibility, the software renderer,
non-Windows targets, and additional graphics backends are explicitly deferred
until the base compatibility release is closed.

## Build and run

From the workspace root:

```powershell
.\MiniQuake2\build.ps1 -UpdateManifest
.\MiniQuake2\build\MiniQuake2.exe --capabilities
.\MiniQuake2\scripts\package.ps1 -SkipBuild
```

With a legal Quake II installation root containing `baseq2\pak0.pak`:

```powershell
.\MiniQuake2\build\MiniQuake2.exe --asset-smoke "C:\Games\Quake2" base1
.\MiniQuake2\build\MiniQuake2.exe --map-preview "C:\Games\Quake2" base1 600
.\MiniQuake2\build\MiniQuake2.exe --play "C:\Games\Quake2" base1 0
.\MiniQuake2\build\MiniQuake2.exe --dedicated "C:\Games\Quake2" base1 27910 0
.\MiniQuake2\build\MiniQuake2.exe --listen "C:\Games\Quake2" base1 600
.\MiniQuake2\build\MiniQuake2.exe --connect 127.0.0.1 27910 600
.\MiniQuake2\scripts\campaign_smoke.ps1 -Quake2Root "C:\Games\Quake2"
.\MiniQuake2\scripts\session_soak.ps1 -Quake2Root "C:\Games\Quake2" -Frames 10000
```

The first command validates a real PAK/BSP38/MD2/WAV set and executes one
server/Game-API frame. The second opens the free-camera OpenGL BSP preview. The
third starts the interactive local vertical slice; `0` keeps it open until the
window is closed. Controls are `W/A/S/D`, mouse look, `Space`/`C` for vertical
movement, `Shift` for speed, mouse button 1 to attack, and `E` to use.
The package script emits deterministic, asset-scanned binary and corresponding
source ZIPs, then extracts and starts the shipped executable for diagnostics and
CLI smoke checks. The source archive also carries the exact shared native-bridge
sources used by the two DLLs.

The campaign script never extracts or copies retail data. It inventories map
and classname counts directly from the PAK/BSP directories, self-tests that
parser, then runs every discovered BSP through the built executable's
Game-API/asset smoke. By default any failed map or skipped entity fails the
gate; `-AllowSkipped` is available only for diagnostic work on incomplete
branches. A machine-readable report can be requested with `-Json PATH`.

## Project contracts

- [Compatibility, scope, and asset contract](docs/COMPATIBILITY_CONTRACT.md)
- [Architecture decisions](docs/ARCHITECTURE.md)
- [Ten-point implementation and acceptance plan](docs/PORT_PLAN.md)
- [Player-facing playability and parity matrix](docs/PLAYABILITY_MATRIX.md)
- [Reference inventory method and counts](docs/reference/README.md)
- [Known risks and release-blocking gates](BLOCK_LEDGER.json)
- [License terms](LICENSE.md) and [retained notices](NOTICE.md)

## Rebuilding the reference ledger

From the workspace root:

```powershell
python MiniQuake2\docs\reference\generate_port_ledger.py `
  --reference-root MiniQuake2\Quake-2-original-source `
  --output MiniQuake2\PORT_LEDGER.json

python MiniQuake2\docs\reference\generate_port_ledger.py `
  --reference-root MiniQuake2\Quake-2-original-source `
  --output MiniQuake2\PORT_LEDGER.json `
  --check
```

The generator refuses a different reference commit or a dirty reference
worktree. This keeps source-to-port accountability deterministic.

## Licensing and attribution

The reference source is licensed by id Software under GPL-2.0-or-later. A port
derived from it must retain the applicable notices and satisfy the GPL source
distribution obligations. The MD4 implementation also carries an RSA Data
Security notice which must be retained wherever that implementation is used.
Quake II game data remains under its original proprietary terms and is not
covered by the source-code license. MiniQuake2 is unofficial and is not
affiliated with or endorsed by id Software or ZeniMax Media.
