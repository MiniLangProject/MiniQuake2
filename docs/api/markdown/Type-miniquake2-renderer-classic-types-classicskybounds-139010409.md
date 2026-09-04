# `miniquake2.renderer.classic.types.ClassicSkyBounds`

[Home](README.md) · [Source file](File-src-miniquake2-renderer-classic-types-ml-1346078158.md)

<a id="struct-struct-miniquake2-renderer-classic-types-classicskybounds-struct-classicskybounds-src-miniquake2-renderer-classic-types-ml-1679467212"></a>
## ClassicSkyBounds

```ml
struct ClassicSkyBounds
```

Per-view projected portal extents for Quake II's six environment faces. Keeping four fixed arrays mirrors ref_gl's skymins/skymaxs layout and lets the backend skip hidden cube regions instead of exposing depth seams.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/classic/types.ml#L244)

## Members

<a id="field-field-miniquake2-renderer-classic-types-classicskybounds-maximums-maximums-src-miniquake2-renderer-classic-types-ml-757454342"></a>
### maximumS

```ml
maximumS
```

Stores the maximum s value associated with classic sky bounds.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/classic/types.ml#L250)

<a id="field-field-miniquake2-renderer-classic-types-classicskybounds-maximumt-maximumt-src-miniquake2-renderer-classic-types-ml-81198140"></a>
### maximumT

```ml
maximumT
```

Stores the maximum t value associated with classic sky bounds.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/classic/types.ml#L252)

<a id="field-field-miniquake2-renderer-classic-types-classicskybounds-minimums-minimums-src-miniquake2-renderer-classic-types-ml-316141802"></a>
### minimumS

```ml
minimumS
```

Stores the minimum s value associated with classic sky bounds.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/classic/types.ml#L246)

<a id="field-field-miniquake2-renderer-classic-types-classicskybounds-minimumt-minimumt-src-miniquake2-renderer-classic-types-ml-1867911184"></a>
### minimumT

```ml
minimumT
```

Stores the minimum t value associated with classic sky bounds.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/classic/types.ml#L248)
