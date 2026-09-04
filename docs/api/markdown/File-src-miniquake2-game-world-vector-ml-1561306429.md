# `src/miniquake2/game/world/vector.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 game world vector facilities for this project.

Package: [`miniquake2.game.world.vector`](Package-miniquake2-game-world-vector-784060144.md)

Reachable from entry: **yes**

## Imports

- `miniquake2/qcommon/types.ml` as `qt` → [src/miniquake2/qcommon/types.ml](File-src-miniquake2-qcommon-types-ml-1663266398.md)
- `std/math.ml` as `smath` → `../MiniLangCompilerML/std/math.ml` — external dependency

## Declarations

<a id="function-function-miniquake2-game-world-vector-add-function-add-first-second-src-miniquake2-game-world-vector-ml-461954067"></a>
### add

```ml
function add(first, second)
```

Adds add to the state managed by the miniquake2 game world vector module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `first` | `dynamic` | — | first value consumed by this operation. |
| `second` | `dynamic` | — | second value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/vector.ml#L32)

<a id="function-function-miniquake2-game-world-vector-copy-function-copy-value-src-miniquake2-game-world-vector-ml-1187887680"></a>
### copy

```ml
function copy(value)
```

Performs the copy operation for the miniquake2 game world vector module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/vector.ml#L23)

<a id="function-function-miniquake2-game-world-vector-dot-function-dot-first-second-src-miniquake2-game-world-vector-ml-988041139"></a>
### dot

```ml
function dot(first, second)
```

Performs the dot operation for the miniquake2 game world vector module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `first` | `dynamic` | — | first value consumed by this operation. |
| `second` | `dynamic` | — | second value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/vector.ml#L75)

<a id="function-function-miniquake2-game-world-vector-equal-function-equal-first-second-src-miniquake2-game-world-vector-ml-1803318933"></a>
### equal

```ml
function equal(first, second)
```

Report whether equal.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `first` | `dynamic` | — | first value consumed by this operation. |
| `second` | `dynamic` | — | second value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/vector.ml#L114)

<a id="function-function-miniquake2-game-world-vector-length-function-length-value-src-miniquake2-game-world-vector-ml-452016020"></a>
### length

```ml
function length(value)
```

Performs the length operation for the miniquake2 game world vector module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/vector.ml#L85)

<a id="function-function-miniquake2-game-world-vector-movedir-function-movedir-angles-src-miniquake2-game-world-vector-ml-1609829983"></a>
### movedir

```ml
function movedir(angles)
```

Return the movedir value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `angles` | `dynamic` | — | angles value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/vector.ml#L124)

<a id="function-function-miniquake2-game-world-vector-multiplyadd-function-multiplyadd-value-amount-direction-src-miniquake2-game-world-vector-ml-499330491"></a>
### multiplyAdd

```ml
function multiplyAdd(value, amount, direction)
```

Performs the multiplyAdd operation for the miniquake2 game world vector module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |
| `amount` | `dynamic` | — | amount value consumed by this operation. |
| `direction` | `dynamic` | — | direction value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/vector.ml#L64)

<a id="function-function-miniquake2-game-world-vector-normalized-function-normalized-value-src-miniquake2-game-world-vector-ml-386703508"></a>
### normalized

```ml
function normalized(value)
```

Performs the normalized operation for the miniquake2 game world vector module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/vector.ml#L97)

<a id="function-function-miniquake2-game-world-vector-requireworldvector-function-requireworldvector-value-operation-src-miniquake2-game-world-vector-ml-965750413"></a>
### requireWorldVector

```ml
function requireWorldVector(value, operation)
```

Require world vector.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |
| `operation` | `dynamic` | — | operation value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/vector.ml#L16)

<a id="function-function-miniquake2-game-world-vector-scale-function-scale-value-amount-src-miniquake2-game-world-vector-ml-1693022552"></a>
### scale

```ml
function scale(value, amount)
```

Performs the scale operation for the miniquake2 game world vector module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |
| `amount` | `dynamic` | — | amount value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/vector.ml#L54)

<a id="function-function-miniquake2-game-world-vector-setmovedir-function-setmovedir-entity-src-miniquake2-game-world-vector-ml-1538298002"></a>
### setMovedir

```ml
function setMovedir(entity)
```

Convert an authored entity angle to a movement direction and clear the render angles exactly as Quake II's G_SetMovedir does.  Brush movers must not retain this angle: it describes translation, not model rotation.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/vector.ml#L142)

<a id="function-function-miniquake2-game-world-vector-subtract-function-subtract-first-second-src-miniquake2-game-world-vector-ml-213568225"></a>
### subtract

```ml
function subtract(first, second)
```

Performs the subtract operation for the miniquake2 game world vector module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `first` | `dynamic` | — | first value consumed by this operation. |
| `second` | `dynamic` | — | second value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/vector.ml#L43)

<a id="function-function-miniquake2-game-world-vector-toangles-function-toangles-direction-src-miniquake2-game-world-vector-ml-1024798616"></a>
### toAngles

```ml
function toAngles(direction)
```

Return the to angles.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `direction` | `dynamic` | — | direction value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/vector.ml#L150)
