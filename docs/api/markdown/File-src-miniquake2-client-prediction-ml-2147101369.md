# `src/miniquake2/client/prediction.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 client prediction facilities for this project.

Package: [`miniquake2.client.prediction`](Package-miniquake2-client-prediction-318492783.md)

Reachable from entry: **yes**

## Imports

- `miniquake2/physics/pmove.ml` as `cppmove` → [src/miniquake2/physics/pmove.ml](File-src-miniquake2-physics-pmove-ml-117812115.md)
- `miniquake2/physics/types.ml` as `cplocal` → [src/miniquake2/physics/types.ml](File-src-miniquake2-physics-types-ml-1448105699.md)
- `miniquake2/protocol/types.ml` as `cppt` → [src/miniquake2/protocol/types.ml](File-src-miniquake2-protocol-types-ml-736261438.md)
- `miniquake2/qcommon/constants.ml` as `cpqc` → [src/miniquake2/qcommon/constants.ml](File-src-miniquake2-qcommon-constants-ml-1976195726.md)
- `miniquake2/qcommon/types.ml` as `cpqt` → [src/miniquake2/qcommon/types.ml](File-src-miniquake2-qcommon-types-ml-1663266398.md)

## Declarations

<a id="function-function-miniquake2-client-prediction-commandviewangles-function-commandviewangles-playerstate-command-src-miniquake2-client-prediction-ml-100107675"></a>
### commandViewAngles

```ml
function commandViewAngles(playerState, command)
```

The PMF_NO_PREDICTION branch still updates view angles from the current command; only origin replay is disabled. This is the managed equivalent of cl.viewangles + SHORT2ANGLE(delta_angles) in CL_PredictMovement.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `playerState` | `dynamic` | — | playerState value consumed by this operation. |
| `command` | `dynamic` | — | command value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/prediction.ml#L175)

<a id="function-function-miniquake2-client-prediction-copypmovestateinto-function-copypmovestateinto-output-input-src-miniquake2-client-prediction-ml-1750171881"></a>
### copyPmoveStateInto

```ml
function copyPmoveStateInto(output, input)
```

Populate the copy pmove state destination.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `output` | `dynamic` | — | Output collection or buffer populated by the operation. |
| `input` | `dynamic` | — | input value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/prediction.ml#L57)

<a id="function-function-miniquake2-client-prediction-copyusercmdinto-function-copyusercmdinto-output-input-src-miniquake2-client-prediction-ml-1912887793"></a>
### copyUserCmdInto

```ml
function copyUserCmdInto(output, input)
```

Populate the copy user cmd destination.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `output` | `dynamic` | — | Output collection or buffer populated by the operation. |
| `input` | `dynamic` | — | input value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/prediction.ml#L81)

<a id="function-function-miniquake2-client-prediction-createworkspace-function-createworkspace-tracecallback-pointcontentscallback-src-miniquake2-client-prediction-ml-1349879235"></a>
### createWorkspace

```ml
function createWorkspace(traceCallback, pointContentsCallback)
```

Create workspace.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `traceCallback` | `dynamic` | — | traceCallback value consumed by this operation. |
| `pointContentsCallback` | `dynamic` | — | pointContentsCallback value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/prediction.ml#L48)

<a id="function-function-miniquake2-client-prediction-localinputangles-function-localinputangles-playerstate-src-miniquake2-client-prediction-ml-2071072966"></a>
### localInputAngles

```ml
function localInputAngles(playerState)
```

cl.viewangles contains the command-space angles; pmove.delta_angles rotates them into the server-selected spawn/intermission space.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `playerState` | `dynamic` | — | playerState value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/prediction.ml#L151)

- [miniquake2.client.prediction.MovementPrediction](Type-miniquake2-client-prediction-movementprediction-580973495.md) — struct
<a id="function-function-miniquake2-client-prediction-predict-function-predict-playerstate-commands-tracecallback-pointcontentscallback-airacceleration-src-miniquake2-client-prediction-ml-1524073045"></a>
### predict

```ml
function predict(playerState, commands, traceCallback, pointContentsCallback, airAcceleration)
```

Return the predict value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `playerState` | `dynamic` | — | playerState value consumed by this operation. |
| `commands` | `dynamic` | — | commands value consumed by this operation. |
| `traceCallback` | `dynamic` | — | traceCallback value consumed by this operation. |
| `pointContentsCallback` | `dynamic` | — | pointContentsCallback value consumed by this operation. |
| `airAcceleration` | `dynamic` | — | airAcceleration value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/prediction.ml#L199)

<a id="function-function-miniquake2-client-prediction-predictinto-function-predictinto-workspace-playerstate-commands-commandcount-airacceleration-src-miniquake2-client-prediction-ml-1976821089"></a>
### predictInto

```ml
function predictInto(workspace, playerState, commands, commandCount, airAcceleration)
```

Populate the predict destination.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `workspace` | `dynamic` | — | workspace value consumed by this operation. |
| `playerState` | `dynamic` | — | playerState value consumed by this operation. |
| `commands` | `dynamic` | — | commands value consumed by this operation. |
| `commandCount` | `dynamic` | — | Number of command to process. |
| `airAcceleration` | `dynamic` | — | airAcceleration value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/prediction.ml#L105)

<a id="function-function-miniquake2-client-prediction-predictionenabled-function-predictionenabled-playerstate-src-miniquake2-client-prediction-ml-2082300830"></a>
### predictionEnabled

```ml
function predictionEnabled(playerState)
```

Report whether prediction enabled.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `playerState` | `dynamic` | — | playerState value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/prediction.ml#L230)

- [miniquake2.client.prediction.PredictionWorkspace](Type-miniquake2-client-prediction-predictionworkspace-510455755.md) — struct
<a id="function-function-miniquake2-client-prediction-shorttoangle-inline-function-shorttoangle-value-src-miniquake2-client-prediction-ml-27914674"></a>
### shortToAngle

```ml
inline function shortToAngle(value)
```

Performs the shortToAngle operation for the miniquake2 client prediction module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/prediction.ml#L144)

<a id="function-function-miniquake2-client-prediction-signedshort-inline-function-signedshort-value-src-miniquake2-client-prediction-ml-869861596"></a>
### signedShort

```ml
inline function signedShort(value)
```

Return the signed short value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/prediction.ml#L160)
