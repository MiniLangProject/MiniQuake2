# `src/miniquake2/server/administration.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 server administration facilities for this project.

Package: [`miniquake2.server.administration`](Package-miniquake2-server-administration-1269037448.md)

Reachable from entry: **yes**

## Imports

- `miniquake2/network/constants.ml` as `adminnc` → [src/miniquake2/network/constants.ml](File-src-miniquake2-network-constants-ml-102415622.md)
- `miniquake2/qcommon/text.ml` as `admintext` → [src/miniquake2/qcommon/text.ml](File-src-miniquake2-qcommon-text-ml-1570504148.md)
- `miniquake2/qcommon/types.ml` as `adminqtypes` → [src/miniquake2/qcommon/types.ml](File-src-miniquake2-qcommon-types-ml-1663266398.md)
- `std/fs.ml` as `adminfs` → `../MiniLangCompilerML/std/fs.ml` — external dependency

## Declarations

<a id="function-function-miniquake2-server-administration-activate-function-activate-state-src-miniquake2-server-administration-ml-1086644441"></a>
### activate

```ml
function activate(state)
```

Performs the activate operation for the miniquake2 server administration module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/server/administration.ml#L66)

<a id="function-function-miniquake2-server-administration-active-function-active-src-miniquake2-server-administration-ml-2127845794"></a>
### active

```ml
function active()
```

Report whether active.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/server/administration.ml#L74)

<a id="global-global-miniquake2-server-administration-activeadministration-activeadministration-src-miniquake2-server-administration-ml-545703612"></a>
### activeAdministration

```ml
activeAdministration
```

Stores module-wide active administration state for the miniquake2 server administration module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/server/administration.ml#L27)

<a id="function-function-miniquake2-server-administration-addip-function-addip-state-value-src-miniquake2-server-administration-ml-849962844"></a>
### addIp

```ml
function addIp(state, value)
```

Add ip.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/server/administration.ml#L156)

- [miniquake2.server.administration.Administration](Type-miniquake2-server-administration-administration-16983148.md) — struct
<a id="function-function-miniquake2-server-administration-configtext-function-configtext-state-src-miniquake2-server-administration-ml-1081519449"></a>
### configText

```ml
function configText(state)
```

Return the config text value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/server/administration.ml#L203)

<a id="function-function-miniquake2-server-administration-configuremasters-function-configuremasters-state-arguments-startindex-src-miniquake2-server-administration-ml-1078719483"></a>
### configureMasters

```ml
function configureMasters(state, arguments, startIndex)
```

Configure masters.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |
| `arguments` | `dynamic` | — | arguments value consumed by this operation. |
| `startIndex` | `dynamic` | — | Zero-based index of start. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/server/administration.ml#L390)

<a id="function-function-miniquake2-server-administration-constanttimeequal-function-constanttimeequal-first-second-src-miniquake2-server-administration-ml-780215870"></a>
### constantTimeEqual

```ml
function constantTimeEqual(first, second)
```

Report whether constant time equal.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `first` | `dynamic` | — | first value consumed by this operation. |
| `second` | `dynamic` | — | second value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/server/administration.ml#L314)

<a id="function-function-miniquake2-server-administration-create-function-create-src-miniquake2-server-administration-ml-1719612454"></a>
### create

```ml
function create()
```

Creates create for the miniquake2 server administration module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/server/administration.ml#L60)

<a id="function-function-miniquake2-server-administration-decimaloctet-function-decimaloctet-source-start-endindex-src-miniquake2-server-administration-ml-1534780498"></a>
### decimalOctet

```ml
function decimalOctet(source, start, endIndex)
```

Return the decimal octet value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `source` | `dynamic` | — | source value consumed by this operation. |
| `start` | `dynamic` | — | start value consumed by this operation. |
| `endIndex` | `dynamic` | — | Zero-based index of end. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/server/administration.ml#L84)

<a id="constant-constant-miniquake2-server-administration-default-master-port-const-default-master-port-27900-src-miniquake2-server-administration-ml-2120936831"></a>
### DEFAULT_MASTER_PORT

```ml
const DEFAULT_MASTER_PORT = 27900
```

Defines the default master port constant used by the miniquake2 server administration module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/server/administration.ml#L24)

<a id="function-function-miniquake2-server-administration-filterpacket-function-filterpacket-state-address-src-miniquake2-server-administration-ml-1960238495"></a>
### filterPacket

```ml
function filterPacket(state, address)
```

True means the connect must be rejected, mirroring SV_FilterPacket.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |
| `address` | `dynamic` | — | address value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/server/administration.ml#L264)

<a id="function-function-miniquake2-server-administration-filtertext-function-filtertext-filter-src-miniquake2-server-administration-ml-549273496"></a>
### filterText

```ml
function filterText(filter)
```

Filter text.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `filter` | `dynamic` | — | filter value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/server/administration.ml#L148)

- [miniquake2.server.administration.IpFilter](Type-miniquake2-server-administration-ipfilter-1475808397.md) — struct
<a id="function-function-miniquake2-server-administration-listip-function-listip-state-src-miniquake2-server-administration-ml-1243707341"></a>
### listIp

```ml
function listIp(state)
```

Return the list ip value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/server/administration.ml#L193)

<a id="function-function-miniquake2-server-administration-matches-function-matches-filter-address-src-miniquake2-server-administration-ml-1769279498"></a>
### matches

```ml
function matches(filter, address)
```

Return the matches value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `filter` | `dynamic` | — | filter value consumed by this operation. |
| `address` | `dynamic` | — | address value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/server/administration.ml#L247)

<a id="constant-constant-miniquake2-server-administration-max-ip-filters-const-max-ip-filters-1024-src-miniquake2-server-administration-ml-1870057944"></a>
### MAX_IP_FILTERS

```ml
const MAX_IP_FILTERS = 1024
```

Defines the max ip filters constant used by the miniquake2 server administration module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/server/administration.ml#L18)

<a id="constant-constant-miniquake2-server-administration-max-rcon-password-bytes-const-max-rcon-password-bytes-128-src-miniquake2-server-administration-ml-617995204"></a>
### MAX_RCON_PASSWORD_BYTES

```ml
const MAX_RCON_PASSWORD_BYTES = 128
```

Defines the max rcon password bytes constant used by the miniquake2 server administration module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/server/administration.ml#L20)

<a id="constant-constant-miniquake2-server-administration-min-rcon-password-bytes-const-min-rcon-password-bytes-8-src-miniquake2-server-administration-ml-1607354521"></a>
### MIN_RCON_PASSWORD_BYTES

```ml
const MIN_RCON_PASSWORD_BYTES = 8
```

Defines the min rcon password bytes constant used by the miniquake2 server administration module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/server/administration.ml#L22)

<a id="function-function-miniquake2-server-administration-parseendpoint-function-parseendpoint-value-src-miniquake2-server-administration-ml-585763181"></a>
### parseEndpoint

```ml
function parseEndpoint(value)
```

Parse endpoint.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/server/administration.ml#L342)

<a id="function-function-miniquake2-server-administration-parsefilter-function-parsefilter-value-src-miniquake2-server-administration-ml-1451299735"></a>
### parseFilter

```ml
function parseFilter(value)
```

StringToFilter intentionally retains the original zero-octet wildcard rule.  Consequently "192.0" describes 192.*.*.*, exactly as baseq2 3.19.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/server/administration.ml#L105)

<a id="function-function-miniquake2-server-administration-printablepassword-function-printablepassword-value-src-miniquake2-server-administration-ml-1021761061"></a>
### printablePassword

```ml
function printablePassword(value)
```

Return the printable password value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/server/administration.ml#L285)

<a id="function-function-miniquake2-server-administration-rconvalid-function-rconvalid-state-supplied-src-miniquake2-server-administration-ml-1628527791"></a>
### rconValid

```ml
function rconValid(state, supplied)
```

Report whether rcon valid.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |
| `supplied` | `dynamic` | — | supplied value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/server/administration.ml#L335)

<a id="function-function-miniquake2-server-administration-removeip-function-removeip-state-value-src-miniquake2-server-administration-ml-1780034884"></a>
### removeIp

```ml
function removeIp(state, value)
```

Remove ip.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/server/administration.ml#L167)

<a id="function-function-miniquake2-server-administration-samefilter-function-samefilter-first-second-src-miniquake2-server-administration-ml-53677460"></a>
### sameFilter

```ml
function sameFilter(first, second)
```

Filter same.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `first` | `dynamic` | — | first value consumed by this operation. |
| `second` | `dynamic` | — | second value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/server/administration.ml#L136)

<a id="function-function-miniquake2-server-administration-servercommand-function-servercommand-state-arguments-src-miniquake2-server-administration-ml-1508889783"></a>
### serverCommand

```ml
function serverCommand(state, arguments)
```

Return the server command value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |
| `arguments` | `dynamic` | — | arguments value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/server/administration.ml#L420)

<a id="function-function-miniquake2-server-administration-setfilterban-function-setfilterban-state-value-src-miniquake2-server-administration-ml-896176400"></a>
### setFilterBan

```ml
function setFilterBan(state, value)
```

Set filter ban.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/server/administration.ml#L277)

<a id="function-function-miniquake2-server-administration-setrconpassword-function-setrconpassword-state-value-src-miniquake2-server-administration-ml-1400548606"></a>
### setRconPassword

```ml
function setRconPassword(state, value)
```

Empty disables RCON like 3.19. Non-empty secrets get a modern minimum and must remain one printable command token; this avoids ambiguous wire parsing.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/server/administration.ml#L299)

<a id="function-function-miniquake2-server-administration-setwritepath-function-setwritepath-state-path-src-miniquake2-server-administration-ml-1442311848"></a>
### setWritePath

```ml
function setWritePath(state, path)
```

Set write path.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |
| `path` | `dynamic` | — | Path of the file or directory used by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/server/administration.ml#L216)

<a id="function-function-miniquake2-server-administration-takemasterping-function-takemasterping-state-src-miniquake2-server-administration-ml-1282526229"></a>
### takeMasterPing

```ml
function takeMasterPing(state)
```

Consume master ping.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/server/administration.ml#L411)

<a id="function-function-miniquake2-server-administration-writeip-function-writeip-state-src-miniquake2-server-administration-ml-55658649"></a>
### writeIp

```ml
function writeIp(state)
```

Use an adjacent verified temporary file so a failed write never truncates the active access-control policy.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/server/administration.ml#L225)
