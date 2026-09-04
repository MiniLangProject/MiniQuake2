# `src/miniquake2/game/player/spawn.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 game player spawn facilities for this project.

Package: [`miniquake2.game.player.spawn`](Package-miniquake2-game-player-spawn-313526381.md)

Reachable from entry: **yes**

## Imports

- `miniquake2/game/player/types.ml` as `gplayertypes` → [src/miniquake2/game/player/types.ml](File-src-miniquake2-game-player-types-ml-1013655302.md)
- `miniquake2/qcommon/text.ml` as `qtext` → [src/miniquake2/qcommon/text.ml](File-src-miniquake2-qcommon-text-ml-1570504148.md)
- `std/math.ml` as `gplayermath` → `../MiniLangCompilerML/std/math.ml` — external dependency

## Declarations

<a id="function-function-miniquake2-game-player-spawn-applystockcoopspawnfixups-function-applystockcoopspawnfixups-mapname-spots-src-miniquake2-game-player-spawn-ml-787492297"></a>
### ApplyStockCoopSpawnFixups

```ml
function ApplyStockCoopSpawnFixups(mapName, spots)
```

Stock p_client.c applies these corrections one frame after entity spawn. The managed layer extracts immutable spawn records before clients begin, so applying the same map-specific data correction here is equivalent and keeps the live BaseEdict graph untouched.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `mapName` | `dynamic` | — | mapName value consumed by this operation. |
| `spots` | `dynamic` | — | spots value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/player/spawn.ml#L68)

<a id="function-function-miniquake2-game-player-spawn-deathmatchspots-function-deathmatchspots-context-src-miniquake2-game-player-spawn-ml-516839890"></a>
### deathmatchSpots

```ml
function deathmatchSpots(context)
```

Return the deathmatch spots value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `context` | `dynamic` | — | Context that carries state for the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/player/spawn.ml#L130)

<a id="function-function-miniquake2-game-player-spawn-deterministicindex-function-deterministicindex-context-count-src-miniquake2-game-player-spawn-ml-1830206055"></a>
### deterministicIndex

```ml
function deterministicIndex(context, count)
```

Return the deterministic index.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `context` | `dynamic` | — | Context that carries state for the operation. |
| `count` | `dynamic` | — | Number of items or units to process. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/player/spawn.ml#L154)

<a id="function-function-miniquake2-game-player-spawn-distance-function-distance-first-second-src-miniquake2-game-player-spawn-ml-625773745"></a>
### distance

```ml
function distance(first, second)
```

Return the distance value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `first` | `dynamic` | — | first value consumed by this operation. |
| `second` | `dynamic` | — | second value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/player/spawn.ml#L102)

<a id="function-function-miniquake2-game-player-spawn-nearestplayerdistance-function-nearestplayerdistance-context-spot-spawningplayer-src-miniquake2-game-player-spawn-ml-1150111318"></a>
### nearestPlayerDistance

```ml
function nearestPlayerDistance(context, spot, spawningPlayer)
```

Return the nearest player distance value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `context` | `dynamic` | — | Context that carries state for the operation. |
| `spot` | `dynamic` | — | spot value consumed by this operation. |
| `spawningPlayer` | `dynamic` | — | spawningPlayer value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/player/spawn.ml#L113)

<a id="function-function-miniquake2-game-player-spawn-selectcoopspawnpoint-function-selectcoopspawnpoint-context-player-src-miniquake2-game-player-spawn-ml-1313702949"></a>
### SelectCoopSpawnPoint

```ml
function SelectCoopSpawnPoint(context, player)
```

Select coop spawn point.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `context` | `dynamic` | — | Context that carries state for the operation. |
| `player` | `dynamic` | — | player value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/player/spawn.ml#L231)

<a id="function-function-miniquake2-game-player-spawn-selectdeathmatchspawnpoint-function-selectdeathmatchspawnpoint-context-player-src-miniquake2-game-player-spawn-ml-2125617129"></a>
### SelectDeathmatchSpawnPoint

```ml
function SelectDeathmatchSpawnPoint(context, player)
```

Select deathmatch spawn point.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `context` | `dynamic` | — | Context that carries state for the operation. |
| `player` | `dynamic` | — | player value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/player/spawn.ml#L223)

<a id="function-function-miniquake2-game-player-spawn-selectfarthestdeathmatchspawnpoint-function-selectfarthestdeathmatchspawnpoint-context-player-src-miniquake2-game-player-spawn-ml-410036017"></a>
### SelectFarthestDeathmatchSpawnPoint

```ml
function SelectFarthestDeathmatchSpawnPoint(context, player)
```

Select farthest deathmatch spawn point.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `context` | `dynamic` | — | Context that carries state for the operation. |
| `player` | `dynamic` | — | player value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/player/spawn.ml#L141)

<a id="function-function-miniquake2-game-player-spawn-selectintermissionpoint-function-selectintermissionpoint-context-src-miniquake2-game-player-spawn-ml-862949194"></a>
### SelectIntermissionPoint

```ml
function SelectIntermissionPoint(context)
```

Select intermission point.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `context` | `dynamic` | — | Context that carries state for the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/player/spawn.ml#L164)

<a id="function-function-miniquake2-game-player-spawn-selectrandomdeathmatchspawnpoint-function-selectrandomdeathmatchspawnpoint-context-player-src-miniquake2-game-player-spawn-ml-621014369"></a>
### SelectRandomDeathmatchSpawnPoint

```ml
function SelectRandomDeathmatchSpawnPoint(context, player)
```

Select random deathmatch spawn point.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `context` | `dynamic` | — | Context that carries state for the operation. |
| `player` | `dynamic` | — | player value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/player/spawn.ml#L189)

<a id="function-function-miniquake2-game-player-spawn-selectsingleplayerspawnpoint-function-selectsingleplayerspawnpoint-context-src-miniquake2-game-player-spawn-ml-1361703090"></a>
### SelectSinglePlayerSpawnPoint

```ml
function SelectSinglePlayerSpawnPoint(context)
```

Select single player spawn point.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `context` | `dynamic` | — | Context that carries state for the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/player/spawn.ml#L251)

<a id="function-function-miniquake2-game-player-spawn-selectspawnpoint-function-selectspawnpoint-context-player-src-miniquake2-game-player-spawn-ml-293323697"></a>
### SelectSpawnPoint

```ml
function SelectSpawnPoint(context, player)
```

Select spawn point.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `context` | `dynamic` | — | Context that carries state for the operation. |
| `player` | `dynamic` | — | player value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/player/spawn.ml#L272)

<a id="function-function-miniquake2-game-player-spawn-spotsfrombaseedicts-function-spotsfrombaseedicts-baseedicts-src-miniquake2-game-player-spawn-ml-730787426"></a>
### spotsFromBaseEdicts

```ml
function spotsFromBaseEdicts(baseEdicts)
```

Return the spots from base edicts.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `baseEdicts` | `dynamic` | — | baseEdicts value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/player/spawn.ml#L16)

<a id="function-function-miniquake2-game-player-spawn-stockcoopfixmap-function-stockcoopfixmap-mapname-src-miniquake2-game-player-spawn-ml-1597013880"></a>
### stockCoopFixMap

```ml
function stockCoopFixMap(mapName)
```

Map stock coop fix.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `mapName` | `dynamic` | — | mapName value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/player/spawn.ml#L45)
