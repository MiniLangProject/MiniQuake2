# Retail validation evidence

Validation date: 2026-08-21 (Europe/Berlin)

The tests below used the user-owned classic Steam installation at
`C:\Program Files (x86)\Steam\steamapps\common\Quake 2`. No game data was
copied into the project, build products, or release archives. The installation
also contains a separate `rerelease` directory; all results below use the
classic root and classic `baseq2` PAK files only.

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
gib sound; Private Save v13 resumes its references, sight state and cooldown.
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
 explosion-entry offsets. Private Save v13 retains a running attack or
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
through Private Save v13. A held Soldier SS death burst also resumes with its
remaining shot count. Paired original full-encounter traces remain open, but no
reachable stock pain/death movement or secondary callback table is known
missing. Gunner, Medic,
 Chick, Flyer, Hover, Tank,
 Soldier, Supertank, Jorg and Boss2 now make their live stock refire decisions
 from the persisted shared CRT stream. Brain follow-up and Mutant jump decisions
 likewise happen at their original callback frames rather than during plan
 construction.

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
state. The integrated DM gate additionally observes moving Blaster projectile
edicts in both real client snapshots and the resulting muzzle light/sound and
blood particles through the normal Protocol-34 dispatcher. This closes the
stock player weapon state/protocol vertical slice; paired original view-model,
kick and per-frame visual capture remains an explicit acceptance gate.

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
chain. The full run completed stream frame 81 exactly once with zero drops and
254,976 mixed stereo frames. This retail gate exposed and fixed the original
decoder's legal leaf-255 fallback for unused zero-count Huffman context rows.
See [`CINEMATIC_ACCEPTANCE.md`](CINEMATIC_ACCEPTANCE.md).

The original `SV_Map` grammar is additionally exercised with the installed
`eou1_.cin+*bunk1$start` and `end.cin+victory.pcx` chains. CIN, terminal PCX
and named map spawn all pass through one product-owned window/renderer
lifecycle; `end.cin+victory.pcx` reports generation 1 and two loading frames.
The native `--video-restart-smoke` replaces a 640x480 windowed renderer with a
1280x720 fullscreen window and GL context,
re-registers `base1`, and produces the same 60 visible surfaces before and
after restart; see
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
