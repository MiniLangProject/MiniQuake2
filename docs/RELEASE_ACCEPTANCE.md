# MiniQuake2 Release Acceptance

This document records the reproducible local acceptance gate for the current
`0.5.0-foundation` compatibility release. Retail data remains external and is
never copied into either archive.

## 2026-08-23 collision-bound monster movement and pursuit acceptance run

The Release product and all 153 native test programs were freshly rebuilt and
executed after porting the remaining shared Quake II 3.19 monster movement and
lost-sight pursuit machinery:

```powershell
.\build.ps1 -Configuration Release -SkipPreflight
.\build.ps1 -Configuration Release -PreflightOnly
```

Both commands exited with code 0. The strict gate passed MiniLang syntax for
349 files, exact manifest membership for 392 maintained files and verifier
self-tests. `ai/move.ml` now supplies the collision-bound `SV_movestep`,
`SV_StepDirection`, `SV_NewChaseDir`, `M_MoveToGoal`, `M_walkmove`, ground,
bottom, water and drop-to-floor behavior. Live GameImport traces combine the
retail BSP and inline-brush hulls with swept dynamic `SOLID_BBOX` edicts, link
successful moves and touch triggers through indexed inline-brush and trigger
sets. The BSP collision hot path ports `CM_RecursiveHullCheck` as a near-first,
fraction-pruned iterative DFS on fixed per-map scalar stacks; only stationary
position tests retain a fixed leaf scratch table, and an original-style brush
check generation suppresses duplicate clips. The server mirrors
`SV_AreaEdicts` by rejecting remote inline brushes against cached swept bounds
before allocating a basis or entering their hull. The hottest brush clip is
explicitly inline and ordinary BBOX link bounds are updated in place. An
explicit engine/game readiness bit keeps the supported asset-free harness
deterministic while every retail BSP remains on the physical path.

The AI run path now uses the original eight-marker `PlayerTrail`,
`AI_LOST_SIGHT`, `AI_PURSUIT_LAST_SEEN`, `AI_PURSUE_NEXT` and
`AI_PURSUE_TEMP` transitions, search timeout, left/right course traces and
cooperative reacquisition. Private-Save v14 retains v7-v13 readers and restores
the pursuit timestamps, last sighting, saved goal, temporary goal, yaw,
partial-ground and velocity state. Focused regressions prove floor/step/drop,
fly/swim boundaries, dynamic blockers, a closed inline BSP door, trigger touch,
trail selection and mid-pursuit restore.

Sound delivery now uses fixed 1,024-event storage, indexed counts and
preallocated per-client plans instead of array concatenation. PHS-filtered
events are consumed as intentional no-plans, while ordinary unreliable sounds
behind a full reliable fragment are dropped with Quake II datagram semantics
rather than retained as false backpressure. The dedicated routing regressions
and dense `lab` runtime both finish with zero pending sounds.

The two final 5,000-frame synthetic soak passes sustained 3,912.44 and 3,859.94
fps with 10,027/10,027 packets each, zero pending sounds, zero rejects and
process-handle deltas of 3/0. The movement-enabled installed-retail `base1`
gate completed 5,000 frames through server frame 5,015 in 29,621.971 ms
(168.79 fps), with 10,385/10,385 packets, zero rejects, a drained command
buffer and zero pending sounds. The dense installed-retail `lab` gate completed
500 frames in 10,384.3258 ms (48.15 fps), with 1,136/1,136 packets, zero
rejects and zero pending sounds. This supersedes both the initial 13.48-fps
physical-movement measurement and the intermediate 6.70-fps all-inline-brush
trace measurement.

The final product also passed the installed classic retail inventory and
session gates with 47 maps, 36,404 raw entities, 20,935 live edicts, zero
skipped classes, a 39/39 physical-input map matrix and this persistent campaign
result:

```text
campaign: maps=39 changes=38 client-state=4 spawn-count=39 steps=753 packets=3690
```

## 2026-08-23 monster sensing and PlayerNoise acceptance run

The Release product and all 152 native test programs were freshly rebuilt and
executed after replacing the remaining generic AI sensing placeholders with the
Quake II 3.19 collision, hearing and sound-target behavior:

```powershell
.\build.ps1 -Configuration Release -SkipPreflight
.\build.ps1 -Configuration Release -PreflightOnly
```

Both commands exited with code 0. The strict gate passed MiniLang syntax for
346 files, exact manifest membership for 389 maintained files and verifier
self-tests. The product-shaped inline-brush regression proves that a live door
blocks both the eye-to-eye `MASK_OPAQUE` visibility trace and the exact
`M_CheckAttack` shot mask, then restores sight and fire after moving away. The
AI scenarios cover one-frame sight publication, the five-second
`AI_SOUND_TARGET` lifetime and the `AI_BRUTAL` -80 health threshold.

Player weapon integration now retains the original two reusable
`player_noise` objects per player, separates primary and impact noise, records
the actual linked BSP area and position, suppresses weapon noise for silenced
shots, deathmatch and `FL_NOTARGET`, and preserves the original absence of
hand-grenade noise. The area-portal link traversal and eye traces are
allocation-free in their hot paths. The complete 5,000-frame synthetic session
soak passed at over 3,565 fps with 10,027/10,027 packets processed.

The accepted executable then passed both installed Steam retail gates:

```text
base1: maps=1 steps=64 snapshots=64 fire=1 items=9 health=100 packets=202 rejected=0
campaign: maps=39 changes=38 client-state=4 spawn-count=39 steps=753 packets=3700
```

## 2026-08-23 turret parity and Private-Save v13 acceptance run

The Release product and all 152 native test programs were freshly rebuilt and
executed after completing the coupled 3.19 turret behavior and persistence
boundary:

```powershell
.\build.ps1 -Configuration Release -SkipPreflight
```

The run exited with code 0. Product diagnostics, capabilities, CLI smoke and
the post-build inventory passed with 346 MiniLang files and 389 maintained
files. The expanded isolated and product-shaped gates prove live skill-based
reaction time and 550/600/650/700 rocket speed, shared Win32 CRT damage,
positioned muzzle sound, crush knockback 10, `DAMAGE_AIM` combat, driver team
detach, the stock Infantry seven-gib inventory and `misc/udeath.wav`. Private
Save v13 retains v7-v12 readers and restores the driver target references,
lost-sight flag, trail time, attack cooldown, clip mask and exact think/die
phase without relinking the team twice. The complete 5,000-frame synthetic
session soak also passed at over 3,700 fps with no pending sounds or rejected
packets.

The freshly accepted executable then passed both installed Steam retail gates:

```text
base1: maps=1 steps=64 snapshots=64 fire=1 items=9 health=100 packets=202 rejected=0
campaign: maps=39 changes=38 client-state=4 spawn-count=39 steps=753 packets=3697
```

## 2026-08-23 reaction/death parity acceptance run

The Release product and all 152 native test programs were freshly rebuilt and
executed after completing the stock pain/death movement and secondary callback
layer:

```powershell
.\build.ps1 -Configuration Release -SkipPreflight
```

The run exited with code 0. Product diagnostics, capabilities, CLI smoke and the
post-build source inventory also passed with 346 MiniLang files and 389
maintained files. The expanded reaction gate fingerprints all 1,813 frames from
63 pain and 43 death plans, inventories 21 frame-sound callbacks, one
callback-local random branch, 18 death-weapon events and three boss explosion
entries, and drives the real GameImport/Protocol-34 boundary. It observes every
Infantry death flash MZ2 27–38, all Soldier death flashes MZ2 92–97 and both held
3–10-shot SS bursts. The locomotion gate covers all reachable stock secondary
callbacks, and Private-Save v12 restores `AI_HOLD_FRAME` plus the remaining
burst count.

The accepted executable then passed both installed Steam retail product gates:

```text
base1: maps=1 steps=64 snapshots=64 fire=1 items=9 health=100 packets=202 rejected=0
campaign: maps=39 changes=38 client-state=4 spawn-count=39 steps=753 packets=3697
```

## 2026-08-23 Medic parity acceptance run

The release gate was rerun after the exact Medic corpse-search, cable,
resurrection and Private-Save v12 work:

```powershell
.\scripts\test.ps1 -Configuration Release
```

The run passed MiniLang syntax for 346 files, exact manifest membership for 389
maintained files, verifier self-tests, all 152 freshly compiled native test
programs, the Release product build, and the version, diagnostics, capabilities
and CLI smokes. The new `gameplay_medic_resurrection_tests.ml` verifies the
strongest visible unowned corpse selection, all 28 cable frames, nine
`TE_MEDIC_CABLE_ATTACK` multicasts, exact launch/hit/heal/retract sounds,
in-place patient reconstruction and old-enemy restoration. The expanded private
save gate restores `AI_MEDIC`, patient/owner/old-enemy references and completes
a cable saved in flight.

The freshly accepted executable then passed the installed Steam retail gates:

```text
base1: maps=1 steps=64 snapshots=64 fire=1 items=9 health=100 packets=201 rejected=0
campaign: maps=39 changes=38 client-state=4 spawn-count=39 steps=753 packets=3697
```

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
