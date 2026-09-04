# `src/miniquake2/game/weapons/vector.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 game weapons vector facilities for this project.

Package: [`miniquake2.game.weapons.vector`](Package-miniquake2-game-weapons-vector-1124756899.md)

Reachable from entry: **yes**

## Imports

- `miniquake2/qcommon/types.ml` as `qt` → [src/miniquake2/qcommon/types.ml](File-src-miniquake2-qcommon-types-ml-1663266398.md)
- `std/math.ml` as `smath` → `../MiniLangCompilerML/std/math.ml` — external dependency

## Declarations

<a id="function-function-miniquake2-game-weapons-vector-add-function-add-first-second-src-miniquake2-game-weapons-vector-ml-30238189"></a>
### add

```ml
function add(first, second)
```

Adds add to the state managed by the miniquake2 game weapons vector module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `first` | `dynamic` | — | first value consumed by this operation. |
| `second` | `dynamic` | — | second value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/weapons/vector.ml#L47)

<a id="function-function-miniquake2-game-weapons-vector-anglevectors-function-anglevectors-angles-src-miniquake2-game-weapons-vector-ml-30479831"></a>
### angleVectors

```ml
function angleVectors(angles)
```

Return the angle vectors value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `angles` | `dynamic` | — | angles value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/weapons/vector.ml#L189)

<a id="function-function-miniquake2-game-weapons-vector-copy-function-copy-value-src-miniquake2-game-weapons-vector-ml-1808106730"></a>
### copy

```ml
function copy(value)
```

Performs the copy operation for the miniquake2 game weapons vector module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/weapons/vector.ml#L37)

<a id="function-function-miniquake2-game-weapons-vector-dot-function-dot-first-second-src-miniquake2-game-weapons-vector-ml-551717937"></a>
### dot

```ml
function dot(first, second)
```

Performs the dot operation for the miniquake2 game weapons vector module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `first` | `dynamic` | — | first value consumed by this operation. |
| `second` | `dynamic` | — | second value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/weapons/vector.ml#L98)

<a id="function-function-miniquake2-game-weapons-vector-length-function-length-value-src-miniquake2-game-weapons-vector-ml-2062178510"></a>
### length

```ml
function length(value)
```

Performs the length operation for the miniquake2 game weapons vector module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/weapons/vector.ml#L108)

<a id="function-function-miniquake2-game-weapons-vector-midpoint-function-midpoint-target-src-miniquake2-game-weapons-vector-ml-1479854748"></a>
### midpoint

```ml
function midpoint(target)
```

Return the midpoint value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `target` | `dynamic` | — | target value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/weapons/vector.ml#L135)

<a id="function-function-miniquake2-game-weapons-vector-multiplyadd-function-multiplyadd-value-amount-direction-src-miniquake2-game-weapons-vector-ml-1246056371"></a>
### multiplyAdd

```ml
function multiplyAdd(value, amount, direction)
```

Performs the multiplyAdd operation for the miniquake2 game weapons vector module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |
| `amount` | `dynamic` | — | amount value consumed by this operation. |
| `direction` | `dynamic` | — | direction value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/weapons/vector.ml#L82)

<a id="function-function-miniquake2-game-weapons-vector-normalized-function-normalized-value-src-miniquake2-game-weapons-vector-ml-1955506854"></a>
### normalized

```ml
function normalized(value)
```

Performs the normalized operation for the miniquake2 game weapons vector module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/weapons/vector.ml#L117)

<a id="function-function-miniquake2-game-weapons-vector-scale-function-scale-value-amount-src-miniquake2-game-weapons-vector-ml-560108322"></a>
### scale

```ml
function scale(value, amount)
```

Performs the scale operation for the miniquake2 game weapons vector module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |
| `amount` | `dynamic` | — | amount value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/weapons/vector.ml#L71)

<a id="function-function-miniquake2-game-weapons-vector-subtract-function-subtract-first-second-src-miniquake2-game-weapons-vector-ml-1212251675"></a>
### subtract

```ml
function subtract(first, second)
```

Performs the subtract operation for the miniquake2 game weapons vector module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `first` | `dynamic` | — | first value consumed by this operation. |
| `second` | `dynamic` | — | second value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/weapons/vector.ml#L59)

<a id="function-function-miniquake2-game-weapons-vector-toarray-function-toarray-value-src-miniquake2-game-weapons-vector-ml-1020653350"></a>
### toArray

```ml
function toArray(value)
```

Return the to array value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/weapons/vector.ml#L159)

<a id="function-function-miniquake2-game-weapons-vector-vectortoangles-function-vectortoangles-direction-src-miniquake2-game-weapons-vector-ml-623903910"></a>
### vectorToAngles

```ml
function vectorToAngles(direction)
```

Return the vector to angles.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `direction` | `dynamic` | — | direction value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/weapons/vector.ml#L169)

<a id="function-function-miniquake2-game-weapons-vector-weaponvectorcomponents-function-weaponvectorcomponents-value-operation-src-miniquake2-game-weapons-vector-ml-1442193161"></a>
### weaponVectorComponents

```ml
function weaponVectorComponents(value, operation)
```

Validate the dynamic MiniLang value once and copy every component into a scalar array before callers allocate a result or enter another helper.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |
| `operation` | `dynamic` | — | operation value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/weapons/vector.ml#L17)
