# `src/miniquake2/network/runtime/checksum.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 network runtime checksum facilities for this project.

Package: [`miniquake2.network.runtime.checksum`](Package-miniquake2-network-runtime-checksum-1151855350.md)

Reachable from entry: **yes**

## Imports

- `miniquake2/qcommon/byteio.ml` as `qbio` → [src/miniquake2/qcommon/byteio.ml](File-src-miniquake2-qcommon-byteio-ml-159119335.md)
- `miniquake2/qcommon/crc.ml` as `qcrc` → [src/miniquake2/qcommon/crc.ml](File-src-miniquake2-qcommon-crc-ml-1741435891.md)

## Declarations

<a id="function-function-miniquake2-network-runtime-checksum-blocksequence-function-blocksequence-data-offset-count-sequence-src-miniquake2-network-runtime-checksum-ml-202788012"></a>
### blockSequence

```ml
function blockSequence(data, offset, count, sequence)
```

Return the block sequence value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `data` | `dynamic` | — | Input data consumed by the operation. |
| `offset` | `dynamic` | — | Zero-based offset at which processing starts. |
| `count` | `dynamic` | — | Number of items or units to process. |
| `sequence` | `dynamic` | — | sequence value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/runtime/checksum.ml#L91)

<a id="function-function-miniquake2-network-runtime-checksum-table-function-table-src-miniquake2-network-runtime-checksum-ml-1238054111"></a>
### table

```ml
function table()
```

Return the table value.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/network/runtime/checksum.ml#L14)
