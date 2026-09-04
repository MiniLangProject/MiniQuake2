# `src/miniquake2/physics/vector.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 physics vector facilities for this project.

Package: [`miniquake2.physics.vector`](Package-miniquake2-physics-vector-1417503493.md)

Reachable from entry: **yes**

## Imports

- `miniquake2/qcommon/types.ml` as `qt` → [src/miniquake2/qcommon/types.ml](File-src-miniquake2-qcommon-types-ml-1663266398.md)
- `std/math.ml` as `smath` → `../MiniLangCompilerML/std/math.ml` — external dependency

## Declarations

<a id="function-function-miniquake2-physics-vector-add-function-add-first-second-src-miniquake2-physics-vector-ml-194493286"></a>
### add

```ml
function add(first, second)
```

Adds add to the state managed by the miniquake2 physics vector module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `first` | `dynamic` | — | first value consumed by this operation. |
| `second` | `dynamic` | — | second value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/physics/vector.ml#L55)

<a id="function-function-miniquake2-physics-vector-anglevectors-function-anglevectors-angles-src-miniquake2-physics-vector-ml-1451207740"></a>
### angleVectors

```ml
function angleVectors(angles)
```

Return the angle vectors value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `angles` | `dynamic` | — | angles value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/physics/vector.ml#L215)

<a id="function-function-miniquake2-physics-vector-component-function-component-value-axis-src-miniquake2-physics-vector-ml-26122276"></a>
### component

```ml
function component(value, axis)
```

Return the component value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |
| `axis` | `dynamic` | — | axis value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/physics/vector.ml#L183)

<a id="function-function-miniquake2-physics-vector-copy-function-copy-value-src-miniquake2-physics-vector-ml-326757487"></a>
### copy

```ml
function copy(value)
```

Performs the copy operation for the miniquake2 physics vector module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/physics/vector.ml#L45)

<a id="function-function-miniquake2-physics-vector-cross-function-cross-first-second-src-miniquake2-physics-vector-ml-1708669728"></a>
### cross

```ml
function cross(first, second)
```

Performs the cross operation for the miniquake2 physics vector module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `first` | `dynamic` | — | first value consumed by this operation. |
| `second` | `dynamic` | — | second value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/physics/vector.ml#L118)

<a id="function-function-miniquake2-physics-vector-dot-function-dot-first-second-src-miniquake2-physics-vector-ml-1426705706"></a>
### dot

```ml
function dot(first, second)
```

Performs the dot operation for the miniquake2 physics vector module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `first` | `dynamic` | — | first value consumed by this operation. |
| `second` | `dynamic` | — | second value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/physics/vector.ml#L107)

<a id="function-function-miniquake2-physics-vector-length-function-length-value-src-miniquake2-physics-vector-ml-466964819"></a>
### length

```ml
function length(value)
```

Performs the length operation for the miniquake2 physics vector module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/physics/vector.ml#L133)

<a id="function-function-miniquake2-physics-vector-multiplyadd-function-multiplyadd-value-amount-direction-src-miniquake2-physics-vector-ml-1650410360"></a>
### multiplyAdd

```ml
function multiplyAdd(value, amount, direction)
```

Performs the multiplyAdd operation for the miniquake2 physics vector module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |
| `amount` | `dynamic` | — | amount value consumed by this operation. |
| `direction` | `dynamic` | — | direction value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/physics/vector.ml#L90)

<a id="function-function-miniquake2-physics-vector-normalized-function-normalized-value-src-miniquake2-physics-vector-ml-8074763"></a>
### normalized

```ml
function normalized(value)
```

Return [normalized vector, original length], matching VectorNormalize's useful result without relying on reference parameters.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/physics/vector.ml#L152)

<a id="function-function-miniquake2-physics-vector-physicsvectorcomponents-function-physicsvectorcomponents-value-operation-src-miniquake2-physics-vector-ml-1789619530"></a>
### physicsVectorComponents

```ml
function physicsVectorComponents(value, operation)
```

Return the physics vector components value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |
| `operation` | `dynamic` | — | operation value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/physics/vector.ml#L37)

<a id="function-function-miniquake2-physics-vector-scale-function-scale-value-amount-src-miniquake2-physics-vector-ml-849026327"></a>
### scale

```ml
function scale(value, amount)
```

Performs the scale operation for the miniquake2 physics vector module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |
| `amount` | `dynamic` | — | amount value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/physics/vector.ml#L79)

<a id="function-function-miniquake2-physics-vector-setcomponent-function-setcomponent-value-axis-componentvalue-src-miniquake2-physics-vector-ml-1483497826"></a>
### setComponent

```ml
function setComponent(value, axis, componentValue)
```

Set component.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |
| `axis` | `dynamic` | — | axis value consumed by this operation. |
| `componentValue` | `dynamic` | — | componentValue value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/physics/vector.ml#L195)

<a id="function-function-miniquake2-physics-vector-subtract-function-subtract-first-second-src-miniquake2-physics-vector-ml-1870631700"></a>
### subtract

```ml
function subtract(first, second)
```

Performs the subtract operation for the miniquake2 physics vector module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `first` | `dynamic` | — | first value consumed by this operation. |
| `second` | `dynamic` | — | second value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/physics/vector.ml#L67)

<a id="function-function-miniquake2-physics-vector-validatephysicsvector-inline-function-validatephysicsvector-value-operation-src-miniquake2-physics-vector-ml-1210920613"></a>
### validatePhysicsVector

```ml
inline function validatePhysicsVector(value, operation)
```

Validate dynamic Vec3-shaped values without materializing a temporary three-element array. Pmove calls dot/length/multiplyAdd hundreds of times per prediction frame, so the former component array dominated its GC rate.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |
| `operation` | `dynamic` | — | operation value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/physics/vector.ml#L18)
