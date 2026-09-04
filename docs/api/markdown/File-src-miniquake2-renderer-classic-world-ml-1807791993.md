# `src/miniquake2/renderer/classic/world.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 renderer classic world facilities for this project.

Package: [`miniquake2.renderer.classic.world`](Package-miniquake2-renderer-classic-world-375877996.md)

Reachable from entry: **yes**

## Imports

- `miniquake2/format/pcx.ml` as `fpcx` → [src/miniquake2/format/pcx.ml](File-src-miniquake2-format-pcx-ml-1818682253.md)
- `miniquake2/format/types.ml` as `ft` → [src/miniquake2/format/types.ml](File-src-miniquake2-format-types-ml-129451131.md)
- `miniquake2/format/wal.ml` as `fwal` → [src/miniquake2/format/wal.ml](File-src-miniquake2-format-wal-ml-418469116.md)
- `miniquake2/qcommon/byteio.ml` as `rclassicworldbyteio` → [src/miniquake2/qcommon/byteio.ml](File-src-miniquake2-qcommon-byteio-ml-159119335.md)
- `miniquake2/qcommon/text.ml` as `qtext` → [src/miniquake2/qcommon/text.ml](File-src-miniquake2-qcommon-text-ml-1570504148.md)
- `miniquake2/renderer/classic/constants.ml` as `rclassicconstants` → [src/miniquake2/renderer/classic/constants.ml](File-src-miniquake2-renderer-classic-constants-ml-1818163902.md)
- `miniquake2/renderer/classic/materials.ml` as `rclassicmaterials` → [src/miniquake2/renderer/classic/materials.ml](File-src-miniquake2-renderer-classic-materials-ml-232284255.md)
- `miniquake2/renderer/classic/scene.ml` as `rclassicscene` → [src/miniquake2/renderer/classic/scene.ml](File-src-miniquake2-renderer-classic-scene-ml-949361389.md)
- `miniquake2/renderer/classic/special.ml` as `rclassicspecial` → [src/miniquake2/renderer/classic/special.ml](File-src-miniquake2-renderer-classic-special-ml-578081284.md)
- `miniquake2/renderer/classic/types.ml` as `rclassictypes` → [src/miniquake2/renderer/classic/types.ml](File-src-miniquake2-renderer-classic-types-ml-1346078158.md)
- `std/string.ml` as `rclassicworldstring` → `../MiniLangCompilerML/std/string.ml` — external dependency

## Declarations

<a id="function-function-miniquake2-renderer-classic-world-addbasetexture-function-addbasetexture-textures-image-generation-src-miniquake2-renderer-classic-world-ml-1331591768"></a>
### addBaseTexture

```ml
function addBaseTexture(textures, image, generation)
```

Add base texture.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `textures` | `dynamic` | — | textures value consumed by this operation. |
| `image` | `dynamic` | — | image value consumed by this operation. |
| `generation` | `dynamic` | — | generation value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/classic/world.ml#L121)

<a id="function-function-miniquake2-renderer-classic-world-addworlddraw-function-addworlddraw-textures-draws-surface-generation-src-miniquake2-renderer-classic-world-ml-1454140399"></a>
### addWorldDraw

```ml
function addWorldDraw(textures, draws, surface, generation)
```

Add world draw.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `textures` | `dynamic` | — | textures value consumed by this operation. |
| `draws` | `dynamic` | — | draws value consumed by this operation. |
| `surface` | `dynamic` | — | surface value consumed by this operation. |
| `generation` | `dynamic` | — | generation value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/classic/world.ml#L161)

<a id="function-function-miniquake2-renderer-classic-world-build-function-build-map-loadfile-lightstyles-entityframe-modulate-generation-src-miniquake2-renderer-classic-world-ml-2090276048"></a>
### build

```ml
function build(map, loadFile, lightStyles, entityFrame, modulate, generation)
```

Build state.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `map` | `dynamic` | — | map value consumed by this operation. |
| `loadFile` | `dynamic` | — | loadFile value consumed by this operation. |
| `lightStyles` | `dynamic` | — | lightStyles value consumed by this operation. |
| `entityFrame` | `dynamic` | — | entityFrame value consumed by this operation. |
| `modulate` | `dynamic` | — | modulate value consumed by this operation. |
| `generation` | `dynamic` | — | generation value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/classic/world.ml#L541)

<a id="function-function-miniquake2-renderer-classic-world-buildmodeldraws-function-buildmodeldraws-scene-textures-generation-model-src-miniquake2-renderer-classic-world-ml-1939918816"></a>
### buildModelDraws

```ml
function buildModelDraws(scene, textures, generation, model)
```

Build model draws.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `scene` | `dynamic` | — | scene value consumed by this operation. |
| `textures` | `dynamic` | — | textures value consumed by this operation. |
| `generation` | `dynamic` | — | generation value consumed by this operation. |
| `model` | `dynamic` | — | model value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/classic/world.ml#L495)

- [miniquake2.renderer.classic.world.ClassicTgaImage](Type-miniquake2-renderer-classic-world-classictgaimage-201999207.md) — struct
<a id="function-function-miniquake2-renderer-classic-world-classicworlddecodetga-function-classicworlddecodetga-data-path-src-miniquake2-renderer-classic-world-ml-1755026576"></a>
### classicWorldDecodeTga

```ml
function classicWorldDecodeTga(data, path)
```

Decode the uncompressed and RLE true-colour TGA variants accepted by ref_gl. The decoder remains MiniLang-owned so custom-server sky data is validated before it enters the renderer resource graph.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `data` | `dynamic` | — | Input data consumed by the operation. |
| `path` | `dynamic` | — | Path of the file or directory used by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/classic/world.ml#L392)

<a id="function-function-miniquake2-renderer-classic-world-classicworldentityvalue-function-classicworldentityvalue-entitytext-key-src-miniquake2-renderer-classic-world-ml-303113232"></a>
### classicWorldEntityValue

```ml
function classicWorldEntityValue(entityText, key)
```

Return the classic world entity value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entityText` | `dynamic` | — | entityText value consumed by this operation. |
| `key` | `dynamic` | — | key value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/classic/world.ml#L345)

<a id="function-function-miniquake2-renderer-classic-world-classicworldskyaxis-function-classicworldskyaxis-entitytext-src-miniquake2-renderer-classic-world-ml-562765647"></a>
### classicWorldSkyAxis

```ml
function classicWorldSkyAxis(entityText)
```

Return the classic world sky axis value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entityText` | `dynamic` | — | entityText value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/classic/world.ml#L358)

<a id="function-function-miniquake2-renderer-classic-world-classicworldskyrotate-function-classicworldskyrotate-entitytext-src-miniquake2-renderer-classic-world-ml-547820327"></a>
### classicWorldSkyRotate

```ml
function classicWorldSkyRotate(entityText)
```

Rotate classic world sky.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entityText` | `dynamic` | — | entityText value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/classic/world.ml#L379)

<a id="function-function-miniquake2-renderer-classic-world-classicworldskytexture-function-classicworldskytexture-loadfile-skyname-suffix-generation-fallbackpalette-src-miniquake2-renderer-classic-world-ml-1369548779"></a>
### classicWorldSkyTexture

```ml
function classicWorldSkyTexture(loadFile, skyName, suffix, generation, fallbackPalette)
```

Return the classic world sky texture value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `loadFile` | `dynamic` | — | loadFile value consumed by this operation. |
| `skyName` | `dynamic` | — | skyName value consumed by this operation. |
| `suffix` | `dynamic` | — | suffix value consumed by this operation. |
| `generation` | `dynamic` | — | generation value consumed by this operation. |
| `fallbackPalette` | `dynamic` | — | fallbackPalette value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/classic/world.ml#L448)

<a id="function-function-miniquake2-renderer-classic-world-configuresky-function-configuresky-world-loadfile-name-rotate-axis-src-miniquake2-renderer-classic-world-ml-718932404"></a>
### configureSky

```ml
function configureSky(world, loadFile, name, rotate, axis)
```

Configure sky.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `world` | `dynamic` | — | world value consumed by this operation. |
| `loadFile` | `dynamic` | — | loadFile value consumed by this operation. |
| `name` | `dynamic` | — | Name of the affected item. |
| `rotate` | `dynamic` | — | rotate value consumed by this operation. |
| `axis` | `dynamic` | — | axis value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/classic/world.ml#L473)

<a id="function-function-miniquake2-renderer-classic-world-copylightmapatlasrow-function-copylightmapatlasrow-destination-destinationpixel-source-sourcepixel-pixels-src-miniquake2-renderer-classic-world-ml-1849170298"></a>
### copyLightmapAtlasRow

```ml
function copyLightmapAtlasRow(destination, destinationPixel, source, sourcePixel, pixels)
```

Copy lightmap atlas row.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `destination` | `dynamic` | — | destination value consumed by this operation. |
| `destinationPixel` | `dynamic` | — | destinationPixel value consumed by this operation. |
| `source` | `dynamic` | — | source value consumed by this operation. |
| `sourcePixel` | `dynamic` | — | sourcePixel value consumed by this operation. |
| `pixels` | `dynamic` | — | pixels value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/classic/world.ml#L236)

<a id="function-function-miniquake2-renderer-classic-world-copylightmapintoatlas-function-copylightmapintoatlas-texture-x-y-width-height-source-src-miniquake2-renderer-classic-world-ml-899990093"></a>
### copyLightmapIntoAtlas

```ml
function copyLightmapIntoAtlas(texture, x, y, width, height, source)
```

Copy lightmap into atlas.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `texture` | `dynamic` | — | texture value consumed by this operation. |
| `x` | `dynamic` | — | Horizontal coordinate used by the operation. |
| `y` | `dynamic` | — | Vertical coordinate used by the operation. |
| `width` | `dynamic` | — | Width in the coordinate or storage units used by the caller. |
| `height` | `dynamic` | — | Height in the coordinate or storage units used by the caller. |
| `source` | `dynamic` | — | source value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/classic/world.ml#L250)

<a id="function-function-miniquake2-renderer-classic-world-findbrushmodel-function-findbrushmodel-world-modelindex-src-miniquake2-renderer-classic-world-ml-1732458120"></a>
### findBrushModel

```ml
function findBrushModel(world, modelIndex)
```

Find brush model.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `world` | `dynamic` | — | world value consumed by this operation. |
| `modelIndex` | `dynamic` | — | Zero-based index of model. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/classic/world.ml#L527)

<a id="function-function-miniquake2-renderer-classic-world-findtexture-function-findtexture-textures-role-name-src-miniquake2-renderer-classic-world-ml-1718959816"></a>
### findTexture

```ml
function findTexture(textures, role, name)
```

Find texture.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `textures` | `dynamic` | — | textures value consumed by this operation. |
| `role` | `dynamic` | — | role value consumed by this operation. |
| `name` | `dynamic` | — | Name of the affected item. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/classic/world.ml#L110)

<a id="constant-constant-miniquake2-renderer-classic-world-lightmap-atlas-size-const-lightmap-atlas-size-256-src-miniquake2-renderer-classic-world-ml-1962400005"></a>
### LIGHTMAP_ATLAS_SIZE

```ml
const LIGHTMAP_ATLAS_SIZE = 256
```

Defines the lightmap atlas size constant used by the miniquake2 renderer classic world module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/classic/world.ml#L28)

- [miniquake2.renderer.classic.world.LightmapAtlasState](Type-miniquake2-renderer-classic-world-lightmapatlasstate-1734585172.md) — struct
<a id="function-function-miniquake2-renderer-classic-world-loadimages-function-loadimages-map-loadfile-palette-src-miniquake2-renderer-classic-world-ml-316487772"></a>
### loadImages

```ml
function loadImages(map, loadFile, palette)
```

Load images.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `map` | `dynamic` | — | map value consumed by this operation. |
| `loadFile` | `dynamic` | — | loadFile value consumed by this operation. |
| `palette` | `dynamic` | — | palette value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/classic/world.ml#L91)

<a id="function-function-miniquake2-renderer-classic-world-newlightmapatlas-function-newlightmapatlas-state-src-miniquake2-renderer-classic-world-ml-1310731266"></a>
### newLightmapAtlas

```ml
function newLightmapAtlas(state)
```

Return the new lightmap atlas value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/classic/world.ml#L218)

<a id="function-function-miniquake2-renderer-classic-world-packlightmapatlases-function-packlightmapatlases-draws-brushmodels-generation-facecount-src-miniquake2-renderer-classic-world-ml-1751186148"></a>
### packLightmapAtlases

```ml
function packLightmapAtlases(draws, brushModels, generation, faceCount)
```

Pack lightmap atlases.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `draws` | `dynamic` | — | draws value consumed by this operation. |
| `brushModels` | `dynamic` | — | brushModels value consumed by this operation. |
| `generation` | `dynamic` | — | generation value consumed by this operation. |
| `faceCount` | `dynamic` | — | Number of face to process. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/classic/world.ml#L329)

<a id="function-function-miniquake2-renderer-classic-world-packlightmapdraw-function-packlightmapdraw-state-draw-src-miniquake2-renderer-classic-world-ml-1237214556"></a>
### packLightmapDraw

```ml
function packLightmapDraw(state, draw)
```

Pack lightmap draw.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |
| `draw` | `dynamic` | — | draw value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/classic/world.ml#L279)

<a id="constant-constant-miniquake2-renderer-classic-world-palette-path-const-palette-path-pics-colormap-pcx-src-miniquake2-renderer-classic-world-ml-1534332838"></a>
### PALETTE_PATH

```ml
const PALETTE_PATH = "pics/colormap.pcx"
```

Defines the palette path constant used by the miniquake2 renderer classic world module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/classic/world.ml#L26)

<a id="function-function-miniquake2-renderer-classic-world-plansignature-function-plansignature-world-src-miniquake2-renderer-classic-world-ml-1988649621"></a>
### planSignature

```ml
function planSignature(world)
```

Return the plan signature value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/classic/world.ml#L590)

<a id="function-function-miniquake2-renderer-classic-world-quakepalette-function-quakepalette-loadfile-src-miniquake2-renderer-classic-world-ml-708228041"></a>
### quakePalette

```ml
function quakePalette(loadFile)
```

Return the quake palette value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `loadFile` | `dynamic` | — | loadFile value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/classic/world.ml#L75)

<a id="function-function-miniquake2-renderer-classic-world-readbytes-function-readbytes-loadfile-path-src-miniquake2-renderer-classic-world-ml-1281084056"></a>
### readBytes

```ml
function readBytes(loadFile, path)
```

Read bytes.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `loadFile` | `dynamic` | — | loadFile value consumed by this operation. |
| `path` | `dynamic` | — | Path of the file or directory used by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/classic/world.ml#L67)

<a id="function-function-miniquake2-renderer-classic-world-surfacebounds-function-surfacebounds-surface-src-miniquake2-renderer-classic-world-ml-528613544"></a>
### surfaceBounds

```ml
function surfaceBounds(surface)
```

Return the surface bounds.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `surface` | `dynamic` | — | surface value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/classic/world.ml#L134)

<a id="function-function-miniquake2-renderer-classic-world-texturepath-function-texturepath-name-src-miniquake2-renderer-classic-world-ml-315819468"></a>
### texturePath

```ml
function texturePath(name)
```

Return the texture path.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `name` | `dynamic` | — | Name of the affected item. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/classic/world.ml#L83)

<a id="function-function-miniquake2-renderer-classic-world-trianglecount-function-trianglecount-world-src-miniquake2-renderer-classic-world-ml-179572997"></a>
### triangleCount

```ml
function triangleCount(world)
```

Return the triangle count.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/classic/world.ml#L580)
