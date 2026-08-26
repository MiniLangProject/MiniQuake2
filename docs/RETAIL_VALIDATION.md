# Retail validation evidence

Validation date: 2026-08-25 (Europe/Berlin)

The tests below used the user-owned classic Steam installation at
`C:\Program Files (x86)\Steam\steamapps\common\Quake 2`. No game data was
copied into the project, build products, or release archives. The installation
also contains a separate `rerelease` directory; all results below use the
classic root and classic `baseq2` PAK files only.

This is a chronological evidence log, so counts and timings belong to the
build described by their surrounding dated paragraph. The latest audit section
and current verifier output supersede older inventory totals without rewriting
the historical measurements.

The 2026-08-25 frame/audio pass replaced per-frame auto-sound channel
allocation with inactive-channel reuse, added epoch-indexed entity and
resource-handle lookup tables, packed BSP lightmaps into 256x256 atlases and
pre-uploaded immutable world textures before opening the audio device. Dynamic
brush lightmaps now update only their atlas rectangle. The mixer feeds all
eight native 1,024-frame buffers from reusable storage and reports queue
underruns explicitly. Two independent 512-frame installed-retail `base1` runs
completed at 105.58 and 107.39 fps with zero missing assets and zero audio
underruns; their longest frames were 180.8135 and 189.0996 ms. The repeated run
measured client/world/entity/HUD phases at
711.7916/2,296.9486/364.9296/299.2592 ms. The installed-retail physical input
smoke also passed after the same Release build. The full source and Release
test matrix passed with 431 maintained files and 386 MiniLang files.

The final same-date renderer pass added the classic 3.19 planar alias shadow.
It retains the receiver point from the existing BSP light traversal, projects
cached interpolated MD2 geometry from entity yaw and height, and draws black
alpha-0.5 geometry after the opaque world/brush pass and before alpha surfaces.
Translucent and first-person weapon aliases are excluded. Shadows remain
independently switchable and now default to disabled, matching the original
`gl_shadows` setting while avoiding an extra alias pass in the product. The
bridge rebuilt twice byte-identically at SHA-256
`E743A52E7D503F6811CFEEC48BBA83912487623F155A273AEB480829C39B9D97`
and passed all 31 native safety invariants.

The Release product and all 153 asset-free programs passed. Grounded `base1`
captures with only the shadow toggle changed retained identical counts of 324
visible/6,983 culled surfaces, nine brush entities and one MD2. The enabled run
reported one shadow at light height 32 versus zero when disabled, with 2,058
differing pixels, 5,990 differing RGB channels, 29,396 absolute error, maximum
channel delta 17 and 167-ppm mean absolute error. The final installed-retail
product completed 100 frames through server frame 34 with 84 models, 68 sounds,
zero missing assets and 2,400 entity submissions. Client/world/entity/HUD
phases measured 82.5237/1,941.6179/91.3086/51.3970 ms.

The same-date MD2 shadedot and render-hotpath pass completed the alias-lighting
port at vertex granularity. The validated original MD2 bytes are retained by
the model asset and passed once per entity to the native bridge; strict native
header, count, frame and offset checks guard frame interpolation. Missing
quantized animation states are expanded into a bounded 1,024-slot VBO cache,
while a GLSL 1.20 path applies the original 162 normals, 16 yaw rows,
negative-dot attenuation and hundredth rounding to the colored shadelight.
D3D9, Vulkan and compatibility OpenGL retain an equivalent CPU-colored
fallback. This removes the render-loop string/array concatenation and complete
byte-buffer copies from the earlier attempts. The native DLL rebuilt twice to
the identical SHA-256
`57F7A867C7D509B6651662A70BA2C4E37E6913E2E4A1859B111DABCF098876D0`;
MiniQuake 1 also rebuilt successfully against the extended bridge.

The Release product and all 153 asset-free programs then passed. The final
installed-retail `base1` run completed 100 frames through server frame 35 with
84 models, 68 sounds, zero missing assets, 2,400 submitted entities, 292
selected world surfaces and 7,015 culled surfaces. Client/world/entity/HUD
phases measured 167.3803/1,842.6336/376.6989/59.7771 ms. The entity phase is
61.3 percent of the preceding 614.2806-ms flat-alias-lighting acceptance, a
38.7-percent reduction, and avoids the multi-second regressions of managed
expanded-triangle batches.

The same-date first-person weapon follow-up retained the exact snapshot
offset/angle/frame handoff and added persistent right/left/center Player Setup,
left-only projection mirroring, center-weapon suppression and live reliable
userinfo publication to the Game API. All 153 native programs passed before
the final default-right `base1` product run. It completed 100 frames through
server frame 36 with 84 models, 68 sounds, zero missing assets, 2,400 submitted
entities and client/world/entity/HUD phases of
116.56/1,599.0575/511.5168/44.5719 ms.

The subsequent same-date alias-lighting pass ported the 3.19
`RecursiveLightPoint`/`R_LightPoint` behavior to a fixed, world-owned MiniLang
stack, including colored light styles, dynamic lights, shell/Fullbright/
Minlight/Glow/IR policies and view-weapon lightlevel feedback into the next
UserCmd. The full 153-program Release matrix passed. The final installed-retail
`base1` product run completed 100 frames through server frame 36 with 84
models, 68 sounds, zero missing assets, 2,400 submitted entities, 292 selected
world surfaces and 7,015 culled surfaces. Client/world/entity/HUD phases were
85.9467/1,507.1547/614.2806/72.3144 ms.

The final same-date player-rendering pass repeated installed-retail `base1`
for 100 product frames after enabling configstring-driven custom player
models/skins, third-person visible weapons, packed beam colors and original
local-player hiding. The final rebuilt binary reached client state 4 through
server frame 39, registered 84 indexed models and 68 sounds with zero missing
assets, selected 292 world surfaces, culled 7,015 and submitted 2,400 entity
instances. Its client/world/entity/HUD
phases measured 90.6254/1,767.8208/504.3197/79.4439 ms.
The earlier 2,600 submission count included the local player and linked weapon;
their removal from the first-person scene accounts exactly for the difference.

The 2026-08-24 client-effect acceptance repeated the movement-enabled retail
performance and campaign gates after porting stock temp-entity, explosion,
muzzleflash, monster-flash and impact-audio semantics and replacing per-effect
particle-array growth with a reusable fixed pool. `base1` completed 5,000
frames in 26,288.5704 ms (190.20 fps) with 10,385/10,385 packets; `lab`
completed 500 frames in 7,319.3864 ms (68.31 fps) with 1,136/1,136 packets.
Both runs reported zero rejects, zero pending sounds and zero command bytes.
The 39-map physical-input matrix remained 39/39 and the persistent chain
remained 39 maps/38 changes/753 steps/3,690 packets.

A follow-up asset-free Release matrix completed the remaining stock client
particle families without changing the legal retail-data boundary. Rail,
Debug, Forcewall, both Bubble trails, Steam/Smoke, login/logout/item respawn,
teleports, Widow splash and the Widow/Nuke sustained radial effects now follow
their 3.19 algorithms and Visual C random stream. All 153 native programs and
the 10,027-packet synthetic soaks passed; the installed-retail performance and
campaign evidence above remains the most recent retail-data run.

The subsequent moving-entity effects pass completed a real 100-frame `base1`
product run with 84 models, 68 sounds, zero missing assets and 2,600 submitted
entity instances after enabling snapshot-driven projectile trails, lights and
BFG/Plasma/sphere translucency. The next visible-entity parity build repeated
that 100-frame gate with the same asset and submission counts after adding
Color-Shell/Powerscreen rendering, linked-model isolation, automatic animation
and the BFG/Fly/Trap/Teleporter particle tail. Its measured client/entity phases
were 55.26/497.32 ms for the run.

The classic installation contains `3.20_Changes.txt`. It is therefore suitable
for retail-data validation, but it is not evidence of strict interoperability
with the contracted unmodified 3.19 binary baseline.

## Input identity

| Relative file | Bytes | SHA-256 |
|---|---:|---|
| `quake2.exe` | 711,680 | `8C9D5A798055FBAED2718156108AE081877156311AE5FB159F64A778F02C2ADE` |
| `baseq2/gamex86.dll` | 397,824 | `1ED478C239E1CEBC9E8714172B8932BB8CBFCB908AC31BE1026F61B49336D3F5` |
| `ref_gl.dll` | 234,496 | `7A66C91988AB406DDC42F3C24D1539E2808222C89259DF1B0CAB21A533D5B5A5` |
| `baseq2/pak0.pak` | 183,997,730 | `1CE99EB11E7E251CCDF690858EFFBA79836DBE5E32A4083AD00A13ECDA491679` |
| `baseq2/pak1.pak` | 12,992,754 | `678210ECD1B27DDE1C645660333A1A7B139D849425793859657F804D379B62AD` |
| `baseq2/pak2.pak` | 45,055 | `CB88D584EF939D08E24433A6CF86274737303FAC2BBD94415927A75E6B269DD8` |

## Passing product runs

`scripts/campaign_smoke.ps1 -Quake2Root <root>`:

- discovered 47 BSP38 maps directly in the classic PAK search set: 39
  single-player maps and 8 deathmatch maps;
- counted 36,404 source entities and 138 distinct stock class names;
- parsed and spawned all maps in one MiniLang process, producing 20,935 live
  edicts with zero skipped classes; `space` was the high-water mark at 883
  live edicts, remaining below `MAX_EDICTS` with four client slots;
- launched the built `MiniQuake2.exe --asset-smoke` separately for every map;
  all 47 processes loaded their BSP/collision/Game-API state, ran a server
  frame, and returned success with zero skipped entities;
- wrote only aggregate JSON evidence to `build`; no PAK member was extracted or
  copied.

`MiniQuake2.exe --asset-smoke <root> base1`:

- `maps/base1.bsp` loaded from three classic PAKs;
- 7,905 faces and 5,238 leafs parsed;
- all 634 map edicts across all 56 class names materialized, with zero unknown
  or skipped classes;
- a 198-frame MD2 and 13,156-sample WAV decoded;
- managed baseq2 spawn and one server frame completed;
- result: `MiniQuake2 asset smoke: PASS`.

`MiniQuake2.exe --dedicated <root> base1 0 20`:

- classic retail BSP/collision/game state started on an ephemeral UDP port;
- 20 fixed server frames completed;
- result: `MiniQuake2 dedicated server: PASS`.

`MiniQuake2.exe --listen <root> base1 100`:

- real loopback UDP challenge, connect, signon, configstrings, baselines, begin,
  PMove, PVS/PHS-filtered snapshots, acknowledgements, and shutdown completed;
- client reached state 4 (`CA_ACTIVE`) and processed 99 packets;
- result: `MiniQuake2 listen session: PASS`.

`MiniQuake2.exe --map-preview <root> base1 1`:

- loaded the 7,905-face BSP and its referenced WAL textures directly from the
  user-owned classic PAKs;
- prepared static Quake II lightmaps and submitted the world through the native
  OpenGL compatibility backend;
- result: `MiniQuake2 map preview: PASS frames=1`.

`MiniQuake2.exe --play <root> base1 100`:

- reused the retail BSP/collision state for an internal Protocol-34 UDP
  listen-server and client;
- completed challenge/connect/signon and reached state 4 (`CA_ACTIVE`);
- registered 80 configstring-driven BSP/MD2 models and 44 WAV sounds without a
  missing-asset fallback;
- ran live UserCmd, Game API, snapshot, `svc_sound`, effect/UI/mixer handoff,
  WAL/lightmap world and MD2 entity submission and clean shutdown;
- submitted 2,300 entity instances over the run;
- selected 95 visible surfaces and culled 7,212 prepared world surfaces from
  view cluster 631 using BSP PVS, area, frustum and backface tests;
- result: `MiniQuake2 interactive vertical slice: PASS`.

`MiniQuake2.exe --play <root> train 100` additionally exercised the expanded
campaign registry and transformed inline-brush renderer on a larger map. It
reached client state 4 through server frame 109, registered 145 models and 57
sounds with zero missing assets, submitted 1,000 entity instances, and ended
with 118 visible versus 7,268 culled world surfaces in view cluster 996.

`MiniQuake2.exe --listen <root> city3 100` reached state 4 and parsed 108
packets. `MiniQuake2.exe --dedicated <root> space 0 20` completed 20 server
frames and clean shutdown on the retail map with the largest live-edict set.

The asset-free native suite also performs a real UDP `changing`/`reconnect`
map switch over the same client/server Netchan. It verifies monotone channel
sequences, complete configstring/baseline/snapshot reset, lower new snapshot
frame numbers, re-signon to active state, malformed/back-pressure atomicity,
and a separate fresh sequence generation for a server restart.

`MiniQuake2.exe --campaign-session-smoke <root> 39` keeps that UDP client and
server alive while loading and spawning the complete 39-map single-player list.
Each level reaches `CA_ACTIVE`; the run performs 38 transactional map changes,
resets level-owned client state, republishes configstrings and baselines, and
completes the next signon without resetting the Netchan sequence generation.
Two consecutive executions of the current multicast product binary returned
the identical result: 39 maps, 38 changes, spawn count 39, 661 session steps
and 3,235 processed packets.
After introducing persisted stock attack-frame schedules, the freshly rebuilt
Release executable again passed all 39 maps and 38 changes with spawn count 39,
now in 660 steps and 3,229 processed packets. The small deterministic reduction
comes from the new attack timing while retaining the same lifecycle outcome.
After completing the stock player-weapon protocol/effect path, the rebuilt
product passed the same matrix again in 661 steps and 3,234 processed packets.
After completing every stock monster ranged, melee and drain attack timeline,
the rebuilt Release product passed all 39 maps and 38 changes again with spawn
count 39, 661 steps and 3,232 processed packets.
After adding the complete stock death-terminal model inventory, the rebuilt
Release product passed the same 39 maps and 38 changes with spawn count 39 in
665 steps and 3,252 packets. The deterministic increase is the four newly
published model configstrings needed beyond the previously registered gib
assets.
After restoring all live stock monster refires, exact melee/random boundaries,
the conditional Brain chain, Mutant jump and saved Gladiator aim, the 2026-08-23
Release executable again passed all 39 maps and 38 changes with spawn count 39
in 689 steps and 3,376 processed packets. A matching `base1` input smoke
completed 64 movement/combat steps, 64 snapshots and 201 accepted packets with
zero rejects.
After restoring the exact attack-table movement columns and mechanical sound
callbacks, plus complete spawned-monster sound precache, the same-date Release
executable passed the matrix in 753 steps and 3,697 processed packets. The
matching `base1` input smoke again completed 64 movement/combat steps, 64
snapshots and 201 accepted packets with zero rejects. The deterministic session
increase comes from publishing the original class sound configstrings before
each signon; the map/change/spawn lifecycle outcome is unchanged.
The matching visible `base1` start reached `CA_ACTIVE` at server frame 14,
registered 84 models and 45 sounds with zero missing assets, submitted 25
entities and selected 326 visible versus 6,981 culled world surfaces.
This is repeated map-load/spawn/network-lifecycle evidence only: it
does not simulate campaign objectives, combat progression or an end-boss run.

`scripts/physical_campaign_smoke.ps1` adds a separate physical-entry matrix.
It starts a fresh real UDP session on each of the same 39 campaign BSPs and
sends 48 decoded movement/attack UserCmds. Every map must produce PMove
displacement, at least one normally scheduled weapon shot, 48 snapshots and
zero rejected packets. The 2026-08-22 run passed 39/39; `base1` additionally
crossed the stock item corridor and gained nine inventory units. `fact3`,
`mine4` and `waste3` killed the deliberately non-reactive probe during those
4.8 seconds, which is retained as hazard telemetry rather than hidden. This
closes physical input at every campaign entry, not full human route-finding or
resource-aware combat clearing.

`runtime_campaign_goal_session_tests` supplies the complementary goal-graph
evidence. Starting at `base1`, it follows the canonical branched route through
51 transitions and all 39 unique BSPs, including every required return trip.
Each step must first reach the selected map through the existing Game/World
key, counter, timer, trigger, monster-death or boss callbacks; only then may the
runtime commit that selected map and complete a normal Protocol-34 re-signon.
The final `boss2` chain reaches `victory.pcx`. The retail run passes with zero
direct `target_changelevel` fallbacks. This is state-machine progression, not a
claim of PMove navigation or weapon-by-weapon clearing: the driver invokes
trigger use boundaries and deterministic lethal damage for goal-bound
monsters rather than synthesizing a human input path. The optional Retail
test is compiled with the product's 1-GB reserved heap profile; the canonical
asset-free test binary deliberately retains the smaller 256-MB test profile.

`baseq2_campaign_behavior_coverage_tests` inventories executable behavior over
all 39 single-player BSPs: 34,298 raw entities, 9,304 target/transition
instances across 32 classes, 1,624 monster instances across 22 BSP monster
classes, and all five retail boss/special classes. The focused endgame gate
executes Jorg death, the `t26` death target, dynamic Makron export with inherited
target, the second count on `trigger_counter`, `target_changelevel`,
intermission/next-map state and the queued `gamemap` command. A separate v6
private-save gate restores both the staged Jorg death and the dynamically
materialized Makron while preserving enemy/target references and exactly-once
transition guards. `point_combat`, `target_actor`, `target_character`,
`target_string`, `trigger_key`, `func_clock`, `trigger_elevator`,
`target_lightramp`, `func_killbox`, the Viper/bomb set piece, the remaining
decorative thinkers, `info_notnull` and `light_mine2` are now functional typed
state machines. All 60 `misc_insane` instances use a dedicated AI with
persisted crawl/crucified/pain/death phases. The two scripted boss props have
their original use/think phases and versioned restore state; the two complete
base/breach/driver turret rigs have coupled transforms, aiming, visibility,
rocket cadence, collision damage and driver lifecycle. The live Game-API gate
also proves current-skill reaction/speed, shared-CRT damage, exact muzzle sound,
crush knockback 10, `DAMAGE_AIM` handling, seven Infantry gibs and the stock
gib sound; Private Save v14 resumes its references, sight state and cooldown.
The measured matrix is
now `simplified=0/0`. This closes the retail classname state-machine tail, not
every animation or AI decision leading to it.

`gameplay_monster_combat_profiles_tests` validates 22 unique stock combat
profiles against representative integrated Berserk melee, Gladiator rail,
Chick rocket and Parasite drain scenarios. Across the retail BSP matrix all 21
combat-capable monster classes are now classified `ai+combat-profile`; the
remaining monster class is the intentionally non-combat `misc_insane` prop AI.
The dynamic Makron supplies the 22nd registry profile. Existing Soldier,
Gunner, Infantry and player weapon goldens remain green, and the unmasked
39-map product graph completes with the expanded profiles active. Every ranged
profile also carries its stock first-shot MZ2 identifier. The
`gameplay_monster_attack_sequence_tests`,
`gameplay_monster_ranged_sequences_tests` and
 `gameplay_monster_melee_sequences_tests` cover every combat family, including
 stock MD2 projection, live stock refire callbacks, ordered MZ2 sequences, the
 conditional Brain tentacle chain, Mutant jump and the Parasite damage/beam
 chain. The product-shaped Gunner gate observes the ordered MZ2 45–52 events
 and its live 50% refire decision from one AI attack. The reaction and locomotion
 suites inventory 63 original pain variants, 43 normal-death variants, all 1,813
 corresponding movement frames, six stock duck/dodge ranges and stand/idle/
 walk/run ranges for all 22 combat entries. They also prove every reachable
 secondary fidget/locomotion callback, the complete pain/death frame-sound
 inventory, Infantry/Soldier death fire and the exact Supertank/Boss2/Jorg
 explosion-entry offsets. Private Save v14 retains a running attack or
 reaction's event index,
 next-frame time, reaction debounce, live refire/jump/aim state, the shared Win32
random seed and stable Medic patient/old-enemy/owner state. Stock death terminals additionally
carry their class-specific corpse bounds, exact organic/metallic gib-model
inventories and the eight-step Supertank explosion/final-gib sequence through
real engine edicts; active gibs round-trip through the same save format. The
 focused multicast gates prove owned/bounded GameImport queuing, ALL/PVS/PHS visibility, reliable
 backpressure and a real UDP `svc_muzzleflash2` reaching the integrated client
 as the expected DLight and attack sound. Attack sequences now execute the exact
 3.19 movement distances, `ai_charge`/`ai_move` boundaries, held-frame behavior
 and mechanical sound callbacks without constructing arrays in the live lookup
 path. Every spawned stock class precaches its complete original sound inventory;
 a Jorg also precaches its dynamically spawned Makron successor. The stock
 sight/search callback inventory now preserves the original callback absences,
 sound channel/attenuation, ordered random branches and silent Makron activation.
 Soldier additionally executes the exact sight-selected running `attack6` and
 dodge-selected ducking `attack3` frames, movement, MZ2 events, bounds and
 Nightmare refire rule; Mutant footstep selection consumes raw CRT `rand` just
 like 3.19. `gameplay_monster_sight_search_tests` and the extended attack/dodge
 gates cover those seams. Medic corpse search now selects the strongest visible
unowned patient within 1,024 units and its exact `attack33..60` cable resumes
through Private Save v14. A held Soldier SS death burst also resumes with its
remaining shot count. Paired original full-encounter traces remain open, but no
reachable stock pain/death movement or secondary callback table is known
missing. Gunner, Medic,
 Chick, Flyer, Hover, Tank,
 Soldier, Supertank, Jorg and Boss2 now make their live stock refire decisions
 from the persisted shared CRT stream. Brain follow-up and Mutant jump decisions
likewise happen at their original callback frames rather than during plan
construction.

The shared live locomotion path now ports the 3.19 `m_move.c` bottom, ground,
step, partial-ground, drop-to-floor, fly/swim and water-boundary rules. Its
GameImport trace combines the retail world and inline BSP hulls with swept
dynamic monster/player boxes; the inline regression proves a monster cannot
cross a closed door and moves again after the door clears. Lost sight enters
the original eight-marker PlayerTrail search with left/right course traces and
search timeout. Private Save v14 retains v7-v13 readers and round-trips the
last-sighting, saved/temporary goal, trail/search time, yaw, velocity and ground
state needed to resume that pursuit; transient ground contact is re-established
against the restored collision world.

The final movement-enabled unpaced retail gate completed 5,000 `base1` frames
through server frame 5,015 in 29,621.971 ms (168.79 frames/s), processing
10,385/10,385 packets with zero rejects, zero pending sounds and a drained
command buffer. A second dense-map gate completed 500 `lab` frames in
10,384.3258 ms (48.15 frames/s), processing 1,136/1,136 packets with the same
zero-reject/zero-backlog result. Swept collision traces now run the original
near-first recursive hull algorithm as an allocation-free fixed-stack DFS;
stationary tests reuse one leaf scratch table and all paths share a brush
check-generation table. Server linking uses indexed inline-brush/trigger sets,
cached absolute bounds and an in-place non-BSP BBOX path. A swept-bounds
`SV_AreaEdicts` broad phase rejects remote inline brushes before basis creation
or hull tracing. The transformed-inline-brush regression still proves
closed-door sight, shot and movement blocking before restoring all three when
the door moves away, and deliberately poisons a remote hull to prove it is not
entered.

The installed physical-input matrix passes all 39 campaign BSPs at 48 frames
each, including `lab`; the persistent one-session chain passes 39 maps and 38
changes in 753 steps with 3,690 packets. Fixed 1,024-event sound storage,
preallocated routing plans and explicit PHS no-plan handling leave the queue at
zero even on the sound-dense `lab` population.

`server_unicast_event_queue_tests`, `network_runtime_unicast_routing_tests` and
`network_runtime_unicast_loopback_tests` close the targeted half of the same
Game-API seam. They validate exact `svc_print`/`svc_centerprint` framing, owned
bounded payloads, two-slot isolation, full-queue failure atomicity, reliable
ACK retention and sequenced-unreliable delivery. The real UDP gate observes the
expected print and centerprint only in the integrated target-client handoff.

`runtime_multiplayer_deathmatch_tests` and `runtime_multiplayer_coop_tests` run
two real local UDP clients against one server. DM proves distinct slots/names,
mutual two-player snapshots, seven decoded UDP Blaster attack edges through
Weapon_Generic/projectile damage, exact obituary/score synchronization, and a
normal attack-latch respawn without `DF_FORCE_RESPAWN`. Coop proves shared
map/spawn epoch, `IT_STAY_COOP` key pickup for both
players, disconnect with the surviving peer still active, and a fresh reconnect
and signon without stale visibility.

`runtime_multiplayer_rotation_spectator_tests` adds a real reliable
`clc_userinfo` transition from spectator to active deathmatch player, drives
the frag-limit and maplist rules through the five-second intermission input
gate, consumes the resulting `gamemap`, re-signs both UDP clients on the next
map while preserving monotone Netchan sequences, and completes a 500-frame
post-change soak with zero rejected packets.

`runtime_multiplayer_coop_checkpoint_tests` exercises both skill endpoints,
saves and restores both connected players plus shared world state without
replacing any of the four live client/server Netchans, validates independent
key inventories and scores, then kills one teammate through eight decoded UDP
Blaster commands. The coop obituary is retained without awarding a deathmatch
frag, and a 200-frame post-restore transport soak completes with zero rejects.

`runtime_multiplayer_all_weapons_tests` sends a real attack UserCmd for all 11
stock weapon modes. Ten firearms produce their normal muzzle/effect handoff on
both integrated clients; the cooked hand grenade is observed as the same live
engine edict in both snapshots. The gate validates per-weapon ammo cost,
Netchan progress, zero rejects and a 300-frame tail soak, including a repeated
run with a 4-MB GC limit.

`runtime_multiplayer_campaign_checkpoint_tests` connects the same goal driver
to two real cooperative UDP clients. Against the installed retail data it
passes all 51 goal-confirmed transitions covering 39 unique campaign BSPs and
creates/restores a two-player checkpoint on every first visit. Each checkpoint
retains both player records and all four live Netchans and produces valid
post-restore health snapshots; the aggregate finishes with zero packet rejects.

The v10+ Private-Save format length-prefixes retail entity text
beyond the 2,047-byte network-string boundary, preserves typed/non-text world
adapters, reconstructs dynamic delayed-use/gib edicts, and restores numbered
activator, owner, team, target, enemy and ground references. Legacy v7 and v8
payloads remain readable.

`gameplay_player_weapon_protocol_tests` now validates all ten stock player
muzzle mappings, silencer framing, hit/blood/splash/bubble/rail/BFG effects,
Shotgun pump timing, BFG windup and late ammo checks, Machinegun/Chaingun/
HyperBlaster cycling, handed muzzle projection, recoil and cooked hand-grenade
state. The integrated UDP gates additionally observe moving Blaster,
HyperBlaster, hand-/launcher-grenade, rocket and BFG projectile edicts in both
real client snapshots, including visible old-origin motion, stock model
configstrings, loop-sound configstrings where applicable, muzzle light/sound
and impact particles through the normal Protocol-34 dispatcher. Named,
previous, next and last-weapon string commands also traverse the live Game
API. This closes the stock player weapon state/protocol vertical slice; paired
original view-model, kick and per-frame visual capture remains an explicit
acceptance gate.

`runtime_active_session_persistence_tests` writes both managed Game and Level
images from an active UDP session, mutates live world/player/item/score state,
restores without resetting the same-map Netchan or server frame, and validates
the next snapshot. A valid outer image with deliberately corrupted private
payload proves that a mid-restore failure rolls back atomically. Cross-map
restore remains an explicit map-change/re-signon responsibility.

The extended unpaced retail session soak completed 20,000 `base1` frames
through server frame 20,014 in 455,711.083 ms (43.89 frames/s), processing
40,740/40,740 packets with zero rejects and a three-handle first-Winsock delta.
It validated and consumed 987 original `menu_loadgame` requests and finished
with zero command-buffer bytes. Histories for world, weapons, network commands
and bridge diagnostics are explicitly bounded, and inactive managed projectiles
are compacted. The same executable completes two asset-free 5,000-frame
sessions at roughly 3,640 frames/s with handle deltas `+3` then `+0`.

`runtime_cross_map_session_persistence_tests` saves Game+Level state on a live
source map, changes maps, completes a full Protocol-34 re-signon and restores
the target checkpoint before validating the next snapshot. Resolver and image
preflight failures do not mutate the live session. A deliberately corrupted
private payload after target signon returns to the source map, re-signs on and
restores the rollback pair; spawn and Netchan sequence generations remain
monotonic rather than being rewound.

## Wire interoperability and visual evidence

`network_external_wire_interop_tests` uses an independent raw UDP peer in both
directions. A MiniQuake2 client completes getchallenge/connect/qport/reliable
`new`/serverdata/ACK against that peer; the raw client completes
challenge/connect/client-connect/`new`/serverdata/reliable ACK against the
MiniQuake2 server. This verifies Protocol-34 wire behavior without sharing the
MiniQuake2 parser on the peer side.

The installed classic executable is unambiguously 3.20 evidence: its hash and
size are listed above, it contains one IEEE-f32 `3.20` and no `3.19`. On this
host it exits with code 0 before creating a window, answering UDP `status`, or
entering a client session, including an isolated working directory and
compatibility-mode attempts. Consequently the raw bidirectional gate is green,
but installed-original process-to-process interoperability is environment
blocked and is not reported as passed. Exact 3.19 evidence remains the pinned
source reference rather than this installed binary.

The renderer capture path performs native GL readback into canonical top-left
RGBA and writes lossless 32-bit TGA. Four repeated 640x480 scenes are now
byte/pixel exact: `base1` inline world, `waste1` water/22 brushes/MD2, `cool1`
alpha/20 brushes/MD2 and `boss2` sky/alpha/11 brushes/MD2. Their hashes are
recorded in [`REF_GL_DIFFERENTIAL.md`](REF_GL_DIFFERENTIAL.md) and in the
generated combined JSON report.

`tools/original_ref_gl_capture.c` now hosts the installed unmodified 32-bit API
v3 DLL directly, while `tools/run_ref_gl_differential.ps1` compiles the current
MiniLang capture entry point and runs both sides at matched cameras. At a
per-channel tolerance of 4, `base1_world` passes with 25,725 differing pixels
and 2,792 ppm mean absolute error; `waste1_world_md2` passes with 10,987 pixels
and 2,303 ppm; the added `cool1_alpha_md2` scene passes with 16,263 pixels and
2,963 ppm while exercising 56 alpha surfaces. The accepted ceilings are
32,000 pixels, 100,000 mismatch ppm
and 4,000 MAE ppm. JSON reports and heatmaps remain derived build artifacts;
the installed DLL and retail data are never copied. See
[`REF_GL_DIFFERENTIAL.md`](REF_GL_DIFFERENTIAL.md).

The combined gate also performs two independent 512-frame audio mixes across
8-bit mono looping and 16-bit stereo replacement channels. Both produce the
same 2,048 PCM bytes and FNV-1a `630146404` under the 4-MB GC profile.

The product executable also plays the installed 3,159,828-byte
`baseq2/video/idlog.cin` through its real Huffman/palette/OpenGL/mixer/device
chain. The final full run completed stream frame 81 exactly once with one
scheduler drop inside the explicit hardware limit and 269,312 mixed stereo
frames. This retail gate exposed and fixed the original
decoder's legal leaf-255 fallback for unused zero-count Huffman context rows.
See [`CINEMATIC_ACCEPTANCE.md`](CINEMATIC_ACCEPTANCE.md).

The original `SV_Map` grammar is additionally exercised with the installed
`eou1_.cin+*bunk1$start` and `end.cin+victory.pcx` chains. CIN, terminal PCX
and named map spawn all pass through one product-owned window/renderer
lifecycle; `end.cin+victory.pcx` reports generation 1 and two loading frames.
The native `--video-restart-smoke` replaces a 640x480 windowed renderer with a
1920x1080 exclusive fullscreen window, verifies matching Win32 desktop metrics,
re-registers `base1`, and produces the same visible surfaces before and after
the renderer change; see
[`MEDIA_SEQUENCE_ACCEPTANCE.md`](MEDIA_SEQUENCE_ACCEPTANCE.md).

The combined one-command host gate, hardware inventory, native audio result and
remaining external device matrix are recorded in
[`HARDWARE_ACCEPTANCE.md`](HARDWARE_ACCEPTANCE.md).

The installed release demos are now product gates as well. Their serverdata
uses the historical protocol number 26; the isolated DemoSession mirrors the
3.19 client's compatibility hack and omits only the old frame suppress byte.
`demo1.dm2` completes 696 packets and 688 rendered frames on `base2` (97 models,
153 sounds and 20,605 entity submissions), while `demo2.dm2` parses all 625
packets/617 frames and renders its `waste2` opening. The mixed
`demo1.dm2+base1` media chain passes under the 1-GiB product heap with two
loading frames, one native window/context and a renderer-state generation
boundary between the expanded BSPs.

The interactive product loop also consumes the complete UI handoff and command
surface: inventory rows use retail `CS_ITEMS` names, mixer gain changes live,
and the three menu slots discover durable pairs and exercise atomic same- or
cross-map session restore. New Game applies skill before spawn, v8 persists it,
Controls captures a replacement binding, and the complete settings/binding
table passes a validated config-file roundtrip. The focused
acceptance and remaining application boundaries are recorded in
[`UI_AUDIO_ACCEPTANCE.md`](UI_AUDIO_ACCEPTANCE.md).

## Compatibility defects exposed and fixed

The first retail run rejected two historical PAK paths containing the safe
segment `models/monsters/tank/../ctank/...`. Virtual paths are now canonicalized
inside the virtual root while attempts to escape that root still fail.

Further runs added regression coverage for the BSP entity lump's terminal NUL,
C `atof`-compatible leading decimal points, collision-to-Game-Trace adaptation,
per-client PVS/PHS snapshot filtering and bounded overflow suppression, and the
fixed 16-entry client snapshot ring. The previous growing-and-slicing snapshot
list caused a deterministic native access violation when the seventeenth large
retail snapshot replaced history; 100 retail frames now complete cleanly.

The first product `--play` attempts also exposed and fixed two full-graph-only
integration defects: world `path_corner` records are now adapted to the AI
target layout at the subsystem boundary, and effects advance on the same
monotonic ClientSession clock used while parsing network events.

The expanded 80-model/634-entity soak then exposed four allocation-pressure
defects that short runs did not reach: nested MD2 vertex references crossing
native OpenGL calls, temporary MD2 geometry subobjects, inline array arguments
inside protocol state constructors, and growing packet-entity/handoff arrays.
The affected paths now use flat scalar GL plans, field-wise owned protocol and
handoff records, and fixed-capacity snapshot construction. Dedicated regression
soaks cover 1,000 MD2 plans, 2,000 protocol copies, and 500 delta-history frames
with 24 entities under forced allocation pressure.

The campaign-wide run exposed two additional reference-compatibility defects.
First, raw BSP entities had been counted directly against `MAX_EDICTS`; the C
game instead frees compiler groups, static untargeted lights and `info_null`
during spawning and reuses those slots. The managed spawn path now performs the
same live-set compaction. Second, `city1` contains `delay ".1.25"`; C `atof`
accepts the numeric prefix as `0.1`, which the checked parser now reproduces
while still rejecting values without a numeric prefix.

The integrated suite then caught a player/world adapter defect: a trigger touch
could assign a world `Vec3` velocity to the PMove array field. The boundary now
converts explicitly in both directions, and the playable Game-API test asserts
that trigger dispatch preserves the player velocity shape and values.

The first whole-campaign session runs also exposed allocation-pressure failures
that moved between retained BSP vectors, edict state, movement records and text
helpers. The underlying defect was in the MiniLang collector rather than those
subsystems: stale mark-bitmap bits at plausible interior addresses could later
alias a real object created by free-list splitting, causing the collector to
skip that object's children. The collector now clears the used mark-bitmap
prefix before every mark phase. Float boxing additionally preserves volatile
`XMM0` across allocation. Dedicated compiler regressions cover nested BSP-like
graphs, reference-member writes and allocation-time float boxing; the repeated
39-map product runs above are the corresponding integration gate.

## Gates not satisfied by this evidence

- process-to-process interoperability with runnable unmodified original 3.19
  client and server binaries (raw bidirectional Protocol-34 is passed);
- broader original-`ref_gl` coverage across GPUs plus runtime-transformed
  inline/alpha states (the two fixed world/water/MD2 differential scenes pass);
- exhaustive retail campaign playthrough behavior and frame-for-frame monster,
  weapon, turret and boss animation/muzzle/event exactness (retail
  class-state-machine, stock damage-emission and cross-map save/re-signon
  orchestration are passed);
- broader multi-host coop/deathmatch weapon/projectile gameplay beyond the
  two-client lifecycle/scoring/item matrix;
- manual input/audio/fullscreen/device-loss acceptance on release hardware.

## 2026-08-26 audit and performance validation

The final Release product was run twice for 5,000 rendered frames on retail
`base1`. The prior accepted baseline and the warm post-audit run were:

| Phase | Baseline (ms) | Conservative final run (ms) | Change |
|---|---:|---:|---:|
| Client | 2,331.4329 | 1,622.0910 | -30.4% |
| World | 2,131.7613 | 1,387.6843 | -34.9% |
| Entities | 1,449.1866 | 1,426.9642 | -1.5% |
| HUD | 317.4074 | 214.7664 | -32.3% |
| Present | 414.5741 | 174.0026 | -58.0% |
| Audio | 1,419.8205 | 1,088.2046 | -23.4% |
| Total measured frame work | 10,345.2984 | 8,184.9848 | -20.9% |

All post-audit runs completed with zero missing assets and zero observed
collections; the baseline observed one full collection. The two final runs
measured 7,910.39 and 8,184.98 ms; the latter maximum frame was 237.22 ms at
frame 1, wholly dominated by initial entity/asset setup, not an active-play GC
pause. The audio queue stayed bounded at eight buffers;
three startup underruns remained in this automated window/device run.

The optimized pending-audio microbenchmark mixes 327,680 output frames with 128
scheduled sounds in 16.89 ms median, down from 229.36 ms (13.6x, -92.6%). The
queue uses an ordered head instead of scanning every pending entry for every
sample; fixed-point mixing and reusable output/autosound storage remove adjacent
hot-loop allocation.

The long-running retail session gate completed 100,000 `base1` frames in
392,527.22 ms (254.76 unpaced simulation frames/s): 212,822 packets sent and
received, zero rejects, zero pending sounds, zero queued map changes, an empty
command buffer and a clean process exit. Additional retail results:

- 47-map spawn pass: 36,404 raw entities, 20,935 live, zero skipped, maximum
  883 live entities on `space`;
- 47-map retained BSP/collision window and the complete 39-map product graph;
- 39 consecutive Protocol-34 retail map sessions without a masked sign-on
  error;
- 600-frame bounded menu smoke, normal stock-attract startup gate and 1920x1080
  fullscreen video restart with identical 68-surface visibility before/after
  restart;
- 600 real movement/weapon snapshots, 1,342 packets and zero rejects;
- live Blaster chain with nine projectiles linked/freed and visibility at
  server export, snapshot, renderer and particle stages (1,183 particles max).

Retail-scale native test executables are now compiled with the same 2-GiB
virtual reserve and 1,536-MiB collection horizon as the product. The earlier
256-MiB test-only reserve could not retain four expanded BSP/collision graphs;
with the product contract both 39/47-map retention gates pass.

The 2026-08-26 whole-product performance audit additionally executes 500
rendered frames on every one of the 47 installed BSPs. All maps pass with zero
missing play assets and zero audio underruns; engine-work throughput ranges
from 133.26 to 724.23 fps with a 457.31 median. The audit exposed and fixed
multi-second heap-commit stalls on `fact2`, `ware1` and `ware2` by separating
the loading allocation horizon from the bounded active-gameplay horizon. See
[`ALL_LEVEL_FPS_2026-08-26.md`](ALL_LEVEL_FPS_2026-08-26.md).

Startup/media parity now also has a deterministic product gate: the stock
`d1` attract loop, `*ntro.cin+base1`, both complete release demos, campaign
CIN previews and OGG level music all pass against the installed retail data.
See [`MEDIA_STARTUP_AUDIT_2026-08-26.md`](MEDIA_STARTUP_AUDIT_2026-08-26.md).
