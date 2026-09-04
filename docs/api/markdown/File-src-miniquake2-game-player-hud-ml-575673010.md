# `src/miniquake2/game/player/hud.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 game player hud facilities for this project.

Package: [`miniquake2.game.player.hud`](Package-miniquake2-game-player-hud-1640530163.md)

Reachable from entry: **yes**

## Imports

- `miniquake2/game/gameplay/item_rules.ml` as `gprules` → [src/miniquake2/game/gameplay/item_rules.ml](File-src-miniquake2-game-gameplay-item-rules-ml-1747940557.md)
- `miniquake2/game/player/view.ml` as `gplayerview` → [src/miniquake2/game/player/view.ml](File-src-miniquake2-game-player-view-ml-886735230.md)
- `miniquake2/qcommon/byteio.ml` as `qbyteio` → [src/miniquake2/qcommon/byteio.ml](File-src-miniquake2-qcommon-byteio-ml-159119335.md)

## Declarations

<a id="function-function-miniquake2-game-player-hud-clientendserverframe-function-clientendserverframe-context-player-src-miniquake2-game-player-hud-ml-501582729"></a>
### ClientEndServerFrame

```ml
function ClientEndServerFrame(context, player)
```

End client server frame.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `context` | `dynamic` | — | Context that carries state for the operation. |
| `player` | `dynamic` | — | player value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/player/hud.ml#L155)

<a id="function-function-miniquake2-game-player-hud-clientendserverframes-function-clientendserverframes-context-src-miniquake2-game-player-hud-ml-67978528"></a>
### ClientEndServerFrames

```ml
function ClientEndServerFrames(context)
```

End client server frames.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `context` | `dynamic` | — | Context that carries state for the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/player/hud.ml#L175)

<a id="function-function-miniquake2-game-player-hud-copystats-function-copystats-source-target-src-miniquake2-game-player-hud-ml-364270469"></a>
### copyStats

```ml
function copyStats(source, target)
```

Copy stats data.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `source` | `dynamic` | — | source value consumed by this operation. |
| `target` | `dynamic` | — | target value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/player/hud.ml#L109)

<a id="function-function-miniquake2-game-player-hud-g-checkchasestats-function-g-checkchasestats-context-target-src-miniquake2-game-player-hud-ml-1586818559"></a>
### G_CheckChaseStats

```ml
function G_CheckChaseStats(context, target)
```

Validate g chase stats.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `context` | `dynamic` | — | Context that carries state for the operation. |
| `target` | `dynamic` | — | target value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/player/hud.ml#L140)

<a id="function-function-miniquake2-game-player-hud-g-setspectatorstats-function-g-setspectatorstats-context-player-src-miniquake2-game-player-hud-ml-1943382093"></a>
### G_SetSpectatorStats

```ml
function G_SetSpectatorStats(context, player)
```

Set g spectator stats.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `context` | `dynamic` | — | Context that carries state for the operation. |
| `player` | `dynamic` | — | player value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/player/hud.ml#L121)

<a id="function-function-miniquake2-game-player-hud-g-setstats-function-g-setstats-context-player-src-miniquake2-game-player-hud-ml-802972889"></a>
### G_SetStats

```ml
function G_SetStats(context, player)
```

Set g stats.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `context` | `dynamic` | — | Context that carries state for the operation. |
| `player` | `dynamic` | — | player value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/player/hud.ml#L48)

<a id="function-function-miniquake2-game-player-hud-imageindex-function-imageindex-context-name-src-miniquake2-game-player-hud-ml-470669091"></a>
### imageIndex

```ml
function imageIndex(context, name)
```

Return the image index.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `context` | `dynamic` | — | Context that carries state for the operation. |
| `name` | `dynamic` | — | Name of the affected item. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/player/hud.ml#L17)

<a id="function-function-miniquake2-game-player-hud-timerstats-function-timerstats-context-player-stats-src-miniquake2-game-player-hud-ml-1022936262"></a>
### timerStats

```ml
function timerStats(context, player, stats)
```

Return the timer stats value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `context` | `dynamic` | — | Context that carries state for the operation. |
| `player` | `dynamic` | — | player value consumed by this operation. |
| `stats` | `dynamic` | — | stats value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/player/hud.ml#L26)
