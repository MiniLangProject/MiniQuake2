# `src/miniquake2/game/world/types.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 game world types facilities for this project.

Package: [`miniquake2.game.world.types`](Package-miniquake2-game-world-types-1409947784.md)

Reachable from entry: **yes**

## Imports

- `miniquake2/game/world/constants.ml` as `gwconstants` → [src/miniquake2/game/world/constants.ml](File-src-miniquake2-game-world-constants-ml-774918061.md)
- `miniquake2/qcommon/types.ml` as `qt` → [src/miniquake2/qcommon/types.ml](File-src-miniquake2-qcommon-types-ml-1663266398.md)

## Declarations

<a id="function-function-miniquake2-game-world-types-createentity-function-createentity-number-classname-src-miniquake2-game-world-types-ml-1532796919"></a>
### createEntity

```ml
function createEntity(number, className)
```

Create entity.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `number` | `dynamic` | — | number value consumed by this operation. |
| `className` | `dynamic` | — | className value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/types.ml#L391)

- [miniquake2.game.world.types.MoveInfo](Type-miniquake2-game-world-types-moveinfo-1637155131.md) — struct
<a id="function-function-miniquake2-game-world-types-stabilizemoveinfo-function-stabilizemoveinfo-moveinfo-src-miniquake2-game-world-types-ml-2137046966"></a>
### stabilizeMoveInfo

```ml
function stabilizeMoveInfo(moveInfo)
```

Move stabilize info.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `moveInfo` | `dynamic` | — | moveInfo value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/types.ml#L350)

<a id="function-function-miniquake2-game-world-types-vec3fromvalue-function-vec3fromvalue-value-label-src-miniquake2-game-world-types-ml-1992550962"></a>
### vec3FromValue

```ml
function vec3FromValue(value, label)
```

Spawn/parser-era components still expose three-element arrays in a few adapters.  World simulation owns qcommon Vec3 records exclusively; convert once at the producer boundary instead of teaching vector math two shapes.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |
| `label` | `dynamic` | — | label value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/types.ml#L335)

- [miniquake2.game.world.types.WorldCallbacks](Type-miniquake2-game-world-types-worldcallbacks-18067046.md) — struct
- [miniquake2.game.world.types.WorldEntity](Type-miniquake2-game-world-types-worldentity-112348493.md) — struct
- [miniquake2.game.world.types.WorldState](Type-miniquake2-game-world-types-worldstate-1529064627.md) — struct
- [miniquake2.game.world.types.WorldTrace](Type-miniquake2-game-world-types-worldtrace-156853779.md) — struct
<a id="function-function-miniquake2-game-world-types-zeromoveinfo-function-zeromoveinfo-src-miniquake2-game-world-types-ml-944043143"></a>
### zeroMoveInfo

```ml
function zeroMoveInfo()
```

Move zero info.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/types.ml#L367)
