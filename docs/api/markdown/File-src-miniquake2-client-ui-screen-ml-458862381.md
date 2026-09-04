# `src/miniquake2/client/ui/screen.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 client ui screen facilities for this project.

Package: [`miniquake2.client.ui.screen`](Package-miniquake2-client-ui-screen-1578439522.md)

Reachable from entry: **yes**

## Imports

- `miniquake2/client/layout.ml` as `clayout` → [src/miniquake2/client/layout.ml](File-src-miniquake2-client-layout-ml-1290796160.md)
- `miniquake2/client/ui/console.ml` as `cuiconsole` → [src/miniquake2/client/ui/console.ml](File-src-miniquake2-client-ui-console-ml-367794066.md)
- `miniquake2/client/ui/keys.ml` as `cuiscreenkeys` → [src/miniquake2/client/ui/keys.ml](File-src-miniquake2-client-ui-keys-ml-2076131853.md)
- `miniquake2/client/ui/menu.ml` as `cuimenu` → [src/miniquake2/client/ui/menu.ml](File-src-miniquake2-client-ui-menu-ml-1156054796.md)
- `miniquake2/client/ui/types.ml` as `cuitypes` → [src/miniquake2/client/ui/types.ml](File-src-miniquake2-client-ui-types-ml-24306002.md)
- `miniquake2/qcommon/constants.ml` as `cuiscreenqc` → [src/miniquake2/qcommon/constants.ml](File-src-miniquake2-qcommon-constants-ml-1976195726.md)

## Declarations

<a id="function-function-miniquake2-client-ui-screen-centerprint-function-centerprint-screen-text-now-duration-src-miniquake2-client-ui-screen-ml-1178397836"></a>
### centerPrint

```ml
function centerPrint(screen, text, now, duration)
```

Print center.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `screen` | `dynamic` | — | screen value consumed by this operation. |
| `text` | `dynamic` | — | Text consumed by the operation. |
| `now` | `dynamic` | — | now value consumed by this operation. |
| `duration` | `dynamic` | — | duration value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/ui/screen.ml#L55)

<a id="function-function-miniquake2-client-ui-screen-create-function-create-console-menu-src-miniquake2-client-ui-screen-ml-1283981751"></a>
### create

```ml
function create(console, menu)
```

Creates create for the miniquake2 client ui screen module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `console` | `dynamic` | — | console value consumed by this operation. |
| `menu` | `dynamic` | — | menu value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/ui/screen.ml#L20)

<a id="function-function-miniquake2-client-ui-screen-crosshairposition-function-crosshairposition-screenwidth-screenheight-picturewidth-pictureheight-src-miniquake2-client-ui-screen-ml-1725250821"></a>
### crosshairPosition

```ml
function crosshairPosition(screenWidth, screenHeight, pictureWidth, pictureHeight)
```

Return the crosshair position.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `screenWidth` | `dynamic` | — | screenWidth value consumed by this operation. |
| `screenHeight` | `dynamic` | — | screenHeight value consumed by this operation. |
| `pictureWidth` | `dynamic` | — | pictureWidth value consumed by this operation. |
| `pictureHeight` | `dynamic` | — | pictureHeight value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/ui/screen.ml#L30)

<a id="function-function-miniquake2-client-ui-screen-draw-function-draw-screen-now-screenwidth-screenheight-stats-configstrings-serverframe-playernumber-exports-src-miniquake2-client-ui-screen-ml-1005996276"></a>
### draw

```ml
function draw(screen, now, screenWidth, screenHeight, stats, configStrings, serverFrame, playerNumber, exports)
```

Draws draw through the miniquake2 client ui screen rendering path.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `screen` | `dynamic` | — | screen value consumed by this operation. |
| `now` | `dynamic` | — | now value consumed by this operation. |
| `screenWidth` | `dynamic` | — | screenWidth value consumed by this operation. |
| `screenHeight` | `dynamic` | — | screenHeight value consumed by this operation. |
| `stats` | `dynamic` | — | stats value consumed by this operation. |
| `configStrings` | `dynamic` | — | configStrings value consumed by this operation. |
| `serverFrame` | `dynamic` | — | serverFrame value consumed by this operation. |
| `playerNumber` | `dynamic` | — | playerNumber value consumed by this operation. |
| `exports` | `dynamic` | — | exports value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/ui/screen.ml#L207)

<a id="function-function-miniquake2-client-ui-screen-drawcenteredlines-function-drawcenteredlines-exports-screenwidth-starty-text-src-miniquake2-client-ui-screen-ml-562564338"></a>
### drawCenteredLines

```ml
function drawCenteredLines(exports, screenWidth, startY, text)
```

Draw centered lines.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `exports` | `dynamic` | — | exports value consumed by this operation. |
| `screenWidth` | `dynamic` | — | screenWidth value consumed by this operation. |
| `startY` | `dynamic` | — | startY value consumed by this operation. |
| `text` | `dynamic` | — | Text consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/ui/screen.ml#L146)

<a id="function-function-miniquake2-client-ui-screen-drawcrosshair-function-drawcrosshair-screen-screenwidth-screenheight-exports-src-miniquake2-client-ui-screen-ml-892858747"></a>
### drawCrosshair

```ml
function drawCrosshair(screen, screenWidth, screenHeight, exports)
```

Draw crosshair.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `screen` | `dynamic` | — | screen value consumed by this operation. |
| `screenWidth` | `dynamic` | — | screenWidth value consumed by this operation. |
| `screenHeight` | `dynamic` | — | screenHeight value consumed by this operation. |
| `exports` | `dynamic` | — | exports value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/ui/screen.ml#L39)

<a id="function-function-miniquake2-client-ui-screen-drawinventory-function-drawinventory-screen-screenwidth-screenheight-exports-src-miniquake2-client-ui-screen-ml-1017828347"></a>
### drawInventory

```ml
function drawInventory(screen, screenWidth, screenHeight, exports)
```

Draw inventory.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `screen` | `dynamic` | — | screen value consumed by this operation. |
| `screenWidth` | `dynamic` | — | screenWidth value consumed by this operation. |
| `screenHeight` | `dynamic` | — | screenHeight value consumed by this operation. |
| `exports` | `dynamic` | — | exports value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/ui/screen.ml#L168)

<a id="function-function-miniquake2-client-ui-screen-drawtext-function-drawtext-exports-x-y-text-src-miniquake2-client-ui-screen-ml-784045118"></a>
### drawText

```ml
function drawText(exports, x, y, text)
```

Draws text through the miniquake2 client ui screen rendering path.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `exports` | `dynamic` | — | exports value consumed by this operation. |
| `x` | `dynamic` | — | Horizontal coordinate used by the operation. |
| `y` | `dynamic` | — | Vertical coordinate used by the operation. |
| `text` | `dynamic` | — | Text consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/ui/screen.ml#L133)

<a id="function-function-miniquake2-client-ui-screen-setinventory-function-setinventory-screen-items-selected-src-miniquake2-client-ui-screen-ml-1917240312"></a>
### setInventory

```ml
function setInventory(screen, items, selected)
```

Set inventory.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `screen` | `dynamic` | — | screen value consumed by this operation. |
| `items` | `dynamic` | — | Items consumed or updated by the operation. |
| `selected` | `dynamic` | — | selected value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/ui/screen.ml#L67)

<a id="function-function-miniquake2-client-ui-screen-updateinventory-function-updateinventory-screen-values-configstrings-selected-src-miniquake2-client-ui-screen-ml-255685184"></a>
### updateInventory

```ml
function updateInventory(screen, values, configStrings, selected)
```

Convert the fixed Protocol-34 inventory vector into the compact rows the renderer needs. Receiving an update does not implicitly open the inventory; the local `inven` command owns that user-visible toggle.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `screen` | `dynamic` | — | screen value consumed by this operation. |
| `values` | `dynamic` | — | values value consumed by this operation. |
| `configStrings` | `dynamic` | — | configStrings value consumed by this operation. |
| `selected` | `dynamic` | — | selected value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/ui/screen.ml#L81)

<a id="function-function-miniquake2-client-ui-screen-updateinventoryhotkeys-function-updateinventoryhotkeys-screen-input-src-miniquake2-client-ui-screen-ml-160569337"></a>
### updateInventoryHotkeys

```ml
function updateInventoryHotkeys(screen, input)
```

Resolve the first exact `use <item>` binding shown by the stock inventory.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `screen` | `dynamic` | — | screen value consumed by this operation. |
| `input` | `dynamic` | — | input value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/ui/screen.ml#L114)
