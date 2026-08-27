# Quake II 3.19 Original-Parity Audit — 2026-08-26

This audit compares MiniQuake2 with the bundled, read-only Quake II 3.19
source at commit `372afde46e7defc9dd2d719a1732b8ace1fa096e`. It supplements the
function inventory in `PORT_LEDGER.json`: an inventory entry is not treated as
implemented evidence unless a live MiniLang path and a behavioral regression
exist.

## Method

The pass reviewed the original public engine/game entry points, the complete
`game/g_spawn.c` class table, and the stateful paths most likely to fail across
frames or maps. In particular, it compared:

- `server/sv_world.c` and `game/g_phys.c` collision and pusher transactions;
- `game/g_spawn.c`, `g_misc.c`, `g_target.c`, `g_func.c`, and `m_actor.c`;
- `game/p_client.c`, `p_hud.c`, `p_weapon.c`, and `g_combat.c`;
- Game API map lifecycle, persistent client data, configstrings, private saves,
  cooperative spawn corrections, and intermissions;
- product-level menu/game/map handoff, because MiniQuake2 creates a fresh Game
  API graph for a successor map whereas the original retains `game.clients` and
  `game.serverflags` in one process.

The audit used source comparison, focused native MiniLang tests, a complete
asset-free build matrix, and retail `pak0.pak` smoke runs. Retail assets remain
external and are never copied into this repository.

## Defects closed in this pass

### Elevator and pusher transaction

The moved `func_plat`/`func_train` state was not relinked after a successful
pusher resolution. Its origin advanced while the server broad-phase bounds
remained at the old floor, allowing Pmove to miss the elevator hull. The port
now follows `SV_Push` by quantizing translation to one eighth of a unit,
relinking every moved team part before rider tests, performing a stationary
target-position trace with the body's clip mask and self pass-entity, applying
the translation-only fallback, updating player delta-yaw, and rolling the
complete team transaction back on a blocker. `MOVETYPE_STOP` carries explicit
ground-entity riders but does not push non-riders.

The authoritative server trace now also clips against linked dynamic
`SOLID_BBOX` entities. It maintains an O(1) link/unlink index, performs a
Minkowski swept-box trace with the original distance epsilon, honors
pass-entity, both owner directions and dead-monster contents, and publishes
the Protocol-34 packed solid value used by client prediction. The earlier
Game-side second BBOX scan has been removed, avoiding duplicate work and
conflicting start-solid semantics on every monster movement trace. The live
`ClientThink` path now also installs the current player as `pm_passent` around
Pmove; without that original global contract a player collided with its own
newly indexed box and could not move.

### Product map-transition state

Settings no longer round-trip through a possibly stale disk file between two
maps. A version-2 product config transfers an in-memory snapshot, serializes
integral floats in valid MiniLang syntax, and stores a complete binding table
so intentional unbinds survive. Version 1 remains readable as an overlay.

A separate typed, owned gameplay handoff mirrors the original persistent
process state. It preserves health, maximum health, inventory, ammunition
capacities, selected/current/last weapon, persistent flags, Power-Cube mask,
scores, cooperative respawn checkpoint, cross-level server flags, and global
help messages. Mutable arrays are deep-copied. Validation occurs before any
successor mutation, and capture/restore errors abort the transition instead of
silently starting with partial defaults.

### Worldspawn, intermission, and cooperative lifecycle

`SP_worldspawn` now publishes the authored level title, sky, sky rotation and
axis, CD track, maximum clients, item names, gravity, next map, and the stock
animated lightstyle strings at indexes 0–11 and 63. The engine-side session
synchronizer only supplies a map-name fallback and no longer overwrites the
authored title. The original unconditional player/environment sounds, sexed
weapon models, and gib models are registered during map startup rather than on
first use.

Intermissions now distinguish immediate ordinary single-player transitions
from unit transitions, select an authored intermission camera with the stock
fallback, freeze and hide clients, clear active powerups, show multiplayer
scores, respawn dead clients, and strip cooperative keys between units.
The shipped cooperative spawn corrections for `security` and the fourteen
maps repaired by `SP_FixCoopSpots` are applied to the managed spawn records.

### Spawn and world callback table

The previously missing live paths for `path_corner`, direct
`func_areaportal` use, `viewthing`, `light_mine1`, `misc_bigviper`,
`misc_gib_arm`, and `misc_gib_leg` are installed. `path_corner` includes
`pathtarget`, teleport corners, target advancement, wait, and actor callback
handoff. `target_crosslevel_target` performs one delayed check and frees itself
whether or not its flags match.

`misc_actor` is implemented as an actual AI actor rather than a registry stub:
deathmatch and malformed-spawn gates, dormant activation, `target_actor`
routing, original bounded animation ranges and movement distances, machine-gun
burst, pain/skin/debounce behavior, player taunts, regular deaths, and its
organic gib inventory are represented in the live Game API path and private
save restoration.

### Player, difficulty, and save data

Easy skill now applies the original half-damage/minimum-one rule to all client
damage paths, including monster attacks, hitscan, and projectiles; damage to
monsters and world entities is unchanged. Cooperative respawn inventories are
value snapshots instead of aliased arrays, Power-Cube masks are consumed
across the participating clients, and death clears power-armor and weapon-loop
state.

Private-Save version 18 adds ammunition capacities, selected item,
silencer-shot count, Power-Cube mask, and the cooperative checkpoint while
retaining backward readers for older versions.

`target_changelevel` now receives `other` and `activator`, rejects a dead
single-player exit, applies the deathmatch no-exit `MOD_EXIT` damage policy,
broadcasts an allowed deathmatch exit, clears cross-level flags only after a
successful policy check, and applies the shipped case-insensitive
`fact1 -> fact3$secret1` repair at spawn time.

Player death now creates the original live dropped weapon and optional Quad
item edicts in deathmatch. A cooked hand grenade is emitted through the normal
projectile/explosion/free lifecycle after the owner has entered `DEAD_DEAD`,
preventing recursive first-death handling.

## Evidence added or strengthened

- elevator/pusher transaction and a moved inline-BSP server trace;
- linked dynamic-BBOX server/PMove collision, owner/dead-monster filtering and
  packet-solid encoding;
- real `base1` to `base2` retail changelevel with successor frames;
- product config v1/v2 compatibility, unbind persistence, and in-memory
  preference precedence;
- deep-copy gameplay handoff and rejection-before-mutation;
- authored worldspawn configstrings, lightstyles, precache inventory, gravity,
  and next-map state;
- cooperative spawn fixes, death checkpoint, intermission camera and cleanup;
- stock registry and live Game API behavior for the newly installed classes;
- easy-skill client damage through both direct and integrated weapon paths;
- target-changelevel policy and live weapon/Quad/cooked-grenade death drops;
- private-save v18 round-trip and legacy-version defaults.

## Gameplay deviations closed on 2026-08-27

The four bounded differences identified by this audit are now implemented:

- eight fixed Body Queue edicts with corpse damage/gibs and private-save state;
- generic freed-edict reuse with inactive-history isolation and the original
  timing guard;
- separate player-persistent `game_helpchanged`/`helpchanged` counters;
- shared `FLYMISSILE`/pusher rollback plus success/blocked mover-think ordering.

Focused regressions cover live Game API numbering and corpse copies, allocator
reuse timing, save/restore, per-player help reminders, missile displacement,
successful post-move thinks and blocked-frame think deferral. The remaining
declared scope boundaries are unchanged:

- foreign native `gamex86.dll` and renderer DLL loading, the software renderer,
  CTF, non-Windows platforms, and additional rendering backends remain the
  previously declared out-of-scope or deferred targets.

External evidence remains necessary for a human-driven full campaign,
side-by-side original visual/AI/demo timing, compatible-process protocol tests,
and a second GPU/audio/input host. None of those external gates is represented
as completed by this source audit.
