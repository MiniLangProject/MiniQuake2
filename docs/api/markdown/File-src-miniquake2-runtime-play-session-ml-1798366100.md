# `src/miniquake2/runtime/play_session.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 runtime play session facilities for this project.

Package: [`miniquake2.runtime.play_session`](Package-miniquake2-runtime-play-session-749206800.md)

Reachable from entry: **yes**

## Imports

- `miniquake2/client/prediction.ml` as `plprediction` → [src/miniquake2/client/prediction.ml](File-src-miniquake2-client-prediction-ml-2147101369.md)
- `miniquake2/client/runtime/handoff.ml` as `plhandoff` → [src/miniquake2/client/runtime/handoff.ml](File-src-miniquake2-client-runtime-handoff-ml-1879961007.md)
- `miniquake2/client/state.ml` as `plstate` → [src/miniquake2/client/state.ml](File-src-miniquake2-client-state-ml-1458406995.md)
- `miniquake2/network/constants.ml` as `plnc` → [src/miniquake2/network/constants.ml](File-src-miniquake2-network-constants-ml-102415622.md)
- `miniquake2/platform/system.ml` as `plsystem` → [src/miniquake2/platform/system.ml](File-src-miniquake2-platform-system-ml-74223645.md)
- `miniquake2/qcommon/byteio.ml` as `plbyteio` → [src/miniquake2/qcommon/byteio.ml](File-src-miniquake2-qcommon-byteio-ml-159119335.md)
- `miniquake2/qcommon/constants.ml` as `plqc` → [src/miniquake2/qcommon/constants.ml](File-src-miniquake2-qcommon-constants-ml-1976195726.md)
- `miniquake2/runtime/client_session.ml` as `plclient` → [src/miniquake2/runtime/client_session.ml](File-src-miniquake2-runtime-client-session-ml-1072602311.md)
- `miniquake2/runtime/server_session.ml` as `plserver` → [src/miniquake2/runtime/server_session.ml](File-src-miniquake2-runtime-server-session-ml-1518722291.md)
- `miniquake2/server/game_bridge.ml` as `plbridge` → [src/miniquake2/server/game_bridge.ml](File-src-miniquake2-server-game-bridge-ml-73559214.md)

## Declarations

<a id="function-function-miniquake2-runtime-play-session-changemapcore-function-changemapcore-session-mapname-entitytext-collision-src-miniquake2-runtime-play-session-ml-1774254031"></a>
### changeMapCore

```ml
function changeMapCore(session, mapName, entityText, collision)
```

Performs the changeMapCore operation for the miniquake2 runtime play session module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `session` | `dynamic` | — | session value consumed by this operation. |
| `mapName` | `dynamic` | — | mapName value consumed by this operation. |
| `entityText` | `dynamic` | — | entityText value consumed by this operation. |
| `collision` | `dynamic` | — | collision value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/play_session.ml#L246)

<a id="function-function-miniquake2-runtime-play-session-changemapretail-function-changemapretail-session-basedirectory-mapname-src-miniquake2-runtime-play-session-ml-1591006253"></a>
### changeMapRetail

```ml
function changeMapRetail(session, baseDirectory, mapName)
```

Performs the changeMapRetail operation for the miniquake2 runtime play session module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `session` | `dynamic` | — | session value consumed by this operation. |
| `baseDirectory` | `dynamic` | — | baseDirectory value consumed by this operation. |
| `mapName` | `dynamic` | — | mapName value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/play_session.ml#L255)

<a id="function-function-miniquake2-runtime-play-session-createcore-function-createcore-mapname-entitytext-collision-userinfo-src-miniquake2-runtime-play-session-ml-1470304914"></a>
### createCore

```ml
function createCore(mapName, entityText, collision, userInfo)
```

Creates core for the miniquake2 runtime play session module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `mapName` | `dynamic` | — | mapName value consumed by this operation. |
| `entityText` | `dynamic` | — | entityText value consumed by this operation. |
| `collision` | `dynamic` | — | collision value consumed by this operation. |
| `userInfo` | `dynamic` | — | userInfo value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/play_session.ml#L101)

<a id="function-function-miniquake2-runtime-play-session-createcoreat-function-createcoreat-mapname-entitytext-collision-spawnpoint-userinfo-src-miniquake2-runtime-play-session-ml-1087727889"></a>
### createCoreAt

```ml
function createCoreAt(mapName, entityText, collision, spawnPoint, userInfo)
```

Create core at.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `mapName` | `dynamic` | — | mapName value consumed by this operation. |
| `entityText` | `dynamic` | — | entityText value consumed by this operation. |
| `collision` | `dynamic` | — | collision value consumed by this operation. |
| `spawnPoint` | `dynamic` | — | spawnPoint value consumed by this operation. |
| `userInfo` | `dynamic` | — | userInfo value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/play_session.ml#L112)

<a id="function-function-miniquake2-runtime-play-session-createcoreatskill-function-createcoreatskill-mapname-entitytext-collision-spawnpoint-userinfo-skill-src-miniquake2-runtime-play-session-ml-908611464"></a>
### createCoreAtSkill

```ml
function createCoreAtSkill(mapName, entityText, collision, spawnPoint, userInfo, skill)
```

Creates core at skill for the miniquake2 runtime play session module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `mapName` | `dynamic` | — | mapName value consumed by this operation. |
| `entityText` | `dynamic` | — | entityText value consumed by this operation. |
| `collision` | `dynamic` | — | collision value consumed by this operation. |
| `spawnPoint` | `dynamic` | — | spawnPoint value consumed by this operation. |
| `userInfo` | `dynamic` | — | userInfo value consumed by this operation. |
| `skill` | `dynamic` | — | skill value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/play_session.ml#L125)

<a id="function-function-miniquake2-runtime-play-session-createretail-function-createretail-basedirectory-mapname-userinfo-src-miniquake2-runtime-play-session-ml-1048215100"></a>
### createRetail

```ml
function createRetail(baseDirectory, mapName, userInfo)
```

Creates retail for the miniquake2 runtime play session module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `baseDirectory` | `dynamic` | — | baseDirectory value consumed by this operation. |
| `mapName` | `dynamic` | — | mapName value consumed by this operation. |
| `userInfo` | `dynamic` | — | userInfo value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/play_session.ml#L135)

<a id="function-function-miniquake2-runtime-play-session-createretailat-function-createretailat-basedirectory-mapname-spawnpoint-userinfo-src-miniquake2-runtime-play-session-ml-1793241219"></a>
### createRetailAt

```ml
function createRetailAt(baseDirectory, mapName, spawnPoint, userInfo)
```

Create retail at.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `baseDirectory` | `dynamic` | — | baseDirectory value consumed by this operation. |
| `mapName` | `dynamic` | — | mapName value consumed by this operation. |
| `spawnPoint` | `dynamic` | — | spawnPoint value consumed by this operation. |
| `userInfo` | `dynamic` | — | userInfo value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/play_session.ml#L145)

<a id="function-function-miniquake2-runtime-play-session-createretailatskill-function-createretailatskill-basedirectory-mapname-spawnpoint-userinfo-skill-src-miniquake2-runtime-play-session-ml-236371770"></a>
### createRetailAtSkill

```ml
function createRetailAtSkill(baseDirectory, mapName, spawnPoint, userInfo, skill)
```

Creates retail at skill for the miniquake2 runtime play session module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `baseDirectory` | `dynamic` | — | baseDirectory value consumed by this operation. |
| `mapName` | `dynamic` | — | mapName value consumed by this operation. |
| `spawnPoint` | `dynamic` | — | spawnPoint value consumed by this operation. |
| `userInfo` | `dynamic` | — | userInfo value consumed by this operation. |
| `skill` | `dynamic` | — | skill value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/play_session.ml#L157)

<a id="function-function-miniquake2-runtime-play-session-pendingusercmds-function-pendingusercmds-session-src-miniquake2-runtime-play-session-ml-287213392"></a>
### pendingUserCmds

```ml
function pendingUserCmds(session)
```

Report whether pending user cmds.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `session` | `dynamic` | — | session value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/play_session.ml#L190)

<a id="function-function-miniquake2-runtime-play-session-playpredictionpointcontents-function-playpredictionpointcontents-point-src-miniquake2-runtime-play-session-ml-443598614"></a>
### playPredictionPointContents

```ml
function playPredictionPointContents(point)
```

Play prediction point contents.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `point` | `dynamic` | — | point value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/play_session.ml#L77)

<a id="global-global-miniquake2-runtime-play-session-playpredictionsession-playpredictionsession-src-miniquake2-runtime-play-session-ml-806022182"></a>
### playPredictionSession

```ml
playPredictionSession
```

Stores module-wide play prediction session state for the miniquake2 runtime play session module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/play_session.ml#L58)

<a id="function-function-miniquake2-runtime-play-session-playpredictiontrace-function-playpredictiontrace-start-mins-maxs-finish-src-miniquake2-runtime-play-session-ml-1052836487"></a>
### playPredictionTrace

```ml
function playPredictionTrace(start, mins, maxs, finish)
```

Play prediction trace.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `start` | `dynamic` | — | start value consumed by this operation. |
| `mins` | `dynamic` | — | mins value consumed by this operation. |
| `maxs` | `dynamic` | — | maxs value consumed by this operation. |
| `finish` | `dynamic` | — | finish value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/play_session.ml#L65)

- [miniquake2.runtime.play_session.PlaySession](Type-miniquake2-runtime-play-session-playsession-1471027968.md) — struct
<a id="function-function-miniquake2-runtime-play-session-predictlocal-function-predictlocal-session-previewcommand-src-miniquake2-runtime-play-session-ml-1585495743"></a>
### predictLocal

```ml
function predictLocal(session, previewCommand)
```

Replay the original 64-entry command ring plus a side-effect-free command for the unsent portion of the current render interval. The listen product uses the authoritative collision bridge, including moving inline brushes.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `session` | `dynamic` | — | session value consumed by this operation. |
| `previewCommand` | `dynamic` | — | previewCommand value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/play_session.ml#L209)

<a id="function-function-miniquake2-runtime-play-session-queueusercmd-function-queueusercmd-session-command-src-miniquake2-runtime-play-session-ml-1463085167"></a>
### queueUserCmd

```ml
function queueUserCmd(session, command)
```

Queue user cmd.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `session` | `dynamic` | — | session value consumed by this operation. |
| `command` | `dynamic` | — | command value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/play_session.ml#L175)

<a id="function-function-miniquake2-runtime-play-session-rununtilactive-function-rununtilactive-session-maximumsteps-src-miniquake2-runtime-play-session-ml-755446283"></a>
### runUntilActive

```ml
function runUntilActive(session, maximumSteps)
```

Report whether run until active.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `session` | `dynamic` | — | session value consumed by this operation. |
| `maximumSteps` | `dynamic` | — | maximumSteps value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/play_session.ml#L300)

<a id="function-function-miniquake2-runtime-play-session-setusercmd-function-setusercmd-session-command-src-miniquake2-runtime-play-session-ml-283142871"></a>
### setUserCmd

```ml
function setUserCmd(session, command)
```

Set user cmd.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `session` | `dynamic` | — | session value consumed by this operation. |
| `command` | `dynamic` | — | command value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/play_session.ml#L183)

<a id="function-function-miniquake2-runtime-play-session-setuserinfo-function-setuserinfo-session-userinfo-src-miniquake2-runtime-play-session-ml-294410959"></a>
### setUserInfo

```ml
function setUserInfo(session, userInfo)
```

Set user info.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `session` | `dynamic` | — | session value consumed by this operation. |
| `userInfo` | `dynamic` | — | userInfo value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/play_session.ml#L198)

<a id="function-function-miniquake2-runtime-play-session-shutdown-function-shutdown-session-src-miniquake2-runtime-play-session-ml-125122614"></a>
### shutdown

```ml
function shutdown(session)
```

Performs the shutdown operation for the miniquake2 runtime play session module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `session` | `dynamic` | — | session value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/play_session.ml#L315)

<a id="function-function-miniquake2-runtime-play-session-signoncomplete-function-signoncomplete-session-src-miniquake2-runtime-play-session-ml-688265682"></a>
### signonComplete

```ml
function signonComplete(session)
```

Return the signon complete value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `session` | `dynamic` | — | session value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/play_session.ml#L165)

<a id="function-function-miniquake2-runtime-play-session-step-function-step-session-src-miniquake2-runtime-play-session-ml-1777484126"></a>
### step

```ml
function step(session)
```

Performs the step operation for the miniquake2 runtime play session module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `session` | `dynamic` | — | session value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/play_session.ml#L262)

- [miniquake2.runtime.play_session.StepResult](Type-miniquake2-runtime-play-session-stepresult-1869154785.md) — struct
<a id="function-function-miniquake2-runtime-play-session-takeframe-function-takeframe-session-src-miniquake2-runtime-play-session-ml-60725666"></a>
### takeFrame

```ml
function takeFrame(session)
```

Consume frame.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `session` | `dynamic` | — | session value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/play_session.ml#L285)

<a id="function-function-miniquake2-runtime-play-session-takelatestframe-function-takelatestframe-session-src-miniquake2-runtime-play-session-ml-88411324"></a>
### takeLatestFrame

```ml
function takeLatestFrame(session)
```

Consume latest frame.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `session` | `dynamic` | — | session value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/play_session.ml#L292)

<a id="function-function-miniquake2-runtime-play-session-wrap-function-wrap-server-userinfo-src-miniquake2-runtime-play-session-ml-689306078"></a>
### wrap

```ml
function wrap(server, userInfo)
```

Wrap state.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `server` | `dynamic` | — | server value consumed by this operation. |
| `userInfo` | `dynamic` | — | userInfo value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/play_session.ml#L86)
