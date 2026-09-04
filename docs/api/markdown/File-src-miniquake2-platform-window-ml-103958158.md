# `src/miniquake2/platform/window.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 platform window facilities for this project.

Package: [`miniquake2.platform.window`](Package-miniquake2-platform-window-1426483614.md)

Reachable from entry: **yes**

## Imports

- `miniquake2/native.ml` as `native` → [src/miniquake2/native.ml](File-src-miniquake2-native-ml-139597585.md)

## Declarations

<a id="function-function-miniquake2-platform-window-applynativewindowmode-function-applynativewindowmode-width-height-fullscreen-src-miniquake2-platform-window-ml-1028818488"></a>
### applyNativeWindowMode

```ml
function applyNativeWindowMode(width, height, fullscreen)
```

Apply one native mode transaction and return the verified client size. The caller retains the logical Window fields until this transaction succeeds.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `width` | `dynamic` | — | Width in the coordinate or storage units used by the caller. |
| `height` | `dynamic` | — | Height in the coordinate or storage units used by the caller. |
| `fullscreen` | `dynamic` | — | fullscreen value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/platform/window.ml#L109)

<a id="function-function-miniquake2-platform-window-create-function-create-title-width-height-fullscreen-src-miniquake2-platform-window-ml-1067016154"></a>
### create

```ml
function create(title, width, height, fullscreen)
```

Creates create for the miniquake2 platform window module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `title` | `dynamic` | — | Human-readable title presented to the user. |
| `width` | `dynamic` | — | Width in the coordinate or storage units used by the caller. |
| `height` | `dynamic` | — | Height in the coordinate or storage units used by the caller. |
| `fullscreen` | `dynamic` | — | fullscreen value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/platform/window.ml#L64)

<a id="function-function-miniquake2-platform-window-destroy-function-destroy-window-src-miniquake2-platform-window-ml-609630350"></a>
### destroy

```ml
function destroy(window)
```

Return the destroy value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `window` | `dynamic` | — | window value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/platform/window.ml#L217)

- [miniquake2.platform.window.InputEvent](Type-miniquake2-platform-window-inputevent-1934567052.md) — struct
<a id="function-function-miniquake2-platform-window-poll-function-poll-window-src-miniquake2-platform-window-ml-1375743190"></a>
### poll

```ml
function poll(window)
```

Performs the poll operation for the miniquake2 platform window module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `window` | `dynamic` | — | window value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/platform/window.ml#L170)

<a id="function-function-miniquake2-platform-window-popinputevent-function-popinputevent-src-miniquake2-platform-window-ml-1879706716"></a>
### popInputEvent

```ml
function popInputEvent()
```

Return the pop input event value.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/platform/window.ml#L226)

<a id="function-function-miniquake2-platform-window-reconfigure-function-reconfigure-window-width-height-fullscreen-src-miniquake2-platform-window-ml-2104478446"></a>
### reconfigure

```ml
function reconfigure(window, width, height, fullscreen)
```

Reconfigure one live Win32 window without destroying its OpenGL context. Changing display mode and frame style in place preserves every registered GPU resource and, consequently, the active level and client presentation.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `window` | `dynamic` | — | window value consumed by this operation. |
| `width` | `dynamic` | — | Width in the coordinate or storage units used by the caller. |
| `height` | `dynamic` | — | Height in the coordinate or storage units used by the caller. |
| `fullscreen` | `dynamic` | — | fullscreen value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/platform/window.ml#L142)

<a id="function-function-miniquake2-platform-window-resolveddisplaymode-function-resolveddisplaymode-width-height-fullscreen-exclusiveavailable-desktopwidth-desktopheight-src-miniquake2-platform-window-ml-1211504996"></a>
### resolvedDisplayMode

```ml
function resolvedDisplayMode(width, height, fullscreen, exclusiveAvailable, desktopWidth, desktopHeight)
```

Resolve a fixed Quake II menu mode to a mode the active monitor can safely display. The third value selects the native "use current display mode" borderless fallback.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `width` | `dynamic` | — | Width in the coordinate or storage units used by the caller. |
| `height` | `dynamic` | — | Height in the coordinate or storage units used by the caller. |
| `fullscreen` | `dynamic` | — | fullscreen value consumed by this operation. |
| `exclusiveAvailable` | `dynamic` | — | exclusiveAvailable value consumed by this operation. |
| `desktopWidth` | `dynamic` | — | desktopWidth value consumed by this operation. |
| `desktopHeight` | `dynamic` | — | desktopHeight value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/platform/window.ml#L47)

<a id="function-function-miniquake2-platform-window-setmousecapture-function-setmousecapture-enabled-src-miniquake2-platform-window-ml-1253819023"></a>
### setMouseCapture

```ml
function setMouseCapture(enabled)
```

Set mouse capture.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `enabled` | `dynamic` | — | enabled value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/platform/window.ml#L234)

<a id="function-function-miniquake2-platform-window-settitle-function-settitle-window-title-src-miniquake2-platform-window-ml-1505133576"></a>
### setTitle

```ml
function setTitle(window, title)
```

Set title.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `window` | `dynamic` | — | window value consumed by this operation. |
| `title` | `dynamic` | — | Human-readable title presented to the user. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/platform/window.ml#L206)

<a id="function-function-miniquake2-platform-window-setverticalsync-function-setverticalsync-window-enabled-src-miniquake2-platform-window-ml-302841163"></a>
### setVerticalSync

```ml
function setVerticalSync(window, enabled)
```

Apply the archived Quake II swap interval to the live OpenGL context.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `window` | `dynamic` | — | window value consumed by this operation. |
| `enabled` | `dynamic` | — | enabled value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/platform/window.ml#L190)

<a id="function-function-miniquake2-platform-window-swap-function-swap-window-src-miniquake2-platform-window-ml-1359545950"></a>
### swap

```ml
function swap(window)
```

Swap state.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `window` | `dynamic` | — | window value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/platform/window.ml#L181)

- [miniquake2.platform.window.Window](Type-miniquake2-platform-window-window-755955212.md) — struct
