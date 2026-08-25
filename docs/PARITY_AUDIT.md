# Quake II 3.19 Parity Audit

This audit separates implemented behavior from missing product functionality
and from acceptance evidence that requires another process, host or device. It
uses the bundled Quake II 3.19 source at commit
`372afde46e7defc9dd2d719a1732b8ace1fa096e` as the reference.

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
  immunity and deathmatch expiry, and persist across Private-Save v16.
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

## Remaining product limitations

The audited stock gameplay and Protocol-34 blocks above are implemented. Three
front-end differences remain visible but do not block campaign or network play:

- data-root selection is automatic or CLI-driven rather than a native Windows
  folder-picker dialog;
- Player Setup shows the selected skin as a 2D icon instead of the original
  rotating 3D player preview;
- the Join page supports LAN broadcast, address-book and numeric IPv4 targets,
  but not DNS-name resolution or an internet master-browser UI.

## Implemented behavior with evidence still open

The following areas do not have a presently identified missing stock callback,
but their 1:1 claim still needs broader evidence:

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

## Remaining closure order

1. Run the external-process, full-campaign, visual and hardware evidence gates.
2. Replace the three front-end limitations above if strict UI parity is made a
   release requirement.

Every functional block must retain the full MiniLang build, asset-free suite,
relevant retail smoke and source-integrity manifest before it is marked closed.
