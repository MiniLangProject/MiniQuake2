# `src/miniquake2/game/base/spawn.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 game base spawn facilities for this project.

Package: [`miniquake2.game.base.spawn`](Package-miniquake2-game-base-spawn-314590413.md)

Reachable from entry: **yes**

## Imports

- `miniquake2/game/base/entity_parser.ml` as `bparser` → [src/miniquake2/game/base/entity_parser.ml](File-src-miniquake2-game-base-entity-parser-ml-1253234792.md)
- `miniquake2/game/base/spawn_registry.ml` as `bregistry` → [src/miniquake2/game/base/spawn_registry.ml](File-src-miniquake2-game-base-spawn-registry-ml-1829836596.md)
- `miniquake2/game/base/types.ml` as `btypes` → [src/miniquake2/game/base/types.ml](File-src-miniquake2-game-base-types-ml-1537748126.md)
- `std/string.ml` as `bspawntext` → `../MiniLangCompilerML/std/string.ml` — external dependency

## Declarations

<a id="function-function-miniquake2-game-base-spawn-appenddiagnostic-function-appenddiagnostic-diagnostics-message-src-miniquake2-game-base-spawn-ml-1213592304"></a>
### appendDiagnostic

```ml
function appendDiagnostic(diagnostics, message)
```

Append diagnostic.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `diagnostics` | `dynamic` | — | diagnostics value consumed by this operation. |
| `message` | `dynamic` | — | Human-readable message associated with the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/base/spawn.ml#L34)

<a id="function-function-miniquake2-game-base-spawn-incrementskipped-function-incrementskipped-skippedclasses-classname-src-miniquake2-game-base-spawn-ml-1603414462"></a>
### incrementSkipped

```ml
function incrementSkipped(skippedClasses, className)
```

Return the increment skipped value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `skippedClasses` | `dynamic` | — | skippedClasses value consumed by this operation. |
| `className` | `dynamic` | — | className value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/base/spawn.ml#L41)

<a id="function-function-miniquake2-game-base-spawn-shouldinhibit-function-shouldinhibit-component-mapname-skill-deathmatch-src-miniquake2-game-base-spawn-ml-1924858213"></a>
### shouldInhibit

```ml
function shouldInhibit(component, mapName, skill, deathmatch)
```

g_spawn.c ED_LoadFromFile applies this after parsing and before ED_CallSpawn. The command/*27 correction is an original retail-map compatibility hack.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `component` | `dynamic` | — | component value consumed by this operation. |
| `mapName` | `dynamic` | — | mapName value consumed by this operation. |
| `skill` | `dynamic` | — | skill value consumed by this operation. |
| `deathmatch` | `dynamic` | — | deathmatch value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/base/spawn.ml#L57)

<a id="function-function-miniquake2-game-base-spawn-spawnentities-function-spawnentities-mapname-entitystring-spawnpoint-src-miniquake2-game-base-spawn-ml-386805987"></a>
### SpawnEntities

```ml
function SpawnEntities(mapName, entityString, spawnPoint)
```

Spawn entities.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `mapName` | `dynamic` | — | mapName value consumed by this operation. |
| `entityString` | `dynamic` | — | entityString value consumed by this operation. |
| `spawnPoint` | `dynamic` | — | spawnPoint value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/base/spawn.ml#L166)

<a id="function-function-miniquake2-game-base-spawn-spawnentitiesformode-function-spawnentitiesformode-mapname-entitystring-spawnpoint-skill-deathmatch-src-miniquake2-game-base-spawn-ml-1177024187"></a>
### SpawnEntitiesForMode

```ml
function SpawnEntitiesForMode(mapName, entityString, spawnPoint, skill, deathmatch)
```

Spawn entities for mode.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `mapName` | `dynamic` | — | mapName value consumed by this operation. |
| `entityString` | `dynamic` | — | entityString value consumed by this operation. |
| `spawnPoint` | `dynamic` | — | spawnPoint value consumed by this operation. |
| `skill` | `dynamic` | — | skill value consumed by this operation. |
| `deathmatch` | `dynamic` | — | deathmatch value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/base/spawn.ml#L176)

<a id="function-function-miniquake2-game-base-spawn-spawnentitieslogged-function-spawnentitieslogged-mapname-entitystring-spawnpoint-logger-src-miniquake2-game-base-spawn-ml-73568263"></a>
### spawnEntitiesLogged

```ml
function spawnEntitiesLogged(mapName, entityString, spawnPoint, logger)
```

Spawn entities logged.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `mapName` | `dynamic` | — | mapName value consumed by this operation. |
| `entityString` | `dynamic` | — | entityString value consumed by this operation. |
| `spawnPoint` | `dynamic` | — | spawnPoint value consumed by this operation. |
| `logger` | `dynamic` | — | logger value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/base/spawn.ml#L186)

<a id="function-function-miniquake2-game-base-spawn-spawnentitieswithregistry-function-spawnentitieswithregistry-mapname-entitystring-spawnpoint-registry-src-miniquake2-game-base-spawn-ml-1863273468"></a>
### SpawnEntitiesWithRegistry

```ml
function SpawnEntitiesWithRegistry(mapName, entityString, spawnPoint, registry)
```

Spawn entities with registry.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `mapName` | `dynamic` | — | mapName value consumed by this operation. |
| `entityString` | `dynamic` | — | entityString value consumed by this operation. |
| `spawnPoint` | `dynamic` | — | spawnPoint value consumed by this operation. |
| `registry` | `dynamic` | — | registry value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/base/spawn.ml#L157)

<a id="function-function-miniquake2-game-base-spawn-spawnentitieswithregistrymode-function-spawnentitieswithregistrymode-mapname-entitystring-spawnpoint-registry-skill-deathmatch-applymodefilter-src-miniquake2-game-base-spawn-ml-992196075"></a>
### SpawnEntitiesWithRegistryMode

```ml
function SpawnEntitiesWithRegistryMode(mapName, entityString, spawnPoint, registry, skill, deathmatch, applyModeFilter)
```

Spawn entities with registry mode.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `mapName` | `dynamic` | — | mapName value consumed by this operation. |
| `entityString` | `dynamic` | — | entityString value consumed by this operation. |
| `spawnPoint` | `dynamic` | — | spawnPoint value consumed by this operation. |
| `registry` | `dynamic` | — | registry value consumed by this operation. |
| `skill` | `dynamic` | — | skill value consumed by this operation. |
| `deathmatch` | `dynamic` | — | deathmatch value consumed by this operation. |
| `applyModeFilter` | `dynamic` | — | applyModeFilter value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/base/spawn.ml#L81)

<a id="constant-constant-miniquake2-game-base-spawn-spawnflag-mode-mask-const-spawnflag-mode-mask-7936-src-miniquake2-game-base-spawn-ml-1177670583"></a>
### SPAWNFLAG_MODE_MASK

```ml
const SPAWNFLAG_MODE_MASK = 7936
```

Defines the spawnflag mode mask constant used by the miniquake2 game base spawn module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/base/spawn.ml#L29)

<a id="constant-constant-miniquake2-game-base-spawn-spawnflag-not-coop-const-spawnflag-not-coop-4096-src-miniquake2-game-base-spawn-ml-1401020317"></a>
### SPAWNFLAG_NOT_COOP

```ml
const SPAWNFLAG_NOT_COOP = 4096
```

Defines the spawnflag not coop constant used by the miniquake2 game base spawn module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/base/spawn.ml#L27)

<a id="constant-constant-miniquake2-game-base-spawn-spawnflag-not-deathmatch-const-spawnflag-not-deathmatch-2048-src-miniquake2-game-base-spawn-ml-523099028"></a>
### SPAWNFLAG_NOT_DEATHMATCH

```ml
const SPAWNFLAG_NOT_DEATHMATCH = 2048
```

Defines the spawnflag not deathmatch constant used by the miniquake2 game base spawn module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/base/spawn.ml#L25)

<a id="constant-constant-miniquake2-game-base-spawn-spawnflag-not-easy-const-spawnflag-not-easy-256-src-miniquake2-game-base-spawn-ml-1733364347"></a>
### SPAWNFLAG_NOT_EASY

```ml
const SPAWNFLAG_NOT_EASY = 256
```

Defines the spawnflag not easy constant used by the miniquake2 game base spawn module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/base/spawn.ml#L19)

<a id="constant-constant-miniquake2-game-base-spawn-spawnflag-not-hard-const-spawnflag-not-hard-1024-src-miniquake2-game-base-spawn-ml-1868639253"></a>
### SPAWNFLAG_NOT_HARD

```ml
const SPAWNFLAG_NOT_HARD = 1024
```

Defines the spawnflag not hard constant used by the miniquake2 game base spawn module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/base/spawn.ml#L23)

<a id="constant-constant-miniquake2-game-base-spawn-spawnflag-not-medium-const-spawnflag-not-medium-512-src-miniquake2-game-base-spawn-ml-1950019536"></a>
### SPAWNFLAG_NOT_MEDIUM

```ml
const SPAWNFLAG_NOT_MEDIUM = 512
```

Defines the spawnflag not medium constant used by the miniquake2 game base spawn module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/base/spawn.ml#L21)
