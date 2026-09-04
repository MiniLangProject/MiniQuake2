# `src/miniquake2/game/world/movers.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 game world movers facilities for this project.

Package: [`miniquake2.game.world.movers`](Package-miniquake2-game-world-movers-2058949969.md)

Reachable from entry: **yes**

## Imports

- `miniquake2/game/world/constants.ml` as `gwconstants` → [src/miniquake2/game/world/constants.ml](File-src-miniquake2-game-world-constants-ml-774918061.md)
- `miniquake2/game/world/core.ml` as `gwcore` → [src/miniquake2/game/world/core.ml](File-src-miniquake2-game-world-core-ml-1171136969.md)
- `miniquake2/game/world/types.ml` as `gwtypes` → [src/miniquake2/game/world/types.ml](File-src-miniquake2-game-world-types-ml-1207695045.md)
- `miniquake2/game/world/vector.ml` as `gwvector` → [src/miniquake2/game/world/vector.ml](File-src-miniquake2-game-world-vector-ml-1561306429.md)
- `miniquake2/qcommon/byteio.ml` as `qbyteio` → [src/miniquake2/qcommon/byteio.ml](File-src-miniquake2-qcommon-byteio-ml-159119335.md)
- `miniquake2/qcommon/types.ml` as `qt` → [src/miniquake2/qcommon/types.ml](File-src-miniquake2-qcommon-types-ml-1663266398.md)
- `std/math.ml` as `smath` → `../MiniLangCompilerML/std/math.ml` — external dependency

## Declarations

<a id="function-function-miniquake2-game-world-movers-acceleratemove-function-acceleratemove-moveinfo-src-miniquake2-game-world-movers-ml-1255316936"></a>
### accelerateMove

```ml
function accelerateMove(moveInfo)
```

Move accelerate.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `moveInfo` | `dynamic` | — | moveInfo value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/movers.ml#L79)

<a id="function-function-miniquake2-game-world-movers-accelerationdistance-function-accelerationdistance-target-rate-src-miniquake2-game-world-movers-ml-1318905418"></a>
### accelerationDistance

```ml
function accelerationDistance(target, rate)
```

Return the acceleration distance value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `target` | `dynamic` | — | target value consumed by this operation. |
| `rate` | `dynamic` | — | rate value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/movers.ml#L54)

<a id="function-function-miniquake2-game-world-movers-buttondone-function-buttondone-entity-world-src-miniquake2-game-world-movers-ml-1923688470"></a>
### buttonDone

```ml
function buttonDone(entity, world)
```

func_button

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/movers.ml#L170)

<a id="function-function-miniquake2-game-world-movers-buttonfire-function-buttonfire-entity-world-src-miniquake2-game-world-movers-ml-1203250158"></a>
### buttonFire

```ml
function buttonFire(entity, world)
```

Fire button.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/movers.ml#L207)

<a id="function-function-miniquake2-game-world-movers-buttonkilled-function-buttonkilled-entity-inflictor-attacker-damage-point-world-src-miniquake2-game-world-movers-ml-1665188160"></a>
### buttonKilled

```ml
function buttonKilled(entity, inflictor, attacker, damage, point, world)
```

Return the button killed value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `inflictor` | `dynamic` | — | inflictor value consumed by this operation. |
| `attacker` | `dynamic` | — | attacker value consumed by this operation. |
| `damage` | `dynamic` | — | damage value consumed by this operation. |
| `point` | `dynamic` | — | point value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/movers.ml#L244)

<a id="function-function-miniquake2-game-world-movers-buttonreturn-function-buttonreturn-entity-world-src-miniquake2-game-world-movers-ml-1015394142"></a>
### buttonReturn

```ml
function buttonReturn(entity, world)
```

Return button.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/movers.ml#L180)

<a id="function-function-miniquake2-game-world-movers-buttontouch-function-buttontouch-entity-other-world-src-miniquake2-game-world-movers-ml-491674602"></a>
### buttonTouch

```ml
function buttonTouch(entity, other, world)
```

Handle button.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `other` | `dynamic` | — | other value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/movers.ml#L231)

<a id="function-function-miniquake2-game-world-movers-buttonuse-function-buttonuse-entity-other-activator-world-src-miniquake2-game-world-movers-ml-1391595737"></a>
### buttonUse

```ml
function buttonUse(entity, other, activator, world)
```

Use button.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `other` | `dynamic` | — | other value consumed by this operation. |
| `activator` | `dynamic` | — | activator value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/movers.ml#L222)

<a id="function-function-miniquake2-game-world-movers-buttonwait-function-buttonwait-entity-world-src-miniquake2-game-world-movers-ml-764618646"></a>
### buttonWait

```ml
function buttonWait(entity, world)
```

Return the button wait value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/movers.ml#L191)

<a id="function-function-miniquake2-game-world-movers-calculateacceleratedmove-function-calculateacceleratedmove-moveinfo-src-miniquake2-game-world-movers-ml-1209085248"></a>
### calculateAcceleratedMove

```ml
function calculateAcceleratedMove(moveInfo)
```

Calculate accelerated move.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `moveInfo` | `dynamic` | — | moveInfo value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/movers.ml#L60)

<a id="function-function-miniquake2-game-world-movers-calculatedoormovespeed-function-calculatedoormovespeed-entity-world-src-miniquake2-game-world-movers-ml-2007789258"></a>
### calculateDoorMoveSpeed

```ml
function calculateDoorMoveSpeed(entity, world)
```

Calculate door move speed.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/movers.ml#L318)

<a id="function-function-miniquake2-game-world-movers-configuresecretdoorgeometry-function-configuresecretdoorgeometry-entity-world-src-miniquake2-game-world-movers-ml-940650206"></a>
### configureSecretDoorGeometry

```ml
function configureSecretDoorGeometry(entity, world)
```

func_door_secret is a two-leg mover. It slides sideways, pauses, moves forward, waits open, then reverses the same two legs.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/movers.ml#L648)

<a id="function-function-miniquake2-game-world-movers-conveyoruse-function-conveyoruse-entity-other-activator-world-src-miniquake2-game-world-movers-ml-2116299691"></a>
### conveyorUse

```ml
function conveyorUse(entity, other, activator, world)
```

func_conveyor

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `other` | `dynamic` | — | other value consumed by this operation. |
| `activator` | `dynamic` | — | activator value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/movers.ml#L1491)

<a id="function-function-miniquake2-game-world-movers-doorblocked-function-doorblocked-entity-other-world-src-miniquake2-game-world-movers-ml-1303617180"></a>
### doorBlocked

```ml
function doorBlocked(entity, other, world)
```

Report whether door blocked.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `other` | `dynamic` | — | other value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/movers.ml#L506)

<a id="function-function-miniquake2-game-world-movers-doorgodown-function-doorgodown-entity-world-src-miniquake2-game-world-movers-ml-2046428750"></a>
### doorGoDown

```ml
function doorGoDown(entity, world)
```

Return the door go down value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/movers.ml#L433)

<a id="function-function-miniquake2-game-world-movers-doorgoup-function-doorgoup-entity-activator-world-src-miniquake2-game-world-movers-ml-297517253"></a>
### doorGoUp

```ml
function doorGoUp(entity, activator, world)
```

Return the door go up value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `activator` | `dynamic` | — | activator value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/movers.ml#L454)

<a id="function-function-miniquake2-game-world-movers-doorhitbottom-function-doorhitbottom-entity-world-src-miniquake2-game-world-movers-ml-1022458726"></a>
### doorHitBottom

```ml
function doorHitBottom(entity, world)
```

Return the door hit bottom value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/movers.ml#L417)

<a id="function-function-miniquake2-game-world-movers-doorhittop-function-doorhittop-entity-world-src-miniquake2-game-world-movers-ml-636379042"></a>
### doorHitTop

```ml
function doorHitTop(entity, world)
```

Return the door hit top value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/movers.ml#L397)

<a id="function-function-miniquake2-game-world-movers-doorkilled-function-doorkilled-entity-inflictor-attacker-damage-point-world-src-miniquake2-game-world-movers-ml-715897700"></a>
### doorKilled

```ml
function doorKilled(entity, inflictor, attacker, damage, point, world)
```

Return the door killed value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `inflictor` | `dynamic` | — | inflictor value consumed by this operation. |
| `attacker` | `dynamic` | — | attacker value consumed by this operation. |
| `damage` | `dynamic` | — | damage value consumed by this operation. |
| `point` | `dynamic` | — | point value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/movers.ml#L538)

<a id="function-function-miniquake2-game-world-movers-doortouch-function-doortouch-entity-other-world-src-miniquake2-game-world-movers-ml-945385406"></a>
### doorTouch

```ml
function doorTouch(entity, other, world)
```

Handle door.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `other` | `dynamic` | — | other value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/movers.ml#L305)

<a id="function-function-miniquake2-game-world-movers-doortriggertouch-function-doortriggertouch-trigger-other-world-src-miniquake2-game-world-movers-ml-1419445819"></a>
### doorTriggerTouch

```ml
function doorTriggerTouch(trigger, other, world)
```

Handle door trigger.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `trigger` | `dynamic` | — | trigger value consumed by this operation. |
| `other` | `dynamic` | — | other value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/movers.ml#L347)

<a id="function-function-miniquake2-game-world-movers-dooruse-function-dooruse-entity-other-activator-world-src-miniquake2-game-world-movers-ml-1321005493"></a>
### doorUse

```ml
function doorUse(entity, other, activator, world)
```

Use door.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `other` | `dynamic` | — | other value consumed by this operation. |
| `activator` | `dynamic` | — | activator value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/movers.ml#L480)

<a id="function-function-miniquake2-game-world-movers-dooruseareaportals-function-dooruseareaportals-entity-isopen-world-src-miniquake2-game-world-movers-ml-346526670"></a>
### doorUseAreaPortals

```ml
function doorUseAreaPortals(entity, isOpen, world)
```

func_door

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `isOpen` | `dynamic` | — | isOpen value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/movers.ml#L293)

<a id="function-function-miniquake2-game-world-movers-elevatorinit-function-elevatorinit-entity-world-src-miniquake2-game-world-movers-ml-550501154"></a>
### elevatorInit

```ml
function elevatorInit(entity, world)
```

Initialize elevator.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/movers.ml#L1406)

<a id="function-function-miniquake2-game-world-movers-elevatoruse-function-elevatoruse-entity-other-activator-world-src-miniquake2-game-world-movers-ml-190076601"></a>
### elevatorUse

```ml
function elevatorUse(entity, other, activator, world)
```

trigger_elevator from g_func.c. The train remains the authoritative mover; the trigger only resolves a requested path_corner and resumes it.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `other` | `dynamic` | — | other value consumed by this operation. |
| `activator` | `dynamic` | — | activator value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/movers.ml#L1382)

<a id="function-function-miniquake2-game-world-movers-explosiveexplode-function-explosiveexplode-entity-inflictor-attacker-damage-point-world-src-miniquake2-game-world-movers-ml-230555596"></a>
### explosiveExplode

```ml
function explosiveExplode(entity, inflictor, attacker, damage, point, world)
```

func_explosive from g_misc.c (kept here with the brush movers).

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `inflictor` | `dynamic` | — | inflictor value consumed by this operation. |
| `attacker` | `dynamic` | — | attacker value consumed by this operation. |
| `damage` | `dynamic` | — | damage value consumed by this operation. |
| `point` | `dynamic` | — | point value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/movers.ml#L1526)

<a id="function-function-miniquake2-game-world-movers-explosivespawn-function-explosivespawn-entity-other-activator-world-src-miniquake2-game-world-movers-ml-579175947"></a>
### explosiveSpawn

```ml
function explosiveSpawn(entity, other, activator, world)
```

Spawn explosive.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `other` | `dynamic` | — | other value consumed by this operation. |
| `activator` | `dynamic` | — | activator value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/movers.ml#L1565)

<a id="function-function-miniquake2-game-world-movers-explosiveuse-function-explosiveuse-entity-other-activator-world-src-miniquake2-game-world-movers-ml-2048322923"></a>
### explosiveUse

```ml
function explosiveUse(entity, other, activator, world)
```

Use explosive.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `other` | `dynamic` | — | other value consumed by this operation. |
| `activator` | `dynamic` | — | activator value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/movers.ml#L1556)

<a id="function-function-miniquake2-game-world-movers-killboxuse-function-killboxuse-entity-other-activator-world-src-miniquake2-game-world-movers-ml-136017839"></a>
### killBoxUse

```ml
function killBoxUse(entity, other, activator, world)
```

func_killbox from g_func.c.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `other` | `dynamic` | — | other value consumed by this operation. |
| `activator` | `dynamic` | — | activator value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/movers.ml#L1609)

<a id="function-function-miniquake2-game-world-movers-movebegin-function-movebegin-entity-world-src-miniquake2-game-world-movers-ml-682606490"></a>
### moveBegin

```ml
function moveBegin(entity, world)
```

Move begin.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/movers.ml#L41)

<a id="function-function-miniquake2-game-world-movers-movecalc-function-movecalc-entity-destination-endfunction-world-src-miniquake2-game-world-movers-ml-372689583"></a>
### moveCalc

```ml
function moveCalc(entity, destination, endFunction, world)
```

Move calc.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `destination` | `dynamic` | — | destination value consumed by this operation. |
| `endFunction` | `dynamic` | — | endFunction value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/movers.ml#L135)

<a id="function-function-miniquake2-game-world-movers-movedone-function-movedone-entity-world-src-miniquake2-game-world-movers-ml-2141543690"></a>
### moveDone

```ml
function moveDone(entity, world)
```

Move done.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/movers.ml#L21)

<a id="function-function-miniquake2-game-world-movers-movefinal-function-movefinal-entity-world-src-miniquake2-game-world-movers-ml-957388304"></a>
### moveFinal

```ml
function moveFinal(entity, world)
```

Move final.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/movers.ml#L30)

<a id="function-function-miniquake2-game-world-movers-platblocked-function-platblocked-entity-other-world-src-miniquake2-game-world-movers-ml-1760191634"></a>
### platBlocked

```ml
function platBlocked(entity, other, world)
```

Report whether plat blocked.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `other` | `dynamic` | — | other value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/movers.ml#L1113)

<a id="function-function-miniquake2-game-world-movers-platcentertouch-function-platcentertouch-trigger-other-world-src-miniquake2-game-world-movers-ml-952207857"></a>
### platCenterTouch

```ml
function platCenterTouch(trigger, other, world)
```

Handle plat center.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `trigger` | `dynamic` | — | trigger value consumed by this operation. |
| `other` | `dynamic` | — | other value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/movers.ml#L1069)

<a id="function-function-miniquake2-game-world-movers-platgodown-function-platgodown-entity-world-src-miniquake2-game-world-movers-ml-1326003186"></a>
### platGoDown

```ml
function platGoDown(entity, world)
```

Return the plat go down value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/movers.ml#L1034)

<a id="function-function-miniquake2-game-world-movers-platgoup-function-platgoup-entity-world-src-miniquake2-game-world-movers-ml-778535438"></a>
### platGoUp

```ml
function platGoUp(entity, world)
```

Return the plat go up value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/movers.ml#L1046)

<a id="function-function-miniquake2-game-world-movers-plathitbottom-function-plathitbottom-entity-world-src-miniquake2-game-world-movers-ml-429208676"></a>
### platHitBottom

```ml
function platHitBottom(entity, world)
```

Return the plat hit bottom value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/movers.ml#L1022)

<a id="function-function-miniquake2-game-world-movers-plathittop-function-plathittop-entity-world-src-miniquake2-game-world-movers-ml-152188810"></a>
### platHitTop

```ml
function platHitTop(entity, world)
```

func_plat

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/movers.ml#L1008)

<a id="function-function-miniquake2-game-world-movers-platuse-function-platuse-entity-other-activator-world-src-miniquake2-game-world-movers-ml-2141580459"></a>
### platUse

```ml
function platUse(entity, other, activator, world)
```

Use plat.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `other` | `dynamic` | — | other value consumed by this operation. |
| `activator` | `dynamic` | — | activator value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/movers.ml#L1060)

<a id="function-function-miniquake2-game-world-movers-refreshbrushgeometry-function-refreshbrushgeometry-entity-world-src-miniquake2-game-world-movers-ml-139448254"></a>
### refreshBrushGeometry

```ml
function refreshBrushGeometry(entity, world)
```

Inline BSP bounds arrive through game_import_t.setmodel after the managed spawn callbacks have established behavior. Rebuild only the geometric endpoints here; do not reapply speed scaling or allocate trigger helpers.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/movers.ml#L1165)

<a id="function-function-miniquake2-game-world-movers-restoremoverstate-function-restoremoverstate-entity-world-src-miniquake2-game-world-movers-ml-1659183766"></a>
### restoreMoverState

```ml
function restoreMoverState(entity, world)
```

Rebind serialized callback identities from classname/state. Function values are deliberately not written to disk; the deterministic spawn path restores behavior and this boundary restores the currently pending mover callback.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/movers.ml#L1708)

<a id="function-function-miniquake2-game-world-movers-rotatingdoorgodown-function-rotatingdoorgodown-entity-world-src-miniquake2-game-world-movers-ml-32137782"></a>
### rotatingDoorGoDown

```ml
function rotatingDoorGoDown(entity, world)
```

Return the rotating door go down value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/movers.ml#L868)

<a id="function-function-miniquake2-game-world-movers-rotatingdoorgoup-function-rotatingdoorgoup-entity-activator-world-src-miniquake2-game-world-movers-ml-2032161461"></a>
### rotatingDoorGoUp

```ml
function rotatingDoorGoUp(entity, activator, world)
```

Return the rotating door go up value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `activator` | `dynamic` | — | activator value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/movers.ml#L903)

<a id="function-function-miniquake2-game-world-movers-rotatingdoorhitbottom-function-rotatingdoorhitbottom-entity-world-src-miniquake2-game-world-movers-ml-1743231958"></a>
### rotatingDoorHitBottom

```ml
function rotatingDoorHitBottom(entity, world)
```

Return the rotating door hit bottom value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/movers.ml#L852)

<a id="function-function-miniquake2-game-world-movers-rotatingdoorhittop-function-rotatingdoorhittop-entity-world-src-miniquake2-game-world-movers-ml-1493084890"></a>
### rotatingDoorHitTop

```ml
function rotatingDoorHitTop(entity, world)
```

Return the rotating door hit top value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/movers.ml#L883)

<a id="function-function-miniquake2-game-world-movers-rotatingdooruse-function-rotatingdooruse-entity-other-activator-world-src-miniquake2-game-world-movers-ml-1636355525"></a>
### rotatingDoorUse

```ml
function rotatingDoorUse(entity, other, activator, world)
```

Use rotating door.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `other` | `dynamic` | — | other value consumed by this operation. |
| `activator` | `dynamic` | — | activator value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/movers.ml#L927)

<a id="function-function-miniquake2-game-world-movers-secretdoorblocked-function-secretdoorblocked-entity-other-world-src-miniquake2-game-world-movers-ml-688763404"></a>
### secretDoorBlocked

```ml
function secretDoorBlocked(entity, other, world)
```

Report whether secret door blocked.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `other` | `dynamic` | — | other value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/movers.ml#L790)

<a id="function-function-miniquake2-game-world-movers-secretdoordie-function-secretdoordie-entity-inflictor-attacker-damage-point-world-src-miniquake2-game-world-movers-ml-792127568"></a>
### secretDoorDie

```ml
function secretDoorDie(entity, inflictor, attacker, damage, point, world)
```

Handle secret door.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `inflictor` | `dynamic` | — | inflictor value consumed by this operation. |
| `attacker` | `dynamic` | — | attacker value consumed by this operation. |
| `damage` | `dynamic` | — | damage value consumed by this operation. |
| `point` | `dynamic` | — | point value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/movers.ml#L810)

<a id="function-function-miniquake2-game-world-movers-secretdoordone-function-secretdoordone-entity-world-src-miniquake2-game-world-movers-ml-1151636826"></a>
### secretDoorDone

```ml
function secretDoorDone(entity, world)
```

Return the secret door done value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/movers.ml#L751)

<a id="function-function-miniquake2-game-world-movers-secretdoormove1-function-secretdoormove1-entity-world-src-miniquake2-game-world-movers-ml-880070942"></a>
### secretDoorMove1

```ml
function secretDoorMove1(entity, world)
```

Move secret door 1.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/movers.ml#L694)

<a id="function-function-miniquake2-game-world-movers-secretdoormove2-function-secretdoormove2-entity-world-src-miniquake2-game-world-movers-ml-284647884"></a>
### secretDoorMove2

```ml
function secretDoorMove2(entity, world)
```

Move secret door 2.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/movers.ml#L686)

<a id="function-function-miniquake2-game-world-movers-secretdoormove3-function-secretdoormove3-entity-world-src-miniquake2-game-world-movers-ml-1748327466"></a>
### secretDoorMove3

```ml
function secretDoorMove3(entity, world)
```

Move secret door 3.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/movers.ml#L704)

<a id="function-function-miniquake2-game-world-movers-secretdoormove4-function-secretdoormove4-entity-world-src-miniquake2-game-world-movers-ml-1068045364"></a>
### secretDoorMove4

```ml
function secretDoorMove4(entity, world)
```

Move secret door 4.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/movers.ml#L720)

<a id="function-function-miniquake2-game-world-movers-secretdoormove5-function-secretdoormove5-entity-world-src-miniquake2-game-world-movers-ml-644761974"></a>
### secretDoorMove5

```ml
function secretDoorMove5(entity, world)
```

Move secret door 5.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/movers.ml#L733)

<a id="function-function-miniquake2-game-world-movers-secretdoormove6-function-secretdoormove6-entity-world-src-miniquake2-game-world-movers-ml-467697404"></a>
### secretDoorMove6

```ml
function secretDoorMove6(entity, world)
```

Move secret door 6.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/movers.ml#L743)

<a id="function-function-miniquake2-game-world-movers-secretdooruse-function-secretdooruse-entity-other-activator-world-src-miniquake2-game-world-movers-ml-1948474873"></a>
### secretDoorUse

```ml
function secretDoorUse(entity, other, activator, world)
```

Use secret door.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `other` | `dynamic` | — | other value consumed by this operation. |
| `activator` | `dynamic` | — | activator value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/movers.ml#L771)

<a id="function-function-miniquake2-game-world-movers-sp-func-button-function-sp-func-button-entity-world-src-miniquake2-game-world-movers-ml-2014516934"></a>
### SP_func_button

```ml
function SP_func_button(entity, world)
```

Spawn func button.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/movers.ml#L1638)

<a id="function-function-miniquake2-game-world-movers-sp-func-conveyor-function-sp-func-conveyor-entity-world-src-miniquake2-game-world-movers-ml-168927742"></a>
### SP_func_conveyor

```ml
function SP_func_conveyor(entity, world)
```

Spawn func conveyor.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/movers.ml#L1680)

<a id="function-function-miniquake2-game-world-movers-sp-func-door-function-sp-func-door-entity-world-src-miniquake2-game-world-movers-ml-245227810"></a>
### SP_func_door

```ml
function SP_func_door(entity, world)
```

Spawn func door.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/movers.ml#L1644)

<a id="function-function-miniquake2-game-world-movers-sp-func-door-secret-function-sp-func-door-secret-entity-world-src-miniquake2-game-world-movers-ml-2075471118"></a>
### SP_func_door_secret

```ml
function SP_func_door_secret(entity, world)
```

Spawn func door secret.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/movers.ml#L1656)

<a id="function-function-miniquake2-game-world-movers-sp-func-explosive-function-sp-func-explosive-entity-world-deathmatch-src-miniquake2-game-world-movers-ml-1651937503"></a>
### SP_func_explosive

```ml
function SP_func_explosive(entity, world, deathmatch)
```

Spawn func explosive.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |
| `deathmatch` | `dynamic` | — | deathmatch value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/movers.ml#L1687)

<a id="function-function-miniquake2-game-world-movers-sp-func-killbox-function-sp-func-killbox-entity-world-src-miniquake2-game-world-movers-ml-726676238"></a>
### SP_func_killbox

```ml
function SP_func_killbox(entity, world)
```

Spawn func killbox.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/movers.ml#L1693)

<a id="function-function-miniquake2-game-world-movers-sp-func-plat-function-sp-func-plat-entity-world-src-miniquake2-game-world-movers-ml-1304284142"></a>
### SP_func_plat

```ml
function SP_func_plat(entity, world)
```

Spawn func plat.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/movers.ml#L1662)

<a id="function-function-miniquake2-game-world-movers-sp-func-timer-function-sp-func-timer-entity-world-src-miniquake2-game-world-movers-ml-445908910"></a>
### SP_func_timer

```ml
function SP_func_timer(entity, world)
```

Spawn func timer.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/movers.ml#L1674)

<a id="function-function-miniquake2-game-world-movers-sp-func-train-function-sp-func-train-entity-world-src-miniquake2-game-world-movers-ml-1571373860"></a>
### SP_func_train

```ml
function SP_func_train(entity, world)
```

Spawn func train.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/movers.ml#L1668)

<a id="function-function-miniquake2-game-world-movers-sp-func-water-function-sp-func-water-entity-world-src-miniquake2-game-world-movers-ml-166986118"></a>
### SP_func_water

```ml
function SP_func_water(entity, world)
```

Spawn func water.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/movers.ml#L1650)

<a id="function-function-miniquake2-game-world-movers-sp-trigger-elevator-function-sp-trigger-elevator-entity-world-src-miniquake2-game-world-movers-ml-1887854696"></a>
### SP_trigger_elevator

```ml
function SP_trigger_elevator(entity, world)
```

Spawn trigger elevator.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/movers.ml#L1699)

<a id="function-function-miniquake2-game-world-movers-spawnbutton-function-spawnbutton-entity-world-src-miniquake2-game-world-movers-ml-1231108776"></a>
### spawnButton

```ml
function spawnButton(entity, world)
```

Spawn button.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/movers.ml#L254)

<a id="function-function-miniquake2-game-world-movers-spawnconveyor-function-spawnconveyor-entity-world-src-miniquake2-game-world-movers-ml-1254204090"></a>
### spawnConveyor

```ml
function spawnConveyor(entity, world)
```

Spawn conveyor.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/movers.ml#L1506)

<a id="function-function-miniquake2-game-world-movers-spawndoor-function-spawndoor-entity-world-src-miniquake2-game-world-movers-ml-1273988796"></a>
### spawnDoor

```ml
function spawnDoor(entity, world)
```

Spawn door.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/movers.ml#L554)

<a id="function-function-miniquake2-game-world-movers-spawndoortrigger-function-spawndoortrigger-entity-world-src-miniquake2-game-world-movers-ml-1161235122"></a>
### spawnDoorTrigger

```ml
function spawnDoorTrigger(entity, world)
```

Spawn door trigger.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/movers.ml#L361)

<a id="function-function-miniquake2-game-world-movers-spawnelevator-function-spawnelevator-entity-world-src-miniquake2-game-world-movers-ml-416997712"></a>
### spawnElevator

```ml
function spawnElevator(entity, world)
```

Spawn elevator.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/movers.ml#L1429)

<a id="function-function-miniquake2-game-world-movers-spawnexplosive-function-spawnexplosive-entity-world-deathmatch-src-miniquake2-game-world-movers-ml-1253819219"></a>
### spawnExplosive

```ml
function spawnExplosive(entity, world, deathmatch)
```

Spawn explosive.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |
| `deathmatch` | `dynamic` | — | deathmatch value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/movers.ml#L1578)

<a id="function-function-miniquake2-game-world-movers-spawnkillbox-function-spawnkillbox-entity-world-src-miniquake2-game-world-movers-ml-1410180930"></a>
### spawnKillBox

```ml
function spawnKillBox(entity, world)
```

Spawn kill box.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/movers.ml#L1618)

<a id="function-function-miniquake2-game-world-movers-spawnplat-function-spawnplat-entity-world-src-miniquake2-game-world-movers-ml-955339042"></a>
### spawnPlat

```ml
function spawnPlat(entity, world)
```

Spawn plat.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/movers.ml#L1128)

<a id="function-function-miniquake2-game-world-movers-spawnplatinsidetrigger-function-spawnplatinsidetrigger-entity-world-src-miniquake2-game-world-movers-ml-489436846"></a>
### spawnPlatInsideTrigger

```ml
function spawnPlatInsideTrigger(entity, world)
```

Report whether spawn plat inside trigger.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/movers.ml#L1084)

<a id="function-function-miniquake2-game-world-movers-spawnrotatingdoor-function-spawnrotatingdoor-entity-world-src-miniquake2-game-world-movers-ml-1496671484"></a>
### spawnRotatingDoor

```ml
function spawnRotatingDoor(entity, world)
```

Spawn rotating door.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/movers.ml#L955)

<a id="function-function-miniquake2-game-world-movers-spawnsecretdoor-function-spawnsecretdoor-entity-world-src-miniquake2-game-world-movers-ml-980995692"></a>
### spawnSecretDoor

```ml
function spawnSecretDoor(entity, world)
```

Spawn secret door.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/movers.ml#L818)

<a id="function-function-miniquake2-game-world-movers-spawntimer-function-spawntimer-entity-world-src-miniquake2-game-world-movers-ml-1266518634"></a>
### spawnTimer

```ml
function spawnTimer(entity, world)
```

Spawn timer.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/movers.ml#L1469)

<a id="function-function-miniquake2-game-world-movers-spawntrain-function-spawntrain-entity-world-src-miniquake2-game-world-movers-ml-329301174"></a>
### spawnTrain

```ml
function spawnTrain(entity, world)
```

Spawn train.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/movers.ml#L1354)

<a id="function-function-miniquake2-game-world-movers-spawnwater-function-spawnwater-entity-world-src-miniquake2-game-world-movers-ml-825085118"></a>
### spawnWater

```ml
function spawnWater(entity, world)
```

func_water reuses door_use only after establishing its distinct defaults: 25-unit speed, zero lip, no blocked callback and a wait=-1 toggle.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/movers.ml#L607)

<a id="function-function-miniquake2-game-world-movers-thinkacceleratedmove-function-thinkacceleratedmove-entity-world-src-miniquake2-game-world-movers-ml-992491038"></a>
### thinkAcceleratedMove

```ml
function thinkAcceleratedMove(entity, world)
```

Run accelerated move.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/movers.ml#L119)

<a id="function-function-miniquake2-game-world-movers-timerthink-function-timerthink-entity-world-src-miniquake2-game-world-movers-ml-1893614010"></a>
### timerThink

```ml
function timerThink(entity, world)
```

func_timer

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/movers.ml#L1439)

<a id="function-function-miniquake2-game-world-movers-timeruse-function-timeruse-entity-other-activator-world-src-miniquake2-game-world-movers-ml-1093779623"></a>
### timerUse

```ml
function timerUse(entity, other, activator, world)
```

Use timer.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `other` | `dynamic` | — | other value consumed by this operation. |
| `activator` | `dynamic` | — | activator value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/movers.ml#L1451)

<a id="function-function-miniquake2-game-world-movers-trainblocked-function-trainblocked-entity-other-world-src-miniquake2-game-world-movers-ml-1558237164"></a>
### trainBlocked

```ml
function trainBlocked(entity, other, world)
```

Report whether train blocked.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `other` | `dynamic` | — | other value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/movers.ml#L1339)

<a id="function-function-miniquake2-game-world-movers-trainfind-function-trainfind-entity-world-src-miniquake2-game-world-movers-ml-861203044"></a>
### trainFind

```ml
function trainFind(entity, world)
```

Find train.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/movers.ml#L1295)

<a id="function-function-miniquake2-game-world-movers-trainnext-function-trainnext-entity-world-src-miniquake2-game-world-movers-ml-523673252"></a>
### trainNext

```ml
function trainNext(entity, world)
```

Return the train next value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/movers.ml#L1239)

<a id="function-function-miniquake2-game-world-movers-trainresume-function-trainresume-entity-world-src-miniquake2-game-world-movers-ml-1973697436"></a>
### trainResume

```ml
function trainResume(entity, world)
```

Resume train.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/movers.ml#L1278)

<a id="function-function-miniquake2-game-world-movers-trainuse-function-trainuse-entity-other-activator-world-src-miniquake2-game-world-movers-ml-640570283"></a>
### trainUse

```ml
function trainUse(entity, other, activator, world)
```

Use train.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `other` | `dynamic` | — | other value consumed by this operation. |
| `activator` | `dynamic` | — | activator value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/movers.ml#L1319)

<a id="function-function-miniquake2-game-world-movers-trainwait-function-trainwait-entity-world-src-miniquake2-game-world-movers-ml-1895438244"></a>
### trainWait

```ml
function trainWait(entity, world)
```

func_train

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/movers.ml#L1210)
