# `src/miniquake2/game/gameplay/item_rules.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 game gameplay item rules facilities for this project.

Package: [`miniquake2.game.gameplay.item_rules`](Package-miniquake2-game-gameplay-item-rules-1554831890.md)

Reachable from entry: **yes**

## Imports

- `miniquake2/game/constants.ml` as `gconstants` → [src/miniquake2/game/constants.ml](File-src-miniquake2-game-constants-ml-1723282332.md)
- `miniquake2/game/gameplay/constants.ml` as `gpconstants` → [src/miniquake2/game/gameplay/constants.ml](File-src-miniquake2-game-gameplay-constants-ml-1803115501.md)
- `miniquake2/game/gameplay/types.ml` as `gptypes` → [src/miniquake2/game/gameplay/types.ml](File-src-miniquake2-game-gameplay-types-ml-2088064005.md)
- `miniquake2/qcommon/text.ml` as `qtext` → [src/miniquake2/qcommon/text.ml](File-src-miniquake2-qcommon-text-ml-1570504148.md)

## Declarations

<a id="function-function-miniquake2-game-gameplay-item-rules-add-ammo-function-add-ammo-player-item-count-src-miniquake2-game-gameplay-item-rules-ml-170592080"></a>
### Add_Ammo

```ml
function Add_Ammo(player, item, count)
```

Add ammo.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `player` | `dynamic` | — | player value consumed by this operation. |
| `item` | `dynamic` | — | item value consumed by this operation. |
| `count` | `dynamic` | — | Number of items or units to process. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/gameplay/item_rules.ml#L85)

<a id="function-function-miniquake2-game-gameplay-item-rules-ammomaximum-function-ammomaximum-inventory-tag-src-miniquake2-game-gameplay-item-rules-ml-449085921"></a>
### ammoMaximum

```ml
function ammoMaximum(inventory, tag)
```

Return the ammo maximum value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `inventory` | `dynamic` | — | inventory value consumed by this operation. |
| `tag` | `dynamic` | — | tag value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/gameplay/item_rules.ml#L71)

<a id="function-function-miniquake2-game-gameplay-item-rules-dorespawn-function-dorespawn-itementity-time-src-miniquake2-game-gameplay-item-rules-ml-1388329294"></a>
### DoRespawn

```ml
function DoRespawn(itemEntity, time)
```

Return the do respawn value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `itemEntity` | `dynamic` | — | itemEntity value consumed by this operation. |
| `time` | `dynamic` | — | time value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/gameplay/item_rules.ml#L116)

<a id="function-function-miniquake2-game-gameplay-item-rules-drop-ammo-function-drop-ammo-player-item-registry-worldentitynumber-src-miniquake2-game-gameplay-item-rules-ml-1283488020"></a>
### Drop_Ammo

```ml
function Drop_Ammo(player, item, registry, worldEntityNumber)
```

Drop ammo.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `player` | `dynamic` | — | player value consumed by this operation. |
| `item` | `dynamic` | — | item value consumed by this operation. |
| `registry` | `dynamic` | — | registry value consumed by this operation. |
| `worldEntityNumber` | `dynamic` | — | worldEntityNumber value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/gameplay/item_rules.ml#L219)

<a id="function-function-miniquake2-game-gameplay-item-rules-drop-weapon-function-drop-weapon-player-item-registry-worldentitynumber-dmflags-src-miniquake2-game-gameplay-item-rules-ml-969926288"></a>
### Drop_Weapon

```ml
function Drop_Weapon(player, item, registry, worldEntityNumber, dmFlags)
```

Drop weapon.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `player` | `dynamic` | — | player value consumed by this operation. |
| `item` | `dynamic` | — | item value consumed by this operation. |
| `registry` | `dynamic` | — | registry value consumed by this operation. |
| `worldEntityNumber` | `dynamic` | — | worldEntityNumber value consumed by this operation. |
| `dmFlags` | `dynamic` | — | dmFlags value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/gameplay/item_rules.ml#L243)

<a id="function-function-miniquake2-game-gameplay-item-rules-findbyclassname-function-findbyclassname-registry-classname-src-miniquake2-game-gameplay-item-rules-ml-790802105"></a>
### findByClassName

```ml
function findByClassName(registry, className)
```

Find by class name.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `registry` | `dynamic` | — | registry value consumed by this operation. |
| `className` | `dynamic` | — | className value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/gameplay/item_rules.ml#L31)

<a id="function-function-miniquake2-game-gameplay-item-rules-findbypickupname-function-findbypickupname-registry-pickupname-src-miniquake2-game-gameplay-item-rules-ml-1769635865"></a>
### findByPickupName

```ml
function findByPickupName(registry, pickupName)
```

Finds by pickup name used by the miniquake2 game gameplay item rules module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `registry` | `dynamic` | — | registry value consumed by this operation. |
| `pickupName` | `dynamic` | — | pickupName value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/gameplay/item_rules.ml#L18)

<a id="function-function-miniquake2-game-gameplay-item-rules-getbyindex-function-getbyindex-registry-index-src-miniquake2-game-gameplay-item-rules-ml-1694805780"></a>
### getByIndex

```ml
function getByIndex(registry, index)
```

Return by index.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `registry` | `dynamic` | — | registry value consumed by this operation. |
| `index` | `dynamic` | — | Zero-based index of the affected item. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/gameplay/item_rules.ml#L44)

<a id="function-function-miniquake2-game-gameplay-item-rules-inventorycount-function-inventorycount-player-item-src-miniquake2-game-gameplay-item-rules-ml-943459799"></a>
### inventoryCount

```ml
function inventoryCount(player, item)
```

Return the inventory count.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `player` | `dynamic` | — | player value consumed by this operation. |
| `item` | `dynamic` | — | item value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/gameplay/item_rules.ml#L62)

<a id="function-function-miniquake2-game-gameplay-item-rules-pickup-ammo-function-pickup-ammo-itementity-player-context-registry-src-miniquake2-game-gameplay-item-rules-ml-914544356"></a>
### Pickup_Ammo

```ml
function Pickup_Ammo(itemEntity, player, context, registry)
```

Pick up ammo.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `itemEntity` | `dynamic` | — | itemEntity value consumed by this operation. |
| `player` | `dynamic` | — | player value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |
| `registry` | `dynamic` | — | registry value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/gameplay/item_rules.ml#L132)

<a id="function-function-miniquake2-game-gameplay-item-rules-pickup-item-function-pickup-item-itementity-player-context-registry-src-miniquake2-game-gameplay-item-rules-ml-1751898"></a>
### Pickup_Item

```ml
function Pickup_Item(itemEntity, player, context, registry)
```

Pick up item.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `itemEntity` | `dynamic` | — | itemEntity value consumed by this operation. |
| `player` | `dynamic` | — | player value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |
| `registry` | `dynamic` | — | registry value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/gameplay/item_rules.ml#L192)

<a id="function-function-miniquake2-game-gameplay-item-rules-pickup-weapon-function-pickup-weapon-itementity-player-context-registry-src-miniquake2-game-gameplay-item-rules-ml-2090251648"></a>
### Pickup_Weapon

```ml
function Pickup_Weapon(itemEntity, player, context, registry)
```

Pick up weapon.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `itemEntity` | `dynamic` | — | itemEntity value consumed by this operation. |
| `player` | `dynamic` | — | player value consumed by this operation. |
| `context` | `dynamic` | — | Context that carries state for the operation. |
| `registry` | `dynamic` | — | registry value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/gameplay/item_rules.ml#L156)

<a id="function-function-miniquake2-game-gameplay-item-rules-setrespawn-function-setrespawn-itementity-delay-time-src-miniquake2-game-gameplay-item-rules-ml-691959071"></a>
### SetRespawn

```ml
function SetRespawn(itemEntity, delay, time)
```

Set respawn.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `itemEntity` | `dynamic` | — | itemEntity value consumed by this operation. |
| `delay` | `dynamic` | — | delay value consumed by this operation. |
| `time` | `dynamic` | — | time value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/gameplay/item_rules.ml#L102)

<a id="function-function-miniquake2-game-gameplay-item-rules-use-weapon-function-use-weapon-player-item-registry-selectempty-src-miniquake2-game-gameplay-item-rules-ml-47667915"></a>
### Use_Weapon

```ml
function Use_Weapon(player, item, registry, selectEmpty)
```

Use weapon.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `player` | `dynamic` | — | player value consumed by this operation. |
| `item` | `dynamic` | — | item value consumed by this operation. |
| `registry` | `dynamic` | — | registry value consumed by this operation. |
| `selectEmpty` | `dynamic` | — | selectEmpty value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/gameplay/item_rules.ml#L202)
