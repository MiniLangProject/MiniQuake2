# `src/miniquake2/game/weapons/core.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 game weapons core facilities for this project.

Package: [`miniquake2.game.weapons.core`](Package-miniquake2-game-weapons-core-401524499.md)

Reachable from entry: **yes**

## Imports

- `miniquake2/game/gameplay/combat.ml` as `gpcombat` → [src/miniquake2/game/gameplay/combat.ml](File-src-miniquake2-game-gameplay-combat-ml-1854285404.md)
- `miniquake2/game/gameplay/constants.ml` as `gpconstants` → [src/miniquake2/game/gameplay/constants.ml](File-src-miniquake2-game-gameplay-constants-ml-1803115501.md)
- `miniquake2/game/gameplay/types.ml` as `gptypes` → [src/miniquake2/game/gameplay/types.ml](File-src-miniquake2-game-gameplay-types-ml-2088064005.md)
- `miniquake2/game/weapons/constants.ml` as `wbconstants` → [src/miniquake2/game/weapons/constants.ml](File-src-miniquake2-game-weapons-constants-ml-539739454.md)
- `miniquake2/game/weapons/types.ml` as `wbtypes` → [src/miniquake2/game/weapons/types.ml](File-src-miniquake2-game-weapons-types-ml-582527054.md)
- `miniquake2/game/weapons/vector.ml` as `wbvector` → [src/miniquake2/game/weapons/vector.ml](File-src-miniquake2-game-weapons-vector-ml-1084549988.md)
- `miniquake2/qcommon/byteio.ml` as `qbyteio` → [src/miniquake2/qcommon/byteio.ml](File-src-miniquake2-qcommon-byteio-ml-159119335.md)
- `miniquake2/qcommon/constants.ml` as `qc` → [src/miniquake2/qcommon/constants.ml](File-src-miniquake2-qcommon-constants-ml-1976195726.md)
- `miniquake2/qcommon/directions.ml` as `qdir` → [src/miniquake2/qcommon/directions.ml](File-src-miniquake2-qcommon-directions-ml-1980852047.md)
- `miniquake2/qcommon/types.ml` as `qt` → [src/miniquake2/qcommon/types.ml](File-src-miniquake2-qcommon-types-ml-1663266398.md)

## Declarations

<a id="function-function-miniquake2-game-weapons-core-addtargetorigin-function-addtargetorigin-target-src-miniquake2-game-weapons-core-ml-143136412"></a>
### addTargetOrigin

```ml
function addTargetOrigin(target)
```

Add target origin.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `target` | `dynamic` | — | target value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/weapons/core.ml#L144)

<a id="function-function-miniquake2-game-weapons-core-advance-function-advance-context-seconds-src-miniquake2-game-weapons-core-ml-1814675747"></a>
### advance

```ml
function advance(context, seconds)
```

Performs the advance operation for the miniquake2 game weapons core module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `context` | `dynamic` | — | Context that carries state for the operation. |
| `seconds` | `dynamic` | — | seconds value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/weapons/core.ml#L284)

<a id="function-function-miniquake2-game-weapons-core-alwayscandamage-function-alwayscandamage-target-origin-src-miniquake2-game-weapons-core-ml-1976371070"></a>
### alwaysCanDamage

```ml
function alwaysCanDamage(target, origin)
```

Report whether always can damage.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `target` | `dynamic` | — | target value consumed by this operation. |
| `origin` | `dynamic` | — | origin value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/weapons/core.ml#L77)

<a id="function-function-miniquake2-game-weapons-core-applydamage-function-applydamage-context-target-inflictor-attacker-direction-point-damage-knockback-flags-meansofdeath-src-miniquake2-game-weapons-core-ml-1209065135"></a>
### applyDamage

```ml
function applyDamage(context, target, inflictor, attacker, direction, point, damage, knockback, flags, meansOfDeath)
```

Apply damage.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `context` | `dynamic` | — | Context that carries state for the operation. |
| `target` | `dynamic` | — | target value consumed by this operation. |
| `inflictor` | `dynamic` | — | inflictor value consumed by this operation. |
| `attacker` | `dynamic` | — | attacker value consumed by this operation. |
| `direction` | `dynamic` | — | direction value consumed by this operation. |
| `point` | `dynamic` | — | point value consumed by this operation. |
| `damage` | `dynamic` | — | damage value consumed by this operation. |
| `knockback` | `dynamic` | — | knockback value consumed by this operation. |
| `flags` | `dynamic` | — | Bit flags controlling the operation. |
| `meansOfDeath` | `dynamic` | — | meansOfDeath value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/weapons/core.ml#L208)

<a id="function-function-miniquake2-game-weapons-core-cleartrace-function-cleartrace-start-mins-maxs-endposition-ignore-mask-src-miniquake2-game-weapons-core-ml-2022919757"></a>
### clearTrace

```ml
function clearTrace(start, mins, maxs, endPosition, ignore, mask)
```

Clear trace.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `start` | `dynamic` | — | start value consumed by this operation. |
| `mins` | `dynamic` | — | mins value consumed by this operation. |
| `maxs` | `dynamic` | — | maxs value consumed by this operation. |
| `endPosition` | `dynamic` | — | endPosition value consumed by this operation. |
| `ignore` | `dynamic` | — | ignore value consumed by this operation. |
| `mask` | `dynamic` | — | mask value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/weapons/core.ml#L58)

<a id="function-function-miniquake2-game-weapons-core-combatdamage-function-combatdamage-target-request-src-miniquake2-game-weapons-core-ml-219148215"></a>
### combatDamage

```ml
function combatDamage(target, request)
```

Return the combat damage value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `target` | `dynamic` | — | target value consumed by this operation. |
| `request` | `dynamic` | — | request value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/weapons/core.ml#L71)

<a id="function-function-miniquake2-game-weapons-core-createcontext-function-createcontext-callbacks-src-miniquake2-game-weapons-core-ml-2134583527"></a>
### createContext

```ml
function createContext(callbacks)
```

Create context.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `callbacks` | `dynamic` | — | callbacks value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/weapons/core.ml#L137)

<a id="function-function-miniquake2-game-weapons-core-damageattackernumber-function-damageattackernumber-src-miniquake2-game-weapons-core-ml-132099343"></a>
### damageAttackerNumber

```ml
function damageAttackerNumber()
```

Return the damage attacker number.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/weapons/core.ml#L46)

<a id="function-function-miniquake2-game-weapons-core-defaultcallbacks-function-defaultcallbacks-src-miniquake2-game-weapons-core-ml-382024627"></a>
### defaultCallbacks

```ml
function defaultCallbacks()
```

Return the default callbacks value.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/weapons/core.ml#L128)

<a id="function-function-miniquake2-game-weapons-core-emiteffect-function-emiteffect-context-kind-start-endposition-normal-style-count-src-miniquake2-game-weapons-core-ml-2050169801"></a>
### emitEffect

```ml
function emitEffect(context, kind, start, endPosition, normal, style, count)
```

Emit effect.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `context` | `dynamic` | — | Context that carries state for the operation. |
| `kind` | `dynamic` | — | kind value consumed by this operation. |
| `start` | `dynamic` | — | start value consumed by this operation. |
| `endPosition` | `dynamic` | — | endPosition value consumed by this operation. |
| `normal` | `dynamic` | — | normal value consumed by this operation. |
| `style` | `dynamic` | — | style value consumed by this operation. |
| `count` | `dynamic` | — | Number of items or units to process. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/weapons/core.ml#L189)

<a id="function-function-miniquake2-game-weapons-core-emptycontents-function-emptycontents-point-src-miniquake2-game-weapons-core-ml-506671653"></a>
### emptyContents

```ml
function emptyContents(point)
```

Report whether empty contents.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `point` | `dynamic` | — | point value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/weapons/core.ml#L65)

<a id="function-function-miniquake2-game-weapons-core-freeprojectile-function-freeprojectile-context-projectile-src-miniquake2-game-weapons-core-ml-26070121"></a>
### freeProjectile

```ml
function freeProjectile(context, projectile)
```

Release projectile.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `context` | `dynamic` | — | Context that carries state for the operation. |
| `projectile` | `dynamic` | — | projectile value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/weapons/core.ml#L162)

<a id="function-function-miniquake2-game-weapons-core-freethink-function-freethink-projectile-context-src-miniquake2-game-weapons-core-ml-693218267"></a>
### freeThink

```ml
function freeThink(projectile, context)
```

Release think.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `projectile` | `dynamic` | — | projectile value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/weapons/core.ml#L177)

<a id="constant-constant-miniquake2-game-weapons-core-max-weapon-event-history-const-max-weapon-event-history-1024-src-miniquake2-game-weapons-core-ml-1582525487"></a>
### MAX_WEAPON_EVENT_HISTORY

```ml
const MAX_WEAPON_EVENT_HISTORY = 1024
```

Defines the max weapon event history constant used by the miniquake2 game weapons core module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/weapons/core.ml#L24)

<a id="function-function-miniquake2-game-weapons-core-nododge-function-nododge-owner-start-direction-speed-src-miniquake2-game-weapons-core-ml-1562209840"></a>
### noDodge

```ml
function noDodge(owner, start, direction, speed)
```

Report whether no dodge.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `owner` | `dynamic` | — | owner value consumed by this operation. |
| `start` | `dynamic` | — | start value consumed by this operation. |
| `direction` | `dynamic` | — | direction value consumed by this operation. |
| `speed` | `dynamic` | — | speed value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/weapons/core.ml#L119)

<a id="function-function-miniquake2-game-weapons-core-noeffect-function-noeffect-effect-src-miniquake2-game-weapons-core-ml-378242844"></a>
### noEffect

```ml
function noEffect(effect)
```

Report whether no effect.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `effect` | `dynamic` | — | effect value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/weapons/core.ml#L88)

<a id="function-function-miniquake2-game-weapons-core-nofree-function-nofree-entity-src-miniquake2-game-weapons-core-ml-1350604474"></a>
### noFree

```ml
function noFree(entity)
```

Report whether no free.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/weapons/core.ml#L104)

<a id="function-function-miniquake2-game-weapons-core-nolink-function-nolink-entity-src-miniquake2-game-weapons-core-ml-1537577554"></a>
### noLink

```ml
function noLink(entity)
```

Report whether no link.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/weapons/core.ml#L99)

<a id="function-function-miniquake2-game-weapons-core-nonoise-function-nonoise-owner-position-noisetype-src-miniquake2-game-weapons-core-ml-1385988175"></a>
### noNoise

```ml
function noNoise(owner, position, noiseType)
```

Report whether no noise.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `owner` | `dynamic` | — | owner value consumed by this operation. |
| `position` | `dynamic` | — | position value consumed by this operation. |
| `noiseType` | `dynamic` | — | noiseType value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/weapons/core.ml#L111)

<a id="function-function-miniquake2-game-weapons-core-noradiustargets-function-noradiustargets-origin-radius-src-miniquake2-game-weapons-core-ml-48032025"></a>
### noRadiusTargets

```ml
function noRadiusTargets(origin, radius)
```

Report whether no radius targets.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `origin` | `dynamic` | — | origin value consumed by this operation. |
| `radius` | `dynamic` | — | radius value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/weapons/core.ml#L83)

<a id="function-function-miniquake2-game-weapons-core-nosound-function-nosound-entity-soundname-src-miniquake2-game-weapons-core-ml-1233763938"></a>
### noSound

```ml
function noSound(entity, soundName)
```

Report whether no sound.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `soundName` | `dynamic` | — | soundName value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/weapons/core.ml#L94)

<a id="function-function-miniquake2-game-weapons-core-radiusdamage-function-radiusdamage-context-inflictor-attacker-basedamage-ignore-radius-meansofdeath-src-miniquake2-game-weapons-core-ml-1302361318"></a>
### radiusDamage

```ml
function radiusDamage(context, inflictor, attacker, baseDamage, ignore, radius, meansOfDeath)
```

Return the radius damage value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `context` | `dynamic` | — | Context that carries state for the operation. |
| `inflictor` | `dynamic` | — | inflictor value consumed by this operation. |
| `attacker` | `dynamic` | — | attacker value consumed by this operation. |
| `baseDamage` | `dynamic` | — | baseDamage value consumed by this operation. |
| `ignore` | `dynamic` | — | ignore value consumed by this operation. |
| `radius` | `dynamic` | — | radius value consumed by this operation. |
| `meansOfDeath` | `dynamic` | — | meansOfDeath value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/weapons/core.ml#L230)

<a id="function-function-miniquake2-game-weapons-core-runduethinks-function-runduethinks-context-src-miniquake2-game-weapons-core-ml-2135289272"></a>
### runDueThinks

```ml
function runDueThinks(context)
```

Run due thinks.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `context` | `dynamic` | — | Context that carries state for the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/weapons/core.ml#L264)

<a id="function-function-miniquake2-game-weapons-core-spawnprojectile-function-spawnprojectile-context-classname-src-miniquake2-game-weapons-core-ml-896172445"></a>
### spawnProjectile

```ml
function spawnProjectile(context, className)
```

Spawn projectile.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `context` | `dynamic` | — | Context that carries state for the operation. |
| `className` | `dynamic` | — | className value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/weapons/core.ml#L152)

<a id="function-function-miniquake2-game-weapons-core-surfaceissky-function-surfaceissky-trace-src-miniquake2-game-weapons-core-ml-1594449386"></a>
### surfaceIsSky

```ml
function surfaceIsSky(trace)
```

Report whether surface is sky.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `trace` | `dynamic` | — | trace value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/weapons/core.ml#L300)

<a id="function-function-miniquake2-game-weapons-core-touchprojectile-function-touchprojectile-context-projectile-other-trace-src-miniquake2-game-weapons-core-ml-516060932"></a>
### touchProjectile

```ml
function touchProjectile(context, projectile, other, trace)
```

Handle projectile.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `context` | `dynamic` | — | Context that carries state for the operation. |
| `projectile` | `dynamic` | — | projectile value consumed by this operation. |
| `other` | `dynamic` | — | other value consumed by this operation. |
| `trace` | `dynamic` | — | trace value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/weapons/core.ml#L257)

<a id="function-function-miniquake2-game-weapons-core-weaponcoreappendevent-function-weaponcoreappendevent-context-value-src-miniquake2-game-weapons-core-ml-1999832213"></a>
### weaponCoreAppendEvent

```ml
function weaponCoreAppendEvent(context, value)
```

Append weapon core event.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `context` | `dynamic` | — | Context that carries state for the operation. |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/weapons/core.ml#L29)

<a id="global-global-miniquake2-game-weapons-core-weaponcoredamageattackernumber-weaponcoredamageattackernumber-src-miniquake2-game-weapons-core-ml-523258395"></a>
### weaponCoreDamageAttackerNumber

```ml
weaponCoreDamageAttackerNumber
```

Stores module-wide weapon core damage attacker number state for the miniquake2 game weapons core module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/weapons/core.ml#L22)

<a id="function-function-miniquake2-game-weapons-core-zerorandomsigned-function-zerorandomsigned-src-miniquake2-game-weapons-core-ml-1912181299"></a>
### zeroRandomSigned

```ml
function zeroRandomSigned()
```

Return the zero random signed value.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/weapons/core.ml#L123)
