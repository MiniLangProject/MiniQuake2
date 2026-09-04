# `src/miniquake2/qcommon/byteio.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 qcommon byteio facilities for this project.

Package: [`miniquake2.qcommon.byteio`](Package-miniquake2-qcommon-byteio-1026503593.md)

Reachable from entry: **yes**

## Declarations

<a id="function-function-miniquake2-qcommon-byteio-biglong-function-biglong-value-src-miniquake2-qcommon-byteio-ml-703694879"></a>
### bigLong

```ml
function bigLong(value)
```

Return the big long value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/byteio.ml#L374)

<a id="function-function-miniquake2-qcommon-byteio-bigshort-function-bigshort-value-src-miniquake2-qcommon-byteio-ml-979967671"></a>
### bigShort

```ml
function bigShort(value)
```

Return the big short value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/byteio.ml#L368)

<a id="function-function-miniquake2-qcommon-byteio-copyinto-function-copyinto-destination-destinationoffset-source-sourceoffset-count-src-miniquake2-qcommon-byteio-ml-1602351381"></a>
### copyInto

```ml
function copyInto(destination, destinationOffset, source, sourceOffset, count)
```

Populate the copy destination.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `destination` | `dynamic` | — | destination value consumed by this operation. |
| `destinationOffset` | `dynamic` | — | destinationOffset value consumed by this operation. |
| `source` | `dynamic` | — | source value consumed by this operation. |
| `sourceOffset` | `dynamic` | — | sourceOffset value consumed by this operation. |
| `count` | `dynamic` | — | Number of items or units to process. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/byteio.ml#L149)

<a id="function-function-miniquake2-qcommon-byteio-f32-inline-function-f32-data-offset-src-miniquake2-qcommon-byteio-ml-247659348"></a>
### f32

```ml
inline function f32(data, offset)
```

Return the f 32 value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `data` | `dynamic` | — | Input data consumed by the operation. |
| `offset` | `dynamic` | — | Zero-based offset at which processing starts. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/byteio.ml#L319)

<a id="function-function-miniquake2-qcommon-byteio-float32bits-function-float32bits-value-src-miniquake2-qcommon-byteio-ml-1872347961"></a>
### float32Bits

```ml
function float32Bits(value)
```

Encode IEEE-754 binary32 using round-to-nearest-even. Negative zero is normalized to positive zero because MiniLang has no signbit primitive.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/byteio.ml#L232)

<a id="function-function-miniquake2-qcommon-byteio-float32frombits-function-float32frombits-bits-src-miniquake2-qcommon-byteio-ml-30901338"></a>
### float32FromBits

```ml
function float32FromBits(bits)
```

Return the float 32 from bits.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `bits` | `dynamic` | — | bits value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/byteio.ml#L287)

<a id="function-function-miniquake2-qcommon-byteio-fractionbits23-function-fractionbits23-fraction-src-miniquake2-qcommon-byteio-ml-1893941846"></a>
### fractionBits23

```ml
function fractionBits23(fraction)
```

Emit 23 fraction bits from a value in [0, 1), returning [bits, tail].

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `fraction` | `dynamic` | — | fraction value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/byteio.ml#L200)

<a id="function-function-miniquake2-qcommon-byteio-i16-inline-function-i16-data-offset-src-miniquake2-qcommon-byteio-ml-582620504"></a>
### i16

```ml
inline function i16(data, offset)
```

Return the i 16 value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `data` | `dynamic` | — | Input data consumed by the operation. |
| `offset` | `dynamic` | — | Zero-based offset at which processing starts. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/byteio.ml#L56)

<a id="function-function-miniquake2-qcommon-byteio-i32-function-i32-data-offset-src-miniquake2-qcommon-byteio-ml-1887449155"></a>
### i32

```ml
function i32(data, offset)
```

Return the i 32 value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `data` | `dynamic` | — | Input data consumed by the operation. |
| `offset` | `dynamic` | — | Zero-based offset at which processing starts. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/byteio.ml#L76)

<a id="function-function-miniquake2-qcommon-byteio-i8-inline-function-i8-data-offset-src-miniquake2-qcommon-byteio-ml-581841588"></a>
### i8

```ml
inline function i8(data, offset)
```

Return the i 8 value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `data` | `dynamic` | — | Input data consumed by the operation. |
| `offset` | `dynamic` | — | Zero-based offset at which processing starts. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/byteio.ml#L39)

<a id="function-function-miniquake2-qcommon-byteio-littlelong-inline-function-littlelong-value-src-miniquake2-qcommon-byteio-ml-446830928"></a>
### littleLong

```ml
inline function littleLong(value)
```

Return the little long value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/byteio.ml#L360)

<a id="function-function-miniquake2-qcommon-byteio-littleshort-inline-function-littleshort-value-src-miniquake2-qcommon-byteio-ml-2094781886"></a>
### littleShort

```ml
inline function littleShort(value)
```

The supported MiniQuake2 release platform is little-endian Windows x64.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/byteio.ml#L352)

<a id="function-function-miniquake2-qcommon-byteio-longswap-function-longswap-value-src-miniquake2-qcommon-byteio-ml-315409159"></a>
### longSwap

```ml
function longSwap(value)
```

Swap long.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/byteio.ml#L341)

<a id="function-function-miniquake2-qcommon-byteio-poweroftwo-function-poweroftwo-exponent-src-miniquake2-qcommon-byteio-ml-143934915"></a>
### powerOfTwo

```ml
function powerOfTwo(exponent)
```

Return the power of two value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `exponent` | `dynamic` | — | exponent value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/byteio.ml#L216)

<a id="function-function-miniquake2-qcommon-byteio-putf32-inline-function-putf32-data-offset-value-src-miniquake2-qcommon-byteio-ml-122697913"></a>
### putF32

```ml
inline function putF32(data, offset, value)
```

Write f 32.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `data` | `dynamic` | — | Input data consumed by the operation. |
| `offset` | `dynamic` | — | Zero-based offset at which processing starts. |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/byteio.ml#L327)

<a id="function-function-miniquake2-qcommon-byteio-puti16-inline-function-puti16-data-offset-value-src-miniquake2-qcommon-byteio-ml-1422667211"></a>
### putI16

```ml
inline function putI16(data, offset, value)
```

Write i 16.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `data` | `dynamic` | — | Input data consumed by the operation. |
| `offset` | `dynamic` | — | Zero-based offset at which processing starts. |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/byteio.ml#L117)

<a id="function-function-miniquake2-qcommon-byteio-puti32-inline-function-puti32-data-offset-value-src-miniquake2-qcommon-byteio-ml-721911427"></a>
### putI32

```ml
inline function putI32(data, offset, value)
```

Write i 32.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `data` | `dynamic` | — | Input data consumed by the operation. |
| `offset` | `dynamic` | — | Zero-based offset at which processing starts. |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/byteio.ml#L139)

<a id="function-function-miniquake2-qcommon-byteio-puti8-inline-function-puti8-data-offset-value-src-miniquake2-qcommon-byteio-ml-1157429359"></a>
### putI8

```ml
inline function putI8(data, offset, value)
```

Write i 8.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `data` | `dynamic` | — | Input data consumed by the operation. |
| `offset` | `dynamic` | — | Zero-based offset at which processing starts. |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/byteio.ml#L97)

<a id="function-function-miniquake2-qcommon-byteio-putu16-inline-function-putu16-data-offset-value-src-miniquake2-qcommon-byteio-ml-984019539"></a>
### putU16

```ml
inline function putU16(data, offset, value)
```

Write u 16.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `data` | `dynamic` | — | Input data consumed by the operation. |
| `offset` | `dynamic` | — | Zero-based offset at which processing starts. |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/byteio.ml#L105)

<a id="function-function-miniquake2-qcommon-byteio-putu32-function-putu32-data-offset-value-src-miniquake2-qcommon-byteio-ml-901074030"></a>
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


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/byteio.ml#L125)

<a id="function-function-miniquake2-qcommon-byteio-putu8-inline-function-putu8-data-offset-value-src-miniquake2-qcommon-byteio-ml-762853119"></a>
### putU8

```ml
inline function putU8(data, offset, value)
```

Write u 8.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `data` | `dynamic` | — | Input data consumed by the operation. |
| `offset` | `dynamic` | — | Zero-based offset at which processing starts. |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/byteio.ml#L86)

<a id="function-function-miniquake2-qcommon-byteio-requirerange-function-requirerange-data-offset-count-src-miniquake2-qcommon-byteio-ml-1252776456"></a>
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


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/byteio.ml#L17)

<a id="function-function-miniquake2-qcommon-byteio-shortswap-function-shortswap-value-src-miniquake2-qcommon-byteio-ml-1726635953"></a>
### shortSwap

```ml
function shortSwap(value)
```

Swap short.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/byteio.ml#L333)

<a id="function-function-miniquake2-qcommon-byteio-shouldroundup-function-shouldroundup-remainder-leastbit-src-miniquake2-qcommon-byteio-ml-1182247457"></a>
### shouldRoundUp

```ml
function shouldRoundUp(remainder, leastBit)
```

Round a binary fractional tail to nearest, ties to even.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `remainder` | `dynamic` | — | remainder value consumed by this operation. |
| `leastBit` | `dynamic` | — | leastBit value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/byteio.ml#L192)

<a id="function-function-miniquake2-qcommon-byteio-truncint-function-truncint-value-src-miniquake2-qcommon-byteio-ml-1043415371"></a>
### truncInt

```ml
function truncInt(value)
```

Convert an integer or finite MiniLang float to a C-style truncating int. Constructing the result bit by bit avoids a native float-to-int helper.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/byteio.ml#L163)

<a id="function-function-miniquake2-qcommon-byteio-u16-inline-function-u16-data-offset-src-miniquake2-qcommon-byteio-ml-650876256"></a>
### u16

```ml
inline function u16(data, offset)
```

Return the u 16 value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `data` | `dynamic` | — | Input data consumed by the operation. |
| `offset` | `dynamic` | — | Zero-based offset at which processing starts. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/byteio.ml#L48)

<a id="function-function-miniquake2-qcommon-byteio-u32-function-u32-data-offset-src-miniquake2-qcommon-byteio-ml-1874963379"></a>
### u32

```ml
function u32(data, offset)
```

Return the u 32 value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `data` | `dynamic` | — | Input data consumed by the operation. |
| `offset` | `dynamic` | — | Zero-based offset at which processing starts. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/byteio.ml#L65)

<a id="function-function-miniquake2-qcommon-byteio-u8-inline-function-u8-data-offset-src-miniquake2-qcommon-byteio-ml-397167780"></a>
### u8

```ml
inline function u8(data, offset)
```

Return the u 8 value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `data` | `dynamic` | — | Input data consumed by the operation. |
| `offset` | `dynamic` | — | Zero-based offset at which processing starts. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/byteio.ml#L31)
