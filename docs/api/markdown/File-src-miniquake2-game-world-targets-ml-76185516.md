# `src/miniquake2/game/world/targets.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 game world targets facilities for this project.

Package: [`miniquake2.game.world.targets`](Package-miniquake2-game-world-targets-63410783.md)

Reachable from entry: **yes**

## Imports

- `miniquake2/game/world/constants.ml` as `gwconstants` → [src/miniquake2/game/world/constants.ml](File-src-miniquake2-game-world-constants-ml-774918061.md)
- `miniquake2/game/world/core.ml` as `gwcore` → [src/miniquake2/game/world/core.ml](File-src-miniquake2-game-world-core-ml-1171136969.md)
- `miniquake2/game/world/vector.ml` as `gwvector` → [src/miniquake2/game/world/vector.ml](File-src-miniquake2-game-world-vector-ml-1561306429.md)
- `miniquake2/qcommon/byteio.ml` as `targetlightrampbyteio` → [src/miniquake2/qcommon/byteio.ml](File-src-miniquake2-qcommon-byteio-ml-159119335.md)
- `miniquake2/qcommon/types.ml` as `targetactorqtypes` → [src/miniquake2/qcommon/types.ml](File-src-miniquake2-qcommon-types-ml-1663266398.md)
- `std/string.ml` as `sstring` → `../MiniLangCompilerML/std/string.ml` — external dependency

## Declarations

<a id="function-function-miniquake2-game-world-targets-crossleveltargetthink-function-crossleveltargetthink-entity-world-src-miniquake2-game-world-targets-ml-1783166012"></a>
### crossLevelTargetThink

```ml
function crossLevelTargetThink(entity, world)
```

Compute level target think.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/targets.ml#L386)

<a id="function-function-miniquake2-game-world-targets-earthquakethink-function-earthquakethink-entity-world-src-miniquake2-game-world-targets-ml-573434936"></a>
### earthquakeThink

```ml
function earthquakeThink(entity, world)
```

Run earthquake.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/targets.ml#L568)

<a id="function-function-miniquake2-game-world-targets-earthquakeuse-function-earthquakeuse-entity-other-activator-world-src-miniquake2-game-world-targets-ml-1615624769"></a>
### earthquakeUse

```ml
function earthquakeUse(entity, other, activator, world)
```

Use earthquake.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `other` | `dynamic` | — | other value consumed by this operation. |
| `activator` | `dynamic` | — | activator value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/targets.ml#L590)

<a id="function-function-miniquake2-game-world-targets-explosionthink-function-explosionthink-entity-world-src-miniquake2-game-world-targets-ml-391583342"></a>
### explosionThink

```ml
function explosionThink(entity, world)
```

Run explosion.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/targets.ml#L222)

<a id="constant-constant-miniquake2-game-world-targets-laser-blue-const-laser-blue-8-src-miniquake2-game-world-targets-ml-691445220"></a>
### LASER_BLUE

```ml
const LASER_BLUE = 8
```

Defines the laser blue constant used by the miniquake2 game world targets module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/targets.ml#L415)

<a id="constant-constant-miniquake2-game-world-targets-laser-direction-changed-const-laser-direction-changed-2147483648-src-miniquake2-game-world-targets-ml-1809542499"></a>
### LASER_DIRECTION_CHANGED

```ml
const LASER_DIRECTION_CHANGED = 2147483648
```

Defines the laser direction changed constant used by the miniquake2 game world targets module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/targets.ml#L423)

<a id="constant-constant-miniquake2-game-world-targets-laser-fat-const-laser-fat-64-src-miniquake2-game-world-targets-ml-1037843818"></a>
### LASER_FAT

```ml
const LASER_FAT = 64
```

Defines the laser fat constant used by the miniquake2 game world targets module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/targets.ml#L421)

<a id="constant-constant-miniquake2-game-world-targets-laser-green-const-laser-green-4-src-miniquake2-game-world-targets-ml-611928926"></a>
### LASER_GREEN

```ml
const LASER_GREEN = 4
```

Defines the laser green constant used by the miniquake2 game world targets module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/targets.ml#L413)

<a id="constant-constant-miniquake2-game-world-targets-laser-orange-const-laser-orange-32-src-miniquake2-game-world-targets-ml-836737041"></a>
### LASER_ORANGE

```ml
const LASER_ORANGE = 32
```

Defines the laser orange constant used by the miniquake2 game world targets module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/targets.ml#L419)

<a id="constant-constant-miniquake2-game-world-targets-laser-red-const-laser-red-2-src-miniquake2-game-world-targets-ml-1722212072"></a>
### LASER_RED

```ml
const LASER_RED = 2
```

Defines the laser red constant used by the miniquake2 game world targets module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/targets.ml#L411)

<a id="constant-constant-miniquake2-game-world-targets-laser-start-on-const-laser-start-on-1-src-miniquake2-game-world-targets-ml-251031605"></a>
### LASER_START_ON

```ml
const LASER_START_ON = 1
```

Defines the laser start on constant used by the miniquake2 game world targets module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/targets.ml#L409)

<a id="constant-constant-miniquake2-game-world-targets-laser-yellow-const-laser-yellow-16-src-miniquake2-game-world-targets-ml-1617643099"></a>
### LASER_YELLOW

```ml
const LASER_YELLOW = 16
```

Defines the laser yellow constant used by the miniquake2 game world targets module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/targets.ml#L417)

<a id="function-function-miniquake2-game-world-targets-laseroff-function-laseroff-entity-world-src-miniquake2-game-world-targets-ml-1765867254"></a>
### laserOff

```ml
function laserOff(entity, world)
```

Report whether laser off.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/targets.ml#L496)

<a id="function-function-miniquake2-game-world-targets-laseron-function-laseron-entity-world-src-miniquake2-game-world-targets-ml-583863598"></a>
### laserOn

```ml
function laserOn(entity, world)
```

Report whether laser on.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/targets.ml#L485)

<a id="function-function-miniquake2-game-world-targets-laserstart-function-laserstart-entity-world-src-miniquake2-game-world-targets-ml-1914515206"></a>
### laserStart

```ml
function laserStart(entity, world)
```

Start laser.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/targets.ml#L520)

<a id="function-function-miniquake2-game-world-targets-laserthink-function-laserthink-entity-world-src-miniquake2-game-world-targets-ml-1918639438"></a>
### laserThink

```ml
function laserThink(entity, world)
```

Run laser.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/targets.ml#L428)

<a id="function-function-miniquake2-game-world-targets-laseruse-function-laseruse-entity-other-activator-world-src-miniquake2-game-world-targets-ml-952545705"></a>
### laserUse

```ml
function laserUse(entity, other, activator, world)
```

Use laser.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `other` | `dynamic` | — | other value consumed by this operation. |
| `activator` | `dynamic` | — | activator value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/targets.ml#L508)

<a id="function-function-miniquake2-game-world-targets-sp-target-actor-function-sp-target-actor-entity-world-src-miniquake2-game-world-targets-ml-761949564"></a>
### SP_target_actor

```ml
function SP_target_actor(entity, world)
```

Spawn target actor.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/targets.ml#L790)

<a id="function-function-miniquake2-game-world-targets-sp-target-blaster-function-sp-target-blaster-entity-world-src-miniquake2-game-world-targets-ml-1011349848"></a>
### SP_target_blaster

```ml
function SP_target_blaster(entity, world)
```

Spawn target blaster.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/targets.ml#L760)

<a id="function-function-miniquake2-game-world-targets-sp-target-changelevel-function-sp-target-changelevel-entity-world-src-miniquake2-game-world-targets-ml-1032499526"></a>
### SP_target_changelevel

```ml
function SP_target_changelevel(entity, world)
```

Spawn target changelevel.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/targets.ml#L742)

<a id="function-function-miniquake2-game-world-targets-sp-target-crosslevel-target-function-sp-target-crosslevel-target-entity-world-src-miniquake2-game-world-targets-ml-1044080342"></a>
### SP_target_crosslevel_target

```ml
function SP_target_crosslevel_target(entity, world)
```

Spawn target crosslevel target.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/targets.ml#L772)

<a id="function-function-miniquake2-game-world-targets-sp-target-crosslevel-trigger-function-sp-target-crosslevel-trigger-entity-world-src-miniquake2-game-world-targets-ml-1598160126"></a>
### SP_target_crosslevel_trigger

```ml
function SP_target_crosslevel_trigger(entity, world)
```

Spawn target crosslevel trigger.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/targets.ml#L766)

<a id="function-function-miniquake2-game-world-targets-sp-target-earthquake-function-sp-target-earthquake-entity-world-src-miniquake2-game-world-targets-ml-1895020054"></a>
### SP_target_earthquake

```ml
function SP_target_earthquake(entity, world)
```

Spawn target earthquake.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/targets.ml#L784)

<a id="function-function-miniquake2-game-world-targets-sp-target-explosion-function-sp-target-explosion-entity-world-src-miniquake2-game-world-targets-ml-495492572"></a>
### SP_target_explosion

```ml
function SP_target_explosion(entity, world)
```

Spawn target explosion.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/targets.ml#L736)

<a id="function-function-miniquake2-game-world-targets-sp-target-goal-function-sp-target-goal-entity-world-src-miniquake2-game-world-targets-ml-1807376870"></a>
### SP_target_goal

```ml
function SP_target_goal(entity, world)
```

Spawn target goal.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/targets.ml#L730)

<a id="function-function-miniquake2-game-world-targets-sp-target-help-function-sp-target-help-entity-world-src-miniquake2-game-world-targets-ml-2025244122"></a>
### SP_target_help

```ml
function SP_target_help(entity, world)
```

Spawn target help.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/targets.ml#L718)

<a id="function-function-miniquake2-game-world-targets-sp-target-laser-function-sp-target-laser-entity-world-src-miniquake2-game-world-targets-ml-522174652"></a>
### SP_target_laser

```ml
function SP_target_laser(entity, world)
```

Spawn target laser.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/targets.ml#L778)

<a id="function-function-miniquake2-game-world-targets-sp-target-lightramp-function-sp-target-lightramp-entity-world-src-miniquake2-game-world-targets-ml-1081797090"></a>
### SP_target_lightramp

```ml
function SP_target_lightramp(entity, world)
```

Spawn target lightramp.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/targets.ml#L796)

<a id="function-function-miniquake2-game-world-targets-sp-target-secret-function-sp-target-secret-entity-world-src-miniquake2-game-world-targets-ml-1831813670"></a>
### SP_target_secret

```ml
function SP_target_secret(entity, world)
```

Spawn target secret.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/targets.ml#L724)

<a id="function-function-miniquake2-game-world-targets-sp-target-spawner-function-sp-target-spawner-entity-world-src-miniquake2-game-world-targets-ml-2003854698"></a>
### SP_target_spawner

```ml
function SP_target_spawner(entity, world)
```

Spawn target spawner.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/targets.ml#L754)

<a id="function-function-miniquake2-game-world-targets-sp-target-speaker-function-sp-target-speaker-entity-world-src-miniquake2-game-world-targets-ml-1286563964"></a>
### SP_target_speaker

```ml
function SP_target_speaker(entity, world)
```

Spawn target speaker.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/targets.ml#L712)

<a id="function-function-miniquake2-game-world-targets-sp-target-splash-function-sp-target-splash-entity-world-src-miniquake2-game-world-targets-ml-1222578698"></a>
### SP_target_splash

```ml
function SP_target_splash(entity, world)
```

Spawn target splash.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/targets.ml#L748)

<a id="function-function-miniquake2-game-world-targets-sp-target-temp-entity-function-sp-target-temp-entity-entity-world-src-miniquake2-game-world-targets-ml-2047278610"></a>
### SP_target_temp_entity

```ml
function SP_target_temp_entity(entity, world)
```

Spawn target temp entity.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/targets.ml#L706)

<a id="function-function-miniquake2-game-world-targets-spawnblaster-function-spawnblaster-entity-world-src-miniquake2-game-world-targets-ml-442132138"></a>
### spawnBlaster

```ml
function spawnBlaster(entity, world)
```

Spawn blaster.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/targets.ml#L353)

<a id="function-function-miniquake2-game-world-targets-spawnchangelevel-function-spawnchangelevel-entity-world-src-miniquake2-game-world-targets-ml-462363654"></a>
### spawnChangeLevel

```ml
function spawnChangeLevel(entity, world)
```

Spawn change level.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/targets.ml#L277)

<a id="function-function-miniquake2-game-world-targets-spawncrossleveltarget-function-spawncrossleveltarget-entity-world-src-miniquake2-game-world-targets-ml-1717633670"></a>
### spawnCrossLevelTarget

```ml
function spawnCrossLevelTarget(entity, world)
```

Spawn cross level target.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/targets.ml#L400)

<a id="function-function-miniquake2-game-world-targets-spawncrossleveltrigger-function-spawncrossleveltrigger-entity-world-src-miniquake2-game-world-targets-ml-1741960094"></a>
### spawnCrossLevelTrigger

```ml
function spawnCrossLevelTrigger(entity, world)
```

Spawn cross level trigger.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/targets.ml#L377)

<a id="function-function-miniquake2-game-world-targets-spawnearthquake-function-spawnearthquake-entity-world-src-miniquake2-game-world-targets-ml-362225602"></a>
### spawnEarthquake

```ml
function spawnEarthquake(entity, world)
```

Spawn earthquake.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/targets.ml#L603)

<a id="function-function-miniquake2-game-world-targets-spawnexplosion-function-spawnexplosion-entity-world-src-miniquake2-game-world-targets-ml-1277430262"></a>
### spawnExplosion

```ml
function spawnExplosion(entity, world)
```

Spawn explosion.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/targets.ml#L250)

<a id="function-function-miniquake2-game-world-targets-spawngoal-function-spawngoal-entity-world-src-miniquake2-game-world-targets-ml-92347950"></a>
### spawnGoal

```ml
function spawnGoal(entity, world)
```

Spawn goal.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/targets.ml#L211)

<a id="function-function-miniquake2-game-world-targets-spawnhelp-function-spawnhelp-entity-world-src-miniquake2-game-world-targets-ml-1827538646"></a>
### spawnHelp

```ml
function spawnHelp(entity, world)
```

Spawn help.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/targets.ml#L160)

<a id="function-function-miniquake2-game-world-targets-spawnlaser-function-spawnlaser-entity-world-src-miniquake2-game-world-targets-ml-2112682886"></a>
### spawnLaser

```ml
function spawnLaser(entity, world)
```

Spawn laser.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/targets.ml#L558)

<a id="function-function-miniquake2-game-world-targets-spawnsecret-function-spawnsecret-entity-world-src-miniquake2-game-world-targets-ml-2077527584"></a>
### spawnSecret

```ml
function spawnSecret(entity, world)
```

Spawn secret.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/targets.ml#L186)

<a id="function-function-miniquake2-game-world-targets-spawnspawner-function-spawnspawner-entity-world-src-miniquake2-game-world-targets-ml-687564418"></a>
### spawnSpawner

```ml
function spawnSpawner(entity, world)
```

Spawn spawner.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/targets.ml#L328)

<a id="function-function-miniquake2-game-world-targets-spawnspeaker-function-spawnspeaker-entity-world-src-miniquake2-game-world-targets-ml-2024271898"></a>
### spawnSpeaker

```ml
function spawnSpeaker(entity, world)
```

Spawn speaker.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/targets.ml#L131)

<a id="function-function-miniquake2-game-world-targets-spawnsplash-function-spawnsplash-entity-world-src-miniquake2-game-world-targets-ml-1061936614"></a>
### spawnSplash

```ml
function spawnSplash(entity, world)
```

Spawn splash.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/targets.ml#L306)

<a id="function-function-miniquake2-game-world-targets-spawntargetactor-function-spawntargetactor-entity-world-src-miniquake2-game-world-targets-ml-1817338382"></a>
### spawnTargetActor

```ml
function spawnTargetActor(entity, world)
```

Spawn target actor.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/targets.ml#L76)

<a id="function-function-miniquake2-game-world-targets-spawntargetlightramp-function-spawntargetlightramp-entity-world-deathmatch-src-miniquake2-game-world-targets-ml-1249778845"></a>
### spawnTargetLightRamp

```ml
function spawnTargetLightRamp(entity, world, deathmatch)
```

Spawn target light ramp.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |
| `deathmatch` | `dynamic` | — | deathmatch value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/targets.ml#L670)

<a id="function-function-miniquake2-game-world-targets-spawntempentity-function-spawntempentity-entity-world-src-miniquake2-game-world-targets-ml-396022822"></a>
### spawnTempEntity

```ml
function spawnTempEntity(entity, world)
```

Spawn temp entity.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/targets.ml#L108)

<a id="function-function-miniquake2-game-world-targets-targetactortouch-function-targetactortouch-entity-other-world-src-miniquake2-game-world-targets-ml-843229520"></a>
### targetActorTouch

```ml
function targetActorTouch(entity, other, world)
```

target_actor from m_actor.c. AI-private state changes are represented by one explicit transition callback; this package still owns target lookup, pathtarget dispatch, jump velocity and deterministic waypoint chaining.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `other` | `dynamic` | — | other value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/targets.ml#L24)

<a id="function-function-miniquake2-game-world-targets-targetlightrampthink-function-targetlightrampthink-entity-world-src-miniquake2-game-world-targets-ml-896960350"></a>
### targetLightRampThink

```ml
function targetLightRampThink(entity, world)
```

target_lightramp from g_target.c. Configstring mutation is an explicit engine callback so this state machine stays deterministic and headless.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/targets.ml#L619)

<a id="function-function-miniquake2-game-world-targets-targetlightrampuse-function-targetlightrampuse-entity-other-activator-world-src-miniquake2-game-world-targets-ml-117546057"></a>
### targetLightRampUse

```ml
function targetLightRampUse(entity, other, activator, world)
```

Use target light ramp.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `other` | `dynamic` | — | other value consumed by this operation. |
| `activator` | `dynamic` | — | activator value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/targets.ml#L643)

<a id="function-function-miniquake2-game-world-targets-useblaster-function-useblaster-entity-other-activator-world-src-miniquake2-game-world-targets-ml-1922596861"></a>
### useBlaster

```ml
function useBlaster(entity, other, activator, world)
```

Use blaster.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `other` | `dynamic` | — | other value consumed by this operation. |
| `activator` | `dynamic` | — | activator value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/targets.ml#L343)

<a id="function-function-miniquake2-game-world-targets-usechangelevel-function-usechangelevel-entity-other-activator-world-src-miniquake2-game-world-targets-ml-712444777"></a>
### useChangeLevel

```ml
function useChangeLevel(entity, other, activator, world)
```

Use change level.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `other` | `dynamic` | — | other value consumed by this operation. |
| `activator` | `dynamic` | — | activator value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/targets.ml#L261)

<a id="function-function-miniquake2-game-world-targets-usecrossleveltrigger-function-usecrossleveltrigger-entity-other-activator-world-src-miniquake2-game-world-targets-ml-1401693361"></a>
### useCrossLevelTrigger

```ml
function useCrossLevelTrigger(entity, other, activator, world)
```

Use cross level trigger.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `other` | `dynamic` | — | other value consumed by this operation. |
| `activator` | `dynamic` | — | activator value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/targets.ml#L368)

<a id="function-function-miniquake2-game-world-targets-useexplosion-function-useexplosion-entity-other-activator-world-src-miniquake2-game-world-targets-ml-117494657"></a>
### useExplosion

```ml
function useExplosion(entity, other, activator, world)
```

Use explosion.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `other` | `dynamic` | — | other value consumed by this operation. |
| `activator` | `dynamic` | — | activator value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/targets.ml#L239)

<a id="function-function-miniquake2-game-world-targets-usegoal-function-usegoal-entity-other-activator-world-src-miniquake2-game-world-targets-ml-1036086641"></a>
### useGoal

```ml
function useGoal(entity, other, activator, world)
```

Use goal.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `other` | `dynamic` | — | other value consumed by this operation. |
| `activator` | `dynamic` | — | activator value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/targets.ml#L199)

<a id="function-function-miniquake2-game-world-targets-usehelp-function-usehelp-entity-other-activator-world-src-miniquake2-game-world-targets-ml-651741265"></a>
### useHelp

```ml
function useHelp(entity, other, activator, world)
```

Use help.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `other` | `dynamic` | — | other value consumed by this operation. |
| `activator` | `dynamic` | — | activator value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/targets.ml#L151)

<a id="function-function-miniquake2-game-world-targets-usesecret-function-usesecret-entity-other-activator-world-src-miniquake2-game-world-targets-ml-364434659"></a>
### useSecret

```ml
function useSecret(entity, other, activator, world)
```

Use secret.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `other` | `dynamic` | — | other value consumed by this operation. |
| `activator` | `dynamic` | — | activator value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/targets.ml#L175)

<a id="function-function-miniquake2-game-world-targets-usespawner-function-usespawner-entity-other-activator-world-src-miniquake2-game-world-targets-ml-127855917"></a>
### useSpawner

```ml
function useSpawner(entity, other, activator, world)
```

Use spawner.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `other` | `dynamic` | — | other value consumed by this operation. |
| `activator` | `dynamic` | — | activator value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/targets.ml#L319)

<a id="function-function-miniquake2-game-world-targets-usespeaker-function-usespeaker-entity-other-activator-world-src-miniquake2-game-world-targets-ml-1318211893"></a>
### useSpeaker

```ml
function useSpeaker(entity, other, activator, world)
```

Use speaker.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `other` | `dynamic` | — | other value consumed by this operation. |
| `activator` | `dynamic` | — | activator value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/targets.ml#L118)

<a id="function-function-miniquake2-game-world-targets-usesplash-function-usesplash-entity-other-activator-world-src-miniquake2-game-world-targets-ml-2009351017"></a>
### useSplash

```ml
function useSplash(entity, other, activator, world)
```

Use splash.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `other` | `dynamic` | — | other value consumed by this operation. |
| `activator` | `dynamic` | — | activator value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/targets.ml#L293)

<a id="function-function-miniquake2-game-world-targets-usetempentity-function-usetempentity-entity-other-activator-world-src-miniquake2-game-world-targets-ml-683402761"></a>
### useTempEntity

```ml
function useTempEntity(entity, other, activator, world)
```

Use temp entity.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `other` | `dynamic` | — | other value consumed by this operation. |
| `activator` | `dynamic` | — | activator value consumed by this operation. |
| `world` | `dynamic` | — | world value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/world/targets.ml#L99)
