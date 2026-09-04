# `src/miniquake2/game/gameplay/precache.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 game gameplay precache facilities for this project.

Package: [`miniquake2.game.gameplay.precache`](Package-miniquake2-game-gameplay-precache-1908803796.md)

Reachable from entry: **yes**

## Imports

- `miniquake2/game/gameplay/types.ml` as `gptypes` → [src/miniquake2/game/gameplay/types.ml](File-src-miniquake2-game-gameplay-types-ml-2088064005.md)
- `miniquake2/qcommon/constants.ml` as `qconstants` → [src/miniquake2/qcommon/constants.ml](File-src-miniquake2-qcommon-constants-ml-1976195726.md)
- `miniquake2/qcommon/text.ml` as `qtext` → [src/miniquake2/qcommon/text.ml](File-src-miniquake2-qcommon-text-ml-1570504148.md)

## Declarations

<a id="function-function-miniquake2-game-gameplay-precache-cacheimage-function-cacheimage-result-imports-path-src-miniquake2-game-gameplay-precache-ml-1045375207"></a>
### cacheImage

```ml
function cacheImage(result, imports, path)
```

Cache image.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `result` | `dynamic` | — | Result object populated or inspected by the operation. |
| `imports` | `dynamic` | — | imports value consumed by this operation. |
| `path` | `dynamic` | — | Path of the file or directory used by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/gameplay/precache.ml#L64)

<a id="function-function-miniquake2-game-gameplay-precache-cachemodel-function-cachemodel-result-imports-path-src-miniquake2-game-gameplay-precache-ml-1724205215"></a>
### cacheModel

```ml
function cacheModel(result, imports, path)
```

Cache model.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `result` | `dynamic` | — | Result object populated or inspected by the operation. |
| `imports` | `dynamic` | — | imports value consumed by this operation. |
| `path` | `dynamic` | — | Path of the file or directory used by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/gameplay/precache.ml#L40)

<a id="function-function-miniquake2-game-gameplay-precache-cachesound-function-cachesound-result-imports-path-src-miniquake2-game-gameplay-precache-ml-2140668239"></a>
### cacheSound

```ml
function cacheSound(result, imports, path)
```

Cache sound.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `result` | `dynamic` | — | Result object populated or inspected by the operation. |
| `imports` | `dynamic` | — | imports value consumed by this operation. |
| `path` | `dynamic` | — | Path of the file or directory used by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/gameplay/precache.ml#L52)

<a id="function-function-miniquake2-game-gameplay-precache-cachetokens-function-cachetokens-result-imports-value-itemname-src-miniquake2-game-gameplay-precache-ml-1534526871"></a>
### cacheTokens

```ml
function cacheTokens(result, imports, value, itemName)
```

Cache tokens.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `result` | `dynamic` | — | Result object populated or inspected by the operation. |
| `imports` | `dynamic` | — | imports value consumed by this operation. |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |
| `itemName` | `dynamic` | — | itemName value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/gameplay/precache.ml#L77)

<a id="function-function-miniquake2-game-gameplay-precache-findbypickupname-function-findbypickupname-registry-pickupname-src-miniquake2-game-gameplay-precache-ml-1720819929"></a>
### findByPickupName

```ml
function findByPickupName(registry, pickupName)
```

Finds by pickup name used by the miniquake2 game gameplay precache module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `registry` | `dynamic` | — | registry value consumed by this operation. |
| `pickupName` | `dynamic` | — | pickupName value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/gameplay/precache.ml#L17)

<a id="function-function-miniquake2-game-gameplay-precache-precacheinto-function-precacheinto-registry-item-imports-result-depth-src-miniquake2-game-gameplay-precache-ml-22663553"></a>
### precacheInto

```ml
function precacheInto(registry, item, imports, result, depth)
```

Populate the precache destination.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `registry` | `dynamic` | — | registry value consumed by this operation. |
| `item` | `dynamic` | — | item value consumed by this operation. |
| `imports` | `dynamic` | — | imports value consumed by this operation. |
| `result` | `dynamic` | — | Result object populated or inspected by the operation. |
| `depth` | `dynamic` | — | depth value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/gameplay/precache.ml#L107)

<a id="function-function-miniquake2-game-gameplay-precache-precacheitem-function-precacheitem-registry-item-imports-src-miniquake2-game-gameplay-precache-ml-495806743"></a>
### PrecacheItem

```ml
function PrecacheItem(registry, item, imports)
```

Return the precache item value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `registry` | `dynamic` | — | registry value consumed by this operation. |
| `item` | `dynamic` | — | item value consumed by this operation. |
| `imports` | `dynamic` | — | imports value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/gameplay/precache.ml#L127)

<a id="function-function-miniquake2-game-gameplay-precache-requireimportfunction-function-requireimportfunction-imports-fieldvalue-fieldname-src-miniquake2-game-gameplay-precache-ml-983736335"></a>
### requireImportFunction

```ml
function requireImportFunction(imports, fieldValue, fieldName)
```

Require import function.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `imports` | `dynamic` | — | imports value consumed by this operation. |
| `fieldValue` | `dynamic` | — | fieldValue value consumed by this operation. |
| `fieldName` | `dynamic` | — | fieldName value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/gameplay/precache.ml#L31)
