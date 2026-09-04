# `src/miniquake2/game/gameplay/registry.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 game gameplay registry facilities for this project.

Package: [`miniquake2.game.gameplay.registry`](Package-miniquake2-game-gameplay-registry-117312862.md)

Reachable from entry: **yes**

## Imports

- `miniquake2/game/gameplay/constants.ml` as `gpconstants` → [src/miniquake2/game/gameplay/constants.ml](File-src-miniquake2-game-gameplay-constants-ml-1803115501.md)
- `miniquake2/game/gameplay/item_rules.ml` as `gprules` → [src/miniquake2/game/gameplay/item_rules.ml](File-src-miniquake2-game-gameplay-item-rules-ml-1747940557.md)
- `miniquake2/game/gameplay/powerups.ml` as `gppowerups` → [src/miniquake2/game/gameplay/powerups.ml](File-src-miniquake2-game-gameplay-powerups-ml-831759227.md)
- `miniquake2/game/gameplay/types.ml` as `gptypes` → [src/miniquake2/game/gameplay/types.ml](File-src-miniquake2-game-gameplay-types-ml-2088064005.md)
- `miniquake2/game/gameplay/weapons.ml` as `gpweapons` → [src/miniquake2/game/gameplay/weapons.ml](File-src-miniquake2-game-gameplay-weapons-ml-233473665.md)

## Declarations

<a id="function-function-miniquake2-game-gameplay-registry-ammo-function-ammo-index-classname-pickupname-quantity-tag-worldmodel-icon-src-miniquake2-game-gameplay-registry-ml-531078286"></a>
### ammo

```ml
function ammo(index, className, pickupName, quantity, tag, worldModel, icon)
```

Return the ammo value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `index` | `dynamic` | — | Zero-based index of the affected item. |
| `className` | `dynamic` | — | className value consumed by this operation. |
| `pickupName` | `dynamic` | — | pickupName value consumed by this operation. |
| `quantity` | `dynamic` | — | quantity value consumed by this operation. |
| `tag` | `dynamic` | — | tag value consumed by this operation. |
| `worldModel` | `dynamic` | — | worldModel value consumed by this operation. |
| `icon` | `dynamic` | — | icon value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/gameplay/registry.ml#L61)

<a id="function-function-miniquake2-game-gameplay-registry-armordata-function-armordata-basecount-maxcount-normalprotection-energyprotection-src-miniquake2-game-gameplay-registry-ml-353509345"></a>
### armorData

```ml
function armorData(baseCount, maxCount, normalProtection, energyProtection)
```

Return the armor data value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `baseCount` | `dynamic` | — | Number of base to process. |
| `maxCount` | `dynamic` | — | Number of max to process. |
| `normalProtection` | `dynamic` | — | normalProtection value consumed by this operation. |
| `energyProtection` | `dynamic` | — | energyProtection value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/gameplay/registry.ml#L154)

<a id="function-function-miniquake2-game-gameplay-registry-baseq2registry-function-baseq2registry-src-miniquake2-game-gameplay-registry-ml-882459397"></a>
### baseq2Registry

```ml
function baseq2Registry()
```

Return the baseq 2 registry value.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/gameplay/registry.ml#L211)

<a id="function-function-miniquake2-game-gameplay-registry-defaultregistry-function-defaultregistry-src-miniquake2-game-gameplay-registry-ml-794897677"></a>
### defaultRegistry

```ml
function defaultRegistry()
```

Performs the defaultRegistry operation for the miniquake2 game gameplay registry module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/gameplay/registry.ml#L84)

<a id="function-function-miniquake2-game-gameplay-registry-frames-function-frames-activatelast-firelast-idlelast-deactivatelast-pauseframes-fireframes-src-miniquake2-game-gameplay-registry-ml-751612588"></a>
### frames

```ml
function frames(activateLast, fireLast, idleLast, deactivateLast, pauseFrames, fireFrames)
```

Return the frames value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `activateLast` | `dynamic` | — | activateLast value consumed by this operation. |
| `fireLast` | `dynamic` | — | fireLast value consumed by this operation. |
| `idleLast` | `dynamic` | — | idleLast value consumed by this operation. |
| `deactivateLast` | `dynamic` | — | deactivateLast value consumed by this operation. |
| `pauseFrames` | `dynamic` | — | pauseFrames value consumed by this operation. |
| `fireFrames` | `dynamic` | — | fireFrames value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/gameplay/registry.ml#L23)

<a id="function-function-miniquake2-game-gameplay-registry-grenades-function-grenades-index-src-miniquake2-game-gameplay-registry-ml-68400857"></a>
### grenades

```ml
function grenades(index)
```

Return the grenades value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `index` | `dynamic` | — | Zero-based index of the affected item. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/gameplay/registry.ml#L71)

<a id="function-function-miniquake2-game-gameplay-registry-healthdata-function-healthdata-count-style-src-miniquake2-game-gameplay-registry-ml-1126831433"></a>
### healthData

```ml
function healthData(count, style)
```

Return the health data value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `count` | `dynamic` | — | Number of items or units to process. |
| `style` | `dynamic` | — | style value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/gameplay/registry.ml#L168)

<a id="function-function-miniquake2-game-gameplay-registry-inventoryslots-function-inventoryslots-registry-src-miniquake2-game-gameplay-registry-ml-152839782"></a>
### inventorySlots

```ml
function inventorySlots(registry)
```

Return the inventory slots value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `registry` | `dynamic` | — | registry value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/gameplay/registry.ml#L118)

<a id="function-function-miniquake2-game-gameplay-registry-simpledata-function-simpledata-kind-duration-src-miniquake2-game-gameplay-registry-ml-365392259"></a>
### simpleData

```ml
function simpleData(kind, duration)
```

Return the simple data value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `kind` | `dynamic` | — | kind value consumed by this operation. |
| `duration` | `dynamic` | — | duration value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/gameplay/registry.ml#L161)

<a id="function-function-miniquake2-game-gameplay-registry-stockitem-function-stockitem-index-classname-pickup-use-drop-pickupsound-worldmodel-icon-pickupname-quantity-flags-tag-precaches-ruledata-src-miniquake2-game-gameplay-registry-ml-1923247540"></a>
### stockItem

```ml
function stockItem(index, className, pickup, use, drop, pickupSound, worldModel, icon, pickupName, quantity, flags, tag, precaches, ruleData)
```

Return the stock item value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `index` | `dynamic` | — | Zero-based index of the affected item. |
| `className` | `dynamic` | — | className value consumed by this operation. |
| `pickup` | `dynamic` | — | pickup value consumed by this operation. |
| `use` | `dynamic` | — | use value consumed by this operation. |
| `drop` | `dynamic` | — | drop value consumed by this operation. |
| `pickupSound` | `dynamic` | — | pickupSound value consumed by this operation. |
| `worldModel` | `dynamic` | — | worldModel value consumed by this operation. |
| `icon` | `dynamic` | — | icon value consumed by this operation. |
| `pickupName` | `dynamic` | — | pickupName value consumed by this operation. |
| `quantity` | `dynamic` | — | quantity value consumed by this operation. |
| `flags` | `dynamic` | — | Bit flags controlling the operation. |
| `tag` | `dynamic` | — | tag value consumed by this operation. |
| `precaches` | `dynamic` | — | precaches value consumed by this operation. |
| `ruleData` | `dynamic` | — | ruleData value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/gameplay/registry.ml#L141)

<a id="function-function-miniquake2-game-gameplay-registry-stockregistry-function-stockregistry-src-miniquake2-game-gameplay-registry-ml-2093410863"></a>
### stockRegistry

```ml
function stockRegistry()
```

Additive complete stock registry. defaultRegistry deliberately remains the original weapon/ammo subset so its established indices and golden tests are stable until the integration layer opts into this registry.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/gameplay/registry.ml#L175)

<a id="function-function-miniquake2-game-gameplay-registry-validate-function-validate-registry-src-miniquake2-game-gameplay-registry-ml-740058310"></a>
### validate

```ml
function validate(registry)
```

Validates validate for the miniquake2 game gameplay registry workflow.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `registry` | `dynamic` | — | registry value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/gameplay/registry.ml#L217)

<a id="function-function-miniquake2-game-gameplay-registry-weapon-function-weapon-index-classname-pickupname-quantity-ammo-weaponmodel-worldmodel-viewmodel-icon-precaches-framecontract-src-miniquake2-game-gameplay-registry-ml-1929659864"></a>
### weapon

```ml
function weapon(index, className, pickupName, quantity, ammo, weaponModel, worldModel, viewModel, icon, precaches, frameContract)
```

Return the weapon value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `index` | `dynamic` | — | Zero-based index of the affected item. |
| `className` | `dynamic` | — | className value consumed by this operation. |
| `pickupName` | `dynamic` | — | pickupName value consumed by this operation. |
| `quantity` | `dynamic` | — | quantity value consumed by this operation. |
| `ammo` | `dynamic` | — | ammo value consumed by this operation. |
| `weaponModel` | `dynamic` | — | weaponModel value consumed by this operation. |
| `worldModel` | `dynamic` | — | worldModel value consumed by this operation. |
| `viewModel` | `dynamic` | — | viewModel value consumed by this operation. |
| `icon` | `dynamic` | — | icon value consumed by this operation. |
| `precaches` | `dynamic` | — | precaches value consumed by this operation. |
| `frameContract` | `dynamic` | — | frameContract value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/gameplay/registry.ml#L39)
