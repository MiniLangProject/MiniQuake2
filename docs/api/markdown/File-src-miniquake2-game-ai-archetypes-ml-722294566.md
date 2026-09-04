# `src/miniquake2/game/ai/archetypes.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 game ai archetypes facilities for this project.

Package: [`miniquake2.game.ai.archetypes`](Package-miniquake2-game-ai-archetypes-1606584659.md)

Reachable from entry: **yes**

## Imports

- `miniquake2/game/ai/actor.ml` as `gaiactor` → [src/miniquake2/game/ai/actor.ml](File-src-miniquake2-game-ai-actor-ml-1670505135.md)
- `miniquake2/game/ai/constants.ml` as `gaiconstants` → [src/miniquake2/game/ai/constants.ml](File-src-miniquake2-game-ai-constants-ml-2069864859.md)
- `miniquake2/game/ai/core.ml` as `gaicore` → [src/miniquake2/game/ai/core.ml](File-src-miniquake2-game-ai-core-ml-1671967255.md)
- `miniquake2/game/ai/insane.ml` as `gaiinsane` → [src/miniquake2/game/ai/insane.ml](File-src-miniquake2-game-ai-insane-ml-754528084.md)
- `miniquake2/game/ai/monster.ml` as `gaimonster` → [src/miniquake2/game/ai/monster.ml](File-src-miniquake2-game-ai-monster-ml-345185618.md)
- `miniquake2/game/ai/props.ml` as `gaiprops` → [src/miniquake2/game/ai/props.ml](File-src-miniquake2-game-ai-props-ml-91813726.md)
- `miniquake2/game/ai/types.ml` as `gaitypes` → [src/miniquake2/game/ai/types.ml](File-src-miniquake2-game-ai-types-ml-2113011711.md)
- `miniquake2/game/constants.ml` as `gconstants` → [src/miniquake2/game/constants.ml](File-src-miniquake2-game-constants-ml-1723282332.md)
- `miniquake2/qcommon/text.ml` as `qtext` → [src/miniquake2/qcommon/text.ml](File-src-miniquake2-qcommon-text-ml-1570504148.md)
- `miniquake2/qcommon/types.ml` as `gaiqtypes` → [src/miniquake2/qcommon/types.ml](File-src-miniquake2-qcommon-types-ml-1663266398.md)

## Declarations

<a id="function-function-miniquake2-game-ai-archetypes-archetype-function-archetype-classname-model-mins-maxs-health-gibhealth-mass-movement-hasattack-hasmelee-src-miniquake2-game-ai-archetypes-ml-1939529770"></a>
### archetype

```ml
function archetype(className, model, mins, maxs, health, gibHealth, mass, movement, hasAttack, hasMelee)
```

Return the archetype value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `className` | `dynamic` | — | className value consumed by this operation. |
| `model` | `dynamic` | — | model value consumed by this operation. |
| `mins` | `dynamic` | — | mins value consumed by this operation. |
| `maxs` | `dynamic` | — | maxs value consumed by this operation. |
| `health` | `dynamic` | — | health value consumed by this operation. |
| `gibHealth` | `dynamic` | — | gibHealth value consumed by this operation. |
| `mass` | `dynamic` | — | mass value consumed by this operation. |
| `movement` | `dynamic` | — | movement value consumed by this operation. |
| `hasAttack` | `dynamic` | — | hasAttack value consumed by this operation. |
| `hasMelee` | `dynamic` | — | hasMelee value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/archetypes.ml#L32)

<a id="function-function-miniquake2-game-ai-archetypes-defaultregistry-function-defaultregistry-src-miniquake2-game-ai-archetypes-ml-433422999"></a>
### defaultRegistry

```ml
function defaultRegistry()
```

Performs the defaultRegistry operation for the miniquake2 game ai archetypes module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/archetypes.ml#L37)

<a id="function-function-miniquake2-game-ai-archetypes-find-function-find-registry-classname-src-miniquake2-game-ai-archetypes-ml-940902639"></a>
### find

```ml
function find(registry, className)
```

Finds find used by the miniquake2 game ai archetypes module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `registry` | `dynamic` | — | registry value consumed by this operation. |
| `className` | `dynamic` | — | className value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/archetypes.ml#L76)

<a id="function-function-miniquake2-game-ai-archetypes-idlemove-function-idlemove-src-miniquake2-game-ai-archetypes-ml-1788037267"></a>
### idleMove

```ml
function idleMove()
```

Move idle.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/archetypes.ml#L109)

<a id="function-function-miniquake2-game-ai-archetypes-reinitializemonster-function-reinitializemonster-actor-context-src-miniquake2-game-ai-archetypes-ml-1882351721"></a>
### ReinitializeMonster

```ml
function ReinitializeMonster(actor, context)
```

Return the reinitialize monster value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/archetypes.ml#L117)

<a id="function-function-miniquake2-game-ai-archetypes-spawnmonster-function-spawnmonster-registry-classname-number-context-src-miniquake2-game-ai-archetypes-ml-2115060889"></a>
### SpawnMonster

```ml
function SpawnMonster(registry, className, number, context)
```

Spawn monster.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `registry` | `dynamic` | — | registry value consumed by this operation. |
| `className` | `dynamic` | — | className value consumed by this operation. |
| `number` | `dynamic` | — | number value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/archetypes.ml#L215)

<a id="function-function-miniquake2-game-ai-archetypes-validate-function-validate-registry-src-miniquake2-game-ai-archetypes-ml-1461390872"></a>
### validate

```ml
function validate(registry)
```

Validates validate for the miniquake2 game ai archetypes workflow.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `registry` | `dynamic` | — | registry value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/archetypes.ml#L93)
