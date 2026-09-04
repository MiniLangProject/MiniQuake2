# `src/miniquake2/game/ai/types.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 game ai types facilities for this project.

Package: [`miniquake2.game.ai.types`](Package-miniquake2-game-ai-types-1184083316.md)

Reachable from entry: **yes**

## Imports

- `miniquake2/game/ai/constants.ml` as `gaiconstants` → [src/miniquake2/game/ai/constants.ml](File-src-miniquake2-game-ai-constants-ml-2069864859.md)
- `miniquake2/game/types.ml` as `gtypes` → [src/miniquake2/game/types.ml](File-src-miniquake2-game-types-ml-1384205920.md)
- `miniquake2/qcommon/types.ml` as `gaiqtypes` → [src/miniquake2/qcommon/types.ml](File-src-miniquake2-qcommon-types-ml-1663266398.md)

## Declarations

- [miniquake2.game.ai.types.AIActor](Type-miniquake2-game-ai-types-aiactor-1497378965.md) — struct
- [miniquake2.game.ai.types.AIContext](Type-miniquake2-game-ai-types-aicontext-1875556959.md) — struct
- [miniquake2.game.ai.types.ArchetypeRegistry](Type-miniquake2-game-ai-types-archetyperegistry-786179090.md) — struct
<a id="function-function-miniquake2-game-ai-types-createactor-function-createactor-number-classname-src-miniquake2-game-ai-types-ml-48801715"></a>
### createActor

```ml
function createActor(number, className)
```

Create actor.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `number` | `dynamic` | — | number value consumed by this operation. |
| `className` | `dynamic` | — | className value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/types.ml#L395)

<a id="function-function-miniquake2-game-ai-types-createclienttarget-function-createclienttarget-number-src-miniquake2-game-ai-types-ml-463159338"></a>
### createClientTarget

```ml
function createClientTarget(number)
```

Create client target.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `number` | `dynamic` | — | number value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/types.ml#L432)

<a id="function-function-miniquake2-game-ai-types-defaultcontext-function-defaultcontext-src-miniquake2-game-ai-types-ml-2136088117"></a>
### defaultContext

```ml
function defaultContext()
```

Return the default context value.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/types.ml#L443)

<a id="function-function-miniquake2-game-ai-types-defaultmonsterinfo-function-defaultmonsterinfo-src-miniquake2-game-ai-types-ml-168580189"></a>
### defaultMonsterInfo

```ml
function defaultMonsterInfo()
```

Return the default monster info value.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/types.ml#L382)

- [miniquake2.game.ai.types.MonsterArchetype](Type-miniquake2-game-ai-types-monsterarchetype-1399510239.md) — struct
- [miniquake2.game.ai.types.MonsterFrame](Type-miniquake2-game-ai-types-monsterframe-1838064125.md) — struct
- [miniquake2.game.ai.types.MonsterInfo](Type-miniquake2-game-ai-types-monsterinfo-1078993004.md) — struct
- [miniquake2.game.ai.types.MonsterMove](Type-miniquake2-game-ai-types-monstermove-1737543805.md) — struct
<a id="function-function-miniquake2-game-ai-types-nooperation-function-nooperation-src-miniquake2-game-ai-types-ml-1424870929"></a>
### noOperation

```ml
function noOperation()
```

Report whether no operation.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/types.ml#L377)

- [miniquake2.game.ai.types.TargetSelection](Type-miniquake2-game-ai-types-targetselection-706508939.md) — struct
