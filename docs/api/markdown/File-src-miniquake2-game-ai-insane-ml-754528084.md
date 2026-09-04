# `src/miniquake2/game/ai/insane.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 game ai insane facilities for this project.

Package: [`miniquake2.game.ai.insane`](Package-miniquake2-game-ai-insane-1198308465.md)

Reachable from entry: **yes**

## Imports

- `miniquake2/game/ai/constants.ml` as `insaneconstants` → [src/miniquake2/game/ai/constants.ml](File-src-miniquake2-game-ai-constants-ml-2069864859.md)
- `miniquake2/game/ai/core.ml` as `insanecore` → [src/miniquake2/game/ai/core.ml](File-src-miniquake2-game-ai-core-ml-1671967255.md)
- `miniquake2/game/ai/types.ml` as `insanetypes` → [src/miniquake2/game/ai/types.ml](File-src-miniquake2-game-ai-types-ml-2113011711.md)
- `miniquake2/game/constants.ml` as `insanegameconstants` → [src/miniquake2/game/constants.ml](File-src-miniquake2-game-constants-ml-1723282332.md)
- `miniquake2/qcommon/types.ml` as `insaneqtypes` → [src/miniquake2/qcommon/types.ml](File-src-miniquake2-qcommon-types-ml-1663266398.md)

## Declarations

<a id="function-function-miniquake2-game-ai-insane-configure-function-configure-actor-context-src-miniquake2-game-ai-insane-ml-522163959"></a>
### configure

```ml
function configure(actor, context)
```

Performs the configure operation for the miniquake2 game ai insane module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/insane.ml#L390)

<a id="function-function-miniquake2-game-ai-insane-insaneapplyspawnflags-function-insaneapplyspawnflags-actor-src-miniquake2-game-ai-insane-ml-494230020"></a>
### insaneApplySpawnFlags

```ml
function insaneApplySpawnFlags(actor)
```

Apply insane spawn flags.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/insane.ml#L223)

<a id="function-function-miniquake2-game-ai-insane-insanecheckdown-function-insanecheckdown-actor-context-src-miniquake2-game-ai-insane-ml-970131347"></a>
### insaneCheckDown

```ml
function insaneCheckDown(actor, context)
```

Validate insane down.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/insane.ml#L279)

<a id="function-function-miniquake2-game-ai-insane-insanecheckup-function-insanecheckup-actor-context-src-miniquake2-game-ai-insane-ml-949565077"></a>
### insaneCheckUp

```ml
function insaneCheckUp(actor, context)
```

Validate insane up.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/insane.ml#L290)

<a id="function-function-miniquake2-game-ai-insane-insanecrawldeathmove-function-insanecrawldeathmove-src-miniquake2-game-ai-insane-ml-607630111"></a>
### insaneCrawlDeathMove

```ml
function insaneCrawlDeathMove()
```

Move insane crawl death.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/insane.ml#L196)

<a id="function-function-miniquake2-game-ai-insane-insanecrawlmove-function-insanecrawlmove-runmove-src-miniquake2-game-ai-insane-ml-636380917"></a>
### insaneCrawlMove

```ml
function insaneCrawlMove(runMove)
```

Move insane crawl.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runMove` | `dynamic` | — | runMove value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/insane.ml#L181)

<a id="function-function-miniquake2-game-ai-insane-insanecrawlpainmove-function-insanecrawlpainmove-src-miniquake2-game-ai-insane-ml-1287374243"></a>
### insaneCrawlPainMove

```ml
function insaneCrawlPainMove()
```

Handle insane crawl move.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/insane.ml#L191)

<a id="function-function-miniquake2-game-ai-insane-insanecross-function-insanecross-actor-context-src-miniquake2-game-ai-insane-ml-1467081887"></a>
### insaneCross

```ml
function insaneCross(actor, context)
```

Compute insane.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/insane.ml#L241)

<a id="function-function-miniquake2-game-ai-insane-insanecrossmove-function-insanecrossmove-struggle-src-miniquake2-game-ai-insane-ml-1385510002"></a>
### insaneCrossMove

```ml
function insaneCrossMove(struggle)
```

Compute insane move.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `struggle` | `dynamic` | — | struggle value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/insane.ml#L202)

<a id="function-function-miniquake2-game-ai-insane-insanedead-function-insanedead-actor-context-src-miniquake2-game-ai-insane-ml-279305991"></a>
### insaneDead

```ml
function insaneDead(actor, context)
```

Return the insane dead value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/insane.ml#L342)

<a id="function-function-miniquake2-game-ai-insane-insanedie-function-insanedie-actor-attacker-damage-context-src-miniquake2-game-ai-insane-ml-24201001"></a>
### insaneDie

```ml
function insaneDie(actor, attacker, damage, context)
```

Handle insane.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `attacker` | `dynamic` | — | attacker value consumed by this operation. |
| `damage` | `dynamic` | — | damage value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/insane.ml#L362)

<a id="function-function-miniquake2-game-ai-insane-insanedownmove-function-insanedownmove-src-miniquake2-game-ai-insane-ml-1090441823"></a>
### insaneDownMove

```ml
function insaneDownMove()
```

Move insane down.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/insane.ml#L131)

<a id="function-function-miniquake2-game-ai-insane-insanedowntoupmove-function-insanedowntoupmove-src-miniquake2-game-ai-insane-ml-1974165535"></a>
### insaneDownToUpMove

```ml
function insaneDownToUpMove()
```

Move insane down to up.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/insane.ml#L119)

<a id="function-function-miniquake2-game-ai-insane-insaneemit-function-insaneemit-actor-context-soundname-src-miniquake2-game-ai-insane-ml-111460813"></a>
### insaneEmit

```ml
function insaneEmit(actor, context, soundName)
```

Emit insane.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |
| `soundName` | `dynamic` | — | soundName value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/insane.ml#L20)

<a id="function-function-miniquake2-game-ai-insane-insanefist-function-insanefist-actor-context-src-miniquake2-game-ai-insane-ml-464658615"></a>
### insaneFist

```ml
function insaneFist(actor, context)
```

Return the insane fist value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/insane.ml#L30)

<a id="function-function-miniquake2-game-ai-insane-insanejumpdownmove-function-insanejumpdownmove-src-miniquake2-game-ai-insane-ml-1680433755"></a>
### insaneJumpDownMove

```ml
function insaneJumpDownMove()
```

Move insane jump down.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/insane.ml#L126)

<a id="function-function-miniquake2-game-ai-insane-insanemakemove-function-insanemakemove-name-firstframe-lastframe-aifunction-distances-endfunction-src-miniquake2-game-ai-insane-ml-725986651"></a>
### insaneMakeMove

```ml
function insaneMakeMove(name, firstFrame, lastFrame, aiFunction, distances, endFunction)
```

Create insane move.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `name` | `dynamic` | — | Name of the affected item. |
| `firstFrame` | `dynamic` | — | firstFrame value consumed by this operation. |
| `lastFrame` | `dynamic` | — | lastFrame value consumed by this operation. |
| `aiFunction` | `dynamic` | — | aiFunction value consumed by this operation. |
| `distances` | `dynamic` | — | distances value consumed by this operation. |
| `endFunction` | `dynamic` | — | endFunction value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/insane.ml#L79)

<a id="function-function-miniquake2-game-ai-insane-insanemoan-function-insanemoan-actor-context-src-miniquake2-game-ai-insane-ml-1124078807"></a>
### insaneMoan

```ml
function insaneMoan(actor, context)
```

Return the insane moan value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/insane.ml#L44)

<a id="function-function-miniquake2-game-ai-insane-insaneonground-function-insaneonground-actor-context-src-miniquake2-game-ai-insane-ml-577800231"></a>
### insaneOnGround

```ml
function insaneOnGround(actor, context)
```

Report whether insane on ground.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/insane.ml#L272)

<a id="function-function-miniquake2-game-ai-insane-insanepain-function-insanepain-actor-attacker-damage-context-src-miniquake2-game-ai-insane-ml-731041089"></a>
### insanePain

```ml
function insanePain(actor, attacker, damage, context)
```

Handle insane.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `attacker` | `dynamic` | — | attacker value consumed by this operation. |
| `damage` | `dynamic` | — | damage value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/insane.ml#L319)

<a id="function-function-miniquake2-game-ai-insane-insanerun-function-insanerun-actor-context-src-miniquake2-game-ai-insane-ml-1636428825"></a>
### insaneRun

```ml
function insaneRun(actor, context)
```

Run insane.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/insane.ml#L260)

<a id="function-function-miniquake2-game-ai-insane-insanescream-function-insanescream-actor-context-src-miniquake2-game-ai-insane-ml-449466851"></a>
### insaneScream

```ml
function insaneScream(actor, context)
```

Return the insane scream value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/insane.ml#L51)

<a id="function-function-miniquake2-game-ai-insane-insanesetmove-function-insanesetmove-actor-move-src-miniquake2-game-ai-insane-ml-1644789983"></a>
### insaneSetMove

```ml
function insaneSetMove(actor, move)
```

Set insane move.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `move` | `dynamic` | — | move value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/insane.ml#L214)

<a id="function-function-miniquake2-game-ai-insane-insaneshake-function-insaneshake-actor-context-src-miniquake2-game-ai-insane-ml-66575991"></a>
### insaneShake

```ml
function insaneShake(actor, context)
```

Return the insane shake value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/insane.ml#L37)

<a id="function-function-miniquake2-game-ai-insane-insanestand-function-insanestand-actor-context-src-miniquake2-game-ai-insane-ml-924612987"></a>
### insaneStand

```ml
function insaneStand(actor, context)
```

Return the insane stand value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/insane.ml#L300)

<a id="function-function-miniquake2-game-ai-insane-insanestanddeathmove-function-insanestanddeathmove-src-miniquake2-game-ai-insane-ml-792604555"></a>
### insaneStandDeathMove

```ml
function insaneStandDeathMove()
```

Move insane stand death.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/insane.ml#L175)

<a id="function-function-miniquake2-game-ai-insane-insanestandinsanemove-function-insanestandinsanemove-src-miniquake2-game-ai-insane-ml-1057537689"></a>
### insaneStandInsaneMove

```ml
function insaneStandInsaneMove()
```

Move insane stand insane.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/insane.ml#L100)

<a id="function-function-miniquake2-game-ai-insane-insanestandnormalmove-function-insanestandnormalmove-src-miniquake2-game-ai-insane-ml-1039969971"></a>
### insaneStandNormalMove

```ml
function insaneStandNormalMove()
```

Move insane stand normal.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/insane.ml#L93)

<a id="function-function-miniquake2-game-ai-insane-insanestandpainmove-function-insanestandpainmove-src-miniquake2-game-ai-insane-ml-778894973"></a>
### insaneStandPainMove

```ml
function insaneStandPainMove()
```

Handle insane stand move.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/insane.ml#L170)

<a id="function-function-miniquake2-game-ai-insane-insaneuptodownmove-function-insaneuptodownmove-src-miniquake2-game-ai-insane-ml-1386571863"></a>
### insaneUpToDownMove

```ml
function insaneUpToDownMove()
```

Move insane up to down.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/insane.ml#L108)

<a id="function-function-miniquake2-game-ai-insane-insanewalk-function-insanewalk-actor-context-src-miniquake2-game-ai-insane-ml-1884936239"></a>
### insaneWalk

```ml
function insaneWalk(actor, context)
```

Return the insane walk value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/insane.ml#L248)

<a id="function-function-miniquake2-game-ai-insane-insanewalkinsanemove-function-insanewalkinsanemove-runmove-src-miniquake2-game-ai-insane-ml-790625137"></a>
### insaneWalkInsaneMove

```ml
function insaneWalkInsaneMove(runMove)
```

Move insane walk insane.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runMove` | `dynamic` | — | runMove value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/insane.ml#L158)

<a id="function-function-miniquake2-game-ai-insane-insanewalknormalmove-function-insanewalknormalmove-runmove-src-miniquake2-game-ai-insane-ml-584513889"></a>
### insaneWalkNormalMove

```ml
function insaneWalkNormalMove(runMove)
```

Move insane walk normal.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runMove` | `dynamic` | — | runMove value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/insane.ml#L146)

<a id="function-function-miniquake2-game-ai-insane-insanezeros-function-insanezeros-count-src-miniquake2-game-ai-insane-ml-2033496908"></a>
### insaneZeros

```ml
function insaneZeros(count)
```

Return the insane zeros value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `count` | `dynamic` | — | Number of items or units to process. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/insane.ml#L62)

<a id="function-function-miniquake2-game-ai-insane-restoremove-function-restoremove-actor-movename-src-miniquake2-game-ai-insane-ml-1764652252"></a>
### restoreMove

```ml
function restoreMove(actor, moveName)
```

Restore move.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `moveName` | `dynamic` | — | moveName value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/insane.ml#L404)
