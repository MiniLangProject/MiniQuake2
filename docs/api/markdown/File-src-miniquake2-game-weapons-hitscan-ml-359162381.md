# `src/miniquake2/game/weapons/hitscan.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 game weapons hitscan facilities for this project.

Package: [`miniquake2.game.weapons.hitscan`](Package-miniquake2-game-weapons-hitscan-237501300.md)

Reachable from entry: **yes**

## Imports

- `miniquake2/game/gameplay/constants.ml` as `gpconstants` → [src/miniquake2/game/gameplay/constants.ml](File-src-miniquake2-game-gameplay-constants-ml-1803115501.md)
- `miniquake2/game/weapons/constants.ml` as `wbconstants` → [src/miniquake2/game/weapons/constants.ml](File-src-miniquake2-game-weapons-constants-ml-539739454.md)
- `miniquake2/game/weapons/core.ml` as `wbcore` → [src/miniquake2/game/weapons/core.ml](File-src-miniquake2-game-weapons-core-ml-1168965024.md)
- `miniquake2/game/weapons/vector.ml` as `wbvector` → [src/miniquake2/game/weapons/vector.ml](File-src-miniquake2-game-weapons-vector-ml-1084549988.md)
- `miniquake2/qcommon/constants.ml` as `qc` → [src/miniquake2/qcommon/constants.ml](File-src-miniquake2-qcommon-constants-ml-1976195726.md)
- `miniquake2/qcommon/text.ml` as `qtext` → [src/miniquake2/qcommon/text.ml](File-src-miniquake2-qcommon-text-ml-1570504148.md)
- `miniquake2/qcommon/types.ml` as `qt` → [src/miniquake2/qcommon/types.ml](File-src-miniquake2-qcommon-types-ml-1663266398.md)

## Declarations

<a id="function-function-miniquake2-game-weapons-hitscan-fire-bullet-function-fire-bullet-context-shooter-start-aimdirection-damage-kick-horizontalspread-verticalspread-meansofdeath-src-miniquake2-game-weapons-hitscan-ml-910295410"></a>
### fire_bullet

```ml
function fire_bullet(context, shooter, start, aimDirection, damage, kick, horizontalSpread, verticalSpread, meansOfDeath)
```

Fire bullet.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `context` | `dynamic` | — | Context that carries state for the operation. |
| `shooter` | `dynamic` | — | shooter value consumed by this operation. |
| `start` | `dynamic` | — | start value consumed by this operation. |
| `aimDirection` | `dynamic` | — | aimDirection value consumed by this operation. |
| `damage` | `dynamic` | — | damage value consumed by this operation. |
| `kick` | `dynamic` | — | kick value consumed by this operation. |
| `horizontalSpread` | `dynamic` | — | horizontalSpread value consumed by this operation. |
| `verticalSpread` | `dynamic` | — | verticalSpread value consumed by this operation. |
| `meansOfDeath` | `dynamic` | — | meansOfDeath value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/weapons/hitscan.ml#L209)

<a id="function-function-miniquake2-game-weapons-hitscan-fire-rail-function-fire-rail-context-shooter-start-aimdirection-damage-kick-src-miniquake2-game-weapons-hitscan-ml-323339347"></a>
### fire_rail

```ml
function fire_rail(context, shooter, start, aimDirection, damage, kick)
```

Fire rail.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `context` | `dynamic` | — | Context that carries state for the operation. |
| `shooter` | `dynamic` | — | shooter value consumed by this operation. |
| `start` | `dynamic` | — | start value consumed by this operation. |
| `aimDirection` | `dynamic` | — | aimDirection value consumed by this operation. |
| `damage` | `dynamic` | — | damage value consumed by this operation. |
| `kick` | `dynamic` | — | kick value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/weapons/hitscan.ml#L233)

<a id="function-function-miniquake2-game-weapons-hitscan-fire-shotgun-function-fire-shotgun-context-shooter-start-aimdirection-damage-kick-horizontalspread-verticalspread-count-meansofdeath-src-miniquake2-game-weapons-hitscan-ml-1757354051"></a>
### fire_shotgun

```ml
function fire_shotgun(context, shooter, start, aimDirection, damage, kick, horizontalSpread, verticalSpread, count, meansOfDeath)
```

Fire shotgun.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `context` | `dynamic` | — | Context that carries state for the operation. |
| `shooter` | `dynamic` | — | shooter value consumed by this operation. |
| `start` | `dynamic` | — | start value consumed by this operation. |
| `aimDirection` | `dynamic` | — | aimDirection value consumed by this operation. |
| `damage` | `dynamic` | — | damage value consumed by this operation. |
| `kick` | `dynamic` | — | kick value consumed by this operation. |
| `horizontalSpread` | `dynamic` | — | horizontalSpread value consumed by this operation. |
| `verticalSpread` | `dynamic` | — | verticalSpread value consumed by this operation. |
| `count` | `dynamic` | — | Number of items or units to process. |
| `meansOfDeath` | `dynamic` | — | meansOfDeath value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/weapons/hitscan.ml#L223)

<a id="function-function-miniquake2-game-weapons-hitscan-firebullet-function-firebullet-context-shooter-start-aimdirection-damage-kick-horizontalspread-verticalspread-meansofdeath-src-miniquake2-game-weapons-hitscan-ml-1883208576"></a>
### fireBullet

```ml
function fireBullet(context, shooter, start, aimDirection, damage, kick, horizontalSpread, verticalSpread, meansOfDeath)
```

Fire bullet.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `context` | `dynamic` | — | Context that carries state for the operation. |
| `shooter` | `dynamic` | — | shooter value consumed by this operation. |
| `start` | `dynamic` | — | start value consumed by this operation. |
| `aimDirection` | `dynamic` | — | aimDirection value consumed by this operation. |
| `damage` | `dynamic` | — | damage value consumed by this operation. |
| `kick` | `dynamic` | — | kick value consumed by this operation. |
| `horizontalSpread` | `dynamic` | — | horizontalSpread value consumed by this operation. |
| `verticalSpread` | `dynamic` | — | verticalSpread value consumed by this operation. |
| `meansOfDeath` | `dynamic` | — | meansOfDeath value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/weapons/hitscan.ml#L125)

<a id="function-function-miniquake2-game-weapons-hitscan-firelead-function-firelead-context-shooter-start-aimdirection-damage-kick-impact-horizontalspread-verticalspread-meansofdeath-src-miniquake2-game-weapons-hitscan-ml-1707062186"></a>
### fireLead

```ml
function fireLead(context, shooter, start, aimDirection, damage, kick, impact, horizontalSpread, verticalSpread, meansOfDeath)
```

Fire lead.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `context` | `dynamic` | — | Context that carries state for the operation. |
| `shooter` | `dynamic` | — | shooter value consumed by this operation. |
| `start` | `dynamic` | — | start value consumed by this operation. |
| `aimDirection` | `dynamic` | — | aimDirection value consumed by this operation. |
| `damage` | `dynamic` | — | damage value consumed by this operation. |
| `kick` | `dynamic` | — | kick value consumed by this operation. |
| `impact` | `dynamic` | — | impact value consumed by this operation. |
| `horizontalSpread` | `dynamic` | — | horizontalSpread value consumed by this operation. |
| `verticalSpread` | `dynamic` | — | verticalSpread value consumed by this operation. |
| `meansOfDeath` | `dynamic` | — | meansOfDeath value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/weapons/hitscan.ml#L41)

<a id="function-function-miniquake2-game-weapons-hitscan-firerail-function-firerail-context-shooter-start-aimdirection-damage-kick-src-miniquake2-game-weapons-hitscan-ml-1292599689"></a>
### fireRail

```ml
function fireRail(context, shooter, start, aimDirection, damage, kick)
```

Fire rail.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `context` | `dynamic` | — | Context that carries state for the operation. |
| `shooter` | `dynamic` | — | shooter value consumed by this operation. |
| `start` | `dynamic` | — | start value consumed by this operation. |
| `aimDirection` | `dynamic` | — | aimDirection value consumed by this operation. |
| `damage` | `dynamic` | — | damage value consumed by this operation. |
| `kick` | `dynamic` | — | kick value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/weapons/hitscan.ml#L157)

<a id="function-function-miniquake2-game-weapons-hitscan-fireshotgun-function-fireshotgun-context-shooter-start-aimdirection-damage-kick-horizontalspread-verticalspread-count-meansofdeath-src-miniquake2-game-weapons-hitscan-ml-2014310583"></a>
### fireShotgun

```ml
function fireShotgun(context, shooter, start, aimDirection, damage, kick, horizontalSpread, verticalSpread, count, meansOfDeath)
```

Fire shotgun.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `context` | `dynamic` | — | Context that carries state for the operation. |
| `shooter` | `dynamic` | — | shooter value consumed by this operation. |
| `start` | `dynamic` | — | start value consumed by this operation. |
| `aimDirection` | `dynamic` | — | aimDirection value consumed by this operation. |
| `damage` | `dynamic` | — | damage value consumed by this operation. |
| `kick` | `dynamic` | — | kick value consumed by this operation. |
| `horizontalSpread` | `dynamic` | — | horizontalSpread value consumed by this operation. |
| `verticalSpread` | `dynamic` | — | verticalSpread value consumed by this operation. |
| `count` | `dynamic` | — | Number of items or units to process. |
| `meansOfDeath` | `dynamic` | — | meansOfDeath value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/weapons/hitscan.ml#L140)

<a id="function-function-miniquake2-game-weapons-hitscan-watersplashstyle-function-watersplashstyle-trace-src-miniquake2-game-weapons-hitscan-ml-1805428482"></a>
### waterSplashStyle

```ml
function waterSplashStyle(trace)
```

Return the water splash style value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `trace` | `dynamic` | — | trace value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/weapons/hitscan.ml#L20)
