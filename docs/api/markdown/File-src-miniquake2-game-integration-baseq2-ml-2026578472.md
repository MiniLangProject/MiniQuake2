# `src/miniquake2/game/integration/baseq2.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 game integration baseq2 facilities for this project.

Package: [`miniquake2.game.integration.baseq2`](Package-miniquake2-game-integration-baseq2-1999269155.md)

Reachable from entry: **yes**

## Imports

- `miniquake2/game/ai/archetypes.ml` as `ibarchetypes` → [src/miniquake2/game/ai/archetypes.ml](File-src-miniquake2-game-ai-archetypes-ml-722294566.md)
- `miniquake2/game/ai/attack_sequences.ml` as `ibattackseq` → [src/miniquake2/game/ai/attack_sequences.ml](File-src-miniquake2-game-ai-attack-sequences-ml-1165424701.md)
- `miniquake2/game/ai/combat_profiles.ml` as `ibaicombat` → [src/miniquake2/game/ai/combat_profiles.ml](File-src-miniquake2-game-ai-combat-profiles-ml-1653840149.md)
- `miniquake2/game/ai/constants.ml` as `ibaiconstants` → [src/miniquake2/game/ai/constants.ml](File-src-miniquake2-game-ai-constants-ml-2069864859.md)
- `miniquake2/game/ai/core.ml` as `ibgaicore` → [src/miniquake2/game/ai/core.ml](File-src-miniquake2-game-ai-core-ml-1671967255.md)
- `miniquake2/game/ai/death_effects.ml` as `ibdeatheffects` → [src/miniquake2/game/ai/death_effects.ml](File-src-miniquake2-game-ai-death-effects-ml-1353580965.md)
- `miniquake2/game/ai/monster.ml` as `ibmonster` → [src/miniquake2/game/ai/monster.ml](File-src-miniquake2-game-ai-monster-ml-345185618.md)
- `miniquake2/game/ai/move.ml` as `ibaimove` → [src/miniquake2/game/ai/move.ml](File-src-miniquake2-game-ai-move-ml-1485609585.md)
- `miniquake2/game/ai/props.ml` as `ibaiprops` → [src/miniquake2/game/ai/props.ml](File-src-miniquake2-game-ai-props-ml-91813726.md)
- `miniquake2/game/ai/reaction_sequences.ml` as `ibreactionseq` → [src/miniquake2/game/ai/reaction_sequences.ml](File-src-miniquake2-game-ai-reaction-sequences-ml-721161120.md)
- `miniquake2/game/ai/sounds.ml` as `ibaisounds` → [src/miniquake2/game/ai/sounds.ml](File-src-miniquake2-game-ai-sounds-ml-1375480234.md)
- `miniquake2/game/ai/trail.ml` as `ibaitrail` → [src/miniquake2/game/ai/trail.ml](File-src-miniquake2-game-ai-trail-ml-2040340232.md)
- `miniquake2/game/ai/types.ml` as `ibaitypes` → [src/miniquake2/game/ai/types.ml](File-src-miniquake2-game-ai-types-ml-2113011711.md)
- `miniquake2/game/constants.ml` as `ibgconstants` → [src/miniquake2/game/constants.ml](File-src-miniquake2-game-constants-ml-1723282332.md)
- `miniquake2/game/gameplay/combat.ml` as `ibgpcombat` → [src/miniquake2/game/gameplay/combat.ml](File-src-miniquake2-game-gameplay-combat-ml-1854285404.md)
- `miniquake2/game/gameplay/constants.ml` as `ibgpconstants` → [src/miniquake2/game/gameplay/constants.ml](File-src-miniquake2-game-gameplay-constants-ml-1803115501.md)
- `miniquake2/game/gameplay/item_rules.ml` as `ibitemrules` → [src/miniquake2/game/gameplay/item_rules.ml](File-src-miniquake2-game-gameplay-item-rules-ml-1747940557.md)
- `miniquake2/game/gameplay/powerups.ml` as `ibpowerups` → [src/miniquake2/game/gameplay/powerups.ml](File-src-miniquake2-game-gameplay-powerups-ml-831759227.md)
- `miniquake2/game/gameplay/precache.ml` as `ibprecache` → [src/miniquake2/game/gameplay/precache.ml](File-src-miniquake2-game-gameplay-precache-ml-886827543.md)
- `miniquake2/game/gameplay/registry.ml` as `ibitems` → [src/miniquake2/game/gameplay/registry.ml](File-src-miniquake2-game-gameplay-registry-ml-1541508425.md)
- `miniquake2/game/gameplay/types.ml` as `ibgtypes` → [src/miniquake2/game/gameplay/types.ml](File-src-miniquake2-game-gameplay-types-ml-2088064005.md)
- `miniquake2/game/gameplay/weapons.ml` as `ibgpweapons` → [src/miniquake2/game/gameplay/weapons.ml](File-src-miniquake2-game-gameplay-weapons-ml-233473665.md)
- `miniquake2/game/integration/pusher.ml` as `ibpusher` → [src/miniquake2/game/integration/pusher.ml](File-src-miniquake2-game-integration-pusher-ml-920046543.md)
- `miniquake2/game/player/commands.ml` as `ibplayercommands` → [src/miniquake2/game/player/commands.ml](File-src-miniquake2-game-player-commands-ml-430416299.md)
- `miniquake2/game/player/constants.ml` as `ibplayerconstants` → [src/miniquake2/game/player/constants.ml](File-src-miniquake2-game-player-constants-ml-946982646.md)
- `miniquake2/game/player/rules.ml` as `ibplayerrules` → [src/miniquake2/game/player/rules.ml](File-src-miniquake2-game-player-rules-ml-492402760.md)
- `miniquake2/game/player/view.ml` as `ibplayerview` → [src/miniquake2/game/player/view.ml](File-src-miniquake2-game-player-view-ml-886735230.md)
- `miniquake2/game/random.ml` as `ibrandom` → [src/miniquake2/game/random.ml](File-src-miniquake2-game-random-ml-37022430.md)
- `miniquake2/game/types.ml` as `ibgametypes` → [src/miniquake2/game/types.ml](File-src-miniquake2-game-types-ml-1384205920.md)
- `miniquake2/game/weapons/constants.ml` as `ibwpconstants` → [src/miniquake2/game/weapons/constants.ml](File-src-miniquake2-game-weapons-constants-ml-539739454.md)
- `miniquake2/game/weapons/core.ml` as `ibwpcore` → [src/miniquake2/game/weapons/core.ml](File-src-miniquake2-game-weapons-core-ml-1168965024.md)
- `miniquake2/game/weapons/hand_grenade.ml` as `ibwphandgrenade` → [src/miniquake2/game/weapons/hand_grenade.ml](File-src-miniquake2-game-weapons-hand-grenade-ml-1007505985.md)
- `miniquake2/game/weapons/hitscan.ml` as `ibwphitscan` → [src/miniquake2/game/weapons/hitscan.ml](File-src-miniquake2-game-weapons-hitscan-ml-359162381.md)
- `miniquake2/game/weapons/projectiles.ml` as `ibwpprojectiles` → [src/miniquake2/game/weapons/projectiles.ml](File-src-miniquake2-game-weapons-projectiles-ml-2146249801.md)
- `miniquake2/game/weapons/types.ml` as `ibwptypes` → [src/miniquake2/game/weapons/types.ml](File-src-miniquake2-game-weapons-types-ml-582527054.md)
- `miniquake2/game/weapons/vector.ml` as `ibwpvector` → [src/miniquake2/game/weapons/vector.ml](File-src-miniquake2-game-weapons-vector-ml-1084549988.md)
- `miniquake2/game/world/constants.ml` as `ibworldconstants` → [src/miniquake2/game/world/constants.ml](File-src-miniquake2-game-world-constants-ml-774918061.md)
- `miniquake2/game/world/core.ml` as `ibworld` → [src/miniquake2/game/world/core.ml](File-src-miniquake2-game-world-core-ml-1171136969.md)
- `miniquake2/game/world/misc.ml` as `ibmisc` → [src/miniquake2/game/world/misc.ml](File-src-miniquake2-game-world-misc-ml-358660036.md)
- `miniquake2/game/world/movers.ml` as `ibmovers` → [src/miniquake2/game/world/movers.ml](File-src-miniquake2-game-world-movers-ml-1599163262.md)
- `miniquake2/game/world/targets.ml` as `ibtargets` → [src/miniquake2/game/world/targets.ml](File-src-miniquake2-game-world-targets-ml-76185516.md)
- `miniquake2/game/world/triggers.ml` as `ibtriggers` → [src/miniquake2/game/world/triggers.ml](File-src-miniquake2-game-world-triggers-ml-1619916595.md)
- `miniquake2/game/world/turret.ml` as `ibturret` → [src/miniquake2/game/world/turret.ml](File-src-miniquake2-game-world-turret-ml-1229260754.md)
- `miniquake2/game/world/turret_types.ml` as `ibturrettypes` → [src/miniquake2/game/world/turret_types.ml](File-src-miniquake2-game-world-turret-types-ml-68266644.md)
- `miniquake2/game/world/types.ml` as `ibwtypes` → [src/miniquake2/game/world/types.ml](File-src-miniquake2-game-world-types-ml-1207695045.md)
- `miniquake2/qcommon/constants.ml` as `ibqconstants` → [src/miniquake2/qcommon/constants.ml](File-src-miniquake2-qcommon-constants-ml-1976195726.md)
- `miniquake2/qcommon/monster_flash_offsets.ml` as `ibflashoffsets` → [src/miniquake2/qcommon/monster_flash_offsets.ml](File-src-miniquake2-qcommon-monster-flash-offsets-ml-1256832337.md)
- `miniquake2/qcommon/text.ml` as `ibqtext` → [src/miniquake2/qcommon/text.ml](File-src-miniquake2-qcommon-text-ml-1570504148.md)
- `miniquake2/qcommon/types.ml` as `ibqtypes` → [src/miniquake2/qcommon/types.ml](File-src-miniquake2-qcommon-types-ml-1663266398.md)
- `std/math.ml` as `ibmath` → `../MiniLangCompilerML/std/math.ml` — external dependency

## Declarations

<a id="global-global-miniquake2-game-integration-baseq2-activeintegrationruntime-activeintegrationruntime-src-miniquake2-game-integration-baseq2-ml-893101059"></a>
### activeIntegrationRuntime

```ml
activeIntegrationRuntime
```

Stores module-wide active integration runtime state for the miniquake2 game integration baseq2 module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L124)

<a id="function-function-miniquake2-game-integration-baseq2-activemonsterattackplan-function-activemonsterattackplan-actor-src-miniquake2-game-integration-baseq2-ml-1272937420"></a>
### activeMonsterAttackPlan

```ml
function activeMonsterAttackPlan(actor)
```

Report whether active monster attack plan.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L5402)

<a id="function-function-miniquake2-game-integration-baseq2-advancedroppeditems-function-advancedroppeditems-runtime-src-miniquake2-game-integration-baseq2-ml-419909349"></a>
### advanceDroppedItems

```ml
function advanceDroppedItems(runtime)
```

Advance every dropped item (compatibility/test entry point).

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L6398)

<a id="function-function-miniquake2-game-integration-baseq2-advancedroppeditemsatnumber-function-advancedroppeditemsatnumber-runtime-requestednumber-src-miniquake2-game-integration-baseq2-ml-530440588"></a>
### advanceDroppedItemsAtNumber

```ml
function advanceDroppedItemsAtNumber(runtime, requestedNumber)
```

Advance dropped items.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |
| `requestedNumber` | `dynamic` | — | requestedNumber value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L6311)

<a id="function-function-miniquake2-game-integration-baseq2-advancemonsterattack-function-advancemonsterattack-runtime-actor-attackplan-src-miniquake2-game-integration-baseq2-ml-1049028445"></a>
### advanceMonsterAttack

```ml
function advanceMonsterAttack(runtime, actor, attackPlan)
```

Advance exactly one 0.1-second attack-plan frame, including movement, frame callbacks and refire decisions. nextFrame is persisted so save/restore does not replay an already emitted projectile or sound.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `attackPlan` | `dynamic` | — | attackPlan value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L5690)

<a id="function-function-miniquake2-game-integration-baseq2-advancemutantjumpphysics-function-advancemutantjumpphysics-runtime-actor-src-miniquake2-game-integration-baseq2-ml-1755482756"></a>
### advanceMutantJumpPhysics

```ml
function advanceMutantJumpPhysics(runtime, actor)
```

Advance mutant jump physics.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |
| `actor` | `dynamic` | — | actor value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L5097)

<a id="function-function-miniquake2-game-integration-baseq2-advanceweaponprojectileatnumber-function-advanceweaponprojectileatnumber-runtime-requestednumber-src-miniquake2-game-integration-baseq2-ml-469907114"></a>
### advanceWeaponProjectileAtNumber

```ml
function advanceWeaponProjectileAtNumber(runtime, requestedNumber)
```

Advance weapon projectiles.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |
| `requestedNumber` | `dynamic` | — | requestedNumber value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L6240)

<a id="function-function-miniquake2-game-integration-baseq2-advanceweaponprojectiles-function-advanceweaponprojectiles-runtime-src-miniquake2-game-integration-baseq2-ml-1352448733"></a>
### advanceWeaponProjectiles

```ml
function advanceWeaponProjectiles(runtime)
```

Advance weapon projectiles.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L6288)

<a id="function-function-miniquake2-game-integration-baseq2-advanceworldtossentities-function-advanceworldtossentities-runtime-src-miniquake2-game-integration-baseq2-ml-858046669"></a>
### advanceWorldTossEntities

```ml
function advanceWorldTossEntities(runtime)
```

Advance every managed world toss entity (compatibility/test entry point).

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L6233)

<a id="function-function-miniquake2-game-integration-baseq2-advanceworldtossentitiesatnumber-function-advanceworldtossentitiesatnumber-runtime-requestednumber-src-miniquake2-game-integration-baseq2-ml-962371036"></a>
### advanceWorldTossEntitiesAtNumber

```ml
function advanceWorldTossEntitiesAtNumber(runtime, requestedNumber)
```

Advance world toss entities.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |
| `requestedNumber` | `dynamic` | — | requestedNumber value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L6159)

<a id="function-function-miniquake2-game-integration-baseq2-aiareasconnected-function-aiareasconnected-first-second-src-miniquake2-game-integration-baseq2-ml-660666703"></a>
### aiAreasConnected

```ml
function aiAreasConnected(first, second)
```

Report whether ai areas connected.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `first` | `dynamic` | — | first value consumed by this operation. |
| `second` | `dynamic` | — | second value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L657)

<a id="function-function-miniquake2-game-integration-baseq2-aiclearshot-function-aiclearshot-actor-other-src-miniquake2-game-integration-baseq2-ml-115122158"></a>
### aiClearShot

```ml
function aiClearShot(actor, other)
```

Clear ai shot.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `other` | `dynamic` | — | other value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L623)

<a id="function-function-miniquake2-game-integration-baseq2-aiinphs-function-aiinphs-first-second-src-miniquake2-game-integration-baseq2-ml-152569075"></a>
### aiInPHS

```ml
function aiInPHS(first, second)
```

Return the ai in phs value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `first` | `dynamic` | — | first value consumed by this operation. |
| `second` | `dynamic` | — | second value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L648)

<a id="function-function-miniquake2-game-integration-baseq2-aipicktarget-function-aipicktarget-targetname-src-miniquake2-game-integration-baseq2-ml-1028820029"></a>
### aiPickTarget

```ml
function aiPickTarget(targetName)
```

Choose ai target.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `targetName` | `dynamic` | — | targetName value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L540)

<a id="global-global-miniquake2-game-integration-baseq2-aitraceendscratch-aitraceendscratch-src-miniquake2-game-integration-baseq2-ml-1262892523"></a>
### aiTraceEndScratch

```ml
aiTraceEndScratch
```

Stores module-wide ai trace end scratch state for the miniquake2 game integration baseq2 module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L447)

<a id="global-global-miniquake2-game-integration-baseq2-aitracestartscratch-aitracestartscratch-src-miniquake2-game-integration-baseq2-ml-1122245879"></a>
### aiTraceStartScratch

```ml
aiTraceStartScratch
```

The server game is single-threaded. Reuse the three immutable-by-callee


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L445)

<a id="global-global-miniquake2-game-integration-baseq2-aitracezeroscratch-aitracezeroscratch-src-miniquake2-game-integration-baseq2-ml-2136821601"></a>
### aiTraceZeroScratch

```ml
aiTraceZeroScratch
```

Stores module-wide ai trace zero scratch state for the miniquake2 game integration baseq2 module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L449)

<a id="function-function-miniquake2-game-integration-baseq2-aitrailpickfirst-function-aitrailpickfirst-actor-src-miniquake2-game-integration-baseq2-ml-424078770"></a>
### aiTrailPickFirst

```ml
function aiTrailPickFirst(actor)
```

Choose ai trail first.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L665)

<a id="function-function-miniquake2-game-integration-baseq2-aitrailpicknext-function-aitrailpicknext-actor-src-miniquake2-game-integration-baseq2-ml-2127054198"></a>
### aiTrailPickNext

```ml
function aiTrailPickNext(actor)
```

Choose ai trail next.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L674)

<a id="global-global-miniquake2-game-integration-baseq2-aitriggermaxsscratch-aitriggermaxsscratch-src-miniquake2-game-integration-baseq2-ml-1066209209"></a>
### aiTriggerMaxsScratch

```ml
aiTriggerMaxsScratch
```

Stores module-wide ai trigger maxs scratch state for the miniquake2 game integration baseq2 module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L453)

<a id="global-global-miniquake2-game-integration-baseq2-aitriggerminsscratch-aitriggerminsscratch-src-miniquake2-game-integration-baseq2-ml-2075323721"></a>
### aiTriggerMinsScratch

```ml
aiTriggerMinsScratch
```

Stores module-wide ai trigger mins scratch state for the miniquake2 game integration baseq2 module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L451)

<a id="function-function-miniquake2-game-integration-baseq2-aiusetargets-function-aiusetargets-actor-activator-src-miniquake2-game-integration-baseq2-ml-801216103"></a>
### aiUseTargets

```ml
function aiUseTargets(actor, activator)
```

Use ai targets.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `activator` | `dynamic` | — | activator value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L563)

<a id="function-function-miniquake2-game-integration-baseq2-aivisible-function-aivisible-actor-other-src-miniquake2-game-integration-baseq2-ml-2018541812"></a>
### aiVisible

```ml
function aiVisible(actor, other)
```

Report whether ai visible.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `other` | `dynamic` | — | other value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L600)

<a id="function-function-miniquake2-game-integration-baseq2-applymonsterattackmovement-function-applymonsterattackmovement-actor-attackplan-timelineoffset-context-src-miniquake2-game-integration-baseq2-ml-540278552"></a>
### applyMonsterAttackMovement

```ml
function applyMonsterAttackMovement(actor, attackPlan, timelineOffset, context)
```

Apply monster attack movement.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `attackPlan` | `dynamic` | — | attackPlan value consumed by this operation. |
| `timelineOffset` | `dynamic` | — | timelineOffset value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L5575)

<a id="function-function-miniquake2-game-integration-baseq2-applyplayerweaponrecoil-function-applyplayerweaponrecoil-runtime-player-item-direction-src-miniquake2-game-integration-baseq2-ml-2124868940"></a>
### applyPlayerWeaponRecoil

```ml
function applyPlayerWeaponRecoil(runtime, player, item, direction)
```

Apply player weapon recoil.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |
| `player` | `dynamic` | — | player value consumed by this operation. |
| `item` | `dynamic` | — | item value consumed by this operation. |
| `direction` | `dynamic` | — | direction value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L4388)

<a id="function-function-miniquake2-game-integration-baseq2-beginmonsterattack-function-beginmonsterattack-runtime-actor-attackplan-src-miniquake2-game-integration-baseq2-ml-1985084317"></a>
### beginMonsterAttack

```ml
function beginMonsterAttack(runtime, actor, attackPlan)
```

Begin monster attack.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `attackPlan` | `dynamic` | — | attackPlan value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L5819)

<a id="function-function-miniquake2-game-integration-baseq2-beginplayerattackanimation-function-beginplayerattackanimation-player-src-miniquake2-game-integration-baseq2-ml-75333800"></a>
### beginPlayerAttackAnimation

```ml
function beginPlayerAttackAnimation(player)
```

Begin player attack animation.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `player` | `dynamic` | — | player value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L4371)

<a id="function-function-miniquake2-game-integration-baseq2-bindenginemodels-function-bindenginemodels-runtime-exporttable-imports-src-miniquake2-game-integration-baseq2-ml-631996769"></a>
### bindEngineModels

```ml
function bindEngineModels(runtime, exportTable, imports)
```

Bind engine models.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |
| `exportTable` | `dynamic` | — | exportTable value consumed by this operation. |
| `imports` | `dynamic` | — | imports value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L3918)

<a id="function-function-miniquake2-game-integration-baseq2-bindenginemodelswithmode-function-bindenginemodelswithmode-runtime-exporttable-imports-refreshgeometry-src-miniquake2-game-integration-baseq2-ml-474357846"></a>
### bindEngineModelsWithMode

```ml
function bindEngineModelsWithMode(runtime, exportTable, imports, refreshGeometry)
```

Bind managed world components to their engine edicts through setmodel so inline brush hull bounds/headnodes become authoritative for movement and traces. This must run after configureIntegratedRuntime installed linkEntity.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |
| `exportTable` | `dynamic` | — | exportTable value consumed by this operation. |
| `imports` | `dynamic` | — | imports value consumed by this operation. |
| `refreshGeometry` | `dynamic` | — | refreshGeometry value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L3893)

<a id="function-function-miniquake2-game-integration-baseq2-bindrestoredenginemodels-function-bindrestoredenginemodels-runtime-exporttable-imports-src-miniquake2-game-integration-baseq2-ml-1265986905"></a>
### bindRestoredEngineModels

```ml
function bindRestoredEngineModels(runtime, exportTable, imports)
```

Bind restored engine models.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |
| `exportTable` | `dynamic` | — | exportTable value consumed by this operation. |
| `imports` | `dynamic` | — | imports value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L3926)

<a id="function-function-miniquake2-game-integration-baseq2-bodyqueuedie-function-bodyqueuedie-entity-inflictor-attacker-damage-point-world-src-miniquake2-game-integration-baseq2-ml-1284821700"></a>
### bodyQueueDie

```ml
function bodyQueueDie(entity, inflictor, attacker, damage, point, world)
```

Handle damage to a corpse copied into the fixed body queue.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `inflictor` | `dynamic` | — | inflictor value consumed by this operation. |
| `attacker` | `dynamic` | — | attacker value consumed by this operation. |
| `damage` | `dynamic` | — | damage value consumed by this operation. |
| `point` | `dynamic` | — | point value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L250)

<a id="function-function-miniquake2-game-integration-baseq2-boundsoverlap-function-boundsoverlap-first-second-src-miniquake2-game-integration-baseq2-ml-1264908123"></a>
### boundsOverlap

```ml
function boundsOverlap(first, second)
```

Return the bounds overlap value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `first` | `dynamic` | — | first value consumed by this operation. |
| `second` | `dynamic` | — | second value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L4151)

<a id="function-function-miniquake2-game-integration-baseq2-clipweaponaxis-function-clipweaponaxis-interval-startvalue-endvalue-minimum-maximum-axis-src-miniquake2-game-integration-baseq2-ml-1620161280"></a>
### clipWeaponAxis

```ml
function clipWeaponAxis(interval, startValue, endValue, minimum, maximum, axis)
```

Clip weapon axis.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `interval` | `dynamic` | — | interval value consumed by this operation. |
| `startValue` | `dynamic` | — | startValue value consumed by this operation. |
| `endValue` | `dynamic` | — | endValue value consumed by this operation. |
| `minimum` | `dynamic` | — | minimum value consumed by this operation. |
| `maximum` | `dynamic` | — | maximum value consumed by this operation. |
| `axis` | `dynamic` | — | axis value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L1636)

<a id="function-function-miniquake2-game-integration-baseq2-clipworldlaseraxis-function-clipworldlaseraxis-clip-startvalue-endvalue-minimum-maximum-axis-src-miniquake2-game-integration-baseq2-ml-1262077177"></a>
### clipWorldLaserAxis

```ml
function clipWorldLaserAxis(clip, startValue, endValue, minimum, maximum, axis)
```

Clip world laser axis.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `clip` | `dynamic` | — | clip value consumed by this operation. |
| `startValue` | `dynamic` | — | startValue value consumed by this operation. |
| `endValue` | `dynamic` | — | endValue value consumed by this operation. |
| `minimum` | `dynamic` | — | minimum value consumed by this operation. |
| `maximum` | `dynamic` | — | maximum value consumed by this operation. |
| `axis` | `dynamic` | — | axis value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L1966)

<a id="function-function-miniquake2-game-integration-baseq2-clipworldlaserbounds-function-clipworldlaserbounds-start-finish-origin-mins-maxs-src-miniquake2-game-integration-baseq2-ml-2120959888"></a>
### clipWorldLaserBounds

```ml
function clipWorldLaserBounds(start, finish, origin, mins, maxs)
```

Clip world laser bounds.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `start` | `dynamic` | — | start value consumed by this operation. |
| `finish` | `dynamic` | — | finish value consumed by this operation. |
| `origin` | `dynamic` | — | origin value consumed by this operation. |
| `mins` | `dynamic` | — | mins value consumed by this operation. |
| `maxs` | `dynamic` | — | maxs value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L1988)

<a id="function-function-miniquake2-game-integration-baseq2-clipworldtossvelocity-function-clipworldtossvelocity-entity-normal-src-miniquake2-game-integration-baseq2-ml-2045214691"></a>
### clipWorldTossVelocity

```ml
function clipWorldTossVelocity(entity, normal)
```

Match g_phys.c ClipVelocity and the SV_Physics_Toss landing gate. Bounce entities retain enough reflected vertical speed to leave the ground again; ordinary toss entities settle on the first walkable floor impact.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `normal` | `dynamic` | — | normal value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L5999)

<a id="function-function-miniquake2-game-integration-baseq2-compactintegratedvalues-function-compactintegratedvalues-values-count-src-miniquake2-game-integration-baseq2-ml-445105170"></a>
### compactIntegratedValues

```ml
function compactIntegratedValues(values, count)
```

Return the compact integrated values value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `values` | `dynamic` | — | values value consumed by this operation. |
| `count` | `dynamic` | — | Number of items or units to process. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L473)

<a id="function-function-miniquake2-game-integration-baseq2-compactweaponprojectiles-function-compactweaponprojectiles-runtime-src-miniquake2-game-integration-baseq2-ml-815224901"></a>
### compactWeaponProjectiles

```ml
function compactWeaponProjectiles(runtime)
```

Remove projectile records released during the numeric edict pass.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L6271)

<a id="function-function-miniquake2-game-integration-baseq2-configureai-function-configureai-context-src-miniquake2-game-integration-baseq2-ml-508771240"></a>
### configureAI

```ml
function configureAI(context)
```

Configure ai.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `context` | `dynamic` | — | Context that carries state for the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L1258)

<a id="function-function-miniquake2-game-integration-baseq2-containsitemindex-function-containsitemindex-indexes-value-src-miniquake2-game-integration-baseq2-ml-1579448884"></a>
### containsItemIndex

```ml
function containsItemIndex(indexes, value)
```

Report whether contains item index.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `indexes` | `dynamic` | — | indexes value consumed by this operation. |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L3709)

<a id="function-function-miniquake2-game-integration-baseq2-copyplayerbody-function-copyplayerbody-runtime-player-src-miniquake2-game-integration-baseq2-ml-721273946"></a>
### copyPlayerBody

```ml
function copyPlayerBody(runtime, player)
```

CopyToBodyQue: snapshot the dead player into the next fixed corpse slot.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |
| `player` | `dynamic` | — | player value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L344)

<a id="function-function-miniquake2-game-integration-baseq2-copyvector-function-copyvector-values-src-miniquake2-game-integration-baseq2-ml-998299513"></a>
### copyVector

```ml
function copyVector(values)
```

Copy vector data.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `values` | `dynamic` | — | values value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L487)

<a id="function-function-miniquake2-game-integration-baseq2-create-function-create-spawnresult-src-miniquake2-game-integration-baseq2-ml-1929614451"></a>
### create

```ml
function create(spawnResult)
```

Construct every world, item and monster record before callbacks can observe the runtime. Parsed edict numbers remain authoritative across proxy tables.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `spawnResult` | `dynamic` | — | spawnResult value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L3561)

<a id="function-function-miniquake2-game-integration-baseq2-damagemonster-function-damagemonster-runtime-monsterindex-attacker-damage-src-miniquake2-game-integration-baseq2-ml-1239322295"></a>
### damageMonster

```ml
function damageMonster(runtime, monsterIndex, attacker, damage)
```

Return the damage monster value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |
| `monsterIndex` | `dynamic` | — | Zero-based index of monster. |
| `attacker` | `dynamic` | — | attacker value consumed by this operation. |
| `damage` | `dynamic` | — | damage value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L6736)

<a id="function-function-miniquake2-game-integration-baseq2-damagemutantjumptarget-function-damagemutantjumptarget-runtime-actor-target-velocity-impactpoint-src-miniquake2-game-integration-baseq2-ml-1857980346"></a>
### damageMutantJumpTarget

```ml
function damageMutantJumpTarget(runtime, actor, target, velocity, impactPoint)
```

Return the damage mutant jump target value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `target` | `dynamic` | — | target value consumed by this operation. |
| `velocity` | `dynamic` | — | velocity value consumed by this operation. |
| `impactPoint` | `dynamic` | — | impactPoint value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L5082)

<a id="function-function-miniquake2-game-integration-baseq2-damageworldentity-function-damageworldentity-runtime-entitynumber-attacker-damage-src-miniquake2-game-integration-baseq2-ml-1254432585"></a>
### damageWorldEntity

```ml
function damageWorldEntity(runtime, entityNumber, attacker, damage)
```

Return the damage world entity value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |
| `entityNumber` | `dynamic` | — | entityNumber value consumed by this operation. |
| `attacker` | `dynamic` | — | attacker value consumed by this operation. |
| `damage` | `dynamic` | — | damage value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L6751)

<a id="function-function-miniquake2-game-integration-baseq2-deathmatchinhibitsitem-function-deathmatchinhibitsitem-itementity-playercontext-src-miniquake2-game-integration-baseq2-ml-627858945"></a>
### deathmatchInhibitsItem

```ml
function deathmatchInhibitsItem(itemEntity, playerContext)
```

Return the deathmatch inhibits item value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `itemEntity` | `dynamic` | — | itemEntity value consumed by this operation. |
| `playerContext` | `dynamic` | — | playerContext value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L6405)

<a id="function-function-miniquake2-game-integration-baseq2-dropplayeritem-function-dropplayeritem-runtime-player-playercontext-item-src-miniquake2-game-integration-baseq2-ml-289352175"></a>
### dropPlayerItem

```ml
function dropPlayerItem(runtime, player, playerContext, item)
```

Drop player item.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |
| `player` | `dynamic` | — | player value consumed by this operation. |
| `playerContext` | `dynamic` | — | playerContext value consumed by this operation. |
| `item` | `dynamic` | — | item value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L2345)

<a id="function-function-miniquake2-game-integration-baseq2-emitmonsterattackeventsound-function-emitmonsterattackeventsound-actor-attackplan-eventindex-eventfired-src-miniquake2-game-integration-baseq2-ml-628713639"></a>
### emitMonsterAttackEventSound

```ml
function emitMonsterAttackEventSound(actor, attackPlan, eventIndex, eventFired)
```

Emit monster attack event sound.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `attackPlan` | `dynamic` | — | attackPlan value consumed by this operation. |
| `eventIndex` | `dynamic` | — | Zero-based index of event. |
| `eventFired` | `dynamic` | — | eventFired value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L5604)

<a id="function-function-miniquake2-game-integration-baseq2-emitmonsterattackframesound-function-emitmonsterattackframesound-actor-attackplan-timelineoffset-src-miniquake2-game-integration-baseq2-ml-69078421"></a>
### emitMonsterAttackFrameSound

```ml
function emitMonsterAttackFrameSound(actor, attackPlan, timelineOffset)
```

Emit monster attack frame sound.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `attackPlan` | `dynamic` | — | attackPlan value consumed by this operation. |
| `timelineOffset` | `dynamic` | — | timelineOffset value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L5591)

<a id="function-function-miniquake2-game-integration-baseq2-emitplayerweaponsound-function-emitplayerweaponsound-runtime-player-channel-name-attenuation-src-miniquake2-game-integration-baseq2-ml-1396326192"></a>
### emitPlayerWeaponSound

```ml
function emitPlayerWeaponSound(runtime, player, channel, name, attenuation)
```

Emit player weapon sound.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |
| `player` | `dynamic` | — | player value consumed by this operation. |
| `channel` | `dynamic` | — | channel value consumed by this operation. |
| `name` | `dynamic` | — | Name of the affected item. |
| `attenuation` | `dynamic` | — | attenuation value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L4450)

<a id="function-function-miniquake2-game-integration-baseq2-findaiplayer-function-findaiplayer-runtime-number-src-miniquake2-game-integration-baseq2-ml-767320370"></a>
### findAIPlayer

```ml
function findAIPlayer(runtime, number)
```

Find ai player.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |
| `number` | `dynamic` | — | number value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L4196)

<a id="function-function-miniquake2-game-integration-baseq2-finditembyclass-function-finditembyclass-runtime-classname-src-miniquake2-game-integration-baseq2-ml-1415355432"></a>
### findItemByClass

```ml
function findItemByClass(runtime, className)
```

Find item by class.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |
| `className` | `dynamic` | — | className value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L3996)

<a id="function-function-miniquake2-game-integration-baseq2-finditembynumber-function-finditembynumber-runtime-number-src-miniquake2-game-integration-baseq2-ml-717540014"></a>
### findItemByNumber

```ml
function findItemByNumber(runtime, number)
```

Find item by number.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |
| `number` | `dynamic` | — | number value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L3986)

<a id="function-function-miniquake2-game-integration-baseq2-findworldbyclass-function-findworldbyclass-runtime-classname-src-miniquake2-game-integration-baseq2-ml-828571006"></a>
### findWorldByClass

```ml
function findWorldByClass(runtime, className)
```

Find world by class.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |
| `className` | `dynamic` | — | className value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L3976)

<a id="function-function-miniquake2-game-integration-baseq2-findworldbynumber-function-findworldbynumber-runtime-number-src-miniquake2-game-integration-baseq2-ml-1366776716"></a>
### findWorldByNumber

```ml
function findWorldByNumber(runtime, number)
```

Find world by number.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |
| `number` | `dynamic` | — | number value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L3963)

<a id="function-function-miniquake2-game-integration-baseq2-finishmonsterattack-function-finishmonsterattack-runtime-actor-attackplan-lastframeoffset-src-miniquake2-game-integration-baseq2-ml-49539675"></a>
### finishMonsterAttack

```ml
function finishMonsterAttack(runtime, actor, attackPlan, lastFrameOffset)
```

Finish monster attack.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `attackPlan` | `dynamic` | — | attackPlan value consumed by this operation. |
| `lastFrameOffset` | `dynamic` | — | lastFrameOffset value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L5664)

<a id="function-function-miniquake2-game-integration-baseq2-firemonsterattack-function-firemonsterattack-runtime-actor-attackplan-eventindex-muzzleflash-src-miniquake2-game-integration-baseq2-ml-656526660"></a>
### fireMonsterAttack

```ml
function fireMonsterAttack(runtime, actor, attackPlan, eventIndex, muzzleFlash)
```

Fire monster attack.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `attackPlan` | `dynamic` | — | attackPlan value consumed by this operation. |
| `eventIndex` | `dynamic` | — | Zero-based index of event. |
| `muzzleFlash` | `dynamic` | — | muzzleFlash value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L5339)

<a id="global-global-miniquake2-game-integration-baseq2-infantrydeathaimpitch-infantrydeathaimpitch-src-miniquake2-game-integration-baseq2-ml-922183047"></a>
### infantryDeathAimPitch

```ml
infantryDeathAimPitch
```

m_infantry.c's fixed death211..death222 spray. Scalar package tables avoid


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L405)

<a id="global-global-miniquake2-game-integration-baseq2-infantrydeathaimyaw-infantrydeathaimyaw-src-miniquake2-game-integration-baseq2-ml-1938650123"></a>
### infantryDeathAimYaw

```ml
infantryDeathAimYaw
```

Stores module-wide infantry death aim yaw state for the miniquake2 game integration baseq2 module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L408)

<a id="function-function-miniquake2-game-integration-baseq2-initializebodyqueue-function-initializebodyqueue-runtime-src-miniquake2-game-integration-baseq2-ml-876294163"></a>
### initializeBodyQueue

```ml
function initializeBodyQueue(runtime)
```

Reserve the eight body edicts immediately after the client range.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L287)

<a id="function-function-miniquake2-game-integration-baseq2-initializeedictallocator-function-initializeedictallocator-runtime-exporttable-maxclients-src-miniquake2-game-integration-baseq2-ml-540840595"></a>
### initializeEdictAllocator

```ml
function initializeEdictAllocator(runtime, exportTable, maxClients)
```

Initialize the level-owned allocator state used by every dynamic entity.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |
| `exportTable` | `dynamic` | — | exportTable value consumed by this operation. |
| `maxClients` | `dynamic` | — | maxClients value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L171)

<a id="function-function-miniquake2-game-integration-baseq2-initializemonstermovement-function-initializemonstermovement-runtime-restoring-src-miniquake2-game-integration-baseq2-ml-1402824198"></a>
### initializeMonsterMovement

```ml
function initializeMonsterMovement(runtime, restoring)
```

m_move/g_monster startup is delayed until the GameImport collision bridge has the retail BSP and inline models linked. Restores re-establish transient ground/water references without altering the persisted transform.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |
| `restoring` | `dynamic` | — | restoring value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L3935)

<a id="function-function-miniquake2-game-integration-baseq2-installdroppeditem-function-installdroppeditem-runtime-player-playercontext-itementity-src-miniquake2-game-integration-baseq2-ml-689101818"></a>
### installDroppedItem

```ml
function installDroppedItem(runtime, player, playerContext, itemEntity)
```

Complete Drop_Item's engine-facing half after the item-specific callback has changed inventory.  The managed item record retains toss velocity and the two stock deadlines: owner immunity for one second and DM expiry at 30.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |
| `player` | `dynamic` | — | player value consumed by this operation. |
| `playerContext` | `dynamic` | — | playerContext value consumed by this operation. |
| `itemEntity` | `dynamic` | — | itemEntity value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L2295)

<a id="function-function-miniquake2-game-integration-baseq2-installmonstertargetproxies-function-installmonstertargetproxies-runtime-src-miniquake2-game-integration-baseq2-ml-655460225"></a>
### installMonsterTargetProxies

```ml
function installMonsterTargetProxies(runtime)
```

Install monster target proxies.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L1408)

<a id="function-function-miniquake2-game-integration-baseq2-installproptargetproxies-function-installproptargetproxies-runtime-src-miniquake2-game-integration-baseq2-ml-1855219445"></a>
### installPropTargetProxies

```ml
function installPropTargetProxies(runtime)
```

Install prop target proxies.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L1356)

<a id="function-function-miniquake2-game-integration-baseq2-installturretrigs-function-installturretrigs-runtime-src-miniquake2-game-integration-baseq2-ml-734389337"></a>
### installTurretRigs

```ml
function installTurretRigs(runtime)
```

Install turret rigs.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L3422)

<a id="function-function-miniquake2-game-integration-baseq2-installworldspawn-function-installworldspawn-entity-world-src-miniquake2-game-integration-baseq2-ml-697497658"></a>
### installWorldSpawn

```ml
function installWorldSpawn(entity, world)
```

Install world spawn.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L3464)

<a id="function-function-miniquake2-game-integration-baseq2-integratedactorbroadcast-function-integratedactorbroadcast-actornumber-message-exclamation-src-miniquake2-game-integration-baseq2-ml-946522053"></a>
### integratedActorBroadcast

```ml
function integratedActorBroadcast(actorNumber, message, exclamation)
```

Return the integrated actor broadcast value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actorNumber` | `dynamic` | — | actorNumber value consumed by this operation. |
| `message` | `dynamic` | — | Human-readable message associated with the operation. |
| `exclamation` | `dynamic` | — | exclamation value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L2700)

<a id="function-function-miniquake2-game-integration-baseq2-integratedactorchat-function-integratedactorchat-actor-message-src-miniquake2-game-integration-baseq2-ml-1736579179"></a>
### integratedActorChat

```ml
function integratedActorChat(actor, message)
```

Return the integrated actor chat value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `message` | `dynamic` | — | Human-readable message associated with the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L2721)

<a id="function-function-miniquake2-game-integration-baseq2-integratedactormessage-function-integratedactormessage-actorentity-message-src-miniquake2-game-integration-baseq2-ml-963406676"></a>
### integratedActorMessage

```ml
function integratedActorMessage(actorEntity, message)
```

Return the integrated actor message value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actorEntity` | `dynamic` | — | actorEntity value consumed by this operation. |
| `message` | `dynamic` | — | Human-readable message associated with the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L2729)

<a id="function-function-miniquake2-game-integration-baseq2-integratedactorname-function-integratedactorname-number-src-miniquake2-game-integration-baseq2-ml-1793905046"></a>
### integratedActorName

```ml
function integratedActorName(number)
```

Return the integrated actor name.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `number` | `dynamic` | — | number value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L2683)

<a id="function-function-miniquake2-game-integration-baseq2-integratedactortransition-function-integratedactortransition-actorentity-waypoint-action-actiontarget-nexttarget-wait-flags-src-miniquake2-game-integration-baseq2-ml-2125313573"></a>
### integratedActorTransition

```ml
function integratedActorTransition(actorEntity, waypoint, action, actionTarget, nextTarget, wait, flags)
```

Return the integrated actor transition value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actorEntity` | `dynamic` | — | actorEntity value consumed by this operation. |
| `waypoint` | `dynamic` | — | waypoint value consumed by this operation. |
| `action` | `dynamic` | — | action value consumed by this operation. |
| `actionTarget` | `dynamic` | — | actionTarget value consumed by this operation. |
| `nextTarget` | `dynamic` | — | nextTarget value consumed by this operation. |
| `wait` | `dynamic` | — | wait value consumed by this operation. |
| `flags` | `dynamic` | — | Bit flags controlling the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L2759)

<a id="function-function-miniquake2-game-integration-baseq2-integratedaidamage-function-integratedaidamage-actor-amount-damageflags-meansofdeath-src-miniquake2-game-integration-baseq2-ml-298767139"></a>
### integratedAIDamage

```ml
function integratedAIDamage(actor, amount, damageFlags, meansOfDeath)
```

Return the integrated ai damage value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `amount` | `dynamic` | — | amount value consumed by this operation. |
| `damageFlags` | `dynamic` | — | damageFlags value consumed by this operation. |
| `meansOfDeath` | `dynamic` | — | meansOfDeath value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L1303)

<a id="function-function-miniquake2-game-integration-baseq2-integratedaideatheffect-function-integratedaideatheffect-actor-effect-src-miniquake2-game-integration-baseq2-ml-6125381"></a>
### integratedAIDeathEffect

```ml
function integratedAIDeathEffect(actor, effect)
```

Return the integrated ai death effect value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `effect` | `dynamic` | — | effect value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L869)

<a id="function-function-miniquake2-game-integration-baseq2-integratedaifindtargets-function-integratedaifindtargets-targetname-src-miniquake2-game-integration-baseq2-ml-615846373"></a>
### integratedAIFindTargets

```ml
function integratedAIFindTargets(targetName)
```

Find integrated ai targets.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `targetName` | `dynamic` | — | targetName value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L1292)

<a id="function-function-miniquake2-game-integration-baseq2-integratedaikillbox-function-integratedaikillbox-actor-src-miniquake2-game-integration-baseq2-ml-1249645886"></a>
### integratedAIKillBox

```ml
function integratedAIKillBox(actor)
```

Kill integrated ai box.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L1317)

<a id="function-function-miniquake2-game-integration-baseq2-integratedailinkactor-function-integratedailinkactor-actor-src-miniquake2-game-integration-baseq2-ml-1881853294"></a>
### integratedAILinkActor

```ml
function integratedAILinkActor(actor)
```

Link integrated ai actor.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L720)

<a id="function-function-miniquake2-game-integration-baseq2-integratedailog-function-integratedailog-message-src-miniquake2-game-integration-baseq2-ml-1184706114"></a>
### integratedAILog

```ml
function integratedAILog(message)
```

Return the integrated ai log value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `message` | `dynamic` | — | Human-readable message associated with the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L1336)

<a id="function-function-miniquake2-game-integration-baseq2-integratedaimovetogoal-function-integratedaimovetogoal-actor-distance-src-miniquake2-game-integration-baseq2-ml-1209531163"></a>
### integratedAIMoveToGoal

```ml
function integratedAIMoveToGoal(actor, distance)
```

Move integrated ai to goal.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `distance` | `dynamic` | — | distance value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L822)

<a id="function-function-miniquake2-game-integration-baseq2-integratedaipointcontents-function-integratedaipointcontents-point-src-miniquake2-game-integration-baseq2-ml-1299652273"></a>
### integratedAIPointContents

```ml
function integratedAIPointContents(point)
```

Return the integrated ai point contents value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `point` | `dynamic` | — | point value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L710)

<a id="function-function-miniquake2-game-integration-baseq2-integratedaisound-function-integratedaisound-actor-soundname-channel-attenuation-src-miniquake2-game-integration-baseq2-ml-1175128573"></a>
### integratedAISound

```ml
function integratedAISound(actor, soundName, channel, attenuation)
```

Return the integrated ai sound value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `soundName` | `dynamic` | — | soundName value consumed by this operation. |
| `channel` | `dynamic` | — | channel value consumed by this operation. |
| `attenuation` | `dynamic` | — | attenuation value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L842)

<a id="function-function-miniquake2-game-integration-baseq2-integratedaisoundindex-function-integratedaisoundindex-soundname-src-miniquake2-game-integration-baseq2-ml-1288320433"></a>
### integratedAISoundIndex

```ml
function integratedAISoundIndex(soundName)
```

Return the integrated ai sound index.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `soundName` | `dynamic` | — | soundName value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L1327)

<a id="function-function-miniquake2-game-integration-baseq2-integratedaitempentity-function-integratedaitempentity-actor-effecttype-src-miniquake2-game-integration-baseq2-ml-1895896653"></a>
### integratedAITempEntity

```ml
function integratedAITempEntity(actor, effectType)
```

Return the integrated ai temp entity value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `effectType` | `dynamic` | — | effectType value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L854)

<a id="function-function-miniquake2-game-integration-baseq2-integratedaitouchtriggers-function-integratedaitouchtriggers-actor-src-miniquake2-game-integration-baseq2-ml-193526260"></a>
### integratedAITouchTriggers

```ml
function integratedAITouchTriggers(actor)
```

Handle integrated ai triggers.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L731)

<a id="function-function-miniquake2-game-integration-baseq2-integratedaitrace-function-integratedaitrace-start-mins-maxs-finish-ignore-mask-src-miniquake2-game-integration-baseq2-ml-374257924"></a>
### integratedAITrace

```ml
function integratedAITrace(start, mins, maxs, finish, ignore, mask)
```

Trace integrated ai.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `start` | `dynamic` | — | start value consumed by this operation. |
| `mins` | `dynamic` | — | mins value consumed by this operation. |
| `maxs` | `dynamic` | — | maxs value consumed by this operation. |
| `finish` | `dynamic` | — | finish value consumed by this operation. |
| `ignore` | `dynamic` | — | ignore value consumed by this operation. |
| `mask` | `dynamic` | — | mask value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L688)

<a id="function-function-miniquake2-game-integration-baseq2-integratedaiwalkmove-function-integratedaiwalkmove-actor-yaw-distance-src-miniquake2-game-integration-baseq2-ml-1453659106"></a>
### integratedAIWalkMove

```ml
function integratedAIWalkMove(actor, yaw, distance)
```

Move integrated ai walk.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `yaw` | `dynamic` | — | yaw value consumed by this operation. |
| `distance` | `dynamic` | — | distance value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L800)

- [miniquake2.game.integration.baseq2.IntegratedBaseQ2](Type-miniquake2-game-integration-baseq2-integratedbaseq2-495913528.md) — struct
<a id="function-function-miniquake2-game-integration-baseq2-integratedbodygibs-function-integratedbodygibs-origin-damage-count-src-miniquake2-game-integration-baseq2-ml-1349819143"></a>
### integratedBodyGibs

```ml
function integratedBodyGibs(origin, damage, count)
```

Spawn the four organic chunks emitted by p_client.c::body_die.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `origin` | `dynamic` | — | origin value consumed by this operation. |
| `damage` | `dynamic` | — | damage value consumed by this operation. |
| `count` | `dynamic` | — | Number of items or units to process. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L1014)

<a id="function-function-miniquake2-game-integration-baseq2-integratedcandamage-function-integratedcandamage-target-origin-src-miniquake2-game-integration-baseq2-ml-1355250882"></a>
### integratedCanDamage

```ml
function integratedCanDamage(target, origin)
```

Report whether integrated can damage.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `target` | `dynamic` | — | target value consumed by this operation. |
| `origin` | `dynamic` | — | origin value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L1724)

<a id="function-function-miniquake2-game-integration-baseq2-integratedclockseconds-function-integratedclockseconds-src-miniquake2-game-integration-baseq2-ml-1958906579"></a>
### integratedClockSeconds

```ml
function integratedClockSeconds()
```

Return the integrated clock seconds value.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L2848)

<a id="function-function-miniquake2-game-integration-baseq2-integratedcombatpointtransition-function-integratedcombatpointtransition-actorentity-point-nexttarget-hold-clearcombatpoint-src-miniquake2-game-integration-baseq2-ml-1709301095"></a>
### integratedCombatPointTransition

```ml
function integratedCombatPointTransition(actorEntity, point, nextTarget, hold, clearCombatPoint)
```

Return the integrated combat point transition value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actorEntity` | `dynamic` | — | actorEntity value consumed by this operation. |
| `point` | `dynamic` | — | point value consumed by this operation. |
| `nextTarget` | `dynamic` | — | nextTarget value consumed by this operation. |
| `hold` | `dynamic` | — | hold value consumed by this operation. |
| `clearCombatPoint` | `dynamic` | — | clearCombatPoint value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L2836)

<a id="function-function-miniquake2-game-integration-baseq2-integratedconsumekeyitem-function-integratedconsumekeyitem-activator-itemclassname-src-miniquake2-game-integration-baseq2-ml-1674104014"></a>
### integratedConsumeKeyItem

```ml
function integratedConsumeKeyItem(activator, itemClassName)
```

Consume integrated key item.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `activator` | `dynamic` | — | activator value consumed by this operation. |
| `itemClassName` | `dynamic` | — | itemClassName value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L2618)

<a id="function-function-miniquake2-game-integration-baseq2-integrateddamageeffect-function-integrateddamageeffect-point-direction-blood-bullet-src-miniquake2-game-integration-baseq2-ml-1160100550"></a>
### integratedDamageEffect

```ml
function integratedDamageEffect(point, direction, blood, bullet)
```

Return the integrated damage effect value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `point` | `dynamic` | — | point value consumed by this operation. |
| `direction` | `dynamic` | — | direction value consumed by this operation. |
| `blood` | `dynamic` | — | blood value consumed by this operation. |
| `bullet` | `dynamic` | — | bullet value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L2950)

<a id="function-function-miniquake2-game-integration-baseq2-integrateddodge-function-integrateddodge-owner-start-direction-speed-src-miniquake2-game-integration-baseq2-ml-1163842456"></a>
### integratedDodge

```ml
function integratedDodge(owner, start, direction, speed)
```

Return the integrated dodge value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `owner` | `dynamic` | — | owner value consumed by this operation. |
| `start` | `dynamic` | — | start value consumed by this operation. |
| `direction` | `dynamic` | — | direction value consumed by this operation. |
| `speed` | `dynamic` | — | speed value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L3131)

- [miniquake2.game.integration.baseq2.IntegratedDynamicClip](Type-miniquake2-game-integration-baseq2-integrateddynamicclip-1524866313.md) — struct
<a id="function-function-miniquake2-game-integration-baseq2-integratedexitdamage-function-integratedexitdamage-targetentity-amount-src-miniquake2-game-integration-baseq2-ml-1062798313"></a>
### integratedExitDamage

```ml
function integratedExitDamage(targetEntity, amount)
```

use_target_changelevel's no-exit punishment is ordinary T_Damage with a large knockback and MOD_EXIT. Route it through the same live target adapter as weapon and projectile damage so players, monsters and brush entities all receive their normal pain/death synchronization.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `targetEntity` | `dynamic` | — | targetEntity value consumed by this operation. |
| `amount` | `dynamic` | — | amount value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L1948)

<a id="function-function-miniquake2-game-integration-baseq2-integratedfinddeadmonster-function-integratedfinddeadmonster-medic-src-miniquake2-game-integration-baseq2-ml-1221206955"></a>
### integratedFindDeadMonster

```ml
function integratedFindDeadMonster(medic)
```

Find integrated dead monster.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `medic` | `dynamic` | — | medic value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L1126)

<a id="function-function-miniquake2-game-integration-baseq2-integratedhaskeyitem-function-integratedhaskeyitem-activator-itemclassname-src-miniquake2-game-integration-baseq2-ml-1680685630"></a>
### integratedHasKeyItem

```ml
function integratedHasKeyItem(activator, itemClassName)
```

Report whether integrated has key item.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `activator` | `dynamic` | — | activator value consumed by this operation. |
| `itemClassName` | `dynamic` | — | itemClassName value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L2605)

<a id="function-function-miniquake2-game-integration-baseq2-integratedinfantrydeathfire-function-integratedinfantrydeathfire-runtime-actor-timelineoffset-src-miniquake2-game-integration-baseq2-ml-625438888"></a>
### integratedInfantryDeathFire

```ml
function integratedInfantryDeathFire(runtime, actor, timelineOffset)
```

Fire integrated infantry death.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `timelineOffset` | `dynamic` | — | timelineOffset value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L1172)

<a id="function-function-miniquake2-game-integration-baseq2-integratedlightstyle-function-integratedlightstyle-style-pattern-src-miniquake2-game-integration-baseq2-ml-1527748424"></a>
### integratedLightStyle

```ml
function integratedLightStyle(style, pattern)
```

Return the integrated light style value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `style` | `dynamic` | — | style value consumed by this operation. |
| `pattern` | `dynamic` | — | pattern value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L2873)

<a id="function-function-miniquake2-game-integration-baseq2-integratedmediccableevent-function-integratedmediccableevent-runtime-medic-eventindex-src-miniquake2-game-integration-baseq2-ml-539430433"></a>
### integratedMedicCableEvent

```ml
function integratedMedicCableEvent(runtime, medic, eventIndex)
```

Return the integrated medic cable event value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |
| `medic` | `dynamic` | — | medic value consumed by this operation. |
| `eventIndex` | `dynamic` | — | Zero-based index of event. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L5317)

<a id="function-function-miniquake2-game-integration-baseq2-integratedmediccorpsevisible-function-integratedmediccorpsevisible-runtime-medic-patient-src-miniquake2-game-integration-baseq2-ml-1440982756"></a>
### integratedMedicCorpseVisible

```ml
function integratedMedicCorpseVisible(runtime, medic, patient)
```

Report whether integrated medic corpse visible.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |
| `medic` | `dynamic` | — | medic value consumed by this operation. |
| `patient` | `dynamic` | — | patient value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L1112)

<a id="function-function-miniquake2-game-integration-baseq2-integratedmonsterbynumber-function-integratedmonsterbynumber-runtime-number-src-miniquake2-game-integration-baseq2-ml-10227664"></a>
### integratedMonsterByNumber

```ml
function integratedMonsterByNumber(runtime, number)
```

Return the integrated monster by number.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |
| `number` | `dynamic` | — | number value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L1509)

<a id="function-function-miniquake2-game-integration-baseq2-integratedmonsterdrainbeam-function-integratedmonsterdrainbeam-runtime-actor-start-endposition-src-miniquake2-game-integration-baseq2-ml-102751030"></a>
### integratedMonsterDrainBeam

```ml
function integratedMonsterDrainBeam(runtime, actor, start, endPosition)
```

Drain integrated monster beam.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `start` | `dynamic` | — | start value consumed by this operation. |
| `endPosition` | `dynamic` | — | endPosition value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L5210)

<a id="function-function-miniquake2-game-integration-baseq2-integratedmonstermediccable-function-integratedmonstermediccable-runtime-medic-cableoffsetindex-src-miniquake2-game-integration-baseq2-ml-1255086883"></a>
### integratedMonsterMedicCable

```ml
function integratedMonsterMedicCable(runtime, medic, cableOffsetIndex)
```

Return the integrated monster medic cable value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |
| `medic` | `dynamic` | — | medic value consumed by this operation. |
| `cableOffsetIndex` | `dynamic` | — | Zero-based index of cable offset. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L5258)

<a id="function-function-miniquake2-game-integration-baseq2-integratedmonstermuzzleflash-function-integratedmonstermuzzleflash-runtime-actor-muzzleflash-origin-src-miniquake2-game-integration-baseq2-ml-1238500461"></a>
### integratedMonsterMuzzleFlash

```ml
function integratedMonsterMuzzleFlash(runtime, actor, muzzleFlash, origin)
```

Return the integrated monster muzzle flash value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `muzzleFlash` | `dynamic` | — | muzzleFlash value consumed by this operation. |
| `origin` | `dynamic` | — | origin value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L5196)

<a id="function-function-miniquake2-game-integration-baseq2-integratedmonsterproxyuse-function-integratedmonsterproxyuse-entity-other-activator-world-src-miniquake2-game-integration-baseq2-ml-98394759"></a>
### integratedMonsterProxyUse

```ml
function integratedMonsterProxyUse(entity, other, activator, world)
```

Use integrated monster proxy.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `other` | `dynamic` | — | other value consumed by this operation. |
| `activator` | `dynamic` | — | activator value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L1397)

<a id="function-function-miniquake2-game-integration-baseq2-integratedplayerbynumber-function-integratedplayerbynumber-runtime-number-src-miniquake2-game-integration-baseq2-ml-1465195438"></a>
### integratedPlayerByNumber

```ml
function integratedPlayerByNumber(runtime, number)
```

Return the integrated player by number.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |
| `number` | `dynamic` | — | number value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L1498)

<a id="function-function-miniquake2-game-integration-baseq2-integratedplayerfire-function-integratedplayerfire-gameplayplayer-registry-src-miniquake2-game-integration-baseq2-ml-1163063165"></a>
### integratedPlayerFire

```ml
function integratedPlayerFire(gameplayPlayer, registry)
```

Bridge the stock p_weapon state machine to authoritative edicts, protocol effects and damage while preserving the component-only fallback used by isolated gameplay tests.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `gameplayPlayer` | `dynamic` | — | gameplayPlayer value consumed by this operation. |
| `registry` | `dynamic` | — | registry value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L4512)

<a id="function-function-miniquake2-game-integration-baseq2-integratedplayermuzzleflash-function-integratedplayermuzzleflash-runtime-shooter-item-shots-silenced-src-miniquake2-game-integration-baseq2-ml-1443422260"></a>
### integratedPlayerMuzzleFlash

```ml
function integratedPlayerMuzzleFlash(runtime, shooter, item, shots, silenced)
```

Return the integrated player muzzle flash value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |
| `shooter` | `dynamic` | — | shooter value consumed by this operation. |
| `item` | `dynamic` | — | item value consumed by this operation. |
| `shots` | `dynamic` | — | shots value consumed by this operation. |
| `silenced` | `dynamic` | — | silenced value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L4479)

<a id="function-function-miniquake2-game-integration-baseq2-integratedplayernoise-function-integratedplayernoise-owner-position-noisetype-src-miniquake2-game-integration-baseq2-ml-1303405569"></a>
### integratedPlayerNoise

```ml
function integratedPlayerNoise(owner, position, noiseType)
```

Return the integrated player noise value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `owner` | `dynamic` | — | owner value consumed by this operation. |
| `position` | `dynamic` | — | position value consumed by this operation. |
| `noiseType` | `dynamic` | — | noiseType value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L3068)

<a id="function-function-miniquake2-game-integration-baseq2-integratedplayernoiseownernumber-function-integratedplayernoiseownernumber-owner-src-miniquake2-game-integration-baseq2-ml-2107783592"></a>
### integratedPlayerNoiseOwnerNumber

```ml
function integratedPlayerNoiseOwnerNumber(owner)
```

Resolve either a WeaponTarget or GameplayPlayer to its engine edict number.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `owner` | `dynamic` | — | owner value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L3047)

<a id="function-function-miniquake2-game-integration-baseq2-integratedpowerarmoreffect-function-integratedpowerarmoreffect-point-direction-armortype-src-miniquake2-game-integration-baseq2-ml-2130626407"></a>
### integratedPowerArmorEffect

```ml
function integratedPowerArmorEffect(point, direction, armorType)
```

Emit the stock power-screen or power-shield impact feedback.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `point` | `dynamic` | — | point value consumed by this operation. |
| `direction` | `dynamic` | — | direction value consumed by this operation. |
| `armorType` | `dynamic` | — | armorType value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L2265)

<a id="global-global-miniquake2-game-integration-baseq2-integratedprojectilefreetotal-integratedprojectilefreetotal-src-miniquake2-game-integration-baseq2-ml-90262251"></a>
### integratedProjectileFreeTotal

```ml
integratedProjectileFreeTotal
```

Stores module-wide integrated projectile free total state for the miniquake2 game integration baseq2 module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L128)

<a id="global-global-miniquake2-game-integration-baseq2-integratedprojectilelinktotal-integratedprojectilelinktotal-src-miniquake2-game-integration-baseq2-ml-2101375587"></a>
### integratedProjectileLinkTotal

```ml
integratedProjectileLinkTotal
```

Stores module-wide integrated projectile link total state for the miniquake2 game integration baseq2 module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L126)

<a id="function-function-miniquake2-game-integration-baseq2-integratedpropproxyuse-function-integratedpropproxyuse-entity-other-activator-world-src-miniquake2-game-integration-baseq2-ml-749568219"></a>
### integratedPropProxyUse

```ml
function integratedPropProxyUse(entity, other, activator, world)
```

Use integrated prop proxy.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `other` | `dynamic` | — | other value consumed by this operation. |
| `activator` | `dynamic` | — | activator value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L1347)

<a id="function-function-miniquake2-game-integration-baseq2-integratedradiustargets-function-integratedradiustargets-origin-radius-src-miniquake2-game-integration-baseq2-ml-1019675429"></a>
### integratedRadiusTargets

```ml
function integratedRadiusTargets(origin, radius)
```

Return the integrated radius targets value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `origin` | `dynamic` | — | origin value consumed by this operation. |
| `radius` | `dynamic` | — | radius value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L1732)

<a id="function-function-miniquake2-game-integration-baseq2-integratedrandomindex-function-integratedrandomindex-count-src-miniquake2-game-integration-baseq2-ml-1594398996"></a>
### integratedRandomIndex

```ml
function integratedRandomIndex(count)
```

Return the integrated random index.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `count` | `dynamic` | — | Number of items or units to process. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L3203)

<a id="function-function-miniquake2-game-integration-baseq2-integratedrandominteger-function-integratedrandominteger-src-miniquake2-game-integration-baseq2-ml-1679333379"></a>
### integratedRandomInteger

```ml
function integratedRandomInteger()
```

Return the integrated random integer value.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L3194)

<a id="function-function-miniquake2-game-integration-baseq2-integratedrandomsigned-function-integratedrandomsigned-src-miniquake2-game-integration-baseq2-ml-1163404499"></a>
### integratedRandomSigned

```ml
function integratedRandomSigned()
```

Return the integrated random signed value.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L3178)

<a id="function-function-miniquake2-game-integration-baseq2-integratedrandomunit-function-integratedrandomunit-src-miniquake2-game-integration-baseq2-ml-333337323"></a>
### integratedRandomUnit

```ml
function integratedRandomUnit()
```

Return the integrated random unit value.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L3186)

<a id="function-function-miniquake2-game-integration-baseq2-integratedreactionframeevent-function-integratedreactionframeevent-actor-plan-timelineoffset-eventkind-src-miniquake2-game-integration-baseq2-ml-336404131"></a>
### integratedReactionFrameEvent

```ml
function integratedReactionFrameEvent(actor, plan, timelineOffset, eventKind)
```

Return the integrated reaction frame event value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `plan` | `dynamic` | — | plan value consumed by this operation. |
| `timelineOffset` | `dynamic` | — | timelineOffset value consumed by this operation. |
| `eventKind` | `dynamic` | — | eventKind value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L1241)

<a id="function-function-miniquake2-game-integration-baseq2-integratedresolvekeyitem-function-integratedresolvekeyitem-itemclassname-src-miniquake2-game-integration-baseq2-ml-775053303"></a>
### integratedResolveKeyItem

```ml
function integratedResolveKeyItem(itemClassName)
```

Resolve integrated key item.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `itemClassName` | `dynamic` | — | itemClassName value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L2583)

<a id="function-function-miniquake2-game-integration-baseq2-integratedresurrectmonster-function-integratedresurrectmonster-runtime-medic-patient-src-miniquake2-game-integration-baseq2-ml-1560751928"></a>
### integratedResurrectMonster

```ml
function integratedResurrectMonster(runtime, medic, patient)
```

Return the integrated resurrect monster value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |
| `medic` | `dynamic` | — | medic value consumed by this operation. |
| `patient` | `dynamic` | — | patient value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L5225)

<a id="function-function-miniquake2-game-integration-baseq2-integratedsoldierdeathfire-function-integratedsoldierdeathfire-runtime-actor-timelineoffset-src-miniquake2-game-integration-baseq2-ml-623818996"></a>
### integratedSoldierDeathFire

```ml
function integratedSoldierDeathFire(runtime, actor, timelineOffset)
```

Fire integrated soldier death.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `timelineOffset` | `dynamic` | — | timelineOffset value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L1196)

<a id="function-function-miniquake2-game-integration-baseq2-integratedsourcenumber-function-integratedsourcenumber-source-src-miniquake2-game-integration-baseq2-ml-577938072"></a>
### integratedSourceNumber

```ml
function integratedSourceNumber(source)
```

Return the integrated source number.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `source` | `dynamic` | — | source value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L1904)

<a id="function-function-miniquake2-game-integration-baseq2-integratedspawnmonster-function-integratedspawnmonster-classname-parent-src-miniquake2-game-integration-baseq2-ml-522970112"></a>
### integratedSpawnMonster

```ml
function integratedSpawnMonster(className, parent)
```

Spawn integrated monster.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `className` | `dynamic` | — | className value consumed by this operation. |
| `parent` | `dynamic` | — | parent value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L1429)

<a id="function-function-miniquake2-game-integration-baseq2-integratedturretacquire-function-integratedturretacquire-driver-world-src-miniquake2-game-integration-baseq2-ml-1760884969"></a>
### integratedTurretAcquire

```ml
function integratedTurretAcquire(driver, world)
```

Return the integrated turret acquire value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `driver` | `dynamic` | — | driver value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L3226)

<a id="function-function-miniquake2-game-integration-baseq2-integratedturretcontrol-function-integratedturretcontrol-src-miniquake2-game-integration-baseq2-ml-730878163"></a>
### integratedTurretControl

```ml
function integratedTurretControl()
```

Return the integrated turret control value.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L3405)

<a id="function-function-miniquake2-game-integration-baseq2-integratedturretcrushdamage-function-integratedturretcrushdamage-targetentity-inflictor-attacker-amount-knockback-means-world-src-miniquake2-game-integration-baseq2-ml-1611651697"></a>
### integratedTurretCrushDamage

```ml
function integratedTurretCrushDamage(targetEntity, inflictor, attacker, amount, knockback, means, world)
```

Return the integrated turret crush damage value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `targetEntity` | `dynamic` | — | targetEntity value consumed by this operation. |
| `inflictor` | `dynamic` | — | inflictor value consumed by this operation. |
| `attacker` | `dynamic` | — | attacker value consumed by this operation. |
| `amount` | `dynamic` | — | amount value consumed by this operation. |
| `knockback` | `dynamic` | — | knockback value consumed by this operation. |
| `means` | `dynamic` | — | means value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L3322)

<a id="function-function-miniquake2-game-integration-baseq2-integratedturretdriverdie-function-integratedturretdriverdie-driver-inflictor-attacker-damage-point-world-src-miniquake2-game-integration-baseq2-ml-1989684203"></a>
### integratedTurretDriverDie

```ml
function integratedTurretDriverDie(driver, inflictor, attacker, damage, point, world)
```

Handle integrated turret driver.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `driver` | `dynamic` | — | driver value consumed by this operation. |
| `inflictor` | `dynamic` | — | inflictor value consumed by this operation. |
| `attacker` | `dynamic` | — | attacker value consumed by this operation. |
| `damage` | `dynamic` | — | damage value consumed by this operation. |
| `point` | `dynamic` | — | point value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L3370)

<a id="function-function-miniquake2-game-integration-baseq2-integratedturretdriverspawn-function-integratedturretdriverspawn-driver-world-src-miniquake2-game-integration-baseq2-ml-1517580779"></a>
### integratedTurretDriverSpawn

```ml
function integratedTurretDriverSpawn(driver, world)
```

Spawn integrated turret driver.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `driver` | `dynamic` | — | driver value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L3350)

<a id="function-function-miniquake2-game-integration-baseq2-integratedturretdriveruse-function-integratedturretdriveruse-driver-other-activator-world-src-miniquake2-game-integration-baseq2-ml-624164926"></a>
### integratedTurretDriverUse

```ml
function integratedTurretDriverUse(driver, other, activator, world)
```

Use integrated turret driver.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `driver` | `dynamic` | — | driver value consumed by this operation. |
| `other` | `dynamic` | — | other value consumed by this operation. |
| `activator` | `dynamic` | — | activator value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L3359)

<a id="function-function-miniquake2-game-integration-baseq2-integratedturretfire-function-integratedturretfire-attacker-start-direction-damage-speed-splashradius-world-src-miniquake2-game-integration-baseq2-ml-1406885504"></a>
### integratedTurretFire

```ml
function integratedTurretFire(attacker, start, direction, damage, speed, splashRadius, world)
```

Fire integrated turret.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `attacker` | `dynamic` | — | attacker value consumed by this operation. |
| `start` | `dynamic` | — | start value consumed by this operation. |
| `direction` | `dynamic` | — | direction value consumed by this operation. |
| `damage` | `dynamic` | — | damage value consumed by this operation. |
| `speed` | `dynamic` | — | speed value consumed by this operation. |
| `splashRadius` | `dynamic` | — | splashRadius value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L3285)

<a id="function-function-miniquake2-game-integration-baseq2-integratedturretpositionedsound-function-integratedturretpositionedsound-origin-entity-soundname-world-src-miniquake2-game-integration-baseq2-ml-48961184"></a>
### integratedTurretPositionedSound

```ml
function integratedTurretPositionedSound(origin, entity, soundName, world)
```

Return the integrated turret positioned sound value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `origin` | `dynamic` | — | origin value consumed by this operation. |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `soundName` | `dynamic` | — | soundName value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L3301)

<a id="function-function-miniquake2-game-integration-baseq2-integratedturretrandomunit-function-integratedturretrandomunit-src-miniquake2-game-integration-baseq2-ml-1188482963"></a>
### integratedTurretRandomUnit

```ml
function integratedTurretRandomUnit()
```

Return the integrated turret random unit value.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L3265)

<a id="function-function-miniquake2-game-integration-baseq2-integratedturretskillvalue-function-integratedturretskillvalue-src-miniquake2-game-integration-baseq2-ml-1119415987"></a>
### integratedTurretSkillValue

```ml
function integratedTurretSkillValue()
```

Return the integrated turret skill value.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L3270)

<a id="function-function-miniquake2-game-integration-baseq2-integratedturretvisible-function-integratedturretvisible-driver-enemy-world-src-miniquake2-game-integration-baseq2-ml-614270235"></a>
### integratedTurretVisible

```ml
function integratedTurretVisible(driver, enemy, world)
```

Report whether integrated turret visible.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `driver` | `dynamic` | — | driver value consumed by this operation. |
| `enemy` | `dynamic` | — | enemy value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L3246)

<a id="function-function-miniquake2-game-integration-baseq2-integratedweaponcallbacks-function-integratedweaponcallbacks-src-miniquake2-game-integration-baseq2-ml-446038913"></a>
### integratedWeaponCallbacks

```ml
function integratedWeaponCallbacks()
```

Return the integrated weapon callbacks value.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L3452)

<a id="function-function-miniquake2-game-integration-baseq2-integratedweaponcontents-function-integratedweaponcontents-point-src-miniquake2-game-integration-baseq2-ml-249788467"></a>
### integratedWeaponContents

```ml
function integratedWeaponContents(point)
```

Return the integrated weapon contents value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `point` | `dynamic` | — | point value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L1714)

<a id="function-function-miniquake2-game-integration-baseq2-integratedweapondamage-function-integratedweapondamage-combatant-request-src-miniquake2-game-integration-baseq2-ml-1911540905"></a>
### integratedWeaponDamage

```ml
function integratedWeaponDamage(combatant, request)
```

Return the integrated weapon damage value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `combatant` | `dynamic` | — | combatant value consumed by this operation. |
| `request` | `dynamic` | — | request value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L1750)

<a id="function-function-miniquake2-game-integration-baseq2-integratedweaponeffect-function-integratedweaponeffect-effect-src-miniquake2-game-integration-baseq2-ml-7925684"></a>
### integratedWeaponEffect

```ml
function integratedWeaponEffect(effect)
```

Return the integrated weapon effect value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `effect` | `dynamic` | — | effect value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L2883)

<a id="function-function-miniquake2-game-integration-baseq2-integratedweaponfree-function-integratedweaponfree-entity-src-miniquake2-game-integration-baseq2-ml-134512102"></a>
### integratedWeaponFree

```ml
function integratedWeaponFree(entity)
```

Release integrated weapon.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L3035)

<a id="function-function-miniquake2-game-integration-baseq2-integratedweaponlink-function-integratedweaponlink-entity-src-miniquake2-game-integration-baseq2-ml-1770825270"></a>
### integratedWeaponLink

```ml
function integratedWeaponLink(entity)
```

Link integrated weapon.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L2987)

<a id="function-function-miniquake2-game-integration-baseq2-integratedweaponsound-function-integratedweaponsound-entity-soundname-src-miniquake2-game-integration-baseq2-ml-1055191514"></a>
### integratedWeaponSound

```ml
function integratedWeaponSound(entity, soundName)
```

Return the integrated weapon sound value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `soundName` | `dynamic` | — | soundName value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L2968)

<a id="function-function-miniquake2-game-integration-baseq2-integratedweapontargets-function-integratedweapontargets-runtime-src-miniquake2-game-integration-baseq2-ml-987940343"></a>
### integratedWeaponTargets

```ml
function integratedWeaponTargets(runtime)
```

Return the integrated weapon targets value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L1603)

<a id="function-function-miniquake2-game-integration-baseq2-integratedweapontrace-function-integratedweapontrace-start-mins-maxs-finish-ignore-mask-src-miniquake2-game-integration-baseq2-ml-510636748"></a>
### integratedWeaponTrace

```ml
function integratedWeaponTrace(start, mins, maxs, finish, ignore, mask)
```

Trace integrated weapon.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `start` | `dynamic` | — | start value consumed by this operation. |
| `mins` | `dynamic` | — | mins value consumed by this operation. |
| `maxs` | `dynamic` | — | maxs value consumed by this operation. |
| `finish` | `dynamic` | — | finish value consumed by this operation. |
| `ignore` | `dynamic` | — | ignore value consumed by this operation. |
| `mask` | `dynamic` | — | mask value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L1675)

<a id="function-function-miniquake2-game-integration-baseq2-integratedworldactor-function-integratedworldactor-number-src-miniquake2-game-integration-baseq2-ml-974952576"></a>
### integratedWorldActor

```ml
function integratedWorldActor(number)
```

Return the integrated world actor value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `number` | `dynamic` | — | number value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L2668)

<a id="function-function-miniquake2-game-integration-baseq2-integratedworldaiactivator-function-integratedworldaiactivator-source-src-miniquake2-game-integration-baseq2-ml-2094155512"></a>
### integratedWorldAIActivator

```ml
function integratedWorldAIActivator(source)
```

Return the integrated world ai activator value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `source` | `dynamic` | — | source value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L1373)

<a id="function-function-miniquake2-game-integration-baseq2-integratedworldaitarget-function-integratedworldaitarget-entity-src-miniquake2-game-integration-baseq2-ml-1068003354"></a>
### integratedWorldAITarget

```ml
function integratedWorldAITarget(entity)
```

Return the integrated world ai target value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L2739)

<a id="function-function-miniquake2-game-integration-baseq2-integratedworldcollisionproxy-function-integratedworldcollisionproxy-runtime-number-src-miniquake2-game-integration-baseq2-ml-1143347368"></a>
### integratedWorldCollisionProxy

```ml
function integratedWorldCollisionProxy(runtime, number)
```

Return the integrated world collision proxy value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |
| `number` | `dynamic` | — | number value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L5976)

<a id="function-function-miniquake2-game-integration-baseq2-integratedworlddamage-function-integratedworlddamage-targetentity-inflictor-attacker-amount-means-src-miniquake2-game-integration-baseq2-ml-1896514086"></a>
### integratedWorldDamage

```ml
function integratedWorldDamage(targetEntity, inflictor, attacker, amount, means)
```

Return the integrated world damage value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `targetEntity` | `dynamic` | — | targetEntity value consumed by this operation. |
| `inflictor` | `dynamic` | — | inflictor value consumed by this operation. |
| `attacker` | `dynamic` | — | attacker value consumed by this operation. |
| `amount` | `dynamic` | — | amount value consumed by this operation. |
| `means` | `dynamic` | — | means value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L1921)

<a id="function-function-miniquake2-game-integration-baseq2-integratedworlddebris-function-integratedworlddebris-kind-origin-speed-count-src-miniquake2-game-integration-baseq2-ml-346403457"></a>
### integratedWorldDebris

```ml
function integratedWorldDebris(kind, origin, speed, count)
```

Match g_misc.c ThrowDebris: model-backed, non-solid bounce entities with a five-to-ten-second lifetime. Unlike monster gibs they carry no EF_GIB trail.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `kind` | `dynamic` | — | kind value consumed by this operation. |
| `origin` | `dynamic` | — | origin value consumed by this operation. |
| `speed` | `dynamic` | — | speed value consumed by this operation. |
| `count` | `dynamic` | — | Number of items or units to process. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L961)

<a id="function-function-miniquake2-game-integration-baseq2-integratedworldearthquake-function-integratedworldearthquake-entity-speed-playsound-src-miniquake2-game-integration-baseq2-ml-231970354"></a>
### integratedWorldEarthquake

```ml
function integratedWorldEarthquake(entity, speed, playSound)
```

Return the integrated world earthquake value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `speed` | `dynamic` | — | speed value consumed by this operation. |
| `playSound` | `dynamic` | — | playSound value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L2185)

<a id="function-function-miniquake2-game-integration-baseq2-integratedworldeffect-function-integratedworldeffect-kind-origin-style-count-src-miniquake2-game-integration-baseq2-ml-847020627"></a>
### integratedWorldEffect

```ml
function integratedWorldEffect(kind, origin, style, count)
```

World state machines use this callback for stock temp entities and visible barrel debris. Permanent protocol edicts are allocated only for the chunks.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `kind` | `dynamic` | — | kind value consumed by this operation. |
| `origin` | `dynamic` | — | origin value consumed by this operation. |
| `style` | `dynamic` | — | style value consumed by this operation. |
| `count` | `dynamic` | — | Number of items or units to process. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L1078)

<a id="function-function-miniquake2-game-integration-baseq2-integratedworldfireblaster-function-integratedworldfireblaster-entity-direction-damage-speed-src-miniquake2-game-integration-baseq2-ml-458362647"></a>
### integratedWorldFireBlaster

```ml
function integratedWorldFireBlaster(entity, direction, damage, speed)
```

Fire integrated world blaster.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `direction` | `dynamic` | — | direction value consumed by this operation. |
| `damage` | `dynamic` | — | damage value consumed by this operation. |
| `speed` | `dynamic` | — | speed value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L2214)

<a id="function-function-miniquake2-game-integration-baseq2-integratedworldkillbox-function-integratedworldkillbox-entity-src-miniquake2-game-integration-baseq2-ml-2106639714"></a>
### integratedWorldKillBox

```ml
function integratedWorldKillBox(entity)
```

Kill integrated world box.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L2233)

<a id="function-function-miniquake2-game-integration-baseq2-integratedworldlasersparks-function-integratedworldlasersparks-origin-normal-count-color-src-miniquake2-game-integration-baseq2-ml-1679377042"></a>
### integratedWorldLaserSparks

```ml
function integratedWorldLaserSparks(origin, normal, count, color)
```

Return the integrated world laser sparks value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `origin` | `dynamic` | — | origin value consumed by this operation. |
| `normal` | `dynamic` | — | normal value consumed by this operation. |
| `count` | `dynamic` | — | Number of items or units to process. |
| `color` | `dynamic` | — | color value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L2167)

<a id="function-function-miniquake2-game-integration-baseq2-integratedworldlasertrace-function-integratedworldlasertrace-start-finish-ignore-src-miniquake2-game-integration-baseq2-ml-1617324712"></a>
### integratedWorldLaserTrace

```ml
function integratedWorldLaserTrace(start, finish, ignore)
```

Merge the engine world trace with managed player, monster and world bounds. The nearest eligible hit wins; scratch records are reused on the server thread.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `start` | `dynamic` | — | start value consumed by this operation. |
| `finish` | `dynamic` | — | finish value consumed by this operation. |
| `ignore` | `dynamic` | — | ignore value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L2011)

<a id="function-function-miniquake2-game-integration-baseq2-integratedworldmeans-function-integratedworldmeans-means-src-miniquake2-game-integration-baseq2-ml-1833680795"></a>
### integratedWorldMeans

```ml
function integratedWorldMeans(means)
```

Return the integrated world means value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `means` | `dynamic` | — | means value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L1891)

<a id="function-function-miniquake2-game-integration-baseq2-integratedworldplayer-function-integratedworldplayer-activator-src-miniquake2-game-integration-baseq2-ml-292387232"></a>
### integratedWorldPlayer

```ml
function integratedWorldPlayer(activator)
```

Return the integrated world player value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `activator` | `dynamic` | — | activator value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L2592)

<a id="function-function-miniquake2-game-integration-baseq2-integratedworldpointcontents-function-integratedworldpointcontents-runtime-point-src-miniquake2-game-integration-baseq2-ml-1673743689"></a>
### integratedWorldPointContents

```ml
function integratedWorldPointContents(runtime, point)
```

Return the integrated world point contents value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |
| `point` | `dynamic` | — | point value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L6018)

<a id="function-function-miniquake2-game-integration-baseq2-integratedworldradiusdamage-function-integratedworldradiusdamage-inflictor-attacker-amount-radius-means-src-miniquake2-game-integration-baseq2-ml-939871170"></a>
### integratedWorldRadiusDamage

```ml
function integratedWorldRadiusDamage(inflictor, attacker, amount, radius, means)
```

Return the integrated world radius damage value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `inflictor` | `dynamic` | — | inflictor value consumed by this operation. |
| `attacker` | `dynamic` | — | attacker value consumed by this operation. |
| `amount` | `dynamic` | — | amount value consumed by this operation. |
| `radius` | `dynamic` | — | radius value consumed by this operation. |
| `means` | `dynamic` | — | means value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L2569)

<a id="function-function-miniquake2-game-integration-baseq2-integratedworldsetmodel-function-integratedworldsetmodel-entity-modelname-src-miniquake2-game-integration-baseq2-ml-526625300"></a>
### integratedWorldSetModel

```ml
function integratedWorldSetModel(entity, modelName)
```

Set integrated world model.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `modelName` | `dynamic` | — | modelName value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L2857)

<a id="function-function-miniquake2-game-integration-baseq2-integratedworldspawnexternal-function-integratedworldspawnexternal-classname-origin-angles-velocity-src-miniquake2-game-integration-baseq2-ml-512830235"></a>
### integratedWorldSpawnExternal

```ml
function integratedWorldSpawnExternal(className, origin, angles, velocity)
```

Spawn integrated world external.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `className` | `dynamic` | — | className value consumed by this operation. |
| `origin` | `dynamic` | — | origin value consumed by this operation. |
| `angles` | `dynamic` | — | angles value consumed by this operation. |
| `velocity` | `dynamic` | — | velocity value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L2473)

<a id="function-function-miniquake2-game-integration-baseq2-itemteammaster-function-itemteammaster-itementity-src-miniquake2-game-integration-baseq2-ml-152640283"></a>
### itemTeamMaster

```ml
function itemTeamMaster(itemEntity)
```

Return the item team master value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `itemEntity` | `dynamic` | — | itemEntity value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L6427)

<a id="function-function-miniquake2-game-integration-baseq2-itemworldeffects-function-itemworldeffects-item-src-miniquake2-game-integration-baseq2-ml-1663965670"></a>
### itemWorldEffects

```ml
function itemWorldEffects(item)
```

Return the item world effects value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `item` | `dynamic` | — | item value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L493)

<a id="function-function-miniquake2-game-integration-baseq2-managededictslotactive-function-managededictslotactive-runtime-number-src-miniquake2-game-integration-baseq2-ml-1317386266"></a>
### managedEdictSlotActive

```ml
function managedEdictSlotActive(runtime, number)
```

Report whether a protocol slot still belongs to a live managed record.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |
| `number` | `dynamic` | — | number value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L143)

<a id="global-global-miniquake2-game-integration-baseq2-mediccableoffsetx-mediccableoffsetx-src-miniquake2-game-integration-baseq2-ml-1926657919"></a>
### medicCableOffsetX

```ml
medicCableOffsetX
```

Exact m_medic.c attack42-relative cable offsets. Package-rooted scalar


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L398)

<a id="global-global-miniquake2-game-integration-baseq2-mediccableoffsety-mediccableoffsety-src-miniquake2-game-integration-baseq2-ml-797713247"></a>
### medicCableOffsetY

```ml
medicCableOffsetY
```

Stores module-wide medic cable offset y state for the miniquake2 game integration baseq2 module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L400)

<a id="global-global-miniquake2-game-integration-baseq2-mediccableoffsetz-mediccableoffsetz-src-miniquake2-game-integration-baseq2-ml-1997354587"></a>
### medicCableOffsetZ

```ml
medicCableOffsetZ
```

Stores module-wide medic cable offset z state for the miniquake2 game integration baseq2 module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L402)

<a id="function-function-miniquake2-game-integration-baseq2-monsterattackdamage-function-monsterattackdamage-runtime-attackplan-eventindex-src-miniquake2-game-integration-baseq2-ml-439937074"></a>
### monsterAttackDamage

```ml
function monsterAttackDamage(runtime, attackPlan, eventIndex)
```

Run monster damage.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |
| `attackPlan` | `dynamic` | — | attackPlan value consumed by this operation. |
| `eventIndex` | `dynamic` | — | Zero-based index of event. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L5056)

<a id="function-function-miniquake2-game-integration-baseq2-monsterattackdamagefromstate-function-monsterattackdamagefromstate-randomstate-attackplan-eventindex-src-miniquake2-game-integration-baseq2-ml-693846412"></a>
### monsterAttackDamageFromState

```ml
function monsterAttackDamageFromState(randomState, attackPlan, eventIndex)
```

Run monster damage from state.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `randomState` | `dynamic` | — | randomState value consumed by this operation. |
| `attackPlan` | `dynamic` | — | attackPlan value consumed by this operation. |
| `eventIndex` | `dynamic` | — | Zero-based index of event. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L5029)

<a id="function-function-miniquake2-game-integration-baseq2-monsterattackdirection-function-monsterattackdirection-actor-attackplan-eventindex-start-destination-velocity-src-miniquake2-game-integration-baseq2-ml-1363857922"></a>
### monsterAttackDirection

```ml
function monsterAttackDirection(actor, attackPlan, eventIndex, start, destination, velocity)
```

Run monster direction.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `attackPlan` | `dynamic` | — | attackPlan value consumed by this operation. |
| `eventIndex` | `dynamic` | — | Zero-based index of event. |
| `start` | `dynamic` | — | start value consumed by this operation. |
| `destination` | `dynamic` | — | destination value consumed by this operation. |
| `velocity` | `dynamic` | — | velocity value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L4855)

<a id="function-function-miniquake2-game-integration-baseq2-monsterattacksupported-function-monsterattacksupported-actor-src-miniquake2-game-integration-baseq2-ml-596704910"></a>
### monsterAttackSupported

```ml
function monsterAttackSupported(actor)
```

Report whether monster attack supported.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L4809)

<a id="function-function-miniquake2-game-integration-baseq2-monsterattacktimelineoffset-function-monsterattacktimelineoffset-actor-attackplan-now-src-miniquake2-game-integration-baseq2-ml-33616597"></a>
### monsterAttackTimelineOffset

```ml
function monsterAttackTimelineOffset(actor, attackPlan, now)
```

Run monster timeline offset.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `attackPlan` | `dynamic` | — | attackPlan value consumed by this operation. |
| `now` | `dynamic` | — | now value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L5538)

<a id="function-function-miniquake2-game-integration-baseq2-monsterenemyaimpoint-function-monsterenemyaimpoint-actor-enemy-src-miniquake2-game-integration-baseq2-ml-1843040478"></a>
### monsterEnemyAimPoint

```ml
function monsterEnemyAimPoint(actor, enemy)
```

Return the monster enemy aim point value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `enemy` | `dynamic` | — | enemy value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L4842)

<a id="function-function-miniquake2-game-integration-baseq2-monsterfirehit-function-monsterfirehit-runtime-actor-enemytarget-shooter-attackplan-eventindex-damage-kick-src-miniquake2-game-integration-baseq2-ml-1607452117"></a>
### monsterFireHit

```ml
function monsterFireHit(runtime, actor, enemyTarget, shooter, attackPlan, eventIndex, damage, kick)
```

Fire monster hit.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `enemyTarget` | `dynamic` | — | enemyTarget value consumed by this operation. |
| `shooter` | `dynamic` | — | shooter value consumed by this operation. |
| `attackPlan` | `dynamic` | — | attackPlan value consumed by this operation. |
| `eventIndex` | `dynamic` | — | Zero-based index of event. |
| `damage` | `dynamic` | — | damage value consumed by this operation. |
| `kick` | `dynamic` | — | kick value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L5133)

<a id="function-function-miniquake2-game-integration-baseq2-monstermeleeaim-function-monstermeleeaim-actor-attackplan-eventindex-src-miniquake2-game-integration-baseq2-ml-395556777"></a>
### monsterMeleeAim

```ml
function monsterMeleeAim(actor, attackPlan, eventIndex)
```

Return the monster melee aim value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `attackPlan` | `dynamic` | — | attackPlan value consumed by this operation. |
| `eventIndex` | `dynamic` | — | Zero-based index of event. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L5000)

<a id="function-function-miniquake2-game-integration-baseq2-monstermuzzleanddirection-function-monstermuzzleanddirection-runtime-actor-attackplan-eventindex-muzzleflash-src-miniquake2-game-integration-baseq2-ml-1967821938"></a>
### monsterMuzzleAndDirection

```ml
function monsterMuzzleAndDirection(runtime, actor, attackPlan, eventIndex, muzzleFlash)
```

Return the monster muzzle and direction value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `attackPlan` | `dynamic` | — | attackPlan value consumed by this operation. |
| `eventIndex` | `dynamic` | — | Zero-based index of event. |
| `muzzleFlash` | `dynamic` | — | muzzleFlash value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L4916)

<a id="function-function-miniquake2-game-integration-baseq2-monstermuzzlestart-function-monstermuzzlestart-actor-muzzleflash-src-miniquake2-game-integration-baseq2-ml-384037649"></a>
### monsterMuzzleStart

```ml
function monsterMuzzleStart(actor, muzzleFlash)
```

Start monster muzzle.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `muzzleFlash` | `dynamic` | — | muzzleFlash value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L4829)

<a id="function-function-miniquake2-game-integration-baseq2-monsterprojectedstart-function-monsterprojectedstart-actor-offset-src-miniquake2-game-integration-baseq2-ml-1560185039"></a>
### monsterProjectedStart

```ml
function monsterProjectedStart(actor, offset)
```

Start monster projected.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `offset` | `dynamic` | — | Zero-based offset at which processing starts. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L4816)

<a id="function-function-miniquake2-game-integration-baseq2-monsterrefiredecisionoffset-function-monsterrefiredecisionoffset-attackplan-src-miniquake2-game-integration-baseq2-ml-1856022726"></a>
### monsterRefireDecisionOffset

```ml
function monsterRefireDecisionOffset(attackPlan)
```

Return the monster refire decision offset.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `attackPlan` | `dynamic` | — | attackPlan value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L5409)

<a id="function-function-miniquake2-game-integration-baseq2-monstersecondarymodelname-function-monstersecondarymodelname-actor-src-miniquake2-game-integration-baseq2-ml-865717746"></a>
### monsterSecondaryModelName

```ml
function monsterSecondaryModelName(actor)
```

Return the monster secondary model name.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L3718)

<a id="function-function-miniquake2-game-integration-baseq2-monstershouldrefire-function-monstershouldrefire-runtime-actor-attackplan-src-miniquake2-game-integration-baseq2-ml-942984949"></a>
### monsterShouldRefire

```ml
function monsterShouldRefire(runtime, actor, attackPlan)
```

Report whether monster should refire.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `attackPlan` | `dynamic` | — | attackPlan value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L5463)

<a id="function-function-miniquake2-game-integration-baseq2-monstersoldierattackdirection-function-monstersoldierattackdirection-randomstate-start-destination-src-miniquake2-game-integration-baseq2-ml-1581006171"></a>
### monsterSoldierAttackDirection

```ml
function monsterSoldierAttackDirection(randomState, start, destination)
```

Run monster soldier direction.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `randomState` | `dynamic` | — | randomState value consumed by this operation. |
| `start` | `dynamic` | — | start value consumed by this operation. |
| `destination` | `dynamic` | — | destination value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L4898)

<a id="function-function-miniquake2-game-integration-baseq2-monsterweapontarget-function-monsterweapontarget-actor-src-miniquake2-game-integration-baseq2-ml-1083000280"></a>
### monsterWeaponTarget

```ml
function monsterWeaponTarget(actor)
```

Return the monster weapon target value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L1545)

<a id="function-function-miniquake2-game-integration-baseq2-parasitedraincandamage-function-parasitedraincandamage-runtime-shooter-enemytarget-start-src-miniquake2-game-integration-baseq2-ml-1796291694"></a>
### parasiteDrainCanDamage

```ml
function parasiteDrainCanDamage(runtime, shooter, enemyTarget, start)
```

Report whether parasite drain can damage.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |
| `shooter` | `dynamic` | — | shooter value consumed by this operation. |
| `enemyTarget` | `dynamic` | — | enemyTarget value consumed by this operation. |
| `start` | `dynamic` | — | start value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L4978)

<a id="function-function-miniquake2-game-integration-baseq2-parasitedrainpointok-function-parasitedrainpointok-start-endposition-src-miniquake2-game-integration-baseq2-ml-234766345"></a>
### parasiteDrainPointOk

```ml
function parasiteDrainPointOk(start, endPosition)
```

Drain parasite point ok.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `start` | `dynamic` | — | start value consumed by this operation. |
| `endPosition` | `dynamic` | — | endPosition value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L4964)

<a id="function-function-miniquake2-game-integration-baseq2-playerchaingunmuzzle-function-playerchaingunmuzzle-player-src-miniquake2-game-integration-baseq2-ml-1196221500"></a>
### playerChaingunMuzzle

```ml
function playerChaingunMuzzle(player)
```

Return the player chaingun muzzle value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `player` | `dynamic` | — | player value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L4352)

<a id="function-function-miniquake2-game-integration-baseq2-playerforgameplay-function-playerforgameplay-runtime-gameplayplayer-src-miniquake2-game-integration-baseq2-ml-238287402"></a>
### playerForGameplay

```ml
function playerForGameplay(runtime, gameplayPlayer)
```

Return the player for gameplay value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |
| `gameplayPlayer` | `dynamic` | — | gameplayPlayer value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L4287)

<a id="function-function-miniquake2-game-integration-baseq2-playermuzzle-function-playermuzzle-player-item-gunframe-shotindex-src-miniquake2-game-integration-baseq2-ml-1832935664"></a>
### playerMuzzle

```ml
function playerMuzzle(player, item, gunFrame, shotIndex)
```

Return the player muzzle value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `player` | `dynamic` | — | player value consumed by this operation. |
| `item` | `dynamic` | — | item value consumed by this operation. |
| `gunFrame` | `dynamic` | — | gunFrame value consumed by this operation. |
| `shotIndex` | `dynamic` | — | Zero-based index of shot. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L4345)

<a id="function-function-miniquake2-game-integration-baseq2-playermuzzleflashforitem-function-playermuzzleflashforitem-item-shots-src-miniquake2-game-integration-baseq2-ml-121871193"></a>
### playerMuzzleFlashForItem

```ml
function playerMuzzleFlashForItem(item, shots)
```

Return the player muzzle flash for item value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `item` | `dynamic` | — | item value consumed by this operation. |
| `shots` | `dynamic` | — | shots value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L4459)

<a id="function-function-miniquake2-game-integration-baseq2-playermuzzleforangles-function-playermuzzleforangles-player-item-gunframe-shotindex-angles-src-miniquake2-game-integration-baseq2-ml-1475034710"></a>
### playerMuzzleForAngles

```ml
function playerMuzzleForAngles(player, item, gunFrame, shotIndex, angles)
```

Return the player muzzle for angles.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `player` | `dynamic` | — | player value consumed by this operation. |
| `item` | `dynamic` | — | item value consumed by this operation. |
| `gunFrame` | `dynamic` | — | gunFrame value consumed by this operation. |
| `shotIndex` | `dynamic` | — | Zero-based index of shot. |
| `angles` | `dynamic` | — | angles value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L4310)

<a id="function-function-miniquake2-game-integration-baseq2-playerweaponshotcount-function-playerweaponshotcount-gameplayplayer-item-effectiveframe-src-miniquake2-game-integration-baseq2-ml-429093451"></a>
### playerWeaponShotCount

```ml
function playerWeaponShotCount(gameplayPlayer, item, effectiveFrame)
```

Return the player weapon shot count.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `gameplayPlayer` | `dynamic` | — | gameplayPlayer value consumed by this operation. |
| `item` | `dynamic` | — | item value consumed by this operation. |
| `effectiveFrame` | `dynamic` | — | effectiveFrame value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L4494)

<a id="function-function-miniquake2-game-integration-baseq2-playerweapontarget-function-playerweapontarget-player-registry-src-miniquake2-game-integration-baseq2-ml-2126039625"></a>
### playerWeaponTarget

```ml
function playerWeaponTarget(player, registry)
```

Return the player weapon target value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `player` | `dynamic` | — | player value consumed by this operation. |
| `registry` | `dynamic` | — | registry value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L1521)

<a id="function-function-miniquake2-game-integration-baseq2-playerworldproxy-function-playerworldproxy-player-src-miniquake2-game-integration-baseq2-ml-877397232"></a>
### playerWorldProxy

```ml
function playerWorldProxy(player)
```

Return the player world proxy value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `player` | `dynamic` | — | player value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L4029)

<a id="function-function-miniquake2-game-integration-baseq2-precachespawned-function-precachespawned-runtime-playercontext-src-miniquake2-game-integration-baseq2-ml-149165153"></a>
### precacheSpawned

```ml
function precacheSpawned(runtime, playerContext)
```

Keep map startup bounded to the definitions that can actually participate in this level. The default Blaster/player model are the only unconditional player assets; duplicate item and monster instances reuse engine indices.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |
| `playerContext` | `dynamic` | — | playerContext value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L3729)

<a id="function-function-miniquake2-game-integration-baseq2-preparemonsterruntimestate-function-preparemonsterruntimestate-actor-src-miniquake2-game-integration-baseq2-ml-1532854654"></a>
### prepareMonsterRuntimeState

```ml
function prepareMonsterRuntimeState(actor)
```

Prepare monster runtime state.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `actor` | `dynamic` | — | actor value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L3542)

<a id="function-function-miniquake2-game-integration-baseq2-preparespawneditem-function-preparespawneditem-runtime-itementity-src-miniquake2-game-integration-baseq2-ml-1612702065"></a>
### prepareSpawnedItem

```ml
function prepareSpawnedItem(runtime, itemEntity)
```

Prepare spawned item.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |
| `itemEntity` | `dynamic` | — | itemEntity value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L6439)

<a id="function-function-miniquake2-game-integration-baseq2-projectilefreecount-function-projectilefreecount-src-miniquake2-game-integration-baseq2-ml-936213411"></a>
### projectileFreeCount

```ml
function projectileFreeCount()
```

Release projectile count.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L136)

<a id="function-function-miniquake2-game-integration-baseq2-projectilelinkcount-function-projectilelinkcount-src-miniquake2-game-integration-baseq2-ml-1765748687"></a>
### projectileLinkCount

```ml
function projectileLinkCount()
```

Link projectile count.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L131)

<a id="function-function-miniquake2-game-integration-baseq2-projectmonsterattackframe-function-projectmonsterattackframe-runtime-actor-attackplan-src-miniquake2-game-integration-baseq2-ml-313180917"></a>
### projectMonsterAttackFrame

```ml
function projectMonsterAttackFrame(runtime, actor, attackPlan)
```

Project monster attack frame.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `attackPlan` | `dynamic` | — | attackPlan value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L5564)

<a id="function-function-miniquake2-game-integration-baseq2-recordframedispatch-function-recordframedispatch-runtime-number-kind-src-miniquake2-game-integration-baseq2-ml-908598080"></a>
### recordFrameDispatch

```ml
function recordFrameDispatch(runtime, number, kind)
```

Record an optional scheduler probe without allocating in production frames.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |
| `number` | `dynamic` | — | number value consumed by this operation. |
| `kind` | `dynamic` | — | kind value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L6563)

<a id="function-function-miniquake2-game-integration-baseq2-refreshairandom-function-refreshairandom-runtime-src-miniquake2-game-integration-baseq2-ml-1968347977"></a>
### refreshAiRandom

```ml
function refreshAiRandom(runtime)
```

Refresh ai random.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L3212)

<a id="function-function-miniquake2-game-integration-baseq2-releaseedict-function-releaseedict-runtime-number-src-miniquake2-game-integration-baseq2-ml-213252162"></a>
### releaseEdict

```ml
function releaseEdict(runtime, number)
```

G_FreeEdict: preserve client and body-queue reservations and timestamp frees.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |
| `number` | `dynamic` | — | number value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L227)

<a id="function-function-miniquake2-game-integration-baseq2-releasereservededict-function-releasereservededict-runtime-number-src-miniquake2-game-integration-baseq2-ml-225629034"></a>
### releaseReservedEdict

```ml
function releaseReservedEdict(runtime, number)
```

Release reserved edict.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |
| `number` | `dynamic` | — | number value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L2284)

<a id="function-function-miniquake2-game-integration-baseq2-reserveedict-function-reserveedict-runtime-src-miniquake2-game-integration-baseq2-ml-1597080329"></a>
### reserveEdict

```ml
function reserveEdict(runtime)
```

G_Spawn: reuse only eligible freed edicts, then extend globals.num_edicts.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L188)

<a id="function-function-miniquake2-game-integration-baseq2-reservespawneredict-function-reservespawneredict-runtime-src-miniquake2-game-integration-baseq2-ml-2075358123"></a>
### reserveSpawnerEdict

```ml
function reserveSpawnerEdict(runtime)
```

Reserve spawner edict.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L2257)

<a id="function-function-miniquake2-game-integration-baseq2-reserveworldeffectedict-function-reserveworldeffectedict-runtime-src-miniquake2-game-integration-baseq2-ml-380199645"></a>
### reserveWorldEffectEdict

```ml
function reserveWorldEffectEdict(runtime)
```

Reuse a freed non-player edict before extending the protocol-visible table. Short-lived debris can otherwise exhaust MAX_EDICTS after several barrels.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L951)

<a id="function-function-miniquake2-game-integration-baseq2-respawnteamitem-function-respawnteamitem-runtime-itementity-src-miniquake2-game-integration-baseq2-ml-874957441"></a>
### respawnTeamItem

```ml
function respawnTeamItem(runtime, itemEntity)
```

Return the respawn team item value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |
| `itemEntity` | `dynamic` | — | itemEntity value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L6522)

<a id="function-function-miniquake2-game-integration-baseq2-restorebodyqueue-function-restorebodyqueue-runtime-src-miniquake2-game-integration-baseq2-ml-257572337"></a>
### restoreBodyQueue

```ml
function restoreBodyQueue(runtime)
```

Rebind body-queue records decoded from a private level save.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L314)

<a id="function-function-miniquake2-game-integration-baseq2-runframe-function-runframe-runtime-src-miniquake2-game-integration-baseq2-ml-1792368317"></a>
### runFrame

```ml
function runFrame(runtime)
```

Run all non-client edicts in the original global numeric slot order.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L6657)

<a id="function-function-miniquake2-game-integration-baseq2-runitematnumber-function-runitematnumber-runtime-number-src-miniquake2-game-integration-baseq2-ml-38229062"></a>
### runItemAtNumber

```ml
function runItemAtNumber(runtime, number)
```

Run one managed item at its global edict slot.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |
| `number` | `dynamic` | — | number value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L6611)

<a id="function-function-miniquake2-game-integration-baseq2-runmonsteratnumber-function-runmonsteratnumber-runtime-number-src-miniquake2-game-integration-baseq2-ml-1232416854"></a>
### runMonsterAtNumber

```ml
function runMonsterAtNumber(runtime, number)
```

Run one monster at its global edict slot.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |
| `number` | `dynamic` | — | number value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L6589)

<a id="function-function-miniquake2-game-integration-baseq2-runmonstercombat-function-runmonstercombat-runtime-actor-src-miniquake2-game-integration-baseq2-ml-934090712"></a>
### runMonsterCombat

```ml
function runMonsterCombat(runtime, actor)
```

Select or continue the original class-specific combat sequence only after reaction/death moves have had priority. The function returns true when it owns this server frame and the generic AI path must not also advance it.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |
| `actor` | `dynamic` | — | actor value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L5868)

<a id="function-function-miniquake2-game-integration-baseq2-runplayergameplayframe-function-runplayergameplayframe-runtime-playercontext-src-miniquake2-game-integration-baseq2-ml-913881795"></a>
### runPlayerGameplayFrame

```ml
function runPlayerGameplayFrame(runtime, playerContext)
```

Run player gameplay frame.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |
| `playerContext` | `dynamic` | — | playerContext value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L6712)

<a id="function-function-miniquake2-game-integration-baseq2-runworldatnumber-function-runworldatnumber-runtime-capturestate-number-src-miniquake2-game-integration-baseq2-ml-1831282003"></a>
### runWorldAtNumber

```ml
function runWorldAtNumber(runtime, captureState, number)
```

Run one world-owned edict, including an atomic pusher team at its captain.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |
| `captureState` | `dynamic` | — | captureState value consumed by this operation. |
| `number` | `dynamic` | — | number value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L6629)

<a id="function-function-miniquake2-game-integration-baseq2-runworldthinkatnumber-function-runworldthinkatnumber-runtime-entity-src-miniquake2-game-integration-baseq2-ml-1941062430"></a>
### runWorldThinkAtNumber

```ml
function runWorldThinkAtNumber(runtime, entity)
```

Run one ordinary world think at its global edict slot.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |
| `entity` | `dynamic` | — | entity value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L6574)

<a id="function-function-miniquake2-game-integration-baseq2-segmentweapontarget-function-segmentweapontarget-start-finish-target-src-miniquake2-game-integration-baseq2-ml-1417098287"></a>
### segmentWeaponTarget

```ml
function segmentWeaponTarget(start, finish, target)
```

Return the segment weapon target value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `start` | `dynamic` | — | start value consumed by this operation. |
| `finish` | `dynamic` | — | finish value consumed by this operation. |
| `target` | `dynamic` | — | target value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L1652)

<a id="function-function-miniquake2-game-integration-baseq2-selectsightclient-function-selectsightclient-runtime-playercontext-src-miniquake2-game-integration-baseq2-ml-1236224055"></a>
### selectSightClient

```ml
function selectSightClient(runtime, playerContext)
```

Rotate the one client considered by FindTarget this frame exactly like g_ai.c:AI_SetSightClient. Client slots, not the managed array order, define the sequence and FL_NOTARGET clients do not consume another player's turn.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |
| `playerContext` | `dynamic` | — | playerContext value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L4237)

<a id="function-function-miniquake2-game-integration-baseq2-setplayergameplaygunframe-function-setplayergameplaygunframe-gameplayplayer-frame-src-miniquake2-game-integration-baseq2-ml-1725009303"></a>
### setPlayerGameplayGunFrame

```ml
function setPlayerGameplayGunFrame(gameplayPlayer, frame)
```

Set player gameplay gun frame.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `gameplayPlayer` | `dynamic` | — | gameplayPlayer value consumed by this operation. |
| `frame` | `dynamic` | — | frame value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L4298)

<a id="function-function-miniquake2-game-integration-baseq2-setsoldierduckattackbounds-function-setsoldierduckattackbounds-runtime-actor-lowered-src-miniquake2-game-integration-baseq2-ml-1345924060"></a>
### setSoldierDuckAttackBounds

```ml
function setSoldierDuckAttackBounds(runtime, actor, lowered)
```

Set soldier duck attack bounds.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |
| `actor` | `dynamic` | — | actor value consumed by this operation. |
| `lowered` | `dynamic` | — | lowered value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L5643)

<a id="function-function-miniquake2-game-integration-baseq2-startmutantjump-function-startmutantjump-runtime-actor-src-miniquake2-game-integration-baseq2-ml-1357385698"></a>
### startMutantJump

```ml
function startMutantJump(runtime, actor)
```

Start mutant jump.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |
| `actor` | `dynamic` | — | actor value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L5063)

<a id="global-global-miniquake2-game-integration-baseq2-stockworldgibmodels-stockworldgibmodels-src-miniquake2-game-integration-baseq2-ml-526152267"></a>
### stockWorldGibModels

```ml
stockWorldGibModels
```

Stores module-wide stock world gib models state for the miniquake2 game integration baseq2 module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L434)

<a id="global-global-miniquake2-game-integration-baseq2-stockworldsexedmodels-stockworldsexedmodels-src-miniquake2-game-integration-baseq2-ml-774279775"></a>
### stockWorldSexedModels

```ml
stockWorldSexedModels
```

Stores module-wide stock world sexed models state for the miniquake2 game integration baseq2 module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L427)

<a id="global-global-miniquake2-game-integration-baseq2-stockworldsounds-stockworldsounds-src-miniquake2-game-integration-baseq2-ml-1075737483"></a>
### stockWorldSounds

```ml
stockWorldSounds
```

SP_worldspawn's unconditional player/environment inventory. These package


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L412)

<a id="function-function-miniquake2-game-integration-baseq2-syncgameedicts-function-syncgameedicts-runtime-exporttable-src-miniquake2-game-integration-baseq2-ml-1509433529"></a>
### syncGameEdicts

```ml
function syncGameEdicts(runtime, exportTable)
```

Synchronize game edicts.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |
| `exportTable` | `dynamic` | — | exportTable value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L6761)

<a id="function-function-miniquake2-game-integration-baseq2-syncplayers-function-syncplayers-runtime-playercontext-src-miniquake2-game-integration-baseq2-ml-662855269"></a>
### syncPlayers

```ml
function syncPlayers(runtime, playerContext)
```

Synchronize players.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |
| `playerContext` | `dynamic` | — | playerContext value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L4206)

<a id="function-function-miniquake2-game-integration-baseq2-thinkplayerhandgrenade-function-thinkplayerhandgrenade-player-playercontext-runtime-item-src-miniquake2-game-integration-baseq2-ml-765799933"></a>
### thinkPlayerHandGrenade

```ml
function thinkPlayerHandGrenade(player, playerContext, runtime, item)
```

Run player hand grenade.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `player` | `dynamic` | — | player value consumed by this operation. |
| `playerContext` | `dynamic` | — | playerContext value consumed by this operation. |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |
| `item` | `dynamic` | — | item value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L4715)

<a id="function-function-miniquake2-game-integration-baseq2-thinkplayerweapon-function-thinkplayerweapon-player-playercontext-src-miniquake2-game-integration-baseq2-ml-1375483418"></a>
### thinkPlayerWeapon

```ml
function thinkPlayerWeapon(player, playerContext)
```

Run player weapon.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `player` | `dynamic` | — | player value consumed by this operation. |
| `playerContext` | `dynamic` | — | playerContext value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L4777)

<a id="function-function-miniquake2-game-integration-baseq2-tossclientdeathitem-function-tossclientdeathitem-runtime-player-playercontext-item-yawoffset-spawnflags-src-miniquake2-game-integration-baseq2-ml-258225077"></a>
### tossClientDeathItem

```ml
function tossClientDeathItem(runtime, player, playerContext, item, yawOffset, spawnFlags)
```

Create the two deathmatch-only drops from p_client.c:TossClientWeapon. Unlike the normal Drop command this must not mutate inventory: player_die clears it immediately after this callback, and the current weapon may be the player's last copy. Both results still use installDroppedItem, so they own real engine edicts, toss physics, models and pickup behavior.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |
| `player` | `dynamic` | — | player value consumed by this operation. |
| `playerContext` | `dynamic` | — | playerContext value consumed by this operation. |
| `item` | `dynamic` | — | item value consumed by this operation. |
| `yawOffset` | `dynamic` | — | yawOffset value consumed by this operation. |
| `spawnFlags` | `dynamic` | — | spawnFlags value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L2371)

<a id="function-function-miniquake2-game-integration-baseq2-tossclientdeathitems-function-tossclientdeathitems-playercontext-player-src-miniquake2-game-integration-baseq2-ml-2100495482"></a>
### tossClientDeathItems

```ml
function tossClientDeathItems(playerContext, player)
```

Return the toss client death items value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `playerContext` | `dynamic` | — | playerContext value consumed by this operation. |
| `player` | `dynamic` | — | player value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L2420)

<a id="function-function-miniquake2-game-integration-baseq2-tossclientheldgrenade-function-tossclientheldgrenade-playercontext-player-src-miniquake2-game-integration-baseq2-ml-1674316744"></a>
### tossClientHeldGrenade

```ml
function tossClientHeldGrenade(playerContext, player)
```

ChangeWeapon throws a cooked hand grenade when its owner dies. The stock code sets grenade_time to level.time first, so the resulting hand grenade has a zero timer and detonates through the ordinary projectile path at the death muzzle. player_die invokes this only after marking the owner dead, so the immediate radius damage cannot recursively re-enter first-death logic.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `playerContext` | `dynamic` | — | playerContext value consumed by this operation. |
| `player` | `dynamic` | — | player value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L2393)

<a id="function-function-miniquake2-game-integration-baseq2-touchdroppeditemtriggers-function-touchdroppeditemtriggers-runtime-item-src-miniquake2-game-integration-baseq2-ml-905372732"></a>
### touchDroppedItemTriggers

```ml
function touchDroppedItemTriggers(runtime, item)
```

Dispatch G_TouchTriggers for a dropped item's newly linked toss position.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |
| `item` | `dynamic` | — | item value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L6111)

<a id="function-function-miniquake2-game-integration-baseq2-touchedict-function-touchedict-runtime-edict-player-playercontext-src-miniquake2-game-integration-baseq2-ml-711468903"></a>
### touchEdict

```ml
function touchEdict(runtime, edict, player, playerContext)
```

Handle edict.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |
| `edict` | `dynamic` | — | edict value consumed by this operation. |
| `player` | `dynamic` | — | player value consumed by this operation. |
| `playerContext` | `dynamic` | — | playerContext value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L4183)

<a id="function-function-miniquake2-game-integration-baseq2-touchitem-function-touchitem-runtime-itementity-player-playercontext-src-miniquake2-game-integration-baseq2-ml-1584646126"></a>
### touchItem

```ml
function touchItem(runtime, itemEntity, player, playerContext)
```

Handle item.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |
| `itemEntity` | `dynamic` | — | itemEntity value consumed by this operation. |
| `player` | `dynamic` | — | player value consumed by this operation. |
| `playerContext` | `dynamic` | — | playerContext value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L4088)

<a id="function-function-miniquake2-game-integration-baseq2-touchitembynumber-function-touchitembynumber-runtime-number-player-playercontext-src-miniquake2-game-integration-baseq2-ml-153656879"></a>
### touchItemByNumber

```ml
function touchItemByNumber(runtime, number, player, playerContext)
```

Handle item by number.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |
| `number` | `dynamic` | — | number value consumed by this operation. |
| `player` | `dynamic` | — | player value consumed by this operation. |
| `playerContext` | `dynamic` | — | playerContext value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L4144)

<a id="function-function-miniquake2-game-integration-baseq2-touchnearbyitems-function-touchnearbyitems-runtime-player-playercontext-src-miniquake2-game-integration-baseq2-ml-2066482342"></a>
### touchNearbyItems

```ml
function touchNearbyItems(runtime, player, playerContext)
```

Handle nearby items.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |
| `player` | `dynamic` | — | player value consumed by this operation. |
| `playerContext` | `dynamic` | — | playerContext value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L4165)

<a id="function-function-miniquake2-game-integration-baseq2-touchpushedbody-function-touchpushedbody-runtime-kind-value-src-miniquake2-game-integration-baseq2-ml-1892545810"></a>
### touchPushedBody

```ml
function touchPushedBody(runtime, kind, value)
```

Dispatch the post-commit G_TouchTriggers pass for every pusher body kind. PlayerData, Actor and WorldEntity retain different authoritative shapes, so each branch reuses its normal trigger adapter instead of leaking snapshots.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |
| `kind` | `dynamic` | — | kind value consumed by this operation. |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L6140)

<a id="function-function-miniquake2-game-integration-baseq2-touchweaponprojectiletriggers-function-touchweaponprojectiletriggers-runtime-projectile-src-miniquake2-game-integration-baseq2-ml-1347525422"></a>
### touchWeaponProjectileTriggers

```ml
function touchWeaponProjectileTriggers(runtime, projectile)
```

Adapt a managed projectile to the stock world-trigger callback surface after SV_PushEntity linked its final pose. Trigger mutations are copied back to the authoritative projectile record before the next physics frame.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |
| `projectile` | `dynamic` | — | projectile value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L6078)

<a id="function-function-miniquake2-game-integration-baseq2-touchworld-function-touchworld-runtime-entity-player-src-miniquake2-game-integration-baseq2-ml-1873637167"></a>
### touchWorld

```ml
function touchWorld(runtime, entity, player)
```

Handle world.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `player` | `dynamic` | — | player value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L4053)

<a id="function-function-miniquake2-game-integration-baseq2-touchworldbyclass-function-touchworldbyclass-runtime-classname-player-src-miniquake2-game-integration-baseq2-ml-249249257"></a>
### touchWorldByClass

```ml
function touchWorldByClass(runtime, className, player)
```

Handle world by class.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |
| `className` | `dynamic` | — | className value consumed by this operation. |
| `player` | `dynamic` | — | player value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L4079)

<a id="function-function-miniquake2-game-integration-baseq2-touchworldbynumber-function-touchworldbynumber-runtime-number-player-src-miniquake2-game-integration-baseq2-ml-505997473"></a>
### touchWorldByNumber

```ml
function touchWorldByNumber(runtime, number, player)
```

Handle world by number.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |
| `number` | `dynamic` | — | number value consumed by this operation. |
| `player` | `dynamic` | — | player value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L4071)

<a id="function-function-miniquake2-game-integration-baseq2-touchworldtosstriggers-function-touchworldtosstriggers-runtime-entity-src-miniquake2-game-integration-baseq2-ml-1861524448"></a>
### touchWorldTossTriggers

```ml
function touchWorldTossTriggers(runtime, entity)
```

Match SV_PushEntity's post-link G_TouchTriggers pass for toss/bounce world records. baseWorldLink mirrors the server-computed expanded abs bounds back onto the managed entity before this query.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |
| `entity` | `dynamic` | — | entity value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L6052)

<a id="function-function-miniquake2-game-integration-baseq2-updateplayertrail-function-updateplayertrail-runtime-playercontext-src-miniquake2-game-integration-baseq2-ml-1511895263"></a>
### updatePlayerTrail

```ml
function updatePlayerTrail(runtime, playerContext)
```

Update player trail.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |
| `playerContext` | `dynamic` | — | playerContext value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L4266)

<a id="function-function-miniquake2-game-integration-baseq2-updateworldtosswater-function-updateworldtosswater-runtime-entity-oldorigin-src-miniquake2-game-integration-baseq2-ml-1919984261"></a>
### updateWorldTossWater

```ml
function updateWorldTossWater(runtime, entity, oldOrigin)
```

SV_Physics_Toss samples only the entity origin. Entry is positioned at the pre-move origin, while exit is positioned at the post-move origin.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `oldOrigin` | `dynamic` | — | oldOrigin value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L6028)

<a id="function-function-miniquake2-game-integration-baseq2-usetriggereditem-function-usetriggereditem-entity-other-activator-world-src-miniquake2-game-integration-baseq2-ml-562221011"></a>
### useTriggeredItem

```ml
function useTriggeredItem(entity, other, activator, world)
```

Use triggered item.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `other` | `dynamic` | — | other value consumed by this operation. |
| `activator` | `dynamic` | — | activator value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L4008)

<a id="function-function-miniquake2-game-integration-baseq2-weapontargetbynumber-function-weapontargetbynumber-runtime-number-src-miniquake2-game-integration-baseq2-ml-706710214"></a>
### weaponTargetByNumber

```ml
function weaponTargetByNumber(runtime, number)
```

Return the weapon target by number.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |
| `number` | `dynamic` | — | number value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L1591)

<a id="function-function-miniquake2-game-integration-baseq2-weaponvector-function-weaponvector-value-src-miniquake2-game-integration-baseq2-ml-554128910"></a>
### weaponVector

```ml
function weaponVector(value)
```

Return the weapon vector value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L1490)

<a id="function-function-miniquake2-game-integration-baseq2-worldentity-function-worldentity-baseedict-src-miniquake2-game-integration-baseq2-ml-1916117679"></a>
### worldEntity

```ml
function worldEntity(baseEdict)
```

Return the world entity value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `baseEdict` | `dynamic` | — | baseEdict value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L502)

<a id="global-global-miniquake2-game-integration-baseq2-worldlaserblockproxy-worldlaserblockproxy-src-miniquake2-game-integration-baseq2-ml-252986803"></a>
### worldLaserBlockProxy

```ml
worldLaserBlockProxy
```

Stores module-wide world laser block proxy state for the miniquake2 game integration baseq2 module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L468)

<a id="global-global-miniquake2-game-integration-baseq2-worldlaserclipscratch-worldlaserclipscratch-src-miniquake2-game-integration-baseq2-ml-1146685543"></a>
### worldLaserClipScratch

```ml
worldLaserClipScratch
```

target_laser is evaluated every server frame.  Reuse its clip and adapter


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L456)

<a id="global-global-miniquake2-game-integration-baseq2-worldlaserendscratch-worldlaserendscratch-src-miniquake2-game-integration-baseq2-ml-2016576075"></a>
### worldLaserEndScratch

```ml
worldLaserEndScratch
```

Stores module-wide world laser end scratch state for the miniquake2 game integration baseq2 module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L459)

<a id="global-global-miniquake2-game-integration-baseq2-worldlasernormalscratch-worldlasernormalscratch-src-miniquake2-game-integration-baseq2-ml-1688772843"></a>
### worldLaserNormalScratch

```ml
worldLaserNormalScratch
```

Stores module-wide world laser normal scratch state for the miniquake2 game integration baseq2 module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L461)

<a id="global-global-miniquake2-game-integration-baseq2-worldlaserplayerproxy-worldlaserplayerproxy-src-miniquake2-game-integration-baseq2-ml-1121058955"></a>
### worldLaserPlayerProxy

```ml
worldLaserPlayerProxy
```

Stores module-wide world laser player proxy state for the miniquake2 game integration baseq2 module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L466)

<a id="global-global-miniquake2-game-integration-baseq2-worldlasertracescratch-worldlasertracescratch-src-miniquake2-game-integration-baseq2-ml-288080803"></a>
### worldLaserTraceScratch

```ml
worldLaserTraceScratch
```

Stores module-wide world laser trace scratch state for the miniquake2 game integration baseq2 module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L463)

<a id="function-function-miniquake2-game-integration-baseq2-worldweapontarget-function-worldweapontarget-entity-src-miniquake2-game-integration-baseq2-ml-881084640"></a>
### worldWeaponTarget

```ml
function worldWeaponTarget(entity)
```

Return the world weapon target value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/integration/baseq2.ml#L1566)
