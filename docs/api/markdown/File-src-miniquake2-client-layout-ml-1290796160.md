# `src/miniquake2/client/layout.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 client layout facilities for this project.

Package: [`miniquake2.client.layout`](Package-miniquake2-client-layout-1297571132.md)

Reachable from entry: **yes**

## Imports

- `miniquake2/game/constants.ml` as `lgc` → [src/miniquake2/game/constants.ml](File-src-miniquake2-game-constants-ml-1723282332.md)
- `miniquake2/qcommon/cmd.ml` as `lcmd` → [src/miniquake2/qcommon/cmd.ml](File-src-miniquake2-qcommon-cmd-ml-1514462021.md)
- `miniquake2/qcommon/constants.ml` as `lqc` → [src/miniquake2/qcommon/constants.ml](File-src-miniquake2-qcommon-constants-ml-1976195726.md)

## Declarations

<a id="function-function-miniquake2-client-layout-draw-function-draw-commands-exports-src-miniquake2-client-layout-ml-1946588517"></a>
### draw

```ml
function draw(commands, exports)
```

Draws draw through the miniquake2 client layout rendering path.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `commands` | `dynamic` | — | commands value consumed by this operation. |
| `exports` | `dynamic` | — | exports value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/layout.ml#L365)

<a id="function-function-miniquake2-client-layout-drawcount-function-drawcount-commands-commandcount-exports-src-miniquake2-client-layout-ml-539095843"></a>
### drawCount

```ml
function drawCount(commands, commandCount, exports)
```

Draw count.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `commands` | `dynamic` | — | commands value consumed by this operation. |
| `commandCount` | `dynamic` | — | Number of command to process. |
| `exports` | `dynamic` | — | exports value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/layout.ml#L373)

<a id="function-function-miniquake2-client-layout-drawnumber-function-drawnumber-exports-x-y-value-width-color-src-miniquake2-client-layout-ml-1427781280"></a>
### drawNumber

```ml
function drawNumber(exports, x, y, value, width, color)
```

Draw number.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `exports` | `dynamic` | — | exports value consumed by this operation. |
| `x` | `dynamic` | — | Horizontal coordinate used by the operation. |
| `y` | `dynamic` | — | Vertical coordinate used by the operation. |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |
| `width` | `dynamic` | — | Width in the coordinate or storage units used by the caller. |
| `color` | `dynamic` | — | color value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/layout.ml#L338)

<a id="function-function-miniquake2-client-layout-drawtext-function-drawtext-exports-x-y-text-style-src-miniquake2-client-layout-ml-1389634058"></a>
### drawText

```ml
function drawText(exports, x, y, text, style)
```

Draws text through the miniquake2 client layout rendering path.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `exports` | `dynamic` | — | exports value consumed by this operation. |
| `x` | `dynamic` | — | Horizontal coordinate used by the operation. |
| `y` | `dynamic` | — | Vertical coordinate used by the operation. |
| `text` | `dynamic` | — | Text consumed by the operation. |
| `style` | `dynamic` | — | style value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/layout.ml#L322)

<a id="function-function-miniquake2-client-layout-fixedplayername-function-fixedplayername-name-src-miniquake2-client-layout-ml-1412352839"></a>
### fixedPlayerName

```ml
function fixedPlayerName(name)
```

Return the fixed player name.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `name` | `dynamic` | — | Name of the affected item. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/layout.ml#L103)

<a id="function-function-miniquake2-client-layout-integer-function-integer-token-operation-src-miniquake2-client-layout-ml-1317774448"></a>
### integer

```ml
function integer(token, operation)
```

Return the integer value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `token` | `dynamic` | — | token value consumed by this operation. |
| `operation` | `dynamic` | — | operation value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/layout.ml#L35)

- [miniquake2.client.layout.LayoutCommand](Type-miniquake2-client-layout-layoutcommand-1566731001.md) — struct
<a id="function-function-miniquake2-client-layout-padleft3-function-padleft3-value-src-miniquake2-client-layout-ml-1983533721"></a>
### padLeft3

```ml
function padLeft3(value)
```

Pad left 3.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/layout.ml#L94)

<a id="function-function-miniquake2-client-layout-parse-function-parse-layout-stats-configstrings-screenwidth-screenheight-src-miniquake2-client-layout-ml-98966130"></a>
### parse

```ml
function parse(layout, stats, configStrings, screenWidth, screenHeight)
```

Parses parse for the miniquake2 client layout workflow.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `layout` | `dynamic` | — | layout value consumed by this operation. |
| `stats` | `dynamic` | — | stats value consumed by this operation. |
| `configStrings` | `dynamic` | — | configStrings value consumed by this operation. |
| `screenWidth` | `dynamic` | — | screenWidth value consumed by this operation. |
| `screenHeight` | `dynamic` | — | screenHeight value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/layout.ml#L312)

<a id="function-function-miniquake2-client-layout-parseatframe-function-parseatframe-layout-stats-configstrings-screenwidth-screenheight-serverframe-playernumber-src-miniquake2-client-layout-ml-445247952"></a>
### parseAtFrame

```ml
function parseAtFrame(layout, stats, configStrings, screenWidth, screenHeight, serverFrame, playerNumber)
```

Parse at frame.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `layout` | `dynamic` | — | layout value consumed by this operation. |
| `stats` | `dynamic` | — | stats value consumed by this operation. |
| `configStrings` | `dynamic` | — | configStrings value consumed by this operation. |
| `screenWidth` | `dynamic` | — | screenWidth value consumed by this operation. |
| `screenHeight` | `dynamic` | — | screenHeight value consumed by this operation. |
| `serverFrame` | `dynamic` | — | serverFrame value consumed by this operation. |
| `playerNumber` | `dynamic` | — | playerNumber value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/layout.ml#L300)

<a id="function-function-miniquake2-client-layout-parsetokens-function-parsetokens-tokens-stats-configstrings-screenwidth-screenheight-src-miniquake2-client-layout-ml-1615837558"></a>
### parseTokens

```ml
function parseTokens(tokens, stats, configStrings, screenWidth, screenHeight)
```

Parse tokens.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `tokens` | `dynamic` | — | tokens value consumed by this operation. |
| `stats` | `dynamic` | — | stats value consumed by this operation. |
| `configStrings` | `dynamic` | — | configStrings value consumed by this operation. |
| `screenWidth` | `dynamic` | — | screenWidth value consumed by this operation. |
| `screenHeight` | `dynamic` | — | screenHeight value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/layout.ml#L288)

<a id="function-function-miniquake2-client-layout-parsetokenscontext-function-parsetokenscontext-tokens-stats-configstrings-screenwidth-screenheight-serverframe-playernumber-src-miniquake2-client-layout-ml-871433920"></a>
### parseTokensContext

```ml
function parseTokensContext(tokens, stats, configStrings, screenWidth, screenHeight, serverFrame, playerNumber)
```

Parse tokens context.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `tokens` | `dynamic` | — | tokens value consumed by this operation. |
| `stats` | `dynamic` | — | stats value consumed by this operation. |
| `configStrings` | `dynamic` | — | configStrings value consumed by this operation. |
| `screenWidth` | `dynamic` | — | screenWidth value consumed by this operation. |
| `screenHeight` | `dynamic` | — | screenHeight value consumed by this operation. |
| `serverFrame` | `dynamic` | — | serverFrame value consumed by this operation. |
| `playerNumber` | `dynamic` | — | playerNumber value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/layout.ml#L263)

<a id="function-function-miniquake2-client-layout-parsetokenscontextinto-function-parsetokenscontextinto-commands-tokens-stats-configstrings-screenwidth-screenheight-serverframe-playernumber-src-miniquake2-client-layout-ml-2090627526"></a>
### parseTokensContextInto

```ml
function parseTokensContextInto(commands, tokens, stats, configStrings, screenWidth, screenHeight, serverFrame, playerNumber)
```

Populate the parse tokens context destination.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `commands` | `dynamic` | — | commands value consumed by this operation. |
| `tokens` | `dynamic` | — | tokens value consumed by this operation. |
| `stats` | `dynamic` | — | stats value consumed by this operation. |
| `configStrings` | `dynamic` | — | configStrings value consumed by this operation. |
| `screenWidth` | `dynamic` | — | screenWidth value consumed by this operation. |
| `screenHeight` | `dynamic` | — | screenHeight value consumed by this operation. |
| `serverFrame` | `dynamic` | — | serverFrame value consumed by this operation. |
| `playerNumber` | `dynamic` | — | playerNumber value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/layout.ml#L122)

<a id="function-function-miniquake2-client-layout-playeridentity-function-playeridentity-configstrings-playerindex-src-miniquake2-client-layout-ml-1270866847"></a>
### playerIdentity

```ml
function playerIdentity(configStrings, playerIndex)
```

Return the player identity value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `configStrings` | `dynamic` | — | configStrings value consumed by this operation. |
| `playerIndex` | `dynamic` | — | Zero-based index of player. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/layout.ml#L67)

<a id="function-function-miniquake2-client-layout-requiretoken-function-requiretoken-tokens-index-operation-src-miniquake2-client-layout-ml-923776363"></a>
### requireToken

```ml
function requireToken(tokens, index, operation)
```

Require token.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `tokens` | `dynamic` | — | tokens value consumed by this operation. |
| `index` | `dynamic` | — | Zero-based index of the affected item. |
| `operation` | `dynamic` | — | operation value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/layout.ml#L53)

<a id="function-function-miniquake2-client-layout-stat-function-stat-stats-index-src-miniquake2-client-layout-ml-1654733065"></a>
### stat

```ml
function stat(stats, index)
```

Return the stat value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `stats` | `dynamic` | — | stats value consumed by this operation. |
| `index` | `dynamic` | — | Zero-based index of the affected item. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/layout.ml#L44)

<a id="function-function-miniquake2-client-layout-tokenize-function-tokenize-layout-src-miniquake2-client-layout-ml-1373398468"></a>
### tokenize

```ml
function tokenize(layout)
```

Return the tokenize value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `layout` | `dynamic` | — | layout value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/layout.ml#L60)
