# `src/miniquake2/renderer/assets.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 renderer assets facilities for this project.

Package: [`miniquake2.renderer.assets`](Package-miniquake2-renderer-assets-1716151503.md)

Reachable from entry: **yes**

## Imports

- `miniquake2/format/bsp.ml` as `fbsp` → [src/miniquake2/format/bsp.ml](File-src-miniquake2-format-bsp-ml-2080213539.md)
- `miniquake2/format/md2.ml` as `fmd2` → [src/miniquake2/format/md2.ml](File-src-miniquake2-format-md2-ml-1028614507.md)
- `miniquake2/format/pcx.ml` as `fpcx` → [src/miniquake2/format/pcx.ml](File-src-miniquake2-format-pcx-ml-1818682253.md)
- `miniquake2/format/sprite.ml` as `fsprite` → [src/miniquake2/format/sprite.ml](File-src-miniquake2-format-sprite-ml-1376398661.md)
- `miniquake2/format/wal.ml` as `fwal` → [src/miniquake2/format/wal.ml](File-src-miniquake2-format-wal-ml-418469116.md)
- `miniquake2/qcommon/text.ml` as `qtext` → [src/miniquake2/qcommon/text.ml](File-src-miniquake2-qcommon-text-ml-1570504148.md)
- `miniquake2/renderer/geometry.ml` as `rgeom` → [src/miniquake2/renderer/geometry.ml](File-src-miniquake2-renderer-geometry-ml-1941312570.md)
- `miniquake2/renderer/types.ml` as `rt` → [src/miniquake2/renderer/types.ml](File-src-miniquake2-renderer-types-ml-975707623.md)

## Declarations

<a id="function-function-miniquake2-renderer-assets-adoptbspmodel-function-adoptbspmodel-registry-map-name-src-miniquake2-renderer-assets-ml-1714029404"></a>
### adoptBspModel

```ml
function adoptBspModel(registry, map, name)
```

Return the adopt bsp model value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `registry` | `dynamic` | — | registry value consumed by this operation. |
| `map` | `dynamic` | — | map value consumed by this operation. |
| `name` | `dynamic` | — | Name of the affected item. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/assets.ml#L228)

- [miniquake2.renderer.assets.AssetRegistry](Type-miniquake2-renderer-assets-assetregistry-142150894.md) — struct
<a id="function-function-miniquake2-renderer-assets-beginregistration-function-beginregistration-registry-src-miniquake2-renderer-assets-ml-940314307"></a>
### beginRegistration

```ml
function beginRegistration(registry)
```

Begin registration.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `registry` | `dynamic` | — | registry value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/assets.ml#L334)

<a id="function-function-miniquake2-renderer-assets-create-function-create-src-miniquake2-renderer-assets-ml-995296558"></a>
### create

```ml
function create()
```

Creates create for the miniquake2 renderer assets module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/assets.ml#L73)

<a id="function-function-miniquake2-renderer-assets-endswith-function-endswith-value-suffix-src-miniquake2-renderer-assets-ml-1928848576"></a>
### endsWith

```ml
function endsWith(value, suffix)
```

Return the ends with value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |
| `suffix` | `dynamic` | — | suffix value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/assets.ml#L80)

<a id="function-function-miniquake2-renderer-assets-findmodel-function-findmodel-registry-name-src-miniquake2-renderer-assets-ml-1166782162"></a>
### findModel

```ml
function findModel(registry, name)
```

Find model.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `registry` | `dynamic` | — | registry value consumed by this operation. |
| `name` | `dynamic` | — | Name of the affected item. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/assets.ml#L106)

<a id="function-function-miniquake2-renderer-assets-findmodelbyhandle-inline-function-findmodelbyhandle-registry-handle-src-miniquake2-renderer-assets-ml-1915017376"></a>
### findModelByHandle

```ml
inline function findModelByHandle(registry, handle)
```

Find model by handle.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `registry` | `dynamic` | — | registry value consumed by this operation. |
| `handle` | `dynamic` | — | Native or runtime handle used by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/assets.ml#L138)

<a id="function-function-miniquake2-renderer-assets-findpicture-function-findpicture-registry-name-src-miniquake2-renderer-assets-ml-1058224116"></a>
### findPicture

```ml
function findPicture(registry, name)
```

Find picture.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `registry` | `dynamic` | — | registry value consumed by this operation. |
| `name` | `dynamic` | — | Name of the affected item. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/assets.ml#L116)

<a id="function-function-miniquake2-renderer-assets-findpicturebyhandle-inline-function-findpicturebyhandle-registry-handle-src-miniquake2-renderer-assets-ml-2117901000"></a>
### findPictureByHandle

```ml
inline function findPictureByHandle(registry, handle)
```

Find picture by handle.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `registry` | `dynamic` | — | registry value consumed by this operation. |
| `handle` | `dynamic` | — | Native or runtime handle used by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/assets.ml#L159)

<a id="function-function-miniquake2-renderer-assets-loadbytes-function-loadbytes-imports-name-src-miniquake2-renderer-assets-ml-2040970405"></a>
### loadBytes

```ml
function loadBytes(imports, name)
```

Load bytes.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `imports` | `dynamic` | — | imports value consumed by this operation. |
| `name` | `dynamic` | — | Name of the affected item. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/assets.ml#L247)

<a id="constant-constant-miniquake2-renderer-assets-max-registered-resources-const-max-registered-resources-4096-src-miniquake2-renderer-assets-ml-1472979878"></a>
### MAX_REGISTERED_RESOURCES

```ml
const MAX_REGISTERED_RESOURCES = 4096
```

Defines the max registered resources constant used by the miniquake2 renderer assets module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/assets.ml#L70)

<a id="function-function-miniquake2-renderer-assets-md2framebounds-function-md2framebounds-model-src-miniquake2-renderer-assets-ml-2045074543"></a>
### md2FrameBounds

```ml
function md2FrameBounds(model)
```

Return the md 2 frame bounds.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `model` | `dynamic` | — | model value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/assets.ml#L214)

- [miniquake2.renderer.assets.ModelAsset](Type-miniquake2-renderer-assets-modelasset-2060896832.md) — struct
<a id="function-function-miniquake2-renderer-assets-modelforhandle-function-modelforhandle-registry-handle-src-miniquake2-renderer-assets-ml-498109409"></a>
### modelForHandle

```ml
function modelForHandle(registry, handle)
```

Handle model for.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `registry` | `dynamic` | — | registry value consumed by this operation. |
| `handle` | `dynamic` | — | Native or runtime handle used by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/assets.ml#L150)

<a id="function-function-miniquake2-renderer-assets-nexthandle-function-nexthandle-registry-kind-name-src-miniquake2-renderer-assets-ml-2061873492"></a>
### nextHandle

```ml
function nextHandle(registry, kind, name)
```

Handle next.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `registry` | `dynamic` | — | registry value consumed by this operation. |
| `kind` | `dynamic` | — | kind value consumed by this operation. |
| `name` | `dynamic` | — | Name of the affected item. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/assets.ml#L97)

- [miniquake2.renderer.assets.PictureAsset](Type-miniquake2-renderer-assets-pictureasset-1941409965.md) — struct
<a id="function-function-miniquake2-renderer-assets-picturefilename-function-picturefilename-name-src-miniquake2-renderer-assets-ml-1741175857"></a>
### pictureFileName

```ml
function pictureFileName(name)
```

The public Renderer API uses extension-less picture names (for example `i_health` and `m_main_logo`).  Files on disk retain the classic `pics/<name>.pcx` layout.  Model skins and WAL materials already arrive as complete qpaths and must remain unchanged.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `name` | `dynamic` | — | Name of the affected item. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/assets.ml#L258)

<a id="function-function-miniquake2-renderer-assets-pictureforhandle-function-pictureforhandle-registry-handle-src-miniquake2-renderer-assets-ml-1823927497"></a>
### pictureForHandle

```ml
function pictureForHandle(registry, handle)
```

Handle picture for.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `registry` | `dynamic` | — | registry value consumed by this operation. |
| `handle` | `dynamic` | — | Native or runtime handle used by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/assets.ml#L171)

<a id="function-function-miniquake2-renderer-assets-registermd2skins-function-registermd2skins-registry-imports-model-src-miniquake2-renderer-assets-ml-878001258"></a>
### registerMd2Skins

```ml
function registerMd2Skins(registry, imports, model)
```

Register md 2 skins.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `registry` | `dynamic` | — | registry value consumed by this operation. |
| `imports` | `dynamic` | — | imports value consumed by this operation. |
| `model` | `dynamic` | — | model value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/assets.ml#L181)

<a id="function-function-miniquake2-renderer-assets-registermodel-function-registermodel-registry-imports-name-src-miniquake2-renderer-assets-ml-9982556"></a>
### registerModel

```ml
function registerModel(registry, imports, name)
```

Register model.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `registry` | `dynamic` | — | registry value consumed by this operation. |
| `imports` | `dynamic` | — | imports value consumed by this operation. |
| `name` | `dynamic` | — | Name of the affected item. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/assets.ml#L267)

<a id="function-function-miniquake2-renderer-assets-registerpicture-function-registerpicture-registry-imports-name-src-miniquake2-renderer-assets-ml-2042750602"></a>
### registerPicture

```ml
function registerPicture(registry, imports, name)
```

Register picture.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `registry` | `dynamic` | — | registry value consumed by this operation. |
| `imports` | `dynamic` | — | imports value consumed by this operation. |
| `name` | `dynamic` | — | Name of the affected item. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/assets.ml#L314)

<a id="function-function-miniquake2-renderer-assets-registerspriteframes-function-registerspriteframes-registry-imports-model-src-miniquake2-renderer-assets-ml-1789845714"></a>
### registerSpriteFrames

```ml
function registerSpriteFrames(registry, imports, model)
```

Register sprite frames.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `registry` | `dynamic` | — | registry value consumed by this operation. |
| `imports` | `dynamic` | — | imports value consumed by this operation. |
| `model` | `dynamic` | — | model value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/assets.ml#L198)

<a id="function-function-miniquake2-renderer-assets-storeresource-function-storeresource-registry-asset-src-miniquake2-renderer-assets-ml-1978141425"></a>
### storeResource

```ml
function storeResource(registry, asset)
```

Return the store resource value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `registry` | `dynamic` | — | registry value consumed by this operation. |
| `asset` | `dynamic` | — | asset value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/assets.ml#L126)
