# `src/miniquake2/game/ai/death_effects.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 game ai death effects facilities for this project.

Package: [`miniquake2.game.ai.death_effects`](Package-miniquake2-game-ai-death-effects-402537138.md)

Reachable from entry: **yes**

## Imports

- `miniquake2/qcommon/types.ml` as `gaideathqtypes` → [src/miniquake2/qcommon/types.ml](File-src-miniquake2-qcommon-types-ml-1663266398.md)

## Declarations

<a id="function-function-miniquake2-game-ai-death-effects-applycorpse-function-applycorpse-actor-context-src-miniquake2-game-ai-death-effects-ml-915261737"></a>
### applyCorpse

```ml
function applyCorpse(actor, context)
```

Apply corpse.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/death_effects.ml#L174)

<a id="function-function-miniquake2-game-ai-death-effects-corpsebounds-function-corpsebounds-classname-src-miniquake2-game-ai-death-effects-ml-1319077344"></a>
### corpseBounds

```ml
function corpseBounds(className)
```

Return the corpse bounds.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `className` | `dynamic` | — | className value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/death_effects.ml#L69)

- [miniquake2.game.ai.death_effects.CorpseBounds](Type-miniquake2-game-ai-death-effects-corpsebounds-984830233.md) — struct
<a id="function-function-miniquake2-game-ai-death-effects-effect-function-effect-kind-modelname-origin-damage-gibtype-head-sequence-effecttype-src-miniquake2-game-ai-death-effects-ml-2124451314"></a>
### effect

```ml
function effect(kind, modelName, origin, damage, gibType, head, sequence, effectType)
```

Return the effect value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `kind` | `dynamic` | — | kind value consumed by this operation. |
| `modelName` | `dynamic` | — | modelName value consumed by this operation. |
| `origin` | `dynamic` | — | origin value consumed by this operation. |
| `damage` | `dynamic` | — | damage value consumed by this operation. |
| `gibType` | `dynamic` | — | gibType value consumed by this operation. |
| `head` | `dynamic` | — | head value consumed by this operation. |
| `sequence` | `dynamic` | — | sequence value consumed by this operation. |
| `effectType` | `dynamic` | — | effectType value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/death_effects.ml#L156)

<a id="function-function-miniquake2-game-ai-death-effects-emit-function-emit-context-actor-event-src-miniquake2-game-ai-death-effects-ml-1798495405"></a>
### emit

```ml
function emit(context, actor, event)
```

Performs the emit operation for the miniquake2 game ai death effects module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `context` | `dynamic` | — | Context that carries state for the operation. |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `event` | `dynamic` | — | event value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/death_effects.ml#L166)

<a id="function-function-miniquake2-game-ai-death-effects-emitexplosion-function-emitexplosion-actor-origin-sequence-context-src-miniquake2-game-ai-death-effects-ml-1125487646"></a>
### emitExplosion

```ml
function emitExplosion(actor, origin, sequence, context)
```

Emit explosion.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `origin` | `dynamic` | — | origin value consumed by this operation. |
| `sequence` | `dynamic` | — | sequence value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/death_effects.ml#L246)

<a id="function-function-miniquake2-game-ai-death-effects-emitgibspecs-function-emitgibspecs-actor-specs-damage-context-src-miniquake2-game-ai-death-effects-ml-1845134826"></a>
### emitGibSpecs

```ml
function emitGibSpecs(actor, specs, damage, context)
```

Emit gib specs.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `specs` | `dynamic` | — | specs value consumed by this operation. |
| `damage` | `dynamic` | — | damage value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/death_effects.ml#L191)

<a id="function-function-miniquake2-game-ai-death-effects-emitmonstergibs-function-emitmonstergibs-actor-damage-context-src-miniquake2-game-ai-death-effects-ml-516584484"></a>
### emitMonsterGibs

```ml
function emitMonsterGibs(actor, damage, context)
```

Emit monster gibs.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `damage` | `dynamic` | — | damage value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/death_effects.ml#L210)

<a id="function-function-miniquake2-game-ai-death-effects-emitsupertankfinalgibs-function-emitsupertankfinalgibs-actor-context-src-miniquake2-game-ai-death-effects-ml-1430317701"></a>
### emitSupertankFinalGibs

```ml
function emitSupertankFinalGibs(actor, context)
```

Emit supertank final gibs.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/death_effects.ml#L217)

<a id="constant-constant-miniquake2-game-ai-death-effects-gib-metallic-const-gib-metallic-1-src-miniquake2-game-ai-death-effects-ml-1585384415"></a>
### GIB_METALLIC

```ml
const GIB_METALLIC = 1
```

Defines the gib metallic constant used by the miniquake2 game ai death effects module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/death_effects.ml#L15)

<a id="constant-constant-miniquake2-game-ai-death-effects-gib-organic-const-gib-organic-0-src-miniquake2-game-ai-death-effects-ml-178065370"></a>
### GIB_ORGANIC

```ml
const GIB_ORGANIC = 0
```

Defines the gib organic constant used by the miniquake2 game ai death effects module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/death_effects.ml#L13)

<a id="function-function-miniquake2-game-ai-death-effects-gibplan-function-gibplan-classname-src-miniquake2-game-ai-death-effects-ml-1548262586"></a>
### gibPlan

```ml
function gibPlan(className)
```

Return the gib plan value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `className` | `dynamic` | — | className value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/death_effects.ml#L102)

- [miniquake2.game.ai.death_effects.GibSpec](Type-miniquake2-game-ai-death-effects-gibspec-1245785953.md) — struct
- [miniquake2.game.ai.death_effects.MonsterDeathEffect](Type-miniquake2-game-ai-death-effects-monsterdeatheffect-345415593.md) — struct
<a id="function-function-miniquake2-game-ai-death-effects-organicgibs-function-organicgibs-src-miniquake2-game-ai-death-effects-ml-133361613"></a>
### organicGibs

```ml
function organicGibs()
```

Return the organic gibs value.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/death_effects.ml#L92)

<a id="function-function-miniquake2-game-ai-death-effects-supertankexplosionorigin-function-supertankexplosionorigin-actor-stage-src-miniquake2-game-ai-death-effects-ml-1960759422"></a>
### supertankExplosionOrigin

```ml
function supertankExplosionOrigin(actor, stage)
```

Return the supertank explosion origin.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `stage` | `dynamic` | — | stage value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/death_effects.ml#L224)

<a id="function-function-miniquake2-game-ai-death-effects-supertankfinalgibs-function-supertankfinalgibs-src-miniquake2-game-ai-death-effects-ml-1869099261"></a>
### supertankFinalGibs

```ml
function supertankFinalGibs()
```

Return the supertank final gibs value.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/death_effects.ml#L138)

<a id="constant-constant-miniquake2-game-ai-death-effects-te-explosion1-const-te-explosion1-5-src-miniquake2-game-ai-death-effects-ml-1241300073"></a>
### TE_EXPLOSION1

```ml
const TE_EXPLOSION1 = 5
```

Defines the te explosion1 constant used by the miniquake2 game ai death effects module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/death_effects.ml#L17)
