# `src/miniquake2/format/binary.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 format binary facilities for this project.

Package: [`miniquake2.format.binary`](Package-miniquake2-format-binary-1985269835.md)

Reachable from entry: **yes**

## Imports

- `miniquake2/native.ml` as `native` → [src/miniquake2/native.ml](File-src-miniquake2-native-ml-139597585.md)

## Declarations

<a id="function-function-miniquake2-format-binary-f32-inline-function-f32-data-offset-src-miniquake2-format-binary-ml-1383788614"></a>
### f32

```ml
inline function f32(data, offset)
```

Return the f 32 value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `data` | `dynamic` | — | Input data consumed by the operation. |
| `offset` | `dynamic` | — | Zero-based offset at which processing starts. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/format/binary.ml#L78)

<a id="function-function-miniquake2-format-binary-fixedstring-function-fixedstring-data-offset-capacity-src-miniquake2-format-binary-ml-167299981"></a>
### fixedString

```ml
function fixedString(data, offset, capacity)
```

Return the fixed string value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `data` | `dynamic` | — | Input data consumed by the operation. |
| `offset` | `dynamic` | — | Zero-based offset at which processing starts. |
| `capacity` | `dynamic` | — | capacity value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/format/binary.ml#L86)

<a id="function-function-miniquake2-format-binary-i16-inline-function-i16-data-offset-src-miniquake2-format-binary-ml-343294738"></a>
### i16

```ml
inline function i16(data, offset)
```

Return the i 16 value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `data` | `dynamic` | — | Input data consumed by the operation. |
| `offset` | `dynamic` | — | Zero-based offset at which processing starts. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/format/binary.ml#L52)

<a id="function-function-miniquake2-format-binary-i32-function-i32-data-offset-src-miniquake2-format-binary-ml-333076187"></a>
### i32

```ml
function i32(data, offset)
```

Return the i 32 value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `data` | `dynamic` | — | Input data consumed by the operation. |
| `offset` | `dynamic` | — | Zero-based offset at which processing starts. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/format/binary.ml#L69)

<a id="function-function-miniquake2-format-binary-i8-inline-function-i8-data-offset-src-miniquake2-format-binary-ml-1256981494"></a>
### i8

```ml
inline function i8(data, offset)
```

Return the i 8 value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `data` | `dynamic` | — | Input data consumed by the operation. |
| `offset` | `dynamic` | — | Zero-based offset at which processing starts. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/format/binary.ml#L35)

<a id="function-function-miniquake2-format-binary-putu16-function-putu16-data-offset-value-src-miniquake2-format-binary-ml-1354689044"></a>
### putU16

```ml
function putU16(data, offset, value)
```

Write u 16.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `data` | `dynamic` | — | Input data consumed by the operation. |
| `offset` | `dynamic` | — | Zero-based offset at which processing starts. |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/format/binary.ml#L102)

<a id="function-function-miniquake2-format-binary-putu32-function-putu32-data-offset-value-src-miniquake2-format-binary-ml-1005250232"></a>
### putU32

```ml
function putU32(data, offset, value)
```

Write u 32.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `data` | `dynamic` | — | Input data consumed by the operation. |
| `offset` | `dynamic` | — | Zero-based offset at which processing starts. |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/format/binary.ml#L113)

<a id="function-function-miniquake2-format-binary-requirerange-function-requirerange-data-offset-count-src-miniquake2-format-binary-ml-895364622"></a>
### requireRange

```ml
function requireRange(data, offset, count)
```

Require range.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `data` | `dynamic` | — | Input data consumed by the operation. |
| `offset` | `dynamic` | — | Zero-based offset at which processing starts. |
| `count` | `dynamic` | — | Number of items or units to process. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/format/binary.ml#L16)

<a id="function-function-miniquake2-format-binary-u16-inline-function-u16-data-offset-src-miniquake2-format-binary-ml-30974378"></a>
### u16

```ml
inline function u16(data, offset)
```

Return the u 16 value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `data` | `dynamic` | — | Input data consumed by the operation. |
| `offset` | `dynamic` | — | Zero-based offset at which processing starts. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/format/binary.ml#L44)

<a id="function-function-miniquake2-format-binary-u32-function-u32-data-offset-src-miniquake2-format-binary-ml-456035371"></a>
### u32

```ml
function u32(data, offset)
```

Return the u 32 value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `data` | `dynamic` | — | Input data consumed by the operation. |
| `offset` | `dynamic` | — | Zero-based offset at which processing starts. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/format/binary.ml#L61)

<a id="function-function-miniquake2-format-binary-u8-inline-function-u8-data-offset-src-miniquake2-format-binary-ml-1750160198"></a>
### u8

```ml
inline function u8(data, offset)
```

Return the u 8 value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `data` | `dynamic` | — | Input data consumed by the operation. |
| `offset` | `dynamic` | — | Zero-based offset at which processing starts. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/format/binary.ml#L27)
