# `src/miniquake2/runtime/client_session.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 runtime client session facilities for this project.

Package: [`miniquake2.runtime.client_session`](Package-miniquake2-runtime-client-session-2029274173.md)

Reachable from entry: **yes**

## Imports

- `miniquake2/client/downloads.ml` as `csdownloads` → [src/miniquake2/client/downloads.ml](File-src-miniquake2-client-downloads-ml-2137413515.md)
- `miniquake2/client/effects/state.ml` as `cseffects` → [src/miniquake2/client/effects/state.ml](File-src-miniquake2-client-effects-state-ml-140719308.md)
- `miniquake2/client/prediction.ml` as `csprediction` → [src/miniquake2/client/prediction.ml](File-src-miniquake2-client-prediction-ml-2147101369.md)
- `miniquake2/client/prediction_world.ml` as `cspredictionworld` → [src/miniquake2/client/prediction_world.ml](File-src-miniquake2-client-prediction-world-ml-1403186180.md)
- `miniquake2/client/runtime/dispatcher.ml` as `csdispatcher` → [src/miniquake2/client/runtime/dispatcher.ml](File-src-miniquake2-client-runtime-dispatcher-ml-506346494.md)
- `miniquake2/client/state.ml` as `csstate` → [src/miniquake2/client/state.ml](File-src-miniquake2-client-state-ml-1458406995.md)
- `miniquake2/network/client.ml` as `csnclient` → [src/miniquake2/network/client.ml](File-src-miniquake2-network-client-ml-1115555876.md)
- `miniquake2/network/constants.ml` as `csnc` → [src/miniquake2/network/constants.ml](File-src-miniquake2-network-constants-ml-102415622.md)
- `miniquake2/network/runtime/commands.ml` as `cscommands` → [src/miniquake2/network/runtime/commands.ml](File-src-miniquake2-network-runtime-commands-ml-1067337840.md)
- `miniquake2/network/runtime/pump.ml` as `cspump` → [src/miniquake2/network/runtime/pump.ml](File-src-miniquake2-network-runtime-pump-ml-890925024.md)
- `miniquake2/network/runtime/transport.ml` as `cstransport` → [src/miniquake2/network/runtime/transport.ml](File-src-miniquake2-network-runtime-transport-ml-1946942007.md)
- `miniquake2/network/runtime/types.ml` as `csnrtypes` → [src/miniquake2/network/runtime/types.ml](File-src-miniquake2-network-runtime-types-ml-1235773127.md)
- `miniquake2/platform/system.ml` as `cssystem` → [src/miniquake2/platform/system.ml](File-src-miniquake2-platform-system-ml-74223645.md)
- `miniquake2/platform/udp.ml` as `csudp` → [src/miniquake2/platform/udp.ml](File-src-miniquake2-platform-udp-ml-357648233.md)
- `miniquake2/protocol/constants.ml` as `cspc` → [src/miniquake2/protocol/constants.ml](File-src-miniquake2-protocol-constants-ml-642349806.md)
- `miniquake2/protocol/netchan.ml` as `cspnetchan` → [src/miniquake2/protocol/netchan.ml](File-src-miniquake2-protocol-netchan-ml-626556964.md)
- `miniquake2/protocol/types.ml` as `cspt` → [src/miniquake2/protocol/types.ml](File-src-miniquake2-protocol-types-ml-736261438.md)
- `miniquake2/qcommon/byteio.ml` as `csqbyteio` → [src/miniquake2/qcommon/byteio.ml](File-src-miniquake2-qcommon-byteio-ml-159119335.md)
- `miniquake2/qcommon/cmd.ml` as `csqcmd` → [src/miniquake2/qcommon/cmd.ml](File-src-miniquake2-qcommon-cmd-ml-1514462021.md)
- `miniquake2/qcommon/constants.ml` as `csqconstants` → [src/miniquake2/qcommon/constants.ml](File-src-miniquake2-qcommon-constants-ml-1976195726.md)
- `miniquake2/qcommon/sizebuf.ml` as `csqsz` → [src/miniquake2/qcommon/sizebuf.ml](File-src-miniquake2-qcommon-sizebuf-ml-1769950759.md)
- `miniquake2/qcommon/types.ml` as `csqtypes` → [src/miniquake2/qcommon/types.ml](File-src-miniquake2-qcommon-types-ml-1663266398.md)

## Declarations

<a id="constant-constant-miniquake2-runtime-client-session-client-command-msec-const-client-command-msec-11-src-miniquake2-runtime-client-session-ml-2131460263"></a>
### CLIENT_COMMAND_MSEC

```ml
const CLIENT_COMMAND_MSEC = 11
```

Defines the client command msec constant used by the miniquake2 runtime client session module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/client_session.ml#L96)

- [miniquake2.runtime.client_session.ClientSession](Type-miniquake2-runtime-client-session-clientsession-1406131014.md) — struct
<a id="constant-constant-miniquake2-runtime-client-session-cmd-backup-const-cmd-backup-64-src-miniquake2-runtime-client-session-ml-1498872467"></a>
### CMD_BACKUP

```ml
const CMD_BACKUP = 64
```

Defines the cmd backup constant used by the miniquake2 runtime client session module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/client_session.ml#L92)

<a id="constant-constant-miniquake2-runtime-client-session-cmd-mask-const-cmd-mask-63-src-miniquake2-runtime-client-session-ml-590710580"></a>
### CMD_MASK

```ml
const CMD_MASK = 63
```

Defines the cmd mask constant used by the miniquake2 runtime client session module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/client_session.ml#L94)

<a id="function-function-miniquake2-runtime-client-session-configuredownloads-function-configuredownloads-session-manager-src-miniquake2-runtime-client-session-ml-930341543"></a>
### configureDownloads

```ml
function configureDownloads(session, manager)
```

Configure downloads.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `session` | `dynamic` | — | session value consumed by this operation. |
| `manager` | `dynamic` | — | manager value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/client_session.ml#L478)

<a id="function-function-miniquake2-runtime-client-session-copyusercmdinto-function-copyusercmdinto-output-command-src-miniquake2-runtime-client-session-ml-193898708"></a>
### copyUserCmdInto

```ml
function copyUserCmdInto(output, command)
```

Populate the copy user cmd destination.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `output` | `dynamic` | — | Output collection or buffer populated by the operation. |
| `command` | `dynamic` | — | command value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/client_session.ml#L168)

<a id="function-function-miniquake2-runtime-client-session-create-function-create-serveraddress-serverport-userinfo-localport-src-miniquake2-runtime-client-session-ml-279781382"></a>
### create

```ml
function create(serverAddress, serverPort, userInfo, localPort)
```

Creates create for the miniquake2 runtime client session module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `serverAddress` | `dynamic` | — | serverAddress value consumed by this operation. |
| `serverPort` | `dynamic` | — | serverPort value consumed by this operation. |
| `userInfo` | `dynamic` | — | userInfo value consumed by this operation. |
| `localPort` | `dynamic` | — | localPort value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/client_session.ml#L134)

<a id="function-function-miniquake2-runtime-client-session-createpredictioncommandscratch-function-createpredictioncommandscratch-src-miniquake2-runtime-client-session-ml-111345328"></a>
### createPredictionCommandScratch

```ml
function createPredictionCommandScratch()
```

Create prediction command scratch.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/client_session.ml#L286)

<a id="function-function-miniquake2-runtime-client-session-fillpredictioncommands-function-fillpredictioncommands-session-previewcommand-output-src-miniquake2-runtime-client-session-ml-532768614"></a>
### fillPredictionCommands

```ml
function fillPredictionCommands(session, previewCommand, output)
```

Allocation-stable form used by the product render loop. History entries are session-owned immutable copies; the preview is consumed synchronously by prediction, which copies each command into its reusable Pmove command.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `session` | `dynamic` | — | session value consumed by this operation. |
| `previewCommand` | `dynamic` | — | previewCommand value consumed by this operation. |
| `output` | `dynamic` | — | Output collection or buffer populated by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/client_session.ml#L296)

<a id="function-function-miniquake2-runtime-client-session-makeoriginscratch-function-makeoriginscratch-count-src-miniquake2-runtime-client-session-ml-201136029"></a>
### makeOriginScratch

```ml
function makeOriginScratch(count)
```

Create origin scratch.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `count` | `dynamic` | — | Number of items or units to process. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/client_session.ml#L119)

<a id="function-function-miniquake2-runtime-client-session-makeusercmdscratch-function-makeusercmdscratch-count-src-miniquake2-runtime-client-session-ml-2113965477"></a>
### makeUserCmdScratch

```ml
function makeUserCmdScratch(count)
```

Create user cmd scratch.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `count` | `dynamic` | — | Number of items or units to process. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/client_session.ml#L107)

<a id="constant-constant-miniquake2-runtime-client-session-max-pending-usercmds-const-max-pending-usercmds-64-src-miniquake2-runtime-client-session-ml-1940711291"></a>
### MAX_PENDING_USERCMDS

```ml
const MAX_PENDING_USERCMDS = 64
```

Defines the max pending usercmds constant used by the miniquake2 runtime client session module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/client_session.ml#L90)

<a id="function-function-miniquake2-runtime-client-session-movementdue-function-movementdue-previoustime-now-src-miniquake2-runtime-client-session-ml-563074868"></a>
### movementDue

```ml
function movementDue(previousTime, now)
```

Return the movement due value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `previousTime` | `dynamic` | — | previousTime value consumed by this operation. |
| `now` | `dynamic` | — | now value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/client_session.ml#L101)

<a id="function-function-miniquake2-runtime-client-session-nextusercmd-function-nextusercmd-session-src-miniquake2-runtime-client-session-ml-504485902"></a>
### nextUserCmd

```ml
function nextUserCmd(session)
```

Return the next user cmd value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `session` | `dynamic` | — | session value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/client_session.ml#L268)

<a id="function-function-miniquake2-runtime-client-session-pendingusercmds-function-pendingusercmds-session-src-miniquake2-runtime-client-session-ml-634248536"></a>
### pendingUserCmds

```ml
function pendingUserCmds(session)
```

Report whether pending user cmds.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `session` | `dynamic` | — | session value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/client_session.ml#L262)

<a id="function-function-miniquake2-runtime-client-session-poll-function-poll-session-src-miniquake2-runtime-client-session-ml-624658990"></a>
### poll

```ml
function poll(session)
```

Receive/ACK/signon half of a listen-server tick without synthesizing a second usercmd for the same UI frame.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `session` | `dynamic` | — | session value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/client_session.ml#L644)

<a id="function-function-miniquake2-runtime-client-session-predictioncommands-function-predictioncommands-session-previewcommand-src-miniquake2-runtime-client-session-ml-1833439359"></a>
### predictionCommands

```ml
function predictionCommands(session, previewCommand)
```

Return exactly the unacknowledged cmd ring followed by the current render preview. Missing pre-active/sign-on sequences are intentionally skipped.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `session` | `dynamic` | — | session value consumed by this operation. |
| `previewCommand` | `dynamic` | — | previewCommand value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/client_session.ml#L327)

<a id="function-function-miniquake2-runtime-client-session-predictionsequence-function-predictionsequence-session-src-miniquake2-runtime-client-session-ml-1226478838"></a>
### predictionSequence

```ml
function predictionSequence(session)
```

Return the prediction sequence value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `session` | `dynamic` | — | session value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/client_session.ml#L360)

<a id="function-function-miniquake2-runtime-client-session-predictremote-function-predictremote-session-previewcommand-collision-src-miniquake2-runtime-client-session-ml-1373983277"></a>
### predictRemote

```ml
function predictRemote(session, previewCommand, collision)
```

CL_PredictMovement for a real remote client: replay the unacknowledged command ring against the locally loaded BSP plus the current packet-entity solids. Listen play may keep using its authoritative Game-API bridge.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `session` | `dynamic` | — | session value consumed by this operation. |
| `previewCommand` | `dynamic` | — | previewCommand value consumed by this operation. |
| `collision` | `dynamic` | — | collision value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/client_session.ml#L401)

<a id="function-function-miniquake2-runtime-client-session-processdownloads-function-processdownloads-session-now-src-miniquake2-runtime-client-session-ml-172810760"></a>
### processDownloads

```ml
function processDownloads(session, now)
```

Process downloads.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `session` | `dynamic` | — | session value consumed by this operation. |
| `now` | `dynamic` | — | now value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/client_session.ml#L576)

<a id="function-function-miniquake2-runtime-client-session-processsignon-function-processsignon-session-now-src-miniquake2-runtime-client-session-ml-1182983854"></a>
### processSignon

```ml
function processSignon(session, now)
```

Process signon.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `session` | `dynamic` | — | session value consumed by this operation. |
| `now` | `dynamic` | — | now value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/client_session.ml#L532)

<a id="function-function-miniquake2-runtime-client-session-pump-function-pump-session-sendmovement-src-miniquake2-runtime-client-session-ml-129118205"></a>
### pump

```ml
function pump(session, sendMovement)
```

Pump state.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `session` | `dynamic` | — | session value consumed by this operation. |
| `sendMovement` | `dynamic` | — | sendMovement value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/client_session.ml#L617)

<a id="function-function-miniquake2-runtime-client-session-queueusercmd-function-queueusercmd-session-command-src-miniquake2-runtime-client-session-ml-1461973661"></a>
### queueUserCmd

```ml
function queueUserCmd(session, command)
```

Queue preserves every input sample. The bounded backlog prevents a paused UI producer from causing unbounded latency when networking resumes.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `session` | `dynamic` | — | session value consumed by this operation. |
| `command` | `dynamic` | — | command value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/client_session.ml#L237)

<a id="function-function-miniquake2-runtime-client-session-reconcileprediction-function-reconcileprediction-session-src-miniquake2-runtime-client-session-ml-910777124"></a>
### reconcilePrediction

```ml
function reconcilePrediction(session)
```

Reconcile prediction.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `session` | `dynamic` | — | session value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/client_session.ml#L382)

<a id="function-function-miniquake2-runtime-client-session-resetmapinput-function-resetmapinput-session-src-miniquake2-runtime-client-session-ml-1791790668"></a>
### resetMapInput

```ml
function resetMapInput(session)
```

Reset map input.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `session` | `dynamic` | — | session value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/client_session.ml#L498)

<a id="function-function-miniquake2-runtime-client-session-resetusercmd-function-resetusercmd-output-msec-src-miniquake2-runtime-client-session-ml-1323113325"></a>
### resetUserCmd

```ml
function resetUserCmd(output, msec)
```

Reset user cmd.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `output` | `dynamic` | — | Output collection or buffer populated by the operation. |
| `msec` | `dynamic` | — | msec value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/client_session.ml#L185)

<a id="function-function-miniquake2-runtime-client-session-run-function-run-session-framelimit-src-miniquake2-runtime-client-session-ml-2030800608"></a>
### run

```ml
function run(session, frameLimit)
```

Runs run for the miniquake2 runtime client session workflow.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `session` | `dynamic` | — | session value consumed by this operation. |
| `frameLimit` | `dynamic` | — | frameLimit value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/client_session.ml#L651)

<a id="function-function-miniquake2-runtime-client-session-sendmove-function-sendmove-session-now-src-miniquake2-runtime-client-session-ml-779520760"></a>
### sendMove

```ml
function sendMove(session, now)
```

Send move.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `session` | `dynamic` | — | session value consumed by this operation. |
| `now` | `dynamic` | — | now value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/client_session.ml#L592)

<a id="function-function-miniquake2-runtime-client-session-sendstringcommand-function-sendstringcommand-session-command-now-src-miniquake2-runtime-client-session-ml-51398913"></a>
### sendStringCommand

```ml
function sendStringCommand(session, command, now)
```

Send string command.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `session` | `dynamic` | — | session value consumed by this operation. |
| `command` | `dynamic` | — | command value consumed by this operation. |
| `now` | `dynamic` | — | now value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/client_session.ml#L442)

<a id="function-function-miniquake2-runtime-client-session-senduserinfo-function-senduserinfo-session-userinfo-now-src-miniquake2-runtime-client-session-ml-1455454465"></a>
### sendUserInfo

```ml
function sendUserInfo(session, userInfo, now)
```

Send user info.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `session` | `dynamic` | — | session value consumed by this operation. |
| `userInfo` | `dynamic` | — | userInfo value consumed by this operation. |
| `now` | `dynamic` | — | now value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/client_session.ml#L460)

<a id="function-function-miniquake2-runtime-client-session-sequencedistance-inline-function-sequencedistance-candidate-base-src-miniquake2-runtime-client-session-ml-2098012097"></a>
### sequenceDistance

```ml
inline function sequenceDistance(candidate, base)
```

Return the sequence distance value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `candidate` | `dynamic` | — | candidate value consumed by this operation. |
| `base` | `dynamic` | — | base value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/client_session.ml#L281)

<a id="function-function-miniquake2-runtime-client-session-setusercmd-function-setusercmd-session-command-src-miniquake2-runtime-client-session-ml-1487152397"></a>
### setUserCmd

```ml
function setUserCmd(session, command)
```

Replace pending samples with the newest command, useful for frame-driven UI where old unsent mouse deltas must not be replayed later.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `session` | `dynamic` | — | session value consumed by this operation. |
| `command` | `dynamic` | — | command value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/client_session.ml#L251)

<a id="function-function-miniquake2-runtime-client-session-shutdown-function-shutdown-session-src-miniquake2-runtime-client-session-ml-736902158"></a>
### shutdown

```ml
function shutdown(session)
```

Performs the shutdown operation for the miniquake2 runtime client session module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `session` | `dynamic` | — | session value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/client_session.ml#L667)

<a id="function-function-miniquake2-runtime-client-session-signoncommand-function-signoncommand-text-src-miniquake2-runtime-client-session-ml-1038325581"></a>
### signonCommand

```ml
function signonCommand(text)
```

Return the signon command value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `text` | `dynamic` | — | Text consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/client_session.ml#L484)

<a id="function-function-miniquake2-runtime-client-session-step-function-step-session-src-miniquake2-runtime-client-session-ml-120330774"></a>
### step

```ml
function step(session)
```

Performs the step operation for the miniquake2 runtime client session module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `session` | `dynamic` | — | session value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/client_session.ml#L637)

<a id="function-function-miniquake2-runtime-client-session-storepredictedorigin-function-storepredictedorigin-session-sequence-fixedorigin-src-miniquake2-runtime-client-session-ml-2112614831"></a>
### storePredictedOrigin

```ml
function storePredictedOrigin(session, sequence, fixedOrigin)
```

Return the store predicted origin.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `session` | `dynamic` | — | session value consumed by this operation. |
| `sequence` | `dynamic` | — | sequence value consumed by this operation. |
| `fixedOrigin` | `dynamic` | — | fixedOrigin value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/client_session.ml#L370)

<a id="function-function-miniquake2-runtime-client-session-synchronizespawncount-function-synchronizespawncount-session-src-miniquake2-runtime-client-session-ml-619194950"></a>
### synchronizeSpawnCount

```ml
function synchronizeSpawnCount(session)
```

Synchronize spawn count.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `session` | `dynamic` | — | session value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/client_session.ml#L520)

<a id="function-function-miniquake2-runtime-client-session-validatedmovement-function-validatedmovement-value-src-miniquake2-runtime-client-session-ml-1854370661"></a>
### validatedMovement

```ml
function validatedMovement(value)
```

Return the validated movement value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/client_session.ml#L154)

<a id="function-function-miniquake2-runtime-client-session-validateusercmd-function-validateusercmd-command-src-miniquake2-runtime-client-session-ml-1753861181"></a>
### validateUserCmd

```ml
function validateUserCmd(command)
```

Validate user cmd.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `command` | `dynamic` | — | command value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/client_session.ml#L229)

<a id="function-function-miniquake2-runtime-client-session-validateusercmdinto-function-validateusercmdinto-output-command-src-miniquake2-runtime-client-session-ml-1600195158"></a>
### validateUserCmdInto

```ml
function validateUserCmdInto(output, command)
```

Populate the validate user cmd destination.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `output` | `dynamic` | — | Output collection or buffer populated by the operation. |
| `command` | `dynamic` | — | command value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/client_session.ml#L196)
