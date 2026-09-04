# `src/miniquake2/client/effects/state.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 client effects state facilities for this project.

Package: [`miniquake2.client.effects.state`](Package-miniquake2-client-effects-state-1439014451.md)

Reachable from entry: **yes**

## Imports

- `miniquake2/client/effects/audio.ml` as `ceaudio` → [src/miniquake2/client/effects/audio.ml](File-src-miniquake2-client-effects-audio-ml-242663153.md)
- `miniquake2/client/effects/constants.ml` as `ceconstants` → [src/miniquake2/client/effects/constants.ml](File-src-miniquake2-client-effects-constants-ml-55259948.md)
- `miniquake2/client/effects/types.ml` as `cetypes` → [src/miniquake2/client/effects/types.ml](File-src-miniquake2-client-effects-types-ml-621918960.md)
- `miniquake2/qcommon/directions.ml` as `cedirections` → [src/miniquake2/qcommon/directions.ml](File-src-miniquake2-qcommon-directions-ml-1980852047.md)
- `miniquake2/qcommon/types.ml` as `qt` → [src/miniquake2/qcommon/types.ml](File-src-miniquake2-qcommon-types-ml-1663266398.md)
- `std/math.ml` as `cemath` → `../MiniLangCompilerML/std/math.ml` — external dependency

## Declarations

<a id="function-function-miniquake2-client-effects-state-add-inline-function-add-first-second-src-miniquake2-client-effects-state-ml-992174676"></a>
### add

```ml
inline function add(first, second)
```

Adds add to the state managed by the miniquake2 client effects state module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `first` | `dynamic` | — | first value consumed by this operation. |
| `second` | `dynamic` | — | second value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/effects/state.ml#L56)

<a id="function-function-miniquake2-client-effects-state-addbeam-function-addbeam-state-entity-destinationentity-modelname-start-finish-offset-playerlinked-duration-src-miniquake2-client-effects-state-ml-470542954"></a>
### addBeam

```ml
function addBeam(state, entity, destinationEntity, modelName, start, finish, offset, playerLinked, duration)
```

Add normal beam.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `destinationEntity` | `dynamic` | — | destinationEntity value consumed by this operation. |
| `modelName` | `dynamic` | — | modelName value consumed by this operation. |
| `start` | `dynamic` | — | start value consumed by this operation. |
| `finish` | `dynamic` | — | finish value consumed by this operation. |
| `offset` | `dynamic` | — | Zero-based offset at which processing starts. |
| `playerLinked` | `dynamic` | — | playerLinked value consumed by this operation. |
| `duration` | `dynamic` | — | duration value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/effects/state.ml#L1155)

<a id="function-function-miniquake2-client-effects-state-addbeamtopool-function-addbeamtopool-state-entity-destinationentity-modelname-start-finish-offset-playerlinked-duration-playerpool-src-miniquake2-client-effects-state-ml-301862847"></a>
### addBeamToPool

```ml
function addBeamToPool(state, entity, destinationEntity, modelName, start, finish, offset, playerLinked, duration, playerPool)
```

Add a beam to the stock normal-beam or player-beam pool.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `destinationEntity` | `dynamic` | — | destinationEntity value consumed by this operation. |
| `modelName` | `dynamic` | — | modelName value consumed by this operation. |
| `start` | `dynamic` | — | start value consumed by this operation. |
| `finish` | `dynamic` | — | finish value consumed by this operation. |
| `offset` | `dynamic` | — | Zero-based offset at which processing starts. |
| `playerLinked` | `dynamic` | — | playerLinked value consumed by this operation. |
| `duration` | `dynamic` | — | duration value consumed by this operation. |
| `playerPool` | `dynamic` | — | playerPool value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/effects/state.ml#L1113)

<a id="function-function-miniquake2-client-effects-state-adddlight-function-adddlight-state-key-origin-radius-color-duration-decay-src-miniquake2-client-effects-state-ml-1063331876"></a>
### addDLight

```ml
function addDLight(state, key, origin, radius, color, duration, decay)
```

Add d light.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |
| `key` | `dynamic` | — | key value consumed by this operation. |
| `origin` | `dynamic` | — | origin value consumed by this operation. |
| `radius` | `dynamic` | — | radius value consumed by this operation. |
| `color` | `dynamic` | — | color value consumed by this operation. |
| `duration` | `dynamic` | — | duration value consumed by this operation. |
| `decay` | `dynamic` | — | decay value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/effects/state.ml#L112)

<a id="function-function-miniquake2-client-effects-state-addexplosion-function-addexplosion-state-kind-origin-modelname-frames-light-lightcolor-flags-alpha-src-miniquake2-client-effects-state-ml-1831471276"></a>
### addExplosion

```ml
function addExplosion(state, kind, origin, modelName, frames, light, lightColor, flags, alpha)
```

Add explosion.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |
| `kind` | `dynamic` | — | kind value consumed by this operation. |
| `origin` | `dynamic` | — | origin value consumed by this operation. |
| `modelName` | `dynamic` | — | modelName value consumed by this operation. |
| `frames` | `dynamic` | — | frames value consumed by this operation. |
| `light` | `dynamic` | — | light value consumed by this operation. |
| `lightColor` | `dynamic` | — | lightColor value consumed by this operation. |
| `flags` | `dynamic` | — | Bit flags controlling the operation. |
| `alpha` | `dynamic` | — | alpha value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/effects/state.ml#L1237)

<a id="function-function-miniquake2-client-effects-state-addexplosionexact-function-addexplosionexact-state-kind-origin-angles-modelname-frames-light-lightcolor-starttime-baseframe-flags-alpha-skinnum-src-miniquake2-client-effects-state-ml-2019649030"></a>
### addExplosionExact

```ml
function addExplosionExact(state, kind, origin, angles, modelName, frames, light, lightColor, startTime, baseFrame, flags, alpha, skinNum)
```

Add explosion exact.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |
| `kind` | `dynamic` | — | kind value consumed by this operation. |
| `origin` | `dynamic` | — | origin value consumed by this operation. |
| `angles` | `dynamic` | — | angles value consumed by this operation. |
| `modelName` | `dynamic` | — | modelName value consumed by this operation. |
| `frames` | `dynamic` | — | frames value consumed by this operation. |
| `light` | `dynamic` | — | light value consumed by this operation. |
| `lightColor` | `dynamic` | — | lightColor value consumed by this operation. |
| `startTime` | `dynamic` | — | startTime value consumed by this operation. |
| `baseFrame` | `dynamic` | — | baseFrame value consumed by this operation. |
| `flags` | `dynamic` | — | Bit flags controlling the operation. |
| `alpha` | `dynamic` | — | alpha value consumed by this operation. |
| `skinNum` | `dynamic` | — | skinNum value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/effects/state.ml#L1201)

<a id="function-function-miniquake2-client-effects-state-addlaser-function-addlaser-state-start-finish-color-src-miniquake2-client-effects-state-ml-1295079908"></a>
### addLaser

```ml
function addLaser(state, start, finish, color)
```

Add laser.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |
| `start` | `dynamic` | — | start value consumed by this operation. |
| `finish` | `dynamic` | — | finish value consumed by this operation. |
| `color` | `dynamic` | — | color value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/effects/state.ml#L1181)

<a id="function-function-miniquake2-client-effects-state-addparticle-function-addparticle-state-origin-velocity-acceleration-color-alpha-alphavelocity-src-miniquake2-client-effects-state-ml-1804144075"></a>
### addParticle

```ml
function addParticle(state, origin, velocity, acceleration, color, alpha, alphaVelocity)
```

Add particle.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |
| `origin` | `dynamic` | — | origin value consumed by this operation. |
| `velocity` | `dynamic` | — | velocity value consumed by this operation. |
| `acceleration` | `dynamic` | — | acceleration value consumed by this operation. |
| `color` | `dynamic` | — | color value consumed by this operation. |
| `alpha` | `dynamic` | — | alpha value consumed by this operation. |
| `alphaVelocity` | `dynamic` | — | alphaVelocity value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/effects/state.ml#L151)

<a id="function-function-miniquake2-client-effects-state-addplayerbeam-function-addplayerbeam-state-entity-modelname-start-finish-offset-playerlinked-duration-src-miniquake2-client-effects-state-ml-1862035945"></a>
### addPlayerBeam

```ml
function addPlayerBeam(state, entity, modelName, start, finish, offset, playerLinked, duration)
```

Add Rogue player beam. Remote players still use this separate reuse pool; playerLinked only controls whether the local camera supplies its origin.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `modelName` | `dynamic` | — | modelName value consumed by this operation. |
| `start` | `dynamic` | — | start value consumed by this operation. |
| `finish` | `dynamic` | — | finish value consumed by this operation. |
| `offset` | `dynamic` | — | Zero-based offset at which processing starts. |
| `playerLinked` | `dynamic` | — | playerLinked value consumed by this operation. |
| `duration` | `dynamic` | — | duration value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/effects/state.ml#L1170)

<a id="function-function-miniquake2-client-effects-state-advance-function-advance-state-now-src-miniquake2-client-effects-state-ml-1812384794"></a>
### advance

```ml
function advance(state, now)
```

Performs the advance operation for the miniquake2 client effects state module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |
| `now` | `dynamic` | — | now value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/effects/state.ml#L1249)

<a id="function-function-miniquake2-client-effects-state-allocatedlight-function-allocatedlight-state-key-src-miniquake2-client-effects-state-ml-482983213"></a>
### allocateDLight

```ml
function allocateDLight(state, key)
```

Allocate d light.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |
| `key` | `dynamic` | — | key value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/effects/state.ml#L85)

<a id="function-function-miniquake2-client-effects-state-bfgparticles-function-bfgparticles-state-origin-src-miniquake2-client-effects-state-ml-128700736"></a>
### bfgParticles

```ml
function bfgParticles(state, origin)
```

Return the bfg particles value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |
| `origin` | `dynamic` | — | origin value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/effects/state.ml#L1011)

<a id="function-function-miniquake2-client-effects-state-bigteleportparticles-function-bigteleportparticles-state-origin-src-miniquake2-client-effects-state-ml-237212924"></a>
### bigTeleportParticles

```ml
function bigTeleportParticles(state, origin)
```

Return the big teleport particles value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |
| `origin` | `dynamic` | — | origin value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/effects/state.ml#L399)

<a id="function-function-miniquake2-client-effects-state-blasterparticles-function-blasterparticles-state-origin-direction-color-src-miniquake2-client-effects-state-ml-1332996948"></a>
### blasterParticles

```ml
function blasterParticles(state, origin, direction, color)
```

Return the blaster particles value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |
| `origin` | `dynamic` | — | origin value consumed by this operation. |
| `direction` | `dynamic` | — | direction value consumed by this operation. |
| `color` | `dynamic` | — | color value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/effects/state.ml#L265)

<a id="function-function-miniquake2-client-effects-state-blastertrail-function-blastertrail-state-startposition-endposition-green-src-miniquake2-client-effects-state-ml-840764176"></a>
### blasterTrail

```ml
function blasterTrail(state, startPosition, endPosition, green)
```

Return the blaster trail value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |
| `startPosition` | `dynamic` | — | startPosition value consumed by this operation. |
| `endPosition` | `dynamic` | — | endPosition value consumed by this operation. |
| `green` | `dynamic` | — | green value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/effects/state.ml#L735)

<a id="function-function-miniquake2-client-effects-state-bubbletrail-function-bubbletrail-state-startposition-endposition-spacing-rise-src-miniquake2-client-effects-state-ml-661462463"></a>
### bubbleTrail

```ml
function bubbleTrail(state, startPosition, endPosition, spacing, rise)
```

Return the bubble trail value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |
| `startPosition` | `dynamic` | — | startPosition value consumed by this operation. |
| `endPosition` | `dynamic` | — | endPosition value consumed by this operation. |
| `spacing` | `dynamic` | — | spacing value consumed by this operation. |
| `rise` | `dynamic` | — | rise value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/effects/state.ml#L577)

<a id="function-function-miniquake2-client-effects-state-centeredrandom-inline-function-centeredrandom-state-src-miniquake2-client-effects-state-ml-602748807"></a>
### centeredRandom

```ml
inline function centeredRandom(state)
```

Return the centered random value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/effects/state.ml#L167)

<a id="function-function-miniquake2-client-effects-state-clear-function-clear-state-src-miniquake2-client-effects-state-ml-1817466112"></a>
### clear

```ml
function clear(state)
```

Clear state.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/effects/state.ml#L1341)

<a id="function-function-miniquake2-client-effects-state-compact-function-compact-values-count-src-miniquake2-client-effects-state-ml-565073900"></a>
### compact

```ml
function compact(values, count)
```

Return the compact value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `values` | `dynamic` | — | values value consumed by this operation. |
| `count` | `dynamic` | — | Number of items or units to process. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/effects/state.ml#L70)

<a id="function-function-miniquake2-client-effects-state-copyvec-inline-function-copyvec-value-src-miniquake2-client-effects-state-ml-565324995"></a>
### copyVec

```ml
inline function copyVec(value)
```

Copy vec data.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/effects/state.ml#L42)

<a id="function-function-miniquake2-client-effects-state-create-function-create-audiocallbacks-randomseed-src-miniquake2-client-effects-state-ml-1670926709"></a>
### create

```ml
function create(audioCallbacks, randomSeed)
```

Creates create for the miniquake2 client effects state module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `audioCallbacks` | `dynamic` | — | audioCallbacks value consumed by this operation. |
| `randomSeed` | `dynamic` | — | randomSeed value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/effects/state.ml#L20)

<a id="function-function-miniquake2-client-effects-state-createsilent-function-createsilent-randomseed-src-miniquake2-client-effects-state-ml-216695019"></a>
### createSilent

```ml
function createSilent(randomSeed)
```

Report whether create silent.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `randomSeed` | `dynamic` | — | randomSeed value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/effects/state.ml#L29)

<a id="function-function-miniquake2-client-effects-state-cross-inline-function-cross-first-second-src-miniquake2-client-effects-state-ml-1305380548"></a>
### cross

```ml
inline function cross(first, second)
```

Performs the cross operation for the miniquake2 client effects state module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `first` | `dynamic` | — | first value consumed by this operation. |
| `second` | `dynamic` | — | second value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/effects/state.ml#L197)

<a id="function-function-miniquake2-client-effects-state-debugtrail-function-debugtrail-state-startposition-endposition-src-miniquake2-client-effects-state-ml-485578437"></a>
### debugTrail

```ml
function debugTrail(state, startPosition, endPosition)
```

Return the debug trail value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |
| `startPosition` | `dynamic` | — | startPosition value consumed by this operation. |
| `endPosition` | `dynamic` | — | endPosition value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/effects/state.ml#L547)

<a id="function-function-miniquake2-client-effects-state-diminishingtrail-function-diminishingtrail-state-startposition-endposition-trail-flags-src-miniquake2-client-effects-state-ml-1079016842"></a>
### diminishingTrail

```ml
function diminishingTrail(state, startPosition, endPosition, trail, flags)
```

Return the diminishing trail value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |
| `startPosition` | `dynamic` | — | startPosition value consumed by this operation. |
| `endPosition` | `dynamic` | — | endPosition value consumed by this operation. |
| `trail` | `dynamic` | — | trail value consumed by this operation. |
| `flags` | `dynamic` | — | Bit flags controlling the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/effects/state.ml#L799)

<a id="function-function-miniquake2-client-effects-state-ensureangularvelocities-function-ensureangularvelocities-state-src-miniquake2-client-effects-state-ml-538266332"></a>
### ensureAngularVelocities

```ml
function ensureAngularVelocities(state)
```

Ensure angular velocities.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/effects/state.ml#L938)

<a id="function-function-miniquake2-client-effects-state-explosionparticles-function-explosionparticles-state-origin-color-colorrun-count-velocityrange-src-miniquake2-client-effects-state-ml-2132371610"></a>
### explosionParticles

```ml
function explosionParticles(state, origin, color, colorRun, count, velocityRange)
```

Return the explosion particles value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |
| `origin` | `dynamic` | — | origin value consumed by this operation. |
| `color` | `dynamic` | — | color value consumed by this operation. |
| `colorRun` | `dynamic` | — | colorRun value consumed by this operation. |
| `count` | `dynamic` | — | Number of items or units to process. |
| `velocityRange` | `dynamic` | — | velocityRange value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/effects/state.ml#L295)

<a id="function-function-miniquake2-client-effects-state-fixedcolorparticles-function-fixedcolorparticles-state-origin-direction-color-count-positivegravity-src-miniquake2-client-effects-state-ml-745913342"></a>
### fixedColorParticles

```ml
function fixedColorParticles(state, origin, direction, color, count, positiveGravity)
```

Return the fixed color particles value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |
| `origin` | `dynamic` | — | origin value consumed by this operation. |
| `direction` | `dynamic` | — | direction value consumed by this operation. |
| `color` | `dynamic` | — | color value consumed by this operation. |
| `count` | `dynamic` | — | Number of items or units to process. |
| `positiveGravity` | `dynamic` | — | positiveGravity value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/effects/state.ml#L256)

<a id="function-function-miniquake2-client-effects-state-flagtrail-function-flagtrail-state-startposition-endposition-color-inclusive-src-miniquake2-client-effects-state-ml-2031911154"></a>
### flagTrail

```ml
function flagTrail(state, startPosition, endPosition, color, inclusive)
```

Return the flag trail value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |
| `startPosition` | `dynamic` | — | startPosition value consumed by this operation. |
| `endPosition` | `dynamic` | — | endPosition value consumed by this operation. |
| `color` | `dynamic` | — | color value consumed by this operation. |
| `inclusive` | `dynamic` | — | inclusive value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/effects/state.ml#L759)

<a id="function-function-miniquake2-client-effects-state-flyeffect-function-flyeffect-state-trail-origin-src-miniquake2-client-effects-state-ml-567334500"></a>
### flyEffect

```ml
function flyEffect(state, trail, origin)
```

Return the fly effect value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |
| `trail` | `dynamic` | — | trail value consumed by this operation. |
| `origin` | `dynamic` | — | origin value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/effects/state.ml#L987)

<a id="function-function-miniquake2-client-effects-state-flyparticles-function-flyparticles-state-origin-count-src-miniquake2-client-effects-state-ml-1451797283"></a>
### flyParticles

```ml
function flyParticles(state, origin, count)
```

Return the fly particles value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |
| `origin` | `dynamic` | — | origin value consumed by this operation. |
| `count` | `dynamic` | — | Number of items or units to process. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/effects/state.ml#L954)

<a id="function-function-miniquake2-client-effects-state-forcewallparticles-function-forcewallparticles-state-startposition-endposition-color-src-miniquake2-client-effects-state-ml-729422320"></a>
### forceWallParticles

```ml
function forceWallParticles(state, startPosition, endPosition, color)
```

Return the force wall particles value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |
| `startPosition` | `dynamic` | — | startPosition value consumed by this operation. |
| `endPosition` | `dynamic` | — | endPosition value consumed by this operation. |
| `color` | `dynamic` | — | color value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/effects/state.ml#L621)

<a id="function-function-miniquake2-client-effects-state-instantshellparticles-function-instantshellparticles-state-origin-color-count-radius-src-miniquake2-client-effects-state-ml-50032640"></a>
### instantShellParticles

```ml
function instantShellParticles(state, origin, color, count, radius)
```

Return the instant shell particles value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |
| `origin` | `dynamic` | — | origin value consumed by this operation. |
| `color` | `dynamic` | — | color value consumed by this operation. |
| `count` | `dynamic` | — | Number of items or units to process. |
| `radius` | `dynamic` | — | radius value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/effects/state.ml#L920)

<a id="function-function-miniquake2-client-effects-state-ionrippertrail-function-ionrippertrail-state-startposition-endposition-src-miniquake2-client-effects-state-ml-196227793"></a>
### ionRipperTrail

```ml
function ionRipperTrail(state, startPosition, endPosition)
```

Return the ion ripper trail value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |
| `startPosition` | `dynamic` | — | startPosition value consumed by this operation. |
| `endPosition` | `dynamic` | — | endPosition value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/effects/state.ml#L768)

<a id="function-function-miniquake2-client-effects-state-itemrespawnparticles-function-itemrespawnparticles-state-origin-src-miniquake2-client-effects-state-ml-1187441652"></a>
### itemRespawnParticles

```ml
function itemRespawnParticles(state, origin)
```

Return the item respawn particles value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |
| `origin` | `dynamic` | — | origin value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/effects/state.ml#L378)

<a id="function-function-miniquake2-client-effects-state-logoutparticles-function-logoutparticles-state-origin-color-src-miniquake2-client-effects-state-ml-1053197353"></a>
### logoutParticles

```ml
function logoutParticles(state, origin, color)
```

Return the logout particles value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |
| `origin` | `dynamic` | — | origin value consumed by this operation. |
| `color` | `dynamic` | — | color value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/effects/state.ml#L356)

<a id="function-function-miniquake2-client-effects-state-normalized-inline-function-normalized-value-src-miniquake2-client-effects-state-ml-1174181899"></a>
### normalized

```ml
inline function normalized(value)
```

Performs the normalized operation for the miniquake2 client effects state module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/effects/state.ml#L179)

<a id="function-function-miniquake2-client-effects-state-normalright-inline-function-normalright-forward-src-miniquake2-client-effects-state-ml-1332735159"></a>
### normalRight

```ml
inline function normalRight(forward)
```

Return the normal right value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `forward` | `dynamic` | — | forward value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/effects/state.ml#L187)

<a id="function-function-miniquake2-client-effects-state-railtrail-function-railtrail-state-startposition-endposition-src-miniquake2-client-effects-state-ml-302536537"></a>
### railTrail

```ml
function railTrail(state, startPosition, endPosition)
```

Return the rail trail value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |
| `startPosition` | `dynamic` | — | startPosition value consumed by this operation. |
| `endPosition` | `dynamic` | — | endPosition value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/effects/state.ml#L651)

<a id="function-function-miniquake2-client-effects-state-random-inline-function-random-state-src-miniquake2-client-effects-state-ml-2045177879"></a>
### random

```ml
inline function random(state)
```

Return the random value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/effects/state.ml#L35)

<a id="function-function-miniquake2-client-effects-state-reserveparticles-function-reserveparticles-state-requested-src-miniquake2-client-effects-state-ml-1115604962"></a>
### reserveParticles

```ml
function reserveParticles(state, requested)
```

Reserve particles.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |
| `requested` | `dynamic` | — | requested value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/effects/state.ml#L125)

<a id="function-function-miniquake2-client-effects-state-resetentitytrails-function-resetentitytrails-state-src-miniquake2-client-effects-state-ml-11420620"></a>
### resetEntityTrails

```ml
function resetEntityTrails(state)
```

Reset entity trails.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/effects/state.ml#L1093)

<a id="function-function-miniquake2-client-effects-state-rockettrail-function-rockettrail-state-startposition-endposition-trail-src-miniquake2-client-effects-state-ml-1511620047"></a>
### rocketTrail

```ml
function rocketTrail(state, startPosition, endPosition, trail)
```

Return the rocket trail value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |
| `startPosition` | `dynamic` | — | startPosition value consumed by this operation. |
| `endPosition` | `dynamic` | — | endPosition value consumed by this operation. |
| `trail` | `dynamic` | — | trail value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/effects/state.ml#L854)

<a id="function-function-miniquake2-client-effects-state-scaled-inline-function-scaled-value-amount-src-miniquake2-client-effects-state-ml-1028166525"></a>
### scaled

```ml
inline function scaled(value, amount)
```

Return the scaled value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |
| `amount` | `dynamic` | — | amount value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/effects/state.ml#L63)

<a id="function-function-miniquake2-client-effects-state-simpleentitytrail-function-simpleentitytrail-state-startposition-endposition-color-originspread-velocityspread-alpha-alphabase-alpharange-inclusive-src-miniquake2-client-effects-state-ml-308995459"></a>
### simpleEntityTrail

```ml
function simpleEntityTrail(state, startPosition, endPosition, color, originSpread, velocitySpread, alpha, alphaBase, alphaRange, inclusive)
```

Return the simple entity trail value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |
| `startPosition` | `dynamic` | — | startPosition value consumed by this operation. |
| `endPosition` | `dynamic` | — | endPosition value consumed by this operation. |
| `color` | `dynamic` | — | color value consumed by this operation. |
| `originSpread` | `dynamic` | — | originSpread value consumed by this operation. |
| `velocitySpread` | `dynamic` | — | velocitySpread value consumed by this operation. |
| `alpha` | `dynamic` | — | alpha value consumed by this operation. |
| `alphaBase` | `dynamic` | — | alphaBase value consumed by this operation. |
| `alphaRange` | `dynamic` | — | alphaRange value consumed by this operation. |
| `inclusive` | `dynamic` | — | inclusive value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/effects/state.ml#L702)

<a id="function-function-miniquake2-client-effects-state-steamparticles-function-steamparticles-state-origin-direction-color-count-magnitude-nogravity-src-miniquake2-client-effects-state-ml-494984942"></a>
### steamParticles

```ml
function steamParticles(state, origin, direction, color, count, magnitude, noGravity)
```

Return the steam particles value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |
| `origin` | `dynamic` | — | origin value consumed by this operation. |
| `direction` | `dynamic` | — | direction value consumed by this operation. |
| `color` | `dynamic` | — | color value consumed by this operation. |
| `count` | `dynamic` | — | Number of items or units to process. |
| `magnitude` | `dynamic` | — | magnitude value consumed by this operation. |
| `noGravity` | `dynamic` | — | noGravity value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/effects/state.ml#L325)

<a id="function-function-miniquake2-client-effects-state-stockdirectionalparticles-function-stockdirectionalparticles-state-origin-direction-color-count-fixedcolor-positivegravity-src-miniquake2-client-effects-state-ml-396715615"></a>
### stockDirectionalParticles

```ml
function stockDirectionalParticles(state, origin, direction, color, count, fixedColor, positiveGravity)
```

Return the stock directional particles value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |
| `origin` | `dynamic` | — | origin value consumed by this operation. |
| `direction` | `dynamic` | — | direction value consumed by this operation. |
| `color` | `dynamic` | — | color value consumed by this operation. |
| `count` | `dynamic` | — | Number of items or units to process. |
| `fixedColor` | `dynamic` | — | fixedColor value consumed by this operation. |
| `positiveGravity` | `dynamic` | — | positiveGravity value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/effects/state.ml#L211)

<a id="function-function-miniquake2-client-effects-state-sustainradialparticles-function-sustainradialparticles-state-sustain-now-nuke-src-miniquake2-client-effects-state-ml-1506570432"></a>
### sustainRadialParticles

```ml
function sustainRadialParticles(state, sustain, now, nuke)
```

Return the sustain radial particles value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |
| `sustain` | `dynamic` | — | sustain value consumed by this operation. |
| `now` | `dynamic` | — | now value consumed by this operation. |
| `nuke` | `dynamic` | — | nuke value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/effects/state.ml#L515)

<a id="function-function-miniquake2-client-effects-state-teleporterentityparticles-function-teleporterentityparticles-state-origin-src-miniquake2-client-effects-state-ml-954314360"></a>
### teleporterEntityParticles

```ml
function teleporterEntityParticles(state, origin)
```

EF_TELEPORTER is a persistent entity flag fired once for every accepted server frame. It is deliberately separate from the 1,053-particle player teleport event above.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |
| `origin` | `dynamic` | — | origin value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/effects/state.ml#L465)

<a id="function-function-miniquake2-client-effects-state-teleportparticles-function-teleportparticles-state-origin-src-miniquake2-client-effects-state-ml-187742512"></a>
### teleportParticles

```ml
function teleportParticles(state, origin)
```

Return the teleport particles value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |
| `origin` | `dynamic` | — | origin value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/effects/state.ml#L432)

<a id="function-function-miniquake2-client-effects-state-trackertrail-function-trackertrail-state-startposition-endposition-color-src-miniquake2-client-effects-state-ml-1913809928"></a>
### trackerTrail

```ml
function trackerTrail(state, startPosition, endPosition, color)
```

Return the tracker trail value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |
| `startPosition` | `dynamic` | — | startPosition value consumed by this operation. |
| `endPosition` | `dynamic` | — | endPosition value consumed by this operation. |
| `color` | `dynamic` | — | color value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/effects/state.ml#L892)

<a id="function-function-miniquake2-client-effects-state-trapparticles-function-trapparticles-state-shiftedorigin-src-miniquake2-client-effects-state-ml-1351242909"></a>
### trapParticles

```ml
function trapParticles(state, shiftedOrigin)
```

Return the trap particles value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |
| `shiftedOrigin` | `dynamic` | — | shiftedOrigin value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/effects/state.ml#L1042)

<a id="function-function-miniquake2-client-effects-state-unitrandom-inline-function-unitrandom-state-src-miniquake2-client-effects-state-ml-595561407"></a>
### unitRandom

```ml
inline function unitRandom(state)
```

Return the unit random value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/effects/state.ml#L161)

<a id="function-function-miniquake2-client-effects-state-vecfromarray-function-vecfromarray-value-src-miniquake2-client-effects-state-ml-210899170"></a>
### vecFromArray

```ml
function vecFromArray(value)
```

Return the vec from array.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/effects/state.ml#L48)

<a id="function-function-miniquake2-client-effects-state-vectorlength-inline-function-vectorlength-value-src-miniquake2-client-effects-state-ml-1545813635"></a>
### vectorLength

```ml
inline function vectorLength(value)
```

Return the vector length.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/effects/state.ml#L173)

<a id="function-function-miniquake2-client-effects-state-wallparticles-function-wallparticles-state-origin-direction-color-count-src-miniquake2-client-effects-state-ml-88724825"></a>
### wallParticles

```ml
function wallParticles(state, origin, direction, color, count)
```

Return the wall particles value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |
| `origin` | `dynamic` | — | origin value consumed by this operation. |
| `direction` | `dynamic` | — | direction value consumed by this operation. |
| `color` | `dynamic` | — | color value consumed by this operation. |
| `count` | `dynamic` | — | Number of items or units to process. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/effects/state.ml#L245)

<a id="function-function-miniquake2-client-effects-state-widowsplashparticles-function-widowsplashparticles-state-origin-src-miniquake2-client-effects-state-ml-1676696048"></a>
### widowSplashParticles

```ml
function widowSplashParticles(state, origin)
```

Return the widow splash particles value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |
| `origin` | `dynamic` | — | origin value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/effects/state.ml#L489)
