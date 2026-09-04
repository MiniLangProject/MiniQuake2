# `src/miniquake2/renderer/classic/types.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 renderer classic types facilities for this project.

Package: [`miniquake2.renderer.classic.types`](Package-miniquake2-renderer-classic-types-1978706585.md)

Reachable from entry: **yes**

## Imports

- `miniquake2/format/types.ml` as `ft` → [src/miniquake2/format/types.ml](File-src-miniquake2-format-types-ml-129451131.md)

## Declarations

- [miniquake2.renderer.classic.types.ClassicBrushFramePlan](Type-miniquake2-renderer-classic-types-classicbrushframeplan-682726009.md) — struct
- [miniquake2.renderer.classic.types.ClassicBrushLightmap](Type-miniquake2-renderer-classic-types-classicbrushlightmap-1622926459.md) — struct
- [miniquake2.renderer.classic.types.ClassicBrushModel](Type-miniquake2-renderer-classic-types-classicbrushmodel-941845462.md) — struct
- [miniquake2.renderer.classic.types.ClassicBrushSubmission](Type-miniquake2-renderer-classic-types-classicbrushsubmission-2028471189.md) — struct
- [miniquake2.renderer.classic.types.ClassicImage](Type-miniquake2-renderer-classic-types-classicimage-1725845624.md) — struct
- [miniquake2.renderer.classic.types.ClassicPointLight](Type-miniquake2-renderer-classic-types-classicpointlight-668186805.md) — struct
- [miniquake2.renderer.classic.types.ClassicScene](Type-miniquake2-renderer-classic-types-classicscene-1231891361.md) — struct
- [miniquake2.renderer.classic.types.ClassicSkyBounds](Type-miniquake2-renderer-classic-types-classicskybounds-139010409.md) — struct
- [miniquake2.renderer.classic.types.ClassicSkyBox](Type-miniquake2-renderer-classic-types-classicskybox-1213413793.md) — struct
- [miniquake2.renderer.classic.types.ClassicSpecialPassPlan](Type-miniquake2-renderer-classic-types-classicspecialpassplan-318739236.md) — struct
- [miniquake2.renderer.classic.types.ClassicSpecialPassScratch](Type-miniquake2-renderer-classic-types-classicspecialpassscratch-681990599.md) — struct
- [miniquake2.renderer.classic.types.ClassicSubmitStats](Type-miniquake2-renderer-classic-types-classicsubmitstats-1684612750.md) — struct
- [miniquake2.renderer.classic.types.ClassicSurface](Type-miniquake2-renderer-classic-types-classicsurface-1857140270.md) — struct
- [miniquake2.renderer.classic.types.ClassicTexture](Type-miniquake2-renderer-classic-types-classictexture-1286534130.md) — struct
- [miniquake2.renderer.classic.types.ClassicTransparentDraw](Type-miniquake2-renderer-classic-types-classictransparentdraw-907508861.md) — struct
- [miniquake2.renderer.classic.types.ClassicVisibilitySelection](Type-miniquake2-renderer-classic-types-classicvisibilityselection-645226723.md) — struct
- [miniquake2.renderer.classic.types.ClassicWorld](Type-miniquake2-renderer-classic-types-classicworld-2124552105.md) — struct
- [miniquake2.renderer.classic.types.ClassicWorldDraw](Type-miniquake2-renderer-classic-types-classicworlddraw-1337804471.md) — struct
<a id="function-function-miniquake2-renderer-classic-types-fallbackimage-function-fallbackimage-name-src-miniquake2-renderer-classic-types-ml-122791776"></a>
### fallbackImage

```ml
function fallbackImage(name)
```

Return the fallback image value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `name` | `dynamic` | — | Name of the affected item. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/classic/types.ml#L470)

- [miniquake2.renderer.classic.types.SpriteDraw](Type-miniquake2-renderer-classic-types-spritedraw-1564791150.md) — struct
- [miniquake2.renderer.classic.types.SpriteVertex](Type-miniquake2-renderer-classic-types-spritevertex-1898175178.md) — struct
<a id="function-function-miniquake2-renderer-classic-types-surfacevertex-function-surfacevertex-position-s-t-lights-lightt-src-miniquake2-renderer-classic-types-ml-752892474"></a>
### surfaceVertex

```ml
function surfaceVertex(position, s, t, lightS, lightT)
```

Return the surface vertex value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `position` | `dynamic` | — | position value consumed by this operation. |
| `s` | `dynamic` | — | s value consumed by this operation. |
| `t` | `dynamic` | — | t value consumed by this operation. |
| `lightS` | `dynamic` | — | lightS value consumed by this operation. |
| `lightT` | `dynamic` | — | lightT value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/classic/types.ml#L480)

- [miniquake2.renderer.classic.types.SurfaceVertex](Type-miniquake2-renderer-classic-types-surfacevertex-1407710122.md) — struct
- [miniquake2.renderer.classic.types.TextureChain](Type-miniquake2-renderer-classic-types-texturechain-1157391533.md) — struct
