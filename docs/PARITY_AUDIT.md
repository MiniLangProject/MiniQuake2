# Quake II 3.19 Parity Audit

This audit separates implemented behavior from missing product functionality
and from acceptance evidence that requires another process, host or device. It
uses the bundled Quake II 3.19 source at commit
`372afde46e7defc9dd2d719a1732b8ace1fa096e` as the reference.

## Closed in the current weapons, brush and audio pass

- Protocol-34 string commands now retain their exact token and argument
  context through Game API `argc`/`argv`/`args`. `use`, `weapnext`,
  `weapprev` and `weaplast` drive the real player inventory, including stock
  `0`-`9` and mouse-wheel defaults that are also added to existing configs.
- A real UDP regression proves named selection, both cycle directions, last
  weapon, rejected unavailable weapons and the resulting client view model.
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

## Confirmed missing product functionality

These are code gaps, not merely missing comparison captures.

| Priority | Area | Evidence in MiniQuake2 | Quake II 3.19 behavior still required |
|---|---|---|---|
| P0 | Remaining Game client commands | Weapon selection/cycling is implemented through Game API arguments, but the remaining `g_cmds.c` dispatch surface is absent | chat/team chat, score/help/players, inventory select/use/drop, arbitrary item use/drop, kill, wave, player list and gated cheat commands |
| P0 | Product startup | running the executable without CLI arguments prints usage and exits; `--play ROOT MAP` creates the session before showing the main menu | persistent application startup, data-directory selection/discovery, menu-before-map lifecycle and clean connect/disconnect transitions |
| P0 | Multiplayer UI | the Multiplayer page contains disabled labels and an explicit parity placeholder; Player Setup exposes handedness only | Join Server, Start Server, address book/server discovery, deathmatch options, downloads, player name/model/skin selection and preview |
| P1 | Client downloads | Protocol-34 chunks are validated and accumulated in memory, but the retail product does not request missing precache assets, install them safely or retry registration | original staged map/model/sound/image/player download workflow with policy toggles and traversal-safe persistence |
| P1 | Server administration | `null_game.ServerCommand` logs that the admin set is pending; RCON and master-server calls are not connected to product sessions | `sv test/addip/removeip/listip/writeip`, connect filtering, RCON execution and configured master heartbeat/shutdown lifecycle |
| P1 | Music | `CS_CDTRACK` exists but no gameplay music/CD-track backend consumes it | level/intermission track playback and stop/resume lifecycle; a modern legal-file backend can be additive but must preserve track semantics |
| P1 | Single-player pause | opening the gameplay menu does not pause the authoritative listen server | original single-player pause semantics while menus/console remain responsive |
| P1 | Remaining sound parity | Core one-shots and snapshot loops play, but active one-shots retain their initial spatialization; sexed sounds currently use a male fallback; several monster loops and `func_water` phases are not published | per-frame active-channel spatialization, entity-specific female/cyborg sounds, Flyer/Hover/Floater/Boss2 and conditional Jorg/Makron loops, `mov_watr`/`stp_watr`, and exact `S_PickChannel` priority/delayed replacement semantics |
| P1 | Remote-client solid prediction | the listen product predicts through its authoritative collision bridge, but a standalone remote-client path does not yet clip against dynamic solid packet entities | `CL_ClipMoveToEntities`-equivalent prediction against moving doors, platforms, trains, players and monsters using Protocol-34 `solid` state |
| P2 | Original client utilities | playback and deterministic test capture exist, but the product command surface has no demo recording or screenshot command | record/stop DM2 lifecycle and user screenshot output |
| P2 | Video/input completion | `vid_gamma` is persisted but not applied; no product controller path is present | hardware gamma where supported, original fallback behavior and joystick/controller input mapping |
| P2 | Save interoperability/presentation | versioned MiniLang saves and three durable slots work | an explicit original-save import policy plus classic slot screenshot/timestamp presentation if compatibility scope requires it |

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

## Closure order

1. Complete the remaining Game API client-command families now that command
   text, weapon selection and weapon cycling are connected; retain two-client
   UDP tests for every family.
2. Introduce the persistent menu-first application lifecycle and complete the
   Join/Start/Player Setup pages.
3. Connect precache downloads, safe client persistence, server administration,
   filtering, RCON and master discovery.
4. Add level music and correct single-player pause behavior.
5. Close demo recording, screenshots, gamma/controller and save-import policy.
6. Run the external-process, full-campaign, visual and hardware evidence gates.

Every functional block must retain the full MiniLang build, asset-free suite,
relevant retail smoke and source-integrity manifest before it is marked closed.
