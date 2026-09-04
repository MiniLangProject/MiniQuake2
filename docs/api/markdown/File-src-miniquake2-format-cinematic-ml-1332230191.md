# `src/miniquake2/format/cinematic.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 format cinematic facilities for this project.

Package: [`miniquake2.format.cinematic`](Package-miniquake2-format-cinematic-445121519.md)

Reachable from entry: **yes**

## Imports

- `miniquake2/format/binary.ml` as `fbio` → [src/miniquake2/format/binary.ml](File-src-miniquake2-format-binary-ml-1080216281.md)
- `miniquake2/format/types.ml` as `ft` → [src/miniquake2/format/types.ml](File-src-miniquake2-format-types-ml-129451131.md)

## Declarations

<a id="function-function-miniquake2-format-cinematic-buildtables-function-buildtables-header-src-miniquake2-format-cinematic-ml-118508061"></a>
### buildTables

```ml
function buildTables(header)
```

Build tables.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `header` | `dynamic` | — | header value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/format/cinematic.ml#L88)

<a id="function-function-miniquake2-format-cinematic-buildtree-function-buildtree-countrow-src-miniquake2-format-cinematic-ml-1298359967"></a>
### buildTree

```ml
function buildTree(countRow)
```

Build tree.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `countRow` | `dynamic` | — | countRow value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/format/cinematic.ml#L55)

<a id="function-function-miniquake2-format-cinematic-decompress-function-decompress-compressed-tables-maximumoutput-src-miniquake2-format-cinematic-ml-725181159"></a>
### decompress

```ml
function decompress(compressed, tables, maximumOutput)
```

Decompress state.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `compressed` | `dynamic` | — | compressed value consumed by this operation. |
| `tables` | `dynamic` | — | tables value consumed by this operation. |
| `maximumOutput` | `dynamic` | — | maximumOutput value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/format/cinematic.ml#L103)

<a id="constant-constant-miniquake2-format-cinematic-header-bytes-const-header-bytes-20-huffman-count-bytes-src-miniquake2-format-cinematic-ml-1862168285"></a>
### HEADER_BYTES

```ml
const HEADER_BYTES = 20 + HUFFMAN_COUNT_BYTES
```

Defines the header bytes constant used by the miniquake2 format cinematic module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/format/cinematic.ml#L16)

<a id="constant-constant-miniquake2-format-cinematic-huffman-count-bytes-const-huffman-count-bytes-256-256-src-miniquake2-format-cinematic-ml-1950696983"></a>
### HUFFMAN_COUNT_BYTES

```ml
const HUFFMAN_COUNT_BYTES = 256 * 256
```

Defines the huffman count bytes constant used by the miniquake2 format cinematic module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/format/cinematic.ml#L14)

<a id="function-function-miniquake2-format-cinematic-parseheader-function-parseheader-data-src-miniquake2-format-cinematic-ml-105116326"></a>
### parseHeader

```ml
function parseHeader(data)
```

Parse header.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `data` | `dynamic` | — | Input data consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/format/cinematic.ml#L20)

<a id="function-function-miniquake2-format-cinematic-readframe-function-readframe-data-offset-framenumber-header-tables-src-miniquake2-format-cinematic-ml-59538075"></a>
### readFrame

```ml
function readFrame(data, offset, frameNumber, header, tables)
```

Reads frame for the miniquake2 format cinematic workflow.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `data` | `dynamic` | — | Input data consumed by the operation. |
| `offset` | `dynamic` | — | Zero-based offset at which processing starts. |
| `frameNumber` | `dynamic` | — | frameNumber value consumed by this operation. |
| `header` | `dynamic` | — | header value consumed by this operation. |
| `tables` | `dynamic` | — | tables value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/format/cinematic.ml#L139)

<a id="function-function-miniquake2-format-cinematic-smallestnode-function-smallestnode-counts-used-count-src-miniquake2-format-cinematic-ml-429890644"></a>
### smallestNode

```ml
function smallestNode(counts, used, count)
```

Return the smallest node value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `counts` | `dynamic` | — | counts value consumed by this operation. |
| `used` | `dynamic` | — | used value consumed by this operation. |
| `count` | `dynamic` | — | Number of items or units to process. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/format/cinematic.ml#L38)
