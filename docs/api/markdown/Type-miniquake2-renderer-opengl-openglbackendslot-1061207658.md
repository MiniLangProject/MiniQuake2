# `miniquake2.renderer.opengl.OpenGlBackendSlot`

[Home](README.md) · [Source file](File-src-miniquake2-renderer-opengl-ml-1095768987.md)

<a id="struct-struct-miniquake2-renderer-opengl-openglbackendslot-struct-openglbackendslot-src-miniquake2-renderer-opengl-ml-1390584543"></a>
## OpenGlBackendSlot

```ml
struct OpenGlBackendSlot
```

The v3 renderer API selects one backend at a time.  These renderer-specific names avoid the self-hosted linker's full-program collisions with the recording backend's own makeExports/state closure symbols.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L233)

## Members

<a id="field-field-miniquake2-renderer-opengl-openglbackendslot-backend-backend-src-miniquake2-renderer-opengl-ml-334480022"></a>
### backend

```ml
backend
```

Stores the backend value associated with open gl backend slot.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L235)
