# Quake II 3.19 Parity Audit

This audit separates implemented behavior from missing product functionality
and from acceptance evidence that requires another process, host or device. It
uses the bundled Quake II 3.19 source at commit
`372afde46e7defc9dd2d719a1732b8ace1fa096e` as the reference.

## Closed in the 2026-08-28 exhaustive follow-up

- `G_RunFrame` now advances non-client edicts by global edict number. Dynamic
  spawns can participate later in the same frame, pusher teams run atomically at
  their captain, team slaves are skipped, and monster combat cannot run before
  the actor's scheduled think.
- Toss/bounce entities, projectiles and dropped items use stock gravity,
  ground-link invalidation, collision masks, water transitions, relinking and
  trigger contact. Mapper `trigger_gravity` key presence remains distinct from
  the edict's physical default multiplier.
- Pusher transactions include standing riders, items and projectiles and invoke
  the stock post-move trigger pass. This closes the elevator/floor clipping and
  door-crush regressions without a geometry-only rider heuristic.
- Private-Save v21 serializes the remaining live projectile, player transient,
  noise, enemy/owner and AI-reference state while preserving older readers.
  Staged Jorg-to-Makron restoration and successor timing have dedicated tests.
- Snapshot visibility follows the original solid/PVS, beam/PHS and sound-only
  cutoffs. Client prediction, save/load menus, controls, inventory, preferences,
  reconnect, RCON, timedemo reporting and campaign archive/autosave behavior
  now cover their previously bounded gaps.
- The classic renderer performs the stock opaque/entity/deferred-alpha order,
  dynamic and brush lightmaps, MD2 culling/winding/lerp, water dual-cluster PVS,
  texture mip chains, animated brush frames and TGA sky fallback. Hot sky and
  warp paths reuse fixed buffers, and paused autosounds remain active.
- Dedicated console input and operator commands are live. Command/cvar services
  now enforce stock expansion and validation rules and emit persistent archive
  state.

These closures are implementation claims backed by deterministic regressions.
Retail campaign traversal, physical input, audio hardware, GPU drivers and long
interactive sessions remain explicit external acceptance evidence.

## Closed in the current source-parity pass

- Protocol-34 string commands now retain their exact token and argument
  context through Game API `argc`/`argv`/`args`. `use`, `weapnext`,
  `weapprev` and `weaplast` drive the real player inventory, including stock
  `0`-`9` and mouse-wheel defaults that are also added to existing configs.
- A real UDP regression proves named selection, both cycle directions, last
  weapon, rejected unavailable weapons and the resulting client view model.
- The remaining bounded `g_cmds.c` families are connected: global/team chat,
  flood protection, score/help/players/playerlist, inventory selection and
  use, arbitrary item use, kill, wave, putaway and the stock gated
  give/god/notarget/noclip commands. Real Protocol-34 tests cover both the
  client command surface and three-client team/flood routing.
- `ED_LoadFromFile` now applies the stock skill/deathmatch spawnflag filters,
  including the original `command` and `trigger_once` map hacks, before a
  class spawn callback runs. The raw parser API remains intentionally
  unfiltered for tools and parser tests.
- Previously simplified retail world behavior now follows the original
  callbacks: `trigger_push`, `trigger_monsterjump`, `func_water`, two-stage
  secret doors, `target_laser`, `target_earthquake`, `target_blaster`, retail
  `target_spawner`, `func_object`, gib entities and toss/bounce physics.
- Client interpolation now includes model/teleport/large-jump lerp resets,
  1/16-unit water camera nudge, 100-ms stair smoothing, animated lightstyles,
  interpolated animation/sky/warp time, area-bit culling and the actual
  `RefDef.blend` polyblend.
- Server timeouts call Game `ClientDisconnect` exactly once for spawned
  clients. Snapshot acknowledgements populate the original 16-sample latency
  ring and synchronize the averaged ping into both server-client and Game
  client state.
- Moving inline BSP entities are linked by their complete bounds, all touched
  PVS clusters and both areas. Doors whose origin lies in a solid or hidden
  leaf therefore remain visible, including cluster-overflow fallback for
  large trains and rotating brushes. This path covers 1,923 relevant brush
  entities across the 47 retail maps.
- Snapshot `EntityState.sound` values now feed an allocation-free autosound
  mixer path. Identical loops are merged and current-frame removal or
  replacement stops/changes the channel, restoring projectile, mover,
  teleporter and ambient-speaker loops.
- Door, rotating-door, secret-door, platform, button and train sound phases
  are connected. `target_speaker` preserves authored volume/attenuation and
  reliable flag, local sounds remain full-volume, and player-relative sounds
  receive the available male fallback.
- Mixer spatialization now uses the stock 80-unit full-volume radius,
  attenuation scale and centered `ATTN_NONE`; protocol `timeofs` delays a
  sound instead of skipping its initial PCM samples.
- Client render submission is capped at the stock 128-entity limit, so dense
  multi-model/effect snapshots truncate safely instead of overrunning the
  renderer handoff.

- Active Protocol-34 clients now receive reliable configstring changes made
  after sign-on, including removals. This is required by the original
  `g_weapon.c` behavior, which may call `modelindex`/`soundindex` only when a
  projectile is first spawned.
- The live client asset registry now loads and clears changed indexed models
  and sounds without resetting the map generation. Late `#w_*.md2` player
  weapon entries also rebuild the affected client-info bindings.
- Blaster, grenade, hand-grenade, rocket and BFG projectiles own explicit stock
  model and loop-sound state rather than relying on a renderer-side classname
  workaround.
- BFG flight uses `s_bfg1.sp2`, its loop sound and
  `EF_BFG | EF_ANIM_ALLFAST`; impact switches to `s_bfg3.sp2`, stops the loop
  and clears `EF_ANIM_ALLFAST`, matching Quake II 3.19.
- Native regression coverage now proves the dynamic server-to-client
  configstring path, client-side late asset registration, BFG state changes,
  and real two-client UDP model, loop-sound and visible-motion handoff for
  Blaster/HyperBlaster bolts, both grenade families, rockets and BFG shots.
- Stock `SpawnItem` now performs the delayed 128-unit `droptofloor` trace,
  start-solid rejection, exact item effects/flags, random team-item exposure,
  one-shot target firing, cooperative Power-Cube masks and deathmatch item
  inhibition. `drop` and `invdrop` allocate real toss edicts, retain owner
  immunity and deathmatch expiry, and persist across Private-Save v17.
- `target_explosion` and `target_splash` now publish exact
  `TE_EXPLOSION1`/`TE_SPLASH` multicast payloads. Untargeted doors and plats
  create live engine-backed touch fields; `func_conveyor`, `trigger_gravity`,
  `trigger_push` and `trigger_hurt` retain the original state, sound and damage
  rules.
- Monster end-frame processing now includes drowning, swimmer suffocation,
  lava/slime damage and water sounds, corpse flies, trigger-spawn activation,
  `point_combat` normalization and Brain power-screen absorption/effects. The
  new runtime adapters connect targets, damage, KillBox, sound indices and
  save/restore rather than leaving these as component-only callbacks.
- Active one-shots are re-spatialized each mixer update. The mixer now uses
  the stock 32-channel arbitration rules and bounded 128-entry pending queue,
  handles `ATTN_STATIC`, and resolves entity-specific female/cyborg sounds.
- Server clients apply the original userinfo `rate` clamp and ten-message
  `SV_RateDrop` accounting, including loopback exemption, `suppressCount` and
  snapshot-size history.

- No-argument startup now discovers Quake II data roots, remembers an explicit
  `--data-root`, opens the main menu before creating a gameplay session and
  performs clean local/remote connect and disconnect transitions.
- Multiplayer pages now provide Join Server, Start Server, LAN discovery,
  address-book entries, player setup, download policy, server options and the
  stock deathmatch flags. Preferences are persisted independently of gameplay
  saves.
- Remote clients execute the staged Protocol-34 precache/download workflow for
  maps, models and their skins, sounds, images, skies and player assets. Paths
  are traversal-safe, partial files resume, completed files install atomically,
  and map checksum plus registration gates prevent premature `begin`.
- Remote prediction clips against world and packet-entity solids, including
  translated and rotated inline BSP movers. Ground flags, the world sentinel
  and `PMF_NO_PREDICTION` match the server contract.
- Server administration now includes IP filtering and persistence, bounded
  RCON command execution, master heartbeat/shutdown packets, dedicated command
  routing and authoritative single-player pause behavior.
- `CS_CDTRACK` drives streamed OGG level/intermission music with focus, pause,
  map-transition and shutdown lifecycle. Track lookup supports retail and
  rerelease filesystem layouts without per-frame buffer concatenation.
- The product command surface now records DM2 files incrementally, stops them
  atomically and writes collision-free TGA screenshots from the rendered
  framebuffer.
- Hardware gamma is applied/restored where supported, while controller input
  supplies persistent enablement, analog movement/look and menu navigation.
- Save slots reject unsupported foreign native formats explicitly and carry
  map, frame, timestamp and screenshot metadata with verified atomic writes.
- BSP PVS submission now caches by cluster and area-bit contents. This removes
  the prior full retail-world surface walk on every frame while preserving
  door/area visibility invalidation.
- Remote clients resolve DNS names through the existing native network bridge,
  preserve fatal sign-on/checksum/download failures, pace keepalives separately
  from approximately 90-Hz UserCmd delivery and reuse prediction scratch state.
- Player Setup now renders the selected skin on the original rotating 144x168
  MD2 preview. Reset Defaults and Go to Console execute their stock actions;
  the stock attract loop plus input-to-menu handoff, Join/Start Server and DM
  options are product-level gates.
- `MOVETYPE_BOUNCE` uses the stock 1.5 overbounce and floor-rest threshold.
  Generic toss/bounce entities update water type/level and emit the original
  transition sound. Private-Save v17 persists those fields while reading v7-v16
  payloads with dry defaults; restored dynamic monster gibs retain `gib_die`.
- BFG laser temp entities use the stock palette, `PMF_NO_PREDICTION` view angles
  follow the server, and packet projectiles retain their original render flags
  plus dynamic-light paths rather than a synthetic fullbright workaround.
- The active render, visibility, snapshot, prediction, effect and audio paths
  reuse bounded scratch storage. The pending-audio queue no longer scans every
  pending entry for every mixed sample; its 327,680-frame/128-pending benchmark
  improved from 229.36 ms to 12.89 ms in the final 2026-08-29 release run. Live
  mixers and server message routing now use fixed-capacity prefix queues, while
  compatibility views are retained only for diagnostic callers. World
  visibility, material passes, brush submissions, alpha records and lightmap
  dirty checks no longer compact or allocate wrappers for every visible
  surface on every frame. Interactive play also omits detailed heap/phase
  probes; bounded audit runs retain the complete telemetry.
- Config v3 archives `cl_maxfps` and `gl_swapinterval`; both are live menu
  controls, survive map handoff/restart and drive the high-resolution frame
  deadline plus native swap interval. Config v1/v2 files upgrade with the
  original 90-fps/vertical-sync defaults.

## Stock product parity status

The dated source-to-port follow-up in
[`ORIGINAL_PARITY_AUDIT_2026-08-26.md`](ORIGINAL_PARITY_AUDIT_2026-08-26.md)
records the latest closed defects and the remaining scoped differences. A
registered classname, a source-inventory entry, or a campaign route smoke is
not treated as proof that every callback and frame-ordering detail is 1:1.

Data-root selection remains automatic or CLI-driven because a native folder
picker was not part of the original product. Likewise, the original 3.19 Join
Server menu provided LAN discovery/address-book entries rather than an
internet master browser, so absence of a modern public-browser service is not
a parity gap.

## Locally implemented; external evidence still open

The following areas still need broader evidence before a 1:1 claim:

- a complete human-driven campaign playthrough with normal navigation,
  resource use and combat rather than deterministic goal routing;
- paired original full-encounter AI, boss, weapon recoil/view-model, demo timing
  and expanded renderer captures;
- original 3.19/3.20 process interoperability on a compatible Windows host;
- a second GPU/driver and audio endpoint, hot-unplug, alt-tab and manual input
  latency coverage.

## Explicitly deferred scope

CTF, original native `gamex86.dll`/renderer DLL ABI loading, the software
renderer, non-Windows targets and additional modern render backends remain
outside the baseq2 compatibility release. They must not be counted as gaps in
the scoped Quake II 3.19 base-game port.

## Closed in the 2026-08-27 gameplay follow-up

- The eight-entry Body Queue now occupies the original fixed range immediately
  after the client edicts. Corpse copies retain presentation, bounds, collision,
  damage and gib behavior; the ring position survives private saves.
- All dynamic gameplay paths use one `G_Spawn`/`G_FreeEdict`-equivalent pool.
  Freed slots retain the original startup relaxation and 0.5-second reuse
  delay. Inactive managed records retain their historical number for private
  save reconstruction but are excluded from live lookup and publication when
  that number is reused.
- `FLYMISSILE` projectiles participate in the same pusher transaction as
  players, monsters and toss bodies. Due mover thinks execute only after a
  successful push; a blocked team rolls back and delays its scheduled thinks
  by one server frame.
- `game_helpchanged` and `helpchanged` are player-persistent fields. Help-page
  acknowledgement, blinking F1 icon and the three reminder sounds no longer
  share one global client state and survive save/restore and level handover.
- Stock `func_killbox` inline models retain bounds for use-time telefragging but
  stay `SOLID_NOT`/`MOVETYPE_NONE`; they no longer block the retail
  `biggun$bstart` player hull.

## Remaining external validation

1. Run the external-process, full-campaign, visual and hardware evidence gates.

Every functional block must retain the full MiniLang build, asset-free suite,
relevant retail smoke and source-integrity manifest before it is marked closed.
