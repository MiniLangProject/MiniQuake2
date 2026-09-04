# `src/miniquake2/game/ai/core.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 game ai core facilities for this project.

Package: [`miniquake2.game.ai.core`](Package-miniquake2-game-ai-core-750952460.md)

Reachable from entry: **yes**

## Imports

- `miniquake2/game/ai/constants.ml` as `gaiconstants` → [src/miniquake2/game/ai/constants.ml](File-src-miniquake2-game-ai-constants-ml-2069864859.md)
- `miniquake2/game/ai/types.ml` as `gaitypes` → [src/miniquake2/game/ai/types.ml](File-src-miniquake2-game-ai-types-ml-2113011711.md)
- `miniquake2/qcommon/constants.ml` as `gaiqconstants` → [src/miniquake2/qcommon/constants.ml](File-src-miniquake2-qcommon-constants-ml-1976195726.md)
- `miniquake2/qcommon/types.ml` as `gaiqtypes` → [src/miniquake2/qcommon/types.ml](File-src-miniquake2-qcommon-types-ml-1663266398.md)
- `std/math.ml` as `gaimath` → `../MiniLangCompilerML/std/math.ml` — external dependency

## Declarations

<a id="function-function-miniquake2-game-ai-core-actoryaw-function-actoryaw-actor-src-miniquake2-game-ai-core-ml-1872805400"></a>
### actorYaw

```ml
function actorYaw(actor)
```

Return the actor yaw.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/core.ml#L42)

<a id="function-function-miniquake2-game-ai-core-ai-charge-function-ai-charge-actor-distance-context-src-miniquake2-game-ai-core-ml-630502874"></a>
### ai_charge

```ml
function ai_charge(actor, distance, context)
```

Return the ai charge value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `distance` | `dynamic` | — | distance value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/core.ml#L253)

<a id="function-function-miniquake2-game-ai-core-ai-checkattack-function-ai-checkattack-actor-distance-context-src-miniquake2-game-ai-core-ml-17633036"></a>
### ai_checkattack

```ml
function ai_checkattack(actor, distance, context)
```

Return the ai checkattack value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `distance` | `dynamic` | — | distance value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/core.ml#L451)

<a id="function-function-miniquake2-game-ai-core-ai-move-function-ai-move-actor-distance-context-src-miniquake2-game-ai-core-ml-663211716"></a>
### ai_move

```ml
function ai_move(actor, distance, context)
```

Move ai.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `distance` | `dynamic` | — | distance value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/core.ml#L199)

<a id="function-function-miniquake2-game-ai-core-ai-run-function-ai-run-actor-distance-context-src-miniquake2-game-ai-core-ml-1973379292"></a>
### ai_run

```ml
function ai_run(actor, distance, context)
```

Port the stock ai_run pursuit state machine. Lost-sight flags and temporary goals change in stock order so trail markers are consumed at most once.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `distance` | `dynamic` | — | distance value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/core.ml#L527)

<a id="function-function-miniquake2-game-ai-core-ai-run-slide-function-ai-run-slide-actor-distance-context-src-miniquake2-game-ai-core-ml-76172692"></a>
### ai_run_slide

```ml
function ai_run_slide(actor, distance, context)
```

Run ai slide.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `distance` | `dynamic` | — | distance value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/core.ml#L511)

<a id="function-function-miniquake2-game-ai-core-ai-stand-function-ai-stand-actor-distance-context-src-miniquake2-game-ai-core-ml-1857770332"></a>
### ai_stand

```ml
function ai_stand(actor, distance, context)
```

Return the ai stand value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `distance` | `dynamic` | — | distance value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/core.ml#L207)

<a id="function-function-miniquake2-game-ai-core-ai-turn-function-ai-turn-actor-distance-context-src-miniquake2-game-ai-core-ml-631718704"></a>
### ai_turn

```ml
function ai_turn(actor, distance, context)
```

Return the ai turn value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `distance` | `dynamic` | — | distance value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/core.ml#L265)

<a id="function-function-miniquake2-game-ai-core-ai-walk-function-ai-walk-actor-distance-context-src-miniquake2-game-ai-core-ml-1952727516"></a>
### ai_walk

```ml
function ai_walk(actor, distance, context)
```

Return the ai walk value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `distance` | `dynamic` | — | distance value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/core.ml#L239)

<a id="global-global-miniquake2-game-ai-core-airuncoursescratch-airuncoursescratch-src-miniquake2-game-ai-core-ml-1510766041"></a>
### aiRunCourseScratch

```ml
aiRunCourseScratch
```

Stores module-wide ai run course scratch state for the miniquake2 game ai core module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/core.ml#L17)

<a id="function-function-miniquake2-game-ai-core-anglemod-function-anglemod-value-src-miniquake2-game-ai-core-ml-724633428"></a>
### angleMod

```ml
function angleMod(value)
```

Return the angle mod value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/core.ml#L81)

<a id="function-function-miniquake2-game-ai-core-candidatefromcontext-function-candidatefromcontext-actor-context-src-miniquake2-game-ai-core-ml-38931589"></a>
### candidateFromContext

```ml
function candidateFromContext(actor, context)
```

Return the candidate from context.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/core.ml#L333)

<a id="function-function-miniquake2-game-ai-core-changeyaw-function-changeyaw-actor-src-miniquake2-game-ai-core-ml-1788356898"></a>
### ChangeYaw

```ml
function ChangeYaw(actor)
```

Return the change yaw.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/core.ml#L153)

<a id="function-function-miniquake2-game-ai-core-copyorigintoarray-inline-function-copyorigintoarray-target-origin-src-miniquake2-game-ai-core-ml-575684071"></a>
### copyOriginToArray

```ml
inline function copyOriginToArray(target, origin)
```

Copy origin to array.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `target` | `dynamic` | — | target value consumed by this operation. |
| `origin` | `dynamic` | — | origin value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/core.ml#L101)

<a id="function-function-miniquake2-game-ai-core-directionto-function-directionto-first-second-src-miniquake2-game-ai-core-ml-592543223"></a>
### directionTo

```ml
function directionTo(first, second)
```

Return the direction to value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `first` | `dynamic` | — | first value consumed by this operation. |
| `second` | `dynamic` | — | second value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/core.ml#L90)

<a id="function-function-miniquake2-game-ai-core-dispatchattackstate-function-dispatchattackstate-actor-context-enemyyaw-src-miniquake2-game-ai-core-ml-325344412"></a>
### DispatchAttackState

```ml
function DispatchAttackState(actor, context, enemyYaw)
```

Dispatch attack state.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |
| `enemyYaw` | `dynamic` | — | enemyYaw value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/core.ml#L435)

<a id="function-function-miniquake2-game-ai-core-facingideal-function-facingideal-actor-src-miniquake2-game-ai-core-ml-261098578"></a>
### FacingIdeal

```ml
function FacingIdeal(actor)
```

Return the facing ideal value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/core.ml#L274)

<a id="function-function-miniquake2-game-ai-core-findtarget-function-findtarget-actor-context-src-miniquake2-game-ai-core-ml-2010126057"></a>
### FindTarget

```ml
function FindTarget(actor, context)
```

Find target.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/core.ml#L347)

<a id="function-function-miniquake2-game-ai-core-foundtarget-function-foundtarget-actor-context-src-miniquake2-game-ai-core-ml-1306007299"></a>
### FoundTarget

```ml
function FoundTarget(actor, context)
```

Return the found target value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/core.ml#L297)

<a id="function-function-miniquake2-game-ai-core-hunttarget-function-hunttarget-actor-context-src-miniquake2-game-ai-core-ml-564385953"></a>
### HuntTarget

```ml
function HuntTarget(actor, context)
```

Return the hunt target value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/core.ml#L282)

<a id="function-function-miniquake2-game-ai-core-infront-function-infront-first-second-src-miniquake2-game-ai-core-ml-635271459"></a>
### infront

```ml
function infront(first, second)
```

Return the infront value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `first` | `dynamic` | — | first value consumed by this operation. |
| `second` | `dynamic` | — | second value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/core.ml#L133)

<a id="function-function-miniquake2-game-ai-core-m-checkattack-function-m-checkattack-actor-context-enemyrange-src-miniquake2-game-ai-core-ml-1842729076"></a>
### M_CheckAttack

```ml
function M_CheckAttack(actor, context, enemyRange)
```

Validate m attack.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |
| `enemyRange` | `dynamic` | — | enemyRange value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/core.ml#L403)

<a id="function-function-miniquake2-game-ai-core-movetogoal-function-movetogoal-actor-distance-context-src-miniquake2-game-ai-core-ml-1516635048"></a>
### moveToGoal

```ml
function moveToGoal(actor, distance, context)
```

Move to goal.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `distance` | `dynamic` | — | distance value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/core.ml#L187)

<a id="function-function-miniquake2-game-ai-core-pursuitgoal-function-pursuitgoal-actor-src-miniquake2-game-ai-core-ml-2075744850"></a>
### pursuitGoal

```ml
function pursuitGoal(actor)
```

Return the pursuit goal value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/core.ml#L110)

<a id="function-function-miniquake2-game-ai-core-range-function-range-first-second-src-miniquake2-game-ai-core-ml-932896757"></a>
### range

```ml
function range(first, second)
```

Return the range value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `first` | `dynamic` | — | first value consumed by this operation. |
| `second` | `dynamic` | — | second value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/core.ml#L122)

<a id="function-function-miniquake2-game-ai-core-scalartoyaw-inline-function-scalartoyaw-x-y-src-miniquake2-game-ai-core-ml-1714262303"></a>
### scalarToYaw

```ml
inline function scalarToYaw(x, y)
```

Return the scalar to yaw.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `x` | `dynamic` | — | Horizontal coordinate used by the operation. |
| `y` | `dynamic` | — | Vertical coordinate used by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/core.ml#L73)

<a id="function-function-miniquake2-game-ai-core-setactoryaw-function-setactoryaw-actor-value-src-miniquake2-game-ai-core-ml-1116238067"></a>
### setActorYaw

```ml
function setActorYaw(actor, value)
```

Set actor yaw.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/core.ml#L49)

<a id="function-function-miniquake2-game-ai-core-vectorlength-function-vectorlength-value-src-miniquake2-game-ai-core-ml-99103392"></a>
### vectorLength

```ml
function vectorLength(value)
```

Return the vector length.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/core.ml#L58)

<a id="function-function-miniquake2-game-ai-core-vectortoyaw-function-vectortoyaw-value-src-miniquake2-game-ai-core-ml-149295482"></a>
### vectorToYaw

```ml
function vectorToYaw(value)
```

Return the vector to yaw.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/core.ml#L64)

<a id="function-function-miniquake2-game-ai-core-vectorx-function-vectorx-value-src-miniquake2-game-ai-core-ml-894343502"></a>
### vectorX

```ml
function vectorX(value)
```

Return the vector x value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/core.ml#L21)

<a id="function-function-miniquake2-game-ai-core-vectory-function-vectory-value-src-miniquake2-game-ai-core-ml-690470812"></a>
### vectorY

```ml
function vectorY(value)
```

Return the vector y value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/core.ml#L28)

<a id="function-function-miniquake2-game-ai-core-vectorz-function-vectorz-value-src-miniquake2-game-ai-core-ml-1509992070"></a>
### vectorZ

```ml
function vectorZ(value)
```

Return the vector z value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/core.ml#L35)

<a id="function-function-miniquake2-game-ai-core-visible-function-visible-actor-other-context-src-miniquake2-game-ai-core-ml-583377309"></a>
### visible

```ml
function visible(actor, other, context)
```

Report whether visible.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `other` | `dynamic` | — | other value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/core.ml#L146)

<a id="function-function-miniquake2-game-ai-core-walkmove-function-walkmove-actor-yaw-distance-context-src-miniquake2-game-ai-core-ml-265224283"></a>
### walkMove

```ml
function walkMove(actor, yaw, distance, context)
```

Move walk.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `yaw` | `dynamic` | — | yaw value consumed by this operation. |
| `distance` | `dynamic` | — | distance value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/core.ml#L170)
