# `src/miniquake2/client/ui/console.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 client ui console facilities for this project.

Package: [`miniquake2.client.ui.console`](Package-miniquake2-client-ui-console-772676055.md)

Reachable from entry: **yes**

## Imports

- `miniquake2/client/ui/constants.ml` as `cuic` → [src/miniquake2/client/ui/constants.ml](File-src-miniquake2-client-ui-constants-ml-1004124106.md)
- `miniquake2/client/ui/types.ml` as `cuitypes` → [src/miniquake2/client/ui/types.ml](File-src-miniquake2-client-ui-types-ml-24306002.md)
- `std/math.ml` as `smath` → `../MiniLangCompilerML/std/math.ml` — external dependency

## Declarations

<a id="function-function-miniquake2-client-ui-console-appendhistory-function-appendhistory-console-value-src-miniquake2-client-ui-console-ml-1150897483"></a>
### appendHistory

```ml
function appendHistory(console, value)
```

Append history.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `console` | `dynamic` | — | console value consumed by this operation. |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/ui/console.ml#L79)

<a id="function-function-miniquake2-client-ui-console-appendline-function-appendline-console-text-time-src-miniquake2-client-ui-console-ml-1455206954"></a>
### appendLine

```ml
function appendLine(console, text, time)
```

Append line.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `console` | `dynamic` | — | console value consumed by this operation. |
| `text` | `dynamic` | — | Text consumed by the operation. |
| `time` | `dynamic` | — | time value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/ui/console.ml#L26)

<a id="function-function-miniquake2-client-ui-console-appendtext-function-appendtext-console-text-time-src-miniquake2-client-ui-console-ml-520514842"></a>
### appendText

```ml
function appendText(console, text, time)
```

Append text.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `console` | `dynamic` | — | console value consumed by this operation. |
| `text` | `dynamic` | — | Text consumed by the operation. |
| `time` | `dynamic` | — | time value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/ui/console.ml#L37)

<a id="function-function-miniquake2-client-ui-console-clearnotify-function-clearnotify-console-src-miniquake2-client-ui-console-ml-686384644"></a>
### clearNotify

```ml
function clearNotify(console)
```

Clear notify.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `console` | `dynamic` | — | console value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/ui/console.ml#L69)

<a id="function-function-miniquake2-client-ui-console-cleartyping-function-cleartyping-console-src-miniquake2-client-ui-console-ml-1831242500"></a>
### clearTyping

```ml
function clearTyping(console)
```

Clear typing.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `console` | `dynamic` | — | console value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/ui/console.ml#L61)

<a id="function-function-miniquake2-client-ui-console-create-function-create-widthchars-src-miniquake2-client-ui-console-ml-1883920978"></a>
### create

```ml
function create(widthChars)
```

Creates create for the miniquake2 client ui console module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `widthChars` | `dynamic` | — | widthChars value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/ui/console.ml#L16)

<a id="function-function-miniquake2-client-ui-console-draincommands-inline-function-draincommands-console-src-miniquake2-client-ui-console-ml-254231395"></a>
### drainCommands

```ml
inline function drainCommands(console)
```

Performs the drainCommands operation for the miniquake2 client ui console module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `console` | `dynamic` | — | console value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/ui/console.ml#L151)

<a id="function-function-miniquake2-client-ui-console-draw-function-draw-console-screenwidth-screenheight-exports-src-miniquake2-client-ui-console-ml-1262931746"></a>
### draw

```ml
function draw(console, screenWidth, screenHeight, exports)
```

Draws draw through the miniquake2 client ui console rendering path.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `console` | `dynamic` | — | console value consumed by this operation. |
| `screenWidth` | `dynamic` | — | screenWidth value consumed by this operation. |
| `screenHeight` | `dynamic` | — | screenHeight value consumed by this operation. |
| `exports` | `dynamic` | — | exports value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/ui/console.ml#L197)

<a id="function-function-miniquake2-client-ui-console-drawtext-function-drawtext-exports-x-y-text-src-miniquake2-client-ui-console-ml-2108478550"></a>
### drawText

```ml
function drawText(exports, x, y, text)
```

Draws text through the miniquake2 client ui console rendering path.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `exports` | `dynamic` | — | exports value consumed by this operation. |
| `x` | `dynamic` | — | Horizontal coordinate used by the operation. |
| `y` | `dynamic` | — | Vertical coordinate used by the operation. |
| `text` | `dynamic` | — | Text consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/ui/console.ml#L165)

<a id="function-function-miniquake2-client-ui-console-editkey-function-editkey-console-key-src-miniquake2-client-ui-console-ml-1116278959"></a>
### editKey

```ml
function editKey(console, key)
```

Return the edit key value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `console` | `dynamic` | — | console value consumed by this operation. |
| `key` | `dynamic` | — | key value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/ui/console.ml#L117)

<a id="function-function-miniquake2-client-ui-console-insertbyte-function-insertbyte-console-value-src-miniquake2-client-ui-console-ml-836731283"></a>
### insertByte

```ml
function insertByte(console, value)
```

Insert byte.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `console` | `dynamic` | — | console value consumed by this operation. |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/ui/console.ml#L103)

<a id="function-function-miniquake2-client-ui-console-notify-function-notify-console-now-exports-src-miniquake2-client-ui-console-ml-2085071605"></a>
### notify

```ml
function notify(console, now, exports)
```

Notify state.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `console` | `dynamic` | — | console value consumed by this operation. |
| `now` | `dynamic` | — | now value consumed by this operation. |
| `exports` | `dynamic` | — | exports value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/ui/console.ml#L178)
