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
the earlier lifecycle trace without a failure. The current complete attack-timeline
build completes in 689 steps and 3,376 processed packets after restoring exact
boss refires, aim state and monster muzzle/effect behavior while publishing the
complete stock gib-model inventory. An executable
goal-route gate additionally visits all 39 unique BSPs in their canonical
branched order through 51 real objective-confirmed map changes, retaining one
Protocol-34 session and completing every re-signon without a direct
`target_changelevel` fallback. It drives the existing key, counter, timer,
trigger, monster-death and boss state machines and terminates at `victory.pcx`;
it intentionally abstracts player navigation and uses deterministic damage for
goal-bound monsters. An executable campaign matrix covers every retail classname and proves the `boss2`
Jorg-to-Makron-to-changelevel chain across a versioned save/restore boundary.
The retail behavior matrix now classifies `point_combat`, `trigger_key`,
`target_actor`, `target_character`, `target_string`, `func_clock` and
`trigger_elevator` as functional world state machines. The following stock pass
also closes `target_lightramp`, `func_killbox`, the Viper/bomb set piece, the
remaining decorative thinkers, `info_notnull`, `light_mine2`, and all 60
`misc_insane` entities. Scripted boss props and the coupled
`turret_base`/`turret_breach`/`turret_driver` rigs close the final retail
class-state-machine tail: the 39-map behavior matrix now reports zero
explicitly simplified instances or classes. Their live Game-API path now uses
the current skill for stock reaction time and 550/600/650/700 rocket speed,
consumes the shared CRT stream for damage, positions the launch sound at the
muzzle, retains crush knockback 10, accepts `DAMAGE_AIM` combat and emits the
Infantry seven-gib inventory on driver death. All 21 combat-capable monster
classes present in those BSPs, plus the dynamically spawned Makron, now route
 through validated 3.19 damage/speed profiles and real MiniLang melee, hitscan,
 rail, blaster or rocket emission. Every combat-capable family now uses a stock
 frame-relative attack, melee or drain timeline with projected MD2 frames. This
 includes live Gunner, Medic, Chick, Flyer, Hover, Tank, Soldier, Supertank and
 boss refire callbacks, the conditional Brain tentacle chain, the Mutant jump,
 the Gladiator's saved rail aim, all close-combat loops and the Parasite's
 ordered damage/beam frames. The attack tables also execute their exact 3.19
 `ai_charge`/`ai_move` distance columns, held-frame rules and mechanical sound
 callbacks; every spawned stock monster publishes its original sound inventory
 before signon, including the Makron assets needed by a dying Jorg. The same stock
layer now covers 63 pain variants, 43 normal-death variants, the original
duck/dodge ranges for the six supporting families, and stand, idle, walk and run
MD2 ranges for all 22 combat entries. All 1,813 pain/death frames execute their
original movement columns. Their live callbacks reproduce the Tank, Jorg and
Makron step/thud/taunt/terminal sounds, Infantry's twelve-frame death machinegun
sweep, the three Soldier death-weapon families and the exact Supertank, Boss2
and Jorg explosion-entry frames. All reachable secondary stock locomotion/
fidget callbacks are active as well, including Soldier idle/walk branches,
Medic corpse scans, Parasite taps/scratch loops, Jorg steps and Tank run start.
Stock terminal deaths apply the original class-specific corpse bounds, export
the original organic and metallic gib-model inventories as timed physics
edicts, and reproduce the eight-step boss explosion sequence before the final
14-part breakup. Ground, step, partial-ground, fly/swim and water-boundary
movement now follows the original collision-bound `m_move.c` path against BSP,
inline brushes and dynamic boxes. Lost enemies are pursued through the original
eight-marker PlayerTrail and left/right course correction rather than a direct
transform. The physical retail path sustains 190.20 unpaced server frames/s in
the accepted 5,000-frame `base1` gate and 68.31 frames/s across 500 frames in
the dense `lab` map. Swept traces use Quake II's near-first BSP hull walk on a
fixed stack, and inline brushes are rejected by cached swept bounds before any
model transform or hull trace. Fixed sound storage also avoids array
concatenation and drains transient/PHS-filtered events without backlog.
Private-Save v14 resumes attacks and active reactions at their next
frame, preserves held death-fire bursts, live refire, jump, saved-aim,
shared-random, Medic ownership, live turret sight/reaction state and all
lost-sight pursuit fields, and round-trips live dynamic gib records. Client
impact feedback follows the Quake II 3.19 temp-entity and muzzleflash switches:
smoke/flash pairs, directional blaster models, explosion model/frame/base
variants, layered player-weapon sounds, monster-family sounds, attenuation and
Rogue effects are covered by Protocol-34 goldens. Transient particles append
into one reusable 4,096-slot pool instead of copying the live array for every
effect. Rail/Debug/Forcewall/Bubble trails, Steam/Smoke, login/logout/item
respawn, teleports, Widow splash and Widow/Nuke sustained effects now use their
stock spatial, gravity, color and alpha algorithms on the original Win32 CRT
random sequence; one-frame particles are consumed after renderer handoff.
Moving snapshot entities now add their stock Rocket/Blaster/grenade/gib/flag/
Tag/Tracker/Ion trails and projectile lights from a fixed per-client trail
table, while BFG/Plasma/sphere translucency follows the original effect bits.
Color-Shell/Powerscreen overlays, isolated linked-model flags, automatic
animation/rotation and the BFG/Fly/Trap/persistent-Teleporter/spinning-light
tail are also active without per-frame particle-array concatenation. The
player renderer now consumes live player configstrings for custom MD2/PCX
model/skin pairs, resolves the stock `#w_*.md2` visible-weapon table from the
packed snapshot skin word, uses original packed `RF_BEAM` color selection and
applies the Rogue male/female/cyborg disguise override. It hides the local
third-person player plus linked weapon while retaining the
first-person view weapon. A two-client UDP arsenal gate proves the visible
weapon index for every stock weapon in both reconstructed snapshots. The
original class-level sight/search callback inventory, sound
channels/attenuation and callback-local random branches are active, including
Makron's silent 13-frame activation, Mutant's CRT-driven step choice and
Soldier's sight-triggered `attack6` plus dodge-triggered `attack3` timelines.
Medic corpse selection follows the original 1,024-unit visible/unowned
strongest-patient rule and runs the full `attack33..60` cable, sound,
Protocol-34 beam and in-place resurrection path.
 Muzzle and beam events travel through the typed
Game-API multicast queue, PVS/PHS routing and real Protocol-34 UDP into client
DLight/sound handoff; `misc_insane` and the two scripted props are intentionally
non-combat states. The complete stock player-weapon set now uses its original
fire-frame boundaries, handed muzzle offsets, recoil, damage split, PlayerNoise,
silencing and Protocol-34 muzzle/impact feedback. Cooked hand grenades are live,
and bolts, grenades, rockets and BFG shots own reusable networked engine edicts
with model/effect/loop-sound state. Two real local UDP clients
complete cooperative item/disconnect/reconnect scenarios; the deathmatch gate
now sees a moving Blaster bolt in both snapshots, kills a 100-health peer
through seven genuine UDP Blaster commands, observes muzzle/sound/blood
handoffs on both clients and respawns through the normal attack latch. A second
two-client gate performs a reliable spectator-to-player transition, frag-limit
maplist rotation, full re-signon and a 500-frame post-change soak without
rewinding the live Netchans. A complete UDP arsenal matrix fires all ten stock
guns plus the cooked hand grenade, checking bilateral effects/projectile
visibility, ammo consumption and a 300-frame transport tail.
The same harness now scales from two through eight local peers; its four-client
gate covers simultaneous signon/telefrag recovery, two disconnect/reconnect
cycles, full snapshot visibility, a channel-preserving four-player checkpoint,
map re-signon and a 500-frame steady-state tail.
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
The same persistence boundary now also saves and restores both players in a
live cooperative session without replacing either client or server Netchan;
skill endpoints, shared key state, teammate damage and a post-restore UDP soak
are covered by a dedicated native gate. A full installed-retail matrix extends
that evidence across 39 campaign BSPs, 51 goal-confirmed transitions and 39
two-player checkpoints. v10 introduced length-prefixed retail entity text and
dynamic world references; v11 added in-flight boss aim/refire plus Win32
random-stream state; v12 added transient monster AI, old-enemy and owner
references required to resume a Medic cable safely; v13 added the world
combat/AI/cooldown fields required to resume a coupled turret without resetting
its target cadence; v14 retains v7-v13 readers and adds collision movement,
velocity, last-sighting, trail and temporary pursuit-goal state.
The product `--cinematic` path now plays installed retail CIN files through
the original 14-fps timing, palette upload, OpenGL raw-frame presentation and
managed PCM mixer/native device lifecycle. A complete `idlog.cin` run reached
frame 81 once with zero drops and restored the game palette on completion.
Classic `+nextserver` strings now drive CIN, PCX and named-spawn map steps;
the interactive loop consumes the validated `gamemap` queued at intermission.
The same executor now plays the installed release DM2 files through the live
snapshot/effect/renderer/audio path. `demo1.dm2` completes all 696 packets and
688 rendered frames on `base2`; its historical Protocol-26 frame layout is
accepted only inside the demo session, while every network connection remains
strict Protocol 34. Heavyweight DM2-to-map chains preserve the window and GL
context but reset renderer-owned managed state between BSPs.
The same product UI now applies mouse sensitivity, always-run and mixer volume
live, renders named `svc_inventory` contents, forwards game/chat commands, and
provides three failure-atomic persistent Save/Load slots, live video-mode
restart, arbitrary key capture and difficulty-aware New Game reconstruction. See
[`docs/UI_AUDIO_ACCEPTANCE.md`](docs/UI_AUDIO_ACCEPTANCE.md) for the exact
remaining hardware-gamma and save-slot presentation boundary. Product settings
and bindings persist through a strict, bounded `miniquake2.cfg` format.
An independent raw Protocol-34 peer validates both client and server wire
directions. Deterministic OpenGL readback produces stable TGA captures, and a
native x86 API-v3 host now drives the installed unmodified classic `ref_gl.dll`
at matching cameras. The paired `base1`, `waste1` and `cool1`
world/water/alpha/MD2 scenes
pass their documented 0.4% mean-error ceiling after restoring the original
`intensity=2` material rule; JSON metrics and heatmaps remain build artifacts.
The unpaced full retail session now passes 20,000 frames at 43.89 frames/s with
40,740 accepted packets, zero rejected packets, a zero-byte engine-command
buffer and bounded diagnostic/event histories. The local RTX-5080/Windows host
also passes a real 640x480-window to 1280x720-fullscreen GL restart and complete
native-device `idlog.cin` playback; see
[`docs/HARDWARE_ACCEPTANCE.md`](docs/HARDWARE_ACCEPTANCE.md).

These results are strong vertical-slice and compatibility evidence, not a claim
that every original campaign behavior or pixel is already identical. The
remaining release work is concentrated in original-process interoperability
(the installed 3.20 executable exits before networking on this host), paired
original player view-model/recoil and full encounter traces beyond the fixed
renderer/sequence fixtures, broader multi-host GPU/device coverage, exhaustive
turret/boss interaction playthroughs, and manual device acceptance. Retail
class, stock monster damage-emission, pain/death movement and reachable
secondary callback coverage are closed, but that is deliberately narrower than
a full campaign playthrough or frame-for-frame whole-session AI parity claim.

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
.\MiniQuake2\build\MiniQuake2.exe --cinematic "C:\Games\Quake2" idlog 0 0
.\MiniQuake2\build\MiniQuake2.exe --demo "C:\Games\Quake2" demo1.dm2 0
.\MiniQuake2\build\MiniQuake2.exe --media-sequence "C:\Games\Quake2" "end.cin+victory.pcx" 0
.\MiniQuake2\build\MiniQuake2.exe --dedicated "C:\Games\Quake2" base1 27910 0
.\MiniQuake2\build\MiniQuake2.exe --listen "C:\Games\Quake2" base1 600
.\MiniQuake2\build\MiniQuake2.exe --connect 127.0.0.1 27910 600
.\MiniQuake2\scripts\campaign_smoke.ps1 -Quake2Root "C:\Games\Quake2"
.\MiniQuake2\scripts\physical_campaign_smoke.ps1 -Quake2Root "C:\Games\Quake2"
.\MiniQuake2\scripts\session_soak.ps1 -Quake2Root "C:\Games\Quake2" -Frames 10000
.\MiniQuake2\scripts\hardware_acceptance.ps1 -Quake2Root "C:\Games\Quake2" -SoakFrames 20000
```

The first command validates a real PAK/BSP38/MD2/WAV set and executes one
server/Game-API frame. The second opens the free-camera OpenGL BSP preview. The
third starts the interactive local vertical slice; `0` keeps it open until the
window is closed. Controls are `W/A/S/D`, mouse look, `Space`/`C` for vertical
movement, `Shift` for speed, mouse button 1 to attack, and `E` to use.
The demo command plays an installed DM2 to completion; a positive frame count
is a deterministic visual preview gate.
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

The physical campaign smoke starts a fresh real UDP client/server session for
each of the 39 stock single-player BSPs. Every map must accept decoded movement
and attack UserCmds, produce PMove displacement, fire through Weapon_Generic,
publish snapshots and reject zero packets. It records item deltas and deaths
without treating an expected combat/environment death as a transport failure.

## Project contracts

- [Compatibility, scope, and asset contract](docs/COMPATIBILITY_CONTRACT.md)
- [Architecture decisions](docs/ARCHITECTURE.md)
- [Ten-point implementation and acceptance plan](docs/PORT_PLAN.md)
- [Release, Debug and deterministic package acceptance](docs/RELEASE_ACCEPTANCE.md)
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
