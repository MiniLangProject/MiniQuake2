# `src/miniquake2/game/ai/reaction_sequences.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 game ai reaction sequences facilities for this project.

Package: [`miniquake2.game.ai.reaction_sequences`](Package-miniquake2-game-ai-reaction-sequences-793322413.md)

Reachable from entry: **yes**

## Imports

- `miniquake2/game/constants.ml` as `gaireactionconstants` → [src/miniquake2/game/constants.ml](File-src-miniquake2-game-constants-ml-1723282332.md)

## Declarations

<a id="function-function-miniquake2-game-ai-reaction-sequences-deathvariant-function-deathvariant-classname-variant-src-miniquake2-game-ai-reaction-sequences-ml-983762783"></a>
### deathVariant

```ml
function deathVariant(className, variant)
```

Return the death variant value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `className` | `dynamic` | — | className value consumed by this operation. |
| `variant` | `dynamic` | — | variant value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/reaction_sequences.ml#L388)

<a id="function-function-miniquake2-game-ai-reaction-sequences-deathvariantcount-function-deathvariantcount-classname-src-miniquake2-game-ai-reaction-sequences-ml-1668892142"></a>
### deathVariantCount

```ml
function deathVariantCount(className)
```

Return the death variant count.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `className` | `dynamic` | — | className value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/reaction_sequences.ml#L374)

<a id="function-function-miniquake2-game-ai-reaction-sequences-deterministicvalue-function-deterministicvalue-actornumber-count-salt-modulus-src-miniquake2-game-ai-reaction-sequences-ml-1404426957"></a>
### deterministicValue

```ml
function deterministicValue(actorNumber, count, salt, modulus)
```

Return the deterministic value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actorNumber` | `dynamic` | — | actorNumber value consumed by this operation. |
| `count` | `dynamic` | — | Number of items or units to process. |
| `salt` | `dynamic` | — | salt value consumed by this operation. |
| `modulus` | `dynamic` | — | modulus value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/reaction_sequences.ml#L160)

<a id="function-function-miniquake2-game-ai-reaction-sequences-durationframes-function-durationframes-plan-src-miniquake2-game-ai-reaction-sequences-ml-199945700"></a>
### durationFrames

```ml
function durationFrames(plan)
```

Return the duration frames value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `plan` | `dynamic` | — | plan value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/reaction_sequences.ml#L499)

<a id="function-function-miniquake2-game-ai-reaction-sequences-externalframeeventat-inline-function-externalframeeventat-plan-timelineoffset-src-miniquake2-game-ai-reaction-sequences-ml-1798065595"></a>
### externalFrameEventAt

```ml
inline function externalFrameEventAt(plan, timelineOffset)
```

Return the external frame event for the requested position.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `plan` | `dynamic` | — | plan value consumed by this operation. |
| `timelineOffset` | `dynamic` | — | timelineOffset value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/reaction_sequences.ml#L658)

<a id="function-function-miniquake2-game-ai-reaction-sequences-framesoundattenuationat-inline-function-framesoundattenuationat-plan-timelineoffset-src-miniquake2-game-ai-reaction-sequences-ml-1413248171"></a>
### frameSoundAttenuationAt

```ml
inline function frameSoundAttenuationAt(plan, timelineOffset)
```

Return the frame sound attenuation for the requested position.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `plan` | `dynamic` | — | plan value consumed by this operation. |
| `timelineOffset` | `dynamic` | — | timelineOffset value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/reaction_sequences.ml#L643)

<a id="function-function-miniquake2-game-ai-reaction-sequences-framesoundchannelat-inline-function-framesoundchannelat-plan-timelineoffset-src-miniquake2-game-ai-reaction-sequences-ml-825342611"></a>
### frameSoundChannelAt

```ml
inline function frameSoundChannelAt(plan, timelineOffset)
```

Return the frame sound channel for the requested position.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `plan` | `dynamic` | — | plan value consumed by this operation. |
| `timelineOffset` | `dynamic` | — | timelineOffset value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/reaction_sequences.ml#L625)

<a id="function-function-miniquake2-game-ai-reaction-sequences-framesoundnameat-inline-function-framesoundnameat-plan-timelineoffset-randomroll-src-miniquake2-game-ai-reaction-sequences-ml-1033308445"></a>
### frameSoundNameAt

```ml
inline function frameSoundNameAt(plan, timelineOffset, randomRoll)
```

Return the frame sound name for the requested position.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `plan` | `dynamic` | — | plan value consumed by this operation. |
| `timelineOffset` | `dynamic` | — | timelineOffset value consumed by this operation. |
| `randomRoll` | `dynamic` | — | randomRoll value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/reaction_sequences.ml#L590)

<a id="function-function-miniquake2-game-ai-reaction-sequences-framesoundusesrandom-inline-function-framesoundusesrandom-plan-timelineoffset-src-miniquake2-game-ai-reaction-sequences-ml-2072960043"></a>
### frameSoundUsesRandom

```ml
inline function frameSoundUsesRandom(plan, timelineOffset)
```

Frame callbacks retained by the stock pain/death mframe_t tables.  Keep the routing scalar and literal-only: these functions run inside MonsterThink and must not concatenate strings or allocate callback tables per frame.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `plan` | `dynamic` | — | plan value consumed by this operation. |
| `timelineOffset` | `dynamic` | — | timelineOffset value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/reaction_sequences.ml#L581)

<a id="global-global-miniquake2-game-ai-reaction-sequences-gaireactionmovebraindeath1-gaireactionmovebraindeath1-src-miniquake2-game-ai-reaction-sequences-ml-922709301"></a>
### gaiReactionMoveBrainDeath1

```ml
gaiReactionMoveBrainDeath1
```

Stores module-wide gai reaction move brain death1 state for the miniquake2 game ai reaction sequences module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/reaction_sequences.ml#L123)

<a id="global-global-miniquake2-game-ai-reaction-sequences-gaireactionmovebraindeath2-gaireactionmovebraindeath2-src-miniquake2-game-ai-reaction-sequences-ml-1895661391"></a>
### gaiReactionMoveBrainDeath2

```ml
gaiReactionMoveBrainDeath2
```

Stores module-wide gai reaction move brain death2 state for the miniquake2 game ai reaction sequences module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/reaction_sequences.ml#L126)

<a id="global-global-miniquake2-game-ai-reaction-sequences-gaireactionmovebrainpain1-gaireactionmovebrainpain1-src-miniquake2-game-ai-reaction-sequences-ml-1509183565"></a>
### gaiReactionMoveBrainPain1

```ml
gaiReactionMoveBrainPain1
```

Stores module-wide gai reaction move brain pain1 state for the miniquake2 game ai reaction sequences module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/reaction_sequences.ml#L62)

<a id="global-global-miniquake2-game-ai-reaction-sequences-gaireactionmovebrainpain2-gaireactionmovebrainpain2-src-miniquake2-game-ai-reaction-sequences-ml-1008677649"></a>
### gaiReactionMoveBrainPain2

```ml
gaiReactionMoveBrainPain2
```

Stores module-wide gai reaction move brain pain2 state for the miniquake2 game ai reaction sequences module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/reaction_sequences.ml#L65)

<a id="global-global-miniquake2-game-ai-reaction-sequences-gaireactionmovebrainpain3-gaireactionmovebrainpain3-src-miniquake2-game-ai-reaction-sequences-ml-1227437021"></a>
### gaiReactionMoveBrainPain3

```ml
gaiReactionMoveBrainPain3
```

Stores module-wide gai reaction move brain pain3 state for the miniquake2 game ai reaction sequences module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/reaction_sequences.ml#L67)

<a id="global-global-miniquake2-game-ai-reaction-sequences-gaireactionmovechickdeath1-gaireactionmovechickdeath1-src-miniquake2-game-ai-reaction-sequences-ml-732700349"></a>
### gaiReactionMoveChickDeath1

```ml
gaiReactionMoveChickDeath1
```

Stores module-wide gai reaction move chick death1 state for the miniquake2 game ai reaction sequences module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/reaction_sequences.ml#L118)

<a id="global-global-miniquake2-game-ai-reaction-sequences-gaireactionmovechickdeath2-gaireactionmovechickdeath2-src-miniquake2-game-ai-reaction-sequences-ml-1215922223"></a>
### gaiReactionMoveChickDeath2

```ml
gaiReactionMoveChickDeath2
```

Stores module-wide gai reaction move chick death2 state for the miniquake2 game ai reaction sequences module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/reaction_sequences.ml#L120)

<a id="global-global-miniquake2-game-ai-reaction-sequences-gaireactionmovechickpain3-gaireactionmovechickpain3-src-miniquake2-game-ai-reaction-sequences-ml-59178333"></a>
### gaiReactionMoveChickPain3

```ml
gaiReactionMoveChickPain3
```

Stores module-wide gai reaction move chick pain3 state for the miniquake2 game ai reaction sequences module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/reaction_sequences.ml#L57)

<a id="global-global-miniquake2-game-ai-reaction-sequences-gaireactionmovegunnerdeath-gaireactionmovegunnerdeath-src-miniquake2-game-ai-reaction-sequences-ml-1769471429"></a>
### gaiReactionMoveGunnerDeath

```ml
gaiReactionMoveGunnerDeath
```

Stores module-wide gai reaction move gunner death state for the miniquake2 game ai reaction sequences module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/reaction_sequences.ml#L84)

<a id="global-global-miniquake2-game-ai-reaction-sequences-gaireactionmovegunnerpain1-gaireactionmovegunnerpain1-src-miniquake2-game-ai-reaction-sequences-ml-1575737363"></a>
### gaiReactionMoveGunnerPain1

```ml
gaiReactionMoveGunnerPain1
```

Non-zero mframe_t movement columns from the stock 3.19 pain/death tables.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/reaction_sequences.ml#L33)

<a id="global-global-miniquake2-game-ai-reaction-sequences-gaireactionmovegunnerpain2-gaireactionmovegunnerpain2-src-miniquake2-game-ai-reaction-sequences-ml-1035056653"></a>
### gaiReactionMoveGunnerPain2

```ml
gaiReactionMoveGunnerPain2
```

Stores module-wide gai reaction move gunner pain2 state for the miniquake2 game ai reaction sequences module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/reaction_sequences.ml#L36)

<a id="global-global-miniquake2-game-ai-reaction-sequences-gaireactionmovegunnerpain3-gaireactionmovegunnerpain3-src-miniquake2-game-ai-reaction-sequences-ml-114728479"></a>
### gaiReactionMoveGunnerPain3

```ml
gaiReactionMoveGunnerPain3
```

Stores module-wide gai reaction move gunner pain3 state for the miniquake2 game ai reaction sequences module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/reaction_sequences.ml#L38)

<a id="global-global-miniquake2-game-ai-reaction-sequences-gaireactionmovehoverdeath-gaireactionmovehoverdeath-src-miniquake2-game-ai-reaction-sequences-ml-143605881"></a>
### gaiReactionMoveHoverDeath

```ml
gaiReactionMoveHoverDeath
```

Stores module-wide gai reaction move hover death state for the miniquake2 game ai reaction sequences module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/reaction_sequences.ml#L128)

<a id="global-global-miniquake2-game-ai-reaction-sequences-gaireactionmovehoverpain1-gaireactionmovehoverpain1-src-miniquake2-game-ai-reaction-sequences-ml-1313636425"></a>
### gaiReactionMoveHoverPain1

```ml
gaiReactionMoveHoverPain1
```

Stores module-wide gai reaction move hover pain1 state for the miniquake2 game ai reaction sequences module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/reaction_sequences.ml#L69)

<a id="global-global-miniquake2-game-ai-reaction-sequences-gaireactionmoveinfantrydeath1-gaireactionmoveinfantrydeath1-src-miniquake2-game-ai-reaction-sequences-ml-923157601"></a>
### gaiReactionMoveInfantryDeath1

```ml
gaiReactionMoveInfantryDeath1
```

Stores module-wide gai reaction move infantry death1 state for the miniquake2 game ai reaction sequences module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/reaction_sequences.ml#L86)

<a id="global-global-miniquake2-game-ai-reaction-sequences-gaireactionmoveinfantrydeath2-gaireactionmoveinfantrydeath2-src-miniquake2-game-ai-reaction-sequences-ml-1010122789"></a>
### gaiReactionMoveInfantryDeath2

```ml
gaiReactionMoveInfantryDeath2
```

Stores module-wide gai reaction move infantry death2 state for the miniquake2 game ai reaction sequences module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/reaction_sequences.ml#L89)

<a id="global-global-miniquake2-game-ai-reaction-sequences-gaireactionmoveinfantrydeath3-gaireactionmoveinfantrydeath3-src-miniquake2-game-ai-reaction-sequences-ml-1854045145"></a>
### gaiReactionMoveInfantryDeath3

```ml
gaiReactionMoveInfantryDeath3
```

Stores module-wide gai reaction move infantry death3 state for the miniquake2 game ai reaction sequences module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/reaction_sequences.ml#L93)

<a id="global-global-miniquake2-game-ai-reaction-sequences-gaireactionmoveinfantrypain1-gaireactionmoveinfantrypain1-src-miniquake2-game-ai-reaction-sequences-ml-1982239383"></a>
### gaiReactionMoveInfantryPain1

```ml
gaiReactionMoveInfantryPain1
```

Stores module-wide gai reaction move infantry pain1 state for the miniquake2 game ai reaction sequences module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/reaction_sequences.ml#L40)

<a id="global-global-miniquake2-game-ai-reaction-sequences-gaireactionmoveinfantrypain2-gaireactionmoveinfantrypain2-src-miniquake2-game-ai-reaction-sequences-ml-70453789"></a>
### gaiReactionMoveInfantryPain2

```ml
gaiReactionMoveInfantryPain2
```

Stores module-wide gai reaction move infantry pain2 state for the miniquake2 game ai reaction sequences module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/reaction_sequences.ml#L42)

<a id="global-global-miniquake2-game-ai-reaction-sequences-gaireactionmovejorgpain3-gaireactionmovejorgpain3-src-miniquake2-game-ai-reaction-sequences-ml-1328192397"></a>
### gaiReactionMoveJorgPain3

```ml
gaiReactionMoveJorgPain3
```

Stores module-wide gai reaction move jorg pain3 state for the miniquake2 game ai reaction sequences module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/reaction_sequences.ml#L79)

<a id="global-global-miniquake2-game-ai-reaction-sequences-gaireactionmovemakrondeath-gaireactionmovemakrondeath-src-miniquake2-game-ai-reaction-sequences-ml-1357293627"></a>
### gaiReactionMoveMakronDeath

```ml
gaiReactionMoveMakronDeath
```

Stores module-wide gai reaction move makron death state for the miniquake2 game ai reaction sequences module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/reaction_sequences.ml#L130)

<a id="global-global-miniquake2-game-ai-reaction-sequences-gaireactionmovemutantpain1-gaireactionmovemutantpain1-src-miniquake2-game-ai-reaction-sequences-ml-292828163"></a>
### gaiReactionMoveMutantPain1

```ml
gaiReactionMoveMutantPain1
```

Stores module-wide gai reaction move mutant pain1 state for the miniquake2 game ai reaction sequences module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/reaction_sequences.ml#L73)

<a id="global-global-miniquake2-game-ai-reaction-sequences-gaireactionmovemutantpain2-gaireactionmovemutantpain2-src-miniquake2-game-ai-reaction-sequences-ml-19252873"></a>
### gaiReactionMoveMutantPain2

```ml
gaiReactionMoveMutantPain2
```

Stores module-wide gai reaction move mutant pain2 state for the miniquake2 game ai reaction sequences module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/reaction_sequences.ml#L75)

<a id="global-global-miniquake2-game-ai-reaction-sequences-gaireactionmovemutantpain3-gaireactionmovemutantpain3-src-miniquake2-game-ai-reaction-sequences-ml-1365009875"></a>
### gaiReactionMoveMutantPain3

```ml
gaiReactionMoveMutantPain3
```

Stores module-wide gai reaction move mutant pain3 state for the miniquake2 game ai reaction sequences module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/reaction_sequences.ml#L77)

<a id="global-global-miniquake2-game-ai-reaction-sequences-gaireactionmoveparasitepain-gaireactionmoveparasitepain-src-miniquake2-game-ai-reaction-sequences-ml-870470917"></a>
### gaiReactionMoveParasitePain

```ml
gaiReactionMoveParasitePain
```

Stores module-wide gai reaction move parasite pain state for the miniquake2 game ai reaction sequences module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/reaction_sequences.ml#L60)

<a id="global-global-miniquake2-game-ai-reaction-sequences-gaireactionmovesoldierdeath1-gaireactionmovesoldierdeath1-src-miniquake2-game-ai-reaction-sequences-ml-366672633"></a>
### gaiReactionMoveSoldierDeath1

```ml
gaiReactionMoveSoldierDeath1
```

Stores module-wide gai reaction move soldier death1 state for the miniquake2 game ai reaction sequences module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/reaction_sequences.ml#L95)

<a id="global-global-miniquake2-game-ai-reaction-sequences-gaireactionmovesoldierdeath2-gaireactionmovesoldierdeath2-src-miniquake2-game-ai-reaction-sequences-ml-1186547843"></a>
### gaiReactionMoveSoldierDeath2

```ml
gaiReactionMoveSoldierDeath2
```

Stores module-wide gai reaction move soldier death2 state for the miniquake2 game ai reaction sequences module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/reaction_sequences.ml#L100)

<a id="global-global-miniquake2-game-ai-reaction-sequences-gaireactionmovesoldierdeath3-gaireactionmovesoldierdeath3-src-miniquake2-game-ai-reaction-sequences-ml-462225773"></a>
### gaiReactionMoveSoldierDeath3

```ml
gaiReactionMoveSoldierDeath3
```

Stores module-wide gai reaction move soldier death3 state for the miniquake2 game ai reaction sequences module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/reaction_sequences.ml#L105)

<a id="global-global-miniquake2-game-ai-reaction-sequences-gaireactionmovesoldierdeath5-gaireactionmovesoldierdeath5-src-miniquake2-game-ai-reaction-sequences-ml-415917425"></a>
### gaiReactionMoveSoldierDeath5

```ml
gaiReactionMoveSoldierDeath5
```

Stores module-wide gai reaction move soldier death5 state for the miniquake2 game ai reaction sequences module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/reaction_sequences.ml#L110)

<a id="global-global-miniquake2-game-ai-reaction-sequences-gaireactionmovesoldierpain1-gaireactionmovesoldierpain1-src-miniquake2-game-ai-reaction-sequences-ml-1044956849"></a>
### gaiReactionMoveSoldierPain1

```ml
gaiReactionMoveSoldierPain1
```

Stores module-wide gai reaction move soldier pain1 state for the miniquake2 game ai reaction sequences module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/reaction_sequences.ml#L44)

<a id="global-global-miniquake2-game-ai-reaction-sequences-gaireactionmovesoldierpain2-gaireactionmovesoldierpain2-src-miniquake2-game-ai-reaction-sequences-ml-808706197"></a>
### gaiReactionMoveSoldierPain2

```ml
gaiReactionMoveSoldierPain2
```

Stores module-wide gai reaction move soldier pain2 state for the miniquake2 game ai reaction sequences module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/reaction_sequences.ml#L46)

<a id="global-global-miniquake2-game-ai-reaction-sequences-gaireactionmovesoldierpain3-gaireactionmovesoldierpain3-src-miniquake2-game-ai-reaction-sequences-ml-1991134629"></a>
### gaiReactionMoveSoldierPain3

```ml
gaiReactionMoveSoldierPain3
```

Stores module-wide gai reaction move soldier pain3 state for the miniquake2 game ai reaction sequences module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/reaction_sequences.ml#L48)

<a id="global-global-miniquake2-game-ai-reaction-sequences-gaireactionmovesoldierpain4-gaireactionmovesoldierpain4-src-miniquake2-game-ai-reaction-sequences-ml-2094447369"></a>
### gaiReactionMoveSoldierPain4

```ml
gaiReactionMoveSoldierPain4
```

Stores module-wide gai reaction move soldier pain4 state for the miniquake2 game ai reaction sequences module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/reaction_sequences.ml#L51)

<a id="global-global-miniquake2-game-ai-reaction-sequences-gaireactionmovetankdeath-gaireactionmovetankdeath-src-miniquake2-game-ai-reaction-sequences-ml-1047897619"></a>
### gaiReactionMoveTankDeath

```ml
gaiReactionMoveTankDeath
```

Stores module-wide gai reaction move tank death state for the miniquake2 game ai reaction sequences module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/reaction_sequences.ml#L114)

<a id="global-global-miniquake2-game-ai-reaction-sequences-gaireactionmovetankpain3-gaireactionmovetankpain3-src-miniquake2-game-ai-reaction-sequences-ml-1737423837"></a>
### gaiReactionMoveTankPain3

```ml
gaiReactionMoveTankPain3
```

Stores module-wide gai reaction move tank pain3 state for the miniquake2 game ai reaction sequences module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/reaction_sequences.ml#L54)

<a id="function-function-miniquake2-game-ai-reaction-sequences-modelframeat-function-modelframeat-plan-timelineoffset-src-miniquake2-game-ai-reaction-sequences-ml-283673140"></a>
### modelFrameAt

```ml
function modelFrameAt(plan, timelineOffset)
```

Performs the modelFrameAt operation for the miniquake2 game ai reaction sequences module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `plan` | `dynamic` | — | plan value consumed by this operation. |
| `timelineOffset` | `dynamic` | — | timelineOffset value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/reaction_sequences.ml#L690)

- [miniquake2.game.ai.reaction_sequences.MonsterReactionPlan](Type-miniquake2-game-ai-reaction-sequences-monsterreactionplan-375035553.md) — struct
<a id="function-function-miniquake2-game-ai-reaction-sequences-movementdistanceat-inline-function-movementdistanceat-plan-timelineoffset-src-miniquake2-game-ai-reaction-sequences-ml-949835619"></a>
### movementDistanceAt

```ml
inline function movementDistanceAt(plan, timelineOffset)
```

Return the movement distance for the requested position.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `plan` | `dynamic` | — | plan value consumed by this operation. |
| `timelineOffset` | `dynamic` | — | timelineOffset value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/reaction_sequences.ml#L506)

<a id="function-function-miniquake2-game-ai-reaction-sequences-painvariant-function-painvariant-classname-variant-src-miniquake2-game-ai-reaction-sequences-ml-1986041229"></a>
### painVariant

```ml
function painVariant(className, variant)
```

Select the stock class-specific pain sequence from a zero-based variant. Random selection stays with the caller, keeping this lookup deterministic.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `className` | `dynamic` | — | className value consumed by this operation. |
| `variant` | `dynamic` | — | variant value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/reaction_sequences.ml#L212)

<a id="function-function-miniquake2-game-ai-reaction-sequences-painvariantcount-function-painvariantcount-classname-src-miniquake2-game-ai-reaction-sequences-ml-597187990"></a>
### painVariantCount

```ml
function painVariantCount(className)
```

Handle variant count.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `className` | `dynamic` | — | className value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/reaction_sequences.ml#L185)

<a id="function-function-miniquake2-game-ai-reaction-sequences-planbyname-function-planbyname-classname-name-src-miniquake2-game-ai-reaction-sequences-ml-1292920801"></a>
### planByName

```ml
function planByName(className, name)
```

Return the plan by name.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `className` | `dynamic` | — | className value consumed by this operation. |
| `name` | `dynamic` | — | Name of the affected item. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/reaction_sequences.ml#L476)

<a id="function-function-miniquake2-game-ai-reaction-sequences-reactionplan-function-reactionplan-classname-suffix-reactionkind-firstframe-lastframe-soundname-attenuation-terminalkind-src-miniquake2-game-ai-reaction-sequences-ml-665538036"></a>
### reactionPlan

```ml
function reactionPlan(className, suffix, reactionKind, firstFrame, lastFrame, soundName, attenuation, terminalKind)
```

Return the reaction plan value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `className` | `dynamic` | — | className value consumed by this operation. |
| `suffix` | `dynamic` | — | suffix value consumed by this operation. |
| `reactionKind` | `dynamic` | — | reactionKind value consumed by this operation. |
| `firstFrame` | `dynamic` | — | firstFrame value consumed by this operation. |
| `lastFrame` | `dynamic` | — | lastFrame value consumed by this operation. |
| `soundName` | `dynamic` | — | soundName value consumed by this operation. |
| `attenuation` | `dynamic` | — | attenuation value consumed by this operation. |
| `terminalKind` | `dynamic` | — | terminalKind value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/reaction_sequences.ml#L149)

<a id="function-function-miniquake2-game-ai-reaction-sequences-selectdeathplan-function-selectdeathplan-classname-actornumber-diecount-gibbed-src-miniquake2-game-ai-reaction-sequences-ml-1413659920"></a>
### selectDeathPlan

```ml
function selectDeathPlan(className, actorNumber, dieCount, gibbed)
```

Select death plan.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `className` | `dynamic` | — | className value consumed by this operation. |
| `actorNumber` | `dynamic` | — | actorNumber value consumed by this operation. |
| `dieCount` | `dynamic` | — | Number of die to process. |
| `gibbed` | `dynamic` | — | gibbed value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/reaction_sequences.ml#L445)

<a id="function-function-miniquake2-game-ai-reaction-sequences-selectpainplan-function-selectpainplan-classname-actornumber-paincount-damage-skill-src-miniquake2-game-ai-reaction-sequences-ml-435325529"></a>
### selectPainPlan

```ml
function selectPainPlan(className, actorNumber, painCount, damage, skill)
```

Select pain plan.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `className` | `dynamic` | — | className value consumed by this operation. |
| `actorNumber` | `dynamic` | — | actorNumber value consumed by this operation. |
| `painCount` | `dynamic` | — | Number of pain to process. |
| `damage` | `dynamic` | — | damage value consumed by this operation. |
| `skill` | `dynamic` | — | skill value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/reaction_sequences.ml#L325)

<a id="function-function-miniquake2-game-ai-reaction-sequences-soldierdeathsound-function-soldierdeathsound-classname-src-miniquake2-game-ai-reaction-sequences-ml-1683720468"></a>
### soldierDeathSound

```ml
function soldierDeathSound(className)
```

Return the soldier death sound value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `className` | `dynamic` | — | className value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/reaction_sequences.ml#L177)

<a id="function-function-miniquake2-game-ai-reaction-sequences-soldierpainsound-function-soldierpainsound-classname-src-miniquake2-game-ai-reaction-sequences-ml-1615654706"></a>
### soldierPainSound

```ml
function soldierPainSound(className)
```

Handle soldier sound.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `className` | `dynamic` | — | className value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/reaction_sequences.ml#L169)

<a id="function-function-miniquake2-game-ai-reaction-sequences-startsbossexplosionat-inline-function-startsbossexplosionat-plan-timelineoffset-src-miniquake2-game-ai-reaction-sequences-ml-342141979"></a>
### startsBossExplosionAt

```ml
inline function startsBossExplosionAt(plan, timelineOffset)
```

Return the starts boss explosion for the requested position.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `plan` | `dynamic` | — | plan value consumed by this operation. |
| `timelineOffset` | `dynamic` | — | timelineOffset value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/reaction_sequences.ml#L674)

<a id="function-function-miniquake2-game-ai-reaction-sequences-stockdodgeplan-function-stockdodgeplan-classname-src-miniquake2-game-ai-reaction-sequences-ml-258356342"></a>
### stockDodgePlan

```ml
function stockDodgePlan(className)
```

Return the stock dodge plan value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `className` | `dynamic` | — | className value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/reaction_sequences.ml#L461)

<a id="function-function-miniquake2-game-ai-reaction-sequences-validateplan-function-validateplan-plan-src-miniquake2-game-ai-reaction-sequences-ml-666009812"></a>
### validatePlan

```ml
function validatePlan(plan)
```

Validates plan for the miniquake2 game ai reaction sequences workflow.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `plan` | `dynamic` | — | plan value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/reaction_sequences.ml#L699)
