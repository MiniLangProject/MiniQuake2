# `src/miniquake2/runtime/application.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 runtime application facilities for this project.

Package: [`miniquake2.runtime.application`](Package-miniquake2-runtime-application-846056837.md)

Reachable from entry: **yes**

## Imports

- `miniquake2/audio/device.ml` as `appaudiodevice` → [src/miniquake2/audio/device.ml](File-src-miniquake2-audio-device-ml-656133731.md)
- `miniquake2/audio/mixer.ml` as `appaudiomixer` → [src/miniquake2/audio/mixer.ml](File-src-miniquake2-audio-mixer-ml-976475642.md)
- `miniquake2/audio/wav.ml` as `appwav` → [src/miniquake2/audio/wav.ml](File-src-miniquake2-audio-wav-ml-415505115.md)
- `miniquake2/client/assets/registry.ml` as `appassetregistry` → [src/miniquake2/client/assets/registry.ml](File-src-miniquake2-client-assets-registry-ml-757705703.md)
- `miniquake2/client/cinematic/audio.ml` as `appcinaudio` → [src/miniquake2/client/cinematic/audio.ml](File-src-miniquake2-client-cinematic-audio-ml-1884837356.md)
- `miniquake2/client/cinematic/picture.ml` as `appcinpicture` → [src/miniquake2/client/cinematic/picture.ml](File-src-miniquake2-client-cinematic-picture-ml-296074172.md)
- `miniquake2/client/cinematic/player.ml` as `appcinplayer` → [src/miniquake2/client/cinematic/player.ml](File-src-miniquake2-client-cinematic-player-ml-1099240939.md)
- `miniquake2/client/demo_recording.ml` as `appdemorecording` → [src/miniquake2/client/demo_recording.ml](File-src-miniquake2-client-demo-recording-ml-612734795.md)
- `miniquake2/client/downloads.ml` as `appdownloads` → [src/miniquake2/client/downloads.ml](File-src-miniquake2-client-downloads-ml-2137413515.md)
- `miniquake2/client/effects/constants.ml` as `appeffectconstants` → [src/miniquake2/client/effects/constants.ml](File-src-miniquake2-client-effects-constants-ml-55259948.md)
- `miniquake2/client/effects/entity.ml` as `appentityeffects` → [src/miniquake2/client/effects/entity.ml](File-src-miniquake2-client-effects-entity-ml-1732564210.md)
- `miniquake2/client/effects/handoff.ml` as `appeffecthandoff` → [src/miniquake2/client/effects/handoff.ml](File-src-miniquake2-client-effects-handoff-ml-1195849101.md)
- `miniquake2/client/effects/state.ml` as `appeffectstate` → [src/miniquake2/client/effects/state.ml](File-src-miniquake2-client-effects-state-ml-140719308.md)
- `miniquake2/client/prediction.ml` as `appprediction` → [src/miniquake2/client/prediction.ml](File-src-miniquake2-client-prediction-ml-2147101369.md)
- `miniquake2/client/runtime/dispatcher.ml` as `appruntimedispatcher` → [src/miniquake2/client/runtime/dispatcher.ml](File-src-miniquake2-client-runtime-dispatcher-ml-506346494.md)
- `miniquake2/client/runtime/handoff.ml` as `appruntimehandoff` → [src/miniquake2/client/runtime/handoff.ml](File-src-miniquake2-client-runtime-handoff-ml-1879961007.md)
- `miniquake2/client/screenshot.ml` as `appscreenshot` → [src/miniquake2/client/screenshot.ml](File-src-miniquake2-client-screenshot-ml-2065936718.md)
- `miniquake2/client/state.ml` as `appclientstate` → [src/miniquake2/client/state.ml](File-src-miniquake2-client-state-ml-1458406995.md)
- `miniquake2/client/ui/commands.ml` as `appuicommands` → [src/miniquake2/client/ui/commands.ml](File-src-miniquake2-client-ui-commands-ml-90449559.md)
- `miniquake2/client/ui/config.ml` as `appuiconfig` → [src/miniquake2/client/ui/config.ml](File-src-miniquake2-client-ui-config-ml-341139691.md)
- `miniquake2/client/ui/console.ml` as `appuiconsole` → [src/miniquake2/client/ui/console.ml](File-src-miniquake2-client-ui-console-ml-367794066.md)
- `miniquake2/client/ui/constants.ml` as `appuiconstants` → [src/miniquake2/client/ui/constants.ml](File-src-miniquake2-client-ui-constants-ml-1004124106.md)
- `miniquake2/client/ui/controller.ml` as `appuicontroller` → [src/miniquake2/client/ui/controller.ml](File-src-miniquake2-client-ui-controller-ml-947969577.md)
- `miniquake2/client/ui/input.ml` as `appuiinput` → [src/miniquake2/client/ui/input.ml](File-src-miniquake2-client-ui-input-ml-1778495101.md)
- `miniquake2/client/ui/keys.ml` as `appuikeys` → [src/miniquake2/client/ui/keys.ml](File-src-miniquake2-client-ui-keys-ml-2076131853.md)
- `miniquake2/client/ui/menu.ml` as `appuimenu` → [src/miniquake2/client/ui/menu.ml](File-src-miniquake2-client-ui-menu-ml-1156054796.md)
- `miniquake2/client/ui/screen.ml` as `appuiscreen` → [src/miniquake2/client/ui/screen.ml](File-src-miniquake2-client-ui-screen-ml-458862381.md)
- `miniquake2/collision/model.ml` as `appcollision` → [src/miniquake2/collision/model.ml](File-src-miniquake2-collision-model-ml-265039588.md)
- `miniquake2/format/bsp.ml` as `appbsp` → [src/miniquake2/format/bsp.ml](File-src-miniquake2-format-bsp-ml-2080213539.md)
- `miniquake2/format/cinematic.ml` as `appcinformat` → [src/miniquake2/format/cinematic.ml](File-src-miniquake2-format-cinematic-ml-1332230191.md)
- `miniquake2/format/md2.ml` as `appmd2` → [src/miniquake2/format/md2.ml](File-src-miniquake2-format-md2-ml-1028614507.md)
- `miniquake2/game/base/spawn.ml` as `appspawn` → [src/miniquake2/game/base/spawn.ml](File-src-miniquake2-game-base-spawn-ml-685876900.md)
- `miniquake2/game/constants.ml` as `appgameconstants` → [src/miniquake2/game/constants.ml](File-src-miniquake2-game-constants-ml-1723282332.md)
- `miniquake2/game/gameplay/constants.ml` as `appgameplayconstants` → [src/miniquake2/game/gameplay/constants.ml](File-src-miniquake2-game-gameplay-constants-ml-1803115501.md)
- `miniquake2/game/gameplay/item_rules.ml` as `appgameplayitems` → [src/miniquake2/game/gameplay/item_rules.ml](File-src-miniquake2-game-gameplay-item-rules-ml-1747940557.md)
- `miniquake2/game/gameplay/registry.ml` as `appgameplayregistry` → [src/miniquake2/game/gameplay/registry.ml](File-src-miniquake2-game-gameplay-registry-ml-1541508425.md)
- `miniquake2/game/integration/baseq2.ml` as `appbaseq2` → [src/miniquake2/game/integration/baseq2.ml](File-src-miniquake2-game-integration-baseq2-ml-2026578472.md)
- `miniquake2/game/integration/campaign_progression.ml` as `appcampaignprogression` → [src/miniquake2/game/integration/campaign_progression.ml](File-src-miniquake2-game-integration-campaign-progression-ml-462910148.md)
- `miniquake2/game/null_game.ml` as `appgame` → [src/miniquake2/game/null_game.ml](File-src-miniquake2-game-null-game-ml-1916269379.md)
- `miniquake2/game/player/transition.ml` as `appplayertransition` → [src/miniquake2/game/player/transition.ml](File-src-miniquake2-game-player-transition-ml-1211895412.md)
- `miniquake2/game/world/constants.ml` as `appworldconstants` → [src/miniquake2/game/world/constants.ml](File-src-miniquake2-game-world-constants-ml-774918061.md)
- `miniquake2/native.ml` as `appnative` → [src/miniquake2/native.ml](File-src-miniquake2-native-ml-139597585.md)
- `miniquake2/network/client.ml` as `appnetworkclient` → [src/miniquake2/network/client.ml](File-src-miniquake2-network-client-ml-1115555876.md)
- `miniquake2/network/runtime/commands.ml` as `appservercommands` → [src/miniquake2/network/runtime/commands.ml](File-src-miniquake2-network-runtime-commands-ml-1067337840.md)
- `miniquake2/network/runtime/transport.ml` as `appnetworktransport` → [src/miniquake2/network/runtime/transport.ml](File-src-miniquake2-network-runtime-transport-ml-1946942007.md)
- `miniquake2/physics/vector.ml` as `appphysicsvector` → [src/miniquake2/physics/vector.ml](File-src-miniquake2-physics-vector-ml-1287862571.md)
- `miniquake2/platform/dedicated_console.ml` as `appdedicatedconsole` → [src/miniquake2/platform/dedicated_console.ml](File-src-miniquake2-platform-dedicated-console-ml-1193017693.md)
- `miniquake2/platform/system.ml` as `appsystem` → [src/miniquake2/platform/system.ml](File-src-miniquake2-platform-system-ml-74223645.md)
- `miniquake2/platform/udp.ml` as `appudp` → [src/miniquake2/platform/udp.ml](File-src-miniquake2-platform-udp-ml-357648233.md)
- `miniquake2/platform/window.ml` as `appwindow` → [src/miniquake2/platform/window.ml](File-src-miniquake2-platform-window-ml-103958158.md)
- `miniquake2/qcommon/byteio.ml` as `appbyteio` → [src/miniquake2/qcommon/byteio.ml](File-src-miniquake2-qcommon-byteio-ml-159119335.md)
- `miniquake2/qcommon/cmd.ml` as `appqcmd` → [src/miniquake2/qcommon/cmd.ml](File-src-miniquake2-qcommon-cmd-ml-1514462021.md)
- `miniquake2/qcommon/constants.ml` as `appqconstants` → [src/miniquake2/qcommon/constants.ml](File-src-miniquake2-qcommon-constants-ml-1976195726.md)
- `miniquake2/qcommon/filesystem.ml` as `appfs` → [src/miniquake2/qcommon/filesystem.ml](File-src-miniquake2-qcommon-filesystem-ml-828451784.md)
- `miniquake2/qcommon/info.ml` as `appinfo` → [src/miniquake2/qcommon/info.ml](File-src-miniquake2-qcommon-info-ml-634538165.md)
- `miniquake2/qcommon/text.ml` as `apptext` → [src/miniquake2/qcommon/text.ml](File-src-miniquake2-qcommon-text-ml-1570504148.md)
- `miniquake2/qcommon/types.ml` as `appqtypes` → [src/miniquake2/qcommon/types.ml](File-src-miniquake2-qcommon-types-ml-1663266398.md)
- `miniquake2/renderer/capture.ml` as `appcapture` → [src/miniquake2/renderer/capture.ml](File-src-miniquake2-renderer-capture-ml-993518394.md)
- `miniquake2/renderer/opengl.ml` as `appgl` → [src/miniquake2/renderer/opengl.ml](File-src-miniquake2-renderer-opengl-ml-1095768987.md)
- `miniquake2/renderer/types.ml` as `apprtypes` → [src/miniquake2/renderer/types.ml](File-src-miniquake2-renderer-types-ml-975707623.md)
- `miniquake2/runtime/campaign_playtest.ml` as `appcampaignplaytest` → [src/miniquake2/runtime/campaign_playtest.ml](File-src-miniquake2-runtime-campaign-playtest-ml-1449829904.md)
- `miniquake2/runtime/client_assets.ml` as `appclientassets` → [src/miniquake2/runtime/client_assets.ml](File-src-miniquake2-runtime-client-assets-ml-1179913804.md)
- `miniquake2/runtime/client_session.ml` as `appclientsession` → [src/miniquake2/runtime/client_session.ml](File-src-miniquake2-runtime-client-session-ml-1072602311.md)
- `miniquake2/runtime/demo_session.ml` as `appdemosession` → [src/miniquake2/runtime/demo_session.ml](File-src-miniquake2-runtime-demo-session-ml-471534783.md)
- `miniquake2/runtime/media_sequence.ml` as `appmediaseq` → [src/miniquake2/runtime/media_sequence.ml](File-src-miniquake2-runtime-media-sequence-ml-1280544663.md)
- `miniquake2/runtime/pause_policy.ml` as `apppause` → [src/miniquake2/runtime/pause_policy.ml](File-src-miniquake2-runtime-pause-policy-ml-1558277676.md)
- `miniquake2/runtime/play_session.ml` as `appplay` → [src/miniquake2/runtime/play_session.ml](File-src-miniquake2-runtime-play-session-ml-1798366100.md)
- `miniquake2/runtime/preview_camera.ml` as `appcamera` → [src/miniquake2/runtime/preview_camera.ml](File-src-miniquake2-runtime-preview-camera-ml-231166813.md)
- `miniquake2/runtime/product_host.ml` as `appproducthost` → [src/miniquake2/runtime/product_host.ml](File-src-miniquake2-runtime-product-host-ml-2075620437.md)
- `miniquake2/runtime/product_startup.ml` as `appstartup` → [src/miniquake2/runtime/product_startup.ml](File-src-miniquake2-runtime-product-startup-ml-320456564.md)
- `miniquake2/runtime/save_metadata.ml` as `appsavemetadata` → [src/miniquake2/runtime/save_metadata.ml](File-src-miniquake2-runtime-save-metadata-ml-601566230.md)
- `miniquake2/runtime/server_session.ml` as `appsession` → [src/miniquake2/runtime/server_session.ml](File-src-miniquake2-runtime-server-session-ml-1518722291.md)
- `miniquake2/runtime/session_persistence.ml` as `apppersistence` → [src/miniquake2/runtime/session_persistence.ml](File-src-miniquake2-runtime-session-persistence-ml-1812463983.md)
- `miniquake2/server/game_bridge.ml` as `appbridge` → [src/miniquake2/server/game_bridge.ml](File-src-miniquake2-server-game-bridge-ml-73559214.md)
- `std/fs.ml` as `appnativefs` → `../MiniLangCompilerML/std/fs.ml` — external dependency
- `std/process.ml` as `appprocess` → `../MiniLangCompilerML/std/process.ml` — external dependency

## Declarations

<a id="constant-constant-miniquake2-runtime-application-application-sound-cache-capacity-const-application-sound-cache-capacity-512-src-miniquake2-runtime-application-ml-1138268663"></a>
### APPLICATION_SOUND_CACHE_CAPACITY

```ml
const APPLICATION_SOUND_CACHE_CAPACITY = 512
```

Defines the application sound cache capacity constant used by the miniquake2 runtime application module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/application.ml#L193)

<a id="function-function-miniquake2-runtime-application-applicationaudiorefillbudget-inline-function-applicationaudiorefillbudget-queuedblocks-src-miniquake2-runtime-application-ml-1394105588"></a>
### applicationAudioRefillBudget

```ml
inline function applicationAudioRefillBudget(queuedBlocks)
```

Pump play audio.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `queuedBlocks` | `dynamic` | — | queuedBlocks value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/application.ml#L741)

<a id="global-global-miniquake2-runtime-application-applicationautomatedchangelevel-applicationautomatedchangelevel-src-miniquake2-runtime-application-ml-1340326992"></a>
### applicationAutomatedChangeLevel

```ml
applicationAutomatedChangeLevel
```

Stores module-wide application automated change level state for the miniquake2 runtime application module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/application.ml#L226)

<a id="global-global-miniquake2-runtime-application-applicationautomatedchangelevelreached-applicationautomatedchangelevelreached-src-miniquake2-runtime-application-ml-2092358692"></a>
### applicationAutomatedChangeLevelReached

```ml
applicationAutomatedChangeLevelReached
```

Stores module-wide application automated change level reached state for the miniquake2 runtime application module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/application.ml#L230)

<a id="global-global-miniquake2-runtime-application-applicationautomatedchangeleveltarget-applicationautomatedchangeleveltarget-src-miniquake2-runtime-application-ml-1303219972"></a>
### applicationAutomatedChangeLevelTarget

```ml
applicationAutomatedChangeLevelTarget
```

Stores module-wide application automated change level target state for the miniquake2 runtime application module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/application.ml#L232)

<a id="global-global-miniquake2-runtime-application-applicationautomatedchangeleveltriggered-applicationautomatedchangeleveltriggered-src-miniquake2-runtime-application-ml-931186386"></a>
### applicationAutomatedChangeLevelTriggered

```ml
applicationAutomatedChangeLevelTriggered
```

Stores module-wide application automated change level triggered state for the miniquake2 runtime application module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/application.ml#L228)

<a id="global-global-miniquake2-runtime-application-applicationautomatedprojectileattack-applicationautomatedprojectileattack-src-miniquake2-runtime-application-ml-236596510"></a>
### applicationAutomatedProjectileAttack

```ml
applicationAutomatedProjectileAttack
```

Stores module-wide application automated projectile attack state for the miniquake2 runtime application module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/application.ml#L222)

<a id="global-global-miniquake2-runtime-application-applicationautomatedweaponwheel-applicationautomatedweaponwheel-src-miniquake2-runtime-application-ml-1796431656"></a>
### applicationAutomatedWeaponWheel

```ml
applicationAutomatedWeaponWheel
```

Stores module-wide application automated weapon wheel state for the miniquake2 runtime application module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/application.ml#L224)

<a id="global-global-miniquake2-runtime-application-applicationfrozenpresentationframe-applicationfrozenpresentationframe-src-miniquake2-runtime-application-ml-48419914"></a>
### applicationFrozenPresentationFrame

```ml
applicationFrozenPresentationFrame
```

Stores module-wide application frozen presentation frame state for the miniquake2 runtime application module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/application.ml#L287)

<a id="global-global-miniquake2-runtime-application-applicationgamemapautosaverequested-applicationgamemapautosaverequested-src-miniquake2-runtime-application-ml-999363580"></a>
### applicationGamemapAutosaveRequested

```ml
applicationGamemapAutosaveRequested
```

Stores module-wide application gamemap autosave requested state for the miniquake2 runtime application module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/application.ml#L270)

<a id="global-global-miniquake2-runtime-application-applicationgamemapendofunit-applicationgamemapendofunit-src-miniquake2-runtime-application-ml-420366864"></a>
### applicationGamemapEndOfUnit

```ml
applicationGamemapEndOfUnit
```

Stores module-wide application gamemap end of unit state for the miniquake2 runtime application module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/application.ml#L272)

<a id="global-global-miniquake2-runtime-application-applicationgroundpushercache-applicationgroundpushercache-src-miniquake2-runtime-application-ml-986744872"></a>
### applicationGroundPusherCache

```ml
applicationGroundPusherCache
```

Stores module-wide application ground pusher cache state for the miniquake2 runtime application module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/application.ml#L276)

- [miniquake2.runtime.application.ApplicationGroundPusherCache](Type-miniquake2-runtime-application-applicationgroundpushercache-777556525.md) — struct
<a id="global-global-miniquake2-runtime-application-applicationlevelcapturechecksum-applicationlevelcapturechecksum-src-miniquake2-runtime-application-ml-1100610848"></a>
### applicationLevelCaptureChecksum

```ml
applicationLevelCaptureChecksum
```

Stores module-wide application level capture checksum state for the miniquake2 runtime application module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/application.ml#L264)

<a id="global-global-miniquake2-runtime-application-applicationlevelcaptureerror-applicationlevelcaptureerror-src-miniquake2-runtime-application-ml-1896991708"></a>
### applicationLevelCaptureError

```ml
applicationLevelCaptureError
```

Stores module-wide application level capture error state for the miniquake2 runtime application module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/application.ml#L266)

<a id="global-global-miniquake2-runtime-application-applicationlevelcapturepath-applicationlevelcapturepath-src-miniquake2-runtime-application-ml-873131704"></a>
### applicationLevelCapturePath

```ml
applicationLevelCapturePath
```

Stores module-wide application level capture path state for the miniquake2 runtime application module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/application.ml#L262)

<a id="function-function-miniquake2-runtime-application-applicationlocalpusher-function-applicationlocalpusher-session-src-miniquake2-runtime-application-ml-501494406"></a>
### applicationLocalPusher

```ml
function applicationLocalPusher(session)
```

Return the managed pusher currently supporting the local player. The game keeps the ground contact as an Edict, whereas renderer interpolation needs the corresponding WorldEntity. Cache this identity-paired lookup because ordinary presentation frames commonly revisit the same floor or lift.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `session` | `dynamic` | — | session value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/application.ml#L413)

<a id="function-function-miniquake2-runtime-application-applicationlocalpusheroffset-function-applicationlocalpusheroffset-session-fraction-src-miniquake2-runtime-application-ml-1112402212"></a>
### applicationLocalPusherOffset

```ml
function applicationLocalPusherOffset(session, fraction)
```

Return the residual interpolation offset for a locally ridden MOVETYPE_PUSH/STOP brush. Translation is already covered by the stock prediction-error path; rotating pushers still need their nonlinear arc.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `session` | `dynamic` | — | session value consumed by this operation. |
| `fraction` | `dynamic` | — | fraction value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/application.ml#L460)

<a id="function-function-miniquake2-runtime-application-applicationlocalpusherrider-function-applicationlocalpusherrider-session-src-miniquake2-runtime-application-ml-914765354"></a>
### applicationLocalPusherRider

```ml
function applicationLocalPusherRider(session)
```

Return whether local prediction is currently riding a moving brush. This feeds the client stair smoother before prediction replays the usercmd ring.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `session` | `dynamic` | — | session value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/application.ml#L447)

<a id="global-global-miniquake2-runtime-application-applicationmediacooperative-applicationmediacooperative-src-miniquake2-runtime-application-ml-1436944492"></a>
### applicationMediaCooperative

```ml
applicationMediaCooperative
```

Stores module-wide application media cooperative state for the miniquake2 runtime application module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/application.ml#L274)

<a id="function-function-miniquake2-runtime-application-applicationpaceframe-function-applicationpaceframe-clock-deadline-maxfps-src-miniquake2-runtime-application-ml-499447115"></a>
### applicationPaceFrame

```ml
function applicationPaceFrame(clock, deadline, maxFps)
```

Wait until the next presentation deadline and return the following one. Quake II's cl_maxfps gate is independent of the renderer swap interval: a blocking swap can satisfy the deadline, while windowed drivers that ignore WGL_EXT_swap_control still receive stable high-resolution pacing here.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `clock` | `dynamic` | — | clock value consumed by this operation. |
| `deadline` | `dynamic` | — | deadline value consumed by this operation. |
| `maxFps` | `dynamic` | — | maxFps value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/application.ml#L484)

<a id="global-global-miniquake2-runtime-application-applicationpersistproductconfig-applicationpersistproductconfig-src-miniquake2-runtime-application-ml-1545605448"></a>
### applicationPersistProductConfig

```ml
applicationPersistProductConfig
```

Stores module-wide application persist product config state for the miniquake2 runtime application module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/application.ml#L268)

<a id="function-function-miniquake2-runtime-application-applicationpresentationfraction-function-applicationpresentationfraction-now-snapshottime-src-miniquake2-runtime-application-ml-693625205"></a>
### applicationPresentationFraction

```ml
function applicationPresentationFraction(now, snapshotTime)
```

Derive the renderer interpolation phase from when a new authoritative snapshot actually arrived, rather than from the independent usercmd clock. If a packet is late, holding at one is stable; restarting at zero would replay the old 100-ms interval and make the view visibly jump backward.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `now` | `dynamic` | — | now value consumed by this operation. |
| `snapshotTime` | `dynamic` | — | snapshotTime value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/application.ml#L295)

<a id="global-global-miniquake2-runtime-application-applicationprojectileattackcommands-applicationprojectileattackcommands-src-miniquake2-runtime-application-ml-1469231536"></a>
### applicationProjectileAttackCommands

```ml
applicationProjectileAttackCommands
```

Stores module-wide application projectile attack commands state for the miniquake2 runtime application module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/application.ml#L252)

<a id="global-global-miniquake2-runtime-application-applicationprojectileexportmaximum-applicationprojectileexportmaximum-src-miniquake2-runtime-application-ml-431924878"></a>
### applicationProjectileExportMaximum

```ml
applicationProjectileExportMaximum
```

Stores module-wide application projectile export maximum state for the miniquake2 runtime application module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/application.ml#L254)

<a id="global-global-miniquake2-runtime-application-applicationprojectilelastenginenumber-applicationprojectilelastenginenumber-src-miniquake2-runtime-application-ml-1835912032"></a>
### applicationProjectileLastEngineNumber

```ml
applicationProjectileLastEngineNumber
```

Stores module-wide application projectile last engine number state for the miniquake2 runtime application module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/application.ml#L260)

<a id="global-global-miniquake2-runtime-application-applicationprojectileparticlemaximum-applicationprojectileparticlemaximum-src-miniquake2-runtime-application-ml-935903302"></a>
### applicationProjectileParticleMaximum

```ml
applicationProjectileParticleMaximum
```

Stores module-wide application projectile particle maximum state for the miniquake2 runtime application module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/application.ml#L246)

<a id="global-global-miniquake2-runtime-application-applicationprojectilerendermaximum-applicationprojectilerendermaximum-src-miniquake2-runtime-application-ml-881907970"></a>
### applicationProjectileRenderMaximum

```ml
applicationProjectileRenderMaximum
```

Stores module-wide application projectile render maximum state for the miniquake2 runtime application module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/application.ml#L244)

<a id="global-global-miniquake2-runtime-application-applicationprojectileservermaximum-applicationprojectileservermaximum-src-miniquake2-runtime-application-ml-1259478104"></a>
### applicationProjectileServerMaximum

```ml
applicationProjectileServerMaximum
```

Stores module-wide application projectile server maximum state for the miniquake2 runtime application module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/application.ml#L250)

<a id="global-global-miniquake2-runtime-application-applicationprojectilesnapshotmaximum-applicationprojectilesnapshotmaximum-src-miniquake2-runtime-application-ml-232027122"></a>
### applicationProjectileSnapshotMaximum

```ml
applicationProjectileSnapshotMaximum
```

Stores module-wide application projectile snapshot maximum state for the miniquake2 runtime application module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/application.ml#L242)

<a id="global-global-miniquake2-runtime-application-applicationprojectilevisibilitydiagnostic-applicationprojectilevisibilitydiagnostic-src-miniquake2-runtime-application-ml-1885381200"></a>
### applicationProjectileVisibilityDiagnostic

```ml
applicationProjectileVisibilityDiagnostic
```

Stores module-wide application projectile visibility diagnostic state for the miniquake2 runtime application module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/application.ml#L258)

<a id="global-global-miniquake2-runtime-application-applicationprojectilevisiblemaximum-applicationprojectilevisiblemaximum-src-miniquake2-runtime-application-ml-1185054312"></a>
### applicationProjectileVisibleMaximum

```ml
applicationProjectileVisibleMaximum
```

Stores module-wide application projectile visible maximum state for the miniquake2 runtime application module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/application.ml#L256)

<a id="global-global-miniquake2-runtime-application-applicationprojectileweaponsoundmaximum-applicationprojectileweaponsoundmaximum-src-miniquake2-runtime-application-ml-1004285664"></a>
### applicationProjectileWeaponSoundMaximum

```ml
applicationProjectileWeaponSoundMaximum
```

Stores module-wide application projectile weapon sound maximum state for the miniquake2 runtime application module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/application.ml#L248)

<a id="global-global-miniquake2-runtime-application-applicationpusheroffsetvalue-applicationpusheroffsetvalue-src-miniquake2-runtime-application-ml-2043093798"></a>
### applicationPusherOffsetValue

```ml
applicationPusherOffsetValue
```

Stores module-wide application pusher offset value state for the miniquake2 runtime application module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/application.ml#L283)

<a id="function-function-miniquake2-runtime-application-applicationpusherpredictionoffset-function-applicationpusherpredictionoffset-client-groundnumber-fraction-riderorigin-src-miniquake2-runtime-application-ml-1534635365"></a>
### applicationPusherPredictionOffset

```ml
function applicationPusherPredictionOffset(client, groundNumber, fraction, riderOrigin)
```

Return only the pusher correction not already supplied by Quake II's normal prediction-error interpolation. A carried player produces the complete endpoint displacement as a prediction error, so adding the raw snapshot offset again would ease the same 100-ms translation twice. The residual is zero for a translating lift and retains only the curved-path correction for a rotating pusher.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `client` | `dynamic` | — | client value consumed by this operation. |
| `groundNumber` | `dynamic` | — | groundNumber value consumed by this operation. |
| `fraction` | `dynamic` | — | fraction value consumed by this operation. |
| `riderOrigin` | `dynamic` | — | riderOrigin value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/application.ml#L375)

<a id="global-global-miniquake2-runtime-application-applicationpusherpredictionoffsetvalue-applicationpusherpredictionoffsetvalue-src-miniquake2-runtime-application-ml-640388876"></a>
### applicationPusherPredictionOffsetValue

```ml
applicationPusherPredictionOffsetValue
```

Stores module-wide application pusher prediction offset value state for the miniquake2 runtime application module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/application.ml#L285)

<a id="function-function-miniquake2-runtime-application-applicationpushersnapshotoffset-function-applicationpushersnapshotoffset-client-groundnumber-fraction-riderorigin-src-miniquake2-runtime-application-ml-802108515"></a>
### applicationPusherSnapshotOffset

```ml
function applicationPusherSnapshotOffset(client, groundNumber, fraction, riderOrigin)
```

Return the camera-space correction produced by rendering one ridden pusher between two adjacent snapshots.  Deriving the correction from the snapshot transforms keeps the rider and brush on the same clock even when Move_Done has already cleared the live gameplay velocity.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `client` | `dynamic` | — | client value consumed by this operation. |
| `groundNumber` | `dynamic` | — | groundNumber value consumed by this operation. |
| `fraction` | `dynamic` | — | fraction value consumed by this operation. |
| `riderOrigin` | `dynamic` | — | riderOrigin value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/application.ml#L322)

<a id="function-function-miniquake2-runtime-application-applicationregisterremoteworld-function-applicationregisterremoteworld-src-miniquake2-runtime-application-ml-2024061876"></a>
### applicationRegisterRemoteWorld

```ml
function applicationRegisterRemoteWorld()
```

Register application remote world.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/application.ml#L4444)

<a id="function-function-miniquake2-runtime-application-applicationremotefileexists-function-applicationremotefileexists-name-src-miniquake2-runtime-application-ml-1764008889"></a>
### applicationRemoteFileExists

```ml
function applicationRemoteFileExists(name)
```

Return the application remote file exists value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `name` | `dynamic` | — | Name of the affected item. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/application.ml#L663)

<a id="function-function-miniquake2-runtime-application-applicationremoteregisterdownload-function-applicationremoteregisterdownload-kind-name-src-miniquake2-runtime-application-ml-911268141"></a>
### applicationRemoteRegisterDownload

```ml
function applicationRemoteRegisterDownload(kind, name)
```

Register application remote download.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `kind` | `dynamic` | — | kind value consumed by this operation. |
| `name` | `dynamic` | — | Name of the affected item. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/application.ml#L672)

<a id="global-global-miniquake2-runtime-application-applicationremoteregistrationassets-applicationremoteregistrationassets-src-miniquake2-runtime-application-ml-846375792"></a>
### applicationRemoteRegistrationAssets

```ml
applicationRemoteRegistrationAssets
```

Stores module-wide application remote registration assets state for the miniquake2 runtime application module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/application.ml#L220)

<a id="global-global-miniquake2-runtime-application-applicationremoteregistrationcollision-applicationremoteregistrationcollision-src-miniquake2-runtime-application-ml-1722753382"></a>
### applicationRemoteRegistrationCollision

```ml
applicationRemoteRegistrationCollision
```

Stores module-wide application remote registration collision state for the miniquake2 runtime application module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/application.ml#L216)

<a id="global-global-miniquake2-runtime-application-applicationremoteregistrationfilesystem-applicationremoteregistrationfilesystem-src-miniquake2-runtime-application-ml-757782816"></a>
### applicationRemoteRegistrationFileSystem

```ml
applicationRemoteRegistrationFileSystem
```

Stores module-wide application remote registration file system state for the miniquake2 runtime application module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/application.ml#L208)

<a id="global-global-miniquake2-runtime-application-applicationremoteregistrationmap-applicationremoteregistrationmap-src-miniquake2-runtime-application-ml-427296866"></a>
### applicationRemoteRegistrationMap

```ml
applicationRemoteRegistrationMap
```

Stores module-wide application remote registration map state for the miniquake2 runtime application module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/application.ml#L214)

<a id="global-global-miniquake2-runtime-application-applicationremoteregistrationmappath-applicationremoteregistrationmappath-src-miniquake2-runtime-application-ml-328657192"></a>
### applicationRemoteRegistrationMapPath

```ml
applicationRemoteRegistrationMapPath
```

Stores module-wide application remote registration map path state for the miniquake2 runtime application module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/application.ml#L218)

<a id="global-global-miniquake2-runtime-application-applicationremoteregistrationrenderer-applicationremoteregistrationrenderer-src-miniquake2-runtime-application-ml-370225560"></a>
### applicationRemoteRegistrationRenderer

```ml
applicationRemoteRegistrationRenderer
```

Stores module-wide application remote registration renderer state for the miniquake2 runtime application module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/application.ml#L210)

<a id="global-global-miniquake2-runtime-application-applicationremoteregistrationsession-applicationremoteregistrationsession-src-miniquake2-runtime-application-ml-1865708154"></a>
### applicationRemoteRegistrationSession

```ml
applicationRemoteRegistrationSession
```

Stores module-wide application remote registration session state for the miniquake2 runtime application module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/application.ml#L206)

<a id="global-global-miniquake2-runtime-application-applicationremoteregistrationworld-applicationremoteregistrationworld-src-miniquake2-runtime-application-ml-153101870"></a>
### applicationRemoteRegistrationWorld

```ml
applicationRemoteRegistrationWorld
```

Stores module-wide application remote registration world state for the miniquake2 runtime application module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/application.ml#L212)

<a id="function-function-miniquake2-runtime-application-applicationrendererempty1-function-applicationrendererempty1-value-src-miniquake2-runtime-application-ml-1633867111"></a>
### applicationRendererEmpty1

```ml
function applicationRendererEmpty1(value)
```

Report whether application renderer empty 1.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/application.ml#L580)

<a id="function-function-miniquake2-runtime-application-applicationrendererimports-function-applicationrendererimports-src-miniquake2-runtime-application-ml-1053622396"></a>
### applicationRendererImports

```ml
function applicationRendererImports()
```

Return the application renderer imports value.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/application.ml#L599)

<a id="function-function-miniquake2-runtime-application-applicationrenderermode-function-applicationrenderermode-mode-src-miniquake2-runtime-application-ml-1480265077"></a>
### applicationRendererMode

```ml
function applicationRendererMode(mode)
```

Return the application renderer mode value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `mode` | `dynamic` | — | Mode selecting the requested behavior. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/application.ml#L594)

<a id="function-function-miniquake2-runtime-application-applicationrenderernoresult0-function-applicationrenderernoresult0-src-miniquake2-runtime-application-ml-2033333176"></a>
### applicationRendererNoResult0

```ml
function applicationRendererNoResult0()
```

Report whether application renderer no result 0.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/application.ml#L548)

<a id="function-function-miniquake2-runtime-application-applicationrenderernoresult1-function-applicationrenderernoresult1-value-src-miniquake2-runtime-application-ml-2049179861"></a>
### applicationRendererNoResult1

```ml
function applicationRendererNoResult1(value)
```

Report whether application renderer no result 1.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/application.ml#L554)

<a id="function-function-miniquake2-runtime-application-applicationrenderernoresult2-function-applicationrenderernoresult2-first-second-src-miniquake2-runtime-application-ml-1327101484"></a>
### applicationRendererNoResult2

```ml
function applicationRendererNoResult2(first, second)
```

Report whether application renderer no result 2.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `first` | `dynamic` | — | first value consumed by this operation. |
| `second` | `dynamic` | — | second value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/application.ml#L561)

<a id="function-function-miniquake2-runtime-application-applicationrenderernoresult3-function-applicationrenderernoresult3-first-second-third-src-miniquake2-runtime-application-ml-1773807009"></a>
### applicationRendererNoResult3

```ml
function applicationRendererNoResult3(first, second, third)
```

Report whether application renderer no result 3.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `first` | `dynamic` | — | first value consumed by this operation. |
| `second` | `dynamic` | — | second value consumed by this operation. |
| `third` | `dynamic` | — | third value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/application.ml#L569)

<a id="function-function-miniquake2-runtime-application-applicationrenderervoid3-function-applicationrenderervoid3-first-second-third-src-miniquake2-runtime-application-ml-672373361"></a>
### applicationRendererVoid3

```ml
function applicationRendererVoid3(first, second, third)
```

Return the application renderer void 3 value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `first` | `dynamic` | — | first value consumed by this operation. |
| `second` | `dynamic` | — | second value consumed by this operation. |
| `third` | `dynamic` | — | third value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/application.ml#L588)

<a id="function-function-miniquake2-runtime-application-applicationrendererzero0-function-applicationrendererzero0-src-miniquake2-runtime-application-ml-1581525676"></a>
### applicationRendererZero0

```ml
function applicationRendererZero0()
```

Return the application renderer zero 0 value.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/application.ml#L574)

<a id="function-function-miniquake2-runtime-application-applicationresolvepresentationframe-function-applicationresolvepresentationframe-frozen-cachedframe-newframe-src-miniquake2-runtime-application-ml-239693354"></a>
### applicationResolvePresentationFrame

```ml
function applicationResolvePresentationFrame(frozen, cachedFrame, newFrame)
```

Keep the last complete gameplay refdef while the local single-player console pauses simulation. The console is an overlay, so rebuilding a predicted refdef behind it can otherwise alternate between packet and local command clocks even though the visible game is meant to be stationary.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `frozen` | `dynamic` | — | frozen value consumed by this operation. |
| `cachedFrame` | `dynamic` | — | cachedFrame value consumed by this operation. |
| `newFrame` | `dynamic` | — | newFrame value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/application.ml#L309)

<a id="global-global-miniquake2-runtime-application-applicationresourcecache-applicationresourcecache-src-miniquake2-runtime-application-ml-1263073940"></a>
### applicationResourceCache

```ml
applicationResourceCache
```

Stores module-wide application resource cache state for the miniquake2 runtime application module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/application.ml#L279)

- [miniquake2.runtime.application.ApplicationResourceCache](Type-miniquake2-runtime-application-applicationresourcecache-1837086201.md) — struct
<a id="function-function-miniquake2-runtime-application-applicationsharedfilesystem-function-applicationsharedfilesystem-basedirectory-src-miniquake2-runtime-application-ml-66516762"></a>
### applicationSharedFileSystem

```ml
function applicationSharedFileSystem(baseDirectory)
```

Return the shared read-only filesystem for one retail data root.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `baseDirectory` | `dynamic` | — | baseDirectory value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/application.ml#L508)

<a id="function-function-miniquake2-runtime-application-applicationsubmitdemoframe-function-applicationsubmitdemoframe-renderer-world-frame-screen-now-window-stats-configstrings-src-miniquake2-runtime-application-ml-1345302975"></a>
### applicationSubmitDemoFrame

```ml
function applicationSubmitDemoFrame(renderer, world, frame, screen, now, window, stats, configStrings)
```

Submit application demo frame.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `renderer` | `dynamic` | — | renderer value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |
| `frame` | `dynamic` | — | frame value consumed by this operation. |
| `screen` | `dynamic` | — | screen value consumed by this operation. |
| `now` | `dynamic` | — | now value consumed by this operation. |
| `window` | `dynamic` | — | window value consumed by this operation. |
| `stats` | `dynamic` | — | stats value consumed by this operation. |
| `configStrings` | `dynamic` | — | configStrings value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/application.ml#L1260)

<a id="function-function-miniquake2-runtime-application-applicationsynchronizesoundcache-function-applicationsynchronizesoundcache-filesystem-src-miniquake2-runtime-application-ml-1815156249"></a>
### applicationSynchronizeSoundCache

```ml
function applicationSynchronizeSoundCache(filesystem)
```

Reset decoded sounds when a direct tool path selects a different data root.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `filesystem` | `dynamic` | — | filesystem value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/application.ml#L527)

<a id="global-global-miniquake2-runtime-application-applicationweaponwheelcommands-applicationweaponwheelcommands-src-miniquake2-runtime-application-ml-2028803150"></a>
### applicationWeaponWheelCommands

```ml
applicationWeaponWheelCommands
```

Stores module-wide application weapon wheel commands state for the miniquake2 runtime application module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/application.ml#L234)

<a id="global-global-miniquake2-runtime-application-applicationweaponwheellastgunindex-applicationweaponwheellastgunindex-src-miniquake2-runtime-application-ml-1428109202"></a>
### applicationWeaponWheelLastGunIndex

```ml
applicationWeaponWheelLastGunIndex
```

Stores module-wide application weapon wheel last gun index state for the miniquake2 runtime application module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/application.ml#L238)

<a id="global-global-miniquake2-runtime-application-applicationweaponwheelstage-applicationweaponwheelstage-src-miniquake2-runtime-application-ml-1231204972"></a>
### applicationWeaponWheelStage

```ml
applicationWeaponWheelStage
```

Stores module-wide application weapon wheel stage state for the miniquake2 runtime application module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/application.ml#L240)

<a id="global-global-miniquake2-runtime-application-applicationweaponwheeltransitions-applicationweaponwheeltransitions-src-miniquake2-runtime-application-ml-2017000340"></a>
### applicationWeaponWheelTransitions

```ml
applicationWeaponWheelTransitions
```

Stores module-wide application weapon wheel transitions state for the miniquake2 runtime application module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/application.ml#L236)

<a id="function-function-miniquake2-runtime-application-applyplayhandoff-function-applyplayhandoff-screen-handoff-src-miniquake2-runtime-application-ml-363351140"></a>
### applyPlayHandoff

```ml
function applyPlayHandoff(screen, handoff)
```

Apply play handoff.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `screen` | `dynamic` | — | screen value consumed by this operation. |
| `handoff` | `dynamic` | — | handoff value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/application.ml#L793)

<a id="function-function-miniquake2-runtime-application-assetsmoke-function-assetsmoke-basedirectory-mapname-src-miniquake2-runtime-application-ml-74015843"></a>
### assetSmoke

```ml
function assetSmoke(baseDirectory, mapName)
```

Return the asset smoke value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `baseDirectory` | `dynamic` | — | baseDirectory value consumed by this operation. |
| `mapName` | `dynamic` | — | mapName value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/application.ml#L1845)

- [miniquake2.runtime.application.AssetSmokeResult](Type-miniquake2-runtime-application-assetsmokeresult-1215826281.md) — struct
<a id="function-function-miniquake2-runtime-application-auditretailcinematic-function-auditretailcinematic-filesystem-name-src-miniquake2-runtime-application-ml-1979685612"></a>
### auditRetailCinematic

```ml
function auditRetailCinematic(filesystem, name)
```

Return the audit retail cinematic value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `filesystem` | `dynamic` | — | filesystem value consumed by this operation. |
| `name` | `dynamic` | — | Name of the affected item. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/application.ml#L1878)

<a id="function-function-miniquake2-runtime-application-auditretaildemo-function-auditretaildemo-filesystem-name-randomseed-src-miniquake2-runtime-application-ml-252857188"></a>
### auditRetailDemo

```ml
function auditRetailDemo(filesystem, name, randomSeed)
```

Return the audit retail demo value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `filesystem` | `dynamic` | — | filesystem value consumed by this operation. |
| `name` | `dynamic` | — | Name of the affected item. |
| `randomSeed` | `dynamic` | — | randomSeed value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/application.ml#L1903)

<a id="function-function-miniquake2-runtime-application-campaignmapnames-function-campaignmapnames-src-miniquake2-runtime-application-ml-894614984"></a>
### campaignMapNames

```ml
function campaignMapNames()
```

Canonical classic baseq2 single-player BSP set.  The read-only Python gate discovers every PAK map dynamically; this stable order is the product-level repeated-session stress matrix and deliberately excludes q2dm maps.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/application.ml#L2012)

<a id="function-function-miniquake2-runtime-application-campaignsignonerror-function-campaignsignonerror-session-mapname-src-miniquake2-runtime-application-ml-861591559"></a>
### campaignSignonError

```ml
function campaignSignonError(session, mapName)
```

Return the campaign signon error value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `session` | `dynamic` | — | session value consumed by this operation. |
| `mapName` | `dynamic` | — | mapName value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/application.ml#L2048)

<a id="function-function-miniquake2-runtime-application-capturelevelstart-function-capturelevelstart-basedirectory-mapname-outputpath-framelimit-src-miniquake2-runtime-application-ml-2058403337"></a>
### captureLevelStart

```ml
function captureLevelStart(baseDirectory, mapName, outputPath, frameLimit)
```

Render one deterministic 1920x1080 product frame at an authored campaign spawn without reading or overwriting the player's persistent configuration.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `baseDirectory` | `dynamic` | — | baseDirectory value consumed by this operation. |
| `mapName` | `dynamic` | — | mapName value consumed by this operation. |
| `outputPath` | `dynamic` | — | Path associated with output. |
| `frameLimit` | `dynamic` | — | frameLimit value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/application.ml#L4250)

<a id="function-function-miniquake2-runtime-application-cinematicpath-function-cinematicpath-name-src-miniquake2-runtime-application-ml-753007365"></a>
### cinematicPath

```ml
function cinematicPath(name)
```

Return the cinematic path.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `name` | `dynamic` | — | Name of the affected item. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/application.ml#L965)

<a id="function-function-miniquake2-runtime-application-closeplayaudio-function-closeplayaudio-device-mixer-src-miniquake2-runtime-application-ml-2020466271"></a>
### closePlayAudio

```ml
function closePlayAudio(device, mixer)
```

Close play audio.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `device` | `dynamic` | — | device value consumed by this operation. |
| `mixer` | `dynamic` | — | mixer value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/application.ml#L770)

<a id="function-function-miniquake2-runtime-application-countavailableassets-function-countavailableassets-entries-src-miniquake2-runtime-application-ml-1082985642"></a>
### countAvailableAssets

```ml
function countAvailableAssets(entries)
```

Report whether count available assets.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entries` | `dynamic` | — | entries value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/application.ml#L782)

<a id="extern_function-extern-function-miniquake2-runtime-application-createdirectoryw-extern-function-createdirectoryw-path-as-wstr-security-as-ptr-from-kernel32-dll-returns-bool-src-miniquake2-runtime-application-ml-953778351"></a>
### CreateDirectoryW

```ml
extern function CreateDirectoryW(path as wstr, security as ptr) from "kernel32.dll" returns bool
```

Invokes the native CreateDirectoryW entry point used by the miniquake2 runtime application module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `path` | `wstr` | — | Path of the file or directory used by the operation. |
| `security` | `ptr` | — | security value consumed by this operation. |


**Returns:** Native bool result produced by the call.

[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/application.ml#L91)

<a id="function-function-miniquake2-runtime-application-demopath-function-demopath-name-src-miniquake2-runtime-application-ml-1185687745"></a>
### demoPath

```ml
function demoPath(name)
```

Return the demo path.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `name` | `dynamic` | — | Name of the affected item. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/application.ml#L995)

<a id="function-function-miniquake2-runtime-application-endswith-function-endswith-value-suffix-src-miniquake2-runtime-application-ml-1960761778"></a>
### endsWith

```ml
function endsWith(value, suffix)
```

Return the ends with value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |
| `suffix` | `dynamic` | — | suffix value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/application.ml#L930)

<a id="function-function-miniquake2-runtime-application-executededicatedcommand-function-executededicatedcommand-session-basedirectory-text-src-miniquake2-runtime-application-ml-1786122283"></a>
### executeDedicatedCommand

```ml
function executeDedicatedCommand(session, baseDirectory, text)
```

Performs the executeDedicatedCommand operation for the miniquake2 runtime application module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `session` | `dynamic` | — | session value consumed by this operation. |
| `baseDirectory` | `dynamic` | — | baseDirectory value consumed by this operation. |
| `text` | `dynamic` | — | Text consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/application.ml#L5198)

<a id="function-function-miniquake2-runtime-application-loadplaysound-function-loadplaysound-name-src-miniquake2-runtime-application-ml-592405575"></a>
### loadPlaySound

```ml
function loadPlaySound(name)
```

Load play sound.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `name` | `dynamic` | — | Name of the affected item. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/application.ml#L614)

<a id="function-function-miniquake2-runtime-application-loadpreviewfile-function-loadpreviewfile-path-src-miniquake2-runtime-application-ml-2098173301"></a>
### loadPreviewFile

```ml
function loadPreviewFile(path)
```

Load preview file.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `path` | `dynamic` | — | Path of the file or directory used by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/application.ml#L541)

<a id="function-function-miniquake2-runtime-application-mappath-function-mappath-name-src-miniquake2-runtime-application-ml-231195787"></a>
### mapPath

```ml
function mapPath(name)
```

Map path.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `name` | `dynamic` | — | Name of the affected item. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/application.ml#L950)

<a id="function-function-miniquake2-runtime-application-missingplayassetsummary-function-missingplayassetsummary-state-src-miniquake2-runtime-application-ml-1582603017"></a>
### missingPlayAssetSummary

```ml
function missingPlayAssetSummary(state)
```

Report whether missing play asset summary.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/application.ml#L697)

<a id="function-function-miniquake2-runtime-application-notemissingplayasset-function-notemissingplayasset-value-src-miniquake2-runtime-application-ml-2132792029"></a>
### noteMissingPlayAsset

```ml
function noteMissingPlayAsset(value)
```

Report whether note missing play asset.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/application.ml#L657)

<a id="function-function-miniquake2-runtime-application-picturepath-function-picturepath-name-src-miniquake2-runtime-application-ml-16700631"></a>
### picturePath

```ml
function picturePath(name)
```

Return the picture path.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `name` | `dynamic` | — | Name of the affected item. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/application.ml#L980)

<a id="global-global-miniquake2-runtime-application-playassetbindings-playassetbindings-src-miniquake2-runtime-application-ml-573925412"></a>
### playAssetBindings

```ml
playAssetBindings
```

Stores module-wide play asset bindings state for the miniquake2 runtime application module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/application.ml#L200)

<a id="global-global-miniquake2-runtime-application-playassetstate-playassetstate-src-miniquake2-runtime-application-ml-1629816166"></a>
### playAssetState

```ml
playAssetState
```

Stores module-wide play asset state state for the miniquake2 runtime application module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/application.ml#L198)

<a id="global-global-miniquake2-runtime-application-playclientruntime-playclientruntime-src-miniquake2-runtime-application-ml-299994292"></a>
### playClientRuntime

```ml
playClientRuntime
```

Stores module-wide play client runtime state for the miniquake2 runtime application module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/application.ml#L202)

<a id="function-function-miniquake2-runtime-application-playconfigpath-function-playconfigpath-basedirectory-src-miniquake2-runtime-application-ml-101588734"></a>
### playConfigPath

```ml
function playConfigPath(baseDirectory)
```

Play config path.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `baseDirectory` | `dynamic` | — | baseDirectory value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/application.ml#L887)

<a id="function-function-miniquake2-runtime-application-playcurrentarchivepaths-function-playcurrentarchivepaths-basedirectory-src-miniquake2-runtime-application-ml-471761824"></a>
### playCurrentArchivePaths

```ml
function playCurrentArchivePaths(baseDirectory)
```

Private `current` archive used between maps within one Quake II unit.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `baseDirectory` | `dynamic` | — | baseDirectory value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/application.ml#L2412)

<a id="function-function-miniquake2-runtime-application-playdemodirectory-function-playdemodirectory-basedirectory-src-miniquake2-runtime-application-ml-2103984818"></a>
### playDemoDirectory

```ml
function playDemoDirectory(baseDirectory)
```

Play demo directory.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `baseDirectory` | `dynamic` | — | baseDirectory value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/application.ml#L921)

<a id="global-global-miniquake2-runtime-application-playeffectstate-playeffectstate-src-miniquake2-runtime-application-ml-1353906600"></a>
### playEffectState

```ml
playEffectState
```

Stores module-wide play effect state state for the miniquake2 runtime application module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/application.ml#L204)

<a id="function-function-miniquake2-runtime-application-playpreferencespath-function-playpreferencespath-basedirectory-src-miniquake2-runtime-application-ml-1801636880"></a>
### playPreferencesPath

```ml
function playPreferencesPath(baseDirectory)
```

Play preferences path.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `baseDirectory` | `dynamic` | — | baseDirectory value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/application.ml#L895)

<a id="function-function-miniquake2-runtime-application-playprofileuserinfo-function-playprofileuserinfo-profile-src-miniquake2-runtime-application-ml-1105819321"></a>
### playProfileUserInfo

```ml
function playProfileUserInfo(profile)
```

Play profile user info.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `profile` | `dynamic` | — | profile value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/application.ml#L690)

<a id="function-function-miniquake2-runtime-application-playsavemetadatapath-function-playsavemetadatapath-basedirectory-slot-src-miniquake2-runtime-application-ml-781009118"></a>
### playSaveMetadataPath

```ml
function playSaveMetadataPath(baseDirectory, slot)
```

Play save metadata path.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `baseDirectory` | `dynamic` | — | baseDirectory value consumed by this operation. |
| `slot` | `dynamic` | — | slot value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/application.ml#L905)

<a id="function-function-miniquake2-runtime-application-playsavepaths-function-playsavepaths-basedirectory-slot-src-miniquake2-runtime-application-ml-1735854504"></a>
### playSavePaths

```ml
function playSavePaths(baseDirectory, slot)
```

Play save paths.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `baseDirectory` | `dynamic` | — | baseDirectory value consumed by this operation. |
| `slot` | `dynamic` | — | slot value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/application.ml#L819)

<a id="function-function-miniquake2-runtime-application-playsaveslotlabel-function-playsaveslotlabel-slot-src-miniquake2-runtime-application-ml-449083894"></a>
### playSaveSlotLabel

```ml
function playSaveSlotLabel(slot)
```

Return the stock autosave/manual slot label.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `slot` | `dynamic` | — | slot value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/application.ml#L2405)

<a id="function-function-miniquake2-runtime-application-playscreenshotdirectory-function-playscreenshotdirectory-basedirectory-src-miniquake2-runtime-application-ml-319490880"></a>
### playScreenshotDirectory

```ml
function playScreenshotDirectory(baseDirectory)
```

Play screenshot directory.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `baseDirectory` | `dynamic` | — | baseDirectory value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/application.ml#L913)

<a id="function-function-miniquake2-runtime-application-playuserinfo-function-playuserinfo-hand-src-miniquake2-runtime-application-ml-471963611"></a>
### playUserInfo

```ml
function playUserInfo(hand)
```

Play user info.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `hand` | `dynamic` | — | hand value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/application.ml#L681)

<a id="global-global-miniquake2-runtime-application-previewfilesystem-previewfilesystem-src-miniquake2-runtime-application-ml-884276520"></a>
### previewFileSystem

```ml
previewFileSystem
```

Stores module-wide preview file system state for the miniquake2 runtime application module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/application.ml#L196)

<a id="function-function-miniquake2-runtime-application-previewmap-function-previewmap-basedirectory-mapname-framelimit-src-miniquake2-runtime-application-ml-1161360651"></a>
### previewMap

```ml
function previewMap(baseDirectory, mapName, frameLimit)
```

Map preview.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `baseDirectory` | `dynamic` | — | baseDirectory value consumed by this operation. |
| `mapName` | `dynamic` | — | mapName value consumed by this operation. |
| `frameLimit` | `dynamic` | — | frameLimit value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/application.ml#L2183)

<a id="function-function-miniquake2-runtime-application-productaddressbook-function-productaddressbook-menu-src-miniquake2-runtime-application-ml-1761658577"></a>
### productAddressBook

```ml
function productAddressBook(menu)
```

Return the product address book value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `menu` | `dynamic` | — | menu value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/application.ml#L2430)

- [miniquake2.runtime.application.ProductMenuSelection](Type-miniquake2-runtime-application-productmenuselection-30273731.md) — struct
<a id="function-function-miniquake2-runtime-application-productpathinside-function-productpathinside-basedirectory-parentdirectory-src-miniquake2-runtime-application-ml-177403777"></a>
### productPathInside

```ml
function productPathInside(baseDirectory, parentDirectory)
```

Report whether product path inside.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `baseDirectory` | `dynamic` | — | baseDirectory value consumed by this operation. |
| `parentDirectory` | `dynamic` | — | parentDirectory value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/application.ml#L831)

<a id="function-function-miniquake2-runtime-application-productsettingsdirectory-function-productsettingsdirectory-basedirectory-src-miniquake2-runtime-application-ml-1758349690"></a>
### productSettingsDirectory

```ml
function productSettingsDirectory(baseDirectory)
```

Return the product settings directory value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `baseDirectory` | `dynamic` | — | baseDirectory value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/application.ml#L864)

<a id="function-function-miniquake2-runtime-application-productsettingsdirectoryfrom-function-productsettingsdirectoryfrom-basedirectory-localappdata-programfiles-programfilesx86-src-miniquake2-runtime-application-ml-1199593448"></a>
### productSettingsDirectoryFrom

```ml
function productSettingsDirectoryFrom(baseDirectory, localAppData, programFiles, programFilesX86)
```

Keep portable installs self-contained, but never try to persist settings below a protected Program Files/Steam data root.  This mirrors modern Windows game behavior while leaving the retail assets read-only.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `baseDirectory` | `dynamic` | — | baseDirectory value consumed by this operation. |
| `localAppData` | `dynamic` | — | localAppData value consumed by this operation. |
| `programFiles` | `dynamic` | — | programFiles value consumed by this operation. |
| `programFilesX86` | `dynamic` | — | programFilesX86 value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/application.ml#L848)

<a id="function-function-miniquake2-runtime-application-pumpplayaudio-function-pumpplayaudio-device-mixer-src-miniquake2-runtime-application-ml-1036191919"></a>
### pumpPlayAudio

```ml
function pumpPlayAudio(device, mixer)
```

Pump play audio.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `device` | `dynamic` | — | device value consumed by this operation. |
| `mixer` | `dynamic` | — | mixer value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/application.ml#L755)

<a id="function-function-miniquake2-runtime-application-randomplayclienteffect-function-randomplayclienteffect-src-miniquake2-runtime-application-ml-1203788624"></a>
### randomPlayClientEffect

```ml
function randomPlayClientEffect()
```

Play random client effect.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/application.ml#L723)

<a id="function-function-miniquake2-runtime-application-remotemapmodelpath-function-remotemapmodelpath-session-src-miniquake2-runtime-application-ml-866391942"></a>
### remoteMapModelPath

```ml
function remoteMapModelPath(session)
```

Map remote model path.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `session` | `dynamic` | — | session value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/application.ml#L4430)

<a id="function-function-miniquake2-runtime-application-resolveplayeffectmodel-function-resolveplayeffectmodel-name-src-miniquake2-runtime-application-ml-1322946413"></a>
### resolvePlayEffectModel

```ml
function resolvePlayEffectModel(name)
```

Resolve play effect model.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `name` | `dynamic` | — | Name of the affected item. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/application.ml#L716)

<a id="function-function-miniquake2-runtime-application-resolveplayentityposition-function-resolveplayentityposition-number-src-miniquake2-runtime-application-ml-1469570611"></a>
### resolvePlayEntityPosition

```ml
function resolvePlayEntityPosition(number)
```

Resolve play entity position.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `number` | `dynamic` | — | number value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/application.ml#L731)

<a id="function-function-miniquake2-runtime-application-resolveplaymodelindex-function-resolveplaymodelindex-index-src-miniquake2-runtime-application-ml-1942579940"></a>
### resolvePlayModelIndex

```ml
function resolvePlayModelIndex(index)
```

Resolve play model index.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `index` | `dynamic` | — | Zero-based index of the affected item. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/application.ml#L708)

<a id="function-function-miniquake2-runtime-application-resultlines-function-resultlines-result-src-miniquake2-runtime-application-ml-766608275"></a>
### resultLines

```ml
function resultLines(result)
```

Return the result lines value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `result` | `dynamic` | — | Result object populated or inspected by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/application.ml#L1996)

- [miniquake2.runtime.application.RetailMediaAudit](Type-miniquake2-runtime-application-retailmediaaudit-1043354161.md) — struct
<a id="function-function-miniquake2-runtime-application-runcampaignsessionsmoke-function-runcampaignsessionsmoke-basedirectory-maximummaps-src-miniquake2-runtime-application-ml-635219631"></a>
### runCampaignSessionSmoke

```ml
function runCampaignSessionSmoke(baseDirectory, maximumMaps)
```

Reuse one real UDP client/server session across multiple user-owned retail maps.  This is intentionally headless: renderer registration is separately covered by --play, while this gate isolates level lifetime and re-signon.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `baseDirectory` | `dynamic` | — | baseDirectory value consumed by this operation. |
| `maximumMaps` | `dynamic` | — | maximumMaps value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/application.ml#L2115)

<a id="function-function-miniquake2-runtime-application-runchangelevelsmoke-function-runchangelevelsmoke-basedirectory-mapname-nextmap-framelimit-src-miniquake2-runtime-application-ml-2112788472"></a>
### runChangeLevelSmoke

```ml
function runChangeLevelSmoke(baseDirectory, mapName, nextMap, frameLimit)
```

Run change level smoke.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `baseDirectory` | `dynamic` | — | baseDirectory value consumed by this operation. |
| `mapName` | `dynamic` | — | mapName value consumed by this operation. |
| `nextMap` | `dynamic` | — | nextMap value consumed by this operation. |
| `frameLimit` | `dynamic` | — | frameLimit value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/application.ml#L4297)

<a id="function-function-miniquake2-runtime-application-rundedicated-function-rundedicated-basedirectory-mapname-port-framelimit-src-miniquake2-runtime-application-ml-1885631870"></a>
### runDedicated

```ml
function runDedicated(baseDirectory, mapName, port, frameLimit)
```

Runs dedicated for the miniquake2 runtime application workflow.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `baseDirectory` | `dynamic` | — | baseDirectory value consumed by this operation. |
| `mapName` | `dynamic` | — | mapName value consumed by this operation. |
| `port` | `dynamic` | — | port value consumed by this operation. |
| `frameLimit` | `dynamic` | — | frameLimit value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/application.ml#L5222)

<a id="function-function-miniquake2-runtime-application-runheadlessclient-function-runheadlessclient-address-port-framelimit-src-miniquake2-runtime-application-ml-1455617393"></a>
### runHeadlessClient

```ml
function runHeadlessClient(address, port, frameLimit)
```

Run headless client.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `address` | `dynamic` | — | address value consumed by this operation. |
| `port` | `dynamic` | — | port value consumed by this operation. |
| `frameLimit` | `dynamic` | — | frameLimit value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/application.ml#L5253)

<a id="function-function-miniquake2-runtime-application-runlisten-function-runlisten-basedirectory-mapname-framelimit-src-miniquake2-runtime-application-ml-544695587"></a>
### runListen

```ml
function runListen(baseDirectory, mapName, frameLimit)
```

Run listen.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `baseDirectory` | `dynamic` | — | baseDirectory value consumed by this operation. |
| `mapName` | `dynamic` | — | mapName value consumed by this operation. |
| `frameLimit` | `dynamic` | — | frameLimit value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/application.ml#L5267)

<a id="function-function-miniquake2-runtime-application-runplay-function-runplay-basedirectory-mapname-framelimit-src-miniquake2-runtime-application-ml-1714908569"></a>
### runPlay

```ml
function runPlay(baseDirectory, mapName, frameLimit)
```

Run play.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `baseDirectory` | `dynamic` | — | baseDirectory value consumed by this operation. |
| `mapName` | `dynamic` | — | mapName value consumed by this operation. |
| `frameLimit` | `dynamic` | — | frameLimit value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/application.ml#L4240)

<a id="function-function-miniquake2-runtime-application-runplayat-function-runplayat-basedirectory-mapname-spawnpoint-framelimit-src-miniquake2-runtime-application-ml-1710052466"></a>
### runPlayAt

```ml
function runPlayAt(baseDirectory, mapName, spawnPoint, frameLimit)
```

Run play at.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `baseDirectory` | `dynamic` | — | baseDirectory value consumed by this operation. |
| `mapName` | `dynamic` | — | mapName value consumed by this operation. |
| `spawnPoint` | `dynamic` | — | spawnPoint value consumed by this operation. |
| `frameLimit` | `dynamic` | — | frameLimit value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/application.ml#L4202)

<a id="function-function-miniquake2-runtime-application-runplayatonhost-function-runplayatonhost-basedirectory-mapname-spawnpoint-framelimit-producthost-skill-src-miniquake2-runtime-application-ml-498848398"></a>
### runPlayAtOnHost

```ml
function runPlayAtOnHost(baseDirectory, mapName, spawnPoint, frameLimit, productHost, skill)
```

Report whether run play at on host.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `baseDirectory` | `dynamic` | — | baseDirectory value consumed by this operation. |
| `mapName` | `dynamic` | — | mapName value consumed by this operation. |
| `spawnPoint` | `dynamic` | — | spawnPoint value consumed by this operation. |
| `frameLimit` | `dynamic` | — | frameLimit value consumed by this operation. |
| `productHost` | `dynamic` | — | productHost value consumed by this operation. |
| `skill` | `dynamic` | — | skill value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/application.ml#L4191)

<a id="function-function-miniquake2-runtime-application-runplayatonhostconfigured-function-runplayatonhostconfigured-basedirectory-mapname-spawnpoint-framelimit-producthost-skill-menuatstart-serveroptions-playerprofile-src-miniquake2-runtime-application-ml-630375751"></a>
### runPlayAtOnHostConfigured

```ml
function runPlayAtOnHostConfigured(baseDirectory, mapName, spawnPoint, frameLimit, productHost, skill, menuAtStart, serverOptions, playerProfile)
```

Report whether run play at on host configured.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `baseDirectory` | `dynamic` | — | baseDirectory value consumed by this operation. |
| `mapName` | `dynamic` | — | mapName value consumed by this operation. |
| `spawnPoint` | `dynamic` | — | spawnPoint value consumed by this operation. |
| `frameLimit` | `dynamic` | — | frameLimit value consumed by this operation. |
| `productHost` | `dynamic` | — | productHost value consumed by this operation. |
| `skill` | `dynamic` | — | skill value consumed by this operation. |
| `menuAtStart` | `dynamic` | — | menuAtStart value consumed by this operation. |
| `serverOptions` | `dynamic` | — | serverOptions value consumed by this operation. |
| `playerProfile` | `dynamic` | — | playerProfile value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/application.ml#L4177)

<a id="function-function-miniquake2-runtime-application-runplayatonhostconfiguredwithconfig-function-runplayatonhostconfiguredwithconfig-basedirectory-mapname-spawnpoint-framelimit-producthost-skill-menuatstart-serveroptions-playerprofile-initialconfig-src-miniquake2-runtime-application-ml-303787105"></a>
### runPlayAtOnHostConfiguredWithConfig

```ml
function runPlayAtOnHostConfiguredWithConfig(baseDirectory, mapName, spawnPoint, frameLimit, productHost, skill, menuAtStart, serverOptions, playerProfile, initialConfig)
```

Report whether run play at on host configured with config.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `baseDirectory` | `dynamic` | — | baseDirectory value consumed by this operation. |
| `mapName` | `dynamic` | — | mapName value consumed by this operation. |
| `spawnPoint` | `dynamic` | — | spawnPoint value consumed by this operation. |
| `frameLimit` | `dynamic` | — | frameLimit value consumed by this operation. |
| `productHost` | `dynamic` | — | productHost value consumed by this operation. |
| `skill` | `dynamic` | — | skill value consumed by this operation. |
| `menuAtStart` | `dynamic` | — | menuAtStart value consumed by this operation. |
| `serverOptions` | `dynamic` | — | serverOptions value consumed by this operation. |
| `playerProfile` | `dynamic` | — | playerProfile value consumed by this operation. |
| `initialConfig` | `dynamic` | — | initialConfig value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/application.ml#L4159)

<a id="function-function-miniquake2-runtime-application-runplayatonhostconfiguredwithstate-function-runplayatonhostconfiguredwithstate-basedirectory-mapname-spawnpoint-framelimit-producthost-skill-menuatstart-serveroptions-playerprofile-initialconfig-initialgameplayhandover-src-miniquake2-runtime-application-ml-634929434"></a>
### runPlayAtOnHostConfiguredWithState

```ml
function runPlayAtOnHostConfiguredWithState(baseDirectory, mapName, spawnPoint, frameLimit, productHost, skill, menuAtStart, serverOptions, playerProfile, initialConfig, initialGameplayHandover)
```

Construct and drive one authoritative local/listen session inside an existing product host. Loading, signon and renderer warm-up finish before audio starts; every exit path returns a complete transition/diagnostic value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `baseDirectory` | `dynamic` | — | baseDirectory value consumed by this operation. |
| `mapName` | `dynamic` | — | mapName value consumed by this operation. |
| `spawnPoint` | `dynamic` | — | spawnPoint value consumed by this operation. |
| `frameLimit` | `dynamic` | — | frameLimit value consumed by this operation. |
| `productHost` | `dynamic` | — | productHost value consumed by this operation. |
| `skill` | `dynamic` | — | skill value consumed by this operation. |
| `menuAtStart` | `dynamic` | — | menuAtStart value consumed by this operation. |
| `serverOptions` | `dynamic` | — | serverOptions value consumed by this operation. |
| `playerProfile` | `dynamic` | — | playerProfile value consumed by this operation. |
| `initialConfig` | `dynamic` | — | initialConfig value consumed by this operation. |
| `initialGameplayHandover` | `dynamic` | — | initialGameplayHandover value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/application.ml#L2865)

<a id="function-function-miniquake2-runtime-application-runplayinputsmoke-function-runplayinputsmoke-basedirectory-mapname-commandsteps-src-miniquake2-runtime-application-ml-1160032319"></a>
### runPlayInputSmoke

```ml
function runPlayInputSmoke(baseDirectory, mapName, commandSteps)
```

Run play input smoke.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `baseDirectory` | `dynamic` | — | baseDirectory value consumed by this operation. |
| `mapName` | `dynamic` | — | mapName value consumed by this operation. |
| `commandSteps` | `dynamic` | — | commandSteps value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/application.ml#L2151)

<a id="function-function-miniquake2-runtime-application-runproduct-function-runproduct-basedirectory-framelimit-src-miniquake2-runtime-application-ml-1654492110"></a>
### runProduct

```ml
function runProduct(baseDirectory, frameLimit)
```

Run product.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `baseDirectory` | `dynamic` | — | baseDirectory value consumed by this operation. |
| `frameLimit` | `dynamic` | — | frameLimit value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/application.ml#L5021)

<a id="function-function-miniquake2-runtime-application-runproductmenuonhost-function-runproductmenuonhost-basedirectory-producthost-framelimit-initialprofile-src-miniquake2-runtime-application-ml-868951180"></a>
### runProductMenuOnHost

```ml
function runProductMenuOnHost(baseDirectory, productHost, frameLimit, initialProfile)
```

Own the menu-only product state until one typed transition is selected. Config, preferences, audio and renderer resources are finalized here so a subsequent local/remote session starts without retaining menu temporaries.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `baseDirectory` | `dynamic` | — | baseDirectory value consumed by this operation. |
| `productHost` | `dynamic` | — | productHost value consumed by this operation. |
| `frameLimit` | `dynamic` | — | frameLimit value consumed by this operation. |
| `initialProfile` | `dynamic` | — | initialProfile value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/application.ml#L2482)

<a id="function-function-miniquake2-runtime-application-runprojectilevisualsmoke-function-runprojectilevisualsmoke-basedirectory-mapname-framelimit-src-miniquake2-runtime-application-ml-1745464295"></a>
### runProjectileVisualSmoke

```ml
function runProjectileVisualSmoke(baseDirectory, mapName, frameLimit)
```

Run projectile visual smoke.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `baseDirectory` | `dynamic` | — | baseDirectory value consumed by this operation. |
| `mapName` | `dynamic` | — | mapName value consumed by this operation. |
| `frameLimit` | `dynamic` | — | frameLimit value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/application.ml#L4380)

<a id="function-function-miniquake2-runtime-application-runremoteproductonhost-function-runremoteproductonhost-basedirectory-endpoint-producthost-playerprofile-downloadpolicy-framelimit-src-miniquake2-runtime-application-ml-1170465716"></a>
### runRemoteProductOnHost

```ml
function runRemoteProductOnHost(baseDirectory, endpoint, productHost, playerProfile, downloadPolicy, frameLimit)
```

Drive a remote Protocol-34 client with independent render, UserCmd and snapshot clocks. Registration is committed only after downloads, checksum validation and all client assets complete successfully.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `baseDirectory` | `dynamic` | — | baseDirectory value consumed by this operation. |
| `endpoint` | `dynamic` | — | endpoint value consumed by this operation. |
| `productHost` | `dynamic` | — | productHost value consumed by this operation. |
| `playerProfile` | `dynamic` | — | playerProfile value consumed by this operation. |
| `downloadPolicy` | `dynamic` | — | downloadPolicy value consumed by this operation. |
| `frameLimit` | `dynamic` | — | frameLimit value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/application.ml#L4508)

<a id="function-function-miniquake2-runtime-application-runremoteproductsmoke-function-runremoteproductsmoke-basedirectory-endpoint-framelimit-src-miniquake2-runtime-application-ml-1991035987"></a>
### runRemoteProductSmoke

```ml
function runRemoteProductSmoke(baseDirectory, endpoint, frameLimit)
```

Run remote product smoke.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `baseDirectory` | `dynamic` | — | baseDirectory value consumed by this operation. |
| `endpoint` | `dynamic` | — | endpoint value consumed by this operation. |
| `frameLimit` | `dynamic` | — | frameLimit value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/application.ml#L5007)

<a id="function-function-miniquake2-runtime-application-runretailcinematic-function-runretailcinematic-basedirectory-name-framelimit-looping-src-miniquake2-runtime-application-ml-1155860641"></a>
### runRetailCinematic

```ml
function runRetailCinematic(baseDirectory, name, frameLimit, looping)
```

Run retail cinematic.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `baseDirectory` | `dynamic` | — | baseDirectory value consumed by this operation. |
| `name` | `dynamic` | — | Name of the affected item. |
| `frameLimit` | `dynamic` | — | frameLimit value consumed by this operation. |
| `looping` | `dynamic` | — | looping value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/application.ml#L1142)

<a id="function-function-miniquake2-runtime-application-runretailcinematiconhost-function-runretailcinematiconhost-basedirectory-name-framelimit-looping-producthost-attractloop-src-miniquake2-runtime-application-ml-249712677"></a>
### runRetailCinematicOnHost

```ml
function runRetailCinematicOnHost(baseDirectory, name, frameLimit, looping, productHost, attractLoop)
```

Product CIN lifecycle: retail FS -> Huffman frames/palette -> OpenGL raw stretch, with the CIN PCM stream feeding the same managed mixer/device used by gameplay. Escape opens/closes the existing menu and pauses/resumes both video time and its mixer channel without losing the current frame.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `baseDirectory` | `dynamic` | — | baseDirectory value consumed by this operation. |
| `name` | `dynamic` | — | Name of the affected item. |
| `frameLimit` | `dynamic` | — | frameLimit value consumed by this operation. |
| `looping` | `dynamic` | — | looping value consumed by this operation. |
| `productHost` | `dynamic` | — | productHost value consumed by this operation. |
| `attractLoop` | `dynamic` | — | attractLoop value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/application.ml#L1018)

<a id="function-function-miniquake2-runtime-application-runretaildemo-function-runretaildemo-basedirectory-name-framelimit-src-miniquake2-runtime-application-ml-1729135261"></a>
### runRetailDemo

```ml
function runRetailDemo(baseDirectory, name, frameLimit)
```

Run retail demo.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `baseDirectory` | `dynamic` | — | baseDirectory value consumed by this operation. |
| `name` | `dynamic` | — | Name of the affected item. |
| `frameLimit` | `dynamic` | — | frameLimit value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/application.ml#L1555)

<a id="function-function-miniquake2-runtime-application-runretaildemoonhost-function-runretaildemoonhost-basedirectory-name-framelimit-producthost-attractloop-src-miniquake2-runtime-application-ml-546909131"></a>
### runRetailDemoOnHost

```ml
function runRetailDemoOnHost(baseDirectory, name, frameLimit, productHost, attractLoop)
```

Product DM2 lifecycle. Release demos are Protocol 26 streams; DemoSession owns that isolated compatibility mode while all live networking remains 34. Configstrings drive the same BSP/model/sound registration and frame/effect handoff used by a connected game.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `baseDirectory` | `dynamic` | — | baseDirectory value consumed by this operation. |
| `name` | `dynamic` | — | Name of the affected item. |
| `frameLimit` | `dynamic` | — | frameLimit value consumed by this operation. |
| `productHost` | `dynamic` | — | productHost value consumed by this operation. |
| `attractLoop` | `dynamic` | — | attractLoop value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/application.ml#L1278)

<a id="function-function-miniquake2-runtime-application-runretailmediaaudit-function-runretailmediaaudit-basedirectory-src-miniquake2-runtime-application-ml-613081900"></a>
### runRetailMediaAudit

```ml
function runRetailMediaAudit(baseDirectory)
```

Deterministic, headless retail gate for the media paths that otherwise need interactive windows. It decodes one real frame from both stock CIN files, replays both release DM2 streams through their Protocol-26 compatibility dispatcher, publishes base1's worldspawn CD track through Game API v3, and opens the matching OGG through the production Vorbis bridge.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `baseDirectory` | `dynamic` | — | baseDirectory value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/application.ml#L1928)

<a id="function-function-miniquake2-runtime-application-runretailmediasequence-function-runretailmediasequence-basedirectory-specification-framelimit-src-miniquake2-runtime-application-ml-240757123"></a>
### runRetailMediaSequence

```ml
function runRetailMediaSequence(baseDirectory, specification, frameLimit)
```

Run retail media sequence.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `baseDirectory` | `dynamic` | — | baseDirectory value consumed by this operation. |
| `specification` | `dynamic` | — | specification value consumed by this operation. |
| `frameLimit` | `dynamic` | — | frameLimit value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/application.ml#L1824)

<a id="function-function-miniquake2-runtime-application-runretailmediasequenceonhost-function-runretailmediasequenceonhost-basedirectory-specification-framelimit-producthost-skill-src-miniquake2-runtime-application-ml-548854689"></a>
### runRetailMediaSequenceOnHost

```ml
function runRetailMediaSequenceOnHost(baseDirectory, specification, frameLimit, productHost, skill)
```

Report whether run retail media sequence on host.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `baseDirectory` | `dynamic` | — | baseDirectory value consumed by this operation. |
| `specification` | `dynamic` | — | specification value consumed by this operation. |
| `frameLimit` | `dynamic` | — | frameLimit value consumed by this operation. |
| `productHost` | `dynamic` | — | productHost value consumed by this operation. |
| `skill` | `dynamic` | — | skill value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/application.ml#L1814)

<a id="function-function-miniquake2-runtime-application-runretailmediasequenceonhostwithsettings-function-runretailmediasequenceonhostwithsettings-basedirectory-specification-framelimit-producthost-skill-initialconfig-playerprofile-src-miniquake2-runtime-application-ml-1842263813"></a>
### runRetailMediaSequenceOnHostWithSettings

```ml
function runRetailMediaSequenceOnHostWithSettings(baseDirectory, specification, frameLimit, productHost, skill, initialConfig, playerProfile)
```

Report whether run retail media sequence on host with settings.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `baseDirectory` | `dynamic` | — | baseDirectory value consumed by this operation. |
| `specification` | `dynamic` | — | specification value consumed by this operation. |
| `frameLimit` | `dynamic` | — | frameLimit value consumed by this operation. |
| `productHost` | `dynamic` | — | productHost value consumed by this operation. |
| `skill` | `dynamic` | — | skill value consumed by this operation. |
| `initialConfig` | `dynamic` | — | initialConfig value consumed by this operation. |
| `playerProfile` | `dynamic` | — | playerProfile value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/application.ml#L1802)

<a id="function-function-miniquake2-runtime-application-runretailmediasequenceonhostwithstate-function-runretailmediasequenceonhostwithstate-basedirectory-specification-framelimit-producthost-skill-initialconfig-playerprofile-initialgameplayhandover-src-miniquake2-runtime-application-ml-557661010"></a>
### runRetailMediaSequenceOnHostWithState

```ml
function runRetailMediaSequenceOnHostWithState(baseDirectory, specification, frameLimit, productHost, skill, initialConfig, playerProfile, initialGameplayHandover)
```

Execute the exact classic `map first+nextserver` media chain. A positive frame limit is a deterministic preview gate per step; zero retains normal interactive behavior (CIN to completion, PCX until Space/Enter, map until window close). DM2 uses the isolated release-demo Protocol-26 compatibility path and renders through the same Protocol-34 client state and product host.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `baseDirectory` | `dynamic` | — | baseDirectory value consumed by this operation. |
| `specification` | `dynamic` | — | specification value consumed by this operation. |
| `frameLimit` | `dynamic` | — | frameLimit value consumed by this operation. |
| `productHost` | `dynamic` | — | productHost value consumed by this operation. |
| `skill` | `dynamic` | — | skill value consumed by this operation. |
| `initialConfig` | `dynamic` | — | initialConfig value consumed by this operation. |
| `playerProfile` | `dynamic` | — | playerProfile value consumed by this operation. |
| `initialGameplayHandover` | `dynamic` | — | initialGameplayHandover value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/application.ml#L1625)

<a id="function-function-miniquake2-runtime-application-runretailpicture-function-runretailpicture-basedirectory-name-framelimit-src-miniquake2-runtime-application-ml-2012812315"></a>
### runRetailPicture

```ml
function runRetailPicture(baseDirectory, name, frameLimit)
```

Run retail picture.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `baseDirectory` | `dynamic` | — | baseDirectory value consumed by this operation. |
| `name` | `dynamic` | — | Name of the affected item. |
| `frameLimit` | `dynamic` | — | frameLimit value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/application.ml#L1241)

<a id="function-function-miniquake2-runtime-application-runretailpictureonhost-function-runretailpictureonhost-basedirectory-name-framelimit-producthost-src-miniquake2-runtime-application-ml-1608693484"></a>
### runRetailPictureOnHost

```ml
function runRetailPictureOnHost(baseDirectory, name, frameLimit, productHost)
```

Static intermission counterpart to runCinematic. Space/Enter emits the classic nextserver intent; Escape opens the same menu/quit lifecycle.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `baseDirectory` | `dynamic` | — | baseDirectory value consumed by this operation. |
| `name` | `dynamic` | — | Name of the affected item. |
| `frameLimit` | `dynamic` | — | frameLimit value consumed by this operation. |
| `productHost` | `dynamic` | — | productHost value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/application.ml#L1158)

<a id="function-function-miniquake2-runtime-application-runretailvideorestartsmoke-function-runretailvideorestartsmoke-basedirectory-mapname-src-miniquake2-runtime-application-ml-1282344759"></a>
### runRetailVideoRestartSmoke

```ml
function runRetailVideoRestartSmoke(baseDirectory, mapName)
```

Run retail video restart smoke.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `baseDirectory` | `dynamic` | — | baseDirectory value consumed by this operation. |
| `mapName` | `dynamic` | — | mapName value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/application.ml#L2424)

<a id="function-function-miniquake2-runtime-application-runretailvideorestartsmokeformode-function-runretailvideorestartsmokeformode-basedirectory-mapname-targetvideomode-src-miniquake2-runtime-application-ml-799366716"></a>
### runRetailVideoRestartSmokeForMode

```ml
function runRetailVideoRestartSmokeForMode(baseDirectory, mapName, targetVideoMode)
```

Native product acceptance for the same mode-apply path used by the live Video menu. The network/game session deliberately does not participate: the gate isolates the Win32 mode change and verifies that the registered BSP remains usable on the same renderer generation.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `baseDirectory` | `dynamic` | — | baseDirectory value consumed by this operation. |
| `mapName` | `dynamic` | — | mapName value consumed by this operation. |
| `targetVideoMode` | `dynamic` | — | targetVideoMode value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/application.ml#L2264)

<a id="function-function-miniquake2-runtime-application-runstockattractlooponhost-function-runstockattractlooponhost-basedirectory-producthost-src-miniquake2-runtime-application-ml-90845085"></a>
### runStockAttractLoopOnHost

```ml
function runStockAttractLoopOnHost(baseDirectory, productHost)
```

Qcommon_Init executes the stock d1 alias when no explicit +command was supplied. Keep the four-entry alias cycle data-driven so any input can hand control back to the persistent product menu without opening another host.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `baseDirectory` | `dynamic` | — | baseDirectory value consumed by this operation. |
| `productHost` | `dynamic` | — | productHost value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/application.ml#L1570)

<a id="function-function-miniquake2-runtime-application-runweaponwheelsmoke-function-runweaponwheelsmoke-basedirectory-mapname-framelimit-src-miniquake2-runtime-application-ml-1470854689"></a>
### runWeaponWheelSmoke

```ml
function runWeaponWheelSmoke(baseDirectory, mapName, frameLimit)
```

Run weapon wheel smoke.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `baseDirectory` | `dynamic` | — | baseDirectory value consumed by this operation. |
| `mapName` | `dynamic` | — | mapName value consumed by this operation. |
| `frameLimit` | `dynamic` | — | frameLimit value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/application.ml#L4411)

<a id="function-function-miniquake2-runtime-application-settlecampaignsession-function-settlecampaignsession-session-maximumsteps-src-miniquake2-runtime-application-ml-1690234823"></a>
### settleCampaignSession

```ml
function settleCampaignSession(session, maximumSteps)
```

Return the settle campaign session value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `session` | `dynamic` | — | session value consumed by this operation. |
| `maximumSteps` | `dynamic` | — | maximumSteps value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/application.ml#L2026)

<a id="function-function-miniquake2-runtime-application-takeactiveproductselection-function-takeactiveproductselection-commandstate-playerprofile-productconfig-src-miniquake2-runtime-application-ml-1320801323"></a>
### takeActiveProductSelection

```ml
function takeActiveProductSelection(commandState, playerProfile, productConfig)
```

Consume a multiplayer request made from an active local game's menu. The caller tears the current listen session down before the product loop starts the selected replacement, so no single-player Game API state leaks into the new server or remote connection.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `commandState` | `dynamic` | — | commandState value consumed by this operation. |
| `playerProfile` | `dynamic` | — | playerProfile value consumed by this operation. |
| `productConfig` | `dynamic` | — | productConfig value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/application.ml#L2835)

<a id="function-function-miniquake2-runtime-application-updateproductbrowsermenu-function-updateproductbrowsermenu-menu-browser-src-miniquake2-runtime-application-ml-1365135433"></a>
### updateProductBrowserMenu

```ml
function updateProductBrowserMenu(menu, browser)
```

Update product browser menu.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `menu` | `dynamic` | — | menu value consumed by this operation. |
| `browser` | `dynamic` | — | browser value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/application.ml#L2449)
