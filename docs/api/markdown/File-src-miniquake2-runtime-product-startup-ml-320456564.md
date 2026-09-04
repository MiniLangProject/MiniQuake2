# `src/miniquake2/runtime/product_startup.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 runtime product startup facilities for this project.

Package: [`miniquake2.runtime.product_startup`](Package-miniquake2-runtime-product-startup-771495518.md)

Reachable from entry: **yes**

## Imports

- `miniquake2/network/client.ml` as `productnetworkclient` → [src/miniquake2/network/client.ml](File-src-miniquake2-network-client-ml-1115555876.md)
- `miniquake2/network/connectionless.ml` as `productconnectionless` → [src/miniquake2/network/connectionless.ml](File-src-miniquake2-network-connectionless-ml-440321234.md)
- `miniquake2/network/runtime/transport.ml` as `producttransport` → [src/miniquake2/network/runtime/transport.ml](File-src-miniquake2-network-runtime-transport-ml-1946942007.md)
- `miniquake2/platform/udp.ml` as `productudp` → [src/miniquake2/platform/udp.ml](File-src-miniquake2-platform-udp-ml-357648233.md)
- `miniquake2/qcommon/info.ml` as `productinfo` → [src/miniquake2/qcommon/info.ml](File-src-miniquake2-qcommon-info-ml-634538165.md)
- `miniquake2/qcommon/text.ml` as `producttext` → [src/miniquake2/qcommon/text.ml](File-src-miniquake2-qcommon-text-ml-1570504148.md)
- `std/fs.ml` as `productfs` → `../MiniLangCompilerML/std/fs.ml` — external dependency
- `std/string.ml` as `productstring` → `../MiniLangCompilerML/std/string.ml` — external dependency

## Declarations

<a id="function-function-miniquake2-runtime-product-startup-activate-function-activate-lifecycle-mapname-src-miniquake2-runtime-product-startup-ml-1667372891"></a>
### activate

```ml
function activate(lifecycle, mapName)
```

Performs the activate operation for the miniquake2 runtime product startup module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `lifecycle` | `dynamic` | — | lifecycle value consumed by this operation. |
| `mapName` | `dynamic` | — | mapName value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/product_startup.ml#L682)

<a id="function-function-miniquake2-runtime-product-startup-addbrowserentry-function-addbrowserentry-browser-endpoint-description-now-src-miniquake2-runtime-product-startup-ml-1258443499"></a>
### addBrowserEntry

```ml
function addBrowserEntry(browser, endpoint, description, now)
```

Add browser entry.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `browser` | `dynamic` | — | browser value consumed by this operation. |
| `endpoint` | `dynamic` | — | endpoint value consumed by this operation. |
| `description` | `dynamic` | — | description value consumed by this operation. |
| `now` | `dynamic` | — | now value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/product_startup.ml#L285)

<a id="function-function-miniquake2-runtime-product-startup-beginconnect-function-beginconnect-lifecycle-endpoint-src-miniquake2-runtime-product-startup-ml-1613342175"></a>
### beginConnect

```ml
function beginConnect(lifecycle, endpoint)
```

Begin connect.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `lifecycle` | `dynamic` | — | lifecycle value consumed by this operation. |
| `endpoint` | `dynamic` | — | endpoint value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/product_startup.ml#L669)

<a id="function-function-miniquake2-runtime-product-startup-beginlocal-function-beginlocal-lifecycle-mapname-src-miniquake2-runtime-product-startup-ml-154582595"></a>
### beginLocal

```ml
function beginLocal(lifecycle, mapName)
```

Begin local.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `lifecycle` | `dynamic` | — | lifecycle value consumed by this operation. |
| `mapName` | `dynamic` | — | mapName value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/product_startup.ml#L657)

<a id="constant-constant-miniquake2-runtime-product-startup-browser-msec-const-browser-msec-1200-src-miniquake2-runtime-product-startup-ml-1553823244"></a>
### BROWSER_MSEC

```ml
const BROWSER_MSEC = 1200
```

Defines the browser msec constant used by the miniquake2 runtime product startup module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/product_startup.ml#L24)

<a id="function-function-miniquake2-runtime-product-startup-browserentrycount-function-browserentrycount-browser-src-miniquake2-runtime-product-startup-ml-92247222"></a>
### browserEntryCount

```ml
function browserEntryCount(browser)
```

Return the browser entry count.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `browser` | `dynamic` | — | browser value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/product_startup.ml#L272)

<a id="function-function-miniquake2-runtime-product-startup-closebrowser-function-closebrowser-browser-src-miniquake2-runtime-product-startup-ml-1108353956"></a>
### closeBrowser

```ml
function closeBrowser(browser)
```

Close browser.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `browser` | `dynamic` | — | browser value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/product_startup.ml#L356)

<a id="function-function-miniquake2-runtime-product-startup-closercontransport-function-closercontransport-transport-src-miniquake2-runtime-product-startup-ml-1179471667"></a>
### closeRconTransport

```ml
function closeRconTransport(transport)
```

Close an outstanding main-menu RCON exchange.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `transport` | `dynamic` | — | transport value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/product_startup.ml#L419)

<a id="function-function-miniquake2-runtime-product-startup-createbrowser-function-createbrowser-src-miniquake2-runtime-product-startup-ml-394057784"></a>
### createBrowser

```ml
function createBrowser()
```

Create browser.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/product_startup.ml#L266)

<a id="function-function-miniquake2-runtime-product-startup-createlifecycle-function-createlifecycle-dataroot-src-miniquake2-runtime-product-startup-ml-1284650120"></a>
### createLifecycle

```ml
function createLifecycle(dataRoot)
```

Create lifecycle.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `dataRoot` | `dynamic` | — | dataRoot value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/product_startup.ml#L649)

<a id="function-function-miniquake2-runtime-product-startup-creatercontransport-function-creatercontransport-src-miniquake2-runtime-product-startup-ml-1409599302"></a>
### createRconTransport

```ml
function createRconTransport()
```

Create a disconnected-console RCON transport without retaining a socket.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/product_startup.ml#L362)

<a id="function-function-miniquake2-runtime-product-startup-decodepreferences-function-decodepreferences-text-src-miniquake2-runtime-product-startup-ml-1868329309"></a>
### decodePreferences

```ml
function decodePreferences(text)
```

Decode preferences.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `text` | `dynamic` | — | Text consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/product_startup.ml#L578)

<a id="constant-constant-miniquake2-runtime-product-startup-default-port-const-default-port-27910-src-miniquake2-runtime-product-startup-ml-237278752"></a>
### DEFAULT_PORT

```ml
const DEFAULT_PORT = 27910
```

Defines the default port constant used by the miniquake2 runtime product startup module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/product_startup.ml#L20)

<a id="function-function-miniquake2-runtime-product-startup-defaultdownloadpolicy-function-defaultdownloadpolicy-src-miniquake2-runtime-product-startup-ml-928775686"></a>
### defaultDownloadPolicy

```ml
function defaultDownloadPolicy()
```

Return the default download policy value.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/product_startup.ml#L464)

<a id="function-function-miniquake2-runtime-product-startup-defaultplayerprofile-function-defaultplayerprofile-src-miniquake2-runtime-product-startup-ml-612903888"></a>
### defaultPlayerProfile

```ml
function defaultPlayerProfile()
```

Return the default player profile value.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/product_startup.ml#L428)

<a id="function-function-miniquake2-runtime-product-startup-defaultpreferences-function-defaultpreferences-src-miniquake2-runtime-product-startup-ml-366695020"></a>
### defaultPreferences

```ml
function defaultPreferences()
```

Return the default preferences value.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/product_startup.ml#L469)

<a id="function-function-miniquake2-runtime-product-startup-defaultserveroptions-function-defaultserveroptions-src-miniquake2-runtime-product-startup-ml-716570592"></a>
### defaultServerOptions

```ml
function defaultServerOptions()
```

Return the default server options value.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/product_startup.ml#L643)

<a id="function-function-miniquake2-runtime-product-startup-disconnect-function-disconnect-lifecycle-src-miniquake2-runtime-product-startup-ml-1492842132"></a>
### disconnect

```ml
function disconnect(lifecycle)
```

Return the disconnect value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `lifecycle` | `dynamic` | — | lifecycle value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/product_startup.ml#L691)

<a id="function-function-miniquake2-runtime-product-startup-discoverretailroot-function-discoverretailroot-selectionpath-candidates-src-miniquake2-runtime-product-startup-ml-958115877"></a>
### discoverRetailRoot

```ml
function discoverRetailRoot(selectionPath, candidates)
```

Discover retail root.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `selectionPath` | `dynamic` | — | Path associated with selection. |
| `candidates` | `dynamic` | — | candidates value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/product_startup.ml#L197)

- [miniquake2.runtime.product_startup.DownloadPolicy](Type-miniquake2-runtime-product-startup-downloadpolicy-420098474.md) — struct
<a id="function-function-miniquake2-runtime-product-startup-encodepreferences-function-encodepreferences-preferences-src-miniquake2-runtime-product-startup-ml-2013516882"></a>
### encodePreferences

```ml
function encodePreferences(preferences)
```

Encode preferences.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `preferences` | `dynamic` | — | preferences value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/product_startup.ml#L520)

- [miniquake2.runtime.product_startup.Endpoint](Type-miniquake2-runtime-product-startup-endpoint-586120097.md) — struct
<a id="function-function-miniquake2-runtime-product-startup-endpointtext-function-endpointtext-endpoint-src-miniquake2-runtime-product-startup-ml-1875792187"></a>
### endpointText

```ml
function endpointText(endpoint)
```

Return the endpoint text value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `endpoint` | `dynamic` | — | endpoint value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/product_startup.ml#L261)

<a id="function-function-miniquake2-runtime-product-startup-loadpreferences-function-loadpreferences-path-src-miniquake2-runtime-product-startup-ml-583216133"></a>
### loadPreferences

```ml
function loadPreferences(path)
```

Load preferences.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `path` | `dynamic` | — | Path of the file or directory used by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/product_startup.ml#L623)

<a id="function-function-miniquake2-runtime-product-startup-loadselectedroot-function-loadselectedroot-path-src-miniquake2-runtime-product-startup-ml-552837889"></a>
### loadSelectedRoot

```ml
function loadSelectedRoot(path)
```

Load selected root.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `path` | `dynamic` | — | Path of the file or directory used by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/product_startup.ml#L172)

<a id="constant-constant-miniquake2-runtime-product-startup-max-browser-servers-const-max-browser-servers-8-src-miniquake2-runtime-product-startup-ml-1526243991"></a>
### MAX_BROWSER_SERVERS

```ml
const MAX_BROWSER_SERVERS = 8
```

Defines the max browser servers constant used by the miniquake2 runtime product startup module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/product_startup.ml#L22)

- [miniquake2.runtime.product_startup.MultiplayerPreferences](Type-miniquake2-runtime-product-startup-multiplayerpreferences-929337978.md) — struct
<a id="function-function-miniquake2-runtime-product-startup-parseendpoint-function-parseendpoint-value-src-miniquake2-runtime-product-startup-ml-1850693055"></a>
### parseEndpoint

```ml
function parseEndpoint(value)
```

Parse endpoint.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/product_startup.ml#L220)

<a id="function-function-miniquake2-runtime-product-startup-parseport-function-parseport-value-src-miniquake2-runtime-product-startup-ml-243850463"></a>
### parsePort

```ml
function parsePort(value)
```

Parse port.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/product_startup.ml#L209)

<a id="function-function-miniquake2-runtime-product-startup-persistselectedroot-function-persistselectedroot-path-root-src-miniquake2-runtime-product-startup-ml-705633779"></a>
### persistSelectedRoot

```ml
function persistSelectedRoot(path, root)
```

Persist selected root.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `path` | `dynamic` | — | Path of the file or directory used by the operation. |
| `root` | `dynamic` | — | root value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/product_startup.ml#L184)

- [miniquake2.runtime.product_startup.PlayerProfile](Type-miniquake2-runtime-product-startup-playerprofile-2126831118.md) — struct
<a id="function-function-miniquake2-runtime-product-startup-playerprofilevalid-function-playerprofilevalid-profile-src-miniquake2-runtime-product-startup-ml-103283619"></a>
### playerProfileValid

```ml
function playerProfileValid(profile)
```

Report whether player profile valid.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `profile` | `dynamic` | — | profile value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/product_startup.ml#L434)

<a id="function-function-miniquake2-runtime-product-startup-playeruserinfo-function-playeruserinfo-profile-src-miniquake2-runtime-product-startup-ml-803620531"></a>
### playerUserInfo

```ml
function playerUserInfo(profile)
```

Return the player user info value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `profile` | `dynamic` | — | profile value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/product_startup.ml#L448)

<a id="function-function-miniquake2-runtime-product-startup-preferencebool-function-preferencebool-value-src-miniquake2-runtime-product-startup-ml-741227143"></a>
### preferenceBool

```ml
function preferenceBool(value)
```

Return the preference bool value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/product_startup.ml#L513)

<a id="function-function-miniquake2-runtime-product-startup-preferenceboolean-function-preferenceboolean-value-src-miniquake2-runtime-product-startup-ml-1161513049"></a>
### preferenceBoolean

```ml
function preferenceBoolean(value)
```

Return the preference boolean value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/product_startup.ml#L572)

<a id="function-function-miniquake2-runtime-product-startup-preferenceinteger-function-preferenceinteger-value-minimum-maximum-src-miniquake2-runtime-product-startup-ml-581730379"></a>
### preferenceInteger

```ml
function preferenceInteger(value, minimum, maximum)
```

Return the preference integer value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |
| `minimum` | `dynamic` | — | minimum value consumed by this operation. |
| `maximum` | `dynamic` | — | maximum value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/product_startup.ml#L563)

<a id="function-function-miniquake2-runtime-product-startup-preferenceline-function-preferenceline-lines-index-prefix-src-miniquake2-runtime-product-startup-ml-1642827243"></a>
### preferenceLine

```ml
function preferenceLine(lines, index, prefix)
```

Return the preference line value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `lines` | `dynamic` | — | lines value consumed by this operation. |
| `index` | `dynamic` | — | Zero-based index of the affected item. |
| `prefix` | `dynamic` | — | prefix value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/product_startup.ml#L549)

<a id="constant-constant-miniquake2-runtime-product-startup-preferences-header-const-preferences-header-miniquake2multiplayer-2-src-miniquake2-runtime-product-startup-ml-58564185"></a>
### PREFERENCES_HEADER

```ml
const PREFERENCES_HEADER = "MiniQuake2Multiplayer 2"
```

Defines the preferences header constant used by the miniquake2 runtime product startup module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/product_startup.ml#L26)

<a id="constant-constant-miniquake2-runtime-product-startup-preferences-legacy-header-const-preferences-legacy-header-miniquake2multiplayer-1-src-miniquake2-runtime-product-startup-ml-1199919820"></a>
### PREFERENCES_LEGACY_HEADER

```ml
const PREFERENCES_LEGACY_HEADER = "MiniQuake2Multiplayer 1"
```

Defines the preferences legacy header constant used by the miniquake2 runtime product startup module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/product_startup.ml#L28)

<a id="function-function-miniquake2-runtime-product-startup-preferencesvalid-function-preferencesvalid-preferences-src-miniquake2-runtime-product-startup-ml-941643398"></a>
### preferencesValid

```ml
function preferencesValid(preferences)
```

Report whether preferences valid.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `preferences` | `dynamic` | — | preferences value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/product_startup.ml#L487)

<a id="function-function-miniquake2-runtime-product-startup-preferencetextsafe-function-preferencetextsafe-value-maximum-src-miniquake2-runtime-product-startup-ml-1575336819"></a>
### preferenceTextSafe

```ml
function preferenceTextSafe(value, maximum)
```

Return the preference text safe value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |
| `maximum` | `dynamic` | — | maximum value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/product_startup.ml#L477)

- [miniquake2.runtime.product_startup.ProductLifecycle](Type-miniquake2-runtime-product-startup-productlifecycle-918829249.md) — struct
<a id="function-function-miniquake2-runtime-product-startup-pumpbrowser-function-pumpbrowser-browser-now-src-miniquake2-runtime-product-startup-ml-624158064"></a>
### pumpBrowser

```ml
function pumpBrowser(browser, now)
```

Pump browser.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `browser` | `dynamic` | — | browser value consumed by this operation. |
| `now` | `dynamic` | — | now value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/product_startup.ml#L336)

<a id="function-function-miniquake2-runtime-product-startup-pumprcon-function-pumprcon-transport-now-src-miniquake2-runtime-product-startup-ml-1555265013"></a>
### pumpRcon

```ml
function pumpRcon(transport, now)
```

Pump matching print replies without blocking the menu presentation loop.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `transport` | `dynamic` | — | transport value consumed by this operation. |
| `now` | `dynamic` | — | now value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/product_startup.ml#L393)

- [miniquake2.runtime.product_startup.RconTransport](Type-miniquake2-runtime-product-startup-rcontransport-433564303.md) — struct
<a id="function-function-miniquake2-runtime-product-startup-retailrootvalid-function-retailrootvalid-root-src-miniquake2-runtime-product-startup-ml-1851660650"></a>
### retailRootValid

```ml
function retailRootValid(root)
```

Report whether retail root valid.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `root` | `dynamic` | — | root value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/product_startup.ml#L154)

<a id="function-function-miniquake2-runtime-product-startup-returntomenu-function-returntomenu-lifecycle-src-miniquake2-runtime-product-startup-ml-1894404188"></a>
### returnToMenu

```ml
function returnToMenu(lifecycle)
```

Return to menu.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `lifecycle` | `dynamic` | — | lifecycle value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/product_startup.ml#L701)

<a id="function-function-miniquake2-runtime-product-startup-savepreferences-function-savepreferences-path-preferences-src-miniquake2-runtime-product-startup-ml-1789416363"></a>
### savePreferences

```ml
function savePreferences(path, preferences)
```

Save preferences.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `path` | `dynamic` | — | Path of the file or directory used by the operation. |
| `preferences` | `dynamic` | — | preferences value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/product_startup.ml#L632)

<a id="function-function-miniquake2-runtime-product-startup-sendrcon-function-sendrcon-transport-endpointtextvalue-password-command-now-src-miniquake2-runtime-product-startup-ml-1593029386"></a>
### sendRcon

```ml
function sendRcon(transport, endpointTextValue, password, command, now)
```

Send one validated connectionless RCON request from a temporary UDP socket.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `transport` | `dynamic` | — | transport value consumed by this operation. |
| `endpointTextValue` | `dynamic` | — | endpointTextValue value consumed by this operation. |
| `password` | `dynamic` | — | password value consumed by this operation. |
| `command` | `dynamic` | — | command value consumed by this operation. |
| `now` | `dynamic` | — | now value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/product_startup.ml#L372)

- [miniquake2.runtime.product_startup.ServerBrowser](Type-miniquake2-runtime-product-startup-serverbrowser-725878657.md) — struct
- [miniquake2.runtime.product_startup.ServerEntry](Type-miniquake2-runtime-product-startup-serverentry-1899571365.md) — struct
- [miniquake2.runtime.product_startup.ServerOptions](Type-miniquake2-runtime-product-startup-serveroptions-1845176159.md) — struct
<a id="function-function-miniquake2-runtime-product-startup-standardretailcandidates-function-standardretailcandidates-src-miniquake2-runtime-product-startup-ml-430105160"></a>
### standardRetailCandidates

```ml
function standardRetailCandidates()
```

Return the standard retail candidates value.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/product_startup.ml#L164)

<a id="function-function-miniquake2-runtime-product-startup-startbrowser-function-startbrowser-browser-addresses-now-src-miniquake2-runtime-product-startup-ml-1012432"></a>
### startBrowser

```ml
function startBrowser(browser, addresses, now)
```

Start browser.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `browser` | `dynamic` | — | browser value consumed by this operation. |
| `addresses` | `dynamic` | — | addresses value consumed by this operation. |
| `now` | `dynamic` | — | now value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/runtime/product_startup.ml#L308)
