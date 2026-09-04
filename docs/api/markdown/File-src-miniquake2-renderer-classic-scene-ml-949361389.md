# `src/miniquake2/renderer/classic/scene.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 renderer classic scene facilities for this project.

Package: [`miniquake2.renderer.classic.scene`](Package-miniquake2-renderer-classic-scene-396279936.md)

Reachable from entry: **yes**

## Imports

- `miniquake2/format/constants.ml` as `fc` → [src/miniquake2/format/constants.ml](File-src-miniquake2-format-constants-ml-1556940367.md)
- `miniquake2/renderer/classic/constants.ml` as `rclassicconstants` → [src/miniquake2/renderer/classic/constants.ml](File-src-miniquake2-renderer-classic-constants-ml-1818163902.md)
- `miniquake2/renderer/classic/lightmaps.ml` as `rclassiclightmaps` → [src/miniquake2/renderer/classic/lightmaps.ml](File-src-miniquake2-renderer-classic-lightmaps-ml-1607780996.md)
- `miniquake2/renderer/classic/sprites.ml` as `rclassicsprites` → [src/miniquake2/renderer/classic/sprites.ml](File-src-miniquake2-renderer-classic-sprites-ml-1178218947.md)
- `miniquake2/renderer/classic/surfaces.ml` as `rclassicsurfaces` → [src/miniquake2/renderer/classic/surfaces.ml](File-src-miniquake2-renderer-classic-surfaces-ml-1888445105.md)
- `miniquake2/renderer/classic/types.ml` as `rclassictypes` → [src/miniquake2/renderer/classic/types.ml](File-src-miniquake2-renderer-classic-types-ml-1346078158.md)

## Declarations

<a id="function-function-miniquake2-renderer-classic-scene-addsprite-function-addsprite-scene-model-entity-cameraup-cameraright-src-miniquake2-renderer-classic-scene-ml-1740189056"></a>
### addSprite

```ml
function addSprite(scene, model, entity, cameraUp, cameraRight)
```

Add sprite.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `scene` | `dynamic` | — | scene value consumed by this operation. |
| `model` | `dynamic` | — | model value consumed by this operation. |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `cameraUp` | `dynamic` | — | cameraUp value consumed by this operation. |
| `cameraRight` | `dynamic` | — | cameraRight value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/classic/scene.ml#L82)

<a id="function-function-miniquake2-renderer-classic-scene-addtotexturechain-function-addtotexturechain-chains-surface-src-miniquake2-renderer-classic-scene-ml-439501910"></a>
### addToTextureChain

```ml
function addToTextureChain(chains, surface)
```

Add to texture chain.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `chains` | `dynamic` | — | chains value consumed by this operation. |
| `surface` | `dynamic` | — | surface value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/classic/scene.ml#L30)

<a id="function-function-miniquake2-renderer-classic-scene-findchain-function-findchain-chains-imagename-src-miniquake2-renderer-classic-scene-ml-1363238855"></a>
### findChain

```ml
function findChain(chains, imageName)
```

Find chain.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `chains` | `dynamic` | — | chains value consumed by this operation. |
| `imageName` | `dynamic` | — | imageName value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/classic/scene.ml#L20)

<a id="function-function-miniquake2-renderer-classic-scene-preparemap-function-preparemap-map-images-entityframe-lightstyles-dlights-modulate-src-miniquake2-renderer-classic-scene-ml-532547915"></a>
### prepareMap

```ml
function prepareMap(map, images, entityFrame, lightStyles, dLights, modulate)
```

Prepare map.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `map` | `dynamic` | — | map value consumed by this operation. |
| `images` | `dynamic` | — | images value consumed by this operation. |
| `entityFrame` | `dynamic` | — | entityFrame value consumed by this operation. |
| `lightStyles` | `dynamic` | — | lightStyles value consumed by this operation. |
| `dLights` | `dynamic` | — | dLights value consumed by this operation. |
| `modulate` | `dynamic` | — | modulate value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/classic/scene.ml#L48)
