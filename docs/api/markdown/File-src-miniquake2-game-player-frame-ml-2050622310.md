# `src/miniquake2/game/player/frame.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 game player frame facilities for this project.

Package: [`miniquake2.game.player.frame`](Package-miniquake2-game-player-frame-840852991.md)

Reachable from entry: **yes**

## Imports

- `miniquake2/game/player/client.ml` as `gplayerclient` → [src/miniquake2/game/player/client.ml](File-src-miniquake2-game-player-client-ml-1308550740.md)
- `miniquake2/game/player/constants.ml` as `gplayerconstants` → [src/miniquake2/game/player/constants.ml](File-src-miniquake2-game-player-constants-ml-946982646.md)
- `miniquake2/game/player/hud.ml` as `gplayerhud` → [src/miniquake2/game/player/hud.ml](File-src-miniquake2-game-player-hud-ml-575673010.md)
- `miniquake2/game/player/rules.ml` as `gplayerrules` → [src/miniquake2/game/player/rules.ml](File-src-miniquake2-game-player-rules-ml-492402760.md)

## Declarations

<a id="function-function-miniquake2-game-player-frame-beginplayerframe-function-beginplayerframe-context-src-miniquake2-game-player-frame-ml-1777030546"></a>
### BeginPlayerFrame

```ml
function BeginPlayerFrame(context)
```

Begin the client portion of a server frame. Return false when the pending intermission exit consumed the frame before any client or entity gameplay.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `context` | `dynamic` | — | Context that carries state for the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/player/frame.ml#L18)

<a id="function-function-miniquake2-game-player-frame-endplayerframe-function-endplayerframe-context-src-miniquake2-game-player-frame-ml-2959638"></a>
### EndPlayerFrame

```ml
function EndPlayerFrame(context)
```

Finish rules and player-state publication after all non-client edicts ran.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `context` | `dynamic` | — | Context that carries state for the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/player/frame.ml#L41)

<a id="function-function-miniquake2-game-player-frame-runplayerframe-function-runplayerframe-context-src-miniquake2-game-player-frame-ml-617314466"></a>
### RunPlayerFrame

```ml
function RunPlayerFrame(context)
```

Run the standalone player-facing frame used by focused component tests.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `context` | `dynamic` | — | Context that carries state for the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/player/frame.ml#L49)
