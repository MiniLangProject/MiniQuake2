# `miniquake2.renderer.opengl.OpenGlPendingClassicPasses`

[Home](README.md) · [Source file](File-src-miniquake2-renderer-opengl-ml-1095768987.md)

<a id="struct-struct-miniquake2-renderer-opengl-openglpendingclassicpasses-struct-openglpendingclassicpasses-src-miniquake2-renderer-opengl-ml-1717711735"></a>
## OpenGlPendingClassicPasses

```ml
struct OpenGlPendingClassicPasses
```

World alpha must be emitted after aliases and particles even though the MiniLang product submits BSP geometry through a separate API call. Retain only the current frame's tail passes; BeginFrame clears stale work.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L241)

## Members

<a id="field-field-miniquake2-renderer-opengl-openglpendingclassicpasses-active-active-src-miniquake2-renderer-opengl-ml-1503255510"></a>
### active

```ml
active
```

Stores the active value associated with open gl pending classic passes.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L251)

<a id="field-field-miniquake2-renderer-opengl-openglpendingclassicpasses-binding-binding-src-miniquake2-renderer-opengl-ml-1734570506"></a>
### binding

```ml
binding
```

Stores the binding value associated with open gl pending classic passes.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L243)

<a id="field-field-miniquake2-renderer-opengl-openglpendingclassicpasses-frame-frame-src-miniquake2-renderer-opengl-ml-1913675754"></a>
### frame

```ml
frame
```

Stores the frame value associated with open gl pending classic passes.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L249)

<a id="field-field-miniquake2-renderer-opengl-openglpendingclassicpasses-stats-stats-src-miniquake2-renderer-opengl-ml-533309978"></a>
### stats

```ml
stats
```

Stores the stats value associated with open gl pending classic passes.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L253)

<a id="field-field-miniquake2-renderer-opengl-openglpendingclassicpasses-transparentcount-transparentcount-src-miniquake2-renderer-opengl-ml-989607176"></a>
### transparentCount

```ml
transparentCount
```

Stores the transparent count value associated with open gl pending classic passes.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L247)

<a id="field-field-miniquake2-renderer-opengl-openglpendingclassicpasses-transparentdraws-transparentdraws-src-miniquake2-renderer-opengl-ml-735904016"></a>
### transparentDraws

```ml
transparentDraws
```

Stores the transparent draws value associated with open gl pending classic passes.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L245)
