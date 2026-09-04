# `src/miniquake2/runtime/media_sequence.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 runtime media sequence facilities for this project.

Package: [`miniquake2.runtime.media_sequence`](Package-miniquake2-runtime-media-sequence-1307755465.md)

Reachable from entry: **yes**

## Imports

- `miniquake2/qcommon/cmd.ml` as `mediaseqcmd` → [src/miniquake2/qcommon/cmd.ml](File-src-miniquake2-qcommon-cmd-ml-1514462021.md)
- `miniquake2/qcommon/constants.ml` as `mediaseqqc` → [src/miniquake2/qcommon/constants.ml](File-src-miniquake2-qcommon-constants-ml-1976195726.md)
- `miniquake2/qcommon/text.ml` as `mediaseqtext` → [src/miniquake2/qcommon/text.ml](File-src-miniquake2-qcommon-text-ml-1570504148.md)

## Declarations

<a id="function-function-miniquake2-runtime-media-sequence-attractinterrupted-function-attractinterrupted-input-src-miniquake2-runtime-media-sequence-ml-107437754"></a>
### attractInterrupted

```ml
function attractInterrupted(input)
```

keys.c maps any press during cl.attractloop to Escape. Grave/Escape may already have changed key_dest before this check, while ordinary buttons are represented by the held-key table.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `input` | `dynamic` | — | input value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/media_sequence.ml#L234)

<a id="function-function-miniquake2-runtime-media-sequence-cooperativepicturesuccessor-function-cooperativepicturesuccessor-step-cooperative-src-miniquake2-runtime-media-sequence-ml-1200414485"></a>
### cooperativePictureSuccessor

```ml
function cooperativePictureSuccessor(step, cooperative)
```

Preserve the original ZOID cooperative end-screen loop back to base1.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `step` | `dynamic` | — | step value consumed by this operation. |
| `cooperative` | `dynamic` | — | cooperative value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/media_sequence.ml#L96)

<a id="function-function-miniquake2-runtime-media-sequence-endswithinsensitive-function-endswithinsensitive-value-suffix-src-miniquake2-runtime-media-sequence-ml-2009788260"></a>
### endsWithInsensitive

```ml
function endsWithInsensitive(value, suffix)
```

Return the ends with insensitive value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |
| `suffix` | `dynamic` | — | suffix value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/media_sequence.ml#L110)

<a id="function-function-miniquake2-runtime-media-sequence-gamebuttondown-function-gamebuttondown-input-src-miniquake2-runtime-media-sequence-ml-211258746"></a>
### gameButtonDown

```ml
function gameButtonDown(input)
```

Return the game button down value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `input` | `dynamic` | — | input value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/media_sequence.ml#L215)

<a id="function-function-miniquake2-runtime-media-sequence-gamemappolicy-function-gamemappolicy-step-singleplayer-src-miniquake2-runtime-media-sequence-ml-292421971"></a>
### gameMapPolicy

```ml
function gameMapPolicy(step, singlePlayer)
```

Match SV_GameMap_f: archive the outgoing level inside a unit, wipe the current-unit archive at `*`, and autosave the successfully spawned successor.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `step` | `dynamic` | — | step value consumed by this operation. |
| `singlePlayer` | `dynamic` | — | singlePlayer value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/media_sequence.ml#L85)

- [miniquake2.runtime.media_sequence.GameMapPolicy](Type-miniquake2-runtime-media-sequence-gamemappolicy-1144263065.md) — struct
<a id="function-function-miniquake2-runtime-media-sequence-kindname-function-kindname-kind-src-miniquake2-runtime-media-sequence-ml-718599998"></a>
### kindName

```ml
function kindName(kind)
```

Return the kind name.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `kind` | `dynamic` | — | kind value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/media_sequence.ml#L271)

<a id="constant-constant-miniquake2-runtime-media-sequence-max-media-steps-const-max-media-steps-16-src-miniquake2-runtime-media-sequence-ml-2135439548"></a>
### MAX_MEDIA_STEPS

```ml
const MAX_MEDIA_STEPS = 16
```

Defines the max media steps constant used by the miniquake2 runtime media sequence module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/media_sequence.ml#L23)

<a id="constant-constant-miniquake2-runtime-media-sequence-max-media-transitions-const-max-media-transitions-64-src-miniquake2-runtime-media-sequence-ml-1609544891"></a>
### MAX_MEDIA_TRANSITIONS

```ml
const MAX_MEDIA_TRANSITIONS = 64
```

Defines the max media transitions constant used by the miniquake2 runtime media sequence module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/media_sequence.ml#L25)

<a id="constant-constant-miniquake2-runtime-media-sequence-media-cin-const-media-cin-1-src-miniquake2-runtime-media-sequence-ml-1735510210"></a>
### MEDIA_CIN

```ml
const MEDIA_CIN = 1
```

Defines the media cin constant used by the miniquake2 runtime media sequence module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/media_sequence.ml#L17)

<a id="constant-constant-miniquake2-runtime-media-sequence-media-dm2-const-media-dm2-3-src-miniquake2-runtime-media-sequence-ml-955232772"></a>
### MEDIA_DM2

```ml
const MEDIA_DM2 = 3
```

Defines the media dm2 constant used by the miniquake2 runtime media sequence module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/media_sequence.ml#L21)

<a id="constant-constant-miniquake2-runtime-media-sequence-media-map-const-media-map-0-src-miniquake2-runtime-media-sequence-ml-1185465983"></a>
### MEDIA_MAP

```ml
const MEDIA_MAP = 0
```

Defines the media map constant used by the miniquake2 runtime media sequence module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/media_sequence.ml#L15)

<a id="constant-constant-miniquake2-runtime-media-sequence-media-pcx-const-media-pcx-2-src-miniquake2-runtime-media-sequence-ml-226477237"></a>
### MEDIA_PCX

```ml
const MEDIA_PCX = 2
```

Defines the media pcx constant used by the miniquake2 runtime media sequence module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/media_sequence.ml#L19)

- [miniquake2.runtime.media_sequence.MediaSequence](Type-miniquake2-runtime-media-sequence-mediasequence-423598066.md) — struct
- [miniquake2.runtime.media_sequence.MediaStep](Type-miniquake2-runtime-media-sequence-mediastep-44543073.md) — struct
<a id="function-function-miniquake2-runtime-media-sequence-nextstockattractindex-function-nextstockattractindex-index-src-miniquake2-runtime-media-sequence-ml-1294845850"></a>
### nextStockAttractIndex

```ml
function nextStockAttractIndex(index)
```

Return the next stock attract index.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `index` | `dynamic` | — | Zero-based index of the affected item. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/media_sequence.ml#L201)

<a id="function-function-miniquake2-runtime-media-sequence-parse-function-parse-specification-src-miniquake2-runtime-media-sequence-ml-1260180841"></a>
### parse

```ml
function parse(specification)
```

Parses parse for the miniquake2 runtime media sequence workflow.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `specification` | `dynamic` | — | specification value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/media_sequence.ml#L245)

<a id="function-function-miniquake2-runtime-media-sequence-parsestep-function-parsestep-component-src-miniquake2-runtime-media-sequence-ml-774600243"></a>
### parseStep

```ml
function parseStep(component)
```

Parse step.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `component` | `dynamic` | — | component value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/media_sequence.ml#L149)

<a id="function-function-miniquake2-runtime-media-sequence-safename-function-safename-value-operation-src-miniquake2-runtime-media-sequence-ml-1232094530"></a>
### safeName

```ml
function safeName(value, operation)
```

Return the safe name.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |
| `operation` | `dynamic` | — | operation value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/media_sequence.ml#L126)

<a id="constant-constant-miniquake2-runtime-media-sequence-stock-attract-steps-const-stock-attract-steps-4-src-miniquake2-runtime-media-sequence-ml-336734467"></a>
### STOCK_ATTRACT_STEPS

```ml
const STOCK_ATTRACT_STEPS = 4
```

Defines the stock attract steps constant used by the miniquake2 runtime media sequence module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/media_sequence.ml#L27)

<a id="function-function-miniquake2-runtime-media-sequence-stockattractstep-function-stockattractstep-index-src-miniquake2-runtime-media-sequence-ml-2036018378"></a>
### stockAttractStep

```ml
function stockAttractStep(index)
```

Stock Quake II 3.19 obtains these four entries from the d1..d4 aliases in baseq2/default.cfg. There is no demos.lst lookup in the original client.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `index` | `dynamic` | — | Zero-based index of the affected item. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/media_sequence.ml#L190)

<a id="function-function-miniquake2-runtime-media-sequence-stocknewgamespecification-function-stocknewgamespecification-src-miniquake2-runtime-media-sequence-ml-1147972014"></a>
### stockNewGameSpecification

```ml
function stockNewGameSpecification()
```

The stock New Game alias is `map *ntro.cin+base1`. The leading star is legal for every SV_Map media kind and marks a new unit/save epoch before SV_Map strips it and classifies the .cin extension.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/media_sequence.ml#L209)

<a id="function-function-miniquake2-runtime-media-sequence-takequeuedgamemap-function-takequeuedgamemap-commandsystem-src-miniquake2-runtime-media-sequence-ml-1734431450"></a>
### takeQueuedGameMap

```ml
function takeQueuedGameMap(commandSystem)
```

The game module queues `gamemap "spec"` through AddCommandString after intermission exit. Validate the complete first command before removing it; unrelated server-console work remains untouched for its own policy layer.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `commandSystem` | `dynamic` | — | commandSystem value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/media_sequence.ml#L283)

<a id="function-function-miniquake2-runtime-media-sequence-takequeuedloadmenu-function-takequeuedloadmenu-commandsystem-src-miniquake2-runtime-media-sequence-ml-1411783602"></a>
### takeQueuedLoadMenu

```ml
function takeQueuedLoadMenu(commandSystem)
```

Single-player death uses the original game-DLL AddCommandString boundary to ask the client host for its load-game menu. Keep that request out of the UI module itself, validate it exactly, and preserve unrelated console commands.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `commandSystem` | `dynamic` | — | commandSystem value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/media_sequence.ml#L306)

<a id="function-function-miniquake2-runtime-media-sequence-timedemometrics-function-timedemometrics-frames-elapsedmsec-src-miniquake2-runtime-media-sequence-ml-1290256558"></a>
### timedemoMetrics

```ml
function timedemoMetrics(frames, elapsedMsec)
```

Compute the same frames/time report exposed by Quake II's timedemo path.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `frames` | `dynamic` | — | frames value consumed by this operation. |
| `elapsedMsec` | `dynamic` | — | elapsedMsec value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/media_sequence.ml#L72)

- [miniquake2.runtime.media_sequence.TimedemoMetrics](Type-miniquake2-runtime-media-sequence-timedemometrics-1988499452.md) — struct
