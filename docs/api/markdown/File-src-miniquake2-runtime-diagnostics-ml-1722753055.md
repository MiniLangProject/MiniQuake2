# `src/miniquake2/runtime/diagnostics.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 runtime diagnostics facilities for this project.

Package: [`miniquake2.runtime.diagnostics`](Package-miniquake2-runtime-diagnostics-43037751.md)

Reachable from entry: **yes**

## Imports

- `miniquake2/audio/device.ml` as `daudio` → [src/miniquake2/audio/device.ml](File-src-miniquake2-audio-device-ml-656133731.md)
- `miniquake2/audio/mixer.ml` as `dmixer` → [src/miniquake2/audio/mixer.ml](File-src-miniquake2-audio-mixer-ml-976475642.md)
- `miniquake2/audio/wav.ml` as `dwav` → [src/miniquake2/audio/wav.ml](File-src-miniquake2-audio-wav-ml-415505115.md)
- `miniquake2/client/cinematic/audio.ml` as `dcinaudio` → [src/miniquake2/client/cinematic/audio.ml](File-src-miniquake2-client-cinematic-audio-ml-1884837356.md)
- `miniquake2/client/cinematic/player.ml` as `dcinplayer` → [src/miniquake2/client/cinematic/player.ml](File-src-miniquake2-client-cinematic-player-ml-1099240939.md)
- `miniquake2/client/demo.ml` as `dclientdemo` → [src/miniquake2/client/demo.ml](File-src-miniquake2-client-demo-ml-1496242839.md)
- `miniquake2/client/effects/parser.ml` as `deffectparser` → [src/miniquake2/client/effects/parser.ml](File-src-miniquake2-client-effects-parser-ml-212038918.md)
- `miniquake2/client/effects/state.ml` as `deffectstate` → [src/miniquake2/client/effects/state.ml](File-src-miniquake2-client-effects-state-ml-140719308.md)
- `miniquake2/client/layout.ml` as `dclientlayout` → [src/miniquake2/client/layout.ml](File-src-miniquake2-client-layout-ml-1290796160.md)
- `miniquake2/client/state.ml` as `dclientstate` → [src/miniquake2/client/state.ml](File-src-miniquake2-client-state-ml-1458406995.md)
- `miniquake2/client/ui/input.ml` as `duiinput` → [src/miniquake2/client/ui/input.ml](File-src-miniquake2-client-ui-input-ml-1778495101.md)
- `miniquake2/client/ui/keys.ml` as `duikeys` → [src/miniquake2/client/ui/keys.ml](File-src-miniquake2-client-ui-keys-ml-2076131853.md)
- `miniquake2/client/ui/screen.ml` as `duiscreen` → [src/miniquake2/client/ui/screen.ml](File-src-miniquake2-client-ui-screen-ml-458862381.md)
- `miniquake2/collision/model.ml` as `dcollision` → [src/miniquake2/collision/model.ml](File-src-miniquake2-collision-model-ml-265039588.md)
- `miniquake2/format/bsp.ml` as `dbsp` → [src/miniquake2/format/bsp.ml](File-src-miniquake2-format-bsp-ml-2080213539.md)
- `miniquake2/format/cinematic.ml` as `dcin` → [src/miniquake2/format/cinematic.ml](File-src-miniquake2-format-cinematic-ml-1332230191.md)
- `miniquake2/format/md2.ml` as `dmd2` → [src/miniquake2/format/md2.ml](File-src-miniquake2-format-md2-ml-1028614507.md)
- `miniquake2/game/ai/archetypes.ml` as `darchetypes` → [src/miniquake2/game/ai/archetypes.ml](File-src-miniquake2-game-ai-archetypes-ml-722294566.md)
- `miniquake2/game/base/spawn.ml` as `dbasespawn` → [src/miniquake2/game/base/spawn.ml](File-src-miniquake2-game-base-spawn-ml-685876900.md)
- `miniquake2/game/gameplay/registry.ml` as `ditemregistry` → [src/miniquake2/game/gameplay/registry.ml](File-src-miniquake2-game-gameplay-registry-ml-1541508425.md)
- `miniquake2/game/integration/baseq2.ml` as `dbaseintegration` → [src/miniquake2/game/integration/baseq2.ml](File-src-miniquake2-game-integration-baseq2-ml-2026578472.md)
- `miniquake2/game/null_game.ml` as `dgame` → [src/miniquake2/game/null_game.ml](File-src-miniquake2-game-null-game-ml-1916269379.md)
- `miniquake2/game/persistence.ml` as `dpersistence` → [src/miniquake2/game/persistence.ml](File-src-miniquake2-game-persistence-ml-545577318.md)
- `miniquake2/game/player/frame.ml` as `dplayerframe` → [src/miniquake2/game/player/frame.ml](File-src-miniquake2-game-player-frame-ml-2050622310.md)
- `miniquake2/game/weapons/core.ml` as `dweaponcore` → [src/miniquake2/game/weapons/core.ml](File-src-miniquake2-game-weapons-core-ml-1168965024.md)
- `miniquake2/game/weapons/hitscan.ml` as `dweaponhitscan` → [src/miniquake2/game/weapons/hitscan.ml](File-src-miniquake2-game-weapons-hitscan-ml-359162381.md)
- `miniquake2/game/weapons/projectiles.ml` as `dweaponprojectiles` → [src/miniquake2/game/weapons/projectiles.ml](File-src-miniquake2-game-weapons-projectiles-ml-2146249801.md)
- `miniquake2/game/world/movers.ml` as `dmovers` → [src/miniquake2/game/world/movers.ml](File-src-miniquake2-game-world-movers-ml-1599163262.md)
- `miniquake2/network/client.ml` as `dnetclient` → [src/miniquake2/network/client.ml](File-src-miniquake2-network-client-ml-1115555876.md)
- `miniquake2/network/runtime/pump.ml` as `dnetpump` → [src/miniquake2/network/runtime/pump.ml](File-src-miniquake2-network-runtime-pump-ml-890925024.md)
- `miniquake2/network/server.ml` as `dnetserver` → [src/miniquake2/network/server.ml](File-src-miniquake2-network-server-ml-562940856.md)
- `miniquake2/physics/pmove.ml` as `dpmove` → [src/miniquake2/physics/pmove.ml](File-src-miniquake2-physics-pmove-ml-117812115.md)
- `miniquake2/platform/system.ml` as `dsystem` → [src/miniquake2/platform/system.ml](File-src-miniquake2-platform-system-ml-74223645.md)
- `miniquake2/platform/udp.ml` as `dudp` → [src/miniquake2/platform/udp.ml](File-src-miniquake2-platform-udp-ml-357648233.md)
- `miniquake2/platform/window.ml` as `dwindow` → [src/miniquake2/platform/window.ml](File-src-miniquake2-platform-window-ml-103958158.md)
- `miniquake2/protocol/entity_delta.ml` as `dentitydelta` → [src/miniquake2/protocol/entity_delta.ml](File-src-miniquake2-protocol-entity-delta-ml-602212639.md)
- `miniquake2/protocol/netchan.ml` as `dnetchan` → [src/miniquake2/protocol/netchan.ml](File-src-miniquake2-protocol-netchan-ml-626556964.md)
- `miniquake2/protocol/player_delta.ml` as `dplayerdelta` → [src/miniquake2/protocol/player_delta.ml](File-src-miniquake2-protocol-player-delta-ml-1460497029.md)
- `miniquake2/qcommon/checksum.ml` as `dchecksum` → [src/miniquake2/qcommon/checksum.ml](File-src-miniquake2-qcommon-checksum-ml-2099292824.md)
- `miniquake2/qcommon/cmd.ml` as `dcmd` → [src/miniquake2/qcommon/cmd.ml](File-src-miniquake2-qcommon-cmd-ml-1514462021.md)
- `miniquake2/qcommon/directions.ml` as `ddirections` → [src/miniquake2/qcommon/directions.ml](File-src-miniquake2-qcommon-directions-ml-1980852047.md)
- `miniquake2/qcommon/filesystem.ml` as `dfs` → [src/miniquake2/qcommon/filesystem.ml](File-src-miniquake2-qcommon-filesystem-ml-828451784.md)
- `miniquake2/renderer/assets.ml` as `dassets` → [src/miniquake2/renderer/assets.ml](File-src-miniquake2-renderer-assets-ml-650889185.md)
- `miniquake2/renderer/classic/materials.ml` as `dclassicmaterials` → [src/miniquake2/renderer/classic/materials.ml](File-src-miniquake2-renderer-classic-materials-ml-232284255.md)
- `miniquake2/renderer/classic/scene.ml` as `dclassicscene` → [src/miniquake2/renderer/classic/scene.ml](File-src-miniquake2-renderer-classic-scene-ml-949361389.md)
- `miniquake2/renderer/opengl.ml` as `dopengl` → [src/miniquake2/renderer/opengl.ml](File-src-miniquake2-renderer-opengl-ml-1095768987.md)
- `miniquake2/runtime/client_session.ml` as `dclientsession` → [src/miniquake2/runtime/client_session.ml](File-src-miniquake2-runtime-client-session-ml-1072602311.md)
- `miniquake2/runtime/server_session.ml` as `dserversession` → [src/miniquake2/runtime/server_session.ml](File-src-miniquake2-runtime-server-session-ml-1518722291.md)
- `miniquake2/server/game_bridge.ml` as `dgamebridge` → [src/miniquake2/server/game_bridge.ml](File-src-miniquake2-server-game-bridge-ml-73559214.md)
- `miniquake2/server/snapshot.ml` as `dsnapshot` → [src/miniquake2/server/snapshot.ml](File-src-miniquake2-server-snapshot-ml-949938726.md)

## Declarations

<a id="function-function-miniquake2-runtime-diagnostics-capabilitylines-function-capabilitylines-src-miniquake2-runtime-diagnostics-ml-1529172498"></a>
### capabilityLines

```ml
function capabilityLines()
```

Return the capability lines value.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/diagnostics.ml#L62)

<a id="function-function-miniquake2-runtime-diagnostics-verifylinkclosure-function-verifylinkclosure-src-miniquake2-runtime-diagnostics-ml-1821430412"></a>
### verifyLinkClosure

```ml
function verifyLinkClosure()
```

Verify link closure.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/diagnostics.ml#L105)
