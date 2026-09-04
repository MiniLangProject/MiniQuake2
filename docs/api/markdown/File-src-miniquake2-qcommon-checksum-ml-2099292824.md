# `src/miniquake2/qcommon/checksum.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 qcommon checksum facilities for this project.

Package: [`miniquake2.qcommon.checksum`](Package-miniquake2-qcommon-checksum-479451564.md)

Reachable from entry: **yes**

## Imports

- `miniquake2/qcommon/byteio.ml` as `bio` → [src/miniquake2/qcommon/byteio.ml](File-src-miniquake2-qcommon-byteio-ml-159119335.md)

## Declarations

<a id="function-function-miniquake2-qcommon-checksum-add32-inline-function-add32-a-b-src-miniquake2-qcommon-checksum-ml-883201576"></a>
### add32

```ml
inline function add32(a, b)
```

Add 32.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `a` | `dynamic` | — | a value consumed by this operation. |
| `b` | `dynamic` | — | b value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/checksum.ml#L32)

<a id="function-function-miniquake2-qcommon-checksum-blockchecksum-function-blockchecksum-data-offset-count-src-miniquake2-qcommon-checksum-ml-644007272"></a>
### blockChecksum

```ml
function blockChecksum(data, offset, count)
```

Return the block checksum value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `data` | `dynamic` | — | Input data consumed by the operation. |
| `offset` | `dynamic` | — | Zero-based offset at which processing starts. |
| `count` | `dynamic` | — | Number of items or units to process. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/checksum.ml#L220)

<a id="function-function-miniquake2-qcommon-checksum-choose-inline-function-choose-x-y-z-src-miniquake2-qcommon-checksum-ml-2061586862"></a>
### choose

```ml
inline function choose(x, y, z)
```

Choose state.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `x` | `dynamic` | — | Horizontal coordinate used by the operation. |
| `y` | `dynamic` | — | Vertical coordinate used by the operation. |
| `z` | `dynamic` | — | z value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/checksum.ml#L48)

<a id="function-function-miniquake2-qcommon-checksum-com-blockchecksum-function-com-blockchecksum-data-offset-count-src-miniquake2-qcommon-checksum-ml-2120387244"></a>
### Com_BlockChecksum

```ml
function Com_BlockChecksum(data, offset, count)
```

Return the com block checksum value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `data` | `dynamic` | — | Input data consumed by the operation. |
| `offset` | `dynamic` | — | Zero-based offset at which processing starts. |
| `count` | `dynamic` | — | Number of items or units to process. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/checksum.ml#L229)

<a id="function-function-miniquake2-qcommon-checksum-majority-inline-function-majority-x-y-z-src-miniquake2-qcommon-checksum-ml-690979810"></a>
### majority

```ml
inline function majority(x, y, z)
```

Return the majority value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `x` | `dynamic` | — | Horizontal coordinate used by the operation. |
| `y` | `dynamic` | — | Vertical coordinate used by the operation. |
| `z` | `dynamic` | — | z value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/checksum.ml#L56)

<a id="function-function-miniquake2-qcommon-checksum-md4-function-md4-data-offset-count-src-miniquake2-qcommon-checksum-ml-1295535750"></a>
### md4

```ml
function md4(data, offset, count)
```

Return the md 4 value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `data` | `dynamic` | — | Input data consumed by the operation. |
| `offset` | `dynamic` | — | Zero-based offset at which processing starts. |
| `count` | `dynamic` | — | Number of items or units to process. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/checksum.ml#L188)

<a id="function-function-miniquake2-qcommon-checksum-parity-inline-function-parity-x-y-z-src-miniquake2-qcommon-checksum-ml-1033691038"></a>
### parity

```ml
inline function parity(x, y, z)
```

Return the parity value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `x` | `dynamic` | — | Horizontal coordinate used by the operation. |
| `y` | `dynamic` | — | Vertical coordinate used by the operation. |
| `z` | `dynamic` | — | z value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/checksum.ml#L64)

<a id="function-function-miniquake2-qcommon-checksum-rotateleft-inline-function-rotateleft-value-count-src-miniquake2-qcommon-checksum-ml-674220285"></a>
### rotateLeft

```ml
inline function rotateLeft(value, count)
```

Rotate left.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |
| `count` | `dynamic` | — | Number of items or units to process. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/checksum.ml#L39)

<a id="function-function-miniquake2-qcommon-checksum-round1-function-round1-a-b-c-d-word-shift-src-miniquake2-qcommon-checksum-ml-686286886"></a>
### round1

```ml
function round1(a, b, c, d, word, shift)
```

Return the round 1 value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `a` | `dynamic` | — | a value consumed by this operation. |
| `b` | `dynamic` | — | b value consumed by this operation. |
| `c` | `dynamic` | — | c value consumed by this operation. |
| `d` | `dynamic` | — | d value consumed by this operation. |
| `word` | `dynamic` | — | word value consumed by this operation. |
| `shift` | `dynamic` | — | shift value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/checksum.ml#L75)

<a id="function-function-miniquake2-qcommon-checksum-round2-function-round2-a-b-c-d-word-shift-src-miniquake2-qcommon-checksum-ml-1733116638"></a>
### round2

```ml
function round2(a, b, c, d, word, shift)
```

Return the round 2 value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `a` | `dynamic` | — | a value consumed by this operation. |
| `b` | `dynamic` | — | b value consumed by this operation. |
| `c` | `dynamic` | — | c value consumed by this operation. |
| `d` | `dynamic` | — | d value consumed by this operation. |
| `word` | `dynamic` | — | word value consumed by this operation. |
| `shift` | `dynamic` | — | shift value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/checksum.ml#L86)

<a id="function-function-miniquake2-qcommon-checksum-round3-function-round3-a-b-c-d-word-shift-src-miniquake2-qcommon-checksum-ml-259516958"></a>
### round3

```ml
function round3(a, b, c, d, word, shift)
```

Return the round 3 value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `a` | `dynamic` | — | a value consumed by this operation. |
| `b` | `dynamic` | — | b value consumed by this operation. |
| `c` | `dynamic` | — | c value consumed by this operation. |
| `d` | `dynamic` | — | d value consumed by this operation. |
| `word` | `dynamic` | — | word value consumed by this operation. |
| `shift` | `dynamic` | — | shift value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/checksum.ml#L98)

<a id="function-function-miniquake2-qcommon-checksum-transform-function-transform-state-block-offset-src-miniquake2-qcommon-checksum-ml-1072492919"></a>
### transform

```ml
function transform(state, block, offset)
```

Transform state.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |
| `block` | `dynamic` | — | block value consumed by this operation. |
| `offset` | `dynamic` | — | Zero-based offset at which processing starts. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/checksum.ml#L107)
