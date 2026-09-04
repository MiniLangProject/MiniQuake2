# `src/miniquake2/renderer/classic/materials.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 renderer classic materials facilities for this project.

Package: [`miniquake2.renderer.classic.materials`](Package-miniquake2-renderer-classic-materials-666326966.md)

Reachable from entry: **yes**

## Imports

- `miniquake2/format/constants.ml` as `fc` → [src/miniquake2/format/constants.ml](File-src-miniquake2-format-constants-ml-1556940367.md)
- `miniquake2/qcommon/text.ml` as `qtext` → [src/miniquake2/qcommon/text.ml](File-src-miniquake2-qcommon-text-ml-1570504148.md)
- `miniquake2/renderer/classic/constants.ml` as `rclassicconstants` → [src/miniquake2/renderer/classic/constants.ml](File-src-miniquake2-renderer-classic-constants-ml-1818163902.md)
- `miniquake2/renderer/classic/types.ml` as `rclassictypes` → [src/miniquake2/renderer/classic/types.ml](File-src-miniquake2-renderer-classic-types-ml-1346078158.md)
- `std/array.ml` as `rclassicarray` → `../MiniLangCompilerML/std/array.ml` — external dependency

## Declarations

<a id="function-function-miniquake2-renderer-classic-materials-alphaforflags-function-alphaforflags-flags-src-miniquake2-renderer-classic-materials-ml-822596248"></a>
### alphaForFlags

```ml
function alphaForFlags(flags)
```

Return the alpha for flags.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `flags` | `dynamic` | — | Bit flags controlling the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/classic/materials.ml#L113)

<a id="function-function-miniquake2-renderer-classic-materials-animatedimage-function-animatedimage-frames-entityframe-src-miniquake2-renderer-classic-materials-ml-1677300477"></a>
### animatedImage

```ml
function animatedImage(frames, entityFrame)
```

Return the animated image value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `frames` | `dynamic` | — | frames value consumed by this operation. |
| `entityFrame` | `dynamic` | — | entityFrame value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/classic/materials.ml#L148)

<a id="function-function-miniquake2-renderer-classic-materials-animationimages-function-animationimages-map-texinfoindex-images-src-miniquake2-renderer-classic-materials-ml-311984032"></a>
### animationImages

```ml
function animationImages(map, texInfoIndex, images)
```

Return the animation images value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `map` | `dynamic` | — | map value consumed by this operation. |
| `texInfoIndex` | `dynamic` | — | Zero-based index of tex info. |
| `images` | `dynamic` | — | images value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/classic/materials.ml#L123)

<a id="function-function-miniquake2-renderer-classic-materials-classify-function-classify-flags-src-miniquake2-renderer-classic-materials-ml-12380712"></a>
### classify

```ml
function classify(flags)
```

Return the classify value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `flags` | `dynamic` | — | Bit flags controlling the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/classic/materials.ml#L103)

<a id="function-function-miniquake2-renderer-classic-materials-findimage-function-findimage-images-name-src-miniquake2-renderer-classic-materials-ml-550724658"></a>
### findImage

```ml
function findImage(images, name)
```

Find image.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `images` | `dynamic` | — | images value consumed by this operation. |
| `name` | `dynamic` | — | Name of the affected item. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/classic/materials.ml#L85)

<a id="function-function-miniquake2-renderer-classic-materials-imagefrompcx-function-imagefrompcx-name-pcx-src-miniquake2-renderer-classic-materials-ml-2028916917"></a>
### imageFromPcx

```ml
function imageFromPcx(name, pcx)
```

Return the image from pcx.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `name` | `dynamic` | — | Name of the affected item. |
| `pcx` | `dynamic` | — | pcx value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/classic/materials.ml#L75)

<a id="function-function-miniquake2-renderer-classic-materials-imagefromwal-function-imagefromwal-wal-palette-src-miniquake2-renderer-classic-materials-ml-1577011884"></a>
### imageFromWal

```ml
function imageFromWal(wal, palette)
```

Return the image from wal.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `wal` | `dynamic` | — | wal value consumed by this operation. |
| `palette` | `dynamic` | — | palette value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/classic/materials.ml#L63)

<a id="function-function-miniquake2-renderer-classic-materials-imageorfallback-function-imageorfallback-images-name-src-miniquake2-renderer-classic-materials-ml-1246364582"></a>
### imageOrFallback

```ml
function imageOrFallback(images, name)
```

Return the image or fallback value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `images` | `dynamic` | — | images value consumed by this operation. |
| `name` | `dynamic` | — | Name of the affected item. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/classic/materials.ml#L95)

<a id="function-function-miniquake2-renderer-classic-materials-rgbafromindexed-function-rgbafromindexed-pixels-palette-src-miniquake2-renderer-classic-materials-ml-1326559741"></a>
### rgbaFromIndexed

```ml
function rgbaFromIndexed(pixels, palette)
```

Return the rgba from indexed.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `pixels` | `dynamic` | — | pixels value consumed by this operation. |
| `palette` | `dynamic` | — | palette value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/classic/materials.ml#L19)

<a id="function-function-miniquake2-renderer-classic-materials-rgbafromindexedintensity-function-rgbafromindexedintensity-pixels-palette-intensity-src-miniquake2-renderer-classic-materials-ml-1290937734"></a>
### rgbaFromIndexedIntensity

```ml
function rgbaFromIndexedIntensity(pixels, palette, intensity)
```

ref_gl uploads mipmapped world/model textures through its intensity table. The stock default is 2; sky and 2-D pictures deliberately stay unscaled.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `pixels` | `dynamic` | — | pixels value consumed by this operation. |
| `palette` | `dynamic` | — | palette value consumed by this operation. |
| `intensity` | `dynamic` | — | intensity value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/classic/materials.ml#L41)
