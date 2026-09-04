# `miniquake2.renderer.classic.visibility.ClassicBrushBounds`

[Home](README.md) · [Source file](File-src-miniquake2-renderer-classic-visibility-ml-1972680069.md)

<a id="struct-struct-miniquake2-renderer-classic-visibility-classicbrushbounds-struct-classicbrushbounds-src-miniquake2-renderer-classic-visibility-ml-1413245946"></a>
## ClassicBrushBounds

```ml
struct ClassicBrushBounds
```

Minimal per-frame brush bounds used by the frustum culler. Keeping this separate from ClassicWorldDraw avoids allocating empty texture/vertex arrays and a full draw record for every moving door, platform and lift each frame.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/classic/visibility.ml#L115)

## Members

<a id="field-field-miniquake2-renderer-classic-visibility-classicbrushbounds-centerx-centerx-src-miniquake2-renderer-classic-visibility-ml-855230625"></a>
### centerX

```ml
centerX
```

Stores the center x value associated with classic brush bounds.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/classic/visibility.ml#L121)

<a id="field-field-miniquake2-renderer-classic-visibility-classicbrushbounds-centery-centery-src-miniquake2-renderer-classic-visibility-ml-1285916085"></a>
### centerY

```ml
centerY
```

Stores the center y value associated with classic brush bounds.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/classic/visibility.ml#L123)

<a id="field-field-miniquake2-renderer-classic-visibility-classicbrushbounds-centerz-centerz-src-miniquake2-renderer-classic-visibility-ml-684372469"></a>
### centerZ

```ml
centerZ
```

Stores the center z value associated with classic brush bounds.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/classic/visibility.ml#L125)

<a id="field-field-miniquake2-renderer-classic-visibility-classicbrushbounds-extentx-extentx-src-miniquake2-renderer-classic-visibility-ml-698337725"></a>
### extentX

```ml
extentX
```

Stores the extent x value associated with classic brush bounds.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/classic/visibility.ml#L127)

<a id="field-field-miniquake2-renderer-classic-visibility-classicbrushbounds-extenty-extenty-src-miniquake2-renderer-classic-visibility-ml-2017468957"></a>
### extentY

```ml
extentY
```

Stores the extent y value associated with classic brush bounds.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/classic/visibility.ml#L129)

<a id="field-field-miniquake2-renderer-classic-visibility-classicbrushbounds-extentz-extentz-src-miniquake2-renderer-classic-visibility-ml-421985545"></a>
### extentZ

```ml
extentZ
```

Stores the extent z value associated with classic brush bounds.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/classic/visibility.ml#L131)

<a id="field-field-miniquake2-renderer-classic-visibility-classicbrushbounds-maxs-maxs-src-miniquake2-renderer-classic-visibility-ml-964113043"></a>
### maxs

```ml
maxs
```

Stores the maxs value associated with classic brush bounds.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/classic/visibility.ml#L119)

<a id="field-field-miniquake2-renderer-classic-visibility-classicbrushbounds-mins-mins-src-miniquake2-renderer-classic-visibility-ml-1901984343"></a>
### mins

```ml
mins
```

Stores the mins value associated with classic brush bounds.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/classic/visibility.ml#L117)
