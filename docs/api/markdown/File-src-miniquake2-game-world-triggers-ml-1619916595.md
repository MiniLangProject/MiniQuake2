# `src/miniquake2/game/world/triggers.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 game world triggers facilities for this project.

Package: [`miniquake2.game.world.triggers`](Package-miniquake2-game-world-triggers-1163204682.md)

Reachable from entry: **yes**

## Imports

- `miniquake2/game/world/constants.ml` as `gwconstants` → [src/miniquake2/game/world/constants.ml](File-src-miniquake2-game-world-constants-ml-774918061.md)
- `miniquake2/game/world/core.ml` as `gwcore` → [src/miniquake2/game/world/core.ml](File-src-miniquake2-game-world-core-ml-1171136969.md)
- `miniquake2/game/world/vector.ml` as `gwvector` → [src/miniquake2/game/world/vector.ml](File-src-miniquake2-game-world-vector-ml-1561306429.md)
- `std/math.ml` as `smath` → `../MiniLangCompilerML/std/math.ml` — external dependency

## Declarations

<a id="function-function-miniquake2-game-world-triggers-enabletrigger-function-enabletrigger-entity-other-activator-world-src-miniquake2-game-world-triggers-ml-1622820147"></a>
### enableTrigger

```ml
function enableTrigger(entity, other, activator, world)
```

Return the enable trigger value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `other` | `dynamic` | — | other value consumed by this operation. |
| `activator` | `dynamic` | — | activator value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/triggers.ml#L96)

<a id="function-function-miniquake2-game-world-triggers-gravitytouch-function-gravitytouch-entity-other-world-src-miniquake2-game-world-triggers-ml-91137584"></a>
### gravityTouch

```ml
function gravityTouch(entity, other, world)
```

Handle gravity.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `other` | `dynamic` | — | other value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/triggers.ml#L347)

<a id="function-function-miniquake2-game-world-triggers-hurttouch-function-hurttouch-entity-other-world-src-miniquake2-game-world-triggers-ml-1150715848"></a>
### hurtTouch

```ml
function hurtTouch(entity, other, world)
```

Handle hurt.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `other` | `dynamic` | — | other value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/triggers.ml#L266)

<a id="function-function-miniquake2-game-world-triggers-hurtuse-function-hurtuse-entity-other-activator-world-src-miniquake2-game-world-triggers-ml-1770166209"></a>
### hurtUse

```ml
function hurtUse(entity, other, activator, world)
```

Use hurt.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `other` | `dynamic` | — | other value consumed by this operation. |
| `activator` | `dynamic` | — | activator value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/triggers.ml#L289)

<a id="function-function-miniquake2-game-world-triggers-inittrigger-function-inittrigger-entity-world-src-miniquake2-game-world-triggers-ml-1791433416"></a>
### initTrigger

```ml
function initTrigger(entity, world)
```

Initialize trigger.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/triggers.ml#L18)

<a id="function-function-miniquake2-game-world-triggers-monsterjumptouch-function-monsterjumptouch-entity-other-world-src-miniquake2-game-world-triggers-ml-1197535732"></a>
### monsterJumpTouch

```ml
function monsterJumpTouch(entity, other, world)
```

Handle monster jump.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `other` | `dynamic` | — | other value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/triggers.ml#L373)

<a id="function-function-miniquake2-game-world-triggers-multitrigger-function-multitrigger-entity-world-src-miniquake2-game-world-triggers-ml-1041559860"></a>
### multiTrigger

```ml
function multiTrigger(entity, world)
```

Return the multi trigger value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/triggers.ml#L41)

<a id="function-function-miniquake2-game-world-triggers-multiwait-function-multiwait-entity-world-src-miniquake2-game-world-triggers-ml-1781775836"></a>
### multiWait

```ml
function multiWait(entity, world)
```

Return the multi wait value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/triggers.ml#L33)

<a id="function-function-miniquake2-game-world-triggers-pushtouch-function-pushtouch-entity-other-world-src-miniquake2-game-world-triggers-ml-1670182394"></a>
### pushTouch

```ml
function pushTouch(entity, other, world)
```

Handle push.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `other` | `dynamic` | — | other value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/triggers.ml#L314)

<a id="function-function-miniquake2-game-world-triggers-sp-trigger-always-function-sp-trigger-always-entity-world-src-miniquake2-game-world-triggers-ml-1931076668"></a>
### SP_trigger_always

```ml
function SP_trigger_always(entity, world)
```

Spawn trigger always.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/triggers.ml#L420)

<a id="function-function-miniquake2-game-world-triggers-sp-trigger-counter-function-sp-trigger-counter-entity-world-src-miniquake2-game-world-triggers-ml-1272395152"></a>
### SP_trigger_counter

```ml
function SP_trigger_counter(entity, world)
```

Spawn trigger counter.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/triggers.ml#L426)

<a id="function-function-miniquake2-game-world-triggers-sp-trigger-gravity-function-sp-trigger-gravity-entity-world-src-miniquake2-game-world-triggers-ml-951552616"></a>
### SP_trigger_gravity

```ml
function SP_trigger_gravity(entity, world)
```

Spawn trigger gravity.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/triggers.ml#L444)

<a id="function-function-miniquake2-game-world-triggers-sp-trigger-hurt-function-sp-trigger-hurt-entity-world-src-miniquake2-game-world-triggers-ml-2052739280"></a>
### SP_trigger_hurt

```ml
function SP_trigger_hurt(entity, world)
```

Spawn trigger hurt.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/triggers.ml#L432)

<a id="function-function-miniquake2-game-world-triggers-sp-trigger-key-function-sp-trigger-key-entity-world-src-miniquake2-game-world-triggers-ml-1226440700"></a>
### SP_trigger_key

```ml
function SP_trigger_key(entity, world)
```

Spawn trigger key.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/triggers.ml#L456)

<a id="function-function-miniquake2-game-world-triggers-sp-trigger-monsterjump-function-sp-trigger-monsterjump-entity-world-src-miniquake2-game-world-triggers-ml-608863860"></a>
### SP_trigger_monsterjump

```ml
function SP_trigger_monsterjump(entity, world)
```

Spawn trigger monsterjump.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/triggers.ml#L450)

<a id="function-function-miniquake2-game-world-triggers-sp-trigger-multiple-function-sp-trigger-multiple-entity-world-src-miniquake2-game-world-triggers-ml-368032066"></a>
### SP_trigger_multiple

```ml
function SP_trigger_multiple(entity, world)
```

Spawn trigger multiple.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/triggers.ml#L402)

<a id="function-function-miniquake2-game-world-triggers-sp-trigger-once-function-sp-trigger-once-entity-world-src-miniquake2-game-world-triggers-ml-293776616"></a>
### SP_trigger_once

```ml
function SP_trigger_once(entity, world)
```

Spawn trigger once.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/triggers.ml#L408)

<a id="function-function-miniquake2-game-world-triggers-sp-trigger-push-function-sp-trigger-push-entity-world-src-miniquake2-game-world-triggers-ml-1425841918"></a>
### SP_trigger_push

```ml
function SP_trigger_push(entity, world)
```

Spawn trigger push.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/triggers.ml#L438)

<a id="function-function-miniquake2-game-world-triggers-sp-trigger-relay-function-sp-trigger-relay-entity-world-src-miniquake2-game-world-triggers-ml-58870552"></a>
### SP_trigger_relay

```ml
function SP_trigger_relay(entity, world)
```

Spawn trigger relay.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/triggers.ml#L414)

<a id="function-function-miniquake2-game-world-triggers-spawnalways-function-spawnalways-entity-world-src-miniquake2-game-world-triggers-ml-177677256"></a>
### spawnAlways

```ml
function spawnAlways(entity, world)
```

Spawn always.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/triggers.ml#L163)

<a id="function-function-miniquake2-game-world-triggers-spawncounter-function-spawncounter-entity-world-src-miniquake2-game-world-triggers-ml-214619232"></a>
### spawnCounter

```ml
function spawnCounter(entity, world)
```

Spawn counter.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/triggers.ml#L254)

<a id="function-function-miniquake2-game-world-triggers-spawngravity-function-spawngravity-entity-world-src-miniquake2-game-world-triggers-ml-608938012"></a>
### spawnGravity

```ml
function spawnGravity(entity, world)
```

Spawn gravity.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/triggers.ml#L356)

<a id="function-function-miniquake2-game-world-triggers-spawnhurt-function-spawnhurt-entity-world-src-miniquake2-game-world-triggers-ml-1616402280"></a>
### spawnHurt

```ml
function spawnHurt(entity, world)
```

Spawn hurt.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/triggers.ml#L299)

<a id="function-function-miniquake2-game-world-triggers-spawnkey-function-spawnkey-entity-world-src-miniquake2-game-world-triggers-ml-1801472024"></a>
### spawnKey

```ml
function spawnKey(entity, world)
```

Spawn key.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/triggers.ml#L206)

<a id="function-function-miniquake2-game-world-triggers-spawnmonsterjump-function-spawnmonsterjump-entity-world-src-miniquake2-game-world-triggers-ml-232242896"></a>
### spawnMonsterJump

```ml
function spawnMonsterJump(entity, world)
```

Spawn monster jump.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/triggers.ml#L389)

<a id="function-function-miniquake2-game-world-triggers-spawnmultiple-function-spawnmultiple-entity-world-src-miniquake2-game-world-triggers-ml-989225086"></a>
### spawnMultiple

```ml
function spawnMultiple(entity, world)
```

Spawn multiple.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/triggers.ml#L106)

<a id="function-function-miniquake2-game-world-triggers-spawnonce-function-spawnonce-entity-world-src-miniquake2-game-world-triggers-ml-1017757288"></a>
### spawnOnce

```ml
function spawnOnce(entity, world)
```

Spawn once.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/triggers.ml#L133)

<a id="function-function-miniquake2-game-world-triggers-spawnpush-function-spawnpush-entity-world-src-miniquake2-game-world-triggers-ml-1087879206"></a>
### spawnPush

```ml
function spawnPush(entity, world)
```

Spawn push.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/triggers.ml#L334)

<a id="function-function-miniquake2-game-world-triggers-spawnrelay-function-spawnrelay-entity-world-src-miniquake2-game-world-triggers-ml-333643044"></a>
### spawnRelay

```ml
function spawnRelay(entity, world)
```

Spawn relay.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/triggers.ml#L155)

<a id="function-function-miniquake2-game-world-triggers-touchmulti-function-touchmulti-entity-other-world-src-miniquake2-game-world-triggers-ml-774915152"></a>
### touchMulti

```ml
function touchMulti(entity, other, world)
```

Handle multi.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `other` | `dynamic` | — | other value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/triggers.ml#L72)

<a id="function-function-miniquake2-game-world-triggers-usecounter-function-usecounter-entity-other-activator-world-src-miniquake2-game-world-triggers-ml-825296737"></a>
### useCounter

```ml
function useCounter(entity, other, activator, world)
```

Use counter.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `other` | `dynamic` | — | other value consumed by this operation. |
| `activator` | `dynamic` | — | activator value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/triggers.ml#L233)

<a id="function-function-miniquake2-game-world-triggers-usekey-function-usekey-entity-other-activator-world-src-miniquake2-game-world-triggers-ml-102887665"></a>
### useKey

```ml
function useKey(entity, other, activator, world)
```

trigger_key. Inventory and cooperative power-cube policy remain outside the world package through resolve/has/consume callbacks.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `other` | `dynamic` | — | other value consumed by this operation. |
| `activator` | `dynamic` | — | activator value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/triggers.ml#L176)

<a id="function-function-miniquake2-game-world-triggers-usemulti-function-usemulti-entity-other-activator-world-src-miniquake2-game-world-triggers-ml-917004825"></a>
### useMulti

```ml
function useMulti(entity, other, activator, world)
```

Use multi.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `other` | `dynamic` | — | other value consumed by this operation. |
| `activator` | `dynamic` | — | activator value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/triggers.ml#L63)

<a id="function-function-miniquake2-game-world-triggers-userelay-function-userelay-entity-other-activator-world-src-miniquake2-game-world-triggers-ml-1559780757"></a>
### useRelay

```ml
function useRelay(entity, other, activator, world)
```

Use relay.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `other` | `dynamic` | — | other value consumed by this operation. |
| `activator` | `dynamic` | — | activator value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/triggers.ml#L148)
