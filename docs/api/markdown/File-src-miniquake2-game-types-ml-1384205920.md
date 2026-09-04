# `src/miniquake2/game/types.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 game types facilities for this project.

Package: [`miniquake2.game.types`](Package-miniquake2-game-types-1715016726.md)

Reachable from entry: **yes**

## Imports

- `miniquake2/game/constants.ml` as `gc` → [src/miniquake2/game/constants.ml](File-src-miniquake2-game-constants-ml-1723282332.md)
- `miniquake2/qcommon/types.ml` as `qt` → [src/miniquake2/qcommon/types.ml](File-src-miniquake2-qcommon-types-ml-1663266398.md)

## Declarations

<a id="function-function-miniquake2-game-types-cvar-function-cvar-name-value-flags-src-miniquake2-game-types-ml-1834448959"></a>
### cvar

```ml
function cvar(name, value, flags)
```

Return the cvar value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `name` | `dynamic` | — | Name of the affected item. |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |
| `flags` | `dynamic` | — | Bit flags controlling the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/types.ml#L501)

- [miniquake2.game.types.Cvar](Type-miniquake2-game-types-cvar-1872176442.md) — struct
- [miniquake2.game.types.Edict](Type-miniquake2-game-types-edict-1482208503.md) — struct
- [miniquake2.game.types.EntityState](Type-miniquake2-game-types-entitystate-400110404.md) — struct
- [miniquake2.game.types.GameClient](Type-miniquake2-game-types-gameclient-143941433.md) — struct
- [miniquake2.game.types.GameExport](Type-miniquake2-game-types-gameexport-104137880.md) — struct
- [miniquake2.game.types.GameImport](Type-miniquake2-game-types-gameimport-1870824615.md) — struct
- [miniquake2.game.types.Link](Type-miniquake2-game-types-link-2126040792.md) — struct
- [miniquake2.game.types.PlayerState](Type-miniquake2-game-types-playerstate-1257824894.md) — struct
- [miniquake2.game.types.Pmove](Type-miniquake2-game-types-pmove-121868117.md) — struct
<a id="function-function-miniquake2-game-types-stabilizeedict-function-stabilizeedict-gtypesedictvalue-src-miniquake2-game-types-ml-1409312362"></a>
### stabilizeEdict

```ml
function stabilizeEdict(gtypesEdictValue)
```

Return the stabilize edict value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `gtypesEdictValue` | `dynamic` | — | gtypesEdictValue value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/types.ml#L443)

<a id="function-function-miniquake2-game-types-stabilizeentitystate-function-stabilizeentitystate-gtypesstatevalue-src-miniquake2-game-types-ml-809501252"></a>
### stabilizeEntityState

```ml
function stabilizeEntityState(gtypesStateValue)
```

Return the stabilize entity state.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `gtypesStateValue` | `dynamic` | — | gtypesStateValue value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/types.ml#L360)

<a id="function-function-miniquake2-game-types-zeroedict-function-zeroedict-number-src-miniquake2-game-types-ml-660179855"></a>
### zeroEdict

```ml
function zeroEdict(number)
```

Return the zero edict value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `number` | `dynamic` | — | number value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/types.ml#L411)

<a id="function-function-miniquake2-game-types-zeroentitystate-function-zeroentitystate-number-src-miniquake2-game-types-ml-1175259697"></a>
### zeroEntityState

```ml
function zeroEntityState(number)
```

Return the zero entity state.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `number` | `dynamic` | — | number value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/types.ml#L342)

<a id="function-function-miniquake2-game-types-zerogameclient-function-zerogameclient-src-miniquake2-game-types-ml-748899828"></a>
### zeroGameClient

```ml
function zeroGameClient()
```

Return the zero game client value.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/types.ml#L405)

<a id="function-function-miniquake2-game-types-zeroplayerstate-function-zeroplayerstate-src-miniquake2-game-types-ml-2007341928"></a>
### zeroPlayerState

```ml
function zeroPlayerState()
```

Return the zero player state.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/types.ml#L395)

<a id="function-function-miniquake2-game-types-zeropmove-function-zeropmove-tracecallback-pointcontentscallback-src-miniquake2-game-types-ml-1328437355"></a>
### zeroPmove

```ml
function zeroPmove(traceCallback, pointContentsCallback)
```

Return the zero pmove value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `traceCallback` | `dynamic` | — | traceCallback value consumed by this operation. |
| `pointContentsCallback` | `dynamic` | — | pointContentsCallback value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/types.ml#L488)

<a id="function-function-miniquake2-game-types-zeropmovestate-function-zeropmovestate-src-miniquake2-game-types-ml-502290600"></a>
### zeroPmoveState

```ml
function zeroPmoveState()
```

Return the zero pmove state.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/types.ml#L331)

<a id="function-function-miniquake2-game-types-zerousercmd-function-zerousercmd-src-miniquake2-game-types-ml-197500758"></a>
### zeroUserCmd

```ml
function zeroUserCmd()
```

Return the zero user cmd value.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/types.ml#L336)
