# `src/miniquake2/client/screenshot.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 client screenshot facilities for this project.

Package: [`miniquake2.client.screenshot`](Package-miniquake2-client-screenshot-771906262.md)

Reachable from entry: **yes**

## Imports

- `miniquake2/renderer/capture.ml` as `screenshotcapture` → [src/miniquake2/renderer/capture.ml](File-src-miniquake2-renderer-capture-ml-993518394.md)
- `std/fs.ml` as `screenshotfs` → `../MiniLangCompilerML/std/fs.ml` — external dependency

## Declarations

<a id="function-function-miniquake2-client-screenshot-capture-function-capture-state-width-height-src-miniquake2-client-screenshot-ml-1627445478"></a>
### capture

```ml
function capture(state, width, height)
```

Call after RenderFrame/UI and before EndFrame swaps the back buffer.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |
| `width` | `dynamic` | — | Width in the coordinate or storage units used by the caller. |
| `height` | `dynamic` | — | Height in the coordinate or storage units used by the caller. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/screenshot.ml#L86)

<a id="function-function-miniquake2-client-screenshot-create-function-create-directory-src-miniquake2-client-screenshot-ml-1352800651"></a>
### create

```ml
function create(directory)
```

Creates create for the miniquake2 client screenshot module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `directory` | `dynamic` | — | directory value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/screenshot.ml#L29)

<a id="extern_function-extern-function-miniquake2-client-screenshot-createdirectoryw-extern-function-createdirectoryw-path-as-wstr-security-as-ptr-from-kernel32-dll-returns-bool-src-miniquake2-client-screenshot-ml-1433909667"></a>
### CreateDirectoryW

```ml
extern function CreateDirectoryW(path as wstr, security as ptr) from "kernel32.dll" returns bool
```

Invokes the native CreateDirectoryW entry point used by the miniquake2 client screenshot module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `path` | `wstr` | — | Path of the file or directory used by the operation. |
| `security` | `ptr` | — | security value consumed by this operation. |


**Returns:** Native bool result produced by the call.

[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/screenshot.ml#L17)

<a id="function-function-miniquake2-client-screenshot-ensuredirectory-function-ensuredirectory-path-src-miniquake2-client-screenshot-ml-1526519125"></a>
### ensureDirectory

```ml
function ensureDirectory(path)
```

Ensure directory.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `path` | `dynamic` | — | Path of the file or directory used by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/screenshot.ml#L37)

<a id="function-function-miniquake2-client-screenshot-filename-function-filename-index-src-miniquake2-client-screenshot-ml-901076746"></a>
### fileName

```ml
function fileName(index)
```

Return the file name.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `index` | `dynamic` | — | Zero-based index of the affected item. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/screenshot.ml#L61)

<a id="function-function-miniquake2-client-screenshot-paddedindex-function-paddedindex-index-src-miniquake2-client-screenshot-ml-371245470"></a>
### paddedIndex

```ml
function paddedIndex(index)
```

Return the padded index.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `index` | `dynamic` | — | Zero-based index of the affected item. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/screenshot.ml#L48)

<a id="function-function-miniquake2-client-screenshot-reservepath-function-reservepath-state-src-miniquake2-client-screenshot-ml-633009643"></a>
### reservePath

```ml
function reservePath(state)
```

Reserve path.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/screenshot.ml#L67)

- [miniquake2.client.screenshot.ScreenshotState](Type-miniquake2-client-screenshot-screenshotstate-1705118593.md) — struct
<a id="function-function-miniquake2-client-screenshot-writeimage-function-writeimage-state-image-src-miniquake2-client-screenshot-ml-974709920"></a>
### writeImage

```ml
function writeImage(state, image)
```

Write image.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |
| `image` | `dynamic` | — | image value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/screenshot.ml#L96)
