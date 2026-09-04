# `src/miniquake2/client/runtime/dispatcher.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 client runtime dispatcher facilities for this project.

Package: [`miniquake2.client.runtime.dispatcher`](Package-miniquake2-client-runtime-dispatcher-1868694665.md)

Reachable from entry: **yes**

## Imports

- `miniquake2/client/demo.ml` as `cdemo` → [src/miniquake2/client/demo.ml](File-src-miniquake2-client-demo-ml-1496242839.md)
- `miniquake2/client/downloads.ml` as `cdownloads` → [src/miniquake2/client/downloads.ml](File-src-miniquake2-client-downloads-ml-2137413515.md)
- `miniquake2/client/effects/constants.ml` as `ceconstants` → [src/miniquake2/client/effects/constants.ml](File-src-miniquake2-client-effects-constants-ml-55259948.md)
- `miniquake2/client/effects/parser.ml` as `ceparser` → [src/miniquake2/client/effects/parser.ml](File-src-miniquake2-client-effects-parser-ml-212038918.md)
- `miniquake2/client/effects/state.ml` as `cestate` → [src/miniquake2/client/effects/state.ml](File-src-miniquake2-client-effects-state-ml-140719308.md)
- `miniquake2/client/runtime/types.ml` as `crtypes` → [src/miniquake2/client/runtime/types.ml](File-src-miniquake2-client-runtime-types-ml-466848886.md)
- `miniquake2/client/state.ml` as `cstate` → [src/miniquake2/client/state.ml](File-src-miniquake2-client-state-ml-1458406995.md)
- `miniquake2/network/client.ml` as `nclient` → [src/miniquake2/network/client.ml](File-src-miniquake2-network-client-ml-1115555876.md)
- `miniquake2/network/constants.ml` as `nc` → [src/miniquake2/network/constants.ml](File-src-miniquake2-network-constants-ml-102415622.md)
- `miniquake2/network/runtime/lifecycle.ml` as `nrlifecycle` → [src/miniquake2/network/runtime/lifecycle.ml](File-src-miniquake2-network-runtime-lifecycle-ml-700259748.md)
- `miniquake2/network/runtime/messages.ml` as `rmessages` → [src/miniquake2/network/runtime/messages.ml](File-src-miniquake2-network-runtime-messages-ml-904838874.md)
- `miniquake2/network/runtime/types.ml` as `nrtypes` → [src/miniquake2/network/runtime/types.ml](File-src-miniquake2-network-runtime-types-ml-1235773127.md)
- `miniquake2/protocol/checked.ml` as `pchecked` → [src/miniquake2/protocol/checked.ml](File-src-miniquake2-protocol-checked-ml-1828862158.md)
- `miniquake2/protocol/constants.ml` as `pc` → [src/miniquake2/protocol/constants.ml](File-src-miniquake2-protocol-constants-ml-642349806.md)
- `miniquake2/protocol/entity_delta.ml` as `pentity` → [src/miniquake2/protocol/entity_delta.ml](File-src-miniquake2-protocol-entity-delta-ml-602212639.md)
- `miniquake2/protocol/netchan.ml` as `pnetchan` → [src/miniquake2/protocol/netchan.ml](File-src-miniquake2-protocol-netchan-ml-626556964.md)
- `miniquake2/protocol/types.ml` as `pt` → [src/miniquake2/protocol/types.ml](File-src-miniquake2-protocol-types-ml-736261438.md)
- `miniquake2/qcommon/constants.ml` as `qc` → [src/miniquake2/qcommon/constants.ml](File-src-miniquake2-qcommon-constants-ml-1976195726.md)

## Declarations

<a id="function-function-miniquake2-client-runtime-dispatcher-acceptframe-function-acceptframe-runtime-buffer-src-miniquake2-client-runtime-dispatcher-ml-1906312957"></a>
### acceptFrame

```ml
function acceptFrame(runtime, buffer)
```

Accept frame.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |
| `buffer` | `dynamic` | — | Buffer that receives or supplies the operation data. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/runtime/dispatcher.ml#L379)

<a id="global-global-miniquake2-client-runtime-dispatcher-activeresolverruntime-activeresolverruntime-src-miniquake2-client-runtime-dispatcher-ml-199216039"></a>
### activeResolverRuntime

```ml
activeResolverRuntime
```

Stores module-wide active resolver runtime state for the miniquake2 client runtime dispatcher module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/runtime/dispatcher.ml#L30)

<a id="function-function-miniquake2-client-runtime-dispatcher-appenddownload-function-appenddownload-runtime-buffer-src-miniquake2-client-runtime-dispatcher-ml-1821264751"></a>
### appendDownload

```ml
function appendDownload(runtime, buffer)
```

Append download.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |
| `buffer` | `dynamic` | — | Buffer that receives or supplies the operation data. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/runtime/dispatcher.ml#L344)

<a id="function-function-miniquake2-client-runtime-dispatcher-appendlimited-function-appendlimited-values-value-maximum-src-miniquake2-client-runtime-dispatcher-ml-248001966"></a>
### appendLimited

```ml
function appendLimited(values, value, maximum)
```

Append limited.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `values` | `dynamic` | — | values value consumed by this operation. |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |
| `maximum` | `dynamic` | — | maximum value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/runtime/dispatcher.ml#L249)

<a id="function-function-miniquake2-client-runtime-dispatcher-beginmapchange-function-beginmapchange-runtime-src-miniquake2-client-runtime-dispatcher-ml-330129477"></a>
### beginMapChange

```ml
function beginMapChange(runtime)
```

Begin map change.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/runtime/dispatcher.ml#L139)

<a id="function-function-miniquake2-client-runtime-dispatcher-beginreconnect-function-beginreconnect-runtime-now-src-miniquake2-client-runtime-dispatcher-ml-2058450251"></a>
### beginReconnect

```ml
function beginReconnect(runtime, now)
```

Begin a user-requested reconnect through the same atomic retirement path as svc_reconnect, without pretending that a server packet was received.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |
| `now` | `dynamic` | — | now value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/runtime/dispatcher.ml#L474)

<a id="function-function-miniquake2-client-runtime-dispatcher-copyarray-function-copyarray-values-src-miniquake2-client-runtime-dispatcher-ml-2052108677"></a>
### copyArray

```ml
function copyArray(values)
```

Copy array data.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `values` | `dynamic` | — | values value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/runtime/dispatcher.ml#L148)

<a id="function-function-miniquake2-client-runtime-dispatcher-create-function-create-networkruntime-clientstate-effectstate-src-miniquake2-client-runtime-dispatcher-ml-400858515"></a>
### create

```ml
function create(networkRuntime, clientState, effectState)
```

Creates create for the miniquake2 client runtime dispatcher module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `networkRuntime` | `dynamic` | — | networkRuntime value consumed by this operation. |
| `clientState` | `dynamic` | — | clientState value consumed by this operation. |
| `effectState` | `dynamic` | — | effectState value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/runtime/dispatcher.ml#L41)

<a id="function-function-miniquake2-client-runtime-dispatcher-dispatch-function-dispatch-runtime-payload-sequence-now-src-miniquake2-client-runtime-dispatcher-ml-1725585346"></a>
### dispatch

```ml
function dispatch(runtime, payload, sequence, now)
```

Dispatch state.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |
| `payload` | `dynamic` | — | payload value consumed by this operation. |
| `sequence` | `dynamic` | — | sequence value consumed by this operation. |
| `now` | `dynamic` | — | now value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/runtime/dispatcher.ml#L487)

<a id="function-function-miniquake2-client-runtime-dispatcher-entity-function-entity-runtime-number-src-miniquake2-client-runtime-dispatcher-ml-1780165574"></a>
### entity

```ml
function entity(runtime, number)
```

Return the entity value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |
| `number` | `dynamic` | — | number value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/runtime/dispatcher.ml#L326)

<a id="constant-constant-miniquake2-client-runtime-dispatcher-max-print-handoffs-const-max-print-handoffs-64-src-miniquake2-client-runtime-dispatcher-ml-220481500"></a>
### MAX_PRINT_HANDOFFS

```ml
const MAX_PRINT_HANDOFFS = 64
```

Defines the max print handoffs constant used by the miniquake2 client runtime dispatcher module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/runtime/dispatcher.ml#L33)

<a id="constant-constant-miniquake2-client-runtime-dispatcher-max-screen-handoffs-const-max-screen-handoffs-16-src-miniquake2-client-runtime-dispatcher-ml-661863815"></a>
### MAX_SCREEN_HANDOFFS

```ml
const MAX_SCREEN_HANDOFFS = 16
```

Defines the max screen handoffs constant used by the miniquake2 client runtime dispatcher module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/runtime/dispatcher.ml#L35)

<a id="function-function-miniquake2-client-runtime-dispatcher-nextdemo-function-nextdemo-runtime-player-now-src-miniquake2-client-runtime-dispatcher-ml-1815041110"></a>
### nextDemo

```ml
function nextDemo(runtime, player, now)
```

Return the next demo value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |
| `player` | `dynamic` | — | player value consumed by this operation. |
| `now` | `dynamic` | — | now value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/runtime/dispatcher.ml#L534)

<a id="function-function-miniquake2-client-runtime-dispatcher-parsebuffer-function-parsebuffer-runtime-buffer-now-src-miniquake2-client-runtime-dispatcher-ml-955256143"></a>
### parseBuffer

```ml
function parseBuffer(runtime, buffer, now)
```

Parse buffer.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |
| `buffer` | `dynamic` | — | Buffer that receives or supplies the operation data. |
| `now` | `dynamic` | — | now value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/runtime/dispatcher.ml#L409)

<a id="function-function-miniquake2-client-runtime-dispatcher-parsecenterprint-function-parsecenterprint-runtime-buffer-now-src-miniquake2-client-runtime-dispatcher-ml-1148293285"></a>
### parseCenterPrint

```ml
function parseCenterPrint(runtime, buffer, now)
```

Parse center print.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |
| `buffer` | `dynamic` | — | Buffer that receives or supplies the operation data. |
| `now` | `dynamic` | — | now value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/runtime/dispatcher.ml#L289)

<a id="function-function-miniquake2-client-runtime-dispatcher-parseinventory-function-parseinventory-runtime-buffer-now-src-miniquake2-client-runtime-dispatcher-ml-1755062121"></a>
### parseInventory

```ml
function parseInventory(runtime, buffer, now)
```

Parse inventory.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |
| `buffer` | `dynamic` | — | Buffer that receives or supplies the operation data. |
| `now` | `dynamic` | — | now value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/runtime/dispatcher.ml#L311)

<a id="function-function-miniquake2-client-runtime-dispatcher-parselayout-function-parselayout-runtime-buffer-now-src-miniquake2-client-runtime-dispatcher-ml-1614001075"></a>
### parseLayout

```ml
function parseLayout(runtime, buffer, now)
```

Parse layout.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |
| `buffer` | `dynamic` | — | Buffer that receives or supplies the operation data. |
| `now` | `dynamic` | — | now value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/runtime/dispatcher.ml#L300)

<a id="function-function-miniquake2-client-runtime-dispatcher-parseprint-function-parseprint-runtime-buffer-now-src-miniquake2-client-runtime-dispatcher-ml-911848053"></a>
### parsePrint

```ml
function parsePrint(runtime, buffer, now)
```

Parse print.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |
| `buffer` | `dynamic` | — | Buffer that receives or supplies the operation data. |
| `now` | `dynamic` | — | now value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/runtime/dispatcher.ml#L276)

<a id="function-function-miniquake2-client-runtime-dispatcher-pendingstufftext-function-pendingstufftext-runtime-src-miniquake2-client-runtime-dispatcher-ml-2027346681"></a>
### pendingStuffText

```ml
function pendingStuffText(runtime)
```

Report whether pending stuff text.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/runtime/dispatcher.ml#L546)

<a id="function-function-miniquake2-client-runtime-dispatcher-readuistring-function-readuistring-buffer-operation-src-miniquake2-client-runtime-dispatcher-ml-1989803524"></a>
### readUiString

```ml
function readUiString(buffer, operation)
```

Read ui string.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `buffer` | `dynamic` | — | Buffer that receives or supplies the operation data. |
| `operation` | `dynamic` | — | operation value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/runtime/dispatcher.ml#L264)

<a id="function-function-miniquake2-client-runtime-dispatcher-releaseresolver-function-releaseresolver-src-miniquake2-client-runtime-dispatcher-ml-807225649"></a>
### releaseResolver

```ml
function releaseResolver()
```

Release resolver.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/runtime/dispatcher.ml#L83)

<a id="function-function-miniquake2-client-runtime-dispatcher-resetclientstate-function-resetclientstate-runtime-src-miniquake2-client-runtime-dispatcher-ml-1437518253"></a>
### resetClientState

```ml
function resetClientState(runtime)
```

Reset client state.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/runtime/dispatcher.ml#L91)

<a id="function-function-miniquake2-client-runtime-dispatcher-resolveentity-function-resolveentity-number-src-miniquake2-client-runtime-dispatcher-ml-496397062"></a>
### resolveEntity

```ml
function resolveEntity(number)
```

Resolve entity.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `number` | `dynamic` | — | number value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/runtime/dispatcher.ml#L335)

<a id="function-function-miniquake2-client-runtime-dispatcher-setdemorecorder-function-setdemorecorder-runtime-demo-src-miniquake2-client-runtime-dispatcher-ml-869580826"></a>
### setDemoRecorder

```ml
function setDemoRecorder(runtime, demo)
```

Set demo recorder.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |
| `demo` | `dynamic` | — | demo value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/runtime/dispatcher.ml#L54)

<a id="function-function-miniquake2-client-runtime-dispatcher-setdownloadmanager-function-setdownloadmanager-runtime-manager-src-miniquake2-client-runtime-dispatcher-ml-1690257774"></a>
### setDownloadManager

```ml
function setDownloadManager(runtime, manager)
```

Set download manager.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |
| `manager` | `dynamic` | — | manager value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/runtime/dispatcher.ml#L63)

<a id="function-function-miniquake2-client-runtime-dispatcher-setlegacydemocompatibility-function-setlegacydemocompatibility-runtime-enabled-src-miniquake2-client-runtime-dispatcher-ml-614083288"></a>
### setLegacyDemoCompatibility

```ml
function setLegacyDemoCompatibility(runtime, enabled)
```

Release DM2 files shipped with Quake II use protocol 26. The 3.19 client kept an explicit demo-only compatibility hack; live network sessions remain strictly Protocol 34.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |
| `enabled` | `dynamic` | — | enabled value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/runtime/dispatcher.ml#L76)

<a id="function-function-miniquake2-client-runtime-dispatcher-takecenterprints-function-takecenterprints-runtime-src-miniquake2-client-runtime-dispatcher-ml-1895172341"></a>
### takeCenterPrints

```ml
function takeCenterPrints(runtime)
```

Consume center prints.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/runtime/dispatcher.ml#L560)

<a id="function-function-miniquake2-client-runtime-dispatcher-takeinventories-function-takeinventories-runtime-src-miniquake2-client-runtime-dispatcher-ml-1467418703"></a>
### takeInventories

```ml
function takeInventories(runtime)
```

Consume inventories.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/runtime/dispatcher.ml#L576)

<a id="function-function-miniquake2-client-runtime-dispatcher-takelayouts-function-takelayouts-runtime-src-miniquake2-client-runtime-dispatcher-ml-624333913"></a>
### takeLayouts

```ml
function takeLayouts(runtime)
```

Consume layouts.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/runtime/dispatcher.ml#L568)

<a id="function-function-miniquake2-client-runtime-dispatcher-takeprints-function-takeprints-runtime-src-miniquake2-client-runtime-dispatcher-ml-957367245"></a>
### takePrints

```ml
function takePrints(runtime)
```

Consume prints.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/runtime/dispatcher.ml#L552)

<a id="function-function-miniquake2-client-runtime-dispatcher-validationruntime-function-validationruntime-runtime-src-miniquake2-client-runtime-dispatcher-ml-1919305963"></a>
### validationRuntime

```ml
function validationRuntime(runtime)
```

Return the validation runtime value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `runtime` | `dynamic` | — | runtime value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/runtime/dispatcher.ml#L161)
