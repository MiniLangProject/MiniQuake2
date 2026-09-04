# `src/miniquake2/format/bsp.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 format bsp facilities for this project.

Package: [`miniquake2.format.bsp`](Package-miniquake2-format-bsp-1376766387.md)

Reachable from entry: **yes**

## Imports

- `miniquake2/format/binary.ml` as `fbio` → [src/miniquake2/format/binary.ml](File-src-miniquake2-format-binary-ml-1080216281.md)
- `miniquake2/format/constants.ml` as `fc` → [src/miniquake2/format/constants.ml](File-src-miniquake2-format-constants-ml-1556940367.md)
- `miniquake2/format/types.ml` as `ft` → [src/miniquake2/format/types.ml](File-src-miniquake2-format-types-ml-129451131.md)

## Declarations

<a id="function-function-miniquake2-format-bsp-decompressvisibility-function-decompressvisibility-visibility-cluster-kind-src-miniquake2-format-bsp-ml-2140751536"></a>
### decompressVisibility

```ml
function decompressVisibility(visibility, cluster, kind)
```

Decompress visibility.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `visibility` | `dynamic` | — | visibility value consumed by this operation. |
| `cluster` | `dynamic` | — | cluster value consumed by this operation. |
| `kind` | `dynamic` | — | kind value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/format/bsp.ml#L165)

<a id="function-function-miniquake2-format-bsp-emptyarray-function-emptyarray-count-src-miniquake2-format-bsp-ml-2087929451"></a>
### emptyArray

```ml
function emptyArray(count)
```

Report whether empty array.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `count` | `dynamic` | — | Number of items or units to process. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/format/bsp.ml#L16)

<a id="function-function-miniquake2-format-bsp-parse-function-parse-data-name-src-miniquake2-format-bsp-ml-1814676147"></a>
### parse

```ml
function parse(data, name)
```

Parses parse for the miniquake2 format bsp workflow.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `data` | `dynamic` | — | Input data consumed by the operation. |
| `name` | `dynamic` | — | Name of the affected item. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/format/bsp.ml#L542)

<a id="function-function-miniquake2-format-bsp-parseareaportals-function-parseareaportals-data-lump-src-miniquake2-format-bsp-ml-1598320464"></a>
### parseAreaPortals

```ml
function parseAreaPortals(data, lump)
```

Parse area portals.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `data` | `dynamic` | — | Input data consumed by the operation. |
| `lump` | `dynamic` | — | lump value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/format/bsp.ml#L461)

<a id="function-function-miniquake2-format-bsp-parseareas-function-parseareas-data-lump-src-miniquake2-format-bsp-ml-60468244"></a>
### parseAreas

```ml
function parseAreas(data, lump)
```

Parse areas.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `data` | `dynamic` | — | Input data consumed by the operation. |
| `lump` | `dynamic` | — | lump value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/format/bsp.ml#L441)

<a id="function-function-miniquake2-format-bsp-parsebrushes-function-parsebrushes-data-lump-src-miniquake2-format-bsp-ml-78764440"></a>
### parseBrushes

```ml
function parseBrushes(data, lump)
```

Parse brushes.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `data` | `dynamic` | — | Input data consumed by the operation. |
| `lump` | `dynamic` | — | lump value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/format/bsp.ml#L400)

<a id="function-function-miniquake2-format-bsp-parsebrushsides-function-parsebrushsides-data-lump-src-miniquake2-format-bsp-ml-149452590"></a>
### parseBrushSides

```ml
function parseBrushSides(data, lump)
```

Parse brush sides.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `data` | `dynamic` | — | Input data consumed by the operation. |
| `lump` | `dynamic` | — | lump value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/format/bsp.ml#L421)

<a id="function-function-miniquake2-format-bsp-parseedges-function-parseedges-data-lump-src-miniquake2-format-bsp-ml-900860584"></a>
### parseEdges

```ml
function parseEdges(data, lump)
```

Parse edges.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `data` | `dynamic` | — | Input data consumed by the operation. |
| `lump` | `dynamic` | — | lump value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/format/bsp.ml#L349)

<a id="function-function-miniquake2-format-bsp-parsefaces-function-parsefaces-data-lump-src-miniquake2-format-bsp-ml-1180054840"></a>
### parseFaces

```ml
function parseFaces(data, lump)
```

Parse faces.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `data` | `dynamic` | — | Input data consumed by the operation. |
| `lump` | `dynamic` | — | lump value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/format/bsp.ml#L255)

<a id="function-function-miniquake2-format-bsp-parsei32array-function-parsei32array-data-lump-name-src-miniquake2-format-bsp-ml-460822631"></a>
### parseI32Array

```ml
function parseI32Array(data, lump, name)
```

Parse i 32 array.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `data` | `dynamic` | — | Input data consumed by the operation. |
| `lump` | `dynamic` | — | lump value consumed by this operation. |
| `name` | `dynamic` | — | Name of the affected item. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/format/bsp.ml#L333)

<a id="function-function-miniquake2-format-bsp-parseleafs-function-parseleafs-data-lump-src-miniquake2-format-bsp-ml-1412861884"></a>
### parseLeafs

```ml
function parseLeafs(data, lump)
```

Parse leafs.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `data` | `dynamic` | — | Input data consumed by the operation. |
| `lump` | `dynamic` | — | lump value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/format/bsp.ml#L283)

<a id="function-function-miniquake2-format-bsp-parselumps-function-parselumps-data-src-miniquake2-format-bsp-ml-1239253082"></a>
### parseLumps

```ml
function parseLumps(data)
```

Parse lumps.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `data` | `dynamic` | — | Input data consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/format/bsp.ml#L22)

<a id="function-function-miniquake2-format-bsp-parsemodels-function-parsemodels-data-lump-src-miniquake2-format-bsp-ml-340492198"></a>
### parseModels

```ml
function parseModels(data, lump)
```

Parse models.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `data` | `dynamic` | — | Input data consumed by the operation. |
| `lump` | `dynamic` | — | lump value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/format/bsp.ml#L369)

<a id="function-function-miniquake2-format-bsp-parsenodes-function-parsenodes-data-lump-src-miniquake2-format-bsp-ml-813426552"></a>
### parseNodes

```ml
function parseNodes(data, lump)
```

Parse nodes.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `data` | `dynamic` | — | Input data consumed by the operation. |
| `lump` | `dynamic` | — | lump value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/format/bsp.ml#L194)

<a id="function-function-miniquake2-format-bsp-parseplanes-function-parseplanes-data-lump-src-miniquake2-format-bsp-ml-683367848"></a>
### parsePlanes

```ml
function parsePlanes(data, lump)
```

Parse planes.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `data` | `dynamic` | — | Input data consumed by the operation. |
| `lump` | `dynamic` | — | lump value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/format/bsp.ml#L79)

<a id="function-function-miniquake2-format-bsp-parsetexinfo-function-parsetexinfo-data-lump-src-miniquake2-format-bsp-ml-1100970848"></a>
### parseTexInfo

```ml
function parseTexInfo(data, lump)
```

Parse tex info.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `data` | `dynamic` | — | Input data consumed by the operation. |
| `lump` | `dynamic` | — | lump value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/format/bsp.ml#L224)

<a id="function-function-miniquake2-format-bsp-parseu16array-function-parseu16array-data-lump-name-src-miniquake2-format-bsp-ml-1939303763"></a>
### parseU16Array

```ml
function parseU16Array(data, lump, name)
```

Parse u 16 array.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `data` | `dynamic` | — | Input data consumed by the operation. |
| `lump` | `dynamic` | — | lump value consumed by this operation. |
| `name` | `dynamic` | — | Name of the affected item. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/format/bsp.ml#L316)

<a id="function-function-miniquake2-format-bsp-parsevertices-function-parsevertices-data-lump-src-miniquake2-format-bsp-ml-383717464"></a>
### parseVertices

```ml
function parseVertices(data, lump)
```

Parse vertices.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `data` | `dynamic` | — | Input data consumed by the operation. |
| `lump` | `dynamic` | — | lump value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/format/bsp.ml#L103)

<a id="function-function-miniquake2-format-bsp-parsevisibility-function-parsevisibility-data-lump-src-miniquake2-format-bsp-ml-1964350054"></a>
### parseVisibility

```ml
function parseVisibility(data, lump)
```

Parse visibility.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `data` | `dynamic` | — | Input data consumed by the operation. |
| `lump` | `dynamic` | — | lump value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/format/bsp.ml#L124)

<a id="function-function-miniquake2-format-bsp-requirestride-function-requirestride-lump-stride-name-src-miniquake2-format-bsp-ml-67742738"></a>
### requireStride

```ml
function requireStride(lump, stride, name)
```

Require stride.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `lump` | `dynamic` | — | lump value consumed by this operation. |
| `stride` | `dynamic` | — | stride value consumed by this operation. |
| `name` | `dynamic` | — | Name of the affected item. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/format/bsp.ml#L47)

<a id="function-function-miniquake2-format-bsp-validatereferences-function-validatereferences-bspmaptovalidate-src-miniquake2-format-bsp-ml-407270804"></a>
### validateReferences

```ml
function validateReferences(bspMapToValidate)
```

Validate references.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `bspMapToValidate` | `dynamic` | — | bspMapToValidate value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/format/bsp.ml#L480)

<a id="function-function-miniquake2-format-bsp-vec3f-function-vec3f-data-offset-src-miniquake2-format-bsp-ml-2047012975"></a>
### vec3f

```ml
function vec3f(data, offset)
```

Return the vec 3 f value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `data` | `dynamic` | — | Input data consumed by the operation. |
| `offset` | `dynamic` | — | Zero-based offset at which processing starts. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/format/bsp.ml#L55)

<a id="function-function-miniquake2-format-bsp-vec3s-function-vec3s-data-offset-src-miniquake2-format-bsp-ml-495757549"></a>
### vec3s

```ml
function vec3s(data, offset)
```

Return the vec 3 s value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `data` | `dynamic` | — | Input data consumed by the operation. |
| `offset` | `dynamic` | — | Zero-based offset at which processing starts. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/format/bsp.ml#L67)
