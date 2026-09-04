# `src/miniquake2/game/base/types.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 game base types facilities for this project.

Package: [`miniquake2.game.base.types`](Package-miniquake2-game-base-types-1230373735.md)

Reachable from entry: **yes**

## Imports

- `miniquake2/game/types.ml` as `gtypes` → [src/miniquake2/game/types.ml](File-src-miniquake2-game-types-ml-1384205920.md)
- `miniquake2/qcommon/types.ml` as `bqtypes` → [src/miniquake2/qcommon/types.ml](File-src-miniquake2-qcommon-types-ml-1663266398.md)

## Declarations

- [miniquake2.game.base.types.BaseEdict](Type-miniquake2-game-base-types-baseedict-574165725.md) — struct
- [miniquake2.game.base.types.BaseEntity](Type-miniquake2-game-base-types-baseentity-496484261.md) — struct
- [miniquake2.game.base.types.EntityPair](Type-miniquake2-game-base-types-entitypair-895215608.md) — struct
- [miniquake2.game.base.types.EntityScanner](Type-miniquake2-game-base-types-entityscanner-1036298858.md) — struct
- [miniquake2.game.base.types.EntityToken](Type-miniquake2-game-base-types-entitytoken-1552949553.md) — struct
<a id="function-function-miniquake2-game-base-types-makebaseedict-function-makebaseedict-number-sourceindex-component-src-miniquake2-game-base-types-ml-1655380836"></a>
### makeBaseEdict

```ml
function makeBaseEdict(number, sourceIndex, component)
```

Create base edict.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `number` | `dynamic` | — | number value consumed by this operation. |
| `sourceIndex` | `dynamic` | — | Zero-based index of source. |
| `component` | `dynamic` | — | component value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/base/types.ml#L243)

- [miniquake2.game.base.types.ParsedEntity](Type-miniquake2-game-base-types-parsedentity-1609671293.md) — struct
- [miniquake2.game.base.types.SkippedClassCount](Type-miniquake2-game-base-types-skippedclasscount-394865194.md) — struct
- [miniquake2.game.base.types.SpawnEntry](Type-miniquake2-game-base-types-spawnentry-811956630.md) — struct
- [miniquake2.game.base.types.SpawnRegistry](Type-miniquake2-game-base-types-spawnregistry-809122413.md) — struct
- [miniquake2.game.base.types.SpawnResult](Type-miniquake2-game-base-types-spawnresult-44666151.md) — struct
- [miniquake2.game.base.types.SpawnTemp](Type-miniquake2-game-base-types-spawntemp-1310507052.md) — struct
<a id="function-function-miniquake2-game-base-types-zerobaseentity-function-zerobaseentity-src-miniquake2-game-base-types-ml-742118097"></a>
### zeroBaseEntity

```ml
function zeroBaseEntity()
```

Return the zero base entity value.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/base/types.ml#L223)

<a id="function-function-miniquake2-game-base-types-zerospawntemp-function-zerospawntemp-src-miniquake2-game-base-types-ml-301274127"></a>
### zeroSpawnTemp

```ml
function zeroSpawnTemp()
```

Spawn zero temp.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/base/types.ml#L217)
