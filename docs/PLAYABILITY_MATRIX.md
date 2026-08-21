# MiniQuake2 Playability and Parity Matrix

This matrix is the working acceptance baseline for the remaining compatibility
release. `PASS` means that the named evidence is executable and deterministic;
it does not imply that adjacent behavior is complete. Retail scenarios read
only legal, user-supplied Quake II data and never copy it into the repository.

## Reproducible scenarios

| ID | Scenario | Current evidence | Status | Remaining parity gate |
|---|---|---|---|---|
| P01 | `base1` load, signon and first frame | `--play <root> base1 1`; client active, models/sounds complete, world PVS submitted | PASS | manual input/device sweep |
| P02 | Player move, look, use and Blaster | `runtime_multiplayer_deathmatch_tests.ml`, `game_api_combat_vertical_slice_tests.ml` | PASS | exact view/gun animation, recoil and feedback comparison |
| P03 | Dense `bunk1` snapshot | 39-map session smoke; 64-entity packet cap and adaptive packet budget | PASS | paired original snapshot/delta trace |
| P04 | `waste1` brush, water, MD2 and alpha rendering | deterministic G06 TGA replay and zero-pixel self-diff | PASS | paired original `ref_gl` capture and tolerance gate |
| P05 | Stock monster attack framing | `gameplay_monster_attack_sequence_tests.ml`; Gunner MZ2 45–52 live chain | PASS (partial families) | complete all monster animation, pain, death and attack variants |
| P06 | Save during an active monster sequence | Private-Save v5 fields in `gameplay_private_save_restore_tests.ml` | PASS | representative retail save positions and original-save policy |
| P07 | `boss2` endgame | Jorg staging, Makron successor, counter and changelevel with persistence | PASS | frame/weapon/audio parity for both bosses |
| P08 | Two-player deathmatch | real UDP Blaster kill, obituary, score and attack-latch respawn | PASS | all weapons, map rotation, spectator and long soak |
| P09 | Two-player cooperative play | shared item, disconnect/reconnect and non-stale signon epoch | PASS | campaign checkpoint matrix and friendly-fire/difficulty variants |
| P10 | Complete single-player map lifecycle | 39 maps, 38 changes/re-signons, no packet rejection | PASS | automated goal-driven progression rather than direct map changes |
| P11 | Original Protocol-34 process interop | independent bidirectional raw peer passes | PARTIAL | installed original 3.20 process exits before UDP on this host; rerun on compatible host |
| P12 | Release/package/device acceptance | manifest, asset exclusion, Release/Debug and package gates | PARTIAL | hardware matrix, original visual references and final performance budgets |

## Current attack-sequence coverage

The data-driven sequence layer follows the original 0.1-second game frame and
uses the original MZ2 identifiers. Random choices are deterministic functions
of edict number and persisted attack count, so save/reload and replay choose the
same branch. This block schedules weapon callbacks at the original relative
frames; the rendered monster models still use the generic AI move and therefore
remain an explicit model-animation parity gate.

| Family | Implemented sequence |
|---|---|
| Infantry | attack111 wind-up and 10–25 held machinegun frames, MZ2 26 |
| Gunner | 7-frame open, MZ2 45–52 chain with bounded 50% refire; four-grenade MZ2 53–56 alternative |
| Light/shotgun soldier | both stock attack layouts and their distinct MZ2 39/40 and 41/42 positions |
| Machinegun soldier | attack403 hold for 3–10 shots at the correct fourth position, MZ2 88 |
| Jorg | paired left/right six-frame machinegun cycle, MZ2 120/126, bounded 90% refire |
| Boss2 | paired machinegun loop and simultaneous four-rocket MZ2 78–81 frame |
| Makron | BFG, 17-frame hyperblaster and saved-position rail alternatives |
| Other active monsters | existing validated single-emission combat profile; exact per-frame variants remain open |

Private-Save v5 persists attack/melee/pain/death counts and the in-flight
`nextFrame`, `pauseTime` and `attackState`. A restored burst therefore resumes
at its next event rather than restarting or silently collapsing to one shot.

## Closure order

The remaining work is closed in this order because it follows what a player
sees and what later gates depend on:

1. Complete player weapon/view/impact feedback.
2. Complete every stock monster and boss frame table, attack variant and event.
3. Drive the 39-map campaign through real goals, movers, combat and transitions.
4. Compare fixed renderer scenes against original `ref_gl` output.
5. Expand audio, UI, menu and cinematic lifecycle comparisons.
6. Broaden save, coop and deathmatch state matrices.
7. Run original-process interoperability on a compatible Windows host.
8. Close malformed-input, performance, hardware and deterministic package gates.

Every block must leave its focused native test, adjacent regressions, project
syntax/inventory, Release build and relevant retail smoke green before it is
marked complete.
