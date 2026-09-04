# `miniquake2.game.base.types.BaseEntity`

[Home](README.md) · [Source file](File-src-miniquake2-game-base-types-ml-1537748126.md)

<a id="struct-struct-miniquake2-game-base-types-baseentity-struct-baseentity-src-miniquake2-game-base-types-ml-735857536"></a>
## BaseEntity

```ml
struct BaseEntity
```

First baseq2-private component.  It covers the common target, trigger and mover fields from the original field_t table.  Later gameplay milestones may append combat/AI state without changing the shared engine Edict prefix.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/base/types.ml#L88)

## Members

<a id="field-field-miniquake2-game-base-types-baseentity-accel-accel-src-miniquake2-game-base-types-ml-2065855368"></a>
### accel

```ml
accel
```

Stores the accel value associated with base entity.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/base/types.ml#L120)

<a id="field-field-miniquake2-game-base-types-baseentity-angles-angles-src-miniquake2-game-base-types-ml-971789456"></a>
### angles

```ml
angles
```

Stores the angles value associated with base entity.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/base/types.ml#L98)

<a id="field-field-miniquake2-game-base-types-baseentity-attenuation-attenuation-src-miniquake2-game-base-types-ml-1241996132"></a>
### attenuation

```ml
attenuation
```

Stores the attenuation value associated with base entity.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/base/types.ml#L144)

<a id="field-field-miniquake2-game-base-types-baseentity-classname-classname-src-miniquake2-game-base-types-ml-448085348"></a>
### className

```ml
className
```

Stores the class name value associated with base entity.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/base/types.ml#L90)

<a id="field-field-miniquake2-game-base-types-baseentity-combattarget-combattarget-src-miniquake2-game-base-types-ml-680635098"></a>
### combatTarget

```ml
combatTarget
```

Stores the combat target value associated with base entity.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/base/types.ml#L112)

<a id="field-field-miniquake2-game-base-types-baseentity-count-count-src-miniquake2-game-base-types-ml-1506233172"></a>
### count

```ml
count
```

Stores the count value associated with base entity.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/base/types.ml#L132)

<a id="field-field-miniquake2-game-base-types-baseentity-damage-damage-src-miniquake2-game-base-types-ml-65456806"></a>
### damage

```ml
damage
```

Stores the damage value associated with base entity.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/base/types.ml#L138)

<a id="field-field-miniquake2-game-base-types-baseentity-deathtarget-deathtarget-src-miniquake2-game-base-types-ml-164650568"></a>
### deathTarget

```ml
deathTarget
```

Stores the death target value associated with base entity.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/base/types.ml#L110)

<a id="field-field-miniquake2-game-base-types-baseentity-decel-decel-src-miniquake2-game-base-types-ml-119550676"></a>
### decel

```ml
decel
```

Stores the decel value associated with base entity.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/base/types.ml#L122)

<a id="field-field-miniquake2-game-base-types-baseentity-delay-delay-src-miniquake2-game-base-types-ml-1308963156"></a>
### delay

```ml
delay
```

Stores the delay value associated with base entity.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/base/types.ml#L126)

<a id="field-field-miniquake2-game-base-types-baseentity-health-health-src-miniquake2-game-base-types-ml-1669292964"></a>
### health

```ml
health
```

Stores the health value associated with base entity.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/base/types.ml#L134)

<a id="field-field-miniquake2-game-base-types-baseentity-killtarget-killtarget-src-miniquake2-game-base-types-ml-754693026"></a>
### killTarget

```ml
killTarget
```

Stores the kill target value associated with base entity.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/base/types.ml#L104)

<a id="field-field-miniquake2-game-base-types-baseentity-map-map-src-miniquake2-game-base-types-ml-1872024336"></a>
### map

```ml
map
```

Stores the map value associated with base entity.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/base/types.ml#L116)

<a id="field-field-miniquake2-game-base-types-baseentity-mass-mass-src-miniquake2-game-base-types-ml-1934298664"></a>
### mass

```ml
mass
```

Stores the mass value associated with base entity.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/base/types.ml#L140)

<a id="field-field-miniquake2-game-base-types-baseentity-message-message-src-miniquake2-game-base-types-ml-674248596"></a>
### message

```ml
message
```

Stores the message value associated with base entity.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/base/types.ml#L114)

<a id="field-field-miniquake2-game-base-types-baseentity-model-model-src-miniquake2-game-base-types-ml-229640320"></a>
### model

```ml
model
```

Stores the model value associated with base entity.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/base/types.ml#L92)

<a id="field-field-miniquake2-game-base-types-baseentity-moveangles-moveangles-src-miniquake2-game-base-types-ml-713037354"></a>
### moveAngles

```ml
moveAngles
```

Stores the move angles value associated with base entity.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/base/types.ml#L148)

<a id="field-field-miniquake2-game-base-types-baseentity-moveorigin-moveorigin-src-miniquake2-game-base-types-ml-29246494"></a>
### moveOrigin

```ml
moveOrigin
```

Stores the move origin value associated with base entity.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/base/types.ml#L146)

<a id="field-field-miniquake2-game-base-types-baseentity-movetype-movetype-src-miniquake2-game-base-types-ml-434555866"></a>
### moveType

```ml
moveType
```

Stores the move type value associated with base entity.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/base/types.ml#L154)

<a id="field-field-miniquake2-game-base-types-baseentity-origin-origin-src-miniquake2-game-base-types-ml-551298844"></a>
### origin

```ml
origin
```

Stores the origin value associated with base entity.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/base/types.ml#L96)

<a id="field-field-miniquake2-game-base-types-baseentity-pathtarget-pathtarget-src-miniquake2-game-base-types-ml-1448183140"></a>
### pathTarget

```ml
pathTarget
```

Stores the path target value associated with base entity.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/base/types.ml#L108)

<a id="field-field-miniquake2-game-base-types-baseentity-random-random-src-miniquake2-game-base-types-ml-1417628794"></a>
### random

```ml
random
```

Stores the random value associated with base entity.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/base/types.ml#L128)

<a id="field-field-miniquake2-game-base-types-baseentity-solid-solid-src-miniquake2-game-base-types-ml-1262488808"></a>
### solid

```ml
solid
```

Stores the solid value associated with base entity.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/base/types.ml#L156)

<a id="field-field-miniquake2-game-base-types-baseentity-sounds-sounds-src-miniquake2-game-base-types-ml-1141328144"></a>
### sounds

```ml
sounds
```

Stores the sounds value associated with base entity.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/base/types.ml#L136)

<a id="field-field-miniquake2-game-base-types-baseentity-spawnflags-spawnflags-src-miniquake2-game-base-types-ml-966586332"></a>
### spawnFlags

```ml
spawnFlags
```

Stores the spawn flags value associated with base entity.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/base/types.ml#L94)

<a id="field-field-miniquake2-game-base-types-baseentity-spawnkind-spawnkind-src-miniquake2-game-base-types-ml-612992264"></a>
### spawnKind

```ml
spawnKind
```

Stores the spawn kind value associated with base entity.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/base/types.ml#L152)

<a id="field-field-miniquake2-game-base-types-baseentity-spawntemp-spawntemp-src-miniquake2-game-base-types-ml-86412112"></a>
### spawnTemp

```ml
spawnTemp
```

Stores the spawn temp value associated with base entity.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/base/types.ml#L150)

<a id="field-field-miniquake2-game-base-types-baseentity-speed-speed-src-miniquake2-game-base-types-ml-1496883508"></a>
### speed

```ml
speed
```

Stores the speed value associated with base entity.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/base/types.ml#L118)

<a id="field-field-miniquake2-game-base-types-baseentity-style-style-src-miniquake2-game-base-types-ml-1173049020"></a>
### style

```ml
style
```

Stores the style value associated with base entity.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/base/types.ml#L130)

<a id="field-field-miniquake2-game-base-types-baseentity-target-target-src-miniquake2-game-base-types-ml-380350226"></a>
### target

```ml
target
```

Stores the target value associated with base entity.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/base/types.ml#L100)

<a id="field-field-miniquake2-game-base-types-baseentity-targetname-targetname-src-miniquake2-game-base-types-ml-38575064"></a>
### targetName

```ml
targetName
```

Stores the target name value associated with base entity.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/base/types.ml#L102)

<a id="field-field-miniquake2-game-base-types-baseentity-team-team-src-miniquake2-game-base-types-ml-2094199270"></a>
### team

```ml
team
```

Stores the team value associated with base entity.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/base/types.ml#L106)

<a id="field-field-miniquake2-game-base-types-baseentity-unknownfields-unknownfields-src-miniquake2-game-base-types-ml-420988596"></a>
### unknownFields

```ml
unknownFields
```

Stores the unknown fields value associated with base entity.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/base/types.ml#L158)

<a id="field-field-miniquake2-game-base-types-baseentity-volume-volume-src-miniquake2-game-base-types-ml-322292492"></a>
### volume

```ml
volume
```

Stores the volume value associated with base entity.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/base/types.ml#L142)

<a id="field-field-miniquake2-game-base-types-baseentity-wait-wait-src-miniquake2-game-base-types-ml-1606304734"></a>
### wait

```ml
wait
```

Stores the wait value associated with base entity.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/base/types.ml#L124)
