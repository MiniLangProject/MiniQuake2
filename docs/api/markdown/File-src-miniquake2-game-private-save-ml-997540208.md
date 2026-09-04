# `src/miniquake2/game/private_save.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 game private save facilities for this project.

Package: [`miniquake2.game.private_save`](Package-miniquake2-game-private-save-1021462080.md)

Reachable from entry: **yes**

## Imports

- `miniquake2/game/ai/actor.ml` as `privatesaveactor` → [src/miniquake2/game/ai/actor.ml](File-src-miniquake2-game-ai-actor-ml-1670505135.md)
- `miniquake2/game/ai/archetypes.ml` as `privatesaveaiarchetypes` → [src/miniquake2/game/ai/archetypes.ml](File-src-miniquake2-game-ai-archetypes-ml-722294566.md)
- `miniquake2/game/ai/insane.ml` as `privatesaveinsane` → [src/miniquake2/game/ai/insane.ml](File-src-miniquake2-game-ai-insane-ml-754528084.md)
- `miniquake2/game/ai/props.ml` as `privatesaveaiprops` → [src/miniquake2/game/ai/props.ml](File-src-miniquake2-game-ai-props-ml-91813726.md)
- `miniquake2/game/ai/types.ml` as `privatesaveaitypes` → [src/miniquake2/game/ai/types.ml](File-src-miniquake2-game-ai-types-ml-2113011711.md)
- `miniquake2/game/base/spawn.ml` as `privatespawn` → [src/miniquake2/game/base/spawn.ml](File-src-miniquake2-game-base-spawn-ml-685876900.md)
- `miniquake2/game/gameplay/types.ml` as `privategameplaytypes` → [src/miniquake2/game/gameplay/types.ml](File-src-miniquake2-game-gameplay-types-ml-2088064005.md)
- `miniquake2/game/integration/baseq2.ml` as `privateintegration` → [src/miniquake2/game/integration/baseq2.ml](File-src-miniquake2-game-integration-baseq2-ml-2026578472.md)
- `miniquake2/game/player/constants.ml` as `privateplayerconstants` → [src/miniquake2/game/player/constants.ml](File-src-miniquake2-game-player-constants-ml-946982646.md)
- `miniquake2/game/player/types.ml` as `privateplayers` → [src/miniquake2/game/player/types.ml](File-src-miniquake2-game-player-types-ml-1013655302.md)
- `miniquake2/game/types.ml` as `privatesavegametypes` → [src/miniquake2/game/types.ml](File-src-miniquake2-game-types-ml-1384205920.md)
- `miniquake2/game/weapons/core.ml` as `privatesaveweaponcore` → [src/miniquake2/game/weapons/core.ml](File-src-miniquake2-game-weapons-core-ml-1168965024.md)
- `miniquake2/game/weapons/projectiles.ml` as `privatesaveprojectiles` → [src/miniquake2/game/weapons/projectiles.ml](File-src-miniquake2-game-weapons-projectiles-ml-2146249801.md)
- `miniquake2/game/weapons/types.ml` as `privatesaveweapontypes` → [src/miniquake2/game/weapons/types.ml](File-src-miniquake2-game-weapons-types-ml-582527054.md)
- `miniquake2/game/world/core.ml` as `privateworldcore` → [src/miniquake2/game/world/core.ml](File-src-miniquake2-game-world-core-ml-1171136969.md)
- `miniquake2/game/world/misc.ml` as `privateworldmisc` → [src/miniquake2/game/world/misc.ml](File-src-miniquake2-game-world-misc-ml-358660036.md)
- `miniquake2/game/world/movers.ml` as `privatemovers` → [src/miniquake2/game/world/movers.ml](File-src-miniquake2-game-world-movers-ml-1599163262.md)
- `miniquake2/game/world/turret.ml` as `privateturret` → [src/miniquake2/game/world/turret.ml](File-src-miniquake2-game-world-turret-ml-1229260754.md)
- `miniquake2/game/world/types.ml` as `privateworldtypes` → [src/miniquake2/game/world/types.ml](File-src-miniquake2-game-world-types-ml-1207695045.md)
- `miniquake2/protocol/checked.ml` as `privatechecked` → [src/miniquake2/protocol/checked.ml](File-src-miniquake2-protocol-checked-ml-1828862158.md)
- `miniquake2/qcommon/message.ml` as `privatemessage` → [src/miniquake2/qcommon/message.ml](File-src-miniquake2-qcommon-message-ml-1426179364.md)
- `miniquake2/qcommon/sizebuf.ml` as `privatesizebuf` → [src/miniquake2/qcommon/sizebuf.ml](File-src-miniquake2-qcommon-sizebuf-ml-1769950759.md)

## Declarations

<a id="function-function-miniquake2-game-private-save-encode-function-encode-runtime-playercontext-entitystring-spawnpoint-src-miniquake2-game-private-save-ml-1480020113"></a>
### encode

```ml
function encode(runtime, playerContext, entityString, spawnPoint)
```

Encode the pointer-free private payload in one fixed field order. New fields are append-only within their versioned record so older readers stay explicit.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |
| `playerContext` | `dynamic` | — | playerContext value consumed by this operation. |
| `entityString` | `dynamic` | — | entityString value consumed by this operation. |
| `spawnPoint` | `dynamic` | — | spawnPoint value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/private_save.ml#L269)

<a id="function-function-miniquake2-game-private-save-findmonster-function-findmonster-runtime-number-src-miniquake2-game-private-save-ml-2145886343"></a>
### findMonster

```ml
function findMonster(runtime, number)
```

Find monster.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |
| `number` | `dynamic` | — | number value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/private_save.ml#L596)

<a id="function-function-miniquake2-game-private-save-itembyindex-function-itembyindex-registry-index-src-miniquake2-game-private-save-ml-528418765"></a>
### itemByIndex

```ml
function itemByIndex(registry, index)
```

Return the item by index.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `registry` | `dynamic` | — | registry value consumed by this operation. |
| `index` | `dynamic` | — | Zero-based index of the affected item. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/private_save.ml#L196)

<a id="function-function-miniquake2-game-private-save-itemindex-function-itemindex-item-src-miniquake2-game-private-save-ml-856669453"></a>
### itemIndex

```ml
function itemIndex(item)
```

Return the item index.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `item` | `dynamic` | — | item value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/private_save.ml#L188)

<a id="constant-constant-miniquake2-game-private-save-private-magic-const-private-magic-mq2baseq2-src-miniquake2-game-private-save-ml-79383435"></a>
### PRIVATE_MAGIC

```ml
const PRIVATE_MAGIC = "MQ2BASEQ2"
```

Defines the private magic constant used by the miniquake2 game private save module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/private_save.ml#L34)

<a id="constant-constant-miniquake2-game-private-save-private-version-const-private-version-21-src-miniquake2-game-private-save-ml-658923988"></a>
### PRIVATE_VERSION

```ml
const PRIVATE_VERSION = 21
```

Defines the private version constant used by the miniquake2 game private save module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/private_save.ml#L36)

<a id="function-function-miniquake2-game-private-save-privatefindworld-function-privatefindworld-runtime-number-classname-src-miniquake2-game-private-save-ml-1796470638"></a>
### privateFindWorld

```ml
function privateFindWorld(runtime, number, className)
```

Find private world.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |
| `number` | `dynamic` | — | number value consumed by this operation. |
| `className` | `dynamic` | — | className value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/private_save.ml#L607)

- [miniquake2.game.private_save.PrivateMonsterReference](Type-miniquake2-game-private-save-privatemonsterreference-1527473914.md) — struct
- [miniquake2.game.private_save.PrivateNoiseReference](Type-miniquake2-game-private-save-privatenoisereference-1727084362.md) — struct
- [miniquake2.game.private_save.PrivateProjectileReference](Type-miniquake2-game-private-save-privateprojectilereference-626238931.md) — struct
<a id="function-function-miniquake2-game-private-save-privateprojectilethinkkind-function-privateprojectilethinkkind-projectile-src-miniquake2-game-private-save-ml-1276404947"></a>
### privateProjectileThinkKind

```ml
function privateProjectileThinkKind(projectile)
```

Return the reconstructible projectile think callback identity.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `projectile` | `dynamic` | — | projectile value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/private_save.ml#L252)

<a id="function-function-miniquake2-game-private-save-privateprojectiletouchkind-function-privateprojectiletouchkind-projectile-src-miniquake2-game-private-save-ml-226658515"></a>
### privateProjectileTouchKind

```ml
function privateProjectileTouchKind(projectile)
```

Return the reconstructible projectile touch callback identity.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `projectile` | `dynamic` | — | projectile value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/private_save.ml#L241)

<a id="function-function-miniquake2-game-private-save-privatereadbool-function-privatereadbool-buffer-label-src-miniquake2-game-private-save-ml-726398556"></a>
### privateReadBool

```ml
function privateReadBool(buffer, label)
```

Read private bool.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buffer` | `dynamic` | — | Buffer that receives or supplies the operation data. |
| `label` | `dynamic` | — | label value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/private_save.ml#L180)

<a id="function-function-miniquake2-game-private-save-privatereadfloat-function-privatereadfloat-buffer-label-src-miniquake2-game-private-save-ml-1865416786"></a>
### privateReadFloat

```ml
function privateReadFloat(buffer, label)
```

Read private float.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buffer` | `dynamic` | — | Buffer that receives or supplies the operation data. |
| `label` | `dynamic` | — | label value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/private_save.ml#L156)

<a id="function-function-miniquake2-game-private-save-privatereadpmove-function-privatereadpmove-buffer-label-src-miniquake2-game-private-save-ml-2040437310"></a>
### privateReadPmove

```ml
function privateReadPmove(buffer, label)
```

Read a complete pmove state.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buffer` | `dynamic` | — | Buffer that receives or supplies the operation data. |
| `label` | `dynamic` | — | label value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/private_save.ml#L223)

<a id="function-function-miniquake2-game-private-save-privatereadvec-function-privatereadvec-buffer-label-src-miniquake2-game-private-save-ml-362863418"></a>
### privateReadVec

```ml
function privateReadVec(buffer, label)
```

Read private vec.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buffer` | `dynamic` | — | Buffer that receives or supplies the operation data. |
| `label` | `dynamic` | — | label value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/private_save.ml#L164)

<a id="function-function-miniquake2-game-private-save-privatereferencenumber-function-privatereferencenumber-value-src-miniquake2-game-private-save-ml-1631795185"></a>
### privateReferenceNumber

```ml
function privateReferenceNumber(value)
```

Return the private reference number.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/private_save.ml#L134)

<a id="function-function-miniquake2-game-private-save-privateresolveworldreference-function-privateresolveworldreference-runtime-playercontext-number-label-src-miniquake2-game-private-save-ml-1789039189"></a>
### privateResolveWorldReference

```ml
function privateResolveWorldReference(runtime, playerContext, number, label)
```

Resolve private world reference.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |
| `playerContext` | `dynamic` | — | playerContext value consumed by this operation. |
| `number` | `dynamic` | — | number value consumed by this operation. |
| `label` | `dynamic` | — | label value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/private_save.ml#L623)

- [miniquake2.game.private_save.PrivateRestore](Type-miniquake2-game-private-save-privaterestore-2030249437.md) — struct
<a id="function-function-miniquake2-game-private-save-privaterestoreaireference-function-privaterestoreaireference-runtime-number-maxclients-exporttable-src-miniquake2-game-private-save-ml-627248755"></a>
### privateRestoreAIReference

```ml
function privateRestoreAIReference(runtime, number, maxClients, exportTable)
```

Restore private ai reference.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |
| `number` | `dynamic` | — | number value consumed by this operation. |
| `maxClients` | `dynamic` | — | maxClients value consumed by this operation. |
| `exportTable` | `dynamic` | — | exportTable value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/private_save.ml#L691)

<a id="function-function-miniquake2-game-private-save-privaterestoreenemy-function-privaterestoreenemy-runtime-number-maxclients-exporttable-src-miniquake2-game-private-save-ml-1240116669"></a>
### privateRestoreEnemy

```ml
function privateRestoreEnemy(runtime, number, maxClients, exportTable)
```

Restore private enemy.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |
| `number` | `dynamic` | — | number value consumed by this operation. |
| `maxClients` | `dynamic` | — | maxClients value consumed by this operation. |
| `exportTable` | `dynamic` | — | exportTable value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/private_save.ml#L673)

<a id="function-function-miniquake2-game-private-save-privaterestorelevelaireference-function-privaterestorelevelaireference-runtime-number-maxclients-exporttable-src-miniquake2-game-private-save-ml-317407859"></a>
### privateRestoreLevelAIReference

```ml
function privateRestoreLevelAIReference(runtime, number, maxClients, exportTable)
```

Resolve an AI level-global reference, including synthetic player-noise slots.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |
| `number` | `dynamic` | — | number value consumed by this operation. |
| `maxClients` | `dynamic` | — | maxClients value consumed by this operation. |
| `exportTable` | `dynamic` | — | exportTable value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/private_save.ml#L719)

- [miniquake2.game.private_save.PrivateWorldReference](Type-miniquake2-game-private-save-privateworldreference-2061766268.md) — struct
<a id="function-function-miniquake2-game-private-save-privatewritebool-function-privatewritebool-buffer-value-src-miniquake2-game-private-save-ml-1040595347"></a>
### privateWriteBool

```ml
function privateWriteBool(buffer, value)
```

Write private bool.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buffer` | `dynamic` | — | Buffer that receives or supplies the operation data. |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/private_save.ml#L171)

<a id="function-function-miniquake2-game-private-save-privatewritepmove-function-privatewritepmove-buffer-state-src-miniquake2-game-private-save-ml-1898438793"></a>
### privateWritePmove

```ml
function privateWritePmove(buffer, state)
```

Write a complete pmove state without relying on the engine save envelope.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buffer` | `dynamic` | — | Buffer that receives or supplies the operation data. |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/private_save.ml#L207)

<a id="function-function-miniquake2-game-private-save-privatewritevec-function-privatewritevec-buffer-value-src-miniquake2-game-private-save-ml-1163566811"></a>
### privateWriteVec

```ml
function privateWriteVec(buffer, value)
```

Write private vec.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buffer` | `dynamic` | — | Buffer that receives or supplies the operation data. |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/private_save.ml#L148)

<a id="function-function-miniquake2-game-private-save-restore-function-restore-data-mapname-maxclients-exporttable-playercontext-src-miniquake2-game-private-save-ml-2101540009"></a>
### restore

```ml
function restore(data, mapName, maxClients, exportTable, playerContext)
```

Restore the versioned, pointer-free MiniQuake2 payload in two phases: first allocate stable entity/AI slots, then resolve saved numeric relationships. This prevents partially decoded references from escaping on malformed input.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `data` | `dynamic` | — | Input data consumed by the operation. |
| `mapName` | `dynamic` | — | mapName value consumed by this operation. |
| `maxClients` | `dynamic` | — | maxClients value consumed by this operation. |
| `exportTable` | `dynamic` | — | exportTable value consumed by this operation. |
| `playerContext` | `dynamic` | — | playerContext value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/game/private_save.ml#L745)
