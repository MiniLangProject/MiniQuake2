# `src/miniquake2/game/ai/move.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 game ai move facilities for this project.

Package: [`miniquake2.game.ai.move`](Package-miniquake2-game-ai-move-155434510.md)

Reachable from entry: **yes**

## Imports

- `miniquake2/game/ai/constants.ml` as `aimoveconstants` → [src/miniquake2/game/ai/constants.ml](File-src-miniquake2-game-ai-constants-ml-2069864859.md)
- `miniquake2/game/ai/core.ml` as `aimovecore` → [src/miniquake2/game/ai/core.ml](File-src-miniquake2-game-ai-core-ml-1671967255.md)
- `miniquake2/qcommon/constants.ml` as `aimoveqconstants` → [src/miniquake2/qcommon/constants.ml](File-src-miniquake2-qcommon-constants-ml-1976195726.md)
- `miniquake2/qcommon/types.ml` as `aimoveqtypes` → [src/miniquake2/qcommon/types.ml](File-src-miniquake2-qcommon-types-ml-1663266398.md)
- `std/math.ml` as `aimovemath` → `../MiniLangCompilerML/std/math.ml` — external dependency

## Declarations

<a id="function-function-miniquake2-game-ai-move-closeenough-function-closeenough-actor-goal-distance-src-miniquake2-game-ai-move-ml-1176952148"></a>
### CloseEnough

```ml
function CloseEnough(actor, goal, distance)
```

Close enough.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `goal` | `dynamic` | — | goal value consumed by this operation. |
| `distance` | `dynamic` | — | distance value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/move.ml#L448)

<a id="function-function-miniquake2-game-ai-move-contentsat-inline-function-contentsat-point-context-src-miniquake2-game-ai-move-ml-536711009"></a>
### contentsAt

```ml
inline function contentsAt(point, context)
```

Return the contents for the requested position.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `point` | `dynamic` | — | point value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/move.ml#L65)

<a id="function-function-miniquake2-game-ai-move-initializeactor-function-initializeactor-actor-context-src-miniquake2-game-ai-move-ml-512497007"></a>
### InitializeActor

```ml
function InitializeActor(actor, context)
```

Initialize actor.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/move.ml#L505)

<a id="function-function-miniquake2-game-ai-move-linkandtouch-inline-function-linkandtouch-actor-context-src-miniquake2-game-ai-move-ml-386264918"></a>
### linkAndTouch

```ml
inline function linkAndTouch(actor, context)
```

Link and touch.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/move.ml#L75)

<a id="function-function-miniquake2-game-ai-move-m-categorizeposition-function-m-categorizeposition-actor-context-src-miniquake2-game-ai-move-ml-1103208265"></a>
### M_CategorizePosition

```ml
function M_CategorizePosition(actor, context)
```

Return the m categorize position.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/move.ml#L191)

<a id="function-function-miniquake2-game-ai-move-m-checkbottom-function-m-checkbottom-actor-context-src-miniquake2-game-ai-move-ml-218783147"></a>
### M_CheckBottom

```ml
function M_CheckBottom(actor, context)
```

Validate m bottom.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/move.ml#L95)

<a id="function-function-miniquake2-game-ai-move-m-checkground-function-m-checkground-actor-context-src-miniquake2-game-ai-move-ml-31790227"></a>
### M_CheckGround

```ml
function M_CheckGround(actor, context)
```

Validate m ground.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/move.ml#L162)

<a id="function-function-miniquake2-game-ai-move-m-droptofloor-function-m-droptofloor-actor-context-src-miniquake2-game-ai-move-ml-1612002585"></a>
### M_DropToFloor

```ml
function M_DropToFloor(actor, context)
```

Drop m to floor.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/move.ml#L216)

<a id="global-global-miniquake2-game-ai-move-movepointscratch-movepointscratch-src-miniquake2-game-ai-move-ml-86820855"></a>
### movePointScratch

```ml
movePointScratch
```

Stores module-wide move point scratch state for the miniquake2 game ai move module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/move.ml#L31)

<a id="function-function-miniquake2-game-ai-move-movestep-function-movestep-actor-movex-movey-movez-relink-context-src-miniquake2-game-ai-move-ml-1449540046"></a>
### MoveStep

```ml
function MoveStep(actor, moveX, moveY, moveZ, relink, context)
```

Apply one stock M_MoveStep attempt without publishing a partial transform. Ground, fly/swim and water branches commit only after their trace checks pass.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `moveX` | `dynamic` | — | moveX value consumed by this operation. |
| `moveY` | `dynamic` | — | moveY value consumed by this operation. |
| `moveZ` | `dynamic` | — | moveZ value consumed by this operation. |
| `relink` | `dynamic` | — | relink value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/move.ml#L241)

<a id="function-function-miniquake2-game-ai-move-movetogoal-function-movetogoal-actor-distance-context-src-miniquake2-game-ai-move-ml-1749247688"></a>
### MoveToGoal

```ml
function MoveToGoal(actor, distance, context)
```

Move to goal.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `distance` | `dynamic` | — | distance value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/move.ml#L470)

<a id="global-global-miniquake2-game-ai-move-movetraceendscratch-movetraceendscratch-src-miniquake2-game-ai-move-ml-16378021"></a>
### moveTraceEndScratch

```ml
moveTraceEndScratch
```

Stores module-wide move trace end scratch state for the miniquake2 game ai move module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/move.ml#L29)

<a id="global-global-miniquake2-game-ai-move-movetracestartscratch-movetracestartscratch-src-miniquake2-game-ai-move-ml-223569309"></a>
### moveTraceStartScratch

```ml
moveTraceStartScratch
```

Stores module-wide move trace start scratch state for the miniquake2 game ai move module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/move.ml#L27)

<a id="global-global-miniquake2-game-ai-move-movezeroscratch-movezeroscratch-src-miniquake2-game-ai-move-ml-2022385481"></a>
### moveZeroScratch

```ml
moveZeroScratch
```

Stores module-wide move zero scratch state for the miniquake2 game ai move module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/move.ml#L33)

<a id="function-function-miniquake2-game-ai-move-newchasedirection-function-newchasedirection-actor-goal-distance-context-src-miniquake2-game-ai-move-ml-1335494827"></a>
### NewChaseDirection

```ml
function NewChaseDirection(actor, goal, distance, context)
```

Return the new chase direction value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `goal` | `dynamic` | — | goal value consumed by this operation. |
| `distance` | `dynamic` | — | distance value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/move.ml#L380)

<a id="constant-constant-miniquake2-game-ai-move-no-direction-const-no-direction-1-src-miniquake2-game-ai-move-ml-231260980"></a>
### NO_DIRECTION

```ml
const NO_DIRECTION = -1.
```

Defines the no direction constant used by the miniquake2 game ai move module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/move.ml#L24)

<a id="function-function-miniquake2-game-ai-move-randominteger-inline-function-randominteger-context-src-miniquake2-game-ai-move-ml-940238309"></a>
### randomInteger

```ml
inline function randomInteger(context)
```

Return the random integer value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `context` | `dynamic` | — | Context that carries state for the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/move.ml#L85)

<a id="function-function-miniquake2-game-ai-move-setorigin-inline-function-setorigin-actor-x-y-z-src-miniquake2-game-ai-move-ml-1689954964"></a>
### setOrigin

```ml
inline function setOrigin(actor, x, y, z)
```

Set origin.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `x` | `dynamic` | — | Horizontal coordinate used by the operation. |
| `y` | `dynamic` | — | Vertical coordinate used by the operation. |
| `z` | `dynamic` | — | z value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/move.ml#L40)

<a id="constant-constant-miniquake2-game-ai-move-step-size-const-step-size-18-src-miniquake2-game-ai-move-ml-1765953943"></a>
### STEP_SIZE

```ml
const STEP_SIZE = 18.
```

Defines the step size constant used by the miniquake2 game ai move module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/move.ml#L22)

<a id="function-function-miniquake2-game-ai-move-stepdirection-function-stepdirection-actor-yaw-distance-context-src-miniquake2-game-ai-move-ml-891046849"></a>
### StepDirection

```ml
function StepDirection(actor, yaw, distance, context)
```

Advance direction.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `yaw` | `dynamic` | — | yaw value consumed by this operation. |
| `distance` | `dynamic` | — | distance value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/move.ml#L357)

<a id="function-function-miniquake2-game-ai-move-tracemove-inline-function-tracemove-actor-start-mins-maxs-finish-context-src-miniquake2-game-ai-move-ml-1376739219"></a>
### traceMove

```ml
inline function traceMove(actor, start, mins, maxs, finish, context)
```

Trace move.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `start` | `dynamic` | — | start value consumed by this operation. |
| `mins` | `dynamic` | — | mins value consumed by this operation. |
| `maxs` | `dynamic` | — | maxs value consumed by this operation. |
| `finish` | `dynamic` | — | finish value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/move.ml#L54)

<a id="function-function-miniquake2-game-ai-move-walkmove-function-walkmove-actor-yaw-distance-context-src-miniquake2-game-ai-move-ml-1767463587"></a>
### WalkMove

```ml
function WalkMove(actor, yaw, distance, context)
```

Move walk.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `yaw` | `dynamic` | — | yaw value consumed by this operation. |
| `distance` | `dynamic` | — | distance value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/move.ml#L492)
