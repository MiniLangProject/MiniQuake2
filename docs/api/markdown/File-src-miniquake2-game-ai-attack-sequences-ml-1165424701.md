# `src/miniquake2/game/ai/attack_sequences.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 game ai attack sequences facilities for this project.

Package: [`miniquake2.game.ai.attack_sequences`](Package-miniquake2-game-ai-attack-sequences-1282779306.md)

Reachable from entry: **yes**

## Imports

- `miniquake2/game/ai/combat_profiles.ml` as `attackprofiles` → [src/miniquake2/game/ai/combat_profiles.ml](File-src-miniquake2-game-ai-combat-profiles-ml-1653840149.md)
- `miniquake2/game/constants.ml` as `attackconstants` → [src/miniquake2/game/constants.ml](File-src-miniquake2-game-constants-ml-1723282332.md)

## Declarations

<a id="function-function-miniquake2-game-ai-attack-sequences-actormachinegunplan-function-actormachinegunplan-raw-src-miniquake2-game-ai-attack-sequences-ml-352081529"></a>
### actorMachinegunPlan

```ml
function actorMachinegunPlan(raw)
```

Return the actor machinegun plan value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `raw` | `dynamic` | — | raw value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/attack_sequences.ml#L360)

<a id="function-function-miniquake2-game-ai-attack-sequences-actormachinegunplanshots-function-actormachinegunplanshots-shotcount-src-miniquake2-game-ai-attack-sequences-ml-742807586"></a>
### actorMachinegunPlanShots

```ml
function actorMachinegunPlanShots(shotCount)
```

Return the actor machinegun plan shots value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `shotCount` | `dynamic` | — | Number of shot to process. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/attack_sequences.ml#L342)

<a id="constant-constant-miniquake2-game-ai-attack-sequences-attack-ai-charge-const-attack-ai-charge-1-src-miniquake2-game-ai-attack-sequences-ml-264858335"></a>
### ATTACK_AI_CHARGE

```ml
const ATTACK_AI_CHARGE = 1
```

Defines the attack ai charge constant used by the miniquake2 game ai attack sequences module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/attack_sequences.ml#L49)

<a id="constant-constant-miniquake2-game-ai-attack-sequences-attack-ai-move-const-attack-ai-move-2-src-miniquake2-game-ai-attack-sequences-ml-2101235294"></a>
### ATTACK_AI_MOVE

```ml
const ATTACK_AI_MOVE = 2
```

Defines the attack ai move constant used by the miniquake2 game ai attack sequences module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/attack_sequences.ml#L51)

<a id="constant-constant-miniquake2-game-ai-attack-sequences-attack-ai-none-const-attack-ai-none-0-src-miniquake2-game-ai-attack-sequences-ml-1192304618"></a>
### ATTACK_AI_NONE

```ml
const ATTACK_AI_NONE = 0
```

Defines the attack ai none constant used by the miniquake2 game ai attack sequences module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/attack_sequences.ml#L47)

<a id="function-function-miniquake2-game-ai-attack-sequences-attackplan-function-attackplan-classname-name-attackkind-damage-knockback-speed-splashradius-maximumrange-count-frameoffsets-muzzleflashes-durationframes-src-miniquake2-game-ai-attack-sequences-ml-1726387409"></a>
### attackPlan

```ml
function attackPlan(className, name, attackKind, damage, knockback, speed, splashRadius, maximumRange, count, frameOffsets, muzzleFlashes, durationFrames)
```

Run plan.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `className` | `dynamic` | — | className value consumed by this operation. |
| `name` | `dynamic` | — | Name of the affected item. |
| `attackKind` | `dynamic` | — | attackKind value consumed by this operation. |
| `damage` | `dynamic` | — | damage value consumed by this operation. |
| `knockback` | `dynamic` | — | knockback value consumed by this operation. |
| `speed` | `dynamic` | — | speed value consumed by this operation. |
| `splashRadius` | `dynamic` | — | splashRadius value consumed by this operation. |
| `maximumRange` | `dynamic` | — | maximumRange value consumed by this operation. |
| `count` | `dynamic` | — | Number of items or units to process. |
| `frameOffsets` | `dynamic` | — | frameOffsets value consumed by this operation. |
| `muzzleFlashes` | `dynamic` | — | muzzleFlashes value consumed by this operation. |
| `durationFrames` | `dynamic` | — | durationFrames value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/attack_sequences.ml#L333)

<a id="function-function-miniquake2-game-ai-attack-sequences-berserkmeleeplan-function-berserkmeleeplan-actornumber-attackcount-src-miniquake2-game-ai-attack-sequences-ml-140979938"></a>
### berserkMeleePlan

```ml
function berserkMeleePlan(actorNumber, attackCount)
```

Return the berserk melee plan value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actorNumber` | `dynamic` | — | actorNumber value consumed by this operation. |
| `attackCount` | `dynamic` | — | Number of attack to process. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/attack_sequences.ml#L465)

<a id="function-function-miniquake2-game-ai-attack-sequences-berserkplanwithraw-function-berserkplanwithraw-raw-src-miniquake2-game-ai-attack-sequences-ml-1572396295"></a>
### berserkPlanWithRaw

```ml
function berserkPlanWithRaw(raw)
```

Return the berserk plan with raw value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `raw` | `dynamic` | — | raw value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/attack_sequences.ml#L1251)

<a id="function-function-miniquake2-game-ai-attack-sequences-boss2machinegunplan-function-boss2machinegunplan-actornumber-attackcount-src-miniquake2-game-ai-attack-sequences-ml-1329372828"></a>
### boss2MachinegunPlan

```ml
function boss2MachinegunPlan(actorNumber, attackCount)
```

Return the boss 2 machinegun plan value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actorNumber` | `dynamic` | — | actorNumber value consumed by this operation. |
| `attackCount` | `dynamic` | — | Number of attack to process. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/attack_sequences.ml#L1100)

<a id="function-function-miniquake2-game-ai-attack-sequences-boss2machinegunplancycles-function-boss2machinegunplancycles-cycles-src-miniquake2-game-ai-attack-sequences-ml-1907405954"></a>
### boss2MachinegunPlanCycles

```ml
function boss2MachinegunPlanCycles(cycles)
```

Return the boss 2 machinegun plan cycles value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `cycles` | `dynamic` | — | cycles value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/attack_sequences.ml#L1073)

<a id="function-function-miniquake2-game-ai-attack-sequences-boss2planwithroll-function-boss2planwithroll-actornumber-attackcount-distance-roll-src-miniquake2-game-ai-attack-sequences-ml-797311448"></a>
### boss2PlanWithRoll

```ml
function boss2PlanWithRoll(actorNumber, attackCount, distance, roll)
```

Return the boss 2 plan with roll value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actorNumber` | `dynamic` | — | actorNumber value consumed by this operation. |
| `attackCount` | `dynamic` | — | Number of attack to process. |
| `distance` | `dynamic` | — | distance value consumed by this operation. |
| `roll` | `dynamic` | — | roll value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/attack_sequences.ml#L1325)

<a id="function-function-miniquake2-game-ai-attack-sequences-boss2rocketplan-function-boss2rocketplan-src-miniquake2-game-ai-attack-sequences-ml-1154121357"></a>
### boss2RocketPlan

```ml
function boss2RocketPlan()
```

Return the boss 2 rocket plan value.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/attack_sequences.ml#L1105)

<a id="function-function-miniquake2-game-ai-attack-sequences-boundedattackoffset-function-boundedattackoffset-plan-timelineoffset-src-miniquake2-game-ai-attack-sequences-ml-1047177002"></a>
### boundedAttackOffset

```ml
function boundedAttackOffset(plan, timelineOffset)
```

Run bounded offset.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `plan` | `dynamic` | — | plan value consumed by this operation. |
| `timelineOffset` | `dynamic` | — | timelineOffset value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/attack_sequences.ml#L120)

<a id="global-global-miniquake2-game-ai-attack-sequences-brainclawdistances-brainclawdistances-src-miniquake2-game-ai-attack-sequences-ml-166442399"></a>
### brainClawDistances

```ml
brainClawDistances
```

Stores module-wide brain claw distances state for the miniquake2 game ai attack sequences module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/attack_sequences.ml#L86)

<a id="function-function-miniquake2-game-ai-attack-sequences-brainclawplan-function-brainclawplan-src-miniquake2-game-ai-attack-sequences-ml-269743533"></a>
### brainClawPlan

```ml
function brainClawPlan()
```

Return the brain claw plan value.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/attack_sequences.ml#L528)

<a id="function-function-miniquake2-game-ai-attack-sequences-brainplanwithroll-function-brainplanwithroll-skill-roll-src-miniquake2-game-ai-attack-sequences-ml-152867191"></a>
### brainPlanWithRoll

```ml
function brainPlanWithRoll(skill, roll)
```

Return the brain plan with roll value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `skill` | `dynamic` | — | skill value consumed by this operation. |
| `roll` | `dynamic` | — | roll value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/attack_sequences.ml#L1285)

<a id="global-global-miniquake2-game-ai-attack-sequences-braintentacledistances-braintentacledistances-src-miniquake2-game-ai-attack-sequences-ml-570603705"></a>
### brainTentacleDistances

```ml
brainTentacleDistances
```

Stores module-wide brain tentacle distances state for the miniquake2 game ai attack sequences module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/attack_sequences.ml#L89)

<a id="function-function-miniquake2-game-ai-attack-sequences-braintentacleplan-function-braintentacleplan-skill-src-miniquake2-game-ai-attack-sequences-ml-1712156126"></a>
### brainTentaclePlan

```ml
function brainTentaclePlan(skill)
```

Return the brain tentacle plan value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `skill` | `dynamic` | — | skill value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/attack_sequences.ml#L535)

<a id="function-function-miniquake2-game-ai-attack-sequences-chickmeleeplan-function-chickmeleeplan-actornumber-attackcount-src-miniquake2-game-ai-attack-sequences-ml-914529918"></a>
### chickMeleePlan

```ml
function chickMeleePlan(actorNumber, attackCount)
```

Return the chick melee plan value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actorNumber` | `dynamic` | — | actorNumber value consumed by this operation. |
| `attackCount` | `dynamic` | — | Number of attack to process. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/attack_sequences.ml#L499)

<a id="function-function-miniquake2-game-ai-attack-sequences-chickmeleeplancycles-function-chickmeleeplancycles-cycles-src-miniquake2-game-ai-attack-sequences-ml-570746918"></a>
### chickMeleePlanCycles

```ml
function chickMeleePlanCycles(cycles)
```

Return the chick melee plan cycles value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `cycles` | `dynamic` | — | cycles value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/attack_sequences.ml#L482)

<a id="global-global-miniquake2-game-ai-attack-sequences-chickrocketcycledistances-chickrocketcycledistances-src-miniquake2-game-ai-attack-sequences-ml-2065133761"></a>
### chickRocketCycleDistances

```ml
chickRocketCycleDistances
```

Stores module-wide chick rocket cycle distances state for the miniquake2 game ai attack sequences module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/attack_sequences.ml#L72)

<a id="global-global-miniquake2-game-ai-attack-sequences-chickrocketenddistances-chickrocketenddistances-src-miniquake2-game-ai-attack-sequences-ml-2000361973"></a>
### chickRocketEndDistances

```ml
chickRocketEndDistances
```

Stores module-wide chick rocket end distances state for the miniquake2 game ai attack sequences module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/attack_sequences.ml#L75)

<a id="function-function-miniquake2-game-ai-attack-sequences-chickrocketplan-function-chickrocketplan-actornumber-attackcount-src-miniquake2-game-ai-attack-sequences-ml-1043682172"></a>
### chickRocketPlan

```ml
function chickRocketPlan(actorNumber, attackCount)
```

Return the chick rocket plan value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actorNumber` | `dynamic` | — | actorNumber value consumed by this operation. |
| `attackCount` | `dynamic` | — | Number of attack to process. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/attack_sequences.ml#L664)

<a id="function-function-miniquake2-game-ai-attack-sequences-chickrocketplancycles-function-chickrocketplancycles-cycles-src-miniquake2-game-ai-attack-sequences-ml-549475810"></a>
### chickRocketPlanCycles

```ml
function chickRocketPlanCycles(cycles)
```

Return the chick rocket plan cycles value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `cycles` | `dynamic` | — | cycles value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/attack_sequences.ml#L647)

<a id="global-global-miniquake2-game-ai-attack-sequences-chickrocketstartdistances-chickrocketstartdistances-src-miniquake2-game-ai-attack-sequences-ml-541327861"></a>
### chickRocketStartDistances

```ml
chickRocketStartDistances
```

Stores module-wide chick rocket start distances state for the miniquake2 game ai attack sequences module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/attack_sequences.ml#L69)

<a id="global-global-miniquake2-game-ai-attack-sequences-chickslashcycledistances-chickslashcycledistances-src-miniquake2-game-ai-attack-sequences-ml-58983203"></a>
### chickSlashCycleDistances

```ml
chickSlashCycleDistances
```

Stores module-wide chick slash cycle distances state for the miniquake2 game ai attack sequences module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/attack_sequences.ml#L79)

<a id="global-global-miniquake2-game-ai-attack-sequences-chickslashenddistances-chickslashenddistances-src-miniquake2-game-ai-attack-sequences-ml-1470734733"></a>
### chickSlashEndDistances

```ml
chickSlashEndDistances
```

Stores module-wide chick slash end distances state for the miniquake2 game ai attack sequences module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/attack_sequences.ml#L81)

<a id="global-global-miniquake2-game-ai-attack-sequences-chickslashstartdistances-chickslashstartdistances-src-miniquake2-game-ai-attack-sequences-ml-288466035"></a>
### chickSlashStartDistances

```ml
chickSlashStartDistances
```

Stores module-wide chick slash start distances state for the miniquake2 game ai attack sequences module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/attack_sequences.ml#L77)

<a id="function-function-miniquake2-game-ai-attack-sequences-clamptimelineoffset-function-clamptimelineoffset-plan-timelineoffset-src-miniquake2-game-ai-attack-sequences-ml-1882307984"></a>
### clampTimelineOffset

```ml
function clampTimelineOffset(plan, timelineOffset)
```

Clamp timeline offset.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `plan` | `dynamic` | — | plan value consumed by this operation. |
| `timelineOffset` | `dynamic` | — | timelineOffset value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/attack_sequences.ml#L1501)

<a id="function-function-miniquake2-game-ai-attack-sequences-deterministicvalue-function-deterministicvalue-actornumber-attackcount-salt-modulus-src-miniquake2-game-ai-attack-sequences-ml-1012048905"></a>
### deterministicValue

```ml
function deterministicValue(actorNumber, attackCount, salt, modulus)
```

Return the deterministic value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actorNumber` | `dynamic` | — | actorNumber value consumed by this operation. |
| `attackCount` | `dynamic` | — | Number of attack to process. |
| `salt` | `dynamic` | — | salt value consumed by this operation. |
| `modulus` | `dynamic` | — | modulus value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/attack_sequences.ml#L369)

<a id="function-function-miniquake2-game-ai-attack-sequences-eventdamage-inline-function-eventdamage-plan-eventindex-src-miniquake2-game-ai-attack-sequences-ml-2082645555"></a>
### eventDamage

```ml
inline function eventDamage(plan, eventIndex)
```

Return the event damage value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `plan` | `dynamic` | — | plan value consumed by this operation. |
| `eventIndex` | `dynamic` | — | Zero-based index of event. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/attack_sequences.ml#L1459)

<a id="function-function-miniquake2-game-ai-attack-sequences-eventknockback-inline-function-eventknockback-plan-eventindex-src-miniquake2-game-ai-attack-sequences-ml-198568627"></a>
### eventKnockback

```ml
inline function eventKnockback(plan, eventIndex)
```

Return the event knockback value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `plan` | `dynamic` | — | plan value consumed by this operation. |
| `eventIndex` | `dynamic` | — | Zero-based index of event. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/attack_sequences.ml#L1468)

<a id="function-function-miniquake2-game-ai-attack-sequences-eventsourceflash-inline-function-eventsourceflash-plan-eventindex-src-miniquake2-game-ai-attack-sequences-ml-675395699"></a>
### eventSourceFlash

```ml
inline function eventSourceFlash(plan, eventIndex)
```

Return the event source flash value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `plan` | `dynamic` | — | plan value consumed by this operation. |
| `eventIndex` | `dynamic` | — | Zero-based index of event. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/attack_sequences.ml#L1476)

<a id="function-function-miniquake2-game-ai-attack-sequences-eventuseshyperblastereffect-inline-function-eventuseshyperblastereffect-plan-eventindex-src-miniquake2-game-ai-attack-sequences-ml-581645971"></a>
### eventUsesHyperblasterEffect

```ml
inline function eventUsesHyperblasterEffect(plan, eventIndex)
```

Return the event uses hyperblaster effect value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `plan` | `dynamic` | — | plan value consumed by this operation. |
| `eventIndex` | `dynamic` | — | Zero-based index of event. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/attack_sequences.ml#L1487)

<a id="function-function-miniquake2-game-ai-attack-sequences-fallbackplan-function-fallbackplan-classname-src-miniquake2-game-ai-attack-sequences-ml-919901638"></a>
### fallbackPlan

```ml
function fallbackPlan(className)
```

Return the fallback plan value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `className` | `dynamic` | — | className value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/attack_sequences.ml#L1138)

<a id="function-function-miniquake2-game-ai-attack-sequences-flipperbiteplan-function-flipperbiteplan-src-miniquake2-game-ai-attack-sequences-ml-1872681507"></a>
### flipperBitePlan

```ml
function flipperBitePlan()
```

Return the flipper bite plan value.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/attack_sequences.ml#L599)

<a id="function-function-miniquake2-game-ai-attack-sequences-floaterblasterplan-function-floaterblasterplan-src-miniquake2-game-ai-attack-sequences-ml-784042413"></a>
### floaterBlasterPlan

```ml
function floaterBlasterPlan()
```

Return the floater blaster plan value.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/attack_sequences.ml#L676)

<a id="function-function-miniquake2-game-ai-attack-sequences-floaterplanwithroll-function-floaterplanwithroll-distance-roll-src-miniquake2-game-ai-attack-sequences-ml-1712142355"></a>
### floaterPlanWithRoll

```ml
function floaterPlanWithRoll(distance, roll)
```

Return the floater plan with roll value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `distance` | `dynamic` | — | distance value consumed by this operation. |
| `roll` | `dynamic` | — | roll value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/attack_sequences.ml#L1295)

<a id="function-function-miniquake2-game-ai-attack-sequences-floaterwhamplan-function-floaterwhamplan-src-miniquake2-game-ai-attack-sequences-ml-326981455"></a>
### floaterWhamPlan

```ml
function floaterWhamPlan()
```

Return the floater wham plan value.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/attack_sequences.ml#L548)

<a id="function-function-miniquake2-game-ai-attack-sequences-floaterzapplan-function-floaterzapplan-src-miniquake2-game-ai-attack-sequences-ml-1484909061"></a>
### floaterZapPlan

```ml
function floaterZapPlan()
```

Return the floater zap plan value.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/attack_sequences.ml#L554)

<a id="global-global-miniquake2-game-ai-attack-sequences-flyerblasterdistances-flyerblasterdistances-src-miniquake2-game-ai-attack-sequences-ml-1306921201"></a>
### flyerBlasterDistances

```ml
flyerBlasterDistances
```

Stores module-wide flyer blaster distances state for the miniquake2 game ai attack sequences module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/attack_sequences.ml#L83)

<a id="function-function-miniquake2-game-ai-attack-sequences-flyerblasterplan-function-flyerblasterplan-src-miniquake2-game-ai-attack-sequences-ml-215403161"></a>
### flyerBlasterPlan

```ml
function flyerBlasterPlan()
```

Return the flyer blaster plan value.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/attack_sequences.ml#L669)

<a id="function-function-miniquake2-game-ai-attack-sequences-flyermeleeplan-function-flyermeleeplan-src-miniquake2-game-ai-attack-sequences-ml-875997325"></a>
### flyerMeleePlan

```ml
function flyerMeleePlan()
```

Return the flyer melee plan value.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/attack_sequences.ml#L523)

<a id="function-function-miniquake2-game-ai-attack-sequences-flyermeleeplancycles-function-flyermeleeplancycles-cycles-src-miniquake2-game-ai-attack-sequences-ml-1781886886"></a>
### flyerMeleePlanCycles

```ml
function flyerMeleePlanCycles(cycles)
```

Return the flyer melee plan cycles value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `cycles` | `dynamic` | — | cycles value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/attack_sequences.ml#L505)

<a id="constant-constant-miniquake2-game-ai-attack-sequences-frame-time-const-frame-time-0-1-src-miniquake2-game-ai-attack-sequences-ml-1792638159"></a>
### FRAME_TIME

```ml
const FRAME_TIME = 0.1
```

Defines the frame time constant used by the miniquake2 game ai attack sequences module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/attack_sequences.ml#L14)

<a id="function-function-miniquake2-game-ai-attack-sequences-framesoundat-function-framesoundat-plan-timelineoffset-src-miniquake2-game-ai-attack-sequences-ml-2022625198"></a>
### frameSoundAt

```ml
function frameSoundAt(plan, timelineOffset)
```

Return the frame sound for the requested position.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `plan` | `dynamic` | — | plan value consumed by this operation. |
| `timelineOffset` | `dynamic` | — | timelineOffset value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/attack_sequences.ml#L243)

<a id="function-function-miniquake2-game-ai-attack-sequences-framesoundattenuationat-function-framesoundattenuationat-plan-timelineoffset-src-miniquake2-game-ai-attack-sequences-ml-1544420012"></a>
### frameSoundAttenuationAt

```ml
function frameSoundAttenuationAt(plan, timelineOffset)
```

Return the frame sound attenuation for the requested position.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `plan` | `dynamic` | — | plan value consumed by this operation. |
| `timelineOffset` | `dynamic` | — | timelineOffset value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/attack_sequences.ml#L313)

<a id="function-function-miniquake2-game-ai-attack-sequences-framesoundchannelat-function-framesoundchannelat-plan-timelineoffset-src-miniquake2-game-ai-attack-sequences-ml-210276098"></a>
### frameSoundChannelAt

```ml
function frameSoundChannelAt(plan, timelineOffset)
```

Return the frame sound channel for the requested position.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `plan` | `dynamic` | — | plan value consumed by this operation. |
| `timelineOffset` | `dynamic` | — | timelineOffset value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/attack_sequences.ml#L297)

<a id="function-function-miniquake2-game-ai-attack-sequences-gladiatormeleeplan-function-gladiatormeleeplan-src-miniquake2-game-ai-attack-sequences-ml-1111638681"></a>
### gladiatorMeleePlan

```ml
function gladiatorMeleePlan()
```

Return the gladiator melee plan value.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/attack_sequences.ml#L457)

<a id="function-function-miniquake2-game-ai-attack-sequences-gladiatorrailplan-function-gladiatorrailplan-src-miniquake2-game-ai-attack-sequences-ml-1380924269"></a>
### gladiatorRailPlan

```ml
function gladiatorRailPlan()
```

Return the gladiator rail plan value.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/attack_sequences.ml#L451)

<a id="function-function-miniquake2-game-ai-attack-sequences-gunnerchainplan-function-gunnerchainplan-actornumber-attackcount-src-miniquake2-game-ai-attack-sequences-ml-1344419964"></a>
### gunnerChainPlan

```ml
function gunnerChainPlan(actorNumber, attackCount)
```

Return the gunner chain plan value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actorNumber` | `dynamic` | — | actorNumber value consumed by this operation. |
| `attackCount` | `dynamic` | — | Number of attack to process. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/attack_sequences.ml#L440)

<a id="function-function-miniquake2-game-ai-attack-sequences-gunnerchainplancycles-function-gunnerchainplancycles-cycles-src-miniquake2-game-ai-attack-sequences-ml-382770206"></a>
### gunnerChainPlanCycles

```ml
function gunnerChainPlanCycles(cycles)
```

Return the gunner chain plan cycles value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `cycles` | `dynamic` | — | cycles value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/attack_sequences.ml#L418)

<a id="function-function-miniquake2-game-ai-attack-sequences-gunnergrenadeplan-function-gunnergrenadeplan-src-miniquake2-game-ai-attack-sequences-ml-906037493"></a>
### gunnerGrenadePlan

```ml
function gunnerGrenadePlan()
```

Return the gunner grenade plan value.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/attack_sequences.ml#L445)

<a id="function-function-miniquake2-game-ai-attack-sequences-gunnerplanwithroll-function-gunnerplanwithroll-actornumber-attackcount-distance-roll-src-miniquake2-game-ai-attack-sequences-ml-934993270"></a>
### gunnerPlanWithRoll

```ml
function gunnerPlanWithRoll(actorNumber, attackCount, distance, roll)
```

Return the gunner plan with roll value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actorNumber` | `dynamic` | — | actorNumber value consumed by this operation. |
| `attackCount` | `dynamic` | — | Number of attack to process. |
| `distance` | `dynamic` | — | distance value consumed by this operation. |
| `roll` | `dynamic` | — | roll value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/attack_sequences.ml#L1265)

<a id="function-function-miniquake2-game-ai-attack-sequences-hoverblasterplan-function-hoverblasterplan-actornumber-attackcount-src-miniquake2-game-ai-attack-sequences-ml-171212034"></a>
### hoverBlasterPlan

```ml
function hoverBlasterPlan(actorNumber, attackCount)
```

Return the hover blaster plan value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actorNumber` | `dynamic` | — | actorNumber value consumed by this operation. |
| `attackCount` | `dynamic` | — | Number of attack to process. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/attack_sequences.ml#L703)

<a id="function-function-miniquake2-game-ai-attack-sequences-hoverblasterplancycles-function-hoverblasterplancycles-cycles-src-miniquake2-game-ai-attack-sequences-ml-1417040838"></a>
### hoverBlasterPlanCycles

```ml
function hoverBlasterPlanCycles(cycles)
```

Return the hover blaster plan cycles value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `cycles` | `dynamic` | — | cycles value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/attack_sequences.ml#L683)

<a id="global-global-miniquake2-game-ai-attack-sequences-hovercycledistances-hovercycledistances-src-miniquake2-game-ai-attack-sequences-ml-1487001661"></a>
### hoverCycleDistances

```ml
hoverCycleDistances
```

Stores module-wide hover cycle distances state for the miniquake2 game ai attack sequences module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/attack_sequences.ml#L94)

<a id="global-global-miniquake2-game-ai-attack-sequences-hoverenddistances-hoverenddistances-src-miniquake2-game-ai-attack-sequences-ml-1475639305"></a>
### hoverEndDistances

```ml
hoverEndDistances
```

Stores module-wide hover end distances state for the miniquake2 game ai attack sequences module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/attack_sequences.ml#L96)

<a id="global-global-miniquake2-game-ai-attack-sequences-hoverstartdistances-hoverstartdistances-src-miniquake2-game-ai-attack-sequences-ml-1709467473"></a>
### hoverStartDistances

```ml
hoverStartDistances
```

Stores module-wide hover start distances state for the miniquake2 game ai attack sequences module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/attack_sequences.ml#L92)

<a id="global-global-miniquake2-game-ai-attack-sequences-infantrymachinegundistances-infantrymachinegundistances-src-miniquake2-game-ai-attack-sequences-ml-259065145"></a>
### infantryMachinegunDistances

```ml
infantryMachinegunDistances
```

Exact movement columns from the Quake II 3.19 mframe_t attack tables. Keep


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/attack_sequences.ml#L54)

<a id="function-function-miniquake2-game-ai-attack-sequences-infantrymeleeplan-function-infantrymeleeplan-src-miniquake2-game-ai-attack-sequences-ml-1945400641"></a>
### infantryMeleePlan

```ml
function infantryMeleePlan()
```

Return the infantry melee plan value.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/attack_sequences.ml#L475)

<a id="function-function-miniquake2-game-ai-attack-sequences-infantryplan-function-infantryplan-actornumber-attackcount-src-miniquake2-game-ai-attack-sequences-ml-974997450"></a>
### infantryPlan

```ml
function infantryPlan(actorNumber, attackCount)
```

Return the infantry plan value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actorNumber` | `dynamic` | — | actorNumber value consumed by this operation. |
| `attackCount` | `dynamic` | — | Number of attack to process. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/attack_sequences.ml#L410)

<a id="function-function-miniquake2-game-ai-attack-sequences-infantryplanshots-function-infantryplanshots-shotcount-src-miniquake2-game-ai-attack-sequences-ml-1455334964"></a>
### infantryPlanShots

```ml
function infantryPlanShots(shotCount)
```

Return the infantry plan shots value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `shotCount` | `dynamic` | — | Number of shot to process. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/attack_sequences.ml#L392)

<a id="global-global-miniquake2-game-ai-attack-sequences-infantrypunchdistances-infantrypunchdistances-src-miniquake2-game-ai-attack-sequences-ml-108547087"></a>
### infantryPunchDistances

```ml
infantryPunchDistances
```

Stores module-wide infantry punch distances state for the miniquake2 game ai attack sequences module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/attack_sequences.ml#L57)

<a id="function-function-miniquake2-game-ai-attack-sequences-jorgbfgplan-function-jorgbfgplan-src-miniquake2-game-ai-attack-sequences-ml-1680693645"></a>
### jorgBfgPlan

```ml
function jorgBfgPlan()
```

Return the jorg bfg plan value.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/attack_sequences.ml#L1066)

<a id="function-function-miniquake2-game-ai-attack-sequences-jorgplan-function-jorgplan-actornumber-attackcount-src-miniquake2-game-ai-attack-sequences-ml-1706979558"></a>
### jorgPlan

```ml
function jorgPlan(actorNumber, attackCount)
```

Return the jorg plan value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actorNumber` | `dynamic` | — | actorNumber value consumed by this operation. |
| `attackCount` | `dynamic` | — | Number of attack to process. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/attack_sequences.ml#L1059)

<a id="function-function-miniquake2-game-ai-attack-sequences-jorgplancycles-function-jorgplancycles-cycles-src-miniquake2-game-ai-attack-sequences-ml-72050354"></a>
### jorgPlanCycles

```ml
function jorgPlanCycles(cycles)
```

Return the jorg plan cycles value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `cycles` | `dynamic` | — | cycles value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/attack_sequences.ml#L1034)

<a id="function-function-miniquake2-game-ai-attack-sequences-jorgplanwithroll-function-jorgplanwithroll-actornumber-attackcount-roll-src-miniquake2-game-ai-attack-sequences-ml-1839621509"></a>
### jorgPlanWithRoll

```ml
function jorgPlanWithRoll(actorNumber, attackCount, roll)
```

Return the jorg plan with roll value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actorNumber` | `dynamic` | — | actorNumber value consumed by this operation. |
| `attackCount` | `dynamic` | — | Number of attack to process. |
| `roll` | `dynamic` | — | roll value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/attack_sequences.ml#L1315)

<a id="function-function-miniquake2-game-ai-attack-sequences-makronbfgplan-function-makronbfgplan-src-miniquake2-game-ai-attack-sequences-ml-754887981"></a>
### makronBfgPlan

```ml
function makronBfgPlan()
```

Return the makron bfg plan value.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/attack_sequences.ml#L1111)

<a id="function-function-miniquake2-game-ai-attack-sequences-makronhyperblasterplan-function-makronhyperblasterplan-src-miniquake2-game-ai-attack-sequences-ml-102381357"></a>
### makronHyperblasterPlan

```ml
function makronHyperblasterPlan()
```

Return the makron hyperblaster plan value.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/attack_sequences.ml#L1117)

<a id="function-function-miniquake2-game-ai-attack-sequences-makronplanwithroll-function-makronplanwithroll-roll-src-miniquake2-game-ai-attack-sequences-ml-550548510"></a>
### makronPlanWithRoll

```ml
function makronPlanWithRoll(roll)
```

Return the makron plan with roll value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `roll` | `dynamic` | — | roll value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/attack_sequences.ml#L1332)

<a id="function-function-miniquake2-game-ai-attack-sequences-makronrailplan-function-makronrailplan-src-miniquake2-game-ai-attack-sequences-ml-1322602589"></a>
### makronRailPlan

```ml
function makronRailPlan()
```

Return the makron rail plan value.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/attack_sequences.ml#L1131)

<a id="global-global-miniquake2-game-ai-attack-sequences-medicblasterdistances-medicblasterdistances-src-miniquake2-game-ai-attack-sequences-ml-1335831389"></a>
### medicBlasterDistances

```ml
medicBlasterDistances
```

Stores module-wide medic blaster distances state for the miniquake2 game ai attack sequences module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/attack_sequences.ml#L62)

<a id="function-function-miniquake2-game-ai-attack-sequences-medicblasterplan-function-medicblasterplan-actornumber-attackcount-src-miniquake2-game-ai-attack-sequences-ml-1373418338"></a>
### medicBlasterPlan

```ml
function medicBlasterPlan(actorNumber, attackCount)
```

Return the medic blaster plan value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actorNumber` | `dynamic` | — | actorNumber value consumed by this operation. |
| `attackCount` | `dynamic` | — | Number of attack to process. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/attack_sequences.ml#L632)

<a id="function-function-miniquake2-game-ai-attack-sequences-medicblasterplancontinue-function-medicblasterplancontinue-includehyper-src-miniquake2-game-ai-attack-sequences-ml-680409799"></a>
### medicBlasterPlanContinue

```ml
function medicBlasterPlanContinue(includeHyper)
```

Return the medic blaster plan continue value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `includeHyper` | `dynamic` | — | includeHyper value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/attack_sequences.ml#L606)

<a id="global-global-miniquake2-game-ai-attack-sequences-mediccabledistances-mediccabledistances-src-miniquake2-game-ai-attack-sequences-ml-1997173849"></a>
### medicCableDistances

```ml
medicCableDistances
```

Stores module-wide medic cable distances state for the miniquake2 game ai attack sequences module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/attack_sequences.ml#L65)

<a id="function-function-miniquake2-game-ai-attack-sequences-mediccableplan-function-mediccableplan-src-miniquake2-game-ai-attack-sequences-ml-866390921"></a>
### medicCablePlan

```ml
function medicCablePlan()
```

Return the medic cable plan value.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/attack_sequences.ml#L637)

<a id="function-function-miniquake2-game-ai-attack-sequences-modelframeat-function-modelframeat-plan-timelineoffset-src-miniquake2-game-ai-attack-sequences-ml-1471523578"></a>
### modelFrameAt

```ml
function modelFrameAt(plan, timelineOffset)
```

Performs the modelFrameAt operation for the miniquake2 game ai attack sequences module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `plan` | `dynamic` | — | plan value consumed by this operation. |
| `timelineOffset` | `dynamic` | — | timelineOffset value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/attack_sequences.ml#L1510)

- [miniquake2.game.ai.attack_sequences.MonsterAttackPlan](Type-miniquake2-game-ai-attack-sequences-monsterattackplan-664622837.md) — struct
<a id="function-function-miniquake2-game-ai-attack-sequences-movementaiat-function-movementaiat-plan-timelineoffset-src-miniquake2-game-ai-attack-sequences-ml-1416865234"></a>
### movementAiAt

```ml
function movementAiAt(plan, timelineOffset)
```

Return the movement ai for the requested position.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `plan` | `dynamic` | — | plan value consumed by this operation. |
| `timelineOffset` | `dynamic` | — | timelineOffset value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/attack_sequences.ml#L211)

<a id="function-function-miniquake2-game-ai-attack-sequences-movementdistanceat-function-movementdistanceat-plan-timelineoffset-src-miniquake2-game-ai-attack-sequences-ml-113404974"></a>
### movementDistanceAt

```ml
function movementDistanceAt(plan, timelineOffset)
```

Return the movement distance for the requested position.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `plan` | `dynamic` | — | plan value consumed by this operation. |
| `timelineOffset` | `dynamic` | — | timelineOffset value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/attack_sequences.ml#L129)

<a id="global-global-miniquake2-game-ai-attack-sequences-mutantjumpdistances-mutantjumpdistances-src-miniquake2-game-ai-attack-sequences-ml-580837173"></a>
### mutantJumpDistances

```ml
mutantJumpDistances
```

Stores module-wide mutant jump distances state for the miniquake2 game ai attack sequences module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/attack_sequences.ml#L98)

<a id="function-function-miniquake2-game-ai-attack-sequences-mutantjumpplan-function-mutantjumpplan-src-miniquake2-game-ai-attack-sequences-ml-430450429"></a>
### mutantJumpPlan

```ml
function mutantJumpPlan()
```

Return the mutant jump plan value.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/attack_sequences.ml#L584)

<a id="function-function-miniquake2-game-ai-attack-sequences-mutantmeleeplan-function-mutantmeleeplan-src-miniquake2-game-ai-attack-sequences-ml-2109743197"></a>
### mutantMeleePlan

```ml
function mutantMeleePlan()
```

Return the mutant melee plan value.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/attack_sequences.ml#L579)

<a id="function-function-miniquake2-game-ai-attack-sequences-mutantmeleeplancycles-function-mutantmeleeplancycles-cycles-src-miniquake2-game-ai-attack-sequences-ml-1802216160"></a>
### mutantMeleePlanCycles

```ml
function mutantMeleePlanCycles(cycles)
```

Return the mutant melee plan cycles value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `cycles` | `dynamic` | — | cycles value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/attack_sequences.ml#L561)

<a id="global-global-miniquake2-game-ai-attack-sequences-parasitedraindistances-parasitedraindistances-src-miniquake2-game-ai-attack-sequences-ml-1093891771"></a>
### parasiteDrainDistances

```ml
parasiteDrainDistances
```

Stores module-wide parasite drain distances state for the miniquake2 game ai attack sequences module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/attack_sequences.ml#L100)

<a id="function-function-miniquake2-game-ai-attack-sequences-parasitedrainplan-function-parasitedrainplan-src-miniquake2-game-ai-attack-sequences-ml-318632125"></a>
### parasiteDrainPlan

```ml
function parasiteDrainPlan()
```

Drain parasite plan.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/attack_sequences.ml#L592)

<a id="function-function-miniquake2-game-ai-attack-sequences-planbyname-function-planbyname-classname-name-actornumber-attackcount-src-miniquake2-game-ai-attack-sequences-ml-216603754"></a>
### planByName

```ml
function planByName(className, name, actorNumber, attackCount)
```

Return the plan by name.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `className` | `dynamic` | — | className value consumed by this operation. |
| `name` | `dynamic` | — | Name of the affected item. |
| `actorNumber` | `dynamic` | — | actorNumber value consumed by this operation. |
| `attackCount` | `dynamic` | — | Number of attack to process. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/attack_sequences.ml#L1343)

<a id="function-function-miniquake2-game-ai-attack-sequences-planbynamecycles-function-planbynamecycles-classname-name-actornumber-attackcount-cycles-src-miniquake2-game-ai-attack-sequences-ml-16449889"></a>
### planByNameCycles

```ml
function planByNameCycles(className, name, actorNumber, attackCount, cycles)
```

Return the plan by name cycles value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `className` | `dynamic` | — | className value consumed by this operation. |
| `name` | `dynamic` | — | Name of the affected item. |
| `actorNumber` | `dynamic` | — | actorNumber value consumed by this operation. |
| `attackCount` | `dynamic` | — | Number of attack to process. |
| `cycles` | `dynamic` | — | cycles value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/attack_sequences.ml#L1412)

<a id="function-function-miniquake2-game-ai-attack-sequences-repeatedcyclecount-function-repeatedcyclecount-actornumber-attackcount-salt-chancepercent-maximumcycles-src-miniquake2-game-ai-attack-sequences-ml-382576060"></a>
### repeatedCycleCount

```ml
function repeatedCycleCount(actorNumber, attackCount, salt, chancePercent, maximumCycles)
```

Return the repeated cycle count.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actorNumber` | `dynamic` | — | actorNumber value consumed by this operation. |
| `attackCount` | `dynamic` | — | Number of attack to process. |
| `salt` | `dynamic` | — | salt value consumed by this operation. |
| `chancePercent` | `dynamic` | — | chancePercent value consumed by this operation. |
| `maximumCycles` | `dynamic` | — | maximumCycles value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/attack_sequences.ml#L382)

<a id="function-function-miniquake2-game-ai-attack-sequences-selectionrandomkind-function-selectionrandomkind-classname-distance-src-miniquake2-game-ai-attack-sequences-ml-848314459"></a>
### selectionRandomKind

```ml
function selectionRandomKind(className, distance)
```

Return the selection random kind value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `className` | `dynamic` | — | className value consumed by this operation. |
| `distance` | `dynamic` | — | distance value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/attack_sequences.ml#L1233)

<a id="function-function-miniquake2-game-ai-attack-sequences-selectplan-function-selectplan-classname-actornumber-attackcount-distance-skill-src-miniquake2-game-ai-attack-sequences-ml-1430569465"></a>
### selectPlan

```ml
function selectPlan(className, actorNumber, attackCount, distance, skill)
```

Select plan.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `className` | `dynamic` | — | className value consumed by this operation. |
| `actorNumber` | `dynamic` | — | actorNumber value consumed by this operation. |
| `attackCount` | `dynamic` | — | Number of attack to process. |
| `distance` | `dynamic` | — | distance value consumed by this operation. |
| `skill` | `dynamic` | — | skill value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/attack_sequences.ml#L1157)

<a id="function-function-miniquake2-game-ai-attack-sequences-soldierattackflash-function-soldierattackflash-classname-flashnumber-src-miniquake2-game-ai-attack-sequences-ml-1517786415"></a>
### soldierAttackFlash

```ml
function soldierAttackFlash(className, flashNumber)
```

Run soldier flash.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `className` | `dynamic` | — | className value consumed by this operation. |
| `flashNumber` | `dynamic` | — | flashNumber value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/attack_sequences.ml#L958)

<a id="function-function-miniquake2-game-ai-attack-sequences-soldierdodgeusesattack-inline-function-soldierdodgeusesattack-skill-roll-src-miniquake2-game-ai-attack-sequences-ml-26165092"></a>
### soldierDodgeUsesAttack

```ml
inline function soldierDodgeUsesAttack(skill, roll)
```

Run soldier dodge uses.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `skill` | `dynamic` | — | skill value consumed by this operation. |
| `roll` | `dynamic` | — | roll value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/attack_sequences.ml#L1017)

<a id="function-function-miniquake2-game-ai-attack-sequences-soldierduckshootplan-function-soldierduckshootplan-classname-src-miniquake2-game-ai-attack-sequences-ml-1873364546"></a>
### soldierDuckShootPlan

```ml
function soldierDuckShootPlan(className)
```

Return the soldier duck shoot plan value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `className` | `dynamic` | — | className value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/attack_sequences.ml#L990)

<a id="function-function-miniquake2-game-ai-attack-sequences-soldierlightplancycles-function-soldierlightplancycles-classname-secondattack-cycles-src-miniquake2-game-ai-attack-sequences-ml-34684829"></a>
### soldierLightPlanCycles

```ml
function soldierLightPlanCycles(className, secondAttack, cycles)
```

Return the soldier light plan cycles value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `className` | `dynamic` | — | className value consumed by this operation. |
| `secondAttack` | `dynamic` | — | secondAttack value consumed by this operation. |
| `cycles` | `dynamic` | — | cycles value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/attack_sequences.ml#L865)

<a id="function-function-miniquake2-game-ai-attack-sequences-soldiermachinegunplanshots-function-soldiermachinegunplanshots-classname-shotcount-src-miniquake2-game-ai-attack-sequences-ml-1890069175"></a>
### soldierMachinegunPlanShots

```ml
function soldierMachinegunPlanShots(className, shotCount)
```

Return the soldier machinegun plan shots value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `className` | `dynamic` | — | className value consumed by this operation. |
| `shotCount` | `dynamic` | — | Number of shot to process. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/attack_sequences.ml#L938)

<a id="function-function-miniquake2-game-ai-attack-sequences-soldierplan-function-soldierplan-classname-actornumber-attackcount-src-miniquake2-game-ai-attack-sequences-ml-169727383"></a>
### soldierPlan

```ml
function soldierPlan(className, actorNumber, attackCount)
```

Return the soldier plan value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `className` | `dynamic` | — | className value consumed by this operation. |
| `actorNumber` | `dynamic` | — | actorNumber value consumed by this operation. |
| `attackCount` | `dynamic` | — | Number of attack to process. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/attack_sequences.ml#L1027)

<a id="function-function-miniquake2-game-ai-attack-sequences-soldierplanvariant-function-soldierplanvariant-classname-actornumber-attackcount-secondattack-src-miniquake2-game-ai-attack-sequences-ml-1842337937"></a>
### soldierPlanVariant

```ml
function soldierPlanVariant(className, actorNumber, attackCount, secondAttack)
```

Return the soldier plan variant value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `className` | `dynamic` | — | className value consumed by this operation. |
| `actorNumber` | `dynamic` | — | actorNumber value consumed by this operation. |
| `attackCount` | `dynamic` | — | Number of attack to process. |
| `secondAttack` | `dynamic` | — | secondAttack value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/attack_sequences.ml#L924)

<a id="function-function-miniquake2-game-ai-attack-sequences-soldierplanwithroll-function-soldierplanwithroll-classname-actornumber-attackcount-roll-src-miniquake2-game-ai-attack-sequences-ml-613834698"></a>
### soldierPlanWithRoll

```ml
function soldierPlanWithRoll(className, actorNumber, attackCount, roll)
```

Return the soldier plan with roll value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `className` | `dynamic` | — | className value consumed by this operation. |
| `actorNumber` | `dynamic` | — | actorNumber value consumed by this operation. |
| `attackCount` | `dynamic` | — | Number of attack to process. |
| `roll` | `dynamic` | — | roll value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/attack_sequences.ml#L1275)

<a id="global-global-miniquake2-game-ai-attack-sequences-soldierrunshootdistances-soldierrunshootdistances-src-miniquake2-game-ai-attack-sequences-ml-490709965"></a>
### soldierRunShootDistances

```ml
soldierRunShootDistances
```

Stores module-wide soldier run shoot distances state for the miniquake2 game ai attack sequences module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/attack_sequences.ml#L59)

<a id="function-function-miniquake2-game-ai-attack-sequences-soldierrunshootplancycles-function-soldierrunshootplancycles-classname-cycles-src-miniquake2-game-ai-attack-sequences-ml-653417665"></a>
### soldierRunShootPlanCycles

```ml
function soldierRunShootPlanCycles(className, cycles)
```

Run soldier shoot plan cycles.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `className` | `dynamic` | — | className value consumed by this operation. |
| `cycles` | `dynamic` | — | cycles value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/attack_sequences.ml#L999)

<a id="function-function-miniquake2-game-ai-attack-sequences-soldiershotgunplancycles-function-soldiershotgunplancycles-classname-secondattack-cycles-src-miniquake2-game-ai-attack-sequences-ml-387630581"></a>
### soldierShotgunPlanCycles

```ml
function soldierShotgunPlanCycles(className, secondAttack, cycles)
```

Return the soldier shotgun plan cycles value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `className` | `dynamic` | — | className value consumed by this operation. |
| `secondAttack` | `dynamic` | — | secondAttack value consumed by this operation. |
| `cycles` | `dynamic` | — | cycles value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/attack_sequences.ml#L893)

<a id="function-function-miniquake2-game-ai-attack-sequences-soldierspecialplan-function-soldierspecialplan-classname-name-offsets-flashes-duration-src-miniquake2-game-ai-attack-sequences-ml-669249095"></a>
### soldierSpecialPlan

```ml
function soldierSpecialPlan(className, name, offsets, flashes, duration)
```

Return the soldier special plan value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `className` | `dynamic` | — | className value consumed by this operation. |
| `name` | `dynamic` | — | Name of the affected item. |
| `offsets` | `dynamic` | — | offsets value consumed by this operation. |
| `flashes` | `dynamic` | — | flashes value consumed by this operation. |
| `duration` | `dynamic` | — | duration value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/attack_sequences.ml#L975)

<a id="function-function-miniquake2-game-ai-attack-sequences-supertankmachinegunplan-function-supertankmachinegunplan-actornumber-attackcount-src-miniquake2-game-ai-attack-sequences-ml-177161972"></a>
### supertankMachinegunPlan

```ml
function supertankMachinegunPlan(actorNumber, attackCount)
```

Return the supertank machinegun plan value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actorNumber` | `dynamic` | — | actorNumber value consumed by this operation. |
| `attackCount` | `dynamic` | — | Number of attack to process. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/attack_sequences.ml#L731)

<a id="function-function-miniquake2-game-ai-attack-sequences-supertankmachinegunplancycles-function-supertankmachinegunplancycles-cycles-src-miniquake2-game-ai-attack-sequences-ml-1143269830"></a>
### supertankMachinegunPlanCycles

```ml
function supertankMachinegunPlanCycles(cycles)
```

Return the supertank machinegun plan cycles value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `cycles` | `dynamic` | — | cycles value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/attack_sequences.ml#L709)

<a id="function-function-miniquake2-game-ai-attack-sequences-supertankplanwithroll-function-supertankplanwithroll-actornumber-attackcount-distance-roll-src-miniquake2-game-ai-attack-sequences-ml-1868378992"></a>
### supertankPlanWithRoll

```ml
function supertankPlanWithRoll(actorNumber, attackCount, distance, roll)
```

Return the supertank plan with roll value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actorNumber` | `dynamic` | — | actorNumber value consumed by this operation. |
| `attackCount` | `dynamic` | — | Number of attack to process. |
| `distance` | `dynamic` | — | distance value consumed by this operation. |
| `roll` | `dynamic` | — | roll value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/attack_sequences.ml#L1306)

<a id="function-function-miniquake2-game-ai-attack-sequences-supertankrocketplan-function-supertankrocketplan-src-miniquake2-game-ai-attack-sequences-ml-1137325857"></a>
### supertankRocketPlan

```ml
function supertankRocketPlan()
```

Return the supertank rocket plan value.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/attack_sequences.ml#L736)

<a id="global-global-miniquake2-game-ai-attack-sequences-tankblasterdistances-tankblasterdistances-src-miniquake2-game-ai-attack-sequences-ml-1622561627"></a>
### tankBlasterDistances

```ml
tankBlasterDistances
```

Stores module-wide tank blaster distances state for the miniquake2 game ai attack sequences module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/attack_sequences.ml#L103)

<a id="function-function-miniquake2-game-ai-attack-sequences-tankblasterplan-function-tankblasterplan-classname-actornumber-attackcount-skill-src-miniquake2-game-ai-attack-sequences-ml-939212968"></a>
### tankBlasterPlan

```ml
function tankBlasterPlan(className, actorNumber, attackCount, skill)
```

Return the tank blaster plan value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `className` | `dynamic` | — | className value consumed by this operation. |
| `actorNumber` | `dynamic` | — | actorNumber value consumed by this operation. |
| `attackCount` | `dynamic` | — | Number of attack to process. |
| `skill` | `dynamic` | — | skill value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/attack_sequences.ml#L787)

<a id="function-function-miniquake2-game-ai-attack-sequences-tankblasterplancycles-function-tankblasterplancycles-classname-cycles-allowrefire-src-miniquake2-game-ai-attack-sequences-ml-1160474043"></a>
### tankBlasterPlanCycles

```ml
function tankBlasterPlanCycles(className, cycles, allowRefire)
```

Return the tank blaster plan cycles value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `className` | `dynamic` | — | className value consumed by this operation. |
| `cycles` | `dynamic` | — | cycles value consumed by this operation. |
| `allowRefire` | `dynamic` | — | allowRefire value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/attack_sequences.ml#L760)

<a id="global-global-miniquake2-game-ai-attack-sequences-tankblasterpostdistances-tankblasterpostdistances-src-miniquake2-game-ai-attack-sequences-ml-775024363"></a>
### tankBlasterPostDistances

```ml
tankBlasterPostDistances
```

Stores module-wide tank blaster post distances state for the miniquake2 game ai attack sequences module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/attack_sequences.ml#L106)

<a id="function-function-miniquake2-game-ai-attack-sequences-tankmachinegunplan-function-tankmachinegunplan-classname-src-miniquake2-game-ai-attack-sequences-ml-208946154"></a>
### tankMachinegunPlan

```ml
function tankMachinegunPlan(className)
```

Return the tank machinegun plan value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `className` | `dynamic` | — | className value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/attack_sequences.ml#L743)

<a id="function-function-miniquake2-game-ai-attack-sequences-tankplan-function-tankplan-classname-actornumber-attackcount-distance-skill-src-miniquake2-game-ai-attack-sequences-ml-1478712005"></a>
### tankPlan

```ml
function tankPlan(className, actorNumber, attackCount, distance, skill)
```

Return the tank plan value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `className` | `dynamic` | — | className value consumed by this operation. |
| `actorNumber` | `dynamic` | — | actorNumber value consumed by this operation. |
| `attackCount` | `dynamic` | — | Number of attack to process. |
| `distance` | `dynamic` | — | distance value consumed by this operation. |
| `skill` | `dynamic` | — | skill value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/attack_sequences.ml#L856)

<a id="function-function-miniquake2-game-ai-attack-sequences-tankplanwithroll-function-tankplanwithroll-classname-actornumber-attackcount-distance-skill-roll-src-miniquake2-game-ai-attack-sequences-ml-1986841310"></a>
### tankPlanWithRoll

```ml
function tankPlanWithRoll(className, actorNumber, attackCount, distance, skill, roll)
```

Return the tank plan with roll value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `className` | `dynamic` | — | className value consumed by this operation. |
| `actorNumber` | `dynamic` | — | actorNumber value consumed by this operation. |
| `attackCount` | `dynamic` | — | Number of attack to process. |
| `distance` | `dynamic` | — | distance value consumed by this operation. |
| `skill` | `dynamic` | — | skill value consumed by this operation. |
| `roll` | `dynamic` | — | roll value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/attack_sequences.ml#L836)

<a id="global-global-miniquake2-game-ai-attack-sequences-tankrocketcycledistances-tankrocketcycledistances-src-miniquake2-game-ai-attack-sequences-ml-1040159341"></a>
### tankRocketCycleDistances

```ml
tankRocketCycleDistances
```

Stores module-wide tank rocket cycle distances state for the miniquake2 game ai attack sequences module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/attack_sequences.ml#L111)

<a id="function-function-miniquake2-game-ai-attack-sequences-tankrocketplan-function-tankrocketplan-classname-actornumber-attackcount-skill-src-miniquake2-game-ai-attack-sequences-ml-582337928"></a>
### tankRocketPlan

```ml
function tankRocketPlan(className, actorNumber, attackCount, skill)
```

Return the tank rocket plan value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `className` | `dynamic` | — | className value consumed by this operation. |
| `actorNumber` | `dynamic` | — | actorNumber value consumed by this operation. |
| `attackCount` | `dynamic` | — | Number of attack to process. |
| `skill` | `dynamic` | — | skill value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/attack_sequences.ml#L823)

<a id="function-function-miniquake2-game-ai-attack-sequences-tankrocketplancycles-function-tankrocketplancycles-classname-cycles-allowrefire-src-miniquake2-game-ai-attack-sequences-ml-1665855713"></a>
### tankRocketPlanCycles

```ml
function tankRocketPlanCycles(className, cycles, allowRefire)
```

Return the tank rocket plan cycles value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `className` | `dynamic` | — | className value consumed by this operation. |
| `cycles` | `dynamic` | — | cycles value consumed by this operation. |
| `allowRefire` | `dynamic` | — | allowRefire value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/attack_sequences.ml#L797)

<a id="global-global-miniquake2-game-ai-attack-sequences-tankrocketpostdistances-tankrocketpostdistances-src-miniquake2-game-ai-attack-sequences-ml-1792370065"></a>
### tankRocketPostDistances

```ml
tankRocketPostDistances
```

Stores module-wide tank rocket post distances state for the miniquake2 game ai attack sequences module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/attack_sequences.ml#L113)

<a id="global-global-miniquake2-game-ai-attack-sequences-tankrocketpredistances-tankrocketpredistances-src-miniquake2-game-ai-attack-sequences-ml-935949979"></a>
### tankRocketPreDistances

```ml
tankRocketPreDistances
```

Stores module-wide tank rocket pre distances state for the miniquake2 game ai attack sequences module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/attack_sequences.ml#L108)

<a id="function-function-miniquake2-game-ai-attack-sequences-validateplan-function-validateplan-plan-src-miniquake2-game-ai-attack-sequences-ml-1049000866"></a>
### validatePlan

```ml
function validatePlan(plan)
```

Validates plan for the miniquake2 game ai attack sequences workflow.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `plan` | `dynamic` | — | plan value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/attack_sequences.ml#L1681)
