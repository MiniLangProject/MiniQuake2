# `src/miniquake2/runtime/product_host.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 runtime product host facilities for this project.

Package: [`miniquake2.runtime.product_host`](Package-miniquake2-runtime-product-host-594244099.md)

Reachable from entry: **yes**

## Imports

- `miniquake2/platform/gamma.ml` as `producthostgamma` → [src/miniquake2/platform/gamma.ml](File-src-miniquake2-platform-gamma-ml-1891815907.md)
- `miniquake2/platform/window.ml` as `producthostwindow` → [src/miniquake2/platform/window.ml](File-src-miniquake2-platform-window-ml-103958158.md)
- `miniquake2/renderer/opengl.ml` as `producthostgl` → [src/miniquake2/renderer/opengl.ml](File-src-miniquake2-renderer-opengl-ml-1095768987.md)

## Declarations

<a id="function-function-miniquake2-runtime-product-host-applyproductgamma-function-applyproductgamma-host-gamma-active-src-miniquake2-runtime-product-host-ml-327814707"></a>
### applyProductGamma

```ml
function applyProductGamma(host, gamma, active)
```

Apply product gamma.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `host` | `dynamic` | — | host value consumed by this operation. |
| `gamma` | `dynamic` | — | gamma value consumed by this operation. |
| `active` | `dynamic` | — | active value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/product_host.ml#L380)

<a id="function-function-miniquake2-runtime-product-host-closeproducthost-function-closeproducthost-host-src-miniquake2-runtime-product-host-ml-937519402"></a>
### closeProductHost

```ml
function closeProductHost(host)
```

Close product host.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `host` | `dynamic` | — | host value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/product_host.ml#L436)

<a id="function-function-miniquake2-runtime-product-host-openproducthost-function-openproducthost-title-videomode-fullscreen-rendererimports-src-miniquake2-runtime-product-host-ml-370399110"></a>
### openProductHost

```ml
function openProductHost(title, videoMode, fullScreen, rendererImports)
```

Open product host.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `title` | `dynamic` | — | Human-readable title presented to the user. |
| `videoMode` | `dynamic` | — | videoMode value consumed by this operation. |
| `fullScreen` | `dynamic` | — | fullScreen value consumed by this operation. |
| `rendererImports` | `dynamic` | — | rendererImports value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/product_host.ml#L253)

<a id="function-function-miniquake2-runtime-product-host-openproducthostwith-function-openproducthostwith-callbacks-title-videomode-fullscreen-rendererimports-src-miniquake2-runtime-product-host-ml-95614056"></a>
### openProductHostWith

```ml
function openProductHostWith(callbacks, title, videoMode, fullScreen, rendererImports)
```

Open product host with.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `callbacks` | `dynamic` | — | callbacks value consumed by this operation. |
| `title` | `dynamic` | — | Human-readable title presented to the user. |
| `videoMode` | `dynamic` | — | videoMode value consumed by this operation. |
| `fullScreen` | `dynamic` | — | fullScreen value consumed by this operation. |
| `rendererImports` | `dynamic` | — | rendererImports value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/product_host.ml#L148)

- [miniquake2.runtime.product_host.ProductHost](Type-miniquake2-runtime-product-host-producthost-1357894128.md) — struct
- [miniquake2.runtime.product_host.ProductHostCallbacks](Type-miniquake2-runtime-product-host-producthostcallbacks-740488232.md) — struct
<a id="function-function-miniquake2-runtime-product-host-producthostcreaterenderer-function-producthostcreaterenderer-imports-contextactive-src-miniquake2-runtime-product-host-ml-482734947"></a>
### productHostCreateRenderer

```ml
function productHostCreateRenderer(imports, contextActive)
```

Create product host renderer.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `imports` | `dynamic` | — | imports value consumed by this operation. |
| `contextActive` | `dynamic` | — | contextActive value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/product_host.ml#L81)

<a id="function-function-miniquake2-runtime-product-host-producthostcreatewindow-function-producthostcreatewindow-title-width-height-fullscreen-src-miniquake2-runtime-product-host-ml-358647950"></a>
### productHostCreateWindow

```ml
function productHostCreateWindow(title, width, height, fullScreen)
```

Create product host window.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `title` | `dynamic` | — | Human-readable title presented to the user. |
| `width` | `dynamic` | — | Width in the coordinate or storage units used by the caller. |
| `height` | `dynamic` | — | Height in the coordinate or storage units used by the caller. |
| `fullScreen` | `dynamic` | — | fullScreen value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/product_host.ml#L59)

<a id="function-function-miniquake2-runtime-product-host-producthostdefaultcallbacks-function-producthostdefaultcallbacks-src-miniquake2-runtime-product-host-ml-1595920952"></a>
### productHostDefaultCallbacks

```ml
function productHostDefaultCallbacks()
```

Return the product host default callbacks value.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/product_host.ml#L104)

<a id="function-function-miniquake2-runtime-product-host-producthostdestroywindow-function-producthostdestroywindow-window-src-miniquake2-runtime-product-host-ml-2097738256"></a>
### productHostDestroyWindow

```ml
function productHostDestroyWindow(window)
```

Return the product host destroy window value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `window` | `dynamic` | — | window value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/product_host.ml#L74)

<a id="function-function-miniquake2-runtime-product-host-producthostdimensions-function-producthostdimensions-videomode-src-miniquake2-runtime-product-host-ml-26187954"></a>
### productHostDimensions

```ml
function productHostDimensions(videoMode)
```

Return the product host dimensions.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `videoMode` | `dynamic` | — | videoMode value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/product_host.ml#L113)

<a id="function-function-miniquake2-runtime-product-host-producthostdrawtext-function-producthostdrawtext-exports-x-y-text-src-miniquake2-runtime-product-host-ml-1179940897"></a>
### productHostDrawText

```ml
function productHostDrawText(exports, x, y, text)
```

Draw product host text.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `exports` | `dynamic` | — | exports value consumed by this operation. |
| `x` | `dynamic` | — | Horizontal coordinate used by the operation. |
| `y` | `dynamic` | — | Vertical coordinate used by the operation. |
| `text` | `dynamic` | — | Text consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/product_host.ml#L263)

<a id="function-function-miniquake2-runtime-product-host-producthostinitrenderer-function-producthostinitrenderer-renderer-src-miniquake2-runtime-product-host-ml-237106747"></a>
### productHostInitRenderer

```ml
function productHostInitRenderer(renderer)
```

Initialize product host renderer.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `renderer` | `dynamic` | — | renderer value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/product_host.ml#L87)

<a id="function-function-miniquake2-runtime-product-host-producthostreconfigurewindow-function-producthostreconfigurewindow-window-width-height-fullscreen-src-miniquake2-runtime-product-host-ml-1927404824"></a>
### productHostReconfigureWindow

```ml
function productHostReconfigureWindow(window, width, height, fullScreen)
```

Reconfigure product host window.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `window` | `dynamic` | — | window value consumed by this operation. |
| `width` | `dynamic` | — | Width in the coordinate or storage units used by the caller. |
| `height` | `dynamic` | — | Height in the coordinate or storage units used by the caller. |
| `fullScreen` | `dynamic` | — | fullScreen value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/product_host.ml#L68)

<a id="function-function-miniquake2-runtime-product-host-producthostrequirecallbacks-function-producthostrequirecallbacks-callbacks-src-miniquake2-runtime-product-host-ml-844631066"></a>
### productHostRequireCallbacks

```ml
function productHostRequireCallbacks(callbacks)
```

Require product host callbacks.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `callbacks` | `dynamic` | — | callbacks value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/product_host.ml#L129)

<a id="function-function-miniquake2-runtime-product-host-producthostrestarterror-function-producthostrestarterror-host-title-rendererimports-oldvideomode-oldfullscreen-gamma-restartfailure-src-miniquake2-runtime-product-host-ml-982161430"></a>
### productHostRestartError

```ml
function productHostRestartError(host, title, rendererImports, oldVideoMode, oldFullScreen, gamma, restartFailure)
```

Restart product host error.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `host` | `dynamic` | — | host value consumed by this operation. |
| `title` | `dynamic` | — | Human-readable title presented to the user. |
| `rendererImports` | `dynamic` | — | rendererImports value consumed by this operation. |
| `oldVideoMode` | `dynamic` | — | oldVideoMode value consumed by this operation. |
| `oldFullScreen` | `dynamic` | — | oldFullScreen value consumed by this operation. |
| `gamma` | `dynamic` | — | gamma value consumed by this operation. |
| `restartFailure` | `dynamic` | — | restartFailure value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/product_host.ml#L236)

<a id="function-function-miniquake2-runtime-product-host-producthostshutdownrenderer-function-producthostshutdownrenderer-renderer-src-miniquake2-runtime-product-host-ml-1814062011"></a>
### productHostShutdownRenderer

```ml
function productHostShutdownRenderer(renderer)
```

Shut down product host renderer.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `renderer` | `dynamic` | — | renderer value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/product_host.ml#L99)

<a id="function-function-miniquake2-runtime-product-host-resetproductrenderer-function-resetproductrenderer-host-rendererimports-src-miniquake2-runtime-product-host-ml-1543779587"></a>
### resetProductRenderer

```ml
function resetProductRenderer(host, rendererImports)
```

Rebuild renderer-owned managed state while preserving the native window and its OpenGL context. Media chains use this between heavyweight 3D steps.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `host` | `dynamic` | — | host value consumed by this operation. |
| `rendererImports` | `dynamic` | — | rendererImports value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/product_host.ml#L406)

<a id="function-function-miniquake2-runtime-product-host-restartproducthost-function-restartproducthost-host-title-videomode-fullscreen-rendererimports-src-miniquake2-runtime-product-host-ml-608637194"></a>
### restartProductHost

```ml
function restartProductHost(host, title, videoMode, fullScreen, rendererImports)
```

Restart product host.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `host` | `dynamic` | — | host value consumed by this operation. |
| `title` | `dynamic` | — | Human-readable title presented to the user. |
| `videoMode` | `dynamic` | — | videoMode value consumed by this operation. |
| `fullScreen` | `dynamic` | — | fullScreen value consumed by this operation. |
| `rendererImports` | `dynamic` | — | rendererImports value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/product_host.ml#L297)

<a id="function-function-miniquake2-runtime-product-host-restoreproducthost-function-restoreproducthost-host-title-videomode-fullscreen-rendererimports-gamma-src-miniquake2-runtime-product-host-ml-2070029673"></a>
### restoreProductHost

```ml
function restoreProductHost(host, title, videoMode, fullScreen, rendererImports, gamma)
```

Recreate the last known-good video host after a target mode, context or renderer initialization failure.  The native backend owns one window at a time, so this rollback is necessarily performed after the old host closes.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `host` | `dynamic` | — | host value consumed by this operation. |
| `title` | `dynamic` | — | Human-readable title presented to the user. |
| `videoMode` | `dynamic` | — | videoMode value consumed by this operation. |
| `fullScreen` | `dynamic` | — | fullScreen value consumed by this operation. |
| `rendererImports` | `dynamic` | — | rendererImports value consumed by this operation. |
| `gamma` | `dynamic` | — | gamma value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/product_host.ml#L186)

<a id="function-function-miniquake2-runtime-product-host-showproductloading-function-showproductloading-host-label-src-miniquake2-runtime-product-host-ml-1522722598"></a>
### showProductLoading

```ml
function showProductLoading(host, label)
```

Return the show product loading value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `host` | `dynamic` | — | host value consumed by this operation. |
| `label` | `dynamic` | — | label value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/product_host.ml#L277)
