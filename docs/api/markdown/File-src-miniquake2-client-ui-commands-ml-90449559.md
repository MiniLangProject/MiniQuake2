# `src/miniquake2/client/ui/commands.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 client ui commands facilities for this project.

Package: [`miniquake2.client.ui.commands`](Package-miniquake2-client-ui-commands-1795075748.md)

Reachable from entry: **yes**

## Imports

- `miniquake2/audio/mixer.ml` as `cuicmdmixer` → [src/miniquake2/audio/mixer.ml](File-src-miniquake2-audio-mixer-ml-976475642.md)
- `miniquake2/client/ui/console.ml` as `cuicmdconsole` → [src/miniquake2/client/ui/console.ml](File-src-miniquake2-client-ui-console-ml-367794066.md)
- `miniquake2/client/ui/constants.ml` as `cuicmdconstants` → [src/miniquake2/client/ui/constants.ml](File-src-miniquake2-client-ui-constants-ml-1004124106.md)
- `miniquake2/client/ui/keys.ml` as `cuicmdkeys` → [src/miniquake2/client/ui/keys.ml](File-src-miniquake2-client-ui-keys-ml-2076131853.md)
- `miniquake2/client/ui/menu.ml` as `cuicmdmenu` → [src/miniquake2/client/ui/menu.ml](File-src-miniquake2-client-ui-menu-ml-1156054796.md)
- `miniquake2/game/constants.ml` as `cuicmdgameconstants` → [src/miniquake2/game/constants.ml](File-src-miniquake2-game-constants-ml-1723282332.md)
- `miniquake2/qcommon/byteio.ml` as `cuicmdbyteio` → [src/miniquake2/qcommon/byteio.ml](File-src-miniquake2-qcommon-byteio-ml-159119335.md)
- `miniquake2/qcommon/cmd.ml` as `cuicmdq` → [src/miniquake2/qcommon/cmd.ml](File-src-miniquake2-qcommon-cmd-ml-1514462021.md)
- `miniquake2/qcommon/info.ml` as `cuicmdinfo` → [src/miniquake2/qcommon/info.ml](File-src-miniquake2-qcommon-info-ml-634538165.md)
- `miniquake2/qcommon/text.ml` as `cuicmdtext` → [src/miniquake2/qcommon/text.ml](File-src-miniquake2-qcommon-text-ml-1570504148.md)
- `miniquake2/runtime/product_startup.ml` as `cuicmdstartup` → [src/miniquake2/runtime/product_startup.ml](File-src-miniquake2-runtime-product-startup-ml-320456564.md)

## Declarations

<a id="function-function-miniquake2-client-ui-commands-booleanargument-function-booleanargument-arguments-name-src-miniquake2-client-ui-commands-ml-677481880"></a>
### booleanArgument

```ml
function booleanArgument(arguments, name)
```

Return the boolean argument value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `arguments` | `dynamic` | — | arguments value consumed by this operation. |
| `name` | `dynamic` | — | Name of the affected item. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/ui/commands.ml#L156)

- [miniquake2.client.ui.commands.CommandState](Type-miniquake2-client-ui-commands-commandstate-1004914784.md) — struct
<a id="function-function-miniquake2-client-ui-commands-create-function-create-src-miniquake2-client-ui-commands-ml-1676149817"></a>
### create

```ml
function create()
```

Creates create for the miniquake2 client ui commands module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/ui/commands.ml#L117)

<a id="function-function-miniquake2-client-ui-commands-downloadpolicy-function-downloadpolicy-commandstate-src-miniquake2-client-ui-commands-ml-1422298823"></a>
### downloadPolicy

```ml
function downloadPolicy(commandState)
```

Return the download policy value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `commandState` | `dynamic` | — | commandState value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/ui/commands.ml#L797)

<a id="function-function-miniquake2-client-ui-commands-drain-function-drain-commandstate-input-screen-mixer-src-miniquake2-client-ui-commands-ml-735213810"></a>
### drain

```ml
function drain(commandState, input, screen, mixer)
```

Drain state.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `commandState` | `dynamic` | — | commandState value consumed by this operation. |
| `input` | `dynamic` | — | input value consumed by this operation. |
| `screen` | `dynamic` | — | screen value consumed by this operation. |
| `mixer` | `dynamic` | — | mixer value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/ui/commands.ml#L651)

<a id="function-function-miniquake2-client-ui-commands-execute-function-execute-commandstate-input-screen-mixer-command-src-miniquake2-client-ui-commands-ml-1616757447"></a>
### execute

```ml
function execute(commandState, input, screen, mixer, command)
```

Execute state.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `commandState` | `dynamic` | — | commandState value consumed by this operation. |
| `input` | `dynamic` | — | input value consumed by this operation. |
| `screen` | `dynamic` | — | screen value consumed by this operation. |
| `mixer` | `dynamic` | — | mixer value consumed by this operation. |
| `command` | `dynamic` | — | command value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/ui/commands.ml#L635)

<a id="function-function-miniquake2-client-ui-commands-integerargument-function-integerargument-arguments-name-minimum-maximum-src-miniquake2-client-ui-commands-ml-1407035306"></a>
### integerArgument

```ml
function integerArgument(arguments, name, minimum, maximum)
```

Return the integer argument value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `arguments` | `dynamic` | — | arguments value consumed by this operation. |
| `name` | `dynamic` | — | Name of the affected item. |
| `minimum` | `dynamic` | — | minimum value consumed by this operation. |
| `maximum` | `dynamic` | — | maximum value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/ui/commands.ml#L143)

<a id="function-function-miniquake2-client-ui-commands-localaction-function-localaction-commandstate-input-screen-mixer-command-src-miniquake2-client-ui-commands-ml-258147699"></a>
### localAction

```ml
function localAction(commandState, input, screen, mixer, command)
```

Apply commands owned by the client UI and return false only for text that must cross the Game API boundary. Parsing and validation happen before any persistent setting is mutated.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `commandState` | `dynamic` | — | commandState value consumed by this operation. |
| `input` | `dynamic` | — | input value consumed by this operation. |
| `screen` | `dynamic` | — | screen value consumed by this operation. |
| `mixer` | `dynamic` | — | mixer value consumed by this operation. |
| `command` | `dynamic` | — | command value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/ui/commands.ml#L236)

<a id="function-function-miniquake2-client-ui-commands-numericargument-function-numericargument-arguments-name-src-miniquake2-client-ui-commands-ml-184322958"></a>
### numericArgument

```ml
function numericArgument(arguments, name)
```

Return the numeric argument value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `arguments` | `dynamic` | — | arguments value consumed by this operation. |
| `name` | `dynamic` | — | Name of the affected item. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/ui/commands.ml#L127)

<a id="function-function-miniquake2-client-ui-commands-playermodelname-function-playermodelname-index-src-miniquake2-client-ui-commands-ml-1863374691"></a>
### playerModelName

```ml
function playerModelName(index)
```

Return the player model name.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `index` | `dynamic` | — | Zero-based index of the affected item. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/ui/commands.ml#L163)

<a id="function-function-miniquake2-client-ui-commands-playerprofile-function-playerprofile-commandstate-input-src-miniquake2-client-ui-commands-ml-1227531791"></a>
### playerProfile

```ml
function playerProfile(commandState, input)
```

Return the player profile value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `commandState` | `dynamic` | — | commandState value consumed by this operation. |
| `input` | `dynamic` | — | input value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/ui/commands.ml#L730)

<a id="function-function-miniquake2-client-ui-commands-playerskinname-function-playerskinname-model-index-src-miniquake2-client-ui-commands-ml-18807270"></a>
### playerSkinName

```ml
function playerSkinName(model, index)
```

Return the player skin name.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `model` | `dynamic` | — | model value consumed by this operation. |
| `index` | `dynamic` | — | Zero-based index of the affected item. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/ui/commands.ml#L173)

<a id="function-function-miniquake2-client-ui-commands-resetoptiondefaults-function-resetoptiondefaults-commandstate-input-screen-mixer-src-miniquake2-client-ui-commands-ml-1496069766"></a>
### resetOptionDefaults

```ml
function resetOptionDefaults(commandState, input, screen, mixer)
```

`exec default.cfg` in the stock Options menu resets controls and the values displayed by that menu. Keep the operation local and typed so it cannot run arbitrary config text, while applying every setting our Options page owns.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `commandState` | `dynamic` | — | commandState value consumed by this operation. |
| `input` | `dynamic` | — | input value consumed by this operation. |
| `screen` | `dynamic` | — | screen value consumed by this operation. |
| `mixer` | `dynamic` | — | mixer value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/ui/commands.ml#L196)

<a id="function-function-miniquake2-client-ui-commands-serveroptions-function-serveroptions-commandstate-src-miniquake2-client-ui-commands-ml-2084406429"></a>
### serverOptions

```ml
function serverOptions(commandState)
```

Return the server options value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `commandState` | `dynamic` | — | commandState value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/ui/commands.ml#L787)

<a id="function-function-miniquake2-client-ui-commands-setdmflag-function-setdmflag-commandstate-bit-enabled-src-miniquake2-client-ui-commands-ml-757527945"></a>
### setDmFlag

```ml
function setDmFlag(commandState, bit, enabled)
```

Set dm flag.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `commandState` | `dynamic` | — | commandState value consumed by this operation. |
| `bit` | `dynamic` | — | bit value consumed by this operation. |
| `enabled` | `dynamic` | — | enabled value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/ui/commands.ml#L183)

<a id="function-function-miniquake2-client-ui-commands-takeconfigdirty-function-takeconfigdirty-commandstate-src-miniquake2-client-ui-commands-ml-182128185"></a>
### takeConfigDirty

```ml
function takeConfigDirty(commandState)
```

Report whether take config dirty.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `commandState` | `dynamic` | — | commandState value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/ui/commands.ml#L713)

<a id="function-function-miniquake2-client-ui-commands-takeconnectaddress-function-takeconnectaddress-commandstate-src-miniquake2-client-ui-commands-ml-409944115"></a>
### takeConnectAddress

```ml
function takeConnectAddress(commandState)
```

Consume connect address.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `commandState` | `dynamic` | — | commandState value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/ui/commands.ml#L739)

<a id="function-function-miniquake2-client-ui-commands-takedisconnect-function-takedisconnect-commandstate-src-miniquake2-client-ui-commands-ml-1636496923"></a>
### takeDisconnect

```ml
function takeDisconnect(commandState)
```

Consume disconnect.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `commandState` | `dynamic` | — | commandState value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/ui/commands.ml#L763)

<a id="function-function-miniquake2-client-ui-commands-takeforwarded-inline-function-takeforwarded-commandstate-src-miniquake2-client-ui-commands-ml-1811981686"></a>
### takeForwarded

```ml
inline function takeForwarded(commandState)
```

Consume forwarded.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `commandState` | `dynamic` | — | commandState value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/ui/commands.ml#L678)

<a id="function-function-miniquake2-client-ui-commands-takeloadslot-function-takeloadslot-commandstate-src-miniquake2-client-ui-commands-ml-1394120679"></a>
### takeLoadSlot

```ml
function takeLoadSlot(commandState)
```

Consume load slot.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `commandState` | `dynamic` | — | commandState value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/ui/commands.ml#L697)

<a id="function-function-miniquake2-client-ui-commands-takenewgameskill-function-takenewgameskill-commandstate-src-miniquake2-client-ui-commands-ml-1504493351"></a>
### takeNewGameSkill

```ml
function takeNewGameSkill(commandState)
```

Consume new game skill.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `commandState` | `dynamic` | — | commandState value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/ui/commands.ml#L705)

<a id="function-function-miniquake2-client-ui-commands-takeplayerdirty-function-takeplayerdirty-commandstate-src-miniquake2-client-ui-commands-ml-1556648263"></a>
### takePlayerDirty

```ml
function takePlayerDirty(commandState)
```

Report whether take player dirty.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `commandState` | `dynamic` | — | commandState value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/ui/commands.ml#L721)

<a id="function-function-miniquake2-client-ui-commands-takerconcommands-function-takerconcommands-commandstate-src-miniquake2-client-ui-commands-ml-495314571"></a>
### takeRconCommands

```ml
function takeRconCommands(commandState)
```

Consume pending remote-console commands.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `commandState` | `dynamic` | — | commandState value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/ui/commands.ml#L779)

<a id="function-function-miniquake2-client-ui-commands-takereconnect-function-takereconnect-commandstate-src-miniquake2-client-ui-commands-ml-79929819"></a>
### takeReconnect

```ml
function takeReconnect(commandState)
```

Consume reconnect request.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `commandState` | `dynamic` | — | commandState value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/ui/commands.ml#L771)

<a id="function-function-miniquake2-client-ui-commands-takerecordname-function-takerecordname-commandstate-src-miniquake2-client-ui-commands-ml-1605181927"></a>
### takeRecordName

```ml
function takeRecordName(commandState)
```

Consume record name.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `commandState` | `dynamic` | — | commandState value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/ui/commands.ml#L805)

<a id="function-function-miniquake2-client-ui-commands-takerefreshservers-function-takerefreshservers-commandstate-src-miniquake2-client-ui-commands-ml-2122981967"></a>
### takeRefreshServers

```ml
function takeRefreshServers(commandState)
```

Consume refresh servers.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `commandState` | `dynamic` | — | commandState value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/ui/commands.ml#L747)

<a id="function-function-miniquake2-client-ui-commands-takesaveslot-function-takesaveslot-commandstate-src-miniquake2-client-ui-commands-ml-1249986087"></a>
### takeSaveSlot

```ml
function takeSaveSlot(commandState)
```

Consume save slot.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `commandState` | `dynamic` | — | commandState value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/ui/commands.ml#L689)

<a id="function-function-miniquake2-client-ui-commands-takescreenshot-function-takescreenshot-commandstate-src-miniquake2-client-ui-commands-ml-81851095"></a>
### takeScreenshot

```ml
function takeScreenshot(commandState)
```

Consume screenshot.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `commandState` | `dynamic` | — | commandState value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/ui/commands.ml#L821)

<a id="function-function-miniquake2-client-ui-commands-takestartserver-function-takestartserver-commandstate-src-miniquake2-client-ui-commands-ml-2059779295"></a>
### takeStartServer

```ml
function takeStartServer(commandState)
```

Consume start server.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `commandState` | `dynamic` | — | commandState value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/ui/commands.ml#L755)

<a id="function-function-miniquake2-client-ui-commands-takestoprecording-function-takestoprecording-commandstate-src-miniquake2-client-ui-commands-ml-499803839"></a>
### takeStopRecording

```ml
function takeStopRecording(commandState)
```

Consume stop recording.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `commandState` | `dynamic` | — | commandState value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/client/ui/commands.ml#L813)
