# `miniquake2.renderer.opengl.GlTextureRecord`

[Home](README.md) · [Source file](File-src-miniquake2-renderer-opengl-ml-1095768987.md)

<a id="struct-struct-miniquake2-renderer-opengl-gltexturerecord-struct-gltexturerecord-src-miniquake2-renderer-opengl-ml-637779671"></a>
## GlTextureRecord

```ml
struct GlTextureRecord
```

The native bridge creates OpenGL 1.1 names on first bind.  Keeping every allocation here makes generation ownership and release observable. Uploaded names are physically deleted through the shared OpenGL bridge; headless records follow the same logical lifecycle without a native call.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L211)

## Members

<a id="field-field-miniquake2-renderer-opengl-gltexturerecord-generation-generation-src-miniquake2-renderer-opengl-ml-1638111504"></a>
### generation

```ml
generation
```

Stores the generation value associated with gl texture record.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L219)

<a id="field-field-miniquake2-renderer-opengl-gltexturerecord-height-height-src-miniquake2-renderer-opengl-ml-1944217682"></a>
### height

```ml
height
```

Stores the height value associated with gl texture record.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L223)

<a id="field-field-miniquake2-renderer-opengl-gltexturerecord-id-id-src-miniquake2-renderer-opengl-ml-807082534"></a>
### id

```ml
id
```

Stores the id value associated with gl texture record.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L213)

<a id="field-field-miniquake2-renderer-opengl-gltexturerecord-name-name-src-miniquake2-renderer-opengl-ml-1346521094"></a>
### name

```ml
name
```

Stores the name value associated with gl texture record.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L215)

<a id="field-field-miniquake2-renderer-opengl-gltexturerecord-released-released-src-miniquake2-renderer-opengl-ml-1757932994"></a>
### released

```ml
released
```

Stores the released value associated with gl texture record.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L227)

<a id="field-field-miniquake2-renderer-opengl-gltexturerecord-role-role-src-miniquake2-renderer-opengl-ml-299499524"></a>
### role

```ml
role
```

Stores the role value associated with gl texture record.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L217)

<a id="field-field-miniquake2-renderer-opengl-gltexturerecord-uploaded-uploaded-src-miniquake2-renderer-opengl-ml-2057206792"></a>
### uploaded

```ml
uploaded
```

Stores the uploaded value associated with gl texture record.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L225)

<a id="field-field-miniquake2-renderer-opengl-gltexturerecord-width-width-src-miniquake2-renderer-opengl-ml-465965308"></a>
### width

```ml
width
```

Stores the width value associated with gl texture record.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/opengl.ml#L221)
