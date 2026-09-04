# `src/miniquake2/format/md2.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 format md2 facilities for this project.

Package: [`miniquake2.format.md2`](Package-miniquake2-format-md2-658439219.md)

Reachable from entry: **yes**

## Imports

- `miniquake2/format/binary.ml` as `fbio` → [src/miniquake2/format/binary.ml](File-src-miniquake2-format-binary-ml-1080216281.md)
- `miniquake2/format/constants.ml` as `fc` → [src/miniquake2/format/constants.ml](File-src-miniquake2-format-constants-ml-1556940367.md)
- `miniquake2/format/types.ml` as `ft` → [src/miniquake2/format/types.ml](File-src-miniquake2-format-types-ml-129451131.md)

## Declarations

<a id="function-function-miniquake2-format-md2-checkedsection-function-checkedsection-data-offset-count-stride-name-src-miniquake2-format-md2-ml-387899900"></a>
### checkedSection

```ml
function checkedSection(data, offset, count, stride, name)
```

Return the checked section value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `data` | `dynamic` | — | Input data consumed by the operation. |
| `offset` | `dynamic` | — | Zero-based offset at which processing starts. |
| `count` | `dynamic` | — | Number of items or units to process. |
| `stride` | `dynamic` | — | stride value consumed by this operation. |
| `name` | `dynamic` | — | Name of the affected item. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/format/md2.ml#L20)

<a id="function-function-miniquake2-format-md2-parse-function-parse-data-name-src-miniquake2-format-md2-ml-443650347"></a>
### parse

```ml
function parse(data, name)
```

Parses parse for the miniquake2 format md2 workflow.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `data` | `dynamic` | — | Input data consumed by the operation. |
| `name` | `dynamic` | — | Name of the affected item. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/format/md2.ml#L30)
