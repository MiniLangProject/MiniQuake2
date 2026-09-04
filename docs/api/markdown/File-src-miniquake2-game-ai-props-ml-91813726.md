# `src/miniquake2/game/ai/props.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 game ai props facilities for this project.

Package: [`miniquake2.game.ai.props`](Package-miniquake2-game-ai-props-1923332075.md)

Reachable from entry: **yes**

## Imports

- `miniquake2/game/ai/constants.ml` as `aipropconstants` → [src/miniquake2/game/ai/constants.ml](File-src-miniquake2-game-ai-constants-ml-2069864859.md)
- `miniquake2/game/constants.ml` as `aipropgameconstants` → [src/miniquake2/game/constants.ml](File-src-miniquake2-game-constants-ml-1723282332.md)
- `miniquake2/qcommon/types.ml` as `aipropqtypes` → [src/miniquake2/qcommon/types.ml](File-src-miniquake2-qcommon-types-ml-1663266398.md)

## Declarations

<a id="function-function-miniquake2-game-ai-props-boss3think-function-boss3think-actor-context-src-miniquake2-game-ai-props-ml-171465385"></a>
### boss3Think

```ml
function boss3Think(actor, context)
```

Run boss 3.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/props.ml#L103)

<a id="function-function-miniquake2-game-ai-props-boss3use-function-boss3use-actor-other-activator-context-src-miniquake2-game-ai-props-ml-84480048"></a>
### boss3Use

```ml
function boss3Use(actor, other, activator, context)
```

Use boss 3.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `other` | `dynamic` | — | other value consumed by this operation. |
| `activator` | `dynamic` | — | activator value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/props.ml#L118)

<a id="function-function-miniquake2-game-ai-props-commanderdrop-function-commanderdrop-actor-context-src-miniquake2-game-ai-props-ml-194805967"></a>
### commanderDrop

```ml
function commanderDrop(actor, context)
```

Drop commander.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/props.ml#L131)

<a id="function-function-miniquake2-game-ai-props-commanderthink-function-commanderthink-actor-context-src-miniquake2-game-ai-props-ml-924259841"></a>
### commanderThink

```ml
function commanderThink(actor, context)
```

Run commander.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/props.ml#L144)

<a id="function-function-miniquake2-game-ai-props-commanderuse-function-commanderuse-actor-other-activator-context-src-miniquake2-game-ai-props-ml-1890833648"></a>
### commanderUse

```ml
function commanderUse(actor, other, activator, context)
```

Use commander.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `other` | `dynamic` | — | other value consumed by this operation. |
| `activator` | `dynamic` | — | activator value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/props.ml#L164)

<a id="function-function-miniquake2-game-ai-props-configure-function-configure-actor-context-src-miniquake2-game-ai-props-ml-1078218985"></a>
### configure

```ml
function configure(actor, context)
```

Performs the configure operation for the miniquake2 game ai props module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/props.ml#L80)

<a id="function-function-miniquake2-game-ai-props-configureboss3stand-function-configureboss3stand-actor-context-src-miniquake2-game-ai-props-ml-1713069317"></a>
### configureBoss3Stand

```ml
function configureBoss3Stand(actor, context)
```

Configure boss 3 stand.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/props.ml#L34)

<a id="function-function-miniquake2-game-ai-props-configurecommanderbody-function-configurecommanderbody-actor-context-src-miniquake2-game-ai-props-ml-776181593"></a>
### configureCommanderBody

```ml
function configureCommanderBody(actor, context)
```

Configure commander body.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/props.ml#L60)

<a id="function-function-miniquake2-game-ai-props-isprop-function-isprop-actor-src-miniquake2-game-ai-props-ml-753320044"></a>
### isProp

```ml
function isProp(actor)
```

Report whether is prop.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/props.ml#L16)

<a id="function-function-miniquake2-game-ai-props-propsound-function-propsound-actor-context-soundname-src-miniquake2-game-ai-props-ml-796074671"></a>
### propSound

```ml
function propSound(actor, context, soundName)
```

Return the prop sound value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |
| `soundName` | `dynamic` | — | soundName value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/props.ml#L24)

<a id="function-function-miniquake2-game-ai-props-restorephase-function-restorephase-actor-src-miniquake2-game-ai-props-ml-1818859032"></a>
### restorePhase

```ml
function restorePhase(actor)
```

Restore phase.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/props.ml#L199)

<a id="function-function-miniquake2-game-ai-props-start-function-start-actor-context-src-miniquake2-game-ai-props-ml-930434857"></a>
### Start

```ml
function Start(actor, context)
```

Starts start for the miniquake2 game ai props workflow.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/props.ml#L89)

<a id="function-function-miniquake2-game-ai-props-startgo-function-startgo-actor-context-src-miniquake2-game-ai-props-ml-598496697"></a>
### StartGo

```ml
function StartGo(actor, context)
```

Start go.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/props.ml#L96)

<a id="function-function-miniquake2-game-ai-props-think-function-think-actor-context-src-miniquake2-game-ai-props-ml-341499945"></a>
### Think

```ml
function Think(actor, context)
```

Performs the Think operation for the miniquake2 game ai props module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/props.ml#L176)

<a id="function-function-miniquake2-game-ai-props-use-function-use-actor-other-activator-context-src-miniquake2-game-ai-props-ml-826178074"></a>
### Use

```ml
function Use(actor, other, activator, context)
```

Use state.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `other` | `dynamic` | — | other value consumed by this operation. |
| `activator` | `dynamic` | — | activator value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/props.ml#L191)
