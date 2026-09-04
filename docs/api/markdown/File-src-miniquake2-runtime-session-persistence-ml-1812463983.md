# `src/miniquake2/runtime/session_persistence.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 runtime session persistence facilities for this project.

Package: [`miniquake2.runtime.session_persistence`](Package-miniquake2-runtime-session-persistence-583629831.md)

Reachable from entry: **yes**

## Imports

- `miniquake2/client/runtime/dispatcher.ml` as `savegatedispatcher` → [src/miniquake2/client/runtime/dispatcher.ml](File-src-miniquake2-client-runtime-dispatcher-ml-506346494.md)
- `miniquake2/game/null_game.ml` as `savegategameapi` → [src/miniquake2/game/null_game.ml](File-src-miniquake2-game-null-game-ml-1916269379.md)
- `miniquake2/game/persistence.ml` as `savegategamepersistence` → [src/miniquake2/game/persistence.ml](File-src-miniquake2-game-persistence-ml-545577318.md)
- `miniquake2/network/constants.ml` as `savegatenetworkconstants` → [src/miniquake2/network/constants.ml](File-src-miniquake2-network-constants-ml-102415622.md)
- `miniquake2/runtime/multiplayer_session.ml` as `savegatemultiplayer` → [src/miniquake2/runtime/multiplayer_session.ml](File-src-miniquake2-runtime-multiplayer-session-ml-510496210.md)
- `miniquake2/runtime/play_session.ml` as `savegateplaysession` → [src/miniquake2/runtime/play_session.ml](File-src-miniquake2-runtime-play-session-ml-1798366100.md)
- `miniquake2/runtime/server_session.ml` as `savegateserversession` → [src/miniquake2/runtime/server_session.ml](File-src-miniquake2-runtime-server-session-ml-1518722291.md)

## Declarations

<a id="function-function-miniquake2-runtime-session-persistence-changecoreuntilcommitted-function-changecoreuntilcommitted-session-mapname-entitytext-collision-maximumsteps-src-miniquake2-runtime-session-persistence-ml-1229507636"></a>
### changeCoreUntilCommitted

```ml
function changeCoreUntilCommitted(session, mapName, entityText, collision, maximumSteps)
```

Return the change core until committed value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `session` | `dynamic` | — | session value consumed by this operation. |
| `mapName` | `dynamic` | — | mapName value consumed by this operation. |
| `entityText` | `dynamic` | — | entityText value consumed by this operation. |
| `collision` | `dynamic` | — | collision value consumed by this operation. |
| `maximumSteps` | `dynamic` | — | maximumSteps value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/session_persistence.ml#L366)

<a id="function-function-miniquake2-runtime-session-persistence-changeretailuntilcommitted-function-changeretailuntilcommitted-session-basedirectory-mapname-maximumsteps-src-miniquake2-runtime-session-persistence-ml-775141862"></a>
### changeRetailUntilCommitted

```ml
function changeRetailUntilCommitted(session, baseDirectory, mapName, maximumSteps)
```

Return the change retail until committed value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `session` | `dynamic` | — | session value consumed by this operation. |
| `baseDirectory` | `dynamic` | — | baseDirectory value consumed by this operation. |
| `mapName` | `dynamic` | — | mapName value consumed by this operation. |
| `maximumSteps` | `dynamic` | — | maximumSteps value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/session_persistence.ml#L383)

<a id="function-function-miniquake2-runtime-session-persistence-coremapsource-function-coremapsource-entitytext-collision-src-miniquake2-runtime-session-persistence-ml-1981672194"></a>
### coreMapSource

```ml
function coreMapSource(entityText, collision)
```

Map core source.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entityText` | `dynamic` | — | entityText value consumed by this operation. |
| `collision` | `dynamic` | — | collision value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/session_persistence.ml#L63)

- [miniquake2.runtime.session_persistence.CoreMapSource](Type-miniquake2-runtime-session-persistence-coremapsource-893917851.md) — struct
<a id="function-function-miniquake2-runtime-session-persistence-crossmapfailure-function-crossmapfailure-session-rollbackcheckpoint-rollbackentitytext-rollbackcollision-maximumsteps-failure-src-miniquake2-runtime-session-persistence-ml-1086218907"></a>
### crossMapFailure

```ml
function crossMapFailure(session, rollbackCheckpoint, rollbackEntityText, rollbackCollision, maximumSteps, failure)
```

Compute map failure.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `session` | `dynamic` | — | session value consumed by this operation. |
| `rollbackCheckpoint` | `dynamic` | — | rollbackCheckpoint value consumed by this operation. |
| `rollbackEntityText` | `dynamic` | — | rollbackEntityText value consumed by this operation. |
| `rollbackCollision` | `dynamic` | — | rollbackCollision value consumed by this operation. |
| `maximumSteps` | `dynamic` | — | maximumSteps value consumed by this operation. |
| `failure` | `dynamic` | — | failure value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/session_persistence.ml#L420)

<a id="function-function-miniquake2-runtime-session-persistence-finishcrossmaprestore-function-finishcrossmaprestore-session-checkpoint-rollbackcheckpoint-rollbackentitytext-rollbackcollision-maximumsteps-src-miniquake2-runtime-session-persistence-ml-16423201"></a>
### finishCrossMapRestore

```ml
function finishCrossMapRestore(session, checkpoint, rollbackCheckpoint, rollbackEntityText, rollbackCollision, maximumSteps)
```

Finish cross map restore.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `session` | `dynamic` | — | session value consumed by this operation. |
| `checkpoint` | `dynamic` | — | checkpoint value consumed by this operation. |
| `rollbackCheckpoint` | `dynamic` | — | rollbackCheckpoint value consumed by this operation. |
| `rollbackEntityText` | `dynamic` | — | rollbackEntityText value consumed by this operation. |
| `rollbackCollision` | `dynamic` | — | rollbackCollision value consumed by this operation. |
| `maximumSteps` | `dynamic` | — | maximumSteps value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/session_persistence.ml#L461)

<a id="function-function-miniquake2-runtime-session-persistence-loadsessioncheckpoint-function-loadsessioncheckpoint-gamepath-levelpath-maxedicts-src-miniquake2-runtime-session-persistence-ml-1678236184"></a>
### loadSessionCheckpoint

```ml
function loadSessionCheckpoint(gamePath, levelPath, maxEdicts)
```

Reconstruct durable slot metadata after a process restart. Spawn/server epochs are intentionally unknown (-1/0); restorePlaySessionRetail therefore performs a legal re-signon before applying the images.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `gamePath` | `dynamic` | — | Path associated with game. |
| `levelPath` | `dynamic` | — | Path associated with level. |
| `maxEdicts` | `dynamic` | — | maxEdicts value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/session_persistence.ml#L160)

<a id="function-function-miniquake2-runtime-session-persistence-readcheckpointimages-function-readcheckpointimages-server-gamepath-levelpath-expectedmap-src-miniquake2-runtime-session-persistence-ml-1318016485"></a>
### readCheckpointImages

```ml
function readCheckpointImages(server, gamePath, levelPath, expectedMap)
```

Read checkpoint images.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `server` | `dynamic` | — | server value consumed by this operation. |
| `gamePath` | `dynamic` | — | Path associated with game. |
| `levelPath` | `dynamic` | — | Path associated with level. |
| `expectedMap` | `dynamic` | — | expectedMap value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/session_persistence.ml#L85)

<a id="function-function-miniquake2-runtime-session-persistence-restorefailure-function-restorefailure-server-rollbackgamepath-rollbacklevelpath-failure-src-miniquake2-runtime-session-persistence-ml-561564401"></a>
### restoreFailure

```ml
function restoreFailure(server, rollbackGamePath, rollbackLevelPath, failure)
```

Restore failure.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `server` | `dynamic` | — | server value consumed by this operation. |
| `rollbackGamePath` | `dynamic` | — | Path associated with rollback game. |
| `rollbackLevelPath` | `dynamic` | — | Path associated with rollback level. |
| `failure` | `dynamic` | — | failure value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/session_persistence.ml#L197)

<a id="function-function-miniquake2-runtime-session-persistence-restoremultiplayersession-function-restoremultiplayersession-session-checkpoint-src-miniquake2-runtime-session-persistence-ml-1183338620"></a>
### restoreMultiplayerSession

```ml
function restoreMultiplayerSession(session, checkpoint)
```

Restore multiplayer session.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `session` | `dynamic` | — | session value consumed by this operation. |
| `checkpoint` | `dynamic` | — | checkpoint value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/session_persistence.ml#L298)

<a id="function-function-miniquake2-runtime-session-persistence-restoreplaysession-function-restoreplaysession-session-checkpoint-src-miniquake2-runtime-session-persistence-ml-155461620"></a>
### restorePlaySession

```ml
function restorePlaySession(session, checkpoint)
```

Restore play session.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `session` | `dynamic` | — | session value consumed by this operation. |
| `checkpoint` | `dynamic` | — | checkpoint value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/session_persistence.ml#L276)

<a id="function-function-miniquake2-runtime-session-persistence-restoreplaysessioncore-function-restoreplaysessioncore-session-checkpoint-resolver-maximumsteps-src-miniquake2-runtime-session-persistence-ml-849192517"></a>
### restorePlaySessionCore

```ml
function restorePlaySessionCore(session, checkpoint, resolver, maximumSteps)
```

Restore play session core.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `session` | `dynamic` | — | session value consumed by this operation. |
| `checkpoint` | `dynamic` | — | checkpoint value consumed by this operation. |
| `resolver` | `dynamic` | — | resolver value consumed by this operation. |
| `maximumSteps` | `dynamic` | — | maximumSteps value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/session_persistence.ml#L505)

<a id="function-function-miniquake2-runtime-session-persistence-restoreplaysessionretail-function-restoreplaysessionretail-session-checkpoint-basedirectory-maximumsteps-src-miniquake2-runtime-session-persistence-ml-2001361121"></a>
### restorePlaySessionRetail

```ml
function restorePlaySessionRetail(session, checkpoint, baseDirectory, maximumSteps)
```

Restore play session retail.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `session` | `dynamic` | — | session value consumed by this operation. |
| `checkpoint` | `dynamic` | — | checkpoint value consumed by this operation. |
| `baseDirectory` | `dynamic` | — | baseDirectory value consumed by this operation. |
| `maximumSteps` | `dynamic` | — | maximumSteps value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/session_persistence.ml#L538)

<a id="function-function-miniquake2-runtime-session-persistence-restoreserversession-function-restoreserversession-server-checkpoint-src-miniquake2-runtime-session-persistence-ml-1489490475"></a>
### restoreServerSession

```ml
function restoreServerSession(server, checkpoint)
```

Restore server session.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `server` | `dynamic` | — | server value consumed by this operation. |
| `checkpoint` | `dynamic` | — | checkpoint value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/session_persistence.ml#L269)

<a id="function-function-miniquake2-runtime-session-persistence-restoreserversessionatcurrentepoch-function-restoreserversessionatcurrentepoch-server-checkpoint-requiresavedspawn-src-miniquake2-runtime-session-persistence-ml-1645183760"></a>
### restoreServerSessionAtCurrentEpoch

```ml
function restoreServerSessionAtCurrentEpoch(server, checkpoint, requireSavedSpawn)
```

Restore server session at current epoch.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `server` | `dynamic` | — | server value consumed by this operation. |
| `checkpoint` | `dynamic` | — | checkpoint value consumed by this operation. |
| `requireSavedSpawn` | `dynamic` | — | requireSavedSpawn value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/session_persistence.ml#L209)

<a id="function-function-miniquake2-runtime-session-persistence-rollbackcrossmap-function-rollbackcrossmap-session-rollbackcheckpoint-entitytext-collision-maximumsteps-src-miniquake2-runtime-session-persistence-ml-866929633"></a>
### rollbackCrossMap

```ml
function rollbackCrossMap(session, rollbackCheckpoint, entityText, collision, maximumSteps)
```

Compute rollback map.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `session` | `dynamic` | — | session value consumed by this operation. |
| `rollbackCheckpoint` | `dynamic` | — | rollbackCheckpoint value consumed by this operation. |
| `entityText` | `dynamic` | — | entityText value consumed by this operation. |
| `collision` | `dynamic` | — | collision value consumed by this operation. |
| `maximumSteps` | `dynamic` | — | maximumSteps value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/session_persistence.ml#L404)

<a id="function-function-miniquake2-runtime-session-persistence-rollbackserversession-function-rollbackserversession-server-rollbackgamepath-rollbacklevelpath-src-miniquake2-runtime-session-persistence-ml-380519537"></a>
### rollbackServerSession

```ml
function rollbackServerSession(server, rollbackGamePath, rollbackLevelPath)
```

Return the rollback server session value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `server` | `dynamic` | — | server value consumed by this operation. |
| `rollbackGamePath` | `dynamic` | — | Path associated with rollback game. |
| `rollbackLevelPath` | `dynamic` | — | Path associated with rollback level. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/session_persistence.ml#L184)

<a id="function-function-miniquake2-runtime-session-persistence-savecrossmaprollback-function-savecrossmaprollback-session-checkpoint-src-miniquake2-runtime-session-persistence-ml-1745383376"></a>
### saveCrossMapRollback

```ml
function saveCrossMapRollback(session, checkpoint)
```

Save cross map rollback.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `session` | `dynamic` | — | session value consumed by this operation. |
| `checkpoint` | `dynamic` | — | checkpoint value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/session_persistence.ml#L352)

<a id="function-function-miniquake2-runtime-session-persistence-savemultiplayersession-function-savemultiplayersession-session-gamepath-levelpath-src-miniquake2-runtime-session-persistence-ml-1488520290"></a>
### saveMultiplayerSession

```ml
function saveMultiplayerSession(session, gamePath, levelPath)
```

Save multiplayer session.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `session` | `dynamic` | — | session value consumed by this operation. |
| `gamePath` | `dynamic` | — | Path associated with game. |
| `levelPath` | `dynamic` | — | Path associated with level. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/session_persistence.ml#L147)

<a id="function-function-miniquake2-runtime-session-persistence-saveplaysession-function-saveplaysession-session-gamepath-levelpath-src-miniquake2-runtime-session-persistence-ml-846453200"></a>
### savePlaySession

```ml
function savePlaySession(session, gamePath, levelPath)
```

Save play session.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `session` | `dynamic` | — | session value consumed by this operation. |
| `gamePath` | `dynamic` | — | Path associated with game. |
| `levelPath` | `dynamic` | — | Path associated with level. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/session_persistence.ml#L136)

<a id="function-function-miniquake2-runtime-session-persistence-saveserversession-function-saveserversession-server-gamepath-levelpath-src-miniquake2-runtime-session-persistence-ml-336408567"></a>
### saveServerSession

```ml
function saveServerSession(server, gamePath, levelPath)
```

Save server session.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `server` | `dynamic` | — | server value consumed by this operation. |
| `gamePath` | `dynamic` | — | Path associated with game. |
| `levelPath` | `dynamic` | — | Path associated with level. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/session_persistence.ml#L119)

- [miniquake2.runtime.session_persistence.SessionCheckpoint](Type-miniquake2-runtime-session-persistence-sessioncheckpoint-1608018511.md) — struct
- [miniquake2.runtime.session_persistence.SessionRestoreResult](Type-miniquake2-runtime-session-persistence-sessionrestoreresult-1162042832.md) — struct
<a id="function-function-miniquake2-runtime-session-persistence-synchronizerestoredserver-function-synchronizerestoredserver-server-src-miniquake2-runtime-session-persistence-ml-1411970851"></a>
### synchronizeRestoredServer

```ml
function synchronizeRestoredServer(server)
```

Synchronize restored server.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `server` | `dynamic` | — | server value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/session_persistence.ml#L102)

<a id="function-function-miniquake2-runtime-session-persistence-targetmapfailure-function-targetmapfailure-session-rollbackcheckpoint-rollbackentitytext-rollbackcollision-maximumsteps-failure-src-miniquake2-runtime-session-persistence-ml-912467671"></a>
### targetMapFailure

```ml
function targetMapFailure(session, rollbackCheckpoint, rollbackEntityText, rollbackCollision, maximumSteps, failure)
```

Map target failure.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `session` | `dynamic` | — | session value consumed by this operation. |
| `rollbackCheckpoint` | `dynamic` | — | rollbackCheckpoint value consumed by this operation. |
| `rollbackEntityText` | `dynamic` | — | rollbackEntityText value consumed by this operation. |
| `rollbackCollision` | `dynamic` | — | rollbackCollision value consumed by this operation. |
| `maximumSteps` | `dynamic` | — | maximumSteps value consumed by this operation. |
| `failure` | `dynamic` | — | failure value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/session_persistence.ml#L437)

<a id="function-function-miniquake2-runtime-session-persistence-validatecrossmapplay-function-validatecrossmapplay-session-checkpoint-maximumsteps-src-miniquake2-runtime-session-persistence-ml-571678091"></a>
### validateCrossMapPlay

```ml
function validateCrossMapPlay(session, checkpoint, maximumSteps)
```

Validate cross map play.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `session` | `dynamic` | — | session value consumed by this operation. |
| `checkpoint` | `dynamic` | — | checkpoint value consumed by this operation. |
| `maximumSteps` | `dynamic` | — | maximumSteps value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/session_persistence.ml#L483)

<a id="function-function-miniquake2-runtime-session-persistence-validatepaths-function-validatepaths-gamepath-levelpath-src-miniquake2-runtime-session-persistence-ml-1313981084"></a>
### validatePaths

```ml
function validatePaths(gamePath, levelPath)
```

Validate paths.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `gamePath` | `dynamic` | — | Path associated with game. |
| `levelPath` | `dynamic` | — | Path associated with level. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/session_persistence.ml#L71)
