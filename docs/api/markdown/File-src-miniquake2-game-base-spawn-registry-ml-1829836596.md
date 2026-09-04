# `src/miniquake2/game/base/spawn_registry.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 game base spawn registry facilities for this project.

Package: [`miniquake2.game.base.spawn_registry`](Package-miniquake2-game-base-spawn-registry-1283126389.md)

Reachable from entry: **yes**

## Imports

- `miniquake2/game/ai/archetypes.ml` as `gaiarchetypes` → [src/miniquake2/game/ai/archetypes.ml](File-src-miniquake2-game-ai-archetypes-ml-722294566.md)
- `miniquake2/game/base/types.ml` as `btypes` → [src/miniquake2/game/base/types.ml](File-src-miniquake2-game-base-types-ml-1537748126.md)
- `miniquake2/game/constants.ml` as `gconstants` → [src/miniquake2/game/constants.ml](File-src-miniquake2-game-constants-ml-1723282332.md)
- `miniquake2/game/gameplay/item_rules.ml` as `gprules` → [src/miniquake2/game/gameplay/item_rules.ml](File-src-miniquake2-game-gameplay-item-rules-ml-1747940557.md)
- `miniquake2/game/gameplay/registry.ml` as `gpregistry` → [src/miniquake2/game/gameplay/registry.ml](File-src-miniquake2-game-gameplay-registry-ml-1541508425.md)
- `std/string.ml` as `bstring` → `../MiniLangCompilerML/std/string.ml` — external dependency

## Declarations

<a id="function-function-miniquake2-game-base-spawn-registry-createregistry-function-createregistry-src-miniquake2-game-base-spawn-registry-ml-227950607"></a>
### createRegistry

```ml
function createRegistry()
```

Create registry.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/base/spawn_registry.ml#L191)

<a id="function-function-miniquake2-game-base-spawn-registry-defaultregistry-function-defaultregistry-src-miniquake2-game-base-spawn-registry-ml-2058601763"></a>
### defaultRegistry

```ml
function defaultRegistry()
```

Performs the defaultRegistry operation for the miniquake2 game base spawn registry module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/base/spawn_registry.ml#L219)

<a id="function-function-miniquake2-game-base-spawn-registry-find-function-find-registry-classname-src-miniquake2-game-base-spawn-registry-ml-552025631"></a>
### find

```ml
function find(registry, className)
```

Finds find used by the miniquake2 game base spawn registry module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `registry` | `dynamic` | — | registry value consumed by this operation. |
| `className` | `dynamic` | — | className value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/base/spawn_registry.ml#L198)

<a id="constant-constant-miniquake2-game-base-spawn-registry-movetype-none-const-movetype-none-0-src-miniquake2-game-base-spawn-registry-ml-1230571320"></a>
### MOVETYPE_NONE

```ml
const MOVETYPE_NONE = 0
```

Defines the movetype none constant used by the miniquake2 game base spawn registry module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/base/spawn_registry.ml#L21)

<a id="constant-constant-miniquake2-game-base-spawn-registry-movetype-push-const-movetype-push-7-src-miniquake2-game-base-spawn-registry-ml-959767535"></a>
### MOVETYPE_PUSH

```ml
const MOVETYPE_PUSH = 7
```

Defines the movetype push constant used by the miniquake2 game base spawn registry module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/base/spawn_registry.ml#L23)

<a id="function-function-miniquake2-game-base-spawn-registry-register-function-register-registry-classname-spawnfunction-src-miniquake2-game-base-spawn-registry-ml-1581121226"></a>
### register

```ml
function register(registry, className, spawnFunction)
```

Register state.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `registry` | `dynamic` | — | registry value consumed by this operation. |
| `className` | `dynamic` | — | className value consumed by this operation. |
| `spawnFunction` | `dynamic` | — | spawnFunction value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/base/spawn_registry.ml#L209)

<a id="function-function-miniquake2-game-base-spawn-registry-sp-brush-component-function-sp-brush-component-entity-src-miniquake2-game-base-spawn-registry-ml-605611992"></a>
### SP_brush_component

```ml
function SP_brush_component(entity)
```

Spawn brush component.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/base/spawn_registry.ml#L144)

<a id="function-function-miniquake2-game-base-spawn-registry-sp-consumed-function-sp-consumed-entity-src-miniquake2-game-base-spawn-registry-ml-2137102544"></a>
### SP_consumed

```ml
function SP_consumed(entity)
```

Spawn consumed.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/base/spawn_registry.ml#L126)

<a id="function-function-miniquake2-game-base-spawn-registry-sp-func-door-function-sp-func-door-entity-src-miniquake2-game-base-spawn-registry-ml-606165756"></a>
### SP_func_door

```ml
function SP_func_door(entity)
```

Spawn func door.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/base/spawn_registry.ml#L54)

<a id="function-function-miniquake2-game-base-spawn-registry-sp-func-water-function-sp-func-water-entity-src-miniquake2-game-base-spawn-registry-ml-273370064"></a>
### SP_func_water

```ml
function SP_func_water(entity)
```

Spawn func water.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/base/spawn_registry.ml#L153)

<a id="function-function-miniquake2-game-base-spawn-registry-sp-gameplay-item-function-sp-gameplay-item-entity-src-miniquake2-game-base-spawn-registry-ml-92889128"></a>
### SP_gameplay_item

```ml
function SP_gameplay_item(entity)
```

Spawn gameplay item.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/base/spawn_registry.ml#L104)

<a id="function-function-miniquake2-game-base-spawn-registry-sp-info-player-function-sp-info-player-entity-src-miniquake2-game-base-spawn-registry-ml-1647125792"></a>
### SP_info_player

```ml
function SP_info_player(entity)
```

Spawn info player.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/base/spawn_registry.ml#L45)

<a id="function-function-miniquake2-game-base-spawn-registry-sp-info-player-start-function-sp-info-player-start-entity-src-miniquake2-game-base-spawn-registry-ml-905230780"></a>
### SP_info_player_start

```ml
function SP_info_player_start(entity)
```

Spawn info player start.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/base/spawn_registry.ml#L36)

<a id="function-function-miniquake2-game-base-spawn-registry-sp-light-function-sp-light-entity-src-miniquake2-game-base-spawn-registry-ml-1836177400"></a>
### SP_light

```ml
function SP_light(entity)
```

Spawn light.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/base/spawn_registry.ml#L135)

<a id="function-function-miniquake2-game-base-spawn-registry-sp-misc-actor-function-sp-misc-actor-entity-src-miniquake2-game-base-spawn-registry-ml-819038488"></a>
### SP_misc_actor

```ml
function SP_misc_actor(entity)
```

Spawn misc actor.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/base/spawn_registry.ml#L176)

<a id="function-function-miniquake2-game-base-spawn-registry-sp-monster-function-sp-monster-entity-src-miniquake2-game-base-spawn-registry-ml-1294738784"></a>
### SP_monster

```ml
function SP_monster(entity)
```

Spawn monster.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/base/spawn_registry.ml#L162)

<a id="function-function-miniquake2-game-base-spawn-registry-sp-target-speaker-function-sp-target-speaker-entity-src-miniquake2-game-base-spawn-registry-ml-107879886"></a>
### SP_target_speaker

```ml
function SP_target_speaker(entity)
```

Spawn target speaker.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/base/spawn_registry.ml#L83)

<a id="function-function-miniquake2-game-base-spawn-registry-sp-trigger-once-function-sp-trigger-once-entity-src-miniquake2-game-base-spawn-registry-ml-18306144"></a>
### SP_trigger_once

```ml
function SP_trigger_once(entity)
```

Spawn trigger once.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/base/spawn_registry.ml#L69)

<a id="function-function-miniquake2-game-base-spawn-registry-sp-world-component-function-sp-world-component-entity-src-miniquake2-game-base-spawn-registry-ml-510386616"></a>
### SP_world_component

```ml
function SP_world_component(entity)
```

Spawn world component.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/base/spawn_registry.ml#L115)

<a id="function-function-miniquake2-game-base-spawn-registry-sp-worldspawn-function-sp-worldspawn-entity-src-miniquake2-game-base-spawn-registry-ml-155493642"></a>
### SP_worldspawn

```ml
function SP_worldspawn(entity)
```

Spawn worldspawn.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/base/spawn_registry.ml#L27)
