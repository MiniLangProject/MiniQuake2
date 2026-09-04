# `src/miniquake2/qcommon/cmd.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 qcommon cmd facilities for this project.

Package: [`miniquake2.qcommon.cmd`](Package-miniquake2-qcommon-cmd-510676045.md)

Reachable from entry: **yes**

## Imports

- `miniquake2/qcommon/cvar.ml` as `cvar` → [src/miniquake2/qcommon/cvar.ml](File-src-miniquake2-qcommon-cvar-ml-1999572875.md)
- `miniquake2/qcommon/text.ml` as `text` → [src/miniquake2/qcommon/text.ml](File-src-miniquake2-qcommon-text-ml-1570504148.md)
- `miniquake2/qcommon/types.ml` as `qt` → [src/miniquake2/qcommon/types.ml](File-src-miniquake2-qcommon-types-ml-1663266398.md)

## Declarations

<a id="function-function-miniquake2-qcommon-cmd-addalias-function-addalias-system-name-value-src-miniquake2-qcommon-cmd-ml-950620943"></a>
### addAlias

```ml
function addAlias(system, name, value)
```

Add alias.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `system` | `dynamic` | — | system value consumed by this operation. |
| `name` | `dynamic` | — | Name of the affected item. |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/cmd.ml#L109)

<a id="function-function-miniquake2-qcommon-cmd-addcommand-function-addcommand-system-name-callback-src-miniquake2-qcommon-cmd-ml-215861499"></a>
### addCommand

```ml
function addCommand(system, name, callback)
```

Add command.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `system` | `dynamic` | — | system value consumed by this operation. |
| `name` | `dynamic` | — | Name of the affected item. |
| `callback` | `dynamic` | — | Callback invoked when the operation completes or the event occurs. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/cmd.ml#L33)

<a id="function-function-miniquake2-qcommon-cmd-addtext-function-addtext-system-value-src-miniquake2-qcommon-cmd-ml-1036817648"></a>
### addText

```ml
function addText(system, value)
```

Add text.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `system` | `dynamic` | — | system value consumed by this operation. |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/cmd.ml#L122)

<a id="function-function-miniquake2-qcommon-cmd-argumenttail-function-argumenttail-value-src-miniquake2-qcommon-cmd-ml-2103084977"></a>
### argumentTail

```ml
function argumentTail(value)
```

Return the argument tail value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/cmd.ml#L92)

<a id="constant-constant-miniquake2-qcommon-cmd-command-buffer-size-const-command-buffer-size-8192-src-miniquake2-qcommon-cmd-ml-104720819"></a>
### COMMAND_BUFFER_SIZE

```ml
const COMMAND_BUFFER_SIZE = 8192
```

Defines the command buffer size constant used by the miniquake2 qcommon cmd module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/cmd.ml#L17)

<a id="function-function-miniquake2-qcommon-cmd-create-function-create-cvars-src-miniquake2-qcommon-cmd-ml-2044757715"></a>
### create

```ml
function create(cvars)
```

Creates create for the miniquake2 qcommon cmd module.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `cvars` | `dynamic` | — | cvars value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/cmd.ml#L25)

<a id="function-function-miniquake2-qcommon-cmd-executebuffer-function-executebuffer-system-src-miniquake2-qcommon-cmd-ml-1786630245"></a>
### executeBuffer

```ml
function executeBuffer(system)
```

Execute buffer.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `system` | `dynamic` | — | system value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/cmd.ml#L222)

<a id="function-function-miniquake2-qcommon-cmd-executestring-function-executestring-system-value-src-miniquake2-qcommon-cmd-ml-302752460"></a>
### executeString

```ml
function executeString(system, value)
```

Execute string.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `system` | `dynamic` | — | system value consumed by this operation. |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/cmd.ml#L203)

<a id="function-function-miniquake2-qcommon-cmd-inserttext-function-inserttext-system-value-src-miniquake2-qcommon-cmd-ml-741937528"></a>
### insertText

```ml
function insertText(system, value)
```

Insert text.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `system` | `dynamic` | — | system value consumed by this operation. |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/cmd.ml#L131)

<a id="function-function-miniquake2-qcommon-cmd-macroexpand-function-macroexpand-system-value-src-miniquake2-qcommon-cmd-ml-1462776944"></a>
### macroExpand

```ml
function macroExpand(system, value)
```

Expand unquoted `$cvar` references with the same bounded repeated-scan policy as Cmd_MacroExpandString. Keeping this in qcommon makes config, client-console and dedicated-console command parsing agree.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `system` | `dynamic` | — | system value consumed by this operation. |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/cmd.ml#L160)

<a id="constant-constant-miniquake2-qcommon-cmd-max-alias-name-const-max-alias-name-32-src-miniquake2-qcommon-cmd-ml-480449674"></a>
### MAX_ALIAS_NAME

```ml
const MAX_ALIAS_NAME = 32
```

Defines the max alias name constant used by the miniquake2 qcommon cmd module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/cmd.ml#L19)

<a id="constant-constant-miniquake2-qcommon-cmd-max-args-const-max-args-80-src-miniquake2-qcommon-cmd-ml-1099643713"></a>
### MAX_ARGS

```ml
const MAX_ARGS = 80
```

Defines the max args constant used by the miniquake2 qcommon cmd module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/cmd.ml#L15)

<a id="constant-constant-miniquake2-qcommon-cmd-max-string-chars-const-max-string-chars-1024-src-miniquake2-qcommon-cmd-ml-1636424838"></a>
### MAX_STRING_CHARS

```ml
const MAX_STRING_CHARS = 1024
```

Defines the max string chars constant used by the miniquake2 qcommon cmd module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/cmd.ml#L21)

<a id="function-function-miniquake2-qcommon-cmd-removecommand-function-removecommand-system-name-src-miniquake2-qcommon-cmd-ml-1294900164"></a>
### removeCommand

```ml
function removeCommand(system, name)
```

Remove command.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `system` | `dynamic` | — | system value consumed by this operation. |
| `name` | `dynamic` | — | Name of the affected item. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/cmd.ml#L45)

<a id="function-function-miniquake2-qcommon-cmd-splitfirst-function-splitfirst-value-src-miniquake2-qcommon-cmd-ml-880309025"></a>
### splitFirst

```ml
function splitFirst(value)
```

Split first.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/cmd.ml#L139)

<a id="function-function-miniquake2-qcommon-cmd-tokenize-function-tokenize-value-src-miniquake2-qcommon-cmd-ml-208305209"></a>
### tokenize

```ml
function tokenize(value)
```

Return the tokenize value.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `value` | `dynamic` | — | Value consumed or transformed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/qcommon/cmd.ml#L56)
