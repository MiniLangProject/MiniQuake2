# `src/miniquake2/client/prediction_world.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 client prediction world facilities for this project.

Package: [`miniquake2.client.prediction_world`](Package-miniquake2-client-prediction-world-509286324.md)

Reachable from entry: **yes**

## Imports

- `miniquake2/client/prediction.ml` as `pwprediction` → [src/miniquake2/client/prediction.ml](File-src-miniquake2-client-prediction-ml-2147101369.md)
- `miniquake2/collision/model.ml` as `pwcollision` → [src/miniquake2/collision/model.ml](File-src-miniquake2-collision-model-ml-265039588.md)
- `miniquake2/physics/vector.ml` as `pwvector` → [src/miniquake2/physics/vector.ml](File-src-miniquake2-physics-vector-ml-1287862571.md)
- `miniquake2/qcommon/constants.ml` as `pwqc` → [src/miniquake2/qcommon/constants.ml](File-src-miniquake2-qcommon-constants-ml-1976195726.md)
- `miniquake2/qcommon/types.ml` as `pwqt` → [src/miniquake2/qcommon/types.ml](File-src-miniquake2-qcommon-types-ml-1663266398.md)

## Declarations

<a id="global-global-miniquake2-client-prediction-world-activepredictionworld-activepredictionworld-src-miniquake2-client-prediction-world-ml-969831668"></a>
### activePredictionWorld

```ml
activePredictionWorld
```

Stores module-wide active prediction world state for the miniquake2 client prediction world module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/prediction_world.ml#L36)

<a id="constant-constant-miniquake2-client-prediction-world-box-epsilon-const-box-epsilon-3-125e-002-src-miniquake2-client-prediction-world-ml-791772202"></a>
### BOX_EPSILON

```ml
const BOX_EPSILON = 3.125e-002
```

Defines the box epsilon constant used by the miniquake2 client prediction world module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/prediction_world.ml#L21)

<a id="function-function-miniquake2-client-prediction-world-boxentitytrace-function-boxentitytrace-start-mins-maxs-finish-entity-src-miniquake2-client-prediction-world-ml-1575806984"></a>
### boxEntityTrace

```ml
function boxEntityTrace(start, mins, maxs, finish, entity)
```

CM_HeadnodeForBox + CM_TransformedBoxTrace, expressed directly as a swept point against the Minkowski-expanded encoded entity bounds. Keep the three slab axes scalar: Pmove calls this for every solid entity and temporary arrays/structs here measurably dominate remote-client prediction.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `start` | `dynamic` | — | start value consumed by this operation. |
| `mins` | `dynamic` | — | mins value consumed by this operation. |
| `maxs` | `dynamic` | — | maxs value consumed by this operation. |
| `finish` | `dynamic` | — | finish value consumed by this operation. |
| `entity` | `dynamic` | — | entity value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/prediction_world.ml#L90)

<a id="function-function-miniquake2-client-prediction-world-collisiontrace-function-collisiontrace-result-entity-src-miniquake2-client-prediction-world-ml-344773500"></a>
### collisionTrace

```ml
function collisionTrace(result, entity)
```

Trace collision.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `result` | `dynamic` | — | Result object populated or inspected by the operation. |
| `entity` | `dynamic` | — | entity value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/prediction_world.ml#L67)

<a id="function-function-miniquake2-client-prediction-world-createpredictionworkspace-function-createpredictionworkspace-src-miniquake2-client-prediction-world-ml-650425826"></a>
### createPredictionWorkspace

```ml
function createPredictionWorkspace()
```

Create prediction workspace.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/prediction_world.ml#L44)

<a id="function-function-miniquake2-client-prediction-world-createworld-function-createworld-src-miniquake2-client-prediction-world-ml-536047926"></a>
### createWorld

```ml
function createWorld()
```

Create world.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/prediction_world.ml#L39)

<a id="function-function-miniquake2-client-prediction-world-dot-inline-function-dot-first-second-src-miniquake2-client-prediction-world-ml-1033246601"></a>
### dot

```ml
inline function dot(first, second)
```

Performs the dot operation for the miniquake2 client prediction world module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `first` | `dynamic` | — | first value consumed by this operation. |
| `second` | `dynamic` | — | second value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/prediction_world.ml#L219)

<a id="function-function-miniquake2-client-prediction-world-emptytrace-function-emptytrace-finish-src-miniquake2-client-prediction-world-ml-524487303"></a>
### emptyTrace

```ml
function emptyTrace(finish)
```

Report whether empty trace.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `finish` | `dynamic` | — | finish value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/prediction_world.ml#L57)

<a id="function-function-miniquake2-client-prediction-world-inlinemodelnumber-function-inlinemodelnumber-world-modelindex-src-miniquake2-client-prediction-world-ml-1166840089"></a>
### inlineModelNumber

```ml
function inlineModelNumber(world, modelIndex)
```

Return the inline model number.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `world` | `dynamic` | — | world value consumed by this operation. |
| `modelIndex` | `dynamic` | — | Zero-based index of model. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/prediction_world.ml#L201)

<a id="function-function-miniquake2-client-prediction-world-mergetrace-function-mergetrace-best-candidate-src-miniquake2-client-prediction-world-ml-110673651"></a>
### mergeTrace

```ml
function mergeTrace(best, candidate)
```

Merge trace.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `best` | `dynamic` | — | best value consumed by this operation. |
| `candidate` | `dynamic` | — | candidate value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/prediction_world.ml#L247)

<a id="function-function-miniquake2-client-prediction-world-normaltoworld-function-normaltoworld-normal-basis-src-miniquake2-client-prediction-world-ml-836807047"></a>
### normalToWorld

```ml
function normalToWorld(normal, basis)
```

Return the normal to world value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `normal` | `dynamic` | — | normal value consumed by this operation. |
| `basis` | `dynamic` | — | basis value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/prediction_world.ml#L237)

<a id="function-function-miniquake2-client-prediction-world-pointcontents-function-pointcontents-world-point-src-miniquake2-client-prediction-world-ml-140695380"></a>
### pointContents

```ml
function pointContents(world, point)
```

Performs the pointContents operation for the miniquake2 client prediction world module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `world` | `dynamic` | — | world value consumed by this operation. |
| `point` | `dynamic` | — | point value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/prediction_world.ml#L325)

<a id="function-function-miniquake2-client-prediction-world-predict-function-predict-playerstate-commands-collision-configstrings-snapshot-localentitynumber-airacceleration-src-miniquake2-client-prediction-world-ml-2036894813"></a>
### predict

```ml
function predict(playerState, commands, collision, configStrings, snapshot, localEntityNumber, airAcceleration)
```

Return the predict value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `playerState` | `dynamic` | — | playerState value consumed by this operation. |
| `commands` | `dynamic` | — | commands value consumed by this operation. |
| `collision` | `dynamic` | — | collision value consumed by this operation. |
| `configStrings` | `dynamic` | — | configStrings value consumed by this operation. |
| `snapshot` | `dynamic` | — | snapshot value consumed by this operation. |
| `localEntityNumber` | `dynamic` | — | localEntityNumber value consumed by this operation. |
| `airAcceleration` | `dynamic` | — | airAcceleration value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/prediction_world.ml#L377)

<a id="function-function-miniquake2-client-prediction-world-predictinto-function-predictinto-world-workspace-playerstate-commands-commandcount-collision-configstrings-snapshot-localentitynumber-airacceleration-src-miniquake2-client-prediction-world-ml-290445368"></a>
### predictInto

```ml
function predictInto(world, workspace, playerState, commands, commandCount, collision, configStrings, snapshot, localEntityNumber, airAcceleration)
```

Session-owned form for the render loop. Both the collision-world wrapper and Pmove workspace retain identity across frames; only their live snapshot references and scalar inputs are updated before synchronous replay.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `world` | `dynamic` | — | world value consumed by this operation. |
| `workspace` | `dynamic` | — | workspace value consumed by this operation. |
| `playerState` | `dynamic` | — | playerState value consumed by this operation. |
| `commands` | `dynamic` | — | commands value consumed by this operation. |
| `commandCount` | `dynamic` | — | Number of command to process. |
| `collision` | `dynamic` | — | collision value consumed by this operation. |
| `configStrings` | `dynamic` | — | configStrings value consumed by this operation. |
| `snapshot` | `dynamic` | — | snapshot value consumed by this operation. |
| `localEntityNumber` | `dynamic` | — | localEntityNumber value consumed by this operation. |
| `airAcceleration` | `dynamic` | — | airAcceleration value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/prediction_world.ml#L407)

<a id="function-function-miniquake2-client-prediction-world-predictionpointcontents-function-predictionpointcontents-point-src-miniquake2-client-prediction-world-ml-1858497006"></a>
### predictionPointContents

```ml
function predictionPointContents(point)
```

Return the prediction point contents value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `point` | `dynamic` | — | point value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/prediction_world.ml#L361)

<a id="function-function-miniquake2-client-prediction-world-predictiontrace-function-predictiontrace-start-mins-maxs-finish-src-miniquake2-client-prediction-world-ml-2137821033"></a>
### predictionTrace

```ml
function predictionTrace(start, mins, maxs, finish)
```

Trace prediction.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `start` | `dynamic` | — | start value consumed by this operation. |
| `mins` | `dynamic` | — | mins value consumed by this operation. |
| `maxs` | `dynamic` | — | maxs value consumed by this operation. |
| `finish` | `dynamic` | — | finish value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/prediction_world.ml#L351)

- [miniquake2.client.prediction_world.PredictionWorld](Type-miniquake2-client-prediction-world-predictionworld-2113261129.md) — struct
<a id="function-function-miniquake2-client-prediction-world-textslice-function-textslice-value-start-count-src-miniquake2-client-prediction-world-ml-481973414"></a>
### textSlice

```ml
function textSlice(value, start, count)
```

Performs the textSlice operation for the miniquake2 client prediction world module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |
| `start` | `dynamic` | — | start value consumed by this operation. |
| `count` | `dynamic` | — | Number of items or units to process. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/prediction_world.ml#L193)

<a id="function-function-miniquake2-client-prediction-world-tomodel-function-tomodel-point-origin-basis-src-miniquake2-client-prediction-world-ml-1771436568"></a>
### toModel

```ml
function toModel(point, origin, basis)
```

Return the to model value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `point` | `dynamic` | — | point value consumed by this operation. |
| `origin` | `dynamic` | — | origin value consumed by this operation. |
| `basis` | `dynamic` | — | basis value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/prediction_world.ml#L227)

<a id="function-function-miniquake2-client-prediction-world-trace-function-trace-world-start-mins-maxs-finish-src-miniquake2-client-prediction-world-ml-398647139"></a>
### trace

```ml
function trace(world, start, mins, maxs, finish)
```

Trace state.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `world` | `dynamic` | — | world value consumed by this operation. |
| `start` | `dynamic` | — | start value consumed by this operation. |
| `mins` | `dynamic` | — | mins value consumed by this operation. |
| `maxs` | `dynamic` | — | maxs value consumed by this operation. |
| `finish` | `dynamic` | — | finish value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/prediction_world.ml#L306)

<a id="function-function-miniquake2-client-prediction-world-traceentities-function-traceentities-world-start-mins-maxs-finish-best-src-miniquake2-client-prediction-world-ml-1251533895"></a>
### traceEntities

```ml
function traceEntities(world, start, mins, maxs, finish, best)
```

Trace entities.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `world` | `dynamic` | — | world value consumed by this operation. |
| `start` | `dynamic` | — | start value consumed by this operation. |
| `mins` | `dynamic` | — | mins value consumed by this operation. |
| `maxs` | `dynamic` | — | maxs value consumed by this operation. |
| `finish` | `dynamic` | — | finish value consumed by this operation. |
| `best` | `dynamic` | — | best value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/prediction_world.ml#L264)

<a id="function-function-miniquake2-client-prediction-world-vec-inline-function-vec-values-src-miniquake2-client-prediction-world-ml-2041901195"></a>
### vec

```ml
inline function vec(values)
```

Return the vec value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `values` | `dynamic` | — | values value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/prediction_world.ml#L51)
