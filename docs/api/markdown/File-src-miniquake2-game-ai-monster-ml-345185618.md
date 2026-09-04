# `src/miniquake2/game/ai/monster.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 game ai monster facilities for this project.

Package: [`miniquake2.game.ai.monster`](Package-miniquake2-game-ai-monster-1197295087.md)

Reachable from entry: **yes**

## Imports

- `miniquake2/game/ai/actor.ml` as `gaiactor` → [src/miniquake2/game/ai/actor.ml](File-src-miniquake2-game-ai-actor-ml-1670505135.md)
- `miniquake2/game/ai/constants.ml` as `gaiconstants` → [src/miniquake2/game/ai/constants.ml](File-src-miniquake2-game-ai-constants-ml-2069864859.md)
- `miniquake2/game/ai/core.ml` as `gaicore` → [src/miniquake2/game/ai/core.ml](File-src-miniquake2-game-ai-core-ml-1671967255.md)
- `miniquake2/game/ai/death_effects.ml` as `gaideatheffects` → [src/miniquake2/game/ai/death_effects.ml](File-src-miniquake2-game-ai-death-effects-ml-1353580965.md)
- `miniquake2/game/ai/locomotion_sequences.ml` as `gailocomotion` → [src/miniquake2/game/ai/locomotion_sequences.ml](File-src-miniquake2-game-ai-locomotion-sequences-ml-762644798.md)
- `miniquake2/game/ai/move.ml` as `gaimove` → [src/miniquake2/game/ai/move.ml](File-src-miniquake2-game-ai-move-ml-1485609585.md)
- `miniquake2/game/ai/props.ml` as `gaimonsterprops` → [src/miniquake2/game/ai/props.ml](File-src-miniquake2-game-ai-props-ml-91813726.md)
- `miniquake2/game/ai/reaction_sequences.ml` as `gaireactions` → [src/miniquake2/game/ai/reaction_sequences.ml](File-src-miniquake2-game-ai-reaction-sequences-ml-721161120.md)
- `miniquake2/game/ai/sounds.ml` as `gaisounds` → [src/miniquake2/game/ai/sounds.ml](File-src-miniquake2-game-ai-sounds-ml-1375480234.md)
- `miniquake2/game/constants.ml` as `gconstants` → [src/miniquake2/game/constants.ml](File-src-miniquake2-game-constants-ml-1723282332.md)
- `miniquake2/qcommon/constants.ml` as `qconstants` → [src/miniquake2/qcommon/constants.ml](File-src-miniquake2-qcommon-constants-ml-1976195726.md)
- `miniquake2/qcommon/types.ml` as `gaiqtypes` → [src/miniquake2/qcommon/types.ml](File-src-miniquake2-qcommon-types-ml-1663266398.md)
- `std/math.ml` as `gaimath` → `../MiniLangCompilerML/std/math.ml` — external dependency

## Declarations

<a id="function-function-miniquake2-game-ai-monster-advancebossexplosion-function-advancebossexplosion-actor-context-src-miniquake2-game-ai-monster-ml-1532093701"></a>
### AdvanceBossExplosion

```ml
function AdvanceBossExplosion(actor, context)
```

Advance boss explosion.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/monster.ml#L953)

<a id="function-function-miniquake2-game-ai-monster-advancereaction-function-advancereaction-actor-plan-context-src-miniquake2-game-ai-monster-ml-299519612"></a>
### AdvanceReaction

```ml
function AdvanceReaction(actor, plan, context)
```

Advance reaction.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `plan` | `dynamic` | — | plan value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/monster.ml#L991)

<a id="function-function-miniquake2-game-ai-monster-applyworlddamage-function-applyworlddamage-actor-amount-damageflags-meansofdeath-context-src-miniquake2-game-ai-monster-ml-2061660446"></a>
### ApplyWorldDamage

```ml
function ApplyWorldDamage(actor, amount, damageFlags, meansOfDeath, context)
```

Apply world damage.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `amount` | `dynamic` | — | amount value consumed by this operation. |
| `damageFlags` | `dynamic` | — | damageFlags value consumed by this operation. |
| `meansOfDeath` | `dynamic` | — | meansOfDeath value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/monster.ml#L675)

<a id="function-function-miniquake2-game-ai-monster-beginbossexplosion-function-beginbossexplosion-actor-context-src-miniquake2-game-ai-monster-ml-541950645"></a>
### BeginBossExplosion

```ml
function BeginBossExplosion(actor, context)
```

Begin boss explosion.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/monster.ml#L978)

<a id="function-function-miniquake2-game-ai-monster-claimmedicpatient-function-claimmedicpatient-actor-patient-preserveenemy-context-src-miniquake2-game-ai-monster-ml-1515857752"></a>
### ClaimMedicPatient

```ml
function ClaimMedicPatient(actor, patient, preserveEnemy, context)
```

Return the claim medic patient value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `patient` | `dynamic` | — | patient value consumed by this operation. |
| `preserveEnemy` | `dynamic` | — | preserveEnemy value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/monster.ml#L296)

<a id="function-function-miniquake2-game-ai-monster-configurestockmovecallbacks-function-configurestockmovecallbacks-actor-move-src-miniquake2-game-ai-monster-ml-1267781681"></a>
### ConfigureStockMoveCallbacks

```ml
function ConfigureStockMoveCallbacks(actor, move)
```

Configure stock move callbacks.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `move` | `dynamic` | — | move value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/monster.ml#L200)

<a id="function-function-miniquake2-game-ai-monster-continuebossdeath-function-continuebossdeath-actor-context-src-miniquake2-game-ai-monster-ml-1879247333"></a>
### ContinueBossDeath

```ml
function ContinueBossDeath(actor, context)
```

Return the continue boss death value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/monster.ml#L821)

<a id="function-function-miniquake2-game-ai-monster-currentmovename-function-currentmovename-actor-src-miniquake2-game-ai-monster-ml-1191101522"></a>
### CurrentMoveName

```ml
function CurrentMoveName(actor)
```

Move current name.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/monster.ml#L26)

<a id="function-function-miniquake2-game-ai-monster-defaultcheckattack-function-defaultcheckattack-actor-context-enemyrange-src-miniquake2-game-ai-monster-ml-1533778498"></a>
### DefaultCheckAttack

```ml
function DefaultCheckAttack(actor, context, enemyRange)
```

Validate default attack.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |
| `enemyRange` | `dynamic` | — | enemyRange value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/monster.ml#L558)

<a id="function-function-miniquake2-game-ai-monster-dispatchdie-function-dispatchdie-actor-attacker-damage-context-src-miniquake2-game-ai-monster-ml-1561565391"></a>
### DispatchDie

```ml
function DispatchDie(actor, attacker, damage, context)
```

Dispatch die.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `attacker` | `dynamic` | — | attacker value consumed by this operation. |
| `damage` | `dynamic` | — | damage value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/monster.ml#L1367)

<a id="function-function-miniquake2-game-ai-monster-dispatchpain-function-dispatchpain-actor-attacker-damage-context-src-miniquake2-game-ai-monster-ml-1604563759"></a>
### DispatchPain

```ml
function DispatchPain(actor, attacker, damage, context)
```

Dispatch pain.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `attacker` | `dynamic` | — | attacker value consumed by this operation. |
| `damage` | `dynamic` | — | damage value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/monster.ml#L1341)

<a id="function-function-miniquake2-game-ai-monster-emitstocksound-function-emitstocksound-actor-context-soundname-channel-attenuation-src-miniquake2-game-ai-monster-ml-1307082964"></a>
### EmitStockSound

```ml
function EmitStockSound(actor, context, soundName, channel, attenuation)
```

Emit stock sound.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |
| `soundName` | `dynamic` | — | soundName value consumed by this operation. |
| `channel` | `dynamic` | — | channel value consumed by this operation. |
| `attenuation` | `dynamic` | — | attenuation value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/monster.ml#L37)

<a id="function-function-miniquake2-game-ai-monster-findmedicpatient-function-findmedicpatient-actor-preserveenemy-context-src-miniquake2-game-ai-monster-ml-634600865"></a>
### FindMedicPatient

```ml
function FindMedicPatient(actor, preserveEnemy, context)
```

Find medic patient.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `preserveEnemy` | `dynamic` | — | preserveEnemy value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/monster.ml#L310)

<a id="function-function-miniquake2-game-ai-monster-finishflipperruntransition-function-finishflipperruntransition-actor-context-src-miniquake2-game-ai-monster-ml-616288853"></a>
### FinishFlipperRunTransition

```ml
function FinishFlipperRunTransition(actor, context)
```

Finish flipper run transition.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/monster.ml#L334)

<a id="function-function-miniquake2-game-ai-monster-finishparasitefidgetloop-function-finishparasitefidgetloop-actor-context-src-miniquake2-game-ai-monster-ml-316167321"></a>
### FinishParasiteFidgetLoop

```ml
function FinishParasiteFidgetLoop(actor, context)
```

Finish parasite fidget loop.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/monster.ml#L350)

<a id="function-function-miniquake2-game-ai-monster-finishparasitefidgetstart-function-finishparasitefidgetstart-actor-context-src-miniquake2-game-ai-monster-ml-1387325563"></a>
### FinishParasiteFidgetStart

```ml
function FinishParasiteFidgetStart(actor, context)
```

Finish parasite fidget start.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/monster.ml#L342)

<a id="function-function-miniquake2-game-ai-monster-finishreaction-function-finishreaction-actor-plan-context-src-miniquake2-game-ai-monster-ml-1096766350"></a>
### FinishReaction

```ml
function FinishReaction(actor, plan, context)
```

Finish reaction.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `plan` | `dynamic` | — | plan value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/monster.ml#L901)

<a id="function-function-miniquake2-game-ai-monster-finishrunstart-function-finishrunstart-actor-context-src-miniquake2-game-ai-monster-ml-898516213"></a>
### FinishRunStart

```ml
function FinishRunStart(actor, context)
```

Finish run start.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/monster.ml#L326)

<a id="function-function-miniquake2-game-ai-monster-finishwalkstart-function-finishwalkstart-actor-context-src-miniquake2-game-ai-monster-ml-174751329"></a>
### FinishWalkStart

```ml
function FinishWalkStart(actor, context)
```

Finish walk start.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/monster.ml#L318)

<a id="function-function-miniquake2-game-ai-monster-flymonsterstart-function-flymonsterstart-actor-context-src-miniquake2-game-ai-monster-ml-1874926223"></a>
### FlyMonsterStart

```ml
function FlyMonsterStart(actor, context)
```

Start fly monster.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/monster.ml#L1309)

<a id="function-function-miniquake2-game-ai-monster-installdefaultcallbacks-function-installdefaultcallbacks-actor-hasattack-hasmelee-src-miniquake2-game-ai-monster-ml-988703684"></a>
### installDefaultCallbacks

```ml
function installDefaultCallbacks(actor, hasAttack, hasMelee)
```

Install default callbacks.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `hasAttack` | `dynamic` | — | hasAttack value consumed by this operation. |
| `hasMelee` | `dynamic` | — | hasMelee value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/monster.ml#L604)

<a id="function-function-miniquake2-game-ai-monster-isactormoveactivity-inline-function-isactormoveactivity-activity-src-miniquake2-game-ai-monster-ml-2017598227"></a>
### IsActorMoveActivity

```ml
inline function IsActorMoveActivity(activity)
```

Report whether is actor move activity.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `activity` | `dynamic` | — | activity value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/monster.ml#L1031)

<a id="function-function-miniquake2-game-ai-monster-islocomotionactivity-inline-function-islocomotionactivity-activity-src-miniquake2-game-ai-monster-ml-558866341"></a>
### IsLocomotionActivity

```ml
inline function IsLocomotionActivity(activity)
```

Report whether is locomotion activity.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `activity` | `dynamic` | — | activity value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/monster.ml#L1024)

<a id="function-function-miniquake2-game-ai-monster-m-endframe-function-m-endframe-actor-context-src-miniquake2-game-ai-monster-ml-1774655117"></a>
### M_EndFrame

```ml
function M_EndFrame(actor, context)
```

End m frame.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/monster.ml#L1042)

<a id="function-function-miniquake2-game-ai-monster-m-fliesoff-function-m-fliesoff-actor-context-src-miniquake2-game-ai-monster-ml-2080974597"></a>
### M_FliesOff

```ml
function M_FliesOff(actor, context)
```

Report whether m flies off.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/monster.ml#L633)

<a id="function-function-miniquake2-game-ai-monster-m-flieson-function-m-flieson-actor-context-src-miniquake2-game-ai-monster-ml-553025373"></a>
### M_FliesOn

```ml
function M_FliesOn(actor, context)
```

Report whether m flies on.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/monster.ml#L644)

<a id="function-function-miniquake2-game-ai-monster-m-flycheck-function-m-flycheck-actor-context-src-miniquake2-game-ai-monster-ml-1707496785"></a>
### M_FlyCheck

```ml
function M_FlyCheck(actor, context)
```

Validate m fly.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/monster.ml#L660)

<a id="function-function-miniquake2-game-ai-monster-m-moveframe-function-m-moveframe-actor-context-src-miniquake2-game-ai-monster-ml-904758441"></a>
### M_MoveFrame

```ml
function M_MoveFrame(actor, context)
```

Move m frame.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/monster.ml#L785)

<a id="function-function-miniquake2-game-ai-monster-m-seteffects-function-m-seteffects-actor-context-src-miniquake2-game-ai-monster-ml-1968279717"></a>
### M_SetEffects

```ml
function M_SetEffects(actor, context)
```

Set m effects.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/monster.ml#L763)

<a id="function-function-miniquake2-game-ai-monster-m-worldeffects-function-m-worldeffects-actor-context-src-miniquake2-game-ai-monster-ml-684950181"></a>
### M_WorldEffects

```ml
function M_WorldEffects(actor, context)
```

Return the m world effects value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/monster.ml#L688)

<a id="function-function-miniquake2-game-ai-monster-mediccheckattack-function-mediccheckattack-actor-context-enemyrange-src-miniquake2-game-ai-monster-ml-1226382514"></a>
### MedicCheckAttack

```ml
function MedicCheckAttack(actor, context, enemyRange)
```

Validate medic attack.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |
| `enemyRange` | `dynamic` | — | enemyRange value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/monster.ml#L566)

<a id="function-function-miniquake2-game-ai-monster-monsterdeathuse-function-monsterdeathuse-actor-context-src-miniquake2-game-ai-monster-ml-1718368471"></a>
### MonsterDeathUse

```ml
function MonsterDeathUse(actor, context)
```

Use monster death.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/monster.ml#L1107)

<a id="function-function-miniquake2-game-ai-monster-monsterstart-function-monsterstart-actor-context-src-miniquake2-game-ai-monster-ml-1995786133"></a>
### MonsterStart

```ml
function MonsterStart(actor, context)
```

Start monster.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/monster.ml#L1128)

<a id="function-function-miniquake2-game-ai-monster-monsterstartgo-function-monsterstartgo-actor-context-src-miniquake2-game-ai-monster-ml-43481577"></a>
### MonsterStartGo

```ml
function MonsterStartGo(actor, context)
```

Start monster go.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/monster.ml#L1191)

<a id="function-function-miniquake2-game-ai-monster-monstertargetuse-function-monstertargetuse-actor-other-activator-context-src-miniquake2-game-ai-monster-ml-1582169832"></a>
### MonsterTargetUse

```ml
function MonsterTargetUse(actor, other, activator, context)
```

Use monster target.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `other` | `dynamic` | — | other value consumed by this operation. |
| `activator` | `dynamic` | — | activator value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/monster.ml#L1282)

<a id="function-function-miniquake2-game-ai-monster-monsterthink-function-monsterthink-actor-context-src-miniquake2-game-ai-monster-ml-124079557"></a>
### MonsterThink

```ml
function MonsterThink(actor, context)
```

Run monster.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/monster.ml#L1058)

<a id="function-function-miniquake2-game-ai-monster-monstertriggeredspawn-function-monstertriggeredspawn-actor-context-src-miniquake2-game-ai-monster-ml-988871737"></a>
### MonsterTriggeredSpawn

```ml
function MonsterTriggeredSpawn(actor, context)
```

Spawn monster triggered.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/monster.ml#L1257)

<a id="function-function-miniquake2-game-ai-monster-monstertriggeredspawnuse-function-monstertriggeredspawnuse-actor-other-activator-context-src-miniquake2-game-ai-monster-ml-447442000"></a>
### MonsterTriggeredSpawnUse

```ml
function MonsterTriggeredSpawnUse(actor, other, activator, context)
```

Spawn monster triggered use.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `other` | `dynamic` | — | other value consumed by this operation. |
| `activator` | `dynamic` | — | activator value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/monster.ml#L1247)

<a id="function-function-miniquake2-game-ai-monster-monstertriggeredstart-function-monstertriggeredstart-actor-context-src-miniquake2-game-ai-monster-ml-973781347"></a>
### MonsterTriggeredStart

```ml
function MonsterTriggeredStart(actor, context)
```

Start monster triggered.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/monster.ml#L1233)

<a id="function-function-miniquake2-game-ai-monster-monsteruse-function-monsteruse-actor-other-activator-context-src-miniquake2-game-ai-monster-ml-201265852"></a>
### MonsterUse

```ml
function MonsterUse(actor, other, activator, context)
```

Use monster.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `other` | `dynamic` | — | other value consumed by this operation. |
| `activator` | `dynamic` | — | activator value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/monster.ml#L1094)

<a id="function-function-miniquake2-game-ai-monster-mutantcheckattack-function-mutantcheckattack-actor-context-enemyrange-src-miniquake2-game-ai-monster-ml-700857628"></a>
### MutantCheckAttack

```ml
function MutantCheckAttack(actor, context, enemyRange)
```

Validate mutant attack.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |
| `enemyRange` | `dynamic` | — | enemyRange value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/monster.ml#L579)

<a id="function-function-miniquake2-game-ai-monster-nextstockrandominteger-function-nextstockrandominteger-context-fallback-src-miniquake2-game-ai-monster-ml-977365248"></a>
### NextStockRandomInteger

```ml
function NextStockRandomInteger(context, fallback)
```

Return the next stock random integer value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `context` | `dynamic` | — | Context that carries state for the operation. |
| `fallback` | `dynamic` | — | Value returned when no explicit result is available. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/monster.ml#L55)

<a id="function-function-miniquake2-game-ai-monster-nextstockrandomunit-function-nextstockrandomunit-context-fallback-src-miniquake2-game-ai-monster-ml-1522699464"></a>
### NextStockRandomUnit

```ml
function NextStockRandomUnit(context, fallback)
```

Return the next stock random unit value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `context` | `dynamic` | — | Context that carries state for the operation. |
| `fallback` | `dynamic` | — | Value returned when no explicit result is available. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/monster.ml#L47)

<a id="function-function-miniquake2-game-ai-monster-normalizecombattarget-function-normalizecombattarget-actor-context-src-miniquake2-game-ai-monster-ml-1279826553"></a>
### NormalizeCombatTarget

```ml
function NormalizeCombatTarget(actor, context)
```

Normalize combat target.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/monster.ml#L1160)

<a id="function-function-miniquake2-game-ai-monster-runreactionframecallbacks-function-runreactionframecallbacks-actor-plan-timelineoffset-context-src-miniquake2-game-ai-monster-ml-19165552"></a>
### RunReactionFrameCallbacks

```ml
function RunReactionFrameCallbacks(actor, plan, timelineOffset, context)
```

Run reaction frame callbacks.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `plan` | `dynamic` | — | plan value consumed by this operation. |
| `timelineOffset` | `dynamic` | — | timelineOffset value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/monster.ml#L846)

<a id="function-function-miniquake2-game-ai-monster-setstockmove-function-setstockmove-actor-movekind-endfunction-src-miniquake2-game-ai-monster-ml-1619131412"></a>
### SetStockMove

```ml
function SetStockMove(actor, moveKind, endFunction)
```

Set stock move.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `moveKind` | `dynamic` | — | moveKind value consumed by this operation. |
| `endFunction` | `dynamic` | — | endFunction value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/monster.ml#L256)

<a id="function-function-miniquake2-game-ai-monster-startreaction-function-startreaction-actor-plan-context-src-miniquake2-game-ai-monster-ml-1764656756"></a>
### StartReaction

```ml
function StartReaction(actor, plan, context)
```

Start reaction.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `plan` | `dynamic` | — | plan value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/monster.ml#L869)

<a id="function-function-miniquake2-game-ai-monster-stateattack-function-stateattack-actor-context-src-miniquake2-game-ai-monster-ml-2023484639"></a>
### StateAttack

```ml
function StateAttack(actor, context)
```

Performs the StateAttack operation for the miniquake2 game ai monster module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/monster.ml#L477)

<a id="function-function-miniquake2-game-ai-monster-statedie-function-statedie-actor-attacker-damage-context-src-miniquake2-game-ai-monster-ml-984825251"></a>
### StateDie

```ml
function StateDie(actor, attacker, damage, context)
```

Handle state.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `attacker` | `dynamic` | — | attacker value consumed by this operation. |
| `damage` | `dynamic` | — | damage value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/monster.ml#L536)

<a id="function-function-miniquake2-game-ai-monster-stateidle-function-stateidle-actor-context-src-miniquake2-game-ai-monster-ml-1604513403"></a>
### StateIdle

```ml
function StateIdle(actor, context)
```

Return the state idle value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/monster.ml#L383)

<a id="function-function-miniquake2-game-ai-monster-statemelee-function-statemelee-actor-context-src-miniquake2-game-ai-monster-ml-984917437"></a>
### StateMelee

```ml
function StateMelee(actor, context)
```

Return the state melee value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/monster.ml#L486)

<a id="function-function-miniquake2-game-ai-monster-statepain-function-statepain-actor-attacker-damage-context-src-miniquake2-game-ai-monster-ml-1373171129"></a>
### StatePain

```ml
function StatePain(actor, attacker, damage, context)
```

Handle state.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `attacker` | `dynamic` | — | attacker value consumed by this operation. |
| `damage` | `dynamic` | — | damage value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/monster.ml#L525)

<a id="function-function-miniquake2-game-ai-monster-staterun-function-staterun-actor-context-src-miniquake2-game-ai-monster-ml-291612661"></a>
### StateRun

```ml
function StateRun(actor, context)
```

Performs the StateRun operation for the miniquake2 game ai monster module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/monster.ml#L438)

<a id="function-function-miniquake2-game-ai-monster-statesearch-function-statesearch-actor-context-src-miniquake2-game-ai-monster-ml-1354929991"></a>
### StateSearch

```ml
function StateSearch(actor, context)
```

Return the state search value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/monster.ml#L403)

<a id="function-function-miniquake2-game-ai-monster-statesight-function-statesight-actor-enemy-context-src-miniquake2-game-ai-monster-ml-490464933"></a>
### StateSight

```ml
function StateSight(actor, enemy, context)
```

Return the state sight value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `enemy` | `dynamic` | — | enemy value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/monster.ml#L496)

<a id="function-function-miniquake2-game-ai-monster-statestand-function-statestand-actor-context-src-miniquake2-game-ai-monster-ml-130951217"></a>
### StateStand

```ml
function StateStand(actor, context)
```

Return the state stand value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/monster.ml#L361)

<a id="function-function-miniquake2-game-ai-monster-statewalk-function-statewalk-actor-context-src-miniquake2-game-ai-monster-ml-1102650277"></a>
### StateWalk

```ml
function StateWalk(actor, context)
```

Return the state walk value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/monster.ml#L421)

<a id="function-function-miniquake2-game-ai-monster-stockfidgetframesound-function-stockfidgetframesound-actor-context-src-miniquake2-game-ai-monster-ml-1677720879"></a>
### StockFidgetFrameSound

```ml
function StockFidgetFrameSound(actor, context)
```

Return the stock fidget frame sound value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/monster.ml#L83)

<a id="function-function-miniquake2-game-ai-monster-stockidlesoundname-function-stockidlesoundname-classname-src-miniquake2-game-ai-monster-ml-957920446"></a>
### StockIdleSoundName

```ml
function StockIdleSoundName(className)
```

Return the stock idle sound name.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `className` | `dynamic` | — | className value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/monster.ml#L62)

<a id="function-function-miniquake2-game-ai-monster-stockjorgidlesound-function-stockjorgidlesound-actor-context-src-miniquake2-game-ai-monster-ml-1541206485"></a>
### StockJorgIdleSound

```ml
function StockJorgIdleSound(actor, context)
```

Return the stock jorg idle sound value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/monster.ml#L152)

<a id="function-function-miniquake2-game-ai-monster-stockjorgstepleft-function-stockjorgstepleft-actor-context-src-miniquake2-game-ai-monster-ml-532425555"></a>
### StockJorgStepLeft

```ml
function StockJorgStepLeft(actor, context)
```

Advance stock jorg left.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/monster.ml#L160)

<a id="function-function-miniquake2-game-ai-monster-stockjorgstepright-function-stockjorgstepright-actor-context-src-miniquake2-game-ai-monster-ml-1793075469"></a>
### StockJorgStepRight

```ml
function StockJorgStepRight(actor, context)
```

Advance stock jorg right.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/monster.ml#L168)

<a id="function-function-miniquake2-game-ai-monster-stockmedicidleframe-function-stockmedicidleframe-actor-context-src-miniquake2-game-ai-monster-ml-1591712871"></a>
### StockMedicIdleFrame

```ml
function StockMedicIdleFrame(actor, context)
```

Return the stock medic idle frame value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/monster.ml#L134)

<a id="function-function-miniquake2-game-ai-monster-stockmutantidleloop-function-stockmutantidleloop-actor-context-src-miniquake2-game-ai-monster-ml-1589356383"></a>
### StockMutantIdleLoop

```ml
function StockMutantIdleLoop(actor, context)
```

Return the stock mutant idle loop value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/monster.ml#L284)

<a id="function-function-miniquake2-game-ai-monster-stockparasitetapsound-function-stockparasitetapsound-actor-context-src-miniquake2-game-ai-monster-ml-2077668223"></a>
### StockParasiteTapSound

```ml
function StockParasiteTapSound(actor, context)
```

Return the stock parasite tap sound value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/monster.ml#L144)

<a id="function-function-miniquake2-game-ai-monster-stockscratchsound-function-stockscratchsound-actor-context-src-miniquake2-game-ai-monster-ml-373115487"></a>
### StockScratchSound

```ml
function StockScratchSound(actor, context)
```

Return the stock scratch sound value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/monster.ml#L99)

<a id="function-function-miniquake2-game-ai-monster-stocksoldiercocksound-function-stocksoldiercocksound-actor-context-src-miniquake2-game-ai-monster-ml-584695079"></a>
### StockSoldierCockSound

```ml
function StockSoldierCockSound(actor, context)
```

Return the stock soldier cock sound value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/monster.ml#L107)

<a id="function-function-miniquake2-game-ai-monster-stocksoldieridleframesound-function-stocksoldieridleframesound-actor-context-src-miniquake2-game-ai-monster-ml-970191589"></a>
### StockSoldierIdleFrameSound

```ml
function StockSoldierIdleFrameSound(actor, context)
```

Return the stock soldier idle frame sound value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/monster.ml#L115)

<a id="function-function-miniquake2-game-ai-monster-stocksoldierwalkcycle-function-stocksoldierwalkcycle-actor-context-src-miniquake2-game-ai-monster-ml-1929139371"></a>
### StockSoldierWalkCycle

```ml
function StockSoldierWalkCycle(actor, context)
```

Return the stock soldier walk cycle value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/monster.ml#L124)

<a id="function-function-miniquake2-game-ai-monster-stockstandfidgetprobe-function-stockstandfidgetprobe-actor-context-src-miniquake2-game-ai-monster-ml-647374527"></a>
### StockStandFidgetProbe

```ml
function StockStandFidgetProbe(actor, context)
```

Return the stock stand fidget probe value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/monster.ml#L267)

<a id="function-function-miniquake2-game-ai-monster-stockstepsound-function-stockstepsound-actor-context-src-miniquake2-game-ai-monster-ml-406773829"></a>
### StockStepSound

```ml
function StockStepSound(actor, context)
```

Advance stock sound.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/monster.ml#L176)

<a id="function-function-miniquake2-game-ai-monster-swimmonsterstart-function-swimmonsterstart-actor-context-src-miniquake2-game-ai-monster-ml-1838923925"></a>
### SwimMonsterStart

```ml
function SwimMonsterStart(actor, context)
```

Start swim monster.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/monster.ml#L1324)

<a id="function-function-miniquake2-game-ai-monster-walkmonsterstart-function-walkmonsterstart-actor-context-src-miniquake2-game-ai-monster-ml-40348249"></a>
### WalkMonsterStart

```ml
function WalkMonsterStart(actor, context)
```

Start walk monster.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/ai/monster.ml#L1295)
