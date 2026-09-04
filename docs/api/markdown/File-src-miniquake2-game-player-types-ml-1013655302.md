# `src/miniquake2/game/player/types.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 game player types facilities for this project.

Package: [`miniquake2.game.player.types`](Package-miniquake2-game-player-types-1229206535.md)

Reachable from entry: **yes**

## Imports

- `miniquake2/game/gameplay/registry.ml` as `gpregistry` → [src/miniquake2/game/gameplay/registry.ml](File-src-miniquake2-game-gameplay-registry-ml-1541508425.md)
- `miniquake2/game/gameplay/types.ml` as `gptypes` → [src/miniquake2/game/gameplay/types.ml](File-src-miniquake2-game-gameplay-types-ml-2088064005.md)
- `miniquake2/game/player/constants.ml` as `gplayerconstants` → [src/miniquake2/game/player/constants.ml](File-src-miniquake2-game-player-constants-ml-946982646.md)
- `miniquake2/game/types.ml` as `gtypes` → [src/miniquake2/game/types.ml](File-src-miniquake2-game-types-ml-1384205920.md)

## Declarations

<a id="function-function-miniquake2-game-player-types-connectresult-function-connectresult-accepted-userinfo-rejection-src-miniquake2-game-player-types-ml-719979434"></a>
### connectResult

```ml
function connectResult(accepted, userInfo, rejection)
```

Connect result.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `accepted` | `dynamic` | — | accepted value consumed by this operation. |
| `userInfo` | `dynamic` | — | userInfo value consumed by this operation. |
| `rejection` | `dynamic` | — | rejection value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/player/types.ml#L494)

- [miniquake2.game.player.types.ConnectResult](Type-miniquake2-game-player-types-connectresult-566738278.md) — struct
<a id="function-function-miniquake2-game-player-types-createcontext-function-createcontext-imports-registry-pmovetrace-src-miniquake2-game-player-types-ml-792538384"></a>
### createContext

```ml
function createContext(imports, registry, pmoveTrace)
```

Create context.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `imports` | `dynamic` | — | imports value consumed by this operation. |
| `registry` | `dynamic` | — | registry value consumed by this operation. |
| `pmoveTrace` | `dynamic` | — | pmoveTrace value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/player/types.ml#L479)

<a id="function-function-miniquake2-game-player-types-createplayer-function-createplayer-number-registry-src-miniquake2-game-player-types-ml-1738436851"></a>
### createPlayer

```ml
function createPlayer(number, registry)
```

Create player.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `number` | `dynamic` | — | number value consumed by this operation. |
| `registry` | `dynamic` | — | registry value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/player/types.ml#L448)

- [miniquake2.game.player.types.DeathResult](Type-miniquake2-game-player-types-deathresult-507329958.md) — struct
<a id="function-function-miniquake2-game-player-types-defaultviewsettings-function-defaultviewsettings-src-miniquake2-game-player-types-ml-1817754535"></a>
### defaultViewSettings

```ml
function defaultViewSettings()
```

Return the default view settings value.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/player/types.ml#L441)

- [miniquake2.game.player.types.FrameResult](Type-miniquake2-game-player-types-frameresult-833824201.md) — struct
- [miniquake2.game.player.types.PlayerContext](Type-miniquake2-game-player-types-playercontext-1192503013.md) — struct
- [miniquake2.game.player.types.PlayerData](Type-miniquake2-game-player-types-playerdata-971010698.md) — struct
- [miniquake2.game.player.types.PlayerPersistent](Type-miniquake2-game-player-types-playerpersistent-968553823.md) — struct
- [miniquake2.game.player.types.PlayerPowerups](Type-miniquake2-game-player-types-playerpowerups-601264183.md) — struct
- [miniquake2.game.player.types.PlayerRespawn](Type-miniquake2-game-player-types-playerrespawn-1079995138.md) — struct
- [miniquake2.game.player.types.PlayerView](Type-miniquake2-game-player-types-playerview-264482547.md) — struct
- [miniquake2.game.player.types.RuleResult](Type-miniquake2-game-player-types-ruleresult-846517172.md) — struct
- [miniquake2.game.player.types.SpawnSelection](Type-miniquake2-game-player-types-spawnselection-449573816.md) — struct
<a id="function-function-miniquake2-game-player-types-spawnspot-function-spawnspot-classname-targetname-origin-angles-src-miniquake2-game-player-types-ml-80099900"></a>
### spawnSpot

```ml
function spawnSpot(className, targetName, origin, angles)
```

Spawn spot.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `className` | `dynamic` | — | className value consumed by this operation. |
| `targetName` | `dynamic` | — | targetName value consumed by this operation. |
| `origin` | `dynamic` | — | origin value consumed by this operation. |
| `angles` | `dynamic` | — | angles value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/player/types.ml#L406)

- [miniquake2.game.player.types.SpawnSpot](Type-miniquake2-game-player-types-spawnspot-453128046.md) — struct
- [miniquake2.game.player.types.ViewSettings](Type-miniquake2-game-player-types-viewsettings-825427563.md) — struct
<a id="function-function-miniquake2-game-player-types-zeropersistent-function-zeropersistent-src-miniquake2-game-player-types-ml-314725449"></a>
### zeroPersistent

```ml
function zeroPersistent()
```

Return the zero persistent value.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/player/types.ml#L411)

<a id="function-function-miniquake2-game-player-types-zeroplayerview-function-zeroplayerview-src-miniquake2-game-player-types-ml-680626429"></a>
### zeroPlayerView

```ml
function zeroPlayerView()
```

Return the zero player view value.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/player/types.ml#L423)

<a id="function-function-miniquake2-game-player-types-zerorespawn-function-zerorespawn-itemslots-src-miniquake2-game-player-types-ml-874251311"></a>
### zeroRespawn

```ml
function zeroRespawn(itemSlots)
```

Return the zero respawn value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `itemSlots` | `dynamic` | — | itemSlots value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/player/types.ml#L418)
