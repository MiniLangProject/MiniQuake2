# `src/miniquake2/renderer/classic/vector.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 renderer classic vector facilities for this project.

Package: [`miniquake2.renderer.classic.vector`](Package-miniquake2-renderer-classic-vector-544293399.md)

Reachable from entry: **yes**

## Imports

- `miniquake2/format/types.ml` as `ft` → [src/miniquake2/format/types.ml](File-src-miniquake2-format-types-ml-129451131.md)
- `std/math.ml` as `smath` → `../MiniLangCompilerML/std/math.ml` — external dependency

## Declarations

<a id="function-function-miniquake2-renderer-classic-vector-add-inline-function-add-first-second-src-miniquake2-renderer-classic-vector-ml-1692376040"></a>
### add

```ml
inline function add(first, second)
```

Adds add to the state managed by the miniquake2 renderer classic vector module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `first` | `dynamic` | — | first value consumed by this operation. |
| `second` | `dynamic` | — | second value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/classic/vector.ml#L21)

<a id="function-function-miniquake2-renderer-classic-vector-copy-inline-function-copy-value-src-miniquake2-renderer-classic-vector-ml-792207189"></a>
### copy

```ml
inline function copy(value)
```

Performs the copy operation for the miniquake2 renderer classic vector module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/classic/vector.ml#L15)

<a id="function-function-miniquake2-renderer-classic-vector-dot-inline-function-dot-first-second-src-miniquake2-renderer-classic-vector-ml-764019036"></a>
### dot

```ml
inline function dot(first, second)
```

Performs the dot operation for the miniquake2 renderer classic vector module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `first` | `dynamic` | — | first value consumed by this operation. |
| `second` | `dynamic` | — | second value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/classic/vector.ml#L46)

<a id="function-function-miniquake2-renderer-classic-vector-length-function-length-value-src-miniquake2-renderer-classic-vector-ml-1027422902"></a>
### length

```ml
function length(value)
```

Performs the length operation for the miniquake2 renderer classic vector module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/classic/vector.ml#L51)

<a id="function-function-miniquake2-renderer-classic-vector-multiplyadd-inline-function-multiplyadd-value-amount-direction-src-miniquake2-renderer-classic-vector-ml-33362156"></a>
### multiplyAdd

```ml
inline function multiplyAdd(value, amount, direction)
```

Performs the multiplyAdd operation for the miniquake2 renderer classic vector module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |
| `amount` | `dynamic` | — | amount value consumed by this operation. |
| `direction` | `dynamic` | — | direction value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/classic/vector.ml#L40)

<a id="function-function-miniquake2-renderer-classic-vector-scale-inline-function-scale-value-amount-src-miniquake2-renderer-classic-vector-ml-1163883405"></a>
### scale

```ml
inline function scale(value, amount)
```

Performs the scale operation for the miniquake2 renderer classic vector module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |
| `amount` | `dynamic` | — | amount value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/classic/vector.ml#L33)

<a id="function-function-miniquake2-renderer-classic-vector-subtract-inline-function-subtract-first-second-src-miniquake2-renderer-classic-vector-ml-1340497038"></a>
### subtract

```ml
inline function subtract(first, second)
```

Performs the subtract operation for the miniquake2 renderer classic vector module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `first` | `dynamic` | — | first value consumed by this operation. |
| `second` | `dynamic` | — | second value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/classic/vector.ml#L27)
