# `src/miniquake2/game/ai/actor.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 game ai actor facilities for this project.

Package: [`miniquake2.game.ai.actor`](Package-miniquake2-game-ai-actor-159823812.md)

Reachable from entry: **yes**

## Imports

- `miniquake2/game/ai/constants.ml` as `actorconstants` → [src/miniquake2/game/ai/constants.ml](File-src-miniquake2-game-ai-constants-ml-2069864859.md)
- `miniquake2/game/ai/core.ml` as `actorcore` → [src/miniquake2/game/ai/core.ml](File-src-miniquake2-game-ai-core-ml-1671967255.md)
- `miniquake2/game/ai/death_effects.ml` as `actordeatheffects` → [src/miniquake2/game/ai/death_effects.ml](File-src-miniquake2-game-ai-death-effects-ml-1353580965.md)
- `miniquake2/game/ai/types.ml` as `actortypes` → [src/miniquake2/game/ai/types.ml](File-src-miniquake2-game-ai-types-ml-2113011711.md)
- `miniquake2/game/constants.ml` as `actorgameconstants` → [src/miniquake2/game/constants.ml](File-src-miniquake2-game-constants-ml-1723282332.md)
- `miniquake2/qcommon/types.ml` as `actorqtypes` → [src/miniquake2/qcommon/types.ml](File-src-miniquake2-qcommon-types-ml-1663266398.md)

## Declarations

<a id="function-function-miniquake2-game-ai-actor-actorattack-function-actorattack-actor-context-src-miniquake2-game-ai-actor-ml-1528493419"></a>
### actorAttack

```ml
function actorAttack(actor, context)
```

Run actor.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/actor.ml#L179)

<a id="function-function-miniquake2-game-ai-actor-actordead-function-actordead-actor-context-src-miniquake2-game-ai-actor-ml-1778781375"></a>
### actorDead

```ml
function actorDead(actor, context)
```

Return the actor dead value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/actor.ml#L248)

<a id="global-global-miniquake2-game-ai-actor-actordeath1distances-actordeath1distances-src-miniquake2-game-ai-actor-ml-1604083103"></a>
### actorDeath1Distances

```ml
actorDeath1Distances
```

Stores module-wide actor death1 distances state for the miniquake2 game ai actor module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/actor.ml#L29)

<a id="global-global-miniquake2-game-ai-actor-actordeath2distances-actordeath2distances-src-miniquake2-game-ai-actor-ml-864716785"></a>
### actorDeath2Distances

```ml
actorDeath2Distances
```

Stores module-wide actor death2 distances state for the miniquake2 game ai actor module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/actor.ml#L31)

<a id="function-function-miniquake2-game-ai-actor-actordeathmove-function-actordeathmove-variant-src-miniquake2-game-ai-actor-ml-1058377034"></a>
### actorDeathMove

```ml
function actorDeathMove(variant)
```

Move actor death.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `variant` | `dynamic` | — | variant value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/actor.ml#L123)

<a id="function-function-miniquake2-game-ai-actor-actordie-function-actordie-actor-attacker-damage-context-src-miniquake2-game-ai-actor-ml-462445243"></a>
### actorDie

```ml
function actorDie(actor, attacker, damage, context)
```

Handle actor.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `attacker` | `dynamic` | — | attacker value consumed by this operation. |
| `damage` | `dynamic` | — | damage value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/actor.ml#L270)

<a id="function-function-miniquake2-game-ai-actor-actormakemove-function-actormakemove-name-firstframe-lastframe-aifunction-distances-endfunction-src-miniquake2-game-ai-actor-ml-1480109711"></a>
### actorMakeMove

```ml
function actorMakeMove(name, firstFrame, lastFrame, aiFunction, distances, endFunction)
```

Create actor move.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `name` | `dynamic` | — | Name of the affected item. |
| `firstFrame` | `dynamic` | — | firstFrame value consumed by this operation. |
| `lastFrame` | `dynamic` | — | lastFrame value consumed by this operation. |
| `aiFunction` | `dynamic` | — | aiFunction value consumed by this operation. |
| `distances` | `dynamic` | — | distances value consumed by this operation. |
| `endFunction` | `dynamic` | — | endFunction value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/actor.ml#L57)

<a id="function-function-miniquake2-game-ai-actor-actorpain-function-actorpain-actor-attacker-damage-context-src-miniquake2-game-ai-actor-ml-1206966017"></a>
### actorPain

```ml
function actorPain(actor, attacker, damage, context)
```

Handle actor.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `attacker` | `dynamic` | — | attacker value consumed by this operation. |
| `damage` | `dynamic` | — | damage value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/actor.ml#L219)

<a id="global-global-miniquake2-game-ai-actor-actorpain1distances-actorpain1distances-src-miniquake2-game-ai-actor-ml-1142502431"></a>
### actorPain1Distances

```ml
actorPain1Distances
```

Stores module-wide actor pain1 distances state for the miniquake2 game ai actor module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/actor.ml#L23)

<a id="global-global-miniquake2-game-ai-actor-actorpain2distances-actorpain2distances-src-miniquake2-game-ai-actor-ml-2122213907"></a>
### actorPain2Distances

```ml
actorPain2Distances
```

Stores module-wide actor pain2 distances state for the miniquake2 game ai actor module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/actor.ml#L25)

<a id="global-global-miniquake2-game-ai-actor-actorpain3distances-actorpain3distances-src-miniquake2-game-ai-actor-ml-904812783"></a>
### actorPain3Distances

```ml
actorPain3Distances
```

Stores module-wide actor pain3 distances state for the miniquake2 game ai actor module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/actor.ml#L27)

<a id="function-function-miniquake2-game-ai-actor-actorpainmove-function-actorpainmove-variant-src-miniquake2-game-ai-actor-ml-875127554"></a>
### actorPainMove

```ml
function actorPainMove(variant)
```

Handle actor move.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `variant` | `dynamic` | — | variant value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/actor.ml#L97)

<a id="function-function-miniquake2-game-ai-actor-actorrandominteger-function-actorrandominteger-context-fallback-src-miniquake2-game-ai-actor-ml-1685167062"></a>
### actorRandomInteger

```ml
function actorRandomInteger(context, fallback)
```

Return the actor random integer value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `context` | `dynamic` | — | Context that carries state for the operation. |
| `fallback` | `dynamic` | — | Value returned when no explicit result is available. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/actor.ml#L45)

<a id="function-function-miniquake2-game-ai-actor-actorrandomunit-function-actorrandomunit-context-fallback-src-miniquake2-game-ai-actor-ml-1256282522"></a>
### actorRandomUnit

```ml
function actorRandomUnit(context, fallback)
```

Return the actor random unit value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `context` | `dynamic` | — | Context that carries state for the operation. |
| `fallback` | `dynamic` | — | Value returned when no explicit result is available. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/actor.ml#L37)

<a id="function-function-miniquake2-game-ai-actor-actorrun-function-actorrun-actor-context-src-miniquake2-game-ai-actor-ml-638334005"></a>
### actorRun

```ml
function actorRun(actor, context)
```

Run actor.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/actor.ml#L165)

<a id="global-global-miniquake2-game-ai-actor-actorrundistances-actorrundistances-src-miniquake2-game-ai-actor-ml-1048865583"></a>
### actorRunDistances

```ml
actorRunDistances
```

Stores module-wide actor run distances state for the miniquake2 game ai actor module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/actor.ml#L21)

<a id="function-function-miniquake2-game-ai-actor-actorrunmove-function-actorrunmove-src-miniquake2-game-ai-actor-ml-1691784125"></a>
### actorRunMove

```ml
function actorRunMove()
```

Run actor move.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/actor.ml#L89)

<a id="function-function-miniquake2-game-ai-actor-actorsetmove-function-actorsetmove-actor-move-src-miniquake2-game-ai-actor-ml-1446246213"></a>
### actorSetMove

```ml
function actorSetMove(actor, move)
```

Set actor move.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `move` | `dynamic` | — | move value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/actor.ml#L135)

<a id="function-function-miniquake2-game-ai-actor-actorstand-function-actorstand-actor-context-src-miniquake2-game-ai-actor-ml-1612959049"></a>
### actorStand

```ml
function actorStand(actor, context)
```

Return the actor stand value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/actor.ml#L145)

<a id="function-function-miniquake2-game-ai-actor-actorstandmove-function-actorstandmove-src-miniquake2-game-ai-actor-ml-141352289"></a>
### actorStandMove

```ml
function actorStandMove()
```

Move actor stand.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/actor.ml#L74)

<a id="function-function-miniquake2-game-ai-actor-actortauntmove-function-actortauntmove-flipoff-src-miniquake2-game-ai-actor-ml-1145218129"></a>
### actorTauntMove

```ml
function actorTauntMove(flipOff)
```

Move actor taunt.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `flipOff` | `dynamic` | — | flipOff value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/actor.ml#L112)

<a id="function-function-miniquake2-game-ai-actor-actoruse-function-actoruse-actor-other-activator-context-src-miniquake2-game-ai-actor-ml-1836678176"></a>
### actorUse

```ml
function actorUse(actor, other, activator, context)
```

Use actor.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `other` | `dynamic` | — | other value consumed by this operation. |
| `activator` | `dynamic` | — | activator value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/actor.ml#L192)

<a id="function-function-miniquake2-game-ai-actor-actorwalk-function-actorwalk-actor-context-src-miniquake2-game-ai-actor-ml-339561465"></a>
### actorWalk

```ml
function actorWalk(actor, context)
```

Return the actor walk value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/actor.ml#L158)

<a id="global-global-miniquake2-game-ai-actor-actorwalkdistances-actorwalkdistances-src-miniquake2-game-ai-actor-ml-1169224783"></a>
### actorWalkDistances

```ml
actorWalkDistances
```

Stores module-wide actor walk distances state for the miniquake2 game ai actor module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/actor.ml#L19)

<a id="function-function-miniquake2-game-ai-actor-actorwalkmove-function-actorwalkmove-src-miniquake2-game-ai-actor-ml-1152954459"></a>
### actorWalkMove

```ml
function actorWalkMove()
```

Move actor walk.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/actor.ml#L80)

<a id="function-function-miniquake2-game-ai-actor-configure-function-configure-actor-context-src-miniquake2-game-ai-actor-ml-300662645"></a>
### configure

```ml
function configure(actor, context)
```

Performs the configure operation for the miniquake2 game ai actor module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/actor.ml#L295)

<a id="function-function-miniquake2-game-ai-actor-restoremove-function-restoremove-actor-movename-src-miniquake2-game-ai-actor-ml-109302622"></a>
### restoreMove

```ml
function restoreMove(actor, moveName)
```

Restore move.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `moveName` | `dynamic` | — | moveName value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/actor.ml#L315)
