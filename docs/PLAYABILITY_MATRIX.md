# MiniQuake2 Playability and Parity Matrix

This matrix is the working acceptance baseline for the remaining compatibility
release. `PASS` means that the named evidence is executable and deterministic;
it does not imply that adjacent behavior is complete. Retail scenarios read
only legal, user-supplied Quake II data and never copy it into the repository.

## Reproducible scenarios

| ID | Scenario | Current evidence | Status | Remaining parity gate |
|---|---|---|---|---|
| P01 | `base1` load, signon and first frame | `--play <root> base1 1`; client active, models/sounds complete, world PVS submitted | PASS | manual input/device sweep |
| P02 | Player move, look and all stock weapons | `gameplay_player_weapon_protocol_tests.ml`, `runtime_multiplayer_deathmatch_tests.ml`, ballistics goldens | PASS (mechanics) | paired original view-model/recoil capture |
| P03 | Dense `bunk1` snapshot | 39-map session smoke; 64-entity packet cap and adaptive packet budget | PASS | paired original snapshot/delta trace |
| P04 | `waste1` brush, water, MD2 and alpha rendering | paired installed-original `ref_gl` gate: 2,303 ppm MAE for world/water/MD2; deterministic Mini replay | PASS (differential) | broaden cameras, GPUs and alpha/inline runtime states |
| P05 | Stock monster frame sequencing | attack/ranged/melee, 63 pain, 43 death, dodge, primary locomotion, class corpse bounds, stock physical gibs and staged Supertank destruction; live MZ2 and Parasite beam chains | PASS (primary moves and death terminals) | secondary fidgets and exact per-frame movement differential |
| P06 | Save during an active monster sequence | Private-Save v10 attack/reaction fields, dynamic World references, boss persistence and live-gib round trip | PASS | original-save import policy |
| P07 | `boss2` endgame | Jorg staging, Makron successor, counter and changelevel with persistence | PASS | frame/weapon/audio parity for both bosses |
| P08 | Two-player deathmatch | all 11 stock weapon modes through real UDP UserCmds, projectiles/effects, scoring/respawn, spectator transition, maplist re-signon and post-change soaks | PASS | functional local gate complete; remote-host/device soak belongs to P12 |
| P09 | Two-player cooperative play | shared item/reconnect, skill 0/3, teammate damage, plus 39-BSP/51-goal-transition route with 39 live two-player checkpoints | PASS | functional local gate complete; remote-host/device soak belongs to P12 |
| P10 | Complete single-player map lifecycle | direct 39-map transport smoke plus 39-unique-BSP/51-change goal route through keys, counters, timers, triggers, deaths, bosses and `victory.pcx` | PASS (goal graph) | physical navigation, combat clearing and item-resource playthrough |
| P11 | Original Protocol-34 process interop | independent bidirectional raw peer passes | PARTIAL | installed original 3.20 process exits before UDP on this host; rerun on compatible host |
| P12 | Release/package/device acceptance | full 335-file Release/native matrix, 374-file manifest, Debug product graph, byte-reproducible packages, extracted-package smoke and original-renderer visual gates | PARTIAL | hardware matrix, device-loss/manual input/audio and final performance budgets |
| P13 | Retail cinematic, demo and intermission playback | product `--cinematic` completes `idlog.cin`; installed `demo1.dm2` completes 696 packets/688 rendered frames; one shared host executes DM2/map and installed unit/end chains; `--play` consumes validated queued `gamemap` | PASS (product chain) | paired original demo timing/pixel trace on compatible host |
| P14 | Product menu, inventory and volume | live mode restart, persistent config/key capture, difficulty-aware New Game, durable same/cross-map slots, settings/quit, inventory and mixer gain | PASS (product lifecycle) | hardware gamma and richer save-slot presentation |

## Current attack-sequence coverage

The data-driven sequence layer follows the original 0.1-second game frame and
uses the original MZ2 identifiers. Random choices are deterministic functions
of edict number and persisted attack count, so save/reload and replay choose the
same branch. This block schedules weapon callbacks at the original relative
frames and projects every attack timeline onto its stock MD2 frames. A companion
reaction/movement layer contains 63 pain variants, 43 normal-death variants,
the stock duck/dodge ranges for six families, and primary stand, idle, walk and
run ranges for all 22 combat entries. Death terminals apply per-class corpse
bounds, exact per-family gib model/count inventories, timed exported gib
edicts, immediate flying-monster explosions and the Supertank's eight-stage
explosion/final-gib chain. Secondary fidgets and exact movement distances
remain a separate differential-parity gate.

| Family | Implemented sequence |
|---|---|
| Infantry | attack111 wind-up and 10–25 held machinegun frames, MZ2 26 |
| Gunner | 7-frame open, MZ2 45–52 chain with bounded 50% refire; four-grenade MZ2 53–56 alternative |
| Light/shotgun soldier | both stock attack layouts and their distinct MZ2 39/40 and 41/42 positions |
| Machinegun soldier | attack403 hold for 3–10 shots at the correct fourth position, MZ2 88 |
| Jorg | paired left/right six-frame machinegun cycle, MZ2 120/126, bounded 90% refire |
| Boss2 | paired machinegun loop and simultaneous four-rocket MZ2 78–81 frame |
| Makron | BFG, 17-frame hyperblaster and saved-position rail alternatives |
| Gladiator/Tank/Medic/Chick/Flyer/Floater/Hover/Supertank | stock ranged wind-up, burst/refire, muzzle order and MD2 frame projection |
| Berserk/Infantry/Flipper/Chick/Flyer/Brain/Floater/Mutant | stock close-combat loops, event damage and MD2 frame projection |
| Parasite | 18-frame drain move, first/subsequent damage split and ordered `TE_PARASITE_ATTACK` beam handoff |

Private-Save v10 persists attack/melee/pain/death counts, reaction debounce and
the in-flight `nextFrame`, `pauseTime` and `attackState`. A restored attack or
reaction therefore resumes at its next event rather than restarting or
silently collapsing to one shot; dynamic gib entities retain model, physics
state and expiry across a level save.

The v10 world payload length-prefixes the complete retail entity text instead
of using the network string limit, reconstructs dynamic `DelayedUse` and gib
edicts, and restores activator/owner/team/target/enemy/ground references by
stable edict number. Readers remain compatible with the earlier v7/v8 payloads.

## Current player-weapon coverage

The managed player path now follows the stock `p_weapon.c` fire boundaries for
Blaster, Shotgun, Super Shotgun, Machinegun, Chaingun, grenade/rocket launcher,
HyperBlaster, Railgun, BFG10K and the special cooked hand grenade. Golden tests
cover the Shotgun pump frame, BFG wind-up and late ammo recheck, held/released
Machinegun and HyperBlaster loops, all three Chaingun burst stages, infinite
ammo, handed muzzle projection, recoil, silencing and hand-grenade cook/release.

Every real shot emits Protocol-34 player muzzle flashes and appropriate impact,
blood, armor-spark, splash, bubble, rail, explosion and BFG temp entities.
Managed moving projectiles own reusable engine edicts with the stock model,
effect and loop-sound fields; a real two-client UDP gate observes a live bolt
in both snapshots before the normal seven-shot Blaster kill. Remaining evidence
is visual/differential rather than a known missing player-weapon family: paired
original view-model/recoil captures. The
separate rotation gate changes a connected spectator back into a solid player
through reliable `clc_userinfo`, reaches a frag-limit intermission, consumes
the queued `gamemap`, re-signs both clients on the successor map without
rewinding either Netchan, and then runs 500 additional server frames without a
rejected packet.

`runtime_multiplayer_all_weapons_tests` equips each stock weapon only as test
setup, then requires the actual attack to travel through a decoded UDP UserCmd.
Blaster, both shotguns, Machinegun, Chaingun, both launchers, HyperBlaster,
Railgun and BFG produce bilateral muzzle handoffs; the cooked hand grenade
becomes a networked `hgrenade` visible in both snapshots. Every ammo cost and a
300-frame post-matrix soak are checked under both normal and 4-MB GC limits.

## Closure order

The remaining work is closed in this order because it follows what a player
sees and what later gates depend on:

1. Complete player weapon/view/impact feedback.
2. Complete every stock monster and boss frame table, attack variant and event.
3. Drive the 39-map campaign through real goals, movers, combat and transitions.
4. Broaden the passing fixed-scene original `ref_gl` differential across GPUs and runtime alpha/inline states.
5. Product lifecycle is closed for one-window media chains, live mode restart,
   key capture, difficulty-aware New Game and persistent save slots; retain
   hardware gamma and richer save-slot presentation as remaining polish.
6. Broaden save, coop and deathmatch state matrices.
7. Run original-process interoperability on a compatible Windows host.
8. Close malformed-input, performance, hardware and deterministic package gates.

Every block must leave its focused native test, adjacent regressions, project
syntax/inventory, Release build and relevant retail smoke green before it is
marked complete.

The current local Release/Debug/package evidence is recorded in
[`RELEASE_ACCEPTANCE.md`](RELEASE_ACCEPTANCE.md). P12 remains partial only for
the explicitly hardware- or external-host-dependent gates listed there.
