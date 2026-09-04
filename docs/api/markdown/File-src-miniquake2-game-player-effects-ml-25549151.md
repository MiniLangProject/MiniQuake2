# `src/miniquake2/game/player/effects.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 game player effects facilities for this project.

Package: [`miniquake2.game.player.effects`](Package-miniquake2-game-player-effects-419919504.md)

Reachable from entry: **yes**

## Imports

- `miniquake2/game/constants.ml` as `gpeconstants` → [src/miniquake2/game/constants.ml](File-src-miniquake2-game-constants-ml-1723282332.md)
- `miniquake2/qcommon/constants.ml` as `gpeqconstants` → [src/miniquake2/qcommon/constants.ml](File-src-miniquake2-qcommon-constants-ml-1976195726.md)

## Declarations

<a id="function-function-miniquake2-game-player-effects-emitconnectioneffect-function-emitconnectioneffect-context-player-flash-src-miniquake2-game-player-effects-ml-1755163445"></a>
### EmitConnectionEffect

```ml
function EmitConnectionEffect(context, player, flash)
```

Emit the four-byte Protocol-34 player muzzleflash used for login/logout.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `context` | `dynamic` | — | Context that carries state for the operation. |
| `player` | `dynamic` | — | player value consumed by this operation. |
| `flash` | `dynamic` | — | flash value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/player/effects.ml#L17)
