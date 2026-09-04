# `src/miniquake2/physics/pmove.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 physics pmove facilities for this project.

Package: [`miniquake2.physics.pmove`](Package-miniquake2-physics-pmove-1389602199.md)

Reachable from entry: **yes**

## Imports

- `miniquake2/game/constants.ml` as `gc` → [src/miniquake2/game/constants.ml](File-src-miniquake2-game-constants-ml-1723282332.md)
- `miniquake2/game/types.ml` as `gt` → [src/miniquake2/game/types.ml](File-src-miniquake2-game-types-ml-1384205920.md)
- `miniquake2/physics/constants.ml` as `phc` → [src/miniquake2/physics/constants.ml](File-src-miniquake2-physics-constants-ml-205880087.md)
- `miniquake2/physics/types.ml` as `pht` → [src/miniquake2/physics/types.ml](File-src-miniquake2-physics-types-ml-1448105699.md)
- `miniquake2/physics/vector.ml` as `phv` → [src/miniquake2/physics/vector.ml](File-src-miniquake2-physics-vector-ml-1287862571.md)
- `miniquake2/qcommon/byteio.ml` as `qbyteio` → [src/miniquake2/qcommon/byteio.ml](File-src-miniquake2-qcommon-byteio-ml-159119335.md)
- `miniquake2/qcommon/constants.ml` as `qc` → [src/miniquake2/qcommon/constants.ml](File-src-miniquake2-qcommon-constants-ml-1976195726.md)
- `miniquake2/qcommon/types.ml` as `qt` → [src/miniquake2/qcommon/types.ml](File-src-miniquake2-qcommon-types-ml-1663266398.md)

## Declarations

<a id="function-function-miniquake2-physics-pmove-accelerate-function-accelerate-localstate-wishdirection-wishspeed-acceleration-src-miniquake2-physics-pmove-ml-1726822542"></a>
### accelerate

```ml
function accelerate(localState, wishDirection, wishSpeed, acceleration)
```

Return the accelerate value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `localState` | `dynamic` | — | localState value consumed by this operation. |
| `wishDirection` | `dynamic` | — | wishDirection value consumed by this operation. |
| `wishSpeed` | `dynamic` | — | wishSpeed value consumed by this operation. |
| `acceleration` | `dynamic` | — | acceleration value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/physics/pmove.ml#L216)

<a id="function-function-miniquake2-physics-pmove-addcurrents-function-addcurrents-pmove-localstate-wishvelocity-src-miniquake2-physics-pmove-ml-1583036035"></a>
### addCurrents

```ml
function addCurrents(pmove, localState, wishVelocity)
```

Add currents.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `pmove` | `dynamic` | — | pmove value consumed by this operation. |
| `localState` | `dynamic` | — | localState value consumed by this operation. |
| `wishVelocity` | `dynamic` | — | wishVelocity value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/physics/pmove.ml#L247)

<a id="function-function-miniquake2-physics-pmove-addtouch-function-addtouch-pmove-entity-src-miniquake2-physics-pmove-ml-650344144"></a>
### addTouch

```ml
function addTouch(pmove, entity)
```

Add touch.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `pmove` | `dynamic` | — | pmove value consumed by this operation. |
| `entity` | `dynamic` | — | entity value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/physics/pmove.ml#L49)

<a id="function-function-miniquake2-physics-pmove-airaccelerate-function-airaccelerate-localstate-wishdirection-wishspeed-acceleration-src-miniquake2-physics-pmove-ml-1920461832"></a>
### airAccelerate

```ml
function airAccelerate(localState, wishDirection, wishSpeed, acceleration)
```

Return the air accelerate value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `localState` | `dynamic` | — | localState value consumed by this operation. |
| `wishDirection` | `dynamic` | — | wishDirection value consumed by this operation. |
| `wishSpeed` | `dynamic` | — | wishSpeed value consumed by this operation. |
| `acceleration` | `dynamic` | — | acceleration value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/physics/pmove.ml#L231)

<a id="function-function-miniquake2-physics-pmove-airmove-function-airmove-pmove-localstate-airacceleration-src-miniquake2-physics-pmove-ml-640156831"></a>
### airMove

```ml
function airMove(pmove, localState, airAcceleration)
```

Move air.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `pmove` | `dynamic` | — | pmove value consumed by this operation. |
| `localState` | `dynamic` | — | localState value consumed by this operation. |
| `airAcceleration` | `dynamic` | — | airAcceleration value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/physics/pmove.ml#L327)

<a id="function-function-miniquake2-physics-pmove-categorizeposition-function-categorizeposition-pmove-localstate-src-miniquake2-physics-pmove-ml-844544497"></a>
### categorizePosition

```ml
function categorizePosition(pmove, localState)
```

Return the categorize position.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `pmove` | `dynamic` | — | pmove value consumed by this operation. |
| `localState` | `dynamic` | — | localState value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/physics/pmove.ml#L383)

<a id="function-function-miniquake2-physics-pmove-checkduck-function-checkduck-pmove-localstate-src-miniquake2-physics-pmove-ml-93561771"></a>
### checkDuck

```ml
function checkDuck(pmove, localState)
```

Validate duck.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `pmove` | `dynamic` | — | pmove value consumed by this operation. |
| `localState` | `dynamic` | — | localState value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/physics/pmove.ml#L556)

<a id="function-function-miniquake2-physics-pmove-checkjump-function-checkjump-pmove-localstate-src-miniquake2-physics-pmove-ml-44978913"></a>
### checkJump

```ml
function checkJump(pmove, localState)
```

Validate jump.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `pmove` | `dynamic` | — | pmove value consumed by this operation. |
| `localState` | `dynamic` | — | localState value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/physics/pmove.ml#L440)

<a id="function-function-miniquake2-physics-pmove-checkspecialmovement-function-checkspecialmovement-pmove-localstate-src-miniquake2-physics-pmove-ml-134190929"></a>
### checkSpecialMovement

```ml
function checkSpecialMovement(pmove, localState)
```

Validate special movement.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `pmove` | `dynamic` | — | pmove value consumed by this operation. |
| `localState` | `dynamic` | — | localState value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/physics/pmove.ml#L473)

<a id="function-function-miniquake2-physics-pmove-clampangles-function-clampangles-pmove-localstate-src-miniquake2-physics-pmove-ml-719890175"></a>
### clampAngles

```ml
function clampAngles(pmove, localState)
```

Clamp angles.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `pmove` | `dynamic` | — | pmove value consumed by this operation. |
| `localState` | `dynamic` | — | localState value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/physics/pmove.ml#L703)

<a id="function-function-miniquake2-physics-pmove-clipvelocity-function-clipvelocity-inputvelocity-normal-overbounce-src-miniquake2-physics-pmove-ml-1504786976"></a>
### clipVelocity

```ml
function clipVelocity(inputVelocity, normal, overbounce)
```

Clip velocity.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `inputVelocity` | `dynamic` | — | inputVelocity value consumed by this operation. |
| `normal` | `dynamic` | — | normal value consumed by this operation. |
| `overbounce` | `dynamic` | — | overbounce value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/physics/pmove.ml#L33)

<a id="function-function-miniquake2-physics-pmove-create-function-create-tracecallback-pointcontentscallback-src-miniquake2-physics-pmove-ml-1519132587"></a>
### create

```ml
function create(traceCallback, pointContentsCallback)
```

Creates create for the miniquake2 physics pmove module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `traceCallback` | `dynamic` | — | traceCallback value consumed by this operation. |
| `pointContentsCallback` | `dynamic` | — | pointContentsCallback value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/physics/pmove.ml#L25)

<a id="function-function-miniquake2-physics-pmove-deadmove-function-deadmove-pmove-localstate-src-miniquake2-physics-pmove-ml-2084358169"></a>
### deadMove

```ml
function deadMove(pmove, localState)
```

Move dead.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `pmove` | `dynamic` | — | pmove value consumed by this operation. |
| `localState` | `dynamic` | — | localState value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/physics/pmove.ml#L593)

<a id="function-function-miniquake2-physics-pmove-flymove-function-flymove-pmove-localstate-doclip-src-miniquake2-physics-pmove-ml-1278788500"></a>
### flyMove

```ml
function flyMove(pmove, localState, doClip)
```

Move fly.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `pmove` | `dynamic` | — | pmove value consumed by this operation. |
| `localState` | `dynamic` | — | localState value consumed by this operation. |
| `doClip` | `dynamic` | — | doClip value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/physics/pmove.ml#L503)

<a id="function-function-miniquake2-physics-pmove-friction-function-friction-pmove-localstate-src-miniquake2-physics-pmove-ml-1543295377"></a>
### friction

```ml
function friction(pmove, localState)
```

Return the friction value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `pmove` | `dynamic` | — | pmove value consumed by this operation. |
| `localState` | `dynamic` | — | localState value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/physics/pmove.ml#L182)

<a id="function-function-miniquake2-physics-pmove-goodposition-function-goodposition-pmove-src-miniquake2-physics-pmove-ml-2065476697"></a>
### goodPosition

```ml
function goodPosition(pmove)
```

Return the good position.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `pmove` | `dynamic` | — | pmove value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/physics/pmove.ml#L607)

<a id="function-function-miniquake2-physics-pmove-initialsnapposition-function-initialsnapposition-pmove-localstate-src-miniquake2-physics-pmove-ml-1585480035"></a>
### initialSnapPosition

```ml
function initialSnapPosition(pmove, localState)
```

Return the initial snap position.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `pmove` | `dynamic` | — | pmove value consumed by this operation. |
| `localState` | `dynamic` | — | localState value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/physics/pmove.ml#L660)

<a id="function-function-miniquake2-physics-pmove-move-function-move-pmove-src-miniquake2-physics-pmove-ml-436466073"></a>
### move

```ml
function move(pmove)
```

Move state.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `pmove` | `dynamic` | — | pmove value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/physics/pmove.ml#L830)

<a id="function-function-miniquake2-physics-pmove-movewithairacceleration-function-movewithairacceleration-pmove-airacceleration-src-miniquake2-physics-pmove-ml-266502231"></a>
### moveWithAirAcceleration

```ml
function moveWithAirAcceleration(pmove, airAcceleration)
```

Move with air acceleration.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `pmove` | `dynamic` | — | pmove value consumed by this operation. |
| `airAcceleration` | `dynamic` | — | airAcceleration value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/physics/pmove.ml#L823)

<a id="function-function-miniquake2-physics-pmove-movewithairaccelerationusinglocal-function-movewithairaccelerationusinglocal-pmove-airacceleration-localstate-src-miniquake2-physics-pmove-ml-1896458813"></a>
### moveWithAirAccelerationUsingLocal

```ml
function moveWithAirAccelerationUsingLocal(pmove, airAcceleration, localState)
```

The caller-supplied private state makes high-frequency client prediction allocation-stable. Server/game callers retain the owning wrapper below.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `pmove` | `dynamic` | — | pmove value consumed by this operation. |
| `airAcceleration` | `dynamic` | — | airAcceleration value consumed by this operation. |
| `localState` | `dynamic` | — | localState value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/physics/pmove.ml#L731)

<a id="function-function-miniquake2-physics-pmove-shorttoangle-function-shorttoangle-value-src-miniquake2-physics-pmove-ml-2018533217"></a>
### shortToAngle

```ml
function shortToAngle(value)
```

Performs the shortToAngle operation for the miniquake2 physics pmove module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/physics/pmove.ml#L696)

<a id="function-function-miniquake2-physics-pmove-signedshort-function-signedshort-value-src-miniquake2-physics-pmove-ml-216038689"></a>
### signedShort

```ml
function signedShort(value)
```

Return the signed short value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/physics/pmove.ml#L688)

<a id="function-function-miniquake2-physics-pmove-snapposition-function-snapposition-pmove-localstate-src-miniquake2-physics-pmove-ml-435146409"></a>
### snapPosition

```ml
function snapPosition(pmove, localState)
```

Return the snap position.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `pmove` | `dynamic` | — | pmove value consumed by this operation. |
| `localState` | `dynamic` | — | localState value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/physics/pmove.ml#L617)

<a id="function-function-miniquake2-physics-pmove-stepslidemove-function-stepslidemove-pmove-localstate-src-miniquake2-physics-pmove-ml-683603473"></a>
### stepSlideMove

```ml
function stepSlideMove(pmove, localState)
```

Advance slide move.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `pmove` | `dynamic` | — | pmove value consumed by this operation. |
| `localState` | `dynamic` | — | localState value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/physics/pmove.ml#L138)

<a id="function-function-miniquake2-physics-pmove-stepslidemovecore-function-stepslidemovecore-pmove-localstate-src-miniquake2-physics-pmove-ml-311124463"></a>
### stepSlideMoveCore

```ml
function stepSlideMoveCore(pmove, localState)
```

Advance slide move core.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `pmove` | `dynamic` | — | pmove value consumed by this operation. |
| `localState` | `dynamic` | — | localState value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/physics/pmove.ml#L60)

<a id="function-function-miniquake2-physics-pmove-watermove-function-watermove-pmove-localstate-src-miniquake2-physics-pmove-ml-112934945"></a>
### waterMove

```ml
function waterMove(pmove, localState)
```

Move water.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `pmove` | `dynamic` | — | pmove value consumed by this operation. |
| `localState` | `dynamic` | — | localState value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/physics/pmove.ml#L297)
