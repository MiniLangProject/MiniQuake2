# `miniquake2.renderer.opengl.Md2LightCacheEntry`

[Home](README.md) · [Source file](File-src-miniquake2-renderer-opengl-ml-1095768987.md)

<a id="struct-struct-miniquake2-renderer-opengl-md2lightcacheentry-struct-md2lightcacheentry-src-miniquake2-renderer-opengl-ml-255592551"></a>
## Md2LightCacheEntry

```ml
struct Md2LightCacheEntry
```

One static BSP light sample retained for an entity slot. Dynamic lights are deliberately excluded and composed at draw time so moving flashes remain exact without repeating RecursiveLightPoint on every presentation frame.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L350)

## Members

<a id="field-field-miniquake2-renderer-opengl-md2lightcacheentry-originx-originx-src-miniquake2-renderer-opengl-ml-1062470020"></a>
### originX

```ml
originX
```

Stores the origin x value associated with md2 light cache entry.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L356)

<a id="field-field-miniquake2-renderer-opengl-md2lightcacheentry-originy-originy-src-miniquake2-renderer-opengl-ml-1047999368"></a>
### originY

```ml
originY
```

Stores the origin y value associated with md2 light cache entry.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L358)

<a id="field-field-miniquake2-renderer-opengl-md2lightcacheentry-originz-originz-src-miniquake2-renderer-opengl-ml-868511960"></a>
### originZ

```ml
originZ
```

Stores the origin z value associated with md2 light cache entry.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L360)

<a id="field-field-miniquake2-renderer-opengl-md2lightcacheentry-sample-sample-src-miniquake2-renderer-opengl-ml-1493323924"></a>
### sample

```ml
sample
```

Stores the sample value associated with md2 light cache entry.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L362)

<a id="field-field-miniquake2-renderer-opengl-md2lightcacheentry-styleepoch-styleepoch-src-miniquake2-renderer-opengl-ml-1221953500"></a>
### styleEpoch

```ml
styleEpoch
```

Stores the style epoch value associated with md2 light cache entry.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L354)

<a id="field-field-miniquake2-renderer-opengl-md2lightcacheentry-worldgeneration-worldgeneration-src-miniquake2-renderer-opengl-ml-384644068"></a>
### worldGeneration

```ml
worldGeneration
```

Stores the world generation value associated with md2 light cache entry.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L352)
