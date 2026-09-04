# `src/miniquake2/renderer/recording.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 renderer recording facilities for this project.

Package: [`miniquake2.renderer.recording`](Package-miniquake2-renderer-recording-1562685617.md)

Reachable from entry: **yes**

## Imports

- `miniquake2/qcommon/types.ml` as `qtypes` → [src/miniquake2/qcommon/types.ml](File-src-miniquake2-qcommon-types-ml-1663266398.md)
- `miniquake2/renderer/constants.ml` as `rc` → [src/miniquake2/renderer/constants.ml](File-src-miniquake2-renderer-constants-ml-1893707491.md)
- `miniquake2/renderer/types.ml` as `rt` → [src/miniquake2/renderer/types.ml](File-src-miniquake2-renderer-types-ml-975707623.md)
- `miniquake2/renderer/validation.ml` as `validation` → [src/miniquake2/renderer/validation.ml](File-src-miniquake2-renderer-validation-ml-96374779.md)

## Declarations

<a id="function-function-miniquake2-renderer-recording-clearcommands-function-clearcommands-binding-src-miniquake2-renderer-recording-ml-1135000183"></a>
### clearCommands

```ml
function clearCommands(binding)
```

Clear commands.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `binding` | `dynamic` | — | binding value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/recording.ml#L379)

<a id="function-function-miniquake2-renderer-recording-commandtrace-function-commandtrace-binding-src-miniquake2-renderer-recording-ml-223534165"></a>
### commandTrace

```ml
function commandTrace(binding)
```

Trace command.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `binding` | `dynamic` | — | binding value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/recording.ml#L385)

<a id="function-function-miniquake2-renderer-recording-createnullrenderer-function-createnullrenderer-src-miniquake2-renderer-recording-ml-2039344542"></a>
### createNullRenderer

```ml
function createNullRenderer()
```

Create null renderer.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/recording.ml#L360)

<a id="function-function-miniquake2-renderer-recording-createrecordingrenderer-function-createrecordingrenderer-src-miniquake2-renderer-recording-ml-1325723054"></a>
### createRecordingRenderer

```ml
function createRecordingRenderer()
```

Create recording renderer.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/recording.ml#L354)

<a id="function-function-miniquake2-renderer-recording-createstate-function-createstate-mode-imports-src-miniquake2-renderer-recording-ml-1033421417"></a>
### createState

```ml
function createState(mode, imports)
```

Creates state for the miniquake2 renderer recording module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `mode` | `dynamic` | — | Mode selecting the requested behavior. |
| `imports` | `dynamic` | — | imports value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/recording.ml#L72)

<a id="function-function-miniquake2-renderer-recording-findresource-function-findresource-resources-name-generation-src-miniquake2-renderer-recording-ml-58877616"></a>
### findResource

```ml
function findResource(resources, name, generation)
```

Find resource.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `resources` | `dynamic` | — | resources value consumed by this operation. |
| `name` | `dynamic` | — | Name of the affected item. |
| `generation` | `dynamic` | — | generation value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/recording.ml#L98)

<a id="function-function-miniquake2-renderer-recording-getrefapi-function-getrefapi-imports-mode-src-miniquake2-renderer-recording-ml-565386303"></a>
### getRefAPI

```ml
function getRefAPI(imports, mode)
```

Internal equivalent of GetRefAPI_t. It binds a validated refimport_t table to the renderer while returning both the export table and inspectable state.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `imports` | `dynamic` | — | imports value consumed by this operation. |
| `mode` | `dynamic` | — | Mode selecting the requested behavior. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/recording.ml#L369)

<a id="function-function-miniquake2-renderer-recording-ishandlecurrent-function-ishandlecurrent-binding-handle-src-miniquake2-renderer-recording-ml-211124429"></a>
### isHandleCurrent

```ml
function isHandleCurrent(binding, handle)
```

Report whether is handle current.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `binding` | `dynamic` | — | binding value consumed by this operation. |
| `handle` | `dynamic` | — | Native or runtime handle used by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/recording.ml#L400)

<a id="function-function-miniquake2-renderer-recording-makeexports-function-makeexports-state-src-miniquake2-renderer-recording-ml-136377451"></a>
### makeExports

```ml
function makeExports(state)
```

Build a complete Renderer API v3 recorder around one shared lifecycle state. Nested callbacks deliberately retain that state instead of copying resources.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/recording.ml#L146)

<a id="nested_function-nested-function-miniquake2-renderer-recording-makeexports-local-appactivate-function-appactivate-activate-src-miniquake2-renderer-recording-ml-1478955059"></a>
### appActivate

```ml
function appActivate(activate)
```

Performs the appActivate operation for the miniquake2 renderer recording module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `activate` | `dynamic` | — | activate value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/recording.ml#L344)

<a id="nested_function-nested-function-miniquake2-renderer-recording-makeexports-local-beginframe-function-beginframe-cameraseparation-src-miniquake2-renderer-recording-ml-247211377"></a>
### beginFrame

```ml
function beginFrame(cameraSeparation)
```

Performs the beginFrame operation for the miniquake2 renderer recording module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `cameraSeparation` | `dynamic` | — | cameraSeparation value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/recording.ml#L327)

<a id="nested_function-nested-function-miniquake2-renderer-recording-makeexports-local-beginregistration-function-beginregistration-mapname-src-miniquake2-renderer-recording-ml-1644616913"></a>
### beginRegistration

```ml
function beginRegistration(mapName)
```

Performs the beginRegistration operation for the miniquake2 renderer recording module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `mapName` | `dynamic` | — | mapName value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/recording.ml#L168)

<a id="nested_function-nested-function-miniquake2-renderer-recording-makeexports-local-cinematicsetpalette-function-cinematicsetpalette-palette-src-miniquake2-renderer-recording-ml-510978899"></a>
### cinematicSetPalette

```ml
function cinematicSetPalette(palette)
```

Performs the cinematicSetPalette operation for the miniquake2 renderer recording module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `palette` | `dynamic` | — | palette value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/recording.ml#L316)

<a id="nested_function-nested-function-miniquake2-renderer-recording-makeexports-local-drawchar-function-drawchar-x-y-character-src-miniquake2-renderer-recording-ml-194865754"></a>
### drawChar

```ml
function drawChar(x, y, character)
```

Draws char through the miniquake2 renderer recording rendering path.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `x` | `dynamic` | — | Horizontal coordinate used by the operation. |
| `y` | `dynamic` | — | Vertical coordinate used by the operation. |
| `character` | `dynamic` | — | character value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/recording.ml#L263)

<a id="nested_function-nested-function-miniquake2-renderer-recording-makeexports-local-drawfadescreen-function-drawfadescreen-src-miniquake2-renderer-recording-ml-547771866"></a>
### drawFadeScreen

```ml
function drawFadeScreen()
```

Draws fade screen through the miniquake2 renderer recording rendering path.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/recording.ml#L294)

<a id="nested_function-nested-function-miniquake2-renderer-recording-makeexports-local-drawfill-function-drawfill-x-y-width-height-color-src-miniquake2-renderer-recording-ml-1740419211"></a>
### drawFill

```ml
function drawFill(x, y, width, height, color)
```

Draws fill through the miniquake2 renderer recording rendering path.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `x` | `dynamic` | — | Horizontal coordinate used by the operation. |
| `y` | `dynamic` | — | Vertical coordinate used by the operation. |
| `width` | `dynamic` | — | Width in the coordinate or storage units used by the caller. |
| `height` | `dynamic` | — | Height in the coordinate or storage units used by the caller. |
| `color` | `dynamic` | — | color value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/recording.ml#L286)

<a id="nested_function-nested-function-miniquake2-renderer-recording-makeexports-local-drawgetpicsize-function-drawgetpicsize-name-src-miniquake2-renderer-recording-ml-303999581"></a>
### drawGetPicSize

```ml
function drawGetPicSize(name)
```

Draws get pic size through the miniquake2 renderer recording rendering path.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `name` | `dynamic` | — | Name of the affected item. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/recording.ml#L232)

<a id="nested_function-nested-function-miniquake2-renderer-recording-makeexports-local-drawpic-function-drawpic-x-y-name-src-miniquake2-renderer-recording-ml-855380578"></a>
### drawPic

```ml
function drawPic(x, y, name)
```

Draws pic through the miniquake2 renderer recording rendering path.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `x` | `dynamic` | — | Horizontal coordinate used by the operation. |
| `y` | `dynamic` | — | Vertical coordinate used by the operation. |
| `name` | `dynamic` | — | Name of the affected item. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/recording.ml#L242)

<a id="nested_function-nested-function-miniquake2-renderer-recording-makeexports-local-drawstretchpic-function-drawstretchpic-x-y-width-height-name-src-miniquake2-renderer-recording-ml-1539925649"></a>
### drawStretchPic

```ml
function drawStretchPic(x, y, width, height, name)
```

Draws stretch pic through the miniquake2 renderer recording rendering path.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `x` | `dynamic` | — | Horizontal coordinate used by the operation. |
| `y` | `dynamic` | — | Vertical coordinate used by the operation. |
| `width` | `dynamic` | — | Width in the coordinate or storage units used by the caller. |
| `height` | `dynamic` | — | Height in the coordinate or storage units used by the caller. |
| `name` | `dynamic` | — | Name of the affected item. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/recording.ml#L253)

<a id="nested_function-nested-function-miniquake2-renderer-recording-makeexports-local-drawstretchraw-function-drawstretchraw-x-y-width-height-columns-rows-data-src-miniquake2-renderer-recording-ml-196132650"></a>
### drawStretchRaw

```ml
function drawStretchRaw(x, y, width, height, columns, rows, data)
```

Draws stretch raw through the miniquake2 renderer recording rendering path.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `x` | `dynamic` | — | Horizontal coordinate used by the operation. |
| `y` | `dynamic` | — | Vertical coordinate used by the operation. |
| `width` | `dynamic` | — | Width in the coordinate or storage units used by the caller. |
| `height` | `dynamic` | — | Height in the coordinate or storage units used by the caller. |
| `columns` | `dynamic` | — | columns value consumed by this operation. |
| `rows` | `dynamic` | — | rows value consumed by this operation. |
| `data` | `dynamic` | — | Input data consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/recording.ml#L307)

<a id="nested_function-nested-function-miniquake2-renderer-recording-makeexports-local-drawtileclear-function-drawtileclear-x-y-width-height-name-src-miniquake2-renderer-recording-ml-409473391"></a>
### drawTileClear

```ml
function drawTileClear(x, y, width, height, name)
```

Draws tile clear through the miniquake2 renderer recording rendering path.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `x` | `dynamic` | — | Horizontal coordinate used by the operation. |
| `y` | `dynamic` | — | Vertical coordinate used by the operation. |
| `width` | `dynamic` | — | Width in the coordinate or storage units used by the caller. |
| `height` | `dynamic` | — | Height in the coordinate or storage units used by the caller. |
| `name` | `dynamic` | — | Name of the affected item. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/recording.ml#L274)

<a id="nested_function-nested-function-miniquake2-renderer-recording-makeexports-local-endframe-function-endframe-src-miniquake2-renderer-recording-ml-1531959562"></a>
### endFrame

```ml
function endFrame()
```

Performs the endFrame operation for the miniquake2 renderer recording module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/recording.ml#L335)

<a id="nested_function-nested-function-miniquake2-renderer-recording-makeexports-local-endregistration-function-endregistration-src-miniquake2-renderer-recording-ml-1451279626"></a>
### endRegistration

```ml
function endRegistration()
```

Performs the endRegistration operation for the miniquake2 renderer recording module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/recording.ml#L213)

<a id="nested_function-nested-function-miniquake2-renderer-recording-makeexports-local-registermodel-function-registermodel-name-src-miniquake2-renderer-recording-ml-2076217345"></a>
### registerModel

```ml
function registerModel(name)
```

Performs the registerModel operation for the miniquake2 renderer recording module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `name` | `dynamic` | — | Name of the affected item. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/recording.ml#L182)

<a id="nested_function-nested-function-miniquake2-renderer-recording-makeexports-local-registerpic-function-registerpic-name-src-miniquake2-renderer-recording-ml-1882385047"></a>
### registerPic

```ml
function registerPic(name)
```

Performs the registerPic operation for the miniquake2 renderer recording module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `name` | `dynamic` | — | Name of the affected item. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/recording.ml#L194)

<a id="nested_function-nested-function-miniquake2-renderer-recording-makeexports-local-registerskin-function-registerskin-name-src-miniquake2-renderer-recording-ml-1246806149"></a>
### registerSkin

```ml
function registerSkin(name)
```

Performs the registerSkin operation for the miniquake2 renderer recording module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `name` | `dynamic` | — | Name of the affected item. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/recording.ml#L188)

<a id="nested_function-nested-function-miniquake2-renderer-recording-makeexports-local-rendererinit-function-rendererinit-hinstance-wndproc-src-miniquake2-renderer-recording-ml-429666152"></a>
### rendererInit

```ml
function rendererInit(hinstance, wndproc)
```

Performs the rendererInit operation for the miniquake2 renderer recording module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `hinstance` | `dynamic` | — | hinstance value consumed by this operation. |
| `wndproc` | `dynamic` | — | wndproc value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/recording.ml#L150)

<a id="nested_function-nested-function-miniquake2-renderer-recording-makeexports-local-renderershutdown-function-renderershutdown-src-miniquake2-renderer-recording-ml-1646197430"></a>
### rendererShutdown

```ml
function rendererShutdown()
```

Performs the rendererShutdown operation for the miniquake2 renderer recording module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/recording.ml#L158)

<a id="nested_function-nested-function-miniquake2-renderer-recording-makeexports-local-renderframe-function-renderframe-frame-src-miniquake2-renderer-recording-ml-922917771"></a>
### renderFrame

```ml
function renderFrame(frame)
```

Renders frame through the miniquake2 renderer recording rendering path.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `frame` | `dynamic` | — | frame value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/recording.ml#L221)

<a id="nested_function-nested-function-miniquake2-renderer-recording-makeexports-local-setsky-function-setsky-name-rotate-axis-src-miniquake2-renderer-recording-ml-2074404495"></a>
### setSky

```ml
function setSky(name, rotate, axis)
```

Updates sky maintained by the miniquake2 renderer recording module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `name` | `dynamic` | — | Name of the affected item. |
| `rotate` | `dynamic` | — | rotate value consumed by this operation. |
| `axis` | `dynamic` | — | axis value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/recording.ml#L202)

<a id="function-function-miniquake2-renderer-recording-record-function-record-state-operation-arguments-src-miniquake2-renderer-recording-ml-1695724682"></a>
### record

```ml
function record(state, operation, arguments)
```

Record state.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |
| `operation` | `dynamic` | — | operation value consumed by this operation. |
| `arguments` | `dynamic` | — | arguments value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/recording.ml#L80)

<a id="function-function-miniquake2-renderer-recording-registerresource-function-registerresource-state-kind-name-src-miniquake2-renderer-recording-ml-951666120"></a>
### registerResource

```ml
function registerResource(state, kind, name)
```

Register resource.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |
| `kind` | `dynamic` | — | kind value consumed by this operation. |
| `name` | `dynamic` | — | Name of the affected item. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/recording.ml#L120)

- [miniquake2.renderer.recording.RenderCommand](Type-miniquake2-renderer-recording-rendercommand-1970857874.md) — struct
- [miniquake2.renderer.recording.RendererState](Type-miniquake2-renderer-recording-rendererstate-329715147.md) — struct
<a id="function-function-miniquake2-renderer-recording-requireinitialized-function-requireinitialized-state-operation-src-miniquake2-renderer-recording-ml-651765704"></a>
### requireInitialized

```ml
function requireInitialized(state, operation)
```

Require initialized.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |
| `operation` | `dynamic` | — | operation value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/recording.ml#L89)

<a id="function-function-miniquake2-renderer-recording-resourceoperation-function-resourceoperation-kind-src-miniquake2-renderer-recording-ml-1440205482"></a>
### resourceOperation

```ml
function resourceOperation(kind)
```

Return the resource operation value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `kind` | `dynamic` | — | kind value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/renderer/recording.ml#L110)
