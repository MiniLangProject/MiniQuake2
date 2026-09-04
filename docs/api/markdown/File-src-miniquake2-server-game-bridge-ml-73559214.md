# `src/miniquake2/server/game_bridge.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 server game bridge facilities for this project.

Package: [`miniquake2.server.game_bridge`](Package-miniquake2-server-game-bridge-516898348.md)

Reachable from entry: **yes**

## Imports

- `miniquake2/collision/model.ml` as `collision` → [src/miniquake2/collision/model.ml](File-src-miniquake2-collision-model-ml-265039588.md)
- `miniquake2/format/binary.ml` as `sgbformatbinary` → [src/miniquake2/format/binary.ml](File-src-miniquake2-format-binary-ml-1080216281.md)
- `miniquake2/format/constants.ml` as `sgbformatconstants` → [src/miniquake2/format/constants.ml](File-src-miniquake2-format-constants-ml-1556940367.md)
- `miniquake2/game/constants.ml` as `gc` → [src/miniquake2/game/constants.ml](File-src-miniquake2-game-constants-ml-1723282332.md)
- `miniquake2/game/types.ml` as `gt` → [src/miniquake2/game/types.ml](File-src-miniquake2-game-types-ml-1384205920.md)
- `miniquake2/physics/pmove.ml` as `phmove` → [src/miniquake2/physics/pmove.ml](File-src-miniquake2-physics-pmove-ml-117812115.md)
- `miniquake2/physics/vector.ml` as `sgbvector` → [src/miniquake2/physics/vector.ml](File-src-miniquake2-physics-vector-ml-1287862571.md)
- `miniquake2/qcommon/byteio.ml` as `sgbbyteio` → [src/miniquake2/qcommon/byteio.ml](File-src-miniquake2-qcommon-byteio-ml-159119335.md)
- `miniquake2/qcommon/cmd.ml` as `commands` → [src/miniquake2/qcommon/cmd.ml](File-src-miniquake2-qcommon-cmd-ml-1514462021.md)
- `miniquake2/qcommon/constants.ml` as `qc` → [src/miniquake2/qcommon/constants.ml](File-src-miniquake2-qcommon-constants-ml-1976195726.md)
- `miniquake2/qcommon/cvar.ml` as `cvars` → [src/miniquake2/qcommon/cvar.ml](File-src-miniquake2-qcommon-cvar-ml-1999572875.md)
- `miniquake2/qcommon/directions.ml` as `qdir` → [src/miniquake2/qcommon/directions.ml](File-src-miniquake2-qcommon-directions-ml-1980852047.md)
- `miniquake2/qcommon/message.ml` as `message` → [src/miniquake2/qcommon/message.ml](File-src-miniquake2-qcommon-message-ml-1426179364.md)
- `miniquake2/qcommon/sizebuf.ml` as `sizebuf` → [src/miniquake2/qcommon/sizebuf.ml](File-src-miniquake2-qcommon-sizebuf-ml-1769950759.md)
- `miniquake2/qcommon/types.ml` as `qt` → [src/miniquake2/qcommon/types.ml](File-src-miniquake2-qcommon-types-ml-1663266398.md)
- `miniquake2/server/game_messages.ml` as `sgmessages` → [src/miniquake2/server/game_messages.ml](File-src-miniquake2-server-game-messages-ml-506318169.md)
- `miniquake2/server/sound_events.ml` as `ssoundevents` → [src/miniquake2/server/sound_events.ml](File-src-miniquake2-server-sound-events-ml-2055264741.md)
- `miniquake2/server/types.ml` as `st` → [src/miniquake2/server/types.ml](File-src-miniquake2-server-types-ml-1630118723.md)

## Declarations

<a id="function-function-miniquake2-server-game-bridge-activateruntime-function-activateruntime-context-src-miniquake2-server-game-bridge-ml-581615393"></a>
### activateRuntime

```ml
function activateRuntime(context)
```

Listen-client prediction shares the exact live collision bridge with the authoritative server. Explicit activation prevents a second test/listen session from leaving the module-global callback context on the wrong map.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `context` | `dynamic` | — | Context that carries state for the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/server/game_bridge.ml#L71)

<a id="function-function-miniquake2-server-game-bridge-activeruntime-function-activeruntime-src-miniquake2-server-game-bridge-ml-1115446372"></a>
### activeRuntime

```ml
function activeRuntime()
```

Return the optional active bridge for Game API-only lifecycle adapters.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/server/game_bridge.ml#L35)

<a id="function-function-miniquake2-server-game-bridge-adaptcollisiontrace-function-adaptcollisiontrace-context-result-src-miniquake2-server-game-bridge-ml-1455916296"></a>
### adaptCollisionTrace

```ml
function adaptCollisionTrace(context, result)
```

Trace adapt collision.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `context` | `dynamic` | — | Context that carries state for the operation. |
| `result` | `dynamic` | — | Result object populated or inspected by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/server/game_bridge.ml#L356)

<a id="function-function-miniquake2-server-game-bridge-adaptcollisiontracewithentity-function-adaptcollisiontracewithentity-context-result-hitentity-src-miniquake2-server-game-bridge-ml-1176169040"></a>
### adaptCollisionTraceWithEntity

```ml
function adaptCollisionTraceWithEntity(context, result, hitEntity)
```

Trace adapt collision with entity.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `context` | `dynamic` | — | Context that carries state for the operation. |
| `result` | `dynamic` | — | Result object populated or inspected by the operation. |
| `hitEntity` | `dynamic` | — | hitEntity value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/server/game_bridge.ml#L342)

<a id="function-function-miniquake2-server-game-bridge-addcommandstring-function-addcommandstring-value-src-miniquake2-server-game-bridge-ml-1372131029"></a>
### addCommandString

```ml
function addCommandString(value)
```

Add command string.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/server/game_bridge.ml#L1325)

<a id="function-function-miniquake2-server-game-bridge-appendlog-function-appendlog-level-value-src-miniquake2-server-game-bridge-ml-1244730595"></a>
### appendLog

```ml
function appendLog(level, value)
```

Append log.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `level` | `dynamic` | — | level value consumed by this operation. |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/server/game_bridge.ml#L81)

<a id="function-function-miniquake2-server-game-bridge-areasconnected-function-areasconnected-first-second-src-miniquake2-server-game-bridge-ml-314605090"></a>
### areasConnected

```ml
function areasConnected(first, second)
```

Report whether areas connected.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `first` | `dynamic` | — | first value consumed by this operation. |
| `second` | `dynamic` | — | second value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/server/game_bridge.ml#L738)

<a id="function-function-miniquake2-server-game-bridge-argc-function-argc-src-miniquake2-server-game-bridge-ml-802402400"></a>
### argc

```ml
function argc()
```

Return the argc value.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/server/game_bridge.ml#L1306)

<a id="function-function-miniquake2-server-game-bridge-args-function-args-src-miniquake2-server-game-bridge-ml-108059008"></a>
### args

```ml
function args()
```

Return the args value.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/server/game_bridge.ml#L1319)

<a id="function-function-miniquake2-server-game-bridge-argv-function-argv-index-src-miniquake2-server-game-bridge-ml-679329728"></a>
### argv

```ml
function argv(index)
```

Return the argv value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `index` | `dynamic` | — | Zero-based index of the affected item. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/server/game_bridge.ml#L1312)

<a id="function-function-miniquake2-server-game-bridge-boxedicts-function-boxedicts-mins-maxs-areatype-src-miniquake2-server-game-bridge-ml-204435405"></a>
### boxEdicts

```ml
function boxEdicts(mins, maxs, areaType)
```

Return the box edicts value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `mins` | `dynamic` | — | mins value consumed by this operation. |
| `maxs` | `dynamic` | — | maxs value consumed by this operation. |
| `areaType` | `dynamic` | — | areaType value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/server/game_bridge.ml#L1140)

<a id="function-function-miniquake2-server-game-bridge-bprintf-function-bprintf-value-src-miniquake2-server-game-bridge-ml-2058134247"></a>
### bprintf

```ml
function bprintf(value)
```

Return the bprintf value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/server/game_bridge.ml#L88)

<a id="function-function-miniquake2-server-game-bridge-bridgeimageindex-function-bridgeimageindex-name-src-miniquake2-server-game-bridge-ml-416005531"></a>
### bridgeImageIndex

```ml
function bridgeImageIndex(name)
```

Return the bridge image index.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `name` | `dynamic` | — | Name of the affected item. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/server/game_bridge.ml#L253)

<a id="function-function-miniquake2-server-game-bridge-bridgemodelindex-function-bridgemodelindex-name-src-miniquake2-server-game-bridge-ml-897882299"></a>
### bridgeModelIndex

```ml
function bridgeModelIndex(name)
```

Return the bridge model index.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `name` | `dynamic` | — | Name of the affected item. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/server/game_bridge.ml#L235)

<a id="function-function-miniquake2-server-game-bridge-bridgesoundindex-function-bridgesoundindex-name-src-miniquake2-server-game-bridge-ml-1381724195"></a>
### bridgeSoundIndex

```ml
function bridgeSoundIndex(name)
```

Return the bridge sound index.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `name` | `dynamic` | — | Name of the affected item. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/server/game_bridge.ml#L244)

<a id="function-function-miniquake2-server-game-bridge-centerprintf-function-centerprintf-entity-value-src-miniquake2-server-game-bridge-ml-2042399992"></a>
### centerprintf

```ml
function centerprintf(entity, value)
```

Return the centerprintf value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/server/game_bridge.ml#L123)

<a id="function-function-miniquake2-server-game-bridge-clearspatialcaches-function-clearspatialcaches-context-src-miniquake2-server-game-bridge-ml-624622623"></a>
### clearSpatialCaches

```ml
function clearSpatialCaches(context)
```

Discard every level-owned spatial index in one atomic replacement. Counts alone are insufficient: the reverse-position tables would make a reused edict number appear to be an old map's brush, trigger or box entity.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `context` | `dynamic` | — | Context that carries state for the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/server/game_bridge.ml#L947)

<a id="function-function-miniquake2-server-game-bridge-collectlinkedentityvisibility-function-collectlinkedentityvisibility-context-nodenumber-mins-maxs-entity-src-miniquake2-server-game-bridge-ml-1512294515"></a>
### collectLinkedEntityVisibility

```ml
function collectLinkedEntityVisibility(context, nodeNumber, mins, maxs, entity)
```

SV_LinkEdict records every distinct PVS cluster touched by the complete linked bounds, not merely the leaf containing s.origin.  Inline BSP origins commonly lie in solid or on the far side of an area boundary, so a point lookup makes doors, plats and buttons disappear even while their geometry is visible.  Fold cluster collection into the existing allocation-free BSP traversal.  MAX_ENT_CLUSTERS overflow retains Quake II's -1 sentinel; the per-client snapshot path then tests all leaves covered by the cached bounds.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `context` | `dynamic` | — | Context that carries state for the operation. |
| `nodeNumber` | `dynamic` | — | nodeNumber value consumed by this operation. |
| `mins` | `dynamic` | — | mins value consumed by this operation. |
| `maxs` | `dynamic` | — | maxs value consumed by this operation. |
| `entity` | `dynamic` | — | entity value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/server/game_bridge.ml#L996)

<a id="function-function-miniquake2-server-game-bridge-collisionworldready-function-collisionworldready-src-miniquake2-server-game-bridge-ml-1635172310"></a>
### collisionWorldReady

```ml
function collisionWorldReady()
```

Report whether collision world ready.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/server/game_bridge.ml#L745)

<a id="function-function-miniquake2-server-game-bridge-configstring-function-configstring-index-value-src-miniquake2-server-game-bridge-ml-2012214017"></a>
### configString

```ml
function configString(index, value)
```

Return the config string value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `index` | `dynamic` | — | Zero-based index of the affected item. |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/server/game_bridge.ml#L197)

<a id="function-function-miniquake2-server-game-bridge-cprintf-function-cprintf-entity-level-value-src-miniquake2-server-game-bridge-ml-808125124"></a>
### cprintf

```ml
function cprintf(entity, level, value)
```

Return the cprintf value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `level` | `dynamic` | — | level value consumed by this operation. |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/server/game_bridge.ml#L102)

<a id="function-function-miniquake2-server-game-bridge-createruntime-function-createruntime-maxclients-src-miniquake2-server-game-bridge-ml-340325366"></a>
### createRuntime

```ml
function createRuntime(maxClients)
```

Create runtime.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `maxClients` | `dynamic` | — | maxClients value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/server/game_bridge.ml#L1338)

<a id="function-function-miniquake2-server-game-bridge-debuggraph-function-debuggraph-value-color-src-miniquake2-server-game-bridge-ml-2107157388"></a>
### debugGraph

```ml
function debugGraph(value, color)
```

Return the debug graph value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |
| `color` | `dynamic` | — | color value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/server/game_bridge.ml#L1332)

<a id="function-function-miniquake2-server-game-bridge-dprintf-function-dprintf-value-src-miniquake2-server-game-bridge-ml-647469591"></a>
### dprintf

```ml
function dprintf(value)
```

Return the dprintf value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/server/game_bridge.ml#L94)

<a id="function-function-miniquake2-server-game-bridge-emptybridgetrace-function-emptybridgetrace-finish-src-miniquake2-server-game-bridge-ml-1575444851"></a>
### emptyBridgeTrace

```ml
function emptyBridgeTrace(finish)
```

Report whether empty bridge trace.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `finish` | `dynamic` | — | finish value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/server/game_bridge.ml#L418)

<a id="function-function-miniquake2-server-game-bridge-fail-function-fail-value-src-miniquake2-server-game-bridge-ml-445198633"></a>
### fail

```ml
function fail(value)
```

Return the fail value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/server/game_bridge.ml#L209)

<a id="function-function-miniquake2-server-game-bridge-findindex-function-findindex-values-name-create-src-miniquake2-server-game-bridge-ml-1275643955"></a>
### findIndex

```ml
function findIndex(values, name, create)
```

Find index.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `values` | `dynamic` | — | values value consumed by this operation. |
| `name` | `dynamic` | — | Name of the affected item. |
| `create` | `dynamic` | — | create value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/server/game_bridge.ml#L217)

<a id="function-function-miniquake2-server-game-bridge-freetags-function-freetags-tag-src-miniquake2-server-game-bridge-ml-195507656"></a>
### freeTags

```ml
function freeTags(tag)
```

Release tags.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `tag` | `dynamic` | — | tag value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/server/game_bridge.ml#L1279)

<a id="global-global-miniquake2-server-game-bridge-gamebridgeactiveruntime-gamebridgeactiveruntime-src-miniquake2-server-game-bridge-ml-2132509624"></a>
### gameBridgeActiveRuntime

```ml
gameBridgeActiveRuntime
```

Stores module-wide game bridge active runtime state for the miniquake2 server game bridge module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/server/game_bridge.ml#L30)

<a id="function-function-miniquake2-server-game-bridge-gamebridgeappendlog-function-gamebridgeappendlog-context-value-src-miniquake2-server-game-bridge-ml-1393359838"></a>
### gameBridgeAppendLog

```ml
function gameBridgeAppendLog(context, value)
```

Append game bridge log.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `context` | `dynamic` | — | Context that carries state for the operation. |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/server/game_bridge.ml#L43)

<a id="function-function-miniquake2-server-game-bridge-gamecvar-function-gamecvar-name-value-flags-src-miniquake2-server-game-bridge-ml-1255365559"></a>
### gameCvar

```ml
function gameCvar(name, value, flags)
```

Return the game cvar value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `name` | `dynamic` | — | Name of the affected item. |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |
| `flags` | `dynamic` | — | Bit flags controlling the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/server/game_bridge.ml#L1287)

<a id="function-function-miniquake2-server-game-bridge-gamecvarforceset-function-gamecvarforceset-name-value-src-miniquake2-server-game-bridge-ml-717708264"></a>
### gameCvarForceSet

```ml
function gameCvarForceSet(name, value)
```

Set game cvar force.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `name` | `dynamic` | — | Name of the affected item. |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/server/game_bridge.ml#L1301)

<a id="function-function-miniquake2-server-game-bridge-gamecvarset-function-gamecvarset-name-value-src-miniquake2-server-game-bridge-ml-1788340564"></a>
### gameCvarSet

```ml
function gameCvarSet(name, value)
```

Set game cvar.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `name` | `dynamic` | — | Name of the affected item. |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/server/game_bridge.ml#L1294)

<a id="function-function-miniquake2-server-game-bridge-inlinebrushcacheindex-function-inlinebrushcacheindex-context-entity-src-miniquake2-server-game-bridge-ml-1084556918"></a>
### inlineBrushCacheIndex

```ml
function inlineBrushCacheIndex(context, entity)
```

Cache inline brush index.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `context` | `dynamic` | — | Context that carries state for the operation. |
| `entity` | `dynamic` | — | entity value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/server/game_bridge.ml#L800)

<a id="function-function-miniquake2-server-game-bridge-inlinemodelnumber-function-inlinemodelnumber-name-src-miniquake2-server-game-bridge-ml-197106837"></a>
### inlineModelNumber

```ml
function inlineModelNumber(name)
```

Return the inline model number.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `name` | `dynamic` | — | Name of the affected item. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/server/game_bridge.ml#L262)

<a id="function-function-miniquake2-server-game-bridge-inphs-function-inphs-first-second-src-miniquake2-server-game-bridge-ml-1785525874"></a>
### inPHS

```ml
function inPHS(first, second)
```

Return the in phs value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `first` | `dynamic` | — | first value consumed by this operation. |
| `second` | `dynamic` | — | second value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/server/game_bridge.ml#L714)

<a id="function-function-miniquake2-server-game-bridge-inpvs-function-inpvs-first-second-src-miniquake2-server-game-bridge-ml-1164871346"></a>
### inPVS

```ml
function inPVS(first, second)
```

Return the in pvs value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `first` | `dynamic` | — | first value consumed by this operation. |
| `second` | `dynamic` | — | second value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/server/game_bridge.ml#L698)

<a id="function-function-miniquake2-server-game-bridge-linkentity-function-linkentity-entity-src-miniquake2-server-game-bridge-ml-773595907"></a>
### linkEntity

```ml
function linkEntity(entity)
```

Link entity.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/server/game_bridge.ml#L1048)

<a id="function-function-miniquake2-server-game-bridge-makeimports-function-makeimports-context-src-miniquake2-server-game-bridge-ml-1015896339"></a>
### makeImports

```ml
function makeImports(context)
```

Create imports.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `context` | `dynamic` | — | Context that carries state for the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/server/game_bridge.ml#L1365)

<a id="constant-constant-miniquake2-server-game-bridge-max-game-bridge-logs-const-max-game-bridge-logs-1024-src-miniquake2-server-game-bridge-ml-340052280"></a>
### MAX_GAME_BRIDGE_LOGS

```ml
const MAX_GAME_BRIDGE_LOGS = 1024
```

Defines the max game bridge logs constant used by the miniquake2 server game bridge module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/server/game_bridge.ml#L32)

<a id="function-function-miniquake2-server-game-bridge-multicast-function-multicast-origin-destination-src-miniquake2-server-game-bridge-ml-1073577830"></a>
### multicast

```ml
function multicast(origin, destination)
```

Return the multicast value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `origin` | `dynamic` | — | origin value consumed by this operation. |
| `destination` | `dynamic` | — | destination value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/server/game_bridge.ml#L1188)

<a id="function-function-miniquake2-server-game-bridge-pmove-function-pmove-value-src-miniquake2-server-game-bridge-ml-8259771"></a>
### pmove

```ml
function pmove(value)
```

Return the pmove value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/server/game_bridge.ml#L1181)

<a id="function-function-miniquake2-server-game-bridge-pointcontents-function-pointcontents-point-src-miniquake2-server-game-bridge-ml-113551302"></a>
### pointContents

```ml
function pointContents(point)
```

Performs the pointContents operation for the miniquake2 server game bridge module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `point` | `dynamic` | — | point value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/server/game_bridge.ml#L670)

<a id="function-function-miniquake2-server-game-bridge-positionedsound-function-positionedsound-origin-entity-channel-soundindex-volume-attenuation-timeoffset-src-miniquake2-server-game-bridge-ml-1525104805"></a>
### positionedSound

```ml
function positionedSound(origin, entity, channel, soundIndex, volume, attenuation, timeOffset)
```

Return the positioned sound value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `origin` | `dynamic` | — | origin value consumed by this operation. |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `channel` | `dynamic` | — | channel value consumed by this operation. |
| `soundIndex` | `dynamic` | — | Zero-based index of sound. |
| `volume` | `dynamic` | — | volume value consumed by this operation. |
| `attenuation` | `dynamic` | — | attenuation value consumed by this operation. |
| `timeOffset` | `dynamic` | — | timeOffset value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/server/game_bridge.ml#L186)

<a id="function-function-miniquake2-server-game-bridge-rebuildspatialcaches-function-rebuildspatialcaches-context-edicts-count-src-miniquake2-server-game-bridge-ml-839946954"></a>
### rebuildSpatialCaches

```ml
function rebuildSpatialCaches(context, edicts, count)
```

Rebuild the compact spatial sets from the authoritative exported edicts. Save restore replaces that whole array, so retaining any previous references would create phantom collisions or touches after the load.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `context` | `dynamic` | — | Context that carries state for the operation. |
| `edicts` | `dynamic` | — | edicts value consumed by this operation. |
| `count` | `dynamic` | — | Number of items or units to process. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/server/game_bridge.ml#L967)

<a id="function-function-miniquake2-server-game-bridge-requireactive-function-requireactive-operation-src-miniquake2-server-game-bridge-ml-2011726883"></a>
### requireActive

```ml
function requireActive(operation)
```

Report whether require active.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `operation` | `dynamic` | — | operation value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/server/game_bridge.ml#L61)

<a id="function-function-miniquake2-server-game-bridge-sametraceentity-function-sametraceentity-first-second-src-miniquake2-server-game-bridge-ml-1439200450"></a>
### sameTraceEntity

```ml
function sameTraceEntity(first, second)
```

Trace same entity.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `first` | `dynamic` | — | first value consumed by this operation. |
| `second` | `dynamic` | — | second value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/server/game_bridge.ml#L394)

<a id="function-function-miniquake2-server-game-bridge-setareaportalstate-function-setareaportalstate-portalnumber-isopen-src-miniquake2-server-game-bridge-ml-1409590319"></a>
### setAreaPortalState

```ml
function setAreaPortalState(portalNumber, isOpen)
```

Set area portal state.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `portalNumber` | `dynamic` | — | portalNumber value consumed by this operation. |
| `isOpen` | `dynamic` | — | isOpen value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/server/game_bridge.ml#L729)

<a id="function-function-miniquake2-server-game-bridge-setmodel-function-setmodel-entity-name-src-miniquake2-server-game-bridge-ml-434590388"></a>
### setModel

```ml
function setModel(entity, name)
```

Set model.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `name` | `dynamic` | — | Name of the affected item. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/server/game_bridge.ml#L278)

<a id="function-function-miniquake2-server-game-bridge-solidboxcacheindex-function-solidboxcacheindex-context-entity-src-miniquake2-server-game-bridge-ml-1816370316"></a>
### solidBoxCacheIndex

```ml
function solidBoxCacheIndex(context, entity)
```

Cache solid box index.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `context` | `dynamic` | — | Context that carries state for the operation. |
| `entity` | `dynamic` | — | entity value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/server/game_bridge.ml#L900)

<a id="function-function-miniquake2-server-game-bridge-solidboxtrace-function-solidboxtrace-start-mins-maxs-finish-entity-src-miniquake2-server-game-bridge-ml-647650980"></a>
### solidBoxTrace

```ml
function solidBoxTrace(start, mins, maxs, finish, entity)
```

CM_HeadnodeForBox + CM_TransformedBoxTrace for a linked SOLID_BBOX. The original collision model implements this as a temporary BSP hull; scalar Minkowski slabs are identical and avoid rebuilding or allocating that hull in every authoritative Pmove trace.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `start` | `dynamic` | — | start value consumed by this operation. |
| `mins` | `dynamic` | — | mins value consumed by this operation. |
| `maxs` | `dynamic` | — | maxs value consumed by this operation. |
| `finish` | `dynamic` | — | finish value consumed by this operation. |
| `entity` | `dynamic` | — | entity value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/server/game_bridge.ml#L434)

<a id="function-function-miniquake2-server-game-bridge-sound-function-sound-entity-channel-soundindex-volume-attenuation-timeoffset-src-miniquake2-server-game-bridge-ml-408279275"></a>
### sound

```ml
function sound(entity, channel, soundIndex, volume, attenuation, timeOffset)
```

Return the sound value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `channel` | `dynamic` | — | channel value consumed by this operation. |
| `soundIndex` | `dynamic` | — | Zero-based index of sound. |
| `volume` | `dynamic` | — | volume value consumed by this operation. |
| `attenuation` | `dynamic` | — | attenuation value consumed by this operation. |
| `timeOffset` | `dynamic` | — | timeOffset value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/server/game_bridge.ml#L146)

<a id="function-function-miniquake2-server-game-bridge-tagfree-function-tagfree-value-src-miniquake2-server-game-bridge-ml-601002073"></a>
### tagFree

```ml
function tagFree(value)
```

Release tag.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/server/game_bridge.ml#L1273)

<a id="function-function-miniquake2-server-game-bridge-tagmalloc-function-tagmalloc-size-tag-src-miniquake2-server-game-bridge-ml-434247847"></a>
### tagMalloc

```ml
function tagMalloc(size, tag)
```

Return the tag malloc value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `size` | `dynamic` | — | Size in the units required by the operation. |
| `tag` | `dynamic` | — | tag value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/server/game_bridge.ml#L1266)

<a id="function-function-miniquake2-server-game-bridge-trace-function-trace-start-mins-maxs-finish-passentity-contentmask-src-miniquake2-server-game-bridge-ml-230446982"></a>
### trace

```ml
function trace(start, mins, maxs, finish, passEntity, contentMask)
```

Trace state.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `start` | `dynamic` | — | start value consumed by this operation. |
| `mins` | `dynamic` | — | mins value consumed by this operation. |
| `maxs` | `dynamic` | — | maxs value consumed by this operation. |
| `finish` | `dynamic` | — | finish value consumed by this operation. |
| `passEntity` | `dynamic` | — | passEntity value consumed by this operation. |
| `contentMask` | `dynamic` | — | contentMask value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/server/game_bridge.ml#L562)

<a id="function-function-miniquake2-server-game-bridge-tracedot-function-tracedot-first-second-src-miniquake2-server-game-bridge-ml-1689651442"></a>
### traceDot

```ml
function traceDot(first, second)
```

Trace dot.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `first` | `dynamic` | — | first value consumed by this operation. |
| `second` | `dynamic` | — | second value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/server/game_bridge.ml#L367)

<a id="function-function-miniquake2-server-game-bridge-traceentityexcluded-function-traceentityexcluded-entity-passentity-contentmask-src-miniquake2-server-game-bridge-ml-1650019926"></a>
### traceEntityExcluded

```ml
function traceEntityExcluded(entity, passEntity, contentMask)
```

Trace entity excluded.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `passEntity` | `dynamic` | — | passEntity value consumed by this operation. |
| `contentMask` | `dynamic` | — | contentMask value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/server/game_bridge.ml#L403)

<a id="function-function-miniquake2-server-game-bridge-tracenormaltoworld-function-tracenormaltoworld-normal-basis-src-miniquake2-server-game-bridge-ml-1844354275"></a>
### traceNormalToWorld

```ml
function traceNormalToWorld(normal, basis)
```

Trace normal to world.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `normal` | `dynamic` | — | normal value consumed by this operation. |
| `basis` | `dynamic` | — | basis value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/server/game_bridge.ml#L383)

<a id="function-function-miniquake2-server-game-bridge-tracetomodel-function-tracetomodel-point-origin-basis-src-miniquake2-server-game-bridge-ml-1358969046"></a>
### traceToModel

```ml
function traceToModel(point, origin, basis)
```

Trace to model.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `point` | `dynamic` | — | point value consumed by this operation. |
| `origin` | `dynamic` | — | origin value consumed by this operation. |
| `basis` | `dynamic` | — | basis value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/server/game_bridge.ml#L375)

<a id="function-function-miniquake2-server-game-bridge-transformedentitybounds-function-transformedentitybounds-entity-src-miniquake2-server-game-bridge-ml-1394887049"></a>
### transformedEntityBounds

```ml
function transformedEntityBounds(entity)
```

Return the transformed entity bounds.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/server/game_bridge.ml#L752)

<a id="function-function-miniquake2-server-game-bridge-triggercacheindex-function-triggercacheindex-context-entity-src-miniquake2-server-game-bridge-ml-1838069868"></a>
### triggerCacheIndex

```ml
function triggerCacheIndex(context, entity)
```

Cache trigger index.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `context` | `dynamic` | — | Context that carries state for the operation. |
| `entity` | `dynamic` | — | entity value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/server/game_bridge.ml#L854)

<a id="function-function-miniquake2-server-game-bridge-unicast-function-unicast-entity-reliable-src-miniquake2-server-game-bridge-ml-301666547"></a>
### unicast

```ml
function unicast(entity, reliable)
```

Return the unicast value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `reliable` | `dynamic` | — | reliable value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/server/game_bridge.ml#L1200)

<a id="function-function-miniquake2-server-game-bridge-unlinkentity-function-unlinkentity-entity-src-miniquake2-server-game-bridge-ml-1203330335"></a>
### unlinkEntity

```ml
function unlinkEntity(entity)
```

Return the unlink entity value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `entity` | `dynamic` | — | entity value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/server/game_bridge.ml#L1126)

<a id="function-function-miniquake2-server-game-bridge-updateinlinebrushcache-function-updateinlinebrushcache-context-entity-linked-src-miniquake2-server-game-bridge-ml-2086842189"></a>
### updateInlineBrushCache

```ml
function updateInlineBrushCache(context, entity, linked)
```

SV_ClipMoveToEntities previously scanned every allocated edict for every Pmove trace. Maintain the tiny linked inline-brush set instead; retail maps typically reduce this hot loop from hundreds of entries to a few doors.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `context` | `dynamic` | — | Context that carries state for the operation. |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `linked` | `dynamic` | — | linked value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/server/game_bridge.ml#L815)

<a id="function-function-miniquake2-server-game-bridge-updatesolidboxcache-function-updatesolidboxcache-context-entity-linked-src-miniquake2-server-game-bridge-ml-1146281079"></a>
### updateSolidBoxCache

```ml
function updateSolidBoxCache(context, entity, linked)
```

AREA_SOLID is a spatial linked list in BaseQ2. Keep the dynamic BBOX subset as an allocation-free indexed set so the authoritative PMove hot path visits only currently linked players, monsters and other box solids.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `context` | `dynamic` | — | Context that carries state for the operation. |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `linked` | `dynamic` | — | linked value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/server/game_bridge.ml#L915)

<a id="function-function-miniquake2-server-game-bridge-updatetriggercache-function-updatetriggercache-context-entity-linked-src-miniquake2-server-game-bridge-ml-788324833"></a>
### updateTriggerCache

```ml
function updateTriggerCache(context, entity, linked)
```

AREA_TRIGGERS is a linked spatial set in the original server. Keep an allocation-free indexed set here as well so each walking monster does not rescan every retail-map edict merely to touch nearby triggers.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `context` | `dynamic` | — | Context that carries state for the operation. |
| `entity` | `dynamic` | — | entity value consumed by this operation. |
| `linked` | `dynamic` | — | linked value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/server/game_bridge.ml#L869)

<a id="function-function-miniquake2-server-game-bridge-writeangle-function-writeangle-value-src-miniquake2-server-game-bridge-ml-1571964657"></a>
### writeAngle

```ml
function writeAngle(value)
```

Write angle.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/server/game_bridge.ml#L1259)

<a id="function-function-miniquake2-server-game-bridge-writebyte-function-writebyte-value-src-miniquake2-server-game-bridge-ml-1774275207"></a>
### writeByte

```ml
function writeByte(value)
```

Write byte.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/server/game_bridge.ml#L1217)

<a id="function-function-miniquake2-server-game-bridge-writechar-function-writechar-value-src-miniquake2-server-game-bridge-ml-1724076283"></a>
### writeChar

```ml
function writeChar(value)
```

Write char.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/server/game_bridge.ml#L1211)

<a id="function-function-miniquake2-server-game-bridge-writedirection-function-writedirection-value-src-miniquake2-server-game-bridge-ml-1417146813"></a>
### writeDirection

```ml
function writeDirection(value)
```

Write direction.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/server/game_bridge.ml#L1253)

<a id="function-function-miniquake2-server-game-bridge-writefloat-function-writefloat-value-src-miniquake2-server-game-bridge-ml-1078052105"></a>
### writeFloat

```ml
function writeFloat(value)
```

Write float.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/server/game_bridge.ml#L1235)

<a id="function-function-miniquake2-server-game-bridge-writelong-function-writelong-value-src-miniquake2-server-game-bridge-ml-1313508703"></a>
### writeLong

```ml
function writeLong(value)
```

Write long.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/server/game_bridge.ml#L1229)

<a id="function-function-miniquake2-server-game-bridge-writeposition-function-writeposition-value-src-miniquake2-server-game-bridge-ml-2145442353"></a>
### writePosition

```ml
function writePosition(value)
```

Write position.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/server/game_bridge.ml#L1247)

<a id="function-function-miniquake2-server-game-bridge-writeshort-function-writeshort-value-src-miniquake2-server-game-bridge-ml-314897837"></a>
### writeShort

```ml
function writeShort(value)
```

Write short.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/server/game_bridge.ml#L1223)

<a id="function-function-miniquake2-server-game-bridge-writestring-function-writestring-value-src-miniquake2-server-game-bridge-ml-1079587569"></a>
### writeString

```ml
function writeString(value)
```

Write string.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/server/game_bridge.ml#L1241)
