# MiniQuake2 Release Acceptance

This document records the reproducible local acceptance gate for the current
`0.5.0-foundation` compatibility release. Retail data remains external and is
never copied into either archive.

## 2026-08-24 per-vertex MD2 shadedot and hotpath acceptance run

The alias-lighting path now completes the Quake II 3.19 vertex-lighting step.
Every ordinary MD2 uses its current-frame normal index, one of 16
yaw-quantized rows derived from the canonical 162 `bytedirs`, the original
negative-dot attenuation and hundredth rounding, and the already sampled
colored shadelight. Shell geometry remains on its expanded fixed-function
path. The GLSL 1.20 fast path keeps the lighting state per entity while sharing
bounded VBOs for quantized frame/old-frame/backlerp geometry; D3D9, Vulkan and
compatibility OpenGL use the equivalent CPU-colored fallback.

The loader retains each already validated compact MD2 byte stream. The native
entry point independently validates its header, counts, frame indices and
64-bit offset bounds, then decompresses and interpolates a cache miss directly.
No expanded triangle bytearray, string concatenation or array concatenation is
performed in the MiniLang render loop. The 1,024-slot cache is cleared with the
renderer lifecycle. The shared bridge built twice byte-identically at SHA-256
`57F7A867C7D509B6651662A70BA2C4E37E6913E2E4A1859B111DABCF098876D0`,
and the sibling MiniQuake product rebuilt successfully.

The current Release product and all 153 native programs passed, including the
OpenGL shadedot-row, MD2 registration/submission, renderer product-graph,
Product Host, multiplayer and 5,000-frame synthetic soak gates. The final
installed-retail `base1` run completed 100 frames through server frame 35 with
84 models, 68 sounds, zero missing assets, 2,400 submitted entities, 292
visible world surfaces and 7,015 culled surfaces. Measured client/world/entity/
HUD phases were 167.38/1,842.63/376.70/59.78 ms; entity rendering is 61.3
percent of the preceding 614.28-ms acceptance result, a 38.7-percent reduction.

## 2026-08-24 alias-lighting acceptance run

The OpenGL MD2 path now follows Quake II 3.19 alias lighting rather than
rendering ordinary models at constant white. A fixed world-owned stack performs
the original near-first BSP light ray without MiniLang recursion or per-query
array concatenation, combines colored light styles and dynamic lights, then
applies shell, Fullbright, Minlight, Glow and IR-goggle overrides in reference
order. View-weapon sampling also publishes `150 * max(rgb)` through the next
Protocol-34 UserCmd lightlevel byte.

The complete Release product and all 153 native programs passed. The final
installed-retail `base1` run completed 100 frames through server frame 36 with
84 models, 68 sounds, zero missing assets, 2,400 submitted entities, 292
visible world surfaces and 7,015 culled surfaces. Measured client/world/entity/
HUD phases were 85.95/1,507.15/614.28/72.31 ms.

## 2026-08-24 first-person weapon handedness acceptance run

The already exact `CL_AddViewWeapon` interpolation path now reaches the last
stock handedness behavior across the product boundary. Gun offset, wrapped gun
angles, current/old frame reset, FOV suppression and the
`RF_MINLIGHT|RF_DEPTHHACK|RF_WEAPONMODEL` flags remain snapshot-driven. The
OpenGL alias renderer mirrors the projection only while drawing a left-handed
view weapon and suppresses the weapon for center-handed players, matching the
3.19 `r_lefthand` policy without transforming world entities.

`hand 0/1/2` is available from a real Player Setup menu, persists in the
bounded product config with safe right-handed fallback for older v1 files,
survives renderer restart and is transmitted live as reliable
`clc_userinfo`. The loopback gate proves the update reaches both the server
slot and Game API `ClientUserinfoChanged` state. Focused UI config/command/menu,
client-state, MD2 renderer, live play-session and Product Host tests passed,
followed by a clean rebuild and execution of all 153 native programs and the
product CLI smokes. The final default-right Release product completed
installed-retail `base1` for 100 frames through server frame 36 with 84 models,
68 sounds, zero missing assets and 2,400 submitted entities. Its measured
client/world/entity/HUD phases were 116.56/1,599.06/511.52/44.57 ms.

## 2026-08-24 player entity-rendering parity acceptance run

The player snapshot path now follows the Quake II 3.19 `cl_ents.c` contracts
for custom clients and visible weapons. Player configstrings are parsed into
bounded client-info records, their model and PCX skin are registered with the
renderer, `male/grunt` is retained as the stock failure fallback, and the
configstring `#w_*.md2` table resolves the high byte of `skinNum` for
`modelIndex2 == 255`. Live configstring changes refresh only the affected
client record. The game-side `ChangeWeapon` path publishes that packed visible
weapon index in every subsequent Protocol-34 snapshot.

The renderer now resolves `modelIndex == 255` through the player model/skin,
renders the selected third-person weapon, chooses packed `RF_BEAM` colors with
the shared client random stream, applies the Rogue male/female/cyborg disguise
model/skin override and omits the local player plus linked weapon
from the first-person scene while retaining the view weapon. Focused asset,
client-state, gameplay, runtime-handoff, product-graph and Product Host gates
passed, followed by a clean rebuild and execution of all 153 native test
programs plus the product CLI smokes. A real two-client UDP arsenal gate fired
all 11 stock weapon entries and verified the visible weapon skin word in both
clients' snapshots. The final Release product completed installed-retail `base1` for
100 frames with 84 models, 68 sounds, zero missing assets and 2,400 submitted
entity instances. The intentional reduction from 2,600 is the two hidden local
third-person entities per rendered frame; measured client/world/entity/HUD
phases were 90.63/1,767.82/504.32/79.44 ms.

## 2026-08-24 visible entity-effect parity acceptance run

The follow-up visible-entity parity pass adds the stock duplicate Color-Shell
entity, derives Quad/Pent/Double/Half-Damage shell colors, renders the armor
Powerscreen model and restores the high-bit translucent linked-model rule.
Linked models no longer inherit the main entity's BFG, Plasma, sphere or shell
flags. Automatic snapshot animation, item rotation and spinning red lights now
follow `cl_ents.c`; BFG aura, Fly, Trap and persistent EF_TELEPORTER particles
follow `cl_fx.c`, including the shared lazy 162x3 angular-velocity table and
Visual C random-call ordering. The Release product and all 153 native programs,
including state, lifecycle, frame-dispatch, renderer-product and Product Host
gates, were rebuilt and passed. The test executables now commit 64 MiB inside
their unchanged 256-MiB reserve; this removes native guard-page failures seen
in multiple independent high-water fixture graphs. The rebuilt product
completed installed-retail `base1` for 100 frames with 84 models, 68 sounds,
zero missing assets and 2,600 submitted entity instances.

## 2026-08-24 snapshot entity trail and light acceptance run

Normal snapshot entities now consume the stock `effects` bits in addition to
one-shot temp entities. A fixed 1,024-slot per-client trail table retains the
last rendered origin and diminishing-trail count without array growth. The
renderer path ports Rocket smoke/fire, Blaster/green-Blaster, grenade/gib,
Flag/Tag, Tracker and Ionripper trails plus the stock Rocket, Blaster,
Hyperblaster, BFG, Trap, flag, Tracker, Ionripper, blue-Hyperblaster and Plasma
lights. Sorted current/previous snapshot entities are merged in one linear pass.
BFG, Plasma and sphere entities also receive their original translucent alpha.

Focused lifecycle, client-state, renderer-product, multiplayer-all-weapons and
Product Host gates passed after a fresh Release product build. A real 100-frame
`base1` product run registered 84 models and 68 sounds with zero missing assets,
submitted 2,600 entity instances and exited successfully. Goldens verify stock
five-unit Blaster spacing, Rocket trail de-duplication, the BFG light ramp and
local-player flag-light behavior.

## 2026-08-24 stock particle-family and sustain acceptance run

The Release product and all 153 native test programs were rebuilt and executed
after completing the Quake II 3.19 `cl_fx.c`, `cl_newfx.c` and `cl_tent.c`
particle-family audit. Protocol-34 goldens now cover the exact Rail ring/spray,
Debug, Forcewall and both Bubble trail spacings; Steam and gravity-free Smoke;
Login/Logout/Respawn, item respawn, the 1,053-particle teleport lattice, the
4,096-particle boss teleport and Widow splash; and the 300/700-particle
Widow-beamout/Nuke sustains. The latter use the original single-frame particle
lifetime instead of persisting or disappearing before renderer handoff.

Client effects now consume the Visual C `rand()` sequence used by the original
Win32 client, including the original `frand`/`crand` divisor and call ordering.
The remaining generic temp-entity particle fallback was removed; every parsed
stock family routes to its own velocity, acceleration, color and alpha law.
Footsteps likewise select all four stock samples from that deterministic stream.
The affected parser, lifecycle, dispatcher, multiplayer arsenal, deathmatch,
renderer-product and UDP routing gates all passed. The final synthetic soaks
completed 10,027/10,027 packets at 3,990.50 and 4,020.79 fps with zero pending
sounds.

## 2026-08-24 client impact parity and fixed-pool acceptance run

The Release product and all 153 native test programs were rebuilt and executed
after the client temp-entity and muzzleflash audit against the Quake II 3.19
`cl_tent.c` and `cl_fx.c` switches. Protocol-34 goldens now cover wall-impact
smoke/flash pairs, ricochet and spark sounds, direction-derived blaster angles,
the exact stock explosion models/frame counts/base frames/alpha, water and
Rogue sounds, player Chaingun layering, weapon reload tails, monster-family
sounds, global attenuation and the Rogue green/negative/plasmabeam flashes.
The monster heatbeam also uses its stock Widow beam model.

The client particle hot path now owns one reusable 4,096-slot backing array and
an explicit logical count. Appending an impact or explosion no longer copies
every live particle; expiry compacts the same buffer in place, while renderer
and transactional frame handoffs still copy only active entries. Per-impact
temporary type and splash-color arrays were replaced with inline branch
classifiers, and stock directional/blaster/explosion particle generators retain
their distinct color, velocity and gravity behavior.

The final synthetic soaks sustained 4,143.92 and 4,048.28 fps over 5,000 frames
and 10,027/10,027 packets each. Installed-retail `base1` completed 5,000 frames
through server frame 5,015 in 26,288.5704 ms (190.20 fps), with
10,385/10,385 packets. Dense `lab` completed 500 frames in 7,319.3864 ms
(68.31 fps), with 1,136/1,136 packets. Both retail runs had zero rejects, zero
pending sounds and an empty command buffer. Physical input passed 39/39 maps;
the persistent campaign passed 39 maps, 38 changes and 753 steps with 3,690
packets.

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
