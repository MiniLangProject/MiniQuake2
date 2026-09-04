# `src/miniquake2/renderer/types.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 renderer types facilities for this project.

Package: [`miniquake2.renderer.types`](Package-miniquake2-renderer-types-551018483.md)

Reachable from entry: **yes**

## Imports

- `miniquake2/qcommon/types.ml` as `qtypes` → [src/miniquake2/qcommon/types.ml](File-src-miniquake2-qcommon-types-ml-1663266398.md)
- `miniquake2/renderer/constants.ml` as `rc` → [src/miniquake2/renderer/constants.ml](File-src-miniquake2-renderer-constants-ml-1893707491.md)

## Declarations

- [miniquake2.renderer.types.CVar](Type-miniquake2-renderer-types-cvar-39284189.md) — struct
<a id="function-function-miniquake2-renderer-types-defaultlightstyles-function-defaultlightstyles-src-miniquake2-renderer-types-ml-1477495534"></a>
### defaultLightStyles

```ml
function defaultLightStyles()
```

Return the default light styles value.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/types.ml#L302)

<a id="function-function-miniquake2-renderer-types-defaultrefdef-function-defaultrefdef-width-height-src-miniquake2-renderer-types-ml-1821504217"></a>
### defaultRefDef

```ml
function defaultRefDef(width, height)
```

Return the default ref def value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `width` | `dynamic` | — | Width in the coordinate or storage units used by the caller. |
| `height` | `dynamic` | — | Height in the coordinate or storage units used by the caller. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/types.ml#L336)

<a id="function-function-miniquake2-renderer-types-dlight-function-dlight-origin-color-intensity-src-miniquake2-renderer-types-ml-245735504"></a>
### dLight

```ml
function dLight(origin, color, intensity)
```

Return the d light value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `origin` | `dynamic` | — | origin value consumed by this operation. |
| `color` | `dynamic` | — | color value consumed by this operation. |
| `intensity` | `dynamic` | — | intensity value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/types.ml#L279)

- [miniquake2.renderer.types.DLight](Type-miniquake2-renderer-types-dlight-211968867.md) — struct
<a id="function-function-miniquake2-renderer-types-emptyentity-function-emptyentity-src-miniquake2-renderer-types-ml-1994596806"></a>
### emptyEntity

```ml
function emptyEntity()
```

Report whether empty entity.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/types.ml#L271)

<a id="function-function-miniquake2-renderer-types-entity-function-entity-model-angles-origin-frame-oldorigin-oldframe-backlerp-skinnum-lightstyle-alpha-skin-flags-src-miniquake2-renderer-types-ml-906609169"></a>
### entity

```ml
function entity(model, angles, origin, frame, oldOrigin, oldFrame, backLerp, skinNum, lightStyle, alpha, skin, flags)
```

Return the entity value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `model` | `dynamic` | — | model value consumed by this operation. |
| `angles` | `dynamic` | — | angles value consumed by this operation. |
| `origin` | `dynamic` | — | origin value consumed by this operation. |
| `frame` | `dynamic` | — | frame value consumed by this operation. |
| `oldOrigin` | `dynamic` | — | oldOrigin value consumed by this operation. |
| `oldFrame` | `dynamic` | — | oldFrame value consumed by this operation. |
| `backLerp` | `dynamic` | — | backLerp value consumed by this operation. |
| `skinNum` | `dynamic` | — | skinNum value consumed by this operation. |
| `lightStyle` | `dynamic` | — | lightStyle value consumed by this operation. |
| `alpha` | `dynamic` | — | alpha value consumed by this operation. |
| `skin` | `dynamic` | — | skin value consumed by this operation. |
| `flags` | `dynamic` | — | Bit flags controlling the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/types.ml#L266)

- [miniquake2.renderer.types.Entity](Type-miniquake2-renderer-types-entity-786378496.md) — struct
<a id="function-function-miniquake2-renderer-types-lightstyle-function-lightstyle-red-green-blue-src-miniquake2-renderer-types-ml-1611845916"></a>
### lightStyle

```ml
function lightStyle(red, green, blue)
```

Return the light style value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `red` | `dynamic` | — | red value consumed by this operation. |
| `green` | `dynamic` | — | green value consumed by this operation. |
| `blue` | `dynamic` | — | blue value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/types.ml#L295)

- [miniquake2.renderer.types.LightStyle](Type-miniquake2-renderer-types-lightstyle-663773858.md) — struct
<a id="function-function-miniquake2-renderer-types-particle-function-particle-origin-color-alpha-src-miniquake2-renderer-types-ml-1287817857"></a>
### particle

```ml
function particle(origin, color, alpha)
```

Return the particle value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `origin` | `dynamic` | — | origin value consumed by this operation. |
| `color` | `dynamic` | — | color value consumed by this operation. |
| `alpha` | `dynamic` | — | alpha value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/types.ml#L287)

- [miniquake2.renderer.types.Particle](Type-miniquake2-renderer-types-particle-1521427721.md) — struct
- [miniquake2.renderer.types.PicSize](Type-miniquake2-renderer-types-picsize-1829344620.md) — struct
<a id="function-function-miniquake2-renderer-types-refdef-function-refdef-x-y-width-height-fovx-fovy-vieworigin-viewangles-blend-time-rdflags-areabits-lightstyles-entities-dlights-particles-src-miniquake2-renderer-types-ml-849189168"></a>
### refDef

```ml
function refDef(x, y, width, height, fovX, fovY, viewOrigin, viewAngles, blend, time, rdFlags, areaBits, lightStyles, entities, dLights, particles)
```

Return the ref def value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `x` | `dynamic` | — | Horizontal coordinate used by the operation. |
| `y` | `dynamic` | — | Vertical coordinate used by the operation. |
| `width` | `dynamic` | — | Width in the coordinate or storage units used by the caller. |
| `height` | `dynamic` | — | Height in the coordinate or storage units used by the caller. |
| `fovX` | `dynamic` | — | fovX value consumed by this operation. |
| `fovY` | `dynamic` | — | fovY value consumed by this operation. |
| `viewOrigin` | `dynamic` | — | viewOrigin value consumed by this operation. |
| `viewAngles` | `dynamic` | — | viewAngles value consumed by this operation. |
| `blend` | `dynamic` | — | blend value consumed by this operation. |
| `time` | `dynamic` | — | time value consumed by this operation. |
| `rdFlags` | `dynamic` | — | rdFlags value consumed by this operation. |
| `areaBits` | `dynamic` | — | areaBits value consumed by this operation. |
| `lightStyles` | `dynamic` | — | lightStyles value consumed by this operation. |
| `entities` | `dynamic` | — | entities value consumed by this operation. |
| `dLights` | `dynamic` | — | dLights value consumed by this operation. |
| `particles` | `dynamic` | — | particles value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/types.ml#L329)

- [miniquake2.renderer.types.RefDef](Type-miniquake2-renderer-types-refdef-1640030575.md) — struct
- [miniquake2.renderer.types.RefExport](Type-miniquake2-renderer-types-refexport-1600012846.md) — struct
- [miniquake2.renderer.types.RefImport](Type-miniquake2-renderer-types-refimport-1969702741.md) — struct
- [miniquake2.renderer.types.RendererBinding](Type-miniquake2-renderer-types-rendererbinding-1288800953.md) — struct
- [miniquake2.renderer.types.ResourceHandle](Type-miniquake2-renderer-types-resourcehandle-2090279157.md) — struct
- [miniquake2.renderer.types.VideoModeInfo](Type-miniquake2-renderer-types-videomodeinfo-1113785593.md) — struct
