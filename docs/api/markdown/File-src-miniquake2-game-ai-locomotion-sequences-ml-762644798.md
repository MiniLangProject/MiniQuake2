# `src/miniquake2/game/ai/locomotion_sequences.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 game ai locomotion sequences facilities for this project.

Package: [`miniquake2.game.ai.locomotion_sequences`](Package-miniquake2-game-ai-locomotion-sequences-1985754795.md)

Reachable from entry: **yes**

## Imports

- `miniquake2/game/ai/core.ml` as `locomotioncore` → [src/miniquake2/game/ai/core.ml](File-src-miniquake2-game-ai-core-ml-1671967255.md)
- `miniquake2/game/ai/types.ml` as `locomotiontypes` → [src/miniquake2/game/ai/types.ml](File-src-miniquake2-game-ai-types-ml-2113011711.md)

## Declarations

<a id="global-global-miniquake2-game-ai-locomotion-sequences-berserkrundistances-berserkrundistances-src-miniquake2-game-ai-locomotion-sequences-ml-621440309"></a>
### berserkRunDistances

```ml
berserkRunDistances
```

Stores module-wide berserk run distances state for the miniquake2 game ai locomotion sequences module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/locomotion_sequences.ml#L38)

<a id="global-global-miniquake2-game-ai-locomotion-sequences-berserkwalkdistances-berserkwalkdistances-src-miniquake2-game-ai-locomotion-sequences-ml-1161186507"></a>
### berserkWalkDistances

```ml
berserkWalkDistances
```

Variable-distance tables are rooted once per package, mirroring the static


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/locomotion_sequences.ml#L36)

<a id="global-global-miniquake2-game-ai-locomotion-sequences-brainrundistances-brainrundistances-src-miniquake2-game-ai-locomotion-sequences-ml-296988081"></a>
### brainRunDistances

```ml
brainRunDistances
```

Stores module-wide brain run distances state for the miniquake2 game ai locomotion sequences module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/locomotion_sequences.ml#L85)

<a id="global-global-miniquake2-game-ai-locomotion-sequences-brainwalkdistances-brainwalkdistances-src-miniquake2-game-ai-locomotion-sequences-ml-197878235"></a>
### brainWalkDistances

```ml
brainWalkDistances
```

Stores module-wide brain walk distances state for the miniquake2 game ai locomotion sequences module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/locomotion_sequences.ml#L83)

<a id="global-global-miniquake2-game-ai-locomotion-sequences-chickmovedistances-chickmovedistances-src-miniquake2-game-ai-locomotion-sequences-ml-125211827"></a>
### chickMoveDistances

```ml
chickMoveDistances
```

Stores module-wide chick move distances state for the miniquake2 game ai locomotion sequences module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/locomotion_sequences.ml#L77)

<a id="global-global-miniquake2-game-ai-locomotion-sequences-chickrunstartdistances-chickrunstartdistances-src-miniquake2-game-ai-locomotion-sequences-ml-1711262199"></a>
### chickRunStartDistances

```ml
chickRunStartDistances
```

Stores module-wide chick run start distances state for the miniquake2 game ai locomotion sequences module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/locomotion_sequences.ml#L75)

<a id="global-global-miniquake2-game-ai-locomotion-sequences-gladiatorrundistances-gladiatorrundistances-src-miniquake2-game-ai-locomotion-sequences-ml-1772484845"></a>
### gladiatorRunDistances

```ml
gladiatorRunDistances
```

Stores module-wide gladiator run distances state for the miniquake2 game ai locomotion sequences module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/locomotion_sequences.ml#L42)

<a id="global-global-miniquake2-game-ai-locomotion-sequences-gladiatorwalkdistances-gladiatorwalkdistances-src-miniquake2-game-ai-locomotion-sequences-ml-845743205"></a>
### gladiatorWalkDistances

```ml
gladiatorWalkDistances
```

Stores module-wide gladiator walk distances state for the miniquake2 game ai locomotion sequences module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/locomotion_sequences.ml#L40)

<a id="global-global-miniquake2-game-ai-locomotion-sequences-gunnerrundistances-gunnerrundistances-src-miniquake2-game-ai-locomotion-sequences-ml-1758978025"></a>
### gunnerRunDistances

```ml
gunnerRunDistances
```

Stores module-wide gunner run distances state for the miniquake2 game ai locomotion sequences module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/locomotion_sequences.ml#L46)

<a id="global-global-miniquake2-game-ai-locomotion-sequences-gunnerwalkdistances-gunnerwalkdistances-src-miniquake2-game-ai-locomotion-sequences-ml-1137212029"></a>
### gunnerWalkDistances

```ml
gunnerWalkDistances
```

Stores module-wide gunner walk distances state for the miniquake2 game ai locomotion sequences module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/locomotion_sequences.ml#L44)

<a id="function-function-miniquake2-game-ai-locomotion-sequences-hasstockmoves-inline-function-hasstockmoves-classname-src-miniquake2-game-ai-locomotion-sequences-ml-1721191499"></a>
### hasStockMoves

```ml
inline function hasStockMoves(className)
```

Report whether has stock moves.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `className` | `dynamic` | — | className value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/locomotion_sequences.ml#L148)

<a id="global-global-miniquake2-game-ai-locomotion-sequences-infantryfidgetdistances-infantryfidgetdistances-src-miniquake2-game-ai-locomotion-sequences-ml-1185081469"></a>
### infantryFidgetDistances

```ml
infantryFidgetDistances
```

Stores module-wide infantry fidget distances state for the miniquake2 game ai locomotion sequences module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/locomotion_sequences.ml#L52)

<a id="global-global-miniquake2-game-ai-locomotion-sequences-infantryrundistances-infantryrundistances-src-miniquake2-game-ai-locomotion-sequences-ml-2125601309"></a>
### infantryRunDistances

```ml
infantryRunDistances
```

Stores module-wide infantry run distances state for the miniquake2 game ai locomotion sequences module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/locomotion_sequences.ml#L50)

<a id="global-global-miniquake2-game-ai-locomotion-sequences-infantrywalkdistances-infantrywalkdistances-src-miniquake2-game-ai-locomotion-sequences-ml-653829981"></a>
### infantryWalkDistances

```ml
infantryWalkDistances
```

Stores module-wide infantry walk distances state for the miniquake2 game ai locomotion sequences module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/locomotion_sequences.ml#L48)

<a id="global-global-miniquake2-game-ai-locomotion-sequences-jorgmovedistances-jorgmovedistances-src-miniquake2-game-ai-locomotion-sequences-ml-499359889"></a>
### jorgMoveDistances

```ml
jorgMoveDistances
```

Stores module-wide jorg move distances state for the miniquake2 game ai locomotion sequences module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/locomotion_sequences.ml#L99)

<a id="global-global-miniquake2-game-ai-locomotion-sequences-jorgstanddistances-jorgstanddistances-src-miniquake2-game-ai-locomotion-sequences-ml-1965639905"></a>
### jorgStandDistances

```ml
jorgStandDistances
```

Stores module-wide jorg stand distances state for the miniquake2 game ai locomotion sequences module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/locomotion_sequences.ml#L93)

<a id="function-function-miniquake2-game-ai-locomotion-sequences-makelocomotionplan-function-makelocomotionplan-classname-standfirst-standlast-idlefirst-idlelast-walkfirst-walklast-runfirst-runlast-src-miniquake2-game-ai-locomotion-sequences-ml-1780342008"></a>
### makeLocomotionPlan

```ml
function makeLocomotionPlan(className, standFirst, standLast, idleFirst, idleLast, walkFirst, walkLast, runFirst, runLast)
```

Create locomotion plan.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `className` | `dynamic` | — | className value consumed by this operation. |
| `standFirst` | `dynamic` | — | standFirst value consumed by this operation. |
| `standLast` | `dynamic` | — | standLast value consumed by this operation. |
| `idleFirst` | `dynamic` | — | idleFirst value consumed by this operation. |
| `idleLast` | `dynamic` | — | idleLast value consumed by this operation. |
| `walkFirst` | `dynamic` | — | walkFirst value consumed by this operation. |
| `walkLast` | `dynamic` | — | walkLast value consumed by this operation. |
| `runFirst` | `dynamic` | — | runFirst value consumed by this operation. |
| `runLast` | `dynamic` | — | runLast value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/locomotion_sequences.ml#L113)

<a id="function-function-miniquake2-game-ai-locomotion-sequences-makestockmove-function-makestockmove-name-firstframe-lastframe-aifunction-distances-defaultdistance-endfunction-src-miniquake2-game-ai-locomotion-sequences-ml-518907979"></a>
### makeStockMove

```ml
function makeStockMove(name, firstFrame, lastFrame, aiFunction, distances, defaultDistance, endFunction)
```

Create stock move.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `name` | `dynamic` | — | Name of the affected item. |
| `firstFrame` | `dynamic` | — | firstFrame value consumed by this operation. |
| `lastFrame` | `dynamic` | — | lastFrame value consumed by this operation. |
| `aiFunction` | `dynamic` | — | aiFunction value consumed by this operation. |
| `distances` | `dynamic` | — | distances value consumed by this operation. |
| `defaultDistance` | `dynamic` | — | defaultDistance value consumed by this operation. |
| `endFunction` | `dynamic` | — | endFunction value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/locomotion_sequences.ml#L170)

<a id="global-global-miniquake2-game-ai-locomotion-sequences-makronmovedistances-makronmovedistances-src-miniquake2-game-ai-locomotion-sequences-ml-1252417285"></a>
### makronMoveDistances

```ml
makronMoveDistances
```

Stores module-wide makron move distances state for the miniquake2 game ai locomotion sequences module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/locomotion_sequences.ml#L101)

<a id="global-global-miniquake2-game-ai-locomotion-sequences-medicrundistances-medicrundistances-src-miniquake2-game-ai-locomotion-sequences-ml-658170445"></a>
### medicRunDistances

```ml
medicRunDistances
```

Stores module-wide medic run distances state for the miniquake2 game ai locomotion sequences module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/locomotion_sequences.ml#L73)

<a id="global-global-miniquake2-game-ai-locomotion-sequences-medicwalkdistances-medicwalkdistances-src-miniquake2-game-ai-locomotion-sequences-ml-21530227"></a>
### medicWalkDistances

```ml
medicWalkDistances
```

Stores module-wide medic walk distances state for the miniquake2 game ai locomotion sequences module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/locomotion_sequences.ml#L71)

<a id="function-function-miniquake2-game-ai-locomotion-sequences-modelframeat-function-modelframeat-plan-activity-framenumber-actornumber-src-miniquake2-game-ai-locomotion-sequences-ml-1949231053"></a>
### modelFrameAt

```ml
function modelFrameAt(plan, activity, frameNumber, actorNumber)
```

Performs the modelFrameAt operation for the miniquake2 game ai locomotion sequences module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `plan` | `dynamic` | — | plan value consumed by this operation. |
| `activity` | `dynamic` | — | activity value consumed by this operation. |
| `frameNumber` | `dynamic` | — | frameNumber value consumed by this operation. |
| `actorNumber` | `dynamic` | — | actorNumber value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/locomotion_sequences.ml#L332)

- [miniquake2.game.ai.locomotion_sequences.MonsterLocomotionPlan](Type-miniquake2-game-ai-locomotion-sequences-monsterlocomotionplan-845389677.md) — struct
<a id="global-global-miniquake2-game-ai-locomotion-sequences-mutantrundistances-mutantrundistances-src-miniquake2-game-ai-locomotion-sequences-ml-2028671437"></a>
### mutantRunDistances

```ml
mutantRunDistances
```

Stores module-wide mutant run distances state for the miniquake2 game ai locomotion sequences module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/locomotion_sequences.ml#L91)

<a id="global-global-miniquake2-game-ai-locomotion-sequences-mutantwalkdistances-mutantwalkdistances-src-miniquake2-game-ai-locomotion-sequences-ml-1913878349"></a>
### mutantWalkDistances

```ml
mutantWalkDistances
```

Stores module-wide mutant walk distances state for the miniquake2 game ai locomotion sequences module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/locomotion_sequences.ml#L89)

<a id="global-global-miniquake2-game-ai-locomotion-sequences-mutantwalkstartdistances-mutantwalkstartdistances-src-miniquake2-game-ai-locomotion-sequences-ml-1414487613"></a>
### mutantWalkStartDistances

```ml
mutantWalkStartDistances
```

Stores module-wide mutant walk start distances state for the miniquake2 game ai locomotion sequences module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/locomotion_sequences.ml#L87)

<a id="global-global-miniquake2-game-ai-locomotion-sequences-parasitemovedistances-parasitemovedistances-src-miniquake2-game-ai-locomotion-sequences-ml-1017602685"></a>
### parasiteMoveDistances

```ml
parasiteMoveDistances
```

Stores module-wide parasite move distances state for the miniquake2 game ai locomotion sequences module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/locomotion_sequences.ml#L81)

<a id="global-global-miniquake2-game-ai-locomotion-sequences-parasitestartdistances-parasitestartdistances-src-miniquake2-game-ai-locomotion-sequences-ml-1003245375"></a>
### parasiteStartDistances

```ml
parasiteStartDistances
```

Stores module-wide parasite start distances state for the miniquake2 game ai locomotion sequences module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/locomotion_sequences.ml#L79)

<a id="function-function-miniquake2-game-ai-locomotion-sequences-rangefirst-function-rangefirst-plan-activity-src-miniquake2-game-ai-locomotion-sequences-ml-1875446793"></a>
### rangeFirst

```ml
function rangeFirst(plan, activity)
```

Return the range first value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `plan` | `dynamic` | — | plan value consumed by this operation. |
| `activity` | `dynamic` | — | activity value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/locomotion_sequences.ml#L310)

<a id="function-function-miniquake2-game-ai-locomotion-sequences-rangelast-function-rangelast-plan-activity-src-miniquake2-game-ai-locomotion-sequences-ml-1098774591"></a>
### rangeLast

```ml
function rangeLast(plan, activity)
```

Return the range last value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `plan` | `dynamic` | — | plan value consumed by this operation. |
| `activity` | `dynamic` | — | activity value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/locomotion_sequences.ml#L320)

<a id="global-global-miniquake2-game-ai-locomotion-sequences-soldierrundistances-soldierrundistances-src-miniquake2-game-ai-locomotion-sequences-ml-1288452561"></a>
### soldierRunDistances

```ml
soldierRunDistances
```

Stores module-wide soldier run distances state for the miniquake2 game ai locomotion sequences module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/locomotion_sequences.ml#L65)

<a id="global-global-miniquake2-game-ai-locomotion-sequences-soldierrunstartdistances-soldierrunstartdistances-src-miniquake2-game-ai-locomotion-sequences-ml-1726977299"></a>
### soldierRunStartDistances

```ml
soldierRunStartDistances
```

Stores module-wide soldier run start distances state for the miniquake2 game ai locomotion sequences module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/locomotion_sequences.ml#L63)

<a id="global-global-miniquake2-game-ai-locomotion-sequences-soldierwalk1distances-soldierwalk1distances-src-miniquake2-game-ai-locomotion-sequences-ml-268971149"></a>
### soldierWalk1Distances

```ml
soldierWalk1Distances
```

Stores module-wide soldier walk1 distances state for the miniquake2 game ai locomotion sequences module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/locomotion_sequences.ml#L57)

<a id="global-global-miniquake2-game-ai-locomotion-sequences-soldierwalk2distances-soldierwalk2distances-src-miniquake2-game-ai-locomotion-sequences-ml-94659589"></a>
### soldierWalk2Distances

```ml
soldierWalk2Distances
```

Stores module-wide soldier walk2 distances state for the miniquake2 game ai locomotion sequences module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/locomotion_sequences.ml#L61)

<a id="function-function-miniquake2-game-ai-locomotion-sequences-stockmove-function-stockmove-classname-movekind-endfunction-src-miniquake2-game-ai-locomotion-sequences-ml-1442806084"></a>
### stockMove

```ml
function stockMove(className, moveKind, endFunction)
```

Return the immutable stock locomotion contract for one class and activity. Unsupported combinations remain explicit instead of inventing frame ranges.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `className` | `dynamic` | — | className value consumed by this operation. |
| `moveKind` | `dynamic` | — | moveKind value consumed by this operation. |
| `endFunction` | `dynamic` | — | endFunction value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/locomotion_sequences.ml#L189)

<a id="function-function-miniquake2-game-ai-locomotion-sequences-stockplan-function-stockplan-classname-src-miniquake2-game-ai-locomotion-sequences-ml-572101232"></a>
### stockPlan

```ml
function stockPlan(className)
```

Return the stock plan value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `className` | `dynamic` | — | className value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/locomotion_sequences.ml#L121)

<a id="global-global-miniquake2-game-ai-locomotion-sequences-tankmovedistances-tankmovedistances-src-miniquake2-game-ai-locomotion-sequences-ml-2074065437"></a>
### tankMoveDistances

```ml
tankMoveDistances
```

Stores module-wide tank move distances state for the miniquake2 game ai locomotion sequences module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/locomotion_sequences.ml#L69)

<a id="global-global-miniquake2-game-ai-locomotion-sequences-tankstartdistances-tankstartdistances-src-miniquake2-game-ai-locomotion-sequences-ml-167269425"></a>
### tankStartDistances

```ml
tankStartDistances
```

Stores module-wide tank start distances state for the miniquake2 game ai locomotion sequences module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/locomotion_sequences.ml#L67)

<a id="function-function-miniquake2-game-ai-locomotion-sequences-validateplan-function-validateplan-plan-src-miniquake2-game-ai-locomotion-sequences-ml-1019377304"></a>
### validatePlan

```ml
function validatePlan(plan)
```

Validates plan for the miniquake2 game ai locomotion sequences workflow.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `plan` | `dynamic` | — | plan value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/locomotion_sequences.ml#L343)
