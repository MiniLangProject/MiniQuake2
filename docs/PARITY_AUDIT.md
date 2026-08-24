# Quake II 3.19 Parity Audit

This audit separates implemented behavior from missing product functionality
and from acceptance evidence that requires another process, host or device. It
uses the bundled Quake II 3.19 source at commit
`372afde46e7defc9dd2d719a1732b8ace1fa096e` as the reference.

## Closed in the current projectile pass

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
  and a real two-client UDP Bolt model/sound handoff.

## Confirmed missing product functionality

These are code gaps, not merely missing comparison captures.

| Priority | Area | Evidence in MiniQuake2 | Quake II 3.19 behavior still required |
|---|---|---|---|
| P0 | Game client commands | `null_game.ClientCommand` only increments a counter; the network adapter also discards the command text before Game API `argc/argv/args` | chat/team chat, score/help, inventory select/use/drop, weapon cycling/last weapon, kill, wave, player list and gated cheat commands |
| P0 | Product startup | running the executable without CLI arguments prints usage and exits; `--play ROOT MAP` creates the session before showing the main menu | persistent application startup, data-directory selection/discovery, menu-before-map lifecycle and clean connect/disconnect transitions |
| P0 | Multiplayer UI | the Multiplayer page contains disabled labels and an explicit parity placeholder; Player Setup exposes handedness only | Join Server, Start Server, address book/server discovery, deathmatch options, downloads, player name/model/skin selection and preview |
| P1 | Client downloads | Protocol-34 chunks are validated and accumulated in memory, but the retail product does not request missing precache assets, install them safely or retry registration | original staged map/model/sound/image/player download workflow with policy toggles and traversal-safe persistence |
| P1 | Server administration | `null_game.ServerCommand` logs that the admin set is pending; RCON and master-server calls are not connected to product sessions | `sv test/addip/removeip/listip/writeip`, connect filtering, RCON execution and configured master heartbeat/shutdown lifecycle |
| P1 | Music | `CS_CDTRACK` exists but no gameplay music/CD-track backend consumes it | level/intermission track playback and stop/resume lifecycle; a modern legal-file backend can be additive but must preserve track semantics |
| P1 | Single-player pause | opening the gameplay menu does not pause the authoritative listen server | original single-player pause semantics while menus/console remain responsive |
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

1. Port the Game API client-command surface and preserve command text through
   `argc/argv/args`, with two-client UDP tests for every command family.
2. Introduce the persistent menu-first application lifecycle and complete the
   Join/Start/Player Setup pages.
3. Connect precache downloads, safe client persistence, server administration,
   filtering, RCON and master discovery.
4. Add level music and correct single-player pause behavior.
5. Close demo recording, screenshots, gamma/controller and save-import policy.
6. Run the external-process, full-campaign, visual and hardware evidence gates.

Every functional block must retain the full MiniLang build, asset-free suite,
relevant retail smoke and source-integrity manifest before it is marked closed.
