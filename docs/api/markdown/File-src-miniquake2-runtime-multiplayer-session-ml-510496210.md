# `src/miniquake2/runtime/multiplayer_session.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 runtime multiplayer session facilities for this project.

Package: [`miniquake2.runtime.multiplayer_session`](Package-miniquake2-runtime-multiplayer-session-807834776.md)

Reachable from entry: **yes**

## Imports

- `miniquake2/game/integration/baseq2.ml` as `mpsbaseq2` → [src/miniquake2/game/integration/baseq2.ml](File-src-miniquake2-game-integration-baseq2-ml-2026578472.md)
- `miniquake2/game/null_game.ml` as `mpsgameapi` → [src/miniquake2/game/null_game.ml](File-src-miniquake2-game-null-game-ml-1916269379.md)
- `miniquake2/network/constants.ml` as `mpsnetworkconstants` → [src/miniquake2/network/constants.ml](File-src-miniquake2-network-constants-ml-102415622.md)
- `miniquake2/platform/system.ml` as `mpsplatformsystem` → [src/miniquake2/platform/system.ml](File-src-miniquake2-platform-system-ml-74223645.md)
- `miniquake2/qcommon/byteio.ml` as `mpsbyteio` → [src/miniquake2/qcommon/byteio.ml](File-src-miniquake2-qcommon-byteio-ml-159119335.md)
- `miniquake2/qcommon/types.ml` as `mpsqtypes` → [src/miniquake2/qcommon/types.ml](File-src-miniquake2-qcommon-types-ml-1663266398.md)
- `miniquake2/runtime/client_session.ml` as `mpsclientsession` → [src/miniquake2/runtime/client_session.ml](File-src-miniquake2-runtime-client-session-ml-1072602311.md)
- `miniquake2/runtime/media_sequence.ml` as `mpsmediasequence` → [src/miniquake2/runtime/media_sequence.ml](File-src-miniquake2-runtime-media-sequence-ml-1280544663.md)
- `miniquake2/runtime/server_session.ml` as `mpsserversession` → [src/miniquake2/runtime/server_session.ml](File-src-miniquake2-runtime-server-session-ml-1518722291.md)

## Declarations

<a id="function-function-miniquake2-runtime-multiplayer-session-activeclients-function-activeclients-session-src-miniquake2-runtime-multiplayer-session-ml-439243180"></a>
### activeClients

```ml
function activeClients(session)
```

Report whether active clients.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `session` | `dynamic` | — | session value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/multiplayer_session.ml#L220)

<a id="function-function-miniquake2-runtime-multiplayer-session-changemapcore-function-changemapcore-session-mapname-entitytext-collision-maximumsteps-src-miniquake2-runtime-multiplayer-session-ml-358920432"></a>
### changeMapCore

```ml
function changeMapCore(session, mapName, entityText, collision, maximumSteps)
```

Performs the changeMapCore operation for the miniquake2 runtime multiplayer session module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `session` | `dynamic` | — | session value consumed by this operation. |
| `mapName` | `dynamic` | — | mapName value consumed by this operation. |
| `entityText` | `dynamic` | — | entityText value consumed by this operation. |
| `collision` | `dynamic` | — | collision value consumed by this operation. |
| `maximumSteps` | `dynamic` | — | maximumSteps value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/multiplayer_session.ml#L361)

<a id="function-function-miniquake2-runtime-multiplayer-session-changemapretail-function-changemapretail-session-basedirectory-mapname-maximumsteps-src-miniquake2-runtime-multiplayer-session-ml-968279190"></a>
### changeMapRetail

```ml
function changeMapRetail(session, baseDirectory, mapName, maximumSteps)
```

Performs the changeMapRetail operation for the miniquake2 runtime multiplayer session module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `session` | `dynamic` | — | session value consumed by this operation. |
| `baseDirectory` | `dynamic` | — | baseDirectory value consumed by this operation. |
| `mapName` | `dynamic` | — | mapName value consumed by this operation. |
| `maximumSteps` | `dynamic` | — | maximumSteps value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/multiplayer_session.ml#L389)

<a id="function-function-miniquake2-runtime-multiplayer-session-checkedclientindex-function-checkedclientindex-session-clientindex-operation-src-miniquake2-runtime-multiplayer-session-ml-430363382"></a>
### checkedClientIndex

```ml
function checkedClientIndex(session, clientIndex, operation)
```

Return the checked client index.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `session` | `dynamic` | — | session value consumed by this operation. |
| `clientIndex` | `dynamic` | — | Zero-based index of client. |
| `operation` | `dynamic` | — | operation value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/multiplayer_session.ml#L171)

<a id="function-function-miniquake2-runtime-multiplayer-session-createcore-function-createcore-mode-mapname-entitytext-collision-userinfos-src-miniquake2-runtime-multiplayer-session-ml-50573672"></a>
### createCore

```ml
function createCore(mode, mapName, entityText, collision, userInfos)
```

Creates core for the miniquake2 runtime multiplayer session module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `mode` | `dynamic` | — | Mode selecting the requested behavior. |
| `mapName` | `dynamic` | — | mapName value consumed by this operation. |
| `entityText` | `dynamic` | — | entityText value consumed by this operation. |
| `collision` | `dynamic` | — | collision value consumed by this operation. |
| `userInfos` | `dynamic` | — | userInfos value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/multiplayer_session.ml#L119)

<a id="function-function-miniquake2-runtime-multiplayer-session-createcoreatskill-function-createcoreatskill-mode-mapname-entitytext-collision-userinfos-skill-src-miniquake2-runtime-multiplayer-session-ml-2032701733"></a>
### createCoreAtSkill

```ml
function createCoreAtSkill(mode, mapName, entityText, collision, userInfos, skill)
```

Creates core at skill for the miniquake2 runtime multiplayer session module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `mode` | `dynamic` | — | Mode selecting the requested behavior. |
| `mapName` | `dynamic` | — | mapName value consumed by this operation. |
| `entityText` | `dynamic` | — | entityText value consumed by this operation. |
| `collision` | `dynamic` | — | collision value consumed by this operation. |
| `userInfos` | `dynamic` | — | userInfos value consumed by this operation. |
| `skill` | `dynamic` | — | skill value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/multiplayer_session.ml#L130)

<a id="function-function-miniquake2-runtime-multiplayer-session-createretail-function-createretail-mode-basedirectory-mapname-userinfos-src-miniquake2-runtime-multiplayer-session-ml-330529334"></a>
### createRetail

```ml
function createRetail(mode, baseDirectory, mapName, userInfos)
```

Creates retail for the miniquake2 runtime multiplayer session module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `mode` | `dynamic` | — | Mode selecting the requested behavior. |
| `baseDirectory` | `dynamic` | — | baseDirectory value consumed by this operation. |
| `mapName` | `dynamic` | — | mapName value consumed by this operation. |
| `userInfos` | `dynamic` | — | userInfos value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/multiplayer_session.ml#L146)

<a id="function-function-miniquake2-runtime-multiplayer-session-createretailatskill-function-createretailatskill-mode-basedirectory-mapname-userinfos-skill-src-miniquake2-runtime-multiplayer-session-ml-165776959"></a>
### createRetailAtSkill

```ml
function createRetailAtSkill(mode, baseDirectory, mapName, userInfos, skill)
```

Creates retail at skill for the miniquake2 runtime multiplayer session module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `mode` | `dynamic` | — | Mode selecting the requested behavior. |
| `baseDirectory` | `dynamic` | — | baseDirectory value consumed by this operation. |
| `mapName` | `dynamic` | — | mapName value consumed by this operation. |
| `userInfos` | `dynamic` | — | userInfos value consumed by this operation. |
| `skill` | `dynamic` | — | skill value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/multiplayer_session.ml#L156)

<a id="function-function-miniquake2-runtime-multiplayer-session-disconnectclient-function-disconnectclient-session-clientindex-src-miniquake2-runtime-multiplayer-session-ml-602303647"></a>
### disconnectClient

```ml
function disconnectClient(session, clientIndex)
```

Return the disconnect client value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `session` | `dynamic` | — | session value consumed by this operation. |
| `clientIndex` | `dynamic` | — | Zero-based index of client. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/multiplayer_session.ml#L514)

<a id="constant-constant-miniquake2-runtime-multiplayer-session-max-client-count-const-max-client-count-8-src-miniquake2-runtime-multiplayer-session-ml-362440569"></a>
### MAX_CLIENT_COUNT

```ml
const MAX_CLIENT_COUNT = 8
```

Defines the max client count constant used by the miniquake2 runtime multiplayer session module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/multiplayer_session.ml#L27)

<a id="constant-constant-miniquake2-runtime-multiplayer-session-min-client-count-const-min-client-count-2-src-miniquake2-runtime-multiplayer-session-ml-1456196187"></a>
### MIN_CLIENT_COUNT

```ml
const MIN_CLIENT_COUNT = 2
```

Defines the min client count constant used by the miniquake2 runtime multiplayer session module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/multiplayer_session.ml#L25)

<a id="constant-constant-miniquake2-runtime-multiplayer-session-mode-coop-const-mode-coop-coop-src-miniquake2-runtime-multiplayer-session-ml-1286553928"></a>
### MODE_COOP

```ml
const MODE_COOP = "coop"
```

Defines the mode coop constant used by the miniquake2 runtime multiplayer session module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/multiplayer_session.ml#L23)

<a id="constant-constant-miniquake2-runtime-multiplayer-session-mode-deathmatch-const-mode-deathmatch-deathmatch-src-miniquake2-runtime-multiplayer-session-ml-1407050650"></a>
### MODE_DEATHMATCH

```ml
const MODE_DEATHMATCH = "deathmatch"
```

Defines the mode deathmatch constant used by the miniquake2 runtime multiplayer session module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/multiplayer_session.ml#L21)

- [miniquake2.runtime.multiplayer_session.MultiplayerSession](Type-miniquake2-runtime-multiplayer-session-multiplayersession-233331990.md) — struct
- [miniquake2.runtime.multiplayer_session.MultiplayerStepResult](Type-miniquake2-runtime-multiplayer-session-multiplayerstepresult-866999593.md) — struct
<a id="function-function-miniquake2-runtime-multiplayer-session-player-function-player-session-clientindex-src-miniquake2-runtime-multiplayer-session-ml-471910315"></a>
### player

```ml
function player(session, clientIndex)
```

Return the player value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `session` | `dynamic` | — | session value consumed by this operation. |
| `clientIndex` | `dynamic` | — | Zero-based index of client. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/multiplayer_session.ml#L195)

<a id="function-function-miniquake2-runtime-multiplayer-session-preparecombatpair-function-preparecombatpair-session-attackerindex-victimindex-distance-src-miniquake2-runtime-multiplayer-session-ml-542838490"></a>
### prepareCombatPair

```ml
function prepareCombatPair(session, attackerIndex, victimIndex, distance)
```

Test/product harness helper only establishes a deterministic unobstructed duel.  It never invokes combat/death code: damage must arrive through the normal client UserCmd -> WeaponThink -> weapon trace/projectile callbacks.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `session` | `dynamic` | — | session value consumed by this operation. |
| `attackerIndex` | `dynamic` | — | Zero-based index of attacker. |
| `victimIndex` | `dynamic` | — | Zero-based index of victim. |
| `distance` | `dynamic` | — | distance value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/multiplayer_session.ml#L433)

<a id="function-function-miniquake2-runtime-multiplayer-session-preparecooppair-function-preparecooppair-session-attackerindex-victimindex-distance-src-miniquake2-runtime-multiplayer-session-ml-1885655888"></a>
### prepareCoopPair

```ml
function prepareCoopPair(session, attackerIndex, victimIndex, distance)
```

Prepare coop pair.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `session` | `dynamic` | — | session value consumed by this operation. |
| `attackerIndex` | `dynamic` | — | Zero-based index of attacker. |
| `victimIndex` | `dynamic` | — | Zero-based index of victim. |
| `distance` | `dynamic` | — | distance value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/multiplayer_session.ml#L490)

<a id="function-function-miniquake2-runtime-multiplayer-session-prepareduel-function-prepareduel-session-attackerindex-victimindex-distance-src-miniquake2-runtime-multiplayer-session-ml-1016135346"></a>
### prepareDuel

```ml
function prepareDuel(session, attackerIndex, victimIndex, distance)
```

Prepare duel.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `session` | `dynamic` | — | session value consumed by this operation. |
| `attackerIndex` | `dynamic` | — | Zero-based index of attacker. |
| `victimIndex` | `dynamic` | — | Zero-based index of victim. |
| `distance` | `dynamic` | — | distance value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/multiplayer_session.ml#L480)

<a id="function-function-miniquake2-runtime-multiplayer-session-queueusercmd-function-queueusercmd-session-clientindex-command-src-miniquake2-runtime-multiplayer-session-ml-2098525026"></a>
### queueUserCmd

```ml
function queueUserCmd(session, clientIndex, command)
```

Queue user cmd.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `session` | `dynamic` | — | session value consumed by this operation. |
| `clientIndex` | `dynamic` | — | Zero-based index of client. |
| `command` | `dynamic` | — | command value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/multiplayer_session.ml#L317)

<a id="function-function-miniquake2-runtime-multiplayer-session-reconnectclient-function-reconnectclient-session-clientindex-userinfo-src-miniquake2-runtime-multiplayer-session-ml-840408266"></a>
### reconnectClient

```ml
function reconnectClient(session, clientIndex, userInfo)
```

Return the reconnect client value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `session` | `dynamic` | — | session value consumed by this operation. |
| `clientIndex` | `dynamic` | — | Zero-based index of client. |
| `userInfo` | `dynamic` | — | userInfo value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/multiplayer_session.ml#L547)

<a id="function-function-miniquake2-runtime-multiplayer-session-result-function-result-session-src-miniquake2-runtime-multiplayer-session-ml-563845464"></a>
### result

```ml
function result(session)
```

Performs the result operation for the miniquake2 runtime multiplayer session module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `session` | `dynamic` | — | session value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/multiplayer_session.ml#L247)

<a id="function-function-miniquake2-runtime-multiplayer-session-rununtilactive-function-rununtilactive-session-maximumsteps-src-miniquake2-runtime-multiplayer-session-ml-1025472635"></a>
### runUntilActive

```ml
function runUntilActive(session, maximumSteps)
```

Report whether run until active.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `session` | `dynamic` | — | session value consumed by this operation. |
| `maximumSteps` | `dynamic` | — | maximumSteps value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/multiplayer_session.ml#L298)

<a id="function-function-miniquake2-runtime-multiplayer-session-serverslot-function-serverslot-session-clientindex-src-miniquake2-runtime-multiplayer-session-ml-248167039"></a>
### serverSlot

```ml
function serverSlot(session, clientIndex)
```

Return the server slot value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `session` | `dynamic` | — | session value consumed by this operation. |
| `clientIndex` | `dynamic` | — | Zero-based index of client. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/multiplayer_session.ml#L182)

<a id="function-function-miniquake2-runtime-multiplayer-session-setuserinfo-function-setuserinfo-session-clientindex-userinfo-src-miniquake2-runtime-multiplayer-session-ml-58281448"></a>
### setUserInfo

```ml
function setUserInfo(session, clientIndex, userInfo)
```

Set user info.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `session` | `dynamic` | — | session value consumed by this operation. |
| `clientIndex` | `dynamic` | — | Zero-based index of client. |
| `userInfo` | `dynamic` | — | userInfo value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/multiplayer_session.ml#L328)

<a id="function-function-miniquake2-runtime-multiplayer-session-shutdown-function-shutdown-session-src-miniquake2-runtime-multiplayer-session-ml-208075652"></a>
### shutdown

```ml
function shutdown(session)
```

Performs the shutdown operation for the miniquake2 runtime multiplayer session module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `session` | `dynamic` | — | session value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/multiplayer_session.ml#L562)

<a id="function-function-miniquake2-runtime-multiplayer-session-signoncomplete-function-signoncomplete-session-src-miniquake2-runtime-multiplayer-session-ml-1445197792"></a>
### signonComplete

```ml
function signonComplete(session)
```

Return the signon complete value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `session` | `dynamic` | — | session value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/multiplayer_session.ml#L241)

<a id="function-function-miniquake2-runtime-multiplayer-session-snapshothasentity-function-snapshothasentity-session-clientindex-entitynumber-src-miniquake2-runtime-multiplayer-session-ml-1033097311"></a>
### snapshotHasEntity

```ml
function snapshotHasEntity(session, clientIndex, entityNumber)
```

Report whether snapshot has entity.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `session` | `dynamic` | — | session value consumed by this operation. |
| `clientIndex` | `dynamic` | — | Zero-based index of client. |
| `entityNumber` | `dynamic` | — | entityNumber value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/multiplayer_session.ml#L416)

<a id="function-function-miniquake2-runtime-multiplayer-session-step-function-step-session-src-miniquake2-runtime-multiplayer-session-ml-1478591116"></a>
### step

```ml
function step(session)
```

Performs the step operation for the miniquake2 runtime multiplayer session module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `session` | `dynamic` | — | session value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/multiplayer_session.ml#L275)

<a id="function-function-miniquake2-runtime-multiplayer-session-synchronizescores-function-synchronizescores-session-src-miniquake2-runtime-multiplayer-session-ml-800406494"></a>
### synchronizeScores

```ml
function synchronizeScores(session)
```

Synchronize scores.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `session` | `dynamic` | — | session value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/multiplayer_session.ml#L203)

<a id="function-function-miniquake2-runtime-multiplayer-session-takequeuedmap-function-takequeuedmap-session-src-miniquake2-runtime-multiplayer-session-ml-1635739944"></a>
### takeQueuedMap

```ml
function takeQueuedMap(session)
```

Report whether take queued map.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `session` | `dynamic` | — | session value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/multiplayer_session.ml#L349)

<a id="function-function-miniquake2-runtime-multiplayer-session-touchitem-function-touchitem-session-clientindex-classname-src-miniquake2-runtime-multiplayer-session-ml-966431032"></a>
### touchItem

```ml
function touchItem(session, clientIndex, className)
```

Handle item.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `session` | `dynamic` | — | session value consumed by this operation. |
| `clientIndex` | `dynamic` | — | Zero-based index of client. |
| `className` | `dynamic` | — | className value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/multiplayer_session.ml#L499)

<a id="function-function-miniquake2-runtime-multiplayer-session-validatemode-function-validatemode-mode-src-miniquake2-runtime-multiplayer-session-ml-1220639093"></a>
### validateMode

```ml
function validateMode(mode)
```

Validate mode.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `mode` | `dynamic` | — | Mode selecting the requested behavior. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/multiplayer_session.ml#L65)

<a id="function-function-miniquake2-runtime-multiplayer-session-validateuserinfos-function-validateuserinfos-userinfos-src-miniquake2-runtime-multiplayer-session-ml-660915460"></a>
### validateUserInfos

```ml
function validateUserInfos(userInfos)
```

Validate user infos.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `userInfos` | `dynamic` | — | userInfos value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/multiplayer_session.ml#L74)

<a id="function-function-miniquake2-runtime-multiplayer-session-wrap-function-wrap-mode-server-userinfos-src-miniquake2-runtime-multiplayer-session-ml-244648296"></a>
### wrap

```ml
function wrap(mode, server, userInfos)
```

Wrap state.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `mode` | `dynamic` | — | Mode selecting the requested behavior. |
| `server` | `dynamic` | — | server value consumed by this operation. |
| `userInfos` | `dynamic` | — | userInfos value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/multiplayer_session.ml#L93)
