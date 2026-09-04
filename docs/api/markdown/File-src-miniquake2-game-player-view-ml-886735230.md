# `src/miniquake2/game/player/view.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 game player view facilities for this project.

Package: [`miniquake2.game.player.view`](Package-miniquake2-game-player-view-2008450959.md)

Reachable from entry: **yes**

## Imports

- `miniquake2/game/gameplay/constants.ml` as `gpconstants` → [src/miniquake2/game/gameplay/constants.ml](File-src-miniquake2-game-gameplay-constants-ml-1803115501.md)
- `miniquake2/game/player/constants.ml` as `gplayerconstants` → [src/miniquake2/game/player/constants.ml](File-src-miniquake2-game-player-constants-ml-946982646.md)
- `miniquake2/game/player/rules.ml` as `gplayerrules` → [src/miniquake2/game/player/rules.ml](File-src-miniquake2-game-player-rules-ml-492402760.md)
- `miniquake2/physics/vector.ml` as `phv` → [src/miniquake2/physics/vector.ml](File-src-miniquake2-physics-vector-ml-1287862571.md)
- `miniquake2/qcommon/byteio.ml` as `qbyteio` → [src/miniquake2/qcommon/byteio.ml](File-src-miniquake2-qcommon-byteio-ml-159119335.md)
- `miniquake2/qcommon/constants.ml` as `qconstants` → [src/miniquake2/qcommon/constants.ml](File-src-miniquake2-qcommon-constants-ml-1976195726.md)
- `miniquake2/qcommon/types.ml` as `qtypes` → [src/miniquake2/qcommon/types.ml](File-src-miniquake2-qcommon-types-ml-1663266398.md)
- `std/math.ml` as `gplayermath` → `../MiniLangCompilerML/std/math.ml` — external dependency

## Declarations

<a id="function-function-miniquake2-game-player-view-applydamage-function-applydamage-context-player-amount-damageflags-meansofdeath-src-miniquake2-game-player-view-ml-1188281528"></a>
### ApplyDamage

```ml
function ApplyDamage(context, player, amount, damageFlags, meansOfDeath)
```

A custom callback may apply armor/team/death rules and returns actual health damage. The default keeps the environment layer useful before full wiring.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `context` | `dynamic` | — | Context that carries state for the operation. |
| `player` | `dynamic` | — | player value consumed by this operation. |
| `amount` | `dynamic` | — | amount value consumed by this operation. |
| `damageFlags` | `dynamic` | — | damageFlags value consumed by this operation. |
| `meansOfDeath` | `dynamic` | — | meansOfDeath value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/player/view.ml#L72)

<a id="function-function-miniquake2-game-player-view-clamp-function-clamp-value-minimum-maximum-src-miniquake2-game-player-view-ml-1757934676"></a>
### clamp

```ml
function clamp(value, minimum, maximum)
```

Clamp state.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |
| `minimum` | `dynamic` | — | minimum value consumed by this operation. |
| `maximum` | `dynamic` | — | maximum value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/player/view.ml#L274)

<a id="function-function-miniquake2-game-player-view-clientviewframe-function-clientviewframe-context-player-src-miniquake2-game-player-view-ml-1246652289"></a>
### ClientViewFrame

```ml
function ClientViewFrame(context, player)
```

Return the client view frame value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `context` | `dynamic` | — | Context that carries state for the operation. |
| `player` | `dynamic` | — | player value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/player/view.ml#L573)

<a id="function-function-miniquake2-game-player-view-emitsound-function-emitsound-context-player-channel-name-attenuation-src-miniquake2-game-player-view-ml-1798307903"></a>
### emitSound

```ml
function emitSound(context, player, channel, name, attenuation)
```

Emit sound.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `context` | `dynamic` | — | Context that carries state for the operation. |
| `player` | `dynamic` | — | player value consumed by this operation. |
| `channel` | `dynamic` | — | channel value consumed by this operation. |
| `name` | `dynamic` | — | Name of the affected item. |
| `attenuation` | `dynamic` | — | attenuation value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/player/view.ml#L25)

<a id="function-function-miniquake2-game-player-view-g-setclienteffects-function-g-setclienteffects-context-player-src-miniquake2-game-player-view-ml-1559354963"></a>
### G_SetClientEffects

```ml
function G_SetClientEffects(context, player)
```

Set g client effects.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `context` | `dynamic` | — | Context that carries state for the operation. |
| `player` | `dynamic` | — | player value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/player/view.ml#L439)

<a id="function-function-miniquake2-game-player-view-g-setclientevent-function-g-setclientevent-player-src-miniquake2-game-player-view-ml-1100547422"></a>
### G_SetClientEvent

```ml
function G_SetClientEvent(player)
```

Set g client event.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `player` | `dynamic` | — | player value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/player/view.ml#L473)

<a id="function-function-miniquake2-game-player-view-g-setclientframe-function-g-setclientframe-player-src-miniquake2-game-player-view-ml-1900107714"></a>
### G_SetClientFrame

```ml
function G_SetClientFrame(player)
```

Set g client frame.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `player` | `dynamic` | — | player value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/player/view.ml#L510)

<a id="function-function-miniquake2-game-player-view-g-setclientsound-function-g-setclientsound-context-player-src-miniquake2-game-player-view-ml-1279410499"></a>
### G_SetClientSound

```ml
function G_SetClientSound(context, player)
```

Set g client sound.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `context` | `dynamic` | — | Context that carries state for the operation. |
| `player` | `dynamic` | — | player value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/player/view.ml#L482)

<a id="function-function-miniquake2-game-player-view-p-damagefeedback-function-p-damagefeedback-context-player-forward-right-src-miniquake2-game-player-view-ml-616606842"></a>
### P_DamageFeedback

```ml
function P_DamageFeedback(context, player, forward, right)
```

Return the p damage feedback value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `context` | `dynamic` | — | Context that carries state for the operation. |
| `player` | `dynamic` | — | player value consumed by this operation. |
| `forward` | `dynamic` | — | forward value consumed by this operation. |
| `right` | `dynamic` | — | right value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/player/view.ml#L206)

<a id="function-function-miniquake2-game-player-view-p-fallingdamage-function-p-fallingdamage-context-player-src-miniquake2-game-player-view-ml-624531029"></a>
### P_FallingDamage

```ml
function P_FallingDamage(context, player)
```

Return the p falling damage value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `context` | `dynamic` | — | Context that carries state for the operation. |
| `player` | `dynamic` | — | player value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/player/view.ml#L169)

<a id="function-function-miniquake2-game-player-view-p-worldeffects-function-p-worldeffects-context-player-src-miniquake2-game-player-view-ml-379446591"></a>
### P_WorldEffects

```ml
function P_WorldEffects(context, player)
```

Return the p world effects value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `context` | `dynamic` | — | Context that carries state for the operation. |
| `player` | `dynamic` | — | player value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/player/view.ml#L94)

<a id="function-function-miniquake2-game-player-view-pointvector-function-pointvector-point-src-miniquake2-game-player-view-ml-1462696909"></a>
### pointVector

```ml
function pointVector(point)
```

Return the point vector value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `point` | `dynamic` | — | point value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/player/view.ml#L44)

<a id="function-function-miniquake2-game-player-view-randomindex-function-randomindex-context-count-src-miniquake2-game-player-view-ml-563057115"></a>
### randomIndex

```ml
function randomIndex(context, count)
```

Return the random index.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `context` | `dynamic` | — | Context that carries state for the operation. |
| `count` | `dynamic` | — | Number of items or units to process. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/player/view.ml#L34)

<a id="function-function-miniquake2-game-player-view-recorddamage-function-recorddamage-player-blood-armor-powerarmor-knockback-point-src-miniquake2-game-player-view-ml-544762310"></a>
### RecordDamage

```ml
function RecordDamage(player, blood, armor, powerArmor, knockback, point)
```

Public adapter for the damage accumulators normally filled by T_Damage.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `player` | `dynamic` | — | player value consumed by this operation. |
| `blood` | `dynamic` | — | blood value consumed by this operation. |
| `armor` | `dynamic` | — | armor value consumed by this operation. |
| `powerArmor` | `dynamic` | — | powerArmor value consumed by this operation. |
| `knockback` | `dynamic` | — | knockback value consumed by this operation. |
| `point` | `dynamic` | — | point value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/player/view.ml#L56)

<a id="function-function-miniquake2-game-player-view-sv-addblend-function-sv-addblend-red-green-blue-alpha-blend-src-miniquake2-game-player-view-ml-1069402018"></a>
### SV_AddBlend

```ml
function SV_AddBlend(red, green, blue, alpha, blend)
```

Add sv blend.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `red` | `dynamic` | — | red value consumed by this operation. |
| `green` | `dynamic` | — | green value consumed by this operation. |
| `blue` | `dynamic` | — | blue value consumed by this operation. |
| `alpha` | `dynamic` | — | alpha value consumed by this operation. |
| `blend` | `dynamic` | — | blend value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/player/view.ml#L383)

<a id="function-function-miniquake2-game-player-view-sv-calcblend-function-sv-calcblend-context-player-src-miniquake2-game-player-view-ml-406096623"></a>
### SV_CalcBlend

```ml
function SV_CalcBlend(context, player)
```

Return the sv calc blend value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `context` | `dynamic` | — | Context that carries state for the operation. |
| `player` | `dynamic` | — | player value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/player/view.ml#L397)

<a id="function-function-miniquake2-game-player-view-sv-calcgunoffset-function-sv-calcgunoffset-context-player-forward-right-up-src-miniquake2-game-player-view-ml-120594391"></a>
### SV_CalcGunOffset

```ml
function SV_CalcGunOffset(context, player, forward, right, up)
```

Return the sv calc gun offset.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `context` | `dynamic` | — | Context that carries state for the operation. |
| `player` | `dynamic` | — | player value consumed by this operation. |
| `forward` | `dynamic` | — | forward value consumed by this operation. |
| `right` | `dynamic` | — | right value consumed by this operation. |
| `up` | `dynamic` | — | up value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/player/view.ml#L346)

<a id="function-function-miniquake2-game-player-view-sv-calcroll-function-sv-calcroll-context-player-right-src-miniquake2-game-player-view-ml-1522580671"></a>
### SV_CalcRoll

```ml
function SV_CalcRoll(context, player, right)
```

Return the sv calc roll value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `context` | `dynamic` | — | Context that carries state for the operation. |
| `player` | `dynamic` | — | player value consumed by this operation. |
| `right` | `dynamic` | — | right value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/player/view.ml#L284)

<a id="function-function-miniquake2-game-player-view-sv-calcviewoffset-function-sv-calcviewoffset-context-player-forward-right-src-miniquake2-game-player-view-ml-821743576"></a>
### SV_CalcViewOffset

```ml
function SV_CalcViewOffset(context, player, forward, right)
```

Return the sv calc view offset.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `context` | `dynamic` | — | Context that carries state for the operation. |
| `player` | `dynamic` | — | player value consumed by this operation. |
| `forward` | `dynamic` | — | forward value consumed by this operation. |
| `right` | `dynamic` | — | right value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/player/view.ml#L300)

<a id="function-function-miniquake2-game-player-view-updatebob-function-updatebob-player-src-miniquake2-game-player-view-ml-754574690"></a>
### UpdateBob

```ml
function UpdateBob(player)
```

Update bob.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `player` | `dynamic` | — | player value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/player/view.ml#L553)
