# `src/miniquake2/platform/dedicated_console.ml`

[Home](README.md) · [Files](Files.md)

Provides miniquake2 platform dedicated console facilities for this project.

Package: [`miniquake2.platform.dedicated_console`](Package-miniquake2-platform-dedicated-console-1328105213.md)

Reachable from entry: **yes**

## Imports

- `miniquake2/native.ml` as `dcnative` → [src/miniquake2/native.ml](File-src-miniquake2-native-ml-139597585.md)

## Declarations

<a id="function-function-miniquake2-platform-dedicated-console-acceptevent-function-acceptevent-state-encoded-src-miniquake2-platform-dedicated-console-ml-295771055"></a>
### acceptEvent

```ml
function acceptEvent(state, encoded)
```

Decode one bridge event. The original Windows Quake console consumes the character on key release; redirected stdin uses the same key-up encoding. The return value is [completedLine-or-void, echoText].

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |
| `encoded` | `dynamic` | — | encoded value consumed by this operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/platform/dedicated_console.ml#L60)

<a id="function-function-miniquake2-platform-dedicated-console-close-function-close-state-src-miniquake2-platform-dedicated-console-ml-260561205"></a>
### close

```ml
function close(state)
```

Release only a console allocated by the shared bridge.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/platform/dedicated_console.ml#L48)

<a id="constant-constant-miniquake2-platform-dedicated-console-console-capacity-const-console-capacity-256-src-miniquake2-platform-dedicated-console-ml-523166448"></a>
### CONSOLE_CAPACITY

```ml
const CONSOLE_CAPACITY = 256
```

Defines the console capacity constant used by the miniquake2 platform dedicated console module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/platform/dedicated_console.ml#L15)

<a id="function-function-miniquake2-platform-dedicated-console-create-function-create-src-miniquake2-platform-dedicated-console-ml-1007992226"></a>
### create

```ml
function create()
```

Create an isolated console decoder. Native allocation remains explicit so unit tests can exercise the byte-for-byte input policy without host I/O.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/platform/dedicated_console.ml#L33)

- [miniquake2.platform.dedicated_console.DedicatedConsoleState](Type-miniquake2-platform-dedicated-console-dedicatedconsolestate-2143362280.md) — struct
<a id="constant-constant-miniquake2-platform-dedicated-console-event-key-down-const-event-key-down-65536-src-miniquake2-platform-dedicated-console-ml-1089649862"></a>
### EVENT_KEY_DOWN

```ml
const EVENT_KEY_DOWN = 65536
```

Defines the event key down constant used by the miniquake2 platform dedicated console module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/platform/dedicated_console.ml#L19)

<a id="constant-constant-miniquake2-platform-dedicated-console-event-present-const-event-present-2147483648-src-miniquake2-platform-dedicated-console-ml-195289576"></a>
### EVENT_PRESENT

```ml
const EVENT_PRESENT = 2147483648
```

Defines the event present constant used by the miniquake2 platform dedicated console module.


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/platform/dedicated_console.ml#L17)

<a id="function-function-miniquake2-platform-dedicated-console-open-function-open-state-src-miniquake2-platform-dedicated-console-ml-422891633"></a>
### open

```ml
function open(state)
```

Attach to the process console, allocating one only when the executable does not already own a usable standard-output handle.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/platform/dedicated_console.ml#L40)

<a id="function-function-miniquake2-platform-dedicated-console-poll-function-poll-state-src-miniquake2-platform-dedicated-console-ml-2070119413"></a>
### poll

```ml
function poll(state)
```

Drain all currently pending native events without blocking the 10 Hz server frame. More than one complete redirected-input line may be available.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/platform/dedicated_console.ml#L90)

<a id="function-function-miniquake2-platform-dedicated-console-write-function-write-state-text-src-miniquake2-platform-dedicated-console-ml-1101419192"></a>
### write

```ml
function write(state, text)
```

Write operator output through the console-safe bridge.

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `state` | `dynamic` | — | Mutable state inspected or updated by the operation. |
| `text` | `dynamic` | — | Text consumed by the operation. |


[View source](https://github.com/MiniLangProject/MiniQuake2/blob/main/src/miniquake2/platform/dedicated_console.ml#L106)
